$PBExportHeader$w_mat_03540_old.srw
$PBExportComments$��ȯ�� pbl
forward
global type w_mat_03540_old from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_03540_old
end type
type rr_2 from roundrectangle within w_mat_03540_old
end type
end forward

global type w_mat_03540_old from w_standard_print
string title = "���Ҹ���"
rr_1 rr_1
rr_2 rr_2
end type
global w_mat_03540_old w_mat_03540_old

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  s_depot, s_fritnbr, s_toitnbr, s_frdate, s_todate, s_yymm, s_maxym, s_gub, s_saupj

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_gub     = dw_ip.GetItemString(1,"gub")
s_depot   = dw_ip.GetItemString(1,"sdepot")
s_fritnbr = dw_ip.GetItemString(1,"fr_itnbr")
s_toitnbr = dw_ip.GetItemString(1,"to_itnbr")
s_yymm    = trim(dw_ip.GetItemString(1,"fr_yymm"))
s_todate  = trim(dw_ip.GetItemString(1,"to_yymm"))
s_saupj   = trim(dw_ip.GetItemString(1,"saupj"))

IF s_saupj = "" OR IsNull(s_saupj) THEN s_saupj = '%'

IF s_yymm = "" OR IsNull(s_yymm) THEN
   s_frdate = '10000101'
	s_yymm = '100001'
ELSE	
   s_frdate = s_yymm + '01'
END IF

IF s_todate = "" OR IsNull(s_todate) THEN
   s_todate = '99991231'
ELSE	
   s_todate = s_todate + '31'
END IF

if s_frdate > s_todate then 
	f_message_chk(34,'[���س��]')
	dw_ip.Setcolumn('fr_yymm')
	dw_ip.SetFocus()
	return -1
end if	

if s_depot = '' or isnull(s_depot) then
	s_depot = '%'
end if

IF s_fritnbr = "" OR IsNull(s_fritnbr) THEN 
	s_fritnbr = '.'
END IF
IF s_toitnbr = "" OR IsNull(s_toitnbr) THEN 
	s_toitnbr = 'zzzzzzzzzzzzzzz'
END IF

if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[ǰ��]')
	dw_ip.Setcolumn('fr_itnbr')
	dw_ip.SetFocus()
	return -1
end if	

SELECT MAX(JPDAT)  
  INTO :s_maxym
  FROM JUNPYO_CLOSING  
 WHERE SABU = :gs_sabu AND JPGU = 'C0' ;

if s_gub = '1' then 
	dw_list.DataObject = "d_mat_03540_1_old"
	dw_print.DataObject = "d_mat_03540_1_p_old"
else
   dw_list.DataObject = "d_mat_03540_2_old"
	dw_print.DataObject = "d_mat_03540_2_p_old"
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

IF dw_print.Retrieve(gs_sabu,s_yymm,s_frdate,s_todate,s_depot,s_fritnbr,s_toitnbr,s_maxym, s_saupj) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_mat_03540_old.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_mat_03540_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, "fr_yymm", left(f_today(), 6))
dw_ip.SetItem(1, "to_yymm", left(f_today(), 6))
dw_ip.SetColumn("fr_yymm")
dw_ip.Setfocus()
end event

event ue_open;call super::ue_open;////�����
//f_mod_saupj(dw_ip, 'saupj' )

//�԰�â�� 
f_child_saupj(dw_ip, 'sdepot', '%')
end event

type p_xls from w_standard_print`p_xls within w_mat_03540_old
boolean visible = true
integer x = 3922
integer y = 180
boolean enabled = false
string picturename = "C:\erpman\image\������ȯ_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_mat_03540_old
end type

type p_preview from w_standard_print`p_preview within w_mat_03540_old
end type

type p_exit from w_standard_print`p_exit within w_mat_03540_old
end type

type p_print from w_standard_print`p_print within w_mat_03540_old
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03540_old
end type

event p_retrieve::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//������� �����̰ų� ������ ��� �����//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\�μ�_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
	p_xls.enabled = False
	p_xls.PictureName = 'C:\erpman\image\������ȯ_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\�μ�_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\�̸�����_up.gif'
	p_xls.enabled = True
	p_xls.PictureName = 'C:\erpman\image\������ȯ_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 fontä ���� - ��
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object ����
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event











type dw_print from w_standard_print`dw_print within w_mat_03540_old
string dataobject = "d_mat_03540_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03540_old
integer x = 59
integer y = 60
integer width = 3653
integer height = 292
string dataobject = "d_mat_03540_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if	

end event

event dw_ip::ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"fr_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"to_itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_ip::itemchanged;string snull, sdate
string  sitnbr, sitdsc, sispec, sdepot, ssaupj
int     ireturn

setnull(snull)

IF this.GetColumnName() ="fr_yymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[���س�� FROM]')
		this.setitem(1, "fr_yymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="to_yymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[���س�� TO]')
		this.setitem(1, "to_yymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('ǰ��', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('ǰ��', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('�԰�', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('ǰ��', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('ǰ��', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('�԰�', 'N', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "saupj"	THEN
	sSaupj = trim(this.GetText())
	//�԰�â�� 
	f_child_saupj(dw_ip, 'sdepot', sSaupj)
END IF
end event

type dw_list from w_standard_print`dw_list within w_mat_03540_old
integer x = 46
integer y = 400
integer width = 4562
integer height = 1920
string dataobject = "d_mat_03540_1"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	dw_list.SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type rr_1 from roundrectangle within w_mat_03540_old
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 52
integer width = 3698
integer height = 312
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_03540_old
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 392
integer width = 4581
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

