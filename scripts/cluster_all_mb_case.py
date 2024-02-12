import csv
import sys

output_clu = sys.argv[1]
your_seq_id_file = sys.argv[2]
name_DB = sys.argv[3]
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


def new_mmseqs2_file(output_clu_mmseqs, your_seq_ids_set, output_file, nameDB) :
    """
    Creates a new tsv files for the clusters obtained with mmseqs2. 
    For each cluster, a case is attributed (your_db_only, afdb_only, mixed).
    
    Args:
    - output_clu_mmseqs (str): The path to the mmseqs2 output file.
    - your_seq_ids_set (set): The set of your DB sequence IDs.
    - output_file (str): The path to the new output file.
    
    Returns:
    - A tsv file containing the clusters with a case attribution, a cluster size and the number of members from your DB.
    """

    with open(output_file, "w") as new_output_file : 
        new_output_file.write(f"Representative\tMember\tCase\tClu_Size\tNb_{nameDB}\n")
        with open(output_clu_mmseqs) as mmseq_file:
            reader = csv.reader(mmseq_file, delimiter='\t')
            data = []
            for row in reader: # Read the file
                if row[0] == row[1] : # Beginning of a new cluster
                    clu = data.copy() # Store the complete cluster in a list
                    data = []
                    data.append(row) # Store the data in a list
                    rep = row[0] # Store the representative

                    if clu != [] : # If the cluster is not empty
                        clu_size = len(clu) # Cluster size
                        mb_afdb = 0 # AFDB members
                        mb_your_db = 0 # Your DB members

                        perc_afdb = -1 # Percentage of AFDB members
                        perc_your_db = -1 # Percentage of your DB members

                        for members in clu :
                            if members[1] in your_seq_ids_set : # Check the type of members
                                mb_your_db += 1
                            else :
                                mb_afdb += 1

                        perc_your_db = (mb_your_db/clu_size)
                        perc_afdb = (mb_afdb/clu_size) 

                        # Case attribution
                        if perc_your_db == 1.0 :
                            case=f"{nameDB}_only"
                        elif perc_afdb == 1.0 :
                            case="afdb_only"
                        else :
                            case="mixed"

                        # Members 
                        for members in clu :
                            new_output_file.write(members[0] + "\t" + members[1] + "\t" + str(case) + "\t" + str(clu_size) + "\t" + str(mb_your_db) + "\n")
  
                elif row[0] == rep : # Continue to read the file until the end of the cluster
                    data.append(row) # Store the members in a list

            # Last cluster
            clu = data.copy()
            #print(clu)
            clu_size = len(clu) # Cluster size
            mb_afdb = 0 # AFDB members
            mb_your_db = 0 # Your DB members

            perc_afdb = -1 # Percentage of AFDB members
            perc_your_db = -1 # Percentage of your DB members

            for members in clu :
                if members[1] in your_seq_ids_set : # Check the type of members
                    mb_your_db += 1
                else :
                    mb_afdb += 1

            perc_your_db = (mb_your_db/clu_size)
            perc_afdb = (mb_afdb/clu_size) 

            # Case attribution
            if perc_your_db == 1.0 :
                case=f"{nameDB}_only"
            elif perc_afdb == 1.0 :
                case="afdb_only"
            else :
                case="mixed"

            # Members 
            for members in clu :
                new_output_file.write(members[0] + "\t" + members[1] + "\t" + str(case) + "\t" + str(clu_size) + "\t" + str(mb_your_db) + "\n")


def main() :
    your_seq_id_set = txt_to_set(your_seq_id_file)
    new_mmseqs2_file(output_clu, your_seq_id_set, output_file, name_DB)

if __name__ == "__main__":
    main()

