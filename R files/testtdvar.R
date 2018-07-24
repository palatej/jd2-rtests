source("./R files/jd2_init.R")
source("./R files/jd2_tdvar.R")
source("./R files/jd2_mtd.R")
source("./R files/jd2_x13.R")
source("./R files/jd2_tests.R")

load("./Data/ABS.rda")

tdvar_all<-function(s, log=TRUE, td="TD7", var="Default",aicdiff=0){
  orig<-s
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

  xx<-jd2_mtd(orig, windowLength = 7,reestimate = TRUE)
  cc<-result(xx, "mtd.smoothedcoefficients")
  s<--rowSums(cc)
  cc<-cbind(cc,s)
  plot(cc[,1], type="l", ylim=c(min(cc), max(cc)))
  clrs<-c( "black","red", "green3","blue","cyan","magenta","gray")
  for (i in 2: dim(cc)[2]){
    lines(cc[,i],col=clrs[i])
  }

#time varying trading days
  a<-jd2_tvtd(orig)
#available results
#dictionary(a)
#take the calendar effects and the final sa series
  td_a<-result(a,"tvtd.tde")
  sa_a<-result(a,"sa")

# same with moving window
  b<-jd2_mtd(orig)
#available results
#dictionary(b)
#take the calendar effects and the final sa series
  td_b<-result(b,"mtd.tde")
  sa_b<-result(b,"sa")

  ts.plot(ts.union(td_a, td_b), col=c("blue", "red"))
  ts.plot(ts.union(sa_a, sa_b), col=c("blue", "red"))

  sa<-result(jd2_x13(orig), "sa")
  cat("\nTD tests on the last 15 years\n" )
  cat("residual TD effects are significant if the PValue < 0.05 \n" )
  cat("\nx13\n" )
  print(jd2_td_FTest(sa, nyears=15)[2])
  cat("\nTime Varying\n")
  print(jd2_td_FTest(sa_a, nyears=15)[2])
  cat("\nMoving window\n" )
  print(jd2_td_FTest(sa_b, nyears=15)[2])
  
}

tdvar_all(ABS$X0.2.09.10.M)
#tdvar_all(ABS$X0.2.20.10.M, var="Contrasts")
#tdvar_all(ABS$X0.2.41.10.M )

