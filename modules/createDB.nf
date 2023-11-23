
process createDB {
    /*
    Create the database in the MMseqs2 format from fasta files
    Inputs :
        - fasta_file : fasta file
    Output :
        - db : database in the MMseqs2 format
    */
    label 'createDB'
    publishDir 'database_mmseqs/createDB', mode: 'copy'

    input: 
        path fasta_file

    output:
        path "db*"
    
    script:
    """
    /MMseqs2/build/bin/mmseqs createdb ${fasta_file.join(' ')} db
    """
}