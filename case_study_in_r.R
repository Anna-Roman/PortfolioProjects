
library(tidyverse)
library(readr)
install.packages("here")
library(here)
#Loading data
dailyActivity_merged <- read_csv("C:/Users/anetr/OneDrive/Documents/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
sleepDay_merged <- read_csv("C:/Users/anetr/OneDrive/Documents/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv")


#Viewing data and checking if data is complete and in correct format
View(dailyActivity_merged)
glimpse(dailyActivity_merged)
View(sleepDay_merged)

#We can see that names of the columns hard to read and date in the column ActivityDate is in the wrong format, character instead of date format
#the column Sleep_Day is also in a wrong format.

#installing packages for cleaning
install.packages("janitor")
library(janitor)
install.packages("skimr")
library(skimr)
library(dplyr)

#making names of the columns more readable and changing format of the column activity_date from character to date. Arranging data  by date in ascending order.
activity <- clean_names(dailyActivity_merged)
View(activity)
daily_activity <- arrange(mutate(activity,mdy_date=mdy(activity_date)), mdy_date)
View(daily_activity)

#checking data for duplicates
sum(duplicated(daily_activity))
#no duplicates
  
#Looking at our new cleaned data 
View(daily_activity)
skim_without_charts(daily_activity)

#Column names are easier to read and all columns are in a correct format

#exploring our data further
summary(daily_activity)
#interesting findings: most of the participants are not very active. we can see in columns 'very_active_minutes' and 'fairly_active_minutes' median is only 4 and 6 minutes respectively. 
#The biggest difference between min and max time spent on activity is in column 'very_active_minutes' also median and mean are quite different.
#average steps per day is around 7400-7600, which is less then recommended. Current guidelines suggest that most adults should aim for about 10,000 steps per day.
#lets visualize our data

# load packages for visualizations
install.packages("ggplot2")
library(ggplot2)

#First lets see daily steps
ggplot(daily_activity, aes(x=mdy_date, y=total_steps))+ geom_point(color='green')+ 
  theme(axis.text.x = element_text(angle = 45))
# here we can clearly see that quite a lot of users move very little, under 10000 steps per day.
# maybe there should be some kind of rewarding system to motivate users to move more, to make it fun.

#Lets check relationship between number of steps and calories
ggplot(daily_activity, aes(x=total_steps, y=calories))+geom_smooth()
#Unsurprisingly we can see strong positive correlation

#cleaning sleepDay_merge data frame
#making names of the columns more readable and changing format of the column sleepDay_merge from character to date. Arranging data  by date in ascending order.

sleep_day_df <- clean_names(sleepDay_merged)
View(sleep_day_df)
sleep_df <- arrange(mutate(sleep_day_df, mdy_date = mdy_hms(sleep_day)), mdy_date)
View(sleep_df)

#checking data for duplicates
sum(duplicated(sleep_df))
# 3 duplicates, time to remove them  
sleep <- unique(sleep_df)
sum(duplicated(sleep))
View(sleep)

#lets look at the relationship between sleep and time spent in bed
ggplot(sleep,aes(x=total_time_in_bed, y=total_minutes_asleep))+geom_point(color="orange")
#we can see strong positive correlation between sleep and time spent in bed with a few outliers. it means for the most part participants didn't have problems with falling asleep.

#merging data
merged <- merge(daily_activity, sleep)
view(merged)

#lets see if there is any correlation between sleep('total_minutes_asleep') and moving during the day('total_steps').  
ggplot(merged, aes(x=total_steps, y=total_minutes_asleep))+geom_smooth()+geom_point()

# Even though line on the plot shows slightly negative  relationship there is no significant correlation between these two variables. 