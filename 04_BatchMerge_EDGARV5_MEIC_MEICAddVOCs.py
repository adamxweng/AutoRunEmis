from netCDF4 import Dataset
import pandas as pd
import numpy as np
from shutil import copyfile
import os


# declaring

# original MEIC base data
MEIC_CO = Dataset("/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/LongTermSim/2017/MOZART/emis/201707/sectors/allsectors/wrfchemi_00z_d01")

rootdir="/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/LongTermSim/2017/MOZART/emis/201707/"


EDGAR_dir = "/gpfs/home/hpc15zha/project/11_wrfchem_20211129/output/EmisUpdate_1/201707/MOZART/emis/1_base/EDGARv5/" # EDGAR file, with PMspec



MEIC_emis_path = np.array(["meic_edgarmerged/"])



#===============  actual processing =======================================




co_base = MEIC_CO['E_CO'][0,0,:,:] # use this to know which grid need to filled with EDGAR data


co_base[co_base == 0] = -9999


co_base[co_base != -9999] = 0 # convert region within China  to 0


co_base[co_base == -9999] = 1 # convert region outside China 1

factor = co_base.copy()


for addpath in MEIC_emis_path:
    base_dir = rootdir+addpath #where other sources will be write in, MEIC emission file
    print(base_dir)
    # these two files should be named the same

    filenames = os.listdir(base_dir)
    filenames = np.array(filenames)

    for file in filenames:

        dsout = Dataset(base_dir + file, "r+", format="NETCDF4_CLASSIC")

        edgarFile = Dataset(EDGAR_dir + file, format="NETCDF4_CLASSIC")

        varnames = list(edgarFile.variables.keys())  # only change line here, we add EDGAR data
        meicnames = list(dsout.variables.keys())

        for species in varnames:
            if species == "Times":
                print("")
            elif species == "XLONG":
                print("")
            elif species == "XLAT":
                print("")
            else:
                # print(species)

                if species in meicnames:
                    print(species)
                    for time in np.arange(0, dsout[species].shape[0], 1):

                        for vertiIndex in np.arange(0, dsout[species].shape[1], 1):
                            dsout[species][time, vertiIndex, :, :] = dsout[species][time, vertiIndex, :, :] + (edgarFile[species][time,vertiIndex,:,:] * factor)
                else:
                    print("*** " + species + " NOT in")

        dsout.close()
        print("************************")
        print("************************")
        print("---    " + file + "    -----")
        print("****     END      ******")
        print("************************")
        print("************************")




