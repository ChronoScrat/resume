# Utility functions


# Print Section in HTML Resume

print_section <- function(section_name){
  
  tmp <- history |>
    filter(section == section_name)
  
  template <- "
  ### {title}
  
  {institution}
  
  {location}
  
  {timeline}
  
  {description}
  
  {responsibilities}
  
  "
  
  print(glue::glue_data(tmp, template))
  
}

# Print contact information in HTML resume

print_contact <- function() {
  
  glue_data(
    contact,
    "- <i class='fa fa-{icon}'></i> {value}"
  ) |> print()
  
  invisible(contact)
}