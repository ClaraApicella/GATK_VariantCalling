#!/bin/bash

#Convert ped family files to vcf
#https://www.biostars.org/p/252938/ 


plink --bfile Worm_genotypes85_rsIDs  -keep-allele-order \
	--recode vcf --out Worm_genotypes85_rsIDs_GRCh37_20240218
