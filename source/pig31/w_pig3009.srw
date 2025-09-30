$PBExportHeader$w_pig3009.srw
$PBExportComments$차량운행 비용일지 - 출력
forward
global type w_pig3009 from w_standard_print
end type
type gb_4 from groupbox within w_pig3009
end type
type rb_1 from radiobutton within w_pig3009
end type
type rb_2 from radiobutton within w_pig3009
end type
type gb_1 from groupbox within w_pig3009
end type
type rr_1 from roundrectangle within w_pig3009
end type
type rr_3 from roundrectangle within w_pig3009
end type
end forward

global type w_pig3009 from w_standard_print
string title = "차량운행 비용일지"
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_1 rr_1
rr_3 rr_3
end type
global w_pig3009 w_pig3009

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string fr_date,to_date,carno,costgbn
string filter

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
carno  = Trim(dw_ip.GetItemString(row,'carno'))
costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))
If IsNull(carno) Then carno = ''
If IsNull(costgbn) Then costgbn = ''

If dw_print.Retrieve(carno+'%',fr_date,to_date,costgbn+'%') < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	p_print.enabled = false
  	return -1
End if	
dw_print.sharedata(dw_list)
//cb_print.enabled = true
return 1

end function

on w_pig3009.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_3
end on

on w_pig3009.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_3)
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

type p_preview from w_standard_print`p_preview within w_pig3009
end type

event p_preview::clicked;int row
string fr_date,to_date,carno,costgbn
string filter

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
carno  = Trim(dw_ip.GetItemString(row,'carno'))
costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))
If IsNull(carno) Then carno = ''
If IsNull(costgbn) Then costgbn = ''

dw_print.Retrieve(carno+'%',fr_date,to_date,costgbn+'%') 

OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within w_pig3009
end type

type p_print from w_standard_print`p_print within w_pig3009
end type

event p_print::clicked;int row
string fr_date,to_date,carno,costgbn
string filter

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

fr_date = Trim(dw_ip.GetItemString(row,'fr_date'))
to_date = Trim(dw_ip.GetItemString(row,'to_date'))
carno  = Trim(dw_ip.GetItemString(row,'carno'))
costgbn  = Trim(dw_ip.GetItemString(row,'costgbn'))
If IsNull(carno) Then carno = ''
If IsNull(costgbn) Then costgbn = ''

dw_print.Retrieve(carno+'%',fr_date,to_date,costgbn+'%') 

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pig3009
end type

type st_window from w_standard_print`st_window within w_pig3009
integer x = 2665
integer y = 5732
end type

type sle_msg from w_standard_print`sle_msg within w_pig3009
integer x = 690
integer y = 5732
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig3009
integer x = 3159
integer y = 5732
end type

type st_10 from w_standard_print`st_10 within w_pig3009
integer x = 329
integer y = 5732
end type

type gb_10 from w_standard_print`gb_10 within w_pig3009
integer x = 315
integer y = 5696
end type

type dw_print from w_standard_print`dw_print within w_pig3009
string dataobject = "d_pig1003_16_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3009
integer x = 27
integer y = 36
integer width = 1984
integer height = 216
string dataobject = "d_pig1003_18"
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
	this.SetItem(GetRow(),"carno",Gs_code)
END IF
end event

type dw_list from w_standard_print`dw_list within w_pig3009
integer x = 32
integer y = 344
integer width = 4581
integer height = 1900
string title = "차량운행 비용일지"
string dataobject = "d_pig1003_16"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type gb_4 from groupbox within w_pig3009
integer x = 466
integer y = 5520
integer width = 768
integer height = 632
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "정렬"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pig3009
integer x = 2080
integer y = 96
integer width = 622
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "차량번호별 비용구분"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.DataObject = 'd_pig1003_16'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_pig1003_16_p'
dw_print.SetTransObject(sqlca)
end event

type rb_2 from radiobutton within w_pig3009
integer x = 2080
integer y = 180
integer width = 640
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "비용구분별 차량번호"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.DataObject = 'd_pig1003_17'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_pig1003_17_p'
dw_print.SetTransObject(sqlca)
end event

type gb_1 from groupbox within w_pig3009
integer x = 2021
integer y = 40
integer width = 727
integer height = 244
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pig3009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 328
integer width = 4608
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pig3009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 16
integer width = 2766
integer height = 300
integer cornerheight = 40
integer cornerwidth = 55
end type

