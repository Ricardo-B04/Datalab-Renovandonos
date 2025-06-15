# Dashboard de Diagnóstico de Zonas AGEB - INEGI Nuevo León

## Descripción

Este es un dashboard interactivo desarrollado en R Shiny para el análisis y diagnóstico de zonas AGEB (Áreas Geoestadísticas Básicas) utilizando datos del INEGI para el estado de Nuevo León. La aplicación permite visualizar y comparar indicadores demográficos, educativos, de salud y vivienda entre AGEBs específicos y los datos estatales.

## Características

- **Carga de datos**: Interfaz para cargar archivos CSV con datos del INEGI
- **Análisis demográfico**: Visualización de población por grupos de edad
- **Indicadores educativos**: Análisis de asistencia escolar y analfabetismo
- **Servicios de salud**: Acceso a servicios médicos
- **Condiciones de vivienda**: Análisis integral de infraestructura y servicios
- **Resumen ejecutivo**: Diagnóstico completo automatizado
- **Comparaciones**: Contraste con datos estatales en tiempo real

## Requisitos del Sistema

### Librerías de R necesarias

```r
install.packages(c(
  "shiny",
  "ggplot2", 
  "dplyr",
  "plotly",
  "shinydashboard",
  "DT"
))
```

### Versiones recomendadas

- R >= 4.0.0
- RStudio (opcional pero recomendado)

## Instalación

1. **Clonar o descargar** el código fuente
2. **Instalar las dependencias** ejecutando el código de instalación de librerías
3. **Preparar los datos** siguiendo las especificaciones de formato
4. **Ejecutar la aplicación** desde RStudio o consola de R

```r
# Para ejecutar la aplicación
shiny::runApp("ruta/al/archivo/app.R")
```

## Estructura de la Base de Datos

### Formato requerido

La aplicación requiere un archivo **CSV** con codificación **UTF-8** que contenga las siguientes columnas obligatorias:

#### Columnas de identificación
- `AGEB`: Código del AGEB
- `MZA`: Código de manzana (debe incluir fila con valor 0 para totales de AGEB)
- `NOM_LOC`: Nombre de la localidad (debe incluir "Total de la entidad" para datos estatales)

#### Columnas demográficas
- `POBTOT`: Población total
- `POB0_14`: Población de 0 a 14 años
- `P_0A2`: Población de 0 a 2 años
- `P_3A5`: Población de 3 a 5 años
- `P_6A11`: Población de 6 a 11 años
- `P_8A14`: Población de 8 a 14 años
- `P_12A14`: Población de 12 a 14 años

#### Columnas educativas
- `P3A5_NOA`: Población de 3 a 5 años que no asiste a la escuela
- `P6A11_NOA`: Población de 6 a 11 años que no asiste a la escuela
- `P12A14NOA`: Población de 12 a 14 años que no asiste a la escuela
- `P8A14AN`: Población de 8 a 14 años analfabeta
- `P8A14AN_F`: Población analfabeta femenina de 8 a 14 años
- `P8A14AN_M`: Población analfabeta masculina de 8 a 14 años

#### Columnas de salud
- `PSINDER`: Población sin derechohabiencia a servicios de salud
- `PDER_SS`: Población con derechohabiencia a servicios de salud

#### Columnas de vivienda
- `TVIVPAR`: Total de viviendas particulares
- `VIVPAR_HAB`: Viviendas particulares habitadas
- `PROM_OCUP`: Promedio de ocupantes por vivienda
- `VPH_PISOTI`: Viviendas con piso de tierra
- `VPH_S_ELEC`: Viviendas sin electricidad
- `VPH_AEASP`: Viviendas sin agua entubada
- `VPH_AGUAFV`: Viviendas sin agua de la red pública
- `VPH_NDEAED`: Viviendas que no disponen de energía eléctrica, agua entubada y drenaje
- `VPH_C_SERV`: Viviendas con todos los servicios
- `VPH_NDACMM`: Viviendas que no disponen de automóvil o camioneta
- `VPH_PC`: Viviendas con computadora
- `VPH_SINLTC`: Viviendas sin línea telefónica celular
- `VPH_SINCINT`: Viviendas sin computadora ni internet
- `VPH_SINTIC`: Viviendas sin ningún bien de TIC

### Notas importantes sobre los datos

1. **Valores faltantes**: Los valores marcados con "*" serán convertidos automáticamente a 0
2. **Filtrado automático**: La aplicación filtra automáticamente las filas donde `MZA == 0`
3. **Datos estatales**: Debe existir una fila con `NOM_LOC == "Total de la entidad"` para las comparaciones estatales
4. **Codificación**: El archivo debe estar en UTF-8 para manejar correctamente los caracteres especiales

### Ejemplo de estructura de datos

```csv
AGEB,MZA,NOM_LOC,POBTOT,POB0_14,P_0A2,P_3A5,P_6A11,P_12A14,P_8A14,...
001,0,Localidad A,1500,450,50,75,180,145,325,...
002,0,Localidad B,2300,690,80,110,250,200,450,...
999,0,Total de la entidad,2500000,750000,85000,125000,280000,240000,520000,...
```

## Reemplazar la Base de Datos

Para utilizar una nueva base de datos:

1. **Verificar el formato**: Asegurar que el nuevo archivo CSV contenga todas las columnas requeridas
2. **Codificación**: Verificar que esté en UTF-8
3. **Estructura**: Confirmar que incluya:
   - Filas con `MZA = 0` para cada AGEB
   - Una fila con `NOM_LOC = "Total de la entidad"` para datos estatales
4. **Carga**: Usar la interfaz de "Carga de Datos" en la aplicación
5. **Validación**: Verificar que los datos se muestren correctamente en la vista previa

### Pasos para validar nueva base de datos

```r
# Verificar estructura del archivo
datos <- read.csv("nuevo_archivo.csv", encoding = "UTF-8")
str(datos)

# Verificar columnas requeridas
columnas_requeridas <- c("AGEB", "MZA", "NOM_LOC", "POBTOT", "POB0_14", ...)
columnas_faltantes <- setdiff(columnas_requeridas, names(datos))
if(length(columnas_faltantes) > 0) {
  print(paste("Columnas faltantes:", paste(columnas_faltantes, collapse = ", ")))
}

# Verificar datos estatales
if(!"Total de la entidad" %in% datos$NOM_LOC) {
  print("ADVERTENCIA: No se encontraron datos estatales")
}
```

## Personalización de Gráficas

### Cambiar tipo de gráfica

Para modificar el tipo de visualización, edita las funciones `renderPlotly()` en el archivo del servidor:

#### De gráfica de pastel a barras

```r
# Código original (pastel)
output$pie_poblacion_total <- renderPlotly({
  # ... código existente ...
  p <- plot_ly(df_pie, labels = ~categoria, values = ~valores, type = 'pie')
})

# Código modificado (barras)
output$bar_poblacion_total <- renderPlotly({
  # ... código existente ...
  p <- plot_ly(df_pie, x = ~categoria, y = ~valores, type = 'bar')
})
```

#### De barras a líneas

```r
# Código original (barras)
p <- plot_ly(df_bar, x = ~edad, y = ~porcentaje, type = 'bar')

# Código modificado (líneas)
p <- plot_ly(df_bar, x = ~edad, y = ~porcentaje, type = 'scatter', mode = 'lines+markers')
```

### Tipos de gráficas disponibles en Plotly

1. **Gráficas de pastel**: `type = 'pie'`
2. **Gráficas de barras**: `type = 'bar'`
3. **Gráficas de líneas**: `type = 'scatter', mode = 'lines'`
4. **Dispersión**: `type = 'scatter', mode = 'markers'`
5. **Histogramas**: `type = 'histogram'`
6. **Boxplots**: `type = 'box'`

### Agregar nuevas gráficas

Para agregar una nueva visualización:

1. **En el UI**: Agregar un nuevo output en la sección correspondiente

```r
box(width = 6, status = "primary", solidHeader = TRUE,
    title = "Nueva Gráfica",
    plotlyOutput("nueva_grafica", height = "400px")
)
```

2. **En el servidor**: Crear la función renderPlotly correspondiente

```r
output$nueva_grafica <- renderPlotly({
  req(datos_ageb())
  row <- datos_ageb()
  
  # Preparar datos
  df_nueva <- data.frame(
    variable = c("Categoría 1", "Categoría 2"),
    valor = c(row$COLUMNA1, row$COLUMNA2)
  )
  
  # Crear gráfica
  p <- plot_ly(df_nueva, x = ~variable, y = ~valor, type = 'bar') %>%
    layout(title = "Título de la Nueva Gráfica")
  
  return(p)
})
```

### Personalizar colores y estilos

```r
# Colores personalizados
p <- plot_ly(df, x = ~x, y = ~y, type = 'bar',
             marker = list(color = c('#1f77b4', '#ff7f0e', '#2ca02c')))

# Para gráficas de pastel
p <- plot_ly(df, labels = ~labels, values = ~values, type = 'pie',
             marker = list(colors = c('#FF6B6B', '#4ECDC4', '#45B7D1')))
```

## Estructura del Proyecto

```
proyecto/
├── app.R                 # Archivo principal de la aplicación
├── README.md            # Este archivo
├── datos/               # Carpeta para archivos de datos
│   └── ejemplo.csv      # Archivo de ejemplo
└── docs/                # Documentación adicional
```

## Uso de la Aplicación

1. **Carga de datos**: Seleccionar archivo CSV en la pestaña "Carga de Datos"
2. **Selección de AGEB**: Elegir el AGEB a analizar del menú desplegable
3. **Navegación**: Usar las pestañas para explorar diferentes categorías de análisis
4. **Comparaciones**: Todas las gráficas incluyen comparación con datos estatales
5. **Resumen**: La pestaña "Resumen" genera un diagnóstico completo automático

## Troubleshooting

### Problemas comunes

1. **Error de codificación**: Verificar que el archivo esté en UTF-8
2. **Columnas faltantes**: Revisar que todas las columnas requeridas estén presentes
3. **Datos no se cargan**: Verificar formato CSV y separadores
4. **Gráficas vacías**: Confirmar que existan datos para el AGEB seleccionado

### Contacto y Soporte

Para reportar problemas o solicitar mejoras, documentar:
- Versión de R utilizada
- Descripción del error
- Archivo de datos de ejemplo (si es posible)
- Pasos para reproducir el problema

## Licencia

Este proyecto se distribuye bajo licencia [especificar licencia]. Ver archivo LICENSE para más detalles.

## Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork del proyecto
2. Crear rama para nueva característica
3. Commit de cambios
4. Push a la rama
5. Crear Pull Request

---

**Última actualización**: Junio 2025  
**Versión**: 1.0.0
