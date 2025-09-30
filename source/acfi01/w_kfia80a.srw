$PBExportHeader$w_kfia80a.srw
$PBExportComments$어음수표책 -생성
forward
global type w_kfia80a from window
end type
type p_exit from uo_picture within w_kfia80a
end type
type p_can from uo_picture within w_kfia80a
end type
type dw_1 from u_key_enter within w_kfia80a
end type
type dw_update from datawindow within w_kfia80a
end type
end forward

global type w_kfia80a from window
integer x = 800
integer y = 476
integer width = 1618
integer height = 776
boolean titlebar = true
string title = "어음/수표책 생성"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
dw_1 dw_1
dw_update dw_update
end type
global w_kfia80a w_kfia80a

type variables
Boolean itemerr =False
s_us_in lstr_us_in                 //어음수표

end variables

event open;string  schk_no
Integer iFindPos

f_window_center_Response(this)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()

dw_1.SetRedraw(False)
   
SELECT MAX("KFM06OT0"."CHECK_NO") INTO :schk_no  FROM "KFM06OT0"  ;
IF SQLCA.SQLCODE <> 0 THEN
	sChk_No = ''
ELSE
	If IsNull(sChk_no) then sChk_no = ''
END IF

sChk_no = Mid(sChk_No,Pos(sChk_no,' ') + 1,10) 

dw_1.InsertRow(0)
dw_1.SetItem(dw_1.GetRow(),"check_no1", sChk_No)
dw_1.SetItem(dw_1.GetRow(),"pur_date",  F_Today())	
dw_1.SetRedraw(True)

dw_1.SetColumn("check_bnk")
dw_1.SetFocus()


end event

on w_kfia80a.create
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_1=create dw_1
this.dw_update=create dw_update
this.Control[]={this.p_exit,&
this.p_can,&
this.dw_1,&
this.dw_update}
end on

on w_kfia80a.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_1)
destroy(this.dw_update)
end on

type p_exit from uo_picture within w_kfia80a
integer x = 1207
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event clicked;
Integer  iCount,i,irow,iLength
Double   dCheckNo
String   sNewChkNo,sBillFirst

dw_update.SetTransObject(SQLCA)

select dataname into :sBillFirst from syscnfg where sysgu = 'A' and serial = 1 and lineno = '99';

IF dw_1.AcceptText() = -1 then return 

lstr_us_in.schk_bnk  = dw_1.GetitemString(1, "check_bnk")
lstr_us_in.schk_gu   = dw_1.GetitemString(1, "check_gu")
lstr_us_in.spur_date = Trim(dw_1.GetitemString(1, "pur_date"))
lstr_us_in.schk_no1  = Trim(dw_1.GetitemString(1, "check_no1"))
iCount               = dw_1.GetitemNumber(1, "count")

IF lstr_us_in.schk_bnk ="" OR ISNULL(lstr_us_in.schk_bnk) THEN
	F_MessageChk(1,'[금융기관]')
   dw_1.SetColumn("check_bnk")
   dw_1.SetFocus()
   Return 1
END IF

IF lstr_us_in.spur_date ="" OR ISNULL(lstr_us_in.spur_date) THEN
	F_MessageChk(1,'[매입일자]')
   dw_1.SetColumn("pur_date")
   dw_1.SetFocus()
   Return 1
ELSE
	IF f_datechk(lstr_us_in.spur_date) = -1 THEN
		MessageBox("확인", "매입일자를 확인하십시오.!!")
		dw_1.SetColumn("pur_date")
		dw_1.SetFocus()
		Return 1
	END IF

	lstr_us_in.spur_date2 = lstr_us_in.spur_date
END IF  

IF lstr_us_in.schk_no1 ="" OR ISNULL(lstr_us_in.schk_no1) THEN
	F_MessageChk(1,'[용지번호]')
   dw_1.SetColumn("check_no1")
   dw_1.SetFocus()
   Return 1
ELSE
	iLength = Len(lstr_us_in.schk_no1)
	dCheckNo = Double(lstr_us_in.schk_no1)
END IF

if IsNull(iCount) or iCount = 0 then
	F_MessageChk(1,'[장수]')
   dw_1.SetColumn("count")
   dw_1.SetFocus()
   Return 1
end if

String sForMat
For i = 1 To iCount
	dCheckNo = dCheckNo + 1
	
	sForMat = Fill("0", iLength)
	
	sNewChkNo = String(dCheckNo,sForMat)
	
	if lstr_us_in.schk_gu = '2' then
		sNewChkNo = sBillFirst + sNewChkNo
	end if
	
	irow = dw_update.insertrow(0) 
	dw_update.SetItem(irow, "check_no",  sNewChkNo)
	dw_update.SetItem(irow, "check_bnk", lstr_us_in.schk_bnk)
	dw_update.SetItem(irow, "check_gu",  lstr_us_in.schk_gu)
	dw_update.SetItem(irow, "pur_date",  lstr_us_in.spur_date)
	dw_update.SetItem(irow, "use_gu",    '0') 
Next

if iRow > 0 then
	IF dw_update.Update() <> 1 THEN
		F_MessageChk(13,'')
		ROLLBACK;
		RETURN
	END IF
end if

lstr_us_in.suse_gu = '0'  
lstr_us_in.flag = '1'  

CloseWithReturn(parent, lstr_us_in)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_can from uo_picture within w_kfia80a
integer x = 1381
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;
lstr_us_in.flag = '2'  
closeWithReturn(parent, lstr_us_in)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_1 from u_key_enter within w_kfia80a
integer x = 32
integer y = 152
integer width = 1541
integer height = 472
integer taborder = 10
string dataobject = "dw_kfia80a"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;String sChkNo,sNull,sNo,sSaupNo,sSaupName

SetNull(sNull)

IF this.GetColumnName() ="check_bnk" THEN
	sSaupNo = this.GetText()
	IF sSaupNo ="" OR IsNull(sSaupNo) THEN RETURN 
	
	sSaupName = F_Get_PersonLst('2',sSaupNo,'%')
	IF sSaupName = '' or IsNull(sSaupName) THEN
		f_messagechk(20,"[금융기관]")
		dw_1.SetItem(1,"check_bnk",snull)
		Return 1
   END IF
END IF
IF this.GetColumnName() ="pur_date" THEN
	IF this.GetText() ="" OR IsNull(this.GetText()) THEN RETURN 
	
	IF f_datechk(this.GetText()) = -1 THEN 
		f_messagechk(20,"매입일자")
		dw_1.SetItem(1,"pur_date",snull)
		Return 1
	END IF
END IF


if this.GetColumnName() = "check_no1" then
	sChkNo = this.GetText()
	if sChkNo = '' or IsNull(sChkNo) then Return
	
	select nvl(MAX("KFM06OT0"."CHECK_NO"),'0000000001') into :sNo from kfm06ot0 ;
	if sqlca.sqlcode = 0 then
		if sno = string(long(schkno) + 1, '0000000000') then
			F_MessageChk(10,'')
			this.SetItem(this.GetRow(),"check_no1", sNull)
			Return 1
		end if
	end if
end if
end event

type dw_update from datawindow within w_kfia80a
boolean visible = false
integer x = 64
integer y = 628
integer width = 1417
integer height = 180
boolean titlebar = true
string title = "어음수표책입력"
string dataobject = "dw_kfia10_popup1"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

