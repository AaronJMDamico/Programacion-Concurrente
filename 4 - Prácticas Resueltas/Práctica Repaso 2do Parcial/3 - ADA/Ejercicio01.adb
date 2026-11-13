-- 1) Resolver el siguiente problema. La página web del Banco Central exhibe las diferentes cotizaciones
-- del dólar oficial de 20 bancos del país, tanto para la compra como para la venta. Existe una tarea
-- programada que se ocupa de actualizar la página en forma periódica y para ello consulta la cotización
-- de cada uno de los 20 bancos. Cada banco dispone de una API, cuya única función es procesar las
-- solicitudes de aplicaciones externas. La tarea programada consulta de a una API por vez, esperando
-- a lo sumo 5 segundos por su respuesta. Si pasado ese tiempo no respondió, entonces se mostrará
-- vacía la información de ese banco.

procedure Ejercicio01 is

   task central;

   task type banco is
      entry consulta();
   end banco

   arrBancos : array (1..20) of banco;

   task body central is
   begin
      loop
         for i in 1..20 loop
            select
               arrBancos(i).consulta();
            or delay 5.0;
               -- sin información
            end select;
         end loop;
      end loop;
   end central;

   task body banco is
   begin
      loop
         accept consulta do
            -- aceptar la solicitud del banco central
         end consulta;
      end loop;
   end banco;

begin
   null;
end Ejercicio01;