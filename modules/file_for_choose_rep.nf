
process file_for_choose_rep {
    /*
    Create the file for the choose_rep script in the correct format
    Inputs :
        - seq_clu_analysis : file created by the cluster_analysis subwf
        - file_choose_rep_script : python script
        - afdb_len : file with the length of the sequences of the AFDB
        - afdb_plddt : file with the pLDDT of the sequences of the AFDB
        - len_db : file with the length of the sequences of your database
        - nameDB : name of your database
        - name_choose_rep_file : name of the output file
    Output :
        - *tsv : file in the correct format for the choose_rep script
    */
    label 'file_for_choose_rep'
    publishDir 'results', mode: 'copy'

    input: 
        path seq_clu_analysis
        path file_choose_rep_script
        path afdb_len
        path afdb_plddt
        path len_db
        val nameDB
        val scale

    output:
        path "${scale}/*.tsv"
    
    script:
    """
    mkdir -p "$scale"
    python $file_choose_rep_script $seq_clu_analysis $afdb_len $afdb_plddt $len_db $nameDB $scale/all_${scale}_clu_plddt_len.tsv
    """
}
