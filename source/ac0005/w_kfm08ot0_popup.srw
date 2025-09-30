$PBExportHeader$w_kfm08ot0_popup.srw
$PBExportComments$할인은행 조회선택
forward
global type w_kfm08ot0_popup from window
end type
type cb_3 from commandbutton within w_kfm08ot0_popup
end type
type cb_2 from commandbutton within w_kfm08ot0_popup
end type
type cb_1 from commandbutton within w_kfm08ot0_popup
end type
type p_exit from uo_picture within w_kfm08ot0_popup
end type
type p_choose from uo_picture within w_kfm08ot0_popup
end type
type p_inq from uo_picture within w_kfm08ot0_popup
end type
type st_2 from statictext within w_kfm08ot0_popup
end type
type dw_1 from u_d_popup_sort within w_kfm08ot0_popup
end type
type sle_name from singlelineedit within w_kfm08ot0_popup
end type
type sle_1 from singlelineedit within w_kfm08ot0_popup
end type
type st_1 from statictext within w_kfm08ot0_popup
end type
type rr_1 from roundrectangle within w_kfm08ot0_popup
end type
type ln_1 from line within w_kfm08ot0_popup
end type
type ln_2 from line within w_kfm08ot0_popup
end type
type rr_2 from roundrectangle within w_kfm08ot0_popup
end type
end forward

global type w_kfm08ot0_popup from window
integer x = 357
integer y = 160
integer width = 3328
integer height = 2272
boolean titlebar = true
string title = "할인은행 조회"
windowtype windowtype = response!
long backcolor = 32106727
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
p_exit p_exit
p_choose p_choose
p_inq p_inq
st_2 st_2
dw_1 dw_1
sle_name sle_name
sle_1 sle_1
st_1 st_1
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_kfm08ot0_popup w_kfm08ot0_popup

type variables
string sCusGbn
end variables

event open;String ls_saup,saup_nm, ls_string

F_Window_Center_Response(This)

sCusGbn = Message.StringParm

ls_string = f_nvl(lstr_custom.code, "")

If Len(ls_string) > 0 Then
	Choose Case Asc(ls_string)
		//숫자 - 코드
		Case is < 65
			sle_1.text = ls_string

		//문자 - 명칭
		Case is >= 65
			sle_name.text = ls_string

	End Choose
End If

String sHalGbn

select substr(nvl(dataname,'1'),1,1) into :sHalGbn from syscnfg where sysgu = 'A' and serial = 16 and lineno = '2' ;
if sHalGbn = '1' then
	dw_1.DataObject = 'dw_kfm08ot0_popup1'
elseif sHalGbn = '2' then
	dw_1.DataObject = 'dw_kfm08ot0_popup2'
else
	dw_1.DataObject = 'dw_kfm08ot0_popup3'
end if
	
dw_1.SetTransObject(SQLCA)
dw_1.Reset()

p_inq.triggerevent(clicked!)

if dw_1.rowcount() = 1 then
	p_choose.triggerevent(clicked!)
end if







end event

on w_kfm08ot0_popup.create
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_exit=create p_exit
this.p_choose=create p_choose
this.p_inq=create p_inq
this.st_2=create st_2
this.dw_1=create dw_1
this.sle_name=create sle_name
this.sle_1=create sle_1
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.Control[]={this.cb_3,&
this.cb_2,&
this.cb_1,&
this.p_exit,&
this.p_choose,&
this.p_inq,&
this.st_2,&
this.dw_1,&
this.sle_name,&
this.sle_1,&
this.st_1,&
this.rr_1,&
this.ln_1,&
this.ln_2,&
this.rr_2}
end on

on w_kfm08ot0_popup.destroy
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.p_inq)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.sle_name)
destroy(this.sle_1)
destroy(this.st_1)
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

type cb_3 from commandbutton within w_kfm08ot0_popup
integer x = 3611
integer y = 624
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

type cb_2 from commandbutton within w_kfm08ot0_popup
integer x = 3611
integer y = 524
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

type cb_1 from commandbutton within w_kfm08ot0_popup
integer x = 3607
integer y = 424
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

type p_exit from uo_picture within w_kfm08ot0_popup
integer x = 3113
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

Close(Parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_kfm08ot0_popup
integer x = 2939
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

lstr_custom.code   = dw_1.GetItemString(ll_Row, "bnk_cd")
lstr_custom.name   = dw_1.GetItemString(ll_Row, "bnkname")
lstr_custom.gubun  = dw_1.GetItemString(ll_Row, "saup_no")

close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type p_inq from uo_picture within w_kfm08ot0_popup
integer x = 2766
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String ls_saup_no,ls_saupnm

ls_saup_no = sle_1.text + "%"
ls_saupnm ="%"+Trim(sle_name.text)+"%"

dw_1.SetRedraw(False)
IF dw_1.Retrieve(ls_saup_no,ls_saupnm,scusgbn) <=0 THEN
	MessageBox("확  인","해당하는 구분에 거래처가 존재하지 않습니다.!!!")
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

type st_2 from statictext within w_kfm08ot0_popup
integer x = 599
integer y = 56
integer width = 165
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "명칭"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from u_d_popup_sort within w_kfm08ot0_popup
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 164
integer width = 3218
integer height = 1888
integer taborder = 40
string dataobject = "dw_kfm08ot0_popup1"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;
p_choose.triggerEvent(Clicked!)
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

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag = True
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	sle_1.text =dw_1.GetItemString(Row,"bnk_cd")
	sle_name.text =dw_1.GetItemString(Row,"kfz04om0_person_nm")

	b_flag = False
END IF



int li_idx,li_loc, li_i
long ll_clickedrow, ll_cur_row
String ls_raised = '6' , ls_lowered = '5' 
string ls_keydowntype,ls_dwobject, ls_tabkey = '~t', ls_dwobject_name
String ls_modify, ls_setsort, ls_rc, ls_sort_title, ls_col_no
DataWindow dw_sort

SetPointer(HourGlass!)

ls_dwobject = GetObjectAtPointer()
li_loc = Pos(ls_dwobject, ls_tabkey)
If li_loc = 0 Then Return
ls_dwobject_name = Left(ls_dwobject, li_loc - 1)

if Right(ls_dwobject_name,2) <> '_t' then return
   
IF b_flag =False THEN 
	b_flag =True
	RETURN
END IF 

If ls_dwobject_name = 'type'  Then
	If Describe(ls_dwobject_name + ".border") = ls_lowered Then
		ls_modify = ls_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'오름차순'"
	Else
		ls_modify = ls_dwobject_name + ".border=" + ls_lowered
		ls_modify = ls_modify + " " + ls_dwobject_name + &
		 ".text=" + "'내림차순'"
	End If

	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("dwModify", ls_rc + " : " + ls_modify)
		Return
	End If
	uf_sort(is_old_dwobject_name)
	Return
End If

If is_old_dwobject_name <> ls_dwobject_name Then 
	If uf_sort(ls_dwobject_name) = -1 Then Return
	If is_old_dwobject_name = "" Then
		ls_col_no = String(Describe("datawindow.column.count"))
		For li_i = 1 To Integer(ls_col_no)
			If Describe("#" + ls_col_no + ".border") = ls_lowered Then
				is_old_dwobject_name = Describe("#" + ls_col_no + &
				 + ".name") + "_t"
				is_old_color = Describe(is_old_dwobject_name + ".color")
				Exit
			End If
		Next
	End If
	If is_old_dwobject_name <> "" Then
		ls_modify = is_old_dwobject_name + ".border=" + ls_raised
		ls_modify = ls_modify + " " + &
		 is_old_dwobject_name + ".color=" + is_old_color
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			MessageBox("dwModify", ls_rc + " : " + ls_modify)
			Return
		End If
	End If
	is_old_color = Describe(ls_dwobject_name + ".color")
	ls_modify = ls_dwobject_name + ".border=" + ls_lowered
	ls_modify = ls_modify + " " + &
	 ls_dwobject_name + ".color=" + String(RGB(0, 0, 128))
	ls_rc = Modify(ls_modify)
	If ls_rc <> "" Then
		MessageBox("Modify", ls_rc + " : " + ls_modify)
		Return
	End If

	is_old_dwobject_name = ls_dwobject_name
End If

end event

event doubleclicked;call super::doubleclicked;
IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

lstr_custom.code   = dw_1.GetItemString(Row, "bnk_cd")
lstr_custom.name   = dw_1.GetItemString(Row, "bnkname")
lstr_custom.gubun  = dw_1.GetItemString(Row, "saup_no")

close(parent)
end event

type sle_name from singlelineedit within w_kfm08ot0_popup
event ue_key pbm_keydown
integer x = 768
integer y = 48
integer width = 1303
integer height = 64
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_kor(Handle(this))
end event

event modified;String ls_saup_no,ls_saupnm

ls_saup_no = sle_1.text + "%"
ls_saupnm ="%"+Trim(sle_name.text)+"%"

if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve(ls_saup_no,ls_saupnm)
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   end if
end if

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.SetFocus()

end event

type sle_1 from singlelineedit within w_kfm08ot0_popup
event ue_key pbm_keydown
integer x = 224
integer y = 48
integer width = 279
integer height = 64
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
integer limit = 6
end type

event ue_key;choose case key
	case keyenter!
		p_inq.TriggerEvent(Clicked!)
end choose
end event

event getfocus;
f_toggle_eng(Handle(this))
end event

event modified;if KeyDown(KeyEnter!)  = TRUE then 
   dw_1.Retrieve( sle_1.TEXT + "%" ,  "%" )
   if dw_1.RowCount() <= 0 then
      MessageBox("확 인","조회할 자료가 없습니다.!!!")
		Return
   else
      sle_1.SetFocus()
   end if
end if

end event

type st_1 from statictext within w_kfm08ot0_popup
integer x = 55
integer y = 56
integer width = 169
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "코드"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfm08ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 16
integer width = 2089
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfm08ot0_popup
integer linethickness = 1
integer beginx = 229
integer beginy = 112
integer endx = 503
integer endy = 112
end type

type ln_2 from line within w_kfm08ot0_popup
integer linethickness = 1
integer beginx = 768
integer beginy = 112
integer endx = 2071
integer endy = 112
end type

type rr_2 from roundrectangle within w_kfm08ot0_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 156
integer width = 3250
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

