program_name = 'stdui'
(***********************************************************)
(*  FILE CREATED ON: 11/04/2013  AT: 09:07:59              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 11/05/2013  AT: 11:17:29        *)
(***********************************************************)

#if_not_defined daGUI

define_constant

dev daGUI[] =
{
	10001:01:000,
	10002:01:000,
	10003:01:000,
	10004:01:000,
	10005:01:000,
	10006:01:000
}

integer MaxGUI	= 05;

#end_if

define_constant

integer msgCONFIRM	= 01;
integer msgQUESTION = 02;
integer msgWARNING	= 03;
integer msgERRORS		= 04;

integer UI_P1_MsgBox_Btns[] =
{
	201, //
	202, //
	203, //
	204, // OK
	205, // CANCEL
	206, // YES
	207, // NO
	208, // Heading
	209, // Message
	210  
}

#if_not_defined _GUI

define_type

struct _GUI
{
	char zone[16];		// Name Of Zone UI Is Located In
	char alert;
}

define_variable

persistent _GUI GUI[MaxGUI];

#end_if

define_function messageBox(integer UI, integer TYPE, char MESSAGE[])
{
	stack_var integer udx;
	stack_var integer idx;
	stack_var char str[128];
	stack_var char hdr[32];
	
	udx = UI;
	idx = TYPE;
	str = MESSAGE;

	switch(idx) // Header Text
	{
		case msgCONFIRM	: hdr = 'Please Confirm';
		case msgQUESTION: hdr = 'Question From AMX Controller'; 
		case msgWARNING	: hdr = 'System Warning';
		case msgERRORS	: hdr = 'System Reporting Errors';
	} 
	
	if(udx > 0)
	{
		send_command daGUI[udx],"'^SHO-204.207,0'";
		
		switch(idx)	// Select Required Buttons
		{
			case msgCONFIRM	: send_command daGUI[udx],"'^SHO-206.207,1'";
			case msgQUESTION: send_command daGUI[udx],"'^SHO-206.207,1'";
			case msgWARNING	: send_command daGUI[udx],"'^SHO-204.205,1'";
			case msgERRORS	: send_command daGUI[udx],"'^SHO-204.205,1'";
		}
		
		send_command daGUI[udx],"'^TXT-',itoa(UI_P1_MsgBox_Btns[08]),',0,',hdr";
		send_command daGUI[udx],"'^TXT-',itoa(UI_P1_MsgBox_Btns[09]),',0,',str";
		send_command daGUI[udx],"'@PPN-MessageBox'";
	}
	else
	{
		send_command daGUI,"'^SHO-204.207,0'";
		
		switch(idx)	// Select Required Buttons
		{
			case msgCONFIRM	: send_command daGUI,"'^SHO-206.207,1'";
			case msgQUESTION: send_command daGUI,"'^SHO-206.207,1'";
			case msgWARNING	: send_command daGUI,"'^SHO-204.205,1'";
			case msgERRORS	: send_command daGUI,"'^SHO-204.205,1'";
		}
		
		send_command daGUI,"'^TXT-',itoa(UI_P1_MsgBox_Btns[08]),',0,',hdr";
		send_command daGUI,"'^TXT-',itoa(UI_P1_MsgBox_Btns[09]),',0,',str";
		send_command daGUI,"'@PPN-MessageBox'";
	}
}

define_event

data_event[daGUI]
{
	online:
	{
	
	}
	offline:
	{
	
	}
	string:
	{
	
	}
}	

define_event

button_event[daGUI,UI_P1_MsgBox_Btns]
{
	push:
	{
		stack_var integer idx;
		stack_var integer udx;
		
		idx = get_last(UI_P1_MsgBox_Btns);
		udx = get_last(daGUI);
		
		GUI[udx].ALERT = true;
		
		switch(idx)
		{
			case 01:
			{
			}
			case 02:
			{
			
			}
			case 03:
			{
			
			}
		}
	}
}