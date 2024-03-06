// Import the different processes
include { file_for_choose_rep } from '../modules/file_for_choose_rep'
include { choose_rep_mod } from '../modules/choose_rep_mod'
include { plot } from '../modules/plot'

// Definition of the subworkflow chooseRep
workflow chooseRep {
    take:
        seq_clu_analysis
        id_db
        len_db
        scale

    main:
    // Create the input files for the choose_rep script
    file_for_choose_rep(seq_clu_analysis, Channel.fromPath(params.file_choose_rep_script), Channel.fromPath(params.len_file_afdb), Channel.fromPath(params.plddt_file_afdb), len_db, params.yourDB, scale)
    choose_rep_file = file_for_choose_rep.out.file_fr_choose_rep

    // Choose the representative of each cluster
    choose_rep_mod(Channel.fromPath(params.choose_rep_script), choose_rep_file, id_db, scale)
    choose_rep = choose_rep_mod.out.choose_rep
    choose_rep_reduced = choose_rep_mod.out.choose_rep_reduced
    choose_rep_mb = choose_rep_mod.out.choose_rep_mb
    choose_rep_log = choose_rep_mod.out.choose_rep_log

    // Plot
    plot(Channel.fromPath(params.analysis_plot), choose_rep, scale)

    emit:
        choose_rep_file
        choose_rep
        choose_rep_log
        choose_rep_reduced
        choose_rep_mb
}

