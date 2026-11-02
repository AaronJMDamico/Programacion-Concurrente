-- 5) En un sistema para acreditar carreras universitarias, hay UN Servidor que atiende pedidos
-- de U Usuarios de a uno a la vez y de acuerdo con el orden en que se hacen los pedidos.
-- Cada usuario trabaja en el documento a presentar, y luego lo envía al servidor; espera la
-- respuesta de este que le indica si está todo bien o hay algún error. Mientras haya algún error,
-- vuelve a trabajar con el documento y a enviarlo al servidor. Cuando el servidor le responde
-- que está todo bien, el usuario se retira. Cuando un usuario envía un pedido espera a lo sumo
-- 2 minutos a que sea recibido por el servidor, pasado ese tiempo espera un minuto y vuelve a
-- intentarlo (usando el mismo documento).

procedure Ejercicio05 is

   task servidor is
      Entry pedido(documento: in text; res: out boolean);
   end servidor;

   task type usuario;

   arrUsuarios: array (1..N) of usuario;

   task body servidor is
      Documento: text;
   begin
      loop
         accept pedido(documento: in text; res: out boolean) do
            res:= revisarDocumento(documento);
         end pedido;
      end loop;
   end servidor;

   task body usuario is
      Documento: text;
      Aprobado: boolean = false;
   begin
      Trabajar(documento);
      while not aprobado loop
         servidor.pedido(documento);
         select
            accept pedido(documento: in text; res: out boolean) do
               if not aprobado then
                  corregirDocumento(documento);
               end if;
            end pedido;
         or delay 120.0;
            delay 60.0;
         end select;
      end loop;
   end usuario

begin
   null;
end Ejercicio05;

-- Nota: el ejercicio lo resolvi sin priorizar si el pedido es corregir o aprobar un documento. Si 
-- se quiere priorizar el corregir antes que aprobar uno nuevo hay que agregar otro entry call.

   task servidor is
      Entry pedido(documento: in text; res: out boolean);
      Entry corregir(documento: in text; res: out boolean); -- Nuevo entry para corregir un documento
   end servidor;

   task body servidor is
      Documento: text;
   begin
      loop
         select 
            accept corregir(documento: in text; res: out boolean) do
               res:= corregirDocumento(documento);
            end corregir;
         or when corregir'Count = 0 =>
            accept pedido(documento: in text; res: out boolean) do
               res:= revisarDocumento(documento);
            end pedido;
         end select;
      end loop;
   end servidor;

   task body usuario is
      Documento: text;
      Aprobado: boolean = false;
   begin
      Trabajar(documento);
      servidor.pedido(documento);
      accept pedido(documento: in text; res: out boolean) do
         if not aprobado then
            corregirDocumento(documento);
         end if;
      end pedido;
      while not aprobado loop
         servidor.corregir(documento);
         select
            accept pedido(documento: in text; res: out boolean) do
               if not aprobado then
                  corregirDocumento(documento);
               end if;
            end pedido;
         or delay 120.0;
            delay 60.0;
         end select;
      end loop;
   end usuario

-- Nota: acá si se prioriza que antes de aprobar un nuevo documento revisa si hay alguno para corregir.