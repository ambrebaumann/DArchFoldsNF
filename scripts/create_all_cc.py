import sys
import networkx as nx
import polars as pl
import pyarrow as pa

path_clu_seq_files = sys.argv[1]
path_clu_struct_files = sys.argv[2]
clu_one_line_out = sys.argv[3]
clu_tsv_output = sys.argv[4]

def return_connected_components(df):
    """
    Returns the connected components of a graph.
    
    Args:
    - df (pl.DataFrame): The dataframe containing the edges of the graph.

    Returns:
    - A list of sets containing the connected components of the graph.
    """
    graph = nx.Graph()
    graph.add_edges_from(df.to_pandas().itertuples(index=False))
    clusters = list(nx.connected_components(graph))
    return clusters

def col_to_set(df, col):
    """
    Converts a column of a dataframe to a set.
    
    Args:
    - df (pl.DataFrame): The dataframe containing the column.
    - col (str): The column to convert.

    Returns:
    - A set containing the elements of the column.
    """

    return set(df.select(pl.col(col)).to_series().to_list())

def main():
    clu_struct = (pl.read_csv(path_clu_struct_files, separator="\t", has_header=False)) 
    clu_seq = (pl.read_csv(path_clu_seq_files, separator="\t", has_header=True))

    #mb_set = col_to_set(clu_seq, "column_2") # The set of all members of the sequence clusters
    rep_set = col_to_set(clu_seq, "annotation_struct") # The set of all representatives of the sequence clusters

    clu_seq = clu_seq.rename({'annotation_struct': 'column_1'})
    clu_seq = clu_seq.rename({'Mb': 'column_2'})

    clu_struct_filter = clu_struct.filter(pl.col("column_2").is_in(rep_set)) 
    # Filter the structure clusters to keep only the row where the member is a representative in the sequence clusters

    big_df = clu_seq.vstack(clu_struct_filter)
    # Concatenate the sequence clusters and the structure clusters filtered

    connected = return_connected_components(big_df) # Get the connected components

    # Write the connected components in two files: 
    #      * one with one cluster per line
    #      * one with one member per line
    with open(clu_one_line_out, 'w') as one_line :
        with open(clu_tsv_output, 'w') as tsv :
            for i, component in enumerate(connected):
                if i != 0:
                    one_line.write('\n')
                one_line.write(','.join(component))
                first_element = next(iter(component))
                for id in component:
                    tsv.write(f"{first_element}\t{id}\n")

if __name__ == "__main__":
    main()