
process cluster {
    /*
    Cluster the database
    Inputs :
        - db : database in the MMseqs2 format
        - coverage : coverage chosen by the user
        - identity : identity chosen by the user
        - covMode : coverage mode chosen by the user
    Output :
        - db_clu : clustered database in the MMseqs2 format
    */
    label 'cluster'
    publishDir 'data/database_mmseqs/cluster', mode: 'copy'

    input: 
        path db
        val coverage
        val identity
        val covMode

    output:
        path "db_clu*"
    
    script:
    """
    /MMseqs2/build/bin/mmseqs cluster db db_clu tmp -c $coverage --min-seq-id $identity --cov-mode $covMode --cluster-mode 2 --cluster-reassign -v 2
    """
}