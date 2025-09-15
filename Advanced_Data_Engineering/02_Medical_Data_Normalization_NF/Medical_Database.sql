-- Para trabajar con el csv primero se crea la estructura
-- Creación de una base de datos
CREATE DATABASE medicina_tarea  
CHARACTER SET utf8mb4  
COLLATE utf8mb4_unicode_ci;
USE medicina_tarea;

-- Creación de una tabla temporal
CREATE TABLE medicina
 (  id_paciente	VARCHAR (10),
    nombre VARCHAR(100),
    telefono VARCHAR(50),
    diagnostico VARCHAR (100),
    medico VARCHAR (100))
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 
    COLLATE=utf8mb4_unicode_ci;
    -- DROP TABLE medicina;

-- SE CONVIERTEN LOS DATOS A LATIN, PARA ESO SE ACTIVA/DESACTIVA EL MODO SEGURO.
SET SQL_SAFE_UPDATES = 0;
UPDATE medicina
SET nombre  = CONVERT(CAST(CONVERT(nombre  USING latin1) AS BINARY) USING utf8mb4),
    diagnostico = CONVERT(CAST(CONVERT(diagnostico USING latin1) AS BINARY) USING utf8mb4),
    medico       = CONVERT(CAST(CONVERT(medico       USING latin1) AS BINARY) USING utf8mb4);

SELECT * FROM medicina;

-- Creación de las tablas normalizadas
-- FN1 - Se busca atomizar los valores en las celdas
ALTER TABLE medicina
ADD COLUMN paciente_id INT auto_increment primary key,
ADD COLUMN telefono_privado VARCHAR (50),
ADD COLUMN telefono_trabajo VARCHAR (50),
ADD COLUMN diagnostico_1 VARCHAR (80),
ADD COLUMN diagnostico_2 VARCHAR (80);

-- Se separan los teléfonos y los diagnósticos.
UPDATE medicina
SET 
    diagnostico_1 = SUBSTRING_INDEX(diagnostico, '|', 1),
    diagnostico_2 = CASE
                   WHEN diagnostico LIKE '%|%' THEN SUBSTRING_INDEX(diagnostico, '|', -1)
                   ELSE NULL
                END,
    telefono_privado = SUBSTRING_INDEX(telefono, '|', 1),
    telefono_trabajo = CASE
                   WHEN telefono LIKE '%|%' THEN SUBSTRING_INDEX(telefono, '|', -1)
                   ELSE NULL
                END;

SET SQL_SAFE_UPDATES=1;

select * from medicina;
-- se eliminan las columnas que ya no son útiles
Alter table medicina
drop column telefono,
drop column diagnostico, 
drop column id_paciente;
-- En este punto ya se cumple con la atomización de los datos, consistencia y clave primaria
-- 2FN Y FN3
-- TABLA USUARIOS
-- ----------------------------SE CREAN TABLAS----------------------------------------------------------------------------------------
CREATE TABLE usuarios(
paciente_id INT PRIMARY KEY auto_increment,
nombre VARCHAR (100),
telefono_trabajo VARCHAR (20),
telefono_privado VARCHAR (20) UNIQUE);
 -- drop table usuarios, medicos, diagnostico, padecimientos;
-- SELECT * FROM usuarios;

CREATE TABLE medicos(
id_medico INT PRIMARY KEY auto_increment,
nombre VARCHAR (50) UNIQUE);

CREATE table padecimientos(
id_padecimiento int primary key auto_increment,
padecimiento varchar (100)UNIQUE);
-- drop table padecimientos;

CREATE TABLE diagnostico(
id_diagnostico int primary key auto_increment,
id_medico INT,
paciente_id int,
id_padecimiento int,
FOREIGN KEY (paciente_id) REFERENCES usuarios(paciente_id),
FOREIGN KEY (id_medico) REFERENCES medicos (id_medico),
FOREIGN KEY (id_padecimiento) REFERENCES padecimientos(id_padecimiento));


-- ------------------------INSERTS-----------------
INSERT INTO usuarios (nombre, telefono_trabajo, telefono_privado)
select distinct nombre, telefono_trabajo, telefono_privado
from medicina
where nombre is not null and nombre <>'';
-- select * from usuarios;

INSERT INTO medicos (nombre)
SELECT DISTINCT medico
from medicina
where nombre is not null and nombre <>'';
-- select * from medicos;

INSERT INTO padecimientos (padecimiento)
SELECT DISTINCT diagnostico_1
FROM medicina
WHERE diagnostico_1 IS NOT NULL AND diagnostico_1 <> ''
UNION -- para eliminar los duplicados
SELECT DISTINCT diagnostico_2
FROM medicina
WHERE diagnostico_2 IS NOT NULL AND diagnostico_2 <> '';
select * from padecimientos;

-- Diagnostico_1
INSERT INTO diagnostico (id_medico, paciente_id, id_padecimiento)
SELECT 
    m.id_medico,
    u.paciente_id,
    p.id_padecimiento
FROM medicina tmp
JOIN usuarios u ON tmp.telefono_privado = u.telefono_privado
JOIN medicos m ON tmp.medico = m.nombre
JOIN padecimientos p ON tmp.diagnostico_1 = p.padecimiento
WHERE tmp.diagnostico_1 IS NOT NULL AND tmp.diagnostico_1 <> '';
-- Diagnostico_2
INSERT INTO diagnostico (id_medico, paciente_id, id_padecimiento)
SELECT 
    m.id_medico,
    u.paciente_id,
    p.id_padecimiento
FROM medicina tmp
JOIN usuarios u ON tmp.telefono_privado = u.telefono_privado
JOIN medicos m ON tmp.medico = m.nombre
JOIN padecimientos p ON tmp.diagnostico_2 = p.padecimiento
WHERE tmp.diagnostico_2 IS NOT NULL AND tmp.diagnostico_2 <> '';

select * from diagnostico;

-- CON ESTO QUEDA NORMALIZADA HASTA LA FORMA FN3
/*En el script se alcanzaron las tres primeras formas normales de la siguiente manera:
 para cumplir 1FN se atomizaron los campos multivalor de la tabla staging medicina —separando telefono en telefono_privado y 
 telefono_trabajo y diagnostico en diagnostico_1 y diagnostico_2 (porque esos dos campos venían algunos en pares en una celda)
 y se normalizaron formatos para que cada celda contenga un único valor. Para lograr la 2FN se crearon tablas por entidad 
 (usuarios, medicos, padecimientos) con claves sustitutas (paciente_id, id_medico, id_padecimiento) de modo que los atributos dependan 
 totalmente de su PK correspondiente y no de una parte de una clave compuesta; y para al final, para lograr la 3FN la tabla 
 que relaciona todo (diagnostico) quedó compuesta únicamente por FKs (id_medico, paciente_id, id_padecimiento) vinculadas a sus tablas 
 maestras, eliminando los textos redundantes y las dependencias transitivas.

