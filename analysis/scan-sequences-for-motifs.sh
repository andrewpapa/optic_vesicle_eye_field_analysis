#!/bin/bash

# --------------------------- #
# -- set paths / filenames -- #
# --------------------------- #


fimo_exec=/home/andrew/bin/meme/bin/fimo
motif_file=/home/andrew/biology/xdf/projects/utils/tfbs_motifs/JASPAR2020_Mus-musculus_memes-extended.txt
motif_str='JASPAR2020ext'

data_dir=/home/andrew/biology/xdf/rotation3/mammalian_eftfs/optic_vesicle_eye_field_analysis/data
prefix=organoids-ATACseq


peak_coords=${data_dir}/ATACseq-peak_locations.bed
peak_coords2=${data_dir}/ATACseq-peak_locations2.bed

echo "INFO: formating bed file"

# remove "chr" from chromosome name -- this step may not be required depending on the 
# primary genome assembly used
cp $peak_coords $peak_coords2
sed -i 's/chr//g' $peak_coords2

# -------------------------- #
# -- produce a fasta file -- #
# -------------------------- #

echo "INFO: extracting sequences from primary assembly"

# Note: mm10 primary assembly downloaded from: ftp://ftp.ensembl.org/pub/release-100/fasta/mus_musculus/dna/
genome_assembly=/home/andrew/biology/xdf/projects/utils/primary_assemblies/Mus_musculus.GRCm38.dna.primary_assembly.fa

# 1. Generate sequences for each genomic locus
# -- run bedtools: use genomic loctions in bed format to generate a fasta file (sequence corresponding to 
# -- locus from primary sequence assembly)
tmp_fasta_file=${data_dir}/ATACseq-peaks-tmp.fa
fasta_file=${data_dir}/ATACseq-peaks.fa
~/bin/bedtools2/bin/bedtools getfasta -fo ${tmp_fasta_file} -fi $genome_assembly -bed $peak_coords2

# 2. add "chr" back to peak identifier
sed -i 's/>/>chr/g' ${tmp_fasta_file}

# 3. generate reasonable names for each fasta sequence
awk 'BEGIN { cntr = 0 } />/ { cntr++ ; print $0"-peak-"cntr } !/>/ { print $0 }' ${tmp_fasta_file} > ${fasta_file}

# 4. remove tmp file
rm ${tmp_fasta_file}


# -------------------------------------- #
# -- create dataset specific bg model -- #
# -------------------------------------- #

echo "INFO: creating background model for FIMO"

bg_exec=/home/andrew/bin/meme/libexec/meme-5.1.1/fasta-get-markov

bg_file=${data_dir}/${prefix}-sequences-model.bg
markov_order=4

# generate background file
$bg_exec -dna -m $markov_order $fasta_file $bg_file

# -------------------------------------------------------- #
# -- run FIMO to find occurences of motifs in sequences -- #
# -------------------------------------------------------- #

echo "INFO: running fimo to find motif instances in sequences"

$fimo_exec --bfile $bg_file --text --max-strand --thresh 1e-4 $motif_file $fasta_file > ${data_dir}/${prefix}-${motif_str}-fimo-raw.txt

# -- clean up -- #
rm ${fasta_file}
