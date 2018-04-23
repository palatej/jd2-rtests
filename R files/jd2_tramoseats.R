source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")


setClass(
  Class="JD2_TramoSeats",
  contains = "JD2_ProcResults"
)

jd2_tramoseats<-function(series, spec=c("RSAfull", "RSA0", "RSA1", "RSA2", "RSA", "RSA4", "RSA5")){
  if (!is.ts(series)){
    stop("series must be a time series")
  }
  spec<-match.arg(spec)
  jspec<-.jcall("ec/satoolkit/tramoseats/TramoSeatsSpecification","Lec/satoolkit/tramoseats/TramoSeatsSpecification;", "fromString", spec)
  
  jrslt<-.jcall("ec/tstoolkit/jdr/sa/Processor", "Lec/tstoolkit/jdr/sa/TramoSeatsResults;", "tramoseats", ts_r2jd(series), jspec, .jnull("jdr/spec/ts/Utility$Dictionary"))
  new (Class = "JD2_TramoSeats", internal = jrslt)
}

