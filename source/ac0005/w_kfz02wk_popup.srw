$PBExportHeader$w_kfz02wk_popup.srw
$PBExportComments$결산자료 선택
forward
global type w_kfz02wk_popup from window
end type
type cb_3 from commandbutton within w_kfz02wk_popup
end type
type cb_2 from commandbutton within w_kfz02wk_popup
end type
type cb_1 from commandbutton within w_kfz02wk_popup
end type
type p_del from uo_picture within w_kfz02wk_popup
end type
type p_exit from uo_picture within w_kfz02wk_popup
end type
type p_choose from uo_picture within w_kfz02wk_popup
end type
type p_inq from uo_picture within w_kfz02wk_popup
end type
type sle_2 from singlelineedit within w_kfz02wk_popup
end type
type st_3 from statictext within w_kfz02wk_popup
end type
type st_2 from statictext within w_kfz02wk_popup
end type
type dw_1 from u_d_popup_sort within w_kfz02wk_popup
end type
type st_1 from statictext within w_kfz02wk_popup
end type
type sle_1 from singlelineedit within w_kfz02wk_popup
end type
type rr_1 from roundrectangle within w_kfz02wk_popup
end type
type ln_1 from line within w_kfz02wk_popup
end type
type ln_2 from line within w_kfz02wk_popup
end type
type rr_2 from roundrectangle within w_kfz02wk_popup
end type
end forward

global type w_kfz02wk_popup from window
integer x = 1518
integer y = 4
integer width = 2199
integer height = 2256
boolean titlebar = true
string title = "결산자료 선택"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_del p_del
p_exit p_exit
p_choose p_choose
p_inq p_inq
sle_2 sle_2
st_3 st_3
st_2 st_2
dw_1 dw_1
st_1 st_1
sle_1 sle_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_kfz02wk_popup w_kfz02wk_popup

type variables

String sSaupj
end variables

event open;String scode,sname

F_Window_Center_Response(This)

sSaupj = Gs_Gubun

sle_1.text = gs_code
sle_2.text = F_Get_Refferance('AD',sSaupj)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.Retrieve(sSaupj,sle_1.Text+'%')

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

on w_kfz02wk_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_del=create p_del
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.sle_2=create sle_2
this.st_3=create st_3
this.st_2=create st_2
this.dw_1=create dw_1
this.st_1=create st_1
this.sle_1=create sle_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_del,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.sle_2,&
this.st_3,&
this.st_2,&
this.dw_1,&
this.st_1,&
this.sle_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.rr_2}
end on

on w_kfz02wk_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_del)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.sle_2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_2)
end on

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type cb_3 from commandbutton within w_kfz02wk_popup
integer x = 2693
integer y = 588
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type cb_2 from commandbutton within w_kfz02wk_popup
integer x = 2693
integer y = 488
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&V)"
end type

event clicked;p_choose.TriggerEvent(Clicked!)
end event

type cb_1 from commandbutton within w_kfz02wk_popup
integer x = 2688
integer y = 388
integer width = 201
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type p_del from uo_picture within w_kfz02wk_popup
integer x = 1655
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;Integer iCurrYear,iPrvYear
String  sCurrFrom,sCurrTo,sPrvFrom,sPrvTo

if dw_1.RowCount() <=0 then return
if dw_1.GetSelectedRow(0) <=0 then return

iCurrYear = dw_1.GetItemNumber(dw_1.GetSelectedRow(0),"curr_year")
sCurrFrom = dw_1.GetItemString(dw_1.GetSelectedRow(0),"curr_from_date")
sCurrTo   = dw_1.GetItemString(dw_1.GetSelectedRow(0),"curr_to_date")
iPrvYear  = dw_1.GetItemNumber(dw_1.GetSelectedRow(0),"prv_year")
sPrvFrom  = dw_1.GetItemString(dw_1.GetSelectedRow(0),"prv_from_date")
sPrvTo    = dw_1.GetItemString(dw_1.GetSelectedRow(0),"prv_to_date")

IF f_dbconfirm("삭제") = 2 THEN Return

/*재무제표자료*/
delete from kfz02wk
	where saupj = :sSaupj and curr_from_date = :sCurrFrom and curr_to_date = :sCurrTo and
			prv_from_date = :sPrvFrom and prv_to_date = :sPrvTo and curr_year = :iCurrYear and
			prv_year = :iPrvYear ;
commit;

/*월별 추정 재무제표*/
delete from kfz09wk2
	where acyear = :iCurrYear and acymf = substr(:sCurrFrom,1,6) and acymt = substr(:sCurrTo,1,6);
Commit;

p_inq.TriggerEvent(Clicked!)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\삭제_up.gif'
end event

type p_exit from uo_picture within w_kfz02wk_popup
integer x = 2002
integer y = 12
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_kfz02wk_popup
integer x = 1829
integer y = 12
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long  ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

gs_code    = String(dw_1.GetItemNumber(ll_Row, "curr_year"),'000') + &
				 dw_1.GetItemString(ll_Row, "curr_from_date") + &
				 dw_1.GetItemString(ll_Row, "curr_to_date") + &
				 String(dw_1.GetItemNumber(ll_Row, "prv_year"),'000') + &
				 dw_1.GetItemString(ll_Row, "prv_from_date") + &
				 dw_1.GetItemString(ll_Row, "prv_to_date")
Close(Parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfz02wk_popup
integer x = 1481
integer y = 12
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String scode,sname

scode = sle_1.text + "%"

dw_1.SetRedraw(False)
IF dw_1.Retrieve(sSaupj,scode) <= 0 THEN
	F_MessageChk(14,'')
	sle_1.SetFocus()
	dw_1.SetRedraw(True)
	Return
END IF
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()
dw_1.SetRedraw(True)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type sle_2 from singlelineedit within w_kfz02wk_popup
event ue_key pbm_keydown
integer x = 274
integer y = 60
integer width = 471
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

type st_3 from statictext within w_kfz02wk_popup
integer x = 55
integer y = 72
integer width = 247
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "사업장"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_kfz02wk_popup
integer x = 1129
integer y = 72
integer width = 110
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "기"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from u_d_popup_sort within w_kfz02wk_popup
event ue_keyenter pbm_dwnprocessenter
event ue_key pbm_keydown
integer x = 37
integer y = 192
integer width = 2112
integer height = 1844
integer taborder = 40
string dataobject = "dw_kfz02wk_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_keyenter;p_choose.TriggerEvent(Clicked!)
end event

event ue_key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event doubleclicked;
IF row <=0 THEN RETURN

gs_code    = String(dw_1.GetItemNumber(Row, "curr_year"),'000') + &
				 dw_1.GetItemString(Row, "curr_from_date") + &
				 dw_1.GetItemString(Row, "curr_to_date") + &
				 String(dw_1.GetItemNumber(Row, "prv_year"),'000') + &
				 dw_1.GetItemString(Row, "prv_from_date") + &
				 dw_1.GetItemString(Row, "prv_to_date")

Close(Parent)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	sle_1.text = String(dw_1.GetItemNumber(Row,"curr_year"))
	
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

type st_1 from statictext within w_kfz02wk_popup
integer x = 805
integer y = 72
integer width = 169
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "기준"
alignment alignment = center!
long bordercolor = 8421504
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_kfz02wk_popup
event ue_key pbm_keydown
integer x = 974
integer y = 60
integer width = 155
integer height = 68
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

type rr_1 from roundrectangle within w_kfz02wk_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 16
integer width = 1289
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfz02wk_popup
integer linethickness = 1
integer beginx = 279
integer beginy = 132
integer endx = 741
integer endy = 132
end type

type ln_2 from line within w_kfz02wk_popup
integer linethickness = 1
integer beginx = 969
integer beginy = 132
integer endx = 1129
integer endy = 132
end type

type rr_2 from roundrectangle within w_kfz02wk_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 184
integer width = 2130
integer height = 1864
integer cornerheight = 40
integer cornerwidth = 55
end type

