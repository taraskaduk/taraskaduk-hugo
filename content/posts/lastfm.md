---
title: "Analyzing 11 years of my personal music listening history"
author: Taras Kaduk
date: '2019-10-11'
slug: lastfm
tags:
  - r
  - tableau
aliases:
    - /posts/lastfm
---

I recently got around to look at some data I've been collecting for a long-long time. The data comes from the service called Last.fm, which tracks your music listening history and offers a host of recommendations based on such habits and your friends' activity. The service has been around for a long time, and I initially signed up for it in 2007, and has been deliberate about tracking my music since then. That makes it over 11 years of data to look at!

I used a service that helped me get the initial large chunk of data out fast:  https://mainstream.ghan.nl/export.html. After that, I wrote a little R script that would pull the most recent listening history using Last FM API, then use a bit of MusicBrainz API to enhance the data, and back to Last FM API to extract tags (genres) by artist.

I built a quick Tableau dashboard to explore my results:

<iframe src="https://public.tableau.com/views/LastFMListeningHistory/View1?:showVizHome=no&:embed=true"
 width="500" height="780" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
 
 
Unfortunately, I ran out of time to do more with this data, and would like to publish whatever I've got. I am hoping to come back to it at some point and take a look at some stuff behind the numbers, but for now it's just a Tableau interactive report!

Oh, and the code to get the data with Last FM's API? Here: https://github.com/taraskaduk/lastfm/blob/master/lastfm_api.R
