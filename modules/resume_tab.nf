
process resume_tab {
    /*
    Type the clusters
    Inputs :
        - clu : tsv file
        - type_clu_script : script to type the clusters
        - id_db : id file of the first database
        - nameDB : name of your database
    Output :
        - tsv file with the type of the clusters
    */

    label 'resume_tab'
    publishDir 'results', mode: 'copy'

    input: 
        path clu_analysis
        path create_resume_tab_clu_analysis
        path id_db
        val nameDB
        val scale

    output:
        path "${scale}/*.tsv"
    
    script:
    """
    mkdir -p "$scale"
    python $create_resume_tab_clu_analysis $id_db $clu_analysis $nameDB $scale/all_${scale}_clu_resume.tsv
    """
}