$PBExportHeader$w_imt_03590.srw
$PBExportComments$** 수입비용명세서
forward
global type w_imt_03590 from w_standard_print
end type
type dw_1 from datawindow within w_imt_03590
end type
type pb_1 from u_pb_cal within w_imt_03590
end type
type pb_2 from u_pb_cal within w_imt_03590
end type
type pb_3 from u_pb_cal within w_imt_03590
end type
type pb_4 from u_pb_cal within w_imt_03590
end type
type rr_1 from roundrectangle within w_imt_03590
end type
end forward

global type w_imt_03590 from w_standard_print
string title = "수입 비용명세서"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
end type
global w_imt_03590 w_imt_03590

type variables
String     is_occod            // 관세부가세
end variables

forward prototypes
public function integer wf_retrieve2 ()
public function integer wf_retrieve1 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve2 ();string sdate, edate, bi1, bi2, sLcno, sBlno, ssaupj 

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
bi1 = trim(dw_ip.object.bi1[1])
bi2 = trim(dw_ip.object.bi2[1])
sLcno = trim(dw_ip.object.lcno[1])
sBlno = trim(dw_ip.object.blno[1])
ssaupj= dw_ip.object.saupj[1]

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(bi1) or bi1 = "")  then bi1 = "0"
if (IsNull(bi2) or bi2 = "")  then bi2 = "ZZZZZZ"

if IsNull(sLcno) or sLcno = ""  then 
	slcno = '%'
else
	slcno = sLcno + '%'
end if

if IsNull(sBlno) or sBlno = ""  then 
	sBlno = '%'
else
	sBlno = sBlno + '%'
end if

//if dw_list.Retrieve(gs_sabu, sdate, edate, bi1, bi2, slcno, sBlno, is_occod, ssaupj) <= 0 then
//	f_message_chk(50,'[수입 비용명세서-[요약]]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, bi1, bi2, slcno, sBlno, is_occod, ssaupj) <= 0 then
	f_message_chk(50,'[수입 비용명세서-[요약]]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.object.txt_occdat.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

dw_print.ShareData(dw_list)

return 1
end function

public function integer wf_retrieve1 ();string sdate, edate, bi1, bi2, jung, sLcno, sBlno, set1, set2, sgub, ssaupj

if 	dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate 	= trim(dw_ip.object.sdate[1])
edate 	= trim(dw_ip.object.edate[1])
bi1   	= trim(dw_ip.object.bi1[1])
bi2   	= trim(dw_ip.object.bi2[1])
jung  	= trim(dw_ip.object.jung[1])
sLcno = trim(dw_ip.object.lcno[1])
sBlno 	= trim(dw_ip.object.blno[1])
set1  	= trim(dw_ip.object.set1[1])
set2  	= trim(dw_ip.object.set2[1])
sgub  = trim(dw_ip.object.gub[1])
ssaupj= dw_ip.object.saupj[1]

if 	(IsNull(sdate) or sdate = "") then sdate = "11110101"
if 	(IsNull(edate) or edate = "") then edate = "99991231"
if 	(IsNull(bi1) or bi1 = "")  then bi1 = "0"
if 	(IsNull(bi2) or bi2 = "")  then bi2 = "ZZZZZZ"

if 	(IsNull(jung) or jung = "")  then 
	f_message_chk(30, "[정산여부]")
	dw_ip.SetColumn("jung")
	dw_ip.Setfocus()
	return -1
end if	

if 	IsNull(sLcno) or sLcno = ""  then 
	slcno = '%'
else
	slcno = sLcno + '%'
end if

if 	IsNull(sBlno) or sBlno = ""  then 
	sBlno = '%'
else
	sBlno = sBlno + '%'
end if

if 	sgub = '1' then 
	dw_list.DataObject = "d_imt_03590_02"
	dw_print.DataObject = "d_imt_03590_02_p"
elseif sgub = '2' then 
	dw_list.DataObject = "d_imt_03590_03"
	dw_print.DataObject = "d_imt_03590_03_p"
elseif sgub = '3' then 	
	dw_list.DataObject = "d_imt_03590_04"
	dw_print.DataObject = "d_imt_03590_04_p"
else
	dw_list.DataObject = "d_imt_03590_05"
	dw_print.DataObject = "d_imt_03590_05_p"
end if
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_list.SetRedraw(False)
dw_list.SetFilter("")
dw_list.Filter()

if 	jung = "2" then //정산신청
   	if 	(IsNull(set1) or set1 = "")  then set1 = "11110101"
   	if 	(IsNull(set2) or set2 = "")  then set2 = "99991231"
   	dw_list.SetFilter("setdat >= '" + set1 + "' and setdat <= '" + set2 + "' and " + &
	                  "settle = 'Y' and ac_confirm = 'N'")
	dw_list.Filter()
elseif jung = "3" then //미정산
	dw_list.SetFilter("settle = 'N'")
	dw_list.Filter()
elseif jung = "4" then //정산완료
	dw_list.SetFilter("ac_confirm = 'Y'")
	dw_list.Filter()
end if	

if 	jung = "2" then //정산신청
   	dw_print.object.txt_setdat.text = "신청일자 : " + String(set1, "@@@@.@@.@@") + " - " + String(set2, "@@@@.@@.@@")   
end if   

dw_print.object.txt_occdat.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")

//if dw_list.Retrieve(gs_sabu, sdate, edate, bi1, bi2, sLcno, sBlno, is_occod, ssaupj) <= 0 then
//	f_message_chk(50,'[수입 비용명세서]')
//	dw_ip.Setfocus()
//	dw_list.SetRedraw(True)
//	return -1
//end if

IF 	dw_print.Retrieve(gs_sabu, sdate, edate, bi1, bi2, sLcno, sBlno, is_occod, ssaupj) <= 0 then
	f_message_chk(50,'[수입 비용명세서]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.SetRedraw(True)

return 1
end function

public function integer wf_retrieve ();string gubun
integer i_rtn

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

gubun = trim(dw_1.object.gubun[1])

if gubun = "1" then
	i_rtn = wf_retrieve1()
elseif gubun = "2" then
	i_rtn = wf_retrieve2()
end if	

return i_rtn
end function

on w_imt_03590.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.rr_1
end on

on w_imt_03590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

//관세 부가세 코드 시스템에서 가져오기
SELECT DATANAME  
  INTO :is_occod 
  FROM SYSCNFG  
 WHERE SYSGU = 'A' AND SERIAL = 13 AND LINENO = '01' ;

IF isnull(is_occod) then is_occod = '' 

f_mod_saupj(dw_ip, 'saupj')
end event

type p_preview from w_standard_print`p_preview within w_imt_03590
end type

type p_exit from w_standard_print`p_exit within w_imt_03590
end type

type p_print from w_standard_print`p_print within w_imt_03590
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_03590
end type







type st_10 from w_standard_print`st_10 within w_imt_03590
end type



type dw_print from w_standard_print`dw_print within w_imt_03590
string dataobject = "d_imt_03590_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03590
integer x = 37
integer y = 72
integer width = 3877
integer height = 336
string dataobject = "d_imt_03590_01"
end type

event dw_ip::itemchanged;String s_cod

s_cod = Trim(this.GetText())

pb_3.Visible = False
pb_4.Visible = False

if 	this.GetColumnName() = "sdate" then
	if 	IsNull(s_cod) or s_cod = "" then return 
	if 	f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지출일자(시작)]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if 	IsNull(s_cod) or s_cod = "" then return 
	if 	f_datechk(s_cod) = -1 then
		f_message_chk(35, "[지출일자(끝)]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "set1" then
	if 	IsNull(s_cod) or s_cod = "" then return 
	if 	f_datechk(s_cod) = -1 then
		f_message_chk(35, "[신청일자(시작)]")
		this.object.set1[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "set2" then
	if 	IsNull(s_cod) or s_cod = "" then return 
	if 	f_datechk(s_cod) = -1 then
		f_message_chk(35, "[신청일자(끝)]")
		this.object.set2[1] = ""
		return 1
	end if
ElseIf This.GetColumnName() = 'jung' Then
	pb_3.Visible = True
	pb_4.Visible = True
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''

// lc번호
IF 	this.GetColumnName() = 'lcno'	THEN

	Open(w_lc_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "lcno",		gs_code)

ELSEIF this.GetColumnName() = 'blno'	THEN

	Open(w_bl_popup4)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	SetItem(1, "blno",		gs_code)

END IF


end event

type dw_list from w_standard_print`dw_list within w_imt_03590
integer x = 46
integer y = 420
integer width = 4549
integer height = 1900
string dataobject = "d_imt_03590_02"
boolean border = false
end type

type dw_1 from datawindow within w_imt_03590
integer x = 23
integer width = 1495
integer height = 88
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_03590_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_list.SetReDraw(False)
if gubun = "1" then //수입비용명세서
	dw_list.DataObject 		= "d_imt_03590_02"
	dw_print.DataObject 	= "d_imt_03590_02_p"
	
	dw_ip.object.group_t.Visible = True
	dw_ip.object.gub.Visible = True
	dw_ip.object.jung_t.Visible = True
	dw_ip.object.jung.Visible = True
elseif gubun = "2" then	//수입비용명세서(요약)
	dw_list.DataObject 		= "d_imt_03580_02"
	dw_print.DataObject 	= "d_imt_03580_02_p"
	dw_ip.object.group_t.Visible = False
	dw_ip.object.gub.Visible = False
	dw_ip.object.jung_t.Visible = False
	dw_ip.object.jung.Visible = False
end if	
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_list.SetReDraw(True)

end event

type pb_1 from u_pb_cal within w_imt_03590
integer x = 1650
integer y = 112
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

type pb_2 from u_pb_cal within w_imt_03590
integer x = 2103
integer y = 112
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

type pb_3 from u_pb_cal within w_imt_03590
boolean visible = false
integer x = 1650
integer y = 288
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('set1')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'set1', gs_code)



end event

type pb_4 from u_pb_cal within w_imt_03590
boolean visible = false
integer x = 2103
integer y = 288
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('set2')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'set2', gs_code)



end event

type rr_1 from roundrectangle within w_imt_03590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 416
integer width = 4571
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

