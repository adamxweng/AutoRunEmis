mkdir -p ${emisout}

mkdir -p ${emisout}/sectors
mkdir -p ${emisout}/sectors/indus
mkdir -p ${emisout}/sectors/power
mkdir -p ${emisout}/sectors/res
mkdir -p ${emisout}/sectors/trans
mkdir -p ${emisout}/sectors/agr

srcID=(transportation agriculture power industry residential)
filedir=(trans agr power indus res)


for i in 0 1 2 3 4
do
        export MEICSource=${srcID[$i]}
        echo $MEICSource
        export outdir=${filedir[$i]}
        echo $outdir
        ${anthro_dir}/anthro_emis < ${emisinpdir}/${outdir}.inp && mv ./wrfchemi* ${emisout}/sectors/${outdir}


done
