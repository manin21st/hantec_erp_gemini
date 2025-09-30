$PBExportHeader$w_kcda06.srw
$PBExportComments$적요코드 등록
forward
global type w_kcda06 from w_inherite
end type
type cbx_1 from checkbox within w_kcda06
end type
type dw_1 from datawindow within w_kcda06
end type
type cb_append from commandbutton within w_kcda06
end type
type gb_2 from groupbox within w_kcda06
end type
type rr_1 from roundrectangle within w_kcda06
end type
end forward

global type w_kcda06 from w_inherite
string title = "적요코드 등록"
cbx_1 cbx_1
dw_1 dw_1
cb_append cb_append
gb_2 gb_2
rr_1 rr_1
end type
global w_kcda06 w_kcda06

type variables
Boolean itemerr =False

w_preview  iw_preview
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);
String sAcc1,sAcc2,sDcGbn,sRmCode,sRmDesc

dw_1.AcceptText()
sAcc1   = dw_1.GetItemString(ll_row,"acc1_cd")
sAcc2   = dw_1.GetItemString(ll_row,"acc2_cd")
sDcGbn  = dw_1.GetItemString(ll_row,"dc_gu") 
sRmCode = dw_1.GetItemString(ll_row,"rm_cd") 
sRmDesc = dw_1.GetItemString(ll_row,"rm_desc") 

IF sAcc1 = "" OR IsNull(sAcc1) THEN
	f_messagechk(1,'[계정과목]')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	Return -1
END IF
IF sAcc2 = "" OR IsNull(sAcc2) THEN
	f_messagechk(1,'[계정과목]')
	dw_1.SetColumn("acc2_cd")
	dw_1.SetFocus()
	Return -1
END IF
IF sDcGbn = "" OR IsNull(sDcGbn) THEN
	f_messagechk(1,'[차대구분]')
	dw_1.SetColumn("dc_gu")
	dw_1.SetFocus()
	Return -1
END IF

IF sRmCode = "" OR IsNull(sRmCode) THEN
	f_messagechk(1,'[적요코드]')
	dw_1.SetColumn("rm_cd")
	dw_1.SetFocus()
	Return -1
END IF
IF sRmDesc = "" OR IsNull(sRmDesc) THEN
	f_messagechk(1,'[적요명]')
	dw_1.SetColumn("rm_desc")
	dw_1.SetFocus()
	Return -1
END IF
Return 1
end function

public function integer wf_dup_chk (integer ll_row);String  sAcc1,sAcc2,sDcGbn,sRmCode
Integer iReturnRow

sAcc1   = dw_1.GetItemString(ll_row,"acc1_cd")
sAcc2   = dw_1.GetItemString(ll_row,"acc2_cd")
sDcGbn  = dw_1.GetItemString(ll_row,"dc_gu") 
sRmCode = dw_1.GetItemString(ll_row,"rm_cd") 

IF sAcc1   ="" OR IsNull(sAcc1)   THEN RETURN 1
IF sAcc2   ="" OR IsNull(sAcc2)   THEN RETURN 1
IF sDcGbn  ="" OR IsNull(sDcGbn)  THEN RETURN 1
IF sRmCode ="" OR IsNull(sRmCode) THEN RETURN 1

iReturnRow = dw_1.find("acc1_cd ='" + sAcc1 + "' and acc2_cd = '" + sAcc2+"' and dc_gu = '"+sDcGbn+"' and rm_cd = '"+ sRmCode + "'", 1, dw_1.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[적요코드]')
	RETURN  -1
END IF
	
Return 1
end function

on w_kcda06.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.cb_append=create cb_append
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_append
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_kcda06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.cb_append)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_1.SetTransObject(SQLCA)

IF dw_1.Retrieve() > 0 THEN
	dw_1.ScrollToRow(1)
	dw_1.SetColumn("rm_desc")
	dw_1.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF

IF dw_1.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF

ib_any_typing =False

open( iw_preview, this)

end event

type dw_insert from w_inherite`dw_insert within w_kcda06
integer x = 18
integer y = 2756
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda06
boolean visible = false
integer x = 4105
integer y = 2852
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda06
boolean visible = false
integer x = 3931
integer y = 2852
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda06
boolean visible = false
integer x = 3049
integer y = 2844
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kcda06
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iGetRow

w_mdi_frame.sle_msg.text =""

IF dw_1.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
	
	iGetRow = dw_1.GetRow()
ELSE
	iFunctionValue = 1	
	
	iGetRow = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iGetRow + 1
	
	dw_1.InsertRow(iCurRow)

	dw_1.ScrollToRow(iCurRow)
	dw_1.SetItem(iCurRow,'sflag','I')
	
	IF iGetRow <> 0 THEN
		dw_1.SetItem(iCurRow,"acc1_cd",dw_1.GetItemString(iGetRow,"acc1_cd"))
		dw_1.SetItem(iCurRow,"acc2_cd",dw_1.GetItemString(iGetRow,"acc2_cd"))
		dw_1.SetItem(iCurRow,"kfz01om0_acc2_nm",dw_1.GetItemString(iGetRow,"kfz01om0_acc2_nm"))
		dw_1.SetItem(iCurRow,"dc_gu",dw_1.GetItemString(iGetRow,"dc_gu"))
		dw_1.SetColumn("rm_cd")
	ELSE
		dw_1.SetColumn("acc1_cd")
	END IF
	dw_1.SetFocus()
	
	ib_any_typing =False

END IF

end event

type p_exit from w_inherite`p_exit within w_kcda06
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kcda06
integer taborder = 50
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_1.SetRedraw(False)
IF dw_1.Retrieve() > 0 THEN
	dw_1.ScrollToRow(1)
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_1.SetRedraw(True)

ib_any_typing =False


end event

type p_print from w_inherite`p_print within w_kcda06
boolean visible = false
integer x = 3301
integer y = 2836
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda06
boolean visible = false
integer x = 3584
integer y = 2852
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kcda06
integer taborder = 40
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
	
	dw_1.SetColumn("rm_desc")
	dw_1.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kcda06
integer taborder = 30
end type

event p_mod::clicked;Integer k,iRtnValue

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

	dw_1.SetColumn("rm_desc")
	dw_1.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_1.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kcda06
boolean visible = false
integer x = 3360
integer y = 2668
end type

type cb_mod from w_inherite`cb_mod within w_kcda06
boolean visible = false
integer x = 2290
integer y = 2668
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

	dw_1.SetColumn("rm_desc")
	dw_1.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_1.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF


end event

type cb_ins from w_inherite`cb_ins within w_kcda06
boolean visible = false
integer x = 608
integer y = 2668
string text = "삽입(&I)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iGetRow

sle_msg.text =""

IF dw_1.GetRow() <=0 THEN RETURN

IF dw_1.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
	
	iGetRow = dw_1.GetRow()
ELSE
	iFunctionValue = 1	
	
	iGetRow = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iGetRow + 1
	
	dw_1.InsertRow(iCurRow)

	dw_1.ScrollToRow(iCurRow)
	dw_1.SetItem(iCurRow,'sflag','I')
	
	IF iGetRow <> 0 THEN
		dw_1.SetItem(iCurRow,"acc1_cd",dw_1.GetItemString(iGetRow,"acc1_cd"))
		dw_1.SetItem(iCurRow,"acc2_cd",dw_1.GetItemString(iGetRow,"acc2_cd"))
		dw_1.SetItem(iCurRow,"kfz01om0_acc2_nm",dw_1.GetItemString(iGetRow,"kfz01om0_acc2_nm"))
		dw_1.SetItem(iCurRow,"dc_gu",dw_1.GetItemString(iGetRow,"dc_gu"))
		dw_1.SetColumn("rm_cd")
	ELSE
		dw_1.SetColumn("acc1_cd")
	END IF
	dw_1.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_kcda06
boolean visible = false
integer x = 2647
integer y = 2668
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
	
	dw_1.SetColumn("rm_desc")
	dw_1.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kcda06
boolean visible = false
integer x = 1038
integer y = 2416
end type

type cb_print from w_inherite`cb_print within w_kcda06
boolean visible = false
integer x = 1833
integer y = 2476
end type

type st_1 from w_inherite`st_1 within w_kcda06
integer x = 41
integer y = 2968
integer width = 361
end type

type cb_can from w_inherite`cb_can within w_kcda06
boolean visible = false
integer x = 3003
integer y = 2668
end type

event cb_can::clicked;call super::clicked;
sle_msg.text =""

dw_1.SetRedraw(False)
IF dw_1.Retrieve() > 0 THEN
	dw_1.ScrollToRow(1)
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_1.SetRedraw(True)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_kcda06
boolean visible = false
integer x = 2107
integer y = 2416
end type

type dw_datetime from w_inherite`dw_datetime within w_kcda06
integer x = 2848
integer y = 2968
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kcda06
integer x = 416
integer y = 2968
integer width = 2437
end type

type gb_10 from w_inherite`gb_10 within w_kcda06
integer x = 23
integer y = 2916
integer width = 3575
end type

type gb_button1 from w_inherite`gb_button1 within w_kcda06
boolean visible = false
integer x = 229
integer y = 2616
integer width = 750
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda06
boolean visible = false
integer x = 2249
integer y = 2616
end type

type cbx_1 from checkbox within w_kcda06
integer x = 2770
integer y = 72
integer width = 905
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "계정별 적요 일람표 미리보기"
end type

event clicked;
long ll_row
String sacc1f,sacc2f,sacc1t,sacc2t,sname1,sname2,snamef,snamet

IF dw_1.AcceptText() = -1 THEN RETURN 
IF dw_1.RowCount() <=0 then Return

sacc1f ="10000"
sacc2f ="00"
snamef ="[자산]"

sacc1t ="99999"
sacc2t ="99"
snamet ="  "

cbx_1.Checked = False

iw_preview.title = '계정별 적요 일람표 미리보기'
iw_preview.dw_preview.dataobject = 'dw_kcda06_3_p'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=2 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve(sacc1f,sacc2f,sacc1t,sacc2t,snamef,snamet) <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True

end event

type dw_1 from datawindow within w_kcda06
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 69
integer y = 216
integer width = 4480
integer height = 2064
integer taborder = 10
string dataobject = "dw_kcda06_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;string sacc1 ,sacc2,sAcc2Name,sDcGbn,sRmCode,sBalGbn,sNull

SetNull(snull)

w_mdi_frame.sle_msg.text =""

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
		this.Setitem(this.getrow(),"acc2_cd",sNull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		RETURN
	END IF
	
	sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM","KFZ01OM0"."BAL_GU"	INTO :sAcc2Name,	:sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"acc1_cd",snull)
			this.Setitem(this.getrow(),"acc2_cd",snull)
			this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
			Return 1
		END IF
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"acc1_cd",snull)
		this.Setitem(this.getrow(),"acc2_cd",snull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		Return 
	end if
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"acc1_cd",snull)
		RETURN 1
	END IF
END IF

IF this.GetColumnName() = 'acc2_cd' THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN 
		this.Setitem(this.getrow(),"acc1_cd",sNull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		RETURN
	END IF
	
	sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM","KFZ01OM0"."BAL_GU"	INTO :sAcc2Name,	:sBalGbn
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		IF sBalGbn = '4' THEN
			F_MessageChk(16,'[전표발행 불가]')
			this.Setitem(this.getrow(),"acc1_cd",snull)
			this.Setitem(this.getrow(),"acc2_cd",snull)
			this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
			Return 1
		END IF
		
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"acc1_cd",snull)
		this.Setitem(this.getrow(),"acc2_cd",snull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 
	end if
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"acc2_cd",snull)
		RETURN 1
	END IF
END IF

IF this.GetColumnName() ="dc_gu" THEN
	sDcGbn = this.GetText()
	IF sDcGbn = "" OR IsNull(sDcGbn) THEN Return
	
	IF sDcGbn <> '1' AND  sDcGbn <> '2' THEN
		f_messagechk(20,"차대구분")
		this.SetItem(this.GetRow(),"dc_gu",snull)
		Return 1
	END IF
	
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"dc_gu",snull)
		RETURN 1
	END IF
END IF

IF this.GetColumnName() ="rm_cd" THEN
	sRmCode = this.GetText()
	IF sRmCode = "" OR IsNull(sRmCode) THEN RETURN
	
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"rm_cd",snull)
		RETURN 1
	END IF
END IF
ib_any_typing =True
		

end event

event itemerror;
Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rm_desc" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rbuttondown;String ls_gj1,ls_gj2,rec_acc1,rec_acc2

SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

this.accepttext()

IF this.GetColumnName() ="acc1_cd" THEN

	ls_gj1 =dw_1.GetItemString(this.GetRow(),"acc1_cd")
	ls_gj2 =dw_1.GetItemString(this.GetRow(),"acc2_cd")

	IF IsNull(ls_gj1) then
   	ls_gj1 = ""
	end if
	
	IF IsNull(ls_gj2) then
   	ls_gj2 = ""
	end if
	
 	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)
	 
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	dw_1.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	dw_1.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	dw_1.SetItem(this.GetRow(),"kfz01om0_acc2_nm",lstr_account.acc2_nm)
	
	this.TriggerEvent(ItemChanged!)
END IF

end event

event rowfocuschanged;//this.SetRowFocusIndicator(Hand!)
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

type cb_append from commandbutton within w_kcda06
boolean visible = false
integer x = 261
integer y = 2668
integer width = 334
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;Integer  iCurRow,iFunctionValue,iRowCount

sle_msg.text =""

iRowCount = dw_1.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_1.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_1.InsertRow(iCurRow)

	dw_1.ScrollToRow(iCurRow)
	dw_1.SetItem(iCurRow,'sflag','I')
	dw_1.SetColumn("acc1_cd")
	dw_1.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_1.RowCount() <=0 THEN
	cb_ins.Enabled = False
ELSE
	cb_ins.Enabled = True
END IF


end event

type gb_2 from groupbox within w_kcda06
integer x = 2734
integer y = 36
integer width = 978
integer height = 128
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kcda06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 212
integer width = 4530
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 46
end type

