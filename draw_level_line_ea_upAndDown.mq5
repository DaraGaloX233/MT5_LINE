//+------------------------------------------------------------------+
//|                                     draw_level_line_ea_test2.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }



//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---


   double bid = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_BID),_Digits);
//double ComferLine=MathMod(tempInPrice,InLine);

   double div_Thousand =0.0;
   double LevalArray[5];
   LevalArray [0]= 0.0;

//--- take bid price div
   div_Thousand = double(int(bid/1000)) *1000-200;
// Print(" div_Thousand2 =", div_Thousand);

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


//Print("Do not create object = ",GetLastError());

   for(int i=0; i<5; i++)
     {
      string name="Level_";
      name=name+string(i);

      ObjectDelete(0, name);

      if(!ObjectCreate(0, name, OBJ_HLINE, 0,0,LevalArray[i]))
         Print("error creat line",GetLastError());
     }





  }

//+------------------------------------------------------------------+
