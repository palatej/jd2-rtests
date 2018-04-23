source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")


setClass(
  Class="JD2_X13",
  contains = "JD2_ProcResults"
)

jd2_x13<-function(series, spec=c("RSA5c", "RSA0", "RSA1", "RSA2c", "RSA3", "RSA4c")){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  spec<-match.arg(spec)
  jspec<-.jcall("ec/satoolkit/x13/X13Specification","Lec/satoolkit/x13/X13Specification;", "fromString", spec)
  
  jrslt<-.jcall("ec/tstoolkit/jdr/sa/Processor", "Lec/tstoolkit/jdr/sa/X13Results;", "x13", ts_r2jd(series), jspec, .jnull("jdr/spec/ts/Utility$Dictionary"))
  new (Class = "JD2_X13", internal = jrslt)
}

