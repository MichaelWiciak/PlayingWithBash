timeTaken() {
    # print separator
    echo "----------------------------------------"

    local max=$1
    start_time1=$(date +%s.%N)
    index=0
    while [ $index -le $max ]; do
        echo $index
        ((index++))
    done
    end_time1=$(date +%s.%N)
    elapsed_time1=$(echo "$end_time1 - $start_time1" | bc)
    elapsed_time1=$(printf "%.5f" "$elapsed_time1")

    echo "Time taken to print $index entries: $elapsed_time1 seconds"

    # Just generate without printing and compare time
    start_time2=$(date +%s.%N)
    index=0
    while [ $index -le $max ]; do
        #no echo $index
        ((index++))
    done
    end_time2=$(date +%s.%N)
    elapsed_time2=$(echo "$end_time2 - $start_time2" | bc)
    elapsed_time2=$(printf "%.5f" "$elapsed_time2")

    echo "Time taken to generate $index entries: $elapsed_time2 seconds"

    combined=$(echo "$elapsed_time1 - $elapsed_time2" | bc)
    combined=$(printf "%.5f" "$combined")
    
    # difference between printing and not printing
    echo "Time difference between printing and not printing for $index entries: $combined seconds"
}

# Note that | bc seems not to be working as intended so I will try to experiment with it

timeTaken 500000
