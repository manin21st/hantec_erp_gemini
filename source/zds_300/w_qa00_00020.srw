$PBExportHeader$w_qa00_00020.srw
$PBExportComments$** 품질 정기검사 품목등록
forward
global type w_qa00_00020 from w_inherite
end type
type cb_1 from commandbutton within w_qa00_00020
end type
type dw_ip from datawindow within w_qa00_00020
end type
type rr_3 from roundrectangle within w_qa00_00020
end type
end forward

global type w_qa00_00020 from w_inherite
integer height = 2480
string title = "정기검사 품목 등록"
cb_1 cb_1
dw_ip dw_ip
rr_3 rr_3
end type
global w_qa00_00020 w_qa00_00020

type variables

end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_init ()
end prototypes

public function integer wf_required_chk ();If dw_ip.AcceptText() = -1 Then Return -1
If dw_insert.AcceptText() = -1 Then Return -1
//If dw_insert.RowCount() < 1 Then Return -1

String ls_ittyp , ls_cvcod ,ls_itnbr , ls_date_st ,ls_date_ft ,ls_expt_dt 
String ls_col ,ls_str, ls_place, ls_yyyy
Long   i ,ii,ll_cnt


ls_ittyp = Trim(dw_ip.Object.gubun[1])
ls_cvcod = Trim(dw_ip.Object.cvcod[1])
ls_place = Trim(dw_ip.Object.grpno1[1])
ls_yyyy = Trim(dw_ip.Object.yyyy[1])

	if isnull(ls_cvcod) or ls_cvcod = '' then
		MessageBox('확인',"거래처를 지정하세요.")
		dw_ip.setcolumn('cvcod')
		dw_ip.setfocus()
		Return -1
	End If

//if ls_ittyp = '1' then	
	if isnull(ls_place) or ls_place = '' then
		MessageBox('확인',"공장을 지정하세요.")
		dw_ip.setcolumn('place')
		dw_ip.setfocus()
		Return -1
	End If
//end if

	if isnull(ls_yyyy) or ls_yyyy = '' then
		MessageBox('확인',"기준년도를 지정하세요.")
		dw_ip.setcolumn('yyyy')
		dw_ip.setfocus()
		Return -1
	End If

For i =1 To dw_insert.RowCount()

	ls_itnbr = Trim(dw_insert.Object.itnbr[i])	
	If ls_itnbr = '' Or isNull(ls_itnbr) Then
		MessageBox('확인',"품번코드가 없습니다.")
		Return -1
	End If
	
//	ll_cnt = 0 
//	For ii = 1 To 12
//		ls_str = dw_insert.GetItemString(i,"mon_"+String(ii,"00"))
//		If ls_str = "Y" Then
//			ll_cnt++
//		End If
//	Next
//	If ll_cnt = 0 Then
//		MessageBox('확인',String(i) +' 행에 선택된 정기 검사월이 없습니다.')
//		dw_insert.SetFocus()
//		dw_insert.ScrollToRow(i)
//		dw_insert.SetColumn(1)
//		Return -1
//	End If
	
//	dw_insert.Object.cvcod[i] = ls_cvcod
	
	ls_ittyp = Trim(dw_insert.Object.ittyp[i])	
	
	ls_place = Trim(dw_insert.Object.place[i])	
	If ls_place = '' Or isNull(ls_place) Then
		MessageBox('확인',"공장을 입력하세요.")
		Return -1
	End If

	dw_insert.Object.yyyy[i] = ls_yyyy

Next

return 1
end function

public function integer wf_init ();dw_ip.Enabled = True

dw_ip.SetRedraw(False)
dw_ip.Reset()

dw_ip.insertrow(0)
dw_ip.setitem(1, 'yyyy', left(f_today(),4))
dw_ip.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()

dw_insert.SetRedraw(True)

Return 1
end function

on w_qa00_00020.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.rr_3
end on

on w_qa00_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_qa00_00020
integer x = 64
integer y = 208
integer width = 4485
integer height = 2072
integer taborder = 20
string dataobject = "d_qa00_00020_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String ls_col ,ls_cod, ls_cvcod, sqcgub
Long   ll_cnt ,ll_row

ib_any_typing = True //입력필드 변경여부 Yes

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())
ls_cvcod = dw_ip.getitemstring(1,'cvcod')

Choose Case ls_col
	
	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil ,ls_ittyp ,ls_ittyp_t
		
		Select itdsc , ispec , jijil ,ittyp
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil , :ls_ittyp 
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itdsc[GetRow()] = ls_itdsc	
		This.Object.ittyp[GetRow()] = ls_ittyp	
		
		select qcgub into :sqcgub from danmst
		 where itnbr = :ls_cod and cvcod = :ls_cvcod and rownum = 1 ;
		if sqlca.sqlcode = 0 then
			This.Object.qcgub[GetRow()] = sqcgub
		end if
		
//		if ls_ittyp <> '1' then
//			This.Object.place[GetRow()] = '이원정공'
//		end if

		
End Choose
 
end event

event dw_insert::clicked;call super::clicked;If Row <= 0 then
	dw_insert.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

END IF
end event

event dw_insert::rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = "itnbr" THEN
	
	Open(w_itemas_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then return
	this.SetItem(row, "itnbr", gs_Code)
	this.TriggerEvent("itemchanged")	
END IF
end event

event dw_insert::buttonclicked;call super::buttonclicked;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
	Case 'b_1'
		gs_code     = Trim(Object.cvcod[row])
		gs_codename = Trim(Object.itnbr[row])
		gs_gubun		= Trim(Object.place[row])
		
		If isNull(gs_code) = False And isNull(gs_codename) = False Then
			Open(w_qa00_00020_popup)
		End If
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_qa00_00020
integer x = 3886
integer y = 32
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;If dw_insert.RowCount() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return

String ls_new 
Long   ll_row

ll_row = dw_insert.GetRow()

If ll_row < 1 Then Return

//ls_new = Trim(dw_insert.Object.is_new[ll_row])
//If ls_new = 'Y' Then
	If f_msg_delete() < 1 Then Return

	dw_insert.DeleteRow(ll_row)
//End If

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '자료 삭제 중 오류가 발생했습니다.')
	Return
End If
end event

type p_addrow from w_inherite`p_addrow within w_qa00_00020
integer x = 3712
integer y = 32
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Long ll_r
String ls_cvcod , ls_place, ls_yyyy

If dw_insert.GetRow() > 0 Then
	ll_r = dw_insert.InsertRow(dw_insert.GetRow() + 1 )	
Else
	ll_r = dw_insert.InsertRow(0)
End If

If dw_ip.AcceptText() = -1 Then Return -1

ls_cvcod = Trim(dw_ip.Object.cvcod[1])
ls_place = Trim(dw_ip.Object.grpno1[1])
ls_yyyy  = Trim(dw_ip.Object.yyyy[1])

	if isnull(ls_cvcod) or ls_cvcod = '' then
		MessageBox('확인',"거래처를 지정하세요.")
		dw_ip.setcolumn('cvcod')
		dw_ip.setfocus()
		Return -1
	End If

//if ls_ittyp = '1' then	
	if isnull(ls_place) or ls_place = '' then
		MessageBox('확인',"공장을 지정하세요.")
		dw_ip.setcolumn('grpno1')
		dw_ip.setfocus()
		Return -1
	End If
//end if

	if isnull(ls_yyyy) or ls_yyyy = '' then
		MessageBox('확인',"기준년도를 지정하세요.")
		dw_ip.setcolumn('yyyy')
		dw_ip.setfocus()
		Return -1
	End If


dw_insert.setitem(ll_r,'saupj',gs_saupj)
dw_insert.setitem(ll_r,'cvcod',ls_cvcod)
dw_insert.setitem(ll_r,'place',ls_place)
dw_insert.setitem(ll_r,'yyyy',ls_yyyy)
dw_insert.ScrollToRow(ll_r)
dw_insert.SetColumn(1)
end event

type p_search from w_inherite`p_search within w_qa00_00020
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa00_00020
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa00_00020
integer x = 4407
integer y = 32
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_qa00_00020
integer x = 4233
integer y = 32
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
wf_init()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"

ib_any_typing = False //입력필드 변경여부 No


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within w_qa00_00020
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa00_00020
integer x = 3538
integer y = 32
end type

event p_inq::clicked;call super::clicked;String ls_cvcod , ls_gubun ,ls_today , ls_itnbr ,ls_itdsc ,ls_qcgub, ls_place, ls_useyn, ls_plnt, ls_eoemp, ls_carcode, ls_yyyy
Long   ll_row ,ll_r

dw_ip.AcceptText()

ls_cvcod   = Trim(dw_ip.Object.cvcod[1])
ls_gubun   = Trim(dw_ip.Object.gubun[1])
ls_place   = Trim(dw_ip.Object.grpno1[1])
ls_eoemp   = Trim(dw_ip.Object.eoemp[1])
ls_carcode = Trim(dw_ip.Object.carcode[1])
ls_yyyy = Trim(dw_ip.Object.yyyy[1])


If ls_cvcod = '' Or isNull(ls_cvcod) Then
	f_message_chk(33,"[업체코드]")
	dw_ip.SetColumn("cvcod")
	dw_ip.SetFocus()
	Return
End If

select cvstatus into :ls_useyn from vndmst
 where cvcod = :ls_cvcod ;
if ls_useyn <> '0' then
	messagebox('확인','거래중인 업체가 아닙니다.~n해당업체의 거래상태를 확인하세요')
	dw_ip.SetColumn("cvcod")
	dw_ip.SetFocus()
	Return
End If

if isnull(ls_gubun) or ls_gubun = '' then ls_gubun = '%'

//if ls_gubun = '1' then
	If ls_place = '' Or isNull(ls_place) Then
		f_message_chk(33,"[공장]")
		dw_ip.SetFocus()
		dw_ip.SetColumn("grpno1")
		Return
	End If
//end if
//if ls_place = '.' then ls_place = '%'

	if isnull(ls_yyyy) or ls_yyyy = '' then
		MessageBox('확인',"기준년도를 지정하세요.")
		dw_ip.setcolumn('yyyy')
		dw_ip.setfocus()
		Return
	End If

If Trim(ls_eoemp) = '' OR IsNull(ls_eoemp) Then ls_eoemp = '%'

If Trim(ls_carcode) = '' OR IsNull(ls_carcode) Then ls_carcode = '%'

/////////////////////////////////////////////////////////////////////
integer				i
datawindowchild	dwc

i = dw_insert.getchild('place',dwc)
dwc.settransobject(sqlca)
dwc.retrieve('%')

ll_row = dw_insert.Retrieve(ls_gubun ,ls_cvcod,ls_place, ls_eoemp, ls_carcode, ls_yyyy)

/////////////////////////////////////////////////////////////////////

Long ll_chk

If ll_row > 0 Then
//	dw_ip.Enabled = False
	ib_any_typing = False //입력필드 변경여부 No
Else
//	ls_place = Trim(dw_ip.Object.grpno1[1])
	
	If MessageBox('확인','해당 거래처에는 정기검사 대상 품번이 없습니다.'+ &
	             '~n~r~n~r해당 거래처의 정기검사 품번을 신규 생성 하시겠습니까?' , &
							    Question!, OKCancel!, 2) = 2 Then 
//		dw_ip.Enabled = True
		ib_any_typing = True
		Return
	Else
		
//		dw_ip.Enabled = False
		ib_any_typing = False
		
		ls_today = f_today()
	
		If ls_gubun = '1'  Then
			SELECT COUNT('X')
			  INTO :ll_chk
			  FROM ITEMAS           A,
			       STOCK_NAPUM_ITEM B
			 WHERE A.ITNBR = B.ITNBR
			   AND NVL(A.USEYN, '0') = '0'
				AND A.ITTYP LIKE :ls_gubun
				AND B.PLNT  LIKE DECODE(:ls_place, '.', '%', :ls_place)
				AND FUN_GET_REFFPF_VALUE('2A', B.PLNT, '1') = :ls_cvcod ;
			
			If ll_chk > 0 Then
			
				DECLARE qc_jugi CURSOR FOR 
	
				SELECT DISTINCT X.ITNBR AS ITNBR,
						 X.ITDSC AS ITDSC,
						 X.QCGUB AS QCGUB,
						 FUN_GET_REFFPF_VALUE('2A',Y.PLNT,'1') AS CVCOD,
						 Y.PLNT AS PLNT
				  FROM ITEMAS X , STOCK_NAPUM_ITEM Y
				 WHERE X.ITNBR = Y.ITNBR
					AND NVL(X.USEYN,'0') = '0'
					AND X.ITTYP LIKE :ls_gubun
					AND Y.PLNT LIKE DECODE(:ls_place, '.', '%', :ls_place)
					AND FUN_GET_REFFPF_VALUE('2A',Y.PLNT,'1') = :ls_cvcod ;
				
				Open qc_jugi ;
				
				Do While True
					
					FETCH qc_jugi Into :ls_itnbr, :ls_itdsc, :ls_qcgub, :ls_cvcod, :ls_plnt ;
					
					If sqlca.sqlcode <> 0 Then Exit 
					
					ll_r = dw_insert.InsertRow(0)
					
					dw_insert.Object.saupj[ll_r] = gs_saupj
					dw_insert.Object.itnbr[ll_r] = ls_itnbr
					dw_insert.Object.itdsc[ll_r] = ls_itdsc
					dw_insert.Object.qcgub[ll_r] = ls_qcgub
					dw_insert.Object.cvcod[ll_r] = Trim(ls_cvcod)
					dw_insert.Object.place[ll_r] = ls_plnt
					dw_insert.Object.yyyy[ll_r] = ls_yyyy
				
				Loop
				
				Close qc_jugi ;
			Else
				DECLARE qc_jugi_gita CURSOR FOR
					
				SELECT DISTINCT A.ITNBR, A.ITDSC, A.QCGUB, B.CVCOD, '.' AS PLNT
				  FROM ITEMAS A,
						 VNDDAN B
				 WHERE A.ITNBR           =    B.ITNBR
					AND NVL(A.USEYN, '0') =    '0'
					AND A.ITTYP           LIKE :ls_gubun
					AND B.CVCOD           =    :ls_cvcod ;
				
				OPEN qc_jugi_gita ;
				
				DO WHILE TRUE
					FETCH qc_jugi_gita INTO :ls_itnbr, :ls_itdsc, :ls_qcgub, :ls_cvcod, :ls_plnt ;
					
					If SQLCA.SQLCODE <> 0 Then EXIT
					
					ll_r = dw_insert.InsertRow(0)					
					
					dw_insert.Object.saupj[ll_r] = gs_saupj
					dw_insert.Object.itnbr[ll_r] = ls_itnbr
					dw_insert.Object.itdsc[ll_r] = ls_itdsc
					dw_insert.Object.qcgub[ll_r] = ls_qcgub
					dw_insert.Object.cvcod[ll_r] = Trim(ls_cvcod)
					dw_insert.Object.place[ll_r] = ls_plnt
					dw_insert.Object.yyyy[ll_r] = ls_yyyy
				
				Loop
				
				Close qc_jugi_gita ;
			End If
		
		Else
			if isnull(ls_gubun) or ls_gubun = '' then ls_gubun = '%'
				
				
			DECLARE qc_jugi2 CURSOR FOR 
			
				SELECT X.ITNBR  ITNBR,
						 X.ITDSC  ITDSC,
						 Y.QCGUB  QCGUB,
						 Y.CVCOD  CVCOD
				  FROM ITEMAS X , DANMST Y
				 WHERE X.ITNBR = Y.ITNBR(+)
				   AND NVL(X.USEYN,'0') = '0'
					And X.ITTYP LIKE :ls_gubun
					And Y.CVCOD = :ls_cvcod ;
						
			Open qc_jugi2 ;
			
			Do While True
				
				FETCH qc_jugi2 Into :ls_itnbr ,:ls_itdsc ,:ls_qcgub ,:ls_cvcod ;
				
				If sqlca.sqlcode <> 0 Then Exit 
				
				ll_r = dw_insert.InsertRow(0)
				
				dw_insert.Object.saupj[ll_r] = gs_saupj
				dw_insert.Object.itnbr[ll_r] = ls_itnbr
				dw_insert.Object.itdsc[ll_r] = ls_itdsc
				dw_insert.Object.qcgub[ll_r] = ls_qcgub
				dw_insert.Object.cvcod[ll_r] = Trim(ls_cvcod)
	        		dw_insert.Object.place[ll_r] = '.'			
				dw_insert.Object.yyyy[ll_r] = ls_yyyy
			Loop
			
			Close qc_jugi2 ;
		End If
		
		If ll_r > 0 Then
			dw_ip.Enabled = False
			ib_any_typing = False //입력필드 변경여부 No
		Else
			f_message_chk(50, "")
		End If
		
	End If
End If
end event

type p_del from w_inherite`p_del within w_qa00_00020
boolean visible = false
integer x = 4416
integer y = 176
integer taborder = 50
end type

event p_del::clicked;call super::clicked;//If dw_insert.RowCount() < 1 Then Return
//
//If f_msg_delete() < 1 Then Return
//
//String ls_new
//Long   i , ll_rcnt ,ll_fr
//
//dw_insert.AcceptText()
//ll_rcnt = dw_insert.RowCount()
//
//For i =1 To ll_rcnt
//	
//	If dw_insert.isSelected(i) Then
//		
//		ls_new = Trim(dw_insert.Object.is_new[i])
//		
//		If ls_new = 'N' Then
//			If MessageBox('확인','삭제 불가능합니다. 계속 진행하시겠습니까?',& 
//						  StopSign!, OKCancel!, 1)  = 1 Then Continue
//		Else
//			dw_insert.DeleteRow(i)
//			i = 0
//			ll_rcnt = dw_insert.RowCount()
//		End if
//	End If
//Next
//
end event

type p_mod from w_inherite`p_mod within w_qa00_00020
integer x = 4059
integer y = 32
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)
Long ll_r
String ls_cvcod , ls_itnbr

//If dw_insert.RowCount() < 1 Then Return


If wf_required_chk() < 1 Then Return

If f_msg_update() = -1 Then Return  //저장 Yes/No ?

If dw_insert.Update() <> 1 Then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
	w_mdi_frame.sle_msg.text = "저장작업을 실패 하였습니다!"
	Return
Else
	Commit ;
	w_mdi_frame.sle_msg.text = "저장작업을 완료 하였습니다!"
	p_inq.TriggerEvent(Clicked!)
End If

ib_any_typing = False //입력필드 변경여부 No

SetPointer(Arrow!)
 
end event

type cb_exit from w_inherite`cb_exit within w_qa00_00020
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa00_00020
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa00_00020
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa00_00020
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa00_00020
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa00_00020
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qa00_00020
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa00_00020
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa00_00020
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qa00_00020
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa00_00020
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa00_00020
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa00_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_qa00_00020
end type

type cb_1 from commandbutton within w_qa00_00020
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

type dw_ip from datawindow within w_qa00_00020
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
string tag = "TEST"
integer x = 41
integer y = 24
integer width = 3433
integer height = 164
integer taborder = 90
string title = "none"
string dataobject = "d_qa00_00020_1"
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

event itemchanged;String ls_col ,ls_cod , ls_cvcod, ls_cvnas, ls_null, ls_place
Long   ll_cnt ,ll_row

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())
setnull(ls_null)

Choose Case ls_col
	Case "cvcod" 
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[거래처]')
			SetColumn(ls_col)
			Return 1
		End If
		Select cvnas 
		  Into :ls_cvnas 
		  From vndmst
		  Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvcod[GetRow()] = ""
			Return 1
		End If

		This.Object.cvnas[GetRow()] = ls_cvnas

		
//	Case "gubun" 
//		If ls_cod = '' Or isNull(ls_cod)  Then return
//		
//		if ls_cod = '1' then
//			This.Object.place[GetRow()] = ls_null
//		else
//			This.Object.place[GetRow()] = '이원정공'
//		end if
	
	Case "cvnas"
		if isnull(ls_cod) or ls_cod = '' then return
		
		select cvcod, cvnas2 into :ls_cod, :ls_cvnas from vndmst
		 where cvnas2 like '%'||:ls_cod||'%' and rownum = 1 ;
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvcod',ls_cod)
			this.setitem(1,'cvnas',ls_cvnas)
		else
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
		end if
		
		return 2
	
	Case "grpno1"
		if ls_cod = '.' or isnull(ls_cod) or ls_cod = '' then return
		
		select a.rfna2 , b.cvnas
		  into :ls_cvcod, :ls_cvnas
		  from reffpf a, vndmst b
		 where a.rfcod = '2A' and a.rfgub = :ls_cod and a.rfna2 = b.cvcod ;
		
		If sqlca.sqlcode <> 0 Then
			This.Object.cvcod[GetRow()] = ""
			This.Object.cvnas[GetRow()] = ""
			Return 1
		End If

		This.Object.cvcod[GetRow()] = ls_cvcod
		This.Object.cvnas[GetRow()] = ls_cvnas

End Choose
 
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

AcceptText()

String ls_gubun

IF this.GetColumnName() = "cvcod" THEN
	
	gs_gubun ='1'
	
	
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then return
	this.SetItem(1, "cvcod", gs_Code)
	this.TriggerEvent("itemchanged")	
END IF
end event

type rr_3 from roundrectangle within w_qa00_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 200
integer width = 4526
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

