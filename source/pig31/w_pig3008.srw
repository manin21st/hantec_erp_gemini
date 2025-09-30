$PBExportHeader$w_pig3008.srw
$PBExportComments$비용별 관리현황 - 출력
forward
global type w_pig3008 from w_standard_print
end type
type rr_1 from roundrectangle within w_pig3008
end type
end forward

global type w_pig3008 from w_standard_print
string title = "기타비용 관리 현황"
rr_1 rr_1
end type
global w_pig3008 w_pig3008

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string fr_date,to_date,caruser,costgbn

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
caruser  = Trim(dw_ip.GetItemString(row,'caruser'))
costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))

If IsNull(caruser) Then caruser = ''
If IsNull(costgbn) Then costgbn = ''

If dw_print.Retrieve(caruser+'%',fr_date,to_date,costgbn+'%') < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
  	return -1
End if
dw_print.sharedata(dw_list)
return 1

//cb_print.enabled = true

end function

on w_pig3008.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pig3008.destroy
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

type p_preview from w_standard_print`p_preview within w_pig3008
end type

event p_preview::clicked;int row
string fr_date,to_date,caruser,costgbn

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
caruser  = Trim(dw_ip.GetItemString(row,'caruser'))
costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))

If IsNull(caruser) Then caruser = ''
If IsNull(costgbn) Then costgbn = ''

dw_print.Retrieve(caruser+'%',fr_date,to_date,costgbn+'%')

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_pig3008
end type

type p_print from w_standard_print`p_print within w_pig3008
end type

event p_print::clicked;int row
string fr_date,to_date,caruser,costgbn

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
caruser  = Trim(dw_ip.GetItemString(row,'caruser'))
costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))

If IsNull(caruser) Then caruser = ''
If IsNull(costgbn) Then costgbn = ''

dw_print.Retrieve(caruser+'%',fr_date,to_date,costgbn+'%')

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pig3008
end type

type st_window from w_standard_print`st_window within w_pig3008
integer x = 2574
integer y = 4692
end type

type sle_msg from w_standard_print`sle_msg within w_pig3008
integer x = 599
integer y = 4692
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig3008
integer x = 3067
integer y = 4692
end type

type st_10 from w_standard_print`st_10 within w_pig3008
integer x = 238
integer y = 4692
end type

type gb_10 from w_standard_print`gb_10 within w_pig3008
integer x = 224
integer y = 4656
end type

type dw_print from w_standard_print`dw_print within w_pig3008
integer x = 4201
integer y = 192
string dataobject = "d_pig1003_12_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3008
integer x = 713
integer y = 60
integer width = 3127
integer height = 144
string dataobject = "d_pig1003_14"
end type

event dw_ip::itemchanged;If dwo.Name = 'fr_date' Or dwo.Name = 'to_date' Then
	If f_datechk(data) = -1 Then return 1 // date형이 아니면 discard
End If

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF This.GetColumnName() =  "caruser"  THEN
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(GetRow(),"caruser",Gs_code)	
END IF

end event

type dw_list from w_standard_print`dw_list within w_pig3008
integer x = 731
integer y = 220
integer width = 3237
string title = "기타비용 관리 현황"
string dataobject = "d_pig1003_12"
boolean border = false
end type

type rr_1 from roundrectangle within w_pig3008
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 718
integer y = 212
integer width = 3269
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

