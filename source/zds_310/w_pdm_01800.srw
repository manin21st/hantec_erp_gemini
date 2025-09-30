$PBExportHeader$w_pdm_01800.srw
$PBExportComments$금형수명관리
forward
global type w_pdm_01800 from w_inherite
end type
type dw_kum from datawindow within w_pdm_01800
end type
type cbx_1 from checkbox within w_pdm_01800
end type
type dw_1 from u_d_select_sort within w_pdm_01800
end type
type dw_2 from datawindow within w_pdm_01800
end type
type p_xls from picture within w_pdm_01800
end type
type rr_1 from roundrectangle within w_pdm_01800
end type
type rr_2 from roundrectangle within w_pdm_01800
end type
end forward

global type w_pdm_01800 from w_inherite
integer width = 5627
integer height = 2660
string title = "동시작업 품번관리"
dw_kum dw_kum
cbx_1 cbx_1
dw_1 dw_1
dw_2 dw_2
p_xls p_xls
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01800 w_pdm_01800

type variables
String is_kum
Long il_focus
end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_mod (integer ai_mod)
public function integer wf_duplication_chk (integer crow)
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long   i
Long   ll_cnt, ll_main
Long   ll_find

String ls_cav
String ls_kum
String ls_itn

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return -1

for i = 1 to ll_cnt
	ls_kum = dw_insert.GetItemString(i, 'kumno')
	if Isnull(ls_kum) or Trim(ls_kum) = "" then
//	   f_message_chk(1400,'[조코드]')
//      MessageBox('확인', '금형번호가 누락되었습니다.')
      MessageBox('확인', 'MAIN품번이 누락되었습니다.')
	   dw_insert.SetColumn('kumno')
	   dw_insert.SetFocus()
	   return -1
   end if	
	
	ls_itn = dw_insert.GetItemString(i, 'itnbr')
	if Isnull(ls_itn) or Trim(ls_itn) = "" then
//	   f_message_chk(1400,'[조명]')
      MessageBox('확인', '부품번호가 누락되었습니다.')
	   dw_insert.SetColumn('itnbr')
	   dw_insert.SetFocus()
		dw_insert.SetRow(i)
	   return -1
   end if
	
	if dw_insert.GetItemString(i, 'useyn') = 'Y' then ll_main++
	
//	ls_cav = dw_insert.GetItemString(i, 'cavno')
	
//	if Isnull(ls_cav) or Trim(ls_cav) = "" then
////	   f_message_chk(1400,'[생산팀]')
//      MessageBox('확인', 'CAV번호가 누락되었습니다.')
//	   dw_insert.SetColumn('cavno')
//	   dw_insert.SetFocus()
//		dw_insert.SetRow(i)
//	   return -1
//   end if
//	
//	If (i + 1) <= ll_cnt Then
//		ll_find = dw_insert.FIND("kumno = '" + ls_kum + "' AND itnbr = '" + ls_itn + "' AND cavno = '" + ls_cav + "'", i + 1, ll_cnt)
//		If ll_find > 0 Then
//			MessageBox('CAV번호 중복', String(ll_find) + ' 번째 Row의 CAV번호가 중복입니다!')
//			dw_insert.SetColumn('cavno')
//			dw_insert.ScrollToRow(ll_find)
//			dw_insert.SetFocus()
//			Return -1
//		End If
//	End If
next

if ll_main > 1 then
	MessageBox('확인', 'MAIN 품번은 유일해야 합니다.')
	RETURN -1
end if

if ll_main = 0 then
	MessageBox('확인', 'MAIN 품번을 지정하십시오.')
	RETURN -1
end if

return 1
end function

public function integer wf_mod (integer ai_mod);long	i

//
if dw_insert.AcceptText() = -1 then return -1

if wf_required_chk() = -1 then return -1 //필수입력항목 체크

for i = 1 to dw_insert.rowcount()
	if wf_duplication_chk(i) = -1 then return -1 // 중복체크
next

If ai_mod = 1 Then
	if f_msg_update() = -1 then return -1 //저장 Yes/No ?
End If

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]')
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return -1
end if

i = dw_1.getselectedrow(0)
if i > 0 then
	dw_1.setitem(i,'cnt',dw_insert.rowcount())
end if

Return 0
end function

public function integer wf_duplication_chk (integer crow);String  s1, s2, s3
long    ll_frow

dw_insert.AcceptText()

s1 = dw_insert.object.itnbr[crow]
s2 = dw_insert.object.cinbr[crow]
s3 = dw_insert.object.kumno[crow]

ll_frow = dw_insert.Find("itnbr = '" + s1 + "' and cinbr = '" + s2 + "' and kumno = '" + s3 + "'", 1, crow - 1)
if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return -1
end if

ll_frow = dw_insert.Find("itnbr = '" + s1 + "' and cinbr = '" + s2 + "' and kumno = '" + s3 + "'", crow + 1, dw_insert.RowCount())

if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return -1
end if
	

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

on w_pdm_01800.create
int iCurrent
call super::create
this.dw_kum=create dw_kum
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.p_xls=create p_xls
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_kum
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.p_xls
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_pdm_01800.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_kum)
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_xls)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_kum.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_kum.insertrow(0)



end event

type dw_insert from w_inherite`dw_insert within w_pdm_01800
integer x = 2121
integer y = 196
integer width = 2478
integer height = 2084
integer taborder = 20
string dataobject = "d_pdm_01800_03_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

end event

event dw_insert::itemchanged;call super::itemchanged;string	sNull, sProject, sjijil, sispec_code, s_section
string	sCode,  sName, 	&
			sItem,  sSpec, &
			sEmpno, sDate,	sItdsc, sIspec, sItnbr, sOpseq, sTuncu, sItgu, soutemp, s_col, s_data 
long		lRow, lReturnRow
dec {5}	dPrice
Integer  iReturn, i
SetNull(sNull)

lRow  = this.GetRow()

IF this.GetColumnName() = "itnbr"	THEN
	sitnbr = this.GetText()
	ireturn = f_get_name3('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_jijil", sjijil)
	RETURN ireturn
END IF
end event

event dw_insert::rbuttondown;call super::rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

// 품번
IF this.GetColumnName() = 'itnbr'	THEN

	open(w_itemas_popup)
	
	IF gs_code = '' or isnull(gs_code) then return 
	
	SetItem(lRow,"itnbr",gs_code)
	SetItem(lRow,"itemas_itdsc",gs_codename)
	
	this.TriggerEvent("itemchanged")
	
END IF




end event

type p_delrow from w_inherite`p_delrow within w_pdm_01800
integer x = 3913
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;Long ll_row

ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return

If f_msg_delete() = - 1 Then Return

dw_insert.DeleteRow(ll_row)

If dw_insert.RowCount() < 1 Then
	dw_insert.SelectRow(0, False)
ElseIf dw_insert.RowCount() = ll_row Then
	dw_insert.SelectRow(0, False)
	dw_insert.SelectRow(ll_row - 1, True)
Else
	dw_insert.SelectRow(0, False)
	dw_insert.SelectRow(ll_row, True)
End If

If dw_insert.UPDATE() = 1 Then 
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '자료삭제를 실패했습니다.')

End If

ll_row = dw_1.getselectedrow(0)
if ll_row > 0 then
	dw_1.setitem(ll_row,'cnt',dw_insert.rowcount())
end if

end event

type p_addrow from w_inherite`p_addrow within w_pdm_01800
integer x = 3739
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;If is_kum = '' Or IsNull(is_kum) Then Return

Long ll_ins

ll_ins = dw_insert.InsertRow(0)

If ll_ins < 1 Then Return

dw_insert.SetItem(ll_ins, 'kumno', is_kum)  //금형번호 (한텍-품번)
dw_insert.SetColumn('itnbr')
dw_insert.ScrollToRow(ll_ins)
dw_insert.SetFocus()



end event

type p_search from w_inherite`p_search within w_pdm_01800
boolean visible = false
integer x = 1714
integer y = 2292
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01800
boolean visible = false
integer x = 677
integer y = 2444
integer taborder = 10
end type

type p_exit from w_inherite`p_exit within w_pdm_01800
integer x = 4434
end type

type p_can from w_inherite`p_can within w_pdm_01800
integer x = 4261
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""


dw_insert.reset()
dw_1.reset()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01800
boolean visible = false
integer x = 4987
integer y = 160
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01800
integer x = 3566
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, ls_itgu

if dw_kum.AcceptText() = -1 then return

sgu = dw_kum.GetItemString(1,'ittyp')
IF IsNull(sgu) THEN 
	MessageBox('확인','품목구분을 선택하세요')
	dw_kum.SetColumn('ittyp')
	dw_kum.SetFocus()
	return
END IF	

scode  	= trim(dw_kum.GetItemString(1,'itnbr'))
ls_itgu  = trim(dw_kum.GetItemString(1,'itgu'))

IF IsNull(scode) Or scode = ''  THEN 
	scode  = "%"
ELSE
	scode  = scode+"%"
END IF
If IsNull(ls_itgu) Or ls_itgu = '' Then ls_itgu = "%"

dw_insert.reset()

dw_1.SetRedraw(False)
dw_1.Retrieve(sgu, scode, ls_itgu)
//dw_insert.ReSet()
dw_1.SetRedraw(True)

//String ls_kum
//
////ls_kum = dw_kum.GetItemString(1, 'kumno')
//
//If ls_kum = '' Or IsNull(ls_kum) Then 
//	ls_kum = '%'
//Else
//	ls_kum = '%' + ls_kum + '%'
//End If
//
//dw_insert.reset()
//
//dw_1.SetRedraw(False)
//dw_1.Retrieve(ls_kum)
////dw_insert.ReSet()
//dw_1.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_pdm_01800
boolean visible = false
integer x = 4786
integer y = 160
end type

type p_mod from w_inherite`p_mod within w_pdm_01800
integer x = 4087
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;wf_mod(1)


end event

type cb_exit from w_inherite`cb_exit within w_pdm_01800
integer x = 4041
integer y = 2328
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01800
integer x = 2999
integer y = 2328
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01800
integer x = 2651
integer y = 2328
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01800
integer x = 3346
integer y = 2328
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01800
integer x = 393
integer y = 2320
end type

type cb_print from w_inherite`cb_print within w_pdm_01800
integer x = 1253
integer y = 2336
end type

type st_1 from w_inherite`st_1 within w_pdm_01800
end type

type cb_can from w_inherite`cb_can within w_pdm_01800
integer x = 3694
integer y = 2328
end type

type cb_search from w_inherite`cb_search within w_pdm_01800
integer x = 750
integer y = 2336
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01800
integer x = 18
integer y = 2512
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01800
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01800
end type

type dw_kum from datawindow within w_pdm_01800
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 23
integer y = 12
integer width = 2811
integer height = 156
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01800_01_item"
boolean border = false
boolean livescroll = true
end type

event ue_key;//Parent.event key(key, keyflags)
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;string snull, s_name

setnull(snull)

Choose Case GetColumnName() 
	Case 'ittyp'
		s_name = this.gettext()
	 
		IF s_name = "" OR IsNull(s_name) THEN 
			RETURN
		END IF
		
		s_name = f_get_reffer('05', s_name)
		if isnull(s_name) or s_name="" then
			f_message_chk(33,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if	
	Case 'itnbr', 'itdsc', 'ispec', 'itm_shtnm'
		p_inq.PostEvent(Clicked!)
END Choose



//This.AcceptText()
//
//If row < 1 Then Return
//
//String ls_name
//
//Choose Case dwo.name
//	Case 'kumno'
//		If Trim(data) = '' OR IsNull(data) Then
//			This.SetItem(row, 'kumnm', '')
//			Return
//		End If
//		
//		SELECT KUMNAME
//		  INTO :ls_name
//		  FROM KUMMST
//		 WHERE KUMNO = :data ;
//		If Trim(ls_name) = '' OR IsNull(ls_name) Then SetNull(ls_name)
//		
//		This.SetItem(row, 'kumnm', ls_name)
//End Choose
//
//p_inq.TriggerEvent(Clicked!)
end event

event rbuttondown;//If row < 1 Then Return
//
//String ls_name
//
//SetNull(gs_code)
//
//Choose Case dwo.name
//	Case 'kumno'
//		Open(w_imt_04630_popup)
//		
//		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
//		
//		SELECT KUMNAME
//		  INTO :ls_name
//		  FROM KUMMST
//		 WHERE KUMNO = :gs_code ;
//		If Trim(ls_name) = '' OR IsNull(ls_name) Then Return
//			
//		This.SetItem(row, 'kumno', gs_code)		
//		This.SetItem(row, 'kumnm', ls_name)
//End Choose
end event

type cbx_1 from checkbox within w_pdm_01800
integer x = 2848
integer y = 100
integer width = 361
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "Count > 0"
end type

event clicked;if this.checked then
	dw_1.setfilter("cnt > 0")
	dw_1.filter()
else
	dw_1.setfilter("")
	dw_1.filter()
end if
end event

type dw_1 from u_d_select_sort within w_pdm_01800
integer x = 27
integer y = 196
integer width = 2030
integer height = 2084
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdm_01800_02_item"
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)


//is_kum = This.GetItemString(currentrow, 'kumno')

is_kum = This.GetItemString(currentrow, 'itemas_itnbr')
If is_kum = '' OR IsNull(is_kum) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(is_kum)
dw_insert.SetRedraw(True)
end event

event clicked;call super::clicked;If row < 1 Then Return

//is_kum = This.GetItemString(row, 'kumno')

is_kum = This.GetItemString(row, 'itemas_itnbr')
If is_kum = '' OR IsNull(is_kum) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(is_kum)
dw_insert.SetRedraw(True)
end event

event retrieveend;call super::retrieveend;If rowcount < 1 Then Return

//is_kum = This.GetItemString(1, 'kumno')

is_kum = This.GetItemString(1, 'itemas_itnbr')
If is_kum = '' OR IsNull(is_kum) Then Return

dw_insert.SetRedraw(False)
dw_insert.Retrieve(is_kum)
dw_insert.SetRedraw(True)
end event

type dw_2 from datawindow within w_pdm_01800
boolean visible = false
integer x = 2144
integer y = 2000
integer width = 393
integer height = 244
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_pdm_01800_excel"
boolean border = false
end type

event constructor;This.SetTransObject(SQLCA)
end event

type p_xls from picture within w_pdm_01800
integer x = 3232
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\엑셀변환_up.gif"
boolean focusrectangle = false
end type

event clicked;dw_2.SetRedraw(False)
dw_2.Retrieve()
dw_2.SetRedraw(True)

If dw_2.RowCount() < 1 Then
	MessageBox('확인', '변환할 자료가 없습니다.')
	Return
End If

If this.Enabled Then wf_excel_down(dw_2)
end event

type rr_1 from roundrectangle within w_pdm_01800
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 188
integer width = 2053
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01800
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2112
integer y = 188
integer width = 2496
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

