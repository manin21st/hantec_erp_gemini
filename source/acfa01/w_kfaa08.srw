$PBExportHeader$w_kfaa08.srw
$PBExportComments$감가상각비 계정과목 등록
forward
global type w_kfaa08 from w_inherite
end type
type dw_1 from datawindow within w_kfaa08
end type
type dw_2 from datawindow within w_kfaa08
end type
type st_2 from statictext within w_kfaa08
end type
type st_3 from statictext within w_kfaa08
end type
type rr_1 from roundrectangle within w_kfaa08
end type
end forward

global type w_kfaa08 from w_inherite
string title = "감가상각비 계정과목 등록"
dw_1 dw_1
dw_2 dw_2
st_2 st_2
st_3 st_3
rr_1 rr_1
end type
global w_kfaa08 w_kfaa08

type variables
string smode

end variables

on w_kfaa08.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rr_1
end on

on w_kfaa08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(Sqlca)
dw_1.Reset()
dw_1.InsertRow(0)

dw_2.SetTransObject(Sqlca)
dw_2.Reset()

dw_1.Retrieve()

String ls_aacc1,ls_aacc2,ls_aacc3,ls_cacc1,ls_cacc2,ls_cacc3
Integer totrow,i

totrow = dw_1.Rowcount()
i = dw_1.Getrow()

For i = 1 to totrow

	ls_aacc1 = dw_1.Getitemstring(i, 'aacc1')
	ls_aacc2 = dw_1.Getitemstring(i, 'aacc2')
	ls_aacc3 = dw_1.Getitemstring(i, 'aacc3')
	ls_cacc1 = dw_1.Getitemstring(i, 'cacc1')
	ls_cacc2 = dw_1.Getitemstring(i, 'cacc2')
	ls_cacc3 = dw_1.Getitemstring(i, 'cacc3')

	dw_1.Setitem(i, 'aacc1_nm', ls_aacc1)
	dw_1.Setitem(i, 'aacc2_nm', ls_aacc2)
	dw_1.Setitem(i, 'aacc3_nm', ls_aacc3)
	dw_1.Setitem(i, 'cacc1_nm', ls_cacc1)
	dw_1.Setitem(i, 'cacc2_nm', ls_cacc2)
	dw_1.Setitem(i, 'cacc3_nm', ls_cacc3)
	
Next

dw_1.SetRowFocusIndicator(HAND!)
end event

type dw_insert from w_inherite`dw_insert within w_kfaa08
boolean visible = false
integer x = 0
integer y = 2788
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa08
boolean visible = false
integer x = 4325
integer y = 2908
end type

type p_addrow from w_inherite`p_addrow within w_kfaa08
boolean visible = false
integer x = 4151
integer y = 2908
end type

type p_search from w_inherite`p_search within w_kfaa08
boolean visible = false
integer x = 3456
integer y = 2908
end type

type p_ins from w_inherite`p_ins within w_kfaa08
boolean visible = false
integer x = 3977
integer y = 2908
end type

type p_exit from w_inherite`p_exit within w_kfaa08
end type

type p_can from w_inherite`p_can within w_kfaa08
boolean visible = false
integer x = 3922
integer y = 3132
end type

type p_print from w_inherite`p_print within w_kfaa08
boolean visible = false
integer x = 3630
integer y = 2908
end type

type p_inq from w_inherite`p_inq within w_kfaa08
boolean visible = false
integer x = 3817
integer y = 2924
end type

type p_del from w_inherite`p_del within w_kfaa08
boolean visible = false
integer x = 3749
integer y = 3132
end type

type p_mod from w_inherite`p_mod within w_kfaa08
integer x = 4270
end type

event p_mod::clicked;call super::clicked;String ls_aacc1, ls_aacc2, ls_aacc3, ls_cacc1, ls_cacc2, ls_cacc3, ls_dw1_rfna2, ls_dw1_rfna3, snull
Integer totrow, i

SetNull(snull)

If dw_1.Accepttext() = -1 then Return

totrow = dw_1.Rowcount()
i = dw_1.Getrow()

w_mdi_frame.sle_msg.text = "자료 저장 중 ..."

dw_1.Setredraw(False)

For i = 1 to totrow
	
	ls_aacc1 = dw_1.Getitemstring(i, 'aacc11') + dw_1.Getitemstring(i, 'aacc12')
	ls_aacc2 = dw_1.Getitemstring(i, 'aacc21') + dw_1.Getitemstring(i, 'aacc22')
	ls_aacc3 = dw_1.Getitemstring(i, 'aacc31') + dw_1.Getitemstring(i, 'aacc32')	
	ls_cacc1 = dw_1.Getitemstring(i, 'cacc11') + dw_1.Getitemstring(i, 'cacc12')
	ls_cacc2 = dw_1.Getitemstring(i, 'cacc21') + dw_1.Getitemstring(i, 'cacc22')
	ls_cacc3 = dw_1.Getitemstring(i, 'cacc31') + dw_1.Getitemstring(i, 'cacc32')	
	
	If ls_aacc1 = '' or Isnull(ls_aacc1) then ls_aacc1 = ""
	If ls_aacc2 = '' or Isnull(ls_aacc2) then ls_aacc2 = ""
	If ls_aacc3 = '' or Isnull(ls_aacc3) then ls_aacc3 = ""
	If ls_cacc1 = '' or Isnull(ls_cacc1) then ls_cacc1 = ""
	If ls_cacc2 = '' or Isnull(ls_cacc2) then ls_cacc2 = ""
	If ls_cacc3 = '' or Isnull(ls_cacc3) then ls_cacc3 = ""
	
	ls_dw1_rfna2 = ls_aacc1 + ls_aacc2 + ls_aacc3
	ls_dw1_rfna3 = ls_cacc1 + ls_cacc2 + ls_cacc3
		
	dw_1.Setitem(i, 'rfna2', ls_dw1_rfna2)	
	dw_1.Setitem(i, 'rfna3', ls_dw1_rfna3)

Next

If dw_1.Update() > 0 then
	commit ;
Else
	Rollback ;
	f_messagechk(13, '')
	w_mdi_frame.sle_msg.text = "자료 저장중 에러가 발생하였습니다.!!!"
	Return
End If

ib_any_typing = false

dw_1.Retrieve()

totrow = dw_1.Rowcount()
i = dw_1.Getrow()

For i = 1 to totrow

	ls_aacc1 = dw_1.Getitemstring(i, 'aacc1')
	ls_aacc2 = dw_1.Getitemstring(i, 'aacc2')
	ls_aacc3 = dw_1.Getitemstring(i, 'aacc3')
	ls_cacc1 = dw_1.Getitemstring(i, 'cacc1')
	ls_cacc2 = dw_1.Getitemstring(i, 'cacc2')
	ls_cacc3 = dw_1.Getitemstring(i, 'cacc3')

	dw_1.Setitem(i, 'aacc1_nm', ls_aacc1)
	dw_1.Setitem(i, 'aacc2_nm', ls_aacc2)
	dw_1.Setitem(i, 'aacc3_nm', ls_aacc3)
	dw_1.Setitem(i, 'cacc1_nm', ls_cacc1)
	dw_1.Setitem(i, 'cacc2_nm', ls_cacc2)
	dw_1.Setitem(i, 'cacc3_nm', ls_cacc3)
	
Next

dw_1.Setredraw(True)

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.!!'

dw_1.SetRowFocusIndicator(HAND!)
end event

type cb_exit from w_inherite`cb_exit within w_kfaa08
boolean visible = false
integer x = 3387
integer y = 2664
integer taborder = 40
end type

type cb_mod from w_inherite`cb_mod within w_kfaa08
boolean visible = false
integer x = 3013
integer y = 2672
end type

event cb_mod::clicked;call super::clicked;String ls_aacc1, ls_aacc2, ls_aacc3, ls_cacc1, ls_cacc2, ls_cacc3, ls_dw1_rfna2, ls_dw1_rfna3, snull
Integer totrow, i

SetNull(snull)

If dw_1.Accepttext() = -1 then Return

totrow = dw_1.Rowcount()
i = dw_1.Getrow()

sle_msg.text = "자료 저장 중 ..."

dw_1.Setredraw(False)

For i = 1 to totrow
	
	ls_aacc1 = dw_1.Getitemstring(i, 'aacc11') + dw_1.Getitemstring(i, 'aacc12')
	ls_aacc2 = dw_1.Getitemstring(i, 'aacc21') + dw_1.Getitemstring(i, 'aacc22')
	ls_aacc3 = dw_1.Getitemstring(i, 'aacc31') + dw_1.Getitemstring(i, 'aacc32')	
	ls_cacc1 = dw_1.Getitemstring(i, 'cacc11') + dw_1.Getitemstring(i, 'cacc12')
	ls_cacc2 = dw_1.Getitemstring(i, 'cacc21') + dw_1.Getitemstring(i, 'cacc22')
	ls_cacc3 = dw_1.Getitemstring(i, 'cacc31') + dw_1.Getitemstring(i, 'cacc32')	
	
	If ls_aacc1 = '' or Isnull(ls_aacc1) then ls_aacc1 = ""
	If ls_aacc2 = '' or Isnull(ls_aacc2) then ls_aacc2 = ""
	If ls_aacc3 = '' or Isnull(ls_aacc3) then ls_aacc3 = ""
	If ls_cacc1 = '' or Isnull(ls_cacc1) then ls_cacc1 = ""
	If ls_cacc2 = '' or Isnull(ls_cacc2) then ls_cacc2 = ""
	If ls_cacc3 = '' or Isnull(ls_cacc3) then ls_cacc3 = ""
	
	ls_dw1_rfna2 = ls_aacc1 + ls_aacc2 + ls_aacc3
	ls_dw1_rfna3 = ls_cacc1 + ls_cacc2 + ls_cacc3
		
	dw_1.Setitem(i, 'rfna2', ls_dw1_rfna2)	
	dw_1.Setitem(i, 'rfna3', ls_dw1_rfna3)

Next

If dw_1.Update() > 0 then
	commit ;
Else
	Rollback ;
	f_messagechk(13, '')
	sle_msg.text = "자료 저장중 에러가 발생하였습니다.!!!"
	Return
End If

ib_any_typing = false

dw_1.Retrieve()

totrow = dw_1.Rowcount()
i = dw_1.Getrow()

For i = 1 to totrow

	ls_aacc1 = dw_1.Getitemstring(i, 'aacc1')
	ls_aacc2 = dw_1.Getitemstring(i, 'aacc2')
	ls_aacc3 = dw_1.Getitemstring(i, 'aacc3')
	ls_cacc1 = dw_1.Getitemstring(i, 'cacc1')
	ls_cacc2 = dw_1.Getitemstring(i, 'cacc2')
	ls_cacc3 = dw_1.Getitemstring(i, 'cacc3')

	dw_1.Setitem(i, 'aacc1_nm', ls_aacc1)
	dw_1.Setitem(i, 'aacc2_nm', ls_aacc2)
	dw_1.Setitem(i, 'aacc3_nm', ls_aacc3)
	dw_1.Setitem(i, 'cacc1_nm', ls_cacc1)
	dw_1.Setitem(i, 'cacc2_nm', ls_cacc2)
	dw_1.Setitem(i, 'cacc3_nm', ls_cacc3)
	
Next

dw_1.Setredraw(True)

sle_msg.text = '자료를 저장하였습니다.!!'

dw_1.SetRowFocusIndicator(HAND!)
end event

type cb_ins from w_inherite`cb_ins within w_kfaa08
boolean visible = false
integer x = 407
integer y = 2716
end type

type cb_del from w_inherite`cb_del within w_kfaa08
boolean visible = false
integer x = 1129
integer y = 2716
end type

type cb_inq from w_inherite`cb_inq within w_kfaa08
boolean visible = false
integer x = 1490
integer y = 2716
end type

type cb_print from w_inherite`cb_print within w_kfaa08
boolean visible = false
integer x = 1851
integer y = 2716
end type

type st_1 from w_inherite`st_1 within w_kfaa08
end type

type cb_can from w_inherite`cb_can within w_kfaa08
boolean visible = false
integer x = 2213
integer y = 2716
end type

type cb_search from w_inherite`cb_search within w_kfaa08
boolean visible = false
integer x = 2574
integer y = 2716
end type



type sle_msg from w_inherite`sle_msg within w_kfaa08
long textcolor = 8388608
end type



type gb_button1 from w_inherite`gb_button1 within w_kfaa08
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa08
boolean visible = false
integer x = 2967
integer y = 2616
integer width = 777
end type

type dw_1 from datawindow within w_kfaa08
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 59
integer y = 208
integer width = 4439
integer height = 2052
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfaa08_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this), 256, 9, 0)
Return 1
end event

event ue_key;If keydown(KEYF1!) or keydown(keytab!) then
	TriggerEvent(RbuttonDown!)
End If

end event

event clicked;this.SetRowFocusIndicator(HAND!)

end event

event itemchanged;string ls_aacc11, ls_aacc12, ls_aacc1_nm, ls_aacc21, ls_aacc22, ls_aacc2_nm, ls_aacc31, ls_aacc32, ls_aacc3_nm, snull
string ls_cacc11, ls_cacc12, ls_cacc1_nm, ls_cacc21, ls_cacc22, ls_cacc2_nm, ls_cacc31, ls_cacc32, ls_cacc3_nm

SetNull(snull)

If dw_1.AcceptText() = -1 then return

If dw_1.GetColumnName() = 'aacc11' then
	ls_aacc11 = dw_1.GetText()
	If ls_aacc11 = "" or isnull(ls_aacc11) then
		dw_1.SetItem(row, 'aacc11', snull)
		dw_1.SetItem(row, 'aacc1_nm', snull) 
		Return
	End If
End If

If dw_1.GetColumnName() = 'aacc12' then
	ls_aacc12 = dw_1.GetText()
	ls_aacc11 = dw_1.GetItemString(row, 'aacc11')
	
	If ls_aacc11 = "" or Isnull(ls_aacc11) then
		dw_1.SetItem(row, 'aacc12', snull)
		dw_1.SetItem(row, 'aacc1_nm', snull)
		Return 1
	End If

	  SELECT "KFZ01OM0"."ACC2_NM"  
		 INTO :ls_aacc1_nm  
		 FROM "KFZ01OM0"  
	 WHERE "KFZ01OM0"."ACC1_CD" = :ls_aacc11
	      AND "KFZ01OM0"."ACC2_CD" = :ls_aacc12 ;

//	IF SQLCA.SQLCODE = 100 THEN
//		f_messagechk(20,"자산 계정")
//		dw_1.SetItem(row, 'aacc11', sNull)
//		dw_1.SetItem(row, 'aacc12', snull)
//		dw_1.SetItem(row, 'aacc1_nm', sNull)
//		dw_1.SetColumn('aacc11')
//		dw_1.SetFocus()
//		Return 1
//	End If
	IF SQLCA.SQLCODE = 0 THEN
		dw_1.SetItem(row, 'aacc2_nm', ls_aacc2_nm)
	End if
End If

If dw_1.GetColumnName() = 'aacc21' then
	ls_aacc21 = dw_1.GetText()
	
	If ls_aacc21 = "" or isnull(ls_aacc21) then
		dw_1.SetItem(row, 'aacc22', snull)
		dw_1.SetItem(row, 'aacc2_nm', snull) 
		Return
	End If
	
End If

If dw_1.GetColumnName() = 'aacc22' then
	ls_aacc22 = dw_1.GetText()
	ls_aacc21 = dw_1.GetItemString(row, 'aacc21')
	
	If isnull(ls_aacc21) or ls_aacc21 = "" then
		dw_1.SetItem(row, 'aacc21', snull)
		Return 1
	End If
	
	SELECT "KFZ01OM0"."ACC2_NM"
	INTO :ls_aacc2_nm
	FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD" =:ls_aacc21
	     AND "KFZ01OM0"."ACC2_CD" = :ls_aacc22 ;
		  
//  	If sqlca.sqlcode = 100 then
//		f_messagechk(20, "상각누계액계정")
//		dw_1.SetItem(row, 'aacc21', snull)
//		dw_1.SetItem(row, 'aacc22', snull)
//		dw_1.SetItem(row, 'aacc2_nm', snull)
//		dw_1.SetColumn('aacc21')
//		dw_1.SetFocus()
//		Return 1
//	End If
	IF SQLCA.SQLCODE = 0 THEN
		dw_1.SetItem(row, 'aacc2_nm', ls_aacc2_nm)
	End if
End If

If dw_1.GetColumnName() = 'aacc31' then
	ls_aacc31 = dw_1.GetText()
	
	If ls_aacc31 = "" or isnull(ls_aacc31) then
		dw_1.SetItem(row, 'aacc32', snull)
		dw_1.SetItem(row, 'aacc3_nm', snull) 
		Return
	End If
	
End If

If dw_1.GetColumnName() = 'aacc32' then
	ls_aacc32 = dw_1.GetText()
	ls_aacc31 = dw_1.GetItemString(row, 'aacc31')
	
	If isnull(ls_aacc31) or ls_aacc31 = "" then
		dw_1.SetItem(row, 'aacc32', snull)
		Return 1
	End If
	
	SELECT "KFZ01OM0"."ACC2_NM"
	INTO :ls_aacc3_nm
	FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD" = :ls_aacc31
	  AND "KFZ01OM0"."ACC2_CD" = :ls_aacc32 ;
		  
//  	If sqlca.sqlcode <> 0 then
//		f_messagechk(20, "국고보조계정")
//		dw_1.SetItem(row, 'aacc31', snull)
//		dw_1.SetItem(row, 'aacc32', snull)
//		dw_1.SetItem(row, 'aacc3_nm', snull)
//		dw_1.SetColumn('aacc31')
//		dw_1.SetFocus()
//		Return 1
//	End If
	IF SQLCA.SQLCODE = 0 THEN
		dw_1.SetItem(row, 'aacc3_nm', ls_aacc3_nm)
	End if
End If

If dw_1.GetColumnName() = 'cacc11' then
	ls_cacc11 = dw_1.GetText()
	If ls_cacc11 = "" or isnull(ls_cacc11) then
		dw_1.SetItem(row, 'cacc11', snull)
		dw_1.SetItem(row, 'cacc1_nm', snull) 
		Return
	End If
End If

If dw_1.GetColumnName() = 'cacc12' then
	ls_cacc12 = dw_1.GetText()
	ls_cacc11 = dw_1.GetItemString(row, 'cacc11')
	
	If ls_cacc11 = "" or Isnull(ls_cacc11) then
		dw_1.SetItem(row, 'cacc12', snull)
		dw_1.SetItem(row, 'cacc1_nm', snull)
		Return 1
	End If

	  SELECT "KFZ01OM0"."ACC2_NM"  
		 INTO :ls_cacc1_nm  
		 FROM "KFZ01OM0"  
	 WHERE "KFZ01OM0"."ACC1_CD" = :ls_cacc11
	      AND "KFZ01OM0"."ACC2_CD" = :ls_cacc12 ;

//	IF SQLCA.SQLCODE = 100 THEN
//		f_messagechk(20,"제)감가상각비")
//		dw_1.SetItem(row, 'cacc11', sNull)
//		dw_1.SetItem(row, 'cacc12', snull)
//		dw_1.SetItem(row, 'cacc1_nm', sNull)
//		dw_1.SetColumn('cacc11')
//		dw_1.SetFocus()
//		Return 1
//	End If
	IF SQLCA.SQLCODE = 0 THEN
		dw_1.SetItem(row, 'cacc1_nm', ls_cacc1_nm)
	End if
End If

If dw_1.GetColumnName() = 'cacc21' then
	ls_cacc21 = dw_1.GetText()
	
	If ls_cacc21 = "" or isnull(ls_cacc21) then
		dw_1.SetItem(row, 'cacc22', snull)
		dw_1.SetItem(row, 'cacc2_nm', snull) 
		Return
	End If
	
End If

If dw_1.GetColumnName() = 'cacc22' then
	ls_cacc22 = dw_1.GetText()
	ls_cacc21 = dw_1.GetItemString(row, 'cacc21')
	
	If isnull(ls_cacc21) or ls_cacc21 = "" then
		dw_1.SetItem(row, 'cacc21', snull)
		Return 1
	End If
	
	SELECT "KFZ01OM0"."ACC2_NM"
	INTO :ls_cacc2_nm
	FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD" =:ls_cacc21
	     AND "KFZ01OM0"."ACC2_CD" = :ls_cacc22 ;
		  
//  	If sqlca.sqlcode = 100 then
//		f_messagechk(20, "판)감가상각비")
//		dw_1.SetItem(row, 'cacc21', snull)
//		dw_1.SetItem(row, 'cacc22', snull)
//		dw_1.SetItem(row, 'cacc2_nm', snull)
//		dw_1.SetColumn('cacc21')
//		dw_1.SetFocus()
//		Return 1
//	End If
	IF SQLCA.SQLCODE = 0 THEN
		dw_1.SetItem(row, 'cacc2_nm', ls_cacc2_nm)
	End if
End If

If dw_1.GetColumnName() = 'cacc31' then
	ls_cacc31 = dw_1.GetText()
	
	If ls_cacc31 = "" or isnull(ls_cacc31) then
		dw_1.SetItem(row, 'cacc32', snull)
		dw_1.SetItem(row, 'cacc3_nm', snull) 
		Return
	End If
	
End If

If dw_1.GetColumnName() = 'cacc32' then
	ls_cacc32 = dw_1.GetText()
	ls_cacc31 = dw_1.GetItemString(row, 'cacc31')
	
	If isnull(ls_cacc31) or ls_cacc31 = "" then
		dw_1.SetItem(row, 'cacc32', snull)
		Return 1
	End If
	
	SELECT "KFZ01OM0"."ACC2_NM"
	INTO :ls_cacc3_nm
	FROM "KFZ01OM0"
	WHERE "KFZ01OM0"."ACC1_CD" = :ls_cacc31
	  AND "KFZ01OM0"."ACC2_CD" = :ls_cacc32 ;
		  
//  	If sqlca.sqlcode <> 0 then
//		f_messagechk(20, "연)감가상각비")
//		dw_1.SetItem(row, 'cacc31', snull)
//		dw_1.SetItem(row, 'cacc32', snull)
//		dw_1.SetItem(row, 'cacc3_nm', snull)
//		dw_1.SetColumn('cacc31')
//		dw_1.SetFocus()
//		Return 1
//	End If
	IF SQLCA.SQLCODE = 0 THEN
		dw_1.SetItem(row, 'cacc3_nm', ls_cacc3_nm)
	End if
End If

end event

event losefocus;this.SetRowFocusIndicator(OFF!)
end event

event rbuttondown;String ls_aacc11, ls_aacc12, ls_aacc1_nm, &
       ls_aacc21, ls_aacc22, ls_aacc2_nm, &
		 ls_aacc31, ls_aacc32, ls_aacc3_nm, snull
String ls_cacc11, ls_cacc12, ls_cacc1_nm, &
       ls_cacc21, ls_cacc22, ls_cacc2_nm, &
		 ls_cacc31, ls_cacc32, ls_cacc3_nm
Long ll_row

w_mdi_frame.sle_msg.text = ""

SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)
SetNull(lstr_account.acc2_nm)

If dw_1.AcceptText() = -1 then Return

ll_row = dw_1.Getrow()

If dw_1.GetColumnName() = 'aacc11' or dw_1.GetColumnName() = 'aacc12' then
		
	ls_aacc11 = dw_1.GetItemString(ll_row, 'aacc11')
	ls_aacc12 = dw_1.GetItemString(ll_row, 'aacc12')
	
	If isnull(ls_aacc11) then
		ls_aacc11 = ""
	End If
	
	If isnull(ls_aacc12) then
		ls_aacc12 = ""
	End If
		
	lstr_account.acc1_cd = Trim(ls_aacc11)
	lstr_account.acc2_cd = Trim(ls_aacc12)
	
	Open(w_kfz01om0_popup)
	
	dw_1.SetItem(ll_row, 'aacc11', lstr_account.acc1_cd)
	dw_1.SetItem(ll_row, 'aacc12', lstr_account.acc2_cd)
	dw_1.SetItem(ll_row, 'aacc1_nm', lstr_account.acc2_nm)
	
	dw_1.Setfocus()
	this.SetRowFocusIndicator(HAND!)
	
	Return
END IF

If dw_1.GetColumnName() = 'aacc21' or dw_1.GetColumnName() = 'aacc22' then
		
	ls_aacc21 = dw_1.GetItemString(ll_row, 'aacc21')
	ls_aacc22 = dw_1.GetItemString(ll_row, 'aacc22')
	
	If isnull(ls_aacc21) then
		ls_aacc21 = ""
	End If
	
	If isnull(ls_aacc22) then
		ls_aacc22 = ""
	End If
		
	lstr_account.acc1_cd = Trim(ls_aacc21)
	lstr_account.acc2_cd = Trim(ls_aacc22)
	
	Open(w_kfz01om0_popup)
	
	dw_1.SetItem(ll_row, 'aacc21', lstr_account.acc1_cd)
	dw_1.SetItem(ll_row, 'aacc22', lstr_account.acc2_cd)
	dw_1.SetItem(ll_row, 'aacc2_nm', lstr_account.acc2_nm)
	
	dw_1.Setfocus()
	this.SetRowFocusIndicator(HAND!)
	
	Return
END IF

If dw_1.GetColumnName() = 'aacc31' or dw_1.GetColumnName() = 'aacc32' then
		
	ls_aacc31 = dw_1.GetItemString(ll_row, 'aacc31')
	ls_aacc32 = dw_1.GetItemString(ll_row, 'aacc32')
	
	If isnull(ls_aacc31) then
		ls_aacc31 = ""
	End If
	
	If isnull(ls_aacc32) then
		ls_aacc32 = ""
	End If
		
	lstr_account.acc1_cd = Trim(ls_aacc31)
	lstr_account.acc2_cd = Trim(ls_aacc32)
	
	Open(w_kfz01om0_popup)
	
	dw_1.SetItem(ll_row, 'aacc31', lstr_account.acc1_cd)
	dw_1.SetItem(ll_row, 'aacc32', lstr_account.acc2_cd)
	dw_1.SetItem(ll_row, 'aacc3_nm', lstr_account.acc2_nm)
	
	dw_1.Setfocus()
	this.SetRowFocusIndicator(HAND!)
	
	Return
END IF

If dw_1.GetColumnName() = 'cacc11' or dw_1.GetColumnName() = 'cacc12' then
		
	ls_cacc11 = dw_1.GetItemString(ll_row, 'cacc11')
	ls_cacc12 = dw_1.GetItemString(ll_row, 'cacc12')
	
	If isnull(ls_cacc11) then
		ls_cacc11 = ""
	End If
	
	If isnull(ls_cacc12) then
		ls_cacc12 = ""
	End If
		
	lstr_account.acc1_cd = Trim(ls_cacc11)
	lstr_account.acc2_cd = Trim(ls_cacc12)
	
	Open(w_kfz01om0_popup)
	
	dw_1.SetItem(ll_row, 'cacc11', lstr_account.acc1_cd)
	dw_1.SetItem(ll_row, 'cacc12', lstr_account.acc2_cd)
	dw_1.SetItem(ll_row, 'cacc1_nm', lstr_account.acc2_nm)
	
	dw_1.Setfocus()
	this.SetRowFocusIndicator(HAND!)
	
	Return
END IF

If dw_1.GetColumnName() = 'cacc21' or dw_1.GetColumnName() = 'cacc22' then
		
	ls_cacc11 = dw_1.GetItemString(ll_row, 'cacc21')
	ls_cacc12 = dw_1.GetItemString(ll_row, 'cacc22')
	
	If isnull(ls_cacc21) then
		ls_cacc21 = ""
	End If
	
	If isnull(ls_cacc22) then
		ls_cacc22 = ""
	End If
		
	lstr_account.acc1_cd = Trim(ls_cacc21)
	lstr_account.acc2_cd = Trim(ls_cacc22)
	
	Open(w_kfz01om0_popup)
	
	dw_1.SetItem(ll_row, 'cacc21', lstr_account.acc1_cd)
	dw_1.SetItem(ll_row, 'cacc22', lstr_account.acc2_cd)
	dw_1.SetItem(ll_row, 'cacc2_nm', lstr_account.acc2_nm)
	
	dw_1.Setfocus()
	this.SetRowFocusIndicator(HAND!)
	
	Return
END IF

If dw_1.GetColumnName() = 'cacc31' or dw_1.GetColumnName() = 'cacc32' then
		
	ls_cacc31 = dw_1.GetItemString(ll_row, 'cacc31')
	ls_cacc32 = dw_1.GetItemString(ll_row, 'cacc32')
	
	If isnull(ls_cacc31) then
		ls_cacc31 = ""
	End If
	
	If isnull(ls_cacc32) then
		ls_cacc32 = ""
	End If
		
	lstr_account.acc1_cd = Trim(ls_cacc31)
	lstr_account.acc2_cd = Trim(ls_cacc32)
	
	Open(w_kfz01om0_popup)
	
	dw_1.SetItem(ll_row, 'cacc31', lstr_account.acc1_cd)
	dw_1.SetItem(ll_row, 'cacc32', lstr_account.acc2_cd)
	dw_1.SetItem(ll_row, 'cacc3_nm', lstr_account.acc2_nm)
	
	dw_1.Setfocus()
	this.SetRowFocusIndicator(HAND!)
	
	Return
END IF

end event

event itemerror;Return 1
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="acc1_nm" OR dwo.name ="acc2_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event editchanged;ib_any_typing =True
end event

type dw_2 from datawindow within w_kfaa08
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
boolean visible = false
integer y = 2396
integer width = 3529
integer height = 420
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfaa08_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(handle(this), 256, 9, 0)
Return 1
end event

event ue_key;If keydown(KEYF1!) then
	TriggerEvent(RbuttonDown!)
End If

end event

event clicked;this.SetRowFocusIndicator(HAND!)
end event

event losefocus;this.SetRowFocusIndicator(OFF!)
end event

event rbuttondown;String ls_acc1, ls_acc2, ls_accnm, ls_sacc1, ls_sacc2, ls_saccnm, snull

SetNull(snull)

If dw_2.Accepttext() = -1 then Return

If dw_2.Getcolumnname() = 'acc1' or dw_2.Getcolumnname() = 'acc2' then
	ls_acc1 = dw_2.Gettext()
	ls_acc2 = dw_2.GetItemString(row, 'acc2')
	
	If Isnull(ls_acc1) then
		ls_acc1 = "" 
	End If
	If Isnull(ls_acc2) then
		ls_acc2 = ""
	End If
	
	lstr_account.acc1_cd = Trim(ls_acc1)
	lstr_account.acc2_cd = Trim(ls_acc2)
	
	Open(w_kfz01om0_popup)
	
	dw_2.SetItem(row, 'acc1', lstr_account.acc1_cd)
	dw_2.SetItem(row, 'acc2', lstr_account.acc2_cd)
	dw_2.SetItem(row, 'acc2_nm', lstr_account.acc2_nm)
	
	dw_2.SetFocus()
	this.SetRowFocusIndicator(HAND!)
	
End If


end event

event itemerror;Return 1
end event

event editchanged;ib_any_typing = True
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="acc1_nm" OR dwo.name ="acc2_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event itemchanged;string ls_acc1, ls_acc2, ls_acc2_nm, ls_sacc1, ls_sacc2, ls_sacc2_nm, snull

SetNull(snull)

If dw_2.Accepttext() = -1 then return

If dw_2.Getcolumnname() = 'acc1' then
	ls_acc1 = dw_2.GetText()
	
	If ls_acc1 = "" or isnull(ls_acc1) then
		dw_2.SetItem(row, 'acc2', snull)
		dw_2.SetItem(row, 'acc2_nm', snull)
		Return 
	End If
End If

If dw_2.GetColumnName() = 'acc2' then
	ls_acc2 = dw_2.GetText()
	ls_acc1 = dw_2.GetItemString(row, 'acc1')
	
	If ls_acc1 = "" or Isnull(ls_acc1) then
		dw_2.SetItem(row, 'acc2', snull)
		Return 1
	End If

	  SELECT "KFZ01OM0"."ACC2_NM"  
		 INTO :ls_acc2_nm  
		 FROM "KFZ01OM0"  
	 WHERE "KFZ01OM0"."ACC1_CD" = :ls_acc1
	      AND "KFZ01OM0"."ACC2_CD" = :ls_acc2 ;

	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"비용계정")
		dw_2.SetItem(row, 'acc1', sNull)
		dw_2.SetItem(row, 'acc2', snull)
		dw_2.SetItem(row, 'acc2_nm', sNull)
		dw_2.SetColumn('acc1')
		dw_2.SetFocus()
		Return 1
	End If
	dw_2.SetItem(row, 'acc2_nm', ls_acc2_nm)
End If


end event

type st_2 from statictext within w_kfaa08
boolean visible = false
integer x = 50
integer y = 2480
integer width = 3529
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "  비용계정 등록"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_kfaa08
integer x = 27
integer y = 100
integer width = 3922
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 12639424
long backcolor = 28144969
boolean enabled = false
string text = "  자산부채계정 / 비용계정 등록"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfaa08
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 4485
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 46
end type

