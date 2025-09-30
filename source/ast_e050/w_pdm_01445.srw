$PBExportHeader$w_pdm_01445.srw
$PBExportComments$** 표준공정 등록
forward
global type w_pdm_01445 from w_inherite
end type
type dw_1 from datawindow within w_pdm_01445
end type
type rr_1 from roundrectangle within w_pdm_01445
end type
type rr_2 from roundrectangle within w_pdm_01445
end type
end forward

global type w_pdm_01445 from w_inherite
string title = "환산표준 등록"
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01445 w_pdm_01445

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);long ll_cnt
string ls_itnbr, ls_opseq, ls_wkctr
dwItemStatus l_status

ls_itnbr = dw_insert.GetItemString(i,'typecd')
ls_opseq = dw_insert.GetItemString(i,'opseq')
ls_wkctr = dw_insert.GetItemString(i,'wkctr')

if dw_1.AcceptText() = -1 then return  -1
if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'typecd')) or &
	dw_insert.GetItemString(i,'typecd') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('typecd')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'opseq')) or &
	dw_insert.GetItemString(i,'opseq') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('opseq')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'wkctr')) or &
	dw_insert.GetItemString(i,'wkctr') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('wkctr')
	dw_insert.SetFocus()
	return -1		
end if	

l_status = dw_insert.GetItemStatus(i, 0, Primary!)

if l_status = NewModified! or l_status = New! then
	SELECT COUNT('X')
	  INTO :ll_cnt
	  FROM ROUTNG_WKCTR
	 WHERE TYPECD = :ls_itnbr
	   AND OPSEQ = :ls_opseq
		AND WKCTR = :ls_wkctr;
		
	if ll_cnt > 0 then
		f_message_chk(10001,'[ '+string(i)+' 행]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('typecd')
		dw_insert.SetFocus()
		return -1
	end if
end if

return 1
end function

on w_pdm_01445.create
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

on w_pdm_01445.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)

dw_1.SetFocus()
end event

event key;call super::key;// Page Up & Page Down & Home & End Key 사용 정의
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

type dw_insert from w_inherite`dw_insert within w_pdm_01445
integer x = 64
integer y = 236
integer width = 4503
integer height = 2056
string dataobject = "d_pdm_01445_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;string sNull
string sItnbr, sItdsc, sWcdsc

SetNull(sNull)

IF dwo.name = "typecd"	THEN
	
	IF data = ''	or		IsNull(data)	THEN	
		this.SetItem(row, "itdsc", snull)
		RETURN 
   END IF
	
	SELECT ITDSC
	  INTO :sItdsc
	  FROM ITEMAS
	 WHERE ITNBR = :data;
	 
	IF data = ''	or		IsNull(data)	THEN	
		this.SetItem(row, "typecd", snull)
		this.SetItem(row, "itdsc", snull)
		RETURN 1
	ELSE
		this.setitem(1, "typecd", data)	
		this.setitem(1, "itdsc", sItdsc)
   END IF
	
	
ELSEIF dwo.name ="opseq" THEN

	IF Len(data) <> 4 THEN
		Messagebox("확 인","공정번호는 4자리여야 합니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	
	IF Not IsNumber(data) THEN
		Messagebox("확 인","공정번호는 숫자만 입력할 수 있습니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	IF data < '0005' THEN
		Messagebox("확 인","공정번호는 0005 보다 적을 수 없습니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	
ELSEIF dwo.name = "wkctr"	THEN
	
	IF data = ''	or		IsNull(data)	THEN	
		this.SetItem(row, "wcdsc", snull)
		RETURN 
   END IF
		
	SELECT "WCDSC"
		INTO :sWcdsc
   	FROM "WRKCTR"  
	   WHERE ( "WKCTR" = :data )   ;
	IF sqlca.sqlcode <> 0		THEN
		messagebox("확인", "등록된 작업장이 아닙니다." )
		this.setitem(row, "wkctr", sNull)	
		this.setitem(row, "wcdsc", sNull)	
		RETURN 1
	END IF
	
	this.SetItem(row, "wcdsc", sWcdsc)

END IF
end event

event dw_insert::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

String sItnbr, sOpseq
Long   nCnt
Dec	 dMchr

IF this.GetColumnName() = "typecd"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return

	this.SetItem(row, "typecd", gs_code)

   this.Event ItemChanged(row, this.object.typecd, gs_code)

ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	gs_code = this.GetText()
	open(w_workplace_popup)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(row, "wkctr", 	 gs_Code)
	this.SetItem(row, "wcdsc", 	 gs_CodeName)
	
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01445
boolean visible = false
integer x = 3575
integer y = 2064
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01445
boolean visible = false
integer x = 3401
integer y = 2064
end type

type p_search from w_inherite`p_search within w_pdm_01445
boolean visible = false
integer x = 3401
integer y = 1924
end type

type p_ins from w_inherite`p_ins within w_pdm_01445
integer x = 3749
end type

event p_ins::clicked;call super::clicked;dw_insert.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_pdm_01445
end type

type p_can from w_inherite`p_can within w_pdm_01445
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_insert.reset()

dw_1.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_pdm_01445
boolean visible = false
integer x = 3575
integer y = 1924
end type

type p_inq from w_inherite`p_inq within w_pdm_01445
integer x = 3575
end type

event p_inq::clicked;call super::clicked;string ls_itnbr, ls_opseq, ls_wkctr

dw_1.AcceptText()

ls_itnbr = dw_1.GetItemString(1, "itnbr")
ls_opseq = dw_1.GetItemString(1, "opseq")
ls_wkctr = dw_1.GetItemString(1, "wkctr")

if ls_itnbr = "" or isNull(ls_itnbr) then ls_itnbr = '%'
if ls_opseq = "" or isNull(ls_opseq) then ls_opseq = '%'
if ls_wkctr = "" or isNull(ls_wkctr) then ls_wkctr = '%'

dw_insert.Retrieve(ls_itnbr, ls_wkctr, ls_opseq)
end event

type p_del from w_inherite`p_del within w_pdm_01445
end type

event p_del::clicked;call super::clicked;long irow

dw_insert.AcceptText()
dw_1.AcceptText()

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

if f_msg_delete() = -1 then return

irow = dw_insert.getrow()
   
dw_insert.SetRedraw(FALSE)

dw_insert.DeleteRow(irow)

if dw_insert.Update() = 1 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_mod from w_inherite`p_mod within w_pdm_01445
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
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01445
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01445
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01445
end type

type cb_del from w_inherite`cb_del within w_pdm_01445
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01445
end type

type cb_print from w_inherite`cb_print within w_pdm_01445
end type

type st_1 from w_inherite`st_1 within w_pdm_01445
end type

type cb_can from w_inherite`cb_can within w_pdm_01445
end type

type cb_search from w_inherite`cb_search within w_pdm_01445
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01445
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01445
end type

type dw_1 from datawindow within w_pdm_01445
integer x = 133
integer y = 48
integer width = 3337
integer height = 148
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01445_a"
boolean border = false
end type

event itemchanged;w_mdi_frame.sle_msg.text = ''

string	sNull, sOpseq, s_ispec, s_itdsc, s_jijil, s_ispec_code, sroslt, sname, sitem, sname2, sItnbr
integer  ireturn 

SetNull(sNull)

IF this.GetColumnName() = "itnbr"	THEN
	
	sItnbr = this.GetText()
	
	IF sItnbr = ''	or		IsNull(sItnbr)	THEN	
		this.SetItem(1, "itdsc", snull)
		RETURN 
   END IF

	ireturn = f_get_name4('품번', 'Y', sItnbr, s_itdsc, s_ispec, s_jijil, s_ispec_code )    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sItnbr)	
	this.setitem(1, "itdsc", s_itdsc)	
	
ELSEIF this.GetColumnName() ="opseq" THEN
	sOpseq = this.GetText()
	
	IF sOpseq = '' or IsNull(sOpseq) THEN
		this.SetItem(1, "opseq", snull)
	END IF
	
	IF Len(sOpseq) <> 4 THEN
		Messagebox("확 인","공정번호는 4자리여야 합니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	
	IF Not IsNumber(sOpseq) THEN
		Messagebox("확 인","공정번호는 숫자만 입력할 수 있습니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	IF sOpseq < '0005' THEN
		Messagebox("확 인","공정번호는 0005 보다 적을 수 없습니다.")
		this.setitem(1, "opseq", sNull)	
		Return 1
	END IF
	
ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	string	sCode
	sCode = this.GetText()
	
	IF sCode = '' or IsNull(sCode) THEN
		this.SetItem(1, "wkctr", snull)
		this.SetItem(1, "wcdsc", snull)
		RETURN
	END IF
	
	SELECT "WCDSC"
		INTO :sName
   	FROM "WRKCTR"  
	   WHERE ( "WKCTR" = :sCode )   ;
	IF sqlca.sqlcode <> 0		THEN
		messagebox("확인", "등록된 작업장이 아닙니다." )
		this.setitem(1, "wkctr", sNull)	
		RETURN 1
	END IF
	
	this.SetItem(1, "wcdsc", sName)

END IF


end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

String sItnbr, sOpseq
Long   nCnt
Dec	 dMchr

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return

	this.SetItem(1, "itnbr", gs_code)

   this.Event ItemChanged(row, this.object.itnbr, gs_code)

ELSEIF this.GetColumnName() = "wkctr"	THEN
	
	gs_code = this.GetText()
	open(w_workplace_popup)
	
	IF Isnull(gs_Code) 	or		gs_Code = ''		THEN	RETURN

	this.SetItem(1, "wkctr", 	 gs_Code)
	this.SetItem(1, "wcdsc", 	 gs_CodeName)
	
END IF
end event

type rr_1 from roundrectangle within w_pdm_01445
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 32
integer width = 3465
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01445
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 228
integer width = 4535
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

