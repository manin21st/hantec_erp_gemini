$PBExportHeader$wr_pif2002.srw
$PBExportComments$** �λ� �ڵ� ��Ȳ
forward
global type wr_pif2002 from w_standard_print
end type
type rr_1 from roundrectangle within wr_pif2002
end type
end forward

global type wr_pif2002 from w_standard_print
integer x = 0
integer y = 0
string title = "�λ� �ڵ� ��Ȳ"
rr_1 rr_1
end type
global wr_pif2002 wr_pif2002

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_gubun

dw_list.reset()

setpointer(hourglass!)

dw_ip.AcceptText()
ls_gubun = trim(dw_ip.GetItemString(1,"insacode"))

if isnull(ls_gubun) or ls_gubun = '' then
	messagebox("�׸� Ȯ��", "��ȸ�Ϸ��� �λ� �ڵ� �׸��� �����ϼ���.!!!", information!)
	dw_ip.setfocus()
	return -1
end if

choose case ls_gubun
	case "���"
		dw_list.dataobject = "dr_pif2002_11"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_11_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_12"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_12_p"
		dw_print.settransobject(sqlca)
	case "����ó"
		dw_list.dataobject = "dr_pif2002_13"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_13_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_14"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_14_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_15"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_15_p"
		dw_print.settransobject(sqlca)
	case "��ȣȸ"
		dw_list.dataobject = "dr_pif2002_16"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_16_p"
		dw_print.settransobject(sqlca)
	case "�߷�"
		dw_list.dataobject = "dr_pif2002_17"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_17_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_18"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_18_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_19"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_19_p"
		dw_print.settransobject(sqlca)
	case "�μ�"
		dw_list.dataobject = "dr_pif2002_20"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_20_p"
		dw_print.settransobject(sqlca)
	case "���"
		dw_list.dataobject = "dr_pif2002_21"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_21_p"
		dw_print.settransobject(sqlca)
//	case "������(�ҵ�)"
//		dw_list.dataobject = "dr_pif2002_22"
//		dw_list.settransobject(sqlca)
//	case "�������(�ҵ�)"
//		dw_list.dataobject = "dr_pif2002_23"
//		dw_list.settransobject(sqlca)
	case "�ܱ���"
		dw_list.dataobject = "dr_pif2002_24"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_24_p"
		dw_print.settransobject(sqlca)
	case "�ܱ��� �ڰ�"
		dw_list.dataobject = "dr_pif2002_25"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_25_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_26"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_26_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_27"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_27_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_28"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_28_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_29"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_29_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_30"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_30_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_31"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_31_p"
		dw_print.settransobject(sqlca)
	case "����"
		dw_list.dataobject = "dr_pif2002_32"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_32_p"
		dw_print.settransobject(sqlca)
	case "��å"
		dw_list.dataobject = "dr_pif2002_34"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_34_p"
		dw_print.settransobject(sqlca)
	case "ä��"
		dw_list.dataobject = "dr_pif2002_35"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_35_p"
		dw_print.settransobject(sqlca)
	case "�б�"
		dw_list.dataobject = "dr_pif2002_36"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_36_p"
		dw_print.settransobject(sqlca)
	case "�з�"
		dw_list.dataobject = "dr_pif2002_37"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_37_p"
		dw_print.settransobject(sqlca)
   case "�ٹ��ϱ���"
		dw_list.dataobject = "dr_pif2002_46"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_46_p"
		dw_print.settransobject(sqlca)
   case "�ٹ�����"
		dw_list.dataobject = "dr_pif2002_48"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_48_p"
		dw_print.settransobject(sqlca)
   case "�����"
		dw_list.dataobject = "dr_pif2002_49"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_49_p"
		dw_print.settransobject(sqlca)
   case "�������"
		dw_list.dataobject = "dr_pif2002_50"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_50_p"
		dw_print.settransobject(sqlca)
   case "ǥ�رٹ���"
		dw_list.dataobject = "dr_pif2002_41"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_41_p"
		dw_print.settransobject(sqlca)
   case "���ϱ���"
		dw_list.dataobject = "dr_pif2002_44"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_44_p"
		dw_print.settransobject(sqlca)
   case "�ܱ����򰡹��"
		dw_list.dataobject = "dr_pif2002_39"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_39_p"
		dw_print.settransobject(sqlca)
   case "��������ǰ��"
		dw_list.dataobject = "dr_pif2002_40"
		dw_list.settransobject(sqlca)
		dw_print.dataobject = "dr_pif2002_40_p"
		dw_print.settransobject(sqlca)
	case "��������ǰSIZE"
		dw_list.dataobject = "dr_pif2002_45"
		dw_list.settransobject(sqlca)	
		dw_print.dataobject = "dr_pif2002_45_p"
		dw_print.settransobject(sqlca)
	case "������"
		dw_list.dataobject = "dr_pif2002_51"
		dw_list.settransobject(sqlca)	
		dw_print.dataobject = "dr_pif2002_51_p"
		dw_print.settransobject(sqlca)
	case "�����ȣ"
		dw_list.dataobject = "dr_pif2002_52"
		dw_list.settransobject(sqlca)	
		dw_print.dataobject = "dr_pif2002_52_p"
		dw_print.settransobject(sqlca)

end choose

if dw_print.retrieve() < 1 then
	messagebox("�ڷ� Ȯ��", "�ش� �ڷᰡ �����ϴ�.!!!", stopsign!)
	dw_ip.setfocus()
  
	return -1
end if
 dw_print.sharedata(dw_list)
//cb_print.enabled = true
//
///* Last page ���ϴ� routine */
//long Li_row = 1, Ll_prev_row
//
//dw_list.setredraw(false)
//dw_list.object.datawindow.print.preview="yes"
//
//gi_page = 1
//
//do while true
//	ll_prev_row = Li_row
//	Li_row = dw_list.ScrollNextPage()
//	If Li_row = ll_prev_row or Li_row <= 0 then
//		exit
//	Else
//		gi_page++
//	End if
//loop
//
//dw_list.scrolltorow(1)
//dw_list.setredraw(true)
//
setpointer(arrow!)

//cb_print.setfocus()
return 1
end function

on wr_pif2002.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wr_pif2002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)
dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)

dw_ip.SetItem(1,"insacode","���")
dw_ip.TriggerEvent(itemchanged!)


//sle_msg.text = "��¹� - ����ũ�� : A4, ��¹��� : ���ι���"
end event

type p_preview from w_standard_print`p_preview within wr_pif2002
integer x = 4046
integer y = 12
end type

type p_exit from w_standard_print`p_exit within wr_pif2002
integer x = 4402
integer y = 12
end type

type p_print from w_standard_print`p_print within wr_pif2002
integer x = 4224
integer y = 12
boolean enabled = true
end type

type p_retrieve from w_standard_print`p_retrieve within wr_pif2002
integer x = 3867
integer y = 12
end type

type st_window from w_standard_print`st_window within wr_pif2002
integer y = 5000
end type

type sle_msg from w_standard_print`sle_msg within wr_pif2002
integer y = 5000
end type

type dw_datetime from w_standard_print`dw_datetime within wr_pif2002
integer y = 5000
end type

type st_10 from w_standard_print`st_10 within wr_pif2002
integer y = 5000
end type

type gb_10 from w_standard_print`gb_10 within wr_pif2002
integer y = 5000
end type

type dw_print from w_standard_print`dw_print within wr_pif2002
integer x = 3680
string dataobject = "dr_pif2002_11_p"
end type

type dw_ip from w_standard_print`dw_ip within wr_pif2002
integer x = 14
integer y = 8
integer width = 1083
integer height = 152
string dataobject = "dr_pif2002_1"
end type

event dw_ip::itemchanged;call super::itemchanged;p_retrieve.triggerevent(clicked!)
end event

type dw_list from w_standard_print`dw_list within wr_pif2002
integer x = 46
integer y = 192
integer width = 4517
integer height = 2120
string dataobject = "dr_pif2002_11"
boolean border = false
end type

type rr_1 from roundrectangle within wr_pif2002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 176
integer width = 4553
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

