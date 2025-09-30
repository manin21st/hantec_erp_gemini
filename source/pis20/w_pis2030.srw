$PBExportHeader$w_pis2030.srw
$PBExportComments$일시(현금)상환 등록-복지회
forward
global type w_pis2030 from w_inherite_standard
end type
type dw_ip from u_key_enter within w_pis2030
end type
type dw_1 from u_key_enter within w_pis2030
end type
type dw_lst from u_d_popup_sort within w_pis2030
end type
type rr_1 from roundrectangle within w_pis2030
end type
type rr_2 from roundrectangle within w_pis2030
end type
end forward

global type w_pis2030 from w_inherite_standard
string title = "일시(현금)상환 등록"
dw_ip dw_ip
dw_1 dw_1
dw_lst dw_lst
rr_1 rr_1
rr_2 rr_2
end type
global w_pis2030 w_pis2030

type variables
string is_gubun = '1'
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function integer wf_check_retdate (string sretdate)
public function integer wf_update_master ()
end prototypes

public function integer wf_requiredchk (integer icurrow);string ls_retdate, snull

setnull(snull)

if dw_1.accepttext() = -1 then return -1

ls_retdate = dw_1.getitemstring(icurrow, 'retdate')

if ls_retdate = '' or isnull(ls_retdate) then
	messagebox("확  인", "상환일자를 입력하세요.")
	return -1
end if

IF f_datechk(ls_retdate) = -1 THEN 
	MessageBox("확  인", "상환일자를 확인하세요.")
	dw_1.setitem(icurrow, 'retdate', snull)
	dw_1.setcolumn('retdate')
	dw_1.setfocus()
	Return -1
END IF

return 1
end function

public function integer wf_check_retdate (string sretdate);String sLendDate,sPaySubMaxDate,sLendKind,sLendEmp

sLendDate = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"lenddate")
sLendKind = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"lendkind")
sLendEmp  = dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"empno")

if sLendDate > sRetDate then
	MessageBox('확 인','대출일자보다 작을수는 없습니다.')
	Return -1
end if

select max(nvl(retdate,''))		into :sPaySubMaxDate
	from p5_lendsch
	where lendgbn = :Is_Gubun and lendkind = :sLendKind and empno = :sLendEmp and lenddate = :sLendDate and
			subgbn = 'Y' and retgbn = '1' ;
if sqlca.sqlcode = 0 then
	if IsNull(sPaySubMaxDate) then sPaySubMaxDate = '0'
else
	sPaySubMaxDate = '0'
end if

if sPaySubMaxDate <> '0' then
	if sRetDate < sPaySubMaxDate then
		MessageBox('확 인','급여 공제 이전으로는 넣을 수 없습니다.')
		Return -1
	end if
end if

return 1
end function

public function integer wf_update_master ();String  sLendDate,sLendEmp,sLendGbn
Double  dAllRetAmt,dLendAmt,dLendRetAmt

sLendDate = dw_lst.GetItemString(dw_lst.GetSelectedRow(0), "lenddate")
sLendEmp  = dw_lst.GetItemString(dw_lst.GetSelectedRow(0), "empno")
sLendGbn = dw_lst.GetItemString(dw_lst.GetSelectedRow(0), "lendGbn")

dLendAmt  = dw_lst.GetItemNumber(dw_lst.GetSelectedRow(0), "lendamt")
if IsNull(dLendAmt) then dLendAmt = 0

dLendRetAmt  = dw_lst.GetItemNumber(dw_lst.GetSelectedRow(0), "lendretamt")
if IsNull(dLendRetAmt) then dLendRetAmt = 0

dw_1.AcceptText()
if dw_1.RowCount() <=0 then
	dAllRetAmt = 0
else
	dAllRetAmt = dw_1.GetItemNumber(dw_1.RowCount(),"sum_allretamt")
	if IsNull(dAllRetAmt) then dAllRetAmt = 0
end if

dw_lst.SetItem(dw_lst.GetSelectedRow(0),"lendallamt",dAllRetAmt)
dw_lst.SetItem(dw_lst.GetSelectedRow(0),"remain",    dLendAmt - dLendRetAmt - dAllRetAmt)
	
return 1

end function

on w_pis2030.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_1=create dw_1
this.dw_lst=create dw_lst
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_lst
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pis2030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_1)
destroy(this.dw_lst)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_lst.settransobject(sqlca)

is_saupcd = gs_saupcd

dw_ip.InsertRow(0)

dw_ip.SetColumn("empno")
dw_ip.SetFocus()

ib_any_typing = False


//dw_ip.InsertRow(0)
//dw_ip.SetItem(dw_ip.GetRow(),"lendgbn", Is_Gubun)
//
//dw_ip.SetColumn("lendkind")
//dw_ip.SetFocus()
//
//ib_any_typing = False
//

end event

type p_mod from w_inherite_standard`p_mod within w_pis2030
integer x = 3822
integer y = 12
integer taborder = 100
end type

event p_mod::clicked;call super::clicked;string ls_empno, ls_lendgbn, ls_lenddate, ls_paygubun
Decimal ld_janamt, ld_Lendamt, ld_allamt, ld_retamt
Integer li_count

ls_empno = dw_lst.GetItemString(dw_lst.GetRow(), "empno")
ls_lenddate = dw_lst.GetItemString(dw_lst.GetRow(), "lenddate")
ls_lendgbn = dw_lst.GetItemString(dw_lst.GetRow(), "lendgbn")
ld_Lendamt = dw_lst.GetItemDecimal(Dw_lst.GetRow(), "lendamt")

w_mdi_frame.sle_msg.text =""

IF dw_1.GetRow() <=0 THEN Return

IF dw_1.AcceptText() = -1 then return

IF Wf_RequiredChk(dw_1.GetRow()) = -1 THEN Return

IF f_dbconfirm("저장") = 2 THEN RETURN
ls_paygubun = dw_1.GetItemString(dw_1.GetRow(), 'paygubun')

DELETE FROM p5_lendsch
		 WHERE Subgbn = 'N' AND
		 		 empno = :ls_empno AND 
				 lendgbn = :ls_lendgbn AND
				 lendkind = '1' AND
				 lenddate = :ls_lenddate AND
				 paygubun like '%' ;	
	

	SELECT SUM(allretamt), SUM(retamt)
  	  INTO :ld_allamt, :ld_retamt
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
			 
			 
	SELECT count(retdate)
  	  INTO :li_count
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
			 
	IF li_count > 0 THEN
		SELECT MIN(janamt)
		  INTO :ld_janamt
		  FROM p5_lendsch
		 WHERE lendgbn = :ls_LendGbn AND
				 empno = :ls_EmpNo AND 
				 lenddate = :ls_LendDate AND
				 lendkind = '1' AND
				 subgbn = 'Y' AND
				 paygubun like '%';
	ELSE
		SELECT lendamt
		  INTO :ld_janamt
		  FROM p5_lendmst
		 WHERE lendgbn = :ls_LendGbn AND
				 empno = :ls_EmpNo AND 
				 lenddate = :ls_LendDate AND
				 lendkind = '1';
	END IF
	
			

dw_1.SetItem(dw_1.GetRow(), 'janamt', ld_janamt - ld_allamt - ld_retamt)
dw_1.SetItem(dw_1.GetRow(), 'reteja', dw_1.GetItemdecimal(dw_1.GetRow(), 'allreteja'))
IF dw_1.Update() = 1 THEN	
	if Wf_Update_Master() = -1 then
		MessageBox('확 인','상환액 갱신을 실패하였습니다.')
		Rollback;
		Return
	end if
	COMMIT ;
	
//	w_mdi_frame.sle_msg.text = '상환/이자지급계획을 갱신 중...'
//	SetPointer(HourGlass!)
//	if F_Create_LendSch(is_gubun,dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"lendkind"),dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"empno"),dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"lenddate")) = -1 then
//		MessageBox('확 인','상환/이자지급계획 갱신을 실패하였습니다.')
//		Rollback;
//		w_mdi_frame.sle_msg.text =""
//		SetPointer(Arrow!)
//		Return
//	end if
//	Commit;
//	SetPointer(Arrow!)
	
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
//	SELECT MIN(janamt)
//  	  INTO :ld_janamt
//	  FROM p5_lendsch
//	 WHERE lendgbn = :ls_LendGbn AND
//			 empno = :ls_EmpNo AND 
//			 lenddate = :ls_LendDate AND
//			 lendkind = '1' AND
//			 subgbn = 'Y' AND
//			 paygubun like '%';
	SELECT SUM(allretamt)
  	  INTO :ld_allamt
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
		 
	dw_lst.SetItem(dw_lst.GetRow(), 'lendallamt', ld_allamt)
	dw_lst.Update() 
	COMMIT ;	
	
	IF ls_paygubun <> 'E' THEN
		MessageBox('확 인', '상환계획 등록 버튼을 눌러서 상환계획을 재생성 해주십시오.')
	END IF
	
	
ELSE
	MessageBox('확 인','자료 저장을 실패하였습니다.')
	ROLLBACK ;
	ib_any_typing = True
	Return
END IF

//
// SELECT MIN(janamt)
//  INTO :ld_janamt
//  FROM p5_lendsch
// WHERE lendgbn = :ls_LendGbn AND
//		 empno = :ls_EmpNo AND 
//		 lenddate = :ls_LendDate AND
//		 lendkind = '1' AND
//		 subgbn = 'Y' AND
//		 paygubun like '%';
//		 
//dw_lst.SetItem(dw_lst.GetRow(), 'lendallamt', ld_lendamt - ld_janamt)
//			
//
//IF dw_lst.Update() > 0 THEN	
//	COMMIT ;
//	ib_any_typing =False
//	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
////	MessageBox('확 인', '상환계획 등록 버튼을 눌러서 상환계획을 재생성 해주십시오.')
//ELSE
//	ROLLBACK ;
//	ib_any_typing = True
//	w_mdi_frame.sle_msg.text ="저장 실패!!"
//	Return
//END IF


p_addrow.enabled = True
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

IF ls_paygubun <> 'E' THEN
	p_search.enabled = True
	p_search.picturename = "C:\erpman\image\상환계획등록_up.gif"
ELSE
	p_search.enabled = False
	p_search.picturename = "C:\erpman\image\상환계획등록_d.gif"
END IF

p_ins.enabled = True
p_ins.picturename = "C:\erpman\image\추가_up.gif"

ib_any_typing = False
end event

type p_del from w_inherite_standard`p_del within w_pis2030
integer x = 3995
integer y = 12
integer taborder = 120
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long li_janamt, li_lendallamt, li_remain,li_allretamt
String ls_lenddate, ls_empno, ls_lendgbn
Decimal ld_janamt

w_mdi_frame.sle_msg.text =""

IF f_dbconfirm("삭제") = 2 THEN RETURN

li_Lendallamt = dw_lst.GetItemDecimal(dw_lst.GetRow(), "lendallamt")
li_janamt = dw_1.GetItemDecimal(dw_1.GetRow(), "compute_1")
li_remain = dw_lst.GetItemDecimal(dw_lst.GetRow(), "remain")
li_allretamt = dw_1.GetItemDecimal(dw_1.GetRow(),"allretamt")
ls_empno = dw_lst.GetItemString(dw_lst.GetRow(), "empno")
ls_lenddate = dw_lst.GetItemString(dw_lst.GetRow(), "lenddate")
ls_lendgbn = dw_lst.GetItemString(dw_lst.GetRow(), "lendgbn")

dw_1.DeleteRow(0)
	
DELETE FROM p5_lendsch
		 WHERE Subgbn = 'N' AND
		 		 empno = :ls_empno AND 
				 lendgbn = :ls_lendgbn AND
				 lendkind = '1' AND
				 lenddate = :ls_lenddate AND
				 paygubun like '%' ;	
	
IF dw_1.update()= 1 THEN
	if Wf_Update_Master() = -1 then
		MessageBox('확 인','상환액 갱신을 실패하였습니다.')
		Rollback;
		Return
	end if
	COMMIT;
	
//	if F_Create_LendSch(is_gubun,dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"lendkind"),dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"empno"),dw_lst.GetItemString(dw_lst.GetSelectedRow(0),"lenddate")) = -1 then
//		MessageBox('확 인','상환/이자지급계획 갱신을 실패하였습니다.')
//		Rollback;
//		Return
//	end if
//	Commit;
	
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
	MessageBox('확 인', '상환계획 등록 버튼을 눌러서 상환계획을 재생성 해주십시오.')	
	
	dw_lst.SetItem(dw_lst.GetRow(), 'lendallamt', li_lendallamt - li_allretamt)	
	
	dw_lst.update()
	COMMIT;
	
	ib_any_typing = False
ELSE
	MessageBox('확 인','자료 삭제를 실패하였습니다.')
	ROLLBACK;
	Return
END IF	
	
	

// SELECT MIN(janamt)
//  INTO :ld_janamt
//  FROM p5_lendsch
// WHERE lendgbn = :ls_LendGbn AND
//		 empno = :ls_EmpNo AND 
//		 lenddate = :ls_LendDate AND
//		 lendkind = '1' AND
//		 subgbn = 'Y' AND
//		 paygubun like '%';
//		 
//dw_lst.SetItem(dw_lst.GetRow(), 'lendallamt', li_lendallamt - li_allretamt)	
//	
//	
//IF	dw_lst.update() = 1 THEN
//	//dw_lst.SetItem(dw_lst.GetSelectedRow(0), "lendallamt", li_lendallamt - li_janamt)
////	dw_lst.SetItem(dw_lst.GetSelectedRow(0), "remain", li_remain + li_janamt)
//	//dw_lst.SetItem(dw_lst.GetSelectedRow(0), "remain", li_remain + li_lendallamt)
//	
//	IF dw_lst.update()= 1 THEN
//		COMMIT;
//		w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
//		ib_any_typing = False
//	ELSE
//		w_mdi_frame.sle_msg.text ="자료삭제 실패!!!"	
//		ROLLBACK;
//	END IF
//		
//ELSE
//	MessageBox('확 인','자료 삭제를 실패하였습니다.')
//	ROLLBACK;
//	Return
//END IF

p_addrow.enabled = True
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

p_search.enabled = True
p_search.picturename = "C:\erpman\image\상환계획등록_up.gif"

p_ins.enabled = True
p_ins.picturename = "C:\erpman\image\추가_up.gif"

ib_any_typing = False

end event

type p_inq from w_inherite_standard`p_inq within w_pis2030
integer x = 3474
integer y = 12
end type

event p_inq::clicked;string sLendKind,sEmpNo,sRetGbn, ls_Lendgbn, snull
long 	rtnvalue, li_cnt
SetNull(snull)

if dw_ip.accepttext() = -1 then return 
sEmpNo    = dw_ip.getitemstring(dw_ip.getrow(), 'empno')
ls_LendGbn = dw_ip.getitemstring(dw_ip.getrow(), 'lendgbn')
sRetGbn   = dw_ip.getitemstring(dw_ip.getrow(), 'retgbn')

//if sLendKind = '' or isnull(sLendKind) then
//	messagebox("확  인", "대출종류를 입력하세요.")
//	dw_ip.setcolumn('lendkind')
//	dw_ip.SetFocus()
//	return 
//end if
if sEmpNo = '' or IsNull(sEmpNo) then 
	messagebox("확  인", "사번을 입력하세요.")
	dw_ip.setcolumn('empno')
	dw_ip.SetFocus()
	return 
end if

IF ls_LendGbn = '' OR IsNull(ls_LendGbn) THEN ls_LendGbn = '%'

p_ins.enabled = True
p_ins.picturename = "C:\erpman\image\추가_up.gif"

p_del.enabled = True
p_del.picturename = "C:\erpman\image\삭제_up.gif"

ib_any_typing = False

dw_lst.SetRedraw(False)
rtnvalue = dw_lst.retrieve(ls_Lendgbn, sEmpNo )
if rtnvalue <= 0 then//Is_Gubun,sLendKind,sEmpNo) <= 0 then
	messagebox("확  인", "조회된 자료가 없습니다.")
	p_ins.enabled = False
   p_ins.picturename = "C:\erpman\image\추가_d.gif"	
	p_mod.enabled = False
	p_mod.picturename = "C:\erpman\image\저장_d.gif"	
	p_del.enabled = False
	p_del.picturename = "C:\erpman\image\삭제_d.gif"  
	p_search.enabled = False
	p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
	dw_ip.SetItem(1, 'lendgbn', snull)
	dw_1.Reset()
	dw_lst.SetRedraw(True)
	
	dw_ip.setcolumn('empno')
	dw_ip.SetFocus()
	return 
end if


//if rtnvalue <= 0 then//Is_Gubun,sLendKind,sEmpNo) <= 0 then
//	MessageBox("확 인", "생성된 계획이 없습니다.")
//	p_ins.enabled = True
//   p_ins.picturename = "C:\erpman\image\추가_up.gif"	
//	p_mod.enabled = True
//	p_mod.picturename = "C:\erpman\image\저장_up.gif"	
//	p_del.enabled = False
//	p_del.picturename = "C:\erpman\image\삭제_d.gif"  
//	p_search.enabled = False
//	p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
//	dw_ip.SetItem(1, 'lendgbn', snull)
//	dw_1.Reset()
//	dw_lst.SetRedraw(True)
//	
//	dw_ip.setcolumn('empno')
//	dw_ip.SetFocus()
//	return 
//end if


if sRetGbn = 'Y' then
	dw_lst.SetFilter("remain <> 0")
else
	dw_lst.SetFilter("")
end if
dw_lst.Filter()
dw_lst.SetRedraw(True)

dw_lst.SelectRow(0,False)
dw_lst.SelectRow(1,True)

//p_ins.enabled = True
//p_ins.picturename = "C:\erpman\image\추가_up.gif"	
//	
//p_mod.enabled = True
//p_mod.picturename = "C:\erpman\image\저장_up.gif"	
//		
//p_del.enabled = True
//p_del.picturename = "C:\erpman\image\삭제_up.gif"	
//
//p_search.enabled = True
//p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"	
//IF rtnvalue > 0 THEN
//	dw_1.Retrieve(dw_lst.GetItemString(dw_lst.GetRow(), "lendgbn"),dw_lst.GetItemsTring(dw_lst.GetRow(),"empno"),dw_lst.GetItemString(dw_lst.GetRow(),"lenddate")) 
//END IF
//

IF dw_lst.RowCount() > 0 THEN
	if rtnvalue > 0 and dw_lst.GetItemNumber(1,"remain") <> 0 then
		p_ins.enabled = True
		p_ins.picturename = "C:\erpman\image\추가_up.gif"	
		
		p_mod.enabled = True
		p_mod.picturename = "C:\erpman\image\저장_up.gif"	
		
		p_del.enabled = True
		p_del.picturename = "C:\erpman\image\삭제_up.gif"	
		
		p_search.enabled = True
		p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"	
	else
		p_ins.enabled = False
		p_ins.picturename = "C:\erpman\image\추가_d.gif"	
		
		p_mod.enabled = False
		p_mod.picturename = "C:\erpman\image\저장_d.gif"	
		
		p_del.enabled = False
		p_del.picturename = "C:\erpman\image\삭제_d.gif"
		
		p_search.enabled = False
		p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
	end if
	
	dw_1.Retrieve(dw_lst.GetItemString(dw_lst.GetRow(), "lendgbn"),dw_lst.GetItemsTring(dw_lst.GetRow(),"empno"),dw_lst.GetItemString(dw_lst.GetRow(),"lenddate")) 
ELSE
	messagebox("확  인", "조회된 자료가 없습니다.")
	dw_1.Reset()
	
	p_ins.enabled = False
   p_ins.picturename = "C:\erpman\image\추가_d.gif"	
		
		p_mod.enabled = False
		p_mod.picturename = "C:\erpman\image\저장_d.gif"	
		
		p_del.enabled = False
		p_del.picturename = "C:\erpman\image\삭제_d.gif"  
				
		p_search.enabled = False
		p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"

//	MessageBox("확 인", "생성된 계획이 없습니다.")
//	dw_1.Reset()
//	
//	p_ins.enabled = True
//   p_ins.picturename = "C:\erpman\image\추가_up.gif"	
//		
//		p_mod.enabled = True
//		p_mod.picturename = "C:\erpman\image\저장_up.gif"	
//		
//		p_del.enabled = False
//		p_del.picturename = "C:\erpman\image\삭제_d.gif"  
//				
//		p_search.enabled = False
//		p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
END IF

//dw_1.Retrieve(dw_lst.GetItemsTring(1,"empno"), dw_lst.GetItemString(1, 'LendGbn'))



end event

type p_print from w_inherite_standard`p_print within w_pis2030
boolean visible = false
integer x = 4133
integer y = 180
integer taborder = 0
end type

type p_can from w_inherite_standard`p_can within w_pis2030
integer x = 4169
integer y = 12
integer taborder = 140
end type

event p_can::clicked;call super::clicked;
setnull(gs_code); setnull(gs_codename);

dw_ip.SetItem(dw_ip.GetRow(), "empno",   '')
dw_ip.SetItem(dw_ip.GetRow(), "empname", '')
dw_ip.SetItem(dw_ip.GetRow(), "lendgbn", '')

dw_lst.Reset()
dw_1.Reset()

p_addrow.enabled = false
p_addrow.picturename = "C:\erpman\image\이자재계산_d.gif"

p_search.enabled = false
p_search.picturename = "C:\erpman\image\상환계획등록_d.gif"

p_ins.enabled = False
p_ins.picturename = "C:\erpman\image\추가_d.gif"

ib_any_typing = False

end event

type p_exit from w_inherite_standard`p_exit within w_pis2030
integer x = 4343
integer y = 12
integer taborder = 160
end type

event p_exit::clicked;setnull(gs_code); setnull(gs_codename);

w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pis2030
integer x = 3648
integer y = 12
integer taborder = 60
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;String ls_LendGbn, ls_EmpNo, ls_LendDate
Int il_currow,il_functionvalue
Decimal ld_janamt

ls_Lendgbn = dw_lst.GetItemString(dw_lst.GetRow(), 'lendgbn')
ls_empno = dw_lst.GetItemString(dw_lst.GetRow(), 'empno')
ls_LendDate = dw_lst.GetItemString(dw_lst.GetRow(), 'lenddate')

w_mdi_frame.sle_msg.text =""

IF dw_1.RowCount() <=0 THEN
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(dw_1.GetRow())
END IF

IF il_functionvalue = 1 THEN
	
	SELECT MIN(janamt)
	  INTO :ld_janamt
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun LIKE '%';

	IF ld_janamt = 0 THEN
		MessageBox("확 인", "전부 공제된 자료입니다.")
		Return 1
	ELSE	
		il_currow = dw_1.InsertRow(0)
		
		dw_1.setitem(il_currow, 'lendgbn',    dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'lendgbn'))
		//dw_1.setitem(il_currow, 'lendgbn',  Is_Gubun)
		dw_1.setitem(il_currow, 'empno',    dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'empno'))
		dw_1.setitem(il_currow, 'lenddate', dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'lenddate'))
		dw_1.setitem(il_currow, 'lendkind', dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'lendkind'))
		
		dw_1.ScrollToRow(il_currow)
		dw_1.SetColumn("retdate")
		dw_1.SetFocus()	
	END IF
END IF

p_addrow.enabled = false
p_addrow.picturename = "C:\erpman\image\이자재계산_d.gif"

ib_any_typing = True








//Int il_currow,il_functionvalue
//
//w_mdi_frame.sle_msg.text =""
//
//IF dw_1.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredchk(dw_1.GetRow())
//	
//	il_currow = dw_1.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_1.InsertRow(il_currow)
//	
//   dw_1.setitem(il_currow, 'lendgbn',    dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'lendgbn'))
//	//dw_1.setitem(il_currow, 'lendgbn',  Is_Gubun)
//	dw_1.setitem(il_currow, 'empno',    dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'empno'))
//	dw_1.setitem(il_currow, 'lenddate', dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'lenddate'))
//	dw_1.setitem(il_currow, 'lendkind', dw_lst.getitemstring(dw_lst.GetSelectedRow(0), 'lendkind'))
//	
//	dw_1.ScrollToRow(il_currow)
//	dw_1.SetColumn("retdate")
//	dw_1.SetFocus()	
//END IF
//
//p_addrow.enabled = false
//p_addrow.picturename = "C:\erpman\image\이자재계산_d.gif"
//
//ib_any_typing = True
//
//
//
end event

type p_search from w_inherite_standard`p_search within w_pis2030
integer x = 3173
integer y = 12
integer width = 302
integer taborder = 0
boolean enabled = false
string picturename = "C:\erpman\image\상환계획등록_d.gif"
end type

event p_search::clicked;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

	IF dw_lst.AcceptText() = -1 THEN RETURN
	
	IF dw_lst.GetRow() < 1 THEN RETURN
	
	gs_code = dw_lst.GetItemString(dw_lst.GetRow(), 'empno')
	gs_codename = dw_lst.GetItemString(dw_lst.GetRow(), 'lenddate')
	gs_codename2 = dw_lst.GetItemString(dw_lst.GetRow(), 'lendgbn')
	
	OpenSheetWithParm(w_pis2020, '1', w_mdi_frame, 2, layered!)

p_inq.TriggerEvent(Clicked!)

end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\상환계획등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\상환계획등록_up.gif"
end event

type p_addrow from w_inherite_standard`p_addrow within w_pis2030
boolean visible = false
integer x = 3950
integer y = 184
integer taborder = 0
boolean enabled = false
string picturename = "C:\erpman\image\이자재계산_d.gif"
end type

event p_addrow::ue_lbuttonup;PictureName = "C:\erpman\image\이자재계산_up.gif"
end event

event p_addrow::ue_lbuttondown;PictureName = "C:\erpman\image\이자재계산_dn.gif"
end event

event p_addrow::clicked;//Integer   iRowCount, k,iDayCnt
//Double    dLendEja,dLendAmt,dRate,dLendRemain
//String    sCurDate,sBeforeDate,sLendDate
//
//if dw_ip.accepttext() = -1 then return
//sLendDate = dw_ip.getitemstring(dw_ip.getrow(), 'lenddate')
//dLendAmt  = dw_ip.getitemdecimal(dw_ip.getrow(), 'lendamt')
//dRate     = dw_ip.getitemdecimal(dw_ip.getrow(), 'rate')
//if IsNull(dLendAmt) then dLendAmt = 0
//if IsNull(dRate) then dRate = 0
//
//iRowCount = dw_1.RowCount()
//if iRowCount <=0 then Return
//
//for k = 1 to iRowCount
//	if dw_1.GetItemstring(k,"subgbn") = 'Y' then Continue
//	if dw_1.GetItemString(k,"allretdate") <> '' and Not IsNull(dw_1.GetItemString(k,"allretdate")) then Continue
//	
//	sCurDate = dw_1.GetItemString(k,"retdate")
//	if k = 1 then
//		sBeforeDate = sLendDate
//		dLendRemain = dLendAmt
//	else
//		sBeforeDate = Left(dw_1.GetItemString(k - 1,"retdate"),6)+'11'
//		dLendRemain = dw_1.GetItemNumber(k - 1,"janamt")
//		if IsNull(dLendRemain) then dLendRemain = 0
//	end if
//	
//	iDayCnt = DaysAfter(Date(String(sBeforeDate,"@@@@.@@.@@")),date(string(sCurDate,"@@@@.@@.@@"))) + 1
//	
//	dLendEja = Round(truncate((dLendRemain * iDayCnt / 365 * (dRate / 100)),0) / 10,0) * 10
//	dw_1.setitem(k, 'reteja',    dLendEja)
//next
//ib_any_typing = True
//
////if dw_1.update() = 1 then
////	commit;
////else
////	messagebox("확 인", "이자 재계산을 실패하였습니다.")	
////	rollback;
////	return
////end if
//
//w_mdi_frame.sle_msg.text = '이자를 재계산하였습니다.'
//
end event

type p_delrow from w_inherite_standard`p_delrow within w_pis2030
boolean visible = false
integer x = 4320
integer y = 180
integer taborder = 0
end type

type dw_insert from w_inherite_standard`dw_insert within w_pis2030
boolean visible = false
integer taborder = 20
end type

type st_window from w_inherite_standard`st_window within w_pis2030
integer taborder = 150
end type

type cb_exit from w_inherite_standard`cb_exit within w_pis2030
integer taborder = 130
end type

type cb_update from w_inherite_standard`cb_update within w_pis2030
integer taborder = 70
end type

type cb_insert from w_inherite_standard`cb_insert within w_pis2030
integer taborder = 30
end type

type cb_delete from w_inherite_standard`cb_delete within w_pis2030
integer taborder = 80
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pis2030
integer taborder = 110
end type

type st_1 from w_inherite_standard`st_1 within w_pis2030
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pis2030
integer taborder = 90
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pis2030
end type

type sle_msg from w_inherite_standard`sle_msg within w_pis2030
end type

type gb_2 from w_inherite_standard`gb_2 within w_pis2030
end type

type gb_1 from w_inherite_standard`gb_1 within w_pis2030
end type

type gb_10 from w_inherite_standard`gb_10 within w_pis2030
end type

type dw_ip from u_key_enter within w_pis2030
integer x = 101
integer y = 20
integer width = 2542
integer height = 140
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pis2030_1_c"
boolean border = false
end type

event itemchanged;
String  sLendKind,sDept, sEmpNo,sEmpName, sConsMat, sRetGbn,sNull

setnull(snull)

if this.getcolumnname() = 'empno' then
	this.setitem(1, 'lendgbn', snull)
	sEmpNo = this.GetText()
	if sEmpNo = '' or isnull(sEmpNo) then
		this.setitem(1, "empname", 	snull)
		return 
	end if
	
	select nvl(consmatgubn,'Y'), 	empname 		into :sConsMat,				:sEmpName
		from p1_master where companycode = 'KN' and empno = :sEmpNo;
	if sqlca.sqlcode = 0 then
		if sConsMat <> 'Y' then
			messagebox("확  인", "복지회에 가입되지 않은 사원입니다.")
			this.setitem(1, 'empno', snull)
			this.setitem(1, 'empname', snull)
			this.setcolumn('empno')
			return 1
		end if
		this.setitem(1, "empname", 	sEmpName)	
	else
		messagebox("확  인", "등록되지 않은 사원입니다.")
		this.setitem(1, 'empno', snull)
		this.setitem(1, 'empname', snull)
		this.setcolumn('empno')
		return 1
	end if
end if	

if this.GetColumnName() = 'retgbn' then
	sRetGbn = this.GetText()
	
	if sRetGbn = 'Y' then
		dw_lst.SetFilter("remain <> 0")
	else
		dw_lst.SetFilter("")
	end if
	dw_lst.Filter()
end if

end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;if this.getcolumnname() = 'empno' then
	SetNull(Gs_Code);	SetNull(Gs_CodeName);
	
	open(w_employee_popup_pis2030)
	
	IF IsNull(Gs_code) THEN Return
	
	this.SetItem(this.GetRow(),"empno",   Gs_code)
	this.SetItem(this.GetRow(),"empname", Gs_codename)
	this.TriggerEvent(ItemChanged!)
END IF

if this.GetColumnName() = 'lenddate' then
	SetNull(Gs_Code);	SetNull(Gs_CodeName);
	
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	if Gs_Code = '' or IsNull(Gs_Code) then Gs_Code = '%'
	
	OpenWithParm(w_pis2020_popup,'1')
	
	if Gs_Code = '' or IsNull(Gs_Code) then return
	
	this.SetItem(this.GetRow(),"empno",    Gs_Code)
	this.SetItem(this.GetRow(),"empname",  F_Get_EmpName(Gs_Code))
	this.SetItem(this.GetRow(),"lenddate", Gs_CodeName)
	this.TriggerEvent(ItemChanged!)
end if
end event

type dw_1 from u_key_enter within w_pis2030
integer x = 2789
integer y = 180
integer width = 1714
integer height = 2016
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pis2030_2"
boolean vscrollbar = true
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;String sRetDate, sRetDate2, sLendDate, sNull, ls_empno, ls_allret, ls_retdate, ls_paygubun, ls_date, ls_lenddate
string ls_allreteja, ls_janamt, ls_lendgbn
decimal ld_janamt, ld_allret, ld_allreteja, ld_remain , snull2, ld_lendeja, ld_rate, ld_jan, ld_eja
integer li_daycnt, li_count

sRetDate2 = dw_lst.GetItemString(dw_lst.GetRow(), 'retdate')
dw_1.SetItem(dw_1.GetRow(), 'lendgbn', dw_lst.GetItemString(dw_lst.GetRow(), 'lendgbn'))
ls_empno = dw_lst.GetItemString(dw_lst.GetRow(), 'empno')
ls_lendgbn = dw_lst.GetItemString(dw_lst.GetRow(), 'lendgbn')
ls_lenddate = dw_lst.GetItemString(dw_lst.GetRow(), 'lenddate')
ld_remain = dw_lst.GetItemDecimal(dw_lst.Getrow(), 'remain')
ld_rate = dw_lst.GetItemDecimal(dw_lst.Getrow(), 'rate')



SetNull(sNull)
SetNull(snull2)



IF this.GetColumnName() = 'paygubun' THEN
	ls_paygubun = Trim(This.GetText())
	IF ls_paygubun = '' OR IsNull(ls_paygubun) THEN 
		MessageBox("확 인", "상환구분을 입력하세요.")
		SetItem(This.getrow(), 'paygubun',snull)
		SetColumn('paygubun')
		This.SetFocus()
		Return 1
	END IF
	
	IF ls_paygubun <> 'E' THEN
		p_search.enabled = True
		p_search.picturename = "C:\erpman\image\상환계획등록_up.gif"
	ELSE
		p_search.enabled = False
		p_search.picturename = "C:\erpman\image\상환계획등록_d.gif"
	END IF
END IF

if this.GetColumnName() = "retdate" then
	sRetDate = Trim(this.GetText())
	if sRetDate = '' or IsNull(sRetDate) then Return
	
	SELECT count(retdate)	
	  INTO :li_Count	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 paygubun like '%' AND
			 subgbn = 'Y';
	
	
	IF li_count > 0 THEN
		li_DayCnt = DaysAfter(Date(String(F_afterday(sretdate2, 1), "@@@@.@@.@@")),date(string(sretdate,"@@@@.@@.@@"))) + 1
	ELSE
		li_DayCnt = DaysAfter(Date(String(sretdate2, "@@@@.@@.@@")),date(string(sretdate,"@@@@.@@.@@"))) + 1
	END IF
	ld_LendEja = truncate(truncate((ld_Remain * li_DayCnt / 365 * (ld_Rate / 100)),0),0)
	
	IF f_datechk(sRetDate) = -1 THEN 
		MessageBox("확 인", "상환일자를 확인하세요.")
		dw_1.setitem(this.GetRow(), 'retdate', snull)
		Return 1
	END IF	
	
	IF integer(sRetDate) < integer(sRetDate2) THEN
		MessageBox("확 인", "최종상환일자보다 커야합니다.")
		dw_1.SetItem(this.GetRow(), 'retdate', snull)
		Return 1
	END IF
		
	if Wf_Check_RetDate(sRetDate) = -1 then
		dw_1.setitem(this.GetRow(), 'retdate', snull)
		Return 1
	end if
		dw_1.setitem(this.GetRow(), 'allretdate', sRetDate)
	
	ls_paygubun = This.GetItemString(This.GetRow(), 'paygubun')
	IF ls_paygubun = 'E' THEN
		this.SetItem(this.GetRow(), 'allretamt', ld_remain)
		this.SetItem(This.GetRow(), 'allreteja', ld_LendEja)
	END IF
END IF

IF this.GetColumnName() = 'allreteja' THEN
	ls_allreteja = this.GetText()
	
	IF long(ls_allreteja) > ld_remain THEN
		MessageBox("확인", "현잔액보다 작아야 합니다.")
		this.SetItem(this.GetRow(), 'allreteja', snull2)
		Return 1
	END IF
	
	ld_allret = dw_1.GetItemdecimal(dw_1.GetRow(), 'allretamt')
	IF IsNull(ls_allret) OR ls_allret = '' THEN ls_allret = '0'
	
	dw_1.SetItem(dw_1.GetRow(), 'janamt', long(ls_allreteja) + ld_allret) 
	
	IF long(ls_allreteja) + ld_allret > ld_remain THEN
		MessageBox("확인", "현잔액보다 작아야 합니다.")
		this.SetItem(this.GetRow(), 'allretamt', snull2)
		this.SetItem(this.GetRow(), 'allreteja', snull2)
		this.SetColumn('allreteja')
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'allretamt' THEN
	ls_allret = this.GetText()
	
	IF long(ls_allret) > ld_remain THEN
		MessageBox("확인", "현잔액보다 작아야 합니다.")
		this.SetItem(this.GetRow(), 'allretamt', snull2)
		Return 1
	END IF
	
	ld_allreteja = dw_1.GetItemdecimal(dw_1.GetRow(), 'allreteja')
	IF IsNull(ls_allreteja) OR ls_allreteja = '' THEN ls_allreteja = '0'
	
	dw_1.SetItem(dw_1.GetRow(), 'janamt', ld_allreteja + long(ls_allret)) 
		
	IF ld_allreteja + long(ls_allret) > ld_remain THEN
		MessageBox("확인", "현잔액보다 작아야 합니다.")
		this.SetItem(this.GetRow(), 'allretamt', snull2)
		this.SetItem(this.GetRow(), 'allreteja', snull2)
		this.SetColumn('allreteja')
		Return 1
	END IF
END IF

  
//
//li_DayCnt = DaysAfter(Date(String(sretdate2,"@@@@.@@.@@")),date(string(sretdate,"@@@@.@@.@@"))) + 1
//ld_LendEja = truncate(truncate((ld_Remain * li_DayCnt / 365 * (ld_Rate / 100)),0) / 10,0) * 10
//
//IF this.GetColumnName() = 'paygubun' THEN
//	ls_paygubun = Trim(This.GetText())
//	IF ls_paygubun = '' OR IsNull(ls_paygubun) THEN 
//		MessageBox("확 인", "상환구분을 입력하세요.")
//		SetItem(This.getrow(), 'paygubun',snull)
//		SetColumn('paygubun')
//		This.SetFocus()
//		Return 1
//	END IF
//	
//	IF ls_paygubun = 'E' THEN
//		this.SetItem(this.GetRow(), 'allretamt', ld_remain)
//	   this.SetItem(This.GetRow(), 'allreteja', ld_LendEja)
//	END IF
//END IF
//this.SetItem(this.GetRow(), 'reteja', ld_lendeja)
//this.SetItem(this.GetRow(), 'ejaday', li_daycnt)

//IF this.GetColumnName() = 'allretamt' THEN
//	ls_allret = GetText()
//   
//	ld_janamt = dw_lst.GetItemDecimal(dw_lst.GetRow(), 'remain')
//	ld_allreteja = dw_1.GetItemDecimal(dw_1.GetRow(), 'allreteja')
//	
//	ld_janamt = ld_janamt - long(ls_allret) - ld_allreteja
//	
//	dw_1.SetItem(dw_1.GetRow(), 'janamt', ld_janamt)
//
//END IF


//
//SELECT Min(janamt)
//  INTO :ld_janamt
//  FROM p5_lendsch
// WHERE subgbn = 'Y' AND
//       EMPNO = :ls_empno;
//		 
//SELECT retdate
//  INTO :ls_retdate
//  FROM p5_lendsch
// WHERE janamt = :ld_janamt and
// 		 empno = :ls_empno; 
// 
// ld_janamt = ld_janamt - long(ls_allret)
// 
// THIS.SetItem(this.GetRow(), 'janamt', ld_janamt)
// 


end event

type dw_lst from u_d_popup_sort within w_pis2030
integer x = 119
integer y = 180
integer width = 2633
integer height = 2024
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pis2030_1"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;
if row <=0 then Return

SelectRow(0,False)
SelectRow(Row,True)


IF this.GetItemString(row, 'empno') = '' OR IsNull(this.GetItemString(row, 'empno')) THEN 
   p_search.enabled = False
	p_search.PictureName = "C:\Erpman\image\상환계획등록_d.gif"
ELSE
	p_search.enabled = True
	p_search.PictureName = "C:\Erpman\image\상환계획등록_up.gif"
END IF //상환계획등록



//if this.GetItemNumber(row,"remain") <> 0 then
//	p_ins.enabled = True
//	p_ins.picturename = "C:\erpman\image\추가_up.gif"	
//	
//	p_mod.enabled = True
//	p_mod.picturename = "C:\erpman\image\저장_up.gif"	
//	
//	p_del.enabled = True
//	p_del.picturename = "C:\erpman\image\삭제_up.gif"	
//else
//	p_ins.enabled = False
//	p_ins.picturename = "C:\erpman\image\추가_d.gif"	
//	
//	p_mod.enabled = False
//	p_mod.picturename = "C:\erpman\image\저장_d.gif"	
//	
//	p_del.enabled = False
//	p_del.picturename = "C:\erpman\image\삭제_d.gif"	
//end if
dw_ip.SetItem(1, 'lendgbn', this.GetItemString(this.GetClickedRow(), 'lendgbn'))

//dw_1.Retrieve(Is_Gubun,dw_lst.GetItemsTring(row,"empno"),dw_lst.GetItemString(row,"lenddate")) 
dw_1.Retrieve(dw_lst.GetItemString(row, "lendgbn"),dw_lst.GetItemsTring(row,"empno"),dw_lst.GetItemString(row,"lenddate")) 

ib_any_typing = False


end event

type rr_1 from roundrectangle within w_pis2030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2779
integer y = 172
integer width = 1733
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pis2030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 105
integer y = 172
integer width = 2665
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

