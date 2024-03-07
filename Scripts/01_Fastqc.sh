#!/bin/bash

module load fastqc/0.11.9
module load multiqc/1.12


start_time=$(date +"%Y-%m-%d %H:%M:%S")

# Define the source and destination directories, use full paths, samples are in sub-directories indicating populations e.g Agger
source_directory="~/fastq_new"
destination_directory="~/fastqc"


# List of population sub-directory names
directories=("Agger" "Alzenbach" "Brool" "Eipbach" "Ferndorfbach" "Hanfbach" "K_Nister" "Lauterbach" "Littfe" "Naafbach" "Nister" "Sieg" "Wiehl" "Wisserbach")

# Loop through each directory
for directory_name in "${directories[@]}"; do
    source_path="${source_directory}/${directory_name}"
    destination_path="${destination_directory}/${directory_name}"

    # Create the destination directory for results if it doesn't exist
    mkdir -p "$destination_path"

    cd ${source_path}

    # Loop through files in the source directory and perform your analysis
    for i in *_2.fq.gz; do
    sample=$(echo ${i} | sed "s/_2\.fq\.gz//")

        # Perform your fastqc analysis on the file and store the results
        fastqc "${source_path}/${sample}_1.fq.gz" "${source_path}/${sample}_2.fq.gz" --outdir="${destination_path}"

        echo "finished ${sample}"
    done
done

echo "Fastqc Analysis and output completed."

#Run multiqc on each population output directories

multiqc "${destination_path}"

end_time=$(date +"%Y-%m-%d %H:%M:%S")

total_runtime=$(($(date -d "$end_time" +%s) - $(date -d "$start_time" +%s))

echo "multi qc analysis and output completed at $end_time (Total Runtime: ${total_runtime} seconds)"


