$PBExportHeader$w_sm90_0010.srw
$PBExportComments$�� �ǸŰ�ȹ ��Ȳ
forward
global type w_sm90_0010 from w_inherite
end type
type rr_1 from roundrectangle within w_sm90_0010
end type
type dw_1 from u_key_enter within w_sm90_0010
end type
type p_1 from uo_picture within w_sm90_0010
end type
type p_preview from picture within w_sm90_0010
end type
type dw_print from datawindow within w_sm90_0010
end type
type p_2 from uo_excel_down within w_sm90_0010
end type
end forward

global type w_sm90_0010 from w_inherite
integer height = 2524
string title = "�� �ǸŰ�ȹ ��Ȳ"
rr_1 rr_1
dw_1 dw_1
p_1 p_1
p_preview p_preview
dw_print dw_print
p_2 p_2
end type
global w_sm90_0010 w_sm90_0010

forward prototypes
public function integer wf_danga (integer arg_row)
public subroutine wf_init ()
end prototypes

public function integer wf_danga (integer arg_row);String sCvcod, sItnbr, stoday, sGiDate ,sCurr
Double	 dDanga
Long ll_rtn

If arg_row <= 0 Then Return 1

sToday	= f_today()
sGiDate	= dw_1.GetItemString(1, 'yymm')+'01'	// �ܰ���������
sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

dDanga = sqlca.fun_erp100000012_1(sGiDate, sCVCOD, sITNBR,'1') ;

If IsNull(dDanga) Then dDanga = 0

dw_insert.Setitem(arg_row, 'sprc', dDanga)

Return 0
end function

public subroutine wf_init ();//



	
end subroutine

on w_sm90_0010.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.p_1=create p_1
this.p_preview=create p_preview
this.dw_print=create dw_print
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_preview
this.Control[iCurrent+5]=this.dw_print
this.Control[iCurrent+6]=this.p_2
end on

on w_sm90_0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_preview)
destroy(this.dw_print)
destroy(this.p_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_1.InsertRow(0)
dw_1.Object.yymm[1] = Left(is_today,6)
dw_1.Object.confirm_dt[1] = is_today

/* User�� ����� Setting Start */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
		dw_1.Modify("saupj.background.color = 80859087")
   End if
End If
/* ---------------------- End  */

dw_1.SetColumn("cvcod")

Long ll_cnt
ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm01_monplan_dt
 where saupj = :gs_code
	and yymm = substr(:is_today,1,6)
	and wandate is not null;
If ll_cnt < 1 Then
	dw_1.Object.cust[1] = '1'
Else
	dw_1.Object.cust[1] = '2'
End If
end event

event key;call super::key;Choose Case key
	Case KeyV!
		p_preview.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_sm90_0010
integer x = 27
integer y = 292
integer width = 4567
integer height = 2024
integer taborder = 130
string dataobject = "d_sm90_0010"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;//Dec 	 dQty, dAmt, dPrc, dmmqty, djucha, davg, dsum, dcha, dDayQty
//Long   nRow, ix, dWorkMon, dWorkWeek
//String sCol, sItnbr, sItdsc, siSpec, sjijil, sispec_code,s_cvcod, snull, get_nm, syymm, sDate, eDate, sFistCol
//Int    ireturn, njucha
//Long   ll_containqty
//
//nRow = GetRow()
//If nRow <= 0 Then Return
//
//SetNull(sNull)
//
//sCol = GetColumnName()
//Choose Case GetColumnName()
//	
//	Case 'itnbr'
//		sItnbr = trim(this.GetText())
//	
//		Select ITDSC ,
//		       CONTAINQTY 
//			Into :sitdsc ,
//			     :ll_containqty
//		  FROM ITEMAS
//		 WHERE ITNBR = :sitnbr ;
//		If sqlca.sqlcode <> 0 Then
//			setitem(nrow, "itnbr", sNull)	
//			setitem(nrow, "itdsc", sNull)	
//			setitem(nrow, "containqty", sNull)	
//			Return 1
//		End If
//		
//		setitem(nrow, "itnbr", sitnbr)	
//		setitem(nrow, "itdsc", sitdsc)
//		setitem(nrow, "containqty", ll_containqty)
//		Post wf_danga(nrow)
//		
//		RETURN ireturn
//	Case 'cvcod'
//		s_cvcod = this.GetText()								
//		 
//		if s_cvcod = "" or isnull(s_cvcod) then 
//			this.setitem(nrow, 'cvnas', snull)
//			return 
//		end if
//		
//		SELECT "VNDMST"."CVNAS"  
//		  INTO :get_nm  
//		  FROM "VNDMST"  
//		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
//	
//		if sqlca.sqlcode = 0 then 
//			this.setitem(nrow, 'cvnas', get_nm)
//			
//			Post wf_danga(nrow)
//		else
//			this.triggerevent(RbuttonDown!)
//			return 1
//		end if
//End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//sle_msg.text = ''
//
//If row < 1 Then Return
//str_code lst_code
//Long i , ll_i = 0
//
//this.AcceptText()
//Choose Case GetcolumnName() 
//	Case "itnbr"
//		
//		gs_gubun = '1'
//		
//		Open(w_itemas_multi_popup)
//
//		lst_code = Message.PowerObjectParm
//		IF isValid(lst_code) = False Then Return 
//		If UpperBound(lst_code.code) < 1 Then Return 
//		
//		For i = row To UpperBound(lst_code.code) + row - 1
//			ll_i++
//			if i > row then p_addrow.triggerevent("clicked")
//			this.SetItem(i,"itnbr",lst_code.code[ll_i])
//			this.TriggerEvent("itemchanged")
//			
//		Next
//	Case 'cvcod'
//		gs_code = GetText()
//
//		Open(w_vndmst_popup)
//		If IsNull(gs_code) Or gs_code = '' Then Return
//		
//		this.SetItem(row, "cvcod", gs_Code)
//		this.SetItem(row, "cvnas", gs_Codename)
//		
//		Post wf_danga(row)
//End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;
If currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if
end event

event dw_insert::ue_pressenter;//Dec dqty
//
///* ǰ���� �Է��ϸ� �������� �̵� */
//If getcolumnname() = "mmqty"  then
//	dQty = Dec(GetText())
//	If IsNull(dQty) Or dQty = 0 Then
//	Else
//		SetColumn('mmqty2')
//		Return 1
//	End If
//End If
//
//Send(Handle(this),256,9,0)
//Return 1
end event

type p_delrow from w_inherite`p_delrow within w_sm90_0010
boolean visible = false
integer x = 3278
integer y = 112
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_sm90_0010
boolean visible = false
integer x = 3442
integer y = 96
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_sm90_0010
boolean visible = false
integer x = 3086
integer y = 20
integer taborder = 110
string picturename = "C:\erpman\image\from_excel.gif"
end type

event p_search::ue_lbuttondown;//
end event

event p_search::ue_lbuttonup;//
end event

type p_ins from w_inherite`p_ins within w_sm90_0010
boolean visible = false
integer x = 4064
integer y = 196
integer taborder = 30
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm90_0010
integer taborder = 100
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm90_0010
integer taborder = 90
end type

event p_can::clicked;call super::clicked;
dw_insert.Reset()
ib_any_typing = False

p_print.enabled = False
p_preview.enabled = False	

p_print.picturename = "c:\erpman\image\�μ�_d.gif"
p_preview.picturename = "c:\erpman\image\�̸�����_d.gif"
		
end event

type p_print from w_inherite`p_print within w_sm90_0010
boolean visible = false
integer x = 3383
integer y = 0
integer taborder = 120
boolean enabled = false
string picturename = "C:\erpman\image\�μ�_d.gif"
end type

event p_print::clicked;call super::clicked;IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_sm90_0010
integer x = 3749
end type

event p_inq::clicked;String ls_saupj , ls_yymm , ls_cvcod , ls_carcode ,ls_itnbr , ls_car


If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
/* ����� üũ */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ls_yymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[��ȹ���]')
	Return
End If

ls_cvcod   = trim(dw_1.getitemstring(1, 'cvcod'))
ls_carcode = trim(dw_1.getitemstring(1, 'carcode'))

If ls_cvcod = '' Or isNull(ls_cvcod) Then 
	ls_cvcod = '%'
Else
	ls_cvcod = ls_cvcod+'%'
End If

If ls_carcode = '' Or isNull(ls_carcode) Then 
	ls_car = '%' 
Else
	//��������� ���� ������ �ڵ尡 �ٸ��Ƿ� �����ؼ� �����´�.
	Select fun_get_reffpf_value('01',:ls_carcode,'4') Into :ls_car
	 From dual ;
	 
	If sqlca.sqlcode <> 0 Then
		ls_car = '%'
	End If
		
End If

ls_itnbr   = trim(dw_1.getitemstring(1, 'itnbr'))
If ls_itnbr = '' Or isNull(ls_itnbr) Then 
	ls_itnbr = '%'
Else
	ls_itnbr = ls_itnbr+'%'
End If

If dw_insert.Retrieve(ls_saupj, ls_yymm, ls_cvcod , ls_car , ls_itnbr) <= 0 Then
	
	p_print.enabled = False
	p_preview.enabled = False	
	
	p_print.picturename = "c:\erpman\image\�μ�_d.gif"
	p_preview.picturename = "c:\erpman\image\�̸�����_d.gif"
	
	f_message_chk(50,'')
	return -1
End If	

p_print.enabled = True
p_preview.enabled = True	

p_print.picturename = "c:\erpman\image\�μ�_up.gif"
p_preview.picturename = "c:\erpman\image\�̸�����_up.gif"

dw_insert.sharedata(dw_print)
	
//Report   �˻����� �� Display
dw_print.Modify("tx_yymm.text = '"+String(ls_yymm,'@@@@.@@')+"'")

ls_saupj = Trim(dw_1.Describe("Evaluate('LookUpDisplay(saupj)', 1)"))
If IsNull(ls_saupj) Or ls_saupj = '' Then ls_saupj = '��ü'
dw_print.Modify("tx_saupj.text = '"+ls_saupj+"'")



/* �� ���� */
dw_insert.object.t_mm.text = String(ls_yymm,'@@@@.@@')+'��'


end event

type p_del from w_inherite`p_del within w_sm90_0010
boolean visible = false
integer x = 3113
integer y = 20
integer taborder = 80
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_sm90_0010
boolean visible = false
integer x = 3118
integer y = 100
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\Ȯ��_up.gif"
end type

event p_mod::ue_lbuttondown;//
end event

event p_mod::ue_lbuttonup;//
end event

type cb_exit from w_inherite`cb_exit within w_sm90_0010
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm90_0010
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm90_0010
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm90_0010
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm90_0010
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm90_0010
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm90_0010
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm90_0010
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm90_0010
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm90_0010
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm90_0010
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm90_0010
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm90_0010
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm90_0010
boolean visible = true
end type

type rr_1 from roundrectangle within w_sm90_0010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4585
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_sm90_0010
integer x = 18
integer y = 16
integer width = 3113
integer height = 252
integer taborder = 20
string dataobject = "d_sm90_0010_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate
Long   nCnt
String sSaupj

SetNull(sNull)

If dw_1.AcceptText() <> 1 Then Return

/* ����� üũ */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

Choose Case GetColumnName()
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.setitem(1, 'cvcod', snull)
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	
	Case 'item'
		sItem = GetText()
		
	Case 'yymm'
		sDate = Left(GetText(),6)
		
		If f_datechk(sDate+'01') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			SELECT COUNT(*) INTO :nCnt FROM SM01_MONPLAN_DT WHERE SAUPJ = :sSaupj AND YYMM = :sDate AND WANDATE IS NOT NULL;
			
			If nCnt > 0 Then
				MessageBox('Ȯ ��','���ǸŰ�ȹ�� ����ó�� �Ǿ��ֽ��ϴ�.!!')
				p_search.Enabled = False
				p_print.Enabled = False
				p_mod.Enabled = False
				p_addrow.Enabled = False
				p_delrow.Enabled = False
				p_del.Enabled = False
				p_search.PictureName = 'C:\erpman\image\from_excel.gif'
				p_print.PictureName = 'C:\erpman\image\�ҿ䷮���_d.gif'
				p_mod.PictureName = 'C:\erpman\image\����_d.gif'
				p_addrow.PictureName = 'C:\erpman\image\���߰�_d.gif'
				p_delrow.PictureName = 'C:\erpman\image\�����_d.gif'
				p_del.PictureName = 'C:\erpman\image\����_d.gif'
				
				Return 1
			
			Else
				p_search.Enabled = True
				p_print.Enabled = True
				p_mod.Enabled = True
				p_addrow.Enabled = True
				p_delrow.Enabled = True
				p_del.Enabled = True
				p_search.PictureName = 'C:\erpman\image\from_excel.gif'
				p_print.PictureName = 'C:\erpman\image\�ҿ䷮���_up.gif'
				p_mod.PictureName = 'C:\erpman\image\����_up.gif'
				p_addrow.PictureName = 'C:\erpman\image\���߰�_up.gif'
				p_delrow.PictureName = 'C:\erpman\image\�����_up.gif'
				p_del.PictureName = 'C:\erpman\image\����_up.gif'
			End If
		End If
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

type p_1 from uo_picture within w_sm90_0010
boolean visible = false
integer x = 4096
integer y = 24
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\Ȯ�����_up.gif"
end type

event clicked;call super::clicked;If dw_1.acceptText() < 1 Then return

If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt
Long   ll_cnt

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm = Trim(dw_1.Object.yymm[1])
ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	 ;
If ll_cnt < 1 Then
	MessageBox('Ȯ��','�ش� ������ ���� �ǸŰ�ȹ�� �������� �ʾҽ��ϴ�.')
	Return
END If

ll_cnt = 0 

SELECT COUNT(*) INTO :ll_cnt
 FROM PM01_MONPLAN_SUM A
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :ls_yymm
	AND A.MOSEQ = 0 
	AND A.SAUPJ LIKE :ls_saupj;

If ll_cnt > 0 Then
	MessageBox('Ȯ��','�ش� �� �ǸŰ�ȹ�� �̹� �����ȹ�� �ݿ��Ǿ� ���������Դϴ�.  ��� �Ұ����մϴ�.')
	Return
Else
	ll_cnt = 0 

	SELECT COUNT(*) INTO :ll_cnt
     FROM PM01_MONPLAN_SUM A
    WHERE A.SABU = :gs_sabu
      AND A.MONYYMM = :ls_yymm
	   AND A.MOSEQ != 0 
	   AND A.SAUPJ LIKE :ls_saupj;
		
	If ll_cnt > 0 Then
		MessageBox('Ȯ��','�ش� �� �ǸŰ�ȹ�� �����ȹ�� �ݿ��� ����(��Ȯ��)�Դϴ�. ��� �� �������� ���뺸 �ʿ��մϴ�.')
	
	End If
	
End If


If MessageBox("Ȯ��",Left(ls_yymm,4)+" ��"+Right(ls_yymm,2)+ " �� �ǸŰ�ȹ�� ��� �Ͻðڽ��ϱ�?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

SetNull(ls_confirm_dt)

Update sm01_monplan_dt Set wandate = :ls_confirm_dt
                    where saupj = :ls_saupj
						    and yymm = :ls_yymm ;
If sqlca.sqlcode <> 0 Then
	Rollback;
	MessageBox('Ȯ��','�������')
	Return
Else
	Commit;
	dw_1.Object.cust[1]='1'
	MessageBox('Ȯ��','���Ǹ� ��ȹ�� ���� ��� �Ǿ����ϴ�.        ')
End If
	

	




	
	
	
end event

type p_preview from picture within w_sm90_0010
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 4096
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\preview.cur"
boolean enabled = false
string picturename = "C:\erpman\image\�̸�����_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;IF This.Enabled = True THEN
	PictureName =  'C:\erpman\image\�̸�����_up.gif'
END IF
end event

event ue_lbuttondown;IF This.Enabled = True THEN
	PictureName = 'C:\erpman\image\�̸�����_dn.gif'
END IF

end event

event clicked;OpenWithParm(w_print_preview, dw_print)	
end event

type dw_print from datawindow within w_sm90_0010
boolean visible = false
integer x = 3214
integer y = 44
integer width = 215
integer height = 180
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm90_0010_p"
boolean border = false
boolean livescroll = true
end type

type p_2 from uo_excel_down within w_sm90_0010
integer x = 3922
integer y = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;If this.Enabled Then uf_excel_down(dw_insert)
end event

