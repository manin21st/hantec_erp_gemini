$PBExportHeader$w_org_pmis_emp_info.srw
$PBExportComments$조직도 화면 (개인정보보기)
forward
global type w_org_pmis_emp_info from window
end type
type p_image from picture within w_org_pmis_emp_info
end type
type dw_emp_info from datawindow within w_org_pmis_emp_info
end type
end forward

global type w_org_pmis_emp_info from window
integer x = 1074
integer y = 484
integer width = 3369
integer height = 1384
boolean titlebar = true
string title = "개인별 상세정보"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 78170280
event ue_visible ( )
p_image p_image
dw_emp_info dw_emp_info
end type
global w_org_pmis_emp_info w_org_pmis_emp_info

type variables


end variables

forward prototypes
public subroutine wf_set_person (string as_emp_cd)
end prototypes

event ue_visible();//If w_mainframe.GetActiveSheet() = iw_parent Then
//	This.Show()
//Else
//	This.Hide()
//End If
end event

public subroutine wf_set_person (string as_emp_cd);String	ls_photo_file, ls_extension
Blob		lbl_image

SELECT extension
 INTO :ls_extension
  FROM insa_image
 WHERE empno = :as_emp_cd
 USING sqlca;
if sqlca.sqlcode <> 0 then ls_extension = 'jpg'

//ls_photo_file = gv_env.setupdir + '\사진\' + as_emp_cd + '.' + ls_extension

dw_emp_info.SetTransObject(SQLCA)
dw_emp_info.Retrieve(as_emp_cd, ls_photo_file)

SetNull(lbl_image)

SELECTBLOB IMAGE
      INTO :lbl_image
		FROM INSA_IMAGE
     WHERE EMPNO = :as_emp_cd
     USING SQLCA ;

If SQLCA.SqlCode <> 0 Or IsNull(lbl_image) Then
	p_image.PictureName = '\Source\JPG\사진.jpg'
Else
	p_image.SetReDraw(False)
	p_image.SetPicture(lbl_image)
	p_image.Width  = 690
	p_image.Height = 700
	p_image.SetReDraw(True)
End If
end subroutine

event open;String	ls_parm, ls_emp_cd, ls_photo_file, ls_extension
Blob		lbl_image

This.Width	= 3369
This.Height	= 1384

//UF.set_center(This)

ls_parm = Message.StringParm
ls_emp_cd = ls_parm

SELECT extension
  INTO :ls_extension
  FROM insa_image
 WHERE empno = :ls_emp_cd
 USING sqlca ;

if sqlca.sqlcode <> 0 then ls_extension = 'jpg'

//ls_photo_file = gv_env.setupdir + '\사진\' + ls_emp_cd + '.' + ls_extension

dw_emp_info.SetTransObject(SQLCA)
dw_emp_info.Retrieve(ls_emp_cd, ls_photo_file)

SetNull(lbl_image)

SELECTBLOB IMAGE
      INTO :lbl_image
		FROM INSA_IMAGE
     WHERE EMPNO = :ls_emp_cd
     USING SQLCA ;

If SQLCA.SqlCode <> 0 Or IsNull(lbl_image) Then
	p_image.PictureName = '\Source\JPG\사진.jpg'
Else
	p_image.SetReDraw(False)
	p_image.SetPicture(lbl_image)
	p_image.Width  = 690
	p_image.Height = 700
	p_image.SetReDraw(True)
End If

end event

on w_org_pmis_emp_info.create
this.p_image=create p_image
this.dw_emp_info=create dw_emp_info
this.Control[]={this.p_image,&
this.dw_emp_info}
end on

on w_org_pmis_emp_info.destroy
destroy(this.p_image)
destroy(this.dw_emp_info)
end on

event close;//iw_parent.ii_empinfo_x = This.X
//iw_parent.ii_empinfo_y = This.Y
end event

type p_image from picture within w_org_pmis_emp_info
integer x = 55
integer y = 44
integer width = 690
integer height = 700
boolean bringtotop = true
boolean focusrectangle = false
end type

type dw_emp_info from datawindow within w_org_pmis_emp_info
integer x = 32
integer y = 24
integer width = 3296
integer height = 1256
integer taborder = 1
boolean enabled = false
string dataobject = "de_insa_master"
boolean border = false
boolean livescroll = true
end type

event retrieveend;If Rowcount = 0 Then InsertRow(0)
end event

