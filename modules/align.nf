
process align {
    /*
    Align the database
    Inputs :
        - db : database in the MMseqs2 format
        - db_clu : clustered database in the MMseqs2 format
    Output :
        - db_align : aligned database in the MMseqs2 format
    */
    label 'align'
    publishDir 'data/database_mmseqs/align', mode: 'copy'

    input: 
        path db
        path db_clu

    output:
        path "db_align*", emit: db_align
    
    script:
    """
    /MMseqs2/build/bin/mmseqs align db db db_clu db_align -a -v 2 > align.log
    """
}


