
process file_for_choose_rep {

    label 'file_for_choose_rep'
    publishDir 'results/changeRepCluSeq', mode: 'copy'

    input: 
        path seq_clu_analysis
        path file_choose_rep_script
        path afdb_len
        path afdb_plddt
        path len_db
        val nameDB
        val name_choose_rep_file

    output:
        path "*.tsv"
    
    script:
    """
    python $file_choose_rep_script $seq_clu_analysis $afdb_len $afdb_plddt $len_db $nameDB $name_choose_rep_file
    """
}