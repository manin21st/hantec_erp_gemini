$PBExportHeader$w_sm10_0020.srw
$PBExportComments$ǰ����ȸ����
forward
global type w_sm10_0020 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0020
end type
type p_excel from uo_picture within w_sm10_0020
end type
type rr_1 from roundrectangle within w_sm10_0020
end type
end forward

global type w_sm10_0020 from w_inherite
integer width = 4649
integer height = 2460
string title = "ǰ������Ÿ ����"
dw_1 dw_1
p_excel p_excel
rr_1 rr_1
end type
global w_sm10_0020 w_sm10_0020

type variables
String is_depot_no
end variables

forward prototypes
public function integer wf_itnbr_check (string sitnbr)
public function integer wf_required_chk ()
end prototypes

public function integer wf_itnbr_check (string sitnbr);Long icnt = 0

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '���� ���� ���� CHECK ��.....'

select count(*) into :icnt
  from vnddan
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�ŷ�ó��ǰ�ܰ�]')
	return -1
end if

select count(*) into :icnt
  from danmst_bg
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�ܰ�����Ÿ]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�ܰ�����Ÿ]')
	return -1
end if

select count(*) into :icnt
  from ecomst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[ECO ����]')
	return -1
end if

select count(*) into :icnt
  from itemas_zig
 where itnbr2 = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����/�˻籸 ����]')
	return -1
end if

select count(*) into :icnt
  from poblkt
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����_ǰ������]')
	return -1
end if

select count(*) into :icnt
  from estima
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[���ֿ���_�����Ƿ�]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����]')
	return -1
end if

select count(*) into :icnt
  from exppid
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����PI Detail]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[������̷�]')
	return -1
end if

//��� BOM üũ  
//  SELECT COUNT("ESTRUC"."USSEQ")  
//    INTO :icnt  
//    FROM "ESTRUC"  
//   WHERE "ESTRUC"."PINBR" = :sitnbr OR "ESTRUC"."CINBR" = :sitnbr ;
//
//if icnt > 0 then
//	w_mdi_frame.sle_msg.text = ''
//	f_message_chk(38,'[���BOM]')
//	return -1
//end if
	
//���� BOM üũ  
  SELECT COUNT("PSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "PSTRUC"  
   WHERE "PSTRUC"."PINBR" = :sitnbr OR "PSTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����BOM]')
	return -1
end if

//���� BOM üũ  
  SELECT COUNT("WSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "WSTRUC"  
   WHERE "WSTRUC"."PINBR" = :sitnbr OR "WSTRUC"."CINBR" = :sitnbr ;	

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����BOM]')
	return -1
end if

//���ִܰ� BOM üũ  
  SELECT SUM(1)  
    INTO :icnt  
    FROM "WSUNPR"  
   WHERE "WSUNPR"."ITNBR" = :sitnbr;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[���ִܰ�BOM]')
	return -1
end if

//�Ҵ� üũ
select count(*) into :icnt
  from holdstock
 where itnbr = :sitnbr;
		 
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�Ҵ�]')
	return -1
end if

//�� ���
select count(*) into :icnt
  from stockmonth
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�������]')
	return -1
end if

w_mdi_frame.sle_msg.text = ''

return 1
end function

public function integer wf_required_chk ();string snull, sasc, s_ittyp, s_itcls, get_nm
int iasc

setnull(snull)

if isnull(dw_insert.GetItemString(1,'ittyp')) or &
	dw_insert.GetItemString(1,'ittyp') = "" then
	f_message_chk(1400,'[ǰ�񱸺�]')
	dw_insert.SetColumn('ittyp')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'itcls')) or &
	dw_insert.GetItemString(1,'itcls') = "" then
	f_message_chk(1400,'[ǰ��з�]')
	dw_insert.SetColumn('itcls')
	dw_insert.SetFocus()
	return -1
else
	s_ittyp = dw_insert.getitemstring(1, 'ittyp')
   s_itcls = dw_insert.getitemstring(1, 'itcls')
	
  SELECT "ITNCT"."TITNM"  
    INTO :get_nm  
    FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_ittyp ) AND  
         ( "ITNCT"."ITCLS" = :s_itcls ) AND  
         ( "ITNCT"."LMSGU" <> 'L' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
   	f_message_chk(33,'[ǰ��з�]')
		dw_insert.SetColumn('itcls')
		dw_insert.SetFocus()
   	return -1
   END IF
end if			

if isnull(dw_insert.GetItemString(1,'itdsc')) or &
	dw_insert.GetItemString(1,'itdsc') = "" then
	f_message_chk(1400,'[ǰ��]')
	dw_insert.SetColumn('itdsc')
	dw_insert.SetFocus()
	return -1
end if	

sAsc =  trim(dw_insert.GetItemString(1,'ispec')) 
 
iAsc = asc(sAsc)
if sAsc = "" or iAsc = 13 then   // ||(ctrl + enter ��) = 13(ascii code ��)   
 	dw_insert.SetItem(1, 'ispec', snull)
end if	

if isnull(dw_insert.GetItemString(1,'gbgub')) or &
	dw_insert.GetItemString(1,'gbgub') = "" then
	f_message_chk(1400,'[���߱���]')
	dw_insert.SetColumn('gbgub')
	dw_insert.SetFocus()
	return -1
end if	

dw_insert.object.gbwan[1] = 'Y'


if isnull(dw_insert.GetItemString(1,'useyn')) or &
	dw_insert.GetItemString(1,'useyn') = "" then
	f_message_chk(1400,'[��뱸��]')
	dw_insert.SetColumn('useyn')
	dw_insert.SetFocus()
	return -1
end if	



return 1
end function

on w_sm10_0020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_excel=create p_excel
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_excel
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm10_0020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_excel)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
		dw_1.Modify("saupj.background.color = 80859087")
   End if
End If

p_delrow.BringToTop = True
p_addrow.BringToTop = True

end event

type dw_insert from w_inherite`dw_insert within w_sm10_0020
integer x = 37
integer y = 204
integer width = 4562
integer height = 2056
integer taborder = 10
string dataobject = "d_sm10_0020_2"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value , ls_saupj , ls_name ,ls_ispec , ls_jijil ,ls_null
Long   ll_cnt
SetNull(ls_null)
ls_col = Lower(GetColumnName())

ls_value = String(GetText())
row = GetRow()
dw_1.AcceptText()
ls_saupj = Trim(dw_1.Object.saupj[1])
Choose Case ls_col
		
	Case 'cvcod'
		
		select cvnas into :ls_name
		  from vndmst
		 where cvcod = :ls_value ;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox('Ȯ��','��ϵ� �ŷ�ó�� �ƴմϴ�.')
			SetItem(row,ls_col,0)
			SetColumn(ls_col)
			Return 1
		End iF
		
		Object.vndmst_cvnas[row] = ls_name
	
	Case 'itnbr'
	
		Select itdsc , ispec , jijil
		  Into  :ls_name ,:ls_ispec , :ls_jijil
		  From itemas 
		  where itnbr = :ls_value ;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox('Ȯ��','��ϵ� ǰ���� �ƴմϴ�.')
			SetItem(row,ls_col,0)
			Object.itemas_itdsc[row] = ls_null
			Object.itemas_ispec[row] = ls_null
			Object.itemas_jijil[row] = ls_null
			SetColumn(ls_col)
			Return 1
		End iF
		
		
		Object.itemas_itdsc[row] = ls_name
		Object.itemas_ispec[row] = ls_ispec
		Object.itemas_jijil[row] = ls_jijil
	
	Case 'newite'
		Long ll_qty
		
		ll_qty = Long(ls_value)
		
		If ll_qty > 6 Then
			MessageBox('Ȯ��','��� Ȯ���ϼ��� 6���� ���� �� �����ϴ�.')
			SetItem(row,ls_col,0)
			SetColumn(ls_col)
			Return 1
		End iF
	
   Case 'mulgbn'
		String ls_mul
		ls_mul = data
		If ls_mul = 'N' Then
			This.SetItem(row, 'mdepot', '')
		End If
	
End Choose


end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''

If row < 1 Then Return
str_code lst_code
Long i , ll_i = 0
String ls_cvcod

	
this.AcceptText()

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		
		Open(w_itemas_multi_popup)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_ins.triggerevent("clicked")
			
			ls_cvcod = Trim(this.object.cvcod[i])
			If ls_cvcod = '' or isNull(ls_cvcod) Then
				this.SetItem(i,"cvcod",object.cvcod[i - 1])
				this.SetItem(i,"vndmst_cvnas",object.vndmst_cvnas[i - 1])
			end iF
			
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next
		
	Case "cvcod"
	
		
		gs_gubun = '1' 
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(row,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
	
		
END Choose
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0020
boolean visible = false
integer x = 2679
integer y = 4
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0020
boolean visible = false
integer x = 2871
integer y = 16
integer width = 174
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_sm10_0020
boolean visible = false
integer x = 1792
integer taborder = 0
string picturename = "C:\erpman\image\��������_up.gif"
end type

event p_search::ue_lbuttondown;//
end event

event p_search::ue_lbuttonup;//
end event

event p_search::clicked;call super::clicked;String ls_itnbr , ls_itnbr_sum
Declare item_new Cursor For

select itnbr
  from itemas 
 where empno2 = :gs_userid ;

Open item_new;
SetNull(ls_itnbr)

Do While True
	
	Fetch item_new Into :ls_itnbr ;
	
	If SQLCA.SQLCODE <> 0 Then Exit
	ls_itnbr_sum = ls_itnbr_sum +',' +ls_itnbr +char(13)+char(10)
	
Loop

Close item_new;


gs_code = '�ű� ǰ�� ������Ͽ�û '
gs_codename = Mid(ls_itnbr_sum , 2, Len(ls_itnbr_sum) ) + " �ű� ǰ���� ����߽��ϴ�. ���������� ������ �ּ���."


Open(w_mail_insert)
end event

type p_ins from w_inherite`p_ins within w_sm10_0020
integer x = 3922
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;Long ll_r
dw_insert.SetRedraw(False)
ll_r = dw_insert.InsertRow(0)
	
dw_insert.SetItem(ll_r, 'crt_date', String(TODAY(), 'yyyymmdd'))
dw_insert.SetItem(ll_r, 'crt_time', String(TODAY(), 'hhmmss'  ))
dw_insert.SetItem(ll_r, 'crt_user', gs_empno                   )

dw_insert.ScrollToRow(ll_r)

dw_insert.SetColumn("cvcod")
dw_insert.SetFocus()
dw_insert.SetRedraw(True)


end event

type p_exit from w_inherite`p_exit within w_sm10_0020
integer taborder = 0
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0020
integer taborder = 0
end type

event p_can::clicked;call super::clicked;
dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_insert.SetFocus()
dw_insert.SetColumn("unmsr")





end event

type p_print from w_inherite`p_print within w_sm10_0020
boolean visible = false
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_sm10_0020
integer x = 3401
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String ls_saupj , ls_itnbr ,ls_cvnas

dw_1.AcceptText() 
dw_insert.AcceptText() 

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])
ls_cvnas = Trim(dw_1.Object.cvnas[1])

If ls_itnbr = '' Or isNull(ls_itnbr) Then
	ls_itnbr = '%'
else
   ls_itnbr = ls_itnbr + '%'
End If

If ls_cvnas = '' Or isNull(ls_cvnas) Then
	ls_cvnas = '%'
else
   ls_cvnas =  '%' + ls_cvnas + '%'
End If


dw_insert.SetRedraw(False)
If dw_insert.Retrieve(ls_itnbr, ls_cvnas) > 0 Then
	
Else
	p_can.TriggerEvent(Clicked!)
End iF
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0020
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust 


if dw_insert.AcceptText() = -1 then return -1
if dw_insert.rowcount() <= 0 then return -1

ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('Ȯ��','������ ����Ÿ�� �������� �ʽ��ϴ�.')
	Return
End IF
if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

String ls_citnbr

For i = ll_rcnt To 1 Step -1
	If dw_insert.isSelected(i) Then
		
		dw_insert.ScrollToRow(i)
		dw_insert.DeleteRow(i)
	End iF
Next

if dw_insert.Update() = 1 then
	
	commit ;
	sle_msg.text =	"����ڷḦ �����Ͽ����ϴ�!!"	
	p_inq.TriggerEvent(Clicked!)
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
end if	
dw_insert.SetRedraw(TRUE)
end event

type p_mod from w_inherite`p_mod within w_sm10_0020
integer x = 3749
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;string ls_cvcod , ls_itnbr ,ls_mulgbn , ls_mdepot
Long i 


if dw_insert.AcceptText() = -1 then return 

IF f_msg_update() < 1 then Return 

For i = 1 To dw_insert.Rowcount()
	ls_cvcod = Trim(dw_insert.object.cvcod[i])
	ls_itnbr = Trim(dw_insert.object.itnbr[i])
	
	If isNull(ls_cvcod) or ls_cvcod = '' Then
		MessageBox('Ȯ��','�ŷ�ó�� �Է��ϼ���.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("cvcod")
		return
	End If
	
	If isNull(ls_itnbr) or ls_itnbr = '' Then
		MessageBox('Ȯ��','ǰ���� �Է��ϼ���.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("itnbr")
		return
	End If
	
	ls_mulgbn = Trim(dw_insert.object.mulgbn[i])
	ls_mdepot = Trim(dw_insert.object.mdepot[i])
	
	If ls_mulgbn ='Y' and ( isNull( ls_mdepot ) or ls_mdepot ='' ) Then
		MessageBox('Ȯ��','ǰ����ü��  �Է��ϼ���.')
		dw_insert.ScrollToRow(i)
		dw_insert.SetFocus()
		dw_insert.SetColumn("mdepot")
		return
	End If
Next

dw_insert.AcceptText()

Long   l
String ls_ymd
String ls_tim
ls_ymd = String(TODAY(), 'yyyymmdd')
ls_tim = String(TODAY(), 'hhmmss'  )
For l = 0 To dw_insert.RowCount()
	l = dw_insert.GetNextModified(l + 1, Primary!)
	If l < 1 Then Exit	
	
	dw_insert.SetItem(l, 'upd_date', ls_ymd  )
	dw_insert.SetItem(l, 'upd_time', ls_tim  )
	dw_insert.SetItem(l, 'upd_user', gs_empno)
	
Next

IF dw_insert.update() <= 0 	THEN
	ROLLBACK;
	Messagebox('Ȯ��','�������')
	RETURN
Else
	Commit ;
	
	p_inq.TriggerEvent(Clicked!)

END IF
	
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0020
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0020
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0020
end type

type cb_del from w_inherite`cb_del within w_sm10_0020
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0020
end type

type cb_print from w_inherite`cb_print within w_sm10_0020
end type

type st_1 from w_inherite`st_1 within w_sm10_0020
end type

type cb_can from w_inherite`cb_can within w_sm10_0020
end type

type cb_search from w_inherite`cb_search within w_sm10_0020
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0020
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0020
end type

type dw_1 from datawindow within w_sm10_0020
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 12
integer width = 3255
integer height = 172
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0020_1"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;p_inq.TriggerEvent(Clicked!)
end event

type p_excel from uo_picture within w_sm10_0020
integer x = 3575
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\������ȯ_up.gif"
end type

event clicked;call super::clicked;String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

String ls_saupj , ls_factory , ls_ymd , ls_itnbr, ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
String ls_empno
Long i


If dw_insert.RowCount() < 1 Then Return

li_rc = GetFileSaveName("������ ���ϸ��� �����ϼ���." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("��������" , ls_filepath + " ������ �̹� �����մϴ�.~r~n" + &
												 "������ ������ ����ðڽ��ϱ�?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
	dw_insert.modify("p_1.visible=0")
	dw_insert.modify("p_2.visible=0")
	
 	If dw_insert.SaveAsAscii(ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
		dw_insert.modify("p_1.visible=1")
		dw_insert.modify("p_2.visible=1")
		return
	End If
	
	dw_insert.modify("p_1.visible=1")
	dw_insert.modify("p_2.visible=1")

END IF

w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end event

type rr_1 from roundrectangle within w_sm10_0020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 200
integer width = 4576
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

