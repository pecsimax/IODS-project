# Pekka Vartiainen, 28.11.2017 #
setwd("/Users/pecsi_max/Desktop/GitHub/IODS-project/data/")
library(stringr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv",
               stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv",
                stringsAsFactors = F, na.strings = "..")


str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# rename variables 
hd_ren <- hd %>% 
       dplyr::rename(hdi_rank = HDI.Rank,
              country = Country,
              hdi = Human.Development.Index..HDI.,
              life_exp = Life.Expectancy.at.Birth,
              edu_exp = Expected.Years.of.Education,
              edu_mean = Mean.Years.of.Education,
              gni = Gross.National.Income..GNI..per.Capita,
              gniasdf = GNI.per.Capita.Rank.Minus.HDI.Rank)
              
# more rename of gii, also computing the two new variables
gii_ren <- gii %>% tbl_df %>% dplyr::rename(gii_rank = GII.Rank,
                                     country = Country,
                                     gii = Gender.Inequality.Index..GII.,
                                     mat_mort_ratio = Maternal.Mortality.Ratio,
                                     ado_birthr = Adolescent.Birth.Rate,
                                     parli_f = Percent.Representation.in.Parliament,
                                     edu2_female = Population.with.Secondary.Education..Female.,
                                     edu2_male = Population.with.Secondary.Education..Male.,
                                     labour_part_female = Labour.Force.Participation.Rate..Female.,
                                     labour_part_male = Labour.Force.Participation.Rate..Male.) %>%
  mutate(edu_ratio = (edu2_female / edu2_male),
         part_ratio = labour_part_female / labour_part_male)

#join the two datasets. It has 195 rowns and 19 variables, yey!
human <- inner_join(hd_ren, gii_ren, by = "country")

#change gni to numeric
human$gni <- as.numeric(stringr::str_replace(human$gni, ",", ""))

#variables we want to keep
keepers <- c("country", "edu_ratio", "part_ratio", "edu_exp", "life_exp", "gni",
             "mat_mort_ratio", "ado_birthr", "parli_f")

human_ <- dplyr::select(human, one_of(keepers))

#using the which -function to produce indices for row numbers
human_ <- human_[which(complete.cases(human_)),]

#it appears that the last 7 rows are regions instead of countries
human_$country
human <- human_[1:(nrow(human_) - 7),]

#set country names to row names
names <- human$country
rownames(human) <- names


#Drop the country variable and confirm that we have a 155 x 8 dataset
human <- dplyr::select(human, -country)
dim(human)

write.csv(human, file = "human")

