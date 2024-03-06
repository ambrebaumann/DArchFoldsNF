
process createDB {
    /*
    Create the database in the MMseqs2 format from fasta files
    Inputs :
        - fasta_file : fasta file
    Output :
        - db : database in the MMseqs2 format
    */
    label 'createDB'
    publishDir 'data/database_mmseqs/db', mode: 'copy'

    input: 
        path fasta_file_your_db
        path fasta_file_afdb

    output:
        path "db*", emit: db
    
    script:
    """
    /MMseqs2/build/bin/mmseqs createdb ${fasta_file_your_db.join(' ')} ${fasta_file_afdb.join(' ')} db > createDB.log
    """
}