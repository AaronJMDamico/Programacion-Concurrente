-- Programación Concurrente - 10/11/25 - Tema 1

-- 3) Implemente una solución para el siguiente problema usando ADA. En la farmacia de un hospital hay una
-- única ventanilla para dispensar medicamentos. Los pacientes internados deben retirar sus medicamentos
-- presentando una receta (un único retiro por persona). Los pacientes son atendidos en el orden de llegada,
-- pero con prioridad de atención: los pacientes de urgencia tienen prioridad sobre los de internación general,
-- y ambos tienen prioridad sobre los pacientes ambulatorios. Cada paciente entrega su receta y recibe la
-- medicación correspondiente. Notas: la función obtenerPrioridad() le permite al paciente conocer su
-- prioridad (retorna 0 si el paciente es de urgencia, 1 si es internado general, o 2 si es ambulatorio). La función
-- obtenerReceta() retorna la receta para el paciente que la invoca mientras que
-- dispensarMedicamento(receta) le retorna al empleado el medicamento para la receta indicada. El empleado
-- atiende de a un paciente por vez, según la prioridad indicada. Todas las tareas deben finalizar.

procedure Parcial02 is

   task type paciente;

   task empleado is
      entry pedidoMedicamento(receta: in String; medicamento: out String);
      entry pedidoInternacion(receta: in String; medicamento: out String)
      entry pedidoAmbulatorio(receta: in String; medicamento: out String)
   end empleado

   arrPacientes : array (1..P) of paciente;

   task body paciente is
      receta : String;
      prioridad : Integer;
      medicamento : String;
   begin
      receta := obtenerReceta();
      prioridad := obtenerPrioridad();
      if prioridad == 0 then
         empleado.pedidoUrgencia(receta, medicamento);
      elsif prioridad == 1 then
         empleado.pedidoInternacion(receta, medicamento);
      else 
         empleado.pedidoAmbulatorio(receta, medicamento);
      end if;
   end paciente;

   task body empleado is
   begin
      loop
         select
            accept pedidoUrgencia(receta: in String; medicamento: out String) do
               medicamento := dispensarMedicamento(receta);
            end pedidoUrgencia
         or when pedidoUrgencia'Count = 0 ->
            accept pedidoInternacion(receta: in String; medicamento: out String) do
               medicamento := dispensarMedicamento(receta);
            end pedidoInternacion
         or when pedidoUrgencia'Count = 0 and pedidoInternacion'Count = 0 ->
            accept pedidoAmbulatorio(receta: in String; medicamento: out String) do
               medicamento := dispensarMedicamento(receta);
            end pedidoAmbulatorio
         end select;
      end loop;
   end empleado;

begin
   null;
end;