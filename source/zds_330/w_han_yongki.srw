$PBExportHeader$w_han_yongki.srw
$PBExportComments$용기 사용현황
forward
global type w_han_yongki from w_inherite_popup
end type
type st_2 from statictext within w_han_yongki
end type
type rr_1 from roundrectangle within w_han_yongki
end type
end forward

global type w_han_yongki from w_inherite_popup
integer width = 4311
integer height = 2448
event ue_open ( )
st_2 st_2
rr_1 rr_1
end type
global w_han_yongki w_han_yongki

type variables
String gs_get[]
end variables

event ue_open();gstr_array lstr_array

lstr_array = Message.PowerObjectParm

gs_get[1] = lstr_array.as_str[1]  //사업장
gs_get[2] = lstr_array.as_str[2]  //수불기간(시작)
gs_get[3] = lstr_array.as_str[3]  //수불기간(종료)
gs_get[4] = lstr_array.as_str[4]  //담당자
gs_get[5] = lstr_array.as_str[5]  //품목구분
gs_get[6] = lstr_array.as_str[6]  //품번
gs_get[7] = lstr_array.as_str[7]  //출고처(출고창고)
gs_get[8] = lstr_array.as_str[8]  //공장
gs_get[9] = lstr_array.as_str[9]  //납품처(거래처)
end event

on w_han_yongki.create
int iCurrent
call super::create
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_han_yongki.destroy
call super::destroy
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_han_yongki
boolean visible = false
integer x = 219
integer y = 32
integer width = 41
integer height = 44
boolean enabled = false
end type

type p_exit from w_inherite_popup`p_exit within w_han_yongki
integer x = 4027
integer y = 12
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::ue_lbuttondown;//
PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;//
PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_han_yongki
integer x = 3854
integer y = 12
end type

event p_inq::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Retrieve(gs_get[1], gs_get[2], gs_get[3], gs_get[4], gs_get[5], gs_get[6], gs_get[7], gs_get[8], gs_get[9])
dw_1.SetRedraw(True)
end event

type p_choose from w_inherite_popup`p_choose within w_han_yongki
boolean visible = false
integer x = 23
integer y = 8
boolean enabled = false
end type

type dw_1 from w_inherite_popup`dw_1 within w_han_yongki
integer x = 50
integer y = 180
integer width = 4192
integer height = 2132
string dataobject = "d_han_yongki_001"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type sle_2 from w_inherite_popup`sle_2 within w_han_yongki
boolean visible = false
integer x = 2917
integer y = 2600
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_han_yongki
boolean visible = false
integer x = 3392
integer y = 2348
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_han_yongki
boolean visible = false
integer x = 4027
integer y = 2348
boolean enabled = false
boolean cancel = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_han_yongki
boolean visible = false
integer x = 3712
integer y = 2348
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_han_yongki
boolean visible = false
integer x = 2734
integer y = 2600
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_han_yongki
boolean visible = false
integer x = 2455
integer y = 2612
end type

type st_2 from statictext within w_han_yongki
integer x = 101
integer y = 72
integer width = 2345
integer height = 72
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
string text = "* 본 화면은 ~"매출현황~"의 조회내용을 기준으로 집계 합니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_han_yongki
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 168
integer width = 4219
integer height = 2164
integer cornerheight = 40
integer cornerwidth = 55
end type

