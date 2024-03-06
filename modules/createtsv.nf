
process createtsv {
    /*
    Create the tsv file from the clustered database
    Inputs :
        - db : database in the MMseqs2 format
        - db_clu : clustered database in the MMseqs2 format
    Output :
        - result_clu.tsv : tsv file
    */
    label 'createtsv'
    publishDir 'results/Seq', mode: 'copy'

    input: 
        path db
        path db_clu

    output:
        path "result_seq_clu.tsv", emit: clu
    
    script:
    """
    /MMseqs2/build/bin/mmseqs createtsv db db db_clu result_seq_clu.tsv > createTsv.log
    """
}