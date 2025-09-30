$PBExportHeader$w_pdt_03400.srw
$PBExportComments$작업지시 승인
forward
global type w_pdt_03400 from w_inherite
end type
type dw_suju from datawindow within w_pdt_03400
end type
type dw_1 from datawindow within w_pdt_03400
end type
type cb_1 from commandbutton within w_pdt_03400
end type
type dw_2 from u_d_popup_sort within w_pdt_03400
end type
type st_2 from statictext within w_pdt_03400
end type
type rr_2 from roundrectangle within w_pdt_03400
end type
type rr_3 from roundrectangle within w_pdt_03400
end type
end forward

global type w_pdt_03400 from w_inherite
string title = "작업지시 대기/승인"
dw_suju dw_suju
dw_1 dw_1
cb_1 cb_1
dw_2 dw_2
st_2 st_2
rr_2 rr_2
rr_3 rr_3
end type
global w_pdt_03400 w_pdt_03400

forward prototypes
public function integer wf_modify_update (long lrow)
end prototypes

public function integer wf_modify_update (long lrow);string spordno, spa_Pordno, sPA_Opseq
dec{3} old_qty, dPdqty

old_qty = dw_2.getitemdecimal(lrow, 'old_qty')
dPdqty  = dw_2.getitemdecimal(lrow, 'momast_pdqty')

//수량이 같으면 return 
If old_qty = dPdqty then Return 1

sPordno = dw_2.getitemstring(lrow, 'momast_pordno') //작지번호

//작업지시대 수주 수량 수정(수주일이 빠른 순서로), 반제품 작지는 사람이 수정하는 것으로  
IF old_qty > dPdqty then // 이전 작업지시량이 크면 수주자료 조정 
	UPDATE "MOMORD"  
		SET "SQTY" = "HQTY", "UPD_USER" = :gs_userid  
	 WHERE ( "MOMORD"."SABU"   = :gs_sabu ) AND  
			 ( "MOMORD"."PORDNO" = :sPordno ) AND  
			 ( "MOMORD"."HQTY"   > 0 )   ;
END IF	
if sqlca.sqlcode < 0 then 
	messagebox("수정실패", "수정작업을 실패하였습니다. [작업지시 대 수주]", StopSign!)
   return -1
end if

//할당수량 변경
UPDATE "HOLDSTOCK"  
   SET "HOLD_QTY" = null  
 WHERE ( "HOLDSTOCK"."SABU"   = :gs_sabu ) AND  
		 ( "HOLDSTOCK"."PORDNO" = :sPordno )   ;

if sqlca.sqlcode < 0 then 
	messagebox("수정실패", "수정작업을 실패하였습니다. [할당]", StopSign!)
   return -1
end if

//구매의뢰 수량 변경
UPDATE ESTIMA  
   SET GUQTY  = :dPdqty,   
		 VNQTY  = :dPdqty,   
		 CNVQTY = FUN_GET_CNV(ITNBR, '3', :dPdqty) 
 WHERE SABU = :gs_sabu AND PORDNO = :sPordno ;

if sqlca.sqlcode < 0 then 
	messagebox("수정실패", "수정작업을 실패하였습니다. [외주발주]", StopSign!)
   return -1
end if

spa_Pordno = dw_2.getitemstring(lrow, 'momast_pa_pordno') //분할작지번호

if spa_Pordno > '.' then 
	sPA_Opseq = dw_2.getitemstring(lrow, 'momast_pa_ospeq') //공정
	
	 Update momast
		 set paqty = paqty - :old_qty + :dPdqty
	  where sabu  = :gs_sabu and pordno = :spa_Pordno;

	if sqlca.sqlcode < 0 then 
		messagebox("수정실패", "수정작업을 실패하였습니다. [분할작지 Head 수정]", StopSign!)
		return -1
	end if
	  
	 Update morout
		 set paqty = paqty - :old_qty + :dPdqty
	  where sabu  = :gs_sabu and pordno = :spa_Pordno and opseq = :sPA_Opseq;
	  
	if sqlca.sqlcode < 0 then 
		messagebox("수정실패", "수정작업을 실패하였습니다. [분할작지 DETAIL 수정]", StopSign!)
		return -1
	end if
end if

Return 1
end function

on w_pdt_03400.create
int iCurrent
call super::create
this.dw_suju=create dw_suju
this.dw_1=create dw_1
this.cb_1=create cb_1
this.dw_2=create dw_2
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_suju
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
end on

on w_pdt_03400.destroy
call super::destroy
destroy(this.dw_suju)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_suju.settransobject(sqlca)

dw_1.insertrow(0)
//dw_1.setitem(1, "stdat", f_today())
//dw_1.setitem(1, "eddat", f_today())
dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_03400
boolean visible = false
integer x = 110
integer y = 2824
integer width = 709
integer height = 140
integer taborder = 0
boolean enabled = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

type p_delrow from w_inherite`p_delrow within w_pdt_03400
boolean visible = false
integer x = 3250
end type

type p_addrow from w_inherite`p_addrow within w_pdt_03400
boolean visible = false
integer x = 3205
end type

type p_search from w_inherite`p_search within w_pdt_03400
integer x = 3749
string picturename = "C:\erpman\image\수정_up.gif"
end type

event p_search::clicked;call super::clicked;long lRow, Lfind
string spordno, sitnbr

lRow = dw_2.getrow()

if lRow > 0 then 
	gs_code = dw_2.getitemstring(lRow, 'momast_pordno')
	spordno = gs_code
else
	setnull(gs_code) 
end if

open(w_pdt_03401)

//if gs_gubun = 'Y' and spordno > '.' then //변경된 사항이 있으면 
//	cb_inq.triggerevent(clicked!)
//	
//	Lfind  = 0
//	Lfind  = dw_2.find("momast_pordno = '"+ spordno +"'", 0, dw_2.rowcount())
//		 
//	if Lfind > 0 then
//		dw_2.SelectRow(Lfind,TRUE)
//		sitnbr  = dw_2.getitemstring(lfind, "momast_itnbr")
//		
//		gs_code = sitnbr //attention 메뉴에서 조회시 필요
//		
//		dw_suju.retrieve(gs_sabu, spordno)
//		dw_rela.retrieve(gs_sabu, spordno)
//		dw_2.scrolltorow(lfind)
//	End if
//End if
//

end event

event p_search::ue_lbuttondown;picturename = 'C:\erpman\image\수정_dn.gif'
end event

event p_search::ue_lbuttonup;picturename = 'C:\erpman\image\수정_up.gif'
end event

type p_ins from w_inherite`p_ins within w_pdt_03400
boolean visible = false
integer x = 2825
end type

type p_exit from w_inherite`p_exit within w_pdt_03400
end type

type p_can from w_inherite`p_can within w_pdt_03400
end type

event p_can::clicked;call super::clicked;rollback;

dw_2.reset()
dw_suju.reset()
dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pdt_03400
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_pdt_03400
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String sstdat, seddat, spdtgu, sgubun, sittyp, sfitcls, stitcls, sitnbr, sempno, &
       snew_sql, sold_sql, swhere_clause

if dw_1.accepttext() = -1 then return

sStdat = trim(dw_1.getitemstring(1, "stdat"))
seddat = trim(dw_1.getitemstring(1, "eddat"))
spdtgu = trim(dw_1.getitemstring(1, "pdtgu"))
sgubun = dw_1.getitemstring(1, "gubun")
sittyp = trim(dw_1.getitemstring(1, "ittyp"))
sfitcls = trim(dw_1.getitemstring(1, "fitcls"))
stitcls = trim(dw_1.getitemstring(1, "titcls"))
sitnbr  = trim(dw_1.getitemstring(1, "fitnbr"))
sempno  = trim(dw_1.getitemstring(1, "empno"))

if sgubun = '1' then 
   IF isnull(sStdat) or sStdat = '' then sStdat = "10000101" 	
   IF isnull(seddat) or seddat = '' then seddat = "99991231"
else
   IF isnull(sStdat) or sStdat = '' then  
		f_message_chk(30,'[지시일자 FROM]')
		dw_1.SetColumn("stdat")
		dw_1.SetFocus()
		RETURN
	END IF
   IF isnull(seddat) or seddat = '' then 
		f_message_chk(30,'[지시일자 TO]')
		dw_1.SetColumn("eddat")
		dw_1.SetFocus()
		RETURN
	END IF
END IF

IF isnull(sfitcls) or sfitcls = '' then 	sfitcls = "." 	
IF isnull(stitcls) or stitcls = '' then 
	stitcls = "zzzzzzz"
ELSE
	stitcls = stitcls + "zzzzzzz"
END IF

IF isnull(sitnbr) or sitnbr = '' then sitnbr = '%'
if isnull(sPdtgu) or spdtgu = '' then spdtgu = '%'
if isnull(sEmpno) or sEmpno = '' then sEmpno = '%'

dw_2.settransobject(sqlca)

dw_suju.reset()

if dw_2.retrieve(gs_sabu, sstdat, seddat, spdtgu, sgubun, sittyp, sfitcls, stitcls, sitnbr, sEmpno) > 0 then
//	cb_mod.enabled = true
	p_mod.enabled = true
	p_mod.picturename = 'C:\erpman\image\저장_up.gif'
Else
	f_message_chk(50,'[대기/승인]')
End if


end event

type p_del from w_inherite`p_del within w_pdt_03400
boolean visible = false
integer x = 2889
end type

type p_mod from w_inherite`p_mod within w_pdt_03400
integer x = 4096
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;Long Lrow, lcount
String sNull

Setnull(sNull)

IF Dw_2.Accepttext() = -1 then return 

if f_msg_update() = -1 then return
sle_msg.text = '자료를 저장중입니다'

lcount = dw_2.rowcount()

For Lrow = 1 to lcount
	 if dw_2.getitemstring(Lrow, "choice") = 'Y' then
		 if isnull(dw_2.getitemstring(Lrow, "momast_cnfdat")) or &
		    Trim(dw_2.getitemstring(Lrow, "momast_cnfdat")) = '' Then
			 dw_2.setitem(Lrow, "momast_cnfdat", f_today())
			 dw_2.setitem(Lrow, "momast_matchk", '2')			 
			 // 수량변경 체크하고 수량이 변경시 관련자료 update 처리
//			 wf_modify_update(Lrow)
		 Else
			 dw_2.setitem(Lrow, "momast_cnfdat", sNull)
			 dw_2.setitem(Lrow, "momast_matchk", '1')
		 End if
 	 End if
Next

//If dw_2.update() = 1 and dw_rela.update() = 1 then
If dw_2.update() = 1 then
	Commit;
	p_inq.triggerevent(clicked!)
Else
	rollback;
	f_rollback()
End if
sle_msg.text = ''


end event

type cb_exit from w_inherite`cb_exit within w_pdt_03400
boolean visible = false
integer x = 2679
integer y = 2804
end type

type cb_mod from w_inherite`cb_mod within w_pdt_03400
boolean visible = false
integer x = 2094
integer y = 2800
integer taborder = 60
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_03400
boolean visible = false
integer x = 311
integer y = 2692
end type

type cb_del from w_inherite`cb_del within w_pdt_03400
boolean visible = false
integer x = 1033
integer y = 2692
end type

type cb_inq from w_inherite`cb_inq within w_pdt_03400
boolean visible = false
integer x = 1723
integer y = 2800
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_03400
boolean visible = false
integer x = 1755
integer y = 2692
end type

type st_1 from w_inherite`st_1 within w_pdt_03400
end type

type cb_can from w_inherite`cb_can within w_pdt_03400
boolean visible = false
integer x = 2336
integer y = 2812
end type

type cb_search from w_inherite`cb_search within w_pdt_03400
boolean visible = false
integer x = 2478
integer y = 2692
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_03400
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_03400
end type

type dw_suju from datawindow within w_pdt_03400
integer x = 50
integer y = 1932
integer width = 4530
integer height = 388
integer taborder = 40
boolean bringtotop = true
string title = "연결수주정보"
string dataobject = "d_pdt_03400_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_pdt_03400
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 37
integer y = 180
integer width = 4576
integer height = 232
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_03400_000"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String scode, sname, sname2
int    ireturn 

scode = this.GetText()

if this.GetColumnName() = 'stdat' then
	if isnull(scode) or scode = '' then return 
	
	if f_datechk(gettext()) = -1 then
		f_message_chk(35,'[작업지시 FROM]') 		
		setitem(1, "stdat", '')
		return 1
	end if
Elseif this.GetColumnName() = 'eddat' then
	if isnull(scode) or scode = '' then return 

	if f_datechk(gettext()) = -1 then
		f_message_chk(35,'[작업지시 TO]')
		setitem(1, "eddat", '')
		return 1
	end if
elseIF this.GetColumnName() = "cvcod" THEN
	ireturn = f_get_name2('V0', 'N', scode, sname, sname2)
	SetItem(1, "cvcod", scode)
	SetItem(1, "cvnas", sname)
   return ireturn 
elseIF this.GetColumnName() = "pordno" THEN
   IF scode = '' or isnull(scode) then return 

	SELECT SABU 
	  INTO :sNAME
	  FROM MOMAST A
	 WHERE A.SABU   = :gs_sabu
		AND A.PORDNO = :scode
		AND A.PORGU  = '20'  ;
		
	IF SQLCA.SQLCODE <> 0 THEN 
		MessageBox('확 인', '합금 작업지시번호를 확인하세요!')
		setitem(1, 'pordno', '')
		Return 1
	END IF
end if

end event

event itemerror;return 1
end event

event rbuttondown;string sittyp
str_itnct lstr_sitnct

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fitcls' then

	sIttyp   = this.GetItemString(1, 'ittyp')
	gs_gubun = this.GetItemString(1, 'pdtgu')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"fitcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	gs_gubun = this.GetItemString(1, 'pdtgu')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'fitnbr' then
	gs_gubun = '1' 
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "fitnbr", gs_code)

elseIF this.GetColumnName() = "cvcod" THEN 
   gs_gubun = '1' 
	OPEN(W_VNDMST_POPUP)

	if gs_code = '' or isnull(gs_code) then return 

	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnas", gs_codename)
elseIF this.getcolumnname() = "pordno"	THEN		
	gs_gubun = '20' 
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "pordno", gs_code)
end if

end event

type cb_1 from commandbutton within w_pdt_03400
boolean visible = false
integer x = 1015
integer y = 2808
integer width = 608
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "수량 조정"
end type

type dw_2 from u_d_popup_sort within w_pdt_03400
event ue_processenter pbm_dwnprocessenter
integer x = 50
integer y = 424
integer width = 4539
integer height = 1432
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_03400_001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;call super::itemerror;RETURN 1
end event

event dw_2::constructor;call super::constructor;if f_change_name('1') = 'Y' then 
	Modify("itemas_ispec_t.text = '" + f_change_name('2') + "'" )
	Modify("itemas_jijil_t.text = '" + f_change_name('3') + "'" )
end if	

end event

event doubleclicked;call super::doubleclicked;//Long Lrow
//String spordno, sItnbr
//
//Lrow = row
//
//if Lrow > 0 then
//	spordno = getitemstring(Lrow, "momast_pordno")	
//	sitnbr  = getitemstring(Lrow, "momast_itnbr")
//	
//	gs_code = sitnbr //attention 메뉴에서 조회시 필요
//	
//	dw_suju.retrieve(gs_sabu, spordno)
//	dw_rela.retrieve(gs_sabu, spordno)
//End if
end event

event itemchanged;call super::itemchanged;long   lrow, lcnt
string spordno
dec{3} dqty, dOld_qty

Lrow = getrow()

spordno = getitemstring(Lrow, "momast_pordno")

if this.getcolumnname() = "choice" then
	dqty = 0

	IF getitemstring(Lrow, "momast_purgc") = 'N' and getitemstring(Lrow, "momast_matchk") = '2' then
		// 진행여부 check
		select sum(roqty) into :dqty
		  from morout
		 where sabu = :gs_sabu And pordno = :spordno;
		 
		if dqty <> 0 then
			f_message_chk(115, '진행중')
			setitem(Lrow, "choice", 'N')
			return 1
		end if
	end if
elseif this.getcolumnname() = "momast_pdqty" then
   dqty = dec(this.gettext())
	dOld_qty = this.getitemdecimal(lrow, 'old_qty')
	
	 // 구매의뢰 상태가 '1','4'인 경우에만 허용	
	 Lcnt = 0
	 Select count(*) into :Lcnt From Estima 
	  where sabu  = :gs_sabu And pordno = :sPordno And blynd IN ('2', '3');
		 
	 if lcnt > 0  then
		 Messagebox("수정여부", "구매검토 또는 발주된 자료는 수량을 수정할 수 없습니다.", stopsign!)
		 this.setitem(lrow, 'momast_pdqty', dold_qty)
		 return 1
	 end if
	 
	 // 할당에 의한 출고내역이 없는 경우에만 가능
	 Lcnt = 0
	 Select count(*) into :Lcnt From Holdstock
	  where sabu = :gs_sabu And pordno = :sPordno  And isqty > 0;
	 if lcnt > 0  then
		 Messagebox("수정여부", "작업지시에 의해 출고된 자료가 있으면 수량을 수정할 수 없습니다.", stopsign!)
		 this.setitem(lrow, 'momast_pdqty', dold_qty)
		 return 1
	 end if	  
	
end if

end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	b_flag = False

	String spordno, sItnbr
	
	spordno = getitemstring(row, "momast_pordno")	
	sitnbr  = getitemstring(row, "momast_itnbr")
	
	gs_code = sitnbr //attention 메뉴에서 조회시 필요
	
	dw_suju.retrieve(gs_sabu, spordno)
   this.setrow(row)
END IF

CALL SUPER ::CLICKED
end event

event itemfocuschanged;call super::itemfocuschanged;//If Row <= 0 then
//	dw_1.SelectRow(0,False)
//	b_flag =True
//ELSE
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//	b_flag = False
//
//	String spordno, sItnbr
//	
//	spordno = getitemstring(row, "momast_pordno")	
//	sitnbr  = getitemstring(row, "momast_itnbr")
//	
//	gs_code = sitnbr //attention 메뉴에서 조회시 필요
//	
//	dw_suju.retrieve(gs_sabu, spordno)
//	dw_rela.retrieve(gs_sabu, spordno)
//   this.setrow(row)
//END IF
//
//
end event

type st_2 from statictext within w_pdt_03400
integer x = 87
integer y = 1884
integer width = 370
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "연결수주정보"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_pdt_03400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 416
integer width = 4562
integer height = 1448
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pdt_03400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 1904
integer width = 4558
integer height = 424
integer cornerheight = 40
integer cornerwidth = 55
end type

