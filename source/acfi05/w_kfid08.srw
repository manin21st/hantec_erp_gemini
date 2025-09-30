$PBExportHeader$w_kfid08.srw
$PBExportComments$���α� ���Կ��� ��Ȳ
forward
global type w_kfid08 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfid08
end type
end forward

global type w_kfid08 from w_standard_print
string title = "���α� ���Կ��� ��Ȳ"
rr_1 rr_1
end type
global w_kfid08 w_kfid08

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_saupj, ls_acc_date, snull

If dw_ip.Accepttext() = -1 then Return -1

Setnull(snull)

ls_saupj = Trim(dw_ip.Getitemstring(1, 'saupj'))
ls_acc_date = Trim(dw_ip.Getitemstring(1, 'acc_date'))

If ls_saupj = "" or Isnull(ls_saupj) then
	ls_saupj = '%'
End If

If ls_acc_date = "" or Isnull(ls_acc_date) then
	f_messagechk(1, '[���Կ������]')
	dw_ip.Setcolumn('acc_date')
	dw_ip.Setfocus()
	Return -1
End If

//If dw_list.Retrieve(ls_saupj, ls_acc_date) <= 0 then
//	f_messagechk(14, "")
//	dw_ip.Setcolumn('saupj')
//	dw_ip.Setfocus()
//	Return -1
//End If

IF dw_print.Retrieve(ls_saupj, ls_acc_date) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1
	

	
end function

event open;call super::open;dw_ip.Setitem(1, 'saupj', gs_saupj)
dw_ip.Setitem(1, 'acc_date', string(left(f_today(),6), "@@@@@@"))
dw_ip.Setfocus()

end event

on w_kfid08.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfid08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_kfid08
end type

type p_exit from w_standard_print`p_exit within w_kfid08
end type

type p_print from w_standard_print`p_print within w_kfid08
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid08
end type







type st_10 from w_standard_print`st_10 within w_kfid08
end type



type dw_print from w_standard_print`dw_print within w_kfid08
string dataobject = "d_kfid08_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfid08
integer width = 1472
integer height = 228
string dataobject = "d_kfid08_1"
end type

type dw_list from w_standard_print`dw_list within w_kfid08
integer x = 64
integer y = 280
integer width = 4517
integer height = 2024
string dataobject = "d_kfid08_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfid08
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 268
integer width = 4544
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

