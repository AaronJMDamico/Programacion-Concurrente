-- 1) Se requiere modelar un puente de un único sentido que soporta hasta 5 unidades de peso.
-- El peso de los vehículos depende del tipo: cada auto pesa 1 unidad, cada camioneta pesa 2
-- unidades y cada camión 3 unidades. Suponga que hay una cantidad innumerable de
-- vehículos (A autos, B camionetas y C camiones). Analice el problema y defina qué tareas,
-- recursos y sincronizaciones serán necesarios/convenientes para resolverlo.

-- a) Realice la solución suponiendo que todos los vehículos tienen la misma prioridad.

procedure Ejercicio01A is

    A : constant Integer := 10;
    B : constant Integer := 5;
    C : constant Integer := 3;

    task type Auto;
    task type Camioneta;
    task type Camion;

    task Puente is
        entry PedidoAuto;
        entry PedidoCamioneta;
        entry PedidoCamion;
        entry Salidas(Peso : in Integer);
    end Puente;

    ArrAutos      : array (1 .. A) of Auto;
    ArrCamionetas : array (1 .. B) of Camioneta;
    ArrCamiones   : array (1 .. C) of Camion;

    task body Auto is
    begin
        Puente.PedidoAuto;
        -- Cruza el puente
        Puente.Salidas(1);
    end Auto;

    task body Camioneta is
    begin
        Puente.PedidoCamioneta;
        -- Cruza el puente
        Puente.Salidas(2);
    end Camioneta;

    task body Camion is
    begin
        Puente.PedidoCamion;
        -- Cruza el puente
        Puente.Salidas(3);
    end Camion;

    task body Puente is
        PesoRestante : Integer := 5;
        VehiculosRestantes : Integer := A + B + C;
    begin
        while VehiculosRestantes > 0 loop
            select
                when PesoRestante >= 1 =>
                    accept PedidoAuto do
                        PesoRestante := PesoRestante - 1;
                    end PedidoAuto;
            or
                when PesoRestante >= 2 =>
                    accept PedidoCamioneta do
                        PesoRestante := PesoRestante - 2;
                    end PedidoCamioneta;
            or
                when PesoRestante >= 3 =>
                    accept PedidoCamion do
                        PesoRestante := PesoRestante - 3;
                    end PedidoCamion;
            or
                accept Salidas(Peso : in Integer) do
                    PesoRestante := PesoRestante + Peso;
                    VehiculosRestantes := VehiculosRestantes - 1;
                end Salidas;
            end select;
        end loop;
    end Puente;

begin
    null;
end Ejercicio01A;

-- b) Modifique la solución para que tengan mayor prioridad los camiones que el resto de los vehículos.

procedure Ejercicio01B is

    A : constant Integer := 10;
    B : constant Integer := 5;
    C : constant Integer := 3;

    task type Auto;
    task type Camioneta;
    task type Camion;

    task Puente is
        entry PedidoAuto;
        entry PedidoCamioneta;
        entry PedidoCamion;
        entry Salidas(Peso : in Integer);
    end Puente;

    ArrAutos      : array (1 .. A) of Auto;
    ArrCamionetas : array (1 .. B) of Camioneta;
    ArrCamiones   : array (1 .. C) of Camion;

    task body Auto is
    begin
        Puente.PedidoAuto;
        -- Cruza el puente
        Puente.Salidas(1);
    end Auto;

    task body Camioneta is
    begin
        Puente.PedidoCamioneta;
        -- Cruza el puente
        Puente.Salidas(2);
    end Camioneta;

    task body Camion is
    begin
        Puente.PedidoCamion;
        -- Cruza el puente
        Puente.Salidas(3);
    end Camion;

    task body Puente is
        PesoRestante : Integer := 5;
        VehiculosRestantes : Integer := A + B + C;
    begin
        while VehiculosRestantes > 0 loop
            select
                when PedidoCamion'Count = 0 and PesoRestante >= 1 =>
                    accept PedidoAuto do
                        PesoRestante := PesoRestante - 1;
                    end PedidoAuto;
            or
                when PedidoCamion'Count = 0 and PesoRestante >= 2 =>
                    accept PedidoCamioneta do
                        PesoRestante := PesoRestante - 2;
                    end PedidoCamioneta;
            or
                when PesoRestante >= 3 =>
                    accept PedidoCamion do
                        PesoRestante := PesoRestante - 3;
                    end PedidoCamion;
            or
                accept Salidas(Peso : in Integer) do
                    PesoRestante := PesoRestante + Peso;
                    VehiculosRestantes := VehiculosRestantes - 1;
                end Salidas;
            end select;
        end loop;
    end Puente;

begin
    null;
end Ejercicio01B;