
process create_all_cc {
    /*
    Use the foldseek clustering of the AFDB to clusterize your database based on structure
    Inputs :
        - create_all_cc_script : python script
        - clu_annot : tsv file created bu the choose_rep subwf with the representative sequence and the members of the cluster
        - foldseek_clu : folseek clustering of the AFDB
    Output :
        - clu_one_line.tsv : file with one structural cluster per line
        - clu_struct.tsv : tsv file with two columns, the first one is the 
        representative sequence and the second one is the members of the cluster
    */

    clusterOptions "-N split_files -l ncpus=1 -l mem=200Gb -l walltime=300:00:00 -q bim"

    label 'create_all_cc'
    publishDir 'results/Struct', mode: 'copy'

    input: 
        path create_all_cc_script
        path clu_annot
        path foldseek_clu

    output:
        path "clu_one_line.tsv", emit: clu_one_line
        path "clu_struct.tsv", emit: clu_struct
    
    script:
    """
    python $create_all_cc_script $clu_annot $foldseek_clu clu_one_line.tsv clu_struct.tsv
    """
}

