--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Probar los scripts en detalle
--

--
-- Modificación de Tablas
-- 

--
-- Gestionar una tabla "nueva"
-- 1. Crear una tabla "nueva" de su iniciativa (una tabla coherente con el sistema con su nombre, no coloque "nueva" como nombre)
-- 2 Agregar una clave primaria y otros 3 campos cualquiera a la tabla "nueva"
-- Mínimo un campo tipo texto y uno numérico
CREATE TABLE t_comentario_actividad (
    id_comentario SERIAL PRIMARY KEY,           -- Clave Primaria
    id_actividad INT NOT NULL,                  -- Campo Numérico 
    id_usuario UUID NOT NULL,                   -- Identificador del autor (UUID)
    contenido_comentario TEXT NOT NULL,         -- Mensaje del usuario 
    valoracion_puntos INT DEFAULT 0,
    CONSTRAINT fk_comentario_usuario FOREIGN KEY (id_usuario)
        REFERENCES t_usuario(id_usuario),
    CONSTRAINT fk_comentario_actividad FOREIGN KEY (id_actividad)
        REFERENCES t_publicacion_actividad(id_actividad)
);

-- 3
-- Quitar uno de los campos de la tabla "nueva"
--
ALTER TABLE t_comentario_actividad 
DROP COLUMN valoracion_puntos;

-- 4
-- Cambiar el nombre de la tabla "nueva" a otro nombre "otro_nombre"
-- Todas las operaciones siguientes se realizan sobre la tabla renombrada
--
ALTER TABLE t_comentario_actividad 
RENAME TO t_auditoria_sistema;
-- 5 
-- Agregar un campo único a la tabla 
--
ALTER TABLE t_auditoria_sistema 
ADD COLUMN codigo_reporte VARCHAR(20) UNIQUE;
-- 6
-- Agregar 2 fechas de inicio y fin; y colocar un control de orden de fechas
--
ALTER TABLE t_auditoria_sistema 
ADD COLUMN fecha_inicio TIMESTAMP,
ADD COLUMN fecha_fin TIMESTAMP,
ADD CONSTRAINT chk_orden_fechas CHECK (fecha_inicio <= fecha_fin);

-- 7
-- Agregar 1 campo entero y colocar un control para que no sea negativo
--
ALTER TABLE t_auditoria_sistema 
ADD COLUMN nivel_importancia INT,
ADD CONSTRAINT chk_no_negativo CHECK (nivel_importancia >= 0);

-- 8
-- Modificar el tamaño de un campo texto de la tabla renombra
--
ALTER TABLE t_auditoria_sistema 
ALTER COLUMN contenido_comentario TYPE VARCHAR(1000);

-- 9
-- Modificar el campo numeríco y colocar un control de rango 
--
ALTER TABLE t_auditoria_sistema 
ADD CONSTRAINT chk_rango_importancia CHECK (nivel_importancia BETWEEN 1 AND 10);

-- 10
-- Agregar un índice a la tabla (cualquier campo)
--
CREATE INDEX idx_usuario_auditoria ON t_auditoria_sistema (id_usuario);

--
-- 11 
-- Eliminar una de las fechas
--
ALTER TABLE t_auditoria_sistema 
DROP COLUMN fecha_fin;

-- 12
-- Borrar todos los datos de una tabla sin dejar traza
--
TRUNCATE TABLE t_auditoria_sistema RESTART IDENTITY;