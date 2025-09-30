$PBExportHeader$wp_pip33.srw
$PBExportComments$** 은행 입금 내역서
forward
global type wp_pip33 from w_standard_print
end type
type dw_1 from datawindow within wp_pip33
end type
type p_2 from picture within wp_pip33
end type
type rr_2 from roundrectangle within wp_pip33
end type
end forward

global type wp_pip33 from w_standard_print
integer x = 0
integer y = 0
integer width = 4667
integer height = 2596
string title = "은행 입금 내역서"
dw_1 dw_1
p_2 p_2
rr_2 rr_2
end type
global wp_pip33 wp_pip33

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_retrieve ();string ls_date,ls_bank1,ls_bank2,ls_pbtag, sKunmu, sSaup
String ls_company,ls_gubn
String sMinBankCode,sMaxBankCode

dw_1.AcceptText()

setpointer(hourglass!)

ls_date  = dw_1.GetItemString(1,"syymm")
ls_bank1 = dw_1.GetItemString(1,"scode1")
ls_bank2 = dw_1.GetItemString(1,"scode2")
ls_pbtag  = dw_1.GetItemString(1,"scodetag")
ls_gubn  = dw_1.GetItemString(1,"gbn")
sKunmu = trim(dw_1.GetitemString(1,'kunmu'))
sSaup = trim(dw_1.GetItemString(1,"saup"))

IF ls_date = '' OR ls_date = '000000' THEN
	MessageBox("확인","지급년월을 입력하세요") 
	dw_1.setcolumn('syymm')
	dw_1.SetFocus()
	return -1 
END IF

IF ls_bank1 = '' OR ISNULL(ls_bank1) THEN
	SELECT MIN ("P0_BANK"."BANKCODE")  
    INTO :sMinBankCode  
    FROM "P0_BANK"  ;
	ls_bank1 = sMinBankCode  
END IF 	
IF ls_bank2 = '' OR ISNULL(ls_bank2) THEN
	SELECT Max ("P0_BANK"."BANKCODE")  
    INTO :sMaxBankCode  
    FROM "P0_BANK"  ;
	ls_bank2 = sMaxBankCode  
END IF
IF ls_bank1 > ls_bank2 THEN
	MessageBox("확인","은행코드범위를 확인하세요") 
	dw_1.SetColumn("scode1")
	dw_1.SetFocus()
	return -1 
END IF


IF IsNull(ls_gubn) or ls_gubn = '' then ls_gubn = '%' 
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF ls_pbtag = 'A'	THEN ls_pbtag = '%'

	
dw_print.modify("address.text = '"+''+"'")
dw_print.modify("tel.text = '"+''+"'")
dw_print.modify("tel.text = '"+''+"'")

IF dw_print.retrieve(ls_date,ls_bank1,ls_bank2,sSaup,ls_gubn,ls_pbtag,sKunmu) < 1 THEN
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_1.setfocus()
	return -1
END IF
String ls_address,ls_tel,ls_fax

//주소
 select dataname
  into : ls_address
  from p0_syscnfg
  where sysgu = 'C' and serial = 1 and lineno = '5' ; 
  dw_print.modify("address.text = '"+ls_address+"'")
//전화번호 
select dataname
  into : ls_tel
  from p0_syscnfg
  where sysgu = 'C' and serial = 1 and lineno = '6' ; 
  dw_print.modify("tel.text = '"+ls_tel+"'")
//팩스번호
select dataname
  into : ls_fax
  from p0_syscnfg
  where sysgu = 'C' and serial = 1 and lineno = '7' ; 
  dw_print.modify("fax.text = '"+ls_fax+"'")

//상호명
select dataname
  into : ls_company
  from p0_syscnfg
  where sysgu = 'C' and serial = 1 and lineno = '3' ; 
  dw_print.modify("scompany.text = '"+ls_company+"'")

IF ls_pbtag = 'P' THEN
	dw_list.modify("t_pay.text = '"+'급  여'+"'")
ELSE
	dw_list.modify("t_pay.text = '"+'상  여'+"'")
END IF

dw_print.sharedata(dw_list)
setpointer(arrow!)

return 1
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(adw_excel,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"	


end subroutine

on wp_pip33.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_2=create p_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_2
this.Control[iCurrent+3]=this.rr_2
end on

on wp_pip33.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.p_2)
destroy(this.rr_2)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = ''

dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)
dw_1.setitem(1,'syymm',left(f_today(),6))

f_set_saupcd(dw_1, 'saup', '1')
is_saupcd = gs_saupcd
end event

type p_xls from w_standard_print`p_xls within wp_pip33
end type

type p_sort from w_standard_print`p_sort within wp_pip33
end type

type p_preview from w_standard_print`p_preview within wp_pip33
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within wp_pip33
end type

type p_print from w_standard_print`p_print within wp_pip33
end type

event p_print::clicked;IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip33
end type

type st_window from w_standard_print`st_window within wp_pip33
boolean visible = false
integer x = 2418
integer y = 2780
end type

type sle_msg from w_standard_print`sle_msg within wp_pip33
boolean visible = false
integer x = 443
integer y = 2780
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip33
boolean visible = false
integer x = 2912
integer y = 2780
end type

type st_10 from w_standard_print`st_10 within wp_pip33
boolean visible = false
integer x = 82
integer y = 2780
end type

type gb_10 from w_standard_print`gb_10 within wp_pip33
boolean visible = false
integer x = 82
integer y = 2740
end type

type dw_print from w_standard_print`dw_print within wp_pip33
integer x = 3950
integer y = 212
string dataobject = "dp_pip33_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip33
boolean visible = false
integer x = 539
integer y = 2408
integer taborder = 80
end type

type dw_list from w_standard_print`dw_list within wp_pip33
integer x = 773
integer y = 304
integer width = 3040
integer height = 1916
string dataobject = "dp_pip33"
boolean border = false
end type

type dw_1 from datawindow within wp_pip33
event ue_enter pbm_dwnprocessenter
event ue_keydown pbm_dwnkey
integer x = 745
integer y = 44
integer width = 3104
integer height = 232
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_pip30ret"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sbank1,sbankName1
String sbank2,sbankName2
String SetNull
String bankname

dw_1.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() = "scode1" THEN
	 sbank1 = this.GetText()
	IF sbank1 = '' or isnull(sbank1) THEN
      dw_1.SetITem(1,"scode1",SetNull)		
      dw_1.SetITem(1,"scodename1",SetNull)		 		
	   RETURN
   END IF
	  SELECT "P0_BANK"."BANKNAME"  
     INTO :bankname
	  FROM "P0_BANK"   
	  WHERE  "P0_BANK"."BANKCODE" =:sbank1;
	  
	  IF SQLCA.SQLCODE <> 0 THEN
		  MessageBox("확인","은행코드를 확인하세요")
		  dw_1.SetITem(1,"scode1",SetNull)		
        dw_1.SetITem(1,"scodename1",SetNull)		 		
		  Return 1
	  ELSE  
        dw_1.SetITem(1,"scodename1",bankname)		 		
     END IF  
ELSEIF this.GetColumnName() = "scode2" THEN	  
	  sbank1 = this.GetText()
	IF sbank1 = '' or isnull(sbank1) THEN
      dw_1.SetITem(1,"scode2",SetNull)		
      dw_1.SetITem(1,"scodename2",SetNull)		 		
		RETURN
	END IF
	  SELECT "P0_BANK"."BANKNAME"  
     INTO :bankname
	  FROM "P0_BANK"   
	  WHERE  "P0_BANK"."BANKCODE" =:sbank1;
	  
	  IF SQLCA.SQLCODE <> 0 THEN
		  MessageBox("확인","은행코드를 확인하세요")
		  dw_1.SetITem(1,"scode2",SetNull)		
        dw_1.SetITem(1,"scodename2",SetNull)		 		
		  Return 1
	  ELSE  
        dw_1.SetITem(1,"scodename2",bankname)		 		
     END IF  
	  
END IF
	
	
	



    
end event

event itemerror;Return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
SetNull(Gs_gubun)	

dw_1.AcceptText()

Gs_gubun = is_saupcd
IF dw_1.GetColumnName() = "scode1" 	THEN

	gs_code = dw_1.GetItemString(1,"scode1")
	
	open(w_bank_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	dw_1.SetItem(1,"scode1",gs_code)
	dw_1.SetItem(1,"scodename1",gs_codename)
	
ELSEIF dw_1.GetColumnName() = "scode2" 	THEN
	
	gs_code = dw_1.GetItemString(1,"scode2")
	
	open(w_bank_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	dw_1.SetItem(1,"scode2",gs_code)
	dw_1.SetItem(1,"scodename2",gs_codename)
END IF
end event

type p_2 from picture within wp_pip33
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3922
integer y = 176
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

event clicked;If this.Enabled Then wf_excel_down(dw_list)
end event

type rr_2 from roundrectangle within wp_pip33
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 754
integer y = 300
integer width = 3086
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

