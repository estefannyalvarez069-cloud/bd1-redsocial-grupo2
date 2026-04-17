--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Probar los scripts en detalle
--

--
-- Modificación de la Base de Datos
-- 


--
-- 1.- DATOS SEMI-ESTRUCTURADOS PARA DATOS PARA BIG DATA
-- Gestionar el campo "perfil_usuario" en tabla "usuarios" 
-- Debe incluir otros datos diferentes al ejemplo del Anexo B
-- 1.- "agregar" un campo tipo JSON o JSNOB
ALTER TABLE t_usuario 
ADD COLUMN perfil_usuario JSONB;
-- 2.- Agregar un par de registros

INSERT INTO t_usuario (id_usuario, nombre_completo, usuario_tag, data_institucional)
VALUES 
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Emmanuel Osorio', '@emma_pascual', '{"facultad": "Ingenieria"}'),
('b1ffbc88-8d0c-3ef7-aa5c-5aa8bc270b22', 'Estefany Dev', '@stef_dev', '{"facultad": "Sistemas"}');

-- Registro 1: Perfil tipo Estudiante con datos de habilidades y cursos
UPDATE t_usuario 
SET perfil_usuario = '{
    "rol": "Estudiante",
    "idiomas": ["Español", "Inglés"],
    "habilidades": ["PostgreSQL", "Python"],
    "certificaciones": [{"nombre": "Data Analyst", "año": 2024}]
}'
WHERE usuario_tag = '@emma_pascual';

-- Registro 2: Tipo egresado con habilidades y experiencia de 4 años 

UPDATE t_usuario 
SET perfil_usuario = '{
    "rol": "Egresado",
    "idiomas": ["Español", "Portugués"],
    "empresa": "Tech Solutions",
    "experiencia_años": 4
}'
WHERE usuario_tag = '@stef_dev';

-- 3. CONSULTA FINAL DE VERIFICACIÓN
SELECT * FROM t_usuario;

--
-- 2.- DATOS SEMI-ESTRUCTURADOS (PARA BIG DATA o IOT)
-- Gestionar un nuevo campo "nombre_campo" (de su propia creación) en cualquier tabla (de las existentes) que considere adecuada
-- 1.- "agregar" un campo tipo JSON o JSONB
ALTER TABLE t_publicacion_actividad 
ADD COLUMN metricas_interaccion JSONB;
-- 2.- Agregar un par de registros de información
-- Primero insertamos la actividad base para que el UPDATE funcione
INSERT INTO t_publicacion_actividad (id_usuario, tipo_categoria, detalle_contenido)
VALUES 
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Evento', '{"titulo": "Seminario Big Data", "lugar": "Auditorio Central"}'),
('b1ffbc88-8d0c-3ef7-aa5c-5aa8bc270b22', 'Post', '{"texto": "¡Hola Mundo Pascualino!", "hashtag": "#Ingenieria"}');

-- Registro 1: Datos tipo IoT (Geolocalización y Dispositivo)
UPDATE t_publicacion_actividad 
SET metricas_interaccion = '{
    "dispositivo": "Android 14",
    "red": "WiFi-Institucional",
    "ubicacion": {"latitud": 6.244, "longitud": -75.581},
    "clima": "24°C",
    "visualizaciones": 450
}'
WHERE id_actividad = 1;

-- Registro 2: Datos tipo Big Data (Engagement y Tags de IA)
UPDATE t_publicacion_actividad 
SET metricas_interaccion = '{
    "reacciones": {"likes": 120, "compartidos": 15},
    "tiempo_promedio_lectura": "45s",
    "etiquetas_ia": ["social", "educacion", "estudiantes"],
    "version_app": "v2.1.0"
}'
WHERE id_actividad = 2;
-- 3.- Consultar la información agregada
SELECT 
    id_actividad,
    tipo_categoria,
    metricas_interaccion->>'dispositivo' AS origen,
    metricas_interaccion->>'visualizaciones' AS vistas
FROM t_publicacion_actividad
WHERE metricas_interaccion IS NOT NULL;


