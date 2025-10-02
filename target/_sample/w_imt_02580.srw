$PBExportHeader$w_imt_02580.srw
$PBExportComments$** �԰�����Ȳ
forward
global type w_imt_02580 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_02580
end type
type pb_2 from u_pic_cal within w_imt_02580
end type
end forward

global type w_imt_02580 from w_standard_print
string title = "�԰�����Ȳ"
boolean maxbox = true
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_02580 w_imt_02580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, emp1, emp2, cvcod1, cvcod2, balgu, sfitnbr, stitnbr, ssort, sSaupj 

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
emp1 = trim(dw_ip.object.emp1[1])
emp2 = trim(dw_ip.object.emp2[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
sfitnbr = trim(dw_ip.object.fitnbr[1])
stitnbr = trim(dw_ip.object.titnbr[1])
ssort = trim(dw_ip.object.sort[1])
balgu = trim(dw_ip.object.balgu[1])
sSaupj = dw_ip.object.saupj[1]

if (IsNull(sdate) or sdate = "") then sdate = "11110101"
if (IsNull(edate) or edate = "") then edate = "99991231"
if (IsNull(emp1) or emp1 = "") then emp1 = "."
if (IsNull(emp2) or emp2 = "") then emp2 = "zzzzzz"
if (IsNull(cvcod1) or cvcod1 = "") then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "") then cvcod2 = "zzzzzz"
if (IsNull(sfitnbr) or sfitnbr = "") then sfitnbr = "."
if (IsNull(stitnbr) or stitnbr = "") then stitnbr = "zzzzzzzzzzzzzzz"
if (IsNull(balgu) or balgu = "") then balgu = "%"


string bagbn

/* ���ִ��� ��뿩�θ� ȯ�漳������ �˻��� */
bagbn	= 'N';
select dataname
  into :bagbn
  from syscnfg
 where sysgu = 'Y' and serial = 12 and lineno = '3';
 
if sqlca.sqlcode <> 0 then
	bagbn = 'N'
end if

IF bagbn = 'Y' then	// ���ִ����� ����ϴ� ���
	dw_list.DataObject = "d_imt_02580_02_1"
	dw_print.DataObject = "d_imt_02580_02_1_p"
else						// ���ִ����� �����ϴ� ���
	dw_list.DataObject = "d_imt_02580_02"
	dw_print.DataObject = "d_imt_02580_02_p"
end if
dw_print.SetTransObject(SQLCA)

if ssort  = '1' then 
	dw_print.SetSort("bal_empno A, pomast_cvcod A, poblkt_baljpno A, poblkt_balseq A")
elseif ssort  = '2' then 	
	dw_print.SetSort("bal_empno A, pomast_cvcod A, poblkt_itnbr A")
else
	dw_print.SetSort("bal_empno A, pomast_cvcod A, itemas_itdsc A, itemas_ispec A")
end if
dw_print.Sort()
dw_print.GroupCalc()

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
if dw_print.Retrieve(gs_sabu, sdate, edate, emp1, emp2, cvcod1, cvcod2, balgu, &
                    sfitnbr, stitnbr, sSaupj) <= 0 then
	f_message_chk(50,'[�԰� ���� ��Ȳ]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1
end function

on w_imt_02580.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_02580.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;/* �ΰ� ����� */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
	End if
End If


///* ������ & ������ & ���ұ��� Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,2) = '01'")
//	state_child2.setFilter("Mid(rfgub,1,2) = '01'")
//	state_child1.Filter()
//	state_child2.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child2.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child1.Filter()
//	state_child2.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//�����1
rtncode 	= dw_ip.GetChild('emp1', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - �����1")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)

//�����2
rtncode 	= dw_ip.GetChild('emp2', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - �����2")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)
end event

type dw_list from w_standard_print`dw_list within w_imt_02580
integer y = 528
integer height = 1964
string dataobject = "d_imt_02580_02_1"
end type

type cb_print from w_standard_print`cb_print within w_imt_02580
integer x = 2798
integer y = 860
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02580
integer x = 2130
integer y = 860
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02580
integer x = 2464
integer y = 860
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02580
integer x = 1797
integer y = 860
end type

type dw_print from w_standard_print`dw_print within w_imt_02580
string dataobject = "d_imt_02580_02_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02580
integer y = 56
integer height = 448
string dataobject = "d_imt_02580_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[��������]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[������]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "sort" then
	if s_cod  = '1' then 
		dw_list.SetSort("bal_empno A, pomast_cvcod A, poblkt_baljpno A, poblkt_balseq A")
	elseif s_cod  = '2' then 	
		dw_list.SetSort("bal_empno A, pomast_cvcod A, poblkt_itnbr A")
	else
		dw_list.SetSort("bal_empno A, pomast_cvcod A, itemas_itdsc A, itemas_ispec A")
	end if
	dw_list.Sort()
	dw_list.GroupCalc()
elseif this.getcolumnname() = 'fitnbr' then //ǰ��(FROM)  
	i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"fitnbr",s_cod)		
	this.setitem(1,"fitdsc",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'fitdsc' then //ǰ��(FROM)  
	s_nam1 = s_cod
	i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"fitnbr",s_cod)		
	this.setitem(1,"fitdsc",s_nam1)
	return i_rtn	
elseif this.getcolumnname() = 'titnbr' then //ǰ��(TO)  
	i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"titnbr",s_cod)		
	this.setitem(1,"titdsc",s_nam1)
	return i_rtn	
elseif this.getcolumnname() = 'titdsc' then //ǰ��(FROM)  
	s_nam1 = s_cod
	i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"titnbr",s_cod)		
	this.setitem(1,"titdsc",s_nam1)
	return i_rtn		
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "cvcod1" then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.cvcod1[1] = gs_code
elseif this.GetColumnName() = "cvcod2" then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	this.object.cvcod2[1] = gs_code
ELSEIF this.GetcolumnName() ="fitnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"fitnbr",gs_code)
ELSEIF this.GetcolumnName() ="titnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"titnbr",gs_code)
end if



end event

type r_1 from w_standard_print`r_1 within w_imt_02580
integer y = 524
end type

type r_2 from w_standard_print`r_2 within w_imt_02580
integer height = 456
end type

type pb_1 from u_pic_cal within w_imt_02580
integer x = 704
integer y = 244
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_02580
integer x = 1157
integer y = 244
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

