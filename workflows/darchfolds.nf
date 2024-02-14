include { preprocessing } from '../subworkflows/preprocessing'
include { createClusters } from '../subworkflows/create_clusters'
include { alignment } from '../subworkflows/alignment'
include { clusterAnalysis } from '../subworkflows/cluster_analysis'
include { chooseRep } from '../subworkflows/choose_rep'

// Definition of the workflow
workflow darchfolds {
    // Create the id file and the length file from the fasta files
    preprocessing()
    id_db = preprocessing.out.id_db
    len_db = preprocessing.out.len_db

    // From the creation of the MMseqs2 database to the creation of the tsv file containing the clusters
    createClusters()
    db = createClusters.out.db
    db_clu = createClusters.out.db_clu
    clu = createClusters.out.clu

    // Align if the user wants to have more outputs about the clusters 
    // Like the coverage, the identity and the position of the alignment 
    alignment(db, db_clu)

    // Type the clusters
    clusterAnalysis(clu, id_db)
    seq_clu_analysis = clusterAnalysis.out.seq_clu_analysis

    // Choose the representative of each cluster
    chooseRep(seq_clu_analysis, len_db)
    choose_rep_file = chooseRep.out.choose_rep_file

}
