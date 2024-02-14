include { file_for_choose_rep } from '../modules/file_for_choose_rep'

// Definition of the workflow
workflow chooseRep {
    take:
        seq_clu_analysis
        len_db

    main:
    // Create the input files for the choose_rep script
    file_for_choose_rep(seq_clu_analysis, Channel.fromPath(params.file_choose_rep_script), Channel.fromPath(params.len_file_afdb), Channel.fromPath(params.plddt_file_afdb), len_db, params.yourDB)
    choose_rep_file = file_for_choose_rep.out

    emit:
        choose_rep_file

}