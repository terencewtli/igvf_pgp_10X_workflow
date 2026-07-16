#!/bin/bash
#$ -cwd
#$ -o logs/A01a_subset_peaks_auto.$JOB_ID
#$ -j y
#$ -N A01a_subset_peaks_auto
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/home/t/terencew/project-cluo/igvf/2023_YR2/multiome
cd $PROJDIR

TEMPLATE=/u/project/cluo/terencew/demux_benchmark/template_demux/
CR_BASE=$PROJDIR/mapping/cr_arc/igvf_ref/default/

SAMPLES=$PROJDIR/txt/samples.txt

time for ID in `seq 1 10`;
do
  SAMPLE=$(head -${ID} $SAMPLES | tail -1)
  INDIR=$CR_BASE/$SAMPLE/outs/
  OUTDIR=$PROJDIR/atac/peaks/cr_arc/
  python $TEMPLATE/autosome_peaks.py $INDIR $OUTDIR $SAMPLE
done

