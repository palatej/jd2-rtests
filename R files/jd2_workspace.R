source("./R files/jd2_init.R")
source("./R files/jd2_procresults.R")
source("./R files/jd2_rslts.R")

# Open a workspace
jd2_openworkspace<-function(name){
  return(.jcall("ec/tstoolkit/jdr/ws/Workspace", "Lec/tstoolkit/jdr/ws/Workspace;", "open", name))
}

#Number of multiprocessing
jd2_multiprocessingcount<-function(jws){
  return (.jcall(jws, "I", "getMultiProcessingCount"))
}

# Get the given processing (from 1 to n )
jd2_multiprocessing<-function(jws, pos=1){
  return(.jcall(jws, "Lec/tstoolkit/jdr/ws/MultiProcessing;", "getMultiProcessing", as.integer(pos-1)))
}

# Get the name of a multiprocessing
jd2_mutiprocessingname<-function(jmp){
  return (.jcall(jmp, "S", "getName"))
}

# Compute all the multi-processing or a given one
jd2_compute<-function(jws, name = NULL){
  if (is.null(name)){
    .jcall(jws, "V", "computeAll")
  }else{
    .jcall(jws, "V", "compute", name)
  }
}

#Number of items in a multiprocessing
jd2_saitemscount<-function(jmp){
  return (.jcall(jmp, "I", "size"))
}

# Get the given item in a multi-processing (from 1 to n )
jd2_saitem<-function(jmp, pos=1){
  return(.jcall(jmp, "Lec/tstoolkit/jdr/ws/SaItem;", "get", as.integer(pos-1)))
}

# Get the results of an saitem 
jd2_saresults<-function(jsa){
  return(.jcall(jsa, "Ldemetra/algorithm/IProcResults;", "getResults"))
}

# Get the specification of an saitem  (possible type: Domain, Estimation, Point)
jd2_saspec<-function(jsa, type="Domain"){
  jt<-.jcall(jsa, "Ldemetra/datatypes/sa/SaItemType;", "getSaDefinition")
  if (type == "Domain"){
  return(.jcall(jt, "Lec/satoolkit/ISaSpecification;", "getDomainSpec"))
  }
  if (type == "Estimation"){
    return(.jcall(jt, "Lec/satoolkit/ISaSpecification;", "getEstimationSpec"))
  }
  if (type == "Point"){
    return(.jcall(jt, "Lec/satoolkit/ISaSpecification;", "getPointSpec"))
  }
  return (NULL)
}

# Get the ts (java) of an saitem 
jd2_sats<-function(jsa){
  jt<-.jcall(jsa, "Ldemetra/datatypes/sa/SaItemType;", "getSaDefinition")
  jts<-.jcall(jt, "Ldemetra/datatypes/Ts;", "getTs")
  return (.jcall(jts, "Lec/tstoolkit/timeseries/simplets/TsData;", "getData"))
}

# Get the name of an saitem 
jd2_saname<-function(jsa){
  jt<-.jcall(jsa, "Ldemetra/datatypes/sa/SaItemType;", "getSaDefinition")
  jts<-.jcall(jt, "Ldemetra/datatypes/Ts;", "getTs")
  return (.jcall(jts, "S", "getName"))
}


# Creates a new workspace
jd2_newworkspace<-function(dictionary=.jnull("jdr/spec/ts/Utility$Dictionary")){
  return(.jcall("ec/tstoolkit/jdr/ws/Workspace", "Lec/tstoolkit/jdr/ws/Workspace;", "create", dictionary))
}

# Creates a new multi-doument
jd2_newmultiprocessing<-function(jws, name){
  return(.jcall(jws, "Lec/tstoolkit/jdr/ws/MultiProcessing;", "newMultiProcessing", name))
}

# Add a new element in a multiprocessing, jmp == multiprocessing, 
jd2_addsaitem<-function(jmp, name, jts, jspec){
    .jcall(jmp, "V", "add", name, jts, jspec)
}

jd2_saveworkspace<-function(jws, file){
  .jcall(jws, "Z", "save", file)
}


