$PBExportHeader$w_kbga11.srw
$PBExportComments$월별 예산 총괄표
forward
global type w_kbga11 from w_standard_print
end type
type st_1 from statictext within w_kbga11
end type
type rr_1 from roundrectangle within w_kbga11
end type
end forward

global type w_kbga11 from w_standard_print
integer x = 0
integer y = 0
string title = "월별 예산 총괄표  조회 및 출력"
st_1 st_1
rr_1 rr_1
end type
global w_kbga11 w_kbga11

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_acc_mm, ls_dept_cd, ls_acc1f, ls_acc2f,ls_acc1t,ls_acc2t, & 
       snull, sqlfd1, sqlfd2, s_yesanname, ls_ye_gu,sDeptCode
		 
SetNull(snull)

if dw_ip.GetRow() < 1 then return -1

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')   // 사업장 
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")   // 예산년도
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")    // 예산구분

ls_acc1f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd1')  // 계정과목 from
ls_acc2f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc2_cd1')  
ls_acc1t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd2')  // 계정과목 to
ls_acc2t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc2_cd2')  

sDeptCode  = dw_ip.GetItemSTring(dw_ip.GetRow(), 'dept')

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


if trim(ls_acc1f) = "" or IsNull(ls_acc1f) then ls_acc1f = "40000"
if trim(ls_acc2f) = "" or IsNull(ls_acc2f) then ls_acc2f = "00"

if trim(ls_acc1t) = "" or IsNull(ls_acc1t) then ls_acc1t = "99999"
if trim(ls_acc2t) = "" or IsNull(ls_acc2t) or ls_acc2t = '00' then ls_acc2t = "99"

if ls_acc1f > ls_acc1t then 
	MessageBox("확 인", "시작 예산과목이 종료 예산과목보다 ~r~r클 수 없습니다.!!")
   dw_ip.SetColumn('acc1_cd1')
	dw_ip.SetFocus()
	return -1
end if

dw_list.SetRedraw(false)

IF dw_print.Retrieve(ls_saupj, ls_acc_yy, ls_ye_gu, &
                    ls_acc1f+ls_acc2f, ls_acc1t+ls_acc2t,sDeptCode) < 1 then 
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.SetRedraw(true)	

return 1

end function

on w_kbga11.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_kbga11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(), 'saupj',    gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(), 'acc_yy',   left(f_today(), 4))

dw_ip.SetItem(dw_ip.GetRow(), 'dept',     Gs_Dept)
dw_ip.SetItem(dw_ip.GetRow(), 'deptname', F_Get_PersonLst('3',Gs_Dept,'1'))
dw_ip.SetItem(dw_ip.GetRow(), 'gubun',    '1')

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

type p_preview from w_standard_print`p_preview within w_kbga11
integer taborder = 40
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbga11
integer taborder = 60
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbga11
integer taborder = 50
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga11
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbga11
end type



type dw_print from w_standard_print`dw_print within w_kbga11
string dataobject = "dw_kbga11_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga11
integer x = 50
integer width = 3433
integer height = 280
integer taborder = 10
string dataobject = "dw_kbga11_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd, ls_acc2_cd,sqlfd3,sqlfd4,&
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
if this.GetColumnName() = 'acc1_cd1' then 
	ls_acc1_cd = this.GetText()
	IF trim(ls_acc1_cd) = "" OR IsNull(ls_acc1_cd) THEN 
		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1",snull)
		Return
	END IF
	
	ls_acc2_cd = this.Getitemstring(this.Getrow(),"acc2_cd1")

	//계정과목명 표시//
	  SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."YACC2_NM"   
		 INTO :sqlfd3, :sqlfd4
		 FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
				"KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
	  if sqlca.sqlcode = 0 then
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1", sqlfd3+'-'+sqlfd4)
	  else
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1",snull)
	  end if
end if

if this.GetColumnName() = 'acc2_cd1' then 
	ls_acc2_cd = this.GetText()
   IF ls_acc2_cd = "" OR IsNull(ls_acc2_cd) THEN ls_acc2_cd = '00'
	
	ls_acc1_cd = this.Getitemstring(this.Getrow(),"acc1_cd1")

	//계정과목명 표시//
	  SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."YACC2_NM"   
		 INTO :sqlfd3, :sqlfd4
		 FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
				"KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
	  if sqlca.sqlcode = 0 then
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1", sqlfd3+'-'+sqlfd4)
	  else
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name1",snull)
	  end if
end if

if this.GetColumnName() = 'acc1_cd2' then 
	ls_acc1_cd = this.GetText()
	IF trim(ls_acc1_cd) = "" OR IsNull(ls_acc1_cd) THEN 
		dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2",snull)
		Return
	END IF
	
	ls_acc2_cd = this.Getitemstring(this.Getrow(),"acc2_cd2")

	//계정과목명 표시//
	  SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."YACC2_NM"   
		 INTO :sqlfd3, :sqlfd4
		 FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
				"KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
	  if sqlca.sqlcode = 0 then
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2", sqlfd3+'-'+sqlfd4)
	  else
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2",snull)
	  end if
end if

if this.GetColumnName() = 'acc2_cd2' then 
	ls_acc2_cd = this.GetText()
	 IF ls_acc2_cd = "" OR IsNull(ls_acc2_cd) THEN ls_acc2_cd = '00'
	
	ls_acc1_cd = this.Getitemstring(this.Getrow(),"acc1_cd2")

	//계정과목명 표시//
	  SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."YACC2_NM"   
		 INTO :sqlfd3, :sqlfd4
		 FROM "KFZ01OM0"  
		WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd and
				"KFZ01OM0"."ACC2_CD" = :ls_acc2_cd ;
	  if sqlca.sqlcode = 0 then
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2", sqlfd3+'-'+sqlfd4)
	  else
		  dw_ip.Setitem(dw_ip.Getrow(),"acc1_name2",snull)
	  end if
end if

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
	   dw_print.dataObject='dw_kbga11_2_p'
   else                    //실행대비//
   	dw_list.dataObject='dw_kbga11_3'	
	   dw_print.dataObject='dw_kbga11_3_p'
   END IF
	dw_list.SetRedraw(True)
   dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() = "acc1_cd1" THEN 

	dw_ip.AcceptText()
	gs_code = dw_ip.GetItemString(dw_ip.GetRow(), "acc1_cd1")
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd1", Left(gs_code,5))
		dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd1", Right(gs_code,2))
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
		dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd2", Right(gs_code,2))		
   	dw_ip.SetItem(dw_ip.GetRow(), "acc1_name2", gs_codename)
	end if
end if

dw_ip.Setfocus()

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kbga11
integer x = 73
integer y = 308
integer width = 4503
integer height = 1996
integer taborder = 30
string title = "월별 예산 총괄표"
string dataobject = "dw_kbga11_2"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type st_1 from statictext within w_kbga11
integer x = 4183
integer y = 240
integer width = 416
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

type rr_1 from roundrectangle within w_kbga11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 300
integer width = 4539
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

