$PBExportHeader$w_pdt_06030.srw
$PBExportComments$정기 점검  계획 생성
forward
global type w_pdt_06030 from w_inherite
end type
type cb_add from commandbutton within w_pdt_06030
end type
type st_2 from statictext within w_pdt_06030
end type
type st_3 from statictext within w_pdt_06030
end type
type rr_1 from roundrectangle within w_pdt_06030
end type
end forward

global type w_pdt_06030 from w_inherite
integer width = 4649
string title = "설비 정기 점검 계획 생성"
cb_add cb_add
st_2 st_2
st_3 st_3
rr_1 rr_1
end type
global w_pdt_06030 w_pdt_06030

on w_pdt_06030.create
int iCurrent
call super::create
this.cb_add=create cb_add
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdt_06030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_add)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.InsertRow(0)
dw_insert.SetItem(1, 'sdate', left(is_today, 6))
dw_insert.SetItem(1, 'edate', left(is_today, 6))
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_06030
integer x = 1481
integer y = 664
integer width = 1518
integer height = 668
integer taborder = 10
string dataobject = "d_pdt_06030_01"
boolean border = false
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

type p_delrow from w_inherite`p_delrow within w_pdt_06030
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06030
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06030
integer x = 3255
integer y = 96
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;call super::clicked;String sdate, edate, sGubun
double dError

if dw_insert.AcceptText() = -1 then 
	dw_insert.SetFocus()
	return -1
end if	

sdate  = Trim(dw_insert.object.sdate[1])
edate  = Trim(dw_insert.object.edate[1])
sGubun = dw_insert.object.gubun[1]

if IsNull(sdate) or sdate = "" then
	f_message_chk(1400, "[년월]")
	dw_insert.SetColumn("sdate")
	dw_insert.SetFocus()
	return
end if	

//if IsNull(edate) or edate = "" then
//	f_message_chk(1400, "[기간 TO]")
//	dw_insert.SetColumn("edate")
//	dw_insert.SetFocus()
//	return
//else
//	edate = edate + '1231'
//end if	

edate = sdate + '31'
if Messagebox("주 의","기존 계획을 삭제후 재생성 합니다!~n~n" + &
                      "진행 하시겠습니까?",Question!,YesNo!,1) <> 1 then 
	sle_msg.text = "생성작업이 취소되었습니다!"						 
	return
else
	sle_msg.text = ""
end if

dError = 0

setpointer(hourglass!)
//messagebox("",sdate + '-' + edate + '-' + sgubun)
// Stored Procedure call
sqlca.erp000000280(gs_sabu, sdate, edate, sGubun, dError)
//messagebox("",string(dError))
setpointer(Arrow!)

If dError < 0 then
	f_message_chk(39, '[설비 정기 점검 계획 생성]') 
Else
	MessageBox("생성 완료","총 " + String(dError) + "건의 자료가 생성되었습니다!")
end if

end event

type p_ins from w_inherite`p_ins within w_pdt_06030
integer x = 2263
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06030
integer x = 3429
integer y = 96
end type

type p_can from w_inherite`p_can within w_pdt_06030
integer x = 3131
integer y = 5000
end type

type p_print from w_inherite`p_print within w_pdt_06030
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06030
integer x = 2089
integer y = 5000
end type

type p_del from w_inherite`p_del within w_pdt_06030
integer x = 2958
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_06030
integer x = 2784
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_pdt_06030
integer x = 2848
integer y = 5000
integer taborder = 30
end type

event cb_exit::clicked;close(parent)
end event

type cb_mod from w_inherite`cb_mod within w_pdt_06030
integer x = 2341
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06030
integer x = 503
integer y = 2104
integer taborder = 70
end type

type cb_del from w_inherite`cb_del within w_pdt_06030
integer x = 1989
integer y = 5000
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06030
integer x = 1275
integer y = 5000
integer taborder = 90
end type

type cb_print from w_inherite`cb_print within w_pdt_06030
integer x = 869
integer y = 2096
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_pdt_06030
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06030
integer x = 2738
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_pdt_06030
integer x = 2912
integer y = 5000
integer width = 334
integer taborder = 20
string text = "생성(&E)"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_06030
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06030
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06030
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06030
end type

type cb_add from commandbutton within w_pdt_06030
boolean visible = false
integer x = 1646
integer y = 5000
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

type st_2 from statictext within w_pdt_06030
integer x = 1755
integer y = 476
integer width = 1248
integer height = 100
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "설비 점검 계획 생성"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_06030
integer x = 1605
integer y = 1452
integer width = 1376
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 134217857
long backcolor = 33027312
boolean enabled = false
string text = "(주의) 기존 계획을 삭제후 재생성 합니다"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_06030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 928
integer y = 280
integer width = 2674
integer height = 1412
integer cornerheight = 40
integer cornerwidth = 55
end type

