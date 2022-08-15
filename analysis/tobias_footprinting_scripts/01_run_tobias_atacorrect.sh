#!/bin/bash

### common files
peak_coords=/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/processed_data/ATACseq-locations.tsv
mm10_genome=/exports/igmm/eddie/apapanas-XDF/projects/utils/primary_assemblies/GRCm38.primary_assembly.genome.fa
blacklist_regions=/exports/igmm/eddie/apapanas-XDF/projects/utils/blacklist_regions/mm10-blacklist.v2.bed

### sample files
#sample_bam_name=D0.bam
#sample_bam_name=D1.bam
#sample_bam_name=D2.bam
#sample_bam_name=D3.bam
#sample_bam_name=D5_GFPminus.bam
sample_bam_name=D5_GFPplus.bam
sample_bam_file=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/data/atac_all_reads/${sample_bam_name}
output_dir=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/data/atac_all_reads/tobias_output

### run TOBIAS ATACorrect
TOBIAS ATACorrect --bam ${sample_bam_file} \
                  --genome ${mm10_genome} \
                  --peaks ${peak_coords} \
                  --blacklist ${blacklist_regions} \
                  --outdir ${output_dir} \
                  --cores 8
