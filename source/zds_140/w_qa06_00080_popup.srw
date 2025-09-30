$PBExportHeader$w_qa06_00080_popup.srw
$PBExportComments$**��ǰ ���� ��Ȳ_����(17.12.04) - ����÷�� �˾�
forward
global type w_qa06_00080_popup from window
end type
type dw_1 from datawindow within w_qa06_00080_popup
end type
type p_2 from picture within w_qa06_00080_popup
end type
type p_1 from picture within w_qa06_00080_popup
end type
type dw_2 from datawindow within w_qa06_00080_popup
end type
type rr_1 from roundrectangle within w_qa06_00080_popup
end type
end forward

global type w_qa06_00080_popup from window
integer width = 4009
integer height = 1948
boolean titlebar = true
string title = "��ǰ ���� ��Ȳ - ����÷��"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
dw_1 dw_1
p_2 p_2
p_1 p_1
dw_2 dw_2
rr_1 rr_1
end type
global w_qa06_00080_popup w_qa06_00080_popup

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"

FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" alias for "CopyFileA;Ansi"
end prototypes

forward prototypes
public function string wf_file_upload (string ar_step_seq, string ar_file_path)
end prototypes

public function string wf_file_upload (string ar_step_seq, string ar_file_path);String ls_sv_path, ls_sv_file, ls_path, ls_file, ls_inspt_dt, ls_new
Long   ll_v, ll_ques
integer li_FileNum

/* ���ϼ��� ��� �������� */
SELECT RFNA3||RFNA5||RFGUB||'_'||RFNA1||'\'
	INTO :ls_sv_path
  FROM REFFPF
WHERE RFCOD = '3Q' 
	 AND RFGUB = :ar_step_seq ;

ls_sv_file = ar_file_path
If ls_sv_file = '' Or isNull(ls_sv_file) Then
	ls_new = 'Y'
End If		

If FileExists(ls_sv_file) Then
	ls_new = 'N'
Else
	ls_new = 'Y'
End If


If ls_new = 'N' then
	ll_ques = MessageBox('Ȯ��', '��ϵ� ������ �� ��� <��> �� �����ϰ�' + &
						'~n�����ϰ� ���� ����ҷ��� <�ƴϿ�> �� �����Ͻʽÿ�.', Question!, YesNoCancel!, 1)
	if ll_ques = 3 then return ls_sv_file
	if ll_ques = 2 then ls_new = 'Y'
End If

If ls_new = 'Y' then
	ll_v = GetFileOpenName("Upload File ����", ls_path, ls_file ,"OFFICE","PowerPoint (*.PPT),*.PPT,Excel Files (*.XLS),*.XLS,��� ���� (*.*),*.*")				
	If ll_v = 1 And FileExists(ls_path) Then
		ls_sv_file = ls_sv_path + ls_file
		if FileExists(ls_sv_file) Then
			messagebox('Ȯ��','������ ���ϸ��� �����մϴ�.~n���ϸ��� �ٲټ���.')
			return ls_sv_file
		end if		
		SetPointer(Hourglass!)
		li_FileNum = FileCopy(ls_path, ls_sv_file, true)
		If li_FileNum <> 1 Then
			MessageBox('Ȯ��','File UpLoad Failed')
			Return ls_sv_file
		End If
//		If CopyFileA(ls_path, ls_sv_file, true) = False Then
//			MessageBox('Ȯ��','File UpLoad Failed')
//			Return ls_sv_file
//		End If
	End If
Else
	SetPointer(Hourglass!)
	ShellExecuteA(0, "open", ls_sv_file, "", "", 1) // ���� �ڵ� ����
End If

Return ls_sv_file
end function

on w_qa06_00080_popup.create
this.dw_1=create dw_1
this.p_2=create p_2
this.p_1=create p_1
this.dw_2=create dw_2
this.rr_1=create rr_1
this.Control[]={this.dw_1,&
this.p_2,&
this.p_1,&
this.dw_2,&
this.rr_1}
end on

on w_qa06_00080_popup.destroy
destroy(this.dw_1)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

f_window_center_response(this) 

If dw_1.Retrieve(gs_code) > 0 Then
	If dw_2.Retrieve(gs_code, gs_gubun) < 1 Then
		
		// �����ڵ� �������� ����Ʈ �ϰ� ����
		INSERT INTO QC_ISIR_FILE
		(QCNEW_NO,	STEP_NO,		STEP_SEQ,	FILE_NAME)
		SELECT
		 :gs_code,		:gs_gubun,		RFGUB,			RFNA1
		   FROM REFFPF
	 	WHERE RFCOD = '3Q' AND RFNA4 = :gs_gubun;

		COMMIT;
		
		dw_2.Retrieve(gs_code, gs_gubun)
	End If
End If

SetNull(gs_gubun)
SetNull(gs_code)

end event

type dw_1 from datawindow within w_qa06_00080_popup
integer x = 14
integer width = 3566
integer height = 372
integer taborder = 10
string title = "none"
string dataobject = "d_qa06_00080_popup_0"
boolean border = false
boolean livescroll = true
end type

type p_2 from picture within w_qa06_00080_popup
integer x = 3781
integer y = 216
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\�ݱ�_up.gif"
boolean focusrectangle = false
end type

event clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_1 from picture within w_qa06_00080_popup
integer x = 3593
integer y = 216
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event clicked;If dw_2.AcceptText() <> 1 Then Return -1

Setpointer(Hourglass!)	

dw_2.AcceptText()
If dw_2.Update() < 1 Then
	Rollback;
	MessageBox('Ȯ��','�������')
	Return
Else
	Commit;
End if

messagebox('Ȯ��','�ڷ������� �Ϸ�Ǿ����ϴ�!!!')
//gs_code = 'OK'
//close(parent)
end event

type dw_2 from datawindow within w_qa06_00080_popup
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 400
integer width = 3909
integer height = 1416
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00080_popup_1"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String sNull, sDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "yymmdd"  , "arrymd"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[����]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
	/* �ŷ�ó */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			
			SetItem(1,"cvnas",	scvnas)
		END IF
End Choose

end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* �ŷ�ó */
	Case "cvcod"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

event clicked;If row <=0 Then return

If dwo.name = 'c_file' Then
	string		ls_step_seq, ls_file_path
	
	ls_step_seq = this.GetItemString(row, 'step_seq')
	ls_file_path  = this.GetItemString(row, 'file_path')
	
	ls_file_path = wf_file_upload(ls_step_seq, ls_file_path)
	this.SetItem(row, 'file_path', ls_file_path)
End If
end event

type rr_1 from roundrectangle within w_qa06_00080_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 388
integer width = 3941
integer height = 1444
integer cornerheight = 40
integer cornerwidth = 55
end type

