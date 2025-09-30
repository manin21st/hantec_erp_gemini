$PBExportHeader$wp_pif2101.srw
$PBExportComments$** 증명서 발급(사용)
forward
global type wp_pif2101 from w_standard_print
end type
type rb_1 from radiobutton within wp_pif2101
end type
type rb_2 from radiobutton within wp_pif2101
end type
type rb_3 from radiobutton within wp_pif2101
end type
type sle_3 from singlelineedit within wp_pif2101
end type
type st_1 from statictext within wp_pif2101
end type
type rr_2 from roundrectangle within wp_pif2101
end type
type rr_3 from roundrectangle within wp_pif2101
end type
type rr_1 from roundrectangle within wp_pif2101
end type
end forward

global type wp_pif2101 from w_standard_print
integer x = 0
integer y = 0
integer height = 2580
string title = "증명서 발급"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
sle_3 sle_3
st_1 st_1
rr_2 rr_2
rr_3 rr_3
rr_1 rr_1
end type
global wp_pif2101 wp_pif2101

type variables
Boolean kEnter
end variables

forward prototypes
public subroutine wf_verify1 (string ls_code)
public subroutine wf_verify2 (string ls_code)
public function integer wf_retrieve ()
public subroutine wf_verify3 (string ls_code)
public subroutine wf_env_set ()
end prototypes

public subroutine wf_verify1 (string ls_code);string ls_name, ls_addr1, ls_addr2, ls_dept, ls_grade, ls_kname, ls_edate
string ls_resno1, ls_resno2, ls_year, ls_month, ls_day

select p1_master.empname,
		 p1_master.residentno1,
		 p1_master.residentno2,
		 p0_dept.deptname2,
		 p0_grade.gradename,
		 p0_jikmu.jikmuname,
		 p1_master.enterdate,
		 p1_etc.address21,
		 p1_etc.address22
  into :ls_name,
		 :ls_resno1,
		 :ls_resno2,
		 :ls_dept,
		 :ls_grade,
		 :ls_kname,
		 :ls_edate,
		 :ls_addr1,
		 :ls_addr2
  from p1_master,
		 p1_careers,
		 p0_dept,
		 p0_grade,
		 p0_jikmu,
		 p1_etc
 where p1_master.companycode = p1_careers.companycode (+) and
		 p1_master.empno = p1_careers.empno (+) and
		 p1_master.companycode = p1_etc.companycode (+) and
		 p1_master.empno = p1_etc.empno (+) and
		 p1_master.gradecode = p0_grade.gradecode (+) and
		 p1_master.deptcode = p0_dept.deptcode (+) and
		 p1_master.jikmugubn = p0_jikmu.jikmugubn (+) and
		 p1_master.empno = :ls_code ;

ls_year = left(ls_edate, 4)
ls_month = mid(ls_edate, 5 ,2)
ls_day = right(ls_edate, 2)

dw_list.insertrow(0)
dw_print.insertrow(0)

IF  trim(ls_addr2) = '' or isnull(ls_addr2) THEN
	 dw_list.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
ELSE
	 dw_list.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
END IF	
//dw_list.setitem(1, "address", lefttrim(ls_addr1))
dw_list.setitem(1, "empname", ls_name)
dw_list.setitem(1, "peopleno1", ls_resno1)
dw_list.setitem(1, "peopleno2", ls_resno2)
dw_list.setitem(1, "deptname", ls_dept)
dw_list.setitem(1, "gradename", ls_grade)
dw_list.setitem(1, "job", ls_kname)
dw_list.setitem(1, "fromyear", ls_year)
dw_list.setitem(1, "frommonth", ls_month)
dw_list.setitem(1, "fromday", ls_day)
IF  trim(ls_addr2) = '' or isnull(ls_addr2) THEN
	 dw_print.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
ELSE
	 dw_print.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
END IF	
//dw_print.setitem(1, "address", lefttrim(ls_addr1))
dw_print.setitem(1, "empname", ls_name)
dw_print.setitem(1, "peopleno1", ls_resno1)
dw_print.setitem(1, "peopleno2", ls_resno2)
dw_print.setitem(1, "deptname", ls_dept)
dw_print.setitem(1, "gradename", ls_grade)
dw_print.setitem(1, "job", ls_kname)
dw_print.setitem(1, "fromyear", ls_year)
dw_print.setitem(1, "frommonth", ls_month)
dw_print.setitem(1, "fromday", ls_day)
end subroutine

public subroutine wf_verify2 (string ls_code);//경력증명서//
string ls_name, ls_addr1, ls_addr2, ls_dept, ls_grade, ls_kname, ls_edate, ls_rdate
string ls_resno1, ls_resno2, ls_yy1, ls_yy2, ls_mm1, ls_mm2, ls_dd1, ls_dd2

select p1_master.empname,
		 p1_master.residentno1,
		 p1_master.residentno2,
		 p0_dept.deptname2,
		 p0_grade.gradename,
		 p0_jikmu.jikmuname,
		 p1_master.enterdate,
		 p1_master.retiredate,
		 p1_etc.address21,
		 p1_etc.address22
  into :ls_name,
		 :ls_resno1,
		 :ls_resno2,
		 :ls_dept,
		 :ls_grade,
		 :ls_kname,
		 :ls_edate,
		 :ls_rdate,
		 :ls_addr1,
		 :ls_addr2
  from p1_master,
		 p0_dept,
		 p0_grade,
		 p0_jikmu,
		 p1_etc
 where p1_master.gradecode = p0_grade.gradecode (+) and
		 p1_master.deptcode = p0_dept.deptcode (+) and
		 p1_master.jikmugubn = p0_jikmu.jikmugubn (+) and
		 p1_master.companycode = p1_etc.companycode (+) and
		 p1_master.empno = p1_etc.empno (+) and
		 p1_master.empno = :ls_code ;

ls_yy1 = left(ls_edate, 4)
ls_mm1 = mid(ls_edate, 5 ,2)
ls_dd1 = right(ls_edate, 2)

ls_yy2 = left(ls_rdate, 4)
ls_mm2 = mid(ls_rdate, 5 ,2)
ls_dd2 = right(ls_rdate, 2)

dw_list.insertrow(0)
dw_print.insertrow(0)

IF  trim(ls_addr2) = '' or isnull(ls_addr2) THEN
	 dw_list.setitem(1, "address",lefttrim(ls_addr1))
ELSE
	 dw_list.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
END IF	
//dw_list.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
//dw_list.setitem(1, "address", lefttrim(ls_addr1))
dw_list.setitem(1, "empname", ls_name)
dw_list.setitem(1, "peopleno1", ls_resno1)
dw_list.setitem(1, "peopleno2", ls_resno2)
dw_list.setitem(1, "deptname", ls_dept)
dw_list.setitem(1, "gradename", ls_grade)
dw_list.setitem(1, "job", ls_kname)
dw_list.setitem(1, "fromyear", ls_yy1)
dw_list.setitem(1, "frommonth", ls_mm1)
dw_list.setitem(1, "fromday", ls_dd1)
dw_list.setitem(1, "toyear", ls_yy2)
dw_list.setitem(1, "tomonth", ls_mm2)
dw_list.setitem(1, "today", ls_dd2)
IF  trim(ls_addr2) = '' or isnull(ls_addr2) THEN
	 dw_print.setitem(1, "address",lefttrim(ls_addr1))
ELSE
	 dw_print.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
END IF	
//dw_print.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
//dw_print.setitem(1, "address", lefttrim(ls_addr1))
dw_print.setitem(1, "empname", ls_name)
dw_print.setitem(1, "peopleno1", ls_resno1)
dw_print.setitem(1, "peopleno2", ls_resno2)
dw_print.setitem(1, "deptname", ls_dept)
dw_print.setitem(1, "gradename", ls_grade)
dw_print.setitem(1, "job", ls_kname)
dw_print.setitem(1, "fromyear", ls_yy1)
dw_print.setitem(1, "frommonth", ls_mm1)
dw_print.setitem(1, "fromday", ls_dd1)
dw_print.setitem(1, "toyear", ls_yy2)
dw_print.setitem(1, "tomonth", ls_mm2)
dw_print.setitem(1, "today", ls_dd2)
end subroutine

public function integer wf_retrieve ();string ls_code, ls_docno, ls_use, ls_yy, ls_mm ,ls_dd, ls_docNum
String sKindCode
INT maxseq

setpointer(hourglass!)

//dw_list.reset()
dw_ip.AcceptText()

/* 문서번호 표시*/

  SELECT max("P1_CERTHST"."SEQ")  
    INTO :maxseq  
    FROM "P1_CERTHST"  
   WHERE ( "P1_CERTHST"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_CERTHST"."YEAR" = substr(:gs_today,1,4) ) ;
			
IF sqlca.sqlcode <> 0 OR maxseq = 0 OR isnull(maxseq) THEN
	maxseq = 1
ELSE
	maxseq = maxseq + 1
END IF	

ls_docNum = left(gs_today,4) + "-" + string(maxseq,'000')
dw_ip.SetItem(dw_ip.GetRow(),"docnum",ls_docNum)

ls_code  = dw_ip.GetItemString(1,"scode1")    /* 사원번호 */
ls_docno = trim(dw_ip.GetItemString(dw_ip.GetRow(),"docnum"))    /* 문서번호 */
ls_use   = trim(dw_ip.GetItemString(dw_ip.GetRow(),"use"))    /* 용    도 */

ls_yy = left(gs_today, 4)
ls_mm = mid(gs_today, 5, 2)
ls_dd = right(gs_today , 2)

IF isnull(ls_code) or ls_code = '' THEN
	messagebox("사원번호", "사원 번호를 입력하세요.!", information!)
	dw_ip.SetColumn("scode1")
	dw_ip.SetFocus()
	Return -1
END IF

IF rb_1.checked = TRUE THEN
   SELECT "P1_MASTER"."SERVICEKINDCODE"  
    INTO :sKindCode  
    FROM "P1_MASTER" 
	 WHERE "P1_MASTER"."EMPNO" = :ls_code ;
 
	IF sKindCode = '3' THEN  
		MessageBox("확인","퇴사자 이므로 재직증명서를 출력할수 없습니다")
		Return -1 
	END IF	
	dw_list.dataobject = "dp_pif2101_1"   // 재직 증명서
	dw_print.dataobject = "dp_pif2101_1"   // 재직 증명서
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	
	wf_verify1(ls_code)
	dw_list.setitem(1, "titlename", '재 직 증 명 서')
	dw_print.setitem(1, "titlename", '재 직 증 명 서')
	
ELSEIF rb_2.checked = TRUE then
	SELECT "P1_MASTER"."SERVICEKINDCODE"  
    INTO :sKindCode  
    FROM "P1_MASTER" 
	 WHERE "P1_MASTER"."EMPNO" = :ls_code ;
 
	IF sKindCode <> '3' THEN  
		MessageBox("확인","퇴사자가 아니므로 경력증명서를 출력할수 없습니다")
		Return -1
	END IF	
	dw_list.dataobject = "dp_pif2101_2"   // 경력 증명서
	dw_print.dataobject = "dp_pif2101_2"   // 재직 증명서
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)
	
	wf_verify2(ls_code)
	dw_list.setitem(1, "titlename", '경 력 증 명 서')
	dw_print.setitem(1, "titlename", '경 력 증 명 서')
	
ELSEIF rb_3.checked = TRUE then
	SELECT "P1_MASTER"."SERVICEKINDCODE"  
    INTO :sKindCode  
    FROM "P1_MASTER" 
	 WHERE "P1_MASTER"."EMPNO" = :ls_code ;
 
	IF sKindCode <> '3' THEN  
		MessageBox("확인","퇴사자가 아니므로 퇴직증명서를 출력할수 없습니다")
		Return -1
	END IF	
	dw_list.dataobject = "dp_pif2101_3"   // 퇴직 증명서
	dw_print.dataobject = "dp_pif2101_3"   // 재직 증명서
	dw_list.settransobject(sqlca)
	dw_print.settransobject(sqlca)	
	
	wf_verify3(ls_code)
	dw_list.setitem(1, "titlename", '퇴 직 증 명 서')
	dw_print.setitem(1, "titlename", '퇴 직 증 명 서')
END IF


Long ToTalLen
Long  ToTalAction
dw_list.setitem(1, "paperno", ls_docno)
dw_print.setitem(1, "paperno", ls_docno)

IF sle_3.text = '2' THEN   // Enter Key 넣었을경우
   ToTalAction = Len(ls_use)
   ToTalLen =  ToTalAction - 2
   ls_use = Left(ls_use,ToTalLen)
ELSE	
   ls_use = ls_use
END IF	

dw_list.setitem(1, "action", ls_use)

dw_list.setitem(1, "presentyear", ls_yy)
dw_list.setitem(1, "presentmonth", ls_mm)
dw_list.setitem(1, "presentday", ls_dd)

dw_print.setitem(1, "action", ls_use)

dw_print.setitem(1, "presentyear", ls_yy)
dw_print.setitem(1, "presentmonth", ls_mm)
dw_print.setitem(1, "presentday", ls_dd)

wf_env_set()   // 명판 Setting

if dw_print.rowcount() < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.SetColumn("scode1")
	dw_ip.SetFocus()
	return -1
end if
dw_print.sharedata(dw_list)
RETURN 1


//cb_print.enabled = true

/* Last page 구하는 routine */
//long Li_row = 1, Ll_prev_row
//
//dw_list.setredraw(false)
//dw_list.object.datawindow.print.preview="yes"
//
//gi_page = 1
//
//do while true
//	ll_prev_row = Li_row
//	Li_row = dw_list.ScrollNextPage()
//	If Li_row = ll_prev_row or Li_row <= 0 then
//		exit
//	Else
//		gi_page++
//	End if
//loop
//
//dw_list.scrolltorow(1)
//dw_list.setredraw(true)

setpointer(arrow!)
end function

public subroutine wf_verify3 (string ls_code);string ls_name, ls_addr1, ls_addr2, ls_dept, ls_grade, ls_kname, ls_edate, ls_rdate
string ls_resno1, ls_resno2, ls_yy1, ls_yy2, ls_mm1, ls_mm2, ls_dd1, ls_dd2

select p1_master.empname,
		 p1_master.residentno1,
		 p1_master.residentno2,
		 p0_dept.deptname2,
		 p0_grade.gradename,
		 p0_jikmu.jikmuname,
		 p1_master.enterdate,
		 p1_master.retiredate,
		 p1_etc.address21,
		 p1_etc.address22
  into :ls_name,
		 :ls_resno1,
		 :ls_resno2,
		 :ls_dept,
		 :ls_grade,
		 :ls_kname,
		 :ls_edate,
		 :ls_rdate,
		 :ls_addr1,
		 :ls_addr2
  from p1_master,
		 p1_careers,
		 p0_dept,
		 p0_grade,
		 p0_jikmu,
		 p1_etc
 where p1_master.companycode = p1_careers.companycode (+) and
		 p1_master.empno = p1_careers.empno (+) and
		 p1_master.gradecode = p0_grade.gradecode (+) and
		 p1_master.deptcode = p0_dept.deptcode (+) and
		 p1_master.jikmugubn = p0_jikmu.jikmugubn (+) and
		 p1_master.companycode = p1_etc.companycode (+) and
		 p1_master.empno = p1_etc.empno (+) and
		 p1_master.empno = :ls_code ;

ls_yy1 = left(ls_edate, 4)
ls_mm1 = mid(ls_edate, 5 ,2)
ls_dd1 = right(ls_edate, 2)

ls_yy2 = left(ls_rdate, 4)
ls_mm2 = mid(ls_rdate, 5 ,2)
ls_dd2 = right(ls_rdate, 2)

dw_list.insertrow(0)
dw_print.insertrow(0)

IF  trim(ls_addr2) = '' or isnull(ls_addr2) THEN
	 dw_list.setitem(1, "address",lefttrim(ls_addr1))
ELSE
	 dw_list.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
END IF	
//dw_list.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
dw_list.setitem(1, "empname", ls_name)
dw_list.setitem(1, "peopleno1", ls_resno1)
dw_list.setitem(1, "peopleno2", ls_resno2)
dw_list.setitem(1, "deptname", ls_dept)
dw_list.setitem(1, "gradename", ls_grade)
dw_list.setitem(1, "job", ls_kname)
dw_list.setitem(1, "fromyear", ls_yy1)
dw_list.setitem(1, "frommonth", ls_mm1)
dw_list.setitem(1, "fromday", ls_dd1)
dw_list.setitem(1, "toyear", ls_yy2)
dw_list.setitem(1, "tomonth", ls_mm2)
dw_list.setitem(1, "today", ls_dd2)
IF  trim(ls_addr2) = '' or isnull(ls_addr2) THEN
	 dw_print.setitem(1, "address",lefttrim(ls_addr1))
ELSE
	 dw_print.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
END IF	
//dw_print.setitem(1, "address", lefttrim(ls_addr1) + ' ' + lefttrim(ls_addr2))
dw_print.setitem(1, "empname", ls_name)
dw_print.setitem(1, "peopleno1", ls_resno1)
dw_print.setitem(1, "peopleno2", ls_resno2)
dw_print.setitem(1, "deptname", ls_dept)
dw_print.setitem(1, "gradename", ls_grade)
dw_print.setitem(1, "job", ls_kname)
dw_print.setitem(1, "fromyear", ls_yy1)
dw_print.setitem(1, "frommonth", ls_mm1)
dw_print.setitem(1, "fromday", ls_dd1)
dw_print.setitem(1, "toyear", ls_yy2)
dw_print.setitem(1, "tomonth", ls_mm2)
dw_print.setitem(1, "today", ls_dd2)
end subroutine

public subroutine wf_env_set ();string ls_saup, ls_name1, ls_name2, ls_name3

ls_saup = dw_ip.GetItemString(1,'saupcd')

select addr, chairman, jurname
  into :ls_name1, :ls_name2, :ls_name3
  from p0_saupcd
 where companycode = :gs_company and
 		 saupcode =  :ls_saup ;


dw_list.modify("name1.text = '"+ls_name1+"'")
dw_print.modify("name1.text = '"+ls_name1+"'")

dw_list.modify("name2.text = '"+ls_name2+"'")
dw_print.modify("name2.text = '"+ls_name2+"'")

dw_list.modify("name3.text = '"+ls_name3+"'")
dw_print.modify("name3.text = '"+ls_name3+"'")
end subroutine

on wp_pif2101.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.sle_3=create sle_3
this.st_1=create st_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.sle_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
this.Control[iCurrent+8]=this.rr_1
end on

on wp_pif2101.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.sle_3)
destroy(this.st_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;integer	maxseq
String	ls_docNum

/* 문서번호 표시*/

  SELECT max("P1_CERTHST"."SEQ")  
    INTO :maxseq  
    FROM "P1_CERTHST"  
   WHERE ( "P1_CERTHST"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_CERTHST"."YEAR" = substr(:gs_today,1,4) ) ;
			
IF sqlca.sqlcode <> 0 OR maxseq = 0 OR isnull(maxseq) THEN
	maxseq = 1
ELSE
	maxseq = maxseq + 1
END IF	

ls_docNum = left(gs_today,4) + "-" + string(maxseq,'000')
dw_ip.SetItem(dw_ip.GetRow(),"docnum",ls_docNum)

f_set_saupcd(dw_ip,'saupcd','1')
is_saupcd = gs_saupcd	
dw_list.InsertRow(0)
end event

type p_xls from w_standard_print`p_xls within wp_pif2101
end type

type p_sort from w_standard_print`p_sort within wp_pif2101
end type

type p_preview from w_standard_print`p_preview within wp_pif2101
boolean visible = false
integer x = 4731
integer y = 188
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pif2101
integer x = 4425
integer y = 12
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2101
integer x = 4251
integer y = 12
string pointer = ""
end type

event p_print::clicked;call super::clicked;integer sSeq,sSeq1,maxseq
String gubn,sEmpno,sDeptcode,sYongdo,sNo,year

dw_ip.AcceptText()

   sEmpno  = dw_ip.GetItemString(1,"scode1")

  IF rb_1.checked THEN 
     gubn = '1'
  ELSEIF rb_2.checked  THEN	
     gubn = '2'
  ELSE
     gubn = '3'
  END IF  
  sYongdo = dw_ip.GetItemString(1,"use")		  //용도
  sNo = trim(dw_ip.GetItemString(1,"docnum"))   //문서번호 
  sSeq = integer(right(sNo,3))
  
                  
  //부서번호   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
   SELECT P1_MASTER.DEPTCODE
    INTO :sDeptcode 
    FROM   P1_MASTER
    WHERE P1_MASTER.COMPANYCODE = :gs_company AND
          P1_MASTER.EMPNO = :sEmpno  ;  
  //         &&&&&&&&&&&&&&&&&
  
  
   INSERT INTO p1_certhst
	VALUES (:gs_company,:sempno,substr(:gs_today,1,4),:sSeq,:gubn,:sNo,:gs_today,:sDeptcode,:sYongdo,'') ;
   IF SQLCA.SQLCODE <> 0 THEN
		Rollback ;
	ELSE
		Commit ; 
		

	
	END IF


end event

type p_retrieve from w_standard_print`p_retrieve within wp_pif2101
integer x = 4078
integer y = 12
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2101
integer y = 5000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2101
integer y = 5000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2101
integer y = 5000
end type

type st_10 from w_standard_print`st_10 within wp_pif2101
integer y = 5000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2101
integer y = 5000
end type

type dw_print from w_standard_print`dw_print within wp_pif2101
integer x = 3753
string dataobject = "dp_pif2101_1"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2101
integer x = 64
integer y = 36
integer width = 1541
integer height = 252
integer taborder = 40
string dataobject = "dp_pif2101_4"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName, ls_name

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


IF GetColumnName() = "scode1" then
  sEmpNo = GetItemString(1,"scode1")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"scode1",SetNull)
		  SetITem(1,"sname1",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 SetITem(1,"scode1",SetNull)
				 SetITem(1,"sname1",SetNull)
				 RETURN 1 
			 END IF
				SetITem(1,"sname1",sEmpName  )
				
	 END IF
END IF

IF GetColumnName() = "sname1" then
  sEmpName = GetItemString(1,"sname1")

//	  IF sEmpName = '' or isnull(sEmpName) THEN
//		  SetITem(1,"scode1",SetNull)
//		  SetITem(1,"sname1",SetNull)
//	  ELSE	
//			SELECT "P1_MASTER"."EMPNO"  
//				INTO :sEmpNo
//				FROM "P1_MASTER"  
//				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
//						( "P1_MASTER"."EMPNAME" = :sEmpName ) ;
//			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원명을 확인하세요!!") 
//				 SetITem(1,"scode1",SetNull)
//				 SetITem(1,"sname1",SetNull)
//				 RETURN 1 
//			 END IF
//				SetITem(1,"scode1",sEmpNo)
//				
//	 END IF
    ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'sname1',ls_name)
		 Setitem(1,'scode1',ls_name)
		 return 2
    end if
	 Setitem(1,"scode1",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"sname1",ls_name)
	 return 2
	 
END IF

end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

AcceptText()
Gs_gubun = is_saupcd
IF GetColumnName() = "saupcd" THEN
   is_saupcd = this.gettext()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
	Gs_gubun = is_saupcd
END IF

IF GetColumnName() = "sname1" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"sname1")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"scode1",Gs_code)
	SetItem(this.GetRow(),"sname1",Gs_codeName)
	
END IF

IF GetColumnName() = "scode1" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"scode1")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"scode1",Gs_code)
	SetItem(this.GetRow(),"sname1",Gs_codeName)
END IF


end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2101
integer y = 344
integer width = 4544
integer height = 1940
string dataobject = "dp_pif2101_1"
boolean border = false
end type

event dw_list::clicked;//override
end event

event dw_list::rowfocuschanged;//override
end event

type rb_1 from radiobutton within wp_pif2101
integer x = 1915
integer y = 64
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "재직 증명서"
boolean checked = true
end type

type rb_2 from radiobutton within wp_pif2101
integer x = 1915
integer y = 128
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "경력 증명서"
end type

type rb_3 from radiobutton within wp_pif2101
integer x = 1915
integer y = 196
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "퇴직 증명서"
end type

type sle_3 from singlelineedit within wp_pif2101
boolean visible = false
integer x = 1614
integer y = 2608
integer width = 155
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within wp_pif2101
integer x = 1605
integer y = 76
integer width = 274
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "출력구분"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within wp_pif2101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 332
integer width = 4571
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within wp_pif2101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 16
integer width = 2354
integer height = 300
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within wp_pif2101
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1879
integer y = 48
integer width = 471
integer height = 236
integer cornerheight = 40
integer cornerwidth = 55
end type

