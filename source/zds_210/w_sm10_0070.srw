$PBExportHeader$w_sm10_0070.srw
$PBExportComments$납품처재고 등록
forward
global type w_sm10_0070 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0070
end type
type cbx_1 from checkbox within w_sm10_0070
end type
type p_1 from uo_picture within w_sm10_0070
end type
type st_2 from statictext within w_sm10_0070
end type
type rr_1 from roundrectangle within w_sm10_0070
end type
end forward

global type w_sm10_0070 from w_inherite
string title = "납품처 실물재고(생성)"
dw_1 dw_1
cbx_1 cbx_1
p_1 p_1
st_2 st_2
rr_1 rr_1
end type
global w_sm10_0070 w_sm10_0070

type variables
STring is_vndcod
end variables

on w_sm10_0070.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.p_1=create p_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_sm10_0070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)

dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

dw_1.Object.sdate[1] = is_today


String ls_maxdt
Select Max(crt_date) Into :ls_maxdt
  From stock_napum_jego
  where saupj = :gs_code ;
  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인','최종 생성일자를 찾을 수 없습니다.')
	Return
End If
	
dw_1.object.edate[1] =ls_maxdt

end event

type dw_insert from w_inherite`dw_insert within w_sm10_0070
integer x = 50
integer y = 372
integer width = 4549
integer height = 1888
string dataobject = "d_sm10_0070_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;//If row <= 0 then
//	this.SelectRow(0,False)
//ELSE
//	this.SelectRow(0, FALSE)
//	this.SelectRow(row,TRUE)
//END IF

f_multi_select(dw_insert)
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col , ls_value ,ls_null  
String ls_itnbr , ls_itdsc ,  ls_ispec, ls_jijil
Int li_cnt

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
			Object.itdsc[row]    	= ls_null
			
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
		   AND A.USEYN = 0 ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[품번]')
			
			Object.itdsc[row]    	= ls_null
			
			SetColumn("itnbr")
			Return 1
		END IF

		Object.itdsc[row]    	= ls_itdsc
		

END Choose




end event

event dw_insert::rbuttondown;call super::rbuttondown;//
//SetNull(gs_gubun)
//sle_msg.text = ''
//
//If row < 1 Then Return
//str_code lst_code
//Long i , ll_i = 0
//
//this.AcceptText()
//
//Choose Case GetcolumnName() 
//	Case "itnbr"
//		gs_gubun = '1'
//		
//		Open(w_itemas_multi_popup)
//
//		lst_code = Message.PowerObjectParm
//		IF isValid(lst_code) = False Then Return 
//		If UpperBound(lst_code.code) < 1 Then Return 
//		
//		For i = row To UpperBound(lst_code.code) + row - 1
//			ll_i++
//			if i > row then p_ins.triggerevent("clicked")
//			this.SetItem(i,"itnbr",lst_code.code[ll_i])
//			this.TriggerEvent("itemchanged")
//			
//		Next
//	
//
//END Choose
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0070
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0070
boolean visible = false
end type

type p_search from w_inherite`p_search within w_sm10_0070
boolean visible = false
integer x = 3099
integer y = 32
string picturename = "C:\erpman\image\button_dn.gif"
end type

type p_ins from w_inherite`p_ins within w_sm10_0070
boolean visible = false
integer x = 3922
end type

event p_ins::clicked;call super::clicked;Long ll_r
ll_r = dw_insert.InsertRow(0)

dw_insert.object.saupj[ll_r] = Trim(dw_1.object.saupj[1])
dw_insert.object.crt_date[ll_r] = Trim(dw_1.object.edate[1])

dw_insert.ScrollToRow(ll_r)
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_sm10_0070
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0070
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

dw_1.Object.sdate[1] = is_today


String ls_maxdt
Select Max(crt_date) Into :ls_maxdt
  From stock_napum_jego
  where saupj = :gs_code ;
  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인','최종 생성일자를 찾을 수 없습니다.')
	Return
End If
	
dw_1.object.edate[1] =ls_maxdt

dw_1.SetRedraw(True)

dw_insert.Reset()



end event

type p_print from w_inherite`p_print within w_sm10_0070
boolean visible = false
integer x = 3383
integer y = 20
end type

type p_inq from w_inherite`p_inq within w_sm10_0070
integer x = 3749
end type

event p_inq::clicked;call super::clicked;
String ls_saupj , ls_sdate , ls_plant , ls_itnbr , ls_filter

dw_1.AcceptText() 

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.sdate[1])
ls_plant = Trim(dw_1.Object.plant[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])

If ls_plant = '' Or isNull(ls_plant) or ls_plant = '.' Then ls_plant = '%'
If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = '%'

dw_insert.SetRedraw(False)

String ls_maxdt
Select Max(crt_date) Into :ls_maxdt
  From stock_napum_jego
  where saupj = :ls_saupj ;
  
If sqlca.sqlcode <> 0 Then
	MessageBox('확인','최종 생성일자를 찾을 수 없습니다.')
	Return
End If
	
dw_1.object.edate[1] =ls_maxdt

If dw_insert.Retrieve(ls_saupj ,ls_plant ,ls_itnbr+'%' ,ls_sdate ) > 0 Then

	If cbx_1.Checked Then
		dw_insert.SetFilter("sil_qty > 0 Or na_qty > 0 ")
		dw_insert.Filter()
		dw_insert.SetFilter("")
	End If
End If

dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0070
end type

event p_del::clicked;call super::clicked;If dw_insert.AcceptText() < 1 Then Return

Long i , ll_rcnt , ll_cnt

ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then Return

If f_msg_Delete() < 1 Then Return

ll_cnt = 0

For i = ll_rcnt To 1 Step -1
	
	If dw_insert.isSelected(i) Then
		dw_insert.DeleteRow(i)
		ll_cnt++
	End iF
	
Next 

If dw_insert.Update() < 1 Then
	MessageBox('확인',sqlca.sqlerrText )
	Rollback;
	Return
Else
	Commit ;
//	f_mdi_msg(string(ll_cnt) + "건이 삭제 되었습니다.")
End iF


end event

type p_mod from w_inherite`p_mod within w_sm10_0070
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0  , ll_seq
String ls_new ,ls_null , ls_seq ,ls_itnbr ,ls_sdate , ls_saupj , ls_plant 

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_update() < 1 Then Return
If dw_1.AcceptText() < 1 Then Return 
If dw_insert.AcceptText() < 1 Then Return 

SetNull(ls_null)

dw_1.AcceptText()

ls_sdate = Trim(dw_1.Object.sdate[1])
ls_saupj = Trim(dw_1.Object.saupj[1])

For i = ll_r To 1 Step -1
	
	ls_plant = Trim(dw_insert.Object.vndcod[i])
	ls_itnbr = Trim(dw_insert.Object.itnbr[i])
	
	If ls_plant = '' or isNull(ls_itnbr) Then
		MessageBox('확인','공장을 등록하세요')
		dw_insert.SetFocus()
		dw_insert.SetColumn("vndcod")
		Return
	End IF
	
	If ls_itnbr = '' or isNull(ls_itnbr) Then
		MessageBox('확인','품번을 등록하세요')
		dw_insert.SetFocus()
		dw_insert.SetColumn("itnbr")
		Return
	End IF
	
	
	If Trim(dw_insert.Object.crt_date[i]) = ls_sdate Then
		dw_insert.Object.jego_qty[i] = dw_insert.Object.com_jego_qty[i]
		dw_insert.Object.dd_qty[i] = dw_insert.Object.jego_qty_temp[i]
		ll_cnt++
	End iF
		
Next

If ll_cnt < 1 Then
	MessageBox('확인','기준일자에 실물재고생성 한 후 재고조정 가능합니다.')
	Return
End iF

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

type cb_exit from w_inherite`cb_exit within w_sm10_0070
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0070
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0070
end type

type cb_del from w_inherite`cb_del within w_sm10_0070
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0070
end type

type cb_print from w_inherite`cb_print within w_sm10_0070
end type

type st_1 from w_inherite`st_1 within w_sm10_0070
end type

type cb_can from w_inherite`cb_can within w_sm10_0070
end type

type cb_search from w_inherite`cb_search within w_sm10_0070
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0070
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0070
end type

type dw_1 from datawindow within w_sm10_0070
event ue_keydown pbm_dwnprocessenter
integer x = 18
integer y = 16
integer width = 3429
integer height = 260
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0070_1"
boolean border = false
boolean livescroll = true
end type

type cbx_1 from checkbox within w_sm10_0070
integer x = 2569
integer y = 160
integer width = 489
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
string text = "전일실적 有"
end type

event clicked;If dw_insert.RowCount() < 1 Then Return
If cbx_1.Checked Then
	dw_insert.SetFilter("sil_qty > 0 Or na_qty > 0 ")

Else
	dw_insert.SetFilter("")
End If

dw_insert.Filter()
dw_insert.SetFilter("")
end event

type p_1 from uo_picture within w_sm10_0070
integer x = 3470
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;Setnull(gs_code)

String ls_crt_date , ls_sdate , ls_saupj
Long   ll_cnt 

dw_1.AcceptText()

ls_saupj =  Trim(dw_1.Object.saupj[1])
gs_code = Trim(dw_1.Object.sdate[1])

Select Count(*) Into :ll_cnt
  From van_hkcd2
 where substr(doccode,3,8) >= :gs_code
   and custcd = fun_get_reffpf_value('AD',:ls_saupj,'4') ;
 
If ll_cnt <1 Then
	MessageBox('확인','기준일자에 해당하는 D2 계획이 접수되지 않았습니다. D2 계획접수 후 실행하세요')
	Return
End iF

open(w_sm10_0070_1)

//dw_insert.Reset()

p_inq.TriggerEvent(Clicked!)
end event

type st_2 from statictext within w_sm10_0070
integer x = 50
integer y = 292
integer width = 2528
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "* 납품실적과 모기업실적은 ( 최종 생성일자 + 1 ) ~~ 기준일자  까지의 합계를 계산한다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sm10_0070
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 364
integer width = 4571
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

