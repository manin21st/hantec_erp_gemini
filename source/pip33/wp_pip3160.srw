$PBExportHeader$wp_pip3160.srw
$PBExportComments$** 급여/상여 명세서(이메일전송NEW)
forward
global type wp_pip3160 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3160
end type
type dw_2 from datawindow within wp_pip3160
end type
type dw_read from dw_list within wp_pip3160
end type
type p_send1 from uo_picture within wp_pip3160
end type
type dw_save from dw_list within wp_pip3160
end type
type dw_emp from datawindow within wp_pip3160
end type
type cb_pdf from commandbutton within wp_pip3160
end type
type cb_cnf from commandbutton within wp_pip3160
end type
type p_send from uo_picture within wp_pip3160
end type
type st_100 from statictext within wp_pip3160
end type
type st_rcvpct from statictext within wp_pip3160
end type
type rr_6 from roundrectangle within wp_pip3160
end type
type rr_1 from roundrectangle within wp_pip3160
end type
end forward

global type wp_pip3160 from w_standard_print
integer x = 0
integer y = 0
integer width = 4576
integer height = 2272
string title = "급여/상여 명세서"
boolean minbox = false
dw_1 dw_1
dw_2 dw_2
dw_read dw_read
p_send1 p_send1
dw_save dw_save
dw_emp dw_emp
cb_pdf cb_pdf
cb_cnf cb_cnf
p_send p_send
st_100 st_100
st_rcvpct st_rcvpct
rr_6 rr_6
rr_1 rr_1
end type
global wp_pip3160 wp_pip3160

type variables
String IsYm,IsSaup,Isgubun,IsEmpno, IsBigo, Is_OsGubun   //설치된 os버젼(1:W10이상, 2:W10이하)
//메일보내기
n_smtp gn_smtp
end variables

forward prototypes
public function integer wf_settext2 ()
public function integer wf_psettext ()
public function integer wf_psettext2 ()
public function integer wf_settext ()
public function integer wf_retrieve ()
public function string wf_getreg (string as_entry, string as_default)
public function boolean wf_send_mail (string sempno, string sempname, string sfilename, string stomaidaddr, string sbody, string stitle)
end prototypes

public function integer wf_settext2 (); String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"allowname")
   dw_list.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 
// dw_list.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_psettext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_print.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text117.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text118.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text119.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text120.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text121.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text122.text = '"+sName+"'")
 
 
 //dw_print.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_psettext2 (); String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"allowname")
   dw_print.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text214.text = '"+sName+"'")
 
// dw_print.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_list.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text117.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text118.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text119.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text120.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text121.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text122.text = '"+sName+"'") 
// dw_list.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_retrieve ();String  sDeptcode,sJikjong,sKunmu, ls_bigo
integer iRtnValue
dw_ip.AcceptText()

IsYm      = dw_ip.GetITemString(1,"l_ym")
IsSaup    = dw_ip.GetITemString(1,"l_saup")
Isgubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
IsEmpno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
sJikjong = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))
IsBigo = dw_ip.GetItemString(1,"bigo")


IF sJikjong = '' OR IsNull(sJikjong) THEN sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
IF IsEmpno  = '' OR  IsNull(IsEmpno) THEN IsEmpno = '%'
		 
IF IsYm = "      " OR IsNull(IsYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(IsYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	MessageBox("확 인","사업장을 입력하세요!!")
//	dw_ip.SetColumn("l_saup")
//	dw_ip.SetFocus()
//	Return -1
//END IF	
IF Isgubun = '' OR ISNULL(Isgubun) THEN
	MessageBox("확 인","구분을 입력하세요!!")
	dw_ip.SetColumn("l_gubn")
	dw_ip.SetFocus()
	Return -1
END IF	

IF IsSaup = '' OR ISNULL(IsSaup) THEN
	IsSaup = '%'	
END IF	

IF IsEmpno = '' OR ISNULL(IsEmpno) THEN
	IsEmpno = '%'
END IF	

IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
	sDeptcode = '%'
END IF	

SetPointer(HourGlass!)
dw_list.Setredraw(false)

IF dw_emp.Retrieve(IsSaup,IsYm,sDeptcode,Isgubun,IsEmpno,sJikjong,sKunmu) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
END IF
	
dw_list.object.datawindow.print.preview = "yes"
dw_list.Setredraw(true)
SetPointer(Arrow!)
//dw_list.Modify("t_bigo1.text = '" + IsBigo + "' ")
//dw_list.Modify("t_bigo2.text = '" + IsBigo + "' ")
//dw_print.Modify("t_bigo1.text = '" + IsBigo + "' ")
//dw_print.Modify("t_bigo2.text = '" + IsBigo + "' ")

Return 1

end function

public function string wf_getreg (string as_entry, string as_default);String ls_regkey, ls_regvalue

ls_regkey = "HKEY_CURRENT_USER\Software\yearend\EmailSMTP"

RegistryGet(ls_regkey, as_entry, ls_regvalue)
If ls_regvalue = "" Then
	ls_regvalue = as_default
End If

Return ls_regvalue
 
end function

public function boolean wf_send_mail (string sempno, string sempname, string sfilename, string stomaidaddr, string sbody, string stitle);String  ls_server, ls_uid
String  ls_port, ls_encrypt, ls_errormsg
//Integer li_idx, li_max
Boolean lb_html, lb_Return
UInt lui_port

String ls_Send_MailId, ls_Send_MailPw, ls_Send_SmtpId

SetPointer(HourGlass!)

ls_server = wf_getreg("Server", "")
ls_Send_MailId = wf_getreg("Userid", "")
ls_Send_SmtpId = wf_getreg("SmtpMail", "")
ls_Send_MailPw = wf_getreg("Password", "") 

lb_html = False
lui_port = Long(wf_getreg("Port", "25"))

// *** set email properties *********************
gn_smtp.of_ResetAll()
gn_smtp.of_SetPort(lui_port)
gn_smtp.of_SetServer(ls_server)

sBody = '한달 동안 고생 많으셨습니다.'

gn_smtp.of_SetSubject(sTitle)  // 제목  
gn_smtp.of_SetBody(sBody, lb_html)     // 내용  
gn_smtp.of_SetFrom(ls_Send_MailId, '급여담당자')  // 보내는 사람 이름 
gn_smtp.of_AddAddress(stomaidaddr, sempname)  // 받는사람이름 

// *** set Userid/Password if required **********
If wf_getreg("Auth", "N") = "Y" Then
  gn_smtp.of_SetLogin(ls_Send_SmtpId, ls_Send_MailPw)
End If

//MessageBox('확인',sfilename)

 gn_smtp.of_AddAttachment(sfilename)
 
// *** send the message *************************
ls_encrypt = wf_getreg("Encrypt", "None")
choose case ls_encrypt
   case "SSL"
      lb_Return = gn_smtp.of_SendSSLMail()
   case "TLS"
      lb_Return = gn_smtp.of_SendTLSMail()
   case else
      lb_Return = gn_smtp.of_SendMail()
end choose


//If lb_Return Then
// MessageBox("SendMail", "Mail successfully sent!")
//Else
// MessageBox("SendMail Error", gn_smtp.of_GetLastError())
//End If

Return lb_Return


//
end function

on wp_pip3160.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_read=create dw_read
this.p_send1=create p_send1
this.dw_save=create dw_save
this.dw_emp=create dw_emp
this.cb_pdf=create cb_pdf
this.cb_cnf=create cb_cnf
this.p_send=create p_send
this.st_100=create st_100
this.st_rcvpct=create st_rcvpct
this.rr_6=create rr_6
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_read
this.Control[iCurrent+4]=this.p_send1
this.Control[iCurrent+5]=this.dw_save
this.Control[iCurrent+6]=this.dw_emp
this.Control[iCurrent+7]=this.cb_pdf
this.Control[iCurrent+8]=this.cb_cnf
this.Control[iCurrent+9]=this.p_send
this.Control[iCurrent+10]=this.st_100
this.Control[iCurrent+11]=this.st_rcvpct
this.Control[iCurrent+12]=this.rr_6
this.Control[iCurrent+13]=this.rr_1
end on

on wp_pip3160.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_read)
destroy(this.p_send1)
destroy(this.dw_save)
destroy(this.dw_emp)
destroy(this.cb_pdf)
destroy(this.cb_cnf)
destroy(this.p_send)
destroy(this.st_100)
destroy(this.st_rcvpct)
destroy(this.rr_6)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_emp.SetTransObject(sqlca)

dw_ip.SetITem(1,"l_ym",f_aftermonth(left(f_today(),6),-1))
dw_ip.SetITem(1,"l_gubn",'P')
dw_list.insertrow(0)

f_set_saupcd(dw_ip, 'l_saup', '1')
is_saupcd = gs_saupcd

dw_ip.SetItem(1, "bigo", "개인임금을 타직원과 공유시 징계조치됩니다.")


//설치된 os버젼
select nvl(dataname,'N')  into :Is_OsGubun  from p0_syscnfg where sysgu = 'P' and serial = 96 and lineno = 'E' ;
if sqlca.sqlcode <> 0 then
	Is_OsGubun = '1'
else
	if IsNull(Is_OsGubun) then Is_OsGubun = '1'
end if
p_retrieve.TriggerEvent(Clicked!)
wf_settext()
wf_settext2()
wf_psettext()
wf_psettext2()	
	

st_100.Visible = false
st_rcvpct.Visible = false
end event

type p_xls from w_standard_print`p_xls within wp_pip3160
integer x = 3360
integer y = 272
end type

type p_sort from w_standard_print`p_sort within wp_pip3160
integer x = 3538
integer y = 268
end type

type p_preview from w_standard_print`p_preview within wp_pip3160
integer x = 4027
end type

event p_preview::clicked;//String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode
//integer iRtnValue
//dw_ip.AcceptText()
//
//sYm      = dw_ip.GetITemString(1,"l_ym")
//sSaup    = dw_ip.GetITemString(1,"l_saup")
//ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
//ls_Empno = dw_ip.GetITemString(1,"l_empno")
//sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
//			  
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'	
//END IF	
//
//IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
//	ls_Empno = '%'
//END IF	
//
//IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
//	sDeptcode = '%'
//END IF

WF_PSETTEXT()
WF_PSETTEXT2()

//dw_print.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within wp_pip3160
integer x = 4375
end type

type p_print from w_standard_print`p_print within wp_pip3160
integer x = 4201
end type

event p_print::clicked;//String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode
//integer iRtnValue
//dw_ip.AcceptText()
//
//sYm      = dw_ip.GetITemString(1,"l_ym")
//sSaup    = dw_ip.GetITemString(1,"l_saup")
//ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
//ls_Empno = dw_ip.GetITemString(1,"l_empno")
//sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
//			  
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'	
//END IF	
//
//IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
//	ls_Empno = '%'
//END IF	
//
//IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
//	sDeptcode = '%'
//END IF	

WF_PSETTEXT()
WF_PSETTEXT2()

//dw_print.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip3160
integer x = 3854
end type

type st_window from w_standard_print`st_window within wp_pip3160
integer x = 2336
integer y = 2584
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3160
integer x = 361
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3160
integer x = 2830
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within wp_pip3160
integer x = 0
integer y = 2584
end type



type dw_print from w_standard_print`dw_print within wp_pip3160
integer x = 3739
integer y = 296
integer width = 183
string dataobject = "dp_pip3160_30_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3160
integer x = 96
integer y = 40
integer width = 3241
integer height = 424
string dataobject = "dp_pip3160_10"
end type

event dw_ip::itemchanged;String sDeptno,sName,snull,sEmpNo,sEmpName
Integer k
SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
	IsSaup = this.GetText()
	sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN RETURN
	  SELECT "P0_DEPT"."DEPTNAME"  
       INTO :sName  
       FROM "P0_DEPT"  
		WHERE "P0_DEPT"."SAUPCD" =:sDeptno ;
		IF sName = '' OR ISNULL(sName) THEN
			MessageBox("확 인","사업장번호를 확인하세요!!")  
			dw_ip.SetITem(1,"l_saup",snull)
			Return 1
		END IF
END IF	


IF dw_ip.GetColumnName() ="l_dept" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"l_dept",snull)
		dw_ip.SetITem(1,"l_deptname",snull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_ip.SetITem(1,"l_dept",snull)
	   dw_ip.SetITem(1,"l_deptname",snull) 
		dw_ip.SetColumn("l_dept")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"l_deptname",sName) 
END IF
IF dw_ip.GetColumnName() = "l_empno" then
   sEmpNo = dw_ip.GetItemString(1,"l_empno")
	
	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"l_empno",snull)
		dw_ip.SetITem(1,"l_empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"l_empno",snull)
				 dw_ip.SetITem(1,"l_empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"l_empname",sEmpName  )
				
	 END IF
END IF

IF  dw_ip.GetColumnName() = "allchk" then 
	IF DATA = 'Y' THEN
		for k = 1 to dw_emp.RowCount()
			dw_emp.SetItem(k,"calccheck",'Y')
		next	
	ELSE
		for k = 1 to dw_emp.RowCount()
			dw_emp.SetItem(k,"calccheck",'N')
		next			
	END IF
END IF

IF dw_ip.GetColumnName() = "bigo" then
    IsBigo = data
END IF

IF dw_ip.GetColumnName() = "l_gubn" then
    Isgubun = data
END IF

IF dw_ip.GetColumnName() = "l_ym" then
    IsYm = data
END IF






end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_Gubun)

Gs_Gubun = is_saupcd
IF dw_ip.GetColumnName() = "l_dept" THEN
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"l_dept",gs_code)
	dw_ip.SetITem(1,"l_deptname",gs_codename)
END IF	

IF dw_ip.GetColumnName() = "l_empno" THEN
   Open(w_employee_saup_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"l_empno",gs_code)
	dw_ip.SetITem(1,"l_empname",gs_codename)
  
END IF	
end event

event dw_ip::ue_pressenter;if this.GetColumnName() <> "bigo" then
	Send(Handle(this),256,9,0)
	Return 1	
end if

end event

type dw_list from w_standard_print`dw_list within wp_pip3160
integer x = 1248
integer y = 476
integer width = 3223
integer height = 1600
string dataobject = "dp_pip3160_30_p"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::rowfocuschanged;//override

end event

type dw_1 from datawindow within wp_pip3160
boolean visible = false
integer x = 151
integer y = 2208
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_pip3160_30_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3160
boolean visible = false
integer x = 1504
integer y = 2544
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_pip3160_30_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_read from dw_list within wp_pip3160
boolean visible = false
integer x = 1051
integer y = 2192
integer width = 1920
integer height = 588
boolean bringtotop = true
string dataobject = "dp_pip3140_read"
boolean hsplitscroll = true
end type

type p_send1 from uo_picture within wp_pip3160
boolean visible = false
integer x = 4338
integer y = 288
integer width = 178
boolean bringtotop = true
string picturename = "C:\Erpman\image\메일전송_up.gif"
end type

event clicked;call super::clicked;
/*방화벽과 SSL연결 문제로 사용하지 않음*/

//Boolean lb_Return
//String ls_Send_MailId, ls_Send_MailPw, ls_server, ls_errormsg,ls_To_MailId, ls_body, ls_title, ls_Pbtag
//String sSaupcd,sfyymm,spbtag,sbigo, sEmpno, sCompany
// 
//ls_server = wf_getreg("Server", "")
//If ls_server = "" Then
//   MessageBox("확인", "메일환경설정을 먼저 하십시오!", StopSign!)
//   Return
//End If
//
//// sle_from_email 보내는사람 이메일주소 
//ls_Send_MailId = wf_getreg("Userid", "")
//If ls_Send_MailId = "" Then
//   MessageBox("확인", "메일환경설정을 먼저 하십시오!", StopSign!)
//   Return
//End If
//
//If Not gn_smtp.of_ValidEmail(ls_Send_MailId, ls_errormsg) Then
//   MessageBox("확인", ls_errormsg, StopSign!)
//   Return
//End If
//ls_Send_MailPw = wf_getreg("Password", "") 
//If ls_Send_MailPw = "" Then
//   MessageBox("확인", "메일환경설정을 먼저 하십시오!", StopSign!)
//   Return
//End If
//
//String ls_filename,  sEmpName
//Integer iCnt, i, iempcnt
//
//IF dw_emp.RowCount() < 0 THEN
//    MessageBox('확인', '메일을 보낼 대상자를 먼저 조회하세요!')
//	Return 
//END IF 
//
//if dw_ip.Accepttext() = -1 then return
//if dw_emp.Accepttext() = -1 then return
//
//sCompany = gs_company
//sSaupcd =  dw_ip.GetItemString( 1, "l_saup");  
//sfyymm = dw_ip.GetItemString( 1, "l_ym");  
//spbtag  = dw_ip.GetItemString( 1, "l_gubn");   
//sbigo  = dw_ip.GetItemString( 1, "bigo");   
//ls_Pbtag = dw_ip.Describe("evaluate('lookupdisplay(l_gubn)',1)")
//if IsNull(ls_Pbtag)  or ls_Pbtag = '' then ls_Pbtag = '급여(상여)'
//
//if isNull(sSaupcd) or sSaupcd = '' then sSaupcd = "%"
//if isNull(spbtag) or spbtag = '' then spbtag = "%"
//ls_title = left(  sfyymm, 4 ) + '년' +Right(  sfyymm, 2 ) + '월 ' + ls_Pbtag + '명세서 입니다.'
//
//SetPointer(HourGlass!)
//w_mdi_frame.sle_msg.text = '첨부자료를 생성하는 중입니다!'		
//cb_pdf.TriggerEvent(Clicked!)
//		
////SetPointer(HourGlass!)
//w_mdi_frame.sle_msg.text = '메일 발송 중입니다!'
//	
//	
//iCnt = 0 
//for i = 1 to dw_emp.RowCount()		
//	Setnull(sEmpno)
//	
//	if dw_emp.GetItemString(i,"calccheck") = 'Y' then			
//		sEmpno = dw_emp.GetItemString(i, "empno")
//		sEmpName = dw_emp.GetItemString(i, "empname")
//		
//		if sEmpno = '' or isNull(sEmpno) then continue
//		//ls_title = left(  sfyymm, 4 ) + '년' +Right(  sfyymm, 2 ) + '월 '+ sEmpName+ '님의 '+ ls_Pbtag + '명세서 입니다.'	
//	 
//		ls_filename = 'c:\erpman\pay\pdf'
//		ls_filename =ls_filename  +'\' +  left(  sfyymm, 4 ) +'년'+Right(  sfyymm, 2 ) + '월 '+ ls_Pbtag + '명세서 -' +  sEmpno+'' + '('+ ''+ sEmpName + ''+')' + '.pdf'	
// 
//		String sTempEmail					
//		// 받는사람 이메일주소 
//// 		ls_To_MailId = dw_emp.GetItemString(i,'email')
//		//ls_To_MailId = 'qufvy@ihantec.com'
//	ls_To_MailId = 'limgy@willdo.co.kr' 
//		if IsNull(ls_To_MailId) or ls_To_MailId = '' then continue
//		If Not gn_smtp.of_ValidEmail(ls_To_MailId, ls_errormsg) Then continue
//		
//		lb_Return = Wf_Send_Mail(sEmpno,sEmpName, ls_filename, ls_To_MailId, ls_body, ls_title)
//		if lb_Return = False then continue
//		iCnt ++
//	end if 
//next
//
//IF iCnt = 0 THEN
//	MessageBox('확인','메일을 보낼 사원을 선택하십시오')
//	return
//end if
//w_mdi_frame.sle_msg.text = '메일 보내기를 완료 되었습니다!'
//MessageBox('확인','메일 보내기를 완료하였습니다')
//
//
//
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

type dw_save from dw_list within wp_pip3160
boolean visible = false
integer x = 3630
integer y = 2428
integer width = 151
integer height = 132
integer taborder = 20
boolean bringtotop = true
string dataobject = "dp_pip3140_mail2"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

type dw_emp from datawindow within wp_pip3160
integer x = 133
integer y = 476
integer width = 1070
integer height = 1588
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "dp_pip3160_20"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;If CurrentRow <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(CurrentRow, TRUE)
	dw_ip.AcceptText()
	
	IsEmpNo =dw_emp.GetItemString(CurrentRow,"empno") 
	IsBigo = dw_ip.GetItemString(1,"bigo")
	dw_list.Retrieve(IsSaup,IsYm,Isgubun,IsEmpno,IsBigo) 
	dw_print.Modify("t_bigo.text = '" + IsBigo + "' ")
	dw_list.Modify("t_bigo.text = '" + IsBigo + "' ")	
	
END IF
end event

event clicked;String sData
Integer  k
dw_ip.Accepttext()
this.SelectRow(0,False)
this.SelectRow(row,true)

If row > 0 then 
	IsEmpNo =dw_emp.GetItemString(row,"empno") 
	IsBigo = dw_ip.GetItemString(1,"bigo")
	
	dw_list.Retrieve(IsSaup,IsYm,Isgubun,IsEmpno,IsBigo)

	dw_print.Modify("t_bigo.text = '" + IsBigo + "' ")
	dw_list.Modify("t_bigo.text = '" + IsBigo + "' ")
	dw_list.object.datawindow.print.preview = "yes"	
End If

end event

type cb_pdf from commandbutton within wp_pip3160
boolean visible = false
integer x = 4073
integer y = 292
integer width = 247
integer height = 140
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "pdf저장"
end type

event clicked;String sfyymm, spbtag, sPaydate, sTag, sSemu, sPgubun, sSaupcd, sCompany, sEmpno, ls_filename, syear, sEmpName, sOsVersion, ls_Pbtag, sbigo
String sModStr  = 'PAY_MAIL'
Integer iCnt, i, iempcnt 

IF dw_emp.RowCount() < 0 THEN
    MessageBox('확인', '출력할 대상자를 먼저 조회하세요!')
	Return 
END IF 

if dw_emp.Accepttext() = -1 then return
if dw_ip.Accepttext() = -1 then return

sCompany = gs_company
sSaupcd =  dw_ip.GetItemString( 1, "l_saup");  
sfyymm = dw_ip.GetItemString( 1, "l_ym");  
spbtag  = dw_ip.GetItemString( 1, "l_gubn");   
sbigo  = dw_ip.GetItemString( 1, "bigo");   
ls_Pbtag = dw_ip.Describe("evaluate('lookupdisplay(l_gubn)',1)")
if IsNull(ls_Pbtag)  or ls_Pbtag = '' then ls_Pbtag = '급여(상여)'

if isNull(sSaupcd) or sSaupcd = '' then sSaupcd = "%"
if isNull(spbtag) or spbtag = '' then spbtag = "%"

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '자료를 조회 중입니다....다른화면으로 이동하지 마시고 기다려 주십시오!'

iCnt = 0

If Not DirectoryExists ( 'c:\erpman\pay\pdf\' ) Then			/*급여파일(PDF) 저장 폴더가 없으면 새로 생성*/
	CreateDirectory ( 'c:\erpman\pay\pdf\' )
End If

for i = 1 to dw_emp.RowCount()		
	Setnull(sEmpno)
	Setnull(sEmpno)

	if dw_emp.GetItemString(i,"calccheck") = 'Y' then			
		sEmpno = dw_emp.GetItemString(i, "empno")
		sEmpName = dw_emp.GetItemString(i, "empname")	
		
		iCnt ++
	end if 
		
	if sEmpno = '' or isNull(sEmpno) then continue
	dw_list.Retrieve(sSaupcd,sfyymm,spbtag,sEmpno,sbigo) 
	wf_settext()
	wf_settext2()
	wf_psettext()
	wf_psettext2()
	dw_print.Modify("t_bigo.text = '" + sbigo + "' ")
    dw_list.Modify("t_bigo.text = '" + sbigo + "' ")
	 
	IF Is_OsGubun = '1' THEN
		 dw_list.Object.DataWindow.Export.PDF.Method = Distill! 
		 dw_list.Object.DataWindow.Export.PDF.Distill.CustomPostScript = "Yes"
		 dw_list.Object.DataWindow.Printer = "Microsoft Print to PDF" //추가된 프린터명
		 
		IF dw_list.RowCount() > 0 THEN
			ls_filename = 'c:\erpman\pay\pdf'
			ls_filename =ls_filename  +'\' +  left(  sfyymm, 4 ) +'년'+Right(  sfyymm, 2 ) + '월 '+ ls_Pbtag + '명세서-' +  sEmpno+'' + '('+ ''+ sEmpName + ''+')' + '.pdf'	
			dw_list.object.DataWindow.Print.Filename = ls_filename
			dw_list.Print()
		END IF 
	ELSE
		dw_list.Object.DataWindow.Export.PDF.Method = Distill! 
		dw_list.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes" 
		dw_list.Object.DataWindow.Printer ="Ghostscript PDF"  //추가된 프린터명	  
		
		IF dw_list.RowCount() > 0 THEN
			ls_filename = 'c:\erpman\pay\pdf'
			ls_filename =ls_filename  +'\' +  left(  sfyymm, 4 ) +'년'+Right(  sfyymm, 2 ) + '월 '+ ls_Pbtag + '명세서-' +  sEmpno+'' + '('+ ''+ sEmpName + ''+')' + '.pdf'	 		
			dw_list.Saveas(ls_filename, PDF!, True) 
		END IF		
	END IF
next

IF iCnt = 0 THEN
	MessageBox('확인','조회할 사원을 선택하십시오')
	return
end if
w_mdi_frame.sle_msg.text = '자료 생성이 완료 되었습니다!'

MessageBox('확인','PDF파일로 저장 완료 하였습니다')
end event

type cb_cnf from commandbutton within wp_pip3160
boolean visible = false
integer x = 4128
integer y = 180
integer width = 402
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "메일환경설정"
end type

event clicked;OpenWithParm(wp_pip3160_mailconf,'')
end event

type p_send from uo_picture within wp_pip3160
integer x = 3680
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\Erpman\image\메일전송_up.gif"
end type

event clicked;call super::clicked;IF Messagebox ("확인", "메일을 전송 하시겠습니까?",Question!,YesNo!) = 2 THEN Return
 	
String  sYm, ls_empno, ls_empname, ls_mailad, sCompany, sSaupcd, sfyymm, sPbtag, sBigo, ls_pbtag
integer iRtnValue
long    i, iCnt
decimal ld_pct_ind

IF dw_emp.RowCount() < 0 THEN
    MessageBox('확인', '메일을 보낼 대상자를 먼저 조회하세요!')
	Return 
END IF 

if dw_ip.Accepttext() = -1 then return
if dw_emp.Accepttext() = -1 then return

sCompany = gs_company
sSaupcd =  dw_ip.GetItemString( 1, "l_saup");  
sfyymm = dw_ip.GetItemString( 1, "l_ym");  
spbtag  = dw_ip.GetItemString( 1, "l_gubn");   
sbigo  = dw_ip.GetItemString( 1, "bigo");   
ls_Pbtag = dw_ip.Describe("evaluate('lookupdisplay(l_gubn)',1)")
if IsNull(ls_Pbtag)  or ls_Pbtag = '' then ls_Pbtag = '급여(상여)'

if isNull(sSaupcd) or sSaupcd = '' then sSaupcd = "%"
if isNull(spbtag) or spbtag = '' then spbtag = "%"

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '첨부자료를 생성하는 중입니다!'		
//첨부파일 생성
cb_pdf.TriggerEvent(Clicked!)
		
//SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '메일 발송 중입니다!'
st_100.Visible = true
st_rcvpct.Visible = true
	
	
//========================== Mail관련...
String ls_ym ,lsv_filename,lsv_ExeName,ls_FileName
mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailRecipient mRecip
mailFileDescription mattach
Boolean ib_attach = False
datawindow ldw_save
//==========================
mSes = create mailSession              // MailSession 오브젝트 생성 .
mRet = mSes.mailLogon(mailNewSession!) // 메일 Session 로그 -온 .

IF mRet <> mailReturnSuccess! THEN
   MessageBox("메일 Session", '로그 -온 실패 ')
   Return
END IF

iCnt = 0
for i = 1 to dw_emp.rowcount() 		
	if dw_emp.GetItemString(i,"calccheck") = 'Y' then			
		ls_empno    = dw_emp.GetITemString(i,"empno")
		ls_empname  = dw_emp.GetITemString(i,"empname")
		ls_mailad   = dw_emp.GetITemString(i,"email")
		//ls_mailad = 'limgy@willdo.co.kr' 	
		
		if ls_mailad = '' or isnull(ls_mailad) then
			messagebox(ls_empno,ls_empname + '의 메일주소가 등록되지 않았습니다! 확인요망')
		else
		
			//***** 메일 보내기 *****
			mMsg.Recipient[1].name = ls_mailad 	  // 메일 받는사람의 주소	
			mMsg.Recipient[1].address = ls_mailad
			ls_ym      = dw_ip.GetITemString(1,"l_ym")
			mMsg.Subject = left(ls_ym, 4 ) + '년' +Right(ls_ym, 2 ) + '월 ' + ls_Pbtag + '명세서 입니다.'
			//mMsg.Subject = dw_emp.GetITemString(i,"email") + '/' + left(ls_ym, 4 ) + '년' +Right(ls_ym, 2 ) + '월 ' + ls_Pbtag + '명세서 입니다.'
	 		mMsg.NoteText = '한달 동안 고생 많으셨습니다.'
			//***** 파일 첨부 *****			
			lsv_FileName =  left(ls_ym, 4 ) +'년'+Right(ls_ym, 2 ) + '월 '+ ls_Pbtag + '명세서-' +  ls_empno+'' + '('+ ''+ ls_empname + ''+')' 
			lsv_ExeName = '.pdf'
			
			long llv_pos
			//파일의 확장자를 검사한다.		
			llv_pos = pos(lsv_FileName , ".")
			
			if llv_pos = 0 then
				ls_filename ='c:\erpman\pay\pdf\' + lsv_FileName + lsv_ExeName			
			end if
			
			mattach.Filetype = mailattach! // 파일 첨부 하기위한 작업 .
			mattach.PathName = ls_filename
			mattach.FileName = ls_filename
			mattach.Position = len(mMsg.notetext) - 1 //첨부된 파일의 위치 지정
			mMsg.attachmentFile[1] = mattach		
	
			mRet = mSes.mailSend(mMsg) // 메일 보내기 .
	
			IF mRet <> mailReturnSuccess! THEN
				MessageBox('메일보내기 ', lsv_FileName + ' 메일보내기 ==> 실패 ')
			end If
	
		end if	
		
		iCnt++
	end if	
	ld_pct_ind = ( iCnt / dw_emp.GetITemNumber(1,"yescnt") ) * 100
	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
	st_rcvpct.visible = true	  		
next				

mSes.mailLogoff() // 메일 Session 끊기 .
DESTROY mSes

SetPointer(Arrow!)

w_mdi_frame.sle_msg.text = '메일 보내기를 완료 되었습니다!'
MessageBox('확인','메일 보내기를 완료하였습니다')

st_rcvpct.width = 0
st_rcvpct.visible = false	  		
st_100.visible = false	  		

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

type st_100 from statictext within wp_pip3160
integer x = 1614
integer y = 700
integer width = 2519
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = true
boolean focusrectangle = false
end type

type st_rcvpct from statictext within wp_pip3160
integer x = 1618
integer y = 700
integer width = 101
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 8388608
boolean focusrectangle = false
end type

type rr_6 from roundrectangle within wp_pip3160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 119
integer y = 468
integer width = 1102
integer height = 1612
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within wp_pip3160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1239
integer y = 468
integer width = 3250
integer height = 1620
integer cornerheight = 40
integer cornerwidth = 55
end type

