$PBExportHeader$w_zip_popup.srw
$PBExportComments$** 우편번호 조회 선택(도로명주소)
forward
global type w_zip_popup from window
end type
type sle_2 from singlelineedit within w_zip_popup
end type
type sle_1 from singlelineedit within w_zip_popup
end type
type ole_1 from u_web_browser within w_zip_popup
end type
type p_retrieve from uo_picture within w_zip_popup
end type
type p_exit from uo_picture within w_zip_popup
end type
type p_choose from uo_picture within w_zip_popup
end type
type cb_1 from commandbutton within w_zip_popup
end type
type cb_return from commandbutton within w_zip_popup
end type
end forward

global type w_zip_popup from window
integer x = 1938
integer y = 84
integer width = 2770
integer height = 2852
boolean titlebar = true
string title = "우편번호 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
sle_2 sle_2
sle_1 sle_1
ole_1 ole_1
p_retrieve p_retrieve
p_exit p_exit
p_choose p_choose
cb_1 cb_1
cb_return cb_return
end type
global w_zip_popup w_zip_popup

type variables
datawindowchild idws

Integer ii_cnt = 0
end variables

forward prototypes
public function boolean wf_getdoc ()
end prototypes

public function boolean wf_getdoc ();oleobject obj

string ls_temp, ls_return, ls_gubun

long ll_str, ll_end

  
//내용 가져오기

IF ole_1.object.Busy = FALSE THEN

	Obj = ole_1.OBJECT.Document
	
	IF ole_1.OBJECT.document THEN
		ls_temp = Obj.body.outerhtml
	END IF
else
	return false
END IF


//원하는 내용 자르기

//구분
ll_str = pos(ls_temp, '[')
ll_end = pos(ls_temp, ']')
ll_end = ll_end - ll_str

ls_gubun = mid(ls_temp, ll_str + 1, ll_end - 1)

if IsNull(ls_gubun) then return false

if ls_gubun = 'R' then
	//5자리

	ll_str = pos(ls_temp, '@')
	ll_end = pos(ls_temp, '$')
	ll_end = ll_end - ll_str

	ls_return = mid(ls_temp, ll_str + 1, ll_end - 1)
	sle_1.text = mid(ls_return,1,5)
	ll_end = len (ls_return)
	sle_2.text = mid(ls_return,7,ll_end)
return true
elseif   ls_gubun = 'J' then

	//지번 
	ll_str = pos(ls_temp, '*')
	ll_end = pos(ls_temp, '%')
	ll_end = ll_end - ll_str

	ls_return = mid(ls_temp, ll_str + 1, ll_end - 1)
	sle_1.text = mid(ls_return,1,6)
	ll_end = len (ls_return)
	sle_2.text = mid(ls_return,8,ll_end)
return true
else
	sle_1.text = 'none'
	sle_2.text = 'none'
	return false
//	wf_GetDoc()
end if


end function

event open;
string ls_url

SetNull(gs_code)
SetNull(gs_codename)

ls_url = 'http://125.141.30.201/daumapi'

ole_1.object.navigate(ls_url,0,0,0,0)


end event

on w_zip_popup.create
this.sle_2=create sle_2
this.sle_1=create sle_1
this.ole_1=create ole_1
this.p_retrieve=create p_retrieve
this.p_exit=create p_exit
this.p_choose=create p_choose
this.cb_1=create cb_1
this.cb_return=create cb_return
this.Control[]={this.sle_2,&
this.sle_1,&
this.ole_1,&
this.p_retrieve,&
this.p_exit,&
this.p_choose,&
this.cb_1,&
this.cb_return}
end on

on w_zip_popup.destroy
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.ole_1)
destroy(this.p_retrieve)
destroy(this.p_exit)
destroy(this.p_choose)
destroy(this.cb_1)
destroy(this.cb_return)
end on

event timer;
boolean req

req = wf_GetDoc()
if req then
	gs_code = sle_1.text
	gs_codename = sle_2.text

	Close(this)
else
	// 서버에서처리한 데이터를 가져오지 못할경우 0.2초단위로 3번더 시도함
	if ii_cnt <= 3 then
		ii_cnt = ii_cnt+1
		timer(0.2)
	else
		ii_cnt = 0
		timer(0)
	end if
end if
end event

type sle_2 from singlelineedit within w_zip_popup
boolean visible = false
integer x = 1202
integer y = 2520
integer width = 1225
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean border = false
end type

type sle_1 from singlelineedit within w_zip_popup
boolean visible = false
integer x = 713
integer y = 2524
integer width = 443
integer height = 80
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean border = false
end type

type ole_1 from u_web_browser within w_zip_popup
integer x = 5
integer y = 8
integer width = 2743
integer height = 2724
integer taborder = 20
string binarykey = "w_zip_popup.win"
integer weight = 700
end type

event doubleclicked;call super::doubleclicked;
// 서버에서 데이터를 처리할 시간이 필요함
timer(0.5)

end event

type p_retrieve from uo_picture within w_zip_popup
boolean visible = false
integer x = 2825
integer y = 532
integer width = 178
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type p_exit from uo_picture within w_zip_popup
boolean visible = false
integer x = 2811
integer y = 208
integer width = 178
integer height = 148
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

type p_choose from uo_picture within w_zip_popup
boolean visible = false
integer x = 2825
integer y = 372
integer width = 178
string pointer = "C:\erpman\cur\choose.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\선택_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\선택_up.gif'
end event

type cb_1 from commandbutton within w_zip_popup
boolean visible = false
integer x = 1189
integer y = 1640
integer width = 293
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "선택(&S)"
end type

event clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//gs_code = dw_1.GetItemString(ll_Row, "zip")
//gs_codename = dw_1.GetItemString(ll_Row, "addr")
//
//Close(Parent)
//

end event

type cb_return from commandbutton within w_zip_popup
boolean visible = false
integer x = 1518
integer y = 1640
integer width = 293
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
03w_zip_popup.bin 
2E00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000b38d1ac001d0de0b00000003000000c00000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f00000000b38d1ac001d0de0bb38d1ac001d0de0b000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c000000000000000100000002fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c00003e03000046620000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13w_zip_popup.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
