# AutoRunEmis
# modified 00_envVriables_settingEmis_XXX.sh
source 00_envVriables_settingEmis_XXX.sh
source ~/.bash_profile
module add python/anaconda/2019.10/3.7
conda activate wrfchemi
bash 01_bash_auto_anthroInp_InJect.sh && bash 02_bash_auto_sectorWRFchemi.sh && bash 03_bash_auto_MEIC_TVprocess.sh
python3 04_BatchMerge_EDGARV5_MEIC_MEICAddVOCs.py
