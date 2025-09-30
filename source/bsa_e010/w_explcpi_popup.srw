$PBExportHeader$w_explcpi_popup.srw
$PBExportComments$L/C NO 선택 POPUP(LOCAL CI등록,미사용예정)
forward
global type w_explcpi_popup from w_inherite_popup
end type
end forward

global type w_explcpi_popup from w_inherite_popup
integer x = 827
integer y = 300
integer width = 2441
integer height = 1908
string title = "L/C No. 선택"
end type
global w_explcpi_popup w_explcpi_popup

on w_explcpi_popup.create
call super::create
end on

on w_explcpi_popup.destroy
call super::destroy
end on

event open;call super::open;string slcno,scvcod

sle_1.text = gs_code

slcno  = trim(gs_code)
scvcod = trim(gs_gubun)

IF IsNull(slcno)  Then slcno = "" 
IF IsNull(scvcod) Then scvcod = "" 



dw_1.Retrieve(gs_sabu,slcno+'%',scvcod)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_1 from w_inherite_popup`dw_1 within w_explcpi_popup
integer y = 132
integer width = 2377
integer height = 1520
integer taborder = 30
string dataobject = "d_explcpi_popup"
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

gs_code		= dw_1.GetItemString(row, "explcno")
gs_codename = dw_1.GetItemString(row, "iojpno")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_explcpi_popup
boolean visible = false
integer x = 1001
integer width = 1138
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_explcpi_popup
integer x = 997
integer y = 1676
integer taborder = 40
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code		= dw_1.GetItemString(ll_row, "explcno")
gs_codename = dw_1.GetItemString(ll_row, "iojpno")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_explcpi_popup
integer x = 1618
integer y = 1676
integer taborder = 60
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_explcpi_popup
integer x = 1307
integer y = 1676
integer taborder = 50
end type

event cb_inq::clicked;string slcno,scvcod

slcno  = trim(sle_1.Text)
scvcod = trim(gs_gubun)

IF IsNull(slcno)  Then slcno = "" 
IF IsNull(scvcod) Then scvcod = "" 

dw_1.Retrieve(gs_sabu,slcno+'%',scvcod+'%')
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_explcpi_popup
integer x = 357
integer width = 471
integer limit = 11
end type

type st_1 from w_inherite_popup`st_1 within w_explcpi_popup
integer x = 27
integer y = 44
integer width = 315
string text = "L/C No."
end type

