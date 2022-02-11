#!/bin/bash
#SBATCH --mail-user=ar.aamer@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --job-name=brats_train1
#SBATCH --output=%x-%j.out
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=32
#SBATCH --mem=90000M
#SBATCH --time=0-00:5
#SBATCH --account=rrg-ebrahimi

nvidia-smi

source ~/py_envs/open_brats2020/bin/activate

echo "------------------------------------< Data preparation>----------------------------------"
echo "Copying the source code"
date +"%T"
cd $SLURM_TMPDIR
cp -r -f ~/scratch/open_brats2020 .

echo "Copying the datasets"
date +"%T"
cp -r -f ~/scratch/Datasets/BRATS2020 .

echo "creating data directories"
date +"%T"



cd BRATS2020
unzip MICCAI_BraTS2020_TrainingData.zip
unzip MICCAI_BraTS2020_ValidationData.zip



echo "----------------------------------< End of data preparation>--------------------------------"
date +"%T"
echo "--------------------------------------------------------------------------------------------"

echo "---------------------------------------<Run the program>------------------------------------"
date +"%T"
cd $SLURM_TMPDIR

cd src

python -m src.train --devices 0 --width 48 --arch EquiUnet


echo "-----------------------------------<End of run the program>---------------------------------"
date +"%T"
echo "--------------------------------------<backup the result>-----------------------------------"
date +"%T"
cd $SLURM_TMPDIR
cp -r $SLURM_TMPDIR/src ~/scratch/open_brats2020

