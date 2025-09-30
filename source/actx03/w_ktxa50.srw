$PBExportHeader$w_ktxa50.srw
$PBExportComments$부동산 코드 등록
forward
global type w_ktxa50 from w_inherite
end type
type cb_append from commandbutton within w_ktxa50
end type
type dw_print from datawindow within w_ktxa50
end type
type dw_ip from datawindow within w_ktxa50
end type
type rr_1 from roundrectangle within w_ktxa50
end type
type dw_1 from datawindow within w_ktxa50
end type
end forward

global type w_ktxa50 from w_inherite
integer width = 6016
integer height = 4052
string title = "부동산 코드 등록"
cb_append cb_append
dw_print dw_print
dw_ip dw_ip
rr_1 rr_1
dw_1 dw_1
end type
global w_ktxa50 w_ktxa50

type variables
Boolean itemerr =False

w_preview  iw_preview
end variables

forward prototypes
public function integer wf_requiredchk ()
end prototypes

public function integer wf_requiredchk ();Int    i,j
String sCode,sCode1

FOR i = 1 TO dw_1.RowCount()
	
	sCode = dw_1.GetItemString(i,"code")
	
	IF IsNull(sCode) OR sCode = "" THEN
		MessageBox("확인","부동산번호를 입력하십시오! ["+String(i)+"행]")
		dw_1.SetRow(i)
		dw_1.SetColumn("code")
		dw_1.SetFocus()
		Return -1
	END IF
NEXT

Return 1
end function

on w_ktxa50.create
int iCurrent
call super::create
this.cb_append=create cb_append
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_append
this.Control[iCurrent+2]=this.dw_print
this.Control[iCurrent+3]=this.dw_ip
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.dw_1
end on

on w_ktxa50.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_append)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.dw_1)
end on

event open;dw_ip.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetItem(1,"saupj",  '99')
dw_ip.SetItem(1,"k_symd", Left(f_today(),4)+'0101')

IF dw_1.Retrieve('%',Left(f_today(),4)+'0101') > 0 THEN
	dw_1.SetColumn("code")
	dw_1.SetFocus()
END IF

dw_print.object.datawindow.print.preview = "yes"
end event

type dw_insert from w_inherite`dw_insert within w_ktxa50
integer x = 1115
integer y = 2632
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_ktxa50
boolean visible = false
integer x = 3886
integer y = 2816
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_ktxa50
boolean visible = false
integer x = 3680
integer y = 2832
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_ktxa50
boolean visible = false
integer x = 1943
integer y = 2660
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_ktxa50
integer x = 3557
end type

event p_ins::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_1.InsertRow(0)

dw_1.ScrollToRow(dw_1.rowcount())

dw_1.SetColumn("code")
dw_1.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_ktxa50
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_ktxa50
integer taborder = 50
end type

event p_can::clicked;call super::clicked;String sSaupj, sDate
w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

sSaupj = dw_ip.GetItemString(1,"saupj")
sDate  = Trim(dw_ip.GetItemString(1,"k_symd"))

if sSaupj = '99' then sSaupj = '%'
if sDate = '' or IsNull(sDate) then sDate = '00000000'

dw_1.SetRedraw(False)
IF dw_1.Retrieve(sSaupj,sDate) > 0 THEN
	dw_1.SetColumn("code")
	dw_1.SetFocus()
END IF

dw_1.SetRedraw(True)
end event

type p_print from w_inherite`p_print within w_ktxa50
integer x = 4078
integer taborder = 0
end type

event p_print::clicked;call super::clicked;IF dw_print.retrieve() <= 0 THEN
	MessageBox("확인","인쇄할 자료가 없습니다.")
	Return -1
END IF

IF dw_print.rowcount() > 0 then 
	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_ktxa50
integer x = 3383
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String sSaupj, sDate

dw_ip.AcceptText()
sSaupj = dw_ip.GetItemString(1,"saupj")
sDate  = Trim(dw_ip.GetItemString(1,"k_symd"))

if sSaupj = '99' then sSaupj = '%'
if sDate = '' or IsNull(sDate) then sDate = '00000000'

IF dw_1.Retrieve(sSaupj, sDate) = 0 THEN
	F_MessageChk(14, "")
	Return
END IF

dw_1.SetColumn("code")
dw_1.SetFocus()

w_mdi_frame.sle_msg.text ="조회되었습니다!"

end event

type p_del from w_inherite`p_del within w_ktxa50
integer x = 3904
integer taborder = 40
end type

event p_del::clicked;call super::clicked;
IF dw_1.GetRow() <= 0 THEN Return

IF F_DbConFirm('삭제') = 2 THEN Return

dw_1.DeleteRow(dw_1.GetRow())

IF dw_1.Update() <> 1 THEN
	Rollback;
	F_MessageChk(12,'')
	Return
END IF

Commit;

w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!"

end event

type p_mod from w_inherite`p_mod within w_ktxa50
integer x = 3730
integer taborder = 30
end type

event p_mod::clicked;String sChk,sGbn,sDate

IF Wf_RequiredChk() = -1 THEN Return

IF dw_1.RowCount() <=0 THEN Return
	
IF dw_1.Update() <> 1 THEN
	F_MessageChk(12,'')
	Rollback;
	Return
END IF

Commit;

w_mdi_frame.sle_msg.text = '저장하였습니다!'
end event

type cb_exit from w_inherite`cb_exit within w_ktxa50
integer x = 3360
integer y = 2668
end type

type cb_mod from w_inherite`cb_mod within w_ktxa50
integer x = 2290
integer y = 2668
end type

type cb_ins from w_inherite`cb_ins within w_ktxa50
integer x = 608
integer y = 2668
string text = "삽입(&I)"
end type

type cb_del from w_inherite`cb_del within w_ktxa50
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

type cb_inq from w_inherite`cb_inq within w_ktxa50
integer x = 1038
integer y = 2416
end type

type cb_print from w_inherite`cb_print within w_ktxa50
integer x = 1641
integer y = 2420
end type

type st_1 from w_inherite`st_1 within w_ktxa50
integer x = 41
integer y = 2968
integer width = 361
end type

type cb_can from w_inherite`cb_can within w_ktxa50
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

type cb_search from w_inherite`cb_search within w_ktxa50
integer x = 2107
integer y = 2416
end type

type dw_datetime from w_inherite`dw_datetime within w_ktxa50
integer x = 2848
integer y = 2968
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_ktxa50
integer x = 416
integer y = 2968
integer width = 2437
end type

type gb_10 from w_inherite`gb_10 within w_ktxa50
integer x = 23
integer y = 2916
integer width = 3575
end type

type gb_button1 from w_inherite`gb_button1 within w_ktxa50
integer x = 229
integer y = 2616
integer width = 750
end type

type gb_button2 from w_inherite`gb_button2 within w_ktxa50
integer x = 2249
integer y = 2616
end type

type cb_append from commandbutton within w_ktxa50
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

type dw_print from datawindow within w_ktxa50
boolean visible = false
integer x = 2889
integer y = 44
integer width = 133
integer height = 104
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dw_ktxa502p"
boolean livescroll = true
end type

type dw_ip from datawindow within w_ktxa50
integer x = 64
integer y = 24
integer width = 1943
integer height = 152
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dw_ktxa501"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_ktxa50
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 180
integer width = 4530
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from datawindow within w_ktxa50
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 73
integer y = 188
integer width = 4494
integer height = 2040
integer taborder = 10
string title = "부동산 코드 등록"
string dataobject = "dw_ktxa502"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;Int    i, iFindRow,iCurRow
String sNull,sCode,sDate,sCvName,sSano,sSaupNo,sSaupj,sResi,sFromDate

SetNull(sNull)

w_mdi_frame.sle_msg.text =""

iCurRow = this.GetRow()
IF this.GetColumnName() = "code" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	sFromDate = Trim(this.GetItemString(this.GetRow(),"rent_sdate"))	
	iFindRow = this.find("code ='" + data + "' and rent_sdate = '" + sFromDate + "'", 1, this.RowCount())
	IF (iCurRow <> iFindRow) and (iFindRow <> 0) THEN
		MessageBox('확인','이미 등록된 자료입니다. 확인하십시요!')
		this.SetItem(iCurRow,"code",sNull)
		this.SetItem(iCurRow,"chung",sNull)
		this.SetItem(iCurRow,"hosu",sNull)
		this.SetItem(iCurRow,"dong_nm",sNull)
		this.SetItem(iCurRow,"updowngbn",'N')
		this.SetItem(iCurRow,"area",0)
		RETURN  1
	END IF
	
	iFindRow = this.find("code ='" + data + "'", 1, this.RowCount())
	IF (iCurRow <> iFindRow) and (iFindRow <> 0) THEN
		this.SetItem(iCurRow,"chung",    this.GetItemString(iFindRow,"chung"))
		this.SetItem(iCurRow,"hosu",     this.GetItemString(iFindRow,"hosu"))
		this.SetItem(iCurRow,"dong_nm",  this.GetItemString(iFindRow,"dong_nm"))
		this.SetItem(iCurRow,"updowngbn",this.GetItemString(iFindRow,"updowngbn"))
		this.SetItem(iCurRow,"area",     this.GetItemNumber(iFindRow,"area"))
		RETURN  
	END IF
END IF

IF this.GetColumnName() = "rent_sdate" THEN
	sFromDate = Trim(data)
	IF sFromDate = "" OR IsNull(sFromDate) THEN Return
	
	sCode = Trim(this.GetItemString(this.GetRow(),"code"))
	
	iFindRow = this.find("code ='" + sCode + "' and rent_sdate = '" + sFromDate + "'", 1, this.RowCount())

	IF (iCurRow <> iFindRow) and (iFindRow <> 0) THEN
		MessageBox('확인','이미 등록된 자료입니다. 확인하십시요!')
		this.SetItem(iCurRow,"rent_sdate",sNull)
		RETURN  1
	END IF
END IF

IF this.GetColumnName() = "updatedate" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN 
	ELSE
		this.SetItem(iCurRow,"rent_sdate",Trim(data))
	END IF
	
END IF

IF this.GetColumnName() = "saup_no" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		this.SetItem(row,"rent_nm",  sNull)
		this.SetItem(row,"rent_sano",sNull)
		Return
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "VNDMST"."CVNAS",	"VNDMST"."SANO",	"VNDMST"."RESIDENT"
	   INTO :sCvName,   			:sSano,				:sResi
	   FROM "VNDMST"  
   	WHERE ( "VNDMST"."CVCOD" = :sSaupNo );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[거래처]')
		this.SetItem(row,"saup_no",sNull)
		this.SetItem(row,"rent_nm",  sNull)
		this.SetItem(row,"rent_sano",sNull)
		Return 1
	END IF
	
	this.SetItem(row,"rent_nm",  sCvName)
	IF IsNull(sSano) OR sSano = "" THEN
		this.SetItem(row,"rent_sano",sResi)
	ELSE
		this.SetItem(row,"rent_sano",sSano)
	END IF
	
END IF

IF this.GetColumnName() = "rent_sdate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,"[입주일]")
		this.SetItem(row,"rent_sdate",sNull)
		Return 1
	ELSE
		this.SetItem(row,"rent_sdate", sDate)
	END IF
END IF

IF this.GetColumnName() = "rent_edate" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,"[퇴거일]")
		this.SetItem(row,"rent_edate",sNull)
		Return 1
	ELSE
		this.SetItem(row,"rent_edate", sDate)
	END IF
END IF

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(row,"saupj",sNull)
		Return 1
	END IF
END IF
end event

event itemerror;Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="rent_nm" THEN
	F_Toggle_Kor(wnd)
ELSE
	F_Toggle_Eng(wnd)
END IF
end event

event getfocus;this.Accepttext()
end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="saup_no" THEN
	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"saup_no"))
	
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""

	OpenWithParm(W_KFZ04OM0_POPUP,'1')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

