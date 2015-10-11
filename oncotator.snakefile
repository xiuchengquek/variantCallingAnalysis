
import os

samples_vcf = [x for x in os.listdir('data/vcf/')]

rule target:
    input: expand("data/oncotator/{samples}.out", samples=samples_vcf) , expand("log/{samples}.log", samples=samples_vcf) 

rule run_oncotator:
    input: "data/vcf/{samples}"
    output: "data/oncotator/{samples}.out", "log/{samples}.log"
    params: dbdir="/share/Temp/xiuque/oncotator/oncotator_v1_ds_Jan262014/"   
    shell: "source /share/Temp/xiuque/oncotator/bin/bin/activate && oncotator -v --db-dir {params.dbdir} -i VCF --log_name {output[1]} {input} {output[0]} hg19"


