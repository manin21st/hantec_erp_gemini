$PBExportHeader$wp_pip3111.srw
$PBExportComments$** 급여/상여 임금대장(급여종류별)
forward
global type wp_pip3111 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3111
end type
type dw_3 from datawindow within wp_pip3111
end type
type rb_1 from radiobutton within wp_pip3111
end type
type rb_2 from radiobutton within wp_pip3111
end type
type st_1 from statictext within wp_pip3111
end type
type rr_1 from roundrectangle within wp_pip3111
end type
end forward

global type wp_pip3111 from w_standard_print
integer width = 4667
integer height = 2516
string title = "급여형태별 급상여 임금대장"
dw_1 dw_1
dw_3 dw_3
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_1 rr_1
end type
global wp_pip3111 wp_pip3111

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

public subroutine wf_reset ();string snull,sname, sabu, smessage 

// 환경변수 근태담당부서 
select saupcd into :sabu
from p0_dept
where deptcode = :gs_dept;

dw_ip.setitem(1,"saup",sabu)
		
// 환경변수 근태담당부서 
Smessage = sqlca.fun_get_authority(gs_dept)

if Smessage = 'ALL'  then
	dw_ip.setitem(dw_ip.getrow(),"deptcode",SetNull(snull))
	dw_ip.modify("saup.protect= 0")
	dw_ip.modify("deptcode.protect= 0")
elseif Smessage = 'PART' then
	dw_ip.setitem(dw_ip.getrow(),"saup",sabu)
	dw_ip.setitem(dw_ip.getrow(),"deptcode",SetNull(snull))
	dw_ip.modify("saup.protect= 1")
	dw_ip.modify("deptcode.protect= 0")
else
	dw_ip.setitem(dw_ip.getrow(),"saup",sabu)
	dw_ip.setitem(dw_ip.getrow(),"deptcode",gs_dept)
	dw_ip.modify("saup.protect= 1")
	dw_ip.modify("deptcode.protect= 1")
end if	



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

public function integer wf_retrieve ();String sStartYear,sSaup,sEndYear
string sDeptcode,ls_gubun,sJikJong,sPbTag,sdwgubn, sKunmu
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

IF sDeptcode = "" OR IsNull(sDeptcode) THEN sDeptcode= '%'

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



ls_gubun = sPbTag

SetPointer(HourGlass!)
		
WF_SETTEXT()
WF_SETTEXT2()

IF dw_Print.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sStartYear,sDeptcode,sJikJong,sKunmu) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	Return -1
else
	dw_list.Retrieve(gs_company,sSaup,ls_gubun,sStartYear,sStartYear,sDeptcode,sJikJong,sKunmu)
	
	Integer iCount
	
	iCount = dw_ip.GetItemNumber(1,"empcnt")
	
	if iCount = 1 then
		dw_print.Modify("t_gl1.visible = 0")
		dw_print.Modify("t_gl2.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 2 then
		dw_print.Modify("t_gl1.visible = 0")
		dw_print.Modify("t_gl2.visible = 0")
		dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 3 then
		dw_print.Modify("t_gl1.visible = 0")
		dw_print.Modify("t_gl2.visible = 0")
		dw_print.Modify("t_gl3.visible = 0")
		dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 4 then
		dw_print.Modify("t_gl1.visible = 0")
		dw_print.Modify("t_gl2.visible = 0")
		dw_print.Modify("t_gl3.visible = 0")
		dw_print.Modify("t_gl4.visible = 0")
		dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 5 then
		dw_print.Modify("t_gl1.visible = 0")
		dw_print.Modify("t_gl2.visible = 0")
		dw_print.Modify("t_gl3.visible = 0")
		dw_print.Modify("t_gl4.visible = 0")
		dw_print.Modify("t_gl5.visible = 0")
	end if
	
END IF

//dw_print.sharedata(dw_list)

SetPointer(Arrow!)

Return 1

end function

on wp_pip3111.create
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

on wp_pip3111.destroy
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

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd



dw_ip.SetITem(1,"ym",f_aftermonth(left(f_today(),6),-1))
dw_ip.SetITem(1,"ym2",f_aftermonth(left(f_today(),6),-1))

//Wf_Reset()

end event

type p_xls from w_standard_print`p_xls within wp_pip3111
integer x = 3639
integer y = 44
end type

type p_sort from w_standard_print`p_sort within wp_pip3111
integer x = 3461
integer y = 44
end type

type p_preview from w_standard_print`p_preview within wp_pip3111
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

type p_exit from w_standard_print`p_exit within wp_pip3111
end type

type p_print from w_standard_print`p_print within wp_pip3111
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

type p_retrieve from w_standard_print`p_retrieve within wp_pip3111
end type

type st_window from w_standard_print`st_window within wp_pip3111
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3111
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3111
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pip3111
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pip3111
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pip3111
integer y = 64
string dataobject = "dp_pip3111_20_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3111
integer x = 46
integer y = 8
integer width = 3730
integer height = 216
string dataobject = "dp_pip3111_10"
end type

event dw_ip::rbuttondown;String sEmpNo, sEmpName, snull

IF dw_ip.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
   SetNull(Gs_gubun)

   Gs_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	dw_ip.SetITem(1,"deptname",gs_codename)	
END IF

IF this.GetColumnName() ="bef_sawon" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bef_sawon",    lstr_custom.code)
	this.SetItem(this.GetRow(),"bef_sawon_name",lstr_custom.name)
	
END IF
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String sDeptno,SetNull,sName,sdwgubn,sEmpNo, sNull,sEmpName

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

IF this.GetColumnName() = "bef_sawon" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		this.SetItem(1,"bef_sawon_name",snull)
		Return
	END IF
	
	sEmpName = F_Get_PersonLst('4',sEmpNo,'1')
	IF IsNull(sEmpName) THEN
//		F_MessageChk(20,'[작성자]')
//		this.SetItem(1,"sawon",snull)
//		this.SetItem(1,"sawonname",snull)
//		Return 1
	ELSE
		this.SetItem(1,"bef_sawon_name",sEmpName)
	END IF
END IF


end event

type dw_list from w_standard_print`dw_list within wp_pip3111
integer x = 73
integer y = 236
integer width = 4475
integer height = 2040
string dataobject = "dp_pip3111_20"
boolean border = false
end type

type dw_1 from datawindow within wp_pip3111
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

type dw_3 from datawindow within wp_pip3111
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

type rb_1 from radiobutton within wp_pip3111
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

type rb_2 from radiobutton within wp_pip3111
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

type st_1 from statictext within wp_pip3111
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

type rr_1 from roundrectangle within wp_pip3111
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

