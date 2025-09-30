$PBExportHeader$w_mm90_00130.srw
$PBExportComments$매입반품현황
forward
global type w_mm90_00130 from w_standard_print
end type
type pb_1 from u_pb_cal within w_mm90_00130
end type
type pb_2 from u_pb_cal within w_mm90_00130
end type
type rr_1 from roundrectangle within w_mm90_00130
end type
type rr_2 from roundrectangle within w_mm90_00130
end type
end forward

global type w_mm90_00130 from w_standard_print
string title = "매입 공제 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_mm90_00130 w_mm90_00130

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	sfdate, stdate, scvcod, sgubun, ls_saupj, ls_bkgbn

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sfdate = trim(dw_ip.getitemstring(1,'fdate'))
stdate = trim(dw_ip.getitemstring(1,'tdate'))
scvcod = dw_ip.getitemstring(1,'cvcod')
sgubun = '%'
ls_saupj=dw_ip.getitemstring(1,'saupj')
ls_bkgbn=dw_ip.getitemstring(1,'bkgbn')

if isnull(sfdate) or sfdate = '' then
	f_message_chk(30,'[일자 from]')
	dw_ip.setcolumn('fdate')
	dw_ip.setfocus()
	return -1
end if

if isnull(stdate) or stdate = '' then
	f_message_chk(30,'[일자 to]')
	dw_ip.setcolumn('tdate')
	dw_ip.setfocus()
	return -1
end if

If sfdate > stdate Then
   MessageBox('확인','날짜 범위지정에 벗어납니다.')
	dw_ip.setcolumn('tdate')
	dw_ip.setfocus()
	return -1
end If

if isnull(scvcod) or scvcod = '' then scvcod = '%'

setpointer(hourglass!)
if dw_list.retrieve(ls_saupj,sfdate,stdate,scvcod,sgubun,ls_bkgbn) < 1 then
	f_message_chk(50,'[매입 반품 현황]')
	dw_ip.Setfocus()
	return -1
end if

Return 1
end function

on w_mm90_00130.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_mm90_00130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.Object.fdate[1] = left(is_today,6)+'01'
dw_ip.Object.tdate[1] = is_today

///* User별 사업장 Setting Start */
//String saupj
//
//If f_check_saupj(saupj) = 1 Then
//	dw_ip.Modify("saupj.protect=1")
//End If
//dw_ip.SetItem(1, 'saupj', saupj)
f_mod_saupj(dw_ip, 'saupj')
/* ---------------------- End  */
end event

type p_preview from w_standard_print`p_preview within w_mm90_00130
end type

type p_exit from w_standard_print`p_exit within w_mm90_00130
end type

type p_print from w_standard_print`p_print within w_mm90_00130
end type

type p_retrieve from w_standard_print`p_retrieve within w_mm90_00130
end type







type st_10 from w_standard_print`st_10 within w_mm90_00130
end type



type dw_print from w_standard_print`dw_print within w_mm90_00130
integer x = 3301
integer y = 132
integer height = 76
string dataobject = "d_mm90_00130_p"
end type

type dw_ip from w_standard_print`dw_ip within w_mm90_00130
integer x = 59
integer y = 52
integer width = 3081
integer height = 160
string dataobject = "d_mm90_00130_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keyF2!) THEN
//   IF	this.getcolumnname() = "cod1"	THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 
//			this.SetItem(1, "cod1", "")
//	      this.SetItem(1, "nam1", "")
//	      return
//	   else
//			this.SetItem(1, "cod1", gs_code)
//	      this.SetItem(1, "nam1", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1
//		end if
//   ELSEIF this.getcolumnname() = "cod2" THEN		
//	   gs_code = this.GetText()
//	   open(w_itemas_popup2)
//	   if isnull(gs_code) or gs_code = "" then 	
//			this.SetItem(1, "cod2", "")
//	      this.SetItem(1, "nam2", "")
//	      return
//	   else
//			this.SetItem(1, "cod2", gs_code)
//	      this.SetItem(1, "nam2", gs_codename)
//	      this.triggerevent(itemchanged!)
//	      return 1	
//		end if	
//   END IF
//END IF  
end event

event dw_ip::itemchanged;string	scvcod, scvnas, snull

setnull(snull)

if this.getcolumnname() = 'cvcod' then
	scvcod = this.gettext()
	
	select cvnas into :scvnas from vndmst
	 where cvcod = :scvcod ;
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',scvnas)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
	
end if
end event

event dw_ip::rbuttondown;call super::rbuttondown;string	snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 거래처
IF this.GetColumnName() = 'cvcod'	THEN
   gs_gubun = '1' 
	open(w_vndmst_popup)

	if Isnull(gs_code) or Trim(gs_code) = "" then 
		this.SetItem(1, "cvnas", snull)
	else
		this.SetItem(1, "cvcod", gs_code)
		this.SetItem(1, "cvnas", gs_codename)
	end if

END IF

end event

type dw_list from w_standard_print`dw_list within w_mm90_00130
integer x = 46
integer y = 268
integer width = 4562
integer height = 1980
string dataobject = "d_mm90_00130_a"
boolean border = false
end type

type pb_1 from u_pb_cal within w_mm90_00130
integer x = 795
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('fdate')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.fdate.protect = '1' Or dw_ip.Object.fdate.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'fdate', gs_code)
end event

type pb_2 from u_pb_cal within w_mm90_00130
integer x = 1243
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('tdate')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.tdate.protect = '1' Or dw_ip.Object.tdate.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'tdate', gs_code)
end event

type rr_1 from roundrectangle within w_mm90_00130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 28
integer width = 3131
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_mm90_00130
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4581
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

