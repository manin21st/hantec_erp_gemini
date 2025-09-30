$PBExportHeader$w_notice_popup.srw
$PBExportComments$** 공지사항 팝업 메인화면용
forward
global type w_notice_popup from w_inherite_popup
end type
type dw_2 from datawindow within w_notice_popup
end type
type dw_3 from datawindow within w_notice_popup
end type
type rr_1 from roundrectangle within w_notice_popup
end type
type rr_2 from roundrectangle within w_notice_popup
end type
end forward

global type w_notice_popup from w_inherite_popup
integer x = 146
integer y = 188
integer width = 3589
integer height = 2036
string title = "공지사항"
boolean center = true
dw_2 dw_2
dw_3 dw_3
rr_1 rr_1
rr_2 rr_2
end type
global w_notice_popup w_notice_popup

type variables
int  li_use  //거래처마스타는 거래중지인 경우도 조회
end variables

on w_notice_popup.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_3=create dw_3
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_notice_popup.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;//This.Center = True

dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

dw_3.InsertRow(0)

dw_3.SetItem(1, 'beforedate', '1')
dw_3.SetItem(1, 'saupj', gs_saupj)
dw_3.SetItem(1, 'title', '')

p_inq.TriggerEvent(Clicked!) //조회버튼

//dw_2.Retrieve(gs_code)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_notice_popup
boolean visible = false
integer x = 73
integer y = 2364
integer width = 210
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_notice_popup
integer x = 3323
string pointer = "HyperLink!"
boolean originalsize = true
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_notice_popup
integer x = 3150
string pointer = "HyperLink!"
end type

event p_inq::clicked;call super::clicked;String sbeforedate, ssaupj, stitle, sfrom, sto, schk, sclose_date

If dw_3.AcceptText() <> 1 Then Return

sbeforedate	= Trim(dw_3.GetItemString(1,'beforedate'))
stitle	= Trim(dw_3.GetItemString(1,'title'))
schk	= Trim(dw_3.GetItemString(1,'auth'))
ssaupj	= gs_saupj

If sbeforedate = '0' Then
	sfrom = '20110101'
Else
	sfrom = f_aftermonth(Left(f_today(),6),-integer(sbeforedate)) + '01'	
End if

sto = f_today()

If IsNull(stitle) OR stitle = '' Then 
	stitle = '%'
Else
	stitle = stitle + '%'
End if

If schk = 'Y' Then	// 게시만료 제외
	sclose_date = f_today()
Else
	sclose_date = '20110101'
End If

dw_1.Retrieve(sfrom, sto, stitle, sclose_date)

end event

type p_choose from w_inherite_popup`p_choose within w_notice_popup
boolean visible = false
integer x = 2825
integer y = 2344
boolean enabled = false
boolean originalsize = true
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF


gs_code = string(dw_1.GetItemNumber(ll_Row, "actno"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_notice_popup
integer x = 41
integer y = 196
integer width = 3474
integer height = 1704
integer taborder = 10
string dataobject = "d_notice_popup_10"
boolean hscrollbar = true
end type

event dw_1::clicked;
if row < 1 then return 
if this.rowcount() < 1 then return 

If row > 0 then
	selectrow(0,false)
	selectrow(row, true)
else
	selectrow(0,false)
end if

//dw_2.Retrieve(This.GetItemString(row, 'no'))

CALL SUPER ::CLICKED

end event

event dw_1::rowfocuschanged;// 상속 안받음
end event

event dw_1::doubleclicked;call super::doubleclicked;
if row < 1 then return 
if this.rowcount() < 1 then return 

If row > 0 then
	selectrow(0,false)
	selectrow(row, true)
else
	selectrow(0,false)
end if

dw_2.Retrieve(This.GetItemString(row, 'no'))
dw_2.Visible = True
end event

type sle_2 from w_inherite_popup`sle_2 within w_notice_popup
boolean visible = false
integer x = 539
integer y = 2340
integer width = 1225
end type

event sle_2::getfocus;IF dw_2.GetItemString(1,"rfgub") = '1' THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type cb_1 from w_inherite_popup`cb_1 within w_notice_popup
boolean visible = false
integer x = 1481
integer y = 2356
end type

type cb_return from w_inherite_popup`cb_return within w_notice_popup
boolean visible = false
integer x = 1792
integer y = 2356
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_notice_popup
boolean visible = false
integer x = 2377
integer y = 2372
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_notice_popup
boolean visible = false
integer x = 329
integer y = 2416
integer width = 197
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_notice_popup
boolean visible = false
integer y = 2432
integer width = 315
string text = "거래처코드"
end type

type dw_2 from datawindow within w_notice_popup
event ue_key pbm_dwnkey
boolean visible = false
integer x = 379
integer y = 512
integer width = 2738
integer height = 1080
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "공지사항 세부 내용"
string dataobject = "d_notice_popup_30"
boolean controlmenu = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_3 from datawindow within w_notice_popup
integer x = 59
integer y = 32
integer width = 2752
integer height = 132
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_notice_popup_01"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_notice_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 16
integer width = 2793
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_notice_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 188
integer width = 3497
integer height = 1728
integer cornerheight = 40
integer cornerwidth = 55
end type

