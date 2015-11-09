SELECT a.descripcion,
lpad(trim(both ' ' from to_char(extract(day FROM nv.fecha_venta),'99')),2,'0')||'/'
||lpad(trim(both ' ' from to_char(extract(month FROM nv.fecha_venta),'99')),2,'0')||'/'
||trim(both ' ' from to_char(extract(year FROM nv.fecha_venta),'9999'))||' '
||lpad(trim(both ' ' from to_char(extract(hour FROM nv.fecha_venta),'99')),2,'0')||':'
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
GROUP BY a.descripcion,
lpad(trim(both ' ' from to_char(extract(day FROM nv.fecha_venta),'99')),2,'0')||'/'
||lpad(trim(both ' ' from to_char(extract(month FROM nv.fecha_venta),'99')),2,'0')||'/'
||trim(both ' ' from to_char(extract(year FROM nv.fecha_venta),'9999'))||' '
||lpad(trim(both ' ' from to_char(extract(hour FROM nv.fecha_venta),'99')),2,'0')||':'
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
ORDER BY a.descripcion,to_date(lpad(trim(both ' ' from to_char(extract(day FROM nv.fecha_venta),'99')),2,'0')||'/'
||lpad(trim(both ' ' from to_char(extract(month FROM nv.fecha_venta),'99')),2,'0')||'/'
||trim(both ' ' from to_char(extract(year FROM nv.fecha_venta),'9999'))||' '
||lpad(trim(both ' ' from to_char(extract(hour FROM nv.fecha_venta),'99')),2,'0')||':'
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
END ,'dd/mm/yyyy');