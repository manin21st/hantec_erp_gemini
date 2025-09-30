$PBExportHeader$w_qct_06700.srw
$PBExportComments$** 불량원인별 분석현황
forward
global type w_qct_06700 from w_standard_print
end type
type rb_1 from radiobutton within w_qct_06700
end type
type st_1 from statictext within w_qct_06700
end type
type rb_2 from radiobutton within w_qct_06700
end type
type rb_3 from radiobutton within w_qct_06700
end type
type rr_1 from roundrectangle within w_qct_06700
end type
end forward

global type w_qct_06700 from w_standard_print
string title = "불량원인별 분석"
rb_1 rb_1
st_1 st_1
rb_2 rb_2
rb_3 rb_3
rr_1 rr_1
end type
global w_qct_06700 w_qct_06700

forward prototypes
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve1 ();string sYYmm
Long   lRank

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sYYmm  = trim(dw_ip.object.ym[1])
lRank  = dw_ip.object.Rank[1]

if (IsNull(sYYMm) or sYYmm = "")  then 
	f_message_chk(30, "[기준년월]")
	dw_ip.SetColumn("syymm")
	dw_ip.Setfocus()
	return -1
end if	

if lRank < 1  then 
	f_message_chk(30, "[불량원인 순위]")
	dw_ip.SetColumn("rank")
	dw_ip.Setfocus()
	return -1
end if	

//if dw_list.Retrieve(gs_sabu, sYYmm, lRank) <= 0 then
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sYYmm, lRank) <= 0 then
	f_message_chk(50,'[불량원인별 분석현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

RETURN 1
end function

public function integer wf_retrieve2 ();string sDate, eDate, scode, ecode

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
scode  = trim(dw_ip.object.scode[1])
ecode  = trim(dw_ip.object.ecode[1])

if sdate = '' or isnull(sdate) then sdate = '10000101'
if edate = '' or isnull(edate) then edate = '99991231'
if scode = '' or isnull(scode) then
	select min(rfgub) 
	  into :scode 
	  from reffpf 
	 where sabu = '1' and rfcod = '32' and rfgub <> '00' ;	
end if

if ecode = '' or isnull(ecode) then 
	select max(rfgub) 
	  into :ecode 
	  from reffpf 
	 where sabu = '1' and rfcod = '32' and rfgub <> '00' ;	
end if

//if dw_list.Retrieve(gs_sabu, sdate, edate, scode, ecode) <= 0 then
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, scode, ecode) <= 0 then
	f_message_chk(50,'[불량원인별 분석현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

RETURN 1
end function

public function integer wf_retrieve3 ();string sDate, eDate
Long   lRank

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate  = trim(dw_ip.object.sdate[1])
edate  = trim(dw_ip.object.edate[1])
lRank  = dw_ip.object.Rank[1]

if lRank < 1  then 
	f_message_chk(30, "[불량원인 순위]")
	dw_ip.SetColumn("rank")
	dw_ip.Setfocus()
	return -1
end if	

if sdate = '' or isnull(sdate) then sdate = '10000101'
if edate = '' or isnull(edate) then edate = '99991231'

//if dw_list.Retrieve(gs_sabu, sdate, edate, lRank) <= 0 then
//	f_message_chk(50,'')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, lRank) <= 0 then
	f_message_chk(50,'[불량원인별 분석현황]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

RETURN 1

end function

public function integer wf_retrieve ();string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(dw_ip.object.gubun[1])

IF rb_1.Checked then 
	if s_cod = "1" then
		dw_list.DataObject = "d_qct_06700_02"
		dw_print.DataObject = "d_qct_06700_02"
	else
		dw_list.DataObject = "d_qct_06700_03"
		dw_print.DataObject = "d_qct_06700_03"
	end if	
ELSEIF rb_2.Checked then 
	if s_cod = "1" then
		dw_list.DataObject = "d_qct_06700_12"
		dw_print.DataObject = "d_qct_06700_12"
	else
		dw_list.DataObject = "d_qct_06700_13"
		dw_print.DataObject = "d_qct_06700_13"
	end if	
ELSE
	if s_cod = "1" then
		dw_list.DataObject = "d_qct_06700_22"
		dw_print.DataObject = "d_qct_06700_22"
	else
		dw_list.DataObject = "d_qct_06700_23"
		dw_print.DataObject = "d_qct_06700_23"
	end if	
END IF
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
	
IF rb_1.Checked then 
	i_rtn  = wf_retrieve1()
ELSEIF rb_2.Checked then
	i_rtn  = wf_retrieve2()
ELSE
	i_rtn  = wf_retrieve3()
END IF

Return i_rtn

end function

on w_qct_06700.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rr_1
end on

on w_qct_06700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rr_1)
end on

event open;call super::open;rb_1.TriggerEvent(Clicked!)

dw_ip.setfocus()
end event

type p_preview from w_standard_print`p_preview within w_qct_06700
end type

type p_exit from w_standard_print`p_exit within w_qct_06700
end type

type p_print from w_standard_print`p_print within w_qct_06700
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06700
end type







type st_10 from w_standard_print`st_10 within w_qct_06700
end type



type dw_print from w_standard_print`dw_print within w_qct_06700
string dataobject = "d_qct_06700_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06700
integer x = 910
integer y = 24
integer width = 2825
integer height = 292
string dataobject = "d_qct_06700_11"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[검사일자 FROM]")
		this.SetItem(1,"sdate","")
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[검사일자 TO]")
		this.SetItem(1,"edate","")
		return 1
	end if
elseif this.GetColumnName() = "ym" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "gubun" then	
	IF rb_1.Checked then 
		if s_cod = "1" then
			dw_list.DataObject = "d_qct_06700_02"
			dw_print.DataObject = "d_qct_06700_02"
		else
			dw_list.DataObject = "d_qct_06700_03"
			dw_print.DataObject = "d_qct_06700_03"
		end if	
	ELSEIF rb_2.Checked then 
		if s_cod = "1" then
			dw_list.DataObject = "d_qct_06700_12"
			dw_print.DataObject = "d_qct_06700_12"
		else
			dw_list.DataObject = "d_qct_06700_13"
			dw_print.DataObject = "d_qct_06700_13"
		end if	
	ELSE
		if s_cod = "1" then
			dw_list.DataObject = "d_qct_06700_22"
			dw_print.DataObject = "d_qct_06700_22"
		else
			dw_list.DataObject = "d_qct_06700_23"
			dw_print.DataObject = "d_qct_06700_23"
		end if	
	END IF
   dw_list.SetTransObject(SQLCA)
   dw_print.SetTransObject(SQLCA)
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	
end if

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_06700
string dataobject = "d_qct_06700_12"
end type

type rb_1 from radiobutton within w_qct_06700
integer x = 96
integer y = 80
integer width = 672
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
string text = "불량원인별 분석(요약)"
boolean checked = true
end type

event clicked;dw_ip.DataObject ="d_qct_06700_01" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'ym', left(is_today, 6))

dw_list.DataObject ="d_qct_06700_02"
dw_list.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type st_1 from statictext within w_qct_06700
integer x = 91
integer y = 24
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
boolean enabled = false
string text = "출력구분"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_qct_06700
integer x = 96
integer y = 156
integer width = 672
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
string text = "불량원인별 분석(상세)"
end type

event clicked;dw_ip.DataObject ="d_qct_06700_11" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'sdate', left(is_today, 6) + '01')
dw_ip.SetItem(1, 'edate', is_today)


dw_list.DataObject ="d_qct_06700_12"
dw_list.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_3 from radiobutton within w_qct_06700
integer x = 96
integer y = 232
integer width = 672
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
string text = "불량원인 관리도"
end type

event clicked;dw_ip.DataObject ="d_qct_06700_21" 
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'sdate', left(is_today, 6) + '01')
dw_ip.SetItem(1, 'edate', is_today)

dw_list.DataObject ="d_qct_06700_22"
dw_list.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rr_1 from roundrectangle within w_qct_06700
integer linethickness = 4
long fillcolor = 16777215
integer x = 55
integer y = 12
integer width = 823
integer height = 304
integer cornerheight = 40
integer cornerwidth = 55
end type

