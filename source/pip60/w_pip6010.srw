$PBExportHeader$w_pip6010.srw
$PBExportComments$** 인건비현황
forward
global type w_pip6010 from w_standard_print
end type
type rr_2 from roundrectangle within w_pip6010
end type
type st_2 from statictext within w_pip6010
end type
type rb_1 from radiobutton within w_pip6010
end type
type rb_3 from radiobutton within w_pip6010
end type
type rb_4 from radiobutton within w_pip6010
end type
type rr_3 from roundrectangle within w_pip6010
end type
end forward

global type w_pip6010 from w_standard_print
integer x = 0
integer y = 0
string title = "부서/개인별 인건비현황"
rr_2 rr_2
st_2 st_2
rb_1 rb_1
rb_3 rb_3
rb_4 rb_4
rr_3 rr_3
end type
global w_pip6010 w_pip6010

type variables
long ll_year, ll_month, ll_day
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sStartYear,sSaup,sEndYear
string sDeptcode,ls_gubun,sJikJong,sPbTag,sdwgubn, sKunmu, sempno, ls_sex
String sAllowText, ArgBuf
Long i

dw_ip.AcceptText()
dw_list.Reset()

sStartYear = dw_ip.GetItemString(1,"ym")
sEndYear   = dw_ip.GetItemString(1,"ym2")
sSaup      = dw_ip.GetItemString(1,"saup")
sDeptcode  = dw_ip.GetItemString(1,"deptcode")
sempno     = dw_ip.GetItemString(1,"empno")

IF sDeptcode = "" OR IsNull(sDeptcode) THEN sDeptcode= '%'
IF sempno = "" OR IsNull(sempno) THEN sempno = '%'

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

//IF sKunmu = '' OR IsNull(sKunmu) THEN
//	sKunmu = '%'
//	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
//ELSE
//	SELECT "KUNMUNAME"
//     INTO :ArgBuf
//     FROM "P0_KUNMU"
//    WHERE ( "KUNMUGUBN" = :sKunmu);
//	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
//END IF

IF sStartYear = "      " OR IsNull(sStartYear) THEN
	MessageBox("확 인","기준년월을 입력하세요!!")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sStartYear + '01') = -1 THEN
   MessageBox("확인","기준년월을 확인하세요")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 

IF sEndYear = "      " OR IsNull(sEndYear) THEN
	MessageBox("확 인","기준년월을 입력하세요!!")
	dw_ip.SetColumn("ym2")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sEndYear + '01') = -1 THEN
   MessageBox("확인","기준년월을 확인하세요")
	dw_ip.SetColumn("ym2")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 
IF sStartYear > sEndYear THEN 
	MessageBox("확인","기준년월범위를 확인하세요")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	Return -1
END IF	


SetPointer(HourGlass!)

IF dw_Print.Retrieve(sSaup,sStartYear,sEndYear,sDeptcode,sempno) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF

dw_print.sharedata(dw_list)

SetPointer(Arrow!)

Return 1

end function

on w_pip6010.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_3
end on

on w_pip6010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_3)
end on

event open;call super::open;
dw_ip.insertrow(0)
dw_ip.Setitem(1,'ym',left(f_today(),4)+'01')
dw_ip.Setitem(1,'ym2',left(f_today(),6))
f_set_saupcd(dw_ip, 'saup','1')
is_saupcd = gs_saupcd

end event

type p_xls from w_standard_print`p_xls within w_pip6010
end type

type p_sort from w_standard_print`p_sort within w_pip6010
end type

type p_preview from w_standard_print`p_preview within w_pip6010
integer y = 20
boolean enabled = true
end type

type p_exit from w_standard_print`p_exit within w_pip6010
integer y = 20
end type

type p_print from w_standard_print`p_print within w_pip6010
integer y = 20
boolean enabled = true
end type

type p_retrieve from w_standard_print`p_retrieve within w_pip6010
integer y = 20
end type

type st_window from w_standard_print`st_window within w_pip6010
boolean visible = false
integer x = 2505
integer y = 2876
end type

type sle_msg from w_standard_print`sle_msg within w_pip6010
boolean visible = false
integer x = 521
integer y = 2872
end type

type dw_datetime from w_standard_print`dw_datetime within w_pip6010
boolean visible = false
integer x = 2990
integer y = 2872
end type

type st_10 from w_standard_print`st_10 within w_pip6010
boolean visible = false
integer x = 160
integer y = 2872
end type

type gb_10 from w_standard_print`gb_10 within w_pip6010
boolean visible = false
integer x = 146
integer y = 2820
end type

type dw_print from w_standard_print`dw_print within w_pip6010
integer x = 3781
string dataobject = "d_pip6010_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pip6010
integer x = 37
integer y = 0
integer width = 2039
integer height = 220
string dataobject = "d_pip6010_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String sDeptno,SetNull,sName,sdwgubn, spbtag, sempno, snull, sempname, ls_name

setnull(SetNull)

dw_ip.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF dw_ip.GetColumnName() ="deptcode" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"deptcode",SetNull)
		dw_ip.SetITem(1,"deptname",SetNull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_ip.SetITem(1,"deptcode",SetNull)
	   dw_ip.SetITem(1,"deptname",SetNull) 
		dw_ip.SetColumn("deptcode")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"deptname",sName) 
END IF	

IF dw_ip.GetColumnName() = "empno" then
   sEmpNo = dw_ip.GetItemString(1,"empno")

	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"empno",snull)
		dw_ip.SetITem(1,"empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"empno",snull)
				 dw_ip.SetITem(1,"empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;IF dw_ip.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
   gs_gubun = is_saupcd

	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	dw_ip.SetITem(1,"deptname",gs_codename)
	
END IF	

IF dw_ip.GetColumnName() = "empno" THEN
	 gs_gubun = is_saupcd
   Open(w_employee_saup_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"empno",gs_code)
	dw_ip.SetITem(1,"empname",gs_codename)
  
END IF	
end event

type dw_list from w_standard_print`dw_list within w_pip6010
integer x = 23
integer y = 236
integer width = 4571
integer height = 2004
string dataobject = "d_pip6010_2"
boolean border = false
end type

type rr_2 from roundrectangle within w_pip6010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2089
integer y = 12
integer width = 1042
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_pip6010
integer x = 2167
integer y = 56
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_pip6010
integer x = 2459
integer y = 44
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "부서별"
boolean checked = true
end type

event clicked;dw_list.Dataobject = "d_pip6010_2"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "d_pip6010_2_p"
dw_print.SetTransobject(sqlca)
end event

type rb_3 from radiobutton within w_pip6010
integer x = 2459
integer y = 120
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "개인별"
end type

event clicked;dw_list.Dataobject = "d_pip6010_3"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "d_pip6010_3_p"
dw_print.SetTransobject(sqlca)
end event

type rb_4 from radiobutton within w_pip6010
integer x = 2738
integer y = 44
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "급여형태별"
end type

event clicked;dw_list.Dataobject = "d_pip6010_4"
dw_list.SetTransobject(sqlca)

dw_print.Dataobject = "d_pip6010_4_p"
dw_print.SetTransobject(sqlca)
end event

type rr_3 from roundrectangle within w_pip6010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 232
integer width = 4590
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

