$PBExportHeader$wp_pif2110.srw
$PBExportComments$** 인사 기록 카드 현황
forward
global type wp_pif2110 from w_standard_print
end type
type cb_1 from commandbutton within wp_pif2110
end type
type dw_1 from datawindow within wp_pif2110
end type
end forward

global type wp_pif2110 from w_standard_print
integer x = 0
integer y = 0
string title = "인사 기록 카드"
cb_1 cb_1
dw_1 dw_1
end type
global wp_pif2110 wp_pif2110

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_company_name, sempno
int i

dw_1.Accepttext()

setpointer(hourglass!)
sempno = dw_ip.GetItemString(1,"empno")

if isnull(sempno) or sempno = '' THEN sempno = '%'

dw_list.SetRedraw(false)
if dw_list.retrieve(gs_company, sempno, gs_picpath, is_saupcd) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_list.InsertRow(0)
	dw_list.SetRedraw(true)
	return -1
end if
f_get_pic(gs_picpath,sempno)
dw_list.SetRedraw(true)

// 회사정보 자료
     select dataname
	  into :ls_company_name
	  from p0_syscnfg
	 where sysgu = 'C' and serial = '1' and lineno = '3' ;
//for i=1 to dw_list.rowcount()
	//dw_list.setitem(i, "companyname", ls_company_name)   // 법인명 & 상호
     dw_list.Modify("companyname.text = '"+ls_company_name+"'")
	//  dw_print.Modify("companyname.text = '"+ls_company_name+"'")
//next


string ls_chk1, ls_chk2, ls_chk3, ls_chk4, ls_chk5, ls_chk6, ls_chk7, ls_chk8, ls_chk9, ls_chk10
string ls_chk11, ls_chk12, ls_chk13

ls_chk1 = dw_1.GetItemString(1,"chk1")
ls_chk2 = dw_1.GetItemString(1,"chk2")
ls_chk3 = dw_1.GetItemString(1,"chk3")
ls_chk4 = dw_1.GetItemString(1,"chk4")
ls_chk5 = dw_1.GetItemString(1,"chk5")
ls_chk6 = dw_1.GetItemString(1,"chk6")
ls_chk7 = dw_1.GetItemString(1,"chk7")
ls_chk8 = dw_1.GetItemString(1,"chk8")
ls_chk9 = dw_1.GetItemString(1,"chk9")
ls_chk10 = dw_1.GetItemString(1,"chk10")
ls_chk11 = dw_1.GetItemString(1,"chk11")
ls_chk12 = dw_1.GetItemString(1,"chk12")
ls_chk13 = dw_1.GetItemString(1,"chk13")

dw_list.SetItem(1,"chk1", ls_chk1)
dw_list.SetItem(1,"chk2", ls_chk2)
dw_list.SetItem(1,"chk3", ls_chk3)
dw_list.SetItem(1,"chk4", ls_chk4)
dw_list.SetItem(1,"chk5", ls_chk5)
dw_list.SetItem(1,"chk6", ls_chk6)
dw_list.SetItem(1,"chk7", ls_chk7)
dw_list.SetItem(1,"chk8", ls_chk8)
dw_list.SetItem(1,"chk9", ls_chk9)
dw_list.SetItem(1,"chk10", ls_chk10)
dw_list.SetItem(1,"chk11", ls_chk11)
dw_list.SetItem(1,"chk12", ls_chk12)
dw_list.SetItem(1,"chk13", ls_chk13)


setpointer(arrow!)

return 1
end function

on wp_pif2110.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
end on

on wp_pif2110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;call super::open;dw_print.ShareDataOff()
dw_list.InsertRow(0)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)


f_set_saupcd(dw_ip,'saupcd','1')
is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within wp_pif2110
boolean visible = false
integer x = 4722
integer y = 16
end type

type p_exit from w_standard_print`p_exit within wp_pif2110
integer x = 4407
integer y = 20
integer taborder = 70
end type

type p_print from w_standard_print`p_print within wp_pif2110
integer x = 4233
integer y = 20
integer taborder = 60
end type

event p_print::clicked;//dw_list.RowsCopy(1, dw_list.RowCount(), Primary!, dw_print, 1, Primary!)

//IF dw_list.rowcount() > 0 then 
//	gi_page = dw_list.GetItemNumber(1,"last_page")
//ELSE
//	gi_page = 1
//END IF
gi_page = 2
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within wp_pif2110
integer x = 4059
integer y = 20
integer taborder = 10
end type

type st_window from w_standard_print`st_window within wp_pif2110
boolean visible = false
integer x = 2665
integer y = 3008
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2110
boolean visible = false
integer x = 690
integer y = 3008
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2110
boolean visible = false
integer x = 3182
integer y = 2992
end type

type st_10 from w_standard_print`st_10 within wp_pif2110
boolean visible = false
integer x = 329
integer y = 3012
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2110
boolean visible = false
integer x = 315
integer y = 2956
end type

type dw_print from w_standard_print`dw_print within wp_pif2110
integer y = 20
string dataobject = "dp_pif2110"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2110
integer x = 32
integer y = 24
integer width = 1202
integer height = 484
integer taborder = 20
string dataobject = "dp_pif2110_1"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	Gs_gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	Triggerevent(ItemChanged!)
END IF
end event

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName, ls_name

AcceptText()

IF GetColumnName() = "empno" then
  sEmpNo = GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"empno",SetNull)
		  SetITem(1,"empname",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 SetITem(1,"empno",SetNull)
				 SetITem(1,"empname",SetNull)
				 RETURN 1 
			 END IF
				SetITem(1,"empname",sEmpName  )
				
	 END IF
	p_retrieve.triggerevent(clicked!)
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
IF GetColumnName() = "saupcd" then
	is_saupcd = this.Gettext()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2110
integer x = 18
integer y = 516
integer width = 4603
integer height = 1752
string dataobject = "dp_pif2110"
boolean border = false
end type

type cb_1 from commandbutton within wp_pif2110
boolean visible = false
integer x = 3616
integer y = 2364
integer width = 521
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "백지출력"
end type

event clicked;string ls_company_name
dw_list.ReSet()
dw_list.insertrow(0)
// 회사정보 자료
select dataname
	  into :ls_company_name
	  from p0_syscnfg
	 where sysgu = 'C' and serial = '1' and lineno = '3' ;
	 
//dw_list.setitem(dw_list.getrow(), "company_name", ls_company_name)   // 법인명 & 상호

OpenWithParm(w_print_options, dw_list)


end event

type dw_1 from datawindow within wp_pif2110
integer x = 1230
integer y = 28
integer width = 2130
integer height = 484
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dp_pif2110_2"
boolean border = false
boolean livescroll = true
end type

