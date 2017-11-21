if(!require(rJava)){
  install.packages("rJava")
}
library("rJava")
.jinit()
.jaddClassPath("./Java/demetra-tstoolkit-2.2.1-SNAPSHOT.jar")
.jaddClassPath("./Java/jdr-2.2.1-SNAPSHOT.jar")

jd_clobj<-.jcall("java/lang/Class", "Ljava/lang/Class;", "forName", "java.lang.Object")
