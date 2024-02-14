
process file_for_choose_rep {

    label 'file_for_choose_rep'
    publishDir 'results', mode: 'copy'

    input: 
        path seq_clu_analysis
        path file_choose_rep_script
        path afdb_len
        path afdb_plddt
        path len_db
        val nameDB

    output:
        path "*.tsv"
    
    script:
    """
    python $file_choose_rep_script $seq_clu_analysis $afdb_len $afdb_plddt $len_db $nameDB all_seq_clu_plddt_len.tsv
    """
}