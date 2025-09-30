$PBExportHeader$w_sys_001_mdi_sheet_01.srw
$PBExportComments$�ű� USER-ID����
forward
global type w_sys_001_mdi_sheet_01 from window
end type
type p4 from uo_picture within w_sys_001_mdi_sheet_01
end type
type p_3 from uo_picture within w_sys_001_mdi_sheet_01
end type
type p_2 from uo_picture within w_sys_001_mdi_sheet_01
end type
type p_1 from uo_picture within w_sys_001_mdi_sheet_01
end type
type rb_group from radiobutton within w_sys_001_mdi_sheet_01
end type
type rb_user from radiobutton within w_sys_001_mdi_sheet_01
end type
type dw_userid from datawindow within w_sys_001_mdi_sheet_01
end type
type rr_1 from roundrectangle within w_sys_001_mdi_sheet_01
end type
end forward

global type w_sys_001_mdi_sheet_01 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "User-Id Create"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p4 p4
p_3 p_3
p_2 p_2
p_1 p_1
rb_group rb_group
rb_user rb_user
dw_userid dw_userid
rr_1 rr_1
end type
global w_sys_001_mdi_sheet_01 w_sys_001_mdi_sheet_01

type variables
String iold_userid, inew_userid, inew_password
String is_window_id, is_today, is_totime, is_usegub
end variables

forward prototypes
public function integer wf_usercopy (string crtuser, string cpyuser)
end prototypes

public function integer wf_usercopy (string crtuser, string cpyuser);//���� ���α׷������� �ʱ�ȭ//
delete from sub2_user_t
where user_id = :crtuser;

if sqlca.sqlcode <> 0 then 
	messagebox('Ȯ ��', '������ ����ں� ���α׷� ���� ����!', StopSign!)
	ROLLBACK;
	return -1
end if

//���� attention menu �ʱ�ȭ//
delete from sub2_user_r
where user_id = :crtuser;

if sqlca.sqlcode <> 0 then 
	messagebox('Ȯ ��', 'ATTENTION MENU ���� ����!', StopSign!)
	ROLLBACK;
	return -1
end if

//user�� ���α׷������� copy//
  INSERT INTO "SUB2_USER_T"  
         ( "USER_ID",   
           "MAIN_ID",   
           "SUB1_ID",   
           "SUB2_ID",   
           "SUB2_NAME",   
           "WINDOW_NAME",   
           "USER_GUB" )  
     SELECT :crtuser,   
            "SUB2_USER_T"."MAIN_ID",   
            "SUB2_USER_T"."SUB1_ID",   
            "SUB2_USER_T"."SUB2_ID",   
            "SUB2_USER_T"."SUB2_NAME",   
            "SUB2_USER_T"."WINDOW_NAME",   
            "SUB2_USER_T"."USER_GUB"  
       FROM "SUB2_USER_T"  
      WHERE "SUB2_USER_T"."USER_ID" = :cpyuser   ;
		
if sqlca.sqlcode <> 0 then 
	messagebox('Ȯ ��', 'COPY ����ں� ���α׷� ���� ����!', StopSign!)
	ROLLBACK;
	return -1
end if

//user�� attention menu copy//
  INSERT INTO "SUB2_USER_R"  
         ( "USER_ID",   
           "P_WINDOW",   
           "C_WINDOW" )  
     SELECT :crtuser,   
            "SUB2_USER_R"."P_WINDOW",   
            "SUB2_USER_R"."C_WINDOW"  
       FROM "SUB2_USER_R"  
      WHERE "SUB2_USER_R"."USER_ID" = :cpyuser   ;

if sqlca.sqlcode <> 0 then 
	messagebox('Ȯ ��', 'COPY  ATTENTION MENU ���� ����!', StopSign!)
	ROLLBACK;
	return -1
end if

return 1
end function

on w_sys_001_mdi_sheet_01.create
this.p4=create p4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.rb_group=create rb_group
this.rb_user=create rb_user
this.dw_userid=create dw_userid
this.rr_1=create rr_1
this.Control[]={this.p4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.rb_group,&
this.rb_user,&
this.dw_userid,&
this.rr_1}
end on

on w_sys_001_mdi_sheet_01.destroy
destroy(this.p4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.rb_group)
destroy(this.rb_user)
destroy(this.dw_userid)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  


rb_user.TriggerEvent(clicked!)


end event

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type p4 from uo_picture within w_sys_001_mdi_sheet_01
integer x = 3008
integer y = 388
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\ERPMAN\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\�ݱ�_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\�ݱ�_dn.gif'
end event

type p_3 from uo_picture within w_sys_001_mdi_sheet_01
integer x = 2843
integer y = 388
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\ERPMAN\image\���_up.gif"
end type

event clicked;dw_userid.setredraw(false)
dw_userid.reset()
dw_userid.insertrow(0)
dw_userid.setredraw(true)
dw_userid.setcolumn('userid')
dw_userid.setfocus()

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\���_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\���_dn.gif'
end event

type p_2 from uo_picture within w_sys_001_mdi_sheet_01
integer x = 2679
integer y = 388
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\ERPMAN\image\����_up.gif"
end type

event clicked;String sUserid

SetPointer(HourGlass!)

if dw_userid.accepttext() < 1 then return 

sUserid = dw_userid.getitemstring(1, "userid")

If rb_user.Checked = True Then  //�Ϲݻ���� ����
	If Isnull(sUserid) then
		Messagebox("USER-ID", "USER-ID�� Ȯ���Ͻʽÿ�", stopsign!)
		return 
	else
		If Messagebox("����Ȯ��", "User  -> " + sUserid  + " �� �����Ͻð����ϱ�?", &
											question!, yesno!, 2) = 2 Then return 
	
									  
		delete from sub2_user_r
				 where user_id = :sUserid;
				 
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', 'ATTENTION MENU ���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
		
		/* User Menu���� */
		Delete From sub2_user_t
				Where user_id = :sUserid;
	
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', '���α׷� MENU ���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
		
		/* User ���� */
		Delete from login_t 
				Where l_userid = :sUserid;
	
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', '���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
	
		Commit;	
								  
	End if
ELSE
	If Isnull(sUserid) then
		Messagebox("GROUP-ID", "GROUP-ID�� Ȯ���Ͻʽÿ�", stopsign!)
		return 
	else
		If Messagebox("����Ȯ��", "GROUP�� �����Ͻø� GROUP�� ���� �Ϲ� ����� ��θ� �����մϴ�." + "~n~n" +&
		                          "GROUP  -> " + sUserid  + " �� �����Ͻð����ϱ�?", &
											question!, yesno!, 2) = 2 Then return 

 	   DELETE FROM SUB2_USER_R A 
		 WHERE EXISTS ( SELECT *
								FROM LOGIN_T 
							  WHERE L_USERID = A.USER_ID  
								 AND L_GROUPNAME  = :sUserid )   ;
									  
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', 'ATTENTION MENU ���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
		
		/* User Menu���� */
 	   DELETE FROM SUB2_USER_T A 
		 WHERE EXISTS ( SELECT *
								FROM LOGIN_T 
							  WHERE L_USERID = A.USER_ID  
								 AND L_GROUPNAME  = :sUserid )   ;
	
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', '���α׷� MENU ���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
		
		/* �Ϲݻ���� ���� */
		Delete from login_t 
				Where l_gubun  = 1
				  and l_groupname = :sUserid;
	
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', '�Ϲ� ����� ���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
		
		/* GROUP ���� */
		Delete from login_t 
				Where l_userid = :sUserid;
	
		IF SQLCA.SQLCODE <> 0 THEN 
			MESSAGEBOX('Ȯ��', '���� ����!', StopSign! )
			ROLLBACK;
			RETURN 
		END IF
	
		Commit;	
								  
	End if
END IF

dw_userid.reset()
dw_userid.insertrow(0)
dw_userid.setcolumn('userid')
dw_userid.setfocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\����_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\����_dn.gif'
end event

type p_1 from uo_picture within w_sys_001_mdi_sheet_01
integer x = 2514
integer y = 388
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\ERPMAN\image\����_up.gif"
end type

event clicked;String sCode, sName, sUserId, sCpyuser

SetPointer(HourGlass!)

If dw_userid.accepttext() <> 1 Then Return -1

sUserId = Trim(dw_userid.getitemstring(1, "userid"))
If Isnull(sUserId) or sUserId = '' then
	Messagebox("ID", "ID�� �ʼ� �Է»����Դϴ�", stopsign!)
	dw_userid.setcolumn("userid")
	dw_userid.setfocus()
	return 0
End if

If Isnull(dw_userid.getitemstring(1, "password")) or Trim(dw_userid.getitemstring(1, "password")) = '' then
	Messagebox("Password", "Password�� �ʼ� �Է»����Դϴ�", stopsign!)
	dw_userid.setcolumn("password")
	dw_userid.setfocus()
	return 0
End if

If Isnull(dw_userid.getitemstring(1, "l_sabu")) or Trim(dw_userid.getitemstring(1, "l_sabu")) = '' then
	Messagebox("�����", "����δ� �ʼ� �Է»����Դϴ�", stopsign!)
	dw_userid.setcolumn("l_sabu")
	dw_userid.setfocus()
	return 0
End if

/* User ��Ͻ� group�� Ȯ�� */
If rb_user.Checked = True Then
	sCode = dw_userid.getitemstring(1, "groupname")
	Select L_gubun 
	  Into :sName 
	  From login_t 
	 where L_userid = :sCode;
	
	If Sqlca.sqlcode <> 0 then
		Messagebox("�׷��", "�׷���� ����Ȯ�մϴ�!")
		dw_userid.setcolumn("groupname")
		dw_userid.setfocus()
		return 0
	End if
	
	If sname = '1' Then
		Messagebox("�׷��", "�ش�׷���� �Ϲݻ���� �Դϴ�!")
		dw_userid.setcolumn("groupname")
		dw_userid.setfocus()
		return 0
	End if
	
	scpyuser = trim(dw_userid.getitemstring(1, "copy_id"))
	If not Isnull(scpyuser)  Then
		Select L_userid Into :scpyuser From login_t where L_userid = :scpyuser;
		If Sqlca.sqlcode <> 0 then
			Messagebox("USER_ID", "COPY �� USER_ID�� ����Ȯ�մϴ�!")
			dw_userid.setcolumn("copy_id")
			dw_userid.setfocus()
			return 
		else
			IF wf_usercopy(sUserid, scpyuser) = -1 THEN 
				RETURN 
			END IF
		end if
	End if
/* Group ��Ͻ� Group�� �Է� */
Else
	dw_userid.SetItem(1,'gubun', '0')
	dw_userid.SetItem(1,'groupname', sUserId)
End If

If dw_userid.update() <> 1 Then
	rollback;
	Messagebox("Ȯ��", "���忡 �����Ͽ����ϴ�!")
	dw_userid.setfocus()
	return -1
End If

Messagebox("����", "�ڷᰡ ����Ǿ����ϴ�")

commit;

dw_userid.setredraw(false)
dw_userid.reset()
dw_userid.insertrow(0)
dw_userid.setredraw(true)

Return 1
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\ERPMAN\image\����_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\ERPMAN\image\����_dn.gif'
end event

type rb_group from radiobutton within w_sys_001_mdi_sheet_01
integer x = 1906
integer y = 424
integer width = 448
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "GROUP ID ����"
end type

event clicked;dw_userid.SetRedraw(False)
dw_userid.DataObject = 'd_sys_001_mdi_sheet_01_1'

dw_userid.settransobject(sqlca)
dw_userid.insertrow(0)
dw_userid.setcolumn('userid')
dw_userid.setItem(1,'gubun','0')

dw_userid.setfocus()

dw_userid.SetRedraw(True)
end event

type rb_user from radiobutton within w_sys_001_mdi_sheet_01
integer x = 1477
integer y = 424
integer width = 489
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
string text = "USER ID ����"
boolean checked = true
end type

event clicked;dw_userid.SetRedraw(False)

dw_userid.DataObject = 'd_sys_001_mdi_sheet_01'

dw_userid.settransobject(sqlca)
dw_userid.insertrow(0)
dw_userid.setcolumn('userid')
dw_userid.setItem(1,'gubun','1')
dw_userid.setfocus()

dw_userid.SetRedraw(True)
end event

type dw_userid from datawindow within w_sys_001_mdi_sheet_01
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 1440
integer y = 556
integer width = 1746
integer height = 1144
integer taborder = 10
string dataobject = "d_sys_001_mdi_sheet_01"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;If Key = Keyf1! then
	This.triggerevent(rbuttondown!)
End if
end event

event ue_downenter;send(handle(this), 256, 9, 0)
return 1
end event

event itemerror;return 1
end event

event itemchanged;String sData, sNull
Long   lGubun

SetNull(sNull)
Choose Case dwo.name
	Case 'userid'
		/* ������ �����Ұ�� ��ȸ */
		Select l_userid , l_gubun
		  Into :sData ,:lgubun
		  From login_t 
		 where l_userid = :data;
		 
		If sqlca.sqlcode <> 0 Then Return
		
		If rb_user.Checked = True and lGubun = 0 Then
			MessageBox('Ȯ ��','Group Id�� �̹� ������Դϴ�')
			SetItem(1,'userid', sNull)
			Return 1
		End if
		
		If rb_user.Checked = False and lGubun = 1 Then
			MessageBox('Ȯ ��','User Id�� �̹� ������Դϴ�')
			SetItem(1,'userid', sNull)
			Return 1
		End if
		
		If Sqlca.sqlcode = 0 then
			this.retrieve(sdata)
		End if
		
	Case 'dept'
		  Select deptname2 Into :sData From p0_dept where deptcode = :data;
		  If Sqlca.sqlcode = 0 then
			  this.setitem(1, "cvnas", sData)		  
 		  Else
			  gs_code 	  = data
			  gs_codename = ''
			  this.triggerevent(rbuttondown!)
			  Return 1
		  End if
	Case 'cvnas'
		  Select deptcode Into :sData From p0_dept where deptname = :data;
		  If Sqlca.sqlcode = 0 then
			  this.setitem(1, "dept", sData)
 		  Else
			  gs_code 	  = ''
			  gs_codename = data
			  this.triggerevent(rbuttondown!)
			  Return 1
		  End if
	Case 'empno'
		
		  SELECT "EMPNAME" INTO :sData FROM "P1_MASTER" WHERE "EMPNO" = :data   ;

		  If Sqlca.sqlcode = 0 then
			  this.setitem(1, "empname", sData)
 		  Else
			  gs_code 	  = data
			  gs_codename = ''
			  this.triggerevent(rbuttondown!)
			  Return 1
		  End if
	Case 'empname'
		  SELECT "EMPNO" INTO :sData FROM "P1_MASTER" WHERE "EMPNAME" = :data   ;
		  If Sqlca.sqlcode = 0 then
			  this.setitem(1, "empno", sData)
 		  Else
			  gs_code 	  = ''
			  gs_codename = data
			  this.triggerevent(rbuttondown!)
			  Return 1
		  End if
End Choose
end event

event rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_code)
SetNull(Gs_codename)

Choose case this.getcolumnname()
		 case 'dept', 'cvnas'
				Open(w_sys_dept_popup)
				this.setitem(1, "dept", gs_code)
				this.setitem(1, "cvnas", gs_codename)
		 case 'empno', 'empname'
				Open(w_sawon_popup)
				this.setitem(1, "empno", gs_code)
				this.setitem(1, "empname", gs_codename)

				this.setitem(1, "dept", gs_gubun)
				
				string sdata
				Select deptname2 Into :sData From p0_dept where deptcode = :gs_gubun;
				this.setitem(1, "cvnas", sdata)
End choose


end event

event dberror;return 1
end event

event retrieveend;If rowcount() = 0 Then
	Messagebox("��ȸ", "��ȸ�ϰ��� �ϴ� User-Id�� �����ϴ�", StopSign!)
	this.reset()
	this.insertrow(0)
End if

iold_userid = getitemstring(1, "userid")

end event

type rr_1 from roundrectangle within w_sys_001_mdi_sheet_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1454
integer y = 392
integer width = 914
integer height = 136
integer cornerheight = 40
integer cornerwidth = 55
end type

