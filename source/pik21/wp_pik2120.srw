$PBExportHeader$wp_pik2120.srw
$PBExportComments$**당직(휴근)현황
forward
global type wp_pik2120 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pik2120
end type
end forward

global type wp_pik2120 from w_standard_print
integer width = 4667
string title = "당직(휴일)근무현황"
rr_2 rr_2
end type
global wp_pik2120 wp_pik2120

type variables
string ls_dkdeptcode, is_timegbn
int li_level
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_retrieve ()
end prototypes

public subroutine wf_reset ();
end subroutine

public function integer wf_retrieve ();String ls_yymm

if dw_ip.Accepttext() = -1 then return -1

ls_yymm = trim(dw_ip.GetItemString(1,"yymm"))


IF ls_yymm = "" OR IsNull(ls_yymm) THEN
	MessageBox("확 인","출력년월을 입력하세요!!")
	dw_ip.SetColumn('yymm')
	dw_ip.SetFocus()
	Return -1
END IF


IF dw_print.Retrieve(is_saupcd, ls_yymm) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF
  
Return 1

end function

on wp_pik2120.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pik2120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"yymm", left(f_today(),6))
dw_ip.SetColumn('yymm')
dw_ip.SetFocus()

f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd



end event

type p_preview from w_standard_print`p_preview within wp_pik2120
end type

type p_exit from w_standard_print`p_exit within wp_pik2120
end type

type p_print from w_standard_print`p_print within wp_pik2120
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pik2120
end type

type st_window from w_standard_print`st_window within wp_pik2120
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pik2120
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pik2120
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pik2120
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pik2120
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pik2120
string dataobject = "dp_pik2120_2_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pik2120
integer x = 78
integer y = 24
integer width = 2953
integer height = 160
integer taborder = 20
string dataobject = "dp_pik2120_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String  SetNull,sDeptCode,sDeptName

AcceptText()

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


IF GetColumnName() = "saupcd" THEN
	is_saupcd = this.GetText()
	if IsNull(is_saupcd) or is_saupcd = '' then is_saupcd = '%'
END IF

IF this.GetcolumnName() ="yymm" THEN
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data + '01') = -1 THEN
		MessageBox("확 인", "출력년월이 부정확합니다.")
		SetItem(getrow(),'yymm',SetNull)
		SetColumn('yymm')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_Gubun)

AcceptText()
IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	
	Gs_Gubun = is_saupcd
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	
END IF
end event

type dw_list from w_standard_print`dw_list within wp_pik2120
integer x = 87
integer y = 204
integer width = 4411
integer height = 2056
string dataobject = "dp_pik2120_2"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pik2120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 200
integer width = 4439
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

