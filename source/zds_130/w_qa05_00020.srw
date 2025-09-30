$PBExportHeader$w_qa05_00020.srw
$PBExportComments$교정 실적 등록
forward
global type w_qa05_00020 from w_inherite
end type
type st_2 from statictext within w_qa05_00020
end type
type p_2 from picture within w_qa05_00020
end type
type dw_1 from u_key_enter within w_qa05_00020
end type
type dw_2 from datawindow within w_qa05_00020
end type
type cbx_1 from checkbox within w_qa05_00020
end type
type dw_list from datawindow within w_qa05_00020
end type
type dw_insp from datawindow within w_qa05_00020
end type
type pb_1 from u_pb_cal within w_qa05_00020
end type
type cb_1 from commandbutton within w_qa05_00020
end type
type cb_2 from commandbutton within w_qa05_00020
end type
type rr_2 from roundrectangle within w_qa05_00020
end type
type rr_1 from roundrectangle within w_qa05_00020
end type
end forward

global type w_qa05_00020 from w_inherite
integer width = 4672
integer height = 2412
string title = "검교정 결과 등록"
st_2 st_2
p_2 p_2
dw_1 dw_1
dw_2 dw_2
cbx_1 cbx_1
dw_list dw_list
dw_insp dw_insp
pb_1 pb_1
cb_1 cb_1
cb_2 cb_2
rr_2 rr_2
rr_1 rr_1
end type
global w_qa05_00020 w_qa05_00020

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" 
end prototypes

type variables
blob	iblobBMP
end variables

forward prototypes
public function integer wf_save_image ()
public function integer wf_required_chk ()
public function integer wf_load_image ()
public function string wf_scale_chk (string arg_code, integer arg_seq, string arg_value)
public subroutine wf_initial ()
public function integer wf_test ()
end prototypes

public function integer wf_save_image ();String	sMchNo

If Not p_2.Visible Then Return 0

sMchNo = dw_insert.getitemstring(1,"mchno")

sqlca.autocommit = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////
// 계측기 이미지 저장
Updateblob lw_mchmes_image
   Set image = :iblobBMP
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;

If SQLCA.SQLCode = -1 Then
	MessageBox("Save Image SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

Commit;

sqlca.autocommit = FALSE

Return 1
end function

public function integer wf_required_chk ();string	sigbn, sidat, sikwan, srecdat, sok

sigbn = dw_insert.getitemstring(1,'sigbn')
if isnull(sigbn) or sigbn = "" then
	f_message_chk(30,'[교정구분]')
	dw_insert.setcolumn('sigbn')
	dw_insert.setfocus()
	return -1
end if

sidat = dw_insert.getitemstring(1,'sidat')
if f_datechk(sidat) = -1 then
	f_message_chk(30,'[실시일자]')
	dw_insert.setcolumn('sidat')
	dw_insert.setfocus()
	return -1
end if

sikwan = dw_insert.getitemstring(1,'sikwan')
if isnull(sikwan) or sikwan = "" then
	f_message_chk(30,'[검사장소]')
	dw_insert.setcolumn('sikwan')
	dw_insert.setfocus()
	return -1
end if

srecdat = dw_insert.getitemstring(1,'recdat')
if f_datechk(srecdat) = -1 then
	f_message_chk(30,'[등록일자]')
	dw_insert.setcolumn('recdat')
	dw_insert.setfocus()
	return -1
end if

sok = dw_insert.getitemstring(1,'status')
if isnull(sok) or sok = "" then
	f_message_chk(30,'[합불판정]')
	dw_insert.setcolumn('status')
	dw_insert.setfocus()
	return -1
end if

return 1
end function

public function integer wf_load_image ();string	sMchNo
int 		iCnt
blob		lblobBMP

p_2.Visible = False

sMchNo = dw_1.getitemstring(1,"mchno")
///////////////////////////////////////////////////////////////////////////////////////////////
Select count(*) Into :iCnt From lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo   ;

If iCnt = 0 Then Return -1

Selectblob image into :lblobBMP from lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '2' And mchno = :sMchNo ;

If sqlca.sqlcode = -1 Then
	MessageBox("SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

// Instance 변수에 보관
iblobBMP = lblobBMP
If p_2.SetPicture(iblobBMP) = 1 Then
	p_2.Visible = True
End if

Return 1
end function

public function string wf_scale_chk (string arg_code, integer arg_seq, string arg_value);string	scale
decimal	dvalue, dfrom, dto

// 숫자 값이 아니면 return
if not isnumber(arg_value) then return ''
dvalue = dec(arg_value)

// 계측기 점검기준에 해당 점검기준이 정의되지 않았으면 return
select scale into :scale from mchmst_insp
 where sabu = :gs_sabu and mchno = :arg_code and seq = :arg_seq ;
if sqlca.sqlcode <> 0 then return ''


// 계측기 점검기준에 측정범위가 지정되지 않았으면 return
if IsNull(scale) or scale = "" then
	return ''
else
	// 계측기 점검기준에 측정범위 지정 오류가 있으면 return
	if pos(scale,' ') > 0 or &
		pos(scale,'_') = 0 or &
		pos(scale,'_',pos(scale,'_')+1) > 0 or &
		not isnumber(left(scale,pos(scale,'_') -1)) or &
		not isnumber(mid(scale,pos(scale,'_')+1)) then
		return ''
//		messagebox('확인','측정범위 지정 오류입니다!!!~n~n ex) 0_15 , -30_30 , -30_-10')
	else
		// 지정한 값이 계측기 점검기준의 측정범위내에 들면 합격(Y) 아니면 불합격(N)
		dfrom = dec(left(scale,pos(scale,'_') -1))
		dto	= dec(mid(scale,pos(scale,'_')+1))
		if dvalue >= dfrom and dvalue <= dto then
			return 'Y'
		else
			return 'N'
		end if
	end if
end if

return ''
end function

public subroutine wf_initial ();dw_2.reset()
dw_1.reset()
dw_list.reset()
dw_1.insertrow(0)

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)

//dw_insert.setitem(1,'lasdat',f_today())
dw_insert.setredraw(true)

p_2.visible = false
p_2.picturename = ''
//p_2.visible = true

ib_any_typing = false
end subroutine

public function integer wf_test ();blob		lblobBMP

p_2.Visible = False

SELECTBLOB IMG INTO :lblobBMP FROM S3016QA1_IMG_KO524 WHERE ITEM_CD = '9324852822k' AND ROWNUM = 1;

If sqlca.sqlcode = -1 Then
	MessageBox("SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

// Instance 변수에 보관
iblobBMP = lblobBMP
If p_2.SetPicture(iblobBMP) = 1 Then
	p_2.Visible = True
End if

Return 1
end function

on w_qa05_00020.create
int iCurrent
call super::create
this.st_2=create st_2
this.p_2=create p_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cbx_1=create cbx_1
this.dw_list=create dw_list
this.dw_insp=create dw_insp
this.pb_1=create pb_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.dw_insp
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_1
end on

on w_qa05_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.p_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cbx_1)
destroy(this.dw_list)
destroy(this.dw_insp)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_2.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_insp.settransobject(sqlca)
dw_insert.settransobject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_qa05_00020
integer x = 2171
integer y = 204
integer width = 2446
integer height = 2012
integer taborder = 20
string dataobject = "d_qa05_00020_a"
boolean border = false
boolean livescroll = false
end type

event dw_insert::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.getcolumnname() = 'linecode' then
	open(w_workplace_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(GetRow(),'linecode',gs_code)
	
	this.trigger Event itemchanged(GetRow(),dwo,gs_code)
//	this.triggerevent(itemchanged!)
elseif this.getcolumnname() = 'mchcode' then
	open(w_mchmst_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(GetRow(),'mchcode',gs_code)
	this.trigger Event itemchanged(GetRow(),dwo,gs_code)	
//	this.triggerevent(itemchanged!)
//elseif this.getcolumnname() = 'mngman' then
//	open(w_sawon_popup)
//	if isnull(gs_code) or gs_code = '' then return
//	
//	this.setitem(GetRow(),'mngman',gs_code)
//	this.trigger Event itemchanged(GetRow(),dwo,gs_code)	
////	this.triggerevent(itemchanged!)
elseif this.GetColumnName() =  'sikwan' Then //검사장소--거래처코드 혹은 부서코드로 대
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		this.setitem(1,'sikwan',gs_code)
	
		this.Trigger Event itemchanged(row,dwo,gs_code)
end if
end event

event dw_insert::itemchanged;call super::itemchanged;string	scode, sname, snull

setnull(snull)

if this.getcolumnname() = 'linecode' then
	scode = this.gettext()
	
	select wcdsc into :sname from wrkctr
	 where wkctr = :scode ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,'linename',sname)
	else
		this.setitem(1,'linecode',snull)
		this.setitem(1,'linename',snull)
		return 1
	end if
	
elseif this.getcolumnname() = 'mchcode' then
	scode = this.gettext()
	
	select mchnam into :sname from mchmst
	 where mchno = :scode ;
	 
	if sqlca.sqlcode = 0 then
		this.setitem(1,'mchname',sname)
	else
		this.setitem(1,'mchcode',snull)
		this.setitem(1,'mchname',snull)
		return 1
	end if
ElseIf this.getcolumnname() = 'sikwan' Then
	scode = Trim(this.gettext())
	
	If IsNull(scode) Or scode = '' Then
		this.object.sikwan_nm[row] = snull
		ReTurn
	End If
	
	SELECT	CVNAS
	INTO		:sname
	FROM		VNDMST
	WHERE		CVCOD = :scode;
	
	If sqlca.sqlcode <> 0 Then
		this.object.sikwan[row] = snull
		this.object.sikwan_nm[row] = snull
		Messagebox("확인","등록된 거래처 혹은 부서가 아닙니다.",Information!)
		Return 1
	End If
	
	this.object.sikwan_nm[row] = sname	
//elseif this.getcolumnname() = 'mngman' then
//	scode = this.gettext()
//	
//	if isnull(scode) or scode = '' then 
//		this.setitem(1,'empname',snull)
//		return
//	end if
//	
//	string	sdept, sdeptname
//	
//	select empname, deptcode, fun_get_dptno(deptcode)
//	  into :sname, :sdept, :sdeptname 
//	  from p1_master
//	 where empno = :scode ;
//	if sqlca.sqlcode = 0 then
//		this.setitem(1,'empname',sname)
//		this.setitem(1,'lastoutdept',sdept)
//		this.setitem(1,'deptname',sdeptname)
//	else
//		messagebox('확인','등록되지 않은 사원코드입니다.')
//		this.setitem(1,'mngman',snull)
//		this.setitem(1,'empname',snull)
//		this.setitem(1,'lastoutdept',snull)
//		this.setitem(1,'deptname',snull)
//		return 1
//	end if
end if
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::buttonclicked;call super::buttonclicked;String ls_s_path ,ls_s_file , ls_path, ls_file ,ls_inspt_dt
Long   ll_v, ll_ques
AcceptText()
Choose Case dwo.name
	Case 'b_down'
		ls_s_path = Trim(Object.meskwa_file_path[row])
		ls_s_file = Trim(Object.meskwa_file_name[row])
		

		If ls_s_path = '' Or isNull(ls_s_path) Then Return
		
		SetPointer(Hourglass!)
		
	   If FileExists(ls_s_path) = False Then
			MessageBox('확인','파일서버에 해당 파일이 존재하지 않습니다.')
			Return
		End If

		ShellExecuteA(0, "open", ls_s_path , "", "", 1) // 파일 자동 실행 

	Case 'b_up'
		
		// 환경설정 - 공통관리 - SCM 연동관리
		IF dw_insert.Object.meskwa_file_yn[row] = 'Y' THEN
			ll_ques = MessageBox('확인','기존 데이터를 삭제하고 등록하시겠습니까...?',Question!,YesNo!)
			IF ll_ques = 1 THEN
				select dataname into :ls_s_path from syscnfg
				 where sysgu = 'C' and serial = 12 and lineno = '2' ;
				
				ls_file = dw_insert.GetItemString(row,'meskwa_file_name')

				FileDelete(ls_s_path + ls_file)
				dw_insert.Object.meskwa_file_yn[row]  = ''
				dw_insert.Object.meskwa_file_path[row]  = ''
				dw_insert.Object.meskwa_file_name[row]  = ''
				
				If dw_insert.Update() <> 1 Then
					ROLLBACK;
					f_message_chk(32,'[자료삭제 실패]') 
					w_mdi_frame.sle_msg.text = "저장삭제를 실패 하였습니다!"
					Return
				Else
					Commit ;
				End If
				
				ll_v = GetFileOpenName("Upload File 선택",ls_path , ls_file ,"XLS","EXCEL Files (*.XLS),*.XLS," &
				+ "PDF Files (*.PDF),*.PDF," + "JPG Files (*.JPG),*.JPG," + "TIF Files (*.TIF),*.TIF," &
				+ "PPT Files (*.PPT),*.PPT," + "ALL Files (*.*),*.*,")
				
				If ll_v = 1 And FileExists(ls_path) Then
					ls_s_path = ls_s_path + ls_file
					if FileExists(ls_s_path) Then
						messagebox('확인','동일한 파일명이 존재합니다.~n파일명을 바꾸세요.')
						return
					end if
		
					If CopyFileA(ls_path,ls_s_path,true) = False Then
						MessageBox('확인','File UpLoad Failed')
						Return
					End If
		
		//			dw_insert.Object.local_path[row] = ls_path
					dw_insert.Object.meskwa_file_path[row]  = ls_s_path
					dw_insert.Object.meskwa_file_name[row]  = ls_file
					
					dw_insert.Object.meskwa_file_yn[row] = 'Y'
				Else
					return
		//			dw_insert.Object.meskwa_file_yn[row] = 'N'
				End If
				
				dw_insert.accepttext( )
				
				If dw_insert.Update() <> 1 Then
					ROLLBACK;
					f_message_chk(32,'[자료저장 실패]') 
					w_mdi_frame.sle_msg.text = "저장작업을 실패 하였습니다!"
					Return
				Else
					Commit ;
					w_mdi_frame.sle_msg.text = "저장작업을 완료 하였습니다!"
					p_inq.TriggerEvent(Clicked!)
				End If
				
				ib_any_typing = False //입력필드 변경여부 No
				
				SetPointer(Arrow!)		
				
			ELSEIF ll_ques = 2 THEN
				RETURN	
			END IF
		
		ELSE
			
		
			select dataname into :ls_s_path from syscnfg
			 where sysgu = 'C' and serial = 12 and lineno = '2' ;
			
			ll_v = GetFileOpenName("Upload File 선택",ls_path , ls_file ,"XLS","EXCEL Files (*.XLS),*.XLS," &
				+ "PDF Files (*.PDF),*.PDF," + "JPG Files (*.JPG),*.JPG," + "TIF Files (*.TIF),*.TIF," &
				+ "PPT Files (*.PPT),*.PPT," + "ALL Files (*.*),*.*,")
			
			If ll_v = 1 And FileExists(ls_path) Then
				ls_s_path = ls_s_path + ls_file
				if FileExists(ls_s_path) Then
					messagebox('확인','동일한 파일명이 존재합니다.~n파일명을 바꾸세요.')
					return
				end if
	
				If CopyFileA(ls_path,ls_s_path,true) = False Then
					MessageBox('확인','File UpLoad Failed')
					Return
				End If
	
	//			dw_insert.Object.local_path[row] = ls_path
				dw_insert.Object.meskwa_file_path[row]  = ls_s_path
				dw_insert.Object.meskwa_file_name[row]  = ls_file
				
				dw_insert.Object.meskwa_file_yn[row] = 'Y'
			Else
				return
	//			dw_insert.Object.meskwa_file_yn[row] = 'N'
			End If
			
			dw_insert.accepttext( )
			
			If dw_insert.Update() <> 1 Then
				ROLLBACK;
				f_message_chk(32,'[자료저장 실패]') 
				w_mdi_frame.sle_msg.text = "저장작업을 실패 하였습니다!"
				Return
			Else
				Commit ;
				w_mdi_frame.sle_msg.text = "저장작업을 완료 하였습니다!"
				p_inq.TriggerEvent(Clicked!)
			End If
			
			ib_any_typing = False //입력필드 변경여부 No
			
			SetPointer(Arrow!)		
		END IF	
	Case 'b_del'  //삭제
		
		ll_ques = MessageBox('확인','데이터를 삭제하시겠습니까...?',Question!,YesNo!)
		IF ll_ques = 1 THEN
			select dataname into :ls_s_path from syscnfg
			where sysgu = 'C' and serial = 12 and lineno = '2' ;
						
			ls_file = dw_insert.GetItemString(row,'meskwa_file_name')
			FileDelete(ls_s_path + ls_file)
			
			dw_insert.Object.meskwa_file_yn[row]  = ''
			dw_insert.Object.meskwa_file_path[row]  = ''
			dw_insert.Object.meskwa_file_name[row]  = ''
	
			If dw_insert.Update() <> 1 Then
				ROLLBACK;
				f_message_chk(32,'[자료삭제 실패]') 
				w_mdi_frame.sle_msg.text = "저장삭제를 실패 하였습니다!"
				Return
			Else
				Commit ;
				w_mdi_frame.sle_msg.text = "저장삭제를 완료 하였습니다!"
				p_inq.TriggerEvent(Clicked!)
			End If
		ELSEIF ll_ques = 2 THEN
			RETURN
		END IF
End Choose


end event

type p_delrow from w_inherite`p_delrow within w_qa05_00020
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa05_00020
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa05_00020
boolean visible = false
integer x = 4434
integer y = 1248
integer width = 160
integer height = 132
string picturename = "C:\erpman\image\등록_up.gif"
end type

event p_search::ue_lbuttondown;//PictureName = "C:\erpman\image\button_dn.gif"
end event

event p_search::ue_lbuttonup;//PictureName = "C:\erpman\image\button_up.gif"
end event

event p_search::clicked;call super::clicked;long		lseq, lrow
string	sabu, smchno, sdate, sok

if dw_insert.rowcount() < 1 then return

if dw_list.rowcount() > 0 then
	if messagebox('확인','기존 정보를 삭제하고 새로 작성합니다',question!,yesno!,2) = 2 then return
end if

sabu 	= dw_insert.getitemstring(1,'sabu')
smchno= dw_insert.getitemstring(1,'mchno')
lseq	= dw_insert.getitemnumber(1,'seq')

if dw_insp.retrieve(sabu,smchno,lseq) < 1 then
//	messagebox('확인','등록된 점검기준이 없습니다')
	return
end if

dw_list.setredraw(false)
DO WHILE dw_list.rowcount() > 0
	dw_list.deleterow(0)
LOOP

FOR lrow = 1 TO dw_insp.rowcount()
	dw_list.insertrow(0)
	dw_list.setitem(lrow,'sabu',sabu)
	dw_list.setitem(lrow,'mchno',smchno)
	dw_list.setitem(lrow,'seq',lseq)
	dw_list.setitem(lrow,'seq2',dw_insp.getitemnumber(lrow,'seq'))
	dw_list.setitem(lrow,'insplist',dw_insp.getitemstring(lrow,'insplist'))
	dw_list.setitem(lrow,'inspgijun',dw_insp.getitemstring(lrow,'inspgijun'))
NEXT
dw_list.setredraw(true)

dw_list.setrow(1)
dw_list.setcolumn('inspvalue')
dw_list.scrolltorow(1)
dw_list.setfocus()
end event

type p_ins from w_inherite`p_ins within w_qa05_00020
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa05_00020
integer x = 4375
end type

type p_can from w_inherite`p_can within w_qa05_00020
integer x = 4201
end type

event p_can::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_qa05_00020
boolean visible = false
integer x = 4713
integer y = 340
end type

type p_inq from w_inherite`p_inq within w_qa05_00020
integer x = 3680
end type

event p_inq::clicked;string	smchno

if dw_1.accepttext() = -1 then return

smchno = trim(dw_1.getitemstring(1,'mchno'))
If IsNull(smchno) Or smchno = '' Then smchno = ''
	
/*
if isnull(smchno) or smchno = "" then
	f_message_chk(30, '[관리번호]')
	dw_1.setcolumn('mchno')
	dw_1.setfocus()
	return
end if
*/
setpointer(hourglass!)
dw_2.setredraw(false)
if dw_2.retrieve(gs_sabu,smchno + '%') < 1 then
	dw_2.setredraw(true)
	f_message_chk(50, '[검교정 계획]')
	dw_1.setfocus()
	return
end if

dw_2.setredraw(true)


////////////////////////////////////////////////////////////////
//long		lseq
//string	sdate, sok
//
//smchno= dw_2.getitemstring(1,'mchno')
//lseq	= dw_2.getitemnumber(1,'seq')
//
//if dw_insert.retrieve(gs_sabu,smchno,lseq) > 0 then
//	sdate = trim(dw_insert.getitemstring(1,'recdat'))
//	if isnull(sdate) or sdate = '' then
//		dw_insert.setitem(1,'recdat',f_today())
//	end if
//	
//	sok = trim(dw_insert.getitemstring(1,'status'))
//	if isnull(sok) or sok = '' then
//		dw_insert.setitem(1,'status','Y')
//	end if
//	
//	dw_list.retrieve(gs_sabu,smchno,lseq)
//else
//	dw_list.reset()
//end if

//if cbx_1.checked then wf_load_image()
ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_qa05_00020
integer x = 4027
end type

event p_del::clicked;string	smchno, ls_s_path, ls_file
Long 		ll_row, ll_cnt

if dw_2.find("chk='Y'",1,dw_2.rowcount()) = 0 then 
	messagebox("확인", "먼저 자료를 선택하십시오!!!")
	return
end if

if MessageBox('확인','선택된 자료를 삭제하시겠습니까...?',Question!,YesNo!,2) =2 then return

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)
dw_insert.setredraw(true)

For ll_row = dw_2.rowcount() To 1 Step -1
	if dw_2.getitemstring(ll_row,'chk') = 'N' then continue
	ll_cnt++
	dw_2.deleterow(ll_row)
Next	

if dw_2.update() = 1 then
	commit ;
else
	rollback ;
	messagebox("삭제실패", "계측기 마스타 삭제 실패!!!")
	return
end if

ib_any_typing = false
//p_can.triggerevent(clicked!)
end event

type p_mod from w_inherite`p_mod within w_qa05_00020
integer x = 3854
end type

event p_mod::clicked;if dw_insert.rowcount() <> 1 then return
if dw_insert.getitemstring(1,'create_flag') = 'Y' then return
if dw_list.accepttext() = -1 then return
if dw_insert.accepttext() = -1 then return
if wf_required_chk() = -1 then return
if f_msg_update() = -1 then return

setpointer(hourglass!)


if dw_insert.update() <> 1 then
	rollback ;
	messagebox("저장실패", "검교정 결과 등록 실패!!!")
	return
end if

String ls_check
long	lrow
Integer i = 0

dw_list.sort()

FOR lrow = 1 TO dw_list.rowcount()
	dw_list.setitem(lrow,'seq2',dw_list.getitemnumber(lrow,'no'))
	ls_check = dw_list.GetItemString(lrow,'inspokyn')
	if ls_check = 'N' then
 		i ++
	end if
NEXT

if i > 0 then
	dw_insert.SetItem(1, 'status','X')
else
	dw_insert.SetItem(1, 'status','Y')
end if

if dw_insert.update() <> 1 then
	rollback ;
	messagebox("저장실패", "데이터를 확인하세요!!!")
	return
end if

if dw_list.update() <> 1 then
	rollback ;
	messagebox("저장실패", "검사 성적서 등록 실패!!!")
	return
end if

commit ;


////////////////////////////////////////////////////////////////////
// 최종교정일 갱신
string	smchno, sidat, status, slasdat ,syongdo , smngman
string	slinecode ,smchcode, slastdt, slastdept
Decimal{2}	ldc_bulrate

smchno    = dw_insert.getitemstring(1,'mchno')
sidat     = dw_insert.getitemstring(1,'sidat')
status    = dw_insert.getitemstring(1,'status')
syongdo   = dw_insert.getitemstring(1,'yongdo')
slinecode = dw_insert.getitemstring(1,'linecode')
smchcode  = dw_insert.getitemstring(1,'mchcode')
slastdept = dw_insert.getitemstring(1,'lastoutdept')
ldc_bulrate = dw_insert.getitemDecimal(1,'bulrat')

If IsNull(ldc_bulrate) Then ldc_bulrate = 0

select lasdat into :slasdat from mesmst
 where sabu = :gs_sabu and mchno = :smchno ;

if isnull(slasdat) or slasdat = '' or slasdat < sidat then
	update mesmst set lasdat = :sidat, 
							laststs = :status ,
							yongdo  = :syongdo ,
/*							linecode = :slinecode,*/
							mchcode = :smchcode,
							lastoutdept = :slastdept,
/*							bulrate = :ldc_bulrate*/
	where sabu = :gs_sabu and mchno = :smchno ;
// 왜 기존에 커밋만 되어 있었나. 자료갱신해도/안해도 상관없음?	
	If sqlca.sqlcode <> 0 Then
		rollback;
	Else
		commit ;
	End If
end if
////////////////////////////////////////////////////////////////////

ib_any_typing = false
p_inq.postevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qa05_00020
end type

type cb_mod from w_inherite`cb_mod within w_qa05_00020
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa05_00020
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa05_00020
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa05_00020
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa05_00020
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa05_00020
end type

type cb_can from w_inherite`cb_can within w_qa05_00020
end type

type cb_search from w_inherite`cb_search within w_qa05_00020
end type







type gb_button1 from w_inherite`gb_button1 within w_qa05_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_qa05_00020
end type

type st_2 from statictext within w_qa05_00020
boolean visible = false
integer x = 2222
integer y = 1300
integer width = 919
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 28144969
long backcolor = 32106727
string text = "계측기기 점검 판정 등록"
boolean focusrectangle = false
end type

type p_2 from picture within w_qa05_00020
boolean visible = false
integer x = 3392
integer y = 292
integer width = 1641
integer height = 1068
boolean bringtotop = true
boolean originalsize = true
boolean border = true
boolean focusrectangle = false
end type

type dw_1 from u_key_enter within w_qa05_00020
event ue_key pbm_dwnkey
integer x = 27
integer y = 20
integer width = 3182
integer height = 160
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa05_00020_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;string	scode, sname, spec, sjungdo, snull

setnull(snull)
if this.getcolumnname() = 'mchno' then
	scode = this.gettext()

	dw_2.reset()
	dw_insert.reset()
	dw_insert.insertrow(0)

	if isnull(scode) or scode = '' then
		this.setitem(1,'mchno',snull)
		this.setitem(1,'mchnm',snull)
		this.SetItem(1,'spec',snull)
		this.SetItem(1,'jungdo',snull)
		return 1
	end if
	
	select mchnam, spec, jungdo 
	  into :sname, :spec, :sjungdo
	  from mesmst
	 where mchno = :scode ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'mchnm',sname)
		this.setitem(1,'spec',spec)
		this.setitem(1,'jungdo',sjungdo)
	else
		this.setitem(1,'mchno',snull)
		this.setitem(1,'mchnm',snull)
		this.setitem(1,'spec',snull)
		this.setitem(1,'jungdo',snull)
		return 1
	end if
	
	p_inq.postevent(clicked!)
end if
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.getcolumnname() = 'mchno' then
	open(w_st22_00020_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(GetRow(),'mchno',gs_code)
//	this.triggerevent(itemchanged!)
	this.Trigger Event itemchanged(GetRow(),dwo,gs_code)
end if
end event

type dw_2 from datawindow within w_qa05_00020
integer x = 46
integer y = 220
integer width = 2098
integer height = 1960
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa05_00020_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
	return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF

long		lseq
string	sabu, smchno, sdate, sok

sabu 	= this.getitemstring(row,'sabu')
smchno= this.getitemstring(row,'mchno')
lseq	= this.getitemnumber(row,'seq')

if dw_insert.retrieve(sabu,smchno,lseq) > 0 then
	sdate = trim(dw_insert.getitemstring(1,'recdat'))
	if isnull(sdate) or sdate = '' then
		dw_insert.setitem(1,'recdat',f_today())
	end if
	
	sok = trim(dw_insert.getitemstring(1,'status'))
	if isnull(sok) or sok = '' then
		dw_insert.setitem(1,'status','Y')
	end if
	
	if dw_list.retrieve(sabu,smchno,lseq) < 1 then
		p_search.triggerevent(clicked!)
	end if
end if


end event

event buttonclicked;String ls_s_path ,ls_s_file , ls_path, ls_file

AcceptText()

IF dwo.name = 'b_down' THEN

		ls_s_path = Trim(Object.file_path[row])
		ls_s_file = Trim(Object.file_name[row])

		If ls_s_path = '' Or isNull(ls_s_path) Then Return
		
		SetPointer(Hourglass!)
		
	   If FileExists(ls_s_path) = False Then
			MessageBox('확인','파일서버에 해당 파일이 존재하지 않습니다.')
			Return
		End If

		ShellExecuteA(0, "open", ls_s_path , "", "", 1) // 파일 자동 실행 
		
END IF
end event

type cbx_1 from checkbox within w_qa05_00020
boolean visible = false
integer x = 4805
integer y = 980
integer width = 242
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "보기"
end type

type dw_list from datawindow within w_qa05_00020
boolean visible = false
integer x = 2217
integer y = 1408
integer width = 2359
integer height = 760
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa05_00020_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;string	smchno, svalue, snull, scheck
integer	iseq

setnull(snull)
if this.getcolumnname() = 'inspvalue' then
	svalue = trim(gettext())
	if isnull(svalue) or svalue = '' then
		this.setitem(row,'inspokyn',snull)
		return
	end if
	
	smchno = this.getitemstring(row,'mchno')
	iseq 	 = this.getitemnumber(row,'seq2')
	this.setitem(row,'inspokyn',wf_scale_chk(smchno,iseq,svalue))
end if


end event

type dw_insp from datawindow within w_qa05_00020
boolean visible = false
integer x = 1509
integer y = 1268
integer width = 160
integer height = 124
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa05_00020_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_qa05_00020
integer x = 2958
integer y = 620
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('sidat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'sidat', gs_code)

end event

type cb_1 from commandbutton within w_qa05_00020
boolean visible = false
integer x = 3227
integer y = 32
integer width = 320
integer height = 132
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄적용"
end type

event clicked;dw_2.AcceptText()
dw_insert.AcceptText()

Long   row
Long   ll_cnt

row = dw_insert.GetRow()
If row < 1 Then Return

ll_cnt = dw_2.RowCount()
If ll_cnt < 1 Then Return

If MessageBox('일괄적용', '선택한 항목을 일괄적용 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

Long   i
Long   ii
Long   ll_seq
Long   ll_copy
Long   ll_rate

String ls_chk
String ls_sabu
String ls_mch
String ls_get[]
String ls_copy[]
/*20060127 불확도를 문자열로 대치됨 bulrate -> temp로 변경*/
String	ls_temp

Decimal ld_amt
Decimal ld_rat

ii = 0
For i = 1 To ll_cnt
	ls_chk = dw_2.GetItemString(i, 'chk')
	
	If ls_chk = 'Y' Then
		If ii < 1 Then
			ls_sabu = dw_2.GetItemString(i, 'sabu' )
			ls_mch  = dw_2.GetItemString(i, 'mchno')
			ll_seq  = dw_2.GetItemNumber(i, 'seq'  )
			
			SELECT A.SIGBN    , A.SIDAT    , A.SIKWAN   , A.OKSIGN     , A.PLNYYMM  , 
			       A.CALNO    , A.STATUS   , A.SIAMT    , A.BULRAT     , A.TESTNO   ,
					 B.YONGDO   , B.LINECODE , B.MCHCODE  , B.LASTOUTDEPT,/* B.BULRATE,*/
					 A.TEMP
			  INTO :ls_get[1] , :ls_get[2] , :ls_get[3] , :ls_get[4]   , :ls_get[5] ,
			       :ls_get[6] , :ls_get[7] , :ld_amt    , :ld_rat      , :ls_get[10],
					 :ls_get[11], :ls_get[12], :ls_get[13], :ls_get[14]  , /*:ll_rate,*/
					 :ls_temp
			  FROM MESKWA A,
			       MESMST B
			 WHERE A.SABU  = B.SABU
			   AND A.MCHNO = B.MCHNO
			   AND A.SABU  = :ls_sabu
			   AND A.MCHNO = :ls_mch
				AND A.SEQ   = :ll_seq  ;
			
			ii++
		End If
		
		ls_copy[1] = dw_2.GetItemString(i, 'sabu' )
		ls_copy[2] = dw_2.GetItemString(i, 'mchno')
		ll_copy    = dw_2.GetItemNumber(i, 'seq'  )

		UPDATE MESKWA
		   SET SIGBN = :ls_get[1], SIDAT  = :ls_get[2], SIKWAN = :ls_get[3], OKSIGN = :ls_get[4], PLNYYMM = :ls_get[5] ,
			    CALNO = :ls_get[6], STATUS = :ls_get[7], SIAMT  = :ld_amt   , /*BULRAT = :ld_rat   ,*/ TESTNO  = :ls_get[10],
				 TEMP  = :ls_temp
		 WHERE SABU  = :ls_copy[1]
		   AND MCHNO = :ls_copy[2]
			AND SEQ   = :ll_copy   ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('일괄적용 실패', '일괄적용 작업 중 오류가 발생했습니다.~r~n전산실로 문의 하십시오.')
			Return
		End If
		
		UPDATE MESMST
		   SET LASDAT  = :ls_get[2] , LASTSTS     = :ls_get[7] , YONGDO  = :ls_get[11], LINECODE = :ls_get[12],
			    MCHCODE = :ls_get[13], LASTOUTDEPT = :ls_get[14]/*, BULRATE = :ll_rate*/
		 WHERE SABU  = :ls_copy[1]
		   AND MCHNO = :ls_copy[2] ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			MessageBox('일괄적용 실패', '일괄적용 작업 중 오류가 발생했습니다.~r~n전산실로 문의 하십시오.')
			Return
		End If		
	End If
Next

COMMIT USING SQLCA;

w_mdi_frame.sle_msg.text = "일괄적용완료!!"

MessageBox('일괄적용 성공', '일괄적용이 완료 되었습니다.')

end event

type cb_2 from commandbutton within w_qa05_00020
boolean visible = false
integer x = 3237
integer y = 84
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
end type

event clicked;wf_test()
end event

type rr_2 from roundrectangle within w_qa05_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 212
integer width = 2130
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_qa05_00020
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2176
integer y = 1392
integer width = 2423
integer height = 796
integer cornerheight = 40
integer cornerwidth = 55
end type

