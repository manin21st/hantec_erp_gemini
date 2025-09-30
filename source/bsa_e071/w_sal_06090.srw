$PBExportHeader$w_sal_06090.srw
$PBExportComments$NEGO 등록
forward
global type w_sal_06090 from w_inherite
end type
type rb_new from radiobutton within w_sal_06090
end type
type rb_upd from radiobutton within w_sal_06090
end type
type tab_1 from tab within w_sal_06090
end type
type tabpage_1 from userobject within tab_1
end type
type rr_3 from roundrectangle within tabpage_1
end type
type dw_1 from u_key_enter within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_3 rr_3
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_4 from roundrectangle within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_4 rr_4
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type rr_5 from roundrectangle within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_5 rr_5
dw_3 dw_3
end type
type tab_1 from tab within w_sal_06090
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_key from datawindow within w_sal_06090
end type
type cb_ban from commandbutton within w_sal_06090
end type
type pb_1 from u_pb_cal within w_sal_06090
end type
type pb_2 from u_pb_cal within w_sal_06090
end type
type rr_1 from roundrectangle within w_sal_06090
end type
type rr_2 from roundrectangle within w_sal_06090
end type
end forward

global type w_sal_06090 from w_inherite
string title = "NEGO 등록"
rb_new rb_new
rb_upd rb_upd
tab_1 tab_1
dw_key dw_key
cb_ban cb_ban
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_06090 w_sal_06090

type variables
String sRfgub
end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_select_lcno (integer row, string lcno)
public function integer wf_update_pi_ngamt (string pino, decimal ngamt, string op)
public function string wf_get_junpyo_no (string sngdt, string sordgbn)
public function string wf_select_pino (integer row, string arg_pino)
public function string wf_find_hsno ()
public function string wf_get_pono (string sPino)
public function double wf_calc_sunsuamt ()
public function double wf_get_piamt (string arg_cino, string arg_pino)
public function integer wf_check_interface (string sngno)
public function double wf_get_ngamt (string sngno, string scino, string spino)
public function integer wf_set_piamt (integer nrow, string arg_ngno, string arg_cino, string arg_pino)
public function integer wf_setting_cipi (integer nrow, string scino)
public function integer wf_update_fob ()
public function integer wf_update_interface (string arg_ngno)
public function integer wf_nego_charge (string sngno, string srfgub1)
public function integer wf_check_detail ()
public function integer wf_calc_curr (integer nrow, string sdate, string scurr)
public subroutine wf_protect_key (boolean gb)
end prototypes

public subroutine wf_init ();rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)      // 신규입력받을 수 있도록 상태 변환

cb_inq.Enabled  = True
cb_ins.Enabled  = True
cb_mod.Enabled  = True
cb_search.Enabled  = True
cb_del.Enabled  = True

dw_key.SetFocus()
dw_key.SetColumn('ngdt')
ib_any_typing = False

/* 자사코드 */
select rtrim(rfgub) into :srfgub
  from reffpf
 where rfcod = '64' and
       rfna2 = 'NEGO';
If IsNull(sRfgub) Or sRfgub = '' Then
	MessageBox('확 인','Nego비용코드가 지정되지 않았습니다.!!~n~n참조코드[64]에서 지정하시기 바랍니다.')
End If
end subroutine

public function integer wf_select_lcno (integer row, string lcno);string s_lcno,s_cvcodnm,s_banklcno,s_curr,s_cvcod
dec    lcamt
  
  SELECT "EXPLC"."EXPLCNO",   
         "EXPLC"."BANKLCNO",   
         "EXPLC"."LCAMT",
		   "EXPLC"."CVCOD",
         FUN_GET_CVNAS("EXPLC"."CVCOD" ) AS CVCODNM ,
         "EXPLC"."CURR"
	  INTO :s_lcno, :s_banklcno ,:lcamt,:s_cvcod, :s_cvcodnm, :s_curr
    FROM "EXPLC"  
   WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
         ( "EXPLC"."EXPLCNO" = :lcno )   ;

dw_key.SetItem(row,'explcno', s_lcno)
dw_key.SetItem(row,'banklcno',s_banklcno)
dw_key.SetItem(row,'cvcod',   s_cvcod)
dw_key.SetItem(row,'cvcodnm', s_cvcodnm)
dw_key.SetItem(row,'lcamt',   lcamt)
If Not IsNull(s_curr) Then dw_key.SetItem(row,'curr',    s_curr)

If Len(Trim(s_lcno)) <= 0 Or IsNull(s_lcno) Then    Return 1

Return 0

end function

public function integer wf_update_pi_ngamt (string pino, decimal ngamt, string op);// nego amt를 pi header에 update
If pino = '' Or IsNull(pino) Then Return 1

If ngamt = 0 Then Return 1

If op = '-' Then ngamt = ngamt * -1          // 삭제된 경우는 빼준다

UPDATE EXPPIH  
   SET NGAMT = nvl(ngamt,0) + :ngamt
 WHERE ( SABU = :gs_sabu ) AND  
       ( PINO = :pino )   ;

If sqlca.sqlcode = 0 Then
	Return  1
Else
   f_message_chk(32,'[P/I 저장]')
	Return -1
End If	
end function

public function string wf_get_junpyo_no (string sngdt, string sordgbn);String  sOrderNo
string  sMaxOrderNo

sMaxOrderNo = String(sqlca.fun_junpyo(gs_sabu,sngdt,sOrdGbn),'000')

IF Double(sMaxOrderNo) <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = sNgdt + sMaxOrderNo

COMMIT;

Return sOrderNo
end function

public function string wf_select_pino (integer row, string arg_pino);//-----------------------------------------------------------//
// ci detail에 pino가 존재하는지 확인                        //
//-----------------------------------------------------------//
String sCino

SetNull(sCino)

SELECT  DISTINCT CINO
  INTO :sCino
  FROM "EXPCID"  
 WHERE ( "EXPCID"."SABU" = :gs_sabu ) AND  
       ( "EXPCID"."PINO" = :arg_pino );
		 
If sqlca.sqlnrows > 1 Then sCino = ''

If IsNull(sCino) Or Trim(sCino) = '' then Return sCino

Return sCino

end function

public function string wf_find_hsno ();/* ------------------------------------------------------------------ */
/* Invoice 내역에 등록된 Pi중에서 첫번째 HS 번호를 반환한다           */
/* ------------------------------------------------------------------ */
String sCino,sPino, sHsNo
Long   ix, Lrow

/* HS number를 가져오기 위한 커서 */
			
datastore ds
ds = create datastore
ds.dataobject = "d_sal_06090_ds"
ds.settransobject(sqlca)

For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
  SetNull(sHsNo)
  sCino = tab_1.tabpage_1.dw_1.GetItemString(ix,'cino')
  sPino = tab_1.tabpage_1.dw_1.GetItemString(ix,'pino')
  /* 매출이 일어난 것중에서 처리 */
  If IsNull(sCino) or sCino = '' Then continue
  If IsNull(sPino) or sPino = '' Then continue
  
  ds.retrieve(gs_sabu, scino, spino)
  For Lrow = 1 to ds.rowcount()
	   shsno = ds.getitemstring(Lrow, "hsno")	 
  NExt
  
  If Not IsNull(sHsNo) and Len(sHsNo) > 0 Then Exit
Next

destroy ds

Return sHsNo
end function

public function string wf_get_pono (string sPino);/* 해당 PI에 대한 발주번호를 가져온다 */
String sPono

SELECT PONO INTO :sPono
  FROM EXPPIH
 WHERE PINO = :sPino;

If sqlca.sqlcode <> 0 Then	sPono = ''

Return sPono
end function

public function double wf_calc_sunsuamt ();/* 선수금액 */
Double dSunsuAmt, dNgAmtH, dNgAmtD, dNgAmtF
Long   ix

dNgAmtH = dw_key.GetItemNumber(1,'ngamt')
If IsNull(dNgAmtH) Then dNgAmtH = 0

/* Nego등록시 작성된 내역 */
If tab_1.tabpage_1.dw_1.Rowcount() > 0 Then
  dNgAmtD = tab_1.tabpage_1.dw_1.GetItemNumber(1,'sum_ngamt_all')
	If IsNull(dNgAmtD) Then dNgAmtD = 0
Else
	dNgAmtD = 0
End If

/* 매출확정시 작성된 내역 */
dNgAmtF = 0
For ix = 1 To tab_1.tabpage_1.dw_1.FilteredCount () 
  dNgAmtF += tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt',Filter!,False)
Next

dSunsuAmt = TrunCate( dNgAmtH - dNgAmtD - dNgAmtF + 0.001 ,2)

If dSunsuAmt < 0 Then dSunsuAmt = 0

dw_key.SetItem(1,'sunsuamt',dSunsuamt)

Return dSunsuAmt


end function

public function double wf_get_piamt (string arg_cino, string arg_pino);/* ------------------------------------------------------------------ */
/* Invoice 금액 가져옴                                                */
/*  - PI 만 입력 : 해당 pi 품목들의 합                                */
/*  - CI    입력 : 해당 pi 품목들의 합  + Charge 금액                 */
/* ------------------------------------------------------------------ */
Double dPiamt,dChargeAmt

/* Pi 금액만 가져올 경우 */
If IsNull(arg_cino) or Trim(arg_cino) = '' Then 
  SELECT NVL(SUM(NVL("EXPPID"."PIAMT",0)),0)
    INTO :dPiamt  
    FROM "EXPPID"  
   WHERE ( "EXPPID"."SABU" = :gs_sabu ) AND  
         ( "EXPPID"."PINO" = :arg_pino );
Else
	SELECT NVL(SUM(NVL(CIAMT,0)),0)
	  INTO :dPiamt
	  FROM EXPCID
	 WHERE CINO = :arg_cino AND
	       PINO = :arg_pino ;
			 
	SELECT NVL(SUM(NVL(CHRAMT,0)),0)
	  INTO :dChargeAmt
	  FROM EXPCICH
	 WHERE CINO = :arg_cino AND
	       PINO = :arg_pino ;

   dPiamt += dChargeAmt
End If

Return dPiamt
end function

public function integer wf_check_interface (string sngno);Long nCnt

/* 회계시스템 이월 확인 */
SELECT COUNT(*)
  INTO :nCnt
  FROM "KIF08OT0"
 WHERE NGNO = :sNgno and
       BAL_DATE IS NOT NULL;

If nCnt > 0 Then
	sle_msg.Text = '회계전표 승인처리된 자료입니다.!!'
	cb_inq.Enabled    = False
	cb_ins.Enabled    = False
	cb_mod.Enabled    = False
	cb_search.Enabled = False
	cb_del.Enabled    = False
End If

Return nCnt
end function

public function double wf_get_ngamt (string sngno, string scino, string spino);/* CINO,PINO를 가지고 기존의 nego금액을 구한다 */
Double dNgamt

If IsNull(sCino ) or sCino = '' Then Return 0
If IsNull(sNgno ) or sNgno = '' Then 
	SELECT SUM(NGAMT) INTO :dNgamt
	  FROM EXPNEGOD
	 WHERE SABU = :gs_sabu AND
			 CINO = :sCino AND
			 PINO = :sPino;
Else
	SELECT SUM(NGAMT) INTO :dNgamt
	  FROM EXPNEGOD
	 WHERE SABU = :gs_sabu AND
			 CINO = :sCino AND
			 PINO = :sPino AND
			 NGNO <> :sNgno ;
End If
			
		 
If sqlca.sqlcode <> 0 Then dNgAmt = 0

If IsNull(dNgAmt) Then dNgamt = 0

Return dNgAmt
end function

public function integer wf_set_piamt (integer nrow, string arg_ngno, string arg_cino, string arg_pino);/* ------------------------------------------------------------------ */
/* Invoice 금액 가져옴                                                */
/*  - PI 만 입력 : 해당 pi 품목들의 합                                */
/*  - CI    입력 : 해당 pi 품목들의 합  + Charge 금액                 */
/* ------------------------------------------------------------------ */
Double dPiamt, wrate, urate, weigh, dNgamt

dPiamt = wf_get_piamt(arg_cino, arg_pino) /* 수출매출 금액 */
dNgAmt = wf_get_ngamt(arg_ngno, arg_cino, arg_pino) /* 기nego 금액 */

wrate = dw_key.GetitemNumber(1,'wrate')
urate = dw_key.GetitemNumber(1,'urate')
//환율은 매출시점의 환율을 가져온다
//SELECT WRATE, URATE INTO :wrate, :urate FROM EXPCIH WHERE SABU = :gs_sabu AND CINO = :arg_cino;

weigh = dw_key.GetitemNumber(1,'weight')
If IsNull(wrate) or wrate = 0 Then wrate =  1
If IsNull(urate) or urate = 0 Then urate =  1
If IsNull(weigh) or weigh = 0 Then weigh =  1

dNgAmt = dPiamt - dNgamt
tab_1.tabpage_1.dw_1.SetItem(nrow,'piamt', dPiamt)
tab_1.tabpage_1.dw_1.SetItem(nrow,'pijan', dNgAmt)
tab_1.tabpage_1.dw_1.SetItem(nrow,'ngamt', dNgAmt)
tab_1.tabpage_1.dw_1.SetItem(nRow,'wamt',  TrunCate(Round((dNgAmt * wrate)/weigh,2),0))
tab_1.tabpage_1.dw_1.SetItem(nRow,'uamt',  TrunCate(Round((dNgAmt * urate)/weigh,2),2))

tab_1.tabpage_1.dw_1.SetItem(nRow,'pono',  wf_get_pono(arg_Pino))

wf_calc_sunsuamt()

Return dPiamt
end function

public function integer wf_setting_cipi (integer nrow, string scino);/* ------------------------------------------------ */
/* ci,pi no를 setting                               */
/* ------------------------------------------------ */
Long   nMax,ix,itemp, Pos, nCnt, Lrow
string s_ngno,s_cino,s_pino, sBalDate, sExpno
Dec	 dUamt, dWamt, dFobamt, dFobamtw

datastore ds
ds = create datastore
ds.dataobject = "d_sal_06090_ds1"
ds.settransobject(sqlca)

// 최대 costseq 구함
nMax = 0
For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
	itemp = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngseq')
	nMax = Max(nMax,itemp)
Next

nCnt = 0
s_ngno = Trim(dw_key.GetItemString(dw_key.GetRow(),'ngno'))

Do
	Pos = Pos(sCino,'#')
	If Pos > 0 Then
		s_cino = Left(sCino,pos - 1)
		sCino = Mid(sCino,pos + 1)
	Else
		s_cino = sCino
		sCino = ''
	End If
	
	If IsNull(s_cino) or Trim(s_cino) = '' Then Exit
	
	ds.retrieve(gs_sabu, s_cino)
	For Lrow = 1 to ds.rowcount()
		sExpno = ds.getitemstring(Lrow, "expno")
		s_cino = ds.getitemstring(Lrow, "cino")
		s_pino = ds.getitemstring(Lrow, "pino")
		dUamt = ds.getitemnumber(Lrow, "uamt")
		dWamt = ds.getitemnumber(Lrow, "wamt")
		dFobamt = ds.getitemnumber(Lrow, "fobamt")
		dFobamtw = ds.getitemnumber(Lrow, "fobamtw")
		If IsNull(dUamt) Then dUAmt = 0
		If IsNull(dwamt) Then dwAmt = 0
		If IsNull(dFobamt) Then dFobAmt = 0
		If IsNull(dFobamtw) Then dFobAmtw = 0
		
		If nCnt > 0 Then
			nRow = tab_1.tabpage_1.dw_1.InsertRow(0)
			nMax = nMax + 1
			tab_1.tabpage_1.dw_1.SetItem(nRow,'sabu',gs_sabu)
			tab_1.tabpage_1.dw_1.SetItem(nRow,'ngno',s_ngno)
			tab_1.tabpage_1.dw_1.SetItem(nRow,'ngseq',nMax)
		End If
		
		nCnt += 1
		tab_1.tabpage_1.dw_1.SetItem(nRow,'expno', sExpno)
		tab_1.tabpage_1.dw_1.SetItem(nRow,'cino',  s_cino)
		tab_1.tabpage_1.dw_1.SetItem(nRow,'pino',  s_pino)
		
		tab_1.tabpage_1.dw_1.SetItem(nRow,'expcih_uamt',    dUamt)
		tab_1.tabpage_1.dw_1.SetItem(nRow,'expcih_wamt',    dWamt)
		tab_1.tabpage_1.dw_1.SetItem(nRow,'expcih_fobamt',  dFobamt)
		tab_1.tabpage_1.dw_1.SetItem(nRow,'expcih_fobamtw', dFobAmtw)
			
		/* Pi별 금액 setting */
		wf_set_piamt(nRow, s_ngno, s_cino,s_pino)
	Next
Loop While Len(sCino) > 1 and Trim(sCino) > ''

destroy ds

Return nCnt
end function

public function integer wf_update_fob ();Long nCnt, ix
Dec  dCiFob, dUamt, dCiamt, dFobAmt

If tab_1.tabpage_1.dw_1.AcceptText() <> 1 Then Return -1

nCnt = tab_1.tabpage_1.dw_1.RowCount()
If nCnt <= 0 Then Return 0

For ix = 1 To nCnt
	/* 미화 FOB 처리 */
	dCiFob = tab_1.tabpage_1.dw_1.GetItemNumber(ix, 'expcih_fobamt')	/* 미화 */
	dUamt  = tab_1.tabpage_1.dw_1.GetItemNumber(ix, 'uamt')				/* Nego */
	dCiAmt = tab_1.tabpage_1.dw_1.GetItemNumber(ix, 'expcih_uamt')		/* Ci */
	If IsNull(dCifob) Then dCiFob = 0
	If IsNull(dUamt)  Then dUamt = 0
	If IsNull(dCiamt) Or dCiamt = 0 Then Continue
	
	dFobAmt = Truncate(dCiFob * dUamt / dCiAmt,2)
	
	tab_1.tabpage_1.dw_1.SetItem(ix, 'fobamt', dFobAmt)

	/* 원화 FOB 처리 */	
	dCiFob = tab_1.tabpage_1.dw_1.GetItemNumber(ix, 'expcih_fobamtw')	/* 미화 */
	If IsNull(dCifob) Then dCiFob = 0
	
	dFobAmt = Truncate(dCiFob * dUamt / dCiAmt,2)
	
	tab_1.tabpage_1.dw_1.SetItem(ix, 'fobamtw', dFobAmt)
Next

dFobAmt = tab_1.tabpage_1.dw_1.GetItemNumber(1, 'fobamt_a')
If IsNull(dFobAmt) Then dFobAmt = 0
dw_key.SetItem(1, 'fobamt', dFobAmt)

dFobAmt = tab_1.tabpage_1.dw_1.GetItemNumber(1, 'fobamtw_a')
If IsNull(dFobAmt) Then dFobAmt = 0
dw_key.SetItem(1, 'fobamtw', dFobAmt)

Return 0
end function

public function integer wf_update_interface (string arg_ngno);/* --------------------------------------------------- */
/* Nego Number로 Interface Table Update                */
/* EXPNEGOH -> KIF08OT0                                */
/* EXPNEGOD -> KIF08OT1                                */
/* EXPCOSTH,EXPCOSTD -> KIF08OT2                       */
/* --------------------------------------------------- */
Long nCnt, weight, dSEq
Dec  wrate, urate, dChamt
Double dSunSuAmt
String sSaupj

SetPointer(HourGlass!)

SELECT COUNT(*) INTO :ncnt
 FROM "KIF08OT0"  
WHERE ( "KIF08OT0"."NGNO" = :arg_ngno ) AND  
		( "KIF08OT0"."BAL_DATE" IS NOT NULL )   ;

If nCnt > 0 Then
 f_message_chk(38,'[전표발행 되었습니다]')
 Return -2
End If

/* 기존 Interface 내용 삭제 */
DELETE FROM "KIF08OT0"
WHERE ( "KIF08OT0"."NGNO" = :arg_ngno ) AND  
		( "KIF08OT0"."BAL_DATE" is Null )   ;

/* Nego Detail delete */
DELETE FROM "KIF08OT1" WHERE ( "KIF08OT1"."NGNO" = :arg_ngno ) ;

/* Nego Cost delete */
DELETE FROM "KIF08OT2" WHERE ( "KIF08OT2"."NGNO" = :arg_ngno ) ;


SELECT COUNT(*) INTO :ncnt
 FROM "EXPNEGOH"  
WHERE ( "SABU" = :gs_sabu ) AND
		( "NGNO" = :arg_ngno ) ;

If nCnt <= 0 Then 
	COMMIT;
	Return 0
End If

/* 부가사업장 */
sSaupj = dw_key.GetItemString(1, 'saupj')

dSunSuAmt = dw_key.GetItemNumber(1,'sunsuamt')
If IsNull(dSunsuAmt) Or dSunsuAmt < 0 Then dSunsuAmt = 0

weight = dw_key.GetItemNumber(1,'weight')
If IsNull(weight) Or weight <= 0 Then weight = 1

/* 기존 Interface 내용 추가 */
INSERT INTO  "KIF08OT0" 
	VALUE  ( "SABU",            "NGNO",            "NGDT",            "CVCOD",      "NGGU",
				"EXPLCNO",         "NGBANK",          "REFNO",           "NGAMT",      "CURR",
				"WRATE",           "URATE",           "WAMT",            "UAMT",       "PAYGU",
				"EXDEPT_CD",       "NGDEPCD" ,        "HSNO",            "ALC_GU",     "SUNSUAMT",
				"INGAMT",			 "ICURR", 			  "SVNGAMT",			"SVWRATE",		"SVNGWAMT",
				"SV_CODE",  		 "SVNGFAMT",		  "DAPSAMT",			"DAPSWON",		"BILL_NO",
				"BILL_GU",			 "BILL_JIGU",		  "BILL_AMT",			"BMAN_DAT",		"BBAL_DAT",
				"BILL_BANK", 		 "BILL_NM",			  "BILL_OWNER_GU",	"TEMP_BILL_YN", "SAUPJ"
				) 
		SELECT "SABU",           "NGNO",            "NGDT",            "CVCOD",      "NGGU",
				"EXPLCNO",         "NGBANK",          "REFNO",           "NGAMT",      "CURR",
				"WRATE",           "URATE",           "WAMT",            "UAMT",       "PAYGU",
				:gs_dept,          "SAVE_CODE",       "HSNO",            'N',          :dSunsuAmt,
				"INGAMT",			 "ICURR", 			  "SVNGAMT",			"SVWRATE",		"SVNGWAMT",
				"SV_CODE",  		 "SVNGFAMT",		  "DAPSAMT",			"DAPSWON",		"BILL_NO",
				"BILL_GU",			 "BILL_JIGU",		  "BILL_AMT",			"BMAN_DAT",		"BBAL_DAT",
				"BILL_BANK", 		 "BILL_NM",			  "BILL_OWNER_GU",	"TEMP_BILL_YN", :sSaupj
		 FROM "EXPNEGOH"
		WHERE "SABU" = :gs_sabu AND
				"NGNO" = :arg_ngno;
If sqlca.sqlcode <> 0 Then
	Rollback;
	f_message_chk(89,'[Interface Error 0]')
	Return -1
End If

If dw_key.RowCount() > 0 Then
	wrate = dw_key.GetItemNumber(1,'wrate')
	urate = dw_key.GetItemNumber(1,'urate')
Else
	RollBack;
	Return -1
End If

/* C/I등록시 환율로 계산하고 C/I가 없는 것은 제외한다 */
INSERT INTO "KIF08OT1"
 VALUE  ( "SABU",            "NGNO",            "NGSEQ",            "CINO",            "PINO",
			 "NGAMT",           "WAMT",			   "UAMT",             "CIWRATE",         "CIURATE",  "CIDATE" )
	SELECT "EXPNEGOD"."SABU",  "EXPNEGOD"."NGNO", "EXPNEGOD"."NGSEQ", "EXPNEGOD"."CINO", "EXPNEGOD"."PINO",
			 "EXPNEGOD"."NGAMT",
			 Trunc("EXPNEGOD"."NGAMT" * NVL("EXPCIH"."WRATE",1)/:weight,0),
			 Trunc("EXPNEGOD"."NGAMT" * NVL("EXPCIH"."URATE",1)/:weight,2),
			 "EXPCIH"."WRATE",  "EXPCIH"."URATE",  "EXPCIH"."SALEDT"
	  FROM "EXPNEGOD", "EXPCIH"
	 WHERE "EXPNEGOD"."NGNO" = :arg_ngno AND
			 "EXPNEGOD"."CINO" = "EXPCIH"."CINO" AND
			 "EXPNEGOD"."DATAGU" =  '1';

If sqlca.sqlcode <> 0 Then
	Rollback;
	f_message_chk(89,'[Interface Error 1]')
	Return -1
End If

INSERT INTO "KIF08OT2" 
 VALUE  ( "SABU",               "NGNO",                  "COSTNO",             "COSTSEQ",             "COSTCD",   
			 "COSTAMT",            "COSTFORAMT",            "COSTVND",            "COSTBIGO"  )
	SELECT "EXPCOSTH"."SABU",    "EXPCOSTD"."NGNO",       "EXPCOSTD"."COSTNO",  "EXPCOSTD"."COSTSEQ",   "EXPCOSTH"."COSTCD",
			 "EXPCOSTD"."COSTAMT", "EXPCOSTD"."COSTFORAMT", "EXPCOSTH"."COSTVND", "EXPCOSTH"."COSTBIGO" 
	  FROM "EXPCOSTD", "EXPCOSTH"
	 WHERE ( "EXPCOSTH"."SABU"   = "EXPCOSTD"."SABU" ) and  
			 ( "EXPCOSTH"."COSTNO" = "EXPCOSTD"."COSTNO" ) and
			 ( "EXPCOSTH"."CRTGU"  = '2' ) and
			 ( "EXPCOSTD"."NGNO" = :arg_ngno ) ;

If sqlca.sqlcode <> 0 Then
	Rollback;
	f_message_chk(89,'[Interface Error 2]')
	Return -1
End If

COMMIT;

/* 수출매출 과 Nego사이의 끝전처리 */
//select b.cino, max(a.ngseq) as ngseq, b.expamt, b.wamt, 
//       sum(a.ngamt) as ngamt, 
//       nvl(sum(c.ngamt),0) as sunamt, 
//       nvl(sum(a.wamt),0) as ngwamt,
//       nvl(sum(trunc(c.ngamt * c.wrate,0)),0) as suwamt, 
//       b.wamt - ( sum(a.wamt) + nvl(sum(trunc(c.ngamt * b.wrate,0)),0) ) as chamt
//
//  from kif08ot1 a, kif05ot0 b, kif05ot2 c
// where a.sabu = b.sabu and
//       a.cino = b.cino and
//       a.sabu = c.sabu(+) and
//       a.cino = c.cino(+)
// group by b.cino, b.expamt, b.wamt
//having b.expamt = sum(a.ngamt) + nvl(sum(c.ngamt),0) and 
//       b.wamt <> sum(a.wamt) + nvl(sum(trunc(c.ngamt * b.wrate,0)),0)

/* 수출매출 과 Nego사이의 끝전처리 */
/* 차이금액 = 수출매출(CI HEADER의 원화금액) */
/*          - SUM(NEGO된 CI원화금액) 			*/
/*          - SUM(선수상계처리된 CI원화금액:매출전송시 발생된 자료) */

select max(a.ngseq),
       b.wamt - ( sum(a.wamt) + nvl(sum(trunc(c.ngamt * b.wrate / :weight,0)),0) ) as chamt
  into :dSEq, :dChamt
  from kif08ot1 a, kif05ot0 b, kif05ot2 c
 where a.sabu = b.sabu and
       a.cino = b.cino and
       a.sabu = c.sabu(+) and
       a.cino = c.cino(+) and
       a.sabu = :gs_sabu and 
       a.ngno = :arg_ngno
 group by b.cino, b.expamt, b.wamt
having b.expamt = sum(a.ngamt) + nvl(sum(c.ngamt),0) and 
       b.wamt <> sum(a.wamt) + nvl(sum(trunc(c.ngamt * b.wrate / :weight,0)),0);

If IsNull(dChamt) Then dChamt = 0

If sqlca.sqlcode = 0 Then
	If dChamt <> 0 Then
		IF MessageBox("끝전수정","끝전 " + String(dChamt) + "원이 발생했습니다." +"~n~n" +&
						  "수정 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

		UPDATE KIF08OT1
		   SET WAMT = WAMT + :dChamt
		 WHERE SABU = :gs_sabu AND
		       NGNO = :arg_ngno AND
				 NGSEQ = :dSeq;
				 
		If sqlca.sqlcode <> 0 Then
			Rollback;
			f_message_chk(89,'[끝전 오류]')
			Return -1
		End If
	End If
	
	COMMIT;
End If

Return 0
end function

public function integer wf_nego_charge (string sngno, string srfgub1);/* -------------------------------------------------------------------- */
/* Nego 비용                                                            */
/* -------------------------------------------------------------------- */
string sCostCd, sCostNo, sCurr, sNgdt, sCino, sPino, sSaupj
Dec{2} dCostAmt,dCostForAmt,dCostAmtd,dCostForAmtd,dNgamt,dTotAmt
Dec{5} dDivRate
Dec{2} dSumAmtd,dSumForAmtd
Long   rCnt,iy, nCnt, ix

sNgdt = Trim(dw_key.GetItemString(1,'ngdt'))
sCurr = Trim(dw_key.GetItemString(1,'curr'))

sSaupj = dw_key.GetItemString(1,'saupj')

nCnt = tab_1.tabpage_2.dw_2.RowCount()
For ix = nCnt To 1 Step -1
	Choose Case tab_1.tabpage_2.dw_2.GetItemStatus(ix,0,Primary!)
		Case New!
			tab_1.tabpage_2.dw_2.DeleteRow(ix)
			continue
		Case NewModified!
	      sCostCd = Trim(tab_1.tabpage_2.dw_2.GetItemString(ix,'costcd'))
	      If IsNull(sCostCd) Or sCostCd = '' Then
				f_message_chk(1400,'[비용구분]')
				tab_1.tabpage_2.dw_2.Setfocus()
				tab_1.tabpage_2.dw_2.SetRow(ix)
				tab_1.tabpage_2.dw_2.SetColumn('costcd')
				Return -1
         End If

//         If sCurr = 'WON' Then
			dCostAmt = tab_1.tabpage_2.dw_2.GetItemNumber(ix,'costamt')
			If IsNull(dCostAmt) Or dCostAmt = 0 Then
				f_message_chk(1400,'[비용]')
				tab_1.tabpage_2.dw_2.Setfocus()
				tab_1.tabpage_2.dw_2.SetRow(ix)
				tab_1.tabpage_2.dw_2.SetColumn('costamt')
				Return -1
			End If
//	      End If
	
			/* 수출비용 채번 */
		   sCostNo = wf_get_junpyo_no(sNgdt,'X5')
      	If IsNull(sCostNo) Then Return -1
	
      	tab_1.tabpage_2.dw_2.SetItem(ix,'sabu',     gs_sabu)
      	tab_1.tabpage_2.dw_2.SetItem(ix,'costno',   sCostNo )
			tab_1.tabpage_2.dw_2.SetItem(ix,'costgu',   sRfgub1 )
	End Choose

	tab_1.tabpage_2.dw_2.SetItem(ix,'costdt',   sNgdt )
   tab_1.tabpage_2.dw_2.SetItem(ix,'curr',     sCurr )
	tab_1.tabpage_2.dw_2.SetItem(ix,'costvat',  0 )
	tab_1.tabpage_2.dw_2.SetItem(ix,'exchrate', dw_key.GetItemNumber(1,'wrate'))
	tab_1.tabpage_2.dw_2.SetItem(ix,'costvnd',  dw_key.GetItemString(1,'ngbank') )

//	MESSAGEBOX('',SSAUPJ)
	tab_1.tabpage_2.dw_2.SetItem(ix,'saupj',   sSaupj )
Next


/* 생성할 Invoice가 없으면 비용을 삭제한다 */
//rCnt = 0
//For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
//	sCino = tab_1.tabpage_1.dw_1.GetItemString(ix,'cino')
//	If IsNull(sCino) Or sCino = '' Then Continue
//	
//	rCnt += 1
//Next
//
//If rCnt <= 0 Then
//	MessageBox('확 인','생성할 Invoice가 없어 수출비용을 삭제합니다!!')
//
//	For ix = 1 To tab_1.tabpage_2.dw_2.RowCount()
//		sCostNo = tab_1.tabpage_2.dw_2.GetItemString(ix,'costno')
//		
//		/* EXPCOSTD DELETE */
//		DELETE FROM EXPCOSTD	 WHERE SABU = :gs_sabu AND COSTNO = :sCostNo;
//		If sqlca.sqlcode <> 0 Then
//			f_message_chk(160,'')
//			RollBack;
//			Return -1
//		End If
//	Next
//	
//	tab_1.tabpage_2.dw_2.RowsMove(1, tab_1.tabpage_2.dw_2.RowCount(),Primary!,tab_1.tabpage_2.dw_2,1,Delete!)
//End If

/* -------------------------------------- */


/* 수출비용 detail 작성 */
For ix = 1 To tab_1.tabpage_2.dw_2.RowCount()
	sCostNo = tab_1.tabpage_2.dw_2.GetItemString(ix,'costno')
	
	DELETE FROM EXPCOSTD	 WHERE SABU = :gs_sabu AND COSTNO = :sCostNo;
	If sqlca.sqlcode <> 0 Then
		f_message_chk(160,'')
		RollBack;
		Return -1
	End If

	/* 배분할 비용금액 */
	dCostAmt = tab_1.tabpage_2.dw_2.GetItemNumber(ix,'costamt')
	dCostForAmt = tab_1.tabpage_2.dw_2.GetItemNumber(ix,'costforamt')

   nCnt = tab_1.tabpage_1.dw_1.RowCount()
	
	/* 매출확정된 nego 금액만 처리대상 : CI,PI No 입력*/
   If nCnt > 0 Then 
		dTotAmt = tab_1.tabpage_1.dw_1.GetItemNumber(1,'sum_ngamt')
 
		dSumAmtd = 0
		dSumForAmtd = 0
		For iy = 1 To nCnt
			/* Ci 가 없으면 생성하지 않는다 */
			sCino = tab_1.tabpage_1.dw_1.GetItemString(iy,'cino')
			If IsNull(sCino) Or sCino = '' Then Continue
			
			/* 수출비용 배분율 계산 */
			dNgAmt = tab_1.tabpage_1.dw_1.GetItemNumber(iy,'ngamt')
			If dTotAmt <> 0 Then dDivRate = dNgAmt / dTotAmt
			
			/*배분된 비용금액 */
			dCostAmtd    = TrunCate(dCostAmt * dDivRate,0)
			dCostForAmtd = TrunCate(dCostForAmt * dDivRate,2)
			dSumAmtd += dCostAmtd
			dSumForAmtd += dCostForAmtd
		  
			/* 끝전 처리 */
			If iy = nCnt Then
				dCostAmtd += TrunCate( dCostAmt - dSumAmtd ,0)
				dCostForAmtd += TrunCate( dCostForAmt - dSumForAmtd ,2)
			End If
	
			sPino = tab_1.tabpage_1.dw_1.GetItemString(iy,'pino')
			INSERT INTO "EXPCOSTD"  
					 ( "SABU",           "COSTNO",          "ISEQ",			  "COSTSEQ",      "CINO",
						"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
						"NGNO" )  
			VALUES ( :gs_sabu,        :sCostNo,          1,				  :iy,            :sCino,   
						:sPino,           :dCostamtd,        0,              :dCostForamtd,
						:sNgno )  ;

			If sqlca.sqlcode <> 0 Then
				f_message_chk(160,'')
				RollBack;
				Return -1
			End If
		Next
	Else
		/* 선수금 수수료일 경우 */
		INSERT INTO "EXPCOSTD"  
				 ( "SABU",           "COSTNO",          "ISEQ",			  "COSTSEQ",      "CINO",
					"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
					"NGNO" )  
		 VALUES ( :gs_sabu,        :sCostNo,          1,				   1,            	NULL,   
					NULL,          	:dCostAmt,         0,              :dCostForAmt,
					:sNgno ) ;
		If sqlca.sqlcode <> 0 Then
			f_message_chk(160,'')
			RollBack;
			Return -1
		End If
	End If
Next

IF tab_1.tabpage_2.dw_2.Update() <> 1 THEN
   ROLLBACK;
	f_message_chk(32,'')
	sle_msg.text = ''
   Return -1
END IF

COMMIT;

Return 0
end function

public function integer wf_check_detail ();/* 선수금액 */
Double dSunsuAmt, dNgAmtH, dNgAmtD, dNgAmtF, dWamtH, dUamtH, dWamtd, dUamtD, dWamtF, dUamtF
Long   ix

dNgAmtH = dw_key.GetItemNumber(1,'ngamt')
dWAmtH = dw_key.GetItemNumber(1,'Wamt')
dUAmtH = dw_key.GetItemNumber(1,'Uamt')

If IsNull(dNgAmtH) Then dNgAmtH = 0
If IsNull(dWAmtH) Then dWAmtH = 0
If IsNull(dUAmtH) Then dUAmtH = 0

/* Nego등록시 작성된 내역 */
If tab_1.tabpage_1.dw_1.Rowcount() > 0 Then
   dNgAmtD = tab_1.tabpage_1.dw_1.GetItemNumber(1,'sum_ngamt_all')
   dWAmtD = tab_1.tabpage_1.dw_1.GetItemNumber(1,'sum_wamt')
   dUAmtD = tab_1.tabpage_1.dw_1.GetItemNumber(1,'sum_uamt')
  
   If IsNull(dNgAmtD) Then dNgAmtD = 0
   If IsNull(dWAmtD) Then dWAmtD = 0
   If IsNull(dUAmtD) Then dUAmtD = 0	
Else
	dNgAmtD = 0
	dWAmtD = 0
	dUAmtD = 0	
End If

/* 매출확정시 작성된 내역 */
dNgAmtF = 0
dWAmtF = 0
dUAmtF = 0
For ix = 1 To tab_1.tabpage_1.dw_1.FilteredCount () 
	 dNgAmtF += tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt',Filter!,False)
    dWAmtF  += tab_1.tabpage_1.dw_1.GetItemNumber(ix,'wamt',Filter!,False)
    dUAmtF  += tab_1.tabpage_1.dw_1.GetItemNumber(ix,'uamt',Filter!,False)  
Next

dSunsuAmt = TrunCate( dNgAmtH - dNgAmtD - dNgAmtF + 0.001 ,2)

/* Head의 Nego금액과 Detial의 Nego금액이 깥으면 원화금액과 외화금액을 맞춘다.
   Nego Detial은 Nego에서 직접등록된 Invoice자료를 기준으로 조정하고 선수금액이 완료된 경우에는
	매출확정에서 끝전을 맞춘다. */
if dNgamtH = dNgamtd + dNgamtF And tab_1.tabpage_1.dw_1.rowcount() > 0 then
	For ix = 1 to tab_1.tabpage_1.dw_1.rowcount()
		 if tab_1.tabpage_1.dw_1.getitemstring(ix, "datagu") = '1' then
			 Exit
		 End if
	Next	
	if ix <= tab_1.tabpage_1.dw_1.rowcount() then
		tab_1.tabpage_1.dw_1.setitem(ix, "wamt", tab_1.tabpage_1.dw_1.getitemnumber(ix, "wamt") + (dWamtH - dWamtD - dwamtF))
		tab_1.tabpage_1.dw_1.setitem(ix, "uamt", tab_1.tabpage_1.dw_1.getitemnumber(ix, "uamt") + (dUamtH - dUamtD - dUamtF))
	End if
End if

If dSunsuAmt < 0 Then
	MessageBox('확 인','NEGO금액보다 C/I의 금액이 큽니다.!!')
	Return -1
End If

Return 1

end function

public function integer wf_calc_curr (integer nrow, string sdate, string scurr);/* 환율과 Nego 금액을 계산한다 */
Double wrate, urate, weigh, dNgAmt
Long   ix

select x.rstan,x.usdrat
  into :wrate,:urate
  from ratemt x
 where x.rdate = :sdate and
       x.rcurr = :sCurr;

select to_number(y.rfna2)
  into :weigh
  from reffpf y
 where y.rfcod = '10' and
       y.rfgub = :sCurr;
		 
If IsNull(wrate) Then wrate = 0.0
If IsNull(urate) Then urate = 0.0
If IsNull(weigh) Then weigh = 0.0
		 
If sqlca.sqlcode = 0 Then
  dw_key.SetItem(nRow,'wrate',wrate)
  dw_key.SetItem(nRow,'urate',urate)
  dw_key.SetItem(nRow,'weight',weigh)
Else
  dw_key.SetItem(nrow,'wrate',1)
  dw_key.SetItem(nrow,'urate',1)
  dw_key.SetItem(nrow,'weight',1)
End If
		
dNgamt = dw_key.GetItemNumber(nRow,'ngamt')
If IsNull(wrate) or wrate = 0 Then wrate =  1
If IsNull(urate) or urate = 0 Then urate =  1
If IsNull(weigh) or weigh = 0 Then weigh =  1

/* Nego Header의 원화,미화 금액 */
dw_key.SetItem(nRow,'wamt',TrunCate((dNgamt * wrate)/weigh,0))
dw_key.SetItem(nRow,'uamt',TrunCate((dNgamt * urate)/weigh,2))

/* Nego Detail의 원화,미화 금액 */
For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
	dNgamt = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt')
	
	tab_1.tabpage_1.dw_1.SetItem(ix,'wamt',TrunCate((dNgamt * wrate)/weigh,0))
  tab_1.tabpage_1.dw_1.SetItem(ix,'uamt',TrunCate((dNgamt * urate)/weigh,2))
Next

Return 0
end function

public subroutine wf_protect_key (boolean gb);dw_key.SetRedraw(False)

If gb = True then       // protect 설정
   dw_key.Modify('ngno.protect = 0')         // 수정일 경우
Else
   dw_key.Modify('ngno.protect = 1')        // 신규일 경우
End If

dw_key.SetRedraw(True)

end subroutine

on w_sal_06090.create
int iCurrent
call super::create
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.tab_1=create tab_1
this.dw_key=create dw_key
this.cb_ban=create cb_ban
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_new
this.Control[iCurrent+2]=this.rb_upd
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.dw_key
this.Control[iCurrent+5]=this.cb_ban
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_sal_06090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.tab_1)
destroy(this.dw_key)
destroy(this.cb_ban)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_key.SetTransObject(sqlca)
dw_key.InsertRow(0)

tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_3.SetTransObject(sqlca)

wf_init()



end event

type dw_insert from w_inherite`dw_insert within w_sal_06090
boolean visible = false
integer x = 110
integer y = 2556
integer width = 361
integer height = 356
integer taborder = 0
boolean enabled = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type p_delrow from w_inherite`p_delrow within w_sal_06090
boolean visible = false
integer x = 2053
integer y = 2432
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_06090
boolean visible = false
integer x = 1879
integer y = 2432
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_06090
integer x = 3913
integer y = 28
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event p_search::clicked;call super::clicked;string sNgno,pi_seq,s_pino,sCostNo
int    nRow,ix
dec    ngamt

nRow  = dw_key.RowCount()
If nRow <=0 Then Return

sNgno = Trim(dw_key.GetItemString(nRow,'ngno'))
If IsNull(sNgno) Or sNgno = '' Then Return

/* 회계 처리 여부 */
If wf_check_interface(sNgno) > 0 Then	
	wf_init()
	Return
End If

IF MessageBox("삭 제",sNgno + "의 모든 자료가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_key.DeleteRow(0) <> 1 Then Return

/* pi header에서 ngamt를 감산함 */
nRow = tab_1.tabpage_1.dw_1.RowCount()
For ix = 1 To nRow
	s_pino = Trim(tab_1.tabpage_1.dw_1.GetItemString(ix,'pino'))
	If IsNull(s_pino ) Or s_pino = '' Then Continue
	
	ngamt = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt')
   wf_update_pi_ngamt(s_pino,ngamt,'-')
Next

/* Invoice 관련 내역 삭제 */
IF dw_key.Update() <> 1 THEN
   ROLLBACK;
   Return
End If

tab_1.tabpage_1.dw_1.RowsMove(1, nRow,  Primary!,tab_1.tabpage_1.dw_1,1,Delete!)
IF tab_1.tabpage_1.dw_1.Update() <> 1 THEN
   ROLLBACK;
   Return
END IF

/* 수출비용 내역 삭제 */
nRow = tab_1.tabpage_2.dw_2.RowCount()
For ix = 1 To nRow
	sCostNo = Trim(tab_1.tabpage_2.dw_2.GetItemString(ix,'costno'))
	If IsNull(sCostNo) Or sCostNo = '' Then Continue
	
	DELETE FROM EXPCOSTD	 WHERE SABU = :gs_sabu AND COSTNO = :sCostNo;
	If sqlca.sqlcode <> 0 Then
		f_message_chk(160,'')
		RollBack;
		Return
	End If
Next

tab_1.tabpage_2.dw_2.RowsMove(1, nRow,  Primary!,tab_1.tabpage_2.dw_2,1,Delete!)
IF tab_1.tabpage_2.dw_2.Update() <> 1 THEN
   ROLLBACK;
   Return
END IF

COMMIT;

/* Nego 반제자료 delete */
DELETE FROM "KIF08OT3" 
 WHERE ( "KIF08OT3"."SABU" = :gs_sabu ) AND
       ( "KIF08OT3"."NGNO" = :sngno ) ;
If sqlca.sqlcode <> 0 Then
	f_message_chk(160,'')
	RollBack;
	Return
End If
	
/* Interface Table update */
wf_update_interface(sNgno)

sle_msg.text ='자료를 삭제하였습니다!!'

wf_init()
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sal_06090
integer x = 3566
integer y = 28
end type

event p_ins::clicked;call super::clicked;int    nRow
String s_cino,s_pino,s_ngdt,s_curr,sCostCd

If dw_key.AcceptText() <> 1 Then Return 

/* Header key check */
dw_key.Setfocus()
dw_key.SetRow(1)
s_ngdt = dw_key.GetItemString(1,'ngdt')
If IsNull(s_ngdt) Or s_ngdt = '' Then
	f_message_chk(40,'[일자]')
	dw_key.SetColumn('ngdt')
	Return
End If

s_curr = dw_key.GetItemString(1,'curr')
If IsNull(s_curr) Or s_curr = '' Then
	f_message_chk(40,'[통화단위]')
	dw_key.SetColumn('curr')
	Return
End If

Choose Case tab_1.Selectedtab 
	Case 1
		nRow = tab_1.tabpage_1.dw_1.RowCount()
		If nRow > 0 Then
			s_cino = Trim(tab_1.tabpage_1.dw_1.GetItemString(nRow,'cino'))
			s_pino = Trim(tab_1.tabpage_1.dw_1.GetItemString(nRow,'pino'))
			
			If ( IsNull(s_cino) Or s_cino = '' ) and ( IsNull(s_pino) Or s_pino = '' )Then
				f_message_chk(1400,'[C/I No. Or P/I No.]')
				tab_1.tabpage_1.dw_1.Setfocus()
				tab_1.tabpage_1.dw_1.SetRow(nRow)
				tab_1.tabpage_1.dw_1.SetColumn('cino')
				Return
			End If
		End If
		
		nRow = tab_1.tabpage_1.dw_1.InsertRow(0)
		
		tab_1.tabpage_1.dw_1.SetFocus()
		tab_1.tabpage_1.dw_1.ScrollToRow(nRow)
		tab_1.tabpage_1.dw_1.SetRow(nRow)
		tab_1.tabpage_1.dw_1.SetColumn('cino')
	Case 2
//		If tab_1.tabpage_1.dw_1.RowCount() <= 0 Then
//			MessageBox('확 인','[Invoice내역에 등록된 내용이 없습니다!!]~r~n~r~n')
//			Return
//		End If
		
		nRow = tab_1.tabpage_2.dw_2.RowCount()
		If nRow > 0 Then
			sCostCd = tab_1.tabpage_2.dw_2.GetItemString(nRow,'costcd')
			
			If IsNull(sCostCd) Or sCostCd = '' Then
				f_message_chk(1400,'[비용구분]')
				tab_1.tabpage_2.dw_2.Setfocus()
				tab_1.tabpage_2.dw_2.SetRow(nRow)
				tab_1.tabpage_2.dw_2.SetColumn('costcd')
				Return
			End If
		End If
		
		nRow = tab_1.tabpage_2.dw_2.InsertRow(0)
		tab_1.tabpage_2.dw_2.SetFocus()
		tab_1.tabpage_2.dw_2.ScrollToRow(nRow)
		tab_1.tabpage_2.dw_2.SetRow(nRow)
		tab_1.tabpage_2.dw_2.SetColumn('costcd')
End Choose

end event

type p_exit from w_inherite`p_exit within w_sal_06090
integer x = 4434
integer y = 28
end type

type p_can from w_inherite`p_can within w_sal_06090
integer x = 4261
integer y = 28
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_sal_06090
boolean visible = false
integer x = 1696
integer y = 2492
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_06090
integer x = 3392
integer y = 28
end type

event p_inq::clicked;call super::clicked;string sNgno,sCino,sPino
Double dPiAmt, dNgAmt
Long   nRow,nCnt,ix

If rb_new.Checked = True Then Return  //신규이면 조회불가

If dw_key.AcceptText() <> 1 Then Return

nRow  = dw_key.RowCount()
If nRow <=0 Then Return
	  
sNgno = Trim(dw_key.GetItemString(nRow,'ngno'))
If IsNull(sNgno) Or sNgno = '' Then
   f_message_chk(1400,'[NEGO No.]')
	Return 1
End If

If dw_key.Retrieve(gs_sabu,sNgno) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
	rb_upd.TriggerEvent(Clicked!)
	return 
End If

tab_1.tabpage_1.dw_1.SetRedraw(False)
nCnt = tab_1.tabpage_1.dw_1.Retrieve(gs_sabu,sNgno)
For ix = 1 To nCnt
	sCino = tab_1.tabpage_1.dw_1.GetItemString(ix,'cino')
	sPino = tab_1.tabpage_1.dw_1.GetItemString(ix,'pino')

	dPiAmt = wf_get_piamt(sCino, sPino) 			/* 수출매출 금액 */
	dNgAmt = wf_get_ngamt(sNgno, sCino, sPino)   /* 기nego 금액 */
	tab_1.tabpage_1.dw_1.SetItem(ix,'piamt', dPiAmt)
	tab_1.tabpage_1.dw_1.SetItem(ix,'pijan', dPiAmt - dNgamt)
Next

wf_calc_sunsuamt() /* 선수금 계산 */

tab_1.tabpage_1.dw_1.SetRedraw(True)

/* Nego 비용조회 */
tab_1.tabpage_2.dw_2.Retrieve(gs_sabu,sNgno)

/* 어음정보조회 */
tab_1.tabpage_3.dw_3.Retrieve(gs_sabu,sNgno)

wf_protect_key(false)

/* 회계 처리 여부 */
wf_check_interface(sNgno)

dw_key.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sal_06090
integer x = 4087
integer y = 28
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event p_del::clicked;call super::clicked;string sCino,sPino,sNgno,sCostNo
Long   nRow,nNgseq
dec    pi_ngamt

/* 회계 처리 여부 */
If wf_check_interface(sNgno) > 0 Then	
	wf_init()
	Return
End If

Choose Case tab_1.SelectedTab 
	Case  1
		nRow  = tab_1.tabpage_1.dw_1.GetRow()
		If nRow <=0 Then Return

		sNgno  = Trim((tab_1.tabpage_1.dw_1.GetItemString(nRow,'ngno')))
		nNgSeq = tab_1.tabpage_1.dw_1.GetItemNumber(nRow,'ngseq')
		sCino  = Trim((tab_1.tabpage_1.dw_1.GetItemString(nRow,'cino')))
		sPino  = Trim((tab_1.tabpage_1.dw_1.GetItemString(nRow,'pino')))
		pi_ngamt = tab_1.tabpage_1.dw_1.GetItemNumber(nRow,'ngamt')
	
		IF MessageBox("삭 제","SEQ : " + String(nRow) + "번째  자료가 삭제됩니다." +"~n~n" +&
						 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

		/* 저장되기 전이면 dw에서만 삭제 */
		If IsNull(sNgno) or Trim(sNgno) = '' Then 
			tab_1.tabpage_1.dw_1.DeleteRow(nRow)
			wf_calc_sunsuamt()
			sle_msg.text ='자료를 삭제하였습니다!!'
			Return
		End If

		/* pi header 에서 차감 */
		If sCino <> '' And Not IsNull(sCino) Then
			If wf_update_pi_ngamt(sPino,pi_ngamt,'-') = -1 Then
				ROLLBACK;
				Return
			END IF
		End If
	
		If tab_1.tabpage_1.dw_1.DeleteRow(nRow) = 1 Then
			IF tab_1.tabpage_1.dw_1.Update() <> 1 THEN
				ROLLBACK;
				Return
			END IF
		End If

		COMMIT;
		
		/* 수출비용 재생성 */
		If wf_nego_charge(sNgno, sRfgub) < 0 Then Return

		/* Interface Table update */
		wf_update_interface(sNgno)

		/* 선수금 계산 */
		wf_calc_sunsuamt()
		
		sle_msg.text ='자료를 삭제하였습니다!!'
   Case 2
		nRow  = tab_1.tabpage_2.dw_2.GetRow()
		If nRow <=0 Then Return
		sCostNo  = Trim((tab_1.tabpage_2.dw_2.GetItemString(nRow,'costno')))
		
		IF MessageBox("삭 제","SEQ : " + String(nRow) + "번째  자료가 삭제됩니다." +"~n~n" +&
							"삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
		
		/* 저장되기 전이면 dw에서만 삭제 */
		If IsNull(sCostNo) or Trim(sCostNo) = '' Then 
			tab_1.tabpage_2.dw_2.DeleteRow(nRow)
			sle_msg.text ='자료를 삭제하였습니다!!'
			Return
		End If
		
		/* EXPCOSTD DELETE */
		DELETE FROM EXPCOSTD	 WHERE SABU = :gs_sabu AND COSTNO = :sCostNo;
		If sqlca.sqlcode <> 0 Then
			f_message_chk(160,'')
			RollBack;
			Return -1
		End If

		/* EXPCOSTH DELETE */
		If tab_1.tabpage_2.dw_2.DeleteRow(nRow) = 1 Then
			IF tab_1.tabpage_2.dw_2.Update() <> 1 THEN
				ROLLBACK;
				Return
			END IF
		End If
		
		COMMIT;
		
		/* Interface Table update */
		sNgno = Trim(dw_key.GetItemString(1,'ngno'))
		If IsNull(sNgno) Or sNgno = '' Then Return
		wf_update_interface(sNgno)

		sle_msg.text ='자료를 삭제하였습니다!!'		
End Choose
end event

event p_del::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event p_del::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_mod from w_inherite`p_mod within w_sal_06090
integer x = 3739
integer y = 28
end type

event p_mod::clicked;call super::clicked;string  sNgno, sCino, sPino, sNgdt, sCvcod, sCurr, sHsNo, sSetSch, sRefNo, sIcurr, sSaveCode, sSaupj
int     nCnt,ix,i_piseq,nRtn, nMax
dec {2} wamt,uamt,dtemp,ngamt,old_amt,new_amt, dIngAmt, dsvwrate, dsvngamt, dsvngfamt, dNgamt, dSubNgamt

If dw_key.AcceptText() <> 1 Then Return
If tab_1.tabpage_1.dw_1.AcceptText() <> 1 Then Return
If tab_1.tabpage_2.dw_2.AcceptText() <> 1 Then Return

/* -------------------------------------------------------------------- */
/* NEGO 헤더 저장                                                       */
/* -------------------------------------------------------------------- */
nCnt  = dw_key.RowCount()
If nCnt <=0 Then 
	f_message_chk(83,'')
	Return
End If

dw_key.SetFocus()

sNgdt = dw_key.GetItemString(nCnt,'ngdt')
If f_datechk(sNgdt) <> 1 Then
	f_message_chk(40,'[일자]')
	dw_key.SetColumn('ngdt')
	Return 
End If

sSaupj = dw_key.GetItemString(nCnt,'saupj')
If f_datechk(sNgdt) <> 1 Then
	f_message_chk(40,'[부가사업장]')
	dw_key.SetColumn('saupj')
	Return 
End If

sSetSch = dw_key.GetItemString(nCnt,'setsch')
If f_datechk(sSetSch) <> 1 Then
	f_message_chk(40,'[결제예정일]')
	dw_key.SetColumn('setsch')
	Return 
End If

sCurr = Trim(dw_key.GetItemString(nCnt,'curr'))
If IsNull(sCurr) or sCurr = '' Then
	f_message_chk(40,'[통화]')
	dw_key.SetColumn('curr')
	Return 
End If

siCurr = Trim(dw_key.GetItemString(nCnt,'icurr'))
If IsNull(siCurr) or siCurr = '' Then
	f_message_chk(40,'[통화]')
	dw_key.SetColumn('icurr')
	Return 
End If

dsvwrate = dw_key.GetItemNumber(nCnt,'svwrate')
If IsNull(dsvwrate) Or dsvwrate = 0 Then
	f_message_chk(40,'[원화예적금 적용환율]')
	dw_key.SetColumn('svwrate')
	Return 
End If

dSvNgAmt = dw_key.GetItemNumber(nCnt,'svngamt')
If IsNull(dSvNgAmt) Then dSvNgAmt = 0

If sICurr = 'WON' Or dSvNgAmt <> 0  Then
	If IsNull(dSvNgAmt) Or dSvNgAmt = 0 Then
		f_message_chk(40,'[원화예적금]')
		dw_key.SetColumn('svngamt')
		Return 
	End If
	
	sSaveCode = Trim(dw_key.GetItemString(nCnt,'sv_code'))
	If IsNull(sSaveCode) or sSaveCode = '' Then
		f_message_chk(40,'[입급계좌]')
		dw_key.SetColumn('sv_code')
		Return 
	End If
End If

/* 외화예적금 CHECK */
If sICurr <> 'WON' Then
	dSvNgFAmt = dw_key.GetItemNumber(nCnt,'svngfamt')
	If IsNull(dSvNgfAmt) Or dSvNgfAmt = 0 Then
		f_message_chk(40,'[외화예적금]')
		dw_key.SetColumn('svngfamt')
		Return 
	End If
	
	sSaveCode = Trim(dw_key.GetItemString(nCnt,'save_code'))
	If IsNull(sSaveCode) or sSaveCode = '' Then
		f_message_chk(40,'[입급계좌]')
		dw_key.SetColumn('save_code')
		Return 
	End If
	
	dIngAmt = dw_key.GetItemNumber(nCnt,'ingamt')
	If IsNull(dIngamt) Or dIngamt = 0 Then
		f_message_chk(40,'[NEGO 입금금액]')
		dw_key.SetColumn('ingamt')
		Return 
	End If
End If

sRefNo = Trim(dw_key.GetItemString(nCnt,'refno'))
If IsNull(sRefNo) or sRefNo = '' Then
	f_message_chk(40,'[NEGO REF No.]')
	dw_key.SetColumn('refno')
	Return 
End If

sCvcod = dw_key.GetItemString(nCnt,'cvcod')
If IsNull(sCvcod) Or sCvcod = ''  Then
	f_message_chk(40,'[Buyer]')
	dw_key.SetColumn('cvcod')
	Return 
End If

dngAmt = dw_key.GetItemNumber(nCnt,'ngamt')
If IsNull(dngamt) Or dngamt = 0 Then
	f_message_chk(40,'[NEGO 금액]')
	dw_key.SetColumn('ngamt')
	Return 
End If

If tab_1.tabpage_1.dw_1.RowCount() > 0 Then
	dSubNgAmt = tab_1.tabpage_1.dw_1.GetItemNumber(1,'sum_ngamt_all')
	If IsNull(dSubNgAmt) Then dSubNgAmt = 0
	
	dNgAmt 	 = Round(dNgamt,2)
	dSubNgAmt = Round(dSubNgamt,2)
	
	If dNgAmt < dSubNgAmt Then
		MessageBox('확 인','NEGO헤더 금액보다 송장NEGO금액이 큽니다.!!')
		Return
	End If
End If

/* 어음정보 지정 */
If tab_1.tabpage_3.dw_3.RowCount() > 0 Then
	String sBillNo, sBManDat
	Double dBillAmt
	
	sBillNo  = tab_1.tabpage_3.dw_3.GetItemString(1, "BILL_NO")
	sBManDat = tab_1.tabpage_3.dw_3.GetItemString(1, "BMAN_DAT")
	dBillAmt = tab_1.tabpage_3.dw_3.GetItemNumber(1, "BILL_AMT")
	
	If Not IsNull(sBillNo) Then
		If IsNull(sBManDat) Or sBManDat = '' Then
			f_message_chk(40,'[어음 만기일]')
			Return 
		End If
		
		If IsNull(dBillAmt) Or dBillAmt = 0 Then
			f_message_chk(40,'[어음 금액]')
			Return 
		End If
	End If
	
	dw_key.SetItem(1, "BILL_NO", sBillNo )
	dw_key.SetItem(1, "BILL_GU",  tab_1.tabpage_3.dw_3.GetItemString(1, "BILL_GU"))   
	dw_key.SetItem(1, "BILL_JIGU",tab_1.tabpage_3.dw_3.GetItemString(1, "BILL_JIGU"))   
	dw_key.SetItem(1, "BILL_AMT", dBillAmt)
	dw_key.SetItem(1, "BMAN_DAT", sBmanDat)
	dw_key.SetItem(1, "BBAL_DAT", tab_1.tabpage_3.dw_3.GetItemString(1, "BBAL_DAT"))
	dw_key.SetItem(1, "BILL_BANK",tab_1.tabpage_3.dw_3.GetItemString(1, "BILL_BANK"))
	dw_key.SetItem(1, "BILL_NM",  tab_1.tabpage_3.dw_3.GetItemString(1, "BILL_NM"))
	dw_key.SetItem(1, "BILL_OWNER_GU",tab_1.tabpage_3.dw_3.GetItemString(1, "BILL_OWNER_GU"))
	dw_key.SetItem(1, "TEMP_BILL_YN",tab_1.tabpage_3.dw_3.GetItemString(1, "TEMP_BILL_YN"))
End If


If rb_new.Checked = True  Then
	/* 전표번호 채번 */
   sNgno = wf_get_junpyo_no(sNgdt,'X4')
	dw_key.SetItem(nCnt,'sabu',gs_sabu)
	dw_key.SetItem(nCnt,'ngno',sNgno)
	dw_key.SetItem(nCnt,'ngsts','10')
Else
   sNgno = Trim(dw_key.GetItemString(nCnt,'ngno'))	
End If

If IsNull(sNgno) Or sNgno = '' Then
	f_message_chk(57,'[Nego No.]')
	dw_key.SetColumn('ngno')
	Return
End If	


If wf_check_detail() <> 1 Then Return

/* -------------------------------------------------------------------- */
/* Invoice 관련내역 : nego detail                                       */
/* -------------------------------------------------------------------- */
nCnt = tab_1.tabpage_1.dw_1.RowCount()

/* 선수금 반제 처리된 매출 최대순번 */
select max(ngseq) into :nMax
  from expnegod
 where sabu = :gs_sabu and
       ngno = :sNgno;

If IsNull(nMax) Then nMax = 0;

For ix = 1 To nCnt
	sCino = Trim(tab_1.tabpage_1.dw_1.GetItemString(ix,'cino'))
	sPino = Trim(tab_1.tabpage_1.dw_1.GetItemString(ix,'pino'))

	/* C/I no. 필수 입력 */
//   If ( IsNull(sCino) Or sCino = '' ) and ( IsNull(sPino) Or sPino = '' ) Then
   If ( IsNull(sCino) Or sCino = '' )  Then
      f_message_chk(1400,'[C/I No.]')
	   tab_1.tabpage_1.dw_1.Setfocus()
	   tab_1.tabpage_1.dw_1.SetRow(nCnt)
	   tab_1.tabpage_1.dw_1.SetColumn('cino')	  
	   Return 1
   End If

   /* key setting */
   tab_1.tabpage_1.dw_1.SetItem(ix,'sabu',gs_sabu)
   tab_1.tabpage_1.dw_1.SetItem(ix,'ngno',sNgno)
   tab_1.tabpage_1.dw_1.SetItem(ix,'ngseq',ix + nMax)
	
	/* pi header에 nego 금액 설정 */
   old_amt = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt',Primary!,true)
	new_amt = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt',Primary!,false)
	If IsNull(old_amt ) Then old_amt = 0
	If IsNull(new_amt ) Then new_amt = 0
	
	If Not IsNull(sCino) And sCino <> '' Then
	  Choose Case tab_1.tabpage_1.dw_1.GetItemStatus(ix,0,Primary!) 
		  Case DataModified!
          nRtn = wf_update_pi_ngamt(sPino,new_amt - old_amt,'+')
   	  Case  NewModified!
		    nRtn =  wf_update_pi_ngamt(sPino,new_amt,'+')
			 
			 /* 자료생성구분 '1': NEGO,'2':INVOICE */
			 tab_1.tabpage_1.dw_1.SetItem(ix,'datagu','1')
	   End Choose

		If nRtn <> 1 Then
			Rollback ;
			Return
		End If
	End If
Next

/* Hs number setting */
dw_key.SetItem(1,'hsno',wf_find_hsno())

/* Fob 배분 */
wf_update_fob()

IF dw_key.Update() <> 1 THEN
	f_message_chk(32,'')
   ROLLBACK;
   Return
END IF

IF tab_1.tabpage_1.dw_1.Update() <> 1 THEN
	f_message_chk(32,'')	
   ROLLBACK;
   Return
END IF

sle_msg.text ='Invoice 관련내역을 저장하였습니다!!'
wf_protect_key(false)

COMMIT;

/* 수출비용 생성 : 선Nego상계자료(CI)도 포함 */
tab_1.tabpage_1.dw_1.SetRedraw(False)
tab_1.tabpage_1.dw_1.SetFilter("")
tab_1.tabpage_1.dw_1.Filter()

If wf_nego_charge(sNgno, srfgub) < 0 Then 
	tab_1.tabpage_1.dw_1.SetRedraw(True)
	Return
End If

tab_1.tabpage_1.dw_1.SetFilter(" datagu = '1' ")
tab_1.tabpage_1.dw_1.Filter()
tab_1.tabpage_1.dw_1.SetRedraw(True)

/* Interface Table update */
wf_update_interface(sNgno)

COMMIT;

/* 반제 처리 */
gs_code = sNgno
OPEN(w_sal_06090_popup)

wf_init()
sle_msg.text ='자료를 저장하였습니다!!'

end event

type cb_exit from w_inherite`cb_exit within w_sal_06090
end type

type cb_mod from w_inherite`cb_mod within w_sal_06090
end type

type cb_ins from w_inherite`cb_ins within w_sal_06090
end type

type cb_del from w_inherite`cb_del within w_sal_06090
end type

type cb_inq from w_inherite`cb_inq within w_sal_06090
end type

type cb_print from w_inherite`cb_print within w_sal_06090
integer x = 1047
integer y = 2548
integer taborder = 80
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_06090
end type

type cb_can from w_inherite`cb_can within w_sal_06090
end type

type cb_search from w_inherite`cb_search within w_sal_06090
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06090
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06090
end type

type rb_new from radiobutton within w_sal_06090
integer x = 59
integer y = 80
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "신규"
end type

event clicked;If This.Checked = True Then
   wf_protect_key(false)

	dw_key.SetRedraw(False)
   dw_key.Reset()
   dw_key.InsertRow(0)
   tab_1.tabpage_1.dw_1.Reset()
   tab_1.tabpage_2.dw_2.Reset()
	tab_1.tabpage_3.dw_3.Reset()

	cb_inq.Enabled  = True
	cb_ins.Enabled  = True
	cb_mod.Enabled  = True
	cb_search.Enabled  = True
	cb_del.Enabled  = True

	dw_key.SetFocus()
	dw_key.SetRow(1)
   dw_key.SetItem(dw_key.GetRow(),'ngdt','')	
	dw_key.SetColumn('ngdt')
	
	// 부가세 사업장 설정
	f_mod_saupj(dw_key, 'saupj')

	dw_key.SetRedraw(True)	
End If

end event

type rb_upd from radiobutton within w_sal_06090
integer x = 274
integer y = 80
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;If This.Checked = True Then
   wf_protect_key(true)

	dw_key.SetRedraw(False)	
   dw_key.Reset()
   dw_key.InsertRow(0)

   tab_1.tabpage_1.dw_1.Reset()
   tab_1.tabpage_2.dw_2.Reset()
	
	cb_inq.Enabled  = True
	cb_ins.Enabled  = True
	cb_mod.Enabled  = True
	cb_search.Enabled  = True
	cb_del.Enabled  = True

	// 부가세 사업장 설정
	f_mod_saupj(dw_key, 'saupj')
	
	dw_key.SetFocus()
	dw_key.SetRow(1)

   dw_key.SetItem(dw_key.GetRow(),'ngno','')	
	dw_key.SetColumn('ngno')
	dw_key.SetRedraw(True)	
End If

end event

type tab_1 from tab within w_sal_06090
integer x = 32
integer y = 1368
integer width = 4558
integer height = 960
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4521
integer height = 848
long backcolor = 32106727
string text = "Invoice 관련 내역"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_1 dw_1
end type

on tabpage_1.create
this.rr_3=create rr_3
this.dw_1=create dw_1
this.Control[]={this.rr_3,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.rr_3)
destroy(this.dw_1)
end on

type rr_3 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 24
integer width = 4494
integer height = 816
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within tabpage_1
event ue_key pbm_dwnkey
integer x = 23
integer y = 36
integer width = 4471
integer height = 796
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sal_06090_d"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

//For iPos = Len(sErrorSyntax) to 1 STEP -1
//	 sMsg = Mid(sErrorSyntax, ipos, 1)
//	 If sMsg   = sReturn or sMsg = sNewline Then
//		 iCount++
//	 End if
//Next
//
//sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)
//

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event itemchanged;String sPino, sCino, sNgno
dec    wrate, urate,weigh
Double ngamt, old_ngamt,new_ngamt,wamt,uamt, dPiJan
Long   nRow

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	/* 면장 번호 */
	Case 'expno'
		sCino = Trim(GetText())
		If IsNull(sCino) Or sCino = '' Then 
			MessageBox('확 인','삭제버튼으로 삭제하시기 바랍니다')
			cb_del.SetFocus()
			Return 2
		End If
	Case 'cino'
		sCino = Trim(GetText())
		If IsNull(sCino) Or sCino = '' Then 
			MessageBox('확 인','삭제버튼으로 삭제하시기 바랍니다')
			cb_del.SetFocus()
			Return 2
		End If
		
		/* CI No로 Invoice금액 설정 */
		If wf_setting_cipi(nRow, sCino) <= 0 Then		Return 2
	Case 'pino'
		sPino = Trim(GetText())
		If IsNull(sPino) Or sPino = '' Then 
			MessageBox('확 인','삭제버튼으로 삭제하시기 바랍니다')
			cb_del.SetFocus()
			Return 2
		End If
		
		sCino = wf_select_pino(row,sPino)
		SetItem(nRow,'cino',sCino)
		
		If IsNull(sCino) or sCino = '' Then
			SELECT PINO Into :sPino 
			  FROM EXPPIH 
			 WHERE SABU = :gs_sabu and
			       PINO = :sPino and
					 PISTS = '2';
					 
			If sqlca.sqlcode <> 0 Then
  			  f_message_chk(98,'[P/I NO]')
			  Return 1
		   End If
		End If
		
		sNgno = GetItemString(nRow,'ngno')
		wf_set_piamt(nRow, sNgno, sCino, sPino)

		SetColumn('ngamt')
	Case 'ngamt'
		new_ngamt = Double(GetText())
		
		/* Invoice 잔액 초과 안됨 */
		dPiJan = Round(GetItemNumber(nRow, 'pijan'),2)
		If dPiJan < new_ngamt Then
			MessageBox('확 인','건별 NEGO금액이 INVOICE잔액을 초과하였습니다')
			Return 2
		End If
		
		wrate = dw_key.GetitemNumber(1,'wrate')
		urate = dw_key.GetitemNumber(1,'urate')
		weigh = dw_key.GetitemNumber(1,'weight')
		If IsNull(wrate) or wrate = 0 Then wrate =  1
		If IsNull(urate) or urate = 0 Then urate =  1
		If IsNull(weigh) or weigh = 0 Then weigh =  1
		
		This.SetItem(nRow,'wamt',TrunCate(Round((new_ngamt * wrate)/weigh,2),0))
		This.SetItem(nRow,'uamt',TrunCate(Round((new_ngamt * urate)/weigh,2),2))
		
		Post wf_calc_sunsuamt()
End Choose
end event

event itemerror;return 1
end event

event rbuttondown;String sCino, sNgno
Long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
Choose Case GetColumnName()
	Case 'expno', 'cino'
		gs_code = 'A'
		gs_gubun = 'Y'
		gs_codename = 'Y' /* 면장발행자료 */
		Open(w_expci_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1

		/* CI No로 Invoice금액 설정 */
		If wf_setting_cipi(nRow, gs_code) <= 0 Then		Return 2
		
		SetColumn('ngamt')
	Case 'pino'
		gs_gubun = '2' // 수주확정된 자료만 
		open(w_exppih_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 1
		
		SetItem(nRow,'pino',gs_code)
		
		sCino = wf_select_pino(nRow,gs_code)
		SetItem(nRow,'cino',sCino)
		
		sNgno = GetItemString(nRow, 'ngno')
		wf_set_piamt(nRow, sNgno, sCino, gs_code)
		
		SetColumn('ngamt')
End Choose

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4521
integer height = 848
long backcolor = 32106727
string text = "Nego 비용"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_2 dw_2
end type

on tabpage_2.create
this.rr_4=create rr_4
this.dw_2=create dw_2
this.Control[]={this.rr_4,&
this.dw_2}
end on

on tabpage_2.destroy
destroy(this.rr_4)
destroy(this.dw_2)
end on

type rr_4 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 24
integer width = 4494
integer height = 816
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within tabpage_2
event ue_processenter pbm_dwnprocessenter
integer x = 23
integer y = 36
integer width = 4466
integer height = 792
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_06090_c"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;dec dAmt,wrate,weigh

Choose Case GetColumnName()
	Case 'costforamt'
		dAmt = Dec(GetText())

		wrate = dw_key.GetitemNumber(1,'wrate')
		weigh = dw_key.GetitemNumber(1,'weight')
		If IsNull(wrate) or wrate = 0 Then wrate =  1
		If IsNull(weigh) or weigh = 0 Then weigh =  1
		
		This.SetItem(row,'costamt',TrunCate(Round((dAmt * wrate)/weigh,2),0))
End Choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4521
integer height = 848
long backcolor = 32106727
string text = "어음정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
dw_3 dw_3
end type

on tabpage_3.create
this.rr_5=create rr_5
this.dw_3=create dw_3
this.Control[]={this.rr_5,&
this.dw_3}
end on

on tabpage_3.destroy
destroy(this.rr_5)
destroy(this.dw_3)
end on

type rr_5 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 24
integer width = 4494
integer height = 816
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_3 from datawindow within tabpage_3
event ue_enter pbm_dwnprocessenter
integer x = 27
integer y = 36
integer width = 4466
integer height = 792
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_sal_06090_h1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;Long nRow
String sDate, sNull

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)
Choose Case GetColumnName()
	Case 'bman_dat'         /* 만기일 */
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,'bman_dat',sNull)
	      Return 1
      END IF
End Choose
end event

type dw_key from datawindow within w_sal_06090
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 105
integer y = 220
integer width = 4384
integer height = 1116
integer taborder = 10
string dataobject = "d_sal_06090_h"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sNgno,sNull,sData,sdate, sSave, sBnkCd, sSaveNo, sCurr, sAbName
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
Long   nRow,nCnt, ix
dec    wrate,urate,weigh
Double dNgAmt

If rb_new.Checked <> True And rb_upd.Checked <> True Then
	f_message_chk(57,' 작업구분 선택')
	Return 2
End If

SetNull(sNull)

nRow  = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName()
	Case 'ngno'
	  sNgno = Trim(GetText())
	  IF sNgno = "" OR IsNull(sNgno) THEN RETURN

     SELECT COUNT(*)
       INTO :nCnt  
       FROM "EXPNEGOH"
      WHERE ( "EXPNEGOH"."SABU" = :gs_sabu ) AND  
            ( "EXPNEGOH"."NGNO" = :sNgno );
		
	  IF nCnt <=0 THEN
		 f_message_chk(33,'[Nego No.]')
       SetItem(nRow,'ngno',sNull)
		 Return 1
	  ELSE
		 cb_inq.TriggerEvent(Clicked!)
	  END If
	Case 'ngdt'         // 접수일자
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,GetColumnName(),sNull)
	      Return 1
      END IF

      sCurr = GetItemString(row,'curr')
	   wf_calc_curr(nRow, sDate, sCurr ) /* 환율과 Nego 금액 계산 */
	Case 'setsch'         // 결제만기일 
		sdate = Trim(GetText())
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
      	SetItem(nRow,GetColumnName(),sNull)
	      Return 1
      END IF
  Case 'ngbank'
   	select fun_get_cvnas(:data) into :scvnas from dual;
		If Trim(scvnas) = '' Then 
	      SetItem(1,GetColumnName(),sNull)
	      SetItem(1,GetColumnName()+'nm', sNull)
			Return 1
		Else	
	      SetItem(1,GetColumnName()+'nm', scvnas)
      End If
	/* Buyer */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
//			SetItem(1,"saupj",   	ssaupj)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	Case 'explcno'  // LC접수번호
		gs_code = Trim(GetText())
	
   	If wf_select_lcno(1,gs_code) = 1 Then
			return 1
 	   End If
	/* Nego 금액 */
   Case 'ngamt'
		dNgamt = Double(GetText())

		wrate = dw_key.GetitemNumber(1,'wrate')
		urate = dw_key.GetitemNumber(1,'urate')
		weigh = dw_key.GetitemNumber(1,'weight')
		If IsNull(wrate) or wrate = 0 Then wrate =  1
		If IsNull(urate) or urate = 0 Then urate =  1
		If IsNull(weigh) or weigh = 0 Then weigh =  1
		
		SetItem(nRow,'wamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
		SetItem(nRow,'uamt',TrunCate(Round((dNgamt * urate)/weigh,2),2))
		
		Post wf_calc_sunsuamt()
	/* 통화 */
	Case 'curr'
		sCurr = Trim(GetText())
		sDate = dw_key.GetItemString(nRow,'ngdt')
			
		wf_calc_curr(nRow, sDate, sCurr)
	/* 원화환율 */
  Case 'wrate'
		wrate = Double(GetText())
		weigh = GetItemNumber(nRow,'weight')
		dNgAmt = GetItemNumber(nRow,'ngamt')

		If IsNull(weigh) or weigh = 0 Then weigh = 1
    SetItem(nRow,'wamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
		
    /* Nego Detail의 원화금액 */
    For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
	    dNgamt = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt')
	
	    tab_1.tabpage_1.dw_1.SetItem(ix,'wamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
    Next

    /* 비용의 원화금액 */
    For ix = 1 To tab_1.tabpage_2.dw_2.RowCount()
	    dNgamt = tab_1.tabpage_2.dw_2.GetItemNumber(ix,'costforamt')
	
	    tab_1.tabpage_2.dw_2.SetItem(ix,'costamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
    Next
	 
	/* 미화환율 */
  Case 'urate'
		urate = Double(GetText())
		weigh = GetItemNumber(nRow,'weight')
		dNgAmt = GetItemNumber(nRow,'ngamt')
		
		If IsNull(weigh) or weigh = 0 Then weigh = 1		
    SetItem(nRow,'uamt',TrunCate((dNgamt * urate)/weigh,2))
		
    /* Nego Detail의 미화금액 */
    For ix = 1 To tab_1.tabpage_1.dw_1.RowCount()
	    dNgamt = tab_1.tabpage_1.dw_1.GetItemNumber(ix,'ngamt')
	
	    tab_1.tabpage_1.dw_1.SetItem(ix,'uamt',TrunCate(Round((dNgamt * urate)/weigh,2),2))
    Next

	/* 예금코드 입력시 */
	Case "save_code"
		sSave = GetText()
		//************************************************
		Select bnk_cd, ab_no, ab_name Into :sBnkcd, :sSaveNo, :sAbName
		From   kfm04ot0
		Where  ab_dpno = :sSave;
		//************************************************
		if sqlca.Sqlcode <> 0 then
 			f_Message_Chk(33, '[예적금코드]')
			SetItem(1, "save_code", sNull)
			SetItem(1, "ab_name", sNull)
			SetItem(1, "ab_no", sNull)
			return 1
		else
			SetItem(1, "ab_name", sAbName)
			SetItem(1, "ab_no", sSaveNo)
		end if
	/* 예금코드 입력시 */
	Case "sv_code"
		sSave = GetText()
		//************************************************
		Select bnk_cd, ab_no, ab_name Into :sBnkcd, :sSaveNo, :sAbName
		From   kfm04ot0
		Where  ab_dpno = :sSave;
		//************************************************
		if sqlca.Sqlcode <> 0 then
 			f_Message_Chk(33, '[예적금코드]')
			SetItem(1, "sv_code", sNull)
			SetItem(1, "sv_ab_name", sNull)
			SetItem(1, "sv_ab_no", sNull)
			return 1
		else
			SetItem(1, "sv_ab_name", sAbName)
			SetItem(1, "sv_ab_no", sSaveNo)
		end if
	/* Nego 금액(원화예적금) */
   Case 'svngamt'
		dNgamt = Double(GetText())

		wrate = dw_key.GetitemNumber(1,'svwrate')
		weigh = dw_key.GetitemNumber(1,'weight')
		If IsNull(wrate) or wrate = 0 Then wrate =  1
		If IsNull(weigh) or weigh = 0 Then weigh =  1
		
		SetItem(nRow,'svngwamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
	/* Nego 금액(외화예적금) */
   Case 'svngfamt'
		dNgamt = Double(GetText())

		wrate = dw_key.GetitemNumber(1,'svwrate')
		weigh = dw_key.GetitemNumber(1,'weight')
		If IsNull(wrate) or wrate = 0 Then wrate =  1
		If IsNull(weigh) or weigh = 0 Then weigh =  1
		
		SetItem(nRow,'ingamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
	/* 원화예적금 적용환율 */
	Case 'svwrate'
		wrate = Double(GetText())
		weigh = GetItemNumber(nRow,'weight')
		dNgAmt = GetItemNumber(nRow,'svngamt')
		
		If IsNull(weigh) or weigh = 0 Then weigh = 1
		SetItem(nRow,'svngwamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
		
		dNgAmt = GetItemNumber(nRow,'svngfamt')
		SetItem(nRow,'ingamt',TrunCate(Round((dNgamt * wrate)/weigh,2),0))
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string s_colnm

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

s_colnm = GetColumnName() 
Choose Case s_colnm
	Case "ngno"                              // nego 접수번호 선택 popup 
		If rb_upd.Checked = False Then Return // 수정일 경우만...
		
		gs_gubun = Left(is_today,6)+'01' + is_today
   	Open(w_expnego_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"ngno",gs_code)

		P_inq.TriggerEvent(Clicked!)
	Case "explcno"                              // lc 접수번호 선택 popup 
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,"explcno",gs_code)
		Post wf_select_lcno(1,gs_code)
	Case "ngbank" 
		gs_gubun = '3' //은행
   	Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN

		SetItem(1,s_colnm,gs_code)
		SetItem(1,s_colnm+'nm',gs_codename)
	/* Buyer */
	Case "cvcod"
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
   /* 예적금코드에 Right 버턴클릭시 Popup 화면 */
	Case "save_code"
		gs_code = GetText()
		Open(w_kfm04ot0_popup)
		
		if gs_code = "" or isnull(gs_code) then return
		
		SetItem(1, "save_code", gs_code)
		SetItem(1, "ab_name", gs_codename)
		SetItem(1, "ab_no", gs_gubun)
   /* 예적금코드에 Right 버턴클릭시 Popup 화면 */
	Case "sv_code"
		gs_code = GetText()
		Open(w_kfm04ot0_popup)
		If gs_code = "" Or isnull(gs_code) Then Return
		
		SetItem(1, "sv_code", gs_code)
		
		SetItem(1, "sv_ab_name", gs_codename)
		SetItem(1, "sv_ab_no", gs_gubun)
END Choose

end event

event retrievestart;SetRedraw(False)
end event

event retrieveend;SetRedraw(True)
end event

type cb_ban from commandbutton within w_sal_06090
boolean visible = false
integer x = 1426
integer y = 2544
integer width = 361
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "반제처리"
end type

event clicked;String sNgno

sNgno = Trim(dw_key.GetItemString(1,'ngno'))
If IsNull(sNgno) Or sNgno = '' Then Return

OPEN(w_sal_06090_popup)
end event

type pb_1 from u_pb_cal within w_sal_06090
integer x = 2528
integer y = 224
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('ngdt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'ngdt', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06090
integer x = 4320
integer y = 672
integer width = 78
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('setsch')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'setsch', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 200
integer width = 4562
integer height = 1140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_06090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 60
integer width = 471
integer height = 120
integer cornerheight = 40
integer cornerwidth = 55
end type

