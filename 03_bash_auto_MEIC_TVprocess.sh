

cat > ./01_20211222_HourlytempoAllo_nonSerial_linuxLoop.py <<EOF

from netCDF4 import Dataset
import pandas as pd
import numpy as np
import os




# this is the script for hourly tempo allocation.
# it is for non-serial wrfchemi file
#




temporal_csv = pd.read_csv(
    '/gpfs/home/hpc15zha/project/06_wrfchem_20210408/wrfchemiPy/pythoncode/Emis_TV_merge/tempoVertiCSV/20211222_MICS_Asia_hourlyWeighting.csv'
    #sep = ';',
    #encoding="ANSI" #  defining what encoding is using
)


csv_sectorsNames = ["trans","indus","power","res"] # 4 sectors
subset_Names = csv_sectorsNames.copy() # dir names

for sector_ix in np.arange(0,len(csv_sectorsNames),1):
    sector_name_inCSV = csv_sectorsNames[sector_ix]
    subset = subset_Names[sector_ix]
    print(sector_name_inCSV)

    wrfchemi_dir = sector_emis_dir+subset+"/"


    filenames = os.listdir(wrfchemi_dir)
    filenames = np.array(filenames)

    for file in filenames:
        print("========  start  ==========")
        print(file)
        print("===========================")


        dsout = Dataset(wrfchemi_dir+file, "r+", format="NETCDF4_CLASSIC")  # reading and writing

        varnames = list(dsout.variables.keys())

        if "00z" in file: # if 00z file, we will assume it start from UTC 0, (local time 8 oclock)

            scale = np.array(temporal_csv.loc[0:11,sector_name_inCSV]) # Note that, unlike the usual Python convention, .loc slices include both endpoints
            # https://towardsdatascience.com/a-python-beginners-look-at-loc-part-1-cb1e1e565ec2

            for species in varnames:
                if species == "Times":
                    print("")
                elif species == "XLONG":
                    print("")
                elif species == "XLAT":
                    print("")
                else:
                    print(species)
                    for i in np.arange(0,12,1): # 12 hour in each file
                        dsout[species][i,0,:,:] = scale[i] * dsout[species][i,0,:,:]

            dsout.close()

        else:
            scale = np.array(temporal_csv.loc[12:23,sector_name_inCSV])  # Note that, unlike the usual Python convention, .loc slices include both endpoints

            for species in varnames:
                if species == "Times":
                    print("")
                elif species == "XLONG":
                    print("")
                elif species == "XLAT":
                    print("")
                else:
                    print(species)
                    for i in np.arange(0,12,1): # 12 hour in each file
                        dsout[species][i,0,:,:] = scale[i] * dsout[species][i,0,:,:]

            dsout.close()
EOF

cat > ./02_20211222_nonSerial_wrfchemi_verti_linuxLoop.py <<EOF

from netCDF4 import Dataset
import pandas as pd
import numpy as np
import os


# only need to do indus, and power



vertical_csv = pd.read_csv(
    '/gpfs/home/hpc15zha/project/06_wrfchem_20210408/wrfchemiPy/pythoncode/Emis_TV_merge/tempoVertiCSV/20211222_MICS_Asia_verti.csv'
    #sep = ';',
    #encoding="ANSI" #  defining what encoding is using
)





# the logic is,
# first do layer of 2 to  (looping all hours of wrfchemi files)
# then do the first layer (looping all hours of wrfchemi files)


csv_sectorsNames = ["indus","power"] # 2 sectors
subset_Names = csv_sectorsNames.copy() # dir names

for sector_ix in np.arange(0,len(csv_sectorsNames),1):
    sector_name_inCSV = csv_sectorsNames[sector_ix]
    subset = subset_Names[sector_ix]
    print(sector_name_inCSV)

    wrfchemi_dir = sector_emis_dir+subset+"/"

    filenames = os.listdir(wrfchemi_dir)
    filenames = np.array(filenames)

    for file in filenames:



        dsout = Dataset(wrfchemi_dir+file, "r+", format="NETCDF4_CLASSIC")  # reading and writing

        varnames = list(dsout.variables.keys())



        for species in varnames:
            if species == "Times":
                print("")
            elif species == "XLONG":
                print("")
            elif species == "XLAT":
                print("")
            else:
                print(species)

                for i in np.arange(1,dsout[species].shape[1],1):
                    for j in np.arange(0,dsout[species].shape[0],1): # time
                        scale = vertical_csv[sector_name_inCSV][i]
                        dsout[species][j,i,:,:] = scale * dsout[species][j,0,:,:] # 1 hour, 1 vertical layer, all data are in the first layer

                for time in np.arange(0,dsout[species].shape[0],1):

                    dsout[species][time,0,:,:] = vertical_csv[sector_name_inCSV][0] * dsout[species][time,0,:,:]

        dsout.close()
        print("************************")
        print("************************")
        print("****     END      ******")
        print("************************")
        print("************************")
EOF

cat > ./03_20210806_merge_wrfchemi_NS_linux.py <<EOF

from netCDF4 import Dataset
import pandas as pd
import numpy as np
import os


allsectors_dir = sector_emis_dir # end with /

base_dir = allsectors_dir+"agr/"#where other sources will be write in

other_dir1 = allsectors_dir+"indus/"
other_dir2 = allsectors_dir+"power/"
other_dir3 = allsectors_dir+"res/"
other_dir4 = allsectors_dir+"trans/"


filenames = os.listdir(base_dir)
filenames = np.array(filenames)


for file in filenames:

    dsout = Dataset(base_dir+file, "r+", format="NETCDF4_CLASSIC")

    other1 = Dataset(other_dir1+file, format="NETCDF4_CLASSIC")
    other2 = Dataset(other_dir2+file, format="NETCDF4_CLASSIC")
    other3 = Dataset(other_dir3+file, format="NETCDF4_CLASSIC")
    other4 = Dataset(other_dir4+file, format="NETCDF4_CLASSIC")

    varnames = list(dsout.variables.keys())

    for species in varnames:
        if species == "Times":
            print("")
        elif species == "XLONG":
            print("")
        elif species == "XLAT":
            print("")
        else:
            print(species)

            for time in np.arange(0,dsout[species].shape[0],1):

                dsout[species][time,:,:,:] =  dsout[species][time,:,:,:] + other1[species][time,:,:,:] + other2[species][time,:,:,:]+other3[species][time,:,:,:] + other4[species][time,:,:,:]# 1 hour, all vertical layer

    dsout.close()
    print("************************")
    print("************************")
    print("---    "+file+"    -----")
    print("****     END      ******")
    print("************************")
    print("************************")
EOF

module add python/anaconda/2019.10/3.7
conda activate wrfchemi
sed -i "1s,^,sector_emis_dir = ${sector_emis_dir}," ./01_20211222_HourlytempoAllo_nonSerial_linuxLoop.py
sed -i "1s,^,sector_emis_dir = ${sector_emis_dir}," ./02_20211222_nonSerial_wrfchemi_verti_linuxLoop.py
sed -i "1s,^,sector_emis_dir = ${sector_emis_dir}," ./03_20210806_merge_wrfchemi_NS_linux.py
python ./01_20211222_HourlytempoAllo_nonSerial_linuxLoop.py && python ./02_20211222_nonSerial_wrfchemi_verti_linuxLoop.py && python ./03_20210806_merge_wrfchemi_NS_linux.py && mkdir -p ${sector_emis_dir_nohash}/allsectors && mv ${sector_emis_dir_nohash}/agr/* ${sector_emis_dir_nohash}/allsectors
