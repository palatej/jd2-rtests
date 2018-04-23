source("./R files/jd2_init.R")
source("./R files/jd2_regarima.R")

load("./Data/ABS.rda")
load("./Data/retail.rda")

reg1<-jd2_tramo(ABS$X0.2.41.10.M)
reg2<-jd2_regarima(ABS$X0.2.41.10.M)

f<-ts.union(result(reg1, "model.fcasts(24)"), result(reg2, "model.fcasts(24)"))
ts.plot(f, col=c("blue", "red"))

dictionary(reg1)

result(reg1, "model.log")
