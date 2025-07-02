BEGIN {
    FS=";"
}
{
    if (NR==FNR)
    {
        MIN[$1] = $2
        MAX[$1] = $3
        AVG[$1] = $4
        FIELD_NAME[NR]=$1
    }
    else if(FNR>1)
    {
        for (i=1; i<=NF; i++)
        {
            j=FIELD_NAME[i]
            MEAN=AVG[j]
            VALUE=$i
            VARIANCE[j]+=((MEAN - VALUE)^2)
        }
    }
}
END {
    for (i=1; i<=NF; i++)
    {
        j=FIELD_NAME[i]
        STD_VAR[j]=((VARIANCE[j] / FNR)^0.5)
        printf "%3d %-22s %6.2f %6.2f %6.2f %8.2e\n", i, j, MIN[j], MAX[j], AVG[j], STD_VAR[j]
    }
}
