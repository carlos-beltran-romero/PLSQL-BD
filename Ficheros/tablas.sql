-------------------------------------CREACION DE TABLAS USANDO LOS TIPOS--------------------------------------------------------------
CREATE TABLE Tarea OF Tipo_Tarea
(
    CONSTRAINT PK_Tarea PRIMARY KEY (ID)
);


CREATE TABLE Cliente OF Tipo_Cliente
(
    CONSTRAINT PK_Cliente PRIMARY KEY (DNI)
);


CREATE TABLE Equipo OF Tipo_Equipo
(
    CONSTRAINT PK_Equipo PRIMARY KEY (ID),
    CONSTRAINT UK_Nombre_Equipo UNIQUE (Nombre)
)
NESTED TABLE TrabajaEn STORE AS ProyectosEquipo,  --ALMACENA LOS PROYECTOS ACTIVOS Y FINALIZADOS DE CADA EQUIPO
NESTED TABLE EstaFormado STORE AS Empleados;


CREATE TABLE Empleado OF Tipo_Empleado
(
    CONSTRAINT PK_Empleado PRIMARY KEY (ID),
    CONSTRAINT FK_Empleado_Equipo FOREIGN KEY (Equipo) REFERENCES Equipo(ID)
)
NESTED TABLE Desarrolla STORE AS ProyectosFinEmpleado; --ALMACENA LOS PROYECTOS FINALIZADOS DE CADA EMPLEADO


CREATE TABLE Proyecto OF Tipo_Proyecto
(
    CONSTRAINT PK_Proyecto PRIMARY KEY (ID),
    CONSTRAINT FK_Proyecto_Equipo FOREIGN KEY (Equipo) REFERENCES Equipo(ID),
    CONSTRAINT UK_Nombre_Proyecto UNIQUE (Nombre),
    Equipo NOT NULL,
    Cliente NOT NULL
)
NESTED TABLE SeDivide STORE AS Tareas;


CREATE TABLE Pago OF Tipo_Pago
(
    CONSTRAINT PK_Pago PRIMARY KEY (ID),
    CONSTRAINT FK_Pago_Proyecto FOREIGN KEY (Proyecto) REFERENCES Proyecto(ID),
    CONSTRAINT FK_Pago_Cliente FOREIGN KEY (Cliente) REFERENCES Cliente(DNI),
    CONSTRAINT UK_Pago_Proyecto UNIQUE (Proyecto),
    Cliente NOT NULL,
    Proyecto NOT NULL
);
