$PBExportHeader$w_mail_insert.srw
$PBExportComments$** 메일table에 바로 메세지 넣기
forward
global type w_mail_insert from w_inherite_popup
end type
type p_mod from uo_picture within w_mail_insert
end type
type dw_list from u_key_enter within w_mail_insert
end type
type dw_save from datawindow within w_mail_insert
end type
type gb_1 from groupbox within w_mail_insert
end type
end forward

global type w_mail_insert from w_inherite_popup
integer x = 1257
integer y = 188
integer width = 2226
integer height = 2008
string title = "메일 보내기"
boolean controlmenu = true
p_mod p_mod
dw_list dw_list
dw_save dw_save
gb_1 gb_1
end type
global w_mail_insert w_mail_insert

type variables
String is_win_id ,is_win_nm

Transaction SQLCA1
end variables

on w_mail_insert.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.dw_list=create dw_list
this.dw_save=create dw_save
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_save
this.Control[iCurrent+4]=this.gb_1
end on

on w_mail_insert.destroy
call super::destroy
destroy(this.p_mod)
destroy(this.dw_list)
destroy(this.dw_save)
destroy(this.gb_1)
end on

event open;call super::open;
dw_jogun.insertRow(0)

dw_jogun.Object.ssubj[1] = gs_code
dw_jogun.Object.sbody[1] = gs_codename

//트랜젝션 생성
String ls_dbms, ls_database, ls_port, ls_id, ls_pwd, ls_conn_str, ls_host, ls_reg_cnn
int	 ix

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
	

String ls_empnm, ls_re_mail

SELECT A.EMPNAME, B.EMAIL
  INTO :ls_empnm, :ls_re_mail
  FROM P1_MASTER A, P1_ETC B, P0_DEPT C
 WHERE A.EMPNO = B.EMPNO(+)
	AND A.DEPTCODE = C.DEPTCODE
	AND A.EMPNO = :gs_empno;

dw_jogun.Object.semp_nm[1] = ls_empnm
dw_jogun.Object.sfrom_addr[1] = ls_re_mail

dw_list.SetTransObject(sqlca)
dw_list.SetRedraw(False)

// gs_gubun이 null이면 전체 리스트 조회, 아니면 주소록에서 읽어온다
If Not IsNull(gs_gubun) Then
	dw_list.DataObject = 'd_mailsend_popup2'
	dw_list.SetTransObject(sqlca)
	If dw_list.Retrieve(gs_gubun, gs_saupj) > 0 Then		// 프로그램 ID로 조회
		For ix =1 To dw_list.RowCount()
			dw_list.SetItem(ix, 'sendyn','Y')
		Next
	End If
Else
	dw_list.DataObject = 'd_mailsend_popup1'
	dw_list.SetTransObject(sqlca)
	dw_list.Retrieve()
	
	dw_list.SetRedraw(True)
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('sbody')
End If

//If Not IsNull(gs_gubun) Then
//	dw_list.SetFilter("empname = '" +gs_gubun +"'")
//	dw_list.Filter()
//End If
//
//If dw_list.Retrieve() <= 0 Then
//	dw_list.SetFilter("")
//	dw_list.Filter()
//Else
//	dw_list.SetItem(1, 'sendyn','Y')
//End If

end event

event closequery;call super::closequery;disconnect	using	sqlca1 ;
destroy	sqlca1
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mail_insert
integer x = 55
integer y = 184
integer width = 2135
integer height = 868
string dataobject = "d_mailsend_popup"
end type

event dw_jogun::ue_pressenter;If GetColumnName() = "sbody" Then
	Return 
Else
	Send(Handle(this),256,9,0)
	Return
End If
end event

type p_exit from w_inherite_popup`p_exit within w_mail_insert
integer x = 1938
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mail_insert
boolean visible = false
integer x = 302
integer y = 1828
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_mail_insert
boolean visible = false
integer x = 2199
integer y = 664
end type

event p_choose::clicked;call super::clicked;//long 		ll_row
//string	smark=''
//
//FOR ll_row = 1 TO dw_1.rowcount()
//	smark = smark + dw_1.getitemstring(ll_row,'yn')
//NEXT
//
//gs_code = smark
//
//Close(Parent)
//
end event

type dw_1 from w_inherite_popup`dw_1 within w_mail_insert
boolean visible = false
integer x = 50
integer y = 196
integer width = 2217
integer height = 1372
integer taborder = 10
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::ue_pressenter;//If GetColumnName() = "sbody" Then
//	Return 
//Else
//	Send(Handle(this),256,9,0)
//	Return
//End If
end event

type sle_2 from w_inherite_popup`sle_2 within w_mail_insert
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_mail_insert
boolean visible = false
integer x = 357
integer y = 1908
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_mail_insert
boolean visible = false
integer x = 677
integer y = 1908
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_mail_insert
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mail_insert
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_mail_insert
boolean visible = false
end type

type p_mod from uo_picture within w_mail_insert
integer x = 1765
integer y = 24
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\전송_up.gif"
end type

event clicked;call super::clicked;String ls_subj ,ls_body ,ls_from_emp ,ls_from_addr , ls_sendyn , ls_today , ls_totime
String ls_recv_userid, ls_mail_table,ls_sqltext
Double ll_sp = 0
Int irtn , i ,ll_cnt = 0 ,ll_r, li_usernum, li_rwid

If dw_jogun.AcceptText() <> 1 Then Return

ls_subj      = Trim(dw_jogun.Object.ssubj[1])
ls_body      = Trim(dw_jogun.Object.sbody[1])

ls_from_emp  = Trim(dw_jogun.Object.semp_nm[1])           
ls_from_addr = Trim(dw_jogun.Object.sfrom_addr[1])  


If ls_subj = '' Or isNull(ls_subj) Then
	MessageBox('확인','메일 제목을 입력하세요')
	Return
End If

If ls_body = '' Or isNull(ls_body) Then
	MessageBox('확인','메일 내용을 입력하세요')
	Return
End If


//dw_save.Reset()
ls_today = f_today()
ls_totime = f_totime()

i 			= 0
ll_cnt 	= 0

do while pos(ls_body,'~h0D') > 0
	ls_body = left(ls_body,pos(ls_body,"~h0D") - 1) + '<BR>' + mid(ls_body,pos(ls_body,"~h0D") + 1)
loop	


do while dw_list.find("sendyn='Y'",i + 1,dw_list.rowcount()) > 0
	i = dw_list.find("sendyn='Y'",i + 1,dw_list.rowcount())
	
	ls_recv_userid = dw_list.getitemstring(i,"l_userid")
	
	//메일 테이블 명을 가져오자.
	
	SELECT 'mailbox_' + ltrim(STR(USERNUM)) + '_folder',   USERNUM
	  into :ls_mail_table, :li_usernum
	  FROM WBUSER
	 WHERE USERID = :ls_recv_userid using sqlca1; 
	
	ls_sqltext = "SELECT max(rwid) as rwid FROM "+ls_mail_table 

	dw_save.setsqlselect(ls_sqltext)
	dw_save.settransobject(sqlca1)
	
	if dw_save.retrieve() = 0 THEN
		MESSAGEBOX("rwid","error")
		continue
	end if
	li_rwid = dw_save.getitemnumber(1,"rwid") + 1
	
	ls_sqltext  = 'INSERT ' + ls_mail_table + ' ( usernum, mailboxid, rwid, senderid, title, receiveddate, sendeddate, vieweddate, isviewed, priority, isinside, msgsize, content ) '
	ls_sqltext += 'VALUES ( ' + string(li_usernum) + ', ' 	//usernum
	ls_sqltext += ' 0, ' 												//mailboxid
	ls_sqltext += "'"+string(li_rwid)+"', "						//rwid
	ls_sqltext += "'"+gs_userid+"', "								//senderid
	ls_sqltext += "'"+ls_subj+"', "									//title
	ls_sqltext += 'convert(varchar(8),getdate(),112)+ substring(convert(varchar(8),getdate(),114),1,2)'
   ls_sqltext += '+substring(convert(varchar(8),getdate(),114),4,2) + substring(convert(varchar(8),getdate(),114),7,2), ' //receiveddate
	ls_sqltext += 'convert(varchar(8),getdate(),112)+ substring(convert(varchar(8),getdate(),114),1,2)'
   ls_sqltext += '+substring(convert(varchar(8),getdate(),114),4,2) + substring(convert(varchar(8),getdate(),114),7,2), ' //sendeddate
//select convert(varchar(8),getdate(),112) ;	
	ls_sqltext += "' ' , "												//vieweddate
	ls_sqltext += '0 , '													//isviewed
	ls_sqltext += '0 , '													//priority
	ls_sqltext += '1 , '													//isinside
	ls_sqltext += '0 , '										         //msgsize		
	ls_sqltext += "'"+ls_body+"' ) "                         //content

	EXECUTE IMMEDIATE :ls_sqltext USING SQLCA1;
	
	IF sqlca1.sqlcode <> 0 THEN
		messagebox(STRING(i),SQLCA1.SQLERRTEXT)
		RollBack using sqlca1;
		RETURN
	END IF
	ll_cnt ++
	
	IF i = dw_list.rowcount() THEN EXIT
loop

If ll_cnt = 0 Then
	MessageBox('확인','보낼 사원을 선택하세요 . ' )
	Return
End If

IF sqlca1.sqlcode = 0 THEN
	COMMIT using sqlca1;
	messagebox(String(ll_cnt)+'. 메일전송','메일 보내기를 완료하였습니다.')
	Close(Parent)
Else
	messagebox(String(ll_cnt)+'. 메일전송','메일 보내기를 실패하였습니다.')
END IF
end event

type dw_list from u_key_enter within w_mail_insert
integer x = 87
integer y = 1136
integer width = 2043
integer height = 728
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_mailsend_popup1"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;String ls_col , ls_value , ls_dept , ls_empno
Long   i

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "is_check"

		ls_dept = Trim(Object.deptno[row])
		For i = row  To Rowcount()
			If ls_dept = Trim(Object.deptno[i] ) Then
				Object.sendyn[i] = ls_value
			Else
				Exit 
			End iF
		Next
	Case "sendyn"
		
		If ls_value = 'N' Then
			ls_dept = Trim(Object.deptno[row])
			For i = row  To Rowcount()
				If ls_dept = Trim(Object.deptno[i] ) Then
					Object.is_check[i] = ls_value
				Else
					Exit 
				End iF
			Next
		End If

END CHOOSE
end event

type dw_save from datawindow within w_mail_insert
boolean visible = false
integer x = 37
integer y = 16
integer width = 1239
integer height = 120
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_get_erp_mail_max_rowid"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_mail_insert
integer x = 69
integer y = 1068
integer width = 2089
integer height = 816
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "메일받는 사람"
end type

