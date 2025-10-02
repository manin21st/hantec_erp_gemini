$PBExportHeader$w_sal_06055.srw
$PBExportComments$수출 매출 회계 전송
forward
global type w_sal_06055 from w_inherite
end type
type gb_7 from groupbox within w_sal_06055
end type
type gb_6 from groupbox within w_sal_06055
end type
type gb_5 from groupbox within w_sal_06055
end type
type rb_1 from radiobutton within w_sal_06055
end type
type rb_2 from radiobutton within w_sal_06055
end type
type cbx_1 from checkbox within w_sal_06055
end type
type dw_sunsu from u_d_select_sort within w_sal_06055
end type
type dw_negod from u_d_select_sort within w_sal_06055
end type
type dw_interface from u_key_enter within w_sal_06055
end type
type pb_1 from u_pic_cal within w_sal_06055
end type
type pb_2 from u_pic_cal within w_sal_06055
end type
type r_gubun from rectangle within w_sal_06055
end type
end forward

global type w_sal_06055 from w_inherite
integer width = 4686
integer height = 2388
string title = "수출 매출 회계 전송"
gb_7 gb_7
gb_6 gb_6
gb_5 gb_5
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
dw_sunsu dw_sunsu
dw_negod dw_negod
dw_interface dw_interface
pb_1 pb_1
pb_2 pb_2
r_gubun r_gubun
end type
global w_sal_06055 w_sal_06055

type variables
String SaleConfirm
String       isNgno[]             // 상계처리된 Nego번호
int             iiNgseq  
end variables

forward prototypes
public function integer wf_check_nego (string arg_cino, string arg_cvcod, string arg_weight)
public function integer wf_ret_sunsu (integer row)
public function integer wf_check_nego_charge ()
public function integer wf_calc_move (string scino, integer ix)
end prototypes

public function integer wf_check_nego (string arg_cino, string arg_cvcod, string arg_weight);/* 선 Nego내역이 존재하면 해당 Nego No.를 입력받는다 */
Double dSunSu, dMaxSeq, dCiamt, dCiWamt, dCiuamt, dSunsuWamt, dSunsuUamt
Double dNgAmt, dNgWamt, dNgUamt, dNgWrate, dNgUrate, weight
Long   ix, iy, nCnt, nRow
String sFrom, sTo, sNgno, sPino
DataStore ds3

iiNgseq = 0

/* 미선택 자료는 삭제한다 */
nCnt = dw_sunsu.RowCount()
For ix = nCnt To 1 Step -1
	If dw_sunsu.GetItemString(ix, 'chk') <> 'Y' Then dw_sunsu.DeleteRow(ix)
Next

If dw_sunsu.RowCount() <= 0 Then Return -1

dw_negod.Reset()

/* Ci,Pi No별 수출금액(Charge포함)  조회 */
ds3 = Create datastore
ds3.DataObject = 'd_sal_06050_ds3'
ds3.SetTransObject(sqlca)

ds3.Retrieve(gs_sabu, arg_cino)

/* 가중치 */
weight = Double(arg_weight)
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
			If ix > dw_sunsu.RowCount() Then Exit
			
			sNgno  	  = dw_sunsu.GetItemString(ix,'ngno')
			dSunSu 	  = dw_sunsu.GetItemNumber(ix,'sunsu')
			dSunSuwamt = dw_sunsu.GetItemNumber(ix,'sunsuwamt')
			dSunSuuamt = dw_sunsu.GetItemNumber(ix,'sunsuuamt')
		
			/* Nego 환율 */
			dNgWrate = dw_sunsu.GetItemNumber(ix,'wrate')
			dNgUrate = dw_sunsu.GetItemNumber(ix,'urate')
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
		
		nRow = dw_negod.InsertRow(0)
		dw_negod.SetItem(nRow, "SABU", gs_sabu)
		dw_negod.SetItem(nRow, "NGNO", sNgno)
      dw_negod.SetItem(nRow, "NGSEQ",dMaxSeq)
		dw_negod.SetItem(nRow, "CINO", arg_cino)
	   dw_negod.SetItem(nRow, "PINO", sPino)
		dw_negod.SetItem(nRow, "NGAMT",dNgAmt)
		dw_negod.SetItem(nRow, "WAMT",dNgWamt)
		dw_negod.SetItem(nRow, "UAMT",dNgUamt)
		dw_negod.SetItem(nRow, "DATAGU",'2')
		
		/* 처리된 Nego번호 기록 */
		iiNgSeq += 1
		isNgNo[iiNgSeq] = sNgno
	LOOP
Next

Destroy ds3

If dw_negod.Update() <> 1 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	MessageBox('확 인','Nego자료 생성중 오류가 발생했습니다!!')
	Return -1
End If

Return 0
end function

public function integer wf_ret_sunsu (integer row);String sCvcod, sSaupj, sCino
Double dCiAmt, dNgamt

sCvcod = dw_insert.GetItemString(row, 'cvcod')
sSaupj = dw_insert.GetItemString(row, 'saupj')
sCino  = dw_insert.GetItemString(row, 'cino')

/* 선수금 현황 조회 */
If dw_sunsu.Retrieve(gs_sabu, sCvcod, sSaupj) > 0 Then
	cb_ins.Enabled = True
Else
	cb_ins.Enabled = False
End If

/* 기연결 선수금 현황 조회 */
If dw_negod.Retrieve(gs_sabu, sCino) > 0 Then
	dCiamt = dw_insert.GetItemNumber(row, 'expamt')
	dNgamt = dw_negod.GetItemNumber(1, 'sum_ngamt')
	If dCiamt <= dNgamt Then	cb_ins.Enabled = False
	
	p_del.Enabled = True
Else
	p_del.Enabled = False
End If

return 1
end function

public function integer wf_check_nego_charge ();string sCostCd, sCostNo, sCurr, sNgdt, sCino, sPino, sNgno
Dec{2} dCostAmt,dCostForAmt,dCostAmtd,dCostForAmtd,dNgamt,dTotAmt
Dec{5} dDivRate
Dec{2} dSumAmtd,dSumForAmtd
Long   rCnt,iy, nCnt, ix, iz, iseq

/* Nego등록시 사용되는 송장 및 비용 dw 사용한다 */
DataStore ds1, ds2

//If iiNgSeq <= 0 Then Return 0

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
		iseq	  = ds2.getitemnumber(ix,'iseq')
		
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
						 ( "SABU",           "COSTNO",          "ISEQ",			  "COSTSEQ",      "CINO",
							"PINO",           "COSTAMT",         "COSTVAT",      "COSTFORAMT",
							"NGNO" )  
				VALUES ( :gs_sabu,        :sCostNo,          :iseq,			  :iy,            :sCino,   
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
			 VALUES ( :gs_sabu,        :sCostNo,          :iseq,			  1,            	NULL,   
						 NULL,          	:dCostAmt,         0,              :dCostForAmt,
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

public function integer wf_calc_move (string scino, integer ix);Double dWeight, dMax
String sCurr, sSaupj
Dec {2} dWrate, dWamt, dUamt
Dec {4} dUrate

sCurr  = dw_insert.GetItemString(ix,"CURR")
sSaupj = dw_insert.GetItemString(ix,"saupj")

/* 가중치 */
Select to_number(rfna2) into :dWeight
  from reffpf
 where rfcod = '10' and
       rfgub = :sCurr;
If sqlca.sqlcode <> 0 Then Return -1

/* 면장환율 */
dWrate = dw_insert.GetItemNumber(ix,"export_wrate")
dUrate = dw_insert.GetItemNumber(ix,"export_urate")

/* 수출매출 자동전표 수정 */
update kif05ot0
	set wrate = :dWrate,
	    urate = :dUrate,
	    wamt = trunc((expamt * :dWrate)/:dweight,0),
		 uamt = trunc((expamt * :dWrate)/:dweight,2)
 where sabu  = :sSaupj and
		 cino  = :sCino;
		 
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),string(sqlca.sqlerrtext))
	RollBack;
	f_message_chk(32,'[수출매출 자동전표]')
	Return -1
End If

/* 수출매출 품목 자동전표 수정 */
update kif05ot1
	set wamt = trunc((ciamt * :dWrate)/:dweight,0),
		 uamt = trunc((ciamt * :dWrate)/:dweight,2)
 where sabu  = :sSaupj and
		 cino  = :sCino;
		 
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),string(sqlca.sqlerrtext))
	RollBack;
	f_message_chk(32,'[수출매출 품목 자동전표]')
	Return -1
End If

/* 끝전차이 수정 */
select nvl(a.wamt - sum(b.wamt),0),
       nvl(a.uamt - sum(b.uamt),0),
		 max(b.ciseq)
  into :dWamt, :dUamt, :dMax
  from kif05ot0 a, kif05ot1 b
 where a.sabu = b.sabu and
       a.cino = b.cino and
		 a.sabu = :sSaupj and
		 a.cino = :sCino
 group by a.wamt, a.uamt;
		 
update kif05ot1
	set wamt = wamt + nvl(:dWamt,0),
		 uamt = uamt + nvl(:dUamt,0)
 where sabu  = :sSaupj and
		 cino  = :sCino and
		 ciseq = :dMax;
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),string(sqlca.sqlerrtext))
	RollBack;
	f_message_chk(32,'[수출매출 자동전표 끝전 수정]')
	Return -1
End If

Return 0
end function

on w_sal_06055.create
int iCurrent
call super::create
this.gb_7=create gb_7
this.gb_6=create gb_6
this.gb_5=create gb_5
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.dw_sunsu=create dw_sunsu
this.dw_negod=create dw_negod
this.dw_interface=create dw_interface
this.pb_1=create pb_1
this.pb_2=create pb_2
this.r_gubun=create r_gubun
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_7
this.Control[iCurrent+2]=this.gb_6
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.dw_sunsu
this.Control[iCurrent+8]=this.dw_negod
this.Control[iCurrent+9]=this.dw_interface
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.r_gubun
end on

on w_sal_06055.destroy
call super::destroy
destroy(this.gb_7)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.dw_sunsu)
destroy(this.dw_negod)
destroy(this.dw_interface)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.r_gubun)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_insert.SetTransObject(sqlca)
dw_interface.SetTransObject(sqlca)
dw_sunsu.SetTransObject(sqlca)
dw_negod.SetTransObject(sqlca)

dw_input.SetTransObject(sqlca)
f_child_saupj(dw_input, 'sarea', gs_saupj)
dw_input.InsertRow(0)


/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_input.SetItem(1, 'sarea', sarea)
	dw_input.Modify("sarea.protect=1")
	dw_input.Modify("sarea.background.color = 80859087")
End If

// 부가세 사업장 설정
f_mod_saupj(dw_input, 'saupj')

/* --------------------------------------------- */
/* 매출확정일 여부 (1:면장,2:출고,3:b/l,4:임의)  */
/* --------------------------------------------- */
select substr(dataname,1,1) into :SaleConfirm
  from syscnfg
 where sysgu = 'S' and
       serial = 8 and
       lineno = 10;


dw_input.SetItem(1, 'sdatef', Left(f_today(),6)+'01')
dw_input.SetItem(1, 'sdatet', f_today())

dw_input.SetFocus()
dw_input.SetColumn('sdatef')

dw_interface.Visible = False
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", false) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", true) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 true) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = false //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = true  //// 찾기
m_main2.m_window.m_filter.enabled = true //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event resize;call super::resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65

dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70

dw_interface.width = this.width - 70
dw_interface.height = this.height - dw_interface.y - 70
end event

type cb_exit from w_inherite`cb_exit within w_sal_06055
end type

type sle_msg from w_inherite`sle_msg within w_sal_06055
end type

type dw_datetime from w_inherite`dw_datetime within w_sal_06055
end type

type st_1 from w_inherite`st_1 within w_sal_06055
integer y = 3100
end type

type p_search from w_inherite`p_search within w_sal_06055
boolean visible = true
integer x = 3922
integer y = 24
boolean enabled = true
string picturename = "..\image\전송처리_up.gif"
end type

event p_search::clicked;call super::clicked;If this.Enabled = False Then Return

Long   ix,nRcnt,nCnt,nRow, nMaxSeq, Lrow
String sDatef,sDatet,sDept, sCino, sItnbr,sAccod
String sNgno, sCurr, sCvcod, sLocalYn, sSaupj, sCustNo
Double dNgAmt, dNgUamt, dNgWamt, dWrate,dNgamtD, dNgUamtD, dNgWamtD, dUrate,dWeight
Double dNgSeq = 0
			 
nRcnt = dw_insert.RowCount()
If nRcnt <= 0 Then Return

dw_interface.Reset()

/* 검색할 키 */
sDatef = dw_input.GetItemString(1,'sdatef')
sDatet = dw_input.GetItemString(1,'sdatet')
sLocalYn = dw_input.GetItemString(1,'localyn')

/* 수출부서 */
select dept_cd into :sDept
  from cia02m
 where cost_cd = ( select substr(dataname,1,6) from syscnfg
						  where sysgu = 'A' and serial = 20 and datagu  = 1 );

sDept = Trim(sDept)
	 
SetPointer(HourGlass!)

/* 수출매출 회계 전송(선수금현황) */
//datastore ds
//ds = create datastore
//ds.settransobject(sqlca)
//ds.dataobject = "d_sal_06055_ds"
//ds.settransobject(sqlca)

/* 회계시스템으로 이월 */
For ix = 1 To nRcnt
	If dw_insert.GetItemString(ix,'chk') = 'Y' then

		/* 매출세금계산서 자동전표 자료 */
		nRow = dw_interface.InsertRow(0)
		sCino = dw_insert.GetItemString(ix,"CINO" )
		sCvcod  = Trim(dw_insert.GetItemString(ix,"CVCOD"))
		sCustNo  =Trim(dw_insert.GetItemString(ix,"cust_no"))

		/* 최종출고처가 지정된 경우 최종출고처로 매출 발생 */
		If Not IsNull(sCustNo) And sCustNo <> '' Then
			sCvcod = sCustNo
		End If
		
		dw_interface.SetItem(nRow,"CINO",    sCino)
		dw_interface.SetItem(nRow,"CVCOD",   sCvcod )
		dw_interface.SetItem(nRow,"DEPT_CD", sDept )
		
		sSaupj = dw_insert.GetItemString(ix,"SAUPJ" )
		dw_interface.SetItem(nRow,"SABU",   gs_sabu)
		dw_interface.SetItem(nRow,"CIDATE", dw_insert.GetItemString(ix,"SALEDT" )) // 매출확정일자 
		dw_interface.SetItem(nRow,"CISTS",  dw_insert.GetItemString(ix,"CISTS" ))
		dw_interface.SetItem(nRow,"OUTCFDT",dw_insert.GetItemString(ix,"OUTCFDT"))

		dw_interface.SetItem(nRow,"SELLER",  dw_insert.GetItemString(ix,"SELLER"))
		dw_interface.SetItem(nRow,"CONSIGNEE",  dw_insert.GetItemString(ix,"CONSIGNEE"))
		dw_interface.SetItem(nRow,"SHIPDAT",  dw_insert.GetItemString(ix,"SHIPDAT"))
		dw_interface.SetItem(nRow,"VF_FROM",  dw_insert.GetItemString(ix,"VF_FROM"))
		dw_interface.SetItem(nRow,"VF_TO",  dw_insert.GetItemString(ix,"VF_TO"))
		dw_interface.SetItem(nRow,"EXPLCNO",  dw_insert.GetItemString(ix,"EXPLCNO"))
		dw_interface.SetItem(nRow,"BUYER",  dw_insert.GetItemString(ix,"BUYER"))
		dw_interface.SetItem(nRow,"OTHER_REF",  dw_insert.GetItemString(ix,"OTHER_REF"))
		dw_interface.SetItem(nRow,"TERM_DELI_PAY",  dw_insert.GetItemString(ix,"TERM_DELI_PAY"))
		dw_interface.SetItem(nRow,"CINOTES",  dw_insert.GetItemString(ix,"CINOTES"))
		dw_interface.SetItem(nRow,"SHIPMARK",  dw_insert.GetItemString(ix,"SHIPMARK"))
		dw_interface.SetItem(nRow,"CTQTY",  dw_insert.GetItemNumber(ix,"CTQTY"))
		dw_interface.SetItem(nRow,"CURR",  dw_insert.GetItemString(ix,"CURR"))
		dw_interface.SetItem(nRow,"WRATE",  dw_insert.GetItemNumber(ix,"WRATE"))
		dw_interface.SetItem(nRow,"URATE",  dw_insert.GetItemNumber(ix,"URATE"))
		
		/* 수출면장번호로 변경(2000.09.27) kif05ot0의 expno varchar2(11) -> varchar2(20) */
		dw_interface.SetItem(nRow,"EXPNO",  dw_insert.GetItemString(ix,"exppmtno"))
		dw_interface.SetItem(nRow,"EXPAMT",  dw_insert.GetItemNumber(ix,"EXPAMT"))
		dw_interface.SetItem(nRow,"WAMT",  dw_insert.GetItemNumber(ix,"WAMT"))
		dw_interface.SetItem(nRow,"UAMT",  dw_insert.GetItemNumber(ix,"UAMT"))
		dw_interface.SetItem(nRow,"BLNO",  dw_insert.GetItemString(ix,"BLNO"))
		dw_interface.SetItem(nRow,"VF",  dw_insert.GetItemString(ix,"VF"))		
		dw_interface.SetItem(nRow,"VATGU",  dw_insert.GetItemString(ix,"VATGU"))
		dw_interface.SetItem(nRow,"SAUPJ",  sSaupj)
		dw_interface.SetItem(nRow,"SACCOD",  '01')
		dw_interface.SetItem(nRow,"ALC_GU", 'N')


		/* 매출세금계산서 품목 자동전표 자료 */
		insert into kif05ot1
			value ( sabu,    cino,   ciseq,   pino,   piseq,   itnbr,   order_spec,
					  ciqty,   ciprc,  ciamt,   wamt,   uamt,
					  accod  )    /* salegu 삭제 2002.2.22  옥준철 */
			select  d.sabu, a.cino, a.ciseq, a.pino, a.piseq, a.itnbr, a.order_spec,
					  a.ciqty, a.ciprc,a.ciamt, a.wamt, a.uamt,
					  decode(nvl(d.localyn,'N'),'N',decode(a.order_spec,'.',fun_get_itnacc(a.itnbr,'2'),fun_get_itnacc(a.itnbr,'7')),
					  									 'Y',decode(a.order_spec,'.',fun_get_itnacc(a.itnbr,'3'),fun_get_itnacc(a.itnbr,'7')),
														 null)
			  from expcid a, itemas b, expcih d
			 where a.itnbr = b.itnbr and
					 a.sabu = d.sabu and
					 a.cino  = d.cino and
					 a.sabu = :gs_sabu and 
					 a.cino = :sCino ;
					 
		If sqlca.sqlcode <> 0 Then
			f_message_chk(32,'[SQLcode 1: ' + string(sqlca.sqlerrtext)+']')
			RollBack;
//			destroy ds
			p_can.TriggerEvent(Clicked!)
			Return -1
		End If
		
		/* ci max seq */
		select max(ciseq) into :nMaxSeq
		  from expcid 
		 where sabu = :gs_sabu and
		       cino = :sCino;
		If IsNull(nMaxSeq) then nMaxSeq = 0
		
		nMaxSeq += 1

		/* 비용을 대체할 품번 */
		SELECT SUBSTR(bigo,1,15) INTO :sItnbr FROM ITNCT
		 WHERE ITTYP = '9' AND
				 TITNM = '기타수출';

		/* 비용 계정코드 */
		select decode(nvl(:sLocalyn,'N'),'N',fun_get_itnacc(:sitnbr,'2'),'Y',fun_get_itnacc(:sitnbr,'3'),null)
		  into :sAcCod
		  from dual;

		/* 비용 품목 자동전표 자료 */
		insert into kif05ot1
			value ( sabu,    cino,   ciseq,   pino,     piseq,   itnbr,   order_spec,
					  ciqty,   ciprc,  ciamt,   wamt,     uamt,	  accod )
			select  :gs_sabu, cino,   :nMaxSeq + rownum, pino,    rownum,  :sItnbr, '.',
					  0,       0,      chramt,  wamt,     uamt,    :sAccod
			  from expcich
			 where sabu = :gs_sabu and 
					 cino = :sCino ;

		If sqlca.sqlcode <> 0 Then
			f_message_chk(32,'[SQLcode 2: ' + string(sqlca.sqlerrtext)+']')
			RollBack;
//			destroy ds
			p_can.TriggerEvent(Clicked!)
			Return -1
		End If
	
		/* 선nego  */
		insert into kif05ot2
				  ( sabu,      cino,      ngno,     ngseq,   ngamt,
					 curr,      wrate,     uamt,     wamt,    cvcod )
			select :gs_sabu, z.cino,    z.ngno,   rownum,  z.ngamt,
					 z.curr,    z.wrate,   Z.uamt,   Z.wamt,  Z.cvcod
			  from (	select y.cino,    y.ngno,   sum(y.ngamt) as ngamt,
								 x.curr,    x.wrate,   sum(y.uamt) as uamt,   sum(y.wamt) as wamt,  x.cvcod
						  from expnegoh x, expnegod y
						 where x.ngno = y.ngno and
								 y.cino = :sCino and
								 y.datagu = '2'
						 group by y.cino, y.ngno, x.curr, x.wrate, x.cvcod ) z;

			If sqlca.sqlcode <> 0 Then
				sle_msg.Text = string(sqlca.sqlcode) + ' ' + sqlca.sqlerrtext
				f_message_chk(32,'[SQLcode 3: ' + string(sqlca.sqlcode)+']')
				RollBack;
				p_can.TriggerEvent(Clicked!)
				Return
			End If

//		ds.retrieve(scino)
//		For Lrow = 1 to ds.rowcount()
//			 sngno 	= ds.getitemstring(Lrow, "ngno")
//			 dngamt 	= ds.getitemdecimal(Lrow, "ngamt")
//			 dnguamt	= ds.getitemdecimal(Lrow, "nguamt")
//			 dngwamt	= ds.getitemdecimal(Lrow, "ngwamt")
//			 scurr 	= ds.getitemstring(Lrow, "curr")
//			 dwrate	= ds.getitemdecimal(Lrow, "wrate")
//			 	
//			select nvl(sum(ngamt),0), nvl(sum(uamt),0) , nvl(sum(wamt),0)
//			  into :dNgamtD, :dNgUamtD, :dNgWamtD
//			  from expnegod 
//			 where sabu = :gs_sabu and
//					 ngno = :sNgno and
//					 datagu = '1';
//
//			dNgSeq  = dNgseq + 1
//			dNgAmt  = Truncate(dNgAmt - dNgAmtD,2)
//			
//			/* 가중치 */
//			If sCurr <> 'WON' Then
//				Select to_number(rfna2) into :dWeight
//				  from reffpf
//				 where rfcod = '10' and
//						 rfgub = :sCurr;
//				If sqlca.sqlcode <> 0 Then Return -1
//	
//				If IsNull(dWeight) Then dWeight = 1
//					dNgUAmt = Truncate((dNgAmt * dUrate)/dWeight,2)
//					dNgWAmt = Truncate((dNgAmt * dWrate)/dWeight,0)
//				Else
//					dNgUAmt = Truncate(dNgUAmt - dNgUAmtD,2)
//					dNgWAmt = Truncate(dNgWAmt - dNgWAmtD,2)
//				End If
//
//				insert into kif05ot2
//						  ( sabu,      cino,      ngno,     ngseq,   ngamt,
//							 curr,      wrate,     uamt,     wamt,    cvcod )
//				 values ( :gs_sabu, :sCino,    :sNgno,   :dNgseq, :dNgAmt,
//							 :sCurr,    :dWrate,   :dNgUamt, :dNgWamt,:scvcod ) ;
//			 
//				If sqlca.sqlcode <> 0 Then
//					sle_msg.Text = string(sqlca.sqlcode) + ' ' + sqlca.sqlerrtext
//					f_message_chk(32,'[SQLcode 3: ' + string(sqlca.sqlcode)+']')
//					RollBack;
//					destroy ds
//					p_can.TriggerEvent(Clicked!)
//					Return
//				End If
//		Next
		nCnt += 1
	End If
Next

//Destroy ds

If nCnt <=0 Then
	f_message_chk(57,'')
	Return
End If

If dw_interface.Update() <> 1 then
	f_message_chk(32,'[SQLcode 4: ' + string(sqlca.sqlcode)+']')
	RollBack;
	Return
Else
	/* Local 계산서 회계전송시 면장환율로 전송시 다시 계산한다 */
	If dw_input.GetItemString(1,'chk') = 'Y' then
		For ix = 1 To dw_insert.RowCount()		
			If dw_insert.GetItemString(ix,'chk') = 'Y' Then
				sCino = dw_insert.GetItemString(ix,"CINO" )
				If wf_calc_move(sCino, ix) <> 0 Then
					RollBack;
					Return
				End If
			End If
		Next
	End If
	
	Commit;
	string	sArea
	sarea  = Trim(dw_input.GetItemString(1,'sarea'))
	dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sarea+'%')
End If

sle_msg.text ='자료를 저장하였습니다!!'
end event

event p_search::ue_lbuttonup;PictureName = "..\image\전송처리_up.gif"
end event

event p_search::ue_lbuttondown;PictureName = "..\image\전송처리_dn.gif"
end event

type p_addrow from w_inherite`p_addrow within w_sal_06055
integer y = 3100
end type

type p_delrow from w_inherite`p_delrow within w_sal_06055
integer y = 3100
end type

type p_mod from w_inherite`p_mod within w_sal_06055
integer x = 1819
integer y = 3100
integer width = 178
integer height = 144
string picturename = "..\image\전송처리_up.gif"
end type

type p_del from w_inherite`p_del within w_sal_06055
boolean visible = true
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "..\image\전송취소_d.gif"
end type

event p_del::clicked;call super::clicked;If this.Enabled = False Then Return

Long ix,nRcnt,nCnt,nRow
String sDatef,sDatet,sJasa, sCiNo, sSaupj, sArea

nRcnt = dw_interface.RowCount()
If nRcnt <= 0 Then Return

/* 검색할 키 */
sDatef = dw_input.GetItemString(1,'sdatef')
sDatet = dw_input.GetItemString(1,'sdatet')
sSaupj = dw_input.GetItemString(1,'saupj')
sarea  = Trim(dw_input.GetItemString(1,'sarea'))

If IsNull(sArea) Then sArea = ''

SetPointer(HourGlass!)

For ix = nRcnt To 1 Step -1
	If dw_interface.GetItemString(ix,'chk') = 'Y' then
		
		sCiNo = dw_interface.GetItemString(ix,'cino')
		/* 매출세금계산서 품목 자동전표 삭제 */
      DELETE FROM "KIF05OT0"
        WHERE ( "KIF05OT0"."SABU" = :gs_sabu ) AND
		        ( "KIF05OT0"."CINO" = :sCiNo ) AND
				  ( "KIF05OT0"."BAL_DATE" IS NULL );

		If sqlca.sqlcode = 0 And sqlca.sqlnRows >= 1 Then
			/* 매출세금계산서 품목 자동전표 삭제 */
			DELETE FROM "KIF05OT1"  
			  WHERE ( "KIF05OT1"."SABU" = :gs_sabu ) AND
					  ( "KIF05OT1"."CINO" = :sCiNo );
		Else
			RollBack;
			MessageBox('확 인','기 전표발행된 자료가 존재합니다')
			Return
		End If
		
		/* 선Nego 품목 자동전표 삭제 */
		DELETE FROM "KIF05OT2"
		  WHERE ( "KIF05OT2"."SABU" = :gs_sabu ) AND
				  ( "KIF05OT2"."CINO" = :sCiNo );
		If sqlca.sqlcode <> 0  Then
			RollBack;
			MessageBox('확 인','전표삭제시 유류가 발생했습니다')
			Return
		End If
		
		nCnt += 1
	End If
Next

If nCnt <=0 Then
	f_message_chk(57,'')
	Return
End If

Commit;

dw_interface.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')

sle_msg.text ='자료를 저장하였습니다!!'

end event

event p_del::ue_lbuttonup;PictureName = "..\image\전송취소_up.gif"
end event

event p_del::ue_lbuttondown;PictureName = "..\image\전송취소_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_sal_06055
integer y = 3100
end type

event p_inq::clicked;call super::clicked;String sDatef,sDatet, sSaupj, sarea
Long   nRcnt

If dw_input.AcceptText() <> 1 Then Return
If dw_input.RowCount() <= 0 Then Return

sSaupj = Trim(dw_input.GetItemString(1,'saupj'))
sDatef = Trim(dw_input.GetItemString(1,'sdatef'))
sDatet = Trim(dw_input.GetItemString(1,'sdatet'))
sarea  = Trim(dw_input.GetItemString(1,'sarea'))

dw_input.SetFocus()
IF f_datechk(sDatef) <> 1 THEN
	f_message_chk(30,'[발행일자]')
	dw_input.SetColumn("sdatef")
	Return
END IF

IF f_datechk(sDatet) <> 1 THEN
	f_message_chk(30,'[발행일자]')
	dw_input.SetColumn("sdatet")
	Return
END IF

IF IsNull(sSaupj) Or sSaupj = '' THEN
	f_message_chk(1400,'[부가사업장]')
	dw_input.SetColumn("saupj")
	Return
END IF

If IsNull(sArea) Then sArea = ''

If rb_1.Checked = True Then
	nRcnt = dw_insert.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')
Else
	nRcnt = dw_interface.Retrieve(gs_sabu, sDatef,sDatet, sSaupj, sArea+'%')
End If

If nRcnt <= 0 Then
	f_message_chk(50,'')
	dw_input.Setfocus()
End If
end event

type p_print from w_inherite`p_print within w_sal_06055
integer y = 3100
end type

type p_can from w_inherite`p_can within w_sal_06055
integer y = 3100
end type

event p_can::clicked;call super::clicked;cbx_1.Checked = False

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite`p_exit within w_sal_06055
integer y = 3100
end type

type p_ins from w_inherite`p_ins within w_sal_06055
integer x = 3913
integer y = 3100
integer width = 178
integer height = 144
string picturename = "..\image\연결_up.gif"
end type

event p_ins::clicked;call super::clicked;String sCino, sCvcod, sSaupj, sWeight
Long   nRow

nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then Return

sCino  = dw_insert.GetItemString(nRow, 'cino')
sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sSaupj = dw_insert.GetItemString(nRow, 'saupj')
sWeight = dw_insert.GetItemString(nRow, 'weight')
		 
/* 선수금내역이 있으면 Nego자료를 생성후 재저장한다 */
If wf_check_nego(sCino, sCvcod, sweight) = -1 Then
	RollBack;
	wf_ret_sunsu(nRow)
	return -1
End If

/* 선수금내역에 대한 수수료가 있을 경우 해당 Nego에 대해서 비용배분을 한다 */
If wf_check_nego_charge() = -1 Then
	RollBack;
	wf_ret_sunsu(nRow)
	return -1
End If

COMMIT;

wf_ret_sunsu(nRow)

end event

type p_new from w_inherite`p_new within w_sal_06055
integer y = 3100
end type

type dw_input from w_inherite`dw_input within w_sal_06055
event ue_processenter pbm_dwnprocessenter
integer x = 366
integer y = 56
integer width = 2921
integer height = 188
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_06055_4"
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sSuDate,sNull, sLocalYn, sSaupj

SetNull(sNull)
Choose Case GetColumnName()
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'sarea', sSaupj)
	Case "sdatef" , "sdatet"
		sSuDate = Trim(this.GetText())
		IF sSuDate ="" OR IsNull(sSuDate) THEN RETURN
		
		IF f_datechk(sSuDate) = -1 THEN
			f_message_chk(35,'[발행기간]')
			this.SetItem(1,GetColumnName() ,snull)
			Return 1
		END IF
	Case 'localyn'
		dw_insert.SetRedraw(False)
		If GetText() = 'N' Then
			/* Direct일 경우는 면장환율로 전송 불가 */
			SetItem(1,'chk','N')
			Modify("chk.visible = 0")
			
			dw_insert.DataObject = 'd_sal_06055_1'
		Else
			/* Local인 경우 */
//			If SaleConfirm = '2' Then Modify("chk.visible = 1")
			
			dw_insert.DataObject = 'd_sal_06055_3'
		End If
		dw_insert.SetTransObject(sqlca)
		dw_insert.SetRedraw(True)
END Choose
end event

event itemerror;return 1
end event

type cb_delrow from w_inherite`cb_delrow within w_sal_06055
boolean visible = false
integer y = 3100
end type

type cb_addrow from w_inherite`cb_addrow within w_sal_06055
boolean visible = false
integer y = 3100
end type

type dw_insert from w_inherite`dw_insert within w_sal_06055
integer x = 37
integer y = 296
integer width = 3489
integer height = 1964
integer taborder = 40
string dataobject = "d_sal_06055_1"
end type

event dw_insert::clicked;call super::clicked;If row <= 0 Then Return

SelectRow(0,   FALSE)
SelectRow(row, TRUE)

wf_ret_sunsu(row)
end event

type cb_mod from w_inherite`cb_mod within w_sal_06055
boolean visible = false
integer y = 3100
end type

event cb_mod::clicked;call super::clicked;String sCino, sCvcod, sSaupj
Long   nRow

nRow = dw_insert.GetSelectedRow(0)
If nRow <= 0 Then Return

sCino  = dw_insert.GetItemString(nRow, 'cino')
sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sSaupj = dw_insert.GetItemString(nRow, 'saupj')

/* 선수금처리된것이 있으면 삭제한다 */
Delete from expnegod
 where sabu = :gs_sabu and
       cino = :sCino and
		 datagu = '2';
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(57,'[Nego삭제시 오류]')
	Return -1
End If

/* 선수금내역에 대한 수수료가 있을 경우 해당 Nego에 대해서 비용배분을 한다 */
If sqlca.sqlnrows > 0 Then
	If wf_check_nego_charge() = -1 Then
		RollBack;
		f_message_chk(57,'[Nego 수수료 삭제시 오류]')
		return -1
	End If
End If

COMMIT;

wf_ret_sunsu(nRow)
end event

type cb_ins from w_inherite`cb_ins within w_sal_06055
boolean visible = false
integer y = 3100
end type

type cb_del from w_inherite`cb_del within w_sal_06055
boolean visible = false
integer y = 3100
end type

type cb_inq from w_inherite`cb_inq within w_sal_06055
boolean visible = false
integer y = 3100
end type

type cb_print from w_inherite`cb_print within w_sal_06055
boolean visible = false
integer y = 3100
end type

type cb_can from w_inherite`cb_can within w_sal_06055
boolean visible = false
integer y = 3100
end type

type cb_search from w_inherite`cb_search within w_sal_06055
boolean visible = false
integer y = 3100
end type

type gb_10 from w_inherite`gb_10 within w_sal_06055
end type

type gb_button1 from w_inherite`gb_button1 within w_sal_06055
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_06055
end type

type r_head from w_inherite`r_head within w_sal_06055
integer x = 362
integer width = 2929
end type

type r_detail from w_inherite`r_detail within w_sal_06055
integer y = 292
end type

type gb_7 from groupbox within w_sal_06055
boolean visible = false
integer x = 681
integer y = 2720
integer width = 818
integer height = 176
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "선수금"
end type

type gb_6 from groupbox within w_sal_06055
boolean visible = false
integer x = 1664
integer y = 2680
integer width = 1856
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_5 from groupbox within w_sal_06055
boolean visible = false
integer x = 64
integer y = 2680
integer width = 421
integer height = 176
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_1 from radiobutton within w_sal_06055
integer x = 78
integer y = 72
integer width = 219
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "처리"
boolean checked = true
end type

event clicked;dw_insert.Reset()
dw_interface.Reset()

dw_sunsu.Reset()
dw_negod.Reset()

p_search.Enabled = True
p_del.Enabled = False
p_search.PictureName = '..\image\전송처리_up.gif'
p_del.PictureName = '..\image\전송취소_d.gif'

dw_insert.SetFocus()
dw_insert.Visible = True
dw_interface.Visible = False

cbx_1.Checked = False

dw_input.SetFocus()
dw_input.SetColumn('sdatef')
end event

type rb_2 from radiobutton within w_sal_06055
integer x = 78
integer y = 148
integer width = 219
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12639424
string text = "취소"
end type

event clicked;dw_insert.Reset()
dw_interface.Reset()

dw_sunsu.Reset()
dw_negod.Reset()

p_search.Enabled = False
p_del.Enabled = True
p_search.PictureName = '..\image\전송처리_d.gif'
p_del.PictureName = '..\image\전송취소_up.gif'

dw_interface.SetFocus()
dw_insert.Visible = False
dw_interface.Visible = True

cbx_1.Checked = False

dw_input.SetFocus()
dw_input.SetColumn('sdatef')
end event

type cbx_1 from checkbox within w_sal_06055
integer x = 2757
integer y = 160
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "전체선택"
end type

event clicked;long ix
String sStatus

IF This.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

If rb_1.Checked = True Then
  For ix = 1 To dw_insert.RowCount()
	  dw_insert.SetItem(ix,'chk',sStatus)
  Next
ElseIf rb_2.Checked = True Then
  For ix = 1 To dw_interface.RowCount()
	  dw_interface.SetItem(ix,'chk',sStatus)
  Next
End If
end event

type dw_sunsu from u_d_select_sort within w_sal_06055
boolean visible = false
integer x = 32
integer y = 3344
integer width = 1755
integer height = 532
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "미연결 선수금(회계전표발행자료)-선수금액 입력"
string dataobject = "d_sal_06055_5"
end type

type dw_negod from u_d_select_sort within w_sal_06055
boolean visible = false
integer x = 1888
integer y = 3288
integer width = 1550
integer height = 532
integer taborder = 11
boolean bringtotop = true
boolean titlebar = true
string title = "연결 선수금"
string dataobject = "d_sal_06055_6"
end type

type dw_interface from u_key_enter within w_sal_06055
integer x = 37
integer y = 296
integer width = 3489
integer height = 1964
integer taborder = 90
string dataobject = "d_sal_06055_2"
boolean vscrollbar = true
boolean border = false
end type

type pb_1 from u_pic_cal within w_sal_06055
integer x = 1106
integer y = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pic_cal within w_sal_06055
integer x = 1573
integer y = 76
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_input.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_input.SetItem(1, 'sdatet', gs_code)

end event

type r_gubun from rectangle within w_sal_06055
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 12639424
integer x = 32
integer y = 52
integer width = 320
integer height = 196
end type

