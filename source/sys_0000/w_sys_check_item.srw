$PBExportHeader$w_sys_check_item.srw
$PBExportComments$기준정보 검증
forward
global type w_sys_check_item from w_standard_print
end type
type rr_1 from roundrectangle within w_sys_check_item
end type
end forward

global type w_sys_check_item from w_standard_print
string title = "기준정보 검증"
rr_1 rr_1
end type
global w_sys_check_item w_sys_check_item

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sIttyp, sPdtgu

If dw_ip.AcceptText() <> 1 Then REturn -1

sIttyp = Trim(dw_ip.GetItemString(1, 'ittyp'))
If sIttyp = '' Or IsnUll(sIttyp) Then sIttyp = ''

sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
If sPdtgu = '' Or IsnUll(sPdtgu) Then sPdtgu = ''

IF dw_print.Retrieve(sIttyp+'%', sPdtgu) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
  
dw_print.sharedata(dw_list)

return 1

end function

on w_sys_check_item.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sys_check_item.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_ip.Reset()
dw_ip.InsertRow(0)

end event

type p_preview from w_standard_print`p_preview within w_sys_check_item
end type

type p_exit from w_standard_print`p_exit within w_sys_check_item
end type

type p_print from w_standard_print`p_print within w_sys_check_item
end type

type p_retrieve from w_standard_print`p_retrieve within w_sys_check_item
end type







type st_10 from w_standard_print`st_10 within w_sys_check_item
end type



type dw_print from w_standard_print`dw_print within w_sys_check_item
string dataobject = "d_sys_check_item_01"
end type

type dw_ip from w_standard_print`dw_ip within w_sys_check_item
integer width = 1952
integer height = 184
string dataobject = "d_sys_check_item_02"
end type

type dw_list from w_standard_print`dw_list within w_sys_check_item
integer x = 41
integer y = 264
integer height = 2000
string dataobject = "d_sys_check_item_01"
boolean border = false
end type

event dw_list::clicked;call super::clicked;String lsSort
Int    liLen

If dwo.type = 'text' Then
		lsSort = dwo.name
	If Right(lsSort,2) = '_t' Then
		liLen = Len(lsSort) - 2
		lsSort = "'" + Left(dwo.name,liLen) + " A'"
		dw_list.SetSort(lsSort)
		dw_list.Sort()
	End IF
End IF


end event

type rr_1 from roundrectangle within w_sys_check_item
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

