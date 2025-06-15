library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(shinydashboard)
library(DT)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Diagnóstico de Zonas AGEB - INEGI Nuevo León"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Carga de Datos", tabName = "datos", icon = icon("upload")),
      menuItem("Demografía", tabName = "demografia", icon = icon("users")),
      menuItem("Educación", tabName = "educacion", icon = icon("graduation-cap")),
      menuItem("Servicios de Salud", tabName = "salud", icon = icon("heartbeat")),
      menuItem("Vivienda", tabName = "vivienda", icon = icon("home")),
      menuItem("Resumen", tabName = "resumen", icon = icon("chart-line"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f4f4f4;
        }
        .box {
          margin-bottom: 20px;
        }
        .main-header .navbar {
          background-color: #3c8dbc !important;
        }
      "))
    ),
    
    tabItems(
      # Tab 1: Carga de Datos
      tabItem(tabName = "datos",
              fluidRow(
                box(width = 12, status = "primary", solidHeader = TRUE,
                    title = "Carga de Archivo CSV",
                    fileInput("archivo", "Selecciona el archivo CSV:",
                              accept = ".csv", width = "100%"),
                    br(),
                    conditionalPanel(
                      condition = "output.datos_cargados",
                      h4("Selección de AGEB:"),
                      uiOutput("ageb_selector"),
                      br(),
                      h4("Vista previa de los datos:"),
                      DT::dataTableOutput("tabla_preview")
                    )
                )
              )
      ),
      
      # Tab 2: Demografía
      tabItem(tabName = "demografia",
              fluidRow(
                box(width = 12, status = "info", solidHeader = TRUE,
                    title = "Información Demográfica",
                    verbatimTextOutput("info_demografia")
                )
              ),
              fluidRow(
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Población 0-14 años vs Resto",
                    plotlyOutput("pie_poblacion_total", height = "400px")
                ),
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Comparación Estatal",
                    plotlyOutput("pie_poblacion_estatal", height = "400px")
                )
              ),
              fluidRow(
                box(width = 6, status = "success", solidHeader = TRUE,
                    title = "Composición Población 0-14 años",
                    plotlyOutput("pie_composicion_ageb", height = "400px")
                ),
                box(width = 6, status = "success", solidHeader = TRUE,
                    title = "Composición Estatal",
                    plotlyOutput("pie_composicion_estatal", height = "400px")
                )
              )
      ),
      
      # Tab 3: Educación
      tabItem(tabName = "educacion",
              fluidRow(
                box(width = 12, status = "warning", solidHeader = TRUE,
                    title = "Información Educativa",
                    verbatimTextOutput("info_educacion")
                )
              ),
              fluidRow(
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Población que NO asiste a la escuela",
                    plotlyOutput("bar_no_asiste", height = "400px")
                ),
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Comparación Estatal",
                    plotlyOutput("bar_no_asiste_estatal", height = "400px")
                )
              ),
              fluidRow(
                box(width = 12, status = "danger", solidHeader = TRUE,
                    title = "Analfabetismo (8-14 años)",
                    verbatimTextOutput("info_analfabetismo")
                )
              ),
              fluidRow(
                box(width = 3, status = "warning", solidHeader = TRUE,
                    title = "Analfabetismo AGEB",
                    plotlyOutput("pie_analfabetismo", height = "300px")
                ),
                box(width = 3, status = "warning", solidHeader = TRUE,
                    title = "Analfabetismo Estado",
                    plotlyOutput("pie_analfabetismo_estatal", height = "300px")
                ),
                box(width = 3, status = "info", solidHeader = TRUE,
                    title = "Por Género AGEB",
                    plotlyOutput("pie_genero_analfabetismo", height = "300px")
                ),
                box(width = 3, status = "info", solidHeader = TRUE,
                    title = "Por Género Estado",
                    plotlyOutput("pie_genero_analfabetismo_estatal", height = "300px")
                )
              )
      ),
      
      # Tab 4: Servicios de Salud
      tabItem(tabName = "salud",
              fluidRow(
                box(width = 12, status = "success", solidHeader = TRUE,
                    title = "Información de Servicios de Salud",
                    verbatimTextOutput("info_salud")
                )
              ),
              fluidRow(
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Acceso a Servicios de Salud - AGEB",
                    plotlyOutput("pie_salud", height = "400px")
                ),
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Acceso a Servicios de Salud - Estado",
                    plotlyOutput("pie_salud_estatal", height = "400px")
                )
              )
      ),
      
      # Tab 5: Vivienda
      tabItem(tabName = "vivienda",
              fluidRow(
                box(width = 12, status = "info", solidHeader = TRUE,
                    title = "Información de Vivienda",
                    verbatimTextOutput("info_vivienda")
                )
              ),
              fluidRow(
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Tipos de Vivienda - AGEB",
                    plotlyOutput("bar_tipos_vivienda", height = "400px")
                ),
                box(width = 6, status = "primary", solidHeader = TRUE,
                    title = "Tipos de Vivienda - Estado",
                    plotlyOutput("bar_tipos_vivienda_estatal", height = "400px")
                )
              ),
              fluidRow(
                box(width = 12, status = "warning", solidHeader = TRUE,
                    title = "Condiciones de Vivienda",
                    tabsetPanel(
                      tabPanel("Piso de Tierra", 
                               fluidRow(
                                 column(6, plotlyOutput("pie_piso_tierra")),
                                 column(6, plotlyOutput("pie_piso_tierra_estatal"))
                               )
                      ),
                      tabPanel("Sin Electricidad",
                               fluidRow(
                                 column(6, plotlyOutput("pie_sin_electricidad")),
                                 column(6, plotlyOutput("pie_sin_electricidad_estatal"))
                               )
                      ),
                      tabPanel("Agua y Abastecimiento",
                               fluidRow(
                                 column(6, plotlyOutput("pie_agua")),
                                 column(6, h4("No hay datos estatales disponibles por inconsistencias en la base"))
                               )
                      ),
                      tabPanel("Sin Servicios Básicos",
                               fluidRow(
                                 column(6, plotlyOutput("pie_sin_servicios")),
                                 column(6, plotlyOutput("pie_sin_servicios_estatal"))
                               )
                      ),
                      tabPanel("Con Todos los Servicios",
                               fluidRow(
                                 column(6, plotlyOutput("pie_todos_servicios")),
                                 column(6, h4("No hay datos estatales disponibles por inconsistencias en la base"))
                               )
                      ),
                      tabPanel("Sin Vehículos",
                               fluidRow(
                                 column(6, plotlyOutput("pie_sin_vehiculos")),
                                 column(6, plotlyOutput("pie_sin_vehiculos_estatal"))
                               )
                      ),
                      tabPanel("Sin Teléfono",
                               fluidRow(
                                 column(6, plotlyOutput("pie_sin_telefono")),
                                 column(6, plotlyOutput("pie_sin_telefono_estatal"))
                               )
                      ),
                      tabPanel("Sin Computadora/Internet",
                               fluidRow(
                                 column(6, plotlyOutput("pie_sin_computadora")),
                                 column(6, plotlyOutput("pie_sin_computadora_estatal"))
                               )
                      ),
                      tabPanel("Sin Tecnologías",
                               fluidRow(
                                 column(6, plotlyOutput("pie_sin_tecnologias")),
                                 column(6, plotlyOutput("pie_sin_tecnologias_estatal"))
                               )
                      )
                    )
                )
              )
      ),
      
      # Tab 6: Resumen
      tabItem(tabName = "resumen",
              fluidRow(
                box(width = 12, status = "primary", solidHeader = TRUE,
                    title = "Resumen Ejecutivo del AGEB",
                    verbatimTextOutput("resumen_completo")
                )
              )
      )
    )
  )
)

# SERVER
server <- function(input, output, session) {
  
  # Datos reactivos
  datos <- reactive({
    req(input$archivo)
    df <- read.csv(input$archivo$datapath, encoding = "UTF-8", stringsAsFactors = FALSE)
    df <- df[df$MZA == 0, ]
    
    # Reemplaza "*" por 0 y convierte columnas numéricas
    columnas <- c(
      "P_0A2", "P_3A5", "P_6A11", "P_8A14", "P_12A14", "POB0_14",
      "P3A5_NOA", "P6A11_NOA", "P12A14NOA", "P8A14AN", "P8A14AN_F", "P8A14AN_M",
      "PSINDER", "PDER_SS", "TVIVPAR", "VIVPAR_HAB", "VPH_PISOTI", "VPH_S_ELEC",
      "VPH_AEASP", "VPH_AGUAFV", "VPH_NDEAED", "VPH_C_SERV", "VPH_NDACMM",
      "VPH_PC", "VPH_SINLTC", "VPH_SINCINT", "VPH_SINTIC"
    )
    
    df[columnas] <- lapply(df[columnas], function(x) as.integer(gsub("\\*", "0", x)))
    df$PROM_OCUP <- as.numeric(gsub("\\*", "0", df$PROM_OCUP))
    return(df)
  })
  
  # Datos estatales (Total de la entidad)
  datos_estatales <- reactive({
    req(datos())
    df <- datos()
    df[df$NOM_LOC == "Total de la entidad", ]
  })
  
  # Datos del AGEB seleccionado
  datos_ageb <- reactive({
    req(input$ageb, datos())
    df <- datos()
    df[df$AGEB == input$ageb, ]
  })
  
  # Output para verificar si los datos están cargados
  output$datos_cargados <- reactive({
    return(!is.null(input$archivo))
  })
  outputOptions(output, 'datos_cargados', suspendWhenHidden = FALSE)
  
  # Selector de AGEB
  output$ageb_selector <- renderUI({
    req(datos())
    selectInput("ageb", "Selecciona un AGEB:",
                choices = unique(datos()$AGEB),
                selected = unique(datos()$AGEB)[1])
  })
  
  # Tabla preview
  output$tabla_preview <- DT::renderDataTable({
    req(datos())
    datos() %>% 
      select(AGEB, NOM_LOC, POBTOT, POB0_14, VIVPAR_HAB, PROM_OCUP) %>%
      head(10)
  }, options = list(scrollX = TRUE, pageLength = 5))
  
  # DEMOGRAFÍA
  output$info_demografia <- renderText({
    req(datos_ageb())
    row <- datos_ageb()
    paste0("Población total: ", row$POBTOT, "\n",
           "Población de 0 a 14 años: ", row$POB0_14, "\n\n",
           "Desglose por grupos de edad:\n",
           "Población de 0 a 2 años: ", row$P_0A2, "\n",
           "Población de 3 a 5 años: ", row$P_3A5, "\n",
           "Población de 6 a 11 años: ", row$P_6A11, "\n",
           "Población de 12 a 14 años: ", row$P_12A14)
  })
  
  output$pie_poblacion_total <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    total <- row$POBTOT
    infantil <- row$POB0_14
    resto <- total - infantil
    
    df_pie <- data.frame(
      categoria = c("Población 0 a 14", "Resto de edades"),
      valores = c(infantil, resto)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Porcentaje de población de 0 a 14 años",
             showlegend = TRUE)
    p
  })
  
  output$pie_poblacion_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    total <- row$POBTOT
    infantil <- row$POB0_14
    resto <- total - infantil
    
    df_pie <- data.frame(
      categoria = c("Población 0 a 14", "Resto de edades"),
      valores = c(infantil, resto)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales",
             showlegend = TRUE)
    p
  })
  
  output$pie_composicion_ageb <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Población 0 a 2", "Población 3 a 5", "Población 6 a 11", "Población 12 a 14"),
      valores = c(row$P_0A2, row$P_3A5, row$P_6A11, row$P_12A14)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Composición de población de 0 a 14 años",
             showlegend = TRUE)
    p
  })
  
  output$pie_composicion_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Población 0 a 2", "Población 3 a 5", "Población 6 a 11", "Población 12 a 14"),
      valores = c(row$P_0A2, row$P_3A5, row$P_6A11, row$P_12A14)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales",
             showlegend = TRUE)
    p
  })
  
  # EDUCACIÓN
  output$info_educacion <- renderText({
    req(datos_ageb())
    row <- datos_ageb()
    paste0("Población de 3 a 5 años que no asiste a la escuela: ", row$P3A5_NOA, 
           " (", round(row$P3A5_NOA/row$P_3A5*100, 2), "%)\n",
           "Población de 6 a 11 años que no asiste a la escuela: ", row$P6A11_NOA,
           " (", round(row$P6A11_NOA/row$P_6A11*100, 2), "%)\n",
           "Población de 12 a 14 años que no asiste a la escuela: ", row$P12A14NOA,
           " (", round(row$P12A14NOA/row$P_12A14*100, 2), "%)")
  })
  
  output$bar_no_asiste <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_bar <- data.frame(
      edad = c("3 a 5", "3 a 5 no", "6 a 11", "6 a 11 no", "12 a 14", "12 a 14 no"),
      porcentaje = c(
        row$P_3A5*100/(row$P_3A5 + row$P3A5_NOA),
        row$P3A5_NOA*100/(row$P_3A5 + row$P3A5_NOA),
        row$P_6A11*100/(row$P_6A11 + row$P6A11_NOA),
        row$P6A11_NOA*100/(row$P_6A11 + row$P6A11_NOA),
        row$P_12A14*100/(row$P_12A14 + row$P12A14NOA),
        row$P12A14NOA*100/(row$P_12A14 + row$P12A14NOA)
      ),
      tipo = c("Total", "No asisten", "Total", "No asisten", "Total", "No asisten")
    )
    
    p <- plot_ly(df_bar, x = ~edad, y = ~porcentaje, color = ~tipo, type = 'bar',
                 colors = c("blue", "red")) %>%
      layout(title = "Población de 3 a 14 que no asiste a la escuela",
             yaxis = list(title = "Porcentaje"))
    p
  })
  
  output$bar_no_asiste_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_bar <- data.frame(
      edad = c("3 a 5", "3 a 5 no", "6 a 11", "6 a 11 no", "12 a 14", "12 a 14 no"),
      porcentaje = c(
        row$P_3A5*100/(row$P_3A5 + row$P3A5_NOA),
        row$P3A5_NOA*100/(row$P_3A5 + row$P3A5_NOA),
        row$P_6A11*100/(row$P_6A11 + row$P6A11_NOA),
        row$P6A11_NOA*100/(row$P_6A11 + row$P6A11_NOA),
        row$P_12A14*100/(row$P_12A14 + row$P12A14NOA),
        row$P12A14NOA*100/(row$P_12A14 + row$P12A14NOA)
      ),
      tipo = c("Total", "No asisten", "Total", "No asisten", "Total", "No asisten")
    )
    
    p <- plot_ly(df_bar, x = ~edad, y = ~porcentaje, color = ~tipo, type = 'bar',
                 colors = c("blue", "red")) %>%
      layout(title = "Comparación con datos estatales",
             yaxis = list(title = "Porcentaje"))
    p
  })
  
  output$info_analfabetismo <- renderText({
    req(datos_ageb())
    row <- datos_ageb()
    paste0("Población de 8 a 14 años que no sabe leer ni escribir: ", row$P8A14AN,
           " (", round(row$P8A14AN/row$P_8A14*100, 2), "%)\n\n",
           "Masculina: ", row$P8A14AN_M, " (", round(row$P8A14AN_M/row$P8A14AN*100, 2), "%)\n",
           "Femenina: ", row$P8A14AN_F, " (", round(row$P8A14AN_F/row$P8A14AN*100, 2), "%)")
  })
  
  output$pie_analfabetismo <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("No sabe leer y escribir", "Sabe leer y escribir"),
      valores = c(row$P8A14AN, row$P_8A14 - row$P8A14AN)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Población analfabeta de 8 a 14 años")
    p
  })
  
  output$pie_analfabetismo_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("No sabe leer y escribir", "Sabe leer y escribir"),
      valores = c(row$P8A14AN, row$P_8A14 - row$P8A14AN)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  output$pie_genero_analfabetismo <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Masculina", "Femenina"),
      valores = c(row$P8A14AN_M, row$P8A14AN_F)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Género de la población analfabeta")
    p
  })
  
  output$pie_genero_analfabetismo_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Masculina", "Femenina"),
      valores = c(row$P8A14AN_M, row$P8A14AN_F)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # SERVICIOS DE SALUD
  output$info_salud <- renderText({
    req(datos_ageb())
    row <- datos_ageb()
    paste0("Población con acceso a servicios de salud: ", row$PDER_SS, "\n",
           "Población sin acceso a servicios de salud: ", row$PSINDER)
  })
  
  output$pie_salud <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Con acceso", "Sin acceso"),
      valores = c(row$PDER_SS, row$PSINDER)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Población con acceso a servicios de salud")
    p
  })
  
  output$pie_salud_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Con acceso", "Sin acceso"),
      valores = c(row$PDER_SS, row$PSINDER)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # VIVIENDA
  output$info_vivienda <- renderText({
    req(datos_ageb())
    row <- datos_ageb()
    paste0("Viviendas totales: ", row$TVIVPAR, "\n",
           "Viviendas particulares habitadas: ", row$VIVPAR_HAB, "\n",
           "Promedio de ocupantes por vivienda: ", row$PROM_OCUP, "\n",
           "Promedio estatal: ", datos_estatales()$PROM_OCUP)
  })
  
  output$bar_tipos_vivienda <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_bar <- data.frame(
      tipo = c("Totales", "Particulares habitadas"),
      cantidad = c(row$TVIVPAR, row$VIVPAR_HAB)
    )
    
    p <- plot_ly(df_bar, x = ~tipo, y = ~cantidad, type = 'bar',
                 marker = list(color = c('#1f77b4', '#ff7f0e'))) %>%
      layout(title = "Tipos de viviendas",
             yaxis = list(title = "Cantidad"))
    p
  })
  
  output$bar_tipos_vivienda_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_bar <- data.frame(
      tipo = c("Totales", "Particulares habitadas"),
      cantidad = c(row$TVIVPAR, row$VIVPAR_HAB)
    )
    
    p <- plot_ly(df_bar, x = ~tipo, y = ~cantidad, type = 'bar',
                 marker = list(color = c('#1f77b4', '#ff7f0e'))) %>%
      layout(title = "Comparación con datos del estado",
             yaxis = list(title = "Cantidad"))
    p
  })
  
  # Condiciones de vivienda - Piso de tierra
  output$pie_piso_tierra <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Piso de tierra", "Otro material"),
      valores = c(row$VPH_PISOTI, row$VIVPAR_HAB - row$VPH_PISOTI)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas con piso de tierra")
    p
  })
  
  output$pie_piso_tierra_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Piso de tierra", "Otro material"),
      valores = c(row$VPH_PISOTI, row$VIVPAR_HAB - row$VPH_PISOTI)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  output$pie_sin_electricidad_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Sin electricidad", "Con electricidad"),
      valores = c(row$VPH_S_ELEC, row$VIVPAR_HAB - row$VPH_S_ELEC)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # Agua y abastecimiento
  output$pie_agua <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Sin agua entubada", "Con agua entubada"),
      valores = c(row$VPH_AEASP, row$VIVPAR_HAB - row$VPH_AEASP)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas sin agua entubada")
    p
  })
  
  # Sin servicios básicos
  output$pie_sin_servicios <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Sin servicios básicos", "Con servicios básicos"),
      valores = c(row$VPH_NDEAED, row$VIVPAR_HAB - row$VPH_NDEAED)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas sin servicios básicos")
    p
  })
  
  output$pie_sin_servicios_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Sin servicios básicos", "Con servicios básicos"),
      valores = c(row$VPH_NDEAED, row$VIVPAR_HAB - row$VPH_NDEAED)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # Con todos los servicios
  output$pie_todos_servicios <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Con todos los servicios", "Sin todos los servicios"),
      valores = c(row$VPH_C_SERV, row$VIVPAR_HAB - row$VPH_C_SERV)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas con todos los servicios")
    p
  })
  
  # Sin vehículos
  output$pie_sin_vehiculos <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Sin vehículos", "Con vehículos"),
      valores = c(row$VPH_NDACMM, row$VIVPAR_HAB - row$VPH_NDACMM)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas sin vehículos")
    p
  })
  
  output$pie_sin_vehiculos_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Sin vehículos", "Con vehículos"),
      valores = c(row$VPH_NDACMM, row$VIVPAR_HAB - row$VPH_NDACMM)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # Sin teléfono
  output$pie_sin_telefono <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Sin teléfono", "Con teléfono"),
      valores = c(row$VPH_SINLTC, row$VIVPAR_HAB - row$VPH_SINLTC)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas sin teléfono")
    p
  })
  
  output$pie_sin_telefono_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Sin teléfono", "Con teléfono"),
      valores = c(row$VPH_SINLTC, row$VIVPAR_HAB - row$VPH_SINLTC)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # Sin computadora/internet
  output$pie_sin_computadora <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Sin computadora/internet", "Con computadora/internet"),
      valores = c(row$VPH_SINCINT, row$VIVPAR_HAB - row$VPH_SINCINT)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas sin computadora/internet")
    p
  })
  
  output$pie_sin_computadora_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Sin computadora/internet", "Con computadora/internet"),
      valores = c(row$VPH_SINCINT, row$VIVPAR_HAB - row$VPH_SINCINT)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # Sin tecnologías
  output$pie_sin_tecnologias <- renderPlotly({
    req(datos_ageb())
    row <- datos_ageb()
    
    df_pie <- data.frame(
      categoria = c("Sin tecnologías", "Con tecnologías"),
      valores = c(row$VPH_SINTIC, row$VIVPAR_HAB - row$VPH_SINTIC)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Viviendas sin tecnologías")
    p
  })
  
  output$pie_sin_tecnologias_estatal <- renderPlotly({
    req(datos_estatales())
    row <- datos_estatales()
    
    df_pie <- data.frame(
      categoria = c("Sin tecnologías", "Con tecnologías"),
      valores = c(row$VPH_SINTIC, row$VIVPAR_HAB - row$VPH_SINTIC)
    )
    
    p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie',
                 textposition = 'inside', textinfo = 'label+percent') %>%
      layout(title = "Comparación con datos estatales")
    p
  })
  
  # RESUMEN EJECUTIVO
  output$resumen_completo <- renderText({
    req(datos_ageb(), datos_estatales())
    ageb <- datos_ageb()
    estado <- datos_estatales()
    
    # Función para calcular porcentajes
    porc <- function(num, den) {
      if(den == 0) return(0)
      round(num/den*100, 2)
    }
    
    # Función para comparar con estado
    comparar <- function(valor_ageb, valor_estado, mayor_es_mejor = FALSE) {
      if (valor_estado == 0) return("Sin datos estatales")
      
      diferencia <- valor_ageb - valor_estado
      if (abs(diferencia) < 0.5) {
        return("similar al estatal")
      } else if (diferencia > 0) {
        if (mayor_es_mejor) {
          return(paste("superior al estatal (+", round(diferencia, 2), " p.p.)"))
        } else {
          return(paste("por encima del estatal (+", round(diferencia, 2), " p.p.)"))
        }
      } else {
        if (mayor_es_mejor) {
          return(paste("inferior al estatal (", round(diferencia, 2), " p.p.)"))
        } else {
          return(paste("por debajo del estatal (", round(diferencia, 2), " p.p.)"))
        }
      }
    }
    
    # Cálculos para el AGEB
    pob_infantil_ageb <- porc(ageb$POB0_14, ageb$POBTOT)
    no_asiste_3a5_ageb <- porc(ageb$P3A5_NOA, ageb$P_3A5)
    no_asiste_6a11_ageb <- porc(ageb$P6A11_NOA, ageb$P_6A11)
    no_asiste_12a14_ageb <- porc(ageb$P12A14NOA, ageb$P_12A14)
    analfabetismo_ageb <- porc(ageb$P8A14AN, ageb$P_8A14)
    sin_salud_ageb <- porc(ageb$PSINDER, ageb$POBTOT)
    piso_tierra_ageb <- porc(ageb$VPH_PISOTI, ageb$VIVPAR_HAB)
    sin_electricidad_ageb <- porc(ageb$VPH_S_ELEC, ageb$VIVPAR_HAB)
    sin_agua_ageb <- porc(ageb$VPH_AEASP, ageb$VIVPAR_HAB)
    sin_servicios_ageb <- porc(ageb$VPH_NDEAED, ageb$VIVPAR_HAB)
    todos_servicios_ageb <- porc(ageb$VPH_C_SERV, ageb$VIVPAR_HAB)
    sin_vehiculos_ageb <- porc(ageb$VPH_NDACMM, ageb$VIVPAR_HAB)
    sin_telefono_ageb <- porc(ageb$VPH_SINLTC, ageb$VIVPAR_HAB)
    sin_computadora_ageb <- porc(ageb$VPH_SINCINT, ageb$VIVPAR_HAB)
    sin_tecnologias_ageb <- porc(ageb$VPH_SINTIC, ageb$VIVPAR_HAB)
    
    # Cálculos para el estado
    pob_infantil_estado <- porc(estado$POB0_14, estado$POBTOT)
    no_asiste_3a5_estado <- porc(estado$P3A5_NOA, estado$P_3A5)
    no_asiste_6a11_estado <- porc(estado$P6A11_NOA, estado$P_6A11)
    no_asiste_12a14_estado <- porc(estado$P12A14NOA, estado$P_12A14)
    analfabetismo_estado <- porc(estado$P8A14AN, estado$P_8A14)
    sin_salud_estado <- porc(estado$PSINDER, estado$POBTOT)
    piso_tierra_estado <- porc(estado$VPH_PISOTI, estado$VIVPAR_HAB)
    sin_electricidad_estado <- porc(estado$VPH_S_ELEC, estado$VIVPAR_HAB)
    sin_agua_estado <- porc(estado$VPH_AEASP, estado$VIVPAR_HAB)
    sin_servicios_estado <- porc(estado$VPH_NDEAED, estado$VIVPAR_HAB)
    todos_servicios_estado <- porc(estado$VPH_C_SERV, estado$VIVPAR_HAB)
    sin_vehiculos_estado <- porc(estado$VPH_NDACMM, estado$VIVPAR_HAB)
    sin_telefono_estado <- porc(estado$VPH_SINLTC, estado$VIVPAR_HAB)
    sin_computadora_estado <- porc(estado$VPH_SINCINT, estado$VIVPAR_HAB)
    sin_tecnologias_estado <- porc(estado$VPH_SINTIC, estado$VIVPAR_HAB)
    
    # Generar resumen
    paste0(
      "=========================================\n",
      "DIAGNÓSTICO INTEGRAL DEL AGEB ", ageb$AGEB, "\n",
      "=========================================\n\n",
      
      "INFORMACIÓN GENERAL:\n",
      "- Población total: ", format(ageb$POBTOT, big.mark = ","), " habitantes\n",
      "- Viviendas particulares habitadas: ", format(ageb$VIVPAR_HAB, big.mark = ","), "\n",
      "- Promedio de ocupantes por vivienda: ", ageb$PROM_OCUP, " (estatal: ", estado$PROM_OCUP, ")\n\n",
      
      "DEMOGRAFÍA:\n",
      "- Población de 0 a 14 años: ", pob_infantil_ageb, "% (", comparar(pob_infantil_ageb, pob_infantil_estado), ")\n",
      "  • 0 a 2 años: ", format(ageb$P_0A2, big.mark = ","), " (", porc(ageb$P_0A2, ageb$POB0_14), "% del grupo infantil)\n",
      "  • 3 a 5 años: ", format(ageb$P_3A5, big.mark = ","), " (", porc(ageb$P_3A5, ageb$POB0_14), "% del grupo infantil)\n",
      "  • 6 a 11 años: ", format(ageb$P_6A11, big.mark = ","), " (", porc(ageb$P_6A11, ageb$POB0_14), "% del grupo infantil)\n",
      "  • 12 a 14 años: ", format(ageb$P_12A14, big.mark = ","), " (", porc(ageb$P_12A14, ageb$POB0_14), "% del grupo infantil)\n\n",
      
      "EDUCACIÓN:\n",
      "- Población de 3 a 5 años que NO asiste: ", no_asiste_3a5_ageb, "% (", comparar(no_asiste_3a5_ageb, no_asiste_3a5_estado), ")\n",
      "- Población de 6 a 11 años que NO asiste: ", no_asiste_6a11_ageb, "% (", comparar(no_asiste_6a11_ageb, no_asiste_6a11_estado), ")\n",
      "- Población de 12 a 14 años que NO asiste: ", no_asiste_12a14_ageb, "% (", comparar(no_asiste_12a14_ageb, no_asiste_12a14_estado), ")\n",
      "- Analfabetismo (8 a 14 años): ", analfabetismo_ageb, "% (", comparar(analfabetismo_ageb, analfabetismo_estado), ")\n\n",
      
      "SERVICIOS DE SALUD:\n",
      "- Población sin acceso a servicios de salud: ", sin_salud_ageb, "% (", comparar(sin_salud_ageb, sin_salud_estado), ")\n\n",
      
      "CONDICIONES DE VIVIENDA:\n",
      "- Viviendas con piso de tierra: ", piso_tierra_ageb, "% (", comparar(piso_tierra_ageb, piso_tierra_estado), ")\n",
      "- Viviendas sin electricidad: ", sin_electricidad_ageb, "% (", comparar(sin_electricidad_ageb, sin_electricidad_estado), ")\n",
      "- Viviendas sin agua entubada: ", sin_agua_ageb, "%\n",
      "- Viviendas sin servicios básicos: ", sin_servicios_ageb, "% (", comparar(sin_servicios_ageb, sin_servicios_estado), ")\n",
      "- Viviendas con todos los servicios: ", todos_servicios_ageb, "%\n\n",
      
      "BIENES Y TECNOLOGÍA:\n",
      "- Viviendas sin vehículos: ", sin_vehiculos_ageb, "% (", comparar(sin_vehiculos_ageb, sin_vehiculos_estado), ")\n",
      "- Viviendas sin teléfono: ", sin_telefono_ageb, "% (", comparar(sin_telefono_ageb, sin_telefono_estado), ")\n",
      "- Viviendas sin computadora/internet: ", sin_computadora_ageb, "% (", comparar(sin_computadora_ageb, sin_computadora_estado), ")\n",
      "- Viviendas sin tecnologías: ", sin_tecnologias_ageb, "% (", comparar(sin_tecnologias_ageb, sin_tecnologias_estado), ")\n\n",
      
      "DIAGNÓSTICO GENERAL:\n",
      if (pob_infantil_ageb > 25) "- Alta concentración de población infantil\n" else "",
      if (analfabetismo_ageb > 5) "- Problema significativo de analfabetismo infantil\n" else "",
      if (sin_salud_ageb > 20) "- Acceso limitado a servicios de salud\n" else "",
      if (piso_tierra_ageb > 10 || sin_servicios_ageb > 15) "- Condiciones deficientes de vivienda\n" else "",
      if (sin_computadora_ageb > 50) "- Brecha digital significativa\n" else "",
      if (sin_vehiculos_ageb > 30) "- Limitaciones de movilidad\n" else "",
      "\n",
      "=========================================\n",
      "Nota: p.p. = puntos porcentuales\n",
      "Fecha de generación: ", Sys.Date()
    )
  })
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)

