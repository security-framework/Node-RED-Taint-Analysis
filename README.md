# Node-RED-Taint-Analysis

The tool has two parts:

### Taint Analysis using CodeQL

Path queries run on Node-RED node databases to extract all the tainted data flows from sources to sinks.

### Python Tool for compliance check

The results of CodeQL compared against HTML description of NodeRED nodes and the final result of model-code compliance checks are produced.
