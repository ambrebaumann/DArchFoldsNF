// Import the different workflows
include { darchfolds } from './workflows/darchfolds'

def helpMessage() {
    log.info """\
        -----------
        DArchFolds
        -----------

        DArchFolds is a workflow that allows to cluster your proteins database with the AlphaFold database using MMseqs2 and to type and analyse the clusters. 

        Usage : 
        The typical command for running the workflow is as follows:
        ???

        Parameters :
        --coverage\tCoverage parameter for the clustering \\
        --identity\tIdentity parameter for the clustering \\
        --covMode\tCoverage mode parameter for the clustering (see MMseqs2 documentation - https://github.com/soedinglab/mmseqs2/wiki) \\
        --yourDB\tName of your database \\
        --doAlignForCovId\tIf you want to have outputs for the coverage and the identity \\
        --doAlignForPos\tIf you want to have outputs for the position (qstart, qend, tstart, tend) \\
        --help\tDisplay this message \\

        Parameters selected :
        --coverage\t${params.coverage} \\
        --identity\t${params.identity} \\
        --covMode\t${params.covMode}\\
        --nameFirstDB\t${params.nameFirstDB}\\
        --doAlignForCovId\t${params.doAlignForCovId}\\
        --doAlignForPos\t${params.doAlignForPos}
    """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

// Definition of the workflow
workflow {
    darchfolds()
}


