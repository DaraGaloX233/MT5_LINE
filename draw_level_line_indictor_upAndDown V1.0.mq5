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
#property indicator_plots 2
input double InLineSeparate=200.0;
input int   mperiod=10;

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
	PeriodMaxAndLowLine(mperiod);
   LevelLine(InLineSeparate);


//--- return value of prev_calculated for next call
   return(rates_total);
  }


//+------------------------------------------------------------------+
void PeriodMaxAndLowLine(int period)
  {
   double High[];
   double Low[];
   int highsgot=CopyHigh(Symbol(),PERIOD_D1,0,period,High);
   int lowsgot=CopyLow(Symbol(),PERIOD_D1,0,period,Low);
   int HighMax=ArrayMaximum(High,0,WHOLE_ARRAY);
   int LowMax=ArrayMinimum(Low,0,WHOLE_ARRAY);
   Print("HighMax: ",High[HighMax]);
   Print("LowMax: ",Low[LowMax]);


   ObjectDelete(0, "highsgot");
   ObjectDelete(0, "lowsgot");


   ObjectCreate(0, "highsgot", OBJ_HLINE, 0,0,High[HighMax]);
   ObjectSetInteger(0,"highsgot",OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,"highsgot",OBJPROP_WIDTH,2);

   ObjectCreate(0, "lowsgot", OBJ_HLINE, 0,0,Low[LowMax]);
   ObjectSetInteger(0,"lowsgot",OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,"lowsgot",OBJPROP_WIDTH,2);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LevelLine(double LineSeparate)
  {
   double LevalArray[5];
   LevalArray [0]= 0.0;
  	double close= NormalizeDouble(iClose(_Symbol,0,1),_Digits);
   //double close = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_LAST),_Digits);
   
//--- take close price div
   double  div_Thousand= double(int(close/100)-4) *100;

 
   Print("div_Thousand: ",div_Thousand);



//---For 200...800 = 4 level


   int k =0;

   for(int j=0; j<1000; j=j+int(LineSeparate))//j=j+200
     {
      double temp =div_Thousand + double(j);
      LevalArray[k] = temp;
      k++;
     }


   for(int i=0; i<5; i++)
     {
      string name="Level_"+string(i);
		
      ObjectDelete(0,name);
      ObjectCreate(0, name, OBJ_HLINE, 0,0,LevalArray[i]);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clrOldLace);


     }


  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
