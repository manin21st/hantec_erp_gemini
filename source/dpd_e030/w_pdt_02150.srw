$PBExportHeader$w_pdt_02150.srw
$PBExportComments$작업실적등록-불량 및 폐기내역
forward
global type w_pdt_02150 from w_inherite
end type
type gb_2 from groupbox within w_pdt_02150
end type
type gb_1 from groupbox within w_pdt_02150
end type
type dw_insert1 from u_key_enter within w_pdt_02150
end type
type rr_1 from roundrectangle within w_pdt_02150
end type
type rr_2 from roundrectangle within w_pdt_02150
end type
end forward

global type w_pdt_02150 from w_inherite
integer x = 46
integer y = 96
integer width = 3634
integer height = 2296
string title = "작업실적등록(불량/폐기)"
boolean minbox = false
windowtype windowtype = response!
gb_2 gb_2
gb_1 gb_1
dw_insert1 dw_insert1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_02150 w_pdt_02150

type variables
datawindow dwname
string isjpno, iswkctr
end variables

forward prototypes
public function integer wf_requiredcheck (ref string asjpno, ref decimal afaqty, ref decimal apeqty)
end prototypes

public function integer wf_requiredcheck (ref string asjpno, ref decimal afaqty, ref decimal apeqty);Long lrow
Decimal {3} faqty, peqty
string sjpno, sGubn

faqty = 0
peqty = 0

// 작업자 필수입력여부 check(Y.인 경우 필수 입력)
select dataname
  into :sGubn
  from syscnfg
 where sysgu = 'Y' and serial = '25' and lineno = '1';
 
if isnull(sGubn) or trim(sGubn) = '' then
	sGubn = 'N'
end if

dw_insert1.accepttext()
dw_insert.accepttext()

// 불량내역 검증
for lrow = 1 to dw_insert1.rowcount()		/* 불량 */
	
	 if isnull(dw_insert1.getitemstring(lrow, "shpfat_gucod")) or &
	    trim(dw_insert1.getitemstring(lrow, "shpfat_gucod")) = ""	 then
		 f_message_chk(1400,'[불량항목]') 
		 dw_insert1.setcolumn("shpfat_gucod")
		 dw_insert1.scrolltorow(lrow)
		 return -1
	 end if	

	 if dw_insert1.getitemdecimal(lrow, "shpfat_guqty") = 0 then
		 f_message_chk(1400,'[불량수량]') 
		 dw_insert1.setcolumn("shpfat_guqty")
		 dw_insert1.scrolltorow(lrow)
		 return -1
	 end if
	 
//	 if isnull(dw_insert1.getitemstring(lrow, "shpfat_opseq")) or &
//		 trim(dw_insert1.getitemstring(lrow, "shpfat_opseq")) = ""	 then
//		 f_message_chk(1400,'[공정코드]') 
//		 dw_insert1.setcolumn("shpfat_opseq")
//		 dw_insert1.scrolltorow(lrow)
//		 return -1
//	 end if		 
	 
//	 if sGubn = 'Y' then
//		 if isnull(dw_insert1.getitemstring(lrow, "empname")) or &
//			 trim(dw_insert1.getitemstring(lrow, "empname")) = ""	 then
//			 f_message_chk(1400,'[작업자]') 
//			 dw_insert1.setcolumn("shpfat_empno")
//			 dw_insert1.scrolltorow(lrow)
//			 return -1
//		 end if	
//	 End if
	
	 faqty = faqty + dw_insert1.getitemdecimal(lrow, "shpfat_guqty")
	 dw_insert1.setitem(lrow, "shpfat_sabu", gs_sabu)
	 dw_insert1.setitem(lrow, "shpfat_shpjpno", isjpno)
NExt

// 폐기내역 검증
for lrow = 1 to dw_insert.rowcount()		/* 폐기 */
	
	 if isnull(dw_insert.getitemstring(lrow, "shpfat_gucod")) or &
	    trim(dw_insert.getitemstring(lrow, "shpfat_gucod")) = ""	 then
		 f_message_chk(1400,'[폐기항목]') 
		 dw_insert.setcolumn("shpfat_gucod")
		 dw_insert.scrolltorow(lrow)
		 return -1
	 end if	

	 if dw_insert.getitemdecimal(lrow, "shpfat_guqty") = 0 then
		 f_message_chk(1400,'[폐기수량]') 
		 dw_insert.setcolumn("shpfat_guqty")
		 dw_insert.scrolltorow(lrow)
		 return -1
	 end if	
	
	 peqty = peqty + dw_insert.getitemdecimal(lrow, "shpfat_guqty")
	 dw_insert.setitem(lrow, "shpfat_sabu", gs_sabu)
	 dw_insert.setitem(lrow, "shpfat_shpjpno", isjpno)
NExt

return 1
end function

on w_pdt_02150.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_insert1=create dw_insert1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_insert1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdt_02150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_insert1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dwname = message.powerobjectparm

Long Lrow, ncnt

Lrow = dwname.getrow()

if Lrow > 0 then
	isjpno  = dwname.getitemstring(Lrow, "shpjpno")
	iswkctr = dwname.getitemstring(Lrow, "morout_wkctr")
else
	Close(this)
end if

f_window_center_response(this)

string scolumn

datawindowchild dwc
dw_insert1.getchild("shpfat_opseq", dwc)
dwc.settransobject(sqlca)
scolumn = dwname.getitemstring(Lrow, "morout_pordno")

// 작업그룹(작업장)별 불량을 등록한 경우는 해당 불량항목만 조회 */
select count(*) into :ncnt from wrkgrp_bul where grpcod = :iswkctr;
If nCnt > 0 Then
	f_child_saupj(dw_insert1,'shpfat_gucod',iswkctr)
Else
	f_child_saupj(dw_insert1,'shpfat_gucod','%')
End If

dw_insert.settransobject(sqlca)
dw_insert1.settransobject(sqlca)

IF dwc.retrieve(gs_sabu, scolumn) < 1 THEN 
	dwc.insertrow(0)
end if

dw_insert.retrieve(gs_sabu,  isjpno)
dw_insert1.retrieve(gs_sabu, isjpno)




end event

type dw_insert from w_inherite`dw_insert within w_pdt_02150
integer x = 55
integer y = 1232
integer width = 3520
integer height = 944
integer taborder = 30
string title = "폐기내역"
string dataobject = "d_pdt_02150_1"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;string sitnbr, sitdsc
long lrow

lrow = this.getrow()

if this.getcolumnname() = "shpfat_scode1"  then
	sitnbr = this.gettext()
	
	select rfna1 into :sitdsc from reffpf
	 where  rfcod = '14' and rfgub = :sitnbr;
	 
	 if sqlca.sqlcode <> 0 then
		f_message_chk(101,'[폐기원인]') 		
		this.setitem(lrow, "shpfat_scode1", '')
		this.setitem(lrow, "gname", '')
		RETURN  1	
	end if
	this.setitem(lrow, "gname", sitdsc)
end if
end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;string colname
long   lrow

lrow = this.getrow()
colname = this.getcolumnname()

if colname = "shpfat_scode1" then
		 setnull(gs_code)
		 setnull(gs_codename)
		 open(w_reffpf14_popup)
		 this.setitem(lrow, "shpfat_scode1", gs_code)
		 this.triggerevent(itemchanged!)
end if

gs_code = ''
gs_codename = ''
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02150
integer x = 4613
integer y = 1548
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02150
integer x = 4439
integer y = 1548
end type

type p_search from w_inherite`p_search within w_pdt_02150
integer x = 3744
integer y = 1548
end type

type p_ins from w_inherite`p_ins within w_pdt_02150
integer x = 4265
integer y = 1548
end type

type p_exit from w_inherite`p_exit within w_pdt_02150
integer x = 4389
integer y = 1372
end type

type p_can from w_inherite`p_can within w_pdt_02150
integer x = 3406
end type

event p_can::clicked;call super::clicked;rollback;

close(parent)
end event

type p_print from w_inherite`p_print within w_pdt_02150
integer x = 3918
integer y = 1548
end type

type p_inq from w_inherite`p_inq within w_pdt_02150
integer x = 4091
integer y = 1548
end type

type p_del from w_inherite`p_del within w_pdt_02150
integer x = 4041
integer y = 1372
end type

type p_mod from w_inherite`p_mod within w_pdt_02150
integer x = 3227
end type

event p_mod::clicked;call super::clicked;Long lrow
string sjpno, gucod
decimal dfaqty, dpeqty

if wf_requiredcheck(sjpno, dfaqty, dpeqty) = -1 then
	return
end if

if dw_insert.update() = -1 then
	rollback;
	return
end if
if dw_insert1.update() = -1 then
	rollback;
	return
end if

commit;

close(parent)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02150
integer x = 1499
integer y = 2488
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02150
integer x = 4416
integer y = 1216
integer width = 750
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02150
integer x = 832
integer y = 2576
integer taborder = 40
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_02150
integer x = 2254
integer y = 2556
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02150
integer x = 270
integer y = 2452
integer taborder = 10
end type

type cb_print from w_inherite`cb_print within w_pdt_02150
integer x = 1253
integer y = 2556
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_02150
integer y = 2200
end type

type cb_can from w_inherite`cb_can within w_pdt_02150
integer x = 4416
integer y = 1348
integer width = 750
boolean cancel = true
end type

type cb_search from w_inherite`cb_search within w_pdt_02150
integer x = 1687
integer y = 2592
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_02150
integer x = 2793
integer y = 2412
end type

type sle_msg from w_inherite`sle_msg within w_pdt_02150
integer y = 2412
integer width = 2414
end type

type gb_10 from w_inherite`gb_10 within w_pdt_02150
integer y = 2376
integer width = 3552
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02150
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02150
end type

type gb_2 from groupbox within w_pdt_02150
boolean visible = false
integer x = 279
integer y = 2368
integer width = 379
integer height = 240
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_pdt_02150
integer x = 4128
integer y = 1056
integer width = 1189
integer height = 920
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_insert1 from u_key_enter within w_pdt_02150
event ue_key pbm_dwnkey
integer x = 55
integer y = 192
integer width = 3520
integer height = 1004
integer taborder = 20
string title = "부적합"
string dataobject = "d_pdt_02150"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;if key = keyf1! then
	this.triggerevent(rbuttondown!)
end if
end event

event rbuttondown;setnull(gs_Gubun)
setnull(gs_code)
setnull(gs_codename)

string colname
long   lrow

lrow = this.getrow()
colname = this.getcolumnname()

if colname = "shpfat_itnbr" then
		 open(w_itemas_popup)
		 if isnull(gs_code) or gs_code = "" then return
		 this.SetItem(lrow,"shpfat_itnbr",gs_code)
		 this.TriggerEvent(ItemChanged!)
elseif colname = "shpfat_cvcod" then
		 open(w_vndmst_popup)
		 this.setitem(lrow, "shpfat_cvcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "shpfat_gucod" then
		 open(w_reffpf33_popup)
		 this.setitem(lrow, "shpfat_gucod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "shpfat_empno" then
	    gi_page = 2  //생산직 사원만 조회
		 gs_code = this.gettext()
		 open(w_sawon_popup2)
		 this.setitem(lrow, "shpfat_empno", gs_code)
		 this.triggerevent(itemchanged!)		 		 
elseif colname = "shpfat_deptcode" then
		 open(w_jomas_popup)
		 this.setitem(lrow, "shpfat_deptcode", gs_code)
		 this.triggerevent(itemchanged!)		 		 
end if


end event

event itemchanged;string sitnbr, sitdsc, sispec, sjijil, sispec_code, scvcod, scode, sName, sName2
integer ireturn
long	  lrow

lrow = this.getrow()
this.accepttext()

if this.getcolumnname() = "shpfat_gucod"  then
	sitnbr = this.getitemstring(lrow, "shpfat_gucod") 
	
	select rfna1 into :sitdsc from reffpf
	 where rfcod = '33' and rfgub = :sitnbr;  

//		select b.rfna1 into :sitdsc
//	  from wrkgrp_bul a,
//			 reffpf     b
//	 where a.grpcod = :iswkctr
//		and a.rfgub  = b.rfgub
//		and b.rfcod  = '33'
//		and b.sabu   = '1'
//		and b.rfgub  = :sitnbr;
	
	 if sqlca.sqlcode <> 0 then
		f_message_chk(101,'[불량항목]') 		
		this.setitem(lrow, "shpfat_gucod", '')
		this.setitem(lrow, "gname", '')
		RETURN  1	
	end if
	this.setitem(lrow, "gname", sitdsc)
ElseIF this.GetColumnName() = "shpfat_itnbr"	THEN
	sItnbr = trim(this.getitemstring(lrow, "shpfat_itnbr"))
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "shpfat_itnbr", sitnbr)	
	if sitnbr > '.' then 
		if isnull(sitdsc) then sitdsc = ' '
		if isnull(sispec) then sispec = ' '
		if isnull(sjijil) then sjijil = ' '
		if isnull(sispec_code) then sispec_code = ' '
	end if
	sitdsc = sitdsc + '.' + sispec + '.' + sjijil + '-' + sispec_code
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	RETURN ireturn
elseif this.getcolumnname() = "shpfat_guqty"  then
	if dec(this.gettext()) < 1 then
		f_message_chk(78,'[불량수량]') 
		RETURN  1	
	end if
elseif this.getcolumnname() = "shpfat_cvcod"	 then
	scvcod = this.gettext()
	ireturn = f_get_name2('V1', 'Y', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "shpfat_cvcod", scvcod)	
	this.setitem(lrow, "vndmst_cvnas2", sitdsc)	
	RETURN ireturn
elseif this.getcolumnname() = "shpfat_empno" then	// 작업자
   sCode = trim(this.gettext())
	 
  	ireturn = f_get_name2('사번', 'Y', scode, sname, sname2) 
	this.setitem(lrow, "shpfat_empno", scode)
	this.setitem(lrow, "empname", sname)
	return ireturn 	
elseif this.getcolumnname() = "shpfat_deptcode" then	// 작업자
   sCode = trim(this.gettext())
	 
  	ireturn = f_get_name2('조', 'Y', scode, sname, sname2) 
	this.setitem(lrow, "shpfat_deptcode", scode)
	this.setitem(lrow, "jomast_jonam", sname)
	return ireturn 	
end if
end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_pdt_02150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 184
integer width = 3538
integer height = 1020
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 1220
integer width = 3538
integer height = 964
integer cornerheight = 40
integer cornerwidth = 55
end type

