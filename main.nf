// Import the different processes
include { createID_len_files } from './modules/createID_len_files'
include { createDB } from './modules/createDB'
include { cluster } from './modules/cluster'
include { createtsv } from './modules/createtsv'
include { align } from './modules/align'
include { align_output_cov_id } from './modules/align_output_cov_id'
include { align_output_pos } from './modules/align_output_pos'
include { type_clu } from './modules/type_clu'

// Definition of the workflow
workflow {
    // Create the id file and the length file from the fasta files
    createID_len_files(Channel.fromPath(params.fasta_file_first_db).collect(), params.nameFirstDB)
    (id_first_db, len_first_db) = createID_len_files.out

    // Create the database in the MMseqs2 format from fasta files
    createDB(Channel.fromPath(params.fasta_file_first_db).collect(), Channel.fromPath(params.fasta_file_second_db).collect())
    db = createDB.out

    // Cluster the database
    cluster(db, params.coverage, params.identity, params.covMode)
    db_clu = cluster.out

    // Create the tsv file from the clustered database
    createtsv(db, db_clu)
    clu = createtsv.out

    // Align if the user wants to have more outputs about the clusters
    // If the users wants to have outputs for the coverage, the identity and the position
    if (params.doAlignForCovId == true && params.doAlignForPos == true){
        align(db, db_clu)
        align_output_cov_id(db, align.out) // Output for the coverage and identity
        align_output_pos(db, align.out) // Output for the position (qstart, qend, tstart, tend)
    }else{
        // If the user wants to have outputs for the coverage and the identity
        if (params.doAlignForCovId == true){
            align(db, db_clu)
            align_output_cov_id(db, align.out)
        }else{
            // If the user wants to have outputs for the position (qstart, qend, tstart, tend)
            if (params.doAlignForPos == true){
                align_output_pos(db, align.out)
            }
        } 
    }

    // Type the clusters
    type_clu(clu, Channel.fromPath(params.type_clu_script), id_first_db, params.nameFirstDB)
}


