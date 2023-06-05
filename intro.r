system("cp -u -R ../input/sits-bundle/sits-bundle/* /usr/local/lib/R/site-library/")

library(sits)
library(sitsdata)

# Create a data cube object based on the information about the files
sinop <- sits_cube(
  source = "BDC", 
  collection  = "MOD13Q1-6",
  data_dir = system.file("extdata/sinop", package = "sitsdata"),  
  parse_info = c("X1", "X2", "tile", "band", "date")
)
# Plot the NDVI for the first date (2013-09-14)
plot(sinop, 
     band = "NDVI", 
     dates = "2013-09-14",
     palette = "RdYlGn")


# Show the R object that describes the data cube
sinop

# Load the MODIS samples for Mato Grosso from the "sitsdata" package
library(tibble)
library(sitsdata)
data("samples_matogrosso_mod13q1", package = "sitsdata")
samples_matogrosso_mod13q1[1:2,]


samples_forest <- dplyr::filter(
    samples_matogrosso_mod13q1, 
    label == "Forest"
)
samples_forest_ndvi <- sits_select(
    samples_forest, 
    band = "NDVI"
)
plot(samples_forest_ndvi)


# Select the bands NDVI and EVI
samples_2bands <- sits_select(
    data = samples_matogrosso_mod13q1, 
    bands = c("NDVI", "EVI")
)
# Train a random forest model
rf_model <- sits_train(
    samples = samples_2bands, 
    ml_method = sits_rfor()
)
# Plot the most important variables of the model
plot(rf_model)


# Classify the raster image
sinop_probs <- sits_classify(
    data = sinop, 
    ml_model = rf_model,
    multicores = 2,
    memsize = 8,
    output_dir = "./tempdir/chp3"
)
# Plot the probability cube for class Forest
plot(sinop_probs, labels = "Forest", palette = "BuGn")


# Perform spatial smoothing
sinop_bayes <- sits_smooth(
    cube = sinop_probs,
    multicores = 2,
    memsize = 8,
    output_dir = "./tempdir/chp3"
)
plot(sinop_bayes, labels = "Forest", palette = "Blues")

# Label the probability file 
sinop_map <- sits_label_classification(
    cube = sinop_bayes, 
    output_dir = "./tempdir/chp3"
)
plot(sinop_map, title = "Sinop Classification Map")

# Show the location of the classification file
sinop_map$file_info[[1]]