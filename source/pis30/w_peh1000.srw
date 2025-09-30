$PBExportHeader$w_peh1000.srw
$PBExportComments$** 분기별 학자금 등록
forward
global type w_peh1000 from w_inherite_multi
end type
type dw_1 from datawindow within w_peh1000
end type
type dw_2 from datawindow within w_peh1000
end type
type dw_4 from datawindow within w_peh1000
end type
type st_2 from statictext within w_peh1000
end type
type st_3 from statictext within w_peh1000
end type
type sle_find from singlelineedit within w_peh1000
end type
type dw_cond from datawindow within w_peh1000
end type
type sle_findname from singlelineedit within w_peh1000
end type
type cb_1 from commandbutton within w_peh1000
end type
type dw_3 from datawindow within w_peh1000
end type
type cb_2 from commandbutton within w_peh1000
end type
type rr_1 from roundrectangle within w_peh1000
end type
type rr_2 from roundrectangle within w_peh1000
end type
type rr_3 from roundrectangle within w_peh1000
end type
type rr_4 from roundrectangle within w_peh1000
end type
end forward

global type w_peh1000 from w_inherite_multi
string title = "분기별학자금등록"
dw_1 dw_1
dw_2 dw_2
dw_4 dw_4
st_2 st_2
st_3 st_3
sle_find sle_find
dw_cond dw_cond
sle_findname sle_findname
cb_1 cb_1
dw_3 dw_3
cb_2 cb_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_peh1000 w_peh1000

type variables
long ll_rpos , il_old_row 
string sClickedempno,lsbunki,lsyy
string ls_dkdeptcode
int li_level
end variables

forward prototypes
public subroutine cb_check ()
end prototypes

public subroutine cb_check ();string smm, sempno
long   ll_row

dw_2.reset()
dw_4.reset()

dw_1.enabled = true
dw_2.enabled = true
dw_4.enabled = true

lsyy = left(gs_today,4)
smm = mid(gs_today,5,2)

dw_cond.SetItem(1,"yy",lsyy)

IF smm <= '3' then
	lsbunki = '1'
elseif smm <= '6' then
	lsbunki = '2'
elseif smm <= '9' then
	lsbunki = '3'
else
	lsbunki = '4'
end if	

dw_cond.SetItem(1,"bunki",lsbunki)

ll_row = dw_1.GetSelectedRow(0)
IF ll_row > 0 THEN
	sempno = dw_1.GetItemString(ll_row,"empno")	
	dw_2.retrieve(gs_company,lsbunki, lsyy, sempno) 
	dw_4.retrieve(gs_company,lsyy, sempno,'%')
	dw_4.sharedata(dw_3)
	dw_2.setfocus()
ELSE
	dw_1.ScrollToRow(1)
END IF

ib_any_typing = False
	
dw_cond.SetFocus()

sle_msg.text = ""
end subroutine

on w_peh1000.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_4=create dw_4
this.st_2=create st_2
this.st_3=create st_3
this.sle_find=create sle_find
this.dw_cond=create dw_cond
this.sle_findname=create sle_findname
this.cb_1=create cb_1
this.dw_3=create dw_3
this.cb_2=create cb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_find
this.Control[iCurrent+7]=this.dw_cond
this.Control[iCurrent+8]=this.sle_findname
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.dw_3
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_2
this.Control[iCurrent+14]=this.rr_3
this.Control[iCurrent+15]=this.rr_4
end on

on w_peh1000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_find)
destroy(this.dw_cond)
destroy(this.sle_findname)
destroy(this.cb_1)
destroy(this.dw_3)
destroy(this.cb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)

dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)

/////shareData/////////////
long ll_share

ll_share = dw_4.sharedata(dw_3)

if ll_share = -1 then Return
///////////////////////////

string snull ,sname

// 환경변수 근태담당부서 
SELECT dataname
	INTO :ls_dkdeptcode
	FROM p0_syscnfg
	WHERE sysgu = 'P' and serial = 1 and lineno = '1' ;

//부서level check	
SELECT "P0_DEPT"."DEPT_LEVEL"  
  INTO :li_level
  FROM "P0_DEPT"  
 WHERE "P0_DEPT"."DEPTCODE" = :gs_dept   ;
	
IF SQLCA.SQLCODE <> 0 THEN	
	  li_level = 3
END IF	

if gs_dept = ls_dkdeptcode  then
	dw_cond.setitem(dw_cond.getrow(),"deptcode",SetNull(snull))
	dw_cond.modify("deptcode.protect= 0")
else
//	dw_cond.setitem(dw_cond.getrow(),"deptcode",gs_dept)
	dw_cond.modify("deptcode.protect= 1")
	
	/*부서명*/
	SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :gs_dept ); 
	if sqlca.sqlcode <> 0 then
		sname = ''
	else
//		dw_cond.setitem(dw_cond.getrow(),"deptname",sname)
	end if	
	
end if	
if gs_dept = ls_dkdeptcode then
	dw_1.retrieve('%','%')
else
	if li_level = 2  then
		dw_1.retrieve('%','%')
	else
		dw_1.retrieve('%','%')
	end if	
end if
cb_check()

end event

type p_delrow from w_inherite_multi`p_delrow within w_peh1000
boolean visible = false
integer x = 1554
integer y = 2556
boolean enabled = false
end type

type p_addrow from w_inherite_multi`p_addrow within w_peh1000
boolean visible = false
integer x = 1381
integer y = 2556
boolean enabled = false
end type

type p_search from w_inherite_multi`p_search within w_peh1000
boolean visible = false
integer x = 686
integer y = 2556
boolean enabled = false
end type

type p_ins from w_inherite_multi`p_ins within w_peh1000
boolean visible = false
integer x = 1207
integer y = 2556
boolean enabled = false
end type

type p_exit from w_inherite_multi`p_exit within w_peh1000
integer x = 3767
end type

type p_can from w_inherite_multi`p_can within w_peh1000
integer x = 3584
end type

event p_can::clicked;call super::clicked;cb_check()
end event

type p_print from w_inherite_multi`p_print within w_peh1000
boolean visible = false
integer x = 859
integer y = 2556
boolean enabled = false
end type

type p_inq from w_inherite_multi`p_inq within w_peh1000
boolean visible = false
integer x = 1033
integer y = 2556
boolean enabled = false
end type

type p_del from w_inherite_multi`p_del within w_peh1000
boolean visible = false
integer x = 1733
integer y = 2556
boolean enabled = false
end type

type p_mod from w_inherite_multi`p_mod within w_peh1000
integer x = 3401
end type

event p_mod::clicked;call super::clicked;
Int iEmpCnt,k,iCurRow

dw_cond.AcceptText()

lsyy  = dw_cond.GetItemString(1,"yy")
lsbunki = dw_cond.GetItemString(1,"bunki")

IF dw_2.AcceptText() = -1 THEN RETURN

iEmpCnt = dw_2.RowCount()
IF iEmpCnt <=0 THEN 
	MessageBox("확 인","처리할 자료가 없습니다!!")
	Return
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

//기존 학자금 자료 삭제
SetPointer(HourGlass!)
sle_msg.text = '자료 저장 중......'

DELETE FROM "P1_SCHOOLAMT"  
  WHERE ( "P1_SCHOOLAMT"."COMPANYCODE" = :gs_company ) AND  
        ( "P1_SCHOOLAMT"."EMPNO" = :sClickedempno ) AND  
        ( "P1_SCHOOLAMT"."YY" = :lsyy ) AND  
        ( "P1_SCHOOLAMT"."BUNKI" = :lsbunki )   ;
commit ;		

FOR k = 1 TO iEmpCnt
	iCurRow = dw_3.InsertRow(0)
	if dw_2.GetItemnumber(k,"amt") <> 0 then
		dw_3.SetItem(iCurRow,"companycode",	gs_company)
		dw_3.SetItem(iCurRow,"empno",       sClickedempno)
		dw_3.SetItem(iCurRow,"name",        dw_2.GetItemstring(k,"name"))
		dw_3.SetItem(iCurRow,"yy",          dw_cond.GetItemstring(1,"yy"))			
		dw_3.SetItem(iCurRow,"bunki",       dw_cond.GetItemstring(1,"bunki"))			
		dw_3.SetItem(iCurRow,"seq",         dw_2.GetItemNumber(k,"seq"))
		dw_3.SetItem(iCurRow,"schoolgubn",  dw_2.GetItemstring(k,"schoolgubn"))
		dw_3.SetItem(iCurRow,"amt",         dw_2.GetItemDECIMAL(k,"amt"))
		dw_3.SetItem(iCurRow,"jidate",    dw_2.GetItemstring(k,"jidate"))
		dw_3.SetItem(iCurRow,"remk",        dw_2.GetItemstring(k,"remk"))
	end if	
NEXT

IF dw_3.Update() <> 1 THEN
	ROLLBACK;
	ib_any_typing = True

	sle_msg.text = ''
	SetPointer(Arrow!)
	
	Return
END IF

COMMIT;
ib_any_typing =False

SetPointer(Arrow!)
sle_msg.text ="자료를 저장하였습니다!!"

dw_4.setredraw(false)
dw_2.retrieve(gs_company,lsbunki, lsyy, sClickedempno) 
dw_4.retrieve(gs_company,lsyy, sClickedempno,'%') 
dw_4.sharedata(dw_3)
dw_4.setredraw(true)
end event

type dw_insert from w_inherite_multi`dw_insert within w_peh1000
boolean visible = false
integer x = 416
integer y = 2556
boolean enabled = false
end type

type st_window from w_inherite_multi`st_window within w_peh1000
boolean visible = false
integer x = 2514
integer y = 2668
boolean enabled = false
end type

type cb_append from w_inherite_multi`cb_append within w_peh1000
boolean visible = false
integer x = 2455
integer y = 2408
integer taborder = 0
boolean enabled = false
end type

event cb_append::clicked;call super::clicked;long ll_crow

ll_crow = dw_2.insertrow(0)

dw_2.setcolumn(8)
dw_2.setrow(ll_crow)
dw_2.scrolltorow(ll_crow)
dw_2.setfocus()
end event

type cb_exit from w_inherite_multi`cb_exit within w_peh1000
boolean visible = false
integer x = 3163
integer y = 2496
integer width = 750
integer taborder = 110
boolean enabled = false
end type

type cb_update from w_inherite_multi`cb_update within w_peh1000
boolean visible = false
integer x = 1536
integer y = 2496
integer width = 750
integer taborder = 90
boolean enabled = false
end type

event cb_update::clicked;
Int iEmpCnt,k,iCurRow

dw_cond.AcceptText()

lsyy  = dw_cond.GetItemString(1,"yy")
lsbunki = dw_cond.GetItemString(1,"bunki")

IF dw_2.AcceptText() = -1 THEN RETURN

iEmpCnt = dw_2.RowCount()
IF iEmpCnt <=0 THEN 
	MessageBox("확 인","처리할 자료가 없습니다!!")
	Return
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

//기존 학자금 자료 삭제
SetPointer(HourGlass!)
sle_msg.text = '자료 저장 중......'

DELETE FROM "P1_SCHOOLAMT"  
  WHERE ( "P1_SCHOOLAMT"."COMPANYCODE" = :gs_company ) AND  
        ( "P1_SCHOOLAMT"."EMPNO" = :sClickedempno ) AND  
        ( "P1_SCHOOLAMT"."YY" = :lsyy ) AND  
        ( "P1_SCHOOLAMT"."BUNKI" = :lsbunki )   ;
commit ;		

FOR k = 1 TO iEmpCnt
	iCurRow = dw_3.InsertRow(0)
	if dw_2.GetItemnumber(k,"amt") <> 0 then
		dw_3.SetItem(iCurRow,"companycode",	gs_company)
		dw_3.SetItem(iCurRow,"empno",       sClickedempno)
		dw_3.SetItem(iCurRow,"name",        dw_2.GetItemstring(k,"name"))
		dw_3.SetItem(iCurRow,"yy",          dw_cond.GetItemstring(1,"yy"))			
		dw_3.SetItem(iCurRow,"bunki",       dw_cond.GetItemstring(1,"bunki"))			
		dw_3.SetItem(iCurRow,"seq",         dw_2.GetItemNumber(k,"seq"))
		dw_3.SetItem(iCurRow,"schoolgubn",  dw_2.GetItemstring(k,"schoolgubn"))
		dw_3.SetItem(iCurRow,"amt",         dw_2.GetItemDECIMAL(k,"amt"))
		dw_3.SetItem(iCurRow,"jidate",    dw_2.GetItemstring(k,"jidate"))
		dw_3.SetItem(iCurRow,"remk",        dw_2.GetItemstring(k,"remk"))
	end if	
NEXT

IF dw_3.Update() <> 1 THEN
	ROLLBACK;
	ib_any_typing = True

	sle_msg.text = ''
	SetPointer(Arrow!)
	
	Return
END IF

COMMIT;
ib_any_typing =False

SetPointer(Arrow!)
sle_msg.text ="자료를 저장하였습니다!!"

dw_4.setredraw(false)
dw_2.retrieve(gs_company,lsbunki, lsyy, sClickedempno) 
dw_4.retrieve(gs_company,lsyy, sClickedempno,'%') 
dw_4.sharedata(dw_3)
dw_4.setredraw(true)
end event

type cb_insert from w_inherite_multi`cb_insert within w_peh1000
boolean visible = false
integer x = 3205
integer y = 2408
integer taborder = 0
boolean enabled = false
end type

type cb_delete from w_inherite_multi`cb_delete within w_peh1000
boolean visible = false
integer x = 2830
integer y = 2408
integer taborder = 0
boolean enabled = false
end type

event cb_delete::clicked;call super::clicked;integer li_dchk
long ll_crow

ll_crow = dw_2.getrow()

if ll_crow > 0 then
   dw_2.deleterow(ll_crow)
   dw_2.setcolumn(8)
   dw_2.setfocus()
end if

// All Data Delete
if dw_2.rowcount() = 0 then   
   li_dchk = messagebox("삭제 확인", "삭제하시겠습니까 ?", question!, okcancel!)
   if li_dchk = 1 then
		cb_update.triggerevent(clicked!)
  	else
     	cb_cancel.triggerevent(clicked!)
   end if
end if
end event

type cb_retrieve from w_inherite_multi`cb_retrieve within w_peh1000
boolean visible = false
integer x = 1454
integer y = 2436
integer taborder = 0
end type

event cb_retrieve::clicked;call super::clicked;
dw_cond.accepttext()
lsbunki = dw_cond.getitemstring(1,"bunki")
lsyy = dw_cond.getitemstring(1,"yy")

if lsyy = '' or isnull(lsyy) then
	MessageBox("확 인","년도를 입력하십시오!!")
	dw_cond.setcolumn("yy")
	dw_cond.setfocus()
	return
end if	

if lsbunki = '' or isnull(lsbunki) then
	MessageBox("확 인","분기를 입력하십시오!!")
	dw_cond.setcolumn("bunki")
	dw_cond.setfocus()
	return
end if	

if sClickedempno = '' or isnull(sClickedempno) then
	MessageBox("확 인","사원은 선택하십시오!!")
	dw_1.setfocus()
	return
end if	


if dw_2.retrieve(gs_company,lsbunki,lsyy,sClickedempno) < 1 then
	dw_cond.SetFocus()
	return
end if

dw_4.retrieve(gs_company,lsyy,sClickedempno,'%')
dw_4.sharedata(dw_3)
dw_2.setfocus()
end event

type st_1 from w_inherite_multi`st_1 within w_peh1000
boolean visible = false
integer x = 352
integer y = 2668
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_peh1000
boolean visible = false
integer x = 2350
integer y = 2496
integer width = 750
integer taborder = 100
boolean enabled = false
end type

event cb_cancel::clicked;cb_check()
end event

type dw_datetime from w_inherite_multi`dw_datetime within w_peh1000
boolean visible = false
integer x = 3163
integer y = 2668
boolean enabled = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_peh1000
boolean visible = false
integer x = 681
integer y = 2668
boolean enabled = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_peh1000
boolean visible = false
integer x = 1495
integer y = 2444
integer width = 2450
integer height = 180
boolean enabled = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_peh1000
boolean visible = false
integer x = 1417
integer y = 2388
integer width = 430
integer height = 180
boolean enabled = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_peh1000
boolean visible = false
integer x = 357
integer y = 2612
boolean enabled = false
end type

type dw_1 from datawindow within w_peh1000
integer x = 421
integer y = 220
integer width = 1147
integer height = 1820
boolean bringtotop = true
string dataobject = "d_peh1000_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;//dw_1.setrowfocusindicator(hand!)
end event

event clicked;
IF row <=0 THEN RETURN

SelectRow(0,False)
SelectRow(row,True)

sClickedempno = dw_1.getitemstring(row, "empno")

cb_retrieve.triggerevent(clicked!)

end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_peh1000
event u_enter pbm_dwnprocessenter
integer x = 1664
integer y = 328
integer width = 2359
integer height = 532
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_peh1000_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event u_enter;
if dw_2.getcolumnname() = "amt" then
   if dw_2.rowcount() = dw_2.getrow() then
		return 1
	else
		send(handle(this), 256, 9, 0)
	end if
else
	send(handle(this), 256, 9, 0)
end if

return 1
end event

event itemerror;return 1
end event

event itemchanged;string sjidate
long irow

if dw_2.accepttext() = -1 then return

irow = dw_2.getrow()

if dw_2.getcolumnname() = "jidate" then
	sjidate = dw_2.getitemstring(irow,"jidate")
	if sjidate = '' or isnull(sjidate) then
		messagebox('확인','지급일을 확인하세요')
		dw_2.setcolumn("jidate")
		dw_2.setfocus()
		return
	else
		If f_datechk(sjidate) = -1 Then 
			MessageBox("확 인", "유효한 년도가 아닙니다.")	
			dw_2.setcolumn("jidate")
			dw_2.setfocus()
			return
		end if
	end if
END IF
			
end event

type dw_4 from datawindow within w_peh1000
event u_enter pbm_dwnprocessenter
integer x = 1664
integer y = 1104
integer width = 2359
integer height = 944
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_peh1000_5"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;int li_row

IF row <=0 THEN RETURN

if keydown(keyshift!) then             ///shiftkey누르고 선택시
	if il_old_row < row then
		for li_row = il_old_row to row
			selectrow(li_row,true)
		next
	else
		for li_row = il_old_row to row step -1
			selectrow(li_row,true)
		next
	end if
elseif keydown(keycontrol!) then       ///controlkey 누르고 선택시
	selectrow(row,not isselected(row))
else                                   ///하나하나 선택시
	il_old_row = row
	SelectRow(0,False)
	SelectRow(row,True)
end if

end event

type st_2 from statictext within w_peh1000
integer x = 1664
integer y = 936
integer width = 640
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "사원별 지급내역"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_3 from statictext within w_peh1000
integer x = 462
integer y = 76
integer width = 169
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "찾기"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_find from singlelineedit within w_peh1000
integer x = 635
integer y = 64
integer width = 320
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;
long lReturnRow

dw_1.SetRedraw(false)

dw_1.SetSort("empno A")
dw_1.Sort()
dw_1.SetRedraw(true)

IF trim(sle_find.text)= '' OR ISNULL(trim(sle_find.text)) THEN RETURN

lReturnRow = dw_1.Find("empno = '"+ trim(sle_find.text) +"' ", 1, dw_1.RowCount())
if lReturnRow = 0 then	
  messagebox("조회","찾는 사번이 없습니다!")
  return
else
	sClickedempno = dw_1.getitemstring(lReturnRow, "empno")
end if
dw_1.scrolltorow(lReturnRow)
dw_1.setrow(lReturnRow)

dw_1.SelectRow(0,False)
dw_1.SelectRow(lReturnRow,True)


cb_retrieve.triggerevent(clicked!)
end event

type dw_cond from datawindow within w_peh1000
event ue_key pbm_dwnkey
integer x = 1664
integer y = 24
integer width = 1573
integer height = 248
integer taborder = 40
string dataobject = "d_peh1000_4"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;string sName, snull,sDeptno,ls_bunki

setnull(snull)

IF dw_cond.GetColumnName() = "deptcode" THEN
	sDeptno = dw_cond.gettext()	
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_cond.SetITem(1,"deptcode",SNull)
		dw_cond.SetITem(1,"deptname",SNull)
		dw_1.retrieve('%','%')
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_cond.SetITem(1,"deptcode",SNull)
	   dw_cond.SetITem(1,"deptname",SNull) 
		dw_cond.SetColumn("deptcode")
      Return 1
	END IF	
	   dw_cond.SetITem(1,"deptname",sName) 
		dw_1.retrieve(sDeptno,'%')
elseif dw_cond.Getcolumnname()= "bunki" then
	ls_bunki = dw_cond.Gettext()
	if ls_bunki = '1' then
		cb_1.enabled = true
	else
		cb_1.enabled = false
	end if
end if
		
cb_retrieve.triggerevent(clicked!)
end event

event rbuttondown;IF dw_cond.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)


	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_cond.SetITem(1,"deptcode",gs_code)
	dw_cond.SetITem(1,"deptname",gs_codename)
	
	dw_1.retrieve(gs_code,'%')
	
END IF	
end event

type sle_findname from singlelineedit within w_peh1000
integer x = 965
integer y = 64
integer width = 503
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;
long lReturnRow

dw_1.SetRedraw(false)

dw_1.SetSort("empname A")
dw_1.Sort()
dw_1.SetRedraw(true)

IF trim(sle_findname.text)= '' OR ISNULL(trim(sle_findname.text)) THEN RETURN

lReturnRow = dw_1.Find("empname = '"+ trim(sle_findname.text) +"' ", 1, dw_1.RowCount())
if lReturnRow = 0 then		
  messagebox("조회","찾는 성명이 없습니다!")
  return
else
	sClickedempno = dw_1.getitemstring(lReturnRow, "empno")
end if
dw_1.scrolltorow(lReturnRow)
dw_1.setrow(lReturnRow)

dw_1.SelectRow(0,False)
dw_1.SelectRow(lReturnRow,True)

cb_retrieve.triggerevent(clicked!)

end event

type cb_1 from commandbutton within w_peh1000
boolean visible = false
integer x = 3506
integer y = 188
integer width = 311
integer height = 68
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "일괄등록"
end type

event clicked;call super::clicked;
Int iEmpCnt, k, iCurRow, i, lrow, n
string lsschoolgubn

If dw_cond.AcceptText() = -1 then return

lsyy = dw_cond.getitemstring(1, "yy")
lsbunki = dw_cond.GetItemString(1,"bunki")

If dw_2.AcceptText() = -1 Then RETURN


iEmpCnt = dw_2.RowCount()
IF iEmpCnt <= 0 THEN 
	MessageBox("확 인","처리할 자료가 없습니다!!")
	Return
END IF

DELETE FROM "P1_SCHOOLAMT"  
WHERE ( "P1_SCHOOLAMT"."COMPANYCODE" = :gs_company ) AND  
		( "P1_SCHOOLAMT"."EMPNO" = :sClickedempno ) AND  
		( "P1_SCHOOLAMT"."YY" = :lsyy ) AND
		( "P1_SCHOOLAMT"."BUNKI" like '%' );
COMMIT ;	
dw_3.reset()
//기존 학자금 자료 삭제


////////학자금 지급내역 일괄등록...
SetPointer(HourGlass!)
sle_msg.text = '자료 일괄처리 중......'

k = 1

FOR lrow = 1 TO dw_2.rowcount()
	lsschoolgubn = dw_2.getitemstring(lrow, "schoolgubn")

	if dw_2.GetItemnumber(lrow, "amt") <> 0 then

		If lsschoolgubn = '1' then
			dw_3.InsertRow(0)
	
			dw_3.SetItem(k, "companycode",	gs_company)
			dw_3.SetItem(k, "empno",       sClickedempno)
			dw_3.SetItem(k, "name",        dw_2.GetItemstring(lrow, "name"))
			dw_3.SetItem(k, "yy",          dw_cond.GetItemstring(1, "yy"))			
			dw_3.SetItem(k, "bunki",       dw_cond.GetItemstring(1, "bunki"))			
			dw_3.SetItem(k, "seq",         dw_2.GetItemNumber(lrow, "seq"))
			dw_3.SetItem(k, "schoolgubn",  dw_2.GetItemstring(lrow, "schoolgubn"))
			dw_3.SetItem(k, "amt",         dw_2.GetItemnumber(lrow, "amt"))	
		
			k = k + 1
		else
			FOR i = 1 TO 4
				dw_3.InsertRow(0)
			 
				dw_3.SetItem(k, "companycode",	gs_company)
				dw_3.SetItem(k, "empno",       sClickedempno)
			 	dw_3.SetItem(k, "name",        dw_2.GetItemstring(lrow, "name"))
			 	dw_3.SetItem(k, "yy",          dw_cond.GetItemstring(1, "yy"))			
			 	dw_3.SetItem(k, "bunki",       string(i))			
			 	dw_3.SetItem(k, "seq",         dw_2.GetItemNumber(lrow, "seq"))
			 	dw_3.SetItem(k, "schoolgubn",  dw_2.GetItemstring(lrow, "schoolgubn"))
			 	dw_3.SetItem(k, "amt",         dw_2.GetItemnumber(lrow, "amt"))
			
			k = k + 1
			NEXT
			
			
		end if
	end if
NEXT
//////////////////////

IF dw_3.Update() <> 1 THEN
	ROLLBACK;
	ib_any_typing = True
	
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	COMMIT;
	ib_any_typing =False
	
	SetPointer(Arrow!)
	sle_msg.text ="일괄처리 완료!!"
END IF

dw_2.retrieve(gs_company, lsbunki, lsyy, sClickedempno) 
dw_4.retrieve(gs_company, lsyy, sClickedempno,'%')
dw_4.sharedata(dw_3)
end event

type dw_3 from datawindow within w_peh1000
boolean visible = false
integer x = 475
integer y = 2644
integer width = 1408
integer height = 88
boolean bringtotop = true
boolean titlebar = true
string title = "학자금자료등록"
string dataobject = "d_peh1000_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
end type

type cb_2 from commandbutton within w_peh1000
integer x = 3209
integer y = 932
integer width = 800
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "학자금지급삭제"
end type

event clicked;long ll_row, ll_count, ll_i, ll_row1

ll_count = dw_4.rowcount()
ll_row1 = dw_4.getrow()

if ll_count <= 0 then Return
if ll_row1 <= 0 then Return
ll_row = 1

if Messagebox("삭제 확인","삭제하시겠습니까?",Question!,YesNo!) = 2 then Return

dw_4.setredraw(false)

For ll_i = 1 to ll_count 
	if dw_4.isselected(ll_row) then
		if dw_4.deleterow(ll_row) = -1 then Return
	else
		ll_row++
	end if
Next

if dw_4.update() = 1 then
	commit;
	sle_msg.text = "자료가 삭제되었습니다."
else
	rollback;
	f_message_chk(32,"[자료확인]")
end if
dw_4.setredraw(true)
end event

type rr_1 from roundrectangle within w_peh1000
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 407
integer y = 28
integer width = 1161
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_peh1000
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1659
integer y = 316
integer width = 2373
integer height = 552
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_peh1000
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1659
integer y = 1096
integer width = 2373
integer height = 968
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_peh1000
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 407
integer y = 212
integer width = 1170
integer height = 1856
integer cornerheight = 40
integer cornerwidth = 55
end type

