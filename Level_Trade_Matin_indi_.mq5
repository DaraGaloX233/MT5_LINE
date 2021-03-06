//+------------------------------------------------------------------+
//|                                      Level_Trade_Matin_indi_.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//------Trade setting
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>

CPositionInfo  m_position;                   // trade position object
CTrade         m_trade;                      // trading object
CSymbolInfo    m_symbol;                     // symbol info object

input ulong m_magic = 98680914;  // Magic Number
//--- Oninit ---
double         ExtTakeProfit = 0.0;
double         ExtStopLoss = 0.0;


double         m_adjusted_point;
ulong          m_slippage = 30;              // slippage
string         str_Digits_adj = " ";


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---

//---
     if(!m_symbol.Name(Symbol())) // sets symbol name
          return(INIT_FAILED);
//---
     m_trade.SetExpertMagicNumber(m_magic);

//---
     /*
     if(IsFillingTypeAllowed(SYMBOL_FILLING_FOK))
         m_trade.SetTypeFilling(ORDER_FILLING_FOK);
     else if(IsFillingTypeAllowed(SYMBOL_FILLING_IOC))
         m_trade.SetTypeFilling(ORDER_FILLING_IOC);
     else
         m_trade.SetTypeFilling(ORDER_FILLING_RETURN);
         */
       
//---
     m_trade.SetDeviationInPoints(m_slippage);


//--- tuning for 3 or 5 digits ---
     int digits_adjust = 1;

// Dollar = 3 or 5 Digits
     if(m_symbol.Digits() == 3 || m_symbol.Digits() == 5)
     {
          digits_adjust = 10;
          str_Digits_adj = " Init = Dollar / 1:10";
     }

// XAUUSD =digits 100

     if(m_symbol.Digits() == 2 && m_symbol.Name() == "XAUUSD")
     {
          digits_adjust = 100;
          str_Digits_adj = " Init = XAUUSD / 1:100";
     }

     else if(m_symbol.Digits() == 2 && m_symbol.Name() == "HK50")
     {
          digits_adjust = 100;
          str_Digits_adj = " Init = HK50 / 1:100";
     }
     else if(m_symbol.Digits() == 2 )
     {
          digits_adjust = 100;  // US30 =10 // USTEC =10, US500 = 10.
          str_Digits_adj = "Symbol (US30 =10 // USTEC =10, US500 = 10) 1:100";

     }

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

     LevelLine();

}
//+------------------------------------------------------------------+
//|  Draw Hundred point separate line                                                                 |
//+------------------------------------------------------------------+
void LevelLine()
{

     double ask = NormalizeDouble(SymbolInfoDouble(Symbol(), SYMBOL_ASK), _Digits);
     double LevalArray[5];
     LevalArray [0] = 0.0;

     double div_Hundred = 0.0; // Div Price to K
     double temp_mod = 0.0;

     double addPoint = 1.0;
     static double Hundred = 0.0 ;
     double separate_Line = 0.0; // 分隔線


     //Print("digits = ", m_symbol.Digits());

     if(m_symbol.Digits() == 2)
     {
//--- take symbol ask price div / Hundred

//-- for US30, ustec, us500, Price > 10 K
          div_Hundred = int(ask / 100); // 276 / 27.6 13579/


          if(div_Hundred >= 100)
          {
               temp_mod = MathMod(div_Hundred, 2);  // 276 % 2 =0 or 1
               separate_Line = 200;

          }
          else if (div_Hundred < 100)  //-- for XAUUSD price < 10 K
          {
               div_Hundred = int(ask / 10); // 19.6 13579/
               temp_mod = MathMod(div_Hundred, 2);  // 19K % 2 =0 or 1
               separate_Line = 20;

          }
     } // End Digits to == 2 &&

//--- For Dollar Darw separate Line
     if(m_symbol.Digits() == 5)
     {
          double temp = ask - 1;
          //ulong div_Hundred1 = int(temp); // 19.6 13579/
          //Print("temp = ", temp);

          double temp1 = double(temp / 100);
          //Print("temp1 = ", temp1);
          temp_mod = MathMod(temp1, 2);  // 19K % 2 =0 or 1
          separate_Line = 20;

          //Print("temp_mod =", temp_mod);

     }

//----------------------------------- 
     if(Hundred < div_Hundred )
     {
          if(temp_mod == 0) // if div_Hundred == 268, 264 ,is double Number
               Hundred = div_Hundred ;
          else
               Hundred = div_Hundred + addPoint; // is single number + 1



     }
     else if( Hundred > div_Hundred )
     {
          if(temp_mod == 0)
               Hundred = div_Hundred ;
          else
               Hundred = div_Hundred + addPoint;
          //Print(" Hundred > = div_Hundred ", Hundred, " / div = ", div_Hundred);

     }

     double baseLine = 0.0;

     if(separate_Line == 200)
          baseLine = Hundred * 100;
     else
          baseLine = Hundred * 10;


     /*
     Print("Hundred         = ", Hundred);
     Print("");
     Print("baseLine Up     = ", baseLine + 200);
     Print("middle baseLine = ", baseLine);
     Print("baseLine Dn     = ", baseLine - 200);
      */
//---print out

     LevalArray[0] = baseLine + separate_Line + separate_Line;
     LevalArray[1] = baseLine + separate_Line;
     LevalArray[2] = baseLine;
     LevalArray[3] = baseLine - separate_Line;
     LevalArray[4] = baseLine - separate_Line - separate_Line;
//---

     for(int i = 0; i < 5; i++)
     {
          string name = "Level_" + string(i);
          ObjectDelete(0, name);

          ObjectCreate(0, name, OBJ_HLINE, 0, 0, LevalArray[i]);
          ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);

          if(!ObjectCreate(0, name, OBJ_HLINE, 0, 0, LevalArray[i]))
          {

               Print("error creat line", GetLastError());

          }
     }

} // End Draw Hundar Line


//+------------------------------------------------------------------+
