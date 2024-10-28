# SpotiClone DB

SpotiClone DB es la version alfa para una base de datos de una tienda de musica ficticia con el mismo nombre, utilizando la estructura de una base de datos de terceros `Chinook Database` con el proposito de darle funcionalidades relevantes a esta tienda falsa por medio de funciones, triggers y eventos, a continuación el Diagrama de dicha estructura.

## Diagrama

![UML](Diagrama.png)

## Requisitos del Sistema

Para ejecutar SpotiClone, se requiere el siguiente software:

- **MySQL** : Versión 8.0 o superior.
- **MySQL Workbench** (opcional pero recomendado): Para gestionar la base de datos de manera visual y ejecutar los scripts SQL.
- **Cliente de línea de comandos de MySQL** : Para ejecutar los archivos `.sql` si no se utiliza MySQL Workbench.
- **Sistema operativo** : Cualquier sistema que soporte MySQL (Windows, Linux, macOS).

## Instalación y Configuración

Sigue los siguientes pasos para configurar el entorno y cargar la base de datos:

### 1. Descargar MySQL y MySQL Workbench

- Descarga e instala MySQL Server desde la página oficial: [https://dev.mysql.com/downloads/mysql/](https://dev.mysql.com/downloads/mysql/)
- (Opcional) Descarga MySQL Workbench: [https://dev.mysql.com/downloads/workbench/](https://dev.mysql.com/downloads/workbench/)

### 2. Crear la Base de Datos

- Abre MySQL Workbench o tu cliente de línea de comandos favorito.
- Ejecuta el archivo `DDL.sql` proporcionado para crear la estructura de la base de datos. Esto incluye la creación de todas las tablas mencionadas anteriormente, así como sus relaciones.

### 3. Cargar Datos Iniciales

- Ejecuta el archivo `DML.sql` para cargar los datos iniciales en las tablas.

### 4. Ejecutar Funciones, Triggers y Eventos

SpotiClone incluye diferentes funciones, triggers y eventos que gestionan ciertas actividades automáticas en la base de datos. Para ejecutar estos, sigue las instrucciones a continuación:

- Ejecutar los respectivos `dql_`de cada tipo de actividad, el orden no es relevante.
- Ejemplo para ejecutar una función:

  ```sql
  SELECT nombre_de_funcion(parametros);
  ```
- Los triggers y eventos se activan automáticamente cuando ocurren ciertas acciones (como inserciones o actualizaciones) en las tablas asociadas.

## Autoría ✒️

### [KevinJGV](https://github.com/KevinJGV)
