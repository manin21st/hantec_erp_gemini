$PBExportHeader$w_kbga02.srw
$PBExportComments$부서별 예산배정표 조회 출력
forward
global type w_kbga02 from w_standard_print
end type
type st_1 from statictext within w_kbga02
end type
type rr_1 from roundrectangle within w_kbga02
end type
end forward

global type w_kbga02 from w_standard_print
string title = "부서별 예산배정표 조회 출력"
st_1 st_1
rr_1 rr_1
end type
global w_kbga02 w_kbga02

type variables
String s_saupjname,s_yesanname,s_deptname
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_ye_gu, ls_dept_cd, ls_acc1f, ls_acc1t, & 
       get_code, get_name, snull, sqlfd1, sqlfd2, sempno

if dw_ip.acceptText() = -1 then return -1
if dw_ip.GetRow() < 1 then return -1

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")
ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"dept_cd")
ls_acc1f   = dw_ip.GetItemString(dw_ip.GetRow(), 'acc1_cd1')
ls_acc1t   = dw_ip.GetItemString(dw_ip.GetRow(), 'acc1_cd2')

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
				"REFFPF"."RFCOD" <> '00' ;
		if sqlca.sqlcode <> 0 then 
   		MessageBox("확 인", "예산구분 코드를 확인하십시오!!")		
			dw_ip.SetColumn('ye_gu')
			dw_ip.SetFocus()			
			return -1
		end if 
end if

// 배정부서
if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
	ls_dept_cd = '%'
else
	SELECT "KFE03OM0"."DEPTCODE"  	INTO :get_code
		FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
	IF Sqlca.Sqlcode <> 0 then 	
	   F_MessageChk(20,'[배정부서]')						
		dw_ip.SetItem(1, 'dept_cd', snull)
		return 1
	end if 
end if

if trim(ls_acc1f) = "" or IsNull(ls_acc1f) then
   ls_acc1f = "40000"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd1 
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1f ) ;
   if sqlca.sqlcode <> 0  then
      ls_acc1f = "40000"
   end if
end if

if trim(ls_acc1t) = "" or IsNull(ls_acc1t) then
   ls_acc1t = "99999"
else
   SELECT DISTINCT "KFZ01OM0"."ACC1_CD"  
      INTO :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1t ) ;
   if sqlca.sqlcode <> 0  then
      ls_acc1t = "99999"
   end if
end if

if ls_acc1f > ls_acc1t then 
	MessageBox("확 인", "시작 예산과목이 종료 예산과목보다 ~r~r클 수 없습니다.!!")
   dw_ip.SetColumn('acc1_cd1')
	dw_ip.SetFocus()
	return -1
end if

dw_list.SetRedraw(false)
IF dw_print.Retrieve(ls_saupj, ls_acc_yy, ls_ye_gu, ls_dept_cd, ls_acc1f, ls_acc1t) < 1 THEN
	MessageBox("확 인","조회한 자료가 없습니다.!!")
	dw_ip.SetColumn('saupj')	
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)	
	Return -1
END IF
dw_print.ShareData(dw_list)
dw_list.SetRedraw(true)	
Return 1
end function

on w_kbga02.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_kbga02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'saupj',  gs_saupj)
dw_ip.SetItem(1, 'acc_yy', left(f_today(), 4))

dw_ip.SetItem(1, 'dept_cd',Gs_Dept)

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("dept_cd.protect = 0")
//	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(255,255,255))+"'")		
ELSE
	dw_ip.Modify("dept_cd.protect = 1")
//	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

dw_ip.SetColumn("ye_gu")

dw_ip.setfocus()

end event

type p_preview from w_standard_print`p_preview within w_kbga02
integer y = 0
integer taborder = 40
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbga02
integer y = 0
integer taborder = 60
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbga02
integer y = 0
integer taborder = 50
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga02
integer y = 0
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbga02
end type



type dw_print from w_standard_print`dw_print within w_kbga02
string dataobject = "dw_kbga02_4_P"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga02
integer x = 46
integer width = 3223
integer height = 204
integer taborder = 10
string dataobject = "dw_kbga02_1"
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
	if isnull(ls_ye_gu) then 
	else
    SELECT "REFFPF"."RFGUB"
    INTO :get_ye_gu
    FROM "REFFPF" 
	 WHERE "REFFPF"."RFCOD" = 'AB'   AND   
          "REFFPF"."RFGUB" = :ls_ye_gu AND   
			 "REFFPF"."RFGUB" <> '00';  
	end if
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
			WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd  AND
			      "KFE03OM0"."USETAG" = '1' ;    //usetag = '1':사용  '2':사용불가 //

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

event dw_ip::itemerror;Return 1
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

type dw_list from w_standard_print`dw_list within w_kbga02
integer x = 64
integer y = 224
integer width = 4526
integer height = 2088
integer taborder = 30
string title = "부서별 예산배정표"
string dataobject = "dw_kbga02_4"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type st_1 from statictext within w_kbga02
integer x = 4206
integer y = 164
integer width = 402
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

type rr_1 from roundrectangle within w_kbga02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 220
integer width = 4558
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

