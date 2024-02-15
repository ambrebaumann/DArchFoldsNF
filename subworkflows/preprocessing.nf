// Import the different processes
include { createID_len_files } from '../modules/createID_len_files'

// Definition of the subworkflow preprocessing
workflow preprocessing {
    main:
    // Create the id file and the length file from the fasta files
    createID_len_files(Channel.fromPath(params.fasta_file_your_db).collect(), params.yourDB)
    (id_db, len_db) = createID_len_files.out

    emit:
        id_db
        len_db
}