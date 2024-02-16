library(ggplot2)

my_colors2 <- c("#9DB3A9", "#A99B93", "#9DA0BF")

args <- commandArgs(trailingOnly = TRUE)

if (length(args)==0) {
    stop("", call.=FALSE)
} else if (length(args)>0) {
    clu_annot_path <- args[1]
    plot_sd_plddt_path <- args[2]
    plot_plddt_path <- args[3]
    plot_len_diff_path <- args[4]
}

clu_annot = read.csv(file=clu_annot_path, header=TRUE, sep="\t")
clu_annot[clu_annot == -1] <- NA

rep_data <- clu_annot[clu_annot$annotation_struct == clu_annot$Mb, ][,c("Type_Clu", "sd_pLDDT", "pLDDT")]

pdf(NULL)
ggplot(rep_data, aes(x=sd_pLDDT, color=Type_Clu, fill=Type_Clu)) + scale_fill_manual(values=my_colors2) + geom_density(alpha = 0.6, show.legend = TRUE) + scale_color_manual(values=my_colors2) + theme_minimal() +
xlab("sd(pLDDT>70)>10") + ylab("Densit\u00e9") + 
geom_vline(xintercept = c(10), color="gray34", linetype = "dashed") + 
theme(axis.title = element_text(size = 20), legend.title = element_text(size=20), legend.text = element_text(size=18)) +
labs(fill = "Type", color = "Type") 
ggsave(plot_sd_plddt_path, width = 8, height = 6)

pdf(NULL)
ggplot(rep_data, aes(x=pLDDT, color=Type_Clu, fill=Type_Clu)) + scale_fill_manual(values=my_colors2) + geom_density(alpha = 0.6, show.legend = TRUE) + scale_color_manual(values=my_colors2) + theme_minimal() + 
xlab("pLDDT>70") + ylab("Densit\u00e9") + 
theme(axis.title = element_text(size = 20), legend.title = element_text(size=20), legend.text = element_text(size=18)) +
labs(fill = "Type", color = "Type") 
ggsave(plot_plddt_path, width = 8, height = 6)


df_for_len_diff <- clu_annot[clu_annot$annotation_struct != clu_annot$Mb, ][,c("seq_len_difference")]

pdf(NULL)
ggplot(mapping = aes(df_for_len_diff))  + geom_density(alpha = 0.6, color="#9DA0BF", fill="#9DA0BF") + theme_minimal() +
xlab("Difference in length between DArchFolds sequences\nand the longest AFDB sequence in a cluster") + ylab("Densit\u00e9") + 
theme(axis.title = element_text(size = 20), legend.title = element_text(size=20), legend.text = element_text(size=18)) 
ggsave(plot_len_diff_path, width = 8, height = 6)
