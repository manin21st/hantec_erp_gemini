$PBExportHeader$wp_pip3090.srw
$PBExportComments$** 개인별소급현황
forward
global type wp_pip3090 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pip3090
end type
type em_ym from editmask within wp_pip3090
end type
type rb_1 from radiobutton within wp_pip3090
end type
type rb_2 from radiobutton within wp_pip3090
end type
type st_1 from statictext within wp_pip3090
end type
type st_2 from statictext within wp_pip3090
end type
type dw_1 from datawindow within wp_pip3090
end type
type ln_1 from line within wp_pip3090
end type
type dw_2 from datawindow within wp_pip3090
end type
type rr_2 from roundrectangle within wp_pip3090
end type
end forward

global type wp_pip3090 from w_standard_print
string title = "개인별소급현황"
rr_1 rr_1
em_ym em_ym
rb_1 rb_1
rb_2 rb_2
st_1 st_1
st_2 st_2
dw_1 dw_1
ln_1 ln_1
dw_2 dw_2
rr_2 rr_2
end type
global wp_pip3090 wp_pip3090

forward prototypes
private function string wf_checkdeptno (string sDeptno)
public function string wf_adddate (string sdate)
public function integer wf_retrieve ()
end prototypes

private function string wf_checkdeptno (string sDeptno);  string sName 
	
	IF sDeptno = "" OR IsNull(sDeptno) THEN
		//return ''
	ELSE	
		SELECT  "P0_DEPT"."DEPTNAME"  
			INTO :sName  
			FROM "P0_DEPT"  
			WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
					( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
			if sqlca.sqlcode<>0 then
				MessageBox("확 인","부서번호를 확인하세요!!") 
				 return ''  
			end if	
			    return sName 
			
	END IF		












end function

public function string wf_adddate (string sdate);String sGet_Ym,sGet_Ym1,sGet_Ym10,sGet_Ym11, & 
       sGet_Ym20,sGet_Ym21,sGet_Ym30,sGet_Ym31, &
		 sGet_Ym40,sGet_Ym41,& 
		 sGet_Ym50,sGet_Ym51,&
		 sGet_Ym60,sGet_Ym61,&
		 sGet_Ym70,sGet_Ym71,&
		 rYm
Date gYm,gYm11,gYm21,gYm31,gYm41,gYm51,gYm61,gYm71
String st

dw_list.modify("f2_t.text = '"+''+"'")
dw_list.modify("f3_t.text = '"+''+"'")
dw_list.modify("f4_t.text = '"+''+"'")
dw_list.modify("f5_t.text = '"+''+"'")
dw_list.modify("year.text = '"+''+"'")

sGet_Ym   = f_last_date(sdate) 
sGet_Ym1  = Left(sGet_Ym,4)  + '-' + Mid(sGet_Ym,5,2) + '-' + Right(sGet_Ym,2)
gYm       = Relativedate(Date(sGet_Ym1),1) //첫째달
dw_list.modify("f2_t.text = '"+Left(String(gYm,'yyyymm'),4)+'년'+ Right(String(gYm,'yyyymm'),2)+'월'+"'")


sGet_Ym10 = f_last_date(String(gYm,'yyyymmdd'))
sGet_Ym11 = Left(sGet_Ym10,4)  + '-' + Mid(sGet_Ym10,5,2) + '-' + Right(sGet_Ym10,2)
gYm11     = Relativedate(Date(sGet_Ym11),1) //둘째달
dw_list.modify("f3_t.text = '"+Left(String(gYm11,'yyyymm'),4)+'년'+Right(String(gYm11,'yyyymm'),2)+'월'             +"'")

sGet_Ym20 = f_last_date(String(gYm11,'yyyymmdd')) 
sGet_Ym21 = Left(sGet_Ym20,4)  + '-' + Mid(sGet_Ym20,5,2) + '-' + Right(sGet_Ym20,2)           
gYm21     = Relativedate(Date(sGet_Ym21),1) //셋째달
dw_list.modify("f4_t.text = '"+Left(String(gYm21,'yyyymm'),4)+'년'+Right(String(gYm21,'yyyymm'),2)+'월'                 +"'")


sGet_Ym30 = f_last_date(String(gYm21,'yyyymmdd')) 
sGet_Ym31 = Left(sGet_Ym30,4)  + '-' + Mid(sGet_Ym30,5,2) + '-' + Right(sGet_Ym30,2)           
gYm31     = Relativedate(Date(sGet_Ym31),1) //넷째달
dw_list.modify("f5_t.text = '"+Left(String(gYm31,'yyyymm'),4)+'년'+Right(String(gYm31,'yyyymm'),2)+'월'    +"'")

sGet_Ym40 = f_last_date(String(gYm31,'yyyymmdd')) 
sGet_Ym41 = Left(sGet_Ym40,4)  + '-' + Mid(sGet_Ym40,5,2) + '-' + Right(sGet_Ym40,2)           
gYm41     = Relativedate(Date(sGet_Ym41),1) //다섯달
dw_list.modify("f6_t.text = '"+Left(String(gYm41,'yyyymm'),4)+'년'+Right(String(gYm41,'yyyymm'),2)+'월'    +"'")

sGet_Ym50 = f_last_date(String(gYm41,'yyyymmdd')) 
sGet_Ym51 = Left(sGet_Ym50,4)  + '-' + Mid(sGet_Ym50,5,2) + '-' + Right(sGet_Ym50,2)           
gYm51     = Relativedate(Date(sGet_Ym51),1) //여섯째
dw_list.modify("f7_t.text = '"+Left(String(gYm51,'yyyymm'),4)+'년'+Right(String(gYm51,'yyyymm'),2)+'월'    +"'")

sGet_Ym60 = f_last_date(String(gYm51,'yyyymmdd')) 
sGet_Ym61 = Left(sGet_Ym60,4)  + '-' + Mid(sGet_Ym60,5,2) + '-' + Right(sGet_Ym60,2)           
gYm61     = Relativedate(Date(sGet_Ym61),1) //일곱째
dw_list.modify("f8_t.text = '"+Left(String(gYm61,'yyyymm'),4)+'년'+Right(String(gYm61,'yyyymm'),2)+'월'    +"'")

sGet_Ym70 = f_last_date(String(gYm61,'yyyymmdd')) 
sGet_Ym71 = Left(sGet_Ym70,4)  + '-' + Mid(sGet_Ym70,5,2) + '-' + Right(sGet_Ym70,2)           
gYm71     = Relativedate(Date(sGet_Ym71),1) //여덟째
dw_list.modify("f9_t.text = '"+Left(String(gYm71,'yyyymm'),4)+'년'+Right(String(gYm71,'yyyymm'),2)+'월'    +"'")


dw_list.modify("year.text = '"+'('+ Left(sDate,4) +'년'+ Right(sDate,2) + '월' + '-'+  Left(String(gYm71,'yyyymm'),4)+'년'+Right(String(gYm71,'yyyymm'),2)+'월'  + ')' +"'")

rYm       = Left(String(gYm71,'yyyymmdd'),6)
Return rYm 
end function

public function integer wf_retrieve ();String sStartYear,sStartYear2,sEndYear,sSaup
string sDeptcode,ls_gubun,ls_JikJong
String sEmpno,sEmpno2
String GetMinEmpno,GetMaxEmpno,ls_GuBn2
String sCalc_Gubn,sChg_Year
Date sYear
String sGet_Ym
String sGet_Ym1 

dw_1.AcceptText()
dw_2.AcceptText()

dw_list.Reset()

sStartYear  = Left(em_ym.text,4)   + mid(em_ym.text,6,2)    //기준년월(From)
sSaup       = dw_1.GetItemString(dw_1.GetRow(),"sabu") //사업장
ls_JikJong  = dw_2.GetItemString(dw_2.GetRow(),"jikjonggubn")      //직종구분
sDeptcode   = dw_2.GetItemString(dw_2.GetRow(),"sdept")    //부서
sEmpno      = dw_2.GetItemString(dw_2.GetRow(),"sempno")   //사번
sEmpno2     = dw_2.GetItemString(dw_2.GetRow(),"sempno2")  //사번
sCalc_Gubn  = '1'                         //소급/승진,승급구분

IF sDeptcode = "" OR IsNull(sDeptcode) THEN	
	sDeptcode= '%'
END IF

IF sSaup = '' OR ISNULL(sSaup) THEN
	sSaup = '%'
END IF
IF IsNull(ls_JikJong) or ls_JikJong = '' then ls_JikJong = '%'

IF sStartYear = "" OR IsNull(sStartYear) THEN
	MessageBox("확 인","출력년월을 입력하세요!!")
	em_ym.SetFocus()
	Return -1
END IF


sStartYear2 = wf_adddate(sStartYear)

IF sEmpno = '' OR ISNULL(sEmpno) THEN
   SELECT MIN(P1_MASTER.EMPNO)
	 INTO:GetMinEmpno
	 FROM P1_MASTER  ;
	 sEmpno = GetMinEmpno	
END IF	
IF sEmpno2 = '' OR ISNULL(sEmpno2) THEN
   SELECT MAX(P1_MASTER.EMPNO)
	 INTO:GetMaxEmpno
	 FROM P1_MASTER  ;
	 sEmpno2 = GetMaxEmpno
END IF	

IF sEmpno > sEmpno2 THEN
   MessageBox("확인","사원번호 범위를 확인하세요")
	dw_2.SetColumn("sempno")
	dw_2.SetFocus()
	Return  -1
END IF	

IF rb_1.checked = true then	
	ls_gubun = 'P'   /*급여*/
ELSEIF rb_2.checked = true then
	ls_gubun = 'B'   /*상여*/
END IF
   

sCalc_Gubn = '1'   /*소급*/
	
	
IF dw_list.Retrieve(gs_company,sSaup,sStartYear,sStartYear2,sDeptcode,sEmpno,sEmpno2,ls_gubun,ls_JikJong,sCalc_Gubn) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
END IF

Return 1

end function

on wp_pip3090.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.em_ym=create em_ym
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.st_2=create st_2
this.dw_1=create dw_1
this.ln_1=create ln_1
this.dw_2=create dw_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.em_ym
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.ln_1
this.Control[iCurrent+9]=this.dw_2
this.Control[iCurrent+10]=this.rr_2
end on

on wp_pip3090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.em_ym)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.ln_1)
destroy(this.dw_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_list.reset()
dw_list.InsertRow(0)
dw_1.settransobject(sqlca)
dw_1.InsertRow(0)
dw_2.settransobject(sqlca)
dw_2.InsertRow(0)

f_set_saupcd(dw_1, 'sabu', '1')
is_saupcd = gs_saupcd


sle_msg.text = "출력물 - 용지크기 :  , 출력방향 : 가로방향"

em_ym.text = String(gs_today,'@@@@.@@')
em_ym.SetFocus()

end event

type p_preview from w_standard_print`p_preview within wp_pip3090
end type

type p_exit from w_standard_print`p_exit within wp_pip3090
end type

type p_print from w_standard_print`p_print within wp_pip3090
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3090
end type

type st_window from w_standard_print`st_window within wp_pip3090
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3090
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3090
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pip3090
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pip3090
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pip3090
integer x = 3813
integer y = 2296
string dataobject = "dp_pip3090_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3090
boolean visible = false
integer x = 722
integer y = 2768
integer height = 140
end type

type dw_list from w_standard_print`dw_list within wp_pip3090
integer x = 14
integer y = 356
integer width = 4594
integer height = 1904
string dataobject = "dp_pip3090"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pip3090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 20
integer width = 2848
integer height = 312
integer cornerheight = 40
integer cornerwidth = 55
end type

type em_ym from editmask within wp_pip3090
event ue_enter pbm_keydown
integer x = 329
integer y = 60
integer width = 302
integer height = 52
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean autoskip = true
end type

event ue_enter;IF key = KeyEnter! THEN
	Send(Handle(this),256,9,0)
	Return 1
END IF
end event

type rb_1 from radiobutton within wp_pip3090
event ue_keydown pbm_keydown
integer x = 1632
integer y = 220
integer width = 288
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "급 여"
boolean checked = true
end type

type rb_2 from radiobutton within wp_pip3090
event ue_keyenter pbm_keydown
integer x = 1344
integer y = 220
integer width = 288
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "상 여"
end type

type st_1 from statictext within wp_pip3090
integer x = 73
integer y = 60
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "기준년월"
boolean focusrectangle = false
end type

type st_2 from statictext within wp_pip3090
integer x = 1106
integer y = 228
integer width = 201
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "구  분"
boolean focusrectangle = false
end type

type dw_1 from datawindow within wp_pip3090
event ue_enter pbm_dwnprocessenter
integer x = 1070
integer y = 44
integer width = 1481
integer height = 92
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_saupcd"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;Return  1
end event

event itemchanged;String SaupCode,sCode


IF dw_1.GetColumnName() = "sabu" THEN
	is_saupcd = this.GetText()
   SaupCode = dw_1.GetText()
	IF SaupCode = '' OR ISNULL(SaupCode) THEN RETURN
    SELECT "P0_SAUPCD"."SAUPCODE"  
     INTO :sCode  
     FROM  "P0_SAUPCD" 
	  WHERE "P0_SAUPCD"."SAUPCODE" =:SaupCode ;
	  IF ISNULL(sCode) OR sCode = '' THEN
		  MessageBox("확인","사업장코드를  확인하세요")
		  dw_1.SetColumn("saupcode")
		  dw_1.SetFocus()
		  Return 1
	  END IF
END IF	

end event

type ln_1 from line within wp_pip3090
integer linethickness = 1
integer beginx = 334
integer beginy = 112
integer endx = 631
integer endy = 112
end type

type dw_2 from datawindow within wp_pip3090
event ue_enter pbm_dwnprocessenter
event ue_keydown pbm_dwnkey
integer x = 78
integer y = 128
integer width = 2789
integer height = 192
integer taborder = 30
string dataobject = "dp_pip3060ret"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String  sDeptCode,returnDeptname,SetNull, sColname1, sColname2, sempcode, ls_name
String sEmpNo,sEmpName

dw_2.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF dw_2.GetColumnName() = "sdept" THEN
	sDeptCode = THIS.GetText()
   IF sDeptCode = '' OR ISNULL(sDeptCode) THEN
		dw_2.SetItem(dw_2.GetRow(),"sdept",SetNull)		 
		dw_2.SetItem(dw_2.GetRow(),"sdeptname",SetNull)		
		RETURN 
	END IF	
		
	  returnDeptname=wf_checkdeptno(sDeptCode)
     IF returnDeptname <> '' THEN
	     dw_2.SetItem(dw_2.GetRow(),"sdeptname",returnDeptname)		
	  ELSE
	     dw_2.SetItem(dw_2.GetRow(),"sdept",SetNull)		 
		  dw_2.SetItem(dw_2.GetRow(),"sdeptname",SetNull)		
		  Return 1
	  END IF	
END IF	 

sColName1 = GetColumnName()

IF sColName1 = "sempno" or sColName1 = "sempno2" THEN
	
	IF sColName1 = "sempno" THEN sColName2 = "sempname"
	IF sColName1 = "sempno2" THEN sColName2 = "sempname2"
	
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

IF sColName1 = "sempname" or sColName1 = "sempname2" THEN
	
	IF sColName1 = "sempname" THEN sColName2 = "sempno"
	IF sColName1 = "sempname2" THEN sColName2 = "sempno2"
	
	sEmpName = GetItemString(1,sColName1)


   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', '%')	 
	 if IsNull(ls_name) then 
		 Setitem(1,sColName1,ls_name)
		 return 2
    end if
	 Setitem(1,sColName2,ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', '%')
	 Setitem(1,sColName1,ls_name)
	 return 1
	

END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF dw_2.GetColumnName() = "sdept"  THEN

	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	  dw_2.SetItem(dw_2.GetRow(),"sDept",gs_code)
	  dw_2.SetItem(dw_2.GetRow(),"sdeptname",gs_codeNAME)

ELSEIF dw_2.GetColumnName() ="sempno" THEN	

	open(w_employee_saup_popup)

   IF IsNull(Gs_code) THEN RETURN
	  dw_2.SetItem(dw_2.GetRow(),"sempno",gs_code)
	  dw_2.SetItem(dw_2.GetRow(),"sempname",gs_codeNAME)
	  
ELSEIF  dw_2.GetColumnName() ="sempno2" THEN	
	
	open(w_employee_saup_popup)

   IF IsNull(Gs_code) THEN RETURN
	  dw_2.SetItem(dw_2.GetRow(),"sempno2",gs_code)
	  dw_2.SetItem(dw_2.GetRow(),"sempname2",gs_codeNAME)   
	
END IF	
end event

event itemerror;return 1
end event

type rr_2 from roundrectangle within wp_pip3090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 348
integer width = 4622
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

