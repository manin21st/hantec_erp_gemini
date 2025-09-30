$PBExportHeader$w_qct_02540.srw
$PBExportComments$** 목표대비 제안 실적 현황
forward
global type w_qct_02540 from w_standard_dw_graph
end type
end forward

global type w_qct_02540 from w_standard_dw_graph
string title = "목표대비 제안실적 현황"
end type
global w_qct_02540 w_qct_02540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gu, sdate, edate, buse, bunm, jechgu, s_jechgu, okgub, s_okgub, simdpt

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gu = trim(dw_ip.object.gu[1])
sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
buse = trim(dw_ip.object.buse[1])
bunm = trim(dw_ip.object.bunm[1])
jechgu = trim(dw_ip.object.jechgu[1])
okgub = trim(dw_ip.object.okgub[1])
simdpt = trim(dw_ip.object.simdpt[1])

if jechgu = "1" then
   s_jechgu = "일반제안"
elseif jechgu = "2" then
   s_jechgu = "테마제안"
else
   s_jechgu = "ALL"
end if

if (IsNull(sdate) or sdate = "")  then sdate = "100001"
if (IsNull(edate) or edate = "")  then edate = "999912"
if (IsNull(simdpt) or simdpt = "")  then simdpt = "%"

if gu = "1" then //개인별
   if (IsNull(buse) or buse = "")  then 
	   f_message_chk(1400,"[부서코드]")
	   dw_ip.SetColumn("buse")
	   dw_ip.SetFocus()
	   return -1
   end if
	dw_list.dataobject = "d_qct_02540_02"
   dw_list.SetTransObject(SQLCA)
	dw_list.object.txt_ymd.text = String(sdate, "@@@@년@@월") + " - " + String(edate, "@@@@년@@월")
	dw_list.object.txt_buse.text = bunm
	dw_list.object.txt_jechgu.text = s_jechgu
	if dw_list.Retrieve(gs_sabu, sdate, edate, buse, jechgu, simdpt) <= 0 then
	   f_message_chk(50,'[목표대비 제안실적 현황-개인별]')
	   dw_ip.Setfocus()
	   return -1
   end if
elseif gu = "2" then //제안부서별
   if (IsNull(buse) or buse = "")  then 
	   f_message_chk(1400,"[부서코드]")
	   dw_ip.SetColumn("buse")
	   dw_ip.SetFocus()
	   return -1
   end if
	if okgub = '1' then
	   dw_list.dataobject = "d_qct_02540_03"
		s_okgub = "제출건수"
	else
		dw_list.dataobject = "d_qct_02540_13"
		s_okgub = "채택건수"
	end if	
   dw_list.SetTransObject(SQLCA)
	dw_list.object.txt_ymd.text = String(sdate, "@@@@년@@월") + " - " + String(edate, "@@@@년@@월")
   dw_list.object.txt_title.text = "(" + bunm + ")" + "과/팀별 " + s_okgub + " 목표대비 제안실적 현황"
	dw_list.object.txt_jechgu.text = s_jechgu
	if dw_list.Retrieve(gs_sabu, sdate, edate, buse, jechgu, simdpt) <= 0 then
	   f_message_chk(50,'[목표대비 제안실적 현황-과/팀별]')
	   dw_ip.Setfocus()
	   return -1
   end if
elseif gu = "3" then //집계부서별	
	if okgub = '1' then
	   dw_list.dataobject = "d_qct_02540_04"
		s_okgub = "제출건수"
	else
		dw_list.dataobject = "d_qct_02540_14"
		s_okgub = "채택건수"
	end if	
   dw_list.SetTransObject(SQLCA)
	dw_list.object.txt_ymd.text = String(sdate, "@@@@년@@월") + " - " + String(edate, "@@@@년@@월")
	dw_list.object.txt_jechgu.text = s_jechgu
   dw_list.object.txt_title.text = "부서별 " + s_okgub + " 목표대비 제안실적 현황"
	if dw_list.Retrieve(gs_sabu, sdate, edate, jechgu, simdpt) <= 0 then
	   f_message_chk(50,'[목표대비 제안실적 현황-부서별]')
	   dw_ip.Setfocus()
	   return -1
   end if
end if

return 1
end function

on w_qct_02540.create
call super::create
end on

on w_qct_02540.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_02540
end type

type p_print from w_standard_dw_graph`p_print within w_qct_02540
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_02540
end type

type st_window from w_standard_dw_graph`st_window within w_qct_02540
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_02540
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_02540
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_02540
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_02540
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_02540
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_02540
integer x = 46
integer y = 0
integer width = 3095
integer height = 260
string dataobject = "d_qct_02540_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
	   f_message_chk(35,"[시작년월]")
	   this.object.sdate[1] = ""
	   return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
	   f_message_chk(35,"[끝년월]")
	   this.object.sdate[1] = ""
	   return 1
	end if
elseif (this.GetColumnName() = "gu") Then
	if s_cod = "1" then //개인별
	   this.object.dpt_txt.text = "소속(과/팀)"
	elseif s_cod = "2" then //제안부서
	   this.object.dpt_txt.text = "부서"
	end if	
elseif (this.GetColumnName() = "buse") Then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.buse[1] = s_cod
	this.object.bunm[1] = s_nam1
	return i_rtn
end if

end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "buse"	THEN		
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "buse", gs_code)
	this.SetItem(1, "bunm", gs_codename)
END IF

end event

event dw_ip::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_02540
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_02540
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_02540
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_02540
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_02540
integer y = 288
integer height = 2024
string dataobject = "d_qct_02540_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_02540
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_02540
integer y = 276
integer height = 2056
end type

