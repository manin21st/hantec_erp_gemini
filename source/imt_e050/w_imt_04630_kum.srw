$PBExportHeader$w_imt_04630_kum.srw
$PBExportComments$금형정보 변경-KUM
forward
global type w_imt_04630_kum from w_inherite
end type
type gb_3 from groupbox within w_imt_04630_kum
end type
type gb_2 from groupbox within w_imt_04630_kum
end type
type dw_1 from datawindow within w_imt_04630_kum
end type
type dw_2 from u_d_select_sort within w_imt_04630_kum
end type
type cbx_1 from checkbox within w_imt_04630_kum
end type
type rr_1 from roundrectangle within w_imt_04630_kum
end type
end forward

global type w_imt_04630_kum from w_inherite
string title = "금형정보(생산) 등록"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
dw_2 dw_2
cbx_1 cbx_1
rr_1 rr_1
end type
global w_imt_04630_kum w_imt_04630_kum

type variables
str_itnct lstr_sitnct
DataWindowChild idwc_1, idwc_2
end variables

forward prototypes
public function integer wf_item_chk (string sitem)
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public subroutine wf_calc_weight (long al_row)
end prototypes

public function integer wf_item_chk (string sitem);long  get_count

SELECT COUNT(*)  
  INTO :get_count
  FROM "ITEMAS"  
 WHERE "ITEMAS"."STDNBR" = :sitem  ;

if get_count > 0 then 
	messagebox("확 인", "표준품번으로 등록된 자료는 사용정지/단종 시킬 수 없습니다.")
	return -1
end if	

return 1
end function

public function integer wf_required_chk (integer i);//if dw_insert.AcceptText() = -1 then return -1
//
//if isnull(dw_insert.GetItemNumber(i,'vnqty')) or &
//	dw_insert.GetItemNumber(i,'vnqty') = 0 then
//	f_message_chk(1400,'[ '+string(i)+' 행 발주예정량]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('vnqty')
//	dw_insert.SetFocus()
//	return -1		
//end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_2.setredraw(false)
dw_1.setredraw(false)

dw_2.reset()
dw_1.reset()

dw_1.setcolumn('ittyp')
dw_1.setfocus()
dw_1.insertrow(0)

dw_1.setredraw(true)
dw_2.setredraw(true)


end subroutine

public subroutine wf_calc_weight (long al_row);If al_row < 1 Then Return

dw_2.AcceptText()

String ls_typ

ls_typ = dw_2.GetItemString(al_row, 'kumgubn')
If trim(ls_typ) = '' Or IsNull(ls_typ) Then 
	MessageBox('금형분류확인', String(al_row) + ' 번째 행의 금형분류가 잘못 되었습니다.')
	Return
End If

Long   ll_gshot  //생산중량
Long   ll_sshot  //S/R중량
Long   ll_jshot  //제품중량
Long   ll_gram   //생산단중
Long   ll_scrap  //S/R단중
Long   ll_jewt   //제품단중

Long   ll_cav    //CAV수
Long   ll_pit    //Pitch수

ll_gshot = dw_2.GetItemNumber(al_row, 'std_gram_shot')
If ll_gshot < 1 OR IsNull(ll_gshot) Then ll_gshot = 0

ll_sshot = dw_2.GetItemNumber(al_row, 'std_scrap_shot')
If ll_sshot < 1 OR IsNull(ll_sshot) Then ll_sshot = 0

ll_jshot = dw_2.GetItemNumber(al_row, 'std_jewt_shot')
If ll_jshot < 1 OR IsNull(ll_jshot) Then ll_jshot = 0

ll_cav = dw_2.GetItemNumber(al_row, 'cvqty')
If ll_cav < 1 OR IsNull(ll_cav) Then ll_cav = 0

ll_pit = dw_2.GetItemNumber(al_row, 'pitch')
If ll_pit < 1 OR IsNull(ll_pit) Then ll_pit = 0

Choose Case LEFT(ls_typ, 1)
	Case 'M'       //사출
		//생산중량 = 제품중량 + S/R중량
		ll_gshot = ll_jshot + ll_sshot
		If ll_gshot < 1 OR IsNull(ll_gshot) Then ll_gshot = 0
		
		dw_2.SetItem(al_row, 'std_gram_shot', ll_gshot)
		
		//단중계산입력
		If ll_cav < 1 OR IsNull(ll_cav) Then
			dw_2.SetItem(al_row, 'std_gram' , 0)
			dw_2.SetItem(al_row, 'std_scrap', 0)
			dw_2.SetItem(al_row, 'std_jewt' , 0)
		Else
			dw_2.SetItem(al_row, 'std_gram' , Round(ll_gshot / ll_cav, 1))  //생산단중
			dw_2.SetItem(al_row, 'std_scrap', Round(ll_sshot / ll_cav, 1))  //S/R단중
			dw_2.SetItem(al_row, 'std_jewt' , Round(ll_jshot / ll_cav, 1))  //제품단중
		End If
	Case 'R'  //고무
		//S/R중량 = 생산중량 - 제품중량
		ll_sshot = ll_gshot - ll_jshot 
		If ll_sshot < 1 OR IsNull(ll_sshot) Then ll_sshot = 0
		
		dw_2.SetItem(al_row, 'std_scrap_shot', ll_sshot)
		
		//단중계산입력
		If ll_cav < 1 OR IsNull(ll_cav) Then
			dw_2.SetItem(al_row, 'std_gram' , 0)
			dw_2.SetItem(al_row, 'std_scrap', 0)
			dw_2.SetItem(al_row, 'std_jewt' , 0)
		Else
			dw_2.SetItem(al_row, 'std_gram' , Round(ll_gshot / ll_cav, 1))  //생산단중
			dw_2.SetItem(al_row, 'std_scrap', Round(ll_sshot / ll_cav, 1))  //S/R단중
			dw_2.SetItem(al_row, 'std_jewt' , Round(ll_jshot / ll_cav, 1))  //제품단중
		End If
		
	Case 'P'  //단자
		//S/R중량 = 생산중량 - 제품중량
		ll_sshot = ll_gshot - ll_jshot 
		If ll_sshot < 1 OR IsNull(ll_sshot) Then ll_sshot = 0
		
		dw_2.SetItem(al_row, 'std_scrap_shot', ll_sshot)
		
		//단중계산입력 (단자는 PITCH로 단중계산)
		If ll_cav < 1 OR IsNull(ll_pit) Then
			dw_2.SetItem(al_row, 'std_gram' , 0)
			dw_2.SetItem(al_row, 'std_scrap', 0)
			dw_2.SetItem(al_row, 'std_jewt' , 0)
		Else
			dw_2.SetItem(al_row, 'std_gram' , Round(ll_gshot / ll_pit, 1))  //생산단중
			dw_2.SetItem(al_row, 'std_scrap', Round(ll_sshot / ll_pit, 1))  //S/R단중
			dw_2.SetItem(al_row, 'std_jewt' , Round(ll_jshot / ll_pit, 1))  //제품단중
		End If
		
End Choose


end subroutine

on w_imt_04630_kum.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_imt_04630_kum.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.GetChild('grp', idwc_1)
idwc_1.SetTransObject(SQLCA)
idwc_1.Retrieve()

dw_1.GetChild('sub', idwc_2)
idwc_2.SetTransObject(SQLCA)
idwc_2.Retrieve('%')

dw_2.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_imt_04630_kum
integer x = 471
integer y = 796
integer width = 2295
integer height = 648
integer taborder = 30
string dataobject = "d_pdm_01340"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sitnbr, sgub, sold
long   lrow

lrow = this.getrow()

IF this.GetColumnName() = "itemas_useyn"	THEN
	sitnbr = this.getitemstring(lrow, "itemas_itnbr")
	sold   = this.getitemstring(lrow, "itemas_useyn")
	sgub   = trim(this.GetText())
   if sold = '0' then 
		if wf_item_chk(sitnbr) = -1 then
			return 1 
		end if	
	end if
END IF
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::clicked;call super::clicked;//If Row <= 0 then
//	dw_insert.SelectRow(0,False)
//	b_flag =True
//ELSE
//
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	
//	b_flag = False
//END IF
//
//CALL SUPER ::CLICKED
end event

type p_delrow from w_inherite`p_delrow within w_imt_04630_kum
boolean visible = false
integer x = 4041
integer y = 2792
end type

type p_addrow from w_inherite`p_addrow within w_imt_04630_kum
boolean visible = false
integer x = 3867
integer y = 2792
end type

type p_search from w_inherite`p_search within w_imt_04630_kum
boolean visible = false
integer x = 3173
integer y = 2792
end type

type p_ins from w_inherite`p_ins within w_imt_04630_kum
boolean visible = false
integer x = 3694
integer y = 2792
end type

type p_exit from w_inherite`p_exit within w_imt_04630_kum
integer x = 4411
end type

type p_can from w_inherite`p_can within w_imt_04630_kum
integer x = 4238
end type

event clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE
end event

type p_print from w_inherite`p_print within w_imt_04630_kum
boolean visible = false
integer x = 3346
integer y = 2792
end type

type p_inq from w_inherite`p_inq within w_imt_04630_kum
integer x = 3890
end type

event p_inq::clicked;call super::clicked;string	ls_sts, ls_grp, ls_sub, ls_kumno, ls_kumname, ls_typeno 

if dw_1.AcceptText() = -1 then return 
 
ls_sts = dw_1.GetItemString(1,'sts')
ls_grp = dw_1.GetItemString(1,'grp')
ls_sub = dw_1.GetItemString(1,'sub')
ls_kumno = dw_1.GetItemString(1,'kumno')
ls_kumname = dw_1.GetItemString(1,'kumname')
ls_typeno = dw_1.GetItemString(1,'typeno')

if isnull(ls_sts) or ls_sts = "" then	ls_sts = "%"
if isnull(ls_grp) or ls_grp = "" then ls_grp = "%"
if isnull(ls_sub) or ls_sub = "" then ls_sub = "%"
if isnull(ls_kumno) or ls_kumno = "" then 
	ls_kumno = "%"
else
	ls_kumno = "%"+ls_kumno+"%"
end if
if isnull(ls_kumname) or ls_kumname = "" then 
	ls_kumname = "%"
else
	ls_kumname = "%"+ls_kumname+"%"
end if
if isnull(ls_typeno) or ls_typeno = "" then 
	ls_typeno = "%"
else
	ls_typeno = "%"+ls_typeno+"%"
end if

SetPointer(HourGlass!)

dw_2.setredraw(false)
if dw_2.Retrieve(ls_grp, ls_sub, ls_sts, ls_kumno, ls_kumname, ls_typeno) <= 0 then 
	dw_1.Setfocus()
   dw_2.setredraw(true)
	return
else
	dw_2.SetFocus()
end if	

ib_any_typing = FALSE

dw_2.setredraw(true)

end event

type p_del from w_inherite`p_del within w_imt_04630_kum
boolean visible = false
integer x = 4389
integer y = 2792
end type

type p_mod from w_inherite`p_mod within w_imt_04630_kum
integer x = 4064
end type

event p_mod::clicked;call super::clicked;if dw_2.AcceptText() = -1 then return 

if dw_2.rowcount() <= 0 then return 	

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_2.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
end event

type cb_exit from w_inherite`cb_exit within w_imt_04630_kum
integer x = 2825
integer y = 2640
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_imt_04630_kum
integer x = 2126
integer y = 2640
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;//if dw_2.AcceptText() = -1 then return 
//
//if dw_2.rowcount() <= 0 then return 	
//
//if f_msg_update() = -1 then return
//
//SetPointer(HourGlass!)
//	
//if dw_2.update() = 1 then
//	sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	return 
//end if	
//		
//cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_imt_04630_kum
integer x = 581
integer y = 2816
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_04630_kum
integer x = 1184
integer y = 2736
end type

type cb_inq from w_inherite`cb_inq within w_imt_04630_kum
integer x = 1641
integer y = 2648
integer width = 329
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//string s_ittyp, s_itcls, sfilter, newsort
//
//if dw_1.AcceptText() = -1 then return 
//
//s_ittyp = dw_1.GetItemString(1,'ittyp')
//s_itcls = dw_1.GetItemString(1,'itcls')
//
//if isnull(s_ittyp) or s_ittyp = "" then
//	f_message_chk(30,'[품목구분]')
//	dw_1.SetColumn('ittyp')
//	dw_1.SetFocus()
//	return
//end if	
//
//SetPointer(HourGlass!)
//
//dw_2.setredraw(false)
//
//if isnull(s_itcls) Then s_itcls = ""
//
//if dw_2.Retrieve(s_ittyp, s_itcls) <= 0 then 
//	dw_1.Setfocus()
//   dw_2.setredraw(true)
//	return
//else
//	dw_2.SetFocus()
//end if	
//
//ib_any_typing = FALSE
//
//dw_2.setredraw(true)
//
end event

type cb_print from w_inherite`cb_print within w_imt_04630_kum
integer x = 686
integer y = 2668
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_imt_04630_kum
end type

type cb_can from w_inherite`cb_can within w_imt_04630_kum
integer x = 2473
integer y = 2640
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type cb_search from w_inherite`cb_search within w_imt_04630_kum
integer x = 2661
integer y = 2876
end type





type gb_10 from w_inherite`gb_10 within w_imt_04630_kum
integer y = 2976
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_04630_kum
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_04630_kum
end type

type gb_3 from groupbox within w_imt_04630_kum
boolean visible = false
integer x = 2080
integer y = 2580
integer width = 1120
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_imt_04630_kum
boolean visible = false
integer x = 1591
integer y = 2588
integer width = 421
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_imt_04630_kum
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 32
integer width = 3470
integer height = 220
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_04630_kum_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
      p_inq.TriggerEvent(Clicked!)
   End If
END IF

end event

event itemerror;return 1
end event

event itemchanged;This.AcceptText()

If row < 1 Then Return

String ls_grp
ls_grp = This.GetItemString(row, 'grp')

idwc_2.Retrieve(ls_grp)

If idwc_2.RowCount() > 0 Then
	This.SetItem(row, 'sub', idwc_2.GetItemString(1, 'grpcod'))
End If
end event

type dw_2 from u_d_select_sort within w_imt_04630_kum
integer x = 37
integer y = 284
integer width = 4571
integer height = 2044
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_imt_04630_kum_2"
boolean border = false
boolean hsplitscroll = true
end type

event itemchanged;call super::itemchanged;string		s_Itcls, s_Name, s_itt, snull, s_col, s_data
int      	ireturn, i
boolean	bchar

setnull(snull)

s_col  = getcolumnname()
s_data = gettext()
If Trim(s_data) = '' OR IsNull(s_data) Then MessageBox('', '1')

IF not isnull(s_col) THEN
	if left(describe(s_col+".coltype"),4) = 'char' then
		bchar = true
	else
		bchar = false
	end if

	// 일괄지정
	if cbx_1.checked then
		for i = 1 to rowcount()
			if isselected(i) then
				if bchar then
					setitem(i,s_col,s_data)
				else
					setitem(i,s_col,dec(s_data))
				end if
				wf_calc_weight(i)
			end if
		next
		SelectRow(0, FALSE)
	Else
		wf_calc_weight(row)
	end if
END IF




end event

event ue_lbuttonup;
SetPointer(HourGlass!)

IF ib_action_on_buttonup THEN
	ib_action_on_buttonup = FALSE
	IF Keydown(KeyControl!) THEN
		this.selectrow(il_lastclickedrow, FALSE)
	ELSE
//		this.SelectRow(0, FALSE)
		this.SelectRow(il_lastclickedrow, TRUE)
	END IF
	il_lastclickedrow = 0
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

type cbx_1 from checkbox within w_imt_04630_kum
integer x = 3904
integer y = 200
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
string text = "일괄 지정"
end type

type rr_1 from roundrectangle within w_imt_04630_kum
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 276
integer width = 4585
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

