------------------------CREACION DE TIPOS------------------------

CREATE OR REPLACE TYPE Tipo_Tarea AS OBJECT (
    ID NUMBER(10),
    Tipo VARCHAR2(50),
    Finalizada NUMBER(1)
);
/

CREATE OR REPLACE TYPE ListaTareas AS TABLE OF Tipo_Tarea;
/

CREATE OR REPLACE TYPE Tipo_Cliente AS OBJECT (
    DNI VARCHAR2(10),
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Direccion VARCHAR2(50),
    Ciudad VARCHAR2(50),
    Provincia VARCHAR2(50),
    Codigo_Postal VARCHAR2(50),
    Correo_Electronico VARCHAR2(50),
    Telefono VARCHAR2(50)
);
/ 

CREATE OR REPLACE TYPE Tipo_Proyecto AS OBJECT (
    ID NUMBER(10),
    Nombre VARCHAR2(50),
    Fecha_Inicio DATE,
    Fecha_Finalizacion_Prevista DATE,
    Fecha_Finalizacion_Real DATE,
    Cliente VARCHAR2(10),
    Equipo NUMBER(10),
    SeDivide ListaTareas
);
/

CREATE OR REPLACE TYPE ListaProyectos AS TABLE OF REF Tipo_Proyecto;
/

CREATE OR REPLACE TYPE ListaProyectosTabla AS TABLE OF Tipo_Proyecto;
/


CREATE OR REPLACE TYPE Tipo_Empleado AS OBJECT (
    ID NUMBER(10),
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Correo VARCHAR2(50),
    Telefono VARCHAR2(50),
    Equipo NUMBER(10),
    Rol VARCHAR2(50),
    Desarrolla ListaProyectos
);
/

CREATE OR REPLACE TYPE ListaEmpleados AS TABLE OF REF Tipo_Empleado;
/

CREATE OR REPLACE TYPE ListaEmpleadosTabla AS TABLE OF Tipo_Empleado;
/

CREATE OR REPLACE TYPE Tipo_Equipo AS OBJECT (
    ID NUMBER(10),
    Nombre VARCHAR2(50),
    TrabajaEn ListaProyectos,
    EstaFormado ListaEmpleados
);
/

CREATE OR REPLACE TYPE Tipo_Pago AS OBJECT (
    ID NUMBER(10),
    Proyecto NUMBER(10),
    Cliente VARCHAR2(10),
    Fecha_Pago DATE,
    Monto NUMBER(10)
);
/