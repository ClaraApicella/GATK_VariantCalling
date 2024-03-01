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

gatk --java-options "-Xmx4g" CalculateGenotypePosteriors \
	-V INDEL_worm_2024_exome_recalibrated_99.4.vcf.gz \
	-ped 20240216_Worm_WES_86_FamilyIDs.ped \
	--supporting-callsets gonl.SV.r5_GRCh38_20240218.vcf.gz \
	-O INDEL_worm_2024_exome_Pedigree_refined.vcf.gz 
