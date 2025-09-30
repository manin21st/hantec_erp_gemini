$PBExportHeader$w_qct_03010.srw
$PBExportComments$VOC ��� ���
forward
global type w_qct_03010 from w_inherite
end type
type dw_sel from datawindow within w_qct_03010
end type
type dw_1 from u_key_enter within w_qct_03010
end type
type pb_1 from u_pb_cal within w_qct_03010
end type
type pb_2 from u_pb_cal within w_qct_03010
end type
type p_3 from u_pb_cal within w_qct_03010
end type
type p_4 from u_pb_cal within w_qct_03010
end type
type pb_5 from u_pb_cal within w_qct_03010
end type
type pb_6 from u_pb_cal within w_qct_03010
end type
type pb_7 from u_pb_cal within w_qct_03010
end type
type rr_1 from roundrectangle within w_qct_03010
end type
end forward

global type w_qct_03010 from w_inherite
string title = "VOC ������"
dw_sel dw_sel
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
p_3 p_3
p_4 p_4
pb_5 pb_5
pb_6 pb_6
pb_7 pb_7
rr_1 rr_1
end type
global w_qct_03010 w_qct_03010

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
string is_path, is_file
end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ
if Isnull(Trim(dw_insert.object.joddpt[1])) or Trim(dw_insert.object.joddpt[1]) = "" then
  	f_message_chk(1400,'[��ġ�μ�]')
	dw_insert.SetColumn('joddpt')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.qcsdat[1])) or Trim(dw_insert.object.qcsdat[1]) = "" then
  	f_message_chk(1400,'[��������]')
	dw_insert.SetColumn('qcsdat')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.chaemp[1])) or Trim(dw_insert.object.chaemp[1]) = "" then
  	f_message_chk(1400,'[ó�������]')
	dw_insert.SetColumn('chaemp')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.wongu[1])) or Trim(dw_insert.object.wongu[1]) = "" then
  	f_message_chk(1400,'[���α׷�/����]')
	dw_insert.SetColumn('gubun')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.analysis[1])) or Trim(dw_insert.object.analysis[1]) = "" then
  	f_message_chk(1400,'[����м�]')
	dw_insert.SetColumn('analysis')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.daetxt[1])) or Trim(dw_insert.object.daetxt[1]) = "" then
  	f_message_chk(1400,'[ó�����]')
	dw_insert.SetColumn('daetxt')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.wadat[1])) or Trim(dw_insert.object.wadat[1]) = "" then
  	f_message_chk(1400,'[�Ϸ�����]')
	dw_insert.SetColumn('wadat')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.chegu[1])) or Trim(dw_insert.object.chegu[1]) = "" then
  	f_message_chk(1400,'[ó������]')
	dw_insert.SetColumn('chegu')
	dw_insert.SetFocus()
	return -1
//elseif dw_insert.object.jangiyn[1] = "Y" then //'����å����'�� Yes�� ���
//	if Isnull(Trim(dw_insert.object.jangidat[1])) or Trim(dw_insert.object.jangidat[1]) = "" then
//		f_message_chk(1400,'[����å�ϷΌ����]')
//	   dw_insert.SetColumn('jangidat')
//	   dw_insert.SetFocus()
//	   return -1
//	end if
//	if Isnull(Trim(dw_insert.object.jangicemp[1])) or Trim(dw_insert.object.jangicemp[1]) = "" then
//		f_message_chk(1400,'[����åȮ����]')
//	   dw_insert.SetColumn('jangicemp')
//	   dw_insert.SetFocus()
//	   return -1
//	end if
end if

if Trim(dw_insert.object.qcsdat[1]) > Trim(dw_insert.object.wadat[1]) then
	MessageBox("�Ϸ����� Ȯ��", "�������� ���� ���� �Ϸ����ڴ� ������ �ʾƿ�!")
   dw_insert.SetColumn('wadat')
   dw_insert.SetFocus()
   return -1
end if

dw_insert.object.clsts[1] = "2" //���� = �Ϸ�
return 1

end function

on w_qct_03010.create
int iCurrent
call super::create
this.dw_sel=create dw_sel
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_3=create p_3
this.p_4=create p_4
this.pb_5=create pb_5
this.pb_6=create pb_6
this.pb_7=create pb_7
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sel
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.p_3
this.Control[iCurrent+6]=this.p_4
this.Control[iCurrent+7]=this.pb_5
this.Control[iCurrent+8]=this.pb_6
this.Control[iCurrent+9]=this.pb_7
this.Control[iCurrent+10]=this.rr_1
end on

on w_qct_03010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_sel)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.pb_5)
destroy(this.pb_6)
destroy(this.pb_7)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_sel.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)


dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)

dw_sel.ReSet()

dw_insert.InsertRow(0)
dw_insert.SetItem(1,'gubun','10')
dw_insert.Setredraw(False)


f_child_wongu(dw_insert, 'wongu', '%')
dw_insert.Setredraw(true)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_03010
integer x = 87
integer y = 764
integer width = 4503
integer height = 1528
integer taborder = 30
string dataobject = "d_qct_03010_03"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2, sgubun
Integer i_rtn 

s_cod = Trim(this.GetText())

if (this.GetColumnName() = "joddpt") Then //��ġ�μ�
	i_rtn = f_get_name2("�μ�", "Y", s_cod, s_nam1, s_nam2)
	this.object.joddpt[1] = s_cod
	this.object.cvnas2[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "qcsdat") Then //Q.C ������
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.qcsdat[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "clamst_transfer_day") Then //��������� �ΰ��� 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�ΰ���]")
		this.object.clamst_transfer_day[1] = ""
		return 1
	end if	
elseif (this.GetColumnName() = "clamst_dispatch_day") Then //���� �μ� �뺸�� 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�뺸��]")
		this.object.clamst_dispatch_day[1] = ""
		return 1
	end if	
elseif (this.GetColumnName() = "gubun") Then //���� �׷�
	if IsNull(s_cod) or s_cod = "" then return

   f_child_wongu(this, 'wongu', s_cod)
elseif (this.GetColumnName() = "clamst_preday") Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[ó��������]")
		this.object.clamst_preday[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "wadat") Then //�Ϸ�����
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�Ϸ�����]")
		this.object.wadat[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "jangiyn") Then //����å����
	if s_cod = "N" then 
		this.object.jangidat[1] = ""
		this.object.jangicemp[1] = ""
		this.object.empname1[1] = ""
		this.object.jangicdat[1] = ""
	end if
elseif (this.GetColumnName() = "jangidat") Then //����å�ϷΌ����
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[����å�ϷΌ����]")
		this.object.jangidat[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "jangicemp") Then //����åȮ����
	i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
	this.object.jangicemp[1] = s_cod
	this.object.empname1[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "jangicdat") Then //����å�Ϸ�����
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[����å�Ϸ�����]")
		this.object.jangicdat[1] = ""
		return 1
	end if
end if
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "joddpt" then //��ġ�μ�
	open(w_vndmst_4_popup)
	this.object.joddpt[1] = gs_code
	this.object.cvnas2[1] = gs_codename
	return
elseif this.getcolumnname() = "jangicemp" then //����åȮ����
	open(w_sawon_popup)
	this.object.jangicemp[1] = gs_code
	this.object.empname1[1] = gs_codename
	return
end if
end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "analysis" or &
   this.GetColumnName() = "daetxt" then return

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::itemfocuschanged;String sCol

sCol = this.GetColumnName()
if sCol = "analysis" or sCol = "daetxt" then
	f_toggle_kor(Handle(this))
else	
	f_toggle_eng(Handle(this))
end if	
end event

event dw_insert::clicked;call super::clicked;string ls_path, ls_file, ls_file_name, ls_Null, ls_jpno, ls_nm
blob   b_data, b_data2
long   i, ll_seq, ll_new_pos, ll_flen, ll_bytes_read, ll_rc, ll_cnt
int    li_fp, li_loops, li_complete, li_rc

setnull(ls_Null)	
ls_jpno = this.getitemstring(1,'cl_jpno')

if dwo.type = 'button' then
	if dwo.name = 'b_1' then //�Ƿ�������ȸ		
		ls_path = 'c:\erpman\doc' 	
		if not directoryexists(ls_path) then 
			createdirectory(ls_path) 
		End if 
		
		//�����̸�
		select ann_filenm into :ls_file_name
 	     from clamst_doc
	    where sabu    = :gs_sabu
		   and cl_jpno = :ls_jpno;
		if ls_file_name = '' or isnull(ls_file_name) then
			messagebox('Ȯ��','������ �������� �ʽ��ϴ�.')
			return
		end if	
		
		//��������
		selectblob ann_file into :b_data
				from clamst_doc
			  where sabu    = :gs_sabu
				 and cl_jpno = :ls_jpno;
				 
		If IsNull(b_data) Then
			messagebox('Ȯ��',ls_file_name +' DownLoad�� �ڷᰡ �����ϴ�.~r~n�ý��� ����ڿ��� �����Ͻʽÿ�.')
			return
		End If		
			IF SQLCA.SQLCode = 0 AND Not IsNull(b_data) THEN
				ls_file_name = ls_path + '\' + ls_file_name
				li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)
		
				ll_new_pos 	= 1
				li_loops 	= 0
				ll_flen 		= 0
		
				IF li_fp = -1 or IsNull(li_fp) then
					messagebox('Ȯ��',ls_path + ' Folder�� ����ġ �ʰų� ������� �ڷ��Դϴ�.')
				Else
					ll_flen = len(b_data)
					
					if ll_flen > 32765 then
						if mod(ll_flen,32765) = 0 then
							li_loops = ll_flen / 32765
						else
							li_loops = (ll_flen/32765) + 1
						end if
					else
						li_loops = 1
					end if
		
					if li_loops = 1 then 
						ll_bytes_read = filewrite(li_fp,b_data)
						Yield()					
					else
						for i = 1 to li_loops
							if i = li_loops then
								b_data2 = blobmid(b_data,ll_new_pos)
							else
								b_data2 = blobmid(b_data,ll_new_pos,32765)
							end if
							ll_bytes_read = filewrite(li_fp,b_data2)
							ll_new_pos = ll_new_pos + ll_bytes_read
		
							Yield()
							li_complete = ( (32765 * i ) / len(b_data)) * 100
						next
							Yield()
					end if
					
					li_rc = 0 
					
					FileClose(li_fp)
				END IF
			END IF
		//==[���α׷� ����/�ٿ�Ϸ���]
		ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
		return
	elseif dwo.name = 'b_2' then //���
		if GetFileOpenName('���� ������ �����ϼ���', ls_path, ls_file) = 1 then
			dw_insert.setitem(1,'re_path',ls_path)
			is_path = ls_path 
			is_file = ls_file
			dw_insert.setitem(1,'re_filenm',ls_file)
		end if
	elseif dwo.name = 'b_3' then //������ȸ
		
		ls_path = 'c:\erpman\doc' 	
		if not directoryexists(ls_path) then 
			createdirectory(ls_path) 
		End if 
		
		//�����̸�
		select re_filenm into :ls_file_name
 	     from clamst_doc
	    where sabu    = :gs_sabu
		   and cl_jpno = :ls_jpno;
		if ls_file_name = '' or isnull(ls_file_name) then
			messagebox('Ȯ��','������ �������� �ʽ��ϴ�.')
			return
		end if	
		
		//��������
		selectblob re_file into :b_data
				from clamst_doc
			  where sabu    = :gs_sabu
				 and cl_jpno = :ls_jpno;
				 
		If IsNull(b_data) Then
			messagebox('Ȯ��',ls_file_name +' DownLoad�� �ڷᰡ �����ϴ�.~r~n�ý��� ����ڿ��� �����Ͻʽÿ�.')
			return
		End If		
			IF SQLCA.SQLCode = 0 AND Not IsNull(b_data) THEN
				ls_file_name = ls_path + '\' + ls_file_name
				li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)
		
				ll_new_pos 	= 1
				li_loops 	= 0
				ll_flen 		= 0
		
				IF li_fp = -1 or IsNull(li_fp) then
					messagebox('Ȯ��',ls_path + ' Folder�� ����ġ �ʰų� ������� �ڷ��Դϴ�.')
				Else
					ll_flen = len(b_data)
					
					if ll_flen > 32765 then
						if mod(ll_flen,32765) = 0 then
							li_loops = ll_flen / 32765
						else
							li_loops = (ll_flen/32765) + 1
						end if
					else
						li_loops = 1
					end if
		
					if li_loops = 1 then 
						ll_bytes_read = filewrite(li_fp,b_data)
						Yield()					
					else
						for i = 1 to li_loops
							if i = li_loops then
								b_data2 = blobmid(b_data,ll_new_pos)
							else
								b_data2 = blobmid(b_data,ll_new_pos,32765)
							end if
							ll_bytes_read = filewrite(li_fp,b_data2)
							ll_new_pos = ll_new_pos + ll_bytes_read
		
							Yield()
							li_complete = ( (32765 * i ) / len(b_data)) * 100
						next
							Yield()
					end if
					
					li_rc = 0 
					
					FileClose(li_fp)
				END IF
			END IF
		//==[���α׷� ����/�ٿ�Ϸ���]
		ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
		return
	elseif dwo.name = 'b_4' then //���ϻ���	
		if trim(ls_jpno) = '' or isnull(ls_jpno) then
			messagebox('����', '������ȣ�� �������� �ʽ��ϴ�.~n ��ȸ�� �۾��� �����մϴ�.')
			return
		end if
		
	   //���� ���翩��
	   select count(*) into :ll_cnt
		  from clamst_doc
	 	 where sabu     = :gs_sabu
		   and cl_jpno  = :ls_jpno;
			  
  		 if ll_cnt = 0 then
			messagebox('Ȯ��','������ �ڷᰡ �������� �ʽ��ϴ�.' ) 
			return
		 else
			select ann_filenm into :ls_nm
			  from clamst_doc
			 where sabu     = :gs_sabu
				and cl_jpno  = :ls_jpno;
			  
			 if isnull(ls_nm)  then //��å���� �������� ������� ����
				delete from clamst_doc where sabu = :gs_sabu and cl_jpno  = :ls_jpno;
				if sqlca.sqlcode = 0 then
					messagebox('Ȯ��','��å�� �ڷᰡ �����Ǿ����ϴ�.') 
					commit;
				else
					messagebox('Ȯ��2[DELETE]','��å�� �ڷ���� �� ������ �߻� �߽��ϴ�.' + SQLCA.SQLERRTEXT) 
					rollback;
					return
				end if	
			 else	//��å���� �����Ұ�� �Ƿ����ϸ� UPDATE
				//���ϸ�,�����update
				Update clamst_doc
					set re_filenm = null,
						 re_empno  = null
				 where sabu     = :gs_sabu
					and cl_jpno  = :ls_jpno;						
				if sqlca.sqlcode = 0 then
					messagebox('Ȯ��','��å�� �ڷᰡ �����Ǿ����ϴ�.') 
					commit;
				else
					messagebox('Ȯ��1[DELETE]','��å�� �ڷ���� �� ������ �߻� �߽��ϴ�.' + SQLCA.SQLERRTEXT) 
					rollback;
					return
				end if	
			
//			 //���� update
//			 UpdateBlob clamst_doc
//				 set re_file = Space(0)
//			  where sabu     = :gs_sabu
//				 and cl_jpno  = :ls_jpno;						
//			if sqlca.sqlcode = 0 then
//				messagebox('Ȯ��','÷�� �ڷᰡ �����Ǿ����ϴ�.') 
//				commit;
//			else
//				messagebox('Ȯ��2[DELETE]','÷�� �ڷ���� �� ������ �߻� �߽��ϴ�.' + SQLCA.SQLERRTEXT) 
//				rollback;
//				return
//			end if	
        end if
		 end if
	end if	
end if	


end event

type p_delrow from w_inherite`p_delrow within w_qct_03010
boolean visible = false
integer x = 4338
integer y = 3484
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_03010
boolean visible = false
integer x = 4165
integer y = 3484
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_03010
boolean visible = false
integer x = 3470
integer y = 3484
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_03010
boolean visible = false
integer x = 3991
integer y = 3484
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_03010
integer x = 4389
integer y = 0
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_qct_03010
integer x = 4215
integer y = 0
integer taborder = 60
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_qct_03010
boolean visible = false
integer x = 3643
integer y = 3484
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_03010
integer x = 3689
integer y = 0
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sdate, edate, clsts, cod, nam

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return 
end if	

sdate = Trim(dw_1.object.sdate[1])
edate = Trim(dw_1.object.edate[1])
clsts = Trim(dw_1.object.clsts[1])
cod = Trim(dw_1.object.cod[1])
nam = Trim(dw_1.object.nam[1])

if IsNull(sdate) or sdate = "" then sdate = "11111111"
if IsNull(edate) or edate = "" then edate = "99999999"
if IsNull(cod) or cod = "" then 
	cod = "X"
else
	cod = cod + "%"
end if	
if IsNull(nam) or nam = "" then 
	nam = "X"
else
	if cod <> "X" then
		nam = "X"
	else	
	   nam = nam + "%"
	end if	
end if	
if cod = "X" and nam = "X" then
	cod = "%"
	nam = "%"
end if	
if dw_sel.Retrieve(gs_sabu, sdate, edate, clsts, cod, nam, gs_saupj) < 1 then
	w_mdi_frame.sle_msg.text = "��ϵ� �ڷᰡ �����ϴ�! "
else	
	w_mdi_frame.sle_msg.text = ""
end if	

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

p_mod.Enabled = False
p_mod.PictureName = 'c:\erpman\image\����_d.gif'
	
p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\����_d.gif'

ib_any_typing = False //�Է��ʵ� ���濩�� No

end event

type p_del from w_inherite`p_del within w_qct_03010
integer x = 4041
integer y = 0
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;String s_cod

if dw_insert.AcceptText() = -1 then return 

if dw_insert.object.clsts[1] = "1" then
	MessageBox("������ �ڷ�", "������ �ڷ�� ������ �� �����ϴ�._n" &
	                        + "'VOC ���' ȭ�鿡�� �����ϼ���!")
	return
end if

if f_msg_delete() = -1 then return

s_cod = dw_insert.object.cl_jpno[1]
if IsNull(s_cod) or s_cod = "" then
	MessageBox("������ȣ Ȯ��", "������ȣ�� Ȯ���ϼ���.")
	return
end if

update clamst
set clsts     = '1',  joddpt    = '',    qcsdat    = '',
	 chaemp    = '',   wongu     = '',    chegu     = '',
	 silgu     = '',   wadat     = '',    jangiyn   = '',
	 jangidat  = '',   jangicemp = '',    jangicdat = '',
	 analysis  = '',   daetxt    = '',    preday    = '', 
	 weight    = 0,    repairqty = 0,     repairprc = 0, 
	 repairamt = 0,    supplyprc = 0,     tax       = 0, 
	 lossamt   = 0 
where sabu = :gs_sabu and cl_jpno = :s_cod;

if sqlca.sqlcode <> 0 then
	ROLLBACK;
   f_message_chk(32, "[��������]")
	w_mdi_frame.sle_msg.Text = "�����۾� ����!"
else
   COMMIT;
   p_inq.TriggerEvent(Clicked!)
   w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
end if


end event

type p_mod from w_inherite`p_mod within w_qct_03010
integer x = 3867
integer y = 0
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_mod::clicked;call super::clicked;string ls_path, ls_file, ls_filenm, ls_jpno
long   ll_cnt

if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if f_msg_update() = -1 then return

ls_jpno = dw_insert.getitemstring(1,'cl_jpno')
IF dw_insert.Update() > 0 THEN	
	COMMIT;
	//�Ƿڹ�������
	ls_file 		= upper(is_file)
	ls_path     = upper(is_path) 
	
	if ls_path <> '' and not(isnull(is_path)) then
		ls_filenm = dw_insert.getitemstring(1,'re_filenm')
		//////////////////////////////////////////
		// ������ FILE�� READ�Ͽ� DB�� UPDATE
		//////////////////////////////////////////
		integer 	li_FileNum, loops, i
		long 		flen, bytes_read, new_pos
		blob 		b, tot_b
		
	  //���� ����
	  select count(*) into :ll_cnt
		 from clamst_doc
		where sabu     = :gs_sabu
		  and cl_jpno  = :ls_jpno;
		  
		if ll_cnt = 0 then
			insert into clamst_doc 
					  (sabu, cl_jpno, re_filenm, re_empno)
			 values (:gs_sabu, :ls_jpno, :ls_filenm, :gs_empno) ;
			if sqlca.sqlcode = 0 then
				commit;
			else
				messagebox('Ȯ��[INSERT]','÷�� �ڷ����� �� ������ �߻� �߽��ϴ�.' + SQLCA.SQLERRTEXT) 
				rollback;
				return
			end if	
		else
			update clamst_doc
				set re_filenm = :ls_filenm
			 where sabu     = :gs_sabu
				and cl_jpno  = :ls_jpno;				
			if sqlca.sqlcode = 0 then
				commit;
			else
				messagebox('Ȯ��[UPDATE]','÷�� �ڷ����� �� ������ �߻� �߽��ϴ�.' + SQLCA.SQLERRTEXT) 
				rollback;
				return
			end if	
		end if	
		
		flen = FileLength(ls_path)
		li_FileNum = FileOpen(ls_path, StreamMode!, Read!, LockRead!)
			
		IF flen > 32765 THEN
			IF Mod(flen, 32765) = 0 THEN
				loops = flen/32765
			ELSE
				loops = (flen/32765) + 1
			END IF
		ELSE
			loops = 1
		END IF
		
		new_pos = 1
		
		FOR i = 1 to loops
			bytes_read = FileRead(li_FileNum, b)
			tot_b = tot_b + b
		NEXT
			
		FileClose(li_FileNum)
					
		//Blob ����
		UpdateBlob clamst_doc
				 set re_file = :tot_b
			  where sabu     = :gs_sabu
				 and cl_jpno  = :ls_jpno;
				 
		If SQLCA.SQLCODE <> 0 Then
			messagebox('Ȯ��','�ڷ����� �� ������ �߻� �߽��ϴ�.' + SQLCA.SQLERRTEXT) 
			ROLLBACK USING SQLCA	;
			Return
		End if				
										
		COMMIT USING SQLCA	;
			
		w_mdi_frame.sle_msg.text ="������ �߰���� �Ǿ����ϴ�!"
	end if	
	///////////////////////////////////////////////////
	
	p_inq.TriggerEvent(Clicked!)
	w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[�������]")
	w_mdi_frame.sle_msg.Text = "�����۾� ����!"
END IF

ib_any_typing = False //�Է��ʵ� ���濩�� No

end event

type cb_exit from w_inherite`cb_exit within w_qct_03010
integer x = 3054
integer y = 3524
end type

type cb_mod from w_inherite`cb_mod within w_qct_03010
integer x = 1998
integer y = 3524
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_03010
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_qct_03010
integer x = 2350
integer y = 3524
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_03010
integer x = 1641
integer y = 3528
end type

type cb_print from w_inherite`cb_print within w_qct_03010
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_qct_03010
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_03010
integer x = 2702
integer y = 3524
end type

type cb_search from w_inherite`cb_search within w_qct_03010
integer x = 1371
integer y = 1956
integer taborder = 100
end type



type sle_msg from w_inherite`sle_msg within w_qct_03010
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_03010
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_03010
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_03010
end type

type dw_sel from datawindow within w_qct_03010
integer x = 1312
integer y = 164
integer width = 3237
integer height = 564
boolean bringtotop = true
string dataobject = "d_qct_03010_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;dw_insert.accepttext()
this.SelectRow(0,False)

if Row <= 0 then return
this.SelectRow(Row,TRUE)
if dw_insert.Retrieve(gs_sabu, Trim(this.object.cl_jpno[Row])) < 1 then
   f_message_chk(50, "[VOC ������]")
	dw_insert.SetRedraw(False)
	dw_insert.Reset()
	dw_insert.InsertRow(0)
	dw_insert.SetRedraw(True)	
else
	//���α��а�����
	f_child_wongu(dw_insert, 'wongu', dw_insert.Getitemstring(1,"gubun"))
	
	if dw_insert.object.clsts[1] = "1" then //��������
		p_del.Enabled = False
		p_del.PictureName = 'c:\erpman\image\����_d.gif'
	
		dw_insert.object.silgu[1]   = "N"
		dw_insert.object.jangiyn[1] = "N"
   else
		p_del.Enabled = True
		p_del.PictureName = 'c:\erpman\image\����_up.gif'
	end if
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\����_up.gif'
	
	dw_insert.SetFocus()
end if	

ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

event rowfocuschanged;this.SelectRow(0,False)

if currentRow <= 0 then return
this.SelectRow(currentRow,TRUE)
if dw_insert.Retrieve(gs_sabu, Trim(this.object.cl_jpno[currentRow])) < 1 then
   f_message_chk(50, "[VOC ������]")
	dw_insert.SetRedraw(False)
	dw_insert.Reset()
	dw_insert.InsertRow(0)
	dw_insert.SetRedraw(True)	
else
	if dw_insert.object.clsts[1] = "1" then //��������
		p_del.Enabled = False
		p_del.PictureName = 'c:\erpman\image\����_d.gif'
	
		dw_insert.object.silgu[1]   = "N"
		dw_insert.object.jangiyn[1] = "N"
   else
		p_del.Enabled = True
		p_del.PictureName = 'c:\erpman\image\����_up.gif'
	end if
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\����_up.gif'
	
	dw_insert.SetFocus()
end if	

ib_any_typing = False //�Է��ʵ� ���濩�� No
end event

type dw_1 from u_key_enter within w_qct_03010
event ue_key pbm_dwnkey
integer x = 87
integer y = 32
integer width = 1202
integer height = 724
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_03010_01"
boolean border = false
end type

event ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseIF keydown(keyF1!) THEN
	if	this.getcolumnname() = "cod" or this.getcolumnname() = "nam" then //ǰ��,ǰ��
	   open(w_itemas_popup2)
	   this.object.cod[1] = gs_code
	   this.object.nam[1] = gs_codename
	   return
   end if	
END IF
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[������]")
		this.object.edate[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "cod") Then //ǰ��
	i_rtn  = f_get_name2("ǰ��", "N", s_cod, s_nam1, s_nam2)
	this.object.cod[1] = s_cod
	this.object.nam[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "nam") Then //ǰ��
	i_rtn  = f_get_name2("ǰ��", "N", s_nam1, s_cod, s_nam2)
	this.object.cod[1] = s_nam1
	this.object.nam[1] = s_cod
	return i_rtn
end if

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "cod" or this.getcolumnname() = "nam" then //ǰ��,ǰ��
	open(w_itemas_popup)
	this.object.cod[1] = gs_code
	this.object.nam[1] = gs_codename
	return
end if	
end event

type pb_1 from u_pb_cal within w_qct_03010
integer x = 754
integer y = 188
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03010
integer x = 1170
integer y = 188
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'edate', gs_code)
end event

type p_3 from u_pb_cal within w_qct_03010
integer x = 4357
integer y = 832
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('qcsdat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_1.getrow(), 'qcsdat', gs_code)
end event

type p_4 from u_pb_cal within w_qct_03010
integer x = 4357
integer y = 920
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('clamst_preday')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_1.getrow(), 'clamst_preday', gs_code)
end event

type pb_5 from u_pb_cal within w_qct_03010
integer x = 2789
integer y = 1500
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('wadat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_1.getrow(), 'wadat', gs_code)
end event

type pb_6 from u_pb_cal within w_qct_03010
integer x = 2793
integer y = 1588
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('clamst_transfer_day')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_1.getrow(), 'clamst_transfer_day', gs_code)
end event

type pb_7 from u_pb_cal within w_qct_03010
integer x = 4357
integer y = 1588
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('clamst_dispatch_day')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_1.getrow(), 'clamst_dispatch_day', gs_code)
end event

type rr_1 from roundrectangle within w_qct_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1298
integer y = 156
integer width = 3264
integer height = 584
integer cornerheight = 40
integer cornerwidth = 55
end type

