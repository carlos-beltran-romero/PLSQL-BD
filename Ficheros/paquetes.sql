--------------------------------------------PROYECTO---------------------------------------------
create or replace PACKAGE PACK_PROYECTO AS
    FUNCTION verEstadoProyecto(id_proyecto IN NUMBER) RETURN VARCHAR2 ;
    FUNCTION equipo(id_proyecto IN NUMBER) RETURN VARCHAR2;-- Devuelve nombre del equipo
    FUNCTION cliente(id_proyecto IN NUMBER) RETURN VARCHAR2;-- Devuelve nombre apellido y dni del cliente
    PROCEDURE finalizarProyecto(id_proyecto IN NUMBER);-- añades contenido a fecha finalizacion
    PROCEDURE actualizarFechaPrevista(id_proyecto IN NUMBER, fecha_prevista IN DATE);
    PROCEDURE cambiarEquipo(id_proyecto IN NUMBER, nuevo_equipo IN NUMBER);-- MODIFICAR ID DE EQUIPO +TRIGGER
    FUNCTION proyectoPorID(id_proyecto IN NUMBER) RETURN VARCHAR2; --DEVUELVE TODA LA INFO DEL PROYECTO
    PROCEDURE finalizarTareaProyecto(id_tarea IN NUMBER, id_proyecto IN NUMBER);--Finaliza la tarea de un proyecto
    FUNCTION factura(id_proyecto IN NUMBER) RETURN VARCHAR2;-- Devuelve la factura del proyecto
END PACK_PROYECTO;
/

create or replace PACKAGE BODY PACK_PROYECTO AS
   FUNCTION verEstadoProyecto(id_proyecto IN NUMBER) RETURN VARCHAR2 IS
    v_tareas_completadas NUMBER;
    v_tareas_totales NUMBER;
    v_fecha DATE;
BEGIN
    SELECT COUNT(*) INTO v_tareas_completadas FROM TABLE(SELECT p.SeDivide FROM Proyecto p WHERE p.ID = id_proyecto) T
        WHERE T.Finalizada = 1;


    SELECT COUNT(*) INTO v_tareas_totales FROM Tarea t WHERE t.ID IN 
        (SELECT ts.ID FROM Proyecto p, TABLE(p.SeDivide) ts WHERE p.ID = id_proyecto);

    SELECT Fecha_Finalizacion_Real INTO v_fecha FROM Proyecto WHERE ID = id_proyecto;

    IF v_fecha IS NOT NULL THEN
        RETURN 'Proyecto finalizado ' || v_fecha;
    ELSE 
        SELECT Fecha_Finalizacion_Prevista INTO v_fecha FROM Proyecto WHERE ID = id_proyecto;
        RETURN 'Proyecto en curso, fecha prevista de finalizacion: '||  v_fecha ||' Tareas completadas: ' || v_tareas_completadas||  ' de '  ||v_tareas_totales;
    END IF;


END verEstadoProyecto;


    FUNCTION equipo(id_proyecto IN NUMBER)
    RETURN VARCHAR2
    IS
    v_nombre_equipo VARCHAR2(30);
    BEGIN
        SELECT p.Nombre
        INTO v_nombre_equipo
        FROM Equipo e
        JOIN Proyecto p ON e.ID = p.Equipo
        WHERE p.ID = id_proyecto;
        RETURN v_nombre_equipo;
    END;




    FUNCTION cliente(id_proyecto IN NUMBER)
    RETURN VARCHAR2
    IS
    v_nombre_cliente VARCHAR2(30);
    v_apellido_cliente VARCHAR2(30);
    v_dni_cliente VARCHAR2(30);
    BEGIN
        SELECT c.Nombre, c.Apellido, c.DNI
        INTO v_nombre_cliente, v_apellido_cliente, v_dni_cliente
        FROM Cliente c
        JOIN Proyecto p ON c.DNI = p.Cliente
        WHERE p.ID = id_proyecto;


        RETURN v_nombre_cliente || ' ' || v_apellido_cliente || ' ' || v_dni_cliente;


    END;

     PROCEDURE finalizarProyecto (id_proyecto IN NUMBER) IS --TRIGGER
BEGIN
    UPDATE Proyecto p
    SET p.Fecha_Finalizacion_Real = SYSDATE,
        p.Fecha_Finalizacion_Prevista = NULL
    WHERE p.ID = id_proyecto;
    UPDATE Empleado
SET Desarrolla = ListaProyectos((SELECT REF(P) FROM Proyecto P WHERE P.ID = id_proyecto))
WHERE ID IN (SELECT ID FROM Empleado WHERE ID IN (SELECT ID FROM TABLE(SELECT Equipo.TrabajaEn FROM Equipo WHERE ID = (SELECT Equipo FROM Proyecto WHERE ID = id_proyecto))));

END finalizarProyecto;



    PROCEDURE actualizarFechaPrevista(id_proyecto IN NUMBER, fecha_prevista IN DATE) IS
    BEGIN
        UPDATE Proyecto p
        SET Fecha_Finalizacion_Prevista = fecha_prevista
        WHERE p.ID = id_proyecto;
    END actualizarFechaPrevista;

   PROCEDURE cambiarEquipo(id_proyecto IN NUMBER, nuevo_equipo IN NUMBER) IS

        v_equipo_actual NUMBER;
        v_proyecto_ref REF Tipo_Proyecto;
        v_lista_proyectos ListaProyectos := ListaProyectos();
    BEGIN

        SELECT Equipo INTO v_equipo_actual FROM Proyecto WHERE ID = id_proyecto;

        IF v_equipo_actual != nuevo_equipo THEN
            SELECT REF(p) INTO v_proyecto_ref FROM Proyecto p WHERE p.ID = id_proyecto;
            FOR r IN (SELECT COLUMN_VALUE FROM TABLE((SELECT e.TrabajaEn FROM Equipo e WHERE v_proyecto_ref MEMBER OF e.TrabajaEn)))
            LOOP
                IF r.COLUMN_VALUE != v_proyecto_ref THEN
                    v_lista_proyectos.EXTEND;
                    v_lista_proyectos(v_lista_proyectos.COUNT) := r.COLUMN_VALUE;
                END IF;
            END LOOP;
            UPDATE Equipo e SET e.TrabajaEn = v_lista_proyectos WHERE v_proyecto_ref MEMBER OF e.TrabajaEn;
            UPDATE Proyecto SET Equipo = nuevo_equipo WHERE ID = id_proyecto;
        END IF;

    END cambiarEquipo;


 FUNCTION proyectoPorID(id_proyecto IN NUMBER) RETURN VARCHAR2 IS
    v_nombre_proyecto VARCHAR2(50);
    v_nombre_equipo VARCHAR2(50);
    BEGIN
        SELECT Nombre INTO v_nombre_proyecto FROM Proyecto WHERE ID = id_proyecto;
        SELECT Nombre INTO v_nombre_equipo FROM Equipo WHERE ID = (SELECT Equipo FROM Proyecto WHERE ID = id_proyecto);
        RETURN 'Nombre del proyecto: '||v_nombre_proyecto || ' Nombre del equipo que lo realiza ' || v_nombre_equipo;
    END proyectoPorID;



  PROCEDURE finalizarTareaProyecto(id_tarea IN NUMBER, id_proyecto IN NUMBER) IS
    v_tareas_totales NUMBER;
    v_tareas_completadas NUMBER;
  BEGIN

        UPDATE TABLE(SELECT p.SeDivide FROM Proyecto p WHERE p.ID = id_proyecto) T
        SET T.Finalizada = 1
        WHERE T.ID = id_tarea;

        SELECT COUNT(*) INTO v_tareas_totales FROM TABLE(SELECT p.SeDivide FROM Proyecto p WHERE p.ID = id_proyecto) T;
        SELECT COUNT(*) INTO v_tareas_completadas FROM TABLE(SELECT p.SeDivide FROM Proyecto p WHERE p.ID = id_proyecto) T
        WHERE T.Finalizada = 1;

        IF v_tareas_totales = v_tareas_completadas THEN
            UPDATE Proyecto p
            SET Fecha_Finalizacion_Real = SYSDATE
            WHERE p.ID = id_proyecto;
        END IF;

  END finalizarTareaProyecto;



  FUNCTION factura(id_proyecto IN NUMBER) RETURN VARCHAR2 IS
    v_factura VARCHAR2(100);
    v_proyecto VARCHAR2(100);
    v_cliente VARCHAR2(100);
    v_fecha DATE;
    v_monto NUMBER;

  BEGIN
    SELECT p.ID, p.Proyecto, p.Cliente, p.Monto INTO v_factura, v_proyecto, v_cliente, v_monto
    FROM Pago p
    
    WHERE p.Proyecto = id_proyecto;
    RETURN ' ID Factura: ' || v_factura || ' ID Proyecto: ' || v_proyecto || ' DNI  Cliente: ' || v_cliente || ' Monto: ' || v_monto;

  END factura;


END PACK_PROYECTO;
/

---------------------------------------EMPLEADO---------------------------------------------
create or replace PACKAGE PACK_EMPLEADO AS


 -- Función que devuelve el nombre  equipo al que pertenece un empleado
  FUNCTION equipo(id_empleado NUMBER) RETURN VARCHAR2;
   -- Función que devuelve los proyectos en los que participa un empleado activo
  FUNCTION proyectosDeEmpleadoActivo(id_empleado NUMBER) RETURN SYS_REFCURSOR;
   -- Función busca en ListaProyectos los proyectos finalizados en los que participa un empleado 
  FUNCTION proyectosDeEmpleadoFinalizados(id_empleado NUMBER) RETURN SYS_REFCURSOR;
   -- Función que devuelve el nombre,apelllido y telefono de empleado correspondiente a un ID dado
  FUNCTION empleadoPorID(id_empleado NUMBER) RETURN VARCHAR2;
   -- Procedimiento que cambia el equipo al que pertenece un empleado
  PROCEDURE cambiarEquipo(id_empleado NUMBER, nuevo_equipo NUMBER);
    -- Procedimiento que elimina un empleado de la base de datos
  PROCEDURE eliminarEmpleado(id_empleado NUMBER);

END PACK_EMPLEADO;
/

create or replace PACKAGE BODY PACK_EMPLEADO AS
    

  FUNCTION equipo(id_empleado NUMBER) RETURN VARCHAR2 IS
    v_nombre_equipo VARCHAR2(50);
  BEGIN
    SELECT e.Nombre
    INTO v_nombre_equipo
    FROM Equipo e
    JOIN Empleado em ON e.ID = em.Equipo
    WHERE em.ID = id_empleado;
    RETURN v_nombre_equipo;

  END;


  FUNCTION proyectosDeEmpleadoActivo(id_empleado NUMBER) RETURN SYS_REFCURSOR IS

      c_proyectos SYS_REFCURSOR;
  BEGIN
      OPEN c_proyectos FOR
          SELECT p.Nombre
          FROM Proyecto p
          JOIN Equipo e ON p.Equipo = e.ID
          JOIN Empleado em ON e.ID = em.Equipo
          WHERE em.ID = id_empleado AND p.Fecha_Finalizacion_Real IS NULL;
      RETURN c_proyectos;
  END;





  FUNCTION proyectosDeEmpleadoFinalizados(id_empleado NUMBER) RETURN SYS_REFCURSOR IS
      l_cursor SYS_REFCURSOR;
  BEGIN
      OPEN l_cursor FOR
          SELECT tp.Nombre
          FROM Empleado e,
              TABLE(e.Desarrolla) d,
              Proyecto tp
          WHERE e.ID = id_empleado AND
                d.COLUMN_VALUE = REF(tp);
      RETURN l_cursor;
  END;


  FUNCTION empleadoPorID(id_empleado NUMBER) RETURN VARCHAR2 IS
    v_nombre Empleado.Nombre%TYPE;
    v_apellido Empleado.Apellido%TYPE;
    v_telefono Empleado.Telefono%TYPE;
  BEGIN
    SELECT Nombre, Apellido, Telefono INTO v_nombre, v_apellido, v_telefono FROM Empleado WHERE ID = id_empleado;
    RETURN v_nombre || ' ' || v_apellido || ' ' || v_telefono;

  END empleadoPorID;

 PROCEDURE cambiarEquipo(id_empleado NUMBER, nuevo_equipo NUMBER) IS -- +TRG_MOD_LISTA_EMPLEADOS

    employee_ref REF Tipo_Empleado;
    new_list ListaEmpleados := ListaEmpleados();
    v_equipo_actual NUMBER;
  BEGIN
    SELECT Equipo INTO v_equipo_actual FROM Empleado WHERE ID = id_empleado;

    IF v_equipo_actual != nuevo_equipo THEN
        SELECT REF(e) INTO employee_ref FROM empleado e WHERE e.ID = id_empleado;
        FOR r IN (SELECT COLUMN_VALUE FROM TABLE(SELECT e.EstaFormado FROM Equipo e WHERE employee_ref MEMBER OF e.EstaFormado))
        LOOP
            IF r.COLUMN_VALUE != employee_ref THEN
                new_list.EXTEND;
                new_list(new_list.COUNT) := r.COLUMN_VALUE;
            END IF;
        END LOOP;
        UPDATE Equipo e SET e.EstaFormado = new_list WHERE employee_ref MEMBER OF e.EstaFormado;
        UPDATE Empleado SET Equipo = nuevo_equipo WHERE ID = id_empleado;
    END IF;
  END cambiarEquipo;


  PROCEDURE eliminarEmpleado(id_empleado NUMBER) IS  --+TRG_ELIMINAR_EMPLEADO
  BEGIN
    DELETE FROM TABLE(SELECT e.EstaFormado FROM Equipo e 
        WHERE e.ID = (SELECT Equipo FROM Empleado WHERE ID = id_empleado)) 
      WHERE COLUMN_VALUE = (SELECT REF(e) FROM Empleado e WHERE e.ID = id_empleado);

    DELETE FROM Empleado WHERE ID = id_empleado;

  END eliminarEmpleado;

END PACK_EMPLEADO;
/


---------------------------------------CLIENTE---------------------------------------------
create or replace PACKAGE PACK_CLIENTE AS
  -- Función que devuelve el nombre apellido y numero de telefono de un cliente dado su DNI
 
  FUNCTION clientePorID(dni_cliente VARCHAR2) RETURN VARCHAR2;

  -- Procedimiento que muestra los proyectos de un cliente
  FUNCTION proyectos(dni_cliente VARCHAR2) RETURN SYS_REFCURSOR;
END PACK_CLIENTE;
/

create or replace PACKAGE BODY PACK_CLIENTE AS
   
  FUNCTION clientePorID(dni_cliente VARCHAR2) RETURN VARCHAR2 IS
    v_nombre VARCHAR2(50);
    v_apellido VARCHAR2(50);
    v_telefono VARCHAR2(50);
  BEGIN
    SELECT Nombre, Apellido, Telefono INTO v_nombre, v_apellido, v_telefono FROM Cliente WHERE DNI = dni_cliente;
    RETURN v_nombre || ' ' || v_apellido || ' ' || v_telefono;

  END clientePorID;

  FUNCTION proyectos(dni_cliente VARCHAR2) RETURN SYS_REFCURSOR IS
  v_proyectos SYS_REFCURSOR;
  BEGIN
    OPEN v_proyectos FOR
      SELECT Nombre FROM Proyecto WHERE Cliente = dni_cliente;

    RETURN v_proyectos;
  END proyectos;

END PACK_CLIENTE;
/

---------------------------------------EQUIPO---------------------------------------------
create or replace PACKAGE PACK_EQUIPO AS
    -- Función que devuelve los empleados que pertenecen a un equipo
    FUNCTION componentesEquipo(id_equipo NUMBER) RETURN SYS_REFCURSOR;
    -- Función que devuelve los proyectos en los que participa un equipo
    FUNCTION proyectosDeEquipoActivos(id_equipo NUMBER) RETURN SYS_REFCURSOR;
    -- Función que devuelve los proyectos en los que participó un equipo y ya finalizaron
    FUNCTION proyectosDeEquipoFinalizados(id_equipo NUMBER) RETURN SYS_REFCURSOR;
  -- Función que devuelveel nombre del equipo dado un ID 
  FUNCTION equipoPorID(id_equipo NUMBER) RETURN VARCHAR2;
  -- Procedimiento que elimina un equipo de la base de datos
  PROCEDURE eliminarEquipo(id_equipo NUMBER);
    -- Procedimiento que elimina un empleado de un equipo
  PROCEDURE eliminarEmpleadoDeEquipo(id_equipo NUMBER,id_empleado NUMBER);
END PACK_EQUIPO;
/

create or replace PACKAGE BODY PACK_EQUIPO AS

    FUNCTION componentesEquipo(id_equipo NUMBER) RETURN SYS_REFCURSOR IS
      l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
            SELECT e.ID, e.Nombre, e.Apellido
            FROM Empleado e
            WHERE e.Equipo = id_equipo;
        RETURN l_cursor;
    END;




    FUNCTION proyectosDeEquipoActivos(id_equipo NUMBER) RETURN SYS_REFCURSOR IS
      c_proyectos SYS_REFCURSOR;
    BEGIN
        OPEN c_proyectos FOR
            SELECT p.Nombre
            FROM Proyecto p
            JOIN Equipo e ON p.Equipo = e.ID
            WHERE e.ID = id_equipo AND p.Fecha_Finalizacion_Real IS NULL;
        RETURN c_proyectos;
    END;

    FUNCTION proyectosDeEquipoFinalizados(id_equipo NUMBER) RETURN SYS_REFCURSOR IS
      c_proyectos SYS_REFCURSOR;
    BEGIN
        OPEN c_proyectos FOR
            SELECT p.Nombre
            FROM Proyecto p
            JOIN Equipo e ON p.Equipo = e.ID
            WHERE e.ID = id_equipo AND p.Fecha_Finalizacion_Real IS NOT NULL;
        RETURN c_proyectos;
    END;

  FUNCTION equipoPorID(id_equipo NUMBER) RETURN VARCHAR2 IS
    v_nombre VARCHAR2(50);
  BEGIN
    SELECT Nombre INTO v_nombre FROM Equipo WHERE ID = id_equipo;
    RETURN v_nombre;

  END equipoPorID;

  PROCEDURE eliminarEquipo(id_equipo NUMBER) IS
  BEGIN
    DELETE FROM Equipo WHERE ID = id_equipo;
  END eliminarEquipo;

    PROCEDURE eliminarEmpleadoDeEquipo(id_equipo NUMBER,id_empleado NUMBER) IS
    BEGIN
      DELETE FROM TABLE(
        SELECT TrabajaEn FROM Equipo WHERE ID = id_equipo) t
      WHERE t.COLUMN_VALUE.ID = id_empleado;

      UPDATE Empleado SET Equipo = NULL WHERE ID = id_empleado;
    END eliminarEmpleadoDeEquipo;
END PACK_EQUIPO;
/


				






    