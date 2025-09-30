$PBExportHeader$w_kifa16.srw
$PBExportComments$자동전표 관리 : 외자입고
forward
global type w_kifa16 from w_inherite
end type
type gb_1 from groupbox within w_kifa16
end type
type rb_1 from radiobutton within w_kifa16
end type
type rb_2 from radiobutton within w_kifa16
end type
type dw_junpoy from datawindow within w_kifa16
end type
type dw_sungin from datawindow within w_kifa16
end type
type dw_detail from datawindow within w_kifa16
end type
type dw_group_detail from datawindow within w_kifa16
end type
type dw_vat from datawindow within w_kifa16
end type
type dw_print from datawindow within w_kifa16
end type
type dw_ip from u_key_enter within w_kifa16
end type
type rr_1 from roundrectangle within w_kifa16
end type
type dw_rtv from datawindow within w_kifa16
end type
type dw_delete from datawindow within w_kifa16
end type
type cbx_all from checkbox within w_kifa16
end type
end forward

global type w_kifa16 from w_inherite
integer height = 2420
string title = "외자입고전표 처리"
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_detail dw_detail
dw_group_detail dw_group_detail
dw_vat dw_vat
dw_print dw_print
dw_ip dw_ip
rr_1 rr_1
dw_rtv dw_rtv
dw_delete dw_delete
cbx_all cbx_all
end type
global w_kifa16 w_kifa16

type variables

String sUpmuGbn = 'O',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode)
public function integer wf_delete_kfz12ot0 ()
end prototypes

public function integer wf_insert_kfz12ot0 (string ssaupj, string sbaldate, string sdeptcode);/************************************************************************************/
/* 외자입고 자료를 자동으로 전표 처리한다.														*/
/* 1. 차변 : 건별 상세의 품목에 대한 계정코드별로 발생.										*/
/* 2. 대변 : 건별 상세의 품목에 대한 미착계정코드별로 발생.									*/
/* ** 품목의 상세내역은 계정별로 모아서 전표의 라인을 구성한다.							*/
/************************************************************************************/
String   sAcc1,sAcc2,sDcGbn,sLcNo,sBlNo,sIoDate,sSdeptCode,sYesanGbn,sChaDae,sCusGbn,sGbn1,&
			sAccDate,sAlcGbn = 'N',sYes = '1',sSabu
Integer  k,iCnt,i,lLinNo,iCurRow,iLoopCnt,iItemDetailCnt,iStartCnt
Long     lJunNo,lAccJunNo
Double   dAmount,dQty

SELECT "VW_CDEPT_CODE"."COST_CD"  										/*원가부문*/
  	INTO :sSdeptCode  
  	FROM "VW_CDEPT_CODE"  
  	WHERE "VW_CDEPT_CODE"."DEPT_CD" = :sDeptCode   ;
		
w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)

IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
	F_MessageChk(28,'[발행일자]')
	Return -1
END IF

dw_rtv.SetFilter("chk = '"+sYes+"'")
dw_rtv.Filter()

w_mdi_frame.sle_msg.text ="외자입고 자동전표 처리 중 ..."

dw_junpoy.Reset()
dw_sungin.Reset()

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)

lLinNo  = 1
iCurRow = 0
iStartCnt = 1
		
FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
				
		sIoDate  = dw_rtv.GetItemString(k,"idate") 
		sLcNo    = dw_rtv.GetItemString(k,"polcno")
		sBlNo    = dw_rtv.GetItemString(k,"poblno")
				
		iLoopCnt = dw_group_detail.Retrieve(sLcNo,sBlNo)		/*처리할 물품 건수*/
		IF iLoopcnt <=0 THEN Continue
		
		FOR iCnt = 1 TO iLoopCnt
			sDcGbn = dw_group_detail.GetItemString(iCnt,"chadae")
			
			sAcc1 = Left(dw_group_detail.GetItemString(iCnt,"accod"),5)
			sAcc2 = Right(dw_group_detail.GetItemString(iCnt,"accod"),2)
				
			dQty      = dw_group_detail.GetItemNumber(iCnt,"sum_ioqty")
			dAmount   = dw_group_detail.GetItemNumber(iCnt,"sum_ioamt")
			IF IsNull(dAmount) THEN dAmount = 0
			IF IsNull(dQty) THEN dQty = 0
			
			SELECT "DC_GU",	"YESAN_GU",	"CUS_GU",	"GBN1"     
				INTO :sChaDae,	:sYesanGbn,	:sCusGbn,	:sGbn1	
				FROM "KFZ01OM0"  
				WHERE ("ACC1_CD" = :sAcc1) AND ("ACC2_CD" = :sAcc2);

			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2)
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)
			
			IF sDcGbn = '1' THEN								/*차변 전표-품목 상세의 계정과목*/
				/*물품 건수*/
				iItemDetailCnt = dw_detail.Retrieve(sLcNo,sBlNo,dw_group_detail.GetItemString(iCnt,"accod"))
			
				dw_junpoy.SetItem(iCurRow,"descr",   dw_detail.GetItemString(1,"itemas_itdsc") +' 외 '+&
																 String(dw_detail.GetItemNumber(1,"item_cnt"))+ '건')	
			ELSE													/*대변 전표-품목 상세의 미착계정과목*/
				dw_junpoy.SetItem(iCurRow,"descr",   '외자 입고')				
			END IF
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdeptCode)
			
			IF sCusGbn = 'Y' THEN
				IF sGbn1 = '1' THEN
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"polcno"))
				ELSE
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_rtv.GetItemString(k,"polcno"))
					dw_junpoy.SetItem(iCurRow,"in_nm",   dw_rtv.GetItemString(k,"polcno"))
				END IF
			END IF
			dw_junpoy.SetItem(iCurRow,"k_qty",   dQty)
			
			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
				dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
			END IF
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 

			lLinNo = lLinNo + 1
		NEXT
	END IF
NEXT

IF dw_junpoy.RowCount() <=0 THEN 
	Return 1
ELSE
	IF dw_junpoy.Update() <> 1 THEN
		F_MessageChk(13,'[미승인전표]')
		SetPointer(Arrow!)
		Return -1
	ELSE			
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				SetPointer(Arrow!)
				Return -1
			ELSE
				sAccDate  = dw_sungin.GetItemString(1,"acc_date")
				lAccJunNo = dw_sungin.GetItemNumber(1,"jun_no")
				sAlcGbn   = 'Y'
			END IF	
		ELSE
			SetNull(sAccDate);	SetNull(lAccJunNo);	sAlcGbn = 'N';
		END IF
	
		FOR i = 1 TO dw_rtv.RowCount()
			IF dw_rtv.GetItemString(i,"chk") = '1' THEN	
				sSabu    = dw_rtv.GetItemString(i,"sabu")
				sIoDate  = dw_rtv.GetItemString(i,"idate") 
				sLcNo    = dw_rtv.GetItemString(i,"polcno")
				sBlNo    = dw_rtv.GetItemString(i,"poblno")
			
				/*외자입고 내역 갱신*/
				UPDATE "KIF16OT0"  
					SET "SAUPJ"   = :sSaupj,		"BAL_DATE" = :sBalDate,		"UPMU_GU"  = :sUpmuGbn,   
						 "BJUN_NO" = :lJunNo,      "ALC_GU"   = :sAlcGbn,     "ACC_DATE" = :sAccDate,   
						 "JUN_NO"  = :lAccJunNo  
					WHERE ( "KIF16OT0"."SABU"   = :sSabu ) AND ( "KIF16OT0"."POLCNO" = :sLcNo ) AND  
							( "KIF16OT0"."POBLNO" = :sBlNo ) AND ("KIF16OT0"."IDATE"  = :sIoDate ) ;
				IF SQLCA.SQLCODE <> 0 THEN
					F_MessageChk(13,'[외자입고내역]')
					SetPointer(Arrow!)
					Return -1
				END IF		
			END IF
		NEXT
	END IF
	
	w_mdi_frame.sle_msg.text ="외자입고 전표 처리 완료!!"
END IF

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
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
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
			
		/*외자입고자료 전표 발행 취소*/
		UPDATE "KIF16OT0"  
     		SET "BAL_DATE" = null,   
 				 "UPMU_GU" = null,   
				 "BJUN_NO" = null
		WHERE ( "KIF16OT0"."SAUPJ"    = :sSaupj  ) AND ( "KIF16OT0"."BAL_DATE" = :sBalDate ) AND  
				( "KIF16OT0"."UPMU_GU"  = :sUpmuGu ) AND ( "KIF16OT0"."BJUN_NO"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			Messagebox("", SQLCA.sqlerrtext)
			F_MessageChk(12,'[외자입고자료]')
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;


SetPointer(Arrow!)
Return 1

end function

on w_kifa16.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_detail=create dw_detail
this.dw_group_detail=create dw_group_detail
this.dw_vat=create dw_vat
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
this.cbx_all=create cbx_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_junpoy
this.Control[iCurrent+5]=this.dw_sungin
this.Control[iCurrent+6]=this.dw_detail
this.Control[iCurrent+7]=this.dw_group_detail
this.Control[iCurrent+8]=this.dw_vat
this.Control[iCurrent+9]=this.dw_print
this.Control[iCurrent+10]=this.dw_ip
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.dw_rtv
this.Control[iCurrent+13]=this.dw_delete
this.Control[iCurrent+14]=this.cbx_all
end on

on w_kifa16.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_detail)
destroy(this.dw_group_detail)
destroy(this.dw_vat)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.rr_1)
destroy(this.dw_rtv)
destroy(this.dw_delete)
destroy(this.cbx_all)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",  Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6) + "01")
dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())
dw_ip.SetItem(dw_ip.Getrow(),"accdate",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_group_detail.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_vat.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '14' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kifa16
boolean visible = false
integer x = 23
integer y = 2712
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa16
boolean visible = false
integer x = 1682
integer y = 3236
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa16
boolean visible = false
integer x = 1509
integer y = 3236
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa16
integer x = 3922
integer y = 4
integer taborder = 70
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

event p_search::clicked;call super::clicked;Integer iSelectRow

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	Gs_Code     = dw_rtv.GetItemString(iSelectRow,"sabu")
	
	OpenWithParm(w_kifa16a,dw_rtv.GetItemString(iSelectRow,"polcno") + &
								  dw_rtv.GetItemString(iSelectRow,"poblno"))
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return
	
	Gs_Code     = dw_delete.GetItemString(iSelectRow,"sabu")
	
	OpenWithParm(w_kifa16a,dw_delete.GetItemString(iSelectRow,"polcno") + &
								  dw_delete.GetItemString(iSelectRow,"poblno"))
END IF
end event

type p_ins from w_inherite`p_ins within w_kifa16
boolean visible = false
integer x = 1335
integer y = 3236
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa16
integer y = 4
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa16
boolean visible = false
integer x = 2203
integer y = 3236
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa16
boolean visible = false
integer x = 987
integer y = 3236
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iRtnVal

IF dw_junpoy.RowCount() <=0 then Return

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

Integer iCount
	
iCount = dw_ip.GetItemNumber(1,"empcnt")

if iCount = 1 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	
elseif iCount = 2 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 3 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 4 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible = 0")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 5 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible = 0")
	dw_print.Modify("t_gl5.visible = 0")
end if


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

type p_inq from w_inherite`p_inq within w_kifa16
integer x = 4096
integer y = 4
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaleDtf,sSaleDtT,sSaupj

IF dw_ip.AcceptText() = -1 THEN RETURN
sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sSaleDtf = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtf"))
sSaleDtt = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtt"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[입고일자]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[입고일자]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetFilter("")
dw_rtv.Filter()
	
dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa16
boolean visible = false
integer x = 2030
integer y = 3236
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa16
integer x = 4270
integer y = 4
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event p_mod::clicked;call super::clicked;
String sAccDate,sDeptCode,sSaupj

IF rb_1.Checked =True THEN
	IF dw_rtv.RowCount() <=0 THEN Return
	
	dw_ip.AcceptText()
	sSaupj    = dw_ip.GetItemString(1,"saupj")
	sAccDate  = dw_ip.GetItemString(1,"accdate")
	sDeptCode = dw_ip.GetItemString(1,"deptcd")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')	
		dw_ip.SetColumn("saupj")
		dw_ip.SetFocus()
		Return 
	END IF
	IF sAccDate = "" OR IsNull(sAccDate) THEN
		F_MessageChk(1,'[회계일자]')	
		dw_ip.SetColumn("accdate")
		dw_ip.SetFocus()
		Return 
	else
		IF F_Check_LimitDate(sAccDate,'A') = -1 THEN
			F_MessageChk(28,'[회계일자]')
			dw_ip.SetColumn("accdate")
			dw_ip.SetFocus()
			Return
		END IF
	END IF
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		F_MessageChk(1,'[작성부서]')	
		dw_ip.SetColumn("deptcd")
		dw_ip.SetFocus()
		Return 
	END IF

	IF Wf_Insert_Kfz12ot0(sSaupj,sAccDate,sDeptCode) = -1 THEN
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

type cb_exit from w_inherite`cb_exit within w_kifa16
integer x = 3712
integer y = 3256
end type

type cb_mod from w_inherite`cb_mod within w_kifa16
integer x = 3374
integer y = 3252
integer width = 329
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa16
integer x = 1970
integer y = 2808
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa16
integer x = 2469
integer y = 2668
end type

type cb_inq from w_inherite`cb_inq within w_kifa16
integer x = 3013
integer y = 3252
end type

type cb_print from w_inherite`cb_print within w_kifa16
integer x = 2071
integer y = 3104
end type

type st_1 from w_inherite`st_1 within w_kifa16
end type

type cb_can from w_inherite`cb_can within w_kifa16
integer x = 3173
integer y = 2668
end type

type cb_search from w_inherite`cb_search within w_kifa16
integer x = 2487
integer y = 3252
integer width = 498
string text = "품목보기(&V)"
end type







type gb_button1 from w_inherite`gb_button1 within w_kifa16
integer x = 1193
integer y = 2504
integer height = 276
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa16
integer x = 2423
integer y = 3204
integer width = 1664
end type

type gb_1 from groupbox within w_kifa16
integer x = 3323
integer width = 457
integer height = 224
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

type rb_1 from radiobutton within w_kifa16
integer x = 3346
integer y = 52
integer width = 416
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
	dw_rtv.Title ="외자입고 자동전표 발행"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa16
integer x = 3346
integer y = 128
integer width = 416
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
	dw_delete.Title ="외자입고 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa16
boolean visible = false
integer x = 55
integer y = 2296
integer width = 1029
integer height = 112
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

type dw_sungin from datawindow within w_kifa16
boolean visible = false
integer x = 55
integer y = 2400
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

type dw_detail from datawindow within w_kifa16
boolean visible = false
integer x = 1221
integer y = 2644
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "건에 계정별 품목 상세"
string dataobject = "d_kifa164"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_group_detail from datawindow within w_kifa16
boolean visible = false
integer x = 1221
integer y = 2544
integer width = 1029
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "권별 계정별 합 리스트"
string dataobject = "d_kifa165"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_vat from datawindow within w_kifa16
boolean visible = false
integer x = 69
integer y = 2516
integer width = 1029
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "부가세 저장"
string dataobject = "d_kifa037"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa16
boolean visible = false
integer x = 73
integer y = 2624
integer width = 1019
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

type dw_ip from u_key_enter within w_kifa16
event ue_key pbm_dwnkey
integer x = 27
integer y = 4
integer width = 3282
integer height = 232
integer taborder = 10
string dataobject = "d_kifa161"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sDeptCode,sChoose,sSdeptCode
Integer i

SetNull(snull)

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"입고일자")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"입고일자")
		dw_ip.SetItem(1,"saledtt",snull)
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

IF this.GetColumnName() ="deptcd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN Return
	
	IF IsNull(F_Get_PersonLst('3',sDeptCode,'1')) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(this.GetRow(),"deptcd",snull)
		Return 1
	END IF
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  
   	INTO :sSdeptCode  
    	FROM "VW_CDEPT_CODE"  
   	WHERE "VW_CDEPT_CODE"."DEPT_CD" = :sDeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN SetNull(sSdeptCode)
	
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_no" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kifa16
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 236
integer width = 4567
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kifa16
integer x = 64
integer y = 244
integer width = 4535
integer height = 1976
integer taborder = 30
string dataobject = "d_kifa162"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;String  sChk,sSabu,sBlNo,sLcNo
Integer iCount

IF this.GetColumnName() = "chk" THEN
	sChk = this.GetText()
	IF sChk = "" OR IsNull(sChk) THEN Return
	
	IF sChk = '1' THEN
		sSabu = this.GetItemString(this.GetRow(),"sabu")
		sLcNo = this.GetItemString(this.GetRow(),"polcno")
		sBlNo = this.GetItemString(this.GetRow(),"poblno")

		SELECT Count(*)     INTO :iCount    
    		FROM "KIF16OT1"  
   		WHERE ( "KIF16OT1"."SABU"   = :sSabu ) AND ( "KIF16OT1"."POLCNO" = :sLcNo ) AND  
         		( "KIF16OT1"."POBLNO" = :sBlNo ) ;
		IF SQLCA.SQLCODE <> 0 THEN
			iCount = 0
		ELSE
			IF IsNull(iCount) THEN iCount = 0
		END IF
		IF iCount <= 0 THEN
			F_MessageChk(16,'[품목별 계정과목]')
			Return 1
		END IF
		
		SELECT Count(*)     INTO :iCount    
    		FROM "KIF16OT1"  
   		WHERE ( "KIF16OT1"."SABU"   = :sSabu ) AND ( "KIF16OT1"."POLCNO" = :sLcNo ) AND  
         		( "KIF16OT1"."POBLNO" = :sBlNo ) AND
					( "KIF16OT1"."ACCODE" is null OR "KIF16OT1"."ACCODE" = '');

		IF SQLCA.SQLCODE <> 0 THEN
			iCount = 0
		ELSE
			IF IsNull(iCount) THEN iCount = 0
		END IF
		
		IF iCount > 0 THEN
			F_MessageChk(1,'[품목별 계정과목]')
			Return 1
		END IF
	END IF
END IF
end event

type dw_delete from datawindow within w_kifa16
integer x = 64
integer y = 244
integer width = 4535
integer height = 1976
integer taborder = 40
string dataobject = "d_kifa163"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

	
end event

type cbx_all from checkbox within w_kifa16
integer x = 3799
integer y = 156
integer width = 357
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

