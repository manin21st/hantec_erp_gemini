$PBExportHeader$w_kfga01.srw
$PBExportComments$경영분석비율코드 등록
forward
global type w_kfga01 from w_inherite
end type
type dw_cond from datawindow within w_kfga01
end type
type dw_update from u_d_popup_sort within w_kfga01
end type
type cbx_1 from checkbox within w_kfga01
end type
type gb_1 from groupbox within w_kfga01
end type
type rr_1 from roundrectangle within w_kfga01
end type
end forward

global type w_kfga01 from w_inherite
string title = "경영분석코드 등록"
dw_cond dw_cond
dw_update dw_update
cbx_1 cbx_1
gb_1 gb_1
rr_1 rr_1
end type
global w_kfga01 w_kfga01

type variables

w_preview  iw_preview
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sMaCode,sMaName,sMaPrtGbn,sMaBunJa,sMaBunMo
Integer iMaSort


dw_update.AcceptText()
sMaCode   = dw_update.GetItemString(icurrow,"ma_code")
sMaName   = dw_update.GetItemString(icurrow,"ma_name")
sMaPrtGbn = dw_update.GetItemString(icurrow,"ma_prtgu")
iMaSort   = dw_update.GetItemNumber(icurrow,"ma_sort")
sMaBunJa  = dw_update.GetItemString(icurrow,"ma_bunja")
sMaBunMo  = dw_update.GetItemString(icurrow,"ma_bunmo")
IF sMaCode = "" OR IsNull(sMaCode) THEN
	F_MessageChk(1,'[비율코드]')
	dw_update.SetColumn("ma_code")
	dw_update.SetFocus()
	Return -1
END IF
IF sMaName = "" OR IsNull(sMaName) THEN
	F_MessageChk(1,'[경영분석비율명]')
	dw_update.SetColumn("ma_name")
	dw_update.SetFocus()
	Return -1
END IF
IF sMaPrtGbn = "" OR IsNull(sMaPrtGbn) THEN
	F_MessageChk(1,'[출력여부]')
	dw_update.SetColumn("ma_prtgu")
	dw_update.SetFocus()
	Return -1
END IF
IF sMaPrtGbn = 'Y' AND (iMaSort = 0 OR IsNull(iMaSort)) THEN
	F_MessageChk(1,'[출력순서]')
	dw_update.SetColumn("ma_sort")
	dw_update.SetFocus()
	Return -1
END IF
IF sMaBunJa = "" OR IsNull(sMaBunJa) THEN
	F_MessageChk(1,'[분자과목명]')
	dw_update.SetColumn("ma_bunja")
	dw_update.SetFocus()
	Return -1
END IF
IF sMaBunMo = "" OR IsNull(sMaBunMo) THEN
	F_MessageChk(1,'[분모과목명]')
	dw_update.SetColumn("ma_bunmo")
	dw_update.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_dup_chk (integer ll_row);String  sMaCode,sMaGubun
Integer iReturnRow

dw_update.AcceptText()
sMaGubun = dw_update.GetItemString(ll_row,"ma_gubun") 
sMacode  = dw_update.GetItemString(ll_row,"ma_code")

IF sMacode ="" OR IsNull(sMacode)   THEN RETURN 1

iReturnRow = dw_update.find("ma_gubun ='" + sMaGubun + "' and ma_code = '" + sMaCode+"'", 1, dw_update.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[비율코드]')
	RETURN  -1
END IF
	
Return 1
end function

on w_kfga01.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_update=create dw_update
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_update
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_kfga01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_update)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;String sgubun

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

SELECT MIN("REFFPF"."RFGUB")
	INTO :sgubun
	FROM "REFFPF"
	WHERE "REFFPF"."RFCOD" ='MA' AND
			"REFFPF"."RFGUB" <> '00' ;
			
dw_cond.SetItem(1,"ma_gubun",sgubun)
p_inq.SetFocus()

dw_update.SetTransObject(SQLCA)

dw_update.Retrieve(sGubun)

IF dw_update.RowCount() <=0 THEN
	p_ins.Enabled = False
ELSE
	p_ins.Enabled = True
END IF

w_mdi_frame.sle_msg.text =""
ib_any_typing =False

open( iw_preview, this)
end event

type dw_insert from w_inherite`dw_insert within w_kfga01
boolean visible = false
integer x = 754
integer y = 2468
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfga01
boolean visible = false
integer x = 3241
integer y = 3148
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfga01
boolean visible = false
integer x = 3067
integer y = 3148
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfga01
boolean visible = false
integer x = 2373
integer y = 3148
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfga01
integer x = 3749
integer y = 4
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_update.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_update.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_update.InsertRow(iCurRow)

	dw_update.ScrollToRow(iCurRow)
	dw_update.SetItem(iCurRow,'sflag','I')
	
	dw_update.SetItem(iCurRow,"ma_gubun",dw_cond.GetItemString(1,"ma_gubun"))
	dw_update.SetColumn("ma_code")
	dw_update.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_update.RowCount() <=0 THEN
	p_ins.Enabled = False
ELSE
	p_ins.Enabled = True
END IF


end event

type p_exit from w_inherite`p_exit within w_kfga01
integer y = 4
end type

type p_can from w_inherite`p_can within w_kfga01
integer y = 4
end type

event p_can::clicked;call super::clicked;
dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

dw_update.Reset()

w_mdi_frame.sle_msg.text =""
ib_any_typing =False

dw_cond.SetFocus()
end event

type p_print from w_inherite`p_print within w_kfga01
boolean visible = false
integer x = 2546
integer y = 3148
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfga01
integer x = 3575
integer y = 4
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sgubun

dw_cond.AcceptText()

sgubun = dw_cond.GetItemString(1,"ma_gubun")
IF sgubun ="" OR IsNull(sgubun) THEN
	MessageBox("확 인","경영분석구분을 입력하세요.!!")
	dw_cond.SetColumn("ma_gubun")
	dw_cond.SetFocus()
	Return
END IF

IF dw_update.Retrieve(sgubun) <= 0 THEN
	F_MessageChk(14,'')
END IF

p_ins.Enabled =True



end event

type p_del from w_inherite`p_del within w_kfga01
integer y = 4
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_update.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_update.DeleteRow(dw_update.GetRow())
IF dw_update.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_update.RowCount()
		dw_update.SetItem(k,'sflag','M')
	NEXT
	
	dw_update.SetColumn("ma_name")
	dw_update.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kfga01
integer y = 4
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_update.AcceptText() = -1 THEN Return

IF dw_update.RowCount() > 0 THEN
	FOR k = 1 TO dw_update.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_update.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_update.RowCount()
		dw_update.SetItem(k,'sflag','M')
	NEXT

	dw_update.SetColumn("ma_name")
	dw_update.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_update.RowCount() <=0 THEN
	p_ins.Enabled = False
ELSE
	p_ins.Enabled = True
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kfga01
boolean visible = false
integer x = 3922
end type

type cb_mod from w_inherite`cb_mod within w_kfga01
boolean visible = false
integer x = 2853
integer y = 2784
end type

type cb_ins from w_inherite`cb_ins within w_kfga01
boolean visible = false
integer x = 1801
integer y = 2796
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_kfga01
boolean visible = false
integer x = 3209
integer y = 2784
end type

type cb_inq from w_inherite`cb_inq within w_kfga01
boolean visible = false
integer x = 1445
integer y = 2796
end type

type cb_print from w_inherite`cb_print within w_kfga01
boolean visible = false
integer x = 2583
integer y = 2520
end type

type st_1 from w_inherite`st_1 within w_kfga01
boolean visible = false
integer x = 69
integer width = 297
end type

type cb_can from w_inherite`cb_can within w_kfga01
boolean visible = false
integer x = 3566
integer y = 2784
end type

type cb_search from w_inherite`cb_search within w_kfga01
boolean visible = false
integer x = 2071
integer y = 2528
end type

type dw_datetime from w_inherite`dw_datetime within w_kfga01
boolean visible = false
integer x = 2839
end type

type sle_msg from w_inherite`sle_msg within w_kfga01
boolean visible = false
integer width = 2464
end type

type gb_10 from w_inherite`gb_10 within w_kfga01
boolean visible = false
integer x = 37
integer width = 3570
end type

type gb_button1 from w_inherite`gb_button1 within w_kfga01
boolean visible = false
integer x = 1403
integer y = 2744
end type

type gb_button2 from w_inherite`gb_button2 within w_kfga01
boolean visible = false
integer x = 2811
integer y = 2728
end type

type dw_cond from datawindow within w_kfga01
integer x = 55
integer y = 28
integer width = 1349
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfga011"
boolean border = false
end type

event itemchanged;dw_update.Reset()
end event

type dw_update from u_d_popup_sort within w_kfga01
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 73
integer y = 172
integer width = 4526
integer height = 2048
integer taborder = 40
string dataobject = "d_kfga012"
boolean border = false
end type

event ue_pressenter;
Send( Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event clicked;If Row <= 0 then
	b_flag = True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event itemchanged;String sNull

SetNull(sNull)

IF this.GetColumnName() = "ma_code" then
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"ma_code",snull)
		RETURN 1
	END IF
END IF
IF this.GetColumnName() = 'ma_prtgu' then
	this.SetItem(this.GetRow(),"ma_sort",0)
END IF
end event

event rbuttondown;
IF This.GetColumnName() <> 'ma_m1acc1' AND This.GetColumnName() <> 'ma_m2acc1' AND &
			This.GetColumnName() <> 'ma_m3acc1' AND This.GetColumnName() <> 'ma_m4acc1' AND &
					This.GetColumnName() <> 'ma_m5acc1' AND This.GetColumnName() <> 'ma_j1acc1' AND &
							This.GetColumnName() <> 'ma_j2acc1' AND This.GetColumnName() <> 'ma_j3acc1' AND &
									This.GetColumnName() <> 'ma_j4acc1' AND This.GetColumnName() <> 'ma_j5acc1' THEN RETURN

gs_code =""

OPEN(W_KFGA02_POPUP)

IF IsNull(gs_code) THEN RETURN

CHOOSE CASE This.GetColumnName() 
	CASE "ma_m1acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_m1acc1",gs_code)	
	CASE "ma_m2acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_m2acc1",gs_code)	
	CASE "ma_m3acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_m3acc1",gs_code)		
	CASE "ma_m4acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_m4acc1",gs_code)			
	CASE "ma_m5acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_m5acc1",gs_code)
	CASE "ma_j1acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_j1acc1",gs_code)				
	CASE "ma_j2acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_j2acc1",gs_code)					
	CASE "ma_j3acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_j3acc1",gs_code)
	CASE "ma_j4acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_j4acc1",gs_code)
	CASE "ma_j5acc1"
		dw_update.SetItem(dw_update.GetRow(),"ma_j5acc1",gs_code)
END CHOOSE
													
	
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="ma_name" or dwo.name = 'ma_bunja' or dwo.name = 'ma_bunmo' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

type cbx_1 from checkbox within w_kfga01
integer x = 2555
integer y = 60
integer width = 882
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "경영분석비율코드 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;
cbx_1.Checked = False

iw_preview.title = '경영분석코드 미리보기'
iw_preview.dw_preview.dataobject = 'd_kfga013'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=1 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve('%') <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True

end event

type gb_1 from groupbox within w_kfga01
integer x = 2464
integer y = 16
integer width = 1079
integer height = 132
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_kfga01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 168
integer width = 4553
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

