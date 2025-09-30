$PBExportHeader$w_kifa20.srw
$PBExportComments$자동전표 관리 : 매출(거래명세서기준)
forward
global type w_kifa20 from w_inherite
end type
type gb_1 from groupbox within w_kifa20
end type
type rb_1 from radiobutton within w_kifa20
end type
type rb_2 from radiobutton within w_kifa20
end type
type dw_ip from u_key_enter within w_kifa20
end type
type dw_junpoy from datawindow within w_kifa20
end type
type dw_sungin from datawindow within w_kifa20
end type
type dw_print from datawindow within w_kifa20
end type
type dw_group_detail from datawindow within w_kifa20
end type
type dw_detail from datawindow within w_kifa20
end type
type rr_1 from roundrectangle within w_kifa20
end type
type dw_rtv from datawindow within w_kifa20
end type
type dw_delete from datawindow within w_kifa20
end type
type cbx_all from checkbox within w_kifa20
end type
end forward

global type w_kifa20 from w_inherite
string title = "매출전표 처리(거래명세서 기준)"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_group_detail dw_group_detail
dw_detail dw_detail
rr_1 rr_1
dw_rtv dw_rtv
dw_delete dw_delete
cbx_all cbx_all
end type
global w_kifa20 w_kifa20

type variables

String sUpmuGbn = 'D',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_update_imhist (string sdatef, string sdatet, string saupj, string baldate, string upmugu, long junno)
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0 (string ssaupj, string sdeptcode, string sbaldate)
end prototypes

public function integer wf_update_imhist (string sdatef, string sdatet, string saupj, string baldate, string upmugu, long junno);Integer i,k
String  sSqlSelect,sCvcod, sAddSelect

IF dw_rtv.RowCount() <=0 THEN Return 1
IF dw_rtv.GetItemNumber(1,"yescnt") = 0 OR IsNull(dw_rtv.GetItemNumber(1,"yescnt")) THEN Return 1

dw_detail.DataObject = 'd_kifa204'
dw_detail.SetTransObject(SQLCA)
dw_detail.Reset()

sSqlSelect = dw_detail.GetSqlSelect()
sSqlSelect = sSqlSelect + " AND (IMHIST.SAUPJANG ='" + saupj +"')"
sSqlSelect = sSqlSelect + " AND (IMHIST.IO_DATE >='" + sDateF +"' AND IMHIST.IO_DATE <= '" + sDatet +"')"
sSqlSelect = sSqlSelect + ' AND ('

FOR i = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(i,"chk") = '1' THEN		
		sCvcod = dw_rtv.GetItemString(i,"cvcod") 
		
		sAddSelect = sAddSelect + " IMHIST.CVCOD = '" + sCvcod + "' OR" 
	END IF
NEXT

sSqlSelect = sSqlSelect + Left(sAddSelect,Len(sAddSelect) - 2) +')'

dw_detail.SetSqlSelect(sSqlSelect)

dw_detail.Modify( "DataWindow.Table.UpdateTable = ~"IMHIST~"")

dw_detail.Retrieve()

FOR k = 1 TO dw_detail.RowCount()
	dw_detail.SetItem(k,"checkno",   upmugu+baldate+String(junno,'0000'))	
NEXT

IF dw_detail.Update() <> 1 THEN
	Return -1
END IF
Return 1
end function

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,sChkNo,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()
dw_sungin.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sChkNo   = dw_delete.GetItemString(k,"checkno")
		
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = Mid(sChkNo,2,8)
		sUpmuGu  = Left(sChkNo,1)
		lJunNo   = Long(Right(sChkNo,4))
		
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
		
		/*매출자료 전표 발행 취소*/
		UPDATE "IMHIST"  
     		SET "CHECKNO" = null 
		WHERE ( "IMHIST"."CHECKNO"    = :sChkNo  )  ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[매출자료]'+sqlca.sqlerrtext)
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;

//String sJipFrom,sJipTo,sJipFlag
//
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
//	FROM "SYSCNFG"  
//   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
//         ( "SYSCNFG"."LINENO" = '1' )   ;
//IF SQLCA.SQLCODE <> 0 THEN 
//	sJipFlag = 'N'
//ELSE
//	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
//END IF
//
//IF sJipFlag = 'Y' THEN
//	sJipFrom = dw_delete.GetItemString(1,"min_ym")
//	sJipTo   = dw_delete.GetItemString(1,"max_ym")
//	
//	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	//전사로 집계('00'월)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	//stored procedure로 사업부문별 거래처별 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF
//
//SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sdeptcode, string sbaldate);/************************************************************************************/
/* 매출자료를 자동으로 전표 처리한다.																*/
/* 1. 차변 : 외상매출금 계정과목으로 발생.(환경파일 A-1-51)									*/
/* 2. 대변 : 건별 상세의 품목에 대한 계정과목으로 발생.										*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sSdept,sCvcod,sYesanGbn,sChaDae,&
			sRemark1,sCusGbn,sGbn1
Integer  k,i,lLinNo,iCurRow,iAccCnt
Long     lJunNo
Double   dAmount

w_mdi_frame.sle_msg.text =""

SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)	/*차변계정(외상매출금)*/
	INTO :sAcc1_Cha,								:sAcc2_Cha
   FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '51' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	F_MessageChk(56,'[차변계정(A-1-51)]')
	RETURN -1
END IF

/*원가부문*/
SELECT "VW_CDEPT_CODE"."COST_CD"    INTO :sSdept  
	FROM "VW_CDEPT_CODE"  
   WHERE "VW_CDEPT_CODE"."DEPT_CD" = :sDeptCode   ;

w_mdi_frame.sle_msg.text ="매출 자동전표 처리 중 ..."

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(28,'[발행일자]')
	Return -1
END IF

dw_junpoy.Reset()
		
/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1
		
FOR k = 1 TO dw_rtv.RowCount()
	
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		sCvcod = dw_rtv.GetItemString(k,"cvcod")
		
		iAccCnt = dw_group_detail.Retrieve(sSaupj,dw_ip.GetItemString(1,"datef"),dw_ip.GetItemString(1,"datet"),sCvcod)
		IF iAccCnt <=0 THEN Continue
		
		sDcGbn = '2'											/*대변 전표*/
		FOR i = 1 TO iAccCnt
			sAcc1_Dae = Left(dw_group_detail.GetItemString(i,"itemacc"),5)
			sAcc2_Dae = Right(dw_group_detail.GetItemString(i,"itemacc"),2)
			
			SELECT "DC_GU",	"YESAN_GU",		"REMARK1",	"CUS_GU",	"GBN1" 
				INTO :sChaDae,	:sYesanGbn,		:sRemark1,	:sCusGbn,	:sGbn1		
				FROM "KFZ01OM0"  
				WHERE ("ACC1_CD" = :sAcc1_Dae) AND ("ACC2_CD" = :sAcc2_Dae);
					
			dAmount  = dw_group_detail.GetItemNumber(i,"ioamt")
			IF IsNull(dAmount) THEN dAmount = 0
			
			iCurRow = dw_junpoy.InsertRow(0)
			
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			dw_junpoy.SetItem(iCurRow,"descr",   '매출 '+dw_group_detail.GetItemString(i,"min_itnbr")+ ' 외')	
			
			IF sChaDae = sDcGbn AND sRemark1 = 'Y' THEN
				dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
			END IF
			
			IF sChaDae = sDcGbn AND (sYesanGbn = 'Y' OR sYesanGbn = 'A') THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
			END IF
			
			IF sCusGbn = 'Y' THEN
				IF sGbn1 = '8' THEN							/*품번*/
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_group_detail.GetItemString(i,"min_itnbr"))
				ELSE
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
					dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvname"))
				END IF				
			END IF
		
//			dw_junpoy.SetItem(iCurRow,"k_qty",   dw_group_detail.GetItemNumber(i,"ioqty"))
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				
			lLinNo = lLinNo + 1		
		NEXT		
		
		sDcGbn = '1'											/*차변 전표-외상매출금*/
			
		iCurRow = dw_junpoy.InsertRow(0)
		
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
		dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
		dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					
		dw_junpoy.SetItem(iCurRow,"amt",     dw_rtv.GetItemNumber(k,"sum_ioamt"))	
		dw_junpoy.SetItem(iCurRow,"descr",   '외상매출금 ')	
		
		dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdept)
		dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"cvcod"))
		dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"cvname"))
		
//		dw_junpoy.SetItem(iCurRow,"k_qty",   dw_rtv.GetItemNumber(k,"sum_ioqty"))
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				
		lLinNo = lLinNo + 1		
		
		dw_rtv.SetItem(k,"imhist_checkno",   sUpmuGbn+sBalDate+String(lJunno,'0000'))	

	END IF
NEXT
		
IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return -1
ELSE		
	IF	Wf_Update_Imhist(dw_ip.GetItemString(1,"datef"),dw_ip.GetItemString(1,"datet"),&
							  sSaupj,sBalDate,sUpmuGbn,lJunNo) = -1 THEN
		F_MessageChk(13,'[매출자료-IMHIST]')
		SetPointer(Arrow!)
		Return -1	
	END IF
	IF dw_junpoy.RowCount() > 0 THEN
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
				Return -1
			END IF	
		END IF
	END IF
END IF
	
COMMIT;

w_mdi_frame.sle_msg.text ="매출 전표 처리 완료!!"

Return 1
end function

on w_kifa20.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_group_detail=create dw_group_detail
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
this.cbx_all=create cbx_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_group_detail
this.Control[iCurrent+9]=this.dw_detail
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.dw_rtv
this.Control[iCurrent+12]=this.dw_delete
this.Control[iCurrent+13]=this.cbx_all
end on

on w_kifa20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_group_detail)
destroy(this.dw_detail)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.dw_delete)
destroy(this.cbx_all)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",   gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"deptcode",gs_dept)
dw_ip.SetItem(dw_ip.Getrow(),"datef",   Left(f_today(),6) + "01")
dw_ip.SetItem(dw_ip.Getrow(),"datet",   f_today())

dw_ip.SetItem(dw_ip.Getrow(),"accdate", f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_detail.SetTransObject(SQLCA)
dw_group_detail.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '18' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("cvcod")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa20
boolean visible = false
integer x = 32
integer y = 3096
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa20
boolean visible = false
integer x = 3753
integer y = 2824
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa20
boolean visible = false
integer x = 3579
integer y = 2824
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa20
integer x = 3931
integer taborder = 70
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

event p_search::clicked;call super::clicked;Integer iSelectRow

Gs_Gubun = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	Gs_Code = dw_rtv.GetItemString(iSelectRow,"cvcod")

	OpenWithParm(w_kifa20a,'I'+dw_ip.GetItemString(1,"datef")+dw_ip.GetItemString(1,"datet"))
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	
	OpenWithParm(w_kifa20a,'D'+dw_delete.GetItemString(iSelectRow,"checkno"))
END IF
end event

type p_ins from w_inherite`p_ins within w_kifa20
boolean visible = false
integer x = 3406
integer y = 2824
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa20
integer x = 4453
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa20
boolean visible = false
integer x = 4274
integer y = 2824
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa20
boolean visible = false
integer x = 3058
integer y = 2824
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

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

type p_inq from w_inherite`p_inq within w_kifa20
integer x = 4105
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sdatef,sdateT,sCvcod,sSaupj

IF dw_ip.AcceptText() = -1 THEN RETURN
sSaupj = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sDatef = dw_ip.GetItemString(dw_ip.GetRow(),"datef")
sDatet = dw_ip.GetItemString(dw_ip.GetRow(),"datet")
sCvcod = dw_ip.GetItemString(dw_ip.GetRow(),"cvcod")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF
IF sCvcod = "" OR IsNull(sCvcod) THEN
	sCvcod = '%'
END IF

IF sDatef = "" OR IsNull(sDateF) THEN
	F_MessageChk(1,'[출고일자]')	
	dw_ip.SetColumn("datef")
	dw_ip.SetFocus()
	Return 
END IF
IF sDatet = "" OR IsNull(sDatet) THEN
	F_MessageChk(1,'[출고일자]')	
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sCvcod,sDatef,sDatet) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sCvcod,sDatef,sDatet) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa20
boolean visible = false
integer x = 4101
integer y = 2824
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa20
integer x = 4279
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;call super::clicked;
IF rb_1.Checked =True THEN
	
	String  sSaupj,sDeptCode,sAccDate
	Integer iChooseCnt,i
	
	IF dw_ip.AcceptText() = -1 THEN RETURN
	
	sSaupj    = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	sDeptCode = dw_ip.GetItemString(dw_ip.GetRow(),"deptcode")
	sAccDate  = dw_ip.GetItemString(dw_ip.GetRow(),"accdate")

	IF ssaupj ="" OR IsNull(ssaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 
	END IF
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		F_MessageChk(1,'[작성부서]')	
		dw_ip.SetColumn("deptcode")
		dw_ip.SetFocus()
		Return 
	END IF
	IF sAccDate = "" OR IsNull(sAccDate) THEN
		F_MessageChk(1,'[회계일자]')	
		dw_ip.SetColumn("accdate")
		dw_ip.SetFocus()
		Return 
	END IF

	IF dw_rtv.RowCount() <=0 THEN Return

	IF Wf_Insert_Kfz12ot0(sSaupj,sDeptCode,sAccDate) = -1 THEN
		Rollback;
		Return
	END IF
	Commit;
	
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

type cb_exit from w_inherite`cb_exit within w_kifa20
boolean visible = false
integer x = 4032
integer y = 3140
end type

type cb_mod from w_inherite`cb_mod within w_kifa20
boolean visible = false
integer x = 3680
integer y = 3136
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa20
boolean visible = false
integer x = 2450
integer y = 2824
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa20
boolean visible = false
integer x = 2450
integer y = 2680
end type

type cb_inq from w_inherite`cb_inq within w_kifa20
boolean visible = false
integer x = 3319
integer y = 3136
end type

type cb_print from w_inherite`cb_print within w_kifa20
boolean visible = false
integer x = 2802
integer y = 2680
end type

type st_1 from w_inherite`st_1 within w_kifa20
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifa20
boolean visible = false
integer x = 3154
integer y = 2680
end type

type cb_search from w_inherite`cb_search within w_kifa20
boolean visible = false
integer x = 2793
integer y = 3144
integer width = 498
string text = "품목보기(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kifa20
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kifa20
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kifa20
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifa20
boolean visible = false
integer x = 2738
integer y = 2620
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa20
boolean visible = false
integer x = 2747
integer y = 3084
integer width = 1659
end type

type gb_1 from groupbox within w_kifa20
integer x = 3419
integer y = 4
integer width = 475
integer height = 316
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

type rb_1 from radiobutton within w_kifa20
integer x = 3438
integer y = 80
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
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="매출 자동전표 발행"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("cvcod")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa20
integer x = 3442
integer y = 184
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
borderstyle borderstyle = stylelowered!
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="매출 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("cvcod")
dw_ip.SetFocus()


end event

type dw_ip from u_key_enter within w_kifa20
event ue_key pbm_dwnkey
integer x = 27
integer width = 3397
integer height = 332
integer taborder = 10
string dataobject = "d_kifa201"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose,sdeptCode,sCust,sCustName,sDeptName
Integer i

SetNull(snull)

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

IF this.GetColumnName() ="datef" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"출고일자")
		dw_ip.SetItem(1,"datef",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="satet" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"출고일자")
		dw_ip.SetItem(1,"datet",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "cvcod" THEN
	sCust = this.GetText()
	IF sCust = "" OR IsNull(sCust) THEN 
		this.SetItem(1,"cvname",snull)
		Return
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCust) AND ( "KFZ04OM0"."PERSON_GU" = '1');
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[거래처]')
		this.SetItem(1,"cvcod",    sNull)
		this.SetItem(1,"cvname",sNull)
		Return 
	ELSE
		this.SetItem(1,"cvname",sCustName)
	END IF
END IF

IF this.GetColumnName() = "deptcode" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sDeptName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(1,"deptcode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="accdate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"회계일자")
		dw_ip.SetItem(1,"accdate",snull)
		Return 1
	END IF
	IF F_Check_LimitDate(sDate,'B') = -1 THEN
		F_MessageChk(29,'[회계일자]')
		this.SetItem(1,"accdate",snull)
		this.SetColumn("accdate")
		Return 1
	END IF
END IF

IF this.GetColumnName() ="choose" THEN
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

IF this.GetColumnName() ="cvcod" THEN
	lstr_custom.code = this.getitemstring(this.getrow(), "cvcod")
	
	if lstr_custom.code = "" or isnull(lstr_custom.code) then lstr_custom.code =''
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"cvcod",   lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"cvname",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type dw_junpoy from datawindow within w_kifa20
boolean visible = false
integer x = 73
integer y = 2588
integer width = 1029
integer height = 104
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

type dw_sungin from datawindow within w_kifa20
boolean visible = false
integer x = 73
integer y = 2696
integer width = 1029
integer height = 104
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

type dw_print from datawindow within w_kifa20
boolean visible = false
integer x = 73
integer y = 2796
integer width = 1029
integer height = 104
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

type dw_group_detail from datawindow within w_kifa20
boolean visible = false
integer x = 1120
integer y = 2588
integer width = 1029
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "수불 상세- 계정별"
string dataobject = "d_kifa203"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_detail from datawindow within w_kifa20
boolean visible = false
integer x = 1120
integer y = 2696
integer width = 1029
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "IMHIST의 CHECKNO에 전표번호 갱신"
string dataobject = "d_kifa204"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
boolean righttoleft = true
end type

type rr_1 from roundrectangle within w_kifa20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 332
integer width = 4576
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kifa20
integer x = 50
integer y = 340
integer width = 4549
integer height = 1888
integer taborder = 30
string dataobject = "d_kifa202"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;String sAcCode,sAcName,snull

SetNull(snull)

IF this.GetColumnName() ="accode" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN Return
	
	SELECT "KFZ01OM0"."ACC2_NM"   	INTO :sAcName
	  	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAcCode);
				
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(this.GetRow(),"accode",snull)
		this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",sAcName)
	END IF
END IF
end event

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

IF this.GetColumnName() ="accode" THEN

	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"accode"),1)

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	end if

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	this.SetItem(this.GetRow(),"accode" ,lstr_account.acc1_cd+lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",lstr_account.acc2_nm)
END IF
end event

event clicked;
IF row <=0 THEN Return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

type dw_delete from datawindow within w_kifa20
integer x = 50
integer y = 340
integer width = 4549
integer height = 1888
integer taborder = 40
string dataobject = "d_kifa205"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
IF row <=0 THEN Return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

type cbx_all from checkbox within w_kifa20
integer x = 3941
integer y = 252
integer width = 366
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
string text = "전체선택"
borderstyle borderstyle = stylelowered!
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

