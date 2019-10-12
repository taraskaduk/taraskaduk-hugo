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

<iframe src="https://public.tableau.com/views/LastFMListeningHistory/View1?:embed=y&:display_count=yes&:origin=viz_share_link:showVizHome=no&:embed=true"
 width="1367" height="780" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
 
 <div class='tableauPlaceholder' id='viz1570839830035' style='position: relative'><noscript><a href='#'><img alt=' ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;La&#47;LastFMListeningHistory&#47;View1&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='path' value='views&#47;LastFMListeningHistory&#47;View1?:embed=y&amp;:display_count=y' /> <param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;La&#47;LastFMListeningHistory&#47;View1&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /></object></div>                <script type='text/javascript'>                    var divElement = document.getElementById('viz1570839830035');                    var vizElement = divElement.getElementsByTagName('object')[0];                    vizElement.style.width='1366px';vizElement.style.height='795px';                    var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>
 
 
Unfortunately, I ran out of time to do more with this data, and would like to publish whatever I've got. I am hoping to come back to it at some point and take a look at some stuff behind the numbers, but for now it's just a Tableau interactive report!

Oh, and the code to get the data with Last FM's API? Here: https://github.com/taraskaduk/lastfm/blob/master/lastfm_api.R
