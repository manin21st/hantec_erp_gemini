$PBExportHeader$w_mat_02505.srw
$PBExportComments$** 출문의뢰현황
forward
global type w_mat_02505 from w_standard_print
end type
type st_1 from statictext within w_mat_02505
end type
type rb_1 from radiobutton within w_mat_02505
end type
type rb_2 from radiobutton within w_mat_02505
end type
type rb_3 from radiobutton within w_mat_02505
end type
type rb_4 from radiobutton within w_mat_02505
end type
type rb_5 from radiobutton within w_mat_02505
end type
type pb_d_mat_02500_07_s from u_pb_cal within w_mat_02505
end type
type pb_d_mat_02500_011_s from u_pb_cal within w_mat_02505
end type
type pb_d_mat_02500_07_e from u_pb_cal within w_mat_02505
end type
type pb_d_mat_02500_011_e from u_pb_cal within w_mat_02505
end type
type pb_d_mat_02500_01_s from u_pb_cal within w_mat_02505
end type
type pb_d_mat_02500_01_e from u_pb_cal within w_mat_02505
end type
type rr_1 from roundrectangle within w_mat_02505
end type
type rr_2 from roundrectangle within w_mat_02505
end type
type rr_3 from roundrectangle within w_mat_02505
end type
end forward

global type w_mat_02505 from w_standard_print
string title = "출문의뢰현황"
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
pb_d_mat_02500_07_s pb_d_mat_02500_07_s
pb_d_mat_02500_011_s pb_d_mat_02500_011_s
pb_d_mat_02500_07_e pb_d_mat_02500_07_e
pb_d_mat_02500_011_e pb_d_mat_02500_011_e
pb_d_mat_02500_01_s pb_d_mat_02500_01_s
pb_d_mat_02500_01_e pb_d_mat_02500_01_e
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_mat_02505 w_mat_02505

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, buse, depot, spdtgu, get_nm, sdepot, sgub, ls_porgu

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if

IF rb_1.Checked then //할당
	spdtgu = trim(dw_ip.object.pdtgu[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	
	IF spdtgu = ""	or isnull(spdtgu) then	
		dw_print.setfilter('')  
		dw_print.object.pdtgu_txt.text =  '전체'
	ELSE
		dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
	
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
		dw_print.object.pdtgu_txt.text = get_nm  
   END IF
	dw_print.filter()
	
	sdate = trim(dw_ip.object.sdate[1])
	edate = trim(dw_ip.object.edate[1])
	buse  = trim(dw_ip.object.buse[1])
	depot = trim(dw_ip.object.depot[1])
	
	if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
	if (IsNull(edate) or edate = "")  then edate = "99991231"
	if (IsNull(buse) or buse = "")  then buse = '%' 
	if (IsNull(depot) or depot = "")  then depot = '%'
	
	dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, buse, depot, '2') <= 0 then
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if

ELSEIF rb_2.Checked then //작업지시별
	spdtgu = trim(dw_ip.object.pdtgu[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	
	if spdtgu = ""	or isnull(spdtgu) then	
		sgub = trim(dw_ip.object.gub[1])
		if sgub = '1' THEN  	
			dw_print.setfilter("out_qty > 0 ")  
		else	
			dw_print.setfilter('')  
		end if	
		dw_print.object.pdtgu_txt.text =  '전체'
	else	  
		sgub = trim(dw_ip.object.gub[1])
		if sgub = '1' THEN  	
			dw_print.setfilter("pdtgu = '"+ spdtgu +"' and out_qty > 0 ")  
		else	
			dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
		end if	
		
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
		dw_print.object.pdtgu_txt.text = get_nm  
	end if
	dw_print.filter()
	
	sdate = trim(dw_ip.object.fr_jno[1])
	edate = trim(dw_ip.object.to_jno[1])

	sdepot = trim(dw_ip.object.depot[1])
	
	if (IsNull(sdepot) or sdepot = "")  then sdepot = "%"
	if (IsNull(sdate) or sdate = "")  then sdate = "."
	if (IsNull(edate) or edate = "")  then edate = "zzzzzzzzzzzzzzzz"
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, sdepot, '2' ) <= 0 then
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
ELSEIF rb_3.Checked then //작업지시별 요약
	spdtgu = trim(dw_ip.object.pdtgu[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	
	IF spdtgu = ""	or isnull(spdtgu) then	
		dw_print.setfilter('')  
		dw_print.object.pdtgu_txt.text =  '전체'
	ELSE
		dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
	
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
		dw_print.object.pdtgu_txt.text = get_nm  
   END IF
	dw_print.filter()
	
	sdate = trim(dw_ip.object.fr_jno[1])
	edate = trim(dw_ip.object.to_jno[1])
	
	if (IsNull(sdate) or sdate = "")  then sdate = "."
	if (IsNull(edate) or edate = "")  then edate = "zzzzzzzzzzzzzzzz"
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, '2' ) <= 0 then
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
ELSEIF rb_4.Checked then //기타 
	sdate = trim(dw_ip.object.sdate[1])
	edate = trim(dw_ip.object.edate[1])
	buse  = trim(dw_ip.object.buse[1])
	depot = trim(dw_ip.object.depot[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	
	if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
	if (IsNull(edate) or edate = "")  then edate = "99991231"
	if (IsNull(buse) or buse = "")  then buse = '%' 
	if (IsNull(depot) or depot = "")  then depot = '%'
	
	dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, buse, depot, '2') <= 0 then
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if
ELSEIF rb_5.Checked then //집계
	spdtgu = trim(dw_ip.object.pdtgu[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	
	IF spdtgu = ""	or isnull(spdtgu) then	
		dw_print.setfilter('')  
		dw_print.object.pdtgu_txt.text =  '전체'
	ELSE
		dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
	
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
		dw_print.object.pdtgu_txt.text = get_nm  
   END IF
	dw_print.filter()
	
	sdate = trim(dw_ip.object.sdate[1])
	edate = trim(dw_ip.object.edate[1])
	buse  = trim(dw_ip.object.buse[1])
	depot = trim(dw_ip.object.depot[1])
	
	if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
	if (IsNull(edate) or edate = "")  then edate = "99991231"
	if (IsNull(buse) or buse = "")  then buse = '%' 
	if (IsNull(depot) or depot = "")  then depot = '%'
	
	dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	if dw_print.Retrieve(gs_sabu, sdate, edate, buse, depot, '2' ) <= 0 then
		f_message_chk(50,'')
		dw_ip.Setfocus()
		return -1
	end if

END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_mat_02505.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.pb_d_mat_02500_07_s=create pb_d_mat_02500_07_s
this.pb_d_mat_02500_011_s=create pb_d_mat_02500_011_s
this.pb_d_mat_02500_07_e=create pb_d_mat_02500_07_e
this.pb_d_mat_02500_011_e=create pb_d_mat_02500_011_e
this.pb_d_mat_02500_01_s=create pb_d_mat_02500_01_s
this.pb_d_mat_02500_01_e=create pb_d_mat_02500_01_e
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rb_5
this.Control[iCurrent+7]=this.pb_d_mat_02500_07_s
this.Control[iCurrent+8]=this.pb_d_mat_02500_011_s
this.Control[iCurrent+9]=this.pb_d_mat_02500_07_e
this.Control[iCurrent+10]=this.pb_d_mat_02500_011_e
this.Control[iCurrent+11]=this.pb_d_mat_02500_01_s
this.Control[iCurrent+12]=this.pb_d_mat_02500_01_e
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
end on

on w_mat_02505.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.pb_d_mat_02500_07_s)
destroy(this.pb_d_mat_02500_011_s)
destroy(this.pb_d_mat_02500_07_e)
destroy(this.pb_d_mat_02500_011_e)
destroy(this.pb_d_mat_02500_01_s)
destroy(this.pb_d_mat_02500_01_e)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;rb_5.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within w_mat_02505
end type

type p_exit from w_standard_print`p_exit within w_mat_02505
end type

type p_print from w_standard_print`p_print within w_mat_02505
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_02505
end type







type st_10 from w_standard_print`st_10 within w_mat_02505
end type



type dw_print from w_standard_print`dw_print within w_mat_02505
string dataobject = "d_mat_02500_08_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02505
integer x = 59
integer y = 224
integer width = 2930
integer height = 252
string dataobject = "d_mat_02500_011"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.SetItem(1,"sdate","")
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.SetItem(1,"edate","")
		return 1
	end if
elseif this.GetColumnName() = "buse" then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"buse",s_cod)
	this.SetItem(1,"bunm",s_nam2)
	return i_rtn
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "buse"	THEN		
	open(w_vndmst_4_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "buse", gs_code)
	this.SetItem(1, "bunm", gs_codename)
ELSEIF	this.getcolumnname() = "fr_jno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "fr_jno", gs_code)
ELSEIF	this.getcolumnname() = "to_jno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "to_jno", gs_code)
END IF
end event

type dw_list from w_standard_print`dw_list within w_mat_02505
integer x = 50
integer y = 508
integer width = 4526
integer height = 1804
string dataobject = "d_mat_02500_08"
boolean border = false
end type

type st_1 from statictext within w_mat_02505
integer x = 82
integer y = 48
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_mat_02505
integer x = 334
integer y = 112
integer width = 645
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "의뢰일자 별(할당)"
end type

event clicked;dw_ip.DataObject ="d_mat_02500_011" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_02500_07_s.Visible = False
pb_d_mat_02500_07_e.Visible = False
pb_d_mat_02500_01_s.Visible = False
pb_d_mat_02500_01_e.Visible = False
pb_d_mat_02500_011_s.Visible = True
pb_d_mat_02500_011_e.Visible = True


dw_list.DataObject ="d_mat_02500_021" 
dw_list.SetTransObject(SQLCA)
dw_print.DataObject ="d_mat_02500_021_p" 
dw_print.SetTransObject(SQLCA)


dw_print.object.t_17.text = '출문 의뢰 현황(할당)'

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')
//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type rb_2 from radiobutton within w_mat_02505
integer x = 1125
integer y = 112
integer width = 608
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
string text = "작업지시번호 별"
end type

event clicked;dw_ip.DataObject ="d_mat_02500_03" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_02500_07_s.Visible = False
pb_d_mat_02500_07_e.Visible = False
pb_d_mat_02500_01_s.Visible = False
pb_d_mat_02500_01_e.Visible = False
pb_d_mat_02500_011_s.Visible = False
pb_d_mat_02500_011_e.Visible = False

dw_list.DataObject ="d_mat_02500_04" 
dw_list.SetTransObject(SQLCA)
dw_print.DataObject ="d_mat_02500_04_p" 
dw_print.SetTransObject(SQLCA)
dw_print.object.t_3.text = '출문 지시서'

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')
//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type rb_3 from radiobutton within w_mat_02505
integer x = 1842
integer y = 48
integer width = 608
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "작업지시번호(요약)"
end type

event clicked;dw_ip.DataObject ="d_mat_02500_06" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_02500_07_s.Visible = False
pb_d_mat_02500_07_e.Visible = False
pb_d_mat_02500_01_s.Visible = False
pb_d_mat_02500_01_e.Visible = False
pb_d_mat_02500_011_s.Visible = False
pb_d_mat_02500_011_e.Visible = False


dw_list.DataObject ="d_mat_02500_05" 
dw_list.SetTransObject(SQLCA)
dw_print.DataObject ="d_mat_02500_05_p" 
dw_print.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

dw_print.object.t_25.text = '출문 의뢰 현황(요약)'

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')
//사업장
f_mod_saupj(dw_ip, 'porgu' )

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type rb_4 from radiobutton within w_mat_02505
integer x = 1125
integer y = 48
integer width = 608
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "의뢰일자 별(기타)"
end type

event clicked;dw_ip.DataObject ="d_mat_02500_01" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_02500_07_s.Visible = False
pb_d_mat_02500_07_e.Visible = False
pb_d_mat_02500_01_s.Visible = True
pb_d_mat_02500_01_e.Visible = True
pb_d_mat_02500_011_s.Visible = False
pb_d_mat_02500_011_e.Visible = False


dw_list.DataObject ="d_mat_02500_02" 
dw_list.SetTransObject(SQLCA)
dw_print.DataObject ="d_mat_02500_02_p" 
dw_print.SetTransObject(SQLCA)

dw_print.object.t_17.text = '출문 의뢰 현황(일반)'

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')
//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)
end event

type rb_5 from radiobutton within w_mat_02505
integer x = 334
integer y = 48
integer width = 645
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
string text = "의뢰일자 별(집계)"
boolean checked = true
end type

event clicked;dw_ip.DataObject ="d_mat_02500_07" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_02500_07_s.Visible = True
pb_d_mat_02500_07_e.Visible = True
pb_d_mat_02500_01_s.Visible = False
pb_d_mat_02500_01_e.Visible = False
pb_d_mat_02500_011_s.Visible = False
pb_d_mat_02500_011_e.Visible = False


dw_list.DataObject ="d_mat_02500_08" 
dw_list.SetTransObject(SQLCA)
dw_print.DataObject ="d_mat_02500_08_p" 
dw_print.SetTransObject(SQLCA)


p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')
//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type pb_d_mat_02500_07_s from u_pb_cal within w_mat_02505
integer x = 1449
integer y = 216
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_mat_02500_011_s from u_pb_cal within w_mat_02505
integer x = 1477
integer y = 224
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

type pb_d_mat_02500_07_e from u_pb_cal within w_mat_02505
integer x = 1906
integer y = 216
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

type pb_d_mat_02500_011_e from u_pb_cal within w_mat_02505
integer x = 1929
integer y = 224
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_mat_02500_01_s from u_pb_cal within w_mat_02505
integer x = 1993
integer y = 228
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_mat_02500_01_e from u_pb_cal within w_mat_02505
integer x = 2455
integer y = 228
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_1 from roundrectangle within w_mat_02505
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 20
integer width = 2496
integer height = 164
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mat_02505
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 192
integer width = 2981
integer height = 300
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_mat_02505
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 500
integer width = 4553
integer height = 1820
integer cornerheight = 40
integer cornerwidth = 55
end type

