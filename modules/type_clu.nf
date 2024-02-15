
process type_clu {
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

    label 'type_clu'
    publishDir 'results', mode: 'copy'

    input: 
        path clu
        path type_clu_script
        path id_db
        val nameDB
        val scale

    output:
        path "${scale}/changeRepClu${scale}/*.tsv"
    
    script:
    """
    mkdir -p "$scale"
    mkdir -p "$scale/changeRepClu$scale"
    python $type_clu_script $clu $id_db $nameDB $scale/changeRepClu$scale/all_${scale}_clu_type_size_nb.tsv
    """
}

