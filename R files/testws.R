source("./R files/jd2_init.R")
source("./R files/jd2_workspace.R")

load("./Data/ABS.rda")
load("./Data/retail.rda")

ws<-jd2_newworkspace()
mp<-jd2_newmultiprocessing(ws, "test")

p1<-.jcall("ec/satoolkit/tramoseats/TramoSeatsSpecification", "Lec/satoolkit/tramoseats/TramoSeatsSpecification;", "fromString", "RSAfull")
p2<-.jcall("ec/satoolkit/x13/X13Specification", "Lec/satoolkit/x13/X13Specification;", "fromString", "RSA5c")

jd2_addsaitem(mp, "a1", ts_r2jd(ABS$X0.2.01.10.M), p1)
jd2_addsaitem(mp, "b1", ts_r2jd(ABS$X0.2.01.10.M), p2)
jd2_addsaitem(mp, "a2", ts_r2jd(ABS$X0.2.02.10.M), p1)
jd2_addsaitem(mp, "b2", ts_r2jd(ABS$X0.2.02.10.M), p2)
jd2_addsaitem(mp, "a3", ts_r2jd(ABS$X0.2.03.10.M), p1)
jd2_addsaitem(mp, "b3", ts_r2jd(ABS$X0.2.03.10.M), p2)
jd2_addsaitem(mp, "a4", ts_r2jd(ABS$X0.2.04.10.M), p1)
jd2_addsaitem(mp, "b4", ts_r2jd(ABS$X0.2.04.10.M), p2)
jd2_addsaitem(mp, "a5", ts_r2jd(ABS$X0.2.05.10.M), p1)
jd2_addsaitem(mp, "b5", ts_r2jd(ABS$X0.2.05.10.M), p2)
jd2_addsaitem(mp, "a6", ts_r2jd(ABS$X0.2.06.10.M), p1)
jd2_addsaitem(mp, "b6", ts_r2jd(ABS$X0.2.06.10.M), p2)
jd2_addsaitem(mp, "a7", ts_r2jd(ABS$X0.2.07.10.M), p1)
jd2_addsaitem(mp, "b7", ts_r2jd(ABS$X0.2.07.10.M), p2)
jd2_addsaitem(mp, "a8", ts_r2jd(ABS$X0.2.08.10.M), p1)
jd2_addsaitem(mp, "b8", ts_r2jd(ABS$X0.2.08.10.M), p2)
jd2_addsaitem(mp, "a9", ts_r2jd(ABS$X0.2.09.10.M), p1)
jd2_addsaitem(mp, "b9", ts_r2jd(ABS$X0.2.09.10.M), p2)

jd2_compute(ws)

jd2_saveworkspace(ws, "c:\\sarepository\\mytest.xml")

item<-jd2_saitem(mp, 1)
proc_dictionary(jd2_saresults(item))

plot(proc_data(jd2_saresults(item), "sa"))

ws2<-jd2_openworkspace("c:\\sarepository\\mytest.xml")
m2<-jd2_multiprocessing(ws2, 1)



