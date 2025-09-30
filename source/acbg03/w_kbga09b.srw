$PBExportHeader$w_kbga09b.srw
$PBExportComments$과목별 예실차이 분석표
forward
global type w_kbga09b from w_standard_print
end type
type rr_1 from roundrectangle within w_kbga09b
end type
end forward

global type w_kbga09b from w_standard_print
integer x = 0
integer y = 0
string title = "과목별 예실차이 분석표 조회 및 출력"
rr_1 rr_1
end type
global w_kbga09b w_kbga09b

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_acc_mm, ls_dept_cd, ls_acc1f, ls_acc2f, ls_acc1t, ls_acc2t,& 
       snull, sqlfd1, sqlfd2, s_yesanname, ls_ye_gu
		 
SetNull(snull)

if dw_ip.GetRow() < 1 then return -1

if dw_ip.acceptText() = -1 then return -1

ls_saupj   = dw_ip.GetItemString(dw_ip.GetRow(), 'saupj')   // 사업장 
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_yy")   // 예산년도
ls_acc_mm  = dw_ip.Getitemstring(dw_ip.Getrow(),"acc_mm")   // 예산월
ls_ye_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"ye_gu")    // 예산구분

ls_acc1f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd1')  // 계정과목 from
ls_acc2f   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc2_cd1')  
ls_acc1t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc1_cd2')  // 계정과목 to
ls_acc2t   = dw_ip.GetItemSTring(dw_ip.GetRow(), 'acc2_cd2')  

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


if trim(ls_acc1f) = "" or IsNull(ls_acc1f) then ls_acc1f = "10000"
if trim(ls_acc2f) = "" or IsNull(ls_acc2f) then ls_acc2f = "00"

if trim(ls_acc1t) = "" or IsNull(ls_acc1t) then ls_acc1t = "89999"
if trim(ls_acc2t) = "" or IsNull(ls_acc2t) or ls_acc2t = '00' then ls_acc2t = "99"

if ls_acc1f > ls_acc1t then 
	MessageBox("확 인", "시작 예산과목이 종료 예산과목보다 ~r~r클 수 없습니다.!!")
   dw_ip.SetColumn('acc1_cd1')
	dw_ip.SetFocus()
	return -1
end if

dw_list.SetRedraw(false)
IF dw_print.Retrieve(ls_saupj, ls_acc_yy, ls_acc_mm, ls_ye_gu, &
                    ls_acc1f+ls_acc2f, ls_acc1t+ls_acc2t) < 1 then 
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

on w_kbga09b.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kbga09b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(), 'saupj', gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(), 'acc_yy', left(f_today(), 4))
dw_ip.SetItem(dw_ip.GetRow(), 'acc_mm', mid(f_today(), 5, 2))

dw_ip.SetColumn('saupj')
dw_ip.SetFocus()


end event

type p_preview from w_standard_print`p_preview within w_kbga09b
integer y = 12
integer taborder = 40
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbga09b
integer y = 12
integer taborder = 60
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbga09b
integer y = 12
integer taborder = 50
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kbga09b
integer y = 12
integer taborder = 20
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbga09b
end type



type dw_print from w_standard_print`dw_print within w_kbga09b
integer x = 3753
integer y = 32
string dataobject = "dw_kbga09b_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kbga09b
integer width = 2761
integer height = 192
integer taborder = 10
string dataobject = "dw_kbga09b_1"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd, ls_acc2_cd,sqlfd3,sqlfd4,&
       ls_ye_gu, get_ye_gu, s_sql, ls_acc1_cd2, ls_acc_mm

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

end event

event dw_ip::itemerror;return 1
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

type dw_list from w_standard_print`dw_list within w_kbga09b
integer x = 59
integer y = 228
integer width = 4544
integer height = 2072
integer taborder = 30
string title = "과목별 예실차이 분석표"
string dataobject = "dw_kbga09b_2"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kbga09b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 216
integer width = 4558
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

