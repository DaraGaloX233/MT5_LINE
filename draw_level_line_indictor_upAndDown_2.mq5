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
// PeriodMaxAndLowLine(mperiod);
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
   double bid = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_BID),_Digits);

//--- take bid price div
   int  div_Thousand= int(bid/1000); //27 +/- 1 26-28
   Print("div_Thousand= ",div_Thousand);
   double  div_Hundar = int(bid/100); // 276 / 27.6 13579/
   Print("div_hundar =",div_Hundar);
   double temp_mod = MathMod(div_Hundar, div_Thousand);  ;   // 6
   Print("temp_div = ", temp_mod);

//---
   double plugHigh = div_Thousand + 1; // value =28
   double plugLow  = div_Thousand - 1; // vlaue =26
   double middleLine = 0.0; // init
   
// follow detect under 500.
   if(temp_mod > 5) // mod > 6789
     {
      //plugHigh = plugHigh + 0.6; // 27
       plugHigh=plugHigh + 0.6;
      middleLine = plugLow + 1.6; // 26 + 0.6 = 26.6

     }

// follow detect under 500.
   if(temp_mod <5)   // mod <5 = 43210
     {
      //plugLow = plugLow -0.6 ; // 24.6
       plugLow=plugLow-0.6;
      middleLine = plugHigh - 1.6; // 27 - 0.6 =26.6

     }

//---print out

   double upline = double(plugHigh * 1000);//27,000.00
   double dnline = double(plugLow * 1000);// 26,000.00
   middleLine = middleLine * 1000;//26500

   Print("upline = ",upline);
   Print("dnline = ",dnline);
   Print("mid line = ", middleLine);


   ObjectDelete(0, "upline");
/// if(modup==0)
// {
   ObjectCreate(0, "upline", OBJ_HLINE, 0,0,upline);
   ObjectSetInteger(0,"upline",OBJPROP_COLOR,clrOldLace);
//  }


   ObjectDelete(0, "dnline");
//  if(moddn==0)
//  {
   ObjectCreate(0, "dnline", OBJ_HLINE, 0,0,dnline);
   ObjectSetInteger(0,"dnline",OBJPROP_COLOR,clrOldLace);
//    }

   ObjectDelete(0, "middleLine");
   ObjectCreate(0, "middleLine", OBJ_HLINE, 0,0,middleLine);
   ObjectSetInteger(0,"middleLine",OBJPROP_COLOR,clrOldLace);



   /*
      int upline =div_Thousand +1;
      int dnline =div_Thousand -1;


      Print("upline: ",upline);
      Print("dnline: ",dnline);
     */


// int uplinediv_Hundar=(upline)*100;
// int dnlinediv_Hundar=(dnline)*100;
//   double uplinediv_Thousand=double(upline*1000);//26000
//  double dnlinediv_Thousand=double(dnline*1000);//24000
// Print ("uplinediv_Thousand: ",uplinediv_Thousand);
//Print ("dnlinediv_Thousand: ",dnlinediv_Thousand);
//double modup=MathMod(uplinediv_Hundar,200);
//double moddn=MathMod(dnlinediv_Hundar,200);
//double modup=MathMod(uplinediv_Thousand,200);
//double moddn=MathMod(dnlinediv_Thousand,200);
//Print("modup: ",modup);
//Print("moddn: ",moddn);
//if(MathMod(uplinediv_Hundar,2))

// int middleLine=(uplinediv_Hundar+dnlinediv_Hundar)/2;
// double middleLine=(upline+dnline)/2*1000;
//   double middleLine=0.0;
//   Print("middle",middleLine);
//   Print(" Upline = ", upline," upline = ", dnline);


// Print(" uplinediv_Thousand = ", uplinediv_Hundar,"dnlinediv_Thousand = ", dnlinediv_Hundar);
//if temp_div>5 middle +500 from underline, if temp_div<5 middle -500 from up


//   Print("middle",middleLine);
//   Print(" Upline = ", upline," upline = ", dnline);

//middle line +200 -200
//double middleLinePlus=middleLine;
//double middleLineMin=middleLine;

   /*
      ObjectDelete(0, "uplinediv_Thousand");
   /// if(modup==0)
   // {
      ObjectCreate(0, "uplinediv_Thousand", OBJ_HLINE, 0,0,uplinediv_Thousand);
      ObjectSetInteger(0,"uplinediv_Thousand",OBJPROP_COLOR,clrOldLace);
   //  }


      ObjectDelete(0, "dnlinediv_Thousand");
   //  if(moddn==0)
   //  {
      ObjectCreate(0, "dnlinediv_Thousand", OBJ_HLINE, 0,0,dnlinediv_Thousand);
      ObjectSetInteger(0,"dnlinediv_Thousand",OBJPROP_COLOR,clrOldLace);
   //    }

      ObjectDelete(0, "middleLine");
      ObjectCreate(0, "middleLine", OBJ_HLINE, 0,0,middleLine);
      ObjectSetInteger(0,"middleLine",OBJPROP_COLOR,clrOldLace);
   */

   /*
   for(int i = 0 ; i <10 ; i++)
     {
      Print("i++", i);
     }

   for(int i = 10 ; i >0 ; i--)
     {
      Print("i--", i);
     }
   */
   /*
   static double temp1 = div_Thousand -1;
   static double temp2 = div_Thousand +1;

   Print("bid ",bid);
   Print("div_Thousand: ",div_Thousand);
   Print("temp1 ",temp1);
   Print("temp2 ",temp2);
   */



//---For 200...800 = 4 level
   /*
      int k =0;

      for(int j=0; j<1000; j=j+int(LineSeparate))//j=j+200
        {
         double temp = div_Thousand + double(j);
         LevalArray[k] = temp;
         k++;

        }

   */
   /*
      for(int i=0; i<5; i++)
        {
         string name="Level_"+string(i);
         ObjectDelete(0, name);
         ObjectCreate(0, name, OBJ_HLINE, 0,0,LevalArray[i]);
         ObjectSetInteger(0,name,OBJPROP_COLOR,clrOldLace);
         /*
          if(!ObjectCreate(0, name, OBJ_HLINE, 0,0,LevalArray[i]))
            {

             Print("error creat line",GetLastError());

            }
            */
//}//


  } // End &&&
//+------------------------------------------------------------------+
