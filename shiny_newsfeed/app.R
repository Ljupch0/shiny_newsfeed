library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(dplyr)
library(googlesheets4)
library(purrr)
#library(shinythemes)

gs4_deauth()
responses <- read_sheet("https://docs.google.com/spreadsheets/d/1ND2z22rjs1f-Hyt0NtDdkUGB11gnJ9odl77s8UkK-jo/") %>%
    dplyr::arrange(desc(Timestamp))

ui <- fluidPage(
    titlePanel("TaskFlow"),
    shinyWidgets::useShinydashboard(),
    tags$head(
        tags$style(HTML("
            .bg-blue-gradient { color: black; }
                            "))
    ),
    fluidRow(
        uiOutput("newsfeed")
    )
)





server <- function(input, output) {
    
    pic <- function(name) {
        if (name == "Tom") {
            "https://i.ibb.co/3kHs9Pv/Tom.jpg"
        } else if (name == "Gunter") {
            "https://i.ibb.co/yB6qrGB/Gunter.jpg"
        } else if (name == "Amy") {
            "https://i.ibb.co/wyR8DBT/Amy.jpg"
        } else if (name == "Michael") {
            "https://i.ibb.co/b2KyzzD/Michael.jpg"
        } else if (name == "Mark") {
            "https://i.ibb.co/fqS4TVh/Mark.jpg"
        }
    }
    
    new_post <- function (person, date, today, tomorrow) {
        
        
        socialBox(title = person,
                  subtitle = date,
                  width = 12,
                  src = pic(person),
                  footer_padding = FALSE,
                  #Content
                  p("What I did today", style="font-weight: bold;"),
                  p(today),
                  p("What I plan to do tomorrow", style="font-weight: bold;"),
                  p(tomorrow)
        )
        
    }
    
    output$newsfeed <- renderUI({
        
        gradientBox(purrr::pmap(.l = responses, .f = ~ new_post(person = ..2, date = ..1, today = ..3, tomorrow = ..4)  ),
                    title = "Task Feed: Data Science Team",
                    width = 6,
                    gradientColor = "blue",
                    footer_padding = FALSE
        )
    }
    
    
    )
    
    
}




shinyApp(ui = ui, server = server)