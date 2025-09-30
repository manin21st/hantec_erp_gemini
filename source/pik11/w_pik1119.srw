$PBExportHeader$w_pik1119.srw
$PBExportComments$** 일근태 수정 입력
forward
global type w_pik1119 from w_inherite_standard
end type
type cb_calc from commandbutton within w_pik1119
end type
type st_2 from statictext within w_pik1119
end type
type dw_3 from datawindow within w_pik1119
end type
type rb_7 from radiobutton within w_pik1119
end type
type rb_6 from radiobutton within w_pik1119
end type
type p_1 from uo_picture within w_pik1119
end type
type p_2 from uo_picture within w_pik1119
end type
type gb_3 from groupbox within w_pik1119
end type
type gb_6 from groupbox within w_pik1119
end type
type rr_1 from roundrectangle within w_pik1119
end type
type dw_1 from u_key_enter within w_pik1119
end type
type dw_2 from u_d_select_sort within w_pik1119
end type
end forward

global type w_pik1119 from w_inherite_standard
string title = "일근태 수정 입력"
boolean resizable = false
event ue_postopen ( )
cb_calc cb_calc
st_2 st_2
dw_3 dw_3
rb_7 rb_7
rb_6 rb_6
p_1 p_1
p_2 p_2
gb_3 gb_3
gb_6 gb_6
rr_1 rr_1
dw_1 dw_1
dw_2 dw_2
end type
global w_pik1119 w_pik1119

type variables
Boolean  Ib_DetailFlag = False
string       ls_dkdeptcode, timegubn
int time_row
Double    dYkTime

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false


end variables

forward prototypes
public function integer wf_check_remainday (integer icurrow, string sempno, string skdate, string scode, string sflag)
public function double wf_conv_hhmm (double dtime)
public subroutine wf_init_clear (integer ll_currow)
public function integer wf_insert_dkentae (double cktime, double tgtime, double kuntime)
public subroutine wf_reset ()
public subroutine wf_set_sqlsyntax (string sdate, string sdept)
end prototypes

event ue_postopen();string	ls_chtime, ls_tgtime, ls_kdate, ls_deptcode, sSaup//, ls_jikjong, sKunmu
int		cnt

if dw_1.accepttext() = -1 then return

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
sSaup = trim(dw_1.Getitemstring(dw_1.getrow(),'saup'))
//ls_jikjong = trim(dw_1.Getitemstring(dw_1.getrow(),'jjong'))
//sKunmu = trim(dw_1.Getitemstring(dw_1.getrow(),'kunmu'))

IF ls_kdate = ""		OR IsNull(ls_kdate)		THEN return
IF ls_deptCode = ""	OR IsNull(ls_deptCode)	THEN ls_DeptCode = '%'
IF sSaup = ""  		OR IsNull(sSaup)			THEN sSaup = '%'
//IF ls_jikjong = ""	OR IsNull(ls_jikjong)	THEN ls_jikjong = '%'
//IF sKunmu = ""  		OR IsNull(sKunmu)			THEN sKunmu = '%'

select count(*) into :cnt
from   p4_dkentae a, p0_dept c//, p1_master b, 
where  a.companycode = :gs_company and
       a.kdate = :ls_kdate and
		 a.deptcode like :ls_deptcode and
		 a.companycode = c.companycode and
		 a.deptcode = c.deptcode and
		 c.saupcd LIKE :sSaup //and
		 //a.jikjonggubn like :ls_jikjong and
		 //a.empno = b.empno and
		 //b.kunmugubn LIKE :sKunmu
		 ;

IF cnt > 0 THEN
	p_inq.TriggerEvent(Clicked!)
ELSE
	IF MessageBox('확인','생성된 근태 자료가 없습니다.~r~n근태자료를 생성하시겠습니까?',Question!,YesNo!) = 1 THEN
		p_search.TriggerEvent(Clicked!)
		p_can.Enabled = True
		p_can.PictureName = "C:\erpman\image\취소_up.gif"
	END IF
END IF
end event

public function integer wf_check_remainday (integer icurrow, string sempno, string skdate, string scode, string sflag);String  sYearMonth,sSex,sFromDate,sToDate,snull, sentdate
Integer lYDay,lCnt

SetNull(snull)

sYearMonth = Left(sKDate, 4) + Mid(sKDate, 5, 2)
		
///* 월차 체크 */
//if sFlag = "1" then			
//	SELECT "P4_MONTHLIST"."YDAY" + "P4_MONTHLIST"."BDAY"				/*이월일수 + 발생일수*/
//		INTO :lYDay  
//	   FROM "P4_MONTHLIST"  
//	   WHERE ( "P4_MONTHLIST"."COMPANYCODE" = :gs_company ) AND  
//			   ( "P4_MONTHLIST"."YYMM" = :sYearMonth ) AND  ( "P4_MONTHLIST"."EMPNO" = :sempno )   ;
//	IF sqlca.sqlcode <> 0 THEN
//		messagebox("확인", "월차를 사용할수 없습니다 (월차 생성 확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1
//	END IF	  
//	
//	/*사용일수 = 일근태의 '월차'근태코드횟수(작업하고 있는 근태일자 제외)*/		
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
//	IF lYDay - lCnt < 1 then					/*잔여일수*/
//		messagebox("확인", "월차를 사용할수 없습니다 (잔여월차 확인) !!")
//		dw_2.SetItem(iCurRow,"ktcode",snull)
//		dw_2.setcolumn("ktcode")
//		dw_2.setfocus()
//		dw_2.scrolltoRow(iCurRow)
//		return -1	
//	END IF
//END IF
//
///* 년차 확인 */
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
		messagebox("확인", "년차를 사용할수 없습니다. !! ~r(총무과에 년차생성을 의뢰하십시오.) ")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	END IF
			
	SELECT count("P4_DKENTAE"."KTCODE")  		/*사용일수*/
		INTO :lCnt  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
				( "P4_DKENTAE"."KDATE" >= :sFromDate ) AND  
				( "P4_DKENTAE"."KDATE" <= :sToDate ) AND  
				( "P4_DKENTAE"."KTCODE" = :scode )   ;
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
//		messagebox("확인", "년차를 사용할수 없습니다 (1년미만자) !!")
//		return -1
//	end if
	  
	IF lYDay - lCnt < 1 then								//잔여일수
		messagebox("확인", "년차를 사용할수 없습니다 (잔여년차확인) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if	
END IF

/* 생리일수 체크 */
if sFlag = "3" then
	sSex = dw_2.getitemstring(iCurRow , "sex")	
	if sSex = '1' then  										//남자사원 생리사용 check
		messagebox("확인","여직원만 생리휴가 사용이 가능합니다.!!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if					
   
	SELECT count("P4_DKENTAE"."KTCODE")  					//사용일수
		INTO :lCnt  
		FROM "P4_DKENTAE"  
		WHERE ( "P4_DKENTAE"."COMPANYCODE" = :gs_company ) AND  
				( "P4_DKENTAE"."EMPNO" = :sempno ) AND  
				( substr("P4_DKENTAE"."KDATE",1,6) = :sYearMonth ) AND  
				( "P4_DKENTAE"."KDATE" <> :sKDate ) AND  
				( "P4_DKENTAE"."KTCODE" = :scode )   ;
	IF lCnt > 0  then
		messagebox("확인", "생리를 사용할수 없습니다 (이미사용) !!")
		dw_2.SetItem(iCurRow,"ktcode",snull)
		dw_2.setcolumn("ktcode")
		dw_2.setfocus()
		dw_2.scrolltoRow(iCurRow)
		return -1
	end if	
END IF	

Return 1

end function

public function double wf_conv_hhmm (double dtime);/*분이 60을 넘을 경우 시간에 add 처리*/

Int iMM
//Int iHH,iMM
//
//iHH = Integer(Left(String(dTime,'00.00'),2))								/*시간*/
//iMM = Integer(Mid(String(dTime,'00.00'),4,2))								/*분*/
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

public subroutine wf_init_clear (integer ll_currow);
dw_2.SetItem(ll_currow,"jkgubn",'0')
dw_2.SetItem(ll_currow,"jkgtime",0)
dw_2.SetItem(ll_currow,"jktime",0)
dw_2.SetItem(ll_currow,"occnt",0)
dw_2.SetItem(ll_currow,"ocfromtime",0)
dw_2.SetItem(ll_currow,"octotime",0)
dw_2.SetItem(ll_currow,"ocgttime",0)
dw_2.SetItem(ll_currow,"ocggtime",0)
dw_2.SetItem(ll_currow,"jtgubn",'0')
dw_2.SetItem(ll_currow,"jtgktime",0)
//dw_2.SetItem(ll_currow,"jtgytime",0)
dw_2.SetItem(ll_currow,"jttime",0)
dw_2.SetItem(ll_currow,"cktime",0)
dw_2.SetItem(ll_currow,"tktime",0)
//dw_2.SetItem(ll_currow,"okfromtime",0)
//dw_2.SetItem(ll_currow,"oktotime",0)
dw_2.SetItem(ll_currow,"klgtime",0)
dw_2.SetItem(ll_currow,"yjgtime",0)
dw_2.SetItem(ll_currow,"ykgtime",0)
dw_2.SetItem(ll_currow,"ykgtime100",0)
dw_2.SetItem(ll_currow,"hkgtime",0)
dw_2.SetItem(ll_currow,"hkyjgtime",0)
dw_2.SetItem(ll_currow,"hkcygtime",0)
dw_2.SetItem(ll_currow,"dktime",0)
dw_2.SetItem(ll_currow,"dkgtime",0)

end subroutine

public function integer wf_insert_dkentae (double cktime, double tgtime, double kuntime);string ls_kdate, ls_deptcode,shday, ls_saup, ls_jikjong, ls_kunmu
int cnt


if dw_1.accepttext() = -1 then return -1

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
ls_saup = dw_3.Getitemstring(dw_3.getrow(),'saup')
//ls_jikjong = dw_1.Getitemstring(dw_1.getrow(),'jjong')
//ls_kunmu = dw_1.Getitemstring(dw_1.getrow(),'kunmu')

IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'
IF ls_saup = ""  OR IsNull(ls_saup)  THEN ls_saup = '%'
//IF ls_kunmu = ""  OR IsNull(ls_kunmu)  THEN ls_kunmu = '%'
//IF ls_jikjong = ""  OR IsNull(ls_jikjong)  THEN ls_jikjong = '%'

delete from p4_dkentae
where companycode = :gs_company and kdate = :ls_kdate and deptcode like :ls_deptcode;
commit ;

//select count(*) into :cnt
//from p4_dkentae
//where companycode = :gs_company and
//      kdate = :ls_kdate and
//		deptcode like :ls_deptcode;


select count(*) into :cnt
from	 p4_dkentae a, p1_master b, p0_dept c
where  a.companycode = :gs_company and
		 a.companycode = b.companycode and
		 a.companycode = c.companycode and
		 a.empno = b.empno and
       a.kdate = :ls_kdate and
		 a.deptcode like :ls_deptcode and
		 //a.jikjonggubn like :ls_jikjong and
		 //b.kunmugubun like :ls_kunmu and
		 b.deptcode = c.deptcode and
		 c.saupcd like :ls_saup	 ;


select hdaygubn into :shday
from p4_calendar
where companycode = :gs_company and
      cldate = :ls_kdate;
		
if cnt > 0 then
	
//	update p4_dkentae
//	set cktime = :cktime,
//	    tktime = :tgtime,
//		 klgtime = :kuntime
//	where companycode = :gs_company and
//			kdate = :ls_kdate and
//			deptcode like :ls_deptcode;

DELETE FROM P4_DKENTAE A
where  A.companycode = :gs_company and
       A.kdate = :ls_kdate and
		 A.deptcode like :ls_deptcode and
		 //A.jikjonggubn like :ls_jikjong and
		 A.empno in (select A.empno
						   from P4_DKENTAE A, p1_master B, p0_dept C
						  where A.companycode = B.companycode and
						 		  A.empno = B.empno and
						 		  //B.kunmugubn like :ls_kunmu and
						 		  A.companycode = C.companycode and
						 		  B.deptcode = C.deptcode and
					   		  C.saupcd like :ls_saup) ;

else
	
 INSERT INTO "P4_DKENTAE"  
         ( "COMPANYCODE",    "DEPTCODE",      "EMPNO",       "KDATE",	"JIKJONGGUBN",
			     "HDAYGUBN",      "CKTIME",     "TKTIME",     "KLGTIME"   )  
 SELECT    a.companycode,    e.deptcode,      a.empno,     :ls_kdate,	A.JIKJONGGUBN,
                  :shday,       :cktime,      :tgtime,      :kuntime

 FROM		p1_master a, p4_dkentae d, p0_dept e, P0_LEVEL f
 WHERE	a.companycode = :gs_company and
       	a.deptcode like :ls_deptcode and
		 	a.servicekindcode <> '2' and
		 	a.enterdate  <= :ls_kdate  AND
      	(a.retiredate  >= :ls_kdate  OR
       	a.retiredate is null OR
       	a.retiredate = ' ') and
			a.empno = d.empno(+) and
         d.kdate(+) = :ls_kdate and 
			//a.kunmugubn like :ls_kunmu and
			a.companycode = e.companycode and
			a.deptcode = e.deptcode and
			e.saupcd like :ls_saup and
			a.LEVELCODE = f.LEVELCODE AND
			f.GUBUN <> '0'	;
end if

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("에러","생성실패!")
	return -1
end if

p_can.Enabled = True
p_can.PictureName = "C:\erpman\image\취소_up.gif"
return 1

end function

public subroutine wf_reset ();String sHdayName,sDayName,snull,sabu, smessage
double ls_chtime, ls_tgtime

dw_1.reset()
dw_1.Insertrow(0)

dw_1.setitem(dw_1.getrow(),"kdate",gs_today)
f_daygubun(gs_today,sDayName, sHdayName)


dw_1.setitem(1,"kweek",sDayName)
dw_1.setitem(1,"kgubun",sHdayName)


select dataname into :ls_chtime			/*출근시각*/
from p0_syscnfg
where sysgu = 'P' and
		serial = '3' and
		lineno = '1' ;

select dataname into :ls_tgtime			/*퇴근시각*/
from p0_syscnfg
where sysgu = 'P' and
		serial = '3' and
		lineno = '2' ;

dw_3.SetItem(1,'chtime',long(ls_chtime))
dw_3.SetItem(1,'tgtime',long(ls_tgtime))


select saupcd into :sabu
from p0_dept
where deptcode = :gs_dept;


		
//// 환경변수 근태담당부서 
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


w_mdi_frame.sle_msg.text =""

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

event open;call super::open;dw_datetime.InsertRow(0)

w_mdi_frame.sle_msg.text =""

f_set_saupcd(dw_3, 'saup', '1')
is_saupcd = gs_saupcd

ib_any_typing=False
p_can.Enabled = false
p_can.PictureName = "C:\erpman\image\취소_d.gif"

Wf_Reset()

Event ue_postopen()

end event

on w_pik1119.create
int iCurrent
call super::create
this.cb_calc=create cb_calc
this.st_2=create st_2
this.dw_3=create dw_3
this.rb_7=create rb_7
this.rb_6=create rb_6
this.p_1=create p_1
this.p_2=create p_2
this.gb_3=create gb_3
this.gb_6=create gb_6
this.rr_1=create rr_1
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_calc
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.rb_7
this.Control[iCurrent+5]=this.rb_6
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_6
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.dw_2
end on

on w_pik1119.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_calc)
destroy(this.st_2)
destroy(this.dw_3)
destroy(this.rb_7)
destroy(this.rb_6)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.gb_3)
destroy(this.gb_6)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.dw_2)
end on

type p_mod from w_inherite_standard`p_mod within w_pik1119
integer x = 3881
end type

event p_mod::clicked;call super::clicked;IF dw_2.AcceptText() = -1 THEN RETURN

IF dw_2.RowCount() <=0 THEN RETURN


IF MessageBox("확 인","저장하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

IF dw_2.Update() <> 1 THEN
	MessageBox("확 인","자료 저장에 실패하였습니다!!")
	ROLLBACK;
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ="자료가 저장되었습니다!"

p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"

//IF MessageBox("확 인","시간계산을 다시하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN
//
///*시간 다시 계산*/
//sle_msg.text ="시간계산 재작업중!"
//ib_detailflag = False
//cb_calc.TriggerEvent(Clicked!)
//
//ib_any_typing = False
//ib_detailflag = False
//
//cb_retrieve.TriggerEvent(Clicked!)
//
//sle_msg.text ="시간계산 완료!"
////

end event

type p_del from w_inherite_standard`p_del within w_pik1119
integer x = 4055
end type

event p_del::clicked;call super::clicked;
Int iSelectedRow
string ls_kjgubn1 ,ls_kjgubn2

IF dw_2.RowCount() <=0 THEN RETURN

iSelectedRow = dw_2.GetRow()
IF iSelectedRow <=0 THEN
	MessageBox("확 인","삭제할 자료를 선택하십시요!!")
	Return
END IF


IF MessageBox("확 인","삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

dw_2.DeleteRow(iSelectedRow)
//IF dw_2.Update() <>  1 THEN
//	MessageBox("확 인","자료 삭제를 실패하였습니다!!")
//	Rollback;
//	Return
//END IF
//
//COMMIT;
//
//sle_msg.text ='자료를 삭제하였습니다!!'
//

p_can.Enabled = True
p_can.PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_inq from w_inherite_standard`p_inq within w_pik1119
integer x = 3534
end type

event p_inq::clicked;call super::clicked;
string ls_kdate, ls_deptcode,sflag,sGbn = 'N', sSaup
Int    k,il_SearchRow

ROLLBACK;

dw_1.accepttext()
ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
sSaup = trim(dw_3.GetItemString(dw_3.getrow(),"saup"))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("확 인","근태일자는 필수입력입니다!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

Parent.SetRedraw(False)

p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"

IF dw_2.retrieve(ls_kdate, ls_deptcode, sSaup) <= 0 then
// messagebox("확인","조회한 자료가 없습니다!")
	w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다! " 
	dw_1.setfocus()
	Parent.SetRedraw(True)
	return 1
END IF

ib_any_typing = False
ib_detailflag = False

Parent.SetRedraw(True)


end event

type p_print from w_inherite_standard`p_print within w_pik1119
boolean visible = false
integer x = 2021
integer y = 2380
end type

type p_can from w_inherite_standard`p_can within w_pik1119
integer x = 4229
end type

event p_can::clicked;call super::clicked;ROLLBACK;

ib_any_typing = False
ib_detailflag = False

Enabled = False
PictureName = "C:\erpman\image\취소_d.gif"

dw_2.reset()
dw_1.setcolumn("kdate")
dw_1.Setfocus()
end event

type p_exit from w_inherite_standard`p_exit within w_pik1119
integer x = 4402
end type

event p_exit::clicked;call super::clicked;/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : 종료" , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
			
end event

type p_ins from w_inherite_standard`p_ins within w_pik1119
integer x = 3707
end type

event p_ins::clicked;call super::clicked;dw_2.InsertRow(0)

p_can.Enabled = True
p_can.PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_search from w_inherite_standard`p_search within w_pik1119
boolean visible = false
integer x = 1842
integer y = 2380
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1119
boolean visible = false
integer x = 2194
integer y = 2380
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1119
boolean visible = false
integer x = 2368
integer y = 2380
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1119
boolean visible = false
integer x = 1573
integer y = 2380
end type

type st_window from w_inherite_standard`st_window within w_pik1119
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1119
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pik1119
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1119
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1119
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1119
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pik1119
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1119
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1119
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1119
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1119
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1119
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1119
boolean visible = false
end type

type cb_calc from commandbutton within w_pik1119
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
string facename = "굴림체"
string text = "시간계산"
end type

event clicked;///******************************************************************************************/
///*** 일근태시간 계산(처리선택된 자료의 근태자료를 읽어서 아래 사항을 갱신한다)				*/
///*** - 근태 table의 '근무일구분' =  근무일 table(p4_kunmu)의 '근무일구분'인 자료 중       */
///*** 1. 지각시간 : wf_calc_jktime 															 				*/ 
///*** 2. 외출시간 : wf_calc_octime																			*/
///*** 3. 조퇴시간 : wf_calc_jttime																			*/
///*** 4. 근로시간 : wf_calc_kltime																			*/
///*** 5. 연장시간 : wf_calc_yjtime																			*/
///*** 6. 야간시간 : wf_calc_yktime																			*/
///*** 7. 등교시간 : wf_calc_jktime																			*/
///*** 8. 휴일(특근)시간 : wf_calc_htime																		*/
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
//// 마감 처리된 월은 수정 불가
//string ls_flag, ls_yymm
//ls_yymm  = left(ls_kdate, 6) 
//
//SELECT "P4_MFLAG"."GUBN"  
//  INTO :ls_flag  
//  FROM "P4_MFLAG" 
//  where companycode= :gs_company and myymm = :ls_yymm ;
//if ls_flag = '1' then
//	messagebox("확인","마감이 완료된 월 입니다.!!")
//	return
//end if	
//
//sMasterSql = wf_ProcedureSql()
//
//sle_msg.text = '일근태시간 계산 중......'
//SetPointer(HourGlass!)
//
//
//sRtnValue = sqlca.sp_calculation_dkentaetime(ls_kdate,'%',sMasterSql,gs_company,gs_userid, gs_ipaddress);
//
//IF Left(sRtnValue,2) <> 'OK' then
//	MessageBox("확 인","근태시간 계산 실패!!"+"["+sRtnValue+"]")
//	Rollback;
//	SetPointer(Arrow!)
//	sle_msg.text =''
//	Return
//else
//	commit;
//END IF
//
//SetPointer(Arrow!)
//sle_msg.text ='일근태시간 계산 완료!!'
//
//
end event

type st_2 from statictext within w_pik1119
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
string facename = "돋움체"
long textcolor = 65535
long backcolor = 12632256
boolean enabled = false
string text = "※개인별 수정시 Double Click하십시오!"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_pik1119
integer x = 1294
integer y = 8
integer width = 1326
integer height = 216
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pik1119_4"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

type rb_7 from radiobutton within w_pik1119
integer x = 2688
integer y = 148
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "성명순"
end type

event clicked;dw_2.SetRedraw(false)

dw_2.SetSort("empname A")
dw_2.Sort()
dw_2.SetRedraw(true)

end event

type rb_6 from radiobutton within w_pik1119
integer x = 2688
integer y = 72
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사번순"
boolean checked = true
end type

event clicked;dw_2.SetRedraw(false)

dw_2.SetSort("empno A")
dw_2.Sort()
dw_2.SetRedraw(true)


end event

type p_1 from uo_picture within w_pik1119
integer x = 3186
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;w_mdi_frame.sle_msg.text =""

string ls_kdate, ls_deptcode, ls_saup, sflag, sGbn = 'N'
Int    k,il_SearchRow
double stime, ttime, ktime

if dw_1.accepttext() = -1 then return 

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')
ls_saup = dw_3.Getitemstring(dw_3.getrow(),'saup')

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("확 인","근태일자는 필수입력입니다!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'
IF ls_saup = "" OR IsNull(ls_saup) THEN ls_saup = '%'

if dw_3.Accepttext()  = -1 then return 

stime = dw_3.GetitemNumber(1,'chtime')
ttime = dw_3.GetitemNumber(1,'tgtime')
ktime = dw_3.GetitemNumber(1,'kuntime')

if stime = 0 or ttime = 0 or ktime < 0  then

	messagebox("확인","출퇴근시간 및 근로시간을 확인하세요!")
	return
end if

if wf_insert_dkentae(stime, ttime, ktime) = -1 then
	w_mdi_frame.sle_msg.text = '근태 생성 실패!'
	return
end if

Parent.SetRedraw(False)


IF dw_2.retrieve(ls_kdate, ls_deptcode, ls_saup) <= 0 then
 	messagebox("확인","조회한 자료가 없습니다!")
	w_mdi_frame.sle_msg.text ="조회한 자료가 없습니다!" 
	dw_1.setfocus()
	Parent.SetRedraw(True)
	return 1
END IF

ib_any_typing = False
ib_detailflag = False

Parent.SetRedraw(True)




end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_2 from uo_picture within w_pik1119
integer x = 3360
integer y = 24
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string ls_kdate, ls_deptcode

if dw_1.accepttext() = -1 then return

ls_kdate = dw_1.Getitemstring(dw_1.getrow(),'kdate')
ls_deptcode = dw_1.Getitemstring(dw_1.getrow(),'deptcode')

IF ls_kdate = "" OR IsNull(ls_kdate) THEN
	MessageBox("확 인","근태일자는 필수입력입니다!!")
	dw_1.SetColumn("kdate")
	dw_1.SetFocus()
	Return -1
END IF

IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN ls_DeptCode = '%'

if messagebox("전체삭제",string(ls_kdate,'@@@@.@@.@@')+"의 자료를 모두 삭제합니다", &
               Exclamation!, OKCancel!, 2) = 2 then return
					
delete from p4_dkentae
where companycode = :gs_company and kdate = :ls_kdate;

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("에러","전체삭제에 실패했습니다!")
	return
else
	commit;
	w_mdi_frame.sle_msg.text = "전체삭제 완료!"
end if

p_can.Enabled = False
p_can.PictureName = "C:\erpman\image\취소_d.gif"
p_inq.Triggerevent(Clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\전체삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\전체삭제_up.gif"
end event

type gb_3 from groupbox within w_pik1119
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
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_6 from groupbox within w_pik1119
integer x = 2629
integer y = 8
integer width = 375
integer height = 220
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "정렬"
end type

type rr_1 from roundrectangle within w_pik1119
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 232
integer width = 4503
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_1 from u_key_enter within w_pik1119
event ue_key pbm_dwnkey
integer x = 55
integer y = 4
integer width = 1239
integer height = 224
integer taborder = 11
string dataobject = "d_pik1119_1"
boolean border = false
end type

event ue_key;//F1 key를 누르면 코드조회처리함	
IF KeyDown(KeyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemchanged;call super::itemchanged;string ls_kdate, ls_deptcode, ls_dept, ls_dayname, ls_hdayname,snull

w_mdi_frame.sle_msg.text =""

SetNull(snull)

IF this.GetColumnName() = "kdate" THEN
	ls_kdate = this.GetText()
	
	IF ls_kdate ="" OR IsNull(ls_kdate) THEN 
	
		this.setitem(this.getrow(),"kweek",snull)
		Return
	END IF
	
	if F_datechk(ls_kdate) = -1 then
		 messagebox("확인","근태일자를 확인하십시오!")
		 this.SetItem(1,"kdate",snull)
		 this.setcolumn("kdate")
		 return 1
	else
		if f_daygubun(ls_kdate,ls_dayname, ls_hdayname) = -1 then
			messagebox("확인","달력일자와 요일명 및 휴무명 참조테이블을 확인하십시오!")
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
	
	IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN RETURN
	
	//부서코드 검사
	SELECT "P0_DEPT"."DEPTCODE"  
		 INTO :ls_dept  
		 FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
	if sqlca.sqlcode <> 0 then
		messagebox("확인","부서코드를 확인하십시오!")
		this.SetItem(1,"deptcode",snull)
		this.setcolumn("deptcode")
		return 1
	end if
	p_inq.TriggerEvent(Clicked!)
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Gs_gubun = is_saupcd
IF this.GetColumnName() = "deptcode"  THEN
	
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

type dw_2 from u_d_select_sort within w_pik1119
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 78
integer y = 236
integer width = 4471
integer height = 2096
integer taborder = 11
string dataobject = "d_pik1119_2"
boolean hscrollbar = false
boolean border = false
end type

event ue_key;IF KeyDown(KeyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this), 256, 9, 0)
Return 1
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

event itemchanged;call super::itemchanged;
String sKtCode,sKtName,snull,sKtDate, sAttendGbn,sYearMonthDay,sYearMonth,sEmpNo,sSex,&
		 sFromDate,sToDate,sAttendTime, shdaygubn, skmgubn,sdate, sname,sss,aaa, sdept, sAttName
Double dJkTime,dJtTime,dOcFrom,dOcTo
Long   lsyday,lscnt, lJkTime, lJtTime,lCkTime,lTkTime,lDkTime,Calc_time
INT    lReturnRow, il_currow , il_count
SetNull(snull)

sle_msg.text =""


this.accepttext()

sDate    = this.GetItemString(1,"kdate")
timegubn = '1'

IF this.getcolumnname() = "empno" THEN
	sEmpNo = this.Gettext()
	IF sEmpNo ="" OR IsNull(sEmpNo) THEN RETURN
	
	SELECT "P1_MASTER"."EMPNAME", "P1_MASTER"."DEPTCODE"   
	   INTO :sname,  :sdept
	   FROM "P1_MASTER"
	   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :sEmpNo)  ;
	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		this.SetItem(this.GetRow(),"deptcode",snull)
		Return 1
	END IF
	lReturnRow = This.Find("empno = '"+sempno+"' ", 1, This.RowCount())
	IF (this.GetRow() <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("확인","등록된 사원입니다.~r등록할 수 없습니다.")
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
				MessageBox("확인","등록된 사원입니다.~r등록할 수 없습니다.")
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
	
	this.SetItem(this.GetRow(),"hdaygubn",shdaygubn)
	this.SetItem(this.GetRow(),"kmgubn",skmgubn)
	this.SetItem(this.GetRow(),"empname",sname)
	this.SetItem(this.GetRow(),"deptcode",sdept)
	
	string sMaxDate ,sDeptCode, sPrtDept 
	int iMaxSeq
	
	SELECT MAX("REALORDDATEFROM")													/*최신발령일자*/
			INTO :sMaxDate
			FROM "P1_ORDERS"
			WHERE "COMPANYCODE" = :gs_company AND "EMPNO" = :sEmpNo and
					"REALORDDATEFROM" <= :sdate ;
	IF sqlca.sqlcode <> 0 then
		sMaxDate= ''
	END IF	
			
	SELECT MAX("P1_ORDERS"."SEQ")
     INTO :iMaxSeq
	  FROM "P1_ORDERS"  
	 WHERE ( "P1_ORDERS"."EMPNO" = :sEmpno ) AND  
			 ( "P1_ORDERS"."REALORDDATEFROM" = :sMaxDate ) ;			
	IF sqlca.sqlcode <> 0 then
		iMaxSeq= 0
	END IF	
		
	/*소속부서,출력부서 구하기*/
	SELECT "P1_ORDERS"."DEPTCODE",   "P1_ORDERS"."PRTDEPT"  
	  INTO :sDeptCode,   			:sPrtDept  
	  FROM "P1_ORDERS"  
    WHERE ( "P1_ORDERS"."COMPANYCODE" = :gs_company ) AND  
		    ( "P1_ORDERS"."EMPNO" = :sEmpNo ) AND  
			 ( "P1_ORDERS"."REALORDDATEFROM" = :sMaxDate ) AND
			 ("P1_ORDERS"."SEQ" = :iMaxSeq) ;
	IF sqlca.sqlcode <> 0 then
		Messagebox("확 인","발령자료가 등록되지 않은 사원이므로 등록할 수 없습니다!!")
		this.SetItem(this.GetRow(),"empno",snull)
		this.SetItem(this.GetRow(),"empname",snull)
		Return 1
	ELSE
		this.setitem(this.GetRow(),'deptcode',sdeptcode)
		this.setitem(this.GetRow(),'p4_dkentae_prtdept',sprtdept)
	END IF	
	
	
ELSE
	sEmpNo = this.Getitemstring(this.GetRow(),'empno')
END IF	

IF this.getcolumnname() = "ktcode" THEN
	sKtCode = this.GetText()
	
	IF sKtCode = "" OR IsNull(sKtCode) THEN
		sAttendTime = '1'
		this.SetItem(this.GetRow(),"attendancetime",'1')
		
//		Wf_Get_CtTime(this.GetItemString(this.GetRow(),"kmgubn"),lCkTime,lTkTime)
//		
//		this.SetItem(this.GetRow(),"cktime",lCkTime)
//		this.SetItem(this.GetRow(),"tktime",lTkTime)		
		Return
   END IF 
	SELECT"ATTENDANCENAME", "ATTENDANCEGUBN", "ATTENDANCETIME" /*근태코드 검사*/
		INTO :sAttName, :sAttendGbn ,:sAttendTime
		FROM "P0_ATTENDANCE"  
		WHERE "P0_ATTENDANCE"."ATTENDANCECODE" = :sKtCode  ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인","근태코드를 확인하십시오!")
		this.SetItem(this.GetRow(),"ktcode",snull)
		this.setcolumn("ktcode")
		this.setfocus()
		return 1
	ELSE
		IF sAttendGbn = '3' THEN
			String gender
			gender = Left(GetItemString(row,"residentno2"),1)
			IF gender <> '2' and gender <> '4' THEN
				MessageBox("확인","남자 사원이므로 '"+sAttName+"' 근태를   ~r~r~n      사용할 수 없습니다.",Exclamation!)
				this.SetItem(this.GetRow(),"ktcode",snull)
				this.setcolumn("ktcode")
				this.setfocus()
				return 1
			END IF
		END IF
		
		this.SetItem(this.GetRow(),"attendancetime",sAttendTime)	
	END IF
	
	sKtDate   = this.Getitemstring(this.GetRow(),'kdate')
	
	
	IF sAttendTime = '1' THEN													/*시간 입력 가능*/
	ELSE
		wf_init_clear(this.GetRow())
	END IF	
END IF

double sjikak,jotoei,ochul
IF this.GetColumnName() = 'jkgtime' THEN
	sjikak = Double(Trim(this.GetText()))
	IF IsNull(sjikak) THEN sjikak =0	
	IF sjikak <> 0 THEN		
		this.SetItem(this.GetRow(),"jkgubn",'1')		
	END IF
END IF

IF this.GetColumnName() = 'jtgktime' THEN
	jotoei = Double(Trim(this.GetText()))
	IF IsNull(jotoei) THEN jotoei =0		
	IF jotoei <> 0 THEN
		this.SetItem(this.GetRow(),"jtgubn",'1')		
	END IF		
END IF

IF this.GetColumnName() = 'ocgttime' THEN
	ochul = Double(Trim(this.GetText()))
	IF IsNull(ochul) THEN ochul =0		
	IF ochul <> 0 THEN
		this.SetItem(this.GetRow(),"occnt",1)		
	END IF		
END IF

ib_detailflag = True



end event

event itemerror;call super::itemerror;Return 1
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

event rowfocuschanged;call super::rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

