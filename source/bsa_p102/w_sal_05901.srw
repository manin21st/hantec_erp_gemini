$PBExportHeader$w_sal_05901.srw
$PBExportComments$무상공급 현황(SPEC)
forward
global type w_sal_05901 from w_standard_print
end type
end forward

global type w_sal_05901 from w_standard_print
string title = "무상공급 현황"
long backcolor = 79741120
end type
global w_sal_05901 w_sal_05901

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFRom, sTo

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[판매기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

SetPointer(HourGlass!)

IF dw_list.Retrieve(gs_sabu, sFrom+'01', sTo+'31') <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
END IF

Return 1
end function

on w_sal_05901.create
call super::create
end on

on w_sal_05901.destroy
call super::destroy
end on

event open;call super::open;dw_ip.SetItem(1,"sdatef", Left(is_today,4)+'01')
dw_ip.SetItem(1,"sdatet", Left(is_today,6))

dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_sal_05901
end type

type p_exit from w_standard_print`p_exit within w_sal_05901
end type

type p_print from w_standard_print`p_print within w_sal_05901
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05901
end type











type dw_print from w_standard_print`dw_print within w_sal_05901
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05901
integer x = 46
integer y = 104
integer width = 750
integer height = 256
string dataobject = "d_sal_059011"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::ue_key;call super::ue_key;string sCol

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	
end event

type dw_list from w_standard_print`dw_list within w_sal_05901
integer x = 823
integer y = 16
integer width = 2811
integer height = 2060
string dataobject = "d_sal_05901"
end type

