$PBExportHeader$w_imt_02045_coil_pop.srw
$PBExportComments$코일 절단 팝업
forward
global type w_imt_02045_coil_pop from w_inherite_popup
end type
type dw_4 from u_d_popup_sort within w_imt_02045_coil_pop
end type
type dw_3 from u_key_enter within w_imt_02045_coil_pop
end type
type pb_2 from u_pb_cal within w_imt_02045_coil_pop
end type
type pb_1 from u_pb_cal within w_imt_02045_coil_pop
end type
type p_1 from picture within w_imt_02045_coil_pop
end type
type cbx_1 from checkbox within w_imt_02045_coil_pop
end type
type cbx_2 from checkbox within w_imt_02045_coil_pop
end type
type rr_1 from roundrectangle within w_imt_02045_coil_pop
end type
type rr_2 from roundrectangle within w_imt_02045_coil_pop
end type
end forward

global type w_imt_02045_coil_pop from w_inherite_popup
integer x = 466
integer y = 160
integer width = 4155
integer height = 2564
string title = "절단 코일 조회 선택"
boolean controlmenu = true
dw_4 dw_4
dw_3 dw_3
pb_2 pb_2
pb_1 pb_1
p_1 p_1
cbx_1 cbx_1
cbx_2 cbx_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_02045_coil_pop w_imt_02045_coil_pop

type variables
string is_cvcod
end variables

forward prototypes
public subroutine wf_filter ()
end prototypes

public subroutine wf_filter ();string	sitnbr, sfilter

if dw_jogun.accepttext() = -1 then return

sitnbr = trim(dw_jogun.GetItemString(1, 'itnbr'))

if cbx_1.checked then
	sfilter = "opt='Y'"
else
	sfilter = ""
end if
	
if isnull(sitnbr) or sitnbr = "" then
else
	if isnull(sfilter) or sfilter = "" then
		sfilter = "pos(poblkt_itnbr,'"+sitnbr+"') > 0"
	else
		sfilter = sfilter + " and pos(poblkt_itnbr,'"+sitnbr+"') > 0"
	end if
end if	

dw_1.SetFilter(sfilter)
dw_1.Filter()
end subroutine

on w_imt_02045_coil_pop.create
int iCurrent
call super::create
this.dw_4=create dw_4
this.dw_3=create dw_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_1=create p_1
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_4
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cbx_2
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_imt_02045_coil_pop.destroy
call super::destroy
destroy(this.dw_4)
destroy(this.dw_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

is_cvcod = gs_code

dw_jogun.setitem(1, 'cvcod', is_cvcod )
dw_jogun.setitem(1, 'cvnas', gs_codename)
dw_jogun.SetFocus()
	
dw_1.ScrollToRow(1)

dw_4.SetTransObject(SQLCA)

dw_3.InsertRow(0)
dw_3.setitem(1,'fr_date',left(f_today(),6)+'01')
dw_3.setitem(1,'to_date',f_today())

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

p_inq.TriggerEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imt_02045_coil_pop
integer x = 37
integer y = 1212
integer width = 2816
integer height = 140
string dataobject = "d_imt_02045_coil_pop1"
end type

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::itemchanged;call super::itemchanged;post wf_filter()
end event

type p_exit from w_inherite_popup`p_exit within w_imt_02045_coil_pop
integer x = 3858
integer y = 1188
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imt_02045_coil_pop
integer x = 3511
integer y = 1188
end type

event p_inq::clicked;call super::clicked;string	sgubun, sfilter

sgubun = dw_jogun.getitemstring(1,'gubun')

cbx_1.checked = false
dw_1.setfilter("")
dw_1.filter()

if dw_jogun.AcceptText() = -1 then return 

String ls_itcls

If cbx_2.Checked = True Then
	ls_itcls = '03'
Else
	ls_itcls = '02'
End If

IF dw_1.Retrieve(is_cvcod, sgubun, ls_itcls) <= 0 THEN
	dw_jogun.SetFocus()
	Return
END IF

dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_imt_02045_coil_pop
integer x = 3685
integer y = 1188
end type

event p_choose::clicked;call super::clicked;long		lsow, lrow
decimal	dqty, dbalqty

lsow = dw_4.getselectedrow(0)
if lsow <= 0 then
	messagebox('확인','가공대상 코일을 선택해야 합니다!!!')
	return
end if

dbalqty = 0

dqty = dw_4.getitemnumber(lsow,'imhist_ioqty')
for lrow = 1 to dw_1.rowcount()
	if dw_1.getitemstring(lrow,'opt') = 'N' then continue
	if dw_1.getitemnumber(lrow,'balqty') <= 0 then
		dw_1.setitem(lrow,'opt','N')
		continue
	end if
	
	dbalqty = dbalqty + dw_1.getitemnumber(lrow,'balqty')
next

if dqty < dbalqty then
	messagebox('확인','가공중량의 합이 입고중량을 초과합니다!!!')
	return
end if
	

gs_code = dw_4.getitemstring(lsow,'imhist_itnbr')
gs_codename = dw_4.getitemstring(lsow,'itemas_itdsc')+'  '+dw_4.getitemstring(lsow,'itemas_ispec')
gs_codename2 = dw_4.getitemstring(lsow,'imhist_iojpno')
// 통코일단가 - 수불장 가공코일금액 계산시 이용 - 2008.10.24 - 송병호
gs_gubun = string(dw_4.getitemnumber(lsow,'imhist_ioprc'))

SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_1.SaveAs("", Clipboard!, False)
Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_imt_02045_coil_pop
integer x = 46
integer y = 1372
integer width = 4018
integer height = 1076
integer taborder = 20
string dataobject = "d_imt_02045_coil_pop2"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code= dw_1.GetItemString(Row, "baljpno")
//gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))
//
//Close(Parent)
//
end event

event dw_1::rowfocuschanged;RETURN 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_imt_02045_coil_pop
boolean visible = false
integer x = 1125
integer y = 2500
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_imt_02045_coil_pop
integer x = 1211
integer y = 2572
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_imt_02045_coil_pop
integer x = 1833
integer y = 2572
end type

type cb_inq from w_inherite_popup`cb_inq within w_imt_02045_coil_pop
integer x = 1522
integer y = 2572
integer taborder = 30
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_imt_02045_coil_pop
boolean visible = false
integer x = 462
integer y = 2500
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_imt_02045_coil_pop
boolean visible = false
integer x = 192
integer y = 2520
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type dw_4 from u_d_popup_sort within w_imt_02045_coil_pop
integer x = 46
integer y = 180
integer width = 4037
integer height = 980
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_imt_02045_coil_pop4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type dw_3 from u_key_enter within w_imt_02045_coil_pop
integer x = 37
integer y = 12
integer width = 2565
integer height = 132
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_imt_02045_coil_pop3"
boolean border = false
end type

event itemchanged;call super::itemchanged;String snull

SetNull(snull)

IF	this.getcolumnname() = "fr_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF	this.getcolumnname() = "to_date"		THEN

	IF f_datechk(trim(this.gettext())) = -1	then
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
END IF
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		gs_gubun ='1'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
	   This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', f_get_name5('11', gs_code, ''))
		
End Choose
end event

type pb_2 from u_pb_cal within w_imt_02045_coil_pop
integer x = 1111
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_3.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
If dw_3.Object.to_date.protect = '1' Or dw_3.Object.to_date.TabSequence = '0' Then Return

dw_3.SetItem(1, 'to_date', gs_code)
end event

type pb_1 from u_pb_cal within w_imt_02045_coil_pop
integer x = 672
integer y = 28
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_3.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
If dw_3.Object.fr_date.protect = '1' Or dw_3.Object.fr_date.TabSequence = '0' Then Return

dw_3.SetItem(1, 'fr_date', gs_code)
end event

type p_1 from picture within w_imt_02045_coil_pop
integer x = 3826
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\자료조회_up.gif"
boolean focusrectangle = false
end type

event clicked;
String sdatef,sdatet, ls_iogbn, sitnbr, sCvcod

dw_3.AcceptText()

sdatef 	= dw_3.GetItemString(1,"fr_date")
sdatet 	= dw_3.GetItemString(1,"to_date")
ls_iogbn = dw_3.GetItemString(1,"iogbn")
sItnbr 	= dw_3.GetItemString(1,"itnbr")
sCvcod   = dw_3.GetItemString(1,"cvcod")

IF sItnbr ="" OR IsNull(sItnbr) THEN
	sItnbr =''
END IF

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF


IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_3.SetColumn("fr_date")
	dw_3.SetFocus()
	Return
END IF

If isNull(ls_iogbn) or ls_iogbn = "" then ls_iogbn = '%'

IF isNull(sCvcod) or sCvcod = "" then sCvcod = '%'

IF dw_4.Retrieve(gs_sabu, gs_saupj, sdatef, sdatet, sCvcod) <= 0 THEN
   messagebox("확인", "조회한 자료가 없습니다!!")
	dw_3.SetColumn("fr_date")
	dw_3.SetFocus()
	Return
END IF

dw_4.SelectRow(0,False)
dw_4.SelectRow(1,True)
dw_4.ScrollToRow(1)
dw_4.SetFocus()


end event

type cbx_1 from checkbox within w_imt_02045_coil_pop
integer x = 2885
integer y = 1212
integer width = 594
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "선택된 자료만 표시"
end type

event clicked;post wf_filter()
end event

type cbx_2 from checkbox within w_imt_02045_coil_pop
integer x = 2885
integer y = 1292
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "통코일 표시"
end type

type rr_1 from roundrectangle within w_imt_02045_coil_pop
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 1360
integer width = 4059
integer height = 1092
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_02045_coil_pop
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 168
integer width = 4059
integer height = 1000
integer cornerheight = 40
integer cornerwidth = 55
end type

