import csv
import sys

# Paths to the files
clu_tsv_path = sys.argv[1] # Tsv file created by cluster_all_mb_case.py
afdb_len_path = sys.argv[2] # Tsv file containing the length of the AFDB sequences
afdb_plddt_path = sys.argv[3] # Tsv file containing the plddt of the AFDB sequences
db_len_path = sys.argv[4] # Tsv file containing the length of  sequences
name_DB = sys.argv[5] # Name of your DB
output_file = sys.argv[6] 

def tsv_to_dict(tsv_file):
    """
    Reads a tsv file and returns a dictionary with the first column as keys and the second column as values.
    
    Args:
        tsv_file (str): path to tsv file

    Returns:
        dict: dictionary with the first column as keys and the second column as values
    """

    data = {} 
    with open(tsv_file, 'r', newline='') as tsvfile:
        reader = csv.reader(tsvfile, delimiter='\t')  
        for row in reader:
            data[row[0]] = row[1]
    return data

def main() :
    afdb_len = tsv_to_dict(afdb_len_path)
    afdb_plddt = tsv_to_dict(afdb_plddt_path)
    arch_len = tsv_to_dict(db_len_path)

    with open(output_file, 'w') as out_file :
        with open(clu_tsv_path, 'r', newline='') as clu_file : 
            clu_mix = csv.reader(clu_file, delimiter='\t')
            for row in clu_mix :
                if row[1] in afdb_len : 
                    out_file.write(f"{row[0]}\t{row[1]}\t{row[2]}\t{afdb_plddt[row[1]]}\t{afdb_len[row[1]]}\n") 
                elif row[1] in arch_len :
                    out_file.write(f"{row[0]}\t{row[1]}\t{row[2]}\tNA\t{arch_len[row[1]]}\n")

if __name__ == "__main__":
    main()