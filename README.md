# Variant Calling Analysis Code Base For Genomic Instability 


## Introduction.

This is the code base analysis involving variant frequency in genomeic instability studies. 

The following analysis are conducted:

1. Coverage by depth analysis
	- Understadning the depth at coverage and coverage of the genome
2. General Summary about the mutations	
	- Finding the number of mutations per base measured
		- Characterised by the different type of mutations	
			- missense / sense mutations
			- deleterious / non deleterious

	- Mutation signature analysis
3. Overlay Expression with mutations
	- Finding the corelation of mutation and expression 




### Step

1. Coverage by depth analysis - This analysis is done to understand the depth at coverage and the coverage of the genome.
   the code used in this analysis is written by aaron statham. The script responsible for running the analysis is called bam_depth_statistics.sh and is found in the folder src
2. Plot Coverage by depth analysis -  This is analysis that construct a line plot highlighting the depth of coverage for each sample using R




