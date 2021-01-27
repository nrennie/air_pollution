<h1 align="center">
Air Pollution Analysis
</h1>

During my PhD, my research focused on developing methods to identify outlier demand in booking patterns for trains in railway networks. To demonstrate that these statistical methods are also applicable in other areas, I started to analyse air pollution data across the United Kingdom. The aim is to identify days with abnormal pollution levels. The data comes from Defra's Automatic Urban and Rural Network (AURN), which reports the level of nitrogen dioxide in the air every hour at 187 different locations. The data can be downloaded from [uk-air.defra.gov.uk/data/data_selector_service](https://uk-air.defra.gov.uk/data/data_selector_service). For this analysis, I considered data from 2014 to 2018.

<p align="center">
<img src="https://github.com/nrennie/air_pollution/blob/main/Images/Aberdeen_stations_map.jpg?raw=true" width="50%">
</p>

I started by considering the data in a single station - Aberdeen. The nitrogen dioxide levels follow a similar pattern each day, with higher levels around rush hour in the morning and evening. 

Functional analysis treats the pollution pattern for each day as an observation of a function over time. This allows us to compare the differences between patterns on different days, without complications from the varying pollution levels throughout each day.

<p align="center">
<img src="https://github.com/nrennie/air_pollution/blob/main/Images/Aberdeen.jpg?raw=true" width="50%">
</p>

The higher levels of pollution around 8am and 6pm are most likely caused by people travelling to work. This raises the question of whether pollution levels are lower on weekends, when there are generally fewer people travelling to work. I considered whether there were different pollution patterns on different days of the week, specifically weekdays vs. weekends. 

To test this formally, a functional ANOVA test can be applied. This tests whether the average pollution pattern on a weekday is significantly different from the avergage pollution pattern on a weekend. The test returns the probability that, if the two pollution patterns were equal, the observed patterns would be this different. For this analysis, the probability was 0. Therefore, we can conclude there is a significant difference in the pollution levels on weekdays compared to weekends. We will analyse weekdays and weekends separately. 

<p align="center">
<img src="https://github.com/nrennie/air_pollution/blob/main/Images/Aberdeen_weekend.jpg?raw=true" width="50%">
</p>

To describe how normal (or abnormal) the pollution pattern for each day is, we calculate the functional depth. A depth measurement attributes a sensible ordering to observations, such that observations which are close to average have higher depth and those far from the average have lower depth. Days which have very low depth can be classified as outliers. Functional depth takes into account the abnormality both in the magnitude (for example, overall higher pollution levels throughout the day), and shape (for example, pollution levels peak earlier in the day than normal) of the pollution pattern.

<p align="center">
<img src="https://github.com/nrennie/air_pollution/blob/main/Images/Aberdeen_depths_weekend.jpg?raw=true" width="50%">
</p>

A threshold is then calculated for the functional depths. If the functional depth for a given day is below that threshold, the day is classified as an outlier.

<p align="center">
<img src="https://github.com/nrennie/air_pollution/blob/main/Images/Aberdeen_outliers.jpg?raw=true" width="50%">
</p>

The days which were detected as outliers in this analysis occur around early November, late December, and early January. Although this may suggest there are seasonal trends with generally higher pollution levels in winter, further investigation found this not to be the case. One possible explanation	for why these dates were classified as having outlying levels of nitrogen dioxide, is fireworks. Fireworks are commonly set off on Bonfire Night, around Christmas, and New Year's Eve. Fireworks have been shown to contribute to elevated levels of gaseous pollutants, including nitrogen dioxide.

<h3 align="center"> 
Part 2 coming soon!
</h3> 

<div align="center"> 
The code for this project can be found at: [github.com/nrennie/air_pollution](https://github.com/nrennie/air_pollution) 
</div>

