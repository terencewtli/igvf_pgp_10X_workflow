#!/bin/bash
#$ -cwd
#$ -o logs/A01b_ambimux_filt01.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_ambimux_filt01
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/home/t/terencew/project-cluo/igvf/2023_YR2/multiome
cd $PROJDIR

TEMPLATE=/u/project/cluo/terencew/demux_benchmark/template_demux/
CR_BASE=$PROJDIR/mapping/cr_arc/igvf_ref/default/

GTF=/u/home/t/terencew/project-cluo/reference/hg38_igvf/IGVF_hg38/genes/genes.gtf.gz
EXCL=/u/project/cluo/terencew/reference/hg38/bed/hg38-blacklist.v2_noheader.bed

SAMPLES=$PROJDIR/txt/samples.txt

# ID=1
ID=${SGE_TASK_ID}
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

DEMUX_DIR=$PROJDIR/demux/regular/

GEX_BAM=$DEMUX_DIR/autosome_bam/gex/${SAMPLE}.reheader.bam
ATAC_BAM=$DEMUX_DIR/autosome_bam/atac/${SAMPLE}.reheader.bam
BARCODES=${CR_BASE}/$SAMPLE/outs/filtered_feature_bc_matrix/barcodes.tsv.gz

VCF=$PROJDIR/vcf/wgs/pgp_filt1.rm_missing.reheader.vcf.gz

DONORS=$PROJDIR/txt/donors.txt

INDIR=$PROJDIR/demux/wgs/
cd $INDIR

PEAKS=$PROJDIR/atac/peaks/cr_arc/${SAMPLE}.peaks.autosome.bed

GEX_OUT=$INDIR/ambimux/gex/${SAMPLE}
ATAC_OUT=$INDIR/ambimux/atac/${SAMPLE}
JOINT_OUT=$INDIR/ambimux/joint/${SAMPLE}

qsub $TEMPLATE/ambimux_gex.sh $GEX_BAM $PEAKS $VCF $DONORS $GTF $EXCL $GEX_OUT
qsub $TEMPLATE/ambimux_atac.sh $ATAC_BAM $PEAKS $VCF $DONORS $GTF $EXCL $ATAC_OUT
qsub $TEMPLATE/ambimux.sh $GEX_BAM $ATAC_BAM $PEAKS $VCF $DONORS $GTF $EXCL $JOINT_OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
