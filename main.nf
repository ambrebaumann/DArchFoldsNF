// Import the different workflows
include { darchfolds } from './workflows/darchfolds'

def helpMessage() {
    log.info """

        ----------
        DArchFolds
        ----------

        DArchFolds is a workflow that allows to cluster your proteins database with the AlphaFold database using MMseqs2 and to type and analyse the clusters. 

        Usage : 
        The typical command for running the workflow is as follows:
        ???

        Parameters :
        - coverage\t\tCoverage parameter for the clustering (default 0.8)
        - identity\t\tIdentity parameter for the clustering (default 0.4)
        - covMode\t\tCoverage mode parameter for the clustering (see MMseqs2 documentation - https://github.com/soedinglab/mmseqs2/wiki) (default 2)
        - yourDB\t\tName of your database (default yourDB)
        - doAlignForCovId\tIf you want to have outputs for the coverage and the identity (default false)
        - doAlignForPos\t\tIf you want to have outputs for the position (qstart, qend, tstart, tend) (default false)
        - help\t\t\tDisplay this message (default false)
    """
}

def parametersSelected() {
    log.info """\
        ----------
        DArchFolds
        ----------

        Parameters Selected :
        - coverage\t\t${params.coverage} 
        - identity\t\t${params.identity}
        - covMode\t\t${params.covMode} 
        - yourDB\t\t${params.yourDB} 
        - doAlignForCovId\t${params.doAlignForCovId} 
        - doAlignForPos\t\t${params.doAlignForPos}
    """
}

// Definition of the workflow
workflow {
    darchfolds()
}

// Show help message
if (params.help == true) {
    helpMessage()
    exit 0
}
else {
    parametersSelected()
}


