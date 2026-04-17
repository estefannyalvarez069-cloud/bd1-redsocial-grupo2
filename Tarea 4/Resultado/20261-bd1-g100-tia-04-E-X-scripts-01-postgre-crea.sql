--
-- Scripst de Creación de la Base de Datos  - SGBD PostgreSQL
--
-- Todas las instrucciones se DEBEN EJECUTAR EN SECUENCIA SIN ERRORES
-- NOTA: Ojo con las tablas relacionadas. Primero las independientes y después las dependientes


--
-- Creación de las tablas
-- 1. TABLAS MAESTRAS E INDEPENDIENTES
CREATE TABLE t_usuario (
    id_usuario UUID PRIMARY KEY,
    nombre_completo VARCHAR (200) NOT NULL,
    usuario_tag VARCHAR (30) UNIQUE NOT NULL,
    data_institucional JSONB NOT NULL
);

CREATE TABLE t_maestra_rol (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR (50) UNIQUE NOT NULL
);

CREATE TABLE t_maestra_categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR (30) UNIQUE NOT NULL
);

--2. Tablas de seguridad y perfil 
CREATE TABLE t_credencial (
    id_credencial UUID PRIMARY KEY,
    id_usuario UUID UNIQUE NOT NULL,
    correo VARCHAR (320) UNIQUE NOT NULL,
    contraseña VARCHAR (20) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_credencial FOREIGN KEY (id_usuario)
        REFERENCES t_usuario(id_usuario)
);

CREATE TABLE t_biografia (
    id_biografia SERIAL PRIMARY KEY,
    id_usuario UUID UNIQUE NOT NULL,
    resumen_profesional JSONB,
    skills_intereses JSONB,
    CONSTRAINT fk_usuario_biografia FOREIGN KEY (id_usuario)
        REFERENCES t_usuario(id_usuario)

);

--3. Tabla central de Actividad
CREATE TABLE t_publicacion_actividad (
    id_actividad SERIAL PRIMARY KEY,
    id_usuario UUID NOT NULL,
    tipo_categoria VARCHAR(50) NOT NULL,
    detalle_contenido JSONB NOT NULL,
    fecha_registro TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usu_actividad FOREIGN KEY (id_usuario)
     REFERENCES t_usuario(id_usuario)
);

--4. Tabla de conexión y relación
CREATE TABLE t_conexiones (
    id_conexion SERIAL PRIMARY KEY,
    id_actor_a UUID NOT NULL,
    id_actor_b UUID NOT NULL,
    tipo_vinculo VARCHAR(30) NOT NULL,
    data_vinculo JSONB,
    CONSTRAINT fk_actor_a FOREIGN KEY (id_actor_a) 
        REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_actor_b FOREIGN KEY (id_actor_b) 
        REFERENCES t_usuario(id_usuario)
);

CREATE TABLE t_usuario_usuario (
    id_seguidor UUID NOT NULL,
    id_seguido UUID NOT NULL,
    tipo_relacion VARCHAR(20) NOT NULL,
    fecha_interaccion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_seguidor FOREIGN KEY (id_seguidor) 
        REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_seguido FOREIGN KEY (id_seguido) 
        REFERENCES t_usuario(id_usuario)
);

CREATE TABLE t_usuario_evento (
    id_usuario UUID NOT NULL,
    id_evento INT NOT NULL,
    fecha_inscripcion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estado_confirmacion VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_usu_evento_u FOREIGN KEY (id_usuario) 
        REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_usu_evento_a FOREIGN KEY (id_evento) 
        REFERENCES t_publicacion_actividad(id_actividad)
);

CREATE TABLE t_usuario_grupo (
    id_usuario UUID NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union DATE DEFAULT CURRENT_DATE,
    rol_miembro VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_usu_grupo_u FOREIGN KEY (id_usuario) 
        REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_usu_grupo_a FOREIGN KEY (id_grupo) 
        REFERENCES t_publicacion_actividad(id_actividad)
);
