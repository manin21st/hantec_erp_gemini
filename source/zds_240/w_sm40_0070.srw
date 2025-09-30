$PBExportHeader$w_sm40_0070.srw
$PBExportComments$매출조정(단가소급,샘플출고)
forward
global type w_sm40_0070 from w_inherite
end type
type rr_2 from roundrectangle within w_sm40_0070
end type
type rb_insert from radiobutton within w_sm40_0070
end type
type rb_modify from radiobutton within w_sm40_0070
end type
type dw_1 from u_key_enter within w_sm40_0070
end type
type dw_print from datawindow within w_sm40_0070
end type
type dw_imhist from datawindow within w_sm40_0070
end type
type dw_hdn from datawindow within w_sm40_0070
end type
type cb_upload from commandbutton within w_sm40_0070
end type
type cb_down from commandbutton within w_sm40_0070
end type
type dw_form from datawindow within w_sm40_0070
end type
type rr_1 from roundrectangle within w_sm40_0070
end type
type rr_3 from roundrectangle within w_sm40_0070
end type
end forward

global type w_sm40_0070 from w_inherite
integer height = 2500
string title = "단가소급 등록"
rr_2 rr_2
rb_insert rb_insert
rb_modify rb_modify
dw_1 dw_1
dw_print dw_print
dw_imhist dw_imhist
dw_hdn dw_hdn
cb_upload cb_upload
cb_down cb_down
dw_form dw_form
rr_1 rr_1
rr_3 rr_3
end type
global w_sm40_0070 w_sm40_0070

type variables

String is_insemp        // 검사담당자
String is_iojpnoOK     //출고송장번호 필수여부
String isCursor 

end variables

forward prototypes
public subroutine wf_clear_item (integer icurrow)
public function integer wf_set_qc (integer nrow, string sitnbr)
public function integer wf_set_ip_jpno (integer nrow, string siojpno, string scvcodb, string saupj)
public function integer wf_create_imhist (string arg_iojpno)
public function integer wf_requiredchk (string sdwobject, integer icurrow)
public function integer wf_chk (integer nrow)
public subroutine wf_init ()
public function integer wf_create_imhist_oy4_after (long arg_row)
end prototypes

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

MessageBox('확인','해당 품번에 단가 정보가 없습니다.')

end subroutine

public function integer wf_set_qc (integer nrow, string sitnbr);/* 품번으로 검사담당자및 검사방법 Setting */
String sNull, sGu, sInsEmp, sQcGub

SetNull(sNull)

sGu = '1'
f_get_qc(sGu,sItnbr,sNull,sNull, sQcGub, sInsEmp )


dw_insert.SetItem(nRow,'insemp', sInsEmp )
dw_insert.SetItem(nRow,'qcgub', sQcGub )

Return 1

end function

public function integer wf_set_ip_jpno (integer nrow, string siojpno, string scvcodb, string saupj);Double dItemQty, dItemPrice, dDcRate, dVatAmt
String sCVcod, sItnbr, sNull
String sItemDsc, sItemSize, sItemUnit, sItemGbn, sItemUseYn, sItemFilsk, sItemitgu, sJijil, sIspecCode

SetNull(sNull)

/* 출고송장의 단가와 수량 */
select x.cvcod, x.itnbr, x.ioreqty, x.ioprc,     y.dc_rate,	x.dyebi3
  into :sCvcod, :sitnbr, :dItemQty, :dItemprice, :dDcRate,  :dVatAmt
  from imhist x, sorder y, iomatrix i
 where x.sabu = y.sabu and
       x.order_no = y.order_no and
		 x.sabu = i.sabu and
		 x.iogbn = i.iogbn and
		 i.salegu = 'Y' and
		 i.jepumio = 'Y' and
		 y.oversea_gu = '1' and
       x.sabu = :gs_sabu and
		 x.iojpno = :siojpno and
		 x.saupj = :saupj;

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

public function integer wf_create_imhist (string arg_iojpno);// 타계정 출고인 경우 생성


Return 1
end function

public function integer wf_requiredchk (string sdwobject, integer icurrow);String  sIoDate,sIoCust,sIoReDept,sIoReEmpNo,sIoDepotNo,sItem,sSpec,sBigo, sFac
String  sIojpNo, sIogbn, sQcGub, sInsEmp, sNull, sSaleGu , sSaupj ,sCvcod
String  ls_gubun , ls_bigo, sOutStore
		
Double  dQty,dPrc

If dw_1.AcceptText() < 1 Then Return -1
If dw_insert.AcceptText() < 1 Then Return -1

SetNull(sNull)

// 수불구분
ls_gubun =  String(dw_1.Object.gubun[1])

// 출고창고(대체인 경우)
sOutStore =  String(dw_1.Object.out_store[1])

Choose Case sdwobject
	Case 'd_sm40_0070_1'

		sIoDate    = Trim(dw_1.GetItemString(1,"sudat"))
		
		IF sIoDate = "" OR IsNull(sIoDate) THEN
			f_message_chk(30,'[일자]')
			dw_1.SetColumn("sudat")
			dw_1.SetFocus()
			Return -1
		END IF
		
		
		sSaupj = Trim(dw_1.GetItemString(1,'saupj'))
		If IsNull(sSaupj) or sSaupj = '' Then
			f_message_chk(30,'[사업장]')
			dw_1.SetColumn("saupj")
			Return -1
		End If
		
		sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
		If IsNull(sCvcod) or sCvcod = '.' Then
			f_message_chk(30,'[거래처]')
			dw_1.SetColumn("cvcod")
			Return -1
		End If

	
  	Case 'd_sm40_0070_a'
		Long i
				
		For i = 1 To iCurRow
			sItem    = Trim(dw_insert.GetItemString(iCurRow,"itnbr"))
			sFac     = Trim(dw_insert.GetItemString(iCurRow,"facgbn"))
		   dQty     = dw_insert.GetItemNumber(iCurRow,"ioreqty")
			dPrc     = dw_insert.GetItemNumber(iCurRow,"ioprc")
			
			dw_insert.SetFocus()
		
			IF sItem = "" OR IsNull(sItem) THEN
				f_message_chk(30,'[품번]')
				dw_insert.SetColumn("itnbr")
				Return -1
			END IF
			
			IF sFac = "" OR IsNull(sFac) THEN
				f_message_chk(30,'[공장]')
				dw_insert.SetColumn("facgbn")
				Return -1
			END IF

//			IF dQty = 0 OR IsNull(dQty) THEN
//				f_message_chk(30,'[수량]')
//				dw_insert.SetColumn("ioreqty")
//				Return -1
//			END IF
			
		 
			If ls_gubun = '3' Then
				ls_bigo   = Trim(dw_insert.GetItemString(iCurRow,"bigo"))
				IF ls_bigo = "" OR IsNull(ls_bigo) THEN
					f_message_chk(30,'[비고(단가소급 사유)]')
					dw_insert.SetColumn("bigo")
					Return -1
				END IF
			Else
				ls_bigo   = Trim(dw_insert.GetItemString(iCurRow,"bigo"))
				IF ls_bigo = "" OR IsNull(ls_bigo) THEN
					f_message_chk(30,'[비고(무상출고 사유)]')
					dw_insert.SetColumn("bigo")
					Return -1
				END IF
			End If
			
	   Next

END Choose

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
String ls_iogbn

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

public subroutine wf_init ();/* 등록 */
IF sModStatus = 'I' THEN
	dw_1.DataObject = 'd_sm40_0070_1'	
ELSE
/* 수정 */
	dw_1.DataObject = 'd_sm40_0070_2'
END IF

If rb_insert.Checked = True Then
	dw_insert.DataObject = 'd_sm40_0070_a'
Else
	dw_insert.DataObject = 'd_sm40_0070_b'
End If
dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(SQLCA)
dw_1.SetRedraw(False)
dw_1.Enabled = True
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetRedraw(True)
dw_1.SetItem(1,"sudat",is_today)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If
String sIogbn, ls_depot_no
sIogbn = Trim(dw_1.GetItemString(1,'gubun'))

SELECT cvcod  into :ls_depot_no
  From vndmst
 where cvgu = '5'
   and ipjogun = :gs_code
	and soguan = '1' 
	and jumaechul = '2';

dw_1.SetItem(1, 'depot_no', ls_depot_no)

If sIogbn = '3' Then
	dw_insert.Modify("iogbn.visible = 0 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 1 ")
	dw_insert.Modify("ioprc.protect = 0")
ElseIf  sIogbn = '5' Then
	dw_insert.Modify("iogbn.visible = 1 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 0 ")
	dw_insert.Modify("ioprc.protect = 1")
	
End If

dw_insert.Reset()

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

ib_any_typing = False

dw_1.SetFocus()

end subroutine

public function integer wf_create_imhist_oy4_after (long arg_row);// 불량반입인 경우 불량창고 이동 입출고 생성 - 2004.03.22 - 송병호

long		i, ll_maxjpno
string	ls_sudat, ls_saupj, ls_depot, ls_depot2, ls_iogbn, ls_iogbn1, ls_iogbn2, ls_jpno
string	ls_jnpcrt1, ls_jnpcrt2, ls_null

setnull(ls_null)
ls_sudat = Trim(dw_1.Object.sudat[1])
ls_saupj = Trim(dw_1.Object.saupj[1])

ls_depot 	= 'Z01'  // 제품 창고
ls_depot2	= 'Z99'  // 불량 창고

//ls_iogbn1 	= 'O05'	// 창고이동출고
//ls_jnpcrt1	= '001'

//2004. 06. 18 수정
ls_iogbn1 	= 'IX5'	// 창고이동출고
ls_jnpcrt1	= '038'

ls_iogbn2 	= 'I11'	// 창고이동입고
ls_jnpcrt2	= '038'	// 사외불량 반품 재검사용


ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,'C0')
IF ll_maxjpno <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
commit;

ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
IF ls_jpno = "" OR IsNull(ls_jpno) THEN
	f_message_chk(51,'[전표번호]')
	Return -1
End If



/////////////////////////////////////////////////////////////////////////////////////////
// 제품창고->불량창고 출고자료

i = dw_imhist.insertrow(0)

dw_imhist.SetItem(i,"sabu",       gs_sabu)
dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(i,'000'))
dw_imhist.SetItem(i,"iogbn",      ls_iogbn1)
dw_imhist.SetItem(i,"itnbr",      dw_insert.GetItemString(arg_row,'itnbr'))
dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
dw_imhist.SetItem(i,"pspec",   	'.')
dw_imhist.SetItem(i,"opseq",		'9999')
dw_imhist.SetItem(i,"depot_no",   'Z01')				// 제품창고
dw_imhist.SetItem(i,"cvcod",      'Z99')				// 불량창고
dw_imhist.SetItem(i,"io_confirm", 'Y')
dw_imhist.SetItem(i,"filsk",      dw_insert.GetItemString(arg_row,'itemas_filsk'))      // 재고관리유무
dw_imhist.SetItem(i,"ioredept",   gs_dept)
dw_imhist.SetItem(i,"ioreemp",    gs_empno)
dw_imhist.SetItem(i,"saupj",      ls_saupj)
dw_imhist.SetItem(i,"inpcnf", 	 'O')   					// 입출고구분(입고)
dw_imhist.SetItem(i,"outchk",		 'N')
dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt1)	
dw_imhist.SetItem(i,"bigo",	 	 dw_insert.GetItemString(arg_row,'bigo'))

dw_imhist.SetItem(i,"ioreqty",    dw_insert.GetItemNumber(arg_row,"ioreqty"))
dw_imhist.SetItem(i,"ioqty",      dw_insert.GetItemNumber(arg_row,"ioreqty"))
dw_imhist.SetItem(i,"insdat",     ls_sudat)                                  // 검수일자 
dw_imhist.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(arg_row,"ioreqty")) // 합격수량
dw_imhist.SetItem(i,"io_date",    ls_sudat)                                  // 승인일자
dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
dw_imhist.SetItem(i,"qcgub",'1')
dw_imhist.SetItem(i,"ip_jpno",	 dw_insert.GetItemString(arg_row,'iojpno'))	


/////////////////////////////////////////////////////////////////////////////////////////
// 제품창고->불량창고 입고자료

i = dw_imhist.insertrow(0)

dw_imhist.SetItem(i,"sabu",       gs_sabu)
dw_imhist.SetItem(i,"iojpno",     ls_jpno+String(i,'000'))
dw_imhist.SetItem(i,"iogbn",      ls_iogbn2)
dw_imhist.SetItem(i,"itnbr",      dw_insert.GetItemString(arg_row,'itnbr'))
dw_imhist.SetItem(i,"sudat", 		 ls_sudat)
dw_imhist.SetItem(i,"pspec",   	'.')
dw_imhist.SetItem(i,"opseq",		'9999')
dw_imhist.SetItem(i,"depot_no",   'Z99')				// 불량창고
dw_imhist.SetItem(i,"cvcod",      'Z01')				// 제품창고
dw_imhist.SetItem(i,"cust_no",    dw_insert.GetItemString(arg_row,'cvcod'))				// 거래처
dw_imhist.SetItem(i,"io_confirm", 'Y')
dw_imhist.SetItem(i,"filsk",      dw_insert.GetItemString(arg_row,'itemas_filsk'))      // 재고관리유무
dw_imhist.SetItem(i,"ioredept",   gs_dept)
dw_imhist.SetItem(i,"ioreemp",    gs_empno)
dw_imhist.SetItem(i,"saupj",      ls_saupj)
dw_imhist.SetItem(i,"inpcnf", 	 'I')   					// 입출고구분(입고)
dw_imhist.SetItem(i,"outchk",		 'N')
dw_imhist.SetItem(i,"jnpcrt",		 ls_jnpcrt2)
dw_imhist.SetItem(i,"bigo",	 	 dw_insert.GetItemString(arg_row,'bigo'))

dw_imhist.SetItem(i,"dyebi1",     dw_insert.GetItemNumber(arg_row,"ioprc"))
dw_imhist.SetItem(i,"dyebi2",     Truncate(dw_insert.GetItemNumber(arg_row,"ioreqty") * &
															 dw_insert.GetItemNumber(arg_row,"ioprc") , 0 ))

dw_imhist.SetItem(i,"ioreqty",    dw_insert.GetItemNumber(arg_row,"ioreqty"))
dw_imhist.SetItem(i,"ioqty",      0)
dw_imhist.SetItem(i,"insdat",     ls_null)                                  // 검수일자 
dw_imhist.SetItem(i,"iosuqty",    0) // 합격수량
dw_imhist.SetItem(i,"io_date",    ls_null)                                  // 승인일자
//	dw_imhist.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
dw_imhist.SetItem(i,"qcgub",'2')
dw_imhist.SetItem(i,"ip_jpno",	 dw_insert.GetItemString(arg_row,'iojpno'))
	

Return 1
end function

on w_sm40_0070.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_insert=create rb_insert
this.rb_modify=create rb_modify
this.dw_1=create dw_1
this.dw_print=create dw_print
this.dw_imhist=create dw_imhist
this.dw_hdn=create dw_hdn
this.cb_upload=create cb_upload
this.cb_down=create cb_down
this.dw_form=create dw_form
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_insert
this.Control[iCurrent+3]=this.rb_modify
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.dw_imhist
this.Control[iCurrent+7]=this.dw_hdn
this.Control[iCurrent+8]=this.cb_upload
this.Control[iCurrent+9]=this.cb_down
this.Control[iCurrent+10]=this.dw_form
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_3
end on

on w_sm40_0070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rb_insert)
destroy(this.rb_modify)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.dw_imhist)
destroy(this.dw_hdn)
destroy(this.cb_upload)
destroy(this.cb_down)
destroy(this.dw_form)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_print.SetTransObject(SQLCA)
dw_print.Reset()

dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()

dw_imhist.SetTransObject(SQLCA)

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

type dw_insert from w_inherite`dw_insert within w_sm40_0070
integer x = 23
integer y = 288
integer width = 4567
integer height = 2020
integer taborder = 20
string dataobject = "d_sm40_0070_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;
Return 1
end event

event dw_insert::itemchanged;String  sNull, sIogbn,sItnbrUnit, sIttyp, sItnbruseyn, sItnbrfilsk, sItnbritgu, sItnbrYn, sOrderSpec
String  sIocust, sIocustname, sIojpno, scvcod, ssaupj, sDate
Dec  dItemQty,dDcRate,dNewDcRate,dTemp
Double dItemPrice
Long    nRow,iRtnValue,nCnt
String  sItnbr, sItdsc, sIspec, sJijil, sispeccode, sIoSpec, sGubun, sTaitnbr ,ls_curr

SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

dw_1.AcceptText()
dw_insert.AcceptText()

Choose Case GetColumnName() 
	Case "itnbr"
		sItnbr = Trim(GetText())
		IF sItnbr ="" OR IsNull(sItnbr) THEN
			Wf_Clear_Item(nRow)
			Return
		END IF
		
		sGubun = dw_1.GetItemString(1, 'gubun')
		
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

			
//		   scvcod = Trim(dw_1.Object.cvcod[1])
//			
//			sDate = dw_1.GetItemString(1,"sudat")
//					
//			sqlca.Fun_Erp100000012_boogook(sdate,scvcod,sItnbr , '1' ,ditemprice , ls_curr) ;
//			//dItemPrice = sqlca.Fun_Erp100000012_1(sdate,scvcod,sItnbr , '1') 
//			
//			IF dItemPrice <= 0 THEN
//				SetItem(nRow,"ioprc",  0)
//				Wf_Clear_Item(nRow)
//				Return 1
//			Else
//				SetItem(nRow,"ioprc",  TrunCate(dItemPrice,2))
//			End If

			SetItem(nRow,"itemas_itdsc",   sItdsc)
			SetItem(nRow,"itemas_ispec",   sIspec)
			SetItem(nRow,"itemas_jijil",   sJijil)
			SetItem(nRow,"itemas_ispec_code",   sIspecCode)
			SetItem(nRow,"itemas_filsk",   sItnbrFilsk)
			SetItem(nRow,"itemas_itgu",    sItnbrItgu)			
		End If
	Case "ioreqty"
	   String ls_iogbn 
		Dec    ld_ioreqty
		ls_iogbn = Trim(dw_1.Object.gubun[1])
		ld_ioreqty = Dec(GetText())
		If ls_iogbn = '3' Then
			IF ld_ioreqty < 0 THEN
//				SetItem(nRow,"iogbn_temp2",   'OY6')
			ElseIf ld_ioreqty > 0 THEN
//				SetItem(nRow,"iogbn_temp2",   'OY5')
			Else
				MessageBox('확인','수량값이  없습니다.')
				Return 1
			END IF
		Else
			IF ld_ioreqty < 0 THEN
				MessageBox('확인','수량값이  없습니다.')
				Return 1
			End If
		End if
			
END Choose
end event

event dw_insert::rbuttondown;Long    nRow
String  sCvcod,sItnbr, sSaupj

long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
lrow = this.GetRow()

str_code lst_code
Long i , ll_i = 0

dw_1.AcceptText()
Choose Case GetcolumnName() 
	Case "itnbr"
	   gs_code = Trim(dw_1.Object.cvcod[1])
		gs_codename = Trim(dw_1.Object.cvnas[1])
		
		IF gs_code = '' Or isNull(gs_code) Then
			MessageBox('확인','거래처를 선택하세요')
			dw_insert.SetFocus()
			dw_insert.SetColumn("cvcod")
			Return
		End If
		
		Open(w_sm40_itemas_popup)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = lrow To UpperBound(lst_code.code) + lrow - 1
			ll_i++
			if i > row then p_ins.triggerevent("clicked")
			
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.SetItem(i,"itemas_itdsc",lst_code.codename[ll_i])
			
			this.SetItem(i,"facgbn",lst_code.sgubun1[ll_i])
			
			this.TriggerEvent("itemchanged")
			
		Next
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
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_insert::rowfocuschanging;
//If newrow <= 0 Then Return
//
//If wf_chk(newrow) = 0 Then
//	p_del.Enabled = True
//	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
//Else
//	p_del.Enabled = False
//	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
//End If

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

type p_delrow from w_inherite`p_delrow within w_sm40_0070
integer x = 4050
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sm40_0070
integer x = 3383
end type

event p_addrow::clicked;call super::clicked;Long ll_row ,ll_r , ll_fr
String sIoGbn, sNull, sDepotNo, sSaupj , sCvcod ,sFactory

SetNull(sNull)
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_insert.AcceptText() = -1 THEN RETURN

ll_r = dw_insert.RowCount()

If sModStatus = 'M' And ll_r < 1 Then 
	MessageBox('확인','등록상태일때 추가 가능합니다.')
	Return
End If

dw_1.SetFocus()

If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return

sIogbn = Trim(dw_1.GetItemString(1,'gubun'))
sSaupj = Trim(dw_1.GetItemString(1,'saupj'))
sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
sFactory = Trim(dw_1.GetItemString(1,'factory'))

ll_r = ll_r + 1
	
ll_row = dw_insert.InsertRow(ll_r)

If sIogbn = '3' Then
	dw_insert.Modify("iogbn.visible = 0 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 1 ")
	dw_insert.Modify("ioprc.protect = 0")
	dw_insert.Object.iogbn_temp2[ll_row] = sNull
ElseIf  sIogbn = '5' Then
	dw_insert.Modify("iogbn.visible = 1 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 0 ")
	dw_insert.Modify("ioprc.protect = 1")
	dw_insert.Object.iogbn[ll_row] = 'O18'
End If
	
dw_insert.AcceptText()
dw_insert.SetItem(ll_r,"cvcod",      sCvcod)
dw_insert.SetItem(ll_r,"facgbn",      sFactory)
dw_insert.ScrollToRow(ll_r)
dw_insert.SetColumn(1)
dw_insert.SetFocus()

dw_1.Enabled = False

end event

type p_search from w_inherite`p_search within w_sm40_0070
integer x = 3182
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sm40_0070
integer x = 3730
end type

event p_ins::clicked;call super::clicked;Long ll_row ,ll_r , ll_fr
String sIoGbn, sNull, sDepotNo, sSaupj , sCvcod ,sFactory

SetNull(sNull)
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_insert.AcceptText() = -1 THEN RETURN

ll_r = dw_insert.RowCount()

If sModStatus = 'M' And ll_r < 1 Then 
	MessageBox('확인','등록상태일때 추가 가능합니다.')
	Return
End If

dw_1.SetFocus()

If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return

sIogbn = Trim(dw_1.GetItemString(1,'gubun'))
sSaupj = Trim(dw_1.GetItemString(1,'saupj'))
sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
sFactory = Trim(dw_1.GetItemString(1,'factory'))

SetNull(gs_code)
SetNull(gs_codename)

gs_code = sCvcod
gs_codename = dw_1.GetItemString(1, 'depot_no')

Open(w_sm40_0070_pop)
If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

dw_hdn.ReSet()
dw_hdn.ImportClipboard()

Long   ll_cnt

ll_cnt = dw_hdn.RowCount()
If ll_cnt < 1 Then Return

Long   i
Long   ll_ins
String ls_chk
For i = 1 To ll_cnt
	ls_chk = dw_hdn.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ll_ins = dw_insert.InsertRow(0)
		dw_insert.SetItem(ll_ins, 'cvcod'       , dw_hdn.GetItemString(i, 'vndmrp_new_cvcod')  )
		
		If Trim(dw_hdn.GetItemString(i, 'vndmrp_new_factory')) = '' OR IsNull(dw_hdn.GetItemString(i, 'vndmrp_new_factory')) Then
			dw_insert.SetItem(ll_ins, 'facgbn', '.')
		Else
			dw_insert.SetItem(ll_ins, 'facgbn', dw_hdn.GetItemString(i, 'vndmrp_new_factory'))
		End If
		
		dw_insert.SetItem(ll_ins, 'itnbr'       , dw_hdn.GetItemString(i, 'vndmrp_new_itnbr')  )
		dw_insert.SetItem(ll_ins, 'itemas_itdsc', dw_hdn.GetItemString(i, 'itemas_itdsc')      )
		dw_insert.SetItem(ll_ins, 'bigo'        , '단가소급'                                   )
	End If
Next

//ll_r = ll_r + 1
//	
//ll_row = dw_insert.InsertRow(ll_r)
//
//If sIogbn = '3' Then
//	dw_insert.Modify("iogbn.visible = 0 ")
//	dw_insert.Modify("iogbn_temp1.visible = 0 ")
//	dw_insert.Modify("iogbn_temp2.visible = 1 ")
//	dw_insert.Modify("ioprc.protect = 0")
//	dw_insert.Object.iogbn_temp2[ll_row] = sNull
//ElseIf  sIogbn = '5' Then
//	dw_insert.Modify("iogbn.visible = 1 ")
//	dw_insert.Modify("iogbn_temp1.visible = 0 ")
//	dw_insert.Modify("iogbn_temp2.visible = 0 ")
//	dw_insert.Modify("ioprc.protect = 1")
//	dw_insert.Object.iogbn[ll_row] = 'O18'
//End If
//	
//dw_insert.AcceptText()
//dw_insert.SetItem(ll_r,"cvcod",      sCvcod)
//dw_insert.SetItem(ll_r,"facgbn",      sFactory)
//dw_insert.ScrollToRow(ll_r)
//dw_insert.SetColumn(1)
//dw_insert.SetFocus()
//
//dw_1.Enabled = False
//
end event

type p_exit from w_inherite`p_exit within w_sm40_0070
integer x = 4425
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm40_0070
integer x = 4251
end type

event p_can::clicked;call super::clicked;Wf_Init()
end event

type p_print from w_inherite`p_print within w_sm40_0070
boolean visible = false
integer x = 2903
integer y = 116
end type

event p_print::clicked;call super::clicked;//String  sIoJpNo, sDepotNo
//Integer iRowCount,iModCnt,iCurRow
//
//If dw_1.AcceptText() <> 1 Then return
//
//sIoJpNo = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
//IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
//	f_message_chk(30,'[의뢰번호]')
//	dw_1.SetColumn("iojpno")
//	dw_1.SetFocus()
//	Return 
//END IF
//
///* 영업 창고 */
//select min(cvcod )
//  into :sDepotNo
//  from vndmst
// where cvgu = '5' and
//       juhandle = '1' ;  
//
///* 저장위치는 영업창고를 우선으로 보여준다 */
//If sqlca.sqlcode <> 0 or IsNull(sDepotNo) Then
//	sDepotNo = dw_1.GetItemString(1,'depot_no')
//End If
//
//IF dw_print.Retrieve(gs_sabu,sIoJpNo, sDepotNo) > 0 THEN
//	dw_print.object.datawindow.print.preview="yes"
//	
//	gi_page = dw_print.GetItemNumber(1,"last_page")
//	OpenWithParm(w_print_options, dw_print)
//Else
//	f_message_chk(50,'')
//END IF

end event

type p_inq from w_inherite`p_inq within w_sm40_0070
integer x = 3557
end type

event p_inq::clicked;call super::clicked;String  sIoJpNo
Long    nCnt 
String  ls_gubun , ls_sudat , ls_saupj ,ls_cvcod , ls_cvnas, ls_depot

If dw_1.AcceptText() <> 1 Then 	Return

If rb_insert.Checked Then 
	MessageBox('확인','신규등록 상태에서는 조회 불가능 합니다.')
	Return
End If
ls_gubun = Trim(dw_1.GetItemString(1,"gubun"))
sIoJpNo  = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
IF sIoJpNo ="" OR IsNull(sIoJpNo) THEN
	f_message_chk(30,'[전표번호]')
	dw_1.SetColumn("iojpno")
	dw_1.SetFocus()
	Return 
END IF

Select a.sudat , a.saupj , a.cvcod ,b.cvnas, a.depot_no
  Into :ls_sudat , :ls_saupj ,:ls_cvcod ,:ls_cvnas, :ls_depot
  From IMHIST a , VNDMST b 
 Where a.cvcod = b.cvcod
 	And a.sabu = :gs_sabu
   And a.iojpno LIKE :sIoJpNo||'%'
	And rownum = 1 ;

If SQLCA.SQLCODE <> 0 Then
	MessageBox('확인','해당 전표번호를 찾을 수 없습니다.')
	Return
End If

dw_1.Object.sudat[1] = ls_sudat
dw_1.Object.saupj[1] = ls_saupj
dw_1.Object.cvcod[1] = ls_cvcod
dw_1.Object.cvnas[1] = ls_cvnas
dw_1.Object.depot_no[1] = ls_depot

If dw_insert.Retrieve(gs_sabu,sIoJpNo) > 0 THEN
   dw_insert.SetFocus()
	dw_1.Enabled = False
	ib_any_typing = False
ELSE
	wf_init()
	f_message_chk(50,'')
	dw_1.SetColumn("iojpno")
	dw_1.SetFocus()
	Return
END IF

/* 검사확인된것이 1건이상이면 추가불가  */
//If ls_gubun <> '1' Then  // 기타매출은 제외 
//
//	SELECT COUNT("IMHIST"."INSDAT")   INTO :nCnt
//	  FROM "IMHIST"  
//	  WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND
//			  ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
//			  ( "IMHIST"."JNPCRT" ='004') AND
//			  ( "IMHIST"."INSDAT" IS NOT NULL);
//	
//	If nCnt > 0 Then
//		p_ins.Enabled = False
//		p_ins.PictureName = "C:\erpman\image\추가_d.gif"
//	Else
//		p_ins.Enabled = True
//		p_ins.PictureName = "C:\erpman\image\추가_up.gif"
//	End If
//
//End If
end event

type p_del from w_inherite`p_del within w_sm40_0070
integer x = 3904
end type

event p_del::clicked;call super::clicked;Integer iCurRow, iCnt
Long    nCnt, nDel, ix
String sIosudate, sGubun, sIojpno, sSaupj

iCurRow = dw_insert.GetRow()
IF iCurRow <=0 THEN
	f_message_chk(36,'')
	Return
END IF

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

/* 매출마감시 송장 발행 안함 */
sIoSuDate = dw_1.GetItemString(1,"sudat")						/*의뢰일자*/

SELECT COUNT(*)  INTO :icnt
 FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:sIoSuDate,1,6) );

If iCnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if

IF F_Msg_Delete() = -1 THEN Return

sSaupj = dw_1.GetItemString(1, 'saupj')
sGubun = dw_1.GetItemString(1, 'gubun')

nCnt = dw_insert.RowCount()
nDel = 0
IF sModStatus = 'M' Then
	For ix = nCnt To 1 Step -1
		If dw_insert.GetItemString(ix, 'del') <> 'Y' Then Continue
		
		sIojpno = dw_insert.GetItemString(ix, 'iojpno')
		
	
		// 창고이동 전표 삭제
		IF sModStatus = 'M' And ( sGubun = '4' Or sGubun = '5' ) THEN
			DELETE FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND SAUPJ = :sSaupj;
			If SQLCA.SQLCODE <> 0 Then
				MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
				RollBack;
				Return
			End If
		End If

		// 창고이동 전표 삭제 - 불량반입인 경우 - 2004.03.24 - 송병호
		IF sModStatus = 'M' And sGubun = '2' THEN
			SELECT COUNT(*) INTO :iCnt FROM IMHIST
			 WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno 
			   AND SAUPJ = :sSaupj AND IOGBN = 'I11' AND JNPCRT = '038' AND INSDAT IS NOT NULL ;
			
			IF iCnt > 0 THEN
				MESSAGEBOX('확인','사외 불량 반품 재검사가 완료된 자료는 삭제할 수 없습니다.')
				dw_insert.SetItem(ix, 'del', 'N')
				CONTINUE
			END IF
			
			DELETE FROM IMHIST WHERE SABU = :gs_sabu AND IP_JPNO = :sIojpno AND SAUPJ = :sSaupj;
			If SQLCA.SQLCODE <> 0 Then
				MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
				RollBack;
				Return
			End If
		End If

		dw_insert.DeleteRow(ix)
		
		nDel += 1
	Next
/* 신규인 경우 삭제 2004.01.26 */
Else
	ix = dw_insert.GetRow()
	If ix > 0 Then
		dw_insert.DeleteRow(ix)
		nDel += 1
	End If
End If

If nDel > 0 Then
	IF sModStatus = 'M' THEN
		IF dw_insert.Update() <> 1 THEN
			ROLLBACK;
			Return
		END IF
		COMMIT;
		
		If dw_insert.RowCount() < 1 Then
			rb_insert.Checked = True
			rb_insert.TriggerEvent(Clicked!)
			Return
		End If
	END IF
	
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	
	w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'
End If

end event

type p_mod from w_inherite`p_mod within w_sm40_0070
integer x = 4078
end type

event p_mod::clicked;String ls_gubun , ls_sudat ,ls_saupj ,ls_cvcod , ls_itnbr ,ls_null , ls_factory
Long   ll_cnt ,ll_maxjpno ,ll_maxseq
String ls_junpo_gb ,ls_jpno ,ls_iogbn 
String ls_depot_no ,ls_iocnf ,ls_gumsu ,ls_new, sNull
Long   i ,ll_rcnt, dInseq, lRowHist 
Dec    ld_ioamt

String sIogubun, srcvcod, sHousegubun, stagbn, sqcgub, sTaOutJpno, sTaInjpno, sSaleyn, sIojpno, sJnpcrt

If dw_insert.RowCount() < 1 Then Return

If f_msg_update() < 1 Then Return

SetNull(ls_null)
SetNull(snull)
   
If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return
	
ls_gubun = Trim(dw_1.Object.gubun[1])
ls_sudat = Trim(dw_1.Object.sudat[1])
ls_saupj = Trim(dw_1.Object.saupj[1])
ls_cvcod = Trim(dw_1.Object.cvcod[1])
ls_factory = Trim(dw_1.Object.factory[1])
ls_depot_no = Trim(dw_1.Object.depot_no[1])

//ls_depot_no = 'Z011'  // 출고 창고 

//SELECT cvcod  into :ls_depot_no
//  From vndmst
// where cvgu = '5'
//   and ipjogun = :ls_saupj
//	and soguan = '1' 
//	and jumaechul = '2';



/* 매출마감 여부 체크  ========================================== */
SELECT COUNT(*)  INTO :ll_cnt
  FROM JUNPYO_CLOSING  
WHERE SABU = :gs_sabu 
   AND JPGU = 'G0' 
	AND JPDAT >= substr(:ls_sudat,1,6)  ;
		
If ll_cnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
//================================================================
	
// 창고별 자동처리 여부 검색 =========================================== 
SELECT VNDMST.HOMEPAGE
  INTO :ls_iocnf
  FROM VNDMST
 WHERE ( VNDMST.CVCOD = :ls_depot_no ) AND  ( VNDMST.CVGU = '5' );
	
If IsNull(ls_iocnf) or ls_iocnf = '' Then	ls_iocnf = 'N'
//======================================================================

// 거래처 검수구분 가겨오기 2003.10.29 ajh
	
SELECT NVL(GUMGU,'N') INTO :ls_gumsu
  FROM VNDMST 
 WHERE CVCOD = :ls_cvcod ;
	 
If SQLCA.SQLCODE <> 0 Then
	MessageBox('확인','거래처 검수 정보가 없습니다.')
	Return
End if
//====================================================

dw_imhist.Reset()

If ls_gubun = '5'  Then   // 기타출고 
	ll_rcnt = dw_insert.RowCount()
	If wf_requiredchk(dw_insert.DataObject,ll_rcnt) < 1 Then Return
	
	IF sModStatus = 'I' THEN   
		ls_junpo_gb = 'C0'
		ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
		IF ll_maxjpno <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			Return 1
		END IF
		commit;
		ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
		sJnpcrt = '001'
		
	
		dw_1.SetItem(1,"iojpno",ls_jpno)
		MessageBox("확 인","채번된 전표번호는 "+ls_jpno+" 번 입니다!!")
	ELSE
		ls_jpno = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
	END IF
	
	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
		f_message_chk(51,'[전표번호]')
		Return
	End If
	
	If ll_rcnt > 0 Then
	  ll_maxseq = Long(dw_insert.GetItemString(1,'maxseq'))
	  If IsNull(ll_maxseq) Then ll_maxseq = 0
	Else
		ll_maxseq = 0
	End If

	For i = 1 TO ll_rcnt
		
		ls_new = Trim(dw_insert.Object.is_new[i])
		
		If ls_new = 'Y' Then
			ll_maxseq += 1
		  	dw_insert.SetItem(i,"sabu",       gs_sabu)
			
			sIojpno = ls_jpno+String(ll_maxseq,'000')
		  	dw_insert.SetItem(i,"iojpno", sIojpno)
		End If
		
		dw_insert.SetItem(i,"iogbn", 		 'O17')
      dw_insert.SetItem(i,"sudat", 		 ls_sudat)
		dw_insert.SetItem(i,"cvcod",      ls_cvcod)
		dw_insert.SetItem(i,"depot_no",      ls_depot_no)
		dw_insert.SetItem(i,"facgbn",      dw_insert.GetItemString(i,'facgbn'))
		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
		
		dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
		dw_insert.SetItem(i,"ioamt",      Truncate(dw_insert.GetItemNumber(i,"ioreqty") * &
		                                           dw_insert.GetItemNumber(i,"ioprc") , 0 ))
		dw_insert.SetItem(i,"insdat",     ls_sudat)
		dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))
		dw_insert.SetItem(i,"io_confirm", ls_iocnf)
		dw_insert.SetItem(i,"io_date",    ls_sudat)
		dw_insert.SetItem(i,"filsk",      dw_insert.GetItemString(i,'itemas_filsk'))
		dw_insert.SetItem(i,"decisionyn", 'Y')
      
//		If ls_gumsu = 'Y' Then
//			dw_insert.SetItem(i,"yebi1",      ls_null)   // 검수하는 업체면 검수일자가 Null
//		Else
			dw_insert.SetItem(i,"yebi1",      ls_sudat)  // 검수하지 않는 업체이면 출고일자가 검수일자
//		End If
		
	   dw_insert.SetItem(i,"ioreemp",    gs_empno)
		dw_insert.SetItem(i,"saupj",      ls_saupj )
      dw_insert.SetItem(i,"inpcnf", 'O')   // 입출고구분(출고)
		dw_insert.SetItem(i,"botimh",'')
		dw_insert.SetItem(i,"outchk",'N')
		// 검수구분 
		dw_insert.SetItem(i,"qcgub",'1')
		dw_insert.SetItem(i,"jnpcrt", sJnpcrt)
		
		
	Next
//ElseIf ls_gubun = '2' Then // 반품  
//	
//	ll_rcnt = dw_insert.RowCount()
//	If wf_requiredchk(dw_insert.DataObject,ll_rcnt) < 1 Then Return
//
//	IF sModStatus = 'I' THEN   
//		ls_junpo_gb = 'C0'
//		ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
//		IF ll_maxjpno <= 0 THEN
//			f_message_chk(51,'')
//			ROLLBACK;
//			Return 1
//		END IF
//		commit;
//		ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
//		
//		dw_1.SetItem(1,"iojpno",ls_jpno)
//		MessageBox("확 인","채번된 전표번호는 "+ls_jpno+" 번 입니다!!")
//	ELSE
//		ls_jpno = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
//	END IF
//	
//	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
//		f_message_chk(51,'[전표번호]')
//		Return
//	End If
//	
//	If ll_rcnt > 0 Then	
//	  ll_maxseq = Long(dw_insert.GetItemString(1,'maxseq'))
//	  If IsNull(ll_maxseq) Then ll_maxseq = 0
//	Else
//		ll_maxseq = 0
//	End If
//	
//	For i = 1 TO ll_rcnt
//		
//		ls_new = Trim(dw_insert.Object.is_new[i])
//		ls_iogbn = dw_insert.GetItemString(i,'iogbn_temp1')
//		
//		If ls_new = 'Y' Then
//			ll_maxseq += 1
//		  	dw_insert.SetItem(i,"sabu",       gs_sabu)
//		  	dw_insert.SetItem(i,"iojpno",     ls_jpno+String(ll_maxseq,'000'))
//		End If
//		
//		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
//		
//		dw_insert.SetItem(i,"iogbn",      ls_iogbn)
//		dw_insert.SetItem(i,"sudat", 		 ls_sudat)
//		dw_insert.SetItem(i,"cvcod",      ls_cvcod)
//		dw_insert.SetItem(i,"ioamt",      Truncate(dw_insert.GetItemNumber(i,"ioreqty") * &
//		                                           dw_insert.GetItemNumber(i,"ioprc") , 0 ))
//		dw_insert.SetItem(i,"io_confirm", ls_iocnf)        // 자동처리유무 
//		dw_insert.SetItem(i,"filsk",      dw_insert.GetItemString(i,'itemas_filsk'))      // 재고관리유무
//		dw_insert.SetItem(i,"ioreemp",    gs_empno)
//		dw_insert.SetItem(i,"saupj",      ls_saupj )
//      dw_insert.SetItem(i,"inpcnf", 'I')   					// 입출고구분(입고)
//		dw_insert.SetItem(i,"botimh",'')
//		dw_insert.SetItem(i,"outchk",'N')
//	   dw_insert.SetItem(i,"jnpcrt",'004')
//		dw_insert.SetItem(i,"ioredept",gs_dept)
//	   dw_insert.SetItem(i,"ioreemp",gs_empno)
//		
//		
//		If ls_gumsu = 'N' Then
//			If ls_iogbn = 'OY3' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                  // 검수일자 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))      // 합격수량
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                  // 승인일자
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
//				dw_insert.SetItem(i,"yebi1",      ls_sudat)                                  // 검수일자 
//				dw_insert.SetItem(i,"qcgub",'1')
//				
//			// 불량반입도 검사완료 - 2004.03.24 - 송병호
//			ElseIf ls_iogbn = 'OY4' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty") )
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                   // 검수일자 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty") )     // 합격수량
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                   // 승인일자
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
//				dw_insert.SetItem(i,"yebi1",      ls_sudat)   											// 검수일자
//				dw_insert.SetItem(i,"qcgub",'1')
//				
//				// 불량창고 수불 - 2004.03.24 - 송병호
//				//if ls_new = 'Y' then wf_create_imhist_oy4_after(i)
//	      End If
//			
//		Else
//			If ls_iogbn = 'OY3' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                  // 검수일자 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))      // 합격수량
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                  // 승인일자
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
//				dw_insert.SetItem(i,"yebi1",      ls_null)                                   // 검수일자 
//				dw_insert.SetItem(i,"qcgub",'1')
//			ElseIf ls_iogbn = 'OY4' Then
//				dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
//				dw_insert.SetItem(i,"insdat",     ls_sudat)                                   // 검수일자 
//				dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))                                         // 합격수량
//				dw_insert.SetItem(i,"io_date",    ls_sudat)                                   // 승인일자
//				dw_insert.SetItem(i,"decisionyn", 'Y')                                       // 검사합불판정 
//				dw_insert.SetItem(i,"yebi1",      ls_sudat)                                   // 검수일자 
//				dw_insert.SetItem(i,"qcgub",'1')
//				
//				// 불량창고 수불 - 2004.03.24 - 송병호
//				//if ls_new = 'Y' then wf_create_imhist_oy4_after(i)
//	      End If
//		End If
//	Next
ElseIf ls_gubun = '3' Then // 단가 소급
	ll_rcnt = dw_insert.RowCount()
	If wf_requiredchk(dw_insert.DataObject,ll_rcnt) < 1 Then Return
	
	IF sModStatus = 'I' THEN   
		ls_junpo_gb = 'C0'
		ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
		IF ll_maxjpno <= 0 THEN
			f_message_chk(51,'')
			ROLLBACK;
			Return 1
		END IF
		commit;
		ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
		
		dw_1.SetItem(1,"iojpno",ls_jpno)
		MessageBox("확 인","채번된 전표번호는 "+ls_jpno+" 번 입니다!!")
	ELSE
		ls_jpno = Mid(dw_1.GetItemString(1,"iojpno"),1,12)
	END IF
	
	IF ls_jpno = "" OR IsNull(ls_jpno) THEN
		f_message_chk(51,'[전표번호]')
		Return
	End If
	
	If ll_rcnt > 0 Then	
	  ll_maxseq = Long(dw_insert.GetItemString(1,'maxseq'))
	  If IsNull(ll_maxseq) Then ll_maxseq = 0
	Else
		ll_maxseq = 0
	End If
	
	For i = 1 TO ll_rcnt
		
		ls_new   = Trim(dw_insert.Object.is_new[i])
		ls_iogbn = dw_insert.GetItemString(i,'iogbn_temp2')
//		ld_ioamt = dw_insert.GetItemDecimal(i,'c_ioamt')
		ld_ioamt = dw_insert.GetItemDecimal(i,'ioamt')
		If IsNull(ld_ioamt) Then ld_ioamt = 0
	   
		If ls_new = 'Y' Then
			ll_maxseq += 1
		  	dw_insert.SetItem(i,"sabu",       gs_sabu)
		  	dw_insert.SetItem(i,"iojpno",     ls_jpno+String(ll_maxseq,'000'))
		End If
		
	 	If ld_ioamt < 0 Then
//			dw_insert.SetItem(i,"iogbn", 		 'OY6')
		ElseIf ld_ioamt > 0 Then
//			dw_insert.SetItem(i,"iogbn", 		 'OY5')
		Else
			MessageBox('확인','단가 소급금액이 없습니다.')
			dw_insert.SetFocus()
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn("ioprc")
			Return
		End If
		
		dw_insert.SetItem(i,"iogbn", 		 'OY3')	// 단가소급 수불구분-2006.12.20

      dw_insert.SetItem(i,"sudat", 		 ls_sudat)
		dw_insert.SetItem(i,"cvcod",      ls_cvcod)
		dw_insert.SetItem(i,"depot_no",      ls_depot_no)
		
		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
		
		dw_insert.SetItem(i,"ioqty",      dw_insert.GetItemNumber(i,"ioreqty"))
		dw_insert.SetItem(i,"ioamt",      ld_ioamt)
//		dw_insert.SetItem(i,"ioamt",      Truncate(dw_insert.GetItemNumber(i,"ioreqty") * &
//		                                           dw_insert.GetItemNumber(i,"ioprc") , 0 ))
		dw_insert.SetItem(i,"insdat",     ls_sudat)
		dw_insert.SetItem(i,"iosuqty",    dw_insert.GetItemNumber(i,"ioreqty"))
		dw_insert.SetItem(i,"io_confirm", ls_iocnf)
		dw_insert.SetItem(i,"io_date",    ls_sudat)
		dw_insert.SetItem(i,"filsk",      'N')
		dw_insert.SetItem(i,"decisionyn", 'Y')
      dw_insert.SetItem(i,"yebi1",      ls_sudat)
		
	   dw_insert.SetItem(i,"ioreemp",    gs_empno)
		dw_insert.SetItem(i,"saupj",      ls_saupj )
		dw_insert.SetItem(i,"facgbn",      dw_insert.GetItemString(i,'facgbn'))
//		dw_insert.SetItem(i,"facgbn",      ls_factory )
		
		dw_insert.SetItem(i,"inpcnf", 'O')
//		If ls_iogbn = 'OY5' Then
//      	dw_insert.SetItem(i,"inpcnf", 'O')   // 입출고구분
//		Else
//			dw_insert.SetItem(i,"inpcnf", 'I')   // 입출고구분(출고)
//		End If
		
		dw_insert.SetItem(i,"botimh",'')
		dw_insert.SetItem(i,"outchk",'N')
		dw_insert.SetItem(i,"qcgub",'1')
		dw_insert.SetItem(i,"jnpcrt",'036')
	Next
END IF

dw_insert.AcceptText()
IF dw_insert.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

IF dw_imhist.Update() <> 1 THEN
	ROLLBACK;
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
//
//If sModStatus = 'I' Then
//	rb_modify.Checked = True
//	rb_modify.TriggerEvent(Clicked!)
//	dw_1.Object.gubun[1] = ls_gubun
//	dw_1.Object.iojpno[1] = ls_jpno
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//

rb_insert.Checked = True
rb_insert.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm40_0070
integer x = 4306
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_sm40_0070
integer x = 3264
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_sm40_0070
integer x = 3616
integer y = 5000
integer taborder = 40
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sm40_0070
integer x = 3611
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sm40_0070
integer x = 3269
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_sm40_0070
integer x = 3963
integer y = 5000
integer width = 626
string text = "반품의뢰서출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_sm40_0070
end type

type cb_can from w_inherite`cb_can within w_sm40_0070
integer x = 3959
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_sm40_0070
integer x = 2171
integer y = 2448
end type







type gb_button1 from w_inherite`gb_button1 within w_sm40_0070
end type

type gb_button2 from w_inherite`gb_button2 within w_sm40_0070
end type

type rr_2 from roundrectangle within w_sm40_0070
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3872
integer y = 216
integer width = 741
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_insert from radiobutton within w_sm40_0070
integer x = 82
integer y = 44
integer width = 261
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
string text = "등록"
boolean checked = true
end type

event clicked;sModStatus = 'I'											/*등록*/

Wf_Init()

end event

type rb_modify from radiobutton within w_sm40_0070
integer x = 82
integer y = 128
integer width = 261
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
string text = "수정"
end type

event clicked;sModStatus = 'M'											/*수정*/

Wf_Init()
end event

type dw_1 from u_key_enter within w_sm40_0070
event ue_key pbm_dwnkey
integer x = 407
integer y = 12
integer width = 2967
integer height = 240
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sm40_0070_1"
boolean border = false
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
String  sGubun
SetNull(snull)

Choose Case this.GetColumnName()
	/*구분 */
	Case  "gubun" 
		sGubun = this.GetText()
		IF sGubun = "" OR IsNull(sGubun) THEN RETURN
		
		dw_1.Object.iojpno[1] = snull
//		dw_1.Object.sudat[1] = is_today
//		dw_1.Object.saupj[1] = snull
		dw_1.Object.cvcod[1] = snull
		dw_1.Object.cvnas[1] = snull
	   
		// 정상출고,원자재출고,as대체출고
		If sGubun = '1' Or sGubun = '4' Or sGubun = '5'  then
			dw_insert.Reset()
			dw_insert.Modify("iogbn.visible = 1 ")
			dw_insert.Modify("iogbn_temp1.visible = 0 ")
			dw_insert.Modify("iogbn_temp2.visible = 0 ")
			dw_insert.Modify("ioprc.protect = 1")
//		ElseIf sGubun = '2' then
//			dw_insert.Reset()
//			dw_insert.Modify("iogbn.visible = 0 ")
//			dw_insert.Modify("iogbn_temp1.visible = 1 ")
//			dw_insert.Modify("iogbn_temp2.visible = 0 ")
//			dw_insert.Modify("ioprc.protect = 1")
		ElseIf sGubun = '3' then
			dw_insert.Reset()
			dw_insert.Modify("iogbn.visible = 0 ")
			dw_insert.Modify("iogbn_temp1.visible = 0 ")
			dw_insert.Modify("iogbn_temp2.visible = 1 ")
			dw_insert.Modify("ioprc.protect = 0")
		End If
		
		If rb_insert.Checked = True Then
			dw_insert.DataObject = 'd_sm40_0070_a'
		Else
			dw_insert.DataObject = 'd_sm40_0070_b'
		End If
		
		dw_insert.SetTransObject(sqlca)
	/* 반품의뢰번호 */
	Case  "iojpno" 
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
		
	  /* 검사확인 */
		SELECT DISTINCT "IMHIST"."INSDAT"   INTO :sInsDat
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
				 ( "IMHIST"."IOJPNO" LIKE :sIoJpNo||'%' ) AND
				 ( "IMHIST"."JNPCRT" ='005') AND
				 ( "IMHIST"."INV_NO" IS NULL );
	
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
		
	Case "factory"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust) or sIoCust = '.' THEN
			this.SetItem(1,"factory",snull)
			this.SetItem(1,"cvcod",  snull)
			this.SetItem(1,"cvnas",  snull)
			Return 1
		END IF
		
		Select rfna2 , fun_get_cvnas( rfna2 ) INTO :sIoCustName,	:sIoCustArea
	    From reffpf
		Where rfcod = '2A'
		  and rfgub = :sIoCust ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			this.SetItem(1,"factory",  snull)
			this.SetItem(1,"cvcod",  snull)
			this.SetItem(1,"cvnas",  snull)
		 return 1
		ELSE
			this.SetItem(1,"cvcod",  sIoCustName)
			this.SetItem(1,"cvnas",  sIoCustArea)
		END IF
	
	/* 반품처 */
	Case "cvcod"
		sIoCust = Trim(GetText())
		IF sIoCust ="" OR IsNull(sIoCust)  THEN
			this.SetItem(1,"cvnas",snull)
			Return 1
		END IF
		
		SELECT "VNDMST"."CVNAS2","VNDMST"."SAREA"		
		  INTO :sIoCustName,	:sIoCustArea
		  FROM "VNDMST"  
		WHERE "VNDMST"."CVCOD" = :sIoCust   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
		 return 1
		ELSE
			this.SetItem(1,"cvnas",  sIoCustName)
		END IF
	/* 반품처명 */
	Case "cvnas" 
		sIoCustName = Trim(GetText())
		IF sIoCustName ="" OR IsNull(sIoCustName) THEN
			this.SetItem(1,"cvcod",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD","VNDMST"."SAREA"		INTO :sIoCust,	:sIoCustArea
		  FROM "VNDMST"  
		WHERE "VNDMST"."CVNAS2" = :sIoCustName   ;
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RbuttonDown!)
			Return 2
		ELSE
			this.SetItem(1,"cvcod",    sIoCust)
		END IF

END Choose

end event

event editchanged;ib_any_typing = True
end event

event rbuttondown;String sDeptName,sNull, sIoGbn
String ls_gubun

SetNull(sNull)
SetNull(Gs_Code)
SetNull(Gs_gubun)
SetNull(Gs_CodeName)

AcceptText()

Choose Case GetColumnName()
	/* 의뢰번호 */
	Case "iojpno" 
		gs_gubun = Trim(This.Object.gubun[1])
		
		Open(w_sm04_00050_popup01)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
		SetItem(1,"iojpno",Left(gs_code,12))
		p_inq.PostEvent(Clicked!)

	/* 반품처 */
	Case "cvcod" , "cvnas"

		If GetColumnName() = 'cvnas' Then
			gs_codename = Trim(GetText())
		End If
		
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetItem(1,"cvnas",gs_codename)
		TriggerEvent("itemChanged")
END Choose

ib_any_typing = True
end event

event itemfocuschanged;IF this.GetColumnName() = "cvnas" Then
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type dw_print from datawindow within w_sm40_0070
boolean visible = false
integer x = 3909
integer y = 232
integer width = 654
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "반품의뢰서"
string dataobject = "d_sal_020503"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_imhist from datawindow within w_sm40_0070
boolean visible = false
integer x = 3296
integer y = 196
integer width = 475
integer height = 116
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_imhist"
boolean border = false
boolean livescroll = true
end type

type dw_hdn from datawindow within w_sm40_0070
boolean visible = false
integer x = 3849
integer y = 1836
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm40_0070_pop_002"
boolean border = false
boolean livescroll = true
end type

type cb_upload from commandbutton within w_sm40_0070
integer x = 3383
integer y = 172
integer width = 347
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
string text = "UPLOAD"
end type

event clicked;Long ll_row ,ll_r , ll_fr
String sIoGbn, sNull, sDepotNo, sSaupj , sCvcod

String ls_itnbr, ls_factory, ls_iogbn, ls_bigo
Long ll_ioamt

SetNull(sNull)
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_insert.AcceptText() = -1 THEN RETURN

ll_row = dw_insert.RowCount()

If sModStatus = 'M' And ll_row < 1 Then 
	MessageBox('확인','등록상태일때 추가 가능합니다.')
	Return
End If

dw_1.SetFocus()

If wf_requiredchk(dw_1.DataObject,1) < 1 Then Return

sIogbn = Trim(dw_1.GetItemString(1,'gubun'))
sSaupj = Trim(dw_1.GetItemString(1,'saupj'))
sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))

If sIogbn = '3' Then
	dw_insert.Modify("iogbn.visible = 0 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 1 ")
	dw_insert.Modify("ioprc.protect = 0")
	ls_iogbn = sNull
ElseIf  sIogbn = '5' Then
	dw_insert.Modify("iogbn.visible = 1 ")
	dw_insert.Modify("iogbn_temp1.visible = 0 ")
	dw_insert.Modify("iogbn_temp2.visible = 0 ")
	dw_insert.Modify("ioprc.protect = 1")
	ls_iogbn = 'O18'
End If


/* File 선택 */
Long   ll_value
String ls_docname
String ls_named

ll_value = GetFileOpenName("Upload Data 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

dw_insert.Reset()
w_mdi_frame.sle_msg.text =''

Setpointer(Hourglass!)

If FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If

/* Excel Import */
uo_xlobject uo_xl

//UserObject 생성
uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, False , 3)

uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting
Long   ll_xl_row, ll_chk, i

ll_xl_row = 2

Do While(True)
	
	//Data가 없을경우엔 Return...........
	If IsNull(uo_xl.uf_gettext(ll_xl_row, 1)) Or Trim(uo_xl.uf_gettext(ll_xl_row, 1)) = '' Then Exit
	
	ll_r = dw_insert.InsertRow(0)
	dw_insert.Scrolltorow(ll_r)
	
	//사용자 ID(A,1)
	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i = 1 To 30
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))		
	Next
	
	ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 1))
	ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row, 2))
	ll_ioamt = Dec(Trim(uo_xl.uf_gettext(ll_xl_row, 3)))
	ls_bigo = Trim(uo_xl.uf_gettext(ll_xl_row, 4))
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM ITEMAS
	 WHERE ITNBR = :ls_itnbr ;
	 
	If ll_chk < 1 Then
		MessageBox('미 등록된 품번', ls_itnbr + ' 은(는) 미 등록된 품번입니다.~r~r~nExcel Importing을 취소합니다.')
		uo_xl.uf_excel_Disconnect()
		DESTROY uo_xlobject
		dw_insert.ReSet()
		dw_insert.SetTransObject(SQLCA)
		Return
	End If
	
	SetNull(ll_chk)
		
	dw_insert.object.cvcod[ll_r]   = sCvcod
	dw_insert.object.itnbr[ll_r]   = ls_itnbr
	dw_insert.TriggerEvent("itemchanged")
	dw_insert.Object.iogbn[ll_r] = ls_iogbn
	dw_insert.Object.facgbn[ll_r] = ls_factory
	dw_insert.Object.facgbn_1[ll_r] = ls_factory
	dw_insert.object.ioamt[ll_r]   = ll_ioamt
	dw_insert.object.bigo[ll_r] = ls_bigo
	
	ll_xl_row ++
	
Loop

uo_xl.uf_excel_Disconnect()
DESTROY uo_xlobject

dw_insert.AcceptText()

dw_insert.ScrollToRow(ll_r)
dw_insert.SetColumn(1)
dw_insert.SetFocus()

dw_1.Enabled = False
end event

type cb_down from commandbutton within w_sm40_0070
integer x = 3744
integer y = 172
integer width = 347
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
string text = "DOWN"
end type

event clicked;String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

dw_form.InsertRow(0)

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(dw_form,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type dw_form from datawindow within w_sm40_0070
boolean visible = false
integer x = 3845
integer y = 1372
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm40_0070_form"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sm40_0070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 280
integer width = 4590
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm40_0070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 375
integer height = 236
integer cornerheight = 40
integer cornerwidth = 55
end type

