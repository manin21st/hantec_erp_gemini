$PBExportHeader$w_kglc20a.srw
$PBExportComments$지급결제 전표-어음결제 상세
forward
global type w_kglc20a from window
end type
type p_exit from uo_picture within w_kglc20a
end type
type p_can from uo_picture within w_kglc20a
end type
type p_del from uo_picture within w_kglc20a
end type
type p_add from uo_picture within w_kglc20a
end type
type dw_find from u_key_enter within w_kglc20a
end type
type tab_bill from tab within w_kglc20a
end type
type tabpage_paybill from userobject within tab_bill
end type
type rr_1 from roundrectangle within tabpage_paybill
end type
type dw_paybil from u_key_enter within tabpage_paybill
end type
type tabpage_paybill from userobject within tab_bill
rr_1 rr_1
dw_paybil dw_paybil
end type
type tabpage_rcvbill from userobject within tab_bill
end type
type dw_rcvbil from u_d_popup_sort within tabpage_rcvbill
end type
type rr_2 from roundrectangle within tabpage_rcvbill
end type
type tabpage_rcvbill from userobject within tab_bill
dw_rcvbil dw_rcvbil
rr_2 rr_2
end type
type tab_bill from tab within w_kglc20a
tabpage_paybill tabpage_paybill
tabpage_rcvbill tabpage_rcvbill
end type
type dw_head from datawindow within w_kglc20a
end type
end forward

global type w_kglc20a from window
integer x = 416
integer y = 224
integer width = 3328
integer height = 1940
boolean titlebar = true
string title = "지급결제방법-어음"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_add p_add
dw_find dw_find
tab_bill tab_bill
dw_head dw_head
end type
global w_kglc20a w_kglc20a

type variables

DataWindow    Idw_Bill
Integer             iCur_TabPage
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function integer wf_dup_chk (string sbillno, string sbillgbn, string sflag)
public subroutine wf_clear_str ()
public subroutine wf_setting_data ()
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sBillNo,sBalDate,sManDate,sBnkcd

Idw_Bill.AcceptText()

sBillNo  = Idw_Bill.GetItemString(iCurRow,"billno")
sBalDate = Idw_Bill.GetItemString(iCurRow,"bbaldate") 
sManDate = Idw_Bill.GetItemString(iCurRow,"bmandate") 
sBnkCd   = Idw_Bill.GetItemString(iCurRow,"bank_cd") 

IF sBillNo = "" OR IsNull(sBillNo) THEN
	F_MessageChk(1,'[어음번호]')
	Idw_Bill.SetColumn("billno")
	Idw_Bill.SetFocus()
	Return -1
END IF
IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[발행일자]')
	Idw_Bill.SetColumn("bbaldate")
	Idw_Bill.SetFocus()
	Return -1
END IF
IF sManDate = "" OR IsNull(sManDate) THEN
	F_MessageChk(1,'[만기일자]')
	Idw_Bill.SetColumn("bmandate")
	Idw_Bill.SetFocus()
	Return -1
END IF
IF sBnkCd = "" OR IsNull(sBnkCd) THEN
	F_MessageChk(1,'[지급은행]')
	Idw_Bill.SetColumn("bank_cd")
	Idw_Bill.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_dup_chk (string sbillno, string sbillgbn, string sflag);String  sNull,sUseTag,sBnkCd,sOwner
Integer iDbCount

SetNull(snull)

/*수표.어음책*/
SELECT "KFM06OT0"."USE_GU","KFM06OT0"."CHECK_BNK"  INTO :sUseTag, :sBnkCd
  	FROM "KFM06OT0"  
  	WHERE "KFM06OT0"."CHECK_NO" = :sBillNo AND "KFM06OT0"."CHECK_GU" = :sBillGbn  ;
IF SQLCA.SQLCODE <> 0 THEN
	IF sflag = 'BILL' THEN
		F_MessageChk(20,'[어음번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"billno",snull)
		Idw_bill.SetItem(Idw_bill.GetRow(),"bank_cd",snull)
	ELSE
		F_MessageChk(20,'[수표번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"checkno",snull)
	END IF
	Return -1
END IF

/*상태 <> '미사용'*/
IF sUseTag <> '0' THEN
	IF sflag = 'BILL' THEN
		F_MessageChk(10,'[어음번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"billno",snull)
		Idw_bill.SetItem(Idw_bill.GetRow(),"bank_cd",snull)
	ELSE
		F_MessageChk(10,'[수표번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"checkno",snull)
	END IF
	Return -1
END IF

/*지급어음 마스타*/
IF sFlag = 'BILL' THEN
	SELECT COUNT("KFM01OT0"."BILL_NO")	INTO :iDbCount  
		FROM "KFM01OT0"  
		WHERE "KFM01OT0"."BILL_NO" = :sBillNo   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		F_MessageChk(10,'[어음번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"billno",snull)
		Idw_bill.SetItem(Idw_bill.GetRow(),"bank_cd",snull)
		Return -1
	END IF
	
	/*전표의 지급어음(TEMP)*/
	SELECT COUNT("KFZ12OTC"."BILL_NO")	INTO :iDbCount  
		FROM "KFZ12OTC"  
		WHERE "KFZ12OTC"."BILL_NO" = :sBillNo   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		F_MessageChk(10,'[어음번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"billno",snull)
		Idw_bill.SetItem(Idw_bill.GetRow(),"bank_cd",snull)
		Return -1
	END IF
	
	/*지급결재전표의 지급어음(kfz19ot4)*/
	SELECT COUNT("KFZ19OT4"."BILLNO")	INTO :iDbCount  
		FROM "KFZ19OT4"  
		WHERE "KFZ19OT4"."BILL_GBN" ='P' AND "KFZ19OT4"."BILLNO" = :sBillNo   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		F_MessageChk(10,'[어음번호]')
		Idw_bill.SetItem(Idw_bill.GetRow(),"billno",snull)
		Idw_bill.SetItem(Idw_bill.GetRow(),"bank_cd",snull)
		Return -1
	END IF
	
	Idw_bill.SetItem(Idw_bill.GetRow(),"bank_cd",sBnkCd)
	
	/*발행인*/
	SELECT substr("SYSCNFG"."DATANAME",1,20)  	INTO :sOwner  
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '80' )   ;
	Idw_bill.SetItem(Idw_bill.GetRow(),"bill_nm",sOwner)
	
	Idw_bill.SetItem(Idw_bill.GetRow(),"bbaldate",Lstr_PayGyel[1].Gyel_Date)
	
END IF
	
Return 1
end function

public subroutine wf_clear_str ();Integer k

For k = 1 TO Lstr_PayGyel[1].AryCnt
	SetNull(Lstr_PayGyel[k].bill_gbn)
	SetNull(Lstr_PayGyel[k].billno)
	SetNull(Lstr_PayGyel[k].bbaldate)
	SetNull(Lstr_PayGyel[k].bmandate)
	SetNull(Lstr_PayGyel[k].bill_nm)
	SetNull(Lstr_PayGyel[k].billamt)
NEXT
		
end subroutine

public subroutine wf_setting_data ();Integer  k,iCurRow,iFindRow

FOR k = 1 TO Lstr_PayGyel[1].AryCnt
	IF Lstr_PayGyel[k].Bill_Gbn = 'P' THEN
		iFindRow = tab_bill.tabpage_paybill.dw_paybil.Find("billno = '" + Lstr_PayGyel[k].billno + "'",1,tab_bill.tabpage_paybill.dw_paybil.RowCount())
		
		IF iFindRow > 0 THEN
			iCurRow = iFindRow
		ELSE
			iCurRow = tab_bill.tabpage_paybill.dw_paybil.InsertRow(0)
			
			tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"bill_gbn", Lstr_PayGyel[1].Bill_Gbn)
			tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"billno",   Lstr_PayGyel[k].billno)
		END IF	
		
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"bbaldate", Lstr_PayGyel[k].bbaldate)
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"bmandate", Lstr_PayGyel[k].bmandate)
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"bank_cd",  Lstr_PayGyel[k].bank_cd)
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"bill_nm",  Lstr_PayGyel[k].bill_nm)
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"billamt",  Lstr_PayGyel[k].billamt)
		
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"gyel_date",Lstr_PayGyel[k].gyel_date)
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"seqno",    Lstr_PayGyel[k].seqno)
		
		tab_bill.tabpage_paybill.dw_paybil.SetItem(iCurRow,"sflag",    'M')
	ELSE
		iCurRow = tab_bill.tabpage_rcvbill.dw_rcvbil.Find("billno = '" + Lstr_PayGyel[k].billno + "'",1,tab_bill.tabpage_rcvbill.dw_rcvbil.RowCount())
		IF iCurRow > 0 THEN
			tab_bill.tabpage_rcvbill.dw_rcvbil.SetItem(iCurRow,"status",'5')
		END IF
	END IF
NEXT
end subroutine

on w_kglc20a.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_add=create p_add
this.dw_find=create dw_find
this.tab_bill=create tab_bill
this.dw_head=create dw_head
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_add,&
this.dw_find,&
this.tab_bill,&
this.dw_head}
end on

on w_kglc20a.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_add)
destroy(this.dw_find)
destroy(this.tab_bill)
destroy(this.dw_head)
end on

event open;
Integer iPCnt,iRCnt

F_Window_Center_Response(This)

tab_bill.tabpage_paybill.dw_paybil.SetTransObject(Sqlca)
tab_bill.tabpage_paybill.dw_paybil.Reset()

tab_bill.tabpage_rcvbill.dw_rcvbil.SetTransObject(Sqlca)
tab_bill.tabpage_rcvbill.dw_rcvbil.Reset()

dw_head.SetTransObject(Sqlca)
dw_head.Reset()
dw_head.InsertRow(0)

dw_head.SetItem(1,"billamt",Lstr_PayGyel[1].Total_GyelAmt)

dw_find.SetTransObject(Sqlca)
dw_find.Reset()
dw_find.InsertRow(0)

iPCnt = tab_bill.tabpage_paybill.dw_paybil.Retrieve(Lstr_PayGyel[1].Gyel_date,Lstr_PayGyel[1].SeqNo)
iRCnt = tab_bill.tabpage_rcvbill.dw_rcvbil.Retrieve(Lstr_PayGyel[1].Gyel_date,Lstr_PayGyel[1].SeqNo,Lstr_PayGyel[1].Saupj)

Wf_Setting_Data()

IF iRCnt > 0 AND tab_bill.tabpage_paybill.dw_paybil.RowCount() <=0 THEN
	Idw_Bill = tab_bill.tabpage_rcvbill.dw_rcvbil
	iCur_TabPage = 2

	dw_find.Visible = True
ELSE
	Idw_Bill = tab_bill.tabpage_paybill.dw_paybil		
	iCur_TabPage = 1
	
	dw_find.Visible = False
END IF

tab_bill.SelectedTab = iCur_TabPage

end event

type p_exit from uo_picture within w_kglc20a
integer x = 3095
integer y = 28
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;Integer iPayRow,iRcvRow,iYesCnt,k,iAryCnt = 0
Double  dAmount = 0,dSumAmt = 0

iPayRow = tab_bill.tabpage_paybill.dw_paybil.RowCount()
IF iPayRow > 0 THEN
	dAmount = tab_bill.tabpage_paybill.dw_paybil.GetItemNumber(1,"sum_payamt")
ELSE
	dAmount = 0
END IF
dSumAmt = dSumAmt + dAmount

iRcvRow = tab_bill.tabpage_rcvbill.dw_rcvbil.RowCount()
IF iRcvRow > 0 THEN
	dAmount = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemNumber(1,"sum_rcvamt")
	iYesCnt = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemNumber(1,"yescnt")
//	IF iYesCnt > 1 THEN
//		F_MessageChk(16,'[선택 건수 1이상]')
//		Return
//	end if
ELSE
	dAmount = 0;		iYesCnt = 0;
END IF
dSumAmt = dSumAmt + dAmount

IF iPayRow <=0 AND iYesCnt <=0 THEN
	Lstr_PayGyel[1].sFlag = '0'
ELSE
	Wf_Clear_Str()
	
	FOR k = 1 TO iPayRow
		iAryCnt = iAryCnt + 1
		
		Lstr_PayGyel[iAryCnt].bill_gbn = tab_bill.tabpage_paybill.dw_paybil.GetItemString(k,"bill_gbn")			
		Lstr_PayGyel[iAryCnt].billno   = tab_bill.tabpage_paybill.dw_paybil.GetItemString(k,"billno")			
		Lstr_PayGyel[iAryCnt].bbaldate = tab_bill.tabpage_paybill.dw_paybil.GetItemString(k,"bbaldate")			
		Lstr_PayGyel[iAryCnt].bmandate = tab_bill.tabpage_paybill.dw_paybil.GetItemString(k,"bmandate")				
		Lstr_PayGyel[iAryCnt].bank_cd  = tab_bill.tabpage_paybill.dw_paybil.GetItemString(k,"bank_cd")			
		Lstr_PayGyel[iAryCnt].bill_nm  = tab_bill.tabpage_paybill.dw_paybil.GetItemString(k,"bill_nm")			
		Lstr_PayGyel[iAryCnt].billamt  = tab_bill.tabpage_paybill.dw_paybil.GetItemNumber(k,"billamt")
	NEXT
	
	IF iYesCnt > 0 THEN
		FOR k = 1 TO iRcvRow
			IF tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemString(k,"status") = '5' THEN
				iAryCnt = iAryCnt + 1
				
				Lstr_PayGyel[iAryCnt].bill_gbn = 'R'			
				Lstr_PayGyel[iAryCnt].billno   = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemString(k,"billno")			
				Lstr_PayGyel[iAryCnt].bbaldate = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemString(k,"bbaldate")			
				Lstr_PayGyel[iAryCnt].bmandate = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemString(k,"bmandate")				
				Lstr_PayGyel[iAryCnt].bank_cd  = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemString(k,"bank_cd")			
				Lstr_PayGyel[iAryCnt].bill_nm  = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemString(k,"bill_nm")			
				Lstr_PayGyel[iAryCnt].billamt  = tab_bill.tabpage_rcvbill.dw_rcvbil.GetItemNumber(k,"billamt")
			END IF
		NEXT
	END IF
	
	Lstr_PayGyel[1].sFlag = '1'
	Lstr_PayGyel[1].AryCnt = iAryCnt
	
	Lstr_PayGyel[1].Total_GyelAmt = dSumAmt
END IF

Close(w_kglc20a)
end event

type p_can from uo_picture within w_kglc20a
integer x = 2921
integer y = 28
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;Lstr_PayGyel[1].sFlag = '0'

Close(w_kglc20a)
end event

type p_del from uo_picture within w_kglc20a
integer x = 2747
integer y = 28
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;Integer k

IF Idw_Bill.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

Idw_Bill.DeleteRow(Idw_Bill.GetRow())
	
Idw_Bill.SetColumn("bbaldate")
Idw_Bill.SetFocus()
	
end event

type p_add from uo_picture within w_kglc20a
integer x = 2574
integer y = 28
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event clicked;call super::clicked;IF ICur_TabPage = 1 THEN
	Integer  iCurRow,iFunctionValue,iRowCount
	
	iRowCount = Idw_Bill.RowCount()
	
	IF iRowCount > 0 THEN
		iFunctionValue = Wf_RequiredChk(Idw_Bill.GetRow())
		IF iFunctionValue <> 1 THEN RETURN
	ELSE
		iFunctionValue = 1	
		
		iRowCount = 0
	END IF
	
	IF iFunctionValue = 1 THEN
		iCurRow = iRowCount + 1
		
		Idw_Bill.InsertRow(iCurRow)
	
		Idw_Bill.ScrollToRow(iCurRow)
		Idw_Bill.SetItem(iCurRow,'sflag','I')
		Idw_Bill.SetColumn("billno")
		Idw_Bill.SetFocus()
	END IF
ELSE
	
END IF
end event

type dw_find from u_key_enter within w_kglc20a
integer x = 859
integer width = 1696
integer height = 256
integer taborder = 50
string dataobject = "dw_kglb01d1_5"
boolean border = false
end type

event buttonclicked;String sBillNoF,sBillNoT,sFromDate,sToDate,sBillAmt,sFindString

IF dwo.name = 'dcb_find' THEN
	this.AcceptText()
	sBillNoF  = this.GetItemString(1,"from_billno")
	sBillNoT  = this.GetItemString(1,"to_billno")
	sFromDate = Trim(this.GetItemString(1,"from_mandate"))
	sToDate   = Trim(this.GetItemString(1,"to_mandate"))
	
	IF sBillNoF = '' OR IsNull(sBillNoF) THEN sBillNoF = '0'
	IF sBillNoT = '' OR IsNull(sBillNoT) THEN sBillNoT = 'z'
	IF sFromDate = '' OR IsNull(sFromDate) THEN sFromDate = '00000000'
	IF sToDate = '' OR IsNull(sToDate) THEN sToDate = '99999999'
	
	Idw_Bill.SetRedraw(False)
	
	IF this.GetItemNumber(1,"billamt") = 0 OR IsNull(this.GetItemNumber(1,"billamt")) THEN
		sFindString = "billno >= '"+sBillNoF+"' and billno <= '"+sBillNoT +"' and bmandate >= '"+sFromDate+"' and bmandate <= '"+sToDate+"'" 
		Idw_Bill.SetFilter(sFindString)
		Idw_Bill.Filter()
	ELSE
		sBillAmt = String(this.GetItemNumber(1,"billamt"))
		
		sFindString = "billno >= '"+sBillNoF+"' and billno <= '"+sBillNoT +"' and bmandate >= '"+sFromDate+"' and bmandate <= '"+sToDate+"' and str_billamt = '"+sBillAmt+"'"
		Idw_Bill.SetFilter(sFindString)
		Idw_Bill.Filter()		
	END IF
	Idw_Bill.SetRedraw(True)
END IF

end event

event rbuttondown;IF this.GetColumnName() ="from_billno" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"from_billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
	this.SetItem(1,"from_billno",Gs_Code)
END IF

IF this.GetColumnName() ="to_billno" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"to_billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
	this.SetItem(1,"to_billno",Gs_Code)
END IF
end event

type tab_bill from tab within w_kglc20a
integer x = 41
integer y = 256
integer width = 3218
integer height = 1564
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_paybill tabpage_paybill
tabpage_rcvbill tabpage_rcvbill
end type

on tab_bill.create
this.tabpage_paybill=create tabpage_paybill
this.tabpage_rcvbill=create tabpage_rcvbill
this.Control[]={this.tabpage_paybill,&
this.tabpage_rcvbill}
end on

on tab_bill.destroy
destroy(this.tabpage_paybill)
destroy(this.tabpage_rcvbill)
end on

event selectionchanged;
icur_tabpage = newindex

IF newindex = 1 THEN
	Idw_Bill = tab_bill.tabpage_paybill.dw_paybil	
	
	p_add.Visible = True
	p_del.Visible = True
	
	dw_find.Visible = False
ELSEif newindex = 2 THEN
	Idw_Bill = tab_bill.tabpage_rcvbill.dw_rcvbil		

	p_add.Visible = False
	p_del.Visible = False
	
	dw_find.Visible = True
END IF

Idw_Bill.SetFocus()	

end event

type tabpage_paybill from userobject within tab_bill
integer x = 18
integer y = 96
integer width = 3182
integer height = 1452
long backcolor = 32106727
string text = "지급어음"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
dw_paybil dw_paybil
end type

on tabpage_paybill.create
this.rr_1=create rr_1
this.dw_paybil=create dw_paybil
this.Control[]={this.rr_1,&
this.dw_paybil}
end on

on tabpage_paybill.destroy
destroy(this.rr_1)
destroy(this.dw_paybil)
end on

type rr_1 from roundrectangle within tabpage_paybill
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 16
integer width = 3150
integer height = 1420
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_paybil from u_key_enter within tabpage_paybill
event ue_key pbm_dwnkey
integer x = 27
integer y = 20
integer width = 3127
integer height = 1408
integer taborder = 30
string dataobject = "d_kglc20a2"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String   sBillNo,sBalDate,sManDate,sBnkCode,sNull
Integer  iReturnRow

SetNull(sNull)

IF this.GetColumnName() = "billno" THEN
	sBillNo = this.GetText()
	IF sBillNo = "" OR IsNull(sBillNo) THEN Return
	
	iReturnRow = this.find("billno ='" + sBillNo + "'", 1, this.RowCount())

	IF (this.GetRow() <> iReturnRow) and (iReturnRow <> 0) THEN
		f_MessageChk(10,'[어음번호]')
		this.SetItem(this.GetRow(),"billno",snull)
		RETURN  1
	END IF

	IF Wf_Dup_Chk(sBillNo,'2','BILL') = -1 THEN Return 1
END IF

IF this.GetColumnName() ="bbaldate" THEN				/*어음발행일자*/
	sBalDate = Trim(this.GetText())
	IF sBalDate ="" OR isNull(sBalDate) THEN REturn
	
	IF F_DateChk(sBalDate) = -1 THEN 
		F_MessageChk(21,'[발행일자]')
		this.SetItem(this.GetRow(),"bbaldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bmandate" THEN			/*어음만기일자*/
	sManDate = Trim(this.GetText())
	IF sManDate = "" OR IsNull(sManDate) THEN REturn
	
	IF F_DateChk(sManDate) = -1 THEN 
		F_MessageChk(21,'[만기일자]')
		this.SetItem(this.GetRow(),"bmandate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bank_cd" THEN
	sBnkCode = this.GetText()
	IF sBnkCode = "" OR IsNull(sBnkCode) THEN REturn
	
	SELECT "KFZ04OM0_V2"."PERSON_CD"  	INTO :sBnkCode
    	FROM "KFZ04OM0_V2"  
   	WHERE ( "KFZ04OM0_V2"."PERSON_CD" = :sBnkCode );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[지급은행]')
		this.SetItem(this.GetRow(),"bank_cd",snull)
		Return 1
	END IF
END IF

end event

event itemerror;Return 1
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event rbuttondown;IF this.GetColumnName() ="billno" THEN
	SetNull(gs_code)
	SetNull(gs_codename)

	gs_code =this.GetItemString(this.GetRow(),"billno")
	
	OpenWithParm(W_KFM06OT0_POPUP,'2')
	
	IF gs_code = "" OR IsNull(gs_code) THEN REturn
	
	this.SetItem(this.GetRow(),"billno",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type tabpage_rcvbill from userobject within tab_bill
integer x = 18
integer y = 96
integer width = 3182
integer height = 1452
long backcolor = 32106727
string text = "받을어음"
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_rcvbil dw_rcvbil
rr_2 rr_2
end type

on tabpage_rcvbill.create
this.dw_rcvbil=create dw_rcvbil
this.rr_2=create rr_2
this.Control[]={this.dw_rcvbil,&
this.rr_2}
end on

on tabpage_rcvbill.destroy
destroy(this.dw_rcvbil)
destroy(this.rr_2)
end on

type dw_rcvbil from u_d_popup_sort within tabpage_rcvbill
integer x = 32
integer y = 24
integer width = 3118
integer height = 1404
integer taborder = 11
string dataobject = "d_kglc20a3"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag = True
ELSe
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type rr_2 from roundrectangle within tabpage_rcvbill
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 16
integer width = 3150
integer height = 1420
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_head from datawindow within w_kglc20a
integer x = 32
integer y = 48
integer width = 841
integer height = 204
string dataobject = "d_kglc20a1"
boolean border = false
boolean livescroll = true
end type

