$PBExportHeader$w_kbgc01.srw
$PBExportComments$부서별 예산사용명세서 조회 출력
forward
global type w_kbgc01 from w_standard_print
end type
type rr_1 from roundrectangle within w_kbgc01
end type
end forward

global type w_kbgc01 from w_standard_print
integer x = 0
integer y = 0
string title = "부서별 예산사용명세서 조회 출력"
rr_1 rr_1
end type
global w_kbgc01 w_kbgc01

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_datef,ls_acc_datet, ls_acc1_cd, ls_acc2_cd, ls_dept_cd, &
       sqlfd, sqlfd2, get_code, get_name, snull
long   rowno


SetNull(snull)

SetPointer(HourGlass!)
dw_ip.AcceptText()

ls_saupj      = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_datef  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_date")
ls_acc_datet  = dw_ip.Getitemstring(dw_ip.Getrow(),"date_to")
ls_acc1_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd")
ls_acc2_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"acc2_cd")
ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"cdept_cd")

////코드검사
if ls_saupj = "" or IsNull(ls_saupj) then	
else
  SELECT "REFFPF"."RFGUB"  
   INTO  :sqlfd
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_saupj and
         "REFFPF"."RFCOD" = 'AD' using sqlca ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","사업장코드를 확인하십시오!")
      return -1
   end if
end if
If ls_saupj = '99' then ls_saupj = '%'   

//배정부서 선택항목으로 변경(0412)
If isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
	ls_dept_cd = '%'
End If

if ls_acc1_cd = ""  or IsNull(ls_acc1_cd) then
   ls_acc1_cd = '%'; 
	ls_acc2_cd = "%";
else
	if ls_acc2_cd = "" OR IsNull(ls_acc2_cd) then
		ls_acc2_cd = "%";
	else
	  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
       INTO :sqlfd, :sqlfd2
       FROM "KFZ01OM0"  
      WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
            "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
      if sqlca.sqlcode <> 0 then
         messagebox("확인","계정과목을 확인하십시오!")
         return -1
     end if
	end if
end if


if f_datechk(ls_acc_datef) = -1 then
   messagebox("확인","회계일자를 확인하십시오!")
   return -1
end if
if f_datechk(ls_acc_datet) = -1 then
   messagebox("확인","회계일자를 확인하십시오!")
   return -1
end if
if ls_acc_datef > ls_acc_datet then
   messagebox("확인","회계일자범위를 확인하십시오!")
   return -1
end if

rowno = dw_print.Retrieve(ls_saupj,ls_acc1_cd,ls_acc2_cd,ls_dept_cd,ls_acc_datef,ls_acc_datet)

if rowno = 0 then
   messagebox("확인","조회할 자료가 없습니다!")
   dw_ip.SetFocus()
   return -1
end if

dw_print.ShareData(dw_list)
Return 1

end function

on w_kbgc01.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kbgc01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;print_gu ="DOUBLE"

dw_list.SetTransObject(SQLCA)

dw_ip.Setitem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"cdept_cd",gs_dept)
dw_ip.Setitem(dw_ip.Getrow(),"acc_date", f_today())
dw_ip.Setitem(dw_ip.Getrow(),"date_to", f_today())

dw_ip.SetColumn("acc1_cd")
dw_ip.SetFocus()


IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("cdept_cd.protect = 0")
//	dw_ip.Modify("cdept_cd.background.color ='"+String(RGB(255,255,255))+"'")			
ELSE
	dw_ip.Modify("cdept_cd.protect = 1")
//	dw_ip.Modify("cdept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
END IF


end event

type p_preview from w_standard_print`p_preview within w_kbgc01
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_kbgc01
integer taborder = 60
end type

type p_print from w_standard_print`p_print within w_kbgc01
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbgc01
integer taborder = 20
end type

type st_window from w_standard_print`st_window within w_kbgc01
integer x = 2363
end type

type sle_msg from w_standard_print`sle_msg within w_kbgc01
integer x = 384
end type

type dw_datetime from w_standard_print`dw_datetime within w_kbgc01
integer width = 754
end type

type st_10 from w_standard_print`st_10 within w_kbgc01
integer width = 347
end type



type dw_print from w_standard_print`dw_print within w_kbgc01
string dataobject = "dw_kbgc01_4_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbgc01
integer y = 32
integer width = 2816
integer height = 208
integer taborder = 10
string dataobject = "dw_kbgc01_1"
end type

event dw_ip::itemchanged;string ls_acc1_cd, ls_acc2_cd, sqlfd3, sqlfd4, ls_dept_cd, get_code
Int rowno

dw_ip.Accepttext()
rowno = dw_ip.Getrow()
if rowno = 1 then
   ls_acc1_cd = dw_ip.Getitemstring(rowno,"acc1_cd")
   ls_acc2_cd = dw_ip.Getitemstring(rowno,"acc2_cd")
end if

if Isnull(ls_acc2_cd) or ls_acc2_cd ="" then
	ls_acc2_cd = '00'
end if
//계정과목명 표시//
  SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    INTO :sqlfd3, :sqlfd4
    FROM "KFZ01OM0"  
   WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
         "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
  if sqlca.sqlcode = 0 then
     dw_ip.Setitem(dw_ip.Getrow(),"accname",sqlfd3 + " - " + sqlfd4)
  else
     dw_ip.Setitem(dw_ip.Getrow(),"accname"," ")
  end if
    
//배정부서 선택항목변경에 따른 수정(0412)
if this.GetColumnName() = 'cdept_cd' then
	
	ls_dept_cd = this.GetText()
	
	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
		return 
		
	else
		SELECT "KFE03OM0"."DEPTCODE"  	INTO :get_code
			FROM "KFE03OM0"  
			WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;

		if sqlca.sqlcode = 0 then 	
			this.SetItem(dw_ip.GetRow(), 'cdept_cd', get_code)
		end if 
	end if
end if
end event

event dw_ip::rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() <> "acc1_cd" THEN RETURN

dw_ip.AcceptText()
gs_code = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd"))
IF IsNull(gs_code) then
	gs_code =""
end if

Open(W_KFE01OM0_POPUP)
if gs_code <> "" and Not IsNull(gs_code) then
   dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", Left(gs_code,5))
   dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd", Mid(gs_code,6,2))
   dw_ip.SetItem(dw_ip.GetRow(), "accname", gs_codename)
end if

dw_ip.Setfocus()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kbgc01
integer x = 69
integer y = 256
integer width = 4517
integer height = 2052
integer taborder = 30
string dataobject = "dw_kbgc01_4"
boolean border = false
end type

type rr_1 from roundrectangle within w_kbgc01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 244
integer width = 4553
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

