#!/exports/igmm/eddie/apapanas-XDF/bin/miniconda3/bin/python

### import libraries/modules/functions ###

import numpy as np
import pandas as pd

from os import listdir
from os.path import isfile, join

import glob
import gc

### set directories/filenames ###

# data directory (contains bed file for peak coordinates)
data_dir = '/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/tobias_binding_analysis/tobias_output_timecourse'

## directory for individual motif results (.xlsx files) from Tobias
motif_dir = data_dir

## consensus peaks coordinates filename
peak_coordinates_file = '/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/processed_data/ATACseq-locations.tsv'


### load consensus peak coordinates into a dataframe         ###
## add a 'peak-id' (helps to construct feature matrix later) ##

print('PROCESS: loading peak coordinates')
peak_coord_header = ['chrom','chromStart','chromEnd']
peak_coord_df = pd.read_csv(peak_coordinates_file,names=peak_coord_header,sep='\t')
peak_coord_df['id'] = 'peak-'+peak_coord_df.index.astype(str)

npeaks = peak_coord_df.shape[0]

print('Number of peaks:', npeaks)
print(peak_coord_df.head())


### create list of motif files ###
print('PROCESS: creating list of motif files')

motif_files = glob.glob(data_dir+'/*/*.txt')
print('Number of motif files:',len(motif_files))


### create a 'master' dataframe containing results from all motif files       ###
### this reads each .txt file as a dataframe and appends it to the master df ###

tobias_footprint_df = pd.read_csv(motif_files[0], sep='\t')

for file in motif_files[1:]:
    
    tobias_footprint_df = tobias_footprint_df.append(pd.read_csv(file, sep='\t'),
                                                     ignore_index=True)


### new (speeds up feature matrix creation) ###
tmp_peak_coords = peak_coord_df['chrom']+'-'+peak_coord_df['chromStart'].astype(str)+'-'+peak_coord_df['chromEnd'].astype(str)
tmp_peak_coords = tmp_peak_coords.values
tmp_peak_coords

peak_coords_dict = {item: idx for idx, item in enumerate(tmp_peak_coords)}

tmp_binding_coords = tobias_footprint_df['peak_chr']+ '-' + tobias_footprint_df['peak_start'].astype(str) +'-'+tobias_footprint_df['peak_end'].astype(str)
tmp_binding_coords = tmp_binding_coords.values
tmp_binding_coords

peak_coord_indices = [peak_coords_dict.get(item) for item in tmp_binding_coords]

tobias_footprint_df['peak-id'] = peak_coord_df['id'].iloc[peak_coord_indices].values
### new (speeds up feature matrix creation) ###
print(tobias_footprint_df.head())




### function to create final dataframes per day ###
def create_feature_matrix_from_tobias_results(tobias_df, day_string, peak_coord_df):
    """
    Function to turn tobias footprint dataframe into a feature matrix (npeaks x nmotifs)
    
    Inputs:
    -- tobias_df: dataframe of merged tobias BINDetect results (all motifs)
    -- day_string: which footprint results to create feature matrix for, e.g. 'Day2_footprints_score'
    -- peak_coord_df: dataframe containing peak coordinates of consensus peaks
    
    Note: this function will only work if the column names in both input dataframes match those
          used in the code below ... if these change, the code will have to be adapted.
    """
    print()
    print('Creating feature matrix for:', day_string)
    
    ## 1. if multiple motifs found in a peak, group these, taking maximum ##
    print('1. grouping scores (if > 1 motif score in a peak)')
    #tobias_day_scores_df = tobias_df.groupby(['peak_chr','peak_start','peak_end','TFBS_name']).agg({day_string: ['sum']})
    tobias_day_scores_df = tobias_df.groupby(['peak_chr','peak_start','peak_end','TFBS_name','peak-id']).agg({day_string: ['sum']})
    tobias_day_scores_df.columns = [day_string]

    tobias_day_scores_df = tobias_day_scores_df.reset_index()
    print(tobias_day_scores_df.shape)

    del tobias_df
    gc.collect()
    
    # 2. unpack dataframe to a df resembling the feature matrix (peaks x motifs) we want
    print('2. first step of feature matrix')
    
    keep_cols = ['peak-id','TFBS_name',day_string]
    tmp_score_df = tobias_day_scores_df[keep_cols].pivot_table(index='peak-id',columns='TFBS_name',fill_value=0)

    del tobias_day_scores_df
    gc.collect()

    tmp_score_df = tmp_score_df.reset_index()
    tmp_score_df = tmp_score_df.rename(columns={"Index":'peak-id'})
    tmp_score_df.columns = tmp_score_df.columns.droplevel()
    tmp_score_df = tmp_score_df.rename(columns={'':'peak-id'})

    # 3. here we fill in the missing rows (peaks where no motifs were found)
    
    print('3. finalizing feature matrix')
    npeaks = peak_coord_df.shape[0]
    score_df =  pd.DataFrame(np.arange(npeaks)).rename(columns={0:'peak-id'})
    score_df['peak-id'] = 'peak-'+score_df['peak-id'].astype(str)
    score_df = pd.merge(score_df,tmp_score_df,on=['peak-id'],how='left')
    score_df = score_df.fillna(0)
    
    print('Done!')
    
    return score_df



#day_string  = 'D3_footprints_score'
#day_string2 = 'D3_footprint_scores'
day_string  = 'D5_GFPplus_footprints_score'
day_string2 = 'D5_GFPplus_footprint_scores'
#
tobias_day5minus_scores_df = create_feature_matrix_from_tobias_results(tobias_footprint_df, day_string, peak_coord_df)
tobias_day5minus_scores_df.to_csv(data_dir + '/tobias_timecourse_'+day_string2+'.csv',sep=',')
print(tobias_day5minus_scores_df.head())
