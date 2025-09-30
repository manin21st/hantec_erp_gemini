$PBExportHeader$w_kgle28.srw
$PBExportComments$외화평가 자동전표 처리
forward
global type w_kgle28 from w_inherite
end type
type rb_1 from radiobutton within w_kgle28
end type
type rb_2 from radiobutton within w_kgle28
end type
type dw_junpoy from datawindow within w_kgle28
end type
type dw_sungin from datawindow within w_kgle28
end type
type dw_print from datawindow within w_kgle28
end type
type dw_sang from datawindow within w_kgle28
end type
type dw_ip from u_key_enter within w_kgle28
end type
type rr_1 from roundrectangle within w_kgle28
end type
type rr_2 from roundrectangle within w_kgle28
end type
type dw_rtv from datawindow within w_kgle28
end type
type dw_delete from datawindow within w_kgle28
end type
end forward

global type w_kgle28 from w_inherite
integer x = 5
integer y = 4
string title = "외화평가 자동전표 처리"
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_sang dw_sang
dw_ip dw_ip
rr_1 rr_1
rr_2 rr_2
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kgle28 w_kgle28

type variables

String sUpmuGbn = 'A',LsAutoSungGbn, LsSonIkAcc, LsSonSilAcc
end variables

forward prototypes
public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount)
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate)
public function integer wf_delete_kfz12ot0 ()
end prototypes

public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount);/*반제 처리 = 반제전표번호를 읽어서 처리*/

String  sCrossNo, sSaupjS,sAccDateS,sUpmuGuS,sBalDateS
Long    lJunNoS,lLinNoS,lBJunNos
Integer iInsertrow

sCrossNo = dw_rtv.GetItemString(icurrow,"crossno")
IF sCrossNo = "" OR IsNull(sCrossNo) THEN
	F_MessageChk(1,'[반제전표번호]')
	Return -1
END IF

sSaupjS   = Left(sCrossNo,1)
sAccDateS = Mid(sCrossNo,2,8)
sUpmuGuS  = Mid(sCrossNo,10,1)
lJunNoS   = Long(Mid(sCrossNo,11,4))
lLinNoS   = Integer(Mid(sCrossNo,15,2)) 
sBalDateS = Mid(sCrossNo,17,8)
lBJunNoS  = Long(Mid(sCrossNo,25,4)) 

iInsertRow = dw_sang.InsertRow(0)
	
dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuGuS)
dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
dw_sang.SetItem(iInsertRow,"lin_no",   lLinNoS)
dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
	
dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
dw_sang.SetItem(iInsertRow,"amt_s",    dAmount)

Return 1
end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate);///************************************************************************************/
/* 외화평가자료를 자동으로 전표 처리한다.															*/
/************************************************************************************/
Integer k,iCurRow
Double  dAmount
Long    lJunNo
String  sAcc_Cha,sAcc_Dae,sSaupNo,sSaupName,sDcGbn,sChaDae,sYesanGbn,sRemark1,sCusGbn,sGbn1,&
		  sSangGbn,sRemark4

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return 1
END IF

SELECT substr("SYSCNFG_A"."DATANAME",1,7),	SUBSTR("SYSCNFG_B"."DATANAME",1,7)
	INTO :LsSonIkAcc,									:LsSonSilAcc			
    FROM "SYSCNFG" "SYSCNFG_A",   "SYSCNFG" "SYSCNFG_B"  
   WHERE ( "SYSCNFG_A"."SYSGU" = 'A' ) AND  
         ( "SYSCNFG_A"."SERIAL" = 18 ) AND  
         ( "SYSCNFG_A"."LINENO" = '6' ) AND  
         ( "SYSCNFG_B"."SYSGU" = 'A' ) AND  
         ( "SYSCNFG_B"."SERIAL" = 18 ) AND  
         ( "SYSCNFG_B"."LINENO" = '7' );    


/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)

w_mdi_frame.sle_msg.text ="외화평가 자동전표 처리 중 ..."

SetPointer(HourGlass!)

dw_junpoy.Reset()

FOR k = 1 TO dw_rtv.RowCount()
	sSaupNo   = dw_rtv.GetItemString(k,"saup_no")
	sSaupName = dw_rtv.GetItemString(k,"saupname")
					
	dAmount   = dw_rtv.GetItemNumber(k,"amount")
	IF IsNull(dAmount) THEN dAmount = 0

	sDcGbn = '1'
	sAcc_Cha  = dw_rtv.GetItemString(k,"cha_acc")			
	
	SELECT "DC_GU",  		"YESAN_GU",			"REMARK1",		"SANG_GU",		"GBN1",	"CUS_GU",   "REMARK4"      
		INTO :sChaDae,		:sYesanGbn,			:sRemark1,		:sSangGbn,		:sGbn1,	:sCusGbn,   :sRemark4
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = Substr(:sAcc_Cha,1,5)) AND  
				( "KFZ01OM0"."ACC2_CD" = Substr(:sAcc_Cha,6,2)) ;
	
	iCurRow = dw_junpoy.InsertRow(0)

	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_ip.GetItemString(1,"deptcode"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
	dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)

	IF sSangGbn = 'Y' AND (sDcGbn <> sChaDae) THEN
		sDcGbn = sChaDae
		dAmount = dAmount * -1	
	ELSE
		dAmount   = dw_rtv.GetItemNumber(k,"amount")
		IF IsNull(dAmount) THEN dAmount = 0
	END IF
	
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	
	dw_junpoy.SetItem(iCurRow,"descr",   '외환평가 대체 전표')
	
	IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_ip.GetItemString(1,"sdeptcode"))
	END IF
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_ip.GetItemString(1,"deptcode"))
	END IF

	IF sCusGbn = 'Y' THEN
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupName)
		
	END IF
	
	if LsSonSilAcc = sAcc_Cha or sRemark4 = 'Y' then
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"y_curr"))
		dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"p_rate"))
		dw_junpoy.SetItem(iCurRow,"k_rate",  dw_rtv.GetItemNumber(k,"y_rate"))
		
		dw_junpoy.SetItem(iCurRow,"y_amt",   0)	
		dw_junpoy.SetItem(iCurRow,"k_amt",   dw_rtv.GetItemNumber(k,"amt"))	
	end if
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	sDcGbn = '2'											
	sAcc_Dae  = dw_rtv.GetItemString(k,"dae_acc")			
	
	SELECT "DC_GU",  		"YESAN_GU",			"REMARK1",		"SANG_GU",		"GBN1",	"CUS_GU",   "REMARK4"       
		INTO :sChaDae,		:sYesanGbn,			:sRemark1,		:sSangGbn,		:sGbn1,	:sCusGbn,   :sRemark4					
		FROM "KFZ01OM0"  
		WHERE ( "KFZ01OM0"."ACC1_CD" = Substr(:sAcc_Dae,1,5)) AND  
				( "KFZ01OM0"."ACC2_CD" = Substr(:sAcc_Dae,6,2)) ;
	
	iCurRow = dw_junpoy.InsertRow(0)

	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", dw_ip.GetItemString(1,"deptcode"))	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
	dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	
	IF sSangGbn = 'Y' AND (sDcGbn <> sChaDae) THEN
		sDcGbn = sChaDae
		dAmount = dAmount * -1	
	ELSE
		dAmount   = dw_rtv.GetItemNumber(k,"amount")
		IF IsNull(dAmount) THEN dAmount = 0
	END IF
	
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
	
	dw_junpoy.SetItem(iCurRow,"descr",   '외환평가 대체 전표')
	
	IF sRemark1 = 'Y' AND sChaDae = sDcGbn THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_ip.GetItemString(1,"sdeptcode"))
	END IF
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",dw_ip.GetItemString(1,"deptcode"))
	END IF

	IF sCusGbn = 'Y' THEN
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo)
		dw_junpoy.SetItem(iCurRow,"in_nm",   sSaupName)
		
	END IF

	if LsSonIkAcc = sAcc_Dae or sRemark4 = 'Y' then
		dw_junpoy.SetItem(iCurRow,"y_curr",  dw_rtv.GetItemString(k,"y_curr"))
		dw_junpoy.SetItem(iCurRow,"y_rate",  dw_rtv.GetItemNumber(k,"p_rate"))
		dw_junpoy.SetItem(iCurRow,"k_rate",  dw_rtv.GetItemNumber(k,"y_rate"))
		
		dw_junpoy.SetItem(iCurRow,"y_amt",   0)	
		dw_junpoy.SetItem(iCurRow,"k_amt",   dw_rtv.GetItemNumber(k,"amt"))	
	end if
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	
	dw_rtv.SetItem(k,"saupj",   sSaupj)
	dw_rtv.SetItem(k,"bal_date",sBalDate)
	dw_rtv.SetItem(k,"upmu_gu", sUpmuGbn)
	dw_rtv.SetItem(k,"bjun_no", lJunNo)
NEXT

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return -1
END IF

IF dw_rtv.Update() <> 1 THEN
	F_MessageChk(13,'[외화평가 자료]')
	SetPointer(Arrow!)	
	RETURN -1
END IF

w_mdi_frame.sle_msg.text ="외화평가 전표 처리 완료!!"

Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull,sCvcod,sMaYm
Long    lJunNo,lNull,lSeqNo

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Continue
		
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			UPDATE "KFZ34OT0"
				SET "SAUPJ" = NULL,	"BAL_DATE" = NULL,	"UPMU_GU" = NULL,	 "BJUN_NO" = NULL
				WHERE ( "SAUPJ"    = :sSaupj ) AND ( "BAL_DATE" = :sBalDate ) AND  
						( "UPMU_GU"  = :sUpmuGu ) AND ( "BJUN_NO"   = :lJunNo ) ;
		END IF
		
		DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
	END IF
NEXT

String sJipFrom,sJipTo,sJipFlag

SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN 
	sJipFlag = 'N'
ELSE
	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
END IF

IF sJipFlag = 'Y' THEN
	sJipFrom = dw_delete.GetItemString(1,"min_ym")
	sJipTo   = dw_delete.GetItemString(1,"max_ym")
	
	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
	w_mdi_frame.sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
	F_ACC_SUM(sJipFrom,sJipTo)
	
	//전사로 집계('00'월)
	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
	
	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
	w_mdi_frame.sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
	
	//stored procedure로 사업부문별 거래처별 집계 처리(시작년월,종료년월)
	w_mdi_frame.sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
END IF

SetPointer(Arrow!)
Return 1

end function

on w_kgle28.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_sang=create dw_sang
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_junpoy
this.Control[iCurrent+4]=this.dw_sungin
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.dw_sang
this.Control[iCurrent+7]=this.dw_ip
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.dw_rtv
this.Control[iCurrent+11]=this.dw_delete
end on

on w_kgle28.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_sang)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",gs_saupj)

dw_ip.SetItem(dw_ip.Getrow(),"baldate",f_today())

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.Modify("saupj.protect = 1")
	dw_ip.SetItem(1,"deptcode",    Gs_Dept)
	
ELSE
	dw_ip.Modify("saupj.protect = 0")
	dw_ip.Modify("deptcode.protect = 0")
END IF	

SELECT substr("SYSCNFG_A"."DATANAME",1,7),	SUBSTR("SYSCNFG_B"."DATANAME",1,7)
	INTO :LsSonIkAcc,									:LsSonSilAcc			
    FROM "SYSCNFG" "SYSCNFG_A",   "SYSCNFG" "SYSCNFG_B"  
   WHERE ( "SYSCNFG_A"."SYSGU" = 'A' ) AND  
         ( "SYSCNFG_A"."SERIAL" = 18 ) AND  
         ( "SYSCNFG_A"."LINENO" = '6' ) AND  
         ( "SYSCNFG_B"."SYSGU" = 'A' ) AND  
         ( "SYSCNFG_B"."SERIAL" = 18 ) AND  
         ( "SYSCNFG_B"."LINENO" = '7' );    
IF F_Get_Remark('S', LsSonIkAcc) = 'Y' OR F_Get_Remark('S', LsSonSilAcc) = 'Y' THEN
	dw_ip.Modify("t_sdept.visible = 1")
ELSE
	dw_ip.Modify("t_sdept.visible = 0")
END IF

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '30' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("baldate")
dw_ip.SetFocus()

w_mdi_frame.sle_msg.text = '선택한 자료를 전표 발행 합니다.!!'

end event

type dw_insert from w_inherite`dw_insert within w_kgle28
boolean visible = false
integer x = 46
integer y = 2668
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgle28
boolean visible = false
integer x = 2747
integer y = 2848
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgle28
boolean visible = false
integer x = 2574
integer y = 2848
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgle28
boolean visible = false
integer x = 1879
integer y = 2848
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgle28
boolean visible = false
integer x = 2400
integer y = 2848
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgle28
integer y = 16
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kgle28
boolean visible = false
integer x = 3269
integer y = 2848
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kgle28
boolean visible = false
integer x = 2158
integer y = 2864
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgle28
integer x = 4096
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sSaupj,sBalDate,sAcCode

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sBalDate = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")
sAcCode  = dw_ip.GetItemString(dw_ip.GetRow(),"accode")

IF ssaupj ="" OR IsNull(ssaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[결산기준일]')	
	dw_ip.SetColumn("baldate")
	dw_ip.SetFocus()
	Return 
END IF

IF sAcCode = '' OR IsNull(sAcCode) THEN sAcCode = '%'

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sBalDate,sAcCode) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
	w_mdi_frame.sle_msg.text = '선택한 자료를 전표 발행 합니다.!!'
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sBalDate,sAcCode) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True

end event

type p_del from w_inherite`p_del within w_kgle28
boolean visible = false
integer x = 3095
integer y = 2848
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kgle28
integer x = 4270
integer y = 16
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;String sSaupj,sBalDate,sDept,sSaupDept,sAlcGbn,sAccDate
Long   lAccJunNo

IF rb_1.Checked =True THEN
	IF dw_rtv.RowCount() <=0 THEN Return
	
	sSaupj    = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	sBalDate  = dw_ip.GetItemString(dw_ip.GetRow(),"baldate")
	sDept     = dw_ip.GetItemString(dw_ip.GetRow(),"deptcode")
	sSaupDept = dw_ip.GetItemString(dw_ip.GetRow(),"sdeptcode")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_ip.Setcolumn("saupj")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sDept = "" OR IsNull(sDept) THEN
		F_MessageChk(1,'[작성부서]')
		dw_ip.Setcolumn("deptcode")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF sBalDate = "" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[결산기준일]')
		dw_ip.Setcolumn("baldate")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF (sSaupDept = "" OR IsNull(sSaupDept)) AND &
		(F_Get_Remark('S', LsSonIkAcc) = 'Y' OR F_Get_Remark('S', LsSonSilAcc) = 'Y') THEN
		F_MessageChk(1,'[원가부문]')
		dw_ip.Setcolumn("sdeptcode")
		dw_ip.SetFocus()
		Return -1
	END IF
	
	IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate) = -1 THEN
		Rollback;
		Return
	ELSE	
		Commit;
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				F_MessageChk(13,'[전표 승인]')
				Rollback;
				Return
			END IF
		END IF
	END IF
	
//	p_print.TriggerEvent(Clicked!)
	
ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_kgle28
boolean visible = false
integer x = 3762
integer y = 2228
end type

type cb_mod from w_inherite`cb_mod within w_kgle28
boolean visible = false
integer x = 3424
integer y = 2228
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kgle28
boolean visible = false
integer x = 2464
integer y = 2592
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kgle28
boolean visible = false
integer x = 2871
integer y = 2584
end type

type cb_inq from w_inherite`cb_inq within w_kgle28
boolean visible = false
integer x = 3063
integer y = 2228
end type

type cb_print from w_inherite`cb_print within w_kgle28
boolean visible = false
integer x = 2121
integer y = 2592
end type

event cb_print::clicked;call super::clicked;//String  sSaupj,sUpmuGu,sBalDate,sCvcod,sMaYm
//Long    lBJunNo,lSeqNo
//Integer i
//
//IF MessageBox("확 인", "출력하시겠습니까?", Question!, OkCancel!, 2) = 2 THEN RETURN
//
//FOR i = 1 TO dw_rtv.RowCount()
//	IF dw_rtv.GetItemString(i,"chk") = '1' THEN
//		sCvcod   = dw_rtv.GetItemString(i,"cvcod")
//		sMaYm    = dw_rtv.GetItemString(i,"mayymm")
//		lSeqNo   = dw_rtv.GetItemNumber(i,"mayyseq")
//		
//		sSaupj   = dw_rtv.GetItemString(i,"saupj")
//		sBalDate = dw_rtv.GetItemString(i,"bal_date") 
//		sUpmuGu  = dw_rtv.GetItemString(i,"upmu_gu") 
//		lBJunNo  = dw_rtv.GetItemNumber(i,"bjun_no") 
//		
//		IF F_Print_Junpoy(dw_print,sSaupj,sBalDate,sUpmuGu,lBJunNo,'%') = -1 THEN
//			F_MessageChk(14,'')
//			Return 1
//		ELSE
//			dw_print.object.datawindow.print.preview="yes"
//			OpenWithParm(w_print_options, dw_Print)
//		END IF
//	END IF
//NEXT
//
end event

type st_1 from w_inherite`st_1 within w_kgle28
boolean visible = false
integer y = 2108
end type

type cb_can from w_inherite`cb_can within w_kgle28
boolean visible = false
integer x = 3218
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kgle28
boolean visible = false
integer x = 1609
integer y = 2596
integer width = 498
string text = "품목보기(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kgle28
boolean visible = false
integer y = 2108
end type

type sle_msg from w_inherite`sle_msg within w_kgle28
boolean visible = false
integer y = 2108
end type

type gb_10 from w_inherite`gb_10 within w_kgle28
boolean visible = false
integer y = 2056
end type

type gb_button1 from w_inherite`gb_button1 within w_kgle28
boolean visible = false
integer x = 2811
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kgle28
boolean visible = false
integer x = 1563
integer y = 2768
integer width = 1129
end type

type rb_1 from radiobutton within w_kgle28
integer x = 3552
integer y = 52
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행처리"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="외화평가 자동전표 발행"

	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("baldate")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kgle28
integer x = 3552
integer y = 152
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제처리"
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="외화평가 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("baldate")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kgle28
boolean visible = false
integer x = 352
integer y = 2644
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_sungin from datawindow within w_kgle28
boolean visible = false
integer x = 352
integer y = 2748
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kgle28
boolean visible = false
integer x = 352
integer y = 2844
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "전표 인쇄"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sang from datawindow within w_kgle28
boolean visible = false
integer x = 352
integer y = 2940
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리결과 저장"
string dataobject = "d_kifa108"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from u_key_enter within w_kgle28
event ue_key pbm_dwnkey
integer x = 23
integer y = 4
integer width = 3099
integer height = 272
integer taborder = 20
string dataobject = "dw_kgle281"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sChoose,sdeptCode,sSdeptCode
Integer i

SetNull(snull)

w_mdi_frame.sle_msg.text = ''

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"결산기준일")
		dw_ip.SetItem(1,"baldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "deptcode" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sSql
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(1,"deptcode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "sdeptcode" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(1,"sdeptcode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="chose" THEN
	sChoose = this.GetText()
	
	IF rb_2.Checked =True THEN
		IF sChoose ='1' THEN
			FOR i =1 TO dw_delete.Rowcount()
				dw_delete.SetItem(i,"chk",'1')
			NEXT
		ELSEIF sChoose ='2' THEN
			FOR i =1 TO dw_delete.Rowcount()
				dw_delete.SetItem(i,"chk",'0')
			NEXT
		END IF
	END IF
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="custf" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"custf",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"custfname", lstr_custom.name)
ELSEIF this.GetColumnName() ="custt" THEN
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"custt",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"custtname", lstr_custom.name)
ELSEIF this.GetColumnName() ="deptf" THEN
	OpenWithParm(W_Kfz04om0_POPUP,'3')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"deptf",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"deptfname", lstr_custom.name)
ELSEIF this.GetColumnName() ="deptt" THEN
	OpenWithParm(W_Kfz04om0_POPUP,'3')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"deptt",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"depttname", lstr_custom.name)
END IF

end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kgle28
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3483
integer y = 12
integer width = 590
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kgle28
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 284
integer width = 4576
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kgle28
integer x = 50
integer y = 296
integer width = 4544
integer height = 1988
integer taborder = 30
string dataobject = "dw_kgle282"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

type dw_delete from datawindow within w_kgle28
integer x = 50
integer y = 296
integer width = 4544
integer height = 1988
integer taborder = 40
string dataobject = "dw_kgle283"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

