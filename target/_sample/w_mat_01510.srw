$PBExportHeader$w_mat_01510.srw
$PBExportComments$입고일보 현황
forward
global type w_mat_01510 from w_standard_print
end type
type pb_1 from u_pic_cal within w_mat_01510
end type
type pb_2 from u_pic_cal within w_mat_01510
end type
type cb_7 from commandbutton within w_mat_01510
end type
type dw_prt from datawindow within w_mat_01510
end type
type cbx_1 from checkbox within w_mat_01510
end type
type dw_chul from datawindow within w_mat_01510
end type
type cb_2 from commandbutton within w_mat_01510
end type
type cb_3 from commandbutton within w_mat_01510
end type
type cb_4 from commandbutton within w_mat_01510
end type
type cb_5 from commandbutton within w_mat_01510
end type
type cb_6 from commandbutton within w_mat_01510
end type
type dw_barprt from datawindow within w_mat_01510
end type
type dw_stkprt from datawindow within w_mat_01510
end type
type dw_barprt2 from datawindow within w_mat_01510
end type
end forward

global type w_mat_01510 from w_standard_print
integer width = 5371
integer height = 2336
string title = "입고일보 현황"
pb_1 pb_1
pb_2 pb_2
cb_7 cb_7
dw_prt dw_prt
cbx_1 cbx_1
dw_chul dw_chul
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
dw_barprt dw_barprt
dw_stkprt dw_stkprt
dw_barprt2 dw_barprt2
end type
global w_mat_01510 w_mat_01510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2, sHouse, sGubun, sfcvcod, stcvcod, sIogbn, sIojpno, eIojpno, sqty, bagbn , sitnbr1, &
       sitnbr2, ls_porgu, ls_ittyp, ls_filter
decimal {3} dqty1, dqty2

IF dw_ip.AcceptText() = -1 THEN RETURN -1

cod1 = TRIM(dw_ip.GetItemString(1, 'sdate'))     //기간
cod2 = TRIM(dw_ip.GetItemString(1, 'edate'))     //기간
sHouse = dw_ip.GetItemString(1, "house")         //창고
sGubun = dw_ip.GetItemString(1, "gubun")         //자료구분
sfcvcod = dw_ip.GetItemString(1, "fcvcod")       //거래처
stcvcod = dw_ip.GetItemString(1, "tcvcod")       //거래처
sIogbn  = dw_ip.GetItemString(1, "iogbn")        //수불구분
sIojpno  = dw_ip.GetItemString(1, "siojpno")     //전표번호(입고의뢰번호)
eIojpno  = dw_ip.GetItemString(1, "eiojpno")     //전표번호(입고의뢰번호)
sqty     = dw_ip.GetItemString(1, "sqty")        //판정구분
sitnbr1 = TRIM(dw_ip.GetItemString(1, 'sitnbr')) //품번
sitnbr2 = TRIM(dw_ip.GetItemString(1, 'eitnbr')) //품번
ls_porgu = TRIM(dw_ip.GetItemString(1, 'porgu')) //사업장
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')       //품목구분

if (IsNull(cod1) or cod1 = "")  then cod1 = "10000101"
if (IsNull(cod2) or cod2 = "")  then cod2 = "99991231"

if IsNull(sHouse)  or trim(sHouse) =''		THEN	sHouse = '%'
if IsNull(sIogbn)  or trim(sIogbn) =''		THEN	sIogbn = '%'
if IsNull(sfcvcod) or trim(sfcvcod) =''	THEN	sfcvcod = '.'
if IsNull(stcvcod) or trim(stcvcod) =''	THEN	stcvcod = 'ZZZZZZZZZZZZZZZ'
if IsNull(siojpno) or trim(sIojpno) =''	THEN	siojpno = '.'
if IsNull(eiojpno) or trim(eIojpno) =''	THEN	eiojpno = 'ZZZZZZZZZZZZZZZ'
if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = "."
if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = "zzzzzzzzzz"
if (IsNull(ls_porgu) or ls_porgu = "")  then ls_porgu = "%"
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

/* 발주단위 사용여부를 환경설정에서 검색함 */
bagbn	= 'N';
select dataname
  into :bagbn
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
 
if sqlca.sqlcode <> 0 then
	bagbn = 'N'
end if

if sGubun = "6" then  // 출발처리(미입하)
	sfcvcod = '%'
	sitnbr1 = '%'
End If

if sGubun  ="1" then 		//	전체
	ls_filter = ""
elseif sGubun  ="2" then	//	미검사(입하)
	ls_filter = " IsNull(insdat) "
elseif sGubun  ="3" then	//	미입고(검사)
	ls_filter = " ( not IsNull(insdat) ) and IsNull(io_date) "
elseif sGubun  ="4" then	//	입고
	ls_filter = " not IsNull(io_date) "
elseif sGubun  ="5" then	//	이월
	ls_filter = " left(imhist_sudat,6) <> left(io_date,6) "
end if

If sGubun <> '6' Then
	dw_list.SetFilter(ls_filter)
	dw_print.SetFilter(ls_filter)
	dw_list.Filter( )
	dw_print.Filter( )
End If

//////////////////////////////////////////////////////////////////////
if sqty = '1' then
	dqty1 = -9999999999.99
	dqty2 = 0
elseif sqty = '2' then
	dqty1 = 0
	dqty2 = -9999999999.99
else
	dqty1 = -9999999999.99
	dqty2 = -9999999999.99
end if


//if dw_list.Retrieve(gs_sabu, cod1, cod2, sHouse, sfcvcod, stcvcod, &
//                    siogbn, siojpno, eiojpno, dqty1, dqty2, sitnbr1, sitnbr2) <= 0 then
//	f_message_chk(50,'[입고 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

If sgubun <> '6' Then
	IF dw_print.Retrieve(gs_sabu, cod1, cod2, sHouse, sfcvcod, stcvcod, &
							  siogbn, siojpno, eiojpno, dqty1, dqty2, sitnbr1, sitnbr2, ls_porgu, gs_saupcd, ls_ittyp) <= 0 then
		f_message_chk(50,'[입고 현황]')
		dw_list.Reset()
		Return -1
	END IF

	cod1 = left(cod1,4) + '/' + mid(cod1,5,2) + '/' + right(cod1,2)
	cod2 = left(cod2,4) + '/' + mid(cod2,5,2) + '/' + right(cod2,2)
	dw_print.Object.st_date.text = cod1 + ' - ' + cod2

	dw_list.ShareData(dw_print)
Else
	If dw_chul.Retrieve(gs_sabu, cod1, cod2, sfcvcod, sitnbr1, ls_ittyp) <= 0 Then
		f_message_chk(50,'[입고 현황]')
		dw_chul.Reset()
		Return -1
	End If
End If

Return 1
end function

on w_mat_01510.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_7=create cb_7
this.dw_prt=create dw_prt
this.cbx_1=create cbx_1
this.dw_chul=create dw_chul
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.dw_barprt=create dw_barprt
this.dw_stkprt=create dw_stkprt
this.dw_barprt2=create dw_barprt2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cb_7
this.Control[iCurrent+4]=this.dw_prt
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.dw_chul
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cb_5
this.Control[iCurrent+11]=this.cb_6
this.Control[iCurrent+12]=this.dw_barprt
this.Control[iCurrent+13]=this.dw_stkprt
this.Control[iCurrent+14]=this.dw_barprt2
end on

on w_mat_01510.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_7)
destroy(this.dw_prt)
destroy(this.cbx_1)
destroy(this.dw_chul)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.dw_barprt)
destroy(this.dw_stkprt)
destroy(this.dw_barprt2)
end on

event ue_open;call super::ue_open;
dw_ip.SetItem(1, 1, Left(is_today,6) + '01')
dw_ip.SetItem(1, 2, is_today)

//사업장
f_mod_saupj(dw_ip, 'porgu' )

//창고
f_child_saupj(dw_ip, 'house',gs_saupj )
end event

event open;call super::open;PostEvent('ue_open') 
end event

event ue_preview;/* 상속받지 않음  */
If dw_ip.GetItemString(1, 'gubun') = '6' Then
	MessageBox('확인', '해당 화면은 인쇄물을 지원하지 않습니다.')
	Return
End If

dw_print.object.datawindow.print.preview = "yes"	

OpenWithParm(w_print_preview, dw_print)	
end event

event ue_retrieve;if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  
	w_mdi_frame.SetMicroHelp("") 
	
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

String ls_ittyp

ls_ittyp = dw_ip.GetItemString(1, 'ittyp')

IF wf_retrieve() = -1 THEN  
	SetPointer(Arrow!)
	dw_ip.SetFocus()
	Return
Else
	If ls_ittyp = '3' Then
		cb_7.Enabled = True
	Else
		cb_1.Enabled = False
	End If
END IF
dw_print.object.datawindow.print.preview = "yes"	
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	
end event

event resize;r_2.width = this.width - 60
dw_ip.width = this.width - 70

r_1.width = this.width - 60
r_1.height = this.height - r_1.y - 65
dw_list.width = this.width - 70
dw_list.height = this.height - dw_list.y - 70

dw_chul.width = this.width - 70
dw_chul.height = this.height - dw_chul.y - 70
end event

type dw_list from w_standard_print`dw_list within w_mat_01510
integer y = 420
integer width = 5239
integer height = 1808
string dataobject = "d_mat_01510"
end type

type cb_print from w_standard_print`cb_print within w_mat_01510
integer x = 3086
integer y = 632
end type

type cb_excel from w_standard_print`cb_excel within w_mat_01510
integer x = 2418
integer y = 632
end type

type cb_preview from w_standard_print`cb_preview within w_mat_01510
integer x = 2752
integer y = 632
end type

type cb_1 from w_standard_print`cb_1 within w_mat_01510
integer x = 2085
integer y = 632
end type

type dw_print from w_standard_print`dw_print within w_mat_01510
integer x = 4261
integer y = 152
integer height = 76
string dataobject = "d_mat_01510_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_01510
integer y = 36
integer width = 5239
integer height = 256
string dataobject = "d_mat_01511"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "cod1"	THEN		
	   gs_code = this.GetText()
	   open(w_itemas_popup2)
	   if isnull(gs_code) or gs_code = "" then 
			this.SetItem(1, "cod1", "")
	      this.SetItem(1, "nam1", "")
	      return
	   else
			this.SetItem(1, "cod1", gs_code)
	      this.SetItem(1, "nam1", gs_codename)
	      this.triggerevent(itemchanged!)
	      return 1
		end if
   ELSEIF this.getcolumnname() = "cod2" THEN		
	   gs_code = this.GetText()
	   open(w_itemas_popup2)
	   if isnull(gs_code) or gs_code = "" then 	
			this.SetItem(1, "cod2", "")
	      this.SetItem(1, "nam2", "")
	      return
	   else
			this.SetItem(1, "cod2", gs_code)
	      this.SetItem(1, "nam2", gs_codename)
	      this.triggerevent(itemchanged!)
	      return 1	
		end if	
   END IF
END IF  
end event

event dw_ip::itemchanged;string	sDate, sNull, sname , s_cod, s_nam1, s_nam2
integer  i_rtn

SetNull(sNull)

IF this.GetColumnName() = 'sdate' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'edate' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'iogbn' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return 
	Select ionam into :sname
	  From iomatrix
	 where sabu = :gs_sabu and iogbn = :sDate;
	if sqlca.sqlcode <> 0 then
		f_message_chk(314,'[수불구분]')		
		this.setitem(1, "iogbn", sNull)
		return 1		
	end if
elseif this.GetColumnName() = "sitnbr" then
	s_cod = data
	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	If Trim(This.GetItemString(1, 'eitnbr')) = '' OR IsNull(This.GetItemString(1, 'eitnbr')) Then
		This.SetItem(1, 'eitnbr', s_cod)
//		This.SetItem(1, 'eitdsc', s_nam1)
	End If
	return i_rtn
elseif this.GetColumnName() = "eitnbr" then
	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	return i_rtn
elseif this.GetColumnName() = "porgu" then
	s_cod = this.GetText()
	//창고
	f_child_saupj(dw_ip, 'house',s_cod )
ElseIf This.GetColumnName() = 'fcvcod' Then
	s_cod = data//This.GetItemString(1, 'fcvcod')
	If Trim(This.GetItemString(1, 'tcvcod')) = '' OR IsNull(This.GetItemString(1, 'tcvcod')) Then
		This.SetItem(1, 'tcvcod', s_cod)
	End If
ElseIf This.GetColumnName() = 'gubun' Then
	s_cod = this.GetText()
	if s_cod = "6" then  // 출발처리(미입하)
		dw_chul.Visible = True
	Else
		dw_chul.Visible = False
	End If
end if




end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "fcvcod" then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.fcvcod[1] = gs_code
	this.object.tcvcod[1] = gs_code

elseif this.GetColumnName() = "tcvcod" then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.tcvcod[1] = gs_code

ELSEIF this.getcolumnname() = "sitnbr"	THEN		
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "sitnbr", gs_code)
	this.SetItem(1, "sitdsc", gs_codename)
	return	

ELSEIF this.getcolumnname() = "eitnbr"	THEN		
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "eitnbr", gs_code)
	this.SetItem(1, "eitdsc", gs_codename)
	return		
END IF
	



end event

type r_1 from w_standard_print`r_1 within w_mat_01510
integer y = 416
integer width = 5248
integer height = 1808
end type

type r_2 from w_standard_print`r_2 within w_mat_01510
integer y = 32
integer width = 5248
integer height = 264
end type

type pb_1 from u_pic_cal within w_mat_01510
integer x = 1435
integer y = 32
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_mat_01510
integer x = 1897
integer y = 32
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type cb_7 from commandbutton within w_mat_01510
integer x = 3922
integer y = 172
integer width = 416
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "스티커 출력"
end type

event clicked;//String ls_iojpno[]
String ls_iojpno
String ls_chk, ls_filter, old_select, new_select

Long   i
Long   ll_chk

ll_chk = 0

For i = 1 To dw_list.RowCount()
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		//ls_iojpno[i] = dw_list.GetItemString(i, 'imhist_iojpno')
		ls_iojpno = dw_list.GetItemString(i, 'imhist_iojpno')
		ls_filter = ls_filter + "'" + ls_iojpno + "',"
		ll_chk++
	End If
Next

If ll_chk < 1 Then
	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
	Return
End If

dw_stkprt.SetRedraw(False)

//dw_prt.DataObject = 'd_mat_01510_p-1'
//dw_prt.SetTransObject(sqlca)

old_select = dw_stkprt.GetSQLSelect()
// MessageBox('', old_select)
new_select  = old_select + " AND A.SABU = '" + gs_sabu + "' AND A.IOJPNO IN (" + Mid(ls_filter, 1, Len(ls_filter) - 1) + ") "
// MessageBox('', new_select)
dw_stkprt.SetSQLSelect(new_select)

dw_stkprt.Retrieve()
dw_stkprt.SetRedraw(True)

OpenWithParm(w_print_preview, dw_stkprt)

dw_stkprt.SetSQLSelect(old_select)
end event

type dw_prt from datawindow within w_mat_01510
boolean visible = false
integer x = 2971
integer y = 320
integer width = 174
integer height = 84
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_mat_01510_barcode2"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cbx_1 from checkbox within w_mat_01510
integer x = 50
integer y = 328
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "전체선택"
end type

event clicked;Long   i
Long   ll_cnt

ll_cnt = dw_list.RowCount()
If ll_cnt < 1 Then Return

If This.Checked = True Then
	This.Text = '전체선택'
	For i = 1 To ll_cnt
		dw_list.SetItem(i, 'chk', 'Y')
	Next
Else
	This.Text = '선택해제'
	For i = 1 To ll_cnt
		dw_list.SetItem(i, 'chk', 'N')
	Next	
End If
end event

type dw_chul from datawindow within w_mat_01510
boolean visible = false
integer x = 37
integer y = 420
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_01510_chul"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_2 from commandbutton within w_mat_01510
boolean visible = false
integer x = 2313
integer y = 308
integer width = 649
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "스티커 출력(backup)"
end type

event clicked;//String ls_iojpno[]
//String ls_chk
//Long   i
//Long   ll_chk
//ll_chk = 0
//i      = 0
//For i = 1 To dw_list.RowCount()
//	ls_chk = dw_list.GetItemString(i, 'chk')
//	If ls_chk = 'Y' Then
//		ls_iojpno[i] = dw_list.GetItemString(i, 'imhist_iojpno')
//		ll_chk = ll_chk + 1
//	End If
//Next
//
//If ll_chk < 1 Then
//	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
//	Return
//End If
//
//dw_prt.SetRedraw(False)
//dw_prt.Retrieve(ls_iojpno)
//dw_prt.SetRedraw(True)
//
//OpenWithParm(w_print_preview, dw_prt)
/*
String ls_getsql

ls_getsql = "  SELECT A.ITNBR," + &
            "         DECODE( C.ISPEC_CODE, NULL, C.JIJIL, C.JIJIL || '-' || C.ISPEC_CODE) AS JIJIL ," + &
            "         C.ISPEC AS ITEMAS_ISPEC," + &
            "         A.PSPEC," + &
            "         A.IOQTY," + &
            "         A.LOTSNO" + &
            "    FROM IMHIST    A," + &   
            "         IOMATRIX  B," + &   
            "         ITEMAS    C," + &   
            "         VNDMST    D," + & 
			   "         VNDMST    E," + & 
			   "         P1_MASTER F," + &
			   "         STOCK     G," + &
  			   "         ITMBUY    H " + &
            "   WHERE A.ITNBR    =    C.ITNBR        AND" + &  
            "         A.DEPOT_NO =    D.CVCOD        AND" + &  
			   "         A.CVCOD    =    E.CVCOD(+)     AND" + &
			   "         A.IO_EMPNO =    F.EMPNO(+)     AND" + &  
			   "         A.SABU     =    B.SABU         AND" + &
			   "         A.IOGBN    =    B.IOGBN        AND" + &
			   "         A.DEPOT_NO =    G.DEPOT_NO(+)  AND" + &
			   "         A.ITNBR    =    G.ITNBR(+)     AND" + &
			   "         A.PSPEC    =    G.PSPEC(+)     AND" + &
			   "         A.ITNBR    =    H.ITNBR(+)     AND" + &
			   "         A.CVCOD    =    H.CVCOD(+)     AND" + &
			   "         H.SEQNO(+) =    0                 "
*/
String ls_iojpno[]
String ls_chk

Long   i
Long   ll_chk
ll_chk = 0
i      = 0
For i = 1 To dw_list.RowCount()
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ls_iojpno[i] = dw_list.GetItemString(i, 'imhist_iojpno')
		/*
		If ll_chk = 0 Then
			ls_iojpno = dw_list.GetItemString(i, 'imhist_iojpno')
		Else
			ls_iojpno = ls_iojpno + ', ' + dw_list.GetItemString(i, 'imhist_iojpno')
		End If
		*/
		ll_chk++
	End If
Next

/*
ls_getsql = ls_getsql + "AND A.IOJPNO IN ( " + ls_iojpno + " ) AND A.ITNBR LIKE 'C%'"
dw_prt.SetSQLSelect(ls_getsql)
*/

dw_prt.SetRedraw(False)
dw_prt.Retrieve(gs_sabu, ls_iojpno)
dw_prt.SetRedraw(True)

OpenWithParm(w_print_preview, dw_prt)
end event

type cb_3 from commandbutton within w_mat_01510
integer x = 3922
integer y = 56
integer width = 603
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "바코드출력(원자재)"
end type

event clicked;String ls_ittyp
//String ls_iojpno[]
String ls_iojpno
String ls_chk, ls_filter, old_select, new_select
Long   i
Long   ll_chk

ls_ittyp = Trim(dw_ip.GetItemString(1, 'ittyp'))
If IsNull(ls_ittyp) Or ls_ittyp = '' Then
	MessageBox('확인', '품목구분을 먼저 지정하시시오!')
	dw_ip.SetColumn('ittyp')
	dw_ip.SetFocus()
	Return
End If

If ls_ittyp <> '3' Then
	MessageBox('선택자료 확인', '품목구분이 원자재로 지정된 경우만 출력이 가능합니다.')
	Return
End If

ll_chk = 0

For i = 1 To dw_list.RowCount()
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		//ls_iojpno[i] = dw_list.GetItemString(i, 'imhist_iojpno')
		ls_iojpno = dw_list.GetItemString(i, 'imhist_iojpno')
		ls_filter = ls_filter + "'" + ls_iojpno + "',"
		ll_chk++
	End If
Next

If ll_chk < 1 Then
	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
	Return
End If

dw_barprt.SetRedraw(False)

//dw_prt.DataObject = 'd_mat_01510_barcode'
//dw_prt.SetTransObject(sqlca)

old_select = dw_barprt.GetSQLSelect()
// MessageBox('', old_select)
new_select  = old_select + " AND A.SABU = '" + gs_sabu + "' AND A.IOJPNO IN (" + Mid(ls_filter, 1, Len(ls_filter) - 1) + ") "
// MessageBox('', new_select)
dw_barprt.SetSQLSelect(new_select)

dw_barprt.Retrieve()

dw_barprt.SetRedraw(True)

OpenWithParm(w_print_preview, dw_barprt)

dw_barprt.SetSQLSelect(old_select)
end event

type cb_4 from commandbutton within w_mat_01510
integer x = 4535
integer y = 56
integer width = 695
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "바코드출력(원자재 외)"
end type

event clicked;String ls_ittyp
//String ls_iojpno[]
String ls_iojpno
String ls_chk, ls_filter, old_select, new_select
Long   i
Long   ll_chk

ls_ittyp = Trim(dw_ip.GetItemString(1, 'ittyp'))
If IsNull(ls_ittyp) Or ls_ittyp = '' Then
	MessageBox('확인', '품목구분을 먼저 지정하시시오!')
	dw_ip.SetColumn('ittyp')
	dw_ip.SetFocus()
	Return
End If

If ls_ittyp = '3' Then
	MessageBox('확인', '품목구분이 원자재가 아닌 경우만 출력이 가능합니다.')
	Return
End If

ll_chk = 0

For i = 1 To dw_list.RowCount()
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		//ls_iojpno[i] = dw_list.GetItemString(i, 'imhist_iojpno')
		ls_iojpno = dw_list.GetItemString(i, 'imhist_iojpno')
		ls_filter = ls_filter + "'" + ls_iojpno + "',"
		ll_chk++
	End If
Next

If ll_chk < 1 Then
	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
	Return
End If

dw_barprt2.SetRedraw(False)

//dw_prt.DataObject = 'd_mat_01510_barcode2'
//dw_prt.SetTransObject(sqlca)

old_select = dw_barprt2.GetSQLSelect()
// MessageBox('', old_select)
new_select  = old_select + " AND A.SABU = '" + gs_sabu + "' AND A.IOJPNO IN (" + Mid(ls_filter, 1, Len(ls_filter) - 1) + ") "
// MessageBox('', new_select)
dw_barprt2.SetSQLSelect(new_select)

dw_barprt2.Retrieve()
dw_barprt2.SetRedraw(True)

OpenWithParm(w_print_preview, dw_barprt2)

dw_barprt2.SetSQLSelect(old_select)
end event

type cb_5 from commandbutton within w_mat_01510
boolean visible = false
integer x = 1019
integer y = 308
integer width = 667
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "바코드출력1"
end type

event clicked;String ls_ittyp
String ls_iojpno
String ls_chk
Long   i
Long   ll_chk

ls_ittyp = Trim(dw_ip.GetItemString(1, 'ittyp'))
If IsNull(ls_ittyp) Or ls_ittyp = '' Then
	MessageBox('확인', '품목구분을 먼저 지정하시시오!')
	dw_ip.SetColumn('ittyp')
	dw_ip.SetFocus()
	Return
End If

If ls_ittyp <> '3' Then
	MessageBox('선택자료 확인', '품목구분이 원자재로 지정된 경우만 출력이 가능합니다.')
	Return
End If

ll_chk = 0

Long		ll_rowc
ll_rowc = dw_list.RowCount()

ll_chk = dw_list.Find("chk = 'Y'", 1, ll_rowc)
If ll_chk < 1 Then
	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
	Return
End If

uLong li_job
li_job = PrintOpen()

For i = 1 To ll_rowc
	ll_chk = dw_list.Find("chk = 'Y'", i, ll_rowc)
	If ll_chk < 1 Then Exit
	
	ls_iojpno = dw_list.GetItemString(ll_chk, 'imhist_iojpno')
	
	dw_barprt.SetRedraw(False)
	dw_barprt.Retrieve(gs_sabu, ls_iojpno)
	dw_barprt.SetRedraw(True)
		
	PrintDataWindow(li_job, dw_barprt)
	
	i = ll_chk
Next

PrintSetup()

PrintClose(li_job)
end event

type cb_6 from commandbutton within w_mat_01510
boolean visible = false
integer x = 1641
integer y = 308
integer width = 603
integer height = 104
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "바코드출력2"
end type

event clicked;
OpenWithParm(w_print_preview, dw_barprt)
end event

type dw_barprt from datawindow within w_mat_01510
boolean visible = false
integer x = 1769
integer y = 1600
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_mat_01510_barcode"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type dw_stkprt from datawindow within w_mat_01510
boolean visible = false
integer x = 3250
integer y = 1600
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_mat_01510_p-1"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(sQLCA)
end event

type dw_barprt2 from datawindow within w_mat_01510
boolean visible = false
integer x = 2510
integer y = 1600
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_mat_01510_barcode2"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

