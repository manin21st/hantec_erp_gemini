$PBExportHeader$w_pdt_02450.srw
$PBExportComments$����/ġ���� �����Ƿ� ���
forward
global type w_pdt_02450 from w_inherite
end type
type gb_3 from groupbox within w_pdt_02450
end type
type gb_2 from groupbox within w_pdt_02450
end type
type gb_1 from groupbox within w_pdt_02450
end type
type cb_wicode from commandbutton within w_pdt_02450
end type
end forward

global type w_pdt_02450 from w_inherite
string title = "�����Ƿ� ���"
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
cb_wicode cb_wicode
end type
global w_pdt_02450 w_pdt_02450

forward prototypes
public function integer wf_reset ()
public function integer wf_requiredcheck (ref string scolumn, ref long lrow)
end prototypes

public function integer wf_reset ();cb_del.enabled = False
cb_wicode.enabled = False

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)
dw_insert.object.kumest_kestno.protect = 0
dw_insert.object.kumest_kestno.Background.Color= 65535

dw_insert.setcolumn("kumest_kestno")
dw_insert.setfocus()
dw_insert.setredraw(true)

return 1

end function

public function integer wf_requiredcheck (ref string scolumn, ref long lrow);string  snull, scode, scdate, sSabu
long    ljpno, dRate

SetNull(sNull)

Lrow = 1

sle_msg.text = "�����Ƿ� �ڷḦ �˻���............."

scode = dw_insert.getitemstring(1, "kumest_kestdat")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[�Ƿ�����]')
	scolumn = "kumest_kestdat"
	return -1
END IF

scode = dw_insert.getitemstring(1, "kumest_estemp")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[�����]')	
	scolumn = "kumest_estemp"
	return -1	
End if

drate = dw_insert.getitemdecimal(1, "kumest_unqty")
if isnull(drate) or drate = 0 then
	f_message_chk(1400, '[�Ƿڼ���]')	
	scolumn = "kumest_unqty"
	return -1	
End if

//scode = dw_insert.getitemstring(1, "kumest_mchno")
//if isnull(scode) or Trim(sCode) = '' then
//	f_message_chk(1400, '[����]')	
//	scolumn = "kumest_mchno"
//	return -1	
//End if
//
//scode = dw_insert.getitemstring(1, "kumest_pgready")
//if isnull(scode) or Trim(sCode) = '' then
//	f_message_chk(1400, '[�غ��Ȳ]')	
//	scolumn = "kumest_pgready"
//	return -1	
//End if
//
//scode = dw_insert.getitemstring(1, "kumest_pgemp")
//if isnull(scode) or Trim(sCode) = '' then
//	f_message_chk(1400, '[�ۼ������]')	
//	scolumn = "kumest_pgemp"
//	return -1	
//End if
//
scode = dw_insert.getitemstring(1, "kumest_kuser")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[����user]')	
	scolumn = "kumest_kuser"
	return -1	
End if


scode = dw_insert.getitemstring(1, "kumest_yodat")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[�䱸������]')
	scolumn = "kumest_yodat"
	return -1
END IF

scode = dw_insert.getitemstring(1, "kumest_hjakgun")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[�����Ƿ�����]')	
	scolumn = "kumest_hjakgun"
	return -1	
End if

scode = dw_insert.getitemstring(1, "kumest_kugbn")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[���ۻ�������]')	
	scolumn = "kumest_kugbn"
	return -1	
End if

//scode = dw_insert.getitemstring(1, "kumest_hygbn")
//if isnull(scode) or Trim(sCode) = '' then
//	f_message_chk(1400, '[���ı���]')	
//	scolumn = "kumest_hygbn"
//	return -1	
//End if
//
if dw_insert.getitemstring(1, "kumest_kestgub") = '2' then  // ������ ��쿡�� check
	scode = dw_insert.getitemstring(1, "kumest_boisgu")
	if isnull(scode) or Trim(sCode) = '' then
		f_message_chk(1400, '[�����߻��ñ�]')	
		scolumn = "kumest_boisgu"
		return -1	
	End if
	scode = dw_insert.getitemstring(1, "kumest_bowarr")
	if isnull(scode) or Trim(sCode) = '' then
		f_message_chk(1400, '[�����߻�����]')	
		scolumn = "kumest_bowarr"
		return -1	
	End if
	scode = dw_insert.getitemstring(1, "kumest_issdat")
	if isnull(scode) or Trim(sCode) = '' then
		f_message_chk(1400, '[�����߻�����]')
		scolumn = "kumest_issdat"		
		return -1
	END IF
End If

scode = dw_insert.getitemstring(1, "kumest_kumno")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[������ȣ]')	
	scolumn = "kumest_kumno"
	return -1	
End if

drate = dw_insert.getitemNumber(1, "kumest_untno")
if isnull(drate) then
	f_message_chk(1400, '[����Unit-No]')	
	scolumn = "kumest_untno"
	return -1	
End if


scode = dw_insert.getitemstring(1, "kumest_citnbr")
if isnull(scode) or Trim(sCode) = '' then
	f_message_chk(1400, '[��ǥǰ��]')
	scolumn = "kumest_citnbr"
	return -1	
End if

drate = dw_insert.getitemdecimal(1, "kumest_unprc")
if isnull(drate) then
	f_message_chk(1400, '[���۴ܰ�]')	
	scolumn = "kumest_unprc"
	return -1	
End if

if dw_insert.getitemstring(1, "kumest_makgub") = '2' then  // ������ ��쿡�� check
	scode = dw_insert.getitemstring(1, "kumest_purgc")
	if isnull(scode) or Trim(sCode) = '' then
		f_message_chk(1400, '[�����۾�����]')	
		scolumn = "kumest_purgc"				
		return -1
	END IF	
	scode = dw_insert.getitemstring(1, "kumest_wicvcod")
	if isnull(scode) or Trim(sCode) = '' then
		f_message_chk(1400, '[���־�ü]')
		scolumn = "kumest_wicvcod"
		return -1	
	End if	
end if

// �ű��� ��쿡�� ä���Ѵ�.
sSabu = dw_insert.getitemstring(1, "kumest_sabu") 
if isnull(sSabu) or sSabu = '' then
	dw_insert.setitem(1, "kumest_sabu", gs_sabu)
	scdate = f_today()
	sle_msg.text = "������ȣ�� ä�� ��............."
	ljpno = sqlca.fun_junpyo(gs_sabu, scdate, 'K1')
	if ljpno <= 0 then
		rollback;
		sle_msg.text = ''
		f_message_chk(51,'[�����Ƿ� ��ǥ��ȣ]')	
		return -1
	else
		commit;
	End if
	
	dw_insert.setitem(1, "kumest_kestno", scdate+string(ljpno, '0000'))
end if

return 1

end function

on w_pdt_02450.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.cb_wicode=create cb_wicode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.cb_wicode
end on

on w_pdt_02450.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.cb_wicode)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
wf_reset()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02450
integer x = 9
integer y = 4
integer width = 3593
integer height = 1900
string dataobject = "d_pdt_02450_1"
end type

event dw_insert::itemchanged;string  snull, scode, sname, sname1, sname2, sname3, sdate, sitnbr, sitdsc, smakgub
Long    Lrow
integer iReturn, inull
Decimal {3} dRate, damt

smakgub = getitemstring(1, "kumest_makgub")	

SetNull(sNull)
SetNull(iNull)

Lrow = getrow()

if this.getcolumnname() = 'kumest_kestno' then
	cb_inq.triggerevent(clicked!)
ELSEif this.getcolumnname() = 'kumest_kestdat' then
	IF f_datechk(this.gettext()) = -1	then
		f_message_chk(35, '[�Ƿ�����]')
		this.setitem(1, "kumest_kestdat", '')
		return 1
	END IF
elseif this.getcolumnname() = 'kumest_estemp' then
   sCode = trim(this.gettext())
  	ireturn = f_get_name2('���', 'Y', scode, sname, sname2) 
	this.setitem(1, "kumest_estemp", scode)
	this.setitem(1, "estemp_name", sname)
	return ireturn 	
elseif this.getcolumnname() = 'kumest_boempno' then
   sCode = trim(this.gettext())
  	ireturn = f_get_name2('���', 'Y', scode, sname, sname2) 
	this.setitem(1, "kumest_boempno", scode)
	this.setitem(1, "boempname", sname)
	return ireturn 	
elseif this.getcolumnname() = "kumest_kumno" then
	ireturn = 0
	scode = this.gettext()
	
	this.setitem(1, "kumest_untno", 0)	
	
	select gubun, kumname, kspec, krate, makdat, citnbr, kumamt
	  into :sname, :sname1, :sname2, :dRate, :sname3, :sitnbr, :damt
	  from kummst
	 where sabu = :gs_sabu and kumno = :scode;
	if sqlca.sqlcode <> 0 then
		f_message_chk(121,'[����]')
		this.setitem(lrow, "kumest_kumno",  	sNull)
		this.setitem(lrow, "kummst_gubun",  	sNull)
		this.setitem(lrow, "kummst_kumname",  	sNull)
		this.setitem(lrow, "kummst_kspec",  	sNull)
		this.setitem(lrow, "kummst_krate",  	0)
		this.setitem(lrow, "kummst_gubun",  	sNull)
		this.setitem(lrow, "kumest_mjgbn",  	sNull)		
		this.setitem(lrow, "kumest_unprc",  	0)		
		return 1
	end if
	this.setitem(lrow, "kumest_kumno",  	scode)
	this.setitem(lrow, "kummst_gubun",  	sname)
	this.setitem(lrow, "kumest_mjgbn",  	sname)
	this.setitem(lrow, "kummst_kumname",  	sname1)
	this.setitem(lrow, "kummst_kspec",  	sname2)
	this.setitem(lrow, "kummst_krate",  	drate)	
	this.setitem(lrow, "kummst_makdat",  	sname3)	
	this.setitem(lrow, "kumest_unprc",  	damt)		

	// ��ǥǰ�� �˻�
	Select Ltrim(itdsc)||'.'||Ltrim(ispec)||Ltrim(ispec_code)||'.'||Ltrim(jijil)
	  into :sitdsc
	  From itemas 
	 where itnbr = :sitnbr;
	 
	this.setitem(lrow, "kumest_citnbr",  sitnbr)
	this.setitem(lrow, "itdsc",  			 sitdsc)	 
	
	//�ֱ� �������� �˻�
	Select Max(hisdat)
	  into :sdate
	  from kummst_hist
	 where sabu = :gs_sabu And kumno = :scode And gubun = '2';
	 
	this.setitem(lrow, "kumest_lastdat",  	sdate)		 
	
elseif this.getcolumnname() = "kumest_untno" then
	ireturn = 0
	drate = dec(this.gettext())
	scode = this.getitemstring(1, "kumest_kumno")
	
	select untnm, untpre
	  into :sname, :sitnbr
	  from kummst_set
	 where sabu = :gs_sabu and kumno = :scode and untno = :drate;
	 
	if sqlca.sqlcode <> 0 then
		f_message_chk(122,'[����Unit-No]')
		this.setitem(lrow, "kumest_untno",  inull)
		this.setitem(lrow, "kummst_set_untnm",  sNull)
		return 1
	end if
	this.setitem(lrow, "kummst_set_untnm",  sname)
	
	// ��ǥǰ�� �˻�
	Select Ltrim(itdsc)||'.'||Ltrim(ispec)||Ltrim(ispec_code)||'.'||Ltrim(jijil)
	  into :sitdsc
	  From itemas 
	 where itnbr = :sitnbr;
	 
	this.setitem(lrow, "kumest_citnbr",  sitnbr)
	this.setitem(lrow, "itdsc",  			 sitdsc)	 	
	
elseif this.getcolumnname() = "kumest_mchno" then
	ireturn = 0
	scode = this.gettext()
	
	if isnull(scode) or trim(scode) = '' then
		this.setitem(lrow, "mchmst_mchnam", snull)
		return
	end if
	select mchnam
	  into :sname
	  from mchmst
	 where sabu = :gs_sabu and mchno = :scode;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[����]')
		this.setitem(lrow, "kumest_mchno",  sNull)
		this.setitem(lrow, "mchmst_mchnam",  sNull)
		return 1
	end if
	this.setitem(lrow, "kumest_mchno",  scode)
	this.setitem(lrow, "mchmst_mchnam",  sname)
	
elseif this.getcolumnname() = "kumest_bomchno" then
	ireturn = 0
	scode = this.gettext()
	
	if isnull(scode) or trim(scode) = '' then
		this.setitem(lrow, "bomchnam", snull)
		return
	end if
	
	select mchnam
	  into :sname
	  from mchmst
	 where sabu = :gs_sabu and mchno = :scode;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[����]')
		this.setitem(lrow, "kumest_bomchno",  sNull)
		this.setitem(lrow, "bomchnam",  sNull)
		return 1
	end if
	this.setitem(lrow, "kumest_bomchno",  scode)
	this.setitem(lrow, "bomchnam",  sname)
	
elseif this.getcolumnname() = 'kumest_pgemp' then
   sCode = trim(this.gettext())
  	ireturn = f_get_name2('���', 'Y', scode, sname, sname2) 
	this.setitem(1, "kumest_pgemp", scode)
	this.setitem(1, "empname",	     sname)
	return ireturn 		
elseif this.getcolumnname() = 'kumest_kuser' then	
	scode = this.gettext()
	ireturn = f_get_name2('V0', 'Y', scode, sname, sname2)    //1�̸� ����, 0�� ����
	this.setitem(1, "kumest_kuser", scode)
	this.setitem(1, "usernam",	     sname)
	return ireturn
elseif this.getcolumnname() = 'kumest_yodat' then
	IF f_datechk(this.gettext()) = -1	then
		f_message_chk(35, '[�䱸������]')
		this.setitem(1, "kumest_yodat", '')
		return 1
	END IF
elseif this.getcolumnname() = 'kumest_lastdat' then
	IF f_datechk(this.gettext()) = -1	then
		f_message_chk(35, '[�ֱټ�����]')
		this.setitem(1, "kumest_lastdat", '')
		return 1
	END IF		
elseif this.getcolumnname() = 'kumest_citnbr' then
	scode = this.gettext()
	Select Ltrim(itdsc)||'.'||Ltrim(ispec)||Ltrim(ispec_code)||'.'||Ltrim(jijil)
	  into :sname
	  From itemas 
	 where itnbr = :sCode;
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[��ǥǰ��]')
		this.setitem(lrow, "kumest_citnbr",  sNull)
		this.setitem(lrow, "itdsc",  			sNull)
		return 1
	end if
	this.setitem(lrow, "itdsc", sname)	
elseif this.getcolumnname() = 'kumest_wicvcod' then
	scode = this.gettext()
	ireturn = f_get_name2('V1', 'Y', scode, sname, sname2)    //1�̸� ����, 0�� ����
	this.setitem(1, "kumest_wicvcod", scode)
	this.setitem(1, "winam",		    sname)
	return ireturn
elseif this.getcolumnname() = 'kumest_kestgub' then	
	
	if this.gettext() = '1' then
		this.setitem(1, "kumest_boisgu", snull)
		this.setitem(1, "kumest_bowarr", snull)
		this.setitem(1, "kumest_issdat", snull)
		this.setitem(1, "kumest_boempno", snull)
		this.setitem(1, "kumest_bomchno", snull)
		this.setitem(1, "boempname", snull)
		this.setitem(1, "bomchnam", snull)
	end if
	
elseif this.getcolumnname() = 'kumest_makgub' then		

   if smakgub = '3' then
		 if dw_insert.getitemstring(1, "kumest_estno")  > '.' then
			 f_message_chk(167, '[�����Ƿ�]')
			 setitem(1, "kumesT_makgub", smakgub)
			 return 1
		 End if
	Else
		 if dw_insert.getitemstring(1, "kumest_pordno") > '.' Then
			 f_message_chk(168, '[�۾�����]')
			 setitem(1, "kumesT_makgub", smakgub)
			 return 1
		 End if
	 End if	 	
end if

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = 'kumest_kestno' then
	open(w_pdt_02451)
	if gs_code = '' or isnull(gs_code) then return 
	
	this.setitem(1, "kumest_kestno", gs_code)
	if not isnull(gs_code) then
	 	this.triggerevent(itemchanged!)		
	end if
elseif this.getcolumnname() = 'kumest_estemp' then
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_estemp", gs_code)
	this.setitem(1, "estemp_name",   gs_codename)
elseif this.getcolumnname() = 'kumest_boempno' then
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_boempno", gs_code)
	this.setitem(1, "boempname",   gs_codename)
elseif this.getcolumnname() = "kumest_kumno" then
	open(w_imt_04630_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_kumno",  gs_code)
 	this.triggerevent(itemchanged!)	
elseif this.getcolumnname() = "kumest_mchno" then
	open(w_mchmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_mchno",  gs_code)
	this.setitem(1, "mchmst_mchnam",  gs_codename)
 	this.triggerevent(itemchanged!)	
elseif this.getcolumnname() = "kumest_bomchno" then
	open(w_mchmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_bomchno",  gs_code)
	this.setitem(1, "bomchnam",  gs_codename)
elseif this.getcolumnname() = 'kumest_pgemp' then
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_pgemp", gs_code)
	this.setitem(1, "empname",	     gs_codename)
elseif this.getcolumnname() = 'kumest_kuser' then	
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_kuser", gs_code)
	this.setitem(1, "usernam",	     gs_codename)
 	this.triggerevent(itemchanged!)
elseif this.getcolumnname() = 'kumest_citnbr' then
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_citnbr",  gs_code)
 	this.triggerevent(itemchanged!)	
elseif this.getcolumnname() = 'kumest_wicvcod' then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "kumest_wicvcod", gs_code)
	this.setitem(1, "winam",		    gs_codename)
 	this.triggerevent(itemchanged!)
end if

end event

event dw_insert::ue_pressenter;if this.getcolumnname() = 'kumest_remark' then return 

Send(Handle(this),256,9,0)
Return 1

end event

type cb_exit from w_inherite`cb_exit within w_pdt_02450
integer x = 3209
integer y = 1936
integer taborder = 70
end type

event cb_exit::clicked;close(parent)
end event

type cb_mod from w_inherite`cb_mod within w_pdt_02450
integer x = 2153
integer y = 1936
end type

event cb_mod::clicked;call super::clicked;String scolumn
Long   Lrow

if dw_insert.accepttext() = -1 then return

// �����Ƿ� �Ǵ� �۾����ð� �� ��쿡�� ������ �� ����
if dw_insert.getitemstring(1, "kumest_conf_yn")  = 'Y' then
	f_message_chk(170, '[�Ƿڽ���]')
	return
elseif dw_insert.getitemstring(1, "kumest_estno")  > '.' then
	f_message_chk(167, '[�����Ƿ�]')
	return
elseif dw_insert.getitemstring(1, "kumest_pordno") > '.' Then
	f_message_chk(168, '[�۾�����]')
	return	
End if

if wf_requiredcheck(scolumn, Lrow) = -1 then
	dw_insert.setcolumn(sColumn)
	dw_insert.setfocus()
	sle_msg.text = ''
	return
end if

sle_msg.text = ''

if f_msg_update() = -1 then return

if dw_insert.update() = -1 then
	rollback;
	f_rollback()
	return
Else
	commit;
end if

cb_inq.triggerevent(clicked!)

end event

type cb_ins from w_inherite`cb_ins within w_pdt_02450
boolean visible = false
integer x = 1019
integer y = 2400
integer taborder = 0
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_02450
integer x = 2505
integer y = 1936
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return 

// �����Ƿ� �Ǵ� �۾����ð� �� ��쿡�� ������ �� ����
if dw_insert.getitemstring(1, "kumest_conf_yn")  = 'Y' then
	f_message_chk(170, '[�Ƿڽ���]')
	return
elseif dw_insert.getitemstring(1, "kumest_estno")  > '.' then
	f_message_chk(167, '[�����Ƿ�]')
	return
elseif dw_insert.getitemstring(1, "kumest_pordno") > '.' Then
	f_message_chk(168, '[�۾�����]')
	return	
End if

if f_msg_delete() = -1 then return

dw_Insert.DeleteRow(0)

if dw_insert.update() = -1 then
	rollback;
	f_rollback()
	return
Else
	commit;
end if

wf_reset()

end event

type cb_inq from w_inherite`cb_inq within w_pdt_02450
integer x = 78
integer y = 1936
integer width = 361
integer taborder = 20
string text = "��ȸ(&Q)"
end type

event cb_inq::clicked;call super::clicked;string sjpno

if dw_insert.accepttext() = -1 then return 

sJpno = dw_insert.getitemstring(1, "kumest_kestno")

dw_insert.setredraw(False)

if dw_insert.retrieve(gs_sabu, sjpno) = 0 then
	f_message_chk(56,'[�����Ƿڳ���]')
	dw_insert.reset()
	dw_insert.insertrow(0)
	dw_insert.setredraw(True)	
	dw_insert.setfocus()
	return
end if

dw_insert.object.kumest_kestno.protect = 1
dw_insert.object.kumest_kestno.Background.Color= 79741120

cb_del.enabled = true

if dw_insert.getitemstring(1, 'kumest_makgub') = '3' then 
	cb_wicode.enabled = True
ELSE
	cb_wicode.enabled = False
end if

dw_insert.setredraw(True)
dw_insert.setfocus()

end event

type cb_print from w_inherite`cb_print within w_pdt_02450
boolean visible = false
integer x = 1486
integer y = 2364
integer taborder = 0
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_02450
end type

type cb_can from w_inherite`cb_can within w_pdt_02450
integer x = 2857
integer y = 1936
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;wf_reset()
end event

type cb_search from w_inherite`cb_search within w_pdt_02450
boolean visible = false
integer x = 1865
integer y = 2336
integer taborder = 0
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02450
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02450
end type

type gb_3 from groupbox within w_pdt_02450
integer x = 873
integer y = 1892
integer width = 709
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_pdt_02450
integer x = 2098
integer y = 1892
integer width = 1504
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_pdt_02450
integer x = 14
integer y = 1892
integer width = 489
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type cb_wicode from commandbutton within w_pdt_02450
integer x = 969
integer y = 1936
integer width = 512
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "�����Ƿ�"
end type

event clicked;if dw_insert.rowcount() < 1 then return

if dw_insert.getitemstring(1, "kumest_conf_yn") <> 'Y' then
	messagebox('Ȯ ��', '���ε� �ڷḸ �����Ƿ� �� �� �ֽ��ϴ�.')
	return
end if

if dw_insert.getitemstring(1, "kumest_makgub") <> '3' then
	f_message_chk(179, '[���۱���]')
	return
end if

gs_code 		= dw_insert.getitemstring(1, "kumest_kestno")
gs_codename = dw_insert.getitemstring(1, "kumest_estno")
open(w_pdt_02453)

setnull(gs_code)
setnull(gs_codename)

cb_inq.triggerevent(clicked!)

end event

