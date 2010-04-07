# Iterates in all directories under $1 and consolidate average times on files under them.
# Directories must NOT have spaces on their names!

work_dir=$PWD

cd $1
for d in $(ls)
do
    cd $d
    sh $work_dir/consolidate_avr_times.sh 1
    sh $work_dir/consolidate_avr_times.sh 5
    sh $work_dir/consolidate_avr_times.sh 10
    sh $work_dir/consolidate_avr_times.sh 15
    cd ..
done

cd $work_dir