#!/bin/bash

#BCFtools
#Script to split multiallelics sties into buallelic and separate INDELS and SNPs into two different output .vcf files

#norm = normalise
#-m multiallelic sites = -split / +merge back together, 
#-both to separate both snps and indels into different records 

bcftools norm -m-both renamed_worm_2024_86samples_WES.vcf.gz --output SPLIT_renamed_worm_2024_86samples_WES.vcf.gz 

#use bcftools view to subset the dataset - specify which variants to extract with -v option (snps/indels)
#redirect output to file
bcftools view -v indels SPLIT_renamed_worm_2024_86samples_WES.vcf.gz  --output SPLIT_indels_renamed_worm_2024_86samples_WES.vcf
bcftools view -v snps SPLIT_renamed_worm_2024_86samples_WES.vcf.gz  --output SPLIT_snps_renamed_worm_2024_86samples_WES.vcf

