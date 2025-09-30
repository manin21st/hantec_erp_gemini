$PBExportHeader$w_kbgb01.srw
$PBExportComments$예산 특인 신청등록
forward
global type w_kbgb01 from w_inherite
end type
type p_cancle from uo_picture within w_kbgb01
end type
type st_2 from statictext within w_kbgb01
end type
type dw_print from datawindow within w_kbgb01
end type
type dw_ret1 from datawindow within w_kbgb01
end type
type dw_ret2 from datawindow within w_kbgb01
end type
type dw_ip from datawindow within w_kbgb01
end type
end forward

shared variables

end variables

global type w_kbgb01 from w_inherite
string title = "예산 특인 신청 등록"
boolean resizable = true
p_cancle p_cancle
st_2 st_2
dw_print dw_print
dw_ret1 dw_ret1
dw_ret2 dw_ret2
dw_ip dw_ip
end type
global w_kbgb01 w_kbgb01

type variables
string is_saupj, is_exe_ymd, is_exe_gu
double idb_exe_amt
long il_exe_no
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer wf_get_remain (string sflag, string smonth, string sacc1, string sacc2, string scdept, ref double dremain)
public function integer wf_insert_kfe01om0 (string ssaupj, string saccyy, string sdeptcd, string sacc1, string sacc2)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
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
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public function integer wf_get_remain (string sflag, string smonth, string sacc1, string sacc2, string scdept, ref double dremain);/*예산마스타 잔액검사		*/
/* 예산 잔액 = 기본금액 + 전월이월 - 차월이월 + 조기집행 + 전용 + 추가 - 집행 - 가집행		*/
String sSaupj,sYear,sExeGbn,sContRolGbn,sCalc_FromYearMon, sCalc_ToYearMon

Double dQurRemain,dJAmt

dw_ip.AcceptText()
sSaupj  = dw_ip.GetItemString(1,"saupj")
sYear   = Left(dw_ip.GetItemString(1,"exe_ymd"),4)
sExeGbn = dw_ip.GetItemString(1,"exe_gu")

IF sSaupj = "" OR IsNull(sSaupj) THEN 
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -2
END IF

IF sYear = "" OR IsNull(sYear) THEN 
	F_MessageChk(1,'[조정처리일자]')
	dw_ip.SetColumn("exc_ymd")
	dw_ip.SetFocus()
	Return -2
END IF

IF sMonth = "" OR IsNull(sMonth) THEN Return 2
IF sAcc1 = "" OR IsNull(sAcc1) THEN Return 2
IF sAcc2 = "" OR IsNull(sAcc2) THEN Return 2
IF sCdept = "" OR IsNull(sCdept) THEN Return 2

SELECT "SYSCNFG"."DATANAME"									/*예산통제구분*/
	INTO :sControlGbn
	FROM "SYSCNFG"  
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 7 ) AND  
     		( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	sContRolGbn = '1'
ELSE
	If IsNull(sControlGbn) THEN sControlGbn = '1'
END IF

SELECT ( NVL("KFE01OM0"."BGK_AMT1",0) + 
			NVL("KFE01OM0"."BGK_AMT2",0) - 
			NVL("KFE01OM0"."BGK_AMT3",0) + 
			NVL("KFE01OM0"."BGK_AMT4",0) + 
			NVL("KFE01OM0"."BGK_AMT5",0) + 
			NVL("KFE01OM0"."BGK_AMT6",0) - 
			NVL("KFE01OM0"."BGK_AMT7",0) - 
			NVL("KFE01OM0"."BGK_AMT8",0) )  
	INTO :dRemain
	FROM "KFE01OM0"  
	WHERE ( "KFE01OM0"."SAUPJ" = :sSaupj ) AND 
			( "KFE01OM0"."ACC_YY"||"KFE01OM0"."ACC_MM" = :sYear||:sMonth ) AND
			( "KFE01OM0"."DEPT_CD" = :sCdept ) AND  
			( "KFE01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFE01OM0"."ACC2_CD" = :sAcc2 ) ;
IF SQLCA.SQLCODE <> 0 THEN
	IF sFlag = '2' THEN
		F_MessageChk(20,'[예산배정자료]')
		Return -1
	END IF
ELSE
	IF sExeGbn <> '50' THEN
		IF (IsNull(dRemain) OR dRemain = 0) AND sFlag = '2' THEN
			F_MessageChk(20,'[예산잔액]')
			Return -1
		END IF
		IF sContRolGbn = '2' THEN
			SELECT MIN("KFE01OM0"."ACC_YY"||"KFE01OM0"."ACC_MM"),MAX("KFE01OM0"."ACC_YY"||"KFE01OM0"."ACC_MM")  
				INTO :sCalc_FromYearMon,								  :sCalc_ToYearMon
				FROM "KFE01OM0"  
				WHERE "KFE01OM0"."SAUPJ"   = :sSaupj AND "KFE01OM0"."ACC_YY" = :sYear AND
						"KFE01OM0"."QUARTER" = 
						( SELECT DISTINCT "KFE01OM0"."QUARTER"  
								FROM "KFE01OM0"  
								WHERE ( "KFE01OM0"."ACC_YY" = :sYear) AND 
										( "KFE01OM0"."ACC_MM" = :sMonth ) AND 
										( "KFE01OM0"."QUARTER" IS NOT NULL )) AND
						"KFE01OM0"."GUBUN1" = 'Y' ;
			IF SQLCA.SQLCODE <> 0 THEN
				sCalc_FromYearMon  = '000000'
				sCalc_ToYearMon    = '000000'
			ELSE
				IF IsNull(sCalc_FromYearMon) THEN sCalc_FromYearMon = '000000'
				IF IsNull(sCalc_ToYearMon) THEN sCalc_ToYearMon = '000000'
			END IF
		ELSE
			sCalc_FromYearMon  = sYear+sMonth
			sCalc_ToYearMon    = sYear+sMonth
		END IF

		SELECT sum(( NVL("KFE01OM0"."BGK_AMT1",0) + 
					NVL("KFE01OM0"."BGK_AMT2",0) - 
					NVL("KFE01OM0"."BGK_AMT3",0) + 
					NVL("KFE01OM0"."BGK_AMT4",0) + 
					NVL("KFE01OM0"."BGK_AMT5",0) + 
					NVL("KFE01OM0"."BGK_AMT6",0) - 
					NVL("KFE01OM0"."BGK_AMT7",0) - 
					NVL("KFE01OM0"."BGK_AMT8",0) ))  
			INTO :dQurRemain
			FROM "KFE01OM0"  
			WHERE ( "KFE01OM0"."SAUPJ" = :sSaupj ) AND 
					( "KFE01OM0"."ACC_YY"||"KFE01OM0"."ACC_MM" >= :sCalc_FromYearMon ) AND  
					( "KFE01OM0"."ACC_YY"||"KFE01OM0"."ACC_MM" <= :sCalc_ToYearMon ) AND 
					( "KFE01OM0"."DEPT_CD" = :sCdept ) AND  
					( "KFE01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFE01OM0"."ACC2_CD" = :sAcc2 ) ;
		IF IsNull(dQurRemain) THEN dQurRemain = 0
		
//		/*조정신청자료 중 미승인 자료 포함:2002.12.28*/
//		select sum(decode(b.ft_gu,'1',nvl(b.exe_amt,0),nvl(b.exe_amt,0) * -1))
//			into :dJAmt
//			from kfe02om0 a, kfe02ot0 b
//			where a.saupj = b.saupj and a.exe_ymd = b.exe_ymd and
//					a.exe_no = b.exe_no and a.exe_gu = b.exe_gu and
//					a.saupj = :sSaupj and a.exe_ymd like :sYear||'%' and
//					a.exe_alc = 'N' and
//					b.acc1_cd = :sAcc1 and b.acc2_cd = :sAcc2 and
//					b.dept_cd = :sCdept and b.acc_mm = :sMonth ;
//		IF IsNull(dJAmt) THEN dJAmt = 0
//		
//		dRemain = dRemain + dJAmt
		
		IF sFlag = '1' THEN Return 1
		
		IF (dQurRemain < Idb_Exe_Amt) and sFlag = '2' THEN
			F_MessageChk(20,'[예산분기잔액]')
			Return -1
		END IF
	END IF
END IF

Return 1
end function

public function integer wf_insert_kfe01om0 (string ssaupj, string saccyy, string sdeptcd, string sacc1, string sacc2);Integer i,iQtr
String  sMm

For i = 1  to 12
	sMm = String(i,'00');
	
	iqtr = ceiling(i/3)
	
	insert into kfe01om0
		(saupj,		acc_yy,		acc_mm,		acc1_cd,		acc2_cd,		dept_cd,
		 bgk_amt1,	bgk_amt2,	bgk_amt3,	bgk_amt4,	bgk_amt5,	bgk_amt6,
		 bgk_amt7,	bgk_amt8,	bgk_txt,		bgk_amtb,	quarter,		gubun1 ) 
	values
		(:sSaupj,	:sAccYy,		:sMm,			:sAcc1,		:sAcc2,		:sDeptCd,
		 0,			0,				0,				0,				0,				0,
		 0,			0,				0,				0,				:iQtr,		'Y')  ;
	if sqlca.sqlcode <> 0 then
		rollback;
		F_MessageChk(13,'')
		Return -1
	end if 
Next
Commit;
Return 1
end function

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_ret1.SetTransObject(sqlca)
dw_ret2.SetTransObject(sqlca)

dw_print.SetTransObject(sqlca)
dw_print.Reset()

dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ret1.Reset()
dw_ret1.InsertRow(0)
dw_ret2.Reset()
dw_ret2.InsertRow(0)

dw_ip.Setitem(dw_ip.Getrow(),"saupj", gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd",String(Today(),"yyyymmdd"))
dw_ip.SetColumn("exe_gu")
dw_ip.SetFocus()

IF F_Valid_EmpNo(Gs_EmpNo) = 'Y' THEN
	dw_ip.Modify("saupj.protect = 0")	
ELSE
	dw_ip.Modify("saupj.protect = 1")	
END IF

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ret1.SetItem(dw_ret1.GetRow(),"dept_cd",    Gs_Dept)
	
	dw_ret1.Modify("dept_cd.protect = 1")
ELSE
	dw_ret1.Modify("dept_cd.protect = 0")
END IF

p_print.enabled = false


end event

on w_kbgb01.create
int iCurrent
call super::create
this.p_cancle=create p_cancle
this.st_2=create st_2
this.dw_print=create dw_print
this.dw_ret1=create dw_ret1
this.dw_ret2=create dw_ret2
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_cancle
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.dw_ret1
this.Control[iCurrent+5]=this.dw_ret2
this.Control[iCurrent+6]=this.dw_ip
end on

on w_kbgb01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_cancle)
destroy(this.st_2)
destroy(this.dw_print)
destroy(this.dw_ret1)
destroy(this.dw_ret2)
destroy(this.dw_ip)
end on

event closequery;call super::closequery;lstr_jpra.flag =True

end event

type dw_insert from w_inherite`dw_insert within w_kbgb01
boolean visible = false
end type

type p_delrow from w_inherite`p_delrow within w_kbgb01
boolean visible = false
integer x = 3323
integer y = 372
end type

type p_addrow from w_inherite`p_addrow within w_kbgb01
boolean visible = false
integer x = 3150
integer y = 372
end type

type p_search from w_inherite`p_search within w_kbgb01
integer x = 3296
integer y = 12
boolean originalsize = true
string picturename = "C:\erpman\image\자료조회_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)

open(w_kbgb01a)

if Not Isnull(gs_code) then
	
   dw_ip.Setitem(dw_ip.Getrow(),"saupj",   Left(gs_code,2))          /* 사업장      */
   dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd", Mid(gs_code,3,8))         /* 조정 처리일 */
   dw_ip.Setitem(dw_ip.Getrow(),"exe_no",  long(Mid(gs_code,11,6)))  /* 조정번호    */ 
	
   p_inq.TriggerEvent(Clicked!)
	
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\자료조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kbgb01
integer x = 3849
integer y = 12
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event p_ins::clicked;call super::clicked;string ls_acc_yy,ls_saupj ,sqlfd, sqlfd3, get_code, get_name, snull
string lst_acc1_cd,lst_acc2_cd,lst_dept_cd, lst_acc_mm, &
       lsf_acc1_cd,lsf_acc2_cd,lsf_dept_cd, lsf_acc_mm
long rowno1, rowno2, sqlfd2, sqlfd5
double ldb_exe_amt,sqlfd4

SetNull(snull)

Setpointer(HourGlass!)

if dw_ip.AcceptText() = -1 then return

is_saupj    = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
is_exe_ymd  = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd")
il_exe_no   = dw_ip.GetitemNumber(dw_ip.Getrow(),"exe_no")
is_exe_gu   = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_gu")
idb_exe_amt = dw_ip.Getitemnumber(dw_ip.Getrow(),"exe_amt")

if is_saupj = "" or IsNull(is_saupj) then
   F_MessageChk(1, "[사업장]")		
	dw_ip.Setcolumn('saupj')
	dw_ip.Setfocus()
   return 
else
	
	SELECT "REFFPF"."RFGUB"  INTO :sqlfd  FROM "REFFPF"
   	WHERE "REFFPF"."RFCOD" = 'AD' and "REFFPF"."RFGUB" = :is_saupj ;
   if sqlca.sqlcode <> 0 then
      messagebox("확 인","사업장을 확인하십시오")
		dw_ip.Setcolumn('saupj')
		dw_ip.Setfocus()
      return 
   end if
end if

if trim(is_exe_ymd) = '' or isnull(is_exe_ymd) then 
   F_MessageChk(1, "[특인처리일]")			
	dw_ip.Setcolumn('exe_ymd')
	dw_ip.Setfocus()
	return 
else
	if f_datechk(is_exe_ymd) = -1 then
		F_MessageChk(21, "[특인처리일]")		
		dw_ip.Setcolumn('exe_ymd')
		dw_ip.Setfocus()
      return
	end if
end if


if trim(is_exe_gu) = "" or Isnull(is_exe_gu) then
   messagebox("확인","특인구분을 확인하십시오")
	dw_ip.SetColumn('exe_gu')
	dw_ip.SetFocus()		
   return
else
   SELECT "REFFPF"."RFGUB"	INTO :sqlfd
   	FROM "REFFPF"
   	WHERE "REFFPF"."RFCOD" = 'AE' and "REFFPF"."RFGUB" = :is_exe_gu ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인","특인구분을 확인하십시오")
		dw_ip.SetColumn('exe_gu')
		dw_ip.SetFocus()				
      return
   end if
end if

if idb_exe_amt = 0 or Isnull(idb_exe_amt) then
   messagebox("확인","특인금액을 확인하십시오")
	dw_ip.SetColumn('exe_amt')
	dw_ip.SetFocus()			
   return
end if

// TO 예산마스타 자료유무 검사

if dw_ret1.GetRow() <= 0 then return 
if dw_ret1.AcceptText() = -1 then return 

lst_dept_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"dept_cd")
lst_acc_mm   = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc_mm")
lst_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")
lst_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")
//ldb_exe_amt = dw_ret1.Getitemdecimal(dw_ret1.Getrow(),"exe_amt")

if isnull(lst_dept_cd) or trim(lst_dept_cd) = "" then
	F_MessageChk(1, "[to 예산부서]")			
	dw_ret1.SetColumn('dept_cd')
	dw_ret1.setfocus()
	return
else
	SELECT "KFE03OM0"."DEPTCODE",   
			  "KFE03OM0"."DEPTNAME"  
		 INTO :get_code,    
				:get_name  
		 FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :lst_dept_cd   ;
	if sqlca.sqlcode = 0 then 	
		dw_ret1.SetItem(dw_ret1.GetRow(), 'dept_cd', get_code)
	else
		F_MessageChk(41, "[to 예산부서]")									
		dw_ret1.SetItem(dw_ret1.GetRow(), 'dept_cd', snull)
		dw_ret1.SetColumn('dept_cd')
		dw_ret1.setfocus()
		return
	end if 
end if

if trim(lst_acc_mm) = '' or  isnull(lst_acc_mm) then
	F_MessageChk(1, "[to 특인월]")
	dw_ret1.SetColumn('acc_mm')
	dw_ret1.Setfocus()
   return 
end if

lst_acc_mm = String(Integer(lst_acc_mm),"00")
dw_ret1.setitem(dw_ret1.getrow(),"acc_mm",lst_acc_mm)

ls_saupj    = is_saupj

ls_acc_yy   = Left(is_exe_ymd,4)

SELECT ("KFE01OM0"."BGK_AMT1" + "KFE01OM0"."BGK_AMT2" - 
        "KFE01OM0"."BGK_AMT3" + "KFE01OM0"."BGK_AMT4" + 
		  "KFE01OM0"."BGK_AMT5" + "KFE01OM0"."BGK_AMT6" - 
		  "KFE01OM0"."BGK_AMT7" - "KFE01OM0"."BGK_AMT8")  
INTO :sqlfd4
FROM "KFE01OM0"  
WHERE ( "KFE01OM0"."SAUPJ" = :is_saupj ) AND  
      ( "KFE01OM0"."ACC_YY" = :ls_acc_yy ) AND  
      ( "KFE01OM0"."ACC_MM" = :lst_acc_mm ) AND  
      ( "KFE01OM0"."DEPT_CD" = :lst_dept_cd ) AND  
      ( "KFE01OM0"."ACC1_CD" = :lst_acc1_cd ) AND  
      ( "KFE01OM0"."ACC2_CD" = :lst_acc2_cd ) ;
if sqlca.sqlcode <> 0 then
	if Wf_Insert_Kfe01om0(is_saupj,ls_acc_yy,lst_dept_cd,lst_acc1_cd,lst_acc2_cd) <> 1 then
		F_MessageChk(12,'[예산배정생성]')
		Return
	end if
	
//   messagebox("확인","예산마스타(TO)에 등록된 자료가 없습니다!")
//   dw_ret1.Setfocus()
//   return	
end if

// FROM 예산마스타 자료유무 검사
if is_exe_gu <> "50" then
	
   if dw_ret2.AcceptText() = -1 then return 
	
   lsf_dept_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"dept_cd")
   lsf_acc_mm   = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc_mm")
   lsf_acc1_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc1_cd")
   lsf_acc2_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc2_cd")
   
	// 예산부서 
	if isnull(lsf_dept_cd) or trim(lsf_dept_cd) = "" then
		F_MessageChk(1, "[from 예산부서]")			
		dw_ret2.SetColumn('dept_cd')
		dw_ret2.setfocus()
		return
	else
		SELECT "KFE03OM0"."DEPTCODE",   
			  "KFE03OM0"."DEPTNAME"  
		 INTO :get_code,    
				:get_name  
		 FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :lsf_dept_cd   ;
		if sqlca.sqlcode = 0 then 	
			dw_ret2.SetItem(dw_ret2.GetRow(), 'dept_cd', get_code)
		else
			F_MessageChk(41, "[from 예산부서]")									
			dw_ret2.SetItem(dw_ret2.GetRow(), 'dept_cd', snull)
			dw_ret2.SetColumn('dept_cd')
			dw_ret2.setfocus()
			return
		end if 
	end if
	
	// 조정월 check
	if trim(lsf_acc_mm) = '' or  isnull(lsf_acc_mm) then
		F_MessageChk(1, "[from 특인월]")
		dw_ret2.SetColumn('acc_mm')
		dw_ret2.Setfocus()
		return 
	end if
	
	lsf_acc_mm = String(Integer(lsf_acc_mm),"00")
	dw_ret2.setitem(dw_ret2.getrow(),"acc_mm",lsf_acc_mm)

//   ldb_exe_amt = dw_ret2.Getitemdecimal(dw_ret2.Getrow(),"exe_amt")
   ls_saupj    = is_saupj
	
   ls_acc_yy   = Left(is_exe_ymd,4)
	
	// 예산 잔액 = 기본금액 + 전월이월 - 차월이월 + 조기집행 + 전용 + 추가 - 집행 - 가집행
   SELECT ("KFE01OM0"."BGK_AMT1" + "KFE01OM0"."BGK_AMT2" - 
	         "KFE01OM0"."BGK_AMT3" + "KFE01OM0"."BGK_AMT4" + 
				"KFE01OM0"."BGK_AMT5" + "KFE01OM0"."BGK_AMT6" - 
				"KFE01OM0"."BGK_AMT7" - "KFE01OM0"."BGK_AMT8")  
   INTO :sqlfd4
   FROM "KFE01OM0"  
   WHERE ( "KFE01OM0"."SAUPJ" = :is_saupj ) AND  
         ( "KFE01OM0"."ACC_YY" = :ls_acc_yy ) AND  
         ( "KFE01OM0"."ACC_MM" = :lsf_acc_mm ) AND  
         ( "KFE01OM0"."DEPT_CD" = :lsf_dept_cd ) AND  
         ( "KFE01OM0"."ACC1_CD" = :lsf_acc1_cd ) AND  
         ( "KFE01OM0"."ACC2_CD" = :lsf_acc2_cd )  using sqlca ;
   if sqlca.sqlcode <> 0 then
      messagebox("확인", "예산마스타(FROM)에 등록된 자료가 없습니다!")
      dw_ret2.Setfocus()
      return
   else
      if idb_exe_amt > sqlfd4 then
         messagebox("확인","예산잔액을 초과하여 조정할 수 없습니다!")
         dw_ret2.Setfocus()
         return			
      end if
   end if
end if


  // 조정번호를 년도의 최대값으로 갖고옴
  SELECT MAX("KFE02OM0"."EXE_NO") 
  INTO  :sqlfd5
  FROM "KFE02OM0"  
  WHERE ( "KFE02OM0"."SAUPJ" = :ls_saupj ) AND  
        ( SUBSTR("KFE02OM0"."EXE_YMD",1,4) = :ls_acc_yy )  using sqlca ;
if sqlca.sqlcode = 0 then
   if Isnull(sqlfd5) then
      sqlfd5 = 0
   end if
   dw_ip.Setitem(dw_ip.Getrow(),"exe_no",sqlfd5 + 1)
   il_exe_no = sqlfd5 + 1
else
   dw_ip.Setitem(dw_ip.Getrow(),"exe_no",1)
   il_exe_no = 1
end if

messagebox("확인","특인번호를 확인하십시오!")

dw_ret1.Setitem(dw_ret1.Getrow(),"saupj",is_saupj)
dw_ret1.Setitem(dw_ret1.Getrow(),"exe_ymd",is_exe_ymd)
dw_ret1.Setitem(dw_ret1.Getrow(),"exe_amt",idb_exe_amt)
dw_ret1.Setitem(dw_ret1.Getrow(),"exe_no",il_exe_no)
dw_ret1.Setitem(dw_ret1.Getrow(),"exe_gu",is_exe_gu)
dw_ret1.Setitem(dw_ret1.Getrow(),"ft_gu","1")

if is_exe_gu <> "50" then
   dw_ret2.Setitem(dw_ret2.Getrow(),"saupj",is_saupj)
   dw_ret2.Setitem(dw_ret2.Getrow(),"exe_ymd",is_exe_ymd)
   dw_ret2.Setitem(dw_ret2.Getrow(),"exe_amt",idb_exe_amt)
   dw_ret2.Setitem(dw_ret2.Getrow(),"exe_no",il_exe_no)
   dw_ret2.Setitem(dw_ret2.Getrow(),"exe_gu",is_exe_gu)
   dw_ret2.Setitem(dw_ret2.Getrow(),"ft_gu","2")
end if

//자료 입력처리
if is_exe_gu <> "50" then
   if dw_ip.Update() = 1 and dw_ret1.Update() = 1 and dw_ret2.Update() = 1 then
	
      commit ;
      dw_ip.Reset()
      dw_ip.insertrow(0)
      dw_ret1.Reset()
      dw_ret1.insertrow(0)
      dw_ret2.Reset()
      dw_ret2.insertrow(0)

      w_mdi_frame.sle_msg.text = "자료가 입력되었습니다!"
   else
      rollback using sqlca ;
   end if
else
   if dw_ip.Update() = 1 and dw_ret1.Update() = 1 then
		
      commit ;
      dw_ip.Reset()
      dw_ip.insertrow(0)
      dw_ret1.Reset()
      dw_ret1.insertrow(0)
      dw_ret2.Reset()
      dw_ret2.insertrow(0)
      w_mdi_frame.sle_msg.text = "자료가 입력되었습니다!"
   else
      rollback using sqlca ;
   end if
end if
dw_ip.Setitem(dw_ip.Getrow(),"saupj",is_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd",is_exe_ymd)
dw_ip.SetColumn("exe_gu")
dw_ip.SetFocus()

dw_ret2.visible = True
dw_ret1.enabled = True
dw_ret2.enabled = True

end event

type p_exit from w_inherite`p_exit within w_kbgb01
integer x = 4370
integer y = 12
integer taborder = 100
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from w_inherite`p_can within w_kbgb01
boolean visible = false
integer x = 3506
integer y = 408
end type

type p_print from w_inherite`p_print within w_kbgb01
integer x = 3643
integer y = 12
integer taborder = 80
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

event clicked;call super::clicked;string sSaupj, sExeYmd,sExeDesc,sDept
long   lExeNo

if dw_ip.AcceptText() = -1 then return 

sSaupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
sExeYmd  = Trim(dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd"))
lExeNo   = dw_ip.GetitemNumber(dw_ip.Getrow(),"exe_no")
sExeDesc = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_desc")

sDept    = dw_ret1.GetItemString(dw_ret1.GetRow(),"dept_cd")

dw_print.Reset()
if dw_print.retrieve(sSaupj, sExeYmd, sDept, sExeDesc,lExeNo,lExeNo) < 1 then 
	MessageBox("확 인", "출력할 자료가 존재하지 않습니다.!!")
	return 
end if

OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_kbgb01
integer x = 3470
integer y = 12
integer taborder = 40
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;string sqlfd, sqlfd2, sqlfd4, ls_ft_gu, ls_acc1_cd, ls_acc2_cd, snull
long rowno1, rowno2, sqlfd3

SetNull(snull)

dw_ip.AcceptText()
is_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
is_exe_ymd = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd")
il_exe_no  = dw_ip.GetitemNumber(dw_ip.Getrow(),"exe_no")

//코드검사
if is_saupj = "" or IsNull(is_saupj) then
   F_MessageChk(1, "[사업장]")		
	dw_ip.Setcolumn('saupj')
	dw_ip.Setfocus()
   return 
else
	
	SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :is_saupj and 
			"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      messagebox("확 인","사업장코드를 확인하십시오")
		dw_ip.Setcolumn('saupj')
		dw_ip.Setfocus()
      return 
   end if
end if

if trim(is_exe_ymd) = '' or isnull(is_exe_ymd) then 
   F_MessageChk(1, "[특인처리일]")			
	dw_ip.Setcolumn('exe_ymd')
	dw_ip.Setfocus()
	return 
else
	if f_datechk(is_exe_ymd) = -1 then
		F_MessageChk(21, "[특인처리일]")		
		dw_ip.Setcolumn('exe_ymd')
		dw_ip.Setfocus()
      return
	end if
end if

if il_exe_no = 0 or IsNull(il_exe_no) then
   messagebox("확인","특인번호를 확인하십시오")
	dw_ip.Setcolumn('exe_no')
	dw_ip.Setfocus()
   return
end if


//자료유무 검사
  SELECT "KFE02OM0"."SAUPJ",   
         "KFE02OM0"."EXE_YMD",   
         "KFE02OM0"."EXE_NO",
         "KFE02OM0"."EXE_GU"
   INTO :sqlfd, :sqlfd2, :sqlfd3, :sqlfd4
    FROM "KFE02OM0"  
   WHERE ( "KFE02OM0"."SAUPJ" = :is_saupj ) AND  
         ( "KFE02OM0"."EXE_YMD" = :is_exe_ymd ) AND  
         ( "KFE02OM0"."EXE_NO" = :il_exe_no )  using sqlca ;

if sqlca.sqlcode <> 0 then
	F_MessageChk(14, "")
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   return
else
	
   dw_ip.Retrieve(is_saupj,is_exe_ymd,il_exe_no)  //조회화면 표시
	
   is_exe_gu = sqlfd4    //조정구분 검사하여 추가시 화면조정처리함//
	
   /* 추가 및 기타 구분하여 처리함 */
   if is_exe_gu <> "50" then
      rowno1 = dw_ret1.Retrieve(is_saupj,is_exe_ymd,il_exe_no,"1")
      rowno2 = dw_ret2.Retrieve(is_saupj,is_exe_ymd,il_exe_no,"2")
     // TO계정과목명 표시
	  ls_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")
     ls_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")
	  
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd, :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname"," ")
      end if
		
      // FROM 계정과목명 표시
      ls_acc1_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc1_cd")
      ls_acc2_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc2_cd")
		
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd, :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret2.Setitem(dw_ret2.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret2.Setitem(dw_ret2.Getrow(),"accname"," ")
      end if
      dw_ret2.visible = True
     
   else
      rowno1 = dw_ret1.Retrieve(is_saupj,is_exe_ymd,il_exe_no,"1")
     // TO계정과목명 표시
      ls_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")
      ls_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")
		
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd, :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname"," ")
      end if

      dw_ret2.visible = False
      
   end if
/*  */
   if rowno1 < 1 then
      messagebox("확인","원하는 자료가 없습니다!")
      return
   else
      p_ins.enabled = False
      dw_ip.enabled = False
      dw_ret1.enabled = False
      dw_ret2.enabled = False
		
      p_print.enabled = true   // 출력 버튼 활성화 
		
		dw_ip.SetColumn('exe_gu')
      dw_ip.Setfocus()
		
   end if
end if

w_mdi_frame.sle_msg.Text = " "
end event

type p_del from w_inherite`p_del within w_kbgb01
integer x = 4023
integer y = 12
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;string ls_acc1_cd, ls_acc2_cd, sqlfd, sqlfd2, sqlfd4, snull, &
       ls_exe_alc
long rowno1, rowno2, sqlfd3
int  flag

SetNull(snull)

SetPointer(HourGlass!)

dw_ip.AcceptText()


is_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
is_exe_ymd = dw_ip.Getitemstring(dw_ip.Getrow(),"exe_ymd")
il_exe_no  = dw_ip.GetitemNumber(dw_ip.Getrow(),"exe_no")
ls_exe_alc = dw_ip.GetItemString(dw_ip.GetRow(), 'exe_alc')

if is_saupj = "" or IsNull(is_saupj) then
   F_MessageChk(1, "[사업장]")		
	dw_ip.Setcolumn('saupj')
	dw_ip.Setfocus()
   return 
else
	
	SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :is_saupj and 
			"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      messagebox("확 인","사업장을 확인하십시오")
		dw_ip.Setcolumn('saupj')
		dw_ip.Setfocus()
      return 
   end if
end if

if trim(is_exe_ymd) = '' or isnull(is_exe_ymd) then 
   F_MessageChk(1, "[특인처리일]")			
	dw_ip.Setcolumn('exe_ymd')
	dw_ip.Setfocus()
	return 
else
	if f_datechk(is_exe_ymd) = -1 then
		F_MessageChk(21, "[특인처리일]")		
		dw_ip.Setcolumn('exe_ymd')
		dw_ip.Setfocus()
      return
	end if
end if

if il_exe_no = 0 or IsNull(il_exe_no) then
   messagebox("확인","특인번호를 확인하십시오")
	dw_ip.Setcolumn('exe_no')
	dw_ip.Setfocus()
   return
end if

//자료유무 검사
  SELECT "KFE02OM0"."SAUPJ",   
         "KFE02OM0"."EXE_YMD",   
         "KFE02OM0"."EXE_NO",
         "KFE02OM0"."EXE_GU"  
   INTO :sqlfd, :sqlfd2, :sqlfd3, :sqlfd4
    FROM "KFE02OM0"  
   WHERE ( "KFE02OM0"."SAUPJ" = :is_saupj ) AND  
         ( "KFE02OM0"."EXE_YMD" = :is_exe_ymd ) AND  
         ( "KFE02OM0"."EXE_NO" = :il_exe_no )  using sqlca ;
if sqlca.sqlcode <> 0 then
   messagebox("확인","원하는 자료가 없습니다!")
   return
else
   if sqlfd4 <> "50" then
      rowno1 = dw_ret1.Retrieve(is_saupj,is_exe_ymd,il_exe_no,"1")
      rowno2 = dw_ret2.Retrieve(is_saupj,is_exe_ymd,il_exe_no,"2")
     // TO계정과목명 표시
      ls_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")
      ls_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd, :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname"," ")
      end if
     // FROM 계정과목명 표시
      ls_acc1_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc1_cd")
      ls_acc2_cd  = dw_ret2.Getitemstring(dw_ret2.Getrow(),"acc2_cd")
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd, :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret2.Setitem(dw_ret2.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret2.Setitem(dw_ret2.Getrow(),"accname"," ")
      end if
   else
      rowno1 = dw_ret1.Retrieve(is_saupj,is_exe_ymd,il_exe_no,"1")
     // TO계정과목명 표시
      ls_acc1_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc1_cd")
      ls_acc2_cd  = dw_ret1.Getitemstring(dw_ret1.Getrow(),"acc2_cd")
      SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"  
      INTO :sqlfd, :sqlfd2
      FROM "KFZ01OM0"  
      WHERE ( "KFZ01OM0"."ACC1_CD" = :ls_acc1_cd ) AND  
            ( "KFZ01OM0"."ACC2_CD" = :ls_acc2_cd )  using sqlca ;
      if sqlca.sqlcode = 0 then
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname",Trim(sqlfd) + " - " + Trim(sqlfd2))
      else
         dw_ret1.Setitem(dw_ret1.Getrow(),"accname"," ")
      end if
   end if
   if rowno1 < 1 then
      messagebox("확인","원하는 자료가 없습니다!")
      return
   end if
end if

//  (1999.07.08 : 남길현) 추가 : 이미 조정신청 예산승인등록에 승인처리된 자료는 
//                               먼저 승인취소를 한 뒤, 삭제를 진행한다.

if ls_exe_alc = 'Y' then 
	MessageBox("확 인", "이미 승인처리된 자료이므로 " + "~n" + &
							  "~n" + "승인 취소를 하신 후, 삭제하십시오!!")
	return 
end if


//확인처리 메세지
flag = messagebox("확인","자료를 삭제하시겠습니까?",Exclamation!,OKCancel!,1)

if flag <> 1 then 
   return
end if

if sqlfd4 <> "50" then
	if dw_ip.DeleteRow(0) = 1 and dw_ret1.DeleteRow(0) = 1 and dw_ret2.DeleteRow(0) = 1 then
		dw_ip.Update();  dw_ret1.Update();  dw_ret2.Update()
		commit  ;
		w_mdi_frame.sle_msg.Text = "자료가 삭제되었습니다!"
	else
		Rollback using sqlca ;
		return
	end if

else
	if dw_ip.DeleteRow(0) = 1 and dw_ret1.DeleteRow(0) = 1 then
		dw_ip.Update();  dw_ret1.Update()
		commit  ;
		w_mdi_frame.sle_msg.Text = "자료가 삭제되었습니다!"
	else
		Rollback using sqlca ;
		return
	end if
end if

dw_ret2.visible = True

p_ins.enabled  = True
dw_ip.enabled   = True
dw_ret1.enabled = True
dw_ret2.enabled = True

dw_ip.Reset()
dw_ip.Insertrow(0)
dw_ret1.Reset()
dw_ret1.Insertrow(0)
dw_ret2.Reset()
dw_ret2.Insertrow(0)

dw_ip.Setitem(dw_ip.Getrow(),"saupj",is_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd",is_exe_ymd)
dw_ip.SetColumn("exe_gu")
dw_ip.SetFocus()
end event

type p_mod from w_inherite`p_mod within w_kbgb01
boolean visible = false
integer x = 3511
integer y = 244
end type

type cb_exit from w_inherite`cb_exit within w_kbgb01
end type

type cb_mod from w_inherite`cb_mod within w_kbgb01
end type

type cb_ins from w_inherite`cb_ins within w_kbgb01
end type

type cb_del from w_inherite`cb_del within w_kbgb01
end type

type cb_inq from w_inherite`cb_inq within w_kbgb01
end type

type cb_print from w_inherite`cb_print within w_kbgb01
end type

type st_1 from w_inherite`st_1 within w_kbgb01
end type

type cb_can from w_inherite`cb_can within w_kbgb01
end type

type cb_search from w_inherite`cb_search within w_kbgb01
end type







type gb_button1 from w_inherite`gb_button1 within w_kbgb01
end type

type gb_button2 from w_inherite`gb_button2 within w_kbgb01
end type

type p_cancle from uo_picture within w_kbgb01
integer x = 4197
integer y = 12
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;dw_ret2.visible = True

p_ins.enabled = True
dw_ip.enabled = True
dw_ret1.enabled = True
dw_ret2.enabled = True

dw_ip.Reset()
dw_ip.Insertrow(0)
dw_ret1.Reset()
dw_ret1.Insertrow(0)
dw_ret2.Reset()
dw_ret2.Insertrow(0)

w_mdi_frame.sle_msg.text = " "
dw_ip.Setitem(dw_ip.Getrow(),"saupj",gs_saupj)
dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd",String(Today(),"yyyymmdd"))
dw_ip.SetColumn("exe_gu")
dw_ip.SetFocus()

p_print.enabled = false


//dw_ip.Setitem(dw_ip.Getrow(),"saupj",is_saupj)
//dw_ip.Setitem(dw_ip.Getrow(),"exe_ymd",is_exe_ymd)
//dw_ip.SetColumn("exe_gu")
//dw_ip.SetFocus()
//sle_msg.Text = " "
end event

type st_2 from statictext within w_kbgb01
integer x = 128
integer y = 1172
integer width = 434
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "[조정 상세]"
boolean focusrectangle = false
end type

type dw_print from datawindow within w_kbgb01
boolean visible = false
integer x = 2153
integer y = 16
integer width = 302
integer height = 132
string title = "추가 예산 편성 신청서"
string dataobject = "dw_kbgb01_7"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_ret1 from datawindow within w_kbgb01
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 128
integer y = 1236
integer width = 2034
integer height = 940
integer taborder = 20
string dataobject = "dw_kbgb01_2"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;/* 예산마스타를 검색하여 조정전,후의 예산잔액을 표시하여줌 */

String  sCdept, sAcc1, sAcc2, sMonth,sAccName,sNull
Double  dRemain
Integer iValue

SetNull(snull)

dw_ip.AcceptText()
iDb_Exe_Amt = dw_ip.GetItemNumber(1,"exe_amt")
IF IsNull(iDb_Exe_Amt) THEN iDb_Exe_Amt = 0

IF this.GetColumnName() = 'dept_cd' then
	sCdept = this.GetText()
	IF sCdept = "" OR IsNull(sCdept) THEN Return
	
	SELECT "KFE03OM0"."DEPTCODE"  	INTO :sCdept
		FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :sCdept ;

	If sqlca.sqlcode <> 0 then 	
	   F_MessageChk(20,'[예산부서]')						
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		return 1
	end if 
	
	iValue = Wf_Get_Remain('1',this.GetItemString(this.GetRow(),"acc_mm"),&
						  this.GetItemString(this.GetRow(),"acc1_cd"),&	
						  this.GetItemString(this.GetRow(),"acc2_cd"),&
						  sCdept,dRemain)
						  
	IF iValue < 1 THEN
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + iDb_Exe_Amt)
	END IF
END IF

if this.GetColumnName() = 'acc1_cd' then 
	sAcc1 = this.GetText()
	IF sAcc1 ="" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.GetItemString(this.GetRow(), 'acc2_cd')
	IF sAcc2 ="" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	
	iValue = Wf_Get_Remain('1',this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + iDb_Exe_Amt)
	END IF
	
end if

if this.GetColumnName() = 'acc2_cd' then 
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.GetItemString(this.GetRow(), 'acc1_cd')
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	iValue = Wf_Get_Remain('1',this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + iDb_Exe_Amt)
	END IF
end if

if this.GetColumnName() = 'acc_mm' then 
	sMonth = this.GetText()
	IF sMonth = "" OR IsNull(sMonth) THEN Return
	
	IF Integer(sMonth) < 1 OR Integer(sMonth) > 12 THEN
		this.SetItem(this.Getrow(),"acc_mm",snull)
	  	Return 1
	END IF

	iValue = Wf_Get_Remain('1',sMonth,&
								  this.GetItemString(this.GetRow(),"acc1_cd"),&
								  this.GetItemString(this.GetRow(),"acc2_cd"),&
								  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc_mm", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain + iDb_Exe_Amt)
	END IF

end if


end event

event rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd" or  this.GetColumnName() = "acc2_cd" THEN 

	gs_code = Trim(this.GetItemString(this.GetRow(), "acc1_cd"))
	
	IF IsNull(gs_code) then
		gs_code =""
	end if
	
	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		dw_ret1.SetItem(dw_ret1.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ret1.SetItem(dw_ret1.GetRow(), "acc2_cd", Mid(gs_code,6,2))
		dw_ret1.SetItem(dw_ret1.GetRow(), "accname", gs_codename)
	end if
	this.TriggerEvent(ItemChanged!)

end if

end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type dw_ret2 from datawindow within w_kbgb01
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 2455
integer y = 1236
integer width = 2034
integer height = 940
integer taborder = 30
string dataobject = "dw_kbgb01_3"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)

Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;/* 예산마스타를 검색하여 조정전,후의 예산잔액을 표시하여줌 */

String  sCdept, sAcc1, sAcc2, sMonth,sAccName,sNull
Double  dRemain
Integer iValue

SetNull(snull)

dw_ip.AcceptText()
iDb_Exe_Amt = dw_ip.GetItemNumber(1,"exe_amt")
IF IsNull(iDb_Exe_Amt) THEN iDb_Exe_Amt = 0

IF this.GetColumnName() = 'dept_cd' then
	sCdept = this.GetText()
	IF sCdept = "" OR IsNull(sCdept) THEN Return
	
	SELECT  "KFE03OM0"."DEPTCODE"  	INTO :sCdept
		FROM "KFE03OM0"  
		WHERE "KFE03OM0"."DEPTCODE" = :sCdept ;

	If sqlca.sqlcode <> 0 then 	
	   F_MessageChk(20,'[예산부서]')						
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		return 1
	end if 
	
	iValue = Wf_Get_Remain('2',this.GetItemString(this.GetRow(),"acc_mm"),&
						  this.GetItemString(this.GetRow(),"acc1_cd"),&	
						  this.GetItemString(this.GetRow(),"acc2_cd"),&
						  sCdept,dRemain)
						  
	IF iValue < 1 THEN
		this.SetItem(this.GetRow(), 'dept_cd', snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - iDb_Exe_Amt)
	END IF
END IF

if this.GetColumnName() = 'acc1_cd' then 
	sAcc1 = this.GetText()
	IF sAcc1 ="" OR IsNull(sAcc1) THEN Return
	
	sAcc2 = this.GetItemString(this.GetRow(), 'acc2_cd')
	IF sAcc2 ="" OR IsNull(sAcc2) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	
	iValue = Wf_Get_Remain('2',this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - iDb_Exe_Amt)
	END IF
	
end if

if this.GetColumnName() = 'acc2_cd' then 
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return
	
	sAcc1 = this.GetItemString(this.GetRow(), 'acc1_cd')
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return
	
	SELECT "KFZ01OM0"."YACC2_NM"	INTO :sAccName  		/*계정과목명 표시*/
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2) AND
				( "KFZ01OM0"."YESAN_GU" = 'Y' OR "KFZ01OM0"."YESAN_GU" = 'A') ;
	if sqlca.sqlcode = 0 then
	  this.Setitem(this.Getrow(),"accname",sAccName)
	else
		F_MessageChk(25,'')
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
	  	Return 1
	end if
	iValue = Wf_Get_Remain('2',this.GetItemString(this.GetRow(),"acc_mm"),&
						  sAcc1,sAcc2,&
						  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc1_cd", snull)
		this.Setitem(this.Getrow(),"acc2_cd", snull)
		this.Setitem(this.Getrow(),"accname", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - iDb_Exe_Amt)
	END IF
end if

if this.GetColumnName() = 'acc_mm' then 
	sMonth = this.GetText()
	IF sMonth = "" OR IsNull(sMonth) THEN Return
	
	IF Integer(sMonth) < 1 OR Integer(sMonth) > 12 THEN
		this.SetItem(this.Getrow(),"acc_mm",snull)
	  	Return 1
	END IF

	iValue = Wf_Get_Remain('2',sMonth,&
								  this.GetItemString(this.GetRow(),"acc1_cd"),&
								  this.GetItemString(this.GetRow(),"acc2_cd"),&
								  this.GetItemString(this.GetRow(),"dept_cd"),dRemain)
						  
	IF iValue < 1 THEN
		this.Setitem(this.Getrow(),"acc_mm", snull)
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
		Return 1
	ELSEIF iValue = 2 THEN
		this.Setitem(this.Getrow(),"exe_bamt", 0)
   	this.Setitem(this.Getrow(),"exe_aamt", 0)
	ELSE
		this.Setitem(this.Getrow(),"exe_bamt", dRemain)
   	this.Setitem(this.Getrow(),"exe_aamt", dRemain - iDb_Exe_Amt)
	END IF

end if


end event

event rbuttondown;String ls_gj1, ls_gj2

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "acc1_cd" or this.GetColumnName() <> "acc2_cd" THEN 

	this.AcceptText()
	gs_code = Trim(dw_ret2.GetItemString(dw_ret2.GetRow(), "acc1_cd"))
	IF IsNull(gs_code) then
		gs_code =""
	end if

	Open(W_KFE01OM0_POPUP)
	
	if gs_code <> "" and Not IsNull(gs_code) then
		dw_ret2.SetItem(dw_ret2.GetRow(), "acc1_cd", Left(gs_code,5))
		dw_ret2.SetItem(dw_ret2.GetRow(), "acc2_cd", Mid(gs_code,6,2))
		dw_ret2.SetItem(dw_ret2.GetRow(), "accname", gs_codename)
	end if
	
end if

end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type dw_ip from datawindow within w_kbgb01
event ue_pressenter pbm_dwnprocessenter
integer x = 110
integer y = 160
integer width = 3762
integer height = 1008
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kbgb01_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;if this.GetColumnName() = 'exe_desc' or this.GetColumnName() = 'exe_desc2' then return 

Send(Handle(this),256,9,0)

Return 1
end event

event itemchanged;string snull, sqlfd

SetNull(snull)

// 사업장
if this.GetColumnName() = 'saupj' then 
   is_saupj    = this.GetText()
	
	if trim(is_saupj) = '' or isnull(is_saupj) then 
      F_MessageChk(1, "[사업장]")		
		return 1
	end if
	
	SELECT "REFFPF"."RFGUB"  
   INTO :sqlfd
   FROM "REFFPF"
   WHERE "REFFPF"."RFCOD" = 'AD' and
         "REFFPF"."RFGUB" = :is_saupj and 
			"REFFPF"."RFGUB" <> '00'	;
   if sqlca.sqlcode <> 0 then
      F_MessageChk(20, "[사업장]")		
      this.SetItem(row, "saupj", snull)
      return 1
   end if
	
end if


if this.GetColumnName() = 'exe_ymd' then 
	is_exe_ymd = this.GetText()
	
	if trim(is_exe_ymd) = '' or isnull(is_exe_ymd) then 
      F_MessageChk(1, "[조정일자]")				
		return 1
   elseif f_datechk(is_exe_ymd) = -1 then
      F_MessageChk(1, "[조정일자]")				
		return 1
   end if		
	
end if

if this.GetColumnName() = 'exe_gu' then 
	
   is_exe_gu   = this.GetText()
	
	if trim(is_exe_gu) = '' or isnull(is_exe_gu) then 
		return 
	else
		SELECT "REFFPF"."RFGUB"  
		INTO :sqlfd
		FROM "REFFPF"
		WHERE "REFFPF"."RFCOD" = 'AE' and
				"REFFPF"."RFGUB" = :is_exe_gu and  
				"REFFPF"."RFGUB" <> '00';
		if sqlca.sqlcode <> 0 then
			F_MessageChk(20, "[예산조정구분]")		
			dw_ip.SetItem(row, 'exe_gu', snull)
			return 1
		end if
	end if
	
	if is_exe_gu = "50" then  //추가조정//
		dw_ret2.visible = False
	else
		dw_ret2.visible = True
	end if
end if

if this.GetColumnName() = 'exe_amt' then 
	idb_exe_amt = long(this.GetText())
	
	if string(idb_exe_amt) = '' or isnull(idb_exe_amt) then 
      F_MessageChk(1, "[조정금액]")						
		return 1
   end if
end if

il_exe_no   = dw_ip.GetitemNumber(dw_ip.Getrow(),"exe_no")



end event

event itemerror;return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="exe_desc" OR dwo.name ="exe_desc2" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event getfocus;this.AcceptText()
end event

