$PBExportHeader$w_kbga10.srw
$PBExportComments$부서별 예실비교표
forward
global type w_kbga10 from w_standard_print
end type
type rr_1 from roundrectangle within w_kbga10
end type
end forward

global type w_kbga10 from w_standard_print
integer x = 0
integer y = 0
string title = "부서별 예실비교표 조회 및 출력"
boolean maxbox = true
rr_1 rr_1
end type
global w_kbga10 w_kbga10

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_acc_mm, ls_dept_cd, ls_acc1f, ls_acc1t, & 
       get_code, get_name, snull, sqlfd1, sqlfd2, s_yesanname, ls_ye_gu, &
		 get_yy_q, ls_yy_q, ls_yy_q_pre, ls_mm_pre, ls_yy_pre

if dw_ip.GetRow() < 1 then return -1

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')   // 사업장 
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")   // 예산년도
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")   // 예산월
ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")  // 배정부서
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")    // 예산구분

ls_acc1f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd1')  // 계정과목 from
ls_acc1t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd2')  // 계정과목 to


IF trim(ls_saupj) = '' or isnull(ls_saupj) THEN
	F_MessageChk(1, "[사업장]")
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   return -1 
ELSE
	IF ls_saupj = '99' THEN ls_saupj = '%'
END IF

if trim(ls_acc_yy) = '' or isnull(ls_acc_yy) then 
	F_MessageChk(1, "[예산년도]")
	dw_ip.SetColumn('acc_yy')
	dw_ip.SetFocus()	
	return -1
end if

if trim(ls_acc_mm) = '' or isnull(ls_acc_mm) then 
	F_MessageChk(1, "[예산월]")
	dw_ip.SetColumn('acc_mm')
	dw_ip.SetFocus()	
	return -1
else
	
	if ls_acc_mm < '01' or ls_acc_mm > '12' then 
		MessageBox("확 인", "예산월 범위를 벗어났습니다.(01~~12)!!")
		return -1
	end if
end if

if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
else
  SELECT "REFFPF"."RFNA1"  
   INTO  :s_yesanname
   FROM "REFFPF"  
   WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
         "REFFPF"."RFCOD" = 'AB' and   
         "REFFPF"."RFCOD" <> '00' using sqlca ;  
   if sqlca.sqlcode <> 0 then
      messagebox("확인","예산구분코드를 확인하십시오!")
      dw_ip.SetFocus()
      return -1
   end if
end if

//배정부서 선택항목으로 변경(0412)
If isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
	ls_dept_cd = '%'
End If

if trim(ls_acc1f) = "" or IsNull(ls_acc1f) then
   ls_acc1f = "10000"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd1 
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1f ) using sqlca ;
   if sqlca.sqlcode <> 0  then
      ls_acc1f = "10000"
	else
		ls_acc1f = sqlfd1
   end if
end if

if trim(ls_acc1t) = "" or IsNull(ls_acc1t) then
   ls_acc1t = "89999"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1t ) using sqlca ;
   if sqlca.sqlcode <> 0  then
      ls_acc1t = "89999"
	else
		ls_acc1t = sqlfd2
   end if
end if

if ls_acc1f > ls_acc1t then 
	MessageBox("확 인", "시작 예산과목이 종료 예산과목보다 ~r~r클 수 없습니다.!!")
   dw_ip.SetColumn('acc1_cd1')
	dw_ip.SetFocus()
	return -1
end if

  // 당해년도 분기
  SELECT DISTINCT "KFE01OM0"."QUARTER"  
    INTO :get_yy_q   
    FROM "KFE01OM0"  
	 WHERE "KFE01OM0"."SAUPJ" = :ls_saupj   AND 
          "KFE01OM0"."ACC_YY" = :ls_acc_yy AND 
         "KFE01OM0"."ACC_MM"  = :ls_acc_mm 	 ;
	if sqlca.sqlcode <> 0 or isnull(get_yy_q) then 
		ls_yy_q = '0'
	else
		ls_yy_q = get_yy_q
   end if
// 당해년도 전분기
if ls_yy_q = '1' then
	ls_yy_q_pre = '0'
else
	ls_yy_q_pre = string(integer(ls_yy_q) - 1 )
end if

// 당해년도 전월
if ls_acc_mm = '01' then
	ls_mm_pre = '00'
else
	ls_mm_pre = string(integer(ls_acc_mm) - 1, '00')
end if

// 전년도 
ls_yy_pre = string(long(ls_acc_yy) - 1 )


dw_print.SetRedraw(false)

//기본조건 (2 줄)
// 당해년도 분기, 전분기, 전월, 전년도 
IF dw_print.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, &
                    ls_dept_cd, ls_acc1f, ls_acc1t, &
						  ls_yy_q, ls_yy_q_pre, ls_mm_pre, ls_yy_pre) < 1 then 
	f_message_chk(50, '')
	dw_print.Reset()
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   dw_print.SetRedraw(true)
	Return -1
END IF

dw_print.ShareData(dw_list)

dw_print.SetRedraw(true)	

return 1
end function

on w_kbga10.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kbga10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'saupj', gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(), 'acc_yy', left(f_today(), 4))
dw_ip.SetItem(dw_ip.GetRow(), 'acc_mm', mid(f_today(), 5, 2))
dw_ip.SetItem(dw_ip.Getrow(), 'dept_cd',Gs_Dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("dept_cd.protect = 0")
//	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(255,255,255))+"'")		
ELSE
	dw_ip.Modify("dept_cd.protect = 1")
//	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
END IF
dw_ip.Setcolumn("acc_mm")
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kbga10
integer y = 12
integer taborder = 40
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbga10
integer y = 12
integer taborder = 60
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbga10
integer y = 12
integer taborder = 50
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga10
integer y = 12
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbga10
end type



type dw_print from w_standard_print`dw_print within w_kbga10
integer x = 3781
integer y = 28
string dataobject = "dw_kbga10_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga10
integer width = 3666
integer height = 192
integer taborder = 10
string dataobject = "dw_kbga10_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd1, &
       ls_ye_gu, get_ye_gu, s_sql, ls_acc1_cd2, get_code, get_name, &
		 ls_dept_cd, ls_acc_mm

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
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :ls_saupj and 
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

if this.GetColumnName() = 'acc_mm' then
	ls_acc_mm = this.GetText()
	if trim(ls_acc_mm) = '' or isnull(ls_acc_mm) then 
		F_MessageChk(1, "[회계월]")
		return 1
	end if
	if ls_acc_mm < '01' or ls_acc_mm > '12' then 
		MessageBox("확 인", "회계월 범위를 벗어났습니다.(01~~12)!!")
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
	if sqlca.sqlcode = 0 and isnull(get_ye_gu) = false then 
	   return 
	else 
		MessageBox("확 인", "예산구분 코드를 확인하십시오!!")		
		this.SetItem(1, 'ye_gu', snull)
		return 1
	end if
end if 	

//배정부서 선택항목변경에 따른 수정(0412)
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
		end if 
	end if
end if

//// 배정부서
//if this.GetColumnName() = 'dept_cd' then
//	
//	ls_dept_cd = this.GetText()
//	
//	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
//		return 
//		
//	else
//		SELECT "KFE03OM0"."DEPTCODE"  	INTO :get_code
//			FROM "KFE03OM0"  
//			WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
//
//		if sqlca.sqlcode = 0 then 	
//			this.SetItem(dw_ip.GetRow(), 'dept_cd', get_code)
//		else
//         F_MessageChk(20,'[예산부서]')						
//			this.SetItem(dw_ip.GetRow(), 'dept_cd', snull)
//			return 1
//		end if 
//	end if
//end if


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
      	return 1 
  		end if
	END IF
END IF


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

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kbga10
integer x = 69
integer y = 220
integer width = 4507
integer height = 2084
integer taborder = 30
string title = "부서별 예실비교표"
string dataobject = "dw_kbga10_2"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kbga10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 212
integer width = 4535
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

