//+------------------------------------------------------------------+
//|                                                DrawLevelLine.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

input double InPrice;
input double InLine=20;
input int Level=1;
double	tempInPrice=InPrice;
int digit;
double High;
double Low;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])

  {
//---
/*
   while(InPrice)
     {
      tempInPrice=InPrice/10;
      digit+=1;
     }

   digit=10^digit;
*/
	double bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
	tempInPrice=bid;
  	
  int Level=int(log10(round(bid)));

 	double ComferLine=MathMod(tempInPrice,InLine);
 	
 	
 	for(int i=1;i<Level;i++)
 { 	if(ComferLine==int(ComferLine))
    {
      High=tempInPrice+InLine;
      Low=tempInPrice-InLine;
     }
 	 drawLine(tempInPrice,High,Low);
 }
												
//--- return value of prev_calculated for next call
   return(rates_total);

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLine(double &tempInPrice, double &High, double &Low )
  {
	ObjectDelete(0, "InPrice");
   ObjectDelete(0, "High");
   ObjectDelete(0, "Low");
  
	ObjectCreate(0, "InPrice", OBJ_HLINE, 0, 0, tempInPrice);
   ObjectSetInteger(0, "InPrice", OBJPROP_COLOR, clrGreen);

   ObjectCreate(0, "High", OBJ_HLINE, 0, 0, High);
   ObjectSetInteger(0, "High", OBJPROP_COLOR, clrYellow);

  
	ObjectCreate(0, "Low", OBJ_HLINE, 0, 0, Low);
   ObjectSetInteger(0, "Low", OBJPROP_COLOR, clrWhite);
  }
//+------------------------------------------------------------------+
