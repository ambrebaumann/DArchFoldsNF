include { createID_len_files } from '../modules/createID_len_files'

// Definition of the workflow
workflow preprocessing {
    main:
    // Create the id file and the length file from the fasta files
    createID_len_files(Channel.fromPath(params.fasta_file_first_db).collect(), params.yourDB)
    (id_first_db, len_first_db) = createID_len_files.out

    emit:
        id_first_db
        len_first_db
}