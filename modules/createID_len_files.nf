
process createID_len_files {
    /*
    Create the id file and the length file from the fasta files
    Inputs :
        - fasta_file : fasta file
        - nameDB : name of the database
    Outputs :  
        - nameDB_id.txt : txt file with the id of each sequence
        - nameDB_len.tsv : tsv file with the id and the length of each sequence
    */

    label 'createID_len_files'
    publishDir 'data/my_db', mode: 'copy'

    input: 
        path fasta_file
        val nameDB

    output:
        path "*.txt"
        path "*.tsv"
    
    script:
    """
    #!/usr/bin/env python
    from Bio import SeqIO
    
    with open("${nameDB}"+"_id.txt", "w") as id_file:
        with open("${nameDB}"+"_len.tsv", "w") as len_file:
            for seq_record in SeqIO.parse("${fasta_file}", "fasta"):
                id_file.write(f"{str(seq_record.id)}\\n")
                len_file.write(f"{str(seq_record.id)}\\t{len(str(seq_record.seq))}\\n")
    
    """
}