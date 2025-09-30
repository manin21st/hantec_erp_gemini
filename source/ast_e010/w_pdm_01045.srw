$PBExportHeader$w_pdm_01045.srw
$PBExportComments$** 기타 거래처 등록
forward
global type w_pdm_01045 from window
end type
type p_exit from uo_picture within w_pdm_01045
end type
type p_can from uo_picture within w_pdm_01045
end type
type p_del from uo_picture within w_pdm_01045
end type
type p_mod from uo_picture within w_pdm_01045
end type
type p_inq from uo_picture within w_pdm_01045
end type
type cbx_1 from checkbox within w_pdm_01045
end type
type dw_list from u_d_popup_sort within w_pdm_01045
end type
type sle_msg from statictext within w_pdm_01045
end type
type dw_detail from datawindow within w_pdm_01045
end type
type rr_1 from roundrectangle within w_pdm_01045
end type
type rr_2 from roundrectangle within w_pdm_01045
end type
end forward

global type w_pdm_01045 from window
integer x = 169
integer y = 172
integer width = 3301
integer height = 2244
boolean titlebar = true
string title = "기타 거래처 등록"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_del p_del
p_mod p_mod
p_inq p_inq
cbx_1 cbx_1
dw_list dw_list
sle_msg sle_msg
dw_detail dw_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01045 w_pdm_01045

type variables
char  ic_Status   // 1 => 등록모드, 2=> 수정모드
string is_empno
end variables

forward prototypes
public function integer wf_cvcod_check (string scust)
public function integer wf_confirm_key ()
public function integer wf_maxcustcode ()
public function integer wf_mult_custom (string as_gubun)
public subroutine wf_query ()
public subroutine wf_new ()
end prototypes

public function integer wf_cvcod_check (string scust);Long icnt = 0

select count(*) into :icnt
  from vnddan
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[거래처제품단가]')
	return -1
end if

select count(*) into :icnt
  from vndsisang
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[거래처평가시상]')
	return -1
end if

select count(*) into :icnt
  from vnddc
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[거래처할인]')
	return -1
end if

select count(*) into :icnt
  from taxmisu
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[계산서발행월미수]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from estima
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[발주예정_구매의뢰]')
	return -1
end if

select count(*) into :icnt
  from pomast
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[발주일반정보]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[수주]')
	return -1
end if

select count(*) into :icnt
  from exppih
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[수출PI Head]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where cvcod = :scust;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[입출고이력]')
	return -1
end if

return 1
end function

public function integer wf_confirm_key ();/*=====================================================================
		1.	등록 mode : Key 검색
		2. Argument : None
		3.	Return Value
			- ( -1 ) : 등록된 코드 
			- (  1 ) : 신  규 코드
=====================================================================*/

string	sname1,sname2,is_key1

is_Key1 = dw_detail.GetItemString(1, "cvcod")
sname1  = dw_detail.GetItemString(1, "cvnas")
sname2  = dw_detail.GetItemString(1, "cvnas2")

IF cbx_1.Checked = FALSE AND (is_key1 = "" or isnull(is_key1)) THEN
	f_message_chk(30,'[거래처코드]')
	dw_detail.setcolumn("cvcod")
	dw_detail.SetFocus()
	Return -1
END IF

IF sname1 ="" OR IsNull(sname1) THEN
	f_message_chk(30,'[상호]')
	dw_detail.setcolumn("cvnas")
	dw_detail.SetFocus()
	Return -1
END IF

IF sname2 ="" OR IsNull(sname2) THEN
	f_message_chk(30,'[약식상호]')
	dw_detail.setcolumn("cvnas2")
	dw_detail.SetFocus()
	Return -1
END IF

Return 1

end function

public function integer wf_maxcustcode ();//////////////////////////////////////////////////////////////
//// 	1. 거래처구분 -> 거래처코드 자동채번 
////		2. 국내,해외,기타거래처만 자동채번 (창고,부서,은행은 제외)
////       단 기타거래처에서 999999는 자동채번에서 제외
//////////////////////////////////////////////////////////////
//String 	sFetched_Id = '', sext_code
//real		rMaxCode
//
//SELECT Max("VNDMST"."CVCOD")
//  INTO :sFetched_Id
//  FROM "VNDMST"  
// WHERE "VNDMST"."CVGU" = '9' AND 
//		 SUBSTR("VNDMST"."CVCOD", 1, 1)  = '9' AND
//		 "VNDMST"."CVCOD" <> '999999'   ;
//
//IF IsNull(sFetched_Id) or  sFetched_id = ''   THEN
//	sFetched_Id = '9' + "00000"
//ELSE
//	DO 
//		SELECT "VNDMST"."CVCOD"
//		  INTO :sext_code
//		  FROM "VNDMST"  
//		 WHERE "VNDMST"."CVCOD" = :sFetched_Id    ;
//		IF SQLCA.SQLCODE = 0 THEN
//			sFetched_Id = String(real(sFetched_id) + 1)
//		END IF
//		
//	LOOP UNTIL SQLCA.SQLCODE = 100
//END IF
//
//rMaxCode = real(sFetched_id) 
//
//IF rMaxCode >= 1 AND len(string(rmaxcode)) = 6 AND string(rmaxcode) <> '999999' THEN
//	dw_main.SetItem(1, "cvcod" , string(rMaxCode) )
//	dw_ip.SetItem(1, "vndcod" , string(rMaxCode) )
//	dw_ip.SetItem(1, "custno" , string(rMaxCode) )
//ELSE
//	MessageBox("거래처구분 확인", "거래처코드를 채번할 수 없습니다.")
//	dw_ip.SetFocus()
//	RETURN -1
//END IF
//	
RETURN	1

end function

public function integer wf_mult_custom (string as_gubun);
string	sCode, sName, sGubun, sSaup, sInter

sCode = dw_detail.getitemstring(1, "cvcod")
sName = dw_detail.getitemstring(1, "cvnas")
sGubun= dw_detail.getitemstring(1, "cvgu")
sSaup = dw_detail.getitemstring(1, "sano")

CHOOSE CASE  sGubun
	CASE '1' TO  '2'
		sInter = '1'
	CASE '9'
		sInter = '99'
END CHOOSE

IF sInter <> ''	THEN
	IF f_Mult_Custom(sCode,sName,sInter,sSaup,'','','',as_Gubun) = -1	THEN	RETURN -1
END IF

RETURN 1
end function

public subroutine wf_query ();sle_msg.text = "조회"

ic_Status = '2'

dw_detail.SetTabOrder('cvcod', 0)
//dw_detail.Modify("cvcod.BackGround.Color= 79741120") 

//cb_delete.enabled = true
p_del.PictureName = "C:\erpman\image\삭제_up.gif"

dw_detail.SetFocus()


end subroutine

public subroutine wf_new ();ic_status = '1'
sle_msg.text = "등록"

dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.InsertRow(0)

dw_detail.SetTabOrder('cvcod', 10)
//dw_detail.Modify("cvcod.BackGround.Color= 65535") 
dw_detail.setitem(1, 'emp_id', is_empno)
dw_detail.SetColumn('cvcod')
dw_detail.SetFocus()

dw_detail.setredraw(true)

//cb_delete.enabled = false
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

dw_list.retrieve()
end subroutine

on w_pdm_01045.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_mod=create p_mod
this.p_inq=create p_inq
this.cbx_1=create cbx_1
this.dw_list=create dw_list
this.sle_msg=create sle_msg
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_can,&
this.p_del,&
this.p_mod,&
this.p_inq,&
this.cbx_1,&
this.dw_list,&
this.sle_msg,&
this.dw_detail,&
this.rr_1,&
this.rr_2}
end on

on w_pdm_01045.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_inq)
destroy(this.cbx_1)
destroy(this.dw_list)
destroy(this.sle_msg)
destroy(this.dw_detail)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;f_window_center_response(this)

dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)
is_empno = gs_code

wf_new()





end event

type p_exit from uo_picture within w_pdm_01045
integer x = 3086
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdm_01045
integer x = 2912
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

wf_New()

sle_msg.text = ''

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_del from uo_picture within w_pdm_01045
integer x = 2738
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
Beep (1)

string s_key

sle_msg.text = ''

IF dw_detail.AcceptText() = -1	THEN	RETURN

s_Key = dw_detail.GetItemString(1, "cvcod")

SetPointer(HourGlass!)

//삭제하기전에 삭제여부 체크해야 
IF wf_cvcod_check(s_key) = -1 THEN RETURN

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ",question!, yesno!)  = 2 THEN return  

IF wf_mult_custom('99') = -1	THEN	
	ROLLBACK;
	F_ROLLBACK()
	Return
END IF
	
dw_detail.SetRedraw(False)
dw_detail.DeleteRow(0)

IF dw_detail.Update() > 0	 THEN
	COMMIT;
	sle_msg.text ='자료를 삭제하였습니다!!'
ELSE
	ROLLBACK;
	dw_detail.SetRedraw(True)
	Return
END IF

p_can.TriggerEvent(clicked!)   


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_pdm_01045
integer x = 2565
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
string  s_cvcod

sle_msg.text = ''

IF dw_detail.Accepttext() = -1 THEN 	
	dw_detail.setfocus()
	RETURN
END IF

SetPointer(HourGlass!)

// 등록시 PK 확인
IF ic_status = '1' THEN
   If cbx_1.Checked = TRUE THEN
//   	IF  wf_MaxCustCode() = -1	THEN	RETURN 
   END IF
END IF

IF  wf_Confirm_key() = -1  THEN 	RETURN
	
IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

// 거래처구분이 수입처일 경우 무검사거래처
//IF wf_CheckGubun() = -1		THEN	RETURN

IF dw_detail.Update() > 0	THEN

   IF wf_mult_custom('1') = -1	THEN		
		ROLLBACK USING sqlca;
		F_ROLLBACK()
		Return
   end if		

	COMMIT USING sqlca;	
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	Return
END IF

wf_query()		
dw_list.retrieve()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_inq from uo_picture within w_pdm_01045
integer x = 2391
integer y = 24
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
sle_msg.text = ''

IF dw_detail.AcceptText() = -1	THEN
	dw_detail.SetFocus()
	return
END IF

string	sCode1, get_nm

sCode1 = dw_detail.GetItemString(1, 'cvcod')    //거래처코드

IF IsNull(sCode1)	 or  sCode1 = ''	THEN
	f_message_chk(30,'[거래처코드]')
	dw_detail.SetColumn("cvcod")
	dw_detail.SetFocus()
	RETURN
END IF

IF dw_detail.Retrieve(sCode1) > 0		THEN
	wf_Query()
ELSE	
	f_message_chk(50,'')
   wf_new()
END IF


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cbx_1 from checkbox within w_pdm_01045
integer x = 2661
integer y = 256
integer width = 489
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "자동채번 여부"
borderstyle borderstyle = stylelowered!
end type

type dw_list from u_d_popup_sort within w_pdm_01045
event ue_key pbm_dwnkey
integer x = 18
integer y = 212
integer width = 1390
integer height = 1768
string dataobject = "d_pdm_01045"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose
end event

event clicked;If Row <= 0 then
//	this.SelectRow(0,False)
	b_flag =True
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	b_flag = False
	
   if dw_detail.Retrieve(this.GetItemString(Row,"cvcod")) <= 0 then
		f_message_chk(56, '[기타거래처]')
		return 
   else
		wf_Query()
	end if	
END IF

CALL SUPER ::CLICKED 
end event

type sle_msg from statictext within w_pdm_01045
integer x = 343
integer y = 2044
integer width = 2885
integer height = 84
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
long bordercolor = 32106727
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_detail from datawindow within w_pdm_01045
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1458
integer y = 216
integer width = 1801
integer height = 1760
integer taborder = 10
string dataobject = "d_pdm_01045_1"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event losefocus;this.AcceptText()
end event

event itemchanged;sle_msg.text = ''

long     get_count
string	scvcod, sNull, sres_no, sname, saddr, get_zip, get_addr

SetNull(sNull)

IF this.GetColumnName() ="cvcod" THEN 
	
	scvcod = this.GetText()
	
	SELECT "VNDMST"."CVNAS2"  
	  INTO :sname  
	  FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :scvcod   ;

	IF SQLCA.SQLCODE = 0 THEN
		p_inq.TriggerEvent(Clicked!)
	END IF

ELSEIF	this.getcolumnname() = "cvnas" THEN
	sname = this.GETTEXT()
	this.setitem(1, 'cvnas2', left(sname, 20))
	
ELSEIF	this.getcolumnname() = "sano"	THEN
	string	sGubun, SaupNo, DupCheck, DupName, scvcod2
	SaupNo = trim(this.GETTEXT())				
	IF IsNull(saupno) OR saupno ="" THEN RETURN 
	scvcod2 = this.getitemstring(1, "cvcod")
	
   if scvcod = "" or isnull(scvcod) then 
		SELECT "VNDMST"."CVCOD",   "VNDMST"."CVNAS"  
		  INTO :DupCheck,   :DupName  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."SANO" = :SaupNo   ;
   else
		SELECT "VNDMST"."CVCOD",   "VNDMST"."CVNAS"  
		  INTO :DupCheck,   :DupName  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."SANO" = :SaupNo AND "VNDMST"."CVCOD" <> :scvcod2  ;
   end if
	
	IF sqlca.sqlcode = 0 THEN
		IF messagebox("사업자등록번호 확인", "등록된 사업자등록번호입니다.~n~r" 	&
						+ "거래처번호 : " + DupCheck + "~n~r거래처   명 : " + DupName + "~n~n" + &
						  "계속하시겠습니까?",Question!,YesNo!, 2) = 2 then
			this.setitem(1, "sano", sNull)
			return 1
		END IF
	END IF
	IF f_vendcode_check(saupno) = False THEN
		IF MessageBox("확 인","사업자등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"sano",snull)
			Return 1
		END IF	
	END IF
ELSEIF this.GetColumnName() = "resident" THEN
	sres_no = trim(this.GETTEXT())				
	
	IF sres_no = "" OR IsNull(sres_no) THEN RETURN
	
	IF f_vendcode_check(sres_no) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"resident",snull)
			Return 1
		END IF
	END IF
ELSEIF this.GetColumnName() ="addr1" THEN
	saddr = this.GetText()
	
	IF IsNull(saddr) OR saddr ="" then
		return 
   ELSE
		saddr = '%' + saddr + '%'
	END IF
	
   SELECT COUNT(*), MAX(ZIP), MAX(ADDR)  
     INTO :get_count, :get_zip, :get_addr
     FROM P0_ZIP  
    WHERE ADDR like :saddr   ;

	IF get_count = 1 THEN 
		this.SetItem(1,"posno", get_zip)
		this.SetItem(1,"addr1", get_addr)
		return 1
	ELSEIF get_count > 1 THEN 
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"posno", snull)
			this.SetItem(1,"addr1", snull)
		END IF
		Return 1	
	ELSE
	   return
	END IF	
END IF

end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event rbuttondown;sle_msg.text = ''

SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() ="cvcod" THEN 
	gs_gubun = '9'
	gi_page = -1 
   Open(w_vndmst_popup)
	gi_page = 0 

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	dw_detail.SetItem(1, "cvcod", gs_Code)
	
	p_inq.TriggerEvent(Clicked!)
ELSEIF this.GetColumnName() ="addr1" THEN
	
	Gs_code = this.GetText()
	
	IF IsNull(Gs_code) THEN Gs_code =""

//	Open(w_zip_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	
	this.SetItem(1,"posno",Gs_code)
	this.SetItem(1,"addr1",Gs_codename)
	
	this.SetColumn("addr2")
	this.SetFocus()
ELSEIF this.GetColumnName() ="posno" THEN
	IF IsNull(Gs_code) THEN Gs_code =""
	
//	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN
	
	this.SetItem(1,"posno",Gs_code)
	this.SetItem(1,"addr1",Gs_codename)
	
	this.SetColumn("addr2")
	this.SetFocus()
END IF
end event

event itemerror;return 1
end event

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type rr_1 from roundrectangle within w_pdm_01045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1449
integer y = 204
integer width = 1824
integer height = 1784
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdm_01045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 204
integer width = 1422
integer height = 1784
integer cornerheight = 40
integer cornerwidth = 46
end type

