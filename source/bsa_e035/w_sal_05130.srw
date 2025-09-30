$PBExportHeader$w_sal_05130.srw
$PBExportComments$거래처 미납잔 일괄변경
forward
global type w_sal_05130 from w_inherite
end type
type cbx_1 from checkbox within w_sal_05130
end type
type rr_1 from roundrectangle within w_sal_05130
end type
type dw_list from datawindow within w_sal_05130
end type
type pb_1 from u_pb_cal within w_sal_05130
end type
type pb_2 from u_pb_cal within w_sal_05130
end type
end forward

global type w_sal_05130 from w_inherite
string title = "거래처 미납잔 단가 일괄변경"
cbx_1 cbx_1
rr_1 rr_1
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
end type
global w_sal_05130 w_sal_05130

forward prototypes
public function integer wf_set_iojpno (string arg_iojpno)
end prototypes

public function integer wf_set_iojpno (string arg_iojpno);String sIojpno, sItnbr, sItdsc, sIspec
String sCvcod, sCvnas2, sArea, sSteamCd, sIoDate
Double dIoPrc

select x.io_date, x.iojpno, x.itnbr, y.itdsc, y.ispec, x.ioprc, x.cvcod, v.cvnas2, v.sarea, a.steamcd
  into :sIoDate, :sIojpno , :sItnbr ,:sitdsc, :sispec , :dIoPrc,:sCvcod, :sCvnas2, :sArea, :sSteamCd
  from imhist x, itemas y, vndmst v, sarea a
 where x.cvcod = v.cvcod and
       v.sarea = a.sarea and
       x.itnbr = y.itnbr and
       x.sabu = :gs_sabu and
		 x.iojpno = :arg_iojpno;

If sqlca.sqlcode = 0 Then
	dw_insert.SetItem(1,'iojpno',  left(sIojpno,12))
	dw_insert.SetItem(1,'sdatef',  sIoDate)
	dw_insert.SetItem(1,'sdatet',  sIoDate)
	dw_insert.SetItem(1,'itnbr',   sItnbr)
	dw_insert.SetItem(1,'itdsc',   sItdsc)
	dw_insert.SetItem(1,'ispec',   sIspec)
	dw_insert.SetItem(1,'ioprc',   dIoPrc)
	dw_insert.SetItem(1,'steamcd', sSteamCd)
	dw_insert.SetItem(1,'sarea',   sArea)
	dw_insert.SetItem(1,'cvcod',   sCvcod)
	dw_insert.SetItem(1,'cvcodnm', sCvnas2)
End If

Return 0
end function

on w_sal_05130.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
end on

on w_sal_05130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_list.SetTransObject(sqlca)

dw_insert.SetTransObject(sqlca)


// 관할구역 설정
f_child_saupj(dw_insert, 'sarea', gs_saupj)

dw_insert.InsertRow(0)

// 부가세 사업장 설정
f_mod_saupj(dw_insert, 'saupj')


/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_insert.Modify("sarea.protect=1")
	dw_insert.Modify("steamcd.protect=1")
End If
dw_insert.SetItem(1, 'sarea', sarea)
dw_insert.SetItem(1, 'steamcd', steam)


p_can.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sal_05130
integer x = 9
integer y = 0
integer width = 3822
integer height = 320
integer taborder = 10
string dataobject = "d_sal_05130"
boolean border = false
end type

event dw_insert::itemchanged;String  sDateFrom,sDateTo,snull
String  sItnbr,sIttyp, sItcls,sItdsc, sIspec, sItemclsname, sIojpNo, sJijil, sIspeccode
String  sarea, steam, sCvcod, scvnas, sSaupj, sName1 , ls_order_no
Long    nRow, nCnt, ireturn ,ll_count , nLen

SetNull(snull)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName() 
	Case 'saupj'
		sSaupj = Trim(GetText())
		
		f_child_saupj(this, 'sarea', sSaupj)
	Case 'order_no'
		ls_order_no = Trim(this.gettext())
		if ls_order_no = "" or isnull(ls_order_no) then return
		
		nLen = Len(ls_order_no)
		
		cb_inq.PostEvent(Clicked!)
		
	Case  "iojpno" 
		sIoJpNo = Mid(this.GetText(),1,12)
		IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
	
		SELECT COUNT("IMHIST"."IOJPNO")   INTO :nCnt
	  	  FROM "IMHIST"  
    	 WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND 
	    	    ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
 		 		 ( "IMHIST"."JNPCRT" ='004') ;

		IF SQLCA.SQLCODE <> 0 THEN	  Return 2

  Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[출고기간]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[출고기간]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 영업팀 */
 Case "steamcd"
	SetItem(1,'sarea',sNull)
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)
/* 관할구역 */
 Case "sarea"
	SetItem(1,"cvcod",sNull)
	SetItem(1,"cvcodnm",sNull)

	sarea = this.GetText()
	IF sarea = "" OR IsNull(sarea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		FROM "SAREA"  
		WHERE "SAREA"."SAREA" = :sarea   ;
		
   SetItem(1,'steamcd',steam)
	/* 거래처 */
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
			SetItem(1,"steamcd",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,"cvcodnm",	scvnas)
		END IF
	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			SetItem(1,"steamcd",   steam)
			SetItem(1,"sarea",   sarea)
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			Return 1
		END IF	
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 품명 */
	Case "itdsc"
		sItdsc = trim(GetText())
	
		ireturn = f_get_name4_sale('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())
	
		ireturn = f_get_name4_sale('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 재질 */
	Case "jijil"
		sJijil = trim(GetText())
	
		ireturn = f_get_name4_sale('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
	/* 규격코드 */
	Case "ispec_code"
		sIspecCode = trim(GetText())
	
		ireturn = f_get_name4_sale('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(nRow, "itnbr", sitnbr)	
		setitem(nRow, "itdsc", sitdsc)	
		setitem(nRow, "ispec", sispec)
		setitem(nRow, "ispec_code", sispeccode)
		setitem(nRow, "jijil", sjijil)
		RETURN ireturn
END Choose
end event

event dw_insert::rbuttondown;string sCvcod
Long   nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case this.GetColumnName()
	/* 거래처 */
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	/* 품목 */
	Case "itnbr","itdsc","ispec"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itnbr",gs_code)
		PostEvent(ItemChanged!)
	/* 출고승인 전표 */
	Case "iojpno" 
		sCvcod = Trim(GetItemString(nRow,'cvcod'))
		If IsNull(sCvcod) Then sCvcod = ''
		
		gs_code     = sCvcod
		gs_gubun    = '004'
		gs_codename = 'A'
		Open(w_imhist_02040_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		wf_set_iojpno(gs_code)
		SetColumn('ioprc')
	/* 수주번호 */
	Case "order_no"
			OpenWithParm(w_sorder_popup,'1')
			IF gs_code ="" OR IsNull(gs_code) THEN RETURN
			
			SetItem(1,"order_no", Left(gs_code,len(gs_code)-3))
		
END Choose
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_05130
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_sal_05130
integer y = 5000
end type

type p_search from w_inherite`p_search within w_sal_05130
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_sal_05130
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_sal_05130
integer x = 4434
end type

type p_can from w_inherite`p_can within w_sal_05130
integer x = 4261
end type

event p_can::clicked;call super::clicked;String sDate

//dw_insert.Reset()
//dw_insert.InsertRow(0)

sdate = f_today()
dw_insert.SetItem(1,'sdatef',Left(sdate,6)+'01')
dw_insert.SetItem(1,'sdatet',sDate)

dw_list.Reset()
end event

type p_print from w_inherite`p_print within w_sal_05130
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_sal_05130
integer x = 3913
end type

event p_inq::clicked;call super::clicked;string sDatef,sDatet,sYymm,sIojpno,sItnbr,sSteamCd,sSArea,sCvcod, sPrtgbn, sToday, sSaupj , ls_order_no
Long   nCnt, ix
string sOrderSpec
double ditemprice,ddcrate, dItemQty


If dw_insert.AcceptText() <> 1 then Return

sDatef = Trim(dw_insert.GetItemString(1,'sdatef'))
sDatet = Trim(dw_insert.GetItemString(1,'sdatet'))
sPrtgbn = Trim(dw_insert.GetItemString(1,'prtgbn'))
sSaupj = Trim(dw_insert.GetItemString(1,'saupj'))
ls_order_no = Trim(dw_insert.GetItemString(1,'order_no'))

dw_insert.SetFocus()

sYymm  = Left(sDatef,6)
If IsNull(sdatef) Or sdatef = '' Or IsNull(sdatet) Or sdatet = '' Then
   f_message_chk(1400,'[출고기간]')
	dw_insert.SetColumn('sdatef')
	Return 
End If

If Left(sDatef,6) <> Left(sDatet,6) Then
	MessageBox('확 인','출고기간은 같은 년월만 가능합니다.!!')
	Return
End If

If IsNull(sSaupj) Or sSaupj = '' Then
   f_message_chk(1400,'[부가사업장]')
	dw_insert.SetColumn('saupj')
	Return 
End If

if ls_order_no = "" or isnull(ls_order_no) then ls_order_no = '%'

/* 마감처리된 년월 확인 */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" >= :sYymm );

If nCnt > 0 Then
	f_message_chk(60,'')
	Return 
End If

/* 품번 */
sItnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
If IsNull(sItnbr) Then sItnbr = ''

sSteamCd = Trim(dw_insert.GetItemString(1,'steamcd'))
sSArea   = Trim(dw_insert.GetItemString(1,'sarea'))
sCvcod   = Trim(dw_insert.GetItemString(1,'cvcod'))
If IsNull(sSteamCd) Then sSteamCd = ''
If IsNull(sSArea)   Then sSarea = ''
If IsNull(sCvcod)   Then sCvcod = ''

If dw_list.retrieve(gs_sabu, sdatef, sdatet, ssteamcd+'%', ssarea+'%', sCvcod+'%', sItnbr+'%', sSaupj,ls_order_no) <= 0 Then
	f_message_chk(300,'')
	Return
End If

sToday = f_today()

SetPointer(HourGlass!)

/* 할인율에 의한 할인율 */
If sPrtGbn = '1' Then
	For ix = 1 To dw_list.RowCount()
		sCvcod 	  = dw_list.GetItemString(ix, "cvcod")
		sOrderSpec = dw_list.GetItemString(ix, "order_spec")

		sItnbr	  = dw_list.GetItemString(ix, "itnbr")
		dItemQty	  = dw_list.GetItemNumber(ix, "ioqty")
		
		sqlca.Fun_Erp100000016(gs_sabu,  sToday, sCvcod, sItnbr,sOrderSpec , 'WON','1', dItemPrice, dDcRate)
		If IsNull(dItemPrice) Then dItemPrice = 0
		If IsNull(dDcRate) Then dDcRate = 0
		
		/* 단가 : 절사한다 */
		dItemPrice = TrunCate(dItemPrice,0)
		
		/* 금액 계산 */	
		dw_list.SetItem(ix,"vioprc",dItemPrice)
		dw_list.SetItem(ix,"vioamt",TrunCate(dItemQty * dItemPrice,0))
	Next
End If
end event

type p_del from w_inherite`p_del within w_sal_05130
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_sal_05130
integer x = 4087
end type

event p_mod::clicked;call super::clicked;Long nRow, ix, nCnt=0
Double dIoPrc, dIoAmt

nRow = dw_list.RowCount()
If nRow <= 0 Then Return

For ix = 1 To nRow
	If dw_list.GetItemString(ix, 'chk') = 'N' Then Continue
	
	dIoPrc = dw_list.GetItemNumber(ix, 'vioprc')
	If IsNull(dIoPrc) Then Continue
	
	dIoamt = dw_list.GetItemNumber(ix, 'vioamt')
	If IsNull(dIoAmt) Then Continue
	
	dw_list.SetItem(ix, 'order_prc', dIoPrc)
	dw_list.SetItem(ix, 'order_amt', dIoAmt)
	dw_list.SetItem(ix, 'chng_prc', dIoPrc)
	
	nCnt += 1
Next

If nCnt <= 0 Then
	MessageBox('확 인','변경된 정보가 없습니다')
	Return
End If

If dw_list.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
Else
	Commit;
	MessageBox('확 인','총 '+string(ncnt)+'건 변경되었습니다.!!')
End If

p_can.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
end event

type cb_exit from w_inherite`cb_exit within w_sal_05130
integer x = 3374
integer y = 2620
integer taborder = 50
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sal_05130
integer x = 878
integer y = 2416
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sal_05130
integer x = 517
integer y = 2416
end type

type cb_del from w_inherite`cb_del within w_sal_05130
integer x = 1239
integer y = 2416
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sal_05130
integer x = 2647
integer y = 2484
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sal_05130
integer x = 1961
integer y = 2416
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_05130
end type

type cb_can from w_inherite`cb_can within w_sal_05130
integer x = 3022
integer y = 2628
integer taborder = 40
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sal_05130
integer x = 2624
integer y = 2620
integer width = 334
integer taborder = 20
boolean enabled = false
string text = "저장(&P)"
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_05130
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_05130
end type

type cbx_1 from checkbox within w_sal_05130
integer x = 3387
integer y = 32
integer width = 366
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
string text = "전체선택"
end type

event clicked;long ll_count
string ls_status

if this.checked=true then
	ls_status='Y'
elseif this.checked=false then
	ls_status='N'
else
	setnull(ls_status)
end if

 for ll_count=1 to dw_list.rowcount()
	dw_list.setitem(ll_count,'chk',ls_status)
next

end event

type rr_1 from roundrectangle within w_sal_05130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 340
integer width = 4585
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_sal_05130
integer x = 18
integer y = 344
integer width = 4558
integer height = 1976
integer taborder = 30
string dataobject = "d_sal_05130_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Long nRow
Dec	dIoPrc, dIoQty

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'vioprc'
		dIoPrc = Dec(GetText())
		
		dIoQty = GetItemNumber(nRow, 'ioqty')
		
		SetItem(nRow, 'vioamt', TrunCate(dIoPrc * dIoQty,0))
End Choose
end event

event itemerror;return 1
end event

type pb_1 from u_pb_cal within w_sal_05130
integer x = 677
integer y = 36
integer height = 72
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_05130
integer x = 1134
integer y = 36
integer height = 72
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sdatet', gs_code)

end event

