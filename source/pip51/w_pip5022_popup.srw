$PBExportHeader$w_pip5022_popup.srw
$PBExportComments$** 퇴직금 계산(선택)
forward
global type w_pip5022_popup from w_inherite_popup
end type
type sle_name from singlelineedit within w_pip5022_popup
end type
type sle_empno from singlelineedit within w_pip5022_popup
end type
type st_2 from statictext within w_pip5022_popup
end type
type ln_1 from line within w_pip5022_popup
end type
type ln_2 from line within w_pip5022_popup
end type
type rr_3 from roundrectangle within w_pip5022_popup
end type
end forward

global type w_pip5022_popup from w_inherite_popup
integer x = 626
integer y = 12
integer width = 1385
integer height = 1284
string title = "사원 조회 선택"
boolean controlmenu = true
sle_name sle_name
sle_empno sle_empno
st_2 st_2
ln_1 ln_1
ln_2 ln_2
rr_3 rr_3
end type
global w_pip5022_popup w_pip5022_popup

type variables
String sgubn 
int ls_seq
end variables

forward prototypes
public subroutine wf_retrieve (string sempno)
end prototypes

public subroutine wf_retrieve (string sempno);
dw_1.Retrieve(sempno)

end subroutine

event open;call super::open;string sempno, sname , stext

muiltstr l_str_parms 
l_str_parms = Message.PowerObjectParm

sempno = l_str_parms.s[1]
sname= l_str_parms.s[2]

wf_retrieve(sempno)

sle_empno.text= sempno
sle_name.text= sname


end event

on w_pip5022_popup.create
int iCurrent
call super::create
this.sle_name=create sle_name
this.sle_empno=create sle_empno
this.st_2=create st_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_name
this.Control[iCurrent+2]=this.sle_empno
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ln_1
this.Control[iCurrent+5]=this.ln_2
this.Control[iCurrent+6]=this.rr_3
end on

on w_pip5022_popup.destroy
call super::destroy
destroy(this.sle_name)
destroy(this.sle_empno)
destroy(this.st_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_3)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_pip5022_popup
boolean visible = false
integer x = 0
integer y = 2780
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_pip5022_popup
integer x = 1170
integer y = 16
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pip5022_popup
boolean visible = false
integer x = 1966
integer y = 2384
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_pip5022_popup
integer x = 997
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "fromdate")
gs_codename = dw_1.GetItemString(ll_Row, "todate")

Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_pip5022_popup
integer x = 27
integer y = 184
integer width = 1289
integer height = 1008
string dataobject = "d_pip5022_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "fromdate")
gs_codename = dw_1.GetItemString(Row, "todate")

Close(Parent) 


end event

type sle_2 from w_inherite_popup`sle_2 within w_pip5022_popup
boolean visible = false
integer y = 2656
end type

type cb_1 from w_inherite_popup`cb_1 within w_pip5022_popup
boolean visible = false
integer y = 2404
end type

type cb_return from w_inherite_popup`cb_return within w_pip5022_popup
boolean visible = false
integer y = 2404
end type

type cb_inq from w_inherite_popup`cb_inq within w_pip5022_popup
boolean visible = false
integer y = 2404
end type

type sle_1 from w_inherite_popup`sle_1 within w_pip5022_popup
boolean visible = false
integer y = 2656
end type

type st_1 from w_inherite_popup`st_1 within w_pip5022_popup
boolean visible = false
integer y = 2668
end type

type sle_name from singlelineedit within w_pip5022_popup
integer x = 503
integer y = 64
integer width = 439
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 20
boolean displayonly = true
end type

type sle_empno from singlelineedit within w_pip5022_popup
integer x = 201
integer y = 64
integer width = 288
integer height = 64
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 20
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_pip5022_popup
integer x = 32
integer y = 72
integer width = 165
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "사 원"
boolean focusrectangle = false
end type

type ln_1 from line within w_pip5022_popup
integer linethickness = 1
integer beginx = 201
integer beginy = 128
integer endx = 489
integer endy = 128
end type

type ln_2 from line within w_pip5022_popup
integer linethickness = 1
integer beginx = 503
integer beginy = 128
integer endx = 942
integer endy = 128
end type

type rr_3 from roundrectangle within w_pip5022_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 172
integer width = 1330
integer height = 1028
integer cornerheight = 40
integer cornerwidth = 55
end type

