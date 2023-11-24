
process createID_files {

    label 'createID_files'
    publishDir 'results', mode: 'copy'

    input: 
        path fasta_file
        val nameDB

    output:
        path "*.txt"
    
    script:
    """
    #!/usr/bin/env python3
    from Bio import SeqIO
    
    with open("${nameDB}"+"_id.txt", "w") as f:
        for seq_record in SeqIO.parse("${fasta_file}", "fasta"):
            f.write(f"{str(seq_record.id)}\\n")
    """
}