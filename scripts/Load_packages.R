# Environment Set up
rm(list = ls()) #Clean workspace
cat("\014")     #Clean Console
gc() # Free memory

###################
# Install packages
###################

pkgs <- c("remedy", "dplyr", "Seurat", "rstudioapi", "BiocManager",
          "cowplot", "gplots", "ggplot2", "grid", "gridExtra",
          "styler", "stringr", "inlmisc", "RColorBrewer",
          "readxl", "devtools", "tidyverse", "hdf5r", "scales",
          "useful", "renv", "pROC", "ggfittext", "ggalluvial", "RVenn")

for(i in 1:length(pkgs)){
  if(!require(pkgs[i], character.only = T)){
    install.packages(pkgs[i])
    require(pkgs[i], character.only = T)
  }else{
    require(pkgs[i], character.only = T)
  }
}

pkgs <- c("gplots", "fgsea", "biomaRt", "clusterProfiler", "SeuratObject",
          "GSEABase", "org.Hs.eg.db", "pcaMethods",
          "SingleCellExperiment", "batchelor", 
          "DelayedArray", "DelayedMatrixStats",
          "limma", "SummarizedExperiment", "SingleR",
          "progeny", "RcisTarget", "glmGamPoi",
          "doMC", "doRNG", "DT", "visNetwork", "readr", "pheatmap", "tibble")


for(i in 1:length(pkgs)){
  if(!require(pkgs[i], character.only = T)){
    BiocManager::install(pkgs[i])
    require(pkgs[i], character.only = T)
  }else{
    require(pkgs[i], character.only = T)
  }
}



#####################
# Github packages
#####################

# library("devtools")

# usethis::browse_github_pat()
# usethis::edit_r_environ()
# GITHUB_PAT = "REDACTED"
# R_MAX_VSIZE = 30Gb


# Scillus 
#devtools::install_github("xmc811/Scillus", ref = "development")
#library("Scillus")


#remotes::install_github("mojaveazure/seurat-disk")
library(SeuratDisk)



#####################
# Reproducibility
#####################

# Only run once to initialise 
#renv::init()

# Run snapshot to update renv.lock file 
#renv::snapshot()

# use to restore environment 
#renv::restore()






