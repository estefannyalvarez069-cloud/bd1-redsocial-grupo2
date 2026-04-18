-- -----------------------------------------------------
-- Script de Creación de la Base de Datos - Red Social Estudiantil
-- SGBD: MySQL
-- -----------------------------------------------------
-- Crea la base de datos si no existe
CREATE DATABASE IF NOT EXISTS red_social_estudiantil;
-- -----------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

-- 1. TABLAS MAESTRAS (INDEPENDIENTES)
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS t_maestra_rol (
    id_rol INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB COMMENT='Define los perfiles institucionales admitidos.';

CREATE TABLE IF NOT EXISTS t_maestra_categoria (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB COMMENT='Define los dominios de actividad (Post, Evento, etc).';

-- 1. TABLAS (DEPENDIENTES)
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS t_usuario (
    id_usuario BINARY(16) NOT NULL PRIMARY KEY,
    nombre_completo VARCHAR(200) NOT NULL,
    usuario_tag VARCHAR(30) NOT NULL UNIQUE,
    data_institucional JSON NOT NULL,
    -- Nota: El JSON simplifica t_rol_usuario y t_dependencia
    INDEX (usuario_tag)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS t_credencial (
    id_credencial BINARY(16) NOT NULL PRIMARY KEY,
    id_usuario BINARY(16) NOT NULL UNIQUE,
    correo VARCHAR(320) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_credencial_usuario FOREIGN KEY (id_usuario) 
        REFERENCES t_usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_biografia (
    id_biografia INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario BINARY(16) NOT NULL UNIQUE,
    resumen_profesional JSON NULL,
    skills_intereses JSON NULL,
    CONSTRAINT fk_biografia_usuario FOREIGN KEY (id_usuario) 
        REFERENCES t_usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS t_publicacion_actividad (
    id_actividad INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario BINARY(16) NOT NULL,
    tipo_categoria VARCHAR(50) NOT NULL,
    detalle_contenido JSON NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_actividad_usuario FOREIGN KEY (id_usuario) 
        REFERENCES t_usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. TABLAS DE (N:M)
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS t_conexiones (
    id_conexion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_actor_a BINARY(16) NOT NULL,
    id_actor_b BINARY(16) NOT NULL,
    tipo_vinculo VARCHAR(30) NOT NULL,
    data_vinculo JSON NULL,
    CONSTRAINT fk_actor_a FOREIGN KEY (id_actor_a) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_actor_b FOREIGN KEY (id_actor_b) REFERENCES t_usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_usuario_usuario (
    id_seguidor BINARY(16) NOT NULL,
    id_seguido BINARY(16) NOT NULL,
    tipo_relacion VARCHAR(20) NOT NULL,
    fecha_interaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_seguidor FOREIGN KEY (id_seguidor) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_seguido FOREIGN KEY (id_seguido) REFERENCES t_usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS t_usuario_evento (
    id_usuario BINARY(16) NOT NULL,
    id_evento INT UNSIGNED NOT NULL,
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_confirmacion VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_inscrito_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_inscrito_evento FOREIGN KEY (id_evento) REFERENCES t_publicacion_actividad(id_actividad)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS t_usuario_grupo (
    id_usuario BINARY(16) NOT NULL,
    id_grupo INT UNSIGNED NOT NULL,
    fecha_union DATE NOT NULL,
    rol_miembro VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_miembro_usuario FOREIGN KEY (id_usuario) REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_miembro_grupo FOREIGN KEY (id_grupo) REFERENCES t_publicacion_actividad(id_actividad)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;