#!/bin/bash

### common files
mm10_genome=/exports/igmm/eddie/apapanas-XDF/projects/utils/primary_assemblies/GRCm38.primary_assembly.genome.fa
peak_coords=/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/processed_data/ATACseq-locations.tsv

### corrected atac signal files (bigwigs) 
#day_id=D0
#day_id=D1
#day_id=D2
#day_id=D3
#day_id=D5_GFPminus
day_id=D5_GFPplus
sample_corrected_bw=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/data/atac_all_reads/tobias_output/${day_id}_corrected.bw

output_dir=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/data/atac_all_reads/tobias_output
output_file=${output_dir}/${day_id}_footprints.bw

### run TOBIAS ATACorrect
TOBIAS FootprintScores --signal ${sample_corrected_bw} \
                       --regions ${peak_coords} \
                       --output ${output_file} \
                       --cores 8
