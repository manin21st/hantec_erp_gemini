$PBExportHeader$w_mat_02520.srw
$PBExportComments$** 출고현황-[출고일자별]
forward
global type w_mat_02520 from w_standard_print
end type
type pb_1 from u_pic_cal within w_mat_02520
end type
type pb_2 from u_pic_cal within w_mat_02520
end type
end forward

global type w_mat_02520 from w_standard_print
integer width = 4667
integer height = 2488
string title = "출고 현황-[출고일자별]"
pb_1 pb_1
pb_2 pb_2
end type
global w_mat_02520 w_mat_02520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, iogbn, depot, scvcod1, scvcod2, sitnbr1, sitnbr2, ls_porgu, ls_engyn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
iogbn = trim(dw_ip.object.iogbn[1])
depot = trim(dw_ip.object.depot[1])

scvcod1 = trim(dw_ip.object.cvcod1[1])
scvcod2 = trim(dw_ip.object.cvcod2[1])
sitnbr1 = trim(dw_ip.object.sitnbr[1])
sitnbr2 = trim(dw_ip.object.eitnbr[1])
ls_porgu = trim(dw_ip.object.porgu[1])
ls_engyn = trim(dw_ip.object.eng_yn[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(iogbn) or iogbn = "")  then iogbn = '%' 

if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = '.' 
if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = 'ZZZZZZ' 
if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = '.' 
if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = 'ZZZZZZ' 
if (IsNull(ls_porgu) or ls_porgu = "")  then ls_porgu = '%' 

if (IsNull(depot) or depot = "")  then 
	f_message_chk(30, "[기준창고]")
	dw_ip.SetColumn("depot")
	dw_ip.Setfocus()
	return -1
end if

/* 사급 자재 유무 Filtering */
if depot = 'Z03' then
	if ls_engyn = "%" then
		dw_print.SetFilter("")
		dw_print.Filter( )
	elseif ls_engyn = "N" then  // 일반 자재
		dw_print.SetFilter(" itemas_eng_yn = 'N' ")
		dw_print.Filter( )
	elseif ls_engyn = "Y" then  // 사급 자재
		dw_print.SetFilter(" itemas_eng_yn = 'Y' ")
		dw_print.Filter( )
	end if	
	
else
	dw_print.SetFilter("")
	dw_print.Filter( )
end if
	
IF dw_print.Retrieve(gs_sabu, sdate, edate, iogbn, depot, scvcod1, scvcod2, sitnbr1, sitnbr2, ls_porgu) <= 0 then
	f_message_chk(50,'[출고현황-[출고일자별]]')
	dw_list.Reset()
	dw_print.insertrow(0)
END IF

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

dw_print.ShareData(dw_list)

return 1
end function

on w_mat_02520.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_mat_02520.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_open;call super::ue_open;dw_ip.setitem(1, "sdate", left(f_today(), 6)+'01')
dw_ip.setitem(1, "edate", f_today())

////사업장
//f_mod_saupj(dw_ip, 'porgu' )

dw_ip.SetItem(1, 'porgu', gs_saupj)

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)
end event

type dw_list from w_standard_print`dw_list within w_mat_02520
integer y = 388
integer width = 4549
integer height = 1936
string dataobject = "d_mat_02520_02"
end type

type cb_print from w_standard_print`cb_print within w_mat_02520
end type

type cb_excel from w_standard_print`cb_excel within w_mat_02520
end type

type cb_preview from w_standard_print`cb_preview within w_mat_02520
end type

type cb_1 from w_standard_print`cb_1 within w_mat_02520
end type

type dw_print from w_standard_print`dw_print within w_mat_02520
integer x = 3753
integer y = 48
string dataobject = "d_mat_02520_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02520
integer y = 52
integer width = 4549
integer height = 292
string dataobject = "d_mat_02520_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText()) 

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
	this.object.eitdsr[1] = s_nam1
	return i_rtn	
elseif this.GetColumnName() = "porgu" then
	s_cod = this.GetText()
//	//사업장
//	f_mod_saupj(dw_ip, 'porgu' )
	//입고창고 
	f_child_saupj(dw_ip, 'depot', s_cod)
end if


end event

event dw_ip::itemerror;return 1
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

type r_1 from w_standard_print`r_1 within w_mat_02520
integer y = 384
integer width = 4558
integer height = 1944
end type

type r_2 from w_standard_print`r_2 within w_mat_02520
integer y = 48
integer width = 4558
integer height = 300
end type

type pb_1 from u_pic_cal within w_mat_02520
integer x = 677
integer y = 148
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

type pb_2 from u_pic_cal within w_mat_02520
integer x = 1147
integer y = 148
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

