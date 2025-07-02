BEGIN {
    FS=";"
}
{
    for (i=1; i<=NF; i++)
    {
        if(NR==1)
        {
            FIELD_NAME[i]=$i
        }
        else if(NR==2)
        {
            MIN[i] = $i
            MAX[i] = $i
            SUM[i] = $i
        }
        else if(NR>2)
        {
            if ($i < MIN[i])
                MIN[i] = $i
            if ($i > MAX[i])
                MAX[i] = $i
            SUM[i] += $i
        }
    }
}
END {
    OFS=";"
    for (i=1; i<=NF; i++)
    {
        MEAN[i] = SUM[i] / NR
        print FIELD_NAME[i], MIN[i], MAX[i], MEAN[i]
    }
    #VARIANCE=SUM_OF_SQUARES / NR
    #STANDARD_DEVIATION=(VARIANCE)^0.5
}
