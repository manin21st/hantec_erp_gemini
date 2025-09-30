$PBExportHeader$w_cia00037.srw
$PBExportComments$재고단가 조정
forward
global type w_cia00037 from w_inherite
end type
type dw_2 from datawindow within w_cia00037
end type
type gb_4 from groupbox within w_cia00037
end type
type dw_1 from datawindow within w_cia00037
end type
type dw_save from datawindow within w_cia00037
end type
type cb_1 from commandbutton within w_cia00037
end type
type rr_1 from roundrectangle within w_cia00037
end type
end forward

global type w_cia00037 from w_inherite
integer width = 4663
integer height = 3376
string title = "재고단가 조정"
dw_2 dw_2
gb_4 gb_4
dw_1 dw_1
dw_save dw_save
cb_1 cb_1
rr_1 rr_1
end type
global w_cia00037 w_cia00037

type variables
Boolean itemerr =False
String     LsIttyp
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);String sItnbr,sIoYm

dw_2.AcceptText()
sIoYm  = dw_2.GetItemString(ll_row,"io_yymm")
sItnbr = dw_2.GetItemString(ll_row,"itnbr")

IF sIoYm = "" OR IsNull(sIoYm) THEN
	f_messagechk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return -1
END IF
IF sItnbr = "" OR IsNull(sItnbr) THEN
	f_messagechk(1,'[품번]')
	dw_2.SetColumn("itnbr")
	dw_2.SetFocus()
	Return -1
END IF
Return 1
end function

public function integer wf_dup_chk (integer ll_row);String  sIoYm,sItnbr
Integer iReturnRow

dw_1.AcceptText()
sIoYm = Trim(dw_1.GetItemString(1,"io_ym"))

dw_2.AcceptText()
sItnbr = dw_2.GetItemString(ll_row,"itnbr")

IF sIoYm  ="" OR IsNull(sIoYm)  THEN RETURN 1
IF sItnbr ="" OR IsNull(sItnbr) THEN RETURN 1

IF LsIttyp = '%' THEN
	iReturnRow = dw_2.find("io_yymm ='" + sIoYm + "' and itnbr = '" + sItnbr + "'", 1, dw_2.RowCount())
ELSE
	iReturnRow = dw_2.find("io_yymm ='" + sIoYm + "' and itnbr = '" + sItnbr + "' and itemas_ittyp = '" + LsIttyp + "'", 1, dw_2.RowCount())	
END IF

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[품번]')
	RETURN  -1
END IF
	
Return 1
end function

on w_cia00037.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_4=create gb_4
this.dw_1=create dw_1
this.dw_save=create dw_save
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_save
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_cia00037.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.dw_save)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1,"io_ym",Left(F_Today(),6))
dw_1.SetItem(1,"io_ymt",Left(F_Today(),6))

dw_1.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

dw_save.SetTransObject(SQLCA)
dw_save.Reset()

p_search.Enabled = False
p_ins.Enabled = False

end event

type dw_insert from w_inherite`dw_insert within w_cia00037
boolean visible = false
integer x = 41
integer y = 2404
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00037
boolean visible = false
integer x = 3849
integer y = 3184
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cia00037
boolean visible = false
integer x = 3675
integer y = 3184
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cia00037
integer x = 3566
boolean enabled = false
string picturename = "C:\erpman\image\생성_d.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

event p_search::clicked;call super::clicked;String sIoYm,sBefYm,sIoYmt,sBefYmt
Long ll_cnt


IF dw_1.Accepttext() = -1 THEN RETURN

sIoYm  = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
sIoYmt = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ymt"))

if MessageBox('확 인','원가년월의 원가수불부의 재고단가를 가져옵니다'+'~n'+&
							 '계속하시겠습니까?',Question!,YesNo!) = 2 then Return

delete from cia23t_muprc where io_yymm = :sIoYm and io_yymmt = :sIoYmt ;
commit;

if Mid(sIoYm ,5,2) = '01' then
	sBefYm = String(Integer(Left(sIoYm,4)) - 1,'0000')+'12'
else
	sBefYm = Left(sIoYm,4)+String(Integer(Mid(sIoYm,5,2)) - 1,'00')
end if

if Mid(sIoYmt ,5,2) = '01' then
	sBefYmt = String(Integer(Left(sIoYmt,4)) - 1,'0000')+'12'
else
	sBefYmt = Left(sIoYmt,4)+String(Integer(Mid(sIoYmt,5,2)) - 1,'00')
end if


INSERT INTO "CIA23T_MUPRC"  
	( "IO_YYMM",   		"IO_YYMMT",		"PDTGU",   		"ITNBR",   		"JPRC",   
	  "OMAT_PRC",   		"OLAB_PRC",   	"OOVER_PRC",   "PUM_TRANS",   "PUM_CHANGE",   "BIGO" )  
SELECT :sIoYm,				:sIoYmT,			 "PDTGU",			"ITNBR",			IM_UPRC,
		 OPMAT_UPRC, 		 OPLAB_UPRC,	 OPOVER_UPRC,	'N',				'N',				NULL
    FROM "CIA23T"  
	 WHERE IO_YYMM = :sBefYm and IO_YYMMT = :sBefYmt  ;
COMMIT;

w_mdi_frame.sle_msg.text = 'CIA23T 자료 생성을 완료하였습니다'

dw_save.reset()
//창고이관, 품목대체 출고인 경우 해당 
if dw_save.Retrieve(sBefYm,sBefYmt) >= 0 then
	for ll_cnt = 1 to dw_save.RowCount()
		dw_save.Object.pum_trans[ll_cnt] = dw_save.Object.b_itrans[ll_cnt]
		dw_save.Object.pum_change[ll_cnt] = dw_save.Object.b_ichange[ll_cnt]
	next

	IF dw_save.Update() = 1 THEN
		commit;
		ib_any_typing = False
	ELSE
		ROLLBACK;
		w_mdi_frame.sle_msg.text = 'CIA23T 자료만 생성을 했습니다.'	
		return
	END IF
end if

w_mdi_frame.sle_msg.text = '자료 생성을 완료하였습니다'
p_inq.TriggerEvent(Clicked!)


							 


end event

type p_ins from w_inherite`p_ins within w_cia00037
integer x = 3739
integer taborder = 0
string pointer = "C:\erpman\cur\new.cur"
boolean enabled = false
string picturename = "C:\erpman\image\전체삭제_d.gif"
end type

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\전체삭제_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\전체삭제_up.gif"
end event

event p_ins::clicked;call super::clicked;String sIoYm,sBefYm,sIoYmt


IF dw_1.Accepttext() = -1 THEN RETURN

sIoYm  = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
sIoYmt = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ymt"))

if MessageBox('확 인','원가년월의 재고단가 조정내역을 모두 삭제합니다.'+'~n'+&
							 '계속하시겠습니까?',Question!,YesNo!) = 2 then Return

delete from cia23t_muprc where io_yymm = :sIoYm and io_yymmt = :sIoYmt ;
commit;

w_mdi_frame.sle_msg.text = '자료 삭제하였습니다'

dw_2.Reset()
end event

type p_exit from w_inherite`p_exit within w_cia00037
integer x = 4434
end type

type p_can from w_inherite`p_can within w_cia00037
integer x = 4261
end type

event p_can::clicked;call super::clicked;String sIttyp,sIoYm,sPdtGu,sIoYmt

w_mdi_frame.sle_msg.text =""
sIoYm  = Trim(dw_1.GetItemString(1,"io_ym"))
sIoYmt = Trim(dw_1.GetItemString(1,"io_ymt"))
sPdtGu = Trim(dw_1.GetItemString(dw_1.GetRow(),"saupgubn"))
sIttyp = dw_1.GetItemString(1,"ittyp")

dw_2.SetRedraw(False)
IF dw_2.Retrieve(sIoYm,sIoYmt,sPdtGu,sIttyp) > 0 THEN
	dw_2.ScrollToRow(1)
	dw_2.SetColumn("jprc")
	dw_2.SetFocus()
	
	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\생성_up.gif'
	
	p_ins.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\전체삭제_d.gif'
	
ELSE
	
	p_search.Enabled = False
	p_search.PictureName = 'C:\erpman\image\생성_d.gif'
	
	p_ins.Enabled = True
	p_ins.PictureName = 'C:\erpman\image\전체삭제_up.gif'
END IF
dw_2.SetRedraw(True)

ib_any_typing =False


end event

type p_print from w_inherite`p_print within w_cia00037
boolean visible = false
integer x = 3493
integer y = 3188
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cia00037
integer x = 3913
end type

event p_inq::clicked;call super::clicked;String sYm,sPdtGu,sYmt

IF dw_1.Accepttext() = -1 THEN RETURN

sYm    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
sYmt   = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ymt"))
sPdtGu = Trim(dw_1.GetItemString(dw_1.GetRow(),"saupgubn"))
LsIttyp = dw_1.GetItemString(dw_1.GetRow(),"ittyp")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[원가년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF
IF sYmt = "" OR IsNull(sYmt) THEN
	f_MessageChk(1,'[원가년월]')
	dw_1.SetColumn("io_ymt")
	dw_1.SetFocus()
	Return
END IF

IF sPdtGu = "" OR IsNull(sPdtGu) THEN
	f_MessageChk(1,'[생산팀]')
	dw_1.SetColumn("saupgubn")
	dw_1.SetFocus()
	Return
END IF

IF LsIttyp = "" OR IsNull(LsIttyp) THEN 
	f_MessageChk(1,'[품목구분]')
	dw_1.SetColumn("ittyp")
	dw_1.SetFocus()
	Return
end if

w_mdi_frame.sle_msg.Text = '조회 중...'
SetPointer(HourGlass!)
dw_2.SetRedraw(False)
IF dw_2.Retrieve(sYm,sYmt,sPdtGu,LsIttyp) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	
	p_search.Enabled = True
	p_search.PictureName = 'C:\erpman\image\생성_up.gif'
	
	p_ins.Enabled = False
	p_ins.PictureName = 'C:\erpman\image\전체삭제_d.gif'
	
	Return
ELSE
	dw_2.SetColumn("jprc")
	dw_2.SetFocus()
	
	p_search.Enabled = False
	p_search.PictureName = 'C:\erpman\image\생성_d.gif'
	
	p_ins.Enabled = True
	p_ins.PictureName = 'C:\erpman\image\전체삭제_up.gif'
	
END IF
dw_2.SetRedraw(True)

w_mdi_frame.sle_msg.text = '조회 완료'
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cia00037
boolean visible = false
integer x = 4224
integer y = 2712
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita") = 0 OR IsNull(dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('삭제') = 2 THEN RETURN
ELSE
	IF MessageBox("확 인","선택하신 자료에 이월 이외의 자료(입고,출고,재고)가 존재합니다.~r"+&
								 "삭제하시겠습니까?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_cia00037
integer x = 4087
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;
IF dw_2.AcceptText() = -1 THEN Return

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	dw_2.SetColumn("jprc")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cia00037
boolean visible = false
integer x = 3026
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_cia00037
boolean visible = false
integer x = 2199
integer y = 2752
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_2.AcceptText() = -1 THEN Return

IF dw_2.RowCount() > 0 THEN
	FOR k = 1 TO dw_2.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT

	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_cia00037
boolean visible = false
integer x = 503
integer y = 2752
integer taborder = 50
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sYm

sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sYm = Trim(dw_1.GetItemString(1,"io_ym"))
IF sYm = "" OR IsNull(sYm) THEN
	F_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_2.InsertRow(0)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'io_yymm',sYm)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetColumn("itnbr")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_cia00037
boolean visible = false
integer x = 2551
integer y = 2752
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita") = 0 OR IsNull(dw_2.GetItemNumber(dw_2.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('삭제') = 2 THEN RETURN
ELSE
	IF MessageBox("확 인","선택하신 자료에 이월 이외의 자료(입고,출고,재고)가 존재합니다.~r"+&
								 "삭제하시겠습니까?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_cia00037
boolean visible = false
integer x = 142
integer y = 2752
integer taborder = 40
end type

event cb_inq::clicked;call super::clicked;String sYm

IF dw_1.Accepttext() = -1 THEN RETURN

sYm    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
LsIttyp = dw_1.GetItemString(dw_1.GetRow(),"ittyp")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF LsIttyp = "" OR IsNull(LsIttyp) THEN LsIttyp = '%'

sle_msg.Text = '조회 중...'
SetPointer(HourGlass!)
dw_2.SetRedraw(False)
IF dw_2.Retrieve(sYm,LsIttyp) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
END IF
dw_2.SetRedraw(True)

sle_msg.text = '조회 완료'
SetPointer(Arrow!)
end event

type cb_print from w_inherite`cb_print within w_cia00037
boolean visible = false
integer x = 1216
integer y = 2740
end type

type st_1 from w_inherite`st_1 within w_cia00037
boolean visible = false
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cia00037
boolean visible = false
integer x = 2907
integer y = 2752
end type

event cb_can::clicked;call super::clicked;String sIttyp,sIoYm

sle_msg.text =""
sIoYm  = Trim(dw_1.GetItemString(1,"io_ym"))
sIttyp = dw_1.GetItemString(1,"ittyp")
IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = '%'

dw_2.SetRedraw(False)
IF dw_2.Retrieve(sIoYm,sIttyp) > 0 THEN
	dw_2.ScrollToRow(1)
	dw_2.SetColumn("iwol_qty")
	dw_2.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_cia00037
boolean visible = false
integer x = 1618
integer y = 2748
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00037
boolean visible = false
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cia00037
boolean visible = false
integer x = 329
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_cia00037
boolean visible = false
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_cia00037
boolean visible = false
integer x = 110
integer y = 2696
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00037
boolean visible = false
integer x = 2153
integer y = 2696
end type

type dw_2 from datawindow within w_cia00037
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 73
integer y = 204
integer width = 4462
integer height = 2032
integer taborder = 30
string dataobject = "dw_cia000372"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event rowfocuschanged;//this.SetRowFocusIndicator(Hand!)
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

type gb_4 from groupbox within w_cia00037
boolean visible = false
integer y = 2948
integer width = 3598
integer height = 140
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
end type

type dw_1 from datawindow within w_cia00037
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 73
integer width = 2889
integer height = 200
integer taborder = 20
string dataobject = "dw_cia000371"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String snull,sYm

SetNull(snull)

w_mdi_frame.sle_msg.text =""

IF this.GetColumnName() ="io_ym" THEN
	sYm = Trim(this.GetText())
	IF sYm = "" OR IsNull(sYm) THEN RETURN
	
	IF F_DateChk(sYm+'01') = -1 THEN 
		F_MessageChk(21,'[원가계산년월]')
		dw_1.SetItem(1,"io_ym",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ittyp" THEN
	LsIttyp = this.GetText()
	IF LsIttyp = "" OR IsNull(LsIttyp) THEN REturn
	
	SELECT "REFFPF"."RFGUB"  INTO :LsIttyp
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '05' ) AND  ( "REFFPF"."RFGUB" =:LsIttyp) ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"품목구분") 
		dw_1.SetItem(1,"ittyp",snull)
		Return 1
	END IF
	
END IF

end event

event itemerror;Return 1

end event

event rbuttondown;String ls_gj1,ls_gj2,rec_acc1,rec_acc2

IF this.GetColumnName() ="person_ac1" OR this.GetColumnName() ="person_cd2" THEN

	ls_gj1 =dw_1.GetItemString(1,"person_ac1")
	ls_gj2 =dw_1.GetItemString(1,"person_cd2")

	IF IsNull(ls_gj1) then
   	ls_gj1 = ""
	end if
	IF IsNull(ls_gj2) then
   	ls_gj2 = ""
	end if

 	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	dw_1.SetItem(1,"person_ac1",lstr_account.acc1_cd)
	dw_1.SetItem(1,"person_cd2",lstr_account.acc2_cd)

	dw_1.SetItem(1,"accname",lstr_account.acc2_nm)
END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="person_nm" OR dwo.name ="person_tx" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event getfocus;this.AcceptText()
end event

type dw_save from datawindow within w_cia00037
boolean visible = false
integer x = 3218
integer y = 64
integer width = 329
integer height = 128
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "dw_cia000372_d"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_cia00037
string tag = "창고이관, 품목대체 계산"
integer x = 3218
integer y = 32
integer width = 256
integer height = 128
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "계산"
end type

event clicked;String sIoYm,sBefYm,sIoYmt
Long ll_cnt


IF dw_1.Accepttext() = -1 THEN RETURN

sIoYm = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
sIoYmt = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ymt"))

if MessageBox('확 인','창고이관, 품목대체자료을 체크합니다.'+'~n'+&
							 '계속하시겠습니까?',Question!,YesNo!) = 2 then Return

dw_save.reset()
//창고이관, 품목대체 출고인 경우 해당 
if dw_save.Retrieve(sIoYm,sIoYmt) >= 0 then
	for ll_cnt = 1 to dw_save.RowCount()
		dw_save.Object.pum_trans[ll_cnt]  = dw_save.Object.b_itrans[ll_cnt]
		dw_save.Object.pum_change[ll_cnt] = dw_save.Object.b_ichange[ll_cnt]
	next

	IF dw_save.Update() = 1 THEN
		commit;
		ib_any_typing = False
	ELSE
		ROLLBACK;
		w_mdi_frame.sle_msg.text = 'CIA23T 자료만 생성을 했습니다.'	
		return
	END IF
end if

w_mdi_frame.sle_msg.text = '자료 생성을 완료하였습니다'
p_inq.TriggerEvent(Clicked!)


							 


end event

type rr_1 from roundrectangle within w_cia00037
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 200
integer width = 4539
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 46
end type

