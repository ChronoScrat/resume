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

# Print Section in DOCX resume

print_section_docx <- function(section_name){
  
  tmp <- history |>
    filter(section == section_name)
  
  template <- "
  
  <table style='width:100%;'>
    <tr style='width:100%'>
      <td style='width:70%'>{title}</td>
      <td>{timeline}</td>
    </tr>
  </table>
  
  ETC ETC
  
  | **{title}** - {institution} | {timeline} |
  | ----------- | :--------: |
  | {description} | |
  | {responsibilities} | |
  
  "
  
  print(glue::glue_data(tmp, template))
  
}