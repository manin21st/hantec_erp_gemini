$PBExportHeader$w_imt_02540.srw
$PBExportComments$** 발주예정 현황
forward
global type w_imt_02540 from w_standard_print
end type
type dw_1 from datawindow within w_imt_02540
end type
type pb_1 from u_pb_cal within w_imt_02540
end type
type pb_2 from u_pb_cal within w_imt_02540
end type
type rr_1 from roundrectangle within w_imt_02540
end type
end forward

global type w_imt_02540 from w_standard_print
string title = "발주예정현황"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_imt_02540 w_imt_02540

type variables
string bagbn

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string autcrt, sempno1, blynd, itgu1, itnbr1, itnbr2, cvcod1, cvcod2, estgu, &
       ssaupj, sfdate, stdate

if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if

autcrt = trim(dw_ip.object.autcrt[1])
sempno1 = trim(dw_ip.object.sempno1[1])
blynd = trim(dw_ip.object.blynd[1])
itgu1 = trim(dw_ip.object.itgu1[1])
itnbr1 = trim(dw_ip.object.itnbr1[1])
itnbr2 = trim(dw_ip.object.itnbr2[1])
cvcod1 = trim(dw_ip.object.cvcod1[1])
cvcod2 = trim(dw_ip.object.cvcod2[1])
estgu  = trim(dw_ip.object.estgu[1])
ssaupj = dw_ip.object.saupj[1]
sfdate = trim(dw_ip.object.fdate[1])
stdate = trim(dw_ip.object.tdate[1])

if (IsNull(autcrt) or autcrt = "")  then 
   f_message_chk(30, "[예정구분]")
	dw_ip.SetColumn("autcrt")
	dw_ip.SetFocus()
	return -1
end if	
if (IsNull(sempno1) or sempno1 = "")  then sempno1 = "%"
if (IsNull(blynd)  or blynd = "")  then blynd = "%"
if (IsNull(itgu1)  or itgu1 = "")  then itgu1 = "%"
if (IsNull(itnbr1) or itnbr1 = "")  then itnbr1 = "."
if (IsNull(itnbr2) or itnbr2 = "")  then itnbr2 = "ZZZZZZZZZZZZZZZ"
if (IsNull(cvcod1) or cvcod1 = "")  then cvcod1 = "."
if (IsNull(cvcod2) or cvcod2 = "")  then cvcod2 = "ZZZZZZ"
if (IsNull(estgu)  or estgu = "")  then estgu = "%"
if (IsNull(sfdate) or sfdate = "")  then sfdate = "10000101"
if (IsNull(stdate) or stdate = "")  then stdate = "99991231"

if dw_print.Retrieve(gs_sabu, autcrt, sempno1, blynd, itgu1, itnbr1, itnbr2, cvcod1, cvcod2, &
                    estgu, ssaupj, sfdate, stdate) <= 0 then
	f_message_chk(50,'[발주예정현황]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.ShareData(dw_list)
end if

return 1
end function

on w_imt_02540.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_imt_02540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;
/* 발주단위 사용여부를 환경설정에서 검색함 */
bagbn	= 'N';
select dataname
  into :bagbn
  from syscnfg
 where sysgu = 'Y' and serial = '12' and lineno = '3';
 
if sqlca.sqlcode <> 0 then
	bagbn = 'N'
end if

if bagbn = 'Y' then 	// 발주단위를 사용하는 경우
	dw_list.DataObject = "d_imt_02540_02_1"
	dw_print.DataObject = "d_imt_02540_02_1_p"
else
	dw_list.DataObject = "d_imt_02540_02"
	dw_print.DataObject = "d_imt_02540_02_p"
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
//	rtncode1    = dw_ip.GetChild('sempno1', state_child1)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,2) = '01'")	
//	state_child1.Filter()
//	
//ELSEIF gs_saupj      = '11' THEN
//   rtncode1    = dw_ip.GetChild('sempno1', state_child1)
//	
//	IF rtncode1 = -1 THEN MessageBox("Error1", "Not a DataWindowChild")
//	
//	state_child1.setFilter("Mid(rfgub,1,1) = 'Z'")	
//	state_child1.Filter()
//END IF

DataWindowChild state_child
integer rtncode

//담당자
rtncode 	= dw_ip.GetChild('sempno1', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('43',gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_imt_02540
end type

type p_exit from w_standard_print`p_exit within w_imt_02540
end type

type p_print from w_standard_print`p_print within w_imt_02540
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_02540
end type







type st_10 from w_standard_print`st_10 within w_imt_02540
end type



type dw_print from w_standard_print`dw_print within w_imt_02540
string dataobject = "d_imt_02540_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_02540
integer x = 55
integer y = 104
integer width = 3589
integer height = 380
integer taborder = 20
string dataobject = "d_imt_02540_01"
end type

event dw_ip::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'itnbr1' then   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"itnbr1", s_cod)		
   this.setitem(1,"itdsc1", s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'itnbr2' then   
	i_rtn = f_get_name2("품번", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"itnbr2", s_cod)		
   this.setitem(1,"itdsc2", s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod1", s_cod)		
   this.setitem(1,"cvnm1", s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cvcod2", s_cod)		
   this.setitem(1,"cvnm2", s_nam1)
	return i_rtn
end if

end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "itnbr1"	THEN		
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "itnbr1", gs_code)
	this.SetItem(1, "itdsc1", gs_codename)
ELSEIF this.getcolumnname() = "itnbr2"	THEN		
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "itnbr2", gs_code)
	this.SetItem(1, "itdsc2", gs_codename)
ELSEIF this.getcolumnname() = "cvcod1"	THEN		
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnm1", gs_codename)
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnm2", gs_codename)
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
IF keydown(keyF2!) THEN
   IF	this.getcolumnname() = "itnbr1"	THEN		
	   open(w_itemas_popup2)
		this.SetItem(1, "itnbr1", gs_code)
      this.SetItem(1, "itdsc1", gs_codename)
		return 
   ELSEIF this.getcolumnname() = "itnbr2" THEN		
	   open(w_itemas_popup2)
		this.SetItem(1, "itnbr2", gs_code)
      this.SetItem(1, "itdsc2", gs_codename)
		return
   END IF
END IF  
end event

type dw_list from w_standard_print`dw_list within w_imt_02540
integer x = 59
integer y = 504
integer width = 4535
integer height = 1820
string dataobject = "d_imt_02540_02"
boolean border = false
end type

type dw_1 from datawindow within w_imt_02540
integer x = 64
integer y = 24
integer width = 722
integer height = 84
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_02540_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String gubun

gubun = Trim(this.GetText())

dw_list.SetReDraw(False)

if bagbn = 'Y' then 	// 발주단위를 사용하는 경우
	if gubun = "1" then //품목별
		dw_list.DataObject = "d_imt_02540_02_1"
		dw_print.DataObject = "d_imt_02540_02_1_p"
	elseif gubun = "2" then	//의뢰번호별
		dw_list.DataObject = "d_imt_02550_02_1"
		dw_print.DataObject = "d_imt_02550_02_1_p"
	elseif gubun = "3" then	//거래처별
		dw_list.DataObject = "d_imt_02560_02_1"
		dw_print.DataObject = "d_imt_02560_02_1_p"
	end if	
Else						// 발주단위를 사용안하는 경우
	if gubun = "1" then //품목별
		dw_list.DataObject = "d_imt_02540_02"
		dw_print.DataObject = "d_imt_02540_02_p"
	elseif gubun = "2" then	//의뢰번호별
		dw_list.DataObject = "d_imt_02550_02"
		dw_print.DataObject = "d_imt_02550_02_p"
	elseif gubun = "3" then	//거래처별
		dw_list.DataObject = "d_imt_02560_02"
		dw_print.DataObject = "d_imt_02560_02_p"
	end if	
end if

dw_print.SetTransObject(SQLCA)
//dw_list.ReSet()
//dw_list.SetReDraw(True)

p_print.Enabled =False
p_print.PictureName =  'C:\erpman\image\인쇄_d.gif'
p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
return
end event

type pb_1 from u_pb_cal within w_imt_02540
integer x = 686
integer y = 112
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('fdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'fdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_02540
integer x = 1138
integer y = 112
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('tdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'tdate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_02540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 500
integer width = 4553
integer height = 1832
integer cornerheight = 40
integer cornerwidth = 55
end type

