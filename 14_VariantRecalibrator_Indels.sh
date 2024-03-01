#!/bin/bash

#load config file
	#{project_root}: directory where the folders of input and ouput files are
		#input files are the files that have already gone through the preprocessing steps and are deduped.
		#different runs (read groups) of the same samples have been merged in one file per sample
	#{REF_file}: path to the fasta file of the reference genome. In the same folder we need the index .fa.fai file to be present
		#with the same prefix
	#{Java_path}: path to the latest version of java

	#${interval_list}: path to the Picard-style .interval_list file specifying the coordinates of the target regions

. ./14_VariantRecalibrator_Indels.conf

#Set the JAVA_HOME directory
JAVA_HOME="${Java_path}"
export JAVA_HOME="${Java_path}"
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH

#change directory to preject root
cd ${project_root}


#record start time
mkdir -p documentation/run_time
date > documentation/run_time/14_VariantRecalibrator_Indels_run.time


#####Run GATK tool VariantRecalibrator

gatk --java-options "-Xms4G -Xmx4G -XX:ParallelGCThreads=2" VariantRecalibrator \
	--max-gaussians "4" \
	-R resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta \
	-V SPLIT_indels_renamed_worm_2024_86samples_WES.vcf.gz \
	--resource:mills,known=false,training=true,truth=true,prior=12.0 resources_broad_hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz \
	--resource:dbsnp,known=true,training=false,truth=false,prior=2.0 resources_broad_hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf \
	-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
	-mode INDEL \
	-O INDELS_worm_2024_exome.recal \
	--tranches-file INDELS_worm_2024_exome.tranches \
	--rscript-file INDELS_worm_2024_exome.plots.R





# record end time
date >> documentation/run_time/14_VariantRecalibrator_Indels_run.time

#done
