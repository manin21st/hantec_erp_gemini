$PBExportHeader$w_ssal_02050.srw
$PBExportComments$유상사급반품 등록
forward
global type w_ssal_02050 from w_inherite
end type
type rr_2 from roundrectangle within w_ssal_02050
end type
type rb_insert from radiobutton within w_ssal_02050
end type
type rb_modify from radiobutton within w_ssal_02050
end type
type dw_print from datawindow within w_ssal_02050
end type
type p_preview from picture within w_ssal_02050
end type
type st_2 from statictext within w_ssal_02050
end type
type rr_3 from roundrectangle within w_ssal_02050
end type
end forward

global type w_ssal_02050 from w_inherite
integer width = 4695
integer height = 2544
string title = "유상사급 판매반품"
rr_2 rr_2
rb_insert rb_insert
rb_modify rb_modify
dw_print dw_print
p_preview p_preview
st_2 st_2
rr_3 rr_3
end type
global w_ssal_02050 w_ssal_02050

type variables

String is_insemp        // 검사담당자
String is_iojpnoOK     //출고송장번호 필수여부
String isCursor 

end variables

forward prototypes
public function integer wf_requiredchk (string sdwobject, integer icurrow)
public function integer wf_catch_special_danga (integer nrow, ref double ioprc, ref double dcrate, string gbn)
public function integer wf_set_qc (integer nrow, string sitnbr)
public function integer wf_chk (integer nrow)
public subroutine wf_clear_item (integer icurrow)
public function integer wf_set_ip_jpno (integer nrow, string siojpno, string scvcodb, string saupj)
public function string wf_calculation_orderno (string sorderdate)
public subroutine wf_init ()
end prototypes

public function integer wf_requiredchk (string sdwobject, integer icurrow);String  sIoDate,sIoCust,sIoReDept,sIoReEmpNo,sIoDepotNo,sItem,sSpec,sBigo
String  sIojpNo, sIogbn, sQcGub, sInsEmp, sNull, sSaleGu

Double  dQty,dPrc

SetNull(sNull)

/* 반품구분 */
sIoGbn     = Trim(dw_input.GetItemString(1,"iogbn"))
IF sIoGbn = "" OR IsNull(sIoGbn) THEN
	f_message_chk(30,'[반품구분]')
	dw_input.SetColumn("iogbn")
	dw_input.SetFocus()
	Return -1
END IF

/* 판매구분 */
SELECT SALEGU INTO :sSaleGu
  FROM IOMATRIX
 WHERE SABU = :gs_sabu AND
 		 IOGBN = :sIogbn;

If IsNull(sSaleGu) Then sSaleGu = 'N'
	
/* key check */
IF sDwObject = 'd_sal_020501' THEN
	sIoDate    = Trim(dw_input.GetItemString(1,"sudat"))
	sIoReDept  = Trim(dw_input.GetItemString(1,"ioredept") )
	sIoReEmpNo = Trim(dw_input.GetItemString(1,"ioreemp")) 
	sIoCust    = Trim(dw_input.GetItemString(1,"cvcod"))
	sIoDepotNo = Trim(dw_input.GetItemString(1,"depot_no"))

	IF sIoDate = "" OR IsNull(sIoDate) THEN
		f_message_chk(30,'[반품의뢰일자]')
		dw_input.SetColumn("sudat")
		dw_input.SetFocus()
		Return -1
	END IF
	
	IF sIoReDept = "" OR IsNull(sIoReDept) THEN
		f_message_chk(30,'[반품담당부서]')
		dw_input.SetColumn("ioredept")
		dw_input.SetFocus()
		Return -1
	END IF
	IF sIoReEmpNo = "" OR IsNull(sIoReEmpNo) THEN
		f_message_chk(30,'[반품의뢰자]')
		dw_input.SetColumn("ioreemp")
		dw_input.SetFocus()
		Return -1
	END IF
	
	/* 부서출고반품일 경우 반품처 무입력 */
	If sIoGbn <> 'O44' Then
	  IF sIoCust = "" OR IsNull(sIoCust) THEN
		 f_message_chk(30,'[반품처]')
		 dw_input.SetColumn("cvcod")
		 dw_input.SetFocus()
		 Return -1
	  END IF
   End If
	
	IF sIoDepotNo = "" OR IsNull(sIoDepotNo) THEN
		f_message_chk(30,'[반품창고]')
		dw_input.SetColumn("depot_no")
		dw_input.SetFocus()
		Return -1
	END IF
ELSEIF sDwObject = 'd_sal_020502' THEN
	sItem    = Trim(dw_insert.GetItemString(iCurRow,"itnbr"))
	dQty     = dw_insert.GetItemNumber(iCurRow,"ioreqty")
	dPrc     = dw_insert.GetItemNumber(iCurRow,"ioprc")
	sSpec    = dw_insert.GetItemString(iCurRow,"pspec")
	sBigo    = dw_insert.GetItemString(iCurRow,"bigo")
	sInsEmp  = dw_insert.GetItemString(iCurRow,"insemp")
	sQcGub   = dw_insert.GetItemString(iCurRow,"qcgub")

	dw_insert.SetFocus()

	IF sItem = "" OR IsNull(sItem) THEN
		f_message_chk(30,'[품번]')
		dw_insert.SetColumn("itnbr")
		Return -1
	END IF
	
	IF dQty = 0 OR IsNull(dQty) THEN
		f_message_chk(30,'[수량]')
		dw_insert.SetColumn("ioreqty")
		Return -1
	END IF

	/* 판매반품일 경우만 단가 확인 */
	If sSaleGu = 'Y' Then
		IF dPrc = 0 OR IsNull(dPrc) THEN
			f_message_chk(30,'[단가]')
			dw_insert.SetColumn("ioprc")
			Return -1
		END IF
	End If

  /* 사양 미입력시 */
	IF sSpec = "" OR IsNull(sSpec) THEN
		dw_insert.SetItem(iCurRow,'pspec','.')
	END IF

  /* 검사구분, 검사담당자 */
	IF sQcGub  = "" OR IsNull(sQcGub) THEN
		f_message_chk(30,'[검사구분]')
		dw_insert.SetColumn("qcgub")
		Return -1
	END IF

  /* 무검사가 아닐경우 검사담당자 필수 입력 */
	IF sQcGub  <> "1" And ( sInsEmp = '' Or IsNull(sInsEmp)) THEN
		f_message_chk(30,'[검사담당자]')
		dw_insert.SetColumn("insemp")
		Return -1
	END IF

  /* 무검사일 경우 검사담당자 */
	IF sQcGub  = "1"  THEN
		dw_insert.SetItem(iCurRow,'insemp', sNull)
	END IF
	
  /* 부서반품일 경우 반품사유 무입력 */
	If sIoGbn <> 'O44' Then
	  IF sBigo = "" OR IsNull(sBigo) THEN
		  f_message_chk(30,'[반품사유]')
		  dw_insert.SetColumn("bigo")
		  dw_insert.SetFocus()
		  Return -1
	  END IF
   End If
	
	/* 출고송장번호 check */
	sIojpNo  = Trim(dw_insert.GetItemString(iCurRow,"ip_jpno"))
	If sIoGbn = 'O41' and is_IojpnoOK = 'Y' and ( sIojpno = '' or IsNull(sIojpno)) then
		f_message_chk(30,'[출고송장번호]')
		dw_insert.SetColumn("ip_jpno")
		dw_insert.SetFocus()
		Return -1
	end if
END IF

Return 1

end function

public function integer wf_catch_special_danga (integer nrow, ref double ioprc, ref double dcrate, string gbn);/* ----------------------------------------------------- */
/* 특출일 경우 할인율과 단가 계산                        */
/* ----------------------------------------------------- */
string s_order_date,s_itnbr,s_ispec,s_curr,s_pricegbn
int irow,rtn

If dw_insert.RowCount() < nRow Then Return 2

s_order_date = dw_input.GetItemString(1,'sudat')
s_itnbr      = dw_insert.GetItemString(nRow,'itnbr')
s_ispec      = dw_insert.GetItemString(nRow,'itemas_ispec')
s_pricegbn   = '1'  //원화
s_curr       = 'WON'		 

If IsNull(s_order_date) Or s_order_date = '' Then
   f_message_chk(40,'[반품일자]')
   Return -1
End If

If IsNull(s_itnbr) Or s_itnbr = '' Then
   f_message_chk(40,'[품번]')
   Return -1
End If

If gbn = '1' Then
	/* 단가 입력시 할인율 계산 */
//   rtn = sqlca.fun_erp100000014(s_itnbr,ioprc,s_order_date,s_curr,s_pricegbn,dcrate)
   If rtn = -1 Then dcrate = 0
Else
	/* 할인율 입력시 단가계산 */
//   rtn = sqlca.fun_erp100000015(s_itnbr,s_order_date,s_curr,s_pricegbn,dcrate,ioprc)
	ioprc  = TrunCate(ioprc,0)
   If rtn = -1 Then 	ioprc = 0
End If

return 1
end function

public function integer wf_set_qc (integer nrow, string sitnbr);/* 품번으로 검사담당자및 검사방법 Setting */
String sNull, sGu, sInsEmp, sQcGub

SetNull(sNull)

sGu = '1'
f_get_qc(sGu,sItnbr,sNull,sNull, sQcGub, sInsEmp )

dw_insert.SetItem(nRow,'insemp', sInsEmp )
dw_insert.SetItem(nRow,'qcgub', sQcGub )

Return 1

end function

public function integer wf_chk (integer nrow);/* ----------------------------------------------------------------------------- */
/* 검사기준  수불승인 검사일자 담당자 승인일자 승인자 의뢰수량 합격수량 수불수량 */
/* ----------------------------------------------------------------------------- */
/* 무검사(1)   자동    sysdate  null   sysdate  null    qty       qty      qty   */
/* 무검사(1)   수동    sysdate  null     null   null    qty       qty       0    */
/*   검사       -        null  insemp    null   null    qty        0        0    */
/* ----------------------------------------------------------------------------- */

String sInsDat, sQcGub, sIoConfirm, sIoDate, sCheckNo

/* 검사일자없으면 삭제가능 */
sQcGub  = Trim(dw_insert.GetItemString(nrow,'qcgub'))
sInsDat = Trim(dw_insert.GetItemString(nrow,'insdat'))
sIoDate = Trim(dw_insert.GetItemString(nrow,'io_date'))
sIoConFirm = Trim(dw_insert.GetItemString(nrow,'io_confirm'))

sCheckNo  = Trim(dw_insert.GetItemString(nrow,'checkno'))

/* 계산서 발행 */
If Not IsNull(sCheckNo) Then Return -4

/* 무검사일경우 */
If sqcgub = '1' Then
   If sIoConfirm = 'Y' Then
		return 0
	ElseIf IsNull(sIoDate) Then
		return 0
	Else
		return -1
	End If
Else
/* 무검사가 아닌데 검사일자가 있을경우 삭제불가 */
	If IsNull(sInsDat) or sInsDat = '' Then
		return 0
	Else
		return -2
	End If	
End If

Return -3
end function

public subroutine wf_clear_item (integer icurrow);String sNull

SetNull(snull)

dw_insert.SetItem(iCurRow,"itnbr",snull)
dw_insert.SetItem(iCurRow,"itemas_itdsc",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec",snull)
dw_insert.SetItem(iCurRow,"itemas_jijil",snull)
dw_insert.SetItem(iCurRow,"itemas_ispec_code",snull)
dw_insert.SetItem(iCurRow,"itemas_filsk",snull)
dw_insert.SetItem(iCurRow,"itemas_itgu",snull)
dw_insert.SetItem(iCurRow,"ioprc",      0)
dw_insert.SetItem(iCurRow,"dcrate",     0)
dw_insert.SetItem(iCurRow,"dyebi3",     0)

dw_insert.SetItem(iCurRow,"insemp",snull)
dw_insert.SetItem(iCurRow,"qcgub",snull)
end subroutine

public function integer wf_set_ip_jpno (integer nrow, string siojpno, string scvcodb, string saupj);Double dItemQty, dItemPrice, dDcRate, dVatAmt
String sCVcod, sItnbr, sNull
String sItemDsc, sItemSize, sItemUnit, sItemGbn, sItemUseYn, sItemFilsk, sItemitgu, sJijil, sIspecCode

SetNull(sNull)

/* 출고송장의 단가와 수량 */
select x.cvcod, x.itnbr, x.ioreqty, x.ioprc   
  into :sCvcod, :sitnbr, :dItemQty, :dItemprice
  from imhist x, iomatrix i
 where x.sabu = i.sabu and
		 x.iogbn = i.iogbn and
       x.sabu = :gs_sabu and
		 x.iojpno = :siojpno and
		 x.iogbn = 'O09' and
		 x.saupj = :saupj	;

IF Sqlca.sqlcode <> 0 THEN
	f_message_chk(33,'[출고송장번호]')
	dw_insert.SetItem(nRow,'ip_jpno',sNull)
	Return 1
END If

SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",   "ITEMAS"."UNMSR",		
		 "ITEMAS"."ITTYP", 	"ITEMAS"."USEYN",	  "ITEMAS"."FILSK",	"ITEMAS"."ITGU",
		 "ITEMAS"."JIJIL",   "ITEMAS"."ISPEC_CODE"
  INTO :sItemDsc,   		:sItemSize,   		  :sItemUnit,				
		 :sItemGbn,			:sItemUseYn,		  :sItemFilsk,			:sItemItgu ,
		 :sJijil,			:sIspecCode
  FROM "ITEMAS"
 WHERE "ITEMAS"."ITNBR" = :sItnbr;

IF Sqlca.sqlcode <> 0 THEN
	f_message_chk(33,'[출고송장번호]')
	dw_insert.SetItem(nRow,'ip_jpno',sNull)
	Return 1
END If
		
dw_insert.SetItem(nRow,'ioprc',      dItemPrice)
dw_insert.SetItem(nRow,'imhist_qty', dItemQty)
dw_insert.SetItem(nRow,'ioreqty',    dItemQty)
dw_insert.SetItem(nRow,"dcrate",     dDcRate)

/* 금액 계산 */
dw_insert.SetItem(nRow,"ioamt",dItemQty * dItemPrice)
dw_insert.SetItem(nRow,"dyebi3",dVatAmt)

dw_insert.SetItem(nRow,'ip_jpno',sIojpNo)

dw_insert.SetItem(nRow,'itnbr',			  sItnbr)
dw_insert.SetItem(nRow,"itemas_itdsc",   sItemDsc)
dw_insert.SetItem(nRow,"itemas_ispec",   sItemSize)
dw_insert.SetItem(nRow,"itemas_jijil",   sJijil)
dw_insert.SetItem(nRow,"itemas_ispec_code",   sIspecCode)
dw_insert.SetItem(nRow,"itemas_filsk",   sItemFilsk)
dw_insert.SetItem(nRow,"itemas_itgu",    sItemItgu)

/* 검사담당자, 검사구분 */
wf_set_qc(nRow, sItnbr)

Return 0
end function

public function string wf_calculation_orderno (string sorderdate);String  sOrderNo,sOrderGbn
Integer iMaxOrderNo

sOrderGbn = 'S0'

iMaxOrderNo = sqlca.fun_junpyo(gs_sabu,sOrderDate,sOrderGbn)
IF iMaxOrderNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = sOrderDate + String(iMaxOrderNo,'000')

commit;

Return sOrderNo
end function

public subroutine wf_init ();String sDepotNo

dw_input.SetRedraw(False)

f_child_saupj(dw_input,'depot_no', gs_saupj)

dw_input.Reset()
dw_input.InsertRow(0)

dw_input.SetRedraw(True)

dw_insert.Reset()

p_ins.Enabled = True
p_ins.PictureName = "..\image\추가_up.gif"

dw_input.SetItem(1,"sudat",is_today)
dw_input.SetItem(1,"ioreemp", Gs_empno)
dw_input.SetItem(1,"empname", f_get_name('EMPNO',Gs_empno))
dw_input.SetItem(1,"ioredept", gs_dept)
dw_input.SetItem(1,"deptname", f_get_name('DPTNO',gs_dept))

ib_any_typing = False

/* 등록 */
IF sModStatus = 'I' THEN
	dw_input.Modify('iojpno.protect = 1')
	//dw_input.Modify("iojpno.background.color = '"+String(Rgb(192,192,192))+"'")
	dw_input.Modify('iogbn.protect = 0')
	//dw_input.Modify("iogbn.background.color = '"+String(Rgb(195,225,184))+"'")
	
	dw_input.Modify('saupj.protect = 0')
	//dw_input.Modify("saupj.background.color = '"+String(Rgb(195,225,184))+"'")
	
	dw_input.Modify('depot_no.protect = 0')
	//dw_input.Modify("depot_no.background.color = '"+String(Rgb(195,225,184))+"'")
	
	dw_input.SetColumn("ioredept")
ELSE
/* 수정 */
	dw_input.Modify('iojpno.protect = 0')
	//dw_input.Modify("iojpno.background.color = 65535")
	dw_input.Modify('iogbn.protect = 1')
	//dw_input.Modify("iogbn.background.color = 80859087")
	dw_input.Modify('depot_no.protect = 1')
	//dw_input.Modify("depot_no.background.color = 80859087")
	
	dw_input.SetColumn("iojpno")
END IF

f_mod_saupj(dw_input,'saupj')

dw_input.SetFocus()

end subroutine

on w_ssal_02050.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_insert=create rb_insert
this.rb_modify=create rb_modify
this.dw_print=create dw_print
this.p_preview=create p_preview
this.st_2=create st_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_insert
this.Control[iCurrent+3]=this.rb_modify
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.p_preview
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.rr_3
end on

on w_ssal_02050.destroy
call super::destroy
destroy(this.rr_2)
destroy(this.rb_insert)
destroy(this.rb_modify)
destroy(this.dw_print)
destroy(this.p_preview)
destroy(this.st_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent('ue_open')
end event

event ue_open;call super::ue_open;f_child_saupj(dw_input,'depot_no', gs_saupj)

dw_input.SetTransObject(SQLCA)
dw_input.Reset()
dw_input.InsertRow(0)

dw_print.SetTransObject(SQLCA)
dw_print.Reset()

dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

/* 출고송장번호 필수입력 여부 */
select substr(dataname,1,1) into :is_IojpnoOK
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 30;

/* 품목입력시 커서위치 여부 - '1' : 품번, '2' : 품명 */
select substr(dataname,1,1) into :isCursor
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 12;

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70

r_head.width = this.width - 60
dw_input.width = this.width - 70

end event

type cb_exit from w_inherite`cb_exit within w_ssal_02050
integer y = 3600
end type

type sle_msg from w_inherite`sle_msg within w_ssal_02050
integer x = 5472
integer y = 3444
end type

type dw_datetime from w_inherite`dw_datetime within w_ssal_02050
integer x = 5472
integer y = 3444
end type

type st_1 from w_inherite`st_1 within w_ssal_02050
integer y = 3600
end type

type p_search from w_inherite`p_search within w_ssal_02050
integer x = 5467
integer y = 3448
end type

type p_addrow from w_inherite`p_addrow within w_ssal_02050
integer x = 5467
integer y = 3448
end type

type p_delrow from w_inherite`p_delrow within w_ssal_02050
integer x = 5467
integer y = 3448
end type

type p_mod from w_inherite`p_mod within w_ssal_02050
integer y = 3200
end type

event p_mod::clicked;call super::clicked;/* ----------------------------------------------------------------------------- */
/* 반품의뢰시 setting 방법                                                       */
/* ----------------------------------------------------------------------------- */
/* 검사기준  수불승인 검사일자 담당자 승인일자 승인자 의뢰수량 합격수량 수불수량 */
/* ----------------------------------------------------------------------------- */
/* 무검사(1)   자동    sysdate  null   sysdate  null    qty       qty      qty   */
/* 무검사(1)   수동    sysdate  null     null   null    qty       qty       0    */
/*   검사       -        null  insemp    null   null    qty        0        0    */
/* ----------------------------------------------------------------------------- */
Integer	iFunctionValue,iRowCount,k,iMaxIoNo,iCurRow, icnt
String   sIoJpNo,sIoJpGbn,sIoSuDate, sDepotNo
string   qcgub,sIoConfirm,sNull,sIoDate
Long     nMaxSeq
Double   dIoPrc

SetNull(sNull)

w_mdi_frame.sle_msg.text =""

/* header key check */
If dw_input.accepttext() <> 1 Then Return
iFunctionValue = Wf_RequiredChk(dw_input.DataObject,1)
IF iFunctionValue = -1 THEN Return

/* detail key check */
If dw_insert.accepttext() <> 1 then Return
iRowCount = dw_insert.RowCount()
IF iRowCount <=0 THEN Return
FOR k = 1 TO iRowCount 													/*필수 체크*/
	iFunctionValue = Wf_RequiredChk(dw_insert.DataObject,k)
	IF iFunctionValue = -1 THEN
		dw_insert.ScrollToRow(k)
		Return
	END IF
NEXT

sIoSuDate = dw_input.GetItemString(1,"sudat")						/*의뢰일자*/

/* 매출마감시 송장 발행 안함 */
SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sIoSuDate,1,6) )   ;

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if

IF F_Msg_Update() = -1 THEN Return

IF sModStatus = 'I' THEN											/*반품의뢰번호 채번*/
   sIoJpGbn = 'C0'
	iMaxIoNo = sqlca.fun_junpyo(gs_sabu,sIoSuDate,sIoJpGbn)
	IF iMaxIoNo <= 0 THEN
		f_message_chk(51,'')
		ROLLBACK;
		Return 1
	END IF
	commit;
	sIoJpNo = sIoSuDate + String(iMaxIoNo,'0000')
	
	dw_input.SetItem(1,"iojpno",sIoJpNo)
	MessageBox("확 인","채번된 반품의뢰번호는 "+sIoJpNo+" 번 입니다!!")
ELSE
	sIoJpNo = Mid(dw_input.GetItemString(1,"iojpno"),1,12)
END IF

/* 순번 최대값 */
If dw_insert.RowCount() > 0 Then
  nMaxSeq = Long(dw_insert.GetItemString(1,'maxseq'))
  If IsNull(nMaxSeq) Then nMaxSeq = 0
Else
	nMaxSeq = 0
End If

/* 수불승인자동 여부 */
sDepotNo =  dw_input.GetItemString(1,'depot_no')

SELECT "VNDMST"."HOMEPAGE"
  INTO :sIoconFirm
  FROM "VNDMST"
 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' );

If IsNull(sIoConFirm) or sIoConFirm = '' Then	sIoConfirm = 'N'

dw_input.SetItem(1,'io_confirm',sIoconFirm) 

String ls_cvcod
String sarea

ls_cvcod = dw_input.GetItemString(1, 'cvcod')
SELECT SAREA
  INTO :sarea
  FROM VNDMST
 WHERE CVCOD = :ls_cvcod ;
 
IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN
	f_message_chk(51,'[반품의뢰번호]')
	Return
ELSE
	For k = 1 TO iRowCount
      If dw_insert.GetItemStatus(k,0,Primary!) = NewModified! Then
		  nMaxSeq += 1
		  dw_insert.SetItem(k,"sabu",       gs_sabu)
		  dw_insert.SetItem(k,"iojpno",     sIoJpNo+String(nMaxseq,'000'))
		End If

		dw_insert.SetItem(k,"saupj", dw_input.GetItemString(1,'saupj'))
		  
		/* 검사완료나 입고승인 여부에 따라 */
		If wf_chk(k) = 0 Then
			/* 수불 승인일자 : 무검사일경우 입력*/
			qcgub      = dw_insert.GetItemString(k,'qcgub')
			dw_insert.SetItem(k,"io_date",    sNull)
			dw_insert.SetItem(k,"iosuqty",    0)
			dw_insert.SetItem(k,"ioqty",      0)
			dw_insert.SetItem(k,"ioamt",      0)
			dw_insert.SetItem(k,"insdat",     sNull)
			dw_insert.SetItem(k,"decisionyn", sNull)

			/* 무검사일경우 */
			If qcgub = '1' Then
				IF sModStatus = 'I' THEN	
					dw_insert.SetItem(k,"insdat",     sIoSuDate)		
				ELSE
					dw_insert.SetItem(k,"insdat",     dw_insert.GetItemString(k, 'sudat'))		
				END IF
				dw_insert.SetItem(k,"io_confirm", sIoConFirm)
				dw_insert.SetItem(k,"iosuqty",    dw_insert.GetItemNumber(k,"ioreqty"))
				dw_insert.SetItem(k,"decisionyn", 'Y')
				
				/* 입고승인자동 */
				If sIoConFirm = 'Y' Then
					IF sModStatus = 'I' THEN	//수정시는 입고일자를 조정이 가능하게 함.
						dw_insert.SetItem(k,"io_date", sIoSuDate)
					ELSE
						dw_insert.SetItem(k,"io_date", dw_insert.GetItemString(k, 'sudat'))		
					END IF
					dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,"ioreqty"))
					
					dIoPrc = dw_insert.GetItemNumber(k,"ioprc")
					If IsNull(dIoPrc) Then dIoPrc = 0
					dw_insert.SetItem(k,"ioamt",      truncate(dw_insert.GetItemNumber(k,"ioreqty")*dIoPrc, 2))			
					IF sModStatus = 'I' THEN
						dw_insert.SetItem(k,"imhist_yebi1",  sIoSuDate) 
					ELSE
						dw_insert.SetItem(k,"imhist_yebi1",  dw_insert.GetItemString(k, 'sudat')) 
					END IF
					
				End If
//			ELSE
//				IF sModStatus <> 'I' THEN	//수정시는 입고일자를 조정이 가능하게 함.
//					dw_insert.SetItem(k,"io_date",    sIoSuDate)
//				END IF
			End If
			
			dw_insert.SetItem(k,"iogbn",      dw_input.GetItemString(1,"iogbn"))
			IF sModStatus = 'I' THEN
				dw_insert.SetItem(k,"sudat", 		 sIoSuDate)
//			ELSE
//				dw_insert.SetItem(k,"sudat", 		 dw_insert.GetItemString(k, 'sudat'))
			END IF
		End If
		
		dw_insert.SetItem(k,"ioredept",   dw_input.GetItemString(1,"ioredept"))
		dw_insert.SetItem(k,"ioreemp",    dw_input.GetItemString(1,"ioreemp"))
		dw_insert.SetItem(k,"cvcod",      dw_input.GetItemString(1,"cvcod"))
//		dw_insert.SetItem(k,"sarea",      dw_input.GetItemString(1,"cust_area"))
		dw_insert.SetItem(k,"depot_no",   sDepotNo)
	
		dw_insert.SetItem(k,"inpcnf", 'I')   // 입출고구분(입고)
		dw_insert.SetItem(k,"botimh",'')
//		dw_insert.SetItem(k,"jnpcrt", '005') // 전표생성구분(반품의뢰)
		dw_insert.SetItem(k,"opseq",'9999')
		dw_insert.SetItem(k,"outchk",'N')
		//공장코드 추가(필수이력되어야 함. - 조회 시 조건누락됨.)
		dw_insert.SetItem(k,"imhist_facgbn",'.')  //공장구분이 없을 경우 '.' 으로 입력 - by shingoon 2007.12.01
		
		/* 출고송장번호 :판매반품일경우만 입력허용*/
		If dw_input.GetItemString(1,"iogbn") <> 'O41' Then
 		  dw_insert.SetItem(k,"ip_jpno",'')
		End If
		
		/* 부서반품일경우 의뢰부서 -> 거래처 */
		If dw_input.GetItemString(1,"iogbn") = 'O44' Then
		  dw_insert.SetItem(k,"cvcod",      dw_input.GetItemString(1,"ioredept"))
		End If
	Next
END IF

IF dw_insert.Update() <> 1 THEN
	MessageBox('확인', '저장시 오류가 발생 했습니다.')
	ROLLBACK;
	Return
END IF

//////////////////////////////////////////////////////////////////////////////
// 2002.03.21 유상웅 : 판매반품 거래명세표 생성
//////////////////////////////////////////////////////////////////////////////
IF sModStatus = '1'		THEN

	SQLCA.ERP000000580(gs_Sabu, sIoJpno)
	IF SQLCA.SQLCODE <> 0	THEN
		f_message_chk(32,'')
		ROLLBACK;
		RETURN 
	END IF
	
END IF
//////////////////////////////////////////////////////////////////////////////


COMMIT;

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'

//IF MessageBox("확 인","반품의뢰서를 출력하시겠습니까?",Question!,YesNo!) = 1 THEN 
//	p_print.TriggerEvent(Clicked!)
//END IF

Wf_Init()
end event

type p_del from w_inherite`p_del within w_ssal_02050
integer y = 3200
end type

event p_del::clicked;call super::clicked;if this.Enabled = False then return

Integer iCurRow, iCnt
String sIosudate

iCurRow = dw_insert.GetRow()
IF iCurRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

If wf_chk(iCurRow) <> 0 Then Return

/* 매출마감시 송장 발행 안함 */
sIoSuDate = dw_input.GetItemString(1,"sudat")						/*의뢰일자*/

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sIoSuDate,1,6) )   ;

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if

string	sCheckno 
sCheckno = dw_insert.GetItemString(iCurRow, "checkno")

IF Not IsNull(sCheckno)		THEN
	MessageBox("삭제불가", "세금계산서가 발행된 자료입니다")
	RETURN
END IF


IF F_Msg_Delete() = -1 THEN Return

dw_insert.DeleteRow(iCurRow)
IF sModStatus = 'M' THEN
	IF dw_insert.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF
	COMMIT;
	
	If dw_insert.RowCount() <= 0 Then wf_init()
END IF

dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()

w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'

end event

type p_inq from w_inherite`p_inq within w_ssal_02050
integer y = 3200
end type

event p_inq::clicked;call super::clicked;String  sIoJpNo
Long    nCnt

If dw_input.AcceptText() <> 1 Then 	Return

sIoJpNo = Mid(dw_input.GetItemString(1,"iojpno"),1,12)
IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
	f_message_chk(30,'[반품의뢰번호]')
	dw_input.SetColumn("iojpno")
	dw_input.SetFocus()
	Return 
END IF

dw_input.Retrieve(gs_sabu,sIoJpNo)
IF dw_insert.Retrieve(gs_sabu,sIoJpNo) > 0 THEN
	
	dw_input.Modify('iojpno.protect = 1')
//	dw_input.Modify("iojpno.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_input.Modify('sudat.protect = 1')
//	dw_input.Modify("sudat.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_input.Modify('iogbn.protect = 1')
//	dw_input.Modify("iogbn.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_input.Modify('saupj.protect = 1')
//	dw_input.Modify("saupj.background.color = '"+String(Rgb(192,192,192))+"'")
	
	dw_insert.ScrollToRow(1)
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	ib_any_typing = False
ELSE
	wf_init()
	f_message_chk(50,'')
	dw_input.SetColumn("iojpno")
	dw_input.SetFocus()
	Return
END IF

/* 검사확인된것이 1건이상이면 추가불가  */
SELECT COUNT("IMHIST"."INSDAT")   INTO :nCnt
  FROM "IMHIST"  
  WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
	     ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
		  ( "IMHIST"."JNPCRT" ='005') AND
		  ( "IMHIST"."INSDAT" IS NOT NULL);

If nCnt > 0 Then
	p_ins.Enabled = False
	p_ins.PictureName = "..\image\추가_d.gif"
Else
	p_ins.Enabled = True
	p_ins.PictureName = "..\image\추가_up.gif"
End If
end event

type p_print from w_inherite`p_print within w_ssal_02050
integer y = 3200
end type

event p_print::clicked;call super::clicked;String  sIoJpNo, sDepotNo
Integer iRowCount,iModCnt,iCurRow

If dw_input.AcceptText() <> 1 Then return

sIoJpNo = Mid(dw_input.GetItemString(1,"iojpno"),1,12)
IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
	f_message_chk(30,'[의뢰번호]')
	dw_input.SetColumn("iojpno")
	dw_input.SetFocus()
	Return 
END IF

/* 영업 창고 */
select min(cvcod )
  into :sDepotNo
  from vndmst
 where cvgu = '5' and
       juhandle = '1' ;  

/* 저장위치는 영업창고를 우선으로 보여준다 */
If sqlca.sqlcode <> 0 or IsNull(sDepotNo) Then
	sDepotNo = dw_input.GetItemString(1,'depot_no')
End If

IF dw_print.Retrieve(gs_sabu,sIoJpNo, sDepotNo) > 0 THEN
	dw_print.object.datawindow.print.preview="yes"
	
	gi_page = dw_print.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_print)
Else
	f_message_chk(50,'')
END IF

end event

type p_can from w_inherite`p_can within w_ssal_02050
integer y = 3200
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_exit from w_inherite`p_exit within w_ssal_02050
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_ssal_02050
integer y = 3200
end type

event p_ins::clicked;call super::clicked;if this.Enabled = False then return

Long il_currow,il_functionvalue
String sIoGbn, sNull, sDepotNo, sSaupj, sSudat, sSarea, sCvcod, sEmpno, ls_bumun

SetNull(sNull)

IF dw_insert.AcceptText() = -1 THEN RETURN

il_currow = dw_insert.RowCount()
IF il_currow <=0 THEN
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(dw_insert.DataObject,il_currow)
END IF

dw_input.SetFocus()

sSaupj = Trim(dw_input.GetItemString(1,'saupj'))
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(30,'[부가사업장]')
	dw_input.SetColumn("saupj")
	Return 
End If

sDepotNo = Trim(dw_input.GetItemString(1,'depot_no'))
If IsNull(sDepotNo) or sDepotNo = '' Then
	f_message_chk(30,'[반품창고]')
	dw_input.SetColumn("depot_no")
	Return 
End If

sSudat = Trim(dw_input.GetItemString(1,'sudat'))
If IsNull(sSudat) or sSudat = '' Then
	f_message_chk(30,'[반품일자]')
	dw_input.SetColumn("sudat")
	Return 
End If

sIogbn = Trim(dw_input.GetItemString(1,'iogbn'))
If IsNull(sIogbn) or sIogbn = '' Then
	f_message_chk(30,'[반품구분]')
	dw_input.SetColumn("iogbn")
	Return 
End If

sCvcod = Trim(dw_input.GetItemString(1,'cvcod'))
If IsNull(sCvcod) or sCvcod = '' Then
	f_message_chk(30,'[반품거래처]')
	dw_input.SetColumn("cvcod")
	Return 
End If

sEmpno = Trim(dw_input.GetItemString(1,'ioreemp'))
If IsNull(sEmpno) or sEmpno = '' Then
	f_message_chk(30,'[반품의뢰자]')
	dw_input.SetColumn("ioreemp")
	Return 
End If

//ls_bumun = Trim(dw_input.GetItemString(1,'yebi3'))
//If IsNull(ls_bumun) or ls_bumun = '' Then
//	f_message_chk(30,'[사업부문]')
//	dw_input.SetColumn("yebi3")
//	Return 
//End If
//
IF il_functionvalue = 1 THEN
	/* 출고구분을 수정못하도록 변경 */
	dw_input.Modify('iogbn.protect = 1')
	//dw_input.Modify("iogbn.background.color = 80859087")
	dw_input.Modify('depot_no.protect = 1')
	//dw_input.Modify("depot_no.background.color = 80859087")
	
	dw_input.Modify('saupj.protect = 1')
	//dw_input.Modify("saupj.background.color = 80859087")
	
	il_currow = il_currow + 1
	
	dw_insert.InsertRow(il_currow)
	
	dw_insert.ScrollToRow(il_currow)
	dw_insert.Object.DataWindow.HorizontalScrollPosition = 0
	sIoGbn = Trim(dw_input.GetItemString(1,"iogbn"))
	dw_insert.SetItem(il_currow,"iogbn",sIoGbn)
	/* 판매반품일 경우 검사구분 입력안함 */
	If sIoGbn = 'O41' Then
		dw_insert.SetItem(il_currow,"qcgub",sNull)
	Else
		dw_insert.SetItem(il_currow,"qcgub",'1')
	End If
	
//	dw_insert.SetItem(il_currow,"insemp",is_insemp)
	dw_insert.SetItem(il_currow,"yebi3",ls_bumun)
	If isCursor = '2' Then dw_insert.SetColumn('itemas_itdsc') else dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
END IF

end event

type p_new from w_inherite`p_new within w_ssal_02050
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_ssal_02050
event ue_key pbm_dwnkey
integer x = 320
integer y = 188
integer width = 4233
integer height = 196
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_ssal_020501"
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sIoJpNo,sSuDate,sIoCust,sIoCustArea,sIoCustName,sIoConFirm
String  sDepotNo,sDept,sDeptname,snull,sEmpNo,sEmpName, sInsDat

SetNull(snull)

Choose Case this.GetColumnName()
	Case "saupj"
		sIoCust = GetText()
		f_child_saupj(dw_input,'depot_no', sIoCust)
//		f_child_saupj(dw_input,'cust_area', sIoCust)
	/* 반품의뢰번호 */
	Case  "iojpno" 
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
	  /* 검사확인 */
		SELECT DISTINCT "IMHIST"."INSDAT"   INTO :sInsDat
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
				 ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
				 ( "IMHIST"."IOGBN" IN ('O47', 'O42') ) ;
				 /*( "IMHIST"."JNPCRT" ='025') AND
				 ( "IMHIST"."INV_NO" IS NULL );*/
	
		IF SQLCA.SQLCODE <> 0 THEN
		  this.TriggerEvent(RButtonDown!)
		  Return 2
		ELSE
			p_inq.TriggerEvent(Clicked!)
		END IF
	Case "sudat"
		sSuDate = Trim(GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[반품의뢰일자]')
			this.SetItem(1,"sudat",snull)
			Return 1
		END IF
	/* 반품담당부서 */
	Case "ioredept"
		sDept = Trim(GetText())
		IF sDept ="" OR IsNull(sDept) THEN
			this.SetItem(1,"deptname",snull)
			this.SetItem(1,"ioreemp",sNull)
			this.SetItem(1,"empname",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sDeptName
		 FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sDept AND "VNDMST"."CVGU" ='4';
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"deptname",sDeptName)
			this.SetItem(1,"ioreemp",sNull)
			this.SetItem(1,"empname",sNull)
		END IF
	/* 반품담당부서명 */
	Case "deptname"
		sDeptName = Trim(GetText())
		IF sDeptName ="" OR IsNull(sDeptName) THEN
			this.SetItem(1,"ioredept",snull)
			this.SetItem(1,"ioreemp",sNull)
			this.SetItem(1,"empname",sNull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD"			INTO :sDept
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVNAS2" = :sDeptName AND "VNDMST"."CVGU" ='4'  ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"ioredept",sDept)
			this.SetItem(1,"ioreemp",sNull)
			this.SetItem(1,"empname",sNull)
		END IF
	/* 반품처 */
	Case "cvcod"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			this.SetItem(1,"cvname",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"		INTO :sIoCustName
		  FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
		 return 2
		ELSE
			this.SetItem(1,"cvname",  sIoCustName)
		END IF
	Case "depot_no"
		sDepotNo = this.GetText()
		IF sDepotNo = "" OR IsNull(sDepotNo) THEN RETURN
		
		SELECT "VNDMST"."CVNAS2" , "VNDMST"."HOMEPAGE"
		  INTO :sDepotNo  , :sIoconFirm  
		  FROM "VNDMST"  
		 WHERE ( "VNDMST"."CVCOD" = :sDepotNo ) AND  ( "VNDMST"."CVGU" = '5' )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[창고]')
			this.SetItem(1,"depot_no",snull)
			Return 1
		END IF
		
		SetItem(1,'io_confirm',sIoconFirm) /* 수불승인여부 */
	/* 반품담당자 */
	Case "ioreemp"
	  sEmpNo = Trim(GetText())
	  If sEmpno = '' Or IsNull(sEmpno) Then
		  SetItem(1,'empname',sNull)
		  Return
	  End If
	
	  SELECT "P1_MASTER"."EMPNO", "P1_MASTER"."EMPNAME", "DEPTCODE"
		 INTO :sEmpNo, :sEmpName, :sDepotNo
		 FROM "P1_MASTER"
		WHERE ("P1_MASTER"."EMPNO" = :sEmpNo ) AND 
				("P1_MASTER"."SERVICEKINDCODE" <> '3' );
	
	  IF SQLCA.SQLCODE <> 0 THEN
		 this.TriggerEvent(RbuttonDown!)
		 Return 2
	  ELSE
		 this.SetItem(1,"empname",sEmpName)
		 this.SetItem(1,"ioredept",sDepotNo)
	  END IF
	/* 반품담당자명 */
	Case "empname"
	  sEmpName = Trim(GetText())
	  If sEmpName = '' Or IsNull(sEmpName) Then
		  SetItem(1,'ioreemp',sNull)
		  Return
	  End If
	
	  SELECT "P1_MASTER"."EMPNO", "P1_MASTER"."EMPNAME" 
		 INTO :sEmpNo, :sEmpName
		 FROM "P1_MASTER"  
		WHERE ("P1_MASTER"."EMPNAME" = :sEmpName ) AND 
				("P1_MASTER"."SERVICEKINDCODE" <> '3' );
	
	  IF SQLCA.SQLCODE <> 0 THEN
		 this.TriggerEvent(RbuttonDown!)
		 Return 2
	  ELSE
		 this.SetItem(1,"ioreemp",sEmpNo)
	  END IF

END Choose

end event

event editchanged;ib_any_typing = True
end event

event rbuttondown;String sDeptName,sNull, sIoGbn

SetNull(sNull)
SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* 반품의뢰번호 */
	Case "iojpno" 
		gs_gubun = '025'
		gs_codename = 'B'
		Open(w_imhist_02600_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"iojpno",Left(gs_code,12))
	   p_inq.PostEvent(Clicked!)
	/* 반품의뢰부서 */
	Case "ioredept"
		Open(w_dept_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"ioredept",gs_code)
		SetItem(1,"deptname",gs_codename)
		SetItem(1,"ioreemp",sNull)
		SetItem(1,"empname",sNull)
		
//		SetColumn("ioreemp")
	/* 반품의뢰부서명 */
	Case "deptname" 
		Open(w_dept_popup)
		
		IF gs_codename ="" OR IsNull(gs_codename) THEN RETURN
		
		SetItem(1,"ioredept",gs_code)
		SetItem(1,"deptname",gs_codename)
		SetItem(1,"ioreemp",sNull)
		SetItem(1,"empname",sNull)
		
//		SetColumn("ioreemp")
	/* 반품담당자 */
	Case "ioreemp" , "empname"
		gs_gubun = GetItemString(1,"ioredept")
		Open(w_sawon_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
//		If gs_gubun <> GetItemString(1,"ioredept") Then
			SELECT "VNDMST"."CVNAS2"
			  INTO :sDeptName
			  FROM "VNDMST"  
			 WHERE "VNDMST"."CVCOD" = :gs_gubun AND "VNDMST"."CVGU" ='4';
			
			SetItem(1,"ioredept",gs_gubun)
			SetItem(1,"deptname",sDeptName)
//		End If
		
		SetItem(1,"ioreemp",gs_code)
		SetItem(1,"empname",gs_codename)
//		SetColumn("cvcod")
	/* 반품처 */
	Case "cvcod" , "cvname"
		
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetItem(1,"cvname",gs_codename)
//		SetColumn("depot_no")
END Choose

ib_any_typing = True
end event

event dw_input::itemfocuschanged;IF this.GetColumnName() = "cvname" OR this.GetColumnName() ='empname' OR this.GetColumnName() ='deptname'THEN
	//f_toggle_kor(Handle(this))
ELSE
	//f_toggle_eng(Handle(this))
END IF
end event

type cb_delrow from w_inherite`cb_delrow within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_addrow from w_inherite`cb_addrow within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type dw_insert from w_inherite`dw_insert within w_ssal_02050
integer x = 37
integer y = 428
integer width = 4521
integer height = 1808
integer taborder = 20
string dataobject = "d_ssal_020502"
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;String  sNull, sIogbn,sItnbrUnit, sIttyp, sItnbruseyn, sItnbrfilsk, sItnbritgu, sItnbrYn, sOrderSpec
String  sIocust, sIocustname, sIojpno, scvcod, ssaupj
Double  dItemQty,dItemPrice,dDcRate,dNewDcRate,dTemp
Long    nRow,iRtnValue,nCnt
String  sItnbr, sItdsc, sIspec, sJijil, sispeccode, sIoSpec

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case "itnbr"
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			Wf_Clear_Item(nRow)
			Return
		END IF
		
		sIoGbn  = Trim(GetItemString(nRow,"iogbn"))
		sIoSpec = Trim(GetItemString(nRow,"pspec"))
		
		SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",   "ITEMAS"."UNMSR",		
				 "ITEMAS"."ITTYP", 	"ITEMAS"."USEYN",	  "ITEMAS"."FILSK",	"ITEMAS"."ITGU",
				 "ITEMAS"."JIJIL", 	"ITEMAS"."ISPEC_CODE"
		  INTO :sItdsc,   			:sIspec,   		  	  :sItnbrUnit,
				 :sIttyp,				:sItnbrUseYn,		  :sItnbrFilsk,			:sItnbrItgu,
				 :sJijil,            :sIspeccode
		  FROM "ITEMAS"
		 WHERE "ITEMAS"."ITNBR" = :sItnbr ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				Wf_Clear_Item(nRow)
				Return 1
			ELSE
				Return 1
			END IF
		ELSE
			/* 입력가능여부 */
			SELECT DECODE(RFNA2,'N',RFNA2,'Y') INTO :sItnbrYn
			  FROM REFFPF  
			 WHERE RFCOD = '05' AND     RFGUB <> '00' AND
					 RFGUB = :sIttyp;
			
			If IsNull(sItnbrYn) Then sItnbr = 'Y'
			
			If sItnbrYN = 'N' or sItnbrUseYn <> '0' Then
				f_message_chk(58,'[품번]')
				Wf_Clear_Item(nRow)
				Return 1
			End If
		
//	   	iRtnValue = sqlca.Fun_Erp100000011(dw_input.GetItemString(1,"sudat"),sItnbr, '.' , ' ' ,'1',dItemPrice,dDcRate) 
			
//			iRtnValue =  sqlca.Fun_Erp100000016(gs_sabu,  dw_input.GetItemString(1,"sudat"), dw_input.GetItemString(1,"cvcod"), sItnbr, '.', &
//												'WON','1', dItemPrice, dDcRate,'3') 
			
			IF iRtnValue > 0 THEN
				SetItem(nRow,"ioprc",  TrunCate(dItemPrice,0))
				SetItem(nRow,"dcrate", dDcRate)
				If sIoGbn = 'O41' Then SetColumn("ip_jpno") Else SetColumn("bigo")
					Setfocus()
				ELSE
					IF iRtnValue < 0 THEN
						f_message_chk(41,'[단가 계산]')
						Wf_Clear_Item(nRow)
						SetColumn("itnbr")
						Return 1 
					ELSE
						SetItem(nRow,"ioprc",	 0)
						SetItem(nRow,"dcrate", 	 0)
						SetItem(nRow,"ioreqty",  0) 
						SetItem(nRow,"dyebi3",   0) 
					END IF
				END IF
		
				SetItem(nRow,"itemas_itdsc",   sItdsc)
				SetItem(nRow,"itemas_ispec",   sIspec)
				SetItem(nRow,"itemas_jijil",   sJijil)
				SetItem(nRow,"itemas_ispec_code",   sIspecCode)
				SetItem(nRow,"itemas_filsk",   sItnbrFilsk)
				SetItem(nRow,"itemas_itgu",    sItnbrItgu)
				
//				/* 검사담당자, 검사구분 */
//				wf_set_qc(nRow, sItnbr)
				Return 
			END IF
			
			If sIoGbn = 'O41' Then SetColumn("ip_jpno") Else SetColumn("bigo")

	Case 'pspec'
		sOrderSpec = Trim(GetText())
		IF sOrderSpec = "" OR IsNull(sOrderSpec) THEN
			SetItem(nRow,"pspec",'.')
			Return 2
		END IF
	/* 고객코드 */
	Case "cust_no"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) THEN
			SetItem(nRow,"cust_name",snull)
			Return
		END IF
		
		SELECT "CUSTOMER"."CUST_NAME"  INTO :sIoCustName  
		  FROM "CUSTOMER"  
		 WHERE "CUSTOMER"."CUST_NO" = :sIoCust   ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			Return 1
		ELSE
			SetItem(nRow,"cust_name",sIoCustName)
		END IF
	Case "cust_name"
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			SetItem(nRow,"cust_no",snull)
			Return
		END IF
		
		SELECT "CUSTOMER"."CUST_NO"  INTO :sIoCust  
		  FROM "CUSTOMER"  
		 WHERE "CUSTOMER"."CUST_NAME" = :sIoCustName ;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				SetItem(nRow,"cust_no",snull)
				SetItem(nRow,"cust_name",snull)
				Return 1
			END IF
		ELSE
			SetItem(nRow,"cust_no",sIoCust)
		END IF
	/* 출고승인 전표 */
	Case "ip_jpno" 
		sIojpNo = Trim(GetText())
		
		dw_input.SetFocus()
		sCvcod  = dw_input.GetItemString(1,'cvcod')
		If sCvcod = '' Or IsNull(sCvcod) Then
			f_message_chk(40,'[반품처]')
			
			dw_input.SetColumn('cvcod')
			Return 2
		End If
		sSaupj = Trim(dw_input.GetItemString(1,'saupj'))
		If sSaupj = '' Or IsNull(sSaupj) Then
			f_message_chk(40,'[부가사업장]')
			dw_input.SetColumn('saupj')
			Return 2
		End If
		
		SetItem(nRow,'imhist_qty',0)
		
		Return wf_set_ip_jpno(nRow,sIojpNo,sCVcod, sSaupj)

	/* 수량 */
	Case "ioreqty"
		dItemQty = Double(GetText())
		IF IsNull(dItemQty) THEN SetItem(nRow,'ioreqty',0)
		
		/* 출고수량과 비교 */
		dTemp = GetItemNumber(nRow,"imhist_qty")
		If dTemp = 0 Or IsNull(dTemp) Then
		ElseIf dItemQty > dTemp Then
			f_message_chk(150,'~r~n~r~n[출고의뢰수량:'+string(dTemp,'#,###')+ ']')
			Return 1
		End If
		
		dItemPrice = GetItemNumber(nRow,"ioprc")
		IF IsNull(dItemPrice) THEN dItemPrice =0
		
		SetItem(nRow,"ioamt",TrunCate(dItemQty * dItemPrice,0))
		SetItem(nRow,"dyebi3",TrunCate(dItemQty * dItemPrice*0.1,0))	/* 부가세 */
	/* 단가 */
	Case "ioprc"
		dItemPrice = Double(GetText())
		If IsNull(dItemPrice) Then dItemPrice = 0
		
		/* 특출 할인율 계산 */
		dNewDcRate = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'1') <> 1 Then Return 2
		SetItem(nRow,"dcrate",dNewDcRate)
		
		/* 금액 계산 */
		dItemQty = GetItemNumber(nRow,"ioreqty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		SetItem(nRow,"ioamt",  TrunCate(dItemQty * dItemPrice,0))
		SetItem(nRow,"dyebi3", TrunCate(dItemQty * dItemPrice*0.1,0))
		
	/* 할인율 */
	Case "dcrate"
		dNewDcRate = Double(GetText())
		If IsNull(dNewDcRate) Then dNewDcRate = 0
		
		/* 특출 할인율 계산 */
		dItemPrice = 0.0
		If wf_catch_special_danga(nRow,dItemPrice,dNewDcRate,'2') <> 1 Then Return 2
		SetItem(nRow,"ioprc",dItemPrice)
		
		/* 금액 계산 */
		dItemQty = GetItemNumber(nRow,"ioreqty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		SetItem(nRow,"ioamt",TrunCate(dItemQty * dItemPrice,0))
		SetItem(nRow,"dyebi3",TrunCate(dItemQty * dItemPrice*0.1,0))
END Choose
end event

event dw_insert::rbuttondown;Long    nRow
String  sCvcod,sItnbr, sSaupj

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
//	  gs_gubun = '1'
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  TriggerEvent(ItemChanged!)
	Case "itemas_itdsc"
	  gs_gubun = '1'  
	  open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  SetColumn("itnbr")
	  SetFocus()
	
	  TriggerEvent(ItemChanged!)
	Case "itemas_ispec"
	  gs_gubun = '1'  
	  open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"itnbr",gs_code)
	  SetColumn("itnbr")
	  SetFocus()
		
	  TriggerEvent(ItemChanged!)
	Case "cust_no"
	  Open(w_cust_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
	  SetItem(nRow,"cust_no",gs_code)
	  SetItem(nRow,"cust_name",gs_codename)
	Case "cust_name"
		Open(w_cust_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"cust_name",gs_codeName)
		TriggerEvent(ItemChanged!)
	/* 출고승인 전표 */
	Case "ip_jpno"
		dw_input.SetFocus()
		sCvcod = Trim(dw_input.GetItemString(1,'cvcod'))
		If sCvcod = '' Or IsNull(sCvcod) Then
			f_message_chk(40,'[반품처]')
			dw_input.SetColumn('cvcod')
			Return 2
		End If
		
		sSaupj = Trim(dw_input.GetItemString(1,'saupj'))
		If sSaupj = '' Or IsNull(sSaupj) Then
			f_message_chk(40,'[부가사업장]')
			dw_input.SetColumn('saupj')
			Return 2
		End If
		
		gs_code     = Trim(GetText())
		gs_gubun    = scvcod
		gs_codename = sSaupj
		Open(w_ssal_02050_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN		
		
		Return wf_set_ip_jpno(nRow,gs_code,sCVcod, sSaupj)
End Choose 

end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup4)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::itemfocuschanged;IF this.GetColumnName() = "bigo" THEN
	//f_toggle_kor(Handle(this))
ELSE
	//f_toggle_eng(Handle(this))
END IF
end event

event dw_insert::rowfocuschanging;
If newrow <= 0 Then Return

If wf_chk(newrow) = 0 Then
	p_del.Enabled = True
	p_del.PictureName = "..\image\삭제_up.gif"
Else
	p_del.Enabled = False
	p_del.PictureName = "..\image\삭제_d.gif"
End If

end event

event dw_insert::updatestart;Long ix

For ix = 1 To This.RowCount()
	Choose Case GetItemStatus(ix,0,Primary!)
		Case NewModified!
			This.SetItem(ix,'crt_user',gs_userid)
		Case DataModified!
			This.SetItem(ix,'upd_user',gs_userid)
	End Choose
Next
end event

type cb_mod from w_inherite`cb_mod within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_ins from w_inherite`cb_ins within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_del from w_inherite`cb_del within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_inq from w_inherite`cb_inq within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_print from w_inherite`cb_print within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_can from w_inherite`cb_can within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type cb_search from w_inherite`cb_search within w_ssal_02050
boolean visible = false
integer y = 3600
end type

type gb_10 from w_inherite`gb_10 within w_ssal_02050
integer x = 5179
integer y = 3444
end type

type gb_button1 from w_inherite`gb_button1 within w_ssal_02050
integer x = 5179
integer y = 3444
end type

type gb_button2 from w_inherite`gb_button2 within w_ssal_02050
integer x = 5179
integer y = 3444
end type

type r_head from w_inherite`r_head within w_ssal_02050
integer x = 315
integer y = 184
integer width = 4242
integer height = 204
end type

type r_detail from w_inherite`r_detail within w_ssal_02050
integer y = 424
integer width = 4530
integer height = 1816
end type

type rr_2 from roundrectangle within w_ssal_02050
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 224
integer y = 28
integer width = 741
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_insert from radiobutton within w_ssal_02050
integer x = 64
integer y = 208
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "등록"
boolean checked = true
end type

event clicked;sModStatus = 'I'											/*등록*/
p_preview.Enabled = false
p_preview.Picturename = '..\image\반품의뢰서출력_d.gif'

Wf_Init()

end event

type rb_modify from radiobutton within w_ssal_02050
integer x = 64
integer y = 284
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "수정"
end type

event clicked;sModStatus = 'M'											/*수정*/
p_preview.Enabled = True
p_preview.Picturename = '..\image\반품의뢰서출력_up.gif'

Wf_Init()
end event

type dw_print from datawindow within w_ssal_02050
boolean visible = false
integer x = 261
integer y = 44
integer width = 654
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "반품의뢰서"
string dataobject = "d_ssal_020503"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_preview from picture within w_ssal_02050
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3223
integer y = 24
integer width = 306
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\preview.cur"
boolean originalsize = true
string picturename = "..\image\반품의뢰서출력_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;If this.Enabled = True then 
	p_preview.Picturename = '..\image\반품의뢰서출력_dn.gif'
End if




end event

event ue_lbuttonup;If this.Enabled = True then 
	p_preview.Picturename = '..\image\반품의뢰서출력_up.gif'
End if
end event

event clicked;String  sIoJpNo, sDepotNo

If dw_input.AcceptText() <> 1 Then 	Return

sIoJpNo = Mid(dw_input.GetItemString(1,"iojpno"),1,12)
IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
	f_message_chk(30,'[반품의뢰번호]')
	dw_input.SetColumn("iojpno")
	dw_input.SetFocus()
	Return 
END IF

IF dw_print.Retrieve(gs_sabu,sIoJpNo) > 0 THEN
	dw_print.object.datawindow.print.preview="yes"
	
	gi_page = dw_print.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_preview, dw_print)
Else
	f_message_chk(50,'')
END IF

end event

type st_2 from statictext within w_ssal_02050
integer x = 1038
integer y = 112
integer width = 1152
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
string text = "※계산서 발행된건은 조회되지 않습니다."
boolean focusrectangle = false
end type

type rr_3 from roundrectangle within w_ssal_02050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 12639424
integer x = 41
integer y = 184
integer width = 261
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

