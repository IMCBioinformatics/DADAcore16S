suppressMessages(library("dplyr"))

## Importing data
taxa_GTDB<-read.table(paste0(snakemake@config[["output_dir"]],"/taxonomy/dada2_tables/GTDB_RDP.tsv"),header=TRUE, row.names = 1, sep = "\t")
taxa_GTDB<-cbind(taxa_GTDB,rownames(taxa_GTDB))
colnames(taxa_GTDB)[8]<-"asv_seq"

taxa_RDP<-read.table(paste0(snakemake@config[["output_dir"]],"/taxonomy/dada2_tables/RDP_RDP.tsv"))
taxa_RDP<-cbind(taxa_RDP,rownames(taxa_RDP))
colnames(taxa_RDP)[8]<-"asv_seq"

taxa_Silva<-read.table(paste0(snakemake@config[["output_dir"]],"/taxonomy/dada2_tables/Silva_RDP.tsv"))
taxa_Silva<-cbind(taxa_Silva,rownames(taxa_Silva))
colnames(taxa_Silva)[8]<-"asv_seq"

taxa_FieldDB<-read.table(paste0(snakemake@config[["output_dir"]],"/taxonomy/dada2_tables/FieldDB_RDP.tsv"))
taxa_FieldDB<-cbind(taxa_FieldDB,rownames(taxa_FieldDB))
colnames(taxa_FieldDB)[8]<-"asv_seq"

seqtab<-readRDS(snakemake@input[["seqs"]])
seqtab2<-t(seqtab)


#Calculating total abundance of each ASV
seqtab3<-cbind(rowSums(seqtab2),seqtab2);colnames(seqtab3)[1]<-"total"

#adding ASVs as a column to seqtab
seqtab4<-data.frame(cbind(rownames(seqtab3),seqtab3))
colnames(seqtab4)[1]<-"asv_seq"


##Genering ASV_number,sequences and length columns
df<-data.frame(cbind(paste0("ASV_",seq_along(1:nrow(taxa_GTDB))),rownames(taxa_GTDB),length<-nchar(rownames(taxa_GTDB))))
colnames(df)<-c("asv_num", "asv_seq","asv_len")


#joining all taxonoy files ands seq table by ASV seqs

df1<-left_join(df,taxa_GTDB,by="asv_seq")
df2<-left_join(df1,taxa_RDP,by="asv_seq")
df3<-left_join(df2,taxa_Silva,by="asv_seq")
df4<-left_join(df3,taxa_FieldDB,by="asv_seq")
df5<-left_join(df4,seqtab4,by="asv_seq")
  
colnames(df5)[1:31]<-c("asv_num", "asv_seq", "asv_len",	
                         "kingdom_gtdb", "phylum_gtdb",	"class_gtdb",	"order_gtdb",	
                         "family_gtdb",	"genus_gtdb",	"species_gtdb",	"kingdom_rdp",	
                         "phylum_rdp",	"class_rdp",	"order_rdp",	"family_rdp",	
                         "genus_rdp",	"species_rdp",	"kingdom_silva",	"phylum_silva",	
                         "class_silva",	"order_silva",	"family_silva",	"genus_silva",	
                         "species_silva","kingdom_FieldDB",	"phylum_FieldDB",	"class_FieldDB",	
                         "order_FieldDB",	"family_FieldDB",	"genus_FieldDB",	"species_FieldDB")
    

colnames(df5) <- gsub("^X", "", colnames(df5))
write.csv(df5,snakemake@output[["table"]],row.names = F)
