BEGIN {
    FS=";"
}
{
    for (i=1; i<=NF; i++)
    {
        if(NR==1)
        {
            quote_start = match($i,"\"")
            quote_end = length($i) - match(substr($i, quote_start+1),"\"")
            # We set FIELD_NAME[i] equal to $i, minus the start and end quotes
            # If there are no start or end quotes, this is equivalent to
            # FIELD_NAME[i]=$i
            FIELD_NAME[i]=substr($i, quote_start+1, (length($i)-quote_end)-1)
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
}
