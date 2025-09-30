$PBExportHeader$w_psd3001.srw
$PBExportComments$���Ϻз�ü����
forward
global type w_psd3001 from w_inherite_standard
end type
type dw_list from u_d_select_sort within w_psd3001
end type
type dw_dp from u_key_enter within w_psd3001
end type
type rr_1 from roundrectangle within w_psd3001
end type
end forward

global type w_psd3001 from w_inherite_standard
string title = "File �з�ü����"
string menuname = "m_class"
boolean resizable = false
dw_list dw_list
dw_dp dw_dp
rr_1 rr_1
end type
global w_psd3001 w_psd3001

forward prototypes
public function integer wf_req_chk ()
end prototypes

public function integer wf_req_chk ();int i,j
string ls_lcod, ls_mcod, ls_lnm, ls_mnm, ls_color, ls_date, ls_chk_string
ls_lcod  = '��з� �ڵ�'
ls_mcod  = '�ߺз� �ڵ�'
ls_lnm   = '��η� ��'
ls_mnm   = '�ߺз� ��'
ls_color = '����'
ls_date  = '�������'

for i = 1 to dw_list.RowCount()
	for j = 2 to 7
		ls_chk_string = dw_list.GetItemString(i, j)
		if ls_chk_string = '' or isNull(ls_chk_string) then
			Choose Case j
				Case 2
					messagebox('Ȯ��', ls_lcod + '�� �Է��ϼ���.', Exclamation!)
					dw_list.SetColumn(j)
					dw_list.SetFocus()
				Case 3
					messagebox('Ȯ��', ls_mcod + '�� �Է��ϼ���.', Exclamation!)
					dw_list.SetColumn(j)
					dw_list.SetFocus()
				Case 4
					messagebox('Ȯ��', ls_lnm + '�� �Է��ϼ���.', Exclamation!)
					dw_list.SetColumn(j)
					dw_list.SetFocus()
				Case 5
					messagebox('Ȯ��', ls_mnm + '�� �Է��ϼ���.', Exclamation!)
					dw_list.SetColumn(j)
					dw_list.SetFocus()
				Case 6
					messagebox('Ȯ��', ls_color + '�� �Է��ϼ���.', Exclamation!)
					dw_list.SetColumn(j)
					dw_list.SetFocus()
				Case 7
					messagebox('Ȯ��', ls_date + '�� �Է��ϼ���.', Exclamation!)
					dw_list.SetColumn(j)
					dw_list.SetFocus()
			End Choose
			return -1
		End if
	Next
		
Next

return 1
end function

on w_psd3001.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_class" then this.MenuID = create m_class
this.dw_list=create dw_list
this.dw_dp=create dw_dp
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_dp
this.Control[iCurrent+3]=this.rr_1
end on

on w_psd3001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_dp)
destroy(this.rr_1)
end on

event open;call super::open;dw_dp.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_dp.insertrow(0)
dw_dp.setFocus()
end event

type p_mod from w_inherite_standard`p_mod within w_psd3001
end type

event p_mod::clicked;call super::clicked;if dw_list.AcceptText() = -1 then return
if wf_req_chk() = -1 then return 

string ls_code,ls_gbn
long i
ls_code = dw_dp.getitemstring(dw_dp.getrow(),'dept')

for i=1 to dw_list.rowcount()
	ls_gbn  = dw_list.getitemstring(i,'lgbn') + &
	          dw_list.getitemstring(i,'mgbn')
   dw_list.setitem(i,'lmgbn',ls_gbn)
next

dw_list.setitem(dw_list.getrow(),'deptcode',ls_code)

if dw_list.update() <> 1 then
	messagebox('Ȯ��','���� ����...!',stopsign!)
	return
else
	sle_msg.text = '���� �Ϸ�...!'
end if
end event

type p_del from w_inherite_standard`p_del within w_psd3001
end type

event p_del::clicked;call super::clicked;if dw_list.rowcount() < 1 then 
	messagebox('Ȯ��','������ ������ �����ϴ�.',exclamation!)
	return
end if

long row,chk
string ls_code,ls_ln,ls_mn

chk = messagebox('Ȯ��','�����Ͻ� �׸��� �����Ͻðڽ��ϱ�?',exclamation!,okcancel!,2)

if chk = 1 then
	row = dw_list.getrow()
	ls_code = dw_list.getitemstring(row,'deptcode')
	ls_ln   = dw_list.getitemstring(row,'lgbn')
	ls_mn   = dw_list.getitemstring(row,'mgbn')
	
	delete from p8_filesyscode
	 where deptcode = :ls_code 
	   and lgbn     = :ls_ln
		and mgbn     = :ls_mn;
		
   commit;
	sle_msg.text = '���� �Ϸ�...!'
	p_inq.TriggerEvent(Clicked!)
else
	return
end if
end event

type p_inq from w_inherite_standard`p_inq within w_psd3001
integer x = 3515
end type

event p_inq::clicked;call super::clicked;if dw_list.AcceptText() = -1 then return

string ls_code

ls_code = dw_dp.getitemstring(dw_dp.getrow(),'dept')
dw_list.retrieve(ls_code)
end event

type p_print from w_inherite_standard`p_print within w_psd3001
boolean visible = false
integer x = 357
integer y = 2472
boolean enabled = false
end type

type p_can from w_inherite_standard`p_can within w_psd3001
end type

event p_can::clicked;call super::clicked;dw_list.reset()
p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_standard`p_exit within w_psd3001
end type

type p_ins from w_inherite_standard`p_ins within w_psd3001
integer x = 3689
end type

event p_ins::clicked;call super::clicked;string ls_dept
ls_dept = dw_dp.GetItemString(1,1)

if ls_dept = '' or isNull(ls_dept) then
	messagebox('Ȯ��','�ش� �μ��� �����ϼ���.',Exclamation!)
	return
end if

if dw_dp.RowCount() < 1 then
	dw_list.Retrieve(ls_dept)
end if

dw_list.scrolltorow(dw_list.insertrow(0))
dw_list.setitem(dw_list.rowcount(),'redate',string(today(),'yyyymmdd'))
dw_list.setitem(dw_list.rowcount(),'deptcode',ls_dept)
dw_list.setfocus()
dw_list.setcolumn('lgbn')
end event

type p_search from w_inherite_standard`p_search within w_psd3001
boolean visible = false
integer x = 873
integer y = 2476
boolean enabled = false
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd3001
boolean visible = false
integer x = 530
integer y = 2476
boolean enabled = false
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd3001
boolean visible = false
integer x = 704
integer y = 2484
boolean enabled = false
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd3001
boolean visible = false
integer y = 2468
boolean enabled = false
end type

type st_window from w_inherite_standard`st_window within w_psd3001
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd3001
end type

type cb_update from w_inherite_standard`cb_update within w_psd3001
end type

type cb_insert from w_inherite_standard`cb_insert within w_psd3001
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd3001
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd3001
end type

type st_1 from w_inherite_standard`st_1 within w_psd3001
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd3001
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_psd3001
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd3001
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd3001
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd3001
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd3001
end type

type dw_list from u_d_select_sort within w_psd3001
event ue_enter pbm_dwnprocessenter
integer x = 434
integer y = 232
integer width = 3831
integer height = 2064
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_psd3001_01"
boolean hscrollbar = false
boolean border = false
boolean livescroll = false
end type

event ue_enter;send(handle(this),256,9,0)
return 1
end event

event itemchanged;call super::itemchanged;long i, ll_chk = 0
string ls_data1, ls_data2, snull
Setnull(snull)

if this.GetColumnName() = 'mgbn' then
	if this.RowCount() = 1 then return

	ls_data1 = this.GetitemString(this.GetRow(),'lgbn') + This.GetText()
	For i = 1 to this.RowCount()
		ls_data2 = this.GetItemString(i,'lgbn')  + &
		           this.GetitemString(i,'mgbn')
					  
	   if ls_data1 = ls_data2 then
			ll_chk = ll_chk + 1 
		end if		
	Next
	
	if ll_chk > 0 then
		messagebox('Ȯ��','�̹� ��ϵ� �ڵ��Դϴ�.',Stopsign!)
		this.SetItem(this.GetRow(),'mgbn', '')
		this.SetColumn('mgbn')
		return 1
		
	end if
End If

IF this.GetcolumnName() ="redate" THEN
	IF f_datechk(data) = -1 THEN
		MessageBox("Ȯ ��", "������ڸ� Ȯ���ϼ���.")
		SetItem(getrow(),'redate',snull)
		SetColumn('redate')
		dw_list.SetFocus()
		Return 1
   END IF
END IF 
end event

event itemerror;call super::itemerror;return 1
end event

type dw_dp from u_key_enter within w_psd3001
integer x = 421
integer y = 44
integer width = 1339
integer height = 128
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_psd3001_02"
boolean border = false
end type

event itemchanged;call super::itemchanged;string ls_code
if this.GetColumnName() = 'dept' then
	ls_code = GetText()
	dw_list.retrieve(ls_code)
end if
end event

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_psd3001
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 425
integer y = 228
integer width = 3854
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

