include { preprocessing                         } from '../subworkflows/preprocessing'
include { createClusters                        } from '../subworkflows/create_clusters'
include { alignment                             } from '../subworkflows/alignment'
include { clusterAnalysis as analyseCluSeq      } from '../subworkflows/cluster_analysis'
include { clusterAnalysis as analyseCluStruct   } from '../subworkflows/cluster_analysis'
include { chooseRep as chooseRepSeq             } from '../subworkflows/choose_rep'
include { chooseRep as chooseRepStruct          } from '../subworkflows/choose_rep'
include { structClustering                      } from '../subworkflows/struct_clustering'

// Definition of the workflow
workflow darchfolds {

    //////////////////////////////////////////
    // Create the id file and the length file from the fasta files
    preprocessing()
    id_db = preprocessing.out.id_db
    len_db = preprocessing.out.len_db

    //////////////////////////////////////////
    // From the creation of the MMseqs2 database to the creation of the tsv file containing the clusters
    createClusters()
    db = createClusters.out.db
    db_clu = createClusters.out.db_clu
    clu = createClusters.out.clu

    //////////////////////////////////////////
    // Align if the user wants to have more outputs about the clusters 
    // Like the coverage, the identity and the position of the alignment 
    alignment(db, db_clu)

    //////////////////////////////////////////
    // Type the clusters
    analyseCluSeq(clu, id_db)
    seq_clu_analysis = analyseCluSeq.out.clu_analysis

    //////////////////////////////////////////
    // Choose the representative of each cluster of sequences
    seq_name_choose_rep_file = "all_seq_clu_plddt_len.tsv"
    seq_output_choose_rep_file_name = "seq_clu_annot.tsv"
    seq_log_file_name = "seq_clu_annot.log"
    chooseRepSeq(seq_clu_analysis, id_db, len_db, seq_name_choose_rep_file, seq_output_choose_rep_file_name, seq_log_file_name, "changeRepCluSeq")
    // Need 
    choose_rep_mb = chooseRepSeq.out.choose_rep_mb
    // Don't need
    choose_rep_file = chooseRepSeq.out.choose_rep_file
    choose_rep = chooseRepSeq.out.choose_rep
    choose_rep_log = chooseRepSeq.out.choose_rep_log
    choose_rep_reduced = chooseRepSeq.out.choose_rep_reduced
    
    //////////////////////////////////////////
    // Clustering of the structures with the foldseek file
    structClustering(choose_rep_mb)
    // Need
    clu_struct = structClustering.out.clu_struct
    // Don't need
    clu_one_line = structClustering.out.clu_one_line
    
    //////////////////////////////////////////
    // Analysis of the structural clusters
    analyseCluStruct(clu_struct, id_db)
    struct_clu_analysis = analyseCluStruct.out.clu_analysis

    //////////////////////////////////////////
    // Choose the representative of each structural cluster
    struct_name_choose_rep_file = "all_struct_clu_plddt_len.tsv"
    struct_output_choose_rep_file_name = "struct_clu_annot.tsv"
    struct_log_file_name = "struct_clu_annot.log"
    chooseRepStruct(struct_clu_analysis, id_db, len_db, struct_name_choose_rep_file, struct_output_choose_rep_file_name, struct_log_file_name, "changeRepCluStruct")
    // Need
    // Don't need

}
    