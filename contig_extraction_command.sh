#!/bin/bash
#
#SBATCH --job-name=seqkit_all_gene
#
#SBATCH --cpus-per-task=4
#SBATCH --time=7200
#SBATCH --mem-per-cpu=2000

echo START SCRIPT

echo Creating temp dir $SCRATCH

RUNDIR=$LOCALSCRATCH/$SLURM_JOB_ID
mkdir -p $LOCALSCRATCH/$SLURM_JOB_ID

echo Importation of seqkit software

cp -fr  $SLURM_SUBMIT_DIR/seqkit $LOCALSCRATCH/$SLURM_JOB_ID
cp $CECITRSF/OM-RGC_v2_assemblies.tar.gz $LOCALSCRATCH/$SLURM_JOB_ID
cp $SLURM_SUBMIT_DIR/contig_id.txt $LOCALSCRATCH/$SLURM_JOB_ID

echo going to Localscratch

cd $RUNDIR

echo untar folder contigs

tar -xf OM-RGC_v2_assemblies.tar.gz

echo concat all contig file

cat OM-RGC_v2_assemblies/*.scaftig > all_contig.fasta

echo extract all sequence names

./seqkit seq all_contig.fasta -n > all_contig_id.txt

echo unix converting

dos2unix all_contig_id.txt
dos2unix contig_id.txt

echo subset all contig id to extract only bac 3 contig

grep -F -f contig_id.txt all_contig_id.txt > bac3_internship_contig_id.txt

echo run seqkit to extract all name

./seqkit grep -n -f bac3_internship_contig_id.txt all_contig.fasta -o bac3_internship_contig_sequences.fasta

echo seqkit end

echo copy result on GLOBALSCRATCH

cp $RUNDIR/bac3_internship_contig_sequences.fasta $CECITRSF
cp $RUNDIR/bac3_internship_contig_id.txt $CECITRSF

echo delete LOCALSCRATCH

rm -rf $LOCALSCRATCH/$SLURM_JOB_ID

echo END SCRIPT