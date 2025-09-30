$PBExportHeader$w_qct_04520.srw
$PBExportComments$** A/S처리결과통보서
forward
global type w_qct_04520 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_04520
end type
end forward

global type w_qct_04520 from w_standard_print
string title = "A/S 처리결과 통보서"
rr_1 rr_1
end type
global w_qct_04520 w_qct_04520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string jpno1, jpno2, uses

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

jpno1 = trim(dw_ip.object.jpno1[1])
jpno2 = trim(dw_ip.object.jpno2[1])
uses = trim(dw_ip.object.uses[1])

if (IsNull(jpno1) or jpno1 = "")  then jpno1 = "."
if (IsNull(jpno2) or jpno2 = "")  then jpno2 = "ZZZZZZZZZZZZ"
if (IsNull(uses) or uses = "")  then 
	f_message_chk(30, "[용도]")
	dw_ip.SetColumn("uses")
	dw_ip.SetFocus()
	return -1
end if

dw_list.SetRedraw(False)
if uses = "1" then //고객용
	dw_list.DataObject = "d_qct_04520_02"
	dw_print.DataObject = "d_qct_04520_02_p"
else
	dw_list.DataObject = "d_qct_04520_03"	
	dw_print.DataObject = "d_qct_04520_03_p"
end if	
dw_list.SetRedraw(True)
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

IF dw_print.Retrieve(gs_sabu, jpno1, jpno2) <= 0 then
	f_message_chk(50,'[A/S 처리결과 통보서]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
//	Return -1
END IF

dw_print.insertrow(0)
dw_print.ShareData(dw_list)

return 1
end function

on w_qct_04520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_04520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_04520
end type

type p_exit from w_standard_print`p_exit within w_qct_04520
end type

type p_print from w_standard_print`p_print within w_qct_04520
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04520
end type







type st_10 from w_standard_print`st_10 within w_qct_04520
end type



type dw_print from w_standard_print`dw_print within w_qct_04520
string dataobject = "d_qct_04520_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04520
integer x = 421
integer y = 44
integer width = 1490
integer height = 208
string dataobject = "d_qct_04520_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "jpno1" then // A/S 처리번호
	open(w_asrslno_popup)
   this.object.jpno1[1] = gs_code
elseif this.getcolumnname() = "jpno2" then // A/S 처리번호
	open(w_asrslno_popup)
   this.object.jpno2[1] = gs_code
end if	
return
end event

type dw_list from w_standard_print`dw_list within w_qct_04520
integer x = 443
integer y = 268
integer width = 3717
integer height = 2044
string dataobject = "d_qct_04520_02"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_qct_04520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 430
integer y = 256
integer width = 3739
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

