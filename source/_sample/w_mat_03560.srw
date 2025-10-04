$PBExportHeader$w_mat_03560.srw
$PBExportComments$** 출고의뢰서
forward
global type w_mat_03560 from w_standard_print
end type
type rr_1 from roundrectangle within w_mat_03560
end type
type rb_1 from radiobutton within w_mat_03560
end type
type rb_2 from radiobutton within w_mat_03560
end type
type rb_3 from radiobutton within w_mat_03560
end type
type rb_4 from radiobutton within w_mat_03560
end type
type cbx_1 from checkbox within w_mat_03560
end type
type pb_d_mat_03560_01_s from u_pb_cal within w_mat_03560
end type
type pb_d_mat_03560_01_e from u_pb_cal within w_mat_03560
end type
type pb_d_mat_03560_04_e from u_pb_cal within w_mat_03560
end type
type pb_d_mat_03560_04_s from u_pb_cal within w_mat_03560
end type
type rb_5 from radiobutton within w_mat_03560
end type
type rr_2 from roundrectangle within w_mat_03560
end type
end forward

global type w_mat_03560 from w_standard_print
string title = "출고 의뢰서"
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
cbx_1 cbx_1
pb_d_mat_03560_01_s pb_d_mat_03560_01_s
pb_d_mat_03560_01_e pb_d_mat_03560_01_e
pb_d_mat_03560_04_e pb_d_mat_03560_04_e
pb_d_mat_03560_04_s pb_d_mat_03560_04_s
rb_5 rb_5
rr_2 rr_2
end type
global w_mat_03560 w_mat_03560

type variables
string is_gubun
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, pdtgu1, pdtgu2, jpno1, jpno2, jpno3, sdepot , sgubun , setc, ls_porgu, Schk

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

IF rb_1.Checked or rb_5.Checked then 
	sdate  = trim(dw_ip.object.sdate[1])
	edate  = trim(dw_ip.object.edate[1])
	pdtgu1 = trim(dw_ip.object.pdtgu1[1])
	pdtgu2 = trim(dw_ip.object.pdtgu2[1])
	jpno1  = trim(dw_ip.object.jpno1[1])
	jpno2  = trim(dw_ip.object.jpno2[1])
	ls_porgu  = trim(dw_ip.object.porgu[1])
	sdepot = trim(dw_ip.object.depot[1])
		
	if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
	if (IsNull(edate) or edate = "")  then edate = "99991231"
	if (IsNull(pdtgu1) or pdtgu1 = "")  then pdtgu1 = "."
	if (IsNull(pdtgu2) or pdtgu2 = "")  then pdtgu2 = "ZZZZZZ"
	if (IsNull(jpno1) or jpno1 = "")  then jpno1 = "."
	if (IsNull(jpno2) or jpno2 = "")  then
		jpno2 = "ZZZZZZZZZZZZ"
	else
		jpno2 = jpno2 + '999'
   end if		
	
//	dw_print.dataobject = 'd_mat_03560_02_p'
//	dw_print.SetTransObject(SQLCA)
	
	if isnull(sdepot) or sdepot = '' then 
		dw_print.setfilter("")  
	else		
		dw_print.setfilter(" holdstock_out_store  = '" + sdepot + "'")  
	end if
	dw_print.filter()

	IF dw_print.Retrieve(gs_sabu, sdate, edate, pdtgu1, pdtgu2, jpno1, jpno2, ls_porgu) <= 0 then
		f_message_chk(50,'[출고 의뢰서]')
		dw_list.Reset()
		dw_print.insertrow(0)
	END IF

	dw_print.ShareData(dw_list)

ELSEIF rb_2.Checked then 
	jpno1 = trim(dw_ip.object.fr_jno[1])
	jpno2 = trim(dw_ip.object.to_jno[1])
	
	sdepot = trim(dw_ip.object.depot[1])
	
	ls_porgu  = trim(dw_ip.object.porgu[1])
	
	sdate  = trim(dw_ip.object.sdate[1])
	edate  = trim(dw_ip.object.edate[1])
	pdtgu1 = trim(dw_ip.object.pdtgu1[1])
	pdtgu2 = trim(dw_ip.object.pdtgu2[1])
	
	if (IsNull(jpno1) or jpno1 = "")  then jpno1 = "."
	if (IsNull(jpno2) or jpno2 = "")  then jpno2 = "zzzzzzzzzzzzzzzz"
	
	if (IsNull(sdate) or sdate = "")  then sdate = "."
	if (IsNull(edate) or edate = "")  then edate = "zzzzzzzzzzzzzzzz"

	if (IsNull(pdtgu1) or pdtgu1 = "")  then pdtgu1 = "."
	if (IsNull(pdtgu2) or pdtgu2 = "")  then pdtgu2 = "ZZZZZZ"

	if isnull(sdepot) or sdepot = '' then 
		dw_list.setfilter("")  
   else		
		dw_list.setfilter("holdstock_hold_store = '" + sdepot + "'")  
	end if
	dw_list.filter()
	
	IF dw_print.Retrieve(gs_sabu, jpno1, jpno2, ls_porgu, pdtgu1, pdtgu2, sdate, edate, ls_porgu ) <= 0 then
		f_message_chk(50,'[출고 의뢰서]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

ELSEIF rb_3.Checked then 

	jpno1  = trim(dw_ip.object.jpno[1])
	sgubun = trim(dw_ip.object.gubun[1])
	setc   = trim(dw_ip.object.etc[1])

	if isnull(jpno1) or jpno1 = '' then 
		f_message_chk(30,'[의뢰번호]')
		dw_ip.Setfocus()
		return -1
   else		
		jpno1 = jpno1 + '%'
	end if

	IF dw_print.Retrieve(gs_sabu, jpno1 , sgubun , setc ) <= 0 then
		f_message_chk(50,'[폐기신청서]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

ELSEIF rb_4.Checked then 

	jpno3  = trim(dw_ip.object.jpno3[1])

	if isnull(jpno3) or jpno3 = '' then 
		f_message_chk(30,'[의뢰번호]')
		dw_ip.Setfocus()
		return -1
   else		
		jpno3 = jpno3 + '%'
	end if

	IF dw_print.Retrieve(gs_sabu, jpno3 ) <= 0 then
		f_message_chk(50,'[타계정대체출고의뢰서]')
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.ShareData(dw_list)

END IF	

return 1
end function

on w_mat_03560.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.cbx_1=create cbx_1
this.pb_d_mat_03560_01_s=create pb_d_mat_03560_01_s
this.pb_d_mat_03560_01_e=create pb_d_mat_03560_01_e
this.pb_d_mat_03560_04_e=create pb_d_mat_03560_04_e
this.pb_d_mat_03560_04_s=create pb_d_mat_03560_04_s
this.rb_5=create rb_5
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.pb_d_mat_03560_01_s
this.Control[iCurrent+8]=this.pb_d_mat_03560_01_e
this.Control[iCurrent+9]=this.pb_d_mat_03560_04_e
this.Control[iCurrent+10]=this.pb_d_mat_03560_04_s
this.Control[iCurrent+11]=this.rb_5
this.Control[iCurrent+12]=this.rr_2
end on

on w_mat_03560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.cbx_1)
destroy(this.pb_d_mat_03560_01_s)
destroy(this.pb_d_mat_03560_01_e)
destroy(this.pb_d_mat_03560_04_e)
destroy(this.pb_d_mat_03560_04_s)
destroy(this.rb_5)
destroy(this.rr_2)
end on

event open;call super::open;cbx_1.Checked = False

rb_1.TriggerEvent(Clicked!)
end event

event ue_open;call super::ue_open;//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

dw_ip.SetItem(1, 'sdate', Left(is_today,6)+'01')
dw_ip.SetItem(1, 'edate', is_today)
end event

type p_preview from w_standard_print`p_preview within w_mat_03560
end type

event p_preview::clicked;if is_gubun = '3'then
	gs_gubun = '999'
ELSE
	setnull(gs_gubun)
end if
OpenWithParm(w_print_preview, dw_print)	

end event

type p_exit from w_standard_print`p_exit within w_mat_03560
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_mat_03560
end type

event p_print::clicked;if is_gubun = '3'then
   dw_print.Object.DataWindow.zoom  = '73'	
end if

iF dw_print.rowcount() > 0 then 
	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_mat_03560
end type







type st_10 from w_standard_print`st_10 within w_mat_03560
end type



type dw_print from w_standard_print`dw_print within w_mat_03560
integer x = 3973
integer y = 172
string dataobject = "d_mat_03560_02_p1"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_03560
integer x = 594
integer y = 20
integer width = 3287
integer height = 272
string dataobject = "d_mat_03560_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
   if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
      f_message_chk(35,"[시작일자]")		
		this.setitem(1, 'sdate', '')
		return 1
	end if	
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
      f_message_chk(35,"[끝일자]")		
		this.setitem(1, 'edate', '')
		return 1
	end if	
elseif this.GetColumnName() = "pdtgu1" then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.pdtgu1[1] = s_cod
	this.object.pdtnm1[1] = s_nam1
	return i_rtn 
elseif this.GetColumnName() = "pdtgu2" then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.pdtgu2[1] = s_cod
	this.object.pdtnm2[1] = s_nam1
	return i_rtn 
end if	
	
end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "pdtgu1"	THEN		
	gs_gubun ='1'
	open(w_vndmst_4_popup)
	this.SetItem(1, "pdtgu1", gs_code)
	this.SetItem(1, "pdtnm1", gs_codename)
ELSEIF this.getcolumnname() = "pdtgu2"	THEN		
	gs_gubun ='1'
	open(w_vndmst_4_popup)
	this.SetItem(1, "pdtgu2", gs_code)
	this.SetItem(1, "pdtnm2", gs_codename)
ELSEIF this.getcolumnname() = "fr_jno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "fr_jno", gs_code)
ELSEIF this.getcolumnname() = "to_jno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "to_jno", gs_code)
ELSEIF this.getcolumnname() = "jpno1"	THEN		
	open(w_haldang_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.SetItem(1, "jpno1", left(gs_code, 12))
ELSEIF this.getcolumnname() = "jpno2"	THEN		
	open(w_haldang_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.SetItem(1, "jpno2", left(gs_code, 12))
ELSEIF this.getcolumnname() = "jpno"	THEN		
	open(w_haldang_popup_1)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.SetItem(1, "jpno", left(gs_code, 12))
ELSEIF this.getcolumnname() = "jpno3"	THEN		
	open(w_haldang_popup)
	if isnull(gs_code)  or  gs_code = ''	then	return
	this.SetItem(1, "jpno3", left(gs_code, 12))
END IF

end event

type dw_list from w_standard_print`dw_list within w_mat_03560
integer x = 32
integer y = 308
integer width = 4576
integer height = 2008
string dataobject = "d_mat_03560_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_mat_03560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 20
integer width = 571
integer height = 264
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_mat_03560
integer x = 64
integer y = 60
integer width = 512
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "출고의뢰일자 별"
boolean checked = true
end type

event clicked;is_gubun = '1'
dw_ip.DataObject ="d_mat_03560_01" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_03560_01_s.Visible = True
pb_d_mat_03560_01_e.Visible = True
pb_d_mat_03560_04_s.Visible = False
pb_d_mat_03560_04_e.Visible = False


dw_list.DataObject ="d_mat_03560_02" 
dw_print.DataObject ="d_mat_03560_02_p1" 
dw_print.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

end event

type rb_2 from radiobutton within w_mat_03560
integer x = 64
integer y = 120
integer width = 512
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "작업지시번호 별"
end type

event clicked;is_gubun = '2'
dw_ip.DataObject ="d_mat_03560_04" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_03560_01_s.Visible = False
pb_d_mat_03560_01_e.Visible = False
pb_d_mat_03560_04_s.Visible = True
pb_d_mat_03560_04_e.Visible = True

dw_list.DataObject ="d_mat_03560_03" 
dw_print.DataObject ="d_mat_03560_03_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

String ls_sdate, ls_edate

select to_char(sysdate,'yyyymmdd'),to_char(sysdate-7,'yyyymmdd')
  into :ls_sdate, :ls_edate
  from dual;

dw_ip.SetItem(1,'sdate', ls_edate)
dw_ip.SetItem(1,'edate', ls_sdate)
end event

type rb_3 from radiobutton within w_mat_03560
boolean visible = false
integer x = 4146
integer y = 188
integer width = 416
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "폐기의뢰서"
end type

event clicked;dw_ip.DataObject ="d_mat_03560_05" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_03560_01_s.Visible = False
pb_d_mat_03560_01_e.Visible = False
pb_d_mat_03560_04_s.Visible = False
pb_d_mat_03560_04_e.Visible = False

dw_list.DataObject ="d_mat_03560_06" 
dw_print.DataObject ="d_mat_03560_06_p" 
dw_print.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)


p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
end event

type rb_4 from radiobutton within w_mat_03560
boolean visible = false
integer x = 4128
integer y = 232
integer width = 512
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "품목대체출고"
end type

event clicked;dw_ip.DataObject ="d_mat_03560_07" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_03560_01_s.Visible = False
pb_d_mat_03560_01_e.Visible = False
pb_d_mat_03560_04_s.Visible = False
pb_d_mat_03560_04_e.Visible = False

dw_list.DataObject ="d_mat_03560_08" 
dw_print.DataObject ="d_mat_03560_08_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
end event

type cbx_1 from checkbox within w_mat_03560
boolean visible = false
integer x = 3584
integer y = 188
integer width = 219
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "서열"
end type

event clicked;if This.Checked = False then
	dw_print.DataObject = 'd_mat_03560_02_p'
	dw_print.SetTransObject(sqlca)
else
	dw_print.DataObject = 'd_mat_03560_02_tp'
	dw_print.SetTransObject(sqlca)
end if
end event

type pb_d_mat_03560_01_s from u_pb_cal within w_mat_03560
integer x = 1321
integer y = 44
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_mat_03560_01_e from u_pb_cal within w_mat_03560
integer x = 1774
integer y = 44
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_mat_03560_04_e from u_pb_cal within w_mat_03560
boolean visible = false
integer x = 3218
integer y = 24
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_mat_03560_04_s from u_pb_cal within w_mat_03560
boolean visible = false
integer x = 2766
integer y = 24
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type rb_5 from radiobutton within w_mat_03560
integer x = 64
integer y = 180
integer width = 512
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "출고의뢰서"
end type

event clicked;is_gubun  = '3'
dw_ip.DataObject ="d_mat_03560_01" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_03560_01_s.Visible = True
pb_d_mat_03560_01_e.Visible = True
pb_d_mat_03560_04_s.Visible = False
pb_d_mat_03560_04_e.Visible = False


dw_list.DataObject ="d_mat_03560_02" 
dw_print.DataObject ="d_mat_03560_02_p" 
dw_print.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'


//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

end event

type rr_2 from roundrectangle within w_mat_03560
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 300
integer width = 4594
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

