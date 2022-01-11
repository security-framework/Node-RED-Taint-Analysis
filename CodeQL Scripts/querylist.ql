
/**
* @name Taint Analysis Node-RED
* @kind path-problem
* @id js/taint

*/

import javascript
import DataFlow::PathGraph
import DataFlow


class MyConfig extends TaintTracking::Configuration {
  MyConfig() { this = "Taint Analysis" }

  override predicate isSource(DataFlow::Node source) { 
    any() }

  override predicate isSink(DataFlow::Node sink) { 
    exists(MethodCallNode call |
    
      call.getMethodName() = "set" and
      call.getArgument(1) = sink or
    
      call.getMethodName() = "setTarget" and
      call.getArgument(0) = sink or
	
      call.getMethodName() = "send" and
      call.getArgument(0) = sink or 

      call.getMethodName() = "warn" and
      call.getArgument(0) = sink or

      call.getMethodName() = "status" and
      call.getArgument(0) = sink or

	//context
     
      call.getMethodName() = "configure" and
      call.getArgument(0) = sink or

      call.getMethodName() = "apply" and
      call.getArgument(1) = sink or
      
      call.getMethodName() = "error" and
      call.getArgument(0) = sink or	

      call.getMethodName() = "log" and
      call.getArgument(0) = sink or

      call.getMethodName() = "json" and
      call.getArgument(0) = sink or

     //Specific to Hardware Nodes 


      call.getMethodName() = "digitalWrite" and
      call.getArgument(1) = sink or

      call.getMethodName() = "digitalRead" and
      call.getArgument(1) = sink or

      call.getMethodName() = "analogWrite" and
      call.getArgument(1) = sink or

      call.getMethodName() = "servoWrite" and
      call.getArgument(1) = sink or

      call.getMethodName() = "sysexCommand" and
      call.getArgument(0) = sink or

      call.getMethodName() = "sendString" and
      call.getArgument(0) = sink or

      call.getMethodName() = "pulse" and
      call.getArgument(1) = sink or

      call.getMethodName() = "morph" and
      call.getArgument(1) = sink or
      
      call.getMethodName() = "blink" and
      call.getArgument(1) = sink or

      call.getMethodName() = "setColor" and
      call.getArgument(1) = sink or

      call.getMethodName() = "sendFeatureReport" and
      call.getArgument(1) = sink or

      call.getMethodName() = "sendFeatureReport" and
      call.getArgument(2) = sink or

      call.getMethodName() = "sendFeatureReport" and
      call.getArgument(3) = sink or

      call.getMethodName() = "write_device" and
      call.getArgument(0) = sink or

      call.getMethodName() = "write" and
      call.getArgument(0) = sink or

      call.getMethodName() = "exec" and
      call.getArgument(0) = sink or

      call.getMethodName() = "setStatus" and
      call.getArgument(0) = sink or
	
      call.getMethodName() = "setStatus" and
      call.getArgument(1) = sink or

      call.getMethodName() = "setStatus" and
      call.getArgument(2) = sink or

      call.getMethodName() = "emit" and
      call.getArgument(1) = sink or

      //io


      call.getMethodName() = "close" and
      call.getArgument(0) = sink or

      //socials

      call.getMethodName() = "stop_listening_for" and
      call.getArgument(0) = sink or

      call.getMethodName() = "say" and
      call.getArgument(0) = sink or

      call.getMethodName() = "say" and
      call.getArgument(1) = sink or

      call.getMethodName() = "notify" and
      call.getArgument(0) = sink or

      call.getMethodName() = "push" and
      call.getArgument(0) = sink or


     //storage


      call.getMethodName() = "del" and
      call.getArgument(0) = sink or

      call.getMethodName() = "hadd" and
      call.getArgument(1) = sink or

      call.getMethodName() = "rush" and
      call.getArgument(1) = sink or

      call.getMethodName() = "doQuery" and
      call.getArgument(0) = sink

    )
   }
}

from MyConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink) and
source.getNode() != sink.getNode()
select sink.getNode(), source, sink, "taint from $@.", source.getNode(), "here"
