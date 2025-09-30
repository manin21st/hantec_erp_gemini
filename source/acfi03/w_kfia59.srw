$PBExportHeader$w_kfia59.srw
$PBExportComments$�Ⱓ�� ������ ��ȯ��ȹ ��Ȳ
forward
global type w_kfia59 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia59
end type
end forward

global type w_kfia59 from w_standard_print
integer x = 0
integer y = 0
string title = "�Ⱓ�� ������ ��ȯ��ȹ ��Ȳ"
rr_1 rr_1
end type
global w_kfia59 w_kfia59

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_acc_ymdf, ls_acc_ymdt, ls_gubun, ls_acc1, ls_acc2
long ll_row

ll_row = dw_ip.GetRow()

if ll_row < 1 then return -1
if dw_ip.AcceptText() = -1 then return -1

ls_acc_ymdf = dw_ip.GetItemString(ll_row, 'acc_ymdf')   // ��ȯ���� FROM
ls_acc_ymdt = dw_ip.GetItemString(ll_row, 'acc_ymdt')   // ��ȯ���� TO
ls_gubun    = dw_ip.GetItemString(ll_row, 'gubun')      // ���/�ܱ� ����(2001.03.21����)

if trim(ls_acc_ymdf) = '' or isnull(ls_acc_ymdf) then 
	F_MessageChk(1, "[��ȯ���� FROM]")
	dw_ip.SetColumn('acc_ymdf')
	dw_ip.SetFocus()
	return -1
else 
	if f_datechk(ls_acc_ymdf) = -1 then 
		F_MessageChk(21, "[��ȯ���� FROM]")
		dw_ip.SetColumn('acc_ymdf')
		dw_ip.SetFocus()
		return -1		
	end if
end if

if trim(ls_acc_ymdt) = '' or isnull(ls_acc_ymdt) then 
	F_MessageChk(1, "[��ȯ���� TO]")
	dw_ip.SetColumn('acc_ymdt')
	dw_ip.SetFocus()
	return -1
else 
	if f_datechk(ls_acc_ymdt) = -1 then 
		F_MessageChk(21, "[��ȯ���� TO]")
		dw_ip.SetColumn('acc_ymdt')
		dw_ip.SetFocus()
		return -1		
	end if
end if

if ls_acc_ymdf > ls_acc_ymdt then
	MessageBox("Ȯ ��", "���� ��ȯ���ں��� ~r~r�������ڰ� Ŭ�� �����ϴ�.!!")
	dw_ip.SetColumn('acc_ymdf')
	dw_ip.SetFocus()
	return -1
end if

If ls_gubun = "" or Isnull(ls_gubun) Then
	f_messagechk(1, "[���/�ܱ� ����]")
	dw_ip.Setcolumn('gubun')
	dw_ip.Setfocus()
	Return -1
End If

dw_list.SetRedraw(false)				 
if dw_print.retrieve(ls_acc_ymdf, ls_acc_ymdt, ls_gubun) < 1 then 
	F_MessageChk(14, "")
	dw_list.insertrow(0)
	dw_ip.SetColumn('acc_ymdf')
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)	
	//return -1
end if
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)	


return 1
end function

on w_kfia59.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia59.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(), 'acc_ymdf', left(f_today(), 6) + "01")
dw_ip.SetItem(dw_ip.GetRow(), 'acc_ymdt', f_today())
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia59
end type

type p_exit from w_standard_print`p_exit within w_kfia59
end type

type p_print from w_standard_print`p_print within w_kfia59
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia59
end type







type st_10 from w_standard_print`st_10 within w_kfia59
end type



type dw_print from w_standard_print`dw_print within w_kfia59
string dataobject = "dw_kfia59_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia59
integer x = 46
integer y = 32
integer width = 2190
integer height = 244
string dataobject = "dw_kfia59_01"
end type

event dw_ip::itemchanged;string ls_acc_ymdf, ls_acc_ymdt


if this.GetColumnName() ='acc_ymdf' then
	ls_acc_ymdf = this.GetText()
	if trim(ls_acc_ymdf) = '' or isnull(ls_acc_ymdf) then
		F_MessageChk(1, "[��ȯ���� FROM]")
		return 1
	else 
		if f_datechk(ls_acc_ymdf) = -1 then
			F_MessageChk(21, "[��ȯ���� FROM]")
			return 1
		end if
	end if
end if

if this.GetColumnName() ='acc_ymdt' then
	ls_acc_ymdt = this.GetText()
	ls_acc_ymdf = this.GetItemString(row, 'acc_ymdf')
	
	if trim(ls_acc_ymdt) = '' or isnull(ls_acc_ymdt) then
		F_MessageChk(1, "[��ȯ���� TO]")
		return 1
	else 
		if f_datechk(ls_acc_ymdt) = -1 then
			F_MessageChk(21, "[��ȯ���� TO]")
			return 1
		end if
	end if
	if ls_acc_ymdf > ls_acc_ymdt then
		MessageBox("Ȯ ��", "���� ��ȯ���ں��� ~r~r�������ڰ� Ŭ�� �����ϴ�.!!")
		return 1
	end if
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia59
integer x = 69
integer y = 296
integer width = 4517
integer height = 2008
string title = "���Ա� ��ȯ ��ȹ ����"
string dataobject = "dw_kfia59_02"
end type

type rr_1 from roundrectangle within w_kfia59
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 284
integer width = 4549
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

