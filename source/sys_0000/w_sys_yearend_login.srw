$PBExportHeader$w_sys_yearend_login.srw
$PBExportComments$사용자별 연말정산 권한 등록
forward
global type w_sys_yearend_login from window
end type
type p_ret from uo_picture within w_sys_yearend_login
end type
type p_exit from uo_picture within w_sys_yearend_login
end type
type p_mod from uo_picture within w_sys_yearend_login
end type
type dw_2 from u_d_popup_sort within w_sys_yearend_login
end type
type dw_1 from u_key_enter within w_sys_yearend_login
end type
type rr_1 from roundrectangle within w_sys_yearend_login
end type
end forward

global type w_sys_yearend_login from window
integer width = 3698
integer height = 2460
boolean titlebar = true
string title = "사용자별 연말정산 권한 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
p_ret p_ret
p_exit p_exit
p_mod p_mod
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_sys_yearend_login w_sys_yearend_login

on w_sys_yearend_login.create
this.p_ret=create p_ret
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_ret,&
this.p_exit,&
this.p_mod,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_sys_yearend_login.destroy
destroy(this.p_ret)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;
dw_1.settransobject(sqlca)
dw_1.insertrow(0)
dw_1.setcolumn('deptcode')
dw_1.setfocus()

dw_2.settransobject(sqlca)
end event

type p_ret from uo_picture within w_sys_yearend_login
integer x = 3067
integer y = 16
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type

event clicked;String sCode, sName, sUserId, sCpyuser

If dw_1.accepttext() <> 1 Then Return 
sCode = dw_1.GetItemString(1,"deptcode")
if sCode = '' or IsNull(sCode) then sCode = '%'

If dw_2.Retrieve(sCode) <=0 then
	Messagebox("확인", "조회한 자료가 없습니다.")
	return 
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\조회_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\조회_up.gif'
end event

type p_exit from uo_picture within w_sys_yearend_login
integer x = 3406
integer y = 16
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\닫기_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\닫기_up.gif'
end event

type p_mod from uo_picture within w_sys_yearend_login
integer x = 3237
integer y = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\ERPMAN\image\저장_up.gif"
end type

event clicked;String sCode, sName, sUserId, sCpyuser

If dw_2.accepttext() <> 1 Then Return 

If dw_2.update() <> 1 Then
	rollback;
	Messagebox("확인", "저장에 실패하였습니다!")
	dw_2.setfocus()
	return 
End If

commit;

Messagebox("저장", "자료가 저장되었읍니다")

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\저장_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\저장_up.gif'
end event

type dw_2 from u_d_popup_sort within w_sys_yearend_login
integer x = 46
integer y = 196
integer width = 3511
integer height = 2044
integer taborder = 20
string dataobject = "d_sys_yearend_login"
boolean vscrollbar = true
boolean border = false
end type

type dw_1 from u_key_enter within w_sys_yearend_login
integer x = 37
integer y = 36
integer width = 1627
integer height = 144
integer taborder = 10
string dataobject = "d_sys_yearend_login_c"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String sDeptCode,sCodeName,sNull

SetNull(sNull)

IF this.GetColumnName() = "deptcode" THEN
	sDeptCode = this.GetText()
	
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return
	END IF
	sCodeName = f_code_select('부서',sDeptCode )
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
		this.SetItem(1,"deptcode",snull)
		this.SetItem(1,"p0_dept_deptname2",snull)
		Return 1
	ELSE
		this.SetItem(1,"p0_dept_deptname2",sCodeName)	
	END IF
END IF
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = '%'
IF this.GetColumnName() ="deptcode" THEN
	
//	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
	this.SetItem(1,"p0_dept_deptname2",gs_codename)	
END IF

end event

type rr_1 from roundrectangle within w_sys_yearend_login
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 188
integer width = 3538
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

