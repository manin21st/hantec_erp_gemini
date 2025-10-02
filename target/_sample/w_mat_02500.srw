$PBExportHeader$w_mat_02500.srw
$PBExportComments$** 출고의뢰현황
forward
global type w_mat_02500 from w_standard_print
end type
type st_1 from statictext within w_mat_02500
end type
type rb_1 from radiobutton within w_mat_02500
end type
type rb_2 from radiobutton within w_mat_02500
end type
type rb_3 from radiobutton within w_mat_02500
end type
type rb_4 from radiobutton within w_mat_02500
end type
type rb_5 from radiobutton within w_mat_02500
end type
type pb_d_mat_02500_01_s from u_pic_cal within w_mat_02500
end type
type pb_d_mat_02500_01_e from u_pic_cal within w_mat_02500
end type
type pb_d_mat_02500_011_s from u_pic_cal within w_mat_02500
end type
type pb_d_mat_02500_011_e from u_pic_cal within w_mat_02500
end type
type pb_d_mat_02500_07_s from u_pic_cal within w_mat_02500
end type
type pb_d_mat_02500_07_e from u_pic_cal within w_mat_02500
end type
end forward

global type w_mat_02500 from w_standard_print
integer width = 4667
string title = "출고의뢰현황"
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
pb_d_mat_02500_01_s pb_d_mat_02500_01_s
pb_d_mat_02500_01_e pb_d_mat_02500_01_e
pb_d_mat_02500_011_s pb_d_mat_02500_011_s
pb_d_mat_02500_011_e pb_d_mat_02500_011_e
pb_d_mat_02500_07_s pb_d_mat_02500_07_s
pb_d_mat_02500_07_e pb_d_mat_02500_07_e
end type
global w_mat_02500 w_mat_02500

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
		get_nm = '전체'
	ELSE
		dw_print.setfilter("momast_pdtgu = '"+ spdtgu +"'")  
	
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
   END IF
	dw_list.filter()
	
	sdate = trim(dw_ip.object.sdate[1])
	edate = trim(dw_ip.object.edate[1])
	buse  = trim(dw_ip.object.buse[1])
	depot = trim(dw_ip.object.depot[1])
	
	if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
	if (IsNull(edate) or edate = "")  then edate = "99991231"
	if (IsNull(buse) or buse = "")  then buse = '%' 
	if (IsNull(depot) or depot = "")  then depot = '%'
	
	IF dw_print.Retrieve(gs_sabu, sdate, edate, buse, depot, '1') <= 0 then
		f_message_chk(50,'[출고의뢰 현황]')
		Return -1
	END IF

	dw_print.object.pdtgu_txt.text = get_nm  
	dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	dw_print.ShareData(dw_list)

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
		get_nm = '전체'
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
	
	end if
	dw_print.filter()
	
	sdate = trim(dw_ip.object.fr_jno[1])
	edate = trim(dw_ip.object.to_jno[1])

	sdepot = trim(dw_ip.object.depot[1])
	
	if (IsNull(sdepot) or sdepot = "")  then sdepot = "%"
	if (IsNull(sdate) or sdate = "")  then sdate = "."
	if (IsNull(edate) or edate = "")  then edate = "zzzzzzzzzzzzzzzz"
	
	IF dw_print.Retrieve(gs_sabu, sdate, edate, sdepot, '1') <= 0 then
		f_message_chk(50,'[출고의뢰 현황]')
		Return -1
	END IF

	dw_print.object.pdtgu_txt.text = get_nm  
	dw_print.ShareData(dw_list)

ELSEIF rb_3.Checked then //작업지시별 요약
	spdtgu = trim(dw_ip.object.pdtgu[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	IF spdtgu = ""	or isnull(spdtgu) then	
		dw_print.setfilter('')
		get_nm = '전체'
	ELSE
		dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
	
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
   END IF
	dw_print.filter()
	
	sdate = trim(dw_ip.object.fr_jno[1])
	edate = trim(dw_ip.object.to_jno[1])
	
	if (IsNull(sdate) or sdate = "")  then sdate = "."
	if (IsNull(edate) or edate = "")  then edate = "zzzzzzzzzzzzzzzz"
	
	IF dw_print.Retrieve(gs_sabu, sdate, edate, '1') <= 0 then
		f_message_chk(50,'[출고의뢰 현황]')
		Return -1
	END IF

	dw_print.object.pdtgu_txt.text = get_nm  

	dw_print.ShareData(dw_list)

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
	
	IF dw_print.Retrieve(gs_sabu, sdate, edate, buse, depot, '1') <= 0 then
		f_message_chk(50,'[출고의뢰 현황]')
		Return -1
	END IF

	dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	dw_print.ShareData(dw_list)

ELSEIF rb_5.Checked then //집계
	spdtgu = trim(dw_ip.object.pdtgu[1])
	ls_porgu = trim(dw_ip.object.porgu[1])
	IF spdtgu = ""	or isnull(spdtgu) then	
		dw_print.setfilter('')  
		get_nm = '전체'
	ELSE
		dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
	
		SELECT "REFFPF"."RFNA1"  
		  INTO :get_nm
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '03' ) AND  
				 ( "REFFPF"."RFGUB" = :spdtgu )   ;
	
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
	
	IF dw_print.Retrieve(gs_sabu, sdate, edate, buse, depot, '1') <= 0 then
		f_message_chk(50,'[출고의뢰 현황]')
		Return -1
	END IF

	dw_print.object.pdtgu_txt.text = get_nm  
	dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
	
	dw_print.ShareData(dw_list)

END IF

return 1

end function

on w_mat_02500.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.pb_d_mat_02500_01_s=create pb_d_mat_02500_01_s
this.pb_d_mat_02500_01_e=create pb_d_mat_02500_01_e
this.pb_d_mat_02500_011_s=create pb_d_mat_02500_011_s
this.pb_d_mat_02500_011_e=create pb_d_mat_02500_011_e
this.pb_d_mat_02500_07_s=create pb_d_mat_02500_07_s
this.pb_d_mat_02500_07_e=create pb_d_mat_02500_07_e
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rb_5
this.Control[iCurrent+7]=this.pb_d_mat_02500_01_s
this.Control[iCurrent+8]=this.pb_d_mat_02500_01_e
this.Control[iCurrent+9]=this.pb_d_mat_02500_011_s
this.Control[iCurrent+10]=this.pb_d_mat_02500_011_e
this.Control[iCurrent+11]=this.pb_d_mat_02500_07_s
this.Control[iCurrent+12]=this.pb_d_mat_02500_07_e
end on

on w_mat_02500.destroy
call super::destroy
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.pb_d_mat_02500_01_s)
destroy(this.pb_d_mat_02500_01_e)
destroy(this.pb_d_mat_02500_011_s)
destroy(this.pb_d_mat_02500_011_e)
destroy(this.pb_d_mat_02500_07_s)
destroy(this.pb_d_mat_02500_07_e)
end on

event ue_open;call super::ue_open;setnull(gs_code)

//사업장
f_mod_saupj(dw_ip, 'porgu')

//입고창고 
f_child_saupj(dw_ip, 'depot', gs_saupj)

pb_d_mat_02500_07_s.Visible = True
pb_d_mat_02500_07_e.Visible = True
pb_d_mat_02500_01_s.Visible = False
pb_d_mat_02500_01_e.Visible = False
pb_d_mat_02500_011_s.Visible = False
pb_d_mat_02500_011_e.Visible = False
end event

event open;call super::open;rb_5.TriggerEvent(Clicked!)
end event

type dw_list from w_standard_print`dw_list within w_mat_02500
integer y = 428
integer width = 4535
integer height = 1868
string dataobject = "d_mat_02500_08"
end type

type cb_print from w_standard_print`cb_print within w_mat_02500
integer y = 500
end type

type cb_excel from w_standard_print`cb_excel within w_mat_02500
integer x = 2747
integer y = 744
end type

type cb_preview from w_standard_print`cb_preview within w_mat_02500
integer y = 500
end type

type cb_1 from w_standard_print`cb_1 within w_mat_02500
integer x = 2414
integer y = 744
end type

type dw_print from w_standard_print`dw_print within w_mat_02500
string dataobject = "d_mat_02500_08_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_02500
integer y = 52
integer width = 4535
integer height = 352
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

type r_1 from w_standard_print`r_1 within w_mat_02500
integer y = 424
integer width = 4544
integer height = 1876
end type

type r_2 from w_standard_print`r_2 within w_mat_02500
integer y = 48
integer width = 4544
integer height = 360
end type

type st_1 from statictext within w_mat_02500
integer x = 2834
integer y = 64
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_mat_02500
integer x = 3099
integer y = 128
integer width = 645
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "의뢰일자 별(할당)"
end type

event clicked;String ls_saupj
dw_ip.DataObject ="d_mat_02500_011" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
pb_d_mat_02500_07_s.Visible = False
pb_d_mat_02500_07_e.Visible = False
pb_d_mat_02500_01_s.Visible = False
pb_d_mat_02500_01_e.Visible = False
pb_d_mat_02500_011_s.Visible = True
pb_d_mat_02500_011_e.Visible = True

dw_list.DataObject ="d_mat_02500_021" 
dw_print.DataObject ="d_mat_02500_021_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//p_print.Enabled =False
//p_preview.enabled = False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

//사업장
f_mod_saupj(dw_ip, 'porgu' )

ls_saupj = dw_ip.GetItemString(1,'porgu')

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)

end event

type rb_2 from radiobutton within w_mat_02500
integer x = 3099
integer y = 256
integer width = 645
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
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
dw_print.DataObject ="d_mat_02500_04_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//p_print.Enabled =False
//p_preview.enabled = False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj

//사업장
f_mod_saupj(dw_ip, 'porgu' )

ls_saupj = dw_ip.GetItemString(1,'porgu')

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type rb_3 from radiobutton within w_mat_02500
integer x = 3099
integer y = 320
integer width = 645
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
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
dw_print.DataObject ="d_mat_02500_05_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//p_print.Enabled =False
//p_preview.enabled = False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj

//사업장
f_mod_saupj(dw_ip, 'porgu' )

ls_saupj = dw_ip.GetItemString(1,'porgu')

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type rb_4 from radiobutton within w_mat_02500
integer x = 3099
integer y = 192
integer width = 645
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
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
dw_print.DataObject ="d_mat_02500_02_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//p_print.Enabled =False
//p_preview.enabled = False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

//사업장
f_mod_saupj(dw_ip, 'porgu' )

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)
end event

type rb_5 from radiobutton within w_mat_02500
integer x = 3099
integer y = 64
integer width = 645
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
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
dw_print.DataObject ="d_mat_02500_08_p" 
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//p_print.Enabled =False
//p_preview.enabled = False
//p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

String ls_saupj
ls_saupj = dw_ip.GetItemString(1,'porgu')
//사업장
f_mod_saupj(dw_ip, 'porgu' )

//입고창고 
f_child_saupj(dw_ip, 'depot', ls_saupj)

//생산팀
f_child_saupj(dw_ip, 'pdtgu', ls_saupj)
end event

type pb_d_mat_02500_01_s from u_pic_cal within w_mat_02500
integer x = 1966
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_d_mat_02500_01_e from u_pic_cal within w_mat_02500
integer x = 2427
integer y = 64
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_mat_02500_011_s from u_pic_cal within w_mat_02500
integer x = 1445
integer y = 64
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

type pb_d_mat_02500_011_e from u_pic_cal within w_mat_02500
integer x = 1897
integer y = 64
integer taborder = 50
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type pb_d_mat_02500_07_s from u_pic_cal within w_mat_02500
integer x = 1417
integer y = 64
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

type pb_d_mat_02500_07_e from u_pic_cal within w_mat_02500
integer x = 1874
integer y = 64
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

