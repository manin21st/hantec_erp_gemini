$PBExportHeader$w_pdt_02464.srw
$PBExportComments$출하검사 현황
forward
global type w_pdt_02464 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_02464
end type
type st_1 from statictext within w_pdt_02464
end type
type rb_1 from radiobutton within w_pdt_02464
end type
type rb_2 from radiobutton within w_pdt_02464
end type
type rb_3 from radiobutton within w_pdt_02464
end type
type pb_1 from u_pb_cal within w_pdt_02464
end type
type pb_2 from u_pb_cal within w_pdt_02464
end type
type rr_2 from roundrectangle within w_pdt_02464
end type
end forward

global type w_pdt_02464 from w_standard_print
string title = "출하 검사 현황"
rr_1 rr_1
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_pdt_02464 w_pdt_02464

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate, ls_edate, ls_sman, ls_eman, sfilter, sgubun, ls_saupj

if dw_ip.AcceptText() = -1 then return -1

ls_sdate = trim(dw_ip.GetItemString(1, 'fr_date'))
ls_edate = trim(dw_ip.GetItemString(1, 'to_date'))
sgubun   = trim(dw_ip.GetItemString(1, 'gubun'))

ls_sman = dw_ip.GetItemString(1, 'fr_man')
ls_eman = dw_ip.GetItemString(1, 'to_man')

ls_saupj = dw_ip.GetItemString(1, 'saupj')

if IsNull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'

if IsNull(ls_edate) or ls_edate = "" then ls_edate = '99991231'

if IsNull(ls_sman) or ls_sman = "" then ls_sman = '.'

if IsNull(ls_eman) or ls_eman = "" then ls_eman = 'zzzzzz'

if IsNull(ls_saupj) or ls_saupj = "" then ls_saupj = '%'

if ls_sdate > ls_edate then
   f_message_chk(34, '[검사일자]')
   dw_ip.setcolumn('fr_date')
   dw_ip.Setfocus()
	return -1
end if	

if ls_sman > ls_eman then
   f_message_chk(34, '[검사담당자]')
   dw_ip.setcolumn('fr_man')
   dw_ip.Setfocus()
	return -1
end if

if sgubun = '1' then
	dw_list.dataobject = 'd_pdt_02464_2'
	dw_print.dataobject = 'd_pdt_02464_2_p'
Else
	dw_list.dataobject = 'd_pdt_02464_3'	
	dw_print.dataobject = 'd_pdt_02464_3_p'
End if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_list.setredraw(false)

IF dw_print.Retrieve(gs_sabu,ls_saupj,  ls_sdate, ls_edate, ls_sman, ls_eman) <= 0 then
	f_message_chk(50,'[출하 검사 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
	Return -1
END IF

sfilter = ''
dw_print.SetFilter(sfilter)
dw_print.Filter( )

if rb_1.checked then
	sfilter = "decision_yn = 'Y'"
	dw_print.SetFilter(sfilter)
	dw_print.Filter( )	
elseif rb_2.checked then
	sfilter = "decision_yn = 'N'"
	dw_print.SetFilter(sfilter)
	dw_print.Filter( )		
end if

dw_print.ShareData(dw_list)

dw_list.setredraw(True)

return 1

end function

on w_pdt_02464.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.rr_2
end on

on w_pdt_02464.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;f_mod_saupj(dw_ip, 'saupj')


end event

type p_preview from w_standard_print`p_preview within w_pdt_02464
end type

type p_exit from w_standard_print`p_exit within w_pdt_02464
end type

type p_print from w_standard_print`p_print within w_pdt_02464
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02464
end type







type st_10 from w_standard_print`st_10 within w_pdt_02464
end type



type dw_print from w_standard_print`dw_print within w_pdt_02464
string dataobject = "d_pdt_02464_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02464
integer x = 64
integer y = 156
integer width = 3749
integer height = 172
string dataobject = "d_pdt_02464_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string s_colname, snull, s_code

s_colname = this.GetColumnName()
if (s_colname = "fr_date") then 
	s_code = Trim(GetTEXT())
   if IsNUll(s_code) or s_code = "" then return 
   if f_datechk(s_code) = -1 then //날짜체크
	   f_message_chk(35,"[검사일자]")
	   this.SetItem(1, s_colname, snull)
	   return 1
   end if
ELSEif (s_colname = "to_date") then
	s_code = Trim(GetTEXT())
   if IsNUll(s_code) or s_code = "" then return 
   if f_datechk(s_code) = -1 then //날짜체크
	   f_message_chk(35,"[검사일자]")
	   this.SetItem(1, s_colname, snull)
	   return 1
   end if
end if	

end event

type dw_list from w_standard_print`dw_list within w_pdt_02464
integer y = 388
integer height = 1864
string dataobject = "d_pdt_02464_2"
end type

type rr_1 from roundrectangle within w_pdt_02464
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 40
integer width = 1170
integer height = 104
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_1 from statictext within w_pdt_02464
integer x = 78
integer y = 72
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "출력조건"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_pdt_02464
integer x = 352
integer y = 64
integer width = 238
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "합격"
boolean checked = true
end type

type rb_2 from radiobutton within w_pdt_02464
integer x = 571
integer y = 64
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "불합격"
end type

type rb_3 from radiobutton within w_pdt_02464
integer x = 887
integer y = 64
integer width = 215
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전체"
end type

type pb_1 from u_pb_cal within w_pdt_02464
integer x = 1737
integer y = 236
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02464
integer x = 2208
integer y = 236
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_ip.SetItem(1, 'to_date', gs_code)
end event

type rr_2 from roundrectangle within w_pdt_02464
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 152
integer width = 3785
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

