$PBExportHeader$wr_pip5029.srw
$PBExportComments$** 퇴직금 지급내역서
forward
global type wr_pip5029 from w_standard_print
end type
type rr_1 from roundrectangle within wr_pip5029
end type
end forward

global type wr_pip5029 from w_standard_print
string title = "퇴직금 지급내역서"
rr_1 rr_1
end type
global wr_pip5029 wr_pip5029

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date, ls_empno,lk_date
long retamt_kigum, reteja_kigum, retamt_bokji, reteja_bokji, krate, brate
int swday

Setpointer(hourglass!)

dw_ip.AcceptText()

ls_date = dw_ip.GetITemString(1,"sYm")      /*정산일자*/
ls_empno = dw_ip.GetITemString(1,"sEmpno")  /* 사번*/
lk_date = dw_ip.GetITemString(1,"kYm")      /*지급일자*/

IF f_datechk(ls_date) = -1 THEN
   MessageBox("확 인","정산일자를 확인하세요!!")
   dw_ip.SetColumn("sYm")
	dw_ip.SetFocus()
	Return -1
END IF		

//IF f_datechk(lk_date) = -1 THEN
//   MessageBox("확 인","지급일자를 확인하세요!!")
//   dw_ip.SetColumn("kYm")
//	dw_ip.SetFocus()
//	Return -1
//END IF		

If ls_empno = "" or isnull(ls_empno) then 
   messagebox("확 인", "퇴직자를 입력하세요.!!")
	dw_ip.SetColumn("sempno")
	dw_ip.SetFocus()
	return -1
End if


dw_list.SetRedraw(FALSE)
If dw_list.Retrieve(gs_company, ls_empno, ls_date, lk_date) < 1 then 
   messagebox("확 인","퇴직금정산 내역이 없습니다.!!")
 	dw_list.Insertrow(0)
   dw_list.SetRedraw(TRUE)
   return -1
End If


dw_list.SetItem(1,'kdate',lk_date)
dw_list.SetRedraw(TRUE)

Return 1

end function

on wr_pip5029.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wr_pip5029.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_list.settransobject(sqlca)
dw_list.InsertRow(0)
dw_ip.SetColumn("sempno")
dw_ip.SetItem(1,"kYm",f_today())

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within wr_pip5029
integer x = 4073
end type

event p_preview::clicked;//string ls_date, ls_empno,lk_date
//
//
//dw_ip.AcceptText()
//
//ls_date = dw_ip.GetITemString(1,"sYm")      /*정산일자*/
//ls_empno = dw_ip.GetITemString(1,"sEmpno")  /* 사번*/
//lk_date = dw_ip.GetITemString(1,"kYm")      /*지급일자*/
//
//dw_print.Retrieve(gs_company, ls_empno, ls_date, lk_date)


OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within wr_pip5029
integer x = 4421
end type

type p_print from w_standard_print`p_print within wr_pip5029
integer x = 4247
end type

event p_print::clicked;//string ls_date, ls_empno,lk_date
//
//
//dw_ip.AcceptText()
//
//ls_date = dw_ip.GetITemString(1,"sYm")      /*정산일자*/
//ls_empno = dw_ip.GetITemString(1,"sEmpno")  /* 사번*/
//lk_date = dw_ip.GetITemString(1,"kYm")      /*지급일자*/
//
//dw_list.Retrieve(gs_company, ls_empno, ls_date, lk_date)


IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)

end event

type p_retrieve from w_standard_print`p_retrieve within wr_pip5029
integer x = 3899
end type

type st_window from w_standard_print`st_window within wr_pip5029
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wr_pip5029
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pip5029
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wr_pip5029
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wr_pip5029
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wr_pip5029
string dataobject = "dr_pip5029_2"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5029
integer x = 526
integer y = 20
integer width = 1806
integer height = 244
string dataobject = "dr_pip5029ret"
end type

event dw_ip::itemchanged;String sempname, sempno, snull,GetEmpname,sMdate, ls_name
int il_count

IF dw_ip.GetColumnName() = "sempno" THEN
   sempno = dw_ip.GetText()

	IF sempno ="" OR IsNull(sempno) THEN RETURN
			
	SetNull(snull)
		
	SELECT p1_master.empname
	  INTO :GetEmpname
	  FROM "P1_MASTER"
	 WHERE "P1_MASTER"."EMPNO" = :sempno;
		
		IF GetEmpname  = '' OR ISNULL(GetEmpname) THEN
		   Messagebox("확 인","등록되지 않은 사번이므로 조회할 수 없습니다!!")
			dw_ip.SetITem(1,"sempno",snull)
			dw_ip.SetITem(1,"sempname",snull)
			return 1
		END IF
		dw_ip.SetITem(1,"sempname",GetEmpname)
		
	 select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :sempno;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sym', sMdate)
     end if
	  
END IF

IF GetColumnName() = "sempname" then
  sEmpName = this.Gettext()

   sempno = wf_exiting_saup_name('empname',sEmpName, '1', '%')	 
	 if IsNull(ls_name) then 
		 Setitem(1,'sempname',ls_name)
		 Setitem(1,'sempno',ls_name)
		 return 1
    end if
	 Setitem(1,"sempno",sempno)
	 ls_name = wf_exiting_saup_name('empno',sempno, '1', '%')
	 Setitem(1,"sempname",ls_name)
	 
	 select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :sempno;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sym', sMdate)
     end if
	  
	 return 1
END IF

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


	
	
	
	
	
	

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)
string sMdate, sempno , sname
dw_ip.AcceptText()

Gs_gubun = is_saupcd

IF dw_ip.GetColumnName() = "sempno"  THEN
   Gs_Code = dw_ip.GetItemString(1,"sempno")
   open(w_employee_retire_popup)
	
   IF IsNull(Gs_code) THEN RETURN
	  dw_ip.SetITem(1,"sempno",Gs_code)
	  dw_ip.SetITem(1,"sempname",gs_codename)
	  
	   select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :Gs_Code;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sym', sMdate)
     end if
	  
END IF

IF GetColumnName() = "sempname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"sempname")
	
	open(w_employee_retire_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	  dw_ip.SetITem(1,"sempno",Gs_code)
	  dw_ip.SetITem(1,"sempname",gs_codename)

	   select max(todate) into :sMdate
	  from p3_retirementpay
	  where empno = :Gs_Code;
	  
	  if IsNull(sMdate) or sMdate = '' then
	  else
		   dw_ip.Setitem(1,'sym', sMdate)
     end if	
END IF

IF GetColumnName() = "sym" THEN
	sempno = trim(GetItemString(1,"sempno"))
	sname = trim(GetItemString(1,"sempname"))

	if sempno = '' or isnull(sempno) then
		MessageBox('확인','사번을 확인하세요!')
		return
	elseif sname = '' or isnull(sname) then
		MessageBox('확인','성명을 확인하세요!')
		return
	end if
	
	muiltstr l_str_parms 
	l_str_parms.s[1] = sempno
   l_str_parms.s[2] = sname
	openwithparm(w_pip5022_popup, l_str_parms)
	
	IF IsNull(Gs_code) THEN RETURN
	SetItem(1,"sym",Gs_codeName)
END IF
end event

type dw_list from w_standard_print`dw_list within wr_pip5029
integer x = 562
integer y = 272
integer width = 3552
integer height = 2016
string dataobject = "dr_pip5029_2"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within wr_pip5029
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 544
integer y = 268
integer width = 3589
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 46
end type

