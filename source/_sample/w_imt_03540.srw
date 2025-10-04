$PBExportHeader$w_imt_03540.srw
$PBExportComments$** OPEN실적 집계표
forward
global type w_imt_03540 from w_standard_print
end type
type rb_1 from radiobutton within w_imt_03540
end type
type rb_2 from radiobutton within w_imt_03540
end type
type pb_1 from u_pb_cal within w_imt_03540
end type
type pb_2 from u_pb_cal within w_imt_03540
end type
type pb_3 from u_pb_cal within w_imt_03540
end type
type pb_4 from u_pb_cal within w_imt_03540
end type
type rr_1 from roundrectangle within w_imt_03540
end type
type rr_2 from roundrectangle within w_imt_03540
end type
end forward

global type w_imt_03540 from w_standard_print
string title = "OPEN/통관 실적 집계표"
rb_1 rb_1
rb_2 rb_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_03540 w_imt_03540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, tong_sdate, tong_edate, bal_sdate, bal_edate, sittyp, fr_itcls, to_itcls, gub

		
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

if rb_1.checked = true then 
	dw_list.DataObject = "d_imt_03540_01_1" 
	dw_print.DataObject = "d_imt_03540_01_1_p" 
	dw_list.settransobject(sqlca)	
	dw_print.settransobject(sqlca)	
	  
	sdate      = trim(dw_ip.object.sdate[1])
	 
	if (IsNull(sdate) or sdate = "") then 
		dw_ip.SetFocus()
		return -1
	end if	
	
	//수입 L/C의 OPEN 일자 + OPEN은행을 기준으로 집계하고 
	//통화단위가 US DOLLAR가 아닌 경우 OPEN일자 대미환산율을 적용하여 
	//US DOLLAR를 기준으로 집계한다.
	
//	if dw_list.Retrieve(gs_sabu, sdate) <= 0 then
//		f_message_chk(50,'[OPEN 실적 집계표]')
//		dw_ip.Setfocus()
//		return -1
//	end if

	IF dw_print.Retrieve(gs_sabu, sdate) <= 0 then
		f_message_chk(50,'[OPEN 실적 집계표]')
		dw_ip.Setfocus()
		dw_list.Reset()
		dw_print.insertrow(0)
	//	Return -1
	END IF

	dw_print.object.txt_yyyy.text = sdate + '년'
	dw_print.ShareData(dw_list)

else
	 
	tong_sdate = trim(dw_ip.object.tong_sdate[1])
	tong_edate = trim(dw_ip.object.tong_edate[1])
	bal_sdate  = trim(dw_ip.object.bal_sdate[1])
	bal_edate  = trim(dw_ip.object.bal_edate[1])
	sittyp     = trim(dw_ip.object.sittyp[1])
	fr_itcls   = trim(dw_ip.object.fr_itcls[1])
	to_itcls   = trim(dw_ip.object.to_itcls[1])
	gub        = trim(dw_ip.object.gub[1])


	if (isNull(tong_sdate) or tong_sdate = "" or Isnull(tong_edate) or tong_edate="" ) then
		dw_ip.setfocus()
		return -1 
	end if

	if isnull(bal_sdate) or bal_sdate = "" then bal_sdate = '11111111'
	if isnull(bal_edate) or bal_edate = "" then bal_edate = '99991231' 
	if isnull(sittyp)   or sittyp = "" then  sittyp = '%'
	if isnull(fr_itcls) or fr_itcls = "" then fr_itcls = '.'
	if isnull(to_itcls) or to_itcls = "" then to_itcls = 'zzzzzzz'

	if  gub = '1' or gub = '2' or gub = '3' then
		dw_list.DataObject = "d_imt_03540_02_1" 
		dw_print.DataObject = "d_imt_03540_02_1_p" 
		dw_list.settransobject(sqlca)	
		dw_print.settransobject(sqlca)	

//		if dw_list.Retrieve( gub, gs_sabu, tong_sdate, tong_edate, bal_sdate, bal_edate, sittyp, fr_itcls, to_itcls ) <= 0 then
//			f_message_chk(50,'[통관 집계표]')
//			dw_ip.Setfocus()
//			return -1
//		end if

		IF dw_print.Retrieve( gub, gs_sabu, tong_sdate, tong_edate, bal_sdate, bal_edate, sittyp, fr_itcls, to_itcls ) <= 0 then
			f_message_chk(50,'[통관 집계표]')
			dw_ip.Setfocus()
			dw_list.Reset()
			dw_print.insertrow(0)
		//	Return -1
		END IF

		dw_print.object.txt_date.text = string(tong_sdate, '@@@@.@@.@@') +' - ' + string(tong_edate, '@@@@.@@.@@') 
		dw_print.ShareData(dw_list)

	else
		dw_list.DataObject = "d_imt_03540_02_2" 
		dw_print.DataObject = "d_imt_03540_02_2" 
		dw_list.settransobject(sqlca)	
		dw_print.settransobject(sqlca)	

//		if dw_list.Retrieve( gs_sabu, tong_sdate, tong_edate, bal_sdate, bal_edate, sittyp, fr_itcls, to_itcls ) <= 0 then
//			f_message_chk(50,'[통관 집계표]')
//			dw_ip.Setfocus()
//			return -1
//		end if

		IF dw_print.Retrieve( gs_sabu, tong_sdate, tong_edate, bal_sdate, bal_edate, sittyp, fr_itcls, to_itcls ) <= 0 then
			f_message_chk(50,'[통관 집계표]')
			dw_ip.Setfocus()
			dw_list.Reset()
			dw_print.insertrow(0)
		//	Return -1
		END IF

		dw_print.object.txt_date.text = string(tong_sdate, '@@@@.@@.@@') +' - ' + string(tong_edate, '@@@@.@@.@@')
		dw_print.ShareData(dw_list)

	end if

end if


return 1
end function

on w_imt_03540.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.pb_4
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_imt_03540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem(1, 'sdate', left(is_today, 4))
end event

type p_preview from w_standard_print`p_preview within w_imt_03540
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_imt_03540
integer taborder = 80
end type

type p_print from w_standard_print`p_print within w_imt_03540
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03540
integer taborder = 40
end type







type st_10 from w_standard_print`st_10 within w_imt_03540
end type



type dw_print from w_standard_print`dw_print within w_imt_03540
integer y = 56
string dataobject = "d_imt_03540_01_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03540
integer x = 658
integer y = 32
integer width = 3255
integer height = 212
integer taborder = 30
string dataobject = "d_imt_03540_01"
end type

event dw_ip::itemchanged;string s_cod

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod + '0101') = -1 then 
		f_message_chk(35, "[기준년도]")
		this.object.sdate[1] = ""
		return 1
	END IF	
elseif this.GetColumnName() = "tong_sdate" then
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod ) = -1 then 
		f_message_chk(35, "[통관시작일자]")
		this.object.tong_sdate[1] = ""
		return 1
	END IF
elseif this.GetColumnName() = "tong_edate" then
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod ) = -1 then 
		f_message_chk(35, "[통관끝일자]")
		this.object.tong_edate[1] = ""
		return 1
	END IF	
elseif this.GetColumnName() = "bal_sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[발주시작일자]")
		this.object.bal_sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "bal_edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[발주끝일자]")
		this.object.bal_edate[1] = ""
		return 1
	end if
end if



end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string snull, sname
str_itnct lstr_sitnct

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itcls' then
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	else
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fr_itcls", lstr_sitnct.s_sumgub)
 	end if	
elseif this.GetColumnName() = 'to_itcls' then
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	else
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"to_itcls", lstr_sitnct.s_sumgub)
 	end if	
end if	

end event

type dw_list from w_standard_print`dw_list within w_imt_03540
integer y = 272
integer width = 4567
integer height = 2072
string dataobject = "d_imt_03540_01_1"
boolean border = false
end type

type rb_1 from radiobutton within w_imt_03540
integer x = 69
integer y = 72
integer width = 521
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "OPEN 실적 집계표"
boolean checked = true
end type

event clicked;dw_ip.DataObject = "d_imt_03540_01" 
pb_1.Visible = False
pb_2.Visible = False
pb_3.Visible = False
pb_4.Visible = False
dw_list.DataObject = "d_imt_03540_01_1" 
dw_print.DataObject = "d_imt_03540_01_1_p" 

dw_ip.SettransObject(sqlca)
dw_list.SettransObject(sqlca)

dw_ip.insertRow(0)
dw_ip.setitem(1, 'sdate', left(is_today, 4))
dw_ip.setfocus()




		
end event

type rb_2 from radiobutton within w_imt_03540
integer x = 69
integer y = 140
integer width = 521
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "통관 실적 집계표"
end type

event clicked;dw_ip.DataObject = "d_imt_03540_02" 
pb_1.Visible = True
pb_2.Visible = True
pb_3.Visible = True
pb_4.Visible = True
dw_list.DataObject = "d_imt_03540_02_1" 
dw_print.DataObject = "d_imt_03540_02_1_p" 

dw_ip.SettransObject(sqlca)
dw_list.SettransObject(sqlca) 
dw_print.SettransObject(sqlca) 

dw_ip.insertRow(0)
dw_ip.setitem(1, 'tong_sdate', left(is_today,4)+'0101' )
dw_ip.setitem(1, 'tong_edate', is_today)
dw_ip.setfocus()


end event

type pb_1 from u_pb_cal within w_imt_03540
boolean visible = false
integer x = 1303
integer y = 44
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('tong_sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'tong_sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_03540
boolean visible = false
integer x = 1723
integer y = 44
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('tong_edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'tong_edate', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_03540
boolean visible = false
integer x = 2885
integer y = 44
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('bal_edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'bal_edate', gs_code)



end event

type pb_4 from u_pb_cal within w_imt_03540
boolean visible = false
integer x = 2450
integer y = 44
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('bal_sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'bal_sdate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_03540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 36
integer width = 599
integer height = 196
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_03540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 268
integer width = 4585
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

