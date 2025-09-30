$PBExportHeader$w_pin1016.srw
$PBExportComments$비품대장
forward
global type w_pin1016 from w_standard_print
end type
type gb_4 from groupbox within w_pin1016
end type
type rr_1 from roundrectangle within w_pin1016
end type
end forward

global type w_pin1016 from w_standard_print
string title = "비품대장"
gb_4 gb_4
rr_1 rr_1
end type
global w_pin1016 w_pin1016

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saup,ls_gbn1,ls_gbn2,ls_gbn3,ls_madept,ls_dept


if dw_ip.Accepttext() = -1 then return -1

ls_saup = dw_ip.GetitemString(1,"saupcd")
ls_gbn1 = dw_ip.GetitemString(1,"gbn1")
ls_gbn2 = dw_ip.GetitemString(1,"gbn2")
ls_gbn3 = dw_ip.GetitemString(1,"gbn3")
ls_madept = dw_ip.GetitemString(1,"madept")
ls_dept = dw_ip.GetitemString(1,"usedept")

if Isnull(ls_saup) or ls_saup = '' then
	messagebox("확인","사업장을 입력하십시요!")
	return -1
end if

if IsNull(ls_gbn1) or ls_gbn1 = '' then ls_gbn1 = '%'
if IsNull(ls_gbn2) or ls_gbn2 = '' then ls_gbn2 = '%' 
if IsNull(ls_gbn3) or ls_gbn3 = '' then ls_gbn3 = '%'
if IsNull(ls_madept) or ls_madept = '' then ls_madept = '%'
if IsNull(ls_dept) or ls_dept = '' then ls_dept = '%'

w_mdi_frame.sle_msg.text = '조회중!..........'
setpointer(HourGlass!)

//if gbn = '1' then
//	dw_list.Dataobject = "d_pin1016_1" 
//	dw_list.Settransobject(sqlca)
//elseif gbn = '2' then
//	dw_list.Dataobject = "d_pin1016_2"
//	dw_list.Settransobject(sqlca)
//end if
	

if dw_print.retrieve(ls_saup,ls_gbn1,ls_gbn2,ls_gbn3,ls_madept,ls_dept) < 1 then
	messagebox("조회","조회할 자료가 없습니다!")
   dw_ip.setcolumn("saupcd")
   dw_ip.setfocus()
	w_mdi_frame.sle_msg.text = ''
	return -1 
end if

//dw_print.sharedata(dw_list)
w_mdi_frame.sle_msg.text = '조회되었습니다!'
setpointer(Arrow!)

return 1
end function

on w_pin1016.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rr_1
end on

on w_pin1016.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rr_1)
end on

event open;call super::open;f_set_saupcd(dw_ip, 'saupcd', '1')
is_saupcd = gs_saupcd
end event

type p_preview from w_standard_print`p_preview within w_pin1016
integer x = 4064
end type

type p_exit from w_standard_print`p_exit within w_pin1016
integer x = 4411
end type

type p_print from w_standard_print`p_print within w_pin1016
integer x = 4238
end type

type p_retrieve from w_standard_print`p_retrieve within w_pin1016
integer x = 3890
end type







type st_10 from w_standard_print`st_10 within w_pin1016
end type



type dw_print from w_standard_print`dw_print within w_pin1016
integer x = 3698
string dataobject = "d_pin1016_2"
end type

type dw_ip from w_standard_print`dw_ip within w_pin1016
integer x = 96
integer y = 0
integer width = 2907
integer height = 256
string dataobject = "d_pin1016_01"
end type

event dw_ip::rbuttondown;//integer x = 96
//integer y = 0
//integer width = 2907
//integer height = 256
//string dataobject = "d_pin1016_01"

IF dw_ip.GetColumnName() = "madept"  THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	open(w_dept_saup_popup)
	
   IF IsNull(Gs_code) THEN RETURN
      dw_ip.SetItem(1,"madept",gs_code )

ELSEIF dw_ip.GetColumnName() = "usedept" then
	
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	
	open(w_dept_saup_popup)
	
   IF IsNull(Gs_code) THEN RETURN
      dw_ip.SetItem(1,"usedept",gs_code )

END IF	
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF
end event

type dw_list from w_standard_print`dw_list within w_pin1016
integer x = 105
integer y = 272
integer width = 4421
integer height = 1972
string title = "비품대장"
string dataobject = "d_pin1016_3"
boolean border = false
end type

type gb_4 from groupbox within w_pin1016
integer x = 105
integer y = 532
integer width = 549
integer height = 360
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type rr_1 from roundrectangle within w_pin1016
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 264
integer width = 4448
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 46
end type

