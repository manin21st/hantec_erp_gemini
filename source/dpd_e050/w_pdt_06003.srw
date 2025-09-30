$PBExportHeader$w_pdt_06003.srw
$PBExportComments$** 설비 구매 현황
forward
global type w_pdt_06003 from w_inherite
end type
type dw_1 from datawindow within w_pdt_06003
end type
type rr_1 from roundrectangle within w_pdt_06003
end type
end forward

global type w_pdt_06003 from w_inherite
string title = "설비 구매 현황"
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_06003 w_pdt_06003

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_required_chk ()
end prototypes

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)

dw_insert.reset()

dw_insert.setredraw(true)


end subroutine

public function integer wf_required_chk ();//필수입력항목 체크
//Long i, lCount
//string sdept, sdate
//
//lCount = dw_insert.RowCount()
//
//for i = 1 to lCount
//	sdept = trim(dw_insert.object.gunam[i])
//	sdate = trim(dw_insert.object.gudat[i])
//	
//   if (Isnull(sdept) or sdept =  "") and sdate > '.' then	
//	   f_message_chk(1400,'[구입처]')
//	   dw_insert.SetColumn('gunam')
//	   dw_insert.SetFocus()
//	   return -1
//	elseif (Isnull(sdate) or sdate =  "") and sdept > '.' then	
//	   f_message_chk(1400,'[구입일자]')
//	   dw_insert.SetColumn('gudat')
//	   dw_insert.SetFocus()
//	   return -1
//   end if
//next

return 1
end function

on w_pdt_06003.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_06003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.insertrow(0)
dw_1.SetFocus()
//dw_1.setitem(1, 'fdate', left(is_today, 6) + '01')
//dw_1.setitem(1, 'tdate', is_today)
//
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

type dw_insert from w_inherite`dw_insert within w_pdt_06003
integer x = 434
integer y = 256
integer width = 3776
integer height = 1956
integer taborder = 30
string dataobject = "d_pdt_06003_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String s_cod
long   lrow

s_cod = Trim(this.GetText())
lrow  = this.getrow()

if this.getcolumnname() = "gudat" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[구입일자]")
		this.object.gudat[lrow] = ""
		return 1
	end if
End If


end event

event dw_insert::rbuttondown;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//if this.getcolumnname() = "ipemp" then
//	open(w_sawon_popup)
//	If IsNull(gs_code) Or gs_code = '' Then Return
//	this.SetItem(this.getrow(), "ipemp", gs_code)
//	this.SetItem(this.getrow(), "p1_master_empname", gs_codename)
//	return
//end if
//
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06003
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06003
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06003
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06003
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06003
integer x = 4059
integer y = 80
end type

type p_can from w_inherite`p_can within w_pdt_06003
integer x = 3886
integer y = 80
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_06003
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06003
integer x = 3538
integer y = 80
end type

event p_inq::clicked;call super::clicked;string sFdate, sTdate

if dw_1.AcceptText() = -1 then return 

sFdate = trim(dw_1.GetItemString(1,'fmchno'))
sTdate = trim(dw_1.GetItemString(1,'tmchno'))

if isnull(sfdate) or sfdate = "" then sfdate = '.'
if isnull(stdate) or stdate = "" then stdate = 'zzzzzz'

SetPointer(HourGlass!)

if dw_insert.Retrieve(gs_sabu, sfdate, stdate) <= 0 then 
	dw_1.Setfocus()
	return
else
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_pdt_06003
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_06003
integer x = 3712
integer y = 80
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

SetPointer(HourGlass!)
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06003
integer x = 3895
integer y = 5000
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06003
integer x = 3191
integer y = 5000
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06003
boolean visible = false
integer x = 539
integer y = 2472
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_06003
boolean visible = false
integer x = 1143
integer y = 2392
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06003
integer x = 3177
integer y = 5000
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_06003
boolean visible = false
integer x = 645
integer y = 2324
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_06003
end type

type cb_can from w_inherite`cb_can within w_pdt_06003
integer x = 3543
integer y = 5000
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_pdt_06003
boolean visible = false
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_pdt_06003
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06003
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06003
end type

type dw_1 from datawindow within w_pdt_06003
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 421
integer y = 100
integer width = 905
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_06003_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if	this.getcolumnname() = "fmchno" then
	gs_gubun = '설비마스타'
	open(w_mchno_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	SetItem(1, "fmchno", gs_code)
elseif	this.getcolumnname() = "tmchno" then
	gs_gubun = '설비마스타'
	open(w_mchno_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	SetItem(1, "tmchno", gs_code)
end if
end event

type rr_1 from roundrectangle within w_pdt_06003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 421
integer y = 244
integer width = 3813
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

