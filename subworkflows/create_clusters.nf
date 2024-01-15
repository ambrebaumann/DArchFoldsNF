// Import the different processes
include { createDB } from '../modules/createDB'
include { cluster } from '../modules/cluster'
include { createtsv } from '../modules/createtsv'

//Definition of the subworkflow createClusters
workflow createClusters {
    main:
    // Create the database in the MMseqs2 format from fasta files
    createDB(Channel.fromPath(params.fasta_file_first_db).collect(), Channel.fromPath(params.fasta_file_second_db).collect())
    db = createDB.out

    // Cluster the database
    cluster(db, params.coverage, params.identity, params.covMode)
    db_clu = cluster.out

    // Create the tsv file from the clustered database
    createtsv(db, db_clu)
    clu = createtsv.out

    emit:
        db
        db_clu
        clu
}
