$PBExportHeader$w_gwdoc_update.srw
forward
global type w_gwdoc_update from w_inherite
end type
type sle_1 from singlelineedit within w_gwdoc_update
end type
type mle_1 from multilineedit within w_gwdoc_update
end type
type st_2 from statictext within w_gwdoc_update
end type
end forward

global type w_gwdoc_update from w_inherite
boolean ib_any_typing = false
sle_1 sle_1
mle_1 mle_1
st_2 st_2
end type
global w_gwdoc_update w_gwdoc_update

type variables
Transaction SQLCA1				// 그룹웨어 접속용
end variables

on w_gwdoc_update.create
int iCurrent
call super::create
this.sle_1=create sle_1
this.mle_1=create mle_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.mle_1
this.Control[iCurrent+3]=this.st_2
end on

on w_gwdoc_update.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_1)
destroy(this.mle_1)
destroy(this.st_2)
end on

event ue_open;call super::ue_open;String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn

// MsSql Server 접속
SQLCA1 = Create Transaction

select dataname into	 :ls_dbms     from syscnfg where sysgu = 'W' and serial = '6' and lineno = '1';
select dataname into	 :ls_database from syscnfg where sysgu = 'W' and serial = '6' and lineno = '2';
select dataname into	 :ls_id	 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '3';
select dataname into	 :ls_pwd 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '4';
select dataname into	 :ls_host 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '5';
select dataname into	 :ls_port 	  from syscnfg where sysgu = 'W' and serial = '6' and lineno = '6';

ls_conn_str = "DBMSSOCN,"+ls_host+","+ls_port 

SetNull(ls_reg_cnn)
RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", ls_host, RegString!, ls_reg_cnn) 

If Trim(Upper(ls_conn_str)) <> Trim(Upper(ls_reg_cnn)) Or &
	( ls_reg_cnn =""  Or isNull(ls_reg_cnn) )  Then
	RegistrySet("HKEY_LOCAL_MACHINE\Software\Microsoft\MSSQLServer\Client\ConnectTo", & 
					ls_host, RegString!, ls_conn_str)
End If

SQLCA1.DBMS = ls_dbms
SQLCA1.Database = ls_database
SQLCA1.LogPass = ls_pwd
SQLCA1.ServerName = ls_host
SQLCA1.LogId =ls_id
SQLCA1.AutoCommit = False
SQLCA1.DBParm = ""

CONNECT USING SQLCA1;
If sqlca1.sqlcode <> 0 Then
	messagebox(string(sqlca1.sqlcode),sqlca1.sqlerrtext)
	MessageBox('확 인','그룹웨어 연동을 할 수 없습니다.!!')
End If
end event

event open;call super::open;PostEvent("ue_open")
end event

event closequery;call super::closequery;disconnect	using	sqlca1 ;
destroy	sqlca1
end event

type dw_insert from w_inherite`dw_insert within w_gwdoc_update
end type

type p_delrow from w_inherite`p_delrow within w_gwdoc_update
end type

type p_addrow from w_inherite`p_addrow within w_gwdoc_update
end type

type p_search from w_inherite`p_search within w_gwdoc_update
end type

type p_ins from w_inherite`p_ins within w_gwdoc_update
end type

type p_exit from w_inherite`p_exit within w_gwdoc_update
end type

type p_can from w_inherite`p_can within w_gwdoc_update
end type

type p_print from w_inherite`p_print within w_gwdoc_update
end type

type p_inq from w_inherite`p_inq within w_gwdoc_update
end type

event p_inq::clicked;call super::clicked;String sGwno, sid
Int    rnum

BLOB scall

sGwno = trim(sle_1.text)

//SELECTBLOB HTMLCONTENT INTO :sCall FROM EAERPHTML
// WHERE CSCODE = 'BDS'
//   AND KEY1 = :sGwno USING SQLCA1;

// 발주품의서
//SELECTBLOB MACRO_FIELD_2 INTO :sCall FROM EAFOLDER_00022_ERP
// WHERE MACRO_FIELD_1 = :sgwno USING SQLCA1;

SELECT REPORTERID, REPORTNUM INTO :sid, :rnum
  FROM EAFOLDER_00022_ERP
 WHERE MACRO_FIELD_1 = :sgwno USING SQLCA1;
 
SELECTBLOB content INTO :scall 
  FROM approvaldocinfo
 WHERE reporterid = :sid
   AND reportnum = :rnum USING SQLCA1;

mle_1.text = String(scall)

end event

type p_del from w_inherite`p_del within w_gwdoc_update
end type

type p_mod from w_inherite`p_mod within w_gwdoc_update
end type

event p_mod::clicked;call super::clicked;String sGwno, sid
BLOB sCall
Int    rnum

sGwno = sle_1.text
sCall = BLOB(mle_1.text)


//UPDATEBLOB EAERPHTML SET HTMLCONTENT = :sCall 
// WHERE CSCODE = 'BDS'
//   AND KEY1 = :sGwno USING SQLCA1;
//	
//If sqlca1.SQLNRows = 0  Then
//	MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
//	RollBack USING SQLCA1;
//	Return -1
//End If
//
//// 발주품의서
//UPDATEBLOB EAFOLDER_00022_ERP SET MACRO_FIELD_2 = :sCall 
// WHERE MACRO_FIELD_1 = :sgwno USING SQLCA1;
//	
//If sqlca1.SQLNRows = 0  Then
//	MESSAGEBOX(STRING(SQLCA1.SQLCODE), SQLCA1.SQLERRTEXT)
//	RollBack USING SQLCA1;
//	Return -1
//End If

// 상신된 문서 직접 UPDATE
SELECT REPORTERID, REPORTNUM INTO :sid, :rnum
  FROM EAFOLDER_00022_ERP
 WHERE MACRO_FIELD_1 = :sgwno USING SQLCA1;
 
UPDATEBLOB approvaldocinfo SET content = :scall 
 WHERE reporterid = :sid
   AND reportnum = :rnum USING SQLCA1;
	
COMMIT USING SQLCA1;
end event

type cb_exit from w_inherite`cb_exit within w_gwdoc_update
end type

type cb_mod from w_inherite`cb_mod within w_gwdoc_update
end type

type cb_ins from w_inherite`cb_ins within w_gwdoc_update
end type

type cb_del from w_inherite`cb_del within w_gwdoc_update
end type

type cb_inq from w_inherite`cb_inq within w_gwdoc_update
end type

type cb_print from w_inherite`cb_print within w_gwdoc_update
end type

type st_1 from w_inherite`st_1 within w_gwdoc_update
end type

type cb_can from w_inherite`cb_can within w_gwdoc_update
end type

type cb_search from w_inherite`cb_search within w_gwdoc_update
end type







type gb_button1 from w_inherite`gb_button1 within w_gwdoc_update
end type

type gb_button2 from w_inherite`gb_button2 within w_gwdoc_update
end type

type sle_1 from singlelineedit within w_gwdoc_update
integer x = 457
integer y = 80
integer width = 777
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type mle_1 from multilineedit within w_gwdoc_update
integer x = 27
integer y = 276
integer width = 4594
integer height = 1932
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_gwdoc_update
integer x = 41
integer y = 80
integer width = 402
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "GW문서번호"
boolean focusrectangle = false
end type

