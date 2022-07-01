# Single cell correlation analysis function


# Example pre-processing before function use 

# Set up dataset
#DefaultAssay(reference) <- "SCT"
#reference # 20,957 genes and 161,764 cells 


# dataset is very large, downsample for correlation analysis 

#length(unique(reference@meta.data$celltype.l2)) # 31 cell type annotations

#Idents(reference) <- reference@meta.data$celltype.l2

#downsampled.seurat <- subset(reference, 
#                             downsample = 1500)
# Get data
#normed.data <- as.matrix(downsampled.seurat@assays$SCT@data)



sc.correlation <- function(data.slot, 
                           goi = "NKG7", 
                           remove.quantile = 0.3,
                           output.tables = "output/tables/Correlation_analysis"){
  
  # dataframe from @data slot from a normalised and downsampled seurat object - already downsampled according to ident of interest to a reasonable cell number
  # goi = gene to test correlation against 
  
  
  # Create output directory
  if(!dir.exists(paste0(output.tables))){
    dir.create(paste0(output.tables), 
               recursive = T)
  }
  
  
  # Define correlation functions - adapted from Hoelzel code
  probeCor <- function(x, gp, method = "pearson") {
    em <- x
    prbcor <- apply(em, 1, cor, em[gp,], method = method)
    return(prbcor)
  }
  
  probeCor.test <- function(x, gp, method = "pearson") {
    em <- x
    prbcort <- apply(em, 1, cor.test, em[gp,], method = method)
    return(prbcort)
  } 
  
  

  # Identify lowest X% expressed genes in dataset 
  q.val <- quantile(rowMeans(data.slot), probs = remove.quantile)
  low.exprs <- rowMeans(data.slot) < q.val
  
  # Filter low expressed genes
  filt.data <- data.slot[!low.exprs, ]
  
  # Calculate pearson correlation for all genes vs. NKG7
  cor.res <- probeCor(filt.data, 
                      gp = goi, 
                      method = "pearson")
  
  # Sort correlation values
  cor.res <- as.data.frame(sort(cor.res, 
                                decreasing = TRUE))
  
  colnames(cor.res) <- "Cor.val"
  
  
  # Calculate statistics 
  cor.res.pval <- probeCor.test(filt.data, 
                                gp = goi, 
                                method = "pearson")
  
  cor.res.pval <- unlist(sapply(cor.res.pval, "[", "p.value"))
  
  names(cor.res.pval) <- gsub(".p.value", "", names(cor.res.pval))
  
  cor.res.pval <- as.data.frame(sort(cor.res.pval,
                                     decreasing = FALSE))
  
  colnames(cor.res.pval) <- "P.val"
  
  
  # Combine both pval and correlation statistic 
  cor.df <- merge(cor.res, cor.res.pval, by = "row.names")
  
  colnames(cor.df)[1] <- c("GeneID")
  
  # Calculate FDR adjusted P value
  cor.df$FDR <- p.adjust(cor.df$P.val, method = "fdr")
  
  
  # Write data to file 
  write.csv(cor.df, paste0(output.tables,  "/Correlation_values_", goi, ".csv"))
  
  # return correlation dataframe
  return(cor.df)
  
  
}




# Example pre-processing 


#DefaultAssay(downsampled.seurat) <- "SCT"
#Idents(downsampled.seurat) <- downsampled.seurat@meta.data$celltype.l3

#small.seurat <- subset(downsampled.seurat, 
#                      downsample = 100)

#small.seurat <- ScaleData(small.seurat)


correlation.heatmaps <- function(seurat.object, 
                                 correlation.df, 
                                 up.n = 20, # number of up regulated genes to show
                                 dn.n = 20, # number of downregulated genes to show
                                 goi = "NKG7", 
                                 output.figures = "output/figures/Correlation_analysis"){
  
  
  # Seurat object should be downsampled and idents set to those of interest
  
  # Create output directory
  if(!dir.exists(paste0(output.figures))){
    dir.create(paste0(output.figures), 
               recursive = T)
  }
  
  
# Top upregulated genes 
  up.genes <- correlation.df %>%
    dplyr::filter(FDR < 0.05) %>%
    dplyr::top_n(up.n, Cor.val) %>% 
    dplyr::pull(GeneID)
  
  up.genes <- unique(c(goi, up.genes))
  
  
  print(DoHeatmap(seurat.object, 
            features = up.genes, 
            angle = 90,
            size = 3,
            raster = FALSE))
  
  dev.copy(pdf, paste0(output.figures, "/Heatmap_top", up.n, "_corr_genes.pdf"))
  dev.off()
  
  
  # Top downregulated genes 
  
  dn.genes <- correlation.df %>%
    dplyr::filter(FDR < 0.05) %>%
    dplyr::top_n(-dn.n, Cor.val) %>% 
    dplyr::pull(GeneID)
  
  dn.genes <- unique(c(goi, dn.genes))
  
  # Neg correlated genes
  print(DoHeatmap(small.seurat, 
            features = dn.genes))
            
  dev.copy(pdf, paste0(output.figures, "/Heatmap_bottom", dn.n, "_corr_genes.pdf"))
  dev.off()
  
  
}




