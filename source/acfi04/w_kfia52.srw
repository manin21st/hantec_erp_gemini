$PBExportHeader$w_kfia52.srw
$PBExportComments$월자금 수지계획 수정
forward
global type w_kfia52 from w_inherite
end type
type dw_list from datawindow within w_kfia52
end type
type dw_mst from datawindow within w_kfia52
end type
type cb_copy from commandbutton within w_kfia52
end type
type gb_3 from groupbox within w_kfia52
end type
type gb_2 from groupbox within w_kfia52
end type
type rb_1 from radiobutton within w_kfia52
end type
type rb_2 from radiobutton within w_kfia52
end type
type cbx_1 from checkbox within w_kfia52
end type
type p_copy from uo_picture within w_kfia52
end type
type rr_1 from roundrectangle within w_kfia52
end type
end forward

global type w_kfia52 from w_inherite
string title = "월 자금 수지계획 수정"
dw_list dw_list
dw_mst dw_mst
cb_copy cb_copy
gb_3 gb_3
gb_2 gb_2
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
p_copy p_copy
rr_1 rr_1
end type
global w_kfia52 w_kfia52

type variables
w_preview  iw_preview

String          LsAuthority ='P'
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
public function integer wf_insert_bef_month ()
end prototypes

public function integer wf_requiredchk (integer irow);String   sSeqNo,sConFirm,sFinCode,sPlanDay
Double   dFAmt

dw_list.AcceptText()
sSeqNo    = dw_list.GetItemString(irow, 'seq_no')
sPlanDay  = dw_list.GetItemString(irow, 'plan_day')
dFAmt		 = dw_list.GetItemNumber(iRow, 'famt')
sConFirm  = dw_list.GetItemString(irow, 'confirm')
sFinCode  = dw_list.GetItemString(irow, 'finance_cd')

if trim(sSeqNo) = '' or isnull(sSeqNo)  then 
	F_MessageChk(1, "[순번]")
	dw_list.SetColumn('seq_no')
	dw_list.SetFocus()
	return -1
end if
IF sPlanDay = '' OR IsNull(sPlanDay) THEN
	F_MessageChk(1, "[일자]")
	dw_list.SetColumn('plan_day')
	dw_list.SetFocus()
	return -1
END IF

IF dFAmt = 0 OR IsNull(dFAmt) THEN
	F_MessageChk(1, "[자금수지금액]")
	dw_list.ScrollToRow(irow)
	dw_list.SetColumn('famt')
	dw_list.SetFocus()
	return -1
END IF

IF sFinCode = '' OR IsNull(sFinCode) THEN
	F_MessageChk(1, "[자금코드]")
	dw_list.SetColumn('finance_cd')
	dw_list.SetFocus()
	return -1
END IF

Return 1
end function

public function integer wf_insert_bef_month ();Double  dRemain
Integer iCount
String  sYearMonth,sLastFinCode,sBefYm,sBefDay

IF LsAuthority = 'P' THEN Return 1								/*현업이면 skip*/

if dw_mst.AcceptText() = -1 then Return -1
sYearMonth = dw_mst.GetItemString(1,"acc_yymm")

dRemain    = dw_mst.GetItemNumber(1,"bef_remain")
IF IsNull(dRemain) THEN dRemain = 0

select nvl(finance_cd,'')		into :sLastFinCode	from kfm10om0 where last_cd = 'Y';			/*차월이월코드설정 없으면 skip*/
if sqlca.sqlcode = 0 then
	if sLastFinCode ='' or IsNull(sLastFinCode) then Return 1
else
	Return 1
end if

IF Mid(sYearMonth,5,2) = '01' THEN
	sBefYm  = String(Long(Left(sYearMonth,4)) - 1,'0000')+'12'
	sBefDay = Right(F_Last_Date(String(Long(Left(sYearMonth,4)) - 1,'0000')+'12'),2)
ELSE
	sBefYm  = Left(sYearMonth,4)+String(Integer(Mid(sYearMonth,5,2)) - 1,'00')
	sBefDay = Right(F_Last_Date(Left(sYearMonth,4)+String(Integer(Mid(sYearMonth,5,2)) - 1,'00')),2)
END IF

select Count(*)	into :iCount		from kfm14ot0
	where acc_ym = :sBefYm and plan_day = :sBefDay and finance_cd = :sLastFinCode ;
if sqlca.sqlcode = 0 then
	if IsNull(iCount) then iCount = 0
else
	iCount = 0
end if

if iCount = 0 then
	insert into kfm14ot0
		(acc_ym,			dept_cd,			saupj,			seq_no,		plan_day,		saup_no,		saup_nm,		
		 descr,			famt,				finance_cd,		confirm,		crtgbn)
	values
		(:sBefYm,		:Gs_Dept,		:Gs_Saupj,		999,			:sBefDay,		null,			null,			
		 '월잔액',		:dRemain,		:sLastFinCode,	'Y',			'2' )  ;
else
	update kfm14ot0
		set famt = :dRemain
		where acc_ym = :sBefYm and plan_day = :sBefDay and finance_cd = :sLastFinCode ;
end if

if sqlca.sqlcode <> 0 then
	Rollback;
	F_MessageChk(13,'[전월말 잔액]')
	Return -1
end if
Return 1
end function

on w_kfia52.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_mst=create dw_mst
this.cb_copy=create cb_copy
this.gb_3=create gb_3
this.gb_2=create gb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.p_copy=create p_copy
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_mst
this.Control[iCurrent+3]=this.cb_copy
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.p_copy
this.Control[iCurrent+10]=this.rr_1
end on

on w_kfia52.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_mst)
destroy(this.cb_copy)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.p_copy)
destroy(this.rr_1)
end on

event open;call super::open;String ls_acc_yymm, get_dept, get_dept1, ls_gubun, sSysDept

dw_mst.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_mst.reset()
dw_list.reset()

dw_mst.Insertrow(0)
dw_mst.SetItem(dw_mst.GetRow(), 'acc_yymm', Left(f_today(),6))
dw_mst.SetColumn('acc_yymm')
dw_mst.SetFocus()

p_del.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

p_ins.Enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

IF F_Authority_Fund_Chk(Gs_dept) = -1 THEN							/*현업*/
	dw_mst.SetItem(1,"dept",  Gs_dept)
	dw_mst.SetItem(1,"saupj", Gs_saupj)

	dw_mst.Modify('saupj.protect = 1')
	dw_mst.Modify('dept.protect = 1')
	dw_mst.Modify('bef_remain.protect = 1')
	
	dw_mst.Modify('basedate.visible = 0')
	dw_mst.Modify('basedate_t.visible = 0')
	
	gb_2.Visible = False
	rb_1.Visible = False
	rb_2.Visible = False
	
	LsAuthority = 'P'
Else
	dw_mst.Modify('saupj.protect = 0')
	dw_mst.Modify('dept.protect = 0')
	dw_mst.Modify('bef_remain.protect = 0')

	dw_mst.Modify('basedate.visible   = 1')
	dw_mst.Modify('basedate_t.visible = 1')
	
	gb_2.Visible = True
	rb_1.Visible = True
	rb_2.Visible = True

	LsAuthority = 'A'	
End if

open( iw_preview, this)


end event

type dw_insert from w_inherite`dw_insert within w_kfia52
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia52
boolean visible = false
integer x = 3767
integer y = 2904
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia52
boolean visible = false
integer x = 3593
integer y = 2904
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia52
boolean visible = false
integer x = 2898
integer y = 2904
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia52
integer x = 3749
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;string sYearMonth, sSeqNo, sDeptCode, sSaupj
long ll_currow, ll_rowcnt

ll_rowcnt = dw_mst.GetRow()
if ll_rowcnt < 1 then return 

if dw_mst.AcceptText() = -1 then return 
sYearMonth = Trim(dw_mst.GetItemString(dw_mst.GetRow(), 'acc_yymm'))
sDeptCode  = dw_mst.GetItemString(dw_mst.Getrow(), 'dept')
sSaupj     = dw_mst.GetItemString(dw_mst.GetRow(), 'saupj')

if trim(sYearMonth) = '' or isnull(sYearMonth) then 
	F_MessageChk(1, "[회계년월]")
	dw_mst.SetColumn('acc_yymm')
	dw_mst.SetFocus()
	return 
end if

IF LsAuthority = 'P' THEN
	if trim(sSaupj) = '' or isnull(sSaupj) then 
		F_MessageChk(1, "[사업장]")
		dw_mst.SetColumn('saupj')
		dw_mst.SetFocus()
		return 
	end if
	
	if trim(sDeptCode) = '' or isnull(sDeptCode)  then 
		F_MessageChk(1, "[작성부서]")
		dw_mst.SetColumn('dept')
		dw_mst.SetFocus()
		return 
	end if
ELSE
	IF sSaupj = '' OR IsNull(sSaupj) then sSaupj = Gs_Saupj
	IF sDeptCode = '' OR IsNull(sDeptCode) THEN sDeptCode = Gs_Dept
END IF

ll_currow = dw_list.GetRow()
IF ll_currow <=0 THEN
	ll_currow = 0
	sSeqNo = '0'
ELSE
	IF Wf_RequiredChk(dw_list.GetRow()) = -1 THEN Return
	
   sSeqNo = String(dw_list.GetItemNumber(1, 'imaxseq'))
END IF

//ll_currow = ll_currow + 1
sSeqNo = string(long(sSeqNo) + 1, '000')

ll_currow = dw_list.InsertRow(0)
dw_list.SetItem(ll_currow, 'acc_ym',  sYearMonth)
dw_list.SetItem(ll_currow, 'dept_cd', sDeptCode)
dw_list.SetItem(ll_currow, 'saupj',   sSaupj)
dw_list.Setitem(ll_currow, "seq_no",  sSeqNo)

dw_list.Setitem(ll_currow, "flag",    LsAuthority)

dw_list.ScrollToRow(ll_currow)

dw_list.selectrow(0, false)
dw_list.setcolumn('seq_no')
dw_list.SetFocus()

w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type p_exit from w_inherite`p_exit within w_kfia52
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_kfia52
integer taborder = 80
end type

event p_can::clicked;call super::clicked;dw_mst.SetRedraw(false)
dw_list.SetRedraw(false)
dw_list.reset()

dw_mst.insertrow(0)

dw_mst.enabled = true 

dw_mst.SetItem(dw_mst.GetRow(), 'acc_yymm', string(today(), 'YYYYMM'))
dw_mst.setcolumn('acc_yymm')
dw_mst.setfocus()

dw_mst.SetRedraw(true)
dw_list.SetRedraw(true)

p_del.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

p_ins.Enabled = False
p_ins.PictureName = "C:\erpman\image\추가_d.gif"

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_kfia52
boolean visible = false
integer x = 3072
integer y = 2904
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia52
integer x = 3575
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String   sYearMonth, sSaupj, sDept, sBefYm
Double   dBefAmt

If dw_mst.AcceptText() = -1 then return
sYearMonth = Trim(dw_mst.GetItemString(1,"acc_yymm"))
sSaupj     = dw_mst.GetItemString(1,"saupj")
sDept      = dw_mst.GetItemString(1,"dept")

If trim(sYearMonth) = '' or isnull(sYearMonth) then
	F_MessageChk(1, "[회계년월]")
	dw_mst.Setcolumn('acc_yymm')
	dw_mst.SetFocus()
   Return
End If

If trim(sSaupj) = '' or IsNull(sSaupj) then	sSaupj = '%'
If Trim(sDept) = '' or IsNull(sDept) Then sDept = '%'

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"

dw_list.SetRedraw(false)
If dw_list.Retrieve(sYearMonth, sSaupj, sDept) < 1 then 
	F_MessageChk(14, "")
   dw_list.SetRedraw(true)	
   dw_mst.SetColumn('acc_yymm')
	dw_mst.SetFocus()
	Return 
else
	p_del.enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"

	IF Mid(sYearMonth,5,2) = '01' THEN
		sBefYm  = String(Long(Left(sYearMonth,4)) - 1,'0000')+'12'
	ELSE
		sBefYm  = Left(sYearMonth,4)+String(Integer(Mid(sYearMonth,5,2)) - 1,'00')
	END IF
	
	select nvl(famt,0)		into :dBefAmt	
		from kfm14ot0 a, kfm10om0 b
		where a.finance_cd = b.finance_cd and a.acc_ym = :sBefYm and 
				b.last_cd = 'Y' ;
				
	dw_mst.SetItem(1,"bef_remain", dBefAmt)
End If
dw_list.SetRedraw(true)
dw_list.SetColumn('saup_no')
dw_list.SetFocus()


end event

type p_del from w_inherite`p_del within w_kfia52
integer taborder = 70
end type

event p_del::clicked;call super::clicked;string ls_seq_no

long ll_currow

ll_currow = dw_list.GetRow()

IF ll_currow <=0 Then Return

ls_seq_no = dw_list.GetItemString(ll_currow, 'seq_no')

if trim(ls_seq_no) = '' or isnull(ls_seq_no) then
	F_MessageChk(1, "[순번]")
	dw_list.SetColumn('seq_no')
	dw_list.Setfocus()
	return 
end if

IF F_DbConFirm('삭제') = 2	THEN	RETURN

dw_list.DeleteRow(ll_currow)

dw_list.SetRedraw(false)

IF dw_list.Update() > 0 THEN
	commit;
	IF ll_currow = 1 OR ll_currow <= dw_list.RowCount() THEN
		dw_list.ScrollToRow(ll_currow - 1)
		dw_list.SetColumn('plan_day')				
		dw_list.SetFocus()		
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	F_MessageChk(12,'')
   dw_list.SetRedraw(true)	
	Return
END IF

dw_list.SetRedraw(true)	
end event

type p_mod from w_inherite`p_mod within w_kfia52
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;String   sYearMonth,sSaupj,sDeptCode,sSysGbn
Long     i,iFunVal

If dw_mst.AcceptText() = -1 then return
IF dw_list.Accepttext() = -1 THEN Return

IF dw_list.RowCount() <=0 THEN Return

select substr(dataname,1,1) into :sSysGbn	from syscnfg where sysgu = 'A' and serial = 19 and lineno = '20';

FOR i = 1 TO dw_list.RowCount()
	sYearMonth = Trim(dw_list.GetItemString(i, 'acc_ym'))
	sDeptCode  = dw_list.GetItemString(i,      'dept_cd')
	sSaupj     = dw_list.GetItemString(i,      'saupj')

	IF sYearMonth = '' OR IsNull(sYearMonth) THEN
		F_MessageChk(1, "[회계년월]")
		dw_mst.SetColumn('acc_yymm')
		dw_mst.SetFocus()
		return 
	END IF
	IF sSaupj = '' OR IsNull(sSaupj) THEN
		F_MessageChk(1, "[사업장]")
		dw_mst.SetColumn('saupj')
		dw_mst.SetFocus()
		return 
	END IF
	IF sDeptCode = '' OR IsNull(sDeptCode) THEN
		F_MessageChk(1, "[작성부서]")
		dw_mst.SetColumn('dept')
		dw_mst.SetFocus()
		return 
	END IF

	IF Wf_RequiredChk(i) = -1 THEN Return
NEXT

IF F_DbConFirm('저장') = 2	THEN	RETURN

FOR i = 1 TO dw_list.RowCount()
	IF LsAuthority = 'P' THEN				/*현업*/
		IF sSysGbn = 'Y' THEN								/*자동으로 확정 함*/
			dw_list.SetItem(i,"confirm",'Y')
		END IF
	END IF
NEXT

IF dw_list.Update() = 1 THEN
	
	if Wf_Insert_Bef_Month() = -1 then Return
	
	COMMIT;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
   F_MessageChk(13,'')
	Return
END IF

dw_list.Setfocus()

p_del.enabled = true
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

IF LsAuthority = 'A' THEN						/*자금담당부서*/
	w_mdi_frame.sle_msg.text = '집계 중...'
	SetPointer(HourGlass!)
	iFunVal = Sqlca.fun_create_kfm12ot0(sYearMonth,'P')
	IF iFunVal <> 1 THEN
		Rollback;
		w_mdi_frame.sle_msg.text = ''
		SetPointer(Arrow!)
		Return
	END IF
	Commit;
	w_mdi_frame.sle_msg.text = '집계 완료'
	SetPointer(Arrow!)
END IF
end event

type cb_exit from w_inherite`cb_exit within w_kfia52
boolean visible = false
integer x = 3232
integer y = 2652
end type

type cb_mod from w_inherite`cb_mod within w_kfia52
boolean visible = false
integer x = 2094
end type

type cb_ins from w_inherite`cb_ins within w_kfia52
boolean visible = false
integer x = 2437
integer y = 2660
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_kfia52
boolean visible = false
integer x = 2441
end type

type cb_inq from w_inherite`cb_inq within w_kfia52
boolean visible = false
integer x = 2089
integer y = 2660
end type

type cb_print from w_inherite`cb_print within w_kfia52
boolean visible = false
integer x = 1015
integer y = 3004
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfia52
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfia52
boolean visible = false
integer x = 2789
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_kfia52
boolean visible = false
integer x = 1435
integer y = 2692
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia52
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia52
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfia52
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia52
boolean visible = false
integer x = 155
integer y = 3072
integer width = 1189
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia52
boolean visible = false
integer x = 2176
integer y = 3068
integer width = 1431
end type

type dw_list from datawindow within w_kfia52
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 256
integer width = 4553
integer height = 1964
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_kfia52_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9 ,0)

this.SelectRow(0, FALSE)

// 자동으로 다음 row 추가 
IF This.GetColumnName() = 'etc' then 
	if this.Getrow() = this.RowCount() then 
   	p_ins.TriggerEvent(Clicked!)
	end if
END IF

return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

// 상대처
if this.GetColumnName() = 'saup_no' then
	
	SetNUll(lstr_custom.code)
	SetNUll(lstr_custom.name)
	
	lstr_custom.code = this.object.saup_no[getrow()]
	
	OpenWithParm(w_kfz04om0_popup, '1')
	
   this.SetItem(this.GetRow(), 'saup_no', lstr_custom.code)
   this.SetItem(this.GetRow(), 'saup_nm', lstr_custom.name)
	
	this.TriggerEvent(ItemChanged!)
end if


// 자금수지코드
IF this.GetColumnName() ="finance_cd" THEN
	
	gs_code = this.object.finance_cd[getrow()]
	
	Open(W_kfm10om0_popup)

	IF IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"finance_cd",gs_code)
	
	this.TriggerEvent(ItemChanged!)
END IF
end event

event itemchanged;String scode, sname, sauto_gubun, ls_plan_day, ls_seq_no, ls_acc_yymm, &
       ls_saup_no, ls_saup_nm, get_code, get_name, snull, sFindCol,sIoGu
Long lRow, lReturnRow

SetNull(snull)

lRow = this.Getrow()

If this.GetColumnName() = 'seq_no' then
	ls_seq_no = this.GetText()
	If trim(ls_seq_no) = '' or IsNull(ls_seq_no) then
		F_MessageChk(1, "[순번]")
		Return 1
	End If
	If Not IsNumber(ls_seq_no) then 
		MessageBox("확 인", "숫자만 입력가능합니다.!!")
		Return 1
	ElseIf long(ls_seq_no) <= 0 then
		MessageBox("확 인", "순번은 0보다 커야 합니다.!!")
		Return 1
	Else
		If len(ls_seq_no) < 3 then
			MessageBox("확 인", "입력범위를 확인하십시오.!!  (000~~999)")
			ls_seq_no = String(long(ls_seq_no), '0000')
			this.SetItem(row, 'seq_no', ls_seq_no)
			Return 1
		End If
	End If
	
   lRow = this.Getrow()	
	sFindCol = GetColumnName()
//	sCode = this.GetText()
	
	lReturnRow = this.find("lower(" + sFindCol + ") = ~"" + lower(ls_seq_no) + "~"", &
	                       1, this.rowcount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인", "이미 등록된 [순번]입니다." + "~n" + "~n" + &
		                   "순번을 확인하십시오")
		this.SetItem(lRow, 'seq_no', sNull)
		this.setredraw(True)
		RETURN  1
	END IF
		
End If

If this.GetColumnName() = 'saup_no' then 
	ls_saup_no = this.GetText()
	
	If isnull(ls_saup_no) or trim(ls_saup_no) = "" then
		this.SetItem(row, 'saup_nm', snull)	
		return 
	Else
		SELECT "KFZ04OM0_V1"."PERSON_CD",   
				  "KFZ04OM0_V1"."PERSON_NM"  
		  INTO :get_code,    
			    :get_name  
		  FROM "KFZ04OM0_V1"  
		 WHERE "KFZ04OM0_V1"."PERSON_CD" = :ls_saup_no   ;
		If sqlca.sqlcode = 0 then 	
			this.SetItem(row, 'saup_no', get_code)
			this.SetItem(row, 'saup_nm', get_name)			
		Else
//         F_MessageChk(20, "[상대처]")									
//			this.SetItem(row, 'saup_no', snull)
//			this.SetItem(row, 'saup_nm', snull)						
//			Return 1
		End If 

	End If
End If	

If this.GetColumnName() = 'saup_nm' then 
	
   ls_saup_no = this.GetItemString(row, 'saup_no')
	ls_saup_nm = this.GetText()
	
	If trim(ls_saup_nm) = '' or isnull(ls_saup_nm) then
		If trim(ls_saup_no) = '' or  isnull(ls_saup_no)  then 
			MessageBox("확 인", "상대처 코드가 입력되지 않으면," + "~n" + "~n" + &
			           "상대처명은 반드시 입력되어야 합니다.!!")
		End If
	End If
End If


If this.GetcolumnName() = 'plan_day' then 
	
	ls_plan_day = this.GetText()
	
	If trim(ls_plan_day) = '' or isnull(ls_plan_day) then 
		F_MessageChk(1, "[일자]")
		Return 1
	Else
		ls_acc_yymm = trim(dw_mst.GetItemString(dw_mst.GetRow(), 'acc_yymm'))
		If F_dateChk(ls_acc_yymm + ls_plan_day) = -1 then
			F_MessageChk(21, "[일자]")
			return 1
		end if
	end if
	
end if


IF this.GetColumnName() = "finance_cd"THEN
	
	scode = this.GetText()
	
	SELECT "FINANCE_NAME","AUTO_CD", "IO_CD" INTO :sname, :sauto_gubun, :sIoGu
		FROM "KFM10OM0"
		WHERE "KFM10OM0"."FINANCE_CD" = :scode ;
	IF SQLCA.SQLCODE <> 0 THEN
//		Messagebox("확 인","등록된 자금수지코드가 아닙니다!!")
//		this.SetItem(lRow,"finance_cd",   snull)
//		this.SetItem(lRow,"finance_name", snull)
//		this.SetItem(lRow,"io_cd",        snull)
//		Return 1
	ELSE
		IF sauto_gubun = 'Y' THEN
			MessageBox("확 인","입력하신 자금수지코드는 '자동계산'하는 항목입니다!!")
			this.SetItem(lRow,"finance_cd",   snull)
			this.SetItem(lRow,"finance_name", snull)
			this.SetItem(lRow,"io_cd",        snull)
			Return 1
		END IF
		this.SetItem(lRow,"finance_name",sname)
		this.SetItem(lRow,"io_cd",       sIoGu)
	END IF
	
END IF
ib_any_typing =True
end event

event itemerror;return 1
end event

event editchanged;ib_any_typing = true 
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ='saup_nm' or this.GetColumnName() = 'descr' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF

end event

event rowfocuschanged;//if currentrow <= 0 then
//	this.SelectRow(0, FALSE)
//else
//	this.SelectRow(0, FALSE)
//	this.SelectRow(currentrow, TRUE)
//	this.ScrollToRow(currentrow)
//end if
//
end event

event getfocus;this.AcceptText()
end event

event retrieveend;Integer   i

this.SetRedraw(False)
if rowcount > 0 then
	for i = 1 to rowCount
		this.Setitem(i, "flag",LsAuthority)	
	next
end if
this.SetRedraw(True)

end event

type dw_mst from datawindow within w_kfia52
event ue_enterkey pbm_dwnprocessenter
integer x = 32
integer y = 12
integer width = 2089
integer height = 220
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kfia52_01"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)

return 1
end event

event itemerror;return 1
end event

event itemchanged;String    sYearMonth, sSaupj, sDept,snull

SetNull(snull)

if this.GetColumnName() = 'acc_yymm' then
	sYearMonth = Trim(this.GetText())
	if trim(sYearMonth) = '' or isnull(sYearMonth) then return 
	
	if F_dateChk(sYearMonth +'01') = -1 then 
		MessageBox("확 인", "유효한 회계년월이 아닙니다.!!")
		this.SetItem(1,"acc_yymm",snull)
		return 1
	end if
	
	dw_list.Reset()
end if

If this.GetColumnName() = 'saupj' then
	sSaupj = this.GetText()
	sYearMonth = this.GetItemString(1, "acc_yymm")
	If trim(sSaupj) = '' or IsNull(sSaupj) then Return

	dw_list.Reset()
End If

If this.GetColumnName() = 'dept' then
	sDept = this.GetText()
	If Trim(sDept) = '' or IsNull(sDept) Then Return

	dw_list.Reset()
End If
end event

event losefocus;this.AcceptText()
end event

type cb_copy from commandbutton within w_kfia52
boolean visible = false
integer x = 2784
integer y = 2660
integer width = 430
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "자료복사(&Q)"
end type

type gb_3 from groupbox within w_kfia52
integer x = 2615
integer width = 777
integer height = 228
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_kfia52
integer x = 2176
integer y = 4
integer width = 411
integer height = 224
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "확정"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kfia52
integer x = 2208
integer y = 52
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체 확정"
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

dw_list.SetRedraw(False)
FOR i = 1 TO dw_list.RowCount()
	dw_list.SetItem(i,"confirm",'Y')
NEXT
dw_list.SetRedraw(True)
end event

type rb_2 from radiobutton within w_kfia52
integer x = 2208
integer y = 128
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "개별 확정"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer i

dw_list.SetRedraw(False)
FOR i = 1 TO dw_list.RowCount()
	dw_list.SetItem(i,"confirm",'N')
NEXT
dw_list.SetRedraw(True)
end event

type cbx_1 from checkbox within w_kfia52
integer x = 2647
integer y = 88
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "월자금수지계획 미리보기"
borderstyle borderstyle = stylelowered!
end type

event clicked;String sYearMonth, sSaupj, sDept,sGubun

If dw_mst.AcceptText() = -1 then return
sYearMonth = Trim(dw_mst.GetItemString(1,"acc_yymm"))
sSaupj     = dw_mst.GetItemString(1,"saupj")
sDept      = dw_mst.GetItemString(1,"dept")

If trim(sYearMonth) = '' or isnull(sYearMonth) then
	F_MessageChk(1, "[회계년월]")
	dw_mst.Setcolumn('acc_yymm')
	dw_mst.SetFocus()
   Return
End If

If trim(sSaupj) = '' or IsNull(sSaupj) then	sSaupj = '%'
If Trim(sDept) = '' or IsNull(sDept) Then sDept = '%'

if sSaupj = '%' and sDept = '%' then
	sGubun = '%'
else
	sGubun = '2'
end if
cbx_1.Checked = False

iw_preview.title = '월자금수지내역'
iw_preview.dw_preview.dataobject = 'dw_kfia53_02_p'
iw_preview.dw_preview.settransobject(sqlca)
iw_preview.dw_preview.modify( 'datawindow.print.preview=yes &
					datawindow.print.preview.zoom=100 datawindow.print.orientation=2 &
					datawindow.print.margin.left=100 datawindow.zoom=100' )

iw_preview.dw_preview.reset()	
IF iw_preview.dw_preview.retrieve(sYearMonth,sSaupj,sDept,sGubun) <=0 THEN
	f_messagechk(14,'')
	iw_preview.Visible = False
	Return	
END IF
iw_preview.Visible =True

end event

type p_copy from uo_picture within w_kfia52
integer x = 3401
integer y = 24
integer width = 178
integer taborder = 10
boolean bringtotop = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;s_soyo is_soyo
long ll_rowcnt

ll_rowcnt = dw_mst.GetRow()
if ll_rowcnt < 1 then return 

if dw_mst.AcceptText() = -1 then return
is_soyo.lstr_yymm    = Trim(dw_mst.GetItemString(ll_rowcnt, 'acc_yymm'))
is_soyo.lstr_saupj   = dw_mst.GetItemString(ll_rowcnt, 'saupj')
is_soyo.lstr_dept    = dw_mst.GetItemString(ll_rowcnt, 'dept')
is_soyo.lstr_return1 = '0'

if trim(is_soyo.lstr_yymm) = '' or isnull(is_soyo.lstr_yymm) then
	F_MessageChk(1, "[회계년월]")
	dw_mst.Setcolumn('acc_yymm')
	dw_mst.SetFocus()
	return 
else 
	if f_datechk(is_soyo.lstr_yymm + "01") = -1 then 
		MessageBox("확 인", "유효한 회계년월이 아닙니다.!!")
		dw_mst.Setcolumn('acc_yymm')
		dw_mst.SetFocus()		
		return 
	end if
end if

IF LsAuthority = 'P' THEN
	if trim(is_soyo.lstr_saupj) = '' or isnull(is_soyo.lstr_saupj) then
		f_messagechk(1,"[사업장]")
		dw_mst.SetColumn('saupj')
		dw_mst.SetFocus()
		return
	End if
	
	if trim(is_soyo.lstr_dept) = '' or isnull(is_soyo.lstr_dept) then
		f_messagechk(1,"[작성부서]")
		dw_mst.SetColumn('dept')
		dw_mst.Setfocus()
		return
	end if
ELSE
	if trim(is_soyo.lstr_saupj) = '' or isnull(is_soyo.lstr_saupj) then is_soyo.lstr_saupj = '%'
	if trim(is_soyo.lstr_dept) = '' or isnull(is_soyo.lstr_dept) then is_soyo.lstr_dept = '%'
END IF

OpenWithParm(w_kfia521, is_soyo)

is_soyo = Message.PowerObjectParm

/* Return = '1'이면 성공 */
If IsValid(Message.PowerObjectParm) = True Then
	If is_soyo.lstr_return1 = '1' then
		p_inq.PostEvent(Clicked!)
	Else
		dw_mst.Setcolumn('acc_yymm')
 	 	dw_mst.SetFocus()
	End If
Else
	dw_mst.Setcolumn('acc_yymm')
	dw_mst.SetFocus()
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type rr_1 from roundrectangle within w_kfia52
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 244
integer width = 4576
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

