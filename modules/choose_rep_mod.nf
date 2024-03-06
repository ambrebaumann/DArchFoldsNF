
process choose_rep_mod {
    /*
    Choose the representative sequence of the cluster
    Inputs :
        - choose_rep_script : python script
        - choose_rep_file : cluster file in the correct format
        - id_db : id file of the first database
        - output_file_name : name of the output file
        - log_file_name : name of the log file
        - path_output : folder of the different output files
    Output :
        - *annot.tsv : tsv file with all the informations 
        - *annot_reduced.tsv : tsv file with the reduced informations
        - *annot_rep_mb.tsv : tsv file with the representative sequence and the members of the cluster
        - *log : log file for pLDDT standard deviation which is higher than a threshold    
    */
    label 'choose_rep_mod'
    publishDir 'results', mode: 'copy'

    input: 
        path choose_rep_script
        path choose_rep_file
        path id_db
        val scale

    output:
        path "${scale}/changeRepClu${scale}/*annot.tsv", emit: choose_rep
        path "${scale}/changeRepClu${scale}/*annot_reduced.tsv", emit: choose_rep_reduced
        path "${scale}/changeRepClu${scale}/*annot_rep_mb.tsv", emit: choose_rep_mb
        path "${scale}/changeRepClu${scale}/*log", emit: choose_rep_log
    
    script:
    """
    mkdir -p "$scale"
    mkdir -p "$scale/changeRepClu$scale"
    python $choose_rep_script $choose_rep_file $id_db ${scale}/changeRepClu${scale}/${scale}_clu_annot.log ${scale}/changeRepClu${scale}/${scale}_clu_annot.tsv
    """
}