use mydb;

DELIMITER $$
CREATE TRIGGER 'actualizarPrecioProducto'
BEFORE UPDATE ON 'productos'
FOR EACH ROW
BEGIN
  IF NEW.coste <> OLD.coste
    THEN
      SET NEW.precio = NEW.coste * 2;
  END IF ;
END$$
DELIMITER ;

SELECT SUBSTR (columna, index de palabra)
FROM tabla
WHERE columna = 'dato';