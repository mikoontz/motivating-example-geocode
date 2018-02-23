#### Title: Where we're coming from and where we're going

#### Estimated time: 5-10mins

#### Objectives
# 1) Have students demonstrate etherpad proficiency
# 2) Have students demonstrate sticky note proficiency
# 3) Demonstrate flexibility and efficiency benefits of programmatic approach
# 4) Demonstrate data visualization benefits of the language of choice (here, R)
# 5) Connect learners personally to each other, this workshop, and coding
# 6) (optional) Demonstrate dynamic documents capabilities of R

#### Instructions
# 1) All sticky notes down
# 2) Each student should open up the etherpad, add their name to the list,
#   and write down their hometown (as though they're searching Google Maps) on a
#   separate line
# 3) Green sticky notes up when finished; red sticky notes up if help is needed
# 4) Instructor will copy the column of hometowns, open a spreadsheet program,
# paste the data inside, and add the column header "location". Feel free to add
# additional columns if you wish (student ID, for instance). 
# 5) Instructor will save the file as "dc_origins.csv" inside the appropriate
#   working directory
# 6) Project is set up ahead of time in directory with the dc_origins.R file.
# 7) Tell students not to focus on the details of this code, but let it wash
#   over them to get a gestalt sense of where we are coming from and where we
#   are headed
# 8) Give a brief description the code will import the data we just generated,
#   interact with Google Maps to "geocode" each hometown-- get its latitude
#   and longitude, plot the locations on a world map, then save that world map
#   as an image file.

# Load necessary packages
library(tidyverse)
library(viridis)
library(geosphere)
library(ggmap)
# library(plotly)
# library(htmlwidgets)

# What is the current location of the workshop?
currentLocation_str <- "Davis, California"
source <- "dsk"

currentLocation <- geocode(currentLocation_str, source = source)
# source <- "google"

# Import the data
learners <- read_csv("dc_origins.csv")

# Use the mutate_geocode() function in the ggmap package on that new column to 
# add new columns to the dataframe representing the longitude and latitude of
# each learner's hometown as a result of a Google Maps lookup.
# [For instance, if your hometown is "Davis, California", the mutate_geocode() 
# function will return -121.7405 in the "lon" column and 38.54491 in the "lat"
# column]
# Remove any rows that fail to geocode. Sorry!

learners <- 
  learners %>%
  as.data.frame() %>%
  mutate_geocode(location, source = source) %>%
  filter(complete.cases(.))

# Use the gcIntermediate() function from the geosphere package to get points
# representing the Great Circle paths between each learner's hometown and the
# current location of the workshop.
gcPoints <- 
  gcIntermediate(p1 = learners[, c("lon", "lat")], 
                 p2 = currentLocation[, c("lon", "lat")],
                 breakAtDateLine = TRUE
                )

# Loop through each Great Circle path and assign each a unique identifier. If
# the Great Circle passes the International Date Line, each segment on either
# side of the Date Line needs to get it's own group identifier so it can be
# plotted separately. In these cases, assign each of the 2 segments a unique
# id, then bind the 2 list elements into a single data frame. If the Great
# Circle does *not* cross the International Date Line, add the unique identifier
# and coerce the list element into a data frame (from a matrix). Ensure all
# column names for each list element data frame have the same names.

for (i in seq_along(gcPoints)) {
  currentPath <- gcPoints[[i]]
  if(is.list(currentPath)) {
    currentPath[[1]] <- data.frame(currentPath[[1]], 
                                   path = paste0(i, ".1"), 
                                   stringsAsFactors = FALSE)
    currentPath[[2]] <- data.frame(currentPath[[2]], 
                                   path = paste0(i, ".2"), 
                                   stringsAsFactors = FALSE)
    currentPath <- bind_rows(currentPath)
  } else {
    currentPath <- data.frame(currentPath, 
                              path = paste0(i), 
                              stringsAsFactors = FALSE)
  }
  colnames(currentPath) <- c("lon", "lat", "path")
  gcPoints[[i]] <- currentPath
}

# Combine the list of data frame elements into a single dataframe, since we know
# each list element data frame has the same number of columns and the same
# column names
gcPoints <- bind_rows(gcPoints)

# Create a plot of the locations of each student's email_affiliation on a globe 
# by mapping the longitude to the x position on the plot, and the latitude to
# the y position on the plot. Use the borders() function from ggplot2 to 
# generate a rough sketch of the land masses on Earth. Color all the points red
# and make them twice as large as default. Ensure that the figure has a 1:1
# ratio between units on the x-axis and units on the y-axis.
dc_origins <- ggplot() + 
  borders("world", colour = "gray50", fill = "gray50")  +
  geom_point(data = learners, aes(x = lon, y = lat, color = location), size = 2) +
  scale_color_viridis(discrete = TRUE) +
  coord_equal() +
  geom_line(data = gcPoints, aes(x = lon, y = lat, group = factor(path)), color = "red")

# Visualize the plot that we just made
# ggplotly(dc_origins)
# htmlwidgets::saveWidget(as_widget(ggplotly(dc_origins)), "dc_origins.html")

# Save the plot we made as a .png file to our working directory while
# specifiying its height and width
ggsave(plot = dc_origins,
       filename = "dc_origins.png",
       device = "png",
       units = "cm",
       width = 20,
       height = 12)