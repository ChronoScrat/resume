

# Deauth from Google Sheets - No login required
gs4_deauth()


# Read the data

history <- read_sheet(ss = Sys.getenv("SHEETS_ID"),
                      sheet = "main",
                      col_types = "c")
skills <- read_sheet(ss = Sys.getenv("SHEETS_ID"),
                     sheet = "skills",
                     col_types = "c")
languages <- read_sheet(ss = Sys.getenv("SHEETS_ID"),
                        sheet = "languages",
                        col_types = "c")
contact <- read_sheet(ss = Sys.getenv("SHEETS_ID"),
                      sheet = "contact_info",
                      col_types = "c")

# Parse the data

## Dates

fix_date <- function(dates){
  
  # The ideia is if the date cell is either empty or has text in it (eg.: "current"),
  # we set the date in the future to fix the timeline
  # This is based on `datadrivencv`, but adapted because I can guarantee how the
  # date is being input on Google Sheets.
  
  date_year <- stringr::str_extract(dates, "(20|19)[0-9]{2}")
  date_year[is.na(date_year)] <- lubridate::year(lubridate::ymd(Sys.Date())) + 10
  
  paste("01","01",date_year, sep="-") |> lubridate::dmy()
  
}

## History

history <- history |>
  filter(is.na(purge)) |>
  mutate(
    no_start = is.na(start_date),
    no_end = is.na(end_date),
    has_start = !no_start,
    has_end = !no_end,
    timeline = case_when(
      no_start & no_end ~ "NA",
      no_start & has_end ~ paste(as.character(end_date)),
      has_start & no_end ~ paste("current", "-", as.character(start_date)),
      TRUE ~ paste(as.character(end_date),"-",as.character(start_date))
    ),
    description = ifelse(is.na(description),"",description),
    responsibilities = ifelse(is.na(responsibilities),"",description)
  ) |>
  arrange(desc(fix_date(end_date)))
