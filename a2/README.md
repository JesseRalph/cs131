# DataCollector


## Description
DataCollector is a bash script that downloads, unzips (if necessary), and summarizes CSV datasets. 
These CSV datasets are placed in a working directory with a name derived from the basename of the dataset URL.
The summary of each CSV file (written to a .md file matching the basename of the CSV) contains:

* Index and name for each column
* Statistics for each numerical column
    * Minimum
    * Maximum
    * Mean
    * Standard Deviation

If desired, the user can select a subset of columns to be summarized.


## Usage

```bash
./datacollector.sh <URL of a CSV file or zipped CSV file>
```
The program will then prompt the user to specify desired fields to summarize (empty input means all fields).


## Example
```bash
jesseralph@instance-20250602-170142:~/cs131/a2$ ./datacollector.sh https://archive.ics.uci.edu/static/public/186/wine+quality.zip
Creating directory wine+quality
Moving to wine+quality
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 91353    0 91353    0     0   539k      0 --:--:-- --:--:-- --:--:--  540k
Data downloaded successfully
Zip file found. Renaming to wine+quality.zip
Unzipping...
Archive:  wine+quality.zip
  inflating: winequality-red.csv     
  inflating: winequality-white.csv   
  inflating: winequality.names       
-------------------------------------------------------
 Processing winequality-red.csv...
-------------------------------------------------------
 Feature Index and Names
  1. fixed acidity
  2. volatile acidity
  3. citric acid
  4. residual sugar
  5. chlorides
  6. free sulfur dioxide
  7. total sulfur dioxide
  8. density
  9. pH
 10. sulphates
 11. alcohol
 12. quality
-------------------------------------------------------
Enter desired feature indices, separated by spaces, or press Enter to skip.

Index Feature                    Min     Max    Mean  StdDev
    1 fixed acidity            4.600  15.900   8.314   1.740
    2 volatile acidity         0.120   1.580   0.527   0.179
    3 citric acid              0.000   1.000   0.271   0.195
    4 residual sugar           0.900  15.500   2.537   1.409
    5 chlorides                0.012   0.611   0.087   0.047
    6 free sulfur dioxide      1.000  72.000  15.865  10.454
    7 total sulfur dioxide     6.000 289.000  46.439  32.875
    8 density                  0.990   1.004   0.996   0.002
    9 pH                       2.740   4.010   3.309   0.154
   10 sulphates                0.330   2.000   0.658   0.169
   11 alcohol                  8.400  14.900  10.416   1.065
   12 quality                  3.000   8.000   5.633   0.807
-------------------------------------------------------
 Processing winequality-white.csv...
-------------------------------------------------------
 Feature Index and Names
  1. fixed acidity
  2. volatile acidity
  3. citric acid
  4. residual sugar
  5. chlorides
  6. free sulfur dioxide
  7. total sulfur dioxide
  8. density
  9. pH
 10. sulphates
 11. alcohol
 12. quality
-------------------------------------------------------
Enter desired feature indices, separated by spaces, or press Enter to skip.
3 5 11
Index Feature                    Min     Max    Mean  StdDev
    3 citric acid              0.000   1.660   0.334   0.121
    5 chlorides                0.009   0.346   0.046   0.022
   11 alcohol                  8.000  14.200  10.512   1.230

```
