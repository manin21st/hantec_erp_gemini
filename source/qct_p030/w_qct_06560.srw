$PBExportHeader$w_qct_06560.srw
$PBExportComments$** 생산팀별 A/S 원인표
forward
global type w_qct_06560 from w_standard_dw_graph
end type
end forward

global type w_qct_06560 from w_standard_dw_graph
string title = "생산팀별 A/S 원인표"
end type
global w_qct_06560 w_qct_06560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ym, pdt1, pdt2, gubun, pdtnm

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

ym = Trim(dw_ip.object.ym[1])
pdt1 = Trim(dw_ip.object.pdt1[1])
pdt2 = Trim(dw_ip.object.pdt2[1])
gubun = Trim(dw_ip.object.gubun[1])
if (IsNull(ym) or ym = "")  then 
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

if IsNull(pdt1) or pdt1 = "" then pdt1 = "."
if IsNull(pdt2) or pdt2 = "" then pdt2 = "ZZZZZZ"

if pdt1 = pdt2 then
	select rfna1 into :pdtnm
	  from reffpf
	 where rfcod = '03' and rfgub = :pdt1;
	if sqlca.sqlcode <> 0 or IsNull(pdtnm) then pdtnm = "생산팀별"
	dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 (" + pdtnm + ") A/S 원인표")
else
	dw_list.object.txt_title.text = String(ym,"@@@@년 @@월 생산팀별 A/S 원인표")
end if

if dw_list.Retrieve(gs_sabu, ym, pdt1, pdt2, gubun) <= 0 then
	f_message_chk(50,'[생산팀별 A/S 원인표]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

on w_qct_06560.create
call super::create
end on

on w_qct_06560.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_qct_06560
end type

type p_print from w_standard_dw_graph`p_print within w_qct_06560
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_06560
end type

event p_retrieve::clicked;call super::clicked;pb_color.Enabled =False
pb_graph.Enabled =False
pb_space.Enabled =False
pb_title.Enabled =False

end event

type st_window from w_standard_dw_graph`st_window within w_qct_06560
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_06560
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_06560
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_06560
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_06560
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_06560
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_06560
integer x = 37
integer y = 0
integer width = 1518
integer height = 252
string dataobject = "d_qct_06560_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "ym" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_06560
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_06560
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_06560
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_06560
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_06560
integer y = 276
integer height = 2036
string dataobject = "d_qct_06560_02"
end type

event dw_list::doubleclicked;//
end event

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_06560
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_06560
integer y = 264
integer height = 2068
end type

