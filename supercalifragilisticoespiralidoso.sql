%psql.sql SELECT t.nombre "Empresa", a.descripcion "Producto",
	TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(YEAR FROM nv.fecha_venta), '9999')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MONTH FROM nv.fecha_venta), '99')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(DAY FROM nv.fecha_venta), '99')) || ' ' || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(HOUR FROM nv.fecha_venta), '99')) || ':' || LPAD(TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MINUTE FROM nv.fecha_venta), '99')), 2, '0') "Fecha venta",
	SUM(dnv.precio) "Total vendido", 
	SUM(dnv.cantidad) "# de productos vendidos",
	COUNT(*) "# de transacciones"
	FROM tiendas t
	INNER JOIN nota_venta nv ON nv.tienda_id = t.tienda_id
	INNER JOIN detalle_nota_venta dnv ON dnv.nota_venta_id = nv.nota_venta_id
	INNER JOIN articulos a ON a.articulo_id = dnv.articulo_id
	WHERE t.nombre IN ('OXXO','K','7 Eleven')
	GROUP BY t.nombre, a.descripcion,                                                                     
	TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(YEAR FROM nv.fecha_venta), '9999')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MONTH FROM nv.fecha_venta), '99')) || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(DAY FROM nv.fecha_venta), '99')) || ' ' || TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(HOUR FROM nv.fecha_venta), '99')) || ':' || LPAD(TRIM(BOTH ' ' FROM TO_CHAR(EXTRACT(MINUTE FROM nv.fecha_venta), '99')), 2, '0')
	ORDER BY t.nombre, 2;

%psql.sql SELECT a.descripcion "Articulo", SUM(dnv.precio * dnv.cantidad) "Total"
	FROM articulos a
	INNER JOIN detalle_nota_venta dnv ON dnv.articulo_id = a.articulo_id
	INNER JOIN nota_venta nv ON nv.nota_venta_id = dnv.nota_venta_id
	INNER JOIN tiendas t ON t.tienda_id = nv.tienda_id
	WHERE t.nombre = 'OXXO'
	GROUP BY a.descripcion
	ORDER BY 2 DESC
	LIMIT 10;

%psql.sql SELECT a.descripcion,
	lpad(trim(both ' ' from to_char(extract(day FROM nv.fecha_venta),'99')),2,'0')||'/'||lpad(trim(both ' ' from to_char(extract(month FROM nv.fecha_venta),'99')),2,'0')||'/'||trim(both ' ' from to_char(extract(year FROM nv.fecha_venta),'9999')) "Fecha venta",SUM(dnv.cantidad) "Cantidad de unidades vendidas"
	FROM articulos a
	INNER JOIN detalle_nota_venta dnv ON a.articulo_id = dnv.articulo_id
	INNER JOIN nota_venta nv ON nv.nota_venta_id = dnv.nota_venta_id
	INNER JOIN tiendas t ON nv.tienda_id = t.tienda_id
	WHERE t.nombre = 'OXXO'
	GROUP BY a.descripcion,
	lpad(trim(both ' ' from to_char(extract(day FROM nv.fecha_venta),'99')),2,'0')||'/'||lpad(trim(both ' ' from to_char(extract(month FROM nv.fecha_venta),'99')),2,'0')||'/'||trim(both ' ' from to_char(extract(year FROM nv.fecha_venta),'9999'))
	ORDER BY to_date(lpad(trim(both ' ' from to_char(extract(day FROM nv.fecha_venta),'99')),2,'0')||'/'||lpad(trim(both ' ' from to_char(extract(month FROM nv.fecha_venta),'99')),2,'0')||'/'||trim(both ' ' from to_char(extract(year FROM nv.fecha_venta),'9999')),'dd/mm/yyyy');

%psql.sql SELECT a.descripcion,
	lpad(trim(both ' ' from to_char(extract(hour FROM nv.fecha_venta),'99')),2,'0')||':'
	||CASE 
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 0 AND 5 THEN '05' 
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 6 AND 10 THEN '10'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 11 AND 15 THEN '15'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 16 AND 20 THEN '20'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 21 AND 25 THEN '25'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 26 AND 30 THEN '30'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 31 AND 35 THEN '35'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 36 AND 40 THEN '40'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 41 AND 45 THEN '45'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 46 AND 50 THEN '50'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 51 AND 55 THEN '55'
		ELSE '59'
	END "Hora venta",
	SUM(dnv.precio * dnv.cantidad) "Total"
	FROM articulos a
	INNER JOIN detalle_nota_venta dnv ON a.articulo_id = dnv.articulo_id
	INNER JOIN nota_venta nv ON nv.nota_venta_id = dnv.nota_venta_id
	INNER JOIN tiendas t ON nv.tienda_id = t.tienda_id
	WHERE t.nombre = 'OXXO'
	AND extract(day FROM nv.fecha_venta) = extract(day FROM now())
	AND extract(month FROM nv.fecha_venta) = extract(month FROM now())
	AND extract(year FROM nv.fecha_venta) = extract(year FROM now())
	AND a.descripcion IN ('Agua','Cerveza','Refresco','Leche')
	GROUP BY a.descripcion,
	lpad(trim(both ' ' from to_char(extract(hour FROM nv.fecha_venta),'99')),2,'0')||':'
	||CASE 
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 0 AND 5 THEN '05' 
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 6 AND 10 THEN '10'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 11 AND 15 THEN '15'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 16 AND 20 THEN '20'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 21 AND 25 THEN '25'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 26 AND 30 THEN '30'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 31 AND 35 THEN '35'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 36 AND 40 THEN '40'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 41 AND 45 THEN '45'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 46 AND 50 THEN '50'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 51 AND 55 THEN '55'
		ELSE '59'
	END 
	ORDER BY 
	lpad(trim(both ' ' from to_char(extract(hour FROM nv.fecha_venta),'99')),2,'0')||':'
	||CASE 
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 0 AND 5 THEN '05' 
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 6 AND 10 THEN '10'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 11 AND 15 THEN '15'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 16 AND 20 THEN '20'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 21 AND 25 THEN '25'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 26 AND 30 THEN '30'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 31 AND 35 THEN '35'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 36 AND 40 THEN '40'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 41 AND 45 THEN '45'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 46 AND 50 THEN '50'
		WHEN extract(minute FROM nv.fecha_venta) BETWEEN 51 AND 55 THEN '55'
		ELSE '59'
	END;

%psql.sql SELECT date_trunc('day', dd):: date as fecha, 10 + random() * (500 - 10 + 1) "Monto"
		FROM generate_series
        ( to_date('27/10/2015','dd/mm/yyyy')::timestamp 
        , now()::timestamp
        , '1 day'::interval) dd;