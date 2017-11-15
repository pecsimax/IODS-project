## Pekka Vartiainen, 7.11.2017, Creating a dataset for 2nd assignment ##
library(dplyr)
library(tidyr)

#opening the data:
learn_url <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"
learn_df <- read.table(learn_url, sep="\t", header = TRUE)

#examine the data:
dim(learn_df) # dimensions: 183 rows, 60 columns
str(learn_df) # df of 183 obs, 60 variables incl., mostly of class "int"

# create variables for deep, surface and strategic learning. First, the question names as vectors
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#Then, create new variables that are the means of the question groups
learn_df$deep <- dplyr::select(learn_df, one_of(deep_questions)) %>% rowMeans
learn_df$surf <- dplyr::select(learn_df, one_of(surface_questions)) %>% rowMeans
learn_df$stra <- dplyr::select(learn_df, one_of(strategic_questions)) %>% rowMeans


# final dataset. Selecting the variables, renaming so that there are only small-case letters
learn <- learn_df %>%
  dplyr::select(gender, Age, Attitude, deep, surf, stra, Points) %>%
  rename(age = Age, attitude = Attitude, points = Points) %>%
  filter(points > 0)

#working directory & save
wd_iods <- "/Users/pecsi_max/Desktop/GitHub/IODS-project/data/"
setwd(wd_iods)
write.csv(learn, file = "learning2014.csv", row.names = FALSE)

#testing, if dataset is saved and can be read correcly
tbl_df(read.csv(paste(wd_iods, "learning2014.csv", sep= "")))

