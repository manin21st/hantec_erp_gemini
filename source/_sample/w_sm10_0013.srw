$PBExportHeader$w_sm10_0013.srw
$PBExportComments$납품장소 등록
forward
global type w_sm10_0013 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0013
end type
type dw_list from datawindow within w_sm10_0013
end type
type dw_insert2 from datawindow within w_sm10_0013
end type
type rb_1 from radiobutton within w_sm10_0013
end type
type rb_2 from radiobutton within w_sm10_0013
end type
type rr_1 from roundrectangle within w_sm10_0013
end type
type rr_2 from roundrectangle within w_sm10_0013
end type
type rr_3 from roundrectangle within w_sm10_0013
end type
type rr_4 from roundrectangle within w_sm10_0013
end type
end forward

global type w_sm10_0013 from w_inherite
string title = "납품처 등록"
dw_1 dw_1
dw_list dw_list
dw_insert2 dw_insert2
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_sm10_0013 w_sm10_0013

type variables
String is_factory , is_newits , is_itnbr
end variables

forward prototypes
public function integer wf_init ()
end prototypes

public function integer wf_init ();If rb_1.Checked Then
	dw_insert.Dataobject = "d_sm10_0013_a"
	dw_insert2.Dataobject = "d_sm10_0013_c"
else
	dw_insert.Dataobject = "d_sm10_0013_a2"
	dw_insert2.Dataobject = "d_sm10_0013_c2"
end if

dw_insert.SetTransObject(SQLCA)
dw_insert2.SetTransObject(SQLCA)

return 1


end function

on w_sm10_0013.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.dw_insert2=create dw_insert2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_insert2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_4
end on

on w_sm10_0013.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.dw_insert2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_list.SetTransObject(SQLCA)
dw_list.Retrieve('')

dw_1.InsertRow(0)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0013
integer x = 1458
integer y = 208
integer width = 3127
integer height = 1044
string dataobject = "d_sm10_0013_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
	
	SetNull(gs_code)
	dw_insert2.SetRedraw(false)
	
	If rb_1.Checked then
		is_newits = Trim(This.Object.vndcod[row])
		
		dw_insert2.Retrieve(is_factory , is_newits )
	else
		is_itnbr = Trim(This.Object.itnbr[row])
		
		dw_insert2.Retrieve(is_factory , is_itnbr )
	end if
	
	dw_insert2.SetRedraw(true)
	
END IF
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value

ls_col = Lower(GetColumnName())

ls_value = String(GetText())
row = GetRow()
Choose Case ls_col
	
	Case 'cvcod'
		String ls_cvnas 
		If ls_value > '' Then
			SELECT "VNDMST"."CVNAS2"  
			  INTO :ls_cvnas  
			  FROM "VNDMST"  
			 WHERE ( "VNDMST"."CVCOD" = :ls_value ) AND
					 ( "VNDMST"."CVSTATUS" = '0' ) ;	
			If sqlca.sqlcode <> 0 Then
				f_message_chk(50,'[거래처]')
				Object.cvnas[row] = ''
				SetColumn(ls_col)
				Return 1
			Else
				Object.cvnas[row] = ls_cvnas
			End iF
		Else
			return 1
		End iF
End Choose


end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName() 
	
	/* 거래처 */
	Case "cvcod" 
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
end Choose
		
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0013
integer x = 4443
integer y = 1284
end type

event p_delrow::clicked;call super::clicked;Long i , ll_r , ll_cnt=0

ll_r = dw_insert2.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert2.AcceptText() < 1 Then Return 


For i = ll_r To 1 Step -1
	
	If dw_insert2.IsSelected(i) Then
		dw_insert2.DeleteRow(i)
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	If dw_insert2.Update() < 1 Then
		Rollback;
		MessageBox('저장실패','저장실패')
		Return
	Else
		Commit;
		
	End iF
End IF
end event

type p_addrow from w_inherite`p_addrow within w_sm10_0013
integer x = 4270
integer y = 1284
end type

event p_addrow::clicked;call super::clicked;Long ll_row , ll_max

If is_factory = '' or isNull(is_factory) Then
	MessageBox('확인','공장을 선택하세요.')
	return
end If

If rb_1.Checked Then

	If is_newits = '' or isNull(is_newits) Then
		MessageBox('확인','하치장을 선택되지 않았습니다. ( 신규하치장은 저장후 선택)')
		return
	end If

	ll_row = dw_insert2.InsertRow(0)
	
	dw_insert2.SetFocus()
	dw_insert2.ScrollToRow(ll_row)
	
	dw_insert2.SelectRow(0, FALSE)
	dw_insert2.SelectRow(ll_row,TRUE)

	dw_insert2.Object.plnt[ll_row] = is_factory
	dw_insert2.Object.vndcod[ll_row] = is_newits
	
	dw_insert2.SetColumn('itnbr')
	
else
	
	If is_itnbr = '' or isNull(is_itnbr) Then
		MessageBox('확인','품번을 선택하세요.')
		return
	end If

	ll_row = dw_insert2.InsertRow(0)
	
	dw_insert2.SetFocus()
	dw_insert2.ScrollToRow(ll_row)
	dw_insert2.Object.plnt[ll_row] = is_factory
	dw_insert2.Object.itnbr[ll_row] = is_itnbr
	
	dw_insert2.SetColumn('vndcod')
	
end if 
end event

type p_search from w_inherite`p_search within w_sm10_0013
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0013
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long ll_row , ll_max

If rb_2.Checked Then
	MessageBox('확인','품번등록 상태일때는 사용할 수 없습니다.')
	Return
End If

If is_factory = '' or isNull(is_factory) Then
	MessageBox('확인','공장을 선택하세요.')
	return
end If

ll_row = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_row)
dw_insert.SelectRow(0, FALSE)
dw_insert.SelectRow(ll_row,TRUE)
dw_insert.Object.plnt[ll_row] = is_factory

SetNull(is_newits)

dw_insert.SetColumn('vndcod')

dw_insert2.Reset()


end event

type p_exit from w_inherite`p_exit within w_sm10_0013
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0013
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0013
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0013
integer x = 3575
end type

event p_inq::clicked;call super::clicked;
String ls_name 
Long   ll_f , ll_rcnt

dw_1.AcceptText() 

ls_name = Trim(dw_1.Object.cvnas[1])

If isNull(ls_name) Then ls_name = ''

dw_list.SetRedraw(False)

If dw_list.Retrieve(ls_name) > 0 Then
	
	is_factory = Trim(dw_list.object.rfgub[1])
	
	ll_rcnt = dw_insert.Retrieve(is_factory)
	
	If ll_rcnt < 1 Then 
		dw_insert.Reset()
		dw_insert2.Reset()
		Return
	end if
		
	If rb_1.Checked Then
		
		is_newits = Trim(dw_insert.Object.vndcod[1])
		
		ll_f = dw_insert.Find("vndcod='"+is_newits+"'" , 1 , ll_rcnt )
		
		If ll_f > 0 Then
		
			dw_insert.SelectRow(0, FALSE)
			dw_insert.SelectRow(ll_f,TRUE)
			
		End If
		
		dw_insert2.Retrieve(is_factory , is_newits ) 
		
	else
		
		DataWindowChild dwc_v
		dw_insert2.GetChild("vndcod", dwc_v)
		dwc_v.SetTransObject(SQLCA)
		dwc_v.Retrieve(is_factory)
		
		is_itnbr = Trim(dw_insert.Object.itnbr[1])
		
		ll_f = dw_insert.Find("itnbr='"+is_itnbr+"'" , 1 , ll_rcnt )
		
		If ll_f > 0 Then
		
			dw_insert.SelectRow(0, FALSE)
			dw_insert.SelectRow(ll_f,TRUE)
			
		End If
		
		dw_insert2.Retrieve(is_factory , is_itnbr ) 
		
		
	end if
		
	
else
	dw_insert.Reset()
	dw_insert2.Reset()
		
End if
	
dw_list.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0013
end type

event p_del::clicked;call super::clicked;Long i , ll_r , ll_cnt=0

String ls_factory  , ls_newits 

If rb_2.Checked Then
	MessageBox('확인','품번등록 상태일때는 사용할 수 없습니다.')
	Return
End If

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

dw_insert2.Reset()

For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
		
		ls_factory = Trim(dw_insert.object.plnt[i])
		ls_newits  = Trim(dw_insert.object.vndcod[i])
		
		Delete From stock_napum_item where vndcod = :ls_newits and plnt = :ls_factory ;
		
		If sqlca.sqlcode <> 0 Then
			MessageBox('확인','삭제 실패'+ sqlca.sqlerrText )
			Rollback;
			Return
		End If
		
		dw_insert.DeleteRow(i)
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('저장실패','저장실패')
		Return
	Else
		Commit;
		
	End iF
End IF
end event

type p_mod from w_inherite`p_mod within w_sm10_0013
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0  , ll_seq
String ls_new ,ls_null , ls_seq ,ls_vndcod , ls_itnbr , ls_factory ,ls_yebi1 , ls_cvcod , ls_vndnam

Long ll_rcnt , ll_f

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_update() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

SetNull(ls_null)

If rb_1.Checked Then

	For i = ll_r To 1 Step -1
		ls_new = Trim(dw_insert.Object.is_new[i])
		
		If ls_new = 'Y' Then
			ls_vndcod = Trim(dw_insert.Object.vndcod[i])
			
			If ls_vndcod = '' Or isNull(ls_vndcod) Then
				MessageBox('확인',String(i)+' 행의 납품처코드가 필요합니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('vndcod')
				Return
			End IF
			
			If is_factory = '' Or isNull(is_factory) Then
				MessageBox('확인',String(i)+' 행의 공장코드가 필요합니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('plnt')
				Return
			End IF
			
			Select Count(*) Into :ll_cnt
			  from STOCK_NAPUM_HEAD
			 where  plnt = :is_factory and vndcod = :ls_vndcod ;
			 
			If ll_cnt > 0 Then
				MessageBox('확인',String(i)+' 행의 해당 납품처코드은 이미 등록된 코드 입니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('vndcod')
				Return
			End If
		End If
		
	Next
	
	ll_r = dw_insert2.RowCount()
	If dw_insert2.AcceptText() < 1 Then Return 
	
	For i = ll_r To 1 Step -1
		ls_new = Trim(dw_insert2.Object.is_new[i])
		
		If ls_new = 'Y' Then
			
			ls_vndcod = Trim(dw_insert2.Object.vndcod[i])
			ls_itnbr = Trim(dw_insert2.Object.itnbr[i])
			ls_factory = Trim(dw_insert2.Object.plnt[i])
			
			If ls_itnbr = '' Or isNull(ls_itnbr) Then
				MessageBox('확인',String(i)+' 행의 품번이 필요합니다.')
				dw_insert2.ScrollToRow(i)
				dw_insert2.SetFocus()
				dw_insert2.SetColumn('itnbr')
				Return
			End IF
			
			If ls_vndcod = '' Or isNull(ls_vndcod) Then
				MessageBox('확인',String(i)+' 행의 납품처코드가 필요합니다.')
				dw_insert2.ScrollToRow(i)
				Return
			End IF
			
			If ls_factory = '' Or isNull(ls_factory) Then
				MessageBox('확인',String(i)+' 행의 공장코드가 필요합니다.')
				dw_insert2.ScrollToRow(i)
				Return
			End IF
			ll_cnt = 0 
			Select Count(*) Into :ll_cnt
			  from STOCK_NAPUM_ITEM
			 where plnt = :ls_factory 
				and vndcod = :ls_vndcod 
				and itnbr = :ls_itnbr;
			 
			If ll_cnt > 0 Then
				MessageBox('확인',String(i)+' 행의 해당 품번은 이미 등록된 코드 입니다.')
				dw_insert2.ScrollToRow(i)
				dw_insert2.SetFocus()
				dw_insert2.SetColumn('itnbr')
				Return
			End If
			

		End If
		
	Next
	
	dw_insert2.AcceptText()

	If dw_insert2.Update() < 1 Then
		Rollback;
		MessageBox('저장실패1','저장실패1')
		Return
	
	End iF
	
	dw_insert.AcceptText()
	
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('저장실패2','저장실패2')
		Return
	Else
		Commit;
		
		ll_rcnt = dw_insert.Retrieve(is_factory)
		ll_f = dw_insert.Find("vndcod='"+is_newits+"'" , 1 , ll_rcnt )
			
		If ll_f > 0 Then
		
			dw_insert.SelectRow(0, FALSE)
			dw_insert.SelectRow(ll_f,TRUE)
			
			dw_insert.ScrollToRow(ll_f)
			
		End If
		
		dw_insert2.Retrieve(is_factory , is_newits )
	
	End iF

else
	
	ll_r = dw_insert2.RowCount()
	If dw_insert2.AcceptText() < 1 Then Return 
	
	For i = ll_r To 1 Step -1
		ls_new = Trim(dw_insert2.Object.is_new[i])
		
		If ls_new = 'Y' Then
			
			ls_vndcod = Trim(dw_insert2.Object.vndcod[i])
			ls_itnbr = Trim(dw_insert2.Object.itnbr[i])
			ls_factory = Trim(dw_insert2.Object.plnt[i])
			
			If ls_itnbr = '' Or isNull(ls_itnbr) Then
				MessageBox('확인',String(i)+' 행의 품번이 필요합니다.')
				dw_insert2.ScrollToRow(i)
				dw_insert2.SetFocus()
				dw_insert2.SetColumn('itnbr')
				Return
			End IF
			
			If ls_vndcod = '' Or isNull(ls_vndcod) Then
				MessageBox('확인',String(i)+' 행의 납품처코드가 필요합니다.')
				dw_insert2.ScrollToRow(i)
				Return
			End IF
			
			If ls_factory = '' Or isNull(ls_factory) Then
				MessageBox('확인',String(i)+' 행의 공장코드가 필요합니다.')
				dw_insert2.ScrollToRow(i)
				Return
			End IF
			
			ll_cnt = 0
			Select Count(*) Into :ll_cnt
			  from STOCK_NAPUM_ITEM
			 where plnt = :ls_factory 
				and vndcod = :ls_vndcod 
				and itnbr = :ls_itnbr;
			 
			If ll_cnt > 0 Then
				MessageBox('확인',String(i)+' 행의 해당 품번은 이미 등록된 코드 입니다.')
				dw_insert2.ScrollToRow(i)
				dw_insert2.SetFocus()
				dw_insert2.SetColumn('itnbr')
				Return
			End If
			
			ll_cnt = 0 
			Select Count(*) Into :ll_cnt
			  from STOCK_NAPUM_HEAD
			 where plnt = :ls_factory 
				and vndcod = :ls_vndcod  ;
				
			ls_yebi1 =  Trim(dw_insert2.Object.yebi1[i])
			ls_cvcod =  Trim(dw_insert2.Object.cvcod[i])
			ls_vndnam =  Trim(dw_insert2.Object.vndnam[i])
			If ll_cnt = 0 Then
				Insert into stock_napum_head ( plnt , vndcod , yebi1 , cvcod ) 
				                      values ( :ls_factory , :ls_vndcod , :ls_yebi1 , :ls_cvcod ) ;
				If sqlca.sqlnrows = 0 Then
					messageBox('확인','저장실패3'+sqlca.sqlerrText)
					rollback;
					return
				end if
				
			else
				update stock_napum_head set yebi1 = :ls_yebi1 ,
				                            cvcod = :ls_cvcod
											where plnt = :ls_factory
											  and vndcod = :ls_vndcod ;
											  
				If sqlca.sqlnrows = 0 Then
					messageBox('확인','저장실패3'+sqlca.sqlerrText)
					rollback;
					return
				end if
					
			end if
			 
			
			
		End If
		
	Next
	
	dw_insert2.AcceptText()

	If dw_insert2.Update() < 1 Then
		Rollback;
		MessageBox('저장실패1','저장실패1')
		Return

	Else
		Commit;
		
		ll_rcnt = dw_insert.Retrieve(is_factory)
		ll_f = dw_insert.Find("itnbr='"+is_itnbr+"'" , 1 , ll_rcnt )
			
		If ll_f > 0 Then
		
			dw_insert.SelectRow(0, FALSE)
			dw_insert.SelectRow(ll_f,TRUE)
			
			dw_insert.ScrollToRow(ll_f)
			
		End If
		
		dw_insert2.Retrieve(is_factory , is_itnbr )
	
	End iF

	
end if
	
	

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0013
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0013
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0013
end type

type cb_del from w_inherite`cb_del within w_sm10_0013
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0013
end type

type cb_print from w_inherite`cb_print within w_sm10_0013
end type

type st_1 from w_inherite`st_1 within w_sm10_0013
end type

type cb_can from w_inherite`cb_can within w_sm10_0013
end type

type cb_search from w_inherite`cb_search within w_sm10_0013
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0013
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0013
end type

type dw_1 from datawindow within w_sm10_0013
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 16
integer width = 2043
integer height = 172
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0013_1"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;p_inq.TriggerEvent(Clicked!)
end event

type dw_list from datawindow within w_sm10_0013
integer x = 41
integer y = 208
integer width = 1349
integer height = 2052
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0013_B"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
	
	Long ll_f , ll_rcnt
	
	SetNull(gs_code)
	dw_insert.SetRedraw(false)
	is_factory = Trim(This.Object.rfgub[row])
	
	ll_rcnt = dw_insert.Retrieve(is_factory)
	
	If ll_rcnt > 0 Then
		
		If rb_1.Checked Then
	
			is_newits = Trim(dw_insert.Object.vndcod[1])
			
			ll_f = dw_insert.Find("vndcod='"+is_newits+"'" , 1 , ll_rcnt )
			
			If ll_f > 0 Then
			
				dw_insert.SelectRow(0, FALSE)
				dw_insert.SelectRow(ll_f,TRUE)
				
			End If
			
			dw_insert2.Retrieve(is_factory , is_newits ) 
			
		else
			DataWindowChild dwc_v
			dw_insert2.GetChild("vndcod", dwc_v)
			dwc_v.SetTransObject(SQLCA)
			dwc_v.Retrieve(is_factory)
			
			is_itnbr = Trim(dw_insert.Object.itnbr[1])
			
			ll_f = dw_insert.Find("itnbr='"+is_itnbr+"'" , 1 , ll_rcnt )
			
			If ll_f > 0 Then
			
				dw_insert.SelectRow(0, FALSE)
				dw_insert.SelectRow(ll_f,TRUE)
				
			End If
			
			dw_insert2.Retrieve(is_factory , is_itnbr ) 
			

		end if
			
		
	else
		dw_insert.Reset()
		dw_insert2.Reset()
			
	End if
	
	dw_insert.SetRedraw(true)
END IF
end event

type dw_insert2 from datawindow within w_sm10_0013
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1449
integer y = 1456
integer width = 3141
integer height = 800
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0013_c"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event itemchanged;String ls_col , ls_value ,ls_null  
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
			Object.itemas_ispec[row] 		= ls_null
			Object.itemas_jijil[row]      = ls_null
			
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
			Object.itemas_ispec[row] 		= ls_null
			Object.itemas_jijil[row]      = ls_null
			SetColumn("itnbr")
			Return 1
		END IF

		Object.itemas_itdsc[row]    	= ls_itdsc
		Object.itemas_ispec[row] 		= ls_ispec
		Object.itemas_jijil[row]      = ls_jijil
	
	Case	"yebi2" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.yebi2[row]    	= ls_null
			Return
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
			Object.yebi2[row]    	= ls_null
			SetColumn("yebi2")
			Return 1
		END IF

END Choose


end event

event rbuttondown;SetNull(gs_code)
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
			if i > row then p_addrow.triggerevent("clicked")
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next

	Case "yebi2"
		gs_gubun = '1'
		Open(w_itemas_popup3)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'yebi2', gs_code)
	
END Choose
end event

event clicked;f_multi_select(this)
end event

type rb_1 from radiobutton within w_sm10_0013
integer x = 2135
integer y = 72
integer width = 311
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "하치장"
boolean checked = true
end type

event clicked;wf_init()

p_inq.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_sm10_0013
integer x = 2542
integer y = 72
integer width = 311
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "품번"
end type

event clicked;wf_init()

p_inq.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_sm10_0013
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1435
integer y = 200
integer width = 3173
integer height = 1072
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm10_0013
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 200
integer width = 1385
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm10_0013
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1435
integer y = 1444
integer width = 3173
integer height = 828
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_sm10_0013
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2071
integer y = 20
integer width = 859
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

