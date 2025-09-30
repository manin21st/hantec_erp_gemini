$PBExportHeader$w_pdt_02463.srw
$PBExportComments$출하검사 불량현황
forward
global type w_pdt_02463 from w_standard_dw_graph
end type
type rb_1 from radiobutton within w_pdt_02463
end type
type rb_2 from radiobutton within w_pdt_02463
end type
type st_1 from statictext within w_pdt_02463
end type
type rr_2 from roundrectangle within w_pdt_02463
end type
end forward

global type w_pdt_02463 from w_standard_dw_graph
string title = "출하 검사 불량현황"
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rr_2 rr_2
end type
global w_pdt_02463 w_pdt_02463

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sYm,sGubn

if dw_ip.AcceptText() = -1 then return -1

sYm =  trim(dw_ip.GetItemString(1,"sym"))

IF rb_1.Checked = TRUE THEN
   dw_list.DataObject =  "d_pdt_02463_2"
ELSE
   dw_list.DataObject =  "d_pdt_02463_3"
END IF

dw_list.SetTransObject(sqlca)
  
IF dw_list.Retrieve(gs_sabu, sYm) < 1 THEN
  f_message_chk(50,'')
  return -1
END IF

return 1
end function

on w_pdt_02463.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_pdt_02463.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"sym",left(f_today(),6))

end event

type p_exit from w_standard_dw_graph`p_exit within w_pdt_02463
end type

type p_print from w_standard_dw_graph`p_print within w_pdt_02463
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_pdt_02463
end type

type st_window from w_standard_dw_graph`st_window within w_pdt_02463
end type

type st_popup from w_standard_dw_graph`st_popup within w_pdt_02463
end type

type pb_title from w_standard_dw_graph`pb_title within w_pdt_02463
integer x = 3319
end type

type pb_space from w_standard_dw_graph`pb_space within w_pdt_02463
integer x = 3145
end type

type pb_color from w_standard_dw_graph`pb_color within w_pdt_02463
integer x = 2962
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_pdt_02463
integer x = 2784
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_pdt_02463
integer x = 105
integer y = 76
integer width = 613
integer height = 80
string dataobject = "d_pdt_02463_1"
end type

event dw_ip::itemerror;RETURN 1
end event

event dw_ip::itemchanged;string s_date, snull

setnull(snull)

IF this.GetColumnName() = 'sym' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date + '01') = -1 THEN
		f_message_chk(35,'[기준년월]')
		this.SetItem(1,"sym",snull)
		Return 1
	END IF
END IF
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_pdt_02463
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_pdt_02463
end type

type st_10 from w_standard_dw_graph`st_10 within w_pdt_02463
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_pdt_02463
integer x = 2752
end type

type dw_list from w_standard_dw_graph`dw_list within w_pdt_02463
string dataobject = "d_pdt_02463_2"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_pdt_02463
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_pdt_02463
end type

type rb_1 from radiobutton within w_pdt_02463
integer x = 1120
integer y = 76
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "생산팀별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_pdt_02463
integer x = 1536
integer y = 76
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전체"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pdt_02463
integer x = 837
integer y = 84
integer width = 256
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pdt_02463
integer linethickness = 1
long fillcolor = 33027312
integer x = 69
integer y = 48
integer width = 1842
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

