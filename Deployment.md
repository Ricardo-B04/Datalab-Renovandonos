# Guía de Despliegue - Aplicación Shiny Diagnóstico de Zonas

## Índice
1. [Importar desde GitHub a PositCloud](#importar-desde-github-a-positcloud)
2. [Preparación en PositCloud](#preparación-en-positcloud)
3. [Despliegue en shinyapps.io](#despliegue-en-shinyappsio)
4. [Mantenimiento y Actualizaciones](#mantenimiento-y-actualizaciones)

## Importar desde GitHub a PositCloud

### Clonar directamente en PositCloud

#### Paso 1: Crear nuevo proyecto
1. Inicia sesión en [posit.cloud](https://posit.cloud/)
2. Haz clic en "New Project"
3. Selecciona "New Project from Git Repository"

#### Paso 2: Configurar el repositorio
1. Pega la URL de tu repositorio GitHub: `https://github.com/Ricardo-B04/Datalab-Renovandonos`
2. PositCloud clonará automáticamente el repositorio
3. Espera a que se complete la importación

#### Paso 3: Verificar archivos importados
```r
# Verificar que todos los archivos están presentes
list.files(recursive = TRUE)

# Verificar que existe renv.lock
file.exists("renv.lock")

# Ver estructura del proyecto
fs::dir_tree()
```

## Preparación en PositCloud

### Paso 1: Restaurar ambiente con renv
```r
# Verificar que renv está disponible
if (!require(renv)) install.packages("renv")

# Restaurar todas las dependencias
renv::restore()

# Si hay problemas, forzar la restauración
renv::restore(confirm = FALSE)
```

### Paso 2: Probar la aplicación localmente
```r
# Ejecutar la app para verificar que funciona
shiny::runApp()

# Si usa app.R
shiny::runApp("app.R")

# Si usa ui.R y server.R
shiny::runApp()
```

### Paso 3: Verificar dependencias
```r
# Ver todas las librerías instaladas
renv::status()

# Ver información de la sesión
sessionInfo()

# Actualizar snapshot si es necesario
renv::snapshot()
```

## Despliegue en shinyapps.io

### La opción más popular y sencilla para aplicaciones Shiny

#### Paso 1: Crear cuenta en shinyapps.io
1. Ve a [shinyapps.io](https://www.shinyapps.io/)
2. Haz clic en "Sign Up" 
3. Crea cuenta gratuita (permite hasta 5 aplicaciones)
4. Confirma tu email

#### Paso 2: Obtener credenciales de autenticación
1. Una vez logueado, ve a tu **Account Settings**
2. Haz clic en la pestaña **"Tokens"**
3. Copia el código que aparece (será algo como):
```r
rsconnect::setAccountInfo(name='tu-usuario',
                         token='XXXXXXXXXX',
                         secret='YYYYYYYYYY')
```

#### Paso 3: Configurar rsconnect en PositCloud
```r
# Instalar rsconnect si no está instalado
if (!require(rsconnect)) install.packages("rsconnect")

# Pegar y ejecutar el código que copiaste de shinyapps.io
rsconnect::setAccountInfo(
  name = 'tu-usuario',
  token = 'XXXXXXXXXX',
  secret = 'YYYYYYYYYY'
)

# Verificar que se configuró correctamente
rsconnect::accounts()
```

#### Paso 4: Desplegar tu aplicación
```r
# Despliegue básico (desde el directorio de tu app)
rsconnect::deployApp()

# O con configuración específica (recomendado)
rsconnect::deployApp(
  appName = "mi-app-shiny",           # Nombre que aparecerá en la URL
  appTitle = "Mi Aplicación Shiny",   # Título descriptivo
  account = "tu-usuario",             # Tu usuario de shinyapps.io
  forceUpdate = TRUE,                 # Forzar actualización si ya existe
  launch.browser = TRUE               # Abrir automáticamente en navegador
)
```

#### Paso 5: Verificar el despliegue
Después del despliegue exitoso:
- Tu app estará disponible en: `https://tu-usuario.shinyapps.io/mi-app-shiny/`
- PositCloud mostrará un enlace clickeable
- La primera carga puede tomar unos segundos

### Límites del plan gratuito:
- **5 aplicaciones** activas máximo
- **25 horas de uso** por mes
- **1 GB de memoria** por aplicación
- **Tiempo de ejecución**: 15 minutos máximo por sesión

### Solución de problemas comunes

#### Error: "Package not found"
```r
# Verificar que todas las librerías están en renv.lock
renv::status()

# Reinstalar librerías faltantes
renv::restore()

# Volver a desplegar
rsconnect::deployApp(forceUpdate = TRUE)
```

#### Error: "Application failed to start"
```r
# Ver logs de la aplicación
rsconnect::showLogs(appName = "mi-app-shiny")

# Común: problemas con rutas de archivos
# Verificar que usas rutas relativas, no absolutas
```

#### Aplicación muy lenta
```r
# Reducir tamaño de datos
# Optimizar código R
# Considerar upgrade a plan de pago para más recursos
```

## Mantenimiento y Actualizaciones

### Actualizar aplicación existente
```r
# Hacer cambios en tu código en PositCloud
# Luego redesplegar:
rsconnect::deployApp(
  appName = "mi-app-shiny",
  forceUpdate = TRUE
)
```

### Monitorear uso
1. Ve a tu dashboard en shinyapps.io
2. Revisa estadísticas de uso mensual
3. Monitora memoria y tiempo de respuesta

### Mejores prácticas
- **Optimiza el código**: Reduce tiempo de carga inicial
- **Minimiza los datos**: Usa archivos RDS en lugar de CSV grandes
- **Usa cache**: Para cálculos que no cambian frecuentemente
- **Prueba localmente**: Siempre verifica que funciona en PositCloud antes de desplegar
