#!/bin/bash
#SBATCH --job-name=KGv2
#SBATCH --output=logs/KGv2.out
#SBATCH --error=logs/KGv2.err
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1                # 1 GPU
#SBATCH --cpus-per-task=8           # Adjust based on your needs
#SBATCH --mem=80G                   # Adjust based on your needs
#SBATCH --nodes=1
#SBATCH --ntasks=1

# Activate your environment
source activate kaggle_rna

checkpoint_path="$HOME/DATA/zeus/hnguyent/DATA/stanford-rna-3d-folding/data/af3-dev/release_model/model_v0.2.0.pt"

CUDA_VISIBLE_DEVICES=0 python ./runner/train.py \
--run_name kaggle_v2 \
--seed 42 \
--base_dir ./PDB_multi \
--dtype bf16 \
--use_msa false \
--project protenix \
--use_wandb false \
--diffusion_batch_size 8 \
--eval_interval 50000 \
--log_interval 1 \
--checkpoint_interval 2000 \
--ema_decay 0.995 \
--train_crop_size 512 \
--max_steps 4000 \
--warmup_steps 50 \
--lr 0.0001 \
--sample_diffusion.N_step 20 \
--load_checkpoint_path ${checkpoint_path} \
--load_ema_checkpoint_path ${checkpoint_path} \
--data.train_sets weightedPDB_before2109_wopb_nometalc_0925 \
--data.weightedPDB_before2109_wopb_nometalc_0925.base_info.pdb_list examples/finetune_subset.txt \
--data.test_sets recentPDB_1536_sample384_0925,posebusters_0925

#sh infer.sh