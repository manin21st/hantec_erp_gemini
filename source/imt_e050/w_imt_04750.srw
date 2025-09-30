$PBExportHeader$w_imt_04750.srw
$PBExportComments$수리의뢰 유형분석
forward
global type w_imt_04750 from w_standard_print
end type
end forward

global type w_imt_04750 from w_standard_print
string title = "수리의뢰 유형분석"
end type
global w_imt_04750 w_imt_04750

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(35,'[기준년도]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(gs_sabu, sFrom) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

Return 1
end function

on w_imt_04750.create
call super::create
end on

on w_imt_04750.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_imt_04750
end type

type p_exit from w_standard_print`p_exit within w_imt_04750
end type

type p_print from w_standard_print`p_print within w_imt_04750
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04750
end type







type dw_ip from w_standard_print`dw_ip within w_imt_04750
integer y = 100
integer height = 576
string dataobject = "d_imt_047503"
end type

event dw_ip::itemchanged;call super::itemchanged;String sNull, sDateFrom, sDateTo

SetNull(snull)

Choose Case GetColumnName() 
	Case 'prtgbn'
		If Trim(GetText()) = '1' Then
			dw_list.Object.rpt_1.DataObject='d_imt_047501'
			dw_list.SetTransObject(SQLCA)
		Else
			dw_list.Object.rpt_1.DataObject='d_imt_047502'
			dw_list.SetTransObject(SQLCA)
		End If
		dw_list.SetRedraw(True)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_imt_04750
string dataobject = "d_imt_04750"
end type

