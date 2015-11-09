
CREATE SEQUENCE vendedores_vendedor_id_seq;

CREATE TABLE vendedores (
                vendedor_id INTEGER NOT NULL DEFAULT nextval('vendedores_vendedor_id_seq'),
                nombre VARCHAR(128) NOT NULL,
                tienda_id INTEGER NOT NULL,
                CONSTRAINT vendedores_pk PRIMARY KEY (vendedor_id)
);
COMMENT ON TABLE vendedores IS 'Tabla de vendedores.';
COMMENT ON COLUMN vendedores.vendedor_id IS 'Id del vendedor.';
COMMENT ON COLUMN vendedores.nombre IS 'Nombre completo del vendedor.';
COMMENT ON COLUMN vendedores.tienda_id IS 'Identificador de la tienda';


ALTER SEQUENCE vendedores_vendedor_id_seq OWNED BY vendedores.vendedor_id;

CREATE SEQUENCE tipos_tienda_tipo_tienda_id_seq;

CREATE TABLE tipos_tienda (
                tipo_tienda_id INTEGER NOT NULL DEFAULT nextval('tipos_tienda_tipo_tienda_id_seq'),
                tipo_tienda VARCHAR(64) NOT NULL,
                CONSTRAINT tipos_tienda_pk PRIMARY KEY (tipo_tienda_id)
);
COMMENT ON TABLE tipos_tienda IS 'Tabla de tipos de tiendas';
COMMENT ON COLUMN tipos_tienda.tipo_tienda_id IS 'Identificador del tipo de tienda';
COMMENT ON COLUMN tipos_tienda.tipo_tienda IS 'Tipo de tienda.';


ALTER SEQUENCE tipos_tienda_tipo_tienda_id_seq OWNED BY tipos_tienda.tipo_tienda_id;

CREATE SEQUENCE estados_estado_id_seq;

CREATE TABLE estados (
                estado_id INTEGER NOT NULL DEFAULT nextval('estados_estado_id_seq'),
                nombre VARCHAR(128) NOT NULL,
                CONSTRAINT estados_pk PRIMARY KEY (estado_id)
);
COMMENT ON TABLE estados IS 'Estados del país';
COMMENT ON COLUMN estados.estado_id IS 'Identificador del estado';
COMMENT ON COLUMN estados.nombre IS 'Nombre del estado';


ALTER SEQUENCE estados_estado_id_seq OWNED BY estados.estado_id;

CREATE SEQUENCE municipios_municipio_id_seq;

CREATE TABLE municipios (
                municipio_id INTEGER NOT NULL DEFAULT nextval('municipios_municipio_id_seq'),
                nombre VARCHAR(128) NOT NULL,
                estado_id INTEGER NOT NULL,
                CONSTRAINT municipios_pk PRIMARY KEY (municipio_id)
);
COMMENT ON TABLE municipios IS 'Tabla de municipios';
COMMENT ON COLUMN municipios.municipio_id IS 'Identificador del municipio';
COMMENT ON COLUMN municipios.nombre IS 'Nombre del municipio';
COMMENT ON COLUMN municipios.estado_id IS 'Identificador del estado';


ALTER SEQUENCE municipios_municipio_id_seq OWNED BY municipios.municipio_id;

CREATE SEQUENCE tiendas_tienda_id_seq;

CREATE TABLE tiendas (
                tienda_id INTEGER NOT NULL DEFAULT nextval('tiendas_tienda_id_seq'),
                nombre VARCHAR(128) NOT NULL,
                estado_id INTEGER NOT NULL,
                municipio_id INTEGER NOT NULL,
                tipo_tienda_id INTEGER NOT NULL,
                CONSTRAINT tiendas_pk PRIMARY KEY (tienda_id)
);
COMMENT ON TABLE tiendas IS 'Tienda que emite la nota de venta';
COMMENT ON COLUMN tiendas.tienda_id IS 'Identificador de la tienda';
COMMENT ON COLUMN tiendas.nombre IS 'Nombre de la tienda';
COMMENT ON COLUMN tiendas.estado_id IS 'Identificador del estado';
COMMENT ON COLUMN tiendas.municipio_id IS 'Identificador del municipio';
COMMENT ON COLUMN tiendas.tipo_tienda_id IS 'Identificador del tipo de tienda';


ALTER SEQUENCE tiendas_tienda_id_seq OWNED BY tiendas.tienda_id;

CREATE SEQUENCE clientes_id_cliente_seq;

CREATE TABLE clientes (
                id_cliente INTEGER NOT NULL DEFAULT nextval('clientes_id_cliente_seq'),
                edad SMALLINT NOT NULL,
                nombre VARCHAR(128) NOT NULL,
                CONSTRAINT clientes_pk PRIMARY KEY (id_cliente)
);
COMMENT ON TABLE clientes IS 'Tabla de clientes';
COMMENT ON COLUMN clientes.id_cliente IS 'Llave primaria del cliente';
COMMENT ON COLUMN clientes.edad IS 'Edad en años del cliente.';


ALTER SEQUENCE clientes_id_cliente_seq OWNED BY clientes.id_cliente;

CREATE SEQUENCE nota_venta_nota_venta_id_seq;

CREATE TABLE nota_venta (
                nota_venta_id INTEGER NOT NULL DEFAULT nextval('nota_venta_nota_venta_id_seq'),
                id_cliente INTEGER NOT NULL,
                fecha_deteccion TIMESTAMP,
                fecha_venta TIMESTAMP DEFAULT now(),
                fraude_flag BOOLEAN DEFAULT false NOT NULL,
                vendedor_id INTEGER NOT NULL,
                tienda_id INTEGER NOT NULL,
                CONSTRAINT nota_venta_pk PRIMARY KEY (nota_venta_id)
);
COMMENT ON TABLE nota_venta IS 'Nota de venta';
COMMENT ON COLUMN nota_venta.nota_venta_id IS 'Id de la nota de venta';
COMMENT ON COLUMN nota_venta.id_cliente IS 'Llave primaria del cliente';
COMMENT ON COLUMN nota_venta.fecha_deteccion IS 'Fecha en que se detectó el status.';
COMMENT ON COLUMN nota_venta.fecha_venta IS 'Fecha de la venta.';
COMMENT ON COLUMN nota_venta.fraude_flag IS 'Bandera de fraude.';
COMMENT ON COLUMN nota_venta.vendedor_id IS 'Id del vendedor.';
COMMENT ON COLUMN nota_venta.tienda_id IS 'Identificador de la tienda';


ALTER SEQUENCE nota_venta_nota_venta_id_seq OWNED BY nota_venta.nota_venta_id;

CREATE SEQUENCE articulos_articulo_id_seq;

CREATE TABLE articulos (
                articulo_id INTEGER NOT NULL DEFAULT nextval('articulos_articulo_id_seq'),
                descripcion VARCHAR(128) NOT NULL,
                precio NUMERIC(9,2) NOT NULL,
                CONSTRAINT articulos_pk PRIMARY KEY (articulo_id)
);
COMMENT ON TABLE articulos IS 'Table de artículos';
COMMENT ON COLUMN articulos.articulo_id IS 'Llave primaria del artículos';
COMMENT ON COLUMN articulos.descripcion IS 'Descripción del artículo';
COMMENT ON COLUMN articulos.precio IS 'Precio del artículo en pesos.';


ALTER SEQUENCE articulos_articulo_id_seq OWNED BY articulos.articulo_id;

CREATE TABLE detalle_nota_venta (
                nota_venta_id INTEGER NOT NULL,
                articulo_id INTEGER NOT NULL,
                precio NUMERIC(9,2) NOT NULL,
                cantidad SMALLINT NOT NULL,
                CONSTRAINT detalle_nota_venta_pk PRIMARY KEY (nota_venta_id, articulo_id)
);
COMMENT ON TABLE detalle_nota_venta IS 'Detalle de la nota de venta.';
COMMENT ON COLUMN detalle_nota_venta.nota_venta_id IS 'Id de la nota de venta';
COMMENT ON COLUMN detalle_nota_venta.articulo_id IS 'Llave primaria del artículos';
COMMENT ON COLUMN detalle_nota_venta.precio IS 'Precio de venta.';
COMMENT ON COLUMN detalle_nota_venta.cantidad IS 'Cantidad de artículos.';


CREATE TABLE articulos_tiendas (
                articulo_id INTEGER NOT NULL,
                tipo_tienda_id INTEGER NOT NULL,
                CONSTRAINT articulos_tiendas_pk PRIMARY KEY (articulo_id, tipo_tienda_id)
);
COMMENT ON TABLE articulos_tiendas IS 'Tabla intermedia';
COMMENT ON COLUMN articulos_tiendas.articulo_id IS 'Llave primaria del artículos';
COMMENT ON COLUMN articulos_tiendas.tipo_tienda_id IS 'Identificador del tipo de tienda';


ALTER TABLE nota_venta ADD CONSTRAINT vendedores_nota_venta_fk
FOREIGN KEY (vendedor_id)
REFERENCES vendedores (vendedor_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE articulos_tiendas ADD CONSTRAINT tipos_tienda_articulos_tiendas_fk
FOREIGN KEY (tipo_tienda_id)
REFERENCES tipos_tienda (tipo_tienda_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE municipios ADD CONSTRAINT estados_municipios_fk
FOREIGN KEY (estado_id)
REFERENCES estados (estado_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE tiendas ADD CONSTRAINT estados_tienda_fk
FOREIGN KEY (estado_id)
REFERENCES estados (estado_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE tiendas ADD CONSTRAINT municipios_tienda_fk
FOREIGN KEY (municipio_id)
REFERENCES municipios (municipio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE tiendas ADD CONSTRAINT tipos_tienda_tienda_fk
FOREIGN KEY (tipo_tienda_id)
REFERENCES tipos_tienda (tipo_tienda_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE nota_venta ADD CONSTRAINT tienda_nota_venta_fk
FOREIGN KEY (tienda_id)
REFERENCES tiendas (tienda_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE nota_venta ADD CONSTRAINT clientes_nota_venta_fk
FOREIGN KEY (id_cliente)
REFERENCES clientes (id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE detalle_nota_venta ADD CONSTRAINT nota_venta_detalle_nota_venta_fk
FOREIGN KEY (nota_venta_id)
REFERENCES nota_venta (nota_venta_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE articulos_tiendas ADD CONSTRAINT articulos_articulos_tiendas_fk
FOREIGN KEY (articulo_id)
REFERENCES articulos (articulo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE detalle_nota_venta ADD CONSTRAINT articulos_detalle_nota_venta_fk
FOREIGN KEY (articulo_id)
REFERENCES articulos (articulo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
