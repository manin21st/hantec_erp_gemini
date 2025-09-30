$PBExportHeader$w_adt_02020.srw
$PBExportComments$�۾����� ���
forward
global type w_adt_02020 from w_inherite
end type
type dw_cond from u_key_enter within w_adt_02020
end type
type pb_1 from u_pb_cal within w_adt_02020
end type
type cb_plc from commandbutton within w_adt_02020
end type
type rr_4 from roundrectangle within w_adt_02020
end type
end forward

global type w_adt_02020 from w_inherite
string title = "�۾����� ���"
dw_cond dw_cond
pb_1 pb_1
cb_plc cb_plc
rr_4 rr_4
end type
global w_adt_02020 w_adt_02020

type variables
DataStore ds_jobconh, ds_jobcond
Boolean   ib_ret=False
String    sOrginalSql
integer   li_last_x
String    isItnbr, isEmpno
end variables

forward prototypes
public function integer wf_create_report (string arg_jobcode)
public function string wf_get_sql ()
public function integer wf_set_report_text (string ar_col, string ar_text, string ar_x, string ar_y, string ar_h, string ar_w)
public function integer wf_set_report_column (string ar_col, integer ar_tab, integer ar_width, string ar_format)
end prototypes

public function integer wf_create_report (string arg_jobcode);string error_syntaxfromSQL, error_create, serr, sCol, sColText, sText, sIsnum
Int    i, j, itab = 0, li_x = 0, li_unit_per_char = 30 
Long   lx, ly, lw, lh, lxpos, lDigit, l_dx, l_dw, li_w, lnam
string new_sql, new_syntax, sFormat
integer li_FileNum

// ��ȸ�� ���̺����� ���� sql������ ���Ѵ�
new_sql = wf_get_sql()

new_syntax = SQLCA.SyntaxFromSQL(new_sql,'Style(Type=tabular)', error_syntaxfromSQL)

IF Len(error_syntaxfromSQL) > 0 THEN
   MessageBox('error',error_syntaxfromSQL)
ELSE
  // Generate new DataWindow
  dw_insert.Create(new_syntax, error_create)
  IF Len(error_create) > 0 THEN
		MessageBox('error1',error_create)
  END IF
END IF

// DataWindow backgroud
dw_insert.Modify("DataWindow.Color='32106727'")

// Header ���� ����
dw_insert.Modify("DataWindow.Header.Height='196'")

// key Column�� text�� ���� �Ӽ� ����
If ds_jobconh.GetItemString(1, 'lotsno') = 'Y' Then 
	itab += 5
	
	wf_set_report_column('lotsno', itab, 20,'')
	
	li_x = Long(dw_insert.Describe('lotsno' + ".x"))
	li_w = Long(dw_insert.Describe('lotsno' + ".width")) 
	
	wf_set_report_text('lotsno', '*LOT NO     ', string(li_x), '0', '196', string(li_w))		
End If
If ds_jobconh.GetItemString(1, 'sdate') = 'Y'  Then 
	itab += 5
	
	wf_set_report_column('sdate', itab, 11,'')
	dw_insert.Modify("sdate.Format='@@@@.@@.@@'")  //FORMAT
	dw_insert.Modify("sdate.alignment='2'")       //FORMAT(center)

	li_x = Long(dw_insert.Describe('sdate' + ".x"))
	li_w = Long(dw_insert.Describe('sdate' + ".width"))
	
	wf_set_report_text('sdate', '*��������', string(li_x), '0', '196', string(li_w))
End If
If ds_jobconh.GetItemString(1, 'stime') = 'Y'  Then 
	itab += 5
	
	wf_set_report_column('stime', itab, 8,'')
	dw_insert.Modify("stime.Format='@@:@@'")      //FORMAT
	dw_insert.Modify("stime.alignment='2'")       //FORMAT(center)
	
	li_x = Long(dw_insert.Describe('stime' + ".x")) 
	li_w = Long(dw_insert.Describe('stime' + ".width"))
	
	wf_set_report_text('stime', '*����~r �ð�', string(li_x), '0', '196', string(li_w))
End If
If ds_jobconh.GetItemString(1, 'edate') = 'Y'  Then 
	itab += 5
	
	wf_set_report_column('edate', itab, 11,'')
	dw_insert.Modify("edate.Format='@@@@.@@.@@'") //FORMAT
	dw_insert.Modify("edate.alignment='2'")       //FORMAT(center)
	
	li_x = Long(dw_insert.Describe('edate' + ".x"))
	li_w = Long(dw_insert.Describe('edate' + ".width"))
	
	wf_set_report_text('edate', '*��������', string(li_x), '0', '196', string(li_w))
End If
If ds_jobconh.GetItemString(1, 'etime') = 'Y'  Then 
	itab += 5
	
	wf_set_report_column('etime', itab, 8,'')
	dw_insert.Modify("etime.Format='@@:@@'")     //FORMAT
	dw_insert.Modify("etime.alignment='2'")      //FORMAT(center)
	
	li_x = Long(dw_insert.Describe('etime' + ".x"))
	li_w = Long(dw_insert.Describe('etime' + ".width"))
	
	wf_set_report_text('etime', '*����~r �ð�', string(li_x), '0', '196', string(li_w))
End If
If ds_jobconh.GetItemString(1, 'itnbr') = 'Y'  Then 
	itab += 5
	
	wf_set_report_column('itnbr', itab, 20,'')
	
	li_x = Long(dw_insert.Describe('itnbr' + ".x")) 
	li_w = Long(dw_insert.Describe('itnbr' + ".width"))
	
	wf_set_report_text('itnbr', '*ǰ��', string(li_x), '0', '196', string(li_w))
End If
//If ds_jobconh.GetItemString(1, 'itnbr') = 'Y'  Then  //ǰ���� ������ ��츸 ������
//	itab += 5
//	
//	wf_set_report_column('itdsc', itab, 40)
//	
//	li_x = Long(dw_insert.Describe('itdsc' + ".x")) 
//	li_w = Long(dw_insert.Describe('itdsc' + ".width"))
//	
//	wf_set_report_text('itdsc', 'ǰ��', string(li_x), '0', '196', string(li_w))
//End If
If ds_jobconh.GetItemString(1, 'empno') = 'Y'  Then 
	itab += 5
	
	wf_set_report_column('empno', itab, 10,'')
	
	li_x = Long(dw_insert.Describe('empno' + ".x")) 
	li_w = Long(dw_insert.Describe('empno' + ".width"))
	
	wf_set_report_text('empno', '*�۾���', string(li_x), '0', '196', string(li_w))
End If

//// �۾��ڸ�
//If ds_jobconh.GetItemString(1, 'empno') = 'Y'  Then 	
//	itab += 5
//	
//	wf_set_report_column('p1_master_empnm', 0, 8)
//	
//	li_x = Long(dw_insert.Describe('p1_master_empnm' + ".x")) 
//	li_w = Long(dw_insert.Describe('p1_master_empnm' + ".width"))
//	
//	wf_set_report_text('p1_master_empnm', '�۾��ڸ�', string(li_x), '0', '196', string(li_w))
//End If

// ����� ���� Column / TEXT �Ӽ�����
For i = 1 To ds_jobcond.RowCount()
	sCol 		 = ds_jobcond.GetItemString(i, 'itemcod')
	sColText	 = ds_jobcond.GetItemString(i, 'item')
   lDigit    = ds_jobcond.GetItemNumber(i, 'digit')
	lnam      = len(ds_jobcond.GetItemString(i, 'item'))
	sFormat   = ds_jobcond.GetItemString(i, 'chk_1')
	itab += 5	// Tab Order : 5�� �����Ѵ�
	
	//Ÿ��Ʋ���� ������ ���̺��� Ŭ���
	if lnam > lDigit then
		lDigit = lnam 
	end if

	wf_set_report_column(sCol, itab, lDigit, sFormat)	
	
	l_dx = Long(dw_insert.Describe(sCol + ".x")) 
	l_dw = Long(dw_insert.Describe(sCol + ".width"))
	
	// ����� ���� Column �� text �Ӽ�
	wf_set_report_text(sCol, sColText, string(l_dx), '136', '64', string(l_dw))		
Next

/* -------------------------------------------- */
// ����� ���� Column�� ���� �׷��ؽ�Ʈ ���� Header #1 start
i = ds_jobcond.RowCount()
j  = 0
lxpos = 0

do 
	sCol 		= Trim(ds_jobcond.GetItemString(i, 'itemcod'))
	sColText = Trim(ds_jobcond.GetItemString(i, 'grpnam1'))
	lx 		= Long(dw_insert.Describe(sCol + ".x"))
	
	If lxpos = 0 Then lxpos =	Long(dw_insert.Describe(sCol + ".x")) + Long(dw_insert.Describe(sCol + ".width"))
	
	If IsNull(sColText) Or sColText = '' Then
		i = i -1
		Continue
	Else
		j = j + 1	// Text id
		
		// Header #2�� ���� ��� height�� �ι�� �Ѵ�
		sText = Trim(ds_jobcond.GetItemString(i, 'grpnam2'))
		If IsNull(sText) Or sText = '' Then
			lh = 132
		Else
			lh = 64
		End If
		
		// Width���� ����(ȭ���̻ڰ� �ϱ� ����...
		lw = lxpos - lx
		
		dw_insert.Modify("create text(band=header color='16777215' alignment='2' border='0'"  +  &
								" height.autosize=no moveable=0 resizeable=0 " + &
								" x='" +string(lx) + "' y='0' height='" +string(lh) + "' width='" + string(lw) + "'"  + &
								" text='" +sColText+"'  name=" + 'new' + string(j,'00') + '_t' +  &
								" font.face='����ü' font.height='-9' font.weight='400' font.family='1' font.pitch='0' font.charset='129' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='0' background.color='28144969')")

      lxpos   = 0
		i = i -1
	End If
loop while (i >= 1)
/* -------------------------------------------- */

// ����� ���� Column�� ����  �׷��ؽ�Ʈ ���� Header #2 start
i = ds_jobcond.RowCount()
lxpos = 0
do 
	sCol 		= Trim(ds_jobcond.GetItemString(i, 'itemcod'))
	sColText = Trim(ds_jobcond.GetItemString(i, 'grpnam2'))
	lx 		= Long(dw_insert.Describe(sCol + ".x"))
	
	If lxpos = 0 Then lxpos =	Long(dw_insert.Describe(sCol + ".x")) + Long(dw_insert.Describe(sCol + ".width"))
	
	If IsNull(sColText) Or sColText = '' Then
		i = i -1
		Continue
	Else
		j = j + 1	// Text id
		lh = 64
		
		lw = lxpos - lx
		
		dw_insert.Modify("create text(band=header color='16777215' alignment='2' border='0'"  +  &
								" height.autosize=no moveable=0 resizeable=0 " + &
								" x='" +string(lx) + "' y='68' height='" +string(lh) + "' width='" + string(lw) + "'"  + &
								" text='" +sColText+"'  name=" + 'new' + string(j,'00') + '_t' +  &
								" font.face='����ü' font.height='-9' font.weight='400' font.family='1' font.pitch='0' font.charset='129' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='0' background.color='28144969')")
      lxpos = 0
		i = i -1
	End If
loop while (i >= 1)
/* -------------------------------------------- */

// UPDATE TABLE ����
dw_insert.Modify("DataWindow.Table.UpdateTable='" + arg_jobcode +"'")
dw_insert.Modify("DataWindow.Table.UpdateWhere='0' ")
dw_insert.Modify("DataWindow.Table.UpdateKeyinPlace=no")

// Key Column ����
dw_insert.Modify("siljpno.Key='yes'")
dw_insert.Modify("sidate.Key='yes'")
dw_insert.Modify("siljpno.Update='Yes'")
dw_insert.Modify("sidate.Update='Yes'")
dw_insert.Modify("wkctr.Update='Yes'")

//DISPLAY ����(UPDATE Key����)
dw_insert.Modify("siljpno.visible='0'")
dw_insert.Modify("sidate.visible='0'")
dw_insert.Modify("wkctr.visible='0'")

dw_insert.Modify("siljpno_t.visible='0'")
dw_insert.Modify("sidate_t.visible='0'")
dw_insert.Modify("wkctr_t.visible='0'")

ds_jobconh.GetItemString(1, 'empno')
//
////////////////////////////
dw_insert.SetTransObject(SQLCA)

dw_insert.Retrieve()

Return 0
end function

public function string wf_get_sql ();String sGetSql, sJobcode, sItemCod, sSidate
Long   ix 

sJobcode = ds_jobconh.GetItemString(1, 'jobcode')	// �۾�����
sSidate  = dw_cond.GetItemString(1, 'sidate')	// �������

sGetSql = "SELECT "

// �����÷� ����
If ds_jobconh.GetItemString(1, 'lotsno') = 'Y' Then sGetSql += " A.LOTSNO,"
If ds_jobconh.GetItemString(1, 'sdate')  = 'Y' Then sGetSql += " A.SDATE,"
If ds_jobconh.GetItemString(1, 'stime')  = 'Y' Then sGetSql += " A.STIME,"
If ds_jobconh.GetItemString(1, 'edate')  = 'Y' Then sGetSql += " A.EDATE,"
If ds_jobconh.GetItemString(1, 'etime')  = 'Y' Then sGetSql += " A.ETIME,"
If ds_jobconh.GetItemString(1, 'itnbr')  = 'Y' Then sGetSql += " A.ITNBR,"
If ds_jobconh.GetItemString(1, 'empno')  = 'Y' Then sGetSql += " A.EMPNO,"
//If ds_jobconh.GetItemString(1, 'empno')  = 'Y' Then sGetSql += " B.EMPNAME AS EMPNM,"

For ix = 1 To ds_jobcond.RowCount()
	sItemCod = ds_jobcond.GetItemString(ix, 'itemcod')
	sGetSql += " A." + sItemCod + ", "
Next

// Key Column �� ��ȸ������ ������ڷ� ����
sGetSql += "A.SILJPNO, A.SIDATE, A.WKCTR "
//sGetSql += " FROM P1_MASTER B, " + sJobcode + " A"
sGetSql += " FROM " + sJobcode + " A"

// �������� ������ sql������ �������� .. ���߿� ���ڸ� ����� ��츦 ���ؼ� �����Ѵ�.
sOrginalSql = sGetSql

//sGetSql += " WHERE A.EMPNO = B.EMPNO(+) AND A.SIDATE = " + sSidate
sGetSql += " WHERE A.SIDATE = " + sSidate

//MessageBox('',sGetSql)

Return sGetSql
end function

public function integer wf_set_report_text (string ar_col, string ar_text, string ar_x, string ar_y, string ar_h, string ar_w);
dw_insert.Modify(ar_col + "_t.text='" + ar_text + "'")	 		// Column Text ����
dw_insert.Modify(ar_col + "_t.background.color='28144969'")	// Column Text ����
dw_insert.Modify(ar_col + "_t.background.mode='2'")
dw_insert.Modify(ar_col + "_t.color='16777215'")

dw_insert.Modify(ar_col + '_t.font.face="����ü"')
dw_insert.Modify(ar_col + '_t.font.height="-9"')
dw_insert.Modify(ar_col + '_t.font.weight="400"')
dw_insert.Modify(ar_col + '_t.font.family="1"')
dw_insert.Modify(ar_col + '_t.font.pitch="1"')
dw_insert.Modify(ar_col + '_t.font.charset="129"')

dw_insert.Modify(ar_col + "_t.x='" + ar_x + "'")  		// Column x��ǥ�� ���� Text ��ġ ����
dw_insert.Modify(ar_col + "_t.width='" +ar_w + "'")   // Column width�� ���� Text ��ġ ����
If ar_y > '0' Then dw_insert.Modify(ar_col + "_t.y='" + ar_y + "'")  		// Column Text ��ġ ����
If ar_h > '0' Then dw_insert.Modify(ar_col + "_t.height='" +ar_h + "'")


return 0


end function

public function integer wf_set_report_column (string ar_col, integer ar_tab, integer ar_width, string ar_format);//Integer	li_unit_per_char = 210	// unit : 1/ 1000 Cm
Integer	li_unit_per_char = 30   
Integer  iLen
String   sColtype, sLen

dw_insert.Modify(ar_col + ".update='yes'") 								// �÷��� UPDATE
dw_insert.Modify(ar_col + ".background.color='16777215'") 			// �÷��� back color
dw_insert.Modify(ar_col + ".color='33554432'") 							// �÷��� color
dw_insert.Modify(ar_col + ".background.mode='0'") 						// �÷��� back MODE
dw_insert.Modify(ar_col + ".TabSequence='" +string(ar_tab) + "'") // tab Order
dw_insert.Modify(ar_col + ".Update='Yes'")

dw_insert.Modify(ar_col + ".x=" + String(li_last_x))

dw_insert.Modify(ar_col + '.font.face="����ü"')
dw_insert.Modify(ar_col + '.font.height="-9"')
dw_insert.Modify(ar_col + '.font.weight="400"')
dw_insert.Modify(ar_col + '.font.family="1"')
dw_insert.Modify(ar_col + '.font.pitch="1"')
dw_insert.Modify(ar_col + '.font.charset="129"')

If ar_format = 'N' Then
	dw_insert.Modify(ar_col + '.Format="##0.00"')
End If

if ar_width > 0 then
   dw_insert.Modify(ar_col + ".Width =" + String(li_unit_per_char * (ar_width)))
	dw_insert.Modify(ar_col + ".Height =" + String(72))
end if

li_last_x = (li_last_x + (li_unit_per_char * ar_width)) + 7 //�÷����� ���� = 7���μ���

Return 0


end function

on w_adt_02020.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.pb_1=create pb_1
this.cb_plc=create cb_plc
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.cb_plc
this.Control[iCurrent+4]=this.rr_4
end on

on w_adt_02020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.pb_1)
destroy(this.cb_plc)
destroy(this.rr_4)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.InsertRow(0)
dw_cond.SetItem(1, 'sidate', f_today())

isItnbr = gs_code
isEmpno = gs_gubun

// ���̺� ���� ��ȸ��
ds_jobconh = CREATE datastore
ds_jobcond = CREATE datastore
ds_jobconh.DataObject = 'd_adt_02010_2'
ds_jobcond.DataObject = 'd_adt_02010_3'

ds_jobconh.SetTransObject(sqlca)
ds_jobcond.SetTransObject(sqlca)
end event

type dw_insert from w_inherite`dw_insert within w_adt_02020
integer x = 46
integer y = 388
integer width = 4498
integer height = 1896
integer taborder = 130
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;String  sNull, sCol_Name, s_cod, s_nam1, s_nam2
long    lRow
int     i_rtn

If dw_insert.AcceptText() <> 1 Then Return

sCol_Name = This.GetColumnName()
lRow      = this.GetRow()
SetNull(sNull)

Choose Case sCol_Name
	// ��������
   Case "sdate"
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[��������]')
			this.SetItem(lRow, "sdate", sNull)
			return 1
		end if
	// ���۽ð�
   Case "stime"
		if f_TimeChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[���۽ð�]')
			this.SetItem(lRow, "stime", sNull)
			return 1
		end if	
	// ��������
   Case "edate"
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[��������]')
			this.SetItem(lRow, "edate", sNull)
			return 1
		end if	
	// ����ð�
   Case "etime"
		if f_TimeChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[����ð�]')
			this.SetItem(lRow, "etime", sNull)
			return 1
		end if	
	// ǰ��
   Case "itnbr"
		s_cod = Trim(this.GetText())
		i_rtn = f_get_name2("ǰ��", "Y", s_cod, s_nam1, s_nam2)
		this.SetItem(lRow, "itnbr", s_cod)
//		this.SetItem(lRow, "itdsc", s_nam1)
		return i_rtn
//	// ǰ��	
//	CASE "itdsc" 
//		i_rtn = f_get_name2("ǰ��", "Y", s_nam1, s_cod, s_nam2)
//		this.SetItem(lRow, "itnbr", s_cod)
//		this.SetItem(lRow, "itdsc", s_nam1)
//		return i_rtn	
	//�۾���	
	Case "empno" 
		s_cod = Trim(this.GetText())
		i_rtn = f_get_name2("���", "Y", s_cod, s_nam1, s_nam2)
		this.SetItem(lRow, "empno", s_cod)
//		this.SetItem(lRow, "empnm", s_nam1)
		return i_rtn
end Choose


end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;String  sNull, sCol_Name
long    lRow

If dw_insert.AcceptText() <> 1 Then Return

sCol_Name = This.GetColumnName()
lRow      = this.GetRow()
SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case sCol_Name
	// �۾���
   Case "empno"	
  	    open(w_sawon_popup)
	    if gs_code = '' or isnull(gs_code) then return 
		 this.SetItem(lRow,"empno",gs_code)
	    this.TriggerEvent("itemchanged")
	// ǰ��	 
	Case "itnbr"
		 open(w_itemas_popup)
 	    if gs_code = '' or isnull(gs_code) then return 
  	    this.SetItem(lRow,"itnbr",gs_code)
	    this.TriggerEvent("itemchanged")
	// LOT NO
	Case "lotsno"
		 gs_code  = dw_cond.getitemstring(1, 'wkctr')
		 gs_gubun = dw_cond.getitemstring(1, 'jobcode')
		 gs_codename = ''
		 open(w_adt_02020_popup)
 	    if gs_code = '' or isnull(gs_code) then return 
  	    this.SetItem(lRow,"lotsno",gs_code)
  	    this.SetItem(lRow,"itnbr",gs_codename)
	    this.TriggerEvent("itemchanged")
end choose
end event

event dw_insert::retrieveend;call super::retrieveend;dw_insert.setsort("A.LOTSNO , A.SDATE, A.STIME A")
dw_insert.sort()	
end event

type p_delrow from w_inherite`p_delrow within w_adt_02020
integer x = 3922
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;
Int il_currow

il_currow = dw_insert.GetRow()
IF il_currow <=0 Then Return

IF f_msg_delete() = -1 THEN RETURN
	
dw_insert.DeleteRow(il_currow)
//ib_any_typing =True
IF dw_insert.Update() > 0 THEN
	commit;
	IF il_currow = 1 OR il_currow <= dw_insert.RowCount() THEN
	ELSE
		dw_insert.ScrollToRow(il_currow - 1)
		dw_insert.SetColumn(1)
		dw_insert.SetFocus()
	END IF
		
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_addrow from w_inherite`p_addrow within w_adt_02020
integer x = 3749
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;Long nRow
String sSidat, sWkctr, sSilJpno, sNull
int    ino

SetNull(sNull)

If ib_ret = False Then Return 	// �۾����ǳ����� �����ȵȰ��� skip

If dw_cond.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sSidat	= Trim(dw_cond.GetItemString(1, 'sidate'))
sWkctr	= Trim(dw_cond.GetItemString(1, 'wkctr'))
If f_datechk(sSidat) <> 1 Then
	f_message_chk(1400,'[�������]')
	Return
End If
If IsNull(sWkctr) Or sWkctr = '' Then
	f_message_chk(1400,'[�۾���]')
	Return
End If

nRow = dw_insert.InsertRow(0)

ino = sqlca.fun_junpyo(gs_sabu,sSidat,'Y')
IF ino <= 0 THEN
	ROLLBACK;
	f_message_chk(51,'')
	SetNull(sSilJpno)
END IF

sSilJpno = sSidat + String(ino,'00000')
Commit;

dw_insert.SetItem(nRow, 'siljpno', sSilJpno)
dw_insert.SetItem(nRow, 'sidate', sSidat)
dw_insert.SetItem(nRow, 'wkctr',  sWkctr)

If ds_jobconh.GetItemString(1, 'lotsno') = 'Y' Then	dw_insert.SetItem(nRow, 'lotsno', sNull)
If ds_jobconh.GetItemString(1, 'sdate') = 'Y' Then	dw_insert.SetItem(nRow, 'sdate', sSidat)
If ds_jobconh.GetItemString(1, 'edate') = 'Y' Then	dw_insert.SetItem(nRow, 'edate', sSidat)
If ds_jobconh.GetItemString(1, 'stime') = 'Y' Then	dw_insert.SetItem(nRow, 'stime', sNull)
If ds_jobconh.GetItemString(1, 'etime') = 'Y' Then	dw_insert.SetItem(nRow, 'etime', sNull)

If Not IsNull(isItnbr) Then
	dw_insert.SetItem(nRow, 'itnbr', isItnbr)
	dw_insert.SetItem(nRow, 'empno', isEmpNo)
	SetNull(isItnbr)
	SetNull(isEmpno)
End If

If dw_insert.Update() <> 1 Then
	RollBack;
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	ib_any_typing =True
	Return
End If

COMMIT;
ib_any_typing =False

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn(1)
dw_insert.SetFocus()

end event

type p_search from w_inherite`p_search within w_adt_02020
integer x = 2505
integer y = 200
integer width = 306
integer taborder = 110
boolean originalsize = true
string picturename = "C:\erpman\image\row����_up.gif"
end type

event p_search::clicked;call super::clicked;Long nRow, llRow
String sSidat, sWkctr, sSilJpno, snull
int    ino

If ib_ret = False Then Return 	// �۾����ǳ����� �����ȵȰ��� skip

SetNull(sNull)

If dw_cond.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

sSidat	= Trim(dw_cond.GetItemString(1, 'sidate'))
sWkctr	= Trim(dw_cond.GetItemString(1, 'wkctr'))
If f_datechk(sSidat) <> 1 Then
	f_message_chk(1400,'[�������]')
	Return
End If
If IsNull(sWkctr) Or sWkctr = '' Then
	f_message_chk(1400,'[�۾���]')
	Return
End If

llRow = dw_insert.RowCount()

If llRow <= 0 Then Return

nRow = dw_insert.RowsCopy(llRow,  llRow, Primary!, dw_insert, llRow, Primary!)

ino = sqlca.fun_junpyo(gs_sabu,sSidat,'Y')
IF ino <= 0 THEN
	ROLLBACK;
	f_message_chk(51,'')
	SetNull(sSilJpno)
END IF

sSilJpno = sSidat + String(ino,'00000')
Commit;

dw_insert.SetItem(nRow, 'siljpno', sSilJpno)
dw_insert.SetItem(nRow, 'sidate', sSidat)
dw_insert.SetItem(nRow, 'wkctr',  sWkctr)

If ds_jobconh.GetItemString(1, 'lotsno') = 'Y' Then	dw_insert.SetItem(nRow, 'lotsno', sNull)
If ds_jobconh.GetItemString(1, 'sdate') = 'Y' Then	dw_insert.SetItem(nRow, 'sdate', sSidat)
If ds_jobconh.GetItemString(1, 'edate') = 'Y' Then	dw_insert.SetItem(nRow, 'edate', sSidat)
If ds_jobconh.GetItemString(1, 'stime') = 'Y' Then	dw_insert.SetItem(nRow, 'stime', sNull)
If ds_jobconh.GetItemString(1, 'etime') = 'Y' Then	dw_insert.SetItem(nRow, 'etime', sNull)

dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn(1)
dw_insert.SetFocus()
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\row����_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\row����_up.gif"
end event

type p_ins from w_inherite`p_ins within w_adt_02020
boolean visible = false
integer y = 180
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;dw_insert.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_adt_02020
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_adt_02020
integer taborder = 90
end type

event p_can::clicked;call super::clicked;String sNull

SetNull(sNull)

ib_ret = False

dw_cond.setitem(1, "jobcode", snull)
dw_cond.setitem(1, "jobnm", snull)
dw_cond.setitem(1, "wkctr", snull)
dw_cond.setitem(1, "wcdsc", snull)

dw_insert.Reset()

w_mdi_frame.sle_msg.text =""
end event

type p_print from w_inherite`p_print within w_adt_02020
boolean visible = false
integer y = 180
integer taborder = 120
end type

type p_inq from w_inherite`p_inq within w_adt_02020
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String sJobcode, sSidat, sSetSql, sPlctbl

If dw_cond.AcceptText() <> 1 Then Return

//x ��ǥ �� �ʱ�ȭ
li_last_x = 0
dw_insert.reset()

sJobcode = Trim(dw_cond.GetItemString(1, 'jobcode'))
sSidat   = Trim(dw_cond.GetItemString(1, 'sidate'))

If IsNull(sJobcode) Or sJobcode = '' Then
	f_message_chk(1400,'[�۾�����]')
	dw_cond.SetFocus()
	dw_cond.SetColumn('jobcode')
	Return
End If

If IsNull(sSidat) Or sSidat = '' Then
	f_message_chk(1400,'[�������]')
	dw_cond.SetFocus()
	dw_cond.SetColumn('sidate')
	Return
End If

dw_insert.SetRedraw(False)

// �ű��� ��� ����Ʈ ����� �����Ѵ�.
If ib_ret = False Then
	// ���̺��� ��ȸ
	If ds_jobconh.Retrieve(sJobcode) <= 0 Then
		MessageBox('Ȯ ��','�۾����� ������ Ȯ���� �� �����ϴ�.!!')
		dw_insert.SetRedraw(True)
		Return
	End If
	
	If ds_jobcond.Retrieve(sJobcode) <= 0 Then
		MessageBox('Ȯ ��','�۾����� �󼼳����� Ȯ���� �� �����ϴ�.!!')
		dw_insert.SetRedraw(True)
		Return
	End If

	sPlctbl = Trim(ds_jobconh.GetItemString(1, 'plctbl'))
	If IsNull(sPlctbl) Or sPlctbl = '' then
		cb_plc.Visible = False
	Else
		cb_plc.Visible = True
	End If
	dw_cond.SetItem(1, 'plctbl', splctbl)
	
	wf_create_report(sJobCode)
	
	ib_ret = True
Else
	// ������ ��ȸ�� ��쿡�� ������ڸ� �����Ѵ�.
	sSetSql = sOrginalSql + " WHERE A.SIDATE = " + sSidat
	dw_insert.SetSQLSelect(sSetSql)
	dw_insert.Retrieve()
End If

// ����
dw_insert.setsort("A.SDATE, A.STIME A, A.LOTSNO A")
dw_insert.sort()
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_adt_02020
boolean visible = false
integer y = 188
integer taborder = 80
end type

type p_mod from w_inherite`p_mod within w_adt_02020
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;String sjobcode, ssdate, sstime, sedate, setime, slotsno, sitnbr, sempno, suseyn, &
       ls_sdate, ls_stime, ls_edate, ls_etime, ls_lotsno, ls_itnbr, ls_empno 
long   i

If dw_insert.accepttext()   <> 1 then Return
If dw_cond.accepttext()   <> 1 then Return

IF F_Msg_Update() = -1 THEN Return

sjobcode = Trim(dw_cond.GetItemString(1,'jobcode'))

//�ʼ��Է��׸� �Է� üũ
select sdate, stime, edate, etime, lotsno, itnbr, empno, useyn 
  into :ssdate, :sstime, :sedate, :setime, :slotsno, :sitnbr, :sempno, :suseyn 
  from jobconh 
 where jobcode = :sjobcode; 
 
if sqlca.sqlcode <> 0 then
   Messagebox("Ȯ��", "�ʼ��Է� �׸��� �������� ����", stopsign!)
   return 1
end if	

//if suseyn = 'Y' then
//   for i = 1 to dw_insert.rowcount()
//       //��������
//		 if ssdate = 'Y' then
//			 ls_sdate  = dw_insert.getitemstring(i,'sdate')
//			 if ls_sdate = '' or isnull(ls_sdate) then
//				 MessageBox('Ȯ��', string(i) + ' �� �Է¶��ο� �������� �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('sdate')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//		 
//		 //���۽ð�
//		 if sstime = 'Y' then
//			 ls_stime  = dw_insert.getitemstring(i,'stime')
//			 if ls_stime = '' or isnull(ls_stime) then
//				 MessageBox('Ȯ��', string(i) + ' �� �Է¶��ο� ���۽ð� �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('stime')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//		 
//		 //��������
//		 if sedate = 'Y' then
//			 ls_edate  = dw_insert.getitemstring(i,'edate')
//			 if ls_edate = '' or isnull(ls_edate) then
//				 MessageBox('Ȯ��', string(i) + ' �� �Է¶��ο� �������� �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('edate')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//		 
//		 //����ð�
//		 if setime = 'Y' then
//		    ls_etime  = dw_insert.getitemstring(i,'etime')
//			 if ls_etime = '' or isnull(ls_etime) then
//				 MessageBox('Ȯ��', string(i)+ ' �� �Է¶��ο� ����ð� �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('etime')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//		 
//		 //LOT ��ȣ
//		 if slotsno = 'Y' then
//			 ls_lotsno = dw_insert.getitemstring(i,'lotsno')
//			 if ls_lotsno = '' or isnull(ls_lotsno) then
//				 MessageBox('Ȯ��', string(i) + ' �� �Է¶��ο� LOT ��ȣ �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('lotsno')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//		 
//		 //ǰ��
//		 if sitnbr = 'Y' then
//			 ls_itnbr  = dw_insert.getitemstring(i,'itnbr')
//			 if ls_itnbr = '' or isnull(ls_itnbr) then
//				 MessageBox('Ȯ��', string(i) + ' �� �Է¶��ο� ǰ�� �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('itnbr')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//		 
//		 //�۾���
//		 if sempno = 'Y' then
//			 ls_empno  = dw_insert.getitemstring(i,'empno')
//			 if ls_empno = '' or isnull(ls_empno) then
//				 MessageBox('Ȯ��', string(i) + ' �� �Է¶��ο� �۾��� �׸��� �Է��ϼ���')
//				 dw_insert.setcolumn('empno')
//				 dw_insert.setfocus()
//				 return 1
//			 end if	
//		 end if	
//   next
//end if	
 
If dw_insert.Update() <> 1 Then
	RollBack;
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	ib_any_typing =True
	Return
End If

COMMIT;
ib_any_typing =False
p_inq.triggerevent('clicked')

w_mdi_frame.sle_msg.text ="�ڷḦ �����Ͽ����ϴ�!!"
end event

type cb_exit from w_inherite`cb_exit within w_adt_02020
end type

type cb_mod from w_inherite`cb_mod within w_adt_02020
end type

type cb_ins from w_inherite`cb_ins within w_adt_02020
end type

type cb_del from w_inherite`cb_del within w_adt_02020
end type

type cb_inq from w_inherite`cb_inq within w_adt_02020
end type

type cb_print from w_inherite`cb_print within w_adt_02020
end type

type st_1 from w_inherite`st_1 within w_adt_02020
end type

type cb_can from w_inherite`cb_can within w_adt_02020
end type

type cb_search from w_inherite`cb_search within w_adt_02020
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_02020
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_02020
end type

type dw_cond from u_key_enter within w_adt_02020
integer x = 23
integer y = 128
integer width = 2432
integer height = 232
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_adt_02020_1"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

Choose case GetColumnName()
	Case "jobcode"
		//x ��ǥ �� �ʱ�ȭ
   	li_last_x = 0
		
		SetNull(gs_code)
		open(w_adt_jobconh)
		if isnull(gs_code) or gs_code = "" then return
		this.setitem(1, "jobcode", gs_code)
		this.setitem(1, "jobnm", gs_codename)
		this.setitem(1, "wkctr", gs_gubun)
		this.setitem(1, "wcdsc", gs_codename2)
		ib_ret = False		// �۾������ڵ� ����� ���
		
		p_inq.triggerevent(itemchanged!)
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String sCode, sNull, sjobnm, swkctr, suseyn

Setnull(sNull)

if this.getcolumnname() = 'jobcode' then
	//x ��ǥ �� �ʱ�ȭ
	li_last_x = 0
	
   sCode = trim(this.gettext())
	
	if sCode = '' or isnull(sCode) then return 
	
	SELECT A.JOBNM, A.WKCTR, A.USEYN INTO :sjobnm, :swkctr, :suseyn
	  FROM JOBCONH A, WRKCTR B
	 WHERE A.JOBCODE = :sCode AND A.WKCTR = B.WKCTR;

	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[�۾����� �ڵ�]')
		this.setitem(1, "jobnm", snull)
		this.setitem(1, "wkctr", snull)
		this.setitem(1, "wcdsc", snull)
		return  1
	end if
	
	this.setitem(1, "jobnm", sjobnm)
	this.setitem(1, "wkctr", swkctr)
	this.setitem(1, "wcdsc", suseyn)
	ib_ret = False		// �۾������ڵ� ����� ���
	
	p_inq.triggerevent(itemchanged!)
End If
end event

type pb_1 from u_pb_cal within w_adt_02020
integer x = 759
integer y = 244
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_cond.SetColumn('sidate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_cond.SetItem(1, 'sidate', gs_code)

end event

type cb_plc from commandbutton within w_adt_02020
boolean visible = false
integer x = 3913
integer y = 256
integer width = 640
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "PLC DATA ��������"
end type

event clicked;string sjobcode, splctbl, ssiljpno, sfrtime, sDate, stime
int    irtn, nRow

If dw_cond.AcceptText() <> 1 Then Return

If dw_insert.RowCount() <= 0 Then Return

nRow = dw_insert.GetRow()
If nRow <= 0 Then Return

sDate = dw_insert.getitemstring(nrow, 'sdate')
stime = dw_insert.getitemstring(nrow, 'stime')
If IsNull(sDate) Or Trim(sDate) = '' Then
	f_message_chk(1400,'���ڸ� �Է��ϼ���!!')
	Return
End If

If IsNull(stime) Or Trim(stime) = '' Then
	f_message_chk(1400,'�ð��� �Է��ϼ���!!')
	Return
End If

sjobcode	= dw_cond.GetItemString(1, 'jobcode')
splctbl	= dw_cond.GetItemString(1, 'plctbl')
sfrtime  = sdate+stime
ssiljpno = dw_insert.GetItemString(nRow, 'siljpno')

// ��������
If dw_insert.Update() <> 1 Then
	RollBack;
	MESSAGEBOX(STRING(SQLCA.SQLCODE),SQLCA.SQLERRTEXT)
	ib_any_typing =True
	Return
End If

COMMIT;

// PLC ���� ��������
//���ν��� ����
DECLARE adtplc_to_erp procedure for adtplc_to_erp(:sjobcode, :splctbl, :ssiljpno, :sfrtime) ;

irtn = 0
Execute adtplc_to_erp;
//MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
FETCH adtplc_to_erp INTO :irtn;

Choose Case irtn
	Case  0
		COMMIT;
		p_inq.TriggerEvent(Clicked!)
	Case -1
		ROLLBACK;
		MessageBox('Ȯ��','������ �����ϴ�.!!')
	Case -2
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		ROLLBACK;
	Case Else
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		ROLLBACK;
End Choose

COMMIT;

close adtplc_to_erp ;
end event

type rr_4 from roundrectangle within w_adt_02020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 368
integer width = 4590
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

