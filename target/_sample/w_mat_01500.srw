$PBExportHeader$w_mat_01500.srw
$PBExportComments$입고의뢰일보 현황
forward
global type w_mat_01500 from w_standard_print
end type
type pb_1 from u_pic_cal within w_mat_01500
end type
type pb_2 from u_pic_cal within w_mat_01500
end type
end forward

global type w_mat_01500 from w_standard_print
integer width = 4667
integer height = 2448
string title = "입고 의뢰일보 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_mat_01500 w_mat_01500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string cod1, cod2, sHouse, sGubun, sToday, scvcod1, scvcod2, sitnbr1, sitnbr2, sempno, ls_porgu

IF dw_ip.AcceptText() = -1 THEN RETURN -1

cod1 = TRIM(dw_ip.GetItemString(1, 'sdate'))
cod2 = TRIM(dw_ip.GetItemString(1, 'edate'))
sHouse = TRIM(dw_ip.GetItemString(1, 'depot_no'))
scvcod1 = TRIM(dw_ip.GetItemString(1, 'cvcod1'))
scvcod2 = TRIM(dw_ip.GetItemString(1, 'cvcod2'))
sitnbr1 = TRIM(dw_ip.GetItemString(1, 'sitnbr'))
sitnbr2 = TRIM(dw_ip.GetItemString(1, 'eitnbr'))
sempno  = TRIM(dw_ip.GetItemString(1, 'empno'))
ls_porgu = TRIM(dw_ip.GetItemString(1, 'porgu'))

sGubun = dw_ip.GetItemString(1, "gubun")

if (IsNull(cod1) or cod1 = "")  then cod1 = "10000101"
if (IsNull(cod2) or cod2 = "")  then cod2 = "99991231"
if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = "."
if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = "ZZZZZZZZZZ"
if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = "."
if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = "ZZZZZZZZZZ"
if (IsNull(sempno)  or sempno  = "")  then sempno  = "%"
if (IsNull(sempno)  or sempno  = "")  then sempno  = "%"
if (IsNull(ls_porgu)  or ls_porgu  = "")  then ls_porgu  = "%"

IF IsNull(sHouse) or Trim(sHouse) = ''	THEN
	sHouse = '%'
END IF

IF IsNull(sGubun) or Trim(sGubun) = ''	THEN
	sGubun = '%'
END IF

string bagbn

/* 발주단위 사용여부를 환경설정에서 검색함 */
bagbn	= 'N';
select dataname
  into :bagbn
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
 
if sqlca.sqlcode <> 0 then
	bagbn = 'N'
end if

IF bagbn = 'Y' then 	// 발주단위를 사용
	dw_list.dataobject = 'd_mat_01501_1'
	dw_print.dataobject = 'd_mat_01501_1_p'
else						// 발주단위를 사용안함
	dw_list.dataobject = 'd_mat_01501'
	dw_print.dataobject = 'd_mat_01501_p'
end if

dw_list.Settransobject(sqlca)
dw_print.Settransobject(sqlca)

sToday = f_today()

SetPointer(HourGlass!)

//////////////////////////////////////////////////////////////////////

IF dw_print.Retrieve(gs_sabu, cod1, cod2, sHouse, sGubun, sToday, scvcod1, scvcod2, sitnbr1, sitnbr2, sempno,ls_porgu) <= 0 then
	f_message_chk(50,'[입고의뢰일보 현황]')
	dw_list.Reset()
	Return -1
END IF

cod1 = left(cod1,4) + '/' + mid(cod1,5,2) + '/' + right(cod1,2)
cod2 = left(cod2,4) + '/' + mid(cod2,5,2) + '/' + right(cod2,2)
dw_print.Object.st_date.text = cod1 + ' - ' + cod2

dw_print.ShareData(dw_list)

Return 1

end function

on w_mat_01500.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_mat_01500.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 1, Left(is_today, 6) + '01')
dw_ip.SetItem(1, 2, is_today )
//sle_msg.text = '담당자는 구매관련 입고자료 조회시에만 입력하십시요'

//사업장
f_mod_saupj(dw_ip, 'porgu' )
//입고창고 
f_child_saupj(dw_ip, 'depot_no', gs_saupj )
//구매담당자
f_child_saupj(dw_ip, 'empno', gs_saupj )
end event

event open;call super::open;PostEvent('ue_open') 
end event

event activate;call super::activate;w_mdi_frame.uo_toolbarstrip.of_SetEnabled("엑셀변환(&E)", false) //// 엑셀다운
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
end event

type dw_list from w_standard_print`dw_list within w_mat_01500
integer y = 420
integer width = 4549
integer height = 1952
string dataobject = "d_mat_01501"
end type

type cb_print from w_standard_print`cb_print within w_mat_01500
end type

type cb_excel from w_standard_print`cb_excel within w_mat_01500
end type

type cb_preview from w_standard_print`cb_preview within w_mat_01500
end type

type cb_1 from w_standard_print`cb_1 within w_mat_01500
end type

type dw_print from w_standard_print`dw_print within w_mat_01500
integer x = 3941
integer y = 184
string dataobject = "d_mat_01501_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_01500
integer y = 56
integer width = 4549
integer height = 296
string dataobject = "d_mat_01500"
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

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2, snull
integer i_rtn


s_cod = Trim(this.GetText()) 

setnull(snull)

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "cvcod1" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)
	this.SetItem(1,"cvnam1",s_nam1)
	If Trim(This.GetItemString(1, 'cvcod2')) = '' OR IsNull(This.GetItemString(1, 'cvcod2')) Then
		This.SetItem(1, 'cvcod2', s_cod)
		This.SetItem(1, 'cvnam2', s_nam1)
	End If
	return i_rtn
elseif this.GetColumnName() = "cvcod2" then
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)
	this.SetItem(1,"cvnam2",s_nam1)
	return i_rtn
elseif this.GetColumnName() = "sitnbr" then
	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	If Trim(This.GetItemString(1, 'eitnbr')) = '' OR IsNull(This.GetItemString(1, 'eitnbr')) Then
		This.SetItem(1, 'eitnbr', s_cod)
		This.SetItem(1, 'eitdsc', s_nam1)
	End If
	return i_rtn
elseif this.GetColumnName() = "eitnbr" then
	i_rtn = f_get_name2("품번","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	this.object.eitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "sitdsc" then
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "eitdsc" then
	s_nam1 = s_cod	
	i_rtn = f_get_name2("품명","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	this.object.eitdsc[1] = s_nam1
	return i_rtn	
elseif this.GetColumnName() = "porgu" then
	s_cod	 = this.GetText()
	//사업장
	f_mod_saupj(dw_ip, 'porgu' )
	//입고창고 
	f_child_saupj(dw_ip, 'depot_no',s_cod	)
	//구매담당자
	f_child_saupj(dw_ip, 'empno',s_cod	 )
end if
	


end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun ='1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return
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

type r_1 from w_standard_print`r_1 within w_mat_01500
integer y = 416
integer width = 4557
integer height = 1960
end type

type r_2 from w_standard_print`r_2 within w_mat_01500
integer width = 4557
integer height = 304
end type

type pb_1 from u_pic_cal within w_mat_01500
integer x = 741
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_mat_01500
integer x = 1161
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

