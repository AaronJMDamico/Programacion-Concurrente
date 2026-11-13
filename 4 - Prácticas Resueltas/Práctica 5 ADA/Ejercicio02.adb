-- 2) Se quiere modelar el funcionamiento de un banco, al cual llegan clientes que deben realizar
-- un pago y retirar un comprobante. Existe un único empleado en el banco, el cual atiende de
-- acuerdo con el orden de llegada.

-- a) Implemente una solución donde los clientes llegan y se retiran sólo después de haber sido atendidos.

procedure Ejercicio02A is

   task Empleado is
      entry Pedido(Pago: in text, Res: out text);
   end Empleado;

   task type Cliente;

   arrClientes: array(1..N) of Cliente;

   task body Cliente is
      Comprobante: text;
   begin
      Empleado.Pedido("Pago", Comprobante);
   end Cliente;

   task body empleado is
   begin
      loop
         accept Pedido (Pago: in text; Res: out text) do
            Res := registrarPago(Pago);
         end Pedido;
      end loop
   end Empleado;

begin
   null;
end Ejercicio02A;

-- b) Implemente una solución donde los clientes se retiran si esperan más de 10 minutos para realizar el pago.

procedure Ejercicio02B is

   task Empleado is
      entry Pedido(Pago: in text, Res: out text);
   end Empleado;

   task type Cliente;

   arrClientes: array(1..N) of Cliente;

   task body Cliente is
      Comprobante: text;
   begin
      select
         Empleado.Pedido("Pago", Comprobante);
      or delay 600.0
         null
      end select;
   end Cliente;

   task body empleado is
   begin
      loop
         accept Pedido (Pago: in text; Res: out text) do
            Res := registrarPago(Pago);
         end Pedido;
      end loop
   end Empleado;

begin
   null;
end Ejercicio02B;

-- C) Implemente una solución donde los clientes se retiran si no son atendidos inmediatamente.

procedure Ejercicio02C is

   task Empleado is
      entry Pedido(Pago: in text, Res: out text);
   end Empleado;

   task type Cliente;

   arrClientes: array(1..N) of Cliente;

   task body Cliente is
      Comprobante: text;
   begin
      select
         Empleado.Pedido("Pago", Comprobante);
      else
         null
      end select;
   end Cliente;

   task body empleado is
   begin
      loop
         accept Pedido (Pago: in text; Res: out text) do
            Res := registrarPago(Pago);
         end Pedido;
      end loop
   end Empleado;

begin
   null;
end Ejercicio02C;

-- D) Implemente una solución donde los clientes esperan a lo sumo 10 minutos para ser
-- atendidos. Si pasado ese lapso no fueron atendidos, entonces solicitan atención una vez más
-- y se retiran si no son atendidos inmediatamente.

procedure Ejercicio02D is

   task Empleado is
      entry Pedido(Pago: in text, Res: out text);
   end Empleado;

   task type Cliente;

   arrClientes: array(1..N) of Cliente;

   task body Cliente is
      Comprobante: text;
   begin
      select
         Empleado.Pedido("Pago", Comprobante);
      or delay 600.0
         select
            Empleado.Pedido("Pago", Comprobante);
         else
            null
         end select;
      end select;
   end Cliente;

   task body empleado is
   begin
      loop
         accept Pedido (Pago: in text; Res: out text) do
            Res := registrarPago(Pago);
         end Pedido;
      end loop
   end Empleado;

begin
   null;
end Ejercicio02D;