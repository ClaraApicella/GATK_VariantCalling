#!/bin/bash

#load config file
	#{project_root}: directory where the folders of input and ouput files are
		#input files are the files that have already gone through the preprocessing steps and are deduped.
		#different runs (read groups) of the same samples have been merged in one file per sample
	#{REF_file}: path to the fasta file of the reference genome. In the same folder we need the index .fa.fai file to be present
		#with the same prefix
	#{Java_path}: path to the latest version of java

	#${interval_list}: path to the Picard-style .interval_list file specifying the coordinates of the target regions

. ./14_VariantRecalibrator.conf

#Set the JAVA_HOME directory
JAVA_HOME="${Java_path}"
export JAVA_HOME="${Java_path}"
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH

#change directory to preject root
cd ${project_root}


#record start time
mkdir -p documentation/run_time
date > documentation/run_time/14_VariantRecalibrator_run.time


#####Run GATK tool VariantRecalibrator

gatk --java-options "-Xms4G -Xmx4G -XX:ParallelGCThreads=2" VariantRecalibrator \
	-tranche 100.0  -tranche 99.9 \
  	-tranche 99.5 -tranche 99.0 \
	-R resources_broad_hg38_v0_Homo_sapiens_assembly38.fasta \
	-V SPLIT_snps_renamed_worm_2024_86samples_WES.vcf.gz \
	--resource:hapmap,known=false,training=true,truth=true,prior=15.0 resources_broad_hg38_v0_hapmap_3.3.hg38.vcf.gz \
	--resource:omni,known=false,training=true,truth=true,prior=12.0 resources_broad_hg38_v0_1000G_omni2.5.hg38.vcf.gz \
	--resource:1000G,known=false,training=true,truth=false,prior=10.0 1000G_phase1.snps.high_confidence.hg38.vcf.gz \
	--resource:dbsnp,known=true,training=false,truth=false,prior=2.0 resources_broad_hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf \
	-an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
	-mode SNP \
	-O SNP_worm_2024_exome.recal \
	--tranches-file SNP_worm_2024_exome.tranches \
	--rscript-file SNP_worm_2024_exome.plots.R

# record end time
date >> documentation/run_time/14_VariantRecalibrator_run.time

#done
