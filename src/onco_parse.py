#!/usr/bin/env python

import os 
import argparse

import yaml

file_list = []



class TsvFilterMixin:
    def read_tsv(self, file):
        self.file = file
        with open(self.file) as f:
            for line in f:

        


class OncoFieldsFilter:
    def __init__(self, yaml):
        with open(yaml) as f:
            configuration  =yaml.load(f)
    

    
    




def read_and_parse(filename, fields_filter):
    with open(filename) as f:
        for line in f:
            fields = line.strip().split('\t')
             
        






if __name__ == '__main__' : 
    parser = argparse.ArgumentParser()
    parser.add_argument("d", type=str , help="number of directory where vcf files are stored")
    parser.add_argument("f", type=str , help="filter configuration file")
    args = parser.parse_args()
    yaml_file = args.f
    






    



