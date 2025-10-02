$PBExportHeader$w_imt_02590.srw
$PBExportComments$** 발주진행현황
forward
global type w_imt_02590 from w_standard_print
end type
type dw_1 from datawindow within w_imt_02590
end type
type pb_d_imt_02590_01_s from u_pic_cal within w_imt_02590
end type
type pb_d_imt_02590_01_e from u_pic_cal within w_imt_02590
end type
type pb_d_imt_02600_01_s from u_pic_cal within w_imt_02590
end type
type pb_d_imt_02600_01_e from u_pic_cal within w_imt_02590
end type
type rr_1 from roundrectangle within w_imt_02590
end type
type rr_3 from roundrectangle within w_imt_02590
end type
end forward

global type w_imt_02590 from w_standard_print
string title = "발주진행현황"
boolean maxbox = true
dw_1 dw_1
pb_d_imt_02590_01_s pb_d_imt_02590_01_s
pb_d_imt_02590_01_e pb_d_imt_02590_01_e
pb_d_imt_02600_01_s pb_d_imt_02600_01_s
pb_d_imt_02600_01_e pb_d_imt_02600_01_e
rr_1 rr_1
rr_3 rr_3
end type
global w_imt_02590 w_imt_02590

type variables
string bagbn


end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
end prototypes

public function integer wf_retrieve ();string gubun
Integer i_rtn

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

public function integer wf_retrieve1 ();string sdate, edate, cvcod1, cvcod2, balsts, emp1, emp2, balgu, ssaupj, ckd

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
balsts = trim(dw_ip.object.balsts[1])
emp1 = trim(dw_ip.object.emp1[1])
emp2 = trim(dw_ip.object.emp2[1])
balgu = trim(dw_ip.object.balgu[1])
ssaupj = dw_ip.object.saupj[1]
ckd = dw_ip.object.ckd[1]

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
if (IsNull(emp1) or emp1 = "")  then emp1 = "."
if (IsNull(emp2) or emp2 = "")  then emp2 = "ZZZZZZ"
if (IsNull(balgu) or balgu = "")  then balgu = "%"
if (IsNull(ckd) or ckd = "") then ckd = "%"

dw_print.SetReDraw(False)
//dw_print.SetFilter("")
//if balsts = "1" then //미완료
//   dw_print.SetFilter("balsts = '1'")
//elseif balsts = "2" then //완료
//   dw_print.SetFilter("balsts = '2'")
//elseif balsts = "3" then //all
//	dw_print.SetFilter("balsts like '%'")
//end if	
//dw_print.Filter()

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
if dw_print.Retrieve(sdate, edate, cvcod1, cvcod2, emp1, emp2, balgu, ssaupj, balsts, ckd) <= 0 then
	f_message_chk(50,'[발주진행현황-발주번호별]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1
end function

public function integer wf_retrieve2 ();string sdate, edate, itnbr1, itnbr2, balsts, emp1, emp2, balgu, ssaupj, ckd

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
balsts = trim(dw_ip.object.balsts[1])
emp1 = trim(dw_ip.object.emp1[1])
emp2 = trim(dw_ip.object.emp2[1])
balgu = trim(dw_ip.object.balgu[1])
ssaupj = dw_ip.object.saupj[1]
ckd = dw_ip.object.ckd[1]

if (IsNull(sdate) or sdate = "")  then sdate = "11110101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "1"
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(emp1) or emp1 = "")  then emp1 = "."
if (IsNull(emp2) or emp2 = "")  then emp2 = "ZZZZZZ"
if (IsNull(balgu) or balgu = "")  then balgu = "%"
if (IsNull(ckd) or ckd = "") then ckd = "%"

//dw_print.SetFilter("")
//if balsts = "1" then //미완료
//   dw_print.SetFilter("balsts = '1'")
//elseif balsts = "2" then //완료
//   dw_print.SetFilter("balsts = '2'")
//end if	
//dw_print.Filter()

dw_print.object.txt_date.text = String(sdate, "@@@@.@@.@@") + " - " + String(edate, "@@@@.@@.@@")
if dw_print.Retrieve(gs_sabu, sdate, edate, itnbr1, itnbr2, emp1, emp2, balgu, ssaupj, balsts, ckd) <= 0 then
	f_message_chk(50,'[발주진행현황-품목별]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1
end function

on w_imt_02590.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_d_imt_02590_01_s=create pb_d_imt_02590_01_s
this.pb_d_imt_02590_01_e=create pb_d_imt_02590_01_e
this.pb_d_imt_02600_01_s=create pb_d_imt_02600_01_s
this.pb_d_imt_02600_01_e=create pb_d_imt_02600_01_e
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_d_imt_02590_01_s
this.Control[iCurrent+3]=this.pb_d_imt_02590_01_e
this.Control[iCurrent+4]=this.pb_d_imt_02600_01_s
this.Control[iCurrent+5]=this.pb_d_imt_02600_01_e
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_3
end on

on w_imt_02590.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.pb_d_imt_02590_01_s)
destroy(this.pb_d_imt_02590_01_e)
destroy(this.pb_d_imt_02600_01_s)
destroy(this.pb_d_imt_02600_01_e)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;/* 발주단위 사용여부를 환경설정에서 검색함 */
bagbn	= 'N';
select dataname
  into :bagbn
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
 
if sqlca.sqlcode <> 0 then
	bagbn = 'N'
end if

IF bagbn = 'Y' then	// 발주단위를 사용하는 경우
	dw_list.DataObject = "d_imt_02590_02_1"
	dw_print.DataObject = "d_imt_02590_02_1_p"
else						// 발주단위를 사용안하는 경우
	dw_list.DataObject = "d_imt_02590_02"
	dw_print.DataObject = "d_imt_02590_02_p"
end if
dw_print.SetTransObject(SQLCA)

dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

/* 부가 사업장 */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
	End if
End If

///* 생산팀 & 영업팀 & 관할구역 Filtering */
//DataWindowChild state_child1, state_child2, state_child3
//integer rtncode1, rtncode2, rtncode3
//
//IF gs_saupj              = '10' THEN
//	rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,2) = '01'")
//	state_child2.setFilter("Mid(rfgub,1,2) = '01'")
//	state_child1.Filter()
//	state_child2.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('emp1', state_child1)
//	rtncode2    = dw_ip.GetChild('emp2', state_child2)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	IF rtncode2 = -1 THEN MessageBox("Error2", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child2.setFilter("Mid(rfgub,1,1) = 'Z'")
//	state_child1.Filter()
//	state_child2.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//담당자1
rtncode 	= dw_ip.GetChild('emp1', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자1")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)

//담당자2
rtncode 	= dw_ip.GetChild('emp2', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자2")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)
end event

event ue_retrieve;if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN  
	SetPointer(Arrow!)
	dw_ip.SetFocus()
	Return
END IF
dw_print.object.datawindow.print.preview = "yes"	
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	
end event

type dw_list from w_standard_print`dw_list within w_imt_02590
integer height = 1964
string dataobject = "d_imt_02590_02"
end type

type cb_print from w_standard_print`cb_print within w_imt_02590
integer x = 3090
integer y = 780
end type

type cb_excel from w_standard_print`cb_excel within w_imt_02590
integer x = 2423
integer y = 780
end type

type cb_preview from w_standard_print`cb_preview within w_imt_02590
integer x = 2757
integer y = 780
end type

type cb_1 from w_standard_print`cb_1 within w_imt_02590
integer x = 2089
integer y = 780
end type

type dw_print from w_standard_print`dw_print within w_imt_02590
integer x = 4297
integer y = 180
string dataobject = "d_imt_02590_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02590
integer x = 480
integer y = 44
integer width = 3406
integer height = 196
string dataobject = "d_imt_02590_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.gettext())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1",s_cod)		
	this.setitem(1,"cvnm1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod2",s_cod)		
	this.setitem(1,"cvnm2",s_nam1)
	return i_rtn
elseif this.GetColumnName() = "itnbr1" then 	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itnbr2" then 	
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itdsc1" then 	
	s_nam1 = s_cod
	i_rtn = f_get_name2("품명", "Y", s_cod, s_nam1, s_nam2)
	this.object.itnbr1[1] = s_cod
	this.object.itdsc1[1] = s_nam1
   return i_rtn
elseif this.GetColumnName() = "itdsc2" then 	
	s_nam1 = s_cod	
	i_rtn = f_get_name2("품명", "Y", s_cod, s_nam1, s_nam2)
	this.object.itnbr2[1] = s_cod
	this.object.itdsc2[1] = s_nam1
   return i_rtn	
end if

end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
IF this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnm1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	open(w_vndmst_popup)
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnm2", gs_codename)
ELSEIF This.GetColumnName() = "itnbr1" then //품번
	open(w_itemas_popup)
	this.object.itnbr1[1] = gs_code
	this.object.itdsc1[1] = gs_codename
ELSEIF This.GetColumnName() = "itnbr2" then //품번
	open(w_itemas_popup)
	this.object.itnbr2[1] = gs_code
	this.object.itdsc2[1] = gs_codename
END IF
end event

event dw_ip::itemerror;return 1
end event

type r_1 from w_standard_print`r_1 within w_imt_02590
end type

type r_2 from w_standard_print`r_2 within w_imt_02590
boolean visible = false
end type

type dw_1 from datawindow within w_imt_02590
integer x = 50
integer y = 56
integer width = 384
integer height = 172
integer taborder = 5
boolean bringtotop = true
string dataobject = "d_imt_02590_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_ip.SetReDraw(False)

if gubun = "1" then //발주번호별
	dw_ip.DataObject = "d_imt_02590_01"	
	pb_d_imt_02590_01_s.Visible = True
	pb_d_imt_02590_01_e.Visible = True
	pb_d_imt_02600_01_s.Visible = False
	pb_d_imt_02600_01_e.Visible = False
	IF bagbn = 'Y' then	// 발주단위를 사용하는 경우
		dw_list.DataObject = "d_imt_02590_02_1"
		dw_print.DataObject = "d_imt_02590_02_1_p"
	else						// 발주단위를 사용안하는 경우
		dw_list.DataObject = "d_imt_02590_02"
		dw_print.DataObject = "d_imt_02590_02_p"
	end if
elseif gubun = "2" then	//품목별
	dw_ip.DataObject = "d_imt_02600_01"	
	pb_d_imt_02590_01_s.Visible = False
	pb_d_imt_02590_01_e.Visible = False
	pb_d_imt_02600_01_s.Visible = True
	pb_d_imt_02600_01_e.Visible = True
	IF bagbn = 'Y' then	// 발주단위를 사용하는 경우	
		dw_list.DataObject = "d_imt_02600_02_1"
		dw_print.DataObject = "d_imt_02600_02_1_p"
	else
		dw_list.DataObject = "d_imt_02600_02"
		dw_print.DataObject = "d_imt_02600_02_p"
	end if
end if	
dw_ip.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetReDraw(True)
end event

type pb_d_imt_02590_01_s from u_pic_cal within w_imt_02590
integer x = 1975
integer y = 60
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

type pb_d_imt_02590_01_e from u_pic_cal within w_imt_02590
integer x = 2414
integer y = 60
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

type pb_d_imt_02600_01_s from u_pic_cal within w_imt_02590
boolean visible = false
integer x = 1792
integer y = 60
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

type pb_d_imt_02600_01_e from u_pic_cal within w_imt_02590
boolean visible = false
integer x = 2231
integer y = 60
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

type rr_1 from roundrectangle within w_imt_02590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 12639424
integer x = 466
integer y = 36
integer width = 3438
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_imt_02590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 12639424
integer x = 32
integer y = 36
integer width = 421
integer height = 212
integer cornerheight = 40
integer cornerwidth = 55
end type

