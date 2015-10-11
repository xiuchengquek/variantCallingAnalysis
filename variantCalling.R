
#!/usr/bin/env Rscript



library(ggplot2)
library(SomaticSignatures)
library(VariantAnnotation)
vcf_files = list.files(path='data/vcf', full.names = T)


