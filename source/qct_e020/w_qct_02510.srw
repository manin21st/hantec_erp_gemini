$PBExportHeader$w_qct_02510.srw
$PBExportComments$** 부서별 제안 현황
forward
global type w_qct_02510 from w_standard_dw_graph
end type
type pb_1 from u_pb_cal within w_qct_02510
end type
type pb_2 from u_pb_cal within w_qct_02510
end type
end forward

global type w_qct_02510 from w_standard_dw_graph
string title = "부서별 제안 현황"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02510 w_qct_02510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate, jegu, gu, dptgu, jipdpt, jipdptnm, simdpt
String  s_jegu[3] = {"일반제안", "테마제안", "ALL"}
Long i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
jegu  = trim(dw_ip.object.jegu[1])
gu    = trim(dw_ip.object.gu[1])
dptgu = trim(dw_ip.object.dptgu[1])
jipdpt = trim(dw_ip.object.jipdpt[1])
jipdptnm = trim(dw_ip.object.jipdptnm[1])
simdpt = trim(dw_ip.object.simdpt[1])

if dptgu = "1" then //제안부서
   if (IsNull(jipdpt) or jipdpt = "")  then
      f_message_chk(1400,'[집계부서]')
	   dw_ip.SetColumn("jipdpt")
	   dw_ip.Setfocus()
	   return -1
	end if	

   CHOOSE CASE gu
		CASE "1" //부서별 제안 제출/채택/실시 건수 현황
			dw_list.DataObject = "d_qct_02510_02"
		CASE "2" //부서별 제안실시 소요경비/절감금액
			dw_list.DataObject = "d_qct_02510_03"
		CASE "3" //부서별 제안점수 현황
			dw_list.DataObject = "d_qct_02510_04"
	END CHOOSE
else //집계부서
   CHOOSE CASE gu
		CASE "1" //부서별 제안 제출/채택/실시 건수 현황
			dw_list.DataObject = "d_qct_02510_12"
		CASE "2" //부서별 제안실시 소요경비/절감금액
			dw_list.DataObject = "d_qct_02510_13"
		CASE "3" //부서별 제안점수 현황
			dw_list.DataObject = "d_qct_02510_14"
	END CHOOSE
end if

dw_list.SetTransObject(SQLCA)

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
dw_list.object.txt_jegu.text = s_jegu[Integer(jegu)]
if jegu = "3" then jegu = "%"
if (IsNull(simdpt) or simdpt = "")  then simdpt = "%"

if dptgu = "1" then //제안부서
   dw_list.object.txt_title.text = "(" + jipdptnm + ")" + "과/팀별 제안 현황"
   i_rtn = dw_list.Retrieve(gs_sabu, sdate, edate, jegu, jipdpt, simdpt)
else
   i_rtn = dw_list.Retrieve(gs_sabu, sdate, edate, jegu, simdpt)
end if

if i_rtn <= 0 then
   f_message_chk(50,'[부서별 제안 현황]')
   dw_ip.Setfocus()
   return -1
end if
	
return 1
end function

on w_qct_02510.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_02510.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_02510
end type

type p_print from w_standard_dw_graph`p_print within w_qct_02510
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_02510
end type

type st_window from w_standard_dw_graph`st_window within w_qct_02510
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_02510
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_02510
integer x = 3785
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_02510
integer x = 3607
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_02510
integer x = 3429
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_02510
integer x = 3250
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_02510
integer x = 32
integer y = 0
integer width = 3109
integer height = 312
string dataobject = "d_qct_02510_01"
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
END IF
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_02510
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_02510
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_02510
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_02510
integer x = 3218
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_02510
integer y = 332
integer height = 1980
string dataobject = "d_qct_02510_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_02510
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_02510
integer y = 320
integer height = 2012
end type

type pb_1 from u_pb_cal within w_qct_02510
integer x = 357
integer y = 64
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02510
integer x = 777
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

