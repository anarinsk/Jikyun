#### Packages innstalled
#pck_list <- c("readxl", "dplyr", "tidyr", "ggplot2")
#install.packages(pck_list)
#rm(pck_list)
#### End of "Packages innstalled"

library(readxl)
library(dplyr)
library(tidyr)

#### Making sdf 

#for MAC OS 
# setwd("~/Documents/github/jikyun/data") 
#for Windows 
# setwd("~/GitHub/Jikyun")

sdf <- read_excel("data/seouluni_donga.xls", col_names=FALSE)
sdf <- tbl_df(sdf)
sdf <- sdf %>% slice(4:n()) %>% select(2:14)
colnames <- sdf[1,]; 
colnames[1] <- "HS_name"; colnames[2] <- "HS_type"; colnames[3] <- "HS_region"; 
for (k in c(4:13))
{
  colnames[k] <- paste("Y",colnames[k],sep="")
}

sdf <- sdf[-1,] 
names(sdf) <- colnames
long_sdf <- sdf %>% gather(year, new_entry, Y2008:Y1999)

### End of "Making sdf" 

### Making tables 
### tdf: temp working df 

tdf <- long_sdf
str(long_sdf)

gdf_1 <- tdf %>% filter(new_entry>0) %>% group_by(year, HS_type) %>% summarise(sum = sum(new_entry))
gdf_2 <- function(x){tdf %>% filter(new_entry>0) %>% filter(year %in% x)} %>% arrange(new_entry)

library(ggplot2)

### Font setting

#install.packages("extrafont")
library(extrafont)
#font_import()
#loadfonts()
fonts()

#### Bar plot with share 
tgdf <- gdf_1 
ggplot(tgdf) +
  geom_bar(aes(x=year, y=sum, fill=HS_type), stat ="identity", position ="fill") + 
  ggtitle("서울대 신입생 고교 종류별 비율") + 
  xlab("연도") + ylab("비율") +
  theme(
    text = element_text(family="NanumBarunGothic"))

my_hist <- function(df, my_year)
  {
  tyear <- paste("Y", my_year, sep="")
  fdf <- df %>% filter(new_entry>0 & new_entry<=20) %>% filter(year %in% tyear) %>% arrange(new_entry); 
  res <- ggplot(fdf) + 
    theme_bw() + 
    ggtitle("Distribution of SNU Freshmen (from 1999 to 2008)") + 
    geom_histogram(aes(new_entry), binwidth = 0.5, fill="green") + 
    xlim(c(0,20)) + ylim(c(0,300)) + 
    xlab("# of SNU fresh in high school") + ylab("count") + 
    theme(text=element_text(family="NanumBarunGothic"))
  
  return(res)
  }


my_hist(tdf, 1999)
my_hist(tdf, 2008)

### Finalize for Shiny 


