$PBExportHeader$w_imt_01000.srw
$PBExportComments$** 연동소요계획 조정
forward
global type w_imt_01000 from w_inherite
end type
type gb_1 from groupbox within w_imt_01000
end type
type gb_3 from groupbox within w_imt_01000
end type
type gb_2 from groupbox within w_imt_01000
end type
type dw_1 from u_key_enter within w_imt_01000
end type
type cb_1 from commandbutton within w_imt_01000
end type
type rr_1 from roundrectangle within w_imt_01000
end type
type rr_2 from roundrectangle within w_imt_01000
end type
end forward

global type w_imt_01000 from w_inherite
string title = "연동 소요계획 조정"
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
cb_1 cb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_01000 w_imt_01000

type variables
string is_pspec, is_jijil
end variables

forward prototypes
public function integer wf_new_setting (long crow)
public function integer wf_required_chk ()
public function integer wf_danga_setting (long crow, string arg_itnbr, string arg_pspec)
public function integer wf_chkdata (string colnm, long crow, string pa, string arg_pspec)
end prototypes

public function integer wf_new_setting (long crow);//현재고,가용재고,예상재고,업체재고 검색
String  cym, itnbr, cvcod, sItgu 
decimal junqty, vndqty, curqty, gaqty, exqty, minsaf

cym   = dw_1.object.cym[1]
itnbr = trim(dw_insert.object.itnbr[crow])
cvcod = trim(dw_insert.object.mtrvnd[crow])

select Nvl(fun_erp000000130(:gs_sabu, :cym, :cvcod, :itnbr, '1'), 0) as junqty,
		 Nvl(erp000000110('ALL', s.itnbr, '.', '1'), 0) as curqty,
		 Nvl(erp000000110('ALL', s.itnbr, '.', '2'), 0) as gaqty,
		 Nvl(erp000000110('ALL', s.itnbr, '.', '3'), 0) as expqty, 
       s.itgu, s.minsaf 
  into :junqty,  :curqty,   :gaqty,   :exqty,   :sItgu,   :minsaf 
  from itemas s
 where s.itnbr = :itnbr ;

//소요량
//dw_insert.object.mtrqty1[crow] = mtrqty1
//dw_insert.object.mtrqty2[crow] = mtrqty2
//dw_insert.object.mtrqty3[crow] = mtrqty3
////권고량
//dw_insert.object.ntrqty1[crow] = ntrqty1
//dw_insert.object.ntrqty2[crow] = ntrqty2
//dw_insert.object.ntrqty3[crow] = ntrqty3
//BOM소요량
//dw_insert.object.toqty1[crow] = toqty1
//dw_insert.object.toqty2[crow] = toqty2
//dw_insert.object.toqty3[crow] = toqty3

dw_insert.object.junqty[crow] = junqty
dw_insert.object.mtrpln_int_curqty[crow] = curqty
dw_insert.object.mtrpln_int_gaqty[crow] = gaqty
dw_insert.object.expqty[crow] = exqty
dw_insert.object.itemas_itgu[crow] = sitgu
dw_insert.object.minsaf[crow] = minsaf

IF sitgu = '3' or sitgu = '4' then 
	dw_insert.object.mtrpln_sum_itgu[crow] = '2'
ELSE	
	dw_insert.object.mtrpln_sum_itgu[crow] = '1'
END IF	

return 1
end function

public function integer wf_required_chk ();//필수입력항목 체크
Long i, icount
if dw_insert.AcceptText() = -1 then
	if dw_insert.RowCount() >= 1 then dw_insert.SetFocus()
	return -1
end if	

icount = dw_insert.RowCount()
if icount < 1 then return -1

for i = 1 to icount
	dw_insert.object.sabu[i] = gs_sabu
   dw_insert.object.mtryymm[i] = dw_1.object.cym[1]
	dw_insert.object.mrseq[i] = dw_1.object.mrseq[1]

	if Isnull(dw_insert.object.mtrvnd[i]) or dw_insert.object.mtrvnd[i] = "" then
		f_message_chk(1400, "[거래처코드]")
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn("mtrvnd")
		dw_insert.SetFocus()
		return -1
   end if	
   if Isnull(dw_insert.object.itnbr[i]) or dw_insert.object.itnbr[i] = "" then
		f_message_chk(1400, "[품번]")
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn("itnbr")
		dw_insert.SetFocus()
		return -1
   end if	
next

return 1
end function

public function integer wf_danga_setting (long crow, string arg_itnbr, string arg_pspec);String sCvcod, sCvnas, sTuncu, sname
Decimal {2} dUnprc

f_buy_unprc(arg_itnbr, arg_pspec,  '9999', sCvcod, sCvnas, dUnprc, sTuncu)

dw_insert.object.mtrvnd[crow]  = sCvcod
dw_insert.object.cvnas2[crow] = sCvnas
dw_insert.object.mtrprc[crow] = dUnprc

select b.emp_id
  into :sname
  from vndmst b
 where b.cvcod = :scvcod;
 
dw_insert.object.emp_id[crow] = sName

return 1
end function

public function integer wf_chkdata (string colnm, long crow, string pa, string arg_pspec);String s_cod, s_nam1, s_nam2, s_nam3, s_nam4
Integer i_rtn

if colnm = "mtrvnd" then
	s_cod = pa
	i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
	dw_insert.object.mtrvnd[crow] = s_cod
	dw_insert.object.cvnas2[crow] = s_nam1	
	return i_rtn
elseif colnm = "itnbr" then
	s_cod = pa
	i_rtn = f_get_name4("품번", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	dw_insert.object.itemas_jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
	wf_danga_setting(crow, s_cod, arg_pspec)
	wf_new_setting(crow)	
	return i_rtn
elseif colnm = "itdsc" then
	s_nam1 = pa
	i_rtn = f_get_name4("품명", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	dw_insert.object.itemas_jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
	wf_danga_setting(crow, s_cod, arg_pspec)
	wf_new_setting(crow)	
	return i_rtn
elseif colnm = "ispec" then
	s_nam2 = pa
	i_rtn = f_get_name4("규격", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	dw_insert.object.itemas_jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
	wf_danga_setting(crow, s_cod, arg_pspec)
	wf_new_setting(crow)	
	return i_rtn
ELSEIF colnm = "itemas_jijil"	THEN
	s_nam3 = pa
	i_rtn = f_get_name4("재질", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	dw_insert.object.itemas_jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
	wf_danga_setting(crow, s_cod, arg_pspec)
	wf_new_setting(crow)	
	return i_rtn
ELSEIF colnm = "ispec_code"	THEN
	s_nam4 = pa
	i_rtn = f_get_name4("규격코드", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	dw_insert.object.itnbr[crow] = s_cod
	dw_insert.object.itdsc[crow] = s_nam1
	dw_insert.object.ispec[crow] = s_nam2
	dw_insert.object.itemas_jijil[crow] = s_nam3
	dw_insert.object.ispec_code[crow] = s_nam4
	wf_danga_setting(crow, s_cod, arg_pspec)
	wf_new_setting(crow)	
	return i_rtn
END IF

end function

on w_imt_01000.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_imt_01000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;f_child_saupj(dw_1, 'empno', gs_saupj)

dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.ReSet()

dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetFocus()

/* 부가 사업장 */
f_mod_saupj(dw_1,'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_imt_01000
integer x = 46
integer y = 328
integer width = 4549
integer height = 1988
integer taborder = 30
string dataobject = "d_imt_01000_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_cod, s_col, cvcod, itnbr, empno, scvcod, scvnas, sNull, sName, sCvgu 
Decimal {2} dunprc
Integer i_rtn , ireturn
Long    	crow, frow
Real    	danga
String		ls_pspec

this.AcceptText()

Setnull(sNull)
s_cod = Trim(this.GetText())
empno = trim(dw_1.object.empno[1])

sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes

s_col 		= this.GetColumnName()
crow 		= this.GetRow()
cvcod  	= this.object.mtrvnd[crow]	
ls_pspec	= '.'

if (s_col = "mtrvnd") or (s_col = "itnbr") or (s_col = "itdsc") or (s_col = "ispec") or &
   (s_col = "jijil") or (s_col = "ispec_code")   then
	i_rtn = wf_chkdata(s_col, crow, s_cod, ls_pspec)
	if i_rtn = 1 then return i_rtn
end if

itnbr  = this.object.itnbr[crow]

// 동일한 품번이 조회하는지 check
if (s_col = "itnbr") or (s_col = "itdsc") or (s_col = "ispec") or &
   (s_col = "itemas_jijil") or (s_col = "ispec_code") then
	frow = 0
	frow = find("itnbr = '"+ itnbr +"'", 0, rowcount())
	if frow > 0 and frow <> crow then
		this.object.itnbr[crow] = snull
		dw_insert.object.itnbr[crow] = snull
		dw_insert.object.itdsc[crow] = snull
		dw_insert.object.ispec[crow] = snull
		dw_insert.object.itemas_jijil[crow] = snull
		dw_insert.object.ispec_code[crow] = snull
		f_message_chk(37, '[계획품번]')
		return 1
	end if
end if

if s_col = 'mtrvnd' then	
	/* 거래처 check */
	select emp_id
	  into :sName
	  from vndmst a
	 where a.cvcod = :cvcod   ;

	dw_insert.object.emp_id[crow] = sname
end if
end event

event dw_insert::rbuttondown;Long crow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
crow = this.GetRow()

if this.GetColumnName() = "mtrvnd" then
	gs_code = this.object.itnbr[crow]
	gs_codename = '9999'
	open(w_danmst_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
	this.object.mtrvnd[crow] = gs_code
	this.object.mtrprc[crow] = dec(gs_codename)
	this.TriggerEvent(itemchanged!)
elseif this.GetColumnName() = "itnbr" or this.GetColumnName() = "itdsc" or &
	    this.GetColumnName() = "ispec" then
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr[crow] = gs_code
	this.object.itdsc[crow] = gs_codename
	this.TriggerEvent(itemchanged!)
end if	
end event

event dw_insert::ue_key;call super::ue_key;Long crow
SetNull(gs_code)
SetNull(gs_codename)
crow = this.GetRow()
if keydown(keyF2!) THEN	
	if this.GetColumnName() = "itnbr" or this.GetColumnName() = "itdsc" or &
	    this.GetColumnName() = "ispec" then
	   open(w_itemas_popup2)
	   this.object.itnbr[crow] = gs_code
	   this.object.itdsc[crow] = gs_codename
	   this.TriggerEvent(itemchanged!)
	end if	
END IF
end event

event dw_insert::doubleclicked;if row < 1 then return 
if this.rowcount() < 1 then return 

gs_gubun 	= 'w_imt_01000'
gs_code  	= this.getitemstring(row, 'itnbr')
gs_codename = this.getitemstring(row, 'mtryymm')

OPEN(w_pdt_07400)
end event

type p_delrow from w_inherite`p_delrow within w_imt_01000
boolean visible = false
integer x = 3845
integer y = 2760
end type

type p_addrow from w_inherite`p_addrow within w_imt_01000
boolean visible = false
integer x = 4069
integer y = 2764
end type

type p_search from w_inherite`p_search within w_imt_01000
integer x = 3273
integer width = 306
string picturename = "C:\erpman\image\정기발주의뢰_up.gif"
end type

event p_search::clicked;call super::clicked;open(w_imt_01600)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\정기발주의뢰_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\정기발주의뢰_up.gif"
end event

type p_ins from w_inherite`p_ins within w_imt_01000
integer x = 3749
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)

//dw_insert.object.sabu[crow] = gs_sabu
//dw_insert.object.mtryymm[crow] = dw_1.object.cym[1]
//dw_insert.object.mrseq[crow] = dw_1.object.mrseq[1]
//dw_insert.object.gub[crow] = 0 //구분

dw_insert.object.mtrprc[crow] = 0 //우선거래처단가
dw_insert.Setredraw(True)
dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_imt_01000
end type

type p_can from w_inherite`p_can within w_imt_01000
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.ReSet()
f_child_saupj(dw_1, 'empno', gs_saupj)
dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()

f_mod_saupj(dw_1, 'saupj')

p_ins.enabled = False
p_ins.pictureName = "C:\erpman\image\추가_d.gif"
p_mod.Enabled = False
p_mod.pictureName = "C:\erpman\image\저장_d.gif"
p_del.Enabled = False
p_del.pictureName = "C:\erpman\image\삭제_d.gif"

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_imt_01000
boolean visible = false
integer x = 4265
integer y = 2776
end type

type p_inq from w_inherite`p_inq within w_imt_01000
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String cym, itnbr1, itnbr2, itgu1, itgu2, empno, scvcod, ssaupj
Integer mrseq

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return
end if	

cym = dw_1.object.cym[1]
mrseq = dw_1.object.mrseq[1]
itnbr1 = dw_1.object.itnbr1[1]
itnbr2 = dw_1.object.itnbr2[1]
ssaupj = dw_1.object.saupj[1]
itgu1 = String(dw_1.object.itgu[1])
empno = Trim(dw_1.object.empno[1])
scvcod = Trim(dw_1.object.cvcod[1])

if itgu1 = "1" then //내자
   itgu2 = "1"
elseif itgu1 = "2" then //외자
   itgu2 = "2"
else
	itgu1 = "1"
	itgu2 = "9"
end if	

if IsNull(cym) or cym = "" then
	f_message_chk(30, "[기준년월]")
	dw_1.SetColumn("cym")
	dw_1.Setfocus()
	return 
elseif f_datechk(cym + '01') = -1 then 
	f_message_chk(35, "[기준년월]")
	dw_1.SetColumn("cym")
	dw_1.Setfocus()
	return 
end if

if mrseq < 0 and mrseq > 9 then
	MessageBox("계획차수 확인","계획차수가 잘못 되었습니다!")
	dw_1.SetColumn("cym")
	dw_1.Setfocus()
	return 
end if	

if IsNull(scvcod) or scvcod = "" then scvcod = "%"
if IsNull(itnbr1) or itnbr1 = "" then itnbr1 = "."
if IsNull(itnbr2) or itnbr2 = "" then itnbr2 = "ZZZZZZZZZZZZZZZ"

dw_insert.SetRedraw(False)

if IsNull(empno) or empno = "" then
   dw_insert.SetFilter("")
   dw_insert.Filter()
else	
	//거래처에 구매담당자가 기록되어 있지 않으면 '01'번 구매담당자가 담당한다. 
	if empno = '01' then 
		dw_insert.SetFilter("emp_id = '" + empno + "'" + "or IsNull(emp_id)")
	   dw_insert.Filter()
	else
		dw_insert.SetFilter("emp_id = '" + empno + "'")
	   dw_insert.Filter()
	end if	
end if	

if dw_insert.Retrieve(gs_sabu, cym, mrseq, itnbr1, itnbr2, itgu1, itgu2, scvcod, ssaupj) < 1 then 
   f_message_chk(50, "[연동소요계획 조정]")
else
	dw_insert.setfocus()
end if	


p_ins.enabled = true
p_ins.pictureName = "C:\erpman\image\추가_up.gif"
p_mod.Enabled = True
p_mod.pictureName = "C:\erpman\image\저장_up.gif"
p_del.Enabled = True
p_del.pictureName = "C:\erpman\image\삭제_up.gif"
dw_insert.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_imt_01000
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long 	lcRow
Boolean fg

if f_msg_delete() = -1 then return
lcRow = dw_insert.GetRow()
if lcRow <= 0 then return
	
if IsNull(Trim(dw_insert.object.sabu[lcRow])) or Trim(dw_insert.object.sabu[lcRow]) = "" then
	fg = False
else 
	fg = True
end if	
dw_insert.DeleteRow(lcRow)
if fg = True then
	if dw_insert.Update() = 1 then
	   COMMIT;
	   w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
   else	
      ROLLBACK;
	   f_message_chk(31,'[삭제실패]') 
	   w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	   Return
	end if	
end if

ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_imt_01000
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return -1
SetPointer(HourGlass!)

if wf_required_chk() = -1 then return //필수입력항목 체크 
if f_msg_update() = -1 then return  //저장 Yes/No ?
if dw_insert.Update() = 1 then
	COMMIT;
	
	Long lrow
	For lrow = 1 to dw_insert.rowcount()
		 dw_insert.setitem(lrow, "gub", 1)
	Next
	
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"
	ib_any_typing = False //입력필드 변경여부 No
else
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_imt_01000
integer x = 3227
integer y = 2832
end type

type cb_mod from w_inherite`cb_mod within w_imt_01000
integer x = 2185
integer y = 2832
integer taborder = 50
boolean enabled = false
end type

event cb_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return -1
SetPointer(HourGlass!)

if wf_required_chk() = -1 then return //필수입력항목 체크 
if f_msg_update() = -1 then return  //저장 Yes/No ?
if dw_insert.Update() = 1 then
	COMMIT;
	
	Long lrow
	For lrow = 1 to dw_insert.rowcount()
		 dw_insert.setitem(lrow, "gub", 1)
	Next
	
	sle_msg.text = "저장 되었습니다!"
	ib_any_typing = False //입력필드 변경여부 No
else
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
   sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_ins from w_inherite`cb_ins within w_imt_01000
integer x = 384
integer y = 2832
integer taborder = 40
boolean enabled = false
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)

//dw_insert.object.sabu[crow] = gs_sabu
//dw_insert.object.mtryymm[crow] = dw_1.object.cym[1]
//dw_insert.object.mrseq[crow] = dw_1.object.mrseq[1]
//dw_insert.object.gub[crow] = 0 //구분

dw_insert.object.mtrprc[crow] = 0 //우선거래처단가
dw_insert.Setredraw(True)
dw_insert.SetColumn("itnbr")
dw_insert.SetFocus()
end event

type cb_del from w_inherite`cb_del within w_imt_01000
integer x = 2533
integer y = 2832
integer taborder = 60
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;long 	lcRow
Boolean fg

if f_msg_delete() = -1 then return
lcRow = dw_insert.GetRow()
if lcRow <= 0 then return
	
if IsNull(Trim(dw_insert.object.sabu[lcRow])) or Trim(dw_insert.object.sabu[lcRow]) = "" then
	fg = False
else 
	fg = True
end if	
dw_insert.DeleteRow(lcRow)
if fg = True then
	if dw_insert.Update() = 1 then
	   COMMIT;
	   sle_msg.Text = "삭제 되었습니다!"
   else	
      ROLLBACK;
	   f_message_chk(31,'[삭제실패]') 
	   sle_msg.Text = "삭제 작업 실패!"
	   Return
	end if	
end if

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_inq from w_inherite`cb_inq within w_imt_01000
integer x = 32
integer y = 2832
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String cym, itnbr1, itnbr2, itgu1, itgu2, empno, scvcod
Integer mrseq

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return
end if	

cym = dw_1.object.cym[1]
mrseq = dw_1.object.mrseq[1]
itnbr1 = dw_1.object.itnbr1[1]
itnbr2 = dw_1.object.itnbr2[1]
itgu1 = String(dw_1.object.itgu[1])
empno = Trim(dw_1.object.empno[1])
scvcod = Trim(dw_1.object.cvcod[1])

if itgu1 = "1" then //내자
   itgu2 = "1"
elseif itgu1 = "2" then //외자
   itgu2 = "2"
else
	itgu1 = "1"
	itgu2 = "9"
end if	

if IsNull(cym) or cym = "" then
	f_message_chk(30, "[기준년월]")
	dw_1.SetColumn("cym")
	dw_1.Setfocus()
	return 
elseif f_datechk(cym + '01') = -1 then 
	f_message_chk(35, "[기준년월]")
	dw_1.SetColumn("cym")
	dw_1.Setfocus()
	return 
end if

if mrseq < 0 and mrseq > 9 then
	MessageBox("계획차수 확인","계획차수가 잘못 되었습니다!")
	dw_1.SetColumn("cym")
	dw_1.Setfocus()
	return 
end if	

if IsNull(scvcod) or scvcod = "" then scvcod = "%"
if IsNull(itnbr1) or itnbr1 = "" then itnbr1 = "."
if IsNull(itnbr2) or itnbr2 = "" then itnbr2 = "ZZZZZZZZZZZZZZZ"

dw_insert.SetRedraw(False)

if IsNull(empno) or empno = "" then
   dw_insert.SetFilter("")
   dw_insert.Filter()
else	
	//거래처에 구매담당자가 기록되어 있지 않으면 '01'번 구매담당자가 담당한다. 
	if empno = '01' then 
		dw_insert.SetFilter("emp_id = '" + empno + "'" + "or IsNull(emp_id)")
	   dw_insert.Filter()
	else
		dw_insert.SetFilter("emp_id = '" + empno + "'")
	   dw_insert.Filter()
	end if	
end if	

if dw_insert.Retrieve(gs_sabu, cym, mrseq, itnbr1, itnbr2, itgu1, itgu2, scvcod) < 1 then 
   f_message_chk(50, "[연동소요계획 조정]")
else
	dw_insert.setfocus()
end if	

cb_ins.Enabled = True
cb_mod.Enabled = True
cb_del.Enabled = True

dw_insert.SetRedraw(True)

end event

type cb_print from w_inherite`cb_print within w_imt_01000
integer x = 1993
end type

type st_1 from w_inherite`st_1 within w_imt_01000
end type

type cb_can from w_inherite`cb_can within w_imt_01000
integer x = 2880
integer y = 2832
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.ReSet()
dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()

cb_ins.Enabled = False
cb_mod.Enabled = False
cb_del.Enabled = False

sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type cb_search from w_inherite`cb_search within w_imt_01000
integer x = 1385
integer y = 2788
end type





type gb_10 from w_inherite`gb_10 within w_imt_01000
integer x = 160
integer y = 2736
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_01000
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_01000
end type

type gb_1 from groupbox within w_imt_01000
boolean visible = false
integer x = 1029
integer y = 2776
integer width = 795
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_imt_01000
boolean visible = false
integer y = 2776
integer width = 750
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_imt_01000
boolean visible = false
integer x = 2153
integer y = 2776
integer width = 1440
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from u_key_enter within w_imt_01000
event ue_key pbm_dwnkey
integer x = 59
integer y = 28
integer width = 3168
integer height = 244
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_01000_01"
boolean border = false
end type

event ue_key;SetNull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN	
	if this.getcolumnname() = "itnbr1" then //품번1
	   open(w_itemas_popup2)
	   this.object.itnbr1[1] = gs_code
		return
   elseif this.getcolumnname() = "itnbr2" then //품번2
	   open(w_itemas_popup2)
	   this.object.itnbr2[1] = gs_code
		return
   end if
END IF
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "cym" then //기준년월
   if f_datechk(s_cod + '01') = -1 then
	   f_message_chk(35,"[기준년월]")
	   this.object.cym[1] = ""
		this.object.mrseq[1] = 0
	   return 1
   end if
   
	select max(mrseq) into :i_rtn
	  from mtrpln_sum
	 where sabu = :gs_sabu and mtryymm = :s_cod;
	 

	if sqlca.sqlcode <> 0 or i_rtn < 1 or IsNull(i_rtn) then
		messagebox("계획차수 확인", mid(s_cod,1,4) + "년" + mid(s_cod,5,2) + "월" + &
                 "연동소요계획 차수를 찾을 수 없습니다! (1차로 적용)")
		this.object.mrseq[1] = 1
	else 
		this.object.mrseq[1] = i_rtn
	end if	
elseif this.getcolumnname() = 'cvcod' then 
	s_cod = this.gettext()
	
	i_rtn = f_get_name2("V1", "Y", s_cod, s_nam1, s_nam2)
	this.object.cvcod[1] = s_cod
	this.object.cvname[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itnbr1' then 
	s_cod = this.gettext()
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1]  = s_cod
	this.object.itdsc1[1]  = s_nam1
	return i_rtn 
elseif this.getcolumnname() = 'itnbr2' then 
	s_cod = this.gettext()
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1]  = s_cod
	this.object.itdsc2[1]  = s_nam1
	return i_rtn 
elseif this.getcolumnname() = 'itdsc1' then 
	s_nam1 = this.gettext()
	i_rtn  = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1]  = s_cod
	this.object.itdsc1[1]  = s_nam1
	return i_rtn
elseif this.getcolumnname() = 'itdsc2' then 
	s_nam1 = this.gettext()
	i_rtn  = f_get_name2("품명", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1]  = s_cod
	this.object.itdsc2[1]  = s_nam1
	return i_rtn		
elseif this.getcolumnname() = 'sortgu' then 
	s_cod  = this.gettext()
	if s_cod = '1' then 
		dw_insert.setsort("itnbr A")
		dw_insert.sort()
	else
		dw_insert.setsort("itdsc A, ispec A, itnbr A")
		dw_insert.sort()		
	end if
elseif GetColumnName() = 'saupj' then
	s_cod = gettext()
	if s_cod = '' OR ISNull(s_cod) then return
	setitem(1,'empno','')
	f_child_saupj(dw_1, 'empno', s_cod)
end if

return

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
if this.getcolumnname() = "itnbr1" then //품번1
   gs_gubun ='3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
elseif this.getcolumnname() = "itnbr2" then //품번2
   gs_gubun ='3'
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
elseif this.getcolumnname() = "cvcod"	then
   gs_gubun ='1'
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvname", gs_codename)
end if	
end event

event getfocus;//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
//dw_insert.SetRedraw(False)
//dw_insert.ReSet()
//dw_insert.SetRedraw(True)
end event

type cb_1 from commandbutton within w_imt_01000
boolean visible = false
integer x = 1120
integer y = 2832
integer width = 613
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "정기발주의뢰"
end type

event clicked;open(w_imt_01600)
end event

type rr_1 from roundrectangle within w_imt_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 20
integer width = 3200
integer height = 268
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 304
integer width = 4567
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 46
end type

