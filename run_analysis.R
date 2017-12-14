#download data 

require(dplyr)
if(!file.exists("./data")){dir.create("./data")}
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/activity.zip")
unzip("./data/activity.zip",exdir = "./data" )

#read features and activity labels

featl<-read.table("./data/UCI HAR Dataset/features.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
acl<-read.table("./data/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE, col.names = c("label", "fullname"), stringsAsFactors = FALSE)

#read train data set and its row attributes

train<-list()
train$data<- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
train$label<- read.table("./data/UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
train$activity<-data.frame(activity = acl$fullname[match( train$label$V1,acl$label)])
train$subject<-read.table("./data/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE, col.names = "subject")

#read test data set and its row attributes

test<-list()
test$data<- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
test$label<- read.table("./data/UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
test$activity<-data.frame(activity = acl$fullname[match(test$label$V1,acl$label)])
test$subject<-read.table("./data/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE, col.names = "subject")

#bind values of two lists

comb<-mapply(rbind, train, test)

#create names with proper format

names(comb$data)<-featl[,2]

#some column names are not unique, thus make.names function is used to create unique names

names(comb$data)<- make.names(names(comb$data), unique = TRUE, allow_ = TRUE)
comb$data<-select(comb$data, matches("mean[^F]|std",ignore.case = FALSE))

#I do not use dplyr's pipeline operator very often, but for the sake of 
#showing what was taught in this course, I used it below to properly format column names

names(comb$data)<-
        names(comb$data) %>%
        tolower()%>%
        gsub("\\.{2,}", "\\.",. ) %>%
        gsub("\\.$", "",.)
#properly formated raw data set will be in raw.data

raw.data<-cbind(comb$subject, comb$activity, comb$data)

#properly formated tidy tada, which includes mean measurement value 
#for every subject and every activity will be in finaldata variable

finaldata<-summarise_all(group_by(raw.data, subject, activity), mean)
#save tidy data as csv

write.csv(finaldata, "./data/finaldata.csv")
#remove working lists to free up workspace
rm(list =ls()[!(ls()=="finaldata"|ls()=="raw.data")] )



