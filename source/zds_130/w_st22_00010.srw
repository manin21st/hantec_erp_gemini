$PBExportHeader$w_st22_00010.srw
$PBExportComments$** 계측기 그룹 등록
forward
global type w_st22_00010 from w_inherite
end type
type dw_1 from datawindow within w_st22_00010
end type
type st_2 from statictext within w_st22_00010
end type
type st_3 from statictext within w_st22_00010
end type
type st_4 from statictext within w_st22_00010
end type
type rr_1 from roundrectangle within w_st22_00010
end type
end forward

global type w_st22_00010 from w_inherite
integer width = 5650
integer height = 3316
string title = "계측기 그룹 등록"
dw_1 dw_1
st_2 st_2
st_3 st_3
st_4 st_4
rr_1 rr_1
end type
global w_st22_00010 w_st22_00010

forward prototypes
public function integer wf_required_chk ()
public subroutine wf_initial ()
end prototypes

public function integer wf_required_chk ();long		ix, lrow
string	scode, sname, sgubun

lrow = dw_insert.RowCount()
FOR ix = lrow To 1 Step -1
	sgubun = dw_1.getitemstring(1,'gubun')
	
	scode = dw_insert.getitemstring(ix,'grgrco')
	if isnull(scode) or scode = '' then
		messagebox('확인','그룹코드를 입력하세요!!!')
		dw_insert.setrow(ix)
		dw_insert.setcolumn('grgrco')
		dw_insert.scrolltorow(ix)
		dw_insert.setfocus()
		return -1
	end if
	
	if sgubun = 'G' then
		if left(scode,1) <> 'G' then
			messagebox('확인','계측기그룹코드는 G로 시작해야합니다!!!')
			dw_insert.setrow(ix)
			dw_insert.setcolumn('grgrco')
			dw_insert.scrolltorow(ix)
			dw_insert.setfocus()
			return -1
		end if
	else
		if left(scode,1) <> 'C' then
			messagebox('확인','C/F그룹코드는 C로 시작해야합니다!!!')
			dw_insert.setrow(ix)
			dw_insert.setcolumn('grgrco')
			dw_insert.scrolltorow(ix)
			dw_insert.setfocus()
			return -1
		end if
	end if		
		
	sname = dw_insert.getitemstring(ix,'grname')
	if isnull(sname) or sname = '' then
		messagebox('확인','그룹명을 입력하세요!!!')
		dw_insert.setrow(ix)
		dw_insert.setcolumn('grname')
		dw_insert.scrolltorow(ix)
		dw_insert.setfocus()
		return -1
	end if
	
	dw_insert.SetItem(ix,'sabu',gs_sabu)
NEXT

return 1
end function

public subroutine wf_initial ();dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)
dw_1.setfocus()
ib_any_typing = false
end subroutine

on w_st22_00010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.rr_1
end on

on w_st22_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_st22_00010
integer x = 37
integer y = 220
integer width = 4562
integer height = 1932
integer taborder = 20
string dataobject = "d_st22_00010_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;ib_any_typing = True //입력필드 변경여부 Yes


end event

event dw_insert::rbuttondown;call super::rbuttondown;long	lrow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lrow = this.getrow()
if lrow < 1 then return

if this.getcolumnname() = 'impdept' then
	open(w_vndmst_4_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(lrow,'impdept',gs_code)
	this.triggerevent(itemchanged!)
end if
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;If Row <= 0 then
	dw_insert.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)

END IF
end event

type p_delrow from w_inherite`p_delrow within w_st22_00010
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_st22_00010
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_st22_00010
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_st22_00010
integer x = 3904
end type

event p_ins::clicked;call super::clicked;Long ll_r

If dw_insert.GetRow() > 0 Then
	ll_r = dw_insert.InsertRow(dw_insert.GetRow() + 1 )	
Else
	ll_r = dw_insert.InsertRow(0)
End If

//dw_insert.setitem(ll_r,'sabu',dw_1.getitemstring(1,'gubun'))
dw_insert.SetColumn('grgrco')
dw_insert.ScrollToRow(ll_r)
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_st22_00010
integer x = 4425
end type

type p_can from w_inherite`p_can within w_st22_00010
integer x = 4251
end type

event p_can::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_st22_00010
boolean visible = false
integer x = 4713
integer y = 340
end type

event p_print::clicked;call super::clicked;if dw_1.accepttext() = -1 then return

gs_code  	 = dw_1.getitemstring(1, "sdate")
gs_codename  = dw_1.getitemstring(1, "edate")

if isnull(gs_code) or trim(gs_code) = '' then
	gs_code = '10000101'
end if

if isnull(gs_codename) or trim(gs_codename) = '' then
	gs_codename = '99991231'
end if

open(w_qct_01075_1)

Setnull(gs_code)
Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_st22_00010
integer x = 3557
end type

event p_inq::clicked;string	scode, sname, sgubun

if dw_1.accepttext() = -1 then return

sgubun = trim(dw_1.getitemstring(1,'gubun'))

scode = trim(dw_1.getitemstring(1,'code'))
if isnull(scode) or scode = "" then 
	scode = '%'
else
	scode = scode + '%'
end if

sname = trim(dw_1.getitemstring(1,'name'))
if isnull(sname) or sname = "" then 
	sname = '%'
else
	sname = '%' + sname + '%'
end if

setpointer(hourglass!)
dw_insert.setredraw(false)
if dw_insert.retrieve(gs_sabu,scode,sname,sgubun) < 1 then
	dw_insert.setredraw(true)
	f_message_chk(50, '[계측기 그룹 등록]')
	dw_1.setfocus()
	return
end if
dw_insert.setredraw(true)
ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_st22_00010
integer x = 4078
end type

event p_del::clicked;call super::clicked;long		lrow, ll_cnt, ll_mes
String ls_grgrco

lrow = dw_insert.getrow()

if lrow < 1 then return

ls_grgrco = TRIM(dw_insert.GetItemString(lrow,'grgrco'))

SELECT COUNT(*) INTO :ll_cnt FROM MESMST WHERE GRPCODE = :ls_grgrco;
 

IF ll_cnt > 0 THEN
	MessageBox("알림","계측기 마스터에 계측기 그룹을 사용중입니다. 삭제하시려면 계측기마스터 등록에서 삭제하십시요")
	RETURN
ELSE
	dw_insert.deleterow(0)
	if dw_insert.update() <> 1 then
		rollback ;
		messagebox("저장실패", "계측기 그룹 삭제 실패!!!")
	return
	end if
	COMMIT;
END IF


end event

type p_mod from w_inherite`p_mod within w_st22_00010
integer x = 3730
end type

event p_mod::clicked;if dw_insert.accepttext() = -1 then return
if wf_required_chk() = -1 then return
if f_msg_update() = -1 then return

setpointer(hourglass!)
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("저장실패", "계측기 그룹 등록 실패!!!")
	return
end if
commit ;

ib_any_typing = false
p_inq.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_st22_00010
end type

type cb_mod from w_inherite`cb_mod within w_st22_00010
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_st22_00010
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_st22_00010
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_st22_00010
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_st22_00010
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_st22_00010
end type

type cb_can from w_inherite`cb_can within w_st22_00010
end type

type cb_search from w_inherite`cb_search within w_st22_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_st22_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_st22_00010
end type

type dw_1 from datawindow within w_st22_00010
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 16
integer width = 2295
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_st22_00010_1"
boolean border = false
end type

event type long ue_pressenter();Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.getcolumnname() = 'deptcode' then
	open(w_vndmst_4_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(1,'deptcode',gs_code)
	this.triggerevent(itemchanged!)

elseif this.getcolumnname() = 'empno' then
	open(w_sawon_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(1,'empno',gs_code)
	this.triggerevent(itemchanged!)
	
end if
end event

event itemchanged;string	sdept, sdeptname, sempno, sempname, snull

setnull(snull)
if this.getcolumnname() = 'deptcode' then
	sdept = this.gettext()
	
	if isnull(sdept) or sdept = '' then 
		this.setitem(1,'deptname',snull)
		return
	end if
	
	select deptname into :sdeptname from p0_dept
	 where deptcode = :sdept ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'deptname',sdeptname)
	else
		messagebox('확인','등록되지 않은 부서코드입니다.')
		this.setitem(1,'deptcode',snull)
		this.setitem(1,'deptname',snull)
		return 1
	end if
	
elseif this.getcolumnname() = 'empno' then
	sempno = this.gettext()
	
	if isnull(sempno) or sempno = '' then 
		this.setitem(1,'empname',snull)
		return
	end if
	
	select empname, deptcode, fun_get_dptno(deptcode) into :sempname, :sdept, :sdeptname from p1_master
	 where empno = :sempno ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'empname',sempname)
		this.setitem(1,'deptcode',sdept)
		this.setitem(1,'deptname',sdeptname)
	else
		messagebox('확인','등록되지 않은 사원코드입니다.')
		this.setitem(1,'empno',snull)
		this.setitem(1,'empname',snull)
		this.setitem(1,'deptcode',snull)
		this.setitem(1,'deptname',snull)
		return 1
	end if

elseif this.getcolumnname() = 'gubun' then
	dw_insert.reset()

end if
end event

type st_2 from statictext within w_st22_00010
integer x = 2322
integer y = 16
integer width = 453
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "※그룹코드기준"
boolean focusrectangle = false
end type

type st_3 from statictext within w_st22_00010
integer x = 2354
integer y = 76
integer width = 1175
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "-계측기: G로 시작하는 숫자  ( ex: G00001 )"
boolean focusrectangle = false
end type

type st_4 from statictext within w_st22_00010
integer x = 2354
integer y = 128
integer width = 1179
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "-C / F : C로 시작하는 숫자  ( ex: C00001 )"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_st22_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 4585
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

