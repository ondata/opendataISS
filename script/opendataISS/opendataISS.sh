#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing
mkdir -p "$folder"/processing/csv
mkdir -p "$folder"/risorse
mkdir -p "$folder"/report

URL="https://www.epicentro.iss.it/coronavirus/open-data/OPENDATA-2021.zip https://www.epicentro.iss.it/coronavirus/open-data/OPENDATA-2020.zip"

for i in $URL; do
  cd "$folder"/risorse
  nome=$(echo "https://www.epicentro.iss.it/coronavirus/open-data/OPENDATA-2020.zip" | sed -r 's|^.+/||g')
  # se i file zip non esistono, scaricali
  if [ ! -f "$folder"/risorse/"$nome" ]; then
    wget "$i"
  fi
done

# decomprimi i file zip
decomprimi="no"
if [ "$decomprimi" = "sì" ]; then
  for i in "$folder"/risorse/OPEN*.zip; do
    nome=$(basename "$i" .zip)
    echo "$nome"
    mkdir -p "$folder"/processing/"$nome"
    unzip "$i" -d "$folder"/processing/"$nome"
  done
fi

# estrai nomi dei fogli
csvtk xlsx2csv "$folder"/processing/OPENDATA-2020/OPENDATA/COVID_19_ISS_open_data_2020-04-23.xlsx -a | mlr --t2n filter '$index>2' then cut -f sheet >"$folder"/risorse/fogliOpenDataISS

# cancella i csv grezzi
#find "$folder"/processing/csv -name '*.csv' -delete

# estrai tutti i file CSV fai file XLSX
for i in "$folder"/processing/OPEN*/OPEN*/*.xlsx; do
  echo "$i"
  nome=$(basename "$i" .xlsx)
  while read p; do
    echo "$p"
    csvtk xlsx2csv "$i" -n "$p" >"$folder"/processing/csv/"$nome"_"$p".csv
  done <"$folder"/risorse/fogliOpenDataISS
done

# fai il merge
#rm "$folder"/risorse/*.csv
#while read p; do
#  mlr --csv remove-empty-columns then skip-trivial-records then unsparsify then put -S '$file=FILENAME;$file=sub($file,"^.+/","")' "$folder"/processing/csv/"$p"*.csv >"$folder"/risorse/"$p".csv
#done <"$folder"/risorse/fogliOpenDataISS

# pulisci file problematico
mlr -I --csv -N cut -x -f 4,5 "$folder"/processing/csv/COVID_19_ISS_open_data_2020-12-10_casi_inizio_sintomi_sint.csv

rm "$folder"/risorse/*.json

# fai il merge di tutti i dati in un JSON per tipo dati
while read p; do
  echo "$p"
  for i in "$folder"/processing/csv/*"$p".csv; do
    mlr --c2j remove-empty-columns then skip-trivial-records then unsparsify then put -S '$file=FILENAME;$file=sub($file,"^.+/","")' "$i" >>"$folder"/risorse/"$p".json
  done
done <"$folder"/risorse/fogliOpenDataISS

# converti i file di insieme da JSON a CSV e estrai righe file in cui la data del file è diversa dalla data del campo iss_date
for i in "$folder"/risorse/*.json; do
  nome=$(basename "$i" .json)
  mlr --j2c cat then put -S '$file=sub($file,".csv$","")' then put -S '$iss_date_iso8601=strftime(strptime($iss_date, "%d/%m/%Y"),"%Y-%m-%d");$file_date_iso8601=regextract_or_else($file,"[0-9]{4}-[0-9]{2}-[0-9]{2}","");if($iss_date_iso8601==$file_date_iso8601){$check=1}else{$check=0}' "$i" >"$folder"/risorse/"$nome".csv
  mlr --csv filter '$check==0' "$folder"/risorse/"$nome".csv>"$folder"/report/errori-date_"$nome".csv
  mlr -I --csv cut -x -f check then reorder -e -f file "$folder"/risorse/"$nome".csv
done

# cancella file di errori vuoti
find "$folder"/report/ -size 0 -delete

# normalizza a intero il codice provinciale
mlr -I --csv put -S '$COD_PROV=sub($COD_PROV,"\..+","")' "$folder"/risorse/casi_provincie.csv
