//+------------------------------------------------------------------+
//|                                         CloseOpen_short line.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//计算昨日收盘和今日开盘差距，画短线
//time1,price1,time2,price2
//昨天，close，今天，昨天close
//--- indicator buffers
#property script_show_inputs 
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_LINE
#property indicator_color1  Red
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
 
   //HLineDelete(0,"prev_dayClose");
  //HLineDelete(0,"today_dayOpen");
  // HLineCreate(0,"prev_dayClose",0,1,prev_dayClose,0,prev_dayClose,inClrYesterdayClose);
  //HLineCreate(0,"today_dayOpen",0,1,today_dayOpen,0,today_dayOpen,inClrTodayOpen);
  	HLineMove(0,"prev_dayClose",prev_dayClose);
  	  TrendPointChange(0,"prev_dayClose",0,1,prev_dayClose);
   HLineMove(0,"today_dayOpen",today_dayOpen);
TrendPointChange(0,"today_dayOpen",0,0,today_dayOpen);

   string text="prev_dayClose: "+DoubleToString(prev_dayClose)+"\n"+
               "today_dayOpen: "+DoubleToString(today_dayOpen)+"\n"+
               "differ: "+DoubleToString(differ)+"%";
   Comment(text);
   return(rates_total);
  }
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,        // 图表 ID 
                 const string          name="DifferTrendLine",  // 线的名称 
                 const int             sub_window=0,      // 子窗口指数 
                 datetime              time1=0,           // 第一个点的时间 
                 double                price1=0,          // 第一个点的价格 
                 datetime              time2=0,           // 第二个点的时间 
                 double                price2=0,          // 第二个点的价格 
                 const color           clr=clrAquamarine,  // 线的颜色 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // 线的风格 
                 const int             width=3,           // 线的宽度 
                 const bool            back=false,        // 在背景中 
                 const bool            selection=true,    // 突出移动 
                 const bool            ray_left=false,    // 线延续向左 
                 const bool            ray_right=false,   // 线延续向右 
                 const bool            hidden=true,       // 隐藏在对象列表 
                 const long            z_order=0)         // 鼠标单击优先


  {

//--- 如果没有设置价格，则在当前卖价水平设置它
 ChangeTrendEmptyPoints(time1,price1,time2,price2);
//--- 创建水平线
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,0,time1,price1,time2,price2,clr)) //change here
     {
      Print(__FUNCTION__,
            ": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }

   ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,0,time1,price1,time2,price2,clr);
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
  
  void ChangeTrendEmptyPoints(datetime &time1,double &price1, 
                            datetime &time2,double &price2) 
  { 
//--- 如果第一点的时间没有设置，它将位于当前柱 
   if(!time1) 
      time1=TimeCurrent(); 
//--- 如果第一点的价格没有设置，则它将用卖价值 
   if(!price1) 
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- 如果第二点的时间没有设置，它则位于第二点左侧的9个柱 
   if(!time2) 
     { 
      //--- 接收最近10柱开盘时间的数组 
      datetime temp[10]; 
      CopyTime(Symbol(),Period(),time1,10,temp); 
      //--- 在第一点左侧9柱设置第二点 
      time2=temp[0]; 
     } 
//--- 如果第二点的价格没有设置，则它与第一点的价格相等 
   if(!price2) 
      price2=price1; 
  } 


bool TrendPointChange(const long   chart_ID=0,       // 图表 ID 
                      const string name="TrendLine", // 线的名称 
                      const int    point_index=0,    // 定位点指数 
                      datetime     time=0,           // 定位点时间坐标 
                      double       price=0)          // 定位点价格坐标 
  { 
//--- 如果没有设置点的位置，则将其移动到当前的卖价柱 
   if(!time) 
      time=TimeCurrent(); 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- 重置错误的值 
   ResetLastError(); 
//--- 移动趋势线定位点   
   if(!ObjectMove(chart_ID,name,point_index,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to move the anchor point! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- 成功执行 
   return(true); 
  } 