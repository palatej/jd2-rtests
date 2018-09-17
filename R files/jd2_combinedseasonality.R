source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")

#setClass(
#  Class="JD2_CombinedSeasonality",
#  contains = "JD2_ProcResults",
#  representation = representation(spec="jobjRef")
#)


#setMethod("show", "JD2_CombinedSeasonality", function(object){
#  if (is.jnull(object@internal)){
#    return (NULL)
#  }else{
#    cat("Combined seasonality test", "\n")
#  }
#})

#jd2_CombinedSeasonality<-function(series, multiplicative=TRUE){
#  js<-ts_r2jd(series)
#  jtest<-.jcall("ec/tstoolkit/jdr/tests/CombinedSeasonalityTest", "Lec/tstoolkit/jdr/tests/CombinedSeasonalityTest$Results;", 
#                "test", js, multiplicative)
#  new (Class = "JD2_CombinedSeasonality", internal = jtest)
#}



