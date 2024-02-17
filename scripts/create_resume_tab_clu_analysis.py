import pandas as pd 
import numpy as np
import sys

id_file = sys.argv[1]
clu_analysis_path = sys.argv[2]
nameDB = sys.argv[3]
output_file = sys.argv[4]

def txt_to_set(path_txt) :
    """
    Converts a text file to a set.

    Args:
    - path_txt (str): The path to the text file.

    Returns:
    - A set containing the elements of the text file.
    """
    
    with open(path_txt, "r") as txt:
        tmp = [line.strip() for line in txt]
    set1 = {x for x in tmp if x != ''}
    return set1


def create_resume_df(clu_analysis_path, id_set, nameDB) :
    """
    Creates a dataframe which resumes the clu analysis.

    Args:
    - clu_analysis_path (str): The path to the cluster analysis file.
    - id_set (set): A set containing the members of the database.
    - nameDB (str): The name of the database.

    Returns:
    - A dataframe
    """

    clu = pd.read_csv(clu_analysis_path, sep='\t', header=0)

    clu['Is_DF'] = clu.apply(lambda row: True  
                                    if row['Member'] in id_set 
                                    else False, axis=1) 
    
    grouped = clu.groupby('Case').agg(
    nb_clu=('Representative', 'nunique'),
    nb_myDB=('Is_DF', lambda x: (x == True).sum()),
    nb_AFDB=('Is_DF', lambda x: (x == False).sum())
    )

    total_nb_myDB = grouped[f'nb_{nameDB}'].sum()
    total_nb_AFDB = grouped['nb_AFDB'].sum()

    grouped.loc['total'] = [grouped['nb_clu'].sum(), total_nb_myDB, total_nb_AFDB]
    grouped.reset_index(inplace=True)

    return grouped


def main() :
    id_set = txt_to_set(id_file)

    resume_df = create_resume_df(clu_analysis_path, id_set, nameDB)
    resume_df.to_csv(output_file, sep='\t', index=False)

if __name__ == "__main__":
    main()