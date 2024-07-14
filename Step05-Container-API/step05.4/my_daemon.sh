COUNT=0

PV=/pv/save.dat     # Persistent volume

if [ -f $PV ]; then
    COUNT=`cat $PV`
    rm -f $PV
fi

save() {
    echo $COUNT > $PV
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
