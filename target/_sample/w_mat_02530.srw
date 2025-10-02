$PBExportHeader$w_mat_02530.srw
$PBExportComments$** 출고현황-[출고처별]
forward
global type w_mat_02530 from w_standard_print
end type
type pb_1 from u_pic_cal within w_mat_02530
end type
type pb_2 from u_pic_cal within w_mat_02530
end type
type cbx_1 from checkbox within w_mat_02530
end type
type cbx_2 from checkbox within w_mat_02530
end type
type cbx_3 from checkbox within w_mat_02530
end type
type cbx_4 from checkbox within w_mat_02530
end type
type cbx_5 from checkbox within w_mat_02530
end type
type cbx_7 from checkbox within w_mat_02530
end type
type cbx_8 from checkbox within w_mat_02530
end type
type cbx_9 from checkbox within w_mat_02530
end type
type rb_all from radiobutton within w_mat_02530
end type
type rb_maip from radiobutton within w_mat_02530
end type
end forward

global type w_mat_02530 from w_standard_print
integer width = 4640
integer height = 2472
string title = "출고 현황-[출고처별]"
pb_1 pb_1
pb_2 pb_2
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_7 cbx_7
cbx_8 cbx_8
cbx_9 cbx_9
rb_all rb_all
rb_maip rb_maip
end type
global w_mat_02530 w_mat_02530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, iogbn, cvcod1, cvcod2, depot, sitnbr1, sitnbr2, ls_engyn, tx_name, sittyp, eittyp

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
sittyp   = trim(dw_ip.object.sittyp[1])
eittyp   = trim(dw_ip.object.eittyp[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(iogbn) or iogbn = "")  then iogbn = '%' 
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
if (IsNull(sitnbr1) or sitnbr1 = "")  then sitnbr1 = "."
if (IsNull(sitnbr2) or sitnbr2 = "")  then sitnbr2 = "ZZZZZZ"
if (IsNull(sittyp) or sittyp = "")  then sittyp = "."
if (IsNull(eittyp) or eittyp = "")  then eittyp = "ZZZZZZZ"

If Trim(depot) = '' OR IsNull(depot) Then
	MessageBox('기준 창고 확인', '기준 창고는 필수 선택 입니다.')
	Return -1
End If

String ls_ittyp

If cbx_1.Checked = True Then
	ls_ittyp = "'1'"
End If

If cbx_2.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'2'"
	Else
		ls_ittyp = ls_ittyp + ", '2'"
	End If
End If

If cbx_3.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'3'"
	Else
		ls_ittyp = ls_ittyp + ", '3'"
	End If
End If

If cbx_4.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'4'"
	Else
		ls_ittyp = ls_ittyp + ", '4'"
	End If
End If

If cbx_5.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'5'"
	Else
		ls_ittyp = ls_ittyp + ", '5'"
	End If
End If

If cbx_7.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'7'"
	Else
		ls_ittyp = ls_ittyp + ", '7'"
	End If
End If

If cbx_8.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'8'"
	Else
		ls_ittyp = ls_ittyp + ", '8'"
	End If
End If

If cbx_9.Checked = True Then
	If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
		ls_ittyp = "'9'"
	Else
		ls_ittyp = ls_ittyp + ", '9'"
	End If
End If

String ls_fil

If rb_maip.Checked = True Then
	ls_fil = "iomatrix_maipgu = 'N' and iomatrix_salegu = 'Y' and cvgu = '1'"
End If

If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
Else
	If rb_maip.Checked = True Then
		ls_fil = ls_fil +  " and itemas_ittyp in (" + ls_ittyp + ")"
	Else
		ls_fil = "itemas_ittyp in (" + ls_ittyp + ")"
	End If
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(depot, sdate, edate, iogbn, sitnbr1, sitnbr2, cvcod1, cvcod2, ls_engyn)

dw_list.SetFilter(ls_fil)
dw_list.Filter()

dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(iogbn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then 
	tx_name = '출고 현황-[출고처별]'
	dw_print.Modify("title_tx.text = '"+tx_name+"'")
Else
	dw_print.Modify("title_tx.text = '"+tx_name+" 현황'")
End If

Return 1




end function

on w_mat_02530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_7=create cbx_7
this.cbx_8=create cbx_8
this.cbx_9=create cbx_9
this.rb_all=create rb_all
this.rb_maip=create rb_maip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.cbx_2
this.Control[iCurrent+5]=this.cbx_3
this.Control[iCurrent+6]=this.cbx_4
this.Control[iCurrent+7]=this.cbx_5
this.Control[iCurrent+8]=this.cbx_7
this.Control[iCurrent+9]=this.cbx_8
this.Control[iCurrent+10]=this.cbx_9
this.Control[iCurrent+11]=this.rb_all
this.Control[iCurrent+12]=this.rb_maip
end on

on w_mat_02530.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_7)
destroy(this.cbx_8)
destroy(this.cbx_9)
destroy(this.rb_all)
destroy(this.rb_maip)
end on

event open;call super::open;dw_ip.setitem(1, "sdate", left(f_today(), 6)+'01')
dw_ip.setitem(1, "edate", f_today())
end event

event ue_open;call super::ue_open;//창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)
end event

type dw_list from w_standard_print`dw_list within w_mat_02530
integer y = 468
integer width = 4539
integer height = 1872
string dataobject = "d_mat_02530_02_1"
end type

type cb_print from w_standard_print`cb_print within w_mat_02530
end type

type cb_excel from w_standard_print`cb_excel within w_mat_02530
end type

type cb_preview from w_standard_print`cb_preview within w_mat_02530
end type

type cb_1 from w_standard_print`cb_1 within w_mat_02530
end type

type dw_print from w_standard_print`dw_print within w_mat_02530
integer x = 4000
integer y = 224
string dataobject = "d_mat_02530_02_p_1"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02530
integer y = 24
integer width = 4539
integer height = 412
string dataobject = "d_mat_02530_01"
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
	this.SetItem(1,"cvcod2",s_cod)
	this.SetItem(1,"cvnam2",s_nam1)
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
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
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

type r_1 from w_standard_print`r_1 within w_mat_02530
integer y = 464
integer width = 4553
integer height = 1880
end type

type r_2 from w_standard_print`r_2 within w_mat_02530
integer y = 20
integer width = 4549
integer height = 420
end type

type pb_1 from u_pic_cal within w_mat_02530
integer x = 622
integer y = 72
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_mat_02530
integer x = 1079
integer y = 72
integer taborder = 60
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type cbx_1 from checkbox within w_mat_02530
integer x = 329
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "완제품"
end type

type cbx_2 from checkbox within w_mat_02530
integer x = 626
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "반제품"
end type

type cbx_3 from checkbox within w_mat_02530
integer x = 923
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "원자재"
end type

type cbx_4 from checkbox within w_mat_02530
integer x = 1221
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "부자재"
end type

type cbx_5 from checkbox within w_mat_02530
integer x = 1518
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "저장품"
end type

type cbx_7 from checkbox within w_mat_02530
integer x = 1815
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "상품"
end type

type cbx_8 from checkbox within w_mat_02530
integer x = 2112
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "가상품"
end type

type cbx_9 from checkbox within w_mat_02530
integer x = 2409
integer y = 312
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "기타"
end type

type rb_all from radiobutton within w_mat_02530
integer x = 2949
integer y = 308
integer width = 338
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "전체"
boolean checked = true
end type

type rb_maip from radiobutton within w_mat_02530
integer x = 3296
integer y = 308
integer width = 338
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "매출기준"
end type

