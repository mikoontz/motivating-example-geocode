This repository contains a short, motivating example of a reproducible workflow. The exercise is entitled "Where are we coming from and where are we going?"

It is intended to be the first exercise in a Carpentries-esque workshop or course and is designed to accomplish several goals at once:

1. Motivate learners about the kinds of things we can do with a flexible, reproducible workflow
1. Connect learners to the material and to each other by having their own "data" (their hometowns) used in an interesting way
1. Demonstrate the interactive structure of the workshop (including using a collaborative document and embracing sticky notes)

# Guide to running this exercise:

## Setup

1. Clone this repository to the computer you are using to present
1. Create a collaborative document using, for example, Etherpad or Google Docs
1. Make sure the collaborative document is available to everyone for editing
1. Have a link to the collaborative document accessible-- either on the course website that everyone can find, or use a URL shortening service (e.g., tinyurl.com) to make a short URL that learners will be able to copy into their browser's location bar
1. Make sure you have a spreadsheet application that can save files in a `.csv` format
1. In the `dc_origins.R` file, be sure to change the `currentLocation` object so that it represents the workshop location. The object should be a character string.

## Execution

1. Tell learners to put all sticky notes down on the side of their computer
1. Each student should open up the collaborative document, add their name to the list, and write down their hometown (as though they're searching Google Maps) on a separate line
1. Green sticky notes up when finished; red sticky notes up if help is needed
1. Instructor will copy the column of hometowns, open a spreadsheet program, paste the data inside, and add the column header "location". Feel free to add additional columns if you wish (student ID, for instance) to mimic more realistic data.
1. Instructor will save the file as `dc_origins.csv` inside the `motivating-example-geocode` project folder
1. Instructor will open the `motivating-example-geocode.Rproj` project and open the `dc_origins.R` file.
1. Highlight all of the `dc_origins.R` code and run it
1. Tell students not to focus on the details of this code, but let it wash over them to get a feel for what is possible and what they'll learn to piece something like this together
1. Give a brief description the code will import the data we just generated: interact with online service (Google Maps or DataScienceToolkit) to "geocode" each hometown-- get its latitude and longitude, plot the locations on a world map, draw a line from hometowns to current workshop location, then save that world map as an image file.

## Notes

1. I'd like to better incorporate feedback to use this motivating exercise as a way to orient learners (see related slides regarding Bloom's, metacognition, and sustainable learning: https://www.academia.edu/35830333/Short-_and_long-_form_training_lessons_from_education_and_cognitive_science_for_effectiveness_)
1. I'm considering adding a level of complexity to this to generate an interactive map with leaflet or some such. This would add an additional (perhaps unnecessary) 'wow' factor, but would also allow me to zoom in on a smaller segment of the world if it turns out that everyone is from a small geographic extent and the plot isn't that impressive.
