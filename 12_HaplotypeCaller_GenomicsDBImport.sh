#!/bin/bash

#Script to merge the individual gVCFs with GenomicsDBImport following GATK guidelines
	#https://gatk.broadinstitute.org/hc/en-us/articles/360035890411-Calling-variants-on-cohorts-of-samples-using-the-HaplotypeCaller-in-GVCF-mode 
	#https://gatk.broadinstitute.org/hc/en-us/articles/360036732771-GenomicsDBImport


#The settings for java have been taken from https://hpc.nih.gov/training/gatk_tutorial/genomics-db-import.html
	#performance did not improve further than 2 threads and 2GB - These need to be set as requirement for the slurm.job
	#https://gatk.broadinstitute.org/hc/en-us/articles/360036732771-GenomicsDBImport#--intervals However, the gatk specifies that additional
		#memory is required by the software so the slurm job should request more than what we specify in the script and in their example they use 4.
		#Settings for script: 2 threads, 4 GB. 
		#Settings for slurm job: 4 threads, 10GB 


#load config file
	#{project_root}: directory where the folders of input and ouput files are
		#input files are the files that have already gone through the preprocessing steps and are deduped.
		#different runs (read groups) of the same samples have been merged in one file per sample
	#{REF_file}: path to the fasta file of the reference genome. In the same folder we need the index .fa.fai file to be present
		#with the same prefix
	#{Java_path}: path to the latest version of java

	#${interval_list}: path to the Picard-style .interval_list file specifying the coordinates of the target regions

. ./12_HaplotypeCaller_GenomicsDBImport.conf

#Set the JAVA_HOME directory
JAVA_HOME="${Java_path}"
export JAVA_HOME="${Java_path}"
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH

#change directory to preject root
cd ${project_root}


#record start time
mkdir -p documentation/run_time
date > documentation/run_time/12_HaplotypeCaller_GenomicsDBImport_run.time

#####This GATK tool takes a sample map file with the paths to each file to be processed, so no need to specify in_path, File_list, or doing loops.

	#The flag Xmx specifies the maximum memory allocation pool for a Java Virtual Machine (JVM), while Xms specifies the initial memory allocation pool.
	#https://stackoverflow.com/questions/14763079/what-are-the-xms-and-xmx-parameters-when-starting-jvm
	#https://hpc.nih.gov/training/gatk_tutorial/bqsr.html

	#--genomicsdb-workspace-path: specifies the name of the folder to create where to save the non-human readable output of GenomicDBImport. 
		#This folder can be non-existent or already exist but be empty
	
	#--batch-size helps to speed up the analysis by setting the number of entries that can be opened at once
	
	#--intervals argument: we can use the preferred format is to supply a Picard-style .interval_list (that we have previously created to calculate HsMetrics).
	
	#--sample-name-map: to specify the name of the map file. #The cohort.sample_map file in the format of a tab delimited file with sample1	path-to-file/sample1.vcf.gz
	#For semplicity we will save the sample_map file in the root directory.

	

	gatk --java-options "-Xms4G -Xmx4G -XX:ParallelGCThreads=2" GenomicsDBImport \
		--sample-name-map cohort_map.txt \
		--batch-size '50' \
		--genomicsdb-workspace-path worm_GDBIm_database \
		--intervals ${interval_list}\
		--interval-padding '100' \
		--reader-threads 2 \
		--tmp-dir './tmp' \
		--merge-input-intervals \
		--bypass-feature-reader
 
	 

# record end time
date >> documentation/run_time/12_HaplotypeCaller_GenomicsDBImport_run.time

#done
