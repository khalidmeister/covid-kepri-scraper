# install.packages(c("ggspatial", "tidyverse", "sf"))
library(ggspatial)
library(tidyverse)
library(sf)

# Map Data for Riau Island
indo_2 <- st_read("D:/Temporary/art/for-riau-map/gadm36_IDN_2.shp")
wilayah <- c("Batam", "Bintan", "Karimun", "Kepulauan Anambas", "Lingga", "Natuna", "Tanjung Pinang")
kepri <- indo_2 %>% filter(NAME_1 == "Kepulauan Riau") %>% mutate(wilayah = wilayah)

# COVID-19 Recap Data
kepri_covid <- read_csv("D:/my-projects/covid-kepri-tracker/kepri.csv")

# Get the coordinates
kepri_coor <- as.data.frame(st_coordinates(st_centroid(kepri)))
kepri_coor$wilayah <- kepri$wilayah

# Join the datasets
kepri_recap <- kepri %>%
  inner_join(kepri_coor, by = "wilayah") %>%
  inner_join(kepri_covid, by = "wilayah")

# Visualize
ggplot(kepri_recap) +
  geom_sf(aes(fill=NAME_2)) +
  geom_label(aes(x = X, y = Y, label = total_positif), size = 2.5) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "br", which_north = "true", pad_x = unit(0.25, "in"), pad_y = unit(0.25, "in"), style = north_arrow_fancy_orienteering) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = gray(0.5), linetype = "dashed", size = 0.5),
    panel.background = element_rect(fill = "aliceblue")    
  ) +
  labs(
    x = "Longitude",
    y = "Latitude",
    title = "Peta Sebaran COVID-19 di Kepulauan Riau",
    subtitle = paste("Per tanggal ", Sys.Date(), ". Sumber data (corona.kepriprov.go.id)"),
    fill = "Kota / Kabupaten"
  )
  