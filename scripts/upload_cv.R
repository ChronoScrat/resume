# Execute this script once the HTML version has already been generated.

if(Sys.getenv("DRIVE_KEY") == ""){
  dotenv::load_dot_env()
}

rmarkdown::render("../index.Rmd",
                  output_file = "../index.html")

pagedown::chrome_print("index.html",
                       output = "../CV - Nathanael.pdf")


googledrive::drive_upload("../CV - Nathanael.pdf",
                          path = "Public/")