$PBExportHeader$wp_pif2103.srw
$PBExportComments$** 발령 사항(사용)
forward
global type wp_pif2103 from w_standard_print
end type
type rb_1 from radiobutton within wp_pif2103
end type
type rb_2 from radiobutton within wp_pif2103
end type
type rb_3 from radiobutton within wp_pif2103
end type
type gb_1 from groupbox within wp_pif2103
end type
type rr_2 from roundrectangle within wp_pif2103
end type
type uo_1 from uo_lev_up within wp_pif2103
end type
end forward

global type wp_pif2103 from w_standard_print
integer x = 0
integer y = 0
integer height = 2580
string title = "발령 사항"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
rr_2 rr_2
uo_1 uo_1
end type
global wp_pif2103 wp_pif2103

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_setting ()
end prototypes

public function integer wf_retrieve ();string ls_date1, ls_date2, ls_name, ls_yy1, ls_yy2, ls_mm1, ls_mm2, ls_dd1, ls_dd2, ls_saupcd
string ls_set1, ls_set2, ls_dept, ls_grade, ls_level, ls_salary, ls_code


setpointer(hourglass!)
dw_ip.AcceptText()

ls_date1 = trim(dw_ip.GetItemString(1,"dayfrom"))
//ls_set1 =Left(ls_date1,4) + mid(ls_date1,6,2) + right(ls_date1,2)
ls_date2 = trim(dw_ip.GetItemString(1,"dayto"))
//ls_set2 =Left(ls_date2,4) + mid(ls_date2,6,2) + right(ls_date2,2)  

ls_name = dw_ip.GetItemString(1,"empno")
ls_code = dw_ip.GetItemString(1,"code")

ls_saupcd = dw_ip.GetItemString(1,"saupcd")

if isnull(ls_date1) or ls_date1 = '' then
	messagebox("발령일자(FROM)", "발령 일자가 부정확합니다.!", information!)
	return -1
end if

if isnull(ls_date2) or ls_date2 = '' then
	messagebox("발령일자(TO)", "발령 일자가 부정확합니다.!", information!)
	return -1
end if

if ls_date1 > ls_date2 then
	messagebox("범위 확인", "입력 범위가 부정확합니다.!", information!)
	return -1
end if

if isnull(ls_name) or ls_name = '' then
	ls_name = '%'
else
   ls_name = dw_ip.GetItemString(1,"empno")
end if

if isnull(ls_code) or ls_code = '' then ls_code = '%'

if isnull(ls_saupcd) or ls_saupcd = '' then ls_saupcd = '%'

//select p0_dept.deptname2,
//       p0_grade.gradename,
//		 p0_level.levelname,
//		 p1_master.salary
//  into :ls_dept,
//       :ls_grade,
//		 :ls_level,
//		 :ls_salary
//  from p1_master,
//       p0_dept,
//		 p0_grade,
//		 p0_level
// where p1_master.companycode = p0_dept.companycode (+) and
//       p1_master.gradecode = p0_grade.gradecode (+) and
//		 p1_master.levelcode = p0_level.levelcode (+) and
//		 p1_master.deptcode = p0_dept.deptcode (+) and
//		 p1_master.empno like :ls_name ;
//
String ls_lev_up
If uo_1.cbx_01.Checked = True Then
	ls_lev_up = "'001'"
End If

If uo_1.cbx_02.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'002'"
	Else
		ls_lev_up = ls_lev_up + ", '002'"
	End If
End If

If uo_1.cbx_03.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'003'"
	Else
		ls_lev_up = ls_lev_up + ", '003'"
	End If
End If

If uo_1.cbx_04.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'004'"
	Else
		ls_lev_up = ls_lev_up + ", '004'"
	End If
End If

If uo_1.cbx_05.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'005'"
	Else
		ls_lev_up = ls_lev_up + ", '005'"
	End If
End If

If uo_1.cbx_06.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'006'"
	Else
		ls_lev_up = ls_lev_up + ", '006'"
	End If
End If

If uo_1.cbx_07.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'007'"
	Else
		ls_lev_up = ls_lev_up + ", '007'"
	End If
End If

If uo_1.cbx_08.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'008'"
	Else
		ls_lev_up = ls_lev_up + ", '008'"
	End If
End If

If uo_1.cbx_09.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'009'"
	Else
		ls_lev_up = ls_lev_up + ", '009'"
	End If
End If

If uo_1.cbx_10.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'010'"
	Else
		ls_lev_up = ls_lev_up + ", '010'"
	End If
End If

If uo_1.cbx_11.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'011'"
	Else
		ls_lev_up = ls_lev_up + ", '011'"
	End If
End If

If uo_1.cbx_12.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'012'"
	Else
		ls_lev_up = ls_lev_up + ", '012'"
	End If
End If

If uo_1.cbx_13.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'013'"
	Else
		ls_lev_up = ls_lev_up + ", '013'"
	End If
End If

If uo_1.cbx_14.Checked = True Then
	If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
		ls_lev_up = "'014'"
	Else
		ls_lev_up = ls_lev_up + ", '014'"
	End If
End If

If Trim(ls_lev_up) = '' OR IsNull(ls_lev_up) Then
	ls_lev_up = "'001', '002', '003', '004', '005', '006', '007', '008', '009', '010', '011', '012', '013', '014'"
End If

String ls_gub, ls_sql, ls_sql1, ls_sql2, ls_sql3
ls_gub = dw_ip.GetItemString(1, 'gubun')

ls_sql = 'SELECT   "P1_MASTER"."EMPNO",' + &
		' "P1_MASTER"."EMPNAME",' + &   
		' "P1_ORDERS"."ORDERDATE",' + &       
		' P1_ORDERS.ORDERCODE,' + & 
		' "P0_ORDER"."ORDERNAME",' + & 
		' "P0_DEPT"."DEPTNAME" AS DNAME,' + &
		' "P0_GRADE"."GRADENAME",' + &
		' "P0_LEVEL"."LEVELNAME",' + &
		' "P1_ORDERS"."SALARY",' + & 
		' "P1_ORDERS"."BASEPAY",' + &       
		' "P1_ORDERS"."REMARK",' + &
		' DEPT.DEPTNAME,' + &
		' GRADE.GRADENAME,' + &
		' TLEVEL.LEVELNAME,' + &
		' P1_MASTER.SALARY,' + &
		' P1_MASTER.DEPTCODE AS DEPTCODE,' + &
		' P1_MASTER.LEVELCODE AS LEVELCODE' + &
' FROM "P1_MASTER",' + &   
	  ' "P0_DEPT",' + &   
	  ' "P0_GRADE",' + &   
	  ' "P0_LEVEL"  ,' + &
	  ' "P1_ORDERS",' + &   
	  ' "P0_ORDER",' + &  
	  '  P0_DEPT DEPT,' + &
	  '  P0_GRADE GRADE,' + &
	  ' P0_LEVEL TLEVEL' + &             
' WHERE   P1_MASTER.COMPANYCODE = P1_ORDERS.COMPANYCODE AND' + &
		'  P1_MASTER.EMPNO = P1_ORDERS.EMPNO AND' + & 
		' ( "P1_ORDERS"."DEPTCODE" = "P0_DEPT"."DEPTCODE"(+) ) and' + &
		' ( "P1_ORDERS"."GRADECODE" = "P0_GRADE"."GRADECODE"(+) ) and ' + &  
		' ( "P1_ORDERS"."LEVELCODE" = "P0_LEVEL"."LEVELCODE"(+) ) AND' + &
		'  P1_ORDERS.ORDERCODE = P0_ORDER.ORDERCODE(+)  AND' + &
		'  P1_MASTER.DEPTCODE= DEPT.deptcode(+) and' + &
		'  P1_MASTER.GRADECODE = GRADE.GRADECODE(+) AND' + &
		 " P1_MASTER.SAUPCD  like '"  + ls_saupcd + "' and " + &
		'  P1_MASTER.LEVELCODE = TLEVEL.LEVELCODE(+)'
If ls_gub = '2' Then
	ls_sql1 = ls_sql + " AND " + &
				  "P1_MASTER.COMPANYCODE = '" + gs_company + "' AND " + &
				  "P1_MASTER.EMPNO LIKE '" + ls_name + "' AND " + &
				  "P1_ORDERS.ORDERDATE >= '" + ls_date1 + "' AND " + &
				  "P1_ORDERS.ORDERDATE <= '" + ls_date2 + "' AND " + &
				  "P1_ORDERS.ORDERCODE LIKE '" + ls_code + "' AND P1_ORDERS.ORDERCODE IN (" + ls_lev_up + ")"
	dw_list.SetSQLSelect(ls_sql1)
	if dw_list.Retrieve() < 1 then
		messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
		return -1
	end if
	
	ls_sql2 = 'select a.empno, a.empname, ' + &
		' b.orderdate, b.ordercode, ' + &
		' d.ordername, e.deptname as dname, ' + &
		' f.gradename, g.levelname, ' + &
		' b.salary, b.basepay, b.remark, ' + &
      ' dept.deptname, ' + &
      ' grade.gradename, ' + &
      ' tlevel.levelname, ' + &
      ' a.salary, a.deptcode, a.levelcode ' + &
 ' from p1_master a, ' + &
		' p1_orders b, ' + &
		' ( select a1.companycode, a1.empno, a1.orderdate, max(a1.seq) as seq  ' + &
			 ' from p1_orders a1,  ' + &
		'			(select companycode, empno, max(orderdate) as orddate  ' + &
		'			from p1_orders  ' + &
		'			group by companycode, empno) ord1 ' + &
		'	where a1.companycode = ord1.companycode and ' + &
		'			a1.empno = ord1.empno and ' + &
		'			a1.orderdate = ord1.orddate ' + &
	'	group by a1.companycode, a1.empno, a1.orderdate) c, ' + &
	'	p0_order d, ' + &
	'	p0_dept e, ' + &
	'	p0_grade f, ' + &
	'	p0_level g, ' + &  
   '   p0_dept dept, ' + &
   '   p0_grade grade, ' + &
   '   p0_level tlevel ' + & 
' where a.companycode = b.companycode and ' + &
		' b.companycode = c.companycode and ' + &
		' a.empno = b.empno and ' + &
		' b.empno = c.empno and ' + &
		' b.orderdate = c.orderdate and ' + &
		' b.seq = c.seq and ' + &
      ' b.deptcode = e.deptcode(+) and ' + &
      ' b.gradecode = f.gradecode(+) and ' + &   
      ' b.levelcode = g.levelcode(+) and ' + &
      ' b.ordercode = d.ordercode(+) and ' + &
      ' a.deptcode= dept.deptcode(+) and ' + &  
      ' a.gradecode = grade.gradecode(+) and ' + &
      ' a.levelcode = tlevel.levelcode(+) and '	
	ls_sql3 = ls_sql2 + "a.companycode = '" + gs_company + "' and " + &
		"a.empno like '"  + ls_name + "' and " + &
		"c.orderdate >= '" + ls_date1 + "' and " + &
		"c.orderdate <= '" + ls_date2 + "' and " + &
		"b.ordercode like '" + ls_code + "' and " + &
		" a.SAUPCD  like '"  + ls_saupcd + "' and " + &
	    "  B.ORDERCODE IN (" + ls_lev_up + ")"
	dw_print.SetSQLSelect(ls_sql1)
	dw_print.Retrieve()
Else
	ls_sql1 = ls_sql + " AND " + &
				  "P1_MASTER.COMPANYCODE = '" + gs_company + "' AND " + &
				  "P1_MASTER.EMPNO LIKE '" + ls_name + "' AND " + &
				  "P1_ORDERS.ORDERDATE >= '" + ls_date1 + "' AND " + &
				  "P1_ORDERS.ORDERDATE <= '" + ls_date2 + "' AND " + &
				   " P1_MASTER.SAUPCD  like '"  + ls_saupcd + "' and " + &
				  "P1_ORDERS.ORDERCODE LIKE '" + ls_code + "'"
	dw_list.SetSQLSelect(ls_sql1)
	dw_print.SetSQLSelect(ls_sql1)
	if dw_list.Retrieve() < 1 then
		messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
		return -1
	Else
		dw_print.Retrieve()
	end if
	
//	if dw_print.retrieve(gs_company,ls_name,ls_date1, ls_date2, ls_code) < 1 then
//		messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
//		return -1
//	end if
	
//	dw_print.sharedata(dw_list)
End If

//dw_list.modify("d_dept.text = '"+ls_dept+"'")
//dw_list.modify("d_grade.text = '"+ls_grade+"'")
//dw_list.modify("d_level.text = '"+ls_level+"'")
//dw_list.modify("d_salary.text = '"+ls_salary+"'")
//
//cb_print.enabled = true
//
///* Last page 구하는 routine */
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
//
setpointer(arrow!)

return 1
end function

public subroutine wf_setting ();Long   ll_cnt

SELECT COUNT('X')
  INTO :ll_cnt
  FROM P0_ORDER ;
If ll_cnt < 1 Then Return

DECLARE LEV_UP CURSOR FOR
	SELECT ORDERCODE, ORDERNAME
	  FROM P0_ORDER ;
	  
OPEN LEV_UP;

String ls_ordercode
String ls_ordername
Long   i

For i = 1 To ll_cnt
	FETCH LEV_UP INTO :ls_ordercode, :ls_ordername;
	Choose Case ls_ordercode
		Case '001'
			uo_1.cbx_01.Text = ls_ordername
		Case '002'
			uo_1.cbx_02.Text = ls_ordername
		Case '003'
			uo_1.cbx_03.Text = ls_ordername
		Case '004'
			uo_1.cbx_04.Text = ls_ordername
		Case '005'
			uo_1.cbx_05.Text = ls_ordername
		Case '006'
			uo_1.cbx_06.Text = ls_ordername
		Case '007'
			uo_1.cbx_07.Text = ls_ordername
		Case '008'
			uo_1.cbx_08.Text = ls_ordername
		Case '009'
			uo_1.cbx_09.Text = ls_ordername
		Case '010'
			uo_1.cbx_10.Text = ls_ordername
		Case '011'
			uo_1.cbx_11.Text = ls_ordername
		Case '012'
			uo_1.cbx_12.Text = ls_ordername
		Case '013'
			uo_1.cbx_13.Text = ls_ordername
		Case '014'
			uo_1.cbx_14.Text = ls_ordername
	End Choose
Next

Close LEV_UP;
end subroutine

on wp_pif2103.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.rr_2=create rr_2
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.uo_1
end on

on wp_pif2103.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.rr_2)
destroy(this.uo_1)
end on

event open;call super::open;//dw_list.settransobject(sqlca)
dw_print.SetTransObject(sqlca)

dw_ip.object.dayto[1] = String(f_today())
dw_ip.object.dayfrom[1] = String(Left(String(f_today()),6) + "01") 

gb_1.visible = false
rb_1.visible = false
rb_2.visible = false
rb_3.visible = false

end event

type p_xls from w_standard_print`p_xls within wp_pif2103
end type

type p_sort from w_standard_print`p_sort within wp_pif2103
end type

type p_preview from w_standard_print`p_preview within wp_pif2103
integer x = 4059
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pif2103
integer x = 4407
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2103
integer x = 4233
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2103
integer x = 3886
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2103
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2103
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2103
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2103
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2103
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2103
integer x = 3936
integer y = 180
string dataobject = "dp_pif2103_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2103
integer x = 32
integer y = 40
integer width = 1856
integer height = 300
integer taborder = 40
string dataobject = "dp_pif2103_2"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
IF GetColumnName() = "empname" THEN
	Gs_Codename = GetItemString(this.GetRow(),"empname")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF

IF GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
END IF

end event

event dw_ip::itemchanged;call super::itemchanged;String sEmpNo,sEmpName, SetNull, sGubun,ls_name

AcceptText()
SetNull(SetNull)

IF GetColumnName() = "empno" THEN
	sEmpNo = GetItemString(1,"empno")

	IF sEmpNo= '' or isnull(sEmpNo) THEN
   	SetItem(1,"empno",SetNull)
 		SetITem(1,"empname",SetNull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"
				INTO :sEmpName
				FROM "P1_MASTER"
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
		 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!")
				 SetItem(1,"empno",SetNull)
				 SetItem(1,"empname",SetNull)
				 RETURN 1
			 END IF
   	      SetItem(1,"empname",sEmpName)
	END IF

END IF

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

//	  IF sEmpName = '' or isnull(sEmpName) THEN
//		  SetITem(1,"empno",SetNull)
//		  SetITem(1,"empname",SetNull)
//	  ELSE	
//			SELECT "P1_MASTER"."EMPNO"  
//				INTO :sEmpNo
//				FROM "P1_MASTER"  
//				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
//						( "P1_MASTER"."EMPNAME" = :sEmpName ) ;
//			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원명을 확인하세요!!") 
//				 SetITem(1,"empno",SetNull)
//				 SetITem(1,"empname",SetNull)
//				 RETURN 1 
//			 END IF
//				 SetITem(1,"empno",sEmpNo)
//				
//	 END IF
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

IF GetColumnName() = "gubun" THEN
	sGubun = GetText()
	choose case sGubun
		case '1'
			dw_print.DataObject = 'dp_pif2103_1_p'
			gb_1.visible = false
			rb_1.visible = false
			rb_2.visible = false
			rb_3.visible = false
			
			uo_1.Visible = False
			SetItem(row,'code',SetNull)
		case '2'
			dw_print.DataObject = 'dp_pif2103_2_p'
			gb_1.visible = false
			rb_1.visible = false
			rb_2.visible = false
			rb_3.visible = false
			
			uo_1.Visible = True
			wf_setting()
			SetItem(row,'code',SetNull)
		case '3'
			dw_print.DataObject = 'dp_pif2103_3_p'
			gb_1.visible = true
			rb_1.visible = true
			rb_2.visible = true
			rb_3.visible = true
			rb_1.checked = false
			rb_2.checked = false
			rb_3.checked = false
			
			uo_1.Visible = False
			SetItem(row,'code','001')
	end choose
	dw_print.SetTransObject(sqlca)
	SetItem(row,'empno',SetNull)
	SetItem(row,'empname',SetNull)
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2103
integer x = 55
integer y = 356
integer width = 4430
integer height = 2012
string dataobject = "dp_pif2103_1"
boolean border = false
end type

type rb_1 from radiobutton within wp_pif2103
integer x = 1952
integer y = 92
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "성명순"
end type

event clicked;string ls_sort
ls_sort = 'p1_master_empname'
dw_print.setsort(ls_sort)
dw_print.sort()
end event

type rb_2 from radiobutton within wp_pif2103
integer x = 1952
integer y = 152
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "부서순"
end type

event clicked;string ls_sort
ls_sort = 'deptcode'
dw_print.setsort(ls_sort)
dw_print.sort()
end event

type rb_3 from radiobutton within wp_pif2103
integer x = 1952
integer y = 208
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "직급순"
end type

event clicked;string ls_sort
ls_sort = 'levelcode'
dw_print.setsort(ls_sort)
dw_print.sort()
end event

type gb_1 from groupbox within wp_pif2103
integer x = 1929
integer y = 32
integer width = 480
integer height = 252
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "정렬"
end type

type rr_2 from roundrectangle within wp_pif2103
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 348
integer width = 4471
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

type uo_1 from uo_lev_up within wp_pif2103
boolean visible = false
integer x = 1888
integer y = 4
integer taborder = 50
end type

on uo_1.destroy
call uo_lev_up::destroy
end on

