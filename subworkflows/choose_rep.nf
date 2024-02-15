include { file_for_choose_rep } from '../modules/file_for_choose_rep'
include { choose_rep_mod } from '../modules/choose_rep_mod'

// Definition of the workflow
workflow chooseRep {
    take:
        seq_clu_analysis
        id_db
        len_db
        name_choose_rep_file
        output_choose_rep_file_name
        log_file_name
        path_output

    main:
    // Create the input files for the choose_rep script
    file_for_choose_rep(seq_clu_analysis, Channel.fromPath(params.file_choose_rep_script), Channel.fromPath(params.len_file_afdb), Channel.fromPath(params.plddt_file_afdb), len_db, params.yourDB, name_choose_rep_file)
    choose_rep_file = file_for_choose_rep.out

    // Choose the representative of each cluster
    choose_rep_mod(Channel.fromPath(params.choose_rep_script), choose_rep_file, id_db, output_choose_rep_file_name, log_file_name, path_output)
    (choose_rep, choose_rep_reduced, choose_rep_mb, choose_rep_log) = choose_rep_mod.out

    emit:
        choose_rep_file
        choose_rep
        choose_rep_log
        choose_rep_reduced
        choose_rep_mb
}

