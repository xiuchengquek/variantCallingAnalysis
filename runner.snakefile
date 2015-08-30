

import os

samples = [x for x in os.listdir('data/bam') if x.endswith('.bam') ]
bedtools = '/share/ClusterShare/software/contrib/gi/bedtools/2.22.0/bedtools'


rule target:
    input : expand('./data/stats/{samples}.gcoverage', samples=samples)


rule run_genome_coverage:
    input : ./data/bam/{samples}
    output : ./data/stats/{samples}.gcoverage
    params : cores="2"
    shell : '$bedtools  genomecov -ibam $input -bga -split -max 250'


