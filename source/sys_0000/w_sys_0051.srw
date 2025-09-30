$PBExportHeader$w_sys_0051.srw
$PBExportComments$** 환경설정(관리구분 등록)
forward
global type w_sys_0051 from window
end type
type p_2 from uo_picture within w_sys_0051
end type
type p_1 from uo_picture within w_sys_0051
end type
type dw_title from u_key_enter within w_sys_0051
end type
end forward

global type w_sys_0051 from window
integer x = 837
integer y = 672
integer width = 1600
integer height = 580
boolean titlebar = true
string title = "관리명 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_2 p_2
p_1 p_1
dw_title dw_title
end type
global w_sys_0051 w_sys_0051

type variables
string sGucode
end variables

event open;String srtn_msg

f_window_center(this)
dw_title.SetTransObject(SQLCA)
dw_title.Reset()
dw_title.InsertRow(0)

srtn_msg = message.StringParm

dw_title.SetItem(1,"sysgu",Left(srtn_msg,1))
dw_title.object.txt_1.text = mid(srtn_msg,2,50)

dw_title.SetColumn("serial")
dw_title.SetFocus()
end event

on w_sys_0051.create
this.p_2=create p_2
this.p_1=create p_1
this.dw_title=create dw_title
this.Control[]={this.p_2,&
this.p_1,&
this.dw_title}
end on

on w_sys_0051.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_title)
end on

type p_2 from uo_picture within w_sys_0051
integer x = 1303
integer y = 324
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;String snull

SetNull(snull)
CloseWithReturn(parent,snull)
end event

type p_1 from uo_picture within w_sys_0051
integer x = 1115
integer y = 324
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;String sdata1, sdata2, sdata3
int inum

dw_title.AcceptText()
sdata1 = Trim(dw_title.GetItemString(1,"sysgu"))
inum = dw_title.GetItemNumber(1,"serial")
sdata3 = Trim(dw_title.GetItemString(1,"titlename"))
if sdata1 = "" or IsNull(sdata1) then
	f_message_chk(1400,'[필수입력항목]') 
	return
elseif inum = 0 or IsNull(inum) then
	f_message_chk(1400,'[필수입력항목]') 
	return
elseif sdata3 = "" or IsNull(sdata3) then
	f_message_chk(1400,'[필수입력항목]') 
	return
end if

INSERT INTO SYSCNFG
(SYSGU, SERIAL, LINENO, TITLENAME)
VALUES
(:sdata1, :inum, '00', :sdata3);

if sqlca.sqlcode = 0 then
	COMMIT;
	if inum > 9 then 
		sdata2 = String(inum)
	else
		sdata2 = "0" + String(inum) 
	end if	
	CloseWithReturn(Parent, sdata1 + sdata2 + sdata3)
else
	ROLLBACK;
	f_message_chk(1,'[자료중복]') 
	CloseWithReturn(Parent, "ERROR")
end if

end event

type dw_title from u_key_enter within w_sys_0051
integer x = 64
integer y = 52
integer width = 1463
integer height = 276
integer taborder = 10
string dataobject = "d_sys_00511"
boolean border = false
boolean livescroll = false
end type

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="titlename" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event itemerror;return 1
end event

