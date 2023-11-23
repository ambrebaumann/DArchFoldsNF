
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
    publishDir 'results', mode: 'copy'

    input: 
        path db
        path db_clu

    output:
        path "result_clu.tsv"
    
    script:
    """
    /MMseqs2/build/bin/mmseqs createtsv db db db_clu result_clu.tsv
    """
}