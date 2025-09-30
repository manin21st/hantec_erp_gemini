$PBExportHeader$w_qa02_00060.srw
$PBExportComments$** 매입 클레임 처리
forward
global type w_qa02_00060 from w_inherite
end type
type dw_1 from datawindow within w_qa02_00060
end type
type dw_2 from datawindow within w_qa02_00060
end type
type dw_qa_clhist from datawindow within w_qa02_00060
end type
type dw_shpact_qa from datawindow within w_qa02_00060
end type
type dw_list from datawindow within w_qa02_00060
end type
type st_2 from statictext within w_qa02_00060
end type
type st_3 from statictext within w_qa02_00060
end type
type rb_1 from radiobutton within w_qa02_00060
end type
type rb_2 from radiobutton within w_qa02_00060
end type
type st_4 from statictext within w_qa02_00060
end type
type rr_1 from roundrectangle within w_qa02_00060
end type
type rr_2 from roundrectangle within w_qa02_00060
end type
type rr_5 from roundrectangle within w_qa02_00060
end type
end forward

global type w_qa02_00060 from w_inherite
integer width = 5152
integer height = 2440
string title = "매입 클레임 처리"
dw_1 dw_1
dw_2 dw_2
dw_qa_clhist dw_qa_clhist
dw_shpact_qa dw_shpact_qa
dw_list dw_list
st_2 st_2
st_3 st_3
rb_1 rb_1
rb_2 rb_2
st_4 st_4
rr_1 rr_1
rr_2 rr_2
rr_5 rr_5
end type
global w_qa02_00060 w_qa02_00060

type variables
string	ic_status
end variables

forward prototypes
public function integer wf_sojae_tuipqty ()
public subroutine wf_initial ()
public function integer wf_required_chk ()
public function integer wf_create_qa_clhist ()
end prototypes

public function integer wf_sojae_tuipqty ();long		lrow
string	syymm, sitnbr, scvcod
decimal	dsumqty, dsumqty2

syymm = trim(dw_1.getitemstring(1,'yymm'))

setpointer(hourglass!)

FOR lrow = 1 TO dw_insert.rowcount()
	sitnbr = dw_insert.getitemstring(lrow,'itnbr')
	scvcod = dw_insert.getitemstring(lrow,'cvcod')
	
	/* 생산자동출고 */
	select nvl(sum(ioqty),0) into :dsumqty from imhist
	 where sabu = '1' and io_date like :syymm||'%'
	   and pdtgu in ( select rfgub from reffpf where rfcod = '03' and rfna2 = :gs_saupj )
	   and iogbn = 'O01' and itnbr = :sitnbr ;
		
	/* 기처리투입량 */
	select nvl(sum(roqty),0) into :dsumqty2 from qa_clhist
	 where sabu = :gs_saupj and yyyymm like :syymm
	   and itnbr = :sitnbr and cvcod = :scvcod ;
		

	dw_insert.setitem(lrow,'roqty',dsumqty - dsumqty2)
	
	
	// 임시변동 삭제해야함 소재투입량 계산없음 
//	If dsumqty <= 0 Then
//		dw_insert.Object.roqty[lrow] = 100
//   End If
	
	//=====================================
NEXT

return 1
end function

public subroutine wf_initial ();dw_1.reset()
dw_list.reset()
dw_qa_clhist.reset()
dw_shpact_qa.reset()

if ic_status = '1' then
	dw_insert.dataobject = 'd_qa02_00060_a'
	dw_1.insertrow(0)
	dw_1.modify("t_up.visible=0")
	dw_1.modify("t_dn.visible=0")
else
	dw_insert.dataobject = 'd_qa02_00060_b'
	dw_1.insertrow(0)
	dw_1.modify("t_up.visible=1")
	dw_1.modify("t_dn.visible=1")
end if

integer	nchasu
string	syymm

syymm = left(f_today(),6)

select max(chasu) into :nchasu from qa_clhist
 where sabu = :gs_saupj and yyyymm = :syymm ;

dw_1.setitem(1,'yymm',syymm)
dw_1.setitem(1,'chasu',nchasu)

dw_insert.settransobject(sqlca)	

dw_1.setfocus()

ib_any_typing = false
end subroutine

public function integer wf_required_chk ();long		lrow, nchasu, nmax
string	syymm
decimal	dprc

syymm = trim(dw_1.getitemstring(1,'yymm'))
nchasu= dw_1.getitemnumber(1,'chasu')

if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[처리년월]')
	dw_1.setfocus()
	return -1
end if

if ic_status = '1' then
	select max(chasu) into :nmax from qa_clhist
	 where sabu = :gs_saupj and yyyymm = :syymm ;
	if isnull(nmax) then
		dw_1.setitem(1,'chasu',1)
	else
		dw_1.setitem(1,'chasu',nmax+1)
	end if
else
	FOR lrow = 1 TO dw_insert.rowcount()
		dprc = dw_insert.getitemnumber(lrow,'workprc')
		if isnull(dprc) or dprc <= 0 then
			messagebox('확인','가공비를 지정하세요')
			dw_insert.setrow(lrow)
			dw_insert.setcolumn('workprc')
			dw_insert.scrolltorow(lrow)
			dw_insert.setfocus()
			return -1
		end if
		dw_insert.setitem(lrow,'workamt',dw_insert.getitemnumber(lrow,'calcamt'))
		dw_insert.setitem(lrow,'totamt',dw_insert.getitemnumber(lrow,'calcamt2'))
		dw_insert.setitem(lrow,'cnfamt',dw_insert.getitemnumber(lrow,'calcamt2'))
	NEXT
end if

string	scvcod, sitnbr, sclmdesc, sname
decimal	dgita

FOR lrow = 1 TO dw_list.rowcount()
	scvcod = dw_list.getitemstring(lrow,'cvcod')
	select cvnas into :sname from vndmst
	 where cvcod = :scvcod and cvgu in ('1','2') ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','업체를 지정하세요')
		dw_list.setrow(lrow)
		dw_list.setcolumn('cvnas')
		dw_list.scrolltorow(lrow)
		dw_list.setfocus()
		return -1
	end if
	
	sitnbr = dw_list.getitemstring(lrow,'itnbr')
	select itdsc into :sname from itemas
	 where itnbr = :sitnbr ;
	if sqlca.sqlcode <> 0 then
		messagebox('확인','품번을 지정하세요')
		dw_list.setrow(lrow)
		dw_list.setcolumn('itnbr')
		dw_list.scrolltorow(lrow)
		dw_list.setfocus()
		return -1
	end if
	
	sclmdesc = dw_list.getitemstring(lrow,'clmdesc')
	if isnull(sclmdesc) or trim(sclmdesc) = '' then
		messagebox('확인','사유를 지정하세요')
		dw_list.setrow(lrow)
		dw_list.setcolumn('clmdesc')
		dw_list.scrolltorow(lrow)
		dw_list.setfocus()
		return -1
	end if
	
	dgita = dw_list.getitemnumber(lrow,'gitaamt')
	if isnull(dgita) or dgita <= 0 then
		messagebox('확인','기타비용을 지정하세요')
		dw_list.setrow(lrow)
		dw_list.setcolumn('gitaamt')
		dw_list.scrolltorow(lrow)
		dw_list.setfocus()
		return -1
	end if
	dw_list.setitem(lrow,'totamt',dw_list.getitemnumber(lrow,'gitaamt'))
	dw_list.setitem(lrow,'cnfamt',dw_list.getitemnumber(lrow,'gitaamt'))
NEXT	

return 1
end function

public function integer wf_create_qa_clhist ();long		lseq, lrow1, lrow2, lins, lfrow, nchasu
string	sjpno, syymm, sitnbr, scvcod

dw_qa_clhist.reset()
syymm = trim(dw_1.getitemstring(1,'yymm'))
nchasu= dw_1.getitemnumber(1,'chasu')

//select max(chasu) into :nchasu from qa_clhist
// where sabu = :gs_saupj and yyyymm = :syymm ;


lseq = sqlca.fun_junpyo(gs_sabu,syymm,'Q1')
if lseq = -1 then 
	rollback;
	f_message_chk(51, '')
	return -1
end if
commit;
sjpno = syymm + string(lseq,'0000')


/* 불량 클레임 */
FOR lrow1 = 1 TO dw_insert.rowcount()
	if dw_insert.getitemnumber(lrow1,'calcamt2') > 0 then
		sitnbr = dw_insert.getitemstring(lrow1,'itnbr')
		scvcod = dw_insert.getitemstring(lrow1,'cvcod')
		
		lins = dw_qa_clhist.insertrow(0)
		dw_qa_clhist.setitem(lins,'sabu',gs_saupj)
		dw_qa_clhist.setitem(lins,'qajpno',sjpno+string(lins,'000'))
		dw_qa_clhist.setitem(lins,'itnbr',sitnbr)
		dw_qa_clhist.setitem(lins,'cvcod',scvcod)
		dw_qa_clhist.setitem(lins,'roqty',dw_insert.getitemnumber(lrow1,'roqty'))
		dw_qa_clhist.setitem(lins,'qasqty',dw_insert.getitemnumber(lrow1,'qasqty'))
		dw_qa_clhist.setitem(lins,'shrat',dw_insert.getitemnumber(lrow1,'shrat'))
		dw_qa_clhist.setitem(lins,'clqty',dw_insert.getitemnumber(lrow1,'clqty'))
		dw_qa_clhist.setitem(lins,'perqty',dw_insert.getitemnumber(lrow1,'perqty'))
		dw_qa_clhist.setitem(lins,'workprc',dw_insert.getitemnumber(lrow1,'workprc'))
		dw_qa_clhist.setitem(lins,'workamt',dw_insert.getitemnumber(lrow1,'calcamt'))
		dw_qa_clhist.setitem(lins,'gitaamt',dw_insert.getitemnumber(lrow1,'gitaamt'))
		dw_qa_clhist.setitem(lins,'totamt',dw_insert.getitemnumber(lrow1,'calcamt2'))
		dw_qa_clhist.setitem(lins,'clmgbn','1')
		dw_qa_clhist.setitem(lins,'yyyymm',syymm)
		dw_qa_clhist.setitem(lins,'chasu',nchasu)
//		dw_qa_clhist.setitem(lins,'wempno',gs_empno)
		dw_qa_clhist.setitem(lins,'okyn','0')  // 미승인
		
		FOR lrow2 = 1 TO dw_shpact_qa.rowcount()
			lrow2 = dw_shpact_qa.find("itnbr='"+sitnbr+"' and cvcod='"+scvcod+"'",lrow2,dw_shpact_qa.rowcount())
			if lrow2 > 0 then
				dw_shpact_qa.setitem(lrow2,'qajpno',sjpno+string(lins,'000'))
			else
				exit
			end if
		NEXT
	end if
NEXT

if dw_qa_clhist.update() <> 1 then
	rollback ;
	messagebox("저장실패", "클레임 자료 생성 실패!!!")
	return  -1
end if

if dw_shpact_qa.update() <> 1 then
	rollback ;
	messagebox("저장실패", "이상 발생 자료 갱신 실패!!!")
	return  -1
end if

return 1
end function

on w_qa02_00060.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_qa_clhist=create dw_qa_clhist
this.dw_shpact_qa=create dw_shpact_qa
this.dw_list=create dw_list
this.st_2=create st_2
this.st_3=create st_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_4=create st_4
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_5=create rr_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_qa_clhist
this.Control[iCurrent+4]=this.dw_shpact_qa
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
this.Control[iCurrent+13]=this.rr_5
end on

on w_qa02_00060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_qa_clhist)
destroy(this.dw_shpact_qa)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_4)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_5)
end on

event open;call super::open;dw_list.settransobject(SQLCA)
dw_shpact_qa.settransobject(SQLCA)
dw_qa_clhist.settransobject(SQLCA)

rb_1.checked = true
rb_1.triggerevent(clicked!)

dw_1.triggerevent(itemchanged!)
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00060
integer x = 32
integer y = 216
integer width = 4558
integer height = 1204
integer taborder = 20
string dataobject = "d_qa02_00060_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::doubleclicked;if row > 0 then
	if ic_status = '1' then
		gs_gubun = dw_1.getitemstring(1,"yymm")
	else
		gs_gubun = this.getitemstring(1,"qajpno")
	end if
	gs_code  = this.getitemstring(row,"itnbr")
	gs_codename = this.getitemstring(row,"cvcod")
	gs_codename2= ic_status
	
	open(w_qa02_00060_popup)
	if isnumber(gs_code) then
		this.setitem(row,'workprc',dec(gs_code))
	end if 
end if

end event

event dw_insert::buttonclicked;call super::buttonclicked;if row > 0 then	
	gs_code = this.getitemstring(row,"qajpno")
	gs_codename = string(this.getitemnumber(row,"cnfamt"))
	
	open(w_qa02_00060_popup2)
	if gs_code = 'OK' and isnumber(gs_codename) then	this.setitem(row,'cnfamt',dec(gs_codename))
end if
end event

event dw_insert::clicked;call super::clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00060
integer x = 4379
integer y = 1436
end type

event p_delrow::clicked;call super::clicked;long	lrow

lrow = dw_list.getrow()
if lrow < 1 then return

if f_msg_delete() = -1 then return

dw_list.deleterow(lrow)
if dw_list.update() <> 1 then
	rollback ;
	messagebox("삭제실패", "불량외 클레임 자료 삭제 실패!!!")
	return
end if
commit ;
end event

type p_addrow from w_inherite`p_addrow within w_qa02_00060
integer x = 4206
integer y = 1436
end type

event p_addrow::clicked;call super::clicked;long	lrow

lrow = dw_list.insertrow(0)

dw_list.setrow(Lrow)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("cvnas")
dw_list.SetFocus()
end event

type p_search from w_inherite`p_search within w_qa02_00060
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa02_00060
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa02_00060
integer x = 4370
end type

type p_can from w_inherite`p_can within w_qa02_00060
integer x = 4197
end type

event p_can::clicked;call super::clicked;dw_list.reset()
dw_insert.reset()
dw_qa_clhist.reset()
dw_shpact_qa.reset()

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_qa02_00060
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

type p_inq from w_inherite`p_inq within w_qa02_00060
integer x = 3675
end type

event p_inq::clicked;long		lcnt1, lcnt2, nchasu
string	syymm, sjpno, spdtgu

if dw_1.accepttext() = -1 then return

syymm = trim(dw_1.getitemstring(1,'yymm'))
if isnull(syymm) or syymm = "" then
	f_message_chk(30,'[처리년월]')
	dw_1.setfocus()
	return
end if

spdtgu = dw_1.getitemstring(1,'pdtgu')

if ic_status = '1' then

	setpointer(hourglass!)
	if dw_insert.retrieve(gs_saupj,syymm,spdtgu) < 1 then
		f_message_chk(50, '[매입 클레임 처리]')
		dw_1.setfocus()
		return
	end if
	
	dw_shpact_qa.retrieve(gs_saupj,syymm)
	dw_list.reset()
	wf_sojae_tuipqty()

else
	nchasu= dw_1.getitemnumber(1,'chasu')
	
	setpointer(hourglass!)
	lcnt1 = dw_insert.retrieve(gs_saupj,syymm,nchasu,spdtgu)
	lcnt2 = dw_list.retrieve(gs_saupj,syymm,nchasu,spdtgu)
	
	if lcnt1 + lcnt2 < 1 then
		f_message_chk(50, '[매입 클레임 처리]')
		dw_1.setfocus()
		return
	end if
	
end if
end event

type p_del from w_inherite`p_del within w_qa02_00060
integer x = 4023
end type

event p_del::clicked;call super::clicked;long		lrow
string	sgubun, sqajpno, sacjpno

if dw_2.accepttext() = -1 then return
if dw_insert.rowcount() < 1 then return

if ic_status = '1' then
	messagebox("확인", "수정 상태에서만 삭제 가능합니다!!!")
	return
end if

lrow = dw_insert.getrow()
if lrow < 1 then return

if f_msg_delete() = -1 then return

sqajpno = trim(dw_insert.getitemstring(lrow,'qajpno'))

dw_insert.deleterow(lrow)

setpointer(hourglass!)
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("삭제실패", "매입 클레임 자료 삭제 실패!!!")
	return
end if

update shpfat_qa
	set qajpno = null
 where sabu = :gs_saupj
	and qajpno = :sqajpno ;

if sqlca.sqlcode < 0 then
	rollback ;
	messagebox("삭제실패", "매입 클레임 자료 삭제 실패 [이상 발생 자료 갱신 실패]!!!")
	return
end if

commit ;

//if dw_insert.rowcount() < 1 then p_can.triggerevent(clicked!)
end event

type p_mod from w_inherite`p_mod within w_qa02_00060
integer x = 3849
end type

event p_mod::clicked;double	dno
string	syymm
integer	nchasu

if dw_1.accepttext() = -1 then return
if dw_2.accepttext() = -1 then return
if dw_list.accepttext() = -1 then return
if dw_insert.accepttext() = -1 then return

if dw_list.rowcount() < 1 and dw_insert.rowcount() < 1 then return
if wf_required_chk() = -1 then return
if f_msg_update() = -1 then return

syymm = trim(dw_1.getitemstring(1,'yymm'))
nchasu= dw_1.getitemnumber(1,'chasu')

setpointer(hourglass!)

if ic_status = '1' then
	if wf_create_qa_clhist() = -1 then return
else
	if dw_insert.update() <> 1 then
		rollback ;
		messagebox("저장실패", "매입 클레임(불량) 저장 실패!!!")
		return
	end if
end if

///////////////////////////////////////////////////////////////////////////////////////
/* 불량외 클레임 */
long		lseq, lrow
string	smaxjpno

select max(qajpno) into :smaxjpno from qa_clhist
 where sabu = :gs_saupj and yyyymm = :syymm and chasu = :nchasu ;

if isnull(smaxjpno) or trim(smaxjpno) = '' then
	lseq = sqlca.fun_junpyo(gs_sabu,syymm,'Q1')
	if lseq = -1 then 
		rollback;
		f_message_chk(51, '')
		return -1
	end if
	dno = double(syymm+string(lseq,'0000')+'000')
else
	dno = double(smaxjpno)
end if

FOR lrow = 1 TO dw_list.rowcount()
	if isnull(dw_list.getitemstring(lrow,'qajpno')) or &
		trim(dw_list.getitemstring(lrow,'qajpno')) = '' then
	
		dno++
		dw_list.setitem(lrow,'sabu',gs_saupj)
		dw_list.setitem(lrow,'qajpno',string(dno))
		dw_list.setitem(lrow,'yyyymm',syymm)
		dw_list.setitem(lrow,'chasu',nchasu)
	end if
NEXT

if dw_list.update() <> 1 then
	rollback ;
	messagebox("저장실패", "매입 클레임(불량외) 저장 실패!!!")
	return
end if
	
commit ;

p_inq.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qa02_00060
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00060
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa02_00060
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa02_00060
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa02_00060
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa02_00060
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa02_00060
end type

type cb_can from w_inherite`cb_can within w_qa02_00060
end type

type cb_search from w_inherite`cb_search within w_qa02_00060
end type







type gb_button1 from w_inherite`gb_button1 within w_qa02_00060
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00060
end type

type dw_1 from datawindow within w_qa02_00060
event ue_pressenter pbm_dwnprocessenter
integer x = 14
integer y = 24
integer width = 1929
integer height = 172
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa02_00060_0"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string 	snull, sjpno, syymm
Long	 	Lrow, nchasu

Setnull(snull)

Lrow = this.getrow()

if this.getcolumnname() = 'yymm' then
	syymm = trim(this.gettext())
	if isnull(syymm) or syymm = '' then 
		this.setitem(lrow,'chasu',1)
		return
	end if
	
	select max(chasu) into :nchasu from qa_clhist
	 where sabu = :gs_saupj and yyyymm = :syymm ;
	if isnull(nchasu) then
		this.setitem(lrow,'chasu',1)
	else
		this.setitem(lrow,'chasu',nchasu)
	end if
end if

if this.getcolumnname() = 'jpno' then
	sjpno = trim(this.gettext())
	if isnull(sjpno) or sjpno = '' then return
	
	p_inq.triggerevent(clicked!)
end if
end event

event itemerror;return 1
end event

event rbuttondown;string	snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'jpno' THEN
	open(w_qa02_00060_popup3)
	IF isnull(gs_Code)  or  gs_Code = '' then return

	this.setitem(1,'jpno',gs_code)
	this.triggerevent(itemchanged!)
END IF
end event

event clicked;string	syymm
integer	nmax, nchasu

if dwo.name = 't_up' then
	syymm = trim(this.getitemstring(row,'yymm'))
	nchasu= this.getitemnumber(row,'chasu')
	
	select max(chasu) into :nmax from qa_clhist
	 where sabu = :gs_saupj and yyyymm = :syymm ;
	if isnull(nmax) then
		this.setitem(row,'chasu',1)
	elseif nchasu + 1 <= nmax then
		this.setitem(row,'chasu',nchasu + 1)
	end if
end if

if dwo.name = 't_dn' then
	nchasu= this.getitemnumber(row,'chasu')
	if nchasu > 1 then
		this.setitem(row,'chasu',nchasu - 1)
	end if
end if
end event

type dw_2 from datawindow within w_qa02_00060
boolean visible = false
integer x = 4663
integer y = 28
integer width = 279
integer height = 172
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00060_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;dw_insert.reset()
end event

type dw_qa_clhist from datawindow within w_qa02_00060
boolean visible = false
integer x = 4722
integer y = 952
integer width = 571
integer height = 600
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00060_c"
boolean border = false
boolean livescroll = true
end type

type dw_shpact_qa from datawindow within w_qa02_00060
boolean visible = false
integer x = 4731
integer y = 1644
integer width = 571
integer height = 600
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00060_d"
boolean border = false
boolean livescroll = true
end type

type dw_list from datawindow within w_qa02_00060
integer x = 32
integer y = 1596
integer width = 4558
integer height = 668
integer taborder = 130
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00060_e"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rbuttondown;long	lrow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

lrow = this.getrow()
if lrow < 1 then return

if this.getcolumnname() = 'itnbr' then
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(lrow,'itnbr',gs_code)
	this.triggerevent(itemchanged!)

elseif this.getcolumnname() = 'cvnas' then
	gs_gubun = '1'
	open(w_vndmst_popup)
	if isnull(gs_code) or gs_code = '' then return
	
	this.setitem(lrow,'cvcod',gs_code)
	this.triggerevent(itemchanged!)
	
end if
end event

event itemchanged;long		lrow
string	sitnbr, sitdsc, scvcod, scvnas, snull
decimal	dgita

lrow = this.getrow()
if lrow < 1 then return

setnull(snull)
if this.getcolumnname() = 'itnbr' then
	sitnbr = this.gettext()
	
	if isnull(sitnbr) or sitnbr = '' then 
		this.setitem(lrow,'itdsc',snull)
		return
	end if
	
	select itdsc into :sitdsc from itemas
	 where itnbr = :sitnbr ;
	if sqlca.sqlcode = 0 then
		this.setitem(lrow,'itdsc',sitdsc)
	else
		this.setitem(lrow,'itnbr',snull)
		this.setitem(lrow,'itdsc',snull)
		return 1
	end if

elseif this.getcolumnname() = 'cvnas' then
	scvcod = this.getitemstring(lrow,'cvcod')
	
	if isnull(scvcod) or scvcod = '' then 
		this.setitem(lrow,'cvnas',snull)
		return
	end if
	
	select cvnas into :scvnas from vndmst
	 where cvcod = :scvcod and cvgu in ('1','2') ;
	if sqlca.sqlcode = 0 then
		this.setitem(lrow,'cvnas',scvnas)
	else
		this.setitem(lrow,'cvcod',snull)
		this.setitem(lrow,'cvnas',snull)
		return 1
	end if

elseif this.getcolumnname() = 'gitaamt' then
	dgita = dec(this.gettext())
	this.setitem(lrow,'totamt',dgita)

end if
end event

event itemerror;return 1
end event

event buttonclicked;if row > 0 then	
	gs_code = this.getitemstring(row,"qajpno")
	gs_codename = string(this.getitemnumber(row,"cnfamt"))
	
	open(w_qa02_00060_popup2)
	if gs_code = 'OK' and isnumber(gs_codename) then	this.setitem(row,'cnfamt',dec(gs_codename))
end if
end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF
end event

type st_2 from statictext within w_qa02_00060
integer x = 37
integer y = 1492
integer width = 603
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 28144969
long backcolor = 32106727
string text = "기타 클레임"
boolean focusrectangle = false
end type

type st_3 from statictext within w_qa02_00060
integer x = 2734
integer y = 72
integer width = 914
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "※ 더블 클릭시 작업품번의 공정별"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_qa02_00060
integer x = 2030
integer y = 80
integer width = 293
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "등 록"
boolean checked = true
end type

event clicked;ic_status = '1'
wf_initial()
end event

type rb_2 from radiobutton within w_qa02_00060
integer x = 2359
integer y = 80
integer width = 293
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "수 정"
end type

event clicked;ic_status = '2'
wf_initial()
end event

type st_4 from statictext within w_qa02_00060
integer x = 2734
integer y = 136
integer width = 914
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "   가공비 계산 창이 나타납니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_qa02_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 208
integer width = 4585
integer height = 1220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qa02_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 1584
integer width = 4585
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_qa02_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1975
integer y = 28
integer width = 704
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

