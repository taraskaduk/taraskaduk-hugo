---
title: Where are the places with the best (and the worst) weather? 2020 Edition
author: Taras Kaduk
date: '2019-01-02'
slug: weather2
tags: [ggplot, maps, geospatial, r]
draft: true
comments: true
---

Last year, I wrote a blog post titled ["Where are the places with the best (and the worst) weather in the United States"](https://taraskaduk.com/2019/02/18/weather/), which was the result of my endless weather data analysis that I conducted in spare time. It proved to be a bit popular for a quick second, which I was very proud of. I later saw my code re-used for a similar weather data viz and posted on r/dataisbeautiful subreddit, which inspired me to post some of my own visuals there... And so I registered on Reddit and posted two things [here](https://www.reddit.com/r/dataisbeautiful/comments/byjies/top_25_world_cities_with_most_pleasant_days_in_a) and [here](https://www.reddit.com/r/dataisbeautiful/comments/bybovm/us_cities_with_most_pleasant_weather_days_in_a/). I did not expect this many comments, both kind and not-so-much ones.




## Updated methodology

1. I start with a list of all world cities and their respective coordinates and population. I found a good source of data here: https://simplemaps.com/
2. For U.S. cities specifically, I also aggregate them into Combined Statistical Areas (one frequent complaint from the Redditors last year was that cities that are literally next to each other are ranked separately. For U.S. cities, I can solve for it by using CSAs instead of incorporated cities. Unfortunately, there is no such easy fix for every city in the world)
3. I then filter out any city that has fewer than 500,000 people living in it. This helps me control the runtime of the computation, as well as get rid of a lot of noise in the data (satellite cities next to big cities), and keep the chosen few climate groups around the world from dominating the charts.
4. For each of the cities of interest, I get weather station data within a 50 km radius for every day for the past 10 years.
5. I proceed by aggregating the data by city by day, finding the average of every weather metric and weighing it according to the distance from the city (stations closest to a city would get more weight)
6. If there are any missing days left in the data set after aggregating the weather data from several stations for every city, I apply a fairly simple `knnreg` model to "predict" the data for the missing days based on the day of the year and the year itself. 
7. With this completed data set, I apply the heat index and wind chill formulas to construct something like a poor man's "feels like" temperature (with the limited data I have on hand)
8. Finally, I classify every day for every station into one of "pleasant / elements / hot / cold / hot & elements / cold & elements" categories, rank the cities by the average count of pleasant days, and visualize the data.

If you still need more details on the methodology, the code is always available here: https://github.com/taraskaduk/weather