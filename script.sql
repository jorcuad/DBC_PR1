DROP TABLE LINEAPEDIDO;
DROP TABLE REFERENCIA;
DROP TABLE VINO;
DROP TABLE BODEGA;
DROP TABLE LINEACOMPRA;
DROP TABLE COMPRA;
DROP TABLE PEDIDO;
DROP TABLE ESTADOPEDIDO;
DROP TABLE PREFERENCIA;
DROP TABLE ABONADO;
DROP TABLE FACTURA;
DROP TABLE ESTADOFACTURA;
DROP TABLE EMPLEADO;
DROP TABLE PERSONA;


CREATE TABLE PERSONA (
    NIF VARCHAR(9) PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDOS VARCHAR(50) NOT NULL,
    DIRECCION VARCHAR(50) NOT NULL,
    TELEFONO VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(50) NOT NULL,
    CUENTABANCARIA VARCHAR(30)
);

INSERT INTO PERSONA VALUES ('123456789', 'Coke', 'Cuadrado', 'C/Falsa 123', '+34 666 666 666', 'email@example.com', '111222333444555666');
INSERT INTO PERSONA VALUES ('223456789', 'Alvaro', 'Garzo', 'C/Falsa 123', '+34 666 666 666', 'email@example.com', '111222333444555666');



CREATE TABLE EMPLEADO (
    LOGIN VARCHAR(20) PRIMARY KEY,
    NIF VARCHAR(9) NOT NULL,
    PASSWORD VARCHAR(20) NOT NULL,
    FECHAINICIO DATE NOT NULL,
    TIPOEMPLEADO CHAR NOT NULL CHECK (TIPOEMPLEADO = 'C' OR TIPOEMPLEADO = 'P' OR TIPOEMPLEADO = 'A'),
    FOREIGN KEY (NIF) REFERENCES PERSONA(NIF)
);

INSERT INTO EMPLEADO VALUES ('asdf', '123456789', 'qwert', '2015-06-10', 'C');


CREATE TABLE ESTADOFACTURA(
    CLAVE CHAR PRIMARY KEY,
    NOMBRE VARCHAR(20) NOT NULL
);
INSERT INTO ESTADOFACTURA(CLAVE,NOMBRE) VALUES('V','VENCIDA');
INSERT INTO ESTADOFACTURA(CLAVE,NOMBRE) VALUES('C','COM');

CREATE TABLE FACTURA(
    NUMEROFACTURA INTEGER not null PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    FECHAEMISION DATE,
    IMPORTE REAL NOT NULL,
    ESTADO CHAR NOT NULL CHECK (ESTADO = 'V' OR ESTADO = 'C' OR ESTADO = 'R' OR ESTADO = 'G'),
    FECHAPAGO DATE,
    IDEXTRACTOBANCARIO VARCHAR(30),
    FOREIGN KEY (ESTADO) REFERENCES ESTADOFACTURA(CLAVE)
);
INSERT INTO FACTURA(IMPORTE,ESTADO) VALUES(5,'V');
INSERT INTO FACTURA(IMPORTE,ESTADO) VALUES(5,'C');

CREATE TABLE ABONADO(
    NUMEROABONADO INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    NIF VARCHAR(9) NOT NULL,
    LOGIN VARCHAR(15) NOT NULL UNIQUE,
    PASSWORD VARCHAR(15) NOT NULL,
    FOREIGN KEY (NIF) REFERENCES PERSONA(NIF)
);
INSERT INTO ABONADO(NIF, LOGIN, PASSWORD) VALUES('123456789', 'luchurt','1234');
INSERT INTO ABONADO(NIF, LOGIN, PASSWORD) VALUES('223456789', 'jorcuad','1234');

CREATE TABLE ESTADOPEDIDO(
    CLAVE CHAR PRIMARY KEY,
    NOMBRE VARCHAR(20) NOT NULL
);

INSERT INTO ESTADOPEDIDO VALUES ('P', 'PENDIENTE');
INSERT INTO ESTADOPEDIDO VALUES ('T', 'TRAMITADO');
INSERT INTO ESTADOPEDIDO VALUES ('C', 'COMPLETADO');
INSERT INTO ESTADOPEDIDO VALUES ('S', 'SERVIDO');
INSERT INTO ESTADOPEDIDO VALUES ('F', 'FACTURADO');
INSERT INTO ESTADOPEDIDO VALUES ('A', 'ABONADO');

CREATE TABLE PEDIDO(
    NUMERO INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    ESTADO CHAR,
    FECHAREALIZACION DATE,
    NOTAENTREGA VARCHAR(200),
    IMPORTE REAL NOT NULL,
    FECHARECEPCION DATE,
    FECHAENTREGA DATE,
    NUMEROFACTURA INTEGER,
    ABONADO INTEGER,
    FOREIGN KEY(ESTADO) REFERENCES ESTADOPEDIDO(CLAVE),
    FOREIGN KEY(NUMEROFACTURA) REFERENCES FACTURA(NUMEROFACTURA),
    FOREIGN KEY(ABONADO) REFERENCES ABONADO(NUMEROABONADO)
);
INSERT INTO PEDIDO(NUMEROFACTURA,ABONADO,IMPORTE) VALUES (1,1,5);
INSERT INTO PEDIDO(NUMEROFACTURA,ABONADO,IMPORTE) VALUES (2,2,5);


CREATE TABLE COMPRA(
    IDCOMPRA INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    FECHAINICIOCOMPRA DATE NOT NULL,
    RECIBIDACOMPLETA CHAR NOT NULL CHECK (RECIBIDACOMPLETA = 'T' OR RECIBIDACOMPLETA = 'F'),
    FECHACOMPRACOMPLETADA DATE,
    IMPORTE REAL NOT NULL,
    PAGADA CHAR NOT NULL CHECK (PAGADA = 'T' OR PAGADA = 'F'),
    FECHAPAGO DATE
);

CREATE TABLE LINEACOMPRA(
    ID INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    UNIDADES SMALLINT NOT NULL,
    RECIBIDA CHAR NOT NULL CHECK(RECIBIDA = 'T' OR RECIBIDA = 'F'),
    FECHARECEPCION DATE,
    IDCOMPRA INTEGER,
    IDBODEGA INTEGER,
    FOREIGN KEY(IDCOMPRA) REFERENCES COMPRA(IDCOMPRA)/*,
    FOREIGN KEY(IDBODEGA) REFERENCES BODEGA(ID)*/
);

CREATE TABLE BODEGA(
    ID INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    NOMBRE VARCHAR(50) NOT NULL,
    CIF VARCHAR(9) NOT NULL,
    DIRECCION VARCHAR(50) NOT NULL
);

CREATE TABLE VINO(
    ID INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    NOMBRECOMERCIAL VARCHAR(50) NOT NULL,
    ANO SMALLINT NOT NULL,
    COMENTARIO VARCHAR(200) NOT NULL,
    IDDENOMINACION INTEGER NOT NULL,
    CATEGORIA CHAR NOT NULL,
    IDBODEGA INTEGER NOT NULL,
    FOREIGN KEY(IDBODEGA) REFERENCES BODEGA(ID)
);

CREATE TABLE REFERENCIA(
    CODIGO INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    ESPORCAJAS CHAR NOT NULL CHECK (ESPORCAJAS = 'T' OR ESPORCAJAS = 'F'),
    CONTENIDOENCL SMALLINT NOT NULL,
    PRECIO REAL NOT NULL,
    DISPONIBLE CHAR NOT NULL CHECK (DISPONIBLE = 'T' OR DISPONIBLE = 'F'),
    VINOID INTEGER NOT NULL,
    FOREIGN KEY(VINOID) REFERENCES VINO(ID)
);

CREATE TABLE LINEAPEDIDO(
    ID INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    UNIDADES INTEGER NOT NULL,
    COMPLETADA CHAR NOT NULL CHECK (COMPLETADA = 'T' OR COMPLETADA = 'F'),
    CODIGOREFERENCIA INTEGER NOT NULL,
    NUMEROPEDIDO INTEGER NOT NULL,
    IDLINEACOMPRA INTEGER NOT NULL,
    FOREIGN KEY(CODIGOREFERENCIA) REFERENCES REFERENCIA(CODIGO),
    FOREIGN KEY(NUMEROPEDIDO) REFERENCES PEDIDO(NUMERO),
    FOREIGN KEY(IDLINEACOMPRA) REFERENCES LINEACOMPRA(ID)
);

/*
INSERT INTO DENOMINACION () VALUES ();
INSERT INTO VINO (NOMBRECOMERCIAL, ANO, COMENTARIO, IDDENOMINACION, CATEGORIA, IDBODEGA) VALUES ();
INSERT INTO REFERENCIA (ESPORCAJAS, CONTENIDOENCL, PRECIO, DISPONIBLE)  VALUES ('T', 750, 9.99, 'T');
*/
