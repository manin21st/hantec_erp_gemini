$PBExportHeader$w_pik1111.srw
$PBExportComments$** �ϱ��� ���� �� ����
forward
global type w_pik1111 from w_inherite_standard
end type
type cb_calc from commandbutton within w_pik1111
end type
type st_2 from statictext within w_pik1111
end type
type dw_2 from u_d_select_sort within w_pik1111
end type
type p_action from uo_picture within w_pik1111
end type
type p_1 from uo_picture within w_pik1111
end type
type p_2 from uo_picture within w_pik1111
end type
type gb_3 from groupbox within w_pik1111
end type
type rr_1 from roundrectangle within w_pik1111
end type
type dw_3 from u_key_enter within w_pik1111
end type
type dw_1 from u_key_enter within w_pik1111
end type
end forward

global type w_pik1111 from w_inherite_standard
event ue_postopen ( )
cb_calc cb_calc
st_2 st_2
dw_2 dw_2
p_action p_action
p_1 p_1
p_2 p_2
gb_3 gb_3
rr_1 rr_1
dw_3 dw_3
dw_1 dw_1
end type
global w_pik1111 w_pik1111

type variables
Boolean Ib_DetailFlag = False
string  ls_dkdeptcode, timegubn
int time_row
Double    dYkTime

String print_gu                 //window�� ��ȸ���� �μ�����  

String     is_preview        // dw���°� preview����
Integer   ii_factor = 100           // ����Ʈ Ȯ�����
boolean   iv_b_down = false

end variables

forward prototypes
public function integer wf_check_remainday (integer icurrow, string sempno, string skdate, string scode, string sflag)
public function double wf_conv_hhmm (double dtime)
public subroutine wf_init_clear (integer ll_currow, string ls_addgubn)
public function integer wf_insert_dkentae (double cktime, double tgtime)
public function integer wf_modify_ktype (long ll_row, string ls_ktype, boolean lb_codecheck)
public subroutine wf_reset ()
public subroutine wf_set_sqlsyntax (string sdate, string sdept)
end prototypes

event ue_postopen();string ls_chtime, ls_tgtime, ls_kdate, ls_deptcode, ls_jikjong, sSaup, sKunmu
int cnt

select dataname into :ls_chtime
from p0_syscnfg
where sysgu = 'P' and
		serial = '3' and
		lineno = '1' ;

select dataname into :ls_tgtime
from p0_syscnfg
where sysgu = 'P' and
		serial = '3' and
		lineno = '2' ;

dw_3.SetItem(1,'chtime',long(ls_chtime))
dw_3.SetItem(1,'tgtime',long(ls_tgtime))

if dw_1.accepttext() = -1 then return

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
ls_jikjong = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong'))
sSaup = trim(dw_1.Getitemstring(dw_1.getrow(),'saup'))
sKunmu = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu'))

IF ls_kdate = ""		OR IsNull(ls_kdate)		THEN return
IF ls_deptCode = ""	OR IsNull(ls_deptCode)	THEN ls_DeptCode = '%'
IF ls_jikjong = ""	OR IsNull(ls_jikjong)	THEN ls_jikjong = '%'
IF sSaup = ""  		OR IsNull(sSaup)			THEN sSaup = '%'
IF sKunmu = ""  		OR IsNull(sKunmu)			THEN sKunmu = '%'

select count(*) into :cnt
from   p4_dkentae a, p1_master b, p0_dept c
where  a.companycode = :gs_company and
       a.kdate = :ls_kdate and
		 a.deptcode like :ls_deptcode and
		 a.companycode = c.companycode and
		 a.deptcode = c.deptcode and
		 c.saupcd LIKE :sSaup and
		 a.jikjonggubn like :ls_jikjong and
		 a.empno = b.empno and
		 b.kunmugubn LIKE :sKunmu;
IF cnt > 0 THEN
	p_inq.TriggerEvent(Clicked!)
ELSE
	IF MessageBox('Ȯ��','������ ���� �ڷᰡ �����ϴ�.~r~n�����ڷḦ �����Ͻðڽ��ϱ�?',Question!,YesNo!) = 1 THEN
		p_search.TriggerEvent(Clicked!)
		p_can.Enabled = True
		p_can.PictureName = "C:\erpman\image\���_up.gif"
	END IF
END IF
end event

public function integer wf_check_remainday (integer icurrow, string sempno, string skdate, string scode, string sflag);String  sYearMonth,sSex,sFromDate,sToDate,snull, sentdate
Integer lYDay,lCnt

SetNull(snull)

sYearMonth = Left(sKDate, 4) + Mid(sKDate, 5, 2)
		
///* ���� üũ */
//if sFlag = "1" then			
//	SELECT "P4_MONTHLIST"."YDAY" + "P4_MONTHLIST"."BDAY"				/*�̿��ϼ� + �߻��ϼ�*/
//		INTO :lYDay  
//	   FROM "P4_MONTHLIST"  
//	   WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
//			   ( "P4_MONTHLIST"."YYMM" = :sYearMonth ) AND  ( "P4_MONTHLIST"."EMPNO" = :sempno )   ;
//	IF sqlca.sqlcode <> 0 THEN
//		messagebox("Ȯ��", "������ ����Ҽ� �����ϴ� (���� ���� Ȯ��) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1
//	END IF	  
//	
//	/*����ϼ� = �ϱ����� '����'�����ڵ�Ƚ��(�۾��ϰ� �ִ� �������� ����)*/		
//	SELECT count("P4_DKENTAE"."KTCODE")  			
//		INTO :lCnt  
//		FROM "P4_DKENTAE"  
//		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
//			   ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
//				( substr("P4_DKENTAE"."KDATE",1,6) = :sYearMonth ) AND  
//				( "P4_DKENTAE"."KTCODE" = :scode )   AND
//				( "P4_DKENTAE"."KDATE" <> :sKDate) ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		lCnt = 0
//	ELSE
//		IF IsNull(lCnt) THEN lCnt =0
//	END IF
//	
//	IF lYDay - lCnt < 1 then					/*�ܿ��ϼ�*/
//		messagebox("Ȯ��", "������ ����Ҽ� �����ϴ� (�ܿ����� Ȯ��) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1	
//	END IF
//END IF
//
///* ���� Ȯ�� */
if sFlag = "2" then
	SELECT "P4_YEARLIST"."CDAY", 
			 "P4_YEARLIST"."KDATE", "P4_YEARLIST"."KDATETO"
		INTO :lYDay , :sFromDate, :sToDate 
		FROM "P4_YEARLIST"  
		WHERE ( "P4_YEARLIST"."COMPANYCODE" = :gs_company ) AND  
			   ( "P4_YEARLIST"."EMPNO" = :sempno ) AND 
				( "P4_YEARLIST"."KDATE" <= :sKDate ) AND
				( "P4_YEARLIST"."KDATETO" >= :sKDate ) and
				( "P4_YEARLIST"."YYMM" = (select max(yymm) from p4_yearlist
				                          where companycode = :gs_company and
												        empno = :sempno ));
				
	if sqlca.sqlcode <> 0 then
		messagebox("Ȯ��", "������ ����Ҽ� �����ϴ�. !! ~r(�ѹ����� ���������� �Ƿ��Ͻʽÿ�.) ")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	END IF
			
	SELECT count("P4_DKENTAE"."KTCODE")  		/*����ϼ�*/
		INTO :lCnt  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
				( "P4_DKENTAE"."KDATE" >= :sFromDate ) AND  
				( "P4_DKENTAE"."KDATE" <= :sToDate ) AND  
				( "P4_DKENTAE"."KTCODE" = :scode );
	if SQLCA.SqLCODE <> 0 THEN
		lCnt = 0
	ELSE
		IF IsNull(lCnt) THEN lCnt =0
	END IF

//	  select substr(enterdate,1,4) into :sentdate
//	  from p1_master
//	  where companycode = :gs_company and
//	        empno = :sempno;
//			  
//	if string(long(sentdate) + 1) = Left(sKDate, 4) and lYday  = 1 and lCnt = 0 then
//		messagebox("Ȯ��", "������ ����Ҽ� �����ϴ� (1��̸���) !!")
//		return -1
//	end if
	  
	IF lYDay - lCnt < 1 then								//�ܿ��ϼ�
		messagebox("Ȯ��", "������ ����Ҽ� �����ϴ� (�ܿ�����Ȯ��) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if	
END IF

/* �����ϼ� üũ */
if sFlag = "3" then
	sSex = dw_2.getitemstring(iCurRow , "sex")	
	if sSex = '1' then  										//���ڻ�� ������� check
		messagebox("Ȯ��","�������� �����ް� ����� �����մϴ�.!!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if					
   
	SELECT count("P4_DKENTAE"."KTCODE")  					//����ϼ�
		INTO :lCnt  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
				( substr("P4_DKENTAE"."KDATE",1,6) = :sYearMonth ) AND  
				( "P4_DKENTAE"."KDATE" <> :sKDate ) AND  
				( "P4_DKENTAE"."KTCODE" = :scode )   ;
	IF lCnt > 0  then
		messagebox("Ȯ��", "������ ����Ҽ� �����ϴ� (�̹̻��) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if	
END IF	

Return 1

end function

public function double wf_conv_hhmm (double dtime);/*���� 60�� ���� ��� �ð��� add ó��*/

Int iMM
//Int iHH,iMM
//
//iHH = Integer(Left(String(dTime,'00.00'),2))								/*�ð�*/
//iMM = Integer(Mid(String(dTime,'00.00'),4,2))								/*��*/
//	
//IF iMM >= 60 THEN
//	iMM = iMM - 60
//	iHH = iHH + 1
//	dTime = Round(((iHH * 100) + iMM)/100,2) 
//END IF

iMM   = Mod(dTime,60)
dTime = Truncate(dTime / 60,0)

dTime = (dTime + (iMM / 100))

Return dTime
	
end function

public subroutine wf_init_clear (integer ll_currow, string ls_addgubn);String ls_null

SetNull(ls_null)
//dw_2.SetItem(ll_currow,"jkgubn",'0')
//dw_2.SetItem(ll_currow,"jkgtime",0)
//dw_2.SetItem(ll_currow,"jktime",0)
//dw_2.SetItem(ll_currow,"occnt",0)
//dw_2.SetItem(ll_currow,"ocfromtime",0)
//dw_2.SetItem(ll_currow,"octotime",0)
//dw_2.SetItem(ll_currow,"ocgttime",0)
//dw_2.SetItem(ll_currow,"ocggtime",0)
//dw_2.SetItem(ll_currow,"jtgubn",'0')
//dw_2.SetItem(ll_currow,"jtgktime",0)
//dw_2.SetItem(ll_currow,"jtgytime",0)
//dw_2.SetItem(ll_currow,"jttime",0)
//dw_2.SetItem(ll_currow,"okfromtime",0)
//dw_2.SetItem(ll_currow,"oktotime",0)
//dw_2.SetItem(ll_currow,"ykgtime100",0)
//dw_2.SetItem(ll_currow,"hkcygtime",0)
//dw_2.SetItem(ll_currow,"dktime",0)
//dw_2.SetItem(ll_currow,"dkgtime",0)

dw_2.SetItem(ll_currow,"kmgubn",ls_null)
dw_2.SetItem(ll_currow,"cktime",0)
dw_2.SetItem(ll_currow,"tktime",0)

IF ls_addgubn = '1' THEN
	dw_2.SetItem(ll_currow,"klgtime",8)
ELSE
	dw_2.SetItem(ll_currow,"klgtime",0)
END IF

dw_2.SetItem(ll_currow,"yjgtime",0)
dw_2.SetItem(ll_currow,"ykgtime",0)
dw_2.SetItem(ll_currow,"hkgtime",0)
dw_2.SetItem(ll_currow,"hkyjgtime",0)
dw_2.SetItem(ll_currow,"hkgtime2",0)
dw_2.SetItem(ll_currow,"jchgtime",0)
dw_2.SetItem(ll_currow,"lungtime",0)

end subroutine

public function integer wf_insert_dkentae (double cktime, double tgtime);string ls_kdate, ls_deptcode, sdaygbn,shday, ls_jikjong, ls_type, ls_saup, ls_kunmu
int cnt

if dw_1.accepttext() = -1 then return -1

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
ls_jikjong = dw_1.Getitemstring(dw_1.getrow(),'jjong')
ls_type = dw_1.Getitemstring(dw_1.getrow(),'ktype')
ls_saup = dw_1.Getitemstring(dw_1.getrow(),'saup')
ls_kunmu = dw_1.Getitemstring(dw_1.getrow(),'kunmu')

IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'
IF ls_jikjong = ""  OR IsNull(ls_jikjong)  THEN ls_jikjong = '%'
IF ls_type = ""  OR IsNull(ls_type)  THEN ls_type = '%'
IF ls_saup = ""  OR IsNull(ls_saup)  THEN ls_saup = '%'
IF ls_kunmu = ""  OR IsNull(ls_kunmu)  THEN ls_kunmu = '%'

select count(*) into :cnt
from	 p4_dkentae a, p1_master b, p0_dept c
where  a.companycode = :gs_company and
		 a.companycode = b.companycode and
		 a.companycode = c.companycode and
		 a.empno = b.empno and
       a.kdate = :ls_kdate and
		 a.deptcode like :ls_deptcode and
		 a.jikjonggubn like :ls_jikjong and
		 b.kunmugubn like :ls_kunmu and
		 b.deptcode = c.deptcode and
		 c.saupcd like :ls_saup	 ;
		
select daygubn, hdaygubn into :sdaygbn, :shday
from p4_calendar
where companycode = :gs_company and
      cldate = :ls_kdate;
		


if cnt > 0 then

//	UPDATE p4_dkentae
//		SET cktime = :cktime,
//	   	 tktime = :tgtime,
//			 kmgubn = :ls_ktype,
//			 KLGTIME = (select kltime from p0_ktype where ktype = :ls_ktype),
//			 YJGTIME = (select yjtime from p0_ktype where ktype = :ls_ktype),
//	 		 YKGTIME = (select yktime from p0_ktype where ktype = :ls_ktype),
//			 HKGTIME = (select hktime from p0_ktype where ktype = :ls_ktype),
//			 HKGTIME2 = (select hltime from p0_ktype where ktype = :ls_ktype),
//			 JCHGTIME = (select jctime from p0_ktype where ktype = :ls_ktype),
//			 LUNGTIME = (select jstime from p0_ktype where ktype = :ls_ktype),
//			 HKYJGTIME = (select hyjtime from p0_ktype where ktype = :ls_ktype)
//	WHERE  companycode = :gs_company and
//			 kdate = :ls_kdate and
//			 deptcode like :ls_deptcode and
//			 jikjonggubn like :ls_jikjong;

//DELETE FROM P4_DKENTAE
//		WHERE	companycode = :gs_company and
//				kdate = :ls_kdate and
//				deptcode like :ls_deptcode and
//				jikjonggubn like :ls_jikjong;


DELETE FROM P4_DKENTAE A
where  A.companycode = :gs_company and
       A.kdate = :ls_kdate and
		 A.deptcode like :ls_deptcode and
		 A.jikjonggubn like :ls_jikjong and
		 A.empno in (select A.empno
						   from P4_DKENTAE A, p1_master B, p0_dept C
						  where A.companycode = B.companycode and
						 		  A.empno = B.empno and
						 		  B.kunmugubn like :ls_kunmu and
						 		  A.companycode = C.companycode and
						 		  B.deptcode = C.deptcode and
					   		  C.saupcd like :ls_saup) ;
		
//messagebox("UPDATE","�����ϴ� �ڷḦ �����մϴ�.")
//else
//messagebox("INSERT","�������� �ʴ� �ڷḦ �����մϴ�.")	
end if

if sdaygbn = '1' then //�Ͽ���
   INSERT INTO "P4_DKENTAE"
         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
 SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
 			    	  c.cktime,       c.tktime,    b.stype   , c.kltime,		 c.yjtime,		 c.yktime,
					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
 FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
 WHERE	a.companycode = :gs_company and
       	a.deptcode like :ls_deptcode and
		 	//a.servicekindcode <> '2' and
		 	a.enterdate  <= :ls_kdate  AND
      	(a.retiredate  >= :ls_kdate  OR
       	a.retiredate is null OR
       	a.retiredate = ' ') and
			a.empno = d.empno(+) and
         d.kdate(+) = :ls_kdate and 
		 	a.empno = b.empno and
		 	b.stype = c.ktype and
			a.kunmugubn like :ls_kunmu and
			a.jikjonggubn like :ls_jikjong and
			a.companycode = e.companycode and
			a.deptcode = e.deptcode and
			e.saupcd like :ls_saup and
			a.LEVELCODE = f.LEVELCODE AND
			f.GUBUN <> '0';
elseif sdaygbn <> '1' and shday <> '0' then  //������
	    INSERT INTO "P4_DKENTAE"
         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
 SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
 			    	  c.cktime,       c.tktime,    b.htype   , c.kltime,		 c.yjtime,		 c.yktime,
					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
 FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
 WHERE	a.companycode = :gs_company and
       	a.deptcode like :ls_deptcode and
		 	//a.servicekindcode <> '2' and
		 	a.enterdate  <= :ls_kdate  AND
      	(a.retiredate  >= :ls_kdate  OR
       	a.retiredate is null OR
       	a.retiredate = ' ') and
			a.empno = d.empno(+) and
         d.kdate(+) = :ls_kdate and 
		 	a.empno = b.empno and
		 	b.htype = c.ktype and
			a.kunmugubn like :ls_kunmu and
			a.jikjonggubn like :ls_jikjong and
			a.companycode = e.companycode and
			a.deptcode = e.deptcode and
			e.saupcd like :ls_saup and
			a.LEVELCODE = f.LEVELCODE AND
			f.GUBUN <> '0';
elseif sdaygbn = '7' and shday = '0' then  //�����
	     INSERT INTO "P4_DKENTAE"
         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
 SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
 			    	  c.cktime,       c.tktime,    b.satype   , c.kltime,		 c.yjtime,		 c.yktime,
					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
 FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
 WHERE	a.companycode = :gs_company and
       	a.deptcode like :ls_deptcode and
		 	//a.servicekindcode <> '2' and
		 	a.enterdate  <= :ls_kdate  AND
      	(a.retiredate  >= :ls_kdate  OR
       	a.retiredate is null OR
       	a.retiredate = ' ') and
			a.empno = d.empno(+) and
         d.kdate(+) = :ls_kdate and 
		 	a.empno = b.empno and
		 	b.satype = c.ktype and
			a.kunmugubn like :ls_kunmu and
			a.jikjonggubn like :ls_jikjong and
			a.companycode = e.companycode and
			a.deptcode = e.deptcode and
			e.saupcd like :ls_saup and
			a.LEVELCODE = f.LEVELCODE AND
			f.GUBUN <> '0';
else                                       //����
	      INSERT INTO "P4_DKENTAE"
         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",   "JIKJONGGUBN",		  "KDATE",    "HDAYGUBN",
			    	 "CKTIME",      "TKTIME",		"KMGUBN", 		 "KLGTIME", 	"YJGTIME", 		"YKGTIME",
				 "KTCODE",        "HKGTIME", 	  "HKGTIME2",	   "JCHGTIME",		"LUNGTIME",  "HKYJGTIME", "HKCYGTIME" )
 SELECT      a.companycode,    a.deptcode,      a.empno,     a.jikjonggubn,	   :ls_kdate,        :shday,
 			    	  c.cktime,       c.tktime,    b.ktype   , c.kltime,		 c.yjtime,		 c.yktime,
					d.ktcode,       c.hktime,	   c.hltime,		c.jctime,		  c.jstime,		c.hyjtime, c.hyktime
 FROM		p1_master a, p1_ktype b, p0_ktype c, p4_dkentae d, p0_dept e, "P0_LEVEL" f
 WHERE	a.companycode = :gs_company and
       	a.deptcode like :ls_deptcode and
		 	//a.servicekindcode <> '2' and
		 	a.enterdate  <= :ls_kdate  AND
      	(a.retiredate  >= :ls_kdate  OR
       	a.retiredate is null OR
       	a.retiredate = ' ') and
			a.empno = d.empno(+) and
         d.kdate(+) = :ls_kdate and 
		 	a.empno = b.empno and
		 	b.ktype = c.ktype and
			a.kunmugubn like :ls_kunmu and
			a.jikjonggubn like :ls_jikjong and
			a.companycode = e.companycode and
			a.deptcode = e.deptcode and
			e.saupcd like :ls_saup and
			a.LEVELCODE = f.LEVELCODE AND
			f.GUBUN <> '0';
end if

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("����","��������!~r" + sqlca.sqlErrText)
	return -1
end if

/*�������� �� ������ �����ڵ� ����*/
DECLARE SP_HOLIKUNTAE PROCEDURE FOR SP_CREATE_HOLIKUNTAE(:gs_saupcd, :ls_kdate);
EXECUTE SP_HOLIKUNTAE;

IF TRIM(SQLCA.SQLERRTEXT) <> '' THEN
	MessageBox('DB Procedure Error',SQLCA.SQLERRTEXT)
END IF

return 1

end function

public function integer wf_modify_ktype (long ll_row, string ls_ktype, boolean lb_codecheck);String	ls_KtCode, ls_AttTime
Double	ld_Cktime, ld_Tktime, ld_col[8]

ls_KtCode	= dw_2.GetItemString(ll_row,'ktcode')
ls_AttTime	= dw_2.GetItemString(ll_row,'attendancetime')

dw_3.AcceptText()
ld_Cktime = dw_3.GetItemNumber(1,'chtime')
ld_Tktime = dw_3.GetItemNumber(1,'tgtime')
IF ld_Cktime = 0 OR ld_Tktime = 0 THEN
	messagebox("Ȯ��","����ٽð��� Ȯ���ϼ���!")
	Return -1
END IF

SELECT	kltime, yjtime, yktime, hktime, hltime, jctime, jstime, hyjtime
  INTO	:ld_col[1], :ld_col[2], :ld_col[3], :ld_col[4], :ld_col[5], :ld_col[6], :ld_col[7], :ld_col[8]
  FROM 	p0_ktype
  WHERE	ktype = :ls_ktype;

IF isnull(ls_KtCode) OR trim(ls_KtCode) = '' OR ls_AttTime = '1' THEN
	dw_2.SetItem(ll_row,'KMGUBN',ls_ktype)
	dw_2.SetItem(ll_row,'CKTIME',ld_Cktime)
	dw_2.SetItem(ll_row,'TKTIME',ld_Tktime)
	dw_2.SetItem(ll_row,'KLGTIME',ld_col[1])
	dw_2.SetItem(ll_row,'YJGTIME',ld_col[2])
	dw_2.SetItem(ll_row,'YKGTIME',ld_col[3])
	dw_2.SetItem(ll_row,'HKGTIME',ld_col[4])
	dw_2.SetItem(ll_row,'HKGTIME2',ld_col[5])
	dw_2.SetItem(ll_row,'JCHGTIME',ld_col[6])
	dw_2.SetItem(ll_row,'LUNGTIME',ld_col[7])
	dw_2.SetItem(ll_row,'HKYJGTIME',ld_col[8])
	ib_any_typing = TRUE
	Return 1
ELSEIF lb_codecheck = TRUE THEN
	MessageBox('Ȯ��','�ð� �Է��� �Ұ����� �����Դϴ�!~r~rŸ���� ����Ϸ��� ���� ���¸� �����ϼ���.')
END IF

Return -1
end function

public subroutine wf_reset ();String sHdayName,sDayName,snull,sabu, smessage
double sStartTime, sEndTime

dw_1.reset()
dw_1.Insertrow(0)

dw_1.setitem(dw_1.getrow(),"kdate",gs_today)
f_daygubun(gs_today,sDayName, sHdayName)


dw_1.setitem(1,"kweek",sDayName)
dw_1.setitem(1,"kgubun",sHdayName)


SELECT "SYSCNFG"."DATANAME"  														/*��ٽð�*/
	INTO :sStartTime
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "SYSCNFG"."SERIAL" = 3 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
dw_3.SetItem(1,"chtime",sStartTime)

SELECT "SYSCNFG"."DATANAME"  														/*��ٽð�*/
	INTO :sEndTime
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "SYSCNFG"."SERIAL" = 3 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )   ;
dw_3.SetItem(1,"tgtime",sEndTime)


select saupcd into :sabu
from p0_dept
where deptcode = :gs_dept;


		
//// ȯ�溯�� ���´��μ� 
//Smessage = sqlca.fun_get_authority(gs_dept)
//
//if Smessage = 'ALL'  then
//	dw_1.setitem(dw_1.getrow(),"deptcode",SetNull(snull))
//	dw_1.modify("kdate.protect= 0")
//	dw_1.modify("deptcode.protect= 0")
//	ls_dkdeptcode = gs_dept
//elseif Smessage = 'PART' then
//	
//	dw_1.setitem(dw_1.getrow(),"deptcode",SetNull(snull))
//	dw_1.modify("kdate.protect= 1")
//	dw_1.modify("deptcode.protect= 0")
//	cb_retrieve.TriggerEvent(Clicked!)
//else
//	dw_1.setitem(dw_1.getrow(),"deptcode",gs_dept)
//	dw_1.modify("kdate.protect= 1")
//	dw_1.modify("deptcode.protect= 1")
//	cb_retrieve.TriggerEvent(Clicked!)
//end if	


sle_msg.text =""

ib_any_typing = False
ib_detailflag = False


end subroutine

public subroutine wf_set_sqlsyntax (string sdate, string sdept);
String sGetSqlSyntax,sGbn1,sGbn2
Long   lSyntaxLength


sGetSqlSyntax = dw_2.GetSqlSelect()

sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."KDATE" = ' + "'" + sdate +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P4_DKENTAE"."DEPTCODE" LIKE ' + "'" + sdept +"'"+")"


dw_2.SetSQLSelect(sGetSqlSyntax)	





end subroutine

event open;call super::open;
dw_datetime.InsertRow(0)

w_mdi_frame.sle_msg.text =""

ib_any_typing=False

Wf_Reset()

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_3.insertrow(0)

f_set_saupcd(dw_1, 'saup', '1')
is_saupcd = gs_saupcd

p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\���_d.gif"

event ue_postopen()
end event

on w_pik1111.create
int iCurrent
call super::create
this.cb_calc=create cb_calc
this.st_2=create st_2
this.dw_2=create dw_2
this.p_action=create p_action
this.p_1=create p_1
this.p_2=create p_2
this.gb_3=create gb_3
this.rr_1=create rr_1
this.dw_3=create dw_3
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_calc
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.p_action
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.gb_3
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.dw_3
this.Control[iCurrent+10]=this.dw_1
end on

on w_pik1111.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_calc)
destroy(this.st_2)
destroy(this.dw_2)
destroy(this.p_action)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.dw_3)
destroy(this.dw_1)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1111
integer x = 3886
integer y = 144
end type

event p_mod::clicked;call super::clicked;
IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_2.RowCount() < 0 THEN RETURN


IF MessageBox("Ȯ ��","�����Ͻðڽ��ϱ�?",Question!,YesNo!) = 2 THEN RETURN

IF dw_2.Update() <> 1 THEN
	MessageBox("Ȯ ��","�ڷ� ������ �����Ͽ����ϴ�!!")
	ROLLBACK;
	Return
END IF

COMMIT;
p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\���_d.gif"

ib_any_typing = false
w_mdi_frame.sle_msg.text ="�ڷᰡ ����Ǿ����ϴ�!"


end event

type p_del from w_inherite_standard`p_del within w_pik1111
integer x = 4059
integer y = 144
end type

event p_del::clicked;call super::clicked;Int iSelectedRow, li_Cnt, i
string ls_kjgubn1 ,ls_kjgubn2

li_Cnt = dw_2.RowCount()
IF li_Cnt <=0 THEN RETURN

iSelectedRow = dw_2.GetRow()
IF iSelectedRow <=0 THEN
	MessageBox("Ȯ ��","������ �ڷḦ �����Ͻʽÿ�!!")
	Return
END IF

IF MessageBox("Ȯ ��","�����Ͻðڽ��ϱ�?",Question!,YesNo!) = 2 THEN RETURN

FOR i = li_Cnt TO 1 STEP -1
	IF dw_2.IsSelected(i) THEN
		dw_2.DeleteRow(i)
	END IF
NEXT

p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\���_up.gif"

//IF dw_2.Update() <>  1 THEN
//	MessageBox("Ȯ ��","�ڷ� ������ �����Ͽ����ϴ�!!")
//	Rollback;
//	Return
//END IF
//
//COMMIT;
//
//sle_msg.text ='�ڷḦ �����Ͽ����ϴ�!!'
//


end event

type p_inq from w_inherite_standard`p_inq within w_pik1111
integer x = 4233
integer y = 4
end type

event p_inq::clicked;call super::clicked;string ls_kdate, ls_deptcode, ls_jikjong, ls_ktype, sflag, sGbn = 'N'
string sSaup, sKunmu
Int    k,il_SearchRow

//ROLLBACK;

dw_1.accepttext()
ls_kdate = trim(dw_1.Getitemstring(dw_1.getrow(),'kdate'))
ls_deptcode = trim(dw_1.Getitemstring(dw_1.getrow(),'deptcode'))
ls_jikjong = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong'))
ls_ktype = trim(dw_1.Getitemstring(dw_1.getrow(),'ktype'))
sSaup = trim(dw_1.Getitemstring(dw_1.getrow(),'saup'))
sKunmu = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu'))

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("Ȯ ��","�������ڴ� �ʼ��Է��Դϴ�!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

IF ls_deptcode = ""	OR IsNull(ls_deptcode)	THEN ls_deptcode = '%'
IF ls_jikjong = ""	OR IsNull(ls_jikjong)	THEN ls_jikjong = '%'
IF ls_ktype = ""		OR IsNull(ls_ktype)		THEN ls_ktype = '%'
IF sSaup = ""  		OR IsNull(sSaup)			THEN sSaup = '%'
IF sKunmu = ""  		OR IsNull(sKunmu)			THEN sKunmu = '%'

//MessageBox('',ls_kdate+','+ls_deptcode+','+ls_jikjong+','+ls_ktype+','+ sSaup+','+sKunmu)

//Parent.SetRedraw(False)

il_SearchRow = dw_2.retrieve(ls_kdate, ls_deptcode, sSaup, ls_jikjong, sKunmu, ls_ktype)
IF il_SearchRow = 0 then
 	messagebox("Ȯ��","��ȸ�� �ڷᰡ �����ϴ�!")
	w_mdi_frame.sle_msg.text ="��ȸ�� �ڷᰡ �����ϴ�! " 
	dw_1.setfocus()
	//Parent.SetRedraw(True)
	return 1
END IF



ib_any_typing = False
ib_detailflag = False

Parent.SetRedraw(True)
end event

type p_print from w_inherite_standard`p_print within w_pik1111
boolean visible = false
integer x = 1961
integer y = 2364
end type

type p_can from w_inherite_standard`p_can within w_pik1111
integer x = 4233
integer y = 144
end type

event p_can::clicked;call super::clicked;
ROLLBACK;

ib_any_typing = False
ib_detailflag = False

dw_2.reset()
dw_1.setcolumn("kdate")
dw_1.Setfocus()

Enabled = false
PictureName = "C:\erpman\image\���_d.gif"

p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_standard`p_exit within w_pik1111
integer x = 4407
integer y = 144
end type

event p_exit::clicked;call super::clicked;
/*=============================================================================================
		 1. window-level user function : ����, ��Ͻ� ȣ���
		    dw_detail �� typing(datawindow) ������� �˻�

		 2. ��������� ��� ��������� ������� ������ ���                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : ��������� �������� �ʰ� ��� ������ ���.
			* -1 : ������ �ߴ��� ���.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)�� typing ����Ȯ��

	Beep(1)
	CHOOSE CASE MessageBox("Ȯ�� : ����" , &
		 "�������� ���� ���� �ֽ��ϴ�. ~r~r��������� �����Ͻðڽ��ϱ�?", &
		 question!, YesNoCancel!) 
	CASE 1
		IF dw_2.Update() <> 1 THEN
			MessageBox("Ȯ ��","�ڷ� ������ �����Ͽ����ϴ�!!")
			ROLLBACK;
			Return
		ELSE
			COMMIT;
		END IF
	CASE 3
		RETURN -1
	CASE ELSE
		ROLLBACK;
	END CHOOSE

END IF
					

end event

type p_ins from w_inherite_standard`p_ins within w_pik1111
integer x = 4407
integer y = 4
end type

event p_ins::clicked;call super::clicked;
String  sMsgRtn,sflag, skDate , sDeptCode, snull
Integer il_SearchRow,k

SetNull(snull)
dw_1.accepttext()
skDate     = dw_1.GetItemString(1,"kdate")
sDeptCode = dw_1.GetItemString(1,"deptcode") 

IF skDate = '' OR Isnull(skDate) THEN
	 messagebox("Ȯ��","�������ڸ� �Է��Ͻʽÿ�!")
	 dw_1.SetItem(1,"kdate",snull)
	 dw_1.setcolumn("kdate")
	 return 
END IF

dw_2.insertrow(0)
dw_2.setitem(dw_2.rowcount(),"companycode", gs_company)
dw_2.setitem(dw_2.rowcount(),"kdate", skdate)
//dw_2.setitem(dw_2.rowcount(),"deptcode", sdeptcode)
dw_2.setitem(dw_2.rowcount(),"eflag", '0')
dw_2.setcolumn("empno")
dw_2.scrolltorow(dw_2.rowcount())
dw_2.setfocus()
w_mdi_frame.sle_msg.text =''

ib_any_typing = TRUE
p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\���_up.gif"

end event

type p_search from w_inherite_standard`p_search within w_pik1111
boolean visible = false
integer x = 1783
integer y = 2364
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1111
boolean visible = false
integer x = 2139
integer y = 2364
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1111
boolean visible = false
integer x = 2313
integer y = 2364
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1111
boolean visible = false
integer x = 1513
integer y = 2360
end type

type st_window from w_inherite_standard`st_window within w_pik1111
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1111
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1111
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1111
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1111
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1111
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1111
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1111
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1111
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1111
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1111
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1111
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1111
boolean visible = false
end type

type cb_calc from commandbutton within w_pik1111
boolean visible = false
integer x = 1440
integer y = 2512
integer width = 352
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ð����"
end type

event clicked;///******************************************************************************************/
///*** �ϱ��½ð� ���(ó�����õ� �ڷ��� �����ڷḦ �о �Ʒ� ������ �����Ѵ�)				*/
///*** - ���� table�� '�ٹ��ϱ���' =  �ٹ��� table(p4_kunmu)�� '�ٹ��ϱ���'�� �ڷ� ��       */
///*** 1. �����ð� : wf_calc_jktime 															 				*/ 
///*** 2. ����ð� : wf_calc_octime																			*/
///*** 3. ����ð� : wf_calc_jttime																			*/
///*** 4. �ٷνð� : wf_calc_kltime																			*/
///*** 5. ����ð� : wf_calc_yjtime																			*/
///*** 6. �߰��ð� : wf_calc_yktime																			*/
///*** 7. ��ð� : wf_calc_jktime																			*/
///*** 8. ����(Ư��)�ð� : wf_calc_htime																		*/
///******************************************************************************************/
//
//String ls_kdate,ls_deptcode,sMasterSql,sRtnValue
//
//dw_1.AcceptText()
//ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
//ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
//IF ls_deptcode ="" OR IsNull(ls_deptcode) THEN
//	ls_deptcode ="%"
//END IF
//
//// ���� ó���� ���� ���� �Ұ�
//string ls_flag, ls_yymm
//ls_yymm  = left(ls_kdate, 6) 
//
//SELECT "P4_MFLAG"."GUBN"  
//  INTO :ls_flag  
//  FROM "P4_MFLAG" 
//  where companycode= :gs_company and myymm = :ls_yymm ;
//if ls_flag = '1' then
//	messagebox("Ȯ��","������ �Ϸ�� �� �Դϴ�.!!")
//	return
//end if	
//
//sMasterSql = wf_ProcedureSql()
//
//sle_msg.text = '�ϱ��½ð� ��� ��......'
//SetPointer(HourGlass!)
//
//
//sRtnValue = sqlca.sp_calculation_dkentaetime(ls_kdate,'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);
//
//IF Left(sRtnValue,2) <> 'OK' then
//	MessageBox("Ȯ ��","���½ð� ��� ����!!"+"["+sRtnValue+"]")
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text =''
//	Return
//else
//	commit;
//END IF
//
//SetPointer(Arrow!)
//sle_msg.text ='�ϱ��½ð� ��� �Ϸ�!!'
//
//
end event

type st_2 from statictext within w_pik1111
boolean visible = false
integer x = 9
integer y = 2600
integer width = 1335
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 65535
long backcolor = 12632256
boolean enabled = false
string text = "�ذ��κ� ������ Double Click�Ͻʽÿ�!"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_2 from u_d_select_sort within w_pik1111
event ue_key pbm_keydown
event ue_enter pbm_dwnprocessenter
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 304
integer width = 4535
integer height = 1900
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pik1111_3"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing = True
end event

event itemchanged;String sKtCode,sKtName,snull,sKtDate, sAttendGbn,sYearMonthDay,sYearMonth,sEmpNo,sSex, &
		 sFromDate,sToDate,sAttendTime, shdaygubn, skmgubn,sdate, sname,sss,aaa, sdept, sAttName, &
		 sAttendAdd, sJikjong
Double dJkTime,dJtTime,dOcFrom,dOcTo
Long   lsyday,lscnt, lJkTime, lJtTime,lCkTime,lTkTime,lDkTime,Calc_time
INT    lReturnRow, il_currow , il_count
SetNull(snull)

sle_msg.text =""


this.accepttext()

sDate    = this.GetItemString(1,"kdate")
timegubn = '1'

IF this.getcolumnname() = "empno" THEN											/* �����ȣ */
	sEmpNo = this.Gettext()
	IF sEmpNo ="" OR IsNull(sEmpNo) THEN RETURN
	
	SELECT "P1_MASTER"."EMPNAME", "P1_MASTER"."DEPTCODE", "P1_MASTER"."JIKJONGGUBN" 
	   INTO :sname,  :sdept, :sJikjong
	   FROM "P1_MASTER"
	   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo)  ;
	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox("Ȯ ��","��ϵ��� ���� ����̹Ƿ� ����� �� �����ϴ�!!")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		this.SetItem(this.GetRow(),"deptcode",snull)
		Return 1
	END IF
	lReturnRow = This.Find("empno = '"+sempno+"' ", 1, This.RowCount())
	IF (this.GetRow() <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("Ȯ��","��ϵ� ����Դϴ�.~r����� �� �����ϴ�.")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		this.SetItem(this.GetRow(),"deptcode",snull)
		RETURN  1	
	ELSE
		  SELECT count("P4_DKENTAE"."EMPNO")  
    	    INTO :il_count  
	       FROM "P4_DKENTAE"  
		   WHERE ( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
               ( "P4_DKENTAE"."KDATE" = :sdate )   ;
			IF il_count <> 0 THEN
				MessageBox("Ȯ��","��ϵ� ����Դϴ�.~r����� �� �����ϴ�.")
				this.SetItem(this.GetRow(),"empno",snull)
				this.SetItem(this.GetRow(),"empname",snull)
				this.SetItem(this.GetRow(),"deptcode",snull)
				RETURN  1	
			END IF	
	END IF
	
	SELECT "P4_CALENDAR"."HDAYGUBN"
    INTO :shdaygubn
    FROM "P4_CALENDAR"
   WHERE ( "P4_CALENDAR"."CLDATE" = :sdate ) ;
	
	SELECT "P1_KTYPE"."KTYPE"
    INTO :skmgubn
    FROM "P1_KTYPE"
   WHERE ( "P1_KTYPE"."EMPNO" = :sempno ) ;	
	
	this.SetItem(this.GetRow(),"hdaygubn",shdaygubn)
	this.SetItem(this.GetRow(),"kmgubn",skmgubn)
	this.SetItem(this.GetRow(),"empname",sname)
	this.SetItem(this.GetRow(),"deptcode",sdept)
	this.SetItem(this.GetRow(),"jikjonggubn",sJikjong)
	wf_modify_ktype(this.GetRow(),skmgubn,TRUE)
	
//	string sMaxDate ,sDeptCode, sPrtDept 
//	int iMaxSeq
//	
//	SELECT MAX("REALORDDATEFROM")													/*�ֽŹ߷�����*/
//			INTO :sMaxDate
//			FROM "P1_ORDERS"
//			WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :sEmpNo and
//					"REALORDDATEFROM" <= :sdate ;
//	IF sqlca.sqlcode <> 0 then
//		sMaxDate= ''
//	END IF	
//
//	SELECT MAX("P1_ORDERS"."SEQ")
//     INTO :iMaxSeq
//	  FROM "P1_ORDERS"  
//	 WHERE ( "P1_ORDERS"."EMPNO" = :sEmpno ) AND  
//			 ( "P1_ORDERS"."REALORDDATEFROM" = :sMaxDate ) ;			
//	IF sqlca.sqlcode <> 0 then
//		iMaxSeq= 0
//	END IF	
//
	/*�ҼӺμ�,��ºμ� ���ϱ�*/
//	SELECT "P1_ORDERS"."DEPTCODE",   "P1_ORDERS"."PRTDEPT"  
//	  INTO :sDeptCode,   			:sPrtDept  
//	  FROM "P1_ORDERS"  
//    WHERE ( "P1_ORDERS"."COMPANYCODE" = :gs_company ) AND  
//		    ( "P1_ORDERS"."EMPNO" = :sEmpNo ) AND  
//			 ( "P1_ORDERS"."REALORDDATEFROM" = :sMaxDate ) AND
//			 ("P1_ORDERS"."SEQ" = :iMaxSeq) ;
//	IF sqlca.sqlcode <> 0 then
//		Messagebox("Ȯ ��","�߷��ڷᰡ ��ϵ��� ���� ����̹Ƿ� ����� �� �����ϴ�!!")
//		this.SetItem(this.GetRow(),"empno",snull)
//		this.SetItem(this.GetRow(),"empname",snull)
//		Return 1
//	ELSE
//		this.setitem(this.GetRow(),'deptcode',sdeptcode)
//		this.setitem(this.GetRow(),'p4_dkentae_prtdept',sprtdept)
//	END IF	
	
	
ELSE
	sEmpNo = this.Getitemstring(this.GetRow(),'empno')
END IF	

IF this.getcolumnname() = "ktcode" THEN									/* �����ڵ� */
	sKtCode = this.GetText()
	
	IF sKtCode = "" OR IsNull(sKtCode) THEN
		sAttendTime = '1'
		this.SetItem(this.GetRow(),"attendancetime",sAttendTime)	
//		Wf_Get_CtTime(this.GetItemString(this.GetRow(),"kmgubn"),lCkTime,lTkTime)
//		
//		this.SetItem(this.GetRow(),"cktime",lCkTime)
//		this.SetItem(this.GetRow(),"tktime",lTkTime)		
		Return
   END IF 
	SELECT "ATTENDANCENAME", "ATTENDANCEGUBN",  /*�����ڵ� �˻�*/
			 "ATTENDANCETIME", "ATTENDANCEADD"
		INTO :sAttName, :sAttendGbn ,:sAttendTime, :sAttendAdd
		FROM "P0_ATTENDANCE"  
		WHERE "P0_ATTENDANCE"."ATTENDANCECODE" = :sKtCode  ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("Ȯ��","�����ڵ带 Ȯ���Ͻʽÿ�!")
		this.SetItem(this.GetRow(),"ktcode",snull)
		this.setcolumn("ktcode")
		this.setfocus()
		return 1
	ELSE
		IF sAttendGbn = '3' THEN
			String gender
			gender = GetItemString(row,"sex")
			IF gender <> '2' and gender <> '4' THEN
				MessageBox("Ȯ��","���� ����̹Ƿ� '"+sAttName+"' ���¸�   ~r~r      ����� �� �����ϴ�.",Exclamation!)
				this.SetItem(this.GetRow(),"ktcode",snull)
				this.setcolumn("ktcode")
				this.setfocus()
				return 1
			END IF
		END IF
		
		this.SetItem(this.GetRow(),"attendancetime",sAttendTime)	
	END IF
	
	sKtDate = this.Getitemstring(this.GetRow(),'kdate')
	
	IF sAttendTime = '1' THEN													/*�ð� �Է� ����*/
	ELSE
		wf_init_clear(this.GetRow(), sAttendAdd)
	END IF	
END IF

IF this.getcolumnname() = "kmgubn" THEN									/* �ٹ�Ÿ�� */
	skmgubn = this.GetText()
	IF wf_modify_ktype(this.GetRow(),skmgubn,TRUE) = -1 THEN
		this.SetItem(this.GetRow(),"kmgubn",snull)
		this.setcolumn("kmgubn")

		this.setfocus()
		RETURN 1
	END IF
END IF

double sjikak,jotoei,ochul
IF this.GetColumnName() = 'jkgtime' THEN
	sjikak = Double(Trim(this.GetText()))
	IF IsNull(sjikak) THEN sjikak =0	
	IF sjikak = 0 THEN
		this.SetItem(this.GetRow(),"jkgubn",snull)	
	ELSE
		this.SetItem(this.GetRow(),"jkgubn",'1')		
	END IF
END IF

IF this.GetColumnName() = 'jtgktime' THEN
	jotoei = Double(Trim(this.GetText()))
	IF IsNull(jotoei) THEN jotoei =0		
	IF jotoei = 0 THEN
		this.SetItem(this.GetRow(),"jtgubn",snull)	
	ELSE
		this.SetItem(this.GetRow(),"jtgubn",'1')		
	END IF		
END IF

IF this.GetColumnName() = 'ocgttime' THEN
	ochul = Double(Trim(this.GetText()))
	IF IsNull(ochul) THEN ochul =0		
	IF ochul = 0 THEN
		this.SetItem(this.GetRow(),"occnt",0)			
	ELSE
		this.SetItem(this.GetRow(),"occnt",1)		
	END IF		
END IF


ib_detailflag = True

p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\���_up.gif"
end event

event itemerror;call super::itemerror;
Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "empno"  THEN
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;//this.SetRowFocusIndicator(Hand!)

this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)
end event

type p_action from uo_picture within w_pik1111
integer x = 3086
integer y = 100
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\�ϰ�����_up.gif"
end type

event clicked;String	ls_ktype
long		i, ll_row

w_mdi_frame.sle_msg.text=""
ls_ktype = dw_3.GetItemString(1,'ktype')
ll_row = dw_2.RowCount()
	
FOR i = 1 to ll_row
	wf_modify_ktype(i, ls_ktype, FALSE)
Next
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ϰ�����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ϰ�����_up.gif"
end event

type p_1 from uo_picture within w_pik1111
integer x = 3886
integer y = 4
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event clicked;string ls_kdate, ls_deptcode, ls_ktype, ls_jikjong, sflag, sGbn = 'N'
string sSaup, sKunmu
Int    k,il_SearchRow
double stime, ttime, ktime

w_mdi_frame.sle_msg.text =""

if dw_1.accepttext() = -1 then return 

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
ls_jikjong = dw_1.Getitemstring(dw_1.getrow(),'jjong')
sSaup = trim(dw_1.Getitemstring(dw_1.getrow(),'saup'))
sKunmu = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu'))

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("Ȯ ��","�������ڴ� �ʼ��Է��Դϴ�!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

IF ls_deptCode = ""	OR IsNull(ls_deptCode)	THEN ls_DeptCode = '%'
IF ls_jikjong = ""	OR IsNull(ls_jikjong)	THEN ls_jikjong = '%'
IF sSaup = ""  		OR IsNull(sSaup)			THEN sSaup = '%'
IF sKunmu = ""  		OR IsNull(sKunmu)			THEN sKunmu = '%'

if dw_3.Accepttext()  = -1 then return 

stime = dw_3.GetitemNumber(1,'chtime')
ttime = dw_3.GetitemNumber(1,'tgtime')

if stime = 0 or ttime = 0 then
	messagebox("Ȯ��","����ٽð��� Ȯ���ϼ���!")
	return
end if


if wf_insert_dkentae(stime, ttime) = -1 then
	w_mdi_frame.sle_msg.text = '���� ���� ����!'
	return
end if

Parent.SetRedraw(False)

IF dw_2.retrieve(ls_kdate, ls_deptcode, sSaup, ls_jikjong, sKunmu, '%') <= 0 then
 	messagebox("Ȯ��","��ȸ�� �ڷᰡ �����ϴ�!")
	w_mdi_frame.sle_msg.text ="��ȸ�� �ڷᰡ �����ϴ�!"
	dw_1.setfocus()
	Parent.SetRedraw(True)
	return 1
END IF

ib_any_typing = TRUE
ib_detailflag = False

Parent.SetRedraw(True)

p_can.Enabled = true
p_can.PictureName = "C:\erpman\image\���_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\����_up.gif"
end event

type p_2 from uo_picture within w_pik1111
integer x = 4059
integer y = 4
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\��ü����_up.gif"
end type

event clicked;call super::clicked;string ls_kdate, ls_deptcode

w_mdi_frame.sle_msg.text =""

if dw_1.accepttext() = -1 then return

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("Ȯ ��","�������ڴ� �ʼ��Է��Դϴ�!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'

if messagebox("��ü����",string(ls_kdate,'@@@@.@@.@@')+"�� �ڷḦ ��� �����մϴ�", &
               Exclamation!, OKCancel!, 2) = 2 then return
					
delete from p4_dkentae
where companycode = :gs_company and kdate = :ls_kdate;

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("����","��ü������ �����߽��ϴ�!")
	return
else
	commit;
	w_mdi_frame.sle_msg.text = "��ü���� �Ϸ�!"
	p_can.Enabled = false
	p_can.PictureName = "C:\erpman\image\���_d.gif"
end if
p_inq.Triggerevent(Clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��ü����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��ü����_up.gif"
end event

type gb_3 from groupbox within w_pik1111
boolean visible = false
integer x = 1371
integer y = 2432
integer width = 485
integer height = 244
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
end type

type rr_1 from roundrectangle within w_pik1111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 300
integer width = 4581
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_3 from u_key_enter within w_pik1111
integer x = 2030
integer y = 60
integer width = 1275
integer height = 224
integer taborder = 21
string dataobject = "d_pik1111_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;String	ls_SetValue
long		i, ll_row

w_mdi_frame.sle_msg.text=""

ls_SetValue = this.GetText()
ll_row = dw_2.RowCount()

choose case(dw_3.GetColumnName())
	case 'chtime'
		FOR i = 1 to ll_row
			dw_2.SetItem(i,'cktime',Long(ls_SetValue))
		Next

	case 'tgtime'
		FOR i = 1 to ll_row
			dw_2.SetItem(i,'tktime',Long(ls_SetValue))
		Next
end choose
end event

type dw_1 from u_key_enter within w_pik1111
event ue_setfilter ( long row )
event ue_key pbm_dwnkey
integer x = 41
integer y = 12
integer width = 1989
integer height = 276
integer taborder = 11
string dataobject = "d_pik1111_1"
boolean border = false
end type

event ue_setfilter(long row);String	ls_jikjong, ls_ktype, ls_saup, ls_kunmu, ls_FilterString

IF This.AcceptText() = -1 THEN return
ls_FilterString = ''

ls_jikjong	= trim(GetItemString(row, 'jjong'))
ls_ktype		= trim(GetItemString(row, 'ktype'))
ls_saup		= trim(GetItemString(row, 'saup'))
ls_kunmu		= trim(GetItemString(row, 'kunmu'))

IF IsNull(ls_jikjong) THEN ls_jikjong = ''
IF IsNull(ls_ktype)	 THEN ls_ktype = ''
IF IsNull(ls_saup)	 THEN ls_saup = ''
IF IsNull(ls_kunmu)	 THEN ls_kunmu = ''

IF ls_jikjong <> '' THEN ls_FilterString += "jikjonggubn = '"+ ls_jikjong +"'"

IF ls_ktype <> '' THEN
	IF ls_FilterString <> '' THEN ls_FilterString += " AND "	
	ls_FilterString += "ktype = '"+ ls_ktype +"'"
END IF

IF ls_saup <> '' THEN
	IF ls_FilterString <> '' THEN ls_FilterString += " AND "	
	ls_FilterString += "saup = '"+ ls_saup +"'"
END IF

IF ls_kunmu <> ''		THEN
	IF ls_FilterString <> '' THEN ls_FilterString += " AND "	
	ls_FilterString += "kunmu = '"+ ls_kunmu +"'"
END IF

dw_2.SetFilter(ls_FilterString)
dw_2.Filter()

IF dw_2.RowCount() = 0 THEN
	w_mdi_frame.sle_msg.text ="��ȸ�� �ڷᰡ �����ϴ�! " 
END IF
end event

event ue_key;//F1 key�� ������ �ڵ���ȸó����	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemchanged;call super::itemchanged;String	ls_kdate, ls_deptcode, ls_dept, ls_dayname, ls_hdayname,snull

w_mdi_frame.sle_msg.text =""

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "kdate" THEN
	ls_kdate = this.GetText()
	
	IF ls_kdate ="" OR IsNull(ls_kdate) THEN 
	
		this.setitem(this.getrow(),"kweek",snull)
		Return
	END IF
	
	if F_datechk(ls_kdate) = -1 then
		 messagebox("Ȯ��","�������ڸ� Ȯ���Ͻʽÿ�!")
		 this.SetItem(1,"kdate",snull)
		 this.setcolumn("kdate")
		 return 1
	else
		if f_daygubun(ls_kdate,ls_dayname, ls_hdayname) = -1 then
			messagebox("Ȯ��","�޷����ڿ� ���ϸ� �� �޹��� �������̺��� Ȯ���Ͻʽÿ�!")
			this.SetItem(1,"kdate",snull)
			this.setcolumn("kdate")
			return 1
		else
		
			this.setitem(1,"kweek",ls_dayname)
			dw_1.setitem(1,"kgubun",ls_hdayname)
		end if
	end if
	p_inq.TriggerEvent(Clicked!)
	
END IF

IF this.GetColumnName() = 'deptcode' THEN
	ls_deptcode = this.GetText()
	
	IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN
		p_inq.TriggerEvent(Clicked!)
		return
	END IF
	
	//�μ��ڵ� �˻�
	SELECT "P0_DEPT"."DEPTCODE"  
		 INTO :ls_dept  
		 FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
	if sqlca.sqlcode <> 0 then
		messagebox("Ȯ��","�μ��ڵ带 Ȯ���Ͻʽÿ�!")
		this.SetItem(1,"deptcode",snull)
		this.setcolumn("deptcode")
		return 1
	end if
	p_inq.TriggerEvent(Clicked!)
END IF

IF GetColumnName() = 'jjong' or GetColumnName() = 'ktype' or &
	GetColumnName() = 'saup' or GetColumnName() = 'kunmu' THEN
	Event ue_setfilter(row)
END IF


end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() = "deptcode"  THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

