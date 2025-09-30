$PBExportHeader$w_sal_02270.srw
$PBExportComments$수주 일괄 취소 등록
forward
global type w_sal_02270 from w_inherite
end type
type dw_ip from u_key_enter within w_sal_02270
end type
type gb_6 from groupbox within w_sal_02270
end type
type cbx_select from checkbox within w_sal_02270
end type
type st_2 from statictext within w_sal_02270
end type
type st_3 from statictext within w_sal_02270
end type
type st_4 from statictext within w_sal_02270
end type
type pb_1 from u_pb_cal within w_sal_02270
end type
type pb_2 from u_pb_cal within w_sal_02270
end type
type rr_1 from roundrectangle within w_sal_02270
end type
end forward

global type w_sal_02270 from w_inherite
integer height = 2420
string title = "수주 일괄 취소 등록"
dw_ip dw_ip
gb_6 gb_6
cbx_select cbx_select
st_2 st_2
st_3 st_3
st_4 st_4
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02270 w_sal_02270

on w_sal_02270.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.gb_6=create gb_6
this.cbx_select=create cbx_select
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.gb_6
this.Control[iCurrent+3]=this.cbx_select
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.rr_1
end on

on w_sal_02270.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.gb_6)
destroy(this.cbx_select)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;String sDatef, sdatet

dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
                                                                                                                                                                                                                                                                                                                                             
dw_ip.InsertRow(0)

dw_ip.SetItem(1,'sdatef','10000101')
dw_ip.SetItem(1,'sdatet',f_today())

///* User별 관할구역 Setting */
//String sarea, steam, saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//End If

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_02270
integer x = 37
integer y = 472
integer width = 4581
integer height = 1732
integer taborder = 10
string dataobject = "d_sal_022701"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

type p_delrow from w_inherite`p_delrow within w_sal_02270
boolean visible = false
integer x = 4261
integer y = 188
end type

type p_addrow from w_inherite`p_addrow within w_sal_02270
boolean visible = false
integer x = 4087
integer y = 188
end type

type p_search from w_inherite`p_search within w_sal_02270
boolean visible = false
integer x = 3566
integer y = 188
end type

type p_ins from w_inherite`p_ins within w_sal_02270
boolean visible = false
integer x = 3913
integer y = 188
end type

type p_exit from w_inherite`p_exit within w_sal_02270
end type

type p_can from w_inherite`p_can within w_sal_02270
end type

event p_can::clicked;call super::clicked;
dw_insert.Reset()

dw_ip.SetFocus()
end event

type p_print from w_inherite`p_print within w_sal_02270
boolean visible = false
integer x = 3739
integer y = 188
end type

type p_inq from w_inherite`p_inq within w_sal_02270
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String sFrom, sTo, sCust,sarea ,ls_pdtgu , ls_sitcls , ls_stitnm , ls_titcls, ls_ttitnm , ls_ittyp 
string ls_order_no , ls_itnbr 
Long ix

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
ls_pdtgu    = dw_ip.getitemstring(1,'pdtgu')
ls_sitcls   = Trim(dw_ip.getitemstring(1,'sitcls'))
ls_titcls   = Trim(dw_ip.getitemstring(1,'titcls'))
ls_ittyp    = dw_ip.getitemstring(1,'ittyp')
ls_itnbr    = Trim(dw_ip.getitemstring(1,'itnbr'))
ls_order_no = Trim(dw_ip.getitemstring(1,'order_no'))

//sCust       = dw_ip.GetItemString(1,"custcode")
//sArea       = dw_ip.GetItemString(1,"areacode")

IF sFrom = "" OR IsNull(sFrom) Or sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[승인기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

//IF sCust = "" OR IsNull(sCust) THEN sCust = ''
//IF sarea = "" OR IsNull(sarea) THEN sarea = ''
if ls_pdtgu = "" or isnull(ls_pdtgu) then ls_pdtgu = '%'
if ls_sitcls = "" or isnull(ls_sitcls) then ls_sitcls = '.'
if ls_titcls = "" or isnull(ls_titcls) then ls_titcls = 'zzzzzzzzzzzzzzzz'
if ls_ittyp = "" or isnull(ls_ittyp) then ls_ittyp = '%'
if ls_itnbr = "" or isnull(ls_itnbr) then ls_itnbr = '%'
if ls_order_no = "" or isnull(ls_order_no) then ls_order_no = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve(gs_sabu, sFrom, sTo, ls_pdtgu,ls_sitcls,ls_titcls,ls_order_no,ls_itnbr ,ls_ittyp)

IF dw_insert.RowCount() <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	dw_insert.SetRedraw(True)
	Return -1
END IF

dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sal_02270
boolean visible = false
integer x = 4434
integer y = 188
end type

type p_mod from w_inherite`p_mod within w_sal_02270
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long ix, nCnt=0
Dec  dCanQty, dOrdQty, dOrdPrc, dItmPrc
String sCause
Dec {4} dUrate, dWeight

If dw_ip.AcceptText() <> 1 Then Return 
If dw_insert.AcceptText() <> 1 Then Return 

IF MessageBox("확 인","잔량에 대해서 취소를 하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)

dw_insert.SetFocus()
For ix = 1 To dw_insert.RowCount()
	If dw_insert.GetItemString(ix, 'chk') <> 'Y' Then Continue
	
	sCause = Trim(dw_insert.GetItemString(ix, 'ord_cancel_cause'))
	If IsNull(sCause) Or sCause = '' Then
		f_message_chk(1400,'[취소사유]')
		dw_insert.ScrollToRow(ix)
		dw_insert.SetColumn('ord_cancel_cause')
		Return
	End If
	
	dCanQty = dw_insert.GetItemNumber(ix, 'canqty')
	If IsNull(dCanQty) Or dCanQty = 0 Then Continue
	
	dOrdPrc = dw_insert.GetItemNumber(ix, 'order_prc')
	If IsNull(dOrdPrc) Then dOrdPrc = 0
	
	dOrdQty = dw_insert.GetItemNumber(ix, 'order_qty')
	If IsNull(dOrdQty) Then dOrdQty = 0
	
	dw_insert.SetItem(ix, 'order_qty', dOrdQty - dCanQty)
	dw_insert.SetItem(ix, 'order_amt', Truncate(dOrdPrc * (dOrdQty - dCanQty),0))
	
	// 외화금액
	dItmPrc = dw_insert.GetItemNumber(ix, 'sorder_itmprc')
	If IsNull(dItmPrc) Then dItmPrc = 0
	dw_insert.SetItem(ix, 'sorder_itmamt', Truncate(dItmPrc * (dOrdQty - dCanQty),2))
	
	// 미화금액
	dUrate  = dw_insert.GetItemNumber(ix,"sorder_head_urate")
	dWeight = dw_insert.GetItemNumber(ix,"sorder_head_weight")
	If IsNull(dUrate) Or dUrate = 0 Then dUrate = 1
	If IsNull(dWeight) Or dWeight = 0 Then dWeight = 1
	dw_insert.SetItem(ix,"sorder_uamt",	 Truncate((dw_insert.GetITEMnUMBER(ix, 'sorder_itmamt') * dUrate )/dWeight,2))

	nCnt += 1
Next

If nCnt > 0 Then
	IF dw_insert.Update() <> 1 THEN
	  f_message_chk(41,string(sqlca.sqlcode)+sqlca.sqlerrtext)
	  rollback;
	  Return
	END IF
	
	Commit;
	
	p_inq.TriggerEvent(Clicked!)
	
	w_mdi_frame.sle_msg.text = '자료를 처리하였습니다!!'
Else
	w_mdi_frame.sle_msg.text = '처리된 건수가 없습니다.!!'
End If

end event

type cb_exit from w_inherite`cb_exit within w_sal_02270
integer x = 3214
integer y = 5000
integer taborder = 130
end type

type cb_mod from w_inherite`cb_mod within w_sal_02270
integer x = 3374
integer y = 212
integer taborder = 70
string text = "처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_sal_02270
integer x = 489
integer y = 5000
integer taborder = 60
end type

type cb_del from w_inherite`cb_del within w_sal_02270
integer x = 1211
integer y = 5000
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_sal_02270
integer x = 3365
integer y = 56
integer taborder = 90
end type

type cb_print from w_inherite`cb_print within w_sal_02270
integer x = 1934
integer y = 5000
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_sal_02270
end type

type cb_can from w_inherite`cb_can within w_sal_02270
integer x = 3365
integer y = 336
integer taborder = 110
end type

type cb_search from w_inherite`cb_search within w_sal_02270
integer x = 2656
integer y = 5000
integer taborder = 120
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02270
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02270
end type

type dw_ip from u_key_enter within w_sal_02270
integer width = 3419
integer height = 456
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sal_02270"
boolean border = false
end type

event itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1 ,sItemClsName , sItemCls , ls_ispec_code , sItemGbn
String  sDateFrom, sDateTo, snull, sPrtGbn, sSummary , ls_itnbr , ls_itdsc , ls_ispec , ls_jijil , sorderNO
long   iDbCount

SetNull(snull)

Choose Case GetColumnName() 
  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[승인기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[승인기간]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 수주번호 */
Case 'order_no'
	sOrderNo = GetText()
		IF sOrderNo = "" OR IsNull(sOrderNo) THEN RETURN
		
		SELECT COUNT("ORDER_NO")  
		  INTO :iDbCount  
		  FROM "SORDER"  
		 WHERE ( "SABU"     = :gs_sabu ) AND  
				 ( "ORDER_NO" = :sOrderNo ) ;
		
		IF SQLCA.SQLCODE <> 0 OR iDbCount <=0 THEN
			f_message_chk(33,'[수주번호]')
			SetItem(1,'order_no',sNull)
			Return 1
		END IF
/* 품목구분 */
Case "ittyp"
	SetItem(1,'sitcls',sNull)
	SetItem(1,'stitnm',sNull)
	SetItem(1,'titcls',sNull)
	SetItem(1,'ttitnm',sNull)
/* 품목분류 */
Case "sitcls"
	SetItem(1,'stitnm',sNull)
	
	sItemCls = Trim(GetText())
	IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
	
	sItemGbn = this.GetItemString(1,"ittyp")
	IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		
		SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			this.SetItem(1,"stitnm",sItemClsName)
		END IF
	END IF
/* 품목명 */
Case "stitnm"
	SetItem(1,"sitcls",snull)
	
	sItemClsName = this.GetText()
	IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
	
	sItemGbn = this.GetItemString(1,"ittyp")
	IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
	  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
		 FROM "ITNCT"  
		WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
			
	  IF SQLCA.SQLCODE <> 0 THEN
		 this.TriggerEvent(RButtonDown!)
		 Return 2
	  ELSE
		 this.SetItem(1,"sitcls",sItemCls)
	  END IF
	END IF
/* 품목분류 */
Case "titcls"
	SetItem(1,'ttitnm',sNull)
	
	sItemCls = Trim(GetText())
	IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
	
	sItemGbn = this.GetItemString(1,"ittyp")
	IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		
		SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
		  FROM "ITNCT"  
		 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
			
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			this.SetItem(1,"ttitnm",sItemClsName)
		END IF
	END IF
/* 품목명 */
Case "ttitnm"
	SetItem(1,"titcls",snull)
	
	sItemClsName = this.GetText()
	IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
	
	sItemGbn = this.GetItemString(1,"ittyp")
	IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
	  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
		 FROM "ITNCT"  
		WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
			
	  IF SQLCA.SQLCODE <> 0 THEN
		 this.TriggerEvent(RButtonDown!)
		 Return 2
	  ELSE
		 this.SetItem(1,"titcls",sItemCls)
	  END IF
	END IF
/* 품번 */
Case	"itnbr" 
	 ls_Itnbr = Trim(this.GetText())
	 IF ls_Itnbr ="" OR IsNull(ls_Itnbr) THEN
		SetItem(1,'itdsc',sNull)
		SetItem(1,'ispec',sNull)
		SetItem(1,'jijil',sNull)
		SetItem(1,'itnbr',sNull)
		Return
	 END IF
	
	 SELECT  "ITDSC",   "ISPEC" , "JIJIL" 
		INTO :ls_itdsc, :ls_ispec , :ls_jijil
		FROM "ITEMAS"
	  WHERE "ITNBR" = :ls_Itnbr ;
	 
	 IF SQLCA.SQLCODE <> 0 THEN
		this.PostEvent(RbuttonDown!)
		Return 2
	 END IF
	
	 SetItem(1,"ispec", ls_ispec)
	 SetItem(1,"itdsc", ls_itdsc)
	 SetItem(1,"jijil", ls_jijil)
/* 품명 */
Case "itdsc"
	 ls_itdsc = trim(this.GetText())	
	 IF ls_itdsc ="" OR IsNull(ls_itdsc) THEN
		 SetItem(1,'itnbr',sNull)
		 SetItem(1,'jijil',sNull)
		 SetItem(1,'ispec',sNull)
		Return
	 END IF
	 
	/* 품명으로 품번찾기 */
	f_get_name4('품명', 'Y', ls_itnbr, ls_itdsc, ls_ispec, ls_jijil, ls_ispec_code)
	 If IsNull(ls_itnbr ) Then
		 this.setitem(1,'itdsc',snull) 
		 Return 1
	 ElseIf ls_itnbr <> '' Then
		 SetItem(1,"itnbr",ls_itnbr)
		 SetColumn("itnbr")
		 SetFocus()
		 TriggerEvent(ItemChanged!)
		 Return 1
	 ELSE
		 SetItem(1,'itnbr',sNull)
		 SetItem(1,'itdsc',sNull)
		 SetItem(1,'ispec',sNull)
		 SetItem(1,'jijil',sNull)
		 SetColumn("itdsc")
		 Return 1
	End If	
/* 규격 */
Case "ispec"
	ls_ispec = trim(this.GetText())	
	IF ls_ispec = ""	or	IsNull(ls_ispec)	THEN
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'jijil',sNull)
		Return
	END IF
	
	/* 규격으로 품번찾기 */
	f_get_name4('규격', 'Y', ls_itnbr, ls_itdsc, ls_ispec, ls_jijil, ls_ispec_code)
	If IsNull(ls_itnbr) Then
		this.setitem(1,'ispec',snull)
		Return 1
	ElseIf ls_itnbr <> '' Then
		SetItem(1,"itnbr",ls_itnbr)
		SetColumn("itnbr")
		SetFocus()
		TriggerEvent(ItemChanged!)
		Return 1
	ELSE
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'jijil',sNull)
		SetItem(1,'ispec',sNull)
		SetColumn("ispec")
		Return 1
	End If	
/* 재질 */
Case "jijil"
	ls_jijil = trim(this.GetText())	
	IF ls_jijil = ""	or	IsNull(ls_jijil)	THEN
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'ispec',sNull)
		Return
	END IF
	
	/* 규격으로 품번찾기 */
	f_get_name4('재질', 'Y', ls_itnbr, ls_itdsc, ls_ispec, ls_jijil, ls_ispec_code)
	If IsNull(ls_itnbr) Then
		this.setitem(1,'jijil',snull)
		Return 1
	ElseIf ls_itnbr <> '' Then
		SetItem(1,"itnbr",ls_itnbr)
		SetColumn("itnbr")
		SetFocus()
		TriggerEvent(ItemChanged!)
		Return 1
	ELSE
		SetItem(1,'itnbr',sNull)
		SetItem(1,'itdsc',sNull)
		SetItem(1,'jijil',sNull)
		SetItem(1,'ispec',sNull)
		SetColumn("ispec")
		Return 1
	End If	
///* 영업팀 */
// Case "deptcode"
//	SetItem(1,'areacode',sNull)
//	SetItem(1,"custcode",sNull)
//	SetItem(1,"custname",sNull)
///* 관할구역 */
// Case "areacode"
//	SetItem(1,"custcode",sNull)
//	SetItem(1,"custname",sNull)
//
//	sarea = this.GetText()
//	IF sarea = "" OR IsNull(sarea) THEN RETURN
//	
//	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
//	  FROM "SAREA"  
//	 WHERE "SAREA"."SAREA" = :sarea   ;
//		
//   SetItem(1,'deptcode',steam)
//	/* 거래처 */
//	Case "custcode"
//		sCvcod = Trim(GetText())
//		IF sCvcod ="" OR IsNull(sCvcod) THEN
//			SetItem(1,"custname",snull)
//			Return
//		END IF
//
//		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
//			SetItem(1, 'custcode', sNull)
//			SetItem(1, 'custname', snull)
//			Return 1
//		ELSE		
//			SetItem(1,"deptcode",   steam)
//			SetItem(1,"areacode",   sarea)
//			SetItem(1,"custname", 	scvnas)
//		END IF
//	/* 거래처명 */
//	Case "custname"
//		scvnas = Trim(GetText())
//		IF scvnas ="" OR IsNull(scvnas) THEN
//			SetItem(1,"custcode",snull)
//			Return
//		END IF
//		
//		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
//			SetItem(1, 'custcode', sNull)
//			SetItem(1, 'custname', snull)
//			Return 1
//		ELSE
//			SetItem(1,"deptcode",   steam)
//			SetItem(1,"areacode",   sarea)
//			
//			SetItem(1,'custcode',   sCvcod)
//			SetItem(1,"custname", 	scvnas)
//			Return 1
//		END IF
END Choose

end event

event itemerror;call super::itemerror;Return 1
end event

event rbuttondown;str_itnct str_sitnct

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "order_no"
	  OpenWithParm(w_sorder_popup,'1')
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	  this.SetItem(1,"order_no",gs_code)
	  
	Case "sitcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"sitcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"stitnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "stitnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"sitcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"stitnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "titcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"titcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"ttitnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "ttitnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"titcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"ttitnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
/* ---------------------------------------- */
  Case "itnbr" ,"itdsc", "ispec" , "jijil"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)	
//	Case "custcode", "custname"
//		gs_gubun = '1'
//		If GetColumnName() = "custname" then
//			gs_codename = Trim(GetText())
//		End If
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		SetItem(1,"custcode",gs_code)
//		SetColumn("custcode")
//		TriggerEvent(ItemChanged!)
END Choose

end event

type gb_6 from groupbox within w_sal_02270
integer x = 2523
integer y = 24
integer width = 439
integer height = 128
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type cbx_select from checkbox within w_sal_02270
integer x = 2907
integer y = 32
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체 선택"
end type

event clicked;Long    k,nRow
Double  dRemainQty
String  sStatus

IF cbx_select.Checked = True THEN
	sStatus = 'Y'
ELSE
	sStatus = 'N'
END IF

Setpointer(HourGlass!)

For k = 1 To dw_insert.RowCount()
	dRemainQty = dw_insert.GetItemNumber(k,"canqty")
	IF IsNull(dRemainQty) Or dRemainQty = 0 Then
		dw_insert.SetItem(k, 'chk', 'N')
		Continue
	End If
	dw_insert.SetItem(k,"chk",sStatus)
Next

w_mdi_frame.sle_msg.text = ''
end event

type st_2 from statictext within w_sal_02270
integer x = 1303
integer y = 2264
integer width = 1467
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "* 취소가능 수량 = ( 주문 - 할당 ) > 0"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_02270
integer x = 2894
integer y = 2264
integer width = 1737
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "* 생산승인일자 존재시 생산승인 취소의뢰를 먼저 하세요.!!"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_02270
integer y = 2264
integer width = 1458
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "* 취소는 절대수범위내에서 출고된 자료에 한함."
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_sal_02270
integer x = 727
integer y = 32
integer width = 82
integer height = 72
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02270
integer x = 1198
integer y = 32
integer width = 82
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02270
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 456
integer width = 4622
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

