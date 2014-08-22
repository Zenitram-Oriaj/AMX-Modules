module_name = 'Clearone_Cnvrg_Comm'
(
	dev vdvDSP,
	dev dvDSP,
	dev dvUI[]
)
(***********************************************************)
(*  FILE CREATED ON: 10/15/2010  AT: 17:23:01              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 08/22/2014  AT: 12:27:08        *)
(***********************************************************)

/*

*/

#define TYPE_DSP 1

#include 'stdio.axi';

define_constant	// Timeline Constants

long tlInfoQue = 21;
long tlDataRcv = 22;
long tlCommCnt = 23;
long tlInfLvls = 24;
long tlInfMuts = 25;

define_constant

integer Converge880			= 01; 		
integer ConvergeTH20 		= 02;		
integer ConvergeVH20 		= 03;		
integer Converge840T 		= 04;		
integer Converge8i 			= 05;		
integer Converge880T 		= 06;		
integer Converge880TA 	= 07;		
integer ConvergeSR1212	= 08; 		
integer ConvergeSR1212A	= 09; 		
integer Converge590			= 10;
integer Converge560			= 11;

define_constant

sinteger siVolumeMinimum = -65
sinteger siVolumeMaximum = 20
	
integer nComTypeIP = 01;
integer nComTypeRS = 02;

long IP_Port = 23;

integer nAnyBtn = 0;

integer MaxInstance = 10;

char cmd_hdr = '#';
char cmd_ftr = $0D;

char cmd_dial[] = 'DIAL';
char cmd_hook[] = 'HOOK';
char cmd_mute[] = 'MUTE';
char cmd_gain[] = 'GAIN';

char typ_tel[] = 'TE';

char typ_lne = 'L';
char typ_inp = 'I';
char typ_mic = 'M';
char typ_out = 'O';
char typ_amp = 'J';
char typ_tx1 = 'T';
char typ_rx1 = 'R';
char typ_prs = 'P';
char typ_gte = 'G';
char typ_bus = 'E';

char process[8][1] = 
{
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H'
}

define_constant

integer nUI_PrsVol_Lvls[] =
{
	01,	// 
	02,	// 
	03,	// 
	04,	// 
	05,	// 
	06,	// 
	07,	// 
	08	//
} 

integer nUI_InpVol_Lvls[] =
{
	11,12,13,14,15,16,
	17,18,19,20,21,22
}

integer nUI_OutVol_Lvls[] =
{
	31,32,33,34,35,36,
	37,38,39,40,41,42
}

define_constant

integer nUI_PhoneCtrl_Btns[] =
{
	01,	// Dial Or Hang-Up
	02,	// Clear
	03,	// Back
	04,	// Last
	05,	// Flash
	06,	// Answer Incoming
	07,	// Reject Incoming
	08,	//
	09	//
} 

integer nUI_PhoneNums_Btns[] =
{
	10,	// Numeric 0
	11,	// Numeric 1
	12,	// Numeric 2
	13,	// Numeric 3
	14,	// Numeric 4
	15,	// Numeric 5
	16,	// Numeric 6
	17,	// Numeric 7
	18,	// Numeric 8
	19,	// Numeric 9
	20,	// Numeric *
	21	// Numeric #
}

integer nUI_PrsVolUp_Btns[] =
{
	31,32,33,34,
	35,36,37,38
}

integer nUI_PrsVolDn_Btns[] =
{
	41,42,43,44,
	45,46,47,48
}

integer nUI_PrsVolMt_Btns[] =
{
	51,52,53,54,
	55,56,57,58
}

integer nUI_InpVolUp_Btns[] =
{
	61,62,63,64,65,66,
	67,68,69,70,71,72
}

integer nUI_InpVolDn_Btns[] =
{
	81,82,83,84,85,86,
	87,88,89,90,91,92
}

integer nUI_InpMute_Btns[] =
{
	101,102,103,104,	// Mics 1 - 4
	105,106,107,108,	// Mics 5 - 8
	109,110,111,112,	// Line 1 - 4
	113,114,115,116		// Telco and Other
}

integer nUI_OutMute_Btns[] =
{
	121,122,123,124,	// Line 1 - 4
	125,126,127,128,	// Line 5 - 8
	129,130,131,132,	// Line 9 - 12
	133,134,135,136		// Telco and Other
} 

integer nUI_AmpMute_Btns[] =
{
	141,142,143,144	// Line 1 - 4
} 

integer nUI_OutVolUp_Btns[] = 
{
	151,152,153,154,
	155,156,157,158,
	159,160,161,162,
	163,164,165,166
}

integer nUI_OutVolDn_Btns[] = 
{
	171,172,173,174,
	175,176,177,178,
	179,180,181,182,
	183,184,185,186
}

define_constant

integer nDev_Ctrl_Btns[] =
{
	001,002,003,004,005,006,007,008,009,010,
	011,012,013,014,015,016,017,018,019,020,
	021,022,023,024,025,026,027,028,029,030
}

define_type

struct _dsp
{
	char buffer[1024];
	char sendCmd[128];
	char crntCmd[128];
	char prevCmd[128];
	
	char sysID[8];
	char modelName[32];
	char baudRate[8];
	
	char SysActive;
	
	integer PrtOnline;
	integer PrtActive;
	
	slong	PrtError;
	slong PrtRetry;
	
	integer devNum;
	integer devPrt;
	
	char phoneNum[16];
	char lastNumDial[16];
	
	integer hookstatus;
	char callTime[16];
	
	integer inpMut[12];
	integer outMut[12];
	integer ampMut[04];
	integer prsMut[08];
	
	float inpLvl[12];
	float outLvl[12];
	float ampLvl[04];
	float prsLvl[08];
	
	float txLvl;
	float rxLvl;
	
	integer txMute;
	integer rxMute;
}

define_variable

volatile _dsp dsp;

define_variable	// Timeline Values

volatile long tlInfoQueTimes[] = 
{
	500,500,500,500,500,500,500,500,500,500,
	500,500,500,500,500,500,500,500,500,500
}

volatile long tlDataRcvTimes[] = {200};
volatile long tlCommCntTimes[] = {500};

define_variable

volatile integer nModel;
volatile integer nID;
volatile integer nHoldOff;

volatile char model = 'H';
volatile char id[1];
volatile char chnl = '1';

volatile char infoMutCmds[][16] = 
{
	'MUTE 1 I',
	'MUTE 2 I',
	'MUTE 3 I',
	'MUTE 4 I',
	'MUTE 5 I',
	'MUTE 6 I',
	'MUTE 7 I',
	'MUTE 8 I',
	
	'MUTE 9 I',
	'MUTE 10 I',
	'MUTE 11 I',
	'MUTE 12 I',
	
	'MUTE A P',
	'MUTE B P',
	'MUTE C P',
	'MUTE D P',
	'MUTE E P',
	'MUTE F P',
	'MUTE G P',
	'MUTE H P'
} 


volatile char infoLvlCmds[][16] = 
{
	'GAIN 1 I',
	'GAIN 2 I',
	'GAIN 3 I',
	'GAIN 4 I',
	'GAIN 5 I',
	'GAIN 6 I',
	'GAIN 7 I',
	'GAIN 8 I',
	
	'GAIN 9 I',
	'GAIN 10 I',
	'GAIN 11 I',
	'GAIN 12 I',
	
	'GAIN A P',
	'GAIN B P',
	'GAIN C P',
	'GAIN D P',
	'GAIN E P',
	'GAIN F P',
	'GAIN G P',
	'GAIN H P'
} 

volatile char queryCmds[20][16] =
{
	'','','','','','','','','','',
	'','','','','','','','','',''
}

define_function init()
{
	print(nDbg_Lvl4,'Running Init() Function');
	
	if(nComType == nComTypeRS)
	{
		send_command dvDSP,'SET BAUD 57600,N,8,1';
		send_command dvDSP,'RXON';
		send_command dvDSP,'HSOFF';
		send_command dvDSP,'XOFF';
	}
	else if(nComType == nComTypeIP)
	{
		setUpTcpComms(IPAddress, IP_Port);
	}
	
	dsp.sysID = "cmd_hdr,model,id";
	
	CancelQuery();
	QueryLevels();
	
	print(nDbg_Lvl4,'Ending Init() Function');
}

define_function Property(char DATRCV[])
{
	stack_var char str[256];
	stack_var char typ[32];
	stack_var char fnc[32];
}

define_function CancelQuery()
{
	if(timeline_active(tlInfoQue))
	{
		print(nDbg_Lvl4,'Cancelling tlInfoQue TimeLine');
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
		print(nDbg_Lvl4,'Starting Up tlInfoQue TimeLine');
		timeline_create(tlInfoQue,tlInfoQueTimes,length_array(tlInfoQueTimes),timeline_relative,timeline_repeat);
	}
}

define_function QueryLevels()
{
	if(timeline_active(tlInfLvls))
	{
	
	}
	else
	{
		print(nDbg_Lvl4,'Starting Up tlInfLvls TimeLine');
		timeline_create(tlInfLvls,tlInfoQueTimes,length_array(tlInfoQueTimes), timeline_relative, timeline_once);
	}
}

define_function QueryMutes()
{
	if(timeline_active(tlInfMuts))
	{
	
	}
	else
	{
		print(nDbg_Lvl4,'Starting Up tlInfMuts TimeLine');
		timeline_create(tlInfMuts,tlInfoQueTimes,length_array(tlInfoQueTimes), timeline_relative, timeline_once);
	}
}

define_function sendDataStr(char DATSND[])
{
	stack_var char str[128];
	
	str = DATSND;
	
	off[vdvDSP,mod_DatRcv];
	
	send_string dvDSP,"cmd_hdr,model,id,' ',str,$0D,$0A";
	
	print(nDbg_Lvl3,"'sendDataStr() :: Has Sent The String: ',str");
	
	dsp.crntCmd = dsp.sendCmd;
	dsp.sendCmd = '';
	
	wait 50 'is_dev_comm'
	{
		on[vdvDSP,mod_Error];
		print(nDbg_Lvl1,"'Communications :: NO RESPONSE FROM DEV:PORT -> ',itoa(dvDSP.number),':',itoa(dvDSP.port)");
	}
}

define_function integer fnConvertChn(char VALUE[])
{
	stack_var char ref[2];
	
	ref = VALUE;
	
	switch(ref)
	{
		case 'A': return 1;
		case 'B': return 2;
		case 'C': return 3;
		case 'D': return 4;
		case 'E': return 5;
		case 'F': return 6;
		case 'G': return 7;
		case 'H': return 8;
		default:
		{
			return atoi(ref);
		}
	}
}

define_function parseRcvData(char DATRCV[])
{
	stack_var char str[256];
	stack_var char temp[8];
	
	stack_var char hdr[4];
	stack_var char cmd[8];
	stack_var char typ[2];
	stack_var char ref[2];
	
	stack_var integer chn;
	stack_var integer val;
	stack_var float fval;
	
	str = DATRCV;
	
	print(nDbg_Lvl4,"'parseRcvData() -> Data Received : ',str");
	
	if(find_string(str,'ERROR',1))
	{
		remove_string(str,'ERROR',1)
		print(nDbg_Lvl1,"'parseRcvData() -> Error Received :',str");
	}
	else
	{
		if(find_string(str,'OK>',1))
		{
			temp = remove_string(str,"$20",1);
		}
		
		hdr = remove_string(str,"$20",1);
		cmd = remove_string(str,"$20",1);
		
		set_length_string(hdr, length_string(hdr) - 1);
		set_length_string(cmd, length_string(cmd) - 1);
		
		if(hdr != dsp.sysID)
		{
			print(nDbg_Lvl4,"'parseRcvData() -> Receive ID Does Not Match : ',hdr,' : ',dsp.sysID");
			return;
		}
		
		switch(cmd)
		{
			case 'MUTE':
			{
				ref = remove_string(str,"$20",1);
				set_length_string(ref, length_string(ref) - 1);
				
				chn = fnConvertChn(ref);
				
				typ = remove_string(str,"$20",1);
				set_length_string(typ, length_string(typ) - 1);
				val = atoi(str);
				
				switch(typ)
				{
					case typ_lne: dsp.inpMut[chn] = val;
					case typ_mic: dsp.inpMut[chn] = val;
					case typ_inp: dsp.inpMut[chn] = val;
					case typ_out: dsp.outMut[chn] = val;
					case typ_amp: dsp.ampMut[chn] = val;
					case typ_tx1: dsp.txMute = val;
					case typ_rx1: dsp.rxMute = val;
					case typ_prs: 
					{
						dsp.prsMut[chn] = val;
					}
					default:{};
				}
			}
			case 'HOOK':
			{
			
			}
			case 'DIAL':
			{
			
			}
			case 'GAIN':
			{
				ref = remove_string(str,"$20",1);
				set_length_string(ref, length_string(ref) - 1);
				
				chn = fnConvertChn(ref);
				
				typ = remove_string(str,"$20",1);
				set_length_string(typ, length_string(typ) - 1);
				
				fval = atof(str);
				
				switch(typ)
				{
					case typ_lne: dsp.inpLvl[chn] = fval;
					case typ_mic: dsp.inpLvl[chn] = fval;
					case typ_inp: dsp.inpLvl[chn] = fval;
					case typ_out: 
					{
						dsp.outLvl[chn] = fval;
						send_level vdvDSP,nUI_OutVol_Lvls[chn],fval;
					}
					case typ_amp: dsp.ampLvl[chn] = fval;
					case typ_tx1: dsp.txLvl = fval;
					case typ_rx1: dsp.rxLvl = fval;
					case typ_prs: 
					{
						dsp.prsLvl[chn] = fval;
						send_level vdvDSP,chn,fval;
					}
					default:{};
				}
				
				if(typ == typ_prs)
				{
					send_level dvUI,chn,dsp.prsLvl[chn];
				}
				else if(typ == typ_mic || typ == typ_inp)
				{
					send_level dvUI,nUI_InpVol_Lvls[chn],dsp.inpLvl[chn];
				}
				else if(typ == typ_out)
				{
					send_level dvUI,nUI_OutVol_Lvls[chn],dsp.outLvl[chn];
				}
				
			}
			case 'RING':
			{
				if(find_string(str,'1 1',1))
				{
					send_command dvUI,"'@PPN-atc_incoming_call'";
					send_string vdvDSP,"'ATC-Incoming Call;'";
					send_command dvUI,"'^TXT-99,0,INCOMING'";
				}
			}
			case 'LABEL':
			{
			
			}
			case 'MTRX':
			{
			
			}
			case 'TE':
			{
				chn = atoi(remove_string(str,"$20",1));
				val = atoi(str);
				
				dsp.hookstatus = val;
				
				if(dsp.hookstatus == 1)
				{
					print(nDbg_Lvl4,"'parseRcvData() -> Telco Status : OFF HOOK : ',itoa(dsp.hookstatus)");
					on[vdvDSP,mod_AtcOn];
					send_command dvUI,"'^TXT-99,0,CONNECTED'";
				}
				else
				{
					print(nDbg_Lvl4,"'parseRcvData() -> Telco Status : ON HOOK : ',itoa(dsp.hookstatus)");
					off[vdvDSP,mod_AtcOn];
					send_command dvUI,"'^TXT-99,0,DISCONNECTED'";
				}
			}
			case 'CALLDUR':
			{
				chn = atoi(remove_string(str,"$20",1));
				dsp.callTime = str;
				
				print(nDbg_Lvl4,"'parseRcvData() -> Call Duration : ',dsp.callTime");
			}
		}	
	}
}

define_function setUpTcpComms(char cIPAddress[], long nPORT)
{
	stack_var char dspIP[16];
	stack_var long dspPort;
	
	dspIP = cIPAddress;
	dspPort = nPORT;
	
	if(!dsp.PrtOnline)
	{
		if(timeline_active(tlCommCnt))
		{
			timeline_kill(tlCommCnt);
		}
		
		ip_client_open(dvDSP.port,dspIP,dspPort,IP_TCP);
		
		timeline_create(tlCommCnt,tlCommCntTimes, length_array(tlCommCntTimes), timeline_relative, timeline_repeat);
	}
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
			errMsg = "'No Case Found For #',itoa(type_cast(ofType))";
		}
	}
	
	print(nDbg_Lvl1, "'fnCommErrorChk() :: ',errMsg");
}

define_function fnDialPhoneNum(char NUM[])
{
	stack_var char dspNUM[16];
	
	dspNUM = NUM;
	
	dsp.lastNumDial = dspNUM;
	
	dsp.sendCmd = "'DIAL 1 ',dspNUM"
	
	sendDataStr(dsp.sendCmd);
	
	send_command dvUI,"'^TXT-99,0,Dialing Number'";
}

define_function fnDialSnglDgt(char NUM[])
{
	stack_var char dspNUM[2];
	
	dspNUM = NUM;
	
	dsp.sendCmd = "'DIAL 1 ',dspNUM"
	
	sendDataStr(dsp.sendCmd);
}

define_function fnSetModelByInt(integer TYPE)
{
	stack_var integer i;
	
	i = TYPE;
	
	switch(i)
	{
		case Converge880			: model = '1';
		case ConvergeTH20 		: model = '2';
		case ConvergeVH20 		: model = 'E';
		case Converge840T 		: model = '3';
		case Converge8i 			: model = 'A';
		case Converge560 			: model = 'C';
		case Converge590 			: model = 'B';
		case Converge880T 		: model = 'D';
		case Converge880TA 		: model = 'H';
		case ConvergeSR1212		: model = 'G';
		case ConvergeSR1212A	: model = 'I';
		default:                      
		{
			model = 'D';
		}
	}
}

define_function fnSetQueryByInt(integer TYPE)
{
	stack_var integer i;
	
	i = TYPE;
	
	switch(i)
	{
		case Converge880			: 
		case ConvergeTH20 		: 
		case ConvergeVH20 		: 
		case Converge8i 			: 
		case ConvergeSR1212		: 
		case ConvergeSR1212A	:
		{
			queryCmds[01] = '';
			queryCmds[06] = '';
		}
	}
}

define_function fnSetModelByLit(char TYPE[])
{
	stack_var char i[16];
	
	i = TYPE;
	
	dsp.modelName = i;
	
	switch(i)
	{
		case 'CONVERGE880'			: model = '1';
		case 'CONVERGETH20' 		: model = '2';
		case 'CONVERGEVH20' 		: model = 'E';
		case 'CONVERGE840T' 		: model = '3';
		case 'CONVERGE8I' 			: model = 'A';
		case 'CONVERGE560' 			: model = 'C';
		case 'CONVERGE590' 			: model = 'B';
		case 'CONVERGE880T' 		: model = 'D';
		case 'CONVERGE880TA' 		: model = 'H';
		case 'CONVERGESR1212'		: model = 'G';
		case 'CONVERGESR1212A'	: model = 'I';
		default:                      
		{
			model = 'D';
		}
	}
}

define_function fnGetHookStatus()
{
	dsp.sendCmd = 'TE 1';
	sendDataStr(dsp.sendCmd);
}

define_function fnGetLastNumber()
{
	sendDataStr(dsp.sendCmd);
}

define_function fnGetLevels(integer EndPnt)
{
	stack_var integer idx;
	
	idx = EndPnt;
}

define_function fnProcessMute(integer PROC)
{
	stack_var integer idx;
	stack_var char ref;
	
	idx = PROC;
	
	if(dsp.prsMut[idx] == 1)
	{
		ref = '0';
	}
	else
	{
		ref = '1';
	}
	
	dsp.sendCmd = "'MUTE ',process[idx],' P ',ref";
	
	sendDataStr(dsp.sendCmd);
}

define_function Set_UI_Values(integer UI)
{
	stack_var integer udx;
	stack_var integer i;
	
	print(nDbg_Lvl4,"'Set_UI_Values() -> Set Values For UI #',itoa(udx)");
	
	udx = UI;
	
	for(i = 1; i <= 12; i++)
	{
		send_level dvUI,nUI_InpVol_Lvls[i],dsp.inpLvl[i];
	}
	
	i = 0;
	
	for(i = 1; i <= 12; i++)
	{
		send_level dvUI,nUI_OutVol_Lvls[i],dsp.outLvl[i];
	}
	
	i = 0;
	
	for(i = 1; i <= 8; i++)
	{
		send_level dvUI,nUI_PrsVol_Lvls[i],dsp.prsLvl[i];
	}
}


define_function AddGainCommand(char sArgInputOutput[],integer nArgChannel,integer nArgVolume)
{
	stack_var char    sMyValue  [10]
	stack_var char    sMyCommand[100]
	
	sMyValue = itoa(type_cast(SignedAdjustFrom255(nArgVolume, siVolumeMinimum, siVolumeMaximum)))
}

define_start
{
	create_buffer dvDSP, dsp.buffer;
	
	set_virtual_level_count(vdvDSP,40);
	
	this.name = 'DSP 00';
	
	wait 150 'wait_to_set_flag'
	{
		dsp.SysActive = true;
	}
}

define_event		// Data Events

data_event[dvDSP]
{
	online:
	{
		dsp.devNum = data.device.number;
		dsp.devPrt = data.device.port;
		
		print(nDbg_Lvl4,"'Is Now Online'");
		
		on[vdvDSP,mod_Online];
		off[vdvDSP,mod_Error];
		
		if(dsp.SysActive)
		{
			init();
		}
	}
	offline:
	{
		print(nDbg_Lvl1,"'IS OFFLINE'");
		
		on[vdvDSP,mod_Error];
		off[vdvDSP,mod_DatRcv];
		off[vdvDSP,mod_Online];
		
		CancelQuery();
		
		if(nComType == nComTypeIP)
		{
			setUpTcpComms(IPAddress, IP_Port);
		}
	}
	onerror:
	{
		stack_var slong errVal;
		
		errVal = type_cast(data.number);
		
		dsp.PrtError = errVal;
		
		fnCommErrorChk(errVal);
	}
	string:
	{
		on[vdvDSP,mod_DatRcv];
		off[vdvDSP,mod_Error];
		
		cancel_wait 'is_dev_comm';
		
		if(timeline_active(tlDataRcv))
		{
		
		}
		else
		{
			timeline_create(tlDataRcv,tlDataRcvTimes,length_array(tlDataRcvTimes),timeline_relative,timeline_repeat);
		}
	}
}

data_event[vdvDSP]
{
	command:
	{
		stack_var char CmdRcv[64];
		stack_var char Temp[32];
		stack_var char cFUNC[64];
		
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
		
		if(find_string(CmdRcv,'?',1))
		{
		}
		else
		{
			switch(cFUNC)
			{
				case 'PASSTHRU':
				{
					dsp.sendCmd = CmdRcv;
				}
				
				case 'PROPERTY':	Property(CmdRcv);
				case 'NAME': 			this.name = CmdRcv;
				case 'IPADDRESS': IPAddress = CmdRcv;
				case 'POLLTIME':	pollTime = atoi(CmdRcv);
				case 'UNITID': 		id = CmdRcv;
				case 'MODEL': 		fnSetModelByLit(CmdRcv);
				case 'DISCONNECT':
				{
					dsp.sendCmd = 'TE 1 0';
					sendDataStr(dsp.sendCmd);
					send_command dvUI,"'^TXT-99,0,DISCONNECTING'";
					dsp.phoneNum = '';
					send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
				}
				case 'REINIT':
				{
					if(nComType == nComTypeRS)
					{
						wait_until(dsp.SysActive == true) { init(); }
					}
					else
					{
						init();
					}
				}
				case 'BAUDRATE':
				{
					send_command dvDSP,"'SET BAUD ',CmdRcv,',N,8,1'";
					print(nDbg_Lvl4,"'Setting Baud Rate To ',CmdRcv");
				}
				
				case 'DEBUG':
				{
					dbg = atoi(CmdRcv);
					print(dbg,"'Setting Debug To ',itoa(dbg)");
				}
				case 'COMTYPE': 
				{
					if(CmdRcv == 'IP')
					{
						nComType = nComTypeIP;
					}
					else
					{
						nComType = nComTypeRS;
					}
				}
				case 'QUERYCMDS':
				{
					stack_var integer idx;
					
					idx = atoi(remove_string(CmdRcv,':',1));
					
					QueryCmds[idx] = CmdRcv;
				}
				case 'LEVEL':   {}
				case 'MUTE':    {}
				case 'STATUS':  {}
				default:{}
			}
			
			if(dsp.sendCmd != '')
			{
				sendDataStr(dsp.sendCmd);
			}
		}
	}
}

data_event[dvUI]
{
	online:
	{
		stack_var integer udx;
		
		udx = get_last(dvUI);
		
		if(dsp.SysActive)
		{
			Set_UI_Values(udx);
		}
	}
	offline:
	{
	
	}
}

define_event		// Level Events

define_event		// Button Events - Virtual Device

button_event[vdvDSP,nDev_Ctrl_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = button.input.channel;
		
		switch(idx)
		{
			case 01: fnGetHookStatus();
			case 02: fnGetLastNumber();
			case 03: fnGetLevels(01);
			case 05: fnGetLevels(02);
			case 07: fnGetLevels(03);
		}      
	}
}

button_event[vdvDSP,nUI_PrsVolUp_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolUp_Btns);
		
		if(dsp.prsLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolUp_Btns);
		
		if(dsp.prsLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[vdvDSP,nUI_PrsVolDn_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolDn_Btns);
		
		if(dsp.prsLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolDn_Btns);
		
		if(dsp.prsLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[vdvDSP,nUI_PrsVolMt_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref[2];
		
		idx = get_last(nUI_PrsVolMt_Btns);
		
		if(dsp.prsMut[idx] == 1)
		{
			ref = '0';
		}
		else
		{
			ref = '1';
		}
		
		dsp.sendCmd = "'MUTE ',process[idx],' P ',ref";
		
		sendDataStr(dsp.sendCmd);
	}
}


button_event[vdvDSP,nUI_InpMute_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref;
		
		idx = get_last(nUI_InpMute_Btns);
		
		if(dsp.inpMut[idx] == 1)
		{
			ref = '0';
		}
		else
		{
			ref = '1';
		}
		
		
		if(idx <= 8)
		{
			dsp.sendCmd = "'MUTE ',itoa(idx),' M ',ref";
		}
		else
		{
			dsp.sendCmd = "'MUTE ',itoa(idx),' L ',ref";
		}
		
		sendDataStr(dsp.sendCmd);
	}
}

define_event		// Button Events - UI

button_event[dvUI,nUI_PhoneCtrl_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PhoneCtrl_Btns);
		
		switch(idx)
		{
			case 01: 
			{
				if((dsp.hookstatus == 0)&&(length_string(dsp.phoneNum) > 1))
				{
					fnDialPhoneNum(dsp.phoneNum)
					send_command dvUI,"'^TXT-99,0,DIALING'";
				}
				else
				{
					if(dsp.hookstatus == 1)
					{
						dsp.sendCmd = 'TE 1 0';
						sendDataStr(dsp.sendCmd);
						send_command dvUI,"'^TXT-99,0,DISCONNECTING'";
						dsp.phoneNum = '';
						send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
					}
					else
					{
						dsp.sendCmd = 'TE 1 1';
						sendDataStr(dsp.sendCmd);
						send_command dvUI,"'^TXT-99,0,CONNECTING'";
					}
				}
			}
			case 02:	// Clear The Phone Number
			{
				dsp.phoneNum = '';
				send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
			}
			case 03: // Remove The Last Digit Entered
			{
				set_length_string(dsp.phoneNum,length_string(dsp.phoneNum) - 1);
				send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
			}
			case 04: // Redial The Last Number
			{
				if(dsp.lastNumDial)
				{
					dsp.phoneNum = dsp.lastNumDial;
					send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
				}
				else
				{
					send_command dvUI,"'^TXT-98,0,No Number Found'";
				}
			}
			case 05: // Do A FLASH on the line
			{
				dsp.phoneNum = '';
				send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
				
				dsp.sendCmd = "'HOOK 1'";
				sendDataStr(dsp.sendCmd);
			}
			case 06: 
			{
				dsp.sendCmd = 'TE 1 1';
				sendDataStr(dsp.sendCmd);
				send_command dvUI,"'@PPK-atc_incoming_call'";
			}
			case 07: 
			{
				send_command dvUI,"'@PPK-atc_incoming_call'";
				dsp.sendCmd = 'TE 1 1';
				sendDataStr(dsp.sendCmd);
				wait 10 'disconnect_call'
				{
					dsp.sendCmd = 'TE 1 0';
					sendDataStr(dsp.sendCmd);
				}
			}
			case 08: 
			{
				dsp.sendCmd = 'TE 1 0';
				sendDataStr(dsp.sendCmd);
			}
			case 09: {}
			default: {}
		}
	}
}

button_event[dvUI,nUI_PhoneNums_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char digit[2];
		
		idx = get_last(nUI_PhoneNums_Btns);
		
		switch(idx)
		{
			case 01: digit = '0';
			case 02: digit = '1';
			case 03: digit = '2';
			case 04: digit = '3';
			case 05: digit = '4';
			case 06: digit = '5';
			case 07: digit = '6';
			case 08: digit = '7';
			case 09: digit = '8';
			case 10: digit = '9';
			case 11: digit = '*';
			case 12: digit = '#';
			default: {}
		}
		
		dsp.phoneNum = "dsp.phoneNum,digit"
		
		if(dsp.hookstatus == 1)
		{
			fnDialSnglDgt(digit);
		}
		
		send_command dvUI,"'^TXT-98,0,',dsp.phoneNum";
	}
}

button_event[dvUI,nUI_InpVolUp_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref[2];
		
		idx = get_last(nUI_InpVolUp_Btns);
		
		if(dsp.inpLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' I 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		stack_var char ref[2];
		
		idx = get_last(nUI_InpVolUp_Btns);
		
		if(dsp.inpLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' I 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[dvUI,nUI_InpVolDn_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref[2];
		
		idx = get_last(nUI_InpVolDn_Btns);
		
		if(dsp.inpLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' I -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		stack_var char ref[2];
		
		idx = get_last(nUI_InpVolDn_Btns);
		
		if(dsp.inpLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' I -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[dvUI,nUI_InpMute_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref;
		
		idx = get_last(nUI_InpMute_Btns);
		
		if(dsp.inpMut[idx] == 1)
		{
			ref = '0';
		}
		else
		{
			ref = '1';
		}
		
		
		if(idx <= 8)
		{
			dsp.sendCmd = "'MUTE ',itoa(idx),' M ',ref";
		}
		else
		{
			dsp.sendCmd = "'MUTE ',itoa(idx),' L ',ref";
		}
		
		sendDataStr(dsp.sendCmd);
	}
}

button_event[dvUI,nUI_OutVolUp_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_OutVolUp_Btns);
		
		if(dsp.outLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' O 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_OutVolUp_Btns);
		
		if(dsp.outLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' O 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[dvUI,nUI_OutVolDn_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_OutVolDn_Btns);
		
		if(dsp.outLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' O -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_OutVolDn_Btns);
		
		if(dsp.outLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',itoa(idx),' O -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[dvUI,nUI_OutMute_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref;
		
		idx = get_last(nUI_OutMute_Btns);
		
		if(dsp.outMut[idx] == 1)
		{
			ref = '0';
		}
		else
		{
			ref = '1';
		}
		
		dsp.sendCmd = "'MUTE ',itoa(idx),' O ',ref";
		
		sendDataStr(dsp.sendCmd);
	}
}

button_event[dvUI,nUI_AmpMute_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref;
		
		idx = get_last(nUI_AmpMute_Btns);
		
		if(dsp.ampMut[idx] == 1)
		{
			ref = '0';
		}
		else
		{
			ref = '1';
		}
		
		dsp.sendCmd = "'MUTE ',itoa(idx),' J ',ref";
		
		sendDataStr(dsp.sendCmd);
	}
}

button_event[dvUI,nUI_PrsVolUp_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolUp_Btns);
		
		if(dsp.prsLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolUp_Btns);
		
		if(dsp.prsLvl[idx] <= 18)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P 2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[dvUI,nUI_PrsVolDn_Btns]
{
	push:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolDn_Btns);
		
		if(dsp.prsLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
	hold[5,repeat]:
	{
		stack_var integer idx;
		
		idx = get_last(nUI_PrsVolDn_Btns);
		
		if(dsp.prsLvl[idx] >= -62)
		{
			dsp.sendCmd = "'GAIN ',process[idx],' P -2 R'";
			sendDataStr(dsp.sendCmd);
		}
	}
}

button_event[dvUI,nUI_PrsVolMt_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var char ref[2];
		
		idx = get_last(nUI_PrsVolMt_Btns);
		
		if(dsp.prsMut[idx] == 1)
		{
			ref = '0';
		}
		else
		{
			ref = '1';
		}
		
		dsp.sendCmd = "'MUTE ',process[idx],' P ',ref";
		
		sendDataStr(dsp.sendCmd);
	}
}


define_event		// All Timeline Events

timeline_event[tlDataRcv]
{
	if(find_string(dsp.buffer,"$0D,$0A",1))
	{
		stack_var char str[512];
		stack_var char temp[8];
		
		str = remove_string(dsp.buffer,"$0D,$0A",1);
		
		set_length_string(str,length_string(str) - 2);
		
		if(length_string(str) > 2)
		{
			if(find_string(str,'>',1))
			{
				temp = remove_string(str,"$20",1);
			}
			
			if(length_string(str) > 5)
			{
				print(nDbg_Lvl3,"'Sending To parseRcvData() -> ',str");
				
				parseRcvData(str);
			}
		}
	}
	else
	{
		timeline_kill(tlDataRcv);
		
		print(nDbg_Lvl4,"'Timeline "tlDataRcv" Has Terminated'");
		
		clear_buffer dsp.buffer;
	}
}

timeline_event[tlInfoQue]
{
	stack_var integer i;
	stack_var integer j;
	
	j = length_array(QueryCmds);
	i = timeline.sequence;
	
	if(i > j)
	{
		print(nDbg_Lvl4,'Ending tlInfoQue TimeLine');
		CancelQuery();
		QueryUnit();
	}
	else
	{
		if(length_string(QueryCmds[i]) > 0)
		{
			dsp.sendCmd = QueryCmds[i];
			sendDataStr(dsp.sendCmd);
		}
	}
}

timeline_event[tlInfLvls]
{
	stack_var integer i;
	stack_var integer j;
	
	j = length_array(infoLvlCmds);
	i = timeline.sequence;
	
	if(i > j)
	{
		print(nDbg_Lvl4,'Ending tlInfLvls TimeLine');
		timeline_kill(tlInfLvls);
		QueryMutes();
	}
	else
	{
		dsp.sendCmd = infoLvlCmds[i];
		
		if(dsp.sendCmd != '')
		{
			sendDataStr(dsp.sendCmd);
		}
	}
}

timeline_event[tlInfMuts]
{
	stack_var integer i;
	stack_var integer j;
	
	j = length_array(infoMutCmds);
	i = timeline.sequence;
	
	if(i > j)
	{
		print(nDbg_Lvl4,'Ending tlInfMuts TimeLine');
		timeline_kill(tlInfMuts);
		QueryUnit();
	}
	else
	{
		dsp.sendCmd = infoMutCmds[i];
		
		if(dsp.sendCmd != '')
		{
			sendDataStr(dsp.sendCmd);
		}
	}
}

timeline_event[tlCommCnt]
{
	if(!dsp.PrtOnline)
	{
		if(dsp.PrtError)
		{
			switch(dsp.PrtError)
			{
				case 02: {}
				case 04: {}
				case 06: setUpTcpComms(IPAddress, IP_Port);
				case 07: setUpTcpComms(IPAddress, IP_Port);
				case 08: {}
				case 09: {}
				case 14: {}
				case 16: {}
				case 17: {}
				default: {}
			}
		}
		else
		{
			setUpTcpComms(IPAddress, IP_Port);
		}
	}
	else
	{
		timeline_kill(tlCommCnt);
	}
}

define_program

wait 3 'Feedback' 
{
	[dvUI,nUI_PhoneCtrl_Btns[01]] = (dsp.hookstatus == 1);
	
	[vdvDSP,mod_AtcOn] = (dsp.hookstatus == 1);
	
	[dvUI,nUI_InpMute_Btns[01]] = (dsp.inpMut[01]);
	[dvUI,nUI_InpMute_Btns[02]] = (dsp.inpMut[02]);
	[dvUI,nUI_InpMute_Btns[03]] = (dsp.inpMut[03]);
	[dvUI,nUI_InpMute_Btns[04]] = (dsp.inpMut[04]);
	[dvUI,nUI_InpMute_Btns[05]] = (dsp.inpMut[05]);
	[dvUI,nUI_InpMute_Btns[06]] = (dsp.inpMut[06]);
	[dvUI,nUI_InpMute_Btns[07]] = (dsp.inpMut[07]);
	[dvUI,nUI_InpMute_Btns[08]] = (dsp.inpMut[08]);
	[dvUI,nUI_InpMute_Btns[09]] = (dsp.inpMut[09]);
	[dvUI,nUI_InpMute_Btns[10]] = (dsp.inpMut[10]);
	[dvUI,nUI_InpMute_Btns[11]] = (dsp.inpMut[11]);
	[dvUI,nUI_InpMute_Btns[12]] = (dsp.inpMut[12]);
	
	[dvUI,nUI_OutMute_Btns[01]] = (dsp.outMut[01]);
	[dvUI,nUI_OutMute_Btns[02]] = (dsp.outMut[02]);
	[dvUI,nUI_OutMute_Btns[03]] = (dsp.outMut[03]);
	[dvUI,nUI_OutMute_Btns[04]] = (dsp.outMut[04]);
	[dvUI,nUI_OutMute_Btns[05]] = (dsp.outMut[05]);
	[dvUI,nUI_OutMute_Btns[06]] = (dsp.outMut[06]);
	[dvUI,nUI_OutMute_Btns[07]] = (dsp.outMut[07]);
	[dvUI,nUI_OutMute_Btns[08]] = (dsp.outMut[08]);
	[dvUI,nUI_OutMute_Btns[09]] = (dsp.outMut[09]);
	[dvUI,nUI_OutMute_Btns[10]] = (dsp.outMut[10]);
	[dvUI,nUI_OutMute_Btns[11]] = (dsp.outMut[11]);
	[dvUI,nUI_OutMute_Btns[12]] = (dsp.outMut[12]);
	
	[dvUI,nUI_AmpMute_Btns[01]] = (dsp.ampMut[01]);
	[dvUI,nUI_AmpMute_Btns[02]] = (dsp.ampMut[02]);
	[dvUI,nUI_AmpMute_Btns[03]] = (dsp.ampMut[03]);
	[dvUI,nUI_AmpMute_Btns[04]] = (dsp.ampMut[04]);
	
	[dvUI,nUI_PrsVolMt_Btns[01]] = (dsp.prsMut[01]);
	[dvUI,nUI_PrsVolMt_Btns[02]] = (dsp.prsMut[02]);
	[dvUI,nUI_PrsVolMt_Btns[03]] = (dsp.prsMut[03]);
	[dvUI,nUI_PrsVolMt_Btns[04]] = (dsp.prsMut[04]);
	[dvUI,nUI_PrsVolMt_Btns[05]] = (dsp.prsMut[05]);
	[dvUI,nUI_PrsVolMt_Btns[06]] = (dsp.prsMut[06]);
	[dvUI,nUI_PrsVolMt_Btns[07]] = (dsp.prsMut[07]);
	[dvUI,nUI_PrsVolMt_Btns[08]] = (dsp.prsMut[08]);
	
	/////////////////////////////////////////////////
	
	[vdvDSP,nUI_PrsVolMt_Btns[01]] = (dsp.prsMut[01]);
	[vdvDSP,nUI_PrsVolMt_Btns[02]] = (dsp.prsMut[02]);
	[vdvDSP,nUI_PrsVolMt_Btns[03]] = (dsp.prsMut[03]);
	[vdvDSP,nUI_PrsVolMt_Btns[04]] = (dsp.prsMut[04]);
	[vdvDSP,nUI_PrsVolMt_Btns[05]] = (dsp.prsMut[05]);
	[vdvDSP,nUI_PrsVolMt_Btns[06]] = (dsp.prsMut[06]);
	[vdvDSP,nUI_PrsVolMt_Btns[07]] = (dsp.prsMut[07]);
	[vdvDSP,nUI_PrsVolMt_Btns[08]] = (dsp.prsMut[08]);
	
	[vdvDSP,nUI_InpMute_Btns[01]] = (dsp.inpMut[01]);
	[vdvDSP,nUI_InpMute_Btns[02]] = (dsp.inpMut[02]);
	[vdvDSP,nUI_InpMute_Btns[03]] = (dsp.inpMut[03]);
	[vdvDSP,nUI_InpMute_Btns[04]] = (dsp.inpMut[04]);
	[vdvDSP,nUI_InpMute_Btns[05]] = (dsp.inpMut[05]);
	[vdvDSP,nUI_InpMute_Btns[06]] = (dsp.inpMut[06]);
	[vdvDSP,nUI_InpMute_Btns[07]] = (dsp.inpMut[07]);
	[vdvDSP,nUI_InpMute_Btns[08]] = (dsp.inpMut[08]);
	[vdvDSP,nUI_InpMute_Btns[09]] = (dsp.inpMut[09]);
	[vdvDSP,nUI_InpMute_Btns[10]] = (dsp.inpMut[10]);
	[vdvDSP,nUI_InpMute_Btns[11]] = (dsp.inpMut[11]);
	[vdvDSP,nUI_InpMute_Btns[12]] = (dsp.inpMut[12]);
	
	/////////////////////////////////////////////////
	
	dsp.PrtOnline = [vdvDSP,mod_Online];
	dsp.PrtActive = [vdvDSP,mod_DatRcv];
}                                                