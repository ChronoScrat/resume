#' This file contains the necessary code to generate the full resume. It is
#' based on the codebase for the datadrivencv package, and adapted according to
#' necessity.

# Libraries
library(googlesheets4)
library(stringr)
library(dplyr)
library(lubridate)
library(glue)


# Environment

if(Sys.getenv("SHEETS_ID") == ""){
  dotenv::load_dot_env()
}

# Google Sheets Deauth - used to bypass the need for a token or an explicit login
gs4_deauth()


# Read sheets

resume <- list()

resume$main <- read_sheet(ss = Sys.getenv("SHEETS_ID"), sheet = "main", col_types = "c")
resume$skills <- read_sheet(ss = Sys.getenv("SHEETS_ID"), sheet = "skills", col_types = "c")
resume$languages <- read_sheet(ss = Sys.getenv("SHEETS_ID"), sheet = "languages", col_types = "c")
resume$contact <- read_sheet(ss = Sys.getenv("SHEETS_ID"), sheet = "contact_info", col_types = "c")

################################################################################

# Sanitize data

## Parse the dates

parse_date <- function(dates){
  
  # Get year: make sure the year starts with either 19 or 20 
  date_year <- stringr::str_extract(dates, "(20|19)[0-9]{2}")
  
  # If there is no match (current or blank), set the year to the future (sorting)
  date_year[is.na(date_year)] <- lubridate::year(lubridate::ymd(Sys.Date())) + 10
  
  # Get Month: it may be either in numeric or alphabetic form
  date_month <- stringr::str_extract(dates, "(\\w+|\\d+)(?=(\\s|\\/|-)(20|19)[0-9]{2})")
  
  # As with the years, if there is no month, set it to Jan (irrelevant)
  date_month[is.na(date_month)] <- "1"
  
  # Finally concatenate the entire date
  paste("1", date_month, date_year, sep = "-") %>%
    lubridate::dmy()  
  
}

## Restructure the main data

resume$main <- resume$main |>
  filter(is.na(purge)) |>
  mutate(
    no_start = is.na(start_date),
    no_end = is.na(end_date),
    has_start = !no_start,
    has_end = !no_end,
    timeline = case_when(
      no_start & no_end ~ "NA",
      no_start & !no_end ~ paste(as.character(end_date)),
      !no_start & no_end ~ paste("current", "-", as.character(start_date)),
      TRUE ~ paste(end_date,"-", start_date)
    ) 
  ) |> 
  arrange(desc(parse_date(end_date)))

################################################################################

# Prints blocks

## Prints the sections

print_section <- function(section_name){
  
  template <- "
  ### {title}
  
  {institution}
  
  {location}
  
  {timeline}
  
  {description}
  
  {responsibilities}
  
  "
  
  tmp_data <- resume$main |> filter(section == section_name)
  
  print(glue_data(tmp_data, template))
  
}


## Prints contact info

print_contact <- function() {
  
  glue_data(
    resume$contact,
    "- <i class='fa fa-{icon}'></i> {value}"
  ) |> print()
  
  invisible(resume)
}
