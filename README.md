AutoZone ITLA

Proyecto final de Apps Móviles desarrollado en Flutter.

AutoZone ITLA es una app pensada para ayudarte a llevar el control de tu vehículo de forma sencilla: desde mantenimientos hasta gastos, todo en un solo lugar.

¿Qué hace esta app?

La idea principal es que puedas registrar y consultar toda la información importante de tu vehículo sin complicaciones.

Con la app puedes:

Registrar tus vehículos
Llevar control de mantenimientos
Registrar consumo de combustible
Controlar gastos e ingresos
Ver información útil como noticias y videos
Consultar un catálogo de vehículos
Interactuar en un foro
¿Cómo está organizada?

El proyecto está dividido por módulos (features), lo que hace el código más limpio y fácil de mantener:

auth (login y registro)
vehiculos
mantenimientos
combustible
gastos
ingresos
noticias
videos
catalogo
perfil
foro
about
Tecnologías utilizadas
Flutter
Dart
Dio (para consumir la API)
Material Design
Cómo ejecutar el proyecto
Clonar el repositorio:

git clone https://github.com/Pavel0990/PROYECTO-FINAL-APPS-MOVILES.git

Entrar al proyecto:

cd autogest_final

Instalar dependencias:

flutter pub get

Ejecutar la app:

flutter run

Nota sobre el catálogo

El catálogo funciona solo para consultar.

No se agregan vehículos desde la app
Depende de los datos que tenga el backend
Si no hay datos, simplemente aparecerá vacío


Equipo de desarrollo

Jorge Miguel Paulino Luciano
2021-0713

Pavel Abreu Torres
2023-1066

Leslie Mariel Ferrand Martinez
2023-0288

Yoskal García Contreras
2022-0497

Rozenny P. Valentin
2021-0685
Telegram: RPV

Angel Antonio Gomera Romero
2022-0493

Arquitectura del proyecto:
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
