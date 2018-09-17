source("./R files/jd2_x11.R")
source("./R files/jd2_combinedseasonality.R")
source("./R files/jd2_tests.R")

load("./Data/ABS.rda")

a<-jd2_x11(ABS$X0.2.09.10.M, mode = "PseudoAdditive", sigmalim = c(1,2), seasonalma = "S3X9")
plot(a)
print(dictionary(a))

d10<-result(a, "decomposition.d10")
plot(d10[cycle(d10)==1])

show(a)

#qb3<-jd2_CombinedSeasonality(result(a, "decomposition.b3"), TRUE)
#show(result(qb3, "stable"))

#qd8<-jd2_CombinedSeasonality(result(a, "decomposition.d8"), TRUE)
#show(result(qd8, "stable"))
#show(result(qd8, "evolutive"))


