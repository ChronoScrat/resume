# This file contains all functions to generate a resume by extracting data from
# a google sheets input. It is based on the [[PACKAGE]](LINK).

# Libraries

library(googlesheets4)
library(stringr)
library(dplyr)
library(lubridate)
library(glue)


# Google Sheets deauth

googlesheets4::gs4_deauth()


# Read sheets

sheet_id = "1BnID3LW-DYHzQkzJAg04yEBCILDBBKk1-JRFeYF2Y1s"

resume <- list()

resume$main <- read_sheet(ss = sheet_id, sheet = "main", col_types = "c")
resume$skills <- read_sheet(ss = sheet_id, sheet = "skills", col_types = "c")
resume$languages <- read_sheet(ss = sheet_id, sheet = "languages", col_types = "c")
resume$contact <- read_sheet(ss = sheet_id, sheet = "contact_info", col_types = "c")

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
  mutate(
    no_start = is.na(start_date),
    no_end = is.na(end_date),
    has_start = !no_start,
    has_end = !no_end,
    #parsed = parse_date(end_date),
    timeline = case_when(
      no_start & no_end ~ "NA",
      no_start & !no_end ~ paste("<span>", as.character(end_date),"</span>"),
      !no_start & no_end ~ paste("current", "-", as.character(start_date)),
      TRUE ~ paste("<span>", end_date,"</span><span>", start_date,"</span>")
    ) 
  ) |> 
  arrange(desc(parse_date(end_date)))

################################################################################

# Prints blocks

## Prints the sections

print_section <- function(section_name){
  
  template <- ""
  
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
