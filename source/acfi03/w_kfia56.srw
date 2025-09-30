$PBExportHeader$w_kfia56.srw
$PBExportComments$예금현황
forward
global type w_kfia56 from w_standard_print
end type
type cbx_1 from checkbox within w_kfia56
end type
type cbx_2 from checkbox within w_kfia56
end type
type cbx_3 from checkbox within w_kfia56
end type
type cbx_4 from checkbox within w_kfia56
end type
type cbx_5 from checkbox within w_kfia56
end type
type cbx_9 from checkbox within w_kfia56
end type
type rr_1 from roundrectangle within w_kfia56
end type
type cbx_6 from checkbox within w_kfia56
end type
type cbx_7 from checkbox within w_kfia56
end type
end forward

global type w_kfia56 from w_standard_print
integer x = 0
integer y = 0
string title = "예금현황"
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_9 cbx_9
rr_1 rr_1
cbx_6 cbx_6
cbx_7 cbx_7
end type
global w_kfia56 w_kfia56

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_acc_ymd, ls_pre_mm, ls_saupj, ls_saupjt, ls_sgbn, ls_cb1 = '0', ls_cb2 = '0', ls_cb3 = '0', ls_cb4 = '0', ls_cb5 = '0', ls_cb6 = '0',ls_cb7 = '0',ls_cb9 = '0'
Long ll_row

ll_row = dw_ip.GetRow()

If ll_row < 1 then return -1

If dw_ip.AcceptText() = -1 then return -1

ls_acc_ymd = dw_ip.GetItemString(ll_row, 'acc_ymd')  // 기준일자
ls_saupj   = dw_ip.Getitemstring(ll_row, 'saupj')    // 사업장
ls_sgbn 	  = dw_ip.Getitemstring(ll_row, 'sgbn')     // 계좌관리구분

If cbx_1.Checked = True then ls_cb1 = '1'
If cbx_2.Checked = True then ls_cb2 = '2'
If cbx_3.Checked = True then ls_cb3 = '3'
If cbx_4.Checked = True then ls_cb4 = '4'
If cbx_5.Checked = True then ls_cb5 = '5'
If cbx_6.Checked = True then ls_cb6 = '6'
If cbx_7.Checked = True then ls_cb7 = '7'
If cbx_9.Checked = True then ls_cb9 = '9'

IF ls_saupj = "" OR IsNull(ls_saupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("kfsacod")
	dw_ip.SetFocus()
	Return -1
END IF

If trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then 
	F_MessageChk(1, "[기준일자]")
	dw_ip.SetColumn('acc_ymd')
	dw_ip.SetFocus()
	return -1
Else 
	If f_datechk(ls_acc_ymd) = -1 then 
		F_MessageChk(21, "[기준일자]")
		dw_ip.SetColumn('acc_ymd')
		dw_ip.SetFocus()
		return -1		
	End If
End If

If ls_sgbn = '3' then ls_sgbn = '%'

If cbx_1.Checked = False and cbx_2.Checked = False and &
   cbx_3.Checked = False and cbx_4.Checked = False and &
	cbx_5.Checked = False and cbx_6.Checked = False and &
	cbx_7.Checked = False and cbx_9.Checked = False then
	MessageBox( "확 인 : [예금종류]", "[예금종류]를 적어도 하나이상을 선택해야 합니다!! ~r~n " + &
                     "원하는 출력항목을 선택하십시오!!" )
   Return -1
End If

ls_pre_mm = mid(ls_acc_ymd, 5, 2)

if ls_pre_mm = '01' then 
	ls_pre_mm = '00'
else
	ls_pre_mm = string(long(ls_pre_mm) - 1, '00')
end if									 
									 
dw_list.SetRedraw(false)				

if dw_print.retrieve(ls_acc_ymd, ls_pre_mm, sabu_f, sabu_t, ls_sgbn, ls_cb1, ls_cb2, ls_cb3, ls_cb4, ls_cb5, ls_cb6,ls_cb7,ls_cb9 ) < 1 then 
	F_MessageChk(14, "")
	dw_list.insertrow(0)
	dw_ip.Setcolumn('acc_ymd')
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)									 	
	//return -1
end if

dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)									 

return 1
end function

on w_kfia56.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_9=create cbx_9
this.rr_1=create rr_1
this.cbx_6=create cbx_6
this.cbx_7=create cbx_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.cbx_3
this.Control[iCurrent+4]=this.cbx_4
this.Control[iCurrent+5]=this.cbx_5
this.Control[iCurrent+6]=this.cbx_9
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.cbx_6
this.Control[iCurrent+9]=this.cbx_7
end on

on w_kfia56.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_9)
destroy(this.rr_1)
destroy(this.cbx_6)
destroy(this.cbx_7)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'acc_ymd', f_today())
dw_ip.SetItem(dw_ip.GetRow(),"saupj",  Gs_Saupj)
IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

cbx_1.Checked = True

dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia56
end type

type p_exit from w_standard_print`p_exit within w_kfia56
end type

type p_print from w_standard_print`p_print within w_kfia56
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia56
end type







type st_10 from w_standard_print`st_10 within w_kfia56
end type



type dw_print from w_standard_print`dw_print within w_kfia56
string dataobject = "dw_kfia56_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia56
integer width = 2898
integer height = 312
string dataobject = "dw_kfia56_01"
end type

event dw_ip::itemchanged;String ls_acc_ymd, snull

If this.GetColumnName() = 'acc_ymd' then
	ls_acc_ymd = this.GetText()
	If trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then
		F_MessageChk(1, "[기준일자]")
		return 1
	else
		if f_datechk(ls_acc_ymd) = -1 then
			F_MessageChk(21, "[기준일자]")
			return 1
		end if
	end if
end if

//if this.GetColumnName() = 'jgbnf' then 
//	ls_jgbnf = this.GetText()
//	if trim(ls_jgbnf) = '' or isnull(ls_jgbnf) then
//		F_MessageChk(1, "[예금종류 FROM]")
//		return 1
//	end if
//end if
//
//if this.GetColumnName() = 'jgbnt' then 
//	ls_jgbnt = this.GetText()
//	if trim(ls_jgbnt) = '' or isnull(ls_jgbnt) then
//		F_MessageChk(1, "[예금종류 TO]")
//		return 1
//	end if
//end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia56
integer x = 69
integer y = 356
integer width = 4517
integer height = 1948
string title = "예금현황"
string dataobject = "dw_kfia56_02"
boolean border = false
end type

type cbx_1 from checkbox within w_kfia56
integer x = 1454
integer y = 128
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "보통예금"
boolean checked = true
boolean lefttext = true
end type

type cbx_2 from checkbox within w_kfia56
integer x = 2144
integer y = 128
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "당좌예금"
boolean checked = true
boolean lefttext = true
end type

type cbx_3 from checkbox within w_kfia56
integer x = 1454
integer y = 200
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "정기적금"
boolean checked = true
boolean lefttext = true
end type

type cbx_4 from checkbox within w_kfia56
integer x = 2144
integer y = 200
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "정기예금"
boolean checked = true
boolean lefttext = true
end type

type cbx_5 from checkbox within w_kfia56
integer x = 1797
integer y = 128
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "외화예금"
boolean checked = true
boolean lefttext = true
end type

type cbx_9 from checkbox within w_kfia56
integer x = 1797
integer y = 200
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "기타예금"
boolean checked = true
boolean lefttext = true
end type

type rr_1 from roundrectangle within w_kfia56
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 344
integer width = 4549
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type cbx_6 from checkbox within w_kfia56
integer x = 2487
integer y = 132
integer width = 302
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "별단예금"
boolean checked = true
boolean lefttext = true
end type

type cbx_7 from checkbox within w_kfia56
integer x = 2491
integer y = 200
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "제예금"
boolean checked = true
boolean lefttext = true
end type

