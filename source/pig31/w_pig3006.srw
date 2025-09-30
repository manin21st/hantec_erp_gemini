$PBExportHeader$w_pig3006.srw
$PBExportComments$업무외 차량 사용 명세 - 출력
forward
global type w_pig3006 from w_standard_print
end type
type rr_1 from roundrectangle within w_pig3006
end type
end forward

global type w_pig3006 from w_standard_print
string title = "업무외 차량 사용 명세"
rr_1 rr_1
end type
global w_pig3006 w_pig3006

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string fr_date,to_date,carno
string filter

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
carno  = Trim(dw_ip.GetItemString(row,'carno'))
If IsNull(carno) Then carno = ''

If dw_print.Retrieve(carno+'%',fr_date,to_date) < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
  	return -1
End if	
dw_print.sharedata(dw_list)
return 1
//cb_print.enabled = true

end function

on w_pig3006.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pig3006.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string first_day,last_day

dw_list.SetTransObject(sqlca)

select to_char(sysdate,'yyyymm') || '01', 
       to_char(last_day(sysdate),'yyyymmdd')
  into :first_day,:last_day		 
  from dual;
  
dw_ip.SetItem(1,'fr_date',first_day)
dw_ip.SetItem(1,'to_date',last_day)
end event

type p_preview from w_standard_print`p_preview within w_pig3006
end type

type p_exit from w_standard_print`p_exit within w_pig3006
end type

type p_print from w_standard_print`p_print within w_pig3006
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig3006
end type

type st_window from w_standard_print`st_window within w_pig3006
integer x = 2395
integer y = 4180
end type

type sle_msg from w_standard_print`sle_msg within w_pig3006
integer x = 421
integer y = 4180
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig3006
integer x = 2889
integer y = 4180
end type

type st_10 from w_standard_print`st_10 within w_pig3006
integer x = 59
integer y = 4180
end type

type gb_10 from w_standard_print`gb_10 within w_pig3006
integer x = 46
integer y = 4144
end type

type dw_print from w_standard_print`dw_print within w_pig3006
string dataobject = "d_pig1003_10_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3006
integer x = 137
integer y = 32
integer width = 2030
integer height = 156
string dataobject = "d_pig1003_13"
end type

event dw_ip::itemchanged;If dwo.Name = 'frdate' Or dwo.Name = 'todate' Then
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

type dw_list from w_standard_print`dw_list within w_pig3006
integer x = 169
integer y = 200
integer width = 4393
integer height = 2044
string title = "업무외 차량 사용 명세"
string dataobject = "d_pig1003_10"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pig3006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 151
integer y = 188
integer width = 4434
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

