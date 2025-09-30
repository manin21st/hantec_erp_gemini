$PBExportHeader$w_kfid10.srw
$PBExportComments$받을어음 종류별 어음집계표
forward
global type w_kfid10 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfid10
end type
type rr_2 from roundrectangle within w_kfid10
end type
end forward

global type w_kfid10 from w_standard_print
string title = "받을어음 종류별 어음집계표"
rr_1 rr_1
rr_2 rr_2
end type
global w_kfid10 w_kfid10

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_bal_date, snull

Setnull(snull)

dw_ip.AcceptText()
ls_bal_date  = Trim(dw_ip.Getitemstring(1, 'bal_date'))

If ls_bal_date = "" or Isnull(ls_bal_date) Then
	f_messagechk(1,'[기준일자]')
	dw_ip.Setcolumn('bal_date')
	dw_ip.Setfocus()
	Return -1
End If

//If dw_list.Retrieve(ls_bal_date) <= 0 Then
//	F_MessageChk(14,'')
//	dw_ip.Setcolumn('bal_date')
//	dw_ip.Setfocus()
//	Return -1
//End If

IF dw_print.Retrieve(ls_bal_date) <= 0 Then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1

end function

on w_kfid10.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_kfid10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'bal_date', F_today())
dw_ip.SetFocus()
	
end event

type p_preview from w_standard_print`p_preview within w_kfid10
end type

type p_exit from w_standard_print`p_exit within w_kfid10
end type

type p_print from w_standard_print`p_print within w_kfid10
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid10
end type







type st_10 from w_standard_print`st_10 within w_kfid10
end type



type dw_print from w_standard_print`dw_print within w_kfid10
string dataobject = "d_kfid102_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfid10
integer x = 59
integer y = 52
integer width = 795
integer height = 88
string dataobject = "d_kfid101"
end type

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfid10
integer x = 41
integer y = 184
integer width = 4544
integer height = 2028
string dataobject = "d_kfid102"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfid10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 24
integer width = 841
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfid10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 180
integer width = 4581
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

