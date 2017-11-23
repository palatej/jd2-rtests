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

jd2_x11<-function(series, mode="Multiplicative", 
                  trendma=0, 
                  seasonalma=c("msr"),
                  sigmalim=c(1.5, 2.5), 
                  nfcasts=0, 
                  nbcasts=0, 
                  seasonal=TRUE){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  
  jspec=.jnew("ec/satoolkit/x11/X11Specification")
  jmode<-.jcall("ec/satoolkit/DecompositionMode", "Lec/satoolkit/DecompositionMode;", "valueOf", mode)
  .jcall(jspec, "V", "setMode", jmode)
  # Should be checked: lower>1, upper > lower
  .jcall(jspec, "V", "setLowerSigma", sigmalim[1])
  .jcall(jspec, "V", "setUpperSigma", sigmalim[2])
  .jcall(jspec, "V", "setForecastHorizon", as.integer(nfcasts))
  .jcall(jspec, "V", "setBackcastHorizon", as.integer(nbcasts))
  .jcall(jspec, "V", "setSeasonal", seasonal)
  .jcall(jspec, "V", "setHendersonFilterLength", as.integer((trendma)))
  # seasonal filters
  freq=frequency(series)
  if (length(seasonalma)==1){
    jd_seas<-.jcall("ec/satoolkit/x11/SeasonalFilterOption", "Lec/satoolkit/x11/SeasonalFilterOption;", "valueOf", seasonalma[1])
    .jcall(jspec, "V", "setSeasonalFilter", jd_seas)
  }else if (length(seasonalma) == freq){
    jd_allseas=list()
    for (i in 1:freq){
      jd_seas<-.jcall("ec/satoolkit/x11/SeasonalFilterOption", "Lec/satoolkit/x11/SeasonalFilterOption;", "valueOf", seasonalma[i])
      jd_allseas[[i]]<-jd_seas
    }
    .jcall(jspec, "V", "setSeasonalFilters", .jarray(jd_allseas, contents.class ="ec/satoolkit/x11/SeasonalFilterOption" ))
  }else{
    stop("Invalid seasonalma option")
  }
  
  jrslt<-.jcall("ec/tstoolkit/jdr/x11/X11Monitor", "Lec/tstoolkit/jdr/x11/X11Monitor$Results;", "process", ts_r2jd(series), jspec)
  new (Class = "JD2_X11", internal = jrslt, spec=jspec)
}

setMethod("saDecomposition", "JD2_X11", function(object){
  if (is.jnull(object@internal)){
    return (NULL)
  }else{
    series<-proc_ts(object@internal, "decomposition.b1")
    sa<-proc_ts(object@internal, "decomposition.d11")
    trend<-proc_ts(object@internal, "decomposition.d12")
    seas<-proc_ts(object@internal, "decomposition.d10")
    irr<-proc_ts(object@internal, "decomposition.d13")
    return (ts.union(series, sa, trend, seas, irr))    
  }
})

