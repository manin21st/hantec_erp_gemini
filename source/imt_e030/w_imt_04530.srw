$PBExportHeader$w_imt_04530.srw
$PBExportComments$업체별 매입금액 현황
forward
global type w_imt_04530 from w_standard_print
end type
type pb_2 from u_pb_cal within w_imt_04530
end type
type pb_1 from u_pb_cal within w_imt_04530
end type
type dw_det from datawindow within w_imt_04530
end type
type dw_bul from datawindow within w_imt_04530
end type
type rr_2 from roundrectangle within w_imt_04530
end type
end forward

global type w_imt_04530 from w_standard_print
integer width = 4667
string title = "업체별 매입금액 현황"
pb_2 pb_2
pb_1 pb_1
dw_det dw_det
dw_bul dw_bul
rr_2 rr_2
end type
global w_imt_04530 w_imt_04530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_frmipgo, s_toipgo, s_frmvnd, s_tovnd, sempno1, sempno2, swaigu, ssugu , s_saupj, smro, sfitem, stitem, sittyp
long     l_retriv

if dw_ip.AcceptText() = -1 then return -1

s_saupj    = dw_ip.GetItemString(1, "saupj")
s_frmipgo  = trim(dw_ip.GetItemString(1,"frmipgo"))
s_toipgo   = trim(dw_ip.GetItemString(1,"toipgo"))
s_frmvnd   = dw_ip.GetItemString(1,"frmvnd")
s_tovnd    = dw_ip.GetItemString(1,"tovnd")
sempno1    = dw_ip.GetItemString(1,"empno1")
sempno2    = dw_ip.GetItemString(1,"empno2")
sempno2    = dw_ip.GetItemString(1,"empno2")

sfitem     = dw_ip.GetItemString(1,"frmitem")
stitem     = dw_ip.GetItemString(1,"toitem" )

sittyp     = dw_ip.GetItemString(1,"ittyp")

If Trim(sittyp) = '' OR IsNull(sittyp) Then sittyp = '%'

If Trim(sfitem) = '' OR IsNull(sfitem) Then sfitem = '.'
If Trim(stitem) = '' OR IsNull(stitem) Then stitem = 'ZZZZZZZZZZZZZZZZZZZZ'

swaigu  = dw_ip.GetItemString(1,"maip")
ssugu   = dw_ip.GetItemString(1,"itgu")
smro    = dw_ip.GetItemString(1,"mro")

IF IsNull(s_frmipgo) OR s_frmipgo = "" then s_frmipgo = '10000101'
IF IsNull(s_toipgo) OR s_toipgo = "" then s_toipgo = '99991231'

if ( IsNull(s_saupj) or s_saupj = "" ) then
	f_message_chk( 30 , "[사업장]" )
	dw_ip.Setcolumn('saupj')
	dw_ip.setfocus()
	return -1 
end if

//거래처
IF IsNull(s_frmvnd) OR s_frmvnd = "" THEN  s_frmvnd = '.'
IF IsNull(s_tovnd) OR s_tovnd = "" THEN  s_tovnd = 'zzzzzz'
IF IsNull(sempno1) OR sempno1 = "" THEN  sempno1 = '.'
IF IsNull(sempno2) OR sempno2 = "" THEN  sempno2 = 'zzzzzz'

If dw_ip.GetItemString(1,"gub") = '3' Then
	l_retriv = dw_print.Retrieve(gs_sabu, s_frmipgo, s_toipgo, s_frmvnd, s_tovnd, &
	                             ssugu, sempno1, sempno2, swaigu , s_saupj, smro, sfitem, stitem )
Else
	l_retriv = dw_print.Retrieve(gs_sabu, s_frmipgo, s_toipgo, s_frmvnd, s_tovnd, &
	                             ssugu, sempno1, sempno2, swaigu , s_saupj, smro, sfitem, stitem, sittyp )
End If

IF l_retriv < 1 THEN
	f_message_chk(50,"[업체별 매입금액 현황]")
	dw_ip.SetColumn('frmipgo')
	dw_ip.SetFocus()
	return -1
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_imt_04530.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_det=create dw_det
this.dw_bul=create dw_bul
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_det
this.Control[iCurrent+4]=this.dw_bul
this.Control[iCurrent+5]=this.rr_2
end on

on w_imt_04530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_det)
destroy(this.dw_bul)
destroy(this.rr_2)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

f_child_saupj(dw_ip,'empno1',gs_saupj)
f_child_saupj(dw_ip,'empno2',gs_saupj)

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')


string  s_frmipgo, s_toipgo

s_frmipgo = Mid(f_today(),1,6) + "01"
s_toipgo  = f_today()

//초기화
dw_ip.SetItem(1, "frmipgo", s_frmipgo)		
dw_ip.SetItem(1, "toipgo", s_toipgo)

///* 부가 사업장 */
//f_mod_saupj(dw_ip,'saupj')
end event

type p_xls from w_standard_print`p_xls within w_imt_04530
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_imt_04530
boolean visible = true
integer x = 4439
integer y = 164
end type

type p_preview from w_standard_print`p_preview within w_imt_04530
end type

type p_exit from w_standard_print`p_exit within w_imt_04530
end type

type p_print from w_standard_print`p_print within w_imt_04530
boolean visible = false
integer x = 4265
integer y = 312
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04530
end type

event p_retrieve::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_imt_04530
end type



type dw_print from w_standard_print`dw_print within w_imt_04530
integer x = 4238
integer y = 184
string dataobject = "d_imt_04531_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04530
integer x = 37
integer y = 0
integer width = 3749
integer height = 460
string dataobject = "d_imt_04530"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string snull, s_col, s_cod, s_nam, s_nam1

sle_msg.Text = ""
this.AcceptText()
SetNull(snull)

s_col = this.GetColumnName()
if s_col = "frmipgo" then
	if IsNull(trim(this.object.frmipgo[1])) or trim(this.object.frmipgo[1]) = "" then return 
	if f_datechk(trim(this.object.frmipgo[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.frmipgo[1]) + "]")
		this.object.frmipgo[1] = ""
		return 1
	end if
elseif s_col = "toipgo" then
	if IsNull(trim(this.object.toipgo[1])) or trim(this.object.toipgo[1]) = "" then return 
	if f_datechk(trim(this.object.toipgo[1])) = -1 then
		messagebox("확인","날짜입력에러![" + trim(this.object.toipgo[1]) + "]")
		this.object.toipgo[1] = ""
		return 1
	end if
// 
ELSEIF s_col = 'frmvnd' THEN   
	s_cod = Trim(this.GetText())
	IF IsNull(s_cod) OR s_cod = "" THEN 
		this.SetItem(1,"frmvndnam",snull)		
		this.SetItem(1,"frmvnd",snull)
		This.SetItem(1, 'tovnd', snull)
		This.SetItem(1, 'tovndnam', snull)
		return
	END IF
	
	SELECT CVNAS
     INTO :s_nam
     FROM VNDMST  
    WHERE CVCOD = :s_cod;                    

	IF sqlca.sqlcode = 0 THEN
		this.SetItem(1,"frmvndnam",s_nam)
		This.SetItem(1, 'tovnd', s_cod)
		This.SetItem(1, 'tovndnam', s_nam)
	ELSE
		this.SetItem(1,"frmvndnam",snull)
		This.SetItem(1, 'tovndnam', snull)
	END IF
	
ELSEIF s_col = 'tovnd' THEN   
	s_cod = Trim(this.GetText())
	IF IsNull(s_cod) OR s_cod = "" THEN
		this.SetItem(1,"tovnd",snull)
		this.SetItem(1,"tovndnam",snull)		
		return
	END IF
	
	SELECT CVNAS
     INTO :s_nam
     FROM VNDMST  
    WHERE CVCOD = :s_cod;                    

	IF sqlca.sqlcode = 0 THEN
		this.SetItem(1,"tovndnam",s_nam)
	ELSE
		this.SetItem(1,"tovndnam",snull)		
	END IF
ELSEIF s_col = 'gub' THEN   
	s_cod = Trim(this.GetText())
   if s_cod = '1' then 
		dw_list.DataObject = "d_imt_04531_temp"
		dw_print.DataObject = "d_imt_04531_p"
   elseif s_cod = '2' then
		dw_list.DataObject = "d_imt_04532"
		dw_print.DataObject = "d_imt_04532_p"
   elseif s_cod = '3' then
		dw_list.DataObject = "d_imt_04533"
		dw_print.DataObject = "d_imt_04533_p"
	elseif s_cod = '4' then
		dw_list.DataObject = "d_imt_04534"
		dw_print.DataObject = "d_imt_04534_p"
   end if		

	dw_print.SetTransObject(SQLCA)
elseif getcolumnname() = 'saupj' then
	s_cod = Gettext()
	f_child_saupj(dw_ip,'empno1',s_cod)
	f_child_saupj(dw_ip,'empno2',s_cod)
ElseIf GetColumnName() = 'frmitem' Then
	This.SetItem(row, 'toitem', data)
END IF	
	

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.GetColumnName() = "frmvnd"	THEN		
	gs_gubun = '1' 
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "frmvnd", gs_code)
	this.SetItem(1, "frmvndnam", gs_codename)
	this.SetItem(1, "tovnd", gs_code)
	this.SetItem(1, "tovndnam", gs_codename)
ELSEIF this.GetColumnName() = "tovnd" THEN		
	gs_gubun = '1' 
	Open(w_vndmst_popup)
	IF IsNull(gs_code) OR gs_code = "" THEN  return
	this.SetItem(1, "tovnd", gs_code)
	this.SetItem(1, "tovndnam", gs_codename)
ElseIf This.GetColumnName() = 'frmitem' Then
	open(w_itemas_popup)	
	if gs_code = '' or isnull(gs_code) then return 
	setitem(1, "frmitem", gs_code)
	setitem(1, "toitem", gs_code)
ElseIf This.GetColumnName() = 'toitem' Then
	open(w_itemas_popup)	
	if gs_code = '' or isnull(gs_code) then return 
	setitem(1, "toitem", gs_code)
END IF




end event

type dw_list from w_standard_print`dw_list within w_imt_04530
integer y = 468
integer width = 4553
integer height = 1852
string dataobject = "d_imt_04531_temp"
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;If row < 1 Then Return

dw_ip.AcceptText()

Choose Case dwo.name
	Case 'imhist_iogbn', 'iomatrix_ionam'
		String ls_iogbn
		String ls_jpno
		ls_iogbn = This.GetItemString(row, 'imhist_iogbn' )
		ls_jpno  = This.GetItemString(row, 'imhist_iojpno')
		If Trim(ls_iogbn) = '' OR IsNull(ls_iogbn) Then
			Return
		ElseIf ls_iogbn <> 'I21' Then
			Return
		End If
		If Trim(ls_jpno)  = '' OR IsNull(ls_jpno)  Then Return
		
		dw_bul.Visible = True
		
		dw_bul.Retrieve(gs_sabu, ls_iogbn, ls_jpno)
	Case 'imhist_itnbr'
		String ls_gub
		ls_gub = dw_ip.GetItemString(1, 'gub')
		If ls_gub = '1' Then			
			dw_det.Visible = True
			
			string   s_frmipgo, s_toipgo, s_frmvnd, s_tovnd, sempno1, sempno2, swaigu, ssugu , s_saupj, smro, sfitem, stitem
			long     l_retriv
			
			s_saupj    = dw_ip.GetItemString(1, "saupj")
			s_frmipgo  = trim(dw_ip.GetItemString(1,"frmipgo"))
			s_toipgo   = trim(dw_ip.GetItemString(1,"toipgo"))
			sempno1    = dw_ip.GetItemString(1,"empno1")
			sempno2    = dw_ip.GetItemString(1,"empno2")
			
			sfitem     = This.GetItemString(row, 'imhist_itnbr')
			s_frmvnd   = This.GetItemString(row, 'imhist_cvcod')
			
			If Trim(sfitem) = '' OR IsNull(sfitem) Then Return
			
			swaigu  = dw_ip.GetItemString(1,"maip")
			ssugu   = dw_ip.GetItemString(1,"itgu")
			smro    = dw_ip.GetItemString(1,"mro")
			
			IF IsNull(s_frmipgo) OR s_frmipgo = "" then s_frmipgo = '10000101'
			IF IsNull(s_toipgo) OR s_toipgo = "" then s_toipgo = '99991231'
			
			if ( IsNull(s_saupj) or s_saupj = "" ) then
				f_message_chk( 30 , "[사업장]" )
				dw_ip.Setcolumn('saupj')
				dw_ip.setfocus()
				return -1 
			end if
			
			//거래처
			IF IsNull(s_frmvnd) OR s_frmvnd = "" THEN  Return
			
			IF IsNull(sempno1) OR sempno1 = "" THEN  sempno1 = '.'
			IF IsNull(sempno2) OR sempno2 = "" THEN  sempno2 = 'zzzzzz'
			
			l_retriv = dw_det.Retrieve(gs_sabu, s_frmipgo, s_toipgo, s_frmvnd, ssugu, sempno1, sempno2, swaigu , s_saupj, sfitem )
			
			IF l_retriv < 1 THEN
				f_message_chk(50,"[업체별 매입금액 현황]")
				dw_ip.SetColumn('frmipgo')
				dw_ip.SetFocus()
				return -1
			END IF
		End If
End Choose
end event

type pb_2 from u_pb_cal within w_imt_04530
integer x = 1285
integer y = 100
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('toipgo')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'toipgo', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04530
integer x = 855
integer y = 100
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('frmipgo')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'frmipgo', gs_code)



end event

type dw_det from datawindow within w_imt_04530
boolean visible = false
integer x = 791
integer y = 608
integer width = 3259
integer height = 1320
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "품목 상세 정보 (Double-Click 하시면 창을 닫습니다.)"
string dataobject = "d_imt_04532-pop"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
string icon = "Asterisk!"
boolean hsplitscroll = true
boolean livescroll = true
end type

event doubleclicked;This.Visible = False
This.Reset()
end event

event constructor;This.SetTransObject(SQLCA)
end event

type dw_bul from datawindow within w_imt_04530
boolean visible = false
integer x = 1371
integer y = 720
integer width = 2048
integer height = 1060
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "불량 상세 정보 (Double-Click 하시면 창을 닫습니다.)"
string dataobject = "d_imt_04532-pop1"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
string icon = "Asterisk!"
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event doubleclicked;This.Visible = False
This.Reset()
end event

type rr_2 from roundrectangle within w_imt_04530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 460
integer width = 4571
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

