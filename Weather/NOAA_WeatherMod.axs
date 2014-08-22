module_name = 'NOAA_WeatherMod' 
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/11/2013  AT: 12:26:04        *)
(***********************************************************)
( 
	dev dvAPI,
	dev vdvAPI
)

/*

http://w1.weather.gov/xml/current_obs/KLAS.xml

<?xml version="1.0" encoding="ISO-8859-1"?> 
<?xml-stylesheet href="latest_ob.xsl" type="text/xsl"?>
<current_observation version="1.0"
	 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 xsi:noNamespaceSchemaLocation="http://www.weather.gov/view/current_observation.xsd">
	<credit>NOAA's National Weather Service</credit>
	<credit_URL>http://weather.gov/</credit_URL>
	<image>
		<url>http://weather.gov/images/xml_logo.gif</url>
		<title>NOAA's National Weather Service</title>
		<link>http://weather.gov</link>
	</image>
	<suggested_pickup>15 minutes after the hour</suggested_pickup>
	<suggested_pickup_period>60</suggested_pickup_period>
	<location>Las Vegas/Mccarran, NV</location>
	<station_id>KLAS</station_id>
	<latitude>36.0789</latitude>
	<longitude>-115.155</longitude>
	<observation_time>Last Updated on Aug 23 2013, 6:56 pm PDT</observation_time>
        <observation_time_rfc822>Fri, 23 Aug 2013 18:56:00 -0700</observation_time_rfc822>
	<weather>Mostly Cloudy</weather>
	<temperature_string>83.0 F (28.3 C)</temperature_string>
	<temp_f>83.0</temp_f>
	<temp_c>28.3</temp_c>
	<relative_humidity>43</relative_humidity>
	<wind_string>Southwest at 10.4 MPH (9 KT)</wind_string>
	<wind_dir>Southwest</wind_dir>
	<wind_degrees>210</wind_degrees>
	<wind_mph>10.4</wind_mph>
	<wind_kt>9</wind_kt>
	<pressure_string>1005.8 mb</pressure_string>
	<pressure_mb>1005.8</pressure_mb>
	<pressure_in>29.78</pressure_in>
	<dewpoint_string>57.9 F (14.4 C)</dewpoint_string>
	<dewpoint_f>57.9</dewpoint_f>
	<dewpoint_c>14.4</dewpoint_c>
	<heat_index_string>83 F (28 C)</heat_index_string>
      	<heat_index_f>83</heat_index_f>
      	<heat_index_c>28</heat_index_c>
	<visibility_mi>10.00</visibility_mi>
 	<icon_url_base>http://forecast.weather.gov/images/wtf/small/</icon_url_base>
	<two_day_history_url>http://www.weather.gov/data/obhistory/KLAS.html</two_day_history_url>
	<icon_url_name>bkn.png</icon_url_name>
	<ob_url>http://www.weather.gov/data/METAR/KLAS.1.txt</ob_url>
	<disclaimer_url>http://weather.gov/disclaimer.html</disclaimer_url>
	<copyright_url>http://weather.gov/disclaimer.html</copyright_url>
	<privacy_policy_url>http://weather.gov/notice.html</privacy_policy_url>
</current_observation>

*/

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

define_type

struct _this
{
	char buffer[65535];
	
	integer PrtOnline;
	integer PrtActive;
	
	slong	PrtError;
	slong PrtRetry;
	
	integer devNum;
	integer devPrt;
	
	char sysRunning;
	
	char location[16];
	char latitude[8];
	char longitude[8];
	char weatherscale[16];
	char provider[32];
	
	char buildDate[32];
}

struct _WeatherCond
{
	char text[32]
	char temp [8]
	char refDate [64]
	
	char windText[32];
	char windDir[16];
	integer direction
	char dewpoint   [8]
	char heatindex	[8]
	char speed  [8]
	
	char humidity   [8]
	char visibility [8]
	char pressure  	[8]
}

define_variable
volatile _this this;

volatile _WeatherCond sWeatherCond;

define_variable

volatile long refreshVal[] = {60000};

volatile integer fcstIdx = 1;
volatile integer dbg = 1;
volatile long tlDataRcvTimes[] = {250};

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
	stack_var char str[1024];
	stack_var char trsh[32];
	
	str = RCVDATA;
	
	if(find_string(str,'<observation_time>',1))
	{
		trsh = remove_string(str,'<observation_time>',1);
		
		sWeatherCond.refDate = remove_string(str,'</',1);
		set_length_string(sWeatherCond.refDate,length_string(sWeatherCond.refDate) - 2);
	}
	else if(find_string(str,'<weather>',1))
	{
		trsh = remove_string(str,'<weather>',1);
		
		sWeatherCond.text = remove_string(str,'</',1);
		set_length_string(sWeatherCond.text,length_string(sWeatherCond.text) - 2);
	}
	else if(find_string(str,'<credit>',1))
	{
		trsh = remove_string(str,'<credit>',1);
		
		this.provider = remove_string(str,'</',1);
		set_length_string(this.provider,length_string(this.provider) - 2);
	}
	else if(find_string(str,'<temp_f>',1))
	{
		trsh = remove_string(str,'<temp_f>',1);
		
		sWeatherCond.temp = remove_string(str,'</',1);
		set_length_string(sWeatherCond.temp,length_string(sWeatherCond.temp) - 2);
	}
	else if(find_string(str,'<heat_index_f>',1))
	{
		trsh = remove_string(str,'<heat_index_f>',1);
		
		sWeatherCond.heatindex = remove_string(str,'</',1);
		set_length_string(sWeatherCond.heatindex,length_string(sWeatherCond.heatindex) - 2);
	}
	else if(find_string(str,'<dewpoint_f>',1))
	{
		trsh = remove_string(str,'<dewpoint_f>',1);
		
		sWeatherCond.dewpoint = remove_string(str,'</',1);
		set_length_string(sWeatherCond.dewpoint,length_string(sWeatherCond.dewpoint) - 2);
	}
	else if(find_string(str,'<relative_humidity>',1))
	{
		trsh = remove_string(str,'<relative_humidity>',1);
		
		sWeatherCond.humidity = remove_string(str,'</',1);
		set_length_string(sWeatherCond.humidity,length_string(sWeatherCond.humidity) - 2);
	}
	else if(find_string(str,'<wind_string>',1))
	{
		trsh = remove_string(str,'<wind_string>',1);
		
		sWeatherCond.windText = remove_string(str,'</',1);
		set_length_string(sWeatherCond.windText,length_string(sWeatherCond.windText) - 2);
	}
	else if(find_string(str,'<wind_dir>',1))
	{
		trsh = remove_string(str,'<wind_dir>',1);
		
		sWeatherCond.windDir = remove_string(str,'</',1);
		set_length_string(sWeatherCond.windDir,length_string(sWeatherCond.windDir) - 2);
	}
	else if(find_string(str,'<wind_degrees>',1))
	{
		trsh = remove_string(str,'<wind_degrees>',1);
		
		sWeatherCond.direction = atoi(remove_string(str,'</',1));
	}
	else if(find_string(str,'<wind_mph>',1))
	{
		trsh = remove_string(str,'<wind_mph>',1);
		
		sWeatherCond.speed = remove_string(str,'</',1);
		set_length_string(sWeatherCond.speed,length_string(sWeatherCond.speed) - 2);
	}
	else if(find_string(str,'<pressure_in>',1))
	{
		trsh = remove_string(str,'<pressure_in>',1);
		
		sWeatherCond.pressure = remove_string(str,'</',1);
		set_length_string(sWeatherCond.pressure,length_string(sWeatherCond.pressure) - 2);
	}
	else if(find_string(str,'<visibility_mi>',1))
	{
		trsh = remove_string(str,'<visibility_mi>',1);
		
		sWeatherCond.visibility = remove_string(str,'</',1);
		set_length_string(sWeatherCond.visibility,length_string(sWeatherCond.visibility) - 2);
	}
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
	send_string vdvAPI,"'HEAT_INDEX-',sWeatherCond.heatindex";
	send_string vdvAPI,"'DEW_POINT-',sWeatherCond.dewpoint";
	send_string vdvAPI,"'FINISH'";
}

define_function fnCommErrorChk (slong VAL)
{
	stack_var slong ofType;
	stack_var char errMsg[32];
	
	ofType = VAL;
	
	switch(ofType)
	{
		case 02: errMsg = 'General failure (out of memory)';
		case 04: errMsg = 'Unknown Host';
		case 06: errMsg = 'Connection refused';
		case 07: errMsg = 'Connection timed out';
		case 08: errMsg = 'Unknown connection error';
		case 09: errMsg = 'Already closed';
		case 14: errMsg = 'Local port already used';
		case 16: errMsg = 'Too many open sockets';
		case 17: errMsg = 'Local Port Not Open';
		default: 
		{
			errMsg = "'No Case Found For ',itoa(type_cast(ofType))";
		}
	}
	
	print(nDbg_Lvl1, "'fnCommErrorChk() :: ',errMsg");
}

define_function char fnConnectAPI(char ifromWhere [])
{
	fnResetStored();
	print(nDbg_Lvl4,"'Time ',Time,' - Updating RSS Weather! From: *-',ifromWhere,'-* line-<',itoa(__LINE__),'>',crlf");
	ip_client_open (dvAPI.Port,'w1.weather.gov',80,1);

	return true;
}

define_function char fnGetRSS()
{
	fcstIdx = 0;
	
	print(nDbg_Lvl4,"'RSS Connected! line-<',itoa(__LINE__),'>',crlf");
	
	send_string dvAPI,"'GET /xml/current_obs/',this.location,'.xml HTTP/1.0',crlf,'Host: w1.weather.gov',crlf,'Accept: */*',crlf,crlf";
	
	//,'&u=f'
	
	print(nDbg_Lvl4,"'RSS Get Request Sent! line-<',itoa(__LINE__),'>',crlf");

	return true;
}

define_function char fnResetStored ()          
{
	sWeatherCond.text = 'UNKNOWN';
	sWeatherCond.temp = '00';
	sWeatherCond.speed = '0.0';
	sWeatherCond.direction = 000;
	sWeatherCond.windDir = 'UNKNOWN';
	sWeatherCond.humidity = '00';
	sWeatherCond.pressure = '00.00';
	sWeatherCond.visibility = '00';
	sWeatherCond.heatindex = '00';
	sWeatherCond.dewpoint = '00';
	
	return true ;
}

define_start
{
	create_buffer dvAPI, this.buffer; 
	
	wait 1200
	{
		this.sysRunning = true;
	}
}

define_event

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
	onerror:
	{
		fnCommErrorChk(type_cast(data.number));
	}
}

data_event[vdvAPI]
{
	online:
	{
		refreshVal[1] = (REFRESH_TIME * 60000) ;
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

button_event[vdvAPI, nUI_Wthr_Cntl]
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
	if(find_string(this.buffer,'</',1))
	{
		stack_var char thisDATA[1024];
		
		thisDATA = remove_string(this.buffer,'</',1);
		
		print(nDbg_Lvl3,"'Sending To fnParseRcvData() -> ',thisDATA");
		
		fnParseRcvData(thisDATA);
	}
	else
	{
		timeline_kill(tlDataRcv);
		
		print(nDbg_Lvl4,"'Timeline "tlDataRcv" Has Terminated'");
		
		clear_buffer this.buffer;
		fnUpdateComm();
	}
}

define_program




