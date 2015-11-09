#!/usr/bin/env python
# -*- coding: utf-8 -*- 
# Autor: Argenis García Zetina
# Fecha: 23/10/2015
# Versión: 2.2

from optparse import OptionParser
import random
import psycopg2
import sys

parser = OptionParser()
parser.add_option("-v", "--vendedor", help="Asigna numero de vendedores", type="int", default=100)
parser.add_option("-c", "--cliente", help="Asigna numero de clientes", type="int", default=1000)
parser.add_option("-m", "--maximoarticuloventa", help="Asigna cantidad maxima de ocurrencias de un articulo en nota venta", type="int", default=10)
parser.add_option("-n", "--notaventa", help="Asigna numero de notas de venta", type="int", default=500)
#parser.add_option("-d", "--detallenotaventa", help="Asigna cantidad maxima de detalles de nota de venta por nota", type="int", default=10)
parser.add_option("-t", "--tienda", help="Asigna numero de tiendas", type="int", default=200)
parser.add_option("-i", "--ipservidor", help="Especifica la ip o hostname del servidor de base de datos", default="localhost")
parser.add_option("-b", "--basedatos", help="Especifica el nombre de la base de datos", default="fraudes")
parser.add_option("-u", "--usuario", help="Especifica el nombre del usuario de la base de datos", default="postgres")
parser.add_option("-p", "--password", help="Especifica el password de la base de datos", default="sinegra1993")
(options, args) = parser.parse_args()

def getConexion():
	conn = None
	try:
		conn_string = "host='%s' dbname='%s' user='%s' password='%s'" %(options.ipservidor, options.basedatos, options.usuario, options.password)
		conn = psycopg2.connect(conn_string)
	except:
		print "Error en la conexion a la base de datos"
		sys.exit(1)
	return conn

def generarPersona(nombres, apellidos):
	nombre = random.choice(nombres)
	paterno = random.choice(apellidos)
	materno = random.choice(apellidos)
	return "%s %s %s" %(nombre, paterno, materno)

def cargarArchivoTiendas():
	tiendas = [];
	fsr_tiendas = open("lista_tiendas.csv", "r")
	for line in fsr_tiendas:
		data = line.split("|")
		nombre = data[0]
		try:
			tipo_tienda_id = int(data[1])
			tiendas.append((nombre, tipo_tienda_id))
		except:
			pass
	fsr_tiendas.close()
	return tiendas

def cargarArchivoNombres():
	nombres = [];
	fsr_nombres = open("nombres.txt", "r")
	for line in fsr_nombres:
		nombres.append(line.strip("\n"))
	fsr_nombres.close()
	return nombres

def cargarArchivoApellidos():
	apellidos = [];
	fsr_apellidos = open("apellidos.txt", "r")
	for line in fsr_apellidos:
		apellidos.append(line.strip("\n"))
	fsr_apellidos.close()
	return apellidos

def generarTienda(tiendas):
	id_estado = random.randint(1, 32)
	conn = getConexion()
	cursor = conn.cursor()
	sql = """SELECT min(municipio_id), max(municipio_id)
	             FROM municipios 
	             WHERE estado_id = %d;""" %(id_estado) 
	cursor.execute(sql)
	rows = cursor.fetchall()
	menor = rows[0][0]
	mayor = rows[0][1]
	cursor.close()
	conn.close()
	id_municipio = random.randint(menor, mayor)
	dado1 = random.randint(0, len(tiendas) + 100)
	if dado1 >= len(tiendas):
		dado2 = random.randint(1, 4)
		if dado2 == 1:
			dado1 = 0
		elif dado2 == 2:
			dado1 = 13
		elif dado2 == 3:
			dado1 = 22
		elif dado2 == 4:
			dado1 = 34
	tienda = tiendas[dado1]
	nombre_tienda = tienda[0]
	id_tipo_tienda = tienda[1]
	return "%s|%d|%d|%d\n" %(nombre_tienda, id_estado, id_municipio, id_tipo_tienda)

def generarNotaVenta(anterior):
	conn = getConexion()
	cursor = conn.cursor()
	cursor.execute("SELECT min(id_cliente), max(id_cliente) FROM clientes;")
	rows = cursor.fetchall()
	id_cliente = random.randint(rows[0][0], rows[0][1])
	cursor.execute("SELECT min(vendedor_id), max(vendedor_id) FROM vendedores;")
	rows = cursor.fetchall()
	vendedor_id = random.randint(rows[0][0], rows[0][1])
	sql = """SELECT tienda_id
	             FROM vendedores 
	             WHERE vendedor_id = %d;""" %(vendedor_id)
	cursor.execute(sql)
	rows = cursor.fetchall()
	tienda_id = rows[0][0]
	while True:
		intervalo = random.randint(1, 30)
		if intervalo < anterior:
			intervalo += random.randint(1, 5)
		if intervalo >= anterior:
			break
	sql = """INSERT INTO nota_venta (id_cliente, fecha_venta, vendedor_id, tienda_id) 
	             VALUES (%d, now() + interval '%d minute', %d, %d);""" %(id_cliente, intervalo, vendedor_id, tienda_id)
	cursor.execute(sql)
	conn.commit() 
	cursor.close()
	conn.close()
	return intervalo

def generarDetalleNotaVenta(nota_venta_id):
	conn = getConexion()
	cursor = conn.cursor()
	sql = """SELECT count(*)
	             FROM nota_venta nv
	             INNER JOIN tiendas t ON nv.tienda_id = t.tienda_id
	             INNER JOIN articulos_tiendas at ON t.tipo_tienda_id = at.tipo_tienda_id 
	             WHERE nv.nota_venta_id = %d;""" %(nota_venta_id)
	cursor.execute(sql)
	rows = cursor.fetchall()
	cantidad_detalles_nota = random.randint(1, rows[0][0])
	for i in range(0, cantidad_detalles_nota):
		while True:
			sql = """SELECT tienda_id 
			             FROM nota_venta
			             WHERE nota_venta_id = %d;""" %(nota_venta_id)
			cursor.execute(sql)
			rows = cursor.fetchall()
			tienda_id = rows[0][0]
			sql = """SELECT a.articulo_id, a.precio 
		                 FROM tiendas t
		                 INNER JOIN tipos_tienda tt ON t.tipo_tienda_id = tt.tipo_tienda_id 
		                 INNER JOIN articulos_tiendas at ON at.tipo_tienda_id = tt.tipo_tienda_id 
		                 INNER JOIN articulos a ON a.articulo_id = at.articulo_id 
		                 WHERE tienda_id = %d;""" %(tienda_id)
			cursor.execute(sql)
			rows = cursor.fetchall()
			eleccion = random.randint(0, cursor.rowcount - 1)
			articulo_id = rows[eleccion][0]
			precio = rows[eleccion][1]
			sql = """SELECT count(*) 
			             FROM detalle_nota_venta 
			             WHERE nota_venta_id = %d 
			             AND articulo_id = %d;""" %(nota_venta_id, articulo_id)
			cursor.execute(sql)
			rows = cursor.fetchall()
			if rows[0][0] == 0:
				break
		sql = """INSERT INTO detalle_nota_venta (nota_venta_id, articulo_id, precio, cantidad) 
		             VALUES (%d, %d, %f, %d);""" %(nota_venta_id, articulo_id, precio, random.randint(1, options.maximoarticuloventa))
		cursor.execute(sql)
		conn.commit()
	cursor.close()
	conn.close()
	return

def main():
	conn = getConexion()
	cursor = conn.cursor()
	cursor.execute("SELECT count(*) FROM articulos;")
	articulos = cursor.fetchall()
	cursor.execute("SELECT count(*) FROM vendedores;")
	vendedores = cursor.fetchall()	
	cursor.execute("SELECT count(*) FROM estados;")
	estados = cursor.fetchall()
	cursor.execute("SELECT count(*) FROM municipios;")
	municipios = cursor.fetchall()
	cursor.execute("SELECT count(*) FROM tiendas;")
	tienda = cursor.fetchall()
	cursor.execute("SELECT count(*) FROM tipos_tienda;")
	tipos_tienda = cursor.fetchall()
	cursor.execute("SELECT count(*) FROM clientes;")
	clientes = cursor.fetchall()
	cursor.execute("SELECT count(*) FROM articulos_tiendas;")
	articulos_tiendas = cursor.fetchall()
	if estados[0][0] == 0:
		fsr_estados = open("estados.csv", "r")
		cursor.copy_expert(sql="COPY estados(nombre) FROM stdin CSV HEADER;", file=fsr_estados)
		fsr_estados.close()
		conn.commit()
		print "Estados registrados\n"
	if municipios[0][0] == 0:
		fsr_municipios = open("municipios.csv", "r")
		cursor.copy_expert(sql="COPY municipios(nombre,estado_id) FROM stdin CSV HEADER DELIMITER '|';", file=fsr_municipios)
		fsr_municipios.close()
		conn.commit()
		print "Municipios registrados\n"
	if tipos_tienda[0][0] == 0:
		fsr_tipos_tienda = open("tipos_tienda.csv", "r")
		cursor.copy_expert(sql="COPY tipos_tienda(tipo_tienda) FROM stdin CSV HEADER;", file=fsr_tipos_tienda)
		fsr_tipos_tienda.close()
		conn.commit()	
		print "Tipos tienda registrados\n"
	if articulos[0][0] == 0:
		fsr_articulos = open("articulos.csv", "r")
		cursor.copy_expert(sql="COPY articulos(descripcion,precio) FROM stdin CSV HEADER DELIMITER '|';", file=fsr_articulos)
		fsr_articulos.close()
		conn.commit()
		print "Articulos registrados\n"
	if tienda[0][0] == 0:
		tiendas = cargarArchivoTiendas()
		fsw_tiendas = open("tiendas.csv", "w")
		fsw_tiendas.write("nombre|estado_id|municipio_id|tipo_tienda_id\n")
		for i in range(0, options.tienda):
			fsw_tiendas.write(generarTienda(tiendas))
		fsw_tiendas.close()
		fsr_tiendas = open("tiendas.csv", "r")
		cursor.copy_expert(sql="COPY tiendas(nombre,estado_id,municipio_id,tipo_tienda_id) FROM stdin CSV HEADER DELIMITER '|';", file=fsr_tiendas)
		fsr_tiendas.close()
		conn.commit()
		print "Tiendas registradas\n"
	if articulos_tiendas[0][0] == 0:
		fsr_articulos_tiendas = open("articulos_tiendas.csv", "r")
		cursor.copy_expert(sql="COPY articulos_tiendas(articulo_id,tipo_tienda_id) FROM stdin CSV HEADER DELIMITER '|';", file=fsr_articulos_tiendas)
		fsr_articulos_tiendas.close()
		conn.commit()
		print "Articulos asignados a las tiendas\n"
	nombres = cargarArchivoNombres()
	apellidos = cargarArchivoApellidos()
	if clientes[0][0] == 0:
		fsw_clientes = open("clientes.csv", "w")
		fsw_clientes.write("edad|nombre\n")
		for i in range(0, options.cliente):
			edad = random.randint(18, 77)
			fsw_clientes.write("%d|%s\n" %(edad, generarPersona(nombres, apellidos)))
		fsw_clientes.close()
		fsr_clientes = open("clientes.csv", "r")
		cursor.copy_expert(sql="COPY clientes(edad,nombre) FROM stdin CSV HEADER DELIMITER '|';", file=fsr_clientes)
		fsr_clientes.close()
		conn.commit()
		print "Clientes registrados\n"
	if vendedores[0][0] == 0:
		fsw_vendedores = open("vendedores.csv", "w")
		fsw_vendedores.write("nombre|tienda_id\n")
		for i in range(0, options.vendedor):
			tienda_id = random.randint(1, options.tienda)
			fsw_vendedores.write("%s|%d\n" %(generarPersona(nombres, apellidos), tienda_id))
		fsw_vendedores.close()
		fsr_vendedores = open("vendedores.csv", "r")
		cursor.copy_expert(sql="COPY vendedores(nombre,tienda_id) FROM stdin CSV HEADER DELIMITER '|';", file=fsr_vendedores)
		fsr_vendedores.close()
		conn.commit()
		print "Vendedores registrados\n"
	anterior = 0
	for i in range(0, options.notaventa):
		anterior = generarNotaVenta(anterior)
		print "Notas de venta %d de %d generadas\n" %(i + 1, options.notaventa)
	sql = "SELECT max(nota_venta_id) - %d + 1, max(nota_venta_id) FROM nota_venta;" %(options.notaventa)
	cursor.execute(sql)
	rows = cursor.fetchall()
	primer_nota = rows[0][0]
	ultima_nota = rows[0][1]
	cursor.close()
	conn.close()
	for i in range(primer_nota, ultima_nota + 1):
		generarDetalleNotaVenta(i)
		print "Detalles de nota de venta %d generadas\n" %(i)
	
if __name__ == "__main__":
	main()
