# Consolidates all average times in run>.log files for a specified number of clients passed as $1.

for j in $1
do
    grep -i average *-cli$j-* | cut -d: -f4 > results-cli$j.txt
done
