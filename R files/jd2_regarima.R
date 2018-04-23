source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")


setClass(
  Class="JD2_RegArima",
  contains = "JD2_ProcResults"
)

jd2_tramo<-function(series, spec=c("TRfull", "TR0", "TR1", "TR2", "TR3", "TR4", "TR5")){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  spec<-match.arg(spec)
  jspec<-.jcall("ec/tstoolkit/modelling/arima/tramo/TramoSpecification","Lec/tstoolkit/modelling/arima/tramo/TramoSpecification;", "fromString", spec)
  
  jrslt<-.jcall("ec/tstoolkit/jdr/regarima/Processor", "Lec/tstoolkit/jdr/regarima/Processor$Results;", "tramo", ts_r2jd(series), jspec, .jnull("jdr/spec/ts/Utility$Dictionary"))
  new (Class = "JD2_RegArima", internal = jrslt)
}

jd2_regarima<-function(series, spec=c("RG5c", "RG0", "RG1", "RG2c", "RG3", "RG4c")){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  spec<-match.arg(spec)
  jrspec<-.jcall("jdr/spec/x13/RegArimaSpec", "Ljdr/spec/x13/RegArimaSpec;", "of", spec)
  jspec<-.jcall(jrspec, "Lec/tstoolkit/modelling/arima/x13/RegArimaSpecification;", "getCore")
  #jspec<-.jcall("ec/tstoolkit/modelling/arima/x13/RegArimaSpecification","Lec/tstoolkit/modelling/arima/x13/RegArimaSpecification;", "fromString", spec)
  
  jrslt<-.jcall("ec/tstoolkit/jdr/regarima/Processor", "Lec/tstoolkit/jdr/regarima/Processor$Results;", "x12", ts_r2jd(series), jspec, .jnull("jdr/spec/ts/Utility$Dictionary"))
  new (Class = "JD2_RegArima", internal = jrslt)
}
