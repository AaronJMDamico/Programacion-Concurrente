-- 3) Resolver el siguiente problema. La oficina central de una empresa de venta de indumentaria debe
-- calcular cuántas veces fue vendido cada uno de los artículos de su catálogo. La empresa se compone
-- de 100 sucursales y cada una de ellas maneja su propia base de datos de ventas. La oficina central
-- cuenta con una herramienta que funciona de la siguiente manera: ante la consulta realizada para un
-- artículo determinado, la herramienta envía el identificador del artículo a las sucursales, para que cada
-- una calcule cuántas veces fue vendido en ella. Al final del procesamiento, la herramienta debe
-- conocer cuántas veces fue vendido en total, considerando todas las sucursales. Cuando ha terminado
-- de procesar un artículo comienza con el siguiente (suponga que la herramienta tiene una función
-- generarArtículo() que retorna el siguiente ID a consultar). Nota: maximizar la concurrencia. Existe
-- una función ObtenerVentas(ID) que retorna la cantidad de veces que fue vendido el artículo con
-- identificador ID en la base de la sucursal que la llama.

procedure Ejercicio03 is

task type sucursal;

task central is
   entry solicitarArticulo(id: out Integer);
   entry recibirResultado(ventas: in Integer);
end central;

arrSucursales : array (1..100) of sucursal;

task body sucursal is
   idAux : Integer;
   ventas : Integer;
begin
   loop
      central.solicitarArticulo(idAux);
      ventas := obtenerVentas(idAux);
      central.recibirResultado(ventas);
   end loop;
end sucursal;

task body central is
   idAux : Integer;
   ventas : Integer;
   total : Integer;
begin
   loop
      idAux := generarArtículo();
      total := 0;
      for i in 1..100 loop
         accept solicitarArticulo(id: out Integer) do
            id := idAux;
         end solicitarArticulo;
      end loop;
      for i in 1..100 loop
         accept recibirResultado(ventas: in Integer) do
               total := total + ventas;
         end recibirResultado;
      end loop;
      -- informo la cantidad total y sigo con el siguiente
   end loop;
end central;

begin
   null;
end Ejercicio03;