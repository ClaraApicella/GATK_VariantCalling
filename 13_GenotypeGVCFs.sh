#!/bin/bash

#Script to Perform joint genotyping and build most likely haplotypes 
	#https://gatk.broadinstitute.org/hc/en-us/articles/360037057852-GenotypeGVCFs 
	#https://gatk.broadinstitute.org/hc/en-us/articles/360035889971

#load config file
	#{project_root}: directory where the folders of input and ouput files are
	

	#{REF_file}: path to the fasta file of the reference genome. In the same folder we need the index .fa.fai file to be present
		#with the same prefix
	#{Java_path}: path to the latest version of java

	#${interval_list}: path to the Picard-style .interval_list file specifying the coordinates of the target regions

. ./13_GenotypeGVCFs.conf

#Set the JAVA_HOME directory
JAVA_HOME="${Java_path}"
export JAVA_HOME="${Java_path}"
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH

#change directory to preject root
cd ${project_root}


#record start time
mkdir -p documentation/run_time
date > documentation/run_time/13_GenotypeGVCFs_run.time

#####	GATK GenotypeGVCFs

	#The flag Xmx specifies the maximum memory allocation pool for a Java Virtual Machine (JVM), while Xms specifies the initial memory allocation pool.
	#https://stackoverflow.com/questions/14763079/what-are-the-xms-and-xmx-parameters-when-starting-jvm
	#https://hpc.nih.gov/training/gatk_tutorial/bqsr.html

	#--intervals argument: we can use the preferred format is to supply a Picard-style .interval_list (that we have previously created to calculate HsMetrics).	

	gatk --java-options "-Xms4G -Xmx4G -XX:ParallelGCThreads=2" GenotypeGVCFs \
		--reference ${REF_file} \
		--variant gendb://worm_GDBIm_database \
		--intervals ${interval_list} \
		--interval-padding '100' \
		--output worm_2024_86samples_WES.vcf.gz \
		--create-output-variant-index 'true' \
		--merge-input-intervals 
	 

# record end time
date >> documentation/run_time/13_GenotypeGVCFs_run.time

#done
