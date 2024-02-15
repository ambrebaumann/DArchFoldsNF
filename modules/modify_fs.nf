
process modify_fs {

    clusterOptions "-N split_files -l ncpus=1 -l mem=200Gb -l walltime=300:00:00 -q bim"

    label 'modify_fs'
    publishDir 'results', mode: 'copy'

    input: 
        path modify_fs_script
        path choose_rep
        path fs_file

    output:
        path "foldseek_corrected.tsv"
    
    script:
    """
    python $modify_fs_script $choose_rep $fs_file foldseek_corrected.tsv
    """
}

