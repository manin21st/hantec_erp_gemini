$PBExportHeader$w_pdt_00130.srw
$PBExportComments$** �� ���ּҿ䷮����
forward
global type w_pdt_00130 from w_inherite
end type
type gb_3 from groupbox within w_pdt_00130
end type
type gb_2 from groupbox within w_pdt_00130
end type
type dw_1 from datawindow within w_pdt_00130
end type
type dw_hidden from datawindow within w_pdt_00130
end type
type rr_4 from roundrectangle within w_pdt_00130
end type
end forward

global type w_pdt_00130 from w_inherite
integer height = 2496
string title = "�� ���� �ҿ䷮����"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
dw_hidden dw_hidden
rr_4 rr_4
end type
global w_pdt_00130 w_pdt_00130

type variables
string ls_text, is_pspec, is_jijil
end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public subroutine wf_setnull ()
end prototypes

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'cvcod')) or &
	dw_insert.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� �ŷ�ó]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('cvcod')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = "" then
	f_message_chk(1400,'[ '+string(i)+' �� ǰ��]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if

Return 1
end function

public subroutine wf_reset ();string syymm
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)


//������� �´� ���������� �����´�. Ȯ����ȹ�� ������ ������ȹ�� �������� ���ϰ� 
//   											 ������ȹ�� ������ Ȯ����ȹ�� ���ҿ��� ���Ѵ�.	
syymm = left(is_today,6)

dw_1.setitem(1, 'syymm', syymm )

SELECT MAX("MONPLN_OUT"."MOSEQ")  
  INTO :get_yeacha  
  FROM "MONPLN_OUT"  
 WHERE ( "MONPLN_OUT"."SABU" = :gs_sabu ) AND ( "MONPLN_OUT"."MONYYMM" = :syymm ) ;

if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

dw_1.setitem(1, 'jjcha', get_yeacha )
dw_1.setfocus()

//dw_insert.DataObject ="d_pdt_00130_1" 
dw_insert.SetTransObject(SQLCA)

dw_1.setredraw(true)
dw_insert.setredraw(true)

/* �ΰ� ����� */
f_mod_saupj(dw_1, 'saupj')

end subroutine

public subroutine wf_setnull ();string snull
long   lrow

setnull(snull)

lrow   = dw_insert.getrow()

dw_insert.setitem(lrow, "itnbr", snull)	
dw_insert.setitem(lrow, "itdsc", snull)	
dw_insert.setitem(lrow, "ispec", snull)



end subroutine

on w_pdt_00130.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.dw_hidden=create dw_hidden
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_hidden
this.Control[iCurrent+5]=this.rr_4
end on

on w_pdt_00130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.dw_hidden)
destroy(this.rr_4)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_hidden.SetTransObject(sqlca)
dw_1.insertrow(0)

wf_reset()


end event

event key;// Page Up & Page Down & Home & End Key ��� ����
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_00130
integer x = 23
integer y = 540
integer width = 4581
integer height = 1736
integer taborder = 20
string dataobject = "d_pdt_00130_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, syymm, get_itnbr, splym, steam, scvcod 
integer  ireturn, iseq
long     lrow, lreturnrow
decimal  dItemPrice    //���ϴܰ�

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   = this.getrow()
syymm  = dw_1.getitemstring(1, 'syymm')
steam   = dw_1.getitemstring(1, 'steam')
iseq   = dw_1.getitemnumber(1, 'jjcha')
splym  = this.getitemstring(lrow, 'plnyymm')

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	scvcod = getitemstring(Lrow, "cvcod")

   if sitnbr = "" or isnull(sitnbr) then
		wf_setnull()
		return 
   end if	
   //��ü ����Ÿ �����쿡�� ���� ǰ���� üũ
	lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[ǰ��]') 
		wf_setnull()
		RETURN  1
	END IF
	//��ϵ� �ڷῡ�� �ߺ� üũ
  SELECT "MONPLN_OUT"."ITNBR"  
    INTO :get_itnbr  
    FROM "MONPLN_OUT"  
   WHERE ( "MONPLN_OUT"."SABU" = :gs_sabu ) AND  
         ( "MONPLN_OUT"."MONYYMM" = :syymm ) AND  
         ( "MONPLN_OUT"."PLNYYMM" = :splym ) AND  
         ( "MONPLN_OUT"."MOSEQ" = :iseq )   AND
         ( "MONPLN_OUT"."CVCOD" = :scvcod )   AND			
         ( "MONPLN_OUT"."ITNBR" = :sitnbr ) ;


   if sqlca.sqlcode <> 0 then 
		ireturn = f_get_name2('ǰ��', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
		this.setitem(lrow, "itnbr", sitnbr)	
		this.setitem(lrow, "itdsc", sitdsc)	
		this.setitem(lrow, "ispec", sispec)

		IF ireturn = 0 then
			//�������� ��ϵǿ����� üũ
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('Ȯ��', ls_text ) 
   			wf_setnull()
				RETURN 1
			END IF
      END IF
		RETURN ireturn
	else
		f_message_chk(37,'[ǰ��]') 
		wf_setnull()
		RETURN 1
	end if	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
   if sitdsc = "" or isnull(sitdsc) then
		wf_setnull()
		return 
   end if	
	
	scvcod = getitemstring(Lrow, "cvcod")

	ireturn = f_get_name2('ǰ��', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   if ireturn = 0 then 
	   //��ü ����Ÿ �����쿡�� ���� ǰ���� üũ
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN  1
		END IF
		
  SELECT "MONPLN_OUT"."ITNBR"  
    INTO :get_itnbr  
    FROM "MONPLN_OUT"  
   WHERE ( "MONPLN_OUT"."SABU" = :gs_sabu ) AND  
         ( "MONPLN_OUT"."MONYYMM" = :syymm ) AND  
         ( "MONPLN_OUT"."PLNYYMM" = :splym ) AND  
         ( "MONPLN_OUT"."MOSEQ" = :iseq )   AND
         ( "MONPLN_OUT"."CVCOD" = :scvcod )   AND			
         ( "MONPLN_OUT"."ITNBR" = :sitnbr ) ;
	
 		if sqlca.sqlcode = 0 then 
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN 1
      else
			//�������� ��ϵǿ����� üũ
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('Ȯ��', ls_text ) 
   			wf_setnull()
				RETURN 1
			END IF
      end if	
   end if		
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
   if sispec = "" or isnull(sispec) then
		wf_setnull()
		return 
   end if	

	ireturn = f_get_name2('�԰�', 'Y', sitnbr, sitdsc, sispec)    //1�̸� ����, 0�� ����	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   if ireturn = 0 then 
		//��ü ����Ÿ �����쿡�� ���� ǰ���� üũ
		lReturnRow = This.Find("itnbr = '"+sitnbr+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN  1
		END IF

	scvcod = getitemstring(Lrow, "cvcod")

		//��ϵ� �ڷῡ�� üũ
  SELECT "MONPLN_OUT"."ITNBR"  
    INTO :get_itnbr  
    FROM "MONPLN_OUT"  
   WHERE ( "MONPLN_OUT"."SABU" = :gs_sabu ) AND  
         ( "MONPLN_OUT"."MONYYMM" = :syymm ) AND  
         ( "MONPLN_OUT"."PLNYYMM" = :splym ) AND  
         ( "MONPLN_OUT"."MOSEQ" = :iseq )   AND
         ( "MONPLN_OUT"."CVCOD" = :scvcod )   AND			
         ( "MONPLN_OUT"."ITNBR" = :sitnbr ) ;
	
 		if sqlca.sqlcode = 0 then 
			f_message_chk(37,'[ǰ��]') 
			wf_setnull()
			RETURN 1
      else
			//�������� ��ϵǿ����� üũ
 		   SELECT "ITEMAS"."ITNBR"  
			  INTO :get_itnbr  
			  FROM "ITEMAS", "ITNCT"  
			 WHERE ( "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" ) and  
					 ( "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" ) and  
					 ( ( "ITEMAS"."ITNBR" = :sitnbr ) AND  
					 ( "ITNCT"."PDTGU" = :steam ) )   ;

			IF SQLCA.SQLCODE <> 0 THEN 
				messagebox('Ȯ��', ls_text ) 
   			wf_setnull()
				RETURN 1
			END IF
      end if	
   end if		
	RETURN ireturn
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
ElseiF this.GetcolumnName() ="cvcod" THEN
	Open(w_vndmst_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"vndmst",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1	
END IF
end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

type p_delrow from w_inherite`p_delrow within w_pdt_00130
integer x = 3918
boolean enabled = false
string picturename = "C:\erpman\image\�����_d.gif"
end type

event p_delrow::clicked;call super::clicked;Integer i, irow, irow2
string s_yymm, s_toym

if dw_1.AcceptText() = -1 then return 

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then return 	


s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("Ȯ��", "���� ���� ��� �ڷ�� ������ �� �����ϴ�!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_pdt_00130
integer x = 3744
boolean enabled = false
string picturename = "C:\erpman\image\���߰�_d.gif"
end type

event p_addrow::clicked;call super::clicked;string s_team, s_yymm, s_plym, s_toym, scvcod, scvname
Int    i_seq, i_plym
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_team = dw_1.GetItemString(1,'steam')
s_yymm = trim(dw_1.GetItemString(1,'syymm'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')
s_team = dw_1.GetItemString(1,'steam')
i_plym  = dw_1.GetItemNumber(1,'plan_ym')

scvcod  = dw_1.GetItemString(1,'cvcod')
scvname = dw_1.GetItemString(1,'cvname')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

if isnull(scvcod) or scvcod = "" then
	f_message_chk(30,'[�ŷ�ó]')
	dw_1.Setcolumn('scvcod')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("Ȯ��", "���� ���� ����� �߰��� �� �����ϴ�!!")

	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[��������]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

if isnull(i_plym) then
	f_message_chk(30,'[��ȹ���]')
	dw_1.Setcolumn('plan_ym')
	dw_1.SetFocus()
	return
else
	s_plym = f_aftermonth(s_yymm, i_plym)   //���س���� ��ȹ����� ���Ͽ� ���� ��ȹ�����...
end if	

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[������]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

dw_insert.SetRedraw(false)

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'monyymm', s_yymm )
dw_insert.setitem(il_currow, 'plnyymm', s_plym )
dw_insert.setitem(il_currow, 'moseq', i_seq )
dw_insert.setitem(il_currow, 'cvcod',  scvcod )

dw_insert.ScrollToRow(il_currow)

dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_insert.SetRedraw(true)
ib_any_typing =True
dw_1.enabled = false

p_search.enabled = false
p_search.PictureName = 'C:\erpman\image\����_d.gif'

end event

type p_search from w_inherite`p_search within w_pdt_00130
boolean visible = false
integer x = 1760
integer y = 2424
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_search::ue_lbuttonup;call super::ue_lbuttonup;p_search.picturename = 'C:\erpman\image\����_up.gif'
end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;p_search.picturename = 'C:\erpman\image\����_dn.gif'
end event

type p_ins from w_inherite`p_ins within w_pdt_00130
boolean visible = false
integer x = 3264
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_00130
end type

type p_can from w_inherite`p_can within w_pdt_00130
end type

event p_can::clicked;call super::clicked;wf_reset()

dw_1.enabled = true
p_search.enabled = true
p_search.PictureName = 'C:\erpman\image\����_up.gif'

ib_any_typing = FALSE

p_addrow.PictureName = 'C:\erpman\image\���߰�_d.gif'
p_delrow.PictureName = 'C:\erpman\image\�����_d.gif'
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
p_addrow.enabled = false
p_delrow.enabled = false
p_mod.enabled = false

dw_1.setfocus()

end event

type p_print from w_inherite`p_print within w_pdt_00130
integer x = 37
integer y = 32
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_print::clicked;call super::clicked;string s_yymm

if dw_1.AcceptText() = -1 then return 
s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[��ȹ���]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if

gs_code = s_yymm

Open(w_pdt_01015)


end event

event p_print::ue_lbuttondown;call super::ue_lbuttondown;this.picturename = 'C:\erpman\image\����_dn.gif'
end event

event p_print::ue_lbuttonup;call super::ue_lbuttonup;this.picturename = 'C:\erpman\image\����_up.gif'
end event

type p_inq from w_inherite`p_inq within w_pdt_00130
integer x = 3570
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_yymm, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr, &
       s_plym, s_lastday, ssaupj, scvcod
Int    i_seq, i_plym
LONG Lrow

if dw_1.AcceptText() = -1 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))
s_team = dw_1.GetItemString(1,'steam')
i_seq  = dw_1.GetItemNumber(1,'jjcha')
i_plym  = dw_1.GetItemNumber(1,'plan_ym')
ssaupj  = trim(dw_1.GetItemString(1,'saupj'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[��������]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

if isnull(i_plym) then
	f_message_chk(30,'[��ȹ���]')
	dw_1.Setcolumn('plan_ym')
	dw_1.SetFocus()
	return
else
	s_plym = f_aftermonth(s_yymm, i_plym)   //���س���� ��ȹ����� ���Ͽ� ���� ��ȹ�����...
end if	

// �Ϻ� �����ȹ�� ������ �ȵǾ� ������ ���ְ�ȹ�� ������ �� ����
Lrow = 0
SELECT COUNT(*) INTO :LROW
 FROM "MONPLN_DTL"  
WHERE ( "MONPLN_DTL"."SABU" = :gs_sabu ) AND  
		( "MONPLN_DTL"."MONYYMM" = :s_yymm ) AND  
		( "MONPLN_DTL"."PLNYYMM" = :s_plym ) AND  
		( "MONPLN_DTL"."MOSEQ" = :i_seq ) ;
If sqlca.sqlcode <> 0  or Lrow = 0 then
	MessageBox("�� �����ȹ", "�� �����ȹ�� �����ϴ�", stopsign!)
	return
End if

// ���ְ�ȹ�� ���ʷ� �����ϴ� ��쿡�� �ڵ����� �����Ѵ�.
Lrow = 0
SELECT COUNT(*) INTO :LROW
 FROM "MONPLN_OUT"  
WHERE ( "MONPLN_OUT"."SABU" = :gs_sabu ) AND  
		( "MONPLN_OUT"."MONYYMM" = :s_yymm ) AND  
		( "MONPLN_OUT"."PLNYYMM" = :s_plym ) AND  
		( "MONPLN_OUT"."MOSEQ" = :i_seq ) ;
IF Lrow = 0 then
	MessageBox("���ְ�ȹ", "���ְ�ȹ�� �����ϴ�" + '~n' + &
								  "�Ϻ� �����ȹ�� �������� ���ְ�ȹ�� �ڵ�����" + '~n' + &
								  "�����մϴ�", information!)
	Insert into monpln_out
		Select sabu, monyymm, plnyymm, moseq, fun_danmst_danga4(itnbr, '.','9999'), itnbr,
				 monqty201,monqty202,monqty203,monqty204,monqty205,monqty206,monqty207,monqty208,monqty209,monqty210,
				 monqty211,monqty212,monqty213,monqty214,monqty215,monqty216,monqty217,monqty218,monqty219,monqty220,
				 monqty221,monqty222,monqty223,monqty224,monqty225,monqty226,monqty227,monqty228,monqty229,monqty230,monqty231
		  from monpln_dtl
		 where sabu = :gs_sabu and monyymm = :s_yymm and plnyymm = :s_plym and moseq = :i_seq;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("����", "���ֻ����ȹ ������ �����Ͽ����ϴ�", stopsign!)
		return
	End if
	
	commit;
	
End if

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[������]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

scvcod   = dw_1.GetItemString(1,'cvcod')
if isnull(scvcod) or scvcod = "" then
	f_message_chk(30,'[�ŷ�ó]')
	dw_1.Setcolumn('cvcod')
	dw_1.SetFocus()
	return
end if	

s_ittyp   = dw_1.GetItemString(1,'sittyp')
if isnull(s_ittyp) or s_ittyp = "" then
	s_ittyp = '%'
end if	
s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
if isnull(s_fritcls) or s_fritcls = "" then
    s_fritcls = '.'
end if	
s_toitcls = trim(dw_1.GetItemString(1,'to_itcls'))
if isnull(s_toitcls) or s_toitcls = "" then
   s_toitcls = 'zzzzzzz'
end if	
if s_fritcls > s_toitcls then 
	f_message_chk(34,'[ǰ��з�]')
	dw_1.Setcolumn('fr_itcls')
	dw_1.SetFocus()
	return
end if
s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
if isnull(s_fritnbr) or s_fritnbr = "" then
	s_fritnbr = '.'
end if	
s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))
if isnull(s_toitnbr) or s_toitnbr = "" then
	s_toitnbr = 'zzzzzzzzzzzzzzz'
end if	
if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[ǰ��]')
	dw_1.Setcolumn('fr_itnbr')
	dw_1.SetFocus()
	return
end if	
	
//��ȹ����� ���������ڸ� ��������
s_lastday = right(f_last_date(s_plym), 2)
if dw_insert.Retrieve(gs_sabu,s_team,s_yymm,i_seq,s_plym, i_plym, s_lastday, &
							 ssaupj, scvcod, s_ittyp,s_fritcls,s_toitcls, s_fritnbr, s_toitnbr) <= 0 then 
	f_message_chk(50,'')
	dw_1.SetFocus()
	p_addrow.enabled = true
	p_addrow.PictureName = 'C:\erpman\image\���߰�_up.gif'
	
	p_delrow.enabled = true
	p_delrow.PictureName = 'C:\erpman\image\�����_up.gif'
	return
end if	

dw_insert.SetFocus()
dw_1.enabled = false
ib_any_typing = FALSE

p_search.enabled = false
p_addrow.enabled = true
p_delrow.enabled = true
p_search.PictureName = 'C:\erpman\image\����_d.gif'
p_addrow.PictureName = 'C:\erpman\image\���߰�_up.gif'
p_delrow.PictureName = 'C:\erpman\image\�����_up.gif'

end event

type p_del from w_inherite`p_del within w_pdt_00130
boolean visible = false
integer x = 1938
integer y = 2424
end type

type p_mod from w_inherite`p_mod within w_pdt_00130
integer x = 4091
end type

event p_mod::clicked;call super::clicked;string s_yymm, s_toym
long   i

if dw_1.AcceptText() = -1 then return 

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 

s_yymm = trim(dw_1.GetItemString(1,'syymm'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[���س��]')
	dw_1.Setcolumn('syymm')
	dw_1.SetFocus()
	return
end if	

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then
	messagebox("Ȯ��", "���� ���� ��� �ڷ�� ������ �� �����ϴ�!!")
	dw_1.setcolumn('syymm')
	dw_1.setfocus()
	return 
end if		

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	sle_msg.text = "�ڷᰡ ����Ǿ����ϴ�!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("�������", "�ڷῡ ���� ������ �����Ͽ����ϴ�")
	return 
end if	
		
p_inq.TriggerEvent(clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_00130
integer x = 3831
integer y = 2512
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_pdt_00130
integer x = 2181
integer y = 2544
integer taborder = 70
end type

type cb_ins from w_inherite`cb_ins within w_pdt_00130
integer x = 1422
integer y = 2544
integer taborder = 60
boolean enabled = false
string text = "�߰�(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_00130
integer x = 2533
integer y = 2544
integer taborder = 80
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_00130
integer x = 1070
integer y = 2544
end type

type cb_print from w_inherite`cb_print within w_pdt_00130
integer x = 590
integer y = 2544
integer width = 462
integer taborder = 40
string text = "����ó��"
end type

type st_1 from w_inherite`st_1 within w_pdt_00130
end type

type cb_can from w_inherite`cb_can within w_pdt_00130
integer x = 3387
integer y = 2528
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_pdt_00130
integer x = 110
integer y = 2544
integer width = 462
integer taborder = 30
string text = "�������ȹ"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_00130
integer x = 9
integer y = 2580
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_00130
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_00130
end type

type gb_3 from groupbox within w_pdt_00130
boolean visible = false
integer x = 2135
integer y = 2484
integer width = 1481
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdt_00130
boolean visible = false
integer x = 64
integer y = 2484
integer width = 1733
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_pdt_00130
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 5
integer y = 188
integer width = 4626
integer height = 284
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_00130_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;IF this.GetColumnName() ="sgub" THEN RETURN

Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "fr_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"fr_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "to_itnbr" Then
			open(w_itemas_popup2)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"to_itnbr",gs_code)
			RETURN 1
		ELSEIF This.GetColumnName() = "fr_itcls" Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return 
			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
					 str_sitnct.s_ittyp = '7' THEN //1����ǰ, 2����ǰ, 7��ǰ  
				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
				this.SetItem(1,"fr_itcls", str_sitnct.s_sumgub)
				RETURN 1
 			else
				f_message_chk(61,'[ǰ�񱸺�]')
				return 1
			end if	
		ELSEIF This.GetColumnName() = "to_itcls" Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return 
			elseif str_sitnct.s_ittyp = '1' or str_sitnct.s_ittyp = '2' or &
					 str_sitnct.s_ittyp = '7' THEN //1����ǰ, 2����ǰ, 7��ǰ  
				this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
				this.SetItem(1,"to_itcls", str_sitnct.s_sumgub)
	   		RETURN 1
 			else
				f_message_chk(61,'[ǰ�񱸺�]')
				return 1
			end if	
      End If
END IF

end event

event itemchanged;string snull, syymm, s_name, s_itt, s_curym, s_gub,steam, steamnm, stitnm, stextnm
int    iseq, inull, get_yeacha, i

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="steam" THEN
	steam = trim(this.GetText())
	setnull(ls_text)
	
	if dw_hidden.retrieve(steam) < 1 then
		messagebox("Ȯ��", '�������� ǰ���� �������� �ʽ��ϴ�. �������� Ȯ���ϼ���!')
		this.setitem(1, 'steam', snull)
		return 1 
	else
		steamnm = dw_hidden.getitemstring(1, 'teamnm')
	   FOR i=1 TO dw_hidden.rowcount()
			 stitnm  = dw_hidden.getitemstring(i, 'titnm')
          if i = 1 then
   			 stextnm = stitnm
			 else
				 stextnm = stextnm + ',' + '~n' + stitnm
 	 		 end if	 
		NEXT
      ls_text =  '������ ' + steamnm + ' ��(��) ' + '��з��� ' + '~n' &
		           + stextnm + ' ��' + '~n' + 'ǰ�� �Է°����մϴ�.'
   end if
ELSEIF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then
  		this.setitem(1, 'jjcha', 1)
		return 
	end if	

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[��ȹ���]')
		this.setitem(1, "syymm", sNull)
  		this.setitem(1, 'jjcha', 1)
		return 1
	END IF
	
	s_curym = left(f_today(), 6)
	
	SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
	  FROM "MONPLN_SUM"  
	 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

	if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

	dw_1.setitem(1, 'jjcha', get_yeacha )
ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq  = integer(this.gettext())
   syymm = trim(this.getitemstring(1, 'syymm'))
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syymm = "" or isnull(syymm) then 
		messagebox("Ȯ��", "��ȹ����� ���� �Է� �Ͻʽÿ�!!")
  		this.setitem(1, 'jjcha', inull)
		this.setcolumn('syymm')
		this.setfocus()
		return 1
	end if		
   SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
     FROM "MONPLN_SUM"  
    WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;
   
	//Ȯ����ȹ�� ���� ��� ������ȹ�� �Է��� �� ����
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("Ȯ��", left(syymm,4)+"�� "+mid(syymm,5,2)+"���� Ȯ��/������ȹ�� ������ " &
			                   + "Ȯ���� �Է°����մϴ�!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	//������ȹ�� �ִ� ��� Ȯ����ȹ�� �Է��� �� ����.	
	elseif get_yeacha = 2 then
		if iseq = 1 then
   		messagebox("Ȯ��", left(syymm,4)+"�� "+mid(syymm,5,2)+"���� ������ȹ�� ������ " &
			                   + "Ȯ���� �Է��� �� �����ϴ�!!")
	  		this.setitem(1, 'jjcha', 2)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
		end if		
   end if		
ELSEIF this.GetColumnName() = 'sittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[ǰ�񱸺�]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   ELSEIF s_itt = '1' or s_itt = '2' or s_itt = '7' THEN //1����ǰ, 2����ǰ, 7��ǰ  
   ELSE 	
		f_message_chk(61,'[ǰ�񱸺�]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   END IF	
ELSEIF this.GetColumnName() = 'cvcod' THEN
	s_itt = this.gettext()	
	
	i = f_get_name2('V1', 'Y', s_itt, stitnm, stextnm)    //1�̸� ����, 0�� ����		
	if i = 0 then
		setitem(1, "cvname", stitnm)
	Else
		setitem(1, "cvcod", snull)
		setitem(1, "cvname", snull)
	End if
	return i
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string snull, sname
str_itnct lstr_sitnct

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'fr_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '7' THEN //1����ǰ, 2����ǰ, 7��ǰ  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fr_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[ǰ�񱸺�]')
		return 1
 	end if	
elseif this.GetColumnName() = 'to_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '7' THEN //1����ǰ, 2����ǰ, 7��ǰ  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"to_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[ǰ�񱸺�]')
		return 1
 	end if	
elseif this.GetColumnName() = 'cvcod' then
   this.accepttext()
	Open(w_vndmst_popup)
	setitem(1, "cvcod", gs_code)
	triggerevent(itemchanged!)
end if	

end event

event losefocus;//this.accepttext()
end event

type dw_hidden from datawindow within w_pdt_00130
boolean visible = false
integer x = 997
integer y = 2384
integer width = 494
integer height = 360
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_pdt_01000_9"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_4 from roundrectangle within w_pdt_00130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 532
integer width = 4613
integer height = 1772
integer cornerheight = 40
integer cornerwidth = 55
end type

