$PBExportHeader$wp_pip3095.srw
$PBExportComments$** 소급대장
forward
global type wp_pip3095 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3095
end type
type dw_3 from datawindow within wp_pip3095
end type
type rb_1 from radiobutton within wp_pip3095
end type
type rb_2 from radiobutton within wp_pip3095
end type
type st_1 from statictext within wp_pip3095
end type
type rr_2 from roundrectangle within wp_pip3095
end type
end forward

global type wp_pip3095 from w_standard_print
string title = "소급대장"
dw_1 dw_1
dw_3 dw_3
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_2 rr_2
end type
global wp_pip3095 wp_pip3095

type variables
string       ls_dkdeptcode
end variables

forward prototypes
public function integer wf_settext2 ()
public subroutine wf_reset ()
public function integer wf_settext ()
private function string wf_checkdeptno (string sdeptno)
public function integer wf_retrieve ()
end prototypes

public function integer wf_settext2 (); String sName
 Long K,ToTalRow
 
 dw_3.Reset()
 dw_3.Retrieve()
 ToTalRow = dw_3.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_3.GetItemString(K,"p3_allowance_allowname")
   dw_list.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_3.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 
 
 
Return 1
end function

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

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"p3_allowance_allowname")
   dw_list.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text117.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text118.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text119.text = '"+sName+"'")
  K = K + 1 
// IF K > ToTalRow THEN RETURN -1
// sName = dw_1.GetItemString(K,"p3_allowance_allowname")
// dw_list.modify("text120.text = '"+sName+"'")
 
 
 
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

public function integer wf_retrieve ();String sStartYear,sSaup,sEndYear,sempno
string sDeptcode,ls_gubun,ls_JikJong,sPbTag,sdwgubn
String sAllowText
Long i

dw_ip.AcceptText()
dw_list.Reset()

sStartYear = dw_ip.GetItemString(1,"ym")
sEndYear   = dw_ip.GetItemString(1,"ym2")
sSaup      = dw_ip.GetItemString(1,"saup")
ls_JikJong = dw_ip.GetItemString(1,"jikjong")
sDeptcode  = dw_ip.GetItemString(1,"deptcode")
sPbTag     = dw_ip.GetItemString(1,"pbtag")
sdwgubn     = dw_ip.GetItemString(1,"dwgubn")
sempno     = dw_ip.getitemstring(1,"empno")

IF sDeptcode = "" OR IsNull(sDeptcode) THEN	
	sDeptcode= '%'
END IF

IF sSaup = '' OR ISNULL(sSaup) THEN
	sSaup = '%'
END IF

if sempno = "" or isnull(sempno) then
	sempno = '%' 
end if

/*직종구분*/
IF ls_JikJong = '1' THEN      /* 관리직 */
	ls_JikJong = '1' 
ELSEIF ls_JikJong = '2' THEN	/* 생산직 */
	ls_JikJong = '2' 
ELSEIF ls_JikJong = '3' THEN	/* 임원   */
	ls_JikJong = '3' 
ELSE
	ls_JikJong = '%'           /* 전  체 */
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


		
	dw_list.SetTransObject(sqlca) 
		
	SetPointer(HourGlass!)	
	
	dw_list.SetRedraw(False)
	IF sdwgubn = 'Y' then
	else	
		DELETE FROM "P3_SOKUB_TMP_PAY"
		COMMIT ;
		
		INSERT INTO "P3_SOKUB_TMP_PAY"	 
						("EMPNO",    "GUBUN",   "ALLOWCODE",   
						 "ALLOWAMT", "SOKUBAMT", "PRINTSEQ", "YYMM")

		 

		 SELECT p8_eeditdatachild.empno as empno,  /*기타수당*/
				 '1' AS GUBUN,
				 p8_eeditdatachild.allowcode,
				 p8_eeditdatachild.btamt as amt,
				 p8_eeditdatachild.btamt as samt,
				 P3_ALLOWANCE.PRINTSEQ, p8_eeditdatachild.workym
		  FROM p8_eeditdatachild,P3_ALLOWANCE
		 WHERE p8_eeditdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p8_eeditdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND				
				 p8_eeditdatachild.companycode =:gs_company AND 
				 p8_eeditdatachild.workym  >= :sStartYear and
   			 p8_eeditdatachild.workym  <= :sEndYear and
				 p8_eeditdatachild.empno like :sempno and
				 p8_eeditdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '1' 
		
		UNION ALL  /*공제부분*/
	
		  SELECT p8_eeditdatachild.empno as empno,  /*기타공제*/
				 '1' AS GUBUN,
				 p8_eeditdatachild.allowcode,
				 p8_eeditdatachild.btamt as amt,
				 p8_eeditdatachild.btamt as samt,
				 P3_ALLOWANCE.PRINTSEQ, p8_eeditdatachild.workym
		  FROM p8_eeditdatachild,P3_ALLOWANCE
		 WHERE p8_eeditdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p8_eeditdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND				
				 p8_eeditdatachild.companycode =:gs_company AND 
				 p8_eeditdatachild.workym  >= :sStartYear and
   			 p8_eeditdatachild.workym  <= :sEndYear and
				 p8_eeditdatachild.empno like :sempno and
				 p8_eeditdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '2' ;
				 
		IF SQLCA.SQLCODE = 0 THEN
			COMMIT ;
		ELSE
			ROLLBACK ;	
		END IF	
		
		WF_SETTEXT()
//		WF_SETTEXT2()
	END IF
		 
	IF dw_list.Retrieve(gs_company,sSaup,sempno,ls_gubun,sStartYear,sEndYear,sDeptcode,ls_JikJong) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_list.SetRedraw(True)
		Return -1
		
	END IF


dw_list.SetRedraw(True)
SetPointer(Arrow!)	

Return 1

end function

on wp_pip3095.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rr_2
end on

on wp_pip3095.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_list.reset()
dw_list.InsertRow(0)
dw_3.settransobject(sqlca)
dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)
dw_1.settransobject(sqlca)

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

sle_msg.text = "출력물 - 용지크기 :  , 출력방향 : 가로방향"

dw_ip.SetITem(1,"ym",String(gs_today,'@@@@@@'))
dw_ip.SetITem(1,"ym2",String(gs_today,'@@@@@@'))

Wf_Reset()

end event

type p_preview from w_standard_print`p_preview within wp_pip3095
boolean enabled = true
end type

type p_exit from w_standard_print`p_exit within wp_pip3095
end type

type p_print from w_standard_print`p_print within wp_pip3095
boolean enabled = true
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3095
end type

type st_window from w_standard_print`st_window within wp_pip3095
boolean visible = false
integer x = 2528
integer y = 3132
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3095
boolean visible = false
integer x = 553
integer y = 3132
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3095
boolean visible = false
integer x = 3022
integer y = 3132
end type

type st_10 from w_standard_print`st_10 within wp_pip3095
boolean visible = false
integer x = 192
integer y = 3132
end type

type gb_10 from w_standard_print`gb_10 within wp_pip3095
boolean visible = false
integer x = 178
integer y = 3096
end type

type dw_print from w_standard_print`dw_print within wp_pip3095
string dataobject = "dp_pip3095_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3095
integer x = 14
integer y = 4
integer width = 2299
integer height = 392
string dataobject = "dp_pip3095"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF dw_ip.GetColumnName() = "deptcode" THEN

	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	dw_ip.SetITem(1,"deptname",gs_codename)
	
END IF	

IF dw_ip.GetColumnName() ="empno" THEN	

	open(w_employee_saup_popup)

   IF IsNull(Gs_code) THEN RETURN
	  dw_ip.SetItem(dw_ip.GetRow(),"empno",gs_code)
	  dw_ip.SetItem(dw_ip.GetRow(),"empname",gs_codename)
END IF

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String sDeptno,SetNull,sName,sdwgubn, sempno, sempname

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

IF dw_ip.GetColumnName() = "empno" then
  sEmpNo = dw_ip.GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  dw_ip.SetITem(1,"empno",SetNull)
		  dw_ip.SetITem(1,"empname",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE <> 0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"empno",SetNull)
				 dw_ip.SetITem(1,"empname",SetNull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF
	
///*상여전용용지*/	
//IF dw_ip.GetColumnName() ="dwgubn" THEN 
//   sdwgubn = dw_ip.GetText()
//	IF sdwgubn = 'N' then
//		IF rb_1.Checked = True THEN 
//		   dw_list.DataObject  = "dp_pip3110_20"     /*A4 사이즈*/
//		ELSEIF rb_2.Checked = True THEN 	
//			dw_list.DataObject  = "dp_pip3110_20_NEW" /*B4 사이즈*/
//		END IF	
//	ELSE	
//		IF rb_1.Checked = True THEN 
//		   dw_list.DataObject  = "dp_pip3110_21"     /*A4 사이즈*/
//		ELSEIF rb_2.Checked = True THEN 	
//			dw_list.DataObject  = "dp_pip3110_21_NEW" /*B4 사이즈*/
//		END IF	
//
//	END IF	
//	dw_list.SetTransObject(sqlca) 
//END IF	
//
end event

type dw_list from w_standard_print`dw_list within wp_pip3095
integer x = 32
integer y = 420
integer width = 4558
integer height = 1836
string dataobject = "dp_pip3095_1"
boolean border = false
end type

type dw_1 from datawindow within wp_pip3095
boolean visible = false
integer x = 411
integer y = 2984
integer width = 1019
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3110_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within wp_pip3095
boolean visible = false
integer x = 1522
integer y = 2984
integer width = 1019
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3110_40"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within wp_pip3095
boolean visible = false
integer x = 2624
integer y = 2960
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

type rb_2 from radiobutton within wp_pip3095
boolean visible = false
integer x = 2624
integer y = 3044
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

type st_1 from statictext within wp_pip3095
boolean visible = false
integer x = 3026
integer y = 2984
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

type rr_2 from roundrectangle within wp_pip3095
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 412
integer width = 4590
integer height = 1852
integer cornerheight = 40
integer cornerwidth = 55
end type

