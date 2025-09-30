$PBExportHeader$w_groupware_browser.srw
$PBExportComments$** 구매결의서
forward
global type w_groupware_browser from window
end type
type sle_2 from singlelineedit within w_groupware_browser
end type
type st_1 from statictext within w_groupware_browser
end type
type sle_1 from singlelineedit within w_groupware_browser
end type
type p_end from uo_picture within w_groupware_browser
end type
type p_cancel from uo_picture within w_groupware_browser
end type
type ole_1 from olecustomcontrol within w_groupware_browser
end type
end forward

global type w_groupware_browser from window
integer width = 4672
integer height = 3060
boolean titlebar = true
string title = "[전자결제]"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
windowtype windowtype = response!
long backcolor = 32106727
sle_2 sle_2
st_1 st_1
sle_1 sle_1
p_end p_end
p_cancel p_cancel
ole_1 ole_1
end type
global w_groupware_browser w_groupware_browser

on w_groupware_browser.create
this.sle_2=create sle_2
this.st_1=create st_1
this.sle_1=create sle_1
this.p_end=create p_end
this.p_cancel=create p_cancel
this.ole_1=create ole_1
this.Control[]={this.sle_2,&
this.st_1,&
this.sle_1,&
this.p_end,&
this.p_cancel,&
this.ole_1}
end on

on w_groupware_browser.destroy
destroy(this.sle_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.p_end)
destroy(this.p_cancel)
destroy(this.ole_1)
end on

event open;string sAddr

String	ls_path

f_window_center(this)

select  dataname into :ls_path from syscnfg where sysgu = 'W' and  serial = 1 and lineno = '6' ;

if isnull(gs_codename) then
	gs_codename=""
end if

// 문서제목을 받을 경우
if gs_codename<>"" then
	st_1.Visible = True
	sle_1.Visible = True
	sle_1.Text = gs_codename
	//sAddr = "http://" + ls_path + "/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid +"&" + "FolderId="+gs_gubun+gs_code+ "&ERPTITLE="+GS_CODENAME
   sAddr = "http://" + ls_path + "/WBCGI/WBLogin.aspx?IsAction=1&UserId_auto="+Lower(gs_userid) +"&password="+Lower(gs_PassWord)+"&next=EAERPGetRecord.asp?FromERP=1%26EAID=" + gs_gubun + gs_code+ "%26ERPTITLE="+GS_CODENAME
Else
	//sAddr = "http://" + ls_path + "/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid +"&" + "FolderId="+gs_gubun+gs_code
	//sAddr = "http://" + ls_path + "/WBCGI/WBLogin.aspx?IsAction=1&UserId_auto="+Lower(gs_userid) +"&password="+Lower(gs_PassWord)+"&next=EAERPGetRecord.asp?FromERP=1%26EAID=" + gs_gubun + gs_code
	
	//Direct_erp 적용할 경우 direct_erp=0(저장안하고 결재라인 자동지정인 경우),1:바로 그룹웨어로 저장
	//sAddr = "http://" + ls_path + "/WBCGI/WBlogin.aspx?IsAction=1&UserId_auto="+Lower(gs_userid) +"&next=EAERPGetRecord.asp?FromERP=1%26EAID=" + gs_gubun +"%26IsWorking=1%26directErp=ok%26" + gs_code

	// 결재라인을 사용자가 직접 지정하는 경우
	sAddr = "http://" + ls_path + "/WBCGI/WBlogin.aspx?IsAction=1&UserId_auto="+Lower(gs_userid) +"&next=EAERPGetRecord.asp?FromERP=1%26EAID=" + gs_gubun +"%26" + gs_code
End If
sle_2.text = saddr
ole_1.object.Navigate(sAddr)

// 결재완료된 문서 조회시 사용함
// http://gw.acedigitech.co.kr:8888/WBCGI/WBLogin.aspx?IsAction=1&UserId_auto=dazone&next=/WBCGI/EAFormView.aspx?ReporterId=admin%26ReportNum=44%26IsReporter=1%26ApprovalStatus=4
end event

type sle_2 from singlelineedit within w_groupware_browser
boolean visible = false
integer x = 585
integer y = 12
integer width = 3392
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_groupware_browser
boolean visible = false
integer x = 46
integer y = 56
integer width = 347
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 65535
long backcolor = 8388736
string text = "문서 제목"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_groupware_browser
boolean visible = false
integer x = 402
integer y = 56
integer width = 3488
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

event modified;string sAddr

String	ls_path


select  dataname into :ls_path from syscnfg where sysgu = 'W' and  serial = 5 and lineno = 6 ;

// 문서제목을 받을 경우
If Not IsNull(this.text) Then
//	sAddr = "http://" + ls_path + "/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid +"&" + "FolderId="+gs_gubun+gs_code+ "&ERPTITLE="+this.text
   sAddr = "http://" + ls_path + "/WBCGI/WBLogin.aspx?IsAction=1&UserId_auto="+gs_userid +"&next=EAERPGetRecord.asp?FromERP=1%26EAID=" + gs_gubun + gs_code+ "%26ERPTITLE="+this.text	
Else
	//sAddr = "http://" + ls_path + "/WBCGI/WBAuthPass.asp?userid_erp="+gs_userid +"&" + "FolderId="+gs_gubun+gs_code
	sAddr = "http://" + ls_path + "/WBCGI/WBLogin.aspx?IsAction=1&UserId_auto="+gs_userid +"&next=EAERPGetRecord.asp?FromERP=1%26EAID=" + gs_gubun + gs_code
End If

MessageBox('', saddr)
ole_1.object.Navigate(sAddr)
end event

type p_end from uo_picture within w_groupware_browser
integer x = 4206
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;gs_code = 'Y'
close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\닫기_dn.gif'

end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\닫기_up.gif'
end event

type p_cancel from uo_picture within w_groupware_browser
integer x = 4032
integer y = 24
integer width = 178
boolean originalsize = true
string picturename = "C:\ERPMAN\image\취소_up.gif"
end type

event clicked;int i, j

j = messagebox('확인', '결제없이 의뢰 확정하시겠습니까?', Question!, Yesno!, 2)
If j = 1 Then 
	gs_code = 'N'
Else
	gs_code = 'C'
End If
close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'C:\ERPMAN\image\취소_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'C:\ERPMAN\image\취소_dn.gif'
end event

type ole_1 from olecustomcontrol within w_groupware_browser
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
integer y = 180
integer width = 4594
integer height = 2748
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_groupware_browser.win"
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cw_groupware_browser.bin 
2900000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000009603b2001c6286400000003000000c00000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f0000000009603b2001c6286409603b2001c62864000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c000000000000000100000002fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c000067df000047010000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c046000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000010801b4041dbf800423478800000000000000000225d3200000076500030002004600030100ffff00000001011a0004010800be0015019804221fe8005f006c003700300033003000000032011e0006010801a2041dbf80042347d800000000000000000225d3680000076600030002004600030100ffff0000000101240004010800a40015019804221fe8005f006c00370030003300300000003401280006010801a8041dbf800423482800000000000000000225d2000000076700030002004600030100ffff00000001012e0004010800520015019804221fe8005f006c0037003000340030000000300132000601080156041dbf800423487800000000000000000225d2900000076800030002004600030100ffff0000000101380004010800580015019804221fe8005f006c003700300034003000000032013c00060108015c041dbf80042348c800000000000000000225d248000007690003000200460003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cw_groupware_browser.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
