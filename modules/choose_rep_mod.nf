
process choose_rep_mod {

    label 'choose_rep_mod'
    publishDir 'results', mode: 'copy'

    input: 
        path choose_rep_script
        path choose_rep_file
        path id_db
        val output_file_name
        val log_file_name
        val path_output

    output:
        path "${path_output}/*annot.tsv"
        path "${path_output}/*annot_reduced.tsv"
        path "${path_output}/*annot_rep_mb.tsv"
        path "${path_output}/*log"
    
    script:
    """
    mkdir -p "$path_output"
    python $choose_rep_script $choose_rep_file $id_db $path_output/$log_file_name $path_output/$output_file_name
    """
}
