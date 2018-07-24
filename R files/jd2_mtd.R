source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")

setClass(
  Class="JD2_MovingTradingDays",
  contains = "JD2_ProcResults"
)




jd2_mtd<-function(s, windowLength=11, smoothingLength=5, preprocessor="tramo", option="TR5a", reestimate=FALSE){
  
  jd_s<-ts_r2jd(s)
  jrslt<-.jcall("ec/tstoolkit/jdr/tdvar/MovingTradingDays", 
                "Lec/tstoolkit/jdr/tdvar/MovingTradingDays$Results;", 
                "movingWindow", jd_s, as.integer(windowLength), as.integer(smoothingLength), preprocessor, option, reestimate)
  new (Class = "JD2_MovingTradingDays", internal = jrslt)
  
}

jd2_tvtd<-function(s, contrasts=FALSE, preprocessor="tramo", option="TR5a"){
  
  jd_s<-ts_r2jd(s)
  jrslt<-.jcall("ec/tstoolkit/jdr/tdvar/MovingTradingDays", 
                "Lec/tstoolkit/jdr/tdvar/MovingTradingDays$Results2;", 
                "timeVarying", jd_s, contrasts, preprocessor, option)
  new (Class = "JD2_MovingTradingDays", internal = jrslt)
  
}


