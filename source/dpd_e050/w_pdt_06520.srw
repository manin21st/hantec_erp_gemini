$PBExportHeader$w_pdt_06520.srw
$PBExportComments$** 설비마스터현황
forward
global type w_pdt_06520 from w_standard_print
end type
type dw_src from u_key_enter within w_pdt_06520
end type
type dw_dsc from u_key_enter within w_pdt_06520
end type
type st_1 from statictext within w_pdt_06520
end type
type st_2 from statictext within w_pdt_06520
end type
type st_3 from statictext within w_pdt_06520
end type
type rr_1 from roundrectangle within w_pdt_06520
end type
type rr_2 from roundrectangle within w_pdt_06520
end type
type rr_3 from roundrectangle within w_pdt_06520
end type
end forward

global type w_pdt_06520 from w_standard_print
string title = "설비마스터현황"
dw_src dw_src
dw_dsc dw_dsc
st_1 st_1
st_2 st_2
st_3 st_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pdt_06520 w_pdt_06520

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string mchno1, mchno2, dptno1, dptno2, gubun, sdate, edate, kegbn , outgubun, swrkctr1, swrkctr2
string s_ord, fgrcod, tgrcod
Long i

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

mchno1 = trim(dw_ip.object.mchno1[1])
mchno2 = trim(dw_ip.object.mchno2[1])
dptno1 = trim(dw_ip.object.dptno1[1])
dptno2 = trim(dw_ip.object.dptno2[1])
gubun  = trim(dw_ip.object.gubun[1])
sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
kegbn  = trim(dw_ip.object.kegbn[1])
fgrcod = trim(dw_ip.object.fgrcod[1])
tgrcod = trim(dw_ip.object.tgrcod[1])
outgubun = trim(dw_ip.object.prtgbn[1])
swrkctr1 = trim(dw_ip.object.wkctr1[1])
swrkctr2 = trim(dw_ip.object.wkctr2[1])

if (IsNull(mchno1) or mchno1 = "") then mchno1 = "."
if (IsNull(mchno2) or mchno2 = "") then mchno2 = "ZZZZZZ"
if (IsNull(dptno1) or dptno1 = "") then dptno1 = "."
if (IsNull(dptno2) or dptno2 = "") then dptno2 = "ZZZZZZ"
if (IsNull(fgrcod) or fgrcod = "") then fgrcod = "."
if (IsNull(tgrcod) or tgrcod = "") then tgrcod = "ZZZZ"
if (IsNull(sdate) or sdate = "") then sdate = "10000101" //초기일자는 변경시키면 안됨
if (IsNull(edate) or edate = "") then edate = "99991231" //이유? 데이타윈도우에 일자 셋팅

if (IsNull(swrkctr1) or swrkctr1 = "") then swrkctr1 = "."
if (IsNull(swrkctr2) or swrkctr2 = "") then swrkctr2 = "ZZZZZZ"

dw_list.SetFilter("") //구분 => ALL
dw_list.Filter( )

if gubun = "2" then //구분 => 보유
   dw_list.SetFilter("IsNull(pedat) or pedat = ''")
	dw_list.Filter( )
elseif gubun = "3" then //구분 => 폐기
	dw_list.SetFilter("not (IsNull(pedat) or pedat = '')")
	dw_list.Filter( )
end if	

if outgubun = '1' then

//		dw_list.object.txt_mchno.text = mchno1 + " - " + mchno2
		if dw_list.Retrieve(gs_sabu, mchno1, mchno2, dptno1, dptno2, sdate, edate, kegbn, fgrcod, tgrcod, swrkctr1, swrkctr2) <= 0 then
			f_message_chk(50,"[설비 마스터 현황]")
			dw_ip.Setfocus()
			return -1
		end if
		
		if dw_dsc.RowCount() < 1 then return 1
		dw_list.SetRedraw(false)
		s_ord = ""
		for i = 1 to dw_dsc.RowCount()
			 if i > 1 then s_ord = s_ord + ", "
			 s_ord = s_ord + dw_dsc.object.col[i] + " " + dw_dsc.object.sortgu[i]
		next
		dw_list.SetRedraw(true)		
		
		dw_list.SetSort(s_ord)
		dw_list.Sort()

		

		
		return 1
		
elseif outgubun = '2' then
	
	  	if dw_list.Retrieve(gs_sabu, mchno1, mchno2, dptno1, dptno2, sdate, edate, kegbn, fgrcod, tgrcod) <= 0 then
			f_message_chk(50,"[설비 마스터 현황]")
			dw_ip.Setfocus()
			return -1
		end if
		
		if dw_dsc.RowCount() < 1 then return 1
		dw_list.SetRedraw(false)
		s_ord = ""
		for i = 1 to dw_dsc.RowCount()
			 if i = 1 then 
				 s_ord = "maincd A, "
			 elseif i > 1 then 
				 s_ord = s_ord + ", "
			 end if
			 s_ord = s_ord + dw_dsc.object.col[i] + " " + dw_dsc.object.sortgu[i]
		next
		dw_list.SetSort(s_ord)
		dw_list.Sort()
		dw_list.GroupCalc()
		
		dw_list.SetRedraw(true)
		
		return 1
	
end if
	
end function

on w_pdt_06520.create
int iCurrent
call super::create
this.dw_src=create dw_src
this.dw_dsc=create dw_dsc
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_src
this.Control[iCurrent+2]=this.dw_dsc
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
end on

on w_pdt_06520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_src)
destroy(this.dw_dsc)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;Long i
String s_col

dw_src.SetTransObject(SQLCA)
dw_src.Retrieve()
for i = dw_src.RowCount() to 1 step -1
	s_col = Upper(dw_src.object.col[i])
	if s_col = "SABU" or s_col = "SPEC" or s_col = "IMGPATH" or s_col = "DAILYHR" then
		dw_src.DeleteRow(i)
	end if	
next

dw_dsc.settransobject(sqlca)

w_mdi_frame.sle_msg.text = "오른쪽 마우스 버튼을 CLICK하면 해당 항목의 정렬순서를 변경합니다!"

end event

type p_preview from w_standard_print`p_preview within w_pdt_06520
integer x = 4110
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_pdt_06520
integer x = 4453
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_pdt_06520
integer x = 4283
integer y = 32
integer taborder = 70
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06520
integer x = 3941
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_pdt_06520
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_pdt_06520
end type



type dw_print from w_standard_print`dw_print within w_pdt_06520
string dataobject = "d_pdt_06520_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06520
integer x = 59
integer y = 36
integer width = 3488
integer height = 344
string dataobject = "d_pdt_06520_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())
SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "mchno1" then 
	gs_gubun = 'ALL'
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnam1[1] = ""
		return
	end if	
	
	select mchnam into :s_nam1 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno1[1] = ""
	   this.object.mchnam1[1] = ""
	else
	   this.object.mchno1[1] = s_cod
	   this.object.mchnam1[1] = s_nam1
   end if
elseif this.GetColumnName() = "mchno2" then 
	gs_gubun = 'ALL'
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnam2[1] = ""
		return 
	end if	
	
	select mchnam into :s_nam1 from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno2[1] = ""
	   this.object.mchnam2[1] = ""
	else
	   this.object.mchno2[1] = s_cod
	   this.object.mchnam2[1] = s_nam1
   end if
elseif this.GetColumnName() = "dptno1" then 
	i_rtn = f_get_name2("부서","N", s_cod, s_nam1, s_nam2) 
	this.object.dptno1[1] = s_cod
	this.object.dptnm1[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "dptno2" then 
	i_rtn = f_get_name2("부서","N", s_cod, s_nam1, s_nam2) 
	this.object.dptno2[1] = s_cod
	this.object.dptnm2[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "prtgbn" then
	
	if s_cod = '1' then 
		dw_list.dataobject = "d_pdt_06520_02" 
	elseif s_cod = '2' then
		dw_list.dataobject = "d_pdt_06520_05"
	end if
	dw_list.settransobject(sqlca)   
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
elseif this.GetColumnName() = "wkctr1" then
	i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr1[1] = s_cod
	this.object.wcdsc1[1] = s_nam1

	return i_rtn
elseif this.GetColumnName() = "wkctr2" then
	i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
	this.object.wkctr2[1] = s_cod
	this.object.wcdsc2[1] = s_nam1

	return i_rtn
end if


end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "mchno1" then
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.object.mchno1[1] = gs_code
	this.object.mchnam1[1] = gs_codename
elseif this.GetColumnName() = "mchno2" then
	gs_gubun = 'ALL'
   open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.object.mchno2[1] = gs_code
	this.object.mchnam2[1] = gs_codename
elseif this.GetColumnName() = "dptno1" then 	
	open(w_vndmst_4_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.object.dptno1[1] = gs_code
	this.object.dptnm1[1] = gs_codename
elseif this.GetColumnName() = "dptno2" then 	
	open(w_vndmst_4_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.object.dptno2[1] = gs_code
	this.object.dptnm2[1] = gs_codename
elseif this.GetColumnName() = "wkctr1" then
	open(w_workplace_popup)
	If 	IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "wkctr1", gs_code)
	this.SetItem(1, "wcdsc1", gs_codename)
elseif this.GetColumnName() = "wkctr2" then
	open(w_workplace_popup)
	If 	IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "wkctr2", gs_code)
	this.SetItem(1, "wcdsc2", gs_codename)
end if

end event

type dw_list from w_standard_print`dw_list within w_pdt_06520
integer x = 1161
integer y = 396
integer width = 3438
integer height = 1920
string dataobject = "d_pdt_06520_02"
boolean border = false
end type

type dw_src from u_key_enter within w_pdt_06520
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 78
integer y = 488
integer width = 1024
integer height = 780
integer taborder = 30
string dragicon = "WinLogo!"
boolean bringtotop = true
string dataobject = "d_pdt_06520_03"
boolean vscrollbar = true
boolean border = false
string icon = "Error!"
end type

event ue_buttondown;Long crow, li_pos
String ls_col

lb_src_down = True
ls_col = this.GetObjectAtPointer()
if Len(ls_col) > 0 then
	li_pos = Pos(ls_col, '~t')
	crow = Integer(Right(ls_col, len(ls_col) - li_pos))
else
	crow = this.GetRow()
end if

this.SelectRow(0,False)
this.SelectRow(crow,True)

end event

event ue_buttonup;lb_src_down = False
this.SelectRow(0,False)
end event

event ue_mousemove;if lb_src_down then  
	this.Drag(begin!)
end if	
end event

event dragdrop;call super::dragdrop;DragObject do_control
Long crow, li_row, ll_found

do_control = DraggedObject()

if do_control = dw_dsc then 
   li_row = dw_dsc.GetRow()
   if li_row < 1 then return
	dw_dsc.DeleteRow(li_row)
end if	
end event

type dw_dsc from u_key_enter within w_pdt_06520
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 78
integer y = 1368
integer width = 1033
integer height = 944
integer taborder = 50
string dragicon = "WinLogo!"
boolean bringtotop = true
string dataobject = "d_pdt_06520_04"
boolean vscrollbar = true
boolean border = false
end type

event ue_lbuttondown;Long crow, li_pos
String ls_col

lb_dsc_down = True
ls_col = this.GetObjectAtPointer()
if Len(ls_col) > 0 then
	li_pos = Pos(ls_col, '~t')
	crow = Integer(Right(ls_col, len(ls_col) - li_pos))
else
	crow = this.GetRow()
end if

this.SelectRow(0,False)
this.SelectRow(crow,True)

end event

event ue_lbuttonup;lb_dsc_down = False
this.SelectRow(0,False)

end event

event ue_mousemove;if lb_dsc_down then 
	s_row = this.GetObjectAtPointer()
	this.Drag(begin!)
end if	
end event

event dragdrop;call super::dragdrop;DragObject do_control
Long crow, arow, li_row, ll_found, li_pos
String ls_col

do_control = DraggedObject()

if do_control = dw_src then 
   li_row = dw_src.GetRow()  
   if li_row < 1 then return
   if this.RowCount() > 0 then
	   ll_found = this.Find("col = '" + dw_src.object.col[li_row] + "'", 1, this.RowCount())
		if ll_found > 0 then
			MessageBox("중복입력", "정렬항목 중복입니다!")
			return
		end if	
   end if
	crow = this.InsertRow(0)
	this.object.col[crow] = dw_src.object.col[li_row]
	this.object.colnm[crow] = dw_src.object.colnm[li_row]
	this.object.sortgu[crow] = 'A'
elseif do_control = dw_dsc then 
   if Len(s_row) > 0 then
	   li_pos = Pos(s_row, '~t')
	   crow = Integer(Right(s_row, len(s_row) - li_pos))
   else
	   crow = this.GetRow()
   end if
	if row < 0 or row > this.RowCount() then 
		arow = this.RowCount()
	else
		arow = row
	end if	
   if dw_dsc.RowsCopy(crow, crow, Primary!, dw_dsc, arow, Primary!) = 1 then
		if crow > arow then
			dw_dsc.DeleteRow(crow + 1)
		else
			dw_dsc.DeleteRow(crow)
		end if	
	end if	
end if	

end event

event rbuttondown;call super::rbuttondown;if this.GetRow() < 1 then return

if this.object.sortgu[row] = "A" then
	this.object.sortgu[row] = "D"
elseif this.object.sortgu[row] = "D" then
	this.object.sortgu[row] = "A"
end if	
	
end event

type st_1 from statictext within w_pdt_06520
integer x = 357
integer y = 1320
integer width = 247
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "[항목]"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_06520
integer x = 837
integer y = 1320
integer width = 215
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "[정렬]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_06520
integer x = 87
integer y = 428
integer width = 370
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "[출력순서]"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_06520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1147
integer y = 392
integer width = 3479
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_06520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 69
integer y = 392
integer width = 1056
integer height = 896
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_06520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 69
integer y = 1296
integer width = 1056
integer height = 1036
integer cornerheight = 40
integer cornerwidth = 55
end type

