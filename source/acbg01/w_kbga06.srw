$PBExportHeader$w_kbga06.srw
$PBExportComments$예산계획서조회출력-미승인예산자료포함
forward
global type w_kbga06 from w_standard_print
end type
type rr_1 from roundrectangle within w_kbga06
end type
end forward

global type w_kbga06 from w_standard_print
integer x = 0
integer y = 0
string title = "예산계획서 조회 및 출력"
rr_1 rr_1
end type
global w_kbga06 w_kbga06

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_ye_gu, ls_dept_cd, ls_acc1_cdf,ls_acc1_cdt, ls_acc2_cd, &
       sqlfd, s_yesanname, ls_acc_yy_pre, get_code, get_name, snull
		 
SetNull(snull)

SetPointer(HourGlass!)

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(), "acc_yy")

ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")
ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")

ls_acc1_cdf   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd1")
ls_acc1_cdt   = dw_ip.Getitemstring(dw_ip.Getrow(),"acc1_cd2")

IF trim(ls_saupj) = '' or isnull(ls_saupj) THEN  
   F_MessageChk(1, "[사업장]")
	dw_ip.setColumn('saupj')
	dw_ip.SetFocus()
	return -1 
else 
	SELECT "REFFPF"."RFNA1"  
		INTO  :sabu_nm
   	FROM "REFFPF"  
   	WHERE "REFFPF"."RFGUB" = :ls_saupj and "REFFPF"."RFCOD" = 'AD' ;
	if sqlca.sqlcode <> 0 then
		messagebox("확인","사업장을 확인하십시오!")
		dw_ip.SetFocus()
		return -1
   end if
	IF ls_saupj = '99' THEN ls_saupj = '%'

END IF

if trim(ls_acc_yy) = '' or isnull(ls_acc_yy) then 
	F_MessageChk(1, "[회계년도]")
	dw_ip.setColumn('acc_yy')
	dw_ip.SetFocus()
	return -1 
end if

if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
else
  SELECT "REFFPF"."RFNA1"  
   INTO  :s_yesanname
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and "REFFPF"."RFCOD" = 'AB' ;  
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산구분을 확인하십시오!")
      dw_ip.SetFocus()
      return -1
   end if
end if

if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
	ls_dept_cd = "%"
else
	SELECT "KFE03OM0"."DEPTCODE"  	INTO :get_code
			FROM "KFE03OM0"  
			WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
	if sqlca.sqlcode <> 0 then 	
		F_MessageChk(41, "[배정부서]")									
		dw_ip.SetItem(dw_ip.GetRow(), 'dept_cd', snull)
		dw_ip.SetColumn('dept_cd')
		dw_ip.SetFocus()
		return -1
	end if 
end if


if trim(ls_acc1_cdf) = "" or IsNull(ls_acc1_cdf) then
   ls_acc1_cdf = "40000"
else
   SELECT "KFZ01OM0"."ACC1_NM"  
      INTO :sqlfd 
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cdf ) using sqlca ;
   if sqlca.sqlcode = 0 or sqlca.sqlcode = -1 then 
   else
      ls_acc1_cdf = "40000"
   end if
end if

if trim(ls_acc1_cdt) = "" or IsNull(ls_acc1_cdt) then
   ls_acc1_cdt = "99999"
else
   SELECT "KFZ01OM0"."ACC1_NM"  
      INTO :sqlfd
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cdt ) using sqlca ;
   if sqlca.sqlcode = 0 or sqlca.sqlcode = -1 then
   else
      ls_acc1_cdt = "99999"
   end if
end if

ls_acc_yy_pre = string(long(ls_acc_yy) - 1, '0000') 

dw_list.SetRedraw(false)

if dw_print.retrieve(ls_saupj, ls_acc_yy, ls_acc_yy_pre, ls_ye_gu, &
                 ls_dept_cd, ls_acc1_cdf, ls_acc1_cdt) < 1 then
   F_MessageChk(14, "")		
   dw_list.SetRedraw(true)	
	return -1
end if

dw_print.ShareData(dw_list)
dw_list.SetRedraw(true)	
return 1

end function

on w_kbga06.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kbga06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1, 'saupj',   gs_saupj)
dw_ip.SetItem(1, 'acc_yy',  left(f_today(), 4))
dw_ip.SetItem(1, 'dept_cd', gs_dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("dept_cd.protect = 0")
//	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(255,255,255))+"'")		
ELSE
	dw_ip.Modify("dept_cd.protect = 1")
//	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

dw_ip.SetFocus()


end event

type p_preview from w_standard_print`p_preview within w_kbga06
integer y = 16
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbga06
integer y = 16
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbga06
integer y = 16
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga06
integer y = 16
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbga06
end type



type dw_print from w_standard_print`dw_print within w_kbga06
integer x = 3557
string dataobject = "dw_kbga06_2_P"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_kbga06
integer y = 12
integer width = 3191
integer height = 228
integer taborder = 10
string dataobject = "dw_kbga06_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd1, &
       ls_ye_gu, get_ye_gu, s_sql, ls_acc1_cd2, get_code, get_name, &
		 ls_dept_cd

SetNull(snull)

if this.GetColumnName() = 'saupj' then 
	
   ls_saupj    = this.GetText()
	
	if trim(ls_saupj) = '' or isnull(ls_saupj) then 
      F_MessageChk(1, "[사업장]")		
		return 1
	end if
	
	SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD'      AND  
         "REFFPF"."RFGUB" = :ls_saupj AND 
			"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      Messagebox("확 인","사업장코드를 확인하십시오")
      this.SetItem(row, "saupj", snull)
      return 1
   end if
	
end if

if this.GetColumnName() = 'acc_yy' then
	
	ls_acc_yy = this.GetText()
	
	if isnull(ls_acc_yy) or trim(ls_acc_yy) = '' then
      F_MessageChk(1, "[회계년도]")				
   	return 1
	end if
	
end if

	
if this.GetcolumnName() = 'ye_gu' then 
	ls_ye_gu = this.GetText()
	if isnull(ls_ye_gu) or trim(ls_ye_gu) = '' then 
		return
	end if
    SELECT "REFFPF"."RFGUB"
    INTO :get_ye_gu
    FROM "REFFPF" 
	 WHERE "REFFPF"."RFCOD" = 'AB'   AND   
          "REFFPF"."RFGUB" = :ls_ye_gu AND   
			 "REFFPF"."RFGUB" <> '00';  
	if sqlca.sqlcode <> 0 then 
		MessageBox("확 인", "예산구분 코드를 확인하십시오!!")		
		this.SetItem(1, 'ye_gu', snull)
		return 1
	end if
end if 	


IF this.GetColumnName() ="acc1_cd1" THEN
	
	ls_acc1_cd1 = this.GetText()
	
	IF trim(ls_acc1_cd1) ="" OR IsNull(ls_acc1_cd1) THEN
		return 
	ELSE
		
		SELECT DISTINCT "KFZ01OM0"."ACC1_NM"
    		INTO :s_sql
    		FROM "KFZ01OM0"  
   		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd1 ;
  		if sqlca.sqlcode = 0 then
     		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1", s_sql)
  		else
     		MessageBox("확 인","계정과목을 확인하세요.!!")
			dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd1", snull)
      	dw_ip.SetFocus()
      	return 1 
  		end if
	END IF
END IF

IF this.GetColumnName() ="acc1_cd2" THEN
	ls_acc1_cd2 = this.GetText()
	
	IF trim(ls_acc1_cd2) ="" OR IsNull(ls_acc1_cd2) THEN
		return 
	ELSE
		SELECT DISTINCT "KFZ01OM0"."ACC1_NM"
    		INTO :s_sql
    		FROM "KFZ01OM0"  
   		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd2 ;
  		if sqlca.sqlcode = 0 then
     		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2",s_sql)
  		else
     		MessageBox("확 인","계정과목을 확인하세요.!!")
			dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd2",snull)
      	dw_ip.SetFocus()
      	return 1 
  		end if
	END IF
END IF

// 배정부서
if this.GetColumnName() = 'dept_cd' then
	
	ls_dept_cd = this.GetText()
	
	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
		return 
	else
		SELECT "KFE03OM0"."DEPTCODE"  	INTO :get_code
			FROM "KFE03OM0"  
			WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;

		if sqlca.sqlcode = 0 then 	
			this.SetItem(dw_ip.GetRow(), 'dept_cd', get_code)
		else
         F_MessageChk(20,'[예산부서]')						
			this.SetItem(dw_ip.GetRow(), 'dept_cd', snull)
			return 1
		end if 
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd1"  THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd1")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd1", Left(gs_code,5))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name1", gs_codename)
	end if
end if

IF this.GetColumnName() = "acc1_cd2"  THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd2")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd2", Left(gs_code,5))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name2", gs_codename)
	end if
end if
dw_ip.Setfocus()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kbga06
integer x = 64
integer y = 252
integer width = 4530
integer height = 2040
integer taborder = 30
string title = "예산계획서"
string dataobject = "dw_kbga06_2"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kbga06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 240
integer width = 4567
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

