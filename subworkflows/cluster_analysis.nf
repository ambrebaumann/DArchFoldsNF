include { type_clu } from '../modules/type_clu'

// Definition of the workflow
workflow clusterAnalysis {
    take:
        clu
        id_db

    main:
    // Type the clusters
    type_clu(clu, Channel.fromPath(params.type_clu_script), id_db, params.yourDB)
    seq_clu_analysis = type_clu.out

    emit:
        seq_clu_analysis
}