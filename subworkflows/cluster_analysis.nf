// Import the different processes
include { type_clu } from '../modules/type_clu'

// Definition of the subworkflow clusterAnalysis
workflow clusterAnalysis {
    take:
        clu
        id_db
        scale

    main:
    // Type the clusters
    type_clu(clu, Channel.fromPath(params.type_clu_script), id_db, params.yourDB, scale)
    clu_analysis = type_clu.out

    emit:
        clu_analysis
}