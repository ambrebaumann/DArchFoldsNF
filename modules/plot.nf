
process plot {
    /*
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
    Rscript $analysis_plot $choose_rep $scale/changeRepClu$scale/sd_plddt_${scale}.jpg $scale/changeRepClu$scale/plddt_${scale}.jpg ${scale}/changeRepClu${scale}/len_diff_${scale}.jpg
    """
}


