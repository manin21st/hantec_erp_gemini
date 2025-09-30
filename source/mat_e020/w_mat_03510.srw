$PBExportHeader$w_mat_03510.srw
$PBExportComments$** 분류별 재고금액 현황
forward
global type w_mat_03510 from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_03510
end type
end forward

global type w_mat_03510 from w_standard_print
string title = "분류별 재고금액 현황"
rr_1 rr_1
end type
global w_mat_03510 w_mat_03510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_depot, s_year, s_month, sgub1, sgub2, smagam

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_depot = dw_ip.GetItemString(1,"depot")
s_year  = trim(dw_ip.GetItemString(1,"syear"))
s_month = trim(dw_ip.GetItemString(1,"month"))
sgub1   = dw_ip.GetItemString(1,"sgub1")
sgub2   = dw_ip.GetItemString(1,"sgub2")

if s_year = '' or isnull(s_year) then
	f_message_chk(30,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	return -1
end if
if s_depot = '' or isnull(s_depot) then
	f_message_chk(30,'[창고]')
	dw_ip.setcolumn('depot')
	dw_ip.setfocus()
	return -1
end if

if sgub1 = '1' then 
	if sgub2 = '1' then 
   	dw_list.DataObject ="d_mat_03510_3" 
   	dw_print.DataObject ="d_mat_03510_3_p" 
	elseif sgub2 = '2' then 
   	dw_list.DataObject ="d_mat_03510_2" 
   	dw_print.DataObject ="d_mat_03510_2_p" 
	else
   	dw_list.DataObject ="d_mat_03510_1" 
   	dw_print.DataObject ="d_mat_03510_1_p" 
	end if	
elseif sgub1 = '2' then 
	if sgub2 = '1' then 
   	dw_list.DataObject ="d_mat_03510_6" 
   	dw_print.DataObject ="d_mat_03510_6_p" 
	elseif sgub2 = '2' then 
   	dw_list.DataObject ="d_mat_03510_5" 
   	dw_print.DataObject ="d_mat_03510_5_p" 
	else	
   	dw_list.DataObject ="d_mat_03510_4" 
   	dw_print.DataObject ="d_mat_03510_4_p" 
	end if
else
	if sgub2 = '1' then 
   	dw_list.DataObject ="d_mat_03510_12" 
   	dw_print.DataObject ="d_mat_03510_12" 
	elseif sgub2 = '2' then 
   	dw_list.DataObject ="d_mat_03510_11" 
   	dw_print.DataObject ="d_mat_03510_11" 
	else	
   	dw_list.DataObject ="d_mat_03510_10" 
   	dw_print.DataObject ="d_mat_03510_10" 
	end if
	s_year = s_year + s_month
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

// 최종마감년월
select max(jpdat)
  into :smagam
  from junpyo_closing
 where jpgu = 'C0';

//IF dw_list.Retrieve(s_year, s_depot, smagam) < 1 THEN
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(s_year, s_depot, smagam) < 1 THEN
	dw_list.Reset()
//	dw_print.insertrow(0)
	Return -1
END IF

dw_print.ShareData(dw_list)

If sgub1 = '2' Then 
	dw_list.Object.year_1.text = String(Long(s_year) - 4) + '년'
	dw_list.Object.year_2.text = String(Long(s_year) - 3) + '년'
	dw_list.Object.year_3.text = String(Long(s_year) - 2) + '년'
	dw_list.Object.year_4.text = String(Long(s_year) - 1) + '년'
	dw_list.Object.year_5.text = s_year + '년'
//	
	
End If

return 1
end function

on w_mat_03510.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_mat_03510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, 'syear', left(is_today, 4))
end event

event ue_open;call super::ue_open;//창고 
f_child_saupj(dw_ip, 'depot', '%')
end event

type p_xls from w_standard_print`p_xls within w_mat_03510
end type

type p_sort from w_standard_print`p_sort within w_mat_03510
end type

type p_preview from w_standard_print`p_preview within w_mat_03510
integer y = 36
end type

type p_exit from w_standard_print`p_exit within w_mat_03510
integer y = 36
end type

type p_print from w_standard_print`p_print within w_mat_03510
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03510
integer y = 36
end type











type dw_print from w_standard_print`dw_print within w_mat_03510
string dataobject = "d_mat_03510_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03510
integer y = 36
integer width = 2857
integer height = 260
string dataobject = "d_mat_03510_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;//setnull(gs_code)
//setnull(gs_codename)
//
//if this.GetColumnName() = 'fr_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"fr_itnbr",gs_code)
//	this.TriggerEvent(ItemChanged!)
//elseif this.GetColumnName() = 'to_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"to_itnbr",gs_code)
//	this.TriggerEvent(ItemChanged!)
//end if	
//
end event

event dw_ip::ue_key;//setnull(gs_code)
//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//ELSEIF keydown(keyF2!) THEN
//	IF This.GetColumnName() = "fr_itnbr" Then
//		open(w_itemas_popup2)
//		if isnull(gs_code) or gs_code = "" then return
//		
//		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
//		this.TriggerEvent(ItemChanged!)
//	ELSEIF This.GetColumnName() = "to_itnbr" Then
//		open(w_itemas_popup2)
//		if isnull(gs_code) or gs_code = "" then return
//		
//		this.SetItem(this.getrow(),"to_itnbr",gs_code)
//		this.TriggerEvent(ItemChanged!)
//	End If
//END IF
//
end event

event dw_ip::itemchanged;call super::itemchanged;String	sCode, sName, sNull

SetNull(sNull)
if this.GetColumnName() = 'sgub1' then
	sCode = trim(this.GetText())
	
	if sCode = '3' then
		this.SetItem(1,'month',Mid(f_today(),5,2))
	end if
elseif this.GetColumnName() = 'month' then
	sCode = trim(this.GetText())
	sName = trim(this.GetItemString(1,'syear'))

	if f_datechk(sName + sCode + '01') = -1 then
		MessageBox("확인","유효한 년월을 지정하세요.")
		this.SetItem(1,'month',sNull)
		return 1
	end if
end if
end event

type dw_list from w_standard_print`dw_list within w_mat_03510
integer x = 50
integer y = 316
integer width = 4539
integer height = 1996
string dataobject = "d_mat_03510_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_mat_03510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 312
integer width = 4562
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

