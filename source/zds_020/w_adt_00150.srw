$PBExportHeader$w_adt_00150.srw
$PBExportComments$운송비 등록(영업)
forward
global type w_adt_00150 from w_inherite
end type
type dw_cond from datawindow within w_adt_00150
end type
type dw_list from datawindow within w_adt_00150
end type
type st_2 from statictext within w_adt_00150
end type
type pb_1 from u_pb_cal within w_adt_00150
end type
type pb_2 from u_pb_cal within w_adt_00150
end type
type pb_3 from u_pb_cal within w_adt_00150
end type
type cbx_1 from checkbox within w_adt_00150
end type
type rb_1 from radiobutton within w_adt_00150
end type
type rb_2 from radiobutton within w_adt_00150
end type
type st_3 from statictext within w_adt_00150
end type
type cbx_2 from checkbox within w_adt_00150
end type
type cbx_3 from checkbox within w_adt_00150
end type
type rr_1 from roundrectangle within w_adt_00150
end type
type rr_2 from roundrectangle within w_adt_00150
end type
type rr_3 from roundrectangle within w_adt_00150
end type
end forward

global type w_adt_00150 from w_inherite
string title = "운송비 등록"
dw_cond dw_cond
dw_list dw_list
st_2 st_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
cbx_1 cbx_1
rb_1 rb_1
rb_2 rb_2
st_3 st_3
cbx_2 cbx_2
cbx_3 cbx_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_adt_00150 w_adt_00150

type variables
string is_gbn
end variables

forward prototypes
public function integer wf_ins_chk ()
public function integer wf_mod_chk ()
public subroutine wf_init ()
end prototypes

public function integer wf_ins_chk ();string sdate, sdept, scvcod

sdate  = dw_cond.GetItemString(1, 'sdate')
sdept  = dw_cond.GetItemString(1, 'deptcode')
scvcod = dw_cond.GetItemString(1, 'cvcod')

if sdate = '' or isNull(sdate) then
	f_message_chk(30,'[운송일자]')
	dw_cond.SetColumn("sdate")
	dw_cond.SetFocus()
	RETURN -1
END IF

if sdept = '' or isNull(sdept) then
	f_message_chk(30,'[작성부서]')
	dw_cond.SetColumn("deptcode")
	dw_cond.SetFocus()
	RETURN -1
END IF


if scvcod = '' or isNull(scvcod) then
	f_message_chk(30,'[거래처]')
	dw_cond.SetColumn("cvcod")
	dw_cond.SetFocus()
	RETURN -1
END IF

return 1
end function

public function integer wf_mod_chk ();string scvcod, sarea, scarno, sdriver
double damt

scvcod  = dw_insert.GetItemString(1, 'cvcod')
sarea   = dw_insert.GetItemString(1, 'areanm')
scarno  = dw_insert.GetItemString(1, 'carno')
sdriver = dw_insert.GetItemString(1, 'driver')
damt    = dw_insert.GetItemNumber(1, 'trnsamt')

if scvcod = '' or isNull(scvcod) then
	f_message_chk(30,'[운송업체]')
	dw_insert.SetColumn("cvcod")
	dw_insert.SetFocus()
	RETURN -1
END IF

if scarno = '' or isNull(scarno) then
	f_message_chk(30,'[차량번호]')
	dw_insert.SetColumn("carno")
	dw_insert.SetFocus()
	RETURN -1
END IF

if sdriver = '' or isNull(sdriver) then
	f_message_chk(30,'[차량번호]')
	dw_insert.SetColumn("driver")
	dw_insert.SetFocus()
	RETURN -1
END IF

if damt = 0 or isNull(damt) then
	f_message_chk(30,'[운송금액]')
	dw_insert.SetColumn("trnsamt")
	dw_insert.SetFocus()
	RETURN -1
END IF

return 1
end function

public subroutine wf_init ();string t_name
dw_list.Reset()
dw_insert.Reset()
dw_cond.Reset()
dw_cond.InsertRow(0)

f_mod_saupj(dw_cond, 'saupj')
dw_cond.SetItem(1, 'sdate', f_today())

dw_cond.SetItem(1, 'fdate', f_today())
dw_cond.SetItem(1, 'tdate', f_today())


dw_cond.SetColumn('deptcode')
dw_cond.SetFocus()


dw_cond.SetItem(1, 'gbn', is_gbn)

if is_gbn = '2' then
	t_name = '운송업체'
	dw_cond.Modify("t_cvcod.text = '"+t_name+"'")

	p_ins.Picturename = 'c:\erpman\image\추가_d.gif'
	p_ins.Enabled = false	
	p_search.PictureName = 'c:\erpman\image\계산_d.gif'
	p_search.Enabled = false
//	p_del.Picturename = 'c:\erpman\image\삭제_up.gif'
//	p_del.Enabled = true
	dw_list.dataobject = 'd_adt_00150_03'
//	dw_list.dataobject = 'd_adt_00150_04'
	pb_1.visible = False
else
	t_name = '출고거래처'
	dw_cond.Modify("t_cvcod.text = '"+t_name+"'")
	p_ins.Picturename = 'c:\erpman\image\추가_d.gif'
	p_ins.Enabled = false
	p_search.PictureName = 'c:\erpman\image\계산_d.gif'
	p_search.Enabled = false
//	p_del.Picturename = 'c:\erpman\image\삭제_d.gif'
//	p_del.Enabled = false
	dw_list.dataobject = 'd_adt_00150_03'
	pb_1.visible = true
end if

dw_list.SetTransObject(sqlca)
end subroutine

on w_adt_00150.create
int iCurrent
call super::create
this.dw_cond=create dw_cond
this.dw_list=create dw_list
this.st_2=create st_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.cbx_1=create cbx_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_3=create st_3
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cond
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_3
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.rb_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.cbx_2
this.Control[iCurrent+12]=this.cbx_3
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
end on

on w_adt_00150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cond)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.cbx_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_3)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;dw_cond.SetTransobject(sqlca)
dw_insert.SetTransobject(sqlca)
dw_list.SetTransobject(sqlca)

is_gbn = '1'

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_adt_00150
integer x = 32
integer y = 300
integer width = 4544
integer height = 768
string dataobject = "d_adt_00150_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemfocuschanged;call super::itemfocuschanged;Choose Case GetColumnName()
	Case 'areanm', 'carno', 'driver', 'bigo'
		f_toggle_kor(handle(this))		
	Case Else
		f_toggle_eng(handle(this))
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::itemchanged;call super::itemchanged;string scvcod, scvnas, snull, starea, starea_nm
string ls_chk, ls_farea, ls_tarea, ls_cvcod, ls_frunit
dec    dl_sum, dl_boxqty, dl_rate, dl_tot
long   ll_row, ll_cnt

if dw_insert.AcceptText() <> 1 then return 2
ll_row = dw_insert.GetRow()
setNull(sNull)

Choose Case getcolumnname()
	case 'cvcod'
		scvcod = trim(gettext())
		select cvnas2 into :scvnas
		  from vndmst
		 where cvcod = :scvcod;
		
		if sqlca.sqlcode = 0 then
			setitem(getrow(), 'cvnas2', scvnas)
		else
			setitem(getrow(), 'cvnas2', snull)
			setitem(getrow(), 'cvnas2', snull)
		end if
	case 'toarea'	
		starea = trim(gettext())
		select rfna1 into :starea_nm
  	     from reffpf
		 where rfcod = '37'
		   and rfgub = :starea;
	   if sqlca.sqlcode = 0 then
			setitem(getrow(), 'areanm', starea_nm)
		else
			setitem(getrow(), 'areanm', snull)
		end if		
	case 'frunit' , 'boxqty', 'cvcod', 'frarea', 'toarea'
		ls_frunit = dw_insert.GetItemString(ll_row,"frunit")
		ls_cvcod  = dw_insert.GetItemString(ll_row,"cvcod")
		ls_farea  = dw_insert.GetItemString(ll_row,"frarea")
		ls_tarea  = dw_insert.GetItemString(ll_row,"toarea")
		dl_boxqty = dw_insert.GetItemNumber(ll_row,"boxqty")
		
		select count(*)
		  into :ll_cnt
		  from fr_charges
		 where cvcod  = :ls_cvcod
			and frarea = :ls_farea
			and toarea = :ls_tarea
			and frunit = :ls_frunit;
		if ll_cnt > 0 then	
			select nvl(frprice,0)
			  into :dl_rate
			  from fr_charges
			 where cvcod  = :ls_cvcod
				and frarea = :ls_farea
				and toarea = :ls_tarea
			   and frunit = :ls_frunit;
				dl_sum = dl_rate * dl_boxqty
				dw_insert.setitem(ll_row,'trnsamt',dl_sum ) 
		else
			dl_rate = 0
			dw_insert.setitem(ll_row,'trnsamt',0 ) 
		end if	      		
		
End Choose

end event

event dw_insert::rbuttondown;call super::rbuttondown;String snull

setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)
setNull(sNull)

Choose Case GetColumnName()
	Case 'cvcod'
		gs_gubun = '1'
		open(w_vndmst_popup)
		
		if gs_code = '' or isNull(gs_code) then
			setitem(getrow(), 'cvcod', snull)
			setitem(getrow(), 'cvnas2', snull)
		else
			setitem(getrow(), 'cvcod',  gs_code)
			setitem(getrow(), 'cvnas2', gs_codename)
		end if

End Choose
			
		
end event

event dw_insert::doubleclicked;call super::doubleclicked;if is_gbn = '1' then return
if RowCount() < 1 then return

string sjpno

sjpno = trim(This.GetItemString(getrow(), 'trnsno'))

//if sjpno <> '' or not(isnull(sjpno)) then
//	dw_list.Retrieve(gs_sabu, gs_saupj, sjpno)
//end if	
//
end event

event dw_insert::clicked;call super::clicked;string sjpno

if is_gbn = '1' then return
if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)

//sjpno = trim(This.GetItemString(row, 'trnsno'))
//if sjpno <> '' or not(isnull(sjpno)) then
//	dw_list.Retrieve(gs_sabu, gs_saupj, sjpno)
//end if	
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;string sjpno
if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

sjpno   = trim(This.GetItemString(currentrow, 'trnsno'))
//if sjpno <> '' or not(isnull(sjpno)) then
//	dw_list.Retrieve(gs_sabu, gs_saupj, sjpno)
//end if	
end event

type p_delrow from w_inherite`p_delrow within w_adt_00150
integer x = 2825
integer y = 700
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_adt_00150
integer x = 2651
integer y = 700
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_adt_00150
integer x = 3749
boolean enabled = false
string picturename = "C:\erpman\image\계산_d.gif"
end type

event p_search::clicked;call super::clicked;string ls_chk, ls_farea, ls_tarea, ls_cvcod, ls_frunit
int    i
dec    dl_sum, dl_boxqty, dl_rate, dl_tot
long   ll_row, ll_cnt

p_search.PictureName = 'c:\erpman\image\계산_dn.gif'
p_search.PictureName = 'c:\erpman\image\계산_up.gif'

if dw_list.accepttext() = -1 then return
if dw_insert.accepttext() = -1 then return

dl_sum    = 0
dl_boxqty = 0

ll_row   = dw_insert.getrow()
ls_farea = dw_insert.Getitemstring(ll_row,'frarea')
ls_tarea = dw_insert.Getitemstring(ll_row,'toarea')
ls_cvcod = dw_insert.Getitemstring(ll_row,'cvcod')

//선택한 출고 박스 수량 SUM
//for i = 1 to dw_list.rowcount()
//	 ls_chk = dw_list.Getitemstring(i,'chk')
//	 if ls_chk = 'Y' then
//		 dl_boxqty = dw_list.Getitemnumber(i,'boxqty')
//		 dl_sum = dl_sum + dl_boxqty
//	 end if	 
//next	
//

boolean lb_found
long ll_breakrow

lb_found    = FALSE
ll_breakrow = 0
dl_tot      = 0
DO WHILE NOT (lb_found)
        ll_breakrow = dw_list.FindGroupChange(ll_breakrow, 1)
		  
        IF ll_breakrow <= 0 THEN EXIT
		  
        IF dw_list.GetItemNumber(ll_breakrow, "boxqty_sum") > 0 THEN
			  if dl_tot > 0 then
				  dw_insert.RowsCopy(ll_row, ll_row, Primary!, dw_insert, ll_row+1, Primary!)
				  ll_row = ll_row + 1
			  End if
			  
			  dl_sum    = 0
			  dl_rate   = 0
           dl_sum    = dl_sum + dw_list.GetItemNumber(ll_breakrow, "boxqty_sum")
			  ls_frunit = dw_list.GetItemString(ll_breakrow, "packsize_sum")
				//기준 운송비
				select count(*)
				  into :ll_cnt
				  from fr_charges
				 where cvcod  = :ls_cvcod
					and frarea = :ls_farea
					and toarea = :ls_tarea
					and frunit = :ls_frunit;
				if isNull(ll_cnt) then ll_cnt = 0
				if ll_cnt > 0 then	
					select nvl(frprice,0)
					  into :dl_rate
					  from fr_charges
					 where cvcod  = :ls_cvcod
						and frarea = :ls_farea
						and toarea = :ls_tarea
						and frunit = :ls_frunit;
				else
					dl_rate = 0
				end if	
				//운송비 계산
				dw_insert.setitem(ll_row,'frunit',ls_frunit ) 
				dw_insert.setitem(ll_row,'boxqty',dl_sum ) 
				dl_sum = dl_rate * dl_sum
				dw_insert.setitem(ll_row,'trnsamt',dl_sum) 
				dl_tot   = dl_tot + 100
        END IF
        ll_breakrow = ll_breakrow + 1
		
LOOP
IF dl_tot = 0 THEN
        MessageBox("확인", "자료가 없습니다!!")
END IF

end event

event p_search::doubleclicked;call super::doubleclicked;p_search.PictureName = 'c:\erpman\image\계산_dn.gif'
p_search.PictureName = 'c:\erpman\image\계산_up.gif'
end event

type p_ins from w_inherite`p_ins within w_adt_00150
integer x = 3575
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;string sdept, sdate, scvcod, sjpno, sfrarea, stoarea
long   lRow, lCnt
int    i

if dw_cond.AcceptText() <> 1 then return 2
if wf_ins_chk() <> 1 then return 2

//for i = 1 to dw_list.Rowcount()
//	 if dw_list.GetItemString(i, 'chk') = 'Y' then lCnt++
//Next
//	
//if lcnt < 1 then
//	MessageBox('[출고내역]', '선택하신 출고 내역이 없습니다.~n출고내역 선택 후 작업가능 합니다', Exclamation!)
//	return
//end if
	
p_search.PictureName = 'c:\erpman\image\계산_up.gif'
p_search.Enabled = true
	
sdept  = dw_cond.GetItemString(1, 'deptcode')
sdate  = dw_cond.GetItemString(1, 'sdate')
scvcod = dw_cond.GetItemString(1, 'cvcod')

/*출발지역 셋팅*/
lcnt = 0
select count(*)
  into :lcnt
  from syscnfg
 where sysgu  = 'S'          //영업
   and serial = '9'          //기초환경
	and lineno in ('12','13') //line no
	and gubun  = '10'         //사업장
	and rfcod  = :gs_saupj;
if lcnt > 0 then
	select NVL(dataname,'')
	  into :sfrarea
	  from syscnfg
	 where sysgu  = 'S'          //영업
		and serial = '9'          //기초환경
		and lineno in ('12','13') //line no
		and gubun  = '10'         //사업장
		and rfcod  = :gs_saupj;
end if		
	
/*운송지역 셋팅*/
lcnt = 0
select count(*)
  into :lcnt
  from vndmst
 where cvcod = :scvcod;
if lcnt > 0 then
	select nvl(exarea,'')
	  into :stoarea
	  from vndmst
	 where cvcod = :scvcod;
end if	

lRow = dw_insert.InsertRow(9999)
dw_insert.ScrollToRow(lRow)
dw_insert.SetItem(lRow, 'sabu',     gs_sabu)
dw_insert.SetItem(lRow, 'saupj',    gs_saupj)
dw_insert.SetItem(lRow, 'trnsdat',  sdate)
dw_insert.SetItem(lRow, 'deptcode', sdept)
dw_insert.SetItem(lRow, 'frarea',   sfrarea)
dw_insert.SetItem(lRow, 'toarea',   stoarea)

dw_insert.SetColumn('cvcod')
dw_insert.SetFocus()

return 1

end event

type p_exit from w_inherite`p_exit within w_adt_00150
end type

type p_can from w_inherite`p_can within w_adt_00150
end type

event p_can::clicked;call super::clicked;rb_1.checked = true
is_gbn = '1'
rb_2.checked = false
wf_init()

end event

type p_print from w_inherite`p_print within w_adt_00150
integer x = 2130
integer y = 700
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_adt_00150
integer x = 3401
end type

event p_inq::clicked;call super::clicked;string sfdate, stdate, sdept, scvcod, sSale_cvcod, sSdate

if dw_cond.AcceptText() <> 1 then return

sSdate  = trim(dw_cond.Getitemstring(1, 'sdate'))
//sfdate  = trim(dw_cond.Getitemstring(1, 'fdate'))
//stdate  = trim(dw_cond.Getitemstring(1, 'tdate'))
sdept   = trim(dw_cond.Getitemstring(1, 'deptcode'))
scvcod  = trim(dw_cond.Getitemstring(1, 'cvcod'))

If sSdate = '' or isNull(sSdate) then
	f_Message_Chk(30, '[일자]')
	dw_cond.SetColumn('sdate')
	dw_cond.setfocus()
	Return 1
End If

sfdate = sSdate
stdate = sSdate
//
//if sfdate = '' or isNull(sfdate) then sfdate = '11111111'
//if stdate = '' or isNull(stdate) then stdate = '99999999'
if sdept  = '' or isNull(sdept)  then sdept = '%'

if is_gbn = '1' then	
	If scvcod = '' or isNull(sCvcod) then
	   f_Message_Chk(30, '[거래처코드]')
	   dw_cond.SetColumn('cvcod')
	   dw_cond.setfocus()
	   Return 1
   End If

	if dw_list.Retrieve(gs_sabu, gs_saupj, sfdate, scvcod) < 1 then
		MessageBox('조회', '해당 의뢰기간으로 조회한 출고 내역이 없습니다.', Exclamation!)
		dw_cond.SetColumn('fdate')
		dw_cond.SetFocus()	
		return 2
	end if
	
	p_ins.Enabled = true
	p_ins.PictureName = 'c:\erpman\image\추가_up.gif'
else
	If sdept = '' or isNull(sdept) or sdept = '%' then
	   f_Message_Chk(30, '[등록부서]')
	   dw_cond.SetColumn('deptcode')
	   dw_cond.setfocus()
	   Return 1
   End If

	If scvcod = '' or isNull(sCvcod) then
		f_Message_Chk(30, '[거래처코드]')
		dw_cond.SetColumn('cvcod')
		dw_cond.setfocus()
		Return 1
	End If

	if dw_insert.Retrieve(gs_sabu, gs_saupj, sdept, sfdate, scvcod) < 1 then
		MessageBox('조회', '해당 조건으로 조회한 운송비 등록 내역이 없습니다.', Exclamation!)
		dw_cond.SetColumn('sdate')
		dw_cond.SetFocus()	
		return 2
	Else
		sSale_cvcod = dw_insert.GetItemString(1, 'sale_cvcod')
		if dw_list.Retrieve(gs_sabu, gs_saupj, sfdate, sSale_cvcod) < 1 then
			MessageBox('조회', '해당 의뢰기간으로 조회한 출고 내역이 없습니다.', Exclamation!)
			dw_cond.SetColumn('sdate')
			dw_cond.SetFocus()	
			return 2
		end if		
	end if
end if
end event

type p_del from w_inherite`p_del within w_adt_00150
end type

event p_del::clicked;call super::clicked;if dw_list.RowCount() < 1 then return
if dw_list.AcceptText() <> 1 then return

long i, j
string sjpno, schk

j = 0

dw_insert.DeleteRow(dw_insert.GetRow())

if is_gbn = '2' then
	if dw_insert.Update() < 1 then
		MessageBox('삭제실패', '삭제에 실패하였습니다.~r' +&
									  '전산실에 문의하세요.', Stopsign!)
		rollback;
		return
	end if	
	commit;
	
	p_inq.triggerevent(clicked!)
	
End if
end event

type p_mod from w_inherite`p_mod within w_adt_00150
end type

event p_mod::clicked;call super::clicked;string sjpno, sdate, siojpno, scvcod
long dmaxno, i, dCnt

if dw_insert.RowCount() < 1 then return 2
if dw_insert.AcceptText() <> 1 then return 2
if wf_mod_chk() <> 1 then return 2

dCnt = 0

//업무 구분 필드(영업 = 'S', 구매 = 'M')
for i = 1 to dw_insert.rowcount()
	 dw_insert.Setitem(i, 'trnsgu', 'S')
next	

if is_gbn = '1' then
	for i = 1 to dw_list.Rowcount()
		if dw_list.GetItemString(i, 'chk') = 'Y' then dCnt++
	Next
	
	if dcnt < 1 then
		MessageBox('[출고내역]', '선택하신 출고 내역이 없습니다.~n출고내역 선택 후 작업가능 합니다', Exclamation!)
		return
	end if		
	
//	if MessageBox('[출고내역 연결]', '[출고 내역]에 Check된  의뢰 내역의 해당 운송장에 연결 하시겠습니까?', &
//														question!, YesNo!, 2) = 2 then
//		return 2
//	end if
	
	sdate  = dw_cond.GetItemString(1, 'sdate')
	scvcod = dw_cond.GetItemString(1, 'cvcod')
	
		// 운송장 번호 채번
		dmaxno = sqlca.fun_junpyo(gs_sabu, sdate, 'M2') 
		commit;
	for i = 1 to dw_list.Rowcount()
		sjpno  = sdate + string(dmaxno, '0000') + string(i, '0000') 
		dw_insert.Setitem(i, 'trnsno', sjpno)
		dw_insert.Setitem(i, 'sale_cvcod', scvcod)
	Next
	
	if dw_insert.update() <> 1 then
		MessageBox('저장실패', '[운송비] 등록에 실패했습니다.~r' + &
									  '전산실에 문의 하세요.', Stopsign!)
		Rollback;
		return
	end if
	
//	for i = 1 to dw_list.Rowcount()
//		siojpno = dw_list.GetItemString(i , 'iojpno')
//		if dw_list.GetItemString(i, 'chk') = 'Y' then
//			update imhist
//				set yebi5 = :sjpno
//			 where sabu   = :gs_sabu
//				and iojpno = :siojpno;
//			
//			if sqlca.sqlcode <> 0 then
//				MessageBox('저장실패', '[출고 - 운송번호 저장] UPDATE 실패!~r' + &
//											  '전산실에 문의 하세요.', Stopsign!)
//				Rollback;
//				return
//			end if
//			
//			update imhist
//				set yebi5 = :sjpno
//			 where sabu = :gs_sabu 
//				and ip_jpno = :siojpno;
//			
//			if sqlca.sqlcode <> 0 then
//				MessageBox('저장실패', '[출고(입고) - 운송번호 저장] UPDATE 실패!~r' + &
//											  '전산실에 문의 하세요.', Stopsign!)
//				Rollback;
//				return
//			end if
//		end if
//	Next
else
	if dw_insert.update() <> 1 then
		MessageBox('저장실패', '[운송내역] 수정에 실패했습니다.~r' + &
									  '전산실에 문의 하세요.', Stopsign!)
		Rollback;
		return
	end if
end if
Commit;

p_inq.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_adt_00150
end type

type cb_mod from w_inherite`cb_mod within w_adt_00150
end type

type cb_ins from w_inherite`cb_ins within w_adt_00150
end type

type cb_del from w_inherite`cb_del within w_adt_00150
end type

type cb_inq from w_inherite`cb_inq within w_adt_00150
end type

type cb_print from w_inherite`cb_print within w_adt_00150
end type

type st_1 from w_inherite`st_1 within w_adt_00150
end type

type cb_can from w_inherite`cb_can within w_adt_00150
end type

type cb_search from w_inherite`cb_search within w_adt_00150
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_00150
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_00150
end type

type dw_cond from datawindow within w_adt_00150
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 23
integer y = 36
integer width = 2770
integer height = 228
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_00150_01"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;send(handle(this), 256,9,0)
return 1
end event

event itemerror;return 1
end event

event rbuttondown;string sNull

setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)
setNull(sNull)


Choose Case GetColumnName()
	Case "deptcode"
		open(w_vndmst_4_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return		
		SetItem(1, "deptcode", gs_Code)
		SetItem(1, "deptname", gs_Codename)
		
	Case "sjpno"
		
	/* 거래처 */
	Case "cvcod"
		Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN 2
		
		SetItem(1, 'cvcod', gs_code)
		TriggerEvent(ItemChanged!)	
End Choose
end event

event itemchanged;string sNull, sjpno, sdeptcode, sdeptname, sData, sname, sname1, sFdate
long   ireturn
setNull(sNull)

dw_cond.AcceptText()
Choose Case GetColumnName()
	Case "sdate"
		sFdate = Trim(GetText())
		
		setitem(1, 'fdate', sFdate)
		
	Case "deptcode"
		sdeptcode = Trim(GetText())
		
		select cvnas into :sdeptname
		  from vndmst
		 where cvgu = '4'
		   and cvcod = :sdeptcode;
		
		if sqlca.sqlcode = 0 then
			setitem(1, 'deptname', sdeptname)
		else
			setitem(1, 'deptcode', snull)
			setitem(1, 'deptname', snull)
		end if
		
	Case "sjpno"
		
	/* 거래처 */
	Case "cvcod"
		sData = gettext()
		ireturn = f_get_name2("V1", 'Y', sdata, sname, sname1)
		if ireturn = 0 then
			setitem(1, "cvcod_nm", sName)
		Else
			setitem(1, "cvcod",   sNull)
			setitem(1, "cvcod_nm", sNull)
			return 1
		End if	
End Choose
end event

type dw_list from datawindow within w_adt_00150
integer x = 27
integer y = 1204
integer width = 4544
integer height = 1032
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_adt_00150_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_adt_00150
integer x = 32
integer y = 1116
integer width = 466
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "* 출고 내역"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_adt_00150
integer x = 663
integer y = 152
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_adt_00150
boolean visible = false
integer x = 3392
integer y = 176
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('fdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'fdate', gs_code)

end event

type pb_3 from u_pb_cal within w_adt_00150
boolean visible = false
integer x = 1097
integer y = 148
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_cond.SetColumn('tdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_cond.SetItem(1, 'tdate', gs_code)

end event

type cbx_1 from checkbox within w_adt_00150
integer x = 4256
integer y = 1108
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;if dw_list.RowCount() < 1 then return

long i

For i = 1 to dw_list.RowCount()
	IF checked then
		dw_list.SetItem(i, 'chk', 'Y')
	ELSE
		dw_list.SetItem(i, 'chk', 'N')
	END IF
NEXT


	
end event

type rb_1 from radiobutton within w_adt_00150
integer x = 2853
integer y = 84
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등  록"
boolean checked = true
end type

event clicked;is_gbn = '1'

wf_init()
end event

type rb_2 from radiobutton within w_adt_00150
integer x = 2853
integer y = 168
integer width = 306
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "수  정"
end type

event clicked;is_gbn = '2'

wf_init()
end event

type st_3 from statictext within w_adt_00150
integer x = 3730
integer y = 196
integer width = 901
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "[계산 Button:용기 적용시에만]"
boolean focusrectangle = false
end type

type cbx_2 from checkbox within w_adt_00150
integer x = 3867
integer y = 1104
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "주간선택"
end type

event clicked;if dw_list.RowCount() < 1 then return

long i

For i = 1 to dw_list.RowCount()
	if dw_list.GetItemString(i, "gungbn") = 'D' then
		IF checked then
			dw_list.SetItem(i, 'chk', 'Y')
		ELSE
			dw_list.SetItem(i, 'chk', 'N')
		END IF
	End if
NEXT


	
end event

type cbx_3 from checkbox within w_adt_00150
integer x = 3474
integer y = 1104
integer width = 347
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "야간선택"
end type

event clicked;if dw_list.RowCount() < 1 then return

long i

For i = 1 to dw_list.RowCount()
	if dw_list.GetItemString(i, "gungbn") <> 'D' then
		IF checked then
			dw_list.SetItem(i, 'chk', 'Y')
		ELSE
			dw_list.SetItem(i, 'chk', 'N')
		END IF
	End if
NEXT


	
end event

type rr_1 from roundrectangle within w_adt_00150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 23
integer y = 284
integer width = 4576
integer height = 800
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_adt_00150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 23
integer y = 1188
integer width = 4576
integer height = 1064
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_adt_00150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 2798
integer y = 40
integer width = 425
integer height = 220
integer cornerheight = 40
integer cornerwidth = 55
end type

