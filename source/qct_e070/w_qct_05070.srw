$PBExportHeader$w_qct_05070.srw
$PBExportComments$계측기마스타 현황
forward
global type w_qct_05070 from w_standard_print
end type
type dw_src from u_key_enter within w_qct_05070
end type
type dw_dsc from u_key_enter within w_qct_05070
end type
type st_1 from statictext within w_qct_05070
end type
type st_2 from statictext within w_qct_05070
end type
type st_3 from statictext within w_qct_05070
end type
type rr_1 from roundrectangle within w_qct_05070
end type
end forward

global type w_qct_05070 from w_standard_print
string title = "계측기 마스터현황"
dw_src dw_src
dw_dsc dw_dsc
st_1 st_1
st_2 st_2
st_3 st_3
rr_1 rr_1
end type
global w_qct_05070 w_qct_05070

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string mchno1, mchno2, dptno1, dptno2, gubun, sdate, edate, kegbn , outgubun, buncd, buncd1 
string s_ord, fgrcod, tgrcod
Long i

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

//mchno1 = trim(dw_ip.object.mchno1[1])
//mchno2 = trim(dw_ip.object.mchno2[1])
//dptno1 = trim(dw_ip.object.dptno1[1])
//dptno2 = trim(dw_ip.object.dptno2[1])
//gubun  = trim(dw_ip.object.gubun[1])
sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
//kegbn  = trim(dw_ip.object.kegbn[1])
//fgrcod = trim(dw_ip.object.fgrcod[1])
//tgrcod = trim(dw_ip.object.tgrcod[1])
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])
//outgubun = trim(dw_ip.object.prtgbn[1])


if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 
	
if (IsNull(sdate) or sdate = "") then sdate = "10000101" //초기일자는 변경시키면 안됨
if (IsNull(edate) or edate = "") then edate = "99991231" //이유? 데이타윈도우에 일자 셋팅

IF dw_print.Retrieve(gs_sabu, sdate, edate, buncd, buncd1) <= 0 then
	f_message_chk(50,"[계측기 마스터 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

////dw_list.SetFilter("") //구분 => ALL
////dw_list.Filter( )
////
////if gubun = "2" then //구분 => 보유
////   dw_list.SetFilter("IsNull(pedat) or pedat = ''")
////	dw_list.Filter( )
////elseif gubun = "3" then //구분 => 폐기
////	dw_list.SetFilter("not (IsNull(pedat) or pedat = '')")
////	dw_list.Filter( )
////end if	
//
////if outgubun = '1' then
//
//		//dw_list.object.txt_mchno.text = buncd + " - " + buncd1
//		if dw_list.Retrieve(gs_sabu, sdate, edate, buncd, buncd1) <= 0 then
//			f_message_chk(50,"[계측기 마스터 현황]")
//			dw_ip.Setfocus()
//			return -1
//		end if
//		
////		if dw_dsc.RowCount() < 1 then return 1
////		dw_list.SetRedraw(false)
////		s_ord = ""
////		for i = 1 to dw_dsc.RowCount()
////			 if i > 1 then s_ord = s_ord + ", "
////			 s_ord = s_ord + dw_dsc.object.col[i] + " " + dw_dsc.object.sortgu[i]
////		next
////		dw_list.SetSort(s_ord)
////		dw_list.Sort()
////		dw_list.SetRedraw(true)
//		
//		return 1
//		
////elseif outgubun = '2' then
////	
////	  	if dw_list.Retrieve(gs_sabu, mchno1, mchno2, dptno1, dptno2, sdate, edate, buncd ) <= 0 then
////			f_message_chk(50,"[계측기 마스터 현황]")
////			dw_ip.Setfocus()
////			return -1
////		end if
////		
////		if dw_dsc.RowCount() < 1 then return 1
////		dw_list.SetRedraw(false)
////		s_ord = ""
////		for i = 1 to dw_dsc.RowCount()
////			 if i = 1 then 
////				 s_ord = "maincd A, "
////			 elseif i > 1 then 
////				 s_ord = s_ord + ", "
////			 end if
////			 s_ord = s_ord + dw_dsc.object.col[i] + " " + dw_dsc.object.sortgu[i]
////		next
////		dw_list.SetSort(s_ord)
////		dw_list.Sort()
////		dw_list.GroupCalc()
////		
////		dw_list.SetRedraw(true)
////		
////		return 1
////	
////end if
	
end function

on w_qct_05070.create
int iCurrent
call super::create
this.dw_src=create dw_src
this.dw_dsc=create dw_dsc
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_src
this.Control[iCurrent+2]=this.dw_dsc
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.rr_1
end on

on w_qct_05070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_src)
destroy(this.dw_dsc)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
end on

event w_qct_05070::open;call super::open;Long i
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

//sle_msg.text = "오른쪽 마우스 버튼을 CLICK하면 해당 항목의 정렬순서를 변경합니다!"

end event

type p_preview from w_standard_print`p_preview within w_qct_05070
integer x = 4279
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_qct_05070
integer x = 4453
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_05070
integer x = 4105
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05070
integer x = 3931
end type



type sle_msg from w_standard_print`sle_msg within w_qct_05070
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qct_05070
end type



type dw_print from w_standard_print`dw_print within w_qct_05070
string dataobject = "d_qct_05070_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05070
integer x = 32
integer y = 60
integer width = 3255
integer height = 152
string dataobject = "d_qct_05070_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod, s_nam1, s_nam2 , ls_buncd
integer i_rtn

s_cod = Trim(this.GetText())


if this.GetColumnName() = "sdate" then 
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
end if


end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

//if this.GetColumnName() = "mchno1" then
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//	open(w_mchno_popup)
//	if isnull(gs_code) or gs_code = '' then return 
//	this.object.mchno1[1] = gs_code
//	this.object.mchnam1[1] = gs_codename
//elseif this.GetColumnName() = "mchno2" then
//	gs_gubun = 'ALL'
//	gs_code  = '계측기'
//	open(w_mchno_popup)
//	if isnull(gs_code) or gs_code = '' then return 
//	this.object.mchno2[1] = gs_code
//	this.object.mchnam2[1] = gs_codename
//elseif this.GetColumnName() = "dptno1" then 	
//	open(w_vndmst_4_popup)
//	if isnull(gs_code) or gs_code = '' then return 
//	this.object.dptno1[1] = gs_code
//	this.object.dptnm1[1] = gs_codename
//elseif this.GetColumnName() = "dptno2" then 	
//	open(w_vndmst_4_popup)
//	if isnull(gs_code) or gs_code = '' then return 
//	this.object.dptno2[1] = gs_code
//	this.object.dptnm2[1] = gs_codename
if this.GetColumnName() = "buncd" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	
elseif this.GetColumnName() = "buncd1" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd1[1] = gs_code
		
end if		

end event

type dw_list from w_standard_print`dw_list within w_qct_05070
integer y = 224
integer width = 4530
integer height = 2080
string dataobject = "d_qct_05070_02"
boolean border = false
end type

type dw_src from u_key_enter within w_qct_05070
event ue_buttondown pbm_lbuttondown
event ue_buttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 1701
integer y = 3096
integer width = 1033
integer height = 400
integer taborder = 0
string dragicon = "C:\ERPMAN\PGM\Mapif0s.ico"
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_qct_05070_03"
boolean vscrollbar = true
string icon = "Error!"
borderstyle borderstyle = stylelowered!
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

type dw_dsc from u_key_enter within w_qct_05070
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_mousemove pbm_mousemove
integer x = 1701
integer y = 3556
integer width = 1033
integer height = 328
integer taborder = 0
string dragicon = "C:\ERPMAN\PGM\Mapif0s.ico"
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_qct_05070_04"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
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

type st_1 from statictext within w_qct_05070
integer x = 1865
integer y = 3504
integer width = 247
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
string text = "[항목]"
boolean focusrectangle = false
end type

type st_2 from statictext within w_qct_05070
integer x = 2459
integer y = 3504
integer width = 215
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
string text = "[정렬]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_qct_05070
integer x = 1687
integer y = 3024
integer width = 370
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
string text = "[출력순서]"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qct_05070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 216
integer width = 4553
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

