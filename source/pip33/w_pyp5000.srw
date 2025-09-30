$PBExportHeader$w_pyp5000.srw
$PBExportComments$** 년도별 항목별 월별 대비표
forward
global type w_pyp5000 from w_standard_print
end type
type dw_1 from datawindow within w_pyp5000
end type
type dw_3 from datawindow within w_pyp5000
end type
type rr_1 from roundrectangle within w_pyp5000
end type
end forward

global type w_pyp5000 from w_standard_print
integer height = 2408
string title = "연간임금내역"
dw_1 dw_1
dw_3 dw_3
rr_1 rr_1
end type
global w_pyp5000 w_pyp5000

forward prototypes
public function integer wf_settext ()
public function integer wf_settext2 ()
public subroutine wf_reset ()
public function integer wf_retrieve ()
end prototypes

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
 
Return 1
end function

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

public subroutine wf_reset ();string snull ,sname, ls_dkdeptcode

// 환경변수 근태담당부서 
SELECT dataname
	INTO :ls_dkdeptcode
	FROM syscnfg
	WHERE sysgu = 'P' and serial = 1 and lineno = '1' ;

if gs_dept = ls_dkdeptcode  then
	dw_ip.setitem(dw_ip.getrow(),"deptcode",SetNull(snull))
	dw_ip.modify("deptcode.protect= 0")
else
	dw_ip.setitem(dw_ip.getrow(),"deptcode",gs_dept)
	dw_ip.modify("deptcode.protect= 1")
	
	/*부서명*/
	SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :gs_dept ); 
	if sqlca.sqlcode <> 0 then
		sname = ''
	else
		dw_ip.setitem(dw_ip.getrow(),"deptname",sname)
	end if	
	
end if	



end subroutine

public function integer wf_retrieve ();
String sStartYear,sEndYear,sBaseYear,sGubun,sEmpno,sEmpname
string sDeptcode,sDeptname,sPbTag,sPaysubtag,ls_gubun
String sAllowText, snull
Long i

Setnull(snull)

dw_ip.AcceptText()
dw_list.Reset()

sGubun = dw_ip.Getitemstring(1, 'gubun')

//개인별 항목별 월별 대비표
If sGubun = '1' then
	
	dw_list.Dataobject = "d_pyp5000_02"
	dw_list.SetTransobject(sqlca)
	
	sStartYear = dw_ip.GetItemString(1,"ym")
	sEmpno     = dw_ip.Getitemstring(1,'empno')
	sPbTag     = dw_ip.GetItemString(1,"pbtag")
	
	sBaseYear  = Left(sStartYear,4)
	
	 SELECT "P1_MASTER"."EMPNAME"  
    INTO :sEmpname  
    FROM "P1_MASTER"
	 WHERE "P1_MASTER"."EMPNO" = :sEmpno ;
	 
	If sEmpno = '' or Isnull(sEmpno) then
		dw_list.Modify("sawon_t.text = '" + "전  체" + "'" ) 
	Else 
      dw_list.modify("sawon_t.text = '" + sEmpno + " " + sEmpname + "'")
	End If
 	
	IF sStartYear = '' OR IsNull(sStartYear) THEN
	   MessageBox("확 인","기준년월을 입력하세요!!")
	   dw_ip.SetColumn("ym")
	   dw_ip.SetFocus()
		Return -1
	ELSE
		IF f_datechk(sStartYear + '0101') = -1 THEN
			MessageBox("확인","기준년월을 확인하세요")
			dw_ip.SetColumn("ym")
			dw_ip.SetFocus()
			Return -1
		END IF	
	END IF 
	
	IF sEmpno = '' OR Isnull(sEmpno) THEN
	   sEmpno = '%'
	END IF
	
	IF sPbtag = '' OR ISNULL(sPbtag) THEN
 	   sPbtag = '%'
	END IF
	
	SetPointer(HourGlass!)	
	
	dw_list.SetRedraw(False)
	
	IF Not Isnull(sStartYear) then
		DELETE FROM "P3_TMP_YEARPAY"
		COMMIT ;
		
		INSERT INTO "P3_TMP_YEARPAY"	 
					("EMPNO",    "GUBUN",    "ALLOWCODE",   
					 "ALLOWAMT", "PRINTSEQ", "WORKYM",    "PBTAG" )
					 
					 
		 SELECT p3_editdatachild.empno as empno,  /*수당*/
				 '1' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ, 
             p3_editdatachild.workym,
				 p3_editdatachild.pbtag
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode = :gs_company AND 
				 p3_editdatachild.empno like :sEmpno and
				 substr(p3_editdatachild.workym,1,4) = :sBaseYear AND
				 p3_editdatachild.pbtag   like :sPbtag and  
				 P3_ALLOWANCE.paysubtag     = '1'
		
		UNION ALL 
	
		 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
				 '2' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ, 
             p3_editdatachild.workym,
				 p3_editdatachild.pbtag
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode = :gs_company AND 
 				 p3_editdatachild.empno like :sEmpno and
				 substr(p3_editdatachild.workym,1,4) = :sBaseYear AND
				 p3_editdatachild.pbtag  like :sPbtag and  
				 P3_ALLOWANCE.paysubtag     = '2'  ;				 
	
		IF SQLCA.SQLCODE = 0 THEN
			COMMIT ;
		ELSE
			ROLLBACK ;	
		END IF	
	END IF
	 
	IF dw_list.Retrieve(gs_company, sStartYear,sEmpno,sPbtag) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_list.SetRedraw(True)
		Return -1	
	END IF
	
END IF

//부서별 항목별 월별 대비표
If sGubun = '2' then
	
	dw_list.Dataobject = 'd_pyp5000_03'
	dw_list.Settransobject(sqlca)
	
	sStartYear = dw_ip.GetItemString(1,"ym")
	sPbTag     = dw_ip.GetItemString(1,"pbtag")
	sDeptcode  = dw_ip.GetItemString(1,"deptcode")
	sPaysubtag = dw_ip.Getitemstring(1,'paysubtag')
	
	sBaseYear  = Left(sStartYear,4)
	
	 SELECT "P0_DEPT"."DEPTNAME"  
    INTO :sDeptname  
    FROM "P0_DEPT"
	 WHERE "P0_DEPT"."DEPTCODE" = :sDeptcode ;
	 
	If sDeptcode = '' or Isnull(sDeptcode) then
		dw_list.Modify("dept_t.text = '" + "전  체" + "'" ) 
	Else 
      dw_list.modify("dept_t.text = '" + sDeptcode + " " + sDeptname + "'")
	End If
	
	IF sStartYear = '' OR IsNull(sStartYear) THEN
	   MessageBox("확 인","기준년월을 입력하세요!!")
	   dw_ip.SetColumn("ym")
	   dw_ip.SetFocus()
		Return -1
	ELSE
		IF f_datechk(sStartYear + '0101') = -1 THEN
			MessageBox("확인","기준년월을 확인하세요")
			dw_ip.SetColumn("ym")
			dw_ip.SetFocus()
			Return -1
		END IF	
	END IF 
	
	IF sDeptcode = '' OR Isnull(sDeptcode) THEN
	   sDeptcode = '%'
	END IF

	IF sPbtag = '' OR ISNULL(sPbtag) THEN
 	   sPbtag = '%'
	END IF
	
	IF sPaysubtag = '' OR Isnull(sPaysubtag) THEN
	   sPaysubtag = '%'
	END IF
	
	SetPointer(HourGlass!)	
	
	dw_list.SetRedraw(False)
	
	IF Not Isnull(sStartYear) then
		DELETE FROM "P3_TMP_YEARPAY"
		COMMIT ;
		
		INSERT INTO "P3_TMP_YEARPAY"	 
					("EMPNO",    "GUBUN",    "ALLOWCODE",   
					 "ALLOWAMT", "PRINTSEQ", "WORKYM",    "PBTAG" )
		SELECT B.empno as empno,  /*기본급*/
				 '1' as gubun,
				 '01' as allowcode,
				 Decode(B.paygubn, '1', A.basepay, '2', A.basepay,0) AS basepay,
				 C.PRINTSEQ, A.WORKYM,
				 A.pbtag AS pbtag		  
		FROM   p3_editdata A, p1_master B, p3_allowance C
		WHERE  A.companycode = B.companycode and 
				 A.empno       = B.empno  and
				 A.companycode = :gs_company and
				 B.deptcode LIKE :sDeptcode and
				 Substr(A.workym,1,4) = :sBaseYear and
				 A.pbtag like :sPbtag AND
				 C.allowcode = '01' AND
				 C.paysubtag = '1'
		UNION ALL 
		SELECT  A.empno  as empno, /*관리직연장수당 */
				 '1' as gubun,
				 '03' as allowcode,
				 A.defaultallow2 as amt,
				 C.PRINTSEQ, A.WORKYM,
				 A.pbtag AS pbtag			  
		FROM   p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE  A.companycode = B.companycode and 
				 A.empno       = B.empno  and
				 A.companycode =:gs_company and
				 B.deptcode LIKE :sDeptcode and
				 substr(A.workym,1,4) =:sBaseYear and
				 A.pbtag like :sPbtag AND
				 C.allowcode = '03' AND
				 C.paysubtag = '1'
		UNION ALL 
		SELECT  A.empno  as empno, /*직책수당 */
				 '1' as gubun,
				 '02' as allowcode,
				 A.defaultallow1 as amt,
				 C.PRINTSEQ, A.WORKYM,
				 A.pbtag AS pbtag		  
		FROM   p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE  A.companycode = B.companycode and 
				 A.empno       = B.empno  and
				 A.companycode =:gs_company and
				 B.deptcode LIKE :sDeptcode and
				 substr(A.workym,1,4) =:sBaseYear and
				 A.pbtag like :sPbtag AND
				 C.allowcode = '02' AND
				 C.paysubtag = '1'
		UNION ALL
		SELECT p3_editdatachild.empno as empno,  /*기타수당*/
				'1' AS GUBUN,
				p3_editdatachild.allowcode,
				p3_editdatachild.allowamt as amt,
				P3_ALLOWANCE.PRINTSEQ, P3_editdatachild.workym,
				p3_editdatachild.pbtag AS pbtag
		FROM  p3_editdatachild,P3_ALLOWANCE
		WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				p3_editdatachild.companycode =:gs_company AND 
				substr(p3_editdatachild.workym,1,4) = :sBaseYear AND
				p3_editdatachild.pbtag     like :sPbtag and  
				P3_ALLOWANCE.paysubtag     = '1'
		UNION ALL  
		SELECT A.empno  as empno,    /*공제부분*/
				'2' as gubun,
				'01' as allowcode,
				A.incometax as amt,
				C.PRINTSEQ, A.WORKYM,
				A.pbtag AS pbtag	  
		FROM  p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE A.companycode = B.companycode and 
				A.empno       = B.empno  and
				A.companycode =:gs_company and
				B.deptcode LIKE :sDeptcode and
				substr(A.workym,1,4) =:sBaseYear and
				A.pbtag like :sPbtag AND
				C.allowcode = '01' AND
				C.paysubtag = '2'
		UNION ALL
		SELECT A.empno  as empno, /*주민세*/
				'2' as gubun,
				'02' as allowcode,
				A.residenttax as amt ,
				C.PRINTSEQ, A.WORKYM,
				A.pbtag AS pbtag		  
		FROM  p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE A.companycode = B.companycode and 
				A.empno       = B.empno  and
				A.companycode =:gs_company and
				B.deptcode LIKE :sDeptcode and
				substr(A.workym,1,4) =:sBaseYear and
				A.pbtag like :sPbtag AND
				C.allowcode = '02' AND
				C.paysubtag = '2'
		UNION ALL   /*고용보험*/
		SELECT A.empno  as empno,
				'2' as gubun,
				'05' as allowcode,
				A.employeeinsurance as amt ,
				C.PRINTSEQ, A.WORKYM,
				A.pbtag AS pbtag		  
		FROM  p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE A.companycode = B.companycode and 
				A.empno       = B.empno  and
				A.companycode =:gs_company and
				B.deptcode LIKE :sDeptcode and
				substr(A.workym,1,4) =:sBaseYear and
				A.pbtag like :sPbtag AND
				C.allowcode = '05' AND
				C.paysubtag = '2'
		UNION ALL   /*국민연금*/
		SELECT A.empno  as empno,
				'2' as gubun, 
				'03' as allowcode,
				A.penamt  as amt ,
				C.PRINTSEQ, A.WORKYM,
				A.pbtag AS pbtag		  
		FROM  p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE A.companycode = B.companycode and 
				A.empno       = B.empno  and
				A.companycode =:gs_company and
				B.deptcode LIKE :sDeptcode and
				substr(A.workym,1,4) =:sBaseYear and
				A.pbtag like :sPbtag AND
				C.allowcode = '03' AND
				C.paysubtag = '2'
		UNION ALL   /*의료보험*/
		SELECT A.empno  as empno,
				'2' as gubun,
				'04' as allowcode,
				A.medamt as amt ,
				C.PRINTSEQ, A.WORKYM,
				A.pbtag AS pbtag		  
		FROM  p3_editdata A, p1_master B,P3_ALLOWANCE C
		WHERE A.companycode = B.companycode and 
				A.empno       = B.empno  and
				A.companycode =:gs_company and
				B.deptcode LIKE :sDeptcode and
				substr(A.workym,1,4) =:sBaseYear and
				A.pbtag like :sPbtag AND
				C.allowcode = '04' AND
				C.paysubtag = '2'
		UNION ALL
		SELECT p3_editdatachild.empno as empno,  /*기타공제*/
				'2' AS GUBUN,
				p3_editdatachild.allowcode,
				p3_editdatachild.allowamt as amt,
				P3_ALLOWANCE.PRINTSEQ, p3_editdatachild.WORKYM,
				p3_editdatachild.pbtag AS pbtag
		FROM  p3_editdatachild,P3_ALLOWANCE
		WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				p3_editdatachild.companycode =:gs_company AND 
				substr(p3_editdatachild.workym,1,4) =:sBaseYear AND
				p3_editdatachild.pbtag    like :sPbtag and  
				P3_ALLOWANCE.paysubtag     = '2'  ;
		IF SQLCA.SQLCODE = 0 THEN
			COMMIT ;
		ELSE
			ROLLBACK ;	
		END IF	
	END IF

	IF dw_print.Retrieve(gs_company, sStartYear,sDeptcode,sPbtag,sPaysubtag) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_print.SetRedraw(True)
		Return -1	
	END IF
	
END IF
dw_print.sharedata(dw_list)	
dw_list.SetRedraw(True)
SetPointer(Arrow!)	

Return 1
end function

on w_pyp5000.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.rr_1
end on

on w_pyp5000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_3.settransobject(sqlca)

sle_msg.text = "출력물 - 용지크기 : A4 , 출력방향 : 가로방향"

dw_ip.SetITem(1,"ym",Left(String(gs_today,'@@@@@@@@'), 4))
end event

type p_preview from w_standard_print`p_preview within w_pyp5000
end type

type p_exit from w_standard_print`p_exit within w_pyp5000
end type

type p_print from w_standard_print`p_print within w_pyp5000
end type

type p_retrieve from w_standard_print`p_retrieve within w_pyp5000
end type







type st_10 from w_standard_print`st_10 within w_pyp5000
end type



type dw_print from w_standard_print`dw_print within w_pyp5000
integer x = 3877
integer y = 2256
end type

type dw_ip from w_standard_print`dw_ip within w_pyp5000
integer x = 0
integer y = 0
integer width = 2862
integer height = 300
string dataobject = "d_pyp5000_01"
end type

event dw_ip::itemchanged;string sdwgubn,sDeptno,SetNull,sName 
string sEmpno, sEmpname

setnull(SetNull)
dw_ip.AcceptText()

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

IF dw_ip.Getcolumnname() = 'empno' then
	sEmpno = dw_ip.Gettext()
	If sEmpno = '' or Isnull(sEmpno) then
		dw_ip.Setitem(1, 'empno', SetNull)
		dw_ip.Setitem(1, 'empname', SetNull)
		Return
	End If
	
	Select p1_master.empname
	  Into :sEmpname
	  From p1_master
	 Where ( p1_master.Companycode = :gs_company )
	   and ( p1_master.empno = :sEmpno ) ;
		
	If sEmpname = '' or Isnull(sEmpname) then
		MessageBox("확 인","사원번호를 확인하세요!!")
		dw_ip.Setitem(1,'empno',SetNull)
		dw_ip.Setitem(1,'empname',SetNull)
		dw_ip.Setcolumn('empno')
		dw_ip.Setfocus()
		Return 1
	End If
	dw_ip.Setitem(1,'empname',sEmpname)
End If



end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;IF dw_ip.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)


	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	dw_ip.SetITem(1,"deptname",gs_codename)
	
END IF	

IF dw_ip.GetColumnName() = "empno" THEN
	SetNull(gs_code)
	SetNull(gs_codename)


	Open(w_employee_popup)
	

	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"empno",gs_code)
	dw_ip.SetITem(1,"empname",gs_codename)
	
END IF	
end event

type dw_list from w_standard_print`dw_list within w_pyp5000
integer x = 23
integer y = 320
integer height = 1908
string dataobject = "d_pyp5000_02"
boolean border = false
end type

type dw_1 from datawindow within w_pyp5000
boolean visible = false
integer x = 727
integer y = 2300
integer width = 553
integer height = 84
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string dataobject = "dp_pip3120_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_pyp5000
boolean visible = false
integer x = 1330
integer y = 2300
integer width = 553
integer height = 84
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pyp5000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 312
integer width = 4617
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

