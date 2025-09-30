$PBExportHeader$w_kifa04.srw
$PBExportComments$자동전표 관리 : 제조원가 대체전표
forward
global type w_kifa04 from w_inherite
end type
type gb_1 from groupbox within w_kifa04
end type
type rb_1 from radiobutton within w_kifa04
end type
type rb_2 from radiobutton within w_kifa04
end type
type dw_ip from u_key_enter within w_kifa04
end type
type dw_junpoy from datawindow within w_kifa04
end type
type dw_sungin from datawindow within w_kifa04
end type
type dw_print from datawindow within w_kifa04
end type
type rr_1 from roundrectangle within w_kifa04
end type
type dw_rtv from datawindow within w_kifa04
end type
end forward

global type w_kifa04 from w_inherite
string title = "제조원가 대체전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_ip dw_ip
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
rr_1 rr_1
dw_rtv dw_rtv
end type
global w_kifa04 w_kifa04

type variables
String sUpmuGbn = 'E',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sacc1_cha, string sacc2_cha)
end prototypes

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i,iCurRow
String  sSaupj,sBalDate,sUpmuGu,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_rtv.GetItemString(k,"saupj")
		sBalDate = dw_rtv.GetItemString(k,"bal_date")
		sUpmuGu  = dw_rtv.GetItemString(k,"upmu_gu")
		lJunNo   = dw_rtv.GetItemNumber(k,"bjun_no")
		
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
	END IF
NEXT

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
//	sJipFrom = dw_rtv.GetItemString(1,"min_ym")
//	sJipTo   = dw_rtv.GetItemString(1,"max_ym")
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

SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sacc1_cha, string sacc2_cha);/************************************************************************************/
/* 제조계정을 대체 처리한다.																			*/
/* 1. 차변 : 입력한 대체계정과목으로 발생															*/
/* 2. 대변 : 선택된 경비 계정으로 발생																*/
/************************************************************************************/
String  sAcc1_Dae,sAcc2_Dae,sSaupNo,sDcGbn,sYearMonth,sYesanGbn,sChaDae,sRemark1
Integer k,lLinNo,lJunNo,iCurRow
Double  dAmount,dTotalAmount

dw_junpoy.Reset()

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="제조원가 대체전표 처리 중 ..."

dTotalAmount  = 0

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(29,'[발행일자]')
	Return -1
END IF
		
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
lLinNo = 1

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN
		sAcc1_Dae = dw_rtv.GetItemString(k,"acc1_cd")
		sAcc2_Dae = dw_rtv.GetItemString(k,"acc2_cd")
		
		dAmount = dw_rtv.GetItemNumber(k,"amount")
								
		sDcGbn = '2'											/*대변 전표 - 제조경비 계정*/
		
		SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae,:sYesanGbn, :sRemark1
		   FROM "KFZ01OM0"  
			WHERE ( "ACC1_CD" = :sAcc1_Dae ) AND ( "ACC2_CD" = :sAcc2_Dae  ) ;
							
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
		dw_junpoy.SetItem(iCurRow,"descr",   '제조계정으로 대체')
		
		IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_ip.GetItemString(1,"sdept_cd"))
		END IF
		IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
			dw_junpoy.SetItem(iCurRow,"cdept_cd",Gs_Dept)
		END IF
		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 

		dTotalAmount = dTotalAmount + dAmount
		lLinNo = lLinNo + 1
	END IF
NEXT

IF dw_junpoy.RowCount() > 0 THEN				/*차변 전표 발생*/
	SELECT "DC_GU",	"YESAN_GU",	"REMARK1"      INTO :sChaDae,:sYesanGbn, :sRemark1
	   FROM "KFZ01OM0"  
	   WHERE ( "ACC1_CD" = :sAcc1_Cha ) AND ( "ACC2_CD" = :sAcc2_Cha);

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
			
	dw_junpoy.SetItem(iCurRow,"amt",     dTotalAmount)
	dw_junpoy.SetItem(iCurRow,"descr",   '제조계정으로 대체')

	IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
		dw_junpoy.SetItem(iCurRow,"sdept_cd",dw_ip.GetItemString(1,"sdept_cd"))
	END IF
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
END IF

IF dw_junpoy.Update() <> 1 THEN
	F_MessageChk(13,'[미승인전표]')
	SetPointer(Arrow!)
	Return -1
END IF

MessageBox("확 인","발생된 미결전표번호 :"+String(sBalDate,'@@@@.@@.@@')+'-'+String(lJunNo,'0000'))

w_mdi_frame.sle_msg.text ="제조원가 대체전표 처리 완료!!"

Return 1
end function

on w_kifa04.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_ip=create dw_ip
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.dw_rtv
end on

on w_kifa04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_ip)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.rr_1)
destroy(this.dw_rtv)
end on

event open;call super::open;String snull

SetNull(snull)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.GetRow(),"saupj",gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"sdate",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.GetRow(),"edate",f_today())
dw_ip.SetItem(dw_ip.GetRow(),"bal_ymd",f_today())
//dw_ip.SetItem(dw_ip.GetRow(),"acc1_cd",'53150')
//dw_ip.SetItem(dw_ip.GetRow(),"acc2_cd",'00')
//dw_ip.SetItem(dw_ip.GetRow(),"acc2_nm","(제)잡 비")
dw_ip.SetColumn("bal_ymd")
dw_ip.SetFocus()

dw_ip.SetItem(dw_ip.GetRow(),"chose",'2')

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '04' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF


p_mod.Enabled =False
end event

type dw_insert from w_inherite`dw_insert within w_kifa04
boolean visible = false
integer x = 50
integer y = 3088
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa04
boolean visible = false
integer x = 3616
integer y = 3100
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa04
boolean visible = false
integer x = 3442
integer y = 3100
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa04
boolean visible = false
integer x = 2747
integer y = 3100
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kifa04
boolean visible = false
integer x = 3269
integer y = 3100
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa04
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kifa04
boolean visible = false
integer x = 4137
integer y = 3100
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa04
boolean visible = false
integer x = 2921
integer y = 3100
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

type p_inq from w_inherite`p_inq within w_kifa04
integer x = 4096
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj,s_datef,s_datet, scode, ecode

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj = dw_ip.GetItemString(dw_ip.Getrow(),"saupj")
s_datef = dw_ip.GetItemString(dw_ip.Getrow(),"sdate")
s_datet = dw_ip.GetItemString(dw_ip.Getrow(),"edate")

IF sSaupj ="" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return
END IF
IF s_datef ="" OR IsNull(s_datef) THEN
	F_MessageChk(1,'[대체기간]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return
END IF
IF s_datet ="" OR IsNull(s_datet) THEN
	F_MessageChk(1,'[대체기간]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	Return
END IF

// 환경변수 A,2,L은 제조계정범위임 //
  SELECT substr("SYSCNFG"."DATANAME",1,7), substr("SYSCNFG"."DATANAME",8,7)
    INTO :scode, :ecode  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND  
         ( "SYSCNFG"."SERIAL" = 2 ) AND  
         ( "SYSCNFG"."LINENO" = 'L' )   ;
IF sqlca.sqlcode <> 0 then
	MessageBox("확 인","환경변수의 제조계정범위값에 자료를 확인하십시오!!")
	Return
END IF


IF dw_rtv.Retrieve(sSaupj,s_datef,s_datet,scode,ecode) <= 0 THEN
	MessageBox("확 인","처리할 자료가 없습니다.!!")
	Return
END IF

p_mod.Enabled =True
dw_ip.SetItem(dw_ip.Getrow(),"chose",'2')
end event

type p_del from w_inherite`p_del within w_kifa04
boolean visible = false
integer x = 3963
integer y = 3100
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa04
integer x = 4270
integer taborder = 40
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sSaupj,sBalDate,sAcc1,sAcc2,sSdeptCode

IF rb_1.Checked =True THEN
	dw_ip.AcceptText()
	sSaupj     = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
	sBalDate   = dw_ip.GetItemString(dw_ip.GetRow(),"bal_ymd")
	sAcc1      = dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")
	sAcc2      = dw_ip.GetItemString(dw_ip.GetRow(),"acc2_cd")
	sSdeptCode = dw_ip.GetItemString(dw_ip.Getrow(),"sdept_cd") 
	
	IF sSaupj ="" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return
	END IF
	IF sBalDate ="" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[발행일자]')
		dw_ip.SetColumn("bal_ymd")
		dw_ip.SetFocus()
		Return
	END IF
	IF sAcc1 ="" OR IsNull(sAcc1) THEN
		F_MessageChk(1,'[대체계정과목]')
		dw_ip.SetColumn("acc1_cd")
		dw_ip.SetFocus()
		Return
	END IF
	IF sAcc2 ="" OR IsNull(sAcc2) THEN
		F_MessageChk(1,'[대체계정과목]')
		dw_ip.SetColumn("acc2_cd")
		dw_ip.SetFocus()
		Return
	END IF
	IF sSdeptCode ="" OR IsNull(sSdeptCode) THEN
		F_MessageChk(1,'[원가부문]')
		dw_ip.SetColumn("sdept_cd")
		dw_ip.SetFocus()
		Return
	END IF
	
	IF dw_rtv.RowCount() <=0 THEN Return
	
	IF Wf_Insert_Kfz12ot0(sSaupj,sBalDate,sAcc1,sAcc2) = -1 THEN
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
	IF dw_rtv.RowCount() <=0 THEN Return
	
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

type cb_exit from w_inherite`cb_exit within w_kifa04
boolean visible = false
integer x = 3808
integer y = 2784
end type

type cb_mod from w_inherite`cb_mod within w_kifa04
boolean visible = false
integer x = 3442
integer y = 2784
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa04
boolean visible = false
integer x = 1586
integer y = 2592
end type

type cb_del from w_inherite`cb_del within w_kifa04
boolean visible = false
integer x = 1934
integer y = 2588
end type

type cb_inq from w_inherite`cb_inq within w_kifa04
boolean visible = false
integer x = 3072
integer y = 2784
end type

type cb_print from w_inherite`cb_print within w_kifa04
boolean visible = false
integer x = 2181
integer y = 2832
end type

type st_1 from w_inherite`st_1 within w_kifa04
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kifa04
boolean visible = false
integer x = 2642
integer y = 2584
end type

type cb_search from w_inherite`cb_search within w_kifa04
boolean visible = false
integer x = 2528
integer y = 2832
end type

type dw_datetime from w_inherite`dw_datetime within w_kifa04
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kifa04
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kifa04
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kifa04
boolean visible = false
integer x = 32
integer y = 2740
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa04
boolean visible = false
integer x = 3026
integer y = 2732
integer width = 1193
integer height = 188
end type

type gb_1 from groupbox within w_kifa04
integer x = 2985
integer y = 24
integer width = 1079
integer height = 152
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
borderstyle borderstyle = styleraised!
end type

type rb_1 from radiobutton within w_kifa04
integer x = 3049
integer y = 80
integer width = 462
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
string text = "전표발행 처리"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="제조원가 대체전표 발행"
	dw_rtv.DataObject ="d_kifa042"
END IF

dw_rtv.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_kifa04
integer x = 3566
integer y = 80
integer width = 462
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
string text = "전표삭제 처리"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_rtv.Title ="제조원가 대체전표 삭제"
	dw_rtv.DataObject ="d_kifa043"
END IF

dw_rtv.SetTransObject(SQLCA)
end event

type dw_ip from u_key_enter within w_kifa04
event ue_key pbm_dwnkey
integer x = 123
integer y = 196
integer width = 1422
integer height = 1252
integer taborder = 10
string dataobject = "d_kifa041"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String mysql1,snull,sacc,ssql_bal,sSDeptCode

SetNull(snull)
Int i

IF dwo.name ="chose" THEN
	IF data ='1' THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'1')
		NEXT
	ELSEIF data ='2' THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'0')
		NEXT
		
	END IF
END IF

IF dwo.name ="saupj" THEN
	
	IF data ="" OR IsNull(data) THEN 
	ELSE

	SELECT "REFFPF"."RFNA1"  
  		INTO :mysql1
  		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
      		( "REFFPF"."RFGUB" = :data )   ;
  	if sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"사업장")
		dw_ip.SetItem(1,"saupj",snull)
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 1
  	end if
END IF
END IF

IF dwo.name ="sdate" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN
		f_messagechk(20,"대체기간") 
		dw_ip.SetItem(1,"sdate",snull)
		dw_ip.SetColumn("sdate")
		Return 1
	END IF
	
END IF

IF dwo.name ="edate" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN
		f_messagechk(20,"대체기간") 
		dw_ip.SetItem(1,"edate",snull)
		dw_ip.SetColumn("edate")
		Return 1
	END IF
	
END IF

IF dwo.name ="bal_ymd" THEN
	
	IF data ="" OR IsNull(data) THEN RETURN 1
	
	IF f_datechk(data) = -1 THEN
		f_messagechk(20,"발행일자")
		dw_ip.SetItem(1,"bal_ymd",snull)
		dw_ip.SetColumn("bal_ymd")
		Return 1
	END IF
	
	IF F_Check_LimitDate(data,'B') = -1 THEN
		F_MessageChk(29,'[발행일자]')
		dw_ip.SetItem(1,"bal_ymd",snull)
		dw_ip.SetColumn("bal_ymd")
		Return 1
	END IF
		
END IF

IF dwo.name ="acc1_cd" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"acc2_cd")
	
	IF sacc= "" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM",   
    		 "KFZ01OM0"."BAL_GU"  
  		INTO :mysql1,   
           :ssql_bal  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :data ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc )   ;
	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"대체계정과목")
		dw_ip.SetItem(1,"acc1_cd",snull)
		dw_ip.SetItem(1,"acc2_cd",snull)
		dw_ip.SetItem(1,"acc2_nm",snull)
		dw_ip.SetColumn("acc1_cd")
		dw_ip.Setfocus()
		Return 
	ELSE
		IF ssql_bal = '4' THEN
			MessageBox("확 인","전표 발행을 할 수 없는 계정입니다.!!")
			dw_ip.SetItem(1,"acc1_cd",snull)
			dw_ip.SetItem(1,"acc2_cd",snull)
			dw_ip.SetItem(1,"acc2_nm",snull)
			dw_ip.SetColumn("acc1_cd")
			dw_ip.Setfocus()
			Return 1 
		ELSE
			dw_ip.SetItem(dw_ip.GetRow(),"acc2_nm",mysql1)
		END IF
	END IF
END IF

IF dwo.name ="acc2_cd" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"acc1_cd")
	
	IF sacc= "" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM",   
    		 "KFZ01OM0"."BAL_GU"  
  		INTO :mysql1,   
           :ssql_bal  
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :data )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"대체계정과목")
		dw_ip.SetItem(1,"acc1_cd",snull)
		dw_ip.SetItem(1,"acc2_cd",snull)
		dw_ip.SetItem(1,"acc2_nm",snull)
		dw_ip.SetColumn("acc1_cd")
		dw_ip.Setfocus()
		Return 1
	ELSE
		IF ssql_bal = '4' THEN
			MessageBox("확 인","전표 발행을 할 수 없는 계정입니다.!!")
			dw_ip.SetItem(1,"acc1_cd",snull)
			dw_ip.SetItem(1,"acc2_cd",snull)
			dw_ip.SetItem(1,"acc2_nm",snull)
			dw_ip.SetColumn("acc1_cd")
			dw_ip.Setfocus()
			Return 1
		ELSE
			dw_ip.SetItem(dw_ip.GetRow(),"acc2_nm",mysql1)
		END IF
	END IF
END IF

IF this.GetColumnName() = "sdept_cd" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(1,"sdept_cd",snull)
		Return 1
	END IF
END IF



end event

event rbuttondown;
this.AcceptText()
IF this.GetColumnName() = "acc1_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.GetItemString(this.GetRow(),"acc1_cd")
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acc2_nm",lstr_account.acc2_nm)
		
//	this.TriggerEvent(ItemChanged!)
END IF
end event

type dw_junpoy from datawindow within w_kifa04
boolean visible = false
integer x = 23
integer y = 2536
integer width = 846
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
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sungin from datawindow within w_kifa04
boolean visible = false
integer x = 23
integer y = 2640
integer width = 846
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "승인 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa04
boolean visible = false
integer x = 23
integer y = 2748
integer width = 846
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

type rr_1 from roundrectangle within w_kifa04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1554
integer y = 200
integer width = 3058
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kifa04
integer x = 1563
integer y = 204
integer width = 3022
integer height = 2008
integer taborder = 30
string dataobject = "d_kifa043"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

