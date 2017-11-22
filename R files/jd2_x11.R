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

jd2_x11<-function(y, mode="Multiplicative", nfcasts=0, nbcasts=0){
  if (!is.ts(y)){
    stop("y must be a time series")
  }
  
  jspec=.jnew("ec/satoolkit/x11/X11Specification")
  jmode<-.jcall("ec/satoolkit/DecompositionMode", "Lec/satoolkit/DecompositionMode;", "valueOf", mode)
  .jcall(jspec, "V", "setMode", jmode)
  .jcall(jspec, "V", "setForecastHorizon", as.integer(nfcasts))
  .jcall(jspec, "V", "setBackcastHorizon", as.integer(nbcasts))
  jrslt<-.jcall("ec/tstoolkit/jdr/x11/X11Monitor", "Lec/tstoolkit/jdr/x11/X11Monitor$Results;", "process", ts_r2jd(y), jspec)
  new (Class = "JD2_X11", internal = jrslt, spec=jspec)
}

setMethod("saDecomposition", "JD2_X11", function(object){
  if (is.jnull(object@internal)){
    return (NULL)
  }else{
    y<-proc_ts(object@internal, "decomposition.b1")
    sa<-proc_ts(object@internal, "decomposition.d11")
    trend<-proc_ts(object@internal, "decomposition.d12")
    seas<-proc_ts(object@internal, "decomposition.d10")
    irr<-proc_ts(object@internal, "decomposition.d13")
    return (ts.union(y, sa, trend, seas, irr))    
  }
})

