$PBExportHeader$w_sal_02045.srw
$PBExportComments$출고송장 등록 - 기타매출
forward
global type w_sal_02045 from w_inherite
end type
type gb_2 from groupbox within w_sal_02045
end type
type rb_1 from radiobutton within w_sal_02045
end type
type rb_2 from radiobutton within w_sal_02045
end type
type dw_cond from u_key_enter within w_sal_02045
end type
type dw_list from u_d_popup_sort within w_sal_02045
end type
type pb_1 from u_pb_cal within w_sal_02045
end type
type rr_1 from roundrectangle within w_sal_02045
end type
end forward

global type w_sal_02045 from w_inherite
integer height = 2548
string title = "기타매출 등록"
gb_2 gb_2
rb_1 rb_1
rb_2 rb_2
dw_cond dw_cond
dw_list dw_list
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_02045 w_sal_02045

type variables
String LsIoJpNo,LsSuBulDate
string  sCursor
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_create_imhist ()
public function integer wf_add_imhist ()
public function integer wf_calc_danga (integer nrow, string itnbr)
public function integer wf_clear_item (integer nrow)
public function integer wf_requiredchk (integer option)
end prototypes

public subroutine wf_init ();rollback;

dw_list.Reset()   // 출력물 

dw_cond.SetRedraw(False)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetRedraw(True)

dw_insert.Reset()

IF sModStatus = 'I' THEN
	p_print.Enabled = False
   p_print.PictureName = "c:\erpman\image\인쇄_d.gif"
	dw_cond.Modify('iojpno.protect = 1')
//	dw_cond.Modify("iojpno.background.color = 80859087")

	dw_cond.Modify('iogbn.protect = 0')
//	dw_cond.Modify("iogbn.background.color = '"+String(Rgb(190,225,184))+"'")

	dw_cond.Modify('cvcod.protect = 0')
	dw_cond.Modify('vndname.protect = 0')
//	dw_cond.Modify("cvcod.background.color = '"+String(Rgb(255,255,0))+"'")
//	dw_cond.Modify("vndname.background.color = '"+String(Rgb(255,255,255))+"'")

	dw_cond.Modify('pjt_cd.protect = 0')
//	dw_cond.Modify("pjt_cd.background.color = '"+String(Rgb(255,255,255))+"'")
		
	dw_cond.Modify('sudat.protect = 0')
// dw_cond.Modify("sudat.background.color = '"+String(Rgb(190,225,184))+"'")

	dw_cond.SetRow(1)
	dw_cond.SetFocus()
	dw_cond.SetColumn("sudat")
	
	// 구분 변경 불가
	dw_cond.Object.area_cd.protect = '0'
ELSE
	p_print.Enabled = True
	p_print.PictureName = "c:\erpman\image\인쇄_up.gif"

	dw_cond.Modify('iojpno.protect = 0')
//	dw_cond.Modify("iojpno.background.color = 65535")

	dw_cond.Modify('iogbn.protect = 1')
//	dw_cond.Modify("iogbn.background.color = '"+String(Rgb(192,192,192))+"'")

	dw_cond.Modify('sudat.protect = 1')
	dw_cond.Modify('cvcod.protect = 1')
	dw_cond.Modify('vndname.protect = 1')
	
// dw_cond.Modify("sudat.background.color = 80859087")
//	dw_cond.Modify("cvcod.background.color = 80859087")
//	dw_cond.Modify("vndname.background.color = 80859087")

	dw_cond.Modify('pjt_cd.protect = 1')
//	dw_cond.Modify("pjt_cd.background.color = 80859087")
	
   dw_cond.SetFocus()
   dw_cond.SetRow(1)
	dw_cond.SetColumn("iojpno")
	
	// 구분 변경 불가
	dw_cond.Object.area_cd.protect = '1'
END IF


// 부가세 사업장 설정
f_mod_saupj(dw_cond, 'saupj')


ib_any_typing = False
end subroutine

public function integer wf_create_imhist ();/* -------------------------------- */
/* 신규로 송장을 등록할 경우 사용   */
/* -------------------------------- */
Long    nRcnt,iMaxIoNo,k
String  sIoJpGbn

nRcnt = dw_insert.RowCount()
IF nRcnt <=0 THEN
	f_message_chk(83,'')
	Return -1
END IF

IF MessageBox("확 인","저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

/*송장번호 채번*/
sIoJpGbn = 'C0'
iMaxIoNo = sqlca.fun_junpyo(gs_sabu,LsSuBulDate,sIoJpGbn)
IF iMaxIoNo <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
commit;

LsIoJpNo = LsSuBulDate + String(iMaxIoNo,'0000')

dw_cond.SetItem(1,"iojpno",LsIoJpNo)
MessageBox("확 인","채번된 송장번호는 "+LsIoJpNo+" 번 입니다!!")

For k = 1 TO nRcnt
	dw_insert.SetItem(k,"sabu",       gs_sabu)
	dw_insert.SetItem(k,"saupj",	    dw_cond.GetItemString(1,"saupj"))
	dw_insert.SetItem(k,"iojpno",     LsIoJpNo+String(k,'000'))
	dw_insert.SetItem(k,"sudat",      LsSuBulDate)
	
	dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,'ioreqty'))
	dw_insert.SetItem(k,"cvcod",	    dw_cond.GetItemString(1,"cvcod"))
	dw_insert.SetItem(k,"sarea",	    dw_cond.GetItemString(1,"cust_area"))
   dw_insert.SetItem(k,"pjt_cd",	    dw_cond.GetItemString(1,"pjt_cd")) /* 프로젝트 */
	  
	dw_insert.SetItem(k,"io_confirm", 'Y') 
	dw_insert.SetItem(k,"io_date",    LsSuBulDate) 
	dw_insert.SetItem(k,"filsk",   	 'N') /* 재고관리구분 */
	dw_insert.SetItem(k,"inpcnf",	    'O') /* 입출고 구분 */
	dw_insert.SetItem(k,"jnpcrt",     '024') /* 전표생성구분 */
	dw_insert.SetItem(k,"opseq",      '9999')
	dw_insert.SetItem(k,"outchk",      'N')
	
	dw_insert.SetItem(k,"imhist_yebi1",    LsSuBulDate)
	dw_insert.SetItem(k,"area_cd",    dw_cond.GetItemString(1,"area_cd"))
	dw_insert.SetItem(k,"imhist_lclgbn",    'V')		// 기타매출 계정으로...
	dw_insert.SetItem(k,"yebi2",    'WON')
	dw_insert.SetItem(k,"dyebi1",    1)
	dw_insert.SetItem(k,"dyebi2",    dw_insert.GetItemNumber(k,'ioprc'))
	dw_insert.SetItem(k,"imhist_lclgbn",    dw_cond.GetItemString(1,"lclgbn"))
	dw_insert.SetItem(k,"foramt",    dw_insert.GetItemNumber(k,'ioamt'))
Next

IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF

COMMIT;

Return nRcnt
end function

public function integer wf_add_imhist ();/* -------------------------------- */
/* 송장에 추가할 경우 사용          */
/* -------------------------------- */
Long  nRcnt,iMaxIoSeq,k,nCnt

nRcnt = dw_insert.RowCount()
IF nRcnt <=0 THEN
	f_message_chk(36,'')
	Return -1
END IF

IF MessageBox("확 인","저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN -1

iMaxIoSeq = Long(dw_insert.GetItemSTring(1,'maxseq'))
If IsNull(iMaxIoSeq) Then iMaxIoSeq = 0

For k = 1 TO nRcnt
	If dw_insert.GetItemStatus(k, 0, Primary!) = NewModified! Then 
	  iMaxIoseq += 1
	  dw_insert.SetItem(k,"sabu",       gs_sabu)
	  dw_insert.SetItem(k,"iojpno",     LsIoJpNo+String(iMaxIoSeq,'000'))
	  dw_insert.SetItem(k,"sudat",      LsSuBulDate)

	  dw_insert.SetItem(k,"cvcod",	   dw_cond.GetItemString(1,"cvcod"))
	  dw_insert.SetItem(k,"sarea",	   dw_cond.GetItemString(1,"cust_area"))
	  dw_insert.SetItem(k,"ioqty",      dw_insert.GetItemNumber(k,'ioreqty'))
	  dw_insert.SetItem(k,"pjt_cd",	   dw_cond.GetItemString(1,"pjt_cd")) /* 프로젝트 */
	  
	  dw_insert.SetItem(k,"io_confirm", 'N')
	  dw_insert.SetItem(k,"io_date",    LsSuBulDate)
	  dw_insert.SetItem(k,"filsk",   	'N') /* 재고관리구분 */
	  dw_insert.SetItem(k,"inpcnf",	   'O') /* 입출고 구분 */
	  dw_insert.SetItem(k,"jnpcrt",     '024') /* 전표생성구분 */
	  dw_insert.SetItem(k,"opseq",      '9999')
	  dw_insert.SetItem(k,"outchk",     'N')
 	  dw_insert.SetItem(k,"imhist_lclgbn",    dw_cond.GetItemString(1,"lclgbn"))
	  dw_insert.SetItem(k,'area_cd',    dw_cond.GetItemString(1,"area_cd"))
     dw_insert.SetItem(k,"imhist_yebi1",    LsSuBulDate) 
	
	  nCnt += 1
   End If
Next

IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return -1
END IF

COMMIT;

Return nCnt
end function

public function integer wf_calc_danga (integer nrow, string itnbr);string sOrderDate, sCvcod
int    iRtnValue
double ditemprice,ddcrate,dItemqty

/* 판매단가및 할인율 */
sOrderDate = dw_cond.GetItemString(1,"sudat")
sCvcod = dw_cond.GetItemString(1,"cvcod")

//iRtnValue = sqlca.Fun_Erp100000010(sOrderDate,dw_cond.GetItemString(1,"cvcod"),Itnbr,' ','1',dItemPrice,dDcRate)
iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu, sOrderDate, sCvcod, Itnbr, '.' , &
                                    'WON','1',dItemPrice,dDcRate) 

If IsNull(dItemPrice) Then dItemPrice = 0
If IsNull(dDcRate) Then dDcRate = 0

Choose Case iRtnValue
	Case is < 0 
		Wf_Clear_Item(nRow)
		f_message_chk(41,'[단가 계산]')
		Return 1
	Case Else
		dw_insert.SetItem(nRow,"ioprc", truncate(dItemPrice,0))
		
		/* 금액 계산 */
		dItemQty = dw_insert.GetItemNumber(nRow,"ioreqty")
		IF IsNull(dItemQty) THEN dItemQty =0
		
		dw_insert.SetItem(nRow,"ioamt",TrunCate(dItemQty * dItemPrice,0))
End Choose
Return 0

end function

public function integer wf_clear_item (integer nrow);String sNull

SetNull(snull)

dw_insert.SetItem(nRow,"itnbr",snull)
dw_insert.SetItem(nRow,"itemas_itdsc",snull)
dw_insert.SetItem(nRow,"itemas_ispec",snull)
dw_insert.SetItem(nRow,"ioprc",      0)
dw_insert.SetItem(nRow,"ioreqty",    0)
dw_insert.SetItem(nRow,"ioqty",      0)
dw_insert.SetItem(nRow,"ioamt",      0)

Return 0

end function

public function integer wf_requiredchk (integer option);String sIoCust, sSaupj

If dw_cond.AcceptText() <> 1 Then Return -1

LsIoJpNo    = Left(dw_cond.GetItemString(1,"iojpno"),12)
LsSuBulDate = Trim(dw_cond.GetItemString(1,"sudat"))
sIoCust     = Trim(dw_cond.GetItemString(1,"cvcod"))
sSaupj	   = Trim(dw_cond.GetItemString(1,"saupj"))

IF Option = 1 And ( sSaupj = "" OR IsNull(sSaupj) ) THEN
	f_message_chk(30,'[부가사업장]')
	dw_cond.SetColumn("saupj")
	dw_cond.SetFocus()
	Return -1
END IF
	 
/* detail check */
If Option = 2 Then
	string sIogbn, sItnbr, sItdsc, sIspec, sPspec, sFac
	Double dIoreqty
	Long   nCnt,ix
	
	nCnt = dw_insert.RowCount()
	If nCnt <=0 Then Return 1
	
	For ix = 1 To nCnt
		sIogbn = dw_insert.GetItemString(ix,'iogbn')
		sFac = dw_insert.GetItemString(ix,'facgbn')
		sItnbr = dw_insert.GetItemString(ix,'itnbr')
		sItdsc = dw_insert.GetItemString(ix,'itemas_itdsc')
		sIspec = dw_insert.GetItemString(ix,'itemas_ispec')
		sPspec = dw_insert.GetItemString(ix,'pspec')
		dIoreqty = dw_insert.GetItemNumber(ix,'ioreqty')
		
	   IF sIogbn = "" OR IsNull(sIogbn) THEN
		  f_message_chk(30,'[출고구분]')
		  dw_insert.SetRow(ix)
		  dw_insert.SetColumn("iogbn")
		  dw_insert.SetFocus()
		  Return -1
	   END IF
	   IF sFac = "" OR IsNull(sFac) THEN
		  f_message_chk(30,'[공장]')
		  dw_insert.SetRow(ix)
		  dw_insert.SetColumn("facgbn")
		  dw_insert.SetFocus()
		  Return -1
	   END IF
	   IF sItnbr = "" OR IsNull(sItnbr) THEN
		  f_message_chk(30,'[품번]')
		  dw_insert.SetRow(ix)
		  dw_insert.SetColumn("itnbr")
		  dw_insert.SetFocus()
		  Return -1
	   END IF
	   IF dIoreqty = 0 OR IsNull(dIoreqty) THEN
		  f_message_chk(30,'[수량]')
		  dw_insert.SetRow(ix)
		  dw_insert.SetColumn("ioreqty")
		  dw_insert.SetFocus()
		  Return -1
	   END IF
	Next	
	Return 1
Else
/* 송장 수정*/
  IF sModStatus = 'C' THEN
	 IF LsIoJpNo = "" OR IsNull(LsIoJpNo) THEN
		f_message_chk(30,'[송장번호]')
		dw_cond.SetColumn("iojpno")
		dw_cond.SetFocus()
		Return -1
	 END IF
/* 신규 송장*/
	ELSEIF sModStatus = 'I' THEN
		IF sIoCust = "" OR IsNull(sIoCust) THEN
			f_message_chk(30,'[거래처]')
			dw_cond.SetColumn("cvcod")
			dw_cond.SetFocus()
			Return -1
		END IF
		
		IF LsSuBulDate = "" OR IsNull(LsSuBulDate) THEN
			f_message_chk(30,'[발행일자]')
			dw_cond.SetColumn("sudat")
			dw_cond.SetFocus()
			Return -1
		END IF
	END IF
	
	Return 1
End If

end function

on w_sal_02045.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_cond=create dw_cond
this.dw_list=create dw_list
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_cond
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rr_1
end on

on w_sal_02045.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_cond)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransObject(SQLCA)
dw_cond.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

/* 출고송장 발행 report */
dw_list.SetTransObject(SQLCA)

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

/* 품목입력시 커서위치 여부 - '1' : 품번, '2' : 품명 */
select substr(dataname,1,1) into :sCursor
  from syscnfg
 where sysgu = 'S' and
       serial = 7 and
       lineno = 12;
Wf_Init()


end event

type dw_insert from w_inherite`dw_insert within w_sal_02045
integer x = 27
integer y = 284
integer width = 4526
integer height = 2028
integer taborder = 20
string dataobject = "d_sal_02045_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;Return 1
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

event dw_insert::itemchanged;String  sMsgParm[7] = {'품목마스타','일일환율','특정제품 할인율','거래처 할인율','정책 할인율','판매단가 없음','단가 = 0'}

String  sItem,sItemDsc,sItemSize,sItemUnit,sOrderDate,sSpecialYn,sItemGbn,sOrderSpec,&
		  sSuJuDate,snull
Double  dItemQty,dItemPrice,dDcRate,dValidQty,dNewDcRate,dItemWonPrc,dHoldQty
Integer nRow,iRtnValue,iRowCount
String  sOverSea,sDepotNo,sColNm

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow   = GetRow()
sColNm = GetColumnName() 

Choose Case sColNm
 Case	"itnbr" 
	sItem = this.GetText()
	IF sItem ="" OR IsNull(sItem) THEN
	  Wf_Clear_Item(nRow)
	  Return
	END IF
	
	SELECT "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC",   "ITEMAS"."UNMSR",		
			 "ITEMAS"."ITTYP"
	  INTO :sItemDsc,   		:sItemSize,   		  :sItemUnit,				
	       :sItemGbn
	  FROM "ITEMAS"
    WHERE "ITEMAS"."ITNBR" = :sItem AND
	       "ITEMAS"."USEYN" = '0' ;

	IF SQLCA.SQLCODE <> 0 THEN
		this.PostEvent(RbuttonDown!)
		Return 2
	END IF
	
	IF sItemGbn <>'9' THEN
		f_message_chk(58,'[품번]')
		Wf_Clear_Item(nRow)
		Return 1
	END IF

	this.SetItem(nRow,"itemas_itdsc",   sItemDsc)
	this.SetItem(nRow,"itemas_ispec",   sItemSize)

   /* 판매단가및 할인율 */
	iRtnValue = wf_calc_danga(nRow,sItem)
	If iRtnValue =  1 Then Return 1

/* 품명 */
 Case "itemas_itdsc"
	sItemDsc = trim(this.GetText())	
	IF sItemDsc = ""	or	IsNull(sItemDsc)	THEN
	  Wf_Clear_Item(nRow)
	END IF

	SELECT "ITEMAS"."ITNBR"
	  INTO :sItem
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITDSC" like :sItemDsc||'%' AND "ITEMAS"."GBWAN" = 'Y' AND
		  (  "ITEMAS"."ITTYP" = '9' );

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(nRow,"itnbr",sItem)
		this.SetColumn("itnbr")
		this.SetFocus()
		
		this.TriggerEvent(ItemChanged!)
		Return 1
	ELSEIF SQLCA.SQLCODE = 100 THEN
		Wf_Clear_Item(nRow)
		this.SetColumn("itemas_itdsc")
		Return 1
	ELSE
		Gs_CodeName = '품명'
		Gs_Code = sItemDsc
		Gs_gubun = '%'
		
		open(w_itemas_popup5)
		
		if Isnull(Gs_Code) OR Gs_Code = "" then 		return 1
		
		this.SetItem(nRow,"itnbr",Gs_Code)
		this.SetColumn("itnbr")
		this.SetFocus()
		
		this.TriggerEvent(ItemChanged!)
		Return 1
	END IF
/* 규격 */
 Case "itemas_ispec"
	sItemSize = trim(this.GetText())	
	IF sItemSize = ""	or	IsNull(sItemSize)	THEN
	  Wf_Clear_Item(nRow)
	  this.SetColumn("itemas_ispec")
	  Return
   End If

	SELECT "ITEMAS"."ITNBR"
	  INTO :sItem
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ISPEC" like :sItemSize||'%' AND "ITEMAS"."GBWAN" = 'Y' AND
		  ( "ITEMAS"."ITTYP" = '9' );
		 
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(nRow,"itnbr",sItem)
		this.SetColumn("itnbr")
		this.SetFocus()
		
		this.TriggerEvent(ItemChanged!)
		Return 1
	ELSEIF SQLCA.SQLCODE = 100 THEN
		Wf_Clear_Item(nRow)
		this.SetColumn("itemas_ispec")
		Return 1
	ELSE
		Gs_Code = sItemSize
		Gs_CodeName = '규격'
		Gs_gubun = '%'
		
		open(w_itemas_popup5)
		
		if Isnull(Gs_Code) OR Gs_Code = "" then 			return 1
		
		this.SetItem(nRow,"itnbr",Gs_Code)
		this.SetColumn("itnbr")
		this.SetFocus()
		
		this.TriggerEvent(ItemChanged!)
		Return 1
	END IF
Case 'pspec'
	sOrderSpec = Trim(this.GetText())
	IF sOrderSpec = "" OR IsNull(sOrderSpec) THEN
		this.SetItem(nRow,"pspec",'.')
		Return 2
	END IF
/* 수량 */
 Case "ioreqty"
	dItemQty = Double(this.GetText())
	IF dItemQty = 0 OR IsNull(dItemQty) THEN Return

	dItemPrice = this.GetItemNumber(nRow,"ioprc")
	IF dItemPrice = 0 Or IsNull(dItemPrice) THEN Return
	
	SetItem(nRow,"ioamt", TrunCate(dItemQty * dItemPrice,0))
//	SetItem(nRow,"dyebi3",TrunCate(dItemQty * dItemPrice * 0.1,0))	/* 부가세 */
/* 단가 */
 Case "ioprc"
	dItemPrice = Double(this.GetText())
   If dItemPrice = 0 Or IsNull(dItemPrice) Then Return

	/* 금액 계산 */
	dItemQty = this.GetItemNumber(nRow,"ioreqty")
	IF IsNull(dItemQty) THEN Return
	
	SetItem(nRow,"ioamt", TrunCate(dItemQty * dItemPrice, 0))
//	SetItem(nRow,"dyebi3",TrunCate(dItemQty * dItemPrice * 0.1, 0))	/* 부가세 */
	/* 단가 */
	Case "ioamt"
		dItemPrice = Double(this.GetText())
		If dItemPrice = 0 Or IsNull(dItemPrice) Then Return
		
//		SetItem(nRow,"dyebi3",TrunCate(dItemPrice * 0.1, 0))	/* 부가세 */
END Choose

end event

event dw_insert::rbuttondown;Integer nRow
string  scolnm

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

w_mdi_frame.sle_msg.text = ''

nRow     = GetRow()
If nRow <= 0 Then Return

sColNm   = GetColumnName()

Choose Case GetcolumnName() 
  Case "itnbr"
	 gs_gubun = '9'
	 Open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)	 
  Case "itemas_itdsc"
 	 gs_gubun = '9'
	 gs_codename = this.GetText()
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
  Case "itemas_ispec"
	 gs_gubun = '9'
	 open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	 SetColumn("itnbr")
	 SetItem(nRow,"itnbr",gs_code)
	 PostEvent(ItemChanged!)
END Choose

end event

event dw_insert::rowfocuschanged;If currentrow <= 0 Then return

If GetItemString(currentrow,'jnpcrt') = '024' Then
	P_del.Enabled = True
	p_del.PictureName = "c:\erpman\image\삭제_up.gif"
Else
	p_del.Enabled = False
	p_del.PictureName = "c:\erpman\image\삭제_d.gif"
End If

end event

event dw_insert::ue_pressenter;if this.getcolumnname() = "pspec" then
  if this.rowcount() = this.getrow() then
	  p_ins.postevent(clicked!)
	  return 1
  end if
end if
	
Send(Handle(this),256,9,0)
Return 1
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

type p_delrow from w_inherite`p_delrow within w_sal_02045
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_02045
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_02045
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_02045
integer x = 3749
integer height = 140
end type

event p_ins::clicked;call super::clicked;Long nRow

IF Wf_RequiredChk(1) = -1 THEN RETURN -1
IF Wf_RequiredChk(2) = -1 THEN RETURN -1

nRow = dw_insert.InsertRow(0)
dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)

If sCursor = '1' Then
  dw_insert.SetColumn('itnbr')
Else
  dw_insert.SetColumn('itemas_itdsc')
End If

// 구분 변경 불가
dw_cond.Object.area_cd.protect = '1'
end event

type p_exit from w_inherite`p_exit within w_sal_02045
end type

type p_can from w_inherite`p_can within w_sal_02045
end type

event p_can::clicked;call super::clicked;rollback;

Wf_Init()
end event

type p_print from w_inherite`p_print within w_sal_02045
boolean visible = false
integer x = 3401
integer y = 20
end type

event p_print::clicked;call super::clicked;Long  iRowCount

If rb_2.Checked = False   Then Return
IF Wf_RequiredChk(1) = -1 THEN Return

IF MessageBox("확 인","출고송장을 출력하시겠습니까?",Question!,YesNo!) = 1 THEN 
//	MessageBox(lssubuldate,lsiojpno)
	iRowCount = dw_list.Retrieve(gs_sabu,LsSuBulDate,'%','%','%',Lsiojpno+'%')
	
	If iRowCount > 0 Then
	  dw_list.object.datawindow.print.preview="yes"
	  gi_page = dw_list.GetItemNumber(1,"last_page")
	
	  OpenWithParm(w_print_options, dw_list)
   End If
END IF

end event

type p_inq from w_inherite`p_inq within w_sal_02045
integer x = 3575
integer y = 20
end type

event p_inq::clicked;call super::clicked;If dw_cond.AcceptText() <> 1 Then Return

IF Wf_RequiredChk(3) = -1 THEN RETURN

/*송장 수정*/
IF sModStatus = 'C' THEN
	IF dw_insert.Retrieve(gs_sabu,LsIoJpNo) <=0 THEN
		f_message_chk(50,'')
		dw_cond.Setfocus()
		Return
	ELSE
	   dw_insert.SetFocus()
	END IF
	dw_cond.Retrieve(gs_sabu,LsIoJpNo)
	dw_cond.Modify('iojpno.protect = 1')
//	dw_cond.Modify("iojpno.background.color = 80859087")
	
//	dw_cond.Modify('saupj.protect = 1')
//	dw_cond.Modify("saupj.background.color = 80859087")

	ib_any_typing = false
END IF
end event

type p_del from w_inherite`p_del within w_sal_02045
end type

event p_del::clicked;call super::clicked;Long nRow, iCnt
String sSudat

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

/* 매출마감시 송장 발행 안함 */
sSudat = dw_cond.GetItemString(1, 'sudat')

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if

IF MessageBox("삭 제","출고송장 자료가 삭제됩니다." +"~n~n" +&
           	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

Choose Case dw_insert.GetItemStatus(nRow,0,Primary!)
	Case New!,NewModified!
		dw_insert.DeleteRow(nRow)
	Case Else
		dw_insert.DeleteRow(nRow)
      If dw_insert.Update() <> 1 Then
        RollBack;
        Return
      End If
      Commit;
END CHOOSE

If dw_insert.RowCount() = 0 Then	p_can.TriggerEvent(Clicked!)
	
w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다.!!'
ib_any_typing = False

end event

type p_mod from w_inherite`p_mod within w_sal_02045
end type

event p_mod::clicked;call super::clicked;Int nRcnt, iCnt
String sSudat

IF Wf_RequiredChk(1) = -1 THEN RETURN -1
IF Wf_RequiredChk(2) = -1 THEN RETURN -1

/* 매출마감시 송장 발행 안함 */
sSudat = dw_cond.GetItemString(1, 'sudat')

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudat,1,6) )   ;

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
	
IF rb_1.Checked = True THEN
	nRcnt = Wf_Create_Imhist()
ELSE
	nRcnt = Wf_Add_Imhist()
END IF

/* 송장처리 완료된 경우 발행 여부에 따라 출고송장을 출력한다 => 출력은 송장발행에서 */
//If nRcnt > 0 Then
//  IF MessageBox("확 인","출고송장을 출력하시겠습니까?",Question!,YesNo!,2) = 1 THEN 
//     nRcnt = dw_list.Retrieve(gs_sabu,LsSuBulDate,'%','%','%',Lsiojpno+'%')
//	
//	  If nRcnt > 0 Then
//	    dw_list.object.datawindow.print.preview="yes"
//	    gi_page = dw_list.GetItemNumber(1,"last_page")
//	
//	    OpenWithParm(w_print_options, dw_list)
//     End If
//  End If
//END IF

wf_init()

w_mdi_frame.sle_msg.text = '자료를 처리하였습니다!!'

end event

type cb_exit from w_inherite`cb_exit within w_sal_02045
integer x = 3255
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_sal_02045
integer x = 2213
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_sal_02045
integer x = 3360
integer y = 5000
integer taborder = 40
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_02045
integer x = 2560
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_02045
integer x = 3008
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_sal_02045
integer x = 3936
integer y = 5000
integer width = 439
boolean enabled = false
string text = "송장출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_02045
end type

type cb_can from w_inherite`cb_can within w_sal_02045
integer x = 2907
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sal_02045
integer x = 992
integer y = 2676
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02045
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02045
end type

type gb_2 from groupbox within w_sal_02045
integer x = 2871
integer width = 366
integer height = 232
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rb_1 from radiobutton within w_sal_02045
integer x = 2926
integer y = 44
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등 록"
boolean checked = true
end type

event clicked;sModStatus = 'I'

Wf_Init()





end event

type rb_2 from radiobutton within w_sal_02045
integer x = 2926
integer y = 132
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수 정"
end type

event clicked;sModStatus = 'C'

Wf_Init()
end event

type dw_cond from u_key_enter within w_sal_02045
event ue_key pbm_dwnkey
integer x = 14
integer y = 4
integer width = 2880
integer height = 256
integer taborder = 10
string dataobject = "d_sal_02045_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
//ElseIf KeyDown(KeyEnter!) Then
//	If GetColumnName() = 'cvcod' Then
//		If dw_insert.rowcount() = 0 and rb_1.Checked = True Then
//		  p_ins.PostEvent(Clicked!)
//        Return 1
//	   End If
//	End If
END IF

end event

event itemerror;
Return 1
end event

event itemchanged;String  sIoJpNo,sSuDate, sIoConFirm,snull
String  sProject_no,sOrderCust, sProject_prjnm
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1

Int     icnt
SetNull(snull)

Choose Case GetColumnName()
	Case "iojpno"
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
		SELECT DISTINCT "IMHIST"."IO_CONFIRM"   INTO :sIoconFirm  
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND ( substr("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
				 ( "IMHIST"."JNPCRT" ='024');
		
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			p_inq.TriggerEvent(Clicked!)
		END IF
	Case "sudat"
		sSuDate = Trim(this.GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[발행일자]')
			this.SetItem(1,"sudat",snull)
			Return 1
		END IF
		
		/* 매출마감시 송장 발행 안함 */
		SELECT COUNT(*)  INTO :icnt
		 FROM "JUNPYO_CLOSING"  
		WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
				( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
				( "JUNPYO_CLOSING"."JPDAT" >= substr(:sSudate,1,6) );
		
		If iCnt >= 1 then
			f_message_chk(60,'[매출마감]')
			Return 1
		End if
	
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"vndname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"cust_area",   sarea)
			SetItem(1,"vndname",	scvnas)
		END IF
	/* 거래처명 */
	Case "vndname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'vndname', snull)
			Return 1
		ELSE
			SetItem(1,"cust_area",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"vndname", scvnas)
			Return 1
		END IF
	/* 프로젝트 */
	Case "project_no"
		sproject_no = Trim(GetText())
		IF sproject_no ="" OR IsNull(sproject_no) THEN
			this.SetItem(1,"prjnm",snull)
			Return
		END IF
		
		sOrderCust = GetItemString(1,'cvcod')
		SELECT "PROJECT"."PRJNM"  
		  INTO :sproject_prjnm  
		  FROM "PROJECT"  
		 WHERE ( "PROJECT"."PRJNO" = :sproject_no ) AND
				 ( "PROJECT"."CUST_NO" = :sOrderCust )   ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			This.TriggerEvent(rbuttondown!)
			return 2
		End If
		
		this.SetItem(1,"prjnm",sproject_prjnm)
End Choose

end event

event rbuttondown;SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName() 
	Case "iojpno"
		gs_codename = 'B'       /* 출고확인 전 */
		gs_gubun    = '024'  /* 전표생성 구분 */
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"iojpno",gs_code)
		p_inq.TriggerEvent(Clicked!)
	/* 거래처 */
	Case "cvcod", "vndname"
		gs_gubun = '1'
		If GetColumnName() = "vndname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from u_d_popup_sort within w_sal_02045
boolean visible = false
integer x = 1216
integer y = 2444
integer width = 823
integer height = 116
integer taborder = 0
boolean enabled = false
boolean titlebar = true
string title = "출고송장 "
string dataobject = "d_sal_02045_3"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

type pb_1 from u_pb_cal within w_sal_02045
integer x = 1970
integer y = 36
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('sudat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'sudat', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02045
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 280
integer width = 4590
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

