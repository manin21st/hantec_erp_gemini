$PBExportHeader$w_sal_06050.srw
$PBExportComments$C/I 등록
forward
global type w_sal_06050 from w_inherite
end type
type tab_1 from tab within w_sal_06050
end type
type tabpage_1 from userobject within tab_1
end type
type rr_5 from roundrectangle within tabpage_1
end type
type dw_insert_1 from u_key_enter within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_5 rr_5
dw_insert_1 dw_insert_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_4 from roundrectangle within tabpage_2
end type
type dw_insert_2 from u_key_enter within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_4 rr_4
dw_insert_2 dw_insert_2
end type
type tabpage_3 from userobject within tab_1
end type
type rr_3 from roundrectangle within tabpage_3
end type
type dw_2 from datawindow within tabpage_3
end type
type dw_1 from datawindow within tabpage_3
end type
type dw_insert_3 from u_key_enter within tabpage_3
end type
type dw_calc from u_key_enter within tabpage_3
end type
type cb_1 from commandbutton within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_3 rr_3
dw_2 dw_2
dw_1 dw_1
dw_insert_3 dw_insert_3
dw_calc dw_calc
cb_1 cb_1
end type
type tabpage_4 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_4
end type
type dw_insert_4 from u_key_enter within tabpage_4
end type
type tabpage_4 from userobject within tab_1
rr_2 rr_2
dw_insert_4 dw_insert_4
end type
type tab_1 from tab within w_sal_06050
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_key from datawindow within w_sal_06050
end type
type rb_new from radiobutton within w_sal_06050
end type
type rb_upd from radiobutton within w_sal_06050
end type
type pb_1 from u_pb_cal within w_sal_06050
end type
type rr_1 from roundrectangle within w_sal_06050
end type
end forward

global type w_sal_06050 from w_inherite
integer width = 4731
integer height = 3732
string title = "COMMERCIAL INVOICE 등록"
tab_1 tab_1
dw_key dw_key
rb_new rb_new
rb_upd rb_upd
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_06050 w_sal_06050

type variables
boolean    ib_down
boolean    ib_cfm     // 출고확정여부
int            drag_start_row,drag_end_row
int            drag_ciseq
string       drag_cino
string        is_junpyo_gb     // 전표채번구분
String       isNgno[]             // 상계처리된 Nego번호
int             iiNgseq  
end variables

forward prototypes
public function integer wf_clear_item (integer nrow)
public function integer wf_select_pino (integer row, string pino, double piseq)
public function integer wf_create_packing (integer rcnt)
public function integer wf_separate_pl (integer row, double new)
public function integer wf_merge_pl (integer fr_row, integer to_row)
public function integer wf_delete_pl (string cino, integer ciseq)
public function string wf_get_junpyo_no (string cidate, string sordergbn)
public function integer wf_calc_curr (integer nrow, string sdate, string scurr)
public function integer wf_get_picharge (integer nrow, string scvcod, string spino)
public function integer wf_copy_buyer (string scvcod)
public function integer wf_get_multi_picharge (integer nrow)
public function integer wf_max_plseq (integer nrow)
public function integer wf_check_nego (string arg_cino, string arg_cvcod)
public function integer wf_separate_pl2 (integer row, long ctfrom, long ctto)
public function integer wf_check_nego_charge ()
public function integer wf_multi_pino (integer nrow)
public function long wf_cal_carton ()
public subroutine wf_init ()
public subroutine wf_protect_key (string gb)
public function integer wf_copy_last_buyer (string arg_cvcod)
end prototypes

public function integer wf_clear_item (integer nrow);String sNull

SetNull(snull)

tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"piseq",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"itdsc",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ispec",snull)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"order_spec",'.')
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ciqty",0)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ciprc",0)
tab_1.tabpage_2.dw_insert_2.SetItem(nRow,"ciamt",0)

Return 1
end function

public function integer wf_select_pino (integer row, string pino, double piseq);string  s_pino,s_itnbr,s_itdsc,s_ispec,s_order_spec, sPono
dec	  d_piqty,d_piamt,d_piprc,d_itmprc,d_itmamt,d_wamt,d_uamt,dHoldQty,dCiQty, dNewCiQty, dInvoiceQty
long    ll_found

dec     dMinQty, dMaxQty, dSeqNo
String  sPangb, sAmtgu

ll_found = tab_1.tabpage_2.dw_insert_2.Find("pino = '" + pino + "' and piseq = " + string(piseq),&
                                            1,tab_1.tabpage_2.dw_insert_2.RowCount())
If ll_found > 0 Then
	f_message_chk(1,'')
	Return 1
End If

  SELECT "EXPPID"."PINO",         "EXPPID"."ITNBR",  "ITEMAS"."ITDSC",  "ITEMAS"."ISPEC",   
         "EXPPID"."ORDER_SPEC",   "EXPPID"."PIQTY",  "EXPPID"."PIAMT" , "EXPPID"."PIPRC",
		   "EXPPID"."ITMPRC",       "EXPPID"."ITMAMT", "EXPPID"."WAMT",   "EXPPID"."UAMT",
		   "EXPPID"."CIQTY",        "EXPPID"."MINQTY", "EXPPID"."MAXQTY", "EXPPID"."PANGB",
         "EXPPID"."AMTGU",        "EXPPID"."SEQNO"
    INTO :s_pino,                 :s_itnbr,          :s_itdsc,          :s_ispec,   
         :s_order_spec,           :d_piqty,          :d_piamt,          :d_piprc,
		   :d_itmprc,               :d_itmamt,         :d_wamt,           :d_uamt,
		   :dCiQty,						 :dMinQty,			  :dMaxQty,				:sPangb,
			:sAmtgu,						 :dSeqNo
    FROM "EXPPID",            "ITEMAS"
   WHERE ( "EXPPID"."SABU"  = "ITEMAS"."SABU" ) and  
         ( "EXPPID"."ITNBR" = "ITEMAS"."ITNBR" ) and  
         ( "EXPPID"."PINO"  = :pino ) AND  
         ( "EXPPID"."PISEQ" = :piseq ) AND  
         ( "EXPPID"."SABU"  = :gs_sabu );

If sqlca.sqlcode <> 0 Then	Return 1

/* 기사용된 Pi수량 Check */
dNewCiQty = d_piqty - dCiQty
If dNewCiQty <= 0 Then
	f_message_chk(130,'[선택하신 품목의 수량이 다른 CI에 등록되었습니다]')
	Return 1
End If

/* 출고 수량 */
select nvl(s.hold_qty ,0) - nvl(s.out_qty ,0), s.invoice_qty - s.out_qty, s.cv_order_no
  into :dHoldQty, :dInvoiceQty, :sPono
  from sorder s
 where s.pino  = :pino and
		 s.piseq = :piseq ;

If IsNull(dHoldQty) Then dHoldQty = 0
If IsNull(dCiQty)   Then dCiQty = 0

tab_1.tabpage_2.dw_insert_2.SetItem(row,'pino',  pino)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'piseq', piseq)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'cv_order_no', sPono)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'itnbr', s_itnbr)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'itdsc', s_itdsc)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'ispec', s_ispec)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'order_spec',s_order_spec)

tab_1.tabpage_2.dw_insert_2.SetItem(row,'ciqty', dNewCiQty)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'ciamt', TrunCate(Round(dNewCiQty,2)* Round(d_piprc,5),2))

tab_1.tabpage_2.dw_insert_2.SetItem(row,'ciprc', d_piprc)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'itmprc',d_itmprc)
tab_1.tabpage_2.dw_insert_2.SetItem(Row,'itmamt',TrunCate(Round(dNewCiQty,2) * Round(d_itmprc,5),2)) // 품목금액


tab_1.tabpage_2.dw_insert_2.SetItem(row,'hold_qty',	dHoldQty)		/* 할당수량 */
tab_1.tabpage_2.dw_insert_2.SetItem(row,'invoice_qty',dInvoiceQty)	/* 출고수량 */

tab_1.tabpage_2.dw_insert_2.SetItem(row,'minqty', dMinQty)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'maxqty', dMaxQty)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'seqno',  dSeqNo)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'pangb',  sPangb)
tab_1.tabpage_2.dw_insert_2.SetItem(row,'amtgu',  sAmtgu)

Return 0
end function

public function integer wf_create_packing (integer rcnt);//-------------------------------------------------//
// 품목정보를 가지고 PACKING LIST 작성             //
//-------------------------------------------------//
String s_sabu,s_cino,s_itdsc,s_ispec, s_pono, sJijil, sIspecCode
Long   l_ciseq,l_ciqty,l_plseq,l_qtypct,l_plqty, maxctno, tmpno
int    ix,nRow, i


tab_1.tabpage_2.dw_insert_2.AcceptText()
If tab_1.tabpage_2.dw_insert_2.RowCount() <= 0 then Return -1

//l_plseq = wf_max_plseq() + 1

For ix = rcnt To rcnt
  s_sabu  = gs_sabu
  s_cino  = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'cino'))
  s_itdsc = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'itdsc'))  
  s_ispec = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'ispec'))
  sJijil			= Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'jijil'))
  sIspecCode	= Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'ispec_code'))
  
  s_pono  = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'cv_order_no'))
  l_ciseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'ciseq')
  l_ciqty = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'ciqty')
  If IsNull(s_itdsc) Then s_itdsc = ''
  If IsNull(s_ispec) Then s_ispec = ''  
  If IsNull(s_itdsc) Then s_itdsc = ''  
  If IsNull(l_ciseq) Then l_ciseq = 0
  If IsNull(l_ciqty) Then l_ciqty = 0
  
   nRow = tab_1.tabpage_3.dw_insert_3.InsertRow(0)
	
	tmpno = 0
	
	for i = 1 to nRow
		maxctno = tab_1.tabpage_3.dw_insert_3.getitemnumber(i, 'ctto')
		if maxctno > tmpno then tmpno = maxctno
	Next
	
	if maxctno = 0 or isNull(maxctno) then 
		maxctno = 1
	else
		maxctno = maxctno + 1
	end if
	
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'sabu',s_sabu)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'cino',s_cino)  
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'ctfrom', maxctno)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'ctto',   maxctno)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'itdsc',s_itdsc)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'ispec',s_ispec)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'jijil',sJijil)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'ispec_code',sIspeccode)
	tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'pono',s_pono)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'ciseq',l_ciseq)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'qtypct',l_ciqty)  
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'plqty',l_ciqty)
   tab_1.tabpage_3.dw_insert_3.SetItem(nRow,'plseq',1)    /* 초기 값은 '1' */
   l_plseq += 1
Next

Return 1
end function

public function integer wf_separate_pl (integer row, double new);//----------------------------------------------------------//
// packing list 분할                                        //
//----------------------------------------------------------//
double old,new2
Long   newRow, nCtFrom, nCtTo, i, j
Long   lctfrom2, lctto2

old = tab_1.tabpage_3.dw_insert_3.GetItemNumber(row,'qtypct')
If old = 0 Or IsNull(old) Then Return 1
If new >= old Then Return 1            // 분할은 적은 수로

new2 = old - new

/* Packing Qty 계산 */
nCtFrom = tab_1.tabpage_3.dw_insert_3.GetItemNumber(row,'ctfrom')
If IsNull(nCtFrom) Then Return 1

nCtTo = tab_1.tabpage_3.dw_insert_3.GetItemNumber(row,'ctto')
If IsNull(nCtTo) Then  nCtTo = nCtFrom

tab_1.tabpage_3.dw_insert_3.SetItem(row,'qtypct',new2)
tab_1.tabpage_3.dw_insert_3.SetItem(row,'plqty', new2*(nCtTo - nCtFrom + 1))

tab_1.tabpage_3.dw_insert_3.RowsCopy(row,row, Primary!,tab_1.tabpage_3.dw_insert_3, row, Primary!)

tab_1.tabpage_3.dw_insert_3.SetItem(Row,'qtypct',new)
tab_1.tabpage_3.dw_insert_3.SetItem(row,'plqty', new*(nCtTo - nCtFrom + 1))
tab_1.tabpage_3.dw_insert_3.SetItem(Row,'plseq', wf_max_plseq(row) + 1)

for i = Row + 1 to tab_1.tabpage_3.dw_insert_3.Rowcount()
	lctto2   = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i - 1, 'ctto')
	lctfrom2 = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i - 1, 'ctfrom')
	
	if i = Row + 1 then
		tab_1.tabpage_3.dw_insert_3.SetItem(i, 'ctfrom', lctto2 + 1)
		tab_1.tabpage_3.dw_insert_3.SetItem(i, 'ctto'  , lctto2 + 1)
	else
		nCtFrom = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i, 'ctfrom')
		nCtTo   = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i, 'ctto')		
		
		tab_1.tabpage_3.dw_insert_3.SetItem(i, 'ctfrom', lctfrom2 + 1)
		tab_1.tabpage_3.dw_insert_3.SetItem(i, 'ctto'  , lctfrom2 + 1 + nCtto - nCtfrom)
	end if
	
	j++
Next

Return 1
end function

public function integer wf_merge_pl (integer fr_row, integer to_row);//----------------------------------------------------------//
// packing list 병합                                        //
//----------------------------------------------------------//
string fr_cino,to_cino
int    fr_ciseq,to_ciseq
double fr_qtypct,to_qtypct,tot_qtypct,fr_plqty,to_plqty, to_ctfrom

int newRow

fr_cino = Trim(tab_1.tabpage_3.dw_insert_3.GetItemSTring(fr_row,'cino'))
to_cino = Trim(tab_1.tabpage_3.dw_insert_3.GetItemSTring(to_row,'cino'))
If fr_cino <> to_cino Then Return 1

fr_ciseq = tab_1.tabpage_3.dw_insert_3.GetItemNumber(fr_row,'ciseq')
to_ciseq = tab_1.tabpage_3.dw_insert_3.GetItemNumber(to_row,'ciseq')
If fr_ciseq <> to_ciseq Then Return 1

to_ctfrom = tab_1.tabpage_3.dw_insert_3.GetItemNumber(to_row,'ctfrom')

/* Packing Qty */
fr_plqty = tab_1.tabpage_3.dw_insert_3.GetItemNumber(fr_row,'plqty')
If IsNull(fr_plqty) Then fr_plqty = 0
to_plqty = tab_1.tabpage_3.dw_insert_3.GetItemNumber(to_row,'plqty')
If IsNull(to_plqty) Then to_plqty = 0
tab_1.tabpage_3.dw_insert_3.SetItem(to_row,'plqty',fr_plqty + to_plqty)

/* Qty Per Carton */
//fr_qtypct = tab_1.tabpage_3.dw_insert_3.GetItemNumber(fr_row,'qtypct')
//If IsNull(fr_qtypct) Then fr_qtypct = 0
//
//to_qtypct = tab_1.tabpage_3.dw_insert_3.GetItemNumber(to_row,'qtypct')
//If IsNull(to_qtypct) Then to_qtypct = 0
//
//tot_qtypct = fr_qtypct + to_qtypct
//
//tab_1.tabpage_3.dw_insert_3.SetItem(to_row,'qtypct',tot_qtypct)

tab_1.tabpage_3.dw_insert_3.SetItem(to_row,'ctto',  to_ctfrom)
tab_1.tabpage_3.dw_insert_3.SetItem(to_row,'qtypct',fr_plqty + to_plqty)

/* 삭제 */
tab_1.tabpage_3.dw_insert_3.DeleteRow(fr_row)

Return 0
end function

public function integer wf_delete_pl (string cino, integer ciseq);//----------------------------------------------------------------//
// cino,ciseq로 packing list를 삭제한다                           //
//----------------------------------------------------------------//
int nRowCnt,nRow


nRowCnt = tab_1.tabpage_3.dw_insert_3.Rowcount()
If nRowCnt <=0 Then Return  1

Do While True
	nRow = tab_1.tabpage_3.dw_insert_3.Find("cino = '" + cino + "' and ciseq = " + string(ciseq) ,1,nRowCnt)
   If nRow <=0 Then Exit
	
	If tab_1.tabpage_3.dw_insert_3.DeleteRow(nRow) <> 1 Then Return -1
Loop

Return 1
end function

public function string wf_get_junpyo_no (string cidate, string sordergbn);String  sOrderNo
string  sMaxOrderNo

//sOrderGbn = 'X2'

sMaxOrderNo = STring(sqlca.fun_junpyo(gs_sabu,cidate,sOrderGbn),'000')

IF Double(sMaxOrderNo) <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	SetNull(sOrderNo)
	Return sOrderNo
END IF

sOrderNo = cidate + sMaxOrderNo

COMMIT;

Return sOrderNo
end function

public function integer wf_calc_curr (integer nrow, string sdate, string scurr);Dec {2}   wrate
Dec {4}   urate
String    weight

select x.rstan,x.usdrat, y.rfna2
  into :wrate,:urate, :weight
  from ratemt x, reffpf y
 where x.rcurr = y.rfgub(+) and
       y.rfcod = '10' and
       x.rdate = :sdate and
       x.rcurr = :scurr;

If IsNull(weight) Or weight = '' Then weight = '0'
If IsNull(wrate) Or wrate = 0 Then wrate = 0.0
If IsNull(urate) Or wrate = 0 Then urate = 0.0
		 
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_wrate',wrate)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_urate',urate)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'weight',Double(weight))

Return 0


end function

public function integer wf_get_picharge (integer nrow, string scvcod, string spino);/* Pi No 입력시 관련 Charge를 가져온다 */
Long nCnt, ix
string sChrgu, sSaupj
Double dChrAmt
dec    wrate, urate, weigh

DataStore ds2

ds2 = Create datastore
ds2.DataObject = 'd_sal_06050_ds2'
ds2.SetTransObject(sqlca)

sSaupj = dw_key.GetItemString(1, 'saupj')

/* 원화금액,외화금액 계산 */
wrate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'expcih_wrate')
urate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'expcih_urate')
weigh = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'weight')
If IsNull(wrate) Or wrate = 0 Then wrate = 1
If IsNull(urate) Or urate = 0 Then urate = 1
If IsNull(weigh) Or weigh = 0 Then weigh = 1

nCnt = 0

/* 조회 */
ds2.Retrieve(gs_sabu, sPino, sCvcod, sSaupj)

For ix = 1 To ds2.RowCount()
	sChrgu 	= Trim(ds2.GetItemString(ix, 'chrgu'))
	dChrAmt	= ds2.GetItemNumber(ix, 'chramt')
	
	If sqlca.sqlcode <> 0 Then Exit
	If nCnt > 0 Then nRow = tab_1.tabpage_4.dw_insert_4.InsertRow(nRow)
	
	nCnt += 1
	tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'pino',sPino)
	tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'chrgu',sChrgu)
	tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'chramt',dChramt)
	tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'wamt',TrunCate((dChramt * wrate)/weigh,0))
	tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'uamt',TrunCate((dChramt * urate)/weigh,2))
Next
Destroy ds2

If ncnt <= 0 Then
	MessageBox('확 인','P/I Charge 가 등록되어있지 않습니다.!!')
	Return 1
Else
	Return 0
End If
end function

public function integer wf_copy_buyer (string scvcod);String sSeller, sConSignee, sVf_From, sVf_To, sCurr, sCiDate, sBuyer, sOther_Ref, sremark, sshipmark, scinotes
String sTerm
Long   nRow

nRow = tab_1.tabpage_1.dw_insert_1.GetRow()
If nRow <= 0 Then Return -1

/* Buyer의 기본정보를 가져온다 */

  SELECT "EXPCIH"."SELLER",         "EXPCIH"."CONSIGNEE",   
         "EXPCIH"."VF_FROM",        "EXPCIH"."VF_TO",       "EXPCIH"."CURR"  ,
			"EXPCIH"."BUYER",          "EXPCIH"."OTHER_REF",	"EXPCIH"."REMARK", "EXPCIH"."SHIPMARK", "EXPCIH"."CINOTES",
			"EXPCIH"."TERM_DELI_PAY"
    INTO :sSeller,                     :sConSignee,   
	      :sVf_From,                    :sVf_To,                     :sCurr,
		   :sBuyer,                      :sOther_ref,		:sRemark, :sshipmark, :scinotes,
			:sterm
    FROM "EXPCIH"  
   WHERE "EXPCIH"."CINO"  = ( SELECT MAX("EXPCIH"."CINO") 
			                          FROM "EXPCIH" 
								               WHERE "EXPCIH"."CVCOD" = :sCvcod AND
															       "EXPCIH"."CIDATE" = ( SELECT MAX("EXPCIH"."CIDATE") 
																		                         FROM "EXPCIH"
																													WHERE "EXPCIH"."CVCOD" = :sCvcod )) ;
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_seller',sSeller)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_consignee',sConsignee)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_vf_from',sVf_From)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_vf_to',sVf_From)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_curr',sCurr)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_buyer',sBuyer)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_other_ref',sOther_ref)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_remark',sRemark)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_shipmark',sShipmark)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_cinotes',scinotes)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_term_deli_pay',sterm)

// 환율 계산
sCiDate = dw_key.GetItemString(1,'cidate')
If Not IsNull(sCurr) Then wf_calc_curr(1,sCiDate,sCurr)

tab_1.tabpage_1.dw_insert_1.SetItemStatus(nRow, 0,Primary!, NewModified!	)

Return 1
end function

public function integer wf_get_multi_picharge (integer nrow);Long     rtn, ix, ll_found
String   sCino, sPino, sPono, sChrgu
Double   dChrAmt, wrate, urate, weigh

datastore ds_multi
ds_multi = Create Datastore

sCino = Trim(dw_key.GetItemString(1,'cino'))
If IsNull(sCino) Or sCino = '' Then    Return -1

/*  Pi Charge 선택하는 데이타원도우를 연결 */
ds_multi.DataObject = 'd_exppich_popup'

/* ClipBoard의 내용을 copy한다 */
rtn = ds_multi.ImportClipBoard()
If rtn <=0 Then Return 0

/* 원화금액,외화금액 계산 */
wrate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'expcih_wrate')
urate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'expcih_urate')
weigh = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'weight')
If IsNull(wrate) Or wrate = 0 Then wrate = 1
If IsNull(urate) Or urate = 0 Then urate = 1
If IsNull(weigh) Or weigh = 0 Then weigh = 1

For ix = 1 To rtn
   sPino   = ds_multi.GetItemString(ix,"pino")
   sPono   = ds_multi.GetItemString(ix,"exppih_pono")
   sChrgu  = ds_multi.GetItemString(ix,"chrgu")
   dChramt = ds_multi.GetItemNumber(ix,"chramt")

   ll_found = tab_1.tabpage_4.dw_insert_4.Find("pino = '" + sPino + "' and chrgu = '" + sChrgu + "'",1,tab_1.tabpage_4.dw_insert_4.RowCount())	
   If ll_found > 0 Then Continue
		
   /* data insertion */
   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'pino',  sPino)
   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'chrgu', sChrgu)
   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'chramt',dChramt)
   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'wamt',TrunCate((dChramt * wrate)/weigh,0))
   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'uamt',TrunCate((dChramt * urate)/weigh,2))

   If ix = rtn Then Exit
   nRow = tab_1.tabpage_4.dw_insert_4.InsertRow(nRow)

   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'sabu',gs_sabu)
   tab_1.tabpage_4.dw_insert_4.SetItem(nRow,'cino',sCino)
Next

/* ClipBoard Clear */
ds_multi.Reset()
ds_multi.SaveAs("dummy",Clipboard!,false) 

Return 0
end function

public function integer wf_max_plseq (integer nrow);/* 같은 ci no,seq중에서 최대값 */
String sCino, sCinoTemp
long   rowcnt,nMax
int    ix,itemp, iCiSeq , iCiSeqTemp

rowcnt = tab_1.tabpage_3.dw_insert_3.RowCount()  // 최대 plseq 구함
If rowcnt <=0 Then Return 0

sCino  = tab_1.tabpage_3.dw_insert_3.GetItemString(nRow,'cino')
iCiSeq = tab_1.tabpage_3.dw_insert_3.GetItemNumber(nRow,'ciseq')

nMax = 1
If rowcnt > 0 Then
  For ix = 1 To rowcnt
	 sCinoTemp  = tab_1.tabpage_3.dw_insert_3.GetItemString(ix,'cino')
	 If IsNull(sCinoTemp) or sCinoTemp = '' Then Continue

	 iCiSeqTemp = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'ciseq')
	 If IsNull(iCiSeqTemp) or iCiSeqTemp = 0 Then Continue

	 If sCino <> sCinoTemp or iCiseq <> iCiSeqTemp Then Continue
	 
    itemp = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'plseq')
    nMax = Max(nMax,itemp)
  Next
End If

Return nMax

end function

public function integer wf_check_nego (string arg_cino, string arg_cvcod);/* 선 Nego내역이 존재하면 해당 Nego No.를 입력받는다 */
Double dSunSu, dMaxSeq, dCiamt, dCiWamt, dCiuamt, dSunsuWamt, dSunsuUamt
Double dNgAmt, dNgWamt, dNgUamt, dNgWrate, dNgUrate, weight
Long   ix, iy
String sFrom, sTo, sNgno, sPino
DataStore ds_nego, ds3

iiNgseq = 0

select a.mind, a.maxd, nvl(sum(a.sunsu) ,0)
  into :sFrom,      :sTo,        :dSunSu
  from ( select x.ngno, min(x.ngdt) as mind, max(x.ngdt) as maxd, x.ngamt - sum(nvl(y.ngamt,0)) as sunsu 
			  from expnegoh x, expnegod y
			 where x.sabu = y.sabu(+) and
					 x.ngno = y.ngno(+) and
					 x.sabu = :gs_sabu and
					 x.cvcod = :arg_cvcod
			 group by x.ngno, x.ngamt
			 having x.ngamt - sum(nvl(y.ngamt,0)) > 0 ) a
 group by a.mind, a.maxd;

/* 선수금이 없으면 종료 */
If IsNull(dSunSu) Then Return 0
If dSunSu <= 0 Then Return 0

/* Ci,Pi No별 수출금액(Charge포함)  조회 */
ds3 = Create datastore
ds3.DataObject = 'd_sal_06050_ds3'
ds3.SetTransObject(sqlca)
ds3.Retrieve(gs_sabu, arg_cino)

MessageBox('확 인','선수금내역이 존재합니다~r~r해당 Nego내역을 선택하십시요!')

/* 선Nego 내역 */
ds_nego = create datastore
ds_nego.DataObject = 'd_expnego_sunsu_popup'

Do While True
	gs_code = arg_cvcod
	gs_gubun = sFrom+sTo
	open(w_expnego_sunsu_popup)
	If IsNull(gs_code) Then Return 0
	
	/* ClipBoard의 내용을 copy한다 */
	ds_nego.Reset()
	ds_nego.ImportClipBoard()
	If ds_nego.RowCount() <= 0 Then Return 0

	For ix = 1 To ds_nego.RowCount()
		If arg_cvcod <> ds_nego.GetItemSTring(ix,'cvcod') Then
			MessageBox('확 인','Buyer가 서로 다릅니다~r동일한 Buyer의 Nego를 선택하세요!!')
			Continue
		End If		
	Next
	
	Exit
Loop

/* 가중치 */
weight = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'weight')
If IsNull(weight) Then weight = 1

/* 선수금 초기화 */
dSunSu = 0
ix = 0

SetPointer(HourGlass!)

For iy = 1 To ds3.RowCount()
	/* 수출매출 읽음 */
	sPino		= Trim(ds3.GetItemString(iy, 'pino'))
	dCiamt	= ds3.GetItemNumber(iy, 'ciamt')
	dCiWamt	= ds3.GetItemNumber(iy, 'wamt')
	dCiuamt	= ds3.GetItemNumber(iy, 'uamt')
	
	If IsNull(dCiAmt)  Then dCiAmt = 0
	If IsNull(dCiWAmt) Then dCiWAmt = 0
	If IsNull(dCiUAmt) Then dCiUAmt = 0
	
	/* 다음처리할 선수금을 읽는다. */
	DO WHILE true
		/* 처리할 매출액이 없을 경우 Exit */
		If dCiAmt <= 0 Then Exit
		
		If dSunSu = 0 Then		
			ix += 1
			If ix > ds_nego.RowCount() Then Exit
			
			sNgno  	  = ds_nego.GetItemString(ix,'ngno')
			dSunSu 	  = ds_nego.GetItemNumber(ix,'sunsu')
			dSunSuwamt = ds_nego.GetItemNumber(ix,'sunsuwamt')
			dSunSuuamt = ds_nego.GetItemNumber(ix,'sunsuuamt')
		
			/* Nego 환율 */
			dNgWrate = ds_nego.GetItemNumber(ix,'wrate')
			dNgUrate = ds_nego.GetItemNumber(ix,'urate')
			If IsNull(dNgWrate) Or dNgWrate = 0 Then dNgWrate = 1
			If IsNull(dNgUrate) Or dNgUrate = 0 Then dNgUrate = 1
			
			/* Nego의 Max순번 */
			Select nvl(max(ngseq),0) into :dMaxSeq
			  from expnegod
			 where sabu = :gs_sabu and
					 ngno = :sNgno;
		End If
	
		/* 선수금액이 수출매출보다 클경우 */
		If dSunsu > dCiAmt Then
			dNgAmt  = dCiAmt
			dNgWAmt = Truncate(Round((dCiAmt * dNgWrate)/weight,2),0)
			dNgUAmt = Truncate(Round((dCiAmt * dNgUrate)/weight,2),2)	
		Else
			dNgAmt  = dSunsu
			dNgWAmt = dSunsuWAmt
			dNgUAmt = dSunsuUAmt			
		End If
		
		/* 처리된 선수금은 제외 */
		dSunSu     -= dNgAmt
		dSunSuWAmt -= dNgWAmt
		dSunSuUAmt -= dNgUAmt

		/* 처리된 매출액은 제외 */
		dCiAmt  = dCiAmt  - dNgAmt
		dCiWAmt = dCiWAmt - dNgWAmt
		dCiUAmt = dCiUAmt - dNgUAmt
		
		/* Nego Detail 작성 */
		dMaxSeq += 1
		insert into expnegod
				  ( "SABU",       "NGNO",      "NGSEQ",           "CINO",   
					 "PINO",       "NGAMT",     "WAMT",            "UAMT",       "DATAGU" )
		 values ( :gs_sabu,    :sNgno,      :dMaxSeq,          :arg_cino,
					 :sPino,       :dNgAmt,     :dNgWamt,          :dNgUamt, 	 '2' );
	
		If sqlca.sqlcode <> 0 Then
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			MessageBox('확 인','Nego자료 생성중 오류가 발생했습니다!!')
			Return -1
		End If
		
		/* 처리된 Nego번호 기록 */
		iiNgSeq += 1
		isNgNo[iiNgSeq] = sNgno
	LOOP
Next

Destroy ds_nego
Destroy ds3

Return 0
end function

public function integer wf_separate_pl2 (integer row, long ctfrom, long ctto);//----------------------------------------------------------//
// packing list 분할                                        //
//----------------------------------------------------------//
double old,new2
Long   newRow, nCtFrom, nCtTo
Long   lCartonQty, lPlQty, lQtyPerCt, lNewPlQty, i
Long   lctfrom2, lctto2

/* Carton 수량 */
lCartonQty = Ctto - CtFrom + 1

/* Carton당 수량 */
lPlQty 	 = tab_1.tabpage_3.dw_insert_3.GetItemNumber(row, 'plqty')
lQtyPerCt = TrunCate(lPlQty / lCartonQty,0)

tab_1.tabpage_3.dw_insert_3.SetItem(row,'qtypct', lQtyPerCt)

lNewPlQty = lQtyPerCt * lCartonQty
tab_1.tabpage_3.dw_insert_3.SetItem(row,'plqty',  lNewPlQty)

If lPlQty > lNewPlQty Then
	tab_1.tabpage_3.dw_insert_3.RowsCopy(row,row, Primary!,tab_1.tabpage_3.dw_insert_3, row, Primary!)

	lNewPlQty = lPlQty - lNewPlQty
	tab_1.tabpage_3.dw_insert_3.SetItem(Row,'ctfrom',ctfrom)
	tab_1.tabpage_3.dw_insert_3.SetItem(Row,'ctto',  ctfrom)
	tab_1.tabpage_3.dw_insert_3.SetItem(Row,'qtypct',lNewPlQty)
	tab_1.tabpage_3.dw_insert_3.SetItem(row,'plqty', lNewPlQty)
	tab_1.tabpage_3.dw_insert_3.SetItem(Row,'plseq', wf_max_plseq(row) + 1)	
	
	for i = Row + 1 to tab_1.tabpage_3.dw_insert_3.Rowcount()
		lctto2   = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i - 1, 'ctto')
		tab_1.tabpage_3.dw_insert_3.SetItem(i, 'ctfrom', lctto2 + 1)
		
		lctfrom2 = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i, 'ctfrom')
		lctto2   = tab_1.tabpage_3.dw_insert_3.GetItemnumber(i, 'ctto')
		lctto2   = lctto2 - lctfrom2 + 1		
		tab_1.tabpage_3.dw_insert_3.SetItem(i, 'ctto'  , tab_1.tabpage_3.dw_insert_3.GetItemnumber(i - 1, 'ctto') + 1 + lctto2)
	Next
	
End If

//tab_1.tabpage_3.dw_insert_3.SetSort('ctfrom A,plseq A')
//tab_1.tabpage_3.dw_insert_3.Sort()

Return 1
end function

public function integer wf_check_nego_charge ();string sCostCd, sCostNo, sCurr, sNgdt, sCino, sPino, sNgno
Dec{2} dCostAmt,dCostForAmt,dCostAmtd,dCostForAmtd,dNgamt,dTotAmt
Dec{5} dDivRate
Dec{2} dSumAmtd,dSumForAmtd
Long   rCnt,iy, nCnt, ix, iz

/* Nego등록시 사용되는 송장 및 비용 dw 사용한다 */
DataStore ds1, ds2

If iiNgSeq <= 0 Then Return 0

/* Invoice 관련내역 */
ds1 = Create datastore
ds1.DataObject = 'd_sal_06090_d'
If ds1.SetTransObject(sqlca) <> 1 Then Return -1

/* Nego비용 내역 */
ds2 = Create datastore
ds2.DataObject = 'd_sal_06090_c'
If ds2.SetTransObject(sqlca) <> 1 Then Return -1

For iz = 1 To iiNgSeq
	sNgno = isNgNo[iz]
	
	/* 필터링 조건을 지운다( datagu = '1') */
	ds1.SetFilter("")
	ds1.Filter()
	
	/* Invoice 관련내역 조회 */
	ds1.Retrieve(gs_sabu, sNgno)

	/* Nego비용 내역 */
	If ds2.Retrieve(gs_sabu, sNgno) <= 0 Then Return 0
	
	/* 수출비용 detail 작성 */
	For ix = 1 To ds2.RowCount()
		sCostNo = ds2.GetItemString(ix,'costno')
		
		DELETE FROM EXPCOSTD	 WHERE SABU = :gs_sabu AND COSTNO = :sCostNo;
		If sqlca.sqlcode <> 0 Then
			f_message_chk(160,'')
			RollBack;
			Return -1
		End If
	
		/* 배분할 비용금액 */
		dCostAmt = ds2.GetItemNumber(ix,'costamt')
		dCostForAmt = ds2.GetItemNumber(ix,'costforamt')
	
		nCnt = ds1.RowCount()
		
		/* 매출확정된 nego 금액만 처리대상 : CI,PI No 입력*/
		If nCnt > 0 Then
			dTotAmt = ds1.GetItemNumber(1,'sum_ngamt')
	 
			dSumAmtd = 0
			dSumForAmtd = 0
			For iy = 1 To nCnt
				/* Ci 가 없으면 생성하지 않는다 */
				sCino = ds1.GetItemString(iy,'cino')
				sPino = ds1.GetItemString(iy,'pino')
				If IsNull(sCino) Or sCino = '' Then Continue
				
				/* 수출비용 배분율 계산 */
				dNgAmt = ds1.GetItemNumber(iy,'ngamt')
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
		
				sPino = ds1.GetItemString(iy,'pino')
				INSERT INTO "EXPCOSTD"  
						 ( "SABU",           "COSTNO",          "COSTSEQ",      "CINO",
							"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
							"NGNO" )  
				VALUES ( :gs_sabu,        :sCostNo,          :iy,            :sCino,   
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
					 ( "SABU",           "COSTNO",          "COSTSEQ",      "CINO",
						"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
						"NGNO" )  
			 VALUES ( :gs_sabu,        :sCostNo,          1,            	NULL,   
						 NULL,          	 :dCostAmt,         0,              :dCostForAmt,
						 :sNgno ) ;
			If sqlca.sqlcode <> 0 Then
				f_message_chk(160,'')
				RollBack;
				Return -1
			End If
		End If
	Next
Next

Destroy ds1
Destroy ds2

Return 0
end function

public function integer wf_multi_pino (integer nrow);string  s_cino,s_pino,s_itnbr,s_itdsc,s_ispec,s_order_spec, sPono, sOrderNo, sJijil, sIspecCode
double  d_piqty,d_piamt,d_piprc,d_itmprc,d_itmamt
long    nMax,RowCnt,itemp,ix,l_piseq,l_ciseq,ll_found
int     rtn
String  sCvcod, sSaupj

datastore ds_multi
ds_multi = Create Datastore

/* P/I기준으로 읽어올 경우 : ClipBoard의 내용을 copy한다 */
ds_multi.DataObject = 'd_exppid_popup'
rtn = ds_multi.ImportClipBoard()

/* key check */
If rtn <=0 Then 
	f_message_chk(50,'')
	Return 0
End If

s_cino = Trim(dw_key.GetItemString(1,'cino'))
If IsNull(s_cino) Or s_cino = '' Then    Return -1

/* Next ci seq selection */
rowcnt = tab_1.tabpage_2.dw_insert_2.RowCount()
nMax = 1
If rowcnt > 0 Then
   For ix = 1 To rowcnt
     itemp = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'ciseq')
     nMax = Max(nMax,itemp)
   Next
   nMax = nMax + 1
End If

For ix = 1 To rtn
	s_pino   = ds_multi.GetItemString(ix,"pino")
	l_piseq  = ds_multi.GetItemNumber(ix,"piseq")
	s_itnbr  = ds_multi.GetItemString(ix,"itnbr")
	s_itdsc  = ds_multi.GetItemString(ix,"itdsc")
	s_ispec  = ds_multi.GetItemString(ix,"ispec")
	sJijil   = ds_multi.GetItemString(ix,"jijil")
	sispecCode  = ds_multi.GetItemString(ix,"ispec_code")
	s_order_spec = ds_multi.GetItemString(ix,"order_spec")
	d_piqty  = ds_multi.GetItemNumber(ix,"piqty")
	d_piamt  = ds_multi.GetItemNumber(ix,"piamt")
	d_piprc  = ds_multi.GetItemNumber(ix,"piprc")
	d_itmprc = ds_multi.GetItemNumber(ix,"itmprc")
	d_itmamt = ds_multi.GetItemNumber(ix,"itmamt")
	
	sPono  	= ds_multi.GetItemString(ix,"pono")
	
	ll_found = tab_1.tabpage_2.dw_insert_2.Find("pino = '" + s_pino + "' and piseq = " + string(l_piseq),1,tab_1.tabpage_2.dw_insert_2.RowCount())	
	If ll_found > 0 Then Continue

	/* data insertion */
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'pino',s_pino)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'piseq',l_piseq)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'cv_order_no',spono)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'order_no',sOrderNo)
	
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'itnbr',s_itnbr)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'itdsc',s_itdsc)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'ispec',s_ispec)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'jijil',sJijil)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'ispec_code',sIspeccode)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'order_spec',s_order_spec)
	
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'ciqty',d_piqty)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'ciamt',d_piamt)
	
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'ciprc',d_piprc)
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'itmprc',d_itmprc)
	
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'itmamt', truncate(d_piqty * d_itmprc,2)) // 품목금액
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'wamt',0)
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'uamt',0)

	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'hold_qty', ds_multi.GetItemNumber(ix,"hold_qty"))	/* 할당수량 */
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'invoice_qty', d_piqty)	/* 출고의뢰수량 */
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'ioqty', ds_multi.GetItemNumber(ix,"ioqty"))	/* 출고수량 */
	
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'minqty', ds_multi.GetItemNumber(ix,"minqty"))
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'maxqty', ds_multi.GetItemNumber(ix,"maxqty"))
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'seqno',  ds_multi.GetItemNumber(ix,"seqno"))
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'pangb',  ds_multi.GetItemString(ix,"pangb"))
	tab_1.tabpage_2.dw_insert_2.SetItem(nrow,'amtgu',  ds_multi.GetItemString(ix,"amtgu"))
	
	/* Packing List 작성 */
	l_Ciseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,'ciseq')
	If Not IsNull(l_Ciseq) Then  wf_delete_pl(s_Cino,l_ciseq)
	
	wf_create_packing(nRow)
	
	If ix = rtn Then Return 0
	nRow = tab_1.tabpage_2.dw_insert_2.InsertRow(0)
	
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'sabu',gs_sabu)
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'cino',s_cino)
	tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'ciseq',nMax)
	nMax += 1
Next

Return 0
end function

public function long wf_cal_carton ();//---------------------------------------------------------//

// Carton 수량 계산                                        //
//---------------------------------------------------------//
Long   ix,iy,nRow,i_ctfrom,i_ctto,i_ctqty,nSub,i_qtypct,i_sum_ctqty
string s_cino

If tab_1.tabpage_3.dw_insert_3.AcceptText() <> 1 Then Return 1
nRow = tab_1.tabpage_3.dw_insert_3.Rowcount()
If nRow <=0 Then Return 1

tab_1.tabpage_3.dw_insert_3.SetRedraw(False)
tab_1.tabpage_3.dw_insert_3.SetSort('ctfrom A,plseq A')
tab_1.tabpage_3.dw_insert_3.Sort()

For ix = 1 To nRow
    i_ctfrom = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'ctfrom')
    i_ctto   = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'ctto')
	 
 	 If IsNull(i_ctfrom) Then
	 	f_message_chk(40,' FROM 입력')
		tab_1.tabpage_3.dw_insert_3.SetFocus()
		tab_1.tabpage_3.dw_insert_3.SetRow(ix)
		tab_1.tabpage_3.dw_insert_3.SetColumn('ctfrom')
		Return 1
	End If

   If IsNull(i_ctto) Or i_ctto = 0 Then 
		i_ctto = i_ctfrom
		tab_1.tabpage_3.dw_insert_3.SetItem(ix,'ctto',i_ctto)
	End If

	/* carton별 qty 구함 for row */
	tab_1.tabpage_3.dw_insert_3.Setitem(ix,'ctqty',i_ctto - i_ctfrom + 1 )
Next

/* carton별 qty를 다시 구함 */
For ix = 1 to nRow - 1
  iy = ix + 1
  i_ctto   = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'ctto')
  
  For iy = ix + 1 To tab_1.tabpage_3.dw_insert_3.RowCount()
	  i_ctfrom = tab_1.tabpage_3.dw_insert_3.GetItemNumber(iy,'ctfrom')
	  If IsNull(i_ctto ) Or i_ctto = 0 Then i_ctto = i_ctfrom
	  
	  nSub = i_ctto - i_ctfrom + 1
	  If nSub > 0 Then 
		 i_ctqty = tab_1.tabpage_3.dw_insert_3.GetItemNumber(iy,'ctqty')
	
		 nSub = i_ctqty - nSub
		 If nSub < 0 Then nSub = 0
		 tab_1.tabpage_3.dw_insert_3.SetItem(iy,'ctqty',nSub)
	  End If
	Next
Next

/* 총 carton qty를 구함 */
i_sum_ctqty = 0
For ix = 1 To nRow
	i_ctqty  = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'ctqty')
	i_qtypct = tab_1.tabpage_3.dw_insert_3.GetItemNumber(ix,'qtypct')
	
	i_sum_ctqty += i_ctqty
	
	/* Pl 수량 = Carton qty * qty per Carton */
	If i_ctqty = 0 Then 
		i_ctqty = 1
		tab_1.tabpage_3.dw_insert_3.SetItem(ix,'ctqty',i_ctqty )
	End If

/* 10.6 */
//	tab_1.tabpage_3.dw_insert_3.SetItem(ix,'plqty',i_ctqty * i_qtypct)
Next

tab_1.tabpage_3.dw_insert_3.Object.ctqty_sum.text = string(i_sum_ctqty,'#,##0')

tab_1.tabpage_3.dw_insert_3.SetRedraw(True)

/* expcih에 ctqty 저장 */
//s_cino  = tab_1.tabpage_3.dw_insert_3.GetItemString(1,'cino')
//UPDATE "EXPCIH"  
//   SET "CTQTY" = :i_sum_ctqty  
// WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
//       ( "EXPCIH"."CINO" = :s_cino );

//If sqlca.sqlcode <> 0 Then
//	RollBack;
//	Return -1
//End IF

tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_ctqty', i_sum_ctqty)

Return 1
end function

public subroutine wf_init ();RollBack;
ib_any_typing = False
rb_new.Checked = True

rb_new.TriggerEvent(Clicked!)      // 신규입력받을 수 있도록 상태 변환
end subroutine

public subroutine wf_protect_key (string gb);dw_key.SetRedraw(False)

/* 수정 */
Choose Case gb 
	Case '수정'
		dw_key.Modify('cino.protect = 0')
//		dw_key.Modify('saupj.protect = 1')
		dw_key.Modify("localyn.protect = 0")
		
		tab_1.tabpage_1.dw_insert_1.Modify('exppih_curr.protect = 1')
	Case '신규'
		If is_junpyo_gb = 'Y' Then // 자동채번 
			dw_key.Modify('cino.protect = 1')
		Else
			dw_key.Modify('cino.protect = 0')
		End If
		dw_key.Modify('cvcod.protect = 0')
//		dw_key.Modify('saupj.protect = 0')
		dw_key.Modify("localyn.protect = 0")
		tab_1.tabpage_1.dw_insert_1.Modify('exppih_curr.protect = 1')
		
		/* 품목기준 */
		dw_key.Modify('yebi1.protect = 0')
	Case '조회'
		dw_key.Modify('cino.protect = 1')
		dw_key.Modify('cvcod.protect = 1')
		dw_key.Modify("localyn.protect = 1")
End Choose

ib_cfm = False

dw_key.SetRedraw(True)
end subroutine

public function integer wf_copy_last_buyer (string arg_cvcod);String sSeller, sConSignee, sVf_From, sVf_To, sCurr, sCiDate, sBuyer, sOther_Ref, sremark, sshipmark, scinotes
String sterm
Long   nRow

nRow = tab_1.tabpage_1.dw_insert_1.GetRow()
If nRow <= 0 Then Return -1

/* Buyer의 기본정보를 가져온다 */

  SELECT "EXPCIH"."SELLER",         "EXPCIH"."CONSIGNEE",   
         "EXPCIH"."VF_FROM",        "EXPCIH"."VF_TO",       "EXPCIH"."CURR"  ,
			"EXPCIH"."BUYER",          "EXPCIH"."OTHER_REF",	"EXPCIH"."REMARK", "EXPCIH"."SHIPMARK", "EXPCIH"."CINOTES",
			"EXPCIH"."TERM_DELI_PAY"
    INTO :sSeller,                     :sConSignee,   
	      :sVf_From,                    :sVf_To,             :sCurr,
		   :sBuyer,                      :sOther_ref,		:sRemark, :sshipmark, :scinotes,
			:sterm
    FROM "EXPCIH"  
   WHERE "EXPCIH"."CINO"  = ( SELECT MAX("EXPCIH"."CINO") 
			                          FROM "EXPCIH" 
								               WHERE "EXPCIH"."PLANDATE" = :arg_Cvcod AND
															"EXPCIH"."CIDATE" = ( SELECT MAX("EXPCIH"."CIDATE") 
															                        FROM "EXPCIH"
																							WHERE "EXPCIH"."PLANDATE" = :arg_Cvcod )) ;
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_seller',sSeller)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_consignee',sConsignee)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_vf_from',sVf_From)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_vf_to',sVf_From)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_curr',sCurr)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_buyer',sBuyer)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_other_ref',sOther_ref)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_remark',sRemark)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_shipmark',sShipmark)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_cinotes',scinotes)
tab_1.tabpage_1.dw_insert_1.SetItem(1,'expcih_term_deli_pay',sterm)

Return 1
end function

on w_sal_06050.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_key=create dw_key
this.rb_new=create rb_new
this.rb_upd=create rb_upd
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_key
this.Control[iCurrent+3]=this.rb_new
this.Control[iCurrent+4]=this.rb_upd
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_sal_06050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_key)
destroy(this.rb_new)
destroy(this.rb_upd)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_key.SetTransObject(sqlca)
dw_key.InsertRow(0)

tab_1.tabpage_1.dw_insert_1.SetTransObject(sqlca)
tab_1.tabpage_2.dw_insert_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_insert_3.SetTransObject(sqlca)
tab_1.tabpage_4.dw_insert_4.SetTransObject(sqlca)
tab_1.tabpage_3.dw_calc.SetTransObject(sqlca)
tab_1.tabpage_3.dw_calc.InsertRow(0)
tab_1.tabpage_3.dw_calc.SetTransObject(sqlca)

tab_1.tabpage_3.dw_1.InsertRow(0)
tab_1.tabpage_3.dw_1.SetTransObject(sqlca)

tab_1.tabpage_3.dw_2.InsertRow(0)
tab_1.tabpage_3.dw_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_2.visible = False

/* 전표 채번 구분 : 'Y'-자동채번,'N'-수입력*/
is_junpyo_gb = f_get_syscnfg('S',6,'40')


wf_init()

end event

type dw_insert from w_inherite`dw_insert within w_sal_06050
boolean visible = false
integer x = 46
integer y = 2520
integer width = 1435
integer height = 312
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_sal_06050
boolean visible = false
integer x = 3863
integer y = 2444
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sal_06050
boolean visible = false
integer x = 3689
integer y = 2444
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sal_06050
boolean visible = false
integer x = 3758
integer y = 2444
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sal_06050
integer x = 3749
integer y = 16
end type

event p_ins::clicked;call super::clicked;string scino
int    nRow,nMax,ix,itemp,rCnt
dwItemStatus l_status

If dw_key.AcceptText() <> 1 Then Return

/* 일반정보를 등록후 품목을 입력할 수 있도록 */
l_status = tab_1.tabpage_1.dw_insert_1.GetItemStatus(1, 0, Primary!)
If l_status = New! Or l_status = NewModified! Or l_status = DataModified! Then
   f_message_chk(57,'[일반정보 저장]')
   Return 
End If

scino = dw_key.GetItemString(1,'cino')

Choose Case tab_1.SelectedTab
   /* 품목등록 -> Packing List는 자동으로 생성됨*/
	Case 2
		rCnt = tab_1.tabpage_2.dw_insert_2.RowCount()
		
		nMax = 1
		If rCnt > 0 Then
			For ix = 1 To rCnt
				itemp = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'ciseq')
				nMax = Max(nMax,itemp)
			Next
			nMax = nMax + 1
		End If

     nRow = tab_1.tabpage_2.dw_insert_2.InsertRow(0)
     tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'sabu',gs_sabu)
	  tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'cino',scino)
     tab_1.tabpage_2.dw_insert_2.SetItem(nRow,'ciseq',nMax)
     tab_1.tabpage_2.dw_insert_2.SetItemStatus(nrow, 0,Primary!, NotModified!)
     tab_1.tabpage_2.dw_insert_2.SetItemStatus(nrow, 0,Primary!, New!)

	  tab_1.tabpage_2.dw_insert_2.SetFocus()
	  tab_1.tabpage_2.dw_insert_2.ScrollToRow(nRow)
	  tab_1.tabpage_2.dw_insert_2.SetRow(nRow)
	  tab_1.tabpage_2.dw_insert_2.SetColumn('pino')
   /* Charge 등록 */
	Case 4
     nRow = tab_1.tabpage_4.dw_insert_4.InsertRow(0)
End Choose
end event

type p_exit from w_inherite`p_exit within w_sal_06050
integer y = 16
end type

type p_can from w_inherite`p_can within w_sal_06050
integer y = 16
end type

event p_can::clicked;call super::clicked;wf_init()
end event

type p_print from w_inherite`p_print within w_sal_06050
boolean visible = false
integer x = 3931
integer y = 2444
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_sal_06050
integer x = 3575
integer y = 16
end type

event p_inq::clicked;call super::clicked;string scino,sts, sExplcno, ssaupj
Long   nRow,ix,nCnt, rowcount
double ciamt, dLcJan

If rb_new.Checked = True Then Return  //신규이면 조회불가

If dw_key.AcceptText() <> 1 Then Return
 
scino = Trim(dw_key.GetItemString(1,'cino'))
If IsNull(scino) Or scino = '' Then
   f_message_chk(1400,'[C/I NO]')
	Return 1
End If

sSaupj = Trim(dw_key.GetItemString(1,'saupj'))

SetPointer(HourGlass!)
If dw_key.Retrieve(gs_sabu,scino) <= 0 Then
   sle_msg.Text = '조회한 자료가 없습니다.!!'
	nRow = dw_key.InsertRow(0)
	dw_key.SetRow(nRow)
	dw_key.SetColumn('cino')
	return 
End If

wf_protect_key('조회')

tab_1.tabpage_1.dw_insert_1.Retrieve(gs_sabu,scino)        // 일반정보 조회

nRow = tab_1.tabpage_2.dw_insert_2.Retrieve(gs_sabu,scino) // 품목정보 조회

tab_1.tabpage_3.dw_insert_3.Retrieve(gs_sabu,scino, sSaupj)  // packing list 조회
tab_1.tabpage_4.dw_insert_4.Retrieve(gs_sabu,scino)  // charge 조회

/* 출고확정 여부 */
sts = Trim(tab_1.tabpage_1.dw_insert_1.GetItemstring(1,'expcih_cists'))
If sts = '2' or sts = '3' Then
	/* 매출이월 여부 */
   SELECT COUNT(*)   INTO :nCnt
     FROM "KIF05OT0"
	 WHERE CINO = :sCino;

   If nCnt > 0 Then
		sle_msg.Text = '회계전송 처리된 자료입니다.!!'
	Else

		/* Nego 여부 */
		select COUNT(*) into :nCnt
		  from EXPNEGOD
		 where sabu = :gs_sabu and
				 cino = :Scino and
				 datagu = '1';

		If  nCnt > 0 Then
			sle_msg.Text = 'Nego 처리된 자료입니다.!!'
		End If
	End If
	
	If sts = '2' Then
		sle_msg.Text = '출고승인 처리된 자료입니다.!!'
	End If
	
	ib_cfm = True
	p_del.Enabled    = false
	
   tab_1.tabpage_2.dw_insert_2.Modify('ciqty.protect = 1')
	
	tab_1.tabpage_2.dw_insert_2.Modify('pino.protect = 1')
	tab_1.tabpage_2.dw_insert_2.Modify('piseq.protect = 1')
	
	tab_1.tabpage_4.dw_insert_4.Modify('pino.protect = 1')
	tab_1.tabpage_4.dw_insert_4.Modify('chramt.protect = 1')
Else
	ib_cfm = False
	p_del.Enabled    = True
	
	/* 수주의 품번,사양과 ci의 품번,사양이 동일한지 check */
	rowcount = tab_1.tabpage_2.dw_insert_2.RowCount()
	For ix = rowcount To 1 Step -1
		If tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'itnbr') <> tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'sorder_itnbr') Then
			MessageBox('확 인','수주품번과 일치 하지 않습니다~r~n' + &
		   	                '확인후 재등록하십시요!!~r~n~r~n' + &
									 '[품명 :' + tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'itdsc') + ']~r~n' + &
									 '[사양 :' + tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'order_spec'))
			Continue
		ElseIf tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'order_spec') <> tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'sorder_order_spec') Then
			MessageBox('확 인','수주품번의 사양이 일치 하지 않습니다~r~n' + &
			                   '확인후 재등록하십시요!!~r~n~r~n' + &
									 '[품명 :' + tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'itdsc') + ']~r~n' + &
									 '[사양 :' + tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'order_spec'))
			Continue
		End If
	Next

	tab_1.tabpage_2.dw_insert_2.Modify('ciqty.protect = 0')
	tab_1.tabpage_2.dw_insert_2.Modify('pino.protect = 0')
	tab_1.tabpage_2.dw_insert_2.Modify('piseq.protect = 0')
	tab_1.tabpage_4.dw_insert_4.Modify('pino.protect = 0')
	tab_1.tabpage_4.dw_insert_4.Modify('chramt.protect = 0')
End If

/* L/C 잔액 */
sExplcno = Trim(tab_1.tabpage_1.dw_insert_1.GetItemstring(1,'expcih_explcno'))
If Not IsNull(sExplcNo ) Then
	SELECT NVL("EXPLC"."LCAMT" - "EXPLC"."CIAMT",0)
	  INTO :dLcjan
	  FROM "EXPLC"  
	 WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
			 ( "EXPLC"."EXPLCNO" = :sExplcno );

	If IsNull(dLcJan) Then dLcJan = 0
	tab_1.tabpage_1.dw_insert_1.SetItem(1,"lcamt_jan",dLcJan)
	tab_1.tabpage_1.dw_insert_1.SetItemStatus(1, 0, Primary!, NotModified!)
End If

end event

type p_del from w_inherite`p_del within w_sal_06050
integer y = 16
end type

event p_del::clicked;call super::clicked;string sCino, s_pino,s_chagu, sIpJpNo, sPacNo, sCvcod
int    nRow,i_ciseq,i_piseq,nRowCnt
dec    d_ciamt

sCvcod = Trim(dw_key.GetItemString(1, 'cvcod'))
sCino  = Trim(dw_key.GetItemString(1, 'cino'))

Choose Case tab_1.selectedtab
	/* 일반정보 삭제 */
	Case 1
		nRow  = tab_1.tabpage_1.dw_insert_1.GetRow()
		If nRow <=0 Then Return
		
		sCino = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(nRow,'expcih_cino'))
		If IsNull(sCino) Or sCino = '' Then
			f_message_chk(1400,' C/I NO')
			Return 1
		End If
	  
		IF MessageBox("삭 제",sCino + "의 모든 자료가 삭제됩니다." +"~n~n" +&
						 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

		If dw_key.GetItemString(1, 'localyn') = 'Y' Then
			UPDATE IMHIST
				SET INV_NO  = NULL,
					 INV_SEQ = 0
			 WHERE INV_NO = :sCino;
			
			If sqlca.sqlcode <> 0 Or sqlca.sqlnrows < 0 Then
				rollback;
				MessageBox('확 인','송장연결취소 실패하였습니다.!!')
				Return
			End If
		End If
				
     // 일반정보 삭제
     tab_1.tabpage_1.dw_insert_1.DeleteRow(tab_1.tabpage_1.dw_insert_1.GetRow())
     If tab_1.tabpage_1.dw_insert_1.Update() <> 1 Then 
		  f_message_chk(32,'[일반정보]')
		  RollBack;
		  Return
	  End If

     // 품목정보 삭제
     nRowCnt = tab_1.tabpage_2.dw_insert_2.RowCount()
	  If nRowCnt > 0 Then 
       tab_1.tabpage_2.dw_insert_2.RowsMove(1,nRowCnt,Primary!,tab_1.tabpage_2.dw_insert_2,1,Delete! )

       If tab_1.tabpage_2.dw_insert_2.Update() <> 1 Then 
		    f_message_chk(32,'[품목정보]')
		    RollBack;
		    Return
	    End If
	  End If

     // Packing List 삭제
     delete expcipl  where sabu = :gs_sabu and   cino = :sCino ;
     If sqlca.sqlcode <> 0 Then 
	    f_message_chk(32,'[Packing List]')
	    RollBack;
	    Return
	  End If

     // Charge 삭제
	  delete expcich   where sabu = :gs_sabu and   cino = :sCino ;
     If sqlca.sqlcode <> 0 Then 
	    f_message_chk(32,'[Charge]')
	    RollBack;
	    Return
	  End If

     COMMIT;
	  
	  wf_init() // 초기화	  
	Case 2                               // 품목정보 개별 삭제
		nRow  = tab_1.tabpage_2.dw_insert_2.GetRow()
		If nRow <=0 Then Return
		
		sCino   = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'cino'))
		s_pino  = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'pino'))
		i_ciseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,'ciseq')
		i_piseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(nRow,'piseq')

		sPacNo = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(nRow,'ip_jpno'))

		/* Pi기준으로 품목을 구성한 경우 */
		If IsNull(sPacNo) Or sPacNo = '' Then
			IF MessageBox("삭 제",s_pino + ' ' + STring(i_piseq) + "의  자료가 삭제됩니다." +"~n~n" +&
					 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
			
			If tab_1.tabpage_2.dw_insert_2.DeleteRow(nRow) <> 1 Then Return
			
			IF wf_delete_pl(sCino,i_ciseq) = 1 THEN                 // 관련 packing list 삭제
				If tab_1.tabpage_3.dw_insert_3.Update() = 1 THEN 
					IF tab_1.tabpage_2.dw_insert_2.Update() <> 1 THEN 
						rollback;
						return
					End If
				Else
					RollBack;
					Return
				End If
			End If
		/* 포장정보로 품목을 구성한 경우 */
		Else
			IF MessageBox("삭 제","품목정보가 모두 삭제됩니다." +"~n~n" +&
									 	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
			
			If tab_1.tabpage_2.dw_insert_2.RowsMove(1, tab_1.tabpage_2.dw_insert_2.RowCount(), &
			                                        Primary!, tab_1.tabpage_2.dw_insert_2, 1, Delete!) <> 1 Then
				rollback;
				F_MESSAGE_CHK(32,'[품목정보]')
				Return
			End If
			
			If tab_1.tabpage_3.dw_insert_3.RowsMove(1, tab_1.tabpage_3.dw_insert_3.RowCount(), &
			                                        Primary!, tab_1.tabpage_3.dw_insert_3, 1, Delete!) <> 1 Then
				rollback;
				F_MESSAGE_CHK(32,'[품목정보]')
				Return
			End If
			
			If tab_1.tabpage_3.dw_insert_3.Update() = 1 THEN 
				IF tab_1.tabpage_2.dw_insert_2.Update() <> 1 THEN 
					rollback;
					return
				End If
			End If

			/* 포장정보에 CI NO 기록 */
			If Not IsNull(sCino) Then
				UPDATE PACLSTH
					SET CINO = NULL
				 WHERE SABU = :gs_sabu AND
						 PACNO = :sPacNo AND
						 CVCOD = :sCvcod AND
						 CINO = :sCino;
		
				If sqlca.sqlcode <> 0 Then				 
					ROLLBACK;
					F_MESSAGE_CHK(32,'[포장정보]')
					Return
				END IF
			End If
		End If
  Case 4                             // CHARGE 정보 개별 삭제
	  nRow  = tab_1.tabpage_4.dw_insert_4.GetRow()
	  If nRow <=0 Then Return
	  
     s_chagu = Trim(tab_1.tabpage_4.dw_insert_4.GetItemSTring(nRow,'chrgu'))
     IF MessageBox("삭 제","SEQ : " + s_chagu + "의  자료가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
	  If tab_1.tabpage_4.dw_insert_4.DeleteRow(nRow) = 1 Then
        IF tab_1.tabpage_4.dw_insert_4.Update() <> 1 THEN
	        ROLLBACK;
	        Return
        END IF
   	End If
End Choose	  

COMMIT;
sle_msg.text ='자료를 삭제하였습니다!!'


end event

type p_mod from w_inherite`p_mod within w_sal_06050
integer y = 16
end type

event p_mod::clicked;call super::clicked;string sCino, sCiDate, sCvcod, sPino, sCurr, sLocalYn, sSaupj, sIpjpno, sShipdate, sPacNo, sCust
double d_piseq,ciamt,chramt, dCiSeq
Long   nRow,ix,i_ctfrom,i_ctto,nCnt

If dw_key.AcceptText() <> 1 Then Return
If tab_1.tabpage_1.dw_insert_1.AcceptText() <> 1 Then Return
If tab_1.tabpage_2.dw_insert_2.AcceptText() <> 1 Then Return
If tab_1.tabpage_3.dw_insert_3.AcceptText() <> 1 Then Return

dw_key.Setfocus()

/* 일자 Check */
sCiDate = Trim(dw_key.GetItemString(1,'cidate'))
If f_dateChk(sCiDate) <> 1 then
	f_message_chk(40,'[송장일자]')
	dw_key.SetColumn('cidate')
	Return
End If

/* 거래처 check */
sCvcod = Trim(dw_key.GetItemString(1,'cvcod'))
If IsNull(sCvcod) or sCvcod = '' Then
	f_message_chk(40,'[거래처]')
	dw_key.SetColumn('cvcod')
	Return
End If

/* 부가사업장 check */
sSaupj = Trim(dw_key.GetItemString(1,'saupj'))
If IsNull(sSaupj) or sSaupj = '' Then
	f_message_chk(40,'[부가사업장]')
	dw_key.SetColumn('saupj')
	Return
End If

/* Local 일경우 바로 출고확정, 환경변수에 따라 매출확정 처리 */
sLocalYn = Trim(dw_key.GetItemString(1,'localyn'))

SetPointer(HourGlass!)

/* 일반정보 저장 */
nRow  = tab_1.tabpage_1.dw_insert_1.GetRow()

tab_1.tabpage_1.dw_insert_1.Setfocus()
sCurr = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(1,'expcih_curr'))
If IsNull(sCurr) Or sCurr = '' then
	f_message_chk(40,'[통화]')
	tab_1.tabpage_1.dw_insert_1.SetColumn('expcih_curr')
	Return
End If

sShipDate = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(1,'expcih_shipdat'))
If IsNull(sShipDate) Or sShipDate = '' then
	f_message_chk(40,'[선적예정일]')
	tab_1.tabpage_1.dw_insert_1.SetColumn('expcih_shipdat')
	Return
End If

/* 전표번호 채번 */
If rb_new.Checked = True  Then
	If is_junpyo_gb = 'Y' Then
		sCino = wf_get_junpyo_no(sCiDate,'X2')
		
		dw_key.SetItem(1,'cino',sCino)
	Else
		sCino = Trim(dw_key.GetItemString(1,'cino'))

		/* 기존 등록 유무 확인 */
		SELECT COUNT(CINO) INTO :nCnt FROM EXPCIH
		 WHERE SABU = :gs_sabu AND CINO = :sCino;

		If nCnt <> 0 Then
			f_message_chk(1,'[C/I No.]')
			SetNull(sCino)
			dw_key.SetItem(1,'cino',sCino)
			dw_key.SetFocus()
			dw_key.SetRow(nRow)
			dw_key.SetColumn('cino')
			Return
		End If
	End If
Else
	sCino = Trim(dw_key.GetItemString(1,'cino'))
End If

/* check cino */
If IsNull(sCino) Or sCino = '' Then
	f_message_chk(40,'[C/I No.]')
	dw_key.Setfocus()
	dw_key.SetColumn('cino')
	Return
End If

sCiDate = Trim(dw_key.GetItemString(1,'cidate'))
sCvcod  = Trim(dw_key.GetItemString(1,'cvcod'))
sCust   = Trim(dw_key.GetItemString(1,'plandate'))

/* key setting */
If rb_new.Checked = True Then
	tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_sabu', gs_sabu)
	tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_cino', sCino)
End If

tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_cidate',  sCiDate)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_cvcod',   sCvcod)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_plandate',   sCust)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_localyn', sLocalYN)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_saupj',   sSaupj)
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_yebi1',   dw_key.GetItemString(1, 'yebi1'))

/* 수출금액 계산 = ci detail amt + charge amt (원화금액,외화금액은 확정시 계산) */
If tab_1.tabpage_2.dw_insert_2.RowCount() > 0 Then
	ciamt = tab_1.tabpage_2.dw_insert_2.GetItemNumber(1,'sum_ciamt')
	If IsNull(ciamt) Then ciamt = 0
Else
	ciamt = 0
End If

If tab_1.tabpage_4.dw_insert_4.RowCount() > 0 Then
	chramt = tab_1.tabpage_4.dw_insert_4.GetItemNumber(1,'sum_chramt')
	If IsNull(chramt) Then chramt = 0
Else
	chramt = 0
End If

ciamt = ciamt + chramt
tab_1.tabpage_1.dw_insert_1.SetItem(nRow,'expcih_expamt',ciamt)


/* 품목정보및 Packing List 저장 */
nRow  = tab_1.tabpage_2.dw_insert_2.RowCount()
If nRow > 0 Then
	sCino  = Trim(dw_key.GetItemString(1,'cino'))

	For ix = nRow To 1 Step -1
		Choose Case tab_1.tabpage_2.dw_insert_2.GetItemStatus(ix,0,Primary!)
			Case New!
				tab_1.tabpage_2.dw_insert_2.DeleteRow(ix)
				Continue
		End Choose
	Next

	/* key check */
	nRow  = tab_1.tabpage_2.dw_insert_2.RowCount()
	If nRow <= 0 Then Return

	For ix = 1 To nRow
		sPino = Trim(tab_1.tabpage_2.dw_insert_2.GetItemString(ix,'pino'))
		d_piseq = tab_1.tabpage_2.dw_insert_2.GetItemNumber(ix,'piseq')
	
		If sPino = '' Or IsNull(sPino) Then
			f_message_chk(40,'[PI NO 입력]')
			tab_1.tabpage_2.dw_insert_2.SetFocus()
			tab_1.tabpage_2.dw_insert_2.SetRow(ix)
			tab_1.tabpage_2.dw_insert_2.SetColumn('pino')
			Return 
		End If

		If IsNull(d_piseq) Or d_piseq = 0 Then
			f_message_chk(40,'[PI SEQ 입력]')
			tab_1.tabpage_2.dw_insert_2.SetFocus()
			tab_1.tabpage_2.dw_insert_2.SetRow(ix)
			tab_1.tabpage_2.dw_insert_2.SetColumn('piseq')
			Return 
		End If
		tab_1.tabpage_2.dw_insert_2.SetItem(ix,'sabu',gs_sabu)
		tab_1.tabpage_2.dw_insert_2.SetItem(ix,'cino',sCino)
	Next

	/* expcid 저장 */
	IF tab_1.tabpage_2.dw_insert_2.RowCount() >0 THEN
		IF tab_1.tabpage_2.dw_insert_2.Update() <> 1 THEN
			ROLLBACK;
			Return
		END IF
	END IF	

	/* expcipl 저장 */
	IF tab_1.tabpage_3.dw_insert_3.RowCount() >0 THEN
		IF tab_1.tabpage_3.dw_insert_3.Update() <> 1 THEN
			ROLLBACK;
			Return
		END IF
	END IF	

	sle_msg.text ='품목정보/Packing List를 저장하였습니다!!'
	
End If

/* Charge 정보 저장 */
nRow  = tab_1.tabpage_4.dw_insert_4.RowCount()
If nRow > 0 Then
	sCino  = Trim(dw_key.GetItemString(1,'cino'))
	For ix = nRow To 1 Step -1
		sPino = trim(tab_1.tabpage_4.dw_insert_4.GetItemString(ix,'pino'))
		If IsNull(sPino ) or sPino = '' Then
			tab_1.tabpage_4.dw_insert_4.DeleteRow(ix)
			continue
		End If
	Next

	nRow = tab_1.tabpage_4.dw_insert_4.RowCount()
	For ix = 1 to nRow
		tab_1.tabpage_4.dw_insert_4.SetItem(ix,'sabu',gs_sabu)
		tab_1.tabpage_4.dw_insert_4.SetItem(ix,'cino',sCino)
	Next

	IF tab_1.tabpage_4.dw_insert_4.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF

	sle_msg.text ='CHARGE를 저장하였습니다!!'
End If

/* carton 수량계산 */
wf_cal_carton() 
	
IF tab_1.tabpage_1.dw_insert_1.Update() <> 1 THEN
	ROLLBACK;
	F_MESSAGE_CHK(32,'')
	Return
END IF

///* 포장정보에 CI NO 기록 */
//If tab_1.tabpage_2.dw_insert_2.RowCount() > 0 Then
//	sPacNo = tab_1.tabpage_2.dw_insert_2.GetItemString(1,'ip_jpno')
//	If Not IsNull(sPacNo) Then
//		UPDATE PACLSTH
//		   SET CINO = :sCino
//		 WHERE SABU = :gs_sabu AND
//		 		 PACNO = :sPacNo AND
//				 CVCOD = :sCvcod;
//
//		If sqlca.sqlcode <> 0 Then				 
//			ROLLBACK;
//			F_MESSAGE_CHK(32,'[포장정보]')
//			Return
//		END IF
//	End If
//End If

Commit;

rb_upd.Checked = True
p_inq.TriggerEvent(Clicked!)

ib_any_typing = False

MessageBox('확 인','저장되었습니다.!!')

w_mdi_frame.sle_msg.text ='저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_06050
end type

type cb_mod from w_inherite`cb_mod within w_sal_06050
end type

type cb_ins from w_inherite`cb_ins within w_sal_06050
end type

type cb_del from w_inherite`cb_del within w_sal_06050
end type

type cb_inq from w_inherite`cb_inq within w_sal_06050
end type

type cb_print from w_inherite`cb_print within w_sal_06050
integer x = 1367
integer y = 2440
integer width = 498
boolean enabled = false
string text = "출고취소(&P)"
end type

type st_1 from w_inherite`st_1 within w_sal_06050
end type

type cb_can from w_inherite`cb_can within w_sal_06050
end type

type cb_search from w_inherite`cb_search within w_sal_06050
integer x = 1413
integer y = 2376
integer width = 498
integer taborder = 50
boolean enabled = false
string text = "출고의뢰(&E)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_06050
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06050
end type

type tab_1 from tab within w_sal_06050
integer x = 37
integer y = 372
integer width = 4567
integer height = 1916
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
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;call super::selectionchanged;If rb_upd.Enabled = True and ib_cfm = True Then         // 수정,확정
	Choose Case newindex 
		Case  1
			cb_inq.Enabled = False     //조회
			cb_ins.Enabled = False     //추가 
			cb_mod.Enabled = True      //저장
			cb_del.Enabled = False     //삭제
		Case Else
			cb_inq.Enabled = False     //조회
			cb_ins.Enabled = False     //추가 
			cb_mod.Enabled = False     //저장
			cb_del.Enabled = False     //삭제
	End Choose
Else
	cb_inq.Enabled = TRue      //조회
	cb_ins.Enabled = True      //추가 
	cb_mod.Enabled = True      //저장
	cb_del.Enabled = True      //삭제
End If
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1804
long backcolor = 32106727
string text = "일반정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
dw_insert_1 dw_insert_1
end type

on tabpage_1.create
this.rr_5=create rr_5
this.dw_insert_1=create dw_insert_1
this.Control[]={this.rr_5,&
this.dw_insert_1}
end on

on tabpage_1.destroy
destroy(this.rr_5)
destroy(this.dw_insert_1)
end on

type rr_5 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 32
integer width = 4475
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert_1 from u_key_enter within tabpage_1
event ue_key pbm_dwnkey
integer x = 50
integer y = 56
integer width = 4434
integer height = 1704
integer taborder = 10
string dataobject = "d_sal_06050_h"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_any_typing = True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


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

event rbuttondown;int nRow
string s_cvcod

SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)

nRow = GetRow()
Choose Case GetColumnName()
	Case "expcih_explcno"                              // lc 접수번호 선택 popup 
      s_cvcod = Trim(dw_key.GetItemString(dw_key.GetRow(),'cvcod'))
      If s_cvcod = '' Or IsNull(s_cvcod) Then
	      f_message_chk(40,'[거래처]')
	      dw_key.SetFocus()
	      dw_key.SetColumn('cvcod')
	      Return 1
      End If
		
		gs_gubun = s_cvcod
   	Open(w_explc_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(row,"expcih_explcno",gs_code)
		This.TriggerEvent(itemchanged!)		
	Case "expcih_shipdat"
		SetNull(gs_code)
		
		str_pos.x = Int(this.x + xpos)  
		str_pos.y = Int(this.y + ypos)
		
		OpenWithParm(w_ddcal, str_pos)
		IF IsNull(gs_code) THEN Return 
		
		this.SetItem(row, 'expcih_shipdat', gs_code)
		this.SetColumn('expcih_shipdat')
End Choose

end event

event itemchanged;Long    nRow
string  sData,rData,sDate,s_banklcno,s_opndat,s_curr,s_cvcod,sNull, sCists
dec {2} d_lcamt_jan

SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

sData = Trim(GetText())
SetNull(sNull)
Choose Case GetColumnName()
/* 선적일자 : 매출확정기준이 송장기준이면 선적일자가 매출확정일자이므로 삭제 불가*/
	Case 'expcih_shipdat'
		sDate = Trim(GetText())
		
//		sCists = GetItemString(nRow,'expcih_cists')
//		If SaleConfirm = '2' and sCists = '2' Then
//			If IsNull(sDate) or sDate = ''  Then
//				MessageBox('확 인','매출확정된 송장입니다')			
//				Return 2
//			Else
//				SetItem(nRow,'expcih_saledt',sDate) // 매출확정일자 수정
//			End If
//		End If
		
		If f_datechk(sdate) <> 1 Then
			f_message_chk(35,'')
			SetItem(nRow,'expcih_shipdat',sNull)
      	setcolumn('expcih_shipdat')
	      Return 1
      END IF
		
	Case 'expcih_curr'
		sDate = dw_key.GetItemString(dw_key.GetRow(),'cidate')
      wf_calc_curr(row,sDate,Trim(Gettext()))  // 환율 setting
	Case 'expcih_explcno'
      s_cvcod = Trim(dw_key.GetItemString(dw_key.GetRow(),'cvcod'))
      If s_cvcod = '' Or IsNull(s_cvcod) Then
	      f_message_chk(40,'[거래처]')
	      dw_key.SetFocus()
	      dw_key.SetColumn('cvcod')
	      Return 2
      End If
		
      If sData = '' Or IsNull(sData) Then 
		   this.SetItem(nrow,"explc_banklcno",'')
		   this.SetItem(nrow,"explc_opndat",'')
		   this.SetItem(nrow,"lcamt_jan",0.0)
			Return 0
		End If
		
		SELECT "EXPLC"."BANKLCNO", "EXPLC"."OPNDAT" ,"EXPLC"."CURR" ,NVL("EXPLC"."LCAMT" - "EXPLC"."CIAMT",0)
        INTO :s_banklcno,      :s_opndat  ,:s_curr, :d_lcamt_jan
        FROM "EXPLC"  
       WHERE ( "EXPLC"."SABU" = :gs_sabu ) AND  
             ( "EXPLC"."EXPLCNO" = :sData ) AND
             ( "EXPLC"."CVCOD" = :s_cvcod);

      If sqlca.sqlcode <> 0 Then
			f_message_chk(33,'[L/C No]')
			Return 1
		End If	

		If IsNull(s_banklcno) Then s_banklcno = ''
		If IsNull(s_opndat)   Then s_opndat = ''
		this.SetItem(nrow,"explc_banklcno",s_banklcno)
		this.SetItem(nrow,"explc_opndat",s_opndat)
		this.SetItem(nrow,"expcih_curr",s_curr)
		this.SetItem(nrow,"lcamt_jan",d_lcamt_jan)
		
		sDate = dw_key.GetItemString(dw_key.GetRow(),'cidate')
      wf_calc_curr(nrow,sDate,s_curr)  // 환율 setting
End Choose

end event

event itemerror;return 1
end event

event ue_pressenter;Choose Case GetColumnName() 
	Case "expcih_seller" ,"expcih_consignee","expcih_shipmark","expcih_cinotes","expcih_buyer","expcih_other_ref","expcih_remark"
		return 0
	Case Else
      Send(Handle(this),256,9,0)
      Return 1
End Choose		
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1804
long backcolor = 32106727
string text = "품목정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 32106727
rr_4 rr_4
dw_insert_2 dw_insert_2
end type

on tabpage_2.create
this.rr_4=create rr_4
this.dw_insert_2=create dw_insert_2
this.Control[]={this.rr_4,&
this.dw_insert_2}
end on

on tabpage_2.destroy
destroy(this.rr_4)
destroy(this.dw_insert_2)
end on

type rr_4 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 32
integer width = 4475
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert_2 from u_key_enter within tabpage_2
event ue_key pbm_dwnkey
integer x = 37
integer y = 40
integer width = 4439
integer height = 1712
integer taborder = 10
string dataobject = "d_sal_06050_d"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_any_typing = True
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


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

event itemchanged;String sData,sCino,sPino,sCvcod, sNull
int    iciseq,nRow,nCnt
Dec	 d_ciqty,d_ciprc,d_itmprc, dInvQty, nNapqty

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

/* ------------------------------------------------- */
/* pino,piseq,qty변경시 기존 packing list는 삭제한다 */
/* ------------------------------------------------- */
sCino = Trim(GetItemString(nRow,'cino'))  // old data
iCiseq = GetItemNumber(nRow,'ciseq')

Choose Case GetColumnName()
	Case 'pino'
		MessageBox("확 인","Right-Button만 사용가능합니다")
		Return 2
	Case 'piseq'
		MessageBox("확 인","Right-Button만 사용가능합니다")
		Return 2
	Case 'ciqty'         // 수량 변경시
		d_ciqty = Long(Trim(GetText()))
		d_ciprc = GetItemNumber(row,'ciprc')
		d_itmprc = GetItemNumber(row,'itmprc')
		If IsNull(d_ciprc) Then d_ciprc = 0

		dInvQty = GetitemNumber(row, 'hold_qty')
		
		If IsNull(dInvQty) Then dInvQty = 0
		
		/* 납품배수 */
		nNapQty = dw_key.GetItemNumber(1,'napqty')
		If IsNull(nNapqty) Or nNapQty = 0 Then
		Else
			If Mod(d_ciqty, nNapQty) <> 0 Then
				MessageBox('확 인','수량은 납품배수 범위내에서 가능합니다.!!')
				Return 2
			End If
		End If
		
		If d_ciqty > dInvQty Then
			MessageBox('확 인','할당된 수량보다 많습니다.!!')
			Return 2
		End If
		
		SetItem(nRow,'ciamt', TrunCate(Round(d_ciqty,2) * Round(d_ciprc,5),2))   // 송장금액
		SetItem(nRow,'itmamt',TrunCate(Round(d_ciqty,2) * Round(d_itmprc,5),2)) // 품목금액
		
		If Not IsNull(iCiseq) Then  wf_delete_pl(sCino,iciseq)  //packing list Delete
		wf_create_packing(nRow)                                  // create packing list
	Case 'ciprc'         // 단가 변경시
		d_ciprc = Double(Trim(GetText()))
		d_ciqty = GetItemNumber(row,'ciqty')
		d_itmprc = GetItemNumber(row,'itmprc')
		If IsNull(d_ciprc) Then d_ciprc = 0
		If IsNull(d_ciqty) Then d_ciqty = 0

		SetItem(nRow,'ciamt', TrunCate(Round(d_ciqty,2) * Round(d_ciprc,5),2))   // 송장금액
		SetItem(nRow,'itmamt',TrunCate(Round(d_ciqty,2) * Round(d_itmprc,5),2)) // 품목금액
End Choose
end event

event rbuttondown;String sPino, sCvcod, sExplcno, sSaupj
Long	nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'pino','piseq'
      sPino  = Trim(GetItemString(nRow,'pino'))
      sCvcod = Trim(dw_key.GetItemString(1,'cvcod'))
      If sCvcod = '' Or IsNull(sCvcod) Then
	      f_message_chk(40,'[거래처]')
	      dw_key.SetFocus()
	      dw_key.SetColumn('cvcod')
	      Return 1
      End If
		
		/* 관련LC No를 입력할 경우 관련pi만 불러온다 */
		sExplcno = Trim(tab_1.tabpage_1.dw_insert_1.GetItemString(1,'expcih_explcno'))
		sSaupj	= dw_key.GetItemString(1, 'saupj')
		If IsNull(sExplcno) Then sExplcno = ''
		
		gs_code		= sSaupj
		gs_gubun    = sCvcod
		gs_codename = sExplcno
		open(w_exppid_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return 2
		
		wf_multi_pino(nRow)
End Choose
end event

event itemerror;return 1
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1804
long backcolor = 32106727
string text = "PACKING"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_2 dw_2
dw_1 dw_1
dw_insert_3 dw_insert_3
dw_calc dw_calc
cb_1 cb_1
end type

on tabpage_3.create
this.rr_3=create rr_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_insert_3=create dw_insert_3
this.dw_calc=create dw_calc
this.cb_1=create cb_1
this.Control[]={this.rr_3,&
this.dw_2,&
this.dw_1,&
this.dw_insert_3,&
this.dw_calc,&
this.cb_1}
end on

on tabpage_3.destroy
destroy(this.rr_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_insert_3)
destroy(this.dw_calc)
destroy(this.cb_1)
end on

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 8
integer width = 4439
integer height = 1760
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within tabpage_3
integer x = 2999
integer y = 1192
integer width = 672
integer height = 360
integer taborder = 40
string title = "none"
string dataobject = "d_sal_06050_calc_new2"
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within tabpage_3
integer x = 3003
integer y = 1192
integer width = 667
integer height = 536
integer taborder = 30
string title = "none"
string dataobject = "d_sal_06050_calc_new"
boolean border = false
boolean livescroll = true
end type

type dw_insert_3 from u_key_enter within tabpage_3
event ue_mousemove pbm_mousemove
event ue_bdown pbm_lbuttondown
event ue_bup pbm_lbuttonup
integer x = 9
integer y = 20
integer width = 4448
integer height = 1132
integer taborder = 10
string dragicon = "WinLogo!"
string dataobject = "d_sal_06050_p"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_mousemove;/* --------------------------------------------------------------- */
/* 마우스를 누른체 움직일 경우 drag                                */
/* --------------------------------------------------------------- */
string  ls_col,ls_colnm

int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

   /* row와 column name을 구분 */ 
	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   /* 해당 column에서만 drag 가능 */
   If ls_colnm <> 'itdsc' And ls_colnm <> 'ispec' Then Return
   If li_row <= 0 Then Return
	
	/* 마으스버튼이 눌릴경우 ue_bdown */
	if ib_down then
		this.Drag (begin!)
      drag_start_row = li_row
	end if

end if

end event

event ue_bdown;string  ls_col,ls_colnm
int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row <= 0 Then Return
	
   If ls_colnm <> 'itdsc' And ls_colnm <> 'ispec' Then
		sle_msg.Text = 'Drag & Drop은 품명과 규격에서만 가능합니다!!'
		ib_down = False
   Else
		sle_msg.Text = ''
		SetRow(li_row)
      ib_down = true
	End If
End if



end event

event ue_bup;ib_down = false

This.Drag(End!)
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


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

event editchanged;ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;int nRow

SetNull(gs_code)
SetNull(gs_codename)

nRow = GetRow()
Choose Case GetColumnName()
	Case 'areacd'
		open(w_nation_popup)
		This.SetItem(nRow,'areacd',gs_code)
		This.SetItem(nRow,'area_areanm',gs_codename)
	Case 'deptcode'
		open(w_vndmst_4_popup)
		This.SetItem(nRow,'deptcode',gs_code)
	Case 'emp_id'
		open(w_sawon_popup)
		This.SetItem(nRow,'emp_id',gs_code)		
		This.SetItem(nRow,'p1_master_empname',gs_codename)		
	Case 'agent'
		open(w_vndmst_popup)
		This.SetItem(nRow,'agent',gs_code)		
		This.SetItem(nRow,'vndmst_cvnas2',gs_codename)				
End Choose

end event

event dragdrop;drag_end_row = row
ib_down = true

If drag_start_row = drag_end_row Then Return
If drag_start_row <= 0 Or drag_end_row <= 0 Then Return

If wf_merge_pl(drag_start_row,drag_end_row) <> 0 Then
	MessageBox('확  인','동일한 송장번호가 아닙니다',StopSign!,Ok!)
End If

end event

event itemchanged;double sizex,sizey,sizez,sizec,size
long   lCtto, lCtFrom, lPlqty, nRow, lctqty, lperqty

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case  GetColumnName() 
//	Case 'ctfrom'
////		lCtFrom = Long(GetText())
////		lCtTo   = GetItemNumber(nRow,'ctto')
////		lPlQty  = GetItemNumber(nRow,'plqty')
////		
////		/* from 이 to보다 클경우 */
////		If lCtFrom > lCtto Then
////			lCtto = lCtFrom
////		End If
//////			Return 2
////		
////		If (lCtTo - lCtFrom + 1 ) > lPlQty Then Return 2
////		
////		lperqty = lplqty / (lctto - lCtfrom + 1)
////		
////		SetItem(nRow, 'ctto', 	lCtto)
////		SetItem(nRow, 'qtypct', lperqty)
//		Return 2
//	Case 'ctto'
////			lCtto = Long(GetText())
////			lCtFrom = GetItemNumber(nRow,'ctfrom')
////			lPlQty  = GetItemNumber(nRow,'plqty')
////			
////			/* from 이 to보다 클경우 */
////			If lCtFrom > lCtto Then Return 2
////			
////			If (lCtTo - lCtFrom + 1 ) > lPlQty Then Return 2
////			
////			Post wf_separate_pl2(nRow,lCtFrom, lCtto)
//	Case 'plqty'
////	   Post wf_separate_pl(nRow,double(data))
//	   return 2
//	Case 'qtypct'
////		lCtFrom = GetItemNumber(nRow,'ctfrom')
////		lCtto   = GetItemNumber(nRow,'ctto')
////		lperqty = long(GetText())
////
////		lctqty  = lctto - lctfrom + 1
////		lplqty  = lperqty	* lctqty
////		
////		SetItem(nRow, 'plqty', lplqty)
//	   return 2
   Case 'cbmsizex','cbmsizey','cbmsizez','ctto'
		  Accepttext()
        sizex = GetItemNumber(nRow,'cbmsizex')
        sizey = GetItemNumber(nRow,'cbmsizey')
        sizez = GetItemNumber(nRow,'cbmsizez')
        sizec = GetItemNumber(nRow,'ctto')
		  If IsNull(sizex) Then sizex = 0
		  If IsNull(sizey) Then sizey = 0
		  If IsNull(sizez) Then sizez = 0
		  If IsNull(sizec) Then sizec = 0
		  size = Round((sizex) * (sizey) * (sizez)* (sizec),3)
		  SetItem(nRow,'cbmsize',size)
End Choose
end event

event buttonclicked;// 합계버튼을 클릭시 카툰수량을 계산한다
//wf_cal_carton()
end event

event dragwithin;sle_msg.text = '# ' + string(row)
end event

type dw_calc from u_key_enter within tabpage_3
integer x = 46
integer y = 1208
integer width = 2921
integer height = 520
integer taborder = 20
string dragicon = "WinLogo!"
boolean bringtotop = true
string dataobject = "d_sal_06050_calc"
boolean border = false
boolean livescroll = false
end type

type cb_1 from commandbutton within tabpage_3
integer x = 3781
integer y = 1320
integer width = 457
integer height = 308
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "중량 계산"
end type

event clicked;/* Packing List 중량 계산 */
//소박스 = 0.13*84+0.088*6+0.029*7+0.52 => calc8 = calc1 * calc2 + calc3 * calc4 + calc5* calc6 +calc7
//대박스 = 12.2*32+11.57+18 =>  (calc8 * calc9 + calc10 + calc11 )
//BASE INFO		
//0477PART : 0.13KG		--> calc1 (품번 중량)
//0515PART : 0.098KG	--> calc1	(품번 중량)
//간지 : 0.088KG			--> calc3
//사각PAD : 0.029KG		--> calc4
//소박스 : 0.52KG		--> calc6
//아웃박스 : 11.57KG	--> calc10	
//팔렛 : 18KG				--> calc11
// carton 수량 				--> calc12
// 예비 						--> calc15

Double calc1, calc2, calc3, calc4, calc5, calc6, calc7, calc8, calc9, calc10
Double calc11, calc12, calc13, calc14, calc15
string snull

setnull(snull)

dw_calc.AcceptText()

calc1 = GetItemNumber(dw_calc, 1, 'calc1')
calc2 = GetItemNumber(dw_calc, 1, 'calc2')
calc3 = GetItemNumber(dw_calc, 1, 'calc3')
calc4 = GetItemNumber(dw_calc, 1, 'calc4')
calc5 = GetItemNumber(dw_calc, 1, 'calc5')
calc6 = GetItemNumber(dw_calc, 1, 'calc6')
calc7 = GetItemNumber(dw_calc, 1, 'calc7')
calc9 = GetItemNumber(dw_calc, 1, 'calc9')
calc10 = GetItemNumber(dw_calc, 1, 'calc10')
calc11 = GetItemNumber(dw_calc, 1, 'calc11')
calc12 = GetItemNumber(dw_calc, 1, 'calc12')


if isnull(calc1) or calc1 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc2) or calc2 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc3) or calc3 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc4) or calc4 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc5) or calc5 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc6) or calc6 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc7) or calc7 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc9) or calc9 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc10) or calc10 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc11) or calc11 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if
if isnull(calc12) or calc12 < 0 then
	MessageBox('확 인',"값이 없습니다.")
	SetFocus()
	return -1;
End if

calc8 = calc1 * calc2 + calc3 * calc4 + calc5* calc6 +calc7

SetItem(dw_calc,1, 'calc8',calc8)

calc13 = (calc8 * calc9 + calc10 + calc11 ) * calc12

SetItem(dw_calc,1, 'calc13',calc13)

calc14 = (calc8 * calc9 + calc10 ) * calc12 

SetItem(dw_calc,1, 'calc14',calc14)
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4530
integer height = 1804
long backcolor = 32106727
string text = "CHARGE"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_insert_4 dw_insert_4
end type

on tabpage_4.create
this.rr_2=create rr_2
this.dw_insert_4=create dw_insert_4
this.Control[]={this.rr_2,&
this.dw_insert_4}
end on

on tabpage_4.destroy
destroy(this.rr_2)
destroy(this.dw_insert_4)
end on

type rr_2 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 32
integer width = 4475
integer height = 1744
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_insert_4 from u_key_enter within tabpage_4
event ue_key pbm_dwnkey
integer x = 37
integer y = 48
integer width = 4457
integer height = 1708
integer taborder = 10
string dataobject = "d_sal_06050_ch"
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

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


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

event editchanged;ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;Long   nRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return 

Choose Case GetColumnName()
	Case 'pino'
		gs_code  	= Trim(GetText())
		gs_gubun		= Trim(dw_key.GetItemString(1,'cvcod'))
		gs_codename = Trim(dw_key.GetItemString(1,'saupj'))
		
		If gs_gubun = '' Or IsNull(gs_gubun) Then
			f_message_chk(40,'[거래처]')
			dw_key.SetFocus()
			dw_key.SetColumn('cvcod')
			Return 1
		End If		
		
		open(w_exppich_popup)
		wf_get_multi_picharge(nRow)
End Choose

end event

event itemchanged;String sPino,sCvcod
Long   nRow
dec wrate,urate,weigh
Double dChrAmt

nRow = GetRow()
Choose Case GetColumnName()
  Case 'pino'
      sPino  = Trim(GetText())
      sCvcod = Trim(dw_key.GetItemString(1,'cvcod'))
      If sCvcod = '' Or IsNull(sCvcod) Then
	      f_message_chk(40,'[거래처]')
	      dw_key.SetFocus()
	      dw_key.SetColumn('cvcod')
	      Return 1
      End If		
		
      Return wf_get_picharge(nRow,sCvcod,sPino)
/* 원화금액,외화금액 계산 */
	Case 'chramt'
	  dChrAmt = Double(GetText())
	  If IsNull(dChrAmt) Then dChrAmt = 0
  	  If tab_1.tabpage_1.dw_insert_1.Rowcount() <= 0 Then Return

     wrate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'expcih_wrate')
     urate = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'expcih_urate')
	   weigh = tab_1.tabpage_1.dw_insert_1.GetItemNumber(1,'weight')
     If IsNull(wrate) Or wrate = 0 Then wrate = 1
     If IsNull(urate) Or urate = 0 Then urate = 1
	  If IsNull(weigh) Or weigh = 0 Then weigh = 1
	  
	  SetItem(nRow,'wamt',TrunCate((dChrAmt * wrate)/weigh,0))
	  SetItem(nRow,'uamt',TrunCate((dChrAmt * urate)/weigh,2))
End Choose




end event

type dw_key from datawindow within w_sal_06050
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 180
integer width = 4613
integer height = 172
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06050_key"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sNull,  sCino, sCurr, sCidate, sCvcod, sCists, sSaupj
String sCvnas, steam, sname1, sarea, sdata
Long   nRow,   nCnt

SetNull(sNull)
If rb_new.Checked <> True And rb_upd.Checked <> True Then
	f_message_chk(57,' 작업구분 선택')
	Return 2
End If

nRow = GetRow()
If nRow <= 0 Then Return 2

/* 확정일 경우 수정 불가 */
sCists = Trim(GetItemString(nRow,'cists'))
If sCists = '2' Then Return 2

Choose Case GetColumnName()
	Case 'cino'
		
		If rb_upd.Checked = True Then
			sCino = Trim(GetText())
			IF sCino = "" OR IsNull(sCino) THEN RETURN
			
				SELECT COUNT(*)
				  INTO :nCnt  
				  FROM "EXPCIH"
				 WHERE ( "EXPCIH"."SABU" = :gs_sabu ) AND  
						 ( "EXPCIH"."CINO" = :sCino ) ;
			
				IF nCnt <=0 THEN
					f_message_chk(33,'[C/I NO]')
					SetItem(nRow,'cino',sNull)
					Return 1
				End if
				
				// 수출대체를 검색하여 대체로 발생된 C/I-No인 경우에는 수정 할 수 없음
				Select Count(*) into :nCnt
				  From imhist_daeche
				 Where Sabu = :gs_sabu And cino = :sCino;
				 
				if ncnt > 0 then
					MessageBox("수출대체", "수출대체로 발생된 C/I입니다", stopsign!)
					setitem(nrow, 'cino', sNull)
					return 1
				End if
				
				p_inq.TriggerEvent(Clicked!)
		Else
			p_inq.TriggerEvent(Clicked!)
		End If
	Case 'cidate'                    // ci 일자
		sCiDate = Trim(GetText())
		If f_datechk(sCiDate) <> 1 or IsNull(sCiDate) Or sCiDate = '' Then
			f_message_chk(35,'')
      	setitem(nRow,'cidate',sNull)
	      Return 1
      END IF
		
		/* 환율 계산 */
		sCurr = tab_1.tabpage_1.dw_insert_1.GetItemString(1,'expcih_curr')
		wf_calc_curr(1,sCiDate,sCurr)
	/* Buyer */
	Case 'cvcod'
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF
	
/*Packing*/
	If sCvcod= '205005' then
		tab_1.tabpage_3.dw_2.visible = True
		tab_1.tabpage_3.dw_1.visible = False
	else
		tab_1.tabpage_3.dw_2.visible = False
		tab_1.tabpage_3.dw_1.visible = True
	end if 


		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod',   sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
//			SetItem(1,"saupj",   	ssaupj)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
		
		If rb_new.Checked = True Then          // 신규일 경우 기존 데이타를 복사한다
			Post wf_copy_buyer(sCvcod)
		End If
	/* 최종출고처 */
	Case 'plandate'
		sData = getitemstring(1, 'cvcod')
		If IsNull(sData) Or sData = '' Then
			MessageBox('확인','Buyer를 먼저 입력하세요.!!')
			Return 2
		End If
		
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'plandate',   sNull)
			SetItem(1, 'custnm', snull)
			Return 1
		ELSE		
			SetItem(1,"custnm",	scvnas)
		END IF
		
		If rb_new.Checked = True Then          // 신규일 경우 기존 데이타를 복사한다
			Post wf_copy_last_buyer(sCvcod)
		End If
End Choose

ib_any_typing = True
end event

event itemerror;return 1
end event

event rbuttondown;string sData, sLocalYn

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

sData = Trim(GetText())
Choose Case GetColumnName() 
	Case "cino" 
		sLocalYn = GetItemString(1, 'localyn')
		
		If rb_upd.Checked = False Then Return // 수정일 경우만...

		gs_code  = 'A'
		gs_gubun = 'A'
   	Open(w_expci_popup)
		If gs_code = '' Or IsNull(gs_code) Then Return
		
		this.SetItem(1,"cino",gs_code)
		p_inq.Post TriggerEvent(Clicked!)
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '2'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	Case 'plandate'
		sData = getitemstring(1, 'cvcod')
		If IsNull(sData) Or sData = '' Then
			MessageBox('확인','Buyer를 먼저 입력하세요.!!')
			Return 2
		End If
		
		gs_gubun = '2'
		Open(w_vndmst_popup)		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"plandate",gs_code)
		SetColumn("plandate")
		TriggerEvent(ItemChanged!)
END Choose
end event

type rb_new from radiobutton within w_sal_06050
integer x = 78
integer y = 60
integer width = 247
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
boolean checked = true
end type

event clicked;If This.Checked = True Then
	Parent.SetRedraw(False)
   tab_1.tabpage_1.dw_insert_1.Reset()
   tab_1.tabpage_1.dw_insert_1.InsertRow(0)
   tab_1.tabpage_2.dw_insert_2.Reset()
   tab_1.tabpage_3.dw_insert_3.Reset()	
   tab_1.tabpage_4.dw_insert_4.Reset()	
	
   dw_key.Reset()
	dw_key.InsertRow(0)
   wf_protect_key('신규')
	
	// 부가세 사업장 설정
	f_mod_saupj(dw_key, 'saupj')

	dw_key.SetFocus()
	dw_key.SetRow(1)
	
	dw_key.SetItem(1, 'cidate', is_today)
	
	If is_junpyo_gb = 'Y' Then
	  dw_key.SetColumn('cidate')
   Else
	  dw_key.SetColumn('cino')
   End If

	tab_1.SelectedTab = 1
	tab_1.TriggerEvent(selectionchanged!)
	Parent.SetRedraw(True)	
End If
end event

type rb_upd from radiobutton within w_sal_06050
integer x = 329
integer y = 60
integer width = 247
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
   Parent.SetRedraw(False)

	tab_1.tabpage_1.dw_insert_1.Reset()
   tab_1.tabpage_1.dw_insert_1.InsertRow(0)
   tab_1.tabpage_2.dw_insert_2.Reset()
   tab_1.tabpage_3.dw_insert_3.Reset()
   tab_1.tabpage_4.dw_insert_4.Reset()	
	
	dw_key.Reset()
	dw_key.InsertRow(0)
   wf_protect_key('수정')
	
	// 부가세 사업장 설정
	f_mod_saupj(dw_key, 'saupj')

	dw_key.SetFocus()
	dw_key.SetRow(1)
	dw_key.SetColumn('cino')

	tab_1.SelectedTab = 1
	tab_1.TriggerEvent(selectionchanged!)
   Parent.SetRedraw(True)	
End If

end event

type pb_1 from u_pb_cal within w_sal_06050
integer x = 1664
integer y = 204
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_key.SetColumn('cidate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_key.SetItem(1, 'cidate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 32
integer width = 562
integer height = 128
integer cornerheight = 40
integer cornerwidth = 55
end type

