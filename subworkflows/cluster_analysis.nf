// Import the different processes
include { type_clu } from '../modules/type_clu'
include { resume_tab } from '../modules/resume_tab'

// Definition of the subworkflow clusterAnalysis
workflow clusterAnalysis {
    take:
        clu
        id_db
        scale

    main:
    // Type the clusters
    type_clu(clu, Channel.fromPath(params.type_clu_script), id_db, params.yourDB, scale)
    clu_analysis = type_clu.out.clu_analysis

    // Create the resume table 
    resume_tab(clu_analysis, Channel.fromPath(params.create_resume_tab_clu_analysis), id_db, params.yourDB, scale)
    resume_tab_file = resume_tab.out.clu_resume

    emit:
        clu_analysis
        resume_tab_file
}