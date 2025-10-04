$PBExportHeader$w_sm10_0045.srw
$PBExportComments$모비스 납품관리
forward
global type w_sm10_0045 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0045
end type
type dw_print from datawindow within w_sm10_0045
end type
type rr_1 from roundrectangle within w_sm10_0045
end type
type rr_2 from roundrectangle within w_sm10_0045
end type
type st_3 from statictext within w_sm10_0045
end type
type e_ek from singlelineedit within w_sm10_0045
end type
type cb_ek from commandbutton within w_sm10_0045
end type
type cb_eh from commandbutton within w_sm10_0045
end type
type e_eh from singlelineedit within w_sm10_0045
end type
type st_2 from statictext within w_sm10_0045
end type
type st_4 from statictext within w_sm10_0045
end type
type cb_1 from commandbutton within w_sm10_0045
end type
type em_1 from editmask within w_sm10_0045
end type
type dw_prt from datawindow within w_sm10_0045
end type
type cb_2 from commandbutton within w_sm10_0045
end type
type p_2 from picture within w_sm10_0045
end type
type p_excel from uo_picture within w_sm10_0045
end type
type rr_3 from roundrectangle within w_sm10_0045
end type
end forward

global type w_sm10_0045 from w_inherite
integer width = 4686
integer height = 3340
string title = "MOBIS A/S VAN 일 발주 현황"
dw_1 dw_1
dw_print dw_print
rr_1 rr_1
rr_2 rr_2
st_3 st_3
e_ek e_ek
cb_ek cb_ek
cb_eh cb_eh
e_eh e_eh
st_2 st_2
st_4 st_4
cb_1 cb_1
em_1 em_1
dw_prt dw_prt
cb_2 cb_2
p_2 p_2
p_excel p_excel
rr_3 rr_3
end type
global w_sm10_0045 w_sm10_0045

forward prototypes
public subroutine wf_excel_down (datawindow adw_excel)
end prototypes

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

on w_sm10_0045.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_print=create dw_print
this.rr_1=create rr_1
this.rr_2=create rr_2
this.st_3=create st_3
this.e_ek=create e_ek
this.cb_ek=create cb_ek
this.cb_eh=create cb_eh
this.e_eh=create e_eh
this.st_2=create st_2
this.st_4=create st_4
this.cb_1=create cb_1
this.em_1=create em_1
this.dw_prt=create dw_prt
this.cb_2=create cb_2
this.p_2=create p_2
this.p_excel=create p_excel
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_print
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.e_ek
this.Control[iCurrent+7]=this.cb_ek
this.Control[iCurrent+8]=this.cb_eh
this.Control[iCurrent+9]=this.e_eh
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.em_1
this.Control[iCurrent+14]=this.dw_prt
this.Control[iCurrent+15]=this.cb_2
this.Control[iCurrent+16]=this.p_2
this.Control[iCurrent+17]=this.p_excel
this.Control[iCurrent+18]=this.rr_3
end on

on w_sm10_0045.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.st_3)
destroy(this.e_ek)
destroy(this.cb_ek)
destroy(this.cb_eh)
destroy(this.e_eh)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.dw_prt)
destroy(this.cb_2)
destroy(this.p_2)
destroy(this.p_excel)
destroy(this.rr_3)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_print.SetTransObject(SQLCA)

dw_1.InsertRow(0)

//dw_1.Object.nap_date1[1] = is_today
//dw_1.Object.nap_date2[1] = is_today

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If




end event

type dw_insert from w_inherite`dw_insert within w_sm10_0045
integer x = 41
integer y = 320
integer width = 4517
integer height = 1928
string dataobject = "d_sm10_0045_napum"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::clicked;call super::clicked;f_multi_select(this)
//IF row <= 0  THEN RETURN
//
//IF IsSelected(row) THEN
//	Selectrow(0,False)
//ELSE
//	Selectrow(0,False)
//	Selectrow(row,True)
//END IF

end event

type p_delrow from w_inherite`p_delrow within w_sm10_0045
boolean visible = false
integer x = 3543
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0045
boolean visible = false
integer x = 3355
integer y = 28
end type

type p_search from w_inherite`p_search within w_sm10_0045
boolean visible = false
integer x = 3342
end type

type p_ins from w_inherite`p_ins within w_sm10_0045
boolean visible = false
integer x = 3195
end type

type p_exit from w_inherite`p_exit within w_sm10_0045
integer x = 4411
end type

event p_exit::clicked;close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0045
integer x = 4238
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If


end event

type p_print from w_inherite`p_print within w_sm10_0045
boolean visible = false
integer x = 3543
boolean enabled = false
end type

event p_print::clicked;call super::clicked;string ls_gubun, ls_saupj, ls_sdate, ls_edate, ls_ptno

if dw_insert.rowcount() = 0 then
	Return
end if

ls_gubun = Trim(dw_1.getitemstring(1,"gubun")) 
ls_saupj = Trim(dw_1.getitemstring(1,"saupj")) 
ls_sdate = Trim(dw_1.getitemstring(1,"nap_date1")) 
ls_edate = Trim(dw_1.getitemstring(1,"nap_date2")) 
ls_ptno = Trim(dw_1.getitemstring(1,"ptno")) 

If trim(ls_ptno) = '' Or isNull(ls_ptno) Then ls_ptno = '%'
If trim(ls_sdate) = '' Or isNull(ls_sdate) Then ls_sdate = '20000101'
If trim(ls_edate) = '' Or isNull(ls_edate) Then ls_edate = '30000101'

dw_print.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate, ls_gubun)

OpenWithParm(w_print_preview, dw_print)
end event

type p_inq from w_inherite`p_inq within w_sm10_0045
integer x = 3890
end type

event p_inq::clicked;call super::clicked;
string ls_gubun, ls_saupj, ls_sdate, ls_edate, ls_ptno

dw_1.accepttext()

ls_gubun = Trim(dw_1.getitemstring(1,"gubun")) 
ls_saupj = Trim(dw_1.getitemstring(1,"saupj")) 
ls_sdate = Trim(dw_1.getitemstring(1,"nap_date1")) 
ls_edate = Trim(dw_1.getitemstring(1,"nap_date2")) 
ls_ptno = Trim(dw_1.getitemstring(1,"ptno")) 

If trim(ls_ptno) = '' Or isNull(ls_ptno) Then ls_ptno = '%'
If trim(ls_sdate) = '' Or isNull(ls_sdate) Then ls_sdate = '19000101'
If trim(ls_edate) = '' Or isNull(ls_edate) Then ls_edate = '29991231'

//dw_insert.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate, ls_gubun)
dw_insert.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate)


end event

type p_del from w_inherite`p_del within w_sm10_0045
boolean visible = false
integer x = 3717
end type

type p_mod from w_inherite`p_mod within w_sm10_0045
integer x = 4064
end type

event p_mod::clicked;call super::clicked;
String ls_itnbr ,ls_cmark,ls_vndcd , ls_comord , ls_saupj
Long i
If dw_insert.AcceptText() < 1 Then Return

If f_msg_update() < 1 Then Return

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장 실패')
	Return
Else
	Commit;
End if


end event

type cb_exit from w_inherite`cb_exit within w_sm10_0045
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0045
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0045
end type

type cb_del from w_inherite`cb_del within w_sm10_0045
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0045
end type

type cb_print from w_inherite`cb_print within w_sm10_0045
end type

type st_1 from w_inherite`st_1 within w_sm10_0045
end type

type cb_can from w_inherite`cb_can within w_sm10_0045
end type

type cb_search from w_inherite`cb_search within w_sm10_0045
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0045
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0045
end type

type dw_1 from datawindow within w_sm10_0045
event ue_enter pbm_dwnprocessenter
integer x = 27
integer y = 32
integer width = 2391
integer height = 272
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0045_menu"
boolean border = false
boolean livescroll = true
end type

event ue_enter;SEND(Handle(This), 256, 9, 0)
Return 1
end event

type dw_print from datawindow within w_sm10_0045
boolean visible = false
integer x = 3415
integer y = 168
integer width = 183
integer height = 128
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0045p"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sm10_0045
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 312
integer width = 4549
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm10_0045
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3616
integer y = 2328
integer width = 878
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_3 from statictext within w_sm10_0045
boolean visible = false
integer x = 3653
integer y = 2480
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "EK, DH"
boolean focusrectangle = false
end type

type e_ek from singlelineedit within w_sm10_0045
boolean visible = false
integer x = 3909
integer y = 2468
integer width = 366
integer height = 64
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean autohscroll = false
boolean hideselection = false
end type

type cb_ek from commandbutton within w_sm10_0045
boolean visible = false
integer x = 4347
integer y = 2468
integer width = 128
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "OK"
end type

event clicked;	Update van_mobis_br Set due_date_boogook = :e_ek.text
	                where (SUBSTR(ORDNO,1,2) = 'EK') or (SUBSTR(ORDNO,1,2) = 'DT');

	If sqlca.sqlcode <> 0 Then
		messageBox('',sqlca.sqlerrtext)
		rollback ;
		Return
	else
		commit;
	end if
	
	p_inq.triggerevent(clicked!)	
end event

type cb_eh from commandbutton within w_sm10_0045
boolean visible = false
integer x = 4347
integer y = 2372
integer width = 128
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "OK"
end type

event clicked;	Update van_mobis_br Set due_date_boogook = :e_eh.text
	                where SUBSTR(ORDNO,1,2) = 'EH';

	If sqlca.sqlcode <> 0 Then
		messageBox('',sqlca.sqlerrtext)
		rollback ;
		Return
	else
		commit;
	end if
	
	p_inq.triggerevent(clicked!)	
end event

type e_eh from singlelineedit within w_sm10_0045
boolean visible = false
integer x = 3909
integer y = 2372
integer width = 366
integer height = 64
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean enabled = false
boolean border = false
boolean autohscroll = false
boolean hideselection = false
end type

type st_2 from statictext within w_sm10_0045
boolean visible = false
integer x = 3653
integer y = 2384
integer width = 183
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "EH"
boolean focusrectangle = false
end type

type st_4 from statictext within w_sm10_0045
boolean visible = false
integer x = 2505
integer y = 80
integer width = 462
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "납품일 일괄지정"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sm10_0045
boolean visible = false
integer x = 2967
integer y = 152
integer width = 206
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "적용"
end type

event clicked;String ls_text

ls_text = LEFT(em_1.Text, 4) + MID(em_1.Text, 6, 2) + RIGHT(em_1.Text, 2)
If Trim(ls_text) = '' OR IsNull(ls_text) OR ls_text = '00000000' Then
	MessageBox('일자확인', '일자를 입력 하십시오.')
	Return
End If

Long   i

For i = 1 To dw_insert.RowCount()
	i = dw_insert.GetSelectedRow(i - 1)
	If i < 1 Then Exit
	dw_insert.SetItem(i, 'due_date_boogook', ls_text)
Next

end event

type em_1 from editmask within w_sm10_0045
boolean visible = false
integer x = 2505
integer y = 156
integer width = 457
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

type dw_prt from datawindow within w_sm10_0045
boolean visible = false
integer x = 3250
integer y = 172
integer width = 146
integer height = 112
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sm10_0045p_minap"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_2 from commandbutton within w_sm10_0045
integer x = 4119
integer y = 188
integer width = 457
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "미납품 출력"
end type

event clicked;string ls_gubun, ls_saupj, ls_sdate, ls_edate, ls_ptno

if dw_insert.rowcount() = 0 then
	Return
end if

ls_gubun = Trim(dw_1.getitemstring(1,"gubun")) 
ls_saupj = Trim(dw_1.getitemstring(1,"saupj")) 
ls_sdate = Trim(dw_1.getitemstring(1,"nap_date1")) 
ls_edate = Trim(dw_1.getitemstring(1,"nap_date2")) 
ls_ptno = Trim(dw_1.getitemstring(1,"ptno")) 

If trim(ls_ptno) = '' Or isNull(ls_ptno) Then ls_ptno = '%'
If trim(ls_sdate) = '' Or isNull(ls_sdate) Then ls_sdate = '19000101'
If trim(ls_edate) = '' Or isNull(ls_edate) Then ls_edate = '29991231'

dw_prt.Retrieve(ls_saupj, ls_ptno, ls_sdate, ls_edate, ls_gubun)

OpenWithParm(w_print_preview, dw_prt)
end event

type p_2 from picture within w_sm10_0045
integer x = 3890
integer y = 164
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

type p_excel from uo_picture within w_sm10_0045
integer x = 3717
integer y = 164
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type rr_3 from roundrectangle within w_sm10_0045
boolean visible = false
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2450
integer y = 32
integer width = 782
integer height = 260
integer cornerheight = 40
integer cornerwidth = 55
end type

