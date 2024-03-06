// Import the different processes
include { align } from '../modules/align'
include { align_output_cov_id } from '../modules/align_output_cov_id'
include { align_output_pos } from '../modules/align_output_pos'

//Definition of the subworkflow Alignment
workflow alignment {
    take:
        db
        db_clu

    main:
    // Align if the user wants to have more outputs about the clusters
    // If the users wants to have outputs for the coverage, the identity and the position
    if (params.doAlignForCovId == true && params.doAlignForPos == true){
        align(db, db_clu)
        align_output_cov_id(db, align.out.db_align) // Output for the coverage and identity
        align_output_pos(db, align.out.db_align) // Output for the position (qstart, qend, tstart, tend)
    }else{
        // If the user wants to have outputs for the coverage and the identity
        if (params.doAlignForCovId == true){
            align(db, db_clu)
            align_output_cov_id(db, align.out.db_align)
        }else{
            // If the user wants to have outputs for the position (qstart, qend, tstart, tend)
            if (params.doAlignForPos == true){
                align_output_pos(db, align.out.db_align)
            }
        } 
    }
}

