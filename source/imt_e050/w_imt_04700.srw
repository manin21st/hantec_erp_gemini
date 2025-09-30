$PBExportHeader$w_imt_04700.srw
$PBExportComments$금형/치공구 보유현황
forward
global type w_imt_04700 from w_standard_print
end type
type rr_1 from roundrectangle within w_imt_04700
end type
end forward

global type w_imt_04700 from w_standard_print
string title = "금형/치공구 보유현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_imt_04700 w_imt_04700

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_grp

ls_grp = dw_ip.GetItemString(row, 'kumgubn')
If Trim(ls_grp) = '' Or IsNull(ls_grp) Then ls_grp = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_grp)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1



end function

on w_imt_04700.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_imt_04700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_imt_04700
end type

type p_exit from w_standard_print`p_exit within w_imt_04700
end type

type p_print from w_standard_print`p_print within w_imt_04700
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04700
end type







type st_10 from w_standard_print`st_10 within w_imt_04700
end type



type dw_print from w_standard_print`dw_print within w_imt_04700
string dataobject = "d_imt_047001_10p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04700
integer x = 64
integer y = 32
integer width = 978
integer height = 168
string dataobject = "d_imt_047001_2"
end type

event dw_ip::rbuttondown;call super::rbuttondown;STRING ls_kumno ,ls_kumno1 ,ls_data

ls_data = Trim(dw_ip.getcolumnname())

Choose Case ls_data
	Case 'kumno'  
	    gs_gubun = '1'
		 
		 open(w_imt_04630_popup)
		 
		 dw_ip.setitem(1,'kumno',gs_code)
		 
	Case 'kumno1' 
		 gs_gubun = '1'
		 
		 open(w_imt_04630_popup)
		 
		 dw_ip.setitem(1,'kumno1',gs_code)
	
End Choose
	


end event

type dw_list from w_standard_print`dw_list within w_imt_04700
integer x = 69
integer y = 220
integer width = 4517
integer height = 2088
string dataobject = "d_imt_047001_10p"
boolean border = false
end type

type rr_1 from roundrectangle within w_imt_04700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 204
integer width = 4544
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

