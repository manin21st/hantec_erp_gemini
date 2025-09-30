$PBExportHeader$w_pdt_04000_2.srw
$PBExportComments$** 구매결의서
forward
global type w_pdt_04000_2 from window
end type
type p_print from uo_picture within w_pdt_04000_2
end type
type p_end from uo_picture within w_pdt_04000_2
end type
type p_cancel from uo_picture within w_pdt_04000_2
end type
type p_sangsin from uo_picture within w_pdt_04000_2
end type
type dw_1 from datawindow within w_pdt_04000_2
end type
type ole_1 from olecustomcontrol within w_pdt_04000_2
end type
end forward

global type w_pdt_04000_2 from window
integer width = 4699
integer height = 2960
boolean titlebar = true
string title = "구매결의서"
boolean controlmenu = true
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 32106727
p_print p_print
p_end p_end
p_cancel p_cancel
p_sangsin p_sangsin
dw_1 dw_1
ole_1 ole_1
end type
global w_pdt_04000_2 w_pdt_04000_2

on w_pdt_04000_2.create
this.p_print=create p_print
this.p_end=create p_end
this.p_cancel=create p_cancel
this.p_sangsin=create p_sangsin
this.dw_1=create dw_1
this.ole_1=create ole_1
this.Control[]={this.p_print,&
this.p_end,&
this.p_cancel,&
this.p_sangsin,&
this.dw_1,&
this.ole_1}
end on

on w_pdt_04000_2.destroy
destroy(this.p_print)
destroy(this.p_end)
destroy(this.p_cancel)
destroy(this.p_sangsin)
destroy(this.dw_1)
destroy(this.ole_1)
end on

event open;call super::open;f_window_center_response(this)
dw_1.SetTransObject(sqlca)

dw_1.retrieve(gs_sabu, gs_code)

dw_1.object.datawindow.print.preview = "yes"

string sAddr

sAddr = "http://61.97.119.235:81/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid +"&" + &
        "FolderId=0000000048&SABU=1&ESTNO="+gs_code+"&BLYND=9"
//        "FolderId=0000000034&SABU=1&ESTNO="+gs_code+"&BLYND=9"
ole_1.object.Navigate(sAddr)
end event

type p_print from uo_picture within w_pdt_04000_2
integer x = 4142
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\인쇄_up.gif"
end type

event clicked;call super::clicked;IF dw_1.rowcount() > 0 then 
	gi_page = dw_1.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_1)
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\인쇄_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\인쇄_up.gif'
end event

type p_end from uo_picture within w_pdt_04000_2
integer x = 4489
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\닫기_dn.gif'

end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\닫기_up.gif'
end event

type p_cancel from uo_picture within w_pdt_04000_2
integer x = 4315
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\취소_up.gif"
end type

event clicked;call super::clicked;int i, j

if ole_1.visible then
	ole_1.visible = false
	dw_1.visible = true
	p_print.Enabled = true
	p_print.PictureName = 'C:\ERPMAN\image\인쇄_up.gif'
	p_sangsin.Enabled = true
	p_sangsin.PictureName = 'C:\ERPMAN\image\결재상신_up.gif'
else
	j = messagebox('확인', '결제없이 의뢰 확정하시겠습니까?', Question!, Yesno!, 2)
	if j = 1 then
		Update estima
         set blynd = '1'
		 where substr(estno,1,12) = :gs_code;
		 
		commit;
		SetNull(gs_code)	
		p_end.TriggerEvent(Clicked!)
	else
		return
	end if
	
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\취소_dn.gif'
end event

type p_sangsin from uo_picture within w_pdt_04000_2
integer x = 3968
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\결재상신_up.gif"
end type

event clicked;if ole_1.Visible then
	return
else
	dw_1.visible = false
   ole_1.visible = true
   p_print.enabled = false
   p_print.PictureName = 'C:\ERPMAN\image\인쇄_d.gif'
	this.Enabled = false
	this.PictureName = 'C:\ERPMAN\image\결재상신_d.gif'
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\결재상신_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\결재상신_dn.gif'
end event

type dw_1 from datawindow within w_pdt_04000_2
integer x = 37
integer y = 552
integer width = 4645
integer height = 2572
integer taborder = 10
string title = "none"
string dataobject = "d_pdt_04000_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type ole_1 from olecustomcontrol within w_pdt_04000_2
event statustextchange ( string text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean ar_cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean ar_cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
boolean visible = false
integer x = 23
integer y = 196
integer width = 4645
integer height = 2672
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_pdt_04000_2.win"
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
09w_pdt_04000_2.bin 
2800000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000005d6f579001c3519900000003000000c00000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f000000005d6f579001c351995d6f579001c35199000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c000000000000000100000002fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c000069020000450a0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c04600000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000200028002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d0062006f005f00650070005d006e006f0000006800740072006500280020007500200073006e006700690065006e006c0064006e006f002000670070007700720061006d00610020002c006f006c0067006e006c002000610070006100720020006d002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d0062006f005f00680074007200650000005d00cc0004000c010000000000000000009a0a0b0100000000000000000000000000d0002e00080000001302e800200c50000075300000000100000001000000000000000000000000000000000000000000000000000000000000000000000000001c081a006893000000000100000001000000b80000000e0017078c00000000000000000000000009c011010000001100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19w_pdt_04000_2.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
