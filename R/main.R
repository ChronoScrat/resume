#' Resume
#' 
#' This project is heavely based on the `datadrivencv` R package, but with a number
#' of modifications.
#' 
#' Three outputs are expected: (1) An HTML resume, which can be accessed from the
#' browser and printed; (2) a DOCX resume, better suited for Application Tracking
#' Systems (ATS); and (3) a PDF version of the DOCX resume.
#' 

# Libraries
library(googlesheets4)
library(dplyr)
library(stringr)
library(lubridate)
library(glue)


# Read the environment if not on Github Actions

if(nzchar(Sys.getenv("CI")) == FALSE){
  dotenv::load_dot_env()
}

# Create Output folder if it doesn't exist

if(!dir.exists("output")){
  dir.create("output")
}

# Load the data

source(file = "R/etl.R")
source(file = "R/utils.R")



# Render the HTML resume

rmarkdown::render(input = "RMD/html_resume.Rmd",
                  output_file = "index.html",
                  output_dir = "output",
                  envir = parent.frame())

# Render DOCX version

rmarkdown::render(input = "RMD/ats_resume.Rmd",
                  output_file = "resume.docx",
                  output_dir = "output",
                  envir = parent.frame())

# Render PDF version