$PBExportHeader$w_mat_01510_meip.srw
$PBExportComments$입고일보 현황 (매입)
forward
global type w_mat_01510_meip from w_standard_print
end type
type pb_1 from u_pic_cal within w_mat_01510_meip
end type
type pb_2 from u_pic_cal within w_mat_01510_meip
end type
type cb_7 from commandbutton within w_mat_01510_meip
end type
type dw_prt from datawindow within w_mat_01510_meip
end type
end forward

global type w_mat_01510_meip from w_standard_print
integer width = 4654
integer height = 2368
string title = "입고일보 현황"
pb_1 pb_1
pb_2 pb_2
cb_7 cb_7
dw_prt dw_prt
end type
global w_mat_01510_meip w_mat_01510_meip

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2, sHouse, sGubun, sfcvcod, stcvcod, sIogbn, sIojpno, eIojpno, sqty, bagbn , sitnbr1, &
       sitnbr2, ls_porgu, ls_ittyp, ls_filter
decimal {3} dqty1, dqty2

IF dw_ip.AcceptText() = -1 THEN RETURN -1

cod1 = TRIM(dw_ip.GetItemString(1, 'sdate'))
cod2 = TRIM(dw_ip.GetItemString(1, 'edate'))
sHouse = dw_ip.GetItemString(1, "house")
sGubun = dw_ip.GetItemString(1, "gubun")
sfcvcod = dw_ip.GetItemString(1, "fcvcod")
stcvcod = dw_ip.GetItemString(1, "tcvcod")
sIogbn  = dw_ip.GetItemString(1, "iogbn")
sIojpno  = dw_ip.GetItemString(1, "siojpno")
eIojpno  = dw_ip.GetItemString(1, "eiojpno")
sqty     = dw_ip.GetItemString(1, "sqty")
sitnbr1 = TRIM(dw_ip.GetItemString(1, 'sitnbr'))
sitnbr2 = TRIM(dw_ip.GetItemString(1, 'eitnbr'))
ls_porgu = TRIM(dw_ip.GetItemString(1, 'porgu'))
ls_ittyp = dw_ip.GetItemString(1, 'ittyp')

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

dw_list.SetFilter(ls_filter)
dw_print.SetFilter(ls_filter)
dw_list.Filter( )
dw_print.Filter( )


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

//IF dw_print.Retrieve(gs_sabu, cod1, cod2, sHouse, sfcvcod, stcvcod, &
//                    siogbn, siojpno, eiojpno, dqty1, dqty2, sitnbr1, sitnbr2, ls_porgu, gs_saupcd, ls_ittyp) <= 0 then
//	f_message_chk(50,'[입고 현황]')
//	dw_list.Reset()
//	Return -1
//END IF

IF dw_print.Retrieve(gs_sabu, cod1, cod2, sHouse, sfcvcod, stcvcod, &
                    siogbn, siojpno, eiojpno, dqty1, dqty2, sitnbr1, sitnbr2, ls_porgu, ls_porgu, ls_ittyp) <= 0 then
	f_message_chk(50,'[입고 현황]')
	dw_list.Reset()
	Return -1
END IF

cod1 = left(cod1,4) + '/' + mid(cod1,5,2) + '/' + right(cod1,2)
cod2 = left(cod2,4) + '/' + mid(cod2,5,2) + '/' + right(cod2,2)
dw_print.Object.st_date.text = cod1 + ' - ' + cod2

dw_list.ShareData(dw_print)

Return 1
end function

on w_mat_01510_meip.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_7=create cb_7
this.dw_prt=create dw_prt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cb_7
this.Control[iCurrent+4]=this.dw_prt
end on

on w_mat_01510_meip.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_7)
destroy(this.dw_prt)
end on

event ue_open;call super::ue_open;
dw_ip.SetItem(1, 1, Left(is_today,6) + '01')
dw_ip.SetItem(1, 2, is_today)

////사업장
//f_mod_saupj(dw_ip, 'porgu' )

//창고
f_child_saupj(dw_ip, 'house',gs_saupj )
end event

event open;call super::open;PostEvent('ue_open') 
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

type dw_list from w_standard_print`dw_list within w_mat_01510_meip
integer y = 324
integer width = 4558
integer height = 1924
string dataobject = "d_mat_01510_meip"
end type

type cb_print from w_standard_print`cb_print within w_mat_01510_meip
integer x = 3461
integer y = 480
end type

type cb_excel from w_standard_print`cb_excel within w_mat_01510_meip
integer x = 2793
integer y = 480
end type

type cb_preview from w_standard_print`cb_preview within w_mat_01510_meip
integer x = 3127
integer y = 480
end type

type cb_1 from w_standard_print`cb_1 within w_mat_01510_meip
integer x = 2459
integer y = 480
end type

type dw_print from w_standard_print`dw_print within w_mat_01510_meip
integer x = 4261
integer y = 152
integer width = 169
integer height = 108
string dataobject = "d_mat_01510_meip_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_01510_meip
integer y = 36
integer width = 4558
integer height = 256
string dataobject = "d_mat_01511_meip"
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
	s_cod = This.GetText()
//	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
//	this.object.sitnbr[1] = s_cod
	this.object.eitnbr[1] = s_cod
//	this.object.sitdsc[1] = s_nam1
//	return i_rtn
//elseif this.GetColumnName() = "eitnbr" then
//	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
//	this.object.eitnbr[1] = s_cod
//	return i_rtn
elseif this.GetColumnName() = "porgu" then
	s_cod = this.GetText()
	//창고
	f_child_saupj(dw_ip, 'house',s_cod )
ElseIf This.GetColumnName() = 'fcvcod' Then
	s_cod = This.GetText()
	This.Object.tcvcod[1] = s_cod
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

type r_1 from w_standard_print`r_1 within w_mat_01510_meip
integer y = 320
integer width = 4567
integer height = 1932
end type

type r_2 from w_standard_print`r_2 within w_mat_01510_meip
integer y = 32
integer width = 4567
integer height = 264
end type

type pb_1 from u_pic_cal within w_mat_01510_meip
integer x = 1490
integer y = 40
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

type pb_2 from u_pic_cal within w_mat_01510_meip
integer x = 1952
integer y = 40
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

type cb_7 from commandbutton within w_mat_01510_meip
boolean visible = false
integer x = 3927
integer y = 184
integer width = 416
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "스티커 출력"
end type

event clicked;String ls_iojpno[]
String ls_chk
Long   i
Long   ll_chk
ll_chk = 0
i      = 0
For i = 1 To dw_list.RowCount()
	ls_chk = dw_list.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		ls_iojpno[i] = dw_list.GetItemString(i, 'imhist_iojpno')
		ll_chk = ll_chk + 1
	End If
Next

If ll_chk < 1 Then
	MessageBox('선택자료 확인', '선택된 자료가 없습니다.')
	Return
End If

dw_prt.SetRedraw(False)
dw_prt.Retrieve(ls_iojpno[])
dw_prt.SetRedraw(True)

OpenWithParm(w_print_preview, dw_prt)
end event

type dw_prt from datawindow within w_mat_01510_meip
boolean visible = false
integer x = 3657
integer y = 216
integer width = 261
integer height = 172
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_mat_01510_p-1"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

