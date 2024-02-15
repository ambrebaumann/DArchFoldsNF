// Import the different subworkflows
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
    ////////////////SEQUENCES/////////////////
    //////////////////////////////////////////
    seq = "Seq"

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
    analyseCluSeq(clu, id_db, seq)
    seq_clu_analysis = analyseCluSeq.out.clu_analysis

    //////////////////////////////////////////
    // Choose the representative of each cluster of sequences
    chooseRepSeq(seq_clu_analysis, id_db, len_db, seq)
    // Need 
    seq_choose_rep_mb = chooseRepSeq.out.choose_rep_mb
    // Don't need
    seq_choose_rep_file = chooseRepSeq.out.choose_rep_file
    seq_choose_rep = chooseRepSeq.out.choose_rep
    seq_choose_rep_log = chooseRepSeq.out.choose_rep_log
    seq_choose_rep_reduced = chooseRepSeq.out.choose_rep_reduced
    
    //////////////////////////////////////////
    ////////////////STRUCTURES////////////////
    //////////////////////////////////////////
    struct = "Struct"

    //////////////////////////////////////////
    // Clustering of the structures with the foldseek file
    structClustering(seq_choose_rep_mb)
    // Need
    clu_struct = structClustering.out.clu_struct
    // Don't need
    clu_one_line = structClustering.out.clu_one_line
    
    //////////////////////////////////////////
    // Analysis of the structural clusters
    analyseCluStruct(clu_struct, id_db, struct)
    struct_clu_analysis = analyseCluStruct.out.clu_analysis

    //////////////////////////////////////////
    // Choose the representative of each structural cluster
    chooseRepStruct(struct_clu_analysis, id_db, len_db, struct)
    // Need 
    // Don't need
    struct_choose_rep_mb = chooseRepStruct.out.choose_rep_mb
    struct_choose_rep_file = chooseRepStruct.out.choose_rep_file
    struct_choose_rep = chooseRepStruct.out.choose_rep
    struct_choose_rep_log = chooseRepStruct.out.choose_rep_log
    struct_choose_rep_reduced = chooseRepStruct.out.choose_rep_reduced
}
    