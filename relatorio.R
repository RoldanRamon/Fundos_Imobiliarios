library(shiny)
library(ggplot2)

# Dados fictícios
dados_ficticios <- data.frame(
  X = 1:10,
  Y = c(3, 5, 8, 6, 4, 7, 9, 2, 5, 3)
)

# Definindo a interface do usuário
ui <- fluidPage(
  titlePanel("Dashboard Interativo em Shiny"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("plot_type", "Escolha o tipo de gráfico:",
                  choices = c("Pontos" = "point", "Linhas" = "line", "Barras" = "bar")),
      
      checkboxInput("show_grid", "Exibir linhas de grade", value = TRUE)
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Definindo o servidor
server <- function(input, output) {
  data <- reactive({
    dados_ficticios
  })
  
  output$plot <- renderPlot({
    req(data())
    
    plot_type <- switch(input$plot_type,
                        "point" = geom_point(),
                        "line" = geom_line(),
                        "bar" = geom_bar(stat = "identity"))
    
    ggplot(data(), aes(x = X, y = Y)) +
      plot_type +
      theme_minimal() +
      labs(title = "Gráfico Interativo", x = "Eixo X", y = "Eixo Y") +
      theme(plot.title = element_text(hjust = 0.5)) +
      coord_cartesian(clip = "off") +
      geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
      theme(plot.margin = margin(20, 20, 20, 20))
  })
}

# Rodando o aplicativo Shiny
shinyApp(ui, server)
