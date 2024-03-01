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
date > documentation/run_time/15_ApplyVQSR_Indels_run.time


#####Run GATK tool ApplyVQSR 
#According to the tests they did https://hpc.nih.gov/training/gatk_tutorial/vqsr.html 2GB are enough with additional 6GB minimum to avoid running out of memory

gatk --java-options "-Xms2G -Xmx2G -XX:ParallelGCThreads=2" ApplyVQSR \
	-V SPLIT_indels_renamed_worm_2024_86samples_WES.vcf.gz \
	-mode INDEL \
	--recal-file "INDELS_worm_2024_exome.recal" \
	--tranches-file "INDELS_worm_2024_exome.tranches" \
	--truth-sensitivity-filter-level 99.4 \
	--create-output-variant-index 'true' \
	-O INDEL_worm_2024_exome_recalibrated_99.4.vcf.gz

# record end time
date >> documentation/run_time/15_ApplyVQSR_Indels_run.time

#done
