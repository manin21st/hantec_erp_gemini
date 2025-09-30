$PBExportHeader$w_pip2111.srw
$PBExportComments$** 계산내역 수정
forward
global type w_pip2111 from w_inherite_standard
end type
type dw_emp from u_key_enter within w_pip2111
end type
type gb_8 from groupbox within w_pip2111
end type
type gb_4 from groupbox within w_pip2111
end type
type rb_1 from radiobutton within w_pip2111
end type
type rb_2 from radiobutton within w_pip2111
end type
type dw_1 from u_key_enter within w_pip2111
end type
type dw_2 from u_key_enter within w_pip2111
end type
type gb_5 from groupbox within w_pip2111
end type
type cb_append from commandbutton within w_pip2111
end type
type cb_erase from commandbutton within w_pip2111
end type
type cb_3 from commandbutton within w_pip2111
end type
type dw_cond from u_key_enter within w_pip2111
end type
type dw_5 from datawindow within w_pip2111
end type
type dw_4 from u_d_popup_sort within w_pip2111
end type
type cb_1 from commandbutton within w_pip2111
end type
type p_erase from uo_picture within w_pip2111
end type
type p_insert from uo_picture within w_pip2111
end type
type p_delete from uo_picture within w_pip2111
end type
type p_append from uo_picture within w_pip2111
end type
type st_2 from statictext within w_pip2111
end type
type st_3 from statictext within w_pip2111
end type
type cb_2 from commandbutton within w_pip2111
end type
type rr_2 from roundrectangle within w_pip2111
end type
type rr_3 from roundrectangle within w_pip2111
end type
type rr_4 from roundrectangle within w_pip2111
end type
type rr_6 from roundrectangle within w_pip2111
end type
type rr_5 from roundrectangle within w_pip2111
end type
type rr_1 from roundrectangle within w_pip2111
end type
type rr_7 from roundrectangle within w_pip2111
end type
end forward

global type w_pip2111 from w_inherite_standard
integer width = 4695
integer height = 2620
string title = "계산내역 수정"
dw_emp dw_emp
gb_8 gb_8
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
dw_2 dw_2
gb_5 gb_5
cb_append cb_append
cb_erase cb_erase
cb_3 cb_3
dw_cond dw_cond
dw_5 dw_5
dw_4 dw_4
cb_1 cb_1
p_erase p_erase
p_insert p_insert
p_delete p_delete
p_append p_append
st_2 st_2
st_3 st_3
cb_2 cb_2
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
rr_6 rr_6
rr_5 rr_5
rr_1 rr_1
rr_7 rr_7
end type
global w_pip2111 w_pip2111

type variables
String iv_workym,iv_pbtag,iv_empno
long ettaxpay, yjtaxpay , gjtaxpay , no_stpay 
end variables

forward prototypes
public function integer wf_required_check (string sdataobj, integer ll_row)
public subroutine wf_calc_editdata ()
public subroutine wf_magamchk ()
end prototypes

public function integer wf_required_check (string sdataobj, integer ll_row);String sempno,scode
Double damount, dpay,dsub

dw_1.Accepttext()
dw_2.Accepttext()
double pamt, samt




IF sdataobj ="d_pip2111_3" and dw_1.rowcount() > 0 THEN							//급여자료 CHILD(지급수당)
	
   pamt = dw_1.GetitemNumber(dw_1.getrow(),'cpay_sum')
	scode   = dw_1.GetItemString(ll_row,"allowcode")
	damount = dw_1.GetItemNumber(ll_row,"allowamt") 
	
	if pamt > 0 then
	
	IF scode ="" OR IsNull(scode) THEN	
		MessageBox("확 인","수당을 입력하세요!!")
		dw_1.SetColumn("allowcode")
		dw_1.SetFocus()
		Return -1
	END IF
	
	IF damount = 0 OR IsNull(damount) THEN
		MessageBox("확 인","금액을 입력하세요!!")
		dw_1.SetColumn("allowamt")
		dw_1.SetFocus()
		Return -1
	END IF
	
    end if
ELSEIF sdataobj ="d_pip2111_4" and dw_2.rowcount() > 0 THEN							//급여자료 CHILD(공제수당)

   samt = dw_2.GetitemNumber(dw_2.getrow(),'csub_sum')

	scode   = dw_2.GetItemString(ll_row,"allowcode")
	damount = dw_2.GetItemNumber(ll_row,"allowamt") 
	
	if samt > 0 then
	IF scode ="" OR IsNull(scode) THEN
		MessageBox("확 인","수당을 입력하세요!!")
		dw_2.SetColumn("allowcode")
		dw_2.SetFocus()
		Return -1
	END IF
	
	IF damount = 0 OR IsNull(damount) THEN
		MessageBox("확 인","금액을 입력하세요!!")
		dw_2.SetColumn("allowamt")
		dw_2.SetFocus()
		Return -1
	END IF
	
   end if

END IF
Return 1
end function

public subroutine wf_calc_editdata ();String sGetSqlSyntax,  staxyn

staxyn = 'N'

//상여 고용보험으로 인한 세금계산 여부 추가 (2021.09.16 정혜원 요청)
//IF iv_pbtag = 'P' then
	if MessageBox("확인", "세금계산을 다시하시겠습니까?", question!, yesno!) = 1	THEN	
		staxyn = 'Y'
	else
		staxyn = 'N' 
	end if
//else
//	staxyn = 'N' 
//end if

sGetSqlSyntax = "select empno,kmgubn from p1_master where empno = '" + iv_empno + "'"

String sReturn = 'OK' ;
DECLARE start_hr_proc_calc_editdataper procedure for hr_recalc_editdata_person(:gs_company,:iv_workym,:iv_empno,:iv_pbtag,:staxyn) ;
execute start_hr_proc_calc_editdataper ; 
FETCH start_hr_proc_calc_editdataper INTO :sReturn;

IF sReturn <> 'OK' then
	rollback;
	MessageBox('확인','자료 갱신 실패!!')
	return
end if
commit;

MessageBox('확인','자료를 저장하였습니다.')


end subroutine

public subroutine wf_magamchk ();String sPayMagamGbn, sSaup

dw_5.AcceptText()
sSaup = dw_5.GetItemString(1,'saup')
IF ISNULL(sSaup) OR sSaup = '' THEN sSaup = '10'

SELECT "P8_PAYFLAG"."CLYN"  		INTO :sPayMagamGbn  
	FROM "P8_PAYFLAG"
   WHERE ( "P8_PAYFLAG"."COMPANYCODE" = :Gs_Company ) AND  
         ( "P8_PAYFLAG"."CLYEARMM" = :Iv_WorkYm) AND
			( "P8_PAYFLAG"."CLGUBN" = :Iv_PbTag ) AND
			( "P8_PAYFLAG"."SAUPCD" = :sSaup );

IF SQLCA.SQLCODE <> 0 THEN
	sPayMagamGbn = 'N'
ELSE
	IF IsNull(sPayMaGamGbn) THEN sPayMagamGbn = 'N'
END IF

IF sPayMagamGbn = 'Y' THEN
	MessageBox("확 인","이미 마감 처리되었습니다. 마감 취소 후 작업하세요!!")

	p_insert.Enabled = False
	p_insert.PictureName = "C:\erpman\image\추가_d.gif"
	p_delete.Enabled = False
	p_delete.PictureName = "C:\erpman\image\삭제_d.gif"
	p_append.Enabled = False
	p_append.PictureName = "C:\erpman\image\추가_d.gif"
	p_erase.Enabled = False
	p_erase.PictureName = "C:\erpman\image\삭제_d.gif"


	p_mod.Enabled = False
	p_append.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.Enabled = False
	p_append.PictureName = "C:\erpman\image\삭제_d.gif"
ELSE

	p_insert.Enabled = True
	p_insert.PictureName = "C:\erpman\image\추가_up.gif"
	p_delete.Enabled = True
	p_delete.PictureName = "C:\erpman\image\삭제_up.gif"
	p_append.Enabled = True
	p_append.PictureName = "C:\erpman\image\추가_up.gif"
	p_erase.Enabled = True
	p_erase.PictureName = "C:\erpman\image\삭제_up.gif"


	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
END IF

if sPayMagamGbn <> 'Y' THEN
	if dw_1.rowcount() > 0 or dw_2.rowcount() > 0  then	

		p_insert.Enabled = True
		p_insert.PictureName = "C:\erpman\image\추가_up.gif"
		p_delete.Enabled = True
		p_delete.PictureName = "C:\erpman\image\삭제_up.gif"
		p_append.Enabled = True
		p_append.PictureName = "C:\erpman\image\추가_up.gif"
		p_erase.Enabled = True
		p_erase.PictureName = "C:\erpman\image\삭제_up.gif"
		

		p_mod.Enabled = True
		p_mod.PictureName = "C:\erpman\image\저장_up.gif"
		p_del.Enabled = True
		p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	ELSE
		w_mdi_frame.sle_msg.text="해당월의 내역이 없습니다!"

		p_insert.Enabled = False
		p_insert.PictureName = "C:\erpman\image\추가_d.gif"
		p_delete.Enabled = False
		p_delete.PictureName = "C:\erpman\image\삭제_d.gif"
		p_append.Enabled = False
		p_append.PictureName = "C:\erpman\image\추가_d.gif"
		p_erase.Enabled = False
		p_erase.PictureName = "C:\erpman\image\삭제_d.gif"
		p_mod.Enabled = False
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		p_del.Enabled = False
		p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	END IF
end if
end subroutine

on w_pip2111.create
int iCurrent
call super::create
this.dw_emp=create dw_emp
this.gb_8=create gb_8
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.gb_5=create gb_5
this.cb_append=create cb_append
this.cb_erase=create cb_erase
this.cb_3=create cb_3
this.dw_cond=create dw_cond
this.dw_5=create dw_5
this.dw_4=create dw_4
this.cb_1=create cb_1
this.p_erase=create p_erase
this.p_insert=create p_insert
this.p_delete=create p_delete
this.p_append=create p_append
this.st_2=create st_2
this.st_3=create st_3
this.cb_2=create cb_2
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_6=create rr_6
this.rr_5=create rr_5
this.rr_1=create rr_1
this.rr_7=create rr_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_emp
this.Control[iCurrent+2]=this.gb_8
this.Control[iCurrent+3]=this.gb_4
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.gb_5
this.Control[iCurrent+9]=this.cb_append
this.Control[iCurrent+10]=this.cb_erase
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.dw_cond
this.Control[iCurrent+13]=this.dw_5
this.Control[iCurrent+14]=this.dw_4
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.p_erase
this.Control[iCurrent+17]=this.p_insert
this.Control[iCurrent+18]=this.p_delete
this.Control[iCurrent+19]=this.p_append
this.Control[iCurrent+20]=this.st_2
this.Control[iCurrent+21]=this.st_3
this.Control[iCurrent+22]=this.cb_2
this.Control[iCurrent+23]=this.rr_2
this.Control[iCurrent+24]=this.rr_3
this.Control[iCurrent+25]=this.rr_4
this.Control[iCurrent+26]=this.rr_6
this.Control[iCurrent+27]=this.rr_5
this.Control[iCurrent+28]=this.rr_1
this.Control[iCurrent+29]=this.rr_7
end on

on w_pip2111.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_emp)
destroy(this.gb_8)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.gb_5)
destroy(this.cb_append)
destroy(this.cb_erase)
destroy(this.cb_3)
destroy(this.dw_cond)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.cb_1)
destroy(this.p_erase)
destroy(this.p_insert)
destroy(this.p_delete)
destroy(this.p_append)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_6)
destroy(this.rr_5)
destroy(this.rr_1)
destroy(this.rr_7)
end on

event open;call super::open;
dw_cond.SetTransObject(SQLCA)
dw_emp.SetTransObject(SQLCA)

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_4.SetTransObject(SQLCA)
dw_5.SetTransObject(SQLCA)
dw_5.insertrow(0)

dw_5.setitem(1,'sdate', f_aftermonth(left(f_today(),6),-1)+'01')
dw_4.retrieve(gs_company, '%','%',f_aftermonth(left(f_today(),6),-1),gs_saupcd,'P')

f_set_saupcd(dw_5, 'saup', '1')
is_saupcd = gs_saupcd

iv_workym = f_aftermonth(left(f_today(),6),-1)
iv_pbtag  = 'P'

dw_cond.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_cond.Reset()
dw_cond.Insertrow(0)

dw_emp.Reset()
dw_emp.Insertrow(0)


dw_1.Reset()
dw_2.Reset()

dw_cond.SetRedraw(True)
dw_emp.SetRedraw(True)

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)


dw_cond.SetItem(1,"workym",f_aftermonth(left(f_today(),6),-1))
dw_cond.SetFocus()
dw_5.SetFocus()

end event

type p_mod from w_inherite_standard`p_mod within w_pip2111
integer x = 3895
end type

event p_mod::clicked;string srtext
Int k

dw_emp.AcceptText()
IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_2.AcceptText() = -1 THEN RETURN

//if f_check_magam(iv_pbtag, iv_workym, is_saupcd) = 'Y' then 
//	MessageBox('확인','이미 마감되었으므로 다시 수정할 수 없습니다')
//	return
//end if

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_1.Update() <> 1 THEN			
	ROLLBACK;
	MessageBox("확 인","급여 지급수당 자료 저장 실패!!")
	Return
END IF

IF dw_2.Update() <> 1 THEN			
	ROLLBACK;
	MessageBox("확 인","급여 공제수당 자료 저장 실패!!")
	Return
END IF
commit;

if dw_1.rowcount() = 0 and dw_2.rowcount() = 0 then
	delete from p3_editdata   where workym = :iv_workym and pbtag = :iv_pbtag and empno = :iv_empno;
else
	wf_Calc_EditData()
end if
COMMIT;

p_inq.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

end event

type p_del from w_inherite_standard`p_del within w_pip2111
integer x = 4069
end type

event p_del::clicked;call super::clicked;Int 	 il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return

il_currow = dw_1.Rowcount()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 급여자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)


dw_1.SetRedraw(False)
il_rowcount = dw_1.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_1.DeleteRow(k)
	NEXT
	IF dw_1.Update() <> 1 THEN
		MessageBox("확 인","급여자료(지급수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_1.SetRedraw(True)
		Return
	END IF
END IF

dw_2.SetRedraw(False)
il_rowcount = dw_2.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_2.DeleteRow(k)
	NEXT
	IF dw_2.Update() <> 1 THEN
		MessageBox("확 인","급여자료(공제수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_2.SetRedraw(True)
		Return
	END IF
END IF

delete from p3_editdata
where workym = :iv_workym and pbtag = :iv_pbtag and empno = :iv_empno;

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

commit;
p_can.TriggerEvent(Clicked!)
ib_any_typing =False
w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
end event

type p_inq from w_inherite_standard`p_inq within w_pip2111
integer x = 3721
end type

event p_inq::clicked;call super::clicked;String sname

dw_cond.AcceptText()
iv_workym = dw_cond.GetItemString(1,"workym")
iv_pbtag  = dw_cond.GetItemString(1,"pbtag")

iv_empno = dw_emp.GetItemString(1,"empno") 

IF iv_workym = "" OR IsNull(iv_workym) THEN
	MessageBox("확 인","작업년월을 입력하세요!!")
	dw_cond.SetColumn("workym")
	dw_cond.SetFocus()
	Return
END IF
IF iv_pbtag = "" OR IsNull(iv_pbtag) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_cond.SetColumn("pbtag")
	dw_cond.SetFocus()
	Return
END IF
IF dw_4.GetSelectedRow(0) > 0 THEN
	iv_empno = dw_4.GetItemString(dw_4.GetSelectedRow(0),"empno")
END IF
IF dw_emp.Retrieve(gs_company,iv_empno,'%',iv_workym,iv_pbtag) <= 0 THEN
	Messagebox("확 인","등록된 사원이 아닙니다!!")
	p_can.TriggerEvent(Clicked!)
	Return 
END IF


//dw_1.SetRedraw(False)
//dw_2.SetRedraw(False)


	dw_1.Retrieve(gs_company,iv_empno,iv_pbtag,'1',iv_workym)
	dw_2.Retrieve(gs_company,iv_empno,iv_pbtag,'2',iv_workym)
	
	double netpayamt
	select sum(decode(gubun,1,allowamt,0)) - sum(decode(gubun,2,allowamt,0))
	into :netpayamt
	from p3_editdatachild
	where empno = :iv_empno and workym = :iv_workym and pbtag = :iv_pbtag ;
	
dw_2.Accepttext()
double pamt, samt

	if dw_2.rowcount() > 0 then
		samt = dw_2.GetitemNumber(dw_2.getrow(),'csub_sum')
		dw_2.setitem(1,'netpayamt',netpayamt)
//		if samt > 0 then
		   dw_2.Modify("allowcode.Visible=1")
         dw_2.Modify("allowamt.Visible=1")
//	   else
//		   dw_2.Modify("allowcode.Visible=0")
//   	   dw_2.Modify("allowamt.Visible=0")
//	   end if
	else
		if netpayamt > 0 then
			dw_2.insertrow(0)
			dw_2.setitem(1,'csub_sum',0)
			dw_2.setitem(1,'netpayamt',netpayamt)			
	 	   dw_2.Modify("allowcode.Visible=0")
   	   dw_2.Modify("allowamt.Visible=0")
	   end if
	end if
	Wf_MagamChk()
		
	w_mdi_frame.sle_msg.text =""

//dw_1.SetRedraw(True)
//dw_2.SetRedraw(True)
end event

type p_print from w_inherite_standard`p_print within w_pip2111
boolean visible = false
integer x = 3813
integer y = 2844
end type

type p_can from w_inherite_standard`p_can within w_pip2111
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_cond.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()


dw_1.Reset()
dw_2.Reset()

p_insert.Enabled =False
p_insert.PictureName = "C:\erpman\image\추가_d.gif"
p_delete.Enabled =False
p_delete.PictureName = "C:\erpman\image\삭제_d.gif"
p_append.Enabled =False
p_append.PictureName = "C:\erpman\image\추가_d.gif"
p_erase.Enabled =False
p_erase.PictureName = "C:\erpman\image\삭제_d.gif"

p_mod.Enabled = True
p_append.PictureName = "C:\erpman\image\저장_up.gif"
p_del.Enabled = True
p_append.PictureName = "C:\erpman\image\삭제_up.gif"

dw_cond.SetRedraw(True)
dw_emp.SetRedraw(True)

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
end event

type p_exit from w_inherite_standard`p_exit within w_pip2111
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pip2111
boolean visible = false
integer x = 4334
integer y = 2844
end type

type p_search from w_inherite_standard`p_search within w_pip2111
boolean visible = false
integer x = 3538
integer y = 20
end type

event p_search::clicked;call super::clicked;string sdate, sdept, sgrade, ssaup, ls_pbtag

if dw_5.Accepttext() = -1 then return
if dw_cond.Accepttext() = -1 then return

sdate = dw_cond.getitemstring(1,'workym')
sdept = dw_5.getitemstring(1,'deptcode')
sgrade = dw_5.getitemstring(1,'grade')
ssaup = dw_5.getitemstring(1,'saup')
ls_pbtag = dw_cond.GetitemString(1,'pbtag')

if IsNull(sdate) or sdate = '' then
	messagebox("확인","조회년월을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'
if IsNull(ssaup) or ssaup = '' then ssaup = '%'

if dw_4.retrieve(gs_company, sdept, sgrade,sdate,ssaup,ls_pbtag) < 1 then
	
	dw_cond.setfocus()
	return	
end if

w_mdi_frame.sle_msg.text = "조회자료가 없습니다!"
end event

type p_addrow from w_inherite_standard`p_addrow within w_pip2111
boolean visible = false
integer x = 3986
integer y = 2844
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip2111
boolean visible = false
integer x = 4160
integer y = 2844
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip2111
boolean visible = false
integer x = 32
integer y = 2336
end type

type st_window from w_inherite_standard`st_window within w_pip2111
boolean visible = false
integer x = 2190
integer y = 2912
integer taborder = 90
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip2111
boolean visible = false
integer x = 4229
integer y = 2372
integer taborder = 180
end type

type cb_update from w_inherite_standard`cb_update within w_pip2111
boolean visible = false
integer x = 3150
integer y = 2512
integer taborder = 100
end type

event cb_update::clicked;call super::clicked;Int k


IF dw_1.AcceptText() = -1 THEN RETURN
IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_1.RowCount() > 0 THEN
	IF wf_required_check(dw_1.DataObject,dw_1.GetRow()) = -1 THEN RETURN
END IF

IF dw_2.RowCount() > 0 THEN
	IF wf_required_check(dw_2.DataObject,dw_2.GetRow()) = -1 THEN RETURN
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN


wf_Calc_EditData()

//dw_1.setredraw(true)
//dw_2.setredraw(true)

double pamt, samt

pamt = dw_1.GetitemNumber(dw_1.getrow(),'cpay_sum')
samt = dw_2.GetitemNumber(dw_2.getrow(),'csub_sum')


if pamt = 0 then
	dw_1.deleterow(1)
end if
IF dw_1.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 지급수당 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

if samt = 0 then
	dw_2.deleterow(1)
end if
IF dw_2.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","급여 공제수당 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

//dw_1.setredraw(false)
//dw_2.setredraw(false)


COMMIT;
cb_retrieve.TriggerEvent(Clicked!)
sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False


		

end event

type cb_insert from w_inherite_standard`cb_insert within w_pip2111
boolean visible = false
integer x = 274
integer y = 2440
integer width = 361
integer taborder = 140
boolean enabled = false
string text = "추가(&I)"
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_1.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_1.DataObject,dw_1.GetRow())
	
	il_currow = dw_1.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_1.InsertRow(il_currow)
	dw_1.SetItem(il_currow,"companycode",gs_company)	
	dw_1.SetItem(il_currow,"workym",iv_workym)
	dw_1.SetItem(il_currow,"empno",iv_empno)
	dw_1.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_1.SetItem(il_currow,"gubun",'1')	

	dw_1.ScrollToRow(il_currow)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
	
END IF

end event

type cb_delete from w_inherite_standard`cb_delete within w_pip2111
boolean visible = false
integer x = 672
integer y = 2440
integer taborder = 150
boolean enabled = false
end type

event cb_delete::clicked;call super::clicked;Int il_currow

il_currow = dw_1.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_1.DeleteRow(il_currow)

//IF dw_1.RowCount() <=0 THEN
//	dw_main.SetItem(1,"etcallowamt",0)
//	dw_main.SetItem(1,"etctaxfree", 0)	
//ELSE
//	dw_main.SetItem(1,"etcallowamt",dw_1.GetItemNumber(1,"ctotal"))
//END IF

IF il_currow = 1 THEN
ELSE
	dw_1.ScrollToRow(il_currow - 1)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
END IF
sle_msg.text ="자료를 삭제하였습니다!!"

ib_any_typing =True

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip2111
boolean visible = false
integer x = 2802
integer y = 2512
integer taborder = 80
end type

event cb_retrieve::clicked;call super::clicked;String sname

dw_cond.AcceptText()
iv_workym = dw_cond.GetItemString(1,"workym")
iv_pbtag  = dw_cond.GetItemString(1,"pbtag")

iv_empno = dw_emp.GetItemString(1,"empno") 

IF iv_workym = "" OR IsNull(iv_workym) THEN
	MessageBox("확 인","작업년월을 입력하세요!!")
	dw_cond.SetColumn("workym")
	dw_cond.SetFocus()
	Return
END IF
IF iv_pbtag = "" OR IsNull(iv_pbtag) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_cond.SetColumn("pbtag")
	dw_cond.SetFocus()
	Return
END IF
IF dw_4.GetSelectedRow(0) > 0 THEN
	iv_empno = dw_4.GetItemString(dw_4.GetSelectedRow(0),"empno")
END IF
IF dw_emp.Retrieve(gs_company,iv_empno,'%',iv_workym,iv_pbtag) <= 0 THEN
	Messagebox("확 인","등록된 사원이 아닙니다!!")
	cb_cancel.TriggerEvent(Clicked!)
	Return 
END IF


//dw_1.SetRedraw(False)
dw_2.SetRedraw(False)


	dw_1.Retrieve(gs_company,iv_empno,iv_pbtag,'1',iv_workym)
	dw_2.Retrieve(gs_company,iv_empno,iv_pbtag,'2',iv_workym)
	
	double netpayamt
	select sum(decode(gubun,1,allowamt,0)) - sum(decode(gubun,2,allowamt,0))
	into :netpayamt
	from p3_editdatachild
	where empno = :iv_empno and workym = :iv_workym and pbtag = :iv_pbtag ;
	
dw_2.Accepttext()
double pamt, samt


  
	if dw_2.rowcount() > 0 then
		samt = dw_2.GetitemNumber(dw_2.getrow(),'csub_sum')
		dw_2.setitem(1,'netpayamt',netpayamt)
		if samt > 0 then
		   dw_2.Modify("allowcode.Visible=1")
         dw_2.Modify("allowamt.Visible=1")
	   else
		   dw_2.Modify("allowcode.Visible=0")
   	   dw_2.Modify("allowamt.Visible=0")
	   end if
	else
		if netpayamt > 0 then
			dw_2.insertrow(0)
			dw_2.setitem(1,'csub_sum',0)
			dw_2.setitem(1,'netpayamt',netpayamt)			
	 	   dw_2.Modify("allowcode.Visible=0")
   	   dw_2.Modify("allowamt.Visible=0")
	   end if
	end if
	Wf_MagamChk()
		
	sle_msg.text =""



//dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
end event

type st_1 from w_inherite_standard`st_1 within w_pip2111
boolean visible = false
integer x = 23
integer y = 2912
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip2111
boolean visible = false
integer x = 3877
integer y = 2512
integer taborder = 130
end type

event cb_cancel::clicked;call super::clicked;dw_cond.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_1.SetRedraw(False)
dw_2.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()


dw_1.Reset()
dw_2.Reset()

cb_insert.Enabled =False
cb_delete.Enabled =False
cb_append.Enabled =False
cb_erase.Enabled =False

cb_update.Enabled = True
cb_3.Enabled      = True
	
dw_cond.SetRedraw(True)
dw_emp.SetRedraw(True)

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pip2111
boolean visible = false
integer x = 2834
integer y = 2912
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip2111
boolean visible = false
integer x = 352
integer y = 2912
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip2111
boolean visible = false
integer x = 919
integer y = 2680
integer width = 1838
integer height = 176
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip2111
boolean visible = false
integer x = 2789
integer y = 2680
integer width = 805
integer height = 176
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip2111
boolean visible = false
integer x = 5
integer y = 2884
end type

type dw_emp from u_key_enter within w_pip2111
event ue_key pbm_dwnkey
integer x = 1696
integer y = 288
integer width = 2825
integer height = 248
integer taborder = 20
string dataobject = "d_pip2111_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sname, sempname, ls_name

dw_emp.Accepttext()
dw_cond.AcceptText()
iv_workym = dw_cond.GetItemString(1,"workym")
iv_pbtag  = dw_cond.GetItemString(1,"pbtag")
iv_empno = dw_emp.GetItemString(1,"empno") 

IF iv_workym = "" OR IsNull(iv_workym) THEN
	MessageBox("확 인","작업년월을 입력하세요!!")
	dw_cond.SetColumn("workym")
	dw_cond.SetFocus()
	Return
END IF
IF iv_pbtag = "" OR IsNull(iv_pbtag) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_cond.SetColumn("pbtag")
	dw_cond.SetFocus()
	Return
END IF



If dw_emp.GetColumnName() = "empno" Then
	iv_empno = this.GetText()
	
	IF iv_empno ="" OR IsNull(iv_empno) THEN RETURN
	    
	IF IsNull(wf_exiting_saup_data("empno",iv_empno,"1",is_saupcd)) THEN
		Messagebox("확 인","등록되지 않은 사원이거나 사업장이 틀립니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		
		Return 1
	END IF

ELSEIF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 iv_empno = ls_name
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)

ELSEIF dw_4.GetSelectedRow(0) > 0 THEN
	iv_empno = dw_4.GetItemString(dw_4.GetSelectedRow(0),"empno")
END IF



IF dw_emp.Retrieve(gs_company,iv_empno,'%',iv_workym,iv_pbtag) <= 0 THEN
	Messagebox("확 인","등록된 사원이 아닙니다!!")
	p_can.TriggerEvent(Clicked!)
	Return 
END IF


//dw_1.SetRedraw(False)
//dw_2.SetRedraw(False)


	dw_1.Retrieve(gs_company,iv_empno,iv_pbtag,'1',iv_workym)
	dw_2.Retrieve(gs_company,iv_empno,iv_pbtag,'2',iv_workym)
	
	double netpayamt
	select sum(decode(gubun,1,allowamt,0)) - sum(decode(gubun,2,allowamt,0))
	into :netpayamt
	from p3_editdatachild
	where empno = :iv_empno and workym = :iv_workym and pbtag = :iv_pbtag ;
	
	if dw_2.rowcount() > 0 then
		dw_2.setitem(1,'netpayamt',netpayamt)
	else
		if netpayamt > 0 then
			dw_2.insertrow(0)
			dw_2.setitem(1,'csub_sum',0)
			dw_2.setitem(1,'netpayamt',netpayamt)		
	   end if
	end if
	Wf_MagamChk()
		
	w_mdi_frame.sle_msg.text =""



//dw_1.SetRedraw(True)
//dw_2.SetRedraw(True)
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

this.AcceptText()
IF this.GetColumnName() = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	Gs_gubun = is_saupcd
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	Gs_gubun = is_saupcd
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;call super::itemerror;return 1
end event

type gb_8 from groupbox within w_pip2111
boolean visible = false
integer x = 242
integer y = 2392
integer width = 805
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_4 from groupbox within w_pip2111
boolean visible = false
integer x = 1929
integer y = 2620
integer width = 759
integer height = 172
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "정렬"
end type

type rb_1 from radiobutton within w_pip2111
boolean visible = false
integer x = 2034
integer y = 2684
integer width = 238
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
string text = "사번"
boolean checked = true
end type

type rb_2 from radiobutton within w_pip2111
boolean visible = false
integer x = 2345
integer y = 2684
integer width = 238
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
string text = "성명"
end type

type dw_1 from u_key_enter within w_pip2111
integer x = 1815
integer y = 840
integer width = 951
integer height = 1348
integer taborder = 60
string dataobject = "d_pip2111_3"
boolean vscrollbar = true
boolean border = false
end type

event editchanged;ib_any_typing =True

this.AcceptText()


end event

event retrievestart;call super::retrievestart;
DataWindowChild dw_child
Int il_rtn

il_rtn = dw_1.GetChild("allowcode",dw_child)
IF il_rtn = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('1') <=0 THEN 
		Messagebox("확 인","등록된 수당이 없습니다!!")
		Return 1
	END IF
END IF
end event

event itemchanged;String sname,snull,sTaxGbn,sNoTaxGbn,sStandPayGbn,sreference, stpaygbn
Int il_currow,lReturnRow, sprint

SetNull(snull)

IF dwo.name ="allowcode" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
		lReturnRow = This.Find("allowcode = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 수당입니다.~r등록할 수 없습니다.")
			this.SetItem(row,"allowcode",snull)
			this.SetItem(row,"p3_allowance_backpaytag",snull)
			this.SetItem(row,"p3_allowance_daycalctag",snull)
			this.SetItem(row,"p3_allowance_taxpaytag", snull)
			RETURN  1	
		END IF

     SELECT "P3_ALLOWANCE"."ALLOWNAME",  "P3_ALLOWANCE"."BACKPAYTAG",
	  			"P3_ALLOWANCE"."DAYCALCTAG", "P3_ALLOWANCE"."TAXPAYTAG",
				"P3_ALLOWANCE"."REFERENCETABLE",	"P3_ALLOWANCE"."STPAYTAG",
				"P3_ALLOWANCE"."PRINTSEQ"
   	 INTO :sname,							  :sTaxGbn,
		 		:sNoTaxGbn,						  :sStandPayGbn,
				:sreference,                 :stpaygbn,
				:sprint
	    FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = '1' AND "P3_ALLOWANCE"."ALLOWCODE" =:data  ;
	IF SQLCA.SQLCODE <> 0 THEN
		w_mdi_frame.sle_msg.text ="수당을 등록하시려면 '급여기준정보'메뉴로 이동하십시요!!"
		Messagebox("확 인","등록된 수당이 아닙니다!!")
		this.SetItem(row,"allowcode",snull)
		this.SetItem(row,"p3_allowance_backpaytag",snull)
		this.SetItem(row,"p3_allowance_daycalctag",snull)
		this.SetItem(row,"p3_allowance_taxpaytag", snull)
		Return 1
	ELSE
		this.SetItem(row,"p3_allowance_backpaytag",sTaxGbn)
		this.SetItem(row,"p3_allowance_daycalctag",sNoTaxGbn)
		this.SetItem(row,"p3_allowance_taxpaytag", sStandPayGbn)
		this.Setitem(row,"p3_editdatachild_notaxkind", sTaxGbn)   /*비과세종류*/
		this.Setitem(row,"p3_editdatachild_notaxgubun", sNoTaxGbn)     /*과세,비과세구분*/
		this.Setitem(row,"p3_editdatachild_mstgubun", sStandPayGbn)    /*월정급여구분*/
		this.Setitem(row,"p3_editdatachild_fixgubun", sreference)      /*고정지급구분*/
		this.Setitem(row,"p3_editdatachild_tongubun", stpaygbn)        /*통상급구분*/  
		this.Setitem(row,"p3_editdatachild_printseq", sprint)        /*출력순서*/  
		
	END IF
END IF

dw_1.Accepttext()
dw_2.Accepttext()

double pamt, samt

pamt = dw_1.GetitemNumber(1,'cpay_sum')
samt = dw_2.GetitemNumber(1,'csub_sum')

dw_2.setitem(1,'netpayamt',pamt - samt)
end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

type dw_2 from u_key_enter within w_pip2111
integer x = 3003
integer y = 840
integer width = 969
integer height = 1352
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_pip2111_4"
boolean vscrollbar = true
boolean border = false
end type

event editchanged;ib_any_typing =True

this.AcceptText()


end event

event retrievestart;call super::retrievestart;
DataWindowChild dw_child
Int il_rtn

il_rtn = dw_2.GetChild("allowcode",dw_child)
IF il_rtn = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('2') <=0 THEN 
		Messagebox("확 인","등록된 수당이 없습니다!!")
		Return 1
	END IF
END IF
end event

event itemchanged;String sname,snull,sTaxGbn,sNoTaxGbn,sStandPayGbn,sreference, stpaygbn, &
		 scode, sgubun
Int il_currow,lReturnRow, sprint, i,cnt
long ll_allowmat

SetNull(snull)

IF dwo.name ="allowcode" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
		lReturnRow = This.Find("allowcode = '"+data+"' ", 1, This.RowCount())
		
		IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
			MessageBox("확인","등록된 수당입니다.~r등록할 수 없습니다.")
			this.SetItem(row,"allowcode",snull)
			this.SetItem(row,"p3_allowance_backpaytag",snull)
			this.SetItem(row,"p3_allowance_daycalctag",snull)
			this.SetItem(row,"p3_allowance_taxpaytag", snull)
			RETURN  1	
		END IF

     SELECT "P3_ALLOWANCE"."ALLOWNAME",  "P3_ALLOWANCE"."BACKPAYTAG",
	  			"P3_ALLOWANCE"."DAYCALCTAG", "P3_ALLOWANCE"."TAXPAYTAG",
				"P3_ALLOWANCE"."REFERENCETABLE",	"P3_ALLOWANCE"."STPAYTAG",
				"P3_ALLOWANCE"."PRINTSEQ"
   	 INTO :sname,							  :sTaxGbn,
		 		:sNoTaxGbn,						  :sStandPayGbn,
				:sreference,                 :stpaygbn,
				:sprint
	    FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = '2' AND "P3_ALLOWANCE"."ALLOWCODE" =:data  ;
	IF SQLCA.SQLCODE <> 0 THEN
		w_mdi_frame.sle_msg.text ="수당을 등록하시려면 '급여기준정보'메뉴로 이동하십시요!!"
		Messagebox("확 인","등록된 수당이 아닙니다!!")
		this.SetItem(row,"allowcode",snull)
		this.SetItem(row,"p3_allowance_backpaytag",snull)
		this.SetItem(row,"p3_allowance_daycalctag",snull)
		this.SetItem(row,"p3_allowance_taxpaytag", snull)
		Return 1
	ELSE
		this.SetItem(row,"p3_allowance_backpaytag",sTaxGbn)
		this.SetItem(row,"p3_allowance_daycalctag",sNoTaxGbn)
		this.SetItem(row,"p3_allowance_taxpaytag", sStandPayGbn)
		this.Setitem(row,"P3_allowance_backpaytag", sTaxGbn)   /*비과세종류*/
		this.Setitem(row,"p3_editdatachild_notaxkind", sTaxGbn)   /*비과세종류*/
		this.Setitem(row,"p3_editdatachild_notaxgubun", sNoTaxGbn)     /*과세,비과세구분*/
		this.Setitem(row,"p3_editdatachild_mstgubun", sStandPayGbn)    /*월정급여구분*/
		this.Setitem(row,"p3_editdatachild_fixgubun", sreference)      /*고정지급구분*/
		this.Setitem(row,"p3_editdatachild_tongubun", stpaygbn)        /*통상급구분*/  
		this.Setitem(row,"p3_editdatachild_printseq", sprint)        /*출력순서*/  
		
	END IF
END IF

IF dwo.name ="allowamt" THEN /*소득세 수정시 주민세 자동 반영*/
   this.Accepttext()
	scode  = GetItemString(row, 'allowcode')
	ll_allowmat = GetItemNumber(row, 'allowamt')	
	sgubun = GetItemString(row, 'gubun')
   cnt = 0
	IF scode = '01' and sgubun = '2' THEN
		il_currow = RowCount()
		FOR i = 1 to il_currow
			scode  = GetItemString(i, 'allowcode')
			sgubun = GetItemString(i, 'gubun')
			IF scode = '02' and sgubun = '2' THEN
				cnt = 1
				this.SetItem(i, 'allowamt', truncate(truncate(ll_allowmat / 10, 0) / 10,0) * 10 )				
			END IF
		NEXT
		if cnt = 0 then
			this.insertrow(il_currow + 1)
			
			  SELECT "P3_ALLOWANCE"."ALLOWNAME",  "P3_ALLOWANCE"."BACKPAYTAG",
	  			"P3_ALLOWANCE"."DAYCALCTAG", "P3_ALLOWANCE"."TAXPAYTAG",
				"P3_ALLOWANCE"."REFERENCETABLE",	"P3_ALLOWANCE"."STPAYTAG",
				"P3_ALLOWANCE"."PRINTSEQ"
   	 INTO :sname,							  :sTaxGbn,
		 		:sNoTaxGbn,						  :sStandPayGbn,
				:sreference,                 :stpaygbn,
				:sprint
	    FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = '2' AND "P3_ALLOWANCE"."ALLOWCODE" = '02'  ;
			this.Setitem(il_currow + 1, 'allowcode','02')
			this.SetItem(il_currow + 1,"companycode",gs_company)
			this.SetItem(il_currow + 1,"workym",iv_workym)
			this.SetItem(il_currow + 1,"pbtag",iv_pbtag)
			this.SetItem(il_currow + 1,"empno",iv_empno)
			this.SetItem(il_currow + 1,"gubun",'2')			
			this.SetItem(il_currow + 1,"p3_allowance_backpaytag",sTaxGbn)
			this.SetItem(il_currow + 1,"p3_allowance_daycalctag",sNoTaxGbn)
			this.SetItem(il_currow + 1,"p3_allowance_taxpaytag", sStandPayGbn)
			this.Setitem(il_currow + 1,"P3_allowance_backpaytag", sTaxGbn)      /*비과세종류*/
			this.Setitem(il_currow + 1,"p3_editdatachild_notaxkind", sTaxGbn)   /*비과세종류*/
			this.Setitem(il_currow + 1,"p3_editdatachild_notaxgubun", sNoTaxGbn)     /*과세,비과세구분*/
			this.Setitem(il_currow + 1,"p3_editdatachild_mstgubun", sStandPayGbn)    /*월정급여구분*/
			this.Setitem(il_currow + 1,"p3_editdatachild_fixgubun", sreference)      /*고정지급구분*/
			this.Setitem(il_currow + 1,"p3_editdatachild_tongubun", stpaygbn)        /*통상급구분*/  
			this.Setitem(il_currow + 1,"p3_editdatachild_printseq", sprint)        /*출력순서*/  
			this.SetItem(il_currow + 1, 'allowamt', truncate(truncate(ll_allowmat / 10, 0) / 10,0) * 10 )				
			
		end if
	END IF
END IF

dw_1.Accepttext()
dw_2.Accepttext()

double pamt, samt

pamt = dw_1.GetitemNumber(1,'cpay_sum')
samt = dw_2.GetitemNumber(1,'csub_sum')

dw_2.setitem(1,'netpayamt', pamt - samt)
end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

type gb_5 from groupbox within w_pip2111
boolean visible = false
integer x = 1929
integer y = 2804
integer width = 759
integer height = 204
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
string text = "자료선택"
end type

type cb_append from commandbutton within w_pip2111
boolean visible = false
integer x = 2729
integer y = 2384
integer width = 334
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
string text = "추가(&A)"
end type

event clicked;Int il_currow,il_functionvalue, abc
string setting
long samt

dw_2.Accepttext()
samt = dw_2.GetitemNumber(1,'csub_sum')
abc = dw_2.rowcount()

IF dw_2.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue = 1
ELSE
	
   if samt = 0 and dw_2.rowcount() >= 0 then
      dw_2.Modify("allowcode.Visible=1")
	   dw_2.Modify("allowamt.Visible=1")
		dw_2.SetItem(1,"companycode",gs_company)	
		dw_2.SetItem(1,"workym",iv_workym)	
		dw_2.SetItem(1,"empno",iv_empno)
		dw_2.SetItem(1,"pbtag",iv_pbtag)	
		dw_2.SetItem(1,"gubun",'2')			
	else
		il_functionvalue = wf_required_check(dw_2.DataObject,dw_2.GetRow())
	
	end if	
	il_currow = dw_2.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_2.InsertRow(il_currow)
	dw_2.SetItem(il_currow,"companycode",gs_company)	
	dw_2.SetItem(il_currow,"workym",iv_workym)	
	dw_2.SetItem(il_currow,"empno",iv_empno)
	dw_2.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_2.SetItem(il_currow,"gubun",'2')		
	dw_2.ScrollToRow(il_currow)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()	
END IF
	

	

end event

type cb_erase from commandbutton within w_pip2111
boolean visible = false
integer x = 3095
integer y = 2384
integer width = 334
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제(&E)"
end type

event clicked;Int il_currow

il_currow = dw_2.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_2.DeleteRow(il_currow)
//IF dw_2.RowCount() <=0 THEN
//	dw_main.SetItem(1,"etcsubamt",0)
//ELSE
//	dw_main.SetItem(1,"etcsubamt",dw_2.GetItemNumber(1,"ctotal"))
//END IF

IF il_currow = 1 THEN
ELSE
	dw_2.ScrollToRow(il_currow - 1)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()
END IF

dw_1.Accepttext()
dw_2.Accepttext()
double pamt, samt

pamt = dw_1.GetitemNumber(1,'cpay_sum')
if dw_2.rowcount() > 0 then
  samt = dw_2.GetitemNumber(1,'csub_sum')
else
  samt = 0
end if

if dw_2.rowcount() = 0 then
	if pamt > 0 then
		dw_2.insertrow(0)
		dw_2.setitem(1,'csub_sum',0)
		dw_2.setitem(1,'netpayamt',pamt)			
	end if	
else
	dw_2.setitem(1,'netpayamt',pamt - samt)			   
end if
if samt > 0 then
	dw_2.Modify("allowcode.Visible=1")
	dw_2.Modify("allowamt.Visible=1")
else
	dw_2.Modify("allowcode.Visible=0")
	dw_2.Modify("allowamt.Visible=0")
end if

sle_msg.text ="자료를 삭제! 완전히 삭제하기 위해선 저장하셔야 합니다!!"

ib_any_typing =True

end event

type cb_3 from commandbutton within w_pip2111
boolean visible = false
integer x = 3502
integer y = 2512
integer width = 361
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&Z)"
end type

event clicked;Int il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return


IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 급여자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)


dw_1.SetRedraw(False)
il_rowcount = dw_1.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_1.DeleteRow(k)
	NEXT
	IF dw_1.Update() <> 1 THEN
		MessageBox("확 인","급여자료(지급수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_1.SetRedraw(True)
		Return
	END IF
END IF

dw_2.SetRedraw(False)
il_rowcount = dw_2.RowCount()

IF il_rowcount > 0 THEN
	FOR k = il_rowcount TO 1 STEP -1
		dw_2.DeleteRow(k)
	NEXT
	IF dw_2.Update() <> 1 THEN
		MessageBox("확 인","급여자료(공제수당) 삭제 실패!!")
		rollback;
		ib_any_typing =True
		dw_2.SetRedraw(True)
		Return
	END IF
END IF

dw_1.SetRedraw(True)
dw_2.SetRedraw(True)

commit;
cb_cancel.TriggerEvent(Clicked!)
ib_any_typing =False
sle_msg.text ="자료를 삭제하였습니다!!"
	





end event

type dw_cond from u_key_enter within w_pip2111
integer x = 1696
integer y = 212
integer width = 1842
integer height = 92
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip2111_5"
boolean border = false
end type

event itemerror;
Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String snull

IF this.GetColumnName() = 'workym' or this.GetColumnName() = 'pbtag' THEN
	iv_workym = GetItemString(1,'workym')
	IF iv_workym = "" OR IsNull(iv_workym) THEN RETURN
	
	IF f_datechk(iv_workym+'01') = -1 THEN
		MessageBox("확 인","작업년월을 확인하세요!!")
		this.SetItem(1,"workym",snull)
		Return 1
	END IF
	dw_5.Setitem(1,'sdate', iv_workym+'01')
	dw_5.Triggerevent(itemchanged!)
END IF
end event

type dw_5 from datawindow within w_pip2111
event ue_enter pbm_dwnprocessenter
integer x = 466
integer y = 196
integer width = 1179
integer height = 344
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip2111_7"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string sdate, sdept, sgrade, snull, sdeptnm
setnull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

if this.GetColumnName() = 'sdate' then
	sdate = this.gettext()
	if f_datechk(sdate) = -1 then
		messagebox("확인","일자를 확인하십시요!")
		dw_5.setitem(1,'sdate',snull)
		dw_5.setcolumn('sdate')
		dw_5.setfocus()		
		return
	end if
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'deptcode' then
	    sdept = this.Gettext()
	select deptname into :sdeptnm
	from p0_dept
	where deptcode = :sdept;
	
	 IF f_chk_saupemp(sdept, '2', is_saupcd) = False THEN
		  this.SetItem(1,'deptcode',snull)
		  this.SetColumn('deptcode')
		  this.SetFocus()
		  Return 1
	  END IF
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'deptname', sdeptnm)
	else
		messagebox("확인","없는 코드입니다")
		this.setitem(1,'deptcode',snull)
		this.setitem(1,'deptname',snull)
		return 1
	end if
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'grade' then
	p_search.Triggerevent(Clicked!)
elseif this.GetColumnName() = 'saup' then
	is_saupcd = this.Gettext()
	p_search.Triggerevent(Clicked!)
	
end if
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_Gubun)


IF GetColumnName() = "deptcode" THEN
	
	Gs_Gubun = is_saupcd
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	p_search.Triggerevent(Clicked!)
	
END IF


end event

type dw_4 from u_d_popup_sort within w_pip2111
integer x = 517
integer y = 636
integer width = 1106
integer height = 1544
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip2111_6"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;If Row <= 0 then
	dw_4.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

type cb_1 from commandbutton within w_pip2111
boolean visible = false
integer x = 933
integer y = 2636
integer width = 402
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "retrieve"
end type

event clicked;string sdate, sdept, sgrade

if dw_5.Accepttext() = -1 then return

sdate = dw_5.getitemstring(1,'sdate')
sdept = dw_5.getitemstring(1,'sdept')
sgrade = dw_5.getitemstring(1,'grade')

if IsNull(sdate) or sdate = '' then
	messagebox("확인","퇴직일자기준을 확인하세요!")
	return
end if

if IsNull(sdept) or sdept = '' then sdept = '%'
if IsNull(sgrade) or sgrade = '' then sgrade = '%'

if dw_4.retrieve(gs_company, sdept, sgrade,sdate) < 1 then
	messagebox("조회","조회자료가 없습니다!")
	return
	dw_5.setcolumn('sdate')
	dw_5.setfocus()
end if
end event

type p_erase from uo_picture within w_pip2111
integer x = 3899
integer y = 620
integer width = 178
integer taborder = 60
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;Int il_currow

il_currow = dw_2.GetRow()
IF il_currow <=0 Then Return

//IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_2.DeleteRow(il_currow)
//IF dw_2.RowCount() <=0 THEN
//	dw_main.SetItem(1,"etcsubamt",0)
//ELSE
//	dw_main.SetItem(1,"etcsubamt",dw_2.GetItemNumber(1,"ctotal"))
//END IF

IF il_currow = 1 THEN
ELSE
	dw_2.ScrollToRow(il_currow - 1)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()
END IF

dw_1.Accepttext()
dw_2.Accepttext()
double pamt, samt

pamt = dw_1.GetitemNumber(1,'cpay_sum')
if dw_2.rowcount() > 0 then
  samt = dw_2.GetitemNumber(1,'csub_sum')
else
  samt = 0
end if

if dw_2.rowcount() = 0 then
	if pamt > 0 then
		dw_2.insertrow(0)
		dw_2.setitem(1,'csub_sum',0)
		dw_2.setitem(1,'netpayamt',pamt)			
	end if	
else
	dw_2.setitem(1,'netpayamt',pamt - samt)			   
end if
if samt > 0 then
	dw_2.Modify("allowcode.Visible=1")
	dw_2.Modify("allowamt.Visible=1")
else
	dw_2.Modify("allowcode.Visible=0")
	dw_2.Modify("allowamt.Visible=0")
end if

w_mdi_frame.sle_msg.text ="자료를 삭제! 완전히 삭제하기 위해선 저장하셔야 합니다!!"

ib_any_typing =True

end event

type p_insert from uo_picture within w_pip2111
integer x = 2501
integer y = 620
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
boolean enabled = false
string picturename = "C:\erpman\Image\추가_d.gif"
end type

event clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_1.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_1.DataObject,dw_1.GetRow())
	
	il_currow = dw_1.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_1.InsertRow(il_currow)
	dw_1.SetItem(il_currow,"companycode",gs_company)	
	dw_1.SetItem(il_currow,"workym",iv_workym)
	dw_1.SetItem(il_currow,"empno",iv_empno)
	dw_1.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_1.SetItem(il_currow,"gubun",'1')	

	dw_1.ScrollToRow(il_currow)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
	
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_delete from uo_picture within w_pip2111
integer x = 2674
integer y = 620
integer width = 178
integer taborder = 60
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event clicked;call super::clicked;Int il_currow

il_currow = dw_1.GetRow()
IF il_currow <=0 Then Return

//IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_1.DeleteRow(il_currow)

//IF dw_1.RowCount() <=0 THEN
//	dw_main.SetItem(1,"etcallowamt",0)
//	dw_main.SetItem(1,"etctaxfree", 0)	
//ELSE
//	dw_main.SetItem(1,"etcallowamt",dw_1.GetItemNumber(1,"ctotal"))
//END IF

IF il_currow = 1 THEN
ELSE
	dw_1.ScrollToRow(il_currow - 1)
	dw_1.SetColumn("allowcode")
	dw_1.SetFocus()
END IF
w_mdi_frame.sle_msg.text ="자료를 삭제! 완전히 삭제하기 위해선 저장하셔야 합니다!!"

ib_any_typing =True

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_append from uo_picture within w_pip2111
integer x = 3726
integer y = 620
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\add.cur"
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event clicked;call super::clicked;Int il_currow,il_functionvalue, abc
string setting
long samt

dw_2.Accepttext()
samt = dw_2.GetitemNumber(1,'csub_sum')
abc = dw_2.rowcount()

IF dw_2.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue = 1
ELSE
	
   if samt = 0 and dw_2.rowcount() >= 0 then
      dw_2.Modify("allowcode.Visible=1")
	   dw_2.Modify("allowamt.Visible=1")
		dw_2.SetItem(1,"companycode",gs_company)	
		dw_2.SetItem(1,"workym",iv_workym)	
		dw_2.SetItem(1,"empno",iv_empno)
		dw_2.SetItem(1,"pbtag",iv_pbtag)	
		dw_2.SetItem(1,"gubun",'2')			
	else
		il_functionvalue = wf_required_check(dw_2.DataObject,dw_2.GetRow())
	
	end if	
	il_currow = dw_2.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_2.InsertRow(il_currow)
	dw_2.SetItem(il_currow,"companycode",gs_company)	
	dw_2.SetItem(il_currow,"workym",iv_workym)	
	dw_2.SetItem(il_currow,"empno",iv_empno)
	dw_2.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_2.SetItem(il_currow,"gubun",'2')		
	dw_2.ScrollToRow(il_currow)
	dw_2.SetColumn("allowcode")
	dw_2.SetFocus()	
END IF
	

	

end event

type st_2 from statictext within w_pip2111
integer x = 1810
integer y = 776
integer width = 274
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = " 지급수당"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pip2111
integer x = 2990
integer y = 776
integer width = 274
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = " 공제수당"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_pip2111
integer x = 1806
integer y = 660
integer width = 302
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월근태"
end type

event clicked;SetNull(gs_code)
SetNull(gs_codename)

gs_code  = iv_workym 
gs_codename = iv_empno

open(w_pip2111_kun)
end event

type rr_2 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1678
integer y = 200
integer width = 2866
integer height = 356
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 462
integer y = 596
integer width = 3689
integer height = 1640
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 507
integer y = 632
integer width = 1157
integer height = 1580
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3712
integer y = 612
integer width = 379
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2482
integer y = 612
integer width = 384
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1737
integer y = 800
integer width = 1134
integer height = 1412
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2917
integer y = 800
integer width = 1134
integer height = 1412
integer cornerheight = 40
integer cornerwidth = 55
end type

