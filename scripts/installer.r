# -------------------------------------------------------------------
# pbdR Installation script 
# TODO add parallel install capabilities
# -------------------------------------------------------------------

### Optional configure arguments.  Leave them as-is for defaults.
### Modify them for system-specific issues


### General settings
# R package library location
lib <- ""

# Set to TRUE if installing from nodes which can't load MPI
no.test.load <- FALSE

# Check if the package needs to be installed or not
check.cran.version <- FALSE



### pbdMPI settings
mpi.type <- "OPENMPI"

# Root path of your MPI library
mpi.loc <- ""



### NetCDF4 settings
# parallel NetCDF4
enable.parallel <- TRUE

# Location of nc-config --- you may need to specify this manually
nc.config.loc <- ""


################################
###  Don't modify below here ###
################################


# FIXME
#MAKE="/usr/bin/make -j 8" R CMD INSTALL pbdSLAP ...

# -------------------------------------------------------------------
#  Check CRAN version against local install
# -------------------------------------------------------------------

check.cran.version <- FALSE # FIXME 

if (check.cran.version){
  np <- new.packages()
  
  # test load packages
  test <- try(library("pbdMPI"), silent=T)
  if (inherits(test, "try-error")){
    mpi <- TRUE
  } else {
    mpiver.loc <- sessionInfo()$otherPkgs$memuse$Version
    mpiver.cran <- grep(
  }
  
} else {
  mpi <- ncdf4 <- slap <- base <- dmat <- demo <- prof <- clust <- TRUE
}

# -------------------------------------------------------------------
# Install
# -------------------------------------------------------------------

### Set repo if needed
if (options()$repo == "@CRAN@"){
  options(repos=structure(c(CRAN="http://mirrors.nics.utk.edu/cran/")))
}

### Change variables to flags
if (no.test.load){
  no.test.load <- "--no-test-load"
} else {
  no.test.load <- ""
}

if (enable.parallel){
  enable.parallel <- "--enable-parallel"
} else {
  enable.parallel <- ""
}

if (mpi.loc != ""){
  mpi.loc <- paste("--with-mpi=", mpi.loc, sep="")
}

if (lib == ""){
  lib <- .libPaths()[1L]
}

instmpi <- instncdf4 <- instslap <- instbase <- instdmat <- instdemo <- instprof <- instclust <- FALSE


### pbdMPI
if (mpi){
  test <- try(install.packages("pbdMPI", lib=lib, INSTALL_opts=no.test.load, configure.args=paste("--with-mpi=", mpi.loc, " --with-Rmpi-type=", mpi.type, sep="")), silent=TRUE)
  if (inherits(test, "try-error")){
    instmpi <- "FAILURE"
  } else {
    instmpi <- TRUE
  }
}

### pbdNCDF4
if (ncdf4){
  test <- try(install.packages("pbdNCDF4", lib=lib, INSTALL_opts=no.test.load, configure.args=paste("--with-nc-config=", nc.config.loc, " ", enable.parallel, sep="")), silent=TRUE)
  if (inherits(test, "try-error")){
    instncdf4 <- "FAILURE"
  } else {
    instncdf4 <- TRUE
  }
}

### pbdSLAP
if (slap){
  test <- try(install.packages("pbdSLAP", lib=lib, INSTALL_opts=no.test.load), silent=TRUE)
  if (inherits(test, "try-error")){
    instslap <- "FAILURE"
  } else {
    instslap <- TRUE
  }
}

### pbdBASE
if (base){
  test <- try(install.packages("pbdBASE", lib=lib, INSTALL_opts=no.test.load), silent=TRUE)
  if (inherits(test, "try-error")){
    instbase <- "FAILURE"
  } else {
    instbase <- TRUE
  }
}

### pbdDMAT
if (dmat){
  test <- try(install.packages("pbdDMAT", lib=lib, INSTALL_opts=no.test.load), silent=TRUE)
  if (inherits(test, "try-error")){
    instdmat <- "FAILURE"
  } else {
    instdmat <- TRUE
  }
}

### pbdDEMO
if (demo){
  test <- try(install.packages("pbdDEMO", lib=lib, INSTALL_opts=no.test.load), silent=TRUE)
  if (inherits(test, "try-error")){
    instdemo <- "FAILURE"
  } else {
    instdemo <- TRUE
  }
}

### pbdPROF
if (prof){
  test <- try(install.packages("pbdPROF", lib=lib, INSTALL_opts=no.test.load), silent=TRUE)
  if (inherits(test, "try-error")){
    instprof <- "FAILURE"
  } else {
    instprof <- TRUE
  }
}

### pmclust
if (clust){
  test <- try(install.packages("pmclust", lib=lib, INSTALL_opts=no.test.load), silent=TRUE)
  if (inherits(test, "try-error")){
    instclust <- "FAILURE"
  } else {
    instclust <- TRUE
  }
}


cat(sprintf("Installed new versions of:\n"))
ret <- t(data.frame(c(instmpi, instncdf4, instslap, instbase, instdmat, instdemo, instprof, instclust)))
rownames(ret) <- "Installed?"
colnames(ret) <- c("pbdMPI", "pbdNCDF4", "pbdSLAP", "pbdBASE", "pbdDMAT", "pbdDEMO", "pbdPROF", "pmclust")
print(ret)


