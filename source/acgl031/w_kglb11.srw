$PBExportHeader$w_kglb11.srw
$PBExportComments$받을어음 만기결제전표 처리(차변합)
forward
global type w_kglb11 from w_inherite
end type
type gb_1 from groupbox within w_kglb11
end type
type rb_1 from radiobutton within w_kglb11
end type
type rb_2 from radiobutton within w_kglb11
end type
type dw_ip from u_key_enter within w_kglb11
end type
type dw_junpoy from datawindow within w_kglb11
end type
type dw_sungin from datawindow within w_kglb11
end type
type dw_print from datawindow within w_kglb11
end type
type dw_rbill from datawindow within w_kglb11
end type
type rr_1 from roundrectangle within w_kglb11
end type
type cbx_all from checkbox within w_kglb11
end type
type dw_rtv from datawindow within w_kglb11
end type
type dw_delete from datawindow within w_kglb11
end type
end forward

global type w_kglb11 from w_inherite
string title = "받을어음 만기결제전표 처리(차변합)"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_rbill dw_rbill
rr_1 rr_1
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kglb11 w_kglb11

type variables

String sUpmuGbn = 'G',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdpno)
end prototypes

public function integer wf_insert_kfz12otd (integer irow, string ssaupj, string sbaldate, long ljunno, integer llinno);Integer iFindRow,iCurRow
String  sFullJunNo

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+&
					       String(lJunNo,'0000')+String(lLinNo,'000')

iFindRow = dw_rbill.InsertRow(0)
	
dw_rbill.SetItem(iFindRow,"saupj",			sSaupj)
dw_rbill.SetItem(iFindRow,"bal_date",		sBalDate)
dw_rbill.SetItem(iFindRow,"upmu_gu",		sUpmuGbn)
dw_rbill.SetItem(iFindRow,"bjun_no",		lJunNo)
dw_rbill.SetItem(iFindRow,"lin_no",			lLinNo)
dw_rbill.SetItem(iFindRow,"full_junno",	sFullJunNo)

dw_rbill.SetItem(iFindRow,"mbal_date",		sBalDate)
dw_rbill.SetItem(iFindRow,"mupmu_gu",		sUpmuGbn)
dw_rbill.SetItem(iFindRow,"mjun_no",		lJunNo)
dw_rbill.SetItem(iFindRow,"mlin_no",		lLinNo)
	
dw_rbill.SetItem(iFindRow,"bill_no",		dw_rtv.GetItemString(iRow,"bill_no"))
dw_rbill.SetItem(iFindRow,"saup_no",		dw_rtv.GetItemString(iRow,"saup_no"))
dw_rbill.SetItem(iFindRow,"bnk_cd",			dw_rtv.GetItemString(iRow,"bnk_cd"))
dw_rbill.SetItem(iFindRow,"bbal_dat",		dw_rtv.GetItemString(iRow,"bbal_dat"))
dw_rbill.SetItem(iFindRow,"bman_dat",		dw_rtv.GetItemString(iRow,"bman_dat"))
dw_rbill.SetItem(iFindRow,"bill_amt",		dw_rtv.GetItemNumber(iRow,"jan_amt"))
dw_rbill.SetItem(iFindRow,"bill_nm",		dw_rtv.GetItemString(iRow,"bill_nm"))
dw_rbill.SetItem(iFindRow,"bill_ris",		dw_rtv.GetItemString(iRow,"bill_ris"))
dw_rbill.SetItem(iFindRow,"bill_gu",		dw_rtv.GetItemString(iRow,"bill_gu"))
dw_rbill.SetItem(iFindRow,"bill_jigu",		dw_rtv.GetItemString(iRow,"bill_jigu"))
dw_rbill.SetItem(iFindRow,"chu_ymd",		dw_rtv.GetItemString(iRow,"chu_ymd"))
dw_rbill.SetItem(iFindRow,"chu_bnk",		dw_rtv.GetItemString(iRow,"chu_bnk"))
dw_rbill.SetItem(iFindRow,"remark1",		dw_rtv.GetItemString(iRow,"remark1"))
dw_rbill.SetItem(iFindRow,"status",			'2')

dw_rbill.SetItem(iFindRow,"owner_saupj",	sSaupj)

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
		
		/*받을어음 전표 발행 취소*/
		DECLARE cursor_bill CURSOR FOR  
  			SELECT "KFM02OT0"."BILL_NO",   
      	   	 "KFM02OT0"."CHU_YMD"  
	    	FROM "KFM02OT0"  
   		WHERE ( "KFM02OT0"."MBAL_DATE" = :sBalDate ) AND  
      	   	( "KFM02OT0"."MUPMU_GU"  = :sUpmuGu ) AND  
         		( "KFM02OT0"."MJUN_NO"   = :lJunNo )   ;
		OPEN cursor_bill;
	
		DO WHILE true
			FETCH cursor_bill INTO :sBill,:sChuYmd;
			
			IF SQLCA.SQLCODE <> 0 THEN EXIT
			
			IF sChuYmd ="" OR IsNull(sChuYmd) THEN
				sStatus ='1'
			ELSE
				sStatus ='3'
			END IF
					
			UPDATE "KFM02OT0"  
				SET "STATUS" = :sStatus,   
					 "MBAL_DATE" = :snull,   
					 "MUPMU_GU" = :snull,   
					 "MJUN_NO" = :lnull,
					 "MLIN_NO" = :lnull
				WHERE "KFM02OT0"."BILL_NO" = :sBill   ;
			IF SQLCA.SQLCODE <> 0 THEN
				F_MessageChk(12,'[받을어음]')
				ROLLBACK;
				SetPointer(Arrow!)
				RETURN -1
			END IF
		LOOP
		CLOSE cursor_bill;
	
	END IF
NEXT

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdpno);/************************************************************************************/
/* 만기결제 받을어음을 자동으로 전표 처리한다.													*/
/* 1. 차변 : 입금계좌코드의 계정과목으로 발생													*/
/* 2. 대변 : 받을어음계정으로 발생																	*/
/************************************************************************************/
String  sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sSaupNo,sDcGbn,sDepotNo,sBillNo,sStatus,sBbalDate
Integer k,lLinNo,lJunNo,iCurRow
Double  dAmount,dTAmount

dw_junpoy.Reset()
dw_rbill.Reset()
dw_sungin.Reset()

w_mdi_frame.sle_msg.text =""

SELECT "KFM04OT0"."ACC1_CD", "KFM04OT0"."ACC2_CD","KFM04OT0"."AB_NO"		/*차변계정*/
	INTO :sAcc1_Cha,   		  :sAcc2_Cha,			  :sDepotNo
   FROM "KFM04OT0"  
   WHERE "KFM04OT0"."AB_DPNO" = :sDpNo   ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","입력하신 계좌코드에 계정과목이 없습니다.!!")
	RETURN -1
END IF

SELECT SUBSTR("DATANAME",1,5), 	SUBSTR("DATANAME",6,2)						/*받을어음*/
	INTO :sAcc1_Dae,  				:sAcc2_Dae	
   FROM "SYSCNFG"  
   WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 1 ) AND  ( "LINENO" = '23' )  ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[받을어음 계정]')
	Return -1
END IF

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

dTAmount = 0

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN
		dTAmount = dTAmount + dw_rtv.GetItemNumber(k,"jan_amt")
	END IF
NEXT

IF dTAmount > 0 THEN
	
	w_mdi_frame.sle_msg.text ="받을어음 만기결제 자동전표 처리 중 ..."

	/*전표번호 채번*/
	lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
	lLinNo = 1
	
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
	
	dw_junpoy.SetItem(iCurRow,"amt",     dTAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   '받을어음 만기결제')
	
	dw_junpoy.SetItem(iCurRow,"sdept_cd","")
	dw_junpoy.SetItem(iCurRow,"saup_no", sDpNo) 
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_ip.GetItemString(1,"name")+'['+sDepotNo+']') 
		
	dw_junpoy.SetItem(iCurRow,"kwan_no", sDepotNo) 	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today())

	FOR k = 1 TO dw_rtv.RowCount()
		IF dw_rtv.GetItemString(k,"chk") = '1' THEN
			sBillNo = dw_rtv.GetItemString(k,"bill_no")
			sStatus = dw_rtv.GetItemString(k,"status")
			sBbalDate = dw_rtv.GetItemString(k,"bman_dat")
			
			sSaupNo = dw_rtv.GetItemString(k,"saup_no")
			dAmount = dw_rtv.GetItemNumber(k,"jan_amt")
			
			sDcGbn = '2'											/*대변 전표*/
			lLinNo = lLinNo + 1
			
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
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   '받을어음 만기결제')
			
			dw_junpoy.SetItem(iCurRow,"sdept_cd","")
			dw_junpoy.SetItem(iCurRow,"saup_no", sSaupNo) 
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kfz04om0_person_nm")) 
				
			IF Wf_Insert_Kfz12otd(k,sSaupj,sBalDate,lJunNo,lLinNo) = 1 THEN
				dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y') 
				dw_junpoy.SetItem(iCurRow,"kwan_no", sBillNo) 
				dw_junpoy.SetItem(iCurRow,"k_eymd",  sBbalDate) 
			ELSE
				dw_junpoy.SetItem(iCurRow,"rbill_gu",'N') 
				Return -1
			END IF
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
		END IF
	NEXT
	
	IF dw_rbill.Update() <> 1 THEN
		F_MessageChk(13,'[받을어음]')
		SetPointer(Arrow!)	
		RETURN -1
	END IF
	
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		SetPointer(Arrow!)
		Return -1
	END IF
	
	//MessageBox("확 인","발생된 미결전표번호 :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunNo,'0000'))
	
	w_mdi_frame.sle_msg.text ="받을어음 만기결제 전표 처리 완료!!"
	Return 1
	
ELSE
	
	w_mdi_frame.sle_msg.text ="처리할 자료가 없습니다"
	Return -1
	
END IF
end function

on w_kglb11.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_rbill=create dw_rbill
this.rr_1=create rr_1
this.cbx_all=create cbx_all
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
this.Control[iCurrent+8]=this.dw_rbill
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.cbx_all
this.Control[iCurrent+11]=this.dw_rtv
this.Control[iCurrent+12]=this.dw_delete
end on

on w_kglb11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_rbill)
destroy(this.rr_1)
destroy(this.cbx_all)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"ls_saupj",gs_saupj)

dw_ip.SetItem(dw_ip.Getrow(),"bbal_dat",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"bman_dat",f_today())

dw_ip.SetItem(dw_ip.Getrow(),"bal_date",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

dw_rbill.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '06' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("bbal_dat")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kglb11
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglb11
boolean visible = false
integer x = 3703
integer y = 2608
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglb11
boolean visible = false
integer x = 3529
integer y = 2608
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglb11
boolean visible = false
integer x = 3003
integer y = 2608
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglb11
boolean visible = false
integer x = 3355
integer y = 2608
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglb11
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kglb11
boolean visible = false
integer x = 4055
integer y = 2608
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kglb11
boolean visible = false
integer x = 3177
integer y = 2608
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
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

type p_inq from w_inherite`p_inq within w_kglb11
integer x = 4096
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sdate,edate,ssaupj,sman_date,sStatus,sStatus1,sStatus2,sStatus3,sStatus4
Int ll_junno,k
Double ldb_amt

w_mdi_frame.sle_msg.text = ''

dw_ip.AcceptText()
sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"ls_saupj")
sdate   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"bbal_dat"))
edate   = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"bman_dat"))
sStatus1 = dw_ip.GetItemString(dw_ip.GetRow(),"status")

IF rb_1.Checked =True THEN
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("ls_saupj")
		dw_ip.SetFocus()
		Return 
	END IF
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
	IF sStatus1 = "" OR IsNull(sStatus1) THEN
		F_MessageChk(1,'[어음상태]')	
		dw_ip.SetColumn("status")
		dw_ip.SetFocus()
		Return 
	ELSE
		IF sStatus1 = '9' THEN
			sStatus1 = '1';	sStatus2 = '3';	sStatus3 = '4';	sStatus4 = '8';
		ELSE
			sStatus2 = sStatus1;		sStatus3 = sStatus1;		sStatus4 = sStatus1;
		END IF
	END IF

	IF dw_rtv.Retrieve(sSaupj,sdate,edate,sStatus1,sStatus2,sStatus3,sStatus4) <= 0 THEN
		F_MessageChk(14,'')
		p_mod.Enabled =False
		Return
	END IF
ELSE
	dw_delete.Reset()
	dw_delete.SetRedraw(False)
	
	IF dw_delete.Retrieve(sSaupj,sdate,edate) <= 0 THEN
		F_MessageChk(14,'')
		p_mod.Enabled =False
		Return
	END IF
	dw_delete.SetRedraw(True)
END IF

p_mod.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kglb11
boolean visible = false
integer x = 3881
integer y = 2608
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglb11
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
		F_MessageChk(1,'[입금계좌코드]')
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
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
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

type cb_exit from w_inherite`cb_exit within w_kglb11
boolean visible = false
integer x = 3360
integer y = 2828
end type

type cb_mod from w_inherite`cb_mod within w_kglb11
boolean visible = false
integer x = 3013
integer y = 2824
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kglb11
boolean visible = false
integer x = 2437
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kglb11
boolean visible = false
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kglb11
boolean visible = false
integer x = 2651
integer y = 2824
end type

type cb_print from w_inherite`cb_print within w_kglb11
boolean visible = false
integer x = 1728
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kglb11
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglb11
boolean visible = false
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kglb11
boolean visible = false
integer x = 3141
integer y = 2580
integer width = 334
string text = "변경(&E)"
end type

event cb_search::clicked;call super::clicked;//OPEN(W_KIFA05A)
end event

type dw_datetime from w_inherite`dw_datetime within w_kglb11
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglb11
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglb11
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglb11
boolean visible = false
integer x = 1687
integer y = 2524
end type

type gb_button2 from w_inherite`gb_button2 within w_kglb11
boolean visible = false
integer x = 2597
integer y = 2768
integer width = 1138
end type

type gb_1 from groupbox within w_kglb11
integer x = 3383
integer y = 16
integer width = 503
integer height = 272
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

type rb_1 from radiobutton within w_kglb11
integer x = 3424
integer y = 88
integer width = 425
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
	dw_rtv.Title ="받을어음 만기결제 자동전표 발행"
	

	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("bbal_dat")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kglb11
integer x = 3424
integer y = 176
integer width = 425
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
	dw_delete.Title ="받을어음 만기결제 자동전표 삭제"
	
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("bbal_dat")
dw_ip.SetFocus()


end event

type dw_ip from u_key_enter within w_kglb11
event ue_key pbm_dwnkey
integer x = 32
integer y = 20
integer width = 3323
integer height = 280
integer taborder = 10
string dataobject = "dw_kglb111"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose
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
//		f_messagechk(20,"입금계좌코드")
//		dw_ip.SetItem(1,"bnk_no",snull)
//		dw_ip.SetItem(1,"name",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(1,"name",ssql)
	END IF
END IF

//IF this.GetColumnName() ="chose" THEN
//	sChoose = this.GetText()
//	
//	IF rb_1.Checked =True THEN
//		IF sChoose ='1' THEN
//			FOR i =1 TO dw_rtv.Rowcount()
//				dw_rtv.SetItem(i,"chk",'1')
//			NEXT
//		ELSEIF sChoose ='2' THEN
//			FOR i =1 TO dw_rtv.Rowcount()
//				dw_rtv.SetItem(i,"chk",'0')
//			NEXT
//		END IF
//	ELSEIF rb_2.Checked =True THEN
//		IF sChoose ='1' THEN
//			FOR i =1 TO dw_delete.Rowcount()
//				dw_delete.SetItem(i,"chk",'1')
//			NEXT
//		ELSEIF sChoose ='2' THEN
//			FOR i =1 TO dw_delete.Rowcount()
//				dw_delete.SetItem(i,"chk",'0')
//			NEXT
//		END IF
//	END IF
//END IF
//
end event

event rbuttondown;this.accepttext()

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_no" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "bnk_no")
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_junpoy from datawindow within w_kglb11
boolean visible = false
integer x = 128
integer y = 2348
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

type dw_sungin from datawindow within w_kglb11
boolean visible = false
integer x = 128
integer y = 2448
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

type dw_print from datawindow within w_kglb11
boolean visible = false
integer x = 128
integer y = 2548
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

type dw_rbill from datawindow within w_kglb11
boolean visible = false
integer x = 123
integer y = 2648
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "받을어음 결제 저장"
string dataobject = "dw_kglb01d1_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kglb11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 300
integer width = 4571
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_all from checkbox within w_kglb11
integer x = 4110
integer y = 220
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

type dw_rtv from datawindow within w_kglb11
integer x = 59
integer y = 312
integer width = 4544
integer height = 1896
integer taborder = 30
string dataobject = "dw_kglb112"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_delete from datawindow within w_kglb11
integer x = 59
integer y = 312
integer width = 4544
integer height = 1896
integer taborder = 40
string dataobject = "dw_kglb113"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

