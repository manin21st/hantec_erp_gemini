$PBExportHeader$w_imt_04730.srw
$PBExportComments$제작 의뢰 진행 현황
forward
global type w_imt_04730 from w_standard_print
end type
end forward

global type w_imt_04730 from w_standard_print
string title = "제작 의뢰 진행 현황"
end type
global w_imt_04730 w_imt_04730

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sKestgub, sMjgub, sMakgub

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sKestgub    = Trim(dw_ip.GetItemString(1,"kestgub"))
sMjgub      = Trim(dw_ip.GetItemString(1,"mjgub"))
sMakgub     = Trim(dw_ip.GetItemString(1,"makgub"))

If IsNull(sKestgub) or sKestgub = '' then sKestgub = ''
If IsNull(sMjgub)   or sMjgub   = '' then sMjgub   = ''

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(35,'[의뢰기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(35,'[의뢰기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If sMakgub = '1' Then
	dw_list.DataObject = 'd_imt_047301'
Else
	dw_list.DataObject = 'd_imt_047302'
End If
dw_list.SetTransObject(SQLCA)

IF dw_list.Retrieve(gs_sabu, sFrom, sTo, sKestgub+'%', sMjgub+'%') <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

Return 1
end function

on w_imt_04730.create
call super::create
end on

on w_imt_04730.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1,'sdatef',left(f_today(),6) +'01')
dw_ip.setitem(1,'sdatet',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_imt_04730
end type

type p_exit from w_standard_print`p_exit within w_imt_04730
end type

type p_print from w_standard_print`p_print within w_imt_04730
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04730
end type







type dw_ip from w_standard_print`dw_ip within w_imt_04730
integer height = 928
string dataobject = "d_imt_04730"
end type

event dw_ip::itemchanged;String sNull, sDateFrom, sDateTo

SetNull(snull)

Choose Case GetColumnName() 
	Case"sdatef"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[의뢰기간]')
			this.SetItem(1,"sdatef",snull)
			Return 1
		END IF
	Case "sdatet"
		sDateTo = Trim(this.GetText())
		IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
		
		IF f_datechk(sDateTo) = -1 THEN
			f_message_chk(35,'[의뢰기간]')
			this.SetItem(1,"sdatet",snull)
			Return 1
		END IF
End Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_04730
string dataobject = "d_imt_047301"
end type

