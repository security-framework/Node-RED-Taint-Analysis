
/**
* @name Flow Analysis
* @kind path-problem

*/

import javascript
import DataFlow::PathGraph
import DataFlow


class MyConfig extends DataFlow::Configuration {
  MyConfig() { this = "FlowTracking" }

  //Specifying potential sources

  override predicate isSource(DataFlow::Node source) {
    exists(MethodCallNode call |
      call.getMethodName() = "on" and
      call.getArgument(1).getAFunctionValue().getAParameter() = source 
      )
   }

  //Specifying potential sinks

  override predicate isSink(DataFlow::Node sink) { 
    exists(MethodCallNode call |
      call.getMethodName() = "send" and
      call.getArgument(0) = sink 
    )
   }
}

from MyConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink) and
source.getNode() != sink.getNode()
select sink.getNode(), source, sink, "taint from $@.", source.getNode(), "here"


