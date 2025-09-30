$PBExportHeader$w_pdt_02000.srw
$PBExportComments$생산승인등록
forward
global type w_pdt_02000 from w_inherite
end type
type cb_up from commandbutton within w_pdt_02000
end type
type dw_information from datawindow within w_pdt_02000
end type
type dw_1 from u_d_popup_sort within w_pdt_02000
end type
type dw_head from datawindow within w_pdt_02000
end type
type p_up from picture within w_pdt_02000
end type
type rr_4 from roundrectangle within w_pdt_02000
end type
type rr_1 from roundrectangle within w_pdt_02000
end type
end forward

global type w_pdt_02000 from w_inherite
integer height = 2576
string title = "생산승인등록"
cb_up cb_up
dw_information dw_information
dw_1 dw_1
dw_head dw_head
p_up p_up
rr_4 rr_4
rr_1 rr_1
end type
global w_pdt_02000 w_pdt_02000

type variables
string is_ispec, is_jijil
end variables

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_jego (string arg_ordno, string arg_itnbr)
public subroutine wf_reset ()
end prototypes

public function integer wf_requiredchk ();
Long Lrow, Lcnt
Decimal {3} dQty
String  sorder, sitnbr, sError, ls_saupj

Lrow = dw_1.rowcount()
ls_saupj	= dw_head.GetItemString(1,"saupj")

For Lcnt = 1 to Lrow
	
	 Sle_msg.text = '자료를 검증 중입니다....!!'
	
	 If dw_1.getitemstring(Lcnt, "yumu") = '3' then
		 if isnull(dw_1.getitemstring(Lcnt, "sorder_misayu")) or &
			 trim(dw_1.getitemstring(Lcnt, "sorder_misayu")) = "" then
			 f_message_chk(1400,'[미승인 사유]')
			 dw_1.scrolltorow(Lcnt)
			 dw_1.setfocus()
			 return -1
		 end if
	 end if
	 
	 if dw_head.getitemstring(1, "gubun") = '1' then		/* 신규작업인 경우 */
		
		 Sle_msg.text = '수주승인에 대한 작업지시를 연결중입니다'	 		
	 
		 If dw_1.getitemstring(Lcnt, "yumu") = '2' then	 
	 
			 sOrder = dw_1.getitemstring(Lcnt, "sorder_order_no")
			 sItnbr = dw_1.getitemstring(Lcnt, "sorder_itnbr")
			 dQty   = dw_1.getitemDecimal(Lcnt, "sorder_order_Qty")	 
		 
		 
			 sError = 'X'
			 sqlca.erp000000870(gs_sabu,ls_saupj, sorder, sitnbr, dqty, sError);
			 Choose Case sError
					  Case 'X'
							 F_message_chk(41,'[할당내역 계산]')
							 Rollback;
							 return -1;
					  Case 'Y'
							 F_message_chk(89,'[할당내역 계산]')
							 Rollback;
							 return -1;
			 End Choose
		 end if
	end if	 
		 
Next

return 1
end function

public function integer wf_jego (string arg_ordno, string arg_itnbr);Decimal {3} dSilQty, dPlanQty, dJisiqty
STring sToday

stoday = f_today()

if dw_information.retrieve(gs_sabu, arg_ordno) > 0 then

	/* 계획수량 */					
	Select Nvl(Sum(b.monqty1), 0)
	  Into :dPlanqty
	  from monpln_sum b
	 where b.sabu 		= :gs_sabu	   and b.monyymm = substr(:stoday, 1, 6)
		and b.itnbr		= :arg_itnbr   and b.moseq = (select max(a.moseq) from monpln_sum a
																	where a.sabu    = :gs_sabu
																	  and a.monyymm = substr(:stoday, 1, 6));
	
	/* 실적수량 */
	select NVl(a.ypdqty , 0)
	  Into :dsilQty
	  from yeapln a
	 where a.sabu 		= :gs_sabu		and a.itnbr =   :arg_itnbr
		and a.yeayymm 	= substr(:stoday, 1, 6)
		and a.yeacha  	= 0 				and a.yeagubn = '0' And a.yeagu = 'B';
		
	/* 작업지시수량 */
	
	Select Sum(Nvl(jisi_qty, 0))   + Sum(Nvl(balju_qty, 0)) +
			 Sum(Nvl(prod_qty, 0))  + Sum(Nvl(pob_qc_qty, 0)) + Sum(Nvl(ins_qty, 0))   +
			 Sum(Nvl(gi_qc_qty, 0)) + Sum(Nvl(gita_in_qty, 0))
	  into :dJisiqty
	  From Stock
	 where itnbr = :arg_itnbr;
 
	dw_information.setitem(1, "planqty", dPlanqty)
	dw_information.setitem(1, "jiqty",   dJisiqty)
	dw_information.setitem(1, "silqty",  dSilqty)	
	dw_information.setitem(1, "Janqty",  dPlanqty - (dJisiqty + dSilqty))
end if
					
return 1
end function

public subroutine wf_reset ();Rollback;

dw_information.reset()
dw_1.reset()
dw_head.enabled = true
//cb_inq.enabled = true
p_inq.enabled = true
p_inq.PictureName = 'C:\erpman\image\조회_up.gif'

//cb_can.enabled = false
p_can.enabled = false
p_can.PictureName = 'C:\erpman\image\취소_d.gif'

//cb_up.enabled = false
p_up.enabled = false
p_up.PictureName = 'C:\erpman\image\일괄승인_d.gif'

//cb_search.enabled = false
p_search.enabled = false
p_search.PictureName = 'C:\erpman\image\일괄취소_d.gif'

//cb_mod.enabled = false
p_mod.enabled = false
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'

dw_head.object.sfrom[1] = is_today
dw_head.object.sto[1]   = is_today

dw_head.setcolumn("gubun")
dw_head.setfocus()

f_mod_saupj(dw_head, 'saupj')


end subroutine

on w_pdt_02000.create
int iCurrent
call super::create
this.cb_up=create cb_up
this.dw_information=create dw_information
this.dw_1=create dw_1
this.dw_head=create dw_head
this.p_up=create p_up
this.rr_4=create rr_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_up
this.Control[iCurrent+2]=this.dw_information
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_head
this.Control[iCurrent+5]=this.p_up
this.Control[iCurrent+6]=this.rr_4
this.Control[iCurrent+7]=this.rr_1
end on

on w_pdt_02000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_up)
destroy(this.dw_information)
destroy(this.dw_1)
destroy(this.dw_head)
destroy(this.p_up)
destroy(this.rr_4)
destroy(this.rr_1)
end on

event open;call super::open;/* 선택화면에 현재일자를 setting */
dw_information.SetTransObject(SQLCA)
dw_head.SetTransObject(SQLCA)
dw_head.insertrow(0)
dw_1.SetTransObject(SQLCA)


wf_reset()

end event

type dw_insert from w_inherite`dw_insert within w_pdt_02000
boolean visible = false
integer x = 1815
integer y = 2564
integer width = 754
integer height = 124
integer taborder = 0
boolean enabled = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String snull, old_yumu, sgubun 
Setnull(snull)

if dwo.name = "yumu" then
	Choose case data
		 case '1'
				this.object.sorder_agrdat[row] = snull
				this.object.sorder_misayu[row] = snull
		 case '2'
			   old_yumu = this.getitemstring(row, 'yumu')
				sgubun   = this.getitemstring(row, 'yebi1')
				if sgubun = 'N' then 
					messagebox("확 인", "생산거부된 품목입니다. 품목마스타를 확인하세요", StopSign!)
					this.setitem(row, 'yumu', old_yumu)
					return 1
				end if	
				this.object.sorder_agrdat[row] = f_today()
				this.object.sorder_misayu[row] = snull
		 case '3'
				this.object.sorder_agrdat[row] = '0'
	End choose
end if
	
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;Long Lrow

Lrow = getrow()

if  Lrow > 0 then
	 wf_jego(getitemstring(Lrow, "sorder_order_no"), getitemstring(Lrow, "sorder_itnbr"))
end if
end event

event dw_insert::doubleclicked;Long Lrow

Lrow = getrow()

if Lrow > 0 then
	gs_code 		= getitemstring(Lrow, "sorder_itnbr")
	gs_codename = getitemstring(Lrow, "itemas_itdsc")
	open(w_pdt_02000_a)
end if

setnull(gs_code)
setnull(gs_codename)


end event

event dw_insert::clicked;If Row <= 0 then
	Return 
ELSE
	SetRow(row)
END IF

end event

type p_delrow from w_inherite`p_delrow within w_pdt_02000
boolean visible = false
integer x = 2917
integer y = 2548
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02000
boolean visible = false
integer x = 3104
integer y = 2560
end type

type p_search from w_inherite`p_search within w_pdt_02000
integer x = 3575
integer y = 16
boolean enabled = false
string picturename = "C:\erpman\image\일괄취소_d.gif"
end type

event p_search::clicked;call super::clicked;Long 		Lrow
String	sNull

Setnull(sNull)

sle_msg.text = '일괄취소 중입니다......!!'

For Lrow = 1 to dw_1.rowcount()
	if dw_1.getitemstring(Lrow, "jisi_yumu") = '지시중' then
	else
		dw_1.setitem(Lrow, "yumu", '1')
		dw_1.setitem(Lrow, "sorder_misayu", snull)
		dw_1.object.sorder_agrdat[Lrow] = sNull
		dw_1.object.sorder_misayu[Lrow] = snull	
	end if
Next

sle_msg.text = ''
Messagebox("일괄취소", "일괄취소를 완료하였읍니다..!!", information!)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\일괄취소_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\일괄취소_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdt_02000
boolean visible = false
integer x = 3241
integer y = 2544
end type

type p_exit from w_inherite`p_exit within w_pdt_02000
integer y = 16
end type

type p_can from w_inherite`p_can within w_pdt_02000
integer y = 16
boolean enabled = false
string picturename = "C:\erpman\image\취소_d.gif"
end type

event p_can::clicked;call super::clicked;wf_reset()
end event

type p_print from w_inherite`p_print within w_pdt_02000
integer x = 4096
integer y = 16
end type

event p_print::clicked;call super::clicked;openwithparm(w_pdt_02000_1, dw_head)
end event

type p_inq from w_inherite`p_inq within w_pdt_02000
integer x = 3749
integer y = 16
end type

event p_inq::clicked;Long    Lrow
Integer icnt
string  fdate, tdate, spdtgu, epdtgu, sittyp, sfitcls, stitcls, sempno
String	ls_saupj

setpointer(hourglass!)
if dw_head.accepttext() = -1 then return 

fdate  		= trim(dw_head.object.sfrom[1])
tdate  		= trim(dw_head.object.sto[1])
spdtgu 	= trim(dw_head.getitemstring(1, 'pdtgu')) 
epdtgu 	= trim(dw_head.getitemstring(1, 'epdtgu')) 
sittyp 		= trim(dw_head.getitemstring(1, 'ittyp')) 
sfitcls 		= trim(dw_head.getitemstring(1, 'fitcls')) 
stitcls 		= trim(dw_head.getitemstring(1, 'titcls')) 
sempno  	= trim(dw_head.getitemstring(1, 'empno')) 
ls_saupj	= dw_head.getitemstring(1, 'saupj')

if fdate = ''  or isnull(fdate)  then fdate = '10000101'
if Tdate = ''  or isnull(tdate)  then tdate = '99991231'
if spdtgu = '' or isnull(spdtgu) then spdtgu = '.'
if epdtgu = '' or isnull(epdtgu) then epdtgu = 'zzzzzz'

if sittyp = '' or isnull(sittyp) then sittyp = '%'
if sfitcls = '' or isnull(sfitcls) then sfitcls = '.'
if stitcls = '' or isnull(stitcls) then 
	stitcls = 'zzzzzzz'
else
	stitcls = stitcls + 'zzzzzz'
end if	
if sempno = '' or isnull(sempno) then sempno = '%'

dw_1.setredraw(false)

if dw_head.object.gubun[1] = '1' then
	dw_1.dataobject = "d_pdt_02000_1"
	dw_1.settransobject(sqlca)

	Lrow = dw_1.retrieve(gs_sabu,ls_saupj, fdate, tdate, spdtgu, epdtgu, sfitcls, stitcls, sempno, sittyp)
	If Lrow = 0 then
		f_message_chk(56,'[미승인 내역]')		
		dw_head.setfocus()
		setpointer(arrow!)
		dw_1.setredraw(true)
		return
	end if
else
	dw_1.dataobject = "d_pdt_02000_2"
	dw_1.settransobject(sqlca)
	Lrow = dw_1.retrieve(gs_sabu, ls_saupj, fdate, tdate, spdtgu, epdtgu, sfitcls, stitcls, sempno, sittyp)
	If Lrow = 0 then
		f_message_chk(56,'[승인 내역]')		
		dw_head.setfocus()
		setpointer(arrow!)
		dw_1.setredraw(true)
		return
	end if
end if

For icnt = 1 to Lrow
	 if     dw_1.getitemstring(icnt, "sorder_agrdat") = '0'  then
			  dw_1.object.yumu[icnt] = "3"
	 Elseif dw_1.getitemstring(icnt, "sorder_agrdat") > '0'  then
			  dw_1.object.yumu[icnt] = "2"						
	 Else   
			  dw_1.object.yumu[icnt] = "1"
	 End if
Next

dw_head.enabled = false
//cb_can.enabled = true
p_can.enabled = true
p_can.PictureName = 'C:\erpman\image\취소_up.gif'

//cb_mod.enabled = true
p_mod.enabled = true
p_mod.PictureName = 'C:\erpman\image\저장_up.gif'

//cb_up.enabled = true
p_up.enabled = true
p_up.PictureName = 'C:\erpman\image\일괄승인_up.gif'

//cb_search.enabled = true
p_search.enabled = true
p_search.PictureName = 'C:\erpman\image\일괄취소_up.gif'

p_inq.enabled = false
p_inq.PictureName = 'C:\erpman\image\조회_d.gif'

if  Lrow > 0 then
	 wf_jego(dw_1.getitemstring(1, "sorder_order_no"), dw_1.getitemstring(1, "sorder_itnbr"))
end if

sle_msg.text = 'Double Click시 공정 및 재고상세내역이 조회됩니다!'

dw_1.setredraw(true)		
dw_1.setfocus()

end event

type p_del from w_inherite`p_del within w_pdt_02000
boolean visible = false
integer x = 4014
integer y = 2468
end type

type p_mod from w_inherite`p_mod within w_pdt_02000
integer y = 16
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;if dw_1.accepttext() = -1 then return 

if wf_requiredchk()   = -1 then 
	sle_msg.text = ''
	return
end if

sle_msg.text = ''

If dw_1.update() = -1 then
	rollback ;
	dw_1.setfocus()
else
	commit;
	wf_reset()
end if
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02000
integer x = 3319
integer y = 2772
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02000
integer x = 2624
integer y = 2772
integer taborder = 70
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02000
integer x = 786
integer y = 2560
end type

type cb_del from w_inherite`cb_del within w_pdt_02000
integer x = 1161
integer y = 2564
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02000
integer x = 59
integer y = 2008
integer height = 40
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_02000
integer x = 626
integer y = 2572
integer width = 741
integer taborder = 40
string text = "작업의뢰서 출력(&P)"
end type

type st_1 from w_inherite`st_1 within w_pdt_02000
end type

type cb_can from w_inherite`cb_can within w_pdt_02000
integer x = 2971
integer y = 2772
integer taborder = 80
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_02000
integer x = 1906
integer y = 2772
integer width = 402
integer taborder = 60
boolean enabled = false
string text = "일괄취소"
end type





type gb_10 from w_inherite`gb_10 within w_pdt_02000
integer x = 23
integer y = 2636
integer height = 144
integer textsize = -9
fontcharset fontcharset = ansi!
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02000
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02000
end type

type cb_up from commandbutton within w_pdt_02000
boolean visible = false
integer x = 1490
integer y = 2772
integer width = 402
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "일괄승인"
end type

type dw_information from datawindow within w_pdt_02000
integer x = 41
integer y = 2156
integer width = 4567
integer height = 152
boolean bringtotop = true
string dataobject = "d_pdt_02000_3"
boolean border = false
boolean livescroll = true
end type

type dw_1 from u_d_popup_sort within w_pdt_02000
integer x = 41
integer y = 440
integer width = 4558
integer height = 1668
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_02000_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
	SetRow(row)
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;call super::doubleclicked;Long Lrow

Lrow = getrow()

if Lrow > 0 then
	gs_code 		= getitemstring(Lrow, "sorder_itnbr")
	gs_codename = getitemstring(Lrow, "itemas_itdsc")
	open(w_pdt_02000_a)
end if

setnull(gs_code)
setnull(gs_codename)


end event

event itemchanged;call super::itemchanged;String snull, old_yumu, sgubun 
Setnull(snull)

if dwo.name = "yumu" then
	Choose case data
		 case '1'
				this.object.sorder_agrdat[row] = snull
				this.object.sorder_misayu[row] = snull
		 case '2'
			   old_yumu = this.getitemstring(row, 'yumu')
				sgubun   = this.getitemstring(row, 'yebi1')
				if sgubun = 'N' then 
					messagebox("확 인", "생산거부된 품목입니다. 품목마스타를 확인하세요", StopSign!)
					this.setitem(row, 'yumu', old_yumu)
					return 1
				end if	
				this.object.sorder_agrdat[row] = f_today()
				this.object.sorder_misayu[row] = snull
		 case '3'
				this.object.sorder_agrdat[row] = '0'
	End choose
end if
	
end event

event itemerror;call super::itemerror;return 1
end event

event dw_1::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event rowfocuschanged;call super::rowfocuschanged;Long Lrow

Lrow = getrow()

if  Lrow > 0 then
	 wf_jego(getitemstring(Lrow, "sorder_order_no"), getitemstring(Lrow, "sorder_itnbr"))
end if
end event

type dw_head from datawindow within w_pdt_02000
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 164
integer width = 4603
integer height = 240
integer taborder = 10
string dataobject = "d_pdt_02000"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event itemchanged;string  sdate, snull

setnull(snull)

IF this.GetColumnName() = "sfrom" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sDate) = -1 THEN
		f_message_chk(35,'[수주승인일]')
		this.SetItem(1,"sfrom",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = "sto" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sDate) = -1 THEN
		f_message_chk(35,'[수주승인일]')
		this.SetItem(1,"sto",snull)
		Return 1
	END IF
ELSEIF this.GetColumnName() = "ittyp" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN 
		setitem(1, "ittyp", '1')
	End if
		

	IF IsNull(f_get_reffer('05', sDate)) THEN
		f_message_chk(35,'[품목구분]')
		this.SetItem(1,"ittyp", '1')
		Return 1
	END IF		
END IF
end event

event rbuttondown;string sittyp
str_itnct lstr_sitnct

gs_code     = ''
gs_codename = ''
gs_gubun    = ''

if this.GetColumnName() = 'fitcls' then

	sIttyp   = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
//	this.SetItem(1, "ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1, "fitcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls' then

	sIttyp   = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
//	this.SetItem(1, "ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1, "titcls", lstr_sitnct.s_sumgub)
END IF
end event

type p_up from picture within w_pdt_02000
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3401
integer y = 16
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\일괄승인_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\일괄승인_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\일괄승인_up.gif'
end event

event clicked;call super::clicked;Long 		Lrow
String	sNull

Setnull(sNull)

sle_msg.text = '일괄승인 중입니다......!!'

For Lrow = 1 to dw_1.rowcount()
	dw_1.setitem(Lrow, "yumu", '2')
	dw_1.setitem(Lrow, "sorder_misayu", snull)
	dw_1.object.sorder_agrdat[Lrow] = f_today()
	dw_1.object.sorder_misayu[Lrow] = snull	
Next

sle_msg.text = ''
Messagebox("일괄승인", "일괄승인을 완료하였읍니다..!!", information!)
end event

type rr_4 from roundrectangle within w_pdt_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 428
integer width = 4590
integer height = 1692
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdt_02000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 2140
integer width = 4590
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

