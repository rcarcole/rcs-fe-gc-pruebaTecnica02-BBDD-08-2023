-- ejercicio 01
USE directores;
-- 5.1
SELECT DNI, NomApels FROM directores;

-- 5.2
SELECT * FROM directores WHERE DNIJefe IS NULL;

-- 5.3
SELECT d.NomApels, de.capacidad FROM directores d JOIN despachos de ON d.Despacho = de.numero;

-- 5.4
SELECT Despacho, COUNT(DNI) as NumeroDeDirectores FROM directores GROUP BY Despacho;

-- 5.5
SELECT dir1.* FROM directores dir1 JOIN directores dir2 ON dir1.DNIJefe = dir2.DNI WHERE dir2.DNIJefe IS NULL;

-- 5.6
SELECT dir1.NomApels AS NombreDirector, dir2.NomApels AS NombreJefe FROM directores dir1
LEFT JOIN directores dir2 ON dir1.DNIJefe = dir2.DNI;

-- 5.7
SELECT COUNT(*) as DespachosSobreutilizados
FROM (
    SELECT d.Despacho FROM directores d
    JOIN despachos de ON d.Despacho = de.numero
    GROUP BY d.Despacho, de.capacidad
    HAVING COUNT(d.DNI) > de.capacidad
) as subquery;

-- 5.8
INSERT INTO despachos (numero) VALUES (124);
INSERT INTO directores (DNI, NomApels, DNIJefe, Despacho) VALUES ('28301700', 'Paco Pérez', NULL, 124);
SELECT * FROM despachos WHERE numero = 124;

-- 5.9
SELECT * FROM directores WHERE DNI = '74568521';
INSERT INTO directores (DNI, NomApels) VALUES ('74568521', 'Nombre del Jefe'); 
UPDATE directores SET DNIJefe = '74568521' WHERE NomApels LIKE '%Pérez%';

-- 5.10
DELETE FROM directores
WHERE DNIJefe IS NOT NULL;



/* -------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
------------------------------------------------------- */



-- Ejercicio 02
USE piezasproveedores;
-- 6.1
SELECT Nombre FROM piezas;

-- 6.2
SELECT * FROM proveedores;

-- 6.3
SELECT AVG(Precio) AS PrecioMedio FROM suministra;

-- 6.4
SELECT p.Nombre  FROM proveedores p 
JOIN suministra s ON p.id = s.IdProveedor WHERE s.CodigoPieza = 1;

-- 6.5
SELECT pi.Nombre 
FROM piezas pi
JOIN suministra s ON pi.Codigo = s.CodigoPieza
WHERE s.IdProveedor = 'HAL';

-- 6.6
SELECT p.Nombre AS NombreProveedor, pi.Nombre AS NombrePieza, s.Precio FROM proveedores p
JOIN suministra s ON p.id = s.IdProveedor
JOIN piezas pi ON s.CodigoPieza = pi.Codigo
WHERE s.Precio = (SELECT MAX(Precio) FROM suministra);

-- 6.7
INSERT INTO proveedores (id, Nombre) VALUES ('TNBC', 'Skellington Supplies');
INSERT INTO suministra (CodigoPieza, IdProveedor, Precio) VALUES (1, 'TNBC', 7);
SELECT * FROM proveedores where Nombre = 'Skellington Supplies';

-- 6.8
UPDATE suministra SET Precio = Precio + 1;

-- 6.9
SELECT * FROM suministra WHERE idProveedor = 'RBT';
DELETE FROM suministra WHERE IdProveedor = 'RBT';
SELECT * FROM suministra WHERE idProveedor = 'RBT';

-- 6.10
DELETE FROM suministra WHERE IdProveedor = 'RBT' AND CodigoPieza = 4;




/* -------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
------------------------------------------------------- */



-- Ejercicio03
USE cientificos;
-- 7.1
SELECT c.DNI, c.NomApels AS 'Nombre del Cientifico', p.id AS 'Identificador del Proyecto', p.Nombre AS 'Nombre del Proyecto' FROM cientificos c
JOIN asignado_a a ON c.DNI = a.cientifico
JOIN proyecto p ON a.proyecto = p.id
ORDER BY p.id, c.DNI;

-- 7.2
SELECT c.DNI, c.NomApels AS 'Nombre del Cientifico', COUNT(a.proyecto) AS 'Numero de Proyectos' FROM cientificos c
LEFT JOIN asignado_a a ON c.DNI = a.cientifico
GROUP BY c.DNI, c.NomApels ORDER BY c.DNI;

-- 7.3
SELECT p.id AS 'Identificador del Proyecto', p.Nombre AS 'Nombre del Proyecto', COUNT(a.cientifico) AS 'Numero de Cientificos' FROM proyecto p
LEFT JOIN asignado_a a ON p.id = a.proyecto
GROUP BY p.id, p.Nombre ORDER BY p.id;


-- 7.4
SELECT c.DNI, c.NomApels AS 'Nombre del Cientifico', SUM(p.Horas) AS 'Horas Totales de Dedicacion' FROM cientificos c
LEFT JOIN asignado_a a ON c.DNI = a.cientifico
LEFT JOIN proyecto p ON a.proyecto = p.id
GROUP BY c.DNI, c.NomApels ORDER BY c.DNI;

-- 7.5
INSERT INTO cientificos (DNI, NomApels) VALUES ('X5678901', 'Jacinto Vera');
INSERT INTO proyecto (id, Nombre, Horas) values ('ABCD', 'Grupo Castilla', 80);
INSERT INTO asignado_a(cientifico, proyecto) values('X5678901','ABCD');

SELECT c.DNI, c.NomApels AS 'Nombre del Cientifico', SUM(p.Horas) / COUNT(DISTINCT p.id) AS 'Dedicacion Media' FROM cientificos c
JOIN asignado_a a ON c.DNI = a.cientifico
JOIN proyecto p ON a.proyecto = p.id
GROUP BY c.DNI, c.NomApels
HAVING COUNT(DISTINCT p.id) > 1 AND (SUM(p.Horas) / COUNT(DISTINCT p.id)) > 80
ORDER BY c.DNI;