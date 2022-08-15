#!/bin/bash

peak_coords=/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/processed_data/ATACseq-locations.tsv
mm10_genome=/exports/igmm/eddie/apapanas-XDF/projects/utils/primary_assemblies/GRCm38.primary_assembly.genome.fa
motif_collection=/exports/igmm/eddie/apapanas-XDF/projects/utils/tfbs_motifs/JASPAR2020_Mus-musculus_memes-extended.txt

# run TOBIAS BINDetect (on timecourse), sub-nucleosomal reads
footprint_signal_dir=/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/ATAC-seq/TOBIAS_Footprinting
output_dir=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/tobias_binding_analysis/tobias_output_timecourse
TOBIAS BINDetect --motifs ${motif_collection} \
                 --signals ${footprint_signal_dir}/{D0,D1,D2,D3,D5_GFPplus}_footprints.bw \
                 --genome $mm10_genome \
                 --motif-pvalue 5e-4 \
                 --peaks $peak_coords \
                 --outdir $output_dir \
                 --time-series \
                 --skip-excel \
                 --cores 8


# # run TOBIAS BINDetect (on timecourse), sub-nucleosomal reads, EFup peaks
# footprint_signal_dir=/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/ATAC-seq/TOBIAS_Footprinting
# output_peaks=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/tobias_binding_analysis/peak_set_beds/organoid-EFup_tad-peaks.bed
# output_dir=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/tobias_binding_analysis/tobias_output_timecourse_EFup_tads
# TOBIAS BINDetect --motifs ${motif_collection} \
#                  --signals ${footprint_signal_dir}/{D0,D1,D2,D3,D5_GFPplus}_footprints.bw \
#                  --genome $mm10_genome \
#                  --motif-pvalue 5e-4 \
#                  --peaks $peak_coords \
#                  --outdir $output_dir \
#                  --time-series \
#                  --output-peaks ${output_peaks} \
#                  --skip-excel \
#                  --prefix "bindetect_EFup"
#                  --cores 8
