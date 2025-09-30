$PBExportHeader$w_stot_popup.srw
$PBExportComments$교육실적자료조회(popup window)
forward
global type w_stot_popup from w_inherite_popup
end type
type sle_empname from singlelineedit within w_stot_popup
end type
type st_4 from statictext within w_stot_popup
end type
type em_seq from editmask within w_stot_popup
end type
type st_2 from statictext within w_stot_popup
end type
type sle_empno from singlelineedit within w_stot_popup
end type
type st_3 from statictext within w_stot_popup
end type
type em_year from editmask within w_stot_popup
end type
type rr_1 from roundrectangle within w_stot_popup
end type
type rr_2 from roundrectangle within w_stot_popup
end type
end forward

global type w_stot_popup from w_inherite_popup
integer x = 1294
integer y = 160
integer width = 2272
integer height = 2008
string title = "교육훈련이수결과 조회 PopUp Window"
boolean controlmenu = true
sle_empname sle_empname
st_4 st_4
em_seq em_seq
st_2 st_2
sle_empno sle_empno
st_3 st_3
em_year em_year
rr_1 rr_1
rr_2 rr_2
end type
global w_stot_popup w_stot_popup

type variables
str_edu  istr_edu
end variables

event open;call super::open;string sgbn, ls_empname

istr_edu = Message.PowerObjectParm

sgbn = istr_edu.str_gbn

sle_empno.text = istr_edu.str_empno
em_year.text = istr_edu.str_eduyear

  SELECT "P1_MASTER"."EMPNAME"  
    INTO :ls_empname  
    FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_MASTER"."EMPNO" = :istr_edu.str_empno )   ;
if sqlca.sqlcode = 0 then
	sle_empname.text = ls_empname
else
	sle_empname.text = ""
end if

end event

on w_stot_popup.create
int iCurrent
call super::create
this.sle_empname=create sle_empname
this.st_4=create st_4
this.em_seq=create em_seq
this.st_2=create st_2
this.sle_empno=create sle_empno
this.st_3=create st_3
this.em_year=create em_year
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_empname
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.em_seq
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_empno
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_year
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_stot_popup.destroy
call super::destroy
destroy(this.sle_empname)
destroy(this.st_4)
destroy(this.em_seq)
destroy(this.st_2)
destroy(this.sle_empno)
destroy(this.st_3)
destroy(this.em_year)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_stot_popup
boolean visible = false
integer x = 0
integer y = 2784
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_stot_popup
integer x = 2053
integer y = 1760
integer width = 165
integer taborder = 60
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(istr_edu.str_empno)
SetNull(istr_edu.str_eduyear)
SetNull(istr_edu.str_empseq)
SetNull(istr_edu.str_gbn)

Closewithreturn(Parent, istr_edu)
//close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_stot_popup
integer x = 1893
integer y = 1760
integer width = 165
integer taborder = 50
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_empno, ls_eduyear, ls_gbn
//long ll_empseq

ls_empno = trim(istr_edu.str_empno)        // 사원번호
ls_eduyear = trim(em_year.text) +'%'  // 계획년도
// ls_empseq = long(trim(em_seq.text) +'%'  // 일련번호
ls_gbn = istr_edu.str_gbn


IF dw_1.Retrieve(gs_code, ls_empno , ls_eduyear) <=0 THEN
	MessageBox("확 인", "검색된 자료가 존재하지 ~r않습니다.!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_stot_popup
integer x = 1733
integer y = 1760
integer width = 165
integer taborder = 40
end type

event p_choose::clicked;call super::clicked;Long ll_row	

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r 다시 선택한후 선택버튼을 누르십시오 !!")
   return
END IF

//gs_code          =      dw_1.GetItemString(ll_Row,"p5_educations_p_companycode")        // 계획년도
istr_edu.str_empno   = dw_1.GetItemString(ll_Row, "empno")
istr_edu.str_eduyear = dw_1.GetItemString(ll_Row,"eduyear")
istr_edu.str_empseq  = dw_1.GetItemNumber(ll_Row,"empseq")
istr_edu.str_sdate   = dw_1.GetItemString(ll_Row,"restartdate")
istr_edu.str_edate   = dw_1.GetItemString(ll_Row,"reenddate")

istr_edu.str_gbn     = dw_1.GetItemString(ll_Row,"bgubn")

Closewithreturn(Parent, istr_edu)
end event

type dw_1 from w_inherite_popup`dw_1 within w_stot_popup
integer x = 14
integer y = 184
integer width = 2217
integer height = 1532
string dataobject = "d_stot_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False

   em_year.text = dw_1.GetItemString(row,"eduyear")        // 계획년도
	em_seq.text = string(dw_1.GetItemNumber(row, "empseq"))
	
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

//gs_code     = dw_1.GetItemString(row,"p5_educations_p_companycode")        // 계획년도
istr_edu.str_empno   = dw_1.GetItemString(row,"empno")
istr_edu.str_eduyear = dw_1.GetItemString(row,"eduyear")
istr_edu.str_empseq   = dw_1.GetItemNumber(row,"empseq")
istr_edu.str_sdate   = dw_1.GetItemString(row,"restartdate")
istr_edu.str_edate   = dw_1.GetItemString(row,"reenddate")

istr_edu.str_gbn   = dw_1.GetItemString(row,"bgubn")

Closewithreturn(Parent, istr_edu)

end event

type sle_2 from w_inherite_popup`sle_2 within w_stot_popup
boolean visible = false
integer y = 2668
end type

type cb_1 from w_inherite_popup`cb_1 within w_stot_popup
boolean visible = false
integer y = 2416
end type

type cb_return from w_inherite_popup`cb_return within w_stot_popup
boolean visible = false
integer y = 2416
end type

type cb_inq from w_inherite_popup`cb_inq within w_stot_popup
boolean visible = false
integer y = 2416
end type

type sle_1 from w_inherite_popup`sle_1 within w_stot_popup
boolean visible = false
integer y = 2668
end type

type st_1 from w_inherite_popup`st_1 within w_stot_popup
boolean visible = false
integer y = 2680
end type

type sle_empname from singlelineedit within w_stot_popup
integer x = 507
integer y = 36
integer width = 283
integer height = 56
integer taborder = 70
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
integer limit = 20
boolean displayonly = true
end type

type st_4 from statictext within w_stot_popup
integer x = 1440
integer y = 44
integer width = 247
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
string text = "일련번호"
boolean focusrectangle = false
end type

type em_seq from editmask within w_stot_popup
integer x = 1687
integer y = 36
integer width = 283
integer height = 56
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
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####"
end type

type st_2 from statictext within w_stot_popup
integer x = 50
integer y = 40
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

type sle_empno from singlelineedit within w_stot_popup
integer x = 192
integer y = 36
integer width = 283
integer height = 56
integer taborder = 10
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

type st_3 from statictext within w_stot_popup
integer x = 855
integer y = 44
integer width = 242
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

type em_year from editmask within w_stot_popup
integer x = 1097
integer y = 36
integer width = 251
integer height = 56
integer taborder = 20
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

type rr_1 from roundrectangle within w_stot_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 8
integer width = 2185
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_stot_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 172
integer width = 2249
integer height = 1572
integer cornerheight = 40
integer cornerwidth = 55
end type

