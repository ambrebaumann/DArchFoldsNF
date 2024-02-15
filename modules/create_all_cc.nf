
process create_all_cc {

    clusterOptions "-N split_files -l ncpus=1 -l mem=200Gb -l walltime=300:00:00 -q bim"

    label 'create_all_cc'
    publishDir 'results', mode: 'copy'

    input: 
        path create_all_cc_script
        path mmseqs_clu
        path foldseek_clu

    output:
        path "clu_one_line.tsv"
        path "clu_struct.tsv"
    
    script:
    """
    python $create_all_cc_script $mmseqs_clu $foldseek_clu clu_one_line.tsv clu_struct.tsv
    """
}

