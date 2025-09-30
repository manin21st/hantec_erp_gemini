$PBExportHeader$w_kglc24.srw
$PBExportComments$월할선급비용 대체전표 처리
forward
global type w_kglc24 from w_inherite
end type
type gb_1 from groupbox within w_kglc24
end type
type rb_1 from radiobutton within w_kglc24
end type
type rb_2 from radiobutton within w_kglc24
end type
type dw_ip from u_key_enter within w_kglc24
end type
type dw_junpoy from datawindow within w_kglc24
end type
type dw_sungin from datawindow within w_kglc24
end type
type dw_proclst from datawindow within w_kglc24
end type
type dw_print from datawindow within w_kglc24
end type
type rr_1 from roundrectangle within w_kglc24
end type
type dw_rtv from datawindow within w_kglc24
end type
type dw_delete from datawindow within w_kglc24
end type
end forward

global type w_kglc24 from w_inherite
string title = "월할선급비용 대체전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_proclst dw_proclst
dw_print dw_print
rr_1 rr_1
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kglc24 w_kglc24

type variables

String sUpmuGbn = 'A',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_sang (string sacc1, string sacc2, string saupno, double damount, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, boolean ssangchk)
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate)
end prototypes

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"choose") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj_s")
		sBalDate = dw_delete.GetItemString(k,"bal_date_s")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu_s")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no_s")
		
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
		
		UPDATE "KFZ31OT1"  
     		SET "SAUPJ_S" = null,   
         	 "BAL_DATE_S" = null,   
         	 "UPMU_GU_S" = null,   
         	 "BJUN_NO_S" = null,   
         	 "LIN_NO_S" = null,   
		       "BAL_GU" = 'N'  
			WHERE ( "KFZ31OT1"."SAUPJ_S"    = :sSaupj  ) AND  
         		( "KFZ31OT1"."BAL_DATE_S" = :sBalDate ) AND  
		         ( "KFZ31OT1"."UPMU_GU_S"  = :sUpmuGu ) AND  
      		   ( "KFZ31OT1"."BJUN_NO_S"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[월할선급비용]')
			ROLLBACK;
			SetPointer(Arrow!)
			RETURN -1
		END IF
	
	END IF
NEXT

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_sang (string sacc1, string sacc2, string saupno, double damount, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, boolean ssangchk);
Integer iCount,iInsertRow,k
Double  dRemainAmt,dCurAmt,dTempAmt

//iCount = dw_sanglst.Retrieve(saupno,sAcc1,sAcc2)
//IF iCount <=0 THEN 
//	F_MessageChk(14,'[반제 대상 자료]')
//	Return -1
//END IF

IF sSangChk = True THEN Return 1

/*반제 처리 화면 띄워서 처리 (99.10.13 수정)*/
lstr_jpra.saupjang = ssaupj
lstr_jpra.baldate  = sbaldate
lstr_jpra.upmugu   = supmugu
lstr_jpra.bjunno   = ljunno
lstr_jpra.sortno   = llinno
lstr_jpra.saupno   = saupno
lstr_jpra.acc1     = sacc1
lstr_jpra.acc2     = sacc2
lstr_jpra.money    = damount
				
OpenWithParm(W_kglb01g,'')
IF Message.StringParm = '0' THEN		/*반제처리 안함*/
	F_MessageChk(17,'[반제 처리]')
	Return -1
END IF			

Return 1
end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate);/************************************************************************************/
/* 월할선급비요 자료를 자동으로 전표 처리한다.													*/
/* 1. 차변 : 처리하는 자료의 계정과목에 대하여 계정과목마스타의 관련계정으로 발생	*/
/* 2. 대변 : 처리하는 자료의 계정과목으로 발생													*/
/************************************************************************************/

String  sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sYesanGbn,sChaDae,sGbn1,sSangGbn
Integer k,lLinNo,lJunNo,iCurRow

dw_junpoy.Reset()
dw_sungin.Reset()

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="월할선급비용 자동전표 처리 중 ..."

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1

FOR k = 1 TO dw_rtv.RowCount()
	sAcc1_Dae = dw_rtv.GetItemString(k,"kfz31ot1_acc1_cd")				/*대변*/
	sAcc2_Dae = dw_rtv.GetItemString(k,"kfz31ot1_acc2_cd")
	
	sAcc1_Cha = dw_rtv.GetItemString(k,"kfz01om0_cacc1_cd")				/*차변*/
	sAcc2_Cha = dw_rtv.GetItemString(k,"kfz01om0_cacc2_cd")
		
	sDcGbn = '1'											/*차변 전표*/
	
	SELECT "DC_GU",	"YESAN_GU",	"GBN1",	"SANG_GU"
		INTO :sChaDae,:sYesanGbn,	:sGbn1,	:sSangGbn
	   FROM "KFZ01OM0"  
	   WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cha ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cha) ;
						
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
			
	dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(k,"kfz31ot1_div_amt"))
	dw_junpoy.SetItem(iCurRow,"descr",   '월할선급비용 자동전표')
			
	dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"kfz31ot0_cdept_cd"))
	
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kfz31ot0_saup_no")) 
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kfz10ot0_in_nm")) 
	
	IF sSangGbn = 'Y' and sDcGbn <> sChaDae THEN
		IF Wf_Insert_Sang(sAcc1_Cha,sAcc2_Cha,dw_rtv.GetItemString(k,"kfz31ot0_saup_no"),&
			dw_rtv.GetItemNumber(k,"kfz31ot1_div_amt"),sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo, False) > 0 THEN																		
			dw_junpoy.SetItem(iCurRow,"cross_gu",'Y') 
		ELSE
			Return -1
		END IF					
	ELSE
		dw_junpoy.SetItem(iCurRow,"cross_gu",'N') 
	END IF
				
	dw_junpoy.SetItem(iCurRow,"k_symd",  dw_rtv.GetItemString(k,"kfz31ot1_k_symd")) 
	dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_rtv.GetItemString(k,"kfz31ot1_k_eymd")) 
	dw_junpoy.SetItem(iCurRow,"k_amt",   dw_rtv.GetItemNumber(k,"kfz10ot0_k_amt")) 
	dw_junpoy.SetItem(iCurRow,"k_rate",  dw_rtv.GetItemNumber(k,"kfz10ot0_k_rate")) 
	
	IF sGbn1 = '6' THEN								/*차입금=>이자비용일 경우 '대체'로 본다. 2001.03.06*/
		dw_junpoy.SetItem(iCurRow,"exp_gu",  '2') 
	END IF
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
	END IF
	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today())
	lLinNo = lLinNo + 1
	
	sDcGbn = '2'											/*대변 전표*/
	
	SELECT "KFZ01OM0"."DC_GU","KFZ01OM0"."YESAN_GU"      INTO :sChaDae,:sYesanGbn	/*예산통제*/
	   FROM "KFZ01OM0"  
	   WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Dae ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Dae) ;
	
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
			
	dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(k,"kfz31ot1_div_amt"))
	dw_junpoy.SetItem(iCurRow,"descr",   dw_rtv.GetItemString(k,"kfz31ot0_descr"))
			
	dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_rtv.GetItemString(k,"kfz31ot0_cdept_cd"))
	dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"kfz31ot0_saup_no")) 
	dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"kfz10ot0_in_nm")) 
	dw_junpoy.SetItem(iCurRow,"k_symd",  dw_rtv.GetItemString(k,"kfz31ot0_k_symd")) 
	dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_rtv.GetItemString(k,"kfz31ot0_k_eymd")) 
	
	IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
	END IF
	
//	dw_junpoy.SetItem(iCurRow,"kwan_no", sDepotNo) 	
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 

	dw_rtv.SetItem(k,"kfz31ot1_saupj_s",   sSaupj)
	dw_rtv.SetItem(k,"kfz31ot1_bal_date_s",sBalDate)
	dw_rtv.SetItem(k,"kfz31ot1_upmu_gu_s", sUpmuGbn)
	dw_rtv.SetItem(k,"kfz31ot1_bjun_no_s", lJunNo)
	dw_rtv.SetItem(k,"kfz31ot1_lin_no_s",  lLinNo)
	dw_rtv.SetItem(k,"kfz31ot1_bal_gu",    'Y')	
	lLinNo = lLinNo + 1
NEXT

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return -1
END IF

IF dw_rtv.Update() <> 1 THEN
	F_MessageChk(13,'[월할선급비용]')
	SetPointer(Arrow!)	
	RETURN -1
END IF

MessageBox("확 인","발생된 미결전표번호 :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunNo,'0000'))

w_mdi_frame.sle_msg.text ="월할 선급비용 전표 처리 완료!!"

Return 1
end function

on w_kglc24.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_proclst=create dw_proclst
this.dw_print=create dw_print
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
this.Control[iCurrent+7]=this.dw_proclst
this.Control[iCurrent+8]=this.dw_print
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.dw_rtv
this.Control[iCurrent+11]=this.dw_delete
end on

on w_kglc24.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_proclst)
destroy(this.dw_print)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_proclst.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",   Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"basedate",Left(f_today(),6))
dw_ip.SetItem(dw_ip.GetRow(),"accym",   Left(f_today(),6))
dw_ip.SetItem(dw_ip.GetRow(),"accday",  Right(F_Last_Date(Left(f_today(),6)),2))

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '16' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("basedate")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kglc24
boolean visible = false
integer x = 1550
integer y = 2544
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kglc24
boolean visible = false
integer x = 3881
integer y = 2700
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kglc24
boolean visible = false
integer x = 3707
integer y = 2700
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kglc24
boolean visible = false
integer x = 3511
integer y = 2532
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kglc24
boolean visible = false
integer x = 3534
integer y = 2700
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kglc24
integer y = 8
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kglc24
boolean visible = false
integer x = 4229
integer y = 2700
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kglc24
boolean visible = false
integer x = 3698
integer y = 2528
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

type p_inq from w_inherite`p_inq within w_kglc24
integer x = 4096
integer y = 8
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sBaseYm,sAcc1,sAcc2,sAccDay,sSaupj

w_mdi_frame.sle_msg.text = ''

dw_ip.AcceptText()
sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sBaseYm = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"basedate"))
sAcc1   = dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")
sAcc2   = dw_ip.GetItemString(dw_ip.GetRow(),"acc2_cd")
sAccDay = dw_ip.GetItemString(dw_ip.GetRow(),"accday")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.Setcolumn("saupj")
	dw_ip.SetFocus()
	Return
END IF
	
IF rb_1.Checked =True THEN
	
	IF sBaseYm = "" OR IsNull(sBaseYm) THEN
		F_MessageChk(1,'[처리년월]')
		dw_ip.Setcolumn("basedate")
		dw_ip.SetFocus()
		Return
	END IF
	
	IF sAcc1 = "" OR IsNull(sAcc1) THEN sAcc1 = '%'
	IF sAcc2 = "" OR IsNull(sAcc2) THEN sAcc2 = '%'
	
	IF dw_rtv.Retrieve(sSaupj,sBaseYm,sAcc1,sAcc2) <= 0 THEN
		F_MessageChk(14,'')
		p_mod.Enabled =False
		Return
	END IF
ELSE
	IF sBaseYm = "" OR IsNull(sBaseYm) THEN
		F_MessageChk(1,'[처리년월]')
		dw_ip.Setcolumn("basedate")
		dw_ip.SetFocus()
		Return
	END IF
	
	dw_delete.Reset()
	dw_delete.SetRedraw(False)

	IF dw_delete.Retrieve(sSaupj,sBaseYm) <= 0 THEN
		F_MessageChk(14,'')
		p_mod.Enabled =False
		Return
	END IF
	dw_delete.SetRedraw(True)
END IF

p_mod.Enabled =True

end event

type p_del from w_inherite`p_del within w_kglc24
boolean visible = false
integer x = 4055
integer y = 2700
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kglc24
integer x = 4270
integer y = 8
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sBalDate,sAccDay,sSaupj

IF rb_1.Checked =True THEN
	dw_ip.AcceptText()
	sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	sAccDay = dw_ip.GetItemString(dw_ip.GetRow(),"accday")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_ip.Setcolumn("saupj")
		dw_ip.SetFocus()
		Return
	END IF

	IF sAccDay ="" OR IsNull(sAccDay) THEN
		F_MessageChk(1,'[회계일자]')
		dw_ip.SetColumn("accday")
		dw_ip.SetFocus()
		Return
	ELSE
		sBalDate = dw_ip.GetItemString(dw_ip.GetRow(),"accym") + sAccDay 	
	END IF
	
	IF dw_rtv.RowCount() <=0 THEN
		F_MessageChk(11,'')	
		Return
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
				SetPointer(Arrow!)
				Return -1
			END IF	
		END IF
	END IF
	
	p_print.TriggerEvent(Clicked!)
ELSE
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

type cb_exit from w_inherite`cb_exit within w_kglc24
boolean visible = false
integer x = 2743
integer y = 2768
end type

type cb_mod from w_inherite`cb_mod within w_kglc24
boolean visible = false
integer x = 2386
integer y = 2768
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kglc24
boolean visible = false
integer x = 1006
integer y = 2580
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kglc24
boolean visible = false
integer x = 2085
integer y = 2580
end type

type cb_inq from w_inherite`cb_inq within w_kglc24
boolean visible = false
integer x = 2025
integer y = 2768
end type

type cb_print from w_inherite`cb_print within w_kglc24
boolean visible = false
integer x = 2437
integer y = 2580
end type

type st_1 from w_inherite`st_1 within w_kglc24
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kglc24
boolean visible = false
integer x = 2789
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kglc24
boolean visible = false
integer x = 3122
integer y = 2580
integer width = 334
string text = "변경(&E)"
end type

event cb_search::clicked;call super::clicked;//OPEN(W_KIFA05A)
end event

type dw_datetime from w_inherite`dw_datetime within w_kglc24
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kglc24
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kglc24
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kglc24
boolean visible = false
integer x = 1993
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kglc24
boolean visible = false
integer x = 1984
integer y = 2712
integer width = 1134
end type

type gb_1 from groupbox within w_kglc24
integer x = 3543
integer width = 539
integer height = 208
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kglc24
integer x = 3602
integer y = 44
integer width = 430
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
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="월할선급비용 자동전표 발행"

	dw_rtv.Visible =True
	dw_delete.Visible =False
	
	dw_ip.Modify("txt_base.text = '처리년월'")
END IF
dw_rtv.Reset()

dw_ip.SetColumn("basedate")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kglc24
integer x = 3602
integer y = 112
integer width = 430
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
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="월할선급비용 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
	
	dw_ip.Modify("txt_base.text = '기준년월'")
END IF
dw_delete.Reset()

dw_ip.SetColumn("basedate")
dw_ip.SetFocus()


end event

type dw_ip from u_key_enter within w_kglc24
event ue_key pbm_dwnkey
integer x = 64
integer y = 12
integer width = 3456
integer height = 212
integer taborder = 10
string dataobject = "d_kglc241"
boolean border = false
end type

event ue_key;IF key = keyF1! or key = keytab! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sAcc1_cd,sAcc2_cd,sAccName,sYearMonth,sSaupj,sSql,snull
Integer iCurRow

SetNull(snull)

iCurRow = this.GetRow()
IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '9' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[회계단위]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() = "basedate" THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth = "" OR IsNull(sYearMonth) THEN RETURN
	
	IF F_DateChk(sYearMonth+'01') = -1 THEN
		F_MessageChk(21,'[처리년월]')
		this.SetItem(iCurRow,"basedate",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"accym", sYearMonth)
		this.SetItem(iCurRow,"accday",Right(F_Last_Date(sYearMonth),2))
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 
	END IF
	
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"accname",sAccName)
	END IF
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		Return 
	END IF
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  INTO :sAccName  
   	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2_Cd );
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"accname",snull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		this.SetItem(iCurRow,"accname",sAccName)
	END IF
END IF

end event

event rbuttondown;this.accepttext()
IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
//	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"accname",lstr_account.acc2_nm)
END IF
end event

event getfocus;this.AcceptText()
end event

type dw_junpoy from datawindow within w_kglc24
boolean visible = false
integer x = 165
integer y = 2476
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

type dw_sungin from datawindow within w_kglc24
boolean visible = false
integer x = 165
integer y = 2584
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

type dw_proclst from datawindow within w_kglc24
boolean visible = false
integer x = 165
integer y = 2684
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "선급비용월할 기처리액"
string dataobject = "d_kglc244"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kglc24
boolean visible = false
integer x = 169
integer y = 2784
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

type rr_1 from roundrectangle within w_kglc24
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 224
integer width = 4539
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kglc24
integer x = 82
integer y = 232
integer width = 4507
integer height = 2068
integer taborder = 30
string dataobject = "d_kglc242"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event retrieveend;
Integer i

FOR i = 1 TO rowcount
	IF dw_proclst.Retrieve(this.GetItemString(i,"kfz31ot0_saupj"),&
								  this.GetItemString(i,"kfz31ot0_acc_date"),&
								  this.GetItemString(i,"kfz31ot0_upmu_gu"),&
								  this.GetItemNumber(i,"kfz31ot0_jun_no"), &
								  this.GetItemNumber(i,"kfz31ot0_lin_no")) > 0 THEN
		this.SetItem(i,"gi_amt",dw_proclst.GetItemNumber(1,"sum_div"))	
	ELSE
		this.SetItem(i,"gi_amt",0)	
	END IF
NEXT
end event

type dw_delete from datawindow within w_kglc24
integer x = 82
integer y = 232
integer width = 4507
integer height = 2068
integer taborder = 40
string dataobject = "d_kglc243"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

