## Pekka Vartiainen, 14.11.2017, wrangling a dataset for logistic regression excercise in IODS. 
## The source of data is: Paulo Cortez, University of Minho, GuimarÃ£es, Portugal, http://www3.dsi.uminho.pt/pcortez 


setwd("/Users/pecsi_max/Desktop/GitHub/IODS-project/data/")

#tiedostopolut
path_mat <- "/Users/pecsi_max/Desktop/GitHub/IODS-project/data/student-mat.csv"
path_por <- "/Users/pecsi_max/Desktop/GitHub/IODS-project/data/student-por.csv"


mat <- read.csv2(path_mat)
por <- read.csv2(path_por)

glimpse(mat)
colnames(mat)
glimpse(por)
colnames(por)

#name the common columns to be used when joining the two datasets
join_by <- c("school", "sex", "age", "address", "famsize",
             "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", 
             "nursery", "internet")


# join the two datasets by the selected identifiers
math_por <- inner_join(mat, por, by = join_by, suffix = c(".mat", ".por"))




# create a new data frame with only the joined columns. This is to allow us to modify other columns, in order to change the 
# non-idential answers
colnames(math_por)
alc <- dplyr::select(math_por, one_of(join_by))
colnames(alc)

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]
notjoined_columns

# The For-loop -solution from datacamp
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- dplyr::select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- dplyr::select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}


#create alc-use, the average alcohol consumption
colnames(alc)
alc <- alc %>%
  mutate(alc_use = (Walc+Dalc) / 2) %>%
  mutate(high_use = (alc_use > 2))

glimpse(alc)

write.csv(alc, file = "alcohol")

# yey! it's a data of 382 x 52 :)