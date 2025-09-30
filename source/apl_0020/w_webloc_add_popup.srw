$PBExportHeader$w_webloc_add_popup.srw
$PBExportComments$인터넷 즐겨찾기 등록
forward
global type w_webloc_add_popup from window
end type
type cb_2 from commandbutton within w_webloc_add_popup
end type
type cb_1 from commandbutton within w_webloc_add_popup
end type
type sle_url from singlelineedit within w_webloc_add_popup
end type
type sle_name from singlelineedit within w_webloc_add_popup
end type
type st_3 from statictext within w_webloc_add_popup
end type
type st_2 from statictext within w_webloc_add_popup
end type
type st_1 from statictext within w_webloc_add_popup
end type
end forward

global type w_webloc_add_popup from window
integer width = 2053
integer height = 456
boolean titlebar = true
string title = "즐겨찾기 추가"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 32106727
cb_2 cb_2
cb_1 cb_1
sle_url sle_url
sle_name sle_name
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_webloc_add_popup w_webloc_add_popup

on w_webloc_add_popup.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_url=create sle_url
this.sle_name=create sle_name
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.sle_url,&
this.sle_name,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_webloc_add_popup.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_url)
destroy(this.sle_name)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;f_window_center(this)
sle_name.text = gs_code
sle_url.text = gs_code

sle_name.SetFocus()
end event

type cb_2 from commandbutton within w_webloc_add_popup
integer x = 1605
integer y = 260
integer width = 366
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소"
end type

event clicked;Close(Parent)
end event

type cb_1 from commandbutton within w_webloc_add_popup
integer x = 1605
integer y = 152
integer width = 366
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인"
boolean default = true
end type

event clicked;String sName, sUrl, sMax

sName = Trim(sle_name.Text)
sUrl  = Trim(sle_url.Text)

If IsNull(sUrl) Or sUrl = '' Then Return

If IsNull(sName) Or sName = '' Then
	sName = sUrl
	Return
End If
	
SELECT MAX(WINDOW_NAME) INTO :sMax FROM SUB2_USER_T_ADD WHERE USER_ID = :gs_userid AND GBN = '2';
If IsNull(sMax) Or sMax = '' Then	sMax = '0'

sMax = String(Dec(sMax)+1,'0000000000')
INSERT INTO "SUB2_USER_T_ADD"  
		( "USER_ID",   					  "WINDOW_NAME",   					  "SUB2_NAME",   					  "WEB_URL",     "GBN" )  
VALUES ( :gs_userid,   					  :sMax,   								  :sName,  							  :sUrl,   		  '2' )  ;

COMMIT;

Close(Parent)
end event

type sle_url from singlelineedit within w_webloc_add_popup
integer x = 279
integer y = 260
integer width = 1303
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_name from singlelineedit within w_webloc_add_popup
integer x = 279
integer y = 152
integer width = 1303
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_webloc_add_popup
integer x = 110
integer y = 276
integer width = 174
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "주소 :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_webloc_add_popup
integer x = 110
integer y = 172
integer width = 183
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "이름 :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_webloc_add_popup
integer x = 101
integer y = 56
integer width = 1056
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "즐겨찾기 목록에 이 페이지를 추가합니다"
boolean focusrectangle = false
end type

