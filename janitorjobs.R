install.packages('readxl')
library(readxl)
library(dplyr)
library(tidyr)

# setwd("~/Documents/github/jikyun/data")
sdf <- read_excel("seouluni_donga.xls", col_names=FALSE)
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

###

tdf <- long_sdf
str(long_sdf)

vdf <- tdf %>% filter(new_entry>0) %>% group_by(year, HS_type) %>% summarise(sum = sum(new_entry))
vdf <- vdf %>% spread(year, sum)
str(vdf)

library(ggplot2)

ggplot(vdf) + 
  geom_bar(mapping = aes(x = HS_type))  

diamonds

ggplot(vdf) +
  geom_bar(aes(x=year, y=sum, fill=HS_type), stat ="identity", position ="fill")
