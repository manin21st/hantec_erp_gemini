$PBExportHeader$w_pdm_01250.srw
$PBExportComments$** 창고별 담당자 등록
forward
global type w_pdm_01250 from w_inherite
end type
type dw_1 from datawindow within w_pdm_01250
end type
type rr_1 from roundrectangle within w_pdm_01250
end type
type rr_2 from roundrectangle within w_pdm_01250
end type
end forward

global type w_pdm_01250 from w_inherite
string title = "창고별 담당자 등록"
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01250 w_pdm_01250

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if isnull(dw_insert.GetItemString(i,'empno')) or &
	dw_insert.GetItemString(i,'empno') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행  담당자]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('empno')
	dw_insert.SetFocus()
	return -1		
end if	

return 1
end function

on w_pdm_01250.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_pdm_01250.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
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

type dw_insert from w_inherite`dw_insert within w_pdm_01250
integer x = 1143
integer y = 192
integer width = 3447
integer height = 2100
integer taborder = 20
string dataobject = "d_pdm_01250"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;Int lRow, lReturnRow, ireturn 
String scode, sname, sname2, snull

SetNull(snull)
lRow  = this.GetRow()	

IF this.GetColumnName() = "empno" THEN
	scode = THIS.GETTEXT()								
	
	IF scode = '' or isnull(scode) then 
		this.SetItem(lRow, "p1_master_empname", sNull)
	END IF	
	
	lReturnRow = This.Find("empno = '"+scode+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[담당자]') 
		this.SetItem(lRow, "empno", sNull)
		RETURN  1
	END IF
	
  	ireturn = f_get_name2('사번', 'Y', scode, sname, sname2) 
	this.setitem(lrow, "empno", scode)
	this.setitem(lrow, "p1_master_empname", sname)
	return ireturn 
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.getcolumnname() = "empno" then
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
	
	this.setitem(this.getrow(), "empno", gs_code)
	this.triggerevent(itemchanged!)		 
end if


end event

type p_delrow from w_inherite`p_delrow within w_pdm_01250
integer x = 3922
end type

event p_delrow::clicked;call super::clicked;long i, irow, irow2

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_pdm_01250
integer x = 3749
end type

event p_addrow::clicked;call super::clicked;long i, lrow, k 
boolean result
string  sdepot

if dw_1.AcceptText() = -1 then return 

FOR k=1 TO dw_1.rowcount()
	result = dw_1.IsSelected(k)
	IF result THEN
		EXIT
	END IF
NEXT

IF result = FALSE THEN 
	MESSAGEBOX("확 인", "창고를 먼저 선택하세요!")
	return 
END IF	

sdepot = dw_1.getitemstring(k, 'cvcod')

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT
	
lRow = dw_insert.InsertRow(0)

dw_insert.setitem(lrow, 'depot_no', sdepot )
dw_insert.ScrollToRow(lrow)
dw_insert.SetColumn('empno')
dw_insert.SetFocus()


end event

type p_search from w_inherite`p_search within w_pdm_01250
boolean visible = false
integer x = 1225
integer y = 2780
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_01250
boolean visible = false
integer x = 1746
integer y = 2780
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_01250
end type

type p_can from w_inherite`p_can within w_pdm_01250
end type

event p_can::clicked;call super::clicked;dw_1.retrieve()

dw_insert.SetReDraw(false)
dw_insert.reset()
dw_insert.setredraw(true)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdm_01250
boolean visible = false
integer x = 1399
integer y = 2780
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_01250
boolean visible = false
integer x = 1573
integer y = 2780
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pdm_01250
boolean visible = false
integer x = 2441
integer y = 2780
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pdm_01250
integer x = 4096
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01250
boolean visible = false
integer x = 3223
integer y = 2840
integer taborder = 70
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01250
boolean visible = false
integer x = 2501
integer y = 2840
integer taborder = 50
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01250
boolean visible = false
integer x = 1778
integer y = 2840
integer taborder = 30
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01250
boolean visible = false
integer x = 2139
integer y = 2840
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01250
boolean visible = false
integer x = 558
integer y = 2840
end type

type cb_print from w_inherite`cb_print within w_pdm_01250
boolean visible = false
integer x = 709
integer y = 2800
end type

type st_1 from w_inherite`st_1 within w_pdm_01250
end type

type cb_can from w_inherite`cb_can within w_pdm_01250
boolean visible = false
integer x = 2862
integer y = 2840
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdm_01250
boolean visible = false
integer x = 1344
integer y = 2788
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01250
integer x = 142
integer y = 2700
integer width = 229
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01250
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01250
end type

type dw_1 from datawindow within w_pdm_01250
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 192
integer width = 1056
integer height = 2100
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01060_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;choose case key
	case keypageup!
		this.scrollpriorpage()
	case keypagedown!
		this.scrollnextpage()
	case keyhome!
		this.scrolltorow(1)
	case keyend!
		this.scrolltorow(this.rowcount())
	case KeyupArrow!
		this.scrollpriorrow()
	case KeyDownArrow!
		this.scrollnextrow()		
end choose
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	
   dw_insert.Retrieve(this.GetItemString(Row,"cvcod")) 
END IF
ib_any_typing = FALSE

end event

type rr_1 from roundrectangle within w_pdm_01250
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 184
integer width = 1074
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01250
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1134
integer y = 184
integer width = 3465
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

