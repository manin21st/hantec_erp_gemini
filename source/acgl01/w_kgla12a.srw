$PBExportHeader$w_kgla12a.srw
$PBExportComments$거래처 기초잔액 등록
forward
global type w_kgla12a from window
end type
type p_exit from uo_picture within w_kgla12a
end type
type p_can from uo_picture within w_kgla12a
end type
type p_del from uo_picture within w_kgla12a
end type
type p_mod from uo_picture within w_kgla12a
end type
type p_search from uo_picture within w_kgla12a
end type
type p_ins from uo_picture within w_kgla12a
end type
type cb_del from commandbutton within w_kgla12a
end type
type dw_cust from datawindow within w_kgla12a
end type
type cb_cust from commandbutton within w_kgla12a
end type
type cb_exit from commandbutton within w_kgla12a
end type
type cb_cancel from commandbutton within w_kgla12a
end type
type cb_save from commandbutton within w_kgla12a
end type
type cb_add from commandbutton within w_kgla12a
end type
type dw_cond from u_key_enter within w_kgla12a
end type
type gb_2 from groupbox within w_kgla12a
end type
type gb_1 from groupbox within w_kgla12a
end type
type rr_1 from roundrectangle within w_kgla12a
end type
type dw_ins from u_key_enter within w_kgla12a
end type
end forward

global type w_kgla12a from window
integer x = 46
integer y = 64
integer width = 4503
integer height = 2208
boolean titlebar = true
string title = "거래처 기초잔고 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_search p_search
p_ins p_ins
cb_del cb_del
dw_cust dw_cust
cb_cust cb_cust
cb_exit cb_exit
cb_cancel cb_cancel
cb_save cb_save
cb_add cb_add
dw_cond dw_cond
gb_2 gb_2
gb_1 gb_1
rr_1 rr_1
dw_ins dw_ins
end type
global w_kgla12a w_kgla12a

type variables
Boolean     ib_any_typing
S_JanGo   Str_JanGo
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
end prototypes

public function integer wf_requiredchk (integer irow);String   sSaupNo,sRemark4
Integer  iCount
Decimal   dDbJan,dDbYjan,dDrAmt,dCrAmt,dJanAmt,dYdramt,dYcramt,dYjanamt

dw_ins.AcceptText()
sSaupNo  = dw_ins.GetItemString(irow,"saup_no")
sRemark4 = dw_ins.GetItemString(irow,"remark4")

if sSaupNo = '' OR IsNull(sSaupNo) then
	F_MessageChk(1,'[거래처]')
	dw_ins.ScrollToRow(irow)	
	dw_ins.SetColumn("saup_no")
	dw_ins.SetFocus()
	Return -1
end if

if sRemark4 = 'Y' then									/*외화잔고 관리*/
	dJanAmt   = dw_ins.GetItemDecimal(iRow,"jan_amt")
	dyJanAmt  = dw_ins.GetItemDecimal(iRow,"yjan_amt")

	IF IsNull(dJanAmt) THEN dJanAmt = 0
	IF IsNull(dyJanAmt) THEN dyJanAmt = 0

	select Count(*),  sum(nvl(jan_amt,0)),	sum(nvl(yjan_amt,0))	
		into :iCount,	:dDbJan,					:dDbYJan
		from kfz13ot2
		where saupj   = :Str_JanGo.saupj   and acc_yy  = :Str_JanGo.acc_yy  and acc_mm = :Str_JanGo.acc_mm and
				acc1_cd = :Str_JanGo.acc1_cd and acc2_cd = :Str_JanGo.acc2_cd and saup_no = :sSaupNo;
	if sqlca.sqlcode = 0 and iCount <=0 and dJanAmt <> 0 then
		F_MessageChk(1,'[상세입력(외화관리=Y)]')
		dw_ins.ScrollToRow(irow)	
		dw_ins.SetColumn("dr_amt")
		dw_ins.SetFocus()
		Return -1
	end if
	if IsNull(dDbJan) then dDbJan = 0
	if IsNull(dDbYJan) then dDbYJan = 0
	
	if (dDbJan <> dJanAmt) 	or (Truncate(dDbYJan,2) <> Truncate(dYJanAmt,2)) then
		MessageBox('확 인','상세 자료와의 합이 다릅니다...')
		dw_ins.ScrollToRow(irow)	
		dw_ins.SetColumn("dr_amt")
		dw_ins.SetFocus()
		Return -1
	end if
end if
Return 1
end function

on w_kgla12a.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_search=create p_search
this.p_ins=create p_ins
this.cb_del=create cb_del
this.dw_cust=create dw_cust
this.cb_cust=create cb_cust
this.cb_exit=create cb_exit
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.cb_add=create cb_add
this.dw_cond=create dw_cond
this.gb_2=create gb_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.dw_ins=create dw_ins
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_search,&
this.p_ins,&
this.cb_del,&
this.dw_cust,&
this.cb_cust,&
this.cb_exit,&
this.cb_cancel,&
this.cb_save,&
this.cb_add,&
this.dw_cond,&
this.gb_2,&
this.gb_1,&
this.rr_1,&
this.dw_ins}
end on

on w_kgla12a.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_search)
destroy(this.p_ins)
destroy(this.cb_del)
destroy(this.dw_cust)
destroy(this.cb_cust)
destroy(this.cb_exit)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.cb_add)
destroy(this.dw_cond)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.dw_ins)
end on

event open;
F_Window_Center_Response(This)

dw_cond.SetTransObject(Sqlca)
dw_cond.Reset()

dw_ins.SetTransObject(Sqlca)
dw_ins.Reset()

dw_cust.SetTransObject(Sqlca)
dw_cust.Reset()

Str_JanGo = Message.PowerObjectParm

dw_cond.Retrieve(Str_JanGo.acc1_cd,Str_JanGo.acc2_cd)
dw_cond.SetItem(1,"saupj",   Str_JanGo.saupj)
dw_cond.SetItem(1,"acc_yy",  Str_JanGo.acc_yy)
dw_cond.SetItem(1,"acc_mm",  Str_JanGo.acc_mm)

dw_ins.Retrieve(Str_JanGo.saupj,Str_JanGo.acc_yy,Str_JanGo.acc_mm,Str_JanGo.acc1_cd,Str_JanGo.acc2_cd)

ib_any_typing =False

end event

type p_exit from uo_picture within w_kgla12a
integer x = 4251
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;
IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인
	IF MessageBox("확인 : ",&
		 			  "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 																			question!, yesno!) = 1 THEN

		RETURN 									
	ELSE
		Rollback;
	END IF

END IF
Close(w_kgla12a)
end event

type p_can from uo_picture within w_kgla12a
integer x = 4078
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;dw_ins.Retrieve(Str_JanGo.saupj,Str_JanGo.acc_yy,Str_JanGo.acc_mm,Str_JanGo.acc1_cd,Str_JanGo.acc2_cd)

ib_any_typing =False

end event

type p_del from uo_picture within w_kgla12a
integer x = 3904
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;Integer k

IF dw_ins.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ins.DeleteRow(dw_ins.GetRow())
IF dw_ins.Update() = 1 THEN
	commit;
	
//	FOR k = 1 TO dw_ins.RowCount()
//		dw_ins.SetItem(k,'sflag','M')
//	NEXT
	
	dw_ins.SetColumn("dr_amt")
	dw_ins.SetFocus()
	
	ib_any_typing = False
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from uo_picture within w_kgla12a
integer x = 3730
integer y = 28
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;Integer k

IF dw_ins.RowCount() > 0 THEN
	FOR k = 1 TO dw_ins.RowCount()
		IF Wf_RequiredChk(k) = -1 THEN Return	
	NEXT
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_ins.Update() <> 1 Then
   f_messagechk(13,"") 
   dw_ins.SetFocus()
   Rollback;
	Return
END IF
Commit;
ib_any_typing = False



end event

type p_search from uo_picture within w_kgla12a
integer x = 3429
integer y = 28
integer width = 306
integer taborder = 90
string picturename = "C:\Erpman\image\거래처가져오기_up.gif"
end type

event clicked;call super::clicked;Integer iCount,iFindRow,k,iLstCnt,iCurRow
String  sCust

setnull(lstr_custom.code)
setnull(lstr_custom.name)

iLstCnt = dw_ins.RowCount()
if iLstCnt > 0 then 
	IF Wf_Requiredchk(dw_ins.GetRow()) = -1 THEN Return
end if

IF dw_ins.getrow() <= 0 THEN
	lstr_custom.code = ""
ELSE
	lstr_custom.code = dw_ins.object.saup_no[dw_ins.getrow()]
END IF

OpenWithParm(w_kgla12a_popup,dw_cond.GetItemString(1,"gbn1"))

IF Message.StringParm = '0' THEN Return

dw_cust.Reset()
dw_cust.ImportClipboard()

iCount = dw_cust.RowCount()
FOR k = 1 TO iCount
	sCust = dw_cust.GetItemString(k,"person_cd")
	
	iFindRow = dw_ins.find("saup_no ='" + sCust + "'", 1, iLstCnt)
	IF iFindRow <=0 THEN
		iCurRow = dw_ins.InsertRow(0)
		
		dw_ins.SetItem(iCurRow,"saupj",  Str_JanGo.saupj)
		dw_ins.SetItem(iCurRow,"acc_yy", Str_JanGo.acc_yy)
		dw_ins.SetItem(iCurRow,"acc_mm", Str_JanGo.acc_mm)
		dw_ins.SetItem(iCurRow,"acc1_cd",Str_JanGo.acc1_cd)
		dw_ins.SetItem(iCurRow,"acc2_cd",Str_JanGo.acc2_cd)

		dw_ins.SetItem(iCurRow,"saup_no", sCust)
		dw_ins.SetItem(iCurRow,"cvname",  dw_cust.GetItemString(k,"person_nm"))
		dw_ins.SetItem(iCurRow,"gbn1",    dw_cond.GetItemString(1,"gbn1"))
		dw_ins.SetItem(iCurRow,"remark4", dw_cond.GetItemString(1,"remark4"))
		dw_ins.SetItem(iCurRow,"dc_gu",   dw_cond.GetItemString(1,"dc_gu"))
		
		ib_any_typing = True
	END IF
NEXT
dw_ins.SetColumn("dr_amt")
dw_ins.SetFocus()


end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\거래처가져오기_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\거래처가져오기_up.gif"
end event

type p_ins from uo_picture within w_kgla12a
integer x = 3255
integer y = 28
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Integer  iCurRow,iRowCount

if dw_ins.RowCount() > 0 then 
	IF Wf_Requiredchk(dw_ins.GetRow()) = -1 THEN Return
end if

iCurRow = dw_ins.RowCount() + 1
	
dw_ins.InsertRow(iCurRow)

dw_ins.ScrollToRow(iCurRow)
dw_ins.SetItem(iCurRow,"saupj",  Str_JanGo.saupj)
dw_ins.SetItem(iCurRow,"acc_yy", Str_JanGo.acc_yy)
dw_ins.SetItem(iCurRow,"acc_mm", Str_JanGo.acc_mm)
dw_ins.SetItem(iCurRow,"acc1_cd",Str_JanGo.acc1_cd)
dw_ins.SetItem(iCurRow,"acc2_cd",Str_JanGo.acc2_cd)
dw_ins.SetItem(iCurRow,"gbn1",   dw_cond.GetItemString(1,"gbn1"))
dw_ins.SetItem(iCurRow,"dc_gu",  dw_cond.GetItemString(1,"dc_gu"))
dw_ins.SetItem(iCurRow,"remark4", dw_cond.GetItemString(1,"remark4"))

dw_ins.SetColumn("saup_no")
dw_ins.SetFocus()
	
ib_any_typing = True

end event

type cb_del from commandbutton within w_kgla12a
integer x = 2391
integer y = 2400
integer width = 334
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;Integer k

IF dw_ins.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ins.DeleteRow(dw_ins.GetRow())
IF dw_ins.Update() = 1 THEN
	commit;
	
//	FOR k = 1 TO dw_ins.RowCount()
//		dw_ins.SetItem(k,'sflag','M')
//	NEXT
	
	dw_ins.SetColumn("dr_amt")
	dw_ins.SetFocus()
	
	ib_any_typing = False
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type dw_cust from datawindow within w_kgla12a
boolean visible = false
integer x = 722
integer y = 2232
integer width = 869
integer height = 104
boolean titlebar = true
string title = "거래처 가져오기"
string dataobject = "dw_kgla12a_popup"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cust from commandbutton within w_kgla12a
integer x = 457
integer y = 2400
integer width = 704
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "거래처 가져오기(I)"
end type

event clicked;Integer iCount,iFindRow,k,iLstCnt,iCurRow
String  sCust

iLstCnt = dw_ins.RowCount()
if iLstCnt > 0 then 
	IF Wf_Requiredchk(dw_ins.GetRow()) = -1 THEN Return
end if

OpenWithParm(w_kgla12a_popup,dw_cond.GetItemString(1,"gbn1"))

IF Message.StringParm = '0' THEN Return

dw_cust.Reset()
dw_cust.ImportClipboard()

iCount = dw_cust.RowCount()
FOR k = 1 TO iCount
	sCust = dw_cust.GetItemString(k,"person_cd")
	
	iFindRow = dw_ins.find("saup_no ='" + sCust + "'", 1, iLstCnt)
	IF iFindRow <=0 THEN
		iCurRow = dw_ins.InsertRow(0)
		
		dw_ins.SetItem(iCurRow,"saupj",  Str_JanGo.saupj)
		dw_ins.SetItem(iCurRow,"acc_yy", Str_JanGo.acc_yy)
		dw_ins.SetItem(iCurRow,"acc_mm", Str_JanGo.acc_mm)
		dw_ins.SetItem(iCurRow,"acc1_cd",Str_JanGo.acc1_cd)
		dw_ins.SetItem(iCurRow,"acc2_cd",Str_JanGo.acc2_cd)

		dw_ins.SetItem(iCurRow,"saup_no", sCust)
		dw_ins.SetItem(iCurRow,"cvname",  dw_cust.GetItemString(k,"person_nm"))
		dw_ins.SetItem(iCurRow,"gbn1",    dw_cond.GetItemString(1,"gbn1"))
		dw_ins.SetItem(iCurRow,"remark4", dw_cond.GetItemString(1,"remark4"))
		dw_ins.SetItem(iCurRow,"dc_gu",   dw_cond.GetItemString(1,"dc_gu"))
		
		ib_any_typing = True
	END IF
NEXT
dw_ins.SetColumn("dr_amt")
dw_ins.SetFocus()


end event

type cb_exit from commandbutton within w_kgla12a
integer x = 3104
integer y = 2400
integer width = 334
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;
IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인
	IF MessageBox("확인 : ",&
		 			  "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 																			question!, yesno!) = 1 THEN

		RETURN 									
	ELSE
		Rollback;
	END IF

END IF
Close(w_kgla12a)
end event

type cb_cancel from commandbutton within w_kgla12a
integer x = 2747
integer y = 2400
integer width = 334
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;dw_ins.Retrieve(Str_JanGo.saupj,Str_JanGo.acc_yy,Str_JanGo.acc_mm,Str_JanGo.acc1_cd,Str_JanGo.acc2_cd)

ib_any_typing =False

end event

type cb_save from commandbutton within w_kgla12a
integer x = 2034
integer y = 2400
integer width = 334
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;Integer k

IF dw_ins.RowCount() > 0 THEN
	FOR k = 1 TO dw_ins.RowCount()
		IF Wf_RequiredChk(k) = -1 THEN Return	
	NEXT
END IF

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_ins.Update() <> 1 Then
   f_messagechk(13,"") 
   dw_ins.SetFocus()
   Rollback;
	Return
END IF
Commit;
ib_any_typing = False



end event

type cb_add from commandbutton within w_kgla12a
integer x = 96
integer y = 2400
integer width = 334
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;Integer  iCurRow,iRowCount

if dw_ins.RowCount() > 0 then 
	IF Wf_Requiredchk(dw_ins.GetRow()) = -1 THEN Return
end if

iCurRow = dw_ins.RowCount() + 1
	
dw_ins.InsertRow(iCurRow)

dw_ins.ScrollToRow(iCurRow)
dw_ins.SetItem(iCurRow,"saupj",  Str_JanGo.saupj)
dw_ins.SetItem(iCurRow,"acc_yy", Str_JanGo.acc_yy)
dw_ins.SetItem(iCurRow,"acc_mm", Str_JanGo.acc_mm)
dw_ins.SetItem(iCurRow,"acc1_cd",Str_JanGo.acc1_cd)
dw_ins.SetItem(iCurRow,"acc2_cd",Str_JanGo.acc2_cd)
dw_ins.SetItem(iCurRow,"gbn1",   dw_cond.GetItemString(1,"gbn1"))
dw_ins.SetItem(iCurRow,"dc_gu",  dw_cond.GetItemString(1,"dc_gu"))
dw_ins.SetItem(iCurRow,"remark4", dw_cond.GetItemString(1,"remark4"))

dw_ins.SetColumn("saup_no")
dw_ins.SetFocus()
	
ib_any_typing = True

end event

type dw_cond from u_key_enter within w_kgla12a
integer x = 9
integer y = 36
integer width = 3259
integer height = 140
integer taborder = 0
string dataobject = "dw_kgla12a1"
boolean border = false
end type

type gb_2 from groupbox within w_kgla12a
integer x = 59
integer y = 2348
integer width = 1134
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_kgla12a
integer x = 2002
integer y = 2348
integer width = 1467
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_kgla12a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 180
integer width = 4407
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_ins from u_key_enter within w_kgla12a
event ue_key pbm_dwnkey
integer x = 46
integer y = 184
integer width = 4384
integer height = 1892
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgla12a2"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;if key = keyF1! or key = keytab! then
	triggerevent(rbuttondown!)
end if
end event

event itemerror;
Return 1
end event

event itemchanged;String   sSaupNo,sSaupName,sGbn1,sDcrGbn,sNull
Integer  iFindRow
Double   dDr,dCr,dJan

SetNull(sNull)

IF this.GetColumnName() ="saup_no" THEN
	sSaupNo = this.GetText()
//	IF sSaupNo = "" OR IsNull(sSaupNo) THEN Return
	
//	sGbn1 = this.GetItemString(this.GetRow(),"gbn1")
//	IF sGbn1 = "" OR IsNull(sGbn1) THEN sGbn1 = '%'
//	
//	sSaupName = F_Get_PersonLst(sGbn1,sSaupNo,'1')
//	IF IsNull(sSaupName) THEN
////		F_MessageChk(27,'')
//		this.SetItem(this.GetRow(),"saup_no",snull)
//		this.SetItem(this.GetRow(),"cvname",snull)
//		Return 1
//	END IF

	iFindRow = this.find("saup_no ='" + sSaupNo + "'", 1, this.RowCount())

	IF (this.GetRow() <> iFindRow) and (iFindRow <> 0) THEN
		f_MessageChk(10,'[거래처]')
		this.SetItem(this.GetRow(),"saup_no",snull)
		this.SetItem(this.GetRow(),"cvname",snull)
		return 1
	END IF

//	this.SetItem(this.GetRow(),"cvname",sSaupName)	
END IF

IF this.GetColumnName() = "dr_amt" THEN
	dDr = Double(this.GetText())
	IF IsNull(dDr) THEN Return 1
	
	dCr = this.GetItemNumber(this.GetRow(),"cr_amt")
	IF IsNull(dCr) THEN dCr = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJan = dDr - dCr
	ELSE
		dJan = dCr - dDr
	END IF
	
	this.SetItem(this.GetRow(),"jan_amt",dJan)
END IF

IF this.GetColumnName() = "cr_amt" THEN
	dCr = Double(this.GetText())
	IF IsNull(dCr) THEN Return 1
	
	dDr = this.GetItemNumber(this.GetRow(),"dr_amt")
	IF IsNull(dDr) THEN dDr = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJan = dDr - dCr
	ELSE
		dJan = dCr - dDr
	END IF
	
	this.SetItem(this.GetRow(),"jan_amt",dJan)
END IF

IF this.GetColumnName() = "ydr_amt" THEN
	dDr = Double(this.GetText())
	IF IsNull(dDr) THEN Return 1
	
	dCr = this.GetItemNumber(this.GetRow(),"ycr_amt")
	IF IsNull(dCr) THEN dCr = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJan = dDr - dCr
	ELSE
		dJan = dCr - dDr
	END IF
	
	this.SetItem(this.GetRow(),"yjan_amt",dJan)
END IF

IF this.GetColumnName() = "ycr_amt" THEN
	dCr = Double(this.GetText())
	IF IsNull(dCr) THEN Return 1
	
	dDr = this.GetItemNumber(this.GetRow(),"ydr_amt")
	IF IsNull(dDr) THEN dDr = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJan = dDr - dCr
	ELSE
		dJan = dCr - dDr
	END IF
	
	this.SetItem(this.GetRow(),"yjan_amt",dJan)
END IF

IF this.GetColumnName() = "dr_qty" THEN
	dDr = Double(this.GetText())
	IF IsNull(dDr) THEN Return 1
	
	dCr = this.GetItemNumber(this.GetRow(),"cr_qty")
	IF IsNull(dCr) THEN dCr = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJan = dDr - dCr
	ELSE
		dJan = dCr - dDr
	END IF
	
	this.SetItem(this.GetRow(),"jan_qty",dJan)
END IF

IF this.GetColumnName() = "cr_qty" THEN
	dCr = Double(this.GetText())
	IF IsNull(dCr) THEN Return 1
	
	dDr = this.GetItemNumber(this.GetRow(),"dr_qty")
	IF IsNull(dDr) THEN dDr = 0
	
	sDcrGbn = this.GetItemString(this.GetRow(),"dc_gu")
	
	IF sDcrGbn = '1' THEN									/*차변*/
		dJan = dDr - dCr
	ELSE
		dJan = dCr - dDr
	END IF
	
	this.SetItem(this.GetRow(),"jan_qty",dJan)
END IF


end event

event buttonclicked;string ls_remark

ls_remark = this.object.remark4[1]

if ls_remark = 'Y' then
	IF dwo.name = 'dcb_curr' THEN
		String  sSaupNo
		Integer iCount
		Double  dYdr,dYcr,dYjan,dDr,dCr,dJan
	
		this.AcceptText()
		sSaupNo  = this.GetItemString(this.getrow(),"saup_no")
		
		OpenWithParm(w_kgla12b,Str_JanGo.saupj+Str_JanGo.acc_yy+Str_JanGo.acc_mm+Str_JanGo.acc1_cd+Str_JanGo.acc2_cd+sSaupNo+'-'+this.GetItemString(this.getrow(),"cvname"))
		
		select Count(*), sum(nvl(ydr_amt,0)),	sum(nvl(ycr_amt,0)),	sum(nvl(yjan_amt,0)),
							  sum(nvl(dr_amt,0)),	sum(nvl(cr_amt,0)),	sum(nvl(jan_amt,0))	
			into :iCount, :dYdr,						:dYcr,					:dYjan,
							  :dDr,						:dCr,						:dJan
			from kfz13ot2
			where saupj   = :Str_JanGo.saupj and acc_yy = :Str_JanGo.acc_yy and acc_mm = :Str_JanGo.acc_mm and
					acc1_cd = :Str_JanGo.acc1_cd and acc2_cd = :Str_JanGo.acc2_cd and saup_no = :sSaupNo;
		if sqlca.sqlcode <> 0 then
			iCount = 0;			dJan = 0
		else
			if IsNull(iCount) then iCount = 0
			if IsNull(dJan) then dJan = 0
		end if
		
		if iCount > 0 then
			this.SetItem(this.getrow(),"dr_amt",  dDr)
			this.SetItem(this.getrow(),"cr_amt",  dCr)
			this.SetItem(this.getrow(),"jan_amt", dJan)
			
			this.SetItem(this.getrow(),"ydr_amt",  dYDr)
			this.SetItem(this.getrow(),"ycr_amt",  dYCr)
			this.SetItem(this.getrow(),"yjan_amt", dYJan)	
			
			ib_any_typing = True
		end if
		
		this.SetItem(this.getrow(),"currjan", dJan)
	END IF
end if
	
end event

event rbuttondown;String sGbn1, ls_name

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() = "saup_no" THEN
	
	lstr_custom.code = this.object.saup_no[getrow()]
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF	
	
	sGbn1 = this.GetItemString(this.GetRow(),"gbn1")
	IF sGbn1 = "" OR IsNull(sGbn1) THEN sGbn1 = '%'
	
	OpenWithParm(W_KFZ04OM0_POPUP,sGbn1)
	
//	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.SetItem(this.GetRow(),"cvname", lstr_custom.name)
	this.TriggerEvent(ItemChanged!)
END IF
end event

event editchanged;ib_any_typing = True
end event

