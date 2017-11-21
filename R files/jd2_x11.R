source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")

if (!isGeneric("mstatistics")){
  setGeneric(name="mstatistics", def = function( object, ... ){standardGeneric("mstatistics")})
  lockBinding("mstatistics", .GlobalEnv)
}

setClass(
  Class="JD2_X11",
  contains = "JD2_ProcResults",
  representation = representation(spec="jobjRef")
)

setClass(
  Class="JD2_MStatistics",
  contains = "JD2_ProcResults"
)


jd2_x11<-function(y, mode="Multiplicative", nfcasts=0, nbcasts=0){
  if (!is.ts(y)){
    stop("y must be a time series")
  }
  
  jspec=.jnew("ec/satoolkit/x11/X11Specification")
  jmode<-.jcall("ec/satoolkit/DecompositionMode", "Lec/satoolkit/DecompositionMode;", "valueOf", mode)
  .jcall(jspec, "V", "setMode", jmode)
  .jcall(jspec, "V", "setForecastHorizon", as.integer(nfcasts))
  .jcall(jspec, "V", "setBackcastHorizon", as.integer(nbcasts))
  jrslt<-.jcall("ec/tstoolkit/jdr/X11Monitor", "Lec/satoolkit/x11/X11Results;", "process", ts_r2jd(y), jspec)
  new (Class = "JD2_X11", internal = jrslt, spec=jspec)
}

setMethod("saDecomposition", "JD2_X11", function(object){
  if (is.jnull(object@internal)){
    return (NULL)
  }else{
    y<-proc_ts(object@internal, "b-tables.b1")
    sa<-proc_ts(object@internal, "d-tables.d11")
    trend<-proc_ts(object@internal, "d-tables.d12")
    seas<-proc_ts(object@internal, "d-tables.d10")
    irr<-proc_ts(object@internal, "d-tables.d13")
    return (ts.union(y, sa, trend, seas, irr))    
  }
})

setMethod("mstatistics", "JD2_X11", function(object){
  if (is.null(object@internal)){
    return (NULL)
  }else{
    jmode<-.jcall(object@spec,"Lec/satoolkit/DecompositionMode;", "getMode")
    jinfo<-.jcall(object@internal, "Lec/tstoolkit/information/InformationSet;", "getInformation")
    jmstats<-.jcall("ec/satoolkit/x11/Mstatistics", "Lec/satoolkit/x11/Mstatistics;", "computeFromX11", jmode, jinfo)
    return ( new (Class = "JD2_MStatistics", internal = jmstats) )
  }
})
