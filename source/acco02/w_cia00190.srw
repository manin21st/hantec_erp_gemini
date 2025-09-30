$PBExportHeader$w_cia00190.srw
$PBExportComments$상여금 월분할 원가 적용
forward
global type w_cia00190 from w_inherite
end type
type cbx_1 from checkbox within w_cia00190
end type
type dw_lst from u_key_enter within w_cia00190
end type
type cb_all_del from commandbutton within w_cia00190
end type
type p_all_del from uo_picture within w_cia00190
end type
type gb_1 from groupbox within w_cia00190
end type
type rr_1 from roundrectangle within w_cia00190
end type
type dw_head from u_key_enter within w_cia00190
end type
end forward

global type w_cia00190 from w_inherite
integer height = 2432
string title = "상여금 월분할 원가 적용"
cbx_1 cbx_1
dw_lst dw_lst
cb_all_del cb_all_del
p_all_del p_all_del
gb_1 gb_1
rr_1 rr_1
dw_head dw_head
end type
global w_cia00190 w_cia00190

type variables
w_preview  iw_preview
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
public function double wf_calculation_baebu (string sioym, string sioymt, string sempno, double dcuramount)
end prototypes

public function integer wf_requiredchk (integer irow);String  sDeptCode,sEmpno

if dw_lst.AcceptText() = -1 then Return -1

sDeptCode = dw_lst.GetItemString(iRow,"deptcode")
sEmpNo    = dw_lst.GetItemString(iRow,"empno")

if sDeptCode = '' or IsNull(sDeptCode) then
	F_MessageChk(1,'[부서]')
	dw_lst.SetColumn("deptcode")
	dw_lst.ScrollToRow(iRow)
	dw_lst.SetFocus()
	Return -1
end if
if sEmpNo = '' or IsNull(sEmpNo) then
	F_MessageChk(1,'[사번]')
	dw_lst.SetColumn("empno")
	dw_lst.ScrollToRow(iRow)
	dw_lst.SetFocus()
	Return -1
end if

Return 1
end function

public function double wf_calculation_baebu (string sioym, string sioymt, string sempno, double dcuramount);Double   dBaeBu = 0,dBonus_Remain
String   sFromYm,sTempYm

select Min(io_yymm||io_yymmt) into :sTempYm from cia11th  where adjust_gubn ='1';
	
if sqlca.sqlcode <> 0 then
	sFromYm = sIoYm+sIoYmt
else
	if sTempYm = '' or IsNull(sTempYm) then
		sFromYm = sIoYm+sIoYmt
	else
		select Max(io_yymm||io_yymmt) into :sFromYm from cia11th
			where io_yymm||io_yymmt < :sIoYm||:sIoYmt and adjust_gubn ='1';
		if sqlca.sqlcode <> 0 or IsNull(sFromYm) then
			sFromYm = sIoYm+sIoYmt
		end if
	end if
end if
	
select sum(nvl(b.apply_bonus,0))	into :dBonus_Remain
	from cia11th a, cia11t2 b
	where a.io_yymm = b.io_yymm and
			a.io_yymmt = b.io_yymmt and 
			a.io_yymm||a.io_yymmt > :sFromYm and a.io_yymm||a.io_yymmt < :sIoYm||:sIoYmT and
			a.adjust_gubn = '0' and b.empno = :sEmpNo ;
if sqlca.sqlcode <> 0 or IsNull(dBonus_Remain) then
	dBonus_Remain = 0
end if

dBaeBu = dCurAmount - dBonus_Remain

Return dBaeBu
end function

on w_cia00190.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_lst=create dw_lst
this.cb_all_del=create cb_all_del
this.p_all_del=create p_all_del
this.gb_1=create gb_1
this.rr_1=create rr_1
this.dw_head=create dw_head
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_lst
this.Control[iCurrent+3]=this.cb_all_del
this.Control[iCurrent+4]=this.p_all_del
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.dw_head
end on

on w_cia00190.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.dw_lst)
destroy(this.cb_all_del)
destroy(this.p_all_del)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.dw_head)
end on

event open;call super::open;dw_head.SetTransObject(Sqlca)
dw_head.Reset()

dw_lst.SetTransObject(Sqlca)
dw_lst.Reset()

if dw_head.Retrieve(Left(F_Today(),6),Left(F_Today(),6)) <=0 then
	dw_head.InsertRow(0)
	
	dw_head.SetItem(1,"io_yymm",    Left(F_Today(),6))
	dw_head.SetItem(1,"io_yymmt",    Left(F_Today(),6))
	dw_head.SetItem(1,"base_yymm",  Left(F_Today(),6))
	dw_head.SetItem(1,"base_yymmt",  Left(F_Today(),6))
	
	dw_head.Modify("io_yymm.protect = 0")
	dw_head.Modify("io_yymmt.protect = 0")
	dw_head.Modify("base_yymm.protect = 0")
	dw_head.Modify("base_yymmt.protect = 0")
	
	dw_head.SetColumn("io_yymm")
	dw_head.SetFocus()
else
	dw_head.Modify("io_yymm.protect = 1")
	dw_head.Modify("io_yymmt.protect = 1")
	dw_head.Modify("base_yymm.protect = 1")
	dw_head.Modify("base_yymmt.protect = 1")
	
	dw_head.SetColumn("babu_rate")
	dw_head.SetFocus()
	
	dw_lst.Retrieve(Left(F_Today(),6),Left(F_Today(),6))
end if

open( iw_preview, this)
end event

type dw_insert from w_inherite`dw_insert within w_cia00190
boolean visible = false
integer y = 2436
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00190
boolean visible = false
integer x = 4187
integer y = 3056
integer taborder = 70
end type

type p_addrow from w_inherite`p_addrow within w_cia00190
boolean visible = false
integer x = 4014
integer y = 3056
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_cia00190
integer x = 3195
integer taborder = 150
string picturename = "C:\erpman\image\자료생성_up.gif"
boolean focusrectangle = true
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\자료생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\자료생성_up.gif"
end event

event p_search::clicked;call super::clicked;String   sYearMonth,sYearMonthT,sBonusYm,sBonusYmT,sJoJeng,sEmpNo,sEmpName,sDeptCode,sProjectCode,sGrade,sJikJong
Double   dRate,dTotal = 0,dBaeBuAmt = 0
Integer  iCnt,k, iCurRow


if dw_head.AcceptText() = -1 then Return
sYearMonth  = Trim(dw_head.GetItemString(1,"io_yymm"))
sYearMonthT = Trim(dw_head.GetItemString(1,"io_yymmt"))
sBonusYm    = Trim(dw_head.GetItemString(1,"base_yymm"))
sBonusYmt   = Trim(dw_head.GetItemString(1,"base_yymmt"))
dRate       = dw_head.GetItemNumber(1,"babu_rate")
sJoJeng     = dw_head.GetItemString(1,"adjust_gubn")

if sYearMonth = '' or IsNull(sYearMonth) then
	F_MessageChk(1,'[원가계산년월]')
	dw_head.SetColumn("io_yymm")
	dw_head.SetFocus()
	Return
end if
if sYearMontht = '' or IsNull(sYearMontht) then
	F_MessageChk(1,'[원가계산년월]')
	dw_head.SetColumn("io_yymmt")
	dw_head.SetFocus()
	Return
end if
if sBonusYm = '' or IsNull(sBonusYm) then
	F_MessageChk(1,'[상여지급년월]')
	dw_head.SetColumn("base_yymm")
	dw_head.SetFocus()
	Return
end if
if sBonusYmt = '' or IsNull(sBonusYmt) then
	F_MessageChk(1,'[상여지급년월]')
	dw_head.SetColumn("base_yymmt")
	dw_head.SetFocus()
	Return
end if
if dRate = 0 or IsNull(dRate) then
	F_MessageChk(1,'[배부율]')
	dw_head.SetColumn("babu_rate")
	dw_head.SetFocus()
	Return
end if

if dw_lst.RowCount() > 0 then
	if MessageBox('확 인','이미 생성된 자료가 있습니다...삭제하시고 다시 생성하시겠습니까...?',Question!,YesNo!,2) = 2 then Return
	
	w_mdi_frame.sle_msg.text = '자료 삭제 중...'
	iCnt = dw_lst.RowCount()
	for k = iCnt to 1 Step -1
		dw_lst.DeleteRow(k)
	next
	
	if dw_lst.Update() = 1 then
		Commit;
	else
		Rollback;
		F_MessageChk(12,'')
		Return
	end if
	w_mdi_frame.sle_msg.text = '자료 삭제 완료'
end if

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '자료 생성 중...'

Declare Cursor_Bonus Cursor for
	select a.empno,							b.empname,						a.deptcode,						a.projectcode,		
			 max(a.gradecode),				sum(nvl(a.totpayamt,0)),	max(b.jikjonggubn)
		from p3_editdata a, p1_master b
		where a.workym >= :sBonusYm and a.workym <= :sBonusYmT and a.pbtag <> 'P' and
				a.empno = b.empno 
	group by a.empno,	b.empname,	a.deptcode,	a.projectcode
	order by a.deptcode, a.empno;
Open Cursor_Bonus;
Do While True
	Fetch Cursor_Bonus into :sEmpNo,		:sEmpName,						:sDeptCode,						:sProjectCode,		
									:sGrade,		:dTotal,							:sJikJong;
	if sqlca.sqlcode <> 0 then Exit
	
	if sJoJeng = '1' then									/*잔액조정적용*/
		dBaeBuAmt = Wf_Calculation_BaeBu(sYearMonth,sYearMonthT,sEmpNo,dTotal)
	else
		dBaeBuAmt = Round(dTotal * (dRate / 100),0)
	end if
	
	iCurRow = dw_lst.InsertRow(0)
	
	dw_lst.SetItem(iCurRow, "io_yymm",   		sYearMonth)
	dw_lst.SetItem(iCurRow, "io_yymmt",   		sYearMonthT)
	dw_lst.SetItem(iCurRow, "deptcode",  		sDeptCode)
	dw_lst.SetItem(iCurRow, "deptname",  		F_Get_Personlst('3',sDeptCode,'%'))
	dw_lst.SetItem(iCurRow, "empno",  	 		sEmpNo)
	dw_lst.SetItem(iCurRow, "empname",   		sEmpName)
	dw_lst.SetItem(iCurRow, "projectcode",		sProjectCode)
	dw_lst.SetItem(iCurRow, "base_bonus",  	dTotal)
	dw_lst.SetItem(iCurRow, "apply_bonus", 	dBaeBuAmt)
	dw_lst.SetItem(iCurRow, "jikjonggubn", 	sJikJong)
	dw_lst.SetItem(iCurRow, "gradecode", 		sGrade)
	
	dw_lst.SetItem(iCurRow, 'sflag',          'M')
	
	dw_lst.ScrollToRow(iCurRow)
Loop
Close Cursor_Bonus;

if iCurRow > 0 then
	if dw_head.Update() <> 1 then
		Rollback;
		F_MessageChk(13,'')
		SetPointer(Arrow!)
		w_mdi_frame.sle_msg.text = ''
		Return
	else
		if dw_lst.Update() <> 1 then
			Rollback;
			F_MessageChk(13,'')
			SetPointer(Arrow!)
			w_mdi_frame.sle_msg.text = ''
			Return		
		end if
		dw_head.Modify("io_yymm.protect = 1")
		dw_head.Modify("io_yymmt.protect = 1")
		dw_head.Modify("base_yymm.protect = 1")
		dw_head.Modify("base_yymmt.protect = 1")
		
		dw_head.SetColumn("babu_rate")
		dw_head.SetFocus()
	
		Commit;
	end if
end if

SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = '자료 생성 완료'

end event

type p_ins from w_inherite`p_ins within w_cia00190
integer x = 3749
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text = ""

dw_head.AcceptText()

iRowCount = dw_lst.RowCount()
IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_lst.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_lst.InsertRow(iCurRow)

	dw_lst.ScrollToRow(iCurRow)
	dw_lst.SetItem(iCurRow,'io_yymm',  dw_head.GetItemString(1,"io_yymm"))
	dw_lst.SetItem(iCurRow,'io_yymmt',  dw_head.GetItemString(1,"io_yymmt"))
	dw_lst.SetItem(iCurRow,'sflag',    'I')
	dw_lst.SetColumn("deptcode")
	dw_lst.SetFocus()
	
	ib_any_typing =False

END IF



end event

type p_exit from w_inherite`p_exit within w_cia00190
integer taborder = 140
end type

type p_can from w_inherite`p_can within w_cia00190
integer taborder = 130
end type

event p_can::clicked;call super::clicked;dw_head.SetRedraw(False)
dw_head.Reset()
dw_head.Insertrow(0)

dw_head.SetItem(1,"io_yymm",    Left(F_Today(),6))
dw_head.SetItem(1,"io_yymmt",    Left(F_Today(),6))
dw_head.SetItem(1,"base_yymm",  Left(F_Today(),6))
dw_head.SetItem(1,"base_yymmt",  Left(F_Today(),6))

dw_head.Modify("io_yymm.protect = 0")
dw_head.Modify("io_yymmt.protect = 0")
dw_head.Modify("base_yymm.protect = 0")
dw_head.Modify("base_yymmt.protect = 0")

dw_head.SetColumn("io_yymm")
dw_head.SetFocus()

dw_head.SetRedraw(True)

dw_lst.Reset()

p_ins.Enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"
p_search.Enabled = False
p_search.PictureName = "C:\erpman\image\자료생성_d.gif"

end event

type p_print from w_inherite`p_print within w_cia00190
boolean visible = false
integer x = 3831
integer y = 3044
integer taborder = 170
end type

type p_inq from w_inherite`p_inq within w_cia00190
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String  sYearMonth,sYearMonthT
Integer iCount

if dw_head.AcceptText() = -1 then Return
sYearMonth = Trim(dw_head.GetItemString(1,"io_yymm"))
sYearMontht = Trim(dw_head.GetItemString(1,"io_yymmt"))
if sYearMonth = '' or IsNull(sYearMonth) then
	F_MessageChk(1,'[원가계산년월]')
	dw_head.SetColumn("io_yymm")
	dw_head.SetFocus()
	Return
end if
if sYearMontht = '' or IsNull(sYearMontht) then
	F_MessageChk(1,'[원가계산년월]')
	dw_head.SetColumn("io_yymmt")
	dw_head.SetFocus()
	Return
end if

select Count(*)	into :iCount		from cia11th 		where io_yymm = :sYearMonth and io_yymmt = :sYearMonthT;
if sqlca.sqlcode = 0 and iCount > 0 then
	dw_head.Retrieve(sYearMonth,sYearMonthT)
	
	dw_head.Modify("io_yymm.protect = 1")
	dw_head.Modify("io_yymmt.protect = 1")
	dw_head.Modify("base_yymm.protect = 1")
	dw_head.Modify("base_yymmt.protect = 1")
	
	dw_head.SetColumn("babu_rate")
	dw_head.SetFocus()
	
	dw_lst.Retrieve(sYearMonth,sYearMonthT)
	
else
	dw_head.Modify("io_yymm.protect = 0")
	dw_head.Modify("io_yymmt.protect = 0")
	dw_head.Modify("base_yymm.protect = 0")
	dw_head.Modify("base_yymmt.protect = 0")
	
	dw_head.SetColumn("io_yymm")
	dw_head.SetFocus()
	
	dw_lst.Reset()
end if

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_search.Enabled = True
p_search.PictureName = "C:\erpman\image\자료생성_up.gif"
p_all_del.Enabled = True
p_all_del.PictureName = "C:\Erpman\image\전체삭제_up.gif"
end event

type p_del from w_inherite`p_del within w_cia00190
integer taborder = 110
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_lst.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_lst.DeleteRow(dw_lst.GetRow())
IF dw_lst.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_lst.RowCount()
		dw_lst.SetItem(k,'sflag','M')
	NEXT
	
	dw_lst.SetColumn("base_bonus")
	dw_lst.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
	Return
END IF
end event

type p_mod from w_inherite`p_mod within w_cia00190
integer taborder = 90
end type

event p_mod::clicked;call super::clicked;String  sYearMonth,sBaseYm
Integer k

if dw_head.AcceptText() = -1 then Return
sYearMonth = Trim(dw_head.GetItemString(1,"io_yymm"))
sBaseYm    = Trim(dw_head.GetItemString(1,"base_yymm"))

if sYearMonth = '' or IsNull(sYearMonth) then
	F_MessageChk(1,'[원가계산년월]')
	dw_head.SetColumn("io_yymm")
	dw_head.SetFocus()
	Return
end if
if sBaseYm = '' or IsNull(sBaseYm) then
	F_MessageChk(1,'[상여지급년월]')
	dw_head.SetColumn("base_yymm")
	dw_head.SetFocus()
	Return
end if

FOR k = 1 TO dw_lst.RowCount()
	if Wf_RequiredChk(k) = -1 then Return
NEXT

IF f_dbConFirm('저장') = 2 THEN RETURN

if dw_head.Update() = 1 then
	IF dw_lst.Update() = 1 THEN
		commit;
		
		FOR k = 1 TO dw_lst.RowCount()
			dw_lst.SetItem(k,'sflag','M')
		NEXT
	
		dw_lst.SetColumn("base_bonus")
		dw_lst.SetFocus()
		
		ib_any_typing = False
		w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
	ELSE
		ROLLBACK;
		f_messagechk(13,'')
	END IF		
else	
	ROLLBACK;
	f_messagechk(13,'')
end if

end event

type cb_exit from w_inherite`cb_exit within w_cia00190
boolean visible = false
integer x = 3013
integer y = 2784
integer taborder = 180
end type

type cb_mod from w_inherite`cb_mod within w_cia00190
boolean visible = false
integer x = 2181
integer y = 2784
integer taborder = 100
end type

type cb_ins from w_inherite`cb_ins within w_cia00190
boolean visible = false
integer x = 494
integer y = 2784
integer taborder = 80
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_cia00190
boolean visible = false
integer x = 2537
integer y = 2784
integer taborder = 120
end type

type cb_inq from w_inherite`cb_inq within w_cia00190
boolean visible = false
integer x = 142
integer y = 2784
integer taborder = 40
end type

type cb_print from w_inherite`cb_print within w_cia00190
boolean visible = false
integer x = 2464
integer y = 2648
end type

type st_1 from w_inherite`st_1 within w_cia00190
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_cia00190
boolean visible = false
integer x = 2894
integer y = 2784
end type

type cb_search from w_inherite`cb_search within w_cia00190
boolean visible = false
integer x = 992
integer y = 2784
integer width = 485
boolean enabled = false
string text = "자료생성(&W)"
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00190
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_cia00190
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_cia00190
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_cia00190
boolean visible = false
integer x = 101
integer y = 2724
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00190
boolean visible = false
integer x = 2139
integer y = 2724
end type

type cbx_1 from checkbox within w_cia00190
integer x = 2747
integer y = 160
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "상여금 배부적용 명세서"
end type

event clicked;String  sYearMonth

cbx_1.Checked = False

if dw_head.AcceptText() = -1 then Return
sYearMonth = Trim(dw_head.GetItemString(1,"io_yymm"))
if sYearMonth = '' or IsNull(sYearMonth) then
	F_MessageChk(1,'[원가계산년월]')
	dw_head.SetColumn("io_yymm")
	dw_head.SetFocus()
	Return
end if

iw_preview.title = '상여금 배부적용 명세서 미리보기'
iw_preview.dw_preview.dataobject = 'dw_cia001903'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=2 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve(sYearMonth) <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF

iw_preview.Visible =True
end event

type dw_lst from u_key_enter within w_cia00190
event ue_key pbm_dwnkey
integer x = 78
integer y = 268
integer width = 4521
integer height = 1940
integer taborder = 60
boolean bringtotop = true
string dataobject = "dw_cia001902"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;IF this.GetColumnName() ="deptcode" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"deptcode", lstr_custom.code)
	this.SetItem(this.GetRow(),"deptname", lstr_custom.name)
	
END IF

IF this.GetColumnName() ="empno" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"empno", lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

event itemchanged;String   sDeptCode,sDeptName,sEmpNo,sEmpName,sProjectCode,sJikJong,sGrade,sNull
Double   dRate,dAmount

SetNull(sNull)

if this.GetColumnName() = "deptcode" then
	sDeptCode = this.GetText()
	if sDeptCode = '' or IsNull(sDeptCode) then 
		this.SetItem(this.GetRow(),"deptname", sNull)
		Return
	end if
	
	sDeptName = F_Get_Personlst('3',sDeptCode,'%')
	if sDeptName = '' or IsNull(sDeptName) then
		F_MessageChk(20,'[부서]')
		this.SetItem(this.Getrow(),"deptcode", sNull)
		this.SetItem(this.Getrow(),"deptname", sNull)
		Return 1
	end if
end if

if this.GetColumnName() = "empno" then
	sEmpNo = this.GetText()
	if sEmpNo = '' or IsNull(sEmpNo) then 
		this.SetItem(this.GetRow(),"empname",     sNull)
		this.SetItem(this.GetRow(),"projectcode", sNull)
		this.SetItem(this.GetRow(),"jikjonggubn", sNull)
		this.SetItem(this.GetRow(),"gradecode",   sNull)
		Return
	end if
	
	select empname,		deptcode,		projectcode,		gradecode,		jikjonggubn
		into :sEmpName,	:sDeptCode,		:sProjectCode,		:sGrade,			:sJikJong
		from p1_master
		where empno = :sEmpNo;
	if sqlca.sqlcode = 0 then
		this.SetItem(this.GetRow(),"empname",     sEmpName)
		this.SetItem(this.GetRow(),"deptcode",    sDeptCode)
		this.SetItem(this.GetRow(),"deptname",    F_Get_PersonLst('3',sDeptCode,'%'))
		this.SetItem(this.GetRow(),"projectcode", sProjectCode)
		this.SetItem(this.GetRow(),"jikjonggubn", sJikJong)
		this.SetItem(this.GetRow(),"gradecode",   sGrade)		
	else
		F_MessageChk(20,'[사번]')
		this.SetItem(this.GetRow(),"empno",       sNull)
		this.SetItem(this.GetRow(),"empname",     sNull)
		this.SetItem(this.GetRow(),"projectcode", sNull)
		this.SetItem(this.GetRow(),"jikjonggubn", sNull)
		this.SetItem(this.GetRow(),"gradecode",   sNull)
		Return 1
	end if
end if

if this.GetColumnName() = "base_bonus" then
	dAmount = Double(this.GetText())
	if dAmount = 0 or IsNull(dAmount) then Return
	
	dRate = dw_head.GetItemNumber(1,"babu_rate")
	if IsNull(dRate) then dRate = 0
	
	this.SetItem(this.GetRow(),"apply_bonus", Round(dAmount * (dRate / 100),0))
end if
end event

event editchanged;ib_any_typing = True
end event

event itemerror;Return 1
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

type cb_all_del from commandbutton within w_cia00190
boolean visible = false
integer x = 1614
integer y = 2784
integer width = 379
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "전체삭제(&M)"
end type

type p_all_del from uo_picture within w_cia00190
integer x = 3369
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\전체삭제_up.gif"
boolean focusrectangle = true
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\Erpman\image\전체삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\Erpman\image\전체삭제_dn.gif"
end event

event clicked;call super::clicked;Integer k,iCnt


if dw_lst.RowCount() <=0  then Return

if MessageBox('확 인','생성된 자료를 모두 삭제하시겠습니까?',Question!,YesNo!,2) = 2 then Return

w_mdi_frame.sle_msg.text = '자료 삭제 중...'
iCnt = dw_lst.RowCount()
for k = iCnt to 1 Step -1
	dw_lst.DeleteRow(k)
next

if dw_lst.Update() = 1 then
	dw_head.SetRedraw(False)
	dw_head.DeleteRow(0)
	if dw_head.Update() = 1 then
		Commit;
			
		dw_head.InsertRow(0)
		
		dw_head.SetItem(1,"io_yymm",    Left(F_Today(),6))
		dw_head.SetItem(1,"io_yymmt",    Left(F_Today(),6))
		dw_head.SetItem(1,"base_yymm",  Left(F_Today(),6))
		dw_head.SetItem(1,"base_yymmt",  Left(F_Today(),6))
		
		dw_head.Modify("io_yymm.protect = 0")
		dw_head.Modify("io_yymmt.protect = 0")
		dw_head.Modify("base_yymm.protect = 0")
		dw_head.Modify("base_yymmt.protect = 0")
		
		dw_head.SetColumn("io_yymm")
		dw_head.SetFocus()
	
		dw_head.SetRedraw(True)
	else
		Rollback;
		F_MessageChk(12,'')
		dw_head.SetRedraw(True)
		Return
	end if
else
	Rollback;
	F_MessageChk(12,'')
	Return
end if
w_mdi_frame.sle_msg.text = '자료 삭제 완료'

end event

type gb_1 from groupbox within w_cia00190
boolean visible = false
integer x = 955
integer y = 2724
integer width = 1079
integer height = 200
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_cia00190
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 264
integer width = 4549
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_head from u_key_enter within w_cia00190
integer x = 64
integer y = 8
integer width = 2683
integer height = 252
integer taborder = 20
string dataobject = "dw_cia001901"
boolean border = false
end type

