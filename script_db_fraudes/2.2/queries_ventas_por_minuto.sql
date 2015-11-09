SELECT t.tienda_id,
	t.nombre "Sucursal", 
	TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(YEAR FROM nv.fecha_venta), '9999')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MONTH FROM nv.fecha_venta), '99')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(DAY FROM nv.fecha_venta), '99')) || ' ' || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(HOUR FROM nv.fecha_venta), '99')) || ':' || LPAD(TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MINUTE FROM nv.fecha_venta), '99')), 2, '0') "Fecha venta",
	SUM(dnv.precio) "Total vendido", 
	SUM(dnv.cantidad) "# de productos vendidos",
	COUNT(*) "# de transacciones"
	FROM tiendas t
	INNER JOIN nota_venta nv ON nv.tienda_id = t.tienda_id
	INNER JOIN detalle_nota_venta dnv ON dnv.nota_venta_id = nv.nota_venta_id
	GROUP BY t.tienda_id,
	t.nombre,                                                                 
	TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(YEAR FROM nv.fecha_venta), '9999')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MONTH FROM nv.fecha_venta), '99')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(DAY FROM nv.fecha_venta), '99')) || ' ' || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(HOUR FROM nv.fecha_venta), '99')) || ':' || LPAD(TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MINUTE FROM nv.fecha_venta), '99')), 2, '0')
	ORDER BY t.tienda_id, 3;

SELECT t.nombre "Empresa", 
	TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(YEAR FROM nv.fecha_venta), '9999')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MONTH FROM nv.fecha_venta), '99')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(DAY FROM nv.fecha_venta), '99')) || ' ' || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(HOUR FROM nv.fecha_venta), '99')) || ':' || LPAD(TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MINUTE FROM nv.fecha_venta), '99')), 2, '0') "Fecha venta",
	SUM(dnv.precio) "Total vendido", 
	SUM(dnv.cantidad) "# de productos vendidos",
	COUNT(*) "# de transacciones"
	FROM tiendas t
	INNER JOIN nota_venta nv ON nv.tienda_id = t.tienda_id
	INNER JOIN detalle_nota_venta dnv ON dnv.nota_venta_id = nv.nota_venta_id
	GROUP BY t.nombre,                                                                     
	TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(YEAR FROM nv.fecha_venta), '9999')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MONTH FROM nv.fecha_venta), '99')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(DAY FROM nv.fecha_venta), '99')) || ' ' || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(HOUR FROM nv.fecha_venta), '99')) || ':' || LPAD(TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MINUTE FROM nv.fecha_venta), '99')), 2, '0')
	ORDER BY t.nombre, 2;