import javascript
import DataFlow::PathGraph
import DataFlow



class MyConfig extends TaintTracking::Configuration {
  MyConfig() { this = "XssUnsafeJQueryPlugin" }


  override predicate isSource(DataFlow::Node source) {

    exists(MethodCallNode call |
    
      call.getMethodName() = "on" and
      call.getArgument(1).getAFunctionValue().getAParameter() = source or

      call.getMethodName() = "listen_for" and
      call.getArgument(1).getAFunctionValue().getAParameter() = source or

      call.getMethodName() = "forEach" and
      call.getArgument(0).getAFunctionValue().getAParameter() = source or

      call.getMethodName() = "query" and
      call.getArgument(2).getAFunctionValue().getAParameter() = source or

      call.getMethodName() = "temperature" and
      call.getArgument(1).getAFunctionValue().getAParameter() = source or

      call.getMethodName() = "onInput" and
      call.getArgument(0).getAFunctionValue().getAParameter() = source
 


      ) or

    exists(CallExpr dollarCall |
       source.asExpr() instanceof CallExpr and
       dollarCall.getCalleeName() = "read" and
       dollarCall.getReceiver().toString() = "stream" and
       source.asExpr() = dollarCall 
     ) 
  
    
   }


  override predicate isSink(DataFlow::Node sink) { 




    exists(MethodCallNode call |

    
  

      call.getMethodName() = "error" and
      call.getArgument(0) = sink or

      call.getMethodName() = "error" and
      call.getArgument(1) = sink or

      call.getMethodName() = "log" and
      call.getArgument(0) = sink
      
      ) 


    }
  
}

from MyConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink) and 
source.getNode() != sink.getNode()
select sink.getNode(), source, sink, "Flow Mapped from source $@.", source.getNode(), "here"
