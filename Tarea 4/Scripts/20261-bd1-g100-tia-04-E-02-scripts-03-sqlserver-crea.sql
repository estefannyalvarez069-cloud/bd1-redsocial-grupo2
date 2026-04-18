--
-- Scripst de Creación de la Base de Datos - SGBD MS SQL Server
--
-- Todas las instrucciones se DEBEN EJECUTAR EN SECUENCIA SIN ERRORES
-- NOTA: Ojo con las tablas relacionadas. Primero las independientes y después las dependientes
--

--
-- Creación de las tablas
-- -- 0. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS

CREATE DATABASE RedPascualinaDB;
GO

USE RedPascualinaDB;
GO

-- 1. CREACIÓN DE TABLAS MAESTRAS E INDEPENDIENTES

-- Tabla: t_usuario 
CREATE TABLE t_usuario (
    id_usuario UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(), 
    nombre_completo VARCHAR(200) NOT NULL, 
    usuario_tag VARCHAR(30) NOT NULL UNIQUE, 
    data_institucional NVARCHAR(MAX) NOT NULL
)

-- Tabla: t_maestra_rol 
CREATE TABLE t_maestra_rol (
    id_rol INT IDENTITY(1,1) PRIMARY KEY, 
    nombre_rol VARCHAR(50) NOT NULL UNIQUE 
)

-- Tabla: t_maestra_categoria
CREATE TABLE t_maestra_categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tipo VARCHAR(30) NOT NULL UNIQUE 
)

-- 2. CREACIÓN DE TABLAS DEPENDIENTES (CON LLAVES FORÁNEAS)

-- Tabla: t_credencial 
CREATE TABLE t_credencial (
    id_credencial UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(), 
    id_usuario UNIQUEIDENTIFIER NOT NULL UNIQUE, 
    correo VARCHAR(320) NOT NULL UNIQUE,
    contraseña VARCHAR(20) NOT NULL,
    fecha_registro DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(),
    CONSTRAINT fk_credencial_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario)
)

-- Tabla: t_biografia
CREATE TABLE t_biografia (
    id_biografia INT IDENTITY(1,1) PRIMARY KEY, 
    id_usuario UNIQUEIDENTIFIER NOT NULL UNIQUE, 
    resumen_profesional NVARCHAR(MAX) NULL, 
    skills_intereses NVARCHAR(MAX) NULL, 
    CONSTRAINT fk_biografia_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario)
)

-- Tabla: t_publicacion_actividad 
CREATE TABLE t_publicacion_actividad (
    id_actividad INT IDENTITY(1,1) PRIMARY KEY, 
    id_usuario UNIQUEIDENTIFIER NOT NULL, 
    tipo_categoria VARCHAR(50) NOT NULL, 
    detalle_contenido NVARCHAR(MAX) NOT NULL, 
    fecha_registro DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
    CONSTRAINT fk_pub_actividad_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario)
)

-- Tabla: t_conexiones 
CREATE TABLE t_conexiones (
    id_conexion INT IDENTITY(1,1) PRIMARY KEY,
    id_actor_a UNIQUEIDENTIFIER NOT NULL,
    id_actor_b UNIQUEIDENTIFIER NOT NULL,
    tipo_vinculo VARCHAR(30) NOT NULL,
    CONSTRAINT fk_conexiones_actor_a FOREIGN KEY (id_actor_a) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_conexiones_actor_b FOREIGN KEY (id_actor_b) REFERENCES t_usuario(id_usuario)
)

-- Tabla: t_usuario_usuario (Tabla intermedia para seguimiento)
CREATE TABLE t_usuario_usuario (
    id_seguidor UNIQUEIDENTIFIER NOT NULL,
    id_seguido UNIQUEIDENTIFIER NOT NULL,
    tipo_relacion VARCHAR(20) NOT NULL,
    fecha_interaccion DATETIMEOFFSET NOT NULL,
    PRIMARY KEY (id_seguidor, id_seguido), 
    CONSTRAINT fk_usuariou_seguidor FOREIGN KEY (id_seguidor) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_usuariou_seguido FOREIGN KEY (id_seguido) REFERENCES t_usuario(id_usuario)
)

-- Tabla: t_usuario_evento (Tabla intermedia para eventos)
CREATE TABLE t_usuario_evento (
    id_usuario UNIQUEIDENTIFIER NOT NULL,
    id_evento INT NOT NULL,
    fecha_inscripcion DATETIMEOFFSET NOT NULL,
    estado_confirmacion VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_usuevento_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_usuevento_evento FOREIGN KEY (id_evento) REFERENCES t_publicacion_actividad(id_actividad)
)

-- Tabla: t_usuario_grupo (Tabla intermedia para grupos)
CREATE TABLE t_usuario_grupo (
    id_usuario UNIQUEIDENTIFIER NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union DATE NOT NULL,
    rol_miembro VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_usugrupo_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_usugrupo_grupo FOREIGN KEY (id_grupo) REFERENCES t_publicacion_actividad(id_actividad)
)


