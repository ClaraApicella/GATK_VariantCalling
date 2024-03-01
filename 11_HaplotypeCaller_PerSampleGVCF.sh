#!/bin/bash

#Script to do variant calling per Sample (Haplotypes will be built in a following step with all samples) GATK guidelines
	#This is achieved calling HaplotypeCaller in GVCF mode. Allowing to split the calling in batches and speeding up the process
	#After joint Haplotype calling will be done on all samples 
#https://gatk.broadinstitute.org/hc/en-us/articles/360035890531
#https://gatk.broadinstitute.org/hc/en-us/articles/360035890411-Calling-variants-on-cohorts-of-samples-using-the-HaplotypeCaller-in-GVCF-mode
#https://gatk.broadinstitute.org/hc/en-us/articles/360035890431-The-logic-of-joint-calling-for-germline-short-variants

#The settings for java have been taken from https://hpc.nih.gov/training/gatk_tutorial/haplotype-caller.html
	#performance did not improve further than 2 threads and 20GB - These need to be set as requirement for the slurm.job


#load config file
	#{project_root}: directory where the folders of input and ouput files are
		#input files are the files that have already gone through the preprocessing steps and are deduped.
		#different runs (read groups) of the same samples have been merged in one file per sample
	#{REF_file}: path to the fasta file of the reference genome. In the same folder we need the index .fa.fai file to be present
		#with the same prefix
	#{Java_path}: path to the latest version of java

	#${interval_list}: path to the Picard-style .interval_list file specifying the coordinates of the target regions

. ./11_HaplotypeCaller_PerSampleGVCF.conf

#Set the JAVA_HOME directory
JAVA_HOME="${Java_path}"
export JAVA_HOME="${Java_path}"
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib:$LD_LIBRARY_PATH

#change directory to preject root
cd ${project_root}


#record start time
date > documentation/run_time/11_HaplotypeCaller_PerSampleGVCF_run.time


#Define input folder where the fastq files are stored
in_path="${project_root}/BQSR_corrected"

#Define list of files to be analised
File_list=$(ls ${in_path}/*bam)

#Define output directory
mkdir -p ${project_root}/PerSample_GVCF
out_path="${project_root}/PerSample_GVCF"

#Define log path
mkdir -p ${project_root}/documentation/HaplotypeCaller_PerSampleGVCF.logs
log_path="${project_root}/documentation/HaplotypeCaller_PerSampleGVCF.logs"


#####Run GATK tools over the files

	for file in ${File_list}; do

	#Define current time
	now=$(date +'%T')

	#Define the Sample name
	Sample_Name=$(basename ${file} _BQSR.bam)

	#Define log_file for comments to be saved to
	log_file="${log_path}/PerSampleGVCF_${Sample_Name}.log"

	echo "Script to calculate apply base correction" > ${log_file}
	echo "$now Started HaplotypeCaller_PerSampleGVCF on ${file}" >> ${log_file}


	#The flag Xmx specifies the maximum memory allocation pool for a Java Virtual Machine (JVM), while Xms specifies the initial memory allocation pool.
	#https://stackoverflow.com/questions/14763079/what-are-the-xms-and-xmx-parameters-when-starting-jvm
	#https://hpc.nih.gov/training/gatk_tutorial/bqsr.html
	
	#!Pedigree information: this can be supplied with additional paramters, however is only used during the annotation of 
		#variants with the inbreeding coefficient - we can do this afterwards, on all samples 
		#https://github.com/broadinstitute/gatk-docs/blob/master/gatk3-faqs/Which_tools_use_pedigree_information%3F.md 

	#Since our is a whole exome analysis we can restrict this only to the target regions by specifying the --intervals argument
	#The preferred format is to supply a Picard-style .interval_list (that we have previously created to calculate HsMetrics).
	#https://gatk.broadinstitute.org/hc/en-us/articles/360035531852

	gatk --java-options "-Xms20G -Xmx20G -XX:ParallelGCThreads=4" HaplotypeCaller \
		-I ${file} \
		--R ${REF_file} \
		--intervals ${interval_list}\
		--interval-padding '100' \
		-O ${out_path}/${Sample_Name}_g.vcf.gz\
		-ERC GVCF\
		>> ${log_file}


	done


# record end time
date >> documentation/run_time/11_HaplotypeCaller_PerSampleGVCF_run.time

#done
