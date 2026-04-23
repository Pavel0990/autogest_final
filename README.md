AutoZone ITLA - Proyecto Final Apps Móviles

Aplicación móvil desarrollada en Flutter para la gestión integral de vehículos, permitiendo a los usuarios controlar mantenimientos, combustible, gastos, ingresos y acceder a información útil desde un solo lugar.

Descripción del Proyecto

AutoZone ITLA es una aplicación diseñada para facilitar el seguimiento y control de vehículos personales o de trabajo.

El sistema permite registrar información clave del vehículo y llevar un control detallado de:

Mantenimientos
Consumo de combustible
Gastos
Ingresos
Estado general del vehículo

Además, incluye módulos informativos como noticias, videos y catálogo de vehículos.

Funcionalidades Principales
Autenticación
Registro de usuario
Inicio de sesión
Cierre de sesión
Vehículos
Registrar vehículos
Ver listado de vehículos
Ver detalle de cada vehículo
Mantenimientos
Registrar mantenimientos
Listar mantenimientos por vehículo
Combustible
Registrar consumo de combustible
Visualizar historial
Gastos e Ingresos
Registro de gastos
Registro de ingresos
Visualización de totales
Noticias
Consulta de noticias desde API
Videos
Visualización de contenido multimedia
Catálogo
Búsqueda de vehículos
Filtros por marca, modelo, año y precio
Visualización de detalles
Perfil
Información del usuario
Foro
Espacio para interacción entre usuarios
Acerca de
Información del equipo desarrollador
Arquitectura

El proyecto está organizado por módulos siguiendo una estructura por features:

lib/
 └── features/
      ├── auth/
      ├── vehiculos/
      ├── mantenimientos/
      ├── combustible/
      ├── gastos/
      ├── ingresos/
      ├── noticias/
      ├── videos/
      ├── catalogo/
      ├── perfil/
      ├── foro/
      └── about/

Cada módulo contiene:

data (servicios/API)
models
presentation (UI)
Tecnologías Utilizadas
Flutter
Dart
Dio (consumo de API)
Material Design
REST API
Instalación y Ejecución
Clonar el repositorio:
git clone https://github.com/Pavel0990/PROYECTO-FINAL-APPS-MOVILES.git
Entrar al proyecto:
cd autogest_final
Instalar dependencias:
flutter pub get
Ejecutar la app:
flutter run
APK

Puedes descargar la APK desde:

(Aquí colocas el enlace de GitHub Releases o Google Drive)

API

La aplicación consume una API REST proporcionada para el proyecto.

Ejemplo de endpoints:

/login
/vehiculos
/mantenimientos
/combustible
/catalogo
Nota sobre el Catálogo

El módulo de catálogo es de solo lectura.

No permite agregar vehículos desde la app
Depende de los datos disponibles en el backend
Si no hay registros, se mostrará vacío
