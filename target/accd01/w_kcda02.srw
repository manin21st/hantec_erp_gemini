$PBExportHeader$w_kcda02.srw
$PBExportComments$거래처 등록
forward
global type w_kcda02 from w_inherite
end type
type cbx_1 from checkbox within w_kcda02
end type
type dw_1 from u_key_enter within w_kcda02
end type
type dw_list from u_d_popup_sort within w_kcda02
end type
type dw_gyul from u_key_enter within w_kcda02
end type
type dw_gubun from u_key_enter within w_kcda02
end type
end forward

global type w_kcda02 from w_inherite
string title = "거래처 등록"
cbx_1 cbx_1
dw_1 dw_1
dw_list dw_list
dw_gyul dw_gyul
dw_gubun dw_gubun
end type
global w_kcda02 w_kcda02

type variables
w_preview  iw_preview
end variables

forward prototypes
public function integer wf_delete_chk (string scust)
public subroutine wf_init ()
public function integer wf_maxcustcode ()
public function integer wf_requiredchk (integer ll_row)
public subroutine wf_find_row (string scvcod)
public subroutine wf_setting_retrievemode (string mode)
end prototypes

public function integer wf_delete_chk (string scust);Long icnt = 0

select count(*) into :icnt from vnddan where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[거래처별상품단가]')
	return -1
end if

select count(*) into :icnt from vndsisang where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[거래처별단가신청]')
	return -1
end if

select count(*) into :icnt from vnddc where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[거래처할인]')
	return -1
end if

select count(*) into :icnt from taxmisu where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[세금계산서미수]')
	return -1
end if

select count(*) into :icnt from danmst where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[단가마스타]')
	return -1
end if

select count(*) into :icnt from estima where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[견적관리_파일첨부]')
	return -1
end if

select count(*) into :icnt from pomast where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[발주서마스터]')
	return -1
end if

select count(*) into :icnt from sorder where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[수주]')
	return -1
end if

select count(*) into :icnt from exppih where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[수출PI Head]')
	return -1
end if

select count(*) into :icnt from imhist where cvcod = :scust;
if sqlca.sqlcode = 0 and icnt >= 1 then
	f_messagechk(20017,'[수입진행이력]')
	return -1
end if

return 1
end function

public subroutine wf_init ();String sNullValue

sModStatus ="I"
w_mdi_frame.sle_msg.text =""

dw_list.Retrieve(dw_gubun.GetItemString(1,"rfgub"))
dw_list.SelectRow(0,False)

SetNull(sNullValue)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"vndmst_cvgu", dw_gubun.GetItemString(1,"rfgub"))
dw_1.SetColumn("vndmst_cvcod")
dw_1.SetFocus()
dw_1.SetRedraw(True)

dw_gyul.SetRedraw(False)
dw_gyul.Reset()
dw_gyul.InsertRow(0)
dw_gyul.SetRedraw(True)

end subroutine

public function integer wf_maxcustcode ();
String 	sGubunCode, sFetched_Id = '', sext_code
real	rMaxCode

dw_gubun.AcceptText()
sGubunCode = dw_gubun.GetItemString(1, "rfgub")

IF sGubunCode = '1' OR sGubunCode = '2' THEN
	SELECT Max("VNDMST"."CVCOD") INTO :sFetched_Id FROM "VNDMST" WHERE "VNDMST"."CVGU" = :sGubunCode AND SUBSTR("VNDMST"."CVCOD", 1, 1)  = :sGubunCode ;
	IF IsNull(sFetched_Id) or  sFetched_id = ''   THEN
		sFetched_Id = sGubunCode + "00000"
	ELSE
		DO 
			SELECT "VNDMST"."CVCOD" INTO :sext_code FROM "VNDMST" WHERE "VNDMST"."CVCOD" = :sFetched_Id;
			IF SQLCA.SQLCODE = 0 THEN
				sFetched_Id = String(real(sFetched_id) + 1)
			END IF
		LOOP UNTIL SQLCA.SQLCODE = 100
	END IF
		rMaxCode = real(sFetched_id) 
	IF rMaxCode >= 1  then
		dw_1.SetItem(1, "vndmst_cvcod" , string(rMaxCode) )
	ELSE
		MessageBox("거래처코드 확인", "거래처코드를 채번할 수 없습니다.")
		dw_1.SetFocus()
		RETURN -1
	END IF
ELSEIF sGubunCode = '9' THEN
	SELECT Max("VNDMST"."CVCOD") INTO :sFetched_Id FROM "VNDMST" WHERE "VNDMST"."CVGU" = :sGubunCode AND SUBSTR("VNDMST"."CVCOD", 1, 1)  = :sGubunCode AND "VNDMST"."CVCOD" <> '999999';
	IF IsNull(sFetched_Id) or  sFetched_id = ''   THEN
		sFetched_Id = sGubunCode + "00000"
	ELSE
		DO 
			SELECT "VNDMST"."CVCOD" INTO :sext_code FROM "VNDMST" WHERE "VNDMST"."CVCOD" = :sFetched_Id;
			IF SQLCA.SQLCODE = 0 THEN
				sFetched_Id = String(real(sFetched_id) + 1)
			END IF
		LOOP UNTIL SQLCA.SQLCODE = 100
	END IF
	rMaxCode = real(sFetched_id) 
	IF rMaxCode >= 1 AND len(string(rmaxcode)) = 6 AND string(rmaxcode) <> '999999' THEN
		dw_1.SetItem(1, "vndmst_cvcod" , string(rMaxCode) )
	ELSE
		MessageBox("거래처코드 확인", "거래처코드를 채번할 수 없습니다.")
		dw_1.SetFocus()
		RETURN -1
	END IF
END IF
RETURN	1
end function

public function integer wf_requiredchk (integer ll_row);String sAutoFlag,sCvcod

sAutoFlag = dw_1.GetItemString(ll_row,"autoflag")
sCvcod    = dw_1.GetItemString(ll_row,"vndmst_cvcod")

IF sAutoFlag = 'N' and (sCvcod = "" OR IsNull(sCvcod)) THEN
	F_MessageChk(1,'[거래처코드]')
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	Return -1
END IF
IF dw_1.GetItemString(ll_row,"vndmst_cvgu") = "" OR IsNull(dw_1.GetItemString(ll_row,"vndmst_cvgu")) THEN
	F_MessageChk(1,'[거래처구분]')
	dw_1.SetColumn("vndmst_cvgu")
	dw_1.SetFocus()
	Return -1
END IF

IF dw_1.GetItemString(ll_row,"vndmst_cvnas") = "" OR IsNull(dw_1.GetItemString(ll_row,"vndmst_cvnas")) THEN
	F_MessageChk(1,'[거래처명]')
	dw_1.SetColumn("vndmst_cvnas")
	dw_1.SetFocus()
	Return -1
END IF

String ls_saleyn , ls_gumaeyn , ls_oyjuyn , ls_yongyn
String ls_sale_dept , ls_gu_dept

ls_saleyn  = Trim(dw_1.Object.saleyn[1])
ls_gumaeyn = Trim(dw_1.Object.gumaeyn[1])
ls_oyjuyn  = Trim(dw_1.Object.oyjuyn[1])
ls_yongyn  = Trim(dw_1.Object.yongyn[1])

If ls_saleyn = 'N' And ls_gumaeyn = 'N' And  ls_oyjuyn = 'N' And ls_yongyn = 'N'Then
	F_MessageChk(1,'[거래처유형]')
	dw_1.SetColumn("yongyn")
	dw_1.SetFocus()
	Return -1
End If

Return 1
end function

public subroutine wf_find_row (string scvcod);Integer iRow

iRow = dw_list.GetSelectedRow(0)
if iRow > 0 then Return

dw_list.SetRedraw(False)
dw_list.Retrieve(dw_gubun.GetItemString(1,"rfgub"))
dw_list.SetRedraw(True)

iRow = dw_list.Find("cvcod = '"+sCvcod + "'",1,dw_list.RowCount())
if iRow > 0 then
	dw_list.ScrollToRow(iRow)
	dw_list.SelectRow(iRow,True)
end if

end subroutine

public subroutine wf_setting_retrievemode (string mode);
dw_1.SetRedraw(False)
IF mode ="M" THEN //수정
	dw_1.SetTabOrder("vndmst_cvcod",0)
	dw_1.Modify("autoflag.visible = 0")
	dw_1.SetColumn("vndmst_cvgu")
ELSEIF mode ="I" THEN //입력
	dw_1.SetTabOrder("vndmst_cvcod",10)
	if dw_1.GetItemString(1,"vndmst_cvgu") = '3' then
		dw_1.SetItem(1,"autoflag",'N')
		dw_1.Modify("autoflag.visible = 0")
	else
		dw_1.SetItem(1,"autoflag",'Y')
		dw_1.Modify("autoflag.visible = 1")
	end if
	dw_1.SetColumn("vndmst_cvcod")
END IF
dw_1.SetFocus()
dw_1.SetRedraw(True)
end subroutine

on w_kcda02.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.dw_list=create dw_list
this.dw_gyul=create dw_gyul
this.dw_gubun=create dw_gubun
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.dw_gyul
this.Control[iCurrent+5]=this.dw_gubun
end on

on w_kcda02.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.dw_gyul)
destroy(this.dw_gubun)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_gyul.SetTransObject(Sqlca)
dw_gubun.SetTransObject(Sqlca)

dw_gubun.Reset()
dw_gubun.InsertRow(0)
dw_gubun.SetItem(1,"rfgub",'1')

ib_any_typing=False
Wf_Init()
sModStatus ="I"
WF_SETTING_RETRIEVEMODE(sModStatus)
dw_1.SetColumn("vndmst_cvcod")
dw_1.SetFocus()

open( iw_preview, this)
end event

event resize;call super::resize;
dw_list.height = this.height - dw_list.y - 150
dw_1.x = dw_list.x + dw_list.width + 10
dw_1.width = this.width - dw_1.x - 40
dw_gyul.x = dw_1.x
dw_gyul.width = dw_1.width
dw_gyul.y = this.height - dw_gyul.height - 150
dw_1.height = this.height - dw_1.y - dw_gyul.height - 160
end event

event activate;call super::activate;
gw_window = this
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", true)
end event

event ue_inq;
String sCvcod
long   ll_row,iCount

w_mdi_frame.sle_msg.text =""
dw_1.AcceptText()
sCvcod =dw_1.GetItemString(dw_1.GetRow(),"vndmst_cvcod")

IF sCvcod = "" OR IsNull(sCvcod) THEN
	f_messagechk(1,'[코드]')
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	Return
END IF

IF dw_1.Retrieve(sCvcod) <= 0 THEN
	dw_1.Reset()
	dw_1.InsertRow(0)
	f_messagechk(14,"")
   dw_1.SetFocus()
	Return
END IF
ib_any_typing=False

dw_gyul.SetRedraw(False)
if dw_gyul.Retrieve(sCvcod) <=0 then
	dw_gyul.InsertRow(0)
	dw_gyul.SetItem(1,"person_cd", sCvcod)
end if
dw_gyul.SetRedraw(True)

sModStatus="M"
WF_SETTING_RETRIEVEMODE(sModStatus)

dw_list.SelectRow(0,False)
dw_list.SelectRow(dw_list.Find("cvcod = '"+sCvcod + "'",1,dw_list.RowCount()),True)
dw_list.ScrollToRow(dw_list.Find("cvcod = '"+sCvcod + "'",1,dw_list.RowCount()))
end event

event ue_append;
w_mdi_frame.sle_msg.text =""
WF_INIT()
sModStatus ="I"
ib_any_typing=False
WF_SETTING_RETRIEVEMODE(sModStatus)
end event

event ue_delete;
string  sCvcod
dw_1.AcceptText()
sCvcod = dw_1.GetItemString(dw_1.GetRow(),"vndmst_cvcod")

if Wf_Delete_Chk(sCvcod) = -1 then
	wf_setting_retrievemode("M")
	dw_1.SetFocus()
	Return
end if

IF f_dbconfirm("삭제") = 2 THEN Return

dw_1.SetRedraw(False)
dw_1.deleterow(0)
IF dw_1.Update() = 1 THEN	
	dw_gyul.SetRedraw(False)
	dw_gyul.DeleteRow(0)
	dw_gyul.Update()
	dw_gyul.SetRedraw(True)
	COMMIT;
	WF_INIT()
	w_mdi_frame.sle_msg.text =" 자료가 삭제되었습니다.!!!"
	ib_any_typing=False
ELSE
	F_MESSAGECHK(12,"")
	dw_1.SetRedraw(True)
	dw_1.SetFocus()
	ROLLBACK;	
END IF	
sModStatus ="I"
WF_SETTING_RETRIEVEMODE(sModStatus)
end event

event ue_update;
String sAutoFlag
IF dw_1.AcceptText() = -1 THEN RETURN
IF Wf_RequiredChk(1) = -1 THEN RETURN
sAutoFlag = dw_1.GetItemString(dw_1.GetRow(),"autoflag")
IF f_dbconfirm("저장") = 2 THEN RETURN

IF sModStatus = 'I' THEN
   If sAutoFlag = 'Y' THEN
   	IF wf_MaxCustCode() = -1	THEN	
			RETURN
		END IF
	END IF
END IF

IF	dw_1.Update() = 1 THEN
	dw_gyul.SetItem(1,"person_cd", dw_1.GetItemString(1,"vndmst_cvcod"))
	if dw_gyul.Update() <> 1 then
		F_MessageChk(13,'')
		Rollback;
		Return
	end if
	COMMIT;
	Wf_Find_Row(dw_1.GetItemString(1,"vndmst_cvcod"))
	w_mdi_frame.sle_msg.text =" 자료가 저장되었습니다.!!!"
	ib_any_typing=False
ELSE
	f_messagechk(13,"")
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	ROLLBACK;	
END IF
sModStatus ="M"
WF_SETTING_RETRIEVEMODE(sModStatus)
end event

event ue_print;
cbx_1.TriggerEvent(Clicked!)
end event

type cbx_1 from checkbox within w_kcda02
integer x = 3081
integer y = 64
integer width = 567
integer height = 64
boolean visible = false
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "거래처 일괄인쇄"
end type

event clicked;cbx_1.Checked = False

iw_preview.title = '거래처 일괄인쇄'
iw_preview.dw_preview.dataobject = 'dw_kcda02_p'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes datawindow.print.preview.zoom=100 datawindow.print.orientation=1 datawindow.print.margin.left=280 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve() <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True
end event

type dw_1 from u_key_enter within w_kcda02
integer x = 1385
integer y = 156
integer width = 3214
integer height = 1580
integer taborder = 30
string dataobject = "dw_kcda02_detail"
end type

event itemchanged;int    iExPrice
Double dNull
string sNull,sres_no,sCustCode,ls_cvcod

w_mdi_frame.sle_msg.text = ''
SetNull(dNull)
SetNull(sNull)

IF this.GetColumnName() = 'vndmst_cvcod' THEN
	sCustCode = this.GetText()
	IF sCustCode = "" OR IsNull(sCustcode) THEN RETURN
	select cvcod into :ls_cvcod from vndmst where cvcod = :sCustCode ;
   if sqlca.sqlcode = 0 then
	   EVENT ue_inq()
   end if
END IF

IF this.GetColumnName() = "vndmst_cvnas" THEN
	IF this.GetText() = "" OR IsNull(this.GetText()) THEN
		this.SetItem(this.GetRow(),"cvnas2",sNull)
	END IF
END IF

IF	this.getcolumnname() = "vndmst_sano"	THEN
	string	SaupNo, DupCheck, DupName
	SaupNo = this.GETTEXT()
	IF IsNull(saupno) OR saupno ="" THEN RETURN
	select cvcod, cvnas into :DupCheck, :DupName from vndmst where sano = :SaupNo and rownum = 1;
	IF sqlca.sqlcode = 0 THEN
		messagebox("사업자등록번호 확인", "등록된 사업자등록번호입니다.~n~r" + "거래처번호 : " + DupCheck + "~n~r거래처   명 : " + DupName )
		this.setitem(1, "vndmst_sano", sNull)
		return 1
	END IF
	IF f_vendcode_check(saupno) = False THEN
		F_MessageChk(20,'[사업자등록번호]')
	END IF
END IF

IF this.GetColumnName() = "resident" THEN
	sres_no = this.GetText()
	IF sres_no = "" OR IsNull(sres_no) THEN RETURN
	IF f_vendcode_check(sres_no) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 저장하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"resident",sNull)
			Return 1
		END IF
	END IF
END IF

String sdptno ,sget_name , ls_cod

IF this.GetColumnName() ="sale_emp" THEN
	sdptno = this.GetText()
	IF sdptno ="" OR IsNull(sdptno) THEN
		this.SetItem(1,"sale_name",sNull)
		RETURN
	END IF
	SELECT "VNDMST"."CVNAS2"  INTO :sget_name FROM "VNDMST" WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"sale_name",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(1,"sale_emp",sNull)
			this.SetItem(1,"sale_name",sNull)
		END IF
		Return 1	
	END IF
ELSEIF this.GetColumnName() ="deptcode" THEN
	sdptno = this.GetText()
	IF sdptno ="" OR IsNull(sdptno) THEN
		this.SetItem(1,"p0_dept_deptname2",sNull)
		RETURN
	END IF
	SELECT "VNDMST"."CVNAS2"  INTO :sget_name FROM "VNDMST" WHERE "VNDMST"."CVCOD" = :sdptno  AND "VNDMST"."CVGU" = '4' ;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"deptname",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(1,"deptcode",sNull)
			this.SetItem(1,"deptname",sNull)
		END IF
		Return 1	
	END IF
ElseIf this.GetColumnName() ="valid_yn" THEN
	ls_cod = Trim(GetText())
	If ls_cod = 'Y' Then
		This.Object.sdate[1] = is_today
		This.Object.edate[1] = f_afterday(is_today , 730 )
	Else
		This.Object.sdate[1] = is_today
		This.Object.edate[1] = '99999999'
	End If
ElseIf this.GetColumnName() ="exprice" THEN
	iExPrice = Integer(this.GetText())
	IF iExPrice = 0 OR IsNull(iExPrice) THEN RETURN
	IF iExPrice <> 1 And iExPrice <> 2 And iExPrice <> 3 And iExPrice <> 4 THEN
		MessageBox("확 인","코드를 확인하십시오.")
		this.SetItem(1,"exprice",dNull)
		Return 1
	END IF
End If
end event

type dw_list from u_d_popup_sort within w_kcda02
integer x = 119
integer y = 276
integer width = 1221
integer height = 1888
integer taborder = 10
string dataobject = "dw_kcda02_list"
end type

event clicked;
if row <=0 then Return

this.SelectRow(0,False)
this.SelectRow(Row,True)

dw_1.SetItem(1,"vndmst_cvcod", this.GetItemString(row,"cvcod"))

EVENT ue_inq()

this.SetFocus()
end event

type dw_gyul from u_key_enter within w_kcda02
integer x = 1390
integer y = 1744
integer width = 3209
integer height = 416
integer taborder = 40
string dataobject = "dw_kcda02_gyul"
end type

event itemfocuschanged;Long wnd
wnd =Handle(this)
IF dwo.name ="autobank" OR dwo.name ="dpname" OR dwo.name ="cvtype" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type dw_gubun from u_key_enter within w_kcda02
integer x = 114
integer y = 116
integer width = 1216
integer height = 144
integer taborder = 11
string dataobject = "dw_kcda02_gubun"
end type

event itemchanged;call super::itemchanged;
if this.GetColumnName() = "rfgub" then
	w_mdi_frame.sle_msg.text =""
	dw_list.Retrieve(this.GetText())
	dw_list.SelectRow(0,False)
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetItem(dw_1.GetRow(),"vndmst_cvgu", this.GetText())
	if this.GetText() = '3' then
		dw_1.SetItem(1,"autoflag",'N')
		dw_1.Modify("autoflag.visible = 0")
	else
		dw_1.SetItem(1,"autoflag",'Y')
		dw_1.Modify("autoflag.visible = 1")
	end if
	dw_1.SetColumn("vndmst_cvcod")
	dw_1.SetFocus()
	dw_1.SetRedraw(True)
	dw_gyul.SetRedraw(False)
	dw_gyul.Reset()
	dw_gyul.InsertRow(0)
	dw_gyul.SetRedraw(True)	
end if
end event