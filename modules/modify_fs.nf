
process modify_fs {
    /*
    Modify the foldseek clustering of the AFDB to clusterize your database based on structure.
    Inputs :
        - modify_fs_script : python script
        - choose_rep : file created by the choose_rep_mod subwf
        - fs_file : foldseek clustering of the AFDB
    Output :
        - foldseek_corrected.tsv : file with the corrected foldseek clustering
    */
    clusterOptions "-N modify_fs -l ncpus=1 -l mem=200Gb -l walltime=300:00:00 -q bim"

    label 'modify_fs'
    publishDir 'data/afdb', mode: 'copy'

    input: 
        path modify_fs_script
        path choose_rep
        path fs_file

    output:
        path "foldseek_corrected.tsv", emit: fs_corrected
    
    script:
    """
    python $modify_fs_script $choose_rep $fs_file foldseek_corrected.tsv
    """
}

