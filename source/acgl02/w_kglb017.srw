$PBExportHeader$w_kglb017.srw
$PBExportComments$자금내역 상세 등록
forward
global type w_kglb017 from window
end type
type p_exit from uo_picture within w_kglb017
end type
type p_can from uo_picture within w_kglb017
end type
type dw_finance from datawindow within w_kglb017
end type
type dw_ins from datawindow within w_kglb017
end type
type dw_disp from datawindow within w_kglb017
end type
type rr_1 from roundrectangle within w_kglb017
end type
end forward

global type w_kglb017 from window
integer x = 1778
integer y = 12
integer width = 2240
integer height = 2176
boolean titlebar = true
string title = "자금수지내역 상세 등록"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
dw_finance dw_finance
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb017 w_kglb017

type variables
Boolean ib_changed,ib_DbChanged

end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);Double  dAmount

dw_ins.AcceptText()

dAmount    = dw_ins.GetItemNumber(iCurRow,"amount")
IF IsNull(dAmount) THEN dAmount = 0

IF dAmount = 0 THEN
	dw_ins.DeleteRow(iCurRow)
ELSE
			
//	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
//	dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
//	dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
//	dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
//	dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)
END IF

Return 1
end function

on w_kglb017.create
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_finance=create dw_finance
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_can,&
this.dw_finance,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb017.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_finance)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

event open;Integer iRowCount,iFindRow,iCurRow,k,iFinanceRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)

dw_finance.SetTransObject(Sqlca)
dw_finance.Reset()

IF dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,&
										lstr_jpra.upmugu,lstr_jpra.bjunno,lstr_jpra.sortno) <=0 THEN
	dw_disp.InsertRow(0)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saupj",     lstr_jpra.saupjang)
	dw_disp.SetItem(dw_disp.GetRow(),"bal_date",  lstr_jpra.baldate)
	dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",   lstr_jpra.upmugu)
	dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",   lstr_jpra.bjunno)
	dw_disp.SetItem(dw_disp.GetRow(),"lin_no",    lstr_jpra.sortno)
END IF
dw_disp.SetItem(dw_disp.GetRow(),"amount",lstr_jpra.money)

iRowCount = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,&
													lstr_jpra.upmugu,lstr_jpra.bjunno,lstr_jpra.sortno)
													
IF lstr_jpra.chadae = '1' THEN											/*차변*/
	iFinanceRow = dw_finance.Retrieve('I')
ELSE
	iFinanceRow = dw_finance.Retrieve('O')
END IF

IF iRowCount <=0 THEN
	FOR k = 1 TO iFinanceRow
		iCurRow = dw_ins.InsertRow(0)	
		
		dw_ins.SetItem(iCurRow,"finance_cd",dw_finance.GetItemString(k,"finance_cd"))
		
		dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
		dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
		dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
		dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
		dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)
	
	NEXT
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("amount")	
	dw_ins.SetFocus()
ELSE
	dw_ins.SetRedraw(False)
	FOR k = 1 TO iFinanceRow
		iFindRow = dw_ins.Find("finance_cd = '"+dw_finance.GetItemString(k,"finance_cd")+"'",1,iRowCount)
		IF iFindRow <=0 THEN
			iCurRow = dw_ins.InsertRow(0)	
			
			dw_ins.SetItem(iCurRow,"finance_cd",dw_finance.GetItemString(k,"finance_cd"))
			
			dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
			dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
			dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
			dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
			dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)
		END IF
	NEXT
	dw_ins.SetSort("finance_cd A")
	dw_ins.Sort()
	
	dw_ins.SetRedraw(True)
	
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("amount")	
	dw_ins.SetFocus()
END IF

ib_changed   = False

end event

type p_exit from uo_picture within w_kglb017
integer x = 2025
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;String  sRtnValue,sChangeGbn
Double  dSumAmt
Integer iRowCount,k

dw_disp.AcceptText()
sChangeGbn = dw_disp.GetItemString(1,"changegbn")									/*대체 여부*/

dw_ins.AcceptText()

if sChangeGbn = 'Y' then
	iRowCount = dw_ins.RowCount()
	
	dw_ins.SetRedraw(False)
	FOR k = iRowCount TO 1 Step -1
		dw_ins.SetItem(k,  "amount",   0)
		
		IF Wf_RequiredChk(k) = -1 THEN 
			dw_ins.SetRedraw(True)
			Return	
		END IF
	NEXT
	dw_ins.SetRedraw(True)	
	
	IF F_DbConFirm('저장') = 2  then return
			
	IF dw_ins.Update() <> 1 THEN
		Rollback;
		F_messageChk(13,'')
		Return
	END IF
	
	sRtnValue = '1'
else
	IF ib_changed = True THEN
		iRowCount = dw_ins.RowCount()
		if iRowCount > 0 then
			dSumAmt = dw_ins.GetItemNumber(dw_ins.RowCount(),"sum_amt")
			IF IsNull(dSumAmt) THEN dSumAmt = 0
		else
			dSumAmt = 0
		end if
		IF dSumAmt <> lstr_jpra.money THEN
			F_MessageChk(37,'')
			Return	
		END IF		
		
		dw_ins.SetRedraw(False)
		FOR k = iRowCount TO 1 Step -1
			IF Wf_RequiredChk(k) = -1 THEN 
				dw_ins.SetRedraw(True)
				Return	
			END IF
		NEXT
		dw_ins.SetRedraw(True)	
			
		IF iRowCount > 0 THEN 	
			IF F_DbConFirm('저장') = 2  then return
			
			IF dw_ins.Update() <> 1 THEN
				Rollback;
				F_messageChk(13,'')
				Return
			END IF
		END IF
		sRtnValue = '1'
	ELSE
		iRowCount = dw_ins.RowCount()
		if iRowCount > 0 then
			dSumAmt = dw_ins.GetItemNumber(dw_ins.RowCount(),"sum_amt")
			IF IsNull(dSumAmt) THEN dSumAmt = 0
		else
			dSumAmt = 0
		end if
		
		IF dSumAmt = 0 THEN
			sRtnValue = '0'	
		ELSE
			IF dSumAmt <> lstr_jpra.money THEN
				F_MessageChk(37,'')
				Return	
			END IF
			sRtnValue = '1'	
		END IF
	END IF
end if

CloseWithReturn(parent,sRtnValue)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_kglb017
integer x = 1851
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;CloseWithReturn(parent,'0')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_finance from datawindow within w_kglb017
boolean visible = false
integer x = 2459
integer y = 524
integer width = 841
integer height = 1360
boolean titlebar = true
string title = "자금코드 조회"
string dataobject = "dw_kglb017_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ins from datawindow within w_kglb017
event ue_enterkey pbm_dwnprocessenter
integer x = 46
integer y = 232
integer width = 2126
integer height = 1792
integer taborder = 10
string dataobject = "dw_kglb017_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;IF this.GetRow() = this.RowCount() THEN
	Send(Handle(this),256,9,0)
END IF
end event

event editchanged;ib_changed = True
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;
String sSdeptcode,sNull

SetNull(sNull)

IF this.GetColumnName() = "sdept_cd" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
	   FROM "VW_CDEPT_CODE"  
   	WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(this.GetRow(),"sdept_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'amount' THEN
	IF IsNull(this.GetText()) THEN
		this.SetItem(this.GetRow(),"amount",0)
	END IF
END IF
ib_changed = True


end event

type dw_disp from datawindow within w_kglb017
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 8
integer width = 1838
integer height = 212
string dataobject = "dw_kglb017_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
IF this.GetColumnName() = "pum_text" THEN
ELSE
	Send(Handle(this),256,9,0)
	Return 1
END IF
end event

event itemfocuschanged;
IF this.GetColumnName() = "pum_text" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))	
END IF
end event

event itemerror;
Return 1
end event

type rr_1 from roundrectangle within w_kglb017
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 220
integer width = 2162
integer height = 1820
integer cornerheight = 40
integer cornerwidth = 55
end type

