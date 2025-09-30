$PBExportHeader$w_workplace_popup.srw
$PBExportComments$** 작업장코드 조회
forward
global type w_workplace_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_workplace_popup
end type
end forward

global type w_workplace_popup from w_inherite_popup
integer width = 1856
integer height = 1800
string title = "작업장 조회 선택"
rr_1 rr_1
end type
global w_workplace_popup w_workplace_popup

type variables
string is_pdtgu
end variables

on w_workplace_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_workplace_popup.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;String scode,sname

dw_jogun.SetTransObject(sqlca)
dw_jogun.InsertRow(0)

// 생산팀
select rfna1 into :sname from reffpf where rfcod = '03' and rfgub = :gs_gubun;
If sqlca.sqlcode <> 0 Then	SetNull(gs_gubun)

If IsNull(gs_gubun) Then
	select min(rfgub) into :is_pdtgu from reffpf where rfcod = '03' and rfna2 = :gs_saupj;
Else
	is_pdtgu = gs_gubun
End If

dw_jogun.SetItem(1, 'pdtgu', is_pdtgu)

if isnull(gs_code) or gs_code = "" then
	gs_code = '%'
	scode = gs_code
	sname = ""
else
	
	dw_jogun.SetItem(1, 'wkcod',gs_code)
	dw_jogun.SetItem(1, 'wknm',gs_codename)
	
	scode = gs_code
	sname = gs_codename
	
	IF IsNull(scode) THEN scode =""
	IF IsNull(sname) THEN sname =""
end if	

dw_1.Retrieve(scode + '%',sname + '%', is_pdtgu+'%')

dw_1.SelectRow(0,False)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_workplace_popup
integer y = 180
integer width = 1819
integer height = 232
string dataobject = "d_workplace_popup1"
end type

event dw_jogun::itemchanged;call super::itemchanged;p_inq.TriggerEvent(clicked!)
end event

type p_exit from w_inherite_popup`p_exit within w_workplace_popup
integer x = 1655
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_workplace_popup
integer x = 1307
end type

event p_inq::clicked;call super::clicked;
String scode,sname, spdtgu

IF dw_jogun.AcceptText() = -1 THEN Return

spdtgu = dw_jogun.GetItemString(1, 'pdtgu')
scode = dw_jogun.GetItemString(1, 'wkcod')
sname = dw_jogun.GetItemString(1, 'wknm')

IF IsNull(scode) THEN scode =""
IF IsNull(sname) THEN sname = ""

IF scode ="" AND sname ="" THEN 
	scode = '%'
	sname = '%'
ELSEIF scode <> "" AND sname ="" THEN
	scode = scode +'%'
	sname = '%'
ELSEIF sname <> "" AND scode ="" THEN
	sname = sname + '%'
	scode = '%'
ELSEIF sname <> "" AND scode <>"" THEN
	sname = sname + '%'
	scode = scode + '%'
END IF

dw_1.Retrieve(scode, sname, spdtgu+'%')
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_workplace_popup
integer x = 1481
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "wrkctr_wkctr")
gs_codename= dw_1.GetItemString(ll_row,"wrkctr_wcdsc")
gs_gubun= dw_1.GetItemString(ll_row,"wrkctr_jocod")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_workplace_popup
integer x = 37
integer y = 444
integer width = 1774
integer height = 1256
integer taborder = 30
string dataobject = "d_workplace_popup"
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

gs_code= dw_1.GetItemString(Row, "wrkctr_wkctr")
gs_codename= dw_1.GetItemString(row,"wrkctr_wcdsc")
gs_gubun= dw_1.GetItemString(row,"wrkctr_jocod")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_workplace_popup
integer x = 768
integer y = 2296
integer width = 859
end type

event sle_2::getfocus;//IF dw_2.GetItemString(1,"rfgub") = '1' THEN
//	f_toggle_kor(Handle(this))
//ELSE
//	f_toggle_eng(Handle(this))
//END IF
end event

type cb_1 from w_inherite_popup`cb_1 within w_workplace_popup
integer x = 727
integer y = 2000
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_workplace_popup
integer x = 1349
integer y = 2000
integer taborder = 60
end type

type cb_inq from w_inherite_popup`cb_inq within w_workplace_popup
integer x = 1038
integer y = 2000
integer taborder = 50
end type

type sle_1 from w_inherite_popup`sle_1 within w_workplace_popup
integer x = 507
integer y = 2296
integer width = 261
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_workplace_popup
integer x = 183
integer y = 2308
integer width = 315
string text = "작업장코드"
end type

type rr_1 from roundrectangle within w_workplace_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 432
integer width = 1797
integer height = 1276
integer cornerheight = 40
integer cornerwidth = 55
end type

