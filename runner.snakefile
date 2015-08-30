

import os

samples = [x for x in os.listdir('data/bam') if x.endswith('.bam') ] 

[print('src/bam_depth_statistics.sh %s' % os.path.join('data/bam', x)) for x in samples]
