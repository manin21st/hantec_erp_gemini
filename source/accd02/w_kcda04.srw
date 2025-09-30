$PBExportHeader$w_kcda04.srw
$PBExportComments$신용카드번호등록
forward
global type w_kcda04 from w_inherite
end type
type dw_1 from u_key_enter within w_kcda04
end type
type sle_search from singlelineedit within w_kcda04
end type
type rb_1 from radiobutton within w_kcda04
end type
type rb_2 from radiobutton within w_kcda04
end type
type cbx_1 from checkbox within w_kcda04
end type
type cb_1 from picture within w_kcda04
end type
type gb_1 from groupbox within w_kcda04
end type
type rr_1 from roundrectangle within w_kcda04
end type
type rr_2 from roundrectangle within w_kcda04
end type
end forward

global type w_kcda04 from w_inherite
string title = "신용카드번호 등록"
dw_1 dw_1
sle_search sle_search
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
cb_1 cb_1
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kcda04 w_kcda04

type variables


w_preview  iw_preview
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);
String sCardNo,sOwner,sCusCd,sTxtNo

dw_1.AcceptText()
sCardNo = dw_1.GetItemString(ll_row,"card_no")
sOwner  = dw_1.GetItemString(ll_row,"owner")
sCusCd  = dw_1.GetItemString(ll_row,"cus_cd")
sTxtNo  = dw_1.GetItemString(ll_row,"txt_no")

IF sCardNo = "" OR IsNull(sCardNo) THEN
	f_messagechk(1,'[카드번호]')
	dw_1.SetColumn("card_no")
	dw_1.SetFocus()
	Return -1
END IF

IF sOwner = "" OR IsNull(sOwner) THEN
	f_messagechk(1,'[회원명]')
	dw_1.SetColumn("owner")
	dw_1.SetFocus()
	Return -1
END IF

IF sCusCd = '' OR IsNull(sCusCd) THEN
	f_messagechk(1,'[카드종류]')
	dw_1.SetColumn("cus_cd")
	dw_1.SetFocus()
	Return -1
END IF

IF sTxtNo = '' OR IsNull(sTxtNo) THEN
	f_messagechk(1,'[사업자번호]')
	dw_1.SetColumn("txt_no")
	dw_1.SetFocus()
	Return -1
END IF

Return 1
end function

event open;call super::open;

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

IF dw_1.Retrieve() > 0 THEN
	dw_1.ScrollToRow(1)
	dw_1.SetColumn("owner")
	dw_1.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF

ib_any_typing =False

open( iw_preview, this)
end event

on w_kcda04.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.sle_search=create sle_search
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.sle_search
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_kcda04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.sle_search)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event key;//Descent Ancestor 
   graphicobject   obj_type
   
   obj_type = GetFocus()
   
   if Typeof(obj_type) <> SingleLineEdit! then
   	Choose Case key
   		Case KeyW!
   			p_print.TriggerEvent(Clicked!)
   		Case KeyQ!
   			p_inq.TriggerEvent(Clicked!)
   		Case KeyT!
   			p_ins.TriggerEvent(Clicked!)
   		Case KeyA!
   			p_addrow.TriggerEvent(Clicked!)
   		Case KeyE!
   			p_delrow.TriggerEvent(Clicked!)
   		Case KeyS!
   			p_mod.TriggerEvent(Clicked!)
   		Case KeyD!
   			p_del.TriggerEvent(Clicked!)
   		Case KeyC!
   			p_can.TriggerEvent(Clicked!)
   		Case KeyX!
   			p_exit.TriggerEvent(Clicked!)
   	End Choose
end if
end event

type dw_insert from w_inherite`dw_insert within w_kcda04
boolean visible = false
integer x = 41
integer y = 2360
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda04
boolean visible = false
integer x = 4073
integer y = 2676
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda04
boolean visible = false
integer x = 3867
integer y = 2700
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda04
boolean visible = false
integer x = 3945
integer y = 2872
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kcda04
integer x = 3749
integer y = 0
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue

w_mdi_frame.sle_msg.text =""

IF dw_1.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_1.InsertRow(0)

	dw_1.ScrollToRow(iCurRow)
	dw_1.SetItem(iCurRow,'sflag','I')
	dw_1.SetColumn("card_no")
	dw_1.SetFocus()
	
	ib_any_typing =False

END IF

end event

type p_exit from w_inherite`p_exit within w_kcda04
integer y = 0
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kcda04
integer y = 0
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_1.SetRedraw(False)
IF dw_1.Retrieve() > 0 THEN
	dw_1.ScrollToRow(1)
	dw_1.SetColumn("owner")
	dw_1.SetFocus()
ELSE
	p_ins.SetFocus()
END IF
dw_1.SetRedraw(True)

cb_1.TriggerEvent(Clicked!)

ib_any_typing =False


end event

type p_print from w_inherite`p_print within w_kcda04
boolean visible = false
integer x = 4160
integer y = 2860
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda04
boolean visible = false
integer x = 3666
integer y = 2880
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kcda04
integer y = 0
integer taborder = 50
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_1.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_1.DeleteRow(dw_1.GetRow())
IF dw_1.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_1.RowCount()
		dw_1.SetItem(k,'sflag','M')
	NEXT
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kcda04
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_1.AcceptText() = -1 THEN Return

IF dw_1.RowCount() > 0 THEN
	FOR k = 1 TO dw_1.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_1.RowCount()
		dw_1.SetItem(k,'sflag','M')
	NEXT

	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kcda04
boolean visible = false
integer x = 3113
integer y = 2816
end type

type cb_mod from w_inherite`cb_mod within w_kcda04
boolean visible = false
integer x = 2181
integer y = 2816
integer width = 293
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_1.AcceptText() = -1 THEN Return

IF dw_1.RowCount() > 0 THEN
	FOR k = 1 TO dw_1.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_1.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_1.RowCount()
		dw_1.SetItem(k,'sflag','M')
	NEXT

	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kcda04
boolean visible = false
integer x = 78
integer y = 2816
integer width = 293
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue

sle_msg.text =""

IF dw_1.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_1.InsertRow(0)

	dw_1.ScrollToRow(iCurRow)
	dw_1.SetItem(iCurRow,'sflag','I')
	dw_1.SetColumn("card_no")
	dw_1.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_kcda04
boolean visible = false
integer x = 2491
integer y = 2816
integer width = 293
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_1.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_1.DeleteRow(dw_1.GetRow())
IF dw_1.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_1.RowCount()
		dw_1.SetItem(k,'sflag','M')
	NEXT
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kcda04
boolean visible = false
integer x = 1029
integer y = 2480
integer width = 293
end type

type cb_print from w_inherite`cb_print within w_kcda04
integer x = 2354
integer y = 2500
integer width = 293
end type

type st_1 from w_inherite`st_1 within w_kcda04
integer width = 334
end type

type cb_can from w_inherite`cb_can within w_kcda04
boolean visible = false
integer x = 2802
integer y = 2816
integer width = 293
end type

event cb_can::clicked;call super::clicked;
sle_msg.text =""

dw_1.SetRedraw(False)
IF dw_1.Retrieve() > 0 THEN
	dw_1.ScrollToRow(1)
	dw_1.SetColumn("owner")
	dw_1.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_1.SetRedraw(True)

cb_1.TriggerEvent(Clicked!)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_kcda04
integer x = 1879
integer y = 2472
integer width = 425
end type

type dw_datetime from w_inherite`dw_datetime within w_kcda04
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kcda04
integer width = 2469
end type



type gb_button1 from w_inherite`gb_button1 within w_kcda04
boolean visible = false
integer x = 46
integer y = 2760
integer width = 361
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda04
boolean visible = false
integer x = 2139
integer y = 2760
integer width = 1349
end type

type dw_1 from u_key_enter within w_kcda04
event ue_key pbm_dwnkey
integer x = 110
integer y = 200
integer width = 4485
integer height = 2056
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kcda04_1"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;
If keydown(keytab!) and dw_1.getcolumnname() = "gj_ymd" then
   if dw_1.rowcount() = dw_1.getrow() then
   	cb_ins.postevent(clicked!)
   end if
end if
end event

event retrieverow;
IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String   sNullValue,sCardNo,sCardKind,sCardName,sCardGbn,sValYmd
Integer  iReturnRow,lRow,iGjYmd

SetNull(sNullValue)

this.AcceptText()

lRow = this.GetRow()

IF this.GetColumnName() = "card_no" THEN
	sCardNo = this.GetText()
	IF sCardNo = "" OR IsNull(sCardNo) THEN RETURN
	
	iReturnRow = dw_1.find("card_no ='" +sCardNo + "'", 1, dw_1.RowCount())

	IF (lRow <> iReturnRow) and (iReturnRow <> 0) THEN
		f_MessageChk(10,'[카드번호]')
		this.SetItem(lRow, "card_no", sNullValue)
		RETURN  1
	END IF
END IF

IF this.GetColumnName() ="cus_cd" THEN
	sCardKind = this.GetText()
	IF sCardKind = "" OR IsNull(sCardKind) THEN RETURN
	
	SELECT "REFFPF"."RFNA1"	INTO :sCardName
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'CD' ) AND  ( "REFFPF"."RFGUB" = :sCardKind )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"카드종류")
		dw_1.SetItem(lRow,"cus_cd",snullvalue)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="card_gu" THEN
	sCardGbn = this.GetText()
	IF sCardGbn = "" OR IsNull(sCardGbn) THEN RETURN
	
	IF Integer(sCardGbn) <= 0 OR Integer(sCardGbn) >= 3 THEN
		f_messagechk(20,"구분")
		dw_1.SetItem(lRow,"card_gu",snullvalue)
		RETURN 1
	END IF
END IF

IF this.GetColumnName() ="val_ymd" THEN
	sValYmd = Trim(this.GetText())
	IF sValYmd = "" OR IsNull(sValYmd) THEN RETURN
	
	IF f_DateChk(sValYmd+"01") = -1 THEN 
		f_messagechk(21,"유효기간") 
		dw_1.SetItem(lRow,"val_ymd",snullvalue)
		RETURN 1
	END IF
END IF

IF this.GetColumnName() ="gj_ymd" THEN
	iGjYmd = Integer(this.GetText())
	IF iGjYmd = 0 OR IsNull(iGjYmd) THEN RETURN
	
	IF iGjYmd <= 0 OR iGjYmd >= 32 THEN 
		f_messagechk(21,"결재일")
		dw_1.SetItem(lRow,"gj_ymd",0)
		RETURN 1
	END IF
END IF
end event

event itemfocuschanged;
IF this.GetColumnName() = "owner" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))	
END IF
end event

event editchanged;ib_any_typing = True
end event

type sle_search from singlelineedit within w_kcda04
integer x = 882
integer y = 56
integer width = 562
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;Cb_1.TriggerEvent(Clicked!)
end event

type rb_1 from radiobutton within w_kcda04
integer x = 178
integer y = 64
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "카드번호"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_kcda04
integer x = 530
integer y = 64
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "회원명"
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_kcda04
integer x = 3095
integer y = 52
integer width = 608
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
string text = "신용카드 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;cbx_1.Checked = False

iw_preview.title = '신용카드 미리보기'
iw_preview.dw_preview.dataobject = 'dw_kcda04_2'
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

type cb_1 from picture within w_kcda04
integer x = 1463
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\검색_up.gif"
boolean focusrectangle = false
end type

event clicked;String sSearch

sSearch = Trim(sle_search.Text)
IF sSearch = "" OR IsNull(sSearch) THEN
		dw_1.SetFilter('')		
ELSE
	IF rb_1.Checked = True THEN									/*카드번호*/
		dw_1.SetFilter("card_no like '"+sSearch+'%'+"'")	
	ELSE
		dw_1.SetFilter("owner like '"+sSearch+'%'+"'")	
	END IF
END IF

dw_1.FilTer()

end event

type gb_1 from groupbox within w_kcda04
integer x = 3049
integer y = 4
integer width = 690
integer height = 144
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

type rr_1 from roundrectangle within w_kcda04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 105
integer y = 8
integer width = 1595
integer height = 172
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kcda04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 188
integer width = 4517
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 46
end type

