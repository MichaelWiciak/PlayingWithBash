timeTakenFailed() {
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

#timeTakenFailed 50000

# Note that | bc seems not to be working as intended so I will try to experiment with it

bcTest(){
    # print separator
    echo "----------------------------------------"
    echo "Testing bc"
    echo "Output of 5/2 is:"
    # try to the result of a calculation that will result in a decimal number
    echo "scale=5; 5/2" | bc -l
    # This works as 2.50000
    # lets try variables now
    result=$(echo "scale=2; 5/2" | bc -l)
    echo "$result"
    # This works as 2.50

}

#bcTest

timeTaken() {
    # print separator
    echo "----------------------------------------"
    # ok, lets try to get one time to work
    local max=$1
    start_time=$(date +%s%3N)
    index=0
    while [ $index -le $max ]; do
        echo $index
        ((index++))
    done
    end_time=$(date +%s%3N)

    elapsed_time=$( { time -p your_command_here > /dev/null; } 2>&1 | awk '/real/ {print $2}' )

    elapsed_time_ms=$(echo "scale=3; $elapsed_time * 1000" | bc)
    
    echo "Elapsed time: $elapsed_time_ms milliseconds"
    # print output
    #echo "Time taken to print $index entries: $elapsed_time1 seconds"
}

timeTaken 50000

