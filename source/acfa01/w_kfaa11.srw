$PBExportHeader$w_kfaa11.srw
$PBExportComments$고정자산 잔고 등록
forward
global type w_kfaa11 from w_inherite
end type
type dw_3 from datawindow within w_kfaa11
end type
type gb_1 from groupbox within w_kfaa11
end type
type pb_2 from picturebutton within w_kfaa11
end type
type pb_3 from picturebutton within w_kfaa11
end type
type pb_4 from picturebutton within w_kfaa11
end type
type pb_5 from picturebutton within w_kfaa11
end type
type dw_cond from u_key_enter within w_kfaa11
end type
type dw_lst from u_d_popup_sort within w_kfaa11
end type
type rr_1 from roundrectangle within w_kfaa11
end type
type dw_1 from u_key_enter within w_kfaa11
end type
end forward

global type w_kfaa11 from w_inherite
string title = "고정자산잔고 등록"
dw_3 dw_3
gb_1 gb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
dw_cond dw_cond
dw_lst dw_lst
rr_1 rr_1
dw_1 dw_1
end type
global w_kfaa11 w_kfaa11

event open;call super::open;STRING DKFYEAR

dw_cond.SetTransobject(sqlca)
dw_cond.Reset()
dw_cond.InsertRow(0)

SELECT "KFA07OM0"."KFYEAR"      INTO :DKFYEAR      FROM "KFA07OM0"  ;

dw_cond.SetItem(1,"kfyear", DKFYEAR)
dw_cond.SetColumn("kfcod1")
dw_cond.Setfocus()

dw_lst.SetTransobject(sqlca)
dw_lst.Reset()

dw_1.SetTransobject(sqlca)
dw_1.Reset()
dw_1.Insertrow(0)



end event

on w_kfaa11.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.gb_1=create gb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.dw_cond=create dw_cond
this.dw_lst=create dw_lst
this.rr_1=create rr_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.pb_5
this.Control[iCurrent+7]=this.dw_cond
this.Control[iCurrent+8]=this.dw_lst
this.Control[iCurrent+9]=this.rr_1
this.Control[iCurrent+10]=this.dw_1
end on

on w_kfaa11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.gb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.dw_cond)
destroy(this.dw_lst)
destroy(this.rr_1)
destroy(this.dw_1)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa11
boolean visible = false
integer x = 101
integer y = 2732
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa11
boolean visible = false
integer x = 3598
integer y = 2800
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfaa11
boolean visible = false
integer x = 3424
integer y = 2800
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfaa11
boolean visible = false
integer x = 2729
integer y = 2800
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfaa11
boolean visible = false
integer x = 3250
integer y = 2800
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfaa11
integer x = 4439
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kfaa11
integer x = 4265
integer taborder = 60
end type

event p_can::clicked;dw_lst.Reset()
dw_lst.SelectRow(0,False)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

dw_cond.SetColumn("kfcod1")
dw_cond.SetFocus()
end event

type p_print from w_inherite`p_print within w_kfaa11
boolean visible = false
integer x = 2903
integer y = 2800
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfaa11
integer x = 3918
integer taborder = 40
end type

event p_inq::clicked;string ls_year, ls_fcod1, DKFYEAR,lsName
long   ll_fcod2, ll_rtn

ll_rtn = dw_1.accepttext()
ls_year   = dw_1.Getitemstring(dw_1.Getrow(),"kfyear")
ls_fcod1  = dw_1.Getitemstring(dw_1.Getrow(),"kfcod1")
ll_fcod2  = dw_1.Getitemnumber(dw_1.Getrow(),"kfcod2")
lsName    = dw_1.Getitemstring(dw_1.Getrow(),"kfname")

dw_1.SetRedraw(False)
if dw_1.retrieve(ls_year, ls_fcod1, ll_fcod2) <= 0 then	
	dw_1.Reset()
   dw_1.Insertrow(0)
	dw_1.SetRedraw(True)
	
	SELECT "KFA07OM0"."KFYEAR"  
      INTO :DKFYEAR  
      FROM "KFA07OM0"  ;
   dw_1.SetItem(dw_1.Getrow(),"kfyear",DKFYEAR)
	dw_1.SetItem(dw_1.Getrow(),"kfcod1", ls_fcod1)
	dw_1.SetItem(dw_1.Getrow(),"kfcod2", ll_fcod2)
	dw_1.SetItem(dw_1.Getrow(),"kfname", lsName)
else
	dw_1.SetRedraw(True)
end if

dw_1.SetColumn("kfamt")
dw_1.Setfocus()
	
ib_any_typing =False
end event

type p_del from w_inherite`p_del within w_kfaa11
boolean visible = false
integer x = 3817
integer y = 2796
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfaa11
integer x = 4091
end type

event p_mod::clicked;call super::clicked;CHAR DKFCOD1
STRING DKFYEAR

setpointer(hourglass!)
DW_1.AcceptText()

/* 계정약칭 */
DKFCOD1  = dw_1.Getitemstring(DW_1.GetRow(),"KFCOD1")

if  DKFCOD1 = "" OR IsNULL(DKFCOD1) then
    sle_msg.text   = "고정자산잔고 수정은 System에서 관리합니다. 필요한 경우만 수정을 하시오."
    Messagebox("확 인","고정자산코드 조회를 실행한 후 하나를 선택하시오.")
    DW_1.setfocus()
    Return
end if

dkfyear = dw_1.GetItemString(DW_1.GetRow(),"kfyear")

if dw_1.Update() = 1 then
//   dw_1.reset()
//   dw_1.Insertrow(0)
//   dw_1.SetItem(dw_1.GetRow(),"kfyear",dkfyear)
   w_mdi_frame.sle_msg.text   = "자료가 수정되었습니다"
   commit using sqlca;
else
   rollback using sqlca;
   messagebox("확 인","고정자산 수정 실패" + sqlca.sqlerrtext) 
   Return
end if
ib_any_typing =False
dw_1.Setfocus()

end event

type cb_exit from w_inherite`cb_exit within w_kfaa11
boolean visible = false
integer x = 3205
integer y = 2568
end type

type cb_mod from w_inherite`cb_mod within w_kfaa11
boolean visible = false
integer x = 2487
integer y = 2564
end type

type cb_ins from w_inherite`cb_ins within w_kfaa11
boolean visible = false
integer x = 1952
integer y = 2872
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfaa11
boolean visible = false
integer x = 2327
integer y = 2872
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kfaa11
boolean visible = false
integer x = 2149
integer y = 2564
end type

type cb_print from w_inherite`cb_print within w_kfaa11
integer x = 1573
integer y = 2868
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfaa11
end type

type cb_can from w_inherite`cb_can within w_kfaa11
boolean visible = false
integer x = 2853
integer y = 2564
boolean cancel = true
end type

type cb_search from w_inherite`cb_search within w_kfaa11
integer x = 1024
integer y = 2864
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfaa11
integer height = 88
end type





type gb_button1 from w_inherite`gb_button1 within w_kfaa11
boolean visible = false
integer x = 91
integer y = 2516
integer width = 443
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa11
boolean visible = false
integer x = 2432
integer y = 2516
integer width = 1157
end type

type dw_3 from datawindow within w_kfaa11
integer x = 192
integer y = 3528
integer width = 3182
integer height = 1684
boolean bringtotop = true
string dataobject = "d_kfaa03"
boolean livescroll = true
end type

type gb_1 from groupbox within w_kfaa11
boolean visible = false
integer x = 2821
integer y = 12
integer width = 457
integer height = 148
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
borderstyle borderstyle = styleraised!
end type

type pb_2 from picturebutton within w_kfaa11
boolean visible = false
integer x = 2853
integer y = 64
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\erpman\image\FIRST.gif"
alignment htextalign = left!
end type

event clicked;string    ls_year, ls_fcod1, DKFYEAR
Double    dMinNo

dw_1.accepttext()
ls_year   = dw_1.Getitemstring(dw_1.Getrow(),"kfyear")
ls_fcod1  = dw_1.Getitemstring(dw_1.Getrow(),"kfcod1")

select Min(kfcod2)		into :dMinNo
	from kfa04om0
	where kfyear = :ls_year and
			kfcod1 = :ls_fcod1 ;
IF sqlca.sqlcode <> 0 THEN
	F_MessageChk(14,'')
	return
ELSE
	if dMinNo <=0 then
		F_MessageChk(14,'')
		return
	end if
END IF

dw_1.SetItem(dw_1.GetRow(),"kfcod2", dMinNo)

p_inq.TriggerEvent(Clicked!)
end event

type pb_3 from picturebutton within w_kfaa11
boolean visible = false
integer x = 2953
integer y = 64
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;string    ls_year, ls_fcod1, DKFYEAR
Double    dCurNo,dKfCod2

dw_1.accepttext()
ls_year   = dw_1.Getitemstring(dw_1.Getrow(),"kfyear")
ls_fcod1  = dw_1.Getitemstring(dw_1.Getrow(),"kfcod1")
dKfCod2   = dw_1.GetitemNumber(dw_1.Getrow(),"kfcod2")

select Max(kfcod2)		into :dCurNo
	from kfa04om0
	where kfyear = :ls_year and
			kfcod1 = :ls_fcod1 and kfcod2 < :dKfCod2 ;
IF sqlca.sqlcode <> 0 THEN
	F_MessageChk(14,'')
	return
ELSE
	if dCurNo <=0 then
		F_MessageChk(14,'')
		return
	end if
END IF

dw_1.SetItem(dw_1.GetRow(),"kfcod2", dCurNo)

p_inq.TriggerEvent(Clicked!)
end event

type pb_4 from picturebutton within w_kfaa11
boolean visible = false
integer x = 3054
integer y = 64
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;string    ls_year, ls_fcod1, DKFYEAR
Double    dCurNo,dKfCod2

dw_1.accepttext()
ls_year   = dw_1.Getitemstring(dw_1.Getrow(),"kfyear")
ls_fcod1  = dw_1.Getitemstring(dw_1.Getrow(),"kfcod1")
dKfCod2   = dw_1.GetitemNumber(dw_1.Getrow(),"kfcod2")

select Min(kfcod2)		into :dCurNo
	from kfa04om0
	where kfyear = :ls_year and
			kfcod1 = :ls_fcod1 and kfcod2 > :dKfCod2 ;
IF sqlca.sqlcode <> 0 THEN
	F_MessageChk(14,'')
	return
ELSE
	if dCurNo <=0 then
		F_MessageChk(14,'')
		return
	end if
END IF

dw_1.SetItem(dw_1.GetRow(),"kfcod2", dCurNo)

p_inq.TriggerEvent(Clicked!)
end event

type pb_5 from picturebutton within w_kfaa11
boolean visible = false
integer x = 3154
integer y = 64
integer width = 82
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\last.gif"
alignment htextalign = left!
end type

event clicked;string    ls_year, ls_fcod1, DKFYEAR
Double    dMaxNo

dw_1.accepttext()
ls_year   = dw_1.Getitemstring(dw_1.Getrow(),"kfyear")
ls_fcod1  = dw_1.Getitemstring(dw_1.Getrow(),"kfcod1")

select Max(kfcod2)		into :dMaxNo
	from kfa04om0
	where kfyear = :ls_year and
			kfcod1 = :ls_fcod1 ;
IF sqlca.sqlcode <> 0 THEN
	F_MessageChk(14,'')
	return
ELSE
	if dMaxNo <=0 then
		F_MessageChk(14,'')
		return
	end if
END IF

dw_1.SetItem(dw_1.GetRow(),"kfcod2", dMaxNo)

p_inq.TriggerEvent(Clicked!)
end event

type dw_cond from u_key_enter within w_kfaa11
integer x = 37
integer y = 60
integer width = 1426
integer height = 220
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfaa111"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;
String  sYear,sKfCod1,sNull

SetNull(sNull)

if this.GetColumnName() = 'kfyear' then
	sYear = this.GetText()
	if sYear = '' or IsNull(sYear) then Return
	
	sKfcod1 = this.GetItemString(this.GetRow(),"kfcod1")
	if sKfcod1 = '' or IsNull(sKfCod1) then Return
	
	dw_lst.SetRedraw(False)
	dw_lst.Retrieve(sYear, sKfCod1)
	dw_lst.SetRedraw(True)
	dw_lst.SelectRow(0,False)
	
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetRedraw(True)
end if

if this.GetColumnName() = 'kfcod1' then
	sKfCod1 = this.GetText()
	if sKfCod1 = '' or IsNull(sKfCod1) then Return
	
	sYear = this.GetItemString(this.GetRow(),"kfyear")
	
	if IsNull(F_Get_Refferance('F1',sKfcod1)) then
		F_MessageChk(20,'[자산구분]')
		this.SetItem(this.GetRow(),"kfcod1", sNull)
		Return 1
	end if
	dw_lst.SetRedraw(False)
	dw_lst.Retrieve(sYear, sKfCod1)
	dw_lst.SetRedraw(True)
	dw_lst.SelectRow(0,False)
	
	dw_1.SetRedraw(False)
	dw_1.Reset()
	dw_1.InsertRow(0)
	dw_1.SetRedraw(True)
	
end if
end event

type dw_lst from u_d_popup_sort within w_kfaa11
integer x = 50
integer y = 292
integer width = 1504
integer height = 1844
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfaa112"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
	b_flag = True
ELSE
	this.SelectRow(0,False)
	this.SelectRow(row,True)

	dw_1.SetRedraw(False)
	if dw_1.Retrieve(dw_cond.GetItemString(1,"kfyear"),this.GetItemString(row,"kfcod1"),this.GetItemNumber(row,"kfcod2")) <=0 then
		dw_1.Reset()
		dw_1.InsertRow(0)
	end if
	dw_1.SetRedraw(True)
	
	b_flag = False
END IF

call super ::clicked
end event

type rr_1 from roundrectangle within w_kfaa11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 284
integer width = 1518
integer height = 1864
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_kfaa11
event ue_key pbm_dwnkey
integer x = 1563
integer y = 292
integer width = 3063
integer height = 1916
integer taborder = 30
string dataobject = "d_kfaa113"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;char dkfcod1
long dkfcod2, row_num, retrieve_row 

SetNull(gs_code)
SetNull(gs_codename)

dw_1.AcceptText()

IF this.GetColumnName() ="kfcod2" THEN 	
	row_num  = dw_1.Getrow()

	dkfcod1 = dw_1.GetItemString( row_num, "kfcod1")
	dkfcod2 = dw_1.GetItemNumber( row_num, "kfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_1.setitem(dw_1.Getrow(),"kfcod1",gs_code)
   dw_1.Setitem(dw_1.Getrow(),"kfcod2",Long(gs_codename))
	dw_1.Setitem(dw_1.Getrow(),"kfname",gs_gubun)
	
	p_inq.TriggerEvent(Clicked!)
END IF

end event

event editchanged;ib_any_typing =True
end event

event itemerror;call super::itemerror;
Return 1
end event

event itemchanged;call super::itemchanged;

if this.GetColumnName() = "kfcod2" then
	if this.GetText() = '' or IsNull(this.GetText()) then Return
	
	p_inq.TriggerEvent(Clicked!)
end if
end event

