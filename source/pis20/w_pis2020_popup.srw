$PBExportHeader$w_pis2020_popup.srw
$PBExportComments$복지회대출 신청 조회 선택
forward
global type w_pis2020_popup from w_inherite_popup
end type
type sle_empnm from singlelineedit within w_pis2020_popup
end type
type sle_empno from singlelineedit within w_pis2020_popup
end type
type st_2 from statictext within w_pis2020_popup
end type
type rr_1 from roundrectangle within w_pis2020_popup
end type
type rr_2 from roundrectangle within w_pis2020_popup
end type
end forward

global type w_pis2020_popup from w_inherite_popup
integer width = 3291
integer height = 1740
sle_empnm sle_empnm
sle_empno sle_empno
st_2 st_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pis2020_popup w_pis2020_popup

event open;call super::open;
String sEmpNo,ls_parm

f_window_center_response(this)

dw_1.SetTransObject(SQLCA)

ls_parm = Message.StringParm

if ls_parm = '1' then				/*복지회*/
	this.Title = '복지회 대출 조회 선택'
else
	this.Title = '근로복지기금 대출 조회 선택'
end if

sEmpNo = Gs_Code
if sEmpNo = '' or IsNull(sEmpNo) or sEmpNo = '%' then
	sle_empno.text =''
	sle_empnm.text =''
else
	sle_empno.text = sEmpNo
	sle_empnm.text = F_Get_EmpName(sEmpNo)
end if

dw_1.Reset()

dw_1.Retrieve(trim(ls_parm),sEmpNo)
 


end event

on w_pis2020_popup.create
int iCurrent
call super::create
this.sle_empnm=create sle_empnm
this.sle_empno=create sle_empno
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_empnm
this.Control[iCurrent+2]=this.sle_empno
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pis2020_popup.destroy
call super::destroy
destroy(this.sle_empnm)
destroy(this.sle_empno)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_pis2020_popup
boolean visible = false
integer x = 2542
integer y = 32
integer width = 265
integer height = 48
end type

type p_exit from w_inherite_popup`p_exit within w_pis2020_popup
integer x = 3017
integer y = 0
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)



end event

type p_inq from w_inherite_popup`p_inq within w_pis2020_popup
boolean visible = false
integer x = 3447
integer y = 28
end type

type p_choose from w_inherite_popup`p_choose within w_pis2020_popup
integer x = 2843
integer y = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

 
gs_code     = dw_1.GetItemString(ll_Row, "empno")
gs_codename = dw_1.GetItemString(ll_Row, "lenddate")
gs_gubun    = dw_1.GetItemString(ll_Row, "lendkind")

Close(Parent)


end event

type dw_1 from w_inherite_popup`dw_1 within w_pis2020_popup
integer x = 23
integer y = 168
integer width = 3191
integer height = 1448
string dataobject = "d_pis2020_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return

END IF

gs_code     = dw_1.GetItemString(Row, "empno")
gs_codename = dw_1.GetItemString(Row, "lenddate")
gs_gubun    = dw_1.GetItemString(Row, "lendkind")

Close(Parent)


end event

type sle_2 from w_inherite_popup`sle_2 within w_pis2020_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_pis2020_popup
end type

type cb_return from w_inherite_popup`cb_return within w_pis2020_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_pis2020_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_pis2020_popup
end type

type st_1 from w_inherite_popup`st_1 within w_pis2020_popup
end type

type sle_empnm from singlelineedit within w_pis2020_popup
integer x = 558
integer y = 40
integer width = 384
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
end type

type sle_empno from singlelineedit within w_pis2020_popup
integer x = 233
integer y = 40
integer width = 315
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
end type

type st_2 from statictext within w_pis2020_popup
integer x = 73
integer y = 52
integer width = 155
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "사번"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pis2020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 160
integer width = 3218
integer height = 1476
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pis2020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 16
integer width = 1019
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

