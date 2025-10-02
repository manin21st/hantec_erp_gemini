$PBExportHeader$w_imt_02610.srw
$PBExportComments$** ��ü ���ǥ/ ������ ��Ȳ/������� ����
forward
global type w_imt_02610 from w_standard_print
end type
type ddlb_dwchoice from dropdownlistbox within w_imt_02610
end type
type pb_1 from u_pic_cal within w_imt_02610
end type
type pb_2 from u_pic_cal within w_imt_02610
end type
end forward

global type w_imt_02610 from w_standard_print
string title = "��ü ���ǥ/������/�����������"
boolean maxbox = true
ddlb_dwchoice ddlb_dwchoice
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_02610 w_imt_02610

forward prototypes
public function integer wf_retrieve_02630 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve_02630 ();String  s_frvndcod, s_tovndcod, s_frdate, s_todate, cvcod1, cvcod2, emp1, emp2
decimal drate

if dw_ip.AcceptText() = -1 then return -1

s_frdate = trim(dw_ip.GetItemString(1, "fr_date"))
s_todate = trim(dw_ip.GetItemString(1, "to_date"))
cvcod1 = trim(dw_ip.GetItemString(1, "cvcod1"))
cvcod2 = trim(dw_ip.GetItemString(1, "cvcod2"))
emp1 = trim(dw_ip.GetItemString(1, "emp1"))
emp2 = trim(dw_ip.GetItemString(1, "emp2"))
if IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
if IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
if IsNull(emp1) or emp1 = "" then emp1 = "."
if IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[��������]')
	dw_ip.Setcolumn('fr_date')
	dw_ip.SetFocus()
	return -1
end if	

//drate = dw_ip.GetItemDecimal(1, "nrate")

IF dw_print.Retrieve(gs_sabu, f_today(), s_frdate,s_todate, drate, cvcod1, cvcod2, emp1, emp2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setcolumn('fr_date')
	dw_ip.Setfocus()
	return -1
end if
dw_print.ShareData(dw_list)
return 1

end function

public function integer wf_retrieve ();long lcnt

// ������������� 630�� call
if ddlb_dwchoice.text = '������� ����' then
	lcnt = wf_retrieve_02630()
	return lcnt
end if


String s_frdate, s_todate
String cvcod1, cvnam1, cvcod2, cvnam2, emp1, emp2

if dw_ip.AcceptText() = -1 then return -1

s_frdate = trim(dw_ip.GetItemString(1, "fr_date"))
s_todate = trim(dw_ip.GetItemString(1, "to_date"))

cvcod1 = trim(dw_ip.GetItemString(1, "cvcod1"))
cvnam1 = trim(dw_ip.GetItemString(1, "cvnam1"))
cvcod2 = trim(dw_ip.GetItemString(1, "cvcod2"))
cvnam2 = trim(dw_ip.GetItemString(1, "cvnam2"))
emp1 = trim(dw_ip.GetItemString(1, "emp1"))
emp2 = trim(dw_ip.GetItemString(1, "emp2"))

IF s_frdate = "" OR IsNull(s_frdate) THEN 
	s_frdate = '10000101'
END IF
IF s_todate = "" OR IsNull(s_todate) THEN 
	s_todate = '99991231'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[��������]')
	dw_ip.Setcolumn('fr_date')
	dw_ip.SetFocus()
	return -1
end if	

IF IsNull(cvcod1) or cvcod1 = "" then cvcod1 = "."
IF IsNull(cvcod2) or cvcod2 = "" then cvcod2 = "ZZZZZZ"
IF IsNull(cvnam1) or cvnam1 = "" then cvnam1 = " "
IF IsNull(cvnam2) or cvnam2 = "" then cvnam2 = " "
IF IsNull(emp1) or emp1 = "" then emp1 = "."
IF IsNull(emp2) or emp2 = "" then emp2 = "ZZZZZZ"

lcnt = 0
if ddlb_dwchoice.text = '��ü���ǥ' then
	dw_print.object.txt_cvnam.text = cvcod1 + " " + cvnam1 + " - " + cvcod2 + " " + cvnam2	
	lcnt =  dw_print.Retrieve(gs_sabu, f_today(), s_frdate,s_todate, cvcod1, cvcod2, emp1, emp2)
elseif ddlb_dwchoice.text = '��ü�� ������ ��Ȳ' then
	lcnt =  dw_print.Retrieve(gs_sabu, s_frdate,s_todate, cvcod1, cvcod2, f_today(), emp1, emp2) 
end if

if lcnt < 1 then
	f_message_chk(50,'')
	dw_ip.Setcolumn('fr_date')
	dw_ip.Setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

return 1

end function

on w_imt_02610.create
int iCurrent
call super::create
this.ddlb_dwchoice=create ddlb_dwchoice
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_dwchoice
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
end on

on w_imt_02610.destroy
call super::destroy
destroy(this.ddlb_dwchoice)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;ddlb_dwchoice.text = '��ü���ǥ'

dw_ip.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_ip.setitem(1, 'to_date', f_today() )

dw_ip.Setfocus()


end event

type dw_list from w_standard_print`dw_list within w_imt_02610
integer y = 380
integer height = 1964
string dataobject = "d_imt_02610_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_02610
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02610
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02610
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02610
end type

type dw_print from w_standard_print`dw_print within w_imt_02610
string dataobject = "d_imt_02610_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02610
integer y = 56
integer height = 284
integer taborder = 20
string dataobject = "d_imt_02610_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2, sdate, snull
integer i_rtn

setnull(snull)
s_cod = trim(this.GetText())

IF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[�������� FROM]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[�������� TO]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1", s_cod)		
   this.setitem(1,"cvnam1", s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod2", s_cod)		
   this.setitem(1,"cvnam2", s_nam1)
	return i_rtn
END IF
return
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return 
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return 
END IF
end event

type r_1 from w_standard_print`r_1 within w_imt_02610
integer y = 376
end type

type r_2 from w_standard_print`r_2 within w_imt_02610
integer height = 292
end type

type ddlb_dwchoice from dropdownlistbox within w_imt_02610
integer x = 2757
integer y = 160
integer width = 667
integer height = 336
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"��ü���ǥ","��ü�� ������ ��Ȳ","������� ����"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//dw_ip.setredraw(false)

Choose case index
		 case 1		// ��ü���ǥ
//				dw_ip.dataobject 	 = 'd_imt_02610_a'
				dw_list.dataobject = 'd_imt_02610_1'
				dw_print.dataobject = 'd_imt_02610_1_p'
		 case 2		// ��ü�� ������ ��Ȳ
//				dw_ip.dataobject 	 = 'd_imt_02620_a'
				dw_list.dataobject = 'd_imt_02620_1'	
				dw_print.dataobject = 'd_imt_02620_1_p'	
		 case 3		// �����������
//				dw_ip.dataobject 	 = 'd_imt_02630_a'
				dw_list.dataobject = 'd_imt_02630_1'
				dw_print.dataobject = 'd_imt_02630_1_p'
End choose
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_print.ShareData(dw_list)

//dw_ip.insertrow(0)
dw_ip.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_ip.setitem(1, 'to_date', f_today() )

dw_list.settransobject(sqlca)
//dw_ip.setredraw(True)

dw_ip.setfocus()

//p_print.Enabled =False
//p_print.PictureName = 'C:\erpman\image\�μ�_d.gif'

//cb_ruler.Enabled = false
//p_preview.enabled = False
//p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
//ddlb_zoom.text = '100'
//cb_ruler.text = '����ON'

end event

type pb_1 from u_pic_cal within w_imt_02610
integer x = 654
integer y = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_02610
integer x = 1143
integer y = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'to_date', gs_code)



end event

