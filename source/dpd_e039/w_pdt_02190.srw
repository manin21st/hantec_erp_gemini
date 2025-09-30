$PBExportHeader$w_pdt_02190.srw
$PBExportComments$** �۾������� �񰡵����� ���
forward
global type w_pdt_02190 from w_inherite
end type
type dw_ip from u_key_enter within w_pdt_02190
end type
type rr_1 from roundrectangle within w_pdt_02190
end type
end forward

global type w_pdt_02190 from w_inherite
integer width = 3122
integer height = 2308
string title = "�۾������� �񰡵����� ���"
boolean resizable = true
dw_ip dw_ip
rr_1 rr_1
end type
global w_pdt_02190 w_pdt_02190

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//�ʼ��Է��׸� üũ
Long   i, j, k, nMax
String cod, sCidat

if dw_insert.AcceptText() = -1 then return -1

sCidat = dw_ip.GetItemString(1, 'sidat')

for i = 1 to dw_insert.RowCount()
	
	cod = Trim(dw_insert.object.ntcod[i])
	if	IsNull(cod) or cod = "" then
		f_message_chk(30, "[�񰡵�����]")
     	dw_insert.SetRow(i)		
		return -1
	end if
	
	j = i + 1
	k = dw_insert.Find("ntcod = '" + cod + "'", j, dw_insert.RowCount())
	
//	if k >= 1 and k <> i then
//		MessageBox("�񰡵����� �ߺ�", "�񰡵������� �ߺ����� �ԷµǾ����ϴ�!")
//		dw_insert.SetRow(i)	
//		return -1
//	end if
	
	if	IsNull(dw_insert.object.ntime[i]) then
		f_message_chk(30, "[�񰡵��ð�]")
     	dw_insert.SetRow(i)		
		return -1
	end if
	
	if	IsNull(Trim(dw_insert.object.dptno[i])) or Trim(dw_insert.object.dptno[i]) = "" then
		f_message_chk(30, "[�������� �ŷ�ó/�μ�]")
     	dw_insert.SetRow(i)		
		return -1
	end if
	
	dw_insert.SetItem(i, "sloss", dw_insert.object.ntime[i] * dw_insert.object.sinwon[i])
next

dw_insert.AcceptText()

select max(ntseq) into :nmax from nttabl where sabu = :gs_sabu and ntdat = :scidat;
If IsNull(nmax) Then nMax = 0

For i = 1 to dw_insert.RowCount()
	If dw_insert.GetItemNumber(i, 'ntseq') = 0 Then
		nMax = nMax + 1
		dw_insert.SetItem(i, 'ntseq', nmax)
	End If
Next

return 1
end function

on w_pdt_02190.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_02190.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)

dw_ip.SetRedraw(False)
dw_ip.ReSet()
dw_ip.InsertRow(0)
if	dw_ip.retrieve(gs_sabu, gs_code) > 0 then
	cb_inq.triggerevent(clicked!)
	this.y = 0
	this.x = 0
else
	dw_ip.ReSet()
	dw_ip.InsertRow(0)
end if

dw_ip.SetRedraw(True)

end event

event close;Setnull(gs_code)
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02190
integer x = 37
integer y = 600
integer width = 2985
integer height = 1484
integer taborder = 30
string dataobject = "d_pdt_02190_02"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col,  s_cod, sname1, sname2
Integer i_rtn
Long crow

this.AcceptText()
ib_any_typing = True //�Է��ʵ� ���濩�� Yes
crow = this.GetRow()
s_cod = Trim(this.getText()) 

Choose Case 	this.GetColumnName()
	Case "dptno"	
		i_rtn 	= f_get_name2('V0', 'Y', s_cod, sname1, sname2)    //1�̸� ����, 0�� ����	
		this.object.dptno[crow] 	= s_cod
		this.object.dptnm[crow] 	= sname1
		return i_rtn
	Case "sdptno"		
		i_rtn 	= f_get_name2('V0', 'Y', s_cod, sname1, sname2)    //1�̸� ����, 0�� ����	
		this.SetItem(crow, "sdptno" , s_cod)
		this.SetItem(crow, "sdptnm", sname1)
		return i_rtn
end Choose

end event

event dw_insert::rbuttondown;Long i

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
i = this.GetRow()

Choose   Case this.getcolumnname()
	Case 	"dptno"
   		gs_gubun = '1'   
		gi_page = -1 
		Open(w_vndmst_popup)
		gi_page = 0 
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		SetItem(i, "dptno", gs_Code)
		this.TriggerEvent(ItemChanged!)
	Case 	"sdptno"
		Open(w_vndmst_4_popup)
		SetItem(i,'sdptno',gs_code)
		SetItem(i,'sdptnm',gs_codename)
		this.triggerevent(itemchanged!)
		
End Choose


return
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if this.RowCount() >= 1 then
	p_mod.Enabled = True
	p_del.Enabled = True
	
	p_mod.PictureName = "C:\erpman\image\����_up.gif"
	p_del.PictureName = "C:\erpman\image\����_up.gif"
else
	p_mod.Enabled = False
	p_del.Enabled = False
	
	p_mod.PictureName = "C:\erpman\image\����_d.gif"
	p_del.PictureName = "C:\erpman\image\����_d.gif"
end if	
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02190
boolean visible = false
integer x = 3753
integer y = 956
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02190
boolean visible = false
integer x = 3579
integer y = 956
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_02190
boolean visible = false
integer x = 3387
integer y = 1600
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02190
integer x = 2167
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_insert.InsertRow(0)
end if

dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.object.sabu[crow] 		= gs_sabu
dw_insert.object.ntdat[crow] 		= dw_ip.object.sidat[1]
dw_insert.object.jocod[crow] 		= dw_ip.object.jocod[1]
dw_insert.object.wkctr[crow] 		= dw_ip.object.wkctr[1]
dw_insert.object.shpjpno[crow] 	= dw_ip.object.shpjpno[1]
dw_insert.SetItem(crow,"sinwon", dw_ip.GetItemDecimal(1,"shpact_inwon")) 

dw_insert.SetColumn("ntcod")
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_pdt_02190
integer x = 2862
end type

type p_can from w_inherite`p_can within w_pdt_02190
integer x = 2688
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("���") = -1 THEN RETURN //����� �ڷ� üũ 

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.enabled = true
dw_ip.SetRedraw(True)
dw_ip.SetFocus()

w_mdi_frame.sle_msg.Text = "���� ���� ���� �۾��� ��� �Ͽ����ϴ�!"
ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type p_print from w_inherite`p_print within w_pdt_02190
boolean visible = false
integer x = 3561
integer y = 1600
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02190
integer x = 1993
end type

event p_inq::clicked;call super::clicked;String jpno, ntdat, jocod
Long crow

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.SetRedraw(True)
	
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return
end if	

jpno = dw_ip.object.shpjpno[1]
if (IsNull(jpno) or jpno = "")  then 
	f_message_chk(30, "[�۾�������ȣ]")
	dw_ip.SetColumn("shpjpno")
	dw_ip.SetFocus()
	return
end if

if dw_ip.Retrieve(gs_sabu, jpno) < 1 then
	dw_ip.SetReDraw(False)
	dw_ip.ReSet()
	dw_ip.InsertRow(0)
	dw_ip.SetReDraw(True)
	f_message_chk(50, "[�۾�������ȣ]")
	return
end if	

dw_ip.enabled = false

ntdat = dw_ip.object.sidat[1]
jocod = dw_ip.object.jocod[1]

crow = dw_insert.Retrieve(gs_sabu, ntdat, jocod, jpno)
if crow < 1 then
	w_mdi_frame.sle_msg.text = "�߰���ư�� ������ �ڷḦ �߰� �� �� �ֽ��ϴ�."
end if	

end event

type p_del from w_inherite`p_del within w_pdt_02190
integer x = 2514
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_del::clicked;call super::clicked;long   lcRow

lcRow = dw_insert.GetRow()
if lcRow < 1 then return

if f_msg_delete() = -1 then return
dw_insert.DeleteRow(lcRow)

w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�! �����ư�� CLICK �Ͽ� �ڷḦ �����ϼ���!"
ib_any_typing = True
end event

type p_mod from w_inherite`p_mod within w_pdt_02190
integer x = 2341
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_mod::clicked;call super::clicked;Real   tot_amt, rNtime
String jpno, sShpJpno

if f_msg_update() = -1 then return  //���� Yes/No ?
if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ 

if dw_insert.Update() <> 1 then
	ROLLBACK;
	f_message_chk(32,'[�۾������� �񰡵����� ���]') 
	sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
end if

/* �۾������� �񰡵��ð� UPDATE */
sShpJpno = Trim(dw_ip.GetItemString(1,'shpjpno'))

If dw_insert.RowCount() > 0 Then
	rNtime = dw_insert.GetItemNumber(1,'sum_ntime')
	If IsNull(rntime) Then rntime = 0
Else
	rNtime = 0
End If

UPDATE SHPACT
	SET NTIME = :rNtime
 WHERE SABU = :gs_sabu AND
		 SHPJPNO = :sShpjpno;

If Sqlca.sqlcode <> 0 Then
	ROLLBACK;
	f_message_chk(32,'[�۾������� �񰡵��ð� ���]') 
	sle_msg.text = "�����۾� ���� �Ͽ����ϴ�!"
	return 
End if

COMMIT;

w_mdi_frame.sle_msg.text = "���� �Ǿ����ϴ�!"

p_inq.TriggerEvent(Clicked!)

ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type cb_exit from w_inherite`cb_exit within w_pdt_02190
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02190
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02190
end type

type cb_del from w_inherite`cb_del within w_pdt_02190
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02190
end type

type cb_print from w_inherite`cb_print within w_pdt_02190
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_pdt_02190
end type

type cb_can from w_inherite`cb_can within w_pdt_02190
end type

type cb_search from w_inherite`cb_search within w_pdt_02190
integer x = 1371
integer y = 2348
end type





type gb_10 from w_inherite`gb_10 within w_pdt_02190
integer x = 32
integer y = 2284
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02190
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02190
end type

type dw_ip from u_key_enter within w_pdt_02190
event ue_key pbm_dwnkey
integer x = 23
integer y = 188
integer width = 3026
integer height = 376
integer taborder = 10
string dataobject = "d_pdt_02190_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "shpjpno" then 
	open(w_shpact_popup)
   this.object.shpjpno[1] = gs_code
	if IsNull(gs_code) or gs_code = "" then
	   this.SetFocus()	
   else
	   p_inq.TriggerEvent(Clicked!)
   end if	
end if	
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "shpjpno" then
	if IsNull(s_cod) or s_cod = "" then return 1
	P_inq.TriggerEvent(Clicked!)
end if
end event

type rr_1 from roundrectangle within w_pdt_02190
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 588
integer width = 3017
integer height = 1508
integer cornerheight = 40
integer cornerwidth = 55
end type

