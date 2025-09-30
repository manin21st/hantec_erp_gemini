$PBExportHeader$w_imt_02010_1.srw
$PBExportComments$** 발주서
forward
global type w_imt_02010_1 from window
end type
type p_print from uo_picture within w_imt_02010_1
end type
type p_end from uo_picture within w_imt_02010_1
end type
type p_cancel from uo_picture within w_imt_02010_1
end type
type p_sangsin from uo_picture within w_imt_02010_1
end type
type dw_1 from datawindow within w_imt_02010_1
end type
type ole_1 from olecustomcontrol within w_imt_02010_1
end type
end forward

global type w_imt_02010_1 from window
integer width = 4699
integer height = 2960
boolean titlebar = true
string title = "발주서"
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
global w_imt_02010_1 w_imt_02010_1

on w_imt_02010_1.create
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

on w_imt_02010_1.destroy
destroy(this.p_print)
destroy(this.p_end)
destroy(this.p_cancel)
destroy(this.p_sangsin)
destroy(this.dw_1)
destroy(this.ole_1)
end on

event open;f_window_center_response(this)

if gs_gubun = '1' then
	dw_1.DataObject = 'd_imt_02010_4'
else
	dw_1.DataObject = 'd_imt_02010_3'
end if

dw_1.SetTransObject(sqlca)
dw_1.retrieve(gs_sabu, gs_code)
dw_1.object.datawindow.print.preview = "yes"
end event

type p_print from uo_picture within w_imt_02010_1
integer x = 4146
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

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\인쇄_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\인쇄_dn.gif'
end event

type p_end from uo_picture within w_imt_02010_1
integer x = 4494
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\닫기_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\닫기_dn.gif'
end event

type p_cancel from uo_picture within w_imt_02010_1
integer x = 4320
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
	p_sangsin.PictureName = 'C:\ERPMAN\image\결재상신_up.gif'
	p_sangsin.Enabled = true
else
	j = messagebox('확인', '결제없이 검토 확정하시겠습니까?', Question!, Yesno!, 2)
	if j = 1 then
		Update estima
         set blynd = '2'
		 where substr(estno,1,12) = :gs_code;
		 
		commit;
		SetNull(gs_code)	
		p_end.TriggerEvent(Clicked!)
	else
		return
	end if
	
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\취소_up.gif'
end event

type p_sangsin from uo_picture within w_imt_02010_1
event ue_lbuttondn pbm_lbuttondown
integer x = 3973
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\결재상신_up.gif"
end type

event ue_lbuttondn;this.PictureName = 'C:\ERPMAN\image\결재상신_dn.gif'
end event

event clicked;if ole_1.Visible then Return

long i, ll_qty, ll_amt, ll_cnt
string ls_no, ls_cod, ls_cvnas, ls_name, ls_dept, ls_dsc

IF gs_gubun = '2' then
	select count(*) into :ll_cnt
	  from estima_web
	 where estno = gs_code;
	 
	if ll_cnt > 1 then
	else
	
		For i = 1 to dw_1.RowCount()
		
			ls_no    = dw_1.GetItemString(i,1)
			ls_cod   = dw_1.GetItemString(i,2)
			ls_cvnas = dw_1.GetItemString(i,3)
			ls_name  = dw_1.GetItemString(i,4)
			ls_dept  = dw_1.GetItemString(i,5)
			ls_dsc   = dw_1.GetItemString(i,6)
			ll_qty   = dw_1.GetItemNumber(i,7)
			ll_amt   = dw_1.GetItemNumber(i,8)
		
			Insert Into estima_web
			(	estno,	cvcod,	cvnas,	empname,	deptname,	itdsc,	guqty,	quamt )
			Values (:ls_no, :ls_cod, :ls_cvnas, :ls_name, :ls_dept, :ls_dsc, :ll_qty, :ll_amt);
			
			IF Sqlca.SqlCode <> 0 THEN 
				MEssageBox('', Sqlca.SqlerrText)
				RollBack ;
				Return 
			END IF
			
			Commit;
		
		Next
		
	end if
end if
string sAddr

if gs_gubun = '1' then
	sAddr = "http://61.97.119.235:81/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid+"&" + &
	        "FolderId=0000000049&SABU=1&ESTNO="+gs_code+"&BLYND=8"
   ole_1.object.Navigate(sAddr)
else
	sAddr = "http://61.97.119.235:81/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid+"&" + &
	        "FolderId=0000000047&ESTNO="+gs_code
   ole_1.object.Navigate(sAddr)
end if

dw_1.visible = false
ole_1.visible = true
p_print.enabled = false
p_print.PictureName = 'C:\ERPMAN\image\인쇄_d.gif'
this.PictureName = 'C:\ERPMAN\image\결재상신_d.gif'
this.Enabled = false
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\결재상신_up.gif'
end event

type dw_1 from datawindow within w_imt_02010_1
integer x = 18
integer y = 612
integer width = 4645
integer height = 2260
integer taborder = 10
string title = "none"
string dataobject = "d_imt_02010_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type ole_1 from olecustomcontrol within w_imt_02010_1
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
string binarykey = "w_imt_02010_1.win"
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
09w_imt_02010_1.bin 
2800000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000008ef409f001c3519900000003000000c00000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f000000008ef409f001c351998ef409f001c35199000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c000000000000000100000002fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c000069020000450a0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c046000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000003600300032005f005c0035006f007300720075006500630000002901180006000c0000001904c00018f200000000000000000006863ad0000d0000012400000102ffff0000000100000000011e000e0008010000730062005f006100390065003900390070002e006c006200280020003a0043bc30005cd310d3ecae30005fd30ccd08005cc77c006f007300720075006500630032005f00300030005f0033003600300032005f005c0035006f0073007200750065006300000029012c0006000c0000001905600018f200000000000000000006acd738000d0000014200000102ffff00000001000000000132000e0008010000730062005f006100300070003000310070002e006c006200280020003a0043bc30005cd310d3ecae30005fd30ccd08005cc77c006f007300720075006500630032005f00300030005f0033003600300032005f005c0035006f007300720075006500630000002901400006000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19w_imt_02010_1.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
