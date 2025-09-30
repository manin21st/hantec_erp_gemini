$PBExportHeader$w_qct_01510.srw
$PBExportComments$**수입검사현황(출력)
forward
global type w_qct_01510 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_01510
end type
type pb_2 from u_pb_cal within w_qct_01510
end type
type pb_3 from u_pb_cal within w_qct_01510
end type
type rr_1 from roundrectangle within w_qct_01510
end type
end forward

global type w_qct_01510 from w_standard_print
string title = "수입검사현황"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
rr_1 rr_1
end type
global w_qct_01510 w_qct_01510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   sStdYmd, sFrmDate, sToDate, sDay1, sDay2, sDay3, sDay4, sDay5, sNull, semps, sempe, &
			sittyp, sgubun

SetNull(sNull)
if dw_ip.AcceptText() = -1 then return -1

sgubun   = trim(dw_ip.GetItemString(1,"gubun"))
sStdYmd  = trim(dw_ip.GetItemString(1,"stdymd"))
sFrmDate = trim(dw_ip.GetItemString(1,"frmdate"))
sToDate  = trim(dw_ip.GetItemString(1,"todate"))
sEmps		= dw_ip.GetItemString(1,"sEmpno")
sEmpe	   = dw_ip.GetItemString(1,"eEmpno")
sittyp   = dw_ip.GetItemString(1,"ittyp")

if sgubun = '1' then /* 일별인 경우에만 check */
	if isnull(sstdymd) or sstdymd = ''  then
		f_message_chk(30,'[기준일자]')
		dw_ip.SetColumn("stdymd")
		dw_ip.SetFocus()	
		return -1
	end if
end if

String sdate, edate

f_weekly(f_today(), '2','1',sdate,edate)

if isnull(sfrmdate) or trim(sfrmdate) = ''  then sfrmdate = sdate

if isnull(stodate) or trim(stodate) = ''  then stodate = edate

if isnull(sittyp) or trim(sittyp) = ''  then sittyp = '%'

if sFrmDate > sToDate then
  	f_message_chk(34,'[기간누계일자]')
	dw_ip.SetColumn("frmdate")
	dw_ip.SetFocus()	
   return -1
end if

sDay1 = f_afterday(sStdYmd,-1)
sDay2 = f_afterday(sStdYmd,-2)
sDay3 = f_afterday(sStdYmd,-3)
sDay4 = f_afterday(sStdYmd,-4)
sDay5 = f_afterday(sStdYmd,-5)

if isnull(semps) or trim(semps) = '' then
	semps = '.'
end if

if isnull(sempe) or trim(sempe) = '' then
	sempe = 'ZZZZZZ'
end if

//if sgubun = '1' then // 일별 수입검사현황
//	IF dw_list.Retrieve(gs_sabu, sStdYmd, sFrmDate, sToDate, sDay1, sDay2, sDay3, sDay4, sDay5, semps, sempe, sittyp) < 1 THEN
//		f_message_chk(50,"[일별 수입 검사 현황]")
//		dw_ip.SetColumn("stdymd")
//		dw_ip.SetFocus()
//		return -1
//	END IF
//else
//	IF dw_list.Retrieve(gs_sabu, sFrmDate, sToDate, semps, sempe, sittyp) < 1 THEN
//		f_message_chk(50,"[기간별 수입 검사 현황]")
//		dw_ip.SetColumn("frmdate")
//		dw_ip.SetFocus()
//		return -1
//	END IF	
//end if

if sgubun = '1' then // 일별 수입검사현황
	IF dw_list.Retrieve(gs_sabu, sStdYmd, sFrmDate, sToDate, sDay1, sDay2, sDay3, sDay4, sDay5, semps, sempe, sittyp) < 1 THEN
		f_message_chk(50,"[일별 수입 검사 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
//		dw_print.insertrow(0)
//		return -1
	END IF
else
	IF dw_list.Retrieve(gs_sabu, sFrmDate, sToDate, semps, sempe, sittyp) < 1 THEN
		f_message_chk(50,"[기간별 수입 검사 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
//		dw_print.insertrow(0)
//		return -1
	END IF	
end if

//dw_print.ShareData(dw_list)

Return 1
end function

on w_qct_01510.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_01510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rr_1)
end on

event open;call super::open;String sdate, edate

f_weekly(f_today(), '2','1',sdate,edate)
  
dw_ip.SetItem(1,"stdymd",is_today)
dw_ip.SetItem(1,"frmdate",sdate)
dw_ip.SetItem(1,"todate",edate)

dw_list.SharedataOff()


end event

type p_preview from w_standard_print`p_preview within w_qct_01510
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_qct_01510
end type

type p_print from w_standard_print`p_print within w_qct_01510
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_qct_01510
end type







type st_10 from w_standard_print`st_10 within w_qct_01510
end type



type dw_print from w_standard_print`dw_print within w_qct_01510
string dataobject = "d_qct_01511_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01510
integer x = 23
integer y = 12
integer width = 3154
integer height = 196
string dataobject = "d_qct_01510"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string sdate, sNull, sname

Setnull(snull)

this.accepttext()

if this.GetColumnName() = 'gubun' THEN
	sDate = TRIM(this.gettext())
	if sDate = '1' then
		dw_list.dataobject = 'd_qct_01511_p'
//		dw_print.dataobject = 'd_qct_01511_p'
	else
		dw_list.dataobject = 'd_qct_01512_1_p'
//		dw_print.dataobject = 'd_qct_01512_1_p'
	end if

	dw_list.settransobject(sqlca)
//	dw_print.settransobject(sqlca)
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


elseIF this.GetColumnName() = 'ittyp' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	select rfna1 into :sname from reffpf where rfcod = '05' and rfgub = :sDate;
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[품목구분]')
		this.setitem(1, "ittyp", sNull)
		return 1
	end if
elseIF this.GetColumnName() = 'stdymd' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[기준일자]')
		this.setitem(1, "stdymd", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'frmdate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		if this.getitemstring(1, "gubun") = '1' then
			f_message_chk(35,'[기간누계 시작일자]')
		else
			f_message_chk(35,'[기간 시작일자]')
		end if
		this.setitem(1, "frmdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'todate' THEN

	sDate = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	
	IF f_datechk(sDate) = -1	then
		if this.getitemstring(1, "gubun") = '1' then
			f_message_chk(35,'[기간누계 종료일자]')
		else
			f_message_chk(35,'[기간 종료일자]')
		end if
		this.setitem(1, "todate", sNull)
		return 1
	END IF
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_01510
integer x = 73
integer y = 244
integer width = 4507
integer height = 2060
string dataobject = "d_qct_01511"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qct_01510
integer x = 2240
integer y = 32
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('frmdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'frmdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01510
integer x = 2693
integer y = 32
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('todate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'todate', gs_code)
end event

type pb_3 from u_pb_cal within w_qct_01510
integer x = 1083
integer y = 36
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('stdymd')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'stdymd', gs_code)
end event

type rr_1 from roundrectangle within w_qct_01510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 232
integer width = 4535
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

