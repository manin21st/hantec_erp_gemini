$PBExportHeader$w_imt_05070.srw
$PBExportComments$발주 현황
forward
global type w_imt_05070 from w_standard_print
end type
type shl_1 from statichyperlink within w_imt_05070
end type
type shl_2 from statichyperlink within w_imt_05070
end type
type st_1 from statictext within w_imt_05070
end type
type st_2 from statictext within w_imt_05070
end type
type pb_1 from u_pb_cal within w_imt_05070
end type
type rr_1 from roundrectangle within w_imt_05070
end type
end forward

global type w_imt_05070 from w_standard_print
string title = "발주 현황"
string menuname = ""
shl_1 shl_1
shl_2 shl_2
st_1 st_1
st_2 st_2
pb_1 pb_1
rr_1 rr_1
end type
global w_imt_05070 w_imt_05070

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_bscdate, ls_from1,ls_from2,ls_from3,ls_from4,ls_from5
String   ls_yymm   , ls_to1,  ls_to2,  ls_to3,  ls_to4,  ls_to5          
String   ls_bscdate1,ls_bscdate2, ls_bscdate3, ls_bscdate4
String	ls_saupj, ls_balgu

ls_bscdate = Trim(dw_ip.GetItemString(1, 'bscdate'))
ls_yymm    = LEFT(ls_bscdate,6)

IF ls_bscdate = '' OR IsNull(ls_bscdate) THEN
	f_message_chk(30, '[기준일자]')
	dw_ip.SetFocus()
	Return -1
END IF

//조회조건 

ls_bscdate1 = f_afterday(ls_bscdate,7)
ls_bscdate2 = f_afterday(ls_bscdate,14)
ls_bscdate3 = f_afterday(ls_bscdate,21)
ls_bscdate4 = f_afterday(ls_bscdate,28)
f_weekly(ls_bscdate,  '1', '7',  ls_from1, ls_to1)
f_weekly(ls_bscdate1, '1', '7', ls_from2, ls_to2)
f_weekly(ls_bscdate2, '1', '7', ls_from3, ls_to3)
f_weekly(ls_bscdate3, '1', '7', ls_from4, ls_to4)
f_weekly(ls_bscdate4, '1', '7', ls_from5, ls_to5)

// head 처리

dw_list.object.w.text    = '[' + RIGHT(ls_from1,2) + '-' + RIGHT(ls_to1,2) + ']'
dw_list.object.w_1.text  = '[' + RIGHT(ls_from2,2) + '-' + RIGHT(ls_to2,2) + ']'
dw_list.object.w_2.text  = '[' + RIGHT(ls_from3,2) + '-' + RIGHT(ls_to3,2) + ']'
dw_list.object.w_3.text  = '[' + RIGHT(ls_from4,2) + '-' + RIGHT(ls_to4,2) + ']'
dw_list.object.w_4.text  = '[' + RIGHT(ls_from5,2) + '-' + RIGHT(ls_to5,2) + ']'
dw_list.object.m.text    = RIGHT(f_aftermonth(ls_yymm, 0),2) +'월'
dw_list.object.m_1.text  = RIGHT(f_aftermonth(ls_yymm, 1),2) +'월'
dw_list.object.m_2.text  = RIGHT(f_aftermonth(ls_yymm, 2),2) +'월'
dw_list.object.m_3.text  = RIGHT(f_aftermonth(ls_yymm, 3),2) +'월 이후'

ls_saupj = dw_ip.GetItemString(1, 'saupj')
IF ls_saupj = '' OR IsNull(ls_saupj) THEN ls_saupj = '%'

ls_balgu = dw_ip.GetItemString(1, 'balgu')
IF ls_balgu = '' OR IsNull(ls_balgu) THEN ls_balgu = '%'

IF dw_list.Retrieve(ls_from1,ls_to1, ls_from2, ls_to2, & 
                    ls_from3, ls_to3, ls_from4, ls_to4, ls_from5, ls_to5,ls_yymm, ls_saupj, ls_balgu) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_imt_05070.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.st_2=create st_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_imt_05070.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'bscdate', f_today())
f_mod_saupj(dw_ip, 'saupj')

SetNull(gs_gubun)
SetNull(gs_code)

//wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_imt_05070
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_imt_05070
end type

type p_print from w_standard_print`p_print within w_imt_05070
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_05070
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_imt_05070
end type



type dw_print from w_standard_print`dw_print within w_imt_05070
integer x = 3255
string dataobject = "d_imt_05070_1"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_05070
integer x = 32
integer y = 96
integer width = 2807
integer height = 152
string dataobject = "d_imt_05070"
end type

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

type dw_list from w_standard_print`dw_list within w_imt_05070
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 264
integer width = 4549
integer height = 2040
string dataobject = "d_imt_05070_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object, ls_Sort
Long	 ll_Row

IF this.Rowcount() < 1 then return 1

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 4)  = 'amt1' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '1')
ELSEIF mid(ls_Object, 1, 4)  = 'amt2' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '2')
ELSEIF mid(ls_Object, 1, 4)  = 'amt3' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '3')
ELSEIF mid(ls_Object, 1, 4)  = 'amt4' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '4')
ELSEIF mid(ls_Object, 1, 4)  = 'amt5' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '5')
ELSEIF mid(ls_Object, 1, 4)  = 'amt6' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '6')
ELSEIF mid(ls_Object, 1, 4)  = 'amt7' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '7')
ELSEIF mid(ls_Object, 1, 4)  = 'amt8' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '8')
ELSEIF mid(ls_Object, 1, 4)  = 'amt9' THEN 
   ll_Row = long(mid(ls_Object, 5, 5))
	this.setrow(ll_row)
  	this.setitem(ll_row, 'opt', '9')

ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF


end event

event dw_list::clicked;call super::clicked;String  ls_Object, ls_Opt, ls_bscdate, ls_bscdate1, ls_bscdate2, ls_bscdate3, ls_bscdate4
String  ls_month,  ls_month1, ls_month2, ls_month3, ls_balgu
Long	  ll_Row
String  ls_from1, ls_to1, ls_from2, ls_to2, ls_from3, ls_to3, ls_from4, ls_to4, ls_from5, ls_to5

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

//해당하는 Week의 구간이나 Month를 Global변수로 다음 Sheet로 넘겨준다.
ls_bscdate  = dw_ip.GetItemString(1,'bscdate')
ls_bscdate1 = f_afterday(ls_bscdate,7)
ls_bscdate2 = f_afterday(ls_bscdate,14)
ls_bscdate3 = f_afterday(ls_bscdate,21)
ls_bscdate4 = f_afterday(ls_bscdate,28)

f_weekly(ls_bscdate,  '1', '7',  ls_from1, ls_to1)
f_weekly(ls_bscdate1, '1', '7', ls_from2, ls_to2)
f_weekly(ls_bscdate2, '1', '7', ls_from3, ls_to3)
f_weekly(ls_bscdate3, '1', '7', ls_from4, ls_to4)
f_weekly(ls_bscdate4, '1', '7', ls_from5, ls_to5)
ls_month = LEFT(ls_bscdate,6)
ls_month1= f_aftermonth(ls_month,1)
ls_month2= f_aftermonth(ls_month,2)
ls_month3= f_aftermonth(ls_month,3)

IF mid(ls_Object, 1, 6)  = 'cvnas2' THEN
ELSE
   ll_Row = long(mid(ls_Object, 5, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 
   
	ls_Opt = This.GetItemString(ll_row,'opt')
   gs_gubun     =  This.GetItemString(ll_row, 'cvcod')
	gs_code      =  This.GetItemString(ll_row, 'cvnas2')
	
	ls_balgu = dw_ip.GetItemString(1, 'balgu')
	
	If IsNull(ls_balgu) or ls_balgu ='' Then ls_balgu ='%'

	If ls_Opt = '1' Then
      gs_codename  =  ls_from1
		gs_codename2 =  ls_to1
	ElseIf ls_Opt = '2' Then
      gs_codename  =  ls_from2
		gs_codename2 =  ls_to2
	ElseIf ls_Opt = '3' Then
      gs_codename  =  ls_from3
		gs_codename2 =  ls_to3
	ElseIf ls_Opt = '4' Then
      gs_codename  =  ls_from4
		gs_codename2 =  ls_to4
	ElseIf ls_Opt = '5' Then
      gs_codename  =  ls_from5
		gs_codename2 =  ls_to5
	ElseIf ls_Opt = '6' Then
      gs_codename  =  ls_month + '01'
		gs_codename2 =  ls_month + '31'
	ElseIf ls_Opt = '7' Then
      gs_codename  =  ls_month1 + '01'
		gs_codename2 =  ls_month1 + '31'
	ElseIf ls_Opt = '8' Then
      gs_codename  =  ls_month2 + '01'
		gs_codename2 =  ls_month2 + '31'
	ElseIf ls_Opt = '9' Then
      gs_codename  =  ls_month3 + '01'
		gs_codename2 =  ls_month3 + '31'
   End If
	
	OpenSheetWithParm(w_imt_05080,ls_balgu, w_mdi_frame, 0, Layered!)

END IF

end event

type shl_1 from statichyperlink within w_imt_05070
integer x = 69
integer y = 36
integer width = 251
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "기준일자"
alignment alignment = center!
end type

event clicked;//Boolean				lb_isopen
//Window				lw_window
//
//lb_isopen = FALSE
//lw_window = parent.GetFirstSheet()
//DO WHILE IsValid(lw_window)
//	if ClassName(lw_window) = 'w_pdt_09010' then
//		lb_isopen = TRUE
//		Exit
//	else		
//		lw_window = parent.GetNextSheet(lw_window)
//	end if
//LOOP
//if lb_isopen then
//	lw_window.windowstate = Normal!
//	lw_window.SetFocus()
//else	
//	OpenSheet(w_pdt_09010, w_mdi_frame, 0, Layered!)	
//end if
end event

type shl_2 from statichyperlink within w_imt_05070
boolean visible = false
integer x = 421
integer y = 36
integer width = 151
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "조별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_05070
boolean visible = false
integer x = 283
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_imt_05070
integer x = 4251
integer y = 200
integer width = 334
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 31778020
string text = "(단위:천원)"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_imt_05070
integer x = 1659
integer y = 112
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('bscdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'bscdate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_05070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

