$PBExportHeader$w_sys_001_mdi_sheet_03.srw
$PBExportComments$User-Id Print
forward
global type w_sys_001_mdi_sheet_03 from w_standard_print
end type
end forward

global type w_sys_001_mdi_sheet_03 from w_standard_print
integer height = 2440
end type
global w_sys_001_mdi_sheet_03 w_sys_001_mdi_sheet_03

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	sDept, sfremp, stoemp		

if dw_ip.accepttext() = -1 	then	return -1

setpointer(hourglass!)

sDept = dw_ip.getitemstring(1, 's_dept')
sFrEmp = dw_ip.getitemstring(1, 's_fremp')
sToEmp = dw_ip.getitemstring(1, 's_toemp')

if isnull(sdept) 	or	trim(sdept) = ''		then sDept = '%'

if isnull(sfremp) or	trim(sFremp) = ''		then sfremp = '.'

if isnull(stoemp) or	trim(stoemp) = ''		then stoemp	= 'ZZZZZZZZZZZZZZZZZZZZ'

IF stoemp < sfremp THEN
   MessageBox("확인","사번 범위를 확인하세요!")
	dw_ip.SetColumn('s_fremp')
	dw_ip.SetFocus()
	Return 1
End If
	
//////////////////////////////////////////////////////////////////////////////
if dw_list.Retrieve(sdept, sfremp, stoemp) = 0 then
   MessageBox("확인","출력자료가 없습니다!")
	dw_ip.SetColumn('s_dept')
	dw_ip.SetFocus()
//	cb_print.Enabled =False
	SetPointer(Arrow!)
	Return 1
END IF

//cb_print.Enabled =True

/* Last page 구하는 routine */
long Li_row = 1, Ll_prev_row

dw_print.setredraw(false)
// dw_print.object.datawindow.print.preview="yes"

gi_page = 1

do while true
	ll_prev_row = Li_row
	Li_row = dw_print.ScrollNextPage()
	If Li_row = ll_prev_row or Li_row <= 0 then
		exit
	Else
		gi_page++
	End if
loop

dw_print.scrolltorow(1)
dw_print.setredraw(true)
setpointer(arrow!)

return 1
end function

on w_sys_001_mdi_sheet_03.create
call super::create
end on

on w_sys_001_mdi_sheet_03.destroy
call super::destroy
end on

type p_preview from w_standard_print`p_preview within w_sys_001_mdi_sheet_03
end type

type p_exit from w_standard_print`p_exit within w_sys_001_mdi_sheet_03
end type

type p_print from w_standard_print`p_print within w_sys_001_mdi_sheet_03
end type

type p_retrieve from w_standard_print`p_retrieve within w_sys_001_mdi_sheet_03
end type







type st_10 from w_standard_print`st_10 within w_sys_001_mdi_sheet_03
end type



type dw_print from w_standard_print`dw_print within w_sys_001_mdi_sheet_03
string dataobject = "d_sys_001_mdi_sheet_03_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sys_001_mdi_sheet_03
integer width = 1902
integer height = 244
string dataobject = "d_sys_001_mdi_sheet_03_1"
end type

event dw_ip::itemchanged;call super::itemchanged;STRING sempno,sempnm,snull,sget_name,sdptno

setnull(snull)

IF this.GetColumnName() ="s_dept" THEN
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(1,"s_deptnm",snull)
		RETURN
	END IF
	
  SELECT "P0_DEPT"."DEPTNAME"  
    INTO :sget_name  
    FROM "P0_DEPT"  
   WHERE "P0_DEPT"."DEPTCODE" = :sdptno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_deptnm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"s_dept",snull)
			this.SetItem(1,"s_deptnm",snull)
		END IF
		
		Return 1	
	END IF
ELSEIF this.GetColumnName() ="s_fremp" THEN
	sempno = this.GetText()
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"s_frnm",snull)
		RETURN
	END IF

  SELECT EMPNAME
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNO" = :sempno   ;
   
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_frnm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_fremp",snull)
			this.SetItem(1,"s_frnm",snull)
		END IF
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_frnm" THEN
	sempnm = this.GetText()
	IF sempnm ="" OR IsNull(sempnm) THEN 
		this.SetItem(1,"s_fremp",snull)
		RETURN
	END IF

  SELECT EMPNO
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNAME" = :sempnm   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_fremp",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_fremp",snull)
			this.SetItem(1,"s_frnm",snull)
		END IF
		
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_toemp" THEN
	sempno = this.GetText()
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"s_tonm",snull)
		RETURN
	END IF

  SELECT EMPNAME
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNO" = :sempno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_tonm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_toemp",snull)
			this.SetItem(1,"s_tonm",snull)
		END IF
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_tonm" THEN
	sempnm = this.GetText()
	IF sempnm ="" OR IsNull(sempnm) THEN 
		this.SetItem(1,"s_toemp",snull)
		RETURN
	END IF

  SELECT EMPNO
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNAME" = :sempnm   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_toemp",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_toemp",snull)
			this.SetItem(1,"s_tonm",snull)
		END IF
		
		Return 1
	END IF
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "s_dept" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_dept", gs_Code)
	this.SetItem(1, "s_deptnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_fremp" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_fremp", gs_Code)
	this.SetItem(1, "s_frnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_frnm" THEN
		
	gs_codename = this.GetItemString(1,"s_frnm")
	IF IsNull(gs_codename) THEN 
		gs_codename =""
	END IF
	
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_fremp", gs_Code)
	this.SetItem(1, "s_frnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_toemp" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_toemp", gs_Code)
	this.SetItem(1, "s_tonm", gs_Codename)
ELSEIF this.GetColumnName() = "s_tonm" THEN
		
	gs_codename = this.GetItemString(1,"s_tonm")
	IF IsNull(gs_codename) THEN 
		gs_codename =""
	END IF
	
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_toemp", gs_Code)
	this.SetItem(1, "s_tonm", gs_Codename)
END IF

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sys_001_mdi_sheet_03
integer y = 264
integer height = 2044
string dataobject = "d_sys_001_mdi_sheet_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

