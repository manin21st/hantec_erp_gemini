$PBExportHeader$w_sal_02080.srw
$PBExportComments$�Ϳ� ������ ����(������)
forward
global type w_sal_02080 from w_inherite
end type
type gb_5 from groupbox within w_sal_02080
end type
type gb_2 from groupbox within w_sal_02080
end type
type cb_1 from commandbutton within w_sal_02080
end type
type gb_3 from groupbox within w_sal_02080
end type
type cbx_1 from checkbox within w_sal_02080
end type
type st_6 from statictext within w_sal_02080
end type
type st_7 from statictext within w_sal_02080
end type
type dw_1 from datawindow within w_sal_02080
end type
type st_8 from statictext within w_sal_02080
end type
type rb_1 from radiobutton within w_sal_02080
end type
type rb_2 from radiobutton within w_sal_02080
end type
type rb_3 from radiobutton within w_sal_02080
end type
type dw_3 from datawindow within w_sal_02080
end type
type cb_3 from commandbutton within w_sal_02080
end type
type dw_4 from datawindow within w_sal_02080
end type
type dw_2 from datawindow within w_sal_02080
end type
type gb_4 from groupbox within w_sal_02080
end type
type rb_4 from radiobutton within w_sal_02080
end type
type cb_4 from commandbutton within w_sal_02080
end type
type p_4 from uo_picture within w_sal_02080
end type
type p_3 from uo_picture within w_sal_02080
end type
type p_1 from uo_picture within w_sal_02080
end type
type pb_1 from u_pb_cal within w_sal_02080
end type
end forward

global type w_sal_02080 from w_inherite
integer height = 2400
string title = "�Ϳ� ������ ����"
gb_5 gb_5
gb_2 gb_2
cb_1 cb_1
gb_3 gb_3
cbx_1 cbx_1
st_6 st_6
st_7 st_7
dw_1 dw_1
st_8 st_8
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
dw_3 dw_3
cb_3 cb_3
dw_4 dw_4
dw_2 dw_2
gb_4 gb_4
rb_4 rb_4
cb_4 cb_4
p_4 p_4
p_3 p_3
p_1 p_1
pb_1 pb_1
end type
global w_sal_02080 w_sal_02080

forward prototypes
public function integer wf_ratecal ()
public function integer wf_gyeljea ()
end prototypes

public function integer wf_ratecal ();//���� ǰ��  �������� ��޺� �������� ���Ͽ� �ŷ�ó�� �������� ����Ѵ�.

long ll_row,i=1,ll_found,ll_rate ,ll_count
string ls_cod,ls_level,ls_date,ls_rate,ls_gubun
dw_3.accepttext()
dw_insert.accepttext()

setpointer(hourglass!)
ls_date=dw_insert.getitemstring(1,"vnddc_start_date")
ls_gubun=dw_insert.getitemstring(1,"gubun")

//����������� ���� ����Ÿ�� ����
ls_cod=dw_insert.getitemstring(1,"vnddc_cvcod")
If IsNull(ls_cod) Then ls_cod = '%'

//SELECT COUNT(*) 
//INTO :ll_count 
//FROM VNDDC ;
//
//if ll_count > 1 then
	DELETE FROM VNDDC
	WHERE START_DATE = :ls_DATE and
			CVCOD LIKE :ls_cod;
//end if
		
ll_row= dw_3.rowcount()

for i=1 to ll_row
	ls_cod=dw_3.getitemstring(i,"cvcod")
   ls_level=dw_3.getitemstring(i,"mlevel")
		
	dw_1.accepttext()
	
	ll_found=dw_1.find("rfgub=  '" + ls_level + "'",1,dw_1.rowcount())
	ls_rate=dw_1.getitemstring(ll_found,"rfvalue")
	
	if  ls_rate="" or isnull(ls_rate) then
		ls_rate = " 0 "
	end if
	
	ll_rate=long(ls_rate)

//�ڷ��Է�	

   INSERT INTO VNDDC (CVCOD,ITTYP,ITCLS,START_DATE,DC_RATE)
	       SELECT :ls_cod,a.ITTYP, a.ITCLS, :ls_date, nvl(a.DC_RATE,0) + nvl(:ll_rate,0) 
			   from ITGRDC a
			  where a.salegu = '1' and
			        a.start_date = ( select max(b.start_date) from itgrdc b
					                    where b.salegu =:ls_gubun and
											        b.start_date <= :ls_date and
													  b.ittyp = a.ittyp and
													  b.itcls = a.itcls );

	if sqlca.sqlcode <> 0 then
//		messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		messagebox('���','�ڷ� �Է��� ���� �߽��ϴ�.')
		rollback;
		return -1
	end if
next

commit;
messagebox('Ȯ��','�ڷ��Է��� �����߽��ϴ�.')
	
return 1


end function

public function integer wf_gyeljea ();////���� ǰ��  �������� ��޺� �������� ���Ͽ� �ŷ�ó�� �������� ����Ѵ�.

long ll_row,i=1,ll_found,ll_rate ,ll_count
string ls_cod,ls_rcvmg,ls_date,ls_rate,ls_gubun
dw_4.accepttext()
dw_insert.accepttext()

setpointer(hourglass!)
ls_date=dw_insert.getitemstring(1,"vnddc_start_date")
ls_gubun=dw_insert.getitemstring(1,"gubun")

//����������� ���� ����Ÿ�� ����
ls_cod=dw_insert.getitemstring(1,"vnddc_cvcod")
If IsNull(ls_cod) Then ls_cod = '%'

//SELECT COUNT(*) 
//INTO :ll_count 
//FROM VNDDC ;
//
//if ll_count > 0 then
	DELETE FROM VNDDC
	WHERE START_DATE = :ls_DATE and
			CVCOD LIKE :ls_cod;
//end if
//
ll_row= dw_4.rowcount()

for i=1 to ll_row
	ls_cod=dw_4.getitemstring(i,"cvcod")
   ls_rcvmg=dw_4.getitemstring(i,"rcvmg")
	
	dw_2.accepttext()
	
	ll_found=dw_2.find("reffpf_rfgub =  '" + ls_rcvmg + "'",1,dw_2.rowcount())

	ls_rate=dw_2.getitemstring(ll_found,"rfvalue")
	
	if  ls_rate="" or isnull(ls_rate) then
		ls_rate = " 0 "
	end if
	
	ll_rate=long(ls_rate)

//�ڷ��Է�	

   INSERT INTO VNDDC (CVCOD,ITTYP,ITCLS,START_DATE,DC_RATE)
	       SELECT :ls_cod,a.ITTYP, a.ITCLS, :ls_date, nvl(a.DC_RATE,0) + nvl(:ll_rate,0) 
			   from ITGRDC a
			  where a.salegu = :ls_gubun and
			        a.start_date = ( select max(b.start_date) from itgrdc b
					                    where b.salegu =:ls_gubun and
											        b.start_date <= :ls_date and
													  b.ittyp = a.ittyp and
													  b.itcls = a.itcls );

	if sqlca.sqlcode <> 0 then
		messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		messagebox('���','�ڷ� �Է��� ���� �߽��ϴ�.')
		rollback;
		return -1
	end if
next

commit;
messagebox('Ȯ��','�ڷ��Է��� �����߽��ϴ�.')

return 1

//
//messagebox("",ls_gubun)
//messagebox("",ls_cod)
//return 1
end function

on w_sal_02080.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_2=create gb_2
this.cb_1=create cb_1
this.gb_3=create gb_3
this.cbx_1=create cbx_1
this.st_6=create st_6
this.st_7=create st_7
this.dw_1=create dw_1
this.st_8=create st_8
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.dw_3=create dw_3
this.cb_3=create cb_3
this.dw_4=create dw_4
this.dw_2=create dw_2
this.gb_4=create gb_4
this.rb_4=create rb_4
this.cb_4=create cb_4
this.p_4=create p_4
this.p_3=create p_3
this.p_1=create p_1
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.rb_3
this.Control[iCurrent+13]=this.dw_3
this.Control[iCurrent+14]=this.cb_3
this.Control[iCurrent+15]=this.dw_4
this.Control[iCurrent+16]=this.dw_2
this.Control[iCurrent+17]=this.gb_4
this.Control[iCurrent+18]=this.rb_4
this.Control[iCurrent+19]=this.cb_4
this.Control[iCurrent+20]=this.p_4
this.Control[iCurrent+21]=this.p_3
this.Control[iCurrent+22]=this.p_1
this.Control[iCurrent+23]=this.pb_1
end on

on w_sal_02080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.cb_1)
destroy(this.gb_3)
destroy(this.cbx_1)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.dw_1)
destroy(this.st_8)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.dw_3)
destroy(this.cb_3)
destroy(this.dw_4)
destroy(this.dw_2)
destroy(this.gb_4)
destroy(this.rb_4)
destroy(this.cb_4)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_1)
destroy(this.pb_1)
end on

event open;call super::open;string ls_date

dw_insert.settransobject(sqlca)
dw_insert.insertrow(0)
dw_insert.setfocus()
dw_insert.object.vndmst_outgu[1]='1'
dw_insert.object.gubun[1]='1'
dw_1.settransobject(sqlca)
dw_1.retrieve()
dw_2.settransobject(sqlca)
dw_2.retrieve()
dw_1.enabled=false
dw_2.enabled=false
p_4.visible=false

select max(jpdat)
into :ls_date
from junpyo_closing ;

dw_insert.setitem(1,'vndjan_base_yymm',ls_date)
dw_insert.setitem(1,'vnddc_start_date',f_today())

end event

type dw_insert from w_inherite`dw_insert within w_sal_02080
integer x = 1015
integer y = 920
integer width = 2615
integer height = 340
integer taborder = 10
string dataobject = "d_sal_02080_01"
boolean border = false
end type

event dw_insert::itemchanged;string s_date, snull, s_cvcod, s_cvnm, s_cvnm2 ,ls_outgu ,ls_dcrategu
int   ireturn

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

if this.accepttext() <> 1 then return 

////���ݽ������///////////////////////////////////////////////////////////
if this.getcolumnname() = 'vndjan_base_yymm' then   
	
	s_date = Trim(this.gettext())
	
	if IsNull(s_date) or s_date = "" then return
		
	if f_datechk(string(long(s_date),'000000')+'01') = -1 then
		f_message_chk(35,'[���ݽ������]')
		this.setitem(1,"vndjan_base_yymm",snull)
		this.setcolumn("vndjan_base_yymm")
		this.setfocus()
		return 1
	end if
end if		

////���������/////////////////////////////////////////////////////////////
IF	this.getcolumnname() = "vnddc_start_date" THEN
	
	s_date = Trim(this.gettext())
	
	IF f_datechk(trim(s_date)) = -1	then
      f_message_chk(35,'[���������]')
		this.setitem(1,"vnddc_start_date",snull)
		this.setcolumn("vnddc_start_date")
		this.setfocus()
		return 1
	END IF
end if

if this.getcolumnname() = 'vnddc_cvcod' then   
	
	s_cvcod = this.gettext()
	
	// *****�� �������� function...
	// �Է¹� => msg���� 'Y',  ��¹� => msg���� 'N'
	ireturn = f_get_name2('V0', 'N', s_cvcod, s_cvnm, s_cvnm2)
	
	this.setitem(1,"vnddc_cvcod", s_cvcod)
	this.setitem(1,"vndmst_cvnas2",s_cvnm)
	
	SELECT OUTGU ,DCRATEGU
	INTO  :ls_outgu , :ls_dcrategu
	FROM  VNDMST
	WHERE CVCOD = :s_cvcod ;
	
	if ls_outgu = "" or isnull(ls_outgu) then
		messagebox('Ȯ��','�ش� �ŷ�ó�� ����ó������ �����ϴ�.' )
		this.setitem(1,'vndmst_outgu',snull)
		return
	end if
	
	if ls_dcrategu = "" or isnull(ls_dcrategu) then
		messagebox('Ȯ��','�ش�ŷ�ó�� ������ ��걸���� ��ϵ��� �ʾҽ��ϴ�.' +"~n~n" +&
		            "���� , ������ �ڵ������ �Ҽ� �����ϴ�." +"~n~n" +&
		            "[ó�����] �ŷ�ó ��Ͽ��� ������ ��걸���� ��� �ٶ��ϴ�.")
								
		this.setitem(1,"vnddc_cvcod", snull)
		this.setitem(1,"vndmst_cvnas2",snull)
		return
	end if
	
	this.setitem(1,'vndmst_outgu',ls_outgu)
	
	return ireturn
end if

ib_any_typing = false
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;string ls_outgu ,snull , ls_dcrategu

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(snull)

/* �ŷ�ó */
if this.GetColumnName() = 'vnddc_cvcod' then	
//	gs_code = Trim(GetText())
	open(w_vndmst_popup)
	if gs_code = "" or isnull(gs_code) then return 
	
	this.setitem(1, 'vnddc_cvcod', gs_code)
	this.setitem(1, 'vndmst_cvnas2', gs_codename)
	
	SELECT OUTGU ,DCRATEGU 
	INTO  :ls_outgu , :ls_dcrategu
	FROM  VNDMST
	WHERE CVCOD = :gs_code ;
	
	if ls_outgu = "" or isnull(ls_outgu) then
		messagebox('Ȯ��','�ش� �ŷ�ó�� ����ó������ �����ϴ�.' )
		this.setitem(1,'vndmst_outgu',snull)
		return
	end if
	
	if ls_dcrategu = "" or isnull(ls_dcrategu) then
		messagebox('Ȯ��','�ش�ŷ�ó�� ������ ��걸���� ��ϵ��� �ʾҽ��ϴ�.' +"~n~n" +&
		            "���� , ������ �ڵ������ �Ҽ� �����ϴ�." +"~n~n" +&
		            "[ó�����] �ŷ�ó ��Ͽ��� ������ ��걸���� ��� �ٶ��ϴ�.")
		this.setitem(1,"vnddc_cvcod", snull)
		this.setitem(1,"vndmst_cvnas2",snull)
		return
	end if
	
	this.setitem(1,'vndmst_outgu',ls_outgu)
	
	return 1
end if 

ib_any_typing = false
end event

event dw_insert::editchanged;ib_any_typing = false
end event

type p_delrow from w_inherite`p_delrow within w_sal_02080
boolean visible = false
integer x = 3278
integer y = 2500
end type

type p_addrow from w_inherite`p_addrow within w_sal_02080
boolean visible = false
integer x = 3104
integer y = 2500
end type

type p_search from w_inherite`p_search within w_sal_02080
boolean visible = false
integer x = 2409
integer y = 2500
end type

type p_ins from w_inherite`p_ins within w_sal_02080
boolean visible = false
integer x = 2930
integer y = 2500
end type

type p_exit from w_inherite`p_exit within w_sal_02080
integer x = 3735
integer y = 364
end type

type p_can from w_inherite`p_can within w_sal_02080
boolean visible = false
integer x = 3799
integer y = 2500
end type

type p_print from w_inherite`p_print within w_sal_02080
boolean visible = false
integer x = 2583
integer y = 2500
end type

type p_inq from w_inherite`p_inq within w_sal_02080
boolean visible = false
integer x = 2757
integer y = 2500
end type

type p_del from w_inherite`p_del within w_sal_02080
boolean visible = false
integer x = 3625
integer y = 2500
end type

type p_mod from w_inherite`p_mod within w_sal_02080
boolean visible = false
integer x = 3451
integer y = 2500
end type

type cb_exit from w_inherite`cb_exit within w_sal_02080
integer x = 2903
integer y = 2500
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_sal_02080
boolean visible = false
integer x = 384
integer y = 2592
end type

type cb_ins from w_inherite`cb_ins within w_sal_02080
boolean visible = false
integer x = 50
integer y = 2592
end type

type cb_del from w_inherite`cb_del within w_sal_02080
boolean visible = false
integer x = 718
integer y = 2592
end type

type cb_inq from w_inherite`cb_inq within w_sal_02080
boolean visible = false
integer x = 1051
integer y = 2592
end type

type cb_print from w_inherite`cb_print within w_sal_02080
boolean visible = false
integer x = 1385
integer y = 2592
end type

type st_1 from w_inherite`st_1 within w_sal_02080
end type

type cb_can from w_inherite`cb_can within w_sal_02080
boolean visible = false
integer x = 1723
integer y = 2592
end type

type cb_search from w_inherite`cb_search within w_sal_02080
boolean visible = false
integer x = 2053
integer y = 2592
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_02080
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_02080
end type

type gb_5 from groupbox within w_sal_02080
integer x = 741
integer y = 132
integer width = 1120
integer height = 328
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_2 from groupbox within w_sal_02080
integer x = 978
integer y = 768
integer width = 2688
integer height = 600
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
end type

type cb_1 from commandbutton within w_sal_02080
boolean visible = false
integer x = 2359
integer y = 100
integer width = 498
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ڵ����(&E)"
end type

type gb_3 from groupbox within w_sal_02080
integer x = 1189
integer y = 556
integer width = 2272
integer height = 200
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "ó������"
end type

type cbx_1 from checkbox within w_sal_02080
boolean visible = false
integer x = 1609
integer y = 832
integer width = 1431
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
boolean enabled = false
string text = "���� �������� ���� ���ܰ� �ϰ�����"
end type

type st_6 from statictext within w_sal_02080
integer x = 795
integer y = 200
integer width = 1001
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "- ���ݿ������� ��밡���մϴ�.!!"
boolean focusrectangle = false
end type

type st_7 from statictext within w_sal_02080
integer x = 800
integer y = 292
integer width = 1015
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
boolean enabled = false
string text = "- �ŷ�ó�� ����� ��ϵ� ��ü������ "
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_sal_02080
boolean visible = false
integer x = 987
integer y = 3200
integer width = 421
integer height = 232
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sal_02080_02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_8 from statictext within w_sal_02080
integer x = 1061
integer y = 376
integer width = 754
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "���õ� �ŷ�ó�� �����˴ϴ�."
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_sal_02080
integer x = 1326
integer y = 640
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "���������غ�"
boolean checked = true
end type

event clicked;//dw_insert.object.vndmst_outgu.visible=true
//dw_insert.object.t1.visible=true
//dw_insert.object.t2.visible=true
dw_insert.object.gubun.visible=false
//dw_1.enabled=false
//dw_2.enabled=false
//dw_insert.setfocus()
//dw_insert.setcolumn(1)
p_1.visible=true
p_4.visible=false

end event

type rb_2 from radiobutton within w_sal_02080
integer x = 1906
integer y = 640
integer width = 411
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "��ޱ��غ�"
end type

event clicked;//dw_insert.object.vndmst_outgu.visible=false
//dw_insert.object.t1.visible=false
//dw_insert.object.t2.visible=false
dw_insert.object.gubun.visible=true
//dw_1.enabled=true
//dw_2.enabled=false
//dw_insert.setfocus()
//dw_insert.setcolumn(1)
p_1.visible=false
//cb_3.visible=true
p_4.visible=true

end event

type rb_3 from radiobutton within w_sal_02080
integer x = 2373
integer y = 640
integer width = 411
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "�������Ǻ�"
end type

event clicked;//dw_insert.object.vndmst_outgu.visible=false
//dw_insert.object.t1.visible=false
//dw_insert.object.t2.visible=false
dw_insert.object.gubun.visible=true
//dw_1.enabled=false
//dw_2.enabled=true
//dw_insert.setfocus()
//dw_insert.setcolumn(1)
p_1.visible=false
//cb_3.visible=true
p_4.visible=true

end event

type dw_3 from datawindow within w_sal_02080
boolean visible = false
integer x = 443
integer y = 3200
integer width = 1413
integer height = 648
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_sal_02080_04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_sal_02080
boolean visible = false
integer x = 1847
integer y = 200
integer width = 498
integer height = 108
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ڵ����(&E)"
end type

type dw_4 from datawindow within w_sal_02080
boolean visible = false
integer x = 1925
integer y = 3200
integer width = 1495
integer height = 612
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_sal_02080_05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_sal_02080
boolean visible = false
integer x = 1408
integer y = 3200
integer width = 398
integer height = 224
integer taborder = 40
string dataobject = "d_sal_02080_03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_sal_02080
boolean visible = false
integer x = 731
integer y = 616
integer width = 3186
integer height = 916
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
end type

type rb_4 from radiobutton within w_sal_02080
integer x = 2866
integer y = 640
integer width = 425
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 32106727
string text = "��� + ����"
end type

event clicked;//dw_insert.object.vndmst_outgu.visible=false
//dw_insert.object.t1.visible=false
//dw_insert.object.t2.visible=false
dw_insert.object.gubun.visible=true
//dw_1.enabled=false
//dw_2.enabled=true
//dw_insert.setfocus()
//dw_insert.setcolumn(1)
p_1.visible=false
//cb_3.visible=true
p_4.visible=true
end event

type cb_4 from commandbutton within w_sal_02080
boolean visible = false
integer x = 2359
integer y = 252
integer width = 498
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ڵ����(&E)"
end type

type p_4 from uo_picture within w_sal_02080
integer x = 3557
integer y = 364
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\�ڵ����_up.gif"
end type

event clicked;call super::clicked;string ls_rgubun , ls_gubun , ls_start_date , ls_cvcod , ls_cvnas2 , ls_outgu , s_base_yymm 
Long   rtn, nCnt

IF dw_insert.Accepttext() = -1 THEN
	dw_insert.setfocus()
	RETURN
END IF

If dw_insert.RowCount() <= 0 Then Return

ls_gubun      = Trim(dw_insert.GetItemString(1, "gubun")) // ���� �ܼ� ���� 
s_base_yymm   = Trim(dw_insert.GetItemString(1, "vndjan_base_yymm"))
ls_start_date = Trim(dw_insert.GetItemString(1, "vnddc_start_date"))
ls_cvcod      = Trim(dw_insert.GetItemString(1, "vnddc_cvcod"))
ls_cvnas2     = Trim(dw_insert.GetItemString(1, "vndmst_cvnas2"))
ls_outgu      = Trim(dw_insert.GetItemString(1, "vndmst_outgu"))

/* �ʼ��Է� �׸� üũ */
IF IsNull(s_base_yymm) or trim(s_base_yymm) = '' THEN
	f_message_chk(30,'[���ݽ������]')
	dw_insert.SetColumn("vndjan_base_yymm")
	dw_insert.SetFocus()
	RETURN
END IF

IF IsNull(ls_start_date) or trim(ls_start_date) = '' THEN
	f_message_chk(30,'[���������]')
	dw_insert.SetColumn("vnddc_start_date")
	dw_insert.SetFocus()
	RETURN 
END IF

If IsNull(ls_cvcod) Or trim(ls_cvcod) = '' Then ls_cvcod = '%'

if rb_2.checked = True then
	ls_rgubun = '1'
elseif rb_3.checked = true then
	ls_rgubun = '2' 
else
	ls_rgubun = '3'
end if

IF MessageBox("������ ����","�ش� �������ڿ� �ۼ��� �������� ��� ������ �����մϴ�." +"~n~n" +&
                    	 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
								
SetPointer(hourglass!)

rtn = sqlca.fun_calc_vnddc_mod(ls_rgubun,ls_start_date,ls_cvcod,ls_gubun,ls_outgu)

//MessageBox(string(rtn),sqlca.sqlerrtext)
Choose Case rtn
  Case 0
	   commit;
	   MessageBox('�۾��Ϸ�','ó���� �Ǽ��� �����ϴ�~r~n~r~n'+string(rtn),Information!,Ok!)
  Case IS > 0
	   commit;
	   MessageBox('�۾��Ϸ�','�ŷ�ó ������ �ڵ������ �Ϸ�Ǿ����ϴ�~r~n~r~n'+string(rtn),Information!,Ok!)
  Case -1
	   rollback;
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		f_message_chk(39,'[�ŷ�ó ������ �ڵ����]')
  Case -3
	   rollback;
		f_message_chk(39,'[���� ����]')
	Case Else
	   rollback;
		f_message_chk(39,'[���� ERROR]')
End Choose

///* ���� �������� ���� ���ܰ� �ϰ����� */
//If cbx_1.Checked = True Then
//	gs_code     = s_cvcod
//	gs_codename = s_cvcodnm
//	open(w_sal_02120)
//End If
//
end event

type p_3 from uo_picture within w_sal_02080
boolean visible = false
integer x = 3689
integer y = 1348
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\�ڵ����_up.gif"
boolean focusrectangle = true
end type

event clicked;call super::clicked; string ls_code,ls_date,ls_value,s_start_date

dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)
dw_insert.accepttext()

ls_code=dw_insert.getitemstring(1,"vnddc_cvcod")
//ls_date=dw_insert.getitemstring(1,"vnddc_start_date")
ls_value=dw_insert.getitemstring(1,"vndjan_base_yymm")
s_start_date=dw_insert.getitemstring(1,"vnddc_start_date")

//���޽��� �Է� Ȯ��
if ls_value="" or isnull(ls_value) then
		f_message_chk(30,'[���ݽ������]')
	   dw_insert.SetColumn("vndjan_base_yymm")
	   dw_insert.SetFocus()
		return
	end if
//����Ⱓ �Է� Ȯ��	
IF IsNull(s_start_date) or trim(s_start_date) = '' THEN
	f_message_chk(30,'[���������]')
	dw_insert.SetColumn("vnddc_start_date")
	dw_insert.SetFocus()
	RETURN 
END IF
	
if rb_2.checked=true then	
	if  ls_code="" or isnull(ls_code) then
		dw_3.retrieve('%')
	else
		dw_3.retrieve(ls_code)
	end if
	if ls_code ="" or isnull(ls_code) then ls_code=''
	IF wf_ratecal() = -1 THEN
		Return
	END IF
elseif rb_3.checked=true then
	if  ls_code="" or isnull(ls_code) then
		dw_4.retrieve('%')
	else
		dw_4.retrieve(ls_code)
	end if
	if ls_code ="" or isnull(ls_code) then ls_code=''
	if wf_gyeljea() = -1 then
		return
	end if
end if

SetPointer(Arrow!)
end event

type p_1 from uo_picture within w_sal_02080
integer x = 3561
integer y = 364
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\�ڵ����_up.gif"
end type

event clicked;call super::clicked;string s_salegu,s_base_yymm,s_start_date,s_cvcod,s_cvcodnm,s_outgu
Long   rtn, nCnt

IF dw_insert.Accepttext() = -1 THEN
	dw_insert.setfocus()
	RETURN
END IF

If dw_insert.RowCount() <= 0 Then Return

s_salegu     = Trim(dw_insert.GetItemString(1, "gubun")) // ���� �ܼ� ���� 
s_base_yymm  = Trim(dw_insert.GetItemString(1, "vndjan_base_yymm"))
s_start_date = Trim(dw_insert.GetItemString(1, "vnddc_start_date"))
s_cvcod      = Trim(dw_insert.GetItemString(1, "vnddc_cvcod"))
s_cvcodnm    = Trim(dw_insert.GetItemString(1, "vndmst_cvnas2"))
s_outgu      = Trim(dw_insert.GetItemString(1, "vndmst_outgu"))

If IsNull(s_cvcod) Then s_cvcod = ''

/* �ʼ��Է� �׸� üũ */
IF IsNull(s_base_yymm) or trim(s_base_yymm) = '' THEN
	f_message_chk(30,'[���ݽ������]')
	dw_insert.SetColumn("vndjan_base_yymm")
	dw_insert.SetFocus()
	RETURN
END IF

IF IsNull(s_start_date) or trim(s_start_date) = '' THEN
	f_message_chk(30,'[���������]')
	dw_insert.SetColumn("vnddc_start_date")
	dw_insert.SetFocus()
	RETURN 
END IF

/* ����ó���� ���� Ȯ�� */
  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
    INTO :nCnt
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'G1' ) AND  
         ( "JUNPYO_CLOSING"."JPDAT" = :s_base_yymm )   ;

If nCnt = 0 Then
	MessageBox("���ݿ� ����","���ݸ������� ��밡���մϴ�.")
	Return 
End If

//select count(*) into :ncnt
//  from vnddc
// where start_date = :s_start_date;
//
If nCnt > 1 Then
	If IsNull(s_cvcod) Then s_cvcod = ''
	
	If IsNull(s_cvcodnm)  Or Trim(s_cvcodnm) = '' Then s_cvcodnm = '���'
	IF MessageBox("�� ��","��������Ϸ� �ڷᰡ ��ϵǾ� �ֽ��ϴ�~r~n~r~n " + s_cvcodnm + " �ڷᰡ �����˴ϴ�." +"~n~n" +&
								 "��� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
End If

SetPointer(hourglass!)

rtn = sqlca.fun_calc_vnddc(gs_sabu,s_salegu,s_base_yymm,s_start_date,s_cvcod+'%',s_outgu)

//MessageBox(string(rtn),sqlca.sqlerrtext)
Choose Case rtn
  Case 0
	   commit;
	   MessageBox('�۾��Ϸ�','ó���� �Ǽ��� �����ϴ�~r~n~r~n'+string(rtn),Information!,Ok!)
  Case IS > 0
	   commit;
	   MessageBox('�۾��Ϸ�','�ŷ�ó ������ �ڵ������ �Ϸ�Ǿ����ϴ�~r~n~r~n'+string(rtn),Information!,Ok!)
  Case -1
	   rollback;
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		f_message_chk(39,'[�ŷ�ó ������ �ڵ����]')
  Case -3
	   rollback;
		f_message_chk(39,'[���� ����]')
	Case Else
	   rollback;
		f_message_chk(39,'[���� ERROR]')
End Choose

/* ���� �������� ���� ���ܰ� �ϰ����� */
If cbx_1.Checked = True Then
	gs_code     = s_cvcod
	gs_codename = s_cvcodnm
	open(w_sal_02120)
End If

end event

type pb_1 from u_pb_cal within w_sal_02080
integer x = 2697
integer y = 952
integer width = 78
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_insert.SetColumn('vnddc_start_date')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_insert.SetItem(1, 'vnddc_start_date', gs_code)

end event

