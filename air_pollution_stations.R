#load packages
library(ggplot2)
library(maps)

#data available from https://uk-air.defra.gov.uk/data/data_selector_service
air_data <- read.csv("25078932314.csv", header=T)
station_names <- colnames(air_data)[c(-1,-2)][-84]
write.table(station_names, "station_names.txt", row.names=FALSE, sep=",", col.names=FALSE)
#use https://www.gpsvisualizer.com/geocoder/ to obtain latitude and longitude 
coord <- read.table("coordinates.txt", row.names=NULL, sep=",") 
coord_df <- data.frame(station_names = station_names, lat = as.numeric(coord[,1]), lon = as.numeric(coord[,2]))

#plot of monitoring sights
worldmap = map_data('world')
p <- ggplot() + 
  geom_polygon(data = worldmap, aes(x = long, y = lat, group = group), fill = '#CFDBC5', color = 'black') + 
  coord_fixed(ratio = 1, xlim = c(-11,4), ylim = c(49, 61)) + 
  geom_point(data = coord_df, aes(x = lon, y = lat), size=3, colour = "#336600") + 
  theme_void() + 
  labs(title = "  Air Pollution Monitoring Stations in the UK") +
  theme(plot.title = element_text(colour = "#336600", size=22, face="bold"))
p
ggsave(p, filename = "stations_map.jpg", height=7.16, width=8.44, units="in")

#plot Aberdeen site 
coord_df$station_colour <- factor(c(rep(1,3), rep(2, nrow(coord_df)-3)))
p <- ggplot() + 
  geom_polygon(data = worldmap, aes(x = long, y = lat, group = group), fill = '#CFDBC5', color = 'black') + 
  coord_fixed(ratio = 1, xlim = c(-11,4), ylim = c(49, 61)) + 
  geom_point(data = coord_df, aes(x = lon, y = lat,  colour = station_colour), size=3) + 
  scale_colour_manual("", values=c("1"="red", "2"="#336600")) +
  annotate("text", x = 2, y = 58, label = "Aberdeen", size=6) +
  geom_segment(aes(x = -1.8, y = 57.14, xend = 0.7, yend = 57.9), size=1) +
  theme_void() + 
  labs(title = "  Air Pollution Monitoring Stations in the UK") +
  theme(plot.title = element_text(colour = "#336600", size=22, face="bold"),
        legend.position="none")
p
ggsave(p, filename = "Aberdeen_stations_map.jpg", height=7.16, width=8.44, units="in")


