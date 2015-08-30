#!/bin/bash -e

# bam_depth_statistics.sh
# Author: Aaron Statham <a.statham@garvan.org.au>
# Version: 1.0.0
# Last modified: 2015-06-22
#
# Uses GNU parallel to run samtools depth simultaneously for each chromosome
# Output is piped to a single awk which creates a per-base depth histogram in an associative array
# This is then post-processed to output a depth report containing
# * Mean coverage
# * Standard deviation of coverage
# * Yield in gigabases
# * Percentage of genome which is >= 5x/10x/15x....100x coverage
# NOTE: To keep reported standard deviation from being anomalously large, coverage is capped at 250x
#       This behaviour is also consistent with Picard WgsMetrics defaults
#
# Output files are "$1.depth.hist" and "$1.depth.stats"
#
# Differences wrt Picard WgsMetrics
# 1) `samtools depth` differs from `picard CollectWgsMetrics`, in that it will count overlapping reads twice, whereas picard marks
# these are EXC_OVERLAP. Typically <1% of bases on HiSeq X, and even less relevant with larger inserts.
# 2) Unlike picard, our PCT_ are actually percentages from 0-100.
#

VERSION=1.1.0
# This value is the number of non-N bases in the genome for b37_decoy as calculated by Picard CollectWgsMetrics
GENOME_SIZE=2864785223

if [[ "$1" == "-v" ]]; then
    echo "$0 version: $VERSION"
    exit 0
elif [[ ! -f "$1" ]]; then
    echo BAM "$1" does not exist!
    exit 1
fi

# Create the depth histogram
samtools idxstats "$1" | cut -f1 | grep -v ^[*] | \
parallel --gnu "samtools depth -q 20 -Q 20 -r {} $1 | cut -f3" | \
awk -v genome_size=$GENOME_SIZE '{
    cov[$1]+=1
} END {
    # Calculate REAL number of 0s (as samtools depth generally skips these)
    for (c in cov) {
        if (c != 0) {
            bases_covered += cov[c]
        }
    }
    cov[0] = genome_size-bases_covered
    for (c in cov) {
        print c"\t"cov[c]
    }
}' | \
sort -k1,1n > "$1.depth.hist"

# Calculate depth statistics from histogram
cat "$1.depth.hist" | awk -v genome_size=$GENOME_SIZE '{
    if ($1>250) $1=250
    mean += int($1)*int($2)
    stdev += int($1)^2*int($2)
    for (i=5; i<=100; i+=5) {
        if ($1>=i) {
            min_cov[i] += $2
        }
    }
} END {
    printf("MEAN_COVERAGE: %.5f\n", mean/genome_size)
    printf("SD_COVERAGE: %.5f\n", sqrt((stdev-(mean^2/genome_size))/(genome_size-1)))
    printf("YIELD_GB: %.5f\n", mean/1000000000)
    for (i=5; i<=100; i+=5) {
        printf("PCT_%d: %.3f\n", i, min_cov[i]/genome_size*100)
    }
}' > "$1.depth.stats"
