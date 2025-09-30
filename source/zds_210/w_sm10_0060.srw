$PBExportHeader$w_sm10_0060.srw
$PBExportComments$납품처재고 등록
forward
global type w_sm10_0060 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0060
end type
type cb_1 from commandbutton within w_sm10_0060
end type
type rr_1 from roundrectangle within w_sm10_0060
end type
end forward

global type w_sm10_0060 from w_inherite
string title = "납품처 계획잔량 등록"
dw_1 dw_1
cb_1 cb_1
rr_1 rr_1
end type
global w_sm10_0060 w_sm10_0060

type variables
STring is_vndcod
end variables

forward prototypes
public function integer wf_itdsc (integer arg_row)
end prototypes

public function integer wf_itdsc (integer arg_row);string ls_value, ls_itdsc, ls_ispec, ls_jijil

	
ls_value = dw_insert.getItemString(arg_row, 'itnbr') 
	
SELECT A.ITDSC , 
		 A.ISPEC ,
		 A.JIJIL
  INTO :ls_itdsc, 
		 :ls_ispec, 		     
		 :ls_jijil
  FROM ITEMAS A 
 WHERE A.ITNBR = :ls_value
	AND A.USEYN = 0 ;

IF SQLCA.SQLCODE <> 0 THEN
	f_message_chk(33,'[품번]')
	
	dw_insert.Object.itdsc[arg_row]    	= ''
	dw_insert.Object.ispec[arg_row]    	= ''
	
	dw_insert.SetColumn("itnbr")
	Return 1
END IF

dw_insert.Object.itdsc[arg_row]    	= ls_itdsc
dw_insert.Object.ispec[arg_row]    	= ls_ispec

return 0
end function

on w_sm10_0060.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_sm10_0060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

end event

type dw_insert from w_inherite`dw_insert within w_sm10_0060
integer x = 46
integer y = 208
integer width = 4530
integer height = 2048
integer taborder = 10
string dataobject = "d_sm10_0060_c"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;String ls_col , ls_value , ls_null , ls_name 
Int li_cnt

row = GetRow()
SetNull(ls_null)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ls_col = GetColumnName() 
ls_value = GetText() 

Choose Case ls_col
	
	Case	"factory" 
		
		select rfna1 into :ls_name
		  from reffpf
		 where rfcod = '2A'
		   and rfgub = :ls_value ;
		
		If sqlca.sqlcode <> 0 Then
			Object.factory_nm[row]    	= ls_null
			return 1
		end IF
		
		Object.factory_nm[row]    	= ls_name

		
		
	Case	"itnbr" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.itnbr[row]    	= ls_null
			Object.itdsc[row]    	= ls_null
			
			Return 1
		END IF
	
      Post	wf_itdsc(row);
		

END Choose




end event

event dw_insert::rbuttondown;call super::rbuttondown;
SetNull(gs_gubun)
sle_msg.text = ''

If row < 1 Then Return
str_code lst_code
Long i , ll_i = 0
String ls_factory ,ls_factory_nm

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
			
			if i = row then
				ls_factory = Trim(object.factory[row])
				ls_factory_nm = Trim(object.factory_nm[row])
			end If
			
			if i > row then p_ins.triggerevent("clicked")
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.SetItem(i,"factory",ls_factory)
			this.SetItem(i,"factory_nm",ls_factory_nm )
			post wf_itdsc(i)
			
		Next
	

END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;//f_multi_select(this)

this.setrow(row)
this.trigger event rowfocuschanged(row)

end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.SelectRow(0, FALSE)
if currentrow > 0 then
	this.SelectRow(currentrow, TRUE)
else
	return
end if

end event

type p_delrow from w_inherite`p_delrow within w_sm10_0060
boolean visible = false
integer x = 3328
integer y = 0
integer taborder = 30
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0060
boolean visible = false
integer x = 3287
integer taborder = 20
end type

type p_search from w_inherite`p_search within w_sm10_0060
boolean visible = false
integer x = 3118
integer y = 28
integer taborder = 40
string picturename = "C:\erpman\image\검색_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\검색_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\검색_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm10_0060
integer x = 3749
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;Long ll_row , ll_max

String ls_name ,ls_itnbr, ls_gbn, ls_cvcod

dw_1.AcceptText() 


ll_row = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_row)


end event

type p_exit from w_inherite`p_exit within w_sm10_0060
integer taborder = 0
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0060
integer taborder = 0
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_insert.Reset()
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)
//
//p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0060
boolean visible = false
integer taborder = 50
end type

type p_inq from w_inherite`p_inq within w_sm10_0060
integer x = 3575
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;
String ls_name ,ls_itnbr, ls_gbn

dw_1.AcceptText() 

ls_name 	= Trim(dw_1.Object.plant[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])

If ls_name = '.' or ls_name = '' or isNull(ls_name) Then ls_name = '%'
If ls_itnbr = '' Or isNull(ls_itnbr) Then 
	ls_itnbr = '%'
else
	ls_itnbr = ls_itnbr + '%'
end if

dw_insert.Retrieve(ls_name, ls_itnbr)

end event

type p_del from w_inherite`p_del within w_sm10_0060
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Long i , ll_r , ll_cnt=0

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
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

type p_mod from w_inherite`p_mod within w_sm10_0060
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0  , ll_seq
String ls_new ,ls_null , ls_seq ,ls_itnbr ,ls_factory, ls_gbn

dec ld_temp_qty

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_update() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

SetNull(ls_null)

ll_r = dw_insert.rowcount()

For i = 1 To ll_r 
	ls_new = Trim(dw_insert.Object.is_new[i])
	
	If ls_new = 'Y' Then
		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
	  
		If ls_itnbr = '' Or isNull(ls_itnbr) Then
			MessageBox('확인',String(i)+' 행의 품번이 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('itnbr')
			Return
		End IF
		
		ls_factory = Trim(dw_insert.Object.factory[i])
		
		If ls_factory = '' Or isNull(ls_factory) Then
			
			MessageBox('확인',String(i)+' 행의 납품장소코드가 필요합니다.')
	
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('factory')
			Return
		End IF
		
     
		Select Count(*) Into :ll_cnt
		  from ITEMAS
		 where ITNBR = :ls_itnbr ;
		 
		If ll_cnt <= 0 Then
			MessageBox('확인',String(i)+' 행의 해당 품번은 등록되지 않은 품번입니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('itnbr')
			Return
		End If
		
		ll_cnt = 0

		Select Count(*) Into :ll_cnt
		  from STOCK_NAPUM
		 where VNDCOD = :ls_factory and ITNBR = :ls_itnbr ;
	
		If ll_cnt > 0 Then
			MessageBox('확인',String(i)+' 행의 해당 품번은 이미 등록된 코드 입니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('itnbr')
			Return
		End If
		
		
	End If
	
	dw_insert.object.jego_qty[i] = dw_insert.object.jego_qty_new[i]

Next

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('저장실패','저장실패')
	Return
Else
	Commit;
	p_inq.TriggerEvent(Clicked!)
End iF

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0060
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0060
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0060
end type

type cb_del from w_inherite`cb_del within w_sm10_0060
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0060
end type

type cb_print from w_inherite`cb_print within w_sm10_0060
end type

type st_1 from w_inherite`st_1 within w_sm10_0060
end type

type cb_can from w_inherite`cb_can within w_sm10_0060
end type

type cb_search from w_inherite`cb_search within w_sm10_0060
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0060
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0060
end type

type dw_1 from datawindow within w_sm10_0060
event ue_keydown pbm_dwnprocessenter
integer x = 18
integer y = 16
integer width = 3003
integer height = 172
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0060_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Choose Case GetColumnName()
	Case "plant"
		String ls_plant
		
		ls_plant = GetText()
		If ls_plant = '.' Then 
			ls_plant = '%'
		End If
			
		dw_insert.Retrieve(gs_code , '' )

	Case 'gbn'
		If GetText() = '1' Then
			dw_insert.DataObject = 'd_sm10_0060_B'
		Else
			dw_insert.DataObject = 'd_sm10_0060_C'
		End If
		dw_insert.SetTransObject(sqlca)
		
End Choose

p_inq.TriggerEvent(Clicked!)

end event

type cb_1 from commandbutton within w_sm10_0060
boolean visible = false
integer x = 3058
integer y = 40
integer width = 402
integer height = 120
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "이월생성"
end type

event clicked;Open(w_ewol)
end event

type rr_1 from roundrectangle within w_sm10_0060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 4558
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

