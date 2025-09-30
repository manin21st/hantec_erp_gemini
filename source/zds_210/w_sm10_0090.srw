$PBExportHeader$w_sm10_0090.srw
forward
global type w_sm10_0090 from w_inherite
end type
type p_excel_upload from uo_picture within w_sm10_0090
end type
type dw_1 from datawindow within w_sm10_0090
end type
type pb_2 from u_pb_cal within w_sm10_0090
end type
type pb_1 from u_pb_cal within w_sm10_0090
end type
type rr_1 from roundrectangle within w_sm10_0090
end type
end forward

global type w_sm10_0090 from w_inherite
string title = "�ְ� ��ȹ ���ε� ���"
p_excel_upload p_excel_upload
dw_1 dw_1
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_sm10_0090 w_sm10_0090

type variables
uo_xlobject uo_xl

string is_cur_directory
end variables

on w_sm10_0090.create
int iCurrent
call super::create
this.p_excel_upload=create p_excel_upload
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_excel_upload
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_sm10_0090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_excel_upload)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)

dw_1.SetItem(1, "sdate", f_today())
dw_1.SetItem(1, "edate", f_today())

is_cur_directory = GetCurrentDirectory()
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0090
integer x = 46
integer y = 200
integer width = 4539
integer height = 2048
string dataobject = "d_sm10_0090_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0090
integer y = 3092
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0090
integer y = 3092
end type

type p_search from w_inherite`p_search within w_sm10_0090
integer y = 3092
end type

type p_ins from w_inherite`p_ins within w_sm10_0090
integer y = 3092
end type

type p_exit from w_inherite`p_exit within w_sm10_0090
end type

type p_can from w_inherite`p_can within w_sm10_0090
end type

event p_can::clicked;call super::clicked;dw_1.SetItem(1, "sdate", f_today())
dw_1.SetItem(1, "edate", f_today())
dw_1.SetItem(1, "factory", '')
dw_1.SetItem(1, "itnbr", '')

dw_insert.reset()
end event

type p_print from w_inherite`p_print within w_sm10_0090
integer y = 3092
end type

type p_inq from w_inherite`p_inq within w_sm10_0090
integer x = 3749
end type

event p_inq::clicked;call super::clicked;string ls_sdate, ls_edate, ls_factory, ls_itnbr

if dw_1.AcceptText() = -1 then return

ls_sdate = trim(dw_1.GetItemString(1, 'sdate'))
ls_edate = trim(dw_1.GetItemString(1, 'edate'))

ls_factory = trim(dw_1.GetItemString(1, 'factory'))
if isnull(ls_factory) or ls_factory = '' then
	ls_factory = '%'
end if

ls_itnbr = trim(dw_1.GetItemString(1, 'itnbr'))

dw_insert.Retrieve(ls_sdate, ls_edate, ls_factory, ls_itnbr)
end event

type p_del from w_inherite`p_del within w_sm10_0090
end type

event p_del::clicked;call super::clicked;long ll_row

ll_row = dw_insert.GetRow()
if ll_row <= 0 then return

dw_insert.DeleteRow(ll_row)
end event

type p_mod from w_inherite`p_mod within w_sm10_0090
end type

event p_mod::clicked;call super::clicked;If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('�������','�������')
	Return
Else
	Commit;
End iF
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0090
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0090
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0090
end type

type cb_del from w_inherite`cb_del within w_sm10_0090
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0090
end type

type cb_print from w_inherite`cb_print within w_sm10_0090
end type

type st_1 from w_inherite`st_1 within w_sm10_0090
end type

type cb_can from w_inherite`cb_can within w_sm10_0090
end type

type cb_search from w_inherite`cb_search within w_sm10_0090
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0090
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0090
end type

type p_excel_upload from uo_picture within w_sm10_0090
integer x = 3589
integer y = 24
boolean bringtotop = true
string picturename = "C:\erpman\image\from_excel.gif"
end type

event clicked;call super::clicked;string ls_docname, ls_named ,ls_line 
Long   ll_FileNum ,ll_value
String ls_gubun , ls_col ,ls_line_t , ls_data[]
Long   ll_xl_row , ll_r , i

String ls_yymmdd, ls_factory, ls_custcd, ls_aitnbr, ls_itnbr, ls_cvcod
long   ll_planqty00, ll_planqty01, ll_planqty02, ll_planqty03, ll_planqty04, ll_planqty05, ll_planqty06, ll_planqty07
long   ll_planqty08, ll_planqty09, ll_planqty10, ll_planqty11, ll_planqty12, ll_planqty13, ll_planqty14

long   ll_count

If dw_1.AcceptText() = -1 Then Return

ll_value = GetFileOpenName("UPLOAD ����Ÿ ��������", ls_docname, ls_named, & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return
//UserObject ����

dw_insert.Reset()

w_mdi_frame.sle_msg.Text = "EXCEL DATA IMPORT ���Դϴ�..........."

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
		
//������ ����
uo_xl.uf_excel_connect(ls_docname, false , 3)

//Sheet ����
uo_xl.uf_selectsheet(1)

//Data ���� Row Setting
ll_xl_row =2

ChangeDirectory(is_cur_directory)

Do While(True)
	
	//Data�� ������쿣 Return...........
	ls_line = trim(uo_xl.uf_gettext(ll_xl_row,1))
	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
	
	//����� ID(A,1)
	//Data�� ���� ��� �ش��ϴ� �������� �����ؾ߸� ���ڰ� ������ ����....������ �𸣰���....
	For i =1 To 27
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
	Next
	
	SetNull(ls_yymmdd)
	SetNull(ls_factory)
	SetNull(ls_custcd)
	SetNull(ls_aitnbr)
	SetNull(ls_itnbr)
	SetNull(ls_cvcod)
	
	SetNull(ll_planqty00)
	SetNull(ll_planqty01)
	SetNull(ll_planqty02)
	SetNull(ll_planqty03)
	SetNull(ll_planqty04)
	SetNull(ll_planqty05)
	SetNull(ll_planqty06)
	SetNull(ll_planqty07)
	SetNull(ll_planqty08)
	SetNull(ll_planqty09)
	SetNull(ll_planqty10)
	SetNull(ll_planqty11)
	SetNull(ll_planqty12)
	SetNull(ll_planqty13)
	SetNull(ll_planqty14)
	
	ls_yymmdd  =  Trim(uo_xl.uf_gettext(ll_xl_row,1))
	if IsNull(ls_yymmdd) or ls_yymmdd = '' then
		uo_xl.uf_excel_Disconnect()
		MessageBox('Ȯ��', string(ll_xl_row) + "�� ��ȹ���� ���� �����ϴ�.")
		return
	end if
	
	ls_factory  =  Trim(uo_xl.uf_gettext(ll_xl_row,2))
	if IsNull(ls_factory) or ls_factory = '' then
		uo_xl.uf_excel_Disconnect()
		MessageBox('Ȯ��', string(ll_xl_row) + "�� �����ڵ� ���� �����ϴ�.")
		return
	end if
	
	ls_custcd  =  Trim(uo_xl.uf_gettext(ll_xl_row,3))
	if IsNull(ls_custcd) or ls_custcd = '' then
		ls_custcd = 'P655'
	elseif ls_custcd = '10' then
		ls_custcd = 'P655'
	end if
	
	ls_aitnbr  =  Trim(uo_xl.uf_gettext(ll_xl_row,4))
	if IsNull(ls_aitnbr) or ls_aitnbr = '' then
		uo_xl.uf_excel_Disconnect()
		MessageBox('Ȯ��', string(ll_xl_row) + "�� ǰ�� ���� �����ϴ�.")
		return
	end if
	
	select a.itnbr
	  into :ls_itnbr
	  from itemas a
	 where replace(a.itnbr, '-', '') = replace(:ls_aitnbr, '-', '');
	if IsNull(ls_itnbr) or ls_itnbr = '' then
		uo_xl.uf_excel_Disconnect()
		MessageBox('Ȯ��', string(ll_xl_row) + "�� ǰ�� ���� ǰ�񸶽�Ÿ�� ��ϵǾ� ���� �ʽ��ϴ�.")
		return
	end if
	
	select count('x')
	  into :ll_count
	  from sm_plan_excel_upload
	 where yyyymmdd = :ls_yymmdd
	   and factory = :ls_factory
	   and itnbr = :ls_itnbr;
	
	if ll_count > 0 then
		uo_xl.uf_excel_Disconnect()
		MessageBox('Ȯ��', "��ȹ���� : " + ls_yymmdd + ", �����ڵ�" + ls_factory + ", ǰ�� : " + ls_itnbr + "�� �̹� ��ϵ� �ڷ��Դϴ�.")
		return
	end if
	
	ls_cvcod  =  Trim(uo_xl.uf_gettext(ll_xl_row,5))
	
	ll_planqty00  =  Dec(uo_xl.uf_gettext(ll_xl_row,6))
	ll_planqty01  =  Dec(uo_xl.uf_gettext(ll_xl_row,7))
	ll_planqty02  =  Dec(uo_xl.uf_gettext(ll_xl_row,8))
	ll_planqty03  =  Dec(uo_xl.uf_gettext(ll_xl_row,9))
	ll_planqty04  =  Dec(uo_xl.uf_gettext(ll_xl_row,10))
	ll_planqty05  =  Dec(uo_xl.uf_gettext(ll_xl_row,11))
	ll_planqty06  =  Dec(uo_xl.uf_gettext(ll_xl_row,12))
	ll_planqty07  =  Dec(uo_xl.uf_gettext(ll_xl_row,13))
	ll_planqty08  =  Dec(uo_xl.uf_gettext(ll_xl_row,14))
	ll_planqty09  =  Dec(uo_xl.uf_gettext(ll_xl_row,15))
	ll_planqty10  =  Dec(uo_xl.uf_gettext(ll_xl_row,16))
	ll_planqty11  =  Dec(uo_xl.uf_gettext(ll_xl_row,17))
	ll_planqty12  =  Dec(uo_xl.uf_gettext(ll_xl_row,18))
	ll_planqty13  =  Dec(uo_xl.uf_gettext(ll_xl_row,19))
	ll_planqty14  =  Dec(uo_xl.uf_gettext(ll_xl_row,20))
	
	ll_r = dw_insert.InsertRow(0) 
	
	//dw_insert.Selectrow(0,false)
	dw_insert.Scrolltorow(ll_r)
	//dw_insert.Selectrow(ll_r,true)
	
	dw_insert.object.yyyymmdd[ll_r]  =  ls_yymmdd
	dw_insert.object.factory[ll_r]   =  ls_factory
	dw_insert.object.custcd[ll_r]    =  ls_custcd
	dw_insert.object.itnbr[ll_r]     =  ls_itnbr
	dw_insert.object.cvcod[ll_r]     =  ls_cvcod
	
	dw_insert.object.planqty00[ll_r] =  ll_planqty00
	dw_insert.object.planqty01[ll_r] =  ll_planqty01
	dw_insert.object.planqty02[ll_r] =  ll_planqty02
	dw_insert.object.planqty03[ll_r] =  ll_planqty03
	dw_insert.object.planqty04[ll_r] =  ll_planqty04
	dw_insert.object.planqty05[ll_r] =  ll_planqty05
	dw_insert.object.planqty06[ll_r] =  ll_planqty06
	dw_insert.object.planqty07[ll_r] =  ll_planqty07
	dw_insert.object.planqty08[ll_r] =  ll_planqty08
	dw_insert.object.planqty09[ll_r] =  ll_planqty09
	dw_insert.object.planqty10[ll_r] =  ll_planqty10
	dw_insert.object.planqty11[ll_r] =  ll_planqty11
	dw_insert.object.planqty12[ll_r] =  ll_planqty12
	dw_insert.object.planqty13[ll_r] =  ll_planqty13
	dw_insert.object.planqty14[ll_r] =  ll_planqty14
	
	ll_xl_row ++
	
Loop

//MessageBox('Ȯ��',String(ll_r)+'���� CLAIM DATA IMPORT �� �Ϸ��Ͽ����ϴ�.')

uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
w_mdi_frame.sle_msg.Text = "DATA �� ���� ���Դϴ�..........."
// ����Ÿ �ٷ� ���� 

If dw_insert.RowCount() < 1 Then Return

dw_insert.AcceptText()

IF dw_insert.Update()  = 1  THEN	
	COMMIT;
	w_mdi_frame.sle_msg.Text = "���� �Ǿ����ϴ�!"
	
	p_inq.TriggerEvent(Clicked!)
	
ELSE
	ROLLBACK;
	//messagebox('',sqlca.sqlerrText)
	f_message_chk(32, "[�������]")
	w_mdi_frame.sle_msg.Text = "�����۾� ����!"
END IF
w_mdi_frame.sle_msg.Text = String(ll_r)+'���� CLAIM DATA IMPORT �� �Ϸ��Ͽ����ϴ�.'
MessageBox('Ȯ��',String(ll_r)+'���� CLAIM DATA IMPORT �� �Ϸ��Ͽ����ϴ�.')

ib_any_typing = False //�Է��ʵ� ���濩�� No


end event

type dw_1 from datawindow within w_sm10_0090
integer x = 27
integer y = 12
integer width = 3456
integer height = 172
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0090_1"
boolean border = false
boolean livescroll = true
end type

type pb_2 from u_pb_cal within w_sm10_0090
integer x = 681
integer y = 64
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('sdate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'sdate', gs_code)

end event

type pb_1 from u_pb_cal within w_sm10_0090
integer x = 1239
integer y = 64
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_1.SetColumn('edate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_1.SetItem(1, 'edate', gs_code)

end event

type rr_1 from roundrectangle within w_sm10_0090
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 192
integer width = 4576
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

