-- Programación Concurrente ATIC/Redictado Programación Concurrente - Primera fecha de MD - 10/06/2026 - Tema 1

-- 2) Resolver con ADA el siguiente problema. Existe un servidor que resuelve pedidos de análisis de similitud de secuencias de
-- ADN de C clientes diferentes. Cada cliente realiza sucesivos pedidos enviando 2 strings con las secuencias a analizar y esperando
-- el resultado, los pedidos pueden ser URGENTES o REGULARES (hasta no recibir el resultado de un pedido no hace uno nuevo);
-- en el caso de los pedidos REGULARES, si pasan 30 minutos y no han sido atendidos el cliente lo descarta y genera un nuevo
-- pedido. El servidor atiende los pedidos de acuerdo con el orden de llegada, pero dando prioridad a los URGENTES, devolviendo
-- el resultado al cliente correspondiente (un número que indica el grado de similitud de las 2 secuencias); cuando no hay pedidos
-- para resolver el servidor se duerme por 5 minutos. Nota: suponga que existe una función Analizar(sec1, sec2) que retorna un
-- entero con el resultado del análisis; el cliente determina la prioridad de cada pedido.

procedure Parcial01 is

task type cliente;

task servidor is
   entry pedidoUrgente(secuencia1: in String; secuencia2: in String; resultado : out Integer);
   entry pedidoRegular(secuencia1: in String; secuencia2: in String; resultado : out Integer);
end servidor;

task body cliente is
   secuencia1 : String;
   secuencia2 : String;
   resultado : Integer
   prioridad : String;
begin
   loop
      prioridad := generarPedido()
      if prioridad == "URGENTE" then
         servidor.pedidoUrgente(secuencia1, secuencia2, resultado);
      else
         select
            servidor.pedidoRegular(secuencia1, secuencia2, resultado);
         or delay 1800.0
            -- reintentar
         end select;
      end if;
   end loop;
end cliente;

task body servidor is
begin
   loop
      select
         accept pedidoUrgente(secuencia1: in String; secuencia2: in String; resultado : out Integer) do
            resultado := analizar(secuencia1, secuencia2);
         end pedidoUrgente;
      or when pedidoUrgente'Count = 0 ->
         accept pedidoRegular(secuencia1: in String; secuencia2: in String; resultado : out Integer) do
            resultado := analizar(secuencia1, secuencia2);
         end pedidoRegular;
      or when pedidoUrgente'Count = 0 and pedidoRegular'Count = 0 ->
         delay 300.0
      end select;
   end loop;
end servidor;

begin
   null;
end Parcial01;