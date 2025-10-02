$PBExportHeader$w_sal_06220.srw
$PBExportComments$ASN 등록-new
forward
global type w_sal_06220 from w_inherite
end type
type pb_1 from u_pic_cal within w_sal_06220
end type
type pb_2 from u_pic_cal within w_sal_06220
end type
type dw_list from datawindow within w_sal_06220
end type
type rr_2 from roundrectangle within w_sal_06220
end type
end forward

global type w_sal_06220 from w_inherite
integer width = 4722
integer height = 3596
string title = "ASN 등록"
pb_1 pb_1
pb_2 pb_2
dw_list dw_list
rr_2 rr_2
end type
global w_sal_06220 w_sal_06220

type variables
string snull
end variables

forward prototypes
public function integer wf_catch_danga (integer nrow, string itnbr, string sorderspec, long ditemqty)
public function integer wf_clear_item (integer nrow)
public function integer wf_copy_last_buyer (string arg_cvcod)
end prototypes

public function integer wf_catch_danga (integer nrow, string itnbr, string sorderspec, long ditemqty);string sOrderDate, sCvcod, sCurr, sPriceGbn, sSaleGu
int 	 irow, iRtnValue = -1
Double dItemPrice, dDcRate, dQtyPrice, dQtyRate

iRow = dw_insert.RowCount()
If iRow <=0 Then Return -1

sOrderDate = dw_insert.GetItemString(iRow,'sudat')
sCvcod  = dw_input.GetItemString(1,'cvcod')
sCurr   = 'USD'

If IsNull(sOrderDate) Or sOrderDate = '' Then
   //f_message_chk(40,'[발행일]')
   Return 2
End If
If IsNull(sCvcod) Or sCvcod = '' Then
   //f_message_chk(40,'[Buyer]')
   Return 2
End If


sPriceGbn  = '2'  //외화


/* 수량이 0이상일 경우 수량base단가,할인율을 구한다 */
If dItemQty > 0 Then
	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, Itnbr, dItemQty, &
                                      sCurr, dQtyPrice, dQtyRate) 
End If
If IsNull(dQtyPrice) Then dQtyPrice = 0
If IsNull(dQtyRate)	Then dQtyRate = 0

/* 판매 기본단가,할인율를 구한다 */
iRtnValue  = sqlca.Fun_Erp100000016( gs_sabu, sOrderDate, sCvcod,     Itnbr, sOrderSpec,&
												 sCurr,    sPriceGbn,  dItemPrice, dDcRate) 

/* 특출단가나 거래처단가일경우 수량별 할인율은 적용안함 */
If iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0

/* 수량별 할인율이 있을 경우 단가를 다시 계산한다 */
If dQtyRate <> 0 Then
	dDcRate += dQtyRate
   iRtnValue = sqlca.fun_erp100000015(itnbr, sOrderSpec, sOrderSpec, sCurr, sPriceGbn, dDcRate, dItemPrice)
End If
												
If IsNull(dItemPrice) Then dItemPrice = 0.0
If IsNull(dDcRate)  Then dDcRate = 0.0

Choose Case iRtnValue
	Case IS < 0 
		f_message_chk(41,'[단가 계산]'+string(irtnvalue))
		Return 1
	Case Else
		dw_insert.SetItem(nRow,"ioprc",	dItemPrice)
End Choose

return 0
end function

public function integer wf_clear_item (integer nrow);//String sNull
dec    dNull

SetNull(snull)
SetNull(dnull)

//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itnbr",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itdsc",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ispec",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ispec_code",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"jijil",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"order_spec",'.')
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itemas_unmsr",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piqty",dNull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"dc_rate",dNull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piprc",dNull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piamt",dNull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"cust_napgi",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"pre_napgi",snull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"seqno",dNull)
//tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itemno",dNull)

Return 1
end function

public function integer wf_copy_last_buyer (string arg_cvcod);String sAsnno, sSudat, sItnbr, sCvcod, sShipper, sBill_to,sCvnas
Long   nRow

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return -1

/* Buyer의 기본정보를 가져온다 */

  SELECT "EXPASN_HAN"."ASNNO",         "EXPASN_HAN"."SUDAT",   
         	"EXPASN_HAN"."ITNBR",        "EXPASN_HAN"."CVCOD",  "VNDMST"."CVNAS",
			"EXPASN_HAN"."SHIPPER"  ,   "EXPASN_HAN"."BILL_TO"
    INTO :sAsnno,                     :sSudat,   
	      	:sItnbr,                    :sCvcod,   :sCvnas,
			:sShipper, 	   :sBill_to
    FROM "EXPASN_HAN" , "VNDMST" 
   WHERE "EXPASN_HAN"."CVCOD" = "VNDMST"."CVCOD"
	AND	"EXPASN_HAN"."ASNNO"  = ( SELECT MAX("EXPASN_HAN"."ASNNO") 
			                          FROM "EXPASN_HAN" 
								               WHERE "EXPASN_HAN"."CVCOD" = :arg_Cvcod AND
															"EXPASN_HAN"."SUDAT" = ( SELECT MAX("EXPASN_HAN"."SUDAT") 
															                        FROM "EXPASN_HAN"
																							WHERE "EXPASN_HAN"."CVCOD" = :arg_Cvcod )) ;
																							
dw_insert.SetItem(nRow,'cvcod',sCvcod)
dw_insert.SetItem(nRow,'cvnas',sCvnas)
dw_insert.SetItem(nRow,'shipper',sShipper)
dw_insert.SetItem(nRow,'bill_to',sBill_to)

Return 1
end function

on w_sal_06220.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_list=create dw_list
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.rr_2
end on

on w_sal_06220.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_list)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_input.InsertRow(0)
TriggerEvent('ue_open')


end event

event ue_open;call super::ue_open;string sSdate

ib_any_typing =False

sSdate = left(f_today(),6)+'01'

dw_input.SetItem(1,'sdate', sSdate)
dw_input.SetItem(1,'edate', f_today())


cb_inq.Post PostEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sal_06220
integer x = 2569
integer y = 2612
end type

type sle_msg from w_inherite`sle_msg within w_sal_06220
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06220
end type

type st_1 from w_inherite`st_1 within w_sal_06220
end type

type p_search from w_inherite`p_search within w_sal_06220
integer x = 1001
integer y = 2604
end type

type p_addrow from w_inherite`p_addrow within w_sal_06220
integer x = 1358
integer y = 2588
end type

type p_delrow from w_inherite`p_delrow within w_sal_06220
integer x = 1531
integer y = 2588
end type

type p_mod from w_inherite`p_mod within w_sal_06220
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.update() = 1 then
	sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
	MessageBox('확 인','저장되었습니다.!!')
	
	p_inq.Post PostEvent(Clicked!)
else
	rollback ;
	return 
end if

end event

type p_del from w_inherite`p_del within w_sal_06220
end type

event p_del::clicked;call super::clicked;/*-------------------------*/
/* 통화 개별 단위 삭제     */
/*-------------------------*/

string sdate,scurr
int    row

IF dw_input.AcceptText() = -1 THEN Return

sdate = Trim(dw_input.GetItemString(1, 'sdate'))

If dw_insert.RowCount() > 0 Then
	row   = dw_insert.GetRow()
   IF MessageBox("삭 제","선택 된 행의 데이터가 삭제 됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.DeleteRow(row)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"자료를 삭제하였습니다!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
   cb_inq.PostEvent(Clicked!)
End If

end event

type p_inq from w_inherite`p_inq within w_sal_06220
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string sdate, edate, cvcod

IF dw_input.AcceptText() = -1 THEN Return

sdate = Trim(dw_input.GetItemString(1, 'sdate'))
edate = Trim(dw_input.GetItemString(1, 'edate'))
cvcod = Trim(dw_input.GetItemString(1, 'cvcod'))

If sdate = '' Or IsNull(sdate) Then Return
If edate = '' Or IsNull(edate) Then Return
If cvcod = '' Or IsNull(cvcod) Then 
	f_message_chk(40,'[거래처]')
	Return
End if

If f_datechk(sdate) = -1 Then
   f_message_chk(40,'[일자/ 오류]')
	dw_input.SetFocus()
	Return
End If

If f_datechk(edate) = -1 Then
   f_message_chk(40,'[일자/ 오류]')
	dw_input.SetFocus()
	Return
End If

If sdate > edate Then
	MessageBox('기간확인', '종료일이 시작일 보다 빠릅니다.')
	dw_input.SetColumn('edate')
	dw_input.SetFocus()
	Return -1
End If


If dw_list.Retrieve(sdate, edate, cvcod) > 0 Then	
	dw_input.Enabled = true
Else
	f_message_Chk(300, '')
	sle_msg.Text = '조회된 건수가 없습니다.!!'
End If



end event

type p_print from w_inherite`p_print within w_sal_06220
integer x = 1175
integer y = 2604
boolean enabled = false
end type

type p_can from w_inherite`p_can within w_sal_06220
end type

event p_can::clicked;call super::clicked;dw_input.Enabled = True
dw_input.SetFocus()

dw_insert.Reset()

end event

type p_exit from w_inherite`p_exit within w_sal_06220
end type

type p_ins from w_inherite`p_ins within w_sal_06220
integer x = 3749
end type

event p_ins::clicked;call super::clicked;//string sdate, sCvcod
//int    rcnt,row
//
//String sData, sName,sOrderSpec
//Long   nRow,d_piqty
//int nRtn
//double dIoQty, dIoprc, dIoamt, dExpasn_han_rstan ,sRstan, sCurramt

String sdate, sName,sOrderSpec,sCvcod,sSdate
Long   nRow,d_piqty
int nRtn , rcnt ,row
double dIoQty, dIoprc, dIoamt, dExpasn_han_rstan ,sRstan, sCurramt

setnull(snull)

IF dw_input.AcceptText() = -1 THEN Return
sCvcod = Trim(dw_input.GetItemString(1, 'cvcod'))

// 일자 setting후 New! 상태로...
dw_insert.Reset()
row = dw_insert.InsertRow(0)
dw_insert.SetItem(row,'sudat',f_today())
dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)

is_today = f_today()   
   	
		SELECT RSTAN 
			INTO :sRstan
			FROM RATEMT
			WHERE RDATE= :is_today
			AND RCURR = 'USD';
        
		IF SQLCA.SQLCODE <> 0 THEN
			dw_insert.SetItem(row,"rstan", 0)
			Return 1
		END IF	
		dw_insert.SetItem(row, "rstan", sRstan)

If sCvcod = snull or sCvcod = '' then
	dw_insert.SetItem(row,'shipper',snull)
	dw_insert.SetItem(row,'bill_to',snull)
Else
	wf_copy_last_buyer(sCvcod)
End if
dw_insert.SetFocus()
dw_insert.SetRow(row)
dw_insert.SetColumn('asnno')

//dw_input.Enabled = False   // 추가중 일자변경 불가
end event

type p_new from w_inherite`p_new within w_sal_06220
end type

type dw_input from w_inherite`dw_input within w_sal_06220
integer y = 56
integer width = 3488
integer height = 188
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06220_1"
end type

event itemchanged;string sdate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow,nRtn,ix,nCnt

SetNull(sNull)
Choose Case GetColumnName()
	Case 'sdate'
		nRow = GetRow()
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'sdate',sNull)
	      Return 1
      	END IF
		
		Post SetItem(nRow,'sdate',sDate)
	Case 'edate'
		nRow = GetRow()
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'edate',sNull)
	      Return 1
      	END IF
		
		Post SetItem(nRow,'edate',sDate)
	/* 거래처 */	
	Case 'cvcod'
		nRow = dw_insert.RowCount()
		
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod',   sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas",	scvnas)
		END IF
End Choose

end event

event rbuttondown;string sPino
long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "cvcod"
		nRow = dw_insert.RowCount()		
		gs_gubun = '2'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

type cb_delrow from w_inherite`cb_delrow within w_sal_06220
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_06220
end type

type dw_insert from w_inherite`dw_insert within w_sal_06220
integer x = 2107
integer y = 300
integer width = 2447
integer height = 2080
integer taborder = 20
string dataobject = "d_sal_06220_2"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_insert::itemchanged;String sData, sName,sOrderSpec
Long   nRow,d_piqty
int nRtn
double dIoQty, dIoprc, dIoamt, dExpasn_han_rstan ,sRstan, sCurramt

nRow = GetRow()
If nRow <= 0 Then Return

setnull(snull)
Choose Case GetColumnName()
	Case 'itnbr'
		sData = gettext()
		
		SELECT ITDSC INTO :sName 
			FROM ITEMAS 
			WHERE ITNBR = :sData;
		
		IF SQLCA.SQLCODE <> 0 THEN
			SetItem(nRow,"itnbr",   sNull)
			SetItem(nRow, "itdsc", sNull)
			Return 1
		END IF
		
		SetItem(nRow, "itdsc", sName)
		
		/* 단가 계산 */
		sOrderSpec = GetItemString(nRow,'pspec')
		d_piqty	  = GetItemNumber(nRow,'ioqty')
		nRtn = wf_catch_danga(nRow,sData, sOrderSpec, d_piqty)
		If nRtn = -1 Then 
			SetItem(nRow, "ioprc", 0)
			Return 1
		End If
		
	Case 'cvcod'
		sData = gettext()
		SELECT CVNAS 
		INTO :sName 
			FROM VNDMST 
			WHERE CVCOD = :sData;
		
		IF SQLCA.SQLCODE <> 0 THEN
			SetItem(nRow,"cvcod",   sNull)
			SetItem(nRow, "cvnas", sNull)
			Return 1
		END IF
		
		SetItem(nRow, "cvnas", sName)	
		
	Case 'sudat'
		sData = gettext()	
		dIoQty = GetItemNumber(nRow, 'ioqty')
		dIoprc = GetItemNumber(nRow, 'ioprc')
		sRstan = GetItemNumber(nRow, 'rstan')
		
				
		SELECT RSTAN 
            INTO :sRstan
            FROM RATEMT
            WHERE RDATE= :sData
            AND rcurr = 'USD';				

			IF SQLCA.SQLCODE <> 0 THEN
				SetItem(nRow,"rstan", 0)
				Return 1
			END IF	
			
			SetItem(nRow, "rstan", sRstan)
//			sCurramt = TrunCate(ROUND(dIoQty * dIoprc*sRstan,2),2)
			sCurramt = ROUND(dIoQty * dIoprc*sRstan,5)
//			Round(dNewCiQty,2)
			SetItem(nRow,"curramt",sCurramt)
			
	
//	Case 'sudat'
//		sData = gettext()
//		 MESSAGEBOX('',sData)
//		If f_datechk(sData) = -1 Then
//			f_message_chk(40,'[일자/ 오류]')
//			SetItem(nRow, "sudat", sNull)
//			dw_insert.SetColumn('sudat')
//			Return
//		End If


//	Case 'ioqty'
//		dIoQty  = double(this.GetText())
//		dIoprc = GetItemNumber(nRow, 'ioprc')
//		
//		IF dIoQty = 0 or isnull(dIoQty) then 
//			SetItem(nRow,"ioamt",0)
//			return 
//		elseif  isnull(dIoprc) or isnull(dIoprc) then 
//			SetItem(nRow,"ioamt",0)
//			return
//		ELSE
//			dIoamt = TrunCate(dIoQty * dIoprc,2)
//			SetItem(nRow,"ioamt",dIoamt)
//		END IF



Case 'ioqty'
		dIoQty  = double(this.GetText())
		dIoprc = GetItemNumber(nRow, 'ioprc')
		sRstan = GetItemNumber(nRow, 'rstan')
		
		IF dIoQty = 0 or isnull(dIoQty) then 
			SetItem(nRow,"ioamt",0)
			SetItem(nRow,"curramt",0)
			return 
		elseif  isnull(dIoprc) or isnull(dIoprc) then 
			SetItem(nRow,"ioamt",0)
			SetItem(nRow,"curramt",0)
			return
		ELSE
			dIoamt = TrunCate(dIoQty * dIoprc,2)
			SetItem(nRow,"ioamt",dIoamt)
			
//			sCurramt = TrunCate(ROUND(dIoQty * dIoprc*sRstan,2),2)
//			sCurramt = ROUND(dIoQty * dIoprc*sRstan,5)
			sCurramt = ROUND((dIoQty)*(dIoprc)*(sRstan),0)
			SetItem(nRow,"curramt",sCurramt)
		END IF

Case 'ioprc'
		dIoprc  = double(this.GetText())
		dIoQty = GetItemNumber(nRow, 'ioqty')
		sRstan = GetItemNumber(nRow, 'rstan')
		
		IF dIoprc = 0 or isnull(dIoprc) then 
			SetItem(nRow,"ioamt",0)
			SetItem(nRow,"curramt",0)
			return 
		elseif  isnull(dIoQty) or isnull(dIoQty) then 
			SetItem(nRow,"ioamt",0)
			SetItem(nRow,"curramt",0)
			return
		ELSE
			dIoamt = TrunCate(dIoQty * dIoprc,2)
			SetItem(nRow,"ioamt",dIoamt)
			
//			sCurramt = TrunCate(ROUND(dIoQty * dIoprc*sRstan,2),2)
//			sCurramt = ROUND(dIoQty * dIoprc*sRstan,5)
			sCurramt = ROUND((dIoQty)*(dIoprc)*(sRstan),0)
			SetItem(nRow,"curramt",sCurramt)
		END IF		
	
//Case 'ioprc'
//		dIoprc  = double(this.GetText())
//		dIoQty = GetItemNumber(nRow, 'ioqty')
//		
//		IF dIoprc = 0 or isnull(dIoprc) then 
//			SetItem(nRow,"ioamt",0)
//			return 
//		elseif  isnull(dIoQty) or isnull(dIoQty) then 
//			SetItem(nRow,"ioamt",0)
//			return
//		ELSE
//			dIoamt = TrunCate(dIoQty * dIoprc,2)
//			SetItem(nRow,"ioamt",dIoamt)
//		END IF		
	
	
End Choose
end event

event dw_insert::itemerror;Return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow, i, ll_i = 0
String sItnbr, sItdsc, sCustno, sCustnm, sPino, sPidate, sOrderSpec, sAsnno
Long lPiseq
int rtn, nRtn, dPiqty
Double dIoprc, dIoamt, sRstan, sCurramt

datastore ds_multi
ds_multi = Create Datastore

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)

nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
	Case "itnbr"
		IF gs_saupj = '%' THEN
			gs_code = '10'
		ELSE
			gs_code = gs_saupj
		END IF
		open(w_exppid_popup_agent)
		
		/* P/I기준으로 읽어올 경우 : ClipBoard의 내용을 copy한다 */
		ds_multi.DataObject = 'd_exppid_popup_agent'
		rtn = ds_multi.ImportClipBoard()
		
		/* key check */
		If rtn <=0 Then 
			f_message_chk(50,'')
			Return 0
		End If
		
		sPino   = ds_multi.GetItemString(1, "pino")
		lPiseq  = ds_multi.GetItemNumber(1, "piseq")
		dPiqty  = ds_multi.GetItemNumber(1, "piqty")
		
		SELECT A.ITNBR, C.ITDSC, A.CVCOD, D.CVNAS, B.PIDATE
		  INTO :sItnbr, :sItdsc, :sCustno, :sCustnm, :sPidate
		  FROM EXPPID A, EXPPIH B, ITEMAS C, VNDMST D
		 WHERE A.PINO = :sPino
		   AND A.PISEQ = :lPiseq
		   AND A.SABU = B.SABU
		   AND A.PINO = B.PINO
		   AND A.ITNBR = C.ITNBR
		   AND A.CVCOD = D.CVCOD;
		
		this.SetItem(nRow, "pino", sPino)
		this.SetItem(nRow, "piseq", lPiseq)
		this.SetItem(nRow, "itnbr", sItnbr)
		this.SetItem(nRow, "itdsc", sItdsc)
		this.SetItem(nRow, "cvcod", sCustno)
		this.SetItem(nRow, "cvnas", sCustnm)
		this.SetItem(nRow, "ioqty", dPiqty)
		
		SELECT :sPidate||TO_CHAR(NVL(TO_NUMBER(MAX(SUBSTR(ASNNO, 9, 3))), 0) + 1, 'FM000')
		  INTO :sAsnno
		  FROM EXPASN_HAN
		 WHERE LENGTH(ASNNO) = 11
		   AND SUBSTR(ASNNO, 1, 8) = :sPidate;
		
		this.SetItem(nRow, "asnno", sAsnno)
		
		/* 단가 계산 */
		sOrderSpec = this.GetItemString(nRow, 'pspec')
		nRtn = wf_catch_danga(nRow, sItnbr, sOrderSpec, dPiqty)
		If nRtn = -1 Then 
			this.SetItem(nRow, "ioprc", 0)
		End If
		
		dIoprc = this.GetItemNumber(nRow, 'ioprc')
		sRstan = this.GetItemNumber(nRow, 'rstan')
		
		IF dPiqty = 0 or isnull(dPiqty) then 
			this.SetItem(nRow, "ioamt", 0)
			this.SetItem(nRow, "curramt", 0)
			return 
		elseif  isnull(dIoprc) or isnull(dIoprc) then 
			this.SetItem(nRow, "ioamt", 0)
			this.SetItem(nRow, "curramt", 0)
			return
		ELSE
			dIoamt = TrunCate(dPiqty * dIoprc,2)
			this.SetItem(nRow, "ioamt", dIoamt)
			
			sCurramt = ROUND((dPiqty)*(dIoprc)*(sRstan),0)
			this.SetItem(nRow, "curramt", sCurramt)
		END IF
	Case "cvcod"
		IF gs_saupj = '%' THEN
			gs_code = '10'
		ELSE
			gs_code = gs_saupj
		END IF
		Open(w_exppid_popup_agent)
		
		/* P/I기준으로 읽어올 경우 : ClipBoard의 내용을 copy한다 */
		ds_multi.DataObject = 'd_exppid_popup_agent'
		rtn = ds_multi.ImportClipBoard()
		
		/* key check */
		If rtn <=0 Then 
			f_message_chk(50,'')
			Return 0
		End If
		
		sPino   = ds_multi.GetItemString(1, "pino")
		lPiseq  = ds_multi.GetItemNumber(1, "piseq")
		dPiqty  = ds_multi.GetItemNumber(1, "piqty")
		
		SELECT A.ITNBR, C.ITDSC, A.CVCOD, D.CVNAS, B.PIDATE
		  INTO :sItnbr, :sItdsc, :sCustno, :sCustnm, :sPidate
		  FROM EXPPID A, EXPPIH B, ITEMAS C, VNDMST D
		 WHERE A.PINO = :sPino
		   AND A.PISEQ = :lPiseq
		   AND A.SABU = B.SABU
		   AND A.PINO = B.PINO
		   AND A.ITNBR = C.ITNBR
		   AND A.CVCOD = D.CVCOD;
		
		this.SetItem(nRow, "pino", sPino)
		this.SetItem(nRow, "piseq", lPiseq)
		this.SetItem(nRow, "itnbr", sItnbr)
		this.SetItem(nRow, "itdsc", sItdsc)
		this.SetItem(nRow, "cvcod", sCustno)
		this.SetItem(nRow, "cvnas", sCustnm)
		this.SetItem(nRow, "ioqty", dPiqty)
		
		SELECT :sPidate||TO_CHAR(NVL(TO_NUMBER(MAX(SUBSTR(ASNNO, 9, 3))), 0) + 1, 'FM000')
		  INTO :sAsnno
		  FROM EXPASN_HAN
		 WHERE LENGTH(ASNNO) = 11
		   AND SUBSTR(ASNNO, 1, 8) = :sPidate;
		
		this.SetItem(nRow, "asnno", sAsnno)
		
		/* 단가 계산 */
		sOrderSpec = this.GetItemString(nRow, 'pspec')
		nRtn = wf_catch_danga(nRow, sItnbr, sOrderSpec, dPiqty)
		If nRtn = -1 Then 
			this.SetItem(nRow, "ioprc", 0)
		End If
		
		dIoprc = this.GetItemNumber(nRow, 'ioprc')
		sRstan = this.GetItemNumber(nRow, 'rstan')
		
		IF dPiqty = 0 or isnull(dPiqty) then 
			this.SetItem(nRow, "ioamt", 0)
			this.SetItem(nRow, "curramt", 0)
			return 
		elseif  isnull(dIoprc) or isnull(dIoprc) then 
			this.SetItem(nRow, "ioamt", 0)
			this.SetItem(nRow, "curramt", 0)
			return
		ELSE
			dIoamt = TrunCate(dPiqty * dIoprc,2)
			this.SetItem(nRow, "ioamt", dIoamt)
			
			sCurramt = ROUND((dPiqty)*(dIoprc)*(sRstan),0)
			this.SetItem(nRow, "curramt", sCurramt)
		END IF
	Case "pino"
		IF gs_saupj = '%' THEN
			gs_code = '10'
		ELSE
			gs_code = gs_saupj
		END IF
		Open(w_exppid_popup_agent)
		
		/* P/I기준으로 읽어올 경우 : ClipBoard의 내용을 copy한다 */
		ds_multi.DataObject = 'd_exppid_popup_agent'
		rtn = ds_multi.ImportClipBoard()
		
		/* key check */
		If rtn <=0 Then 
			f_message_chk(50,'')
			Return 0
		End If
		
		sPino   = ds_multi.GetItemString(1, "pino")
		lPiseq  = ds_multi.GetItemNumber(1, "piseq")
		dPiqty  = ds_multi.GetItemNumber(1, "piqty")
		
		SELECT A.ITNBR, C.ITDSC, A.CVCOD, D.CVNAS, B.PIDATE
		  INTO :sItnbr, :sItdsc, :sCustno, :sCustnm, :sPidate
		  FROM EXPPID A, EXPPIH B, ITEMAS C, VNDMST D
		 WHERE A.PINO = :sPino
		   AND A.PISEQ = :lPiseq
		   AND A.SABU = B.SABU
		   AND A.PINO = B.PINO
		   AND A.ITNBR = C.ITNBR
		   AND A.CVCOD = D.CVCOD;
		
		this.SetItem(nRow, "pino", sPino)
		this.SetItem(nRow, "piseq", lPiseq)
		this.SetItem(nRow, "itnbr", sItnbr)
		this.SetItem(nRow, "itdsc", sItdsc)
		this.SetItem(nRow, "cvcod", sCustno)
		this.SetItem(nRow, "cvnas", sCustnm)
		this.SetItem(nRow, "ioqty", dPiqty)
		
		SELECT :sPidate||TO_CHAR(NVL(TO_NUMBER(MAX(SUBSTR(ASNNO, 9, 3))), 0) + 1, 'FM000')
		  INTO :sAsnno
		  FROM EXPASN_HAN
		 WHERE LENGTH(ASNNO) = 11
		   AND SUBSTR(ASNNO, 1, 8) = :sPidate;
		
		this.SetItem(nRow, "asnno", sAsnno)
		
		/* 단가 계산 */
		sOrderSpec = this.GetItemString(nRow, 'pspec')
		nRtn = wf_catch_danga(nRow, sItnbr, sOrderSpec, dPiqty)
		If nRtn = -1 Then 
			this.SetItem(nRow, "ioprc", 0)
		End If
		
		dIoprc = this.GetItemNumber(nRow, 'ioprc')
		sRstan = this.GetItemNumber(nRow, 'rstan')
		
		IF dPiqty = 0 or isnull(dPiqty) then 
			this.SetItem(nRow, "ioamt", 0)
			this.SetItem(nRow, "curramt", 0)
			return 
		elseif  isnull(dIoprc) or isnull(dIoprc) then 
			this.SetItem(nRow, "ioamt", 0)
			this.SetItem(nRow, "curramt", 0)
			return
		ELSE
			dIoamt = TrunCate(dPiqty * dIoprc,2)
			this.SetItem(nRow, "ioamt", dIoamt)
			
			sCurramt = ROUND((dPiqty)*(dIoprc)*(sRstan),0)
			this.SetItem(nRow, "curramt", sCurramt)
		END IF
END Choose
end event

event dw_insert::ue_pressenter;Choose Case GetColumnName() 
	Case "bigo", "shipper", "bill_to"
		return 0
	Case Else
      Send(Handle(this),256,9,0)
      Return 1
End Choose		
end event

type cb_mod from w_inherite`cb_mod within w_sal_06220
integer x = 1513
integer y = 2612
integer taborder = 50
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_06220
integer x = 887
integer y = 2612
integer taborder = 30
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_sal_06220
integer x = 1865
integer y = 2612
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_06220
integer x = 526
integer y = 2612
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_06220
integer x = 1765
integer y = 2748
integer taborder = 100
boolean enabled = false
end type

type cb_can from w_inherite`cb_can within w_sal_06220
integer x = 2217
integer y = 2612
integer taborder = 70
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_06220
integer x = 2487
integer y = 2748
integer taborder = 110
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_sal_06220
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06220
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06220
end type

type r_head from w_inherite`r_head within w_sal_06220
end type

type r_detail from w_inherite`r_detail within w_sal_06220
integer width = 2047
integer height = 2116
end type

type pb_1 from u_pic_cal within w_sal_06220
integer x = 613
integer y = 92
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_06220
integer x = 1115
integer y = 92
integer width = 78
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'edate', gs_code)

end event

type dw_list from datawindow within w_sal_06220
integer x = 37
integer y = 284
integer width = 2039
integer height = 2108
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06220"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;string sdate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow,nRtn,ix,nCnt

SetNull(sNull)
Choose Case GetColumnName()
	Case 'sdate'
		nRow = GetRow()
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'sdate',sNull)
	      Return 1
      	END IF
		
		Post SetItem(nRow,'sdata',sDate)
	Case 'edate'
		nRow = GetRow()
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'edate',sNull)
	      Return 1
      	END IF
		
		Post SetItem(nRow,'edata',sDate)
	/* 거래처 */	
	Case 'cvcod'
		nRow = dw_insert.RowCount()
		
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod',   sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas",	scvnas)
		END IF
End Choose

end event

event rbuttondown;string sPino
long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "cvcod"
		nRow = dw_insert.RowCount()		
		gs_gubun = '2'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

event clicked;String sAsnno

IF Row <=0 THEN RETURN
SelectRow(0,False)
SelectRow(Row,True)

If dw_list.AcceptText() <> 1 Then Return

sAsnno    = Trim(GetItemSTring(Row,"asnno"))
	
IF dw_insert.Retrieve(sAsnno) <=0 THEN 
	f_message_chk(50,'')
	dw_insert.Setfocus()
	Return
END IF

ib_any_typing = False

end event

type rr_2 from roundrectangle within w_sal_06220
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 12639424
integer x = 2103
integer y = 280
integer width = 2455
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

