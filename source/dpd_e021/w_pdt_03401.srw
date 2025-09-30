$PBExportHeader$w_pdt_03401.srw
$PBExportComments$�۾����� �������� ����
forward
global type w_pdt_03401 from window
end type
type p_mod from uo_picture within w_pdt_03401
end type
type p_inq from uo_picture within w_pdt_03401
end type
type p_can from uo_picture within w_pdt_03401
end type
type p_exit from uo_picture within w_pdt_03401
end type
type st_4 from statictext within w_pdt_03401
end type
type st_3 from statictext within w_pdt_03401
end type
type st_2 from statictext within w_pdt_03401
end type
type st_1 from statictext within w_pdt_03401
end type
type dw_holdstock from datawindow within w_pdt_03401
end type
type dw_5 from datawindow within w_pdt_03401
end type
type dw_4 from datawindow within w_pdt_03401
end type
type cb_3 from commandbutton within w_pdt_03401
end type
type dw_3 from datawindow within w_pdt_03401
end type
type dw_2 from datawindow within w_pdt_03401
end type
type dw_1 from datawindow within w_pdt_03401
end type
type rr_1 from roundrectangle within w_pdt_03401
end type
type rr_2 from roundrectangle within w_pdt_03401
end type
type rr_3 from roundrectangle within w_pdt_03401
end type
type rr_5 from roundrectangle within w_pdt_03401
end type
end forward

global type w_pdt_03401 from window
integer x = 9
integer y = 12
integer width = 3552
integer height = 2252
boolean titlebar = true
string title = "�۾����� ���� ����"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_mod p_mod
p_inq p_inq
p_can p_can
p_exit p_exit
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
dw_holdstock dw_holdstock
dw_5 dw_5
dw_4 dw_4
cb_3 cb_3
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_5 rr_5
end type
global w_pdt_03401 w_pdt_03401

type variables
string is_update = 'N'
end variables

forward prototypes
public function integer wf_qty_check ()
public function integer wf_holdstock_create ()
public function integer wf_pordno (string spordno)
public subroutine wf_reset ()
end prototypes

public function integer wf_qty_check ();string spordno
dec{3} dqty, dold_qty, diqty, dqty1, dqty2
long   lrow

spordno   = dw_1.getitemstring(1, 'pordno')
dqty      = dw_1.getitemdecimal(1, 'pdqty')
dold_qty  = dw_1.getitemdecimal(1, 'old_pdqty')

// 1) ���� ���� üũ
For Lrow = dw_5.rowcount() to 1 step -1
	 diqty = dw_5.getitemdecimal(Lrow, "totqty")
    
    if lrow = dw_5.rowcount() and dqty < diqty then 
		 MessageBox("�������", "���� ������� �հ谡 ���ü������� Ů�ϴ�. ������ Ȯ���ϼ���!")
		 dw_5.setfocus()
		 return -1
	 END IF

	 IF dw_5.getitemdecimal(Lrow, "momord_sqty") <= 0 THEN 
		 dw_5.deleterow(lrow) 
	 END IF
Next


// 3) �Ҵ� ���� üũ
if dw_4.rowcount() > 0 then 
	dqty1 = dw_4.getitemdecimal(1, "totqty")  //�Ҵ����
else
	dqty1 = 0
end if

if dw_3.rowcount() > 0 then 
	dqty2 = dw_3.getitemdecimal(1, "totqty")  //�Ҵ����
else
	dqty2 = 0
end if

if dqty < ( dqty1 + dqty2 ) then 
   MessageBox("�������", "�Ҵ� �� ������ + �Ҵ���� �� ���� ���ü������� Ů�ϴ�. ������ Ȯ���ϼ���!")
   dw_3.setfocus()
	return -1
END IF

For Lrow = dw_4.rowcount() to 1 step -1
	 IF dw_4.getitemdecimal(Lrow, "hold_qty") <= 0 THEN 
		 dw_4.deleterow(lrow) 
	 END IF
Next

return 1

end function

public function integer wf_holdstock_create ();dec{3} dqty, dsumqty
Int    ij = 0
String sitnbr, spspec, sDepot_no, sCode, sPordno, sHold_depot, sPdtgu, sbuseo, sToday, sholdno, sOpseq
Long   Lrow, lcount, k

dw_holdstock.reset()

spordno   = dw_1.getitemstring(1, 'pordno')
sToday = f_today()

lcount = dw_3.rowcount()
FOR k = 1 TO lcount
	dqty = dw_3.getitemdecimal(k, 'yqty')
	if dqty > 0 then //�Ҵ����
		lrow   = dw_holdstock.insertrow(0)

		if ij = 0 then 
			iJ = sqlca.fun_junpyo(gs_sabu, stoday, 'B0')
			if iJ < 1 then
				f_message_chk(51,'[�Ҵ��ȣ]') 
				rollback;
				return -1
			end if
				
			sholdno = stoday + String(iJ, '0000')	
		end if
		
		/* ����â�� ����ûâ��� �Ѵ�. */
		sHold_depot  = dw_3.getitemstring(k, "stock_depot_no")
		spspec 	    = dw_3.getitemstring(k, "stock_pspec")
		
		if sitnbr = '' or isnull(sitnbr) then 
			sItnbr = dw_3.getitemstring(k, "stock_itnbr") //����ǰ ǰ��

			// ���䱸���� �۾��������ڸ� �������� ��
			Select fsdat, pdtgu
			  into :sCode, :spdtgu 
			  From momast where sabu = :gs_sabu And pordno = :sPordno;
			if IsNull( sCode ) or Trim( sCode ) = '' then sCode = stoday
		
			//ù��° �����ڵ带 �Է��Ѵ�.
			Select Min(opseq) into :sOpseq From morout where sabu = :gs_sabu And pordno = :sPordno;
			if IsNull(sOpseq) or Trim(sOpseq) = '' then 
				 rollback;
				 MessageBox("����", "ù��° ������ �˻��� �� �����ϴ�", stopsign!)
				 return -1
			End if

			// 2001/05/11 �� �߰� ==> ����â�� �ֿ켱���� �߰� 
			select depot_no 
			  into :sdepot_no
			  from routng
			 where itnbr = :sItnbr and opseq = :sopseq ;			
		
		   if isnull(sdepot_no) or sdepot_no = '' then 
				Select cvcod, 		 deptcode
				  into :sdepot_no, :sbuseo
				  from vndmst
				 where cvgu = '5' and jumaeip = :spdtgu and rownum = 1;
			else
				Select deptcode
				  into :sbuseo
				  from vndmst
				 where cvcod = :sdepot_no ;
		   end if
			
			if isnull(sdepot_no) or trim(sDepot_no) = '' then
				rollback;
				Messagebox("â��", "����â�� �˻��� �� �����ϴ�", stopsign!)
				return -1
			end if
		End if
			 

		dw_holdstock.setitem(Lrow, "sabu",       	 gs_sabu)
		dw_holdstock.setitem(Lrow, "hold_no",    	 sholdno + string(Lrow, '000'))
		dw_holdstock.setitem(Lrow, "hold_date",  	 sToday)
		dw_holdstock.setitem(Lrow, "hold_gu",    	 'O03')
		dw_holdstock.setitem(Lrow, "itnbr",      	 sItnbr)
		dw_holdstock.setitem(Lrow, "pspec",     	 spspec)
		dw_holdstock.setitem(Lrow, "hold_qty",  	 dqty)
		dw_holdstock.setitem(Lrow, "hold_store", 	 sHold_depot)
		dw_holdstock.setitem(Lrow, "out_store",  	 sDepot_no)  
		dw_holdstock.setitem(Lrow, "req_dept",     sBuseo)
		
		dw_holdstock.setitem(Lrow, "rqdat",       scode)	 
		dw_holdstock.setitem(Lrow, "pordno",      sPordno)
		dw_holdstock.setitem(Lrow, "out_chk",     '1')
		dw_holdstock.setitem(Lrow, "naougu",      '1')	 
		dw_holdstock.setitem(Lrow, "hosts",       'N')
				 
		dw_holdstock.setitem(Lrow, "opseq",			sOpseq)
		dw_holdstock.setitem(Lrow, "crt_user",		gs_userid)
		dw_holdstock.setitem(Lrow, "buwan",			'N')
		dw_holdstock.setitem(Lrow, "hyebia4",		'Y')

      dsumqty = dsumqty + dqty
	end if
NEXT

IF dsumqty > 0 then 
	If dw_holdstock.update() <> 1 then
		rollback;
		f_message_chk(32, "[�Ҵ系��]")
		return -1
	End if
End if

return 1

end function

public function integer wf_pordno (string spordno);string sitnbr, sNull
dec{3} dqty, drelqty

SetNull(sNull)

Select pdqty 
  into :dqty 
  from momast
 Where sabu   = :gs_sabu 
   And pordno = :sPordno ;
 
if sqlca.sqlcode <> 0 then
	MessageBox("Ȯ ��", "�۾����� ��ȣ�� Ȯ���ϼ���", stopsign!)
	return -1
end if

select a.itnbr 
  into :sitnbr
  from holdstock a, itemas b
 where a.itnbr  = b.itnbr
   and a.sabu   = :gs_sabu
	and a.pordno = :sPordno 
	and b.ittyp  = '2' 
	and rownum   = 1 ;

dw_1.setitem(1, "itnbr", sitnbr)
dw_1.setitem(1, "pdqty", dqty)
dw_1.setitem(1, "old_pdqty", dqty)

//cb_2.enabled = false
p_mod.enabled = false
p_mod.PictureName = 'C:\erpman\image\����_d.gif'
cb_3.enabled = false

dw_2.reset()
dw_3.reset()
dw_4.reset()
dw_5.reset()

return 1


end function

public subroutine wf_reset ();//cb_1.enabled = True
p_inq.enabled = true
p_inq.PictureName = 'C:\erpman\image\��ȸ_up.gif'

//cb_2.enabled = false
 p_mod.enabled = false
 p_mod.PictureName = 'C:\erpman\image\����_d.gif'
	 
//cb_3.enabled = false

dw_1.setredraw(false)
dw_1.reset()
dw_2.reset()
dw_3.reset()
dw_4.reset()
dw_5.reset()
dw_1.insertrow(0)
dw_1.setredraw(true)

dw_1.setfocus()


end subroutine

on w_pdt_03401.create
this.p_mod=create p_mod
this.p_inq=create p_inq
this.p_can=create p_can
this.p_exit=create p_exit
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_holdstock=create dw_holdstock
this.dw_5=create dw_5
this.dw_4=create dw_4
this.cb_3=create cb_3
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_5=create rr_5
this.Control[]={this.p_mod,&
this.p_inq,&
this.p_can,&
this.p_exit,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.dw_holdstock,&
this.dw_5,&
this.dw_4,&
this.cb_3,&
this.dw_3,&
this.dw_2,&
this.dw_1,&
this.rr_1,&
this.rr_2,&
this.rr_3,&
this.rr_5}
end on

on w_pdt_03401.destroy
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.p_can)
destroy(this.p_exit)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_holdstock)
destroy(this.dw_5)
destroy(this.dw_4)
destroy(this.cb_3)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_5)
end on

event open;f_window_center_response(this)

dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)
dw_5.settransobject(sqlca)
dw_holdstock.settransobject(sqlca)

dw_1.insertrow(0)
dw_1.setfocus()

if gs_code > '.' then 
	dw_1.setitem(1, 'pordno', gs_code)
	wf_pordno(gs_Code)
end if
end event

type p_mod from uo_picture within w_pdt_03401
integer x = 2994
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event clicked;call super::clicked;string sPordno
Dec {3} dQty

if dw_1.accepttext() = -1 then return
if dw_3.accepttext() = -1 then return
if dw_4.accepttext() = -1 then return
if dw_5.accepttext() = -1 then return

if wf_qty_check() = -1 then return
if f_msg_update() = -1 then return

sPordno = dw_1.getitemstring(1, 'pordno')
dqty    = dw_1.getitemdecimal(1, 'pdqty')

//���ü��� ����
UPDATE MOMAST  
   SET PDQTY = :dqty
 WHERE SABU = :gs_sabu AND PORDNO = :sPordno ;

if sqlca.sqlcode = 0 and SQLCA.SQLNROWS > 0 then 
	if dw_5.update() = 1 then
		if dw_4.update() = 1 then
			if wf_holdstock_create() = -1 then return 
			commit;
		Else 
			rollback;
			MessageBox("�������", "�Ҵ���� ������ �����߻�", stopsign!)
			return
		end if
	Else
		rollback;
		MessageBox("�������", "���� ���᳻�� ������ �����߻�", stopsign!)
		return
	end if
else
	rollback;
	MessageBox("�������", "���ü��� ������ �����߻�", stopsign!)
	return
end if

is_update = 'Y' 
p_can.triggerevent(clicked!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\����_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\����_dn.gif'
end event

type p_inq from uo_picture within w_pdt_03401
integer x = 2821
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\��ȸ_up.gif"
end type

event clicked;string sPordno, sitnbr
Long   Lcnt

if dw_1.accepttext() = -1 then return

sPordno = dw_1.getitemstring(1, "pordno")
sitnbr  = dw_1.getitemstring(1, "itnbr")

if IsNull( sPordno ) or trim( sPordno ) = '' then
	MessageBox("Ȯ��", "���� ������ȣ�� �Է��Ͻʽÿ�", stopsign!)
	dw_1.setfocus()
	return
end if

dw_5.retrieve(gs_sabu, sPordno)
dw_2.retrieve(gs_sabu, sPordno)
dw_4.retrieve(gs_sabu, sPordno)
dw_3.retrieve(gs_sabu, sPordno)
	
 // �����Ƿ� ���°� '1','4'�� ��쿡�� ���	
 Lcnt = 0
 Select count(*) into :Lcnt From Estima 
  where sabu  = :gs_sabu And pordno = :sPordno And blynd IN ('2', '3');
	 
 if lcnt > 0  then
	 Messagebox("��������", "���Ű��� �Ǵ� ���ֵ� �ڷ�� ������ ������ �� �����ϴ�.", stopsign!)
	 p_mod.enabled = false
	 p_mod.PictureName = 'C:\erpman\image\����_dn.gif'
	 return 1
 end if
 
 // �Ҵ翡 ���� ������� ���� ��쿡�� ����
 Lcnt = 0
 Select count(*) into :Lcnt From Holdstock
  where sabu = :gs_sabu And pordno = :sPordno  And isqty > 0;
 if lcnt > 0  then
	 Messagebox("��������", "�۾����ÿ� ���� ���� �ڷᰡ ������ ������ ������ �� �����ϴ�.", stopsign!)
	 //cb_2.enabled = false
 	 p_mod.enabled = false
	 p_mod.PictureName = 'C:\erpman\image\����_dn.gif'
	 return 1
 end if	  

// ���� ���࿩�� check
Select count(*) into :Lcnt 
  from morout
 where sabu = :gs_sabu And pordno = :spordno and roqty > 0 ;

 if lcnt > 0  then
	 Messagebox("��������", "�۾������� ��ϵ� �ڷᰡ ������ ������ ������ �� �����ϴ�.", stopsign!)
	 //cb_2.enabled = false
 	 p_mod.enabled = false
	 p_mod.PictureName = 'C:\erpman\image\����_dn.gif'
	 return 1
 end if	  
		 
//cb_2.enabled = true
p_mod.enabled = true
p_mod.PictureName = 'C:\erpman\image\����_up.gif'

end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\��ȸ_up.gif'
end event

event ue_lbuttondown;PictureName = 'C:\erpman\image\��ȸ_dn.gif'
end event

type p_can from uo_picture within w_pdt_03401
integer x = 3168
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\���_up.gif"
end type

event clicked;call super::clicked;wf_reset()
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\���_up.gif'
end event

event ue_lbuttondown;PictureName = 'C:\erpman\image\���_dn.gif'
end event

type p_exit from uo_picture within w_pdt_03401
integer x = 3342
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;gs_gubun = is_update

close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\�ݱ�_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\�ݱ�_dn.gif'
end event

type st_4 from statictext within w_pdt_03401
integer x = 82
integer y = 1380
integer width = 1541
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "��� ����(������ �Է½� �Ҵ��ڷᰡ �����˴ϴ�.)"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_03401
integer x = 2240
integer y = 696
integer width = 1216
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "����ǰ �Ҵ� ����(������ 0�̸� ����)"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_03401
integer x = 73
integer y = 696
integer width = 1541
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "���� ���� ���� ����(Double Click�̸� ����ó��)"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdt_03401
integer x = 55
integer y = 224
integer width = 1216
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "���� ���� ����(��������� 0�̸� ����ó��"
boolean focusrectangle = false
end type

type dw_holdstock from datawindow within w_pdt_03401
boolean visible = false
integer x = 846
integer y = 2212
integer width = 823
integer height = 164
boolean enabled = false
string title = "none"
string dataobject = "d_krs_02070_d"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within w_pdt_03401
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 316
integer width = 3483
integer height = 320
integer taborder = 20
string dataobject = "d_pdt_03401_5"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

type dw_4 from datawindow within w_pdt_03401
event ue_pressenter pbm_dwnprocessenter
integer x = 2176
integer y = 784
integer width = 1339
integer height = 564
integer taborder = 50
string dataobject = "d_pdt_03401_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event constructor;//if f_change_name('1') = 'Y' then 
//	Modify("ispec_t.text = '" + f_change_name('2') + "'" )
//	Modify("jijil_t.text = '" + f_change_name('3') + "'" )
//end if	
//
end event

type cb_3 from commandbutton within w_pdt_03401
boolean visible = false
integer x = 128
integer y = 2260
integer width = 338
integer height = 104
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "����(&D)"
end type

event clicked;//string sgubun
//Long	 Lrow
//
//if dw_1.accepttext() = -1 then return
//
//Lrow = dw_2.getrow()
//
//if Lrow < 1 then
//	MessageBox("����", "�����ϰ��� �ϴ� �ڷᰡ ���õ��� �ʾ����ϴ�", stopsign!)
//	dw_2.setfocus()
//	return
//End if
//
//sgubun  = dw_1.getitemstring(1, "gubun")
//
//// ������������ ����
//if sGubun = '2' then
//	dw_2.Deleterow(Lrow)
//End if
//
//is_update = 'Y'
end event

type dw_3 from datawindow within w_pdt_03401
integer x = 27
integer y = 1460
integer width = 3461
integer height = 660
integer taborder = 60
string dataobject = "d_pdt_03401_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event constructor;if f_change_name('1') = 'Y' then 
	Modify("ispec_t.text = '" + f_change_name('2') + "'" )
	Modify("jijil_t.text = '" + f_change_name('3') + "'" )
end if	

end event

type dw_2 from datawindow within w_pdt_03401
event ue_processener pbm_dwnprocessenter
integer x = 23
integer y = 784
integer width = 2094
integer height = 564
integer taborder = 40
string dataobject = "d_pdt_03401_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_processener;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;//dec {3} dSaveQty, dqty
//
//if row < 1 then return
//
//dSaveqty = getitemdecimal(Row, "momrel_relqty")
//dQty		= Dec(gettext())
//
//if dqty <= 0 then
//	MessageBox("�������", "��������� 0�� ������� �����ϴ�" + '~n' + &
//								  "�ڷḦ �����Ͽ� �ֽʽÿ�", stopsign!)
//	setitem(Row, "momrel_relqty", dSaveqty)
//	Return 1
//End if
end event

event itemerror;return 1
end event

event constructor;//if f_change_name('1') = 'Y' then 
//	Modify("ispec_t.text = '" + f_change_name('2') + "'" )
//	Modify("jijil_t.text = '" + f_change_name('3') + "'" )
//end if	
//
end event

type dw_1 from datawindow within w_pdt_03401
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 40
integer width = 1961
integer height = 140
integer taborder = 10
string dataobject = "d_pdt_03401_1"
boolean border = false
end type

event ue_key;if keydown(keyf1!) then
	this.triggerevent(rbuttondown!)
end if
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;gs_gubun = '30' 
gs_code = '���'
open(w_jisi_popup)
if isnull(gs_code) or gs_code = "" then 	return
this.SetItem(1, "pordno", gs_code)
triggerevent(itemchanged!)
end event

event itemerror;return 1
end event

event itemchanged;string spordno
dec{3} dqty, dOld_qty
long   lcnt

if getcolumnname() = 'pordno' then
	spordno = trim(this.gettext())
   if spordno = '' or isnull(spordno) then 
		wf_reset()
		return 
	end if

	if wf_pordno(spordno) < 0 then 
		wf_reset()
		return 1
	end if

elseif this.getcolumnname() = "pdqty" then
   dqty     = dec(this.gettext())
	dOld_qty = this.getitemdecimal(1, 'old_pdqty')
	spordno  = this.getitemstring(1, "pordno")
	
	if sPordno = '' or isnull(sPordno) then 
		messagebox('Ȯ ��', '����������ȣ�� ���� �Է��ϼ���!')
		this.setitem(1, 'pdqty', dold_qty)
		Return 1
	end if
	
	if dqty > dold_qty then 
		messagebox('Ȯ ��', 'ó�� ������������ ũ�� ������ ������ �� �����ϴ�.')
		this.setitem(1, 'pdqty', dold_qty)
		return 1
	end if
end if

end event

type rr_1 from roundrectangle within w_pdt_03401
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 308
integer width = 3497
integer height = 336
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_03401
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 772
integer width = 2117
integer height = 584
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_03401
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2171
integer y = 772
integer width = 1358
integer height = 584
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pdt_03401
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 1452
integer width = 3479
integer height = 680
integer cornerheight = 40
integer cornerwidth = 55
end type

