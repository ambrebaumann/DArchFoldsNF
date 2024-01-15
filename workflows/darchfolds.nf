include { preprocessing } from '../subworkflows/preprocessing'
include { createClusters } from '../subworkflows/create_clusters'
include { alignment } from '../subworkflows/alignment'
include { clusterAnalysis } from '../subworkflows/cluster_analysis'

// Definition of the workflow
workflow darchfolds {
    // Create the id file and the length file from the fasta files
    preprocessing()
    id_first_db = preprocessing.out.id_first_db
    len_first_db = preprocessing.out.len_first_db

    // From the creation of the MMseqs2 database to the creation of the tsv file containing the clusters
    createClusters()
    db = createClusters.out.db
    db_clu = createClusters.out.db_clu
    clu = createClusters.out.clu

    // Align if the user wants to have more outputs about the clusters 
    // Like the coverage, the identity and the position of the alignment 
    alignment(db, db_clu)

    // Type the clusters
    clusterAnalysis(clu, id_first_db)
    clu_analysis = clusterAnalysis.out.clu_analysis
}
