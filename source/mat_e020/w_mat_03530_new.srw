$PBExportHeader$w_mat_03530_new.srw
$PBExportComments$** 수불장 (한텍)
forward
global type w_mat_03530_new from w_standard_print
end type
type rr_2 from roundrectangle within w_mat_03530_new
end type
type cb_1 from commandbutton within w_mat_03530_new
end type
type dw_print2 from datawindow within w_mat_03530_new
end type
type dw_print3 from datawindow within w_mat_03530_new
end type
type dw_list2 from u_d_select_sort within w_mat_03530_new
end type
type dw_list3 from u_d_select_sort within w_mat_03530_new
end type
type dw_print4 from datawindow within w_mat_03530_new
end type
type dw_list4 from u_d_select_sort within w_mat_03530_new
end type
type dw_1 from datawindow within w_mat_03530_new
end type
end forward

global type w_mat_03530_new from w_standard_print
string title = "수불장-NEW"
rr_2 rr_2
cb_1 cb_1
dw_print2 dw_print2
dw_print3 dw_print3
dw_list2 dw_list2
dw_list3 dw_list3
dw_print4 dw_print4
dw_list4 dw_list4
dw_1 dw_1
end type
global w_mat_03530_new w_mat_03530_new

type variables
str_itnct lstr_sitnct

string	is_create = 'N'
end variables

forward prototypes
public subroutine wf_move (string sitnbr, string sitdsc, string sispec)
public function integer wf_retrieve ()
end prototypes

public subroutine wf_move (string sitnbr, string sitdsc, string sispec);if sitnbr = '' or isnull(sitnbr) then return 

dw_ip.setitem(1, "to_itnbr", sitnbr)	
dw_ip.setitem(1, "to_itdsc", sitdsc)	
dw_ip.setitem(1, "to_ispec", sispec)

end subroutine

public function integer wf_retrieve ();String  s_depot, s_date, sittyp, sitcls, eitcls, sitnbr, eitnbr, sMayymm, s_gub, sedate, ls_saupj
String  ls_oldsql, ls_newsql, ls_finalsql, ls_prtgbn
Long ll_pos

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_gub   = dw_ip.GetItemString(1,"gub")
s_date  = TRIM(dw_ip.GetItemString(1,"syymm"))
sedate  = TRIM(dw_ip.GetItemString(1,"eyymm"))
sittyp  = TRIM(dw_ip.GetItemString(1,"itgu"))
sitcls  = TRIM(dw_ip.GetItemString(1,"itcls"))
eitcls  = TRIM(dw_ip.GetItemString(1,"eitcls"))
sitnbr  = TRIM(dw_ip.GetItemString(1,"fr_itnbr"))
eitnbr  = TRIM(dw_ip.GetItemString(1,"to_itnbr"))
ls_saupj  = TRIM(dw_ip.GetItemString(1,"saupj"))
ls_prtgbn  = TRIM(dw_ip.GetItemString(1,"prtgbn"))

s_depot = dw_ip.GetItemString(1,"depot")

IF s_date = "" OR IsNull(s_date) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF

IF sedate = "" OR IsNull(sedate) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("eyymm")
	dw_ip.SetFocus()
	Return -1
END IF

if s_date > sedate then
	Messagebox("년월", "시작년월이 종료년월보다 큽니다", stopsign!)
	dw_ip.SetColumn("eyymm")
	dw_ip.SetFocus()
	Return -1
End if

if s_gub = '2' then 
	IF s_depot = "" OR IsNull(s_depot) THEN 
		f_message_chk(30,'[창고]')
		dw_ip.SetColumn("depot")
		dw_ip.SetFocus()
		Return -1
	END IF
else
   s_depot = '%'
end if

IF sittyp  = "" OR IsNull(sittyp)  THEN sittyp  = '%'
IF sitcls = "" OR IsNull(sitcls) THEN sitcls = '.'
IF eitcls = "" OR IsNull(eitcls) THEN eitcls = 'ZZZZZZZZZZZZ'
IF sitnbr = "" OR IsNull(sitnbr) THEN sitnbr = '.'
IF eitnbr = "" OR IsNull(eitnbr) THEN eitnbr = 'ZZZZZZZZZZZZ'
IF ls_saupj = "" OR IsNull(ls_saupj) THEN ls_saupj = '%'

//최종마감년월
SELECT MAX(JPDAT)  
  INTO :sMayymm
  FROM JUNPYO_CLOSING  
 WHERE SABU = '1' AND JPGU = 'C0'    ;

if isnull(sMayymm) then sMayymm = ' '

dw_print.ShareDataOff()
dw_print2.ShareDataOff()

IF dw_list.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj) < 1 THEN
	dw_print.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

//IF dw_list.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj) < 1 THEN
//	dw_print.Reset()
//	dw_print.insertrow(0)
////	Return -1
//END IF

dw_list2.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj)
dw_list3.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj)
dw_list4.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj)

Integer		li_rtn
li_rtn = dw_list.ShareData(dw_print)
//Messagebox('1', li_rtn)
dw_list2.ShareData(dw_print2)
dw_print3.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj)
dw_print4.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, ls_saupj)

//IF dw_print.Retrieve(gs_sabu, s_date, sedate, s_depot, sitnbr, eitnbr, sittyp, sitcls, eitcls, gs_saupj) < 1 THEN
//	dw_list.Reset()
//	dw_print.insertrow(0)
////	Return -1
//END IF
//
//dw_print.ShareData(dw_list)

String ls_itgu
ls_itgu = dw_ip.GetItemString(1, 'itgu')
ls_itgu = f_get_reffer('05', ls_itgu)
If Trim(ls_itgu) = '' OR IsNull(ls_itgu) Then ls_itgu = ' '

if ls_prtgbn = '1' then
	dw_print.Object.t_100.text = s_date
	dw_print.Object.t_101.text = sedate
	//dw_print.Object.t_102.text = sMayymm
	dw_print.Object.t_102.text = ls_itgu
elseif ls_prtgbn = '2' then
	dw_print2.Object.t_100.text = s_date
	dw_print2.Object.t_101.text = sedate
	dw_print2.Object.t_102.text = ls_itgu
	//dw_print2.Object.t_102.text = sMayymm
//ElseIf ls_prtgbn = '3' Then
//	dw_print3.Object.t_100.text = s_date
//	dw_print3.Object.t_101.text = sedate
//	dw_print3.Object.t_102.text = ls_itgu
	//dw_print2.Object.t_102.text = sMayymm
ElseIf ls_prtgbn = '4' Then
	dw_print4.Object.t_100.text = s_date
	dw_print4.Object.t_101.text = sedate
	dw_print4.Object.t_102.text = ls_itgu
	//dw_print2.Object.t_102.text = sMayymm
end if

return 1



end function

on w_mat_03530_new.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.cb_1=create cb_1
this.dw_print2=create dw_print2
this.dw_print3=create dw_print3
this.dw_list2=create dw_list2
this.dw_list3=create dw_list3
this.dw_print4=create dw_print4
this.dw_list4=create dw_list4
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_print2
this.Control[iCurrent+4]=this.dw_print3
this.Control[iCurrent+5]=this.dw_list2
this.Control[iCurrent+6]=this.dw_list3
this.Control[iCurrent+7]=this.dw_print4
this.Control[iCurrent+8]=this.dw_list4
this.Control[iCurrent+9]=this.dw_1
end on

on w_mat_03530_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.cb_1)
destroy(this.dw_print2)
destroy(this.dw_print3)
destroy(this.dw_list2)
destroy(this.dw_list3)
destroy(this.dw_print4)
destroy(this.dw_list4)
destroy(this.dw_1)
end on

event open;call super::open;dw_ip.SetItem(1, "syymm", left(f_today(), 6))
dw_ip.SetItem(1, "eyymm", left(f_today(), 6))
dw_ip.SetColumn("syymm")
dw_ip.Setfocus()

dw_list2.settransobject(sqlca)
dw_print2.settransobject(sqlca)
dw_list3.settransobject(sqlca)
dw_print3.settransobject(sqlca)
dw_list4.SetTransObject(SQLCA)
dw_print4.SetTransObject(SQLCA)

end event

event ue_open;call super::ue_open;////사업장
//f_mod_saupj(dw_ip, 'saupj' )

////입고창고 
//f_child_saupj(dw_ip, 'depot', gs_saupj)
end event

type p_xls from w_standard_print`p_xls within w_mat_03530_new
boolean visible = true
integer x = 4270
integer y = 24
end type

event p_xls::clicked;String  ls_prtgbn

If not this.Enabled Then return
IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_prtgbn = TRIM(dw_ip.GetItemString(1,"prtgbn"))
if ls_prtgbn = '1' then
	wf_excel_down(dw_list)	
elseif ls_prtgbn = '2' then
	wf_excel_down(dw_list2)	
elseif ls_prtgbn = '3' then
	wf_excel_down(dw_list3)	
ElseIf ls_prtgbn = '4' then
	wf_excel_down(dw_list4)
end if
end event

type p_sort from w_standard_print`p_sort within w_mat_03530_new
end type

type p_preview from w_standard_print`p_preview within w_mat_03530_new
integer taborder = 50
end type

event p_preview::clicked;String  ls_prtgbn

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_prtgbn = TRIM(dw_ip.GetItemString(1,"prtgbn"))
if ls_prtgbn = '1' then
	OpenWithParm(w_print_preview, dw_print)	
elseif ls_prtgbn = '2' then
	OpenWithParm(w_print_preview, dw_print2)	
elseif ls_prtgbn = '3' then
	OpenWithParm(w_print_preview, dw_print3)
elseif ls_prtgbn = '4' then
	OpenWithParm(w_print_preview, dw_print4)
end if
end event

type p_exit from w_standard_print`p_exit within w_mat_03530_new
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_mat_03530_new
boolean visible = false
integer x = 3671
integer y = 236
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_03530_new
end type

event p_retrieve::clicked;if is_Upmu = 'A' then
	
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


// 수불장-NEW 계산
//cb_1.triggerevent(clicked!)


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











type dw_print from w_standard_print`dw_print within w_mat_03530_new
integer x = 3726
string dataobject = "d_mat_03530_new_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03530_new
integer x = 46
integer y = 20
integer width = 3648
integer height = 400
string dataobject = "d_mat_03530_new_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;string snull, sdate, sitnbr, sitdsc, sispec
int    ireturn 
long	 lsow

setnull(snull)

IF this.GetColumnName() ="syymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ElseIF this.GetColumnName() ="eyymm" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "eyymm", sNull)
		return 1
	END IF	
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	this.setitem(1, "fr_itdsc", sitdsc)	
	this.setitem(1, "fr_ispec", sispec)
	wf_move(sitnbr, sitdsc, sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	this.setitem(1, "to_itdsc", sitdsc)	
	this.setitem(1, "to_ispec", sispec)
	RETURN ireturn

ELSEIF this.getcolumnname() = 'depot' THEN 
	sIspec = this.getText()

	Select cvnas2
	Into :sitdsc
	From vndmst
	Where cvcod = :sIspec;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확인", "창고 코드를 확인하십시요.")
		this.SetFocus()
		this.SetColumn("depot")
		this.SetItem(1,"depotnm",  "")
		Return 2
	ELSE
   	this.setitem(1,"depotnm", sitdsc)
	END IF

ELSEIF this.getcolumnname() = 'prtgbn' THEN 
	sitdsc = this.getText()
	if sitdsc = '1' then
		dw_list.visible = true
		dw_list2.visible = false
		dw_list3.visible = false
		dw_list4.visible = false
	elseif sitdsc = '2' then
		dw_list.visible = false
		dw_list2.visible = true
		dw_list3.visible = false
		dw_list4.visible = false
	elseif sitdsc = '3' then
		dw_list.visible = false
		dw_list2.visible = false
		dw_list3.visible = true
		dw_list4.visible = false
	elseif sitdsc = '4' then
		dw_list.visible = false
		dw_list2.visible = false
		dw_list3.visible = false
		dw_list4.visible = true
	end if


END IF
end event

event dw_ip::rbuttondown;string sIttyp

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'itcls' then
	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetColumn('itcls')
	this.SetFocus()

elseif this.GetColumnName() = 'eitcls' then
	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"eitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('eitcls')
	this.SetFocus()

elseif this.GetColumnName() = 'fr_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
elseif this.GetColumnName() = 'to_itnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
ELSEIF this.getcolumnname() = "depot"	THEN		
	gs_gubun = '5' 
	open(w_vndmst_popup)

	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "depot", gs_code)
	this.SetItem(1, "depotnm", gs_codename)

end if	

end event

type dw_list from w_standard_print`dw_list within w_mat_03530_new
integer x = 78
integer y = 460
integer width = 4517
integer height = 1816
integer taborder = 40
string dataobject = "d_mat_03530_new_1"
boolean border = false
end type

event dw_list::clicked;long		lsow
string	sitnbr

If Row <= 0 then
	dw_list.SelectRow(0,False)
	dw_list2.SelectRow(0,FALSE)
	dw_list3.SelectRow(0,FALSE)
	dw_list4.SelectRow(0,FALSE)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

	sitnbr = this.getitemstring(Row, 'itnbr')
	lsow = dw_list2.find("itnbr='"+sitnbr+"'", 1, dw_list2.rowcount())
	if lsow > 0 then
		dw_list2.SelectRow(0, FALSE)
		dw_list2.SelectRow(lsow,TRUE)
		dw_list2.ScrollToRow(lsow)
	end if
	lsow = dw_list3.find("itnbr='"+sitnbr+"'", 1, dw_list3.rowcount())
	if lsow > 0 then
		dw_list3.SelectRow(0, FALSE)
		dw_list3.SelectRow(lsow,TRUE)
		dw_list3.ScrollToRow(lsow)
	end if
	lsow = dw_list4.find("itnbr='"+sitnbr+"'", 1, dw_list4.rowcount())
	if lsow > 0 then
		dw_list4.SelectRow(0, FALSE)
		dw_list4.SelectRow(lsow,TRUE)
		dw_list4.ScrollToRow(lsow)
	end if
END IF
end event

type rr_2 from roundrectangle within w_mat_03530_new
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 448
integer width = 4562
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

type cb_1 from commandbutton within w_mat_03530_new
boolean visible = false
integer x = 3936
integer y = 240
integer width = 631
integer height = 132
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "수불장 자료 집계"
end type

event clicked;if is_create = 'Y' then return

String sLyymm, sSyymm, sTyymm, sError='X'

//SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
//  INTO :sLyymm
//  FROM "JUNPYO_CLOSING"  
// WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//       ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;
//
//if isnull(sLyymm) or sLyymm = '' then sLyymm = '200610'	// 기초재고
	
sSyymm = dw_ip.getitemstring(1,'syymm')
sTyymm = dw_ip.getitemstring(1,'eyymm')

//if sLyymm <= sSyymm then
//	sSyymm = sLyymm
//end if

setpointer(hourglass!)
w_mdi_frame.sle_msg.text = '수불자료를 집계중입니다....!!'

sError = 'X'
sqlca.ERP000008000(gs_sabu, sSyymm, sTyymm, sError);
//messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
if sError <> 'N' then
	w_mdi_frame.sle_msg.text = ''
	F_message_chk(41,'[수불자료 집계]')
	Rollback;
	return 
end if

Commit;

is_create = 'Y'

//p_retrieve.triggerevent(clicked!)
end event

type dw_print2 from datawindow within w_mat_03530_new
boolean visible = false
integer x = 3611
integer y = 172
integer width = 128
integer height = 112
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03530_new_2_p"
boolean livescroll = true
end type

type dw_print3 from datawindow within w_mat_03530_new
boolean visible = false
integer x = 3611
integer y = 300
integer width = 128
integer height = 112
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03530_new_3"
boolean livescroll = true
end type

type dw_list2 from u_d_select_sort within w_mat_03530_new
boolean visible = false
integer x = 64
integer y = 460
integer width = 4526
integer height = 1816
integer taborder = 11
string dataobject = "d_mat_03530_new_2"
boolean border = false
boolean hsplitscroll = true
end type

event clicked;long		lsow
string	sitnbr

If Row <= 0 then
	dw_list.SelectRow(0,False)
	dw_list2.SelectRow(0,FALSE)
	dw_list3.SelectRow(0,FALSE)
	dw_list4.SelectRow(0,FALSE)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

	sitnbr = this.getitemstring(Row, 'itnbr')
	lsow = dw_list.find("itnbr='"+sitnbr+"'", 1, dw_list.rowcount())
	if lsow > 0 then
		dw_list.SelectRow(0, FALSE)
		dw_list.SelectRow(lsow,TRUE)
		dw_list.ScrollToRow(lsow)
	end if
	lsow = dw_list3.find("itnbr='"+sitnbr+"'", 1, dw_list3.rowcount())
	if lsow > 0 then
		dw_list3.SelectRow(0, FALSE)
		dw_list3.SelectRow(lsow,TRUE)
		dw_list3.ScrollToRow(lsow)
	end if
	lsow = dw_list4.find("itnbr='"+sitnbr+"'", 1, dw_list4.rowcount())
	if lsow > 0 then
		dw_list4.SelectRow(0, FALSE)
		dw_list4.SelectRow(lsow,TRUE)
		dw_list4.ScrollToRow(lsow)
	end if
END IF
end event

type dw_list3 from u_d_select_sort within w_mat_03530_new
boolean visible = false
integer x = 64
integer y = 460
integer width = 4526
integer height = 1816
integer taborder = 21
string dataobject = "d_mat_03530_new_3"
boolean border = false
boolean hsplitscroll = true
end type

event clicked;long		lsow
string	sitnbr

If Row <= 0 then
	dw_list.SelectRow(0,False)
	dw_list2.SelectRow(0,FALSE)
	dw_list3.SelectRow(0,FALSE)
	dw_list4.SelectRow(0,FALSE)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

	sitnbr = this.getitemstring(Row, 'itnbr')
	lsow = dw_list.find("itnbr='"+sitnbr+"'", 1, dw_list.rowcount())
	if lsow > 0 then
		dw_list.SelectRow(0, FALSE)
		dw_list.SelectRow(lsow,TRUE)
		dw_list.ScrollToRow(lsow)
	end if
	lsow = dw_list2.find("itnbr='"+sitnbr+"'", 1, dw_list2.rowcount())
	if lsow > 0 then
		dw_list2.SelectRow(0, FALSE)
		dw_list2.SelectRow(lsow,TRUE)
		dw_list2.ScrollToRow(lsow)
	end if
	lsow = dw_list4.find("itnbr='"+sitnbr+"'", 1, dw_list4.rowcount())
	if lsow > 0 then
		dw_list4.SelectRow(0, FALSE)
		dw_list4.SelectRow(lsow,TRUE)
		dw_list4.ScrollToRow(lsow)
	end if
END IF
end event

type dw_print4 from datawindow within w_mat_03530_new
boolean visible = false
integer x = 3808
integer y = 236
integer width = 128
integer height = 112
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_mat_03530_new_4_p"
boolean livescroll = true
end type

type dw_list4 from u_d_select_sort within w_mat_03530_new
integer x = 64
integer y = 460
integer width = 4526
integer height = 1816
integer taborder = 11
string dataobject = "d_mat_03530_new_4"
boolean border = false
end type

event clicked;call super::clicked;long		lsow
string	sitnbr

If Row <= 0 then
	dw_list.SelectRow(0,False)
	dw_list2.SelectRow(0,FALSE)
	dw_list3.SelectRow(0,FALSE)
	dw_list4.SelectRow(0,FALSE)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

	sitnbr = this.getitemstring(Row, 'itnbr')
	lsow = dw_list.find("itnbr='"+sitnbr+"'", 1, dw_list.rowcount())
	if lsow > 0 then
		dw_list.SelectRow(0, FALSE)
		dw_list.SelectRow(lsow,TRUE)
		dw_list.ScrollToRow(lsow)
	end if
	lsow = dw_list2.find("itnbr='"+sitnbr+"'", 1, dw_list2.rowcount())
	if lsow > 0 then
		dw_list2.SelectRow(0, FALSE)
		dw_list2.SelectRow(lsow,TRUE)
		dw_list2.ScrollToRow(lsow)
	end if
	lsow = dw_list3.find("itnbr='"+sitnbr+"'", 1, dw_list3.rowcount())
	if lsow > 0 then
		dw_list3.SelectRow(0, FALSE)
		dw_list3.SelectRow(lsow,TRUE)
		dw_list3.ScrollToRow(lsow)
	end if
END IF
end event

type dw_1 from datawindow within w_mat_03530_new
boolean visible = false
integer x = 2414
integer y = 1300
integer width = 1609
integer height = 800
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "전체 재고와 창고별 재고 확인용"
string dataobject = "d_mat_03530_new_4_depot"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

