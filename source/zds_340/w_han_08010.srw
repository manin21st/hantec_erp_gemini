$PBExportHeader$w_han_08010.srw
$PBExportComments$기간별 근태현황 집계표
forward
global type w_han_08010 from w_standard_print
end type
type rr_1 from roundrectangle within w_han_08010
end type
end forward

global type w_han_08010 from w_standard_print
string title = "기간별근태현황집계표"
rr_1 rr_1
end type
global w_han_08010 w_han_08010

type variables
string is_timegbn
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sStartYear,sEndYear, sabu
string sDeptcode,sempno

if dw_ip.Accepttext() = -1 then return -1

sStartYear = trim(dw_ip.GetItemString(1,"dayfrom"))
sEndYear   = trim(dw_ip.GetItemString(1,"dayto"))

sDeptcode   = trim(dw_ip.GetItemString(1,"deptcode"))
sempno   = trim(dw_ip.GetItemString(1,"empno"))

sabu = dw_ip.Getitemstring(1,'sabu')
if IsNull(sabu) or sabu = '' then sabu = '%'

IF sDeptcode = "" OR IsNull(sDeptcode) THEN	
	sDeptcode= '%'
END IF

IF sempno = "" OR IsNull(sempno) THEN	
	sempno= '%'
END IF

IF sStartYear = "" OR IsNull(sStartYear) THEN
	MessageBox("확 인","시작일자를 입력하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF

IF sEndYear = "" OR IsNull(sEndYear) THEN
	MessageBox("확 인","종료일자를 입력하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF

IF sStartYear > sEndYear THEN
	MessageBox("확 인","출력일자 범위를 확인하세요!!")
	dw_ip.SetColumn('dayfrom')
	dw_ip.SetFocus()
	Return -1
END IF


IF dw_print.Retrieve(sDeptcode,sStartYear,sEndYear, sempno, sabu, is_timegbn) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF
   dw_list.Retrieve(sDeptcode,sStartYear,sEndYear, sempno, sabu, is_timegbn)
Return 1
end function

on w_han_08010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_han_08010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_print.ShareDataOff()
dw_ip.SetItem(1,"dayfrom",String(gs_today))
dw_ip.SetItem(1,"dayto",String(gs_today))
dw_ip.SetColumn('dayfrom')
dw_ip.SetFocus()

f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd

is_timegbn = f_get_p0_syscnfg(8, '1')
end event

type p_xls from w_standard_print`p_xls within w_han_08010
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_08010
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_08010
end type

type p_exit from w_standard_print`p_exit within w_han_08010
end type

type p_print from w_standard_print`p_print within w_han_08010
boolean visible = false
integer x = 3054
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_08010
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event

type st_window from w_standard_print`st_window within w_han_08010
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_han_08010
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_han_08010
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_han_08010
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_han_08010
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_han_08010
string dataobject = "d_han_08010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_08010
integer x = 169
integer y = 28
integer width = 2318
string dataobject = "d_han_08010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, ls_date, ls_name

AcceptText()

IF GetColumnName() = "empno" then
  sEmpNo = GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"empno",SetNull)
		  SetITem(1,"empname",SetNull)
	  ELSE
		  String ls_dept
		  SELECT DEPTCODE
		    INTO :ls_dept
			 FROM P1_MASTER
			WHERE EMPNO = :sEmpNo;
		  If ls_dept <> '30060' Then
		     MessageBox('부서확인', '부서가 "생산팀(2)"인 사원만 조회 가능합니다.')
			  This.SetItem(row, 'empno', '')
			  Return 1
		  End If
		  IF f_chk_saupemp(sEmpNo, '1', is_saupcd) = False THEN
			  SetItem(getrow(),'empno',SetNull)
			  SetColumn('empno')
			  dw_ip.SetFocus()
			  Return 1
		  END IF			
		
			 SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원번호를 확인하세요!!") 
//				 SetITem(1,"empno",SetNull)
//				 SetITem(1,"empname",SetNull)
//				 RETURN 1 
//			 END IF
				SetITem(1,"empname",sEmpName  )
				
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



IF GetColumnName() = "deptcode" then
  sDeptCode = GetItemString(1,"deptcode")

	  IF sDeptCode = '' or isnull(sDeptCode) THEN
		  SetITem(1,"deptcode",SetNull)
		  SetITem(1,"deptname",SetNull)
	  ELSE
		  IF f_chk_saupemp(sDeptCode, '2', is_saupcd) = False THEN
			  SetItem(getrow(),'deptcode',SetNull)
			  SetColumn('deptcode')
			  dw_ip.SetFocus()
			  Return 1
		  END IF
		  
		 SELECT "P0_DEPT"."DEPTNAME"  
			INTO :sDeptName
			FROM "P0_DEPT"  
		  WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				  ( "P0_DEPT"."DEPTCODE" = :sDeptCode ); 
			 
//			 IF SQLCA.SQLCODE<>0 THEN
//				 MessageBox("확 인","사원번호를 확인하세요!!") 
//				 SetITem(1,"deptcode",SetNull)
//				 SetITem(1,"deptname",SetNull)
//				 RETURN 1 
//			 END IF
				SetITem(1,"deptname",sDeptName  )
				
	 END IF
END IF


IF GetColumnName() = "sabu" THEN
	is_saupcd = this.GetText()
END IF


IF this.GetcolumnName() ="dayfrom" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'dayfrom',SetNull)
		SetColumn('dayfrom')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF


IF this.GetcolumnName() ="dayto" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "출력일자가 부정확합니다.")
		SetItem(getrow(),'dayto',SetNull)
		SetColumn('dayto')
		dw_ip.SetFocus()
		Return 1
	END IF
	ls_date = this.GetItemString(this.GetRow(), 'dayfrom')
	IF long(data) < long(ls_date) THEN
		MessageBox("확 인", "출력일자 범위가 부정확합니다.")
		SetItem(getrow(),'dayto',SetNull)
		SetColumn('dayto')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_Gubun)

AcceptText()
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	
	Gs_Gubun = is_saupcd
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	String ls_dept
   SELECT DEPTCODE
	  INTO :ls_dept
	  FROM P1_MASTER
	 WHERE EMPNO = :Gs_code;
   If ls_dept <> '30060' Then
	   MessageBox('부서확인', '부서가 "생산팀(2)"인 사원만 조회 가능합니다.')
		This.SetItem(row, 'empno', '')
	   Return 1
   End If
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF

//SetNull(Gs_code)
//SetNull(Gs_codename)
//SetNull(Gs_gubun)
//
//AcceptText()
//IF GetColumnName() = "deptcode" THEN
//	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
//	
//	Gs_gubun = is_saupcd
//	open(w_dept_saup_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	
//	SetItem(this.GetRow(),"deptcode",Gs_code)
//	SetItem(this.GetRow(),"deptname",Gs_codeName)
//	
//END IF
//
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_han_08010
integer x = 187
integer y = 320
integer width = 4224
string dataobject = "d_han_08010_002"
boolean border = false
end type

type rr_1 from roundrectangle within w_han_08010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 178
integer y = 312
integer width = 4242
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

