$PBExportHeader$w_keypad_popup.srw
$PBExportComments$수량입력 Key Board 창
forward
global type w_keypad_popup from window
end type
type pb_15 from picturebutton within w_keypad_popup
end type
type pb_14 from picturebutton within w_keypad_popup
end type
type pb_13 from picturebutton within w_keypad_popup
end type
type pb_12 from picturebutton within w_keypad_popup
end type
type pb_11 from picturebutton within w_keypad_popup
end type
type pb_10 from picturebutton within w_keypad_popup
end type
type pb_9 from picturebutton within w_keypad_popup
end type
type pb_8 from picturebutton within w_keypad_popup
end type
type pb_7 from picturebutton within w_keypad_popup
end type
type pb_6 from picturebutton within w_keypad_popup
end type
type pb_5 from picturebutton within w_keypad_popup
end type
type pb_4 from picturebutton within w_keypad_popup
end type
type pb_3 from picturebutton within w_keypad_popup
end type
type pb_2 from picturebutton within w_keypad_popup
end type
type pb_1 from picturebutton within w_keypad_popup
end type
type st_count from statictext within w_keypad_popup
end type
type dw_1 from datawindow within w_keypad_popup
end type
type r_1 from rectangle within w_keypad_popup
end type
end forward

global type w_keypad_popup from window
integer x = 5
integer y = 4
integer width = 1682
integer height = 2272
boolean titlebar = true
string title = "화상키보드(현장)"
windowtype windowtype = response!
long backcolor = 32106727
string icon = "C:\POPMAN\ICO\popman.ico"
pb_15 pb_15
pb_14 pb_14
pb_13 pb_13
pb_12 pb_12
pb_11 pb_11
pb_10 pb_10
pb_9 pb_9
pb_8 pb_8
pb_7 pb_7
pb_6 pb_6
pb_5 pb_5
pb_4 pb_4
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
st_count st_count
dw_1 dw_1
r_1 r_1
end type
global w_keypad_popup w_keypad_popup

type variables
string is_gubun, is_code
end variables

on w_keypad_popup.create
this.pb_15=create pb_15
this.pb_14=create pb_14
this.pb_13=create pb_13
this.pb_12=create pb_12
this.pb_11=create pb_11
this.pb_10=create pb_10
this.pb_9=create pb_9
this.pb_8=create pb_8
this.pb_7=create pb_7
this.pb_6=create pb_6
this.pb_5=create pb_5
this.pb_4=create pb_4
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_count=create st_count
this.dw_1=create dw_1
this.r_1=create r_1
this.Control[]={this.pb_15,&
this.pb_14,&
this.pb_13,&
this.pb_12,&
this.pb_11,&
this.pb_10,&
this.pb_9,&
this.pb_8,&
this.pb_7,&
this.pb_6,&
this.pb_5,&
this.pb_4,&
this.pb_3,&
this.pb_2,&
this.pb_1,&
this.st_count,&
this.dw_1,&
this.r_1}
end on

on w_keypad_popup.destroy
destroy(this.pb_15)
destroy(this.pb_14)
destroy(this.pb_13)
destroy(this.pb_12)
destroy(this.pb_11)
destroy(this.pb_10)
destroy(this.pb_9)
destroy(this.pb_8)
destroy(this.pb_7)
destroy(this.pb_6)
destroy(this.pb_5)
destroy(this.pb_4)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_count)
destroy(this.dw_1)
destroy(this.r_1)
end on

event open;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////     이동옥      2007.06.19         ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 사용자 key Board
//This.x = Pointerx()
//This.y = Pointery()

f_window_center(this)

string	sTime

/*gs_gubun '1' 수량 입력  '2' 시간입력*/
/*gs_code  초기값*/

is_gubun = gs_gubun
is_code	= gs_code
SetNull(gs_gubun)

if is_gubun = '1' then
	dw_1.dataobject = 'd_keypad_popup_1'
else
	dw_1.dataobject = 'd_keypad_popup_2'	
end if

dw_1.insertrow(0)


if is_gubun = '1' then
	if is_code = '' or isnull(is_code) then
	else
		dw_1.setitem(1, 'nu', is_code)
	end if
else
	if is_code = '' or isnull(is_code) then
		
		SELECT	TO_CHAR(SYSDATE, 'HH24MI')
		  into	:sTime
		  FROM	DUAL;
		  
		dw_1.setitem(1, 'nu', sTime)
	else
		dw_1.setitem(1, 'nu', is_code)
	end if	
end if

dw_1.SetFocus()

end event

type pb_15 from picturebutton within w_keypad_popup
integer x = 571
integer y = 400
integer width = 517
integer height = 340
integer taborder = 30
integer textsize = -24
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "지우기"
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;if dw_1.accepttext( ) = -1 then	return
	
dw_1.Setitem(1, 'nu', '')
dw_1.SetFocus()

end event

type pb_14 from picturebutton within w_keypad_popup
integer x = 1106
integer y = 1812
integer width = 517
integer height = 340
integer taborder = 80
integer textsize = -48
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "←"
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////     이동옥      2007.06.19         ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

String ls_org
Long	 ll_length

if	dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org <> '' and Not IsNull( ls_org ) then
	
	ll_length = len( ls_org )
	
	dw_1.SetItem( 1, 'nu', Left(ls_org, ll_length - 1 )  )

End If
end event

type pb_13 from picturebutton within w_keypad_popup
integer x = 571
integer y = 1812
integer width = 517
integer height = 340
integer taborder = 70
integer textsize = -48
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "."
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org
int	 i
if dw_1.AcceptText() = -1 then return

/*시간일경우 처리 안함*/
if is_gubun = '2' then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	return
Else
	for i = 1 to len(ls_org)
		if right(left(ls_org, i), 1) = '.' then
			return
		end if
	next
	
	
	ls_org = ls_org + '.'
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_12 from picturebutton within w_keypad_popup
integer x = 37
integer y = 1812
integer width = 517
integer height = 340
integer taborder = 60
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "0"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '0'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '0'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '0'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_11 from picturebutton within w_keypad_popup
integer x = 1106
integer y = 1460
integer width = 517
integer height = 340
integer taborder = 50
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "9"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '9'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '9'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '9'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_10 from picturebutton within w_keypad_popup
integer x = 571
integer y = 1460
integer width = 517
integer height = 340
integer taborder = 40
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "8"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '8'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '8'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '8'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_9 from picturebutton within w_keypad_popup
integer x = 37
integer y = 1460
integer width = 517
integer height = 340
integer taborder = 30
integer textsize = -36
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "7"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '7'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '7'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '7'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_8 from picturebutton within w_keypad_popup
integer x = 1106
integer y = 1108
integer width = 517
integer height = 340
integer taborder = 150
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "6"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '6'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '6'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '6'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_7 from picturebutton within w_keypad_popup
integer x = 571
integer y = 1108
integer width = 517
integer height = 340
integer taborder = 140
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "5"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '5'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '5'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '5'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_6 from picturebutton within w_keypad_popup
integer x = 37
integer y = 1108
integer width = 517
integer height = 340
integer taborder = 100
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "4"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '4'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '4'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '4'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_5 from picturebutton within w_keypad_popup
integer x = 1106
integer y = 756
integer width = 517
integer height = 340
integer taborder = 110
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "3"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '3'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '3'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '3'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_4 from picturebutton within w_keypad_popup
integer x = 571
integer y = 756
integer width = 517
integer height = 340
integer taborder = 120
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "2"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '2'
Else
	if is_gubun = '1' then
		ls_org = ls_org + '2'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '2'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type pb_3 from picturebutton within w_keypad_popup
integer x = 1106
integer y = 404
integer width = 517
integer height = 340
integer taborder = 20
integer textsize = -24
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기"
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////     이동옥      2007.06.19         ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SetNull(gs_code)
SetNull(gs_gubun)
Close(parent)
end event

type pb_2 from picturebutton within w_keypad_popup
integer x = 37
integer y = 400
integer width = 517
integer height = 340
integer taborder = 130
integer textsize = -24
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "입력"
string picturename = "c:\erpman\image\pop_but_in_ov.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;date dDate

if dw_1.accepttext( ) = -1 then	return
	
gs_code = dw_1.GetItemString( 1, 'nu' )

if is_gubun = '1' then				/*숫자*/
	If gs_code = '' or isnull(gs_code) then
		MessageBox('오류', '값을 입력하세요')
		SetNull(gs_code)
		return
	End If
else										/*시간*/

	if len( gs_code ) <> 4 then
		MessageBox('오류', '4자리로 입력하여야 합니다.')
		SetNull(gs_code)
		return		
	end if
	
	select to_date(:gs_code, 'hh24mi')
	  into :dDate
	  from dual;
	
	if sqlca.sqlcode <> 0 then
		MessageBox('오류', '잘못된 시간입니다.')
		SetNull(gs_code)
		return	
	end if
end if

Close(parent)
end event

type pb_1 from picturebutton within w_keypad_popup
integer x = 37
integer y = 756
integer width = 517
integer height = 340
integer taborder = 90
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "1"
string picturename = "c:\erpman\image\pop_but_in.gif"
vtextalign vtextalign = vcenter!
end type

event clicked;String ls_org

if dw_1.AcceptText() = -1 then return

ls_org = dw_1.GetItemString( 1, 'nu' )

If ls_org = '' or IsNull( ls_org ) then
	ls_org = '1'
Else
	
	if is_gubun = '1' then
		ls_org = ls_org + '1'
	else
		if len( ls_org ) < 4 then
			ls_org = ls_org + '1'
		end if
	end if
End If

dw_1.SetItem( 1, 'nu', ls_org )
dw_1.SetFocus()
end event

type st_count from statictext within w_keypad_popup
boolean visible = false
integer y = 2288
integer width = 850
integer height = 184
integer taborder = 10
boolean bringtotop = true
integer textsize = -28
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "1234567"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_keypad_popup
event ue_enterkey pbm_dwnkey
integer x = 50
integer y = 20
integer width = 1582
integer height = 328
integer taborder = 20
string dataobject = "d_keypad_popup_1"
boolean livescroll = true
end type

event ue_enterkey;Choose case key
	case keyenter!
		pb_2.TriggerEvent( Clicked! )
End Choose
end event

type r_1 from rectangle within w_keypad_popup
long linecolor = 255
integer linethickness = 6
long fillcolor = 16777215
integer x = 41
integer y = 12
integer width = 1600
integer height = 344
end type

