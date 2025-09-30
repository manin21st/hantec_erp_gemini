$PBExportHeader$w_dmcode_popup.srw
$PBExportComments$ ===> DM Code Popup
forward
global type w_dmcode_popup from w_inherite_popup
end type
end forward

global type w_dmcode_popup from w_inherite_popup
int X=1120
int Y=276
int Width=1659
int Height=1904
boolean TitleBar=true
string Title="DM 코드 조회 및 선택"
end type
global w_dmcode_popup w_dmcode_popup

on w_dmcode_popup.create
call super::create
end on

on w_dmcode_popup.destroy
call super::destroy
end on

event open;call super::open;dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_1 from w_inherite_popup`dw_1 within w_dmcode_popup
int Y=32
int Width=1577
int Height=1612
int TabOrder=30
string DataObject="d_dmcode_popup"
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

gs_code= dw_1.GetItemString(Row, "dmcode")
gs_codename= dw_1.GetItemString(row,"dmname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_dmcode_popup
int X=658
int Width=1138
boolean Visible=false
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_dmcode_popup
int X=896
int Y=1676
int Width=343
int TabOrder=40
end type

event cb_1::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "dmcode")
gs_codename= dw_1.GetItemString(ll_row,"dmname")

Close(Parent)

end event

type cb_return from w_inherite_popup`cb_return within w_dmcode_popup
int X=1266
int Y=1676
int Width=343
int TabOrder=60
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_dmcode_popup
int X=1271
int Y=1676
int TabOrder=50
boolean Visible=false
end type

event cb_inq::clicked;string scode, sname

scode = trim(sle_1.text)
sname = trim(sle_2.text)

IF IsNull(scode) or scode = "" THEN 
	scode = "%"
ELSE
	scode = scode + '%'
END IF	

IF IsNull(sname) or sname = "" THEN
	sname = "%"
ELSE
	sname = '%' + sname + '%'
END IF	

dw_1.Retrieve(scode, sname)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type sle_1 from w_inherite_popup`sle_1 within w_dmcode_popup
int X=357
int Width=302
boolean Visible=false
int Limit=6
TextCase TextCase=AnyCase!
end type

type st_1 from w_inherite_popup`st_1 within w_dmcode_popup
int X=27
int Y=44
int Width=315
boolean Visible=false
string Text="고객 코드"
end type

