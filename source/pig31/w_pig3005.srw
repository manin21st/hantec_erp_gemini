$PBExportHeader$w_pig3005.srw
$PBExportComments$차량관리대장 - 출력
forward
global type w_pig3005 from w_standard_print
end type
type rr_1 from roundrectangle within w_pig3005
end type
end forward

global type w_pig3005 from w_standard_print
string title = "차량관리대장"
rr_1 rr_1
end type
global w_pig3005 w_pig3005

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string cargbn

row = dw_ip.GetRow()
If row <= 0 then return -1

cargbn = dw_ip.Object.cargbn[row]
If cargbn = '0' then cargbn = ''

If dw_print.Retrieve(cargbn+'%') < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
  	return -1
End if	
dw_print.sharedata(dw_list)
return 1
//cb_print.enabled = true

end function

on w_pig3005.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pig3005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.SetTransObject(sqlca)



end event

type p_preview from w_standard_print`p_preview within w_pig3005
end type

type p_exit from w_standard_print`p_exit within w_pig3005
end type

type p_print from w_standard_print`p_print within w_pig3005
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig3005
end type

type st_window from w_standard_print`st_window within w_pig3005
integer x = 2469
integer y = 4004
end type

type sle_msg from w_standard_print`sle_msg within w_pig3005
integer x = 494
integer y = 4004
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig3005
integer x = 2962
integer y = 4004
end type

type st_10 from w_standard_print`st_10 within w_pig3005
integer x = 133
integer y = 4004
end type

type gb_10 from w_standard_print`gb_10 within w_pig3005
integer x = 119
integer y = 3968
end type

type dw_print from w_standard_print`dw_print within w_pig3005
string dataobject = "d_pig1003_09_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3005
integer x = 27
integer y = 32
integer width = 891
integer height = 304
string dataobject = "d_pig1003_15"
end type

event dw_ip::itemchanged;If dwo.Name = 'frdate' Or dwo.Name = 'todate' Then
	If f_datechk(data) = -1 Then return 1 // date형이 아니면 discard
End If

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;IF dwo.name =  "carno"  THEN
	open(w_car_popup)
	If IsNull(gs_code) Then Return
	this.SetItem(row,"carno",Gs_code)
END IF
end event

type dw_list from w_standard_print`dw_list within w_pig3005
integer x = 27
integer y = 356
integer width = 4576
integer height = 1952
string title = "차량관리대장"
string dataobject = "d_pig1003_09"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pig3005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 344
integer width = 4608
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

