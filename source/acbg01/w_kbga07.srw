$PBExportHeader$w_kbga07.srw
$PBExportComments$예산계정코드 등록
forward
global type w_kbga07 from w_inherite
end type
type dw_2 from datawindow within w_kbga07
end type
type gb_1 from groupbox within w_kbga07
end type
type cbx_1 from checkbox within w_kbga07
end type
type gb_2 from groupbox within w_kbga07
end type
type rr_1 from roundrectangle within w_kbga07
end type
end forward

global type w_kbga07 from w_inherite
string title = "예산계정 등록"
dw_2 dw_2
gb_1 gb_1
cbx_1 cbx_1
gb_2 gb_2
rr_1 rr_1
end type
global w_kbga07 w_kbga07

type variables
w_preview  iw_preview

end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer irow);Return 1
end function

public function integer wf_dup_chk (integer ll_row);
Return 1
end function

on w_kbga07.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_1=create gb_1
this.cbx_1=create cbx_1
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_kbga07.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.gb_1)
destroy(this.cbx_1)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_2.SetTransObJect(sqlca)
if dw_2.Retrieve() > 0 then
	dw_2.Setcolumn("yesan_gu")
	dw_2.SetFocus()
end if

ib_any_typing =False

open( iw_preview, this)
end event

type dw_insert from w_inherite`dw_insert within w_kbga07
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kbga07
boolean visible = false
integer x = 2889
integer y = 2588
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kbga07
boolean visible = false
integer x = 2715
integer y = 2588
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kbga07
boolean visible = false
integer x = 3598
integer y = 2608
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kbga07
boolean visible = false
integer x = 2542
integer y = 2588
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kbga07
integer x = 4434
integer taborder = 40
end type

type p_can from w_inherite`p_can within w_kbga07
integer x = 4261
integer taborder = 30
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_2.SetRedraw(False)
IF dw_2.Retrieve() > 0 THEN
	dw_2.SetColumn("yesan_gu")
	dw_2.SetFocus()
END IF
dw_2.SetRedraw(True)

ib_any_typing =False

end event

type p_print from w_inherite`p_print within w_kbga07
boolean visible = false
integer x = 3771
integer y = 2608
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kbga07
boolean visible = false
integer x = 2368
integer y = 2588
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kbga07
boolean visible = false
integer x = 3237
integer y = 2588
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kbga07
integer x = 4087
integer taborder = 20
end type

event p_mod::clicked;call super::clicked;
IF dw_2.AcceptText() = -1 THEN Return

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	dw_2.SetColumn("yesan_gu")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kbga07
boolean visible = false
integer x = 4000
integer y = 2440
end type

type cb_mod from w_inherite`cb_mod within w_kbga07
boolean visible = false
integer x = 3291
integer y = 2440
end type

type cb_ins from w_inherite`cb_ins within w_kbga07
boolean visible = false
integer x = 1742
integer y = 2848
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_kbga07
boolean visible = false
integer x = 1806
integer y = 3064
end type

type cb_inq from w_inherite`cb_inq within w_kbga07
boolean visible = false
integer x = 1294
integer y = 2848
end type

type cb_print from w_inherite`cb_print within w_kbga07
boolean visible = false
integer x = 2194
integer y = 2760
end type

type st_1 from w_inherite`st_1 within w_kbga07
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kbga07
boolean visible = false
integer x = 3648
integer y = 2440
end type

type cb_search from w_inherite`cb_search within w_kbga07
boolean visible = false
integer x = 1216
integer y = 3064
integer width = 526
string text = "부서 가져오기"
end type

type dw_datetime from w_inherite`dw_datetime within w_kbga07
boolean visible = false
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_kbga07
boolean visible = false
integer width = 2487
end type

type gb_10 from w_inherite`gb_10 within w_kbga07
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kbga07
boolean visible = false
integer x = 1257
integer y = 2804
integer width = 407
integer height = 180
end type

type gb_button2 from w_inherite`gb_button2 within w_kbga07
boolean visible = false
integer x = 3255
integer y = 2392
integer width = 1115
integer height = 180
end type

type dw_2 from datawindow within w_kbga07
event ue_enter pbm_dwnprocessenter
integer x = 78
integer y = 192
integer width = 4512
integer height = 2092
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbga071"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(This),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event editchanged;ib_any_typing = True
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="yacc2_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

event itemchanged;String sYesanGbn,sNullValue,sRemark6,sYeGbn

SetNull(sNullValue)

IF this.GetColumnName() ="yesan_gu" THEN
	sYeSanGbn = this.GetText()
	IF sYeSanGbn = "" OR IsNull(sYeSanGbn) THEN RETURN
	
	IF sYeSanGbn <> 'Y' AND sYeSanGbn <> 'N' AND sYeSanGbn <> 'A' THEN
		f_messagechk(20,"예산통제구분")
		this.SetItem(this.GetRow(),"yesan_gu",sNullValue)
		Return 1
	END IF	
END IF

IF this.GetColumnName() ="ye_gu" THEN
	sYeGbn = this.GetText()
	IF sYeGbn = "" OR IsNull(sYeGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AB',sYeGbn)) THEN
		F_Messagechk(20,"예산구분")
		this.SetItem(this.GetRow(),"ye_gu",sNullValue)
		Return 1
	END IF
END IF


IF this.GetColumnName() ="remark6" THEN
	sRemark6 = this.GetText()
	IF sRemark6 = "" OR IsNull(sRemark6) THEN RETURN
	
	IF sRemark6 <> '1' AND sRemark6 <> '2' AND sRemark6 <> '3' THEN
		f_messagechk(20,"전결규정")
		this.SetItem(this.GetRow(),"remark6",sNullValue)
		Return 1
	END IF	
END IF
end event

type gb_1 from groupbox within w_kbga07
integer x = 3296
integer y = 44
integer width = 777
integer height = 120
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_kbga07
integer x = 3323
integer y = 76
integer width = 709
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "예산계정코드 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.Checked = False

iw_preview.title = '예산계정코드 미리보기'
iw_preview.dw_preview.dataobject = 'dw_kbga072'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=2 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve() <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True
end event

type gb_2 from groupbox within w_kbga07
boolean visible = false
integer x = 1184
integer y = 3016
integer width = 594
integer height = 180
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

type rr_1 from roundrectangle within w_kbga07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 188
integer width = 4544
integer height = 2108
integer cornerheight = 40
integer cornerwidth = 55
end type

