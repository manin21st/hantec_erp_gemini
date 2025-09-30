$PBExportHeader$w_kcda01b.srw
$PBExportComments$계정과목별 관리항목 등록
forward
global type w_kcda01b from window
end type
type st_2 from statictext within w_kcda01b
end type
type st_1 from statictext within w_kcda01b
end type
type p_exit from uo_picture within w_kcda01b
end type
type p_mod from uo_picture within w_kcda01b
end type
type p_can from uo_picture within w_kcda01b
end type
type dw_update from datawindow within w_kcda01b
end type
type dw_list from datawindow within w_kcda01b
end type
type dw_ins from datawindow within w_kcda01b
end type
end forward

global type w_kcda01b from window
integer width = 3616
integer height = 1936
boolean titlebar = true
string title = "계정과목별 관리항목 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
st_2 st_2
st_1 st_1
p_exit p_exit
p_mod p_mod
p_can p_can
dw_update dw_update
dw_list dw_list
dw_ins dw_ins
end type
global w_kcda01b w_kcda01b

type variables
String sCurPosition
Long d1_currentrow, d2_currentrow
String sAcc1Cd,sAcc2Cd
Boolean ib_Changed = False
end variables

on w_kcda01b.create
this.st_2=create st_2
this.st_1=create st_1
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_can=create p_can
this.dw_update=create dw_update
this.dw_list=create dw_list
this.dw_ins=create dw_ins
this.Control[]={this.st_2, &
this.st_1, &
this.p_exit, &
this.p_mod, &
this.p_can, &
this.dw_update, &
this.dw_list, &
this.dw_ins}
end on

on w_kcda01b.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_can)
destroy(this.dw_update)
destroy(this.dw_list)
destroy(this.dw_ins)
end on

event open;
String sMsgParm,sAcc1Name,sAcc2Name

f_window_center_Response(this)

dw_ins.SetTransObject(SQLCA)
dw_ins.Reset()
dw_ins.InsertRow(0)

ib_changed = False

sMsgParm = Message.StringParm
sAcc1Cd = Left(sMsgParm,5)
sAcc2Cd = Mid(sMsgParm,6,2)

SELECT "KFZ01OM0"."ACC1_NM", "KFZ01OM0"."ACC2_NM"
	INTO :sAcc1Name, :sAcc2Name
   FROM "KFZ01OM0"
   WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1Cd ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2Cd );

dw_ins.SetItem(1,"acc1_cd",sAcc1Cd)
dw_ins.SetItem(1,"acc2_cd",sAcc2Cd)
dw_ins.SetItem(1,"kfz01om0_acc1_nm",sAcc1Name)
dw_ins.SetItem(1,"kfz01om0_acc2_nm",sAcc2Name)

dw_list.SetTransObject(SQLCA)
dw_update.SetTransObject(SQLCA)
dw_update.Reset()
dw_update.Retrieve(sAcc1Cd,sAcc2Cd,'1')
end event

event resize;
dw_list.width = (this.width / 2) - 100
dw_list.height = this.height - dw_list.y - 120

st_2.x = dw_list.x + dw_list.width + 40
dw_update.x = dw_list.x + dw_list.width + 40
dw_update.width = dw_list.width
dw_update.height = dw_list.height

p_mod.x = this.width - p_mod.width - p_can.width - p_exit.width - 80
p_can.x = this.width - p_can.width - p_exit.width - 60
p_exit.x = this.width - p_exit.width - 40
end event

type st_2 from statictext within w_kcda01b
integer x = 1650
integer y = 276
integer width = 462
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
string text = "등록된 관리항목"
boolean focusrectangle = false
end type

type st_1 from statictext within w_kcda01b
integer x = 87
integer y = 280
integer width = 457
integer height = 52
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
string text = "관리항목"
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_kcda01b
integer x = 3397
integer y = 8
integer width = 178
integer taborder = 50
string picturename = "btn_close_up.gif"
end type

event clicked;
Integer iCount
String  sConFirm

SELECT COUNT(*) INTO :iCount
	FROM "KFZ01OT0"
   WHERE ( "KFZ01OT0"."ACC1_CD" = :sAcc1Cd ) AND ( "KFZ01OT0"."ACC2_CD" = :sAcc2Cd )   ;
IF SQLCA.SQLCODE = 0 AND iCount > 0 THEN
	sConFirm = 'ok'
ELSE
	sConFirm = 'cancel'
END IF

IF ib_Changed = True THEN
	IF MessageBox("확 인","저장되지 않은 자료가 있습니다!~n저장하시겠습니까?",Question!,YesNo!) = 1 THEN
		Return
	END IF
END IF
CloseWithReturn(w_kcda01b,sConFirm)
end event

type p_mod from uo_picture within w_kcda01b
integer x = 3049
integer y = 8
integer width = 178
integer taborder = 30
string picturename = "btn_save_up.gif"
end type

event clicked;
String  sKwanColName
Integer i

IF dw_update.AcceptText() = -1 THEN RETURN

FOR i = 1 TO dw_update.RowCount()
	sKwanColName = dw_update.GetItemString(i,"kwan_colnm")
	IF sKwanColName = "" OR IsNull(sKwanColName) THEN
		f_messagechk(1,'[관리항목명]')
		dw_update.ScrollToRow(i)
		dw_update.SetColumn("kwan_colnm")
		dw_update.SetFocus()
		Return
	END IF
	
	dw_update.SetItem(i,"seq_no",i)
NEXT
IF f_DBconfirm('저장') = -1 THEN RETURN

IF dw_update.Update() = 1 THEN
	commit;
	ib_changed = False
ELSE
	f_messagechk(13,'')
	rollback;
END IF
end event

type p_can from uo_picture within w_kcda01b
integer x = 3223
integer y = 8
integer width = 178
integer taborder = 40
string picturename = "btn_cancel_up.gif"
end type

event clicked;
rollback;
dw_update.Retrieve(sAcc1Cd,sAcc2Cd,dw_ins.GetItemString(1,"dc_gu"))
ib_changed = False
end event

type dw_update from datawindow within w_kcda01b
integer x = 1655
integer y = 332
integer width = 1902
integer height = 1448
integer taborder = 20
string dataobject = "dw_kcda01b_3"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dragdrop;
Integer lrow
String sAcc1,sAcc2,sDcGu,sColumnId

if sCurPosition <> 'dw_list' then	return

sAcc1 = dw_ins.getitemString(1, "acc1_cd")
sAcc2 = dw_ins.getitemString(1, "acc2_cd")
sDcGu = dw_ins.getitemString(1, "dc_gu")

sColumnId = dw_list.getitemstring(d1_currentrow, "kwan_cd")

if this.Find("acc1_cd ='" + sAcc1 + "' and acc2_cd ='" + sAcc2 + "' and dc_gu ='" +sDcGu + "' and kwan_colid = '"+ sColumnId +"'", 1, dw_update.rowcount() ) > 0	then	
	dw_list.SelectRow(0,False)
	return
end if

lrow = this.Insertrow(0)

this.setitem(lrow, "acc1_cd", 	sAcc1)
this.setitem(lrow, "acc2_cd",		sAcc2)
this.setitem(lrow, "dc_gu",	   sDcGu)
this.setitem(lrow, "kwan_colid", dw_list.getitemstring(d1_currentrow, "kwan_cd") ) 
this.setitem(lrow, "kwan_colnm", dw_list.getitemstring(d1_currentrow, "kwan_nm") ) 

IF sColumnId = 'kwan_no2' THEN
	this.SetItem(lRow,"ref_gbn",'8')
END IF

IF dw_list.GetItemString(d1_currentrow,"kwan_type") = '문자' THEN
	this.SetItem(lRow,"kwan_type",'1')	
ELSE
	this.SetItem(lRow,"kwan_type",'0')	
END IF
this.SetItem(lRow,"seq_no",lRow)

this.ScrollToRow(lrow)
this.SetColumn("kwan_colnm")
this.SetFocus()
ib_changed = True
dw_update.SelectRow(0,False)
dw_list.SelectRow(0,False)
end event

event clicked;
sCurPosition = 'dw_update'
d2_CurrentRow = row
if d2_currentrow < 1 then  return
this.drag(begin!)
this.selectrow(0, false)
this.selectrow(d2_currentrow, true)
end event

event itemerror;
Return 1
end event

event itemchanged;
String sCusGbn,snull
SetNull(snull)
this.AcceptText()

IF this.GetColumnName() = "ref_gbn" THEN
	sCusGbn = this.GetText()
	
	IF sCusGbn = "" OR IsNull(sCusGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('CU',sCusGbn)) THEN
		f_messageChk(20,'[참조구분]')
		this.SetItem(this.GetRow(),"ref_gbn",snull)
		Return 1
	ELSE
		IF sCusGbn = '90' OR sCusGbn = '91' THEN			/*프로젝트,현장코드*/
			F_MessageChk(20,'[참조구분]')
			this.SetItem(this.GetRow(),"ref_gbn",snull)
			Return 1	
		END IF
	END IF
END IF
end event

type dw_list from datawindow within w_kcda01b
integer x = 82
integer y = 332
integer width = 1518
integer height = 1448
string dataobject = "dw_kcda01b_2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
sCurPosition = 'dw_list'
d1_CurrentRow = this.getclickedrow()
if d1_currentrow < 1 then  return
this.drag(begin!)
this.selectrow(0, false)
this.selectrow(d1_currentrow, true)
end event

event dragdrop;
if sCurPosition <> 'dw_update' then	return
if d2_currentrow < 1 then	return

dw_update.DeleteRow(d2_currentrow)
dw_update.SelectRow(0,False)
dw_list.SelectRow(0,False)
end event

type dw_ins from datawindow within w_kcda01b
integer x = 55
integer y = 12
integer width = 2267
integer height = 228
integer taborder = 10
string dataobject = "dw_kcda01b_1"
boolean border = false
boolean livescroll = true
end type

event itemerror;
Return 1
end event

event itemchanged;
String sDcGu
this.AcceptText()

IF this.GetColumnName() = 'dc_gu' THEN
	sDcGu = this.GetText()
	dw_update.Retrieve(sAcc1Cd,sAcc2Cd,sDcGu)
END IF
end event
