-- 7) Se debe calcular el valor promedio de un vector de 1 millón de números enteros que se
-- encuentra distribuido entre 10 procesos Worker (es decir, cada Worker tiene un vector de
-- 100 mil números). Para ello, existe un Coordinador que determina el momento en que se
-- debe realizar el cálculo de este promedio y que, además, se queda con el resultado. Nota:
-- maximizar la concurrencia; este cálculo se hace una sola vez.

procedure Ejercicio07 is

   task type worker is
      entry empezar();
   end worker;

   task coordinador is
      entry termine(total: in Integer);
   end coordinador;

   arrWorkers : array (1..10) of worker;

   task body worker is
      arrDividido : array (1..100000) of Integer; -- Asumo que ya tiene está parte del vector
   begin
      accept empezar() do
         -- Empiezar a laburar
      end empezar;

      for i : Integer = 1 to 4 loop
         total := total + arrDividido(i);
      end loop;

      coordinador.termine(total);
   end worker;

   task body coordinador is
      resultado : Integer = 0;
   begin
      for i : Integer = 1 to 10 loop
         arrWorkers(i).empezar()
      end loop;

      for 1 to 10 loop
         accept termine(total: in Integer) do
            resultado := resultado + total;
         end termine;
      end loop

      resultado := resultado / 1000000;
   end coordinador;
   
begin
   null;
end Ejercicio07;