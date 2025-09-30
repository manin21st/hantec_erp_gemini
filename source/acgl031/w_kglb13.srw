$PBExportHeader$w_kglb13.srw
$PBExportComments$지급어음 만기결제전표 처리(대변합)
forward
global type w_kglb13 from w_inherite
end type
type gb_1 from groupbox within w_kglb13
end type
type rb_1 from radiobutton within w_kglb13
end type
type rb_2 from radiobutton within w_kglb13
end type
type dw_ip from u_key_enter within w_kglb13
end type
type dw_junpoy from datawindow within w_kglb13
end type
type dw_sungin from datawindow within w_kglb13
end type
type dw_print from datawindow within w_kglb13
end type
type dw_jbill from datawindow within w_kglb13
end type
type cbx_all from checkbox within w_kglb13
end type
type rr_1 from roundrectangle within w_kglb13
end type
type dw_rtv from datawindow within w_kglb13
end type
type dw_delete from datawindow within w_kglb13
end type
end forward

global type w_kglb13 from w_inherite
string title = "지급어음 만기결제전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_jbill dw_jbill
cbx_all cbx_all
rr_1 rr_1
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kglb13 w_kglb13

type variables

String sUpmuGbn = 'H',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno)
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdpno)
public function integer wf_delete_kfz12ot0 ()
end prototypes

public function integer wf_insert_kfz12otc (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno);Integer iFindRow,iCurRow
String  sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+&
					       String(lJunNo,'0000')+String(lLinNo,'000')
					 
iFindRow = dw_jbill.InsertRow(0)
	
dw_jbill.SetItem(iFindRow,"saupj",			sSaupj)
dw_jbill.SetItem(iFindRow,"bal_date",		sBalDate)
dw_jbill.SetItem(iFindRow,"upmu_gu",		sUpmuGbn)
dw_jbill.SetItem(iFindRow,"bjun_no",		lJunNo)
dw_jbill.SetItem(iFindRow,"lin_no",			lLinNo)
dw_jbill.SetItem(iFindRow,"full_junno",	sFullJunNo)

dw_jbill.SetItem(iFindRow,"mbal_date",		sBalDate)
dw_jbill.SetItem(iFindRow,"mupmu_gu",		sUpmuGbn)
dw_jbill.SetItem(iFindRow,"mjun_no",		lJunNo)
dw_jbill.SetItem(iFindRow,"mlin_no",		lLinNo)
	
dw_jbill.SetItem(iFindRow,"bill_no",		dw_rtv.GetItemString(iRow,"bill_no"))
dw_jbill.SetItem(iFindRow,"saup_no",		dw_rtv.GetItemString(iRow,"saup_no"))
dw_jbill.SetItem(iFindRow,"bnk_cd",			dw_rtv.GetItemString(iRow,"bnk_cd"))
dw_jbill.SetItem(iFindRow,"bbal_dat",		dw_rtv.GetItemString(iRow,"bbal_dat"))
dw_jbill.SetItem(iFindRow,"bman_dat",		dw_rtv.GetItemString(iRow,"bman_dat"))
dw_jbill.SetItem(iFindRow,"bill_amt",		dw_rtv.GetItemNumber(iRow,"bill_amt"))
dw_jbill.SetItem(iFindRow,"bill_nm",		dw_rtv.GetItemString(iRow,"bill_nm"))
dw_jbill.SetItem(iFindRow,"status",			'2')

dw_jbill.SetItem(iFindRow,"remark1",		dw_rtv.GetItemString(iRow,"remark1"))

dw_jbill.SetItem(iFindRow,"owner_saupj",	sSaupj)
dw_jbill.SetItem(iFindRow,"bill_gbn",		dw_rtv.GetItemString(iRow,"bill_gbn"))


Return 1
end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdpno);/************************************************************************************/
/* 만기결제 받을어음을 자동으로 전표 처리한다.													*/
/* 1. 차변 : 지급어음계정으로 발생																	*/
/* 2. 대변 : 출금계좌코드의 계정과목으로 발생													*/
/************************************************************************************/
String  sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sSaupNo,sDcGbn,sDepotNo,sBillNo,sStatus,&
		  sBManDate,sBillGbn
Integer k,lLinNo,lJunNo,iCurRow
Double  dAmount,dTAmount

dw_junpoy.Reset()
dw_jbill.Reset()
dw_sungin.Reset()

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()
sBillGbn = dw_ip.GetItemString(1,"bill_gu")

SELECT "KFM04OT0"."ACC1_CD", "KFM04OT0"."ACC2_CD","KFM04OT0"."AB_NO"		/*대변계정*/
	INTO :sAcc1_Dae,   		  :sAcc2_Dae,			  :sDepotNo
   FROM "KFM04OT0"  
   WHERE "KFM04OT0"."AB_DPNO" = :sDpNo   ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","입력하신 계좌코드에 계정과목이 없습니다.!!")
	RETURN -1
END IF

if sBillGbn = '1' then
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*지급어음*/
		INTO :sAcc1_Cha,  						  :sAcc2_Cha	
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '24' )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[지급어음 계정]')
		Return -1
	END IF
else
	SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)		/*전자어음*/
		INTO :sAcc1_Cha,  						  :sAcc2_Cha	
		FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
				( "SYSCNFG"."LINENO" = '91' )  ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(56,'[전자어음 계정]')
		Return -1
	END IF
end if

w_mdi_frame.sle_msg.text ="지급어음 만기결제 자동전표 처리 중 ..."

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF
		
/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1
dTAmount = 0

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN
		sBillNo = dw_rtv.GetItemString(k,"bill_no")
		sStatus = dw_rtv.GetItemString(k,"status")
		sBManDate = dw_rtv.GetItemString(k,"bman_dat")
		
		sSaupNo = dw_rtv.GetItemString(k,"saup_no")
		dAmount = dw_rtv.GetItemNumber(k,"bill_amt")
		
		sDcGbn = '1'											/*차변 전표*/
		
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
		dw_junpoy.SetItem(iCurRow,"descr",   '만기결제')
		
		dw_junpoy.SetItem(iCurRow,"sdept_cd","")
		dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo) 
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kfz04om0_person_nm")) 
		
		IF Wf_Insert_Kfz12otc(k,sSaupj,sBalDate,lJunNo,lLinNo) = 1 THEN
			dw_junpoy.SetItem(iCurRow,"kwan_no", sBillNo) 
			dw_junpoy.SetItem(iCurRow,"k_eymd",  sBManDate) 
			dw_junpoy.SetItem(iCurRow,"jbill_gu",'Y') 
		ELSE
			dw_junpoy.SetItem(iCurRow,"jbill_gu",'N') 
			Return -1
		END IF
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		lLinNo = lLinNo + 1
		dTAmount = dTAmount + dAmount
		
	END IF
NEXT

IF lLinNo > 1 THEN
	
	sDcGbn = '2'											/*대변 전표*/
	
	iCurRow = dw_junpoy.InsertRow(0)

	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)
	dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
	dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	
	dw_junpoy.SetItem(iCurRow,"amt",     dTAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   '만기결제')
	
	dw_junpoy.SetItem(iCurRow,"sdept_cd","")
	dw_junpoy.SetItem(iCurRow,"saup_no", sDpNo)
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_ip.GetItemString(1,"name")+'['+sDepotNo+']')
		
	dw_junpoy.SetItem(iCurRow,"kwan_no", sDepotNo)
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
	
END IF

IF dw_jbill.Update() <> 1 THEN
	F_MessageChk(13,'[지급어음]')
	SetPointer(Arrow!)	
	RETURN -1
END IF

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return -1
END IF

MessageBox("확 인","발생된 미결전표번호 :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunNo,'0000'))

w_mdi_frame.sle_msg.text ="지급어음 만기결제 전표 처리 완료!!"

Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"mbal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"mupmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"mjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1
		
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		END IF

		DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
		DELETE FROM "KFZ12OT3"  										/*전표송부내역 삭제*/
			WHERE ( "KFZ12OT3"."SAUPJ"    = :sSaupj ) AND  
					( "KFZ12OT3"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT3"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT3"."JUN_NO"   = :lJunNo )   ;
					
		UPDATE "KFM01OT0"  
			SET "STATUS" = '1',   
				 "MBAL_DATE" = :snull,   
				 "MUPMU_GU" = :snull,   
				 "MJUN_NO" = :lnull,
				 "MLIN_NO" = :lnull
			WHERE "KFM01OT0"."MBAL_DATE" = :sBalDate AND
					"KFM01OT0"."MUPMU_GU"  = :sUpmuGu AND
					"KFM01OT0"."MJUN_NO"  = :lJunNo ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[지급어음]')
			ROLLBACK;
			SetPointer(Arrow!)
			RETURN -1
		END IF
		
	END IF
NEXT

SetPointer(Arrow!)
Return 1

end function

on w_kglb13.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_jbill=create dw_jbill
this.cbx_all=create cbx_all
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_jbill
this.Control[iCurrent+9]=this.cbx_all
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.dw_rtv
this.Control[iCurrent+12]=this.dw_delete
end on

on w_kglb13.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_jbill)
destroy(this.cbx_all)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"ls_saupj",gs_saupj)

dw_ip.SetItem(dw_ip.Getrow(),"bbal_dat",Left(f_today(),6) + "01")
dw_ip.SetItem(dw_ip.Getrow(),"bman_dat",f_today())

dw_ip.SetItem(dw_ip.Getrow(),"bal_date",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)

dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_jbill.SetTransObject(SQLCA)

cb_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '07' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("bbal_dat")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kglb13
boolean visible = false
integer x = 320
integer y = 2516
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglb13
boolean visible = false
integer x = 3694
integer y = 2736
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglb13
boolean visible = false
integer x = 3520
integer y = 2736
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglb13
boolean visible = false
integer x = 2825
integer y = 2736
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglb13
boolean visible = false
integer x = 3346
integer y = 2736
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglb13
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kglb13
boolean visible = false
integer x = 4215
integer y = 2736
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kglb13
boolean visible = false
integer x = 2999
integer y = 2736
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn
Long   lBJunNo,iRtnVal,lJunNo

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

sSaupj   = dw_junpoy.GetItemString(1,"saupj")
sBalDate = dw_junpoy.GetItemString(1,"bal_date") 
sUpmuGu  = dw_junpoy.GetItemString(1,"upmu_gu") 
lBJunNo  = dw_junpoy.GetItemNumber(1,"bjun_no") 

select distinct jun_no into :lJunNo	from kfz10ot0 
	where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGu and bjun_no = :lBJunNo;
if sqlca.sqlcode = 0 then

	iRtnVal = F_Call_JunpoyPrint(dw_print,'Y',sJunGbn,sSaupj,sBalDate,sUpmuGu,lJunNo,sPrtGbn,'P')
else
	iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
end if
		
IF iRtnVal = -1 THEN
	F_MessageChk(14,'')
	Return -1
ELSEIF iRtnVal = -2 THEN
	Return 1
ELSE	
	sPrtGbn = '1'
END IF
end event

type p_inq from w_inherite`p_inq within w_kglb13
integer x = 4096
end type

event p_inq::clicked;call super::clicked;String sdate,edate,ssaupj,sman_date,sbnk_cd,sbnk_cd_temp,sBillGbn
Int ll_junno,k
Double ldb_amt

sle_msg.text = ''

dw_ip.AcceptText()
sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"ls_saupj")
sdate   = dw_ip.GetItemString(dw_ip.GetRow(),"bbal_dat")
edate   = dw_ip.GetItemString(dw_ip.GetRow(),"bman_dat")
sbnk_cd = dw_ip.GetItemString(dw_ip.GetRow(),"bnk_cd")
sBillGbn = dw_ip.GetItemString(dw_ip.GetRow(),"bill_gu")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("ls_saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF rb_1.Checked =True THEN
	IF sdate = "" OR IsNull(sdate) THEN
		F_MessageChk(1,'[만기일자]')	
		dw_ip.SetColumn("bbal_dat")
		dw_ip.SetFocus()
		Return 
	END IF
	IF edate = "" OR IsNull(edate) THEN
		F_MessageChk(1,'[만기일자]')	
		dw_ip.SetColumn("bman_dat")
		dw_ip.SetFocus()
		Return 
	END IF
	IF IsNull(sbnk_cd) THEN 
		sbnk_cd = ""
	END IF
	
	sbnk_cd_temp = sbnk_cd + '%'
	
	IF dw_rtv.Retrieve(sSaupj,sdate,edate,sbnk_cd_temp,sBillGbn) <= 0 THEN
		F_MessageChk(14,'')
		p_mod.Enabled =False
		Return
	END IF
ELSE
	dw_delete.Reset()
	dw_delete.SetRedraw(False)

	IF dw_delete.Retrieve(sSaupj,sdate,edate,sBillGbn) <= 0 THEN
		F_MessageChk(14,'')
		p_mod.Enabled =False
		Return
	END IF
	dw_delete.SetRedraw(True)
END IF

p_mod.Enabled =True

dw_ip.SetItem(dw_ip.GetRow(),"chose",'2')
end event

type p_del from w_inherite`p_del within w_kglb13
boolean visible = false
integer x = 4041
integer y = 2736
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglb13
integer x = 4270
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sSaupj,sBalDate,sDpNo

IF rb_1.Checked =True THEN
	dw_ip.AcceptText()
	sSaupj     = dw_ip.GetItemString(dw_ip.GetRow(),"ls_saupj")
	sBalDate   = dw_ip.GetItemString(dw_ip.GetRow(),"bal_date")
	sDpNo      = dw_ip.GetItemString(dw_ip.Getrow(),"bnk_no")
	
	IF sSaupj ="" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_ip.SetColumn("ls_saupj")
		dw_ip.SetFocus()
		Return
	END IF
	IF sBalDate ="" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[발행일자]')
		dw_ip.SetColumn("bal_date")
		dw_ip.SetFocus()
		Return
	END IF
	IF sDpNo ="" OR IsNull(sDpNo) THEN
		F_MessageChk(1,'[출금계좌코드]')
		dw_ip.SetColumn("bnk_no")
		dw_ip.SetFocus()
		Return
	END IF
	
	IF dw_rtv.RowCount() <=0 THEN Return
	
	IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate,sDpNo) = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
		
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
				Return -1
			END IF	
		END IF
	END IF
	
	p_print.TriggerEvent(Clicked!)
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

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kglb13
integer x = 2258
integer y = 2768
end type

type cb_mod from w_inherite`cb_mod within w_kglb13
integer x = 1911
integer y = 2768
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kglb13
integer x = 2235
integer y = 2776
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kglb13
integer x = 2089
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kglb13
integer x = 1550
integer y = 2768
end type

type cb_print from w_inherite`cb_print within w_kglb13
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kglb13
end type

type cb_can from w_inherite`cb_can within w_kglb13
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kglb13
integer x = 3122
integer y = 2580
integer width = 334
string text = "변경(&E)"
end type

event cb_search::clicked;call super::clicked;//OPEN(W_KIFA05A)
end event







type gb_button1 from w_inherite`gb_button1 within w_kglb13
integer x = 2066
integer y = 2692
end type

type gb_button2 from w_inherite`gb_button2 within w_kglb13
integer x = 1495
integer y = 2712
integer width = 1138
end type

type gb_1 from groupbox within w_kglb13
integer x = 3461
integer y = 20
integer width = 498
integer height = 244
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
end type

type rb_1 from radiobutton within w_kglb13
integer x = 3502
integer y = 76
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행처리"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="지급어음 만기결제 자동전표 발행"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("bbal_dat")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kglb13
integer x = 3502
integer y = 164
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제처리"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="지급어음 만기결제 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("bbal_dat")
dw_ip.SetFocus()


end event

type dw_ip from u_key_enter within w_kglb13
event ue_key pbm_dwnkey
integer x = 37
integer y = 16
integer width = 3410
integer height = 272
integer taborder = 20
string dataobject = "dw_kglb131"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,ssqlb,sSaupj,sDate,sBnkNo,sChoose,sSdeptCode,sBnkCd
Integer i

SetNull(snull)

IF this.GetColumnName() ="bbal_dat" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"만기일자")
		dw_ip.SetItem(1,"bbal_dat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bman_dat" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"만기일자")
		dw_ip.SetItem(1,"bman_dat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ls_saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"ls_saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="bal_date" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"발행일자")
		dw_ip.SetItem(1,"bal_date",snull)
		Return 1
	END IF
	IF F_Check_LimitDate(sDate,'B') = -1 THEN
		F_MessageChk(29,'[발행일자]')
		dw_ip.SetItem(1,"bal_date",snull)
		dw_ip.SetColumn("bal_date")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bnk_no" THEN
	sBnkNo = this.GetText()
	IF sBnkNo = "" OR IsNull(sBnkNo) THEN 
		dw_ip.SetItem(1,"name",snull)
		Return
	END IF
	
	SELECT "KFM04OT0"."AB_NAME"  INTO :ssql  
    	FROM "KFM04OT0"  
   	WHERE "KFM04OT0"."AB_DPNO" = :sBnkNo   ;
	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"출금계좌코드")
//		dw_ip.SetItem(1,"bnk_no",snull)
//		dw_ip.SetItem(1,"name",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(1,"name",ssql)
	END IF
END IF

IF this.GetColumnName() ="bnk_cd" THEN
	sBnkCd = this.GetText()
	IF sBnkCd = "" OR IsNull(sBnkCd) THEN 
		dw_ip.SetItem(1,"bnk_name",snull)
		Return
	END IF
	
	SELECT "KFZ04OM0_V2"."PERSON_NM"  INTO :ssqlb
    	FROM "KFZ04OM0_V2"  
   	WHERE "KFZ04OM0_V2"."PERSON_CD" = :sBnkCd   ;
	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"지급은행")
//		dw_ip.SetItem(1,"bnk_cd",snull)
//		dw_ip.SetItem(1,"bnk_name",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(1,"bnk_name",ssqlb)
	END IF
END IF

IF this.GetColumnName() ="chose" THEN
	sChoose = this.GetText()
	
	IF rb_1.Checked =True THEN
		IF sChoose ='1' THEN
			FOR i =1 TO dw_rtv.Rowcount()
				dw_rtv.SetItem(i,"chk",'1')
			NEXT
		ELSEIF sChoose ='2' THEN
			FOR i =1 TO dw_rtv.Rowcount()
				dw_rtv.SetItem(i,"chk",'0')
			NEXT
		END IF
	ELSEIF rb_2.Checked =True THEN
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

this.accepttext()

IF this.GetColumnName() ="bnk_no" THEN
	lstr_custom.code = this.getitemstring(this.getrow(), "bnk_no") 
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

IF this.GetColumnName() ="bnk_cd" THEN
	lstr_custom.code = this.getitemstring(this.getrow(), "bnk_cd")
	
	OpenWithParm(W_Kfz04om0_POPUP,'2')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_cd",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_junpoy from datawindow within w_kglb13
boolean visible = false
integer x = 242
integer y = 2756
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dberror;MessageBox('error',sqlerrtext)
end event

type dw_sungin from datawindow within w_kglb13
boolean visible = false
integer x = 242
integer y = 2864
integer width = 1029
integer height = 100
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

type dw_print from datawindow within w_kglb13
boolean visible = false
integer x = 242
integer y = 2968
integer width = 1029
integer height = 100
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

type dw_jbill from datawindow within w_kglb13
boolean visible = false
integer x = 242
integer y = 3116
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "지급어음 결제 저장"
string dataobject = "dw_kglb01c1_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type cbx_all from checkbox within w_kglb13
integer x = 4110
integer y = 200
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체 선택"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '자료 선택 중...'
if cbx_all.Checked = True then
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'1')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'1')
		NEXT
	END IF
else
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'0')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'0')
		NEXT
	END IF	
end if
w_mdi_frame.sle_msg.text = ''
end event

type rr_1 from roundrectangle within w_kglb13
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 288
integer width = 4571
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kglb13
integer x = 55
integer y = 296
integer width = 4544
integer height = 1956
integer taborder = 30
string dataobject = "dw_kglb132"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;
IF dwo.name ="chk" THEN
	IF data ='1' THEN
		dw_rtv.SetItem(dw_rtv.GetRow(),"chose_amt",GetItemNumber(dw_rtv.GetRow(),"bill_amt"))
	ELSEIF data ='0' THEN
		dw_rtv.SetItem(dw_rtv.GetRow(),"chose_amt",0)
	END IF
END IF
end event

type dw_delete from datawindow within w_kglb13
integer x = 55
integer y = 296
integer width = 4544
integer height = 1944
integer taborder = 40
string dataobject = "dw_kglb133"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

