
#相关，首先需要每一个细胞类型的表达谱
#HCL细胞表达谱
#exp_anno <- read.table("D:kang/lncSpA2/process/1_data.process/HCL/HCL_exp_fetal_anno_file_names.txt",sep="\t",header=T,stringsAsFactors=F)
#exp_anno[,1] <- gsub("[0-9]$","",exp_anno[,1])
#tissue_num <- data.frame(table(exp_anno[,1]))
library(stringr)
exp_anno = list.files("E:\\lcw\\lncSPA\\xukang\\zhenghe\\exp\\")

tissue_num <- read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")

library(Seurat)
library(dplyr)
input_file <- "E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\"
output <- "E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\each\\"

for (i in 1:dim(tissue_num)[1]) {
  tissue_seurat <- readRDS(paste(input_file,tissue_num$V1[i],"\\\\",tissue_num$V1[i],".rds",sep=""))
  tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  tissue_exp <- tissue_seurat[["RNA"]]@data
  anno_value <- read.table(paste("E:\\lcw\\lncSPA\\xukang\\zhenghe\\cellid_type\\",tissue_num$V1[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  rownames(anno_value) = anno_value$cell_ID
  #rownames(anno_value) = str_c("X",rownames(anno_value),sep = "")

  cell_num <- data.frame(table(anno_value$cell_type))
  cell_num <- cell_num[which(cell_num[,1] != "Unknown"),]
  #cell_num[,1] <- gsub("\\/"," or ",cell_num[,1])
  for (k in 1:nrow(cell_num)) {
    cell_file <- anno_value[which(anno_value$cell_type == as.character(cell_num[k,1])),]
    cell_exp <- tissue_exp[,which(colnames(tissue_exp) %in% rownames(cell_file))]
    write.table(cell_exp,file=paste(output,tissue_num$V1[i],".",gsub("\\/"," or ",as.character(cell_num[k,1])),".cell_num.cells.txt",sep=""),sep="\t",quote=F,row.names=T)
    gc()
  }
}




######这个，是对lncRNA进行筛选（只要了CE lncRNA和CE mRNA）
#对细胞进行筛选
#HCL fetal
#lncRNA
exp_anno <- read.table("D:kang/lncSpA2/process/1_data.process/HCL/HCL_exp_fetal_anno_file_names.txt",sep="\t",header=T,stringsAsFactors=F)
exp_anno[,1] <- gsub("[0-9]$","",exp_anno[,1])
tissue_num <- data.frame(table(exp_anno[,1]))
input_file <- "D:kang/lncSpA2/process/1_data.process/HCL/"
lncRNA_result <- read.table("D:kang/lncSpA2/process/4_database/2_information/HCL_fetal_lncRNA_information.txt",header=T,sep="\t",stringsAsFactors=F)
#tissue <- "Adipose"
library(data.table) 
result <- c()
for (tissue in tissue_num[,1]) {
  tissue_cell_num <- read.table(paste(input_file,"Fetal_",tissue,"/",tissue,".cell_num.cells.txt",sep=""),sep="\t",header=T,stringsAsFactors=F,check.names=F)
  tissue_cell_num1 <- tissue_cell_num[which(tissue_cell_num[,1] %in% unique(lncRNA_result[,1])),]
  tissue_cell_num2 <- data.table::melt(tissue_cell_num1,id="Gene")
  tissue_cell_num2$tissue_type <- rep(tissue,nrow(tissue_cell_num2))
  colnames(tissue_cell_num2) <- c("gene","cell","cell_num_value","tissue_type")
  result <- rbind(result,tissue_cell_num2)
}
HCL_lncRNA_information <- merge(lncRNA_result,result,by=c("gene","cell","tissue_type"),all.x=T)
HCL_lncRNA_information_10 <- HCL_lncRNA_information[which(HCL_lncRNA_information$cell_num_value >= 10),]
write.table(HCL_lncRNA_information,file="D:kang/lncSpA2/process/4_database/2_information/HCL_fetal_lncRNA_information.cell_num.txt",quote=F,sep="\t",row.names=F)
write.table(HCL_lncRNA_information_10,file="D:kang/lncSpA2/process/4_database/2_information/HCL_fetal_lncRNA_information.cell_num_10.txt",quote=F,sep="\t",row.names=F)

#mRNA
exp_anno <- read.table("D:kang/lncSpA2/process/1_data.process/HCL/HCL_exp_fetal_anno_file_names.txt",sep="\t",header=T,stringsAsFactors=F)
exp_anno[,1] <- gsub("[0-9]$","",exp_anno[,1])
tissue_num <- data.frame(table(exp_anno[,1]))
input_file <- "D:kang/lncSpA2/process/1_data.process/HCL/"
mRNA_result <- read.table("D:kang/lncSpA2/process/4_database/2_information/HCL_fetal_mRNA_information.txt",header=T,sep="\t",stringsAsFactors=F)
#tissue <- "Adipose"
library(data.table)
result <- c()
for (tissue in tissue_num[,1]) {
  tissue_cell_num <- read.table(paste(input_file,"Fetal_",tissue,"/",tissue,".cell_num.cells.txt",sep=""),sep="\t",header=T,stringsAsFactors=F,check.names=F)
  tissue_cell_num1 <- tissue_cell_num[which(tissue_cell_num[,1] %in% unique(mRNA_result[,1])),]
  tissue_cell_num2 <- data.table::melt(tissue_cell_num1,id="Gene")
  tissue_cell_num2$tissue_type <- rep(tissue,nrow(tissue_cell_num2))
  colnames(tissue_cell_num2) <- c("gene","cell","cell_num_value","tissue_type")
  result <- rbind(result,tissue_cell_num2)
}
HCL_mRNA_information <- merge(mRNA_result,result,by=c("gene","cell","tissue_type"),all.x=T)
HCL_mRNA_information_10 <- HCL_mRNA_information[which(HCL_mRNA_information$cell_num_value >= 10),]
write.table(HCL_mRNA_information,file="D:kang/lncSpA2/process/4_database/2_information/HCL_fetal_mRNA_information.cell_num.txt",quote=F,sep="\t",row.names=F)
write.table(HCL_mRNA_information_10,file="D:kang/lncSpA2/process/4_database/2_information/HCL_fetal_mRNA_information.cell_num_10.txt",quote=F,sep="\t",row.names=F)











#这个是计算相关性的代码
#相关性计算
library(scLink)
library(dplyr)
library(SAVER)
#得到p值的函数
getP <- function(r, n){
  t1 <- (r * sqrt(n - 2))/sqrt(1 - r^2)
  p <- pt(t1, n-2)
  p <- 2 * pmin(p, 1-p)
}
######矩阵变为四列
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
######矩阵变为三列
flattenCorrMatrix1 <- function(cormat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut]
  )
}

input <- "E:/lcw/lncSPA/xukang/zhenghe/res/2basic_information/"
input_exp <- "E:/lcw/lncSPA/xukang/zhenghe/res/5lncRNA_cor_mRNA.result/each/"
output <- "E:/lcw/lncSPA/xukang/zhenghe/res/5lncRNA_cor_mRNA.result/cor_result/"
lncRNA_result <- read.table(paste(input,"tissue_lncRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
mRNA_result <- read.table(paste(input,"tissue_mRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)

tissue_num <- read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")
#tissue <- "Adrenal-Gland"
#tissue <- "Uterus"
for (i in 9:dim(tissue_num)[1]){
  a1 = Sys.time()
  print(a1)
  print(i)
  lncRNA_tissue <- lncRNA_result[which(lncRNA_result$tissue_type == tissue_num$V2[i]),]
  mRNA_tissue <- mRNA_result[which(mRNA_result$tissue_type == tissue_num$V2[i]),]
  cell_inte_name <- intersect(lncRNA_tissue$cell_type,mRNA_tissue$cell_type)
  cor_normal_result <- c()
  cor_sclink_result <- c()
  cor_saver_result <- c()
  #cell_name <- "Cancer cell"
  for (cell_name in cell_inte_name) {
    cell_name1 <- gsub("\\/"," or ",cell_name)

    cell_exp <- read.table(paste(input_exp,tissue_num$V1[i],".",cell_name1,".cell_num.cells.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
    gc()
    if(ncol(cell_exp)>4){
      lncRNA_cell_exp <- cell_exp[which(rownames(cell_exp) %in% lncRNA_tissue[which(lncRNA_tissue$cell_type == cell_name),1]),]
      mRNA_cell_exp <- cell_exp[which(rownames(cell_exp) %in% mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),]
      cell_exp_sclink <- rbind(lncRNA_cell_exp,mRNA_cell_exp)
      ###一般的cor.test
      cor_r1 <- Hmisc::rcorr(t(cell_exp_sclink),type="pearson")
      cor_result <- flattenCorrMatrix(cor_r1$r,cor_r1$P)
      lncRNA <- data.frame(gene_id=rownames(lncRNA_cell_exp))
      mRNA <- data.frame(gene_id=rownames(mRNA_cell_exp))
      cor_result <- cor_result %>% 
        merge(mRNA,by.x = "column",by.y = "gene_id") %>% 
        merge(lncRNA,by.x="row",by.y = "gene_id")
      cor_result$cancer_type <- rep(tissue_num$V2[i],nrow(cor_result))
      cor_result$classification <- mRNA_tissue[match(cor_result[,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
      cor_result$cell <- rep(cell_name,nrow(cor_result))
      cor_normal_result <- rbind(cor_normal_result,cor_result)
      gc()
    
      ###sclink
      cor_r = sclink_cor(expr = t(cell_exp_sclink), ncores = 1)
      cor_r2 <- flattenCorrMatrix1(cormat=cor_r)
      cor_r2 <- cor_r2 %>% 
        merge(mRNA,by.x = "column",by.y = "gene_id") %>% 
        merge(lncRNA,by.x="row",by.y = "gene_id")
      gte_p <- getP(cor_r2[,3],ncol(lncRNA_cell_exp))###37代表你的数据的列数
      cor_r2$p_value <- gte_p
      cor_r2$cancer_type <- rep(tissue_num$V2[i],nrow(cor_r2))
      cor_r2$classification <- mRNA_tissue[match(cor_r2[,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
      cor_r2$cell <- rep(cell_name,nrow(cor_r2))
      cor_sclink_result <- rbind(cor_sclink_result,cor_r2)
      gc()
    }
  }
  colnames(cor_normal_result) <- c("lncRNA_name","mRNA_name","R","p_value","tissue_type","classification","cell")
  write.table(cor_normal_result,file=paste(output,tissue_num$V1[i],".cell.cor_r_p.txt",sep=""),sep="\t",quote=F,row.names=F)
  colnames(cor_sclink_result) <- c("lncRNA_name","mRNA_name","R","p_value","tissue_type","classification","cell")
  write.table(cor_sclink_result,file=paste(output,tissue_num$V1[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",quote=F,row.names=F)
  a2 = Sys.time()
  print(a2-a1)
  gc()
}





#这个是整理结果的
#########################################
#HCL lncRNA mRNA cor result
#########################################
input <- "E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\cor_result\\"

tissue_num <- read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:dim(tissue_num)[1]) {
  sclink_result <- read.table(paste(input,tissue_num$V1[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
  sclink_result_005 <- sclink_result[which(sclink_result[,4] < 0.05),]
  sclink_result_005_04 <- sclink_result_005[which(abs(sclink_result_005[,3]) > 0.4),]
  sclink_result_005_04$mRNA_ENSG <- mRNA[match(sclink_result_005_04$mRNA_name,mRNA$gene_name),"ensembl_gene_id"]
  sclink_result_005_04$lncRNA_ENSG <- lncRNA_all[match(sclink_result_005_04$lncRNA_name,lncRNA_all$gene_name),"ensembl_gene_id"]
  lncRNA_num <- unique(sclink_result_005_04$lncRNA_ENSG)
  for (j in 1:length(lncRNA_num)) {
    lncRNA_cor_mRNA <- sclink_result_005_04[which(sclink_result_005_04$lncRNA_ENSG == lncRNA_num[j]),]
    mRNA_paste <- apply(lncRNA_cor_mRNA[,c("mRNA_ENSG","mRNA_name","p_value","R","classification","cell")],1,function(x){paste(x,collapse=":")})
    mRNA_paste1 <- paste(mRNA_paste,collapse=";")
    lncRNA_paste <- paste(lncRNA_cor_mRNA[1,"lncRNA_ENSG"],lncRNA_cor_mRNA[1,"lncRNA_name"],sep=";")
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"tissue_type"],lncRNA_paste,mRNA_paste1)))
  }
}


write.table(final_res,file="E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F,append=T)




####23.02.24——————TICA改正服务器运行代码------



#这个是计算相关性的代码
#相关性计算
library(scLink)
library(dplyr)
library(SAVER)
#得到p值的函数
getP <- function(r, n){
  t1 <- (r * sqrt(n - 2))/sqrt(1 - r^2)
  p <- pt(t1, n-2)
  p <- 2 * pmin(p, 1-p)
}
######矩阵变为四列
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
######矩阵变为三列
flattenCorrMatrix1 <- function(cormat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut]
  )
}

input <- "/bioXJ/lcw/lncSPA/new_cor/TICA/basic_information/"
input_exp <- "/bioXJ/lcw/lncSPA/new_cor/TICA/each/"
output <- "/bioXJ/lcw/lncSPA/new_cor/TICA/cor/"
lncRNA_result <- read.table(paste(input,"TICA_lncRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
mRNA_result <- read.table(paste(input,"TICA_mRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)

mRNA_data = read.table("/bioXJ/lcw/lncSPA/protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

tissue_num <- read.table("/bioXJ/lcw/lncSPA/new_cor/TICA/ts.txt",header = F,sep="\t")
#tissue <- "Adrenal-Gland"
#tissue <- "Uterus"
for (i in 9:dim(tissue_num)[1]){
  a1 = Sys.time()
  print(a1)
  print(i)
  lncRNA_tissue <- lncRNA_result[which(lncRNA_result$tissue_type == tissue_num$V2[i]),]
  mRNA_tissue <- mRNA_result[which(mRNA_result$tissue_type == tissue_num$V2[i]),]
  cell_inte_name <- unique(lncRNA_tissue$cell_type)
  cor_normal_result <- c()
  cor_sclink_result <- c()
  cor_saver_result <- c()
  #cell_name <- "Cancer cell"
  for (cell_name in cell_inte_name) {
    cell_name1 <- gsub("\\/"," or ",cell_name)
    
    cell_exp <- read.table(paste(input_exp,tissue_num$V1[i],".",cell_name1,".cell_num.cells.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
    gc()
    if(ncol(cell_exp)>4){
      lncRNA_cell_exp <- cell_exp[which(rownames(cell_exp) %in% lncRNA_tissue[which(lncRNA_tissue$cell_type == cell_name),1]),]
      mRNA_cell_exp <- cell_exp[which(rownames(cell_exp) %in% mRNA_data$gene_name),]
      cell_exp_sclink <- rbind(lncRNA_cell_exp,mRNA_cell_exp)
      ###一般的cor.test
      cor_r1 <- Hmisc::rcorr(t(cell_exp_sclink),type="pearson")
      cor_result <- flattenCorrMatrix(cor_r1$r,cor_r1$P)
      lncRNA <- data.frame(gene_id=rownames(lncRNA_cell_exp))
      mRNA <- data.frame(gene_id=rownames(mRNA_cell_exp))
      
      cor_result <- cor_result[cor_result$row %in% lncRNA$gene_id,]
      cor_result <- cor_result[cor_result$column %in% mRNA$gene_id,]
      
      cor_result = cor_result[is.nan(cor_result$cor) == F,]
      cor_result = cor_result[is.nan(cor_result$p) == F,]
      
      cor_result$cancer_type <- rep(tissue_num$V2[i],nrow(cor_result))
      #cor_result$classification <- mRNA_tissue[match(cor_result[,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
      cor_result$classification = 0
      
      for(k in 1:nrow(cor_result)){
        if(cor_result$column[k] %in% mRNA_tissue$gene){
          cor_result$classification[k] <- mRNA_tissue[match(cor_result[k,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
        }else if(cor_result$column[k] %in% mRNA_tissue$gene == F){cor_result$classification[k] = "non_CE"}
      }
      
      
      
      cor_result$cell <- rep(cell_name,nrow(cor_result))
      cor_normal_result <- rbind(cor_normal_result,cor_result)
      gc()
      
      ###sclink
      cor_r = sclink_cor(expr = t(cell_exp_sclink), ncores = 1)
      cor_r2 <- flattenCorrMatrix1(cormat=cor_r)
      
      cor_r2 <- cor_r2[cor_r2$row %in% lncRNA$gene_id,]
      cor_r2 <- cor_r2[cor_r2$column %in% mRNA$gene_id,]
      
      cor_r2 = cor_r2[is.na(cor_r2$cor) == F,]
      
      gte_p <- getP(cor_r2[,3],ncol(lncRNA_cell_exp))###37代表你的数据的列数
      cor_r2$p_value <- gte_p
      cor_r2$cancer_type <- rep(tissue_num$V2[i],nrow(cor_r2))
      cor_r2$classification = 0
      
      for(k in 1:nrow(cor_r2)){
        if(cor_r2$column[k] %in% mRNA_tissue$gene){
          cor_r2$classification[k] <- mRNA_tissue[match(cor_r2[k,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
        }else if(cor_r2$column[k] %in% mRNA_tissue$gene == F){cor_r2$classification[k] = "non_CE"}
      }
      
      cor_r2$cell <- rep(cell_name,nrow(cor_r2))
      cor_sclink_result <- rbind(cor_sclink_result,cor_r2)
      gc()
    }
  }
  colnames(cor_normal_result) <- c("lncRNA_name","mRNA_name","R","p_value","tissue_type","classification","cell")
  write.table(cor_normal_result,file=paste(output,tissue_num$V1[i],".cell.cor_r_p.txt",sep=""),sep="\t",quote=F,row.names=F)
  colnames(cor_sclink_result) <- c("lncRNA_name","mRNA_name","R","p_value","tissue_type","classification","cell")
  write.table(cor_sclink_result,file=paste(output,tissue_num$V1[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",quote=F,row.names=F)
  a2 = Sys.time()
  print(a2-a1)
  gc()
}

rm(list = ls())
gc()



#这个是整理结果的
#########################################
#HCL lncRNA mRNA cor result
#########################################
input <- "/bioXJ/lcw/lncSPA/new_cor/TICA/cor/"

tissue_num <- read.table("/bioXJ/lcw/lncSPA/new_cor/TICA/ts.txt",header = F,sep="\t")

lncRNA <- read.table("/bioXJ/lcw/lncSPA/lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("/bioXJ/lcw/lncSPA/protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("/bioXJ/lcw/lncSPA/other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
#write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:dim(tissue_num)[1]) {
  sclink_result <- read.table(paste(input,tissue_num$V1[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
  sclink_result_005 <- sclink_result[which(sclink_result[,4] < 0.05),]
  sclink_result_005_04 <- sclink_result_005[which(abs(sclink_result_005[,3]) > 0.4),]
  sclink_result_005_04$mRNA_ENSG <- mRNA[match(sclink_result_005_04$mRNA_name,mRNA$gene_name),"ensembl_gene_id"]
  sclink_result_005_04$lncRNA_ENSG <- lncRNA_all[match(sclink_result_005_04$lncRNA_name,lncRNA_all$gene_name),"ensembl_gene_id"]
  lncRNA_num <- unique(sclink_result_005_04$lncRNA_ENSG)
  for (j in 1:length(lncRNA_num)) {
    lncRNA_cor_mRNA <- sclink_result_005_04[which(sclink_result_005_04$lncRNA_ENSG == lncRNA_num[j]),]
    mRNA_paste <- apply(lncRNA_cor_mRNA[,c("mRNA_ENSG","mRNA_name","p_value","R","classification","cell")],1,function(x){paste(x,collapse=":")})
    mRNA_paste1 <- paste(mRNA_paste,collapse=";")
    lncRNA_paste <- paste(lncRNA_cor_mRNA[1,"lncRNA_ENSG"],lncRNA_cor_mRNA[1,"lncRNA_name"],sep=";")
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"tissue_type"],lncRNA_paste,mRNA_paste1)))
  }
}


write.table(final_res,file="/bioXJ/lcw/lncSPA/new_cor/TICA/lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F,append=T)












