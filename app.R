library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashBootstrapComponents)

library(ggplot2)
library(dplyr)
library(purrr)
library(plotly)

app <- Dash$new()

gap <- read.csv("data/gapminder_processed.csv")

app$layout(
  dbcContainer(
    list(
      dccDropdown(
        id = "year_input",
        options = gap %>%
          pull(year) %>%
          unique() %>%
          purrr::map(function(year) list(label = year, value = year)),
        value = 1970
      ),
      dccGraph(id = "bubble_plot")
    )
  )
)

app %>% add_callback(
  output("bubble_plot", "figure"),
  input("year_input", "value"),
  function(year_inp) {
    gap_f <- filter(gap, year == year_inp)
    p <- gap_f %>% 
      ggplot(aes(
        x = children_per_woman,
        y = life_expectancy,
        color = region,
        size = population)) +
      geom_point()
    ggplotly(p)
  }
)

app$run_server(host = "0.0.0.0")
