#!/bin/bash

File="INDEL_worm_2024_exome_Clean.vcf"

bcftools sort  $File -o  $File

bcftools view $File -Oz -o ${File}.gz
bcftools index -t ${File}.gz


File="SNP_worm_2024_exome_Clean.vcf"

bcftools sort  $File -o  $File

bcftools view $File -Oz -o ${File}.gz
bcftools index -t ${File}.gz

