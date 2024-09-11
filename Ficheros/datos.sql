--------------INSERT TAREAS------------------------
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'HTML', 0));
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'CSS', 0));
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'JAVA', 0));
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'PHP', 0));
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'SQL', 0));
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'Diseño', 0));
INSERT INTO Tarea  VALUES (Tipo_Tarea(tarea_seq.NEXTVAL, 'Marketing', 0));
--------------INSERT CLIENTES------------------------
INSERT INTO Cliente 
VALUES ('12345678A', 'Juan', 'Perez', 'Calle 1', 'Calle Alcornocales n12', 'Cadiz', '11011', 'juan@gmail', '956785432');
INSERT INTO Cliente 
VALUES ('32913742X', 'Maria', 'Gonzalez', 'Calle 2', 'Calle Alcornocales n15', 'Cadiz', '11011', 'maria@gmail', '956785432');
INSERT INTO Cliente
VALUES ('32456312M', 'Emilio', 'Contador', 'Calle 1', 'Calle Jacinto', 'Puerto santa Maria', '11011', 'emilio@gmail', '956145321');
INSERT INTO Cliente
VALUES ('45237654M', 'Elena', 'Frais', 'Calle 1', 'Calle Guerrero', 'Puerto santa Maria', '11406', 'Elena@gmail', '965345412');
INSERT INTO Cliente
VALUES ('324567431X', 'Carlos', 'Beltran', 'Jacinto', 'Calle Guerrero', 'Puerto santa Maria', '11408', 'carlos@gmail', '956765456');


--------------INSERT EQUIPOS------------------------
INSERT INTO Equipo VALUES(equipo_seq.NEXTVAL,'Equipo Foliu',NULL,NULL);
INSERT INTO Equipo VALUES(equipo_seq.NEXTVAL,'Equipo Retom',NULL,NULL);

--------------INSERT PROYECTOS------------------------
INSERT INTO Proyecto VALUES (
    proyecto_seq.NEXTVAL, 'FitNation', TO_DATE('2023/05/01', 'yyyy/mm/dd'), TO_DATE('2023/10/31', 'yyyy/mm/dd'), NULL, '12345678A', 1,NULL);--NO FINALIZADO

INSERT INTO Proyecto VALUES (proyecto_seq.NEXTVAL, 'Animals',TO_DATE('2023/01/01', 'yyyy/mm/dd'),TO_DATE('2023/10/02', 'yyyy/mm/dd'),NULL,'32913742X',2,NULL);--NO FINALIZADO

INSERT INTO Proyecto VALUES (proyecto_seq.NEXTVAL, 'GYMRat',TO_DATE('2021/02/01', 'yyyy/mm/dd'),NULL,TO_DATE('2022/10/02', 'yyyy/mm/dd'),'32456312M',2,NULL);--FINALIZADO

INSERT INTO Proyecto VALUES (proyecto_seq.NEXTVAL, 'Foliu',TO_DATE('2022/02/01', 'yyyy/mm/dd'),NULL,TO_DATE('2023/02/02', 'yyyy/mm/dd'),'45237654M',1,NULL);--FINALIZADO

INSERT INTO Proyecto VALUES (proyecto_seq.NEXTVAL, 'GymFit',TO_DATE('2023/02/05', 'yyyy/mm/dd'),TO_DATE('2023/11/02', 'yyyy/mm/dd'),NULL,'324567431X',1,NULL);--NO FINALIZADO


   UPDATE Proyecto
SET SeDivide = ListaTareas((SELECT VALUE(T) FROM Tarea T WHERE T.ID = 1 ),(SELECT VALUE(T) FROM Tarea T WHERE T.ID = 2 ),(SELECT VALUE(T) FROM Tarea T WHERE T.ID = 3 ),(SELECT VALUE(T) FROM Tarea T WHERE T.ID = 4 ),(SELECT VALUE(T) FROM Tarea T WHERE T.ID = 5 ),(SELECT VALUE(T) FROM Tarea T WHERE T.ID = 6 ),(SELECT VALUE(T) FROM Tarea T WHERE T.ID = 7))
WHERE ID = 1 OR ID = 2 OR ID = 3 OR ID = 5 OR ID = 6;

--------------INSERT EMPLEADOS------------------------
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Juan', 'Perez', 'juan@gmail.com', '956785432', 1, 'Back-End',NULL);
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Maria', 'Gonzalez', 'maria@gmail.com', '956585432', 1, 'Front-End',NULL );
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Pedro', 'Gomez', '@pedro@gmail.com', '956785438', 1, 'Diseño',NULL );
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Ana', 'Garcia', 'ana@gmail.com', '956785439', 1, 'Diseñador',NULL );
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Luis', 'Rodriguez', 'luis@gmail.com', '956785430', 2, 'Front-End',NULL );
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Sara', 'Fernandez', 'sara@gmail.com', '956785431', 2, 'Back-End',NULL );
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Carlos', 'Ruiz', 'carlosbome@gmail.com', '956785432', 2, 'Marketing',NULL );
INSERT INTO Empleado (ID, Nombre, Apellido, Correo, Telefono, Equipo, Rol, Desarrolla)
VALUES (empleado_seq.NEXTVAL, 'Laura', 'Torres', '@laurita34@gmail.com', '956785433', 2, 'Diseñador',NULL );

UPDATE Empleado
SET Desarrolla = ListaProyectos((SELECT REF(P) FROM Proyecto P WHERE P.ID = 4))
WHERE ID = 1 OR ID = 2 OR ID = 3 OR ID = 4;

UPDATE Empleado
SET Desarrolla = ListaProyectos((SELECT REF(P) FROM Proyecto P WHERE P.ID = 3))
WHERE ID = 5 OR ID = 6 OR ID = 7 OR ID = 8;


--------------------INSERT PROYECTOS EN EQUIPOS------------------------
UPDATE Equipo
SET TrabajaEn = ListaProyectos((SELECT REF(P) FROM Proyecto P WHERE P.ID = 1), (SELECT REF(P) FROM Proyecto P WHERE P.ID = 4), (SELECT REF(P) FROM Proyecto P WHERE P.ID = 5))
WHERE ID = 1;

UPDATE Equipo
SET EstaFormado=ListaEmpleados((SELECT REF(E) FROM Empleado E WHERE E.ID = 1),(SELECT REF(E) FROM Empleado E WHERE E.ID = 2),(SELECT REF(E) FROM Empleado E WHERE E.ID = 3),(SELECT REF(E) FROM Empleado E WHERE E.ID = 4))
WHERE ID = 1;

UPDATE Equipo
SET TrabajaEn = ListaProyectos((SELECT REF(P) FROM Proyecto P WHERE P.ID = 2),(SELECT REF(P) FROM Proyecto P WHERE P.ID = 3))
WHERE ID = 2;

UPDATE Equipo
SET EstaFormado=ListaEmpleados((SELECT REF(E) FROM Empleado E WHERE E.ID = 5),(SELECT REF(E) FROM Empleado E WHERE E.ID = 6),(SELECT REF(E) FROM Empleado E WHERE E.ID = 7),(SELECT REF(E) FROM Empleado E WHERE E.ID = 8))
WHERE ID = 2;


--------------INSERT PAGO--------------------------

INSERT INTO Pago VALUES (pago_seq.NEXTVAL,1,'12345678A', TO_DATE('2023/05/01', 'yyyy/mm/dd'),1000);
INSERT INTO Pago VALUES (pago_seq.NEXTVAL,2,'32913742X',TO_DATE('2023/01/01', 'yyyy/mm/dd'),2000);
INSERT INTO Pago VALUES (pago_seq.NEXTVAL,3,'32456312M',TO_DATE('2021/02/01', 'yyyy/mm/dd'),3000);
INSERT INTO Pago VALUES (pago_seq.NEXTVAL,4,'45237654M',TO_DATE('2021/02/01', 'yyyy/mm/dd'),4000);
INSERT INTO Pago VALUES (pago_seq.NEXTVAL,5,'324567431X',TO_DATE('2023/05/02', 'yyyy/mm/dd'),5000);