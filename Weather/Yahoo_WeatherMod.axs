Module_Name='Yahoo_WeatherMod' 
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 08/22/2014  AT: 12:41:32        *)
(***********************************************************)
( 
	dev dvAPI,
	dev vdvAPI,
	dev dvTP[],
	integer RfshTime
)

//	 http://weather.yahooapis.com/forecastrss?w=2436704 12795460  

// --> http://feeds.weatherbug.com/rss.aspx?zipcode=81611&feed=currtxt,fcsttxt&zcode=z4641
// --> http://forecast.weather.gov/MapClick.php?CityName=Aspen&state=CO&site=GJT&textField1=39.1946&textField2=-106.827&TextType=1
// --> http://www.crh.noaa.gov/images/fxc/gjt/wx/File.png

/*

Code 		Description
0 			tornado
1 			tropical storm
2 			hurricane
3 			severe thunderstorms
4 			thunderstorms
5 			mixed rain and snow
6 			mixed rain and sleet
7 			mixed snow and sleet
8 			freezing drizzle
9 			drizzle
10 			freezing rain
11 			showers
12 			showers
13 			snow flurries
14 			light snow showers
15 			blowing snow
16 			snow
17 			hail
18 			sleet
19 			dust
20 			foggy
21 			haze
22 			smoky
23 			blustery
24 			windy
25 			cold
26 			cloudy
27 			mostly cloudy (night)
28 			mostly cloudy (day)
29 			partly cloudy (night)
30 			partly cloudy (day)
31 			clear (night)
32 			sunny
33 			fair (night)
34 			fair (day)
35 			mixed rain and hail
36 			hot
37		 	isolated thunderstorms
38 			scattered thunderstorms
39 			scattered thunderstorms
40 			scattered showers
41 			heavy snow
42 			scattered snow showers
43 			heavy snow
44 			partly cloudy
45 			thundershowers
46 			snow showers
47 			isolated thundershowers
3200 		not available


*/

//		<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
//				<rss version="2.0" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
//					<channel>
//				
//		<title>Yahoo! Weather - Las Vegas, NV</title>
//		<link>http://us.rd.yahoo.com/dailynews/rss/weather/Las_Vegas__NV/*http://weather.yahoo.com/forecast/USNV0049_f.html</link>
//		<description>Yahoo! Weather for Las Vegas, NV</description>
//		<language>en-us</language>
//		<lastBuildDate>Sun, 18 Aug 2013 8:52 am PDT</lastBuildDate>
//		<ttl>60</ttl>
//		<yweather:location city="Las Vegas" region="NV"   country="United States"/>
//		<yweather:units temperature="F" distance="mi" pressure="in" speed="mph"/>
//		<yweather:wind chill="90"   direction="120"   speed="3" />
//		<yweather:atmosphere humidity="26"  visibility="10"  pressure="29.99"  rising="1" />
//		<yweather:astronomy sunrise="6:01 am"   sunset="7:25 pm"/>
//		<image>
//		<title>Yahoo! Weather</title>
//		<width>142</width>
//		<height>18</height>
//		<link>http://weather.yahoo.com</link>
//		<url>http://l.yimg.com/a/i/brand/purplelogo//uh/us/news-wea.gif</url>
//		</image>
//		<item>
//		<title>Conditions for Las Vegas, NV at 8:52 am PDT</title>
//		<geo:lat>36.17</geo:lat>
//		<geo:long>-115.14</geo:long>
//		<link>http://us.rd.yahoo.com/dailynews/rss/weather/Las_Vegas__NV/*http://weather.yahoo.com/forecast/USNV0049_f.html</link>
//		<pubDate>Sun, 18 Aug 2013 8:52 am PDT</pubDate>
//		<yweather:condition  text="Fair"  code="34"  temp="90"  date="Sun, 18 Aug 2013 8:52 am PDT" />
//		<description><![CDATA[
//		<img src="http://l.yimg.com/a/i/us/we/52/34.gif"/><br />
//		<b>Current Conditions:</b><br />
//		Fair, 90 F<BR />
//		<BR /><b>Forecast:</b><BR />
//		Sun - Partly Cloudy. High: 102 Low: 81<br />
//		Mon - Mostly Cloudy. High: 101 Low: 80<br />
//		Tue - Mostly Sunny. High: 103 Low: 81<br />
//		Wed - Partly Cloudy. High: 105 Low: 80<br />
//		Thu - Partly Cloudy. High: 104 Low: 78<br />
//		<br />
//		<a href="http://us.rd.yahoo.com/dailynews/rss/weather/Las_Vegas__NV/*http://weather.yahoo.com/forecast/USNV0049_f.html">Full Forecast at Yahoo! Weather</a><BR/><BR/>
//		(provided by <a href="http://www.weather.com" >The Weather Channel</a>)<br/>
//		]]></description>
//		<yweather:forecast day="Sun" date="18 Aug 2013" low="81" high="102" text="Partly Cloudy" code="30" />
//		<yweather:forecast day="Mon" date="19 Aug 2013" low="80" high="101" text="Mostly Cloudy" code="28" />
//		<yweather:forecast day="Tue" date="20 Aug 2013" low="81" high="103" text="Mostly Sunny" code="34" />
//		<yweather:forecast day="Wed" date="21 Aug 2013" low="80" high="105" text="Partly Cloudy" code="30" />
//		<yweather:forecast day="Thu" date="22 Aug 2013" low="78" high="104" text="Partly Cloudy" code="30" />
//		<guid isPermaLink="false">USNV0049_2013_08_22_7_00_PDT</guid>
//		</item>
//		</channel>
//		</rss>
//		
//		<!-- api28.weather.gq1.yahoo.com Sun Aug 18 16:57:08 PST 2013 -->



define_constant	// Debug Level Constants

integer nDbg_Lvl1 = 1;	// Error Mesaages Only
integer nDbg_Lvl2 = 2;	// Error & Warning Mesaages Only
integer nDbg_Lvl3 = 3;	// Error, Warning, & Data Received Mesaages Only
integer nDbg_Lvl4 = 4;	// All Messages

define_constant

long tlUpdate		= 01;
long tlDataRcv  = 02;

define_constant

REFRESH_TIME     	= 60 ;
TRUE             	= 1 ;
FALSE            	= 0 ;
CLIENT_ONLINE	 		= 1 ;
CLIENT_OFFLINE	 	= 0 ;
SERVER_ONLINE	 		= 2 ;
TCP              	= 1 ;
UDP         	 		= 2 ;
ClientOnline      = 12 ;
crlf[2]           = {$0D,$0A} ;

define_constant

integer nUI_Wthr_Cntl[] = 
{
	01,
	02,
	03,
	04,
	05,
	06,
	07,
	08,	
	09, // Last Update
	10
}

integer nUI_Crnt_Cond[] = 
{
	11,	// City And Region
	12,	// Weather Icon
	13,	// Current Temp
	14,	// High
	15,	// Low
	16,	// Condition
	17,	// Wind
	18,	// Humidity
	19,	// Visibilty
	20,	// Pressure
	21, // Sunrise
	22, // Sunset
	23, // Wind Direction
	24, // Compass Icon
	25
}

integer nUI_Fcst_WDay[] = {31,32,33,34,35};
integer nUI_Fcst_Icon[] = {41,42,43,44,45};
integer nUI_Fcst_Text[] = {51,52,53,54,55};
integer nUI_Fcst_High[] = {61,62,63,64,65};
integer nUI_Fcst_Lows[] = {71,72,73,74,75};

define_type

struct _this
{
	char buffer[65000];
	
	integer PrtOnline;
	integer PrtActive;
	
	slong	PrtError;
	slong PrtRetry;
	
	integer devNum;
	integer devPrt;
	
	char page[32];
	
	char sysRunning;
	
	char location[16];
	char weatherscale[16];
	
	char buildDate[32];
}

struct _WeatherCond
{
	char text[16]
	char code [8]
	char temp [8]
	char refDate [64]
	
	char sunrise[16]
	char sunset [16]
	
	integer direction
	char windDir  [16];
	char chill    [32]
	char speed  	[8]
	
	char country [16]
	char city    [32]
	char region  [8]
	
	char humidity   [8]
	char visibility [8]
	char pressure  	[8]
	char rising  		[8]
}

struct _WeatherUnit
{
	char temperature[8];
	char distance[8];
	char pressure[8];
	char speed[8];
}

struct _WeatherFcst
{
	char high[5][8];
	char low[5][8];
	char text[5][64];
	char code[5][8];
	char refDay[5][8];
	char refDate[5][32];
}

define_variable
volatile _this this;

volatile _WeatherCond sWeatherCond;
volatile _WeatherUnit sWeatherUnit;
volatile _WeatherFcst sWeatherFcst;

define_variable

volatile char cRSSTrash [1000] ;
volatile char cRSStoText[10000]

volatile sinteger nHOUR_TIME;
volatile sinteger nHOUR_RISE;
volatile sinteger nHOUR_SET;

define_variable

volatile long refreshVal[] = {60000};

volatile integer fcstIdx = 1;
volatile integer dbg = 1;
volatile long tlDataRcvTimes[] = {150};

define_function print(integer LVL, char MSG[])
{
	stack_var integer thisLVL;
	stack_var char dbgMSG[256];
	
	thisLVL = LVL;
	
	if((dbg) && (thisLVL <= dbg))
	{
		switch(thisLVL)
		{
			case nDbg_Lvl1: dbgMSG = "'ERROR :: ' ,MSG";
			case nDbg_Lvl2: dbgMSG = "'WARN :: '  ,MSG";
			case nDbg_Lvl3: dbgMSG = "'DATA :: '  ,MSG";
			case nDbg_Lvl4: dbgMSG = "'INFO :: '  ,MSG";
		}
		send_string 0,"'Weather :: ',dbgMSG";
	}
}

define_function fnParseRcvData(char RCVDATA[])
{
	stack_var char str[256];
	stack_var char trsh[32];
	
	str = RCVDATA;
	
	if(find_string(str,'yweather:',1))
	{
		stack_var char ref[32];
		
		trsh = remove_string(str,':',1);
		ref = remove_string(str,"$20",1);
		set_length_string(ref,length_string(ref) - 1);
		
		switch(ref)
		{
			case 'wind': fnSetWindsInf(str);
			case 'units': fnSetUnitsInf(str);
			case 'location': fnSetLocalInf(str);
			case 'forecast': fnSetFcstInf(str);
			case 'astronomy': fnSetAstroInf(str);
			case 'condition': fnSetCondInf(str);
			case 'atmosphere': fnSetAtmsphInf(str);
		}
	}
	else if(find_string(str,'<lastBuildDate>',1))
	{
		trsh = remove_string(str,'<lastBuildDate>',1);
		
		this.buildDate = remove_string(str,'</',1);
		set_length_string(this.buildDate,length_string(this.buildDate) - 2);
	}
	else if(find_string(str,'<description>',1))
	{
	
	}
	else if(find_string(str,'<title>',1))
	{
	
	}
}

define_function fnSetLocalInf(char RCVDATA[])
{
	// city="Las Vegas" region="NV"   country="United States"/>
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'city',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.city = remove_string(str,'"',1);
			set_length_string(sWeatherCond.city,length_string(sWeatherCond.city) - 1);
		}
		if(find_string(tmp,'region',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.region = remove_string(str,'"',1);
			set_length_string(sWeatherCond.region,length_string(sWeatherCond.region) - 1);
		}
		if(find_string(tmp,'country',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.country = remove_string(str,'"',1);
			set_length_string(sWeatherCond.country,length_string(sWeatherCond.country) - 1);
		}
	}
}

define_function fnSetUnitsInf(char RCVDATA[])
{
	// temperature="F" distance="mi" pressure="in" speed="mph"/>
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'temperature',1))
		{
			remove_string(str,'"',1);
			sWeatherUnit.temperature = remove_string(str,'"',1);
			set_length_string(sWeatherUnit.temperature,length_string(sWeatherUnit.temperature) - 1);
		}
		if(find_string(tmp,'distance',1))
		{
			remove_string(str,'"',1);
			sWeatherUnit.distance = remove_string(str,'"',1);
			set_length_string(sWeatherUnit.distance,length_string(sWeatherUnit.distance) - 1);
		}
		if(find_string(tmp,'pressure',1))
		{
			remove_string(str,'"',1);
			sWeatherUnit.pressure = remove_string(str,'"',1);
			set_length_string(sWeatherUnit.pressure,length_string(sWeatherUnit.pressure) - 1);
		}
		if(find_string(tmp,'speed',1))
		{
			remove_string(str,'"',1);
			sWeatherUnit.speed = remove_string(str,'"',1);
			set_length_string(sWeatherUnit.speed,length_string(sWeatherUnit.speed) - 1);
		}
	}
}

define_function fnSetWindsInf(char RCVDATA[])
{
	//  chill="99"   direction="0"   speed="7" />
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'chill',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.chill = remove_string(str,'"',1);
			set_length_string(sWeatherCond.chill,length_string(sWeatherCond.chill) - 1);
		}
		if(find_string(tmp,'direction',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.direction = atoi(remove_string(str,'"',1));
		}
		if(find_string(tmp,'speed',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.speed = remove_string(str,'"',1);
			set_length_string(sWeatherCond.speed,length_string(sWeatherCond.speed) - 1);
		}
	}
}

define_function fnSetAtmsphInf(char RCVDATA[])
{
	// humidity="20"  visibility="10"  pressure="29.93"  rising="2" />
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'humidity',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.humidity = remove_string(str,'"',1);
			set_length_string(sWeatherCond.humidity,length_string(sWeatherCond.humidity) - 1);
		}
		if(find_string(tmp,'visibility',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.visibility = remove_string(str,'"',1);
			set_length_string(sWeatherCond.visibility,length_string(sWeatherCond.visibility) - 1);
		}
		if(find_string(tmp,'pressure',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.pressure = remove_string(str,'"',1);
			set_length_string(sWeatherCond.pressure,length_string(sWeatherCond.pressure) - 1);
		}
		if(find_string(tmp,'rising',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.rising = remove_string(str,'"',1);
			set_length_string(sWeatherCond.rising,length_string(sWeatherCond.rising) - 1);
		}
	}
}

define_function fnSetAstroInf(char RCVDATA[])
{
	// sunrise="6:01 am"   sunset="7:25 pm"/>
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'sunrise',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.sunrise = remove_string(str,'"',1);
			set_length_string(sWeatherCond.sunrise,length_string(sWeatherCond.sunrise) - 1);
		}
		if(find_string(tmp,'sunset',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.sunset = remove_string(str,'"',1);
			set_length_string(sWeatherCond.sunset,length_string(sWeatherCond.sunset) - 1);
		}
	}
}

define_function fnSetCondInf(char RCVDATA[])
{
	// text="Fair"  code="34"  temp="99"  date="Sun, 18 Aug 2013 12:53 pm PDT"
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'text',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.text = remove_string(str,'"',1);
			set_length_string(sWeatherCond.text,length_string(sWeatherCond.text) - 1);
		}
		if(find_string(tmp,'code',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.code = remove_string(str,'"',1);
			set_length_string(sWeatherCond.code,length_string(sWeatherCond.code) - 1);
		}
		if(find_string(tmp,'temp',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.temp = remove_string(str,'"',1);
			set_length_string(sWeatherCond.temp,length_string(sWeatherCond.temp) - 1);
		}
		if(find_string(tmp,'date',1))
		{
			remove_string(str,'"',1);
			sWeatherCond.refDate = remove_string(str,'"',1);
			set_length_string(sWeatherCond.refDate,length_string(sWeatherCond.refDate) - 1);
		}
	}
}

define_function fnSetFcstInf(char RCVDATA[])
{
	// day="Sun" date="18 Aug 2013" low="81" high="99" text="Mostly Cloudy" code="27" />
	stack_var char str[256];
	stack_var char tmp[32];
	
	str = RCVDATA;
	fcstIdx = (fcstIdx + 1);
	
	while(find_string(str,'=',1))
	{
		tmp = remove_string(str,'=',1);
		
		if(find_string(tmp,'day',1))
		{
			remove_string(str,'"',1);
			sWeatherFcst.refDay[fcstIdx] = remove_string(str,'"',1);
			set_length_string(sWeatherFcst.refDay[fcstIdx],length_string(sWeatherFcst.refDay[fcstIdx]) - 1);
		}
		if(find_string(tmp,'date',1))
		{
			remove_string(str,'"',1);
			sWeatherFcst.refDate[fcstIdx] = remove_string(str,'"',1);
			set_length_string(sWeatherFcst.refDate[fcstIdx],length_string(sWeatherFcst.refDate[fcstIdx]) - 1);
		}
		if(find_string(tmp,'low',1))
		{
			remove_string(str,'"',1);
			sWeatherFcst.low[fcstIdx] = remove_string(str,'"',1);
			set_length_string(sWeatherFcst.low[fcstIdx],length_string(sWeatherFcst.low[fcstIdx]) - 1);
		}
		if(find_string(tmp,'high',1))
		{
			remove_string(str,'"',1);
			sWeatherFcst.high[fcstIdx] = remove_string(str,'"',1);
			set_length_string(sWeatherFcst.high[fcstIdx],length_string(sWeatherFcst.high[fcstIdx]) - 1);
		}
		if(find_string(tmp,'text',1))
		{
			remove_string(str,'"',1);
			sWeatherFcst.text[fcstIdx] = remove_string(str,'"',1);
			set_length_string(sWeatherFcst.text[fcstIdx],length_string(sWeatherFcst.text[fcstIdx]) - 1);
		}
		if(find_string(tmp,'code',1))
		{
			remove_string(str,'"',1);
			sWeatherFcst.code[fcstIdx] = remove_string(str,'"',1);
			set_length_string(sWeatherFcst.code[fcstIdx],length_string(sWeatherFcst.code[fcstIdx]) - 1);
		}
	}
}

define_function fnUpdateUI()
{
	stack_var integer i;
	
	send_command dvTP,"'^TXT-',itoa(nUI_Wthr_Cntl[09]),',0,Last Update: ',this.buildDate";
	
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[01]),',0,',sWeatherCond.city,'-',sWeatherCond.region";
	send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[02]),',0,wthr_',sWeatherCond.code,'.png'";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[03]),',0,',sWeatherCond.temp,' ',$B0,'F'";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[04]),',0,',sWeatherFcst.high[1],' ',$B0,'F'";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[05]),',0,',sWeatherFcst.low[1],' ',$B0,'F'";
	
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[06]),',0,',sWeatherCond.text";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[07]),',0,',sWeatherCond.speed,' ',sWeatherUnit.speed";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[08]),',0,',sWeatherCond.humidity,'%'";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[09]),',0,',sWeatherCond.visibility,' ',sWeatherUnit.distance";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[10]),',0,',sWeatherCond.pressure,' ',sWeatherUnit.pressure";
	
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[11]),',0,',sWeatherCond.sunrise";
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[12]),',0,',sWeatherCond.sunset";
	
	send_command dvTP,"'^TXT-',itoa(nUI_Crnt_Cond[13]),',0,',sWeatherFcst.low[1],$B0";
	
	if((sWeatherCond.direction > 0) && (sWeatherCond.direction < 22))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_n.png'";
		sWeatherCond.windDir = 'North';
	}
	else if ((sWeatherCond.direction > 21) && (sWeatherCond.direction < 67))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_ne.png'";
		sWeatherCond.windDir = 'NorthEast';
	}
	else if ((sWeatherCond.direction > 66) && (sWeatherCond.direction < 112))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_e.png'";
		sWeatherCond.windDir = 'East';
	}
	else if ((sWeatherCond.direction > 111) && (sWeatherCond.direction < 157))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_se.png'";
		sWeatherCond.windDir = 'SouthEast';
	}
	else if ((sWeatherCond.direction > 156) && (sWeatherCond.direction < 202))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_s.png'";
		sWeatherCond.windDir = 'South';
	}
	else if ((sWeatherCond.direction > 201) && (sWeatherCond.direction < 247))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_sw.png'";
		sWeatherCond.windDir = 'SouthWest';
	}
	else if ((sWeatherCond.direction > 246) && (sWeatherCond.direction < 292))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_w.png'";
		sWeatherCond.windDir = 'West';
	}
	else if ((sWeatherCond.direction > 291) && (sWeatherCond.direction < 337))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_nw.png'";
		sWeatherCond.windDir = 'NorthWest';
	}
	else if ((sWeatherCond.direction > 336) && (sWeatherCond.direction <= 360))
	{
		send_command dvTP,"'^BMP-',itoa(nUI_Crnt_Cond[14]),',0,compass_n.png'";
		sWeatherCond.windDir = 'North';
	}
	else
	{
		sWeatherCond.windDir = 'Unknown';
	}
	
	for(i = 1; i <= 5; i++)
	{
		send_command dvTP,"'^TXT-',itoa(nUI_Fcst_WDay[i]),',0,',sWeatherFcst.refDay[i]";
		send_command dvTP,"'^BMP-',itoa(nUI_Fcst_Icon[i]),',0,wthr_sml_',sWeatherFcst.code[i],'.png'";
		send_command dvTP,"'^TXT-',itoa(nUI_Fcst_Text[i]),',0,',sWeatherFcst.text[i]";
		send_command dvTP,"'^TXT-',itoa(nUI_Fcst_High[i]),',0,',sWeatherFcst.high[i],' ',$B0,'F'";
		send_command dvTP,"'^TXT-',itoa(nUI_Fcst_Lows[i]),',0,',sWeatherFcst.low[i],' ',$B0,'F'";
	}
	
	wait 10 'close_pp_update'
	{
		send_command dvTP,"'@PPF-pp_weather_update;',this.page";
	}
}

define_function char fnConnectAPI(char ifromWhere [])
{
	print(nDbg_Lvl4,"'Time ',Time,' - Updating RSS Weather! From: *-',ifromWhere,'-* line-<',itoa(__LINE__),'>',crlf");
	ip_client_open (dvAPI.Port,'weather.yahooapis.com',80,1) ;//ok for rss/xml and html //
	
	send_command dvTP,"'@PPN-pp_weather_update;',this.page";
	return true;
}

define_function fnUpdateComm()
{
	send_string vdvAPI,"'CONDITION-',sWeatherCond.text";
	send_string vdvAPI,"'TEMPERATURE-',sWeatherCond.temp";
	send_string vdvAPI,"'WIND_SPEED-',sWeatherCond.speed";
	send_string vdvAPI,"'WIND_DEGREES-',itoa(sWeatherCond.direction)";
	send_string vdvAPI,"'WIND_DIRECTION-',sWeatherCond.windDir";
	send_string vdvAPI,"'HUMIDITY-',sWeatherCond.humidity";
	send_string vdvAPI,"'PRESSURE-',sWeatherCond.pressure";
	send_string vdvAPI,"'VISIBILITY-',sWeatherCond.visibility";
	send_string vdvAPI,"'FINISH'";
}

define_function char fnGetRSS()
{
	fcstIdx = 0;
	
	print(nDbg_Lvl4,"'RSS Connected! line-<',itoa(__LINE__),'>',crlf");
	
	send_string dvAPI,"'GET /forecastrss?w=',this.location,'&u=f HTTP/1.0',crlf,'Host: weather.yahooapis.com',crlf,'Accept: */*',crlf,crlf";
	
	print(nDbg_Lvl4,"'RSS Get Request Sent! line-<',itoa(__LINE__),'>',crlf");

	return true;
}

define_start
{
	create_buffer dvAPI, this.buffer; 
	
	this.page = 'Weather';
	wait 1200
	{
		this.sysRunning = true;
	}
}

define_event

data_event[dvTP]
{
	online:
	{
		if(this.sysRunning == true)
		{
			fnUpdateUI();
		}
	}
}

data_event[dvAPI]
{
	online:
	{
	  fnGetRSS()
	}
	string:
	{
		this.PrtActive = true;
	}
	offline:
	{
		print(nDbg_Lvl4,"'API server disconnected! line-<',itoa(__LINE__),'>'");
		
		if(length_string(this.buffer) > 0)
		{
			print(nDbg_Lvl4,"'API Buffer Has Data! line-<',itoa(__LINE__),'>'");
			if(timeline_active(tlDataRcv))
			{
			
			}
			else
			{
				timeline_create(tlDataRcv,tlDataRcvTimes,length_array(tlDataRcvTimes),timeline_relative,timeline_repeat);
			}
		}
		else
		{
			print(nDbg_Lvl2,"'API Buffer Has NO DATA! line-<',itoa(__LINE__),'>'");
		}
	}
	OnError:
	{
		print(nDbg_Lvl1,"'API status code: ',itoa(DATA.NUMBER),' line-<',itoa(__LINE__),'>'");
	}
}

data_event[vdvAPI]
{
	online:
	{
		if (RfshTime > 60)
		{
			refreshVal[1] = (RfshTime * 60000) ;
		}
		else 
		{
			refreshVal[1] = (REFRESH_TIME * 60000) ;
		}
	}
	command:
	{
		stack_var char CmdRcv[64];
		stack_var char cFUNC[16];
		
		CmdRcv = data.text;
		
		print(nDbg_Lvl3,CmdRcv);
		
		if(find_string(CmdRcv,"';'",1))
		{
			set_length_string(CmdRcv,length_string(CmdRcv) - 1);
		}
		
		if(find_string(CmdRcv,"'-'",1))
		{
			cFUNC = remove_string(CmdRcv,'-',1);
			set_length_string(cFUNC,length_string(cFUNC) - 1);
		}
		else
		{
			cFUNC = CmdRcv;
		}
		
		switch(cFUNC)
		{
			case 'PASSBACK':{}
			case 'LOCATION':
			{
				this.location = CmdRcv;
			}
			case 'WEATHERSCALE':
			{
				this.weatherscale = CmdRcv;
			}
			case 'REFRESH':
			{
				stack_var integer val;
				
				val = atoi(CmdRcv);
				
				refreshVal[1] = (val * 60000) ;
			}
			case 'REINIT':
			{
				fnConnectAPI('Event :: REINIT');
				
				if(timeline_active(tlUpdate))
				{
					timeline_kill(tlUpdate);
				}
				
				timeline_create(tlUpdate, refreshVal, length_array(refreshVal), timeline_relative, timeline_repeat); 
			}
			case 'DEBUG':
			{
				dbg = atoi(CmdRcv);
				print(dbg,"'Setting Debug To ',itoa(dbg)");
			}
			default:{}
		}
	}
}

define_event

button_event[dvTP, nUI_Wthr_Cntl]
{
	push:
	{
		stack_var integer idx;
	  idx = get_last(nUI_Wthr_Cntl)
	  switch (idx)
		{
			case 1:
			{
		    fnConnectAPI('Manual Update') ;
		    break;
			}
			case 2:
			{
				//add button functions as needed
		    break ;
			}
		}
	}
}

define_event

timeline_event[tlUpdate]
{
	fnConnectAPI('TimeLine_Event') ;
}

timeline_event[tlDataRcv]
{
	if(find_string(this.buffer,"$0A",1))
	{
		stack_var char thisDATA[10000];
		stack_var char trash[16];
		
		if(find_string(this.buffer,"$0D,$0A",1))
		{
			thisDATA = remove_string(this.buffer,"$0D,$0A",1);
			set_length_string(thisDATA,length_string(thisDATA) - 2);
		}
		else if(find_string(this.buffer,"$0A",1))
		{
			thisDATA = remove_string(this.buffer,"$0A",1);
			set_length_string(thisDATA,length_string(thisDATA) - 1);
		}
		
		print(nDbg_Lvl3,"'Sending To fnParseRcvData() -> ',thisDATA");
		
		fnParseRcvData(thisDATA);
	}
	else
	{
		timeline_kill(tlDataRcv);
		
		print(nDbg_Lvl4,"'Timeline "tlDataRcv" Has Terminated'");
		
		clear_buffer this.buffer;
		fnUpdateUI();
	}
}

define_program
