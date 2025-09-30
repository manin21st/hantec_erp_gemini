$PBExportHeader$w_pig3007.srw
$PBExportComments$차량운행일지 - 출력
forward
global type w_pig3007 from w_standard_print
end type
type rr_1 from roundrectangle within w_pig3007
end type
end forward

global type w_pig3007 from w_standard_print
string title = "차량운행일지"
rr_1 rr_1
end type
global w_pig3007 w_pig3007

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string fr_date,to_date,carno,costgbn
string filter

if dw_ip.AcceptText() = -1 then return -1
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
carno  = Trim(dw_ip.GetItemString(row,'carno'))
//costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))
If IsNull(carno) Then carno = ''
If IsNull(costgbn) Then costgbn = ''

If dw_print.Retrieve(carno+'%',fr_date,to_date) < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.setcolumn('carno')
	dw_ip.setfocus()
  	return -1
End if	
  dw_print.sharedata(dw_list)

return 1

//cb_print.enabled = true

end function

on w_pig3007.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pig3007.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string first_day,last_day

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.SetTransObject(sqlca)
dw_list.InsertRow(0)


dw_ip.SetItem(1, 'fr_date', string(today(), 'yyyymm'+'01'))
dw_ip.SetItem(1, 'to_date', string(today(), 'yyyymmdd'))


end event

type p_preview from w_standard_print`p_preview within w_pig3007
end type

event p_preview::clicked;string fr_date,to_date,carno,costgbn
string filter

if dw_ip.AcceptText() = -1 then return -1

fr_date = Trim(dw_ip.GetItemString(1,'fr_date'))
to_date = Trim(dw_ip.GetItemString(1,'to_date'))
carno  = Trim(dw_ip.GetItemString(1,'carno'))

If IsNull(carno) Then carno = ''
If IsNull(costgbn) Then costgbn = ''

dw_print.Retrieve(carno+'%',fr_date,to_date) 

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_pig3007
end type

type p_print from w_standard_print`p_print within w_pig3007
end type

event p_print::clicked;string fr_date,to_date,carno,costgbn
string filter

if dw_ip.AcceptText() = -1 then return -1

fr_date = Trim(dw_ip.GetItemString(1,'fr_date'))
to_date = Trim(dw_ip.GetItemString(1,'to_date'))
carno  = Trim(dw_ip.GetItemString(1,'carno'))

If IsNull(carno) Then carno = ''
If IsNull(costgbn) Then costgbn = ''

dw_print.Retrieve(carno+'%',fr_date,to_date) 

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pig3007
end type

type st_window from w_standard_print`st_window within w_pig3007
integer y = 4132
end type

type sle_msg from w_standard_print`sle_msg within w_pig3007
integer y = 4132
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig3007
integer y = 4132
end type

type st_10 from w_standard_print`st_10 within w_pig3007
integer y = 4132
end type

type gb_10 from w_standard_print`gb_10 within w_pig3007
integer y = 4096
end type

type dw_print from w_standard_print`dw_print within w_pig3007
string dataobject = "d_pig1003_11_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3007
integer x = 9
integer y = 36
integer width = 2034
integer height = 152
string dataobject = "d_pig1003_13"
end type

event dw_ip::itemchanged;If dwo.Name = 'fr_date' Or dwo.Name = 'to_date' Then
	If f_datechk(data) = -1 Then return 1 // date형이 아니면 discard
End If

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;IF This.GetColumnName() =  "carno"  THEN
	open(w_car_popup)
	If IsNull(gs_code) Then Return
	this.SetItem(getrow(),"carno",Gs_code)
END IF
end event

type dw_list from w_standard_print`dw_list within w_pig3007
integer x = 32
integer y = 200
integer width = 4553
integer height = 2056
string title = "차량운행일지"
string dataobject = "d_pig1003_11"
boolean vscrollbar = false
boolean border = false
end type

type rr_1 from roundrectangle within w_pig3007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 192
integer width = 4571
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

