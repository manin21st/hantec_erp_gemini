$PBExportHeader$w_pdm_01000a.srw
$PBExportComments$구분코드 등록
forward
global type w_pdm_01000a from window
end type
type p_close from picture within w_pdm_01000a
end type
type p_ok from picture within w_pdm_01000a
end type
type dw_insert from datawindow within w_pdm_01000a
end type
type rr_1 from roundrectangle within w_pdm_01000a
end type
end forward

global type w_pdm_01000a from window
integer x = 837
integer y = 672
integer width = 1481
integer height = 704
boolean titlebar = true
string title = "구분코드 등록"
windowtype windowtype = response!
long backcolor = 32106727
p_close p_close
p_ok p_ok
dw_insert dw_insert
rr_1 rr_1
end type
global w_pdm_01000a w_pdm_01000a

type variables
string sGucode
end variables

event open;dw_insert.SetTransObject(sqlca)
dw_insert.Reset()
dw_insert.Insertrow(0)

dw_insert.SetFocus()
end event

on w_pdm_01000a.create
this.p_close=create p_close
this.p_ok=create p_ok
this.dw_insert=create dw_insert
this.rr_1=create rr_1
this.Control[]={this.p_close,&
this.p_ok,&
this.dw_insert,&
this.rr_1}
end on

on w_pdm_01000a.destroy
destroy(this.p_close)
destroy(this.p_ok)
destroy(this.dw_insert)
destroy(this.rr_1)
end on

type p_close from picture within w_pdm_01000a
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 1239
integer y = 440
integer width = 178
integer height = 144
integer taborder = 30
string pointer = "c:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event clicked;CloseWithReturn(PARENT,'0')
end event

type p_ok from picture within w_pdm_01000a
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 1061
integer y = 440
integer width = 178
integer height = 144
integer taborder = 20
string pointer = "c:\erpman\cur\confirm.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event clicked;String sRfCod,sRfname

if dw_insert.AcceptText() = -1 then return
sRfCod  = dw_insert.GetItemString(1,"rfcod")
sRfName = dw_insert.GetItemString(1,"rfna1")

IF sRfCod = '' OR IsNull(sRfCod) THEN
	F_MessageChk(1,'[구분코드]')
	dw_insert.Setcolumn("rfcod")
	dw_insert.Setfocus()
	Return
END IF
IF sRfName = '' OR IsNull(sRfName) THEN
	F_MessageChk(1,'[구분명칭]')
	dw_insert.Setcolumn("rfna1")
	dw_insert.Setfocus()
	Return
END IF
IF dw_insert.Update() <> 1 then
	F_MessageChk(13,'')
	Rollback;
	Return
END IF
Commit;

CloseWithReturn(parent,'1')
end event

type dw_insert from datawindow within w_pdm_01000a
event ue_enter pbm_dwnprocessenter
integer x = 105
integer y = 68
integer width = 1271
integer height = 304
integer taborder = 10
string dataobject = "d_pdm_01000a_1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event itemchanged;String   sRfCod,sNull
Integer  iDbCnt

SetNull(sNull)

IF this.GetColumnName() = "rfcod" THEN
	sRfCod = this.GetText()
	IF sRfCod = '' OR IsNull(sRfCod) THEN Return
	
	select Count(*) 	into :iDbCnt  from reffpf where rfcod = :sRfCod and rfgub = '00';
	if sqlca.sqlcode = 0 and iDbCnt > 0 then
		F_MessageChk(10,'')
		this.SetItem(this.GetRow(),"rfcod",sNull)
		Return 1
	end if
END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rfna1" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type rr_1 from roundrectangle within w_pdm_01000a
integer linethickness = 1
long fillcolor = 33027312
integer x = 73
integer y = 28
integer width = 1344
integer height = 404
integer cornerheight = 40
integer cornerwidth = 55
end type

