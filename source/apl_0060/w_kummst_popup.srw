$PBExportHeader$w_kummst_popup.srw
$PBExportComments$*금형 마스터 조회 선택(F1 KEY)
forward
global type w_kummst_popup from w_inherite_popup
end type
type rb_1 from radiobutton within w_kummst_popup
end type
type rb_2 from radiobutton within w_kummst_popup
end type
type gb_1 from groupbox within w_kummst_popup
end type
type rr_2 from roundrectangle within w_kummst_popup
end type
end forward

global type w_kummst_popup from w_inherite_popup
integer x = 357
integer y = 236
integer width = 2185
integer height = 1816
string title = "금형/치공구 조회"
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_2 rr_2
end type
global w_kummst_popup w_kummst_popup

type variables
string is_itcls
end variables

on w_kummst_popup.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kummst_popup.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)
dw_jogun.SetFocus()

//dw_jogun.setitem(1, 'ittyp', gs_gubun)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_kummst_popup
integer x = 0
integer y = 32
integer width = 1335
integer height = 196
string dataobject = "d_kummst_popup_h"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'econo' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
//	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[ECO No]')
		this.SetItem(1,'econo', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_kummst_popup
integer x = 1989
integer y = 28
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_kummst_popup
integer x = 1641
integer y = 28
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_kumno, ls_gubun

if dw_jogun.AcceptText() = -1 then return 

ls_kumno = dw_jogun.GetItemString(1,'kumno')

IF IsNull(ls_kumno) Or ls_kumno = "" Then
	ls_kumno = '%' + ls_kumno +'%'
End If
//sold_sql = " SELECT   ECOMST.ECO_NO,  " + &  
//				" ECOMST.ITNBR,  " + &  
//				" ECOMST.RFGUB,  " + &  
//				" REFFPF.RFNA1,  " + &  
//				" REFFPF.RFNA3,  " + &  
//				" ECOMST.RECEIPT_DATE,  " + &  
//				" ECOMST.ECO_DATE  " + &  
//				" FROM ECOMST,  " + &  
//				" 		REFFPF  " + &  
//				" WHERE ECOMST.RFGUB = REFFPF.RFGUB  " + &  
//				" AND	 REFFPF.RFGUB = '01'  "
//
//swhere_clause = ""
//
//IF ls_econo <> "" THEN
//	ls_econo = '%' + ls_econo +'%'
//	swhere_clause = swhere_clause + "AND ECO_NO LIKE '"+ls_econo+"'"
//END IF
//
//snew_sql = sold_sql + swhere_clause
//dw_1.SetSqlSelect(snew_sql)

If rb_1.Checked = True Then
	ls_gubun = 'M'
ElseIf rb_2.Checked = true Then
	ls_gubun = 'J'
End If

If dw_1.Retrieve(ls_kumno, ls_gubun ) = 0 Then
	f_message_chk(50, '금형 관리번호 ')
	return
End If
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_kummst_popup
integer x = 1815
integer y = 28
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF

gs_code = dw_1.GetItemString(ll_Row, "kumno")
gs_codename = dw_1.GetItemString(ll_row,"kumname")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_kummst_popup
integer x = 27
integer y = 248
integer width = 2126
integer height = 1452
integer taborder = 100
string dataobject = "d_kummst_popup_d"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

p_choose.TriggerEvent(Clicked!)
end event

type sle_2 from w_inherite_popup`sle_2 within w_kummst_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_kummst_popup
end type

type cb_return from w_inherite_popup`cb_return within w_kummst_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_kummst_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_kummst_popup
end type

type st_1 from w_inherite_popup`st_1 within w_kummst_popup
end type

type rb_1 from radiobutton within w_kummst_popup
integer x = 859
integer y = 52
integer width = 320
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "금  형"
boolean checked = true
end type

type rb_2 from radiobutton within w_kummst_popup
integer x = 859
integer y = 112
integer width = 320
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "치공구"
end type

type gb_1 from groupbox within w_kummst_popup
boolean visible = false
integer x = 814
integer y = 12
integer width = 416
integer height = 164
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type rr_2 from roundrectangle within w_kummst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 244
integer width = 2149
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

