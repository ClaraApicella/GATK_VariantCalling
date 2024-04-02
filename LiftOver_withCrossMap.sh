#!/bin/bash

#Lift over coordinates from one genome build to another with CrossMap
#https://crossmap.readthedocs.io/en/latest/#
#https://www.biostars.org/p/252938/ 

#Path to the CrossMap software
CrossMap="/home/a/apicella/miniconda3/bin/CrossMap"

#Perform Liftover to new genome build
#Specify the style of chromosome IDs with --chromid: "a" =as-is , "l" = long style (e.g. "chr1"), "s"= short style (1,2,3...)
${CrossMap} vcf --chromid l \
		./hg19ToHg38.over.chain.gz \
		Worm_genotypes85_rsIDs_GRCh37_20240218.vcf \
		hg38_ens110.fa \
		Worm_genotypes85_rsIDs_GRCh38_20240218.vcf

#Generate a new ped file family with plink
plink --vcf Worm_genotypes85_rsIDs_GRCh38_20240218.vcf --make-bed --out Worm_genotypes85_rsIDs_GRCh38_20240218
