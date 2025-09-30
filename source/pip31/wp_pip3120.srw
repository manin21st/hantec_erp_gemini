$PBExportHeader$wp_pip3120.srw
$PBExportComments$** 급여/상여 집계표
forward
global type wp_pip3120 from w_standard_print
end type
type dw_2 from datawindow within wp_pip3120
end type
type dw_1 from datawindow within wp_pip3120
end type
type dw_3 from datawindow within wp_pip3120
end type
type st_1 from statictext within wp_pip3120
end type
type rb_1 from radiobutton within wp_pip3120
end type
type rb_2 from radiobutton within wp_pip3120
end type
type rr_1 from roundrectangle within wp_pip3120
end type
end forward

global type wp_pip3120 from w_standard_print
string title = "급여/ 상여 집계표"
dw_2 dw_2
dw_1 dw_1
dw_3 dw_3
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global wp_pip3120 wp_pip3120

type variables
string ls_dkdeptcode
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_settext ()
public function integer wf_settext2 ()
public function integer wf_psettext ()
public function integer wf_psettext2 ()
private function string wf_checkdeptno (string sdeptno)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_reset ();string snull ,sname, sabu, smessage

// 환경변수 근태담당부서 
select saupcd into :sabu
from p0_dept
where deptcode = :gs_dept;

dw_ip.setitem(1,"saup",sabu)
		
//// 환경변수 근태담당부서 
Smessage = sqlca.fun_get_authority(gs_dept)

if Smessage = 'ALL'  then
	dw_ip.setitem(dw_1.getrow(),"deptcode",SetNull(snull))
	dw_ip.modify("saup.protect= 0")
	dw_ip.modify("deptcode.protect= 0")
elseif Smessage = 'PART' then
	dw_ip.setitem(dw_1.getrow(),"saup",sabu)
	dw_ip.setitem(dw_1.getrow(),"deptcode",SetNull(snull))
	dw_ip.modify("saup.protect= 1")
	dw_ip.modify("deptcode.protect= 0")
else
	dw_ip.setitem(dw_1.getrow(),"saup",sabu)
	dw_ip.setitem(dw_1.getrow(),"deptcode",gs_dept)
	dw_ip.modify("saup.protect= 1")
	dw_ip.modify("deptcode.protect= 1")
end if	



end subroutine

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_list.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text117.text = '"+sName+"'")
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text118.text = '"+sName+"'")
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text119.text = '"+sName+"'")
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text120.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_settext2 (); String sName
 Long K,ToTalRow
 
 dw_3.Reset()
 dw_3.Retrieve()
 ToTalRow = dw_3.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_3.GetItemString(K,"allowname")
   dw_list.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_psettext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_print.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text117.text = '"+sName+"'")
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text118.text = '"+sName+"'")
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text119.text = '"+sName+"'")
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text120.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_psettext2 (); String sName
 Long K,ToTalRow
 
 dw_3.Reset()
 dw_3.Retrieve()
 ToTalRow = dw_3.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_3.GetItemString(K,"allowname")
   dw_print.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text214.text = '"+sName+"'")
 
 
 
Return 1
end function

private function string wf_checkdeptno (string sdeptno);  string sName 
	
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

public function integer wf_retrieve ();String sStartYear,sSaup,sEndYear,sdwgubn,stolevel,sfromlevel
string sDeptcode,ls_gubun,sJikjong,sPbTag,sKunmu
String sAllowText, ArgBuf
Long i

dw_ip.AcceptText()
dw_2.Reset()
dw_list.Reset()

sStartYear = dw_ip.GetItemString(1,"ym")
sEndYear   = dw_ip.GetItemString(1,"ym")
sSaup      = dw_ip.GetItemString(1,"saup")
sJikjong = dw_ip.GetItemString(1,"jikjong")
sPbTag     = dw_ip.GetItemString(1,"pbtag")
sDeptcode  = dw_ip.GetItemString(1,"deptcode")
sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
sfromlevel  = dw_ip.GetItemString(1,"fromlevel")
stolevel     = dw_ip.GetItemString(1,"tolevel")
sKunmu		= dw_ip.GetItemString(1,"kunmu")

IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
	sDeptcode = '%'
END IF


IF sJikjong = '' or isnull(sJikjong) THEN
	sJikjong = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :sJikjong);
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

IF sStartYear = "      " OR IsNull(sStartYear) THEN
	MessageBox("확 인","기준년월을 입력하세요!!")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sStartYear + '01') = -1 THEN
   MessageBox("확인","기준년월을 확인하세요")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 


IF sEndYear = "      " OR IsNull(sEndYear) THEN
	MessageBox("확 인","기준년월을 입력하세요!!")
	dw_ip.SetColumn("ym2")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sEndYear + '01') = -1 THEN
   MessageBox("확인","기준년월을 확인하세요")
	dw_ip.SetColumn("ym2")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 
IF sStartYear > sEndYear THEN 
	MessageBox("확인","기준년월범위를 확인하세요")
	dw_ip.SetColumn("ym")
	dw_ip.SetFocus()
	Return -1
END IF	

ls_gubun = sPbTag  

		
SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '급여/상여 집계 처리중입니다...'



WF_SETTEXT()
WF_SETTEXT2()

IF dw_print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sEndYear,sDeptcode,sJikjong,sKunmu) <=0 THEN
MessageBox("확 인","조회한 자료가 없습니다!!")
w_mdi_frame.sle_msg.text = ''
Return -1
END IF


SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = ''

Return 1

end function

on wp_pip3120.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_3=create dw_3
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rr_1
end on

on wp_pip3120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_list.reset()
dw_list.InsertRow(0)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)
dw_1.settransobject(sqlca)



dw_ip.SetITem(1,"ym",f_aftermonth(left(f_today(),6),-1))
dw_ip.SetITem(1,"ym2",f_aftermonth(left(f_today(),6),-1))

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

//wf_reset()

end event

type p_preview from w_standard_print`p_preview within wp_pip3120
integer x = 4078
end type

event p_preview::clicked;//String sStartYear,sSaup,sEndYear,sdwgubn,stolevel,sfromlevel
//string sDeptcode,ls_gubun,ls_JikJong,sPbTag 
//String sAllowText
//Long i
//
//dw_ip.AcceptText()
//dw_print.Reset()
//
//sStartYear = dw_ip.GetItemString(1,"ym")
//sEndYear   = dw_ip.GetItemString(1,"ym2")
//sSaup      = dw_ip.GetItemString(1,"saup")
//ls_JikJong = dw_ip.GetItemString(1,"jikjong")
//sPbTag     = dw_ip.GetItemString(1,"pbtag")
//sDeptcode  = dw_ip.GetItemString(1,"deptcode")
//sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
//sfromlevel  = dw_ip.GetItemString(1,"fromlevel")
//stolevel     = dw_ip.GetItemString(1,"tolevel")
//
//IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
//	sDeptcode = '%'
//END IF
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'
//END IF
//
//IF sfromlevel = '' OR ISNULL(sfromlevel) THEN
//	sfromlevel = '00'
//END IF
//
//IF stolevel = '' OR ISNULL(stolevel) THEN
//	stolevel = '99'
//END IF
//
//
///*직종구분*/
//IF ls_JikJong = '1' THEN      /* 관리직 */
//	ls_JikJong = '1' 
//ELSEIF ls_JikJong = '2' THEN	/* 생산직 */
//	ls_JikJong = '2' 
//ELSE
//	ls_JikJong = '%'           /* 전  체 */
//END IF	
//
//
//
//ls_gubun = sPbTag  

			
WF_PSETTEXT()
WF_PSETTEXT2()

//dw_print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sEndYear,sDeptcode,ls_JikJong,sfromlevel,stolevel) 

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within wp_pip3120
integer x = 4425
end type

type p_print from w_standard_print`p_print within wp_pip3120
integer x = 4251
end type

event p_print::clicked;//String sStartYear,sSaup,sEndYear,sdwgubn,stolevel,sfromlevel
//string sDeptcode,ls_gubun,ls_JikJong,sPbTag 
//String sAllowText
//Long i
//
//dw_ip.AcceptText()
//dw_print.Reset()
//
//sStartYear = dw_ip.GetItemString(1,"ym")
//sEndYear   = dw_ip.GetItemString(1,"ym2")
//sSaup      = dw_ip.GetItemString(1,"saup")
//ls_JikJong = dw_ip.GetItemString(1,"jikjong")
//sPbTag     = dw_ip.GetItemString(1,"pbtag")
//sDeptcode  = dw_ip.GetItemString(1,"deptcode")
//sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
//sfromlevel  = dw_ip.GetItemString(1,"fromlevel")
//stolevel     = dw_ip.GetItemString(1,"tolevel")
//
//IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
//	sDeptcode = '%'
//END IF
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'
//END IF
//
//IF sfromlevel = '' OR ISNULL(sfromlevel) THEN
//	sfromlevel = '00'
//END IF
//
//IF stolevel = '' OR ISNULL(stolevel) THEN
//	stolevel = '99'
//END IF
//
//
///*직종구분*/
//IF ls_JikJong = '1' THEN      /* 관리직 */
//	ls_JikJong = '1' 
//ELSEIF ls_JikJong = '2' THEN	/* 생산직 */
//	ls_JikJong = '2' 
//ELSE
//	ls_JikJong = '%'           /* 전  체 */
//END IF	
//
//
//
//ls_gubun = sPbTag  

			
WF_PSETTEXT()
WF_PSETTEXT2()

//dw_print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sEndYear,sDeptcode,ls_JikJong,sfromlevel,stolevel) 

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip3120
integer x = 3904
end type

type st_window from w_standard_print`st_window within wp_pip3120
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3120
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3120
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pip3120
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pip3120
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pip3120
integer x = 3739
integer y = 40
string dataobject = "dp_pip3120_20_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3120
integer y = 0
integer width = 2853
integer height = 240
string dataobject = "dp_pip3120_10"
end type

event dw_ip::rbuttondown;IF dw_ip.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
   SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	dw_ip.SetITem(1,"deptname",gs_codename)
	
END IF	
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;string sdwgubn,sDeptno,SetNull,sName 

setnull(SetNull)
dw_ip.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF dw_ip.GetColumnName() ="deptcode" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"deptcode",SetNull)
		dw_ip.SetITem(1,"deptname",SetNull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_ip.SetITem(1,"deptcode",SetNull)
	   dw_ip.SetITem(1,"deptname",SetNull) 
		dw_ip.SetColumn("deptcode")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"deptname",sName) 
END IF	
/*상여전용용지*/	
IF dw_ip.GetColumnName() ="dwgubn" THEN 
   sdwgubn = dw_ip.GetText()
	IF sdwgubn = 'N' then
		IF rb_1.Checked = True THEN 
		   dw_list.DataObject  = "dp_pip3120_20"     /*A4 사이즈*/
		ELSEIF rb_2.Checked = True THEN 	
			dw_list.DataObject  = "dp_pip3120_20_NEW" /*B4 사이즈*/
		END IF	
	ELSE	
		IF rb_1.Checked = True THEN 
		   dw_list.DataObject  = "dp_pip3120_21"     /*A4 사이즈*/
		ELSEIF rb_2.Checked = True THEN 	
			dw_list.DataObject  = "dp_pip3120_21"     /*A4 사이즈*/
		END IF	

	END IF	
	dw_list.SetTransObject(sqlca) 
END IF	

end event

type dw_list from w_standard_print`dw_list within wp_pip3120
integer x = 55
integer y = 248
integer width = 4517
integer height = 2076
string dataobject = "dp_pip3120_20"
boolean border = false
end type

type dw_2 from datawindow within wp_pip3120
boolean visible = false
integer x = 3310
integer y = 2440
integer width = 1189
integer height = 436
integer taborder = 60
boolean titlebar = true
string dataobject = "dp_pip3010_10knc"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within wp_pip3120
boolean visible = false
integer x = 539
integer y = 2916
integer width = 805
integer height = 96
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3110_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within wp_pip3120
boolean visible = false
integer x = 1454
integer y = 2900
integer width = 805
integer height = 96
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3110_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within wp_pip3120
boolean visible = false
integer x = 2688
integer y = 2468
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within wp_pip3120
boolean visible = false
integer x = 2683
integer y = 2548
integer width = 311
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "A4 SIZE"
boolean checked = true
end type

type rb_2 from radiobutton within wp_pip3120
boolean visible = false
integer x = 2683
integer y = 2632
integer width = 311
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "B4 SIZE"
end type

type rr_1 from roundrectangle within wp_pip3120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 240
integer width = 4549
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

