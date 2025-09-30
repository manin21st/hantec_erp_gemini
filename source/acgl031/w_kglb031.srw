$PBExportHeader$w_kglb031.srw
$PBExportComments$ÀüÇ¥ °Ë»ö-Á¤·Ä Á¶°Ç
forward
global type w_kglb031 from window
end type
type p_current5 from picture within w_kglb031
end type
type p_current4 from picture within w_kglb031
end type
type p_current3 from picture within w_kglb031
end type
type p_current2 from picture within w_kglb031
end type
type p_current1 from picture within w_kglb031
end type
type st_2 from statictext within w_kglb031
end type
type st_3 from statictext within w_kglb031
end type
type rb_desc5 from radiobutton within w_kglb031
end type
type rb_desc4 from radiobutton within w_kglb031
end type
type rb_desc3 from radiobutton within w_kglb031
end type
type rb_desc2 from radiobutton within w_kglb031
end type
type rb_asc5 from radiobutton within w_kglb031
end type
type rb_asc4 from radiobutton within w_kglb031
end type
type rb_asc3 from radiobutton within w_kglb031
end type
type rb_asc2 from radiobutton within w_kglb031
end type
type rb_desc1 from radiobutton within w_kglb031
end type
type rb_asc1 from radiobutton within w_kglb031
end type
type sle_columnname5 from singlelineedit within w_kglb031
end type
type sle_columnname4 from singlelineedit within w_kglb031
end type
type sle_columnname3 from singlelineedit within w_kglb031
end type
type sle_columnname2 from singlelineedit within w_kglb031
end type
type sle_columnname1 from singlelineedit within w_kglb031
end type
type sle_columntitle5 from singlelineedit within w_kglb031
end type
type sle_columntitle4 from singlelineedit within w_kglb031
end type
type sle_columntitle3 from singlelineedit within w_kglb031
end type
type sle_columntitle2 from singlelineedit within w_kglb031
end type
type lb_columnname from listbox within w_kglb031
end type
type sle_columntitle1 from singlelineedit within w_kglb031
end type
type lb_columntitle from listbox within w_kglb031
end type
type gb_1 from groupbox within w_kglb031
end type
type gb_2 from groupbox within w_kglb031
end type
type gb_3 from groupbox within w_kglb031
end type
type gb_4 from groupbox within w_kglb031
end type
type gb_5 from groupbox within w_kglb031
end type
type cb_1 from commandbutton within w_kglb031
end type
type cb_2 from commandbutton within w_kglb031
end type
type cb_3 from commandbutton within w_kglb031
end type
type gb_6 from groupbox within w_kglb031
end type
type gb_7 from groupbox within w_kglb031
end type
end forward

global type w_kglb031 from window
integer x = 709
integer y = 744
integer width = 2254
integer height = 932
boolean titlebar = true
string title = "Á¤·Ä"
windowtype windowtype = response!
long backcolor = 32106727
event ue_asign_obj pbm_custom01
p_current5 p_current5
p_current4 p_current4
p_current3 p_current3
p_current2 p_current2
p_current1 p_current1
st_2 st_2
st_3 st_3
rb_desc5 rb_desc5
rb_desc4 rb_desc4
rb_desc3 rb_desc3
rb_desc2 rb_desc2
rb_asc5 rb_asc5
rb_asc4 rb_asc4
rb_asc3 rb_asc3
rb_asc2 rb_asc2
rb_desc1 rb_desc1
rb_asc1 rb_asc1
sle_columnname5 sle_columnname5
sle_columnname4 sle_columnname4
sle_columnname3 sle_columnname3
sle_columnname2 sle_columnname2
sle_columnname1 sle_columnname1
sle_columntitle5 sle_columntitle5
sle_columntitle4 sle_columntitle4
sle_columntitle3 sle_columntitle3
sle_columntitle2 sle_columntitle2
lb_columnname lb_columnname
sle_columntitle1 sle_columntitle1
lb_columntitle lb_columntitle
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
gb_6 gb_6
gb_7 gb_7
end type
global w_kglb031 w_kglb031

type variables
singlelineedit current_sle_title, current_sle_name

SingleLineEdit iv_sle_columnname[5]
RadioButton iv_rb_asc[5]

end variables

forward prototypes
public subroutine wf_setfocus (integer il_current)
end prototypes

event ue_asign_obj;iv_sle_columnname[1] = sle_columnname1
iv_sle_columnname[2] = sle_columnname2
iv_sle_columnname[3] = sle_columnname3
iv_sle_columnname[4] = sle_columnname4
iv_sle_columnname[5] = sle_columnname5

iv_rb_asc[1] = rb_asc1
iv_rb_asc[2] = rb_asc2
iv_rb_asc[3] = rb_asc3
iv_rb_asc[4] = rb_asc4
iv_rb_asc[5] = rb_asc5

end event

public subroutine wf_setfocus (integer il_current);
CHOOSE CASE il_current
	CASE 1
		p_current1.Visible = True
		p_current2.Visible = False
		p_current3.Visible = False
		p_current4.Visible = False
		p_current5.Visible = False
		
		sle_columntitle1.SetFocus()
	CASE 2
		p_current1.Visible = False
		p_current2.Visible = True
		p_current3.Visible = False
		p_current4.Visible = False
		p_current5.Visible = False
		
		sle_columntitle2.SetFocus()
	CASE 3
		p_current1.Visible = False
		p_current2.Visible = False
		p_current3.Visible = True
		p_current4.Visible = False
		p_current5.Visible = False
		
		sle_columntitle3.SetFocus()
	CASE 4
		p_current1.Visible = False
		p_current2.Visible = False
		p_current3.Visible = False
		p_current4.Visible = True
		p_current5.Visible = False
		
		sle_columntitle4.SetFocus()
	CASE 5
		p_current1.Visible = False
		p_current2.Visible = False
		p_current3.Visible = False
		p_current4.Visible = False
		p_current5.Visible = True
		
		sle_columntitle5.SetFocus()
END CHOOSE

end subroutine

event open;st_cond_qry_sort_parm	st_Sort_parm
Integer						i

F_Window_Center_Response(This)

p_current1.picturename = "next1.bmp"
p_current2.picturename = "next1.bmp"
p_current3.picturename = "next1.bmp"
p_current4.picturename = "next1.bmp"
p_current5.picturename = "next1.bmp"

st_sort_parm = Message.PowerObjectParm

For i = 1 to st_sort_parm.lb_columnname.TotalItems()
	lb_columnname.AddItem(st_sort_parm.lb_columnName.Text(i))
	lb_columntitle.AddItem(st_sort_parm.lb_columnTitle.Text(i))
Next

PostEvent("ue_asign_obj")

Wf_SetFocus(1)



end event

on w_kglb031.create
this.p_current5=create p_current5
this.p_current4=create p_current4
this.p_current3=create p_current3
this.p_current2=create p_current2
this.p_current1=create p_current1
this.st_2=create st_2
this.st_3=create st_3
this.rb_desc5=create rb_desc5
this.rb_desc4=create rb_desc4
this.rb_desc3=create rb_desc3
this.rb_desc2=create rb_desc2
this.rb_asc5=create rb_asc5
this.rb_asc4=create rb_asc4
this.rb_asc3=create rb_asc3
this.rb_asc2=create rb_asc2
this.rb_desc1=create rb_desc1
this.rb_asc1=create rb_asc1
this.sle_columnname5=create sle_columnname5
this.sle_columnname4=create sle_columnname4
this.sle_columnname3=create sle_columnname3
this.sle_columnname2=create sle_columnname2
this.sle_columnname1=create sle_columnname1
this.sle_columntitle5=create sle_columntitle5
this.sle_columntitle4=create sle_columntitle4
this.sle_columntitle3=create sle_columntitle3
this.sle_columntitle2=create sle_columntitle2
this.lb_columnname=create lb_columnname
this.sle_columntitle1=create sle_columntitle1
this.lb_columntitle=create lb_columntitle
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_6=create gb_6
this.gb_7=create gb_7
this.Control[]={this.p_current5,&
this.p_current4,&
this.p_current3,&
this.p_current2,&
this.p_current1,&
this.st_2,&
this.st_3,&
this.rb_desc5,&
this.rb_desc4,&
this.rb_desc3,&
this.rb_desc2,&
this.rb_asc5,&
this.rb_asc4,&
this.rb_asc3,&
this.rb_asc2,&
this.rb_desc1,&
this.rb_asc1,&
this.sle_columnname5,&
this.sle_columnname4,&
this.sle_columnname3,&
this.sle_columnname2,&
this.sle_columnname1,&
this.sle_columntitle5,&
this.sle_columntitle4,&
this.sle_columntitle3,&
this.sle_columntitle2,&
this.lb_columnname,&
this.sle_columntitle1,&
this.lb_columntitle,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5,&
this.cb_1,&
this.cb_2,&
this.cb_3,&
this.gb_6,&
this.gb_7}
end on

on w_kglb031.destroy
destroy(this.p_current5)
destroy(this.p_current4)
destroy(this.p_current3)
destroy(this.p_current2)
destroy(this.p_current1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rb_desc5)
destroy(this.rb_desc4)
destroy(this.rb_desc3)
destroy(this.rb_desc2)
destroy(this.rb_asc5)
destroy(this.rb_asc4)
destroy(this.rb_asc3)
destroy(this.rb_asc2)
destroy(this.rb_desc1)
destroy(this.rb_asc1)
destroy(this.sle_columnname5)
destroy(this.sle_columnname4)
destroy(this.sle_columnname3)
destroy(this.sle_columnname2)
destroy(this.sle_columnname1)
destroy(this.sle_columntitle5)
destroy(this.sle_columntitle4)
destroy(this.sle_columntitle3)
destroy(this.sle_columntitle2)
destroy(this.lb_columnname)
destroy(this.sle_columntitle1)
destroy(this.lb_columntitle)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_6)
destroy(this.gb_7)
end on

type p_current5 from picture within w_kglb031
integer x = 55
integer y = 552
integer width = 73
integer height = 60
boolean originalsize = true
string picturename = "c:\autonics\pi\next1.bmp"
boolean focusrectangle = false
end type

type p_current4 from picture within w_kglb031
integer x = 55
integer y = 456
integer width = 73
integer height = 60
boolean originalsize = true
string picturename = "c:\autonics\pi\next1.bmp"
boolean focusrectangle = false
end type

type p_current3 from picture within w_kglb031
integer x = 55
integer y = 348
integer width = 73
integer height = 60
boolean originalsize = true
string picturename = "c:\autonics\pi\next1.bmp"
boolean focusrectangle = false
end type

type p_current2 from picture within w_kglb031
integer x = 55
integer y = 240
integer width = 73
integer height = 60
boolean originalsize = true
string picturename = "c:\autonics\pi\next1.bmp"
boolean focusrectangle = false
end type

type p_current1 from picture within w_kglb031
integer x = 55
integer y = 132
integer width = 73
integer height = 60
boolean originalsize = true
string picturename = "c:\autonics\pi\next1.bmp"
boolean focusrectangle = false
end type

type st_2 from statictext within w_kglb031
integer x = 142
integer y = 28
integer width = 466
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 16777215
long backcolor = 28144969
boolean enabled = false
string text = "Á¤·Ä Ç×¸ñ"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_kglb031
integer x = 626
integer y = 28
integer width = 855
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 16777215
long backcolor = 28144969
boolean enabled = false
string text = "Á¤·Ä ¼ø¼­"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type rb_desc5 from radiobutton within w_kglb031
integer x = 1083
integer y = 556
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8421376
long backcolor = 32106727
boolean enabled = false
string text = "³»¸²Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_desc4 from radiobutton within w_kglb031
integer x = 1083
integer y = 448
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8421376
long backcolor = 32106727
boolean enabled = false
string text = "³»¸²Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_desc3 from radiobutton within w_kglb031
integer x = 1083
integer y = 344
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8421376
long backcolor = 32106727
boolean enabled = false
string text = "³»¸²Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_desc2 from radiobutton within w_kglb031
integer x = 1083
integer y = 244
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8421376
long backcolor = 32106727
boolean enabled = false
string text = "³»¸²Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_asc5 from radiobutton within w_kglb031
integer x = 654
integer y = 556
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "¿À¸§Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_asc4 from radiobutton within w_kglb031
integer x = 654
integer y = 448
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "¿À¸§Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_asc3 from radiobutton within w_kglb031
integer x = 654
integer y = 344
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "¿À¸§Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_asc2 from radiobutton within w_kglb031
integer x = 654
integer y = 244
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "¿À¸§Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_desc1 from radiobutton within w_kglb031
integer x = 1083
integer y = 136
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8421376
long backcolor = 32106727
boolean enabled = false
string text = "³»¸²Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type rb_asc1 from radiobutton within w_kglb031
integer x = 654
integer y = 136
integer width = 357
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "¿À¸§Â÷¼ø"
borderstyle borderstyle = stylelowered!
end type

type sle_columnname5 from singlelineedit within w_kglb031
integer x = 2286
integer y = 1356
integer width = 421
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_columnname4 from singlelineedit within w_kglb031
integer x = 2286
integer y = 1252
integer width = 421
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_columnname3 from singlelineedit within w_kglb031
integer x = 2286
integer y = 1148
integer width = 421
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_columnname2 from singlelineedit within w_kglb031
integer x = 2281
integer y = 1044
integer width = 421
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_columnname1 from singlelineedit within w_kglb031
integer x = 2286
integer y = 940
integer width = 421
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_columntitle5 from singlelineedit within w_kglb031
event ue_rbclear pbm_custom01
integer x = 142
integer y = 540
integer width = 466
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

on ue_rbclear;rb_asc5.Checked = False
rb_desc5.Checked = False
rb_asc5.Enabled = False
rb_desc5.Enabled = False

end on

on modified;This.Text = Trim(This.Text)
If Len(This.Text) <> 0 Then
	rb_asc5.Enabled = True; rb_asc5.Checked = True
	rb_desc5.Enabled = True
Else
	rb_asc5.Enabled = False
	rb_desc5.Enabled = False
End If

end on

event losefocus;//current_sle_title = This
//current_sle_name = sle_columnname5

end event

event getfocus;current_sle_title = This
current_sle_name = sle_columnname5

Wf_SetFocus(5)
end event

type sle_columntitle4 from singlelineedit within w_kglb031
event ue_rbclear pbm_custom01
integer x = 142
integer y = 432
integer width = 466
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

on ue_rbclear;rb_asc4.Checked = False
rb_desc4.Checked = False
rb_asc4.Enabled = False
rb_desc4.Enabled = False

end on

on modified;This.Text = Trim(This.Text)
If Len(This.Text) <> 0 Then
	rb_asc4.Enabled = True; rb_asc4.Checked = True
	rb_desc4.Enabled = True
Else
	rb_asc4.Enabled = False
	rb_desc4.Enabled = False
End If

end on

event losefocus;//current_sle_title = This
//current_sle_name = sle_columnname4
//
end event

event getfocus;current_sle_title = This
current_sle_name = sle_columnname4

Wf_SetFocus(4)
end event

type sle_columntitle3 from singlelineedit within w_kglb031
event ue_rbclear pbm_custom01
integer x = 142
integer y = 328
integer width = 466
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

on ue_rbclear;rb_asc3.Checked = False
rb_desc3.Checked = False
rb_asc3.Enabled = False
rb_desc3.Enabled = False

end on

on modified;This.Text = Trim(This.Text)
If Len(This.Text) <> 0 Then
	rb_asc3.Enabled = True; rb_asc3.Checked = True
	rb_desc3.Enabled = True
Else
	rb_asc3.Enabled = False
	rb_desc3.Enabled = False
End If

end on

event losefocus;//current_sle_title = This
//current_sle_name = sle_columnname3

end event

event getfocus;current_sle_title = This
current_sle_name = sle_columnname3

Wf_SetFocus(3)
end event

type sle_columntitle2 from singlelineedit within w_kglb031
event ue_rbclear pbm_custom01
integer x = 142
integer y = 224
integer width = 466
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

on ue_rbclear;rb_asc2.Checked = False
rb_desc2.Checked = False
rb_asc2.Enabled = False
rb_desc2.Enabled = False

end on

event modified;This.Text = Trim(This.Text)
If Len(This.Text) <> 0 Then
	rb_asc2.Enabled = True; rb_asc2.Checked = True
	rb_desc2.Enabled = True
	
Else
	rb_asc2.Enabled = False
	rb_desc2.Enabled = False
End If

end event

event losefocus;//current_sle_title = This
//current_sle_name = sle_columnname2

end event

event getfocus;current_sle_title = This
current_sle_name = sle_columnname2

Wf_SetFocus(2)
end event

type lb_columnname from listbox within w_kglb031
integer x = 2688
integer y = 928
integer width = 475
integer height = 528
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 16777215
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type sle_columntitle1 from singlelineedit within w_kglb031
event ue_rbclear pbm_custom01
integer x = 142
integer y = 120
integer width = 466
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 8388736
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

on ue_rbclear;rb_asc1.Checked = False
rb_desc1.Checked = False
rb_asc1.Enabled = False
rb_desc1.Enabled = False

end on

event modified;This.Text = Trim(This.Text)

If Len(This.Text) <> 0 Then
	rb_asc1.Enabled = True; rb_asc1.Checked = True
	rb_desc1.Enabled = True
	
Else
	rb_asc1.Enabled = False
	rb_desc1.Enabled = False
End If

end event

event losefocus;//current_sle_title = This
//current_sle_name = sle_columnname1

end event

event getfocus;
current_sle_title = This
current_sle_name = sle_columnname1

Wf_SetFocus(1)

end event

type lb_columntitle from listbox within w_kglb031
integer x = 1486
integer y = 112
integer width = 704
integer height = 524
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 15269887
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;current_sle_title.Text = This.SelectedItem()
current_sle_title.PostEvent(Modified!)

lb_columnname.SelectItem(This.SelectedIndex())
current_sle_name.Text = lb_columnname.SelectedItem()

end event

type gb_1 from groupbox within w_kglb031
integer x = 626
integer y = 84
integer width = 855
integer height = 132
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_kglb031
integer x = 626
integer y = 192
integer width = 855
integer height = 132
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_kglb031
integer x = 626
integer y = 296
integer width = 855
integer height = 132
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_kglb031
integer x = 626
integer y = 400
integer width = 855
integer height = 132
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_5 from groupbox within w_kglb031
integer x = 626
integer y = 504
integer width = 855
integer height = 132
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_kglb031
integer x = 1312
integer y = 680
integer width = 416
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
string text = "È®ÀÎ"
boolean default = true
end type

on clicked;Integer	i
String	ls_Sort_Syntax

ls_Sort_Syntax = ""

If sle_columnname1.Text <> "" Then
	ls_Sort_Syntax = sle_columnname1.Text
	If rb_asc1.Checked Then
		ls_Sort_Syntax = ls_Sort_Syntax + " A"
	Else
		ls_Sort_Syntax = ls_Sort_Syntax + " D"
	End If
End If

For i = 2 To 5
	If iv_sle_columnname[i].Text <> "" Then
		If ls_Sort_Syntax <> "" Then
			ls_Sort_Syntax = ls_Sort_Syntax + ", " + iv_sle_columnname[i].Text
		Else
			ls_Sort_Syntax = iv_sle_columnname[i].Text
		End If

		If iv_rb_asc[i].Checked Then
			ls_Sort_Syntax = ls_Sort_Syntax + " A"
		Else
			ls_Sort_Syntax = ls_Sort_Syntax + " D"
		End If
	End If
Next

CloseWithReturn(Parent, ls_Sort_Syntax)

end on

type cb_2 from commandbutton within w_kglb031
integer x = 1746
integer y = 680
integer width = 416
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
string text = "Ãë¼Ò"
end type

on clicked;CloseWithReturn(Parent, "")

end on

type cb_3 from commandbutton within w_kglb031
integer x = 174
integer y = 680
integer width = 416
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
string text = "Áö¿ì±â"
end type

on clicked;current_sle_title.Text = ""
current_sle_name.Text = ""
current_sle_title.PostEvent("ue_rbclear")

end on

type gb_6 from groupbox within w_kglb031
integer x = 1280
integer y = 632
integer width = 914
integer height = 172
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type gb_7 from groupbox within w_kglb031
integer x = 142
integer y = 632
integer width = 480
integer height = 172
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "±¼¸²Ã¼"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

