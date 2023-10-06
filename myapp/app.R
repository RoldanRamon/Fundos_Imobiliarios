library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(DT)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Exemplo Shiny"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Clusterização", tabName = "cluster", icon = icon("chart-area")),
      selectInput("species", "Selecionar Espécie:", choices = unique(iris$Species))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "dashboard",
        fluidRow(
          valueBoxOutput("valuebox1"),
          valueBoxOutput("valuebox2"),
          valueBoxOutput("valuebox3"),
          valueBoxOutput("valuebox4")
        ),
        hr(),
        fluidRow(
          box(
            title = "Filtro de Hambúrguer",
            width = 12,
            background = "yellow"
          )
        ),
        fluidRow(
          box(
            title = "Gráfico de Barras 1",
            width = 6,
            plotOutput("barplot1")
          ),
          box(
            title = "Gráfico de Barras 2",
            width = 6,
            plotOutput("barplot2")
          )
        ),
        fluidRow(
          box(
            title = "Gráfico de Linha",
            width = 12,
            plotOutput("lineplot")
          )
        ),
        fluidRow(
          box(
            title = "Heatmap",
            width = 12,
            plotlyOutput("heatmap")
          )
        )
      ),
      tabItem(
        tabName = "cluster",
        fluidRow(
          box(
            title = "Gráfico de Clusterização (k-means)",
            width = 12,
            plotOutput("kmeans_plot")
          )
        ),
        fluidRow(
          box(
            title = "Estatísticas Descritivas",
            width = 6,
            tableOutput("desc_stats")
          ),
          box(
            title = "Base de Dados",
            width = 6,
            DTOutput("data_table")
          )
        )
      )
    )
  )
)

# Define server
server <- function(input, output) {
  # ValueBoxes
  output$valuebox1 <- renderValueBox({
    valueBox(42, "Valor 1", icon = icon("heart"))
  })
  
  output$valuebox2 <- renderValueBox({
    valueBox(123, "Valor 2", icon = icon("chart-bar"))
  })
  
  output$valuebox3 <- renderValueBox({
    valueBox(876, "Valor 3", icon = icon("money-bill-alt"))
  })
  
  output$valuebox4 <- renderValueBox({
    valueBox(456, "Valor 4", icon = icon("tachometer-alt"))
  })
  
  # Gráficos
  output$barplot1 <- renderPlot({
    data <- iris[iris$Species == input$species, ]
    ggplot2::ggplot(data, aes(x = Species, fill = Species)) +
      ggplot2::geom_bar() +
      ggplot2::labs(title = "Gráfico de Barras 1")
  })
  
  output$barplot2 <- renderPlot({
    data <- iris[iris$Species == input$species, ]
    ggplot2::ggplot(data, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
      ggplot2::geom_point() +
      ggplot2::labs(title = "Gráfico de Barras 2")
  })
  
  output$lineplot <- renderPlot({
    data <- iris[iris$Species == input$species, ]
    ggplot2::ggplot(data, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
      ggplot2::geom_line() +
      ggplot2::labs(title = "Gráfico de Linha")
  })
  
  output$heatmap <- renderPlotly({
    data <- cor(iris[, 1:4])
    plotly::plot_ly(z = data, colorscale = "Viridis") %>%
      plotly::layout(title = "Heatmap")
  })
  
  # Clusterização com k-means
  output$kmeans_plot <- renderPlot({
    data <- iris[, 1:4]
    kmeans_result <- kmeans(data, centers = 3)
    data$cluster <- as.factor(kmeans_result$cluster)
    ggplot(data, aes(x = Sepal.Length, y = Sepal.Width, color = cluster)) +
      geom_point() +
      labs(title = "Gráfico de Clusterização (k-means)")
  })
  
  # Estatísticas Descritivas
  output$desc_stats <- renderTable({
    data <- iris[iris$Species == input$species, ]
    summary(data)
  })
  
  # Tabela de Dados
  output$data_table <- renderDT({
    data <- iris[iris$Species == input$species, ]
    datatable(data)
  })
}

# Run the Shiny app
shinyApp(ui, server)
