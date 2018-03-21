library(readr)
library(stringr)
library(tidyverse)
library(rvest)

path <- getwd()
movies_vector <- character()
j<-10
k<-0
i<-0

for(j in 10:9) {
    if (j == 9) k <- 0 else k <- 10
    position <- 0
        
    
    for(i in 0:300){
        url <- paste("http://www.kids-in-mind.com/cgi-bin/listbyrating/search.pl?query=&stpos=", 
                    position, 
                    "&stype=AND&s1=0&s2=10&v1=0&v2=10&p1=",
                    k,
                    "&p2=",
                    j,
                    "&m=1&m=2&m=3&m=4", sep = "")
    
        import <- read_html(url)

        vector <- import %>%
            html_node(".t11normal+ p") %>%
            html_text() %>% 
            str_replace_all('\\\n\\\n', '') %>% 
            str_replace_all('\\[\\[', '[') %>%
            str_replace_all('\\]\\]', ']')
        
            if(j == 9){
                vector <- vector %>% 
                    str_extract_all('([^\\]]* \\[\\d{4}\\] \\[\\S+\\] - [0-9]{1,2}.[0-9]{1,2}.[0-9])')
            } else {
                vector <- vector %>% 
                    str_extract_all('([^\\]]* \\[\\d{4}\\] \\[\\S+\\] - [0-9]{1,2}.[0-9]{1,2}.10)')
            }
        movies_vector <- c(movies_vector,vector[[1]])
    
        position <- position + 34
        if(any(duplicated(movies_vector)) == TRUE) break
    }
    if(any(grepl('Zootopia',movies_vector)) == TRUE) break
}



movies_df <- 
    as_data_frame(movies_vector) %>% 
    separate(value, sep = '\\[', remove = TRUE, into = c('name', 'year', 'rating')) %>% 
    separate(rating, sep = '\\] - ', remove = TRUE, into = c('mcaa', 'rating')) %>% 
    separate(rating, sep = '\\.', remove = TRUE, into = c('sex', 'violence', 'profanity'))

movies_df <- movies_df %>% 
    mutate(
        year = str_replace(movies_df$year, '\\]', ''),
        sex = as.numeric(sex),
        violence = as.numeric(violence),
        profanity = as.numeric(profanity),
        mcaa = factor(mcaa, levels = c('G', 'PG', 'PG-13', 'R', 'NC-17', 'NR'))
        ) 
    

write_csv(movies_df, paste(path,'movies_extract.csv', sep = "/"))
remove(i,j,k, movies_vector, position, url, vector, import)
