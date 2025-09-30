$PBExportHeader$w_barcode.srw
$PBExportComments$** BAR-CODE 입력창 (납입전표번호)
forward
global type w_barcode from window
end type
type sle_1 from singlelineedit within w_barcode
end type
end forward

global type w_barcode from window
integer width = 1486
integer height = 592
boolean titlebar = true
string title = "납입카드번호 입력"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
sle_1 sle_1
end type
global w_barcode w_barcode

on w_barcode.create
this.sle_1=create sle_1
this.Control[]={this.sle_1}
end on

on w_barcode.destroy
destroy(this.sle_1)
end on

event open;f_window_center(this)

setnull(gs_gubun)
setnull(gs_code)

sle_1.setfocus()
end event

type sle_1 from singlelineedit within w_barcode
integer x = 192
integer y = 152
integer width = 1061
integer height = 144
integer taborder = 10
integer textsize = -20
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//string 	sjpno, ls_cardno, ls_jpnos, ls_fullpath                                                                                                                           
//
//sjpno = sle_1.text
//
//select prt_jpno into :ls_cardno from poblkt_hist
// where jpno = :sjpno and rownum = 1 ;
//
//if isnull(ls_cardno) or ls_cardno = '' then
//	messagebox('확인','처리가능한 납입카드번호가 아닙니다.')
//	sle_1.text = ''
//	return
//end if
//
//// 카드번호에 해당하는 납입번호 가져오기
//select fun_get_scm_jpno_list(:ls_cardno) 
//  into :ls_jpnos from dual ;
//  
//
//// 주소는 이원정공에 맞게 주세요 
//// 아마 이거 맞을 겁니다. -->http://scm.lwp.co.kr/sc/sc1/I002.aspx?jpno=" 
//ls_fullpath = "http://scm.lwp.co.kr/sc/sc1/I002_R01.aspx?jpno="+ls_jpnos 
//                                                                                                                                             
//w_mdi_frame.sle_addr.text = ls_fullpath
//w_mdi_frame.sle_addr.PostEvent(Modified!)           
//
//close(parent)

long		lcnt
string	sjpno

sjpno = sle_1.text

select count(*) into :lcnt from poblkt_hist
 where prt_jpno = :sjpno ;

if lcnt = 0 then
	messagebox('확인','처리가능한 BARCODE번호가 아닙니다.')
	sle_1.text = ''
	return
end if

gs_gubun = 'OK'
gs_code  = sjpno

close(parent)
end event

