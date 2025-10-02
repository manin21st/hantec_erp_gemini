$PBExportHeader$w_mat_01530.srw
$PBExportComments$** 입고 대기/승인 현황
forward
global type w_mat_01530 from w_standard_print
end type
type pb_1 from u_pic_cal within w_mat_01530
end type
type pb_2 from u_pic_cal within w_mat_01530
end type
end forward

global type w_mat_01530 from w_standard_print
integer width = 4599
string title = "입고 대기/승인 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_mat_01530 w_mat_01530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, sgub, depot, spdtgu, strgbn 

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
depot = trim(dw_ip.object.depot[1])
sgub  = trim(dw_ip.object.gub[1])
spdtgu = trim(dw_ip.object.pdtgu[1])
strgbn = trim(dw_ip.object.trgbn[1])

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(depot) or depot = "")  then depot = '%'

dw_print.setredraw(false)
if sgub = '1' then 
	dw_list.DataObject ="d_mat_01530_1" 
	dw_print.DataObject ="d_mat_01530_1_p" 
	dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
	
	dw_print.SetFilter("")
   if NOT (spdtgu = '' or isnull(spdtgu)) then 
		if strgbn = '1' then
			dw_print.setfilter("pdtgu = '"+ spdtgu + "' imhist_opseq = '9999'")
		else
			dw_print.setfilter("pdtgu = '"+ spdtgu + "' imhist_opseq <> '9999'")			
		end if
	Else
		if strgbn = '1' then
			dw_print.setfilter("imhist_opseq = '9999'")
		else
			dw_print.setfilter("imhist_opseq <> '9999'")			
		end if
	end if
	dw_print.filter()
	
   dw_print.setredraw(true)
	
	//dw_list.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	if dw_print.Retrieve(gs_sabu, sdate, edate, depot, strgbn) <= 0 then
		f_message_chk(50,'[입고대기현황]')
		dw_ip.Setfocus()
		return -1
	end if
elseif sgub = '2' then
	dw_list.DataObject ="d_mat_01530_2" 
	dw_print.DataObject ="d_mat_01530_2_p" 
	dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)  
	
	dw_print.SetFilter("")
   if NOT (spdtgu = '' or isnull(spdtgu)) then 
		if strgbn = '1' then
			dw_print.setfilter("pdtgu = '"+ spdtgu + "' imhist_opseq = '9999'")
		else
			dw_print.setfilter("pdtgu = '"+ spdtgu + "' imhist_opseq <> '9999'")			
		end if		
	else
		if strgbn = '1' then
			dw_print.setfilter("imhist_opseq = '9999'")
		else
			dw_print.setfilter("imhist_opseq <> '9999'")			
		end if		
	end if

	dw_print.filter()
	//dw_list.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	dw_print.setredraw(true)
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, depot, strgbn) <= 0 then
		f_message_chk(50,'[입고승인현황]')
		dw_ip.Setfocus()
		return -1
	end if
else
	dw_list.DataObject ="d_mat_01530_0" 
	dw_print.DataObject ="d_mat_01530_0_p" 
	dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA) 
	
	dw_print.SetFilter("")
   if NOT (spdtgu = '' or isnull(spdtgu)) then 
		if strgbn = '1' then
			dw_print.setfilter("pdtgu = '"+ spdtgu + "' imhist_opseq = '9999'")
		else
			dw_print.setfilter("pdtgu = '"+ spdtgu + "' imhist_opseq <> '9999'")			
		end if
	else
		if strgbn = '1' then
			dw_print.setfilter("imhist_opseq = '9999'")
		else
			dw_print.setfilter("imhist_opseq <> '9999'")			
		end if		
	end if
	dw_print.filter()
	//dw_list.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	dw_print.setredraw(true)
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, depot, strgbn) <= 0 then
		f_message_chk(50,'[입고 대기/승인 현황]')
		dw_ip.Setfocus()
		return -1
	end if
end if
    
	dw_print.sharedata(dw_list) 
return 1
end function

on w_mat_01530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_mat_01530.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_open;call super::ue_open;//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj )
//생산팀
f_child_saupj(dw_ip, 'pdtgu', gs_saupj )
end event

type dw_list from w_standard_print`dw_list within w_mat_01530
integer y = 372
integer width = 4457
integer height = 1960
string dataobject = "d_mat_01530_0"
end type

type cb_print from w_standard_print`cb_print within w_mat_01530
integer x = 3365
integer y = 560
end type

type cb_excel from w_standard_print`cb_excel within w_mat_01530
integer x = 2697
integer y = 560
end type

type cb_preview from w_standard_print`cb_preview within w_mat_01530
integer x = 3031
integer y = 560
end type

type cb_1 from w_standard_print`cb_1 within w_mat_01530
integer x = 2363
integer y = 560
end type

type dw_print from w_standard_print`dw_print within w_mat_01530
string dataobject = "d_mat_01530_0_P"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_01530
integer y = 52
integer width = 4457
integer height = 284
string dataobject = "d_mat_01530_a"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.SetItem(1,"sdate","")
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.SetItem(1,"edate","")
		return 1
	end if
//elseif this.GetColumnName() = "buse" then
//	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
//	this.SetItem(1,"buse",s_cod)
//	this.SetItem(1,"bunm",s_nam2)
//	return i_rtn
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;//SetNull(gs_code)
//SetNull(gs_codename)
//
//IF	this.getcolumnname() = "buse"	THEN		
//	open(w_vndmst_4_popup)
//	if isnull(gs_code) or gs_code = "" then 	return
//	this.SetItem(1, "buse", gs_code)
//	this.SetItem(1, "bunm", gs_codename)
//END IF
end event

type r_1 from w_standard_print`r_1 within w_mat_01530
integer y = 368
integer width = 4466
integer height = 1968
end type

type r_2 from w_standard_print`r_2 within w_mat_01530
integer y = 48
integer width = 4466
integer height = 292
end type

type pb_1 from u_pic_cal within w_mat_01530
integer x = 754
integer y = 152
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

type pb_2 from u_pic_cal within w_mat_01530
integer x = 1198
integer y = 152
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

