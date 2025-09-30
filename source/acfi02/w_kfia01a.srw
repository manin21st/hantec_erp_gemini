$PBExportHeader$w_kfia01a.srw
$PBExportComments$예적금 조회 출력
forward
global type w_kfia01a from w_standard_print
end type
type rb_1 from radiobutton within w_kfia01a
end type
type rb_2 from radiobutton within w_kfia01a
end type
type gb_5 from groupbox within w_kfia01a
end type
type gb_4 from groupbox within w_kfia01a
end type
type rb_3 from radiobutton within w_kfia01a
end type
type rb_4 from radiobutton within w_kfia01a
end type
type rr_1 from roundrectangle within w_kfia01a
end type
type rr_2 from roundrectangle within w_kfia01a
end type
end forward

global type w_kfia01a from w_standard_print
integer x = 0
integer y = 0
string title = "예적금 조회 출력"
rb_1 rb_1
rb_2 rb_2
gb_5 gb_5
gb_4 gb_4
rb_3 rb_3
rb_4 rb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_kfia01a w_kfia01a

type variables
String      is_bank,      &
               is_basedate,  &  
               is_datef,  &  
               is_datet,  &  
               is_sgbn,  &  
               is_jgbn1 ='3', &   
               is_jgbn2 ='4'

end variables

forward prototypes
public function integer wf_chk_cond ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_chk_cond ();String sSaupj
Long   ll_row

ll_row = dw_ip.Getrow()

If dw_ip.AcceptText() = -1 Then Return -1

sSaupj	= dw_ip.Getitemstring( ll_row, 'saupj' )
is_bank	= dw_ip.Getitemstring( ll_row, 'bank' )
is_datef = Trim(dw_ip.GetItemString( ll_row, 'datef'))
is_datet = Trim(dw_ip.GetItemString( ll_row, 'datet'))

is_sgbn  = dw_ip.GetItemString( ll_row, 'sgbn')

is_basedate = f_today()

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

If is_bank = '' or Isnull(is_bank) then is_bank = '%' 

If is_datef = '' or Isnull(is_datef) then	is_datef = '00000000'
If is_datet = '' or Isnull(is_datet) then	is_datet = '99999999'
If is_sgbn = '3' then is_sgbn = '%'

Return 1
end function

public function integer wf_retrieve ();Int ll_rtn_chk

IF dw_ip.AcceptText() = -1 THEN RETURN -1
IF WF_CHK_COND() <> 1 THEN Return -1

IF dw_print.Retrieve(sabu_f, sabu_t, is_bank,is_basedate, is_datef,is_datet,is_sgbn,is_jgbn1,is_jgbn2) <=0 THEN
	f_messagechk(14,"") 
	//dw_list.insertrow(0)
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia01a.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_5=create gb_5
this.gb_4=create gb_4
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_5
this.Control[iCurrent+4]=this.gb_4
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_kfia01a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;

dw_list.SetTransObject(SQLCA)
dw_print.settransobject(sqlca)

dw_ip.Setitem(dw_ip.Getrow(), 'saupj', Gs_Saupj)

IF F_Authority_Fund_Chk(Gs_Dept)	 = -1 THEN							/*권한 체크- 현업 여부*/	
	dw_ip.Modify("saupj.protect = 1")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF	

dw_ip.SetColumn('saupj')
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia01a
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfia01a
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfia01a
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia01a
string pointer = ""
end type





type dw_datetime from w_standard_print`dw_datetime within w_kfia01a
integer taborder = 70
end type

type st_10 from w_standard_print`st_10 within w_kfia01a
end type



type dw_print from w_standard_print`dw_print within w_kfia01a
string dataobject = "d_kfia01a_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia01a
integer x = 32
integer y = 48
integer width = 2066
integer height = 292
string dataobject = "d_kfia01a_0"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String ls_bank, ls_banknm, sDate, snull

SetNull(snull)

sle_msg.text = ""

IF this.GetColumnName() = 'bank' THEN
	ls_bank = dw_ip.Gettext()
	IF ls_bank = '' OR IsNull(ls_bank) THEN Return
	
	SELECT "KFZ04OM0"."PERSON_NM"  	INTO :ls_banknm
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND ( "KFZ04OM0"."PERSON_CD" = :ls_bank )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"은행코드")
		dw_ip.SetItem(dw_ip.GetRow(),"bank",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="datef" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN Return
	
	IF f_datechk(sDate) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="datet" THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN Return
	
	IF f_datechk(sdate) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

end event

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="acc1f" OR this.GetColumnName() ="acc2f" THEN
	lstr_account.acc1_cd =dw_ip.GetItemString(1,"acc1f")
	lstr_account.acc2_cd =dw_ip.GetItemString(1,"acc2f")

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	end if

	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	IF lstr_account.gbn1 <> '5' THEN
		dw_ip.SetItem(1,"acc1f",snull)
		dw_ip.SetItem(1,"acc2f",snull)

		dw_ip.SetItem(1,"accf_nm",snull)
	ELSE
		dw_ip.SetItem(1,"acc1f",lstr_account.acc1_cd)
		dw_ip.SetItem(1,"acc2f",lstr_account.acc2_cd)

		dw_ip.SetItem(1,"accf_nm",lstr_account.acc2_nm)
	END IF
END IF
end event

event dw_ip::ue_pressenter;call super::ue_pressenter;//Send(Handle(this),256,9,0)
//Return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia01a
integer x = 46
integer y = 360
integer width = 4544
integer height = 1940
string dataobject = "d_kfia01a_01"
boolean border = false
boolean hsplitscroll = false
end type

type rb_1 from radiobutton within w_kfia01a
integer x = 2185
integer y = 136
integer width = 690
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "예금종류별 은행코드순"
boolean checked = true
end type

event clicked;dw_list.SetRedraw(False)

IF rb_3.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_01'
   dw_print.Dataobject = 'd_kfia01a_01_p'
	dw_print.Title ="정기성:예적금종류별 은행코드순"
ELSEif rb_4.Checked = True THEN 
	dw_list.Dataobject = 'd_kfia01a_02'
   dw_print.Dataobject = 'd_kfia01a_02_p'
	dw_print.Title ="비정기성:예금종류별 은행코드순"
End If


dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_list.SetRedraw(True)
end event

type rb_2 from radiobutton within w_kfia01a
integer x = 2185
integer y = 212
integer width = 690
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "은행코드별 예금종류순"
end type

event clicked;dw_list.SetRedraw(False)

IF rb_3.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_03'
   dw_print.Dataobject = 'd_kfia01a_03_p'
	dw_list.Title ="정기성:은행코드별 예적금종류순"
ELSEif rb_4.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_04'
   dw_print.Dataobject = 'd_kfia01a_04_p'
	dw_list.Title ="비정기성:은행코드별 예금종류순"
END IF

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_list.SetRedraw(True)

end event

type gb_5 from groupbox within w_kfia01a
integer x = 2917
integer y = 76
integer width = 562
integer height = 228
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "예금종류"
end type

type gb_4 from groupbox within w_kfia01a
integer x = 2139
integer y = 76
integer width = 773
integer height = 228
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "출력구분"
end type

type rb_3 from radiobutton within w_kfia01a
integer x = 2962
integer y = 140
integer width = 475
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "정기성 예금"
boolean checked = true
end type

event clicked;dw_list.SetRedraw(False)

IF rb_1.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_01'
   dw_print.Dataobject = 'd_kfia01a_01_p'
	dw_list.Title ="정기성:예적금종류별 은행코드순"
ELSEif rb_2.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_03'
   dw_print.Dataobject = 'd_kfia01a_03_p'
	dw_list.Title ="정기성:은행코드별 예적금종류순"
End If



dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_list.SetRedraw(True)
end event

type rb_4 from radiobutton within w_kfia01a
integer x = 2962
integer y = 212
integer width = 475
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "비정기성 예금"
end type

event clicked;dw_list.SetRedraw(False)

IF rb_1.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_02'
   dw_print.Dataobject = 'd_kfia01a_02_p'
	dw_list.Title ="비정기성:예금종류별 은행코드순"
ELSEif rb_2.Checked = True THEN
	dw_list.Dataobject = 'd_kfia01a_04'
   dw_print.Dataobject = 'd_kfia01a_04_p'
	dw_list.Title ="비정기성:은행코드별 예금종류순"
END IF

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_list.SetRedraw(True)

end event

type rr_1 from roundrectangle within w_kfia01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2103
integer y = 56
integer width = 1408
integer height = 272
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfia01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 344
integer width = 4567
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

