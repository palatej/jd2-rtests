source("./R files/jd2_rslts.R")

if (! isGeneric("saDecomposition")){
  setGeneric(name="saDecomposition", def = function( object, id, ... ){standardGeneric("saDecomposition")})
  lockBinding("saDecomposition", .GlobalEnv)
}

if (! isGeneric("result" )){
  setGeneric(name="result", def = function( object, id, ... ){standardGeneric("result")})
  lockBinding("result", .GlobalEnv)
}

if (!isGeneric("dictionary")){
  setGeneric(name="dictionary", def = function( object, ... ){standardGeneric("dictionary")})
  lockBinding("dictionary", .GlobalEnv)
}

setClass(
  Class="JD2_ProcResults",
  representation = representation(internal = "jobjRef" )
)

setMethod("dictionary", "JD2_ProcResults", function(object){
  if (is.null(object@internal)){
    NULL
  }else{
    proc_dictionary(object@internal)
  }
  
})

setMethod("result", signature = c(object="JD2_ProcResults", id="character"), function(object, id){
  if (is.null(object@internal)){
    NULL
  }else{
    proc_data(object@internal, id)}
})

lockBinding("result", .GlobalEnv)
