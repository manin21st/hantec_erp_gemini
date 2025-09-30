$PBExportHeader$w_org_dept_input_add.srw
$PBExportComments$조직도 신규조직 등록
forward
global type w_org_dept_input_add from window
end type
type p_1 from uo_picture within w_org_dept_input_add
end type
type p_exit from uo_picture within w_org_dept_input_add
end type
type uo_1 from uo_button_okcancel within w_org_dept_input_add
end type
type dw_input from uo_extended_dw within w_org_dept_input_add
end type
end forward

global type w_org_dept_input_add from window
integer x = 1056
integer y = 484
integer width = 1664
integer height = 896
boolean titlebar = true
string title = "조직 추가"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
boolean clientedge = true
event ue_received_code ( )
p_1 p_1
p_exit p_exit
uo_1 uo_1
dw_input dw_input
end type
global w_org_dept_input_add w_org_dept_input_add

event ue_received_code;//if FC.result then
//	choose case FC.kind
//		case 'name_kor', 'manager'
////			dw_input.object.name_kor[1] = FC.data('empname')
////			dw_input.object.manager[1]  = FC.data('empno')
//	end choose
//end if

end event

event open;String	ls_parm, ls_token, ls_org_cd, ls_parent_cd
DateTime	ldt_applydate

//UF.set_center(This)
dw_input.SetTransObject(SQLCA)

ls_parm = Message.StringParm
If Len(ls_parm) > 0 Then
	ls_token = f_get_token(ls_parm, '~t')
	Choose Case ls_token
		Case "##EDIT##"
			// Edit Mode
			ls_org_cd = ls_parm
			dw_input.Retrieve(ls_org_cd)
			dw_input.object.org_cd.tabsequence = 0
			dw_input.object.org_cd.background.color = 67108864
			Title = "조직 변경"
		Case "##ADD##"
			// Add Mode
			ls_parent_cd = ls_parm
			
			dw_input.InsertRow(0)
			dw_input.SetItem(1, "org_cd_parent", ls_parent_cd)
		Case "##ROOT##"
			// Add Root Mode
			ls_parent_cd = ls_parm
			dw_input.InsertRow(0)
			dw_input.SetItem(1, "org_cd", "000000")
			dw_input.SetItem(1, "org_cd_parent", "000000")
			dw_input.object.org_cd.tabsequence = 0
			dw_input.object.org_cd.background.color = 67108864
		Case Else
			Post Close(This)
	End Choose
Else
	Post Close(This)
End If
end event

on w_org_dept_input_add.create
this.p_1=create p_1
this.p_exit=create p_exit
this.uo_1=create uo_1
this.dw_input=create dw_input
this.Control[]={this.p_1,&
this.p_exit,&
this.uo_1,&
this.dw_input}
end on

on w_org_dept_input_add.destroy
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.uo_1)
destroy(this.dw_input)
end on

type p_1 from uo_picture within w_org_dept_input_add
integer x = 1243
integer y = 20
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
boolean border = false
end type

event clicked;call super::clicked;If dw_input.Update() = 1 Then
	COMMIT;
	CloseWithReturn(Parent, "##OK##")
Else
	ROLLBACK;
End If

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

type p_exit from uo_picture within w_org_dept_input_add
integer x = 1417
integer y = 20
integer width = 178
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;Close(Parent)

end event

type uo_1 from uo_button_okcancel within w_org_dept_input_add
boolean visible = false
integer x = 581
integer y = 908
integer taborder = 20
boolean enabled = false
boolean border = false
end type

event constructor;call super::constructor;setmode(false,true)
end event

event ue_ok();call super::ue_ok;If dw_input.Update() = 1 Then
	COMMIT;
	CloseWithReturn(Parent, "##OK##")
Else
	ROLLBACK;
End If

end event

event ue_cancel();call super::ue_cancel;Close(Parent)

end event

on uo_1.destroy
call uo_button_okcancel::destroy
end on

type dw_input from uo_extended_dw within w_org_dept_input_add
integer x = 41
integer y = 188
integer width = 1504
integer height = 528
integer taborder = 10
string dataobject = "d_org_dept_input_add"
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;setmode(0,true,false,0,'')

end event

event ue_findcodes;//FC.row  = 1
//FC.kind = getcolumnname()

//choose case getcolumnname()
//	case 'name_kor', 'manager'
//       FC.find(1, Parent, '사원번호 찾기', 'df_insa_master', " p1_master.companycode = '" + gs_company + "' AND servicekindcode = '1'", trim(gettext()), showtag + '0001001')
//end choose
//
end event

