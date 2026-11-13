-- 3) Se dispone de un sistema compuesto por 1 central y 2 procesos periféricos, que se
-- comunican continuamente. Se requiere modelar su funcionamiento considerando las
-- siguientes condiciones:

-- La central siempre comienza su ejecución tomando una señal del proceso periférico 1; luego
-- toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una
-- señal de proceso periférico 2, recibe señales del mismo proceso durante 3 minutos.

-- Los procesos periféricos envían señales continuamente a la central. La señal del
-- proceso 1 será considerada vieja (se deshecha) si en 2 minutos no fue recibida. Si la
-- señal del proceso 2 no puede ser recibida inmediatamente, entonces espera 1 minuto y
-- vuelve a mandarla (no se deshecha).

procedure Ejercicio03 is

   task Central is
      entry Pedido1(Señal: in Integer);
      entry Pedido2(Señal: in Integer);
      entry Terminar;
   end Central;

   task Periferico1;
   task Periferico2;

   task Timer is
       entry Demorar;
   end Timer;

   task body Central is
      SeñalAct: Integer;
      Demorado: Boolean := False;
   begin
      -- La central comienza esperando al periférico 1.
      accept Pedido1 (Señal: in Integer) do
         SeñalAct := Señal;
      end Pedido1;
      loop
         if not Demorado then
            select
               accept Pedido1 (Señal: in Integer) do
                  SeñalAct := Señal;
               end Pedido1;
            or
               accept Pedido2 (Señal: in Integer) do
                  SeñalAct := Señal;
               end Pedido2;
               -- Comienza el período especial.
               Demorado := True;
               Timer.Demorar;
            end select;
         else
            -- Durante 3 minutos, atender exclusivamente al periférico 2
            -- o la señal de finalización del temporizador
            select
               accept Terminar do
                  Demorado := False;
               end Terminar;
            or
               accept Pedido2 (Señal : in Integer) do
                  SeñalAct := Señal;
               end Pedido2;
            end select;
         end if;
      end loop;
   end Central;

   task body Periferico1;
   begin
      loop
         select
            Central.Pedido1(1);
         or delay 120.0
            null
         end select;
      end loop;
   end Periferico1;

   task body Periferico2 is
   begin
      loop
         select
            Central.Pedido(2);
         else
            delay 60.0
         end select;
      end loop;
   end Periferico2;

   task body Timer is
   begin
      loop
         accept Demorar;
         delay 180.0;
         Central.Terminar;
      end loop;
   end Timer;

begin
   null;
end Ejercicio03;