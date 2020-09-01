//+------------------------------------------------------------------+
//|                           draw_level_line_indictor_upAndDown.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots 5

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

   double bid = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_BID),_Digits);
   
   int devider=int(log10(bid));
   //Print(devider);


   double div_Thousand =0.0;
   double LevalArray[5];
   LevalArray [0]= 0.0;

//--- take bid price div
   div_Thousand = double(int(bid/10)) *10-400;
 	Print("div_Thousand: ",div_Thousand);

   if(div_Thousand < 0)
      Print("Error zero");

//---For 200...800 = 4 level

   int k =0;

   for(int j=0; j<1000; j=j+200)
     {
      double temp = div_Thousand + double(j);
      LevalArray[k] = temp;
      k +=1;
      //Print(" i = ",i,"j = ",j);
      //Print("LevelArr= ", LevalArray[i]);
     }


   for(int i=0; i<5; i++)
     {
      string name="Level_";
      name=name+string(i);

      ObjectDelete(0, name);
		//ObjectSetInteger(0,name,0,clrYellow);
      if(!ObjectCreate(0, name, OBJ_HLINE, 0,0,LevalArray[i]))
			{
			
         Print("error creat line",GetLastError());
         
         }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
