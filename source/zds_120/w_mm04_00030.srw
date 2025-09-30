$PBExportHeader$w_mm04_00030.srw
$PBExportComments$** ���� ����
forward
global type w_mm04_00030 from w_inherite
end type
type dw_detail from datawindow within w_mm04_00030
end type
type p_1 from picture within w_mm04_00030
end type
type pb_1 from u_pb_cal within w_mm04_00030
end type
type pb_2 from u_pb_cal within w_mm04_00030
end type
type st_2 from statictext within w_mm04_00030
end type
type st_3 from statictext within w_mm04_00030
end type
type p_xls from picture within w_mm04_00030
end type
type rr_1 from roundrectangle within w_mm04_00030
end type
type rr_3 from roundrectangle within w_mm04_00030
end type
end forward

global type w_mm04_00030 from w_inherite
integer width = 4745
integer height = 2780
string title = "���� ����"
dw_detail dw_detail
p_1 p_1
pb_1 pb_1
pb_2 pb_2
st_2 st_2
st_3 st_3
p_xls p_xls
rr_1 rr_1
rr_3 rr_3
end type
global w_mm04_00030 w_mm04_00030

forward prototypes
public function integer wf_imhist_division (string arg_iojpno, string arg_utype)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_imhist_division (string arg_iojpno, string arg_utype);String	sItnbr, sItdsc, sError
Decimal	dDivQty

/* �����ϱ����� ó���ؾ��� */
select a.itnbr, b.itdsc, a.iodeqty
  into :sItnbr, :sItdsc, :dDivQty
  from imhist a, itemas b
 where a.sabu = :gs_sabu
	and a.iojpno = :arg_iojpno ;

If arg_utype = 'I' Then		
	If dDivQty <= 0 Then Return 1
	
	w_mdi_frame.sle_msg.text = sItnbr + '  ' + sItdsc + ' �������Դϴ�....!!'
Else
	w_mdi_frame.sle_msg.text = sItnbr + '  ' + sItdsc + ' �������Դϴ�....!!'
End If

sError = 'X'

setpointer(hourglass!)
sqlca.mm10_imhist_divqty(gs_sabu, arg_iojpno, gs_userid, arg_utype, sError) ;
If sError <> 'N' Then
	w_mdi_frame.sle_msg.text = ''
	MessageBox("Ȯ��", "���� ó���� ������ �߻� �Ͽ����ϴ�", stopsign!)
	Return -1
End If

Return 1
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

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
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "�ڷ�ٿ����!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "�ڷ�ٿ�Ϸ�!!!"
end subroutine

on w_mm04_00030.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.p_1=create p_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_2=create st_2
this.st_3=create st_3
this.p_xls=create p_xls
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.p_xls
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_3
end on

on w_mm04_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.p_xls)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_detail.settransobject(SQLCA)
dw_insert.settransobject(SQLCA)

dw_detail.InsertRow(0)

dw_detail.Object.yymm[1] = f_aftermonth(left(f_today(),6) , -1)
dw_detail.Object.sdate[1] = f_aftermonth(left(f_today(),6) , -1) + '01'
dw_detail.Object.edate[1] = f_last_date(f_aftermonth(left(f_today(),6) , -1)) 

dw_detail.SetFocus()
dw_detail.SetColumn(1)

f_mod_saupj(dw_detail, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_mm04_00030
integer x = 32
integer y = 260
integer width = 4558
integer height = 2016
integer taborder = 20
string dataobject = "d_mm04_00030_a_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''
Long ll_row 
ll_row = GetRow()
If ll_row < 1 Then Return

IF this.GetColumnName() = "sojae_itnbr" THEN
//	gs_gubun = Trim(This.Object.itnbr[ll_row])
//	
//	dw_bom.Retrieve(gs_gubun)  // ���� ���Լ����� ����ϱ� ���� bom
//	
//	Open(w_qa02_00050_popup01)
//	
//	IF isnull(gs_Code)  or  gs_Code = '' or &
//	   isnull(gs_Codename)  or  gs_Codename = '' then 
//		
//		This.Object.sojae_itnbr[ll_row] = ''
//		This.Object.sojae_itdsc[ll_row] = '' 
//		This.Object.cvcod[ll_row] = ''
//		This.Object.cvnas[ll_row] = ''
//		return
//	End If
//	
//	String ls_itdsc ,ls_cvnas
//	
//	SELECT B.ITDSC,
//	       C.CVNAS2
//	  Into :ls_itdsc , :ls_cvnas 
//	  FROM DANMST A , ITEMAS B, VNDMST C
//	 WHERE A.ITNBR = :gs_code
//	   AND A.CVCOD = :gs_codename
//		AND A.ITNBR = B.ITNBR
//		AND A.CVCOD = C.CVCOD ;
//
//	If SQLCA.SQLCODE <> 0 Then
//		f_message_chk(33,'')
//		
//	Else
//	   This.Object.sojae_itnbr[ll_row] = gs_code
//		This.Object.sojae_itdsc[ll_row] = ls_itdsc
//		This.Object.cvcod[ll_row] = gs_codename
//		This.Object.cvnas[ll_row] = ls_cvnas
//	End If
//	
//	Dec ld_roqty = 0 ,ld_rq 
//	Long   i,ll_level
//	String ls_p , ls_c
//	
//	For i = 1 To dw_bom.RowCount()
//		ll_level = dw_bom.Object.lvlno[i]
//		
//		If i = 1 Then
//			ld_rq = dw_bom.Object.qtypr[i]
//		Else
//			If ll_level <> 1 Then
//				ld_rq = ld_rq *  dw_bom.Object.qtypr[i]
//			Else
//				ld_rq = dw_bom.Object.qtypr[i]
//			End If
//		End if
//		
//		dw_bom.Object.s_qty[i] = ld_rq
//		
//		ls_c = dw_bom.Object.cinbr[i]
//		If ls_c = gs_code Then
//			ld_roqty = ld_roqty + dw_bom.Object.s_qty[i]
//		End If
//	Next
//	
//	dw_insert.Object.shpact_qa_roqty[ll_row] = ld_roqty * dw_insert.Object.roqty[ll_row]
//
	
END IF
end event

event dw_insert::buttonclicked;call super::buttonclicked;If row < 1 Then Return

decimal	dqty

Choose Case Lower(dwo.name)
	Case 'b_fat'
		gs_code = Trim(This.Object.shpjpno[row])
		
		If gs_code > '' Then
//			Open(w_qa02_00050_popup03)
			dqty = message.doubleparm
			this.setitem(row,'qasqty',dqty)
		End If
End Choose


end event

event dw_insert::itemchanged;call super::itemchanged;gs_code = ''
gs_codename = ''
gs_gubun = ''
Long ll_row 
Dec  ld_qasqty, ld_ioqty, ld_deqty

AcceptText()

ll_row = GetRow()
If ll_row < 1 Then Return

IF this.GetColumnName() = "dan_flag" THEN
	if this.gettext() = 'Y' then
		this.setitem(ll_row,'imhist_ioamt',(this.getitemnumber(ll_row,'imhist_ioqty') * &
														this.getitemnumber(ll_row,'imhist_ioprc')))
	end if
	
ELSEIF this.GetColumnName() = "imhist_iodeqty" THEN
	ld_deqty = Dec(this.gettext())
	ld_ioqty = this.GetItemNumber(ll_row, 'imhist_iosuqty')
	if ld_deqty >= ld_ioqty then
		messagebox('Ȯ��','���Ҽ����� �԰������ �ʰ��� �� �����ϴ�!!!')
		this.SetItem(ll_row, 'imhist_iodeqty', 0)
		return 1
	end if

	this.setitem(ll_row,'imhist_ioqty', ld_ioqty - ld_deqty)

ElseIf This.GetColumnName() = 'amt' Then
	This.SetItem(ll_row, 'dan_flag', 'Y')
	This.SetItem(ll_row, 'upamt', This.GetItemNumber(ll_row, 'amt'))
	This.SetItem(ll_row, 'upprc', This.GetItemNumber(ll_row, 'amt') / This.GetItemNumber(ll_row, 'imhist_ioqty'))	
	

//	ld_qasqty =This.Object.qasqty[ll_row]
//	If ld_qasqty > 0 Then
//		gs_gubun = Trim(This.Object.itnbr[ll_row])
//		
//		dw_bom.Retrieve(gs_gubun)  // ���� ���Լ����� ����ϱ� ���� bom
//		
//		Open(w_qa02_00050_popup01)
//		
//		IF isnull(gs_Code)  or  gs_Code = '' or &
//			isnull(gs_Codename)  or  gs_Codename = '' then 
//			
//			This.Object.sojae_itnbr[ll_row] = ''
//			This.Object.sojae_itdsc[ll_row] = '' 
//			This.Object.cvcod[ll_row] = ''
//			This.Object.cvnas[ll_row] = ''
//			return
//		End If
//		
//		String ls_itdsc ,ls_cvnas
//		
//		SELECT B.ITDSC,
//				 C.CVNAS2
//		  Into :ls_itdsc , :ls_cvnas 
//		  FROM DANMST A , ITEMAS B, VNDMST C
//		 WHERE A.ITNBR = :gs_code
//			AND A.CVCOD = :gs_codename
//			AND A.ITNBR = B.ITNBR
//			AND A.CVCOD = C.CVCOD ;
//	
//		If SQLCA.SQLCODE <> 0 Then
//			f_message_chk(33,'')
//			
//		Else
//			This.Object.sojae_itnbr[ll_row] = gs_code
//			This.Object.sojae_itdsc[ll_row] = ls_itdsc
//			This.Object.cvcod[ll_row] = gs_codename
//			This.Object.cvnas[ll_row] = ls_cvnas
//		End If
//		
//		Dec ld_roqty = 0 ,ld_rq 
//		Long   i,ll_level
//		String ls_p , ls_c
//		
//		For i = 1 To dw_bom.RowCount()
//			ll_level = dw_bom.Object.lvlno[i]
//			
//			If i = 1 Then
//				ld_rq = dw_bom.Object.qtypr[i]
//			Else
//				If ll_level <> 1 Then
//					ld_rq = ld_rq *  dw_bom.Object.qtypr[i]
//				Else
//					ld_rq = dw_bom.Object.qtypr[i]
//				End If
//			End if
//			
//			dw_bom.Object.s_qty[i] = ld_rq
//			
//			ls_c = dw_bom.Object.cinbr[i]
//			If ls_c = gs_code Then
//				ld_roqty = ld_roqty + dw_bom.Object.s_qty[i]
//			End If
//		Next
//		
//		dw_insert.Object.shpact_qa_roqty[ll_row] = ld_roqty * dw_insert.Object.roqty[ll_row]
//	End If
	
END IF
end event

event dw_insert::clicked;call super::clicked;//this.setrow(row)
this.trigger event rowfocuschanged(row)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then 
	this.SelectRow(0, FALSE)
	return
end if

this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

dw_detail.setitem(1,'vendor',this.getitemstring(currentrow,'imhist_cvcod'))
dw_detail.setitem(1,'vendorname',this.getitemstring(currentrow,'vndmst_cvnas'))
end event

type p_delrow from w_inherite`p_delrow within w_mm04_00030
boolean visible = false
integer x = 4923
integer y = 328
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mm04_00030
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mm04_00030
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_mm04_00030
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_mm04_00030
integer x = 4402
integer y = 0
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_mm04_00030
integer x = 4229
integer y = 0
end type

event p_can::clicked;call super::clicked;dw_insert.reset()

dw_detail.InsertRow(0)

dw_detail.Object.sdate[1] = f_afterday(f_today(),-30)
dw_detail.Object.edate[1] = f_today() 

dw_detail.SetFocus()
dw_detail.SetColumn(1)

p_xls.Enabled =False
p_xls.PictureName = 'C:\erpman\image\������ȯ_d.gif'
end event

type p_print from w_inherite`p_print within w_mm04_00030
boolean visible = false
integer x = 2117
integer y = 2428
boolean enabled = false
string picturename = "C:\erpman\image\�μ�_d.gif"
end type

type p_inq from w_inherite`p_inq within w_mm04_00030
integer x = 3355
integer y = 0
end type

event p_inq::clicked;call super::clicked;string ssdate, sedate, scvcod, snull, sittyp, syymm

if dw_detail.accepttext() = -1 then return

syymm  = trim(dw_detail.getitemstring(1, "yymm"))
ssdate = syymm + '01'
sedate = f_last_date(syymm) 
//ssdate  = trim(dw_detail.getitemstring(1, "sdate"))
//sedate  = trim(dw_detail.getitemstring(1, "edate"))
scvcod  = dw_detail.getitemstring(1, "vendor")
sittyp  = trim(dw_detail.getitemstring(1, "ittyp"))

if isnull(ssdate) or trim(ssdate) = '' then
	f_message_chk(30, '[�԰�����FROM]')
	dw_detail.SetColumn("sdate")
	dw_detail.SetFocus()
	return
end if

if isnull(sedate) or trim(sedate) = '' then
	f_message_chk(30, '[�԰�����TO]')
	dw_detail.SetColumn("edate")
	dw_detail.SetFocus()
	return
end if

if isnull(scvcod) or trim(scvcod) = '' then scvcod = '%'
//	f_message_chk(30, '[�ŷ�ó]')
//	dw_detail.SetColumn("vendor")
//	dw_detail.SetFocus()
//	return
//end if
if isnull(sittyp) or trim(sittyp) = '' then sittyp = '%'

String  ls_saupj
ls_saupj = dw_detail.GetItemString(1, 'saupj')
IF (IsNull(ls_saupj) or Trim(ls_saupj) = "" ) then
	f_message_chk(30, "[�����]")
   dw_detail.SetColumn('saupj')
	dw_detail.SetFocus()
	return
end if

dw_insert.setredraw(false)

if dw_insert.retrieve(ls_saupj, ssdate, sedate, scvcod, sittyp) > 0 then
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\������ȯ_up.gif'
else
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\������ȯ_d.gif'
   f_message_chk(50, '[���� ����]')
end if

dw_insert.setredraw(true)
end event

type p_del from w_inherite`p_del within w_mm04_00030
integer x = 3881
integer y = 0
end type

event p_del::clicked;call super::clicked;long		lrow
string	siojpno, sfield_cd
decimal	dqty

If Messagebox('Ȯ��','���õ� �ڷḦ �����Ͻðڽ��ϱ�?', question!, yesno!, 2) = 2 Then Return

For lrow = dw_insert.RowCount() To 1 Step -1

	if dw_insert.getitemstring(lrow,'del_flag') = 'Y' then

		siojpno = dw_insert.GetItemString(lrow, 'imhist_iojpno')
		if wf_imhist_division(siojpno, 'D') = -1 then
			rollback ;
			messagebox('Ȯ��','�����ڷ� ���� ����!!!')
			w_mdi_frame.sle_msg.text = ''
			return
		end if
		
		dw_insert.deleterow(lrow)
		lrow++
	end if
Next

if dw_insert.update() <> 1 then
	rollback ;
	messagebox('Ȯ��','�����ڷ� ���� ����!!!')
	return
end if

Commit;
w_mdi_frame.sle_msg.text = ''
p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_mm04_00030
integer x = 4055
integer y = 0
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

Long	 	i
String 	sdate1, sdate2, siojpno


If f_msg_update() < 1 Then Return

Double ldb_amt

dw_insert.setredraw(false)
For i=1 To dw_insert.RowCount()
	sdate1 = dw_insert.getitemstring(i,'insdat')
	sdate2 = dw_insert.getitemstring(i,'io_date')
	
	if f_datechk(sdate2) = -1 then
		messagebox('Ȯ��','���ڰ� �߸� �����Ǿ����ϴ�!!!')
		dw_insert.setrow(i)
		dw_insert.scrolltorow(i)
		dw_insert.setfocus()
		return
	end if
	
	if sdate1 <> sdate2 then
		dw_insert.setitem(i,'upd_user',gs_empno)
		dw_insert.setitem(i,'bigo','���� ���� / ')
	end if
	
	if dw_insert.getitemstring(i,'dan_flag') = 'Y' then
		dw_insert.setitem(i,'imhist_ioprc',dw_insert.getitemnumber(i,'upprc'))
		//2007.05.29 by shingoon-----------------------------------------------------
		//��ǰ�� ��� ('-'���� * �ܰ�)�� ��� �� �ݾ� �Է� ��.
		//iomatrix -> calvalue���� ���ϸ� '+'�� �ٲ�.
		//imhist -> ioamt�� '+'�ݾ��� �ԷµǾ�� �ϳ� '-'�� �Է� �Ǿ�����.
		//"IMHIST"."IOSUQTY"�� ������ �޾ƿ;� ��. "IMHIST"."IOQTY"�� "IMHIST"."IOSUQTY" * "IOMATRIX"."CALVALUE"�� �̹� ���� ����.
//		dw_insert.setitem(i,'imhist_ioamt',dw_insert.getitemnumber(i,'upamt'))
		ldb_amt = dw_insert.getitemnumber(i,'upamt_re')
		dw_insert.setitem(i,'imhist_ioamt', ldb_amt)
		//---------------------------------------------------------------------------
		
		dw_insert.setitem(i,'bigo',dw_insert.getitemstring(i,'bigo')+'�ܰ� ����')
	end if
Next
dw_insert.setredraw(true)

if dw_insert.update() <> 1 then
	rollback ;
	messagebox('�������','�ڷ� ���� ����!!!')
	return
end if

For i=1 To dw_insert.RowCount()
	if dw_insert.GetItemNumber(i, 'imhist_iodeqty') = 0 Then Continue			// ���Ҽ����� ������ skip
	if dw_insert.GetItemString(i, 'imhist_field_cd') > '.' Then Continue		// �����ڷ�� skip
	
	siojpno = dw_insert.GetItemString(i, 'imhist_iojpno')
	if wf_imhist_division(siojpno, 'I') = -1 then
		rollback ;
		messagebox('Ȯ��','�ڷ� ���� ����!!!')
		w_mdi_frame.sle_msg.text = ''
		return
	end if
Next

Commit;
w_mdi_frame.sle_msg.text = ''
p_inq.TriggerEvent(Clicked!)

	
	
end event

type cb_exit from w_inherite`cb_exit within w_mm04_00030
end type

type cb_mod from w_inherite`cb_mod within w_mm04_00030
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_mm04_00030
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_mm04_00030
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_mm04_00030
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_mm04_00030
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_mm04_00030
end type

type cb_can from w_inherite`cb_can within w_mm04_00030
end type

type cb_search from w_inherite`cb_search within w_mm04_00030
end type







type gb_button1 from w_inherite`gb_button1 within w_mm04_00030
end type

type gb_button2 from w_inherite`gb_button2 within w_mm04_00030
end type

type dw_detail from datawindow within w_mm04_00030
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 24
integer width = 3291
integer height = 124
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_mm04_00030_1"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sVendor, sVendorname, sNull

SetNull(sNull)

// �ŷ�ó
IF this.GetColumnName() = 'vendor'		THEN

	sVendor = this.gettext()
	SELECT CVNAS2
	  INTO :sVendorName
	  FROM VNDMST
	 WHERE CVCOD = :sVendor 	AND
	 		 CVSTATUS = '0' ;
	 
	if sqlca.sqlcode <> 0 	then
//		f_message_chk(33,'[�ŷ�ó]')
		this.setitem(1, "vendor", sNull)
		this.setitem(1, "vendorname", sNull)
		return
	end if

	this.setitem(1, "vendorname", sVendorName)

END IF




end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// ��ǥ��ȣ
IF this.GetColumnName() = 'vendor'	THEN
   gs_gubun = '1' 
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1, "vendor",		gs_code)
	SetItem(1, "vendorname",gs_codename)

END IF


end event

type p_1 from picture within w_mm04_00030
integer x = 3707
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\�ܰ�����_up.gif"
boolean focusrectangle = false
end type

event clicked;long		lrow
string	sitnbr, scvcod, sdate, sopseq, siogbn, sguout, sittyp
decimal {2}	dunprc	

if messagebox('Ȯ��','�ܰ������� �����մϴ�.',question!,yesno!,1) = 2 then return

setpointer(hourglass!)

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'mod_flag') = 'N' then continue
	
	sitnbr = dw_insert.getitemstring(lrow,'imhist_itnbr')
	scvcod = dw_insert.getitemstring(lrow,'imhist_cvcod')
	sopseq = dw_insert.getitemstring(lrow,'imhist_opseq')
	sdate  = trim(dw_insert.getitemstring(lrow,'io_date'))
	siogbn = dw_insert.getitemstring(lrow,'imhist_iogbn')
	sittyp = dw_insert.getItemstring(lrow,'itemas_ittyp')
	if siogbn = 'I03' then
		sguout = '2'
	else
		//2007.05.29 by shingoon - ��ǰ���(I21)�� ��� ����/���� ������ �����Ƿ� �ܰ��� �������� ����.
		//��ǰ���(I21)�� ǰ�񱸺����� ����/���� ����ó�� - ����ǰ/����ǰ�� ����, ������� ����
		//��ǰ�� ���
		If siogbn = 'I21' Then
			//����ǰ, ����ǰ�� ��� ����('2')
			If sittyp = '1' OR sittyp = '2' Then
				sguout = '2'
			Else
				//�������� ��� ����('1')
				sguout = '1'
			End If
		Else
			//��ǰ�� �ƴ� ��� ����('1')
			sguout = '1'
		End If
	end if	
	
	select fun_danmst_danga6(:sitnbr, :scvcod, :sopseq, :sdate, :sguout)
	  into :dunprc from dual ;

//	select fun_erp100000012_1(:sdate,:scvcod,:sitnbr,'1')
//	  into :dunprc from dual ;
	if sqlca.sqlcode = 0 then dw_insert.setitem(lrow,'upprc',dunprc)
	
//	MESSAGEBOX('A',STRING(DUNPRC))
	
	if dw_insert.getitemnumber(lrow,'upprc') > 0 and &
		dw_insert.getitemnumber(lrow,'imhist_ioprc') <> dw_insert.getitemnumber(lrow,'upprc') then
		dw_insert.setitem(lrow,'dan_flag','Y')
	end if
NEXT

messagebox('Ȯ��','�ܰ����� ���� �Ϸ�!!!')
end event

type pb_1 from u_pb_cal within w_mm04_00030
boolean visible = false
integer x = 649
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_detail.SetColumn('sdate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_detail.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_mm04_00030
boolean visible = false
integer x = 969
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_detail.SetColumn('edate')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_detail.SetItem(1, 'edate', gs_code)

end event

type st_2 from statictext within w_mm04_00030
integer x = 59
integer y = 196
integer width = 2181
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "1) �ܰ����� : �ܰ����� ó���� ���� üũ�ؼ� �����ϸ� ���õ� �ڷḸ �ܰ� �����."
boolean focusrectangle = false
end type

type st_3 from statictext within w_mm04_00030
boolean visible = false
integer x = 2450
integer y = 196
integer width = 1961
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "2) �������� : ���Ҽ����� ������ ������ �����ϸ� �ڷᰡ ���ҵǾ� ��Ÿ��."
boolean focusrectangle = false
end type

type p_xls from picture within w_mm04_00030
integer x = 3534
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\������ȯ_d.gif"
boolean focusrectangle = false
end type

event clicked;If this.Enabled Then wf_excel_down(dw_insert) 
end event

type rr_1 from roundrectangle within w_mm04_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 172
integer width = 4585
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_mm04_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer width = 3328
integer height = 156
integer cornerheight = 40
integer cornerwidth = 46
end type

