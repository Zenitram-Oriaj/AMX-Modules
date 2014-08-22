module_name = 'Yamaha_YSPxx_Comm'
(
	dev vdvYSP,
	dev dvYSP
)

(***********************************************************)
(*  FILE CREATED ON: 09/21/2010  AT: 10:21:51              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 08/22/2014  AT: 12:23:02        *)
(***********************************************************)

/*

YSP-4100
$12G0113F96 @E01900	000302FF00 1100037010000000021102929232D2DFFFF28282814000F0F0F064002502040100110111E142011110001000511100FF00000A36363136191B142424212411120000034$03

$02002000$03
$12G0113F0A @E01900 010D3 $03


YSP-4000
$12G0079D93 @E01900 01200C300040100001818130202A2A222D2D280000222A2A282A2A222A2A28282828285A011411E1410000144050005050505181818181800000050505050010101000010E2$03

YSP-1100
$12G0064B7B	@E01900	01301D100040100001818030202A2A222D2D280000222A2A282A2A222A2A28000028285A011411E1410000144050002020303181818181800000C1$03


$12G0079D93@E01900

[20:1:1301]-	$02-002000-$03		$12 G0 11 3E 0A @E 01 90 00 20 D3 $03
[22:1:1301]-	$02-602000-$01		$12 G0 11 3E 0A @E 01 90 00 00 D1 $03
[21:2:1301]-	$02-602000-$03		$12 G0 11 3E 0A @E 01 90 00 10 D2 $03
[20:2:1301]-	$02-602000-$03		$12 G0 11 3E 0A @E 01 90 00 00 D1 $03
[22:2:1301]-	$02-602000-$03		$12 G0 11 3E 0A @E 01 90 00 20 D3 $03
[21:1:1301]-	$02-602000-$03		$12 G0 11 3E 0A @E 01 90 00 20 D3 $03

///////////////////////////////////////////////////////////////////////



[23:2:1301]-[$02$02-30100B-$03 $02-30110F-$03]

[23:2:1301]-[													$02-30-12-10-$03]
[20:2:1301]-[$02	$02-30-11-0F-$03		$02-30-12-10-$03]
[21:2:1301]-[$02	$02-30-11-0F-$03		$02-30-12-10-$03]
[21:1:1301]-[$02	$02-30-11-0F-$03		$02-30-12-10-$03]
[20:1:1301]-[$02	$02-30-11-0F-$03		$02-30-12-10-$03]

[23:2:1301]-[$02301003$03]
[23:2:1301]-[$02301100$03]
[23:2:1301]-[$02301202$03]
[20:2:1301]-[$02301100$03]
[20:2:1301]-[$02301202$03]

[22:1:1301]-[$02	$02-30-11-0F-$03	$02-30-12-10-$03]
[21:2:1301]-[$02301100$03]
[21:2:1301]-[$02301202$03]
[21:1:1301]-[$02301100$03]
[21:1:1301]-[$02301202$03]
[20:1:1301]-[$02301100$03]
[20:1:1301]-[$02301202$03]
[22:1:1301]-[$02301100$03]
[22:1:1301]-[$02301202$03]
[22:2:1301]-[$02$0230110F$03$02301210$03]
[22:2:1301]-[$02301100$03]
[22:2:1301]-[$02301202$03]

*/

#include 'stdio.axi';

define_constant	// Timeline Constants

long tlInfoQue = 23;
long tlDataRcv = 24;
long tlIntSets = 26;
long tlSndRTry = 27;

define_constant

integer nVolume = 1;

define_constant

char cmd_hdr	= $02;
char cmd_ftr	= $03;

char cmd_get_all[] = {$11,$00,$00,$00,$03};

char cmd_set_fbk[] = '80000';	// Tell The Device To Report Data
char cmd_set_dly[] = '80100';	// Set The Delay Between Recieved Commands To 0ms

char cmd_lst_inp[] = '86001';	// Set Input Mode To "Last Input"

char cmd_pwr_ion[] = '0787E';	// Select Power On Command
char cmd_pwr_off[] = '0787F';	// Select Power Off Command

char cmd_inp_tva[] = '078DF'; // Select Input TV
char cmd_inp_ax1[] = '07849'; // Select Input Aux 1
char cmd_inp_dvd[] = '0784A'; // Select Input DVD
char cmd_inp_dab[] = '0784B'; // Select Input DAB
char cmd_inp_ax3[] = '078BC'; // Select Input Aux 3
char cmd_inp_ax2[] = '078DE'; // Select Input Aux 2
char cmd_inp_fma[] = '078B6'; // Select Input FM
char cmd_inp_xma[] = '0787D'; // Select Input XM

char cmd_inp_hm4[] = '07841'; // Select Input HDMI 4
char cmd_inp_hm1[] = '0784A';


char cmd_aud_vup[] = '0781E';	// Select Volume Up
char cmd_aud_vdn[] = '0781F';	// Select Volume Down

char cmd_vmt_ion[] = '07EA2';	// Select Volume Mute On
char cmd_vmt_off[] = '07EA3';	// Select Volume Mute Off

char cmd_srs_dep[] = '0786E';	// Select SRS TrueBass Deep
char cmd_srs_mid[] = '0786D';	// Select SRS TrueBass Mid
char cmd_srs_off[] = '0786F';	// Select SRS TrueBass Off

char cmd_dsp_md1[] = '07EF9';	// DSP Mode Spectacle
char cmd_dsp_md2[] = '07EFA';	// DSP Mode Sci-Fi
char cmd_dsp_md3[] = '07EFB';	// DSP Mode Adventure
char cmd_dsp_md4[] = '07EE1';	// DSP Mode Concert Hall
char cmd_dsp_md5[] = '07EEC';	// DSP Mode Jazz Club
char cmd_dsp_md6[] = '07EF3';	// DSP Mode Music Video
char cmd_dsp_md7[] = '07EF8';	// DSP Mode Sports
char cmd_dsp_off[] = '0789B';	// DSP Mode OFF

define_constant	// Device Control Button Array

integer nDev_Ctrl_Btns[] =
{
	001,002,003,004,005,006,007,008,009,010,
	011,012,013,014,015,016,017,018,019,020,
	021,022,023,024,025,026,027,028,029,030,
	031,032,033,034,035,036,037,038,039,040,
	041,042,043,044,045,046,047,048,049,050,
	051,052,053,054,055,056,057,058,059,060,
	061,062,063,064,065,066,067,068,069,070,
	071,072,073,074,075,076,077,078,079,080,
	081,082,083,084,085,086,087,088,089,090
}

define_type			// Define Local Structures

struct _ysp
{
	char buffer[128];
	char sendCmd[128];
	char crntCmd[128];
	char prevCmd[128];
	
	integer model;
	
	integer sendretry;
	
	integer PrtOnline;
	integer PrtActive;
	
	integer devNum;
	integer devPrt;
	
	char pwrstat;
	integer isPwrOn;
	
	integer error;
	integer amute;
	integer input;
	float volume;
}

define_variable	// Instantiate Structures

volatile char cmd_get_vol[] = '82001';	// Request The Text Value Of The Volume Level
volatile char cmd_get_inp[] = '82003';	// Request The Text Value Of The Input Name

volatile _ysp ysp;

volatile char cmd_vol_set[3];		// Set the volume to a specific level (For YSP Older Than 4100)

define_variable	// Timeline Values

volatile long tlInfoQueTimes[] = {80000};
volatile long tlDataRcvTimes[] = {250};
volatile long tlIntSetsTimes[] = {1000,1000,1000,1000};

volatile long tlSndRTryTimes[] = {1000};

define_function sendDataStr(char DATSND[])
{
	stack_var char str[128];
	
	str = DATSND;
	
	off[vdvYSP,mod_DatRcv];
	send_string dvYSP,"cmd_hdr,str,cmd_ftr";
	
	if(timeline_active(tlSndRTry))
	{
		if(ysp.crntCmd == ysp.sendCmd)
		{
			ysp.sendretry = (ysp.sendretry + 1);
		}
		if(ysp.sendretry > 7)
		{
			if(timeline_active(tlSndRTry))
			{
				timeline_kill(tlSndRTry);
			}
			
			on[vdvYSP,mod_Error];
			
			print(nDbg_Lvl1,"'Communications :: NO RESPONSE FROM DEV:PORT -> ',itoa(dvYSP.number),':',itoa(dvYSP.port)");
			
			init();
		}
	}
	else
	{
		ysp.crntCmd = ysp.sendCmd;
		ysp.sendCmd = '';
		
		ysp.sendretry = 01;
		if(timeline_active(tlSndRTry))
		{
		
		}
		else
		{
			timeline_create(tlSndRTry,tlSndRTryTimes,length_array(tlSndRTryTimes),timeline_relative,timeline_repeat);
		}
	}
	
	print(nDbg_Lvl4,"'sendDataStr() :: Sent Command of ',str");
}

define_function fnsendDataStr(char DATRCV[])
{
	stack_var char str[256];
	
	stack_var char TYP[1];
	stack_var char GRD[1];
	stack_var char RCMD[2];
	stack_var char RDAT[2];
	
	str = DATRCV;
	
	TYP = get_buffer_string(str,1);
	GRD = get_buffer_string(str,1);
	
	RCMD = get_buffer_string(str,2);
	RDAT = get_buffer_string(str,2);
	
	/*

	*/
	
	switch(TYP)
	{
		case '0': print(nDbg_Lvl4,"'fnsendDataStr() :: Command Was Executed Via RS-232'");
		case '1': print(nDbg_Lvl4,"'fnsendDataStr() :: Command Was Executed Via IR Remote'");
		case '2': print(nDbg_Lvl4,"'fnsendDataStr() :: Command Was Executed Via Keys On Unit'");
		case '3': print(nDbg_Lvl4,"'fnsendDataStr() :: Command Was Executed Via The System'");
		case '4': print(nDbg_Lvl4,"'fnsendDataStr() :: Command Was Executed Via HDMI'");
		default:
		{
			print(nDbg_Lvl2,"'fnsendDataStr() :: Switch(TYP) :: Did not find a case for ',TYP");
		}
	}
	
	switch(GRD)
	{
		case '0': print(nDbg_Lvl4,"'fnsendDataStr() :: No Guard'");
		case '1': print(nDbg_Lvl2,"'fnsendDataStr() :: System Guard'");
		case '2': print(nDbg_Lvl2,"'fnsendDataStr() :: Setting Guard'");
		default:
		{
			print(nDbg_Lvl2,"'fnsendDataStr() :: Switch(GRD) :: Did not find a case for ',GRD");
		}
	}
	
	switch(RCMD)
	{
		case '10': {}; // Signal Format
		case '11': {}; // Sampling
		case '12': {}; // Channel Front Rear
		case '13': {};
		case '14': {}; // Bit Rate
		case '20':	// Power
		{
			if(RDAT == '01')
			{
				ysp.pwrstat = true;
				on[vdvYSP,mod_PwrOn];
				send_string vdvYSP,"'POWER=ON'";
			}
			else
			{
				ysp.pwrstat = false;
				off[vdvYSP,mod_PwrOn];
				send_string vdvYSP,"'POWER=OFF'";
			}
		}
		case '21':	// Input
		{
			ysp.input = atoi(RDAT);
		}
		case '22': {}; // Decoder Mode
		case '23':	// Mute
		{
			if(RDAT == '01')
			{
				ysp.amute = true;
				on[vdvYSP,mod_AMute];
			}
			else
			{
				ysp.amute = false;
				off[vdvYSP,mod_AMute];
			}
		}
		case '26': // Volume
		{
			stack_var integer val;
			val = hextoi(RDAT);
			
			if(ysp.model > 4000)
			{
				ysp.volume = val;
				send_level vdvYSP,nVolume,ysp.volume
			}
			else
			{
				ysp.volume = (val / 2.55);
				send_level vdvYSP,nVolume,ysp.volume
			}
		}
		case '5A': {}; // MAX Volume
		case '5B': {}; // Intial Volume
		
		case '80': {};
		case '81': {};
		case '82': {};
		case '83': {};
		case '84': {};
		case '85': {};
		case '86': {};
		case '87': {};
		case '88': {};
		case '89': {};
		case '8A': {};
		case '8B': {};
		
		default: 
		{
			print(nDbg_Lvl2,"'fnsendDataStr() :: Switch(RCMD) :: Did not find a case for ',RCMD");
		}
	}
}

define_function readInTextVals(char DATRCV[])
{
	stack_var char str[32];
	
	str = DATRCV;
	
	if(find_string(str,'MUTE',1))
	{
		ysp.amute = true;
		on[vdvYSP,mod_AMute];
	}
	else
	{
	}
}

define_function readInPwrOnVals(char DATRCV[])
{
	/*
	When Unit Is Powered On:
	$12G0079D93@E01900
	$12G0113F0A@E01900 020D4
	$12G0113F0A@E01900 020D4 $03
	---
	0 - System
	1	- Power
	2	- Input
	0 - Input Mode
	0 - Audio Mute
	
	9 - Master Volume Upper
	A - Master Volume Lower
	
	*/
	
	stack_var char str[128];
	
	str = DATRCV;
	
	print(nDbg_Lvl4,"'readInPwrOnVals() :: Parsing ysp Data :: ',str");
	
	if(length_string(str) < 10)
	{
		ysp.pwrstat = false;
		off[vdvYSP,mod_PwrOn];
		send_string vdvYSP,"'POWER=OFF'";
	}
	else
	{
		ysp.pwrstat = true;
		on[vdvYSP,mod_PwrOn];
		send_string vdvYSP,"'POWER=ON'";
		
		if(ysp.model > 4000)
		{
		}
		else
		{
		}
	}
}

define_function fnSetVolumeLvl(integer LVL)
{
	stack_var integer yspLVL;
	stack_var char HexVal[3];
	
	yspLVL = LVL;
	HexVal  = itohex(yspLVL);
	
	ysp.sendCmd = "cmd_vol_set,HexVal";
	sendDataStr(ysp.sendCmd);
}

define_function fnSetIntialVals()
{
	ysp.volume = 200;
	
	ysp.input = false;
	ysp.amute = false;
	
	cmd_vol_set = '830';
}

define_function fnSetCmdsTo4x00()
{
	cmd_get_vol = '81501';
	cmd_get_inp = '81503'
	cmd_vol_set = '826';
}

define_function CancelQuery()
{
	if(timeline_active(tlInfoQue))
	{
		timeline_kill(tlInfoQue);
	}
}

define_function QueryUnit()
{
	if(timeline_active(tlInfoQue))
	{
	
	}
	else
	{
		timeline_create(tlInfoQue,tlInfoQueTimes,length_array(tlInfoQueTimes),timeline_relative,timeline_repeat);
	}
}

define_function SetInitReq()
{
	if(timeline_active(tlIntSets))
	{
	
	}
	else
	{
		timeline_create(tlIntSets,tlIntSetsTimes,length_array(tlIntSetsTimes),timeline_relative,timeline_once);
	}
}

define_function init()
{
	send_command dvYSP,'SET BAUD 9600,N,8,1';
	send_command dvYSP,'RXON';
	send_command dvYSP,'HSOFF';
	send_command dvYSP,'XOFF';
	
	on[vdvYSP,mod_Online];
	
	send_string dvYSP,"$11,$00,$00,$00,$03";
	print(nDbg_Lvl2,"'Communications :: Sending Initialzation String To YSP'");
	
	SetInitReq();
}

define_start		// All Startup Items
{
	create_buffer dvYSP, ysp.buffer;
	this.name = 'YSP';
}

define_event		// All Data Events

data_event[dvYSP]
{
	online:
	{
		ysp.devNum = dvYSP.number;
		ysp.devPrt = dvYSP.port;
		
		print(nDbg_Lvl4,"'is Online'");
		
		init();
	}
	offline:
	{
		ysp.PrtOnline = false;
		ysp.PrtActive = false;
		
		if(timeline_active(tlIntSets))
		{
			timeline_kill(tlIntSets);
		}
		
		print(nDbg_Lvl1,"'is OFFLINE'");
		
		off[vdvYSP,mod_Online];
		off[vdvYSP,mod_DatRcv];
	}
	string:
	{
		ysp.PrtActive = true;
		on[vdvYSP,mod_DatRcv];
		off[vdvYSP,mod_Error];
		
		if(timeline_active(tlSndRTry))
		{
			timeline_kill(tlSndRTry);
			ysp.sendretry = 0;
		}
		
		if(timeline_active(tlDataRcv))
		{
		
		}
		else
		{
			timeline_create(tlDataRcv,tlDataRcvTimes,length_array(tlDataRcvTimes),timeline_relative,timeline_repeat);
		}
	}
}

data_event[vdvYSP]
{
	online:
	{
		fnSetIntialVals();
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
		
		if(find_string(CmdRcv,'-',1))
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
			case 'PASSTHRU':
			{
				ysp.sendCmd = CmdRcv;
			}
			case 'REINIT': init();
			case 'NAME': this.name = CmdRcv;
			case 'POWER': 
			{
				switch(CmdRcv)
				{
					case 'ON': do_push(vdvYSP,1);
					case 'OFF': do_push(vdvYSP,2);
				}
			}
			case 'INPUT': {}
			case 'MODEL': 
			{
				// YSP-4100 and 5100 Units have a differant Direct Volume Control Header as well as other functions.
				stack_var integer model;
				
				model = atoi(CmdRcv);
				
				ysp.model = model;
				
				if(model > 4000) fnSetCmdsTo4x00();
			}
			case 'VOLUME':
			{
				stack_var integer val;
				
				val = atoi(CmdRcv);
				fnSetVolumeLvl(val);
			}
			case 'BAUDRATE':
			{
				send_command dvYSP,"'SET BAUD ',CmdRcv,',N,8,1'";
				print(nDbg_Lvl4,"'Setting Baud Rate To ',CmdRcv");
			}
			case 'DEBUG':
			{
				dbg = atoi(CmdRcv);
				print(dbg,"'Setting Debug To ',itoa(dbg)");
			}
			case 'STATUS':{}
			default:{}
		}
		
		if(ysp.sendCmd != '')
		{
			sendDataStr(ysp.sendCmd);
		}
	}
}

define_event		// All Button Events

button_event[vdvYSP,nDev_Ctrl_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = button.input.channel;
		
		switch(idx)
		{
			case 01: ysp.sendCmd = cmd_pwr_ion;
			case 02: ysp.sendCmd = cmd_pwr_off;
			
			case 03: ysp.sendCmd = cmd_inp_tva;
			case 04: ysp.sendCmd = cmd_inp_ax1;
			case 05: ysp.sendCmd = cmd_inp_dvd;
			case 06: ysp.sendCmd = cmd_inp_dab;
			case 07: ysp.sendCmd = cmd_inp_ax3;
			case 08: ysp.sendCmd = cmd_inp_ax2;
			case 09: ysp.sendCmd = cmd_inp_fma;
			case 10: ysp.sendCmd = cmd_inp_hm4;
			
			case 13: ysp.sendCmd = cmd_vmt_ion;
			case 14: ysp.sendCmd = cmd_vmt_off;
			
			case 18: ysp.sendCmd = cmd_aud_vup;
			case 19: ysp.sendCmd = cmd_aud_vdn;
			
			case 21: ysp.sendCmd = cmd_dsp_md1;
			case 22: ysp.sendCmd = cmd_dsp_md2;
			case 23: ysp.sendCmd = cmd_dsp_md3;
			case 24: ysp.sendCmd = cmd_dsp_md4;
			case 25: ysp.sendCmd = cmd_dsp_md5;
			case 26: ysp.sendCmd = cmd_dsp_md6;
			case 27: ysp.sendCmd = cmd_dsp_md7;
			case 28: ysp.sendCmd = cmd_dsp_off;
			
			case 81: ysp.sendCmd = cmd_get_all;
			case 82: ysp.sendCmd = cmd_get_vol;
			case 83: ysp.sendCmd = cmd_get_inp;
			
			default: {};
		}
		
		if(ysp.sendCmd != '')
		{
			sendDataStr(ysp.sendCmd);
		}
	}
	hold[3, repeat]:
	{
		stack_var integer idx;
		
		idx = button.input.channel;
		
		switch(idx)
		{
			case 11: 
			{
				if(ysp.volume <= 99)
				{
					ysp.sendCmd = cmd_aud_vup;
				}
			}
			case 12: 
			{
				if(ysp.volume >= 1)
				{
					ysp.sendCmd = cmd_aud_vdn;
				}
			}
		}
		
		if(ysp.sendCmd != '')
		{
			sendDataStr(ysp.sendCmd);
		}
	}
}

define_event		// All Timeline Eventa

timeline_event[tlDataRcv]
{
	if(find_string(ysp.buffer,"$03",1))
	{
		stack_var char str[256];
		stack_var char trash[32];
		
		if(find_string(ysp.buffer,"$12",1))
		{
			// $12G0079D93@E01900
			// $12G0113F0A@E01900 020D4
			
			if(find_string(ysp.buffer,"'@E01900'",1))
			{
				trash = remove_string(ysp.buffer,"'@E01900'",1);
				str = remove_string(ysp.buffer,"$03",1);
				
				set_length_string(str,length_string(str) - 1);
				
				print(nDbg_Lvl3,"'Sending To readInPwrOnVals() -> ',str");
				
				readInPwrOnVals(str);
			}
		}
		else if(find_string(ysp.buffer,"$11,'01'",1))
		{
			trash = remove_string(ysp.buffer,"$11,'01'",1);
			str = remove_string(ysp.buffer,"$03",1);
			
			set_length_string(str,length_string(str) - 1);
			
			print(nDbg_Lvl3,"'Sending To readInTextVals() -> ',str");
			
			readInTextVals(str);
		}
		else
		{
			str = remove_string(ysp.buffer,"$03",1);
			
			set_length_string(str,length_string(str) - 1);
			
			if(find_string(str,"$02,$02",1))
			{
				remove_string(str,"$02,$02",1);
			}
			else
			{
				remove_string(str,"$02",1);
			}
			
			print(nDbg_Lvl3,"'Sending To fnsendDataStr() -> ',str");
			
			fnsendDataStr(str);
		}
	}
	else
	{
		timeline_kill(tlDataRcv);
		
		print(nDbg_Lvl4,"'Timeline "tlDataRcv" Has Terminated'");
		
		clear_buffer ysp.buffer;
	}
}

timeline_event[tlSndRTry]
{
	ysp.sendCmd = ysp.crntCmd;
	sendDataStr(ysp.sendCmd);
}

timeline_event[tlIntSets]
{
	if(timeline_active(tlSndRTry))
	{
		timeline_kill(tlIntSets);
	}
	else
	{
		switch(timeline.sequence)
		{
			case 01: ysp.sendCmd = cmd_set_fbk;
			case 02: ysp.sendCmd = cmd_set_dly;
			case 03: ysp.sendCmd = cmd_get_vol;
			case 04: ysp.sendCmd = cmd_get_inp;
		}
		
		if(ysp.sendCmd != '')
		{
			sendDataStr(ysp.sendCmd);
		}
	}
}

timeline_event[tlInfoQue]
{
	if([vdvYSP,255])
	{
		switch(timeline.sequence)
		{
			case 01:
			{
				ysp.sendCmd = cmd_get_vol;
				print(nDbg_Lvl4,"'Has Requested Volume Level'");
				sendDataStr(ysp.sendCmd);
			}
			default: {}
		}
	}
}

define_program

wait 5 'update_virtual_fdbck'
{
	[vdvYSP,mod_PwrOn] = (ysp.pwrstat);
	[vdvYSP,mod_AMute] = (ysp.amute);
	[vdvYSP,mod_Error] = (ysp.error);
}