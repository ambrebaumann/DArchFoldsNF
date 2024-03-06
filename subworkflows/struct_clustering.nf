// Import the different processes
include { modify_fs } from '../modules/modify_fs'
include { create_all_cc } from '../modules/create_all_cc'

// Definition of the subworkflow structClustering
workflow structClustering {
    take:
        choose_rep

    main:
    // Create a new foldseek file with the same ids as the mmseqs file
    modify_fs(Channel.fromPath(params.modify_fs_script), choose_rep, Channel.fromPath(params.fs_file))
    new_fs = modify_fs.out.fs_corrected

    // Create the one line and the struct file
    create_all_cc(Channel.fromPath(params.clustering_struct_script), choose_rep, new_fs)
    clu_one_line = create_all_cc.out.clu_one_line
    clu_struct = create_all_cc.out.clu_struct

    emit:
        clu_one_line
        clu_struct
}
