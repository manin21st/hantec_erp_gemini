$PBExportHeader$w_voda_mailsend_popup.srw
$PBExportComments$** 메일보내기 팝업
forward
global type w_voda_mailsend_popup from w_inherite_popup
end type
type p_mod from uo_picture within w_voda_mailsend_popup
end type
type tab_1 from tab within w_voda_mailsend_popup
end type
type tabpage_1 from userobject within tab_1
end type
type dw_list from u_key_enter within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_list dw_list
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_key_enter within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_voda_mailsend_popup
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_2 from commandbutton within w_voda_mailsend_popup
end type
type cb_3 from commandbutton within w_voda_mailsend_popup
end type
type dw_3 from datawindow within w_voda_mailsend_popup
end type
end forward

global type w_voda_mailsend_popup from w_inherite_popup
integer x = 1257
integer y = 188
integer width = 2277
integer height = 1880
string title = "메일 보내기"
boolean controlmenu = true
p_mod p_mod
tab_1 tab_1
cb_2 cb_2
cb_3 cb_3
dw_3 dw_3
end type
global w_voda_mailsend_popup w_voda_mailsend_popup

type variables
String is_win_id ,is_win_nm

Transaction SQLCA3
end variables

on w_voda_mailsend_popup.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.tab_1=create tab_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.dw_3
end on

on w_voda_mailsend_popup.destroy
call super::destroy
destroy(this.p_mod)
destroy(this.tab_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.dw_3)
end on

event open;call super::open;wstr_parm lstr_parm 

lstr_parm = message.powerobjectparm

is_win_id = lstr_parm.s_parm[1]
is_win_nm = lstr_parm.s_parm[2]

If is_win_id = '' or isNull(is_win_id) Then
	Close(This)
	messagebox('','프로그램명이 없습니다.')
	return
End If

dw_jogun.insertRow(0)
dw_jogun.Object.spgm[1] = is_win_id
dw_jogun.Object.spgm_nm[1] = is_win_nm

String ls_empnm, ls_re_mail

SELECT A.EMPNAME, B.EMAIL
  INTO :ls_empnm, :ls_re_mail
  FROM P1_MASTER A, P1_ETC B, P0_DEPT C
 WHERE A.EMPNO = B.EMPNO(+)
	AND A.DEPTCODE = C.DEPTCODE
	AND A.EMPNO = :gs_empno;

dw_jogun.Object.semp_nm[1] = ls_empnm
dw_jogun.Object.sfrom_addr[1] = ls_re_mail

//dw_list.SetTransObject(sqlca)
//dw_list.Retrieve(is_win_id)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_voda_mailsend_popup
integer x = 50
integer y = 184
integer width = 2217
integer height = 936
string dataobject = "d_voda_mailsend_popup"
end type

event dw_jogun::ue_pressenter;If GetColumnName() = "sbody" Then
	Return 
Else
	Send(Handle(this),256,9,0)
	Return
End If
end event

type p_exit from w_inherite_popup`p_exit within w_voda_mailsend_popup
integer x = 2094
integer y = 32
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_voda_mailsend_popup
boolean visible = false
integer x = 302
integer y = 1828
boolean enabled = false
end type

type p_choose from w_inherite_popup`p_choose within w_voda_mailsend_popup
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

type dw_1 from w_inherite_popup`dw_1 within w_voda_mailsend_popup
boolean visible = false
integer x = 50
integer y = 196
integer width = 2217
integer height = 916
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

type sle_2 from w_inherite_popup`sle_2 within w_voda_mailsend_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_voda_mailsend_popup
boolean visible = false
integer x = 357
integer y = 1908
integer taborder = 20
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_voda_mailsend_popup
boolean visible = false
integer x = 677
integer y = 1908
integer taborder = 30
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_voda_mailsend_popup
boolean visible = false
integer x = 1074
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_voda_mailsend_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_voda_mailsend_popup
boolean visible = false
end type

type p_mod from uo_picture within w_voda_mailsend_popup
integer x = 1920
integer y = 32
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\전송_up.gif"
end type

event clicked;call super::clicked;String ls_subj ,  ls_from_emp ,ls_from_addr, ls_deptcode, ls_deptname, ls_mail_chk, ls_empname,  ls_email, ls_mail
String ls_project, ls_activity, ls_subject, ls_body, ls_from_nm, ls_from_mail_id, ls_to_nm, ls_to_mail_id
DOUBLE li_return
Double ll_sp = 0
Int irtn, ll_i, ll_i2, ll_i3, ll_i4

setpointer(hourglass!)
dw_3.settransobject(sqlca) 
dw_jogun.AcceptText ( )
tab_1.tabpage_1.dw_list.AcceptText ( )
tab_1.tabpage_2.dw_2.AcceptText ( )
If dw_jogun.AcceptText() <> 1 Then Return

ls_subj      = Trim(dw_jogun.Object.ssubj[1])
ls_body      = Trim(dw_jogun.Object.sbody[1])

ls_from_emp  = Trim(dw_jogun.Object.semp_nm[1])            // 임시 Setting
ls_from_addr = Trim(dw_jogun.Object.sfrom_addr[1])            // 임시 Setting

If ls_from_emp = '' Or isNull(ls_from_emp) Then
	MessageBox('확인','작성자 사원명을 입력하세요')
	Return
End If

If ls_from_addr = '' Or isNull(ls_from_addr) Then
	MessageBox('확인','작성자 메일 주소를 입력하세요')
	Return
End If


If ls_subj = '' Or isNull(ls_subj) Then
	MessageBox('확인','메일 제목을 입력하세요')
	Return
End If

If ls_body = '' Or isNull(ls_body) Then
	MessageBox('확인','메일 내용을 입력하세요')
	Return
End If

///////////////////////////////////////////////////////////////////////////////////////////////////////
//메일보내기 
if tab_1.tabpage_1.dw_list.rowcount() + tab_1.tabpage_2.dw_2.rowcount() < 1 then 
	Messagebox('확인', '받는사람 또는 받는부서를 선택하시오!') 
	Return 
End if 

//사원메일ID체크
if tab_1.tabpage_1.dw_list.rowcount() > 0 then 
	For ll_i = 1 to tab_1.tabpage_1.dw_list.rowcount()
		ls_to_nm = tab_1.tabpage_1.dw_list.object.empname[ll_i] 
		ls_to_mail_id = tab_1.tabpage_1.dw_list.object.empname[ll_i] 
		if trim(ls_to_mail_id) = '' or isnull(ls_to_mail_id) then 
			Messagebox('확인', '사원[' + ls_to_nm + '] 의 메일주소가 입력되지 않았습니다 ' )
			Return 
		End if 
	Next 
End if 

//부서원 메일ID체크
if tab_1.tabpage_2.dw_2.rowcount() > 0 then 
	For ll_i = 1 to tab_1.tabpage_2.dw_2.rowcount()
		ls_deptcode = tab_1.tabpage_2.dw_2.object.deptcode[ll_i]
		ls_deptname = tab_1.tabpage_2.dw_2.object.deptname[ll_i]
		
		//부서체크
		if ls_deptcode = '' or isnull(ls_deptcode) then 
			Messagebox('확인', '부서정보가 명확하지 않습니다. 다시 확인하시오!' ) 
			Return 
		End if 
		//부서원체크
		if dw_3.retrieve(ls_deptcode) < 1 then 
			Messagebox('확인', '부서 [' + ls_deptname + '] 에 부서원이 등록되어 있지 않습니다') 
		   Return 
		End if 
		
		//
		if dw_3.rowcount() > 0 then
			ls_mail_chk = ' ' 
			For ll_i2 = 1 to dw_3.rowcount() 
				ls_empname = dw_3.object.empname[ll_i2]
				ls_email   = dw_3.object.email[ll_i2]
				
				if ls_email = '' or isnull(ls_email) then 
					ls_mail_chk = trim(ls_mail_chk) + ' ' + ls_empname
				end if 
			Next
				if trim(ls_mail_chk) = '' or isnull(ls_mail_chk) then 
					Messagebox('확인', '부서 [' + ls_deptname + ']에 등록되지 않은  ~n' + '사번리스트 [' + ls_mail_chk + '] ')
				End if 
		End if 
			
	Next 
End if 

//프로시저 선언
DECLARE lsp_mailsend procedure for sp_voda_mailsend
(:ls_subject, :ls_body, :ls_from_nm, :ls_from_mail_id, :ls_to_nm, :ls_to_mail_id) ;


//////////////////////////////////////////////////////////////////////////////
//해당사원메일 보내기
if tab_1.tabpage_1.dw_list.rowcount() > 0 then 
	For ll_i = 1 to tab_1.tabpage_1.dw_list.rowcount()
		ls_to_nm = tab_1.tabpage_1.dw_list.object.empname[ll_i] 
		ls_to_mail_id = tab_1.tabpage_1.dw_list.object.addr_to[ll_i] 
		if trim(ls_to_mail_id) <> '' and isnull(ls_to_mail_id) = false then 
			//메일 보내기
			ls_subject 		 = dw_jogun.object.ssubj[1]
			ls_body    		 = dw_jogun.object.sbody[1]
			ls_from_nm 		 = dw_jogun.object.semp_nm[1]
			ls_from_mail_id = dw_jogun.object.sfrom_addr[1]
			//
			ls_to_nm 		 = tab_1.tabpage_1.dw_list.object.empname[ll_i]
			ls_to_mail_id 	 = tab_1.tabpage_1.dw_list.object.addr_to[ll_i]
			
			Execute lsp_mailsend ;
			IF SQLCA.SQLCODE = -1 THEN 
				MESSAGEBOX('에러', SQLCA.SQLERRTEXT)
			eND IF 	

		End if 
	Next 
End if 

//부서원에 메일보내기
if tab_1.tabpage_2.dw_2.rowcount() > 0 then 
	For ll_i = 1 to tab_1.tabpage_2.dw_2.rowcount()
		ls_subject 		 = dw_jogun.object.ssubj[1]
		ls_body    		 = dw_jogun.object.sbody[1]
		ls_from_nm 		 = dw_jogun.object.semp_nm[1]
		ls_from_mail_id = dw_jogun.object.sfrom_addr[1]
		//하위
		ls_deptcode 	 = tab_1.tabpage_2.dw_2.object.deptcode[ll_i]
		ls_deptname 	 = tab_1.tabpage_2.dw_2.object.deptname[ll_i]
		
		ls_deptcode = tab_1.tabpage_2.dw_2.object.deptcode[ll_i]
		ls_deptname = tab_1.tabpage_2.dw_2.object.deptname[ll_i]
		
		//부서원체크
		if dw_3.retrieve(ls_deptcode) < 1 then 
		   continue  
		End if 

		if dw_3.rowcount() > 0 then
			For ll_i2 = 1 to dw_3.rowcount() 
			ls_mail_chk = ' ' 
				ls_empname = dw_3.object.empname[ll_i2]
				ls_email   = dw_3.object.email[ll_i2]
				
				if ls_email <> '' and isnull(ls_email) = false then 
					ls_mail_chk = trim(ls_mail_chk) + ' ' + ls_empname

					//메일 보내기
					ls_to_nm = ls_empname
					ls_to_mail_id = ls_email
					
					Execute lsp_mailsend ;
					IF SQLCA.SQLCODE = -1 THEN 
						MESSAGEBOX('에러', SQLCA.SQLERRTEXT)
					eND IF 	

				end if 
			Next
		End if 
			
	Next 
End if 

close lsp_mailsend ;

setpointer(arrow!)
dw_jogun.object.ssubj[1] = '' 
dw_jogun.object.sbody[1] = ''

tab_1.tabpage_1.dw_list.reset() 
tab_1.tabpage_2.dw_2.reset()

Messagebox('확인', '메일이 전송 되었습니다!') 

Close(parent)


end event

type tab_1 from tab within w_voda_mailsend_popup
event create ( )
event destroy ( )
integer x = 59
integer y = 1116
integer width = 2185
integer height = 680
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 2149
integer height = 568
long backcolor = 32106727
string text = "받는 사람"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_list dw_list
end type

on tabpage_1.create
this.dw_list=create dw_list
this.Control[]={this.dw_list}
end on

on tabpage_1.destroy
destroy(this.dw_list)
end on

type dw_list from u_key_enter within tabpage_1
integer y = 4
integer width = 2144
integer height = 552
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_voda_mailsend_popup1"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;String ls_empno, ls_empname, ls_email, ls_deptcode, ls_deptname 

if getcolumnname() = 'empno' then 
	ls_empno = gettext() 
	select a.empno, 
			 a.empname, 
			 c.email,
			 b.deptname 
	  into :ls_empno,
	  		 :ls_empname,
			 :ls_email,
			 :ls_deptname
	  From p1_master a, p0_dept b ,P1_ETC c 
	 where a.deptcode = b.deptcode
	   and a.empno    = c.empno(+)
	   and a.empno = :ls_empno; 
		
	if sqlca.sqlcode <> 0 then 
		Messagebox('확인', '잘못된 사원코드를 입력했습니다') 
		Return 
	End if 
	this.setitem(row, 'empname', ls_empname) 
	this.setitem(row, 'addr_to', ls_email) 
	this.setitem(row, 'deptname', ls_deptname) 

elseif  getcolumnname() = 'empname' then 
	ls_empname = gettext()
	select a.empno, 
			 a.empname, 
			 c.email,
			 b.deptname 
	  into :ls_empno,
	  		 :ls_empname,
			 :ls_email,
			 :ls_deptname
	  From p1_master a, p0_dept b ,P1_ETC c 
	 where a.deptcode = b.deptcode
	   and a.empno    = c.empno(+) 
	   and a.empname = :ls_empname; 
		
	if sqlca.sqlcode <> 0 then 
		Messagebox('확인', '잘못된 사원코드를 입력했습니다') 
		Return 
	End if 

	this.setitem(row, 'empno', ls_empno) 
	this.setitem(row, 'addr_to', ls_email) 
	this.setitem(row, 'deptname', ls_deptname) 

End if 


end event

event rbuttondown;call super::rbuttondown;string ls_empno, ls_empname, ls_email, ls_deptname

IF GetColumnName() = 'empno' THEN

	open(w_sawon_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'empno', gs_code)
	SetItem(row, 'empname', gs_codename)

	select a.empno, 
			 a.empname, 
			 c.email,
			 
			 b.deptname 
	  into :ls_empno,
	  		 :ls_empname,
			 :ls_email,
			 :ls_deptname
	  From p1_master a, p0_dept b, P1_ETC c 
	 where a.deptcode = b.deptcode 
	   and a.empno = c.empno(+)
	 	and a.empno = :gs_code ; 
	
	this.setitem(row, 'empname', ls_empname) 
	this.setitem(row, 'addr_to', ls_email) 
	this.setitem(row, 'deptname', ls_deptname) 

elseIF GetColumnName() = 'empname' THEN

	open(w_sawon_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'empno', gs_code)
	SetItem(row, 'empname', gs_codename)
	this.triggerevent('itemchanged')

	select a.empno, 
			 a.empname, 
			 c.email,
			 b.deptname 
	  into :ls_empno,
	  		 :ls_empname,
			 :ls_email,
			 :ls_deptname
	  From p1_master a, p0_dept b , P1_ETC c 
	 where a.deptcode = b.deptcode
	   and a.empno    = c.empno(+)
	 	and a.empname = :gs_codename ; 
	
	this.setitem(row, 'empno', ls_empno) 
	this.setitem(row, 'addr_to', ls_email) 
	this.setitem(row, 'deptname', ls_deptname) 

End if 
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 2149
integer height = 568
long backcolor = 32106727
string text = "받는 부서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_key_enter within tabpage_2
integer y = 4
integer width = 2144
integer height = 552
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_voda_mailsend_popup2"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;IF GetColumnName() = 'deptcode' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'deptcode', gs_code)
	SetItem(row, 'deptname', gs_codename)
elseIF GetColumnName() = 'deptname' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'deptcode', gs_code)
	SetItem(row, 'deptname', gs_codename)
	
End if 
end event

event itemchanged;call super::itemchanged;string ls_deptcode, ls_deptname 

if dwo.name = 'deptcode' then 
	ls_deptcode = gettext() 
	select deptname 
	  into :ls_deptname 
	  From p0_dept 
	 where deptcode = :ls_deptcode ; 
	if sqlca.sqlcode <> 0 then 
		Messagebox('확인', '잘못된 부서정보를 입력했습니다') 
		Return 
	End if 
	this.setitem(row, 'deptname' , ls_deptname) 
elseif  dwo.name = 'deptname' then 
	ls_deptname = gettext() 
	select deptcode 
	  into :ls_deptcode 
	  From p0_dept 
	 where deptname = :ls_deptname ; 
	if sqlca.sqlcode <> 0 then 
		Messagebox('확인', '잘못된 부서정보를 입력했습니다') 
		Return 
	End if 
	this.setitem(row, 'deptcode' , ls_deptcode) 
End if 


end event

type cb_2 from commandbutton within w_voda_mailsend_popup
integer x = 2011
integer y = 1116
integer width = 233
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제"
end type

event clicked;Long ll_row

if tab_1.selectedtab = 1 then
	ll_row = tab_1.tabpage_1.dw_list.getrow()
	tab_1.tabpage_1.dw_list.deleterow(ll_row)
else 
	ll_row = tab_1.tabpage_2.dw_2.getrow()
	tab_1.tabpage_2.dw_2.deleterow(ll_row)
End if 

end event

type cb_3 from commandbutton within w_voda_mailsend_popup
integer x = 1774
integer y = 1116
integer width = 233
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가"
end type

event clicked;if tab_1.selectedtab = 1 then
	tab_1.tabpage_1.dw_list.insertrow(0) 
else 
	tab_1.tabpage_2.dw_2.insertrow(0) 
End if 
end event

type dw_3 from datawindow within w_voda_mailsend_popup
boolean visible = false
integer x = 549
integer y = 684
integer width = 937
integer height = 400
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_voda_mailsend_popup3"
boolean livescroll = true
end type

