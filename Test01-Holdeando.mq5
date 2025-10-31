#property strict

input int delta_days = 0;
input double lots = 0.01;

datetime first_day = 0;
bool done = false;

void OnTick()
{

   // Evitamos múltiples ejecuciones
   if(done) return;

   // Capturamos el primer día en el que se ejecuta el bot
   if(first_day == 0){
      first_day = TimeCurrent();
      return; // esperamos al siguiente tick
   }

   // Si aún no llegamos al día objetivo, no hacemos nada
   if(TimeCurrent() < first_day + delta_days * 86400)
      return;

   // Preparar y enviar orden MARKET BUY
   MqlTradeRequest req;
   MqlTradeResult  res;
   ZeroMemory(req);
   ZeroMemory(res);
   
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   req.action    = TRADE_ACTION_DEAL;
   req.symbol    = _Symbol;
   req.volume    = lots;
   req.type      = ORDER_TYPE_BUY;
   req.price     = ask;
   req.deviation = 5;
   req.magic     = 1;
   req.comment   = "Testing random buy";
   req.type_filling = ORDER_FILLING_FOK;

   if(OrderSend(req, res)){
      PrintFormat("BUY ejecutado: ticket=%I64d volumen=%.2f precio=%.5f en fecha %s", 
         res.order, lots, ask, TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS));
   }else{
      PrintFormat("OrderSend fallo: codigo=%d retcode=%d comment=%s", 
         GetLastError(), res.retcode, res.comment);
   }
   
   done = true;
}
