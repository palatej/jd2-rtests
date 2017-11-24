source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")

if (!isGeneric("mstatistics")){
  setGeneric(name="mstatistics", def = function( object, ... ){standardGeneric("mstatistics")})
  lockBinding("mstatistics", .GlobalEnv)
}

setClass(
  Class="JD2_X11",
  contains = "JD2_ProcResults"
)

jd2_x11<-function(series, mode=c("Multiplicative", "Additive", "LogAdditive", "PseudoAdditive"), 
                  trendma=0, 
                  seasonalma=c("Msr", "X11Default", "S3X1", "S3X3", "S3X5", "S3X7", "S3X9", "S3X15", "Stable"), 
                  seasonalma.specific=NULL, 
                  sigmalim=c(1.5, 2.5), 
                  nfcasts=0, 
                  nbcasts=0, 
                  seasonal=TRUE){
  mode<-match.arg(mode)
  if (! is.null(seasonalma.specific)){
    seasonalma.specific<-match.arg(seasonalma.specific, choices = seasonalma , several.ok=TRUE)
  }
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  seasonalma<-match.arg(seasonalma)
  
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
  if (is.null(seasonalma.specific)){
    jd_seas<-.jcall("ec/satoolkit/x11/SeasonalFilterOption", "Lec/satoolkit/x11/SeasonalFilterOption;", "valueOf", seasonalma[1])
    .jcall(jspec, "V", "setSeasonalFilter", jd_seas)
  }else if (length(seasonalma.specific) == freq){
    jd_allseas=list()
    for (i in 1:freq){
      jd_seas<-.jcall("ec/satoolkit/x11/SeasonalFilterOption", "Lec/satoolkit/x11/SeasonalFilterOption;", "valueOf", seasonalma.specific[i])
      jd_allseas[[i]]<-jd_seas
    }
    .jcall(jspec, "V", "setSeasonalFilters", .jarray(jd_allseas, contents.class ="ec/satoolkit/x11/SeasonalFilterOption" ))
  }else{
    stop("Invalid seasonalma option")
  }
  
  jrslt<-.jcall("ec/tstoolkit/jdr/x11/X11Monitor", "Lec/tstoolkit/jdr/x11/X11Monitor$Results;", "process", ts_r2jd(series), jspec)
  new (Class = "JD2_X11", internal = jrslt)
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

setMethod("show", "JD2_X11", function(object){
  if (is.jnull(object@internal)){
    return (NULL)
  }else{
    cat("X11 decomposition", "\n")
    cat("M-Statistics","\n")
    for (i in 1:10){
      item=paste("diagnostics.M(",i,")", sep="")
      name=paste("M",i, ": ",sep="")
      m<-proc_numeric(object@internal, as.character(item))
      cat(name, format(round(m, 4), scientific = FALSE), "\n")
    }
    m<-proc_numeric(object@internal, "diagnostics.Q")
    cat("Q: ", format(round(m, 4), scientific = FALSE), "\n")
  }
})

setMethod("plot", "JD2_X11", function(x,y,...){
  if (is.jnull(x@internal)){
    return
  }else{
    plot(saDecomposition(x))
  }
})
