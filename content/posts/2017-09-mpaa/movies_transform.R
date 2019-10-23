# library() -------------------------------------------------------------------

library(readr)
library(stringr)
library(tidyverse)
library(dplyr)
library(rvest)
library(ggrepel)
library(ggthemes)

# Extract -----------------------------------------------------------------

path <- "/Users/Taras_kaduk/Documents/taraskaduk/content/posts/mpaa"

if (file.exists(paste(path,'movies_extract.csv', sep = "/"))) {
  movies_df <- read_csv(paste(path,'movies_extract.csv', sep = "/"))
} else {

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
    separate(rating, sep = '\\] - ', remove = TRUE, into = c('mpaa', 'rating')) %>% 
    separate(rating, sep = '\\.', remove = TRUE, into = c('sex', 'violence', 'profanity'))
  
  movies_df <- movies_df %>% 
    mutate(
      year = str_replace(movies_df$year, '\\]', ''),
      sex = as.numeric(sex),
      violence = as.numeric(violence),
      profanity = as.numeric(profanity),
      mpaa = factor(mpaa, levels = c('G', 'PG', 'PG-13', 'R', 'NC-17', 'NR'))
    ) 
  
  
  write_csv(movies_df, paste(path,'movies_extract.csv', sep = "/"))
  remove(i,j,k, movies_vector, position, url, vector, import)
}



# Transform ---------------------------------------------------------------

movies_df <- movies_df %>% 
  filter(mpaa != 'NR') %>% 
  mutate(avg = (sex + profanity + violence)/3)

movies_df$mpaa <- movies_df$mpaa %>% recode(R = 'R & NC-17', `NC-17` = 'R & NC-17') 
movies_df$mpaa <- factor(movies_df$mpaa, levels = c('G', 'PG', 'PG-13', 'R & NC-17'))
movies_gather <- movies_df %>% 
  gather(key = metric, value = score, c(sex, violence, profanity, avg))


# Graphs -----------------------------------------------------------------


theme <- theme_fivethirtyeight() +
  theme(
  legend.position="none",
  axis.ticks.y=element_blank(),
  panel.grid.major.y = element_line(colour="#e0e0e0",size=40),
  panel.grid.major.x =element_line(colour="#F0F0F0",size=.75),
  panel.grid.minor =element_blank(),
  panel.background=element_rect(fill="#F0F0F0"),
  plot.background=element_rect(fill="#F0F0F0"),
  plot.title=element_text(face="bold", colour="#3C3C3C",size=20),
  plot.subtitle=element_text(face="bold",colour="#3C3C3C",size=12),
  axis.text.x=element_text(size=11,colour="#535353",face="bold"),
  axis.text.y=element_text(size=11,colour="#535353",face="bold"),
  axis.title.y=element_text(size=11,colour="#535353",face="bold",vjust=1.5),
  axis.title.x=element_text(size=11,colour="#535353",face="bold",vjust=-.5),
  plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))



labels_all <- movies_df %>% 
  filter(name == "Jimmy Neutron: Boy Genius" | 
           name == 'Adventures of Elmo In Grouchland, The' |
           name == "Harry Potter and the Half-Blood Prince" |
           name == 'Year One' |
           name == 'Halloween' |
           name == 'Little Rascals, The' |
           name ==  'Life is Beautiful' |
           name == 'King\'s Speech, The'
  )


ggplot(data = movies_df, aes(x=avg, y = mpaa, col = mpaa)) +
  geom_jitter(alpha = 0.2) +
  scale_colour_brewer(palette = "Spectral", direction = -1) +
  geom_point(data = labels_all, size = 3) +
  geom_label_repel(
    data = labels_all,
    aes(label = name),
    size = 3,
    nudge_y = 0.1) +
  ylab('MPAA Rating') + 
  xlab('Average (violence & gore, sex, profanity)') +
  labs(
    title = 'MPAA rating isn\'t everything',
    subtitle = 'On average, there are always movies from a higher category \nthat may be more appropriate') +
  theme


labels_profanity <- movies_df %>% 
  filter(name %in% c('Aladdin',
                'Beethoven',
                'Life is Beautiful',
                'Psycho',
                'Cars',
                'Apollo 13',
                'Nutty Professor, The',
                'Straight Outta Compton')
         )


ggplot(data = movies_df, aes(x=as.factor(profanity), y = mpaa, col = mpaa)) +
  geom_jitter(alpha = 0.2) +
  scale_colour_brewer(palette = "Spectral", direction = -1) +
  geom_point(data = labels_profanity, size = 3) +
  geom_label_repel(
    data = labels_profanity,
    aes(label = name),
    size = 3,
    nudge_y = 0.1) +
  ylab('mpaa Rating') + xlab('Profanity') +
  labs(
    title = '') +
  theme





# G and PG movies violence ------------------------------------------------

labels_g_pg <- movies_df %>% 
  filter(name == "Babe: Pig in the City" | 
           name == "Beauty and the Beast" & mpaa == 'G' |
           name == 'Zeus and Roxanne' |
           name == 'Sleepless in Seattle')

ggplot(data = movies_df %>% filter(mpaa %in% c('PG', 'G')), aes(x=as.factor(violence), y = mpaa, col = as.factor(violence))) +
  geom_jitter(alpha = 0.5, size =3) +
  scale_colour_brewer(palette = "Spectral", direction = -1) +
  geom_point(data = labels_g_pg, size = 5) +
  geom_label_repel(
    data = labels_g_pg,
    aes(label = name),
    size = 4,
    col = 'grey51',
    nudge_x = 1,
    nudge_y = 0) +
  theme +
  theme(axis.text.y = element_text(size = rel(1.2)),
        panel.grid.major.y = element_line(colour="#e0e0e0",size=70)) +
  ylab('mpaa Rating') + xlab('Violence and Gore') +
  labs(
    title = 'That G movie you felt safe about',
    subtitle = 'is probably just as violent as a PG one you rejected')


# R profanity -------------------------------------------------------------

labels_r <- movies_gather %>% 
  filter(metric != 'avg') %>% 
  filter(metric == 'violence' & 
           name %in% c(
             'Sex and the City', 
             'Basic Instinct', 
             'Saw', 
             'Nightmare on Elm Street, A') | 
           metric == 'sex' & 
           name %in% c(
             'Reservoir Dogs', 
             'Love Actually', 
             'Basic Instinct', 
             'American Pie') |
           metric == 'profanity' & 
           name %in% c(
             'Psycho',  
             'Office Space',
             'Pulp Fiction',
             'Old School',
             'Anchorman',
             'Amelie'
           )       
  )


ggplot(
    data = movies_gather %>% 
        filter(
            mpaa == 'R & NC-17' & 
            metric != 'avg'), 
    aes(x=as.factor(score), y = 1, col = mpaa)) +
    geom_jitter(alpha = 0.3, size = 3) +
    scale_colour_manual(values = c('#d7191c')) +
    geom_point(data = labels_r, size = 4,  col = 'black') +
    geom_label_repel(
        data = labels_r,
        aes(label = name),
        size = 3,
        col = 'black') +
    guides(fill = FALSE) +
    xlab('') + ylab('') +
  theme(
    legend.position="none",
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.text.y=element_blank(),
    axis.ticks.y=element_blank()) +
  labs(
    title = 'R and NC-17 Movies aren\'t necessarily violent or vulgar... \nbut they sure as fuck are profane',
    subtitle = 'Most R and NC-17 movies are 5 or more on a profanity scale') +
  facet_grid(metric ~ .)


ggplot(
    data = movies_gather %>% 
        filter(
            mpaa == 'R & NC-17' & 
                metric != 'avg'), 
    aes(x= score, y = ..density..)) +
    geom_histogram(bins = 11, stat = 'bin', col = 'white', fill = '#d7191c') +
    guides(fill = FALSE) +
    xlab('') + ylab('') +
    theme(
      legend.position="none",
      panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank()) +
    labs(
        title = 'R and NC-17 Movies aren\'t necessarily violent or vulgar... \nbut they sure as fuck are profane',
        subtitle = 'Most R and NC-17 movies are 5 or more on a profanity scale') +
    facet_grid(metric ~ .)


# Old junk ----------------------------------------------------------------


# 
# ggplot(data = movies_df, aes(x=as.factor(violence), y = mpaa, col = mpaa)) +
#     geom_jitter(alpha = 0.2) +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     geom_point(data = data_exceptions) +
#     geom_label_repel(
#          data = data_exceptions,
#          aes(label = name),
#          size = 3) +
#     geom_hline(yintercept = 0) +
#     geom_vline(xintercept = 0) +
#     ylab('mpaa Rating') + xlab('Violence and Gore') +
#     labs(
#         title = 'That G movie you felt safe about \nis probably just as violent as a PG one you rejected') 


# +
#     ggsave(filename="viol.png", device = 'png', dpi=600, scale = 1.5)



# movies_df %>% 
#   group_by(mpaa) %>% 
#   filter(avg == max(avg)) %>% 
#   arrange(mpaa)
# 
# movies_df %>% filter(grepl('Harry Potter', movies_df$name) == TRUE)
# movies_df %>% filter(grepl('Star Wars', movies_df$name) == TRUE)
# 

# 
# 
# ggplot(data = movies_df, aes(x=sex, y=violence, alpha = 0.5, col = mpaa)) +
#     geom_jitter() +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     facet_wrap(~ mpaa)
# 
# ggplot(data = movies_df, aes(x=sex, y=profanity, alpha = 0.5, col = mpaa)) +
#     geom_jitter() +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     facet_wrap(~ mpaa)
# 
# ggplot(data = movies_df, aes(x=profanity, y=violence, alpha = 0.5, col = mpaa)) +
#     geom_jitter() +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     facet_wrap(~ mpaa)
# 
# ggplot(data = movies_df, aes(x=profanity, y=violence, alpha = sex, col = mpaa)) +
#     geom_jitter() +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     facet_wrap(~ mpaa)
# 
# ggplot(data = movies_df, aes(x=avg, y = mpaa, col = mpaa)) +
#     geom_jitter(alpha = 0.2) +
#     scale_colour_brewer(palette = "Spectral", direction = -1)
# 
# ggplot(data = movies_df, aes(x=sex, y = mpaa, col = mpaa)) +
#     geom_jitter(alpha = 0.2) +
#     scale_colour_brewer(palette = "Spectral", direction = -1)
# 
# 
# 
# ggplot(data = movies_df, aes(x=as.factor(violence), y = mpaa, col = mpaa)) +
#     geom_jitter(alpha = 0.2) +
#     scale_colour_brewer(palette = "Spectral", direction = -1)
#  
# ggplot(data = movies_gather, aes(x=score, y = metric, col = mpaa)) +
#   geom_jitter(alpha = 0.2) +
#   scale_colour_brewer(palette = "Spectral", direction = -1) +
#   facet_grid(mpaa ~ .)
# 
# ggplot(data = movies_gather, aes(x=score, y = mpaa, col = mpaa)) +
#   geom_jitter(alpha = 0.2) +
#   scale_colour_brewer(palette = "Spectral", direction = -1) +
#   facet_grid(metric ~ .)
# 
# ggplot(data = movies_df, aes(x=as.factor(violence))) +
#   geom_bar() +
#   scale_colour_brewer(palette = "Spectral", direction = -1) +
#   facet_grid(mpaa ~ .)
# 
# ggplot(data = movies_df, aes(x=sex)) +
#     geom_density() +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     facet_grid(mpaa ~ .)
# 
# ggplot(data = movies_df, aes(x=profanity)) +
#     geom_density() +
#     scale_colour_brewer(palette = "Spectral", direction = -1) +
#     facet_grid(mpaa ~ .)
# 
# ggplot(data = movies_df %>% filter(mpaa %in% c('PG', 'G')), aes(x=as.factor(violence), y = 1, col = mpaa)) +
#   geom_jitter(alpha = 0.5) +
#   scale_colour_manual(values = c('#2b83ba', '#abdda4')) +
#   geom_point(data = labels_g_pg, size = 3) +
#   geom_label_repel(
#     data = labels_g_pg,
#     aes(label = name),
#     size = 4) +
#   theme +
#   ylab('mpaa Rating') + xlab('Violence and Gore') +
#   labs(
#     title = 'That G movie you felt safe about \nis probably just as violent as a PG one you rejected') +
#   facet_grid(mpaa ~ .)




# text --------------------------------------------------------------------
# 
# Does mpaa movie rating mean anything?
# Being a parent in modern days is lots of fun. Not only all of us are pretty much winging it, not having any idea what we’re doing (seriously, you need a license to do braids and nails, yet raising a human being a future member of society is a no-brainer, right?) — we are also constantly being watched and judged by other parents.
# When it comes to watching movies with our six-year-old son, we don’t have a strict set of rules. We pretty much fly by the seat of our pants with “I know it when I see it” approach to violence, profanity, or any other content. Not to say that we’re watching Pulp Fiction and Basic Instinct — the most challenging movie to date was probably Alice in the Wonderland — but we pay little attention to the mpaa rating (in our case, it’s always between G and PG. So far)
# That’s why I was interesting to find out that some parents swear by this rating, and use it religiously when deciding what their kids can and can’t watch.
# And it’d be all good if I haven’t noticed that these rating are kind of… arbitrary. So, I decided to dig into the data. Because data will solve all of our problems, right?
# I searched around a bit, and stumbled upon a few awesome things. First, apparently imdb.com has a parental section for every movie. Not sure how to get there with page links, but you go to any movie page, clean up the fluff at the end of the hyperlink and replace it with “/parentalguide” in the end, you’ll get a page with some cool info. For example, here is the page for Pulp Fiction, if you ever wondered if the movie is appropriate to watch with children (hint: it is not): http://www.imdb.com/title/tt0110912/parentalguide
# However, these guides are not standard in the way they are filled out, and scrubbing IMBd for this data wouldn’t get me where I wanted to be fast enough. And then I stumbled upon this awesome website called kids-in-mind.com. It had a lot of info similar or equal to one contained on IMBd.com, but it had a crucial key component: every movie on this website is rated on an 11-point scale, from 0 to 10, on three metrics: sex & nudity, violence & gore, and profanity. Well, this is just perfect! Not only that — it also has that mpaa rating data point, which means I get all of my data in one sitting.
# So, I wrote a little R script using rvest package, and got my data into a tidy dataframe (I’ll post the code on github shortly), and started exploring. After a little bit of data wrangling and running into some obvious things (like, the higher the mpaa rating of the movie, the more likely it is to be rated in all 3 categories), I started to see some interesting narratives worth sharing
