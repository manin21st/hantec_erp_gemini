$PBExportHeader$w_qct_02530.srw
$PBExportComments$** 부서별 제안실적 현황
forward
global type w_qct_02530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_02530
end type
type pb_2 from u_pb_cal within w_qct_02530
end type
end forward

global type w_qct_02530 from w_standard_print
string title = "부서별 제안실적 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02530 w_qct_02530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, gu, dptgu, jipdpt, jipdptnm, jests, simdpt
string s_gu[3] = {"일반제안", "테마제안", "ALL"}, &
       s_jests[5] = {"제출", "채택", "실시", "미실시", "ALL"}
Long i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
gu = trim(dw_ip.object.gu[1])
dptgu = trim(dw_ip.object.dptgu[1])
jipdpt = trim(dw_ip.object.jipdpt[1])
jipdptnm = trim(dw_ip.object.jipdptnm[1])
jests = trim(dw_ip.object.jests[1])
simdpt = trim(dw_ip.object.simdpt[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(simdpt) or simdpt = "")  then simdpt = "%"
if isnull(jipdpt) or jipdpt = "" then jipdpt = '%'

//if dptgu = "1" then //제안부서
////   if (IsNull(jipdpt) or jipdpt = "")  then jipdpt = '%'
////      f_message_chk(1400,'[집계부서]')
////	   dw_ip.SetColumn("jipdpt")
////	   dw_ip.Setfocus()
////	   return -1
////	end if	
//   
//   dw_list.DataObject = "d_qct_02530_02"
//   dw_print.DataObject = "d_qct_02530_02"
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//
//   dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
//   dw_list.object.txt_gu.text = s_gu[Integer(gu)]
//   dw_list.object.txt_jests.text = s_jests[Integer(jests)]
//
//	if isnull(jipdpt) or jipdpt = "%" then
//		dw_list.object.txt_title.text = "전체팀별 제안실적 현황"
//	else
//	   dw_list.object.txt_title.text = "(" + jipdptnm + ")" + " 과/팀별 제안실적 현황"	
//	end if
//	
//   if gu = "3" then gu = "%"
//   if jests = "5" then jests = "%"
//	i_rtn = dw_list.Retrieve(gs_sabu, sdate, edate, gu, jipdpt, jests, simdpt)
//else //집계부서
//   dw_list.DataObject = "d_qct_02530_03"
//   dw_print.DataObject = "d_qct_02530_03"
//	dw_list.SetTransObject(SQLCA)
//	dw_print.SetTransObject(SQLCA)
//	dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
//   dw_list.object.txt_gu.text = s_gu[Integer(gu)]
//   dw_list.object.txt_jests.text = s_jests[Integer(jests)]
//   if gu = "3" then gu = "%"
//   if jests = "5" then jests = "%"
//	i_rtn = dw_list.Retrieve(gs_sabu, sdate, edate, gu, jests, simdpt)
//end if
//
//if i_rtn <= 0 then
//	f_message_chk(50,'[부서별 제안실적 현황]')
//	dw_ip.Setfocus()
//	return -1
//end if

if dptgu = "1" then //제안부서
   dw_list.DataObject = "d_qct_02530_02"
   dw_print.DataObject = "d_qct_02530_02"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)

   dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
   dw_list.object.txt_gu.text = s_gu[Integer(gu)]
   dw_list.object.txt_jests.text = s_jests[Integer(jests)]

	if isnull(jipdpt) or jipdpt = "%" then
		dw_list.object.txt_title.text = "전체팀별 제안실적 현황"
	else
	   dw_list.object.txt_title.text = "(" + jipdptnm + ")" + " 과/팀별 제안실적 현황"	
	end if
	
   if gu = "3" then gu = "%"
   if jests = "5" then jests = "%"

	i_rtn = dw_print.Retrieve(gs_sabu, sdate, edate, gu, jipdpt, jests, simdpt)

else //집계부서
   dw_list.DataObject = "d_qct_02530_03"
   dw_print.DataObject = "d_qct_02530_03"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)

	dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
   dw_list.object.txt_gu.text = s_gu[Integer(gu)]
   dw_list.object.txt_jests.text = s_jests[Integer(jests)]

   if gu = "3" then gu = "%"
   if jests = "5" then jests = "%"

	i_rtn = dw_print.Retrieve(gs_sabu, sdate, edate, gu, jests, simdpt)

end if

dw_print.ShareData(dw_list)

if i_rtn <= 0 then
	f_message_chk(50,'[부서별 제안실적 현황]')
	dw_ip.Setfocus()
	dw_print.insertrow(0)
//	return -1
end if

return 1
end function

on w_qct_02530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_02530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_02530
end type

type p_exit from w_standard_print`p_exit within w_qct_02530
end type

type p_print from w_standard_print`p_print within w_qct_02530
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_02530
end type







type st_10 from w_standard_print`st_10 within w_qct_02530
end type



type dw_print from w_standard_print`dw_print within w_qct_02530
string dataobject = "d_qct_02530_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_02530
integer y = 0
integer width = 2770
integer height = 296
string dataobject = "d_qct_02530_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "jipdpt" then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.jipdpt[1] = s_cod
	this.object.jipdptnm[1] = s_nam1
	return i_rtn	
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "jipdpt"	THEN		
	open(w_vndmst_4_popup)
	this.SetItem(1, "jipdpt", gs_code)
	this.SetItem(1, "jipdptnm", gs_codename)
	return 
END IF
end event

type dw_list from w_standard_print`dw_list within w_qct_02530
string dataobject = "d_qct_02530_02"
end type

type pb_1 from u_pb_cal within w_qct_02530
integer x = 357
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02530
integer x = 795
integer y = 64
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

