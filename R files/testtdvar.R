source("./R files/jd2_init.R")
source("./R files/jd2_tdvar.R")
source("./R files/jd2_mtd.R")
source("./R files/jd2_x13.R")
source("./R files/jd2_tests.R")

load("./Data/ABS.rda")

tdvar_all<-function(s, log=TRUE, td="TD7", var="Default",aicdiff=0){
  if (log){
    s<-log(s)
  }
  x<-jd2_tdvar(s, td, var, aicdiff)
  show(x)
  c<-result(x, "coefficients.value")
  ec<-result(x, "coefficients.stde")
  w<-c[,dim(c)[2]]
  ew<-ec[,dim(c)[2]]
  
  plot(w, type="l", col="red", ylim=c(min(w-ew), max(w+ew)))
  lines(w+ew, col="gray")
  lines(w-ew, col="gray")
  
  plot(c[,1], type="l", ylim=c(min(c), max(c)))
  clrs<-c( "black","red", "green3","blue","cyan","magenta","gray")
  for (i in 2: dim(c)[2]){
    lines(c[,i],col=clrs[i])
  }
}

mtd_all<-function(s, preprocessor="tramo", option="TR5a"){
  a<-jd2_mtd(s, windowLength = 11, preprocessor = preprocessor, option = option,reestimate = TRUE)
  c_a<-result(a, "mtd.smoothedcoefficients")
  if (! is.null(c_a)){
    sum<--rowSums(c_a)
    c_a<-cbind(c_a,sum)
    plot(c_a[,1], type="l", ylim=c(min(c_a), max(c_a)))
    clrs<-c( "black","red", "green3","blue","cyan","magenta","gray")
    for (i in 2: dim(c_a)[2]){
      lines(c_a[,i],col=clrs[i])
    }
#available results
#dictionary(a)
#take the calendar effects and the final sa series
    td_a<-result(a,"mtd.tde")
    sa_a<-result(a,"sa")

#time varying trading days
    b<-jd2_tvtd(s, preprocessor = preprocessor, option = option)

# same with moving window
    c_b<-result(b, "tvtd.coefficients")
    sum<--rowSums(c_b)
      c_b<-cbind(c_b,sum)
      plot(c_b[,1], type="l", ylim=c(min(c_b), max(c_b)))
      clrs<-c( "black","red", "green3","blue","cyan","magenta","gray")
      for (i in 2: dim(c_b)[2]){
        lines(c_b[,i],col=clrs[i])
      }
      #available results
#dictionary(b)
#take the calendar effects and the final sa series
    td_b<-result(b,"tvtd.tde")
    sa_b<-result(b,"sa")

    ts.plot(ts.union(td_a, td_b), col=c("blue", "red"))
    ts.plot(ts.union(sa_a, sa_b), col=c("blue", "red"))

    sa<-result(jd2_x13(s), "sa")
    cat("\nTD tests on the last 15 years\n" )
    cat("residual TD effects are significant if the PValue < 0.05 \n" )
    cat("\nx13\n" )
    print(jd2_td_FTest(sa, nyears=15)[2])
    cat("\nTime Varying\n")
    print(jd2_td_FTest(sa_a, nyears=15)[2])
    cat("\nMoving window\n" )
    print(jd2_td_FTest(sa_b, nyears=15)[2])
  }
}

tdvar_all(ABS$X0.2.09.10.M)
mtd_all(ABS$X0.2.09.10.M)
#tdvar_all(ABS$X0.2.20.10.M, var="Contrasts")
#tdvar_all(ABS$X0.2.41.10.M )

