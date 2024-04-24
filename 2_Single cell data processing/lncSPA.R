library(Seurat)
library(stringr)
lncRNA <- read.table("D:\\01\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("D:\\01\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("D:\\01\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
cellanno <- read.table("D:\\01\\data\\cell_anno.txt",header=T,sep="\t",stringsAsFactors=F)#细胞类型文件-----------------------------------
cellanno01 <- read.table("D:\\01\\data\\cellanno01.txt",header=T,sep="\t",stringsAsFactors=F)#细胞类型文件-----------------------------------

memory.limit(100000000)
#setwd("D:\\01\\data\\TISCH2")
#listfiles <- list.files()
#listfiles = str_sub(listfiles,1,-5)

setwd("D:\\01\\result\\fenlei1")
listfiles <- list.files(pattern="*celltype_geneclass.txt$")
listfiles = str_sub(listfiles,1,-25)

setwd("D:\\computer language\\R\\script")

#############piliangchuli---------------------
for(j in 29:length(listfiles)){
    dir = str_c("D:\\01\\data\\TISCH2\\",listfiles[j],".rds",sep = "")
    cancer_seurat = readRDS(dir)#读取数据
    cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
    temp = cancer_seurat@meta.data#细胞类型信息
    cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
    
    
    for(m in 1:dim(cell_type)[1]){
        for(n in 1:dim(cellanno)[1]){
            if(cell_type$cell[m] == cellanno$X1[n]){
                cell_type$cell[m] = cellanno$X3[n]
            }
        }
    }
    rm(m,n)
    gc()
    
    for(m in 1:dim(cell_type)[1]){
        for(n in 1:dim(cellanno01)[1]){
            if(cell_type$cell[m] == cellanno01$X2[n]){
                cell_type$cell[m] = cellanno01$X1[n]
            }
        }
    }
    gc()
    
    cancer_exp = cancer_seurat[["RNA"]]@data#提取表达数据
    
    table_temp = as.data.frame(table(cell_type$cell))#记录共有多少种细胞
    
    result = rownames(cancer_exp)
    gc()
    ##计算同一种细胞均值
    for(i in 1:dim(table_temp)[1]){
        cell_exp = cancer_exp[,colnames(cancer_exp) %in% rownames(cell_type[(cell_type$cell == table_temp$Var1[i]),])]
        cell_values <- rowMeans(cell_exp)#apply(as.data.frame(cell_exp),1,mean)#
        result <- cbind(result,cell_values)
        colnames(result)[i+1] = as.character(table_temp$Var1[i])
    }
    
    result = result[,-1]
    result = as.data.frame(result)
    mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
    lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
    pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]
    
    CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
    for(i in 1:dim(result)[1]){
        cell_max = max(as.numeric(result[i,]))
        max_cell = colnames(result)[which.max(result[i,])]
        tt = result[i,-(which.max(result[i,]))]
        remain_max = max(as.numeric(tt))
        remain_mean = mean(as.numeric(tt))
        cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
        CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
    }
    CS_CER_CEH_all = CS_CER_CEH_all[-1,]
    rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
    #CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
    final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
    for(i in 1:dim(CS_CER_CEH_all)[1]){
        if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
            if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
                if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
                    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
                        tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                                           remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                                           cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
                        final_result_CS = rbind(final_result_CS,tempf)
                    }
                }
            } 
        }
        else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
            if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
                if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
                    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
                        tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                                           remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                                           cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
                        final_result_CS = rbind(final_result_CS,tempf)
                    }
                }
            } 
        }
        else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
            if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
                if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
                    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
                        tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                                           remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                                           cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
                        final_result_CS = rbind(final_result_CS,tempf)
                    }
                }
            } 
        }
    }
    final_result_CS = final_result_CS[-1,]
    
    remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
    #CER 在该细胞中的表达大于其他最大值的五倍
    final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
    for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
        if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
            if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
                if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
                    tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                                       remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                                       cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
                    final_result_CER = rbind(final_result_CER,tempf)
                }
            } 
        }
        else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
            if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
                if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
                    tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                                       remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                                       cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
                    final_result_CER = rbind(final_result_CER,tempf)
                }
            } 
        }
        else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
            if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
                if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
                    tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                                       remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                                       cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
                    final_result_CER = rbind(final_result_CER,tempf)
                }
            } 
        }
    }
    final_result_CER = final_result_CER[-1,]
    
    remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
    #CEH 在该细胞中的表达大于其他均值的五倍
    final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
    result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
    for(i in 1:dim(result_CEH)[1]){
        if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
            if(max(as.numeric(result_CEH[i,]))>0.01){
                tt = as.data.frame(result_CEH[i,])
                cell_mean = ""
                remain_data = ""
                remain_mean = ""
                cell_type = ""
                for(m in 1:dim(result_CEH)[2]){
                  if(as.numeric(tt[1,m])>0.01){
                    if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
                        cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
                        remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
                        remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
                        cell_type = str_c(cell_type,",",colnames(tt)[m])
                    }
                }
                }
                tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                                   remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                                   cell_type = cell_type,gene_type = "mRNA")
                final_result_CEH = rbind(final_result_CEH,tempf)
            }
        }
        else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
            if(max(as.numeric(result_CEH[i,]))>0.001){
                tt = as.data.frame(result_CEH[i,])
                cell_mean = ""
                remain_data = ""
                remain_mean = ""
                cell_type = ""
                for(m in 1:dim(result_CEH)[2]){
                    if(as.numeric(tt[1,m])>0.001){
                        if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
                            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
                            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
                            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
                            cell_type = str_c(cell_type,",",colnames(tt)[m])
                        }
                    }
                }
                tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                                   remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                                   cell_type = cell_type,gene_type = "lncRNA")
                final_result_CEH = rbind(final_result_CEH,tempf)
            }
        }
        else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
            if(max(as.numeric(result_CEH[i,]))>0.001){
                tt = as.data.frame(result_CEH[i,])
                cell_mean = ""
                remain_data = ""
                remain_mean = ""
                cell_type = ""
                for(m in 1:dim(result_CEH)[2]){
                    if(as.numeric(tt[1,m])>0.001){
                        if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
                            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
                            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
                            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
                            cell_type = str_c(cell_type,",",colnames(tt)[m])
                        }
                    }
                }
                tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                                   remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                                   cell_type = cell_type,gene_type = "pseudogene")
                final_result_CEH = rbind(final_result_CEH,tempf)
            }
        }
    }
    final_result_CEH = final_result_CEH[-1,]
    
    tt1 = c()
    for(i in 1:dim(final_result_CEH)[1]){
        if(final_result_CEH$cell_exp[i]==""){
            tt1 = c(tt1,i)
        }
    }
    final_result_CEH = final_result_CEH[-tt1,]
    final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
    final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
    final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
    final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)
    

    final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)
    celltype_geneclass = data.frame(cell = table_temp$Var1,CS = 0,CER = 0,CEH = 0)
    rownames(celltype_geneclass) = celltype_geneclass$cell
    
    cs = as.data.frame(table(final_result_CS$cell_type))
    rownames(cs) = cs$Var1
    cer = as.data.frame(table(final_result_CER$cell_type))
    rownames(cer) = cer$Var1
    ceh = as.data.frame(table(final_result_CEH$cell_type))
    rownames(ceh) = ceh$Var1
    
    for(i in 1:dim(celltype_geneclass)[1]){
        if(rownames(celltype_geneclass)[i] %in% rownames(cs)){celltype_geneclass[i,2] = cs[rownames(celltype_geneclass)[i],2]}
        if(rownames(celltype_geneclass)[i] %in% rownames(cer)){celltype_geneclass[i,3] = cer[rownames(celltype_geneclass)[i],2]}
        if(rownames(celltype_geneclass)[i] %in% rownames(ceh)){celltype_geneclass[i,4] = ceh[rownames(celltype_geneclass)[i],2]}
    }

    
    write.table(celltype_geneclass,file = str_c("D:\\01\\result\\fenlei2\\",listfiles[j],"__celltype_geneclass",".txt",sep = ""),
                row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
    
    dir2 = str_c("D:\\01\\result\\fenlei2\\",listfiles[j],".txt",sep = "")
    
    write.table(final_result,dir2,row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
    
    rm(tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,cell_type,
       cancer_exp,cancer_seurat,cell_exp,temp,ceh,cer,cs,celltype_geneclass,CS_CER_CEH_all,cstemp,lncRNA_exp,
       mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
       cell_values,dir,dir2,i,m,max_cell,cell_max,table_temp,result,result_CEH)
    gc()
}






#####细胞类型表达谱----
setwd("D:\\01\\data\\TISCH2")
listfiles <- list.files()
listfiles = str_sub(listfiles,1,-5)
setwd("D:\\computer language\\R\\script")
cell_anno = read.table("D:\\01\\data\\cell_anno.txt",header=T,sep="\t",stringsAsFactors=F)

for(j in 29:length(listfiles)){
dir = str_c("D:\\01\\data\\TISCH2\\",listfiles[j],".rds",sep = "")
cancer_seurat = readRDS(dir)#读取数据
cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
temp = cancer_seurat@meta.data#细胞类型信息
cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型


cellanno = read.table("E:/lcw/lncSPA/TISCH/GSE116256_AML/cellann.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellanno)[1] = "cell_ID"
cellanno$cell_ID = str_replace_all(cellanno$cell_ID,"-",".")
#将细胞类型统一
cell_type = merge(cell_type,cellanno,by = "cell_ID",all = T)
rownames(cell_type) = cell_type$cell_ID


cancer_exp = aa[["RNA"]]@data#提取表达数据


table_temp = as.data.frame(table(cell_type$cell_type))#记录共有多少种细胞
table_temp$Var1 = as.character(table_temp$Var1)

result = rownames(cancer_exp)
gc()
##计算同一种细胞均值
for(i in 1:dim(table_temp)[1]){
    cell_exp = cancer_exp[,colnames(cancer_exp) %in% rownames(cell_type[(cell_type$cell_type == table_temp$Var1[i]),])]
    #cell_exp = as.data.frame(cell_exp)
    cell_values <- rowMeans(cell_exp)
    result <- cbind(result,cell_values)
    colnames(result)[i+1] = as.character(table_temp$Var1[i])
}
write.table(result,"E:/lcw/lncSPA/zhenghe/exp/GSE116256_AML_2.txt",sep="\t",quote=F,row.names=F,col.names = T)

rm(result,cancer_exp,cancer_seurat)
gc()
}







library(Seurat)
library(dplyr)
library(stringr)

setwd("D:\\01\\result\\fenlei")
listfiles <- list.files(pattern="*celltype_geneclass.txt$")
listfiles = str_sub(listfiles,1,-25)

#setwd("D:\\01\\result\\HCL")
#for(i in 1:length(listfiles)){dir.create(listfiles[i])}

for(i in 41:length(listfiles)){
    setwd(paste("D:\\01\\result\\HCL\\",listfiles[i],"\\",sep=""))
    dir = str_c("D:\\01\\data\\TISCH2\\",listfiles[i],".rds",sep = "")
    tissue_seurat = readRDS(dir)#读取数据
    tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
    #temp = tissue_seurat@meta.data#细胞类型信息
    #cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
    #cancer_exp = tissue_seurat[["RNA"]]@data#提取表达数据
    
    #rm(tissue_seurat)
    #gc()
    
    #table_temp = as.data.frame(table(cell_type$cell))#记录共有多少种细胞
    
    #result = rownames(cancer_exp)
    #gc()
    ##计算同一种细胞均值
    #for(i in 1:dim(table_temp)[1]){
    #cell_exp = cancer_exp[,colnames(cancer_exp) %in% rownames(cell_type[(cell_type$cell == table_temp$Var1[i]),])]
    #cell_values <- rowMeans(cell_exp)
    #result <- cbind(result,cell_values)
    #colnames(result)[i+1] = as.character(table_temp$Var1[i])
    #}
    
    #write.table(result,file = str_c("D:\\01\\result\\exp\\",listfiles[j],".txt",sep = ""),sep="\t",quote=F,row.names=F)
    #4. 找Variable基因
    tissue_seurat = FindVariableFeatures(tissue_seurat, selection.method = "vst", nfeatures = 2000)
    gc()
    #5. scale表达矩阵
    tissue_seurat <- ScaleData(tissue_seurat, features = rownames(tissue_seurat))
    #6. 降维聚类
    #（基于前面得到的high variable基因的scale矩阵）
    tissue_seurat <- RunPCA(tissue_seurat, npcs = 50, verbose = FALSE)
    pdf(file = as.character(paste(listfiles[i],".VizDimLoadings.pdf",sep="")))
    p <- VizDimLoadings(tissue_seurat, dims = 1:2, reduction = "pca")
    print(p)
    dev.off()
    
    pdf(paste(listfiles[i],".DimPlot.pdf",sep=""))
    p <- DimPlot(tissue_seurat, reduction = "pca")
    print(p)
    dev.off()
    ##########
    pdf(paste(listfiles[i],".DimHeatmap.pdf",sep=""))
    p =  DimHeatmap(tissue_seurat, dims = 1, cells = 500, balanced = TRUE)
    print(p)
    dev.off()
    #7.定义数据集维度
    #NOTE: This process can take a long time for big datasets, comment out for expediency. 
    #More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
    tissue_seurat <- JackStraw(tissue_seurat, num.replicate = 100)
    gc()
    tissue_seurat <- ScoreJackStraw(tissue_seurat, dims = 1:20)
    
    pdf(paste(listfiles[i],".JackStrawPlot.pdf",sep=""))
    p <- JackStrawPlot(tissue_seurat, dims = 1:15)
    print(p)
    dev.off()
    
    pdf(paste(listfiles[i],".ElbowPlot.pdf",sep=""))
    p <- ElbowPlot(tissue_seurat,ndims = 50)
    print(p)
    dev.off()
    #8.细胞分类
    tissue_seurat <- FindNeighbors(tissue_seurat, dims = 1:10)
    gc()
    tissue_seurat <- FindClusters(tissue_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))
    
    #用已知的细胞类型代替分类的细胞类型
    temp = tissue_seurat@meta.data
    
    #tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
    Idents(object=tissue_seurat) <- tissue_seurat@meta.data$Celltype..major.lineage.
    #9.可视化分类结果
    #UMAP
    tissue_seurat <- RunUMAP(tissue_seurat, dims = 1:10, label = T)
    gc()
    #head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
    write.table(tissue_seurat@reductions$umap@cell.embeddings,file=paste(listfiles[i],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
    #note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
    p1 <- DimPlot(tissue_seurat, reduction = "umap")
    #T-SNE
    tissue_seurat <- RunTSNE(tissue_seurat, dims = 1:10)#报错，改为不检查重复
    gc()
    #head(tissue_seurat@reductions$tsne@cell.embeddings)
    write.table(tissue_seurat@reductions$tsne@cell.embeddings,file=paste(listfiles[i],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
    p2 <- DimPlot(tissue_seurat, reduction = "tsne")
    pdf(paste(listfiles[i],".umap.tsne.pdf",sep=""),width = 15, height = 8)
    print(p1 + p2)
    dev.off()
    saveRDS(tissue_seurat, file = paste(listfiles[i],".rds",sep=""))  #保存数据，用于后续个性化分析
    gc()
    #10.提取各细胞类型的marker gene
    #find all markers of cluster 1
    #cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
    #利用 DoHeatmap 命令可以可视化marker基因的表达
    tissue_seurat.markers <- FindAllMarkers(tissue_seurat, only.pos = TRUE, min.pct = 0.25)
    gc()
    top3 <- tissue_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
    pdf(paste(listfiles[i],".DoHeatmap.pdf",sep=""))
    p <- DoHeatmap(tissue_seurat, features = top3$gene) + NoLegend()
    print(p)
    dev.off()
    pdf(paste(listfiles[i],".umap.DimPlot.pdf",sep=""))
    p <- DimPlot(tissue_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
    print(p)
    dev.off()
    pdf(paste(listfiles[i],".tsne.DimPlot.pdf",sep=""))
    p <- DimPlot(tissue_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
    print(p)
    dev.off()
    rm(p,p1,p2,temp,tissue_seurat,tissue_seurat.markers,top3)
    gc()
}


library(Seurat)
library(dplyr)
library(stringr)


cellanno <- read.table("D:\\01\\data\\cell_anno.txt",header=T,sep="\t",stringsAsFactors=F)#细胞类型

setwd("D:\\01\\result\\fenlei")
listfiles <- list.files(pattern="*celltype_geneclass.txt$")
listfiles = str_sub(listfiles,1,-25)

#setwd("D:\\01\\result\\HCL_new")
#for(i in 1:length(listfiles)){dir.create(listfiles[i])}

for(i in 1:length(listfiles)){
    setwd(paste("D:\\01\\result\\HCL_new\\",listfiles[i],"\\",sep=""))
    dir = str_c("D:\\01\\data\\TISCH2\\",listfiles[i],".rds",sep = "")
    tissue_seurat = readRDS(dir)#读取数据
    
    for(m in 1:length(tissue_seurat@meta.data$Celltype..major.lineage.)){
        for(n in 1:dim(cellanno)[1]){
            if(length(tissue_seurat@meta.data$Celltype..major.lineage.[m] == cellanno$X1[n])){
                tissue_seurat@meta.data$Celltype..major.lineage.[m] = cellanno$X3[n]
            }
        }
    }
    
    tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
    #temp = tissue_seurat@meta.data#细胞类型信息
    #cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
    #cancer_exp = tissue_seurat[["RNA"]]@data#提取表达数据
    
    #rm(tissue_seurat)
    #gc()
    
    #table_temp = as.data.frame(table(cell_type$cell))#记录共有多少种细胞
    
    #result = rownames(cancer_exp)
    #gc()
    ##计算同一种细胞均值
    #for(i in 1:dim(table_temp)[1]){
    #cell_exp = cancer_exp[,colnames(cancer_exp) %in% rownames(cell_type[(cell_type$cell == table_temp$Var1[i]),])]
    #cell_values <- rowMeans(cell_exp)
    #result <- cbind(result,cell_values)
    #colnames(result)[i+1] = as.character(table_temp$Var1[i])
    #}
    
    #write.table(result,file = str_c("D:\\01\\result\\exp\\",listfiles[j],".txt",sep = ""),sep="\t",quote=F,row.names=F)
    #4. 找Variable基因
    tissue_seurat = FindVariableFeatures(tissue_seurat, selection.method = "vst", nfeatures = 2000)
    gc()
    #5. scale表达矩阵
    tissue_seurat <- ScaleData(tissue_seurat, features = rownames(tissue_seurat))
    #6. 降维聚类
    #（基于前面得到的high variable基因的scale矩阵）
    tissue_seurat <- RunPCA(tissue_seurat, npcs = 50, verbose = FALSE)
    pdf(file = as.character(paste(listfiles[i],".VizDimLoadings.pdf",sep="")))
    p <- VizDimLoadings(tissue_seurat, dims = 1:2, reduction = "pca")
    print(p)
    dev.off()
    
    pdf(paste(listfiles[i],".DimPlot.pdf",sep=""))
    p <- DimPlot(tissue_seurat, reduction = "pca")
    print(p)
    dev.off()
    ##########
    pdf(paste(listfiles[i],".DimHeatmap.pdf",sep=""))
    p =  DimHeatmap(tissue_seurat, dims = 1, cells = 500, balanced = TRUE)
    print(p)
    dev.off()
    #7.定义数据集维度
    #NOTE: This process can take a long time for big datasets, comment out for expediency. 
    #More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
    tissue_seurat <- JackStraw(tissue_seurat, num.replicate = 100)
    gc()
    tissue_seurat <- ScoreJackStraw(tissue_seurat, dims = 1:20)
    
    pdf(paste(listfiles[i],".JackStrawPlot.pdf",sep=""))
    p <- JackStrawPlot(tissue_seurat, dims = 1:15)
    print(p)
    dev.off()
    
    pdf(paste(listfiles[i],".ElbowPlot.pdf",sep=""))
    p <- ElbowPlot(tissue_seurat,ndims = 50)
    print(p)
    dev.off()
    #8.细胞分类
    tissue_seurat <- FindNeighbors(tissue_seurat, dims = 1:10)
    gc()
    tissue_seurat <- FindClusters(tissue_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))
    
    #用已知的细胞类型代替分类的细胞类型
    temp = tissue_seurat@meta.data
    
    #tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
    Idents(object=tissue_seurat) <- tissue_seurat@meta.data$Celltype..major.lineage.
    #9.可视化分类结果
    #UMAP
    tissue_seurat <- RunUMAP(tissue_seurat, dims = 1:10, label = T)
    gc()
    #head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
    write.table(tissue_seurat@reductions$umap@cell.embeddings,file=paste(listfiles[i],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
    #note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
    p1 <- DimPlot(tissue_seurat, reduction = "umap")
    #T-SNE
    tissue_seurat <- RunTSNE(tissue_seurat, dims = 1:10)#报错，改为不检查重复
    gc()
    #head(tissue_seurat@reductions$tsne@cell.embeddings)
    write.table(tissue_seurat@reductions$tsne@cell.embeddings,file=paste(listfiles[i],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
    p2 <- DimPlot(tissue_seurat, reduction = "tsne")
    pdf(paste(listfiles[i],".umap.tsne.pdf",sep=""),width = 15, height = 8)
    print(p1 + p2)
    dev.off()
    saveRDS(tissue_seurat, file = paste(listfiles[i],".rds",sep=""))  #保存数据，用于后续个性化分析
    gc()
    #10.提取各细胞类型的marker gene
    #find all markers of cluster 1
    #cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
    #利用 DoHeatmap 命令可以可视化marker基因的表达
    tissue_seurat.markers <- FindAllMarkers(tissue_seurat, only.pos = TRUE, min.pct = 0.25)
    gc()
    top3 <- tissue_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
    pdf(paste(listfiles[i],".DoHeatmap.pdf",sep=""))
    p <- DoHeatmap(tissue_seurat, features = top3$gene) + NoLegend()
    print(p)
    dev.off()
    pdf(paste(listfiles[i],".umap.DimPlot.pdf",sep=""))
    p <- DimPlot(tissue_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
    print(p)
    dev.off()
    pdf(paste(listfiles[i],".tsne.DimPlot.pdf",sep=""))
    p <- DimPlot(tissue_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
    print(p)
    dev.off()
    rm(p,p1,p2,temp,tissue_seurat,tissue_seurat.markers,top3)
    gc()
}









rm(tissue_seurat)    
gc()

setwd("D:\\computer language\\R\\script")

library(Seurat)
library(dplyr)
library(stringr) 
memory.limit(10000000000)

untreat = c("BCC_GSE123813_QC","CLL_GSE125881_QC","NSCLC_GSE131907_QC")          

listfiles = setdiff(listfiles,untreat)

temp = ""


setwd(paste("D:\\01\\result\\HCL\\",temp,"\\",sep=""))
dir = str_c("D:\\01\\data\\TISCH2\\",temp,".rds",sep = "")
tissue_seurat = readRDS(dir)#读取数据
tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
gc()
#temp = tissue_seurat@meta.data#细胞类型信息
#cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
#cancer_exp = tissue_seurat[["RNA"]]@data#提取表达数据

#rm(tissue_seurat)
#gc()

#table_temp = as.data.frame(table(cell_type$cell))#记录共有多少种细胞

#result = rownames(cancer_exp)
#gc()
##计算同一种细胞均值
#for(i in 1:dim(table_temp)[1]){
#cell_exp = cancer_exp[,colnames(cancer_exp) %in% rownames(cell_type[(cell_type$cell == table_temp$Var1[i]),])]
#cell_values <- rowMeans(cell_exp)
#result <- cbind(result,cell_values)
#colnames(result)[i+1] = as.character(table_temp$Var1[i])
#}

#write.table(result,file = str_c("D:\\01\\result\\exp\\",listfiles[j],".txt",sep = ""),sep="\t",quote=F,row.names=F)
#4. 找Variable基因
tissue_seurat = FindVariableFeatures(tissue_seurat, selection.method = "vst", nfeatures = 2000)
gc()
#5. scale表达矩阵
tissue_seurat <- ScaleData(tissue_seurat, features = rownames(tissue_seurat))
gc()
#6. 降维聚类
#（基于前面得到的high variable基因的scale矩阵）
tissue_seurat <- RunPCA(tissue_seurat, npcs = 50, verbose = FALSE)
gc()
pdf(file = as.character(paste(temp,".VizDimLoadings.pdf",sep="")))
p <- VizDimLoadings(tissue_seurat, dims = 1:2, reduction = "pca")
print(p)
dev.off()

gc()
pdf(paste(temp,".DimPlot.pdf",sep=""))
p <- DimPlot(tissue_seurat, reduction = "pca")
print(p)
dev.off()
gc()
##########
pdf(paste(temp,".DimHeatmap.pdf",sep=""))
p =  DimHeatmap(tissue_seurat, dims = 1, cells = 500, balanced = TRUE)
print(p)
dev.off()
gc()
#7.定义数据集维度
#NOTE: This process can take a long time for big datasets, comment out for expediency. 
#More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
tissue_seurat <- JackStraw(tissue_seurat, num.replicate = 100)
gc()
tissue_seurat <- ScoreJackStraw(tissue_seurat, dims = 1:20)
gc()
pdf(paste(temp,".JackStrawPlot.pdf",sep=""))
p <- JackStrawPlot(tissue_seurat, dims = 1:15)
print(p)
dev.off()

gc()
pdf(paste(temp,".ElbowPlot.pdf",sep=""))
p <- ElbowPlot(tissue_seurat,ndims = 50)
print(p)
dev.off()
gc()
#8.细胞分类
tissue_seurat <- FindNeighbors(tissue_seurat, dims = 1:10)
gc()
tissue_seurat <- FindClusters(tissue_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))
gc()
#用已知的细胞类型代替分类的细胞类型

#tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
Idents(object=tissue_seurat) <- tissue_seurat@meta.data$Celltype..major.lineage.
gc()
#9.可视化分类结果
#UMAP
tissue_seurat <- RunUMAP(tissue_seurat, dims = 1:10, label = T)
gc()
#head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
write.table(tissue_seurat@reductions$umap@cell.embeddings,file=paste(temp,".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
#note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
p1 <- DimPlot(tissue_seurat, reduction = "umap")
#T-SNE
tissue_seurat <- RunTSNE(tissue_seurat, dims = 1:10,perplexity = 1)#报错，改为不检查重复,perplexity = 1
gc()
#head(tissue_seurat@reductions$tsne@cell.embeddings)
write.table(tissue_seurat@reductions$tsne@cell.embeddings,file=paste(temp,".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
p2 <- DimPlot(tissue_seurat, reduction = "tsne")
pdf(paste(temp,".umap.tsne.pdf",sep=""),width = 15, height = 8)
print(p1 + p2)
dev.off()
saveRDS(tissue_seurat, file = paste(temp,".rds",sep=""))  #保存数据，用于后续个性化分析
gc()
#10.提取各细胞类型的marker gene
#find all markers of cluster 1
#cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
#利用 DoHeatmap 命令可以可视化marker基因的表达
tissue_seurat.markers <- FindAllMarkers(tissue_seurat, only.pos = TRUE, min.pct = 0.25)
gc()
top3 <- tissue_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
pdf(paste(temp,".DoHeatmap.pdf",sep=""))
p <- DoHeatmap(tissue_seurat, features = top3$gene) + NoLegend()
print(p)
dev.off()
gc()
pdf(paste(temp,".umap.DimPlot.pdf",sep=""))
p <- DimPlot(tissue_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
print(p)
dev.off()
gc()
pdf(paste(temp,".tsne.DimPlot.pdf",sep=""))
p <- DimPlot(tissue_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
print(p)
dev.off()
rm(p,p1,p2,tissue_seurat,tissue_seurat.markers,top3)
gc()


setwd("D:\\computer language\\R\\script")

#############################################################整理finaldataframe-------------

library(Seurat)
library(dplyr)
library(stringr) 
memory.limit(10000000000)

f = function(x){
    aa = paste(as.character(x),collapse = ",")
    return(aa)
}

cellanno <- read.table("D:\\01\\data\\cell_anno.txt",header=T,sep="\t",stringsAsFactors=F)#细胞类型文件-----------------------------------

setwd("D:\\01\\result\\fenlei")
listfiles <- list.files(pattern="*celltype_geneclass.txt$")
listfiles = str_sub(listfiles,1,-25)

untreat = c("BCC_GSE123813_QC","CLL_GSE125881_QC","NSCLC_GSE131907_QC","SKCM_GSE123139_QC")          
listfiles = setdiff(listfiles,untreat)


for(i in 2:length(listfiles)){
    tissue_seurat = readRDS(str_c("D:\\01\\data\\TISCH2\\",listfiles[i],".rds",sep = ""))#RDS文件--------------------------------
    gc()
    tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
    gc()
    temp = tissue_seurat@meta.data#细胞类型信息
    
    cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
    #统一细胞类型
    for(m in 1:dim(cell_type)[1]){
        for(n in 1:dim(cellanno)[1]){
            if(cell_type$cell[m] == cellanno$X1[n]){
                cell_type$cell[m] = cellanno$X3[n]
            }
        }
    }
    
    
    
    table_temp = as.data.frame(table(cell_type$cell))
    
    cell_type01 = data.frame()
    celltype = c()
    for(j in 1:dim(table_temp)[1]){
        temp01 = cell_type[cell_type$cell == table_temp$Var1[j],]
        temp01 = temp01[str_order(temp01$cell_ID),]
        cell_type01 = rbind(cell_type01,temp01)
        temp01 = as.data.frame(t(temp01))
        celltype = c(celltype,paste(as.character(temp01[1,]),collapse = ","))
        
    }
    
    tsne = read.table(str_c("D:\\01\\result\\HCL_new\\",listfiles[i],"\\",listfiles[i],".tsne.cell.embeddings.txt",sep = ""),
                      header=T,sep="\t",stringsAsFactors=F)##tsne坐标------------------------------------------------------------
    tsne = tsne[rownames(cell_type01),]#按排序一一对应
    
    tissue_exp = tissue_seurat[["RNA"]]@data#提取表达数据
    tissue_exp = tissue_exp[,rownames(cell_type01)]#按排序一一对应
    
    
    cell_type01 = as.data.frame(t(cell_type01))
    
    tsne = as.data.frame(t(tsne))
    gc()
    
    res = as.data.frame(matrix(0,nrow = dim(tissue_exp)[1]+4,ncol = 1))
    rownames(res) = c("cell_name","cell_type",rownames(tsne),rownames(tissue_exp))
    colnames(res) = listfiles[i]
    res[1,1] = paste(as.character(cell_type01[2,]),collapse = ",")
    res[2,1] = paste(celltype,collapse = ";")
    res[3,1] = paste(as.character(tsne[1,]),collapse = ",")
    res[4,1] = paste(as.character(tsne[2,]),collapse = ",")
    
    bb = apply(tissue_exp,1,f)
    gc()
    res[5:dim(res)[1],1] = bb
    
    write.table(res,file=str_c("D:\\01\\result\\final_dataframe1\\",listfiles[i],".txt"),
                sep="\t",quote=F,row.names=T)####输出文件位置-----------------------------------------------
    rm(cell_type,res,temp,tissue_exp,tissue_seurat,tsne,bb,m,n,celltype,cell_type01,temp01,table_temp)
    gc()
    
}





setwd("D:\\computer language\\R\\script")

gc()

library(xlsx)
aa = read.xlsx("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\cell_type.xlsx",sheetIndex = 2)
bb = read.xlsx("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tissue.xlsx",sheetIndex = 1)

cc = aa[,c(1,3)]
colnames(cc) = c("cancer","system")

write.table(cc,"D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\cancer_system.txt",sep="\t",quote=F,row.names=F)

############三个文件找最大值--------------------------------------------------

library(stringr)
infcon <- file("D:\\01\\data\\geo_detail.txt", open="rt")   ##打开文件的读写入口，称为连接对象
batch <- 1000   ##设置每批要读入的行数

data = data.frame()

lines <- readLines(infcon, batch)   ##分批读入

temp01 = str_split(lines[1],pattern = "\t")
temp01 = as.data.frame(temp01)
temp01 = t(temp01)
rownames(temp01) = temp01[1,1]

data = rbind(data,temp01)

for(i in 6:length(lines)){
    temp01 = str_split(lines[i],pattern = "\t")
    temp01 = as.data.frame(temp01)
    temp01 = t(temp01)
    rownames(temp01) = temp01[1,1]
    for(m in 2:dim(temp01)[2]){
        if(as.character(temp01[1,m]) != "NONE"){
            temp02 = str_split(temp01[1,m],pattern = ",")[[1]]
            temp02 = as.numeric(temp02)
            temp02<-temp02[-which(is.na(temp02))]
            temp01[1,m] = max(as.numeric(temp02))
        }
    }
    data = rbind(data,temp01) 
}

while(TRUE){ 
    lines <- readLines(infcon, batch)   ##分批读入
    if(length(lines)==0) break  ##没有新的读入内容时终止
    for(i in 1:length(lines)){
        temp01 = str_split(lines[i],pattern = "\t")
        temp01 = as.data.frame(temp01)
        temp01 = t(temp01)
        rownames(temp01) = temp01[1,1]
        for(m in 2:dim(temp01)[2]){
            if(as.character(temp01[1,m]) != "NONE"){
                temp02 = str_split(temp01[1,m],pattern = ",")[[1]]
                temp02 = as.numeric(temp02)
                temp02<-temp02[-which(is.na(temp02))]
                temp01[1,m] = max(as.numeric(temp02))
            }
            
        }
        data = rbind(data,temp01)
    }
    gc()
}

close(infcon)  ##关闭file()函数产生的infcon连接


write.table(data,file = "D:\\01\\result\\geo_data.txt",sep="\t",quote=F,row.names=F)





########统计数据-----------------------------------------

aa = data.frame(a = c(11,22,55,88,66,33,55,44),b=c(45,98,63,22,55,33,77,52),c = c(01,12,5,6,3,5,7,3))
write.table(aa,file = "D:\\01\\result\\cell_number.txt",sep="\t",quote=F,row.names=F)




library(stringr)
data = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\TISCH_lncRNA_information.txt",header=T,sep="\t",stringsAsFactors=F)
data$tissue_type = str_sub(data$tissue_type,1,-4)
data$aa = data$tissue_type
data$aa = sub("_",",",data$aa)
for(i in 1:dim(data)[1]){
    data$tissue[i]=str_split(data$aa[i],",")[[1]][1]
    data$sequence[i]=str_split(data$aa[i],",")[[1]][2] 
}

write.table(data,file = "D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\TISCH_lncRNA_information_1.txt",sep="\t",quote=F,row.names=F)



setwd("D:\\01\\result\\fenlei")
listfiles <- list.files(pattern="*celltype_geneclass.txt$")
listfiles = str_sub(listfiles,1,-25)

setwd("D:\\computer language\\R\\script")

setwd("D:\\01\\process\\")
for(i in 1:length(listfiles)){dir.create(listfiles[i])}

for(i in 1:length(listfiles)){
    setwd(str_c("D:\\01\\process\\",listfiles[i],sep = ""))
    dir.create(listfiles[i])
}


##2022/06/29
cell_research = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\cell_research_lncRNA_information.txt",
                           header=T,sep="\t",stringsAsFactors=F)
HCL_lncRNA = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\HCL_lncRNA_information_new.txt",
                        header=T,sep="\t",stringsAsFactors=F)
TISCH_lncRNA = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\TISCH_lncRNA_information.txt",
                          header=T,sep="\t",stringsAsFactors=F)
ce_cs = data.frame(cell_research = c(0,0,0),HCL = c(0,0,0),TISCH = c(0,0,0))
rownames(ce_cs) = c("CS","CER","CEH")

cell = as.data.frame(table(cell_research$class))
HCL = as.data.frame(table(HCL_lncRNA$class))
TISCH = as.data.frame(table(TISCH_lncRNA$class))
rownames(ce_cs) = cell$Var1
ce_cs$cell_research = cell$Freq
ce_cs$HCL = HCL$Freq
ce_cs$TISCH = TISCH$Freq
write.table(ce_cs,file = "D:\\01\\result\\tongji\\all_cecs.txt",sep="\t",quote=F,row.names=T)

###组织中
data = TISCH_lncRNA
tissue = as.data.frame(table(data$tissue_type))

tissue_cecs =matrix(0,nrow = 3,ncol = dim(tissue)[1])
tissue_cecs = as.data.frame(tissue_cecs)
rownames(tissue_cecs) = c("CEH","CER","CS")

for(i in 1:length(tissue$Var1)){
    temp1 = data[data$tissue_type == as.character(tissue$Var1)[i],]
    temp2 = as.data.frame(table(temp1$class))
    
    for(j in 1:dim(temp2)[1]){
        tissue_cecs[as.character(temp2$Var1[j]),i] = temp2$Freq[j]
    }
    colnames(tissue_cecs)[i] = as.character(tissue$Var1)[i]
}

cell_tissue_cecs = tissue_cecs

HCL_tissue_cecs = tissue_cecs
TISCH_tissue_cecs = tissue_cecs

write.table(cell_tissue_cecs,file = "D:\\01\\result\\tongji\\cell_tissue_cecs.txt",sep="\t",quote=F,row.names=T)
write.table(HCL_tissue_cecs,file = "D:\\01\\result\\tongji\\HCL_tissue_cecs.txt",sep="\t",quote=F,row.names=T)
write.table(TISCH_tissue_cecs,file = "D:\\01\\result\\tongji\\TISCH_tissue_cecs.txt",sep="\t",quote=F,row.names=T)

#####改动
cell_tissue_cecs = read.table("D:\\01\\result\\tongji\\TISCH_tissue_cecs.txt",
                              header=T,sep="\t",stringsAsFactors=F)

tissue = colnames(cell_tissue_cecs)
for(i in 1:length(tissue)){
    tissue[i] = str_c("'",tissue[i],"'",sep = "")
}

zuzhi = c()
for(i in 1:length(tissue)){
    zuzhi = str_c(zuzhi,tissue[i],",")
}
zuzhi = str_sub(zuzhi,1,-2)

cell_tissue_cecs_1 = data.frame(TISCH = c(0,0,0,0))
rownames(cell_tissue_cecs_1) = c("tissue",rownames(cell_tissue_cecs))
cell_tissue_cecs_1[1,1] = zuzhi

for(i in 1:dim(cell_tissue_cecs)[1]){
    temp = c()
    for(j in 1:dim(cell_tissue_cecs)[2]){
        temp = str_c(temp,as.character(cell_tissue_cecs[i,j]),",")
    }
    temp = str_sub(temp,1,-2)
    cell_tissue_cecs_1[i+1,1] = temp
}

write.table(cell_tissue_cecs_1,file = "D:\\01\\result\\tongji\\TISCH_tissue_cecs_1.txt",sep="\t",quote=F,row.names=T)

#################染色体

data = cell_research
tissue = as.data.frame(table(data$seqnames))

tissue_cecs =matrix(0,nrow = 3,ncol = dim(tissue)[1])
tissue_cecs = as.data.frame(tissue_cecs)
rownames(tissue_cecs) = c("CEH","CER","CS")

for(i in 1:length(tissue$Var1)){
    temp1 = data[data$seqnames == as.character(tissue$Var1)[i],]
    temp2 = as.data.frame(table(temp1$class))
    
    for(j in 1:dim(temp2)[1]){
        tissue_cecs[as.character(temp2$Var1[j]),i] = temp2$Freq[j]
    }
    colnames(tissue_cecs)[i] = as.character(tissue$Var1)[i]
}

cell_seqnames_cecs = tissue_cecs
HCL_seqnames_cecs = tissue_cecs
TISCH_seqnames_cecs = tissue_cecs


write.table(cell_seqnames_cecs,file = "D:\\01\\result\\tongji\\cell_seqnames_cecs.txt",sep="\t",quote=F,row.names=T)
write.table(HCL_seqnames_cecs,file = "D:\\01\\result\\tongji\\HCL_seqnames_cecs.txt",sep="\t",quote=F,row.names=T)
write.table(TISCH_seqnames_cecs,file = "D:\\01\\result\\tongji\\TISCH_seqnames_cecs.txt",sep="\t",quote=F,row.names=T)

#统计mRNA、lncRNA数量-----------
library(Seurat)
library(stringr)

lncRNA <- read.table("D:\\01\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("D:\\01\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("D:\\01\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),]

lncRNA = union(other_RNA$gene_name,lncRNA$gene_name)
mRNA = mRNA$gene_name

aa = read.table("D:\\01\\result\\tongji\\TISCH_tissue_cecs.txt",header=T,sep="\t",stringsAsFactors=F)
list1 = colnames(aa)

TISCH_lncRNA = c()
TISCH_mRNA = c()

for(i in 1:length(list1)){
    exp = read.table(str_c("D:\\01\\result\\exp\\",list1[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
    lncRNA_temp = exp[exp$result %in% lncRNA,]
    mRNA_temp = exp[exp$result %in% mRNA,]
    TISCH_lncRNA = union(TISCH_lncRNA,lncRNA_temp$result)
    TISCH_mRNA = union(TISCH_mRNA,mRNA_temp$result)
}

TISCH_lncRNA = as.data.frame(TISCH_lncRNA)
TISCH_mRNA = as.data.frame(TISCH_mRNA)

write.table(TISCH_lncRNA,file = "D:\\01\\result\\tongji\\TISCH_lncRNA.txt",sep="\t",quote=F,row.names=T)
write.table(TISCH_mRNA,file = "D:\\01\\result\\tongji\\TISCH_mRNA.txt",sep="\t",quote=F,row.names=T)



cell_lncRNA = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\5_cell_research_lncRNA.txt",
                         header=T,sep="\t",stringsAsFactors=F)
cell_mRNA = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\5_cell_research_mRNA.txt",
                       header=T,sep="\t",stringsAsFactors=F)
HCL_lncRNA = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\5_HCL_lncRNA.txt",
                        header=T,sep="\t",stringsAsFactors=F)
HCL_mRNA = read.table("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\tsne坐标\\5_HCL_mRNA.txt",
                      header=T,sep="\t",stringsAsFactors=F)

all_lncRNA = union(TISCH_lncRNA$TISCH_lncRNA,cell_lncRNA$x)
all_lncRNA = union(all_lncRNA,HCL_lncRNA$x)



all_mRNA = union(TISCH_mRNA$TISCH_mRNA,cell_mRNA$x)
all_mRNA = union(all_mRNA,HCL_mRNA$x)


write.table(all_lncRNA,file = "D:\\01\\result\\tongji\\all_lncRNA.txt",sep="\t",quote=F,row.names=T)
write.table(all_mRNA,file = "D:\\01\\result\\tongji\\all_mRNA.txt",sep="\t",quote=F,row.names=T)




#################################火山图--------------------
library(ggplot2)
######读入数据-------------------------
diff = read.csv("D:\\360MoveData\\Users\\鲸落万物生\\Desktop\\差异基因1.csv",header = T)
rownames(diff) = as.vector(diff$X)
######标签因子化--------------------------
diff$result = factor(diff$result,levels = c("up","down","not"),order = T)

data = data.frame(P = diff$log_p.value,FC = diff$FC,res = diff$result)
rownames(data) = as.vector(diff$X)
######画图---------------------
P_volcano = ggplot(data,aes(x = FC,y = P))+
  geom_point(aes(color = res))+
  
  #设置点的颜色
  scale_color_manual(values = c("up" = "red", "down" = "blue", "not" = "grey"))+
  labs(x="FC",y="logP")+
  
  #增加阈值线:分别对应log P=0.05,|log2FC|=1
  geom_hline(yintercept=-log10(0.05),linetype=4)+
  geom_vline(xintercept=c(-1,1),linetype=4)

P_volcano

# 初步处理所有原始数据--------




cellanno <- read.table("E:\\lcw\\lncSPA\\data\\cell_anno.txt",header=T,sep="\t",stringsAsFactors=F)#细胞类型文件-----------------------------------
cellanno01 <- read.table("E:\\lcw\\lncSPA\\data\\cellanno01.txt",header=T,sep="\t",stringsAsFactors=F)#细胞类型文件-----------------------------------

cellanno = cellanno[,-2]

data = read.csv("E:\\lcw\\lncSPA\\filter_data\\GSE115978_melanoma\\GSE115978_cell.annotations.csv")

data = read.table("C:\\Users\\DELL\\Desktop\\新建文本文档.txt",header=T,sep="\t",stringsAsFactors=F)

data = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE141982_glioma\\cellAnnotations.txt",header=T,sep="\t",stringsAsFactors=F)

data = read.xlsx("E:\\lcw\\lncSPA\\filter_data\\GSE118056_Merkel cell carcinoma\\GSE118056_umap.xlsx")


write.table(temp,file = "E:\\lcw\\lncSPA\\result\\cell_type.txt",sep="\t",quote=F,row.names=F)



file = "GSE125449_liver cancer"

data = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE123813_BCC_Cancer-skin\\bcc_scRNA_counts.txt",header=T,sep="\t",stringsAsFactors=F)

data = Matrix::readMM("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_matrix.mtx")

data = read.csv("E:\\lcw\\lncSPA\\filter_data\\GSE117988_Merkel cell carcinoma\\GSE117988_raw.expMatrix_PBMC.csv")
data_tumor = read.csv("E:\\lcw\\lncSPA\\filter_data\\GSE117988_Merkel cell carcinoma\\GSE117988_raw.expMatrix_Tumor.csv")

#data = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE134520_Early Gastric Cancer\\expdata_GSE134520_Early Gastric Cancer.txt",header=T,sep="\t",stringsAsFactors=F)

#data = read.xlsx("E:\\lcw\\lncSPA\\filter_data\\GSE123813_BCC_Cancer-skin\\bcc_all_metadata.xlsx")

gene = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_genes.tsv")

barcodes = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_barcodes.tsv")

rownames(data) = data$X
data = data[,-1]

cell_gene = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_samples.txt",header=T,sep="\t",stringsAsFactors=F)


aa = cell_gene %>% distinct(test, .keep_all = TRUE)
aa$test = str_replace(aa$test,"-",".")
View(aa)
rownames(aa) = aa$test
cell_gene = aa

#cell_gene$cell_id = str_sub(cell_gene$cell_id,1,-3)
rownames(cell_gene) = cell_gene[,2]


rownames(data) = gene$V2
colnames(data) = barcodes$V1


saveRDS(data, "E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_matrix.Rds")


data1 = readRDS("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_matrix.Rds")

data1 = readRDS("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set1_matrix.Rds")
data2 = readRDS("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_matrix.Rds")

gene1 = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set1_genes.tsv")
gene2 = read.table("E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\GSE125449_Set2_genes.tsv")

data = merge(data1,data2)


data1 = NormalizeData(object = data1, normalization.method = "LogNormalize", scale.factor = 10000)
data2 = NormalizeData(object = data2, normalization.method = "LogNormalize", scale.factor = 10000)


















library(openxlsx)
library(stringr)
library(Matrix)
library(Seurat)
library(dplyr)
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件


celltype = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")

setwd("E:\\lcw\\lncSPA\\orignal_data\\")
listfile1 = list.files()
listfile1 = listfile1[1:15]


setwd("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\")
listfile2 = list.files()

#GSE72056_melanoma------------------------------------
data = read.table("E:\\lcw\\lncSPA\\orignal_data\\GSE72056_melanoma\\GSE72056_melanoma_single_cell_revised_v2.txt",header=T,sep="\t",stringsAsFactors=F)
data = data[-1,]
data_mean=aggregate(.~Cell,mean,data=data)#表达谱里相同的基因取均值

rownames(data_mean) = data_mean$Cell
data_mean = data_mean[,-1]


tissue_seurat <- CreateSeuratObject(counts = data.matrix(data_mean),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)
tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = tissue_seurat[["RNA"]]@data#提取表达数据

cellann = data.frame(cell = colnames(data),cell_type = t(data[1,]))
colnames(cellann) = c("cell","cell_type")
cellann = cellann[-1,]

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell





#GSE75688_breast cancer------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE75688_breast cancer\\")

data = read.table("GSE75688_GEO_processed_Breast_Cancer_raw_TPM_matrix.txt",header=T,sep="\t",stringsAsFactors=F)
cellann = read.xlsx("GSE75688_umap.xlsx")
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

data = data[,-1]
data = data[,-2]

data_mean=aggregate(.~gene_name,mean,data=data)#表达谱里相同的基因取均值
rownames(data_mean) = data_mean$gene_name
data_mean = data_mean[,-1]

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data_mean),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = tissue_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

#GSE84465_GBM------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE84465_GBM\\")

data = read.csv("GSE84465_GBM_All_data.csv",sep = " ")

cellann = read.xlsx("GSE84465_GBM_umap.xlsx")
cellann$cell_id = str_c("X",cellann$cell_id,sep = "")

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

tissue_seurat <- CreateSeuratObject(counts = data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = tissue_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

#GSE103322_HNSCC----------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE103322_HNSCC\\")

data = read.table("GSE103322_HNSCC_all_data.txt",header=T,sep="\t",stringsAsFactors=F)
cellann = read.table("GSE103322_HNSCC_metafile.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellann)[6] = "cell_type"

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")
data = data[-c(1,2,3,4,5),]

rownames(data) = data$X
data = data[,-1]

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = tissue_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}




cell_gene = cellann
rownames(cell_gene) = cell_gene$cell

#GSE115978_melanoma--------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE115978_melanoma\\")

data = read.csv("GSE115978_counts.csv")
cellann = read.csv("GSE115978_cell.annotations.csv")
colnames(cellann)[3] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")


rownames(data) = data$X
data = data[,-1]

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = tissue_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cells

#GSE116256_AML------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE116256_AML\\")
listfile = list.files(pattern = "dem")
data = read.table(listfile[1],header=T,sep="\t",stringsAsFactors=F)
for(i in 2:length(listfile)){
  data_temp = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  data = merge(data, data_temp, by = 'Gene',all.x = TRUE, all.y = T)
}
rownames(data) = data$Gene
data = data[,-1]

cellann = read.table("D:\\Desktop\\cellanno.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(cellann$celltype))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")
tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

write.table(tabletemp,"D:\\Desktop\\tabletemp.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tabletemp = read.table("D:\\Desktop\\tabletemp.txt",header=T,sep="\t",stringsAsFactors=F)

colnames(cellann)[2] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

write.table(cellann,"D:\\Desktop\\cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)


cell_gene = cellann
rownames(cell_gene) = cell_gene$cells

#GSE117988_Merkel cell carcinoma-----------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE117988_Merkel cell carcinoma\\")

data_PBMC = read.csv("GSE117988_raw.expMatrix_PBMC.csv")
colnames(data_PBMC)[2:12875] = str_c(colnames(data_PBMC)[2:12875],".p",sep = "")

data_tumor = read.csv("GSE117988_raw.expMatrix_Tumor.csv")
colnames(data_tumor)[2:7432] = str_c(colnames(data_tumor)[2:7432],".t",sep = "")

data = merge(data_PBMC, data_tumor, by = 'X',all.x = TRUE, all.y = T)
data[is.na(data)] = 0
rownames(data) = data$X
data = data[,-1]

cellann = read.xlsx("GSE117988_umap.xlsx")
cellann$cell_id = str_sub(cellann$cell_id,1,-3)
cellann$cell_id = str_replace(cellann$cell_id,"-",".")
cellann$cell_id[str_detect(cellann$cell_sample,"PBMC")] = str_c(cellann$cell_id[str_detect(cellann$cell_sample,"PBMC")],".p",sep = "")
cellann$cell_id[str_detect(cellann$cell_sample,"Tumor")] = str_c(cellann$cell_id[str_detect(cellann$cell_sample,"Tumor")],".t",sep = "")

colnames(cellann)[4] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

#write.table(cellann,"D:\\Desktop\\cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id


#GSE118056_Merkel cell carcinoma---------------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE118056_Merkel cell carcinoma\\")

data = read.csv("GSE118056_raw.expMatrix.csv")
rownames(data) = data$X
data = data[,-1]

cellann = read.xlsx("GSE118056_umap.xlsx")

colnames(cellann)[4] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

#########GSE123813_BCC_Cancer-skin--------------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE123813_BCC_Cancer-skin\\")

data = read.table("bcc_scRNA_counts.txt",header=T,sep="\t",stringsAsFactors=F,row.names = 1)

rownames(data) = data$X
data = data[,-1]

cellann = read.csv("bcc_all_metadata.csv")

colnames(cellann)[5] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

write.table(cellann,"D:\\Desktop\\cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

data_mean=aggregate(.~genes,mean,data=data)

rownames(data) = data[,1]
data = data[,-1]

#GSE125449_liver cancer------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE125449_liver cancer\\")
data1 = Read10X("set1")
data2 = Read10X("set2")

tissue_seurat1 = CreateSeuratObject(counts = data1,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat2 = CreateSeuratObject(counts = data2,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat = merge(tissue_seurat1,tissue_seurat2)

sample1 = read.table("GSE125449_Set1_samples.txt",header=T,sep="\t",stringsAsFactors=F)
sample2 = read.table("GSE125449_Set2_samples.txt",header=T,sep="\t",stringsAsFactors=F)

sample = rbind(sample1,sample2)

colnames(sample)[3] = "cell_type"
tabletemp = as.data.frame(table(sample$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")


tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

temp = tissue_seurat@meta.data#细胞类型信息


data = tissue_seurat[["RNA"]]@data#提取表达数据


for(m in 1:dim(sample)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(sample$cell_type[m] == tabletemp$Var1[n]){##
      sample$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


cell_gene = sample
rownames(cell_gene) = cell_gene$Cell.Barcode

#########GSE131907_Lung_Cancer----------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE131907_Lung_Cancer\\")

tissue_seurat = readRDS("GSE131907_Lung_Cancer_normalized_log2TPM_matrix.rds")
tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cellann = read.table("cellann.txt.txt",header=T,sep="\t",stringsAsFactors=F)

colnames(cellann)[5] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

write.table(cellann,"D:\\Desktop\\cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#GSE134520_Early Gastric Cancer细胞类型只有两种----------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE134520_Early Gastric Cancer\\")

cellann = read.table("cellAnnotations.txt",header=F,sep="\t",stringsAsFactors=F)
colnames(cellann)[2] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))





#GSE141982_glioma-------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE141982_glioma\\")

cellann = read.table("cellAnnotations.txt",header=F,sep="\t",stringsAsFactors=F)
colnames(cellann)[2] = "cell_type"
cellann$V1 = str_replace(cellann$V1,"-",".")

tabletemp = as.data.frame(table(cellann$cell_type))
tabletemp$cell = c("Astrocyte","Endothelial cell","Macrophage","Neutrophil")



data = read.table("expdata_GSE141982-glioma.txt",header=T,sep="\t",stringsAsFactors=F)
tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$V1

#GSE145137_bladder_cancer--------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE145137_bladder_cancer\\")
data = read.table("GSM4307111_GEO_processed_BC159-T_3_log2TPM_matrix_final.txt",header=T,sep="\t",stringsAsFactors=F)
rownames(data) = data$gene
data = data[,-1]

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cellann = read.xlsx("GSE145137_umap.xlsx")
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

#GSE146771_colon_cancer---------------------------------------------
setwd("E:\\lcw\\lncSPA\\orignal_data\\GSE146771_colon_cancer\\")

data = read.table("CRC.Leukocyte.Smart-seq2.TPM.txt",header=T,sep=" ",stringsAsFactors=F)

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)


cellann = read.table("CRC.Leukocyte.Smart-seq2.Metadata.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellann)[15] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")
for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$CellName


#######TISCH_own------------------
library(rhdf5)
library(hdf5r)
library(readr)
library(Seurat)
library(stringr)



setwd("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\")
listfile = list.files()


cellanno = data.frame()

for(i in 1:length(listfile)){
  setwd(str_c("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\",listfile[i],sep = ""))
  listfile1 = list.files(pattern = ".tsv")
  data = read_tsv(listfile1)
  aa = as.data.frame(table(data$`Celltype (major-lineage)`))
  cellanno = rbind(cellanno,aa)
}

tabletemp = as.data.frame(table(cellann$Var1))

write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")
tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")









#####
setwd("D:/R/script")
tabc = c()

setwd("E:\\lcw\\lncSPA\\data\\TISCH2\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)

for(i in 1:length(listfile)){
  dir.create(listfile[i])
}

setwd(str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\",listfile[k],sep = ""))




for(k in 1:length(listfile)){
  
  listfile1 = list.files(pattern = ".h5")
  listfile2 = list.files(pattern = ".tsv")
  
  cellann = read_tsv(listfile2)
  colnames(cellann)[5] = "cell_type"
  
  for(m in 1:dim(cellann)[1]){
    for(n in 1:dim(tabletemp)[1]){
      if(cellann$cell_type[m] == tabletemp$Var1[n]){##
        cellann$cell_type[m] = tabletemp$cell[n]##
      }
    }
  }
  
  cell_gene = as.data.frame(cellann)
  rownames(cell_gene) = cell_gene$Cell
  
  
  h5 = Read10X_h5(listfile1)
  
  tissue_seurat <- CreateSeuratObject(counts = h5,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)
  
  tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  data = tissue_seurat[["RNA"]]@data#提取表达数据
  
  table_temp = as.data.frame(table(cell_gene$cell_type))##
  
  if(dim(table_temp)[1]>=3){
    
    result = rownames(data)
    
    #rownames(cell_gene) = str_replace(rownames(cell_gene),"-",".")
    
    for(i in 1:dim(table_temp)[1]){
      cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
      cell_values = apply(as.data.frame(cell_exp),1,mean)#cell_values <- rowMeans(cell_exp)#
      result <- cbind(result,cell_values)
      colnames(result)[i+1] = as.character(table_temp$Var1[i])
    }
    write.table(result,str_c("E:\\lcw\\lncSPA\\zhenghe\\exp\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
    result = result[,-1]
    result = as.data.frame(result)
    mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
    lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
    pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]
    
    
    CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
    for(i in 1:dim(result)[1]){
      cell_max = max(as.numeric(result[i,]))
      max_cell = colnames(result)[which.max(result[i,])]
      tt = result[i,-(which.max(result[i,]))]
      remain_max = max(as.numeric(tt))
      remain_mean = mean(as.numeric(tt))
      cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
      CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
    }
    CS_CER_CEH_all = CS_CER_CEH_all[-1,]
    rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
    #CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
    final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
    for(i in 1:dim(CS_CER_CEH_all)[1]){
      if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
          if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
            if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
              tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                                 remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                                 cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
              final_result_CS = rbind(final_result_CS,tempf)
            }
          }
        } 
      }
      else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
          if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
            if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
              tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                                 remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                                 cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
              final_result_CS = rbind(final_result_CS,tempf)
            }
          }
        } 
      }
      else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
          if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
            if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
              tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                                 remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                                 cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
              final_result_CS = rbind(final_result_CS,tempf)
            }
          }
        } 
      }
    }
    final_result_CS = final_result_CS[-1,]
    
    remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
    #CER 在该细胞中的表达大于其他最大值的五倍
    final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
    for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
      if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
          if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                               remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                               cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
            final_result_CER = rbind(final_result_CER,tempf)
          }
        } 
      }
      else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
          if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                               remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                               cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
            final_result_CER = rbind(final_result_CER,tempf)
          }
        } 
      }
      else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
          if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                               remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                               cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
            final_result_CER = rbind(final_result_CER,tempf)
          }
        } 
      }
    }
    final_result_CER = final_result_CER[-1,]
    
    remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
    #CEH 在该细胞中的表达大于其他均值的五倍
    final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
    result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
    for(i in 1:dim(result_CEH)[1]){
      if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
        if(max(as.numeric(result_CEH[i,]))>0.01){
          tt = as.data.frame(result_CEH[i,])
          cell_mean = ""
          remain_data = ""
          remain_mean = ""
          cell_type = ""
          for(m in 1:dim(result_CEH)[2]){
            if(as.numeric(tt[1,m])>0.01){
              if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
                cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
                remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
                remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
                cell_type = str_c(cell_type,",",colnames(tt)[m])
              }
            }
          }
          tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                             remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                             cell_type = cell_type,gene_type = "mRNA")
          final_result_CEH = rbind(final_result_CEH,tempf)
        }
      }
      else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
        if(max(as.numeric(result_CEH[i,]))>0.001){
          tt = as.data.frame(result_CEH[i,])
          cell_mean = ""
          remain_data = ""
          remain_mean = ""
          cell_type = ""
          for(m in 1:dim(result_CEH)[2]){
            if(as.numeric(tt[1,m])>0.001){
              if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
                cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
                remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
                remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
                cell_type = str_c(cell_type,",",colnames(tt)[m])
              }
            }
          }
          tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                             remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                             cell_type = cell_type,gene_type = "lncRNA")
          final_result_CEH = rbind(final_result_CEH,tempf)
        }
      }
      else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
        if(max(as.numeric(result_CEH[i,]))>0.001){
          tt = as.data.frame(result_CEH[i,])
          cell_mean = ""
          remain_data = ""
          remain_mean = ""
          cell_type = ""
          for(m in 1:dim(result_CEH)[2]){
            if(as.numeric(tt[1,m])>0.001){
              if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
                cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
                remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
                remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
                cell_type = str_c(cell_type,",",colnames(tt)[m])
              }
            }
          }
          tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                             remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                             cell_type = cell_type,gene_type = "pseudogene")
          
          final_result_CEH = rbind(final_result_CEH,tempf)
        }
      }
    }
    final_result_CEH = final_result_CEH[-1,]
    
    tt1 = c()
    for(i in 1:dim(final_result_CEH)[1]){
      if(final_result_CEH$cell_exp[i]==""){
        tt1 = c(tt1,i)
      }
    }
    final_result_CEH = final_result_CEH[-tt1,]
    final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
    final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
    final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
    final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)
    
    ttceh = data.frame()
    for(i in 1:dim(final_result_CEH)[1]){
      
      if(str_detect(final_result_CEH$cell_exp[i],",")){
        tt1 = final_result_CEH[i,]
        for(j in 1:length(strsplit(tt1$cell_exp[1],",")[[1]])){
          t_temp = data.frame(gene = tt1$gene[1],cell_exp = strsplit(tt1$cell_exp[1],",")[[1]][j],
                              remain_max = strsplit(tt1$remain_max[1],",")[[1]][j],
                              remain_mean = strsplit(tt1$remain_mean[1],",")[[1]][j],class = tt1$class[1],
                              cell_type = strsplit(tt1$cell_type[1],",")[[1]][j],gene_type = tt1$gene_type[1])
          ttceh = rbind(ttceh,t_temp)
        }
      }
    }
    
    final_result_CEH = rbind(final_result_CEH,ttceh)
    
    
    
    tt1 = c()
    for(i in 1:dim(final_result_CEH)[1]){
      if(str_detect(final_result_CEH$cell_exp[i],",")){
        tt1 = c(tt1,i)
      }
    }
    
    if(length(tt1) >0){final_result_CEH = final_result_CEH[-tt1,]}
    
    
    
    
    
    
    
    final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)
    celltype_geneclass = data.frame(cell = table_temp$Var1,CS = 0,CER = 0,CEH = 0)
    rownames(celltype_geneclass) = celltype_geneclass$cell
    
    cs = as.data.frame(table(final_result_CS$cell_type))
    rownames(cs) = cs$Var1
    cer = as.data.frame(table(final_result_CER$cell_type))
    rownames(cer) = cer$Var1
    ceh = as.data.frame(table(final_result_CEH$cell_type))
    rownames(ceh) = ceh$Var1
    
    for(i in 1:dim(celltype_geneclass)[1]){
      if(rownames(celltype_geneclass)[i] %in% rownames(cs)){celltype_geneclass[i,2] = cs[rownames(celltype_geneclass)[i],2]}
      if(rownames(celltype_geneclass)[i] %in% rownames(cer)){celltype_geneclass[i,3] = cer[rownames(celltype_geneclass)[i],2]}
      if(rownames(celltype_geneclass)[i] %in% rownames(ceh)){celltype_geneclass[i,4] = ceh[rownames(celltype_geneclass)[i],2]}
    }
    
    
    
    
    
    
    final_result$cell_num_value = 0
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for(i in 1:dim(final_result)[1]){
      
      temp = data[final_result$gene[i],colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == final_result$cell_type[i]),])]##
      
      final_result$cell_num_value[i] = sum(temp!=0)
    }
    
    final_result_10 = final_result[final_result$cell_num_value>=10,]
    
    
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    write.table(final_result,str_c("E:\\lcw\\lncSPA\\orignal_data\\1final_res\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
    write.table(final_result_10,str_c("E:\\lcw\\lncSPA\\zhenghe\\final_res_10\\",listfile[k],"_10.txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
    tabc = c(tabc,listfile[k])
  }
  
  
  rm(tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,cell_type,cellann,h5,
     cell_exp,temp,ceh,cer,cs,celltype_geneclass,CS_CER_CEH_all,cstemp,lncRNA_exp,
     mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
     cell_values,max_cell,cell_max,table_temp,result,result_CEH,n,m,final_result_10,ttceh,tissue_seurat,data,cell_gene)
  gc()
  
  setwd("D:/R/script")
  
  
  
  
  
  
}





####
cell_gene = cell_gene[-which(cell_gene$cell_type=="?"),]


table_temp = as.data.frame(table(cell_gene$cell_type))##

table_temp = table_temp[-which(table_temp$Freq<10),]


result = rownames(data)

#rownames(cell_gene) = str_replace(rownames(cell_gene),"-",".")

for(i in 1:dim(table_temp)[1]){
  cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
  cell_values <- rowMeans(cell_exp)#cell_values = apply(as.data.frame(cell_exp),1,mean)#
  result <- cbind(result,cell_values)
  colnames(result)[i+1] = as.character(table_temp$Var1[i])
}

result = result[,-1]
result = as.data.frame(result)
mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]


CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
for(i in 1:dim(result)[1]){
  cell_max = max(as.numeric(result[i,]))
  max_cell = colnames(result)[which.max(result[i,])]
  tt = result[i,-(which.max(result[i,]))]
  remain_max = max(as.numeric(tt))
  remain_mean = mean(as.numeric(tt))
  cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
  CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
}
CS_CER_CEH_all = CS_CER_CEH_all[-1,]
rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
#CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
for(i in 1:dim(CS_CER_CEH_all)[1]){
  if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
      if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                             remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                             cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
          final_result_CS = rbind(final_result_CS,tempf)
        }
      }
    } 
  }
  else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                             remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                             cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
          final_result_CS = rbind(final_result_CS,tempf)
        }
      }
    } 
  }
  else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                             remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                             cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
          final_result_CS = rbind(final_result_CS,tempf)
        }
      }
    } 
  }
}
final_result_CS = final_result_CS[-1,]

remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
#CER 在该细胞中的表达大于其他最大值的五倍
final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
  if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
    if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
        tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                           remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                           cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
        final_result_CER = rbind(final_result_CER,tempf)
      }
    } 
  }
  else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
    if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
        tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                           remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                           cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
        final_result_CER = rbind(final_result_CER,tempf)
      }
    } 
  }
  else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
    if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
        tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                           remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                           cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
        final_result_CER = rbind(final_result_CER,tempf)
      }
    } 
  }
}
final_result_CER = final_result_CER[-1,]

remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
#CEH 在该细胞中的表达大于其他均值的五倍
final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
for(i in 1:dim(result_CEH)[1]){
  if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
    if(max(as.numeric(result_CEH[i,]))>0.01){
      tt = as.data.frame(result_CEH[i,])
      cell_mean = ""
      remain_data = ""
      remain_mean = ""
      cell_type = ""
      for(m in 1:dim(result_CEH)[2]){
        if(as.numeric(tt[1,m])>0.01){
          if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
            cell_type = str_c(cell_type,",",colnames(tt)[m])
          }
        }
      }
      tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                         remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                         cell_type = cell_type,gene_type = "mRNA")
      final_result_CEH = rbind(final_result_CEH,tempf)
    }
  }
  else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
    if(max(as.numeric(result_CEH[i,]))>0.001){
      tt = as.data.frame(result_CEH[i,])
      cell_mean = ""
      remain_data = ""
      remain_mean = ""
      cell_type = ""
      for(m in 1:dim(result_CEH)[2]){
        if(as.numeric(tt[1,m])>0.001){
          if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
            cell_type = str_c(cell_type,",",colnames(tt)[m])
          }
        }
      }
      tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                         remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                         cell_type = cell_type,gene_type = "lncRNA")
      final_result_CEH = rbind(final_result_CEH,tempf)
    }
  }
  else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
    if(max(as.numeric(result_CEH[i,]))>0.001){
      tt = as.data.frame(result_CEH[i,])
      cell_mean = ""
      remain_data = ""
      remain_mean = ""
      cell_type = ""
      for(m in 1:dim(result_CEH)[2]){
        if(as.numeric(tt[1,m])>0.001){
          if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
            cell_type = str_c(cell_type,",",colnames(tt)[m])
          }
        }
      }
      tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                         remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                         cell_type = cell_type,gene_type = "pseudogene")
      
      final_result_CEH = rbind(final_result_CEH,tempf)
    }
  }
}
final_result_CEH = final_result_CEH[-1,]

tt1 = c()
for(i in 1:dim(final_result_CEH)[1]){
  if(final_result_CEH$cell_exp[i]==""){
    tt1 = c(tt1,i)
  }
}
final_result_CEH = final_result_CEH[-tt1,]
final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)

ttceh = data.frame()
for(i in 1:dim(final_result_CEH)[1]){
  
  if(str_detect(final_result_CEH$cell_exp[i],",")){
    tt1 = final_result_CEH[i,]
    for(j in 1:length(strsplit(tt1$cell_exp[1],",")[[1]])){
      t_temp = data.frame(gene = tt1$gene[1],cell_exp = strsplit(tt1$cell_exp[1],",")[[1]][j],
                          remain_max = strsplit(tt1$remain_max[1],",")[[1]][j],
                          remain_mean = strsplit(tt1$remain_mean[1],",")[[1]][j],class = tt1$class[1],
                          cell_type = strsplit(tt1$cell_type[1],",")[[1]][j],gene_type = tt1$gene_type[1])
      ttceh = rbind(ttceh,t_temp)
    }
  }
}

final_result_CEH = rbind(final_result_CEH,ttceh)



tt1 = c()
for(i in 1:dim(final_result_CEH)[1]){
  if(str_detect(final_result_CEH$cell_exp[i],",")){
    tt1 = c(tt1,i)
  }
}
final_result_CEH = final_result_CEH[-tt1,]






final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)
celltype_geneclass = data.frame(cell = table_temp$Var1,CS = 0,CER = 0,CEH = 0)
rownames(celltype_geneclass) = celltype_geneclass$cell

cs = as.data.frame(table(final_result_CS$cell_type))
rownames(cs) = cs$Var1
cer = as.data.frame(table(final_result_CER$cell_type))
rownames(cer) = cer$Var1
ceh = as.data.frame(table(final_result_CEH$cell_type))
rownames(ceh) = ceh$Var1

for(i in 1:dim(celltype_geneclass)[1]){
  if(rownames(celltype_geneclass)[i] %in% rownames(cs)){celltype_geneclass[i,2] = cs[rownames(celltype_geneclass)[i],2]}
  if(rownames(celltype_geneclass)[i] %in% rownames(cer)){celltype_geneclass[i,3] = cer[rownames(celltype_geneclass)[i],2]}
  if(rownames(celltype_geneclass)[i] %in% rownames(ceh)){celltype_geneclass[i,4] = ceh[rownames(celltype_geneclass)[i],2]}
}






final_result$cell_num_value = 0
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
for(i in 1:dim(final_result)[1]){
  
  temp = data[final_result$gene[i],colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == final_result$cell_type[i]),])]##
  
  final_result$cell_num_value[i] = sum(temp!=0)
}

final_result_10 = final_result[final_result$cell_num_value>=10,]


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

write.table(final_result,"E:\\lcw\\lncSPA\\orignal_data\\TRES\\final_res\\GSE72056_melanoma.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(final_result_10,"E:\\lcw\\lncSPA\\orignal_data\\TRES\\final_res_10\\GSE72056_melanoma_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

rm(tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,cell_type,cellann,
   cell_exp,temp,ceh,cer,cs,celltype_geneclass,CS_CER_CEH_all,cstemp,lncRNA_exp,
   mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
   cell_values,i,m,max_cell,cell_max,table_temp,result,result_CEH,n,dir2,final_result_10,file,t_temp,ttceh,tissue_seurat,tabletemp,data,cell_gene,j)
gc()

setwd("D:/R/script")



















data = Read10X(data.dir = "E:\\lcw\\lncSPA\\filter_data\\GSE125449_liver cancer\\set1\\")

pbmc <- CreateSeuratObject(counts = data, project = "seurat", min.cells = 3, min.features = 50,names.delim = "_")





"D:/R/script"





getwd()

setwd("D:/R/script")

listfile = list.files()

aa = as.data.frame(listfile)

aa$cancer = str_split(aa$listfile,"_")

bb = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type_number.xlsx",sheet = 1)

"GSE140819"%in%aa$GSE

#######################tiger_data------------------------
library(GEOquery)



cell_type = read.csv("E:\\lcw\\lncSPA\\tiger_data\\CD4_TIL_droplet_cellinfo_matrice.csv")

data = temp_data
rownames(data) = data[,1]
data = data[,-1]

tissue_seurat <- CreateSeuratObject(counts = temp_data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)


data01 = readRDS("E:\\lcw\\lncSPA\\tiger_data\\GSM4138872_scADT_BMMC_D1T1.rds")






library(openxlsx)
library(stringr)
library(Seurat)
library(dplyr)


temp_data = read.table("E:\\lcw\\lncSPA\\tiger_data\\NSCLC_GSE150430\\npc_scRNA_hg19_processed_data.txt",header=T,sep="\t",stringsAsFactors=F)


aa = as.data.frame(t(temp_data[1,]))
aa$cell = rownames(aa)
temp_data = temp_data[-1,]

tissue_seurat <- CreateSeuratObject(counts = temp_data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_")


bb = as.data.frame(table(aa$Cell_type))

write.table(bb,"D:\\Desktop\\tiger_celltype.txt",sep="\t",quote=F,row.names=F)

bb = read.xlsx("D:\\Desktop\\tiger_celltype.xlsx")


table_temp = as.data.frame(table(bb$cell))


for(m in 1:dim(aa)[1]){
  for(n in 1:dim(bb)[1]){
    if(aa$Cell_type[m] == bb$Var1[n]){##
      aa$Cell_type[m] = bb$cell[n]##
    }
  }
}

result = rownames(temp_data)

for(i in 1:dim(table_temp)[1]){
  cell_exp = temp_data[,colnames(temp_data) %in% aa$cell[which(aa$Cell_type == table_temp$Var1[i])]]##
  cell_values <- rowMeans(cell_exp)#cell_values = apply(as.data.frame(cell_exp),1,mean)#
  result <- cbind(result,cell_values)
  colnames(result)[i+1] = as.character(table_temp$Var1[i])
}

result = result[,-1]
result = as.data.frame(result)


gse <- getGEO(GEO="GSE152048", 
              destdir = "E:/lcw/lncSPA/tiger_data/OS_GSE152048",
              filename=NULL, 
              GSElimits=NULL,
              GSEMatrix=TRUE, 
              AnnotGPL=FALSE, 
              getGPL=FALSE)

options()$repos #翻墙
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options()$BioC_mirror
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/")
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
library(GEOquery)
gset <- getGEO('GSE123904', destdir="E:/lcw/lncSPA/tiger_data/NSCLC_GSE123904",
               AnnotGPL = T,     ## 注释文件
               getGPL = T)       ## 平台文件


getwd()
exprSet <- read.table("E:\\lcw\\lncSPA\\tiger_data\\NSCLC_GSE123904\\GSE123904-GPL20301_series_matrix.txt",
                      comment.char="!",       #comment.char="!" 意思是！后面的内容不要读取
                      stringsAsFactors=F,
                      header=T)
class(exprSet)
rownames(exprSet) <- exprSet[,1]  #把第一列的值变为行名
exprSet <- exprSet[,-1]  #把第一列去掉




data = Read10X(data.dir = "E:\\lcw\\lncSPA\\tiger_data\\OS_GSE152048\\BC2")

tissue_seurat = CreateSeuratObject(counts = data, min.cells = 3, min.features = 50, names.delim = "_")


temp = tissue_seurat@meta.data#细胞类型信息
cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型

cancer_exp = tissue_seurat[["RNA"]]@data#提取表达数据


####################CRC_GSE132465--------------------------
E:\lcw\lncSPA\tiger_data\CRC_GSE132465

cellann = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132465\\GSE132465_GEO_processed_CRC_10X_cell_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(cellann$Cell_type))


write.xlsx(tabletemp,"D:\\Desktop\\tiger_celltype.xlsx")


tabletemp = read.xlsx("D:\\Desktop\\tiger_celltype.xlsx")

colnames(cellann)[5] = "cell_type"
for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


data = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132465\\GSE132465_GEO_processed_CRC_10X_raw_UMI_count_matrix.txt",header=T,sep="\t",stringsAsFactors=F)





aa$Index = str_replace(aa$Index,"-",".")
aa = as.data.frame(aa[,c(1,5)])
rownames(aa) = aa$Index
aa$cell = rownames(aa)
aa= as.data.frame(aa[,-1])
colnames(aa) = c("Cell_type","cell")

###############


cancer_seurat = readRDS("E:\\lcw\\lncSPA\\tiger_data\\MPAL_GSE139369\\GSM4138872_scRNA_BMMC_D1T1.rds")
cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
temp = cancer_seurat@Dimnames
cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型

cancer_exp = cancer_seurat@x#提取表达数据



aa = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132465\\final_result_10.txt",header=T,sep="\t",stringsAsFactors=F)


###################ESCC_GSE145370-------




#####
library(BiocManager)
BiocManager::install("rhdf5")
library(rhdf5)
library(Seurat)
library(hdf5r)
library(stringr)
getwd()#
setwd("D:/R/script")

setwd("E:\\lcw\\lncSPA\\tiger_data\\NSCLC_GSE140819")
fs=list.files(pattern = '.h5')
fs



aa = Read10X_h5("NSCLC14_fresh-LE_channel1_raw_gene_bc_matrices_h5.h5")

(p=str_split(fs[1],'_',simplify = T)[,2])

tissue_seurat <- CreateSeuratObject( aa ,project = p , min.cells = 3, min.features = 50, names.delim = "_")
tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
temp = tissue_seurat@meta.data#细胞类型信息
#cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型

data = read.csv("GSM4186958_metadata_NSCLC14_fresh-LE_channel1.csv")
data$X = str_sub(data$X,6,-1)
data$X = str_c(data$X,"-1",sep = "")

cancer_exp = tissue_seurat[["RNA"]]@data#提取表达数据

#####################CRC_GSE132257------------------------
library(patchwork)
data = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132257\\GSE132257_GEO_processed_protocol_and_fresh_frozen_raw_UMI_count_matrix.txt",header=T,sep="\t",stringsAsFactors=F)
rownames(data) = data$Index
data = data[,-1]

anno = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132257\\GSE132257_processed_protocol_and_fresh_frozen_cell_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(anno$Cell_type))
tabletemp$cell = 0

temp = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132465\\tiger_celltype.txt",header=T,sep="\t",stringsAsFactors=F)
temp$Var1[7] = as.character(tabletemp$Var1[7])
temp$cell[7] = "Unclassified"


write.table(temp,"E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132257\\tiger_celltype.txt",sep="\t",quote=F,row.names=F)

pbmc <- CreateSeuratObject(counts = data, project = "pbmc3k",min.cells = 3, min.features = 50, names.delim = "_")


#####################CRC_GSE144735-----------------------------------
library(Seurat)
library(stringr)
data = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE144735\\GSE144735_processed_KUL3_CRC_10X_raw_UMI_count_matrix.txt",header=T,sep="\t",stringsAsFactors=F)



anno = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE144735\\GSE144735_processed_KUL3_CRC_10X_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(anno$Cell_type))
tabletemp$cell = 0



####################

##########################################################20220923---------------------
library(org.Hs.eg.db) #人类注释数据库
library(clusterProfiler)#进行GO富集和KEGG富集
library(dplyr) #进行数据转换
library(stringr)
setwd("D:/R/script")

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

lncRNA = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\data\\HCL_fetal")
listfile = list.files()


res = data.frame(tissue_type = 0,lncRNA_ID = 0,mRNA_ID = 0)

for(i in 1:length(listfile)){
  
  data = read.table(str_c("E:\\lcw\\lncSPA\\data\\HCL_fetal\\",listfile[i],sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  table_lnc = as.data.frame(table(data$lncRNA_name))
  
  
  for(j in 1:dim(table_lnc)[1]){
    
    if(table_lnc$Var1[j] %in% lncRNA$gene_name){
      temp = data[data$lncRNA_name == table_lnc$Var1[j],]
      
      mmtemp = ""
      for(m in 1:dim(temp)[1]){
        if((temp$mRNA_name[m] %in% mRNA$gene_name) & is.na(temp$classification[m]) == F){
          mm0 = str_c(mRNA$ensembl_gene_id[which(mRNA$gene_name == temp$mRNA_name[m])],temp$mRNA_name[m],temp$p_value[m],temp$R[m],temp$classification[m],temp$cell[m],sep = ":")
          mmtemp = str_c(mmtemp,mm0,sep = ";")
        }
        
      }
      mmtemp = str_sub(mmtemp,2,-1)
      temp_res = data.frame(tissue_type = data$tissue_type[j],
                            lncRNA_ID = str_c(lncRNA$ensembl_gene_id[which(lncRNA$gene_name == table_lnc$Var1[j])],table_lnc$Var1[j],sep = ";"),
                            mRNA_ID = mmtemp)
      res = rbind(res,temp_res)
    }
    
  }
  
}
res = res[-1,]



res <- res %>% distinct(tissue_type,lncRNA_ID,mRNA_ID, .keep_all = T)
res_02 = res_01 %>% distinct(mRNA_ID, .keep_all = T)

write.table(res,"E:\\lcw\\lncSPA\\result\\HCL_fetal_res.txt",sep="\t",quote=F,row.names=F)
write.table(res_01,"E:\\lcw\\lncSPA\\result\\HCL_fetal_res_01.txt",sep="\t",quote=F,row.names=F)




rm(mm,mm0,temp,tt,table_lnc,i,j,m)



aa = as.data.frame(table(lncrna$Var1))
bb = as.data.frame(table(mrna$Var1))


lncRNA_ID<-bitr(aa$Var1,fromType="SYMBOL",toType=c("ENTREZID","ENSEMBL","SYMBOL"),OrgDb="org.Hs.eg.db")
mRNA_ID<-bitr(bb$Var1,fromType="SYMBOL",toType=c("ENTREZID","ENSEMBL","SYMBOL"),OrgDb="org.Hs.eg.db")




for(i in 1:length(listfile)){
  data = data = read.table(str_c("E:\\lcw\\lncSPA\\data\\HCL_fetal\\",listfile[i],sep = ""),header=T,sep="\t",stringsAsFactors=F)
  print(table(data$tissue_type))
}







temp = data.frame(tissue_type = data$tissue_type[j],
                  lncRNA_ID = str_c(lncRNA$ensembl_gene_id[which(lncRNA$gene_name == data$lncRNA_name[j])],data$lncRNA_name[j],sep = ";"),
                  mRNA_ID = 0)





lncRNA[lncRNA$gene_name == table_lnc$Var1[j],]








hcl = read.table("E:\\lcw\\lncSPA\\result\\HCL_fetal_res_01.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

hcl_s = read.table("E:\\lcw\\lncSPA\\result\\HCL_fetal_cor.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件



data$mRNA_ID = NA
data$lncRNA_ID = NA

for(i in 1:dim(data)[1]){
  if(data$mRNA_name[i] %in% mRNA$gene_name){data$mRNA_ID[i] = mRNA$ensembl_gene_id[which(mRNA$gene_name == data$mRNA_name[i])]}
  if(data$lncRNA_name[i] %in% lncRNA$gene_name){data$lncRNA_ID[i] = lncRNA$ensembl_gene_id[which(lncRNA$gene_name == data$lncRNA_name[i])]}
}

data[is.na(data)] = "NA"
table_lnc = as.data.frame(table(data$lncRNA_name))


##########################################################20220923----------
library(org.Hs.eg.db) #人类注释数据库
library(clusterProfiler)#进行GO富集和KEGG富集
library(dplyr) #进行数据转换
library(stringr)
setwd("D:/R/script")

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件


lncRNA = rbind(lncRNA,other_RNA)

cancer = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\cancer.xlsx")

tissue_num <- data.frame(cancer = str_c(cancer$cancer_type,cancer$Dataset,sep = "_"),input = cancer$cancer)


setwd("E:\\lcw\\lncSPA\\zhenghe\\result\\5TISCH.lncRNA_cor_mRNA.result")
listfile = list.files(pattern = "sclink")


res = data.frame(tissue_type = 0,lncRNA_ID = 0,mRNA_ID = 0)

for(i in 1:length(listfile)){
  
  data = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  
  table_lnc = as.data.frame(table(data$lncRNA_name))
  
  
  for(j in 1:dim(table_lnc)[1]){
    if(table_lnc$Var1[j] %in% lncRNA$gene_name){
      lnc_temp = lncRNA[lncRNA$gene_name == table_lnc$Var1[j],]
      for(n in 1:dim(lnc_temp)[1]){
        temp = data[data$lncRNA_name == table_lnc$Var1[j],]
        
        mmtemp = ""
        for(m in 1:dim(temp)[1]){
          if(temp$mRNA_name[m] %in% mRNA$gene_name){
            mRNA_temp = mRNA[mRNA$gene_name == temp$mRNA_name[m],]
            for(k in 1:dim(mRNA_temp)[1]){
              if(is.na(temp$classification[m]) == F){
                mm0 = str_c(mRNA_temp$ensembl_gene_id[k],temp$mRNA_name[m],temp$p_value[m],temp$R[m],temp$classification[m],temp$cell[m],sep = ":")
                mmtemp = str_c(mmtemp,mm0,sep = ";")
              }else{
                mm0 = str_c(mRNA_temp$ensembl_gene_id[k],temp$mRNA_name[m],temp$p_value[m],temp$R[m],"NA",temp$cell[m],sep = ":")
                mmtemp = str_c(mmtemp,mm0,sep = ";")
              }
            }
          }else{
            if(is.na(temp$classification[m]) == F){
              mm0 = str_c("NA",temp$mRNA_name[m],temp$p_value[m],temp$R[m],temp$classification[m],temp$cell[m],sep = ":")
              mmtemp = str_c(mmtemp,mm0,sep = ";")
            }else{
              mm0 = str_c("NA",temp$mRNA_name[m],temp$p_value[m],temp$R[m],"NA",temp$cell[m],sep = ":")
              mmtemp = str_c(mmtemp,mm0,sep = ";")
            }
            
          }
          
        }
        mmtemp = str_sub(mmtemp,2,-1)
        temp_res = data.frame(tissue_type = str_split(listfile[i],pattern = "\\.")[[1]][1],
                              lncRNA_ID = str_c(lnc_temp$ensembl_gene_id[n],table_lnc$Var1[j],sep = ";"),
                              mRNA_ID = mmtemp)
        res = rbind(res,temp_res)
      }
      
    }else{
      temp = data[data$lncRNA_name == table_lnc$Var1[j],]
      
      mmtemp = ""
      for(m in 1:dim(temp)[1]){
        if(temp$mRNA_name[m] %in% mRNA$gene_name){
          mRNA_temp = mRNA[mRNA$gene_name == temp$mRNA_name[m],]
          for(k in 1:dim(mRNA_temp)[1]){
            if(is.na(temp$classification[m]) == F){
              mm0 = str_c(mRNA_temp$ensembl_gene_id[k],temp$mRNA_name[m],temp$p_value[m],temp$R[m],temp$classification[m],temp$cell[m],sep = ":")
              mmtemp = str_c(mmtemp,mm0,sep = ";")
            }else{
              mm0 = str_c(mRNA_temp$ensembl_gene_id[k],temp$mRNA_name[m],temp$p_value[m],temp$R[m],"NA",temp$cell[m],sep = ":")
              mmtemp = str_c(mmtemp,mm0,sep = ";")
            }
          }
        }else{
          if(is.na(temp$classification[m]) == F){
            mm0 = str_c("NA",temp$mRNA_name[m],temp$p_value[m],temp$R[m],temp$classification[m],temp$cell[m],sep = ":")
            mmtemp = str_c(mmtemp,mm0,sep = ";")
          }else{
            mm0 = str_c("NA",temp$mRNA_name[m],temp$p_value[m],temp$R[m],"NA",temp$cell[m],sep = ":")
            mmtemp = str_c(mmtemp,mm0,sep = ";")
          }
          
        }
        
      }
      mmtemp = str_sub(mmtemp,2,-1)
      temp_res = data.frame(tissue_type = data$tissue_type[j],
                            lncRNA_ID = str_c("NA",table_lnc$Var1[j],sep = ";"),
                            mRNA_ID = mmtemp)
      res = rbind(res,temp_res)
    }
    
  }
  
}
res = res[-1,]




######暑假数据重新整理---------------------------------
setwd("D:/R/script")
tabc = c()


setwd("E:\\lcw\\lncSPA\\data\\TISCH2\\")
listfile = list.files()
listfile = str_sub(listfile,1,-4)

for(i in 1:length(listfile)){
  dir.create(listfile[i])
}

tabletemp = data.frame()
for(k in 1:length(listfile)){
  
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\",listfile[k],".rds",sep = ""))#读取数据
  cancer_seurat = NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
  temp = cancer_seurat@meta.data#细胞类型信息
  cell_type = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
  
  tt = as.data.frame(table(cell_type$cell))
  
  tabletemp = rbind(tabletemp,tt)
  rm(cancer_seurat,cell_type,temp)
  gc()
}###整理细胞类型
table_temp = as.data.frame(table(tabletemp$Var1))

write.xlsx(table_temp,"E:/lcw/lncSPA/data/TISCH2/cell_type.xlsx")

tabletemp = read.xlsx("E:/lcw/lncSPA/data/TISCH2/cell_type.xlsx")#统一后的所有细胞类型

write.table(tabletemp,"D:\\Desktop\\tabletemp.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


for(k in 11:length(listfile)){
  
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\",listfile[k],"_QC.rds",sep = ""))#读取数据
  
  cancer_seurat = NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)#标准化
  
  temp = cancer_seurat@meta.data#细胞类型信息
  
  cell_gene = data.frame(cell = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
  #将细胞类型统一
  cell_gene$cell_type = "0"
  for(m in 1:dim(cell_gene)[1]){
    for(n in 1:dim(tabletemp)[1]){
      if(as.character(cell_gene$cell[m]) == as.character(tabletemp$Var1[n])){
        cell_gene$cell_type[m] = tabletemp$cell[n]
      }
    }
  }
  
  
  data = cancer_seurat[["RNA"]]@data#提取表达数据
  
  table_temp = as.data.frame(table(cell_gene$cell_type))#记录共有多少种细胞
  
  result = rownames(data)
  
  for(i in 1:dim(table_temp)[1]){
    cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
    cell_values <- rowMeans(cell_exp)#cell_values = apply(as.data.frame(cell_exp),1,mean)#
    result <- cbind(result,cell_values)
    colnames(result)[i+1] = as.character(table_temp$Var1[i])
  }
  
  
  write.table(result,str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\1gene_exp_mean\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  
  result = result[,-1]
  result = as.data.frame(result)
  mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
  lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
  pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]
  
  
  CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
  for(i in 1:dim(result)[1]){
    cell_max = max(as.numeric(result[i,]))
    max_cell = colnames(result)[which.max(result[i,])]
    tt = result[i,-(which.max(result[i,]))]
    remain_max = max(as.numeric(tt))
    remain_mean = mean(as.numeric(tt))
    cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
    CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
  }
  CS_CER_CEH_all = CS_CER_CEH_all[-1,]
  rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
  #CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
  final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  for(i in 1:dim(CS_CER_CEH_all)[1]){
    if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
    else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
    else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
  }
  final_result_CS = final_result_CS[-1,]
  
  remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
  #CER 在该细胞中的表达大于其他最大值的五倍
  final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
    if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
    else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
    else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
  }
  final_result_CER = final_result_CER[-1,]
  
  remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
  #CEH 在该细胞中的表达大于其他均值的五倍
  final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
  for(i in 1:dim(result_CEH)[1]){
    if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.01){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.01){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "mRNA")
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
    else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.001){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.001){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "lncRNA")
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
    else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.001){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.001){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "pseudogene")
        
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
  }
  final_result_CEH = final_result_CEH[-1,]
  
  tt1 = c()
  for(i in 1:dim(final_result_CEH)[1]){
    if(final_result_CEH$cell_exp[i]==""){
      tt1 = c(tt1,i)
    }
  }
  final_result_CEH = final_result_CEH[-tt1,]
  final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
  final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
  final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
  final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)
  
  ttceh = data.frame()
  for(i in 1:dim(final_result_CEH)[1]){
    
    if(str_detect(final_result_CEH$cell_exp[i],",")){
      tt1 = final_result_CEH[i,]
      for(j in 1:length(strsplit(tt1$cell_exp[1],",")[[1]])){
        t_temp = data.frame(gene = tt1$gene[1],cell_exp = strsplit(tt1$cell_exp[1],",")[[1]][j],
                            remain_max = strsplit(tt1$remain_max[1],",")[[1]][j],
                            remain_mean = strsplit(tt1$remain_mean[1],",")[[1]][j],class = tt1$class[1],
                            cell_type = strsplit(tt1$cell_type[1],",")[[1]][j],gene_type = tt1$gene_type[1])
        ttceh = rbind(ttceh,t_temp)
      }
    }
  }
  
  final_result_CEH = rbind(final_result_CEH,ttceh)
  
  
  
  tt1 = c()
  for(i in 1:dim(final_result_CEH)[1]){
    if(str_detect(final_result_CEH$cell_exp[i],",")){
      tt1 = c(tt1,i)
    }
  }
  
  if(length(tt1) >0){final_result_CEH = final_result_CEH[-tt1,]}
  
  
  
  
  final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)
  
  
  final_result$cell_num_value = 0
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  for(i in 1:dim(final_result)[1]){
    
    temp = data[final_result$gene[i],colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == final_result$cell_type[i]),])]##
    
    final_result$cell_num_value[i] = sum(temp!=0)
  }
  
  final_result_10 = final_result[final_result$cell_num_value>=10,]
  
  
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  write.table(final_result,str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\1final_res\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  write.table(final_result_10,str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\1final_res_10\\",listfile[k],"_10.txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  tabc = c(tabc,listfile[k])
  
  rm(tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,cell_type,
     cell_exp,temp,CS_CER_CEH_all,cstemp,lncRNA_exp,
     mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
     cell_values,max_cell,cell_max,table_temp,result,result_CEH,n,m,final_result_10,ttceh,data,cell_gene)
  gc()
  
  setwd(str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\",listfile[k],sep = ""))
  
  #4. 找Variable基因
  cancer_seurat = FindVariableFeatures(cancer_seurat, selection.method = "vst", nfeatures = 2000)
  gc()
  
  #5. scale表达矩阵
  cancer_seurat <- ScaleData(cancer_seurat, features = rownames(cancer_seurat))
  #6. 降维聚类
  #（基于前面得到的high variable基因的scale矩阵）
  cancer_seurat <- RunPCA(cancer_seurat, npcs = 50, verbose = FALSE)
  pdf(file = as.character(paste(listfile[k],".VizDimLoadings.pdf",sep="")))
  p <- VizDimLoadings(cancer_seurat, dims = 1:2, reduction = "pca")
  print(p)
  dev.off()
  
  pdf(paste(listfile[k],".DimPlot.pdf",sep=""))
  p <- DimPlot(cancer_seurat, reduction = "pca")
  print(p)
  dev.off()
  ##########
  pdf(paste(listfile[k],".DimHeatmap.pdf",sep=""))
  p =  DimHeatmap(cancer_seurat, dims = 1, cells = 500, balanced = TRUE)
  print(p)
  dev.off()
  #7.定义数据集维度
  #NOTE: This process can take a long time for big datasets, comment out for expediency. 
  #More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
  cancer_seurat <- JackStraw(cancer_seurat, num.replicate = 100)
  gc()
  cancer_seurat <- ScoreJackStraw(cancer_seurat, dims = 1:20)
  
  pdf(paste(listfile[k],".JackStrawPlot.pdf",sep=""))
  p <- JackStrawPlot(cancer_seurat, dims = 1:15)
  print(p)
  dev.off()
  
  pdf(paste(listfile[k],".ElbowPlot.pdf",sep=""))
  p <- ElbowPlot(cancer_seurat,ndims = 50)
  print(p)
  dev.off()
  #8.细胞分类
  cancer_seurat <- FindNeighbors(cancer_seurat, dims = 1:10)
  gc()
  cancer_seurat <- FindClusters(cancer_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))
  
  #用已知的细胞类型代替分类的细胞类型
  temp = cancer_seurat@meta.data
  
  #tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
  Idents(object=cancer_seurat) <- cancer_seurat@meta.data$Celltype..major.lineage.
  #9.可视化分类结果
  #UMAP
  cancer_seurat <- RunUMAP(cancer_seurat, dims = 1:10, label = T)
  gc()
  #head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
  write.table(cancer_seurat@reductions$umap@cell.embeddings,file=paste(listfile[k],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
  #note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
  p1 <- DimPlot(cancer_seurat, reduction = "umap")
  #T-SNE
  cancer_seurat <- RunTSNE(cancer_seurat, dims = 1:10)#报错，改为不检查重复
  gc()
  #head(tissue_seurat@reductions$tsne@cell.embeddings)
  write.table(cancer_seurat@reductions$tsne@cell.embeddings,file=paste(listfile[k],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
  p2 <- DimPlot(cancer_seurat, reduction = "tsne")
  pdf(paste(listfile[k],".umap.tsne.pdf",sep=""),width = 15, height = 8)
  print(p1 + p2)
  dev.off()
  saveRDS(cancer_seurat, file = paste(listfile[k],".rds",sep=""))  #保存数据，用于后续个性化分析
  gc()
  #10.提取各细胞类型的marker gene
  #find all markers of cluster 1
  #cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
  #利用 DoHeatmap 命令可以可视化marker基因的表达
  cancer_seurat.markers <- FindAllMarkers(cancer_seurat, only.pos = TRUE, min.pct = 0.25)
  gc()
  top3 <- cancer_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
  pdf(paste(listfile[k],".DoHeatmap.pdf",sep=""))
  p <- DoHeatmap(cancer_seurat, features = top3$gene) + NoLegend()
  print(p)
  dev.off()
  pdf(paste(listfile[k],".umap.DimPlot.pdf",sep=""))
  p <- DimPlot(cancer_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
  print(p)
  dev.off()
  pdf(paste(listfile[k],".tsne.DimPlot.pdf",sep=""))
  p <- DimPlot(cancer_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
  print(p)
  dev.off()
  rm(p,p1,p2,temp,cancer_seurat,cancer_seurat.markers,top3)
  gc()
  
}
setwd("D:/R/script")


#######开学数据重新整理--------------
##TISCH_own------
library(rhdf5)
library(hdf5r)
library(readr)
library(Seurat)
library(stringr)
setwd("D:/R/script")
setwd("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\")

listfile = list.files()

tabletemp = read.xlsx("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\tabletemp.xlsx")
write.table(tabletemp,"D:\\Desktop\\tabletemp.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

for(k in 1:length(listfile)){
  
  setwd(str_c("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\",listfile[k],sep = ""))
  listfile1 = list.files(pattern = ".h5")
  listfile2 = list.files(pattern = ".tsv")
  
  cellann = read_tsv(listfile2)
  colnames(cellann)[5] = "cell_type"
  
  for(m in 1:dim(cellann)[1]){
    for(n in 1:dim(tabletemp)[1]){
      if(cellann$cell_type[m] == tabletemp$Var1[n]){##
        cellann$cell_type[m] = tabletemp$cell[n]##
      }
    }
  }
  
  cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$Cell)
  
  write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  
  cell_gene = as.data.frame(cellann)
  rownames(cell_gene) = cell_gene$Cell
  
  
  
  
  h5 = Read10X_h5(listfile1)
  
  cancer_seurat <- CreateSeuratObject(counts = h5,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)
  
  cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  data = cancer_seurat[["RNA"]]@data#提取表达数据
  
  table_temp = as.data.frame(table(cell_gene$cell_type))##
  
  if(dim(table_temp)[1]>=3){
    
    result = rownames(data)
    
    #rownames(cell_gene) = str_replace(rownames(cell_gene),"-",".")
    
    for(i in 1:dim(table_temp)[1]){
      cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
      cell_values <- rowMeans(cell_exp)#cell_values = apply(as.data.frame(cell_exp),1,mean)#
      result <- cbind(result,cell_values)
      colnames(result)[i+1] = as.character(table_temp$Var1[i])
    }
    
    write.table(result,str_c("E:\\lcw\\lncSPA\\zhenghe\\exp\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
    
    setwd("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\")
    dir.create(listfile[k])
    setwd(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[k],sep = ""))
    
    #4. 找Variable基因
    cancer_seurat = FindVariableFeatures(cancer_seurat, selection.method = "vst", nfeatures = 2000)
    gc()
    
    #5. scale表达矩阵
    cancer_seurat <- ScaleData(cancer_seurat, features = rownames(cancer_seurat))
    #6. 降维聚类
    #（基于前面得到的high variable基因的scale矩阵）
    cancer_seurat <- RunPCA(cancer_seurat, npcs = 50, verbose = FALSE)
    pdf(file = as.character(paste(listfile[k],".VizDimLoadings.pdf",sep="")))
    p <- VizDimLoadings(cancer_seurat, dims = 1:2, reduction = "pca")
    print(p)
    dev.off()
    
    pdf(paste(listfile[k],".DimPlot.pdf",sep=""))
    p <- DimPlot(cancer_seurat, reduction = "pca")
    print(p)
    dev.off()
    ##########
    pdf(paste(listfile[k],".DimHeatmap.pdf",sep=""))
    p =  DimHeatmap(cancer_seurat, dims = 1, cells = 500, balanced = TRUE)
    print(p)
    dev.off()
    #7.定义数据集维度
    #NOTE: This process can take a long time for big datasets, comment out for expediency. 
    #More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
    cancer_seurat <- JackStraw(cancer_seurat, num.replicate = 100)
    gc()
    cancer_seurat <- ScoreJackStraw(cancer_seurat, dims = 1:20)
    
    pdf(paste(listfile[k],".JackStrawPlot.pdf",sep=""))
    p <- JackStrawPlot(cancer_seurat, dims = 1:15)
    print(p)
    dev.off()
    
    pdf(paste(listfile[k],".ElbowPlot.pdf",sep=""))
    p <- ElbowPlot(cancer_seurat,ndims = 50)
    print(p)
    dev.off()
    #8.细胞分类
    cancer_seurat <- FindNeighbors(cancer_seurat, dims = 1:10)
    gc()
    cancer_seurat <- FindClusters(cancer_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))
    
    #用已知的细胞类型代替分类的细胞类型
    temp = cancer_seurat@meta.data
    
    #tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
    Idents(object=cancer_seurat) <- cellann$cell_type
    #9.可视化分类结果
    #UMAP
    cancer_seurat <- RunUMAP(cancer_seurat, dims = 1:10, label = T)
    gc()
    #head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
    write.table(cancer_seurat@reductions$umap@cell.embeddings,file=paste(listfile[k],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
    #note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
    p1 <- DimPlot(cancer_seurat, reduction = "umap")
    #T-SNE
    cancer_seurat <- RunTSNE(cancer_seurat, dims = 1:10, check_duplicates = FALSE)#报错，改为不检查重复
    gc()
    #head(tissue_seurat@reductions$tsne@cell.embeddings)
    write.table(cancer_seurat@reductions$tsne@cell.embeddings,file=paste(listfile[k],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
    p2 <- DimPlot(cancer_seurat, reduction = "tsne")
    pdf(paste(listfile[k],".umap.tsne.pdf",sep=""),width = 15, height = 8)
    print(p1 + p2)
    dev.off()
    saveRDS(cancer_seurat, file = paste(listfile[k],".rds",sep=""))  #保存数据，用于后续个性化分析
    gc()
    #10.提取各细胞类型的marker gene
    #find all markers of cluster 1
    #cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
    #利用 DoHeatmap 命令可以可视化marker基因的表达
    cancer_seurat.markers <- FindAllMarkers(cancer_seurat, only.pos = TRUE, min.pct = 0.25)
    gc()
    top3 <- cancer_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
    pdf(paste(listfile[k],".DoHeatmap.pdf",sep=""))
    p <- DoHeatmap(cancer_seurat, features = top3$gene) + NoLegend()
    print(p)
    dev.off()
    pdf(paste(listfile[k],".umap.DimPlot.pdf",sep=""))
    p <- DimPlot(cancer_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
    print(p)
    dev.off()
    pdf(paste(listfile[k],".tsne.DimPlot.pdf",sep=""))
    p <- DimPlot(cancer_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
    print(p)
    dev.off()
    rm(p,p1,p2,temp,cancer_seurat,cancer_seurat.markers,top3)
    rm(result,h5,data,table_temp,cell_values,listfile1,listfile2,m,n,cell_exp,cell_gene,cellann)
    gc()
    
  }
}  

































#GSE72056_melanoma------------------------------------
data = read.table("E:\\lcw\\lncSPA\\TISCH\\GSE72056_melanoma\\GSE72056_melanoma_single_cell_revised_v2.txt",header=T,sep="\t",stringsAsFactors=F)
data = data[-1,]
data = data[-1,]


cellann = data.frame(cell = colnames(data),cell_type = t(data[1,]))
colnames(cellann) = c("cell","cell_type")
cellann = cellann[-1,]

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")
data = data[-1,]

data_mean=aggregate(.~Cell,mean,data=data)#表达谱里相同的基因取均值

rownames(data_mean) = data_mean$Cell
data_mean = data_mean[,-1]


tissue_seurat <- CreateSeuratObject(counts = data.matrix(data_mean),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)
cancer_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据



for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell

listfile = c("GSE72056_melanoma")
k=1



#GSE75688_breast cancer------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE75688_breast cancer")

data = read.table("GSE75688_GEO_processed_Breast_Cancer_raw_TPM_matrix.txt",header=T,sep="\t",stringsAsFactors=F)
cellann = read.xlsx("GSE75688_umap.xlsx")
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

data = data[,-1]
data = data[,-2]

data_mean=aggregate(.~gene_name,mean,data=data)#表达谱里相同的基因取均值
rownames(data_mean) = data_mean$gene_name
data_mean = data_mean[,-1]

cancer_seurat <- CreateSeuratObject(counts = data.matrix(data_mean),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

listfile = c("GSE75688_breast cancer")
k=1

















#GSE84465_GBM------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE84465_GBM\\")

data = read.csv("GSE84465_GBM_All_data.csv",sep = " ")

cellann = read.xlsx("GSE84465_GBM_umap.xlsx")
cellann$cell_id = str_c("X",cellann$cell_id,sep = "")

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

tissue_seurat <- CreateSeuratObject(counts = data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

listfile = c("GSE84465_GBM")














#GSE103322_HNSCC----------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE103322_HNSCC\\")

data = read.table("GSE103322_HNSCC_all_data.txt",header=T,sep="\t",stringsAsFactors=F)
cellann = read.table("GSE103322_HNSCC_metafile.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellann)[6] = "cell_type"

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")
data = data[-c(1,2,3,4,5),]

rownames(data) = data$X
data = data[,-1]

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell

listfile = c("GSE103322_HNSCC")




#GSE115978_melanoma--------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE115978_melanoma\\")

data = read.csv("GSE115978_counts.csv")
cellann = read.csv("GSE115978_cell.annotations.csv")
colnames(cellann)[3] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("tabletemp.xlsx")


rownames(data) = data$X
data = data[,-1]

cancer_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cells)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cells


listfile = c("GSE115978_melanoma")
k = 1



#GSE116256_AML------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE116256_AML\\")
listfile = list.files(pattern = "dem")
data = read.table(listfile[1],header=T,sep="\t",stringsAsFactors=F)
for(i in 2:length(listfile)){
  data_temp = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  data = merge(data, data_temp, by = 'Gene',all.x = TRUE, all.y = T)
}
rownames(data) = data$Gene
data = data[,-1]

listfile = list.files(pattern = "anno")
cellann = read.table(listfile[1],header=T,sep="\t",stringsAsFactors=F)
for(i in 2:length(listfile)){
  cell_temp = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  cellann = merge(cellann, cell_temp, by = 'Cell',all.x = TRUE, all.y = T)
}
rownames(data) = data$Gene
data = data[,-1]






cellann = read.table("cellann.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(cellann$celltype))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")
tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

write.table(tabletemp,"D:\\Desktop\\tabletemp.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tabletemp = read.table("ctabletemp.txt",header=T,sep="\t",stringsAsFactors=F)

colnames(cellann)[2] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

write.table(cellann,"cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)


cell_gene = cellann
rownames(cell_gene) = cell_gene$cells







#GSE117988_Merkel cell carcinoma-----------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE117988_Merkel cell carcinoma\\")

listfile = c("GSE117988_Merkel cell carcinoma")

data_PBMC = read.csv("GSE117988_raw.expMatrix_PBMC.csv")
colnames(data_PBMC)[2:12875] = str_c(colnames(data_PBMC)[2:12875],".p",sep = "")

data_tumor = read.csv("GSE117988_raw.expMatrix_Tumor.csv")
colnames(data_tumor)[2:7432] = str_c(colnames(data_tumor)[2:7432],".t",sep = "")

data = merge(data_PBMC, data_tumor, by = 'X',all.x = TRUE, all.y = T)
data[is.na(data)] = 0
rownames(data) = data$X
data = data[,-1]

cellann = read.xlsx("GSE117988_umap.xlsx")
cellann$cell_id = str_sub(cellann$cell_id,1,-3)
cellann$cell_id = str_replace(cellann$cell_id,"-",".")
cellann$cell_id[str_detect(cellann$cell_sample,"PBMC")] = str_c(cellann$cell_id[str_detect(cellann$cell_sample,"PBMC")],".p",sep = "")
cellann$cell_id[str_detect(cellann$cell_sample,"Tumor")] = str_c(cellann$cell_id[str_detect(cellann$cell_sample,"Tumor")],".t",sep = "")

colnames(cellann)[4] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

#write.table(cellann,"D:\\Desktop\\cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

tissue_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id

data = cancer_seurat[["RNA"]]@data#提取表达数据



#GSE118056_Merkel cell carcinoma---------------------------------------------------
listfile = c("GSE118056_Merkel cell carcinoma")
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE118056_Merkel cell carcinoma\\")

data = read.csv("GSE118056_raw.expMatrix.csv")
rownames(data) = data$X
data = data[,-1]

cellann = read.xlsx("GSE118056_umap.xlsx")

colnames(cellann)[4] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


cancer_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id




#########GSE123813_BCC_Cancer-skin--------------------------------------------------
listfile = c("GSE123813_BCC_Cancer-skin")

setwd("E:\\lcw\\lncSPA\\TISCH\\GSE123813_BCC_Cancer-skin\\")

data = readRDS("GSE123813_BCC_Cancer-skin.rds")


cellann = read.table("cellann.txt",header=T,sep="\t",stringsAsFactors=F)


cancer_seurat <- NormalizeData(object = data, normalization.method = "LogNormalize", scale.factor = 10000)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell.id







#GSE125449_liver cancer------------------------------------------------------
listfile = c("GSE125449_liver cancer")
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE125449_liver cancer\\")
data1 = Read10X("set1")
data2 = Read10X("set2")

tissue_seurat1 = CreateSeuratObject(counts = data1,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

tissue_seurat2 = CreateSeuratObject(counts = data2,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat = merge(tissue_seurat1,tissue_seurat2)

sample1 = read.table("GSE125449_Set1_samples.txt",header=T,sep="\t",stringsAsFactors=F)
sample2 = read.table("GSE125449_Set2_samples.txt",header=T,sep="\t",stringsAsFactors=F)

sample = rbind(sample1,sample2)

colnames(sample)[3] = "cell_type"
tabletemp = as.data.frame(table(sample$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")


cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

#temp = tissue_seurat@meta.data#细胞类型信息


data = cancer_seurat[["RNA"]]@data#提取表达数据


for(m in 1:dim(sample)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(sample$cell_type[m] == tabletemp$Var1[n]){##
      sample$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


cell_gene = sample
rownames(cell_gene) = cell_gene$Cell.Barcode


#########GSE131907_Lung_Cancer-------------这个不用了---------------------------
listfile = c("GSE131907_Lung_Cancer")
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE131907_Lung_Cancer\\")

tissue_seurat = readRDS("GSE131907_Lung_Cancer_normalized_log2TPM_matrix.rds")
tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

cellann = read.table("cellann.txt.txt",header=T,sep="\t",stringsAsFactors=F)

colnames(cellann)[5] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

write.table(cellann,"D:\\Desktop\\cellann.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)











#GSE141982_glioma-------------------------------------------
listfile = c("GSE141982_glioma")
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE141982_glioma\\")

cellann = read.table("cellAnnotations.txt",header=F,sep="\t",stringsAsFactors=F)
colnames(cellann)[2] = "cell_type"
cellann$V1 = str_replace(cellann$V1,"-",".")

tabletemp = as.data.frame(table(cellann$cell_type))
tabletemp$cell = c("Astrocyte","Endothelial cell","Macrophage","Neutrophil")



data = read.table("expdata_GSE141982-glioma.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$V1


#GSE145137_bladder_cancer--------------------------------
listfile = c("GSE145137_bladder_cancer")
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE145137_bladder_cancer\\")
data = read.table("GSM4307111_GEO_processed_BC159-T_3_log2TPM_matrix_final.txt",header=T,sep="\t",stringsAsFactors=F)
rownames(data) = data$gene
data = data[,-1]

cancer_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
data = cancer_seurat[["RNA"]]@data#提取表达数据



cellann = read.xlsx("GSE145137_umap.xlsx")
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$cell_id



#GSE146771_colon_cancer---------------------------------------------
listfile = c("GSE146771_colon_cancer")

setwd("E:\\lcw\\lncSPA\\TISCH\\GSE146771_colon_cancer\\")

data = read.table("CRC.Leukocyte.Smart-seq2.TPM.txt",header=T,sep=" ",stringsAsFactors=F)

cancer_seurat <- CreateSeuratObject(counts = data.matrix(data),project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data#提取表达数据

cellann = read.table("CRC.Leukocyte.Smart-seq2.Metadata.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellann)[15] = "cell_type"
tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")
for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_gene = cellann
rownames(cell_gene) = cell_gene$CellName







################################################TIGER

####################CRC_GSE132465--------------------------
setwd("D:/R/script")

E:\lcw\lncSPA\tiger_data\CRC_GSE132465

cellann = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132465\\GSE132465_GEO_processed_CRC_10X_cell_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(cellann$Cell_type))


write.xlsx(tabletemp,"D:\\Desktop\\tiger_celltype.xlsx")


tabletemp = read.xlsx("D:\\Desktop\\tiger_celltype.xlsx")

colnames(cellann)[5] = "cell_type"
for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


data = read.table("E:\\lcw\\lncSPA\\tiger_data\\CRC_GSE132465\\GSE132465_GEO_processed_CRC_10X_raw_UMI_count_matrix.txt",header=T,sep="\t",stringsAsFactors=F)






######################

table_temp = as.data.frame(table(cell_gene$cell_type))##

result = rownames(data)

#rownames(cell_gene) = str_replace(rownames(cell_gene),"-",".")

for(i in 1:dim(table_temp)[1]){
  cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
  cell_values = apply(as.data.frame(cell_exp),1,mean)#cell_values <- rowMeans(cell_exp)#
  result <- cbind(result,cell_values)
  colnames(result)[i+1] = as.character(table_temp$Var1[i])
}

write.table(result,str_c("E:\\lcw\\lncSPA\\zhenghe\\exp\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)










if(dim(table_temp)[1]>=3){
  
  
  result = result[,-1]
  result = as.data.frame(result)
  mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
  lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
  pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]
  
  
  CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
  for(i in 1:dim(result)[1]){
    cell_max = max(as.numeric(result[i,]))
    max_cell = colnames(result)[which.max(result[i,])]
    tt = result[i,-(which.max(result[i,]))]
    remain_max = max(as.numeric(tt))
    remain_mean = mean(as.numeric(tt))
    cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
    CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
  }
  CS_CER_CEH_all = CS_CER_CEH_all[-1,]
  rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
  #CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
  final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  for(i in 1:dim(CS_CER_CEH_all)[1]){
    if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
    else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
    else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
  }
  final_result_CS = final_result_CS[-1,]
  
  remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
  #CER 在该细胞中的表达大于其他最大值的五倍
  final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
    if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
    else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
    else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
  }
  final_result_CER = final_result_CER[-1,]
  
  remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
  #CEH 在该细胞中的表达大于其他均值的五倍
  final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
  for(i in 1:dim(result_CEH)[1]){
    if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.01){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.01){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "mRNA")
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
    else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.001){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.001){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "lncRNA")
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
    else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.001){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.001){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "pseudogene")
        
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
  }
  final_result_CEH = final_result_CEH[-1,]
  
  tt1 = c()
  for(i in 1:dim(final_result_CEH)[1]){
    if(final_result_CEH$cell_exp[i]==""){
      tt1 = c(tt1,i)
    }
  }
  final_result_CEH = final_result_CEH[-tt1,]
  final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
  final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
  final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
  final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)
  
  ttceh = data.frame()
  for(i in 1:dim(final_result_CEH)[1]){
    
    if(str_detect(final_result_CEH$cell_exp[i],",")){
      tt1 = final_result_CEH[i,]
      for(j in 1:length(strsplit(tt1$cell_exp[1],",")[[1]])){
        t_temp = data.frame(gene = tt1$gene[1],cell_exp = strsplit(tt1$cell_exp[1],",")[[1]][j],
                            remain_max = strsplit(tt1$remain_max[1],",")[[1]][j],
                            remain_mean = strsplit(tt1$remain_mean[1],",")[[1]][j],class = tt1$class[1],
                            cell_type = strsplit(tt1$cell_type[1],",")[[1]][j],gene_type = tt1$gene_type[1])
        ttceh = rbind(ttceh,t_temp)
      }
    }
  }
  
  final_result_CEH = rbind(final_result_CEH,ttceh)
  
  
  
  tt1 = c()
  for(i in 1:dim(final_result_CEH)[1]){
    if(str_detect(final_result_CEH$cell_exp[i],",")){
      tt1 = c(tt1,i)
    }
  }
  
  if(length(tt1) >0){final_result_CEH = final_result_CEH[-tt1,]}
  
  
  
  
  
  
  
  final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)
  
  
  
  
  
  
  
  final_result$cell_num_value = 0
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  for(i in 1:dim(final_result)[1]){
    
    temp = data[final_result$gene[i],colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == final_result$cell_type[i]),])]##
    
    final_result$cell_num_value[i] = sum(temp!=0)
  }
  
  final_result_10 = final_result[final_result$cell_num_value>=10,]
  
  
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  write.table(final_result,str_c("E:\\lcw\\lncSPA\\orignal_data\\1final_res\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  write.table(final_result_10,str_c("E:\\lcw\\lncSPA\\zhenghe\\final_res_10\\",listfile[k],"_10.txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
}













setwd("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\")
dir.create(listfile[k])
setwd(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[k],sep = ""))

#4. 找Variable基因
cancer_seurat = FindVariableFeatures(cancer_seurat, selection.method = "vst", nfeatures = 2000)
gc()

#5. scale表达矩阵
cancer_seurat <- ScaleData(cancer_seurat, features = rownames(cancer_seurat))
#6. 降维聚类
#（基于前面得到的high variable基因的scale矩阵）
cancer_seurat <- RunPCA(cancer_seurat, npcs = 50, verbose = FALSE)
pdf(file = as.character(paste(listfile[k],".VizDimLoadings.pdf",sep="")))
p <- VizDimLoadings(cancer_seurat, dims = 1:2, reduction = "pca")
print(p)
dev.off()

pdf(paste(listfile[k],".DimPlot.pdf",sep=""))
p <- DimPlot(cancer_seurat, reduction = "pca")
print(p)
dev.off()
##
pdf(paste(listfile[k],".DimHeatmap.pdf",sep=""))
p =  DimHeatmap(cancer_seurat, dims = 1, cells = 500, balanced = TRUE)
print(p)
dev.off()
#7.定义数据集维度
#NOTE: This process can take a long time for big datasets, comment out for expediency. 
#More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
cancer_seurat <- JackStraw(cancer_seurat, num.replicate = 100)
gc()
cancer_seurat <- ScoreJackStraw(cancer_seurat, dims = 1:20)

pdf(paste(listfile[k],".JackStrawPlot.pdf",sep=""))
p <- JackStrawPlot(cancer_seurat, dims = 1:15)
print(p)
dev.off()

pdf(paste(listfile[k],".ElbowPlot.pdf",sep=""))
p <- ElbowPlot(cancer_seurat,ndims = 50)
print(p)
dev.off()
#8.细胞分类
cancer_seurat <- FindNeighbors(cancer_seurat, dims = 1:10)
gc()
cancer_seurat <- FindClusters(cancer_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))

#用已知的细胞类型代替分类的细胞类型
temp = cancer_seurat@meta.data

#tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
Idents(object=cancer_seurat) <- cellann$cell_type
#9.可视化分类结果
#UMAP
cancer_seurat <- RunUMAP(cancer_seurat, dims = 1:10, label = T)
gc()
#head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
write.table(cancer_seurat@reductions$umap@cell.embeddings,file=paste(listfile[k],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
#note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
p1 <- DimPlot(cancer_seurat, reduction = "umap")
#T-SNE
cancer_seurat <- RunTSNE(cancer_seurat, dims = 1:10, check_duplicates = FALSE)#报错，改为不检查重复
gc()
#head(tissue_seurat@reductions$tsne@cell.embeddings)
write.table(cancer_seurat@reductions$tsne@cell.embeddings,file=paste(listfile[k],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
p2 <- DimPlot(cancer_seurat, reduction = "tsne")
pdf(paste(listfile[k],".umap.tsne.pdf",sep=""),width = 15, height = 8)
print(p1 + p2)
dev.off()
saveRDS(cancer_seurat, file = paste(listfile[k],".rds",sep=""))  #保存数据，用于后续个性化分析
gc()
#10.提取各细胞类型的marker gene
#find all markers of cluster 1
#cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
#利用 DoHeatmap 命令可以可视化marker基因的表达
cancer_seurat.markers <- FindAllMarkers(cancer_seurat, only.pos = TRUE, min.pct = 0.25)
gc()
top3 <- cancer_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
pdf(paste(listfile[k],".DoHeatmap.pdf",sep=""))
p <- DoHeatmap(cancer_seurat, features = top3$gene) + NoLegend()
print(p)
dev.off()
pdf(paste(listfile[k],".umap.DimPlot.pdf",sep=""))
p <- DimPlot(cancer_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
print(p)
dev.off()
pdf(paste(listfile[k],".tsne.DimPlot.pdf",sep=""))
p <- DimPlot(cancer_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
print(p)
dev.off()
rm(p,p1,p2,temp,cancer_seurat,cancer_seurat.markers,top3)
rm(result,tissue_seurat,data,table_temp,cell_values,listfile1,listfile2,m,n,cell_exp,cell_gene,cellann)
rm(tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,cell_type,cellann,h5,
   cell_exp,temp,ceh,cer,cs,celltype_geneclass,CS_CER_CEH_all,cstemp,lncRNA_exp,
   mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
   cell_values,max_cell,cell_max,table_temp,result,result_CEH,n,m,final_result_10,ttceh,tissue_seurat,data,cell_gene,t_temp)
gc()

















tabletemp = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")
#######细胞ID与类型对应文件----------

#暑假保留数据
setwd("D:/R/script")
setwd("E:\\lcw\\lncSPA\\data\\TISCH2")
listfile = list.files()
listfile = listfile[-c(1,2,3,7)]
listfile = str_sub(listfile,1,-5)

celltype = celltype[-129,]
celltype = celltype[-142,]

celltype = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")
for(i in 1:length(listfile)){
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\data\\TISCH2\\",listfile[i],".rds",sep = ""))#读取数据
  
  temp = cancer_seurat@meta.data#细胞类型信息
  cell_type = data.frame(cell_type = temp[,4],cell_ID = rownames(temp),row.names = rownames(temp))#提取细胞编号及其对应的细胞类型
  
  for(m in 1:dim(cell_type)[1]){
    for(n in 1:dim(celltype)[1]){
      if(as.character(cell_type$cell_type[m]) == as.character(celltype$Var1[n])){
        cell_type$cell_type[m] = celltype$cell[n]
      }
    }
  }
  
  
  write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  
}


#开学补充数据
library(rhdf5)
library(hdf5r)
library(readr)
library(Seurat)
library(stringr)
setwd("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own")
listfile = list.files()
listfile = listfile[-18]
tabletemp = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")

for(i in 1:length(listfile)){
  setwd(str_c("E:\\lcw\\lncSPA\\orignal_data\\TISCH_own\\",listfile[i],sep = ""))
  listfile1 = list.files(pattern = ".tsv")
  
  cellann = read_tsv(listfile1)
  colnames(cellann)[5] = "cell_type"
  
  for(m in 1:dim(cellann)[1]){
    for(n in 1:dim(celltype)[1]){
      if(cellann$cell_type[m] == celltype$Var1[n]){##
        cellann$cell_type[m] = celltype$cell[n]##
      }
    }
  }
  
  cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$Cell)
  
  write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
}


####散装数据
celltype = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")

##GSE72056_melanoma----
data = read.table("E:\\lcw\\lncSPA\\TISCH\\GSE72056_melanoma\\GSE72056_melanoma_single_cell_revised_v2.txt",header=T,sep="\t",stringsAsFactors=F)
data = data[-1,]
data = data[-1,]


cellann = data.frame(cell = colnames(data),cell_type = t(data[1,]))
colnames(cellann) = c("cell_ID","cell_type")
cellann = cellann[-1,]

tabletemp = as.data.frame(table(cellann$cell_type))
write.xlsx(tabletemp,"D:\\Desktop\\tabletemp.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\tabletemp.xlsx")
data = data[-1,]

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(celltype)[1]){
    if(cellann$cell_type[m] == celltype$Var1[n]){##
      cellann$cell_type[m] = celltype$cell[n]##
    }
  }
}


cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_ID)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE72056_melanoma",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

##GSE75688_breast cancer----
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE75688_breast cancer\\")

celltype = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")

cellann = read.xlsx("GSE75688_umap.xlsx")



for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(celltype)[1]){
    if(cellann$cell_type[m] == celltype$Var1[n]){##
      cellann$cell_type[m] = celltype$cell[n]##
    }
  }
}


cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_id)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE75688_breast cancer",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


##GSE84465_GBM----
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE84465_GBM\\")


cellann = read.xlsx("GSE84465_GBM_umap.xlsx")



for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}



cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_id)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE84465_GBM",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#GSE103322_HNSCC----------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE103322_HNSCC\\")


cellann = read.table("GSE103322_HNSCC_metafile.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellann)[6] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE103322_HNSCC",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#GSE115978_melanoma--------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE115978_melanoma\\")

cellann = read.csv("GSE115978_cell.annotations.csv")
colnames(cellann)[3] = "cell_type"


for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cells)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

cell_gene = cellann
rownames(cell_gene) = cell_gene$cells


listfile = c("GSE115978_melanoma")
k = 1

tabletemp = rbind(tabletemp,c("","Unclassified"))
#GSE116256_AML------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE116256_AML\\")

listfile = list.files(pattern = "anno")
cellann = read.table(listfile[1],header=T,sep="\t",stringsAsFactors=F)

celltype = data.frame(cell_type = cellann$CellType,cell_ID = cellann$Cell)
for(i in 2:length(listfile)){
  cell_temp = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  celltypetemp = data.frame(cell_type = cell_temp$CellType,cell_ID = cell_temp$Cell)
  celltype = rbind(celltype,celltypetemp)
}


cellann = celltype


for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}


cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_ID)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE116256_AML",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#GSE117988_Merkel cell carcinoma-----------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE117988_Merkel cell carcinoma\\")

cellann = read.xlsx("GSE117988_umap.xlsx")
cellann$cell_id = str_replace(cellann$cell_id,"-",".")
cellann$cell_id = str_sub(cellann$cell_id,1,-3)

cellann$cell_id[str_detect(cellann$cell_sample,"PBMC")] = str_c(cellann$cell_id[str_detect(cellann$cell_sample,"PBMC")],".p",sep = "")
cellann$cell_id[str_detect(cellann$cell_sample,"Tumor")] = str_c(cellann$cell_id[str_detect(cellann$cell_sample,"Tumor")],".t",sep = "")

colnames(cellann)[4] = "cell_type"


for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}



cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_id)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE117988_Merkel cell carcinoma",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#GSE118056_Merkel cell carcinoma---------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE118056_Merkel cell carcinoma\\")

cellann = read.xlsx("GSE118056_umap.xlsx")

colnames(cellann)[4] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_id)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE118056_Merkel cell carcinoma",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#########GSE123813_BCC_Cancer-skin--------------------------------------------------


setwd("E:\\lcw\\lncSPA\\TISCH\\GSE123813_BCC_Cancer-skin\\")


cellann = read.csv("bcc_all_metadata.csv")

colnames(cellann)[5] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell.id)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE123813_BCC_Cancer-skin",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#GSE125449_liver cancer------------------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE125449_liver cancer\\")

sample1 = read.table("GSE125449_Set1_samples.txt",header=T,sep="\t",stringsAsFactors=F)
sample2 = read.table("GSE125449_Set2_samples.txt",header=T,sep="\t",stringsAsFactors=F)

sample = rbind(sample1,sample2)

colnames(sample)[3] = "cell_type"


for(m in 1:dim(sample)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(sample$cell_type[m] == tabletemp$Var1[n]){##
      sample$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = sample$cell_type,cell_ID = sample$Cell.Barcode)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE125449_liver cancer",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#GSE141982_glioma-------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE141982_glioma\\")

cellann = read.table("cellAnnotations.txt",header=F,sep="\t",stringsAsFactors=F)
colnames(cellann)[2] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$V1)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE141982_glioma",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#GSE145137_bladder_cancer--------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE145137_bladder_cancer\\")

cellann = read.xlsx("GSE145137_umap.xlsx")


for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}
cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell_id)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE145137_bladder_cancer",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#GSE146771_colon_cancer---------------------------------------------
setwd("E:\\lcw\\lncSPA\\TISCH\\GSE146771_colon_cancer\\")

cellann = read.table("CRC.Leukocyte.Smart-seq2.Metadata.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(cellann)[15] = "cell_type"

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$cell_type[m] == tabletemp$Var1[n]){##
      cellann$cell_type[m] = tabletemp$cell[n]##
    }
  }
}

cell_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$CellName)

write.table(cell_type,str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\","GSE146771_colon_cancer",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)







#lncSPA最后结果整理过程----

library(dplyr)
library(openxlsx)
library(stringr)
setwd("D:/R/script")

cancer = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\cancer.xlsx")
compartment = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\aa.xlsx")
compartment = compartment %>% distinct(Var1, .keep_all = T)


celltype = read.xlsx("E:\\lcw\\lncSPA\\result\\cell_type.xlsx")
cellcompartment = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\aa.xlsx")
celltype = celltype %>% distinct(Var1,cell, .keep_all = T)
write.xlsx(celltype,"E:\\lcw\\lncSPA\\result\\cell_type.xlsx")

celltype = as.data.frame(table(celltype$cell))

write.csv(celltype,"E:\\lcw\\lncSPA\\zhenghe\\all_cell_type.csv",row.names = F)

####TISCH_lncRNA_information.cell_num_10,,TISCH_mRNA_information.cell_num_10
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

other_RNA = other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),]

setwd("E:\\lcw\\lncSPA\\zhenghe\\final_res_10\\")
listfile = list.files()

TISCH_lncRNA = data.frame()
TISCH_mRNA = data.frame()

for(i in 1:length(listfile)){
  temp_data = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  
  for(j in 1:dim(temp_data)[1]){
    if(temp_data$cell_type[j] == "Tumor cell"){
      temp_data$cell_type[j] = "Cancer cell"
    }else if(temp_data$cell_type[j] == "Neoplatic cell"){
      temp_data$cell_type[j] = "Cancer cell"
    }else if(temp_data$cell_type[j] == "Proliferative T"){
      temp_data$cell_type[j] = "Proliferative T cell"
    }
  }
  
  temp_data$tumor_type = str_sub(listfile[i],1,-8)
  
  lnctemp = temp_data[temp_data$gene_type %in% c("lncRNA","pseudogene"),]
  mrnatemp = temp_data[temp_data$gene_type  == "mRNA",]
  
  TISCH_lncRNA = rbind(TISCH_lncRNA,lnctemp)
  TISCH_mRNA = rbind(TISCH_mRNA,mrnatemp)
}

write.table(TISCH_lncRNA,"E:\\lcw\\lncSPA\\zhenghe\\result\\TISCH_lncRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(TISCH_mRNA,"E:\\lcw\\lncSPA\\zhenghe\\result\\TISCH_mRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

rm(TISCH_lncRNA,TISCH_mRNA,lnctemp,mrnatemp,temp_data)
gc()


#统一癌症类型

data = read.table("E:\\lcw\\lncSPA\\zhenghe\\result\\2basic_information\\TISCH_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F)
cancer = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\cancer.xlsx")

TISCH_lncRNA$cancer_type = 0
TISCH_mRNA$cancer_type = 0


data = TISCH_lncRNA
data = TISCH_mRNA

for(i in 1:dim(data)[1]){
  for(j in 1:dim(cancer)[1]){
    if(data$tumor_type[i] == cancer$cancer[j]){
      data$cancer_type[i] = cancer$cancer_type[j]
      data$Dataset[i] = cancer$Dataset[j]
    }
  }
}

colnames(data)[9] = "ensembl_gene_id"
data$ensembl_gene_id = 0

#lncRNA
for(i in 1:dim(data)[1]){
  if(data$gene_type[i] == "lncRNA"){
    data$ensembl_gene_id[i] = lncRNA$ensembl_gene_id[which(lncRNA$gene_name == data$gene[i])]
  }else if(data$gene_type[i] == "pseudogene"){
    data$ensembl_gene_id[i] = other_RNA$ensembl_gene_id[which(other_RNA$gene_name == data$gene[i])]
    data$gene_type[i] = other_RNA$gene_type[which(other_RNA$gene_name == data$gene[i])]
  }
}

#mRNA
for(i in 1:dim(data)[1]){
  data$ensembl_gene_id[i] = mRNA$ensembl_gene_id[which(mRNA$gene_name == data$gene[i])]
}




write.table(data,"E:\\lcw\\lncSPA\\zhenghe\\result\\2basic_information\\TISCH_mRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#加染色体信息
data = read.table("E:\\lcw\\lncSPA\\zhenghe\\result\\2basic_information\\TISCH_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F)

data$seqnames = 0
data$start = 0
data$end = 0
data$strand = 0

#lncRNA
for(i in 1:dim(data)[1]){
  if(data$gene_type[i] == "lncRNA"){
    data$seqnames[i] = lncRNA$seqnames[which(lncRNA$gene_name == data$gene[i])]
    data$start[i] = lncRNA$start[which(lncRNA$gene_name == data$gene[i])]
    data$end[i] = lncRNA$end[which(lncRNA$gene_name == data$gene[i])]
    data$strand[i] = lncRNA$strand[which(lncRNA$gene_name == data$gene[i])]
    
    
  }else{
    data$seqnames[i] = other_RNA$seqnames[which(other_RNA$gene_name == data$gene[i])]
    data$start[i] = other_RNA$start[which(other_RNA$gene_name == data$gene[i])]
    data$end[i] = other_RNA$end[which(other_RNA$gene_name == data$gene[i])]
    data$strand[i] = other_RNA$strand[which(other_RNA$gene_name == data$gene[i])]
  }
}


#mRNA
for(i in 1:dim(data)[1]){
  data$seqnames[i] = mRNA$seqnames[which(mRNA$gene_name == data$gene[i])]
  data$start[i] = mRNA$start[which(mRNA$gene_name == data$gene[i])]
  data$end[i] = mRNA$end[which(mRNA$gene_name == data$gene[i])]
  data$strand[i] = mRNA$strand[which(mRNA$gene_name == data$gene[i])]
}








write.table(data,"E:\\lcw\\lncSPA\\zhenghe\\result\\2basic_information\\TISCH_lncRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(data,"E:\\lcw\\lncSPA\\zhenghe\\result\\2basic_information\\TISCH_mRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)




###TISCH_annotation-----------
setwd("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)

TISCH_annotation = data.frame(cancer_type = 0,dataset = 0,cell = 0,compartment = 0)

for(i in 1:length(listfile)){
  data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cell_type = as.data.frame(table(data$cell_type))
  
  cell_type$Var1 = as.character(cell_type$Var1)
  
  for(j in 1:dim(cell_type)[1]){
    if(cell_type$Var1[j] == "Tumor cell"){
      cell_type$Var1[j] = "Cancer cell"
    }else if(cell_type$Var1[j] == "Neoplatic cell"){
      cell_type$Var1[j] = "Cancer cell"
    }else if(cell_type$Var1[j] == "Proliferative T"){
      cell_type$Var1[j] = "Proliferative T cell"
    }
  }
  
  ann_temp = data.frame(cancer_type = cancer$cancer_type[which(cancer$cancer == listfile[i])],
                        dataset = cancer$Dataset[which(cancer$cancer == listfile[i])],
                        cell = cell_type$Var1)
  
  ann_temp$compartment = 0
  
  for(j in 1:dim(ann_temp)[1]){
    ann_temp$compartment[j] = compartment$compartment[which(compartment$Var1 == ann_temp$cell[j])]
  }
  
  TISCH_annotation = rbind(TISCH_annotation,ann_temp)
}
TISCH_annotation = TISCH_annotation[-1,]
write.table(TISCH_annotation,"E:\\lcw\\lncSPA\\zhenghe\\result\\1celltree\\TISCH_annotation.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

rm(cell_type,data,TISCH_annotation,ann_temp,listfile,i,j)




##TISCH_cell_CE_lncRNA_num---

TISCH_cell_CE_lncRNA_num = data.frame(cancer_type = "0",Dataset = 0,cell_type = "0",cell_num = 0,CE_num = 0)
setwd("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)
#write.xlsx(data.frame(cancer = listfile),"E:\\lcw\\lncSPA\\zhenghe\\cancer_type.xlsx")

for(i in 1:length(listfile)){
  
  cellid_type = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  CE_data = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\final_res_10\\",listfile[i],"_10.txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  
  all_cell_type = as.data.frame(table(cellid_type$cell_type))
  
  CE_cell_type = as.data.frame(table(CE_data$cell_type[which(CE_data$gene_type %in% c("lncRNA","pseudogene"))]))
  
  temp_data = data.frame(cancer_type = cancer$cancer_type[which(cancer$cancer == listfile[i])],
                         Dataset = cancer$Dataset[which(cancer$cancer == listfile[i])],
                         cell_type = all_cell_type$Var1,cell_num = all_cell_type$Freq,CE_num = 0)
  
  for(m in 1:dim(temp_data)[1]){
    for(n in 1:dim(CE_cell_type)[1]){
      if(as.character(temp_data$cell_type[m]) == as.character(CE_cell_type$Var1[n])){##
        temp_data$CE_num[m] = CE_cell_type$Freq[n]##
      }
    }
  }
  
  temp_data$cell_type = as.character(temp_data$cell_type)
  
  for(j in 1:dim(temp_data)[1]){
    if(as.character(temp_data$cell_type[j]) == "Tumor cell"){
      temp_data$cell_type[j] = "Cancer cell"
    }else if(as.character(temp_data$cell_type[j]) == "Neoplatic cell"){
      temp_data$cell_type[j] = "Cancer cell"
    }else if(as.character(temp_data$cell_type[j]) == "Proliferative T"){
      temp_data$cell_type[j] = "Proliferative T cell"
    }
  }
  
  TISCH_cell_CE_lncRNA_num = rbind(TISCH_cell_CE_lncRNA_num,temp_data)
}
TISCH_cell_CE_lncRNA_num = TISCH_cell_CE_lncRNA_num[-1,]

write.table(TISCH_cell_CE_lncRNA_num,"E:\\lcw\\lncSPA\\zhenghe\\result\\1celltree\\TISCH_cell_CE_lncRNA_num.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#TISCH_lncRNA_all_tissue_cell_exp_mean.round_4---------
library(stringr)
library(openxlsx)

cancer = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\cancer.xlsx")
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

lnc_all = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\zhenghe\\exp\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)

gene_cancer = data.frame()
for(i in 1:length(listfile)){
  data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F,check.names = F)
  data[,2:ncol(data)] = 
  data$cancer_type = cancer$cancer_type[which(cancer$cancer == listfile[i])]
  data$Dataset = cancer$Dataset[which(cancer$cancer == listfile[i])]
  data = data[data$result %in% lnc_all$gene_name,]
  data = merge(data,lnc_all[,"gene_name","ensembl_gene_id"],by = "ensembl_gene_id",all.x = T)
  
}


# all_cell_type = data.frame()
# 
# gene_cancer = data.frame()
# 
# for(i in 1:length(listfile)){
#   
#   data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
#   for(j in 1:dim(data)[1]){
#     if(data$result[j] %in% lnc_all$gene_name){
#       temp1 = data.frame(gene_name = data$result[j],
#                          ensembl_gene_id = lnc_all$ensembl_gene_id[which(lnc_all$gene_name == data$result[j])],
#                          cancer_type = cancer$cancer_type[which(cancer$cancer == listfile[i])],
#                          Dataset = cancer$Dataset[which(cancer$cancer == listfile[i])],
#                          cancer = listfile[i])
#       gene_cancer = rbind(gene_cancer,temp1)
#     }
#     
#   }
#   
#   
#   temp2 = data.frame(cell_type = colnames(data))
#   
#   all_cell_type = rbind(all_cell_type,temp2)
#   print(i)
#   
# }

celltype = read.table("E:\\lcw\\lncSPA\\zhenghe\\all_cell_type.txt",header=T,sep="\t",stringsAsFactors=F)


gene_cancer[,6:73] = NA

colnames(gene_cancer)[6:73] = as.character(celltype$Var1)




write.table(gene_cancer,"E:\\lcw\\lncSPA\\zhenghe\\result\\3bar_plot\\before_gene_cancer.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)



aaa = read.xlsx("E:\\lcw\\lncSPA\\zhenghe\\aa.xlsx")

write.table(aaa,"E:\\lcw\\lncSPA\\zhenghe\\all_cell_type_name.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#服务器
gene_cancer = read.table("E:\\lcw\\lncSPA\\zhenghe\\result\\3bar_plot\\before_gene_cancer.txt",header=T,sep="\t",stringsAsFactors=F)
setwd("E:\\lcw\\lncSPA\\zhenghe\\exp\\")

listfile = list.files()
listfile = str_sub(listfile,1,-5)

for(i in 2:length(listfile)){
  
  print(i)
  print(Sys.time())
  
  exp_data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  
  
  tabletemp = data.frame(colnames(exp_data))
  
  tabletemp = data.frame(cell_type = tabletemp[-1,])
  
  for(j in 1:dim(tabletemp)[1]){
    if(as.character(tabletemp$cell_type[j]) == "Tumor.cell"){
      tabletemp$cell_type[j] = "Cancer.cell"
    }else if(as.character(tabletemp$cell_type[j]) == "Neoplatic.cell"){
      tabletemp$cell_type[j] = "Cancer.cell"
    }else if(as.character(tabletemp$cell_type[j]) == "Proliferative.T"){
      tabletemp$cell_type[j] = "Proliferative.T.cell"
    }
  }
  
  colnames(exp_data) = c("result",tabletemp$cell_type)
  rownames(exp_data) = exp_data$result
  
  
  for(j in 1:dim(exp_data)[1]){
    for(k in 1:dim(tabletemp)[1]){
      if(rownames(exp_data)[j]%in%gene_cancer$gene_name){
        gene_cancer[(gene_cancer$gene_name == exp_data$result[j] & gene_cancer$cancer == listfile[i]),tabletemp$cell_type[k]] = round(exp_data[j,tabletemp$cell_type[k]],4)
        
      }
    }
    
  }
  
}


gene_cancer = gene_cancer[str_order(gene_cancer$gene_name),]

write.table(gene_cancer,"E:\\lcw\\lncSPA\\zhenghe\\result\\3bar_plot\\TISCH_lncRNA_all_tissue_cell_exp_mean.round_4.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)




##4.detail
##HCL.cell.cell_type.tsne_x.tsne_y.exp.round_4HCL.cell.exp_max
library(Seurat)
library(stringr)
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

all_lnc = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\")

listfile = list.files()

gene_temp = data.frame(gene = 0)
for(i in 1:(length(listfile)-1)){
  gc()
  cancer_seurat = readRDS(str_c(listfile[i],"\\\\",listfile[i],".rds"))
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  df = data.frame(gene = rownames(data) )
  gene_temp = rbind(gene_temp,df)
  print(i)
}

gene_all = read.table("E:\\lcw\\lncSPA\\zhenghe\\gene_all.txt",header=T,sep="\t",stringsAsFactors=F)


gene_all = data.frame(gene = gene_all$Var1)

gene_all = rbind(gene_all,gene_temp)


gene_all = as.data.frame(gene_all[-1,])
colnames(gene_all) = "gene"

gene_all = as.data.frame(table(gene_all$gene))

gene_all = gene_all[-1,]

gene_all = gene_all[gene_all$Var1 %in% all_lnc$gene_name,]

write.table(gene_all,"E:\\lcw\\lncSPA\\zhenghe\\gene_all.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#服务器


gene_all = read.table("E:\\lcw\\lncSPA\\zhenghe\\gene_all.txt",header=T,sep="\t",stringsAsFactors=F)



cancer = read.table("E:\\lcw\\lncSPA\\zhenghe\\cancer.txt",header=T,sep="\t",stringsAsFactors=F)

listfile = cancer$cancer



TISCH.cell.exp_max = data.frame(Gene = as.character(gene_all$Var1))
TISCH.cell.exp_max[,2:58] = "NONE"
colnames(TISCH.cell.exp_max)[2:58] = listfile
rownames(TISCH.cell.exp_max) = TISCH.cell.exp_max$Gene



final_table = data.frame(Gene = c("cancer_type","Dataset","cell","cell_type","tsne_x","tsne_y",as.character(gene_all$Var1)))

final_table[,2:58] = "NONE"
colnames(final_table)[2:58] = listfile
rownames(final_table) = final_table$Gene

final_table[1,2:58] = cancer$cancer_type
final_table[2,2:58] = cancer$Dataset



for(i in 1:length(listfile)){
  print(i)
  a1 = Sys.time()
  cell_and_type = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  for(j in 1:dim(cell_and_type)[1]){
    if(as.character(cell_and_type$cell_type[j]) == "Tumor cell"){
      cell_and_type$cell_type[j] = "Cancer cell"
    }else if(as.character(cell_and_type$cell_type[j]) == "Neoplatic cell"){
      cell_and_type$cell_type[j] = "Cancer cell"
    }else if(as.character(cell_and_type$cell_type[j]) == "Proliferative T"){
      cell_and_type$cell_type[j] = "Proliferative T cell"
    }
  }
  rownames(cell_and_type) = cell_and_type$cell_ID
  
  tsne = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[i],"\\\\",listfile[i],".tsne.cell.embeddings.txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[i],"\\\\",listfile[i],".rds",sep = ""))
  
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  
  
  final_table_temp = data.frame(Gene = c("cell","cell_type","tsne_x","tsne_y",rownames(data)[rownames(data)%in%gene_all$Var1]),data = "")
  rownames(final_table_temp) = final_table_temp$Gene
  
  
  table_temp = as.data.frame(table(cell_and_type$cell_type))
  
  for(k in 1:dim(table_temp)[1]){
    cell_temp = cell_and_type[cell_and_type$cell_type == as.character(table_temp$Var1[k]),]
    tsne_temp = tsne[rownames(cell_temp),]
    exp_temp = data[rownames(data)%in%gene_all$Var1,rownames(cell_temp)]
    cell01 = pinjie(as.character(cell_temp$cell_ID))
    cell_type01 = pinjie(as.character(cell_temp$cell_type))
    tsne_x01 = pinjie(round(tsne_temp$tSNE_1,2))
    tsne_y01 = pinjie(round(tsne_temp$tSNE_2,2))
    
    final_table_temp$data[1] = str_c(as.character(final_table_temp$data[1]),cell01,sep = ";")
    final_table_temp$data[2] = str_c(as.character(final_table_temp$data[2]),cell_type01,sep = ";")
    final_table_temp$data[3] = str_c(as.character(final_table_temp$data[3]),tsne_x01,sep = ";")
    final_table_temp$data[4] = str_c(as.character(final_table_temp$data[4]),tsne_y01,sep = ";")
    
    final_table_temp$data[5:dim(final_table_temp)[1]] = str_c(final_table_temp$data[5:dim(final_table_temp)[1]],apply(round(exp_temp,4),1,pinjie),sep = ";")
  }
  
  final_table_temp$data = str_sub(final_table_temp$data,2,-1)
  
  write.table(final_table_temp,str_c("E:\\lcw\\lncSPA\\zhenghe\\result\\4detail\\each\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  rm(final_table_temp)
  gc()
  
  for(n in 1:dim(exp_temp)[1]){
    if(rownames(exp_temp)[n] %in% TISCH.cell.exp_max$Gene){
      TISCH.cell.exp_max[rownames(exp_temp)[n],listfile[i]] = max(exp_temp[n,])
    }
  }
  i=i+1
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2)
  gc()
}


write.table(TISCH.cell.exp_max,"/bioXJ/lcw/4detail/TISCH.cell.exp_max.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(final_table,"/bioXJ/lcw/4detail/HCL.cell.cell_type.tsne_x.tsne_y.exp.round_4.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}





for(m in 1:dim(final_table_temp)[1]){
  final_table[rownames(final_table_temp)[m],listfile[i]] = final_table_temp$data[m]
}




####


library(Seurat)
library(stringr)
library(dplyr)

rm(list = ls())
gc()
pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}




gene_all = read.table("E:\\lcw\\lncSPA\\zhenghe\\gene_all.txt",header=T,sep="\t",stringsAsFactors=F)



cancer = read.table("E:\\lcw\\lncSPA\\zhenghe\\cancer.txt",header=T,sep="\t",stringsAsFactors=F)

listfile = cancer$cancer

TISCH.cell.exp_max = data.frame(Gene = as.character(gene_all$Var1))
TISCH.cell.exp_max[,2:58] = "NONE"
colnames(TISCH.cell.exp_max)[2:58] = listfile
rownames(TISCH.cell.exp_max) = TISCH.cell.exp_max$Gene



final_table = data.frame(Gene = c("cancer_type","Dataset","cell","cell_type","tsne_x","tsne_y",as.character(gene_all$Var1)))

final_table[,2:58] = "NONE"
colnames(final_table)[2:58] = listfile
rownames(final_table) = final_table$Gene

final_table[1,2:58] = cancer$cancer_type
final_table[2,2:58] = cancer$Dataset



for(i in 40:length(listfile)){
  print(i)
  a1 = Sys.time()
  cell_and_type = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  for(j in 1:dim(cell_and_type)[1]){
    if(as.character(cell_and_type$cell_type[j]) == "Tumor cell"){
      cell_and_type$cell_type[j] = "Cancer cell"
    }else if(as.character(cell_and_type$cell_type[j]) == "Neoplatic cell"){
      cell_and_type$cell_type[j] = "Cancer cell"
    }else if(as.character(cell_and_type$cell_type[j]) == "Proliferative T"){
      cell_and_type$cell_type[j] = "Proliferative T cell"
    }
  }
  rownames(cell_and_type) = cell_and_type$cell_ID
  
  tsne = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[i],"\\\\",listfile[i],".tsne.cell.embeddings.txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[i],"\\\\",listfile[i],".rds",sep = ""))
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  final_table_temp = data.frame(Gene = c("cell","cell_type","tsne_x","tsne_y",rownames(data)[rownames(data)%in%gene_all$Var1]),data = "")
  
  rownames(final_table_temp) = final_table_temp$Gene
  
  
  table_temp = as.data.frame(table(cell_and_type$cell_type))
  
  for(k in 1:dim(table_temp)[1]){
    cell_temp = cell_and_type[cell_and_type$cell_type == as.character(table_temp$Var1[k]),]
    rownames(cell_temp) = str_c("X",rownames(cell_temp),sep = "")
    tsne_temp = tsne[rownames(cell_temp),]
    exp_temp = data.frame(data[rownames(data)%in%gene_all$Var1,rownames(cell_temp)])
    cell01 = pinjie(as.character(cell_temp$cell_ID))
    cell_type01 = pinjie(as.character(cell_temp$cell_type))
    tsne_x01 = pinjie(round(tsne_temp$tSNE_1,2))
    tsne_y01 = pinjie(round(tsne_temp$tSNE_2,2))
    
    final_table_temp$data[1] = str_c(as.character(final_table_temp$data[1]),cell01,sep = ";")
    final_table_temp$data[2] = str_c(as.character(final_table_temp$data[2]),cell_type01,sep = ";")
    final_table_temp$data[3] = str_c(as.character(final_table_temp$data[3]),tsne_x01,sep = ";")
    final_table_temp$data[4] = str_c(as.character(final_table_temp$data[4]),tsne_y01,sep = ";")
    
    final_table_temp$data[5:dim(final_table_temp)[1]] = str_c(final_table_temp$data[5:dim(final_table_temp)[1]],apply(round(exp_temp,4),1,pinjie),sep = ";")
  }
  
  final_table_temp$data = str_sub(final_table_temp$data,2,-1)
  
  #  for(m in 1:dim(final_table_temp)[1]){
  #    final_table[rownames(final_table_temp)[m],listfile[i]] = final_table_temp$data[m]
  #  }
  colnames(final_table_temp)[2] = listfile[i]
  
  write.table(final_table_temp,str_c("E:\\lcw\\lncSPA\\zhenghe\\result\\4detail\\each\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  #for(n in 1:dim(exp_temp)[1]){
  #  if(rownames(exp_temp)[n] %in% TISCH.cell.exp_max$Gene){
  #   TISCH.cell.exp_max[rownames(exp_temp)[n],listfile[i]] = max(exp_temp[n,])
  #  }
  #}
  
  
  
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2)
  gc()
}




colnames(TISCH.cell.exp_max)[2:58] = colnames(final_table)[2:58]

write.table(TISCH.cell.exp_max,"/bioXJ/lcw/4detail/TISCH.cell.exp_max.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)





####TISCH.cell.exp_max
library(Seurat)
library(stringr)
library(dplyr)

rm(list = ls())
gc()
pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}


gene_all = read.table("/bioXJ/lcw/4detail/gene_all.txt",header=T,sep="\t",stringsAsFactors=F)



cancer = read.table("/bioXJ/lcw/4detail/cancer.txt",header=T,sep="\t",stringsAsFactors=F)

listfile = cancer$cancer

TISCH.cell.exp_max = data.frame(Gene = as.character(gene_all$Var1))
TISCH.cell.exp_max[,2:58] = "NONE"
colnames(TISCH.cell.exp_max)[2:58] = listfile
rownames(TISCH.cell.exp_max) = TISCH.cell.exp_max$Gene

for(i in 1:length(listfile)){
  
  cancer_seurat = readRDS(str_c("/bioXJ/lcw/4detail/TISCH/",listfile[i],"/",listfile[i],".rds",sep = ""))
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  
  
  
  lnc_exp = data[rownames(data)%in%gene_all$Var1,]
  
  for(n in 1:dim(lnc_exp)[1]){
    if(rownames(lnc_exp)[n] %in% TISCH.cell.exp_max$Gene){
      TISCH.cell.exp_max[rownames(lnc_exp)[n],listfile[i]] = max(lnc_exp[n,])
    }
  }
  
  
  
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2)
  gc()
}




colnames(TISCH.cell.exp_max)[2:58] = colnames(final_table)[2:58]
colnames(final_table)[2:58] = str_c(final_table[1,2:58],final_table[2,2:58],sep = "_") 

write.table(TISCH.cell.exp_max,"/bioXJ/lcw/4detail/TISCH.cell.exp_max.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
#write.table(final_table,str_c("/bioXJ/lcw/4detail/final_table.txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)





#######逐个生成文件

library(Seurat)
library(stringr)
library(dplyr)

rm(list = ls())
gc()
pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}




gene_all = read.table("E:\\lcw\\lncSPA\\zhenghe\\gene_all.txt",header=T,sep="\t",stringsAsFactors=F)



cancer = read.table("E:\\lcw\\lncSPA\\zhenghe\\cancer.txt",header=T,sep="\t",stringsAsFactors=F)

listfile = cancer$cancer

TISCH.cell.exp_max = data.frame(Gene = as.character(gene_all$Var1))
TISCH.cell.exp_max[,2:58] = "NONE"
colnames(TISCH.cell.exp_max)[2:58] = listfile
rownames(TISCH.cell.exp_max) = TISCH.cell.exp_max$Gene



final_table = data.frame(Gene = c("cancer_type","Dataset","cell","cell_type","tsne_x","tsne_y",as.character(gene_all$Var1)))

final_table[,2:58] = "NONE"
colnames(final_table)[2:58] = listfile
rownames(final_table) = final_table$Gene

final_table[1,2:58] = cancer$cancer_type
final_table[2,2:58] = cancer$Dataset


i=56
for(i in 40:length(listfile)){
  print(i)
  a1 = Sys.time()
  cell_and_type = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  for(j in 1:dim(cell_and_type)[1]){
    if(as.character(cell_and_type$cell_type[j]) == "Tumor cell"){
      cell_and_type$cell_type[j] = "Cancer cell"
    }else if(as.character(cell_and_type$cell_type[j]) == "Neoplatic cell"){
      cell_and_type$cell_type[j] = "Cancer cell"
    }else if(as.character(cell_and_type$cell_type[j]) == "Proliferative T"){
      cell_and_type$cell_type[j] = "Proliferative T cell"
    }
  }
  rownames(cell_and_type) = cell_and_type$cell_ID
  
  tsne = read.table(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[i],"\\\\",listfile[i],".tsne.cell.embeddings.txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\zhenghe\\TICSH\\",listfile[i],"\\\\",listfile[i],".rds",sep = ""))
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  final_table_temp = data.frame(Gene = c("cell","cell_type","tsne_x","tsne_y",rownames(data)[rownames(data)%in%gene_all$Var1]),data = "")
  
  rownames(final_table_temp) = final_table_temp$Gene
  
  
  table_temp = as.data.frame(table(cell_and_type$cell_type))
  
  for(k in 1:dim(table_temp)[1]){
    cell_temp = cell_and_type[cell_and_type$cell_type == as.character(table_temp$Var1[k]),]
    #rownames(cell_temp) = str_replace(rownames(cell_temp),"-",".")
    tsne_temp = tsne[rownames(cell_temp),]
    exp_temp = data.frame(data[rownames(data)%in%gene_all$Var1,rownames(cell_temp)])
    cell01 = pinjie(as.character(cell_temp$cell_ID))
    cell_type01 = pinjie(as.character(cell_temp$cell_type))
    tsne_x01 = pinjie(round(tsne_temp$tSNE_1,2))
    tsne_y01 = pinjie(round(tsne_temp$tSNE_2,2))
    
    final_table_temp$data[1] = str_c(as.character(final_table_temp$data[1]),cell01,sep = ";")
    final_table_temp$data[2] = str_c(as.character(final_table_temp$data[2]),cell_type01,sep = ";")
    final_table_temp$data[3] = str_c(as.character(final_table_temp$data[3]),tsne_x01,sep = ";")
    final_table_temp$data[4] = str_c(as.character(final_table_temp$data[4]),tsne_y01,sep = ";")
    
    final_table_temp$data[5:dim(final_table_temp)[1]] = str_c(final_table_temp$data[5:dim(final_table_temp)[1]],apply(round(exp_temp,4),1,pinjie),sep = ";")
  }
  
  final_table_temp$data = str_sub(final_table_temp$data,2,-1)
  
  #  for(m in 1:dim(final_table_temp)[1]){
  #    final_table[rownames(final_table_temp)[m],listfile[i]] = final_table_temp$data[m]
  #  }
  colnames(final_table_temp)[2] = listfile[i]
  
  write.table(final_table_temp,str_c("E:\\lcw\\lncSPA\\zhenghe\\result\\4detail\\each\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  #for(n in 1:dim(exp_temp)[1]){
  #  if(rownames(exp_temp)[n] %in% TISCH.cell.exp_max$Gene){
  #   TISCH.cell.exp_max[rownames(exp_temp)[n],listfile[i]] = max(exp_temp[n,])
  #  }
  #}
  
  
  
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2)
  gc()
}




colnames(TISCH.cell.exp_max)[2:58] = colnames(final_table)[2:58]

write.table(TISCH.cell.exp_max,"/bioXJ/lcw/4detail/TISCH.cell.exp_max.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#########10.21师姐那里领的文件---------------------------
library(Seurat)
library(stringr)
library(dplyr)
library(openxlsx)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

getwd()
setwd("D:/R/script")
setwd("E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\")
listfile = list.files()

all_cell_type = data.frame()
for(i in 1:length(listfile)){
  temp = read.table(str_c("E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\",listfile[i],"\\\\",listfile[i],".label.txt",sep = ""))
  all_cell_type = rbind(all_cell_type,temp)
}
cell_type = as.data.frame(table(all_cell_type$Var1))
write.xlsx(cell_type,"D:\\Desktop\\cell_type.xlsx")

tabletemp = read.xlsx("D:\\Desktop\\cell_type.xlsx")#统一的细胞类型
write.table(tabletemp,"E:\\lcw\\lncSPA\\xukang\\cell_type.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


for(k in 1:length(listfile)){
  print(k)
  s1 = Sys.time()
  print(s1)
  
  tissue_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\",listfile[k],"\\\\",listfile[k],".rds",sep = ""))
  
  tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  
  temp = tissue_seurat@meta.data
  
  cellann = data.frame(cell_type = as.character(temp$Majority_voting_CellTypist_high),cell_ID = rownames(temp))
  gc()
  for(m in 1:dim(cellann)[1]){
    for(n in 1:dim(tabletemp)[1]){
      if(cellann$cell_type[m] == tabletemp$Var1[n]){##
        cellann$cell_type[m] = tabletemp$cell[n]##
      }
    }
  }
  #细胞ID--细胞类型对应文件
  write.table(cellann,str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\cellid_type\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  gc()
  cell_gene = cellann
  rownames(cell_gene) = cell_gene$cell_ID
  
  data = tissue_seurat[["RNA"]]@data
  
  table_temp = as.data.frame(table(cell_gene$cell_type))
  
  result = rownames(data)
  
  for(i in 1:dim(table_temp)[1]){
    cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
    cell_values = apply(as.data.frame(cell_exp),1,mean)#cell_values <- rowMeans(cell_exp)#
    result <- cbind(result,cell_values)
    colnames(result)[i+1] = as.character(table_temp$Var1[i])
  }
  #细胞类型表达均值文件
  write.table(result,str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\exp\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  gc()
  result = result[,-1]
  result = as.data.frame(result)
  mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
  lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
  pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]
  
  
  CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
  for(i in 1:dim(result)[1]){
    cell_max = max(as.numeric(result[i,]))
    max_cell = colnames(result)[which.max(result[i,])]
    tt = result[i,-(which.max(result[i,]))]
    remain_max = max(as.numeric(tt))
    remain_mean = mean(as.numeric(tt))
    cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
    CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
  }
  CS_CER_CEH_all = CS_CER_CEH_all[-1,]
  rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
  #CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
  final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  for(i in 1:dim(CS_CER_CEH_all)[1]){
    if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
    else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
    else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
      if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
          if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
            tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                               remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                               cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
            final_result_CS = rbind(final_result_CS,tempf)
          }
        }
      } 
    }
  }
  final_result_CS = final_result_CS[-1,]
  gc()
  remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
  #CER 在该细胞中的表达大于其他最大值的五倍
  final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
    if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
    else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
    else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
        if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                             remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                             cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
          final_result_CER = rbind(final_result_CER,tempf)
        }
      } 
    }
  }
  final_result_CER = final_result_CER[-1,]
  gc()
  remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
  #CEH 在该细胞中的表达大于其他均值的五倍
  final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
  result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
  for(i in 1:dim(result_CEH)[1]){
    if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.01){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.01){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "mRNA")
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
    else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.001){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.001){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "lncRNA")
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
    else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
      if(max(as.numeric(result_CEH[i,]))>0.001){
        tt = as.data.frame(result_CEH[i,])
        cell_mean = ""
        remain_data = ""
        remain_mean = ""
        cell_type = ""
        for(m in 1:dim(result_CEH)[2]){
          if(as.numeric(tt[1,m])>0.001){
            if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
              cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
              remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
              remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
              cell_type = str_c(cell_type,",",colnames(tt)[m])
            }
          }
        }
        tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                           remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                           cell_type = cell_type,gene_type = "pseudogene")
        
        final_result_CEH = rbind(final_result_CEH,tempf)
      }
    }
  }
  final_result_CEH = final_result_CEH[-1,]
  gc()
  tt1 = c()
  for(i in 1:dim(final_result_CEH)[1]){
    if(final_result_CEH$cell_exp[i]==""){
      tt1 = c(tt1,i)
    }
  }
  final_result_CEH = final_result_CEH[-tt1,]
  final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
  final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
  final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
  final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)
  
  ttceh = data.frame()
  for(i in 1:dim(final_result_CEH)[1]){
    
    if(str_detect(final_result_CEH$cell_exp[i],",")){
      tt1 = final_result_CEH[i,]
      for(j in 1:length(strsplit(tt1$cell_exp[1],",")[[1]])){
        t_temp = data.frame(gene = tt1$gene[1],cell_exp = strsplit(tt1$cell_exp[1],",")[[1]][j],
                            remain_max = strsplit(tt1$remain_max[1],",")[[1]][j],
                            remain_mean = strsplit(tt1$remain_mean[1],",")[[1]][j],class = tt1$class[1],
                            cell_type = strsplit(tt1$cell_type[1],",")[[1]][j],gene_type = tt1$gene_type[1])
        ttceh = rbind(ttceh,t_temp)
      }
    }
  }
  
  final_result_CEH = rbind(final_result_CEH,ttceh)
  gc()
  
  
  tt1 = c()
  for(i in 1:dim(final_result_CEH)[1]){
    if(str_detect(final_result_CEH$cell_exp[i],",")){
      tt1 = c(tt1,i)
    }
  }
  
  if(length(tt1) >0){final_result_CEH = final_result_CEH[-tt1,]}
  
  final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)
  
  final_result$cell_num_value = 0
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  for(i in 1:dim(final_result)[1]){
    
    temp = data[final_result$gene[i],colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == final_result$cell_type[i]),])]##
    
    final_result$cell_num_value[i] = sum(temp!=0)
  }
  
  final_result_10 = final_result[final_result$cell_num_value>=10,]
  
  
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  write.table(final_result,str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\final_res\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  write.table(final_result_10,str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\final_res_10\\",listfile[k],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  rm(tissue_seurat,data,result,cellann,cell_exp,cell_gene,table_temp,m,n,tt,final_result_10,
     tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,
     cell_exp,temp,CS_CER_CEH_all,cstemp,lncRNA_exp,
     mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
     cell_values,max_cell,cell_max,result_CEH,ttceh,t_temp)
  gc()
  s2 = Sys.time()
  print(s2-s1)
  
}


#########结果整合
###tissue_annotation-----------
setwd("E:\\lcw\\lncSPA\\xukang\\zhenghe\\cellid_type\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)
tissue_name = read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")

tissue_annotation = data.frame(tissue_type = 0,cell = 0,compartment = 0)

for(i in 1:length(listfile)){
  data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cell_type = as.data.frame(table(data$cell_type))
  
  cell_type$Var1 = as.character(cell_type$Var1)
  
  
  ann_temp = data.frame(tissue_type = tissue_name$V2[which(tissue_name$V1 == listfile[i])],
                        cell = cell_type$Var1)
  
  ann_temp$compartment = 0
  
  #for(j in 1:dim(ann_temp)[1]){
  #  ann_temp$compartment[j] = compartment$compartment[which(compartment$Var1 == ann_temp$cell[j])]
  #}
  
  tissue_annotation = rbind(tissue_annotation,ann_temp)
}
tissue_annotation = tissue_annotation[-1,]
write.table(tissue_annotation,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\1celltree\\tissue_annotation.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

rm(cell_type,data,TISCH_annotation,ann_temp,listfile,i,j)

tissue_annotation = read.table("E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\1celltree\\tissue_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
cell_annotation = read.xlsx("E:\\lcw\\lncSPA\\xukang\\cell_type.xlsx")

for(i in 1:dim(cell_annotation)[1]){
  tissue_annotation$compartment[tissue_annotation$cell == cell_annotation$cell[i]] = cell_annotation$compartment[i]
}
write.table(tissue_annotation,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\1celltree\\tissue_annotation.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)




##tissue_cell_CE_lncRNA_num---

tissue_cell_CE_lncRNA_num = data.frame(tissue_type = "0",cell_type = "0",cell_num = 0,CE_num = 0)
setwd("E:\\lcw\\lncSPA\\xukang\\zhenghe\\cellid_type\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)
#write.xlsx(data.frame(cancer = listfile),"E:\\lcw\\lncSPA\\zhenghe\\cancer_type.xlsx")

for(i in 1:length(listfile)){
  
  cellid_type = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  CE_data = read.table(str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\final_res_10\\",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  
  all_cell_type = as.data.frame(table(cellid_type$cell_type))
  
  CE_cell_type = as.data.frame(table(CE_data$cell_type[which(CE_data$gene_type %in% c("lncRNA","pseudogene"))]))
  
  temp_data = data.frame(tissue_type = tissue_name$V2[which(tissue_name$V1 == listfile[i])],
                         cell_type = all_cell_type$Var1,cell_num = all_cell_type$Freq,CE_num = 0)
  
  for(m in 1:dim(temp_data)[1]){
    for(n in 1:dim(CE_cell_type)[1]){
      if(as.character(temp_data$cell_type[m]) == as.character(CE_cell_type$Var1[n])){##
        temp_data$CE_num[m] = CE_cell_type$Freq[n]##
      }
    }
  }
  
  
  
  tissue_cell_CE_lncRNA_num = rbind(tissue_cell_CE_lncRNA_num,temp_data)
}
tissue_cell_CE_lncRNA_num = tissue_cell_CE_lncRNA_num[-1,]

write.table(tissue_cell_CE_lncRNA_num,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\1celltree\\tissue_cell_CE_lncRNA_num.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)







####2.TISCH_lncRNA_information.cell_num_10,,TISCH_mRNA_information.cell_num_10
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

other_RNA = other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),]
tissue_name = read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")
setwd("E:\\lcw\\lncSPA\\xukang\\zhenghe\\final_res_10\\")
listfile = list.files()

tissue_lncRNA = data.frame()
tissue_mRNA = data.frame()

for(i in 1:length(listfile)){
  temp_data = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  
  
  temp_data$tissue_type = tissue_name$V2[which(tissue_name$V1 == str_sub(listfile[i],1,-5))]
  
  lnctemp = temp_data[temp_data$gene_type %in% c("lncRNA","pseudogene"),]
  mrnatemp = temp_data[temp_data$gene_type  == "mRNA",]
  
  tissue_lncRNA = rbind(tissue_lncRNA,lnctemp)
  tissue_mRNA = rbind(tissue_mRNA,mrnatemp)
}

data = tissue_lncRNA
data = tissue_mRNA


data$ensembl_gene_id = 0

#lncRNA
for(i in 1:dim(data)[1]){
  if(data$gene_type[i] == "lncRNA"){
    data$ensembl_gene_id[i] = lncRNA$ensembl_gene_id[which(lncRNA$gene_name == data$gene[i])]
  }else if(data$gene_type[i] == "pseudogene"){
    data$ensembl_gene_id[i] = other_RNA$ensembl_gene_id[which(other_RNA$gene_name == data$gene[i])]
    data$gene_type[i] = other_RNA$gene_type[which(other_RNA$gene_name == data$gene[i])]
  }
}

#mRNA
for(i in 1:dim(data)[1]){
  data$ensembl_gene_id[i] = mRNA$ensembl_gene_id[which(mRNA$gene_name == data$gene[i])]
}



data$seqnames = 0
data$start = 0
data$end = 0
data$strand = 0

#lncRNA
for(i in 1:dim(data)[1]){
  if(data$gene_type[i] == "lncRNA"){
    data$seqnames[i] = lncRNA$seqnames[which(lncRNA$gene_name == data$gene[i])]
    data$start[i] = lncRNA$start[which(lncRNA$gene_name == data$gene[i])]
    data$end[i] = lncRNA$end[which(lncRNA$gene_name == data$gene[i])]
    data$strand[i] = lncRNA$strand[which(lncRNA$gene_name == data$gene[i])]
    
    
  }else{
    data$seqnames[i] = other_RNA$seqnames[which(other_RNA$gene_name == data$gene[i])]
    data$start[i] = other_RNA$start[which(other_RNA$gene_name == data$gene[i])]
    data$end[i] = other_RNA$end[which(other_RNA$gene_name == data$gene[i])]
    data$strand[i] = other_RNA$strand[which(other_RNA$gene_name == data$gene[i])]
  }
}


#mRNA
for(i in 1:dim(data)[1]){
  data$seqnames[i] = mRNA$seqnames[which(mRNA$gene_name == data$gene[i])]
  data$start[i] = mRNA$start[which(mRNA$gene_name == data$gene[i])]
  data$end[i] = mRNA$end[which(mRNA$gene_name == data$gene[i])]
  data$strand[i] = mRNA$strand[which(mRNA$gene_name == data$gene[i])]
}


write.table(data,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\2basic_information\\tissue_lncRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(data,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\2basic_information\\tissue_mRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

###############
###############
###############
library(stringr)
library(openxlsx)

tissue_name = read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

all_lnc = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\xukang\\zhenghe\\exp\\")

listfile = list.files()
listfile = str_sub(listfile,1,-5)

all_cell_type = data.frame()

#read.table("E:\\lcw\\lncSPA\\xukang\\cell_type.txt",header = F,sep="\t")

gene_cancer = data.frame()

for(i in 1:length(listfile)){
  
  data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F,check.names = F)
  for(j in 1:dim(data)[1]){
    if(data$result[j] %in% all_lnc$gene_name){
      temp1 = data.frame(gene_name = data$result[j],
                         ensembl_gene_id = all_lnc$ensembl_gene_id[which(all_lnc$gene_name == data$result[j])],
                         tissue_type = tissue_name$V2[which(tissue_name$V1 == listfile[i])])
      gene_cancer = rbind(gene_cancer,temp1)
    }
    
  }
  
  
  temp2 = data.frame(cell_type = colnames(data))
  
  all_cell_type = rbind(all_cell_type,temp2)
  print(i)
  
}


celltype = read.table("E:\\lcw\\lncSPA\\xukang\\cell_type.txt",header=T,sep="\t",stringsAsFactors=F)


gene_cancer[,4:18] = NA

colnames(gene_cancer)[4:18] = as.character(celltype$cell)




write.table(gene_cancer,"E:\\lcw\\lncSPA\\xukang\\before_lnc_gene.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

write.xlsx(celltype,"E:\\lcw\\lncSPA\\xukang\\cell_type.xlsx")



write.table(aaa,"E:\\lcw\\lncSPA\\zhenghe\\all_cell_type_name.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#服务器
tissue_name = read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")
gene_cancer = read.table("E:\\lcw\\lncSPA\\xukang\\before_lnc_gene.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
gene_cancer = gene_cancer %>% distinct(tissue_type,gene_name,ensembl_gene_id, .keep_all = T)

celltype = read.xlsx("E:\\lcw\\lncSPA\\xukang\\cell_type.xlsx")

setwd("E:\\lcw\\lncSPA\\xukang\\zhenghe\\exp\\")

listfile = list.files()
listfile = str_sub(listfile,1,-5)

for(i in 1:length(listfile)){
  
  print(i)
  print(Sys.time())
  a1 = Sys.time()
  exp_data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F,check.names = F)
  
  
  
  tabletemp = data.frame(colnames(exp_data))
  
  tabletemp = data.frame(cell_type = tabletemp[-1,])
  
  
  colnames(exp_data) = c("result",tabletemp$cell_type)
  rownames(exp_data) = exp_data$result
  
  
  for(j in 1:dim(exp_data)[1]){
    for(k in 1:dim(tabletemp)[1]){
      if(rownames(exp_data)[j]%in%gene_cancer$gene_name){
        gene_cancer[(gene_cancer$gene_name == exp_data$result[j] & gene_cancer$tissue_type == tissue_name$V2[which(tissue_name$V1 == listfile[i])]),tabletemp$cell_type[k]] = round(exp_data[j,tabletemp$cell_type[k]],4)
        
      }
    }
    
  }
  
  a2 = Sys.time()
  print(a2-a1)
}


gene_cancer = gene_cancer[str_order(gene_cancer$gene_name),]



write.table(gene_cancer,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\3bar_plot\\tissue_lncRNA_all_tissue_cell_exp_mean.round_4.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


##4.detail
##HCL.cell.cell_type.tsne_x.tsne_y.exp.round_4HCL.cell.exp_max
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

all_lnc = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\xukang\\zhenghe\\exp\\")
listfile = list.files()

gene_temp = data.frame(gene = 0)

for(i in 1:length(listfile)){
  gc()
  data = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
  
  df = data.frame(gene = data$result)
  gene_temp = rbind(gene_temp,df)
  print(i)
}
gene_temp = as.data.frame(gene_temp[-1,])

gene_all_lnc = as.data.frame(table(gene_temp$`gene_temp[-1, ]`))

gene_all_lnc = gene_all_lnc[gene_all_lnc$Var1 %in% all_lnc$gene_name,]
gene_all_lnc = as_data_frame(gene_all_lnc[,-2])
colnames(gene_all_lnc)[1] = "gene"

write.table(gene_all_lnc,"E:\\lcw\\lncSPA\\xukang\\all_lnc_gene.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#cell.exp.max
library(Seurat)
library(stringr)
library(dplyr)

rm(list = ls())
gc()
pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}


gene_all = read.table("E:\\lcw\\lncSPA\\xukang\\all_lnc_gene.txt",header=T,sep="\t",stringsAsFactors=F)



cancer = read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")

listfile = cancer$V1

tissue.cell.exp_max = data.frame(Gene = as.character(gene_all$gene))
tissue.cell.exp_max[,2:18] = "NONE"
colnames(tissue.cell.exp_max)[2:18] = listfile
rownames(tissue.cell.exp_max) = tissue.cell.exp_max$Gene

for(i in 1:length(listfile)){
  print(i)
  a1 = Sys.time()
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\",listfile[i],"\\\\",listfile[i],".rds",sep = ""))
  cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  
  
  lnc_exp = data[rownames(data)%in%gene_all$gene,]
  
  for(n in 1:dim(lnc_exp)[1]){
    if(rownames(lnc_exp)[n] %in% tissue.cell.exp_max$Gene){
      tissue.cell.exp_max[rownames(lnc_exp)[n],listfile[i]] = max(lnc_exp[n,])
    }
  }
  
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2,lnc_exp,data)
  gc()
}


colnames(tissue.cell.exp_max)[2:18] = cancer$V2

write.table(tissue.cell.exp_max,"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\4detail\\tissue.cell.exp_max.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)





#######逐个生成文件

library(Seurat)
library(stringr)
library(dplyr)

rm(list = ls())
gc()
pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}




gene_all = read.table("E:\\lcw\\lncSPA\\xukang\\all_lnc_gene.txt",header=T,sep="\t",stringsAsFactors=F)



cancer = read.table("E:\\lcw\\lncSPA\\xukang\\ts.txt",header = F,sep="\t")

listfile = cancer$V1

for(i in 1:length(listfile)){
  print(i)
  a1 = Sys.time()
  cell_and_type = read.table(str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\cellid_type\\",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  rownames(cell_and_type) = cell_and_type$cell_ID
  
  tsne = read.table(str_c("E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\",listfile[i],"\\\\",listfile[i],".tsne.cell.embeddings.txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cancer_seurat = readRDS(str_c("E:\\lcw\\lncSPA\\xukang\\Data\\codedata\\tissue_rds\\",listfile[i],"\\\\",listfile[i],".rds",sep = ""))
  cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  final_table_temp = data.frame(Gene = c("cell","cell_type","tsne_x","tsne_y",rownames(data)[rownames(data)%in%gene_all$gene]),data = "")
  
  rownames(final_table_temp) = final_table_temp$Gene
  
  
  table_temp = as.data.frame(table(cell_and_type$cell_type))
  
  for(k in 1:dim(table_temp)[1]){
    cell_temp = cell_and_type[cell_and_type$cell_type == as.character(table_temp$Var1[k]),]
    #rownames(cell_temp) = str_replace(rownames(cell_temp),"-",".")
    tsne_temp = tsne[rownames(cell_temp),]
    exp_temp = data.frame(data[rownames(data)%in%gene_all$gene,rownames(cell_temp)])
    cell01 = pinjie(as.character(cell_temp$cell_ID))
    cell_type01 = pinjie(as.character(cell_temp$cell_type))
    tsne_x01 = pinjie(round(tsne_temp$tSNE_1,2))
    tsne_y01 = pinjie(round(tsne_temp$tSNE_2,2))
    
    final_table_temp$data[1] = str_c(as.character(final_table_temp$data[1]),cell01,sep = ";")
    final_table_temp$data[2] = str_c(as.character(final_table_temp$data[2]),cell_type01,sep = ";")
    final_table_temp$data[3] = str_c(as.character(final_table_temp$data[3]),tsne_x01,sep = ";")
    final_table_temp$data[4] = str_c(as.character(final_table_temp$data[4]),tsne_y01,sep = ";")
    
    final_table_temp$data[5:dim(final_table_temp)[1]] = str_c(final_table_temp$data[5:dim(final_table_temp)[1]],apply(round(exp_temp,4),1,pinjie),sep = ";")
  }
  
  final_table_temp$data = str_sub(final_table_temp$data,2,-1)
  
  #  for(m in 1:dim(final_table_temp)[1]){
  #    final_table[rownames(final_table_temp)[m],listfile[i]] = final_table_temp$data[m]
  #  }
  colnames(final_table_temp)[2] = listfile[i]
  
  write.table(final_table_temp,str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\4detail\\each\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  #for(n in 1:dim(exp_temp)[1]){
  #  if(rownames(exp_temp)[n] %in% TISCH.cell.exp_max$Gene){
  #   TISCH.cell.exp_max[rownames(exp_temp)[n],listfile[i]] = max(exp_temp[n,])
  #  }
  #}
  
  
  
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2,final_table_temp)
  gc()
}




colnames(TISCH.cell.exp_max)[2:58] = colnames(final_table)[2:58]

write.table(TISCH.cell.exp_max,"/bioXJ/lcw/4detail/TISCH.cell.exp_max.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


aa = read.table("E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\4detail\\each\\BLD.txt",header=T,sep="\t",stringsAsFactors=F)



#####统计----
library(openxlsx)
library(stringr)
library(dplyr)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\cell_res_compart.txt",header=T,sep="\t",stringsAsFactors=F)
hcl = read.table("E:\\lcw\\lncSPA\\统计\\hcl_compart.txt",header=T,sep="\t",stringsAsFactors=F)
other = read.table("E:\\lcw\\lncSPA\\统计\\other_compart.txt",header=T,sep="\t",stringsAsFactors=F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\tts_compart.txt",header=T,sep="\t",stringsAsFactors=F)

data = tts

for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(The Tabula Sapiens)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=tts",sep = "")
}

tts = data

#cell_res
cancer_Adult = cell_res[,c(3,4)]


#hcl
normal_Adult = hcl[str_detect(hcl$tissue_type,"Adult"),c(3,4)]
normal_fetal = hcl[str_detect(hcl$tissue_type,"Fetal"),c(3,4)]

#other
cancer_Adult = rbind(cancer_Adult,other[str_detect(other$tissue_type,"Adult"),c(3,4)])
cancer_fetal = other[str_detect(other$tissue_type,"Pediatric"),c(3,4)]

#tts
normal_Adult = rbind(normal_Adult,tts[,c(3,4)])


normal_Adult$tissue_full = str_sub(normal_Adult$tissue_full,7,-1)
normal_Adult$tissue = str_sub(normal_Adult$tissue,7,-1)

cancer_Adult$tissue_full = str_sub(cancer_Adult$tissue_full,7,-1)
cancer_Adult$tissue = str_sub(cancer_Adult$tissue,7,-1)


#tisch
tisch = read.table("E:\\lcw\\lncSPA\\统计\\TISCH_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tisch$tissue_type = str_c(tisch$cancer_type,tisch$dataset,sep = "_")
tisch = tisch %>% distinct(tissue_type, .keep_all = T)

data = tisch

for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$cancer_type[i],"(",data$dataset[i],")",sep = "")
  data$tissue[i] = str_c(data$cancer_type[i],"=geo",sep = "")
}

tisch = data

cancer_Adult = read.table("E:\\lcw\\lncSPA\\统计\\cancer_Adult.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_Adult = rbind(cancer_Adult,tisch[,c(6,7)])

###tica----
normal_Adult = read.table("E:\\lcw\\lncSPA\\统计\\normal_Adult.txt",header=T,sep="\t",stringsAsFactors=F)
tica = read.table("E:\\lcw\\lncSPA\\统计\\tica_compartment.txt",header=T,sep="\t",stringsAsFactors=F)

tica = tica %>% distinct(tissue_type, .keep_all = T)

data = tica

for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(TICA)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=tica",sep = "")
}

tica = data

normal_Adult = rbind(normal_Adult,tica[,c(5,6)])



write.table(cancer_Adult,"E:\\lcw\\lncSPA\\统计\\cancer_Adult.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(normal_Adult,"E:\\lcw\\lncSPA\\统计\\normal_Adult.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(normal_fetal,"E:\\lcw\\lncSPA\\统计\\normal_fetal.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(cancer_fetal,"E:\\lcw\\lncSPA\\统计\\cancer_fetal.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)



data = other
data$tissue_type = str_replace(data$tissue_type,pattern = "_","-")

for(i in 1:dim(data)[1]){
  if(str_split(data$tissue_type[i],pattern = "-")[[1]][1] == "Adult"){
    data$tissue_type[i] = str_split(data$tissue_type[i],pattern = "-")[[1]][2]
    data$tissue_full[i] = str_c(data$tissue_type[i],"(Human Cell Landscape)",sep = "")
    data$tissue[i] = str_c(data$tissue_type[i],"_hcl",sep = "")
  }else{
    data$tissue_type[i] = str_replace(data$tissue_type[i],pattern = "-","_")
    data$tissue_full[i] = str_c(data$tissue_type[i],"(Human Cell Landscape)",sep = "")
    data$tissue[i] = str_c(data$tissue_type[i],"_hcl",sep = "")
  }
  
}

######TIGER 4套数据----------------------
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

#####################CRC_GSE132257------------------------
library(patchwork)
library(Seurat)
library(stringr)

data = read.table("E:\\lcw\\lncSPA\\tiger_data\\used_data\\CRC_GSE132257\\GSE132257_GEO_processed_protocol_and_fresh_frozen_raw_UMI_count_matrix.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
rownames(data) = data$Index
data = data[,-1]

cellann = read.table("E:\\lcw\\lncSPA\\tiger_data\\used_data\\CRC_GSE132257\\GSE132257_processed_protocol_and_fresh_frozen_cell_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(cellann$Cell_type))
tabletemp$cell = c("B cell","Epithelial cell","Mast cell","Myeloid cell","Stromal cell","T cell","Unclassified")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$Cell_type[m] == tabletemp$Var1[n]){##
      cellann$Cell_type[m] = tabletemp$cell[n]##
    }
  }
}


cellann$Index = str_replace_all(cellann$Index,"-",".")
colnames(cellann)[1] = "cell"
colnames(cellann)[6] = "cell_type"

cellid_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell)
write.table(cellid_type,str_c("E:\\lcw\\lncSPA\\TIGER\\cellid_type\\","CRC_GSE132257",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


cancer_seurat <- CreateSeuratObject(counts = data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data

cell_gene = as.data.frame(cellann)
rownames(cell_gene) = cell_gene$cell


#####################CRC_GSE144735------------------------
library(patchwork)
library(Seurat)
library(stringr)
library(dplyr)

data = read.table("E:\\lcw\\lncSPA\\tiger_data\\used_data\\CRC_GSE144735\\GSE144735_processed_KUL3_CRC_10X_raw_UMI_count_matrix.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
rownames(data) = data$Index
data = data[,-1]

cellann = read.table("E:\\lcw\\lncSPA\\tiger_data\\used_data\\CRC_GSE144735\\GSE144735_processed_KUL3_CRC_10X_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tabletemp = as.data.frame(table(cellann$Cell_type))
tabletemp$cell = c("B cell","Epithelial cell","Mast cell","Myeloid cell","Stromal cell","T cell")

for(m in 1:dim(cellann)[1]){
  for(n in 1:dim(tabletemp)[1]){
    if(cellann$Cell_type[m] == tabletemp$Var1[n]){##
      cellann$Cell_type[m] = tabletemp$cell[n]##
    }
  }
}



colnames(cellann)[1] = "cell"
colnames(cellann)[5] = "cell_type"

cellid_type = data.frame(cell_type = cellann$cell_type,cell_ID = cellann$cell)
write.table(cellid_type,str_c("E:\\lcw\\lncSPA\\TIGER\\cellid_type\\","CRC_GSE144735",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


cancer_seurat <- CreateSeuratObject(counts = data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)

cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)

data = cancer_seurat[["RNA"]]@data

cell_gene = as.data.frame(cellann)
rownames(cell_gene) = cell_gene$cell





















table_temp = as.data.frame(table(cell_gene$cell_type))

result = rownames(data)

for(i in 1:dim(table_temp)[1]){
  cell_exp = data[,colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == table_temp$Var1[i]),])]##
  cell_values <- rowMeans(cell_exp)#cell_values = apply(as.data.frame(cell_exp),1,mean)#
  result <- cbind(result,cell_values)
  colnames(result)[i+1] = as.character(table_temp$Var1[i])
}


write.table(result,str_c("E:\\lcw\\lncSPA\\TIGER\\exp\\","CRC_GSE144735",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

gc()
result = result[,-1]
result = as.data.frame(result)
mRNA_exp = result[rownames(result) %in% mRNA$gene_name,]
lncRNA_exp = result[(rownames(result) %in% lncRNA$gene_name),]
pse_exp = result[rownames(result) %in% (other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),9]),]


CS_CER_CEH_all = data.frame(gene = "0",cell_exp = 0,cell = 0,remain_max = 0,remain_mean = 0)
for(i in 1:dim(result)[1]){
  cell_max = max(as.numeric(result[i,]))
  max_cell = colnames(result)[which.max(result[i,])]
  tt = result[i,-(which.max(result[i,]))]
  remain_max = max(as.numeric(tt))
  remain_mean = mean(as.numeric(tt))
  cstemp = data.frame(gene = rownames(result[i,]),cell_exp = cell_max,cell = max_cell,remain_max = remain_max,remain_mean = remain_mean)
  CS_CER_CEH_all = rbind(CS_CER_CEH_all,cstemp)
}
CS_CER_CEH_all = CS_CER_CEH_all[-1,]
rownames(CS_CER_CEH_all) = CS_CER_CEH_all$gene
#CS 只在这个细胞中大于阈值（0.01） #并且大于其他最大值的五倍
final_result_CS = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
for(i in 1:dim(CS_CER_CEH_all)[1]){
  if((CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.01){
      if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.01){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                             remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                             cell_type = CS_CER_CEH_all$cell[i],gene_type = "mRNA")
          final_result_CS = rbind(final_result_CS,tempf)
        }
      }
    } 
  }
  else if((CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                             remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                             cell_type = CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
          final_result_CS = rbind(final_result_CS,tempf)
        }
      }
    } 
  }
  else if((CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
    if(as.numeric(CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(CS_CER_CEH_all$remain_max[i])<0.001){
        if(as.numeric(CS_CER_CEH_all$cell_exp[i])>5*as.numeric(CS_CER_CEH_all$remain_max[i])){
          tempf = data.frame(gene = CS_CER_CEH_all$gene[i],cell_exp = CS_CER_CEH_all$cell_exp[i],
                             remain_max = CS_CER_CEH_all$remain_max[i],remain_mean = CS_CER_CEH_all$remain_mean[i],class = "CS",
                             cell_type = CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
          final_result_CS = rbind(final_result_CS,tempf)
        }
      }
    } 
  }
}
final_result_CS = final_result_CS[-1,]

remain_CS_CER_CEH_all = CS_CER_CEH_all[setdiff(CS_CER_CEH_all$gene,final_result_CS$gene),]
#CER 在该细胞中的表达大于其他最大值的五倍
final_result_CER = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
for(i in 1:dim(remain_CS_CER_CEH_all)[1]){
  if((remain_CS_CER_CEH_all$gene[i]%in%rownames(mRNA_exp))){
    if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.01){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
        tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                           remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                           cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "mRNA")
        final_result_CER = rbind(final_result_CER,tempf)
      }
    } 
  }
  else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(lncRNA_exp))){
    if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
        tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                           remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                           cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "lncRNA")
        final_result_CER = rbind(final_result_CER,tempf)
      }
    } 
  }
  else if((remain_CS_CER_CEH_all$gene[i]%in%rownames(pse_exp))){
    if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>0.001){
      if(as.numeric(remain_CS_CER_CEH_all$cell_exp[i])>5*as.numeric(remain_CS_CER_CEH_all$remain_max[i])){
        tempf = data.frame(gene = remain_CS_CER_CEH_all$gene[i],cell_exp = remain_CS_CER_CEH_all$cell_exp[i],
                           remain_max = remain_CS_CER_CEH_all$remain_max[i],remain_mean = remain_CS_CER_CEH_all$remain_mean[i],class = "CER",
                           cell_type = remain_CS_CER_CEH_all$cell[i],gene_type = "pseudogene")
        final_result_CER = rbind(final_result_CER,tempf)
      }
    } 
  }
}
final_result_CER = final_result_CER[-1,]

remain_CS_CER_CEH_all_1 = remain_CS_CER_CEH_all[setdiff(remain_CS_CER_CEH_all$gene,final_result_CER$gene),]
#CEH 在该细胞中的表达大于其他均值的五倍
final_result_CEH = data.frame(gene = "0",cell_exp = 0,remain_max = 0,remain_mean = 0,class = "0",cell_type = "0",gene_type = "0")
result_CEH = result[rownames(result)%in%rownames(remain_CS_CER_CEH_all_1),]
for(i in 1:dim(result_CEH)[1]){
  if((rownames(result_CEH)[i]%in%rownames(mRNA_exp))){
    if(max(as.numeric(result_CEH[i,]))>0.01){
      tt = as.data.frame(result_CEH[i,])
      cell_mean = ""
      remain_data = ""
      remain_mean = ""
      cell_type = ""
      for(m in 1:dim(result_CEH)[2]){
        if(as.numeric(tt[1,m])>0.01){
          if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
            cell_type = str_c(cell_type,",",colnames(tt)[m])
          }
        }
      }
      tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                         remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                         cell_type = cell_type,gene_type = "mRNA")
      final_result_CEH = rbind(final_result_CEH,tempf)
    }
  }
  else if((rownames(result_CEH)[i]%in%rownames(lncRNA_exp))){
    if(max(as.numeric(result_CEH[i,]))>0.001){
      tt = as.data.frame(result_CEH[i,])
      cell_mean = ""
      remain_data = ""
      remain_mean = ""
      cell_type = ""
      for(m in 1:dim(result_CEH)[2]){
        if(as.numeric(tt[1,m])>0.001){
          if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
            cell_type = str_c(cell_type,",",colnames(tt)[m])
          }
        }
      }
      tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                         remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                         cell_type = cell_type,gene_type = "lncRNA")
      final_result_CEH = rbind(final_result_CEH,tempf)
    }
  }
  else if((rownames(result_CEH)[i]%in%rownames(pse_exp))){
    if(max(as.numeric(result_CEH[i,]))>0.001){
      tt = as.data.frame(result_CEH[i,])
      cell_mean = ""
      remain_data = ""
      remain_mean = ""
      cell_type = ""
      for(m in 1:dim(result_CEH)[2]){
        if(as.numeric(tt[1,m])>0.001){
          if(as.numeric(tt[1,m])>5*mean(as.numeric(tt[1,-m]))){
            cell_mean = str_c(cell_mean,",",as.character(as.numeric(tt[1,m])))
            remain_data = str_c(remain_data,",",as.character(max(as.numeric(tt[1,-m]))))
            remain_mean = str_c(remain_mean,",",as.character(mean(as.numeric(tt[1,-m]))))
            cell_type = str_c(cell_type,",",colnames(tt)[m])
          }
        }
      }
      tempf = data.frame(gene = rownames(result_CEH)[i],cell_exp = cell_mean,
                         remain_max = remain_data,remain_mean = remain_mean,class = "CEH",
                         cell_type = cell_type,gene_type = "pseudogene")
      
      final_result_CEH = rbind(final_result_CEH,tempf)
    }
  }
}
final_result_CEH = final_result_CEH[-1,]

tt1 = c()
for(i in 1:dim(final_result_CEH)[1]){
  if(final_result_CEH$cell_exp[i]==""){
    tt1 = c(tt1,i)
  }
}
final_result_CEH = final_result_CEH[-tt1,]
final_result_CEH$cell_exp = str_sub(final_result_CEH$cell_exp,2,-1)
final_result_CEH$remain_max = str_sub(final_result_CEH$remain_max,2,-1)
final_result_CEH$remain_mean = str_sub(final_result_CEH$remain_mean,2,-1)
final_result_CEH$cell_type = str_sub(final_result_CEH$cell_type,2,-1)

ttceh = data.frame()
for(i in 1:dim(final_result_CEH)[1]){
  
  if(str_detect(final_result_CEH$cell_exp[i],",")){
    tt1 = final_result_CEH[i,]
    for(j in 1:length(strsplit(tt1$cell_exp[1],",")[[1]])){
      t_temp = data.frame(gene = tt1$gene[1],cell_exp = strsplit(tt1$cell_exp[1],",")[[1]][j],
                          remain_max = strsplit(tt1$remain_max[1],",")[[1]][j],
                          remain_mean = strsplit(tt1$remain_mean[1],",")[[1]][j],class = tt1$class[1],
                          cell_type = strsplit(tt1$cell_type[1],",")[[1]][j],gene_type = tt1$gene_type[1])
      ttceh = rbind(ttceh,t_temp)
    }
  }
}

final_result_CEH = rbind(final_result_CEH,ttceh)



tt1 = c()
for(i in 1:dim(final_result_CEH)[1]){
  if(str_detect(final_result_CEH$cell_exp[i],",")){
    tt1 = c(tt1,i)
  }
}

if(length(tt1) >0){final_result_CEH = final_result_CEH[-tt1,]}




final_result = rbind(final_result_CS,final_result_CER,final_result_CEH)


final_result$cell_num_value = 0
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
for(i in 1:dim(final_result)[1]){
  
  temp = data[final_result$gene[i],colnames(data) %in% rownames(cell_gene[(cell_gene$cell_type == final_result$cell_type[i]),])]##
  
  final_result$cell_num_value[i] = sum(temp!=0)
}

final_result_10 = final_result[final_result$cell_num_value>=10,]


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

write.table(final_result,str_c("E:\\lcw\\lncSPA\\TIGER\\final_res\\","CRC_GSE144735",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(final_result_10,str_c("E:\\lcw\\lncSPA\\TIGER\\final_res_10\\","CRC_GSE144735",".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

rm(tempf,tt,tt1,final_result,final_result_CEH,final_result_CER,final_result_CS,cell_type,
   cell_exp,temp,CS_CER_CEH_all,cstemp,lncRNA_exp,
   mRNA_exp,pse_exp,remain_CS_CER_CEH_all,remain_CS_CER_CEH_all_1,remain_data,remain_max,remain_mean,cell_mean,
   cell_values,max_cell,cell_max,table_temp,result,result_CEH,n,m,final_result_10,ttceh,data,cell_gene)
gc()

setwd(str_c("E:\\lcw\\lncSPA\\TIGER\\tiger\\","CRC_GSE144735",sep = ""))
listfile = c("CRC_GSE144735")
k=1
#4. 找Variable基因
cancer_seurat = FindVariableFeatures(cancer_seurat, selection.method = "vst", nfeatures = 2000)
gc()

#5. scale表达矩阵
cancer_seurat <- ScaleData(cancer_seurat, features = rownames(cancer_seurat))
#6. 降维聚类
#（基于前面得到的high variable基因的scale矩阵）
cancer_seurat <- RunPCA(cancer_seurat, npcs = 50, verbose = FALSE)
pdf(file = as.character(paste(listfile[k],".VizDimLoadings.pdf",sep="")))
p <- VizDimLoadings(cancer_seurat, dims = 1:2, reduction = "pca")
print(p)
dev.off()
gc()
pdf(paste(listfile[k],".DimPlot.pdf",sep=""))
p <- DimPlot(cancer_seurat, reduction = "pca")
print(p)
dev.off()
##########
pdf(paste(listfile[k],".DimHeatmap.pdf",sep=""))
p =  DimHeatmap(cancer_seurat, dims = 1, cells = 500, balanced = TRUE)
print(p)
dev.off()
#7.定义数据集维度
#NOTE: This process can take a long time for big datasets, comment out for expediency. 
#More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
cancer_seurat <- JackStraw(cancer_seurat, num.replicate = 100)
gc()
cancer_seurat <- ScoreJackStraw(cancer_seurat, dims = 1:20)

pdf(paste(listfile[k],".JackStrawPlot.pdf",sep=""))
p <- JackStrawPlot(cancer_seurat, dims = 1:15)
print(p)
dev.off()

pdf(paste(listfile[k],".ElbowPlot.pdf",sep=""))
p <- ElbowPlot(cancer_seurat,ndims = 50)
print(p)
dev.off()
#8.细胞分类
cancer_seurat <- FindNeighbors(cancer_seurat, dims = 1:10)
gc()
cancer_seurat <- FindClusters(cancer_seurat, resolution =c(0.5,0.6,0.8,1,1.4,2,2.5,4))

#用已知的细胞类型代替分类的细胞类型
temp = cancer_seurat@meta.data

#tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
Idents(object=cancer_seurat) <- cellann$cell_type
#9.可视化分类结果
#UMAP
cancer_seurat <- RunUMAP(cancer_seurat, dims = 1:10, label = T)
gc()
#head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
write.table(cancer_seurat@reductions$umap@cell.embeddings,file=paste(listfile[k],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
#note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
p1 <- DimPlot(cancer_seurat, reduction = "umap")
#T-SNE
cancer_seurat <- RunTSNE(cancer_seurat, dims = 1:10)#报错，改为不检查重复
gc()
#head(tissue_seurat@reductions$tsne@cell.embeddings)
write.table(cancer_seurat@reductions$tsne@cell.embeddings,file=paste(listfile[k],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
p2 <- DimPlot(cancer_seurat, reduction = "tsne")
pdf(paste(listfile[k],".umap.tsne.pdf",sep=""),width = 15, height = 8)
print(p1 + p2)
dev.off()
saveRDS(cancer_seurat, file = paste(listfile[k],".rds",sep=""))  #保存数据，用于后续个性化分析
gc()
#10.提取各细胞类型的marker gene
#find all markers of cluster 1
#cluster1.markers <- FindMarkers(tissue_seurat, ident.1 = 1, min.pct = 0.25)
#利用 DoHeatmap 命令可以可视化marker基因的表达
cancer_seurat.markers <- FindAllMarkers(cancer_seurat, only.pos = TRUE, min.pct = 0.25)
gc()
top3 <- cancer_seurat.markers %>% group_by(cluster) %>% top_n(n = 3, wt = avg_log2FC)
pdf(paste(listfile[k],".DoHeatmap.pdf",sep=""))
p <- DoHeatmap(cancer_seurat, features = top3$gene) + NoLegend()
print(p)
dev.off()
pdf(paste(listfile[k],".umap.DimPlot.pdf",sep=""))
p <- DimPlot(cancer_seurat, reduction = "umap", label = TRUE, pt.size = 0.5)
print(p)
dev.off()
pdf(paste(listfile[k],".tsne.DimPlot.pdf",sep=""))
p <- DimPlot(cancer_seurat, reduction = "tsne", label = TRUE, pt.size = 1)
print(p)
dev.off()
rm(p,p1,p2,temp,cancer_seurat,cancer_seurat.markers,top3)
gc()



#TIGER 4 ----







#########TIGER结果整合
#所有细胞类型
library(openxlsx)
library(stringr)
###TIGER_annotation-----------
setwd("E:\\lcw\\lncSPA\\TIGER\\cellid_type\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)

TIGER_annotation = data.frame(cancer_type = 0,cell = 0,compartment = 0)

for(i in 1:length(listfile)){
  data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cell_type = as.data.frame(table(data$cell_type))
  
  cell_type$Var1 = as.character(cell_type$Var1)
  
  
  ann_temp = data.frame(cancer_type = listfile[i],
                        cell = cell_type$Var1)
  
  ann_temp$compartment = 0
  
  #for(j in 1:dim(ann_temp)[1]){
  #  ann_temp$compartment[j] = compartment$compartment[which(compartment$Var1 == ann_temp$cell[j])]
  #}
  
  TIGER_annotation = rbind(TIGER_annotation,ann_temp)
}
TIGER_annotation = TIGER_annotation[-1,]
write.table(TIGER_annotation,"E:\\lcw\\lncSPA\\TIGER\\res\\1celltree\\TIGER_annotation.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

cell_type = as.data.frame(table(TIGER_annotation$cell))
cell_type$Var1 = as.character(cell_type$Var1)

write.xlsx(cell_type,"E:\\lcw\\lncSPA\\TIGER\\cell_type.xlsx")

rm(cell_type,data,TISCH_annotation,ann_temp,listfile,i,j)

TIGER_annotation = read.table("E:\\lcw\\lncSPA\\TIGER\\res\\1celltree\\TIGER_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
cell_annotation = read.xlsx("E:\\lcw\\lncSPA\\TIGER\\cell_type.xlsx")



for(i in 1:dim(cell_annotation)[1]){
  TIGER_annotation$compartment[TIGER_annotation$cell == cell_annotation$Var1[i]] = cell_annotation$compartment[i]
}
write.table(TIGER_annotation,"E:\\lcw\\lncSPA\\TIGER\\res\\1celltree\\TIGER_annotation.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


rm(list = ls())
gc()
##TIGER_cell_CE_lncRNA_num---

TIGER_cell_CE_lncRNA_num = data.frame(cancer_type = "0",cell_type = "0",cell_num = 0,CE_num = 0)
setwd("E:\\lcw\\lncSPA\\TIGER\\cellid_type\\")
listfile = list.files()
listfile = str_sub(listfile,1,-5)
#write.xlsx(data.frame(cancer = listfile),"E:\\lcw\\lncSPA\\zhenghe\\cancer_type.xlsx")

for(i in 1:length(listfile)){
  
  cellid_type = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  CE_data = read.table(str_c("E:\\lcw\\lncSPA\\TIGER\\final_res_10\\",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  
  all_cell_type = as.data.frame(table(cellid_type$cell_type))
  
  CE_cell_type = as.data.frame(table(CE_data$cell_type[which(CE_data$gene_type %in% c("lncRNA","pseudogene"))]))
  
  temp_data = data.frame(cancer_type = listfile[i],
                         cell_type = all_cell_type$Var1,cell_num = all_cell_type$Freq,CE_num = 0)
  
  for(m in 1:dim(temp_data)[1]){
    for(n in 1:dim(CE_cell_type)[1]){
      if(as.character(temp_data$cell_type[m]) == as.character(CE_cell_type$Var1[n])){##
        temp_data$CE_num[m] = CE_cell_type$Freq[n]##
      }
    }
  }
  
  
  
  TIGER_cell_CE_lncRNA_num = rbind(TIGER_cell_CE_lncRNA_num,temp_data)
}
TIGER_cell_CE_lncRNA_num = TIGER_cell_CE_lncRNA_num[-1,]

write.table(TIGER_cell_CE_lncRNA_num,"E:\\lcw\\lncSPA\\TIGER\\res\\1celltree\\TIGER_cell_CE_lncRNA_num.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


rm(list = ls())
gc()




####TIGER_2basic_information----
####2.TIGER_lncRNA_information.cell_num_10,,TIGER_mRNA_information.cell_num_10
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

other_RNA = other_RNA[str_detect(other_RNA$gene_type,"pseudogene"),]

setwd("E:\\lcw\\lncSPA\\TIGER\\final_res_10\\")
listfile = list.files()



TIGER_lncRNA = data.frame()
TIGER_mRNA = data.frame()

for(i in 1:length(listfile)){
  temp_data = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  
  
  temp_data$cancer_type = str_sub(listfile[i],1,-5)
  
  lnctemp = temp_data[temp_data$gene_type %in% c("lncRNA","pseudogene"),]
  mrnatemp = temp_data[temp_data$gene_type  == "mRNA",]
  
  TIGER_lncRNA = rbind(TIGER_lncRNA,lnctemp)
  TIGER_mRNA = rbind(TIGER_mRNA,mrnatemp)
}

data = TIGER_lncRNA
data = TIGER_mRNA


data$ensembl_gene_id = 0

#lncRNA
for(i in 1:dim(data)[1]){
  if(data$gene_type[i] == "lncRNA"){
    data$ensembl_gene_id[i] = lncRNA$ensembl_gene_id[which(lncRNA$gene_name == data$gene[i])]
  }else if(data$gene_type[i] == "pseudogene"){
    data$ensembl_gene_id[i] = other_RNA$ensembl_gene_id[which(other_RNA$gene_name == data$gene[i])]
    data$gene_type[i] = other_RNA$gene_type[which(other_RNA$gene_name == data$gene[i])]
  }
}

#mRNA
for(i in 1:dim(data)[1]){
  data$ensembl_gene_id[i] = mRNA$ensembl_gene_id[which(mRNA$gene_name == data$gene[i])]
}



data$seqnames = 0
data$start = 0
data$end = 0
data$strand = 0

#lncRNA
for(i in 1:dim(data)[1]){
  if(data$gene_type[i] == "lncRNA"){
    data$seqnames[i] = lncRNA$seqnames[which(lncRNA$gene_name == data$gene[i])]
    data$start[i] = lncRNA$start[which(lncRNA$gene_name == data$gene[i])]
    data$end[i] = lncRNA$end[which(lncRNA$gene_name == data$gene[i])]
    data$strand[i] = lncRNA$strand[which(lncRNA$gene_name == data$gene[i])]
    
    
  }else{
    data$seqnames[i] = other_RNA$seqnames[which(other_RNA$gene_name == data$gene[i])]
    data$start[i] = other_RNA$start[which(other_RNA$gene_name == data$gene[i])]
    data$end[i] = other_RNA$end[which(other_RNA$gene_name == data$gene[i])]
    data$strand[i] = other_RNA$strand[which(other_RNA$gene_name == data$gene[i])]
  }
}


#mRNA
for(i in 1:dim(data)[1]){
  data$seqnames[i] = mRNA$seqnames[which(mRNA$gene_name == data$gene[i])]
  data$start[i] = mRNA$start[which(mRNA$gene_name == data$gene[i])]
  data$end[i] = mRNA$end[which(mRNA$gene_name == data$gene[i])]
  data$strand[i] = mRNA$strand[which(mRNA$gene_name == data$gene[i])]
}


write.table(data,"E:\\lcw\\lncSPA\\TIGER\\res\\2basic_information\\TIGER_lncRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(data,"E:\\lcw\\lncSPA\\TIGER\\res\\2basic_information\\TIGER_mRNA_information.cell_num_10.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

rm(list = ls())
gc()


####TIGER_3bar_plot----

library(stringr)
library(openxlsx)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

all_lnc = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\TIGER\\exp\\")

listfile = list.files()
listfile = str_sub(listfile,1,-5)

all_cell_type = data.frame()

#read.table("E:\\lcw\\lncSPA\\xukang\\cell_type.txt",header = F,sep="\t")

gene_cancer = data.frame()

for(i in 1:length(listfile)){
  
  data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F,check.names = F)
  for(j in 1:dim(data)[1]){
    if(data$result[j] %in% all_lnc$gene_name){
      temp1 = data.frame(gene_name = data$result[j],
                         ensembl_gene_id = all_lnc$ensembl_gene_id[which(all_lnc$gene_name == data$result[j])],
                         cancer_type = listfile[i])
      gene_cancer = rbind(gene_cancer,temp1)
    }
    
  }
  
  
  temp2 = data.frame(cell_type = colnames(data))
  
  all_cell_type = rbind(all_cell_type,temp2)
  print(i)
  
}

gene_cancer = gene_cancer %>% distinct(gene_name,ensembl_gene_id,cancer_type, .keep_all = T)


celltype = read.xlsx("E:\\lcw\\lncSPA\\TIGER\\cell_type.xlsx")


gene_cancer[,4:22] = NA

colnames(gene_cancer)[4:22] = as.character(celltype$Var1)




write.table(gene_cancer,"E:\\lcw\\lncSPA\\TIGER\\before_lnc_gene.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)


#服务器
gene_cancer = read.table("E:\\lcw\\lncSPA\\TIGER\\before_lnc_gene.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
gene_cancer = gene_cancer %>% distinct(cancer_type,gene_name,ensembl_gene_id, .keep_all = T)

celltype = read.xlsx("E:\\lcw\\lncSPA\\TIGER\\cell_type.xlsx")

setwd("E:\\lcw\\lncSPA\\TIGER\\exp\\")

listfile = list.files()
listfile = str_sub(listfile,1,-5)

for(i in 1:length(listfile)){
  
  print(i)
  print(Sys.time())
  
  exp_data = read.table(str_c(listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F,check.names = F)
  
  
  
  tabletemp = data.frame(colnames(exp_data))
  
  tabletemp = data.frame(cell_type = tabletemp[-1,])
  
  
  colnames(exp_data) = c("result",tabletemp$cell_type)
  rownames(exp_data) = exp_data$result
  
  
  for(j in 1:dim(exp_data)[1]){
    for(k in 1:dim(tabletemp)[1]){
      if(rownames(exp_data)[j]%in%gene_cancer$gene_name){
        gene_cancer[(gene_cancer$gene_name == exp_data$result[j] & gene_cancer$cancer_type == listfile[i]),tabletemp$cell_type[k]] = round(exp_data[j,tabletemp$cell_type[k]],4)
        
      }
    }
    
  }
  
}


gene_cancer = gene_cancer[str_order(gene_cancer$gene_name),]



write.table(gene_cancer,"E:\\lcw\\lncSPA\\TIGER\\res\\3bar_plot\\TIGER_lncRNA_all_tissue_cell_exp_mean.round_4.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
rm(list = ls())
gc()


##TIGER_4.detail----
##HCL.cell.cell_type.tsne_x.tsne_y.exp.round_4HCL.cell.exp_max__服务器
lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA = other_RNA[str_detect(other_RNA$gene_type,pattern = "pseudogene"),]

all_lnc = rbind(lncRNA,other_RNA)

setwd("E:\\lcw\\lncSPA\\TIGER\\exp\\")
listfile = list.files()

gene_temp = data.frame(gene = 0)

for(i in 1:length(listfile)){
  gc()
  data = read.table(listfile[i],header=T,sep="\t",stringsAsFactors=F)
  
  df = data.frame(gene = data$result)
  gene_temp = rbind(gene_temp,df)
  print(i)
}
gene_temp = as.data.frame(gene_temp[-1,])

gene_all_lnc = as.data.frame(table(gene_temp$`gene_temp[-1, ]`))

gene_all_lnc = gene_all_lnc[gene_all_lnc$Var1 %in% all_lnc$gene_name,]
gene_all_lnc = as_data_frame(gene_all_lnc[,-2])
colnames(gene_all_lnc)[1] = "gene"

write.table(gene_all_lnc,"E:\\lcw\\lncSPA\\TIGER\\all_lnc_gene.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

#######逐个生成文件

library(Seurat)
library(stringr)
library(dplyr)

rm(list = ls())
gc()
pinjie = function(x){
  library(stringr)
  temp = ""
  for(i in 1:length(x)){
    temp = str_c(temp,as.character(x[i]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}




gene_all = read.table("E:/lcw/lncSPA/TIGER/all_lnc_gene.txt",header=T,sep="\t",stringsAsFactors=F)

listfile = list.files("E:/lcw/lncSPA/TIGER/cellid_type/")
listfile = str_sub(listfile,1,-5)


for(i in 1:length(listfile)){
  print(i)
  a1 = Sys.time()
  cell_and_type = read.table(str_c("E:/lcw/lncSPA/TIGER/cellid_type/",listfile[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  rownames(cell_and_type) = cell_and_type$cell_ID
  
  tsne = read.table(str_c("E:/lcw/lncSPA/TIGER/tiger/",listfile[i],"/",listfile[i],".tsne.cell.embeddings.txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  
  cancer_seurat = readRDS(str_c("E:/lcw/lncSPA/TIGER/tiger/",listfile[i],"/",listfile[i],".rds",sep = ""))
  cancer_seurat <- NormalizeData(object = cancer_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  data = cancer_seurat[["RNA"]]@data
  rm(cancer_seurat)
  gc()
  final_table_temp = data.frame(Gene = c("cell","cell_type","tsne_x","tsne_y",rownames(data)[rownames(data)%in%gene_all$gene]),data = "")
  
  rownames(final_table_temp) = final_table_temp$Gene
  
  
  table_temp = as.data.frame(table(cell_and_type$cell_type))
  
  for(k in 1:dim(table_temp)[1]){
    cell_temp = cell_and_type[cell_and_type$cell_type == as.character(table_temp$Var1[k]),]
    #rownames(cell_temp) = str_replace(rownames(cell_temp),"-",".")
    tsne_temp = tsne[rownames(cell_temp),]
    exp_temp = data.frame(data[rownames(data)%in%gene_all$gene,rownames(cell_temp)])
    exp_temp = round(exp_temp,4)
    cell01 = pinjie(as.character(cell_temp$cell_ID))
    cell_type01 = pinjie(as.character(cell_temp$cell_type))
    tsne_x01 = pinjie(round(tsne_temp$tSNE_1,2))
    tsne_y01 = pinjie(round(tsne_temp$tSNE_2,2))
    
    final_table_temp$data[1] = str_c(as.character(final_table_temp$data[1]),cell01,sep = ";")
    final_table_temp$data[2] = str_c(as.character(final_table_temp$data[2]),cell_type01,sep = ";")
    final_table_temp$data[3] = str_c(as.character(final_table_temp$data[3]),tsne_x01,sep = ";")
    final_table_temp$data[4] = str_c(as.character(final_table_temp$data[4]),tsne_y01,sep = ";")
    
    final_table_temp$data[5:dim(final_table_temp)[1]] = str_c(final_table_temp$data[5:dim(final_table_temp)[1]],apply(exp_temp,1,pinjie),sep = ";")
  }
  
  final_table_temp$data = str_sub(final_table_temp$data,2,-1)
  
  #  for(m in 1:dim(final_table_temp)[1]){
  #    final_table[rownames(final_table_temp)[m],listfile[i]] = final_table_temp$data[m]
  #  }
  colnames(final_table_temp)[2] = listfile[i]
  
  write.table(final_table_temp,str_c("E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\4detail\\each\\",listfile[i],".txt",sep = ""),row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
  
  #for(n in 1:dim(exp_temp)[1]){
  #  if(rownames(exp_temp)[n] %in% TISCH.cell.exp_max$Gene){
  #   TISCH.cell.exp_max[rownames(exp_temp)[n],listfile[i]] = max(exp_temp[n,])
  #  }
  #}
  
  
  
  a2 = Sys.time()
  print(a2-a1)
  rm(a1,a2,final_table_temp)
  gc()
}




#5cor----
#相关，首先需要每一个细胞类型的表达谱
#HCL细胞表达谱
#exp_anno <- read.table("D:kang/lncSpA2/process/1_data.process/HCL/HCL_exp_fetal_anno_file_names.txt",sep="\t",header=T,stringsAsFactors=F)
#exp_anno[,1] <- gsub("[0-9]$","",exp_anno[,1])
#tissue_num <- data.frame(table(exp_anno[,1]))
rm(list = ls())
gc()
library(stringr)
exp_anno = list.files("/bioXJ/lcw/TIGER/exp/")
exp_anno = str_sub(exp_anno,1,-5)

library(Seurat)
library(dplyr)
input_file <- "/bioXJ/lcw/TIGER/RDS/"
output <- "/bioXJ/lcw/TIGER/each/"

for (i in 1:length(exp_anno)) {
  tissue_seurat <- readRDS(paste(input_file,exp_anno[i],"/",exp_anno[i],".rds",sep=""))
  tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
  tissue_exp <- tissue_seurat[["RNA"]]@data
  anno_value <- read.table(paste("/bioXJ/lcw/TIGER/cellid_type/",exp_anno[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
  rownames(anno_value) = anno_value$cell_ID
  #rownames(anno_value) = str_c("X",rownames(anno_value),sep = "")
  
  cell_num <- data.frame(table(anno_value$cell_type))
  cell_num <- cell_num[which(cell_num[,1] != "Unknown"),]
  #cell_num[,1] <- gsub("\\/"," or ",cell_num[,1])
  for (k in 1:nrow(cell_num)) {
    cell_file <- anno_value[which(anno_value$cell_type == as.character(cell_num[k,1])),]
    cell_exp <- tissue_exp[,which(colnames(tissue_exp) %in% rownames(cell_file))]
    write.table(cell_exp,file=paste(output,exp_anno[i],".",gsub("\\/"," or ",as.character(cell_num[k,1])),".cell_num.cells.txt",sep=""),sep="\t",quote=F,row.names=T)
    gc()
  }
}







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


input <- "E:/lcw/lncSPA/TIGER/res/2basic_information/"
input_exp <- "E:/lcw/lncSPA/TIGER/res/5cor/each/"
output <- "E:/lcw/lncSPA/TIGER/res/5cor/cor_result/"
lncRNA_result <- read.table(paste(input,"TIGER_lncRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
mRNA_result <- read.table(paste(input,"TIGER_mRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)

listfile = list.files("E:/lcw/lncSPA/TIGER/exp/")
listfile = str_sub(listfile,1,-5)
#tissue <- "Adrenal-Gland"
#tissue <- "Uterus"
for (i in 2:length(listfile)){
  a1 = Sys.time()
  print(a1)
  print(i)
  lncRNA_tissue <- lncRNA_result[which(lncRNA_result$cancer_type == listfile[i]),]
  mRNA_tissue <- mRNA_result[which(mRNA_result$cancer_type == listfile[i]),]
  cell_inte_name <- intersect(lncRNA_tissue$cell_type,mRNA_tissue$cell_type)
  cor_normal_result <- c()
  cor_sclink_result <- c()
  cor_saver_result <- c()
  #cell_name <- "Cancer cell"
  for (cell_name in cell_inte_name) {
    cell_name1 <- gsub("\\/"," or ",cell_name)
    
    cell_exp <- read.table(paste(input_exp,listfile[i],".",cell_name1,".cell_num.cells.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
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
      cor_result$cancer_type <- rep(listfile[i],nrow(cor_result))
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
      cor_r2$cancer_type <- rep(listfile[i],nrow(cor_r2))
      cor_r2$classification <- mRNA_tissue[match(cor_r2[,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
      cor_r2$cell <- rep(cell_name,nrow(cor_r2))
      cor_sclink_result <- rbind(cor_sclink_result,cor_r2)
      gc()
    }
  }
  colnames(cor_normal_result) <- c("lncRNA_name","mRNA_name","R","p_value","cancer_type","classification","cell")
  write.table(cor_normal_result,file=paste(output,listfile[i],".cell.cor_r_p.txt",sep=""),sep="\t",quote=F,row.names=F)
  colnames(cor_sclink_result) <- c("lncRNA_name","mRNA_name","R","p_value","cancer_type","classification","cell")
  write.table(cor_sclink_result,file=paste(output,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",quote=F,row.names=F)
  a2 = Sys.time()
  print(a2-a1)
  gc()
}



#########################################
input <- "E:/lcw/lncSPA/TIGER/res/5cor/cor_result/"

listfile = list.files("E:/lcw/lncSPA/TIGER/exp/")
listfile = str_sub(listfile,1,-5)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
#write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:length(listfile)) {
  sclink_result <- read.table(paste(input,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
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
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"cancer_type"],lncRNA_paste,mRNA_paste1)))
  }
}

colnames(final_res) = c("cancer_type","lncRNA_ID","mRNA_ID")
write.table(final_res,file="E:/lcw/lncSPA/TIGER/res/5cor/lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=T,append=T)







#####统计----
library(openxlsx)
library(stringr)
library(dplyr)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\cell_res_compart.txt",header=T,sep="\t",stringsAsFactors=F)
hcl = read.table("E:\\lcw\\lncSPA\\统计\\hcl_compart.txt",header=T,sep="\t",stringsAsFactors=F)
other = read.table("E:\\lcw\\lncSPA\\统计\\other_compart.txt",header=T,sep="\t",stringsAsFactors=F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\tts_compart.txt",header=T,sep="\t",stringsAsFactors=F)

data = tts

for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(The Tabula Sapiens)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=tts",sep = "")
}

tts = data

#cell_res
cancer_Adult = cell_res[,c(3,4)]


#hcl
normal_Adult = hcl[str_detect(hcl$tissue_type,"Adult"),c(3,4)]
normal_fetal = hcl[str_detect(hcl$tissue_type,"Fetal"),c(3,4)]

#other
cancer_Adult = rbind(cancer_Adult,other[str_detect(other$tissue_type,"Adult"),c(3,4)])
cancer_fetal = other[str_detect(other$tissue_type,"Pediatric"),c(3,4)]

#tts
normal_Adult = rbind(normal_Adult,tts[,c(3,4)])


normal_Adult$tissue_full = str_sub(normal_Adult$tissue_full,7,-1)
normal_Adult$tissue = str_sub(normal_Adult$tissue,7,-1)

cancer_Adult$tissue_full = str_sub(cancer_Adult$tissue_full,7,-1)
cancer_Adult$tissue = str_sub(cancer_Adult$tissue,7,-1)


#tisch
tisch = read.table("E:\\lcw\\lncSPA\\统计\\TISCH_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tisch$tissue_type = str_c(tisch$cancer_type,tisch$dataset,sep = "_")
tisch = tisch %>% distinct(tissue_type, .keep_all = T)

data = tisch

for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$cancer_type[i],"(",data$dataset[i],")",sep = "")
  data$tissue[i] = str_c(data$cancer_type[i],"=",data$dataset[i],sep = "")
}

tisch = data

cancer_Adult = read.table("E:\\lcw\\lncSPA\\统计\\cancer_Adult.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_Adult = cancer_Adult[1:54,]
cancer_Adult = rbind(cancer_Adult,tisch[,c(6,7)])

###tica----
normal_Adult = read.table("E:\\lcw\\lncSPA\\统计\\normal_Adult.txt",header=T,sep="\t",stringsAsFactors=F)
tica = read.table("E:\\lcw\\lncSPA\\统计\\tica_compartment.txt",header=T,sep="\t",stringsAsFactors=F)

tica = tica %>% distinct(tissue_type, .keep_all = T)

data = tica

for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(TICA)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=tica",sep = "")
}

tica = data

normal_Adult = rbind(normal_Adult,tica[,c(5,6)])


#癌症加全称

cancername =read.xlsx("D:\\Desktop\\cancer (2).xlsx")

cancer_Adult$cancer_name = 0

for(i in 1:dim(cancername)[1]){
  for(j in 1:dim(cancer_Adult)[1]){
    if(str_split(cancer_Adult$tissue[j],"=")[[1]][1] == cancername$cancer[i]){
      cancer_Adult$cancer_name[j] = cancername$fullname[i]
    }
  }
}

for(i in 1:dim(cancer_Adult)[1]){
  if(cancer_Adult$cancer_name[i] == 0){
    cancer_Adult$cancer_name[i] = str_split(cancer_Adult$tissue[i],"=")[[1]][1]
  }
}





write.table(cancer_Adult,"E:\\lcw\\lncSPA\\统计\\cancer_Adult.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(normal_Adult,"E:\\lcw\\lncSPA\\统计\\normal_Adult.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(normal_fetal,"E:\\lcw\\lncSPA\\统计\\normal_fetal.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(cancer_fetal,"E:\\lcw\\lncSPA\\统计\\cancer_fetal.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)



data = other
data$tissue_type = str_replace(data$tissue_type,pattern = "_","-")

for(i in 1:dim(data)[1]){
  if(str_split(data$tissue_type[i],pattern = "-")[[1]][1] == "Adult"){
    data$tissue_type[i] = str_split(data$tissue_type[i],pattern = "-")[[1]][2]
    data$tissue_full[i] = str_c(data$tissue_type[i],"(Human Cell Landscape)",sep = "")
    data$tissue[i] = str_c(data$tissue_type[i],"_hcl",sep = "")
  }else{
    data$tissue_type[i] = str_replace(data$tissue_type[i],pattern = "-","_")
    data$tissue_full[i] = str_c(data$tissue_type[i],"(Human Cell Landscape)",sep = "")
    data$tissue[i] = str_c(data$tissue_type[i],"_hcl",sep = "")
  }
  
}











library(stringr)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\cell_res_celltree.txt",header=T,sep="\t",stringsAsFactors=F)
hcl = read.table("E:\\lcw\\lncSPA\\统计\\hcl_celltree.txt",header=T,sep="\t",stringsAsFactors=F)
other = read.table("E:\\lcw\\lncSPA\\统计\\other_celltree.txt",header=T,sep="\t",stringsAsFactors=F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\tts_celltree.txt",header=T,sep="\t",stringsAsFactors=F)
tiger = read.table("E:\\lcw\\lncSPA\\TIGER\\res\\1celltree\\TIGER_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tica = read.table("E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\1celltree\\tissue_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
tisch = read.table("E:\\lcw\\lncSPA\\zhenghe\\result\\1celltree\\TISCH_annotation.txt",header=T,sep="\t",stringsAsFactors=F)


####normal
hcl$resource = "hcl"
tts$resource = "tts"
tica$resource = "tica"

hcl = hcl[,-c(3,4,5,6)]
tts = tts[,-c(3,4,5,6)]
tica = tica[,-3]
colnames(tica)[2] = "cell_type"


normal = rbind(hcl,tts,tica)

####cancer
#cell_res
cell_res$resource = "cell_res"
data = cell_res
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(Junbin Qian. Cell Research. 2020)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=cell_res",sep = "")
}
cell_res = data

cell_res = data.frame(tissue_full = cell_res$tissue_full,cell_type = cell_res$cell_type,tissue = cell_res$tissue)

#other
data = other
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(GSE140819)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=other",sep = "")
}
other = data

other = data.frame(tissue_full = other$tissue_full,cell_type = other$cell_type,tissue = other$tissue)

#tisch
data = tisch
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$cancer_type[i],"(",data$dataset[i],")",sep = "")
  data$tissue[i] = str_c(data$cancer_type[i],"=",data$dataset[i],sep = "")
}
tisch = data
tisch = data.frame(tissue_full = tisch$tissue_full,cell_type = tisch$cell,tissue = tisch$tissue)

#tiger
data = tiger
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(str_split(data$cancer_type[i],"_")[[1]][1],"(",str_split(data$cancer_type[i],"_")[[1]][2],")",sep = "")
  data$tissue[i] = str_c(str_split(data$cancer_type[i],"_")[[1]][1],"=",str_split(data$cancer_type[i],"_")[[1]][2],sep = "")
}
tiger = data
tiger = data.frame(tissue_full = tiger$tissue_full,cell_type = tiger$cell,tissue = tiger$tissue)


cancer = rbind(cell_res,other,tisch,tiger)


#癌症加全称

cancername =read.xlsx("D:\\Desktop\\cancer (2).xlsx")

cancer$cancer_name = 0

for(i in 1:dim(cancername)[1]){
  for(j in 1:dim(cancer)[1]){
    if(str_split(cancer$tissue[j],"=")[[1]][1] == cancername$cancer[i]){
      cancer$cancer_name[j] = cancername$fullname[i]
    }
  }
}

for(i in 1:dim(cancer)[1]){
  if(cancer$cancer_name[i] == 0){
    cancer$cancer_name[i] = str_split(cancer$tissue[i],"=")[[1]][1]
  }
}

write.table(cancer,"E:\\lcw\\lncSPA\\统计\\cancer.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(normal,"E:\\lcw\\lncSPA\\统计\\normal.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)





cancer = read.table("E:\\lcw\\lncSPA\\统计\\cancer.txt",header=T,sep="\t",stringsAsFactors=F)
cancer = cancer[1:624,]

cancer_fetal = read.table("E:\\lcw\\lncSPA\\统计\\cancer_fetal.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_fetal = cancer_fetal[1:14,]


####epn----
library(stringr)
epn_celltree = read.table("E:\\lcw\\lncSPA\\统计\\epn_celltree.txt",header=T,sep="\t",stringsAsFactors=F)
data = epn_celltree
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(GSE125969)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=epn",sep = "")
}
epn_celltree = data

cancer_fetal = rbind(cancer_fetal,epn_celltree[,c(6,7)])
write.table(cancer_fetal,"E:\\lcw\\lncSPA\\统计\\cancer_fetal.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)

epn_celltree$cancer_name = "Ependymoma"

epn_celltree = data.frame(tissue_full = epn_celltree$tissue_full,cell_type = epn_celltree$cell_type,tissue = epn_celltree$tissue,cancer_name = epn_celltree$cancer_name)
cancer = rbind(cancer,epn_celltree)

####group----
group = read.table("E:\\lcw\\lncSPA\\统计\\group_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

data = group
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(Vento-Tormo Group)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=group",sep = "")
  data$cancer_name = "Vento-Tormo Group"
}
group = data

group = data.frame(tissue_full = group$tissue_full,cell_type = group$cell_type,tissue = group$tissue,cancer_name = group$cancer_name)


cancer = rbind(cancer,group)



####nature----
nature = read.table("E:\\lcw\\lncSPA\\统计\\nature_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

data = nature
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$tissue_type[i],"(Nature_Medicine_GSE150728)",sep = "")
  data$tissue[i] = str_c(data$tissue_type[i],"=nature",sep = "")
  data$cancer_name = "Nature_Medicine_GSE150728"
}
nature = data

nature = data.frame(tissue_full = nature$tissue_full,cell_type = nature$cell_type,tissue = nature$tissue,cancer_name = nature$cancer_name)


cancer = rbind(cancer,nature)
write.table(cancer,"E:\\lcw\\lncSPA\\统计\\cancer.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)



cancer_a = read.table("E:\\lcw\\lncSPA\\统计\\cancer_a.txt",header=T,sep="\t",stringsAsFactors=F)
tiger = read.table("E:\\lcw\\lncSPA\\TIGER\\res\\1celltree\\TIGER_annotation.txt",header=T,sep="\t",stringsAsFactors=F)
cancer = read.table("E:\\lcw\\lncSPA\\统计\\cancer.txt",header=T,sep="\t",stringsAsFactors=F)

data = tiger
for(i in 1:dim(data)[1]){
  data$tissue_full[i] = str_c(data$cancer_type[i],"(",data$dataset[i],")",sep = "")
  data$tissue[i] = str_c(data$cancer_type[i],"=",data$dataset[i],"=tiger",sep = "")
}

data$cancer_name = c(rep("Colorectal cancer",19),rep("Non-small cell lung cancer",13))

tiger = data

tiger_01 = tiger %>% distinct(tissue, .keep_all = T)

cancer_a$tissue[608:639] = str_sub(cancer_a$tissue[608:639],1,-4)
cancer_a$tissue[608:639] = str_c(cancer_a$tissue[608:639],"tiger",sep = "")

cancer$tissue[135:624] = str_c(cancer$tissue[135:624],"=geo",sep = "")


colnames(tiger)[3] = "cell_type"
tiger = tiger[,c("tissue_full","cell_type","tissue","cancer_name")]
cancer = rbind(cancer,tiger)

write.table(cancer,"E:\\lcw\\lncSPA\\统计\\cancer.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)
write.table(cancer_a,"E:\\lcw\\lncSPA\\统计\\cancer_a.txt",row.names=FALSE,col.names=TRUE,sep="\t",quote=F)




library(Seurat)
setwd("E:/lcw/lncSPA/TISCH/GSE125449_liver cancer")
set1_data = Read10X("set1")
cancer_seurat <- CreateSeuratObject(counts = set1_data,project = "seurat", min.cells = 3, min.features = 50, names.delim = "_",)


rm(list = ls())
gc()


####结果修正
data = read.table("E:/lcw/lncSPA/TIGER/res/1celltree/TIGER_annotation.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

colnames(data)[1] = "cancer"
for(i in 1:dim(data)[1]){
  data$cancer_type[i] = str_split(data$cancer[i],"_")[[1]][1]
  data$dataset[i] = str_split(data$cancer[i],"_")[[1]][2]
}


data = data[,-9]
aa = colnames(data)

c_data = data[,c(aa[1:9],"cancer_type","Dataset",aa[10:13])]

write.table(c_data,"E:/lcw/lncSPA/TIGER/res/1celltree/TIGER_annotation.txt",sep="\t",quote=F,row.names=F)



data = read.table("E:/lcw/lncSPA/zhenghe/result/3bar_plot/TISCH_lncRNA_all_tissue_cell_exp_mean.round_4.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
data$cancer = str_c(data$cancer_type,data$Dataset,sep = "_")
aa = data.frame(name =colnames(data))
all_name = read.table("E:/lcw/lncSPA/zhenghe/all_cell_type_name.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

aa$cell = aa$name

for(i in 1:nrow(aa)){
  if(aa$name[i] %in% all_name$name){
    aa$cell[i] = all_name$Var1[all_name$name == aa$name[i]]
  }
}
colnames(data) = aa$cell

write.table(data,"E:/lcw/lncSPA/zhenghe/result/3bar_plot/tisch_lncRNA_all_tissue_cell_exp_mean.round_4.txt",sep="\t",quote=F,row.names=F)

##细胞名斜杠换成or
library(stringr)
data = read.table("E:/lcw/lncSPA/zhenghe/result/3bar_plot/TISCH_lncRNA_all_tissue_cell_exp_mean.round_4.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

aa = data.frame(name =colnames(data))
aa$cell = aa$name

for(i in 1:dim(aa)[1]){
  if(str_detect(aa$name[i],pattern = "/")){
    aa$cell[i] = str_replace(aa$cell[i],"/"," or ")
  }
}

colnames(data) = aa$cell

write.table(data,"E:/lcw/lncSPA/zhenghe/result/3bar_plot/tisch_lncRNA_all_tissue_cell_exp_mean.round_4.txt",sep="\t",quote=F,row.names=F)

####11.9会后改正-----
normal_a = read.table("E:\\lcw\\lncSPA\\统计\\normal_a.txt",header=T,sep="\t",stringsAsFactors=F)
normal_f = read.table("E:\\lcw\\lncSPA\\统计\\normal_f.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_p = read.table("E:\\lcw\\lncSPA\\统计\\cancer_p.txt",header=T,sep="\t",stringsAsFactors=F)
cacner_a = read.table("E:\\lcw\\lncSPA\\统计\\cancer_a.txt",header=T,sep="\t",stringsAsFactors=F)

cancer_resource = read.table("E:\\lcw\\lncSPA\\统计\\cancer_resource.txt",header=T,sep="\t",stringsAsFactors=F)
tissue_cell = read.table("E:\\lcw\\lncSPA\\统计\\tissue_cell.txt",header=T,sep="\t",stringsAsFactors=F)

#normal_a
for(i in 1:dim(normal_a)[1]){
  normal_a$cancer[i] = str_split(normal_a$tissue_full[i],pattern = "\\(")[[1]][1]
  normal_a$source[i] = str_split(normal_a$tissue_full[i],pattern = "\\(")[[1]][2]
}

normal_a$cancer = str_replace_all(normal_a$cancer,pattern = c("_"),replacement = " ")
normal_a$cancer = str_replace_all(normal_a$cancer,pattern = c("-"),replacement = " ")

normal_a$source = str_sub(normal_a$source,1,-2)

write.xlsx(normal_a,"D:/Desktop/narmal_aaaa.xlsx")

normal_a = read.xlsx("D:/Desktop/narmal_aaaa.xlsx")

normal_a$tissue_full_01 = str_c(normal_a$cancer," (",normal_a$source,")",sep = "")

for(i in 1:dim(normal_a)[1]){
  normal_a$tissue[i] = str_c(normal_a$cancer[i],str_split(normal_a$tissue[i],pattern = "=")[[1]][2],sep = "=")
}

normal_a = normal_a[,c(1,2,5)]

write.table(normal_a,"E:\\lcw\\lncSPA\\统计\\normal_a.txt",sep="\t",quote=F,row.names=F)
###cancer_a

for(i in 1:dim(cacner_a)[1]){
  cacner_a$cancer[i] = str_split(cacner_a$tissue_full[i],pattern = "\\(")[[1]][1]
  cacner_a$source[i] = str_split(cacner_a$tissue_full[i],pattern = "\\(")[[1]][2]
}

cacner_a$cancer = str_replace_all(cacner_a$cancer,pattern = c("_"),replacement = " ")
cacner_a$cancer = str_replace_all(cacner_a$cancer,pattern = c("-"),replacement = " ")

cacner_a$source = str_sub(cacner_a$source,1,-2)

write.xlsx(cacner_a,"D:/Desktop/cancer_aaaa.xlsx")

cancer_a = read.xlsx("D:/Desktop/cancer_aaaa.xlsx")

cancer_a$tissue_full = str_c(cancer_a$cancer," (",cancer_a$source,")",sep = "")

for(i in 1:dim(cancer_a)[1]){
  cancer_a$tissue[i] = str_c(cancer_a$cancer[i],str_split(cancer_a$tissue[i],pattern = "=")[[1]][2],sep = "=")
}


cancer_a = cancer_a[,c(1,2,5)]

write.table(cancer_a,"E:\\lcw\\lncSPA\\统计\\cancer_a.txt",sep="\t",quote=F,row.names=F)

####cancer_p

for(i in 1:dim(cancer_p)[1]){
  cancer_p$cancer[i] = str_split(cancer_p$tissue_full[i],pattern = "\\(")[[1]][1]
  cancer_p$source[i] = str_split(cancer_p$tissue_full[i],pattern = "\\(")[[1]][2]
}
cancer_p$source = str_sub(cancer_p$source,1,-2)

write.xlsx(cancer_p,"D:/Desktop/cancer_pppp.xlsx")
cancer_p = read.xlsx("D:/Desktop/cancer_pppp.xlsx")

cancer_p$tissue_full = str_c(cancer_p$cancer," (",cancer_p$source,")",sep = "")


for(i in 1:dim(cancer_p)[1]){
  cancer_p$tissue[i] = str_c(cancer_p$cancer[i],str_split(cancer_p$tissue[i],pattern = "=")[[1]][2],sep = "=")
}

cancer_p = cancer_p[,c(1,2,5)]

write.table(cancer_p,"E:\\lcw\\lncSPA\\统计\\cancer_p.txt",sep="\t",quote=F,row.names=F)

####normal_f
for(i in 1:dim(normal_f)[1]){
  normal_f$cancer[i] = str_split(normal_f$tissue_full[i],pattern = "\\(")[[1]][1]
  normal_f$source[i] = str_split(normal_f$tissue_full[i],pattern = "\\(")[[1]][2]
}
normal_f$source = str_sub(normal_f$source,1,-2)

write.xlsx(normal_f,"D:/Desktop/normal_ffff.xlsx")

normal_f = read.xlsx("D:/Desktop/normal_ffff.xlsx")

normal_f$tissue_full = str_c(normal_f$cancer," (",normal_f$source,")",sep = "")


for(i in 1:dim(normal_f)[1]){
  normal_f$tissue[i] = str_c(normal_f$cancer[i],str_split(normal_f$tissue[i],pattern = "=")[[1]][2],sep = "=")
}

normal_f = normal_f[,c(1,2)]

write.table(normal_f,"E:\\lcw\\lncSPA\\统计\\normal_f.txt",sep="\t",quote=F,row.names=F)

####cancer_resource

for(i in 1:dim(cancer_resource)[1]){
  cancer_resource$cancer[i] = str_split(cancer_resource$tissue_full[i],pattern = "\\(")[[1]][1]
  cancer_resource$source[i] = str_split(cancer_resource$tissue_full[i],pattern = "\\(")[[1]][2]
}


cancer_resource$cancer = str_replace_all(cancer_resource$cancer,pattern = c("_"),replacement = " ")
cancer_resource$cancer = str_replace_all(cancer_resource$cancer,pattern = c("-"),replacement = " ")

cancer_resource$source = str_sub(cancer_resource$source,1,-2)

write.xlsx(cancer_resource,"D:/Desktop/cancer_resource.xlsx")

cancer_resource = read.xlsx("D:/Desktop/cancer_resource.xlsx")


cancer_resource$tissue_full = str_c(cancer_resource$cancer," (",cancer_resource$source,")",sep = "")

for(i in 1:dim(cancer_resource)[1]){
  cancer_resource$tissue[i] = str_c(cancer_resource$cancer[i],str_split(cancer_resource$tissue[i],pattern = "=")[[1]][2],sep = "=")
}


cancer_resource = cancer_resource[,c(1,2,3,4)]
colnames(cancer_resource)[4] = "cancer_full_name"

write.table(cancer_resource,"E:\\lcw\\lncSPA\\统计\\cancer_resource.txt",sep="\t",quote=F,row.names=F)

####tissue_cell
tissue_cell$tissue_type_01 = tissue_cell$tissue_type

tissue_cell$tissue_type_01 = str_replace_all(tissue_cell$tissue_type_01,pattern = c("_"),replacement = " ")
tissue_cell$tissue_type_01 = str_replace_all(tissue_cell$tissue_type_01,pattern = c("-"),replacement = " ")

write.xlsx(tissue_cell,"D:/Desktop/tissue_cell.xlsx")

tissue_cell = read.xlsx("D:/Desktop/tissue_cell.xlsx")

write.table(tissue_cell,"E:\\lcw\\lncSPA\\统计\\tissue_cell.txt",sep="\t",quote=F,row.names=F)

#############
normal_a = read.table("E:\\lcw\\lncSPA\\统计\\normal_a.txt",header=T,sep="\t",stringsAsFactors=F)
normal_f = read.table("E:\\lcw\\lncSPA\\统计\\normal_f.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_p = read.table("E:\\lcw\\lncSPA\\统计\\cancer_p.txt",header=T,sep="\t",stringsAsFactors=F)
cacner_a = read.table("E:\\lcw\\lncSPA\\统计\\cancer_a.txt",header=T,sep="\t",stringsAsFactors=F)

cancer_resource = read.table("E:\\lcw\\lncSPA\\统计\\cancer_resource.txt",header=T,sep="\t",stringsAsFactors=F)


normal_a0 = read.table("E:\\lcw\\lncSPA\\统计\\normal_a_0.txt",header=T,sep="\t",stringsAsFactors=F)
normal_f0 = read.table("E:\\lcw\\lncSPA\\统计\\normal_f_0.txt",header=T,sep="\t",stringsAsFactors=F)
cancer_p0 = read.table("E:\\lcw\\lncSPA\\统计\\cancer_p_0.txt",header=T,sep="\t",stringsAsFactors=F)
cacner_a0 = read.table("E:\\lcw\\lncSPA\\统计\\cancer_a_0.txt",header=T,sep="\t",stringsAsFactors=F)

cancer_resource0 = read.table("E:\\lcw\\lncSPA\\统计\\cancer_resource_0.txt",header=T,sep="\t",stringsAsFactors=F)


####11.16maybe是最后一次改动---------
library(stringr)
library(dplyr)
##1.basic加一列compartment
#hcl_basic

hcl_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\hcl_basic.txt",header=T,sep="\t",stringsAsFactors=F)
hcl_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\hcl_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

hcl_basic_adult = hcl_basic[hcl_basic$source == "adult",]
hcl_basic_fetal = hcl_basic[hcl_basic$source == "fetal",]

hcl_celltree_adult = hcl_celltree[hcl_celltree$source == "adult",]
hcl_celltree_fetal = hcl_celltree[hcl_celltree$source == "fetal",]

table_adult = hcl_celltree_adult %>% distinct(cell_type,compartment, .keep_all = T)
table_fetal = hcl_celltree_fetal %>% distinct(cell_type,compartment, .keep_all = T)

for(i in 1:nrow(table_adult)){
  hcl_basic_adult$compartment[hcl_basic_adult$cell == table_adult$cell_type[i]] = table_adult$compartment[i]
}

for(i in 1:nrow(table_fetal)){
  hcl_basic_fetal$compartment[hcl_basic_fetal$cell == table_fetal$cell_type[i]] = table_fetal$compartment[i]
}

hcl = rbind(hcl_basic_adult,hcl_basic_fetal)

write.table(hcl,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\hcl_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()

#tts

tts_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\tts_basic.txt",header=T,sep="\t",stringsAsFactors=F)
tts_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\tts_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

for(i in 1:nrow(tts_celltree)){
  tts_basic$compartment[tts_basic$cell == tts_celltree$cell_type[i] & tts_basic$tissue == tts_celltree$tissue_type[i]] = tts_celltree$compartment[i]
}

write.table(tts_basic,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\tts_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()

#tica

tica_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\tica_basic.txt",header=T,sep="\t",stringsAsFactors=F)
tica_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\tica_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

for(i in 1:nrow(tica_celltree)){
  tica_basic$compartment[tica_basic$cell == tica_celltree$cell_type[i] & tica_basic$tissue == tica_celltree$tissue_type[i]] = tica_celltree$compartment[i]
}

write.table(tica_basic,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\tica_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()

#tiger

tiger_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\tiger_basic.txt",header=T,sep="\t",stringsAsFactors=F)
tiger_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\tiger_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

for(i in 1:nrow(tiger_celltree)){
  tiger_basic$compartment[tiger_basic$cell == tiger_celltree$cell_type[i] & tiger_basic$tissue == tiger_celltree$tissue_type[i] & tiger_basic$dataset == tiger_celltree$dataset[i]] = tiger_celltree$compartment[i]
}

write.table(tiger_basic,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\tiger_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()


#cell_res

cell_res_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F)
cell_res_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\cell_res_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

for(i in 1:nrow(cell_res_celltree)){
  cell_res_basic$compartment[cell_res_basic$cell == cell_res_celltree$cell_type[i] & cell_res_basic$tissue == cell_res_celltree$tissue_type[i]] = cell_res_celltree$compartment[i]
}

write.table(cell_res_basic,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\cell_res_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()



#other

other_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\other_basic.txt",header=T,sep="\t",stringsAsFactors=F)
other_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\other_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

for(i in 1:nrow(other_celltree)){
  other_basic$compartment[other_basic$cell == other_celltree$cell_type[i] & other_basic$tissue == other_celltree$tissue_type[i] & other_basic$source == other_celltree$source[i]] = other_celltree$compartment[i]
}

write.table(other_basic,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()



#geo

geo_basic = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F)
geo_celltree = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\geo_celltree.txt",header=T,sep="\t",stringsAsFactors=F)

for(i in 1:nrow(geo_celltree)){
  geo_basic$compartment[geo_basic$cell == geo_celltree$cell_type[i] & geo_basic$tissue == geo_celltree$tissue_type[i] & geo_basic$dataset == geo_celltree$dataset[i]] = geo_celltree$compartment[i]
}

write.table(geo_basic,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()

##2.other的四个文件
#GSE140819.cell.cell_type.tsne_x.tsne_y.exp.round_4

library(stringr)
data = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\GSE140819.cell.cell_type.tsne_x.tsne_y.exp.round_4.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data[1,] = str_replace_all(data[1,],"/"," or ")

data_adult = data[,1:12]
data_fetal = data[,c(1,13:16)]

colnames(data_adult)[2:12] = str_sub(colnames(data_adult)[2:12],7,-1)


write.table(data_adult,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\GSE140819.cell.cell_type.tsne_x.tsne_y.exp.round_4_adult.txt",sep="\t",quote=F,row.names=F)
write.table(data_fetal,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\GSE140819.cell.cell_type.tsne_x.tsne_y.exp.round_4_fetal.txt",sep="\t",quote=F,row.names=F)



#GSE140819.cell.exp_max
data = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\GSE140819.cell.exp_max.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data_adult = data[,1:12]
data_fetal = data[,c(1,13:16)]

colnames(data_adult)[2:ncol(data_adult)] = str_sub(colnames(data_adult)[2:ncol(data_adult)],7,-1)

write.table(data_adult,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\GSE140819.cell.exp_max_adult.txt",sep="\t",quote=F,row.names=F)
write.table(data_fetal,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\GSE140819.cell.exp_max_fetal.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()


#GSE140819_lncRNA_all_tissue_cell_exp_mean.round_4

data = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\GSE140819_lncRNA_all_tissue_cell_exp_mean.round_4.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data_adult = data[str_detect(data$tissue_type,"Adult"),]
data_fetal = data[str_detect(data$tissue_type,"Pediatric"),]

data_adult$tissue_type = str_sub(data_adult$tissue_type,7,-1)

write.table(data_adult,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\GSE140819_lncRNA_all_tissue_cell_exp_mean.round_4_adult.txt",sep="\t",quote=F,row.names=F)
write.table(data_fetal,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\GSE140819_lncRNA_all_tissue_cell_exp_mean.round_4_fetal.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()



#other_paste

data = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\other_paste.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

tt = c()

for(i in 1:nrow(data)){
  if((str_detect(data$tissue_type[i],"Adult") == F) & (str_detect(data$tissue_type[i],"Pediatric") == F)){
    tt = c(tt,i)
    data$mRNA[i-1] = str_c(data$mRNA[i-1],data$tissue_type[i],sep = "")
  }
}

write.table(data,"D:\\Desktop\\fetal.txt",sep="\t",quote=F,row.names=F)


data_adult = data[str_detect(data$tissue_type,"Adult"),]
data_fetal = data[str_detect(data$tissue_type,"Pediatric"),]

data_adult$tissue_type = str_sub(data_adult$tissue_type,7,-1)

write.table(data_adult,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_paste_adult.txt",sep="\t",quote=F,row.names=F)
write.table(data_fetal,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_paste_fetal.txt",sep="\t",quote=F,row.names=F)

rm(list = ls())
gc()


##cancer_resource、cancer_a

data = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\cancer_resource.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data$cancer_name[data$cancer_name == "Adenocarcinoma and squamous cell carcinoma"] = "Lung adenocarcinoma and lung squamous cell carcinoma"

data$tissue_full = str_replace_all(data$tissue_full,"_"," ")


cancer_a = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\cancer_a.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

cancer_a$cancer_full[cancer_a$cancer_full == "Adenocarcinoma and squamous cell carcinoma"] = "Lung adenocarcinoma and lung squamous cell carcinoma"

cancer_a$tissue_full = str_replace_all(cancer_a$tissue_full,"_"," ")

data = data[-which(data$cancer_name == "Corona virus disease 2019"),]
cancer_a = cancer_a[-which(cancer_a$cancer_full == "Corona virus disease 2019"),]


write.table(data,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\cancer_resource.txt",sep="\t",quote=F,row.names=F)
write.table(cancer_a,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\cancer_a.txt",sep="\t",quote=F,row.names=F)


# 癌症大类
library(openxlsx)
aa = as.data.frame(table(data$tissue_full))

for(i in 1:nrow(aa)){
  aa$cancer[i] = str_split(as.character(aa$Var1[i]),"\\(")[[1]][1]
  aa$source[i] = str_split(as.character(aa$Var1[i]),"\\(")[[1]][2]
}


aa$cancer = str_sub(aa$cancer,1,-2)
aa$source = str_sub(aa$source,1,-2)


write.xlsx(aa,"D:\\Desktop\\cancer_class_aaaa.xlsx")

cancer_class = read.xlsx("D:\\Desktop\\cancer_class_aaaa.xlsx")


cancer_class = cancer_class[-which(cancer_class$cancer_full_name == "Corona virus disease 2019"),]

write.table(cancer_class,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\cancer_class.txt",sep="\t",quote=F,row.names=F)


##cancer_class和cancer_resource整合
data = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\cancer_resource.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

cancer_class = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cancer_class.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)


for(i in 1:nrow(cancer_class)){
  data$cancer_type[data$tissue_full == cancer_class$Var1[i]] = cancer_class$cancer_type[i]
}

for(i in 1:nrow(data)){
  data$cancer[i] = str_split(data$tissue_full[i],"\\(")[[1]][1]
  data$source[i] = str_split(data$tissue_full[i],"\\(")[[1]][2]
  data$class[i] = str_split(data$tissue[i],"=")[[1]][length(str_split(data$tissue[i],"=")[[1]])]
}

data$cancer = str_sub(data$cancer,1,-2)
data$source = str_sub(data$source,1,-2)
#data$source = str_replace_all(data$source," ","_")
data$source[data$source == "Junbin Qian. Cell Research. 2020"] = "Qian et al., Cell Research 2020"

data = data[-which(data$cancer_name == "Corona virus disease 2019"),]

data$search = str_c(data$source,"=",data$class,sep = "")
data$display = str_replace_all(data$source,"_"," ")

cancer_resource = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cancer_resource.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data$tissue_full = str_c(data$cancer," ","(",str_replace_all(data$source,"_"," "),")",sep = "")

for(i in 1:nrow(cancer_class)){
  data$cancer_type[data$tissue_full == cancer_class$Var1[i]] = cancer_class$cancer_type[i]
}


write.xlsx(data,"D:\\Desktop\\aa_aa_aa.xlsx")
data = read.xlsx("D:\\Desktop\\aa_aa_aa.xlsx")

data01 = data[,c(1:4,10)]


write.table(data01,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\cancer_resource_after.txt",sep="\t",quote=F,row.names=F)


data_search = data[data$class %in% c("tiger","geo"),c(8,9)]
data_search = data_search[c(str_detect(data_search$search,"geo"),str_detect(data_search$search,"tiger")),]

write.table(data_search,"E:\\lcw\\lncSPA\\统计\\11.16\\after\\search.txt",sep="\t",quote=F,row.names=F)


#12.05整理数据-----
##interat_basic.txt-整合正常和癌症的染色体、name、ID信息
library(stringr)
library(openxlsx)
library(dplyr)
hcl = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\hcl_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tts_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tica_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
geo = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tiger_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\epn_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

integrate_basic = rbind(geo[,c("gene_name","ensembl_gene_id","seqnames")],
                        other[,c("gene_name","ensembl_gene_id","seqnames")],
                        cell_res[,c("gene_name","ensembl_gene_id","seqnames")],
                        tiger[,c("gene_name","ensembl_gene_id","seqnames")],
                        epn[,c("gene_name","ensembl_gene_id","seqnames")],
                        hcl[,c("gene_name","ensembl_gene_id","seqnames")],
                        tts[,c("gene_name","ensembl_gene_id","seqnames")],
                        tica[,c("gene_name","ensembl_gene_id","seqnames")])

integrate_basic = integrate_basic %>% distinct(gene_name,ensembl_gene_id,seqnames,.keep_all = T)


write.table(integrate_basic,"E:\\lcw\\lncSPA\\统计\\12.06_res\\integrate_basic.txt",sep="\t",quote=F,row.names=F)
##lncRNA_barplot-----

lncRNA_barplot = data.frame()
####emtab
emtab = geo[str_detect(geo$dataset,"EMTAB"),]
temp = as.data.frame(table(emtab$gene_name))

lncRNA_barplot = rbind(lncRNA_barplot,temp)
colnames(lncRNA_barplot) = c("gene_name","EMTAB")

####cra
cra = geo[str_detect(geo$dataset,"CRA"),]
temp = as.data.frame(table(cra$gene_name))

colnames(temp) = c("gene_name","NGDC")

lncRNA_barplot = merge(lncRNA_barplot,temp,by = "gene_name",all = T)

####hcl
temp = as.data.frame(table(hcl$gene_name))
colnames(temp) = c("gene_name","hcl")
lncRNA_barplot = merge(lncRNA_barplot,temp,by = "gene_name",all = T)

####tts
temp = as.data.frame(table(tts$gene_name))
colnames(temp) = c("gene_name","tts")
lncRNA_barplot = merge(lncRNA_barplot,temp,by = "gene_name",all = T)

####cell_res
temp = as.data.frame(table(cell_res$gene_name))
colnames(temp) = c("gene_name","cell_res")
lncRNA_barplot = merge(lncRNA_barplot,temp,by = "gene_name",all = T)


####tica
temp = as.data.frame(table(tica$gene_name))
colnames(temp) = c("gene_name","tica")
lncRNA_barplot = merge(lncRNA_barplot,temp,by = "gene_name",all = T)


####geo
geo = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
geo = geo[str_detect(geo$dataset,"GSE"),]

geo = rbind(data.frame(gene = geo[,1]),data.frame(gene = tiger[,1]),data.frame(gene = epn[,1]),data.frame(gene = other[,1]))

temp = as.data.frame(table(geo$gene))
colnames(temp) = c("gene_name","GEO")
lncRNA_barplot = merge(lncRNA_barplot,temp,by = "gene_name",all = T)

lncRNA_barplot[is.na(lncRNA_barplot)] = 0

lncRNA_barplot$total = apply(lncRNA_barplot,1,function(x){sum(as.numeric(x[2:8]))})

lncRNA_barplot = lncRNA_barplot[order(lncRNA_barplot$total,decreasing = T),]

lncRNA_barplot_top20 = lncRNA_barplot[1:20,]


write.table(lncRNA_barplot,"E:\\lcw\\lncSPA\\统计\\12.06_res\\lncRNA_barplot.txt",sep="\t",quote=F,row.names=F)
write.table(lncRNA_barplot_top20,"E:\\lcw\\lncSPA\\统计\\12.06_res\\lncRNA_barplot_top20.txt",sep="\t",quote=F,row.names=F)

##normal_centric----
rm(list = ls())
gc()
hcl = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\hcl_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tts_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tica_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

aa = rbind(as.data.frame(table(hcl$tissue)),as.data.frame(table(tts$tissue)),as.data.frame(table(tica$tissue)))
aa$Var1 = as.character(aa$Var1)
aa = as.data.frame(table(aa$Var1))
write.xlsx(aa,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tissue.xlsx")

tissue = read.xlsx("E:\\lcw\\lncSPA\\统计\\12.06_res\\tissue.xlsx")##对应表---

treeleaf_normal = rbind(hcl[hcl$source == "adult",c("gene_name","ensembl_gene_id","seqnames","tissue")],
                        tts[,c("gene_name","ensembl_gene_id","seqnames","tissue")],
                        tica[,c("gene_name","ensembl_gene_id","seqnames","tissue")])

for(i in 1:nrow(treeleaf_normal)){
  treeleaf_normal$tissue[i] = tissue$tissue[tissue$Var1 == treeleaf_normal$tissue[i]]
}

write.table(treeleaf_normal,"E:\\lcw\\lncSPA\\统计\\12.06_res\\treeleaf_normal.txt",sep="\t",quote=F,row.names=F)


####tts
tts_treeleaf = tts[,c("gene_name","ensembl_gene_id","seqnames","tissue")]
tts_treeleaf$tissue_new = 0
tts_treeleaf$System = 0


for(i in 1:nrow(tts_treeleaf)){
  tts_treeleaf$tissue_new[i] = tissue$tissue[tissue$Var1 == tts_treeleaf$tissue[i]]
  tts_treeleaf$System[i] = tissue$system[tissue$Var1 == tts_treeleaf$tissue[i]]
}

tts_treeleaf = tts_treeleaf[,-4]
colnames(tts_treeleaf)[4] = "tissue"

tts_order = as.data.frame(table(tts_treeleaf$tissue))
tts_order = tts_order[order(tts_order$Freq,decreasing = F),]

write.table(tts_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tts_order.txt",sep="\t",quote=F,row.names=F)
write.table(tts_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tts_treeleaf.txt",sep="\t",quote=F,row.names=F)

####tica
tica_treeleaf = tica[,c("gene_name","ensembl_gene_id","seqnames","tissue")]
tica_treeleaf$tissue_new = 0
tica_treeleaf$System = 0


for(i in 1:nrow(tica_treeleaf)){
  tica_treeleaf$tissue_new[i] = tissue$tissue[tissue$Var1 == tica_treeleaf$tissue[i]]
  tica_treeleaf$System[i] = tissue$system[tissue$Var1 == tica_treeleaf$tissue[i]]
}

tica_treeleaf = tica_treeleaf[,-4]
colnames(tica_treeleaf)[4] = "tissue"

tica_order = as.data.frame(table(tica_treeleaf$tissue))
tica_order = tica_order[order(tica_order$Freq,decreasing = F),]

write.table(tica_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tica_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(tica_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tica_order.txt",sep="\t",quote=F,row.names=F)

####hcl_adult
hcl_adult_treeleaf = hcl[hcl$source == "adult",c("gene_name","ensembl_gene_id","seqnames","tissue")]
hcl_adult_treeleaf$tissue_new = 0
hcl_adult_treeleaf$System = 0


for(i in 1:nrow(hcl_adult_treeleaf)){
  hcl_adult_treeleaf$tissue_new[i] = tissue$tissue[tissue$Var1 == hcl_adult_treeleaf$tissue[i]]
  hcl_adult_treeleaf$System[i] = tissue$system[tissue$Var1 == hcl_adult_treeleaf$tissue[i]]
}

hcl_adult_treeleaf = hcl_adult_treeleaf[,-4]
colnames(hcl_adult_treeleaf)[4] = "tissue"

hcl_adult_order = as.data.frame(table(hcl_adult_treeleaf$tissue))
hcl_adult_order = hcl_adult_order[order(hcl_adult_order$Freq,decreasing = F),]

write.table(hcl_adult_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\hcl_adult_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(hcl_adult_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\hcl_adult_order.txt",sep="\t",quote=F,row.names=F)

####hcl_fetal
hcl_fetal_treeleaf = hcl[hcl$source == "fetal",c("gene_name","ensembl_gene_id","seqnames","tissue")]
hcl_fetal_treeleaf$tissue_new = 0
hcl_fetal_treeleaf$System = 0


for(i in 1:nrow(hcl_fetal_treeleaf)){
  hcl_fetal_treeleaf$tissue_new[i] = tissue$tissue[tissue$Var1 == hcl_fetal_treeleaf$tissue[i]]
  hcl_fetal_treeleaf$System[i] = tissue$system[tissue$Var1 == hcl_fetal_treeleaf$tissue[i]]
}

hcl_fetal_treeleaf = hcl_fetal_treeleaf[,-4]
colnames(hcl_fetal_treeleaf)[4] = "tissue"

hcl_fetal_order = as.data.frame(table(hcl_fetal_treeleaf$tissue))
hcl_fetal_order = hcl_fetal_order[order(hcl_fetal_order$Freq,decreasing = F),]

write.table(hcl_fetal_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\hcl_fetal_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(hcl_fetal_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\hcl_fetal_order.txt",sep="\t",quote=F,row.names=F)




pinjie = function(x){
  temp = ""
  for(m in 1:length(x)){
    temp = str_c(temp,as.character(x[m]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}

###tts__截图表
tissue_data = as.data.frame(table(tts$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()


for(i in 1:nrow(tissue_data)){
  data = tts[tts$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                          num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
  
}


for(i in 1:nrow(final_data)){
  final_data$tissue[i] = tissue$tissue[tissue$Var1 == final_data$tissue[i]]
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tts_data.txt",sep="\t",quote=F,row.names=F)


###tica__截图表
tissue_data = as.data.frame(table(tica$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()


for(i in 1:nrow(tissue_data)){
  data = tica[tica$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                               num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
  
}


for(i in 1:nrow(final_data)){
  final_data$tissue[i] = tissue$tissue[tissue$Var1 == final_data$tissue[i]]
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\tica_data.txt",sep="\t",quote=F,row.names=F)



##cancer_centric----
geo = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tiger_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\epn_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

aa = rbind(as.data.frame(table(geo$tissue)),as.data.frame(table(other$tissue)),as.data.frame(table(cell_res$tissue)),
           as.data.frame(table(tiger$tissue)),as.data.frame(table(epn$tissue)))
aa$Var1 = as.character(aa$Var1)

aa = as.data.frame(table(aa$Var1))

write.xlsx(aa,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cancer.xlsx")

cancer = read.xlsx("E:\\lcw\\lncSPA\\统计\\12.06_res\\cancer.xlsx")


###treeleaf_cancer_adult
treeleaf_cancer_adult = rbind(geo[,c("gene_name","ensembl_gene_id","seqnames","tissue")],
                       other[other$source == "adult",c("gene_name","ensembl_gene_id","seqnames","tissue")],
                       cell_res[,c("gene_name","ensembl_gene_id","seqnames","tissue")],
                       tiger[,c("gene_name","ensembl_gene_id","seqnames","tissue")])

write.table(treeleaf_cancer_adult,"E:\\lcw\\lncSPA\\统计\\12.06_res\\treeleaf_cancer_adult.txt",sep="\t",quote=F,row.names=F)


###treeleaf_cancer_adult
treeleaf_cancer_fetal = rbind(epn[,c("gene_name","ensembl_gene_id","seqnames","tissue")],
                              other[other$source == "fetal",c("gene_name","ensembl_gene_id","seqnames","tissue")])

write.table(treeleaf_cancer_fetal,"E:\\lcw\\lncSPA\\统计\\12.06_res\\treeleaf_cancer_fetal.txt",sep="\t",quote=F,row.names=F)


####emtab
emtab_treeleaf = geo[str_detect(geo$dataset,"EMTAB"),c("gene_name","ensembl_gene_id","seqnames","tissue","source")]
emtab_treeleaf$System = 0
for(i in 1:nrow(emtab_treeleaf)){
  emtab_treeleaf$System[i] = cancer$System[cancer$Var1 == emtab_treeleaf$tissue[i]]
}

emtab_order = as.data.frame(table(emtab_treeleaf$tissue))
emtab_order = emtab_order[order(emtab_order$Freq,decreasing = F),]

write.table(emtab_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\emtab_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(emtab_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\emtab_order.txt",sep="\t",quote=F,row.names=F)


####cra
cra_treeleaf = geo[str_detect(geo$dataset,"CRA"),c("gene_name","ensembl_gene_id","seqnames","tissue","source")]
cra_treeleaf$System = 0
for(i in 1:nrow(cra_treeleaf)){
  cra_treeleaf$System[i] = cancer$System[cancer$Var1 == cra_treeleaf$tissue[i]]
}

cra_order = as.data.frame(table(cra_treeleaf$tissue))
cra_order = cra_order[order(cra_order$Freq,decreasing = F),]

write.table(cra_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cra_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(cra_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cra_order.txt",sep="\t",quote=F,row.names=F)
####geo

geo = geo[str_detect(geo$dataset,"GSE"),]

geo = rbind(geo[,c("gene_name","ensembl_gene_id","seqnames","tissue","source")],
            tiger[,c("gene_name","ensembl_gene_id","seqnames","tissue","source")],
            epn[,c("gene_name","ensembl_gene_id","seqnames","tissue","source")],
            other[,c("gene_name","ensembl_gene_id","seqnames","tissue","source")])


####geo_adult
geo_adult_treeleaf = geo[geo$source == "adult",]

geo_adult_treeleaf$System = 0


for(i in 1:nrow(geo_adult_treeleaf)){
  geo_adult_treeleaf$System[i] = cancer$System[cancer$Var1 == geo_adult_treeleaf$tissue[i]]
}

geo_adult_order = as.data.frame(table(geo_adult_treeleaf$tissue))
geo_adult_order = geo_adult_order[order(geo_adult_order$Freq,decreasing = F),]

write.table(geo_adult_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_adult_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(geo_adult_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_adult_order.txt",sep="\t",quote=F,row.names=F)


####geo_fetal
geo_fetal_treeleaf = geo[geo$source == "fetal",]

geo_fetal_treeleaf$System = 0


for(i in 1:nrow(geo_fetal_treeleaf)){
  geo_fetal_treeleaf$System[i] = cancer$System[cancer$Var1 == geo_fetal_treeleaf$tissue[i]]
}

geo_fetal_order = as.data.frame(table(geo_fetal_treeleaf$tissue))
geo_fetal_order = geo_fetal_order[order(geo_fetal_order$Freq,decreasing = F),]

write.table(geo_fetal_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_fetal_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(geo_fetal_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_fetal_order.txt",sep="\t",quote=F,row.names=F)



####cell_res
cell_res_treeleaf = cell_res[,c("gene_name","ensembl_gene_id","seqnames","tissue")]
cell_res_treeleaf$System = 0


for(i in 1:nrow(cell_res_treeleaf)){
  cell_res_treeleaf$System[i] = cancer$System[cancer$Var1 == cell_res_treeleaf$tissue[i]]
}

cell_res_order = as.data.frame(table(cell_res_treeleaf$tissue))
cell_res_order = cell_res_order[order(cell_res_order$Freq,decreasing = F),]

write.table(cell_res_treeleaf,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cell_res_treeleaf.txt",sep="\t",quote=F,row.names=F)
write.table(cell_res_order,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cell_res_order.txt",sep="\t",quote=F,row.names=F)



pinjie = function(x){
  temp = ""
  for(m in 1:length(x)){
    temp = str_c(temp,as.character(x[m]),sep = ",")
  }
  temp = str_sub(temp,2,-1)
  return(temp)
}

geo = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tiger_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\epn_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

emtab = geo[str_detect(geo$dataset,"EMTAB"),]
cra = geo[str_detect(geo$dataset,"CRA"),]

geo = geo[str_detect(geo$dataset,"GSE"),]

geo = rbind(geo[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")],
            tiger[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")],
            epn[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")],
            other[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")])



###emtab__截图表


tissue_data = as.data.frame(table(emtab$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()

for(i in 1:nrow(tissue_data)){
  data = emtab[emtab$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                               num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\emtab_data.txt",sep="\t",quote=F,row.names=F)


# ###geo__截图表
# tissue_data = as.data.frame(table(geo$tissue))
# tissue_data$Var1 = as.character(tissue_data$Var1)
# 
# final_data = data.frame()
# 
# for(i in 1:nrow(tissue_data)){
#   data = geo[geo$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
#   cell_data = table(data$cell) %>% as.data.frame()
#   cell_data$Var1 = as.character(cell_data$Var1)
#   cell = ""
#   num = ""
#   CE = ""
#   
#   for(j in 1:nrow(cell_data)){
#     data_01 = data[data$cell == cell_data$Var1[j],]
#     CE_data = table(data_01$classification) %>% as.data.frame()
#     CE_temp = pinjie(CE_data$Var1)
#     num_temp = pinjie(CE_data$Freq)
#     cell = str_c(cell,cell_data$Var1[j],sep = ",")
#     num = str_c(num,num_temp,sep = ";")
#     CE = str_c(CE,CE_temp,sep = ";")
#   }
#   
#   final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
#                                num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
#   
#   final_data = rbind(final_data,final_data_temp)
# }
# 
# write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_data.txt",sep="\t",quote=F,row.names=F)


###cra__截图表
tissue_data = as.data.frame(table(cra$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()

for(i in 1:nrow(tissue_data)){
  data = cra[cra$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                               num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cra_data.txt",sep="\t",quote=F,row.names=F)


###cell_res__截图表
tissue_data = as.data.frame(table(cell_res$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()

for(i in 1:nrow(tissue_data)){
  data = cell_res[cell_res$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                               num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\cell_res_data.txt",sep="\t",quote=F,row.names=F)


###geo_fetal__截图表
geo_fetal = geo[geo$source == "fetal",]

tissue_data = as.data.frame(table(geo_fetal$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()

for(i in 1:nrow(tissue_data)){
  data = geo_fetal[geo_fetal$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                               num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_fetal_data.txt",sep="\t",quote=F,row.names=F)


###geo_adult__截图表
geo_adult = geo[geo$source == "adult",]

tissue_data = as.data.frame(table(geo_adult$tissue))
tissue_data$Var1 = as.character(tissue_data$Var1)

final_data = data.frame()

for(i in 1:nrow(tissue_data)){
  data = geo_adult[geo_adult$tissue == tissue_data$Var1[i],c("tissue","cell","classification")]
  cell_data = table(data$cell) %>% as.data.frame()
  cell_data$Var1 = as.character(cell_data$Var1)
  cell = ""
  num = ""
  CE = ""
  
  for(j in 1:nrow(cell_data)){
    data_01 = data[data$cell == cell_data$Var1[j],]
    CE_data = table(data_01$classification) %>% as.data.frame()
    CE_temp = pinjie(CE_data$Var1)
    num_temp = pinjie(CE_data$Freq)
    cell = str_c(cell,cell_data$Var1[j],sep = ",")
    num = str_c(num,num_temp,sep = ";")
    CE = str_c(CE,CE_temp,sep = ";")
  }
  
  final_data_temp = data.frame(tissue = tissue_data$Var1[i],cell = str_sub(cell,2,-1),
                               num = str_sub(num,2,-1),CE = str_sub(CE,2,-1))
  
  final_data = rbind(final_data,final_data_temp)
}

write.table(final_data,"E:\\lcw\\lncSPA\\统计\\12.06_res\\geo_adult_data.txt",sep="\t",quote=F,row.names=F)


#12.09统计数据----
###1.Data overview----


##3,4,5数据读取----
rm(list = ls())
gc()

geo = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tiger_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\epn_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

emtab = geo[str_detect(geo$dataset,"EMTAB"),]
cra = geo[str_detect(geo$dataset,"CRA"),]

geo = geo[str_detect(geo$dataset,"GSE"),]

geo = rbind(geo[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")],
            tiger[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")],
            epn[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")],
            other[,c("gene_name","ensembl_gene_id","seqnames","tissue","source","classification","cell")])
rm(tiger,other,epn)


hcl = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\hcl_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tts_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tica_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)


###3、4、5结果统计----
library(stringr)
factor = c("CS","CER","CEH")
source = c("hcl","tts","tica","geo","cell_res","cra","emtab")
list = c("hcl" = hcl,"tts" = tts,"tica" = tica,"geo" = geo,"cell_res" = cell_res,"cra" = cra,"emtab" = emtab)

for(i in 1:length(source)){
  #3.Numbers of TE/CE lncRNAs in each resource
  num_in_resource = as.data.frame(table(list[[str_c(source[i],".classification",sep = "")]]))
  write.table(num_in_resource,str_c("E:\\lcw\\lncSPA\\统计\\12.09_res\\3.number_in_resource\\",source[i],".txt",sep = ""),sep="\t",quote=F,row.names=F)
  
  #4. Numbers of TE/CE lncRNAs in each tissue
  num_in_tissue = as.data.frame(table(list[[str_c(source[i],".tissue",sep = "")]]))
  num_in_tissue$CS = 0
  num_in_tissue$CER = 0
  num_in_tissue$CEH = 0
  for(j in 1:nrow(num_in_tissue)){
    tissue_temp = list[[str_c(source[i],".classification",sep = "")]][list[[str_c(source[i],".tissue",sep = "")]] == as.character(num_in_tissue$Var1[j])]
    table1 = as.data.frame(table(tissue_temp))
    for(k in 1:nrow(table1)){
      num_in_tissue[j,as.character(table1$tissue_temp[k])] = table1$Freq[k]
    }
  }
  write.table(num_in_tissue,str_c("E:\\lcw\\lncSPA\\统计\\12.09_res\\4.number_in_tissue\\",source[i],".txt",sep = ""),sep="\t",quote=F,row.names=F)
  
  #5. TE/CE lncRNAs distribution on chromosome
  num_in_chromosome = as.data.frame(table(list[[str_c(source[i],".seqnames",sep = "")]]))
  num_in_chromosome$CS = 0
  num_in_chromosome$CER = 0
  num_in_chromosome$CEH = 0
  for(j in 1:nrow(num_in_chromosome)){
    chromosome_temp = list[[str_c(source[i],".classification",sep = "")]][list[[str_c(source[i],".seqnames",sep = "")]] == as.character(num_in_chromosome$Var1[j])]
    table2 = as.data.frame(table(chromosome_temp))
    for(k in 1:nrow(table2)){
      num_in_chromosome[j,as.character(table2$chromosome_temp[k])] = table2$Freq[k]
    }
  }

  write.table(num_in_chromosome,str_c("E:\\lcw\\lncSPA\\统计\\12.09_res\\5.number_in_chromosome\\",source[i],".txt",sep = ""),sep="\t",quote=F,row.names=F)
  
  
  
}

table(list[["tts.classification"]])


num_in_chromosome = num_in_chromosome[order(num_in_chromosome$Var1,levels())]


##12.21，癌症正常数据统计----
library(dplyr)
library(openxlsx)
#cancer
geo = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\geo_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\other_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tiger_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\epn_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)



cancer_fetal = data.frame(tissue = epn$tissue,dataset = "GSE125969")
cancer_fetal = rbind(cancer_fetal,data.frame(tissue = other$tissue[other$source == "fetal"],dataset = "GSE140819"))
cancer_fetal = cancer_fetal %>% distinct(tissue,dataset,.keep_all = T)



cancer_adult = rbind(geo[,c("tissue","dataset")],tiger[,c("tissue","dataset")],data.frame(tissue = cell_res$tissue,dataset = "Junbin Qian. Cell Research. 2020"),
                     data.frame(tissue = other$tissue[other$source == "adult"],dataset = "GSE140819"))

cancer_adult = cancer_adult %>% distinct(tissue,dataset,.keep_all = T)

write.xlsx(cancer_fetal,"E:/lcw/lncSPA/统计/12.21/cancer_fetal.xlsx")
write.xlsx(cancer_adult,"E:/lcw/lncSPA/统计/12.21/cancer_adult.xlsx")


cancer_adult = read.xlsx("E:/lcw/lncSPA/统计/12.21/cancer_adult.xlsx")
cancer_fetal = read.xlsx("E:/lcw/lncSPA/统计/12.21/cancer_fetal.xlsx")

cancer_adult_data = as.data.frame(table(cancer_adult$cancer))
cancer_fetal_data = as.data.frame(table(cancer_fetal$cancer))

write.table(cancer_adult_data,"E:/lcw/lncSPA/统计/12.21/cancer_adult_data.txt",sep="\t",quote=F,row.names=F)
write.table(cancer_fetal_data,"E:/lcw/lncSPA/统计/12.21/cancer_fetal_data.txt",sep="\t",quote=F,row.names=F)


#normal
hcl = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\hcl_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tts = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tts_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica = read.table("E:\\lcw\\lncSPA\\统计\\11.16\\after\\tica_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)


normal_fetal = data.frame(tissue = hcl$tissue[hcl$source == "fetal"],dataset = "hcl")
normal_adult = rbind(data.frame(tissue = hcl$tissue[hcl$source == "adult"],dataset = "hcl"),data.frame(tissue = tica$tissue,dataset = "tica"),data.frame(tissue = tts$tissue,dataset = "tts"))

normal_fetal = normal_fetal %>% distinct(tissue,dataset,.keep_all = T)
normal_adult = normal_adult %>% distinct(tissue,dataset,.keep_all = T)


write.xlsx(normal_fetal,"E:/lcw/lncSPA/统计/12.21/normal_fetal.xlsx")
write.xlsx(normal_adult,"E:/lcw/lncSPA/统计/12.21/normal_adult.xlsx")

normal_adult = read.xlsx("E:/lcw/lncSPA/统计/12.21/normal_adult.xlsx")
normal_fetal = read.xlsx("E:/lcw/lncSPA/统计/12.21/normal_fetal.xlsx")


normal_adult_data = as.data.frame(table(normal_adult$tissue_after))
normal_fetal_data = as.data.frame(table(normal_fetal$tissue_after))

write.table(normal_adult_data,"E:/lcw/lncSPA/统计/12.21/normal_adult_data.txt",sep="\t",quote=F,row.names=F)
write.table(normal_fetal_data,"E:/lcw/lncSPA/统计/12.21/normal_fetal_data.txt",sep="\t",quote=F,row.names=F)

#cancer_adult
lncSPA1_cancer_adult = c("Brain cancer","Brain cancer","Lung cancer","Lung cancer","Liver cancer","Kidney cancer","Kidney cancer",
                   "Liver cancer","Colorectal cancer","Prostate Cancer","Bladder cancer","Testicular Cancer","Skin cancer",
                   "Skin cancer","Head and neck cancer","Lymph cancer","Thyroid Cancer","Esophageal Cancer","Pancreatic cancer"
                   ,"Breast cancer","Stomach Cancer","Breast cancer","Kidney cancer","Kidney cancer","Kidney cancer",
                   "Pancreatic cancer","Uterus cancer","Uterus cancer","Skin cancer","Colorectal cancer","Ovarian cancer","Uterus cancer","Leukemia")
cancer_adult1 = as.data.frame(table(lncSPA1_cancer_adult))

cancer_adult1$lncSPA1_cancer_adult = as.character(cancer_adult1$lncSPA1_cancer_adult)
colnames(cancer_adult1) = c("Var1","Freq")

cancer_adult_all = merge(cancer_adult,cancer_adult1,by = "Var1",all = T)
colnames(cancer_adult_all) = c("cancer","lncSPA2","lncSPA1")
cancer_adult_all[is.na(cancer_adult_all)] = 0

cancer_adult_all$all = cancer_adult_all$lncSPA2 + cancer_adult_all$lncSPA1

cancer_adult_data = data.frame(database = rep(c("lncSPA1","lncSPA2"),21),cancer = rep(cancer_adult_all$cancer,each = 2))
for(i in 1:nrow(cancer_adult_data)){cancer_adult_data$number[i] = cancer_adult_all[cancer_adult_all$cancer == cancer_adult_data$cancer[i],cancer_adult_data$database[i]]}
cancer_adult_all = cancer_adult_all[order(cancer_adult_all$all,decreasing = T),]
factor1 = factor(cancer_adult_all$cancer,levels = cancer_adult_all$cancer)
cancer_adult_data$cancer = factor(cancer_adult_data$cancer,levels = cancer_adult_all$cancer)

##堆积柱状图-----
ggplot(cancer_adult_data,aes(cancer,number,fill = database))+##reorder()表示x轴重新排序-
  geom_bar(stat="identity",position="stack")+
  theme(axis.text.x = element_text(angle = 80,hjust = 1))+
  ylab("Dataset Number") + 
  scale_fill_manual(values = c("dodgerblue4","firebrick4"))


#cancer_fetal
cancer_fetal1 = as.data.frame(table(c("Leukemia","Brain cancer","Leukemia","Leukemia","Kidney cancer", "Kidney cancer","Kidney cancer")))
cancer_fetal2 = read.table("E:\\lcw\\lncSPA\\统计\\12.21\\cancer_fetal_data.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

cancer_fetal = merge(cancer_fetal2,cancer_fetal1,by = "Var1",all = T)
colnames(cancer_fetal) = c("cancer","lncSPA2","lncSPA1")
cancer_fetal[is.na(cancer_fetal)] = 0

cancer_fetal_data = data.frame(database = rep(c("lncSPA1","lncSPA2"),4),cancer = rep(cancer_fetal$cancer,each = 2))
for(i in 1:nrow(cancer_fetal_data)){cancer_fetal_data$number[i] = cancer_fetal[cancer_fetal$cancer == cancer_fetal_data$cancer[i],cancer_fetal_data$database[i]]}
cancer_fetal$all = cancer_fetal$lncSPA2 + cancer_fetal$lncSPA1
cancer_fetal = cancer_fetal[order(cancer_fetal$all,decreasing = T),]
cancer_fetal_data$cancer = factor(cancer_fetal_data$cancer,levels = cancer_fetal$cancer)


##堆积柱状图-----
ggplot(cancer_fetal_data,aes(cancer,number,fill = database))+##reorder()表示x轴重新排序-
  geom_bar(stat="identity",position="stack")+
  theme(axis.text.x = element_text(angle = 80,hjust = 1))+
  ylab("Dataset Number") + 
  scale_fill_manual(values = c("dodgerblue4","firebrick4"))


#normal_adult
normal_adult2 = read.table("E:/lcw/lncSPA/统计/12.21/normal_adult_data.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
normal_adult1 = data.frame(Var1 = c("adipose.tissue","adrenal.gland","appendix","bladder","blood","blood.vessel","bone.marrow","brain",
                                    "breast","cervix","colon","duodenum","endometrium","esophagus","gall.bladder","fallopian.tube","heart",
                                    "kidney","leukocyte","liver","lung","lymph.node","muscle","nerve","ovary","pancreas","pituitary","placenta",
                                    "prostate","salivary.gland","skin","small.intestine","spleen","stomach","testis","thyroid","uterus","vagina"),
                           Freq = c(4,4,2,3,2,2,2,4,3,2,4,2,1,3,3,1,4,4,1,4,4,3,3,1,4,3,2,2,4,3,3,3,3,3,4,4,2,2))
normal_adult = merge(normal_adult2,normal_adult1,by = "Var1",all = T)
colnames(normal_adult) = c("tissue","lncSPA2","lncSPA1")
normal_adult[is.na(normal_adult)] = 0

normal_adult_data = data.frame(database = rep(c("lncSPA1","lncSPA2"),57),tissue = rep(normal_adult$tissue,each = 2))
for(i in 1:nrow(normal_adult_data)){normal_adult_data$number[i] = normal_adult[normal_adult$tissue == normal_adult_data$tissue[i],normal_adult_data$database[i]]}
normal_adult$all = normal_adult$lncSPA2 + normal_adult$lncSPA1
normal_adult = normal_adult[order(normal_adult$all,decreasing = T),]
normal_adult_data$tissue = factor(normal_adult_data$tissue,levels = normal_adult$tissue)

##堆积柱状图-----
ggplot(normal_adult_data,aes(tissue,number,fill = database))+##reorder()表示x轴重新排序-
  geom_bar(stat="identity",position="stack")+
  theme(axis.text.x = element_text(angle = 80,hjust = 1))+
  ylab("Dataset Number") + 
  ylim(0,10)+
  scale_fill_manual(values = c("dodgerblue4","firebrick4"))

#normal_fetal
normal_fetal = read.table("E:/lcw/lncSPA/统计/12.21/normal_fetal_data.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
normal_fetal$database = "lncSPA2"
colnames(normal_fetal)[1:2] = c("tissue","number")
normal_fetal = normal_fetal[order(normal_fetal$number,decreasing = T),]
normal_fetal$tissue = factor(normal_fetal$tissue,levels = normal_fetal$tissue)
##堆积柱状图-----
ggplot(normal_fetal,aes(tissue,number,fill = database))+##reorder()表示x轴重新排序-
  geom_bar(stat="identity",position="stack")+
  theme(axis.text.x = element_text(angle = 80,hjust = 1))+
  ylab("Dataset Number") + 
  scale_fill_manual(values = c("firebrick4"))










##柱状图----
library(ggplot2)
normal_adult = read.table("E:\\lcw\\lncSPA\\统计\\12.21\\normal_adult_data.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
ggplot(data=normal_adult, aes(x=reorder(Var1,-Freq),y=Freq)) + 
  geom_bar(stat="identity", fill = "#009ACD",width=0.8) + 
  theme_bw() + 
  xlab("Tissue") + 
  ylab("Dataset Number") + 
  labs(title = "Dataset Number Statistics")+ 
  theme(axis.text.x=element_text(face = "bold", color="gray50",angle = 80,vjust = 1, hjust = 1 ))#angle是坐标轴字体倾斜的角度，可以自己设置



cancer_adult = read.table("E:\\lcw\\lncSPA\\统计\\12.21\\cancer_adult_data.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
ggplot(data=cancer_adult, aes(x=reorder(Var1,-Freq),y=Freq)) + 
  geom_bar(stat="identity", fill = "#009ACD",width=0.8) + 
  geom_text(aes(label=VAL),size=4,vjust=-0.5)+
  theme_bw() + 
  xlab("cancer") + 
  ylab("Dataset Number") + 
  labs(title = "Dataset Number Statistics")+ 
  theme(axis.text.x=element_text(face = "bold", color="gray50",angle = 80,vjust = 1, hjust = 1 ))#angle是坐标轴字体倾斜的角度，可以自己设置

##堆积柱状图-----
ggplot(cancer_adult_data,aes(cancer,number,fill = database))+##reorder()表示x轴重新排序-
  geom_bar(stat="identity",position="stack")+
  theme(axis.text.x = element_text(angle = 80,hjust = 1))+
  ylab("Dataset Number") + 
  scale_fill_manual(values = c("dodgerblue4","firebrick4"))#+
  #geom_text(aes(label=number),size=4,vjust=-0.5)
                    
                    



##12.22mRNA信息表格整理----
library(stringr)
library(dplyr)
#normal
hcl = read.table("E:\\lcw\\lncSPA\\mRNA\\HCL_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
hcl_fetal = read.table("E:\\lcw\\lncSPA\\mRNA\\HCL_fetal_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
hcl = rbind(hcl,hcl_fetal)
rm(hcl_fetal)
hcl = hcl[,c("gene","seqnames","start","end","strand","ensembl_gene_id")]

tts = read.table("E:\\lcw\\lncSPA\\mRNA\\The_Tabula_Sapiens_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tts = tts[,c("gene","seqnames","start","end","strand","ensembl_gene_id")]

tica = read.table("E:\\lcw\\lncSPA\\mRNA\\TICA_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica = tica[,c("gene","seqnames","start","end","strand","ensembl_gene_id")]

hcl$source = "hcl"
tts$source = "tts"
tica$source = "tica"

tts  = tts %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,.keep_all = T)

hcl  = hcl %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,.keep_all = T)

tica  = tica %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,.keep_all = T)

normal = rbind(tts,hcl,tica)

write.table(normal,"E:/lcw/lncSPA/统计/12.21/normal.txt",sep="\t",quote=F,row.names=F)

#cancer
tisch = read.table("E:\\lcw\\lncSPA\\mRNA\\TISCH_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tisch = tisch[,c("gene","seqnames","start","end","strand","ensembl_gene_id","cancer_type","Dataset")]
tisch$source = str_c("geo",tisch$Dataset,sep = "=")
tisch = tisch[,c(1:6,9)]
tisch  = tisch %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,source,.keep_all = T)


cell_res = read.table("E:\\lcw\\lncSPA\\mRNA\\cell_research_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = cell_res[,c("gene","seqnames","start","end","strand","ensembl_gene_id")]
cell_res$source = "cell_res"
cell_res  = cell_res %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,.keep_all = T)


other = read.table("E:\\lcw\\lncSPA\\mRNA\\GSE140819_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = other[,c("gene","seqnames","start","end","strand","ensembl_gene_id")]
other$source = "other=GSE140819"
other  = other %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,.keep_all = T)


tiger = read.table("E:\\lcw\\lncSPA\\mRNA\\TIGER_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = tiger[,c("gene","seqnames","start","end","strand","ensembl_gene_id","cancer_type")]
for(i in 1:nrow(tiger)){tiger$source[i] = str_split(tiger$cancer_type[i],"_")[[1]][2]}
tiger$cancer_type = str_c("tiger",tiger$source,sep = "=")
tiger = tiger[,1:7]
colnames(tiger)[7] = "source"
tiger  = tiger %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,source,.keep_all = T)


epn = read.table("E:\\lcw\\lncSPA\\mRNA\\GSE125969_mRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = epn[,c("gene","seqnames","start","end","strand","ensembl_gene_id")]
epn$source = "epn=GSE125969"
epn  = epn %>% distinct(gene,seqnames,start,end,strand,ensembl_gene_id,.keep_all = T)

cancer = rbind(tisch,cell_res,other,tiger,epn)
write.table(cancer,"E:/lcw/lncSPA/统计/12.21/cancer.txt",sep="\t",quote=F,row.names=F)


###2023.1.11lncRNA总表整理----
rm(list = ls())
gc()
library(stringr)

##tisch
tisch = read.table("E:/lcw/lncSPA/lncRNA/TISCH_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

tisch$cell_type[tisch$cell_type == "CD4+ T cell"] = "CD4 T cell"
tisch$cell_type[tisch$cell_type == "CD8+ T cell"] = "CD8 T cell"
tisch$cell_type[tisch$cell_type == "cancer"] = "Cancer cell"
tisch$cell_type[tisch$cell_type == "Cancer"] = "Cancer cell"
tisch$cell_type[tisch$cell_type == "DC"] = "Dendritic cell"
tisch$cell_type[tisch$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
tisch$cell_type[tisch$cell_type == "Smooth muscle cell"] = "Muscle cell"

tisch$cell_type[tisch$cell_type == "Classic dendritic cell"] = "Dendritic cell"
tisch$cell_type[tisch$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
tisch$cell_type[tisch$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"




cancer = as.data.frame(table(tisch$cancer_type))
temp = as.character(cancer$Var1)

cancer$name = c("AEL","ALL","AML","BCC","BLCA","BRCA","CHOL","CLL","COAD","CRC", "GBM","GLI","HNSCC",
                "KIRC","LICA","LIHC","MCC","MEL","MM","NET","NHL","NSCLC","OV","PAAD","SCC","SKCM","UVM")

for(i in 1:nrow(cancer)){tisch$cancer_type[tisch$cancer_type == as.character(cancer$Var1[i])] = cancer$name[i]}

cname = str_c("tisch",cancer$name,sep = "_")

tisch_data = list(gene = unique(tisch$gene))
for(i in 1:length(cname)){tisch_data[cname[i]] = NA}
tisch_data = data.frame(tisch_data)
rownames(tisch_data) = tisch_data$gene

for(i in 1:nrow(tisch)){
  temp_data = tisch[i,]
  if(is.na(tisch_data[temp_data$gene[1],str_c("tisch_",temp_data$cancer_type[1],sep = "")])){
    tisch_data[temp_data$gene[1],str_c("tisch_",temp_data$cancer_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(tisch_data[temp_data$gene[1],str_c("tisch_",temp_data$cancer_type[1],sep = "")]) == F){
    tisch_data[temp_data$gene[1],str_c("tisch_",temp_data$cancer_type[1],sep = "")] = str_c(tisch_data[temp_data$gene[1],str_c("tisch_",temp_data$cancer_type[1],sep = "")],
                                                                                            str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}

##tiger
tiger = read.table("E:/lcw/lncSPA/lncRNA/TIGER_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

tiger$cell_type[tiger$cell_type == "CD4+ T cell"] = "CD4 T cell"
tiger$cell_type[tiger$cell_type == "CD8+ T cell"] = "CD8 T cell"
tiger$cell_type[tiger$cell_type == "cancer"] = "Cancer cell"
tiger$cell_type[tiger$cell_type == "Cancer"] = "Cancer cell"
tiger$cell_type[tiger$cell_type == "DC"] = "Dendritic cell"
tiger$cell_type[tiger$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
tiger$cell_type[tiger$cell_type == "Smooth muscle cell"] = "Muscle cell"

tiger$cell_type[tiger$cell_type == "Classic dendritic cell"] = "Dendritic cell"
tiger$cell_type[tiger$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
tiger$cell_type[tiger$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

tiger_data = data.frame(gene = unique(tiger$gene),tiger_CRC = NA,tiger_NSCLC = NA)
rownames(tiger_data) = tiger_data$gene

for(i in 1:nrow(tiger)){
  temp_data = tiger[i,]
  if(is.na(tiger_data[temp_data$gene[1],str_c("tiger_",temp_data$cancer_type[1],sep = "")])){
    tiger_data[temp_data$gene[1],str_c("tiger_",temp_data$cancer_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(tiger_data[temp_data$gene[1],str_c("tiger_",temp_data$cancer_type[1],sep = "")]) == F){
    tiger_data[temp_data$gene[1],str_c("tiger_",temp_data$cancer_type[1],sep = "")] = str_c(tiger_data[temp_data$gene[1],str_c("tiger_",temp_data$cancer_type[1],sep = "")],
                                                                                            str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}




##tica
tica = read.table("E:/lcw/lncSPA/lncRNA/TICA_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

tica$cell_type[tica$cell_type == "CD4+ T cell"] = "CD4 T cell"
tica$cell_type[tica$cell_type == "CD8+ T cell"] = "CD8 T cell"
tica$cell_type[tica$cell_type == "cancer"] = "Cancer cell"
tica$cell_type[tica$cell_type == "Cancer"] = "Cancer cell"
tica$cell_type[tica$cell_type == "DC"] = "Dendritic cell"
tica$cell_type[tica$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
tica$cell_type[tica$cell_type == "Smooth muscle cell"] = "Muscle cell"

tica$cell_type[tica$cell_type == "Classic dendritic cell"] = "Dendritic cell"
tica$cell_type[tica$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
tica$cell_type[tica$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(tica$tissue_type))
temp = as.character(cancer$Var1)
temp

cancer$name = c("Blood","Bone marrow","Caecum","Duodenum","jejunum_epithelial","jejunum_lamina_propria","Liver","lleum","Lung-draining lymph nodes","Lungs",
                "Mesenteric lymph nodes","Omentum","Sigmoid colon","Skeletal muscle","Spleen","Thymus","Transverse colon")

cname = str_c("tica",as.character(cancer$Var1),sep = "_")

tica_data = list(gene = unique(tica$gene))
for(i in 1:length(cname)){tica_data[cname[i]] = NA}
tica_data = data.frame(tica_data,check.names = F)
rownames(tica_data) = tica_data$gene

for(i in 1:nrow(tica)){
  temp_data = tica[i,]
  if(is.na(tica_data[temp_data$gene[1],str_c("tica_",temp_data$tissue_type[1],sep = "")])){
    tica_data[temp_data$gene[1],str_c("tica_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(tica_data[temp_data$gene[1],str_c("tica_",temp_data$tissue_type[1],sep = "")]) == F){
    tica_data[temp_data$gene[1],str_c("tica_",temp_data$tissue_type[1],sep = "")] = str_c(tica_data[temp_data$gene[1],str_c("tica_",temp_data$tissue_type[1],sep = "")],
                                                                                            str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}

##tts
tts = read.table("E:/lcw/lncSPA/lncRNA/The_Tabula_Sapiens_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tts)[2] = "cell_type"

tts$cell_type[tts$cell_type == "CD4+ T cell"] = "CD4 T cell"
tts$cell_type[tts$cell_type == "CD8+ T cell"] = "CD8 T cell"
tts$cell_type[tts$cell_type == "cancer"] = "Cancer cell"
tts$cell_type[tts$cell_type == "Cancer"] = "Cancer cell"
tts$cell_type[tts$cell_type == "DC"] = "Dendritic cell"
tts$cell_type[tts$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
tts$cell_type[tts$cell_type == "Smooth muscle cell"] = "Muscle cell"

tts$cell_type[tts$cell_type == "Classic dendritic cell"] = "Dendritic cell"
tts$cell_type[tts$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
tts$cell_type[tts$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(tts$tissue_type))
temp = as.character(cancer$Var1)
temp

cname = str_c("tts",as.character(cancer$Var1),sep = "_")

tts_data = list(gene = unique(tts$gene))
for(i in 1:length(cname)){tts_data[cname[i]] = NA}
tts_data = data.frame(tts_data,check.names = F)
rownames(tts_data) = tts_data$gene

for(i in 1:nrow(tts)){
  temp_data = tts[i,]
  if(is.na(tts_data[temp_data$gene[1],str_c("tts_",temp_data$tissue_type[1],sep = "")])){
    tts_data[temp_data$gene[1],str_c("tts_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(tts_data[temp_data$gene[1],str_c("tts_",temp_data$tissue_type[1],sep = "")]) == F){
    tts_data[temp_data$gene[1],str_c("tts_",temp_data$tissue_type[1],sep = "")] = str_c(tts_data[temp_data$gene[1],str_c("tts_",temp_data$tissue_type[1],sep = "")],
                                                                                          str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}

##cell_res
cell_res = read.table("E:/lcw/lncSPA/lncRNA/cell_research_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(cell_res)[2] = "cell_type"

cell_res$cell_type[cell_res$cell_type == "CD4+ T cell"] = "CD4 T cell"
cell_res$cell_type[cell_res$cell_type == "CD8+ T cell"] = "CD8 T cell"
cell_res$cell_type[cell_res$cell_type == "cancer"] = "Cancer cell"
cell_res$cell_type[cell_res$cell_type == "Cancer"] = "Cancer cell"
cell_res$cell_type[cell_res$cell_type == "DC"] = "Dendritic cell"
cell_res$cell_type[cell_res$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
cell_res$cell_type[cell_res$cell_type == "Smooth muscle cell"] = "Muscle cell"

cell_res$cell_type[cell_res$cell_type == "Classic dendritic cell"] = "Dendritic cell"
cell_res$cell_type[cell_res$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
cell_res$cell_type[cell_res$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(cell_res$tissue_type))
temp = as.character(cancer$Var1)
temp

cname = str_c("cell_res",as.character(cancer$Var1),sep = "_")

cell_res_data = list(gene = unique(cell_res$gene))
for(i in 1:length(cname)){cell_res_data[cname[i]] = NA}
cell_res_data = data.frame(cell_res_data,check.names = F)
rownames(cell_res_data) = cell_res_data$gene

for(i in 1:nrow(cell_res)){
  temp_data = cell_res[i,]
  if(is.na(cell_res_data[temp_data$gene[1],str_c("cell_res_",temp_data$tissue_type[1],sep = "")])){
    cell_res_data[temp_data$gene[1],str_c("cell_res_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(cell_res_data[temp_data$gene[1],str_c("cell_res_",temp_data$tissue_type[1],sep = "")]) == F){
    cell_res_data[temp_data$gene[1],str_c("cell_res_",temp_data$tissue_type[1],sep = "")] = str_c(cell_res_data[temp_data$gene[1],str_c("cell_res_",temp_data$tissue_type[1],sep = "")],
                                                                                        str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}



##hcl
hcl = read.table("E:/lcw/lncSPA/lncRNA/HCL_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl)[2] = "cell_type"

hcl$cell_type[hcl$cell_type == "CD4+ T cell"] = "CD4 T cell"
hcl$cell_type[hcl$cell_type == "CD8+ T cell"] = "CD8 T cell"
hcl$cell_type[hcl$cell_type == "cancer"] = "Cancer cell"
hcl$cell_type[hcl$cell_type == "Cancer"] = "Cancer cell"
hcl$cell_type[hcl$cell_type == "DC"] = "Dendritic cell"
hcl$cell_type[hcl$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
hcl$cell_type[hcl$cell_type == "Smooth muscle cell"] = "Muscle cell"

hcl$cell_type[hcl$cell_type == "Classic dendritic cell"] = "Dendritic cell"
hcl$cell_type[hcl$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
hcl$cell_type[hcl$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(hcl$tissue_type))
temp = as.character(cancer$Var1)
temp

cname = str_c("hcl",as.character(cancer$Var1),sep = "_")

hcl_data = list(gene = unique(hcl$gene))
for(i in 1:length(cname)){hcl_data[cname[i]] = NA}
hcl_data = data.frame(hcl_data,check.names = F)
rownames(hcl_data) = hcl_data$gene

for(i in 1:nrow(hcl)){
  temp_data = hcl[i,]
  if(is.na(hcl_data[temp_data$gene[1],str_c("hcl_",temp_data$tissue_type[1],sep = "")])){
    hcl_data[temp_data$gene[1],str_c("hcl_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(hcl_data[temp_data$gene[1],str_c("hcl_",temp_data$tissue_type[1],sep = "")]) == F){
    hcl_data[temp_data$gene[1],str_c("hcl_",temp_data$tissue_type[1],sep = "")] = str_c(hcl_data[temp_data$gene[1],str_c("hcl_",temp_data$tissue_type[1],sep = "")],
                                                                                                  str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}

##hcl_fetal

hcl_fetal = read.table("E:/lcw/lncSPA/lncRNA/HCL_fetal_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_fetal)[2] = "cell_type"

hcl_fetal$cell_type[hcl_fetal$cell_type == "CD4+ T cell"] = "CD4 T cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "CD8+ T cell"] = "CD8 T cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "cancer"] = "Cancer cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "Cancer"] = "Cancer cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "DC"] = "Dendritic cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "Smooth muscle cell"] = "Muscle cell"

hcl_fetal$cell_type[hcl_fetal$cell_type == "Classic dendritic cell"] = "Dendritic cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
hcl_fetal$cell_type[hcl_fetal$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(hcl_fetal$tissue_type))
temp = as.character(cancer$Var1)
temp

cname = str_c("hcl_fetal",as.character(cancer$Var1),sep = "_")

hcl_fetal_data = list(gene = unique(hcl_fetal$gene))
for(i in 1:length(cname)){hcl_fetal_data[cname[i]] = NA}
hcl_fetal_data = data.frame(hcl_fetal_data,check.names = F)
rownames(hcl_fetal_data) = hcl_fetal_data$gene

for(i in 1:nrow(hcl_fetal)){
  temp_data = hcl_fetal[i,]
  if(is.na(hcl_fetal_data[temp_data$gene[1],str_c("hcl_fetal_",temp_data$tissue_type[1],sep = "")])){
    hcl_fetal_data[temp_data$gene[1],str_c("hcl_fetal_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(hcl_fetal_data[temp_data$gene[1],str_c("hcl_fetal_",temp_data$tissue_type[1],sep = "")]) == F){
    hcl_fetal_data[temp_data$gene[1],str_c("hcl_fetal_",temp_data$tissue_type[1],sep = "")] = str_c(hcl_fetal_data[temp_data$gene[1],str_c("hcl_fetal_",temp_data$tissue_type[1],sep = "")],
                                                                                        str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}


##epn
epn = read.table("E:/lcw/lncSPA/lncRNA/GSE125969_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(epn)[2] = "cell_type"

epn$cell_type[epn$cell_type == "CD4+ T cell"] = "CD4 T cell"
epn$cell_type[epn$cell_type == "CD8+ T cell"] = "CD8 T cell"
epn$cell_type[epn$cell_type == "cancer"] = "Cancer cell"
epn$cell_type[epn$cell_type == "Cancer"] = "Cancer cell"
epn$cell_type[epn$cell_type == "DC"] = "Dendritic cell"
epn$cell_type[epn$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
epn$cell_type[epn$cell_type == "Smooth muscle cell"] = "Muscle cell"

epn$cell_type[epn$cell_type == "Classic dendritic cell"] = "Dendritic cell"
epn$cell_type[epn$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
epn$cell_type[epn$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(epn$tissue_type))
temp = as.character(cancer$Var1)
temp

cname = str_c("epn",as.character(cancer$Var1),sep = "_")

epn_data = list(gene = unique(epn$gene))
for(i in 1:length(cname)){epn_data[cname[i]] = NA}
epn_data = data.frame(epn_data,check.names = F)
rownames(epn_data) = epn_data$gene

for(i in 1:nrow(epn)){
  temp_data = epn[i,]
  if(is.na(epn_data[temp_data$gene[1],str_c("epn_",temp_data$tissue_type[1],sep = "")])){
    epn_data[temp_data$gene[1],str_c("epn_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(epn_data[temp_data$gene[1],str_c("epn_",temp_data$tissue_type[1],sep = "")]) == F){
    epn_data[temp_data$gene[1],str_c("epn_",temp_data$tissue_type[1],sep = "")] = str_c(epn_data[temp_data$gene[1],str_c("epn_",temp_data$tissue_type[1],sep = "")],
                                                                                                    str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}

##other
other = read.table("E:/lcw/lncSPA/lncRNA/GSE140819_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(other)[2] = "cell_type"

other$cell_type[other$cell_type == "CD4+ T cell"] = "CD4 T cell"
other$cell_type[other$cell_type == "CD8+ T cell"] = "CD8 T cell"
other$cell_type[other$cell_type == "cancer"] = "Cancer cell"
other$cell_type[other$cell_type == "Cancer"] = "Cancer cell"
other$cell_type[other$cell_type == "DC"] = "Dendritic cell"
other$cell_type[other$cell_type == "Bronchial smooth muscle cell"] = "Muscle cell"
other$cell_type[other$cell_type == "Smooth muscle cell"] = "Muscle cell"

other$cell_type[other$cell_type == "Classic dendritic cell"] = "Dendritic cell"
other$cell_type[other$cell_type == "Conventional dendritic cell"] = "Dendritic cell"
other$cell_type[other$cell_type == "Myeloid dendritic cell"] = "Dendritic cell"

cancer = as.data.frame(table(other$tissue_type))
temp = as.character(cancer$Var1)
temp

cancer$name = c("CLL","CLL","GBM","MEL","MBC","MBC","MBC","MBC","NSCLC","OV","OV","Pediatric_HGG","Pediatric_NBM","Pediatric_SARC","Pediatric_RMS")

for(i in 1:nrow(cancer)){other$tissue_type[other$tissue_type == as.character(cancer$Var1[i])] = cancer$name[i]}

cancer = as.data.frame(table(other$tissue_type))
temp = as.character(cancer$Var1)
temp

cname = str_c("other",as.character(cancer$Var1),sep = "_")

other_data = list(gene = unique(other$gene))
for(i in 1:length(cname)){other_data[cname[i]] = NA}
other_data = data.frame(other_data,check.names = F)
rownames(other_data) = other_data$gene

for(i in 1:nrow(other)){
  temp_data = other[i,]
  if(is.na(other_data[temp_data$gene[1],str_c("other_",temp_data$tissue_type[1],sep = "")])){
    other_data[temp_data$gene[1],str_c("other_",temp_data$tissue_type[1],sep = "")] = str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";")
  }else if(is.na(other_data[temp_data$gene[1],str_c("other_",temp_data$tissue_type[1],sep = "")]) == F){
    other_data[temp_data$gene[1],str_c("other_",temp_data$tissue_type[1],sep = "")] = str_c(other_data[temp_data$gene[1],str_c("other_",temp_data$tissue_type[1],sep = "")],
                                                                                        str_c(temp_data$class[1],temp_data$cell_type[1],sep = ";"),sep = "_")
  }
}


all = merge(tisch_data,tiger_data,by = "gene",all = T)

all = merge(all,cell_res_data,by = "gene",all = T)

all = merge(all,epn_data,by = "gene",all = T)

all = merge(all,hcl_data,by = "gene",all = T)

all = merge(all,hcl_fetal_data,by = "gene",all = T)

all = merge(all,other_data,by = "gene",all = T)

all = merge(all,tica_data,by = "gene",all = T)

all = merge(all,tts_data,by = "gene",all = T)

all$number = apply(all,1,function(x){return(sum(is.na(x) == F)-1)})

all = all[order(all$number,decreasing = T),]


write.table(all,"E:/lcw/lncSPA/all_table.txt",sep="\t",quote=F,row.names=F,col.names = T)



all = read.table("E:/lcw/lncSPA/all_table.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)




aa = as.data.frame(colnames(all))
aa$name = str_c(aa$`colnames(all)`,c("_",rep("_cancer",33),"_",rep("_normal",41),rep("_",20),rep("_cancer",6),rep("_",4),rep("_normal",41),"_"))
colnames(all) = aa$name

all_data = all

all_data$number_ = all_data$number_-1

all_data$normal = 0
all_data$cancer = 0
all_data$fetal = 0
all_data$Pediatric = 0


all_data$normal = apply(all_data,1,function(x){return(sum(is.na(x[str_detect(names(x),"normal")]) == F)-1)})
all_data$cancer = apply(all_data,1,function(x){return(sum(is.na(x[str_detect(names(x),"cancer")]) == F)-1)})
all_data$fetal = apply(all_data,1,function(x){return(sum(is.na(x[str_detect(names(x),"fetal")]) == F)-1)})
all_data$Pediatric = apply(all_data,1,function(x){return(sum(is.na(x[str_detect(names(x),"Pediatric")]) == F)-1)})

colnames(all_data) = c(as.character(aa$`colnames(all)`),"normal_adult","cancer_adult","normal_fetal","cancer_fetal")


write.table(all_data,"E:/lcw/lncSPA/all_table_2.txt",sep="\t",quote=F,row.names=F,col.names = T)

###cell_type-specific_lncRNAs(marker_res)----
library(stringr)
library(dplyr)
library(openxlsx)
tisch = read.table("E:/lcw/lncSPA/lncRNA/TISCH_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tisch$From = str_c(tisch$cancer_type,tisch$Dataset,sep = "_")
tisch$A_F = "Adult"
tisch$T_C = tisch$cancer_type
tisch$N_C = "cancer"

tiger = read.table("E:/lcw/lncSPA/lncRNA/TIGER_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger$From = str_c(tiger$cancer_type,tiger$Dataset,sep = "_")
tiger$A_F = "Adult"
tiger$T_C = tiger$cancer_type
tiger$N_C = "cancer"


tica = read.table("E:/lcw/lncSPA/lncRNA/TICA_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica$From = "TICA"
tica$A_F = "Adult"
tica$T_C = tica$tissue_type
tica$N_C = "normal"

tts = read.table("E:/lcw/lncSPA/lncRNA/The_Tabula_Sapiens_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tts)[2] = "cell_type"
tts$From = "TTS"
tts$A_F = "Adult"
tts$T_C = tts$tissue_type
tts$N_C = "normal"

cell_res = read.table("E:/lcw/lncSPA/lncRNA/cell_research_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(cell_res)[2] = "cell_type"
cell_res$From = "cell_res"
cell_res$A_F = "Adult"
cell_res$T_C = cell_res$tissue_type
cell_res$N_C = "cancer"


hcl = read.table("E:/lcw/lncSPA/lncRNA/HCL_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl)[2] = "cell_type"
hcl$From = "HCL"
hcl$A_F = "Adult"
hcl$T_C = hcl$tissue_type
hcl$N_C = "normal"


hcl_fetal = read.table("E:/lcw/lncSPA/lncRNA/HCL_fetal_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_fetal)[2] = "cell_type"
hcl_fetal$From = "HCL"
hcl_fetal$A_F = "Fetal"
hcl_fetal$T_C = hcl_fetal$tissue_type
hcl_fetal$N_C = "normal"

epn = read.table("E:/lcw/lncSPA/lncRNA/GSE125969_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(epn)[2] = "cell_type"
epn$From = "EPN"
epn$A_F = "Fetal"#"Adult"#
epn$T_C = epn$tissue_type
epn$N_C = "cancer"



other = read.table("E:/lcw/lncSPA/lncRNA/GSE140819_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(other)[2] = "cell_type"
other$From = "GSE140819"
other$A_F = ifelse(str_detect(other$tissue_type,"Adult"),"Adult","Fetal")
other$T_C = other$tissue_type
other$N_C = "cancer"


total_data = rbind(cell_res[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   epn[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   other[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   hcl_fetal[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   hcl[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   tts[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   tica[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   tiger[,c("gene","cell_type","From","T_C","A_F","N_C")],
                   tisch[,c("gene","cell_type","From","T_C","A_F","N_C")])


all_cell_type = read.xlsx("E:/lcw/lncSPA/数据统一/all_cell_type(fixed).xlsx",colNames = F)


for(i in 1:nrow(all_cell_type)){
  total_data$cell_type[total_data$cell_type == all_cell_type$X1[i]] = all_cell_type$X3[i]
}


lnc2_table = read.csv("E:/lcw/lncSPA/文章图/lnc2_tissue_table.csv")

for(i in 1:nrow(lnc2_table)){
  total_data$T_C[total_data$T_C == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}



aa = as.data.frame(table(total_data$gene))

marker_res = data.frame()



for(i in 1:nrow(aa)){
  temp_gene = total_data[total_data$gene == as.character(aa$Var1[i]),]
  
  if(nrow(temp_gene) > 5){
    temp = as.data.frame(table(temp_gene$cell_type))
    
    for(j in 1:nrow(temp)){
      temp_celltype = temp_gene[temp_gene$cell_type == as.character(temp$Var1[j]),]
      
      chose_table = temp_celltype
      
      if(nrow(chose_table) > 14){
        res_temp = total_data[((total_data$gene == as.character(aa$Var1[i])) & (total_data$cell_type == as.character(temp$Var1[j]))),]
        
        marker_res = rbind(marker_res,res_temp)
        
      }
    }
    
  }
  
}

write.csv(marker_res,"E:/lcw/lncSPA/图标/marker_res15_.csv",row.names = F)




# c1 = total_data[total_data$cell_type == "Adipocyte",]
# 
# c1 = total_data[total_data$cell_type == "Neutrophil",]
# 
# c1 = total_data[total_data$cell_type == "NK cell",]
# 
# c1 = total_data[total_data$cell_type == "Cancer cell",]
# 
# c1 = total_data[total_data$cell_type == "T cell",]
# 
# c1 = total_data[total_data$cell_type == "Mast cell",]
# 
# c1 = total_data[total_data$cell_type == "Myeloid",]
# 
# c1 = total_data[total_data$cell_type == "DC",]
# 
# 
# 
# c1 = total_data[total_data$cell_type == "Endothelial cell",]
# c1 = total_data[total_data$cell_type == "Stromal cell",]
# c1 = total_data[total_data$cell_type == "Stellate cell",]
# c1 = rbind(total_data[total_data$cell_type == "Neuron cell",],total_data[total_data$cell_type == "Neuron",])
# c1 = total_data[total_data$cell_type == "Macrophage",]
# 
# c1 = total_data[total_data$cell_type == "Fibroblast",]
# c1 = total_data[total_data$cell_type == "Lymphocyte",]
# c1 = total_data[total_data$cell_type == "Leucocyte",]
# 
# #c1 = total_data[total_data$cell_type == "Eosinophilic granulocyte",]
# c1 = total_data[total_data$cell_type == "Ciliated cell",]
# c1 = rbind(total_data[total_data$cell_type == "Alveolar cell",],total_data[total_data$cell_type == "Alveolar",])
# c1 = total_data[total_data$cell_type == "Smooth muscle cell",]











#23 修改相关性计算方法-----------------
##
##
##
##
#5cor
#相关，首先需要每一个细胞类型的表达谱
#HCL细胞表达谱
#exp_anno <- read.table("D:kang/lncSpA2/process/1_data.process/HCL/HCL_exp_fetal_anno_file_names.txt",sep="\t",header=T,stringsAsFactors=F)
#exp_anno[,1] <- gsub("[0-9]$","",exp_anno[,1])
#tissue_num <- data.frame(table(exp_anno[,1]))
# rm(list = ls())
# gc()
# library(stringr)
# exp_anno = list.files("/bioXJ/lcw/TIGER/exp/")
# exp_anno = str_sub(exp_anno,1,-5)
# 
# library(Seurat)
# library(dplyr)
# input_file <- "/bioXJ/lcw/TIGER/RDS/"
# output <- "/bioXJ/lcw/TIGER/each/"
# 
# for (i in 1:length(exp_anno)) {
#   tissue_seurat <- readRDS(paste(input_file,exp_anno[i],"/",exp_anno[i],".rds",sep=""))
#   tissue_seurat <- NormalizeData(object = tissue_seurat, normalization.method = "LogNormalize", scale.factor = 10000)
#   tissue_exp <- tissue_seurat[["RNA"]]@data
#   anno_value <- read.table(paste("/bioXJ/lcw/TIGER/cellid_type/",exp_anno[i],".txt",sep = ""),header=T,sep="\t",stringsAsFactors=F)
#   rownames(anno_value) = anno_value$cell_ID
#   #rownames(anno_value) = str_c("X",rownames(anno_value),sep = "")
#   
#   cell_num <- data.frame(table(anno_value$cell_type))
#   cell_num <- cell_num[which(cell_num[,1] != "Unknown"),]
#   #cell_num[,1] <- gsub("\\/"," or ",cell_num[,1])
#   for (k in 1:nrow(cell_num)) {
#     cell_file <- anno_value[which(anno_value$cell_type == as.character(cell_num[k,1])),]
#     cell_exp <- tissue_exp[,which(colnames(tissue_exp) %in% rownames(cell_file))]
#     write.table(cell_exp,file=paste(output,exp_anno[i],".",gsub("\\/"," or ",as.character(cell_num[k,1])),".cell_num.cells.txt",sep=""),sep="\t",quote=F,row.names=T)
#     gc()
#   }
# }
# 
# 
# 




#这个是计算相关性的代码
#相关性计算
library(stringr)
library(scLink)
library(Hmisc)
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



input <- "E:/lcw/lncSPA/TIGER/res/2basic_information/"
input_exp <- "E:/lcw/lncSPA/TIGER/res/5cor/each/"
output <- "E:/lcw/lncSPA/TIGER/res/5cor/new_cor/"

##获取CE　lncRNA数据
lncRNA_result <- read.table(paste(input,"TIGER_lncRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)

#获取所有　mRNA数据
mRNA_result <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件

mRNA_tissue1 = read.table(paste(input,"TIGER_mRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
#read.table(paste(input,"TIGER_mRNA_information.cell_num_10.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)

listfile = list.files("E:/lcw/lncSPA/TIGER/exp/")#有哪些数据集，分数据集处理
listfile = str_sub(listfile,1,-5)
#tissue <- "Adrenal-Gland"
#tissue <- "Uterus"
for (i in 1:length(listfile)){
  a1 = Sys.time()
  print(a1)
  print(i)
  lncRNA_tissue <- lncRNA_result[which(str_c(lncRNA_result$cancer_type,lncRNA_result$Dataset,sep = "_") == listfile[i]),]#逐个数据集筛选计算
  
  mRNA_tissue <- mRNA_tissue1[which(mRNA_tissue1$cancer_type == listfile[i]),]
  
  cell_inte_name <- unique(lncRNA_tissue$cell_type)#CE lncRNA 细胞类型和所有mRNA细胞类型交集
  cor_normal_result <- c()
  cor_sclink_result <- c()
  cor_saver_result <- c()
  #cell_name <- "Myeloid cell"
  for (cell_name in cell_inte_name) {
    cell_name1 <- gsub("\\/"," or ",cell_name)
    
    cell_exp <- read.table(paste(input_exp,listfile[i],".",cell_name1,".cell_num.cells.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
    gc()
    if(ncol(cell_exp)>4){
      lncRNA_cell_exp <- cell_exp[which(rownames(cell_exp) %in% lncRNA_tissue[which(lncRNA_tissue$cell_type == cell_name),1]),]
      mRNA_cell_exp <- cell_exp[which(rownames(cell_exp) %in% mRNA_result$gene_name),]
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
      
      cor_result$cancer_type <- rep(listfile[i],nrow(cor_result))
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
      cor_r2$cancer_type <- rep(listfile[i],nrow(cor_r2))
      #cor_r2$classification <- mRNA_tissue[match(cor_r2[,2],mRNA_tissue[which(mRNA_tissue$cell_type == cell_name),1]),"class"]
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
  colnames(cor_normal_result) <- c("lncRNA_name","mRNA_name","R","p_value","cancer_type","classification","cell")
  write.table(cor_normal_result,file=paste(output,listfile[i],".cell.cor_r_p.txt",sep=""),sep="\t",quote=F,row.names=F)
  colnames(cor_sclink_result) <- c("lncRNA_name","mRNA_name","R","p_value","cancer_type","classification","cell")
  write.table(cor_sclink_result,file=paste(output,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",quote=F,row.names=F)
  a2 = Sys.time()
  print(a2-a1)
  gc()
}



#########################################
input <- "E:/lcw/lncSPA/TIGER/res/5cor/cor_result/"

listfile = list.files("E:/lcw/lncSPA/TIGER/exp/")
listfile = str_sub(listfile,1,-5)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:length(listfile)) {
  sclink_result <- read.table(paste(input,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
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
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"cancer_type"],lncRNA_paste,mRNA_paste1)))
  }
}

colnames(final_res) = c("cancer_type","lncRNA_ID","mRNA_ID")
write.table(final_res,file="E:/lcw/lncSPA/TIGER/res/5cor/lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=T,append=T)





#####细胞重新聚类------
library(Seurat)
library(SingleR)


tissue_seurat = readRDS("E:/lcw/lncSPA/TIGER/tiger/CRC_GSE132257/CRC_GSE132257.rds")


cell_anno = read.table("E:/lcw/lncSPA/tiger_data/used_data/CRC_GSE132257/GSE132257_processed_protocol_and_fresh_frozen_cell_annotation.txt",header = T,sep = "\t")

feature_1 = c()

c1 = total_data[total_data$cell_type == "Stromal cell",]
c1 = c1[order(c1$cell_exp,decreasing = T),]
feature_1 = c(feature_1,c1$gene)


feature_1 = total_data$gene
feature_1 = unique(feature_1)




#4. 找Variable基因
tissue_seurat = FindVariableFeatures(tissue_seurat, selection.method = "vst", nfeatures = 2000)
gc()
#5. scale表达矩阵
tissue_seurat <- ScaleData(tissue_seurat, features = rownames(tissue_seurat))
#6. 降维聚类
#（基于前面得到的high variable基因的scale矩阵）
tissue_seurat <- RunPCA(tissue_seurat, npcs = 50, verbose = FALSE,features = feature_1)

VizDimLoadings(tissue_seurat, dims = 1:2, reduction = "pca")



DimPlot(tissue_seurat, reduction = "pca")



DimHeatmap(tissue_seurat, dims = 1, cells = 500, balanced = TRUE)

#7.定义数据集维度
#NOTE: This process can take a long time for big datasets, comment out for expediency. 
#More approximate techniques such as those implemented in ElbowPlot() can be used to reduce computation time
tissue_seurat <- JackStraw(tissue_seurat, num.replicate = 100)
gc()
tissue_seurat <- ScoreJackStraw(tissue_seurat, dims = 1:20)


JackStrawPlot(tissue_seurat, dims = 1:15)



ElbowPlot(tissue_seurat,ndims = 50)

#8.细胞分类
tissue_seurat <- FindNeighbors(tissue_seurat, dims = 1:10)
gc()
tissue_seurat <- FindClusters(tissue_seurat, resolution = 0.5)#c(0.5,0.6,0.8,1,1.4,2,2.5,4)   

#用已知的细胞类型代替分类的细胞类型
temp = tissue_seurat@meta.data

#tissue_seurat@meta.data$CT <- anno_value[match(rownames(tissue_seurat@meta.data),rownames(anno_value)),"CT"]
Idents(object=tissue_seurat) <- tissue_seurat@meta.data$Celltype..major.lineage.
#9.可视化分类结果
#UMAP
tissue_seurat <- RunUMAP(tissue_seurat, dims = 1:10, label = T)
gc()
#head(tissue_seurat@reductions$umap@cell.embeddings) # 提取UMAP坐标值。
write.table(tissue_seurat@reductions$umap@cell.embeddings,file=paste(listfiles[i],".umap.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
#note that you can set `label = TRUE` or use the LabelClusters function to help label individual clusters
p1 <- DimPlot(tissue_seurat, reduction = "umap")
#T-SNE
tissue_seurat <- RunTSNE(tissue_seurat, dims = 1:10)#报错，改为不检查重复
gc()
#head(tissue_seurat@reductions$tsne@cell.embeddings)
write.table(tissue_seurat@reductions$tsne@cell.embeddings,file=paste(listfiles[i],".tsne.cell.embeddings.txt",sep=""),sep="\t",quote=F,row.names=T)
p2 <- DimPlot(tissue_seurat, reduction = "tsne")
pdf(paste(listfiles[i],".umap.tsne.pdf",sep=""),width = 15, height = 8)
print(p1 + p2)
dev.off()




features = c("IGHGP","IFNG-AS1","MIR4435-2HG","ADAMTS9-AS2","RP11-354E11.2","RP11-768F21.1","RP11-1143G9.4","LINC01094","DIO3OS","FENDRR","RORA-AS1","RP11-347P5.1")

DotPlot(tissue_seurat,features = features )+theme(axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5))


#singleR注释
library(SingleR)
library(scater)
hpca.se <- HumanPrimaryCellAtlasData()

test = tissue_seurat[,1:100]

test = LogNormalize(test)

test.hesc <- SingleR(test = test, ref = hpca.se, labels = hpca.se$label.main)



#####画图----

###河流图(正常癌症分开画)----
library(stringr)
library(dplyr)

######癌症（cell_res,TISCH,TIGER,EPN,other）

all_data = data.frame()

##ann
# other_ann = read.table("E:/lcw/lncSPA/文章图/河流图/GSE140819_tissue_cell_num_com.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F,fileEncoding="UTF16")
# other_ann = other_ann[,c("cell_type","compartment")]
# 
# hcl_fetal_ann = read.table("E:/lcw/lncSPA/文章图/河流图/HCL_fetal_annotation.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
# colnames(hcl_fetal_ann)[5] = "cell_type"
# hcl_fetal_ann = hcl_fetal_ann[,c("cell_type","compartment")]
# 
# 
# hcl_ann = read.table("E:/lcw/lncSPA/文章图/河流图/HCL_tissue_cell_num_com.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
# colnames(hcl_ann)[4] = "cell_type"
# hcl_ann = hcl_ann[,c("cell_type","compartment")]
# 
# 
# tts_ann = read.table("E:/lcw/lncSPA/文章图/河流图/The_Tabula_Sapiens_tissue_cell_num.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
# tts_ann = tts_ann[,c("cell_type","compartment")]
# 
# all_ann = rbind(other_ann,hcl_ann,hcl_fetal_ann,tts_ann)
# all_ann = all_ann %>% distinct(cell_type,compartment,.keep_all = T)

###数据准备(这里开始)
##tisch
tisch = read.table("E:/lcw/lncSPA/lncRNA/TISCH_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tisch = tisch[,c("cell_type","cancer_type")]
tisch$cell_class = 0
tisch$source = "TISCH"

tisch_ann = read.table("E:/lcw/lncSPA/zhenghe/result/1celltree/TISCH_annotation.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tisch_class = tisch_ann %>% distinct(cell,compartment,.keep_all = T)

for(i in 1:nrow(tisch_class)){
  tisch$cell_class[tisch$cell_type == tisch_class$cell[i]] = tisch_class$compartment[i]
}

tisch = tisch[,c("cell_type","cell_class","cancer_type","source")]

all_data = rbind(all_data,tisch)

##tiger
tiger = read.table("E:/lcw/lncSPA/lncRNA/TIGER_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = tiger[,c("cell_type","cancer_type")]
tiger$cell_class = 0
tiger$source = "tiger"


tiger_ann = read.table("E:/lcw/lncSPA/TIGER/res/1celltree/TIGER_annotation.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger_class = tiger_ann %>% distinct(cell,compartment,.keep_all = T)

for(i in 1:nrow(tiger_class)){
  tiger$cell_class[tiger$cell_type == tiger_class$cell[i]] = tiger_class$compartment[i]
}

tiger = tiger[,c("cell_type","cell_class","cancer_type","source")]

all_data = rbind(all_data,tiger)

all_ann = all_data[,c("cell_type","cell_class")] %>% distinct(cell_type,cell_class,.keep_all = T)
##epn
epn = read.table("E:/lcw/lncSPA/lncRNA/GSE125969_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(epn)[2] = "cell_type"
colnames(epn)[3] = "cancer_type"
epn = epn[,c("cell_type","cancer_type")]
epn$cell_class = 0
epn$source = "epn"


epn_ann = read.table("E:/lcw/lncSPA/文章图/河流图/epn_celltree.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)



epn_class = epn_ann %>% distinct(cell_type,.keep_all = T)

epn_class$compartment = c("cancer","immune","immune","stromal")

for(i in 1:nrow(epn_class)){
  epn$cell_class[epn$cell_type == epn_class$cell_type[i]] = epn_class$compartment[i]
}

epn = epn[,c("cell_type","cell_class","cancer_type","source")]

all_data = rbind(all_data,epn)



##other

other = read.table("E:/lcw/lncSPA/lncRNA/GSE140819_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(other)[2] = "cell_type"
colnames(other)[3] = "cancer_type"
other = other[,c("cell_type","cancer_type")]
other$cell_class = 0
other$source = "other"


other_ann = read.table("E:/lcw/lncSPA/文章图/河流图/GSE140819_tissue_cell_num_com.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F,fileEncoding="UTF16")



other_class = other_ann %>% distinct(cell_type,compartment,.keep_all = T)

for(i in 1:nrow(other_class)){
  other$cell_class[other$cell_type == other_class$cell_type[i]] = other_class$compartment[i]
}

other = other[,c("cell_type","cell_class","cancer_type","source")]

all_data = rbind(all_data,other)


##cell_res
cell_res = read.table("E:/lcw/lncSPA/lncRNA/cell_research_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(cell_res)[2] = "cell_type"
colnames(cell_res)[3] = "cancer_type"
cell_res = cell_res[,c("cell_type","cancer_type")]
cell_res$cell_class = 0
cell_res$source = "cell_res"


cell_res_ann = read.table("E:/lcw/lncSPA/文章图/河流图/cell_res_celltree.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)



cell_res_class = cell_res_ann %>% distinct(cell_type,compartment,.keep_all = T)

for(i in 1:nrow(cell_res_class)){
  cell_res$cell_class[cell_res$cell_type == cell_res_class$cell_type[i]] = cell_res_class$compartment[i]
}

cell_res = cell_res[,c("cell_type","cell_class","cancer_type","source")]

all_data = rbind(all_data,cell_res)

cancer_celltype_all = as.data.frame(unique(all_data$cell_type))
cancer_type_all = as.data.frame(unique(all_data$cancer_type))
colnames(cancer_celltype_all) = "cell_type"
colnames(cancer_type_all) = "cancer_type"

library(readxl)
library(stringr)
cancer_name = read_xlsx("E:/lcw/lncSPA/统计/cancer_resource.xlsx")
cancer_name$tissue = apply(cancer_name,1,function(x){
  temp = str_split(x[3],"=")[[1]][1]
  return(temp)
})

all_data$cancer_type[str_detect(all_data$cancer_type,"Adult_")] = str_sub(all_data$cancer_type[str_detect(all_data$cancer_type,"Adult_")],7,-1)

all_data_cancer = all_data

cancer_name = cancer_name[,c("tissue","cancer","system")]
cancer_name = cancer_name %>% distinct(tissue,cancer,system,.keep_all = T)

all_data_cancer$system = 0

for(i in 1:nrow(cancer_name)){
  all_data_cancer$cancer_type[all_data_cancer$cancer_type == cancer_name$tissue[i]] = cancer_name$cancer[i]
}

for(i in 1:nrow(cancer_name)){
  all_data_cancer$system[all_data_cancer$cancer_type == cancer_name$cancer[i]] = cancer_name$system[i]
}

all_cell_type = read_xlsx("E:/lcw/lncSPA/数据统一/all_cell_type(fixed).xlsx",col_names = F)


for(i in 1:nrow(all_cell_type)){
  all_data_cancer$cell_type[all_data_cancer$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}


all_data_cancer = all_data_cancer[str_order(all_data_cancer$cell_class),]
all_data_cancer$cell_type = factor(all_data_cancer$cell_type,levels = unique(all_data_cancer$cell_type))


all_data_cancer = all_data_cancer[str_order(all_data_cancer$system),]
all_data_cancer$cancer_type = factor(all_data_cancer$cancer_type,levels = unique(all_data_cancer$cancer_type))

all_data_cancer$cell_class[all_data_cancer$cell_type == "Alveolar cell"] = "epithelial"
all_data_cancer$cell_class[all_data_cancer$cell_type == "Melanocyte"] = "epithelial"


write.table(all_data_cancer,"E:/lcw/lncSPA/文章图/all_lnc_cancer.txt",sep="\t",quote=F,row.names=F,col.names = T)

View(all_data_cancer%>%distinct(cell_type,cell_class,.keep_all = T))


table(all_data_cancer$system)
table(all_data_cancer$cancer_type[all_data_cancer$system == "Circulatory System"])


##画图
library(ggplot2)
library(ggalluvial)
library(paletteer)
library(ggsci)
library(ggthemes)

df <- to_lodes_form(all_data_cancer[,1:3],
                    axes = 1:3,
                    id = "value")

new_color<-c("#F9C7A3","#FAE073",
             paletteer_c("grDevices::Blues 2", 9),
             paletteer_c("ggthemes::Classic Area Green",17),
             paletteer_d("ggsci::alternating_igv"),
             paletteer_c("ggthemes::Orange Light", 15),
             paletteer_d("ggthemes::excel_Badge"),
             paletteer_c("ggthemes::Red-Green-Gold Diverging",34))

col<- unique(c(pal_npg("nrc")(10),pal_aaas("default")(10),pal_nejm("default")(8),pal_lancet("lanonc")(9),
               pal_jama("default")(7),pal_jco("default")(10),pal_ucscgb("default")(26),pal_d3("category10")(10),
               pal_locuszoom("default")(7),pal_igv("default")(51),
               pal_uchicago("default")(9),pal_startrek("uniform")(7),
               pal_tron("legacy")(7),pal_futurama("planetexpress")(12),pal_rickandmorty("schwifty")(12),
               pal_simpsons("springfield")(16),pal_gsea("default")(12)))


ggplot(df, aes(x = x, fill=stratum, label=stratum,
               stratum = stratum, alluvium  = value))+#数据
  geom_flow(width = 0.3,#连线宽度
            curve_type = "sine",#曲线形状，有linear、cubic、quintic、sine、arctangent、sigmoid几种类型可供调整
            alpha = 0.5,#透明度
            color = 'white',#间隔颜色
            size = 0.1)+#间隔宽度
  geom_stratum(width = 0.28)+#图中方块的宽度
  #geom_text(stat = 'stratum', size = 5, color = 'black')+
  scale_fill_manual(values = new_color)+#自定义颜色
  theme_void()+#主题（无轴及网格线）
  theme()#去除图例







######正常（tica, hcl, tts)
all_data_normal = data.frame()
tica = read.table("E:/lcw/lncSPA/lncRNA/TICA_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tica)[6] = "cell_type"
tica = tica[,c("cell_type","tissue_type")]
tica$cell_class = 0
tica$source = "tica"


tica_ann = read.table("E:/lcw/lncSPA/xukang/zhenghe/res/1celltree/tissue_annotation.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

tica_class = tica_ann %>% distinct(cell,compartment,.keep_all = T)

for(i in 1:nrow(tica_class)){
  tica$cell_class[tica$cell_type == tica_class$cell[i]] = tica_class$compartment[i]
}

tica = tica[,c("cell_type","cell_class","tissue_type","source")]

all_data_normal = rbind(all_data_normal,tica)


##tts(搁置)
tts = read.table("E:/lcw/lncSPA/lncRNA/The_Tabula_Sapiens_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tts)[2] = "cell_type"
tts = tts[,c("cell_type","tissue_type")]
tts$cell_class = 0
tts$source = "tts"


tts_ann = read.table("E:/lcw/lncSPA/文章图/河流图/The_Tabula_Sapiens_tissue_cell_num.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

tts_class = tts_ann %>% distinct(cell_type,compartment,.keep_all = T)

for(i in 1:nrow(tts_class)){
  tts$cell_class[tts$cell_type == tts_class$cell_type[i]] = tts_class$compartment[i]
}

tts = tts[,c("cell_type","cell_class","tissue_type","source")]

all_data_normal = rbind(all_data_normal,tts)

##hcl
hcl = read.table("E:/lcw/lncSPA/lncRNA/HCL_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl)[2] = "cell_type"
hcl = hcl[,c("cell_type","tissue_type")]
hcl$cell_class = 0
hcl$source = "hcl"


hcl_ann = read.table("E:/lcw/lncSPA/文章图/河流图/HCL_tissue_cell_num_com.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_ann)[4] = "cell_type"
hcl_ann = data.frame(cell_type = hcl_ann$cell_type,compartment = hcl_ann$compartment)
hcl_class = hcl_ann %>% distinct(cell_type,compartment,.keep_all = T)

for(i in 1:nrow(hcl_class)){
  hcl$cell_class[hcl$cell_type == hcl_class$cell_type[i]] = hcl_class$compartment[i]
}

hcl = hcl[,c("cell_type","cell_class","tissue_type","source")]

all_data_normal = rbind(all_data_normal,hcl)

##hcl_fetal
hcl_fetal = read.table("E:/lcw/lncSPA/lncRNA/HCL_fetal_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_fetal)[2] = "cell_type"
hcl_fetal = hcl_fetal[,c("cell_type","tissue_type")]
hcl_fetal$cell_class = 0
hcl_fetal$source = "hcl_fetal"


hcl_fetal_ann = read.table("E:/lcw/lncSPA/文章图/河流图/HCL_fetal_annotation.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_fetal_ann)[5] = "cell_type"
hcl_fetal_ann = data.frame(cell_type = hcl_fetal_ann$cell_type,compartment = hcl_fetal_ann$compartment)
hcl_fetal_class = hcl_fetal_ann %>% distinct(cell_type,compartment,.keep_all = T)

for(i in 1:nrow(hcl_fetal_class)){
  hcl_fetal$cell_class[hcl_fetal$cell_type == hcl_fetal_class$cell_type[i]] = hcl_fetal_class$compartment[i]
}

hcl_fetal = hcl_fetal[,c("cell_type","cell_class","tissue_type","source")]

all_data_normal = rbind(all_data_normal,hcl_fetal)

all_data_normal$cell_class[all_data_normal$cell_class == 0] = "endothelial"
all_data_normal$cell_class[as.character(all_data_normal$cell_type) == "Macrophage"] = "immune"


all_cell_type = read_xlsx("E:/lcw/lncSPA/数据统一/all_cell_type(fixed).xlsx",col_names = F)
for(i in 1:nrow(all_cell_type)){
  all_data_normal$cell_type[all_data_normal$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}


lnc2_table = read.csv("E:/lcw/lncSPA/文章图/lnc2_tissue_table.csv")
all_data_normal$system= 0

for(i in 1:nrow(lnc2_table)){
  all_data_normal$tissue_type[all_data_normal$tissue_type == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
  all_data_normal$system[all_data_normal$tissue_type == lnc2_table$tissue[i]] = lnc2_table$system[i]
}


all_data_normal$cell_class[all_data_normal$cell_type == "Hepatocyte"] = "stromal"
all_data_normal$cell_class[all_data_normal$cell_type == "Epithelial cell"] = "epithelial"
all_data_normal$cell_class[all_data_normal$cell_type == "Mesothelial cell"] = "epithelial"
all_data_normal$cell_class[all_data_normal$cell_type == "Progenitor cell"] = "stromal"
all_data_normal$cell_class[all_data_normal$cell_type == "Leydig cell"] = "epithelial"
all_data_normal$cell_class[all_data_normal$cell_type == "Macrophage"] = "immune"

aa = all_data_normal %>% distinct(cell_type,cell_class,.keep_all = T)
table(aa$cell_type) %>% as.data.frame()%>%View()

#排列问题

all_data_normal$cell_class[all_data_normal$cell_class == "Other"] = "other"

all_data_normal = all_data_normal[str_order(all_data_normal$cell_class),]

all_data_normal$cell_type = factor(all_data_normal$cell_type,levels = unique(all_data_normal$cell_type))


all_data_normal = all_data_normal[str_order(all_data_normal$system),]
all_data_normal$tissue_type = factor(all_data_normal$tissue_type,levels = unique(all_data_normal$tissue_type))


write.table(all_data_normal,"E:/lcw/lncSPA/文章图/all_lnc_normal.txt",sep="\t",quote=F,row.names=F,col.names = T)
##画图
library(ggplot2)
library(ggalluvial)
library(paletteer)
library(ggsci)

df1 <- to_lodes_form(all_data_normal[,1:3],
                    axes = 1:3,
                    id = "value")



col<- c(paletteer_c("ggthemes::Blue", 3),
        heat.colors(50),
        paletteer_c("ggthemes::Purple", 9),
        terrain.colors(31),
        paletteer_d("ggthemes::excel_Berlin"),
        topo.colors(40),
        paletteer_d("ggthemes::excel_Madison"),
        cm.colors(53))


ggplot(df1, aes(x = x, fill=stratum, label=stratum,
               stratum = stratum, alluvium  = value))+#数据
  geom_flow(width = 0.3,#连线宽度
            curve_type = "sine",#曲线形状，有linear、cubic、quintic、sine、arctangent、sigmoid几种类型可供调整
            alpha = 0.5,#透明度
            color = 'white',#间隔颜色
            size = 0.1)+#间隔宽度
  geom_stratum(width = 0.28)+#图中方块的宽度
  #geom_text(stat = 'stratum', size = 5, color = 'black')+
  scale_fill_manual(values = col)+#自定义颜色
  theme_void()+#主题（无轴及网格线）
  theme()#去除图例



#####2

library(stringr)
library(dplyr)
##normal----
lnc1_normal = read.table("E:/lcw/lncSPA/文章图/lncRNA_num_across_each_tissue_lncspa1.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
lnc1_normal = as.data.frame(t(lnc1_normal))
lnc1_normal$TE_number = apply(lnc1_normal,1,sum)
colnames(lnc1_normal)[1:5] = c("Integration","GTEx","HPA","HBM2","FANTOM")
lnc1_normal$tissue = rownames(lnc1_normal)
lnc1_normal$tissue[19] = "adipose"
lnc1_normal$tissue = str_replace(lnc1_normal$tissue,"\\."," ")
lnc1_normal = lnc1_normal[,c("tissue","TE_number")]

##normal

tica = read.table("E:/lcw/lncSPA/lncRNA/TICA_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica = tica[,c("gene","tissue_type")]
colnames(tica) = c("gene","tissue")
tica$source = "tica"

tts = read.table("E:/lcw/lncSPA/lncRNA/The_Tabula_Sapiens_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tts = tts[,c("gene","tissue_type")]
colnames(tts) = c("gene","tissue")
tts$source = "tts"



hcl = read.table("E:/lcw/lncSPA/lncRNA/HCL_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
hcl = hcl[,c("gene","tissue_type")]
colnames(hcl) = c("gene","tissue")
hcl$source = "hcl"

hcl_fetal = read.table("E:/lcw/lncSPA/lncRNA/HCL_fetal_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
hcl_fetal = hcl_fetal[,c("gene","tissue_type")]
colnames(hcl_fetal) = c("gene","tissue")
hcl_fetal$source = "hcl_fetal"


total_normal = rbind(hcl,tts,tica)

lnc2_table = read.csv("E:/lcw/lncSPA/文章图/lnc2_tissue_table.csv")

for(i in 1:nrow(lnc2_table)){
  total_normal$tissue[total_normal$tissue == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}

lnc2_normal = as.data.frame(table(total_normal$tissue))
colnames(lnc2_normal) = c("tissue","CE_number")
lnc2_normal$tissue = as.character(lnc2_normal$tissue)


for(i in 1:nrow(lnc2_table)){
  hcl_fetal$tissue[hcl_fetal$tissue == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}

aa = as.data.frame(table(hcl_fetal$tissue))
colnames(aa)[1] = "tissue"
aa$tissue = as.character(aa$tissue)

all = merge(aa,lnc2_normal,by = "tissue",all = T)

lnc2_normal$tissue = str_replace(lnc2_normal$tissue,"\\."," ")



merge_normal = merge(lnc1_normal,lnc2_normal,by = "tissue",all = T)
merge_normal[is.na(merge_normal)] = 0

merge_normal = merge_normal[order(merge_normal$CE_number,decreasing = T),]


library(ggplot2)
library(reshape2)
library(cowplot)

plot_data = data.frame()

for(i in 1:nrow(merge_normal)){
  temp = data.frame(lncRNA = c("TE_lnc","CE_lnc"),tissue = rep(merge_normal$tissue[i],2),number = c(merge_normal$TE_number[i],merge_normal$CE_number[i]))
  plot_data = rbind(plot_data,temp)
}

plot_data$tissue = factor(plot_data$tissue,levels = merge_normal$tissue)

ggplot(plot_data, aes(x=tissue, y=number, fill=lncRNA)) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme_bw()+
  scale_y_continuous(expand=c(0,0))+
  coord_cartesian(ylim = c(0, 12000))+
  theme_classic()+#去除网格线背景
  theme(axis.text.x = element_text(angle = 80, hjust = 1, vjust = 1,size = 14))+##设置x轴字体大小
  theme(axis.text.y = element_text(size = 14, color = "black"))+##设置y轴字体大小
  theme(title=element_text(size=13))#设置标题字体大小











####cancer----

lnc1_cancer = read.table("E:/lcw/lncSPA/文章图/lncRNA_num_across_cancer_lncspa1.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
lnc1_cancer = as.data.frame(t(lnc1_cancer))
lnc1_cancer$cli_TE = rownames(lnc1_cancer)
colnames(lnc1_cancer) = c("TE_number","cancer")
lnc1_cancer$cancer[26] = "AML"
lnc1_cancer$cancer[11] = "HNSCC"


##cancer
tisch = read.table("E:/lcw/lncSPA/lncRNA/TISCH_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tisch = tisch[,c("gene","cancer_type")]
colnames(tisch) = c("gene","tissue")

tiger = read.table("E:/lcw/lncSPA/lncRNA/TIGER_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger = tiger[,c("gene","cancer_type")]
colnames(tiger) = c("gene","tissue")

cell_res = read.table("E:/lcw/lncSPA/lncRNA/cell_research_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cell_res = cell_res[,c("gene","tissue_type")]
colnames(cell_res) = c("gene","tissue")


epn = read.table("E:/lcw/lncSPA/lncRNA/GSE125969_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
epn = epn[,c("gene","tissue_type")]
colnames(epn) = c("gene","tissue")



other = read.table("E:/lcw/lncSPA/lncRNA/GSE140819_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
other = other[,c("gene","tissue_type")]
colnames(other) = c("gene","tissue")


total_cancer = rbind(tisch,tiger,cell_res,epn,other)

lnc2_table = read.csv("E:/lcw/lncSPA/文章图/lnc2_tissue_table.csv")

for(i in 1:nrow(lnc2_table)){
  total_cancer$tissue[total_cancer$tissue == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}

lnc2_cancer = as.data.frame(table(total_cancer$tissue))
colnames(lnc2_cancer) = c("cancer","CE_number")
lnc2_cancer$cancer = as.character(lnc2_cancer$cancer)



merge_cancer = merge(lnc1_cancer,lnc2_cancer,by = "cancer",all = T)
merge_cancer[is.na(merge_cancer)] = 0


merge_cancer = merge_cancer[order(merge_cancer$CE_number,decreasing = T),]


library(ggplot2)
library(reshape2)
library(cowplot)

plot_data_cancer = data.frame()

for(i in 1:nrow(merge_cancer)){
  temp = data.frame(lncRNA = c("TE_lnc","CE_lnc"),Cancer = rep(merge_cancer$cancer[i],2),number = c(merge_cancer$TE_number[i],merge_cancer$CE_number[i]))
  plot_data_cancer = rbind(plot_data_cancer,temp)
}

plot_data_cancer$Cancer = factor(plot_data_cancer$Cancer,levels = merge_cancer$cancer)

ggplot(plot_data_cancer, aes(x=Cancer, y=number, fill=lncRNA)) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme_bw()+
  scale_y_continuous(expand=c(0,0))+
  coord_cartesian(ylim = c(0, 6000))+
  theme_classic() +
  theme(axis.text.x = element_text(angle = 80, hjust = 1, vjust = 1,size = 14))+##设置x轴字体大小
  theme(axis.text.y = element_text(size = 14, color = "black"))+##设置y轴字体大小
  theme(title=element_text(size=13))#设置标题字体大小
#coord_flip()##这一步是让柱状图横过来，不加的话柱状图是竖着的

























####比较----

dataset = data.frame(lncSPA1.0 = c(4,0,1,1),lncSPA2.0 = c(3,1,74,5))
rownames(dataset) = c("Normal(Adult)","Normal(Fetal)","Cancer(Adult)","Cancer(Pediatric)")

dataset = data.frame(Sample_class = rep(c("Normal(Adult)","Normal(Fetal)","Cancer(Adult)","Cancer(Pediatric)"),each = 2),source = rep(c("lncSPA1.0","lncSPA2.0"),4),
                     Number = c(4,3,0,1,1,74,1,5))
dataset$Sample_class = factor(dataset$Sample_class,levels = c("Cancer(Pediatric)","Normal(Fetal)","Normal(Adult)","Cancer(Adult)"))

dataset$lable = "Dataset"


T_or_D = data.frame(lncSPA1.0 = c(38,0,33,7),lncSPA2.0 = c(60,20,32,5))
rownames(T_or_D) = c("Normal(Adult)","Normal(Fetal)","Cancer(Adult)","Cancer(Pediatric)")

T_or_D = data.frame(Sample_class = rep(c("Normal(Adult)","Normal(Fetal)","Cancer(Adult)","Cancer(Pediatric)"),each = 2),source = rep(c("lncSPA1.0","lncSPA2.0"),4),
                    Number = c(38,60,0,20,33,32,7,5))
T_or_D$Sample_class = factor(T_or_D$Sample_class,levels = c("Cancer(Pediatric)","Normal(Fetal)","Normal(Adult)","Cancer(Adult)"))

T_or_D$lable = "Tissue/Disease"


cell_or_sample = data.frame(lncSPA1.0 = c(9426,0,11093,711),lncSPA2.0 = c(1209450,211059,1417873,55405))
rownames(cell_or_sample) = c("Normal(Adult)","Normal(Fetal)","Cancer(Adult)","Cancer(Pediatric)")

cell_or_sample = data.frame(Sample_class = rep(c("Normal(Adult)","Normal(Fetal)","Cancer(Adult)","Cancer(Pediatric)"),each = 2),source = rep(c("lncSPA1.0","lncSPA2.0"),4),
                            Number = c(9426,1209450,0,211059,11093,1417873,711,55405))
cell_or_sample$Sample_class = factor(cell_or_sample$Sample_class,levels = c("Cancer(Pediatric)","Normal(Fetal)","Normal(Adult)","Cancer(Adult)"))

cell_or_sample$lable = "Cell/sample"


all = rbind(dataset,T_or_D,cell_or_sample)

all$lable = factor(all$lable,levels = unique(all$lable))

library(ggplot2)
library(ggbreak)
# 
# ggplot(dataset, aes(
#   x = factor(Sample_class,levels = c("Cancer(Pediatric)","Normal(Fetal)","Normal(Adult)","Cancer(Adult)")), # 将第一列转化为因子，目的是显示顺序与文件顺序相同，否则按照字母顺序排序
#   y = Number#y = ifelse(source == "lncSPA1.0", Number, -Number),  # 判断分组情况，将两个柱子画在0的两侧
#   fill = source)) +
#   geom_bar(stat = 'stack')+                                # 画柱形图
#   coord_cartesian(ylim = c(0, 100))+
#   coord_flip()+                                               # x轴与y轴互换位置
#   geom_text(                                                  # 在图形上加上数字标签
#     aes(label=Number,                                          # 标签的值（数据框的第三列）
#         # vjust = ifelse(variable == "Up", -0.5, 1),          # 垂直位置。如果没有coord_flip()，则可以取消这行注释
#         hjust = ifelse(source == "lncSPA1.0", -0.4, 1.1)),size=4)+            # 水平位置 
#   scale_y_continuous(                                         # 调整y轴
#     labels = abs)+                                            # 刻度设置为绝对值
#   theme_classic()#+
# #scale_y_break(c(-100, -55400),scales = "fixed",
#               #expand=expansion(add = c(0, 5)))





#dateset
ggplot(data=dataset,aes(Sample_class,Number,fill=source))+
  #如果是针对分组的柱形图，则position除了可以"identity"(不调整，组内前后重叠)、还包括“stack“（堆积，默认）；"fill"(按比例堆积)；“dodge“（分散开）
  geom_bar(stat="identity",position="stack", color="black", width=0.7,size=0.25)+
  scale_fill_manual(values=c("#00BFC4","#F8766D"))+
  labs(x = "",y = "Nutrient (mg/L)")+# 添加x，y轴名
  #scale_y_continuous(expand = c(0,0))+# 坐标轴延伸，确保图形元素覆盖至坐标
  theme_classic()+# 主题类型
  # 设置主题
  theme(panel.background=element_rect(fill="white",colour="black",size=0.25), # 填充框内主题颜色，边框颜色和边框线条粗细
        axis.line=element_line(colour="black",size=0.25), # x,y轴颜色，粗细
        axis.title=element_text(size=13,color="black"), # x,y轴名设置
        axis.text = element_text(size=12,color="black"), # x,y轴文本设置
        legend.position= c(0.9,0.85) # 显示图例，c(x,y)这里指将轴默认为1，里面的数字为轴的占比
  )




#dateset
ggplot(data=dataset,aes(Sample_class,Number,fill=source))+
  #如果是针对分组的柱形图，则position除了可以"identity"(不调整，组内前后重叠)、还包括“stack“（堆积，默认）；"fill"(按比例堆积)；“dodge“（分散开）
  geom_bar(stat="identity",position="stack", color="black", width=0.7,size=0.25)+
  scale_fill_manual(values=c("#00BFC4","#F8766D"))+
  labs(x = "",y = "Nutrient (mg/L)")+# 添加x，y轴名
  #scale_y_continuous(expand = c(0,0))+# 坐标轴延伸，确保图形元素覆盖至坐标
  theme_classic()+# 主题类型
  # 设置主题
  theme(panel.background=element_rect(fill="white",colour="black",size=0.25), # 填充框内主题颜色，边框颜色和边框线条粗细
        axis.line=element_line(colour="black",size=0.25), # x,y轴颜色，粗细
        axis.title=element_text(size=13,color="black"), # x,y轴名设置
        axis.text = element_text(size=12,color="black"), # x,y轴文本设置
        legend.position= c() # 显示图例，c(x,y)这里指将轴默认为1，里面的数字为轴的占比
  )



#cell_sample
ggplot(data=cell_or_sample,aes(Sample_class,Number,fill=source))+
  #如果是针对分组的柱形图，则position除了可以"identity"(不调整，组内前后重叠)、还包括“stack“（堆积，默认）；"fill"(按比例堆积)；“dodge“（分散开）
  geom_bar(stat="identity",position="stack", color="black", width=0.7,size=0.25)+
  scale_fill_manual(values=c("#00BFC4","#F8766D"))+
  labs(x = "",y = "Nutrient (mg/L)")+# 添加x，y轴名
  #scale_y_continuous(expand = c(0,0))+# 坐标轴延伸，确保图形元素覆盖至坐标
  theme_classic()+# 主题类型
  # 设置主题
  theme(panel.background=element_rect(fill="white",colour="black",size=0.25), # 填充框内主题颜色，边框颜色和边框线条粗细
        axis.line=element_line(colour="black",size=0.25), # x,y轴颜色，粗细
        axis.title=element_text(size=13,color="black"), # x,y轴名设置
        axis.text = element_text(size=12,color="black"), # x,y轴文本设置
        legend.position= c() # 显示图例，c(x,y)这里指将轴默认为1，里面的数字为轴的占比
  )


#T_or_D
ggplot(data=T_or_D,aes(Sample_class,Number,fill=source))+
  #如果是针对分组的柱形图，则position除了可以"identity"(不调整，组内前后重叠)、还包括“stack“（堆积，默认）；"fill"(按比例堆积)；“dodge“（分散开）
  geom_bar(stat="identity",position="stack", color="black", width=0.7,size=0.25)+
  scale_fill_manual(values=c("#00BFC4","#F8766D"))+
  labs(x = "",y = "Nutrient (mg/L)")+# 添加x，y轴名
  #scale_y_continuous(expand = c(0,0))+# 坐标轴延伸，确保图形元素覆盖至坐标
  theme_classic()+# 主题类型
  # 设置主题
  theme(panel.background=element_rect(fill="white",colour="black",size=0.25), # 填充框内主题颜色，边框颜色和边框线条粗细
        axis.line=element_line(colour="black",size=0.25), # x,y轴颜色，粗细
        axis.title=element_text(size=13,color="black"), # x,y轴名设置
        axis.text = element_text(size=12,color="black"), # x,y轴文本设置
        legend.position= c() # 显示图例，c(x,y)这里指将轴默认为1，里面的数字为轴的占比
  )



####3.26所有细胞类型  
library(readxl)
all_cell_type = read_xlsx("E:/lcw/lncSPA/数据统一/all_cell_type(fixed).xlsx",col_names = F)

######正常（tica, hcl, tts)
all_data_normal = data.frame()

tica = read.table("E:/lcw/lncSPA/lncRNA/TICA_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tica)[6] = "cell_type"

for(i in 1:nrow(all_cell_type)){
  tica$cell_type[tica$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}
temp = as.data.frame(table(tica$cell_type))
temp$source = "tica"

all_data_normal = rbind(all_data_normal,temp)


##tts(搁置)
tts = read.table("E:/lcw/lncSPA/lncRNA/The_Tabula_Sapiens_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tts)[2] = "cell_type"

for(i in 1:nrow(all_cell_type)){
  tts$cell_type[tts$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

temp = as.data.frame(table(tts$cell_type))
temp$source = "tts"

all_data_normal = rbind(all_data_normal,temp)

##hcl
hcl = read.table("E:/lcw/lncSPA/lncRNA/HCL_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl)[2] = "cell_type"

for(i in 1:nrow(all_cell_type)){
  hcl$cell_type[hcl$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

temp = as.data.frame(table(hcl$cell_type))
temp$source = "hcl"

all_data_normal = rbind(all_data_normal,temp)


##hcl_fetal
hcl_fetal = read.table("E:/lcw/lncSPA/lncRNA/HCL_fetal_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_fetal)[2] = "cell_type"

for(i in 1:nrow(all_cell_type)){
  hcl_fetal$cell_type[hcl_fetal$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

temp = as.data.frame(table(hcl_fetal$cell_type))
temp$source = "hcl_fetal"

all_data_normal = rbind(all_data_normal,temp)

colnames(all_data_normal)[1] = "cell_type"
all_data_normal$cell_type = as.character(all_data_normal$cell_type)

write.xlsx(all_data_normal,"E:/lcw/lncSPA/文章图/normal_celltype_source.xlsx")





####癌症
lnc2_table = read.csv("E:/lcw/lncSPA/文章图/lnc2_tissue_table.csv")
all_data_cancer = data.frame()
##tisch
tisch = read.table("E:/lcw/lncSPA/lncRNA/TISCH_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(all_cell_type)){
  tisch$cell_type[tisch$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

for(i in 1:nrow(lnc2_table)){
  tisch$cancer_type[tisch$cancer_type == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}


tisch$source = str_c(tisch$cancer_type,tisch$Dataset,sep = "_")

temp = as.data.frame(table(tisch$source))

for(i in 1:nrow(temp)){
  tt = tisch[tisch$source == as.character(temp$Var1[i]),]
  tt_temp = as.data.frame(table(tt$cell_type))
  tt_temp$source = as.character(temp$Var1[i])
  all_data_cancer = rbind(all_data_cancer,tt_temp)
}


##tiger
tiger = read.table("E:/lcw/lncSPA/lncRNA/TIGER_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(all_cell_type)){
  tiger$cell_type[tiger$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

for(i in 1:nrow(lnc2_table)){
  tiger$cancer_type[tiger$cancer_type == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}


tiger$source = str_c(tiger$cancer_type,tiger$Dataset,sep = "_")

temp = as.data.frame(table(tiger$source))

for(i in 1:nrow(temp)){
  tt = tiger[tiger$source == as.character(temp$Var1[i]),]
  tt_temp = as.data.frame(table(tt$cell_type))
  tt_temp$source = as.character(temp$Var1[i])
  all_data_cancer = rbind(all_data_cancer,tt_temp)
}

##epn
epn = read.table("E:/lcw/lncSPA/lncRNA/GSE125969_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

for(i in 1:nrow(all_cell_type)){
  epn$cell[epn$cell == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

temp = as.data.frame(table(epn$cell))
temp$source = "EPN"

all_data_cancer = rbind(all_data_cancer,temp)


##other

other = read.table("E:/lcw/lncSPA/lncRNA/GSE140819_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(other)[2] = "cell_type"
colnames(other)[3] = "cancer_type"
for(i in 1:nrow(all_cell_type)){
  other$cell_type[other$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

temp = as.data.frame(table(other$cell_type))
temp$source = "GSE140819"

all_data_cancer = rbind(all_data_cancer,temp)


##cell_res
cell_res = read.table("E:/lcw/lncSPA/lncRNA/cell_research_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(cell_res)[2] = "cell_type"
colnames(cell_res)[3] = "cancer_type"
for(i in 1:nrow(all_cell_type)){
  cell_res$cell_type[cell_res$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}

temp = as.data.frame(table(cell_res$cell_type))
temp$source = "cell_res"

all_data_cancer = rbind(all_data_cancer,temp)



write.xlsx(all_data_cancer,"E:/lcw/lncSPA/文章图/cancer_celltype_source.xlsx")


####3.29细胞类型整理----
library(readxl)
library(stringr)
all_cell_type = read_xlsx("E:/lcw/lncSPA/数据统一/all_cell_type(fixed).xlsx",col_names = F)
write.table(all_cell_type,"E:/lcw/lncSPA/数据统一/all_cell_type(fixed).txt",sep="\t",quote=F,row.names=F,col.names = T)
#cell_res_celltree
cell_res_celltree = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_celltree.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(all_cell_type)){
  cell_res_celltree$cell_type[cell_res_celltree$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
}
write.table(cell_res_celltree,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_celltree.txt",sep="\t",quote=F,row.names=F,col.names = T)

#cell_res_adult_lncexp
cell_res_adult_lncexp = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_adult_lncexp.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(all_cell_type)){
  colnames(cell_res_adult_lncexp)[colnames(cell_res_adult_lncexp) == all_cell_type$...1[i]] = all_cell_type$...3[i]
}
write.table(cell_res_adult_lncexp,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_adult_lncexp.txt",sep="\t",quote=F,row.names=F,col.names = T)

#cell_res_adult_max（不需要修改）
# cell_res_adult_max = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_adult_max.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
# for(i in 1:nrow(all_cell_type)){
#   colnames(cell_res_adult_lncexp)[colnames(cell_res_adult_lncexp) == all_cell_type$...1[i]] = all_cell_type$...3[i]
# }
# write.table(cell_res_adult_max,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_adult_max.txt",sep="\t",quote=F,row.names=F,col.names = T)

#cell_res_adult_paste
cell_res_adult_paste = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_adult_paste.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(cell_res_adult_paste)){
  for(j in 1:nrow(all_cell_type)){
    if(str_detect(cell_res_adult_paste$mRNA[i],all_cell_type$...1[j])){
      cell_res_adult_paste$mRNA[i] = str_replace_all(cell_res_adult_paste$mRNA[i],all_cell_type$...1[j],all_cell_type$...3[j])
    }
  }
}
write.table(cell_res_adult_paste,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_adult_paste.txt",sep="\t",quote=F,row.names=F,col.names = T)

#cell_res_basic
cell_res_basic = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_basic.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(all_cell_type)){
  cell_res_basic$cell[cell_res_basic$cell == all_cell_type$...1[i]] = all_cell_type$...3[i]
  cell_res_basic$cell_fullname[cell_res_basic$cell_fullname == all_cell_type$...1[i]] = all_cell_type$...3[i]
}
write.table(cell_res_basic,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_basic.txt",sep="\t",quote=F,row.names=F,col.names = T)


# #cell_res_compart（不需要修改）
# cell_res_compart = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_compart.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
# for(i in 1:nrow(all_cell_type)){
#   cell_res_celltree$cell_type[cell_res_celltree$cell_type == all_cell_type$...1[i]] = all_cell_type$...3[i]
# }
# write.table(cell_res_compart,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_compart.txt",sep="\t",quote=F,row.names=F,col.names = T)
# 

# #cell_res_order（不需要修改）


#cell_res_sunburst
cell_res_sunburst = read.table("E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/cell_res_sunburst.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
for(i in 1:nrow(cell_res_sunburst)){
  for(j in 1:nrow(all_cell_type)){
    if(str_detect(cell_res_sunburst$cell[i],all_cell_type$...1[j])){
      cell_res_sunburst$cell[i] = str_replace_all(cell_res_sunburst$cell[i],all_cell_type$...1[j],all_cell_type$...3[j])
    }
  }
}
write.table(cell_res_sunburst,"E:/lcw/lncSPA/统计/3.29_细胞类型整合/cell_res/after/cell_res_sunburst.txt",sep="\t",quote=F,row.names=F,col.names = T)



a = c(1,2,3,4,1,2,3,4,5,6,1,2,3,4,5,5,5,1,2,6,1,4,8,1,2)
index = c()
for(i in 2:(length(a)-1)){if((a[i] >= a[i+1]) & (a[i] >= a[i-1])){index = c(index,i)}}



#zhengli
data = read.table("E:/lcw/lncSPA/数据统一/HCL_fetal_tissue_cell_num.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data_table = as.data.frame(table(data$tissue_type))
for(i in 1:nrow(data_table)){
  data_table$all[i] = sum(data$num[data$tissue_type == as.character(data_table$Var1[i])])
}

hcl_fetal = data_table


##
data = read.table("E:/lcw/lncSPA/数据统一/HCL_tissue_cell_num.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data_table = as.data.frame(table(data$tissue_type))
for(i in 1:nrow(data_table)){
  data_table$all[i] = sum(data$num[data$tissue_type == as.character(data_table$Var1[i])])
}

hcl = data_table

##
data = read.table("E:/lcw/lncSPA/数据统一/The_Tabula_Sapiens_tissue_cell_num.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data_table = as.data.frame(table(data$tissue_type))
for(i in 1:nrow(data_table)){
  data_table$all[i] = sum(data$num[data$tissue_type == as.character(data_table$Var1[i])])
}

tts = data_table



##
data = read.table("E:/lcw/lncSPA/xukang/zhenghe/res/1celltree/tissue_cell_CE_lncRNA_num.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)

data_table = as.data.frame(table(data$tissue_type))
for(i in 1:nrow(data_table)){
  data_table$all[i] = sum(data$cell_num[data$tissue_type == as.character(data_table$Var1[i])])
}

tica = data_table


all=rbind(tts,hcl,hcl_fetal,tica)



####510table_all-----
library(stringr)
library(dplyr)
library(openxlsx)
tisch = read.table("E:/lcw/lncSPA/lncRNA/TISCH_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tisch$From = str_c(tisch$cancer_type,tisch$Dataset,sep = "_")
tisch$A_F = "Adult"
tisch$T_C = tisch$cancer_type
tisch$N_C = "cancer"
tisch$source = tisch$Dataset
colnames(tisch)[10] = "tissue_type"


tiger = read.table("E:/lcw/lncSPA/lncRNA/TIGER_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tiger$From = str_c(tiger$cancer_type,tiger$Dataset,sep = "_")
tiger$A_F = "Adult"
tiger$T_C = tiger$cancer_type
tiger$N_C = "cancer"
tiger$source = tiger$Dataset
colnames(tiger)[10] = "tissue_type"


tica = read.table("E:/lcw/lncSPA/lncRNA/TICA_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
tica$From = "TICA"
tica$A_F = "Adult"
tica$T_C = tica$tissue_type
tica$N_C = "normal"
tica$source = "tica"


tts = read.table("E:/lcw/lncSPA/lncRNA/The_Tabula_Sapiens_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(tts)[2] = "cell_type"
tts$From = "TTS"
tts$A_F = "Adult"
tts$T_C = tts$tissue_type
tts$N_C = "normal"
tts$source = "tts"


cell_res = read.table("E:/lcw/lncSPA/lncRNA/cell_research_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(cell_res)[2] = "cell_type"
cell_res$From = "cell_res"
cell_res$A_F = "Adult"
cell_res$T_C = cell_res$tissue_type
cell_res$N_C = "cancer"
cell_res$source = "cell_res"

hcl = read.table("E:/lcw/lncSPA/lncRNA/HCL_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl)[2] = "cell_type"
hcl$From = "HCL"
hcl$A_F = "Adult"
hcl$T_C = hcl$tissue_type
hcl$N_C = "normal"
hcl$source = "hcl"

hcl_fetal = read.table("E:/lcw/lncSPA/lncRNA/HCL_fetal_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(hcl_fetal)[2] = "cell_type"
hcl_fetal$From = "HCL"
hcl_fetal$A_F = "Fetal"
hcl_fetal$T_C = hcl_fetal$tissue_type
hcl_fetal$N_C = "normal"
hcl_fetal$source = "hcl_fetal"


epn = read.table("E:/lcw/lncSPA/lncRNA/GSE125969_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(epn)[2] = "cell_type"
epn$From = "EPN"
epn$A_F = "Fetal"#"Adult"#
epn$T_C = epn$tissue_type
epn$N_C = "cancer"
epn$source = "epn"


other = read.table("E:/lcw/lncSPA/lncRNA/GSE140819_lncRNA_information.cell_num_10.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
colnames(other)[2] = "cell_type"
other$From = "GSE140819"
other$A_F = ifelse(str_detect(other$tissue_type,"Adult"),"Adult","Fetal")
other$T_C = other$tissue_type
other$N_C = "cancer"
other$source = "GSE140819"


tisch$cancer = str_c(tisch$tissue_type,tisch$Dataset,sep = "_")
tiger$cancer = str_c(tiger$tissue_type,tiger$Dataset,sep = "_")
tica$cancer = str_c(tica$tissue_type,tica$From,sep = "_")
tts$cancer = str_c(tts$tissue_type,tts$From,sep = "_")
cell_res$cancer = str_c(cell_res$tissue_type,cell_res$From,sep = "_")
hcl$cancer = str_c(hcl$tissue_type,hcl$From,sep = "_")
hcl_fetal$cancer = str_c(hcl_fetal$tissue_type,hcl_fetal$source,sep = "_")
epn$cancer = str_c(epn$tissue_type,epn$From,sep = "_")
other$cancer = str_c(other$tissue_type,other$From,sep = "_")



total_data = rbind(cell_res[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   epn[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   other[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   hcl_fetal[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   hcl[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   tts[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   tica[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   tiger[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")],
                   tisch[,c("gene","cell_type","A_F","N_C","class","tissue_type","source","cancer")])


all_cell_type = read.xlsx("E:/lcw/lncSPA/数据统一/all_cell_type(fixed).xlsx",colNames = F)


for(i in 1:nrow(all_cell_type)){
  total_data$cell_type[total_data$cell_type == all_cell_type$X1[i]] = all_cell_type$X3[i]
}


lnc2_table = read.csv("E:/lcw/lncSPA/文章图/lnc2_tissue_table.csv")

for(i in 1:nrow(lnc2_table)){
  total_data$tissue_type[total_data$tissue_type == lnc2_table$Var1[i]] = lnc2_table$tissue[i]
}
total_data$cancer = str_c(total_data$tissue_type,total_data$source,sep = ":")

# colnames(lnc2_table)[4] = "tissue_type"

spl3 = read.xlsx("E:/lcw/lncCE/Supplementary Table 3.xlsx")

spl3$dataset = apply(spl3,1,function(x){
  temp = total_data[total_data$gene == x[1] & total_data$cell_type == x[2] & total_data$A_F == x[3] & total_data$N_C == x[4],]
  return(paste(temp$cancer,collapse = ","))
})

write.xlsx(spl3,"E:/lcw/lncCE/Supplementary Table 3(改).xlsx")
####919附表补充----





total_data_01 = merge(total_data,aa[,c("tissue_type","system")],by = "tissue_type",all = T)

data_AN = total_data_01[total_data_01$A_F == "Adult" & total_data_01$N_C == "normal",] %>% group_by(system,tissue_type) %>% summarise(count = n())
data_AC = total_data_01[total_data_01$A_F == "Adult" & total_data_01$N_C == "cancer",] %>% group_by(system,tissue_type) %>% summarise(count = n())
data_FC = total_data_01[total_data_01$A_F == "Fetal" & total_data_01$N_C == "cancer",] %>% group_by(system,tissue_type) %>% summarise(count = n())
data_FN = total_data_01[total_data_01$A_F == "Fetal" & total_data_01$N_C == "normal",] %>% group_by(system,tissue_type) %>% summarise(count = n())


table_temp = total_data %>% group_by(source,tissue_type,cell_type) %>% summarize(count = n())

write.table(table_temp,file="E:/lcw/lncCE/lnc_statistics_1.txt",sep="\t",quote=F,row.names=F,col.names=T)

View(table(total_data$tissue_type))
View(table(total_data$cell_type[total_data$tissue_type == "GLI"]))

aa = as.data.frame(table(total_data$gene))

marker_res_all = data.frame()

for(i in 1:nrow(aa)){
  temp_gene = total_data[total_data$gene == aa$Var1[i],]
  uni_data = temp_gene %>% distinct(gene,cell_type,A_F,N_C,.keep_all = T)
  uni_data$count = 0
  for(j in 1:nrow(uni_data)){
    temp001 = temp_gene[(temp_gene$cell_type == uni_data$cell_type[j] & temp_gene$A_F == uni_data$A_F[j] & temp_gene$N_C == uni_data$N_C[j]),]
    uni_data$count[j] = nrow(temp001)
  }
  
  marker_res_all = rbind(marker_res_all,uni_data)
}


write.csv(marker_res_all,"E:/lcw/lncSPA/图标/marker_res_all.csv")




#5.24相关结果不卡阈值----

#####TIGER----
input <- "E:/lcw/lncSPA/TIGER/res/5cor/cor_result/"

listfile = list.files("E:/lcw/lncSPA/TIGER/exp/")
listfile = str_sub(listfile,1,-5)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
#write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:length(listfile)) {
  sclink_result <- read.table(paste(input,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
  sclink_result_005 <- sclink_result[which(sclink_result[,4] < 0.05),]
  #sclink_result_005_04 <- sclink_result_005[which(abs(sclink_result_005[,3]) > 0.4),]
  sclink_result_005$mRNA_ENSG <- mRNA[match(sclink_result_005$mRNA_name,mRNA$gene_name),"ensembl_gene_id"]
  sclink_result_005$lncRNA_ENSG <- lncRNA_all[match(sclink_result_005$lncRNA_name,lncRNA_all$gene_name),"ensembl_gene_id"]
  lncRNA_num <- unique(sclink_result_005$lncRNA_ENSG)
  for (j in 1:length(lncRNA_num)) {
    lncRNA_cor_mRNA <- sclink_result_005[which(sclink_result_005$lncRNA_ENSG == lncRNA_num[j]),]
    mRNA_paste <- apply(lncRNA_cor_mRNA[,c("mRNA_ENSG","mRNA_name","p_value","R","classification","cell")],1,function(x){paste(x,collapse=":")})
    mRNA_paste1 <- paste(mRNA_paste,collapse=";")
    lncRNA_paste <- paste(lncRNA_cor_mRNA[1,"lncRNA_ENSG"],lncRNA_cor_mRNA[1,"lncRNA_name"],sep=";")
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"cancer_type"],lncRNA_paste,mRNA_paste1)))
  }
}

colnames(final_res) = c("tissue_type","lncRNA_ID","mRNA_ID")
write.table(final_res,file="E:/lcw/lncSPA/TIGER/res/5cor/TIGER_lncRNA_cor_mRNA.result_no.txt",sep="\t",quote=F,row.names=F,col.names=T)


#####TICA----
input <- "E:/lcw/lncSPA/xukang/zhenghe/res/5lncRNA_cor_mRNA.result/cor_result/"

listfile = list.files("E:/lcw/lncSPA/xukang/zhenghe/exp/")
listfile = str_sub(listfile,1,-5)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
#write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:length(listfile)) {
  sclink_result <- read.table(paste(input,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
  sclink_result_005 <- sclink_result[which(sclink_result[,4] < 0.05),]
  #sclink_result_005_04 <- sclink_result_005[which(abs(sclink_result_005[,3]) > 0.4),]
  sclink_result_005$mRNA_ENSG <- mRNA[match(sclink_result_005$mRNA_name,mRNA$gene_name),"ensembl_gene_id"]
  sclink_result_005$lncRNA_ENSG <- lncRNA_all[match(sclink_result_005$lncRNA_name,lncRNA_all$gene_name),"ensembl_gene_id"]
  lncRNA_num <- unique(sclink_result_005$lncRNA_ENSG)
  for (j in 1:length(lncRNA_num)) {
    lncRNA_cor_mRNA <- sclink_result_005[which(sclink_result_005$lncRNA_ENSG == lncRNA_num[j]),]
    mRNA_paste <- apply(lncRNA_cor_mRNA[,c("mRNA_ENSG","mRNA_name","p_value","R","classification","cell")],1,function(x){paste(x,collapse=":")})
    mRNA_paste1 <- paste(mRNA_paste,collapse=";")
    lncRNA_paste <- paste(lncRNA_cor_mRNA[1,"lncRNA_ENSG"],lncRNA_cor_mRNA[1,"lncRNA_name"],sep=";")
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"tissue_type"],lncRNA_paste,mRNA_paste1)))
  }
}

colnames(final_res) = c("tissue_type","lncRNA_ID","mRNA_ID")
write.table(final_res,file="E:/lcw/lncSPA/xukang/zhenghe/res/5lncRNA_cor_mRNA.result/TICA_lncRNA_cor_mRNA.result_no.txt",sep="\t",quote=F,row.names=F,col.names=T)


#####TISCH----
input <- "E:/lcw/lncSPA/zhenghe/result/5TISCH.lncRNA_cor_mRNA.result/"

listfile = list.files("E:/lcw/lncSPA/zhenghe/result/5TISCH.lncRNA_cor_mRNA.result/",pattern = "cor_r_p.sclink.txt")
listfile = str_sub(listfile,1,-25)

lncRNA <- read.table("E:\\lcw\\lncSPA\\data\\lncRNA.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
mRNA <- read.table("E:\\lcw\\lncSPA\\data\\protein_coding.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
other_RNA <- read.table("E:\\lcw\\lncSPA\\data\\other_gene.gencode.v38.annotation.txt",header=T,sep="\t",stringsAsFactors=F)#RNA注释文件
lncRNA <- lncRNA[,c(1,2,5,6,7,8,9)]
other_RNA <- other_RNA[,c(1,2,5,6,7,8,9)]
lncRNA_all <- rbind(lncRNA,other_RNA)
final_res = data.frame()
#tissue <- "Adipose"
#write.table(t(c("tissue_type","lncRNA_ID","mRNA_ID")),"E:\\lcw\\lncSPA\\xukang\\zhenghe\\res\\5lncRNA_cor_mRNA.result\\lncRNA_cor_mRNA.result.txt",sep="\t",quote=F,row.names=F,col.names=F)
for (i in 1:length(listfile)) {
  sclink_result <- read.table(paste(input,listfile[i],".cell.cor_r_p.sclink.txt",sep=""),sep="\t",header=T,stringsAsFactors=F)
  sclink_result_005 <- sclink_result[which(sclink_result[,4] < 0.05),]
  #sclink_result_005_04 <- sclink_result_005[which(abs(sclink_result_005[,3]) > 0.4),]
  sclink_result_005$mRNA_ENSG <- mRNA[match(sclink_result_005$mRNA_name,mRNA$gene_name),"ensembl_gene_id"]
  sclink_result_005$lncRNA_ENSG <- lncRNA_all[match(sclink_result_005$lncRNA_name,lncRNA_all$gene_name),"ensembl_gene_id"]
  lncRNA_num <- unique(sclink_result_005$lncRNA_ENSG)
  for (j in 1:length(lncRNA_num)) {
    lncRNA_cor_mRNA <- sclink_result_005[which(sclink_result_005$lncRNA_ENSG == lncRNA_num[j]),]
    mRNA_paste <- apply(lncRNA_cor_mRNA[,c("mRNA_ENSG","mRNA_name","p_value","R","classification","cell")],1,function(x){paste(x,collapse=":")})
    mRNA_paste1 <- paste(mRNA_paste,collapse=";")
    lncRNA_paste <- paste(lncRNA_cor_mRNA[1,"lncRNA_ENSG"],lncRNA_cor_mRNA[1,"lncRNA_name"],sep=";")
    final_res = rbind(final_res,t(c(lncRNA_cor_mRNA[1,"cancer_type"],lncRNA_paste,mRNA_paste1)))
  }
}

colnames(final_res) = c("cancer_type","lncRNA_ID","mRNA_ID")
write.table(final_res,file="E:/lcw/lncSPA/zhenghe/result/TISCH_lncRNA_cor_mRNA.result_no.txt",sep="\t",quote=F,row.names=F,col.names=T)



setwd("E:/lcw/lncSPA/all_CE/")
listf = list.files()

all_ce = data.frame()

for(i in 1:length(listf)){
  dddd = read.table(listf[i],header = T,sep="\t")
  dddd = dddd[,c("gene_name","classification")]
  all_ce = rbind(all_ce,dddd)
}
all_ce = all_ce %>% distinct(gene_name,.keep_all = T)


####2023.7.4(快到最后了吧)-------

data = read.table("E:/lcw/lncCE/cancer_final.txt",header=T,sep="\t",stringsAsFactors=F)

all_cancer = as.data.frame(table(data$cancer))
all_cancer$tissue = c("blood","blood","Bone marrow")

setwd("E:/lcw/lncCE/6.25/")
cancer_a = read.table("cancer_a.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
cancer_p = read.table("cancer_p.txt",header=T,sep="\t",stringsAsFactors=F,check.names = F)
setwd("D:/R/script")

cancer_full = as.data.frame(table(c(cancer_a$cancer_full,cancer_p$cancer_full)))


cancer_full$tissue = c("Blood","Blood","Bone marrow","Skin","Bladder","Mammary","Liver",
                       "Blood","Colon","Rectum","Brain","Brain","Brain","Head and neck",
                       "Brain","Kidney","Liver","Liver","Lung","Skin","Skin","Mammary/Brain","Mammary/Liver","Mammary/Lymph node",
                       "Bone marrow","Brain","Small intestine","Lymph node","Lung","Lung",
                       "Uterus","Pancreas","Muscle","Bone marrow","Skin","Skin","Eye")

colnames(cancer_full)[1] = "cancer"
write.table(cancer_full,file="E:/lcw/lncSPA/cancer_tissue.txt",sep="\t",quote=F,row.names=F,col.names=T)


####画图----

library(Seurat)
data = readRDS("E:/lcw/lncSPA/zhenghe/TICSH/PAAD_CRA001160/PAAD_CRA001160.rds")
DimPlot(data, reduction = "tsne",   pt.size=0.5, label = F,repel = F,raster=FALSE)
FeaturePlot(data, reduction = "tsne",features = "PCAT19",raster=FALSE)












































