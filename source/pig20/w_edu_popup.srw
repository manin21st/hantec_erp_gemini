$PBExportHeader$w_edu_popup.srw
$PBExportComments$교육훈련조회(부분) popup window - 계획신청자료에서 사용
forward
global type w_edu_popup from w_inherite_popup
end type
type st_5 from statictext within w_edu_popup
end type
type sle_gbn from singlelineedit within w_edu_popup
end type
type st_2 from statictext within w_edu_popup
end type
type sle_empno from singlelineedit within w_edu_popup
end type
type st_3 from statictext within w_edu_popup
end type
type em_year from editmask within w_edu_popup
end type
type rr_1 from roundrectangle within w_edu_popup
end type
type rr_2 from roundrectangle within w_edu_popup
end type
end forward

global type w_edu_popup from w_inherite_popup
integer x = 1467
integer y = 200
integer width = 2085
integer height = 1720
string title = "교육훈련계획조회 PopUp Window"
st_5 st_5
sle_gbn sle_gbn
st_2 st_2
sle_empno sle_empno
st_3 st_3
em_year em_year
rr_1 rr_1
rr_2 rr_2
end type
global w_edu_popup w_edu_popup

type variables
str_edu  istr_edu
end variables

event open;call super::open;string sgbn

istr_edu = Message.PowerObjectParm

sgbn = istr_edu.str_gbn

if trim(sgbn) = "P" then
	sle_gbn.text = "계획자료"
elseif trim(sgbn) = "R" then
	sle_gbn.text = "신청자료"	
end if

sle_empno.text = istr_edu.str_empno
em_year.text = istr_edu.str_eduyear

p_inq.TriggerEvent(Clicked!)
//
end event

on w_edu_popup.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_gbn=create sle_gbn
this.st_2=create st_2
this.sle_empno=create sle_empno
this.st_3=create st_3
this.em_year=create em_year
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_gbn
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_empno
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_year
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_edu_popup.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_gbn)
destroy(this.st_2)
destroy(this.sle_empno)
destroy(this.st_3)
destroy(this.em_year)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_edu_popup
boolean visible = false
integer x = 0
integer y = 2740
end type

type p_exit from w_inherite_popup`p_exit within w_edu_popup
integer x = 1879
integer y = 1468
integer width = 165
integer taborder = 0
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(istr_edu.str_empno)
SetNull(istr_edu.str_eduyear)
SetNull(istr_edu.str_empseq)
SetNull(istr_edu.str_gbn)

Closewithreturn(Parent, istr_edu)
//close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_edu_popup
integer x = 1719
integer y = 1468
integer width = 165
integer taborder = 0
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_empno, ls_eduyear, ls_gbn
//long ll_empseq

ls_empno = trim(istr_edu.str_empno)        // 사원번호
ls_eduyear = trim(em_year.text) +'%'  // 계획년도
// ls_empseq = long(trim(em_seq.text) +'%'  // 일련번호
ls_gbn = istr_edu.str_gbn


IF dw_1.Retrieve(gs_code, ls_empno , ls_eduyear, ls_gbn) <=0 THEN
	MessageBox("확 인", "검색된 자료가 ~n존재하지 않습니다.!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_edu_popup
integer x = 1559
integer y = 1468
integer width = 165
integer taborder = 0
end type

event p_choose::clicked;call super::clicked;Long ll_row	

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r다시 선택한후 선택버튼을 누르십시오.!!")
   return
END IF

//gs_code          =      dw_1.GetItemString(ll_Row,"p5_educations_p_companycode")        // 계획년도
istr_edu.str_empno   = dw_1.GetItemString(ll_Row, "p5_educations_p_empno")
istr_edu.str_eduyear = dw_1.GetItemString(ll_Row,"eduyear")
istr_edu.str_empseq  = dw_1.GetItemNumber(ll_Row,"p5_educations_p_empseq")
istr_edu.str_gbn     = dw_1.GetItemString(ll_Row,"bgubn")

Closewithreturn(Parent, istr_edu)
end event

type dw_1 from w_inherite_popup`dw_1 within w_edu_popup
integer x = 37
integer y = 164
integer width = 1979
integer height = 1268
integer taborder = 20
string dataobject = "d_edu_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False

   em_year.text = dw_1.GetItemString(row,"eduyear")        // 계획년도
//	em_seq.text = string(dw_1.GetItemNumber(row, "p5_educations_p_empseq"))
	
END IF

CALL SUPER ::CLICKED


end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r다시 선택한후 ok 버튼을 누르십시오.!!")
   return
END IF

//gs_code     = dw_1.GetItemString(row,"p5_educations_p_companycode")        // 계획년도
istr_edu.str_empno   = dw_1.GetItemString(row,"p5_educations_p_empno")
istr_edu.str_eduyear = dw_1.GetItemString(row,"eduyear")
istr_edu.str_empseq   = dw_1.GetItemNumber(row,"p5_educations_p_empseq")
istr_edu.str_gbn   = dw_1.GetItemString(row,"bgubn")


Closewithreturn(Parent, istr_edu)

end event

type sle_2 from w_inherite_popup`sle_2 within w_edu_popup
boolean visible = false
integer y = 2620
end type

type cb_1 from w_inherite_popup`cb_1 within w_edu_popup
boolean visible = false
integer y = 2368
end type

type cb_return from w_inherite_popup`cb_return within w_edu_popup
boolean visible = false
integer y = 2368
end type

type cb_inq from w_inherite_popup`cb_inq within w_edu_popup
boolean visible = false
integer y = 2368
end type

type sle_1 from w_inherite_popup`sle_1 within w_edu_popup
boolean visible = false
integer y = 2620
end type

type st_1 from w_inherite_popup`st_1 within w_edu_popup
boolean visible = false
integer y = 2632
end type

type st_5 from statictext within w_edu_popup
integer x = 91
integer y = 48
integer width = 142
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "구분"
boolean focusrectangle = false
end type

type sle_gbn from singlelineedit within w_edu_popup
integer x = 233
integer y = 48
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 6
boolean displayonly = true
end type

type st_2 from statictext within w_edu_popup
integer x = 549
integer y = 48
integer width = 142
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "사번"
boolean focusrectangle = false
end type

type sle_empno from singlelineedit within w_edu_popup
integer x = 695
integer y = 44
integer width = 297
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 6
boolean displayonly = true
end type

type st_3 from statictext within w_edu_popup
integer x = 1042
integer y = 44
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "계획년도"
boolean focusrectangle = false
end type

type em_year from editmask within w_edu_popup
integer x = 1303
integer y = 44
integer width = 238
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
string mask = "####"
end type

type rr_1 from roundrectangle within w_edu_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer width = 2016
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_edu_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 148
integer width = 2034
integer height = 1296
integer cornerheight = 40
integer cornerwidth = 55
end type

