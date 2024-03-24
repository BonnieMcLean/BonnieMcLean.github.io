---
layout: post  
title: Conducting online linguistic research with R Shiny  
image: /assets/img/blog/mogyufuwa.jpg
description: >  
  A quick blog post about my experiences using R Shiny and Google Sheets (free) to conduct online linguistic research. 
sitemap: false  
hide_last_modified: true  
tags: [research, coding, teaching, online_data]  
excerpt_separator: <!--more-->  
---
Back in 2021, I taught a course on 'Doing Linguistic Research with R'. As part of the course the students had to conduct their own linguistic research and analyse the results in R, and I figured out a way that they could use R Shiny to design simple linguistic surveys and collect linguistic data from online participants. 

Shiny is primarily used for displaying data interactively. See for example my Shiny app on [Ideophones in Japan](https://bonnie-mclean.shinyapps.io/ideophonesacrossjapan-eng/). However, I've discovered that you can also use it for running experiments. It's easier than Javascript, and cheaper + more customisable than paying for a service like Qualtrics or Gorilla (though I would still use Gorilla if you want to do more complicated things). 

|                           |Survey software (e.g. Qualtrics)|Javascript/HTML/PHP|Shiny     |
|---------------------------|--------------------------------|-------------------|----------|
|Cost                       |$\$\$                           |Low                |Low/Free* |
|Learning curve             |Low                             |High               |Medium    |
|Customisation              |Low                             |High               |High      |
|Data and stats integration |Low                             |Low                |High      |

*shinyapps.io provides free hosting for up to 5 apps, with up to 25 active hours per month. After that you have to pay a monthly fee to increase the number of apps/active hours per month (the cheapest option is $9/month for 25 apps and 100 active hours)

Pretty much everything you can do with javascript, you can do with shiny, but it has the added advantage of being easier to learn and write (since it's built on R, which most linguists already know). Also, since you're likely to use R for data analysis, it's good to have the data already in a format that R can work with. Running your experiments in RShiny thus simplifies your workflow from data collection > analysis.



