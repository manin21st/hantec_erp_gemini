$PBExportHeader$w_sm10_0025_spec.srw
$PBExportComments$고객사별 작업사양품번 등록(17.06.18-한텍)
forward
global type w_sm10_0025_spec from w_inherite
end type
type dw_1 from datawindow within w_sm10_0025_spec
end type
type dw_list from datawindow within w_sm10_0025_spec
end type
type rb_1 from radiobutton within w_sm10_0025_spec
end type
type rb_2 from radiobutton within w_sm10_0025_spec
end type
type p_excel from uo_picture within w_sm10_0025_spec
end type
type dw_excel from datawindow within w_sm10_0025_spec
end type
type gb_1 from groupbox within w_sm10_0025_spec
end type
type rr_1 from roundrectangle within w_sm10_0025_spec
end type
type rr_2 from roundrectangle within w_sm10_0025_spec
end type
end forward

global type w_sm10_0025_spec from w_inherite
integer width = 4672
integer height = 4008
string title = "작업사양 품번 등록"
dw_1 dw_1
dw_list dw_list
rb_1 rb_1
rb_2 rb_2
p_excel p_excel
dw_excel dw_excel
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sm10_0025_spec w_sm10_0025_spec

type variables
String is_cvcod  ,is_itnbr , is_seq

end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();

//If rb_1.Checked Then
//	dw_1.DataObject = 'd_sm10_0025_1'
//	dw_list.DataObject = 'd_sm10_0025_a'
//	dw_insert.DataObject = 'd_sm10_0025_b'
//ElseIf rb_2.Checked Then
//	dw_1.DataObject = 'd_sm10_0025_2'
//	dw_list.DataObject = 'd_sm10_0025_a2'
//	dw_insert.DataObject = 'd_sm10_0025_b2'
//End If

dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

SetNull(is_cvcod)
SetNull(is_seq)
SetNull(is_itnbr)

dw_1.InsertRow(0)
dw_1.SetColumn(1)
dw_1.SetFocus()


end subroutine

on w_sm10_0025_spec.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rb_1=create rb_1
this.rb_2=create rb_2
this.p_excel=create p_excel
this.dw_excel=create dw_excel
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.p_excel
this.Control[iCurrent+6]=this.dw_excel
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_sm10_0025_spec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.p_excel)
destroy(this.dw_excel)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_excel.SetTransObject(SQLCA)

rb_1.Checked = True

wf_init()

If rb_1.Checked Then
	dw_list.Retrieve('')
End if

end event

type dw_insert from w_inherite`dw_insert within w_sm10_0025_spec
integer x = 2592
integer y = 208
integer width = 2011
integer height = 2032
string dataobject = "d_sm10_0025_spec_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::clicked;call super::clicked;
f_multi_select(dw_insert)
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col , ls_value ,ls_null  
String ls_itnbr , ls_itdsc ,ls_ispec , ls_jijil ,ls_carname 
Int li_cnt 
Long ll_cnt

row = GetRow()
SetNull(ls_null)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ls_col = GetColumnName() 
ls_value = GetText() 

Choose Case ls_col
	Case	"itnbr" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.itnbr[row]    	= ls_null
			Object.itemas_itdsc[row]    	= ls_null
		
			Return 1
		END IF
	
		SELECT A.ITDSC , 
		       A.ISPEC ,
		       A.JIJIL
		  INTO :ls_itdsc, 
		       :ls_ispec, 		     
		       :ls_jijil
		  FROM ITEMAS A 
		 WHERE A.ITNBR = :ls_value
		   AND (A.USEYN = 0 OR A.USEYN = 1) ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[품번]')
			
			Object.itemas_itdsc[row]    	= ls_null
			Object.bunbr[row]    	= ls_null
			SetColumn("itnbr")
			Return 1
		END IF
		
		Object.bunbr[row]    	= ls_value
		Object.itemas_itdsc[row]    	= ls_itdsc

	Case	"cvcod" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.cvcod[row]    	= ls_null
			Object.cvnas[row] 		= ls_null
			
			Return 1
		END IF
	
		SELECT cvnas  into :ls_carname
		  FROM vndmst
		 Where cvcod = :ls_value ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[거래처]')
			
			Object.cvocd[row]    	= ls_null
			Object.cvnas[row] 		= ls_null
			
			SetColumn("cvcod")
			Return 1
		END IF


		Object.cvnas[row]    	= ls_carname
	
END Choose


end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''

If row < 1 Then Return
str_code lst_code
Long i , ll_i = 0
Long ll_seq , ll_cnt=0

String  ls_null
		
SetNull(ls_null)
	
dw_1.AcceptText()
this.AcceptText()

Choose Case GetcolumnName() 
	Case "itnbr"
		gs_gubun = '1'
		
		Open(w_itemas_multi_popup)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_ins.triggerevent("clicked")
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.SetItem(i,"bunbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next

		
	Case "cvcod"
	
		gs_code = ''
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
		
		this.SetItem(row,"cvcod",gs_code)
		this.SetItem(row,"cvnas",gs_codename)
	
END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0025_spec
integer x = 3918
integer width = 183
end type

event p_delrow::clicked;call super::clicked;String ls_new , ls_plnt  , ls_itnbr, ls_sayang
Long i , ll_r , ll_cnt=0

ll_r = dw_insert.GetRow()

If ll_r < 1 Then
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
    Return
End IF
//If f_msg_delete() < 1 Then Return
	
dw_insert.DeleteRow(ll_r)

end event

type p_addrow from w_inherite`p_addrow within w_sm10_0025_spec
integer x = 3739
end type

event p_addrow::clicked;call super::clicked;Long ll_row , ll_r , i

If is_itnbr = '' Or isNull(is_itnbr) Then
	MessageBox('확인','품번을 선택 후 거래처-관리품번를 추가할 수 있습니다.')
	Return
End If

ll_row = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_row)
dw_insert.Object.itnbr[ll_row] = is_itnbr
dw_insert.Object.bunbr[ll_row] = is_itnbr

end event

type p_search from w_inherite`p_search within w_sm10_0025_spec
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0025_spec
boolean visible = false
integer x = 2624
integer y = 28
end type

event p_ins::clicked;call super::clicked;Long ll_row , ll_r , i

If is_itnbr = '' Or isNull(is_itnbr) Then
	MessageBox('확인','품번을 선택 후 거래처-관리품번를 추가할 수 있습니다.')
	Return
End If

ll_row = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_row)
dw_insert.Object.itnbr[ll_row] = is_itnbr
dw_insert.Object.bunbr[ll_row] = is_itnbr


end event

type p_exit from w_inherite`p_exit within w_sm10_0025_spec
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0025_spec
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0025_spec
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0025_spec
integer x = 3561
end type

event p_inq::clicked;call super::clicked;
String ls_name ,ls_code , ls_itnbr ,ls_itdsc

dw_1.AcceptText() 
If rb_1.Checked Then
	
	ls_name = Trim(dw_1.Object.itnbr[1])
	
	If isNull(ls_name) Then ls_name = ''
	
	dw_list.SetRedraw(False)
	
	If dw_list.Retrieve(ls_name) > 0 Then
		
		is_itnbr = Trim(dw_list.Object.itnbr[1])
		dw_insert.Retrieve( is_itnbr )
		
	End If
	dw_list.SetRedraw(True)
ElseIf rb_2.Checked Then

	ls_name = Trim(dw_1.Object.cvnas[1])
	
	dw_list.SetRedraw(False)
	
	If dw_list.Retrieve(ls_name) > 0 Then
		
		is_cvcod = Trim(dw_list.Object.cvcod[1])
		dw_insert.Retrieve( is_cvcod )
	
	End If
	dw_list.SetRedraw(True)

End If
end event

type p_del from w_inherite`p_del within w_sm10_0025_spec
boolean visible = false
integer x = 3141
integer y = 0
end type

event p_del::clicked;call super::clicked;String ls_new , ls_plnt  , ls_itnbr, ls_sayang
Long i , ll_r , ll_cnt=0

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
//If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return

For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
		ls_new = dw_insert.Object.is_new[i]
		If ls_new = 'N' Then
			ls_itnbr   = Trim(dw_insert.Object.itnbr[i])
			ls_plnt = Trim(dw_insert.Object.plnt[i])
			ls_sayang = Trim(dw_insert.Object.sayang[i])
			
			Delete From itmspec
			Where itnbr = :ls_itnbr
				and plnt = :ls_plnt
				and sayang = :ls_sayang;
										
			If sqlca.sqlcode <> 0 Then
				MessageBox('확인',sqlca.sqlerrText )
				Rollback;
				Return
			End iF
		End if
			
		dw_insert.DeleteRow(i)
		
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	Commit ;
	//dw_insert.Retrieve( is_itnbr)
End IF

end event

type p_mod from w_inherite`p_mod within w_sm10_0025_spec
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0 ,ll_cnt2 = 0 ,ll_rtn=0  , ll_f ,ii
String ls_new ,ls_null , ls_itnbr ,ls_bunbr,ls,ls_plnt,ls_chek, ls_sayang

If dw_insert.AcceptText() < 1 Then Return 
//ll_r = dw_insert.RowCount()
//If ll_r < 1 Then Return

SetNull(ls_null)

For i = 1 To ll_r
	
	ls_new = Trim(dw_insert.Object.is_new[i])
	ls_itnbr = Trim(dw_insert.Object.itnbr[i])
	ls_plnt = Trim(dw_insert.Object.plnt[i])
	ls_sayang = Trim(dw_insert.Object.sayang[i])
	ls_bunbr = Trim(dw_insert.Object.bunbr[i])

	If ls_new = 'Y' Then
		
		If ls_itnbr = '' Or isNull(ls_itnbr) Then
			MessageBox('확인',String(i)+' 행의 품번이 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn(1)
			Return
		End IF
		
		If ls_plnt = '' Or isNull(ls_plnt) Then
			MessageBox('확인',String(i)+' 행의 공장코드가 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn(1)
			Return
		End IF
		
		If ls_sayang = '' Or isNull(ls_sayang) Then
			MessageBox('확인',String(i)+' 행의 작업사양이 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn(1)
			Return
		End IF

		If ls_bunbr = '' Or isNull(ls_bunbr) Then
			MessageBox('확인',String(i)+' 행의 관리품번이 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn(2)
			Return
		End IF
		
		ii = i + 1
		If ii < ll_r Then
			ll_f = dw_insert.Find("plnt = '"+ls_plnt+"' and itnbr='"+ls_itnbr+"' and bunbr='"+ls_bunbr+"' and sayang='"+ls_sayang+"'", ii, ll_r )
		
			If ll_f > 0 Then
				MessageBox('확인',String(ll_f)+'행에 중복된 데이타가 존재합니다.')
				dw_insert.ScrollToRow(ll_f)
				dw_insert.SetFocus()
				dw_insert.SetColumn(1)
				Return
			End IF
		End If
		
		Select Count(*) Into :ll_cnt
		  from itmspec
		where itnbr = :ls_itnbr
			and plnt = :ls_plnt
		    and sayang = :ls_sayang ;
		 
		If ll_cnt > 0 Then
			MessageBox('확인',String(i)+' 행은 이미 등록된 관리품번입니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('itnbr')
			Rollback;
			Return
		End If
	
	End If

Next


If f_msg_update() < 1 Then Return

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('저장실패','저장실패')
	Return
Else
	Commit;
	
End iF

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0025_spec
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0025_spec
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0025_spec
end type

type cb_del from w_inherite`cb_del within w_sm10_0025_spec
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0025_spec
end type

type cb_print from w_inherite`cb_print within w_sm10_0025_spec
end type

type st_1 from w_inherite`st_1 within w_sm10_0025_spec
end type

type cb_can from w_inherite`cb_can within w_sm10_0025_spec
end type

type cb_search from w_inherite`cb_search within w_sm10_0025_spec
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0025_spec
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0025_spec
end type

type dw_1 from datawindow within w_sm10_0025_spec
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 16
integer width = 2007
integer height = 172
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0025_1"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;

p_inq.TriggerEvent(Clicked!)
end event

event itemchanged;str_code lst_code
Long i , ll_i = 0 , ll_row
String ls_carcode , ls_seq , ls_null
String ls_scd8a , ls_scd8b, ls_scd8c, ls_scd8d, ls_scd8e, ls_scd8f ,ls_scd8g , ls_scd8h, ls_scd8i
Long ll_seq , ll_cnt=0

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''


ll_row = dw_insert.RowCount() + 1

SetNull(ls_null)
	
If getColumnName() = "carcode" Then
	
End If
	
end event

event itemerror;return 1
end event

type dw_list from datawindow within w_sm10_0025_spec
integer x = 41
integer y = 208
integer width = 2501
integer height = 2032
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0025_spec_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;
If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
	
	SetNull(gs_code)
	dw_insert.SetRedraw(false)
	is_itnbr = Trim(This.Object.itnbr[row])
	dw_insert.Retrieve( is_itnbr )
	dw_insert.SetRedraw(true)
END IF
end event

type rb_1 from radiobutton within w_sm10_0025_spec
boolean visible = false
integer x = 2139
integer y = 72
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품번"
boolean checked = true
end type

event clicked;wf_init()
end event

type rb_2 from radiobutton within w_sm10_0025_spec
boolean visible = false
integer x = 2327
integer y = 60
integer width = 293
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "거래처"
end type

event clicked;wf_init()
end event

type p_excel from uo_picture within w_sm10_0025_spec
boolean visible = false
integer x = 3241
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

Long i
String ls_carcode

If dw_1.AcceptText() < 1 Then Return


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
	

 	If dw_insert.SaveAsAscii(ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type dw_excel from datawindow within w_sm10_0025_spec
boolean visible = false
integer x = 2171
integer y = 2260
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0017_excel"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_sm10_0025_spec
boolean visible = false
integer x = 2057
integer y = 4
integer width = 526
integer height = 172
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sm10_0025_spec
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2587
integer y = 200
integer width = 2021
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm10_0025_spec
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 200
integer width = 2523
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

