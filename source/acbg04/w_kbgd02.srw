$PBExportHeader$w_kbgd02.srw
$PBExportComments$월별 예산 총괄표(전체)
forward
global type w_kbgd02 from w_standard_print
end type
end forward

global type w_kbgd02 from w_standard_print
integer x = 0
integer y = 0
string title = "월별 예산 총괄표(전체)  조회 및 출력"
end type
global w_kbgd02 w_kbgd02

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_acc_mm, ls_dept_cd, ls_acc1f, ls_acc1t, & 
       snull, sqlfd1, sqlfd2, s_yesanname, ls_ye_gu,sDeptCode
		 
SetNull(snull)

if dw_ip.GetRow() < 1 then return -1

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')   // 사업장 
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")   // 예산년도
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")    // 예산구분

ls_acc1f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd1')  // 계정과목 from
ls_acc1t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd2')  // 계정과목 to

sDeptCode  = dw_ip.GetItemSTring(dw_ip.GetRow(), 'dept')

IF trim(ls_saupj) = '' or isnull(ls_saupj) THEN
	F_MessageChk(1, "[사업장]")
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   return -1 
END IF

if trim(ls_acc_yy) = '' or isnull(ls_acc_yy) then 
	F_MessageChk(1, "[예산년도]")
	dw_ip.SetColumn('acc_yy')
	dw_ip.SetFocus()	
	return -1
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

IF IsNull(sDeptCode) OR sDeptCode = "" THEN sDeptCode = '%'

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

dw_list.SetRedraw(false)

if dw_list.Retrieve(ls_saupj, ls_acc_yy, ls_ye_gu, &
                    ls_acc1f, ls_acc1t,sDeptCode) < 1 then 
   F_MessageChk(14, "")
	
	dw_ip.SetColumn('saupj')
	dw_ip.Setfocus()
   dw_list.SetRedraw(true)	
	return -1
end if

dw_list.SetRedraw(true)	

return 1

end function

on w_kbgd02.create
call super::create
end on

on w_kbgd02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(), 'saupj',    gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(), 'acc_yy',   left(f_today(), 4))

dw_ip.SetItem(dw_ip.GetRow(), 'dept',     Gs_Dept)
dw_ip.SetItem(dw_ip.GetRow(), 'deptname', F_Get_PersonLst('3',Gs_Dept,'1'))

dw_ip.SetColumn('saupj')
dw_ip.SetFocus()

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("dept.protect = 0")
//	dw_ip.Modify("dept.background.color =16777215")		
ELSE
	dw_ip.Modify("dept.protect = 1")
//	dw_ip.Modify("dept.background.color ='"+String(RGB(192,192,192))+"'")			
END IF

end event

type p_preview from w_standard_print`p_preview within w_kbgd02
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_kbgd02
integer taborder = 60
end type

type p_print from w_standard_print`p_print within w_kbgd02
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbgd02
integer taborder = 20
end type







type st_10 from w_standard_print`st_10 within w_kbgd02
end type



type dw_print from w_standard_print`dw_print within w_kbgd02
end type

type dw_ip from w_standard_print`dw_ip within w_kbgd02
integer x = 27
integer width = 3227
integer height = 216
integer taborder = 10
string dataobject = "dw_kbgd02_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd1, &
       ls_ye_gu, get_ye_gu, s_sql, ls_acc1_cd2, ls_acc_mm,sDeptCode,sDeptName, ls_gubun

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

IF this.GetColumnName() = "dept" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(dw_ip.GetRow(),"deptname",snull)
		Return
	END IF
	
	sDeptName = F_Get_PersonLst('10',sDeptCode,'%')
	IF IsNull(sDeptName) THEN
		F_MessageChk(20,'[예산부서]')
		this.SetItem(dw_ip.GetRow(),"dept",snull)
		this.SetItem(dw_ip.GetRow(),"deptname",snull)
		Return 1
	ELSE
		this.SetItem(dw_ip.GetRow(),"deptname",sDeptName)
	END IF
END IF

if this.GetColumnName() = 'gubun' then 
   ls_gubun = this.Gettext()
   IF ls_gubun = '1' THEN  //기본대비//
	   dw_list.dataObject='dw_kbga11_2'
   else                    //실행대비//
   	dw_list.dataObject='dw_kbga11_3'	
   END IF
	dw_list.SetRedraw(True)
   dw_list.SetTransObject(SQLCA)
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

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

type dw_list from w_standard_print`dw_list within w_kbgd02
integer y = 256
integer height = 1996
integer taborder = 30
string title = "월별 예산 총괄표"
string dataobject = "dw_kbgd02_2"
end type

