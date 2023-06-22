trash()
    {
    mv $@ /gpfs/home/hpc15zha/trashcan
    }

cleartrash()
    {
    read -p "clear sure?[n]" confirm
    [ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf /gpfs/home/hpc15zha/trashcan/*
    }
	


mkdir -p ${emisinpdir}

trash ${emisinpdir}/*

cat > ${emisinpdir}/agr.inp <<EOF
&CONTROL



 src_file_suffix = '.nc'
 src_names = 'BC(1)','GLY(1)','MVK(1)','MEK(1)','PRD2(1)','MACR(1)',
            'MGLY(1)','ALK1(1)','ALK2(1)','ALK3(1)','ALK4(1)',
            'ALK5(1)','ARO1(1)','ARO2(1)','OLE1(1)',
            'OLE2(1)','ETHE(1)','HCHO(1)','CCHO(1)','ACET(1)',
            'MEOH(1)','ISOP(1)','TERP(1)','BALD(1)','CH4(1)',
			'CRES(1)','PHEN(1)',
            'CO(28)','CO2(44)','NH3(17)','NO(30)','NO2(46)','OC(1)','PM25(1)','PM10(1)','SO2(64)',
 sub_categories  = 'emis_tot'
 cat_var_prefix  = ' '
 serial_output   = .false.


 emissions_zdim_stag = 8
 emis_map = 'CO->CO',
			'NO->NO',
			'NO2->NO2',
			'SO2->SO2',
			'NH3->NH3',
            'BIGALK->ALK3+ALK4+ALK5',
			'BIGENE->OLE2',
            'C2H4->ETHE',
			!'C2H5OH->0.0*CO',!!!shutdown,
			'C2H6->ALK1',
			'CH2O->HCHO',
			'CH3CHO->CCHO',
            'CH3COCH3->ACET',
			!'CH3OH->MEOH',!!! not able to map to RADM2
			'MEK->PRD2+MEK',
			'TOLUENE->ARO1',!!! previous 'TOLUENE->ARO1+ARO2', however, based on carter table, it should be separated
			'XYLENE->ARO2',!!! previous is 0
            'C3H6->OLE1',
			'C3H8->ALK2',
			!'ISOP->ISOP',!!! iso is not processed in BMZ
			!'APIN->TERP',!!! shut down, not able to map to RADM2
            !'SULF->0.0*SO2',
			!'C2H2->0.0*CO',! previous 0.00561790*CO is uncertain, now we set to 0
			!'BENZENE->0.0*CO',
            !'GLY->GLY',!!! shut down, not able to map to RADM2
			!'MACR->MACR',!!! shut down, not able to map to RADM2
			!'MGLY->MGLY',!!! shut down, not able to map to RADM2, emis_opt==3 has no MGLY
			!'MVK->MVK',!!! shut down, not able to map to RADM2,
            !'HCOOH->0.0*CO',
			!'HONO->0.0*CO',
			!'BALD->BALD',!!! not in emis_opt =10, shut down, not able to map to RADM2,
			!'CH4->CH4',!!! not in emis_opt =10, shut down, not able to map to RADM2,
			!'CRES->CRES',!!! not in emis_opt =10, shut down, not able to map to RADM2,
			!'PHEN->PHEN',!!! not in emis_opt =10, shut down, not able to map to RADM2,
            'ECI(a)->0.2*BC','ECJ(a)->0.8*BC','ORGI(a)->0.2*OC','ORGJ(a)->0.8*OC','PM25I(a)->0.2*PM25 + -0.2*BC + -0.2*OC',
            'PM25J(a)->0.8*PM25 + -0.8*BC + -0.8*OC','PM_10(a)->PM10 + -1.0*PM25','SO4I(a)->0.0*PM10','SO4J(a)->0.0*PM10',
			'NO3I(a)->0.0*PM10',
            'NO3J(a)->0.0*PM10','NH4I(a)->0.0*PM10','NH4J(a)->0.0*PM10','NAI(a)->0.0*PM10','NAJ(a)->0.0*PM10',
            'CLI(a)->0.0*PM10','CLJ(a)->0.0*PM10',
			'CO_A->0.0*CO','CO_BB->0.0*CO',!!! included, these two are tracers
			'ORGI_A(a)->0.0*PM10',
            'ORGI_BB(a)->0.0*PM10','ORGJ_A(a)->0.0*PM10','ORGJ_BB(a)->0.0*PM10','VOCA->0.0*PM10','VOCBB->0.0*PM10'
/
EOF

cp ${emisinpdir}/agr.inp ${emisinpdir}/indus.inp
cp ${emisinpdir}/agr.inp ${emisinpdir}/power.inp
cp ${emisinpdir}/agr.inp ${emisinpdir}/res.inp
cp ${emisinpdir}/agr.inp ${emisinpdir}/trans.inp

#========= agriculture =============

sed -i "2s,^, anthro_dir = ${emisdir}," ${emisinpdir}/agr.inp
sed -i "3s,^, wrf_dir    = ${wrfdirforemis}," ${emisinpdir}/agr.inp
sed -i "4s,^, src_file_prefix = \'${emisfile_prefix}_agriculture_\'," ${emisinpdir}/agr.inp
sed -i "16s,^, start_output_time = ${emis_starttime}," ${emisinpdir}/agr.inp
sed -i "17s,^, stop_output_time = ${emis_endtime}," ${emisinpdir}/agr.inp

#========= indus =============
sed -i "2s,^, anthro_dir = ${emisdir}," ${emisinpdir}/indus.inp
sed -i "3s,^, wrf_dir    = ${wrfdirforemis}," ${emisinpdir}/indus.inp
sed -i "4s,^, src_file_prefix = \'${emisfile_prefix}_industry_\'," ${emisinpdir}/indus.inp
sed -i "16s,^, start_output_time = ${emis_starttime}," ${emisinpdir}/indus.inp
sed -i "17s,^, stop_output_time = ${emis_endtime}," ${emisinpdir}/indus.inp

#========= power =============
sed -i "2s,^, anthro_dir = ${emisdir}," ${emisinpdir}/power.inp
sed -i "3s,^, wrf_dir    = ${wrfdirforemis}," ${emisinpdir}/power.inp
sed -i "4s,^, src_file_prefix = \'${emisfile_prefix}_power_\'," ${emisinpdir}/power.inp
sed -i "16s,^, start_output_time = ${emis_starttime}," ${emisinpdir}/power.inp
sed -i "17s,^, stop_output_time = ${emis_endtime}," ${emisinpdir}/power.inp

#========= residential =============
sed -i "2s,^, anthro_dir = ${emisdir}," ${emisinpdir}/res.inp
sed -i "3s,^, wrf_dir    = ${wrfdirforemis}," ${emisinpdir}/res.inp
sed -i "4s,^, src_file_prefix = \'${emisfile_prefix}_residential_\'," ${emisinpdir}/res.inp
sed -i "16s,^, start_output_time = ${emis_starttime}," ${emisinpdir}/res.inp
sed -i "17s,^, stop_output_time = ${emis_endtime}," ${emisinpdir}/res.inp

#========= transportation =============
sed -i "2s,^, anthro_dir = ${emisdir}," ${emisinpdir}/trans.inp
sed -i "3s,^, wrf_dir    = ${wrfdirforemis}," ${emisinpdir}/trans.inp
sed -i "4s,^, src_file_prefix = \'${emisfile_prefix}_transportation_\'," ${emisinpdir}/trans.inp
sed -i "16s,^, start_output_time = ${emis_starttime}," ${emisinpdir}/trans.inp
sed -i "17s,^, stop_output_time = ${emis_endtime}," ${emisinpdir}/trans.inp


#======== checking the script ===========

diff -b ${emisinpdir}/agr.inp ${emisinpdir}/indus.inp
diff -b ${emisinpdir}/agr.inp ${emisinpdir}/power.inp
diff -b ${emisinpdir}/agr.inp ${emisinpdir}/res.inp
diff -b ${emisinpdir}/agr.inp ${emisinpdir}/trans.inp
echo "should only sector difference"


