$PBExportHeader$w_kfia71.srw
$PBExportComments$금융기관별 담보설정등록
forward
global type w_kfia71 from w_inherite
end type
type dw_lst from datawindow within w_kfia71
end type
type dw_detail from u_key_enter within w_kfia71
end type
type dw_bnk from u_key_enter within w_kfia71
end type
type rr_1 from roundrectangle within w_kfia71
end type
end forward

global type w_kfia71 from w_inherite
string title = "금융기관별 담보설정 등록"
dw_lst dw_lst
dw_detail dw_detail
dw_bnk dw_bnk
rr_1 rr_1
end type
global w_kfia71 w_kfia71

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_setting_lst (string sbnkcd)
public function integer wf_setting_detail (integer icurrow)
public function long wf_no (string sbnk)
end prototypes

public function integer wf_requiredchk ();String  sBnk,sKind,sCont,sGrCd,sFrDate,sToDate
Double  dAmount

IF dw_detail.AcceptText() = -1 THEN Return -1

sBnk    = dw_detail.GetItemString(1,"bnk_cd")
sKind   = dw_detail.GetItemString(1,"dam_kind")
sCont   = dw_detail.GetItemString(1,"dam_cont")
sGrCd   = dw_detail.GetItemString(1,"gar_cd")
sFrDate = Trim(dw_detail.GetItemString(1,"dam_date"))
sToDate = Trim(dw_detail.GetItemString(1,"dam_freedate"))
dAmount = dw_detail.GetItemNumber(1,"dam_amt")

IF sBnk = "" OR IsNull(sBnk) THEN
	F_MessageChk(1,"[금융기관]")
	dw_detail.SetColumn("bnk_cd")
	dw_detail.SetFocus()
	Return -1
END IF
IF sKind = "" OR IsNull(sKind) THEN
	F_MessageChk(1,"[보증종류]")
	dw_detail.SetColumn("dam_kind")
	dw_detail.SetFocus()
	Return -1
END IF
IF sKind <> '3' THEN
	IF sCont = "" OR IsNull(sCont) THEN
		F_MessageChk(1,"[담보내용]")
		dw_detail.SetColumn("dam_cont")
		dw_detail.SetFocus()
		Return -1
	END IF
	
	IF sFrDate = "" OR IsNull(sFrDate) THEN
		F_MessageChk(1,"[담보설정일]")
		dw_detail.SetColumn("dam_date")
		dw_detail.SetFocus()
		Return -1
	END IF
	IF dAmount = 0 OR IsNull(dAmount) THEN
		F_MessageChk(1,"[설정금액]")
		dw_detail.SetColumn("dam_amt")
		dw_detail.SetFocus()
		Return -1
	END IF
END IF
Return 1
end function

public function integer wf_setting_lst (string sbnkcd);Integer iRow

IF IsNull(sbnkcd) THEN sBnkCd = '%'

iRow = dw_lst.Retrieve(sBnkCd)

IF iRow > 0 THEN
//	dw_lst.SelectRow(0,False)
//	dw_lst.SelectRow(1,True)
	
	Wf_Setting_Detail(0)	
ELSE
	Wf_Setting_Detail(0)	
END IF

Return iRow
end function

public function integer wf_setting_detail (integer icurrow);Integer iRow
String  sBnkCd

dw_bnk.AcceptText()
sBnkCd = dw_bnk.GetItemString(1,"bnk_cd")
IF IsNull(sBnkCd) THEN sBnkCd = '%'

IF iCurRow <=0 THEN
	sModStatus = 'I'
	dw_detail.SetRedraw(False)
	dw_detail.Reset()
	dw_detail.InsertRow(0)
	dw_detail.SetRedraw(True)
	
	IF sBnkCd <> '%' THEN
		dw_detail.SetItem(dw_detail.GetRow(),"bnk_cd",sBnkCd)
		dw_detail.SetColumn("dam_kind")
	ELSE
		dw_detail.SetColumn("bnk_cd")
	END IF
	ib_any_typing = True
ELSE
	dw_detail.SetRedraw(False)
	dw_detail.Retrieve(dw_lst.GetItemString(iCurRow,"bnk_cd"),dw_lst.GetItemNumber(iCurRow,"seq_no"),F_Today())
	dw_detail.SetRedraw(True)
	
	sModStatus = 'M'
	
	dw_detail.SetColumn("dam_kind")
	
	ib_any_typing = False
END IF
dw_detail.SetFocus()

Return 1
end function

public function long wf_no (string sbnk);
Integer iMaxNum

SELECT MAX(NVL("SEQ_NO",0))    INTO :iMaxNum  
	FROM "KFM07OT0"  
   WHERE "KFM07OT0"."BNK_CD" = :sBnk   ;
IF SQLCA.SQLCODE <> 0 THEN
	iMaxNum = 0
ELSE
	IF IsNull(iMaxNum) THEN iMaxNum = 0
END IF

iMaxNum = iMaxNum + 1
Return iMaxNum
end function

on w_kfia71.create
int iCurrent
call super::create
this.dw_lst=create dw_lst
this.dw_detail=create dw_detail
this.dw_bnk=create dw_bnk
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lst
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_bnk
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfia71.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lst)
destroy(this.dw_detail)
destroy(this.dw_bnk)
destroy(this.rr_1)
end on

event open;call super::open;dw_bnk.SetTransObject(Sqlca)
dw_bnk.Reset()
dw_bnk.InsertRow(0)

dw_detail.SetTransObject(Sqlca)
dw_detail.Reset()

dw_lst.SetTransObject(Sqlca)

Wf_Setting_Lst('%')

ib_any_typing = False



end event

type dw_insert from w_inherite`dw_insert within w_kfia71
boolean visible = false
integer x = 110
integer y = 2644
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia71
boolean visible = false
integer x = 4133
integer y = 2908
end type

type p_addrow from w_inherite`p_addrow within w_kfia71
boolean visible = false
integer x = 3959
integer y = 2908
end type

type p_search from w_inherite`p_search within w_kfia71
boolean visible = false
integer x = 3264
integer y = 2908
end type

type p_ins from w_inherite`p_ins within w_kfia71
boolean visible = false
integer x = 3785
integer y = 2908
end type

type p_exit from w_inherite`p_exit within w_kfia71
end type

type p_can from w_inherite`p_can within w_kfia71
end type

event p_can::clicked;call super::clicked;String sBnk

dw_bnk.AcceptText()
sBnk = dw_bnk.GetItemString(1,"bnk_cd")

Wf_Setting_Lst(sBnk)

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_kfia71
boolean visible = false
integer x = 3438
integer y = 2908
end type

type p_inq from w_inherite`p_inq within w_kfia71
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String sBnk

dw_bnk.AcceptText()
sBnk = dw_bnk.GetItemString(1,"bnk_cd")
IF IsNull(sBnk) or sBnk = '' THEN sBnk = '%'
		
Wf_Setting_Lst(sBnk)

end event

type p_del from w_inherite`p_del within w_kfia71
end type

event p_del::clicked;call super::clicked;
IF dw_detail.RowCount() <=0 THEN Return

IF dw_detail.AcceptText() = -1	THEN	RETURN

IF F_dbConFirm('삭제') = 2 THEN RETURN

dw_detail.SetRedraw(False)
dw_detail.DeleteRow(0)
IF dw_detail.Update() <> 1	 THEN
	ROLLBACK;
	f_messagechk(12,'')
	dw_detail.SetRedraw(True)
	Return
END IF
Commit;
ib_any_typing = True

Wf_Setting_Lst(dw_bnk.GetItemString(1,"bnk_cd"))
dw_detail.SetRedraw(True)




end event

type p_mod from w_inherite`p_mod within w_kfia71
end type

event p_mod::clicked;call super::clicked;Integer iSeqNo

IF dw_detail.RowCount() <=0 THEN Return
IF dw_detail.AcceptText() = -1 THEN Return
IF Wf_RequiredChk() = -1 THEN Return

IF dw_detail.GetItemNumber(dw_detail.Getrow(),"seq_no") = 0 OR IsNull(dw_detail.GetItemNumber(dw_detail.Getrow(),"seq_no")) THEN
	iSeqNo = Wf_No(dw_detail.GetItemString(dw_detail.Getrow(),"bnk_cd"))
	dw_detail.SetItem(dw_detail.Getrow(),"seq_no",iSeqNo)
ELSE
	iSeqNo = dw_detail.GetItemNumber(dw_detail.Getrow(),"seq_no")
END IF

IF F_DbConFirm('저장') = 2 THEN Return

IF dw_detail.Update() <> 1 THEN
	F_Messagechk(13,'')
	Rollback;
	Return
END IF
Commit;
Wf_Setting_Lst(dw_bnk.GetItemString(1,"bnk_cd"))

//ib_any_typing = False


end event

type cb_exit from w_inherite`cb_exit within w_kfia71
boolean visible = false
integer x = 3310
integer y = 2696
integer taborder = 80
end type

type cb_mod from w_inherite`cb_mod within w_kfia71
boolean visible = false
integer x = 2226
integer y = 2696
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;Integer iSeqNo

IF dw_detail.RowCount() <=0 THEN Return
IF dw_detail.AcceptText() = -1 THEN Return
IF Wf_RequiredChk() = -1 THEN Return

IF dw_detail.GetItemNumber(1,"seq_no") = 0 OR IsNull(dw_detail.GetItemNumber(1,"seq_no")) THEN
	iSeqNo = Wf_No(dw_detail.GetItemString(1,"bnk_cd"))
	dw_detail.SetItem(1,"seq_no",iSeqNo)
ELSE
	iSeqNo = dw_detail.GetItemNumber(1,"seq_no")
END IF

IF F_DbConFirm('저장') = 2 THEN Return

IF dw_detail.Update() <> 1 THEN
	F_Messagechk(13,'')
	Rollback;
	Return
END IF
Commit;
Wf_Setting_Lst(dw_bnk.GetItemString(1,"bnk_cd"))

ib_any_typing = True


end event

type cb_ins from w_inherite`cb_ins within w_kfia71
boolean visible = false
integer x = 2240
integer y = 2792
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfia71
boolean visible = false
integer x = 2587
integer y = 2696
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;
IF dw_detail.RowCount() <=0 THEN Return

IF dw_detail.AcceptText() = -1	THEN	RETURN

IF F_dbConFirm('삭제') = 2 THEN RETURN

dw_detail.SetRedraw(False)
dw_detail.DeleteRow(0)
IF dw_detail.Update() <> 1	 THEN
	ROLLBACK;
	f_messagechk(12,'')
	dw_detail.SetRedraw(True)
	Return
END IF
Commit;
ib_any_typing = True

Wf_Setting_Lst(dw_bnk.GetItemString(1,"bnk_cd"))
dw_detail.SetRedraw(True)




end event

type cb_inq from w_inherite`cb_inq within w_kfia71
boolean visible = false
integer x = 256
integer y = 2696
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String sBnk

dw_bnk.AcceptText()
sBnk = dw_bnk.GetItemString(1,"bnk_cd")
IF IsNull(sBnk) or sBnk = '' THEN sBnk = '%'
		
Wf_Setting_Lst(sBnk)

end event

type cb_print from w_inherite`cb_print within w_kfia71
boolean visible = false
integer x = 2610
integer y = 2796
end type

type st_1 from w_inherite`st_1 within w_kfia71
end type

type cb_can from w_inherite`cb_can within w_kfia71
boolean visible = false
integer x = 2949
integer y = 2696
end type

event cb_can::clicked;call super::clicked;String sBnk

dw_bnk.AcceptText()
sBnk = dw_bnk.GetItemString(1,"bnk_cd")

Wf_Setting_Lst(sBnk)
end event

type cb_search from w_inherite`cb_search within w_kfia71
boolean visible = false
integer x = 1733
integer y = 2792
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia71
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia71
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfia71
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia71
boolean visible = false
integer x = 215
integer y = 2644
integer width = 416
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia71
boolean visible = false
integer x = 2194
integer y = 2644
end type

type dw_lst from datawindow within w_kfia71
integer x = 288
integer y = 200
integer width = 2071
integer height = 2060
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kfia712"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF Row <=0 THEN Return

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(Row,True)

dw_detail.SetRedraw(False)	
dw_detail.Retrieve(dw_lst.GetItemString(Row,"bnk_cd"),dw_lst.GetItemNumber(Row,"seq_no"),F_Today())
dw_detail.SetRedraw(True)	

sModStatus = 'M'

end event

event rowfocuschanged;If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	
	dw_detail.SetRedraw(False)
   
	dw_detail.Retrieve(dw_lst.GetItemString(currentRow,"bnk_cd"),dw_lst.GetItemNumber(currentRow,"seq_no"),F_Today())
	dw_detail.SetRedraw(True)

   this.scrollTorow(currentrow)
	this.setFocus()
END IF

sModStatus = 'M'
end event

type dw_detail from u_key_enter within w_kfia71
event ue_key pbm_dwnkey
integer x = 2405
integer y = 180
integer width = 1870
integer height = 1872
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_kfia713"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event itemerror;Return 1
end event

event editchanged;ib_any_typing = True
end event

event itemchanged;String  sNull,sLoName,sLoNo,sLoMDate,sBaseDate,sDpNo,sDpName, ls_bnknm
Double  dLoAmt

SetNull(sNull)
IF this.GetColumnName() = "bnk_cd" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN 
		this.SetItem(this.GetRow(),"bnkname",sNull)
		Return
	END IF
	
	ls_bnknm = F_Get_Personlst('2',this.GetText(),'1')
	
	IF IsNull(ls_bnknm) THEN
//		F_MessageChk(20,'[금융기관]')
		this.SetItem(this.GetRow(),"bnk_cd",sNull)
		Return 
	Else
		this.SetItem(this.GetRow(),"bnkname",ls_bnknm)
	END IF
END IF

IF this.GetColumnName() = "gar_cd" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN 
		this.SetItem(this.GetRow(),"gar_cd_1",sNull)
		Return
	END IF
	
	ls_bnknm = F_Get_Personlst('2',this.GetText(),'1')
	
	IF IsNull(ls_bnknm) THEN
//		F_MessageChk(20,'[보증기관]')
		this.SetItem(this.GetRow(),"gar_cd",sNull)
		Return 
	Else
		this.SetItem(this.GetRow(),"gar_cd_1",ls_bnknm)
	END IF
END IF

IF this.GetColumnName() = "dam_kind" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN Return
	
//	IF this.GetText() = '3' THEN
//		F_MessageChk(16,'[보증종류=예적금]')
//		this.SetItem(this.GetRow(),"dam_kind",sNull)
//		Return 1
//	END IF
	IF IsNull(F_Get_Refferance('DB',this.GetText())) THEN
		F_MessageChk(20,'[보증종류]')
		this.SetItem(this.GetRow(),"dam_kind",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "dam_date" THEN
	IF Trim(this.GetText()) = "" OR IsNull(Trim(this.GetText())) THEN Return
	
	IF F_DateChk(this.GetText()) = -1 THEN
		F_MessageChk(21,'[담보설정일]')
		this.SetItem(this.GetRow(),"dam_date",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "dam_freedate" THEN
	IF Trim(this.GetText()) = "" OR IsNull(Trim(this.GetText())) THEN Return
	
	IF F_DateChk(this.GetText()) = -1 THEN
		F_MessageChk(21,'[담보해지일]')
		this.SetItem(this.GetRow(),"dam_freedate",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "lo_no" THEN
	sLoNo = this.GetText()
	IF sLoNo = "" OR IsNull(sLoNo) THEN 
		this.SetItem(this.GetRow(),"lo_name",sNull)
		this.SetItem(this.GetRow(),"lo_atdt",sNull)
		this.SetItem(this.GetRow(),"jan",0)
		Return
	END IF
	sBaseDate = f_Today()
	
	SELECT "KFM03OT0"."LO_NAME",            "KFM03OT0"."LO_ATDT",
			 FUN_CALC_CUSTJAN("KFM03OT0"."SAUPJ","KFM03OT0"."SAUPJ", :sBaseDate, "KFM03OT0"."ACC1_CD", "KFM03OT0"."ACC2_CD", "KFM03OT0"."LO_CD")
	   INTO :sLoName,   				         :sLoMDate,			:dLoAmt
	   FROM "KFM03OT0"  
   	WHERE "KFM03OT0"."LO_CD" = :sLoNo ;
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[차입금코드]')
		this.SetItem(this.GetRow(),"lo_name",sNull)
		this.SetItem(this.GetRow(),"lo_atdt",sNull)
		this.SetItem(this.GetRow(),"jan",0)
		Return 
	END IF
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"lo_name", sLoName)
		this.SetItem(this.GetRow(),"lo_atdt", sLoMDate)
		this.SetItem(this.GetRow(),"jan",     dLoAmt)
	End if
END IF

IF this.GetColumnName() = "ab_dpno" THEN
	sDpNo = this.GetText()
	IF sDpNo = "" OR IsNull(sDpNo) THEN 
		this.SetItem(this.GetRow(),"abdpname",sNull)
		Return
	END IF
	
	SELECT "KFM04OT0"."AB_NAME"	   INTO :sDpName
	   FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sDpNo AND "KFM04OT0"."AB_DAMBO" = 'Y';
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[예적금코드]')
		this.SetItem(this.GetRow(),"abdpname",sNull)
		this.SetItem(this.GetRow(),"ab_dpno",sNull)
		Return 
	else
		this.SetItem(this.GetRow(),"abdpname", sDpName)
	End if
END IF



end event

event ue_pressenter;
IF this.GetColumnName() <> "dam_cont" THEN
	Send(Handle(this),256,9,0)
	Return 1
end if
end event

event rbuttondown;this.accepttext()

IF this.GetColumnName() = "bnk_cd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = this.object.bnk_cd[1]
	
	OpenWithParm(W_Kfz04om0_Popup,'2')
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bnk_cd",  lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName() = "gar_cd" THEN
	SetNull(lstr_custom.code)	
	SetNull(lstr_custom.name)
	
	lstr_custom.code = this.object.gar_cd[1]
	
	OpenWithParm(W_Kfz04om0_Popup,'2')
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"gar_cd",  lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName() = "lo_no" THEN
	SetNull(Gs_code)	
	SetNull(Gs_codename)	
	
	gs_code = this.object.lo_no[1]
	
	Open(W_Kfm03ot0_Popup)
	IF Gs_code = "" OR IsNull(Gs_code) THEN Return
	
	this.SetItem(this.GetRow(),"lo_no",  Gs_code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName() = "ab_dpno" THEN
	SetNull(Gs_code)	
	SetNull(Gs_codename)	
	
	gs_code = this.object.ab_dpno[1]
	
	Open(W_Kfm04ot0_Popup)
	IF Gs_code = "" OR IsNull(Gs_code) THEN Return
	
	this.SetItem(this.GetRow(),"ab_dpno",  Gs_code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF
end event

type dw_bnk from u_key_enter within w_kfia71
event ue_key pbm_dwnkey
integer x = 274
integer y = 24
integer width = 1294
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfia711"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sNull,sBnkName

SetNull(sNull)
IF this.GetColumnName() = "bnk_cd" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN 
		this.SetItem(this.GetRow(),"bnkname",snull)
		Return
	END IF
	
	sBnkName = F_Get_Personlst('2',this.GetText(),'1')
	IF IsNull(sBnkName) THEN
//		F_MessageChk(20,'[금융기관]')
		this.SetItem(this.GetRow(),"bnk_cd",sNull)
		this.SetItem(this.GetRow(),"bnkname",snull)
		Return 
	ELSE
		this.SetItem(this.GetRow(),"bnkname",sBnkName)
		
		Wf_Setting_Lst(this.GetText())
	END IF
END IF
end event

event itemerror;Return 1
end event

event rbuttondown;this.accepttext()

IF this.GetColumnName() = "bnk_cd" THEN
	SetNull(lstr_custom.code)	
	SetNull(lstr_custom.name)
	
	lstr_custom.code = this.object.bnk_cd[this.getrow()]
	
	OpenWithParm(W_Kfz04om0_Popup,'2')
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bnk_cd",  lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type rr_1 from roundrectangle within w_kfia71
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 283
integer y = 196
integer width = 2112
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 46
end type

