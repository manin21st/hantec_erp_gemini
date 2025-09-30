$PBExportHeader$wp_pif2108.srw
$PBExportComments$** 사원명부(사용)
forward
global type wp_pif2108 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pif2108
end type
type rb_1 from radiobutton within wp_pif2108
end type
type rb_2 from radiobutton within wp_pif2108
end type
type rb_3 from radiobutton within wp_pif2108
end type
type rb_4 from radiobutton within wp_pif2108
end type
type st_4 from statictext within wp_pif2108
end type
type rr_2 from roundrectangle within wp_pif2108
end type
end forward

global type wp_pif2108 from w_standard_print
integer x = 0
integer y = 0
string title = "사원명부"
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
st_4 st_4
rr_2 rr_2
end type
global wp_pif2108 wp_pif2108

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_name1, ls_name2, ls_gubun,sJikJong, sKunmu, sSaup
String GetMinEmpno,GetMaxEmpno,GetMinEmpname,GetMaxEmpname, ArgBuf

IF dw_ip.AcceptText() = -1 THEN return -1

ls_name1 = dw_ip.GetItemString(1,"empno1")
ls_name2 = dw_ip.GetItemString(1,"empno2")
ls_gubun = trim(left(dw_ip.GetItemString(1,"cond"), 1))
sJikJong = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu	= dw_ip.GetItemString(1,"KUNMU")
sSaup = trim(dw_ip.GetItemString(1,"saup"))

dw_list.Reset()

IF isnull(ls_name1) or ls_name1 = '' THEN
	SELECT MIN(P1_MASTER.EMPNO)
	 INTO:GetMinEmpno
	 FROM P1_MASTER  ;
  
  SELECT P1_MASTER.EMPNAME
	  INTO :GetMinEmpname
	  FROM  P1_MASTER
	  WHERE P1_MASTER.EMPNO = :GetMinEmpno ;
     ls_name1 = GetMinEmpno
ELSE
    GetMinEmpname = dw_ip.GetITemString(1,"empname1")
END IF

IF isnull(ls_name2) or ls_name2 = '' then 
	SELECT MAX(P1_MASTER.EMPNO)
	  INTO:GetMaxEmpno
	 FROM P1_MASTER  ;
	 
	SELECT P1_MASTER.EMPNAME
	  INTO :GetMaxEmpname
	  FROM  P1_MASTER
	  WHERE P1_MASTER.EMPNO = :GetMaxEmpno ;
	
	ls_name2 = GetMaxEmpno
ELSE
	GetMaxEmpname = dw_ip.GetITemString(1,"empname2")
END IF

if ls_name1 > ls_name2 then
	messagebox("범위 확인", "입력 범위가 부정확합니다.!", information!)
	dw_ip.SetColumn("empno")
	dw_ip.SetFocus()
	return -1
end if

//if isnull(ls_gubun) or ls_gubun = '' then
//	messagebox("출력조건", "출력 조건을 확인하세요.!", information!)
//	return -1
//end if

dw_print.modify("startempname.text = '"+ GetMinEmpname +"'")
dw_print.modify("endempname.text = '"+ GetMaxEmpname +"'")

IF ls_gubun = '' or isnull(ls_gubun) THEN ls_gubun = '%'	

IF sJikJong = '' or isnull(sJikJong) THEN
	sJikJong = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :sJikJong);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '' OR IsNull(sKunmu) THEN
	sKunmu = '%'
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF


if dw_print.retrieve(ls_name1, ls_name2, left(ls_gubun, 1), sJikJong, sKunmu, sSaup) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.SetColumn("empno")
	dw_ip.SetFocus()
	return -1
end if

dw_print.sharedata(dw_list)

//IF rb_1.checked THEN
//	dw_print.setsort("1A")
//   dw_print.sort()
//   dw_print.modify("stitle.text = '"+"(사원번호순)"+"'")
//ELSEIF rb_2.checked THEN
//	dw_print.setsort("2A")
//	dw_print.sort()	
//   dw_print.modify("stitle.text = '"+"(성명순)"+"'")
//ELSEIF rb_3.checked THEN	 
//	dw_print.setsort("6A")
//	dw_print.sort()	
//   dw_print.modify("stitle.text = '"+"(입사일자순)"+"'")
//ELSE	 
//	dw_print.setsort("5A")
//	dw_print.sort()	
//   dw_print.modify("stitle.text = '"+"(소속부서순)"+"'")
//END IF


setpointer(arrow!)

return 1
end function

on wp_pif2108.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.st_4=create st_4
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.rr_2
end on

on wp_pif2108.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.st_4)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd



end event

type p_preview from w_standard_print`p_preview within wp_pif2108
integer x = 4078
integer y = 20
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pif2108
integer x = 4434
integer y = 20
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2108
integer x = 4256
integer y = 20
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2108
integer x = 3899
integer y = 20
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2108
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2108
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2108
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2108
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2108
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2108
integer x = 3639
integer y = 44
integer width = 123
integer height = 132
boolean enabled = false
string dataobject = "dp_pif2108_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2108
integer x = 375
integer y = 4
integer width = 2437
integer height = 288
integer taborder = 70
string dataobject = "dw_pif2108ret"
end type

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF dw_ip.GetColumnName() = "empno1"  THEN

  gs_code = dw_ip.GetItemString(1,"empno1")

  open(w_employee_saup_popup)

  if isnull(gs_code) or gs_code = '' then return

	dw_ip.SetITem(1,"empno1",gs_code)
	dw_ip.SetITem(1,"empname1",gs_codename)
ELSEIF dw_ip.GetColumnName() = "empno2"  THEN
	
  gs_code = dw_ip.GetItemString(1,"empno2")

  open(w_employee_saup_popup)

  if isnull(gs_code) or gs_code = '' then return

	dw_ip.SetITem(1,"empno2",gs_code)
	dw_ip.SetITem(1,"empname2",gs_codename)
		
END IF
end event

event dw_ip::itemchanged;call super::itemchanged;String sEmpNo,sEmpName,SetNull,sColName1,sColName2, ls_name,sEmpCode

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


sColName1 = GetColumnName()

IF sColName1 = "empno1" or sColName1 = "empno2" THEN
	
	IF sColName1 = "empno1" THEN sColName2 = "empname1"
	IF sColName1 = "empno2" THEN sColName2 = "empname2"
	
	sEmpCode = GetItemString(1,sColName1)

	IF sEmpCode = "" OR ISNULL(sEmpCode) THEN
		SetItem(1,sColName2,"")
		Return 1
	ELSE
		SELECT "P1_MASTER"."EMPNAME"  
		  INTO :sEmpName  
		  FROM "P1_MASTER"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpCode ) ; 
   	IF SQLCA.SQLCODE <> 0  THEN
			 MessageBox("확인" ,"사원코드를 확인하세요!") 
		    SetItem(1,sColName1,"")
			 SetItem(1,sColName2,"")
			 Return 1
		END IF
		    SetItem(1,sColName2,sEmpName) 
	END IF

END IF

IF sColName1 = "empname1" or sColName1 = "empname2" THEN
	
	IF sColName1 = "empname1" THEN sColName2 = "empno1"
	IF sColName1 = "empname2" THEN sColName2 = "empno2"
	
	sEmpName = GetItemString(1,sColName1)

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,sColName1,ls_name)
		 Setitem(1,sColName2,ls_name)
		 return 2
    end if
	 Setitem(1,sColName2,ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,sColName1,ls_name)
	 return 1
	

END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2108
integer x = 389
integer y = 308
integer width = 3442
integer height = 1948
string dataobject = "dp_pif2108"
boolean hscrollbar = false
boolean border = false
end type

type rr_1 from roundrectangle within wp_pif2108
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2825
integer y = 8
integer width = 736
integer height = 276
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within wp_pif2108
integer x = 2848
integer y = 100
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "사원번호"
boolean checked = true
end type

event clicked;//dw_list.setsort("1A")
//dw_list.sort()
//dw_print.modify("stitle.text = '"+"(사원번호순)"+"'")

dw_list.Dataobject = "dp_pif2108"
dw_list.SetTransobject(sqlca)
dw_print.Dataobject = "dp_pif2108_p"
dw_print.SetTransobject(sqlca)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within wp_pif2108
integer x = 3205
integer y = 100
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "성    명"
end type

event clicked;//dw_list.setsort("2A")
//dw_list.sort()
//dw_list.modify("stitle.text = '"+"(성명순)"+"'")
dw_list.Dataobject = "dp_pif2108_1"
dw_list.SetTransobject(sqlca)
dw_print.Dataobject = "dp_pif2108_1_p"
dw_print.SetTransobject(sqlca)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within wp_pif2108
integer x = 2848
integer y = 196
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "입사일자"
end type

event clicked;//dw_list.setsort("6A")
//dw_list.sort()
//dw_list.modify("stitle.text = '"+"(입사일자순)"+"'")
dw_list.Dataobject = "dp_pif2108_2"
dw_list.SetTransobject(sqlca)
dw_print.Dataobject = "dp_pif2108_2_p"
dw_print.SetTransobject(sqlca)

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_4 from radiobutton within wp_pif2108
integer x = 3205
integer y = 196
integer width = 320
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "부서코드"
end type

event clicked;//dw_list.setsort("5A")
//dw_list.sort()
//dw_list.modify("stitle.text = '"+"(소속부서순)"+"'")
dw_list.Dataobject = "dp_pif2108_3"
dw_list.SetTransobject(sqlca)
dw_print.Dataobject = "dp_pif2108_3_p"
dw_print.SetTransobject(sqlca)

p_retrieve.TriggerEvent(Clicked!)
end event

type st_4 from statictext within wp_pif2108
integer x = 3058
integer y = 32
integer width = 261
integer height = 44
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "정    렬"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within wp_pif2108
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 379
integer y = 304
integer width = 3465
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

