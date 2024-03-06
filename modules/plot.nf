
process plot {
    /*
    Create the plots of the pLDDT, the standard deviation of the pLDDT 
    and the length difference between each sequences of your db and the 
    longest sequence of the cluster.
    Inputs :
        - analysis_plot : script to create the plots
        - choose_rep : tsv file with the representative of each cluster
        - scale : scale of the analysis
    Output :
        - sd_plddt : plot of the standard deviation of the pLDDT
        - plddt : plot of the pLDDT
        - len_diff : plot of the length difference
    */
    label 'plot'
    publishDir 'results', mode: 'copy'

    input: 
        path analysis_plot
        path choose_rep
        val scale

    output:
        path "${scale}/changeRepClu${scale}/sd_plddt_${scale}.jpg"
        path "${scale}/changeRepClu${scale}/plddt_${scale}.jpg"
        path "${scale}/changeRepClu${scale}/len_diff_${scale}.jpg"
    
    script:
    """
    mkdir -p "$scale"
    mkdir -p "$scale/changeRepClu$scale"
    Rscript $analysis_plot $choose_rep ${scale}/changeRepClu${scale}/sd_plddt_${scale}.jpg ${scale}/changeRepClu${scale}/plddt_${scale}.jpg ${scale}/changeRepClu${scale}/len_diff_${scale}.jpg
    """
}


