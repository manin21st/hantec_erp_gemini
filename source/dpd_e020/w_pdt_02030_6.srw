$PBExportHeader$w_pdt_02030_6.srw
$PBExportComments$작업지시시 오류확인
forward
global type w_pdt_02030_6 from window
end type
type p_1 from uo_picture within w_pdt_02030_6
end type
type st_msg from statictext within w_pdt_02030_6
end type
type dw_1 from datawindow within w_pdt_02030_6
end type
type rr_1 from roundrectangle within w_pdt_02030_6
end type
end forward

global type w_pdt_02030_6 from window
integer x = 283
integer y = 496
integer width = 3113
integer height = 1552
boolean titlebar = true
string title = "작업지시 품목에 대한 기초자료 오류 확인"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
st_msg st_msg
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_02030_6 w_pdt_02030_6

on w_pdt_02030_6.create
this.p_1=create p_1
this.st_msg=create st_msg
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.st_msg,&
this.dw_1,&
this.rr_1}
end on

on w_pdt_02030_6.destroy
destroy(this.p_1)
destroy(this.st_msg)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;datastore ds
ds = message.powerobjectparm
ds.sharedata(dw_1)

f_window_center_response(this)


end event

type p_1 from uo_picture within w_pdt_02030_6
integer x = 2862
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

type st_msg from statictext within w_pdt_02030_6
integer x = 37
integer y = 1368
integer width = 3026
integer height = 88
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdt_02030_6
integer x = 46
integer y = 192
integer width = 3003
integer height = 1148
integer taborder = 10
string dataobject = "d_pdt_02030_strerr"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;sTring sColname
Integer iData

st_msg.text = ''

sColName = dwo.name
If row > 0 then
	if sColName = 'err1' or sColName = 'err2' or sColName = 'err3' or &
	   sColName = 'err4' or sColName = 'err5' or sColName = 'err6' Then
		iData = getitemdecimal(row, scolname)
	End if
End if

if iData > 1 then
	Choose Case sColName
			 Case 'err1'
					st_msg.text = '표준공정에 동시공정이 Cross되어 있읍니다.'
			 Case 'err2'
					if idata = 2 then
						st_msg.text = '작업시간이 없읍니다.'
					Elseif idata = 3 then
						st_msg.text = '최초공정 표시가 없읍니다.'
					Elseif idata = 4 then
						st_msg.text = '최종공정 표시가 없읍니다.'
					Elseif idata = 5 then
						st_msg.text = '표준공정 자료가 없읍니다.'						
					End if
			 Case 'err3'
					if idata = 2 then
						st_msg.text = '최초공정에 최초표시가 없읍니다.'
					Elseif idata = 3 then
						st_msg.text = '최초공정이 동시공정으로 되어 있읍니다.'
					End if
			 Case 'err4'
					if idata = 2 then
						st_msg.text = '최종공정에 최초표시가 없읍니다.'
					Elseif idata = 3 then
						st_msg.text = '최종공정이 동시공정으로 되어 있읍니다.'
					End if				
			 Case 'err5'
					st_msg.text = '구성된 BOM내역이 없읍니다.'
			 Case 'err6'
					st_msg.text = '외주 거래처 내역이 없읍니다.'
	End Choose
End if
end event

type rr_1 from roundrectangle within w_pdt_02030_6
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 184
integer width = 3026
integer height = 1164
integer cornerheight = 40
integer cornerwidth = 55
end type

