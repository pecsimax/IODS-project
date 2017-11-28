# Pekka Vartiainen, 28.11.2017 #
setwd("/Users/pecsi_max/Desktop/GitHub/IODS-project/data/")

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
hd_ren <- hd %>% tbl_df %>% 
       rename(hdi_rank = HDI.Rank,
              country = Country,
              hdi = Human.Development.Index..HDI.,
              life_exp = Life.Expectancy.at.Birth,
              edu_exp = Expected.Years.of.Education,
              edu_mean = Mean.Years.of.Education,
              gni = Gross.National.Income..GNI..per.Capita,)
              
# more rename of gii, also computing the two new variables
gii_ren <- gii %>% tbl_df %>% rename(gii_rank = GII.Rank,
                                     country = Country,
                                     gii = Gender.Inequality.Index..GII.,
                                     mat_mort_ratio = Maternal.Mortality.Ratio,
                                     birthrate = Adolescent.Birth.Rate,
                                     repr_percentage = Percent.Representation.in.Parliament,
                                     edu2_female = Population.with.Secondary.Education..Female.,
                                     edu2_male = Population.with.Secondary.Education..Male.,
                                     labour_part_female = Labour.Force.Participation.Rate..Female.,
                                     labour_part_male = Labour.Force.Participation.Rate..Male.) %>%
  mutate(edu_ratio = (edu2_female / edu2_male),
         part_ratio = labour_part_female / labour_part_male)

#join the two datasets. It has 195 rowns and 19 variables, yey!
human <- inner_join(hd_ren, gii_ren, by = "country")

#save the file
write.csv(human, file = "human.csv")
