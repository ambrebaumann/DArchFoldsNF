import sys
import csv
import polars as pl

# Paths to the files
path_mmseqs = sys.argv[1]
path_foldseek = sys.argv[2]
path_output_file = sys.argv[3]

mmseqs = (
    pl.read_csv(path_mmseqs, separator="\t", has_header=False)
)
mb_set = set(mmseqs.select(pl.col("column_2")).to_series().to_list())

with open(path_output_file, "w") as f:
    with open(path_foldseek) as fs:
        reader = csv.reader(fs, delimiter='\t')
        data = []
        for row in reader: # Read the file
            if row[0] not in mb_set : 
                if row[0] == row[1]:
                    rep_to_delete = row[0]
                    flag = True           
                
                elif row[1] in mb_set :
                    if flag : 
                        new_rep = row[1]
                        flag = False
                    f.write(f"{new_rep}\t{row[1]}\n")
            
            elif row[1] in mb_set :
                f.write(f"{row[0]}\t{row[1]}\n")

                