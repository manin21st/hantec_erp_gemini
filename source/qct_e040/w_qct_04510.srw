$PBExportHeader$w_qct_04510.srw
$PBExportComments$** A/S접수및처리현황
forward
global type w_qct_04510 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_04510
end type
type pb_2 from u_pb_cal within w_qct_04510
end type
type rr_1 from roundrectangle within w_qct_04510
end type
end forward

global type w_qct_04510 from w_standard_print
integer height = 2628
string title = "샘플 접수 및 처리현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_04510 w_qct_04510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, assts, agecod, agenam, rcvdpt, rcvnam, rcvlog, rcvnm

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
assts = trim(dw_ip.object.assts[1])
agecod = trim(dw_ip.object.agecod[1])
agenam = trim(dw_ip.object.agenam[1])
rcvdpt = trim(dw_ip.object.rcvdpt[1])
rcvnam = trim(dw_ip.object.rcvnam[1])
rcvlog = trim(dw_ip.object.rcvlog[1])

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(assts) or assts = "")  then 
	assts = "%"
else
	assts = assts + "%"
end if
if (IsNull(agecod) or agecod = "")  then 
	agecod = "%"
else
	agecod = agecod + "%"
end if
if (IsNull(rcvdpt) or rcvdpt = "")  then 
	rcvdpt = "%"
else
	rcvdpt = rcvdpt + "%"
end if
if (IsNull(rcvlog) or rcvlog = "")  then 
	rcvlog = "%"
end if

dw_list.SetReDraw(False)
dw_list.ReSet()
dw_list.SetReDraw(True)

dw_list.object.txt_ymd.text = String(sdate, "@@@@.@@.@@ - ") + String(edate,"@@@@.@@.@@") 
if IsNull(agenam) or agenam = "" then
   dw_list.object.txt_agenam.text = "전체"
else
	dw_list.object.txt_agenam.text = agenam
end if
if IsNull(rcvnam) or rcvnam = "" then
   dw_list.object.txt_rcvnam.text = "전체"
else
	dw_list.object.txt_rcvnam.text = rcvnam
end if

if rcvlog = "%" then
	dw_list.object.txt_rcvlog.text = "전체"
else
  SELECT "REFFPF"."RFNA1"  
    INTO :rcvnm  
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" =  '1' ) AND  
         ( "REFFPF"."RFCOD" = '31' ) AND  
         ( "REFFPF"."RFGUB" = :rcvlog )   ;

	dw_list.object.txt_rcvlog.text = rcvnm

end if

IF dw_list.Retrieve(gs_sabu, sdate, edate, assts, agecod, rcvdpt, rcvlog) <= 0 then
	f_message_chk(50,'[A/S 접수 및 처리 현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
//	dw_print.insertrow(0)
//	Return -1
END IF

//dw_print.ShareData(dw_list)

return 1

end function

on w_qct_04510.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qct_04510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.SharedataOff()
end event

event ue_open;call super::ue_open;string ls_Date
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

ls_Date = f_today()
dw_ip.setitem(1,"sdate",Left(ls_Date,6)+'01')
dw_ip.SetItem(1, "edate", ls_Date)
dw_ip.setfocus()

end event

type p_preview from w_standard_print`p_preview within w_qct_04510
boolean enabled = true
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_qct_04510
end type

type p_print from w_standard_print`p_print within w_qct_04510
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within w_qct_04510
end type







type st_10 from w_standard_print`st_10 within w_qct_04510
end type



type dw_print from w_standard_print`dw_print within w_qct_04510
string dataobject = "d_qct_04510_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04510
integer x = 37
integer y = 36
integer width = 3392
integer height = 228
string dataobject = "d_qct_04510_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then //접수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then //접수일자
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "agecod" then //대리점
		i_rtn = f_get_name2("대리점", "N", s_cod, s_nam1, s_nam2)
		this.object.agecod[1] = s_cod
		this.object.agenam[1] = s_nam1
		return i_rtn
elseif this.GetColumnName() = "rcvdpt" then //의뢰부서
		i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
		this.object.rcvdpt[1] = s_cod
		this.object.rcvnam[1] = s_nam1
		return i_rtn
end if

end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "agecod" then //대리점 
	open(w_agent_popup)
	this.object.agecod[1] = gs_code
	this.object.agenam[1] = gs_codename
elseif this.getcolumnname() = "rcvdpt" then //의뢰부서
	open(w_vndmst_4_popup)
	this.object.rcvdpt[1] = gs_code
	this.object.rcvnam[1] = gs_codename
end if	

return
end event

type dw_list from w_standard_print`dw_list within w_qct_04510
integer x = 64
integer y = 284
integer width = 4526
integer height = 2036
string dataobject = "d_qct_04510_02_p"
end type

type pb_1 from u_pb_cal within w_qct_04510
integer x = 745
integer y = 60
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_04510
integer x = 1175
integer y = 60
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_04510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 268
integer width = 4571
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

