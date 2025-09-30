$PBExportHeader$w_qct_04540.srw
$PBExportComments$** 생산팀별 A/S처리현황
forward
global type w_qct_04540 from w_standard_dw_graph
end type
type dw_1 from u_key_enter within w_qct_04540
end type
end forward

global type w_qct_04540 from w_standard_dw_graph
string title = "생산팀별 A/S처리현황(그래프)"
dw_1 dw_1
end type
global w_qct_04540 w_qct_04540

type variables
integer ii
end variables

forward prototypes
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve1 ();string gubun, gubname[2] = {"A/S", "전체(A/S+크레임)"}
string outgub, pdtgu1, pdtgu2, pym, cym, spym, scym
Long   i_rtn

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cym = trim(dw_ip.object.ym[1])
gubun = trim(dw_ip.object.gubun[1])
outgub = trim(dw_ip.object.outgub[1])

if (IsNull(gubun) or gubun = "")  then 
	f_message_chk(30,'[구분]')
	dw_ip.SetColumn("gubun")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(cym) or cym = "")  then
	f_message_chk(30,'[처리년월]')
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

pdtgu1 = trim(dw_ip.object.pdtgu1[1])  
pdtgu2 = trim(dw_ip.object.pdtgu2[1])  
if IsNull(pdtgu1) or Trim(pdtgu1) = "" then pdtgu1 = "."
if IsNull(pdtgu2) or Trim(pdtgu2) = "" then pdtgu2 = "ZZZZZZ"

pym 	= f_aftermonth(cym, -5)	
spym	= left(f_aftermonth(cym, -12), 6) + '01'
scym	= left(f_aftermonth(cym, -12), 6) + '12'

//////////////////////////////////////////////////////////////////////////////
// [SQL 설명]
// job : '1' - A/S, '2' - 전체(A/S + 크레임)
//
// gubun : '1' - A/S수, '2' - 전년 A/S수, '3' - 크레임수, '4' - 전년크레임수,
//         '5' - 6개월 판매수, '6' - 전년판매수
//////////////////////////////////////////////////////////////////////////////
dw_list.object.txt_ymd.text = String(trim(dw_ip.object.ym[1]), "@@@@년@@월") 
dw_list.object.gubname.text = gubname[Integer(gubun)]

setpointer(hourglass!)

if outgub = "1" then
	i_rtn = dw_list.Retrieve(gs_sabu, gubun, pym, cym, spym, scym, pdtgu1, pdtgu2)
else
	i_rtn = dw_list.Retrieve(gs_sabu, gubun, pym, cym, spym, scym, pdtgu1, pdtgu2)
end if	

if i_rtn <= 0 then
	f_message_chk(50,'[생산팀별 A/S 현황]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_retrieve2 ();string gubun, gubname[2] = {"A/S", "전체(A/S+크레임)"}
string pym, cym, spym, scym, spdtgu

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

cym = trim(dw_ip.object.ym[1])
gubun = trim(dw_ip.object.gubun[1])
spdtgu = trim(dw_ip.object.pdtgu1[1])
if (IsNull(gubun) or gubun = "")  then 
	f_message_chk(30,'[구분]')
	dw_ip.SetColumn("gubun")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(cym) or cym = "")  then 
	f_message_chk(30,'[처리년월]')
	dw_ip.SetColumn("ym")
	dw_ip.Setfocus()
	return -1
end if

if (IsNull(spdtgu) or trim(spdtgu) = "")  then  spdtgu = '%'

setpointer(hourglass!)

pym = f_aftermonth(cym, -5)
spym	= left(f_aftermonth(cym, -12), 6) + '01'
scym	= left(f_aftermonth(cym, -12), 6) + '12'
//////////////////////////////////////////////////////////////////////////////
// [dw_imsi의 field 설명]
// job : '1' - A/S, '2' - 전체(A/S + 크레임)
//
// gubun : '1' - A/S수, '2' - 전년 A/S수, '3' - 크레임수, '4' - 전년크레임수,
//         '5' - 6개월 판매수, '6' - 전년판매수
//////////////////////////////////////////////////////////////////////////////
dw_list.object.txt_ymd.text = String(trim(dw_ip.object.ym[1]), "@@@@년@@월") 
dw_list.object.gubname.text = gubname[Integer(gubun)]
if dw_list.Retrieve(gs_sabu, gubun, pym, cym, spym, scym, spdtgu) <= 0 then
	f_message_chk(50,'[생산팀별 A/S 현황(그래프)]')
	dw_ip.Setfocus()
	return -1
end if

return 1
end function

public function integer wf_retrieve ();string gubun
Integer i_rtn

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if

sle_msg.text = '자료를 출력중입니다............!!'

gubun = trim(dw_1.object.gubun[1])
if gubun = "1" then
   i_rtn = wf_retrieve1()
elseif gubun = "2" then
   i_rtn = wf_retrieve2()
end if	

sle_msg.text = ''

setpointer(arrow!)

return i_rtn

end function

on w_qct_04540.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_qct_04540.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)
dw_ip.setitem(1, "ym", left(f_today(), 6))
dw_1.SetFocus()
end event

type p_exit from w_standard_dw_graph`p_exit within w_qct_04540
end type

type p_print from w_standard_dw_graph`p_print within w_qct_04540
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_qct_04540
end type

event p_retrieve::clicked;call super::clicked;string gubun

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if

gubun = trim(dw_1.object.gubun[1])

if gubun <> "2" then
   pb_color.Enabled =False
   pb_graph.Enabled =False
   pb_space.Enabled =False
   pb_title.Enabled =False
end if	
end event

type st_window from w_standard_dw_graph`st_window within w_qct_04540
end type

type st_popup from w_standard_dw_graph`st_popup within w_qct_04540
end type

type pb_title from w_standard_dw_graph`pb_title within w_qct_04540
integer x = 4475
integer y = 184
end type

type pb_space from w_standard_dw_graph`pb_space within w_qct_04540
integer x = 4297
integer y = 184
end type

type pb_color from w_standard_dw_graph`pb_color within w_qct_04540
integer x = 4119
integer y = 184
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_qct_04540
integer x = 3941
integer y = 184
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_qct_04540
integer x = 1070
integer y = 4
integer width = 2834
integer taborder = 20
string dataobject = "d_qct_04530_01"
end type

event dw_ip::itemchanged;String s_cod, sdata, snull

dw_list.SetRedraw(False)
dw_list.ReSet()
dw_list.SetRedraw(True)

s_cod = Trim(this.GetText())
Setnull(sNull)

if this.GetColumnName() = "ym" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod+'01') = -1 then
		f_message_chk(35, "[처리년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "outgub" then 
	if s_cod = "1" then
		dw_list.DataObject = "d_qct_04530_03"
	elseif s_cod = "2" then
		dw_list.DataObject = "d_qct_04530_02"	
	end if
	dw_list.SetTransObject(SQLCA)	

	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
elseif this.getcolumnname() = "pdtgu1" then
	sdata = f_get_reffer('03', s_cod)
	if isnull(sdata) or trim(sdata) = '' then
		f_message_chk(33, "[생산팀]")
		this.object.pdtgu1[1] = snull
		return 1
	end if
elseif this.getcolumnname() = "pdtgu2" then
	sdata = f_get_reffer('03', s_cod)
	if isnull(sdata) or trim(sdata) = '' then
		f_message_chk(33, "[생산팀]")
		this.object.pdtgu2[1] = snull
		return 1
	end if
end if

//dw_list.object.datawindow.print.preview = "yes"	

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type sle_msg from w_standard_dw_graph`sle_msg within w_qct_04540
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_qct_04540
end type

type st_10 from w_standard_dw_graph`st_10 within w_qct_04540
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_qct_04540
end type

type dw_list from w_standard_dw_graph`dw_list within w_qct_04540
integer y = 252
integer width = 4567
string dataobject = "d_qct_04530_02"
end type

event dw_list::retrievestart;ii = 0
end event

event dw_list::retrieverow;/* 그래프인 경우에는 상위 10건만 선택 */
if dataobject = 'd_qct_04540_02' then
	ii++
	
	setitem(row, "titnm", '['+string(ii, "00") +']' + getitemstring(row, "titnm"))
	if ii > 9 then
		return 1
	end if
end if
end event

type gb_10 from w_standard_dw_graph`gb_10 within w_qct_04540
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_qct_04540
integer y = 240
integer height = 2092
end type

type dw_1 from u_key_enter within w_qct_04540
integer x = 9
integer y = 4
integer width = 1079
integer height = 220
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_04540_03"
boolean border = false
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)
dw_list.SetReDraw(False)
if gubun = "1" then //생산팀별A/S현황
	dw_ip.DataObject = "d_qct_04530_01"
	dw_list.DataObject = "d_qct_04530_02"
elseif gubun = "2" then	//생산팀별A/S현황(그래프)
	dw_ip.DataObject = "d_qct_04540_01"
	dw_list.DataObject = "d_qct_04540_02"
end if	

dw_ip.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.setitem(1, "ym", left(f_today(), 6))
dw_ip.SetReDraw(True)

dw_list.SetTransObject(SQLCA)
dw_list.ReSet()
dw_list.SetReDraw(True)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

return
end event

