$PBExportHeader$w_pig3100.srw
$PBExportComments$차량보험, 검사일 리스트
forward
global type w_pig3100 from w_standard_print
end type
type rb_1 from radiobutton within w_pig3100
end type
type rb_2 from radiobutton within w_pig3100
end type
type rr_1 from roundrectangle within w_pig3100
end type
end forward

global type w_pig3100 from w_standard_print
string title = "차량 보험,검사일 리스트"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_pig3100 w_pig3100

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_date, ls_cargbn, snull, ls_tdate,ls_status
Integer k
SetNull(Snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'gdate')
ls_cargbn = dw_ip.GetItemString(dw_ip.GetRow(), 'cargbn')
ls_tdate = dw_ip.GetItemString(dw_ip.GetRow(), 'tdate') 
ls_status = dw_ip.GetItemString(1, "status")

IF ls_date = '' OR IsNull(ls_date) THEN
	MessageBox("확인", "조회일자를 입력하세요!")
	dw_ip.SetItem(dw_ip.GetRow(), 'gdate', snull)
	dw_ip.SetColumn('gdate')
	dw_ip.SetFocus()
	Return 1
END IF
IF ls_tdate = '' OR IsNull(ls_tdate) THEN
	MessageBox("확인", "조회일자를 입력하세요!")
	dw_ip.SetItem(dw_ip.GetRow(), 'tdate', snull)
	dw_ip.SetColumn('tdate')
	dw_ip.SetFocus()
	Return 1
END IF

IF ls_cargbn = '' OR IsNull(ls_cargbn) THEN ls_cargbn = '%'
if ls_status = '' or IsNull(ls_status) then ls_status = '%'

IF dw_print.Retrieve(ls_date, ls_cargbn,ls_status) <= 0 THEN
	MessageBox("확인", "조회된 자료가 없습니다.")
	Return 1
END IF



dw_print.ShareData(dw_list)

Return 1
	

end function

on w_pig3100.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pig3100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)

//dw_ip.SetItem(dw_ip.GetRow(), 'gdate', left(f_today(),6)+'01')
dw_ip.SetItem(dw_ip.GetRow(), 'gdate', f_today())
dw_ip.SetItem(dw_ip.GetRow(), 'tdate', f_today())
end event

type p_preview from w_standard_print`p_preview within w_pig3100
integer taborder = 60
end type

type p_exit from w_standard_print`p_exit within w_pig3100
integer taborder = 80
end type

type p_print from w_standard_print`p_print within w_pig3100
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig3100
integer taborder = 40
end type







type st_10 from w_standard_print`st_10 within w_pig3100
end type



type dw_print from w_standard_print`dw_print within w_pig3100
integer x = 3982
integer y = 220
boolean enabled = false
string dataobject = "d_pig3100_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3100
integer x = 658
integer y = 48
integer width = 3255
integer height = 244
integer taborder = 30
string dataobject = "d_pig3100_c"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_date, snull
SetNull(snull)

IF this.GetColumnName() = 'gdate' THEN
	ls_date = this.GetText()
	
	IF ls_date = '' OR IsNull(ls_date) THEN
		MessageBox("확인", "기준일자를 입력하세요!")
		this.SetItem(this.GetRow(), 'gdate', snull)
		this.SetColumn('gdate')
		this.SetFocus()
		Return 1
	END IF
	
	If f_datechk(ls_date) = -1 THEN
		MessageBox("확 인", "기준일자가 부정확합니다.")
		this.SetItem(this.GetRow(), 'gdate', snull)
		this.SetColumn('gdate')
		this.SetFocus()
		Return 1
	END IF
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_pig3100
integer x = 777
integer y = 316
integer width = 3077
integer height = 1908
integer taborder = 50
string dataobject = "d_pig3100_1"
boolean border = false
end type

type rb_1 from radiobutton within w_pig3100
integer x = 727
integer y = 124
integer width = 402
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "보험만기일"
boolean checked = true
end type

event clicked;dw_list.DataObject = 'd_pig3100_1'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_pig3100_1_p'
dw_print.SetTransObject(sqlca)
//dw_list.Title = '보험만기일 현황'
end event

type rb_2 from radiobutton within w_pig3100
integer x = 1129
integer y = 124
integer width = 402
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "차기검사일"
end type

event clicked;dw_list.DataObject = 'd_pig3100_2'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_pig3100_2_p'
dw_print.SetTransObject(sqlca)
//dw_list.Title = '차기검사일 현황'
end event

type rr_1 from roundrectangle within w_pig3100
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 768
integer y = 308
integer width = 3118
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

