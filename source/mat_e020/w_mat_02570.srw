$PBExportHeader$w_mat_02570.srw
$PBExportComments$수불구분별 입/출고 현황
forward
global type w_mat_02570 from w_standard_dw_graph
end type
end forward

global type w_mat_02570 from w_standard_dw_graph
string title = "수불구분별 입출고 현황"
end type
global w_mat_02570 w_mat_02570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, yyyy, itgub, s_itgub, mm, cym1, cym2, nym1, nym2, sgijun, swaigu

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gubun = trim(dw_ip.object.gubun[1])
yyyy = trim(dw_ip.object.yyyy[1])
itgub = trim(dw_ip.object.itgub[1])
mm = trim(dw_ip.object.mm[1])
sgijun = trim(dw_ip.object.gijun[1])
swaigu = trim(dw_ip.object.maip[1])

if (IsNull(yyyy) or yyyy = "")  then 
	f_message_chk(30,'[기준년도]')
	dw_ip.SetColumn("yyyy")
	dw_ip.Setfocus()
	return -1
end if
if (IsNull(mm) or mm = "")  then 
	f_message_chk(30,'[마감월]')
	dw_ip.SetColumn("mm")
	dw_ip.Setfocus()
	return -1
end if
if (IsNull(itgub) or itgub = "")  then 
	f_message_chk(30,'[품목구분]')
	dw_ip.SetColumn("itgub")
	dw_ip.Setfocus()
	return -1
end if

cym1 = yyyy + '01'
cym2 = yyyy + mm

if gubun = "1" then //계정별입고현황
	dw_list.DataObject = "d_mat_02570_02"
elseif gubun = "2" then //창고계정별입고현황
   dw_list.DataObject = "d_mat_02570_12"
elseif gubun = "3" then //계정별출고현황
   dw_list.DataObject = "d_mat_02570_52"
elseif gubun = "4" then //창고계정별출고현황
   dw_list.DataObject = "d_mat_02570_62"
end if
dw_list.SetTransObject(SQLCA)

dw_list.object.txt_yyyy.text = String(yyyy, "@@@@년")
dw_list.object.txt_mm.text = String(mm, "@@월")

select rfna1 into :s_itgub 
  from reffpf
 where rfcod = '05' and rfgub = :itgub;
 
if IsNull(s_itgub) or s_itgub = "" then s_itgub = " "
dw_list.object.txt_itgub.text = s_itgub

if dw_list.Retrieve(cym1, cym2, itgub, sgijun, swaigu) <= 0 then
	f_message_chk(50,'[계정별 입출고 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1

end function

on w_mat_02570.create
call super::create
end on

on w_mat_02570.destroy
call super::destroy
end on

type p_exit from w_standard_dw_graph`p_exit within w_mat_02570
end type

type p_print from w_standard_dw_graph`p_print within w_mat_02570
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_mat_02570
end type

event p_retrieve::clicked;call super::clicked;pb_color.Enabled =False
pb_graph.Enabled =False
pb_space.Enabled =False
pb_title.Enabled =False
end event

type st_window from w_standard_dw_graph`st_window within w_mat_02570
end type

type st_popup from w_standard_dw_graph`st_popup within w_mat_02570
end type

type pb_title from w_standard_dw_graph`pb_title within w_mat_02570
end type

type pb_space from w_standard_dw_graph`pb_space within w_mat_02570
end type

type pb_color from w_standard_dw_graph`pb_color within w_mat_02570
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_mat_02570
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_mat_02570
integer x = 14
integer y = 4
integer width = 3785
integer height = 200
string dataobject = "d_mat_02570_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "yyyy" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '0101') = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.yyyy[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "mm" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk('1999' + s_cod + '01') = -1 then
		f_message_chk(35, "[마감월]")
		this.object.mm[1] = ""
		return 1
	end if
end if

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_mat_02570
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_mat_02570
end type

type st_10 from w_standard_dw_graph`st_10 within w_mat_02570
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_mat_02570
end type

type dw_list from w_standard_dw_graph`dw_list within w_mat_02570
string dataobject = "d_mat_02570_02"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_mat_02570
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_mat_02570
end type

