// Import the different processes
include { createDB } from '../modules/createDB'
include { cluster } from '../modules/cluster'
include { createtsv } from '../modules/createtsv'

//Definition of the subworkflow createClusters
workflow createClusters {
    main:
    // Create the database in the MMseqs2 format from fasta files
    createDB(Channel.fromPath(params.fasta_file_your_db).collect(), Channel.fromPath(params.fasta_file_afdb).collect())
    db = createDB.out.db

    // Cluster the database
    cluster(db, params.coverage, params.identity, params.covMode)
    db_clu = cluster.out.db_clu

    // Create the tsv file from the clustered database
    createtsv(db, db_clu)
    clu = createtsv.out.clu

    emit:
        db
        db_clu
        clu
}
