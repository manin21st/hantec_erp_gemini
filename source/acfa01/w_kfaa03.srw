$PBExportHeader$w_kfaa03.srw
$PBExportComments$고정자산잔고 등록
forward
global type w_kfaa03 from w_inherite
end type
type dw_3 from datawindow within w_kfaa03
end type
type gb_1 from groupbox within w_kfaa03
end type
type dw_1 from u_key_enter within w_kfaa03
end type
type pb_2 from picturebutton within w_kfaa03
end type
type pb_3 from picturebutton within w_kfaa03
end type
type pb_4 from picturebutton within w_kfaa03
end type
type pb_5 from picturebutton within w_kfaa03
end type
end forward

global type w_kfaa03 from w_inherite
string title = "고정자산 잔고 등록"
dw_3 dw_3
gb_1 gb_1
dw_1 dw_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
end type
global w_kfaa03 w_kfaa03

event open;call super::open;STRING DKFYEAR

dw_1.SetTransobject(sqlca)
dw_1.Reset()
dw_1.Insertrow(0)


SELECT "KFA07OM0"."KFYEAR"  
    INTO :DKFYEAR  
    FROM "KFA07OM0"  ;

DW_1.SetItem(dw_1.Getrow(),"KFYEAR",DKFYEAR)
dw_1.SetColumn("kfcod1")
dw_1.Setfocus()

end event

on w_kfaa03.create
int iCurrent
call super::create
this.dw_3=create dw_3
this.gb_1=create gb_1
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_3
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.pb_4
this.Control[iCurrent+7]=this.pb_5
end on

on w_kfaa03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_3)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa03
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa03
boolean visible = false
integer x = 3589
integer y = 2152
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfaa03
boolean visible = false
integer x = 3415
integer y = 2152
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfaa03
boolean visible = false
integer x = 2720
integer y = 2152
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfaa03
boolean visible = false
integer x = 3241
integer y = 2152
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfaa03
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kfaa03
integer taborder = 40
end type

event p_can::clicked;String dkfyear


dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.Insertrow(0)
dw_1.SetRedraw(True)

SELECT "KFA07OM0"."KFYEAR"  
    INTO :DKFYEAR  
    FROM "KFA07OM0"  ;

DW_1.SetItem(dw_1.Getrow(),"KFYEAR",DKFYEAR)
dw_1.SetColumn("kfcod1")
dw_1.Setfocus()

//CHAR   DKFCOD1
//STRING DKFYEAR
//LONG   DKFCOD2, row_num, Retrieve_row
//
//DW_1.AcceptText()
//row_num = dw_1.Getrow()
//
//dkfyear = dw_1.GetItemString(row_num,"kfyear")
//dkfcod1 = dw_1.GetItemString(row_num,"kfcod1")
//dkfcod2 = dw_1.GetItemNumber(row_num,"kfcod2")
//
//if IsNull(dkfyear) then dkfyear = ""
//if IsNull(dkfcod1) then dkfcod1 = ""
//if IsNull(dkfcod2) then dkfcod2 = 0
//
//
//Retrieve_row = dw_1.Retrieve(dkfyear,dkfcod1,dkfcod2)
//
//if Retrieve_row <= 0 then
//   dw_1.Reset()
//   dw_1.InsertRow(0)
//   dw_1.SetFocus()
//   dw_1.SetItem(row_num,"kfyear",DKFYEAR)
//   sle_msg.text = "회기년도, 고정자산코드를 확인하시오."
//   return
//end if
//
//Dw_1.SetFocus()
//sle_msg.text = ""
//ib_any_typing =False
end event

type p_print from w_inherite`p_print within w_kfaa03
boolean visible = false
integer x = 2894
integer y = 2152
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfaa03
integer x = 3922
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

type p_del from w_inherite`p_del within w_kfaa03
boolean visible = false
integer x = 3936
integer y = 2152
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfaa03
integer x = 4096
integer taborder = 30
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
   dw_1.reset()
   dw_1.Insertrow(0)
   dw_1.SetItem(dw_1.GetRow(),"kfyear",dkfyear)
   sle_msg.text   = "자료가 수정되었습니다"
   commit using sqlca;
else
   rollback using sqlca;
   messagebox("확 인","고정자산 수정 실패" + sqlca.sqlerrtext) 
   Return
end if
ib_any_typing =False
dw_1.Setfocus()

end event

type cb_exit from w_inherite`cb_exit within w_kfaa03
boolean visible = false
integer x = 3195
integer y = 1920
end type

type cb_mod from w_inherite`cb_mod within w_kfaa03
boolean visible = false
integer x = 2478
integer y = 1916
end type

type cb_ins from w_inherite`cb_ins within w_kfaa03
boolean visible = false
integer x = 1952
integer y = 2872
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfaa03
boolean visible = false
integer x = 2327
integer y = 2872
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kfaa03
boolean visible = false
integer x = 2139
integer y = 1916
end type

type cb_print from w_inherite`cb_print within w_kfaa03
integer x = 1573
integer y = 2868
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfaa03
end type

type cb_can from w_inherite`cb_can within w_kfaa03
boolean visible = false
integer x = 2843
integer y = 1916
boolean cancel = true
end type

type cb_search from w_inherite`cb_search within w_kfaa03
integer x = 1024
integer y = 2864
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfaa03
integer height = 88
end type





type gb_button1 from w_inherite`gb_button1 within w_kfaa03
boolean visible = false
integer x = 82
integer y = 1868
integer width = 443
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa03
boolean visible = false
integer x = 2423
integer y = 1868
integer width = 1157
end type

type dw_3 from datawindow within w_kfaa03
integer x = 192
integer y = 3528
integer width = 3182
integer height = 1684
boolean bringtotop = true
string dataobject = "d_kfaa03"
boolean livescroll = true
end type

type gb_1 from groupbox within w_kfaa03
integer x = 3447
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

type dw_1 from u_key_enter within w_kfaa03
event ue_key pbm_dwnkey
integer x = 320
integer y = 164
integer width = 3483
integer height = 1760
integer taborder = 20
string dataobject = "d_kfaa03"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
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

type pb_2 from picturebutton within w_kfaa03
integer x = 3479
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

type pb_3 from picturebutton within w_kfaa03
integer x = 3579
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

type pb_4 from picturebutton within w_kfaa03
integer x = 3680
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

type pb_5 from picturebutton within w_kfaa03
integer x = 3781
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

