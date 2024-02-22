
process align_output_pos {
    /*
    Create the tsv file with position of the alignment from the clustered database
    Inputs :
        - db : database in the MMseqs2 format
        - db_align : aligned database in the MMseqs2 format
    Output :
        - align_output_pos.tsv : tsv file
    */
    label 'align_output_pos'
    publishDir 'results/Seq/alignment', mode: 'copy'

    input: 
        path db
        path db_align

    output:
        path "align_output_pos.tsv"
    
    script:
    """
    /MMseqs2/build/bin/mmseqs convertalis db db db_align align_output_pos.tsv --format-output "query,target,qstart,qend,tstart,tend" --format-mode 4 > align_output_pos.log
    """
}