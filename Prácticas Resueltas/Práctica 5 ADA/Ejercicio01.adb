-- 1) Se requiere modelar un puente de un único sentido que soporta hasta 5 unidades de peso.
-- El peso de los vehículos depende del tipo: cada auto pesa 1 unidad, cada camioneta pesa 2
-- unidades y cada camión 3 unidades. Suponga que hay una cantidad innumerable de
-- vehículos (A autos, B camionetas y C camiones). Analice el problema y defina qué tareas,
-- recursos y sincronizaciones serán necesarios/convenientes para resolverlo.

-- a) Realice la solución suponiendo que todos los vehículos tienen la misma prioridad.

procedure ejercicio01A is
    Task type auto;
    Task type camioneta;
    Task type camion;

    Task Puente is
        entry pedidoAuto;
        entry pedidoCamioneta;
        entry pedidoCamion;
        entry salidas(peso: in int);
    end Puente;

    Task body auto is begin
        Puente.pedidoAuto();
        //Pasa por el puente;
        Puente.salidas(1);
    end auto;

    Task body camioneta is begin
        Puente.pedidoCamioneta();
        //Pasa por el puente;
        Puente.salidas(2);
    end camioneta;

    Task body camion is begin
        Puente.pedidoCamion();
        //Pasa por el puente;
        Puente.salidas(3);
    end camion;

    arrAutos: array (1..A) of auto;
    arrCamionetas: array (1..B) of camioneta;
    arrCamiones: array (1..C) of camion;

    Task body Puente is
        pesoRestante: integer;
        aux: integer;
    begin
        pesoRestante := 5;
        loop
            SELECT
                when(pesoRestante - 1 >= 0) =>
                    accept pedidoAuto do
                        pesoRestante := pesoRestante - 1;
                    end pedidoAuto;
                OR
                when(pesoRestante - 2 >= 0) =>
                    accept pedidoCamioneta do
                        pesoRestante := pesoRestante - 2;
                    end pedidoCamioneta;
                OR
                when(pesoRestante - 3 >= 0) =>
                    accept pedidoCamion do
                        pesoRestante := pesoRestante - 3;
                    end pedidoCamion;
                OR
                    accept salidas(aux: in integer) do
                        pesoRestante := pesoRestante + aux;
                    end salidas;
            end SELECT;
        end loop;
    end Puente;

begin
    null;
end Puente;

-- b) Modifique la solución para que tengan mayor prioridad los camiones que el resto de los vehículos.

procedure Ejercicio01B is

    task type Auto;
    task type Camioneta;
    task type Camion;

    task Puente is
        entry PedidoAuto;
        entry PedidoCamioneta;
        entry PedidoCamion;
        entry Salidas(peso: in integer);
    end Puente;

    arrAutos: array (1..A) of Auto;
    arrCamionetas: array (1..B) of Camioneta;
    arrCamiones: array (1..C) of Camion;

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
        pesoRestante: integer := 5;
    begin
        loop
            select
                when (pedidoCamion'count = 0 and pesoRestante >= 1) =>
                    accept PedidoAuto do
                        pesoRestante := pesoRestante - 1;
                    end PedidoAuto;
            or
                when (pedidoCamion'count = 0 and pesoRestante >= 2) =>
                    accept PedidoCamioneta do
                        pesoRestante := pesoRestante - 2;
                    end PedidoCamioneta;
            or
                when (pesoRestante >= 3) =>
                    accept PedidoCamion do
                        pesoRestante := pesoRestante - 3;
                    end PedidoCamion;
            or
                accept Salidas(peso: in integer) do
                    pesoRestante := pesoRestante + peso;
                end Salidas;
            end select;
        end loop;
    end Puente;

begin
    null;
end Puente;