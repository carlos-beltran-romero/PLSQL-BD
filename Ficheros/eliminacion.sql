--ELIMINACION EN ORDEN DE TODAS LAS TABLAS, PAQUETES, SECUENCIAS, ETC
DROP TRIGGER TRG_ELIMINAR_EQUIPO;
DROP TRIGGER TRG_ELIMINAR_CLIENTE;
DROP TRIGGER TRG_MODIFICAR_CLIENTE_PROYECTO;
DROP TRIGGER TRG_MODIFICAR_FECHA_PROYECTO;
DROP TRIGGER TRG_MODIFICAR_FECHA_FIN_PROYECTO;

DROP SEQUENCE pago_seq;
DROP SEQUENCE empleado_seq;
DROP SEQUENCE tarea_seq;
DROP SEQUENCE equipo_seq;
DROP SEQUENCE proyecto_seq;

DROP TABLE Pago CASCADE CONSTRAINTS;
DROP TABLE Proyecto CASCADE CONSTRAINTS;
DROP TABLE Empleado CASCADE CONSTRAINTS;
DROP TABLE Equipo CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Tarea CASCADE CONSTRAINTS;

DROP TYPE Tipo_Equipo FORCE;
DROP TYPE ListaEmpleadosTabla FORCE;
DROP TYPE ListaEmpleados FORCE;
DROP TYPE Tipo_Empleado FORCE;
DROP TYPE ListaProyectosTabla FORCE;
DROP TYPE ListaProyectos FORCE;
DROP TYPE Tipo_Proyecto FORCE;
DROP TYPE Tipo_Cliente FORCE;
DROP TYPE ListaTareas FORCE;
DROP TYPE Tipo_Tarea FORCE;
DROP TYPE Tipo_Pago FORCE;

DROP PACKAGE PACK_PROYECTO;
DROP PACKAGE PACK_EMPLEADO;
DROP PACKAGE PACK_EQUIPO;
DROP PACKAGE PACK_CLIENTE;



