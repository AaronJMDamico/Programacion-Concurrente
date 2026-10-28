-- 4) En una clínica existe un médico de guardia que recibe continuamente peticiones de
-- atención de las E enfermeras que trabajan en su piso y de las P personas que llegan a la
-- clínica ser atendidos.

-- Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el médico lo
-- haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atención del
-- médico. Si no es atendida tres veces, se enoja y se retira de la clínica.

-- Cuando una enfermera requiere la atención del médico, si este no lo atiende inmediatamente
-- le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el
-- momento que pueda (el pedido puede ser que el médico le firme algún papel). Cuando la
-- petición ha sido recibida por el médico o la nota ha sido dejada en el escritorio, continúa
-- trabajando y haciendo más peticiones.

-- El médico atiende los pedidos dándole prioridad a los enfermos que llegan para ser atendidos.
-- Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto tiempo. Cuando
-- está libre aprovecha a procesar las notas dejadas por las enfermeras.

procedure Ejercicio04 is

   E: constant Integer := 15;
   P: constant Integer := 50;

   task Medico is
      entry pedidoPersona(Solicitud: in text);
      entry pedidoEnfermera(Nota: in text);
      entry pedidoNota(Nota: in text);
   end Medico;

   task Escritorio is
      entry dejarNota(Nota: in text);
      entry sacarNota(Nota: out text);
   end Escritorio;

   task Admin;
   task type Enfermera;
   task type Persona;

   arrEnfermeras: array(1..E) of Enfermera;
   arrPersonas: array(1..P) of Persona;

   task body Medico is
   begin
      loop
         select
            accept pedidoPersona(Solicitud: in text) do
               -- Atiende a la persona
            end pedidoPersona;
         or when pedidoPersona'Count = 0 =>
            accept pedidoEnfermera(Nota: in text) do
               -- Atiende a la enfermera
            end pedidoEnfermera;
         or when pedidoPersona'Count = 0 =>
            accept pedidoNota(Nota: in text) do
               -- Procesa una nota
            end pedidoNota;
         end select;
      end loop;
   end Medico;

   task body Escritorio is
      colaNotas: queue;
   begin
      loop
         select
            accept dejarNota(Nota: in text) do
               push(colaNotas, Nota);
            end dejarNota;
         or when not empty(colaNotas) =>
            accept sacarNota(Nota: out text) do
               pop(colaNotas, Nota);
            end sacarNota;
         end select;
      end loop;
   end Escritorio;

   task body Admin is
      Nota: text;
   begin
      loop
         Escritorio.sacarNota(Nota);
         Medico.pedidoNota(Nota);
      end loop;
   end Admin;

   task body Enfermera is
      Nota: text;
   begin
      loop
         select
            Medico.pedidoEnfermera(Nota);
         else
            Escritorio.dejarNota(Nota);
         end select;
      end loop;
   end Enfermera;

   task body Persona is
      Solicitud: text;
      intentos: Integer := 0;
      Atendido: Boolean := False;
   begin
      while intentos < 3 and not atendido loop
         select
            Medico.pedidoPersona(Solicitud);
            atendido := true;
         or delay 300.0;
            intentos := intentos + 1;
            if Intentos < 3 then
               delay 600.0;
            end if;
         end select;
      end loop;
   end Persona;

begin
   null;
end Ejercicio04;

-- Nota: La task admin actúa como tope de la pila de notas del escritorio. Lo hice de está forma
-- ya que si hago que el médico reciba del escritorio puede haber busy waiting si no hay notas, 
-- por lo que se quedaría esperando a que el escritorio reciba una nota y se la entregue al
-- médico. Admin, al contrario, siempre tiene una nota lista.