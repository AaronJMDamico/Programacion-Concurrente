-- 2) Resolver el siguiente problema. En un negocio de cobros digitales hay P personas que deben pasar
-- por la única caja de cobros para realizar el pago de sus boletas. Las personas son atendidas de acuerdo
-- con el orden de llegada, teniendo prioridad aquellos que deben pagar menos de 5 boletas de los que
-- pagan más. Adicionalmente, las personas ancianas tienen prioridad sobre los dos casos anteriores.
-- Las personas entregan sus boletas al cajero y el dinero de pago; el cajero les devuelve el vuelto y los
-- recibos de pago.

procedure Ejercicio02 is

task type persona;

task caja is
   entry pedidoAncianos(dinero : in Float; boletas : in Integer; vuelto : out Float; recibo : out String);
   entry pedidoBoletas(dinero : in Float; boletas : in Integer; vuelto : out Float; recibo : out String);
   entry pedidoNormal(dinero : in Float; boletas : in Integer; vuelto : out Float; recibo : out String);
end caja;

arrPersonas : array (1..P) of persona;

task body persona is
   esAnciano : Boolean = ?
   boletas : Integer = ?
   dinero : Float = ?
   vuelto : Float;
   recibo : String;
begin
   -- se inicializan o se reciben por parámetro las variables
   if esAnciano then
      caja.pedidoAncianos(dinero, boletas, vuelto, recibo)
   elsif boletas < 5 then
      caja.pedidoBoletas(dinero, boletas, vuelto, recibo)
   else 
      caja.pedidoNormal(dinero, boletas, vuelto, recibo)
   end if;
end persona;

task body caja is
   
begin
   loop
      select
         accept pedidoAncianos (dinero : in Float; boletas : in Integer; vuelto : out Float; recibo : out String) do
            -- procesar pago
         end pedidoAncianos
      or when pedidoAncianos'Count = 0 ->
         accept pedidoBoletas (dinero : in Float; boletas : in Integer; vuelto : out Float; recibo : out String) do
            -- procesar pago
         end pedidoBoletas
      or when pedidoAncianos'Count = 0 and pedidoBoletas'Count = 0 ->
         accept pedidoNormal (dinero : in Float; boletas : in Integer; vuelto : out Float; recibo : out String) do
            -- procesar pago
         end pedidoNormal
      end select;
   end loop; 
end caja;

begin
   null;
end Ejercicio02;