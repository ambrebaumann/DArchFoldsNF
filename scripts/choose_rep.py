import pandas as pd 
import numpy as np
import sys

# Paths to the files
clu_tsv_path = sys.argv[1] # Tsv file created by create_file_for_change_rep.py
id_path = sys.argv[2]  
path_log_file = sys.argv[3]
complete_output_file = sys.argv[4]

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


def calculate_std(series):
    """
    Calculates the standard deviation of a series.

    Args:
    - series (pd.Series): The series to calculate the standard deviation of.

    Returns:
    - The standard deviation of the series.
    """

    filtered_series = series[series != -1]
    if len(filtered_series) > 1:
        return filtered_series.std()
    else:
        return np.nan


def swap_columns(df, col1, col2):
    """
    Swaps the position of two columns in a dataframe.

    Args:
    - df (pd.DataFrame): The dataframe to swap the columns in.
    - col1 (str): The name of the first column.
    - col2 (str): The name of the second column.

    Returns:
    - The dataframe with the columns swapped.
    """
    col_list = list(df.columns)
    x, y = col_list.index(col1), col_list.index(col2)
    col_list[y], col_list[x] = col_list[x], col_list[y]
    df = df[col_list]
    return df


def create_log_file_for_sd_plddt_thr(clu, log_file, threshold) :
    """
    Creates a log file for pLDDT standard deviation which is higher than a threshold.

    Args:
    - clu_file (pd.DataFrame): The cluster file.
    - log_file (str): The path to the log file.
    - threshold (float): The threshold for the standard deviation of the pLDDT.

    Returns:
    - A log file containing the representant, member, pLDDT and standard deviation of the pLDDT 
    for all the clusters with a standard deviation of the pLDDT higher than the threshold.
    """

    with open(log_file, "w") as log :
        log.write(f"# That is a log file with all the sd(pLDDT > 70) > {threshold}\n")
        log.write("# Representant\tMember\tpLDDT\tsd(pLDDT>70)\tSeq_Len\n")

        clu = clu.sort_values(by=['sd_pLDDT', 'Rep'], ascending=[False, False]) # Sort the dataframe by representant and standard deviation of the pLDDT

        for _, row in clu.iterrows():
            if row['sd_pLDDT'] > threshold:
                log.write(f"{row['Rep']}\t{row['Mb']}\t{row['pLDDT']}\t{row['sd_pLDDT']}\t{row['Seq_Len']}\n")


def choose_representant(clu_file, threshold, arch_id) :
    """
    Chooses the new representant of each cluster to annotate each archaea with a structure.

    Args:
    - clu_file (pd.DataFrame): The cluster file.
    - threshold (float): The threshold for the standard deviation of the pLDDT.
    - arch_id (set): The set of the archaea IDs.

    Returns:
    - A dataframe containing the representant, member, type of cluster, pLDDT>70,
    length of the sequence, standard deviation of the pLDDT, AFDB id of the new representant,
    pLDDT of the new representant, the difference of length between the archaea sequences and 
    the AFDB with the longest sequence.
    """

    clu = pd.read_csv(clu_file, sep='\t', header=None) # Read the cluster file
    clu.columns = ["Rep", "Mb", "Type_Clu", "pLDDT", "Seq_Len"] # Set the columns names
    clu = clu.set_index('Mb') # Set the index to the member column

    clu["sd_pLDDT"] = clu.groupby("Rep")["pLDDT"].transform(calculate_std) # Calculate the standard deviation of the pLDDT

    clu['pLDDT'].fillna(-1, inplace=True) # Replace the NaN values by -1

    clu['best_pLDDT'] = clu.groupby('Rep')['pLDDT'].idxmax() # Get the index of the best pLDDT for each representant
    clu['best_pLDDT'].fillna(method='ffill', inplace=True) # Replace the NaN values by the previous value

    clu['AFDB_Len_Seq'] = clu.apply(lambda row: row['Seq_Len'] 
                                    if row.name not in arch_id 
                                    else -1, axis=1) 
    # New column with the length of the sequence of the AFDB and -1 for the archaea

    clu['longer_Seq'] = clu.groupby('Rep')['AFDB_Len_Seq'].idxmax() # Get the index of the AFDB with the longest sequence
    clu['longer_Seq'].fillna(method='ffill', inplace=True) # Replace the NaN values by the previous value

    clu['annotation_struct'] = clu.apply(lambda row: row['best_pLDDT']
                                        if row['sd_pLDDT'] > threshold 
                                        else row['longer_Seq'], axis=1)
    # New column with the index of the new representant

    clu = clu.merge(clu[['pLDDT']], 
                    left_on='annotation_struct', 
                    right_index=True, 
                    suffixes=('', '_annotation_struct'))
    # Merge the pLDDT of the new representant 

    clu['seq_len_difference'] = clu.apply(lambda row: clu.loc[row['annotation_struct'], 'Seq_Len'] - row['Seq_Len'] 
                                        if row.name in arch_id 
                                        else "NA", axis=1)
    # New column with the difference of length between the archaea sequences and the AFDB with the longest sequence
    
    clu = clu.drop(columns=['best_pLDDT', 'longer_Seq', 'AFDB_Len_Seq']) # Drop the columns
    clu.reset_index(inplace=True) # Reset the index
    clu = swap_columns(clu, 'Mb', 'Rep') # Swap the columns

    clu_reduced = clu[['annotation_struct', 'Mb', 'Type_Clu', 'pLDDT_annotation_struct', 'Seq_Len']]  

    clu_rep_mb = clu[['annotation_struct', 'Mb']] # Create a dataframe with the new representant and the member

    return clu, clu_reduced, clu_rep_mb
        

def main() :
    arch_id = txt_to_set(id_path) # Get the set of the archaea IDs
    
    create_the_two_df = choose_representant(clu_tsv_path, 10, arch_id) # Create the three dataframes

    clu = create_the_two_df[0] # Create the big dataframe with all the informations
    clu_reduced = create_the_two_df[1] # Create the reduced dataframe 
    clu_rep_mb = create_the_two_df[2] # Create the dataframe with the new representant and the member

    clu.to_csv(complete_output_file, sep='\t') # Write the dataframe in a tsv file
    clu_reduced.to_csv(complete_output_file.replace(".tsv", "_reduced.tsv"), sep='\t') # Write the reduced dataframe in a tsv file
    clu_rep_mb.to_csv(complete_output_file.replace(".tsv", "_rep_mb.tsv"), sep='\t') # Write the dataframe with the new representant and the member in a tsv file


    create_log_file_for_sd_plddt_thr(clu, path_log_file, 10) # Create the log file


if __name__ == "__main__":
    main()