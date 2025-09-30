$PBExportHeader$w_cvdouble_popup.srw
$PBExportComments$** 청구 항목 등록
forward
global type w_cvdouble_popup from w_inherite_popup
end type
type st_itnbr from statictext within w_cvdouble_popup
end type
type st_itdsc from statictext within w_cvdouble_popup
end type
type rr_1 from roundrectangle within w_cvdouble_popup
end type
end forward

global type w_cvdouble_popup from w_inherite_popup
integer x = 1083
integer y = 212
integer width = 2290
integer height = 892
string title = "공급업체 조회 선택"
st_itnbr st_itnbr
st_itdsc st_itdsc
rr_1 rr_1
end type
global w_cvdouble_popup w_cvdouble_popup

on w_cvdouble_popup.create
int iCurrent
call super::create
this.st_itnbr=create st_itnbr
this.st_itdsc=create st_itdsc
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_itnbr
this.Control[iCurrent+2]=this.st_itdsc
this.Control[iCurrent+3]=this.rr_1
end on

on w_cvdouble_popup.destroy
call super::destroy
destroy(this.st_itnbr)
destroy(this.st_itdsc)
destroy(this.rr_1)
end on

event open;call super::open;//dw_jogun.SetTransObject(SQLCA)
//dw_jogun.InsertRow(0)

//IF IsNull(gs_gubun) THEN
//	gs_gubun ="%"
//ELSE   
//   dw_jogun.setitem(1, 'ittyp' , gs_gubun)	
//END IF

st_itnbr.text = gs_code
st_itdsc.text = gs_codename

dw_1.Retrieve(gs_code)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_cvdouble_popup
boolean visible = false
integer x = 2606
integer y = 420
integer width = 1157
integer height = 140
string dataobject = "d_itnct_m_popup0"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name, s_cdchk

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()

   IF	Isnull(s_name)  or  trim(s_name) = ''	Then
		s_name = '%'
	ELSE	
		s_cdchk = f_get_reffer('05', s_name)
		if isnull(s_cdchk) or s_cdchk="" then
			f_message_chk(33,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if	
	END IF

	dw_1.Retrieve(s_name)
		
	dw_1.SelectRow(0,False)
	dw_1.SelectRow(1,True)
	dw_1.ScrollToRow(1)
	dw_1.SetFocus()
END IF
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

type p_exit from w_inherite_popup`p_exit within w_cvdouble_popup
integer x = 2034
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

CloseWithReturn(Parent, 'NOK')
end event

type p_inq from w_inherite_popup`p_inq within w_cvdouble_popup
boolean visible = false
integer x = 1253
integer y = 12
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_cvdouble_popup
integer x = 1861
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row,"cvcod")
gs_codename = dw_1.GetItemString(ll_Row,"cvnas")

CloseWithReturn(Parent, 'OK')
end event

type dw_1 from w_inherite_popup`dw_1 within w_cvdouble_popup
integer x = 32
integer y = 192
integer width = 2194
integer height = 532
integer taborder = 20
string dataobject = "d_cvdouble_popup1"
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

gs_code = dw_1.GetItemString(Row,"cvcod")
gs_codename = dw_1.GetItemString(Row,"cvnas")

CloseWithReturn(Parent, 'OK')
end event

type sle_2 from w_inherite_popup`sle_2 within w_cvdouble_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_cvdouble_popup
boolean visible = false
integer x = 1728
integer y = 1952
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_cvdouble_popup
boolean visible = false
integer x = 2048
integer y = 1952
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_cvdouble_popup
boolean visible = false
integer x = 1074
integer taborder = 50
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_cvdouble_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_cvdouble_popup
boolean visible = false
end type

type st_itnbr from statictext within w_cvdouble_popup
integer x = 27
integer y = 24
integer width = 1211
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "none"
boolean focusrectangle = false
end type

type st_itdsc from statictext within w_cvdouble_popup
integer x = 27
integer y = 100
integer width = 1211
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "none"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_cvdouble_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 180
integer width = 2222
integer height = 568
integer cornerheight = 40
integer cornerwidth = 55
end type

