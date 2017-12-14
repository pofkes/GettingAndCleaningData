# Getting and cleaning data project

The script run_analysis.R downloads and cleans Human Activity Recognition Using Smartphones Data Set from the UCI machine learning depository.

The script downloads files into current working directory's subdirectory - /data. After that creates appropriate data labels, merges training and test datasets, extracts only the mean and standard deviation of the measurements, and aggregates them as the average by subject and activity. Lastly it saves finaldata variable in R's workspace and also saves it as a csv in /data for further analysis.

More information about how the data set and all the variables were constructed and transformed can be found in the CodeBook.md file.
