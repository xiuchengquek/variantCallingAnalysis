import os 

samples_vcf = [x for x in os.listdir('data/vcf/')]



rule target:
    input: expand("data/intersected/{samples}.tsv", samples=samples_vcf),  "data/references/gencode.v17.annotation.doctored.exon.gtf", expand("data/oncotator/{samples}.out", samples=samples_vcf)

rule build_reference_exon:
    input : "data/references/gencode.v17.annotation.doctored.gtf"
    output : "data/references/gencode.v17.annotation.doctored.exon.gtf"
    shell : "awk ' $3 ~ \"exon\" {{ print $0 }} ' {input} | sed -e 's/^chr//' > {output}"




rule bed2vcf:
    input:  "data/vcf/{samples}"
    output: "data/bed/{samples}.bed"
    shell: "vcf2bed < {input} > {output}"

rule intersect_expression:
    input:  "data/bed/{samples}.bed"
    output : "data/intersected/{samples}.tsv"
    params : exon="data/references/gencode.v17.annotation.doctored.exon.gtf"
    shell : "/share/ClusterShare/software/contrib/gi/bedtools/2.22.0/intersectBed -wa -wb -a {input} -b {params.exon} > {output}"

rule run_oncotator:
    input: "data/vcf/{samples}"
    output: "data/oncotator/{samples}.out"
    params: dbdir="/share/Temp/xiuque/oncotator/oncotator_v1_ds_Jan262014/"
    shell: "source /share/Temp/xiuque/oncotator/bin/bin/activate && oncotator -v --db-dir {params.dbdir} -i VCF {input} {output} hg19" 


