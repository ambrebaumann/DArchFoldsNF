include { preprocessing } from '../subworkflows/preprocessing'
include { usingMMseqs2 } from '../subworkflows/using_mmseqs2'
include { clusterAnalysis } from '../subworkflows/cluster_analysis'

// Definition of the workflow
workflow darchfolds {
    
    // Create the id file and the length file from the fasta files
    preprocessing()
    id_first_db = preprocessing.out.id_first_db
    len_first_db = preprocessing.out.len_first_db

    // From the creation of the MMseqs2 database to the creation of the tsv file containing the clusters
    usingMMseqs2()
    clu = usingMMseqs2.out.clu

    // Type the clusters
    clusterAnalysis(clu, id_first_db)
    clu_analysis = clusterAnalysis.out.clu_analysis
}
