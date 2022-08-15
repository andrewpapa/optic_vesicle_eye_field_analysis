#!/bin/bash

tobias_dir=/exports/igmm/eddie/apapanas-XDF/projects/mammalian_eftfs/tobias_binding_analysis
footprint_signal_dir=/exports/igmm/eddie/apapanas-XDF/data/eye_organoids/ATAC-seq/TOBIAS_Footprinting
dist_file=${tobias_dir}/tobias_output_timecourse/bindetect_distances.txt

motif_arr_str=$(head -n 1 ${dist_file})
# echo $motif_arr_str
motif_id_arr=(${motif_arr_str// / })

#motif_id_arr=( Rax_PH0156.1 Rax_2_M00426_2.00 )
#motif_name_arr=( Rax_1 Rax_2 )

len_ids=${#motif_id_arr[@]}
# len_names=${#motif_name_arr[@]}

# echo $len_ids, $len_names 
echo $len_ids
for (( n=1; n<${len_ids}; n++ ))
do

    motif_id=${motif_id_arr[${n}]}
    # motif_name=${motif_name_arr[${n}]}
    motif_name=${motif_id_arr[${n}]}
    echo "$n", $motif_name,  $motif_id

    echo "Plotting footprints: genome-wide peaks, all bound motif occurences"
    ## plot 4: footprints,  genome-wide peaks, all bound motif occurences ##
    motif_file_1=${tobias_dir}/tobias_output_timecourse/${motif_id}/beds/${motif_id}_D3_footprints_bound.bed
    motif_file_2=${tobias_dir}/tobias_output_timecourse/${motif_id}/beds/${motif_id}_D5_GFPplus_footprints_bound.bed
    output_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_bound_genome-wide_d3_d5p.pdf
    output_txt_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_bound_genome-wide_d3_d5p.txt
    
    TOBIAS PlotAggregate --TFBS ${motif_file_1} ${motif_file_2} \
                         --TFBS-labels "d3 bound" "d5 bound" \
                         --signals ${footprint_signal_dir}/D3_corrected.bw ${footprint_signal_dir}/D5_GFPplus_corrected.bw \
                         --signal-labels "d3" "d5plus" \
                         --blacklist ${blacklist_regions} \
                         --output ${output_file} \
                         --output-txt ${output_txt_file} \
                         --flank 100 \
                         --smooth 3 \
                         --share_y both \
                         --plot_boundaries \
                         --signal-on-x

    echo "Plotting footprints: eye-field peaks, all bound motif occurences"
    ## plot 5: footprints,  EF peaks, all bound motif occurences ##
    motif_file_1=${tobias_dir}/tobias_output_timecourse/${motif_id}/beds/${motif_id}_D3_footprints_bound.bed
    motif_file_2=${tobias_dir}/tobias_output_timecourse/${motif_id}/beds/${motif_id}_D5_GFPplus_footprints_bound.bed
    regions_select=${tobias_dir}/peak_set_beds/organoid-EFup_tad-peaks.bed
    output_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_bound_EF-peaks_d3_d5p.pdf
    output_txt_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_bound_EF-peaks_d3_d5p.txt
    
    TOBIAS PlotAggregate --TFBS ${motif_file_1} ${motif_file_2} \
                         --TFBS-labels "d3 bound" "d5 bound" \
                         --signals ${footprint_signal_dir}/D3_corrected.bw ${footprint_signal_dir}/D5_GFPplus_corrected.bw \
                         --signal-labels "d3" "d5plus" \
                         --blacklist ${blacklist_regions} \
                         --regions ${regions_select} \
                         --region-labels "EF-peaks" \
                         --output ${output_file} \
                         --output-txt ${output_txt_file} \
                         --flank 100 \
                         --smooth 4 \
                         --share_y both \
                         --plot_boundaries \
                         --signal-on-x

    echo "Plotting footprints: genome-wide peaks, all motif occurences"
    ## plot 1: footprints,  genome-wide peaks, all motif occurences ##
    motif_file=${tobias_dir}/tobias_output_timecourse/${motif_id}/beds/${motif_id}_all.bed
    output_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_all_genome-wide_d3_d5p.pdf
    output_txt_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_all_genome-wide_d3_d5p.txt
    
    TOBIAS PlotAggregate --TFBS ${motif_file} \
                         --TFBS-labels "all motif occurences" \
                         --signals ${footprint_signal_dir}/D3_corrected.bw ${footprint_signal_dir}/D5_GFPplus_corrected.bw \
                         --signal-labels "d3" "d5plus" \
                         --blacklist ${blacklist_regions} \
                         --output ${output_file} \
                         --output-txt ${output_txt_file} \
                         --flank 100 \
                         --smooth 3 \
                         --share_y both \
                         --plot_boundaries \
                         --signal-on-x

    echo "Plotting footprints: EFup peaks, all motif occurences"
    ## plot 2: footprints,  EF peaks, all motif occurences ##
    motif_file=${tobias_dir}/tobias_output_timecourse/${motif_id}/beds/${motif_id}_all.bed
    regions_select=${tobias_dir}/peak_set_beds/organoid-EFup_tad-peaks.bed
    output_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_all_EF-peaks_d3_d5p.pdf
    output_txt_file=${tobias_dir}/tobias_aggregate_plots/${motif_name}_footprints_all_EF-peaks_d3_d5p.txt
    
    TOBIAS PlotAggregate --TFBS ${motif_file} \
                         --TFBS-labels "all motif occurences" \
                         --signals ${footprint_signal_dir}/D3_corrected.bw ${footprint_signal_dir}/D5_GFPplus_corrected.bw \
                         --signal-labels "d3" "d5plus" \
                         --regions ${regions_select} \
                         --region-labels "EF-peaks" \
                         --blacklist ${blacklist_regions} \
                         --output ${output_file} \
                         --output-txt ${output_txt_file} \
                         --flank 100 \
                         --smooth 4 \
                         --share_y both \
                         --plot_boundaries \
                         --signal-on-x

done
