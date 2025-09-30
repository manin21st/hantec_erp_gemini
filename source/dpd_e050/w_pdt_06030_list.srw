$PBExportHeader$w_pdt_06030_list.srw
$PBExportComments$설비 점검 계획 생성 list
forward
global type w_pdt_06030_list from w_inherite
end type
type dw_1 from datawindow within w_pdt_06030_list
end type
type rb_delete from radiobutton within w_pdt_06030_list
end type
type rb_insert from radiobutton within w_pdt_06030_list
end type
type cbx_1 from checkbox within w_pdt_06030_list
end type
type rr_1 from roundrectangle within w_pdt_06030_list
end type
type rr_2 from roundrectangle within w_pdt_06030_list
end type
end forward

global type w_pdt_06030_list from w_inherite
integer width = 5650
integer height = 3316
string title = "정기점검 계획 생성_LIST"
dw_1 dw_1
rb_delete rb_delete
rb_insert rb_insert
cbx_1 cbx_1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_06030_list w_pdt_06030_list

forward prototypes
public function integer wf_required_chk ()
public function integer wf_save_mesplan ()
public function integer wf_lastdate_check (string arg_silgu)
public subroutine wf_initial ()
end prototypes

public function integer wf_required_chk ();long		lrow
string	sdecdate, sdecrslt, simpdate, simpdept, sdeptname

FOR lrow = 1 TO dw_insert.rowcount()
	sdecdate = trim(dw_insert.getitemstring(lrow,'decdate'))
	sdecrslt = dw_insert.getitemstring(lrow,'decrslt')
	if isnull(sdecdate) or sdecdate = '' then
		if isnull(sdecrslt) or sdecrslt = '' then
		else
			messagebox('확인','심사일자를 입력하세요!!!')
			dw_insert.setrow(lrow)
			dw_insert.setcolumn('decdate')
			dw_insert.scrolltorow(lrow)
			dw_insert.setfocus()
			return -1
		end if
	end if
	
	if isnull(sdecrslt) or sdecrslt = '' then
		if isnull(sdecdate) or sdecdate = '' then
		else
			messagebox('확인','판정결과를 입력하세요!!!')
			dw_insert.setrow(lrow)
			dw_insert.setcolumn('decrslt')
			dw_insert.scrolltorow(lrow)
			dw_insert.setfocus()
			return -1
		end if
	end if
	
	simpdept = dw_insert.getitemstring(lrow,'impdept')
	simpdate = trim(dw_insert.getitemstring(lrow,'impdate'))
	if isnull(simpdept) or simpdept = '' then
		if isnull(simpdate) or simpdate = '' then
		else
			messagebox('확인','개선부서를 입력하세요!!!')
			dw_insert.setrow(lrow)
			dw_insert.setcolumn('impdept')
			dw_insert.scrolltorow(lrow)
			dw_insert.setfocus()
			return -1
		end if
	else
		select deptname into :sdeptname from p0_dept
		 where deptcode = :simpdept ;
		if sqlca.sqlcode <> 0 then
			messagebox('확인','등록되지 않은 부서입니다!!!')
			dw_insert.setrow(lrow)
			dw_insert.setcolumn('impdept')
			dw_insert.scrolltorow(lrow)
			dw_insert.setfocus()
			return -1
		end if
	end if
	
	if isnull(simpdate) or simpdate = '' then
		if isnull(simpdept) or simpdept = '' then
		else
			messagebox('확인','개선예정일을 입력하세요!!!')
			dw_insert.setrow(lrow)
			dw_insert.setcolumn('impdate')
			dw_insert.scrolltorow(lrow)
			dw_insert.setfocus()
			return -1
		end if
	end if
NEXT

return 1
end function

public function integer wf_save_mesplan ();long		lcnt, lseq, lmax, lrow, lpoint, i , ls_seq , ls_prqty
string	smchno, syymm, ssilgu, sgikwan
string ls_sabu , ls_edate , ls_gubun , ls_mchno ,  ls_inspday , ls_inspbody , ls_insplist , ls_inspgijun
string ls_itnbr , ls_depot_no , ls_damdang
//syymm = trim(dw_1.getitemstring(1,'yymm'))
dw_insert.Accepttext()

lseq = 0

FOR lrow = 1 TO dw_insert.rowcount()
	if dw_insert.getitemstring(lrow,'chk_flag') = 'N' then continue 
	
	ls_sabu  = trim(dw_insert.getitemstring(lrow,'sabu'))
	ls_edate = trim(dw_insert.getitemstring(lrow,'edate'))
	ls_gubun = trim(dw_insert.getitemstring(lrow,'inspday'))
	ls_mchno= trim(dw_insert.getitemstring(lrow,'mchno'))
	ls_seq = dw_insert.GetItemNumber(lrow,'seq')
	ls_inspday =  trim(dw_insert.getitemstring(lrow,'inspday'))
	ls_inspbody =  trim(dw_insert.getitemstring(lrow,'inspbody'))
 	ls_insplist =  trim(dw_insert.getitemstring(lrow,'insplist') )   
 	ls_inspgijun =  trim(dw_insert.getitemstring(lrow,'inspgijun'))   	
	ls_itnbr =  trim(dw_insert.getitemstring(lrow,'itnbr'))   	
	ls_prqty = dw_insert.GetItemNumber(lrow,'prqty')
 	ls_depot_no =  trim(dw_insert.getitemstring(lrow,'depot_no'))   	
	ls_damdang =  trim(dw_insert.getitemstring(lrow,'damdang'))   	
	
//	select nvl(max(seq),0) into :lmax from meskwa
//	 where sabu = :gs_sabu and mchno = :smchno ;		 
			 
//	If lmax > 0 Then
//		// 해당월 계획이 있으면 skip
//		select count(seq) into :lseq from meskwa
//		 where sabu = :gs_sabu and mchno = :smchno and plnyymm = :syymm ;
//		if lseq > 0 then continue
//	end if
	
	

	
		insert into mchrsl
		  (  sabu,       sidat,   gubun,  mchno,
		       seq, inspbody,  insplist,    iegbn,
			 rsltxt,    rslcod, chkman,	   suamt,
			 sutim,   watim,     jutim,     itnbr,
			 yeqty,      siqty, ins_gub,depot_no,     damdang )
		values
		 (   :ls_sabu,	  :ls_edate, :ls_inspday , :ls_mchno,
		     :ls_seq,  :ls_inspbody , :ls_insplist , '1',
			:ls_inspgijun, 'W' , '' , 0 ,
			0, 0, 0, :ls_itnbr,
			:ls_prqty , :ls_prqty , '1',:ls_depot_no , :ls_damdang ) ;
			
//		insert into mchrsl
//		  (  sabu,       sidat,   gubun,  mchno,
//		       seq, inspbody,  insplist,    iegbn )
//		values
//		 (   :ls_sabu,	  :ls_edate, :ls_inspday , :ls_mchno,
//		     :ls_seq,  :ls_inspbody , :ls_insplist , '1' ) ;
			
			COMMIT;
//		if sqlca.sqlcode <> 0 then
//			rollback ;
//			return -1
//		end if

NEXT

return 1
end function

public function integer wf_lastdate_check (string arg_silgu);string	smchno, slasdat

declare c1 cursor for
	select mchno, lasdat
	  from mesmst
	 where sabu = :gs_code
	   and silgu= :arg_silgu
		and lasdat is not null ;
		
open c1 ;

do while true
	fetch c1 into :smchno, :slasdat ;
	if sqlca.sqlcode <> 0 then exit 
	
	if f_datechk(slasdat) = -1 then
		close c1 ;
		messagebox('확인','최종교정일이 잘못 지정되었습니다.~n~n' +&
						'관리번호 [ '+smchno+' ] , 최종교정일 [ '+slasdat+' ]')
		return -1
	end if
loop

close c1 ;

return 1
end function

public subroutine wf_initial ();dw_1.reset()

dw_insert.setredraw(false)
if smodstatus = '1' then
	dw_insert.dataobject = 'w_pdt_06030_list_2'
else
	dw_insert.dataobject = 'w_pdt_06030_list_3'
end if
dw_insert.settransobject(sqlca)
dw_insert.setredraw(true)

dw_1.insertrow(0)
dw_1.setitem(1,'fryymm',left(f_today(),6))
//dw_1.setitem(1,'toyymm',left(f_today(),6))

dw_1.setfocus()
ib_any_typing = false
end subroutine

on w_pdt_06030_list.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_delete=create rb_delete
this.rb_insert=create rb_insert
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_delete
this.Control[iCurrent+3]=this.rb_insert
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_pdt_06030_list.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_delete)
destroy(this.rb_insert)
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;rb_insert.checked = true
rb_insert.triggerevent(clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_pdt_06030_list
integer x = 37
integer y = 216
integer width = 4562
integer height = 1932
integer taborder = 20
string dataobject = "w_pdt_06030_list_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06030_list
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06030_list
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_06030_list
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdt_06030_list
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_06030_list
integer x = 4425
end type

type p_can from w_inherite`p_can within w_pdt_06030_list
integer x = 4251
end type

event p_can::clicked;rb_insert.checked = true
rb_insert.triggerevent(clicked!)
end event

type p_print from w_inherite`p_print within w_pdt_06030_list
boolean visible = false
integer x = 4713
integer y = 340
end type

event p_print::clicked;call super::clicked;if dw_1.accepttext() = -1 then return

gs_code  	 = dw_1.getitemstring(1, "sdate")
gs_codename  = dw_1.getitemstring(1, "edate")

if isnull(gs_code) or trim(gs_code) = '' then
	gs_code = '10000101'
end if

if isnull(gs_codename) or trim(gs_codename) = '' then
	gs_codename = '99991231'
end if

open(w_qct_01075_1)

Setnull(gs_code)
Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_pdt_06030_list
integer x = 3730
integer y = 20
end type

event p_inq::clicked;string	sfryymm, stoyymm, sgubun, silgu

if dw_1.accepttext() = -1 then return

sfryymm = trim(dw_1.getitemstring(1,'fryymm'))
if isnull(sfryymm) or sfryymm = "" then
	f_message_chk(30, '[기준 년월]')
	dw_1.setcolumn('fryymm')
	dw_1.setfocus()
	return
end if

//stoyymm = trim(dw_1.getitemstring(1,'toyymm'))
//if isnull(stoyymm) or stoyymm = "" then
//	f_message_chk(30, '[기준 년월]')
//	dw_1.setcolumn('toyymm')
//	dw_1.setfocus()
//	return
//end if

//silgu = dw_1.getitemstring(1,'silgu')

//if wf_lastdate_check(silgu) = -1 then return
	
setpointer(hourglass!)
dw_insert.setredraw(false)

//dw_insert.setfilter("")
//dw_insert.filter()
//
//sgubun = dw_1.getitemstring(1,'status')
//if sgubun = '1' then
//	dw_insert.setfilter("chagi = '"+syymm+"'")
//else
//	dw_insert.setfilter("chagi <= '"+syymm+"'")
//end if
//dw_insert.filter()
//
if smodstatus = '1' then
	if dw_insert.retrieve(sfryymm,'2') < 1 then
		dw_insert.setredraw(true)
		//f_message_chk(50, '[검교정 대상 선정]')
		messagebox("확인","조회 결과가 없습니다.")
		dw_1.setfocus()
		return
	end if
else
	if dw_insert.retrieve(sfryymm+'%','2') < 1 then
		dw_insert.setredraw(true)
		//f_message_chk(50, '[검교정 대상 선정]')
		messagebox("확인","조회 결과가 없습니다.")
		dw_1.setfocus()
		return
	end if
end if


//if dw_insert.retrieve(sfryymm,'2') < 1 then
//	dw_insert.setredraw(true)
//	//f_message_chk(50, '[검교정 대상 선정]')
//	messagebox("확인","조회 결과가 없습니다.")
//	dw_1.setfocus()
//	return
//end if

dw_insert.setredraw(true)
ib_any_typing = false
end event

type p_del from w_inherite`p_del within w_pdt_06030_list
integer x = 4078
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long		lrow

if smodstatus = '1' then return
if dw_insert.rowcount() < 1 then return

if messagebox('확인','선택된 자료에 대한 계획을 삭제합니다',question!,yesno!,1) = 2 then return

FOR lrow = dw_insert.rowcount() TO 1 STEP -1
	if dw_insert.getitemstring(lrow,'chk_flag') = 'N' then continue
	
	dw_insert.deleterow(lrow)
NEXT

setpointer(hourglass!)
if dw_insert.update() <> 1 then
	rollback ;
	w_mdi_frame.sle_msg.text = "삭제실패!!"
	messagebox("삭제실패", "정기점검 계획 삭제 실패!!!")
	return
end if

commit ;

ib_any_typing = false

w_mdi_frame.sle_msg.text = "삭제완료!!"

//p_can.triggerevent(clicked!)
end event

type p_mod from w_inherite`p_mod within w_pdt_06030_list
integer x = 3904
end type

event p_mod::clicked;if smodstatus = '2' then return
if dw_insert.rowcount() < 1 then return
if dw_insert.accepttext() = -1 then return
//if wf_required_chk() = -1 then return

//if messagebox('확인','선택된 자료에 대한 검교정 계획을 생성합니다',question!,yesno!,1) = 2 then return
//if f_msg_update() = -1 then return

setpointer(hourglass!)
if wf_save_mesplan() = -1 then
	rollback ;
	w_mdi_frame.sle_msg.text = "저장실패!!"
	messagebox("저장실패", "검교정 계획 생성 실패!!!")
	return
end if
commit ;

ib_any_typing = false

w_mdi_frame.sle_msg.text = "저장완료!!"
p_can.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06030_list
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06030_list
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06030_list
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_pdt_06030_list
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06030_list
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_pdt_06030_list
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_pdt_06030_list
end type

type cb_can from w_inherite`cb_can within w_pdt_06030_list
end type

type cb_search from w_inherite`cb_search within w_pdt_06030_list
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_06030_list
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06030_list
end type

type dw_1 from datawindow within w_pdt_06030_list
integer x = 18
integer y = 16
integer width = 768
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "w_pdt_06030_list_1"
boolean border = false
end type

event itemerror;return 1
end event

type rb_delete from radiobutton within w_pdt_06030_list
integer x = 3049
integer y = 76
integer width = 242
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
string text = "수정"
end type

event clicked;sModStatus = '2'
p_mod.Enabled = FALSE
p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
p_del.Enabled = TRUE
p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
wf_Initial()


end event

type rb_insert from radiobutton within w_pdt_06030_list
integer x = 2743
integer y = 76
integer width = 242
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
string text = "등록"
boolean checked = true
end type

event clicked;sModStatus = '1'	// 등록
p_del.Enabled = FALSE
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
p_mod.Enabled = true
p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
wf_Initial()
end event

type cbx_1 from checkbox within w_pdt_06030_list
integer x = 69
integer y = 252
integer width = 78
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 28144969
end type

event clicked;long	lrow

dw_insert.setredraw(false)
if this.checked then
	FOR lrow = 1 TO dw_insert.rowcount()
		dw_insert.setitem(lrow,'chk_flag','Y')
	NEXT
else
	FOR lrow = 1 TO dw_insert.rowcount()
		dw_insert.setitem(lrow,'chk_flag','N')
	NEXT
end if
dw_insert.setredraw(true)
end event

type rr_1 from roundrectangle within w_pdt_06030_list
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 4585
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_06030_list
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2656
integer y = 20
integer width = 686
integer height = 160
integer cornerheight = 40
integer cornerwidth = 46
end type

