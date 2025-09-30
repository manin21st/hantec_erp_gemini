$PBExportHeader$w_kfga02.srw
$PBExportComments$재무분석코드 등록
forward
global type w_kfga02 from w_inherite
end type
type dw_update from u_d_popup_sort within w_kfga02
end type
type cbx_1 from checkbox within w_kfga02
end type
type gb_1 from groupbox within w_kfga02
end type
type rr_1 from roundrectangle within w_kfga02
end type
end forward

global type w_kfga02 from w_inherite
string title = "재무분석코드 등록"
dw_update dw_update
cbx_1 cbx_1
gb_1 gb_1
rr_1 rr_1
end type
global w_kfga02 w_kfga02

type variables
w_preview  iw_preview
end variables

forward prototypes
public subroutine wf_init (integer ll_currow)
public function integer wf_requiredchk (integer icurrow)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public subroutine wf_init (integer ll_currow);
String snull

SetNull(snull)

dw_update.SetItem(ll_currow,"accd",snull)
dw_update.SetItem(ll_currow,"accd_nm",snull)
dw_update.SetItem(ll_currow,"acgu1",snull)
dw_update.SetItem(ll_currow,"acgu2",snull)

dw_update.SetColumn("accd")
dw_update.SetFocus()
end subroutine

public function integer wf_requiredchk (integer icurrow);String  sAcCd,sName,sYearGbn

dw_update.AcceptText()
sAcCd    = dw_update.GetItemString(icurrow,"accd") 
sName    = dw_update.GetItemString(icurrow,"accd_nm") 
sYearGbn = dw_update.GetItemString(icurrow,"year_gbn") 

IF sAcCd ="" OR IsNull(sAcCd) THEN
	F_MessageChk(1,'[분석코드]')
	dw_update.SetColumn("accd")
	dw_update.SetFocus()
	Return -1
END IF
IF sName ="" OR IsNull(sName) THEN
	F_MessageChk(1,'[계정명칭]')
	dw_update.SetColumn("accd_nm")
	dw_update.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_dup_chk (integer ll_row);String  sAcCd
Integer iReturnRow

dw_update.AcceptText()
sAcCd = dw_update.GetItemString(ll_row,"accd") 

IF sAcCd ="" OR IsNull(sAcCd)   THEN RETURN 1

iReturnRow = dw_update.find("accd ='" + sAcCd + "'", 1, dw_update.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[분석코드]')
	RETURN  -1
END IF
	
	
Return 1
end function

on w_kfga02.create
int iCurrent
call super::create
this.dw_update=create dw_update
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_update
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfga02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_update)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_update.SetTransObject(SQLCA)
dw_update.Reset()
dw_update.Retrieve()

w_mdi_frame.sle_msg.text =""

ib_any_typing =False

open( iw_preview, this)
end event

type dw_insert from w_inherite`dw_insert within w_kfga02
boolean visible = false
integer x = 46
integer y = 3116
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfga02
boolean visible = false
integer x = 3433
integer y = 3112
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfga02
boolean visible = false
integer x = 3259
integer y = 3112
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfga02
boolean visible = false
integer x = 2565
integer y = 3112
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfga02
integer x = 3749
integer y = 8
integer taborder = 10
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
	
	dw_update.SetColumn("accd")
	dw_update.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_update.RowCount() <=0 THEN
	p_ins.Enabled = False
ELSE
	p_ins.Enabled = True
END IF


end event

type p_exit from w_inherite`p_exit within w_kfga02
integer y = 8
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kfga02
integer y = 8
integer taborder = 50
end type

event p_can::clicked;call super::clicked;
dw_update.Retrieve()

w_mdi_frame.sle_msg.text =""

ib_any_typing =False

end event

type p_print from w_inherite`p_print within w_kfga02
boolean visible = false
integer x = 2738
integer y = 3112
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfga02
boolean visible = false
integer x = 2912
integer y = 3112
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfga02
integer y = 8
integer taborder = 40
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
	
	dw_update.SetColumn("accd_nm")
	dw_update.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kfga02
integer y = 8
integer taborder = 30
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

	dw_update.SetColumn("accd_nm")
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

type cb_exit from w_inherite`cb_exit within w_kfga02
boolean visible = false
integer x = 3397
integer y = 2748
end type

type cb_mod from w_inherite`cb_mod within w_kfga02
boolean visible = false
integer x = 1966
integer y = 2752
integer width = 338
end type

type cb_ins from w_inherite`cb_ins within w_kfga02
boolean visible = false
integer x = 105
integer y = 2796
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_kfga02
boolean visible = false
integer x = 2327
integer y = 2752
end type

type cb_inq from w_inherite`cb_inq within w_kfga02
boolean visible = false
integer x = 1559
integer y = 2760
end type

type cb_print from w_inherite`cb_print within w_kfga02
boolean visible = false
integer x = 2688
integer y = 2752
end type

type st_1 from w_inherite`st_1 within w_kfga02
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfga02
boolean visible = false
integer x = 3040
integer y = 2752
end type

type cb_search from w_inherite`cb_search within w_kfga02
boolean visible = false
integer x = 718
integer y = 2804
integer width = 750
string text = "재무분석코드 출력(&P)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kfga02
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfga02
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfga02
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfga02
boolean visible = false
integer x = 69
integer y = 2736
integer width = 421
end type

type gb_button2 from w_inherite`gb_button2 within w_kfga02
boolean visible = false
integer x = 1929
integer y = 2696
integer width = 1833
end type

type dw_update from u_d_popup_sort within w_kfga02
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 91
integer y = 172
integer width = 4503
integer height = 2128
integer taborder = 20
string dataobject = "d_kfga022"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event clicked;If Row <= 0 then
	b_flag = True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event editchanged;ib_any_typing =True
end event

event itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;this.SetRowFocusIndiCator(Hand!)
end event

event itemchanged;String sAcCode,sNull

SetNull(sNull)
IF this.GetColumnName() = 'accd' THEN
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"accd",snull)
		RETURN 1
	END IF
END IF

IF this.GetColumnName() = 'acccode' THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN Return
	
	select acc1_cd||acc2_cd into :sAcCode
		from kfz01om0
		where acc1_cd||acc2_cd = :sAcCode;
//	if sqlca.sqlcode <> 0 then
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(this.GetRow(),"acccode", snull)
//		Return 1
//	end if
	if sqlca.sqlcode = 0 then
		this.SetItem(this.GetRow(),"acccode", sAcCode)
	end if
END IF
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event rbuttondown;this.accepttext()

IF this.GetColumnName() ="acccode" THEN
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.object.acccode[getrow()]

	Open(W_KFZ01OM0_POPUP1)

	IF lstr_account.acc1_cd ="" AND IsNull(lstr_account.acc1_cd) THEN RETURN
	
	dw_update.SetItem(this.GetRow(),"acccode",lstr_account.acc1_cd + lstr_account.acc2_cd)
END IF
end event

event buttonclicked;string sRtnMsg,sAcCode

IF dwo.name = 'bcb_calc' THEN
	dw_update.AcceptText()
	
	sAcCode = this.GetItemString(this.GetRow(),"accd")
	  
	OpenWithParm(w_kfga02a,String(Len(sAcCode))+sAcCode + this.GetItemString(this.GetRow(),"accd_nm"))
  
	sRtnMsg = Message.StringParm
  
	IF sRtnMsg = 'ok' THEN
		ib_any_typing = True
	END IF
END IF
end event

type cbx_1 from checkbox within w_kfga02
integer x = 2889
integer y = 56
integer width = 741
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "재무분석코드 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;
cbx_1.Checked = False

iw_preview.title = '재무분석코드 미리보기'
iw_preview.dw_preview.dataobject = 'd_kfga023'
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

type gb_1 from groupbox within w_kfga02
integer x = 2821
integer width = 882
integer height = 148
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfga02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 164
integer width = 4539
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

