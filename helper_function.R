# effective target predict

#load geneset data
load("R_DATA/target_dn_symbol.Rdata")
load("R_DATA/target_up_symbol.Rdata")
load("R_DATA/target_8233_phi.Rdata")

#geneset enrich calculate
GSEA.EnrichmentScore2 <- function(gene.list, gene.set, weighted.score.type = 1, correl.vector = NULL) {  
  #
  # Computes the weighted GSEA score of gene.set in gene.list. It is the same calculation as in 
  # GSEA.EnrichmentScore but faster (x8) without producing the RES, arg.RES and tag.indicator outputs.
  # This call is intended to be used to asses the enrichment of random permutations rather than the 
  # observed one.
  # The weighted score type is the exponent of the correlation 
  # weight: 0 (unweighted = Kolmogorov-Smirnov), 1 (weighted), and 2 (over-weighted). When the score type is 1 or 2 it is 
  # necessary to input the correlation vector with the values in the same order as in the gene list.
  #
  # Inputs:
  #   gene.list: The ordered gene list (e.g. integers indicating the original position in the input dataset)  
  #   gene.set: A gene set (e.g. integers indicating the location of those genes in the input dataset) 
  #   weighted.score.type: Type of score: weight: 0 (unweighted = Kolmogorov-Smirnov), 1 (weighted), and 2 (over-weighted)  
  #  correl.vector: A vector with the coorelations (e.g. signal to noise scores) corresponding to the genes in the gene list 
  #
  # Outputs:
  #   ES: Enrichment score (real number between -1 and +1) 
  #
  # The Broad Institute
  # SOFTWARE COPYRIGHT NOTICE AGREEMENT
  # This software and its documentation are copyright 2003 by the
  # Broad Institute/Massachusetts Institute of Technology.
  # All rights are reserved.
  #
  # This software is supplied without any warranty or guaranteed support
  # whatsoever. Neither the Broad Institute nor MIT can be responsible for
  # its use, misuse, or functionality.
  
  N <- length(gene.list) 
  Nh <- length(gene.set) 
  Nm <-  N - Nh 
  
  loc.vector <- vector(length=N, mode="numeric")
  peak.res.vector <- vector(length=Nh, mode="numeric")
  valley.res.vector <- vector(length=Nh, mode="numeric")
  tag.correl.vector <- vector(length=Nh, mode="numeric")
  tag.diff.vector <- vector(length=Nh, mode="numeric")
  tag.loc.vector <- vector(length=Nh, mode="numeric")
  
  loc.vector[gene.list] <- seq(1, N)
  tag.loc.vector <- loc.vector[gene.set]
  
  tag.loc.vector <- sort(tag.loc.vector, decreasing = F)
  
  if (weighted.score.type == 0) {
    tag.correl.vector <- rep(1, Nh)
  } else if (weighted.score.type == 1) {
    tag.correl.vector <- correl.vector[tag.loc.vector]
    tag.correl.vector <- abs(tag.correl.vector)
  } else if (weighted.score.type == 2) {
    tag.correl.vector <- correl.vector[tag.loc.vector]*correl.vector[tag.loc.vector]
    tag.correl.vector <- abs(tag.correl.vector)
  } else {
    tag.correl.vector <- correl.vector[tag.loc.vector]**weighted.score.type
    tag.correl.vector <- abs(tag.correl.vector)
  }
  
  norm.tag <- 1.0/sum(tag.correl.vector)
  tag.correl.vector <- tag.correl.vector * norm.tag
  norm.no.tag <- 1.0/Nm
  tag.diff.vector[1] <- (tag.loc.vector[1] - 1) 
  tag.diff.vector[2:Nh] <- tag.loc.vector[2:Nh] - tag.loc.vector[1:(Nh - 1)] - 1
  tag.diff.vector <- tag.diff.vector * norm.no.tag
  peak.res.vector <- cumsum(tag.correl.vector - tag.diff.vector)
  valley.res.vector <- peak.res.vector - tag.correl.vector
  max.ES <- max(peak.res.vector)
  min.ES <- min(valley.res.vector)
  ES <- signif(ifelse(max.ES > - min.ES, max.ES, min.ES), digits=5)
  
  return(list(ES = ES))
}

# target association
fun_target <- function(querydata){
  nsets<- length(target_dn_symbol[,1])
  genenames<- rownames(querydata)
  n_sample <- ncol(querydata)
  A <-apply(querydata, 2,  function(x){order(x,decreasing = TRUE)})  
  TES <- matrix(ncol = n_sample,nrow = nsets)
  
  for(q in 1:nsets){
    up_gene_order <- match(target_up_symbol[q,], genenames)
    up_gene_order <- up_gene_order[!is.na(up_gene_order)]
    dw_gene_order <- match(target_dn_symbol[q,], genenames)
    dw_gene_order <- dw_gene_order[!is.na(dw_gene_order)]
    for (p in 1:n_sample) {
      gene.list2 <- A[,p]
      upES <- unlist(GSEA.EnrichmentScore2(gene.list = gene.list2, gene.set = up_gene_order, weighted.score.type = 0))
      downES <- unlist(GSEA.EnrichmentScore2(gene.list = gene.list2, gene.set = dw_gene_order, weighted.score.type = 0))
      TES[q,p] <- upES - downES
    }
  }
  exist_set <- !is.na(TES[,1])
  query.rowname <- rownames(target_dn_symbol)[exist_set]
  TES <- matrix(TES[exist_set,],ncol = n_sample)
  
  ###2、计算random TESvalue
  target_phi <- target_phi
  phi <- target_phi[exist_set,]
  nsets1 <- length(phi[,1])
  ###3、计算 p value  
  pvalue <- matrix(nrow = nsets1,ncol = n_sample)
  for(i in 1:n_sample){
    for (j in 1:nsets1) {
      pvalue[j,i] <- ifelse(TES[j,i] >= 0, sum(phi[j,] >= TES[j,i])/sum(phi[j,]>=0), 
                            sum(phi[j,] < TES[j,i])/sum(phi[j,]<0))
    } 
  }
  ###3、计算NESvalue and fdr value
  # 
  phi.pos.mean <- apply(phi,1,function(x){
    mean(x[x>=0])
  })
  phi.neg.mean <- apply(phi,1,function(x){
    mean(abs(x[x<0]))
  })
  
  phi.norm.pos <- phi
  phi.norm.pos[phi<0]<-0
  phi.norm.pos <-phi.norm.pos/phi.pos.mean
  phi.norm.neg <- phi
  phi.norm.neg[phi>=0]<-0
  phi.norm.neg <-phi.norm.neg/phi.neg.mean
  phi.norm <- phi
  phi.norm[phi<0] <- phi.norm.neg[phi<0]
  phi.norm[phi>=0] <- phi.norm.pos[phi>=0]
  #r#r#r#r#r#r#r#r#r#r#r#r#r#r
  ES_query <- TES
  ES_query.pos <- ES_query
  ES_query.pos[ES_query<0]<-0
  ES_query.pos <-ES_query.pos/phi.pos.mean
  ES_query.neg <- ES_query
  ES_query.neg[ES_query>=0]<-0
  ES_query.neg <-ES_query.neg/phi.neg.mean
  
  ES_query.norm <- ES_query
  ES_query.norm[ES_query<0] <- ES_query.neg[ES_query<0]
  ES_query.norm[ES_query>=0] <- ES_query.pos[ES_query>=0]
  
  FDRvalue <- matrix(nrow = nsets1,ncol = n_sample)
  
  for(i in 1:n_sample){
    for (j in 1:nsets1) {
      if(ES_query.norm[j,i] >= 0){
        A <- sum(phi.norm >= ES_query.norm[j,i])/sum(phi.norm>=0)
        B <- sum(ES_query.norm >= ES_query.norm[j,i])/sum(ES_query.norm>=0)
        FDRvalue[j,i] <- A/B 
      }
      else{
        A <- sum(phi.norm <= ES_query.norm[j,i])/sum(phi.norm<0)
        B <- sum(ES_query.norm <= ES_query.norm[j,i])/sum(ES_query.norm<0)
        FDRvalue[j,i] <- A/B
      } 
    }                   
  }
  
  query_target_gsea <- cbind(data.frame(query.rowname),TES,ES_query.norm, pvalue, FDRvalue)
  rownames(query_target_gsea) <- query.rowname
  colnames(query_target_gsea) <- c("Target name",paste(rep(colnames(querydata),times=4),rep(c("_ETS","_NETS","_Pvalue","_FDR"),each=n_sample),sep = ""))
  gc()
  return(list(query_target_gsea=query_target_gsea))
}
