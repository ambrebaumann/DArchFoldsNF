
process align_output_cov_id {
    /*
    Create the tsv file with the coverage and the sequence identity of each member of the cluster from the clustered database
    Inputs :
        - db : database in the MMseqs2 format
        - db_align : aligned database in the MMseqs2 format
    Output :
        - align_output_pos.tsv : tsv file
    */
    label 'align_output_cov_id'
    publishDir 'results', mode: 'copy'

    input: 
        path db
        path db_align

    output:
        path "align_cov_id.tsv"
    
    script:
    """
    /MMseqs2/build/bin/mmseqs convertalis db db db_align align_cov_id.tsv --format-output "query,target,fident,qcov,tcov,tlen" --format-mode 4
    """
}