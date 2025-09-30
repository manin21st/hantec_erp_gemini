$PBExportHeader$w_sm40_0010p.srw
$PBExportComments$현대/기아 CKD 미납현황
forward
global type w_sm40_0010p from w_standard_print
end type
type st_1 from statictext within w_sm40_0010p
end type
type cb_2 from commandbutton within w_sm40_0010p
end type
type rr_1 from roundrectangle within w_sm40_0010p
end type
type sle_1 from singlelineedit within w_sm40_0010p
end type
type cb_1 from commandbutton within w_sm40_0010p
end type
type rb_1 from radiobutton within w_sm40_0010p
end type
type rb_2 from radiobutton within w_sm40_0010p
end type
type dw_1 from datawindow within w_sm40_0010p
end type
type gb_1 from groupbox within w_sm40_0010p
end type
end forward

global type w_sm40_0010p from w_standard_print
string title = "CKD 미납현황"
st_1 st_1
cb_2 cb_2
rr_1 rr_1
sle_1 sle_1
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
gb_1 gb_1
end type
global w_sm40_0010p w_sm40_0010p

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_hkmc ()
public subroutine wf_mobis ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ed

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간 확인', '시작일 보다 종료일이 빠릅니다.')
	dw_ip.setColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

String ls_fac

ls_fac = dw_ip.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) OR Trim(ls_fac) = '.' Then ls_fac = '%'

String ls_stit

ls_stit = dw_ip.GetItemString(row, 'stit')
If Trim(ls_stit) = '' OR IsNull(ls_stit) Then ls_stit = '.'

String ls_edit

ls_edit = dw_ip.GetItemString(row, 'edit')
If Trim(ls_edit) = '' OR IsNull(ls_edit) Then ls_edit = 'ZZZZZZZZZZZZZZZZZZZZ'

//String ls_gbn
//String ls_fil
//ls_gbn = dw_ip.GetItemString(row, 'gubun')
//
String ls_ckdgbn
ls_ckdgbn = dw_ip.GetItemString(row, 'ckdgbn')
//If ls_ckdgbn = 'H' Then
//	/* C1, C4, L2, L3공장은 분납발주가 접수되기 때문에 출고되면 완납처리 - by shingoon 2009.06.10 */
//	/* C1, C4, L2, L3공장은 [발주번호+발주수량]으로 미납관리 하지 않음. [발주번호]가 출고되면 완납으로 관리 */
//	/* ls_fil = "if(isnull(d_chuldate), '', d_chuldate) = '' or van_hkcd68_order_qty <> if(van_hkcd68_factory in ('C1', 'C4', 'L2', 'L3'), van_hkcd68_order_qty, d_chulqty)"*/
//   /* 발주수량보다 출고수량이 많은 경우도 완납처리(Y공장은 발주번호가 같고 form_orderno가 다른 자료가 접수 됨 : 김대성DR) - by shingoon 2009.07.27 */
//	ls_fil = "if(isnull(d_chuldate), '', d_chuldate) = '' or van_hkcd68_order_qty > if(van_hkcd68_factory in ('C1', 'C4', 'L2', 'L3'), van_hkcd68_order_qty, d_chulqty)"
//Else
//	ls_fil = "if(isnull(d_chuldate), '', d_chuldate) = '' or van_mobis_ckd_b_balqty <> d_chulqty"
//End If

dw_list.SetRedraw(False)

If ls_ckdgbn = 'H' OR ls_ckdgbn = 'G' OR ls_ckdgbn = 'P' Then
	dw_list.Retrieve(ls_st, ls_ed, ls_fac, ls_stit, ls_edit)
Else
	dw_list.Retrieve(ls_st, ls_ed, ls_stit, ls_edit)
End If

//If ls_gbn <> 'A' Then
//	dw_list.SetFilter(ls_fil)
//	dw_list.Filter()
//Else
//	dw_list.SetFilter('')
//	dw_list.Filter()
//End If


dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

//dw_list.ShareData(dw_print)

Return 1

end function

public subroutine wf_hkmc ();Long   ll_cnt

ll_cnt = dw_list.RowCount()
If ll_cnt < 1 Then Return

Long   i
String ls_chk
String ls_doc
String ls_cust
String ls_fac
String ls_itnbr
String ls_order

For i = 1 To ll_cnt
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ls_doc   = dw_list.GetItemString(i, 'van_hkcd68_doccode')
		ls_cust  = dw_list.GetItemString(i, 'van_hkcd68_custcd' )
		ls_fac   = dw_list.GetItemString(i, 'van_hkcd68_factory')
		ls_itnbr = dw_list.GetItemString(i, 'van_hkcd68_itnbr'  )
		ls_order = dw_list.GetItemString(i, 'van_hkcd68_orderno')
		
		INSERT INTO VAN_HKCD68_CLS
			  ( SABU      , DOCCODE   , CUSTCD    , FACTORY    , ITNBR    , ORDERNO          , ORDER_GB    , ORDER_QTY      ,
		       IPDAN     , ORDER_DATE, ORDER_TYPE, ORDER_TIME , ORDER_MIN, PACKUNI          , FORM_ORDERNO, COUNTRY_CARKIND,
				 TO_ORDERNO, LOCNO_CKD , YARDNO_CKD, PACKCON_CKD, SEQNO    , CRT_DATE         , CRT_TIME    , CRT_USER       ,
				 CITNBR    , MITNBR    , MCVCOD    , MDCVCOD    , BALYN    , ORDER_DATE_HANTEC, BALJPNO     , BALSEQ )
		SELECT SABU      , DOCCODE   , CUSTCD    , FACTORY    , ITNBR    , ORDERNO          , ORDER_GB    , ORDER_QTY      ,
		       IPDAN     , ORDER_DATE, ORDER_TYPE, ORDER_TIME , ORDER_MIN, PACKUNI          , FORM_ORDERNO, COUNTRY_CARKIND,
				 TO_ORDERNO, LOCNO_CKD , YARDNO_CKD, PACKCON_CKD, SEQNO    , CRT_DATE         , CRT_TIME    , CRT_USER       ,
				 CITNBR    , MITNBR    , MCVCOD    , MDCVCOD    , BALYN    , ORDER_DATE_HANTEC, BALJPNO     , BALSEQ
		  FROM VAN_HKCD68
		 WHERE SABU    = :gs_sabu
		   AND DOCCODE = :ls_doc
			AND CUSTCD  = :ls_cust
			AND FACTORY = :ls_fac
			AND ITNBR   = :ls_itnbr
			AND ORDERNO = :ls_order ;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
			ROLLBACK USING SQLCA;
			Return
		End If
	End If
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('처리확인', '완료처리 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('처리확인', '처리 실패입니다!')
	Return
End If
end subroutine

public subroutine wf_mobis ();Long   ll_cnt

ll_cnt = dw_list.RowCount()
If ll_cnt < 1 Then Return

Long   i
String ls_chk
String ls_balno
String ls_balseq

For i = 1 To ll_cnt
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ls_balno  = dw_list.GetItemString(i, 'van_mobis_ckd_b_balno' )
		ls_balseq = dw_list.GetItemString(i, 'van_mobis_ckd_b_balseq')
		
		INSERT INTO VAN_MOBIS_CKD_B_CLS
			  ( BALNO  , BALSEQ , BALDATE , ORDERNO , ORDERSQ , ORDDATE , ITNBR   , ITDSC  , BALQTY , 
			    NAPAREA, YODATE , NAPYN   , GADATE  , MULTI_DS, NDATE   , CUSTOMER, CARNAME, BALMEMO, 
				 STATUS , FACTORY, CRT_DATE, CRT_TIME, CRT_USER, MITNBR  , MCVCOD  , BALYN  , BALJPNO, BALSEQ2 )
		SELECT BALNO  , BALSEQ , BALDATE , ORDERNO , ORDERSQ , ORDDATE , ITNBR   , ITDSC  , BALQTY , 
			    NAPAREA, YODATE , NAPYN   , GADATE  , MULTI_DS, NDATE   , CUSTOMER, CARNAME, BALMEMO, 
				 STATUS , FACTORY, CRT_DATE, CRT_TIME, CRT_USER, MITNBR  , MCVCOD  , BALYN  , BALJPNO, BALSEQ2
		  FROM VAN_MOBIS_CKD_B
		 WHERE BALNO  = :ls_balno
		   AND BALSEQ = :ls_balseq ;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
			ROLLBACK USING SQLCA;
			Return
		End If
	End If
Next

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('처리확인', '완료처리 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('처리확인', '처리 실패입니다!')
	Return
End If
end subroutine

on w_sm40_0010p.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_2=create cb_2
this.rr_1=create rr_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_sm40_0010p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.rr_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

end event

event key;//
// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	/* 단축키 */
//	Case KeyQ!
//		p_retrieve.TriggerEvent(Clicked!)
//	Case KeyV!
//		IF p_preview.Enabled THEN 
//			p_preview.TriggerEvent(Clicked!)
//		END IF
//	Case KeyW!
//		IF p_preview.Enabled THEN 
//			p_print.TriggerEvent(Clicked!)
//		END IF		
//	Case KeyX!
//		p_exit.TriggerEvent(Clicked!)
end choose
end event

type p_xls from w_standard_print`p_xls within w_sm40_0010p
boolean visible = true
integer x = 4247
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm40_0010p
boolean visible = true
integer x = 3653
integer y = 24
boolean enabled = false
boolean originalsize = false
string picturename = "C:\erpman\image\정렬_d.gif"
end type

type p_preview from w_standard_print`p_preview within w_sm40_0010p
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_sm40_0010p
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_sm40_0010p
boolean visible = false
integer x = 4064
integer y = 180
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm40_0010p
integer x = 3899
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	
	p_sort.Enabled = False
	p_sort.PictureName = 'C:\erpman\image\정렬_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
	p_sort.Enabled = True
	p_sort.PictureName = 'C:\erpman\image\정렬_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_sm40_0010p
end type



type dw_print from w_standard_print`dw_print within w_sm40_0010p
integer x = 3758
string dataobject = "d_sm40_0010p_003"
end type

type dw_ip from w_standard_print`dw_ip within w_sm40_0010p
integer x = 32
integer width = 3026
integer height = 232
string dataobject = "d_sm40_0010p_001"
end type

event dw_ip::itemchanged;call super::itemchanged;
If row < 1 Then Return

String	sckd

Choose Case dwo.name
	Case 'stit'
		If Trim(This.GetItemString(row, 'edit')) = '' OR IsNull(This.GetItemString(row, 'edit')) Then
			This.SetItem(row, 'edit', data)
		End If
		
	Case 'd_st'
		If Trim(This.GetItemString(row, 'd_ed')) = '' OR IsNull(This.GetItemString(row, 'd_ed')) Then
			This.SetItem(row, 'd_ed', data)
		End If
		
	Case 'ckdgbn'
		sckd = data
		if sckd = 'H' then //현대기아
			dw_list.dataobject = 'd_sm40_0010p_002_hkmc'
//			dw_print.dataobject = 'd_sm40_0010p_003'
		elseif sckd = 'M' then //모비스
			dw_list.dataobject = 'd_sm40_0010p_002_mobis'
//			dw_print.dataobject = 'd_sm40_0010p_003m'
		elseif sckd = 'G' then //글로비스
			dw_list.dataobject = 'd_sm40_0010p_002_globis'
		elseif sckd = 'W' then //위아
			dw_list.dataobject = 'd_sm40_0010p_002_wia'
		elseif sckd = 'P' then //파워텍
			dw_list.dataobject = 'd_sm40_0010p_002_ptc'
		end if
		dw_list.settransobject(sqlca)
//		dw_print.settransobject(sqlca)

End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm40_0010p
integer x = 46
integer y = 332
integer width = 4539
integer height = 1904
string dataobject = "d_sm40_0010p_002_hkmc"
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;If row < 1 Then Return

String  ls_ckdgbn
ls_ckdgbn = dw_ip.GetItemString(1, 'ckdgbn')

String  ls_itnbr
String  ls_bal
Choose Case ls_ckdgbn
	Case 'M'
		ls_itnbr = This.GetItemString(row, 'itnbr')
		ls_bal   = This.GetItemString(row, 'balno')
	Case 'W'
		ls_itnbr = This.GetItemString(row, 'itnbr')
		ls_bal   = This.GetItemString(row, 'balno')
	Case 'H'
		/* 공장구분이 현대와 기아로 나눠서 발주번호를 적용 - by shingoon 2013.11.27 */
		String  ls_plnt
		ls_plnt = This.GetItemString(row, 'plant')
		/* 참조코드(2A)의 공장별납품처 자료 중 RFNA3의 값이 H:현대, K:기아, M:모비스 */
		String  ls_typ
		String  ls_ckd
		SELECT RFNA3, RFCOMMENT INTO :ls_typ, :ls_ckd FROM REFFPF WHERE RFCOD = '2A' AND RFGUB = :ls_plnt ;
		If ls_typ = 'K' AND ls_ckd = 'CKD' Then
			ls_itnbr = This.GetItemString(row, 'mitnbr' )
			ls_bal   = This.GetItemString(row, 'saledot')
		Else
			ls_itnbr = This.GetItemString(row, 'mitnbr')
			ls_bal   = This.GetItemString(row, 'pdno'  )
		End If
	Case 'G'
		ls_itnbr = This.GetItemString(row, 'mitnbr' )
		ls_bal   = This.GetItemString(row, 'orderno')
	Case 'P'
		ls_itnbr = This.GetItemString(row, 'itnbr' )
		ls_bal   = This.GetItemString(row, 'order_no')
End Choose

Integer li_ret
dw_1.SetRedraw(False)
li_ret = dw_1.Retrieve(gs_sabu, gs_saupj, ls_itnbr, ls_bal)
dw_1.SetRedraw(True)

If li_ret < 1 Then
	MessageBox('출고내역', '해당 자료로 출고된 내역이 없습니다.')
	Return
End If

dw_1.Visible = True
end event

type st_1 from statictext within w_sm40_0010p
boolean visible = false
integer x = 64
integer y = 260
integer width = 3502
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "※ C1, C4, L2, L3공장은 분납발주가  접수되기 때문에 발주번호에 대한 출고여부로 미납관리 함. [더블클릭 시 상세 조회]"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sm40_0010p
boolean visible = false
integer x = 3653
integer y = 192
integer width = 352
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "완료처리"
end type

event clicked;If MessageBox('처리확인', '선택된 자료의 발주를 완료처리 합니다.~r~n~r~n계속 하시겠습니까?', Question!, YesNo!, 2) = 2 Then Return

String ls_gbn

ls_gbn = dw_ip.GetItemString(1, 'ckdgbn')
If ls_gbn = 'H' Then
	wf_hkmc()
Else
	wf_mobis()
End If
end event

type rr_1 from roundrectangle within w_sm40_0010p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 320
integer width = 4567
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

type sle_1 from singlelineedit within w_sm40_0010p
boolean visible = false
integer x = 2770
integer y = 68
integer width = 544
integer height = 76
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type cb_1 from commandbutton within w_sm40_0010p
boolean visible = false
integer x = 2770
integer y = 144
integer width = 544
integer height = 80
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "발주번호 검색"
end type

event clicked;String ls_order
ls_order = sle_1.Text
If Trim(ls_order) = '' OR IsNull(ls_order) Then Return

String ls_dat
String ls_jpno
String ls_qty
Long   ll_qty

If rb_1.Checked = True Then
	SELECT MAX(SUDAT), MAX(IOJPNO), SUM(IOQTY)
	  INTO :ls_dat   , :ls_jpno   , :ll_qty
	  FROM IMHIST
	 WHERE SABU = '1'
		AND LOTSNO LIKE SUBSTR(:ls_order, 1, LENGTH(:ls_order) - 1)||'%' ;
	If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then 
		MessageBox('검색완료', '발주번호 ' + ls_order + '는(은) 출고되지 않았습니다.')
		Return
	End If
ElseIf rb_2.Checked = True Then
	SELECT MAX(SUDAT), MAX(IOJPNO), SUM(IOQTY)
	  INTO :ls_dat   , :ls_jpno   , :ll_qty
	  FROM IMHIST
	 WHERE SABU = '1'
		AND LOTSNO = SUBSTR(:ls_order, 1, 10)
		AND LOTENO = '0'||SUBSTR(:ls_order, 11, 5) ;
	If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then 
		MessageBox('검색완료', '발주번호 ' + ls_order + '는(은) 출고되지 않았습니다.')
		Return
	End If
End If

ls_dat  = LEFT(ls_dat, 4) + '.' + MID(ls_dat, 5, 2) + '.' + RIGHT(ls_dat, 2)
ls_jpno = LEFT(ls_jpno, 8) + '-' + MID(ls_jpno, 9, 4) + '-' + RIGHT(ls_jpno, 3)
ls_qty  = String(ll_qty, '#,###')


Long   ll_cnt
If rb_1.Checked = True Then
	SELECT COUNT('X')
	  INTO :ll_cnt
	  FROM VAN_HKCD68
	 WHERE ORDERNO = :ls_order ;
ElseIf rb_2.Checked = True Then
	SELECT COUNT('X')
	  INTO :ll_cnt
	  FROM VAN_MOBIS_CKD_B
	 WHERE BALNO  = SUBSTR(:ls_order, 1, 10)
	   AND BALSEQ = SUBSTR(:ls_order, 11, 5);
End If

String ls_ckd
If ll_cnt > 0 Then
	ls_ckd = '접수'
Else
	ls_ckd = '-'
End If

MessageBox('검색완료', 'VAN 접수 여부 : ' + ls_ckd + '~r~n'+ &
                       '출고처리일자 : ' + ls_dat + '~r~n' + '출고전표번호 : ' + ls_jpno + '~r~n' + '출고수량       : ' + ls_qty + 'EA')


end event

type rb_1 from radiobutton within w_sm40_0010p
boolean visible = false
integer x = 3328
integer y = 72
integer width = 251
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "HKMC"
boolean checked = true
end type

type rb_2 from radiobutton within w_sm40_0010p
boolean visible = false
integer x = 3328
integer y = 144
integer width = 261
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "MOBIS"
end type

type dw_1 from datawindow within w_sm40_0010p
boolean visible = false
integer x = 219
integer y = 708
integer width = 4201
integer height = 1408
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "출고내역 현황"
string dataobject = "d_sm40_0010p_002_imhist"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type gb_1 from groupbox within w_sm40_0010p
boolean visible = false
integer x = 2738
integer width = 882
integer height = 252
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 32106727
string text = "출고여부 검색"
borderstyle borderstyle = stylebox!
end type

