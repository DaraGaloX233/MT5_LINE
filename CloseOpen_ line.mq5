//+------------------------------------------------------------------+
//|                                         CloseOpen_short line.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//计算昨日收盘和今日开盘差距，画短线

//--- indicator buffers
input color    inClrYesterdayClose=clrAquamarine;
input color    inClrTodayOpen=clrAquamarine;
input int      InpWidth=3;
input ENUM_LINE_STYLE InpStyle=STYLE_DASH;
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
//先提取昨天和今天的时间
   double prev_dayClose=iClose(_Symbol,PERIOD_D1,1);
   double today_dayOpen=iOpen(_Symbol,PERIOD_D1,0);
   double differ=(today_dayOpen-prev_dayClose)/today_dayOpen*100;
   HLineDelete(0,"prev_dayClose");
   HLineDelete(0,"today_dayOpen");
   HLineCreate(0,"prev_dayClose",0,prev_dayClose,inClrYesterdayClose,0,InpWidth);
   HLineCreate(0,"today_dayOpen",0,today_dayOpen,inClrTodayOpen,0,InpWidth);
   HLineMove(0,"prev_dayClose",prev_dayClose);
   HLineMove(0,"today_dayOpen",today_dayOpen);

   string text="prev_dayClose: "+DoubleToString(prev_dayClose)+"\n"+
               "today_dayOpen: "+DoubleToString(today_dayOpen)+"\n"+
               "differ"+DoubleToString(differ)+"%";
   Comment(text);
   return(rates_total);
  }
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,        // 图表 ID
                 string                name="HLine",      // 线的名称
                 const int             sub_window=0,      // 子窗口指数
                 double                price=0,           // 线的价格
                 const color           clr=clrAqua,        // 线的颜色
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // 线的风格
                 const int             width=3,           // 线的宽度
                 const long            z_order=0)         // 鼠标单击优先


  {

//--- 如果没有设置价格，则在当前卖价水平设置它
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- 重置错误的值
   ResetLastError();
//--- 创建水平线
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price)) //change here
     {
      Print(__FUNCTION__,
            ": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }

   ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price);
//--- 设置线的颜色
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); //这里clr不能设定颜色，否则会锁死颜色不能变
//--- 设置线的显示风格
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,InpStyle);
//--- 设置线的宽度
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,InpWidth);
   return(true);
  }
//+------------------------------------------------------------------+
//| 移动水平线                                                        |
//+------------------------------------------------------------------+
bool HLineMove(const long   chart_ID=0,   // 图表 ID
               const string name="HLine", // 线的名称
               double       price=0)      // 线的价格
  {
//--- 如果没有设置线的价格，则将其移动到当前卖价水平
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- 重置错误的值
   ResetLastError();
//--- 移动水平线
   if(!ObjectMove(chart_ID,name,0,0,price))
     {
      Print(__FUNCTION__,
            ": failed to move the horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行
   return(true);
  }
//+------------------------------------------------------------------+
//| 删除水平线                                                        |
//+------------------------------------------------------------------+
bool HLineDelete(const long   chart_ID=0,   // 图表ID
                 const string name="HLine") // 线的名称
  {
//--- 重置错误的值
   ResetLastError();
//--- 删除水平线
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行
   return(true);
  }

bool ChartCommentSet(const string str,const long chart_ID=0) 
  { 
ChartSetString(chart_ID,CHART_COMMENT,str) ;
return(true); 
  }