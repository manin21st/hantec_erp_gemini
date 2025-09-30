$PBExportHeader$w_ktxa70.srw
$PBExportComments$원산지확인서 발급세액공제신고서
forward
global type w_ktxa70 from w_inherite
end type
type dw_cond from u_key_enter within w_ktxa70
end type
type dw_lst from u_d_popup_sort within w_ktxa70
end type
type dw_detail from u_key_enter within w_ktxa70
end type
type dw_mvat from datawindow within w_ktxa70
end type
type cb_add_rpt from commandbutton within w_ktxa70
end type
type cb_1 from commandbutton within w_ktxa70
end type
type rr_1 from roundrectangle within w_ktxa70
end type
end forward

global type w_ktxa70 from w_inherite
integer width = 4645
integer height = 2524
string title = "원산지확인서 발급세액공제신고서"
dw_cond dw_cond
dw_lst dw_lst
dw_detail dw_detail
dw_mvat dw_mvat
cb_add_rpt cb_add_rpt
cb_1 cb_1
rr_1 rr_1
end type
global w_ktxa70 w_ktxa70

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sCrtDate, sSaupNo, sGeyDate, sItdsc, sTaxDate
Double  dQty, dAmt
Long    lSerNo

dw_lst.AcceptText()
lSerNo    = dw_lst.GetItemNumber(dw_lst.GetRow(),"kfz17ot3_serno")
sCrtDate  = Trim(dw_lst.GetItemString(icurrow,"kfz17ot3_crtdate"))

sSaupNo   = dw_lst.GetItemString(icurrow,"kfz17ot3_saupno")

sGeyDate  = Trim(dw_lst.GetItemString(icurrow,"kfz17ot3_geydate"))
sItdsc    = dw_lst.GetItemString(icurrow,"kfz17ot3_itdsc") 
dQty      = dw_lst.GetItemNumber(icurrow,"kfz17ot3_qty") 

sTaxDate  = Trim(dw_lst.GetItemString(icurrow,"kfz17ot3_taxdate"))
dAmt   = dw_lst.GetItemNumber(icurrow,"kfz17ot3_gonamt") 

IF lSerNo = 0 OR IsNull(lSerNo) THEN 
	F_MessageChk(1,'[일련번호]')
	dw_lst.SetColumn("kfz17ot3_serno")
	dw_lst.SetFocus()
	Return -1
END IF

IF sCrtDate = "" OR IsNull(sCrtDate) THEN 
	F_MessageChk(1,'[작성일]')
	dw_lst.SetColumn("kfz17ot3_crtdate")
	dw_lst.SetFocus()
	Return -1
END IF

IF sSaupNo = "" OR IsNull(sSaupNo) THEN 
	F_MessageChk(1,'[거래처]')
	dw_lst.SetColumn("kfz17ot3_saupno")
	dw_lst.SetFocus()
	Return -1
END IF

IF sGeyDate = "" OR IsNull(sGeyDate) THEN 
	F_MessageChk(1,'[공급일]')
	dw_lst.SetColumn("kfz17ot3_geydate")
	dw_lst.SetFocus()
	Return -1
END IF

IF sItdsc = "" OR IsNull(sItdsc) THEN 
	F_MessageChk(1,'[품명]')
	dw_lst.SetColumn("kfz17ot3_itdsc")
	dw_lst.SetFocus()
	Return -1
END IF

IF sTaxDate = "" OR IsNull(sTaxDate) THEN 
	F_MessageChk(1,'[세금계산서 작성일]')
	dw_lst.SetColumn("kfz17ot3_taxdate")
	dw_lst.SetFocus()
	Return -1
END IF

IF dQty = 0 OR IsNull(dQty) THEN
	F_MessageChk(1,'[수량]')
	dw_lst.SetColumn("kfz17ot3_qty")
	dw_lst.SetFocus()
	Return -1
END IF

IF dAmt = 0 OR IsNull(dAmt) THEN
	F_MessageChk(1,'[공급가액]')
	dw_lst.SetColumn("kfz17ot3_gonamt")
	dw_lst.SetFocus()
	Return -1
END IF

Return 1
end function

on w_ktxa70.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_lst=create dw_lst
this.dw_detail=create dw_detail
this.dw_mvat=create dw_mvat
this.cb_add_rpt=create cb_add_rpt
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_lst
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_mvat
this.Control[iCurrent+5]=this.cb_add_rpt
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.rr_1
end on

on w_ktxa70.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_lst)
destroy(this.dw_detail)
destroy(this.dw_mvat)
destroy(this.cb_add_rpt)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;String  sJasa, sVatGisu,sStart, sEnd

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

select rfna2 into :sJasa from reffpf where rfcod = 'AD' and rfgub = :Gs_Saupj ;

dw_cond.SetItem(1,"saupj",   Gs_Saupj)
dw_cond.SetItem(1,"jasa_cd", sJasa)

sVatGisu = F_Get_VatGisu(gs_saupj,f_today())
										
SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
	INTO :sStart,								:sEnd  
   FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;
dw_cond.SetItem(1,"gisu", sVatGisu)
dw_cond.SetItem(1,"fymd", Left(f_Today(),4)+sStart)
dw_cond.SetItem(1,"tymd", Left(f_Today(),4)+sEnd)
	
dw_lst.SetTransObject(SQLCA)
dw_lst.Reset()

dw_detail.SetTransObject(SQLCA)
dw_detail.Reset()
dw_detail.InsertRow(0)

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_ins.Enabled = False

end event

type dw_insert from w_inherite`dw_insert within w_ktxa70
boolean visible = false
integer x = 750
integer y = 2432
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa70
boolean visible = false
integer x = 3826
integer y = 3248
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa70
boolean visible = false
integer x = 3643
integer y = 3244
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa70
boolean visible = false
integer x = 3269
integer y = 3252
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa70
boolean visible = false
integer x = 4882
integer y = 760
integer taborder = 50
string picturename = "C:\erpman\image\추가_d.gif"
end type

type p_exit from w_inherite`p_exit within w_ktxa70
integer x = 4411
integer y = 4
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_ktxa70
integer x = 4238
integer y = 4
integer taborder = 80
end type

event p_can::clicked;call super::clicked;String           sJasa,sFrom, sTo

sJasa  = dw_cond.GetItemString(1,"jasa_cd")
sFrom  = Trim(dw_cond.GetItemString(1,"fymd"))
sTo    = Trim(dw_cond.GetItemString(1,"tymd"))

dw_lst.Retrieve(sFrom,sTo,sJasa)

if dw_detail.Retrieve(sFrom,sTo,sJasa) <=0 then
	dw_detail.InsertRow(0)
	
	dw_detail.SetItem(1,"rpt_fr",sFrom)
	dw_detail.SetItem(1,"rpt_to",sTo)
	dw_detail.SetItem(1,"jasa_cd",sJasa)
end if

ib_any_typing = False

end event

type p_print from w_inherite`p_print within w_ktxa70
boolean visible = false
integer x = 3465
integer y = 3240
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_ktxa70
integer x = 3717
integer y = 4
end type

event p_inq::clicked;call super::clicked;String           sJasa,sFrom, sTo

if dw_cond.AcceptText() = -1 then Return

sJasa  = dw_cond.GetItemString(1,"jasa_cd")
sFrom  = Trim(dw_cond.GetItemString(1,"fymd"))
sTo    = Trim(dw_cond.GetItemString(1,"tymd"))

if sJasa = '' or IsNull(sJasa) then
	F_MessageChk(1,'[자사]')
	dw_cond.SetColumn("jasa_cd")
	dw_cond.SetFocus()
	Return
end if

if sFrom = '' or IsNull(sFrom) then
	F_MessageChk(1,'[신고기간]')
	dw_cond.SetColumn("fymd")
	dw_cond.SetFocus()
	Return
end if
if sTo = '' or IsNull(sTo) then
	F_MessageChk(1,'[신고기간]')
	dw_cond.SetColumn("tymd")
	dw_cond.SetFocus()
	Return
end if

p_ins.PictureName = 'C:\erpman\image\추가_up.gif'
p_ins.Enabled = True

if dw_lst.Retrieve(sFrom,sTo,sJasa) <=0 then
	F_MessageChk(14,'')
end if

dw_detail.Retrieve(sFrom,sTo,sJasa)
if dw_detail.RowCount() <=0 then
	dw_detail.InsertRow(0)
	
	dw_detail.SetItem(1,"rpt_fr",sFrom)
	dw_detail.SetItem(1,"rpt_to",sTo)
	dw_detail.SetItem(1,"jasa_cd",sJasa)
end if
	
dw_lst.SetFocus()
end event

type p_del from w_inherite`p_del within w_ktxa70
integer x = 4064
integer y = 4
integer taborder = 70
end type

event p_del::clicked;call super::clicked;Integer iRow

iRow = dw_lst.GetRow()

IF iRow <=0 THEN Return

IF F_DbConFirm("삭제") = 2 THEN Return

IF iRow = 1 THEN
	dw_lst.DeleteRow(0)
	IF dw_lst.Update() <> 1 THEN
		F_MessageChk(12,'')
		Rollback;
		Return
	ELSE
		dw_detail.SetRedraw(False)
		dw_detail.DeleteRow(0)
		IF dw_detail.Update() <> 1 THEN
			F_MessageChk(12,'')
			Rollback;
			dw_detail.SetRedraw(True)
			Return
		END IF
		dw_detail.SetRedraw(True)
	END IF
ELSE
	dw_lst.DeleteRow(0)
	IF dw_lst.Update() <> 1 THEN
		F_MessageChk(12,'')
		Rollback;
		Return
	ELSE
		dw_detail.SetItem(1,"balcnt", dw_lst.GetItemNumber(1,"balcnt"))
		dw_detail.SetItem(1,"subamt", dw_detail.GetItemNumber(1,"calc_subamt"))
		dw_detail.SetItem(1,"gongtax", dw_detail.GetItemNumber(1,"calc_gongtax"))
		dw_detail.SetItem(1,"hangoamt", dw_detail.GetItemNumber(1,"calc_hangoamt"))
		IF dw_detail.Update() <> 1 THEN
			F_MessageChk(12,'')
			Rollback;
			dw_detail.SetRedraw(True)
			Return
		END IF
	END IF
END IF

commit;

if iRow <> 1 then
	dw_detail.ScrollToRow(iRow - 1)
end if

dw_lst.SetFocus()

ib_any_typing = False

w_mdi_frame.sle_msg.Text = '자료를 저장하였습니다!!'
end event

type p_mod from w_inherite`p_mod within w_ktxa70
integer x = 3890
integer y = 4
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;
dw_lst.AcceptText()
IF dw_detail.GetRow() <=0 THEN Return

IF Wf_RequiredChk(dw_lst.GetRow()) = -1 THEN Return

IF F_DbConFirm("저장") = 2 THEN Return

IF dw_lst.Update() <> 1 THEN
	F_MessageChk(13,'')
	Rollback;
	Return
else
	dw_detail.SetItem(1,"balcnt", dw_lst.GetItemNumber(1,"balcnt"))
	dw_detail.SetItem(1,"subamt", dw_detail.GetItemNumber(1,"calc_subamt"))
	dw_detail.SetItem(1,"gongtax", dw_detail.GetItemNumber(1,"calc_gongtax"))
	dw_detail.SetItem(1,"hangoamt", dw_detail.GetItemNumber(1,"calc_hangoamt"))

	IF dw_detail.Update() <> 1 THEN
		F_MessageChk(13,'')
		Rollback;
		Return
	END IF
END IF

commit;

ib_any_typing = False

w_mdi_frame.sle_msg.Text = '자료를 저장하였습니다!!'

end event

type cb_exit from w_inherite`cb_exit within w_ktxa70
end type

type cb_mod from w_inherite`cb_mod within w_ktxa70
end type

type cb_ins from w_inherite`cb_ins within w_ktxa70
end type

type cb_del from w_inherite`cb_del within w_ktxa70
end type

type cb_inq from w_inherite`cb_inq within w_ktxa70
end type

type cb_print from w_inherite`cb_print within w_ktxa70
end type

type st_1 from w_inherite`st_1 within w_ktxa70
end type

type cb_can from w_inherite`cb_can within w_ktxa70
end type

type cb_search from w_inherite`cb_search within w_ktxa70
end type







type gb_button1 from w_inherite`gb_button1 within w_ktxa70
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa70
end type

type dw_cond from u_key_enter within w_ktxa70
integer x = 18
integer y = 12
integer width = 2537
integer height = 144
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_ktxa70_1"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String sJasa,sSaupj, sVatGisu,sNull,sStart,sEnd

if this.GetColumnName() = 'jasa_cd' then
	sJasa = this.GetText()
	if sJasa = '' or IsNull(sJasa) then Return
	
	select rfna3 into :sSaupj from reffpf where rfcod = 'JA' and rfgub = :sJasa;
	
	this.SetItem(this.GetRow(),"saupj", sSaupj)
end if

IF this.GetColumnName() = "gisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(this.GetRow(),"gisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,4),	SUBSTR("REFFPF"."RFNA2",5,4)  /*부가세 기수에 해당하는 거래기간*/
			INTO :sStart,								:sEnd  
   		FROM "REFFPF"  
		   WHERE ( "REFFPF"."RFCOD" = 'AV' ) AND  ( "REFFPF"."RFGUB" = :sVatGisu ) ;
		this.SetItem(this.GetRow(),"fymd",Left(f_Today(),4)+sStart)
		this.SetItem(this.GetRow(),"tymd",Left(f_Today(),4)+sEnd)	
	END IF
END IF

IF this.GetColumnName() ="fymd" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"신고기간")
		this.SetItem(1,"fymd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="tymd" THEN
	IF f_datechk(Trim(this.GetText())) = -1 THEN 
		f_messagechk(20,"신고기간")
		this.SetItem(1,"tymd",snull)
		Return 1
	END IF
END IF

end event

type dw_lst from u_d_popup_sort within w_ktxa70
integer x = 41
integer y = 372
integer width = 4530
integer height = 1888
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_ktxa70_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False

	SelectRow(0,False)
	SelectRow(row,True)
	
	dw_detail.ScrollToRow(row)
END IF

CALL SUPER ::CLICKED

dw_detail.ScrollToRow(this.GetSelectedRow(0))

end event

event rowfocuschanged;call super::rowfocuschanged;//if currentrow <=0 then Return
//
//SelectRow(0,False)
//SelectRow(currentrow,True)
//
//dw_detail.ScrollToRow(currentrow)
end event

event retrieveend;call super::retrieveend;//Integer k
//
//if rowcount <=0 then return
//
//for k = 1 to rowcount
//	this.SetItem(k, "sflag", 'M')	
//next
end event

event rbuttondown;call super::rbuttondown;String snull

SetNull(snull)

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.AcceptText()

IF this.GetColumnName() ="kfz17ot3_saupno" THEN
	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"kfz17ot3_saupno"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"kfz17ot3_saupno",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String  sSaupNo,sCvName,sSano, sNull
Integer  iCurRow

SetNull(sNull)

iCurRow = this.GetRow()
IF this.GetColumnName() ="kfz17ot3_crtdate" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN RETURN	
	
	IF F_DateChk(data) = -1 THEN 
		F_MessageChk(21,'[작성일자]')
		this.SetItem(iCurRow,"kfz17ot3_crtdate",sNull)
		Return 1
	END IF		
END IF

IF this.GetColumnName() = "kfz17ot3_saupno" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		
		this.SetItem(iCurRow,"vndmst_cvnas",   sNull)
		this.SetItem(iCurRow,"vndmst_sano",sNull)
		Return
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "VNDMST"."CVNAS",	   	"VNDMST"."SANO"
	   INTO :sCvName,   					:sSano 
	   FROM "VNDMST"  
   	WHERE ( "VNDMST"."CVCOD" = :sSaupNo);
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(iCurRow,"vndmst_cvnas",   sCvName)
		this.SetItem(iCurRow,"vndmst_sano",		sSano)
	ELSE
		F_MessageChk(20,'[거래처]')
		
		this.SetItem(iCurRow,"vndmst_cvnas", sNull)
		this.SetItem(iCurRow,"vndmst_sano",   sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="kfz17ot3_geydate" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN RETURN	
	
	IF F_DateChk(data) = -1 THEN 
		F_MessageChk(21,'[공급일]')
		this.SetItem(iCurRow,"kfz17ot3_geydate",sNull)
		Return 1
	END IF		
END IF
IF this.GetColumnName() ="kfz17ot3_taxdate" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN RETURN	
	
	IF F_DateChk(data) = -1 THEN 
		F_MessageChk(21,'[세금계산사 작성일]')
		this.SetItem(iCurRow,"kfz17ot3_taxdate",sNull)
		Return 1
	END IF		
END IF

dw_detail.SetItem(1,"balcnt", this.GetItemNumber(1,"balcnt"))
dw_detail.SetItem(1,"subamt", dw_detail.GetItemNumber(1,"calc_subamt"))
dw_detail.SetItem(1,"gongtax", dw_detail.GetItemNumber(1,"calc_gongtax"))
dw_detail.SetItem(1,"hangoamt", dw_detail.GetItemNumber(1,"calc_hangoamt"))
	
ib_any_typing = True
end event

type dw_detail from u_key_enter within w_ktxa70
integer x = 27
integer y = 160
integer width = 4581
integer height = 196
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_ktxa70_2"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then Return

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(currentrow,True)
end event

type dw_mvat from datawindow within w_ktxa70
boolean visible = false
integer x = 2222
integer y = 2460
integer width = 1029
integer height = 116
boolean bringtotop = true
boolean titlebar = true
string title = "미결부가세 갱신"
string dataobject = "dw_kgla032"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type cb_add_rpt from commandbutton within w_ktxa70
integer x = 3282
integer y = 12
integer width = 398
integer height = 68
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인서추가"
end type

event clicked;Integer iCurRow

if dw_lst.GetRow() > 0 then
	if Wf_RequiredChk(dw_lst.GetRow()) = -1 then Return
end if

sModStatus = 'I'

dw_lst.SetRedraw(False)

iCurRow = dw_lst.InsertRow(0)

dw_lst.SetItem(iCurRow,"kfz17ot3_rpt_fr",   dw_cond.GetItemString(1,"fymd"))
dw_lst.SetItem(iCurRow,"kfz17ot3_rpt_to",   dw_cond.GetItemString(1,"tymd"))
dw_lst.SetItem(iCurRow,"kfz17ot3_jasa_cd",  dw_cond.GetItemString(1,"jasa_cd"))

if iCurRow = 1 then
	dw_lst.SetItem(iCurRow,"kfz17ot3_serno",  iCurRow)
else
	dw_lst.SetItem(iCurRow,"kfz17ot3_serno",  dw_lst.GetItemNumber(1,"max_serno") + 1)
end if

//dw_lst.SetItem(iCurRow,"sflag",    sModStatus)
dw_lst.ScrollToRow(iCurRow)

dw_lst.SetRedraw(True)

dw_lst.ScrollToRow(iCurRow)
dw_lst.SetColumn("kfz17ot3_crtdate")
dw_lst.SetFocus()

end event

type cb_1 from commandbutton within w_ktxa70
integer x = 3282
integer y = 84
integer width = 398
integer height = 68
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "공급물품추가"
end type

event clicked;Integer iCurRow, iSelectRow

iSelectRow = dw_lst.GetRow()

if iSelectRow > 0 then
	if Wf_RequiredChk(iSelectRow) = -1 then Return
end if

sModStatus = 'I'

dw_lst.SetRedraw(False)

iCurRow = dw_lst.InsertRow(0)

dw_lst.SetItem(iCurRow,"kfz17ot3_rpt_fr",   dw_cond.GetItemString(1,"fymd"))
dw_lst.SetItem(iCurRow,"kfz17ot3_rpt_to",   dw_cond.GetItemString(1,"tymd"))
dw_lst.SetItem(iCurRow,"kfz17ot3_jasa_cd",  dw_cond.GetItemString(1,"jasa_cd"))
dw_lst.SetItem(iCurRow,"kfz17ot3_serno",    dw_lst.GetItemNumber(iSelectRow,"kfz17ot3_serno"))
dw_lst.SetItem(iCurRow,"kfz17ot3_crtdate",  dw_lst.GetItemString(iSelectRow,"kfz17ot3_crtdate"))
dw_lst.SetItem(iCurRow,"kfz17ot3_saupno",   dw_lst.GetItemString(iSelectRow,"kfz17ot3_saupno"))
dw_lst.SetItem(iCurRow,"vndmst_cvnas",      dw_lst.GetItemString(iSelectRow,"vndmst_cvnas"))
dw_lst.SetItem(iCurRow,"vndmst_sano",       dw_lst.GetItemString(iSelectRow,"vndmst_sano"))

//dw_lst.SetItem(iCurRow,"sflag",    sModStatus)
dw_lst.ScrollToRow(iCurRow)

dw_lst.SetRedraw(True)

dw_lst.ScrollToRow(iCurRow)
dw_lst.SetColumn("kfz17ot3_geydate")
dw_lst.SetFocus()

p_ins.PictureName = 'C:\erpman\image\추가_d.gif'
p_ins.Enabled = False





end event

type rr_1 from roundrectangle within w_ktxa70
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 360
integer width = 4558
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

