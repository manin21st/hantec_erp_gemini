$PBExportHeader$w_pip3150.srw
$PBExportComments$** 개인별 급여/상여 임금대장
forward
global type w_pip3150 from w_standard_print
end type
type dw_1 from datawindow within w_pip3150
end type
type dw_3 from datawindow within w_pip3150
end type
type rb_1 from radiobutton within w_pip3150
end type
type rb_2 from radiobutton within w_pip3150
end type
type st_1 from statictext within w_pip3150
end type
type rr_1 from roundrectangle within w_pip3150
end type
end forward

global type w_pip3150 from w_standard_print
string title = "개인별 급여/ 상여 임금대장"
dw_1 dw_1
dw_3 dw_3
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_1 rr_1
end type
global w_pip3150 w_pip3150

type variables
string       ls_dkdeptcode
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_psettext ()
public function integer wf_psettext2 ()
private function string wf_checkdeptno (string sdeptno)
public function integer wf_settext ()
public function integer wf_settext2 ()
public function integer wf_retrieve ()
end prototypes

public subroutine wf_reset ();//string snull,sname, sabu, smessage 
//
//// 환경변수 근태담당부서 
//select saupcd into :sabu
//from p0_dept
//where deptcode = :gs_dept;
//
//dw_ip.setitem(1,"saup",sabu)
//		
//// 환경변수 근태담당부서 
//Smessage = sqlca.fun_get_authority(gs_dept)
//
//if Smessage = 'ALL'  then
//	dw_ip.setitem(dw_ip.getrow(),"deptcode",SetNull(snull))
//	dw_ip.modify("saup.protect= 0")
//	dw_ip.modify("deptcode.protect= 0")
//elseif Smessage = 'PART' then
//	dw_ip.setitem(dw_ip.getrow(),"saup",sabu)
//	dw_ip.setitem(dw_ip.getrow(),"deptcode",SetNull(snull))
//	dw_ip.modify("saup.protect= 1")
//	dw_ip.modify("deptcode.protect= 0")
//else
//	dw_ip.setitem(dw_ip.getrow(),"saup",sabu)
//	dw_ip.setitem(dw_ip.getrow(),"deptcode",gs_dept)
//	dw_ip.modify("saup.protect= 1")
//	dw_ip.modify("deptcode.protect= 1")
//end if	



//
//if gs_dept = ls_dkdeptcode  then
//	dw_ip.setitem(dw_ip.getrow(),"deptcode",SetNull(snull))
//	dw_ip.modify("deptcode.protect= 0")
//else
//	dw_ip.setitem(dw_ip.getrow(),"deptcode",gs_dept)
//	dw_ip.modify("deptcode.protect= 1")
//	/*부서명*/
//	SELECT  "P0_DEPT"."DEPTNAME"  
//		INTO :sName  
//		FROM "P0_DEPT"  
//		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
//				( "P0_DEPT"."DEPTCODE" = :gs_dept ); 
//	if sqlca.sqlcode <> 0 then
//		sname = ''
//	else
//		dw_ip.setitem(dw_ip.getrow(),"deptname",sname)
//	end if	
//				
//end if	
//
//
//
end subroutine

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
   K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text121.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text122.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text123.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text124.text = '"+sName+"'")
 

 
 
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
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text215.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text216.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text217.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text218.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_print.modify("text219.text = '"+sName+"'")
 
 
 
 
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
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text121.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text122.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text123.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text124.text = '"+sName+"'")
 
 
 
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
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text215.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text216.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text217.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text218.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"allowname")
 dw_list.modify("text219.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_retrieve ();String sStartYear,sSaup,sEndYear
string sDeptcode,ls_gubun,sJikJong,sPbTag,sdwgubn, sKunmu, sempno, ls_sex
String sAllowText, ArgBuf
Long i

dw_ip.AcceptText()
dw_list.Reset()

sStartYear = dw_ip.GetItemString(1,"ym")
sEndYear   = dw_ip.GetItemString(1,"ym2")
sSaup      = dw_ip.GetItemString(1,"saup")
sJikJong = dw_ip.GetItemString(1,"jikjong")
sDeptcode  = dw_ip.GetItemString(1,"deptcode")
sPbTag     = dw_ip.GetItemString(1,"pbtag")
sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
sKunmu		= dw_ip.GetItemString(1,"kunmu")
sempno = dw_ip.GetItemString(1,"l_empno")
ls_sex = dw_ip.GetItemString(1,"sex")

IF sDeptcode = "" OR IsNull(sDeptcode) THEN sDeptcode= '%'
IF sempno = "" OR IsNull(sempno) THEN
	messagebox("확인","조회할 사번을 입력하세요!")
	dw_ip.SetColumn("l_empno")
	dw_ip.SetFocus()
	Return -1
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

	//IF sdwgubn = 'Y' then
	//		IF rb_1.Checked = True THEN 
	//		   dw_list.DataObject  = "dp_pip3110_21"     /*A4 사이즈*/
	//		ELSEIF rb_2.Checked = True THEN 	
	//			dw_list.DataObject  = "dp_pip3110_21_NEW" /*B4 사이즈*/
	//		END IF	
	//ELSE	
	//		IF rb_1.Checked = True THEN 
	//		   dw_list.DataObject  = "dp_pip3110_20"     /*A4 사이즈*/
	//		ELSEIF rb_2.Checked = True THEN 	
	//			dw_list.DataObject  = "dp_pip3110_20_NEW" /*B4 사이즈*/
	//		END IF	
	//
	//END IF	
		
//	dw_list.SetTransObject(sqlca)

	SetPointer(HourGlass!)
	sdwgubn = 'N'
//	IF sdwgubn = 'Y' then
//	else
//		DELETE FROM "P3_TMP_PAY"
//		COMMIT ;
//		
//		INSERT INTO "P3_TMP_PAY"
//						("EMPNO",    "GUBUN",   "ALLOWCODE",
//						 "ALLOWAMT", "PRINTSEQ")
//						 
//	 SELECT p3_editdatachild.empno as empno,  /*수당*/
//				 '1' AS GUBUN,
//				 p3_tallowance.tallowcode,
//				 sum(p3_editdatachild.allowamt) as amt,
//				 p3_tallowance.printseq
//		  FROM p3_editdatachild,P3_ALLOWANCE, p3_tallowance
//		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
//				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
//             p3_allowance.tallowcode = p3_tallowance.tallowcode and
//             p3_allowance.paysubtag = p3_tallowance.gubun and
//				 p3_editdatachild.companycode = :gs_company AND 
//				 p3_editdatachild.workym     = :sStartYear AND
//				 p3_editdatachild.pbtag     = :ls_gubun and  
//				 P3_ALLOWANCE.paysubtag     = '1' 
//	  group by 	p3_editdatachild.empno,
//				 p3_tallowance.tallowcode,	
//				 p3_tallowance.printseq
//		
//		UNION ALL 
//	
//		 SELECT p3_editdatachild.empno as empno,  /*공제부문*/
//				 '2' AS GUBUN,
//				 p3_tallowance.tallowcode,
//				 sum(p3_editdatachild.allowamt) as amt,
//				 p3_tallowance.printseq
//		  FROM p3_editdatachild,P3_ALLOWANCE, p3_tallowance
//		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
//				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
//             p3_allowance.tallowcode = p3_tallowance.tallowcode and
//             p3_allowance.paysubtag = p3_tallowance.gubun and
//				 p3_editdatachild.companycode = :gs_company AND 
//				 p3_editdatachild.workym     = :sStartYear AND
//				 p3_editdatachild.pbtag     = :ls_gubun and  
//				 P3_ALLOWANCE.paysubtag     = '2' 
// group by 	p3_editdatachild.empno,
//				 p3_tallowance.tallowcode,	
//				 p3_tallowance.printseq		 ;		
				 
				 
//		 SELECT p3_editdatachild.empno as empno,  /*수당*/
//				 '1' AS GUBUN,
//				 p3_editdatachild.allowcode,
//				 p3_editdatachild.allowamt as amt,
//				 P3_ALLOWANCE.PRINTSEQ
//		  FROM p3_editdatachild,P3_ALLOWANCE
//		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
//				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
//				 p3_editdatachild.companycode =:gs_company AND 
//				 p3_editdatachild.workym     =:sStartYear AND
//				 p3_editdatachild.pbtag     =:ls_gubun and  
//				 P3_ALLOWANCE.paysubtag     = '1'
//		
//		UNION ALL 
//	
//		 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
//				 '2' AS GUBUN,
//				 p3_editdatachild.allowcode,
//				 p3_editdatachild.allowamt as amt,
//				 P3_ALLOWANCE.PRINTSEQ
//		  FROM p3_editdatachild,P3_ALLOWANCE
//		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
//				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
//				 p3_editdatachild.companycode =:gs_company AND 
//				 p3_editdatachild.workym     =:sStartYear AND
//				 p3_editdatachild.pbtag     =:ls_gubun and  
//				 P3_ALLOWANCE.paysubtag     = '2'  ;
				 
//		IF SQLCA.SQLCODE = 0 THEN
//			COMMIT ;
//		ELSE
//			ROLLBACK ;
//		END IF
		
		WF_SETTEXT()
		WF_SETTEXT2()
//	END IF

	IF dw_Print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sEndYear,sDeptcode,sJikJong,sKunmu,sempno) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		Return -1
	END IF

dw_print.sharedata(dw_list)

SetPointer(Arrow!)

Return 1

end function

on w_pip3150.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_pip3150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;

dw_list.settransobject(sqlca)
dw_list.reset()
dw_list.InsertRow(0)
dw_3.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)
dw_1.settransobject(sqlca)

w_mdi_frame.sle_msg.text = "출력물 - 용지크기 :  , 출력방향 : 가로방향"

dw_ip.SetITem(1,"ym",String(gs_today,'@@@@@@'))
dw_ip.SetITem(1,"ym2",String(gs_today,'@@@@@@'))

f_set_saupcd(dw_ip,'saup','1')
is_saupcd = gs_saupcd

//Wf_Reset()

end event

type p_preview from w_standard_print`p_preview within w_pip3150
integer y = 28
end type

event p_preview::clicked;//String sStartYear,sSaup,sEndYear
//string sDeptcode,ls_gubun,ls_JikJong,sPbTag,sdwgubn
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
//sDeptcode  = dw_ip.GetItemString(1,"deptcode")
//sPbTag     = dw_ip.GetItemString(1,"pbtag")
//sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
//IF sDeptcode = "" OR IsNull(sDeptcode) THEN	
//	sDeptcode= '%'
//END IF
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'
//END IF
//
///*직종구분*/
//IF ls_JikJong = '1' THEN      /* 관리직 */
//	ls_JikJong = '1' 
//ELSEIF ls_JikJong = '2' THEN	/* 생산직 */
//	ls_JikJong = '2' 
//ELSEIF ls_JikJong = '3' THEN	/* 임원 */
//	ls_JikJong = '3' 	
//ELSE
//	ls_JikJong = '%'           /* 전  체 */
//END IF	
//
//
//
//ls_gubun = sPbTag


	
WF_PSETTEXT()
WF_PSETTEXT2()

//		 
//dw_print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sStartYear,sDeptcode,ls_JikJong) 
//		
//
OpenWithParm(w_print_preview, dw_print)	




end event

type p_exit from w_standard_print`p_exit within w_pip3150
end type

type p_print from w_standard_print`p_print within w_pip3150
end type

event p_print::clicked;//String sStartYear,sSaup,sEndYear
//string sDeptcode,ls_gubun,ls_JikJong,sPbTag,sdwgubn
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
//sDeptcode  = dw_ip.GetItemString(1,"deptcode")
//sPbTag     = dw_ip.GetItemString(1,"pbtag")
//sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
//IF sDeptcode = "" OR IsNull(sDeptcode) THEN	
//	sDeptcode= '%'
//END IF
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'
//END IF
//
///*직종구분*/
//IF ls_JikJong = '1' THEN      /* 관리직 */
//	ls_JikJong = '1' 
//ELSEIF ls_JikJong = '2' THEN	/* 생산직 */
//	ls_JikJong = '2' 
//ELSEIF ls_JikJong = '3' THEN	/* 임원 */
//	ls_JikJong = '3' 	
//ELSE
//	ls_JikJong = '%'           /* 전  체 */
//END IF	
//
//
//
//ls_gubun = sPbTag
//

	
WF_PSETTEXT()
WF_PSETTEXT2()

		 
//dw_print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sStartYear,sDeptcode,ls_JikJong) 
		

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)




end event

type p_retrieve from w_standard_print`p_retrieve within w_pip3150
end type

type st_window from w_standard_print`st_window within w_pip3150
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_pip3150
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_pip3150
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_pip3150
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_pip3150
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_pip3150
integer x = 3785
integer y = 32
string dataobject = "d_pip3150_20_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pip3150
integer x = 46
integer y = 8
integer width = 3579
integer height = 216
string dataobject = "d_pip3150_10"
end type

event dw_ip::rbuttondown;IF dw_ip.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)


	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	dw_ip.SetITem(1,"deptname",gs_codename)
	
END IF	

IF dw_ip.GetColumnName() = "l_empno" THEN
   Open(w_employee_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"l_empno",gs_code)
	dw_ip.SetITem(1,"l_empname",gs_codename)
  
END IF	
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String sDeptno,SetNull,sName,sdwgubn, spbtag, sempno, snull, sempname, ls_name

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
		   dw_list.DataObject  = "dp_pip3110_20"     /*A4 사이즈*/
		ELSEIF rb_2.Checked = True THEN 	
			dw_list.DataObject  = "dp_pip3110_20_NEW" /*B4 사이즈*/
		END IF	
	ELSE	
		IF rb_1.Checked = True THEN 
		   dw_list.DataObject  = "dp_pip3110_21"     /*A4 사이즈*/
		ELSEIF rb_2.Checked = True THEN 	
			dw_list.DataObject  = "dp_pip3110_21_NEW" /*B4 사이즈*/
		END IF	

	END IF	
	dw_list.SetTransObject(sqlca) 
END IF	

/*연월차대장*/	
IF dw_ip.GetColumnName() ="pbtag" THEN 
   spbtag = dw_ip.GetText()
	IF spbtag = 'Y' then
   	MessageBox("확 인", "연월차대장은 연월차지급관리에서 출력하세여!!") 
		dw_ip.SetITem(1,"pbtag",'P')
		dw_ip.SetColumn("pbtag")
      Return 1
	END IF	
/*	
	IF spbtag = 'Y' then
	   dw_list.DataObject  = "dp_pip3110_20_y"     /*연차대장*/
	ELSE
		dw_list.DataObject  = "dp_pip3110_20"       /*급상여 대장*/
	END IF	
	IF spbtag = 'Y' then
	   dw_print.DataObject  = "dp_pip3110_20_p_y"     /*연차대장*/
	ELSE
		dw_print.DataObject  = "dp_pip3110_20_p"       /*급상여 대장*/
	END IF	
	dw_list.SetTransObject(sqlca) 
	dw_print.SetTransObject(sqlca) 
*/	
END IF	
IF dw_ip.GetColumnName() = "l_empno" then
   sEmpNo = dw_ip.GetItemString(1,"l_empno")

	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"l_empno",snull)
		dw_ip.SetITem(1,"l_empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"l_empno",snull)
				 dw_ip.SetITem(1,"l_empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"l_empname",sEmpName  )
				
	 END IF
END IF

IF GetColumnName() = "l_empname" then
  sEmpName = GetItemString(1,"l_empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'l_empname',ls_name)
		 Setitem(1,'l_empno',ls_name)
		 return 1
    end if
	 Setitem(1,"l_empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"l_empname",ls_name)
	 return 1
END IF
end event

type dw_list from w_standard_print`dw_list within w_pip3150
integer x = 73
integer y = 236
integer width = 4475
integer height = 2040
string dataobject = "d_pip3150_20"
boolean border = false
end type

event dw_list::clicked;//override
end event

event dw_list::rowfocuschanged;//override
end event

type dw_1 from datawindow within w_pip3150
boolean visible = false
integer x = 361
integer y = 2496
integer width = 1019
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3110_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_pip3150
boolean visible = false
integer x = 1527
integer y = 2496
integer width = 1010
integer height = 88
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3110_40"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pip3150
boolean visible = false
integer x = 1275
integer y = 2772
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

type rb_2 from radiobutton within w_pip3150
boolean visible = false
integer x = 1275
integer y = 2856
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

type st_1 from statictext within w_pip3150
boolean visible = false
integer x = 1280
integer y = 2692
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

type rr_1 from roundrectangle within w_pip3150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 228
integer width = 4512
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

