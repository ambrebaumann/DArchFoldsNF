
process type_clu {
    /*
    Type the clusters
    Inputs :
        - clu : tsv file
        - type_clu_script : script to type the clusters
        - id_first_db : id file of the first database
        - nameDB : name of the first database
    Output :
        - tsv file with the type of the clusters
    */

    label 'type_clu'
    publishDir 'results', mode: 'copy'

    input: 
        path clu
        path type_clu_script
        path id_first_db
        val nameDB


    output:
        path "*.tsv"
    
    script:
    """
    python $type_clu_script $clu $id_first_db $nameDB all_clu_type_size_nb.tsv
    """
}

