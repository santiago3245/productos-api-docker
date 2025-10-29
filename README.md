# API REST de Productos con SQL Server - Dockerizada

## 📋 Descripción del Proyecto

Este proyecto es una API REST completa desarrollada con **Spring Boot** y **Java 17** que gestiona un CRUD de productos, conectada a una base de datos **SQL Server**. Toda la aplicación está completamente **contenerizada con Docker** para garantizar portabilidad, reproducibilidad y aislamiento del entorno.

## 🏗️ Arquitectura del Proyecto

```
Api/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/productosapi/
│       │       ├── ProductosApiApplication.java    # Clase principal
│       │       ├── controller/
│       │       │   └── ProductoController.java     # Endpoints REST
│       │       ├── model/
│       │       │   └── Producto.java               # Entidad JPA
│       │       ├── repository/
│       │       │   └── ProductoRepository.java     # Capa de datos
│       │       └── service/
│       │           └── ProductoService.java        # Lógica de negocio
│       └── resources/
│           └── application.properties              # Configuración de la aplicación
├── Dockerfile                                      # Imagen Docker de la API
├── docker-compose.yml                              # Orquestación de contenedores
├── init.sql                                        # Script de inicialización de BD
├── .env                                            # Variables de entorno
├── .gitignore                                      # Archivos ignorados por Git
├── pom.xml                                         # Dependencias Maven
└── README.md                                       # Este archivo
```

## 🚀 Tecnologías Utilizadas

- **Java 17** - Lenguaje de programación
- **Spring Boot 3.1.5** - Framework para la API REST
- **Spring Data JPA** - ORM para persistencia de datos
- **SQL Server 2022** - Base de datos relacional
- **Maven** - Gestor de dependencias
- **Docker & Docker Compose** - Contenerización y orquestación
- **Lombok** - Reducción de código boilerplate

## 📦 Estructura de la Entidad Producto

```json
{
  "id": 1,
  "nombre": "Laptop Dell XPS 15",
  "descripcion": "Laptop de alto rendimiento",
  "precio": 1299.99,
  "stock": 15,
  "fechaCreacion": "2025-10-28T10:00:00",
  "fechaActualizacion": "2025-10-28T10:00:00"
}
```

## 🔌 Endpoints de la API

### Productos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| `GET` | `/api/productos` | Obtener todos los productos |
| `GET` | `/api/productos/{id}` | Obtener un producto por ID |
| `POST` | `/api/productos` | Crear un nuevo producto |
| `PUT` | `/api/productos/{id}` | Actualizar un producto existente |
| `DELETE` | `/api/productos/{id}` | Eliminar un producto |
| `GET` | `/api/productos/buscar?nombre={nombre}` | Buscar productos por nombre |
| `GET` | `/api/productos/stock-bajo?stock={cantidad}` | Productos con stock bajo |
| `GET` | `/api/productos/health` | Health check de la API |

## 🐳 Instrucciones de Ejecución con Docker

### Prerrequisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop) instalado
- [Git](https://git-scm.com/) instalado

### Paso 1: Clonar el Repositorio

```powershell
git clone <URL_DEL_REPOSITORIO>
cd Api
```

### Paso 2: Configurar Variables de Entorno

El archivo `.env` ya está configurado con valores por defecto:

```env
MSSQL_SA_PASSWORD=YourStrong@Passw0rd
DB_USERNAME=sa
```

> ⚠️ **Importante**: En producción, cambia la contraseña por una más segura.

### Paso 3: Construir y Levantar los Contenedores

```powershell
# Construir las imágenes y levantar los contenedores
docker-compose up --build -d
```

> ⚠️ **IMPORTANTE**: Espera aproximadamente 30 segundos a que SQL Server esté completamente iniciado antes de continuar con el siguiente paso.

### Paso 4: Inicializar la Base de Datos

Una vez que SQL Server esté listo, ejecuta el siguiente comando para crear la base de datos y las tablas:

```powershell
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C -i /docker-entrypoint-initdb.d/init.sql
```

Este comando ejecuta el script `init.sql` que:
1. � Crea la base de datos `ProductosDB`
2. 🗂️ Crea la tabla `productos` con su estructura
3. � Inserta 10 productos de ejemplo
4. � Crea índices para optimizar las búsquedas

### Paso 5: Verificar que los Contenedores Están Corriendo

```powershell
docker-compose ps
```

Deberías ver:
```
NAME                  STATUS          PORTS
productos-api         Up              0.0.0.0:8080->8080/tcp
sqlserver-productos   Up (healthy)    0.0.0.0:1433->1433/tcp
```

### Paso 6: Probar la API

Puedes probar la API de dos formas:

#### **Opción A: Desde tu navegador web (solo GET)**
Abre tu navegador y visita:
```
http://localhost:8080/api/productos
http://localhost:8080/api/productos/health
```

#### **Opción B: Usando comandos Docker (con `wget`)**

**Health Check:**
```powershell
docker exec -it productos-api wget -qO- http://localhost:8080/api/productos/health
```

**Obtener todos los productos:**
```powershell
docker exec -it productos-api wget -qO- http://localhost:8080/api/productos
```

**Obtener producto por ID:**
```powershell
docker exec -it productos-api wget -qO- http://localhost:8080/api/productos/1
```

**Buscar productos por nombre:**
```powershell
docker exec -it productos-api wget -qO- "http://localhost:8080/api/productos/buscar?nombre=laptop"
```

**Crear un nuevo producto (INSERT con SQL):**
```powershell
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "INSERT INTO ProductosDB.dbo.productos (nombre, descripcion, precio, stock, fecha_creacion, fecha_actualizacion) VALUES (N'Nuevo Producto', N'Descripción del producto', 99.99, 50, GETDATE(), GETDATE())"
```

**Actualizar un producto (UPDATE con SQL):**
```powershell
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "UPDATE ProductosDB.dbo.productos SET nombre='Producto Actualizado', precio=199.99, stock=20 WHERE id=1"
```

**Eliminar un producto (DELETE con SQL):**
```powershell
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "DELETE FROM ProductosDB.dbo.productos WHERE id=11"
```

> **Nota:** Los comandos `docker exec` funcionan desde **cualquier ubicación** en tu sistema, no necesitas estar en la carpeta del proyecto.

#### **Opción C: Consultas SQL directas**

También puedes consultar y manipular la base de datos directamente:

```powershell
# Ver todos los productos
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "SELECT * FROM ProductosDB.dbo.productos"

# Buscar producto por ID
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "SELECT * FROM ProductosDB.dbo.productos WHERE id=1"

# Contar productos
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "SELECT COUNT(*) AS total FROM ProductosDB.dbo.productos"
```

> **Nota:** Los comandos `docker exec` funcionan desde **cualquier ubicación** en tu sistema, no necesitas estar en la carpeta del proyecto.

# Eliminar producto por ID (con SQL)
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "1234" -C -Q "DELETE FROM ProductosDB.dbo.productos WHERE id=11"
```

**Buscar productos por nombre:**
```powershell
docker exec -it productos-api wget -qO- "http://localhost:8080/api/productos/buscar?nombre=laptop"
```

> **Nota:** Los comandos `docker exec` funcionan desde **cualquier ubicación** en tu sistema, no necesitas estar en la carpeta del proyecto.

## 🛠️ Comandos Docker Útiles

### Ver logs de los contenedores
```powershell
# Logs de la API
docker-compose logs -f api

# Logs de SQL Server
docker-compose logs -f sqlserver
```

### Detener los contenedores
```powershell
docker-compose down
```

### Detener y eliminar volúmenes (reiniciar BD)
```powershell
docker-compose down -v
```

### Reconstruir solo la API
```powershell
docker-compose up --build api
```

### Acceder a la consola de SQL Server
```powershell
docker exec -it sqlserver-productos /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd"
```

## 📊 Base de Datos

### Conexión a SQL Server

- **Host**: localhost
- **Puerto**: 1433
- **Usuario**: sa
- **Contraseña**: YourStrong@Passw0rd
- **Base de datos**: ProductosDB

### Esquema de la Tabla `productos`

```sql
CREATE TABLE productos (
    id BIGINT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(500),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    fecha_creacion DATETIME2 NOT NULL,
    fecha_actualizacion DATETIME2 NOT NULL
);
```

### Datos de Ejemplo

El script `init.sql` inserta automáticamente 10 productos de ejemplo al inicializar la base de datos.

## 🏗️ Dockerfile - Multi-Stage Build

El Dockerfile utiliza un **build multi-etapa** para optimizar el tamaño de la imagen:

1. **Etapa de Build**: Usa Maven para compilar la aplicación
2. **Etapa de Runtime**: Usa una imagen ligera de JRE para ejecutar el JAR

## 🧪 Testing

Puedes usar **Postman**, **Thunder Client** (VS Code) o **curl** para probar los endpoints.

### Colección de Postman

Importa esta URL en Postman para probar todos los endpoints:
```
http://localhost:8080/api/productos
```

## 📝 Notas Adicionales

### Persistencia de Datos

Los datos de SQL Server se persisten en un volumen Docker llamado `sqlserver-data`. Esto significa que:
- Los datos sobreviven al reinicio de contenedores
- Para resetear la BD, usa `docker-compose down -v`

### Tiempos de Inicio

- SQL Server tarda ~20-30 segundos en estar listo
- La API espera a que SQL Server esté saludable antes de iniciar (healthcheck)

### Modificar el Código

Si modificas el código de la API:
```powershell
# Reconstruir y reiniciar solo la API
docker-compose up --build api
```

### ¿Por qué necesito ejecutar el script init.sql manualmente?

**Explicación:**
- La imagen oficial de SQL Server en Docker **NO ejecuta automáticamente** scripts `.sql` al iniciar (a diferencia de MySQL/PostgreSQL)
- Aunque el archivo `init.sql` está montado en el contenedor, debes ejecutarlo manualmente con el comando `sqlcmd`
- Este es un comportamiento estándar de SQL Server en contenedores Docker

**Solución:**
Después de `docker-compose up`, ejecuta:
```powershell
docker exec -it sqlserver-productos /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -C -i /docker-entrypoint-initdb.d/init.sql
```

### La API no se conecta a la base de datos

1. Verifica que SQL Server esté healthy:
   ```powershell
   docker-compose ps
   ```

2. Revisa los logs:
   ```powershell
   docker-compose logs sqlserver
   docker-compose logs api
   ```

3. Verifica la contraseña en `.env`

### Puerto 8080 o 1433 ya en uso

Modifica los puertos en `docker-compose.yml`:
```yaml
ports:
  - "8081:8080"  # Para la API
  - "1434:1433"  # Para SQL Server
```

