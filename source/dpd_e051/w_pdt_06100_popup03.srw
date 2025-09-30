$PBExportHeader$w_pdt_06100_popup03.srw
$PBExportComments$설비점검 소요자재 등록
forward
global type w_pdt_06100_popup03 from window
end type
type p_inq from picture within w_pdt_06100_popup03
end type
type p_close from picture within w_pdt_06100_popup03
end type
type p_save from picture within w_pdt_06100_popup03
end type
type p_del from picture within w_pdt_06100_popup03
end type
type p_add from picture within w_pdt_06100_popup03
end type
type dw_2 from datawindow within w_pdt_06100_popup03
end type
type dw_1 from datawindow within w_pdt_06100_popup03
end type
type rr_1 from roundrectangle within w_pdt_06100_popup03
end type
end forward

global type w_pdt_06100_popup03 from window
integer width = 2350
integer height = 1720
boolean titlebar = true
string title = "사용자재등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_inq p_inq
p_close p_close
p_save p_save
p_del p_del
p_add p_add
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_06100_popup03 w_pdt_06100_popup03

type variables
String is_code ,is_codename

end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_mchrsl_update ()
public function integer wf_imhist_create ()
end prototypes

public function integer wf_required_chk ();Long 		i,	ll_qty
String 	sdate, smchno, ls_itnbr

sdate = trim(dw_1.getitemstring(1,'date'))
if f_datechk(sdate) = -1 then
	messagebox('확인','사용일자를 확인하세요')
	return -1
end if	

smchno = trim(dw_1.getitemstring(1,'mchno'))
if isnull(smchno) or smchno = '' then
	messagebox('확인','설비코드를 확인하세요')
	return -1
end if

For i = 1 To dw_2.RowCount()	
	ls_itnbr = Trim(dw_2.Object.imhist_itnbr[i])
	ll_qty   = dw_2.Object.imhist_ioqty[i]
	
	If ls_itnbr = '' Or isNull(ls_itnbr)  Then
		f_message_chk(1400,"[품번]")
		dw_2.ScrollToRow(i)
		dw_2.SetColumn("imhist_itnbr")
		dw_2.SetFocus()
		Return -1
	End If
	If ll_qty <= 0 Then
		f_message_chk(1400,"[수량]")
		dw_2.ScrollToRow(i)
		dw_2.SetColumn("imhist_ioqty")
		dw_2.SetFocus()
		Return -1
	End If
Next

return 1
end function

public function integer wf_mchrsl_update ();//////////////////////////////////////////////////////////////////////////////////////////////
// 정기점검 OR 수리의뢰 자료 갱신 - 2004.03.02
string	sidat, sgubun, smchno, sjpno
integer	seq

sidat = trim(dw_1.getitemstring(1,'sidat'))
sgubun= dw_1.getitemstring(1,'gubun')
smchno= dw_1.getitemstring(1,'mchno')
seq 	= dw_1.getitemnumber(1,'seq')

if dw_2.rowcount() < 1 then
	setnull(sjpno)
else
	sjpno = left(dw_2.getitemstring(1,'imhist_iojpno'),12)
end if

if sgubun = '2' then
	update mchrsl
		set iojpno = :sjpno
	 where sabu = :gs_sabu
		and sidat = :sidat
		and gubun = '2'
		and mchno = :smchno ;
else		
	update mchrsl
		set iojpno = :sjpno
	 where sabu = :gs_sabu
		and sidat = :sidat
		and gubun = :sgubun
		and mchno = :smchno
		and seq	 = :seq ;
end if 

if sqlca.sqlcode <> 0 then
	rollback ;
	messagebox('확인','MRO 불출자료 생성실패!!!')
	return -1
end if
	
RETURN 1
end function

public function integer wf_imhist_create ();string	sJpno, 		&
			sEmpno,		&
			sDate, 		&
			sVendor,		&
			sNull, sIogbn, smchno, sdeptcode, sdepot, siojpno
long		lRow, lRowOut, lins, lfrow
long 		dSeq
decimal	dqty

lfrow = dw_2.find("crt_flag='Y'",1,dw_2.rowcount())  // 신규 없으면 return
if lfrow = 0 then return 1

sdate  = trim(dw_1.getitemstring(1,'date'))
smchno = dw_1.getitemstring(1,'mchno')

// 생산 팀 반
select c.dptno into :sdeptcode
  from mchmst a, wrkctr b, jomast c
 where a.mchno = :smchno
   and a.wkctr = b.wkctr
   and b.jocod = c.jocod ;
if sqlca.sqlcode <> 0 then
	sdeptcode = gs_dept
end if

// MRO 창고
select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :gs_dept and juprod = 'Z' ;
if sqlca.sqlcode <> 0 then
	sdepot = 'Z57'
end if	

// 전표채번
lfrow = dw_2.find("not isnull(imhist_iojpno)",1,dw_2.rowcount())
if lfrow > 0 then
	sjpno = left(dw_2.getitemstring(lfrow,'imhist_iojpno'),12)
else
	dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
	IF dSeq < 1		THEN
		ROLLBACK;
		f_message_chk(51,'[출고번호]')
		RETURN -1
	END IF
	COMMIT;
	sJpno  = sDate + string(dSeq, "0000")
end if
			
siogbn = 'O81'	/* 수불구분 - MRO 불출	*/

FOR lRow = 1	TO	dw_2.RowCount()
	siojpno = dw_2.getitemstring(lrow,'imhist_iojpno')
	if isnull(siojpno) or siojpno = '' then
		
		dw_2.SetItem(lRow, "imhist_sabu",		gs_sabu)
		dw_2.SetItem(lRow, "imhist_jnpcrt",		'001')											// 전표생성구분
		dw_2.SetItem(lRow, "imhist_inpcnf",		'O')												// 입출고구분
		dw_2.SetItem(lRow, "imhist_iojpno", 	sJpno+string(lRow, "000"))
		dw_2.SetItem(lRow, "imhist_iogbn",  	siogbn) 											// 수불구분
		dw_2.SetItem(lRow, "imhist_sudat",	 	sDate)											// 수불일자=현재일자
		dw_2.SetItem(lRow, "imhist_pspec",	 	".")												//사양
		dw_2.SetItem(lRow, "imhist_opseq",	 	'9999') 											// 공정순서
	
		dw_2.SetItem(lRow, "imhist_depot_no",	sdepot) 											// 기준창고=담당부서창고
		dw_2.SetItem(lRow, "imhist_io_empno",	gs_empno)										// 수불승인자=담당자
		dw_2.SetItem(lRow, "imhist_ioredept",	sdeptcode)										// 수불승인자=담당자
		dw_2.SetItem(lRow, "imhist_cvcod",		sdeptcode)										// 거래처창고=사용부서
		
		dw_2.SetItem(lRow, "imhist_insdat",		sDate) 											// 검사일자=입고의뢰일자
		dw_2.SetItem(lRow, "imhist_ioreqty", 	dw_2.GetItemDecimal(lRow, "imhist_ioqty"))		// 합격수량=출고의뢰수량
		dw_2.SetItem(lRow, "imhist_iosuqty", 	dw_2.GetItemDecimal(lRow, "imhist_ioqty"))		// 합격수량=출고수량
	
		dw_2.SetItem(lRow, "imhist_io_confirm", 'Y')												// 수불승인여부
		dw_2.SetItem(lRow, "imhist_io_date", 	sDate)											// 수불승인일자=입고일자
		dw_2.SetItem(lRow, "imhist_filsk", 		'Y')												// 재고관리구분
		dw_2.SetItem(lRow, "imhist_mchno", 	smchno)											   // 사용처
		dw_2.SetItem(lRow, "imhist_bigo", 		'사용자재등록')								// 비고
		dw_2.setitem(lrow, "crt_flag", 'N')
	end if
NEXT
	
RETURN 1
end function

on w_pdt_06100_popup03.create
this.p_inq=create p_inq
this.p_close=create p_close
this.p_save=create p_save
this.p_del=create p_del
this.p_add=create p_add
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_inq,&
this.p_close,&
this.p_save,&
this.p_del,&
this.p_add,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_pdt_06100_popup03.destroy
destroy(this.p_inq)
destroy(this.p_close)
destroy(this.p_save)
destroy(this.p_del)
destroy(this.p_add)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;string	smchnam, siojpno

f_window_center(This)

this.title = message.stringparm + this.title

dw_2.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

if gs_codename2 = '2' then		// 정기점검
	select iojpno 
	  into :siojpno 
	  from mchrsl
	 where sabu  = :gs_sabu 
	   and sidat = :gs_gubun
		and gubun = '2'
		and mchno = :gs_code
		and iojpno is not null 
		and rownum = 1 ;
else									// 수리결과
	select iojpno 
	  into :siojpno 
	  from mchrsl
	 where sabu  = :gs_sabu 
	   and sidat = :gs_gubun
		and gubun = :gs_codename2
		and mchno = :gs_code
		and seq   = :gi_page
		and iojpno is not null 
		and rownum = 1 ;
end if
	
	
dw_1.setitem(1,'sidat',gs_gubun)
dw_1.setitem(1,'mchno',gs_code)

select mchnam into :smchnam from mchmst
 where mchno = :gs_code ;

dw_1.setitem(1,'mchnam',smchnam)
dw_1.setitem(1,'date',gs_codename)
dw_1.setitem(1,'gubun',gs_codename2)
dw_1.setitem(1,'seq',gi_page)
dw_1.setitem(1,'iojpno',siojpno)

// MRO 창고
string	sdepot

select cvcod into :sdepot from vndmst
 where cvgu = '5' and deptcode = :gs_dept and juprod = 'Z' ;
if sqlca.sqlcode <> 0 then
	sdepot = 'Z57'
end if
dw_1.setitem(1,'deptcode',sdepot)

p_inq.postevent(clicked!)
end event

type p_inq from picture within w_pdt_06100_popup03
integer x = 1385
integer y = 24
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\조회_up.gif"
boolean focusrectangle = false
end type

event clicked;string	sjpno

dw_1.accepttext()

sjpno = dw_1.getitemstring(1,'iojpno')
if isnull(sjpno) or sjpno = '' then
	sjpno = 'XXXXXXXXXXXX'
else
	sjpno = sjpno + '%'
end if

setpointer(hourglass!)
if dw_2.Retrieve(sjpno) < 1 then
	return
end if

dw_1.setitem(1,'date',dw_2.getitemstring(1,'imhist_sudat'))
end event

type p_close from picture within w_pdt_06100_popup03
integer x = 2098
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_save from picture within w_pdt_06100_popup03
integer x = 1563
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;if dw_1.AcceptText() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return
if wf_required_chk() = -1 then return

If f_msg_update() < 1 Then Return
if wf_imhist_create() = -1 then return

dw_2.accepttext()
if dw_2.update() <> 1 then
	rollback ;
	messagebox('확인','MRO 불출자료 생성실패!!!')
	return -1
end if

if wf_mchrsl_update() = -1 then return

Commit;

messagebox('확인','자료를 저장하였습니다.')
//p_close.postevent(clicked!)
end event

type p_del from picture within w_pdt_06100_popup03
integer x = 1920
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\ERPMAN\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;Long 	ll_r

ll_r = dw_2.GetRow()
If ll_r < 1 Then Return

dw_2.DeleteRow(ll_r)
end event

type p_add from picture within w_pdt_06100_popup03
integer x = 1742
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\ERPMAN\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event clicked;Long ll_r

ll_r = dw_2.InsertRow(0)

dw_2.setitem(ll_r,'imhist_depot_no',dw_1.getitemstring(1,'deptcode'))
dw_2.ScrollToRow(ll_r)
dw_2.SetFocus()
dw_2.SetColumn(1)
end event

type dw_2 from datawindow within w_pdt_06100_popup03
event ue_pressenter pbm_dwnprocessenter
integer x = 64
integer y = 376
integer width = 2203
integer height = 1176
integer taborder = 10
string title = "none"
string dataobject = "d_pdt_06100_popup04"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;long		lrow
String 	ls_cod , ls_col, ls_itdsc, ls_ispec, snull

lrow = this.getrow()
if lrow < 1 then return

setnull(snull)
ls_col = GetColumnName()

Choose Case ls_col
	Case "imhist_itnbr"
		
		ls_cod = GetText()
		if isnull(ls_cod) or ls_cod = '' then
			this.setitem(lrow,'itemas_itdsc',snull)
			this.setitem(lrow,'itemas_ispec',snull)
			return
		end if 
		
		Select itdsc, ispec Into :ls_itdsc, :ls_ispec
		  From itemas
		  where sabu = :gs_sabu and itnbr = :ls_cod ;
		 
		If SQLCA.SQLCODE <> 0 then
			this.setitem(lrow,'imhist_itnbr',snull)
			this.setitem(lrow,'itemas_itdsc',snull)
			this.setitem(lrow,'itemas_ispec',snull)
			Return 1
		Else
			this.setitem(lrow,'itemas_itdsc',ls_itdsc)
			this.setitem(lrow,'itemas_ispec',ls_ispec)
		End if
		
End Choose
end event

event rbuttondown;long		lrow
str_code lst_code

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

lrow = this.getrow()
if lrow < 1 then return

If	this.getcolumnname() = "imhist_itnbr" Then
	open(w_stock_popup1)
   
	lst_code = Message.PowerObjectParm
   if gs_code= '' or isnull(gs_code) Then Return
   this.SetItem(lrow, "imhist_itnbr", gs_code)
	this.SetItem(lrow, 'jego_qty',   lst_code.qty)
	this.TriggerEvent(Itemchanged!)
End if 
end event

type dw_1 from datawindow within w_pdt_06100_popup03
integer x = 41
integer y = 192
integer width = 2245
integer height = 172
integer taborder = 10
string title = "none"
string dataobject = "d_pdt_06100_popup03_a"
boolean border = false
boolean livescroll = true
end type

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if	this.getcolumnname() = "mchno" then
	open(w_mchno_popup)

   if gs_code= '' or isnull(gs_code) then return
   this.setitem(1,"mchno",gs_code)
	
   this.TriggerEvent(itemchanged!)
end if  
end event

event itemchanged;string	scode, sname, snull

if	this.getcolumnname() = "mchno" then
	scode = this.gettext()
	if isnull(scode) or scode = '' then
		this.setitem(1,'mchnam',snull)
		return
	end if
	
	select mchnam into :sname from mchmst
	 where mchno = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'mchnam',sname)
	else
		this.setitem(1,'mchno',snull)
		this.setitem(1,'mchnam',snull)
		return 1
	end if
end if  
end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_pdt_06100_popup03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 368
integer width = 2222
integer height = 1196
integer cornerheight = 40
integer cornerwidth = 55
end type

