# TASK 2.1: Determines the average score of a student, 
# given the sum of their scores and number of classes.
function calculate_average(sum, count) {
    return (sum/count)
}

# TASK 2.2: Determines pass/fail status, given the average score as input.
function calculate_status(avg_score) {
    if (avg_score >= 70)
        return "Pass"
    return "Fail"
}

# TASK 3.1: Given scores indexed by student ids,
# create an array of the highest scoring students.
function get_high_student(scores) {
    for (id in scores)
    {
        score=scores[id]
        # If this is our first score, or if this score equals an already found one,
        # we add it to our list and adjust our count.
        if (high_score_count == 0 || score == high_score)
        {
            high_score=score
            high_score_count++
            high_student[id]=high_score_count
        }
        # if, instead, we have found a new extreme score, we delete the old list
        # and create a new one, containing only this student.  We reset the count.
        else if (score > high_score)
        {
            high_score=score
            high_score_count=1
            delete high_student
            high_student[id]=high_score_count
        }
    }
}

# TASK 3.2: Same code as get_high_student, except for variable names and the direction of <
function get_low_student(scores) {
    for (id in scores)
    {
        score=scores[id]
        if (low_score_count == 0 || score == low_score)
        {
            low_score=score
            low_score_count++
            low_student[id]=low_score_count
        }
        else if (score < low_score)
        {
            low_score=score
            low_score_count=1
            delete low_student
            low_student[id]=low_score_count
        }
    }
}

BEGIN {
    FS=","
}
{
    if(NR==1)
    {
    # The first record we use to map column names to column indices
        for (i=1; i<=NF; i++)
        {
            # replace capital letters to make matching easier.
            column=tolower($i)

            # check if "name" appears in the column name.
            if (index(column,"name"))
            {
                name_index=i
            }
            # check if "student" followed by "id" appears in the column name.
            else if (match(column,"student*id"))
            {
                id_index=i
            }
            # check if "cs" followed by at least one digit appears in the column name.
            else if (match(column, "cs[0-9]+"))
            {
                # mapping class names to column index,
                # e.g. class_list[CS146]=3.
                class_list[$i]=i
                # keep count of how many classes we have.
                class_count+=1
            }
        }
    }
    else
    {
    # Now we are in the block handling every row except for the first.
        # look up the contents of the studentid column.
        # we use the id as a unique index for this row's student
        # into our associative array.
        student_id=$id_index
        for(class in class_list)
        {
            # find column index for this class.
            class_index=class_list[class]

            # find the student's grade in this class.
            grade=$class_index

            # TASK 1: add the grade to the student's sum of grades.
            Sum_of_Grades[student_id]+=grade
        }

        # TASK 4.1 Map the student's name to their ID
        Student_Name[student_id]=$name_index

        # TASK 2.1: function caluclate_average computes the average grade for this student.
        Average_Score[student_id]=calculate_average(Sum_of_Grades[student_id], class_count)

        # TASK 2.2: function calculate_status determines their pass/fail status.
        Status[student_id]=calculate_status(Average_Score[student_id])
    }
}       
END {

    # TASK 3: Use our defined functions to get a list of highest and lowest scoring students
    get_low_student(Sum_of_Grades)
    get_high_student(Sum_of_Grades)

    # Nicely format the column headings we need for TASK 4 and TASK 5
    formatting="| %-10s | %-12s | %-11s | %-13s | %-6s | %14s |\n"
    print "-------------------------------------------------------------------------------------"
    printf formatting, "Student ID","Student Name","Total Score","Average score","Status","Special Status"
    print "-------------------------------------------------------------------------------------"
    # Match the formatting for the actual data
    formatting="| %-10d | %-12s | %-11d | %-13d | %-6s | %14s |\n"
    for (id in Sum_of_Grades)
    {
        name=Student_Name[id]
        total=Sum_of_Grades[id]
        average=Average_Score[id]
        pf_status=Status[id]
        special=""
        if (id in low_student)
        {
            special="lowest score"
        }
        if (id in high_student)
        {
            special="highest score"
        }
        # TASK 4: Print student id, name, total score, average score, pass/fail,
        # Task 5: and print special, which is a string saying if they were the highest or lowest.
        printf formatting, id, name, total, average, pf_status, special
    }
    print "-------------------------------------------------------------------------------------"
    print ""
    print "TASK 1 The sum_of_grades associative array is on line 110 of grader.awk:"
    print "       >>> Sum_of_Grades[student_id]+=grade"
    print "TASKS 2 and 3 are all in appropriately named functions at the top of the file."
    print "TASKS 4 and 5 are in the above table."
    print ""
}
