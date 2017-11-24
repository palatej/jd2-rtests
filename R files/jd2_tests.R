source("./R files/jd2_init.R")
source("./R files/jd2_rslts.R")

jd2_seasonality_KruskalWallis<-function(series){
  js<-ts_r2jd(series)
  jtest<-.jcall("ec/tstoolkit/jdr/tests/SeasonalityTests", "Lec/tstoolkit/information/StatisticalTest;", "kruskalWallisTest", js)
  if (is.jnull(jtest))
    return (NULL)
  else{
    return (test_jd2r(jtest))
  }
}

jd2_seasonality_Friedman<-function(series){
  js<-ts_r2jd(series)
  jtest<-.jcall("ec/tstoolkit/jdr/tests/SeasonalityTests", "Lec/tstoolkit/information/StatisticalTest;", "friedmanTest", js)
  if (is.jnull(jtest))
    return (NULL)
  else{
    return (test_jd2r(jtest))
  }
}


jd2_seasonality_FTest<-function(series, ar=TRUE, nyears=0){
  js<-ts_r2jd(series)
  jtest<-.jcall("ec/tstoolkit/jdr/tests/SeasonalityTests", "Lec/tstoolkit/information/StatisticalTest;", "ftest", js, ar, as.integer(nyears))
  if (is.jnull(jtest))
    return (NULL)
  else{
    return (test_jd2r(jtest))
  }
}

jd2_seasonality_QSTest<-function(series, nyears=0, diff = -1, mean=TRUE){
  js<-ts_r2jd(series)
  jtest<-.jcall("ec/tstoolkit/jdr/tests/SeasonalityTests", "Lec/tstoolkit/information/StatisticalTest;", "qstest", js, as.integer(nyears), as.integer(diff), mean)
  if (is.null(jtest))
    return (NULL)
  else{
    return (test_jd2r(jtest))
  }
}

jd2_td_FTest<-function(series, ar=TRUE, nyears=0){
  js<-ts_r2jd(series)
  jtest<-.jcall("ec/tstoolkit/jdr/tests/TradingDaysTests", "Lec/tstoolkit/information/StatisticalTest;", "ftest", js, ar, as.integer(nyears))
  if (is.jnull(jtest))
    return (NULL)
  else{
    return (test_jd2r(jtest))
  }
}

