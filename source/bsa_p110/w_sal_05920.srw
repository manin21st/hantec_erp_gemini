$PBExportHeader$w_sal_05920.srw
$PBExportComments$거래처 분기영업순위 현황
forward
global type w_sal_05920 from w_standard_print
end type
end forward

global type w_sal_05920 from w_standard_print
string title = "거래처 분기영업순위 현황"
long backcolor = 80859087
end type
global w_sal_05920 w_sal_05920

forward prototypes
public function double wf_set_cvcod (integer nrow, string s_fryymm, string s_toyymm, string scvcod)
public function integer wf_retrieve ()
end prototypes

public function double wf_set_cvcod (integer nrow, string s_fryymm, string s_toyymm, string scvcod);/********************************************************************************/
/* 거래처에 대한 기 여신금액/여신율을 산출한다.	(분기)								  */
/* argument : 법인코드(I),거래처(I),분기시작년월(I),분기끝년월(I),현재일자(I)   */
/* return   : dec (여신율)       									  				        */
/********************************************************************************/
dec {2} Cal_dBMiSuGum,	Cal_dDPanMaeGum,	Cal_dOrdCntAmt	
dec     Cal_dBillJaga,	Cal_dBillTasuN,	Cal_dBillTasuY
dec  	  Cal_UseAmount,	Cal_dBillBudo,    Cal_dSugum
dec     Cal_CreditLimit,Cal_CreditRate,   Cal_SinJangRate
Double  eum,sugum, Cal_hoijunil,          Cal_Dambo
Long    sRow

String  sCurDate, sDate

sCurDate = f_last_date(s_toyymm)

SetPointer(hourGlass!)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

/*전월 미수금*/
SELECT SUM("VNDJAN"."IWOL_CREDIT_AMT") 
  INTO :Cal_dBMiSuGum
  FROM "VNDJAN", "VNDMST"
 WHERE ( "VNDJAN"."CVCOD" = "VNDMST"."CVCOD") AND
       ( "VNDJAN"."SABU" = :gs_sabu ) AND  
       ( "VNDJAN"."BASE_YYMM" = :s_toyymm ) AND  
		  vndjan.silgu = :ls_silgu   and
       ( "VNDMST"."SALESCOD" = :sCvcod );

IF IsNull(Cal_dBMiSuGum) THEN
	Cal_dBMiSuGum =0
END IF

/*분기수금, 판매금액 */
SELECT SUM(NVL("VNDJAN"."SUGUM_BILL",0) + NVL("VNDJAN"."SUGUM_SAVE",0) +
               NVL("VNDJAN"."SUGUM_CASH",0) + NVL("VNDJAN"."SUGUM_GITA",0)),
		 SUM("VNDJAN"."MAECHUL_AMT")
  INTO :Cal_dSuGum, :Cal_dDPanMaeGum
  FROM "VNDJAN"  ,"VNDMST"
 WHERE ( "VNDJAN"."CVCOD" = "VNDMST"."CVCOD") AND
       ( "VNDJAN"."SABU" = :gs_sabu ) AND  
		   vndjan.silgu = :ls_silgu   and
       ( "VNDJAN"."BASE_YYMM" = :s_toyymm ) AND  
       ( "VNDMST"."SALESCOD" = :sCvcod );

IF IsNull(Cal_dSuGum) THEN
	Cal_dSuGum =0
END IF

IF IsNull(Cal_dDPanMaeGum) THEN
	Cal_dDPanMaeGum =0
END IF

/* 미처리금액 */
SELECT SUM((NVL(SORDER.ORDER_QTY,0) - NVL(SORDER.OUT_QTY,0)) * 
		 NVL(SORDER.ORDER_PRC,0))
  INTO :Cal_dOrdCntAmt
  FROM SORDER  ,VNDMST
 WHERE ( SORDER.CVCOD = VNDMST.CVCOD ) AND
       ( SORDER.SABU = :gs_sabu ) AND  
		 ( VNDMST.SALESCOD = :sCvcod ) AND  
	  	 ( SORDER.SUJU_STS = '2' OR SORDER.SUJU_STS = '5' OR SORDER.SUJU_STS = '6' );
IF IsNull(Cal_dOrdCntAmt) THEN
	Cal_dOrdCntAmt =0
END IF
				 
/*자가발행 만기 미도래 어음*/
SELECT SUM("KFM02OT0"."BILL_AMT")
	INTO :Cal_dBillJaga  
	FROM "KFM02OT0"  ,"VNDMST"
	WHERE ( "KFM02OT0"."SAUP_NO" = "VNDMST"."CVCOD" ) AND
	      ( "VNDMST"."SALESCOD" = :sCvcod ) AND
	      ( "KFM02OT0"."BMAN_DAT" > :sCurDate ) AND  
      	( "KFM02OT0"."BILL_JIGU" = '1' ) AND  ( "KFM02OT0"."STATUS" <> '9' );

IF IsNull(Cal_dBillJaga) THEN
	Cal_dBillJaga =0
END IF

/*타수발행 만기 미도래어음*/
SELECT SUM("KFM02OT0"."BILL_AMT")
	INTO :Cal_dBillTasuN  
	FROM "KFM02OT0" , "VNDMST"
	WHERE ( "KFM02OT0"."SAUP_NO" = "VNDMST"."CVCOD" ) AND
	      ( "VNDMST"."SALESCOD" = :sCvcod ) AND
	      ( "KFM02OT0"."BMAN_DAT" > :sCurDate ) AND  
			( "KFM02OT0"."BILL_JIGU" = '2' ) AND  ( "KFM02OT0"."STATUS" <> '9' ) AND
			( "KFM02OT0"."TEMP_BILL_YN" = 'N');
				
IF IsNull(Cal_dBillTasuN) THEN
	Cal_dBillTasuN =0
END IF

/*타수발행 만기 미도래어음(융통어음)*/
SELECT SUM("KFM02OT0"."BILL_AMT")
	INTO :Cal_dBillTasuY
	FROM "KFM02OT0"  ,"VNDMST"
	WHERE ( "KFM02OT0"."SAUP_NO" = "VNDMST"."CVCOD" ) AND
	      ( "VNDMST"."SALESCOD" = :sCvcod ) AND
	      ( "KFM02OT0"."BMAN_DAT" > :sCurDate ) AND  
	      ( "KFM02OT0"."BILL_JIGU" = '2' ) AND  ( "KFM02OT0"."STATUS" <> '9' ) AND
	      ( "KFM02OT0"."TEMP_BILL_YN" = 'Y');

IF IsNull(Cal_dBillTasuY) THEN
	Cal_dBillTasuY =0
END IF

/*부도어음 잔액*/
SELECT SUM("KFM02OT0"."BILL_AMT") - SUM("KFM02OT0"."BUDO_AMT")
	INTO :Cal_dBillBudo
	FROM "KFM02OT0"  ,"VNDMST"
	WHERE ( "KFM02OT0"."SAUP_NO" = "VNDMST"."CVCOD" ) AND 
	      ( "VNDMST"."SALESCOD" = :sCvcod ) AND 
/*	      ( "KFM02OT0"."BMAN_DAT" > :sCurDate ) AND   */
  	      ( "KFM02OT0"."STATUS" ='9' );

IF IsNull(Cal_dBillBudo) THEN
	Cal_dBillBudo =0
END IF

Cal_UseAmount = Cal_dBMiSuGum +	Cal_dDPanMaeGum +	Cal_dOrdCntAmt + Cal_dBillJaga + &
                Cal_dBillTasuN + Cal_dBillTasuY +	Cal_dBillBudo - Cal_dSugum

/*거래처 담보금액 및 실적거래처 */
select nvl(a.credit_limit,0)
  into :Cal_CreditLimit
  from vndmst a
 where a.cvstatus <> '2' and
       a.cvcod = :sCvcod;
 
select sum(nvl(b.damamt,0))
  into :Cal_Dambo
  from vndmst a,custdambo b
 where a.cvcod = b.cust_no(+) and
       a.cvstatus <> '2' and
       a.salescod = :sCvcod
 group by a.salescod;

If sqlca.sqlcode <> 0 Then Cal_creditLimit = 0

/* 여신율 = 여신금액/(신용한도금액*1개월) */
If Cal_CreditLimit <> 0 Then
	Cal_CreditRate = Cal_UseAmount / (Cal_CreditLimit)
	
//	If sCvcod = '11002' Then MessageBox(string(Cal_UseAmount) , string(Cal_CreditLimit))
Else
	Cal_CreditRate = 0
End If
dw_list.SetItem(nRow,'yusinrate',Cal_CreditRate)

/* 어음적수 = 어음금액*(만기일 - 입금일) */
select nvl(sum(a.bill_amt*(to_date(a.bman_dat,'yyyymmdd') - to_date(a.ipgum_date,'yyyymmdd'))),0)
  into :eum
  from sugum a, vndmst v
 where a.cvcod = v.cvcod and
       a.ipgum_cause = '1' and
		 a.ipgum_type  = '1' and
		 substr(a.ipgum_date,1,6) >= :s_fryymm and
		 substr(a.ipgum_date,1,6) <= :s_toyymm and
		 v.salescod = :sCvcod;

/* 분기 수금회전일 = 어음적수 / 수금액 */
sRow = dw_list.Find("cvcod = '" + sCvcod + "'",1,dw_list.RowCount())
If sRow <= 0  Then  Return Cal_CreditRate

sugum = dw_list.GetItemNumber(sRow,'sugum')
If sugum <> 0 Then  Cal_hoijunil = Truncate(eum / sugum,1)

dw_list.SetItem(nRow,'hoijunil',Cal_hoijunil)

Return Cal_CreditRate
end function

public function integer wf_retrieve ();string	syear,sgu, steam, sarea, tx_name, sCvcod
string   s_fr1,s_to1,s_fr2,s_to2
int      ix,iy,nRow,iord
dec      ord1,ord2
//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear  = trim(dw_ip.getitemstring(1, 'syear'))
sgu    = trim(dw_ip.getitemstring(1, 'gu'))
steam  = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea  = trim(dw_ip.getitemstring(1, 'areacode'))

If IsNull(steam) then steam = ''
If IsNull(sarea) then sarea = ''

IF	IsNull(syear) or syear = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

IF	IsNull(sgu) or sgu = '' then
	f_message_chk(1400,'[분기]')
	dw_ip.setcolumn('gu')
	dw_ip.setfocus()
	Return -1
END IF

Choose Case sgu
	Case '1'
		s_fr1 = syear + '01' ; s_to1 = syear + '03'
		s_fr2 = String(Long(syear)-1) + '01' ; s_to2 = String(Long(syear)-1) + '03'
	Case '2'
		s_fr1 = syear + '04' ; s_to1 = syear + '06'
		s_fr2 = String(Long(syear)-1) + '04' ; s_to2 = String(Long(syear)-1) + '06'
	Case '3'
		s_fr1 = syear + '07' ; s_to1 = syear + '09'
		s_fr2 = String(Long(syear)-1) + '07' ; s_to2 = String(Long(syear)-1) + '09'
	Case '4'
		s_fr1 = syear + '10' ; s_to1 = syear + '12'
		s_fr2 = String(Long(syear)-1) + '10' ; s_to2 = String(Long(syear)-1) + '12'
End Choose

////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

nRow = dw_list.retrieve(steam+'%',sarea+'%',sgu,s_fr1,s_to1,s_fr2,s_to2,ls_silgu)
if nRow < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('gu')
	dw_ip.setfocus()
	return -1
end if

/* 총순위로 정렬*/
dw_list.SetSort('total_order A')
dw_list.Sort()

/* 평가처리된 거래처만 조회 */
dw_list.SetFilter('total_order > 0')
dw_list.Filter()

/* 분기총회전일, 여신율 */
For ix = 1 To dw_list.Rowcount()
	sCvcod = dw_list.GetItemString(ix,'cvcod')
	
	wf_set_cvcod(ix,s_fr1, s_to1, sCvcod)
Next

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_sarea.text = '"+tx_name+"'")

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05920.create
call super::create
end on

on w_sal_05920.destroy
call super::destroy
end on

event open;call super::open;
dw_ip.SetItem(1,'syear',Left(f_today(),4))

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
dw_ip.SetItem(1, 'areacode', sarea)
dw_ip.SetItem(1, 'deptcode', steam)
end event

type p_preview from w_standard_print`p_preview within w_sal_05920
end type

type p_exit from w_standard_print`p_exit within w_sal_05920
end type

type p_print from w_standard_print`p_print within w_sal_05920
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05920
end type







type st_10 from w_standard_print`st_10 within w_sal_05920
end type



type dw_print from w_standard_print`dw_print within w_sal_05920
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05920
integer x = 37
integer y = 100
integer width = 745
integer height = 896
string dataobject = "d_sal_05920_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sNull, sIoCustArea, sDept

SetNull(snull)

Choose Case GetColumnName() 
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
	/* 관할구역 */
	Case "areacode"
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
			
		SetItem(1,'deptcode',sDept)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05920
integer x = 805
integer width = 2807
integer height = 2056
string dataobject = "d_sal_05920"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

