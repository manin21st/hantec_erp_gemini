$PBExportHeader$w_kfic20.srw
$PBExportComments$보험대장등록
forward
global type w_kfic20 from w_inherite
end type
type dw_1 from datawindow within w_kfic20
end type
type dw_3 from datawindow within w_kfic20
end type
type dw_4 from datawindow within w_kfic20
end type
type cb_dw_4_ins from commandbutton within w_kfic20
end type
type cb_dw_4_del from commandbutton within w_kfic20
end type
type dw_2 from u_d_popup_sort within w_kfic20
end type
type gb_2 from groupbox within w_kfic20
end type
type rr_1 from roundrectangle within w_kfic20
end type
type rr_2 from roundrectangle within w_kfic20
end type
end forward

global type w_kfic20 from w_inherite
string title = "보험대장등록"
dw_1 dw_1
dw_3 dw_3
dw_4 dw_4
cb_dw_4_ins cb_dw_4_ins
cb_dw_4_del cb_dw_4_del
dw_2 dw_2
gb_2 gb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kfic20 w_kfic20

forward prototypes
public function integer wf_requirechk (integer icurrow)
public function integer wf_requirechk1 (integer icurrow1)
end prototypes

public function integer wf_requirechk (integer icurrow);string  sInsur_No,sInsur_Type,sInsur_Co,sInsur_Term1,sInsur_Term2
integer iInsur_amt,iInsur_Bill

dw_3.AcceptText()

sInsur_No    = dw_3.GetItemString(icurrow,"insur_no")
sInsur_Type  = dw_3.GetItemString(icurrow,"insur_type")
sInsur_Co    = dw_3.GetItemString(icurrow,"insur_co")
sInsur_Term1 = dw_3.GetItemString(icurrow,"insur_term1")
sInsur_Term2 = dw_3.GetItemString(icurrow,"insur_term2")
iInsur_Amt   = dw_3.GetItemNumber(icurrow,"insur_amt")
iInsur_Bill  = dw_3.GetItemNumber(icurrow,"insur_bill")

IF sInsur_No = "" OR IsNull(sInsur_No) THEN
	F_MessageChk(1,'[보험번호]')
	dw_3.SetColumn("insur_no")
	dw_3.SetFocus()
	Return -1
END IF

IF sInsur_Type = "" OR IsNull(sInsur_Type) THEN
	F_MessageChk(1,'[보험종류]')
	dw_3.SetColumn("insur_type")
	dw_3.SetFocus()
	Return -1
END IF

IF sInsur_Co = "" OR IsNull(sInsur_Co) THEN
	F_MessageChk(1,'[보험사]')
	dw_3.SetColumn("insur_Co")
	dw_3.SetFocus()
	Return -1
END IF

IF sInsur_Term1 = "" OR IsNull(sInsur_Term1) THEN
	F_MessageChk(1,'[보험기간]')
	dw_3.SetColumn("insur_term1")
	dw_3.SetFocus()
	Return -1
END IF

IF sInsur_Term2 = "" OR IsNull(sInsur_Term2) THEN
	F_MessageChk(1,'[보험기간]')
	dw_3.SetColumn("insur_term2")
	dw_3.SetFocus()
	Return -1
END IF

IF sInsur_Term1 >= sInsur_Term2 THEN
	F_MessageChk(1,'[보험기간]')
	dw_3.SetColumn("insur_term2")
	dw_3.SetFocus()
	Return -1
END IF

if f_datechk(sInsur_Term1) = -1 then 
	F_MessageChk(21, "[보험기간]")
	return -1
end if

if f_datechk(sInsur_Term2) = -1 then 
	F_MessageChk(21, "[보험기간]")
	return -1
end if

IF iInsur_Amt = 0 OR IsNull(iInsur_Amt) THEN
	F_MessageChk(1,'[보험금액]')
	dw_3.SetColumn("insur_amt")
	dw_3.SetFocus()
	Return -1
END IF

IF iInsur_Bill = 0 OR IsNull(iInsur_Bill) THEN
	F_MessageChk(1,'[보험료]')
	dw_3.SetColumn("insur_bill")
	dw_3.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_requirechk1 (integer icurrow1);string  sInsur_Good,sInsur_Amt
Integer sInsur_Seq

dw_4.AcceptText()

sInsur_Seq   = dw_4.GetItemNumber(icurrow1,"insur_seq")
sInsur_Good  = dw_4.GetItemString(icurrow1,"insur_good")
//sInsur_Amt    = dw_3.GetItemString(icurrow,"insur_amt")

IF sInsur_Seq = 0 OR IsNull(sInsur_Seq) THEN
	F_MessageChk(1,'[순 번]')
	dw_4.SetColumn("insur_seq")
	dw_4.SetFocus()
	Return -1
END IF

IF sInsur_Good = "" OR IsNull(sInsur_Good) THEN
	F_MessageChk(1,'[보험물건명]')
	dw_4.SetColumn("insur_good")
	dw_4.SetFocus()
	Return -1
END IF

Return 1
end function

on w_kfic20.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.dw_4=create dw_4
this.cb_dw_4_ins=create cb_dw_4_ins
this.cb_dw_4_del=create cb_dw_4_del
this.dw_2=create dw_2
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_4
this.Control[iCurrent+4]=this.cb_dw_4_ins
this.Control[iCurrent+5]=this.cb_dw_4_del
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_kfic20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.cb_dw_4_ins)
destroy(this.cb_dw_4_del)
destroy(this.dw_2)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;	
dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
dw_1.SetItem(1,"insur_term1", F_Today())

dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)

dw_2.sharedata(dw_3)

if dw_2.Retrieve(F_Today()) <=0 then
	dw_3.InsertRow(0)	
	
	p_del.enabled = false
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	
	p_can.enabled = false
	p_can.PictureName = "C:\erpman\image\취소_d.gif"
	
	p_addrow.enabled = false
	p_addrow.PictureName = "C:\erpman\image\행추가_d.gif"
	
	p_delrow.enabled = false
	p_delrow.PictureName = "C:\erpman\image\행삭제_d.gif"

else
		
   dw_4.Retrieve(dw_2.GetItemString(dw_2.getrow(),"insur_no"))
	dw_4.ScrollToRow(1)
	
	p_del.enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	
	p_can.enabled = True
	p_can.PictureName = "C:\erpman\image\취소_up.gif"
	
	p_addrow.enabled = True
	p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"
	
	p_delrow.enabled = True
	p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"

end if

dw_1.SetColumn("insur_term1")
dw_1.SetFocus()






end event

type dw_insert from w_inherite`dw_insert within w_kfic20
boolean visible = false
integer x = 69
integer y = 2640
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfic20
integer x = 3401
end type

event p_delrow::clicked;call super::clicked;Integer k,IRow

IF dw_4.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_4.DeleteRow(0)

  

end event

type p_addrow from w_inherite`p_addrow within w_kfic20
integer x = 3227
end type

event p_addrow::clicked;call super::clicked;long    iCurRow,iCurRow1,iFunctionValue1
String  sInsur_no

 IF dw_4.RowCount() > 0 THEN
	  iFunctionValue1 = Wf_RequireChk1(dw_4.GetRow())
	  IF iFunctionValue1 <> 1 THEN RETURN
  ELSE
  	iFunctionValue1 = 1	
  END IF

  IF iFunctionValue1 = 1 THEN
     sInsur_no = dw_3.GetItemString(dw_3.GetRow(),"insur_no")
     iCurRow = dw_4.InsertRow(0)

     dw_4.ScrollToRow(iCurRow)
     dw_4.SetColumn("insur_seq")
     dw_4.SetFocus()

     dw_4.SetItem(iCurRow,"insur_no",sInsur_no)
     dw_4.SetItem(iCurRow,"insur_amt",0)
 END IF
 
end event

type p_search from w_inherite`p_search within w_kfic20
boolean visible = false
integer x = 3127
integer y = 2892
end type

type p_ins from w_inherite`p_ins within w_kfic20
integer x = 3749
end type

event p_ins::clicked;call super::clicked;long    iCurRow,iCurRow1,iRowCnt,iRrow
boolean result
integer iFunctionValue

  IF dw_3.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_3.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN

//     iRowCnt = dw_2.RowCount()
//     iRrow   = dw_2.GetRow()
//	  result  = dw_2.IsSelected(iRrow)
//     IF result THEN
//        dw_2.SelectRow(iRrow, FALSE)
//     ELSE
//	     dw_2.SelectRow(iRrow, TRUE)
//     END IF
//     
//	  dw_2.InsertRow(iRowCnt+1)
//	  dw_2.SelectRow(iRowCnt+1,True)
	  
	  iCurRow = dw_3.InsertRow(0)
	  dw_2.ScrollToRow(iCurRow)

	  dw_3.SetItem(iCurRow,"insur_amt",0)
	  dw_3.SetItem(iCurRow,"insur_rate",0)
	  dw_3.ScrollToRow(iCurRow)
	  dw_3.SetColumn("insur_no")
	  dw_3.SetFocus()

     dw_4.SetReDraw(False)
     dw_4.Reset() 
	  dw_4.SetReDraw(True)
     p_del.Enabled =True
	  p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	  p_can.Enabled =True
	  p_can.PictureName = "C:\erpman\image\취소_up.gif"
	  p_addrow.Enabled =True
	  p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"
	  p_delrow.Enabled =True
	  p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"

 END IF
	

end event

type p_exit from w_inherite`p_exit within w_kfic20
end type

type p_can from w_inherite`p_can within w_kfic20
end type

event p_can::clicked;call super::clicked;string sInsur_Term1,sInsur_No

w_mdi_frame.sle_msg.text =""

  dw_1.AcceptText()
  sInsur_Term1 =dw_1.GetItemString(1,"insur_term1")

IF dw_2.Retrieve(sInsur_Term1) > 0 THEN
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	
	dw_2.ScrollToRow(1)

   sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")
   dw_3.Retrieve(sInsur_No)
	dw_3.ScrollToRow(1)
	dw_3.SetColumn("insur_type")
	dw_3.SetFocus()

   dw_4.Retrieve(sInsur_No)
	dw_4.ScrollToRow(1)
	
ELSE
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
END IF
p_del.Enabled =True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

p_can.Enabled =True
p_can.PictureName = "C:\erpman\image\취소_up.gif"

p_addrow.Enabled =True
p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"

p_delrow.Enabled =True
p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"

end event

type p_print from w_inherite`p_print within w_kfic20
boolean visible = false
integer x = 3301
integer y = 2892
end type

type p_inq from w_inherite`p_inq within w_kfic20
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sInsur_Term1,sInsur_No
w_mdi_frame.sle_msg.text =""

IF dw_1.RowCount() <= 0 THEN 
	F_MessageChk(2,'[기준일자]')
	dw_1.SetColumn("insur_term1")
	dw_1.SetFocus()
	Return
END IF
	
dw_1.AcceptText()
sInsur_Term1 = Trim(dw_1.GetItemString(dw_1.GetRow(),"insur_term1"))

IF sInsur_Term1 = "" OR IsNull(sInsur_Term1) THEN
	F_MessageChk(1,'[기준일자]')
	dw_1.SetColumn("insur_term1")
	dw_1.SetFocus()
	Return 1
END IF

if f_datechk(sInsur_Term1) = -1 then 
	F_MessageChk(21, "[기준일자]")
	return -1
end if

IF dw_2.Retrieve(sInsur_Term1) > 0 THEN
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	
	dw_2.ScrollToRow(1)

   sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")
   dw_4.Retrieve(sInsur_No)
	dw_4.ScrollToRow(1)
	
ELSE
	dw_3.insertrow(0)
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
END IF
p_del.Enabled =True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

p_can.Enabled =True
p_can.PictureName = "C:\erpman\image\취소_up.gif"

p_addrow.Enabled =True
p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"

p_delrow.Enabled =True
p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"

end event

type p_del from w_inherite`p_del within w_kfic20
end type

event p_del::clicked;call super::clicked;Integer k,IRow,iRowCnt,iCount
 string sInsur_Term1,sInsur_No


IF dw_3.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_3.DeleteRow(0)

IF dw_3.Update() <> 1 THEN 
   f_messagechk(12,'')
	Rollback ;
	Return
END IF

iRowCnt = dw_4.RowCount()
if iRowCnt > 0 then
	for iCount = iRowCnt to 1 step -1
		 dw_4.DeleteRow(iCount)
	next
end if

IF dw_4.Update() <> 1 THEN
   f_messagechk(12,'')
	Rollback;
	Return
END IF

Commit 	;

w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"

sInsur_Term1 =dw_1.GetItemString(1,"insur_term1")
//dw_3.SetReDraw(False)
dw_3.Reset()          /*삭제후 clear*/
dw_2.Reset()
if dw_2.Retrieve(sInsur_Term1) > 0 then
   dw_2.SelectRow(1,True)

   sInsur_No =dw_2.GetItemString(dw_2.getrow(),"insur_no")
   dw_4.SetReDraw(False)
   dw_4.Reset() 
   dw_4.Retrieve(sInsur_No)
   dw_4.SetReDraw(True)

   dw_3.Retrieve(sInsur_No)
   dw_3.SetReDraw(True)
else
   dw_2.InsertRow(0)
   dw_3.InsertRow(0)
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
end if
end event

type p_mod from w_inherite`p_mod within w_kfic20
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue,iFunctionValue,iFunctionValue1
string  sSflag,sInsur_Term1,sInsur_No

  IF dw_3.AcceptText() = -1 THEN Return

  IF dw_3.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_3.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE 
	  iFunctionValue = 1	
  END IF

  IF dw_4.RowCount() > 0 THEN
	  iFunctionValue1 = Wf_RequireChk1(dw_4.GetRow())
	  IF iFunctionValue1 <> 1 THEN RETURN
  ELSE 
	  iFunctionValue1 = 1	
  END IF

 IF iFunctionValue = 1 THEN
    IF f_dbConFirm('저장') = 2 THEN RETURN

       IF dw_3.Update() <> 1 THEN
          f_messagechk(13,'')
	       Rollback;
	       Return
       END IF
END IF		
		
IF iFunctionValue1 = 1 THEN
   IF dw_4.Update() <> 1 THEN
      f_messagechk(13,'')
      Rollback;
      Return
	END IF  
END IF		

COMMIT;

w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"

dw_1.AcceptText()
sInsur_Term1 =dw_1.GetItemString(1,"insur_term1")

dw_2.Retrieve(sInsur_Term1)
sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")

dw_3.SetReDraw(False)
dw_3.Reset() 
dw_3.Retrieve(sInsur_No)
dw_3.SetReDraw(True) 

dw_4.SetReDraw(False)
dw_4.Reset() 
dw_4.Retrieve(sInsur_No)
dw_4.SetReDraw(True)
		
dw_2.SelectRow(0,False)
dw_2.ScrollToRow(1)
dw_2.SelectRow(1,True)
dw_2.SetColumn("insur_no")
dw_2.SetFocus()

end event

type cb_exit from w_inherite`cb_exit within w_kfic20
boolean visible = false
integer x = 3305
integer y = 2680
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_kfic20
boolean visible = false
integer x = 2222
integer y = 2680
integer taborder = 70
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue,iFunctionValue,iFunctionValue1
string  sSflag,sInsur_Term1,sInsur_No

  IF dw_3.AcceptText() = -1 THEN Return

  IF dw_3.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_3.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE 
	  iFunctionValue = 1	
  END IF

  IF dw_4.RowCount() > 0 THEN
	  iFunctionValue1 = Wf_RequireChk1(dw_4.GetRow())
	  IF iFunctionValue1 <> 1 THEN RETURN
  ELSE 
	  iFunctionValue1 = 1	
  END IF

 IF iFunctionValue = 1 THEN
    IF f_dbConFirm('저장') = 2 THEN RETURN

       IF dw_3.Update() <> 1 THEN
          f_messagechk(13,'')
	       Rollback;
	       Return
       END IF
END IF		
		
IF iFunctionValue1 = 1 THEN
   IF dw_4.Update() <> 1 THEN
      f_messagechk(13,'')
      Rollback;
      Return
	END IF  
END IF		

COMMIT;

sle_msg.text ="자료가 저장되었습니다.!!!"

dw_1.AcceptText()
sInsur_Term1 =dw_1.GetItemString(1,"insur_term1")

dw_2.Retrieve(sInsur_Term1)
sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")

dw_3.SetReDraw(False)
dw_3.Reset() 
dw_3.Retrieve(sInsur_No)
dw_3.SetReDraw(True) 

dw_4.SetReDraw(False)
dw_4.Reset() 
dw_4.Retrieve(sInsur_No)
dw_4.SetReDraw(True)
		
dw_2.SelectRow(0,False)
dw_2.ScrollToRow(1)
dw_2.SelectRow(1,True)
dw_2.SetColumn("insur_no")
dw_2.SetFocus()

end event

type cb_ins from w_inherite`cb_ins within w_kfic20
boolean visible = false
integer x = 549
integer y = 2680
integer taborder = 90
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;long    iCurRow,iCurRow1,iRowCnt,iRrow
boolean result
integer iFunctionValue

  IF dw_3.RowCount() > 0 THEN
	  iFunctionValue = Wf_RequireChk(dw_3.GetRow())
	  IF iFunctionValue <> 1 THEN RETURN
  ELSE
  	iFunctionValue = 1	
  END IF

  IF iFunctionValue = 1 THEN

     iRowCnt = dw_2.RowCount()
     iRrow   = dw_2.GetRow()
	  result  = dw_2.IsSelected(iRrow)
     IF result THEN
        dw_2.SelectRow(iRrow, FALSE)
     ELSE
	     dw_2.SelectRow(iRrow, TRUE)
     END IF
     
	  dw_2.InsertRow(iRowCnt+1)
	  dw_2.SelectRow(iRowCnt+1,True)
	  
	  iCurRow = dw_3.InsertRow(0)

	  dw_3.SetItem(iCurRow,"insur_amt",0)
	  dw_3.SetItem(iCurRow,"insur_rate",0)
	  dw_3.ScrollToRow(iCurRow)
	  dw_3.SetColumn("insur_no")
	  dw_3.SetFocus()

     dw_4.SetReDraw(False)
     dw_4.Reset() 
	  dw_4.SetReDraw(True)
     cb_del.enabled = true
     cb_can.enabled = true
     cb_dw_4_ins.enabled = true
     cb_dw_4_del.enabled = true

 END IF
	

end event

type cb_del from w_inherite`cb_del within w_kfic20
boolean visible = false
integer x = 2583
integer y = 2680
integer taborder = 80
end type

event cb_del::clicked;call super::clicked;Integer k,IRow,iRowCnt,iCount
 string sInsur_Term1,sInsur_No


IF dw_3.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_3.DeleteRow(0)

IF dw_3.Update() <> 1 THEN 
   f_messagechk(12,'')
	Rollback ;
	Return
END IF

iRowCnt = dw_4.RowCount()
if iRowCnt > 0 then
	for iCount = iRowCnt to 1 step -1
		 dw_4.DeleteRow(iCount)
	next
end if

IF dw_4.Update() <> 1 THEN
   f_messagechk(12,'')
	Rollback;
	Return
END IF

Commit 	;

sle_msg.text ="자료가 삭제되었습니다.!!!"

sInsur_Term1 =dw_1.GetItemString(1,"insur_term1")
//dw_3.SetReDraw(False)
dw_3.Reset()          /*삭제후 clear*/
dw_2.Reset()
if dw_2.Retrieve(sInsur_Term1) > 0 then
   dw_2.SelectRow(1,True)

   sInsur_No =dw_2.GetItemString(1,"insur_no")
   dw_4.SetReDraw(False)
   dw_4.Reset() 
   dw_4.Retrieve(sInsur_No)
   dw_4.SetReDraw(True)

   dw_3.Retrieve(sInsur_No)
   dw_3.SetReDraw(True)
else
   dw_2.InsertRow(0)
   dw_3.InsertRow(0)
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
end if
end event

type cb_inq from w_inherite`cb_inq within w_kfic20
boolean visible = false
integer x = 192
integer y = 2680
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String sInsur_Term1,sInsur_No
sle_msg.text =""

IF dw_1.RowCount() <= 0 THEN 
	F_MessageChk(2,'[기준일자]')
	dw_1.SetColumn("insur_term1")
	dw_1.SetFocus()
	Return
END IF
	
dw_1.AcceptText()
sInsur_Term1 = Trim(dw_1.GetItemString(dw_1.GetRow(),"insur_term1"))

IF sInsur_Term1 = "" OR IsNull(sInsur_Term1) THEN
	F_MessageChk(1,'[기준일자]')
	dw_1.SetColumn("insur_term1")
	dw_1.SetFocus()
	Return 1
END IF

if f_datechk(sInsur_Term1) = -1 then 
	F_MessageChk(21, "[기준일자]")
	return -1
end if

IF dw_2.Retrieve(sInsur_Term1) > 0 THEN
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	
	dw_2.ScrollToRow(1)

   sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")
   dw_3.Retrieve(sInsur_No)
	dw_3.ScrollToRow(1)
	dw_3.SetColumn("insur_type")
	dw_3.SetFocus()

   dw_4.Retrieve(sInsur_No)
	dw_4.ScrollToRow(1)
	
ELSE
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
END IF
cb_del.enabled = true
cb_can.enabled = true
cb_dw_4_ins.enabled = true
cb_dw_4_del.enabled = true

end event

type cb_print from w_inherite`cb_print within w_kfic20
integer x = 1216
integer y = 2952
end type

type st_1 from w_inherite`st_1 within w_kfic20
boolean visible = false
integer x = 23
integer y = 2720
end type

type cb_can from w_inherite`cb_can within w_kfic20
boolean visible = false
integer x = 2944
integer y = 2680
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;string sInsur_Term1,sInsur_No
sle_msg.text =""

  dw_1.AcceptText()
  sInsur_Term1 =dw_1.GetItemString(1,"insur_term1")

IF dw_2.Retrieve(sInsur_Term1) > 0 THEN
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	
	dw_2.ScrollToRow(1)

   sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")
   dw_3.Retrieve(sInsur_No)
	dw_3.ScrollToRow(1)
	dw_3.SetColumn("insur_type")
	dw_3.SetFocus()

   dw_4.Retrieve(sInsur_No)
	dw_4.ScrollToRow(1)
	
ELSE
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
END IF
cb_del.enabled = true
cb_can.enabled = true
cb_dw_4_ins.enabled = true
cb_dw_4_del.enabled = true

dw_4.SetReDraw(False)
dw_4.Reset() 

end event

type cb_search from w_inherite`cb_search within w_kfic20
integer x = 1509
integer y = 2796
end type

type dw_datetime from w_inherite`dw_datetime within w_kfic20
boolean visible = false
integer x = 2843
integer y = 2716
end type

type sle_msg from w_inherite`sle_msg within w_kfic20
boolean visible = false
integer x = 375
integer y = 2720
integer width = 2464
end type

type gb_10 from w_inherite`gb_10 within w_kfic20
boolean visible = false
integer x = 5
integer y = 2668
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_kfic20
boolean visible = false
integer x = 155
integer y = 2628
end type

type gb_button2 from w_inherite`gb_button2 within w_kfic20
boolean visible = false
integer x = 2190
integer y = 2628
end type

type dw_1 from datawindow within w_kfic20
integer x = 480
integer y = 48
integer width = 1239
integer height = 132
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfic20_a"
boolean border = false
end type

event itemchanged;String sInsur_Term1,sInsur_No
w_mdi_frame.sle_msg.text =""

IF dw_1.RowCount() <= 0 THEN 
	F_MessageChk(2,'[기준일자]')
	dw_1.SetColumn("insur_term1")
	dw_1.SetFocus()
	Return 1
END IF
	
dw_1.AcceptText()
sInsur_Term1 =dw_1.GetItemString(dw_1.GetRow(),"insur_term1")

IF sInsur_Term1 = "" OR IsNull(sInsur_Term1) THEN
	F_MessageChk(1,'[기준일자]')
	dw_1.SetColumn("insur_term1")
	dw_1.SetFocus()
	Return 1
END IF

if f_datechk(sInsur_Term1) = -1 then 
	F_MessageChk(21, "[기준일자]")
	return -1
end if

IF dw_2.Retrieve(sInsur_Term1) > 0 THEN
	dw_2.SelectRow(0,False)
	dw_2.SelectRow(1,True)
	
	dw_2.ScrollToRow(1)

   sInsur_No = dw_2.GetItemString(dw_2.GetRow(),"insur_no")
   dw_3.Retrieve(sInsur_No)
	dw_3.ScrollToRow(1)
	dw_3.SetColumn("insur_type")
	dw_3.SetFocus()
	
   dw_4.Retrieve(sInsur_No)
	dw_4.ScrollToRow(1)

ELSE
	dw_3.InsertRow(0)
	dw_3.SetColumn("insur_no")
   dw_3.SetFocus()	
	
	dw_4.Reset()
END IF
p_del.Enabled =True
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

p_can.Enabled =True
p_can.PictureName = "C:\erpman\image\취소_up.gif"

p_addrow.Enabled =True
p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"

p_delrow.Enabled =True
p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"



end event

type dw_3 from datawindow within w_kfic20
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 1847
integer y = 192
integer width = 2158
integer height = 1212
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kfic20_c"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;this.accepttext()

IF this.GetColumnName() = "insur_co" THEN
	SetNUll(lstr_custom.code)
	SetNUll(lstr_custom.name)

   lstr_custom.code = this.GetItemString(this.GetRow(),"insur_co")
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ''

	OpenWithParm(w_kfz04om0_popup, '2')
	
   if Not IsNull(lstr_custom.code) then
		this.SetItem(this.GetRow(),'insur_co', lstr_custom.code)
		this.SetItem(this.GetRow(), 'insur_conm', lstr_custom.name)
//      this.TriggerEvent(ItemChanged!)
   end if

END IF

end event

event itemerror;return 1
end event

event itemchanged;String sNull,sInsur_No,sInsur_Good,sInsur_Type,sInsur_Type_Nm,sInsur_Term1,sInsur_Term2,sInsur_FreeDate
String sInsur_Co,sInsur_CoNm
Long ll_Row

SetNull(sNull)

IF this.GetColumnName() = "insur_no" THEN
	sInsur_No = this.GetText() 
   if sInsur_No = '' or isnull(sInsur_No) then return
   SELECT "KFM21M"."INSUR_GOOD"
	  INTO :sInsur_Good
	  FROM "KFM21M"
	 WHERE "KFM21M"."INSUR_NO" = :sInsur_No;
    If Sqlca.Sqlcode = 0 then
  		f_messagechk(10,'[보험번호]')
		Return 1
	 END IF	
END IF

IF this.GetColumnName() = "insur_type" THEN 
   sInsur_Type = this.GetText()
		
   SELECT "REFFPF"."RFGUB"
     INTO :sInsur_Type_Nm
     FROM "REFFPF"  
    WHERE "REFFPF"."RFCOD" ='IS' AND
          "REFFPF"."RFGUB" =:sInsur_Type  ; 

   If Sqlca.Sqlcode <> 0 then
		f_messagechk(20,'[보험 종류]')
      this.Setitem(this.getrow(),"insur_type",sNull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "insur_co" THEN
   sInsur_Co = this.GetText()
	
	if sinsur_co = '' or isnull(sinsur_co) then
		this.Setitem(this.getrow(),"insur_conm",snull)
	end if

   SELECT "KFZ04OM0"."PERSON_NM"
     INTO :sInsur_CoNm
     FROM "KFZ04OM0"  
    WHERE "KFZ04OM0"."PERSON_CD" = :sInsur_Co
	   AND "KFZ04OM0"."PERSON_GU" = '2';
   If Sqlca.Sqlcode = 0 then
	      this.Setitem(this.getrow(),"insur_conm",sInsur_CoNm)
	else
//  		f_messagechk(11,'[보험사]')
      this.Setitem(this.getrow(),"insur_co",sNull)
      this.Setitem(this.getrow(),"insur_conm",sNull)
		Return 
	END IF	
END IF

sInsur_Term1 = this.GetItemString(this.getrow(),"insur_term1")

IF this.GetColumnName() = "insur_term2" THEN 
   sInsur_Term2 = this.GetText()
   if sInsur_Term1 >= sInsur_Term2 then
		f_messagechk(21,'[보험기간]')
      this.Setitem(this.getrow(),"insur_term2",sNull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "insur_freedate" THEN 
   sInsur_FreeDate = this.GetText()
   if sInsur_FreeDate >= sInsur_Term2 then
		f_messagechk(21,'[보험해지일]')
      this.Setitem(this.getrow(),"insur_freedate",sNull)
		Return 1
	END IF	
END IF


end event

type dw_4 from datawindow within w_kfic20
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 1883
integer y = 1424
integer width = 2171
integer height = 780
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kfic20_d"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

type cb_dw_4_ins from commandbutton within w_kfic20
boolean visible = false
integer x = 1317
integer y = 2680
integer width = 389
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "줄추가(&I)"
end type

event clicked;long    iCurRow,iCurRow1,iFunctionValue1
String  sInsur_no

 IF dw_4.RowCount() > 0 THEN
	  iFunctionValue1 = Wf_RequireChk1(dw_4.GetRow())
	  IF iFunctionValue1 <> 1 THEN RETURN
  ELSE
  	iFunctionValue1 = 1	
  END IF

  IF iFunctionValue1 = 1 THEN
     sInsur_no = dw_3.GetItemString(dw_3.GetRow(),"insur_no")
     iCurRow = dw_4.InsertRow(0)

     dw_4.ScrollToRow(iCurRow)
     dw_4.SetColumn("insur_seq")
     dw_4.SetFocus()

     dw_4.SetItem(iCurRow,"insur_no",sInsur_no)
     dw_4.SetItem(iCurRow,"insur_amt",0)
 END IF
 
end event

type cb_dw_4_del from commandbutton within w_kfic20
boolean visible = false
integer x = 1733
integer y = 2680
integer width = 389
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "줄삭제(&E)"
end type

event clicked;Integer k,IRow

IF dw_4.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return 
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_4.DeleteRow(0)

  

end event

type dw_2 from u_d_popup_sort within w_kfic20
integer x = 443
integer y = 208
integer width = 1381
integer height = 2000
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_kfic20_b"
boolean border = false
end type

event clicked;String sInsur_No
Long ll_Row

If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_3.ScrollToRow(row)
	sInsur_No = GetItemString(row,"insur_no")
			 
	dw_4.Retrieve(sInsur_No)
	
	p_del.enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	
	p_can.enabled = True
	p_can.PictureName = "C:\erpman\image\취소_up.gif"
	
	p_addrow.enabled = True
	p_addrow.PictureName = "C:\erpman\image\행추가_up.gif"
	
	p_delrow.enabled = True
	p_delrow.PictureName = "C:\erpman\image\행삭제_up.gif"
//	Lb_AutoFlag = False
	
	b_flag = False
	
//	smodstatus="M"
//	wf_setting_retrievemode(smodstatus)
END IF

CALL SUPER ::CLICKED


end event

event rowfocuschanged;call super::rowfocuschanged;string sInsur_No

If currentrow <= 0 then
	dw_3.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_3.ScrollToRow(currentrow)
	
	sInsur_No = GetItemString(currentrow,"insur_no")
			 
	dw_4.Retrieve(sInsur_No)
	
END IF

end event

type gb_2 from groupbox within w_kfic20
boolean visible = false
integer x = 1280
integer y = 2628
integer width = 887
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfic20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1874
integer y = 1416
integer width = 2208
integer height = 804
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kfic20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 434
integer y = 200
integer width = 1399
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 46
end type

