source("./R files/jd2_init.R")
source("./R files/jd2_ts.R")

proc_numeric<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (!is.null(s))
    .jcall(s, "D", "doubleValue")
  else
    return (NaN)
}

proc_vector<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.null(s))
    return(NULL)
  .jevalArray(s)
}

proc_int<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.null(s))
    return(-1)
  .jcall(s, "I", "intValue")
}

proc_bool<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.null(s))
    return(FALSE)
  .jcall(s, "Z", "booleanValue")
}

proc_ts<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.null(s))
    return (NULL)
  else
    return (ts_jd2r(s))
}

proc_period<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  else
    return (period_jd2r(s))
}

proc_str<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  .jcall(s, "S", "toString")
}

proc_desc<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  return (.jevalArray(s))
}

proc_test<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  desc<-.jcall(s, "S", "getDescription")
  val<-.jcall(s, "D", "getValue")
  pval<-.jcall(s, "D", "getPvalue")
  all<-c(val, pval)
  attr(all, "description")<-desc
  return (all)
}

proc_parameter<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  val<-.jcall(s, "D", "getValue")
  e<-.jcall(s, "D", "getStde")
  return (c(val, e))
}

proc_parameters<-function(rslt, name){
  jd_p<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(jd_p))
    return(NULL)
  p<-.jcastToArray(jd_p)
  len<-length(p)
  all<-array(0, dim=c(len,2))
  for (i in 1:len){
    all[i, 1]<-.jcall(p[[i]], "D", "getValue")
    all[i, 2]<-.jcall(p[[i]], "D", "getStde")
  }
  return (all)
}

proc_reg<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  desc<-.jfield(s, "S", "description")
  val<-.jfield(s, "D", "coefficient")
  e<-.jfield(s, "D", "stdError")
  all<-c(val, e)
  attr(all, "description")<-desc
  return (all)
}

proc_matrix<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.jnull(s))
    return(NULL)
  return (matrix_jd2r(s))
}

proc_data<-function(rslt, name){
  s<-.jcall(rslt, "Ljava/lang/Object;", "getData", name, jd_clobj)
  if (is.null(s))
    return (NULL)
  if (.jinstanceof(s, "ec.tstoolkit/timeseries/simplets/TsData"))
    return(ts_jd2r(.jcast(s,"ec.tstoolkit/timeseries/simplets/TsData")))
  else if (.jinstanceof(s, "ec.tstoolkit/maths/matrices/Matrix"))
    return(matrix_jd2r(.jcast(s,"ec.tstoolkit/maths/matrices/Matrix")))
  else if (.jinstanceof(s, "java/lang/reflect/Array"))
    return (.jevalArray(s, silent=TRUE))
  else if (.jinstanceof(s, "java/lang/Number"))
    return (.jcall(s, "D", "doubleValue"))
  else if (.jinstanceof(s, "ec/tstoolkit/information/StatisticalTest"))
    return (test_jd2r(s))
  else
    return (.jcall(s, "S", "toString"))
}

proc_dictionary2<-function(jobj){
  jmap<-.jcall(.jcast(jobj, "ec/tstoolkit/algorithm/IProcResults"), "Ljava/util/Map;", "getDictionary")
  jkeys<-.jcall(jmap, "Ljava/util/Set;", "keySet")
  size<-.jcall(jkeys, "I", "size")
  keys<-array(dim=size)
  jiter<-.jcall(jkeys, "Ljava/util/Iterator;", "iterator")
  for (i in 1:size){
    keys[i]=.jcall(.jcall(jiter, "Ljava/lang/Object;", "next"), "Ljava/lang/String;", "toString")
  }
  return (keys)
}

proc_dictionary<-function(name){
  jmapping<-.jcall(name, "Ldemetra/information/InformationMapping;", "getMapping")
  jmap<-.jnew("java/util/LinkedHashMap")
  .jcall(jmapping, "V", "fillDictionary", .jnull("java/lang/String"), .jcast(jmap, "java/util/Map"), TRUE )
  jkeys<-.jcall(jmap, "Ljava/util/Set;", "keySet")
  size<-.jcall(jkeys, "I", "size")
  keys<-array(dim=size)
  jiter<-.jcall(jkeys, "Ljava/util/Iterator;", "iterator")
  for (i in 1:size){
    keys[i]=.jcall(.jcall(jiter, "Ljava/lang/Object;", "next"), "Ljava/lang/String;", "toString")
  }
  return (keys)
}



matrix_jd2r<-function(s){
  if (is.jnull(s)){
    return (NULL)
  }
  nr<-.jcall(s, "I", "getRowsCount")
  nc<-.jcall(s, "I", "getColumnsCount")
  d<-.jcall(s, "[D", "internalStorage")
  return (array(d, dim=c(nr, nc)))
}

matrix_r2jd<-function(s){
  if (!is.matrix(s)){
    return (NULL)
  }
  sdim<-dim(s)
  return (.jnew("ec/tstoolkit/maths/matrices/matrix", as.double(s), as.integer(sdim[1], as.integer(sdim[2])) ))
}

test_jd2r<-function(s){
  if (is.null(s))
    return(NULL)
  desc<-.jfield(s, "S", "description")
  val<-.jfield(s, "D", "value")
  pval<-.jfield(s, "D", "pvalue")
  all<-c(val, pval)
  attr(all, "description")<-desc
  return (all)
}


