# Load data file to R Shiny

## Uploading data from the user interface
## One of the easiest ways to load data into a Shiny application is to allow users to upload their own data files

## Shiny provides the fileInput function, which allows users to select and upload their files from the local machine
## The uploaded files can be accessed using the input object in the server function

ui <- fluidPage(
  fileInput("file1", "Choose CSV File",
            accept = c("text/csv",
                       "text/comma-separated-values,
                       .csv"))
)

server <- function(input, output) {
  data <- reactive({
    infile <- input$file1
    if (is.null(infile)) {
      return(NULL)
    }
    read.csv(infile$datapath, header = TRUE)
  })
}

## Loading data from a URL
## This is useful if the data is hosted on a server and needs to be accessed by multiple users
## The read.table or read.csv function can be used to load data from a URL

server <- function(input, output) {
  data <- reactive({
    url <- "http://example.com/data.csv"
    read.csv(url)
  })
}

## Loading data from a database:
## This is useful when dealing with large datasets that cannot be easily loaded into memory
## The DBI and RMySQL packages can be used to establish a connection to a database and query data

library(DBI)
library(RMySQL)

con <- dbConnect(MySQL(), user = "username", password = "password", 
                 host = "localhost", dbname = "database")

server <- function(input, output) {
  data <- reactive({
    query <- "SELECT * FROM tablename"
    dbGetQuery(con, query)
  })
}

## Loading data from a file on the server
## This is useful when the data file is too large to be uploaded by the user or when the data needs to be refreshed periodically

server <- function(input, output) {
  data <- reactive({
    file <- "/path/to/data.csv"
    read.csv(file)
  })
}
