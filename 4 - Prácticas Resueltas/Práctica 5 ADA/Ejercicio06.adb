-- 6) En una playa hay 5 equipos de 4 personas cada uno (en total son 20 personas donde cada
-- una conoce previamente a que equipo pertenece). Cuando las personas van llegando
-- esperan con los de su equipo hasta que el mismo esté completo (hayan llegado los 4
-- integrantes), a partir de ese momento el equipo comienza a jugar. El juego consiste en que
-- cada integrante del grupo junta 15 monedas de a una en una playa (las monedas pueden ser
-- de 1, 2 o 5 pesos) y se suman los montos de las 60 monedas conseguidas en el grupo. Al
-- finalizar cada persona debe conocer el grupo que más dinero junto. Nota: maximizar la
-- concurrencia. Suponga que para simular la búsqueda de una moneda por parte de una
-- persona existe una función Moneda() que retorna el valor de la moneda encontrada.

procedure Ejercicio06  is

   task type persona is
      entry identificar(idPersona: in Integer; idEquipo: in Integer);
      entry conocerGanador(idGanador: in Integer);
   end persona;

   task type equipo is
      entry identificar(idEquipo: in Integer);
      entry llegada();
      entry empezar();
      entry depositar(monedas: in Integer);
   end equipo;

   task admin is
      entry entregarTotal()
   end admin;

   arrPersonas: array (1..20) of persona;
   arrEquipos: array (1..5) of equipo;

   task body persona is
      idP : Integer;
      idE : Integer;
      idG : Integer;
      cantMonedas : Integer = 0;
   begin
      accept identificar(idPersona: in Integer; idEquipo: in Integer) do
         idP := idPersona;
         idE := idEquipo;
      end identificar
      
      arrEquipos(idE).llegada();
      arrEquipos(idE).empezar();
      
      while cantMonedas < 15 loop
         cantMonedas := cantMonedas + moneda();
      end loop;

      arrEquipos(idE).depositar(cantMonedas);

      accept conocerGanador(idGanador: in Integer) do
         idG := idGanador
      end infoGanador;
   end persona;

   task body equipo is
      idE : Integer;
      idG : Integer;
      cantMonedas : Integer = 0;
   begin
      accept identificar(idEquipo: in Integer) do
         idE: idEquipo;
      end identificar;

      for 1 to 4 loop
         accept llegada() do
            -- llega una persona
         end llegada;
      end loop;

      for 1 to 4 loop
         accept empezar() do
            -- comienza una persona
         end empezar;
      end loop;

      for 1 to 4 loop
         accept depositar(monedas: in Integer) do
            cantMonedas := cantMonedas + monedas;
         end depositar;
      end loop;

      admin.entregarTotal(idE, cantMonedas);
   end equipo;

   task body admin is
      maxMonedas : Integer = 0;
      idG: Integer;
   begin
      for 1 to 5 loop
         accept entregarTotal(idEquipo: in Integer; cantMonedas: in Integer) do
            if cantMonedas > maxMonedas then
               maxMonedas := cantMonedas;
               idG := idEquipo;
            end if;
         end entregarTotal;
      end loop;

      for i : int = 1 to 20 loop
         arrPersonas(i).conocerGanador(idG);
      end loop;
   end admin;

   idEquipo : Integer;
begin
   for i : Integer = 1 to 5 loop
      arrEquipos(i).identificar(i);   
   end loop;
   for i : Integer = 1 to 20 loop
      if i mod 5 == 0 then
         idEquipo++
      end if;
      arrPersonas(i).identificar(i, idEquipo);
   end loop;
end Ejercicio06;