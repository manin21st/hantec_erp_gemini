$PBExportHeader$w_pdtgu_ittyp.srw
$PBExportComments$ ===> 생산팀에 속한 품목분류 Popup
forward
global type w_pdtgu_ittyp from w_inherite_popup
end type
type st_2 from statictext within w_pdtgu_ittyp
end type
end forward

global type w_pdtgu_ittyp from w_inherite_popup
integer x = 581
integer y = 188
integer width = 2514
integer height = 1908
string title = "대/중분류 코드 조회"
st_2 st_2
end type
global w_pdtgu_ittyp w_pdtgu_ittyp

on w_pdtgu_ittyp.create
int iCurrent
call super::create
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
end on

on w_pdtgu_ittyp.destroy
call super::destroy
destroy(this.st_2)
end on

event open;call super::open;if isnull(gs_code) or gs_code = "" then
	gs_code = '%'
	gs_codename = ''
end if

sle_1.Text = gs_code
sle_2.Text = gs_codename

dw_1.Retrieve(gs_code)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdtgu_ittyp
end type

type p_exit from w_inherite_popup`p_exit within w_pdtgu_ittyp
end type

type p_inq from w_inherite_popup`p_inq within w_pdtgu_ittyp
end type

type p_choose from w_inherite_popup`p_choose within w_pdtgu_ittyp
end type

type dw_1 from w_inherite_popup`dw_1 within w_pdtgu_ittyp
integer y = 128
integer width = 2437
integer height = 1524
integer taborder = 10
string dataobject = "d_ittyp_popup8"
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

event dw_1::doubleclicked;string slag, smid, smal
long   lseq

IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row,"itcls")
gs_codename = dw_1.GetItemString(Row,"titnm")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pdtgu_ittyp
integer x = 617
integer y = 24
integer width = 1006
long backcolor = 79741120
boolean displayonly = true
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdtgu_ittyp
integer x = 1673
integer y = 1676
integer width = 384
integer taborder = 20
end type

event cb_1::clicked;String slag, smid, smal
Long ll_row, lseq

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row,"itcls")
gs_codename = dw_1.GetItemString(ll_Row,"titnm")

Close(Parent)


end event

type cb_return from w_inherite_popup`cb_return within w_pdtgu_ittyp
integer x = 2085
integer y = 1676
integer width = 384
integer taborder = 40
end type

event cb_return::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_pdtgu_ittyp
boolean visible = false
integer x = 2350
integer y = 1668
integer taborder = 30
end type

event cb_inq::clicked;String sgu

//dw_2.acceptText()

//sgu = dw_2.GetItemString(1,'ittyp')

IF sgu ="" OR IsNull(sgu) THEN sgu ='1'

IF dw_1.Retrieve(sgu) <= 0 THEN
	f_message_chk(50,'')
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type sle_1 from w_inherite_popup`sle_1 within w_pdtgu_ittyp
integer x = 393
integer y = 24
integer width = 215
long backcolor = 79741120
integer limit = 15
boolean displayonly = true
end type

type st_1 from w_inherite_popup`st_1 within w_pdtgu_ittyp
boolean visible = false
integer x = 59
integer y = 132
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type st_2 from statictext within w_pdtgu_ittyp
integer x = 64
integer y = 40
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "생 산 팀 :"
boolean focusrectangle = false
end type

