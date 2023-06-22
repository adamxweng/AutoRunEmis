
#============ directory for output emission inp file (MOZART) =============== 
export emisinpdir=/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/LongTermSim/2017/MOZART/00_autoRunScript/emisrun/emisinp_201707

#============== anthro emiss files processing ===========
# declare anthro_dir
# declare wrf_dir

export emisdir="'/gpfs/home/hpc15zha/scratch/emission_inventory/MEIC/2017_pythonArea'"
export wrfdirforemis="'/gpfs/home/hpc15zha/project/11_wrfchem_20211129/wrf371/heteorchem1_srun/WRFV3/test/em_real'"
# year of emission
export emisfile_prefix="2017"

export emis_starttime="'2017-07-01_00:00:00'"
export emis_endtime="'2017-07-31_23:00:00'"

#============= emission output directory, wrfchemi for each sector ====================

export emisout=/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/LongTermSim/2017/MOZART/emis/201707


#============ anthro emis directory ==========================================

export anthro_dir=/gpfs/home/hpc15zha/project/11_wrfchem_20211129/tools/ANTHRO/src

# no need to change everytime

#============== logdir =======================================================
export log_dir=/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/LongTermSim/2017/MOZART/00_autoRunScript/emisrun/logdir_201707

#==============  Tempo and vertical allocation =============================== 
# remember to change this
export sector_emis_dir='"/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/LongTermSim/2017/MOZART/emis/201707/sectors/"#'
export sector_emis_dir_nohash=${emisout}/sectors


