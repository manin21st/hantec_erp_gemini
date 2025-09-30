$PBExportHeader$w_pig5010a.srw
$PBExportComments$교육계획 등록-세부일정 등록
forward
global type w_pig5010a from window
end type
type dw_ins from u_key_enter within w_pig5010a
end type
type dw_dsp from datawindow within w_pig5010a
end type
type p_ins from uo_picture within w_pig5010a
end type
type p_exit from uo_picture within w_pig5010a
end type
type p_del from uo_picture within w_pig5010a
end type
type p_mod from uo_picture within w_pig5010a
end type
type rr_1 from roundrectangle within w_pig5010a
end type
end forward

global type w_pig5010a from window
integer width = 4498
integer height = 2200
boolean titlebar = true
string title = "세부일정 등록"
boolean resizable = true
long backcolor = 32106727
dw_ins dw_ins
dw_dsp dw_dsp
p_ins p_ins
p_exit p_exit
p_del p_del
p_mod p_mod
rr_1 rr_1
end type
global w_pig5010a w_pig5010a

type variables
Str_Edu   iStr_Edukey
Boolean   ib_any_typing
end variables

forward prototypes
public function integer wf_requiredchk (integer irow)
public function integer wf_date (string sdate, string edate)
end prototypes

public function integer wf_requiredchk (integer irow);
dw_ins.AcceptText()

if Trim(dw_ins.GetItemString(iRow,"startdate")) = '' or IsNull(Trim(dw_ins.GetItemString(iRow,"startdate"))) then
	MessageBox('확 인','교육일자를 입력하십시요.')
	dw_ins.SetColumn("startdate")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if

if Trim(dw_ins.GetItemString(iRow,"enddate")) = '' or IsNull(Trim(dw_ins.GetItemString(iRow,"enddate"))) then
	MessageBox('확 인','교육일자를 입력하십시요.')
	dw_ins.SetColumn("enddate")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if
if dw_ins.GetItemNumber(iRow,"strattime") = 0 or IsNull(dw_ins.GetItemNumber(iRow,"starttime")) then
	MessageBox('확 인','교육시간을 입력하십시요.')
	dw_ins.SetColumn("starttime")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if
if dw_ins.GetItemNumber(iRow,"endtime") = 0 or IsNull(dw_ins.GetItemNumber(iRow,"endtime")) then
	MessageBox('확 인','교육시간을 입력하십시요.')
	dw_ins.SetColumn("endtime")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if

if dw_ins.GetItemString(iRow,"educdesc") = '' or IsNull(dw_ins.GetItemString(iRow,"educdesc")) then
	MessageBox('확 인','교육내용을 입력하십시요.')
	dw_ins.SetColumn("educdesc")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if
if dw_ins.GetItemString(iRow,"edubook") = '' or IsNull(dw_ins.GetItemString(iRow,"edubook")) then
	MessageBox('확 인','교재명을 입력하십시요.')
	dw_ins.SetColumn("edubook")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if
if dw_ins.GetItemString(iRow,"eduteacher") = '' or IsNull(dw_ins.GetItemString(iRow,"eduteacher")) then
	MessageBox('확 인','교육담당을 입력하십시요.')
	dw_ins.SetColumn("eduteacher")
	dw_ins.ScrollToRow(iRow)
	dw_ins.SetFocus()
	Return -1
end if
Return 1
end function

public function integer wf_date (string sdate, string edate);string temp_date1, temp_date2
long ll_temp1

if isnull(sdate) or sdate = "" then return -1
if isnull(edate) or edate = "" then return -1

temp_date1 = string(left(sdate, 4) + "/"+ mid(sdate, 5,2) + "/" + &
				 right(sdate, 2))
temp_date2 = string(left(edate, 4) + "/"+ mid(edate, 5,2) + "/" + &
				 right(edate, 2))
ll_temp1 = 	daysafter(date(temp_date1), date(temp_date2)) + 1

return ll_temp1

end function

on w_pig5010a.create
this.dw_ins=create dw_ins
this.dw_dsp=create dw_dsp
this.p_ins=create p_ins
this.p_exit=create p_exit
this.p_del=create p_del
this.p_mod=create p_mod
this.rr_1=create rr_1
this.Control[]={this.dw_ins,&
this.dw_dsp,&
this.p_ins,&
this.p_exit,&
this.p_del,&
this.p_mod,&
this.rr_1}
end on

on w_pig5010a.destroy
destroy(this.dw_ins)
destroy(this.dw_dsp)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.rr_1)
end on

event open;

F_Window_Center_Response(This)

iStr_Edukey = Message.PowerObjectParm

if iStr_Edukey.str_mode = 'R' then
	p_ins.Visible = False
	p_mod.visible = False
	p_del.Visible = False
else
	p_ins.Visible = True
	p_mod.visible = True
	p_del.Visible = True
end if

dw_dsp.SetTransObject(Sqlca)
dw_ins.SetTransObject(Sqlca)

dw_dsp.Retrieve(Gs_Company,iStr_Edukey.str_empno,iStr_Edukey.str_eduyear,iStr_Edukey.str_empseq)
dw_ins.Retrieve(Gs_Company,iStr_Edukey.str_empno,iStr_Edukey.str_eduyear,iStr_Edukey.str_empseq)

ib_any_typing = False
end event

type dw_ins from u_key_enter within w_pig5010a
event ue_key pbm_dwnkey
integer x = 59
integer y = 256
integer width = 4357
integer height = 1752
integer taborder = 20
string dataobject = "d_pig5010a2"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;call super::editchanged;ib_any_typing = True
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;String   sStart,sEnd,sStartTime,sEndTime,sEmpNo,sEmpNm,sNull
Integer  iDateSu

if this.GetColumnName() ="startdate"THEN
	sStart = Trim(this.GetText())
	if sStart = '' or IsNull(sStart) then Return
	
	if F_DateChk(sStart) = -1 then
		MessageBox("확 인", "유효한 날짜가 아닙니다.")
		this.SetItem(this.GetRow(),"startdate",   sNull)
		Return 1
	end if
	
	sEnd = this.GetItemstring(this.GetRow(),"enddate")
	if sEnd = '' or IsNull(sEnd) then Return
	
	this.SetItem(this.GetRow(),"datesu", Wf_Date(sStart,sEnd))
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'datesu' then
	iDateSu = Integer(this.GetText())
	if iDateSu = 0 or IsNull(iDateSu) then Return
	
	this.setItem(this.GetRow(), 'ehour', iDateSu * this.GetItemNumber(this.GetRow(),"temp1")) 	
end if

if this.GetColumnName() ="enddate"THEN
	sEnd = Trim(this.GetText())
	if sEnd = '' or IsNull(sEnd) then Return
	
	if F_DateChk(sEnd) = -1 then
		MessageBox("확 인", "유효한 날짜가 아닙니다.")
		this.SetItem(this.GetRow(),"enddate",   sNull)
		Return 1
	end if
	
	sStart = this.GetItemstring(this.GetRow(),"startdate")
	if sStart = '' or IsNull(sStart) then Return
	
	this.SetItem(this.GetRow(),"datesu", Wf_Date(sStart,sEnd))
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'starttime' then
	sStartTime = this.GetText()
	if sStartTime = '' or IsNull(sStartTime) then Return
	
	if IsTime(string(long(sStartTime),'00:00')) = False then
		MessageBox('확 인','유효한 시간이 아닙니다.')
		this.SetItem(this.GetRow(), "starttime",   sNull)
		Return 1
	end if
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'endtime' then
	sEndTime = this.GetText()
	if sEndTime = '' or IsNull(sEndTime) then Return
	
	if IsTime(string(long(sEndTime),'00:00')) = False then
		MessageBox('확 인','유효한 시간이 아닙니다.')
		this.SetItem(this.GetRow(), "endtime",   sNull)
		Return 1
	end if
	
	this.AcceptText()
	this.setItem(this.GetRow(), 'ehour', this.GetItemNumber(this.GetRow(),"datesu") * this.GetItemNumber(this.GetRow(),"temp1")) 
end if

if this.GetColumnName() = 'eduteacher'  then
	sEmpno = this.GetText()
	if sEmpno = '' or IsNull(sEmpNo) then
		this.SetItem(this.GetRow(),"empname",   sNull)
		Return
	end if
	
	select a.empname	into :sEmpNm from p1_master a	where a.empno = :sEmpNo;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','등록되어 있는 사번이 아닙니다.확인하십시요.')
		this.SetItem(this.GetRow(),"eduteacher", sNull)
		this.SetItem(this.GetRow(),"empname",    sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"empname",   sEmpNm)
end if


end event

event rbuttondown;call super::rbuttondown;if this.GetColumnName() = 'eduteacher'  then
	SetNull(Gs_Code);		SetNull(Gs_CodeName);
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"eduteacher",  Gs_Code)
   this.TriggerEvent(ItemChanged!)	
end if
end event

type dw_dsp from datawindow within w_pig5010a
integer x = 37
integer y = 24
integer width = 2414
integer height = 220
string dataobject = "d_pig5010a1"
boolean border = false
boolean livescroll = true
end type

type p_ins from uo_picture within w_pig5010a
integer x = 3730
integer y = 16
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event clicked;call super::clicked;Integer  il_currow,il_functionvalue

IF dw_ins.RowCount() <=0 THEN 
	il_currow = 0
ELSE
	il_currow = dw_ins.GetRow() 
	
	if wf_requiredchk(il_currow) = -1 then Return
END IF

il_currow = il_currow + 1

dw_ins.InsertRow(il_currow)

dw_ins.setitem(il_currow, 'companycode', Gs_Company)
dw_ins.setitem(il_currow, 'empno',       iStr_EduKey.str_empno)
dw_ins.setitem(il_currow, 'eduyear',     iStr_EduKey.str_eduyear)
dw_ins.setitem(il_currow, 'empseq',      iStr_EduKey.str_empseq)

dw_ins.ScrollToRow(il_currow)
dw_ins.setcolumn('startdate')
dw_ins.setfocus()	

ib_any_typing = True


end event

type p_exit from uo_picture within w_pig5010a
integer x = 4251
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event clicked;call super::clicked;
if ib_any_typing = True then
	if MessageBox('확 인','저장하지 않은 자료가 존재합니다.저장하시겠습니까?',Question!,YesNo!) = 2 then
		rollback;
	else
		p_mod.TriggerEvent(Clicked!)
	end if
end if

Close(Parent)
end event

type p_del from uo_picture within w_pig5010a
integer x = 4078
integer y = 16
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event clicked;call super::clicked;if dw_ins.AcceptText() = -1 then return

if dw_ins.GetRow() <=0 then return

IF f_dbconfirm("삭제") = 2 THEN RETURN

dw_ins.DeleteRow(0)
IF dw_ins.update()= 1 THEN
	COMMIT;
	ib_any_typing = False
ELSE
	MessageBox('확 인','자료삭제를 실패하였습니다.')
	ROLLBACK;
END IF
end event

type p_mod from uo_picture within w_pig5010a
integer x = 3904
integer y = 16
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event clicked;call super::clicked;IF dw_ins.GetRow() <=0 THEN Return
IF dw_ins.AcceptText() = -1 then return 

IF Wf_RequiredChk(dw_ins.GetRow()) = -1 THEN Return

IF f_dbconfirm("저장") = 2 THEN RETURN

IF dw_ins.Update() > 0 THEN			
	COMMIT;
	ib_any_typing = False
ELSE
	MessageBox('확 인','자료저장을 실패하였습니다.')
	ROLLBACK;
	Return
END IF
end event

type rr_1 from roundrectangle within w_pig5010a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 248
integer width = 4384
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

