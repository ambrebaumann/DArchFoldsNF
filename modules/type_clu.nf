
process type_clu {

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

