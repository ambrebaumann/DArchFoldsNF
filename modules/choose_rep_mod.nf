
process choose_rep_mod {

    label 'choose_rep_mod'
    publishDir 'results/changeRepCluSeq', mode: 'copy'

    input: 
        path choose_rep_script
        path choose_rep_file
        path id_db
        val output_file_name
        val log_file_name

    output:
        path "*"
    
    script:
    """
    python $choose_rep_script $choose_rep_file $id_db $log_file_name $output_file_name
    """
}
