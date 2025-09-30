$PBExportHeader$w_pdt_06043.srw
$PBExportComments$�����Ƿڵ��
forward
global type w_pdt_06043 from w_inherite
end type
type gb_5 from groupbox within w_pdt_06043
end type
type rb_2 from radiobutton within w_pdt_06043
end type
type rb_1 from radiobutton within w_pdt_06043
end type
type dw_print from datawindow within w_pdt_06043
end type
type dw_1 from datawindow within w_pdt_06043
end type
type pb_6 from u_pb_cal within w_pdt_06043
end type
type pb_1 from u_pb_cal within w_pdt_06043
end type
type dw_list from u_d_select_sort within w_pdt_06043
end type
type pb_2 from u_pb_cal within w_pdt_06043
end type
type pb_3 from u_pb_cal within w_pdt_06043
end type
type rr_1 from roundrectangle within w_pdt_06043
end type
end forward

global type w_pdt_06043 from w_inherite
integer height = 3928
string title = "�����Ƿڵ�� (����)"
gb_5 gb_5
rb_2 rb_2
rb_1 rb_1
dw_print dw_print
dw_1 dw_1
pb_6 pb_6
pb_1 pb_1
dw_list dw_list
pb_2 pb_2
pb_3 pb_3
rr_1 rr_1
end type
global w_pdt_06043 w_pdt_06043

forward prototypes
public function integer wf_required_chk ()
public function integer wf_init ()
end prototypes

public function integer wf_required_chk ();String ls_sidat, ls_retim, ls_widpt, ls_wiemp, ls_mchno, ls_jidat, &
       ls_sttim, ls_gocod, ls_godesc, ls_jecod, ls_state, ls_fix

//if dw_1.Accepttext() = -1 then return -1
if dw_insert.Accepttext() = -1 then return -1 

ls_sidat = dw_insert.getitemstring(1,"mchrsl_sidat")  //�����Ƿ� ���� 
ls_mchno = dw_insert.getitemstring(1,"mchrsl_mchno")  //�����ȣ

ls_retim = dw_insert.getitemstring(1,"mchrsl_retim")   //�Ƿ� �ð�
ls_wiemp = dw_insert.getitemstring(1,"mchrsl_wiemp")   //�Ƿڴ����
ls_widpt = dw_insert.getitemstring(1,"mchrsl_widpt")   //�Ƿںμ�
ls_jidat = dw_insert.getitemstring(1,"mchrsl_jidat")   //��������
ls_sttim = dw_insert.getitemstring(1,"mchrsl_sttim")   //�������� �ð� 
ls_gocod = dw_insert.getitemstring(1,"mchrsl_gocod")   //���� ���� �ڵ�
ls_godesc = dw_insert.getitemstring(1,"mchrsl_godesc") //���� ����
ls_jecod = dw_insert.getitemstring(1,"mchrsl_jecod")   // ��ǰ�̻�߻��ڵ� 
ls_state = dw_insert.GetItemString(1,'nowsts')         //������(1:����, 2:����)
ls_fix   = dw_insert.GetItemString(1,'fixgub')         //����(1:�������, 2:������, 3:��ǰ��ü)

If Trim(ls_fix) = '' OR IsNull(ls_fix) Then
	f_message_chk(1400, '[����]')
	dw_1.SetColumn('fixgub')
	dw_1.SetFocus()
	Return -1
End If
 
if IsNull(ls_sidat) or ls_sidat = "" or f_datechk(ls_sidat) = -1 then //�����Ƿ� ����
	f_message_chk(1400, "[�����Ƿ�����]")
	dw_1.setcolumn('sidat')
	dw_1.setfocus()
	return -1
end if

if  IsNull(ls_mchno) or ls_mchno = ""  then  //�����ȣ  
	f_message_chk(1400, "[������ȣ]")
	dw_1.setcolumn('mchno')
	dw_1.setfocus()
	return -1 
end if

//if  IsNull(ls_retim) or ls_retim = ""  then    //�Ƿ� �ð� 
//	f_message_chk(1400, "[�Ƿ� �ð�]")
//	dw_insert.setcolumn("mchrsl_retim")
//	dw_insert.setfocus()
//	return -1                          
//end if
dw_insert.SetItem(1, 'mchrsl_retim', String(TODAY(), 'hhmm'))  //�Ƿڽð�
dw_insert.SetItem(1, 'maketim'     , String(TODAY(), 'hhmm'))  //�ۼ��ð�

if   IsNull(ls_wiemp) or ls_wiemp = ""  then //�Ƿڴ���� 
	f_message_chk(1400, "[�Ƿ� �����]")
	dw_insert.setcolumn("mchrsl_wiemp")
	dw_insert.setfocus()
	return -1
end if

if IsNull(ls_widpt) or ls_widpt = ""  then  //�Ƿںμ� 
	f_message_chk(1400, "[�Ƿ� �μ�]")
	dw_insert.setcolumn("mchrsl_widpt")
	dw_insert.setfocus()
	return -1
end if

if Trim(ls_state) = '' OR IsNull(ls_state) Then
	f_message_chk(1400, '[������]')
	dw_insert.SetColumn('nowsts')
	dw_insert.SetFocus()
	Return -1
End If

//������ �����°� ������ ��� ��������, �ð��� Ȯ��
If ls_state = '2' Then	
	if  IsNull(ls_jidat) or ls_jidat = "" or f_datechk(ls_jidat) = -1 then //��������
		f_message_chk(1400, "[��������]")
		dw_insert.setcolumn("mchrsl_jidat")
		dw_insert.setfocus()
		return -1 
	end if
	
	if   IsNull(ls_sttim) or ls_sttim = ""  then  //�������� �ð� 
		f_message_chk(1400, "[�������� �ð�]")
		dw_insert.setcolumn("mchrsl_sttim")
		dw_insert.setfocus()
		return -1
	end if
End If

//if IsNull(ls_gocod) or ls_gocod = "" then //���� ���� �ڵ� 
//	f_message_chk(1400, "[���� ���� �ڵ�]")
//	dw_insert.setcolumn("mchrsl_gocod")
//	dw_insert.setfocus()
//	return -1 
//end if

if  IsNull(ls_godesc) or ls_godesc = "" then //���� ���� 
	f_message_chk(1400, "[���� ����]")
	dw_insert.setcolumn("mchrsl_godesc")
	dw_insert.setfocus()
	return -1
end if

if  IsNull(ls_jecod) or ls_jecod = "" then // ��ǰ�̻�߻��ڵ� 
	f_message_chk(1400, "[��ǰ�̻�߻��ڵ�]")
	dw_insert.setcolumn("mchrsl_jecod")
	dw_insert.setfocus()
	return -1
end if

return 1
end function

public function integer wf_init ();dw_insert.Setredraw(false)
dw_insert.reset()
dw_insert.Insertrow(0)
dw_insert.Setredraw(true)

//dw_1.Setredraw(false)
//dw_1.Reset()
//dw_1.InsertRow(0)
//dw_1.SetFocus()

dw_list.SetTransObject(SQLCA)

if rb_1.Checked = true then
	// ��ϸ��
	dw_1.SetTabOrder('stdat' , 0)
	dw_1.SetTabOrder('eddat' , 0)
	dw_1.SetTabOrder('mchno' , 0)
	dw_1.SetTabOrder('mchnam', 0)

	p_del.Enabled = False	
	p_inq.Enabled = False
	p_del.pictureName = "c:\erpman\image\����_d.gif"	
	p_inq.pictureName = "c:\erpman\image\��ȸ_d.gif"
	
	dw_insert.SetItem(1, 'mchrsl_jidat', String(TODAY(), 'yyyymmdd'))
	dw_insert.SetItem(1, 'inputdat'    , String(TODAY(), 'yyyymmdd'))
	dw_insert.SetItem(1, 'makedat'     , String(TODAY(), 'yyyymmdd'))
	
	dw_insert.SetItem(1, 'mchrsl_widpt', gs_dept)
	dw_insert.SetItem(1, 'makedept'    , gs_dept)
	dw_insert.SetItem(1, 'mchrsl_wiemp', gs_empno)
	dw_insert.SetItem(1, 'p1_master_empname', f_get_name5('02', gs_empno, ''))
	dw_insert.SetItem(1, 'vndmst_cvnas', f_get_name5('01', gs_dept, ''))
   dw_insert.SetItem(1, 'makedept_nm' , f_get_name5('01', gs_dept, ''))
	
else  // ������� 		
	dw_1.SetTabOrder('stdat' , 10)
	dw_1.SetTabOrder('eddat' , 20)
	dw_1.SetTabOrder('mchno' , 30)
	dw_1.SetTabOrder('mchnam', 40)
	
	p_del.Enabled = TRUE		
	p_inq.Enabled = TRUE		
	p_del.pictureName = "c:\erpman\image\����_up.gif"	
	p_inq.pictureName = "c:\erpman\image\��ȸ_up.gif"
end if

//dw_1.setredraw(true)

ib_any_typing =False
p_print.Enabled = False	
p_print.pictureName = "c:\erpman\image\�μ�_d.gif"	


return 1
end function

on w_pdt_06043.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_print=create dw_print
this.dw_1=create dw_1
this.pb_6=create pb_6
this.pb_1=create pb_1
this.dw_list=create dw_list
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.dw_print
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.pb_6
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.rr_1
end on

on w_pdt_06043.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_print)
destroy(this.dw_1)
destroy(this.pb_6)
destroy(this.pb_1)
destroy(this.dw_list)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_print.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_1.InsertRow(0)
rb_1.checked = true
wf_init()
				
if gs_gubun = "testno" then 
	string ls_jidat, ls_sttim, ls_widpt, ls_wiemp, ls_gocod, ls_godesc, ls_jecod, &
	       ls_bigo,  ls_cvnas, ls_empname, ls_mchnam
	
	select a.jidat,   a.sttim,    a.widpt,    a.wiemp,     a.gocod,    a.godesc,
	       a.jecod,   a.bigo,     v.cvnas,    p.empname,   b.mchnam
	  into :ls_jidat, :ls_sttim,  :ls_widpt,  :ls_wiemp,   :ls_gocod,  :ls_godesc, 
	       :ls_jecod, :ls_bigo,   :ls_cvnas,  :ls_empname, :ls_mchnam
	  from mchrsl a, mchmst b, vndmst v, p1_master p
	 where a.sabu  = b.sabu(+)   
      and a.mchno = b.mchno(+)
      and a.widpt = v.cvcod(+)
      and a.wiemp = p.empno(+) 
	   and a.sabu  = :gs_sabu  
	   and a.sidat = :gs_codename 
	   and a.gubun = '4'      
	   and a.mchno = :gs_code 
	   and a.seq   = :gi_page ; 
	
//	dw_1.setitem(1, 'mchno', gs_code)
//	dw_1.setitem(1, 'mchmst_mchnam', ls_mchnam )
	dw_insert.setitem(1,"mchrsl_jidat" , ls_jidat)
	dw_insert.setitem(1,"mchrsl_sttim" , ls_sttim)
	dw_insert.setitem(1,"mchrsl_widpt" , ls_widpt)
	dw_insert.setitem(1,"vndmst_cvnas" , ls_cvnas)
	dw_insert.setitem(1,"mchrsl_wiemp" , ls_wiemp)
	dw_insert.setitem(1,"p1_master_empname" , ls_empname)
	dw_insert.setitem(1,"mchrsl_gocod" , ls_gocod)
	dw_insert.setitem(1,"mchrsl_godesc" , ls_godesc)
	dw_insert.setitem(1,"mchrsl_jecod" , ls_jecod)
	dw_insert.setitem(1,"mchrsl_bigo" , ls_bigo)
	
	dw_insert.setcolumn("mchrsl_retim")
	dw_insert.setfocus()
end if	

dw_1.SetItem(1, 'stdat', String(TODAY(), 'yyyymm' + '01'))
dw_1.SetItem(1, 'eddat', String(TODAY(), 'yyyymmdd'))


end event

type dw_insert from w_inherite`dw_insert within w_pdt_06043
integer x = 1819
integer y = 284
integer width = 2793
integer height = 1876
integer taborder = 40
string dataobject = "d_pdt_06043_01"
boolean border = false
boolean livescroll = false
end type

event dw_insert::ue_pressenter;call super::ue_pressenter;//if this.getcolumnname() = "mchrsl_bigo" then
//	return
//else
//   Send(Handle(this),256,9,0)
//   Return 1
//end if
end event

event dw_insert::rbuttondown;setnull(gs_gubun) 
setnull(gs_code) 
setnull(gs_codename)

string s_cod

s_cod = dw_insert.getcolumnname()

if s_cod = "mchrsl_widpt" then
	open( w_vndmst_4_popup ) 
	if isnull(gs_code) or gs_code = '' then return 
	
   dw_insert.setitem(1,"mchrsl_widpt", gs_code)
	dw_insert.setitem(1,"vndmst_cvnas", gs_codename)
	
ElseIf s_cod = 'makedept' Then
	Open(w_vndmst_4_popup)
	If Trim(gs_code) = '' OR IsNull(gs_code) Then
		dw_insert.SetItem(row, 'makedept'   , '')
		dw_insert.Setitem(row, 'mekddept_nm', '')
		Return
	End If
	
	This.SetItem(row, 'makedept'   , gs_code    )
	This.SetItem(row, 'makedept_nm', gs_codename)	

elseif s_cod = "mchrsl_wiemp" then
	gs_gubun = This.GetItemString(row, 'mchrsl_widpt')
	open( w_sawon_popup ) 
//	gs_gubun = dw_1.GetItemString(1, 'section')
//	If Trim(gs_gubun) = '' OR IsNull(gs_gubun) Then
//		MessageBox('Section Ȯ��', 'SECTION�� �����Ͻʽÿ�.')
//		Return
//	End If
//	gs_code  = '1'
//	Open(w_workemp_popup2)
	if isnull(gs_code) or gs_code = '' then return 
	dw_insert.setitem(1,"mchrsl_wiemp" ,gs_code)
	this.triggerevent(itemchanged!)
ELSEIF s_cod = 'mchrsl_wkctr' then
	Open(w_workplace_popup)
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
	This.SetItem(row, 'mchrsl_wkctr', gs_code    )
	This.SetItem(row, 'wrkctr_wcdsc', gs_codename)
ElseIf s_cod = 'mchrsl_mchno' Then
	open(w_mchno_popup)
		
	if gs_code= '' or isnull(gs_code) then return
	
	this.SetItem(1, "mchrsl_mchno", gs_code)
	this.SetItem(1, "mchmst_mchnam", gs_codename)
	
	String ls_ctr
	String ls_dsc
	
	SELECT WKCTR  , FUN_GET_WCDSC(WKCTR)
	  INTO :ls_ctr, :ls_dsc
	  FROM MCHMST
	 WHERE MCHNO  = :gs_code 
		AND ROWNUM = 1        ;
	If SQLCA.SQLCODE <> 0 Then Return
	
	dw_insert.SetItem(1, 'mchrsl_wkctr', ls_ctr)
	dw_insert.SetItem(1, 'wrkctr_wcdsc', ls_dsc)
end if
end event

event dw_insert::itemerror;call super::itemerror;return 1 

end event

event dw_insert::itemchanged;String  s_cod, sNull, sname, sname2, sdept, sdeptnm
Integer ireturn

SetNull(sNull)

if this.getcolumnname() = "mchrsl_retim" then //�Ƿ� �ð� 
   s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then	return 
	
	if f_timechk(s_cod) = -1 then 
		f_message_chk(176, "[�Ƿڽð�]")
		setitem(1, "mchrsl_retim", snull)
		return 1 
	end if

elseif this.getcolumnname() = "mchrsl_widpt" then //�Ƿںμ� 
   s_cod = Trim(this.GetText())
	ireturn = f_get_name2('�μ�','Y', s_cod, sname, sname2 )
	this.setitem(1,"mchrsl_widpt", s_cod)
	this.setitem(1,"vndmst_cvnas", sname)
	return ireturn
	
elseIf This.GetColumnName() = 'makedept' Then //�ۼ��μ�
	If Trim(data) = '' OR IsNull(data) Then
		This.SetItem(row, 'makedept_nm', '')
		Return
	End If
	
	ireturn = f_get_name2('�μ�', 'Y', data, sname, sname2)
	This.SetItem(row, 'makedept_nm', sname)
	Return ireturn
elseif this.getcolumnname() = "mchrsl_wiemp" then //�Ƿڴ���� 
   s_cod = Trim(this.GetText())
	ireturn = f_get_name2('���','Y', s_cod , sname, sname2 )
	this.setitem(1,"mchrsl_wiemp", s_cod )
	this.setitem(1,"p1_master_empname", sname)
	
	if ireturn <> 1 then 
	  SELECT "P1_MASTER"."DEPTCODE",  "VNDMST"."CVNAS2"  
		 INTO :sdept, :sdeptnm 
		 FROM "P1_MASTER", "VNDMST"  
		WHERE "P1_MASTER"."DEPTCODE" = "VNDMST"."CVCOD"(+)
		  AND "P1_MASTER"."EMPNO"    = :s_cod   ;

		this.setitem(1,"mchrsl_widpt", sdept)
		this.setitem(1,"vndmst_cvnas", sdeptnm)
		this.setitem(1,"makedept"    , sdept)
		this.setitem(1,"makedept_nm" , sdeptnm)
   end if
	return ireturn
elseif this.getcolumnname() = "mchrsl_jidat" then //��������
   s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[��������]")
		this.object.mchrsl_jidat[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "mchrsl_sttim" then //�������� �ð� 
   s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then	return 
	
	if f_timechk(s_cod) = -1 then 
		f_message_chk(176, "[�������۽ð�]")
		setitem(1, "mchrsl_sttim", snull)
		return 1 
	end if
elseif this.getcolumnname() = 'mchrsl_wkctr' then
	if trim(data) = '' or isnull(data) then
		this.setitem(row, 'wrkctr_wcdsc', '')
		return
	end if
	
	String ls_name
	
	SELECT WCDSC
	  INTO :ls_name
	  FROM WRKCTR
	 WHERE WKCTR = :data ;
	
	This.SetItem(row, 'wrkctr_wcdsc', ls_name)
	
End If

end event

type p_delrow from w_inherite`p_delrow within w_pdt_06043
integer y = 5000
integer taborder = 90
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06043
integer y = 5000
integer taborder = 70
end type

type p_search from w_inherite`p_search within w_pdt_06043
integer y = 5000
integer taborder = 180
end type

type p_ins from w_inherite`p_ins within w_pdt_06043
integer y = 5000
integer taborder = 50
end type

type p_exit from w_inherite`p_exit within w_pdt_06043
integer x = 4398
integer y = 36
integer taborder = 170
end type

type p_can from w_inherite`p_can within w_pdt_06043
integer x = 4224
integer y = 36
integer taborder = 150
end type

event p_can::clicked;call super::clicked;rb_1.checked = true

wf_init()
end event

type p_print from w_inherite`p_print within w_pdt_06043
integer x = 3529
integer y = 36
integer taborder = 190
boolean enabled = false
string picturename = "C:\erpman\image\�μ�_d.gif"
end type

event p_print::clicked;call super::clicked;OpenWithParm(w_print_preview, dw_print)	

end event

type p_inq from w_inherite`p_inq within w_pdt_06043
integer x = 3703
integer y = 36
boolean enabled = false
string picturename = "C:\erpman\image\��ȸ_d.gif"
end type

event p_inq::clicked;call super::clicked;//string ls_sidat, ls_mchno, sRslcod 
//int    li_seq	
//
//if dw_1.Accepttext() = -1 then return
//
//ls_sidat = dw_1.getitemstring(1, "sidat") 
//ls_mchno = dw_1.getitemstring(1, "mchno") 
//li_seq   = dw_1.getitemdecimal(1, "seq")
//
//if IsNull(ls_sidat) or ls_sidat = "" then
//	f_message_chk(30,'[�����Ƿ�����]')
//	dw_1.setcolumn("sidat") 
//	dw_1.setfocus()
//   return  
//end if
//
//if IsNull(ls_mchno) or ls_mchno = "" then 
//	f_message_chk(30,'[������ȣ]')
//	dw_1.setcolumn("mchno")
//	dw_1.setfocus()
//	return 
//end if
//
//if IsNull(li_seq) then
//	f_message_chk(30,'[�Ƿڹ�ȣ]')
//	dw_1.setcolumn("mchno")
//	dw_1.setfocus()
//	return 
//end if

dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_st
String ls_ed

ls_st = dw_1.GetItemString(row, 'stdat')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('�������� Ȯ��', '���������� �߸��Ǿ����ϴ�.')
		dw_1.SetColumn('stdat')
		dw_1.SetFocus()
		Return 
	End If
End If

ls_ed = dw_1.GetItemString(row, 'eddat')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('�������� Ȯ��', '���������� �߸��Ǿ����ϴ�.')
		dw_1.SetColumn('eddat')
		dw_1.SetFocus()
		Return 
	End If
End If

String ls_mchno

ls_mchno = dw_1.GetItemString(row, 'mchno')
If Trim(ls_mchno) = '' OR IsNull(ls_mchno) Then ls_mchno = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(gs_sabu, ls_st, ls_ed, ls_mchno)
dw_list.SetRedraw(True)

//if dw_insert.retrieve(gs_sabu, ls_sidat, ls_mchno, li_seq ) <= 0 then
//   f_message_chk(50, '')
//   dw_1.setcolumn("mchno")
//   dw_1.setfocus()
//   Return
//else
//	dw_print.retrieve(gs_sabu, ls_sidat, ls_mchno, li_seq )
//	sRslcod = dw_insert.GetitemSTring(1, 'mchrsl_rslcod')
//	
//	if sRslcod <> 'W' then 
//		messagebox('Ȯ ��', '��������� ��ϵ� �ڷ��Դϴ�. �ڷḦ ������ �� �����ϴ�.')
//		dw_insert.enabled = false
//		p_del.enabled = false
//		p_mod.enabled = false
//		p_del.pictureName = "c:\erpman\image\����_d.gif"	
//		p_mod.pictureName = "c:\erpman\image\����_d.gif"
//	END IF
//end if

ib_any_typing = False //�Է��ʵ� ���濩�� No

p_print.Enabled = True
p_print.pictureName = "c:\erpman\image\�μ�_up.gif"	

//dw_1.Modify('sidat.protect = 1')
//dw_1.Modify('sidat.background.color = 79741120')
//dw_1.Modify('mchno.protect = 1')
//dw_1.Modify('mchno.background.color = 79741120')

end event

type p_del from w_inherite`p_del within w_pdt_06043
integer x = 4050
integer y = 36
integer taborder = 130
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;if dw_1.Accepttext() <> 1 then return
if dw_insert.Accepttext() <> 1 then return 

if f_msg_delete() = -1 then return

dw_insert.setredraw(false)
dw_insert.DeleteRow(0)

if dw_insert.Update() <> 1 then
	ROLLBACK;
	f_message_chk(31,'[��������]') 
	p_can.triggerevent(clicked!)
	dw_insert.setredraw(true)
	Return
end if
commit;    // ���� �Ϸ� 

p_can.triggerevent(clicked!)
p_inq.TriggerEvent(Clicked!)

dw_insert.setredraw(true)
sle_msg.Text = "����ó�� �Ǿ����ϴ�!"

end event

type p_mod from w_inherite`p_mod within w_pdt_06043
integer x = 3877
integer y = 36
integer taborder = 110
end type

event p_mod::clicked;call super::clicked;String ls_sidat, ls_mchno
long   ll_seq 

if dw_insert.AcceptText() = -1 then return

ls_sidat = dw_insert.getitemstring(1,"mchrsl_sidat")
ls_mchno = dw_insert.getitemstring(1,"mchrsl_mchno")

if wf_required_chk() = -1 then return // �ʼ��Է��׸� üũ 

if f_msg_update() = -1 then return
///////////////////////////////////

if rb_1.checked = true then   // ��ϸ��  
	select Max(seq)  // �Ƿ� ��ȣ �ڵ�ä�� 
	  into :ll_seq
	  from mchrsl 
	 where sabu  = :gs_sabu
	   and sidat = :ls_sidat
		and gubun = '4'
      and mchno = :ls_mchno ; 
					
	if ll_seq = 0 or IsNULL(ll_seq) then
		ll_seq = 950
	else
		ll_seq ++
	end if

///////////////////////////////////////////////////////////////////////////	
	dw_insert.setitem(1, "mchrsl_sabu",  gs_sabu )
	dw_insert.setitem(1, "mchrsl_sidat", ls_sidat)
	dw_insert.setitem(1, "mchrsl_mchno", ls_mchno) 
	dw_insert.setitem(1, "mchrsl_seq",   ll_seq)
//	dw_1.setitem(1, "seq",   ll_seq)
	dw_insert.SetItem(1, 'inputdat', String(TODAY(), 'yyyymmdd'))
	dw_insert.SetItem(1, 'inputtim', String(TODAY(), 'hhmm'    ))

	IF dw_insert.Update() > 0 THEN		
		COMMIT;
		messagebox("Ȯ��", "�Ƿڹ�ȣ����:" + string(ll_seq) ) 
	ELSE
		ROLLBACK;
		f_message_chk(32, "[�������]")
		return 
	END IF

//	dw_1.Modify('sidat.protect = 1 ')
//	dw_1.Modify('sidat.background.color = 79741120')
//	dw_1.Modify('mchno.protect = 1 ')
//	dw_1.Modify("mchno.background.color = 79741120")
	p_del.Enabled = TRUE		
	p_inq.Enabled = TRUE
	p_del.pictureName = "c:\erpman\image\����_up.gif"	
	p_inq.pictureName = "c:\erpman\image\��ȸ_up.gif"	
	rb_2.checked = true
			
else         // ������� 
	 IF dw_insert.Update() > 0 THEN		
		 COMMIT;
	 ELSE
		ROLLBACK;
		f_message_chk(32, "[�������]")
		return
	 END IF
end if

If Messagebox('���', '���� �Ƿڼ��� ��� �Ͻðڽ��ϱ�?', Question!, YesNo!, 2) = 1 Then
	dw_print.Retrieve(gs_sabu, ls_sidat, '4', ls_mchno, ll_seq)
	p_print.TriggerEvent(Clicked!)
Else
	p_inq.Triggerevent(clicked!)
End If
		

		

end event

type cb_exit from w_inherite`cb_exit within w_pdt_06043
integer x = 3191
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06043
integer x = 2053
integer y = 5000
integer taborder = 120
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06043
integer x = 1605
integer y = 2644
end type

type cb_del from w_inherite`cb_del within w_pdt_06043
integer x = 2405
integer y = 5000
integer taborder = 140
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06043
integer x = 3707
integer y = 5000
integer taborder = 80
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_06043
integer x = 2295
integer y = 5000
integer taborder = 100
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_06043
end type

type cb_can from w_inherite`cb_can within w_pdt_06043
integer x = 2757
integer y = 5000
integer taborder = 160
end type

type cb_search from w_inherite`cb_search within w_pdt_06043
integer x = 1952
integer y = 2632
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_06043
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06043
end type

type gb_5 from groupbox within w_pdt_06043
integer x = 3218
integer y = 4
integer width = 256
integer height = 192
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
end type

type rb_2 from radiobutton within w_pdt_06043
integer x = 3241
integer y = 108
integer width = 219
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "����"
end type

event clicked;wf_init()



end event

type rb_1 from radiobutton within w_pdt_06043
integer x = 3241
integer y = 40
integer width = 219
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "���"
boolean checked = true
end type

event clicked;wf_init()

end event

type dw_print from datawindow within w_pdt_06043
boolean visible = false
integer x = 645
integer y = 2188
integer width = 357
integer height = 320
boolean bringtotop = true
boolean enabled = false
string title = "�����Ƿڼ�"
string dataobject = "d_pdt_06043_03"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdt_06043
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 32
integer y = 24
integer width = 1915
integer height = 252
integer taborder = 20
string dataobject = "d_pdt_06043_04"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string  s_cod , ls_mchno , ls_mchnam  , snull , ls_sidat 
long    lnull , net , ll_seq , ll_temp

sle_msg.text = ""
setnull(snull)
setnull(lnull)
 
if this.getcolumnname() = "sidat"  then  // �����Ƿ� ���� 
	s_cod = Trim(this.gettext()) 
   if s_cod = '' or isnull(s_cod) then return 
	if f_datechk(s_cod) = -1 then 
		f_message_chk(35, "[����]" )
		this.object.sidat[1] = "" 
		return 1
	end if
elseif  this.getcolumnname() = "mchno" then // �����ȣ 
	s_cod = Trim(this.gettext())
		
	/* NUll ���� ""���� üũ */
	if IsNull(s_cod) or s_cod = ""  then
		this.object.mchnam[1] = ""
		this.object.seq[1] = lnull
		return 
	end if
				
	/*  ���� �ڵ尡 table �� �ִ� ������ �ڵ� ��ȸ */
	select mchnam 
	  into :ls_mchnam
	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod ;
				
	if sqlca.sqlcode <> 0 then
		messageBox("Ȯ��", "��ϵ� �����ȣ�� �ƴմϴ�." )
		this.setitem(1,"mchno", snull )
		this.setitem(1,"mchmst_mchnam", snull)
		this.setitem(1, "seq", lnull)
		return 1
	end if
	this.setitem(row,"mchmst_mchnam", ls_mchnam ) 	
		
	if rb_2.checked = true then  // ���� ��� �̸� �ڵ����� �˾��ߵ��� (1)
		  gs_gubun    = 'W'
		  gs_code     = s_cod // �����ȣ 
		  gs_codename = this.getitemstring(1, "sidat") // �Ƿ����� 
		  
		  open(w_pdt_06043_pop_up)
		  
		  if IsNull(gs_code) or gs_code= "" then 
				MessageBox("Ȯ��", "�ڷḦ �����ϼ���. " ) 
				this.setitem(1, "sidat", snull)
				this.setitem(1, "mchno", snull)
				this.setitem(1, "mchmst_mchnam" , snull)
				this.setitem(1, "seq", lnull)
				return 1 
		  end if
			this.Setitem(1, "sidat",  gs_gubun )
			this.Setitem(1, "mchno",  gs_code )
			this.Setitem(1, "mchmst_mchnam", gs_codename )
			this.Setitem(1, "seq",  gi_page )
			
			If gs_codename2 <> '�Ƿ�' Then
				MessageBox('�Ƿڳ���Ȯ��', gs_codename2 + ' �� �׸��Դϴ�!~r~n���� �Ͻ� �� �����ϴ�.')
				This.SetColumn('mchno')
				This.SetFocus()
				Return
			End If
				
			
		  p_inq.triggerEvent(Clicked!)  // �ڵ����� ��ȸ�ǵ��� (2)
			 
	end if 
     
end if

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if	this.getcolumnname() = "mchno" then
//	if rb_1.checked = true then // �ű� ��� ��� �϶� 
		open(w_mchno_popup)
		
		if gs_code= '' or isnull(gs_code) then return
		
		this.SetItem(1, "mchno", gs_code)
		this.SetItem(1, "mchnam", gs_codename)
		
		String ls_ctr
		String ls_dsc
		
		SELECT WKCTR  , WCDSC
		  INTO :ls_ctr, :ls_dsc
		  FROM WRKCTR
		 WHERE MCHNO  = :gs_code 
		   AND ROWNUM = 1        ;
		If SQLCA.SQLCODE <> 0 Then Return
		
		dw_insert.SetItem(1, 'mchrsl_wkctr', ls_ctr)
		dw_insert.SetItem(1, 'wrkctr_wcdsc', ls_dsc)
	
//	elseif rb_2.checked = true then // ���� ��� �϶� 
//		gs_gubun    = 'W' //�Ƿ� �ڷ� 
//	   gs_codename = this.getitemstring(1, "sidat") // �Ƿ����� 
//					
//		open(w_pdt_06043_pop_up)
//							
//		if IsNull(gs_code) or gs_code = "" then return  
//
//		this.Setitem(1, "dat",  gs_gubun )
//		this.Setitem(1, "mchno",  gs_code )
//		this.Setitem(1, "mchnam", gs_codename )
//		this.Setitem(1, "seq",  gi_page )
//		
//		If gs_codename2 <> '�Ƿ�' Then
//			MessageBox('�Ƿ�Ȯ��', gs_codename2 + ' �� �ڷ��Դϴ�!~r~n���� �Ͻ� �� �����ϴ�.')
//			This.SetColumn('mchno')
//			This.SetFocus()
//			Return
//		End If		
//		
//		p_inq.triggerevent(clicked!)   // �ڵ����� ��ȸ 
//	end if
end if 
	
end event

event itemerror;return 1
end event

type pb_6 from u_pb_cal within w_pdt_06043
integer x = 768
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('stdat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'stdat', gs_code)
end event

type pb_1 from u_pb_cal within w_pdt_06043
integer x = 2592
integer y = 468
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('mchrsl_sidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_sidat', gs_code)

end event

type dw_list from u_d_select_sort within w_pdt_06043
integer x = 46
integer y = 296
integer width = 1742
integer height = 1840
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdt_06044_03_kum"
boolean border = false
end type

event clicked;//
If row < 1 Then Return

String ls_data[]
Long   ll_seq
ls_data[1] = This.GetItemString(row, 'mchrsl_sabu' )  //�����
ls_data[2] = This.GetItemString(row, 'mchrsl_sidat')  //�����Ƿ���
ls_data[3] = This.GetItemString(row, 'mchrsl_gubun')  //�Ƿڱ���
ls_data[4] = This.GetItemString(row, 'mchrsl_mchno')  //�����ȣ
ll_seq     = This.GetItemNumber(row, 'mchrsl_seq'  )  //�Ƿڹ�ȣ

If This.GetItemString(row, 'status') <> '1' Then
	p_mod.Enabled = False
	p_del.Enabled = False
	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
Else
	p_mod.Enabled = True
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
	p_del.PictureName = 'C:\erpman\image\����_up.gif'	
End If

dw_insert.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)
dw_print.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)
end event

event retrieveend;call super::retrieveend;If rowcount < 1 Then Return

Long row
row = This.GetRow()

String ls_data[]
Long   ll_seq
ls_data[1] = This.GetItemString(row, 'mchrsl_sabu' )  //�����
ls_data[2] = This.GetItemString(row, 'mchrsl_sidat')  //�����Ƿ���
ls_data[3] = This.GetItemString(row, 'mchrsl_gubun')  //�Ƿڱ���
ls_data[4] = This.GetItemString(row, 'mchrsl_mchno')  //�����ȣ
ll_seq     = This.GetItemNumber(row, 'mchrsl_seq'  )  //�Ƿڹ�ȣ

If This.GetItemString(row, 'status') <> '1' Then
	p_mod.Enabled = False
	p_del.Enabled = False
	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
Else
	p_mod.Enabled = True
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
	p_del.PictureName = 'C:\erpman\image\����_up.gif'	
End If

If dw_insert.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq) < 1 Then
	Return -1
Else
	dw_print.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)
	This.SelectRow(0, FALSE)
	This.SetRow(1)	
	This.SelectRow(1, TRUE)
End If


end event

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow < 1 Then Return

This.SelectRow(0, FALSE)
This.SetRow(currentrow)	
This.SelectRow(currentrow, TRUE)

String ls_data[]
Long   ll_seq
ls_data[1] = This.GetItemString(currentrow, 'mchrsl_sabu' )  //�����
ls_data[2] = This.GetItemString(currentrow, 'mchrsl_sidat')  //�����Ƿ���
ls_data[3] = This.GetItemString(currentrow, 'mchrsl_gubun')  //�Ƿڱ���
ls_data[4] = This.GetItemString(currentrow, 'mchrsl_mchno')  //�����ȣ
ll_seq     = This.GetItemNumber(currentrow, 'mchrsl_seq'  )  //�Ƿڹ�ȣ

If This.GetItemString(currentrow, 'status') <> '1' Then
	p_mod.Enabled = False
	p_del.Enabled = False
	p_mod.PictureName = 'C:\erpman\image\����_d.gif'
	p_del.PictureName = 'C:\erpman\image\����_d.gif'
Else
	p_mod.Enabled = True
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\����_up.gif'
	p_del.PictureName = 'C:\erpman\image\����_up.gif'	
End If

dw_insert.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)
dw_print.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)

end event

type pb_2 from u_pb_cal within w_pdt_06043
integer x = 4087
integer y = 636
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('mchrsl_jidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_jidat', gs_code)
end event

type pb_3 from u_pb_cal within w_pdt_06043
integer x = 1239
integer y = 44
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('eddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'eddat', gs_code)
end event

type rr_1 from roundrectangle within w_pdt_06043
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 284
integer width = 1769
integer height = 1872
integer cornerheight = 40
integer cornerwidth = 55
end type

