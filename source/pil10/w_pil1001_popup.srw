$PBExportHeader$w_pil1001_popup.srw
$PBExportComments$대여금관리마스타-사원조회popupwindow
forward
global type w_pil1001_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_pil1001_popup
end type
type rr_1 from roundrectangle within w_pil1001_popup
end type
type ln_3 from line within w_pil1001_popup
end type
type ln_8 from line within w_pil1001_popup
end type
end forward

global type w_pil1001_popup from w_inherite_popup
integer x = 2208
integer width = 1010
integer height = 1512
string title = "대여금관리마스타-사원조회"
boolean controlmenu = true
rr_2 rr_2
rr_1 rr_1
ln_3 ln_3
ln_8 ln_8
end type
global w_pil1001_popup w_pil1001_popup

on w_pil1001_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
this.ln_3=create ln_3
this.ln_8=create ln_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.ln_3
this.Control[iCurrent+4]=this.ln_8
end on

on w_pil1001_popup.destroy
call super::destroy
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.ln_3)
destroy(this.ln_8)
end on

event open;call super::open;f_Window_Center_Response(This)
String scode,sname

IF IsNull(gs_code) THEN gs_code =""
IF IsNull(gs_codename) THEN gs_codename =""

sle_1.text = gs_code
sle_2.text = gs_codename

scode = trim(sle_1.text +'%')
sname = '%' + sle_2.text + '%'

dw_1.Retrieve(scode,sname)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pil1001_popup
boolean visible = false
integer x = 14
integer y = 1756
end type

type p_exit from w_inherite_popup`p_exit within w_pil1001_popup
integer x = 777
integer y = 1260
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(Gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pil1001_popup
integer x = 430
integer y = 1260
end type

event p_inq::clicked;call super::clicked;String scode,sname

scode = trim(sle_1.text +'%')
sname = trim('%' + sle_2.text + '%')

IF dw_1.Retrieve(scode,sname) <=0 THEN
	MessageBox("확 인", "검색된 내역이 없습니다.!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_pil1001_popup
integer x = 603
integer y = 1260
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "p3_lendmst_empno")
Gs_codename = dw_1.GetItemString(ll_Row, "p1_master_empname")
Close(Parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_pil1001_popup
integer x = 37
integer y = 180
integer width = 919
integer height = 1064
integer taborder = 30
string dataobject = "d_pil1001_popup"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return

END IF

gs_code = dw_1.GetItemString(Row, "p3_lendmst_empno")
Gs_codename = dw_1.GetItemString(Row, "p1_master_empname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pil1001_popup
integer x = 471
integer y = 64
integer width = 430
integer height = 60
end type

type cb_1 from w_inherite_popup`cb_1 within w_pil1001_popup
boolean visible = false
integer x = 82
integer taborder = 40
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "p3_lendmst_empno")
Gs_codename = dw_1.GetItemString(ll_Row, "p1_master_empname")
Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_pil1001_popup
boolean visible = false
integer x = 695
integer taborder = 60
end type

event cb_return::clicked;
SetNull(gs_code)
SetNull(Gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_pil1001_popup
boolean visible = false
integer x = 389
integer taborder = 50
end type

event cb_inq::clicked;String scode,sname

scode = trim(sle_1.text +'%')
sname = trim('%' + sle_2.text + '%')

IF dw_1.Retrieve(scode,sname) <=0 THEN
	MessageBox("확 인", "검색된 내역이 없습니다.!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type sle_1 from w_inherite_popup`sle_1 within w_pil1001_popup
integer x = 256
integer y = 64
integer width = 201
integer height = 60
long backcolor = 1090519039
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_pil1001_popup
integer x = 41
integer y = 72
integer width = 215
long backcolor = 33027312
boolean enabled = true
string text = "사원명"
end type

type rr_2 from roundrectangle within w_pil1001_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 36
integer width = 933
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pil1001_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 942
integer height = 1080
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_3 from line within w_pil1001_popup
integer linethickness = 1
integer beginx = 256
integer beginy = 124
integer endx = 457
integer endy = 124
end type

type ln_8 from line within w_pil1001_popup
integer linethickness = 1
integer beginx = 471
integer beginy = 124
integer endx = 901
integer endy = 124
end type

