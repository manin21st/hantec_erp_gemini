$PBExportHeader$w_sm04_00005.srw
$PBExportComments$출하의뢰등록
forward
global type w_sm04_00005 from w_inherite
end type
type dw_1 from u_key_enter within w_sm04_00005
end type
type rr_1 from roundrectangle within w_sm04_00005
end type
type pb_1 from u_pb_cal within w_sm04_00005
end type
type pb_2 from u_pb_cal within w_sm04_00005
end type
type st_2 from statictext within w_sm04_00005
end type
type pb_3 from u_pb_cal within w_sm04_00005
end type
type dw_imsi from datawindow within w_sm04_00005
end type
type cbx2_all from checkbox within w_sm04_00005
end type
end forward

global type w_sm04_00005 from w_inherite
integer height = 2492
string title = "출하의뢰등록"
dw_1 dw_1
rr_1 rr_1
pb_1 pb_1
pb_2 pb_2
st_2 st_2
pb_3 pb_3
dw_imsi dw_imsi
cbx2_all cbx2_all
end type
global w_sm04_00005 w_sm04_00005

type variables
str_code istr_itnbr

end variables

forward prototypes
public function integer wf_danga (integer nrow)
public function integer wf_require_chk (string ar_dataobject)
public function integer wf_init ()
end prototypes

public function integer wf_danga (integer nrow);String sToday, sCvcod, sItnbr, sSpec
Double dItemPrice, dDcRate

sToday = f_today()

sCvcod = dw_insert.GetItemString(nRow, 'cvcod')
sItnbr = dw_insert.GetItemString(nRow, 'itnbr')
sSpec  = dw_insert.GetItemString(nRow, 'pspec')

if	isNull(sCvcod) or sCvcod = '' then
	sCvcod = '.'
end if	

if	isNull(sItnbr) or sItnbr = '' then
	sItnbr = '.'
end if	

dItemPrice  = sqlca.FUN_ERP100000012_1(sToday ,sCvcod, sItnbr , sSpec )

If IsNull(dItemPrice) Then dItemPrice = 0

dw_insert.SetItem(nRow, 'itm_prc', dItemPrice)

return 1
end function

public function integer wf_require_chk (string ar_dataobject);If ar_dataobject = "d_sm40_0010_1" Then
	
	Long ll_rcnt
	String ls_start , ls_start_time , ls_arrive , ls_arrive_time ,ls_carno
	
	ll_rcnt = dw_1.RowCount()
	If dw_1.AcceptText() < 1 Then Return -1
	If ll_rcnt <  1 Then Return -1
	
	ls_start 	   =  Trim(dw_1.Object.start_dt[1])
	ls_start_time  =  Trim(dw_1.Object.start_time[1])
	ls_arrive      =  Trim(dw_1.Object.arriv_dt[1])
	ls_arrive_time =  Trim(dw_1.Object.arriv_time[1])
	
	ls_carno = Trim(dw_1.Object.trans_carno[1])
	
	If ls_start = '' Or isNull(ls_start) Or f_datechk(ls_start) < 1 Then
		f_message_chk(35,'[출발일자]')
		dw_1.SetFocus()
		dw_1.SetColumn("start_dt")
		Return -1
	End if
	
	If ls_arrive = '' Or isNull(ls_arrive) Or f_datechk(ls_arrive) < 1 Then
		f_message_chk(35,'[도착일자]')
		dw_1.SetFocus()
		dw_1.SetColumn("arriv_dt")
		Return -1
	End if
	
	
End If

Return 1

	
end function

public function integer wf_init ();String ls_saupj , ls_factory , ls_ymd , ls_itnbr

If dw_1.AcceptText() < 1 Then Return -1

ls_saupj 	= Trim(dw_1.Object.saupj[1])
ls_ymd 		= Trim(dw_1.Object.sdate[1])
ls_factory 	= Trim(dw_1.Object.plant[1])
ls_itnbr 	= Trim(dw_1.Object.itnbr[1])

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_itnbr = '' Or isNull(ls_itnbr)  Then ls_itnbr = '%'

dw_1.Reset()

dw_insert.Reset()
dw_1.InsertRow(0)


f_mod_saupj(dw_1, 'saupj')

dw_1.Object.sdate[1] 		= is_today
dw_1.Object.start_dt[1] 	= is_today
dw_1.Object.start_time[1] 	= is_totime
dw_1.Object.arriv_dt[1] 	= is_today
dw_1.Setitem(1, "ckasu", '1')

dw_1.SetFocus()
dw_1.SetColumn("itnbr")


return 1
end function

on w_sm04_00005.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_2=create st_2
this.pb_3=create pb_3
this.dw_imsi=create dw_imsi
this.cbx2_all=create cbx2_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.dw_imsi
this.Control[iCurrent+8]=this.cbx2_all
end on

on w_sm04_00005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_2)
destroy(this.pb_3)
destroy(this.dw_imsi)
destroy(this.cbx2_all)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)
dw_imsi.SetTransObject(SQLCA)
dw_1.InsertRow(0)

wf_init()





end event

type dw_insert from w_inherite`dw_insert within w_sm04_00005
integer x = 27
integer y = 388
integer width = 4581
integer height = 1916
integer taborder = 140
string dataobject = "d_sm04_00005_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec  dmmqty, davg
Long nJucha, ix, nRow
Int  ireturn
String sitnbr, sitdsc, sispec, sjijil, sispec_code, s_cvcod, snull, get_nm 
Double ld_reqty_temp , ld_balqty , ld_REQTY, ld_no, ld_qty
String ls_holdno , ls_no, ls_kind

If dw_1.AcceptText() < 1 Then Return


setnull(snull)

nRow = GetRow()
If nRow <= 0 Then Return

ls_kind  = dw_insert.GetItemString(nRow, "in_kind")


Choose Case GetColumnName()
	Case 'is_chk'
		get_nm = trim(this.GetText())
		ld_reqty_temp = Double(this.GetItemDecimal(nrow, "reqty_temp") )
		
		If get_nm = 'Y' Then
			object.reqty_temp[row] = object.minap_qty[row]
			ld_qty	= dw_insert.GetItemDecimal(nrow, "gure_gigan") 
			dw_insert.SetItem(nrow, "boxqty", Ceiling(ld_reqty_temp/ld_qty))
			SetColumn("reqty_temp")
		Else
			object.reqty_temp[row] 	= 0
			object.boxqty[row] 		= 0
		End iF
	Case 'reqty_temp'
		
		ld_reqty_temp = Double(this.GetText())
		
		If ld_reqty_temp  = 0 Then
			Return 1
		End iF

		ld_balqty = object.bal_qty[row]
		ld_REQTY  = object.REQTY[row]
		

		If (ld_balqty -ld_REQTY ) - ld_reqty_temp  < 0 Then
			object.reqty_temp[row] = 0
			MessageBox('확인','출하수량이 발주수량보다 클수 없습니다.')
			Return 1
		End iF

		If ld_balqty  - ld_reqty_temp  > 0 Then
			/*  copy 복사본 장소를 clear 한후 전체 row를 복사가 아니라 
			                       1 row 만 복사데이타를 복사한다. */
			dw_imsi.reset()
//			dw_insert.RowsCopy(dw_insert.GetRow(), &
//							  dw_insert.RowCount(), Primary!, dw_imsi, 1, Primary!)
			dw_insert.RowsCopy(dw_insert.GetRow(), &
							  nrow, Primary!, dw_imsi, 1, Primary!)
			/* 1. 원래 분할출하수량 --> 발주수량   
			   2. 추가 발주수량 =  원 발주수량 - 출하수량
			*/				  
			dw_insert.SetItem(nRow, "bal_qty" , ld_reqty_temp)
			dw_imsi.SetItem(1, "bal_qty" , ld_balqty - ld_reqty_temp)
			dw_imsi.SetItem(1, "in_kind" , ls_kind)
			ls_holdno 	= MID(dw_imsi.GetItemString(1, "hold_no") , 1,11) + '%'
			
			SELECT SUBSTR(MAX(HOLD_NO),12,4) into :ls_no FROM SM04_DAILY_ITEM 
			 WHERE HOLD_NO LIKE :ls_holdno;
			 
			ld_no    	= long(ls_no) + 1
			ls_holdno   = mid(ls_holdno,1,11) + string(ld_no,"0000")
			dw_imsi.SetItem(1, "hold_no" , ls_holdno)
			dw_imsi.SetItem(1, "reqty_temp" , 0)
			
			dw_insert.setRedraw(False)
			
			IF dw_imsi.Update() <> 1 THEN
				MessageBox('확인2 dw_imsi',sqlca.sqlerrText)
				dw_insert.setRedraw(true)
				ROLLBACK;
				Return
			else	
				IF dw_insert.Update() <> 1 THEN
					MessageBox('확인2 dw_insert',sqlca.sqlerrText)
					dw_insert.setRedraw(true)
					ROLLBACK;
					Return
				end if	
			end if

			dw_insert.reset()
			p_inq.TriggerEvent(clicked!)
			
			
			dw_insert.setrow(nrow)
			dw_insert.SetFocus()
			dw_insert.setcolumn("reqty_temp")
			dw_insert.setRedraw(true)
		End iF

		/* box 수량 확인 */
		
		ld_qty	= dw_insert.GetItemDecimal(nrow, "gure_gigan") 
		dw_insert.SetItem(nrow, "boxqty", Ceiling(ld_reqty_temp/ld_qty))
		
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itdsc", sitdsc)
		
		Post wf_danga(nrow)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'cvnas', get_nm)
		else
			this.setitem(nrow, 'cvcod', snull)
			this.setitem(nrow, 'cvnas', snull)
			this.triggerevent(RbuttonDown!)
			return 1
		end if
		
		Post wf_danga(nrow)

		

End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(lrow,"itnbr",gs_code)
		this.SetItem(lrow,"itdsc",gs_codename)
		
		Post wf_danga(lrow)
		
		Return 1
	Case 'cvcod'
		gs_code = GetText()
      gs_gubun = '1'
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(lrow, "cvcod", gs_Code)
		this.SetItem(lrow, "cvnas", gs_Codename)
		
		Post wf_danga(lrow)
End Choose
end event

event dw_insert::clicked;call super::clicked;//f_multi_select(this)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;
if currentrow < 1 then return 
if this.rowcount() < 1 then return 


this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)
end event

type p_delrow from w_inherite`p_delrow within w_sm04_00005
integer x = 4270
integer y = 172
integer taborder = 70
end type

event p_delrow::clicked;call super::clicked;Long Lrow 
String ls_holdno


Lrow = dw_insert.getrow()
if Lrow < 1 then return

ls_holdno = dw_insert.getitemstring(Lrow, "hold_no")

if MessageBox("삭제확인", "접수번호 : " + ls_holdno + '~n' + &
								  "을 삭제하시겠읍니까?", question!, yesno!) = 1 then
	ib_any_typing = true								  							  
	dw_insert.deleterow(Lrow)
End if
end event

type p_addrow from w_inherite`p_addrow within w_sm04_00005
integer x = 4096
integer y = 172
integer taborder = 60
end type

event p_addrow::clicked;call super::clicked;long lRow, lin,  ll_count
integer i_maxseq 
String ls_holdNo, ls_saupj, ls_maxseq, ls_ymd

ls_ymd 		= Trim(dw_1.Object.sdate[1])
ls_saupj		= Trim(dw_1.Object.saupj[1])

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

i_maxseq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'S1')
IF i_maxseq <= 0 THEN
	ROLLBACK;
	f_message_chk(51,'[접수번호]')
	Return -1
END IF

ls_holdNo = ls_ymd + String(i_maxseq,'000') + '0001'
Commit;


Lin  = dw_insert.getrow()
ll_count = dw_insert.rowCount()



IF dw_insert.RowCount() > 0 THEN
	lrow = dw_insert.insertrow(Lin+1)
	dw_insert.ScrollToRow(lrow)
	dw_insert.setitem(lRow, "saupj", ls_saupj)
	dw_insert.setitem(lRow, "hold_no", ls_holdNo)
	dw_insert.setitem(lRow, "YYMMDD", ls_ymd)
	dw_insert.setitem(lRow, "gubun", '5')    //--- 5.임의 구분값으로 설정.
	dw_insert.setitem(lRow, "reqty", 0)    
	dw_insert.setitem(lRow, "reqty_temp", 0)    
	dw_insert.setitem(lRow, "pspec", '.')
	dw_insert.setitem(lRow, "cvcod", dw_insert.GetItemString(Lin,"cvcod"))
	dw_insert.setitem(lRow, "plnt", dw_insert.GetItemString(Lin,"plnt"))
	dw_insert.setitem(lRow, "napgi_dt", dw_insert.GetItemString(Lin,"napgi_dt"))
	dw_insert.SetRow(lRow)
	dw_insert.setcolumn("cvcod")
	dw_insert.setfocus()
	dw_insert.TriggerEvent(itemchanged!)
ELSE
	lrow = dw_insert.insertrow(Lin+1)
	dw_insert.ScrollToRow(lrow)
	dw_insert.setitem(lRow, "saupj", ls_saupj)
	dw_insert.setitem(lRow, "hold_no", ls_holdNo)
	dw_insert.setitem(lRow, "YYMMDD", ls_ymd)
	dw_insert.setitem(lRow, "gubun", '5')    //--- 5.임의 구분값으로 설정.
	dw_insert.setitem(lRow, "reqty", 0)    
	dw_insert.setitem(lRow, "reqty_temp", 0)    
	dw_insert.setitem(lRow, "pspec", '.')    
	dw_insert.SetRow(lRow)
	dw_insert.setcolumn("cvcod")
	dw_insert.setfocus()

END IF

end event

type p_search from w_inherite`p_search within w_sm04_00005
integer x = 3922
integer y = 172
integer taborder = 120
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::clicked;String sYymm
Long   nCnt
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

syymm = trim(dw_1.getitemstring(1, 'sdate'))
If IsNull(syymm) Or sYymm = '' Then
	f_message_chk(1400,'[생성일자]')
	Return
End If

//If syymm <> is_today Then
//	messagebox('확인','해당일자가 시스템 현재 일자와 상이합니다. 현재 일자일 경우만 생성 가능합니다.')
//	Return
//End If	

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If


// 주간마감여부 확인

SELECT COUNT(*) INTO :nCnt FROM SM03_WEEKPLAN_ITEM WHERE SAUPJ = :sSaupj AND YYMMDD = :syymm AND CNFIRM IS NOT NULL;

If sqlca.sqlcode <> 0 Then
	MessageBox('확인',sqlca.sqlerrText)
	nCnt = 0;
End if

If 	nCnt <= 0 Then
	MessageBox('확 인','주간 판매계획 데이타들이 [확정] 되지 않았습니다.!!')
	Return
End If

SetNull(gs_code)
SetNull(gs_codename)

gs_code = sYymm
gs_codename = ssaupj
Open(w_sm04_00005_1)

p_inq.TriggerEvent(Clicked!)




end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm04_00005
boolean visible = false
integer x = 2971
integer y = 224
integer taborder = 40
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm04_00005
integer taborder = 110
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_sm04_00005
integer taborder = 100
end type

event p_can::clicked;call super::clicked;
wf_init();

end event

type p_print from w_inherite`p_print within w_sm04_00005
boolean visible = false
integer x = 3214
integer y = 188
integer taborder = 130
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

type p_inq from w_inherite`p_inq within w_sm04_00005
integer x = 3922
end type

event p_inq::clicked;String ls_saupj , ls_factory , ls_ymd , ls_itnbr
integer ix
decimal{3}  dqty1, dqty2, dqty3, dqty4, dbal_qty, dbal1_qty, dcal

If dw_1.AcceptText() < 1 Then Return

ls_saupj 	= Trim(dw_1.Object.saupj[1])
ls_ymd 		= Trim(dw_1.Object.sdate[1])
ls_factory 	= Trim(dw_1.Object.plant[1])
ls_itnbr 	= Trim(dw_1.Object.itnbr[1])

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'
If ls_itnbr = '' Or isNull(ls_itnbr)  Then ls_itnbr = '%'

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[계획시작일]')
	Return
End If

/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If


SetPointer(HourGlass!)

If dw_insert.Retrieve(ls_saupj, ls_ymd, ls_factory, ls_itnbr+'%') <= 0 Then
	
	f_message_chk(50,'')
End If


if dw_insert.rowcount() < 1 then 
	p_del.enabled = false
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
else	
	p_del.enabled = true
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
end if

for ix = 1 to dw_insert.rowcount()
	dbal_qty		= dw_insert.GetItemDecimal(ix, "bal_qty") 
	dqty1			= dw_insert.GetItemDecimal(ix, "reqty") 
	/* 품목의 수용수량  */
	dqty2			= dw_insert.GetItemDecimal(ix, "gure_gigan") 
	dbal1_qty	= dw_insert.GetItemDecimal(ix, "bal1_qty") 
	dw_insert.SetItem(ix, "boxqty", Ceiling(dqty1/dqty2))
	ls_factory	= dw_insert.GetItemString(ix, "plnt") 
	ls_itnbr		= dw_insert.GetItemString(ix, "itnbr") 
	/* 상주처 재고, 안전재고 */
	Select jego_qty, na_qty into :dqty3, :dqty4   from stock_napum_jego
	 where vndcod = :ls_factory and itnbr = :ls_itnbr;
	if	isNull(dqty3) then dqty3 = 0
	if	isNull(dqty4) then dqty4 = 0
	
	dCal	= round((dqty3 - dbal_qty - dbal1_qty - dqty4) / dqty2 , 0)
	dCal	= dCal * dqty2
	dw_insert.SetItem(ix, "chul_qty", dCal)
	
next	

end event

type p_del from w_inherite`p_del within w_sm04_00005
boolean visible = false
integer x = 4439
integer y = 268
integer taborder = 90
end type

event p_del::clicked;call super::clicked;Long ll_rcnt  , i , ll_f
String ls_chek ,ls_iojpno , ls_null
String ls_saupj , ls_lotsno , ls_facgbn , ls_itnbr , ls_doccode , ls_holdno ,ls_gubun
String ls_pspec

If dw_insert.AcceptText() < 1 Then Return
ll_rcnt = dw_insert.Rowcount() 

If ll_rcnt < 1 Then Return

If f_msg_delete() < 1 Then Return

SetNull(ls_null)
For i = ll_rcnt To 1 Step -1
	
	ls_chek = Trim(dw_insert.Object.is_check[i])
	
	If ls_chek = 'Y' Then
		ls_holdno 	= Trim(dw_insert.Object.order_no[i])
		ls_saupj 	= Trim(dw_insert.object.saupj[i])
		ls_lotsno 	= Trim(dw_insert.object.lotsno[i])
		ls_itnbr 	= Trim(dw_insert.Object.itnbr[i])
		ls_pspec 	= Trim(dw_insert.Object.pspec[i])
		ls_facgbn 	= Trim(dw_insert.Object.facgbn[i])
		ls_iojpno 	= Trim(dw_insert.object.iojpno[i])
		
		SetNull(ls_doccode)
		SetNull(ls_gubun)
		
		Select gubun ,doccode 
		  Into :ls_gubun , :ls_doccode
		 from SM04_DAILY_ITEM where hold_no = :ls_holdno ;
		If sqlca.sqlcode <> 0 Then
			MessageBox('확인',sqlca.sqlerrText)
			Return
		End iF
		
		if	isNull(ls_doccode) or ls_doccode = ' '	then
			ls_doccode = '.'
		end if
		Update sm04_daily_item Set start_date = :ls_null ,
		                           start_time = :ls_null ,
											arriv_date = :ls_null ,
											arriv_time = :ls_null ,
											trans_carno = :ls_null ,
											iojpno = :ls_null,
											isqty =  (SELECT NVL(SUM(IOQTY),0)
														   FROM IMHIST
														  WHERE saupj 	= :ls_saupj
														    and FACGBN = :ls_facgbn
														    and lotsno = :ls_lotsno
														    and itnbr  = :ls_itnbr
															 and iojpno != :ls_iojpno )    ,
											ckasu = :ls_null
								  where saupj = :ls_saupj
								    and hold_no = :ls_holdno ;
		If sqlca.sqlcode <> 0 Then
			MessageBox('1',sqlca.sqlerrText)
			Rollback ;
			REturn
		Else
			
			//messagebox('' , ls_doccode +'     '+ls_facgbn +'     '+ ls_itnbr +'      '+ ls_lotsno )
			Update SM03_WEEKPLAN_ITEM SET CHULHA_QTY = 0, HOLD_NO = NULL
								 Where nvl(doccode, '.') = :ls_doccode
									and gate 	= :ls_facgbn
									and itnbr 	= :ls_itnbr
									and pspec 	= :ls_pspec
									and hold_no = :ls_holdno ;
			
			If sqlca.SQLNRows < 1 Then
				MessageBox('2',sqlca.sqlerrText)
				Rollback;
				Return
			
			End if
			
		End if

		dw_insert.DeleteRow(i)
	End iF
Next

dw_insert.AcceptText()
If dw_insert.Update() < 1 Then
	Messagebox('확인',sqlca.sqlerrText)
	Rollback;
	Return
Else
	Commit ;
	
End If

p_inq.TriggerEvent(Clicked!)




end event

type p_mod from w_inherite`p_mod within w_sm04_00005
integer x = 4096
integer taborder = 80
end type

event p_mod::clicked;String ls_sudat ,ls_saupj ,  ls_null , ls_temp  
Long   ll_cnt 
Long   i , ll_rcnt

If dw_1.AcceptText() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return
/*  -- 마지막 RECORD가 없더라도 행삭제된것은 저장을 하여야 함.        */
//ll_rcnt = dw_insert.RowCount()
//If ll_rcnt < 1 Then Return

SetNull(ls_null)

ls_sudat = Trim(dw_1.Object.sdate[1])
ls_saupj = Trim(dw_1.Object.saupj[1])

/* 매출마감 여부 체크  ========================================== */
SELECT COUNT(*)  INTO :ll_cnt
  FROM "JUNPYO_CLOSING"  
WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
		( "JUNPYO_CLOSING"."JPDAT" >= substr(:ls_sudat,1,6) );
		
If ll_cnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
//================================================================

//출발,도착일시 체크 ========================================================================

String ls_start , ls_start_time , ls_arrive , ls_arrive_time , ls_chasu ,ls_check


If dw_1.AcceptText() < 1 Then Return -1

ls_start 	   =  Trim(dw_1.Object.start_dt[1])
ls_start_time  =  Trim(dw_1.Object.start_time[1])
ls_arrive      =  Trim(dw_1.Object.arriv_dt[1])
ls_arrive_time =  Trim(dw_1.Object.arriv_time[1])
ls_chasu       =  Trim(dw_1.Object.ckasu[1])


// 단순 행추가일시에는 내용을 저장할 필요가 없으므로 skip.
ll_cnt = 0
for i = 1 to dw_insert.rowcount()
	SetNull(ls_temp)
	ls_temp = Trim(dw_insert.Object.is_chk[i])
	IF	ls_temp = 'Y'	then ll_cnt++
NEXT

if ll_cnt <= 0  then
	goto Jump
end if

If ls_start = '' Or isNull(ls_start) Or f_datechk(ls_start) < 1 Then
	f_message_chk(35,'[출발일자]')
	dw_1.SetFocus()
	dw_1.SetColumn("start_dt")
	Return -1
End if

If ls_start_time = '' Or isNull(ls_start_time)  Then
	f_message_chk(35,'[출발시간]')
	dw_1.SetFocus()
	dw_1.SetColumn("start_time")
	Return -1
End if

If ls_arrive = '' Or isNull(ls_arrive) Or f_datechk(ls_arrive) < 1 Then
	f_message_chk(35,'[도착일자]')
	dw_1.SetFocus()
	dw_1.SetColumn("arriv_dt")
	Return -1
End if

If ls_arrive_time = '' Or isNull(ls_arrive_time)  Then
	f_message_chk(35,'[도착시간]')
	dw_1.SetFocus()
	dw_1.SetColumn("arriv_time")
	Return -1
End if


If ls_chasu = '' Or isNull(ls_chasu)  Then
	f_message_chk(36,'[차수]')
	dw_1.SetFocus()
	dw_1.SetColumn("ckasu")
	Return -1
End if

//========================================================================


If f_msg_update() < 1 Then Return



	//=========================================================================================
for i = 1 to dw_insert.rowcount()
	SetNull(ls_temp)
	ls_temp = Trim(dw_insert.Object.is_chk[i])
 
	If (ls_temp = 'Y') Then
		
		dw_insert.Object.ckasu[i] 			= ls_chasu
		dw_insert.Object.start_date[i] 	= ls_start
		dw_insert.Object.start_time[i] 	= Left(ls_start_time,4)
		dw_insert.Object.arriv_date[i] 	= ls_arrive
		dw_insert.Object.arriv_time[i] 	= Left(ls_arrive_time,4)
		dw_insert.Object.REQTY[i] 			= dw_insert.Object.REQTY[i] &
												   + dw_insert.Object.REQTY_temp[i]
		
	End IF
	
Next


JUMP:

dw_insert.AcceptText()

IF dw_insert.Update() <> 1 THEN
	MessageBox('확인 dw_insert',sqlca.sqlerrText)
	ROLLBACK;
	Return
END IF

COMMIT;

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'

end event

type cb_exit from w_inherite`cb_exit within w_sm04_00005
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm04_00005
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm04_00005
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm04_00005
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm04_00005
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm04_00005
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm04_00005
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm04_00005
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm04_00005
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm04_00005
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm04_00005
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm04_00005
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm04_00005
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm04_00005
boolean visible = true
end type

type dw_1 from u_key_enter within w_sm04_00005
integer x = 18
integer y = 24
integer width = 3639
integer height = 208
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sm04_00005_1"
boolean border = false
end type

event itemchanged;String sDate, sNull, s_cvcod,get_nm, sSaupj
Long   nCnt

SetNull(sNull)

//Choose Case GetColumnName()
//	Case 'cvcod'
//		s_cvcod = Trim(GetText())
//		
//		if s_cvcod = "" or isnull(s_cvcod) then 
//			this.setitem(1, 'cvnas', snull)
//			return 
//		end if
//		
//		SELECT "VNDMST"."CVNAS"  
//		  INTO :get_nm  
//		  FROM "VNDMST"  
//		 WHERE "VNDMST"."CVCOD" = :s_cvcod;
//	
//		if sqlca.sqlcode = 0 then 
//			this.setitem(1, 'cvnas', get_nm)
//		else
//			this.triggerevent(RbuttonDown!)
//			return 1
//		end if	
//End Choose
end event

event itemerror;call super::itemerror;RETURN 1
end event

event rbuttondown;call super::rbuttondown;int lreturnrow, lrow
string snull
str_code lst_code
Long i , ll_i = 0


setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun	= '1'       //완제품.
		Open(w_itemas_multi_popup)
		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_ins.triggerevent("clicked")
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
//			wf_itdsc(i)
			
		Next
	Case "cvcod"
		gs_code = this.GetText()
		IF Gs_code ="" OR IsNull(gs_code) THEN 
			gs_code =""
		END IF
		
		gs_gubun = '2'
		Open(w_vndmst_popup)
		
		IF isnull(gs_Code)  or  gs_Code = ''	then  
			this.SetItem(lrow, "cvcod", snull)
			this.SetItem(lrow, "cvnas", snull)
			return
		ELSE
			lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
			IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
				f_message_chk(37,'[거래처]') 
				this.SetItem(lRow, "cvcod", sNull)
				this.SetItem(lRow, "cvnas", sNull)
				RETURN  1
			END IF
		END IF	
	
		this.SetItem(lrow, "cvcod", gs_Code)
		this.SetItem(lrow, "cvnas", gs_Codename)
End Choose;

end event

type rr_1 from roundrectangle within w_sm04_00005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 348
integer width = 4599
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_1 from u_pb_cal within w_sm04_00005
integer x = 2720
integer y = 44
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('start_dt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'start_dt', gs_code)

end event

type pb_2 from u_pb_cal within w_sm04_00005
integer x = 2720
integer y = 132
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('arriv_dt')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'arriv_dt', gs_code)

end event

type st_2 from statictext within w_sm04_00005
integer x = 59
integer y = 328
integer width = 471
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출하 접수 자료"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_3 from u_pb_cal within w_sm04_00005
integer x = 1765
integer y = 48
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', gs_code)

end event

type dw_imsi from datawindow within w_sm04_00005
boolean visible = false
integer x = 146
integer y = 1500
integer width = 3506
integer height = 684
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm04_00005_IMSI"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx2_all from checkbox within w_sm04_00005
integer x = 3721
integer y = 340
integer width = 210
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 28144969
string text = "ALL"
end type

event clicked;Long ll_rcnt , i, ld_reqty_temp, ld_qty
String	ls_date



ll_rcnt = dw_insert.Rowcount() 
if ll_rcnt < 1 Then  Return


If cbx2_all.Checked Then
	For i = 1 To ll_rcnt
		ls_date 	= dw_insert.GetItemstring(i, "start_date")
		if not isNull(ls_date)  and ls_date <> '' then continue
		ld_reqty_temp = Double(dw_insert.GetItemDecimal(i, "reqty_temp") )
		dw_insert.Object.is_chk[i] = 'Y'
		dw_insert.object.reqty_temp[i] = dw_insert.object.minap_qty[i]
		ld_qty	= dw_insert.GetItemDecimal(i, "gure_gigan") 
		dw_insert.SetItem(i, "boxqty", Ceiling(ld_reqty_temp/ld_qty))
	Next
Else
	For i = 1 To ll_rcnt
		ls_date 	= dw_insert.GetItemstring(i, "start_date")
		if not isNull(ls_date)  and ls_date <> '' then continue

		dw_insert.Object.is_chk[i] = 'N'
		dw_insert.object.reqty_temp[i] 	= 0
		dw_insert.object.boxqty[i] 		= 0
	Next
End If

		
	
end event

