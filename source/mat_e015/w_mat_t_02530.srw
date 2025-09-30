$PBExportHeader$w_mat_t_02530.srw
$PBExportComments$** �����Ȳ-[���ó��]
forward
global type w_mat_t_02530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mat_t_02530
end type
type pb_2 from u_pb_cal within w_mat_t_02530
end type
type rr_1 from roundrectangle within w_mat_t_02530
end type
end forward

global type w_mat_t_02530 from w_standard_print
string title = "���� ��� ��Ȳ-[���ó��]"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_mat_t_02530 w_mat_t_02530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, iogbn, cvcod1, cvcod2, depot, sitnbr1, sitnbr2, ls_engyn

if dw_ip.AcceptText() = -1 then
   dw_ip.SetFocus()
	return -1
end if	
sdate    = trim(dw_ip.object.sdate[1])
edate    = trim(dw_ip.object.edate[1])
iogbn    = trim(dw_ip.object.iogbn[1])
cvcod1   = trim(dw_ip.object.cvcod1[1])
cvcod2   = trim(dw_ip.object.cvcod2[1])
sitnbr1  = trim(dw_ip.object.sitnbr[1])
sitnbr2  = trim(dw_ip.object.eitnbr[1])
depot    = trim(dw_ip.object.depot[1])
ls_engyn = trim(dw_ip.object.eng_yn[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(iogbn) or iogbn = "")  then iogbn = '%' 
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = "."
if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = "ZZZZZZ"

if (IsNull(depot) or depot = "")  then 
	f_message_chk(30, "[����â��]")
	dw_ip.SetColumn("depot")
	dw_ip.Setfocus()
	return -1
end if

/* ��� ���� ���� Filtering */
if depot = 'Z03' then
	if ls_engyn = "%" then
		dw_print.SetFilter("")
		dw_print.Filter( )
	elseif ls_engyn = "N" then  // �Ϲ� ����
		dw_print.SetFilter(" itemas_eng_yn = 'N' ")
		dw_print.Filter( )
	elseif ls_engyn = "Y" then  // ��� ����
		dw_print.SetFilter(" itemas_eng_yn = 'Y' ")
		dw_print.Filter( )
	end if	
else
	dw_print.SetFilter("")
	dw_print.Filter( )
end if

IF dw_print.Retrieve(gs_sabu,sdate, edate, iogbn, cvcod1, cvcod2, depot, sitnbr1, sitnbr2) <= 0 then
	f_message_chk(50,'[�����Ȳ-[���ó��]]')
	dw_list.Reset()
	dw_print.insertrow(0)
END IF

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

dw_print.ShareData(dw_list)

return 1
end function

on w_mat_t_02530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_mat_t_02530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", left(f_today(), 6)+'01')
dw_ip.setitem(1, "edate", f_today())
end event

event ue_open;call super::ue_open;//�԰�â�� 
f_child_saupj(dw_ip, 'depot', gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_mat_t_02530
end type

type p_exit from w_standard_print`p_exit within w_mat_t_02530
end type

type p_print from w_standard_print`p_print within w_mat_t_02530
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_t_02530
end type







type st_10 from w_standard_print`st_10 within w_mat_t_02530
end type



type dw_print from w_standard_print`dw_print within w_mat_t_02530
integer x = 4000
integer y = 224
string dataobject = "d_mat_t_02530_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_t_02530
integer x = 37
integer y = 24
integer width = 3767
integer height = 412
string dataobject = "d_mat_t_02530_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText()) 

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[������]")
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
	i_rtn = f_get_name2("ǰ��","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "eitnbr" then
	i_rtn = f_get_name2("ǰ��","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	this.object.eitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "sitdsc" then
	s_nam1 = s_cod
	i_rtn = f_get_name2("ǰ��","Y", s_cod, s_nam1, s_nam2)
	this.object.sitnbr[1] = s_cod
	this.object.sitdsc[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "eitdsc" then
	s_nam1 = s_cod	
	i_rtn = f_get_name2("ǰ��","Y", s_cod, s_nam1, s_nam2)
	this.object.eitnbr[1] = s_cod
	this.object.eitdsr[1] = s_nam1
	return i_rtn	
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

type dw_list from w_standard_print`dw_list within w_mat_t_02530
integer x = 50
integer y = 448
integer width = 4539
integer height = 1872
string dataobject = "d_mat_t_02530_02"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mat_t_02530
integer x = 617
integer y = 60
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_t_02530
integer x = 1083
integer y = 60
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_1 from roundrectangle within w_mat_t_02530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 440
integer width = 4567
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

