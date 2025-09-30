$PBExportHeader$w_pdm_90000.srw
$PBExportComments$IO_MATRIX 등록
forward
global type w_pdm_90000 from w_inherite
end type
type dw_list from datawindow within w_pdm_90000
end type
type st_2 from statictext within w_pdm_90000
end type
type st_3 from statictext within w_pdm_90000
end type
type st_4 from statictext within w_pdm_90000
end type
type st_5 from statictext within w_pdm_90000
end type
type st_6 from statictext within w_pdm_90000
end type
type rr_1 from roundrectangle within w_pdm_90000
end type
type rr_2 from roundrectangle within w_pdm_90000
end type
end forward

global type w_pdm_90000 from w_inherite
string title = "MATRIX 등록"
dw_list dw_list
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_90000 w_pdm_90000

type variables

end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();if isnull(dw_insert.GetItemString(1,'iogbn')) or &
	dw_insert.GetItemString(1,'iogbn') = "" then
	f_message_chk(1400,'[수불구분]')
	dw_insert.SetColumn('iogbn')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(1,'ionam')) or &
	dw_insert.GetItemString(1,'ionam') = "" then
	f_message_chk(1400,'[수불구분명]')
	dw_insert.SetColumn('ionam')
	dw_insert.SetFocus()
	return -1		
end if	

if dw_insert.GetItemString(1,'jnpcrt') = '007' then
	if isnull(dw_insert.GetItemString(1,'maigbn')) or &
		dw_insert.GetItemString(1,'maigbn') = "" then
		f_message_chk(1400,'[매입시 구분]')
		dw_insert.SetColumn('maigbn')
		dw_insert.SetFocus()
		return -1		
	end if	
end if	

if dw_insert.GetItemString(1,'autipg') = 'Y' then
	if isnull(dw_insert.GetItemString(1,'rcvcod')) or &
		dw_insert.GetItemString(1,'rcvcod') = "" then
		f_message_chk(1400,'[창고이동 입고 수불구분]')
		dw_insert.SetColumn('rcvcod')
		dw_insert.SetFocus()
		return -1		
	end if	
end if	

//관련처코드가 창고이고 출고이면 창고이동출고에서 자동전표생성으로
IF dw_insert.GetItemString(1,'relcod') = '1' or &
   dw_insert.GetItemString(1,'relcod') = '4' then
	if dw_insert.GetItemString(1,'iosp') = 'O' then
      if dw_insert.GetItemString(1,'autipg') <> 'Y' then
			messagebox("확 인", "관련처 코드가 창고이면서 I-O구분이 출고이면 "  +"~n"+&
									  "창고이동출고에서 자동전표 생성으로 셋팅되야 합니다.")
			dw_insert.SetColumn('autipg')
			dw_insert.SetFocus()
			return -1		
		end if
	end if
END IF

return 1
end function

on w_pdm_90000.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_pdm_90000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.SetTransObject(sqlca)
dw_list.retrieve(gs_sabu)
dw_insert.SetTransObject(sqlca)

dw_insert.insertrow(0)
dw_insert.setitem(1, 'sabu', gs_sabu)
dw_insert.setcolumn('iogbn')
dw_insert.setfocus()
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

type dw_insert from w_inherite`dw_insert within w_pdm_90000
integer x = 1687
integer y = 252
integer width = 2752
integer height = 2044
integer taborder = 20
string dataobject = "d_pdm_90000_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_key;call super::ue_key;//// Page Up & Page Down & Home & End Key 사용 정의
//choose case key
//	case KeyEnter! 
//		if this.getcolumnname() = "auto" then
//			if this.rowcount() = this.getrow() then
//				cb_ins.postevent(clicked!)
//				return 1
//			end if
//		end if
//end choose
//
//
end event

event dw_insert::itemchanged;String get_nm, s_gbn, snull, s_name

SetNull(snull)

IF this.GetColumnName() = "iogbn" THEN
	s_gbn = this.GetText()

	IF s_gbn = "" OR IsNull(s_gbn) THEN RETURN
	
	SELECT IOGBN
	  INTO :get_nm   		
	  FROM IOMATRIX  
	 WHERE IOGBN = :s_gbn  ;

	IF SQLCA.SQLCODE = 0 THEN
		this.Retrieve(gs_sabu, s_gbn) 
		this.SetTaborder('iogbn',0)
	//	this.Modify("iogbn.BackGround.Color= 79741120") 
		this.setcolumn('ionam')
		this.setfocus()
		ib_any_typing = FALSE
	END IF

ELSEIF this.GetColumnName() = "jnpcrt" THEN
	s_gbn = this.GetText()
   if s_gbn <> '007' then
		this.setitem(1, 'maigbn', snull)
	end if	
	
ELSEIF this.GetColumnName() = "rcvcod" THEN
	s_gbn = this.gettext()
 
   IF s_gbn = "" OR IsNull(s_gbn) THEN RETURN

   SELECT "IOMATRIX"."IONAM"  
     INTO :s_name  
     FROM "IOMATRIX"  
    WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND  
          ( "IOMATRIX"."IOGBN" = :s_gbn )   ;
	
	if sqlca.sqlcode <> 0 then
		f_message_chk(22,'[수불구분]')
		this.SetItem(1,'rcvcod', snull)
		return 1
   end if	
END IF
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdm_90000
boolean visible = false
integer x = 3342
integer y = 2592
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_90000
boolean visible = false
integer x = 3214
integer y = 2612
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdm_90000
boolean visible = false
integer x = 2642
integer y = 2588
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_90000
boolean visible = false
integer x = 3163
integer y = 2588
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_90000
integer x = 4402
integer y = 56
end type

type p_can from w_inherite`p_can within w_pdm_90000
integer x = 4224
integer y = 56
end type

event p_can::clicked;call super::clicked;dw_list.retrieve(gs_sabu)

dw_insert.SetReDraw(false)
dw_insert.reset()
dw_insert.insertrow(0)

dw_insert.setitem(1, 'sabu', gs_sabu)

dw_insert.SetTaborder('iogbn',10)
//dw_insert.Modify("iogbn.BackGround.Color= 12639424") 
dw_insert.setcolumn('iogbn')
dw_insert.setfocus()

dw_insert.SetRedraw(true)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdm_90000
boolean visible = false
integer x = 2816
integer y = 2588
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_90000
boolean visible = false
integer x = 2990
integer y = 2588
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pdm_90000
boolean visible = false
integer x = 3013
integer y = 2568
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pdm_90000
integer x = 4046
integer y = 56
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

IF wf_required_chk() = -1 THEN RETURN

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	return 
end if	
		
p_can.TriggerEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdm_90000
integer x = 2181
integer y = 2728
integer taborder = 50
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pdm_90000
integer x = 1477
integer y = 2728
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdm_90000
integer x = 649
integer y = 2612
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_90000
integer x = 1801
integer y = 2752
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//Integer i, irow, irow2
//
//dw_insert.AcceptText()
//
//if dw_insert.rowcount() <= 0 then
//	f_Message_chk(31,'[삭제 행]')
//	return 
//end if	
//
//irow = dw_insert.getrow() - 1
//irow2 = dw_insert.getrow() + 1
//if irow > 0 then   
//	FOR i = 1 TO irow
//		IF wf_required_chk(i) = -1 THEN RETURN
//	NEXT
//end if	
//
//FOR i = irow2 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
//if f_msg_delete() = -1 then return
//
//dw_insert.SetRedraw(FALSE)
//
//dw_insert.DeleteRow(0)
//
//if dw_insert.Update() = 1 then
//	sle_msg.text =	"자료를 삭제하였습니다!!"	
//	ib_any_typing = false
//	commit ;
//else
//	rollback ;
//end if	
//dw_insert.SetRedraw(TRUE)
//
//
end event

type cb_inq from w_inherite`cb_inq within w_pdm_90000
integer x = 1394
integer y = 2612
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdm_90000
integer x = 1957
integer y = 2848
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdm_90000
integer x = 14
integer y = 2732
integer width = 361
end type

type cb_can from w_inherite`cb_can within w_pdm_90000
integer x = 1829
integer y = 2728
integer taborder = 40
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdm_90000
integer x = 2592
integer y = 2836
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_90000
integer x = 2825
integer y = 2732
integer width = 741
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_pdm_90000
integer x = 379
integer y = 2732
integer width = 2446
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_pdm_90000
integer y = 2720
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_90000
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_90000
end type

type dw_list from datawindow within w_pdm_90000
event ue_key pbm_dwnkey
integer x = 101
integer y = 244
integer width = 1376
integer height = 2048
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_90000"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	
   if dw_insert.Retrieve(gs_sabu, this.GetItemString(Row,"iogbn")) <= 0 then
		f_message_chk(56, '[수불구분]')
		return 
   else
		dw_insert.SetTaborder('iogbn',0)
	//	dw_insert.Modify("iogbn.BackGround.Color= 79741120") 
      dw_insert.setcolumn('ionam')
      dw_insert.setfocus()
	end if	
END IF
ib_any_typing = FALSE

end event

type st_2 from statictext within w_pdm_90000
integer x = 178
integer y = 20
integer width = 2254
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "생산입고구분, 이월구분, 생산출고, 외주사급출고, 작업실적에 의한 자동출고, "
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_90000
integer x = 603
integer y = 92
integer width = 1353
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "~'YES~'는 수불구분내에서 유일해야 합니다..."
boolean focusrectangle = false
end type

type st_4 from statictext within w_pdm_90000
integer x = 46
integer y = 20
integer width = 110
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "▷"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_pdm_90000
integer x = 178
integer y = 92
integer width = 434
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "소급적용여부에"
boolean focusrectangle = false
end type

type st_6 from statictext within w_pdm_90000
integer x = 178
integer y = 168
integer width = 2926
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "수입검사 의뢰 여부는 창고이동시 적용되며 해당품목이 ~'입고후 검사품~'으로 지정된 경우만 해당됩니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdm_90000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1545
integer y = 236
integer width = 3035
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_90000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 236
integer width = 1399
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

