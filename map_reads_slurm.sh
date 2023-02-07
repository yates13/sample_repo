#! /bin/bash

## UPDATE THE FIRST THREE VARIABLES BASED ON YOUR INFORMATION

## Variables: data(dd), working(wd), and save(sd) directory; reference(ref), metadata(met), jobfile(jf), reference prefix(rfp) 
dd="/home/adc0032/DpulexCaloricWD/Data" # may exclude because I will probably make this in script
wd="/scratch/adc0032/DpulexCaloricWD"
sd="/home/adc0032/DpulexCaloricSD"
ref="${wd}/Daphnia_pulex.scaffolds.fa"
met="${wd}/dpulex.calor.meta"
jf="${wd}/dpulex.calor.jf"
rfp=`basename ${ref} | cut -d "." -f 1`

##Commands

# moving into wd, if exists; if not generate the directory and its parent directories. Also silence directory exists message
if [ -d ${wd} ]; then
	cd ${wd}
else
	mkdir -p ${wd}
	cd ${wd}
fi

## UPDATE THIS VARIABLE ASSIGNMENT TO A SINGLE SAMPLE ID FROM THE LIST: SRR6819014, SRR6819015, SRR6819016, SRR6819017

# sample pulled from array task id (this should be the number of samples you have on your jf list and should be specified in the #SBATCH header)
sm=$( head -n ${SLURM_ARRAY_TASK_ID} ${jf} | tail -n 1)

## UPDATE THIS VARIABLE TO RUN A SINGLE MAPPER- PICK ONE FROM BELOW
# array of mappers
mappers=(hisat2 star)

## UPDATE THIS TO SUBMIT THE CORRECT MAPPER SCRIPT BASED ON YOUR MAPPERS VARIABLE
# run trimmed sample reads through hisat2 and through star
printf '%s\n' "${mappers[@]}" | parallel "sh ~/workflow/run_{}.sh ${sm} ${wd}"

