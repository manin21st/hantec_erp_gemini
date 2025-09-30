$PBExportHeader$w_sal_05780.srw
$PBExportComments$���� ��� ��ǰ�� �ǸŽ��� ��Ȳ
forward
global type w_sal_05780 from w_standard_dw_graph
end type
type dw_view from datawindow within w_sal_05780
end type
end forward

global type w_sal_05780 from w_standard_dw_graph
string title = "���� ��� ��ǰ�� �ǸŽ��� ��Ȳ"
dw_view dw_view
end type
global w_sal_05780 w_sal_05780

forward prototypes
public function string wf_catch_bungi (string sfrom)
public function integer wf_retrieve ()
public function integer wf_setting_datawindow (string sdatef, string sdatet, string sgubun, string stitle, string steamcd, string sarea)
end prototypes

public function string wf_catch_bungi (string sfrom);String sMsg

Choose Case Right(sFrom,2)
	Case '01'
		sMsg  = Left(sFrom,4) + '�� 1�б�'
	Case '04'
		sMsg  = Left(sFrom,4) + '�� 2�б�'
	Case '07'
		sMsg  = Left(sFrom,4) + '�� 3�б�'
	Case '10'
		sMsg  = Left(sFrom,4) + '�� 4�б�'
End Choose
	
Return sMsg
end function

public function integer wf_retrieve ();String sdatef, sDatet, sBunGi, sPrtGbn, sFrom, sTo, steamcd, sarea, sChk, tx_name
Long   ix, nRow

If dw_ip.AcceptText() <> 1 Then Return -1

sdatet   = Trim(dw_ip.GetItemString(1,'sym'))
sBunGi   = Trim(dw_ip.GetItemString(1,'bungi'))
sPrtGbn  = Trim(dw_ip.GetItemString(1,'prtgbn'))
sChk     = Trim(dw_ip.GetItemString(1,'chk'))
sTeamcd  = Trim(dw_ip.GetItemString(1,'deptcode'))
sarea    = Trim(dw_ip.GetItemString(1,'areacode'))

If	sPrtGbn = '1' and f_datechk(sDatet+'01') <> 1 then
	f_Message_Chk(35, '[���س��]')
	dw_ip.setcolumn('sym')
	dw_ip.setfocus()
	Return -1
End if

If sPrtGbn = '2' and IsNull(sBungi) Then 
	f_Message_Chk(35, '[���غб�]')
	dw_ip.setcolumn('bungi')
	dw_ip.setfocus()
	Return -1
End if

If sChk = '2' Then
	If sTeamcd = '' Or IsNull(sTeamcd) Then 
		f_Message_Chk(1400, '[������]')
		dw_ip.setcolumn('deptcode')
		dw_ip.setfocus()
		Return -1
	End if	
End If

If sChk = '3' Then
	If sarea = '' Or IsNull(sarea) Then 
		f_Message_Chk(1400, '[���ұ���]')
		dw_ip.setcolumn('areacode')
		dw_ip.setfocus()
		Return -1
	End if	
End If

If IsNull(sTeamcd) Then sTeamcd = ''
sTeamCd += '%'

If IsNull(sarea) Then sarea = ''
sarea += '%'

dw_list.SetRedraw(False)
dw_list.Reset()

/* ������� */
If sPrtGbn = '1' Then
	/* ��3���� ���� �ݾ� */
	wf_setting_datawindow(f_aftermonth(sDatet,-3), f_aftermonth(sDatet,-1), '1','3���� ���', steamcd, sarea)
	
	/* ���� ���� �ݾ� */
	sDatef = f_aftermonth(sDatet,-1)
	wf_setting_datawindow(sDatef, sDatef, '2','���� ����', steamcd, sarea)
	
	/* ��� ���� �ݾ� */
	wf_setting_datawindow(sDatet, sDatet, '3','��� ����', steamcd, sarea)
	
	dw_list.Object.txt_sdate.text = String(sDatet,'@@@@.@@')
/* ���б��� or ���� ���б� ��� */
Else
	Choose Case sBungi
		Case '1'
			sDatef = Left(sDatet,4) + '01'
			sDatet = Left(sDatet,4) + '03'
		Case '2'
			sDatef = Left(sDatet,4) + '04'
			sDatet = Left(sDatet,4) + '06'
		Case '3'
			sDatef = Left(sDatet,4) + '07'
			sDatet = Left(sDatet,4) + '09'
		Case '4'
			sDatef = Left(sDatet,4) + '10'
			sDatet = Left(sDatet,4) + '12'
	End Choose

	/* ���б� ��� */
	If sPrtGbn = '2' Then
		/* �����б� ���� �ݾ� */
		sFrom = f_aftermonth(sDatef,-6)
		sTo   = f_aftermonth(sDatef,-4)
		wf_setting_datawindow(sFrom, sTo, '4', wf_catch_bungi(sFrom), steamcd, sarea)
		
		/* ���б� ���� �ݾ� */
		sFrom = f_aftermonth(sDatef,-3)
		sTo   = f_aftermonth(sDatef,-1)
		wf_setting_datawindow(sFrom, sTo, '5', wf_catch_bungi(sFrom), steamcd, sarea)
		
		/* ��� ���� �ݾ� */
		wf_setting_datawindow(sDatef, sDatet, '6',wf_catch_bungi(sDatef), steamcd, sarea)
	/* ���� ���б� ��� */
	Else		
		/* ���б� ���� �ݾ� */
		sFrom = f_aftermonth(sDatef, -12)
		sTo   = f_aftermonth(sDatef, -12)
		wf_setting_datawindow(sFrom, sTo, '5', wf_catch_bungi(sFrom), steamcd, sarea)
		
		/* ��� ���� �ݾ� */
		wf_setting_datawindow(sDatef, sDatet, '6',wf_catch_bungi(sDatef), steamcd, sarea)
	End If
	
	dw_list.Object.txt_sdate.text = wf_catch_bungi(sDatef)
End If

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '��ü'
dw_list.Modify("txt_sarea.text = '"+tx_name+"'")


dw_list.SetRedraw(True)

return 1
end function

public function integer wf_setting_datawindow (string sdatef, string sdatet, string sgubun, string stitle, string steamcd, string sarea);Long nRow , ix, iy, row
Double dQty, dAmt

/* N-UP �� ���� */
Int  nNupCnt = 14
Int  nAvg

/* ������ 1�̸� 3���� ������� ���Ѵ� */
If sGubun = '1' Then
	nAvg = 3
Else
	nAvg = 1
End If

/* ���� �ݾ� ��ȸ*/

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

nRow = dw_view.Retrieve(gs_sabu, sdatef, sdatet, steamcd,sarea,ls_silgu)
If nRow <= 0 Then Return -1

/* �ߺз��� N-up�� �̻��̸� �ڸ��� */
If nRow >= nNupCnt Then
	iy = nNupCnt
Else
	iy = nRow
End If

For ix = 1 To iy - 1
	row = dw_list.InsertRow(0)	
	
	dw_list.SetItem(row,'gubun',sGubun)
	dw_list.SetItem(row,'title',sTitle)
	dw_list.SetItem(row,'titnm',dw_view.GetItemString(ix,'titnm'))
	dw_list.SetItem(row,'sales_qty',dw_view.GetItemNumber(ix,'sales_qty')/nAvg)
	dw_list.SetItem(row,'sales_amt',dw_view.GetItemNumber(ix,'sales_amt')/1000/nAvg)
Next

/* ������ row�� [��Ÿ]�� N-Up�� �̻� ������ �����Ѵ� */
For ix = iy To nRow
	dQty += dw_view.GetItemNumber(ix,'sales_qty')
	dAmt += dw_view.GetItemNumber(ix,'sales_amt')
Next

row = dw_list.InsertRow(0)	
dw_list.SetItem(row,'gubun',sGubun)
dw_list.SetItem(row,'title',sTitle)
dw_list.SetItem(row,'titnm',    dw_view.GetItemString(nRow,'titnm'))
dw_list.SetItem(row,'sales_qty',dQty/nAvg)
dw_list.SetItem(row,'sales_amt',dAmt/1000/nAvg)

/* N-up�� ���ڶ�� ����ŭ Insert�Ѵ� */
If nRow < nNupCnt Then
	For ix = 1 To nNupCnt - nRow
		dw_list.InsertRow(0)
	Next
End If

Return 0

end function

on w_sal_05780.create
int iCurrent
call super::create
this.dw_view=create dw_view
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_view
end on

on w_sal_05780.destroy
call super::destroy
destroy(this.dw_view)
end on

event open;call super::open;dw_view.SetTransObject(sqlca)

sle_msg.text = "��������� �Է��ϰ� ��ȸ������ ��������"
dw_ip.setitem(1,'sym',left(f_today(),6))
end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05780
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05780
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05780
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05780
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05780
integer x = 1947
integer y = 2372
integer height = 72
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05780
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05780
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05780
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05780
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05780
integer x = 14
integer y = 20
integer width = 3803
integer height = 184
string dataobject = "d_sal_057801"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sNull, siocustarea,sDept

SetNull(sNull)

Choose Case GetColumnName()
	/* ������ */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
	/* ���ұ��� */
	Case "areacode"
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		 FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
		SetItem(1,'deptcode',sDept)
	/* ���౸�� */
	Case 'prtgbn'
		dw_list.SetRedraw(False)
		If Trim(GetText()) = '1' Then 
			dw_list.DataObject = 'd_sal_05780'
		ElseIf Trim(GetText()) = '2' Then 
			dw_list.DataObject = 'd_sal_057802'
		Else
			dw_list.DataObject = 'd_sal_057803'
		End If
		dw_list.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
	/* �ڷᱸ�� */
	Case 'chk'
		If Trim(GetText()) = '1' Then 
			SetItem(1,'deptcode',sNull)
			SetItem(1,'areacode',sNull)
		End If
End Choose
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05780
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05780
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05780
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05780
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05780
string dataobject = "d_sal_05780"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05780
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05780
end type

type dw_view from datawindow within w_sal_05780
boolean visible = false
integer x = 137
integer y = 2372
integer width = 1499
integer height = 360
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_05780_02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

