include { type_clu } from '../modules/type_clu'

// Definition of the workflow
workflow clusterAnalysis {
    take:
        clu
        id_first_db

    main:
    // Type the clusters
    type_clu(clu, Channel.fromPath(params.type_clu_script), id_first_db, params.yourDB)
    clu_analysis = type_clu.out

    emit:
        clu_analysis
}