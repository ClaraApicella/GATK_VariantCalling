#!/bin/bash



project_root="/scratch/tmp/apicella/projects/wormsQC/dmx/Runs_109_cycles/3_gatk_HaplotypeCaller/Merged_clean_runs/16_CalculateGenotypePosteriors"

#{Java_path}: path to the latest version of java
Java_path="/home/a/apicella/software/jdk-17.0.8"


#Set the JAVA_HOME directory
JAVA_HOME="${Java_path}"
export JAVA_HOME="${Java_path}"
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH

#change directory to preject root
cd ${project_root}

gatk --java-options "-Xmx4g" VariantFiltration \
	-V SNP_worm_2024_exome_Pedigree_refined.vcf.gz \
	-R resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta \
	-O SNP_worm_2024_exome_GQ20_Pedigree_refined.vcf.gz \
	-G-filter "GQ < 20.0" -G-filter-name "lowGQ" \
	-G-filter "DP < 10.0" -G-filter-name "lowDP" \
	--set-filtered-genotype-to-no-call 
