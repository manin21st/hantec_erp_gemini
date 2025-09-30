$PBExportHeader$w_imt_10010_01.srw
$PBExportComments$ ===> 주간 구매의뢰 생성
forward
global type w_imt_10010_01 from window
end type
type pb_1 from u_pb_cal within w_imt_10010_01
end type
type p_2 from uo_picture within w_imt_10010_01
end type
type p_1 from uo_picture within w_imt_10010_01
end type
type st_1 from statictext within w_imt_10010_01
end type
type dw_1 from datawindow within w_imt_10010_01
end type
type gb_1 from groupbox within w_imt_10010_01
end type
end forward

global type w_imt_10010_01 from window
integer x = 823
integer y = 360
integer width = 1403
integer height = 956
boolean titlebar = true
string title = "정기발주의뢰 생성"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
pb_1 pb_1
p_2 p_2
p_1 p_1
st_1 st_1
dw_1 dw_1
gb_1 gb_1
end type
global w_imt_10010_01 w_imt_10010_01

on w_imt_10010_01.create
this.pb_1=create pb_1
this.p_2=create p_2
this.p_1=create p_1
this.st_1=create st_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.pb_1,&
this.p_2,&
this.p_1,&
this.st_1,&
this.dw_1,&
this.gb_1}
end on

on w_imt_10010_01.destroy
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;f_window_center(this)

// 구매담당자
datawindowchild state_child1
integer rtncode

rtncode = dw_1.GetChild('empno', state_child1)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 구매")
state_child1.SetTransObject(SQLCA)
state_child1.Retrieve("1", "1", gs_saupj)

dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, "gyymm", gs_code)

/* 부가 사업장 */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		dw_1.Modify("saupj.protect=1")
		dw_1.Modify("saupj.background.color = 80859087")
	End if
End If

dw_1.setfocus()

SetNull( Gs_Code )
end event

type pb_1 from u_pb_cal within w_imt_10010_01
integer x = 859
integer y = 36
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('gyymm')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'gyymm', gs_code)



end event

type p_2 from uo_picture within w_imt_10010_01
integer x = 1184
integer y = 588
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_1 from uo_picture within w_imt_10010_01
integer x = 1024
integer y = 588
string picturename = "C:\erpman\image\구매의뢰_up.gif"
end type

event clicked;call super::clicked;String 	sYymm, sEmpno, sScvcod, sEcvcod, sCalgu, sDelgu, sError, ssaupj

IF dw_1.accepttext() = -1 THEN RETURN 

SetPointer(HourGlass!)

sYymm 	= TRIM(dw_1.getitemstring(1, "gyymm"))
sSaupj	= dw_1.getitemstring(1, "saupj")
sEmpno	= dw_1.getitemstring(1, "empno")
sScvcod	= dw_1.getitemstring(1, "scvcod")
sEcvcod  = dw_1.getitemstring(1, "ecvcod")
sDelgu	= dw_1.getitemstring(1, "Delgu")

IF isnull(syymm) or trim(syymm) = '' then 
	f_message_chk(30, "[기준일자]")
	dw_1.SetColumn("gyymm")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sSaupj) or trim(ssaupj) = '' then 
	f_message_chk(30, "[사업장]")
	dw_1.SetColumn("saupj")
	dw_1.SetFocus()
	RETURN
END IF

IF isnull(sEmpno) or trim(sEmpno) = '' then 
	f_message_chk(30, "[담당자]")
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	RETURN
END IF

if isnull(sSCvcod) or trim(sSCvcod) = '' then sSCvcod = '.'
if isnull(sECvcod) or trim(sEcvcod) = '' then sEcvcod = 'ZZZZZZ'

sError = 'X'

St_1.text = '발주의뢰자료를 생성중입니다...!!'

sqlca.erp000000411(gs_sabu, syymm, sempno, sScvcod, sEcvcod, sDelgu, sSaupj, sError);

If sError = 'X' or sError = 'Y' then
	f_message_chk(41, '[정기발주의뢰]') 
Else
	Messagebox("정기발주", "정상적으로 발주의뢰가 되었읍니다", information!)
end if

st_1.text = ''

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\구매의뢰_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\구매의뢰_up.gif'
end event

type st_1 from statictext within w_imt_10010_01
integer x = 37
integer y = 764
integer width = 1307
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_imt_10010_01
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 37
integer y = 16
integer width = 1339
integer height = 576
integer taborder = 10
string dataobject = "d_imt_10010_01_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.getcolumnname() = "scvcod"	THEN //거래처코드(FROM)		
	open(w_vndmst_popup)
   this.SetItem(1, "scvcod", gs_code)
	return
ELSEIF this.getcolumnname() = "ecvcod"	THEN //거래처코드(TO)		
	open(w_vndmst_popup)
   this.SetItem(1, "ecvcod", gs_code)
	return
END IF
end event

event itemerror;return 1
end event

event itemchanged;sTring scolname, sData, Snull
Long Lrow

SetNull( sNull )

scolname = dwo.name

If sColname = 'gyymm' then
	sData = gettext()
	If f_datechk(sData) = -1 then
		Messagebox("기준일자", "기준일자가 부정확합니다", stopsign!)
		setitem(1, "gyymm", sNull)
		return 1
	End if
	
End if
end event

type gb_1 from groupbox within w_imt_10010_01
integer x = 23
integer y = 732
integer width = 1339
integer height = 124
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

