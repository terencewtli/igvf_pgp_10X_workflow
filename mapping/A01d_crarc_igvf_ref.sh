#!/bin/bash
#$ -cwd
#$ -o logs/A01d_crarc_igvf_ref.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_crarc_igvf_ref
#$ -l h_data=2G,h_rt=24:00:00
#$ -pe shared 10
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/home/t/terencew/project-cluo/igvf/2023_YR2/multiome
cd $PROJDIR

REF=/u/project/cluo/terencew/reference/hg38_igvf/IGVF_hg38/

# ID=1
ID=$SGE_TASK_ID
LIB=$PROJDIR/csv/cr_arc/multi${ID}.csv

SAMPLES=$PROJDIR/txt/samples.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CR_ARC=/u/project/cluo/terencew/programs/cellranger-arc-2.0.1/bin/cellranger-arc

cd $PROJDIR/mapping/cr_arc/igvf_ref/default

time $CR_ARC count --id $SAMPLE \
  --reference ${REF} --libraries ${LIB} \
  --localcores=50 --localmem=60

echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date `
echo " "
