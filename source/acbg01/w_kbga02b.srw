$PBExportHeader$w_kbga02b.srw
$PBExportComments$과목별 예산배정표 조회 출력
forward
global type w_kbga02b from w_standard_print
end type
type st_1 from statictext within w_kbga02b
end type
type rr_1 from roundrectangle within w_kbga02b
end type
end forward

global type w_kbga02b from w_standard_print
string title = "과목별 예산배정표 조회 출력"
st_1 st_1
rr_1 rr_1
end type
global w_kbga02b w_kbga02b

type variables
String s_saupjname,s_yesanname,s_deptname
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_ye_gu, ls_dept_cd, ls_acc1f, ls_acc1t, & 
       get_code1, get_code2, get_name, snull, sqlfd1, sqlfd2, ls_acc2f, ls_acc2t, &
		 ls_fdept_cd, ls_tdept_cd

if dw_ip.GetRow() < 1 then return -1

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')   // 사업장 
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")   // 예산년도
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")    // 예산구분

ls_acc1f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd1')  // 계정과목 from
ls_acc1t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd12')  // 계정과목 FROM
ls_acc2f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd2')  // 계정과목 TO
ls_acc2t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd22')  // 계정과목 to

ls_fdept_cd = dw_ip.GetItemString(dw_ip.GetRow(), 'fdept_cd')  // 부서범위 from
ls_tdept_cd = dw_ip.GetItemString(dw_ip.GetRow(), 'tdept_cd')  //부서범위 to

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

if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
   ls_ye_gu = "%"
ELSE
	SELECT "REFFPF"."RFNA1"  
   	INTO  :s_yesanname
   	FROM "REFFPF"  
   	WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
         	"REFFPF"."RFCOD" = 'AB'      and  
				"REFFPF"."RFCOD" <> '00' using sqlca ;
		if sqlca.sqlcode <> 0 then 
   		MessageBox("확 인", "예산구분 코드를 확인하십시오!!")		
			dw_ip.SetColumn('ye_gu')
			dw_ip.SetFocus()			
			return -1
		end if 
end if

if trim(ls_acc1f) = "" or IsNull(ls_acc1f) then
   ls_acc1f = "40000"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd1 
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1f ) using sqlca ;
   if sqlca.sqlcode <> 0  then
      MessageBox("확인","계정과목을 확인하십시요!")
		dw_ip.SetColumn('acc1_cd1')
		dw_ip.SetFocus()
		return -1
   end if
end if

if trim(ls_acc1t) = "" or IsNull(ls_acc1t) then
	ls_acc1t = '00'
End if

if trim(ls_acc2f) = "" or IsNull(ls_acc2f) then
   ls_acc2f = "99999"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc2f ) using sqlca ;
   if sqlca.sqlcode <> 0  then
      MessageBox("확인","계정과목을 확인하십시요.")
		return -1
   end if
end if

if trim(ls_acc2t) = "" or IsNull(ls_acc2t) or ls_acc2t = '00' then
	ls_acc2t = '99'
End if

if ls_acc1f+ls_acc1t > ls_acc2f+ls_acc2t then 
	MessageBox("확 인", "시작 예산과목이 종료 예산과목보다 ~r~r클 수 없습니다.!!")
   dw_ip.SetColumn('acc1_cd1')
	dw_ip.SetFocus()
	return 1
end if

if trim(ls_fdept_cd) = '' or IsNull(ls_fdept_cd) then
	ls_fdept_cd = '100000'
else
//   SELECT DISTINCT "KFE01OM0_VA"."DEPT_CD"  
//      INTO :get_code1 
//      FROM "KFE01OM0_VA"  
//      WHERE ( "KFE01OM0_VA"."DEPT_CD" = :ls_fdept_cd ) using sqlca ;
//   if sqlca.sqlcode = 0  then
//		dw_ip.SetItem(1,"fdept_cd",get_code1)
//	Else
//		MessageBox("확인", "부서범위를 확인하십시요!")
//		dw_ip.SetColumn('fdept_cd')
//		dw_ip.SetFocus()
//		return -1
//   end if
end if
	
if trim(ls_tdept_cd) = '' or IsNull(ls_tdept_cd) then
	ls_tdept_cd = '999999'
else
//   SELECT DISTINCT "KFE01OM0_VA"."DEPT_CD"  
//      INTO :get_code2
//      FROM "KFE01OM0_VA"  
//      WHERE ( "KFE01OM0_VA"."DEPT_CD" = :ls_tdept_cd ) using sqlca ;
//   if sqlca.sqlcode = 0  then
//		dw_ip.SetItem(1,"tdept_cd",get_code2)
//	Else
//      MessageBox("확인", "부서범위를 확인하십시요!")
//		dw_ip.SetColumn('tdept_cd')
//		dw_ip.SetFocus()
//		return -1
//   end if
end if

dw_list.SetRedraw(false)
IF dw_print.Retrieve(ls_saupj, ls_acc_yy, ls_ye_gu,ls_acc1f,ls_acc1t,ls_acc2f,ls_acc2t,ls_fdept_cd,ls_tdept_cd) < 1 THEN
   F_MessageChk(14, "")
	dw_ip.Setcolumn('saupj')
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)	
	Return -1
END IF

dw_print.ShareData(dw_list)
dw_list.SetRedraw(true)	

Return 1

end function

on w_kbga02b.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_kbga02b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'saupj', gs_saupj)
dw_ip.SetItem(1, 'acc_yy', left(f_today(), 4))

dw_ip.SetColumn("ye_gu")

dw_ip.setfocus()

end event

type p_preview from w_standard_print`p_preview within w_kbga02b
integer y = 8
integer taborder = 40
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbga02b
integer y = 8
integer taborder = 60
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbga02b
integer y = 8
integer taborder = 50
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga02b
integer y = 8
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbga02b
end type



type dw_print from w_standard_print`dw_print within w_kbga02b
string dataobject = "dw_kbga02_5_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga02b
integer x = 50
integer y = 12
integer width = 3680
integer height = 212
integer taborder = 10
string dataobject = "dw_kbga02b_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd1, &
       ls_ye_gu, get_ye_gu, s_sql, s_sql2, ls_acc1_cd2, get_code, get_name, &
		 ls_dept_cd, ls_acc1_cd12, ls_acc1_cd22

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


IF this.GetColumnName() ="acc1_cd12" THEN
	
	ls_acc1_cd1 = this.GetItemString(row, 'acc1_cd1')
	ls_acc1_cd12 = this.GetText()
	
	IF trim(ls_acc1_cd12) ="" OR IsNull(ls_acc1_cd12) THEN
		ls_acc1_cd12 = '00'
	END IF
		
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."YACC2_NM"
		INTO :s_sql, :s_sql2
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :ls_acc1_cd1||:ls_acc1_cd12 ;
	if sqlca.sqlcode = 0 then
		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1", s_sql2)
	else
		MessageBox("확 인","예산과목을 확인하세요.!!")
		dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd1", snull)
		dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd12", snull)
		dw_ip.SetItem(dw_ip.GetRow(),"acc1_name1",snull)						
		dw_ip.SetFocus()
		return 1 
	end if
END IF


IF this.GetColumnName() ="acc1_cd22" THEN
	ls_acc1_cd2 = this.GetItemString(row, 'acc1_cd2')
	ls_acc1_cd22 = this.GetText()
	
	IF trim(ls_acc1_cd22) ="" OR IsNull(ls_acc1_cd22) THEN
		ls_acc1_cd22 = '99'
	END IF
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."YACC2_NM"
		INTO :s_sql, :s_sql2
		FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :ls_acc1_cd2||:ls_acc1_cd22 ;
	if sqlca.sqlcode = 0 then
		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2", s_sql2)
	else
		MessageBox("확 인","예산과목을 확인하세요.!!")
		dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd2",snull)
		dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd22",snull)
		dw_ip.SetItem(dw_ip.GetRow(),"acc1_name2",snull)			
		dw_ip.SetFocus()
		return 1 
	end if
   if ls_acc1_cd1+ls_acc1_cd12 > ls_acc1_cd2+ls_acc1_cd22 then 
   	MessageBox("확 인", "시작 예산과목이 종료 예산과목보다 ~r~r클 수 없습니다.!!")
	   return 1
   end if
END IF


end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd1" THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd1")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd1", Left(gs_code,5))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd12", mid(gs_code,6,2))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name1", gs_codename)
	end if
end if

IF this.GetColumnName() = "acc1_cd2" THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd2")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd2", Left(gs_code,5))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd22", mid(gs_code,6,2))
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name2", gs_codename)
	end if
end if
dw_ip.Setfocus()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kbga02b
integer x = 59
integer y = 232
integer width = 4530
integer height = 2064
integer taborder = 30
string title = "과목별 예산배정표"
string dataobject = "dw_kbga02_5"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type st_1 from statictext within w_kbga02b
integer x = 4201
integer y = 160
integer width = 398
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "(단위 : 천원)"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kbga02b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 224
integer width = 4558
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

