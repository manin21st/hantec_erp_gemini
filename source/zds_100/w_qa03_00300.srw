$PBExportHeader$w_qa03_00300.srw
$PBExportComments$고객 claim 정보등록
forward
global type w_qa03_00300 from w_inherite
end type
type cb_1 from commandbutton within w_qa03_00300
end type
type dw_ip from datawindow within w_qa03_00300
end type
type dw_list from datawindow within w_qa03_00300
end type
type rr_3 from roundrectangle within w_qa03_00300
end type
end forward

global type w_qa03_00300 from w_inherite
integer height = 2480
string title = "고객 CLAIM 정보등록"
cb_1 cb_1
dw_ip dw_ip
dw_list dw_list
rr_3 rr_3
end type
global w_qa03_00300 w_qa03_00300

forward prototypes
public function integer wf_required_chk ()
public function integer wf_init ()
public function integer wf_select_chk ()
end prototypes

public function integer wf_required_chk ();If dw_insert.AcceptText() < 1 Then Return -1
If dw_insert.RowCount() < 1 Then Return -1

String ls_saupj , ls_itnbr , ls_cvcod ,ls_cvgub ,ls_insert_dt 
Long   ll_row

//ls_saupj = Trim(dw_insert.Object.saupj[1])
ls_itnbr = Trim(dw_insert.Object.itnbr[1])
ls_cvcod = Trim(dw_insert.Object.cvcod[1])
ls_cvgub   = Trim(dw_insert.Object.cvgub[1])
ls_insert_dt   = Trim(dw_insert.Object.insert_dt[1])

//If ls_saupj = '' Or isNull(ls_saupj) Then
//	f_message_chk(1400 , '[사업장]')
//	dw_insert.SetColumn("saupj")
//	Return -1
//End If

If ls_itnbr = '' Or isNull(ls_itnbr) Then
	f_message_chk(33 , '[품번]')
	dw_insert.SetColumn("itnbr")
	Return -1
End If
	
If ls_cvcod = '' Or isNull(ls_cvcod) Then
	f_message_chk(33 , '[거래처코드]')
	dw_insert.SetColumn("cvcod")
	Return -1
End If

If ls_cvgub = '' Or isNull(ls_cvgub) Then
	f_message_chk(33 , '[거래처구분]')
	dw_insert.SetColumn("cvgub")
	Return -1
End If


If ls_insert_dt = '' Or isNull(ls_insert_dt) Or f_datechk(ls_insert_dt) < 0  Then
	f_message_chk(35 , '[의뢰일자]')
	dw_insert.SetColumn("insert_dt")
	Return -1
End If




return 1
end function

public function integer wf_init ();String ls_today
ls_today = f_today()

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
//dw_insert.Object.accept_dt[1] = ls_today
dw_insert.SetRedraw(True)

Return 1
end function

public function integer wf_select_chk ();//If dw_ip.AcceptText() < 1 Then Return -1
//If dw_ip.RowCount() < 1 Then Return -1
//
//String ls_date_st , ls_date_ft ,ls_gubun , ls_saupj ,ls_cvcod1,ls_cvcod
//Long   ll_row
//
////ls_date_st = Trim(dw_ip.Object.sdate[1])
////ls_date_ft = Trim(dw_ip.Object.edate[1])
////ls_saupj   = Trim(dw_ip.Object.saupj[1])
////ls_gubun   = Trim(dw_ip.Object.cvgub[1])
//
//ls_date_st = Trim(dw_ip.getitemstring(1,'sdate'))
//ls_date_ft = Trim(dw_ip.getitemstring(1,'edate'))
//ls_cvcod   = Trim(dw_ip.getitemstring(1,'cvcod'))
//ls_cvcod1   = Trim(dw_ip.getitemstring(1,'cvcod1'))
//
//
//If ls_date_st = '' Or isNull(ls_date_st) Or f_datechk(ls_date_st) < 0  Then
//	f_message_chk(35 , '[접수일자]')
//	dw_ip.SetColumn("sdate")
//	Return -1
//End If
//
//If ls_date_ft = '' Or isNull(ls_date_ft) Or f_datechk(ls_date_ft) < 0  Then
//	f_message_chk(35 , '[접수일자]')
//	dw_ip.SetColumn("edate")
//	Return -1
//End If
//
////If ls_saupj = '' Or isNull(ls_saupj) Then
////	f_message_chk(1400 , '[사업장]')
////	dw_ip.SetColumn("saupj")
////	Return -1
////End If
return 1
end function

on w_qa03_00300.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.rr_3
end on

on w_qa03_00300.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

String ls_today

ls_today = f_today()

wf_init()


dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.Object.sdate[1] = left(ls_today,4) + '01'
dw_ip.Object.edate[1] = left(ls_today,6)





end event

type dw_insert from w_inherite`dw_insert within w_qa03_00300
integer x = 37
integer y = 1764
integer width = 4567
integer height = 516
integer taborder = 20
string dataobject = "d_qa03_00300_3"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String ls_col ,ls_cod, ls_null, ls_nam
Long   ll_cnt ,ll_row

isnull(ls_null)

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case 'cvcod'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'compute_0004',ls_null)
			Return 
		End If
		
		select cvnas into :ls_nam 
		  from vndmst
	 	 where cvcod = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'compute_0004',ls_nam)
		else
			f_message_chk(33, "[업체코드]")
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'compute_0004',ls_null)
			return 1
		end if
	
End Choose
 
end event

event dw_insert::rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')
	Case 'cvcod'
		gs_code = this.GetText()
		open(w_vndmst_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.cvcod[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')
End Choose

end event

event dw_insert::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event dw_insert::ue_pressenter;If Lower(GetColumnName()) ="bad_txt" Then
	Return
Else
	Send(Handle(this),256,9,0)
	Return 1
End if
end event

type p_delrow from w_inherite`p_delrow within w_qa03_00300
boolean visible = false
integer x = 3109
integer y = 324
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa03_00300
boolean visible = false
integer x = 2935
integer y = 324
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa03_00300
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa03_00300
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa03_00300
integer x = 4407
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_qa03_00300
integer x = 4233
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
wf_init()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"

p_del.Enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
ib_any_typing = False //입력필드 변경여부 No


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within w_qa03_00300
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa03_00300
integer x = 3712
end type

event p_inq::clicked;call super::clicked;String ls_date_st , ls_date_ft ,ls_cvcod ,ls_saupj,ls_cvcod1
Long   ll_row

If wf_select_chk() = -1 Then Return

//ls_date_st = Trim(dw_ip.Object.sdate[1])
//ls_date_ft = Trim(dw_ip.Object.edate[1])
//ls_gubun   = Trim(dw_ip.Object.cvgub[1])
//ls_saupj   = Trim(dw_ip.Object.saupj[1])

ls_date_st = Trim(dw_ip.getitemstring(1,'sdate'))
ls_date_ft = Trim(dw_ip.getitemstring(1,'edate'))
ls_cvcod   = Trim(dw_ip.getitemstring(1,'cvcod'))
ls_cvcod1   = Trim(dw_ip.getitemstring(1,'cvcod1'))

if  ls_cvcod = '' or isnull(ls_cvcod) then ls_cvcod = '...'
if   ls_cvcod1 = '' or isnull(ls_cvcod1) then ls_cvcod1 = 'zzz'

ll_row = dw_list.Retrieve(ls_date_st, ls_date_ft,ls_cvcod ,ls_cvcod1)

If ll_row > 0 Then
	wf_init()
	ib_any_typing = False //입력필드 변경여부 No
Else
	f_message_chk(50, "")
End If


		

end event

type p_del from w_inherite`p_del within w_qa03_00300
integer x = 4059
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;If dw_insert.RowCount() < 1 Then Return



String ls_no , ls_result
Long   ll_fr


dw_insert.AcceptText()

IF MessageBox("확인", "삭제하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

ll_fr =dw_list.getrow()
dw_list.DeleteRow(ll_fr)
dw_list.Update()





end event

type p_mod from w_inherite`p_mod within w_qa03_00300
integer x = 3886
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)
If dw_insert.AcceptText() = -1 Then Return -1
If dw_insert.RowCount() < 1 Then Return

If f_msg_update() = -1 Then Return  //저장 Yes/No ?
dw_insert.Object.sabu[1] = gs_sabu

if dw_insert.update() <> 1 Then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
	Return
Else
	Commit ;
	p_inq.TriggerEvent(Clicked!)
End If

ib_any_typing = False //입력필드 변경여부 No

SetPointer(Arrow!)



//
//String ls_today ,ls_new , ls_seq , ls_no
//
//ls_new = Trim(dw_insert.Object.is_new[1])
//If ls_new = 'Y' Then
//	
//	ls_today = f_today()
//	
//	SetNull(ls_seq)
//	
//	Select Max(SubStr(qanew_no,9,4)) Into :ls_seq
//	  From qc_sampl
//	  Where substr(qanew_no,1,8) = :ls_today ;
//	  
//	If sqlca.sqlcode <> 0 Then
//		ls_no = ls_today + '0001'
//	End if
//	If isNull(ls_seq) Or ls_seq = '' Then
//		ls_no = ls_today + '0001'
//	Else
//		ls_no = ls_today + String(Long(ls_seq) + 1 ,'0000')
//	End If
//	
//	dw_insert.Object.qanew_no[1] = ls_no
//	dw_insert.Object.saupj[1] = gs_saupj
//	dw_insert.Object.cvgub[1] = '2'
//
//End If
//	
//If wf_required_chk() < 1 then Return
//
//If dw_insert.Update() <> 1 Then
//	ROLLBACK;
//	f_message_chk(32,'[자료저장 실패]') 
//	Return
//Else
//	Commit ;
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//ib_any_typing = False //입력필드 변경여부 No
//
//SetPointer(Arrow!)
// 
end event

type cb_exit from w_inherite`cb_exit within w_qa03_00300
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa03_00300
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa03_00300
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa03_00300
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa03_00300
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa03_00300
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qa03_00300
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa03_00300
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa03_00300
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qa03_00300
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa03_00300
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa03_00300
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa03_00300
end type

type gb_button2 from w_inherite`gb_button2 within w_qa03_00300
end type

type cb_1 from commandbutton within w_qa03_00300
boolean visible = false
integer x = 2267
integer y = 2344
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM사용내역 조회"
end type

type dw_ip from datawindow within w_qa03_00300
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 24
integer width = 3474
integer height = 164
integer taborder = 90
string title = "none"
string dataobject = "d_qa03_00300_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)

END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;String ls_col ,ls_cod , ls_cvnas , ls_nam , ls_null
Long   ll_cnt ,ll_row
setnull(ls_null)
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col

		
 
	Case 'cvcod'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
			Return 
		End If
		
		select cvnas into :ls_nam 
		  from vndmst
	 	 where cvcod = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvnas',ls_nam)
		else
			f_message_chk(33, "[업체코드]")
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
			return 1
		end if

		
	Case 'cvcod1'
		If ls_cod = '' Or isNull(ls_cod) Then
			this.setitem(1,'cvcod1',ls_null)
			this.setitem(1,'cvnas1',ls_null)
			Return 
		End If
		
		select cvnas into :ls_nam 
		  from vndmst
	 	 where cvcod = :ls_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvnas1',ls_nam)
		else
			f_message_chk(33, "[업체코드]")
			this.setitem(1,'cvcod1',ls_null)
			this.setitem(1,'cvnas1',ls_null)
			return 1
		end if		
		
		
		
		
	
End Choose
 
end event

event rbuttondown;String ls_col

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
ls_col = Lower(GetColumnName())

Choose Case ls_col
	
	Case 'cvcod' 
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
		
			Case 'cvcod1' 
		open(w_vndmst_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)
	
	
	
End Choose
end event

type dw_list from datawindow within w_qa03_00300
integer x = 69
integer y = 212
integer width = 4494
integer height = 1520
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa03_00300_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;//If row < 1 Then Return
//
//AcceptText()
//
//String ls_no
//
//ls_no = Trim(Object.qanew_no[row])
//
//If ls_no = '' Or isNull(ls_no) Then Return
//
//dw_insert.SetRedraw(False)
//
//If dw_insert.Retrieve(ls_no) < 1 Then
//	dw_insert.Reset()
//	dw_insert.InsertRow(0)
//	p_del.Enabled = False
//	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
//Else
//	p_del.Enabled = True
//	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
//End If
//
//dw_insert.SetRedraw(True)
//	
//
end event

event clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
dw_list.accepttext()
string syymm, scvcod

syymm = dw_list.getitemstring(row,'yymm')
scvcod = dw_list.getitemstring(row,'cvcod')
	If dw_insert.Retrieve(syymm,scvcod) < 1 Then
		dw_insert.Reset()
		dw_insert.InsertRow(0)
		p_del.Enabled = False
		p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	Else
		p_del.Enabled = True
		p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
	End If
END IF
end event

type rr_3 from roundrectangle within w_qa03_00300
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 200
integer width = 4526
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

