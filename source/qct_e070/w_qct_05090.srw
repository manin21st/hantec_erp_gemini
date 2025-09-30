$PBExportHeader$w_qct_05090.srw
$PBExportComments$계측기 정기점검 계획생성
forward
global type w_qct_05090 from w_inherite
end type
type gb_2 from groupbox within w_qct_05090
end type
type gb_1 from groupbox within w_qct_05090
end type
type cb_add from commandbutton within w_qct_05090
end type
type st_2 from statictext within w_qct_05090
end type
type st_3 from statictext within w_qct_05090
end type
end forward

global type w_qct_05090 from w_inherite
integer width = 3657
integer height = 2404
string title = "계측기 정기 점검 계획 생성"
long backcolor = 12632256
gb_2 gb_2
gb_1 gb_1
cb_add cb_add
st_2 st_2
st_3 st_3
end type
global w_qct_05090 w_qct_05090

on w_qct_05090.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.gb_1=create gb_1
this.cb_add=create cb_add
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.cb_add
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
end on

on w_qct_05090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.cb_add)
destroy(this.st_2)
destroy(this.st_3)
end on

event open;call super::open;dw_insert.InsertRow(0)
dw_insert.SetItem(1, 'sdate', is_today)
dw_insert.SetItem(1, 'edate', left(is_today, 4))
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_05090
integer x = 1129
integer y = 560
integer width = 1403
integer height = 268
string dataobject = "d_qct_05090_01"
boolean livescroll = false
end type

event dw_insert::itemchanged;//String s_cod
//
//s_cod = Trim(this.GetText())
//
////if this.getcolumnname() = "yyyy" then //기준년도 
////	if IsNull(s_cod) or s_cod = ""  then
////		f_message_chk(35, "[기준년도]")
////		return 1 
////	end if
////end if
//
//if this.getcolumnname() = "year" then //기준년도 
//	if IsNull(s_cod) or s_cod = ""  then
//		f_message_chk(35, "[기준년도]")
//		return 1 
//	end if
//end if
//
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::getfocus;call super::getfocus;sle_msg.text = ""
end event

type cb_exit from w_inherite`cb_exit within w_qct_05090
integer x = 3205
integer y = 1936
integer taborder = 30
end type

event cb_exit::clicked;close(parent)
end event

type cb_mod from w_inherite`cb_mod within w_qct_05090
boolean visible = false
integer x = 1870
integer y = 1936
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_qct_05090
boolean visible = false
integer x = 503
integer y = 2104
integer taborder = 70
end type

type cb_del from w_inherite`cb_del within w_qct_05090
boolean visible = false
integer x = 1522
integer y = 1936
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qct_05090
boolean visible = false
integer x = 73
integer y = 1936
integer taborder = 90
end type

type cb_print from w_inherite`cb_print within w_qct_05090
boolean visible = false
integer x = 869
integer y = 2096
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_qct_05090
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_05090
boolean visible = false
integer x = 2217
integer y = 1936
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_qct_05090
integer x = 2839
integer y = 1936
integer width = 334
integer taborder = 20
string text = "생성(&E)"
end type

event cb_search::clicked;call super::clicked;String sdate, edate, sGubun
double dError

if dw_insert.AcceptText() = -1 then 
	dw_insert.SetFocus()
	return -1
end if	

sdate  = Trim(dw_insert.object.sdate[1])
edate  = Trim(dw_insert.object.edate[1])
sGubun = dw_insert.object.gubun[1]

if IsNull(sdate) or sdate = "" then
	f_message_chk(1400, "[기간 FROM]")
	dw_insert.SetColumn("sdate")
	dw_insert.SetFocus()
	return
end if	

if IsNull(edate) or edate = "" then
	f_message_chk(1400, "[기간 TO]")
	dw_insert.SetColumn("edate")
	dw_insert.SetFocus()
	return
else
	edate = edate + '1231'
end if	


if Messagebox("주 의","기존 계획을 삭제후 재생성 합니다!~n~n" + &
                      "진행 하시겠습니까?",Question!,YesNo!,1) <> 1 then 
	sle_msg.text = "생성작업이 취소되었습니다!"						 
	return
else
	sle_msg.text = ""
end if

dError = 0

setpointer(hourglass!)
    
// Stored Procedure call
sqlca.erp000000280(gs_sabu, sdate, edate, sGubun, dError)

setpointer(Arrow!)

If dError < 0 then
	f_message_chk(39, '[ 계측기 정기점검 계획 생성]') 
Else
	MessageBox("생성 완료","총 " + String(dError) + "건의 자료가 생성되었습니다!")
end if

end event



type sle_msg from w_inherite`sle_msg within w_qct_05090
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_05090
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_05090
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05090
end type

type gb_2 from groupbox within w_qct_05090
integer x = 37
integer y = 8
integer width = 3552
integer height = 1860
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qct_05090
integer x = 2789
integer y = 1868
integer width = 800
integer height = 200
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type cb_add from commandbutton within w_qct_05090
boolean visible = false
integer x = 1175
integer y = 1936
integer width = 334
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

type st_2 from statictext within w_qct_05090
integer x = 1111
integer y = 248
integer width = 1408
integer height = 100
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "계측기 정기 점검 계획 생성"
boolean focusrectangle = false
end type

type st_3 from statictext within w_qct_05090
integer x = 1088
integer y = 1268
integer width = 1376
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "(주의) 기존 계획을 삭제후 재생성 합니다"
boolean focusrectangle = false
end type

