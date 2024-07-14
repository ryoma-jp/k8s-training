COUNT=0

if [ -f save.dat ]; then
    COUNT=`cat save.dat`
    rm -f save.dat
fi

save() {
    echo $COUNT > save.dat
    exit 0
}
trap save TERM

if [ -z "$INTERVAL" ]; then
    INTERVAL=5
fi

while [ true ];
do
    TM=`date|awk '{print $4}'`
    printf "%s : %s\n" $TM $COUNT
    let COUNT=COUNT+1
    sleep $INTERVAL
done
