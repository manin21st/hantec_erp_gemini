$PBExportHeader$w_sal_05040.srw
$PBExportComments$�б��� ��� �� ó��
forward
global type w_sal_05040 from w_inherite
end type
type gb_3 from groupbox within w_sal_05040
end type
type gb_2 from groupbox within w_sal_05040
end type
type gb_1 from groupbox within w_sal_05040
end type
type dw_key from u_key_enter within w_sal_05040
end type
type dw_list from datawindow within w_sal_05040
end type
type dw_rate from datawindow within w_sal_05040
end type
type dw_std from datawindow within w_sal_05040
end type
end forward

global type w_sal_05040 from w_inherite
integer height = 2400
string title = "�б��� ��� �� ó��"
long backcolor = 80859087
event ue_open pbm_custom01
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_key dw_key
dw_list dw_list
dw_rate dw_rate
dw_std dw_std
end type
global w_sal_05040 w_sal_05040

type variables
string is_year,     is_gu

end variables

forward prototypes
public function integer wf_key_protect (boolean gb)
public function integer wf_key_check ()
public function integer wf_retrieve ()
public function string wf_skip_sisang (integer srow, string scvcod)
public function double wf_calc_rebate2 (string scvcod, integer subtract)
public function double wf_calc_rebate (string scvcod, integer subtract)
public function double wf_set_cvcod (integer nrow, string scvcod)
end prototypes

public function integer wf_key_protect (boolean gb);Choose Case gb
	Case True
		dw_key.Modify('base_year.protect = 1')
      dw_key.Modify("base_year.background.color = '"+String(Rgb(192,192,192))+"'") // gray
		dw_key.Modify('sisang_gu.protect = 1')
      dw_key.Modify("sisang_gu.background.color = '"+String(Rgb(192,192,192))+"'") // gray
	Case False
		dw_key.Modify('base_year.protect = 0')
      dw_key.Modify("base_year.background.color = '"+String(Rgb(190,225,184))+"'")	 // mint
		dw_key.Modify('sisang_gu.protect = 0')
      dw_key.Modify("sisang_gu.background.color = '"+String(Rgb(190,225,184))+"'")	 // mint
End Choose

Return 1
end function

public function integer wf_key_check ();int    nRow

dw_key.AcceptText()
nRow = dw_key.RowCount()
If nrow <= 0 Then Return -1

SetNull(is_year)
SetNull(is_gu)
is_year = dw_key.GetItemString(nRow,'base_year')
is_gu   = dw_key.GetItemString(nRow,'sisang_gu')

If IsNull(is_year) Or is_year = '' Then
   f_message_chk(1400,'[���س⵵]')
	dw_key.SetFocus()
	dw_key.SetColumn('base_year')
	Return -1
End If

If IsNull(is_gu) Then
   f_message_chk(1400,'[�бⱸ��]')
	dw_key.SetFocus()
	dw_key.SetColumn('sisang_gu')
	Return -1
End If

Return 1
end function

public function integer wf_retrieve ();string	syear,sgu
string   s_fr1,s_to1,s_fr2,s_to2
int      ix,iy,nRow,iord
dec      ord1,ord2
//////////////////////////////////////////////////////////////////
If dw_key.accepttext() <> 1 Then Return -1

syear  = is_year
sgu    = is_gu

IF	IsNull(syear) or syear = '' then
	f_message_chk(1400,'[���س⵵]')
	dw_key.setcolumn('syear')
	dw_key.setfocus()
	Return -1
END IF

IF	IsNull(sgu) or sgu = '' then
	f_message_chk(1400,'[�б�]')
	dw_key.setcolumn('gu')
	dw_key.setfocus()
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

nRow = dw_list.retrieve('%','%',sgu,s_fr1,s_to1,s_fr2,s_to2)
if nRow < 1	then
	f_message_chk(50,"")
	dw_key.setcolumn('sisang_gu')
	dw_key.setfocus()
	return -1
end if

// ���� clear
For ix = 1 To nRow
  dw_list.SetItem(ix,'maechul_order',1)
  dw_list.SetItem(ix,'sinjang_order',1)
  dw_list.SetItem(ix,'sugum_order',1)
  dw_list.SetItem(ix,'total_order',1)
Next

// ���� ���
For ix = 1 To ( nRow - 1 )
	For iy = ix + 1 To nRow
       ord1 = dw_list.GetItemNumber(ix,'maechul')
       ord2 = dw_list.GetItemNumber(iy,'maechul')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'maechul_order')
				iord += 1
				dw_list.SetItem(iy,'maechul_order',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'maechul_order')
				iord += 1
				dw_list.SetItem(ix,'maechul_order',iord)
		End Choose

       ord1 = dw_list.GetItemNumber(ix,'sinjangrate')
       ord2 = dw_list.GetItemNumber(iy,'sinjangrate')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'sinjang_order')
				iord += 1
				dw_list.SetItem(iy,'sinjang_order',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'sinjang_order')
				iord += 1
				dw_list.SetItem(ix,'sinjang_order',iord)
		End Choose

       ord1 = dw_list.GetItemNumber(ix,'maesugum')
       ord2 = dw_list.GetItemNumber(iy,'maesugum')
		 
		 Choose Case ( ord1 - ord2 )
			Case is > 0
				iord = dw_list.GetItemNumber(iy,'sugum_order')
				iord += 1
				dw_list.SetItem(iy,'sugum_order',iord)
			Case is < 0
				iord = dw_list.GetItemNumber(ix,'sugum_order')
				iord += 1
				dw_list.SetItem(ix,'sugum_order',iord)
		End Choose


   Next
Next

// Total rank
dw_list.SetSort('sum_order ,sinjangrate D,maechul,maesugum ')
dw_list.Sort()
For ix = 1 To nRow
	dw_list.SetItem(ix,'total_order',ix)
Next

dw_list.SetRedraw(True)
Return 1
end function

public function string wf_skip_sisang (integer srow, string scvcod);string sSisang_No_gu
string s_fryymm,s_toyymm
long   nRow,Rcnt,ix
dec    sinjangrate,sugumrate,hoijunil,yosinrate
double maechul,sugum,eum,dStdData

SetNull(sSisang_No_gu)

Rcnt = dw_list.RowCount()
If Rcnt <= 0 Then Return sSisang_No_gu

/* �򰡴�� Ȯ�� */
nRow = dw_list.Find("cvcod = '" + sCvcod + "'",1,Rcnt)
If nRow <= 0  Then Return sSisang_No_gu

s_fryymm = dw_key.GetItemString(1,'fr_yymm')
s_toyymm = dw_key.GetItemString(1,'to_yymm')

/* ȯ�漳���� ��ϵ� ������ �������� �û����ܿ��θ� �Ǵ� */
For ix = 1 To dw_std.RowCount()
	dStdData = Double(dw_std.GetItemString(ix,'dataname'))
	If IsNull(dStdData) Then dStdData = 0
	
	Choose Case Trim(dw_std.GetItemString(ix,'lineno'))
		Case '10'    /* �����(�̻�) */
         maechul = dw_list.GetItemNumber(nRow,'maechul')
         If maechul < dStdData Then Return '7'
		Case '11'    /* �������ѵ�(�̸�) */
			yosinrate = dw_insert.GetItemNumber(sRow,'yusinrate') * 100
		
         If yosinrate >= dStdData Then Return '1'
		Case '12'    /* ����ȸ����(����) */
	        hoijunil = dw_insert.GetItemNumber(sRow,'hoijunil')
           If hoijunil > dStdData Then Return '2'

		Case '13'    /* �ŷ�ó�б������(�̻�) */
			sugumrate = dw_list.GetItemNumber(nRow,'sugumrate')
         If sugumrate < (dStdData/100) Then Return '4'
		Case '14'    /* �û�������ѵ��� */
			/* => wf_calc_rebate()���� ���� ó���� */
		Case Else
//			f_message_chk(163,'[�븮�� �û����� �ڵ� :' + dw_std.GetItemString(ix,'datagu') + ']')
	End Choose
Next

Return sSisang_No_gu
end function

public function double wf_calc_rebate2 (string scvcod, integer subtract);/* �ŷ�ó �û�� ��� */
/* subtract : ������ ���� */
/* ����� 2000/04/12 DW_INSERT �� ��������� ���� �߰�*/
long nRow,total_rank
double maechul,sisang_amt, dMaxAmt
String sValue
dec    rate

nRow = dw_insert.Find("cvcod = '" + sCvcod + "'",1,dw_insert.RowCount())
If nRow <= 0 Then Return 0
	  
maechul    = dw_insert.GetItemNumber(nRow,'maechul')
total_rank = dw_insert.GetItemNumber(nRow,'total_rank') + subtract

nRow = dw_rate.Find("bungi_rank = " + string(total_rank),1,dw_rate.RowCount())
If nRow > 0 Then
  rate = dw_rate.GetItemNumber(nRow,'sisang_rate')
  sisang_amt = maechul * ( rate / 100 )
Else
  sisang_amt = 0.0
End If

/* �û���ѵ� */
select dataname into :sValue
  from syscnfg
 where sysgu = 'S' and
       serial = 4 and
       lineno = 14;

If IsNumber(sValue) Then 
	dMaxAmt = Double(sValue)
Else
	dMaxamt = 2000000
End If

If sisang_amt > dMaxAmt Then	sisang_amt = dMaxAmt
	
Return sisang_amt

end function

public function double wf_calc_rebate (string scvcod, integer subtract);/* �ŷ�ó �û�� ��� */
/* subtract : ������ ���� */

long nRow,total_rank
double maechul,sisang_amt, dMaxAmt
String sValue
dec    rate

nRow = dw_list.Find("cvcod = '" + sCvcod + "'",1,dw_list.RowCount())
If nRow <= 0 Then Return 0
	  
maechul    = dw_list.GetItemNumber(nRow,'maechul')
total_rank = dw_list.GetItemNumber(nRow,'total_order') + subtract

nRow = dw_rate.Find("bungi_rank = " + string(total_rank),1,dw_rate.RowCount())
If nRow > 0 Then
  rate = dw_rate.GetItemNumber(nRow,'sisang_rate')
  sisang_amt = maechul * ( rate / 100 )
Else
  sisang_amt = 0.0
End If

/* �û���ѵ� */
select dataname into :sValue
  from syscnfg
 where sysgu = 'S' and
       serial = 4 and
       lineno = 14;

If IsNumber(sValue) Then 
	dMaxAmt = Double(sValue)
Else
	dMaxamt = 2000000
End If

If sisang_amt > dMaxAmt Then	sisang_amt = dMaxAmt
	
Return sisang_amt

end function

public function double wf_set_cvcod (integer nrow, string scvcod);/********************************************************************************/
/* �ŷ�ó�� ���� �� ���űݾ�/�������� �����Ѵ�.	(�б�)								  */
/* argument : �����ڵ�(I),�ŷ�ó(I),�б���۳��(I),�бⳡ���(I),��������(I)   */
/* return   : dec (������)       									  				        */
/********************************************************************************/
dec {2} Cal_dBMiSuGum,	Cal_dDPanMaeGum,	Cal_dOrdCntAmt	
dec     Cal_dBillJaga,	Cal_dBillTasuN,	Cal_dBillTasuY
dec  	  Cal_UseAmount,	Cal_dBillBudo,    Cal_dSugum
dec     Cal_CreditLimit,Cal_CreditRate,   Cal_SinJangRate
Double  eum,sugum, Cal_hoijunil,          Cal_Dambo
Long    sRow

String s_fryymm,s_toyymm, sCurDate, sDate

s_fryymm = dw_key.GetItemString(1,'fr_yymm')
s_toyymm = dw_key.GetItemString(1,'to_yymm')
sCurDate = f_last_date(s_toyymm)

/*���� �̼���*/
SELECT SUM("VNDJAN"."IWOL_CREDIT_AMT") 
  INTO :Cal_dBMiSuGum
  FROM "VNDJAN", "VNDMST"
 WHERE ( "VNDJAN"."CVCOD" = "VNDMST"."CVCOD") AND
       ( "VNDJAN"."SABU" = :gs_sabu ) AND  
       ( "VNDJAN"."BASE_YYMM" = :s_toyymm ) AND  
       ( "VNDMST"."SALESCOD" = :sCvcod ) AND
		 ( "VNDJAN"."SILGU" = (select substr(dataname,1,1) from syscnfg 
                               where sysgu = 'S' and
                                     serial = 8 and
                                     lineno = '40' ));


IF IsNull(Cal_dBMiSuGum) THEN
	Cal_dBMiSuGum =0
END IF

/*�б����, �Ǹűݾ� */
SELECT SUM(NVL("VNDJAN"."SUGUM_BILL",0) + NVL("VNDJAN"."SUGUM_SAVE",0) +
               NVL("VNDJAN"."SUGUM_CASH",0) + NVL("VNDJAN"."SUGUM_GITA",0)),
		 SUM("VNDJAN"."MAECHUL_AMT")
  INTO :Cal_dSuGum, :Cal_dDPanMaeGum
  FROM "VNDJAN"  ,"VNDMST"
 WHERE ( "VNDJAN"."CVCOD" = "VNDMST"."CVCOD") AND
       ( "VNDJAN"."SABU" = :gs_sabu ) AND  
       ( "VNDJAN"."BASE_YYMM" = :s_toyymm ) AND  
       ( "VNDMST"."SALESCOD" = :sCvcod ) AND
		 ( "VNDJAN"."SILGU" = (select substr(dataname,1,1) from syscnfg 
                               where sysgu = 'S' and
                                     serial = 8 and
                                     lineno = '40' ));

IF IsNull(Cal_dSuGum) THEN
	Cal_dSuGum =0
END IF

IF IsNull(Cal_dDPanMaeGum) THEN
	Cal_dDPanMaeGum =0
END IF

dw_insert.SetItem(nRow,'bmaechul',Cal_dDPanMaeGum)

/* ��ó���ݾ� */
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
				 
/*�ڰ����� ���� �̵��� ����*/
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

/*Ÿ������ ���� �̵�������*/
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

/*Ÿ������ ���� �̵�������(�������)*/
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

/*�ε����� �ܾ�*/
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

/*�ŷ�ó �㺸�ݾ� �� �����ŷ�ó */
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
dw_insert.SetItem(nRow,'dambo',Cal_Dambo)

//MessageBox(string(cal_useamount),string(cal_creditlimit))

/* �������� */
select sdate into :sDate  from vndmst
 where salescod = :sCVcod;
If sqlca.sqlcode <> 0 Then SetNull(sDate )
dw_insert.SetItem(nRow,'vndmst_sdate',sDate)

/* ������ = ���űݾ�/(�ſ��ѵ��ݾ�*1����) */
If Cal_CreditLimit <> 0 Then
	Cal_CreditRate = Cal_UseAmount / (Cal_CreditLimit)
Else
	Cal_CreditRate = 0
End If
dw_insert.SetItem(nRow,'yusinrate',Cal_CreditRate)

/* �������� = �����ݾ�*(������ - �Ա���) */
select nvl(sum(a.bill_amt*(to_date(a.bman_dat,'yyyymmdd') - to_date(a.ipgum_date,'yyyymmdd'))),0)
  into :eum
  from sugum a, vndmst v
 where a.cvcod = v.cvcod and
       a.ipgum_cause = '1' and
		 a.ipgum_type  = '1' and
		 substr(a.ipgum_date,1,6) >= :s_fryymm and
		 substr(a.ipgum_date,1,6) <= :s_toyymm and
		 v.salescod = :sCvcod;

/* �б� ����ȸ���� = �������� / ���ݾ� */
sRow = dw_list.Find("cvcod = '" + sCvcod + "'",1,dw_list.RowCount())
If sRow <= 0  Then  Return Cal_CreditRate

sugum = dw_list.GetItemNumber(sRow,'sugum')
If sugum <> 0 Then  Cal_hoijunil = Truncate(eum / sugum,1)

dw_insert.SetItem(nRow,'hoijunil',Cal_hoijunil)

/* ������ */
Cal_SinJangRate = dw_list.GetItemNumber(sRow,'sinjangrate')
dw_insert.SetItem(nRow,'srate',Cal_SinJangRate)

Return Cal_CreditRate
end function

on w_sal_05040.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_key=create dw_key
this.dw_list=create dw_list
this.dw_rate=create dw_rate
this.dw_std=create dw_std
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_key
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.dw_rate
this.Control[iCurrent+7]=this.dw_std
end on

on w_sal_05040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_key)
destroy(this.dw_list)
destroy(this.dw_rate)
destroy(this.dw_std)
end on

event open;call super::open;string syear

dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

/* ��ó�� ����Ÿ������ */
dw_list.SetTransObject(sqlca)

/* �û��� ����Ÿ������ */
dw_rate.SetTransObject(sqlca)

/* �򰡱��� ����Ÿ������ */
dw_std.SetTransObject(sqlca)

cb_can.Post PostEvent(Clicked!)

ib_any_typing =  FAlse

end event

type dw_insert from w_inherite`dw_insert within w_sal_05040
integer x = 110
integer y = 316
integer width = 3429
integer height = 1500
integer taborder = 20
boolean titlebar = true
string title = "�ŷ�ó �� �û� ����"
string dataobject = "d_sal_05040"
boolean maxbox = true
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::editchanged;call super::editchanged;ib_any_typing =True
end event

event dw_insert::itemchanged;int    nRow,subtract
String sCvcod,cvcodnm,sNoGu, sNull
double sisang_amt

If row <=0 Then Return

SetNull(sNull)

Choose Case GetColumnName()
	Case 'rank_minus'
	  subtract = Long(GetText())              /* ������ ���� */
	  If IsNull(subtract) Then subtract = 0
	  
	  sCvcod     = GetItemString(row,'cvcod')
	  sisang_amt = wf_calc_rebate(sCvcod,subtract)

	  This.SetItem(Row,'sisang_amt',sisang_amt)
/* --------------------------------------------------- */
	Case 'sisang_no_gu'
		sNoGu   = Trim(GetText())
		/* �û��� ���Խ�ų ��� */
		If sNogu = '' Or IsNull(sNogu) Then 
			sCvcod     = GetItemString(row,'cvcod')
			
			sisang_amt = wf_calc_rebate(sCvcod,0)
			
			SetItem(Row,'sisang_yn',sNull)
			SetItem(Row,'sisang_amt',sisang_amt)
			Return
		End If	
		
		/* �û��� ���ܽ�ų ��� */		
		cvcodnm = Trim(This.GetItemstring(row,'cvcodnm'))			
		IF MessageBox("�û�����",cvcodnm + "��(��) �û󿡼� ���ܵ˴ϴ�." +"~n~n" +&
							"���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN 2
		
		SetItem(nRow,'sisang_yn','N')
		SetItem(Row,'sisang_amt',0)
/* --------------------------------------------------- */
	Case 'minus_cause_gu'
		If dw_list.RowCount() <=0 Then Return 2
End Choose
end event

event dw_insert::itemerror;return 1
end event

type cb_exit from w_inherite`cb_exit within w_sal_05040
integer x = 3159
integer y = 1896
end type

type cb_mod from w_inherite`cb_mod within w_sal_05040
integer x = 2103
integer y = 1896
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;If IsNull(is_year) Or IsNull(is_gu) Then
   f_message_chk(1400,'')
	dw_key.SetFocus()
	dw_key.SetColumn('base_year')
	Return -1
End If

If dw_insert.Update() = 1 then
	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_ins from w_inherite`cb_ins within w_sal_05040
boolean visible = false
integer x = 18
integer y = 2264
integer width = 142
integer height = 148
integer taborder = 0
boolean enabled = false
string text = ""
end type

type cb_del from w_inherite`cb_del within w_sal_05040
integer x = 2455
integer y = 1896
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;int    row,rank,rcnt

rcnt = dw_insert.RowCount()

If rcnt > 0 Then
   IF MessageBox("�� ��","�ŷ�ó �򰡳��� ��ü�� �����˴ϴ�." +"~n~n" +&
                     	 "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If dw_insert.RowsMove(1,rcnt,Primary!,dw_insert,1,Delete!)  = 1 Then
		If dw_insert.Update() = 1 Then
		   commit;
		   sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
	   Else
		   Rollback ;
	   End If		
	End If	
   dw_insert.Retrieve(gs_sabu,is_year,is_gu)
End If

end event

type cb_inq from w_inherite`cb_inq within w_sal_05040
integer x = 658
integer y = 1896
integer width = 498
string text = "��ó��(&G)"
end type

event cb_inq::clicked;call super::clicked;/* ----------------------------------------------------- */
/* �ŷ�ó �б��� ó��                                  */
/* dw_insert : ��ó�� ���� (vndsisang)                 */
/* dw_list   : ������ݽ��� ���� (vndjan)                */
/* dw_rate   : �û��� (png_vnd_q_gi)                     */
/* ----------------------------------------------------- */
int     rcnt,row,ix,nRow,nCnt
long    lcount
dec     rate,total_rank
double  sisang_amt,maechul
string  sCvcod,sSisang_No_gu, sCvcodNm

If wf_key_check() = -1 Then Return                // key check

/* �û��� */
rcnt = dw_rate.Retrieve(gs_sabu,is_year,is_gu)
If rcnt <= 0 Then
	f_message_chk(57,'[�û��� ���]')
	Return
End If

/* �򰡱��� */
rcnt = dw_std.Retrieve()
If rcnt <= 0 Then
	f_message_chk(57,'[�򰡱��� ���]')
	Return
End If

SetPointer(HourGlass!)

/* ���� �򰡳��� ��ȸ */
rcnt = dw_insert.Retrieve(gs_sabu,is_year,is_gu)

/* ������ݽ��� ���� */
If wf_retrieve() = -1 Then Return

If rcnt > 0 Then
   IF MessageBox("��ó��","������ ��ó���� ������ �����մϴ�." +"~n~n" +&
                     	 "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN 
      RETURN
	Else

		delete from vndsisang
		 where sabu = :gs_sabu and
		       base_year = :is_year and
				 sisang_gu = :is_gu;
				 
		If sqlca.sqlcode = 0 then
			ib_any_typing = false
			commit ;
		else
			rollback ;
			sle_msg.text =	"�ڷ������ �����Ͽ����ϴ�!!"
			return 
		end if
		
		dw_insert.Reset()
	End If
End If

/* �򰡳��� ó�� */
For ix = 1 To dw_list.RowCount()
	nRow = dw_insert.InsertRow(0)
   sCvcod = dw_list.GetItemString(ix,'cvcod')
	
	dw_insert.SetItem(nRow,'sabu',     gs_sabu)
	dw_insert.SetItem(nRow,'base_year',is_year)
	dw_insert.SetItem(nRow,'sisang_gu',is_gu)
	dw_insert.SetItem(nRow,'cvcod',    sCvcod)
	dw_insert.SetItem(nRow,'cvcodnm',   dw_list.GetItemString(ix,'cvcodnm'))
	dw_insert.SetItem(nRow,'sales_rank',dw_list.GetItemNumber(ix,'maechul_order'))
	dw_insert.SetItem(nRow,'sungj_rank',dw_list.GetItemNumber(ix,'sinjang_order'))
	dw_insert.SetItem(nRow,'sugum_rank',dw_list.GetItemNumber(ix,'sugum_order'))
	dw_insert.SetItem(nRow,'maechul',dw_list.GetItemNumber(ix,'maechul'))
	dw_insert.SetItem(nRow,'pmaechul',dw_list.GetItemNumber(ix,'pmaechul'))
	total_rank = dw_list.GetItemNumber(ix,'total_order')
	dw_insert.SetItem(nRow,'total_rank', total_rank)

   wf_set_cvcod(nRow, sCvcod) /* �ŷ�ó ���� */
	
   /* �û����� ���� */
   sSisang_No_gu = wf_skip_sisang(nRow, sCvcod)
   If Not IsNull(sSisang_No_gu) then        
     dw_insert.SetItem(nRow,'sisang_amt',0)
	  dw_insert.SetItem(nRow,'sisang_no_gu',sSisang_No_gu)
	  continue
   End If
Next

/* Ư������ �ŷ�ó �� ���� */
nCnt = dw_list.RowCount()
For ix = nCnt To 1 Step -1
	sSisang_No_gu = dw_insert.GetItemString(ix,'sisang_no_gu')
	If sSisang_No_gu = '6' or sSisang_No_gu = '7' Then
		dw_insert.DeleteRow(ix)
		continue
	End If
	
	/* �ŷ�ó���� ��Ÿ�� ���ԵǸ� ���� */
	sCvcodNm = Trim(dw_insert.GetItemString(ix,'cvcodnm'))
	If Pos(sCvcodNm,'��Ÿ') > 0 Then
		dw_insert.DeleteRow(ix)
		continue
	End If
Next

lCount = dw_insert.RowCount()

/* ���� ������ */
If lCount > 0 Then
	dw_insert.SetSort('sales_rank')
	dw_insert.Sort()

	For ix = 1 To lCount
		dw_insert.SetItem(ix,'sales_rank',ix)
	Next
	
	dw_insert.SetSort('sungj_rank')
	dw_insert.Sort()
	For ix = 1 To lCount
		dw_insert.SetItem(ix,'sungj_rank',ix)
	Next
	
	dw_insert.SetSort('sugum_rank')
	dw_insert.Sort()
	For ix = 1 To lCount
		dw_insert.SetItem(ix,'sugum_rank',ix)
	Next
	
	//	dw_insert.SetSort('total_rank')
	// ����� 2000.04.12
   dw_insert.SetSort('sum_order A, sinjangrate D, maechul A')
	dw_insert.Sort()
	For ix = 1 To lCount
		dw_insert.SetItem(ix,'total_rank',ix)
	Next

	/* �򰡳��� ó�� */
	For ix = 1 To lCount
		sCvcod = dw_insert.GetItemString(ix,'cvcod')
		
		/* �û�� ��� */
		sisang_amt = wf_calc_rebate2(sCvcod,0)
	
		dw_insert.SetItem(ix,'sisang_amt',sisang_amt)
	Next
	

Else
   sle_msg.Text = 'ó���� �Ǽ��� �����ϴ�.!!'
End If

wf_key_protect(true)

end event

type cb_print from w_inherite`cb_print within w_sal_05040
boolean visible = false
integer x = 2903
integer y = 2532
integer taborder = 0
end type

type st_1 from w_inherite`st_1 within w_sal_05040
end type

type cb_can from w_inherite`cb_can within w_sal_05040
integer x = 2807
integer y = 1896
integer taborder = 70
end type

event cb_can::clicked;call super::clicked;string syear
int row

dw_list.Reset()

dw_key.Reset()
row = dw_key.InsertRow(0)
syear = Left(f_today(),4)
dw_key.SetItem(row,'base_year',syear)

wf_key_protect(false)

dw_key.SetFocus()
dw_key.SetRow(row)
dw_key.SetColumn('base_year')

dw_insert.Reset()

SetNull(is_year)
SetNull(is_gu)

ib_any_typing = false

end event

type cb_search from w_inherite`cb_search within w_sal_05040
integer x = 165
integer y = 1896
integer taborder = 30
end type

event cb_search::clicked;call super::clicked;/* ----------------------------------------------------- */
/* ���� ��ó�� ���� ��ȸ                               */
/* ----------------------------------------------------- */
Long   rcnt, ix

If wf_key_check() = -1 Then Return                // key check

/* ���� �򰡳��� ��ȸ */
rcnt = dw_insert.Retrieve(gs_sabu,is_year,is_gu)

If rcnt <=0 Then
   sle_msg.Text = 'ó���� �Ǽ��� �����ϴ�.!!'
	Return
End If

/* �û��� */
rcnt = dw_rate.Retrieve(gs_sabu,is_year,is_gu)
If rcnt <= 0 Then
	f_message_chk(57,'[�û��� ���]')
	Return
End If

SetPointer(HourGlass!)

/* ������ݽ��� ���� */
If wf_retrieve() = -1 Then Return

/* �ŷ�ó ���� */
For ix = 1 To dw_list.RowCount()
   wf_set_cvcod(ix, dw_list.GetItemString(ix,'cvcod'))
Next

wf_key_protect(true)

end event







type gb_3 from groupbox within w_sal_05040
integer x = 2053
integer y = 1824
integer width = 1481
integer height = 236
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_sal_05040
integer x = 110
integer y = 1824
integer width = 1115
integer height = 236
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_sal_05040
integer x = 119
integer width = 1312
integer height = 296
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_key from u_key_enter within w_sal_05040
integer x = 183
integer y = 72
integer width = 1225
integer height = 196
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_05040_key"
boolean border = false
end type

event itemchanged;string s_fr1,s_to1,syear

Choose Case GetColumnName()
	Case 'base_year'
//		cb_search.TriggerEvent(Clicked!)      // ��ȸ
	Case 'sisang_gu'
	  syear = GetItemString(row,'base_year')
	  If syear = '' Or IsNull(syear) Then Return 2
	  
     Choose Case Trim(data)
    	 Case '1'
		   s_fr1 = syear + '01' ; s_to1 = syear + '03'
	    Case '2'
		   s_fr1 = syear + '04' ; s_to1 = syear + '06'
	    Case '3'
		   s_fr1 = syear + '07' ; s_to1 = syear + '09'
	    Case '4'
		   s_fr1 = syear + '10' ; s_to1 = syear + '12'
     End Choose
	  
	  SetItem(row,'fr_yymm',s_fr1)
  	  SetItem(row,'to_yymm',s_to1)
		 
//	  cb_search.PostEvent(Clicked!)      // ��ȸ
End Choose
end event

event itemerror;return 1
end event

type dw_list from datawindow within w_sal_05040
boolean visible = false
integer x = 265
integer y = 2280
integer width = 763
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "�� ó��(d_sal_059201)"
string dataobject = "d_sal_059201"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_rate from datawindow within w_sal_05040
boolean visible = false
integer x = 1047
integer y = 2280
integer width = 763
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "�û���"
string dataobject = "d_sal_05050"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_std from datawindow within w_sal_05040
boolean visible = false
integer x = 1829
integer y = 2280
integer width = 763
integer height = 100
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "�򰡱���"
string dataobject = "d_sal_05040_std"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

