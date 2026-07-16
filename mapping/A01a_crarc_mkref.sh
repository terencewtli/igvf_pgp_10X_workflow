#!/bin/bash
#$ -cwd
#$ -o logs/A01a_crarc_mkref.$JOB_ID
#$ -j y
#$ -N A01a_crarc_mkref
#$ -l h_data=2G,h_rt=12:00:00
#$ -pe shared 20

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/reference/hg38_igvf/
cd $PROJDIR

###  merge subset gtf + header

GTF=$PROJDIR/gencode.v43.cellranger.gtf
HEADER=$PROJDIR/gtf_header.txt

FINAL=$PROJDIR/gencode.v43.cellranger.final.gtf.gz

cat $HEADER $GTF | gzip - > $FINAL

CONFIG=$PROJDIR/scripts/crarc_config.json

CR_ARC=/u/project/cluo/terencew/programs/cellranger-arc-2.0.1/bin/cellranger-arc

time $CR_ARC mkref \
  --config=$CONFIG \
  --nthreads=50

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
