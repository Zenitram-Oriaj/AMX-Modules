program_name = 'stdio'
(***********************************************************)
(*  FILE CREATED ON: 10/10/2013  AT: 11:07:26              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/07/2014  AT: 07:56:16        *)
(***********************************************************)

/*



*/

define_constant	// Debug Levels - Constants

integer nDbg_Lvl1 = 1;	// Error Mesaages Only
integer nDbg_Lvl2 = 2;	// Error & Warning Mesaages Only
integer nDbg_Lvl3 = 3;	// Error, Warning, & Data Received Mesaages Only
integer nDbg_Lvl4 = 4;	// All Messages 

define_constant	// Modules - Feedback Channels

integer mod_Online = 255;
integer mod_DatRcv = 254;
integer mod_Error  = 253;
integer mod_AMute  = 252;
integer mod_PwrOn  = 250;
integer mod_Busy	 = 251;

#if_defined TYPE_DSP
integer mod_AtcOn  = 251;
#end_if

#if_defined TYPE_PRJ
integer mod_Lmp1Lw = 241;
integer mod_Lmp2Lw = 242;
integer mod_Warmng = 249;
integer mod_Coolng = 251;
integer mod_VMute  = 252;
#end_if

define_constant	// 

long tlSysMntr			= 01;	// System Monitor Timeline

define_constant	//

char cr		 	= $0D;
char crlf[]	= {$0D,$0A};

char ack   	= $06;
char nack  	= $15;

char null[] = '';

define_constant	// Modules - Control Channels

integer _sys_ion		= 01;	// System On
integer _sys_prp		= 02;	// Prep System
integer _sys_cs1		= 03;	// Custom Event 01
integer _sys_cs2		= 04;	// Custom Event 02
integer _sys_cs3		= 05;	// Custom Event 03
integer _sys_vup		= 06;	// Volume Up
integer _sys_vdn		= 07;	// Volume Down
integer _sys_amt		= 08;	// Audio Mute
integer _sys_off		= 09;	// Sustem Off
integer _sys_cof		= 10;	// Custom Off

integer _pwr_ion		= 01; //
integer _pwr_off		= 02; //

integer _inp_rgb		= 01;
integer _inp_dvi		= 02;
integer _inp_hdm		= 03;
integer _inp_ybr		= 04;
integer _inp_vid		= 05;
integer _inp_svd		= 06;

integer _vol_inc		= 18;
integer _vol_dec		= 19;

integer _mut_ion 		= 13;
integer _mut_off 		= 14;

integer _svr_ion		= 21;
integer _svr_off		= 22;

define_constant

integer nComTypeIP = 01;
integer nComTypeRS = 02;

define_constant	// Level Constants

integer volm = 01;

define_constant	// 

integer Sys_Ctrl_Btns[] =
{
	001,002,003,004,005,006,007,008,009,010,
	011,012,013,014,015,016,017,018,019,020,
	021,022,023,024,025,026,027,028,029,030,
	031,032,033,034,035,036,037,038,039,040,
	041,042,043,044,045,046,047,048,049,050,
	051,052,053,054,055,056,057,058,059,060,
	061,062,063,064,065,066,067,068,069,070,
	071,072,073,074,075,076,077,078,079,080,
	081,082,083,084,085,086,087,088,089,090,
	091,092,093,094,095,096,097,098,099,100,
	101,102,103,104,105,106,107,108,109,110,
	111,112,113,114,115,116,117,118,119,120,
	121,122,123,124,125,126,127,128,129,130,
	131,132,133,134,135,136,137,138,139,140,
	141,142,143,144,145,146,147,148,149,150,
	151,152,153,154,155,156,157,158,159,160,
	161,162,163,164,165,166,167,168,169,170,
	171,172,173,174,175,176,177,178,179,180,
	181,182,183,184,185,186,187,188,189,190,
	191,192,193,194,195,196,197,198,199,200
}

define_constant	// 

char HexArray[][3] =
{
	'$00','$01','$02','$03','$04','$05','$06','$07',
	'$08','$09','$0A','$0B','$0C','$0D','$0E','$0F',
	'$10','$11','$12','$13','$14','$15','$16','$17',
	'$18','$19','$1A','$1B','$1C','$1D','$1E','$1F',
	'$20','$21','$22','$23','$24','$25','$26','$27',
	'$28','$29','$2A','$2B','$2C','$2D','$2E','$2F',
	'$30','$31','$32','$33','$34','$35','$36','$37',
	'$38','$39','$3A','$3B','$3C','$3D','$3E','$3F',
	'$40','$41','$42','$43','$44','$45','$46','$47',
	'$48','$49','$4A','$4B','$4C','$4D','$4E','$4F',
	'$50','$51','$52','$53','$54','$55','$56','$57',
	'$58','$59','$5A','$5B','$5C','$5D','$5E','$5F',
	'$60','$61','$62','$63','$64','$65','$66','$67',
	'$68','$69','$6A','$6B','$6C','$6D','$6E','$6F',
	'$70','$71','$72','$73','$74','$75','$76','$77',
	'$78','$79','$7A','$7B','$7C','$7D','$7E','$7F',
	'$80','$81','$82','$83','$84','$85','$86','$87',
	'$88','$89','$8A','$8B','$8C','$8D','$8E','$8F',
	'$90','$91','$92','$93','$94','$95','$96','$97',
	'$98','$99','$9A','$9B','$9C','$9D','$9E','$9F',
	'$A0','$A1','$A2','$A3','$A4','$A5','$A6','$A7',
	'$A8','$A9','$AA','$AB','$AC','$AD','$AE','$AF',
	'$B0','$B1','$B2','$B3','$B4','$B5','$B6','$B7',
	'$B8','$B9','$BA','$BB','$BC','$BD','$BE','$BF',
	'$C0','$C1','$C2','$C3','$C4','$C5','$C6','$C7',
	'$C8','$C9','$CA','$CB','$CC','$CD','$CE','$CF',
	'$D0','$D1','$D2','$D3','$D4','$D5','$D6','$D7',
	'$D8','$D9','$DA','$DB','$DC','$DD','$DE','$DF',
	'$E0','$E1','$E2','$E3','$E4','$E5','$E6','$E7',
	'$E8','$E9','$EA','$EB','$EC','$ED','$EE','$EF',
	'$F0','$F1','$F2','$F3','$F4','$F5','$F6','$F7',
	'$F8','$F9','$FA','$FB','$FC','$FD','$FE','$FF'
}

define_type

struct _this
{
	char name[32];
	dev devinf;
}

define_variable

volatile _this this;
volatile integer dbg = nDbg_Lvl4;

define_variable // System Boolean Variables

volatile char bSysNotify;	// If An E-Mail Has Been Sent Or Not
volatile char bSysActive;	// They System Is Now Being Used By The End User
volatile char bSysOnline;	// The Master Is Fully Booted And The System Is All Good
volatile char bAutoShtDn;	// Call The Auto Shutdown.
volatile char bSeqActive;	// If System Sequencing Mode Is Active

define_variable

#if_not_defined IPAddress
volatile char IPAddress[16];
#end_if

volatile integer nComType;
volatile integer pollTime = 300;

define_variable // Timeline - Timing Arrays

constant long tlStdTimes[] = // 10 Seconds Total Time
{
	500,500,500,500,500,500,500,500,500,500,
	500,500,500,500,500,500,500,500,500,500
}

define_function print(integer DBGLVL, char MSG[])
{
	stack_var integer lvl;
	stack_var char str[1024];

	lvl = DBGLVL;
	str = MSG;

	if((dbg) && (lvl <= dbg))
	{
		switch(lvl)
		{
			case nDbg_Lvl1: str = "'ERROR :: ' ,str";
			case nDbg_Lvl2: str = "'WARN :: '  ,str";
			case nDbg_Lvl3: str = "'DATA :: '  ,str";
			case nDbg_Lvl4: str = "'INFO :: '  ,str";
		}
		
		if(length_string(str) <= 128)
		{
			send_string 0,"this.name,' :: ',str";
		}
		else
		{
			stack_var tstr[128];
			
			tstr = str;
			
			while(length_string(str) > 128)
			{
				tstr = get_buffer_string(str,128);
				send_string 0,"this.name,' :: ',tstr";
			}
			
			send_string 0,"this.name,' :: ',tstr";
		}
	}
}

define_function println(integer DBGLVL, char MSG[])
{
	stack_var integer lvl;
	stack_var char str[255];

	lvl = DBGLVL;
	str = MSG;

	if((dbg) && (lvl <= dbg))
	{
		switch(lvl)
		{
			case nDbg_Lvl1: str = "'ERROR :: ' ,str";
			case nDbg_Lvl2: str = "'WARN :: '  ,str";
			case nDbg_Lvl3: str = "'DATA :: '  ,str";
			case nDbg_Lvl4: str = "'INFO :: '  ,str";
		}
		send_string 0,"this.name,' :: ',str";
	}
}

define_function char ChkSumCal(char SNDCMD[])
{
	stack_var char str[64];
	stack_var integer lngth;
	stack_var integer i;
	stack_var integer sum;
	stack_var char val;
	
	lngth = length_string(SNDCMD);
	str = SNDCMD;
	sum = 0;
	
	for(i = 1; i <= lngth; i++)
	{
		sum = (sum + type_cast(str[i]));
	}
	
	val = type_cast(sum);
	
	return val;
}

define_function char[255] formatHex(char REFDATA[])
{
	stack_var integer lngth;
	stack_var integer i;
	stack_var integer j;
	
	stack_var char str[255];
	
	lngth = length_string(REFDATA);
	
	for(i = 1; i <= lngth; i++)
	{
		j = (1 + type_cast(get_buffer_string(REFDATA,1)));
		str = "str,HexArray[j]";
		
		if(i < lngth)
		{
			str = "str,','";
		}
	}
	
	return str;
}

define_function float formatTemp(float VAL)
{
	stack_var float xC;
	stack_var float xF;
	stack_var float xJ
	
	xJ = VAL;
	
	xC = (xJ / 10);
	
	xF = (1.8 * xC) + 32;
	
	return xF;
}

define_function char[20] dpstoa(dev device)
{
	return "itoa(device.number),':',itoa(device.port),':',itoa(device.system)"
}

define_function integer StringMatch(char strSTR1[],char strSTR2[])
{
  stack_var integer nI;
	stack_var integer nMIN;
	stack_var integer	nMAX;
	stack_var integer nSAMECOUNT;
	
  stack_var double dRESULT;
	stack_var double dSAME;
	stack_var double dMAX;

  nMAX = max_value(length_string(strSTR1), length_string(strSTR2));
  nMIN = min_value(length_string(strSTR1), length_string(strSTR2));
  
  nSAMECOUNT = 0
	
	for(nI = 1; nI <= nMAX; nI++)
  {
    if(nI > nMIN)
		{
			break;
		}
		
		if (strSTR1[nI] = strSTR2[nI])
		{
			nSAMECOUNT++;
		}
	}
    
	dMAX = nMAX
	dSAME = nSAMECOUNT
	
	if(nSAMECOUNT)
	{
		dRESULT = (dSAME / dMAX) * 100;
	}
	else
	{
		dRESULT = 0;
	}
	
	return atoi(format('%-9.0f', dRESULT));
}

define_function sinteger SignedAdjustFrom255(integer nArgValue,sinteger siArgMinimum,sinteger siArgMaximum) 
{
	stack_var sinteger siMyValue;
	stack_var sinteger newValue;
	
	siMyValue = type_cast(nArgValue)

	newValue = ((siMyValue * (siArgMaximum - siArgMinimum)) / 255) + siArgMinimum;
	
	return newValue;
}