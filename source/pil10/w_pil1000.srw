$PBExportHeader$w_pil1000.srw
$PBExportComments$**종업원대여금기본자료입력
forward
global type w_pil1000 from w_inherite_standard
end type
type dw_main from u_key_enter within w_pil1000
end type
type pb_1 from picturebutton within w_pil1000
end type
type pb_2 from picturebutton within w_pil1000
end type
type pb_3 from picturebutton within w_pil1000
end type
type pb_4 from picturebutton within w_pil1000
end type
type cb_1 from commandbutton within w_pil1000
end type
type cb_2 from commandbutton within w_pil1000
end type
type dw_emp from datawindow within w_pil1000
end type
type p_plancre from uo_picture within w_pil1000
end type
type p_planmod from uo_picture within w_pil1000
end type
type gb_5 from groupbox within w_pil1000
end type
end forward

global type w_pil1000 from w_inherite_standard
string title = "대여금기초자료등록"
dw_main dw_main
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
cb_1 cb_1
cb_2 cb_2
dw_emp dw_emp
p_plancre p_plancre
p_planmod p_planmod
gb_5 gb_5
end type
global w_pil1000 w_pil1000

type variables

end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
end prototypes

public function integer wf_required_check (integer ll_row);String sempno,slendate,sfr_lend,sto_lend,sgubn
int slendamt 
	

dw_main.AcceptText()
dw_emp.AcceptText()

sempno    = dw_emp.GetItemString(1, "empno")
sgubn    = dw_emp.GetItemString(1, "gubn")

slendate          = dw_main.GetItemString(1, "lenddate")
sfr_lend          = dw_main.GetItemString(1, "fr_lend")
slendamt          = dw_main.GetItemnumber(1, "lendamt")

IF sgubn ="" OR IsNull(sgubn) THEN
	MessageBox("확 인","대출구분을 입력하십시요!!")
	dw_emp.SetColumn("gubn")
	dw_emp.SetFocus()
	Return -1
END IF

IF sempno ="" OR IsNull(sempno) THEN
	MessageBox("확 인","사번을 입력하십시요!!")
	dw_emp.SetColumn("empno")
	dw_emp.SetFocus()
	Return -1
END IF

IF f_datechk(slendate) = -1 THEN
		MessageBox("확 인","대출일자를 확인하십시요!!")
		dw_main.SetColumn("lenddate")
		dw_emp.SetFocus()
	Return -1
END IF

IF f_datechk(sfr_lend + "01" ) = -1 THEN
	MessageBox("확 인","대출기간From을 확인하십시요!!")
	dw_main.SetColumn("sfr_lend")
	dw_emp.SetFocus()
	Return -1
END IF

IF slendamt = 0 OR IsNull(slendamt) THEN
	MessageBox("확 인","대출금액을 입력하십시요!!")
	dw_main.SetColumn("lendamt")
	Return -1
END IF

Return 1
end function

on w_pil1000.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_emp=create dw_emp
this.p_plancre=create p_plancre
this.p_planmod=create p_planmod
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.dw_emp
this.Control[iCurrent+9]=this.p_plancre
this.Control[iCurrent+10]=this.p_planmod
this.Control[iCurrent+11]=this.gb_5
end on

on w_pil1000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_emp)
destroy(this.p_plancre)
destroy(this.p_planmod)
destroy(this.gb_5)
end on

event open;call super::open;
dw_emp.SetTransObject(SQLCA)
dw_emp.Reset()
dw_emp.Insertrow(0)
dw_emp.SetColumn("empno")
dw_emp.setitem(1,"gubn",'1')
dw_emp.Setfocus()

pb_1.picturename = "C:\erpman\Image\first.gif"
pb_2.picturename = "C:\erpman\Image\next.gif"
pb_3.picturename = "C:\erpman\Image\prior.gif"
pb_4.picturename = "C:\erpman\Image\last.gif"


dw_main.SetTransObject(SQLCA)
dw_main.Reset()
dw_main.Insertrow(0)

p_plancre.Enabled = FALSE
p_plancre.picturename = "C:\erpman\Image\상환계획작성_d.gif"
p_planmod.Enabled = FALSE
p_planmod.picturename = "C:\erpman\Image\상환계획수정_d.gif"
end event

type p_mod from w_inherite_standard`p_mod within w_pil1000
integer taborder = 100
end type

event p_mod::clicked;call super::clicked;Int il_currow
string sgubn,sempno

dw_emp.Accepttext()
sgubn = dw_emp.getitemstring(1,"gubn")
sempno = dw_emp.getitemstring(1,"empno")

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
END IF

dw_main.setitem(1,"lendgubn",sgubn)
dw_main.setitem(1,"empno",sempno)

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	
IF dw_main.Update() > 0 THEN			
	
	COMMIT USING sqlca;
	ib_any_typing =False
	
	dw_main.SetItem(dw_main.GetRow(),'arg_flag','R')
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF
dw_emp.setcolumn("empno")
dw_emp.Setfocus()

p_plancre.Enabled = TRUE
p_plancre.picturename = "C:\erpman\Image\상환계획작성_up.gif"
p_planmod.Enabled = TRUE
p_planmod.picturename = "C:\erpman\Image\상환계획수정_up.gif"
end event

type p_del from w_inherite_standard`p_del within w_pil1000
integer taborder = 120
end type

event p_del::clicked;call super::clicked;Int il_currow, Total_Count
string sempno , sgubn

dw_main.SetRedraw(False)

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

dw_emp.AcceptText()
sempno    = dw_main.GetItemString(1, "empno")
sgubn    = dw_main.GetItemString(1, "lendgubn")

//상환내역자료 존재check
  SELECT count(*)  
    INTO :Total_Count 
    FROM "P3_LENDREST"  
   WHERE "P3_LENDREST"."EMPNO" = :sempno  and
			"P3_LENDREST"."LENDGUBN" = :sgubn ;
	
IF Total_Count = 0 OR IsNull(Total_Count) Then	
	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
ELSE
	IF MessageBox("확인", "상환자료가 존재합니다 전체삭제하시겠습까", question!, yesno!) = 2	THEN return  
END IF	

	
dw_main.DeleteRow(il_currow)
	
IF dw_main.Update() > 0 THEN
	
	DELETE FROM "P3_LENDSCH"  
   WHERE "P3_LENDSCH"."EMPNO" = :sempno  and
			"P3_LENDSCH"."LENDGUBN" = :sgubn ;
			
   DELETE FROM "P3_LENDREST"  
   WHERE  "P3_LENDREST"."EMPNO" = :sempno  AND  
          "P3_LENDREST"."LENDGUBN" = :sgubn ;

	
	commit;
	p_ins.TriggerEvent(Clicked!)
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF
dw_emp.setcolumn("empno")
dw_emp.setfocus()
dw_emp.SetRedraw(True)
end event

type p_inq from w_inherite_standard`p_inq within w_pil1000
integer x = 2976
end type

event p_inq::clicked;call super::clicked;String 	sEmpNo,sEmpName,sColumnName,sgubn
Int il_RowCount

dw_emp.AcceptText()
sempno   = dw_emp.GetItemString(1,"empno")
sempname = dw_emp.GetItemString(1,"empname") 
sgubn = dw_emp.GetItemString(1,"gubn") 

IF IsNull(sempno) OR sempno ="" THEN 
	sempno =""
ELSE
	sColumnName = "empno"
	IF IsNull(wf_exiting_data(sColumnName,sempno,"0")) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF IsNull(sempname) OR sempname ="" THEN 
	sempname =""	
ELSE
	sColumnName = "empname"
	sempno = wf_exiting_data(sColumnName,sempname,"0")
	IF IsNull(sempno) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF sempno ="" AND sempname ="" THEN
	MessageBox("확 인","조회할 조건을 입력하십시요!!")
	dw_emp.SetColumn("empno")
	dw_emp.SetFocus()
	Return  
END IF


dw_main.SetRedraw(False)		
IF dw_main.Retrieve(sempno,sgubn) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
//	cb_cancel.TriggerEvent(Clicked!)
	dw_main.Reset()
	dw_main.InsertRow(0)
	w_mdi_frame.sle_msg.text =""
	p_plancre.Enabled = FALSE
	p_plancre.picturename = "C:\erpman\Image\상환계획작성_d.gif"
	p_planmod.Enabled = FALSE
	p_planmod.picturename = "C:\erpman\Image\상환계획수정_d.gif"
ELSE
	dw_main.SetItem(dw_main.GetRow(),'arg_flag','R')
	dw_main.SetColumn("lenddate")
	dw_main.setfocus()
	w_mdi_frame.sle_msg.text ="조 회"
	p_plancre.Enabled = TRUE
	p_plancre.picturename = "C:\erpman\Image\상환계획작성_up.gif"
	p_planmod.Enabled = TRUE
	p_planmod.picturename = "C:\erpman\Image\상환계획수정_up.gif"
END IF

dw_main.SetRedraw(True)
end event

type p_print from w_inherite_standard`p_print within w_pil1000
boolean visible = false
integer x = 3927
integer y = 2672
integer taborder = 230
end type

type p_can from w_inherite_standard`p_can within w_pil1000
integer taborder = 140
end type

event p_can::clicked;call super::clicked;Int il_currow,il_insrow

ib_any_typing = False

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.setitem(1,"gubn",'1')
dw_emp.Setcolumn("empno")

dw_emp.SetFocus()


dw_main.Reset()
dw_main.InsertRow(0)

dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)		

p_plancre.Enabled = FALSE
p_plancre.picturename = "C:\erpman\Image\상환계획작성_d.gif"
p_planmod.Enabled = FALSE
p_planmod.picturename = "C:\erpman\Image\상환계획수정_d.gif"
end event

type p_exit from w_inherite_standard`p_exit within w_pil1000
integer taborder = 170
end type

type p_ins from w_inherite_standard`p_ins within w_pil1000
integer x = 3150
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_insrow

il_currow = dw_main.GetRow()
	
IF il_currow > 0 THEN
	IF wf_required_check(il_currow) <> 1 THEN RETURN
END IF

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.Setcolumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.InsertRow(0)
	
dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)		
	
p_plancre.Enabled = FALSE
p_plancre.picturename = "C:\erpman\Image\상환계획작성_d.gif"
p_planmod.Enabled = FALSE
p_planmod.picturename = "C:\erpman\Image\상환계획수정_d.gif"
end event

type p_search from w_inherite_standard`p_search within w_pil1000
boolean visible = false
integer x = 3753
integer y = 2672
integer taborder = 190
end type

type p_addrow from w_inherite_standard`p_addrow within w_pil1000
boolean visible = false
integer x = 4101
integer y = 2672
integer taborder = 60
end type

type p_delrow from w_inherite_standard`p_delrow within w_pil1000
boolean visible = false
integer x = 4274
integer y = 2672
integer taborder = 80
end type

type dw_insert from w_inherite_standard`dw_insert within w_pil1000
boolean visible = false
integer x = 165
integer y = 2460
integer taborder = 20
end type

type st_window from w_inherite_standard`st_window within w_pil1000
boolean visible = false
integer taborder = 150
end type

type cb_exit from w_inherite_standard`cb_exit within w_pil1000
boolean visible = false
integer x = 3657
integer y = 2556
integer taborder = 200
end type

type cb_update from w_inherite_standard`cb_update within w_pil1000
boolean visible = false
integer x = 2546
integer y = 2556
integer taborder = 110
end type

event cb_update::clicked;call super::clicked;Int il_currow
string sgubn,sempno

dw_emp.Accepttext()
sgubn = dw_emp.getitemstring(1,"gubn")
sempno = dw_emp.getitemstring(1,"empno")

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
END IF

dw_main.setitem(1,"lendgubn",sgubn)
dw_main.setitem(1,"empno",sempno)

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	
IF dw_main.Update() > 0 THEN			
	
	COMMIT USING sqlca;
	ib_any_typing =False
	
	dw_main.SetItem(dw_main.GetRow(),'arg_flag','R')
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF
dw_emp.setcolumn("empno")
dw_emp.Setfocus()

cb_1.Enabled = TRUE
cb_2.Enabled = TRUE

end event

type cb_insert from w_inherite_standard`cb_insert within w_pil1000
boolean visible = false
integer x = 887
integer y = 2556
integer taborder = 90
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_insrow

il_currow = dw_main.GetRow()
	
IF il_currow > 0 THEN
	IF wf_required_check(il_currow) <> 1 THEN RETURN
END IF

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.Setcolumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.InsertRow(0)
	
dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)		
	
cb_1.Enabled = FALSE
cb_2.Enabled = FALSE
end event

type cb_delete from w_inherite_standard`cb_delete within w_pil1000
boolean visible = false
integer x = 2917
integer y = 2556
integer taborder = 160
end type

event cb_delete::clicked;call super::clicked;Int il_currow, Total_Count
string sempno , sgubn

dw_main.SetRedraw(False)

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

dw_emp.AcceptText()
sempno    = dw_main.GetItemString(1, "empno")
sgubn    = dw_main.GetItemString(1, "lendgubn")

//상환내역자료 존재check
  SELECT count(*)  
    INTO :Total_Count 
    FROM "P3_LENDREST"  
   WHERE "P3_LENDREST"."EMPNO" = :sempno  and
			"P3_LENDREST"."LENDGUBN" = :sgubn ;
	
IF Total_Count = 0 OR IsNull(Total_Count) Then	
	IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
ELSE
	IF MessageBox("확인", "상환자료가 존재합니다 전체삭제하시겠습까", question!, yesno!) = 2	THEN return  
END IF	

	
dw_main.DeleteRow(il_currow)
	
IF dw_main.Update() > 0 THEN
	
	DELETE FROM "P3_LENDSCH"  
   WHERE "P3_LENDSCH"."EMPNO" = :sempno  and
			"P3_LENDSCH"."LENDGUBN" = :sgubn ;
			
   DELETE FROM "P3_LENDREST"  
   WHERE  "P3_LENDREST"."EMPNO" = :sempno  AND  
          "P3_LENDREST"."LENDGUBN" = :sgubn ;

	
	commit;
	cb_insert.TriggerEvent(Clicked!)
	ib_any_typing =False
	sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF
dw_emp.setcolumn("empno")
dw_emp.setfocus()
dw_emp.SetRedraw(True)







end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pil1000
boolean visible = false
integer x = 521
integer y = 2556
integer taborder = 70
end type

event cb_retrieve::clicked;call super::clicked;String 	sEmpNo,sEmpName,sColumnName,sgubn
Int il_RowCount

dw_emp.AcceptText()
sempno   = dw_emp.GetItemString(1,"empno")
sempname = dw_emp.GetItemString(1,"empname") 
sgubn = dw_emp.GetItemString(1,"gubn") 

IF IsNull(sempno) OR sempno ="" THEN 
	sempno =""
ELSE
	sColumnName = "empno"
	IF IsNull(wf_exiting_data(sColumnName,sempno,"0")) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF IsNull(sempname) OR sempname ="" THEN 
	sempname =""	
ELSE
	sColumnName = "empname"
	sempno = wf_exiting_data(sColumnName,sempname,"0")
	IF IsNull(sempno) THEN
		MessageBox("확 인","등록되지 않은 사원입니다!!")
		Return
	END IF
END IF

IF sempno ="" AND sempname ="" THEN
	MessageBox("확 인","조회할 조건을 입력하십시요!!")
	dw_emp.SetColumn("empno")
	dw_emp.SetFocus()
	Return  
END IF


dw_main.SetRedraw(False)		
IF dw_main.Retrieve(sempno,sgubn) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
//	cb_cancel.TriggerEvent(Clicked!)
	dw_main.Reset()
	dw_main.InsertRow(0)
	sle_msg.text =""
	cb_1.Enabled = false
   cb_2.Enabled = false
ELSE
	dw_main.SetItem(dw_main.GetRow(),'arg_flag','R')
	dw_main.SetColumn("lenddate")
	dw_main.setfocus()
	sle_msg.text ="조 회"
	cb_1.Enabled = TRUE
   cb_2.Enabled = TRUE
END IF

dw_main.SetRedraw(True)



end event

type st_1 from w_inherite_standard`st_1 within w_pil1000
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pil1000
boolean visible = false
integer x = 3287
integer y = 2556
integer taborder = 180
end type

event cb_cancel::clicked;call super::clicked;Int il_currow,il_insrow

ib_any_typing = False

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.setitem(1,"gubn",'1')
dw_emp.Setcolumn("empno")

dw_emp.SetFocus()


dw_main.Reset()
dw_main.InsertRow(0)

dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)		

cb_1.Enabled = FALSE
cb_2.Enabled = FALSE

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pil1000
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pil1000
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pil1000
boolean visible = false
integer x = 1307
integer y = 2508
integer width = 2711
integer height = 176
end type

type gb_1 from w_inherite_standard`gb_1 within w_pil1000
boolean visible = false
integer x = 485
integer y = 2508
integer height = 176
end type

type gb_10 from w_inherite_standard`gb_10 within w_pil1000
boolean visible = false
end type

type dw_main from u_key_enter within w_pil1000
integer x = 777
integer y = 812
integer width = 2935
integer height = 1280
integer taborder = 50
string dataobject = "d_pil1000_2"
boolean border = false
end type

event itemchanged;Int il_currow,lnull
String snull,slendate
Double damount,dStandard ,temp_paydeduamt , temp_meeddeduamt, temp_mondeduamt

w_mdi_frame.sle_msg.text=""

SetNull(snull)
SetNull(lnull)
dw_main.accepttext()

il_currow = this.GetRow()

IF this.GetColumnName() = "lenddate" THEN
	slendate = this.GetText()	
	IF slendate ="" OR IsNull(slendate) THEN RETURN	
	
	IF f_datechk(slendate) = -1 THEN
		MessageBox("확 인","대출일자를 확인하십시요!!")
		this.SetItem(1,"lenddate",snull)
		this.setcolumn("lenddate")
//		dw_main.setfocus()
	Return 1
   END IF
END IF

IF this.GetColumnName() = "fr_lend" THEN
	slendate = this.GetText()	
	IF slendate ="" OR IsNull(slendate) THEN RETURN	
	
	IF f_datechk(slendate + "01" ) = -1 THEN
		MessageBox("확 인","대출기간From을 확인하십시요!!")
		this.SetItem(1,"fr_lend",snull)
		this.setcolumn("fr_lend")
//		dw_main.setfocus()
	Return 1
   END IF
END IF

temp_paydeduamt   = dw_main.getitemnumber(il_currow,"paydeduamt")
temp_meeddeduamt  = dw_main.getitemnumber(il_currow,"meeddeduamt")

temp_mondeduamt   = temp_paydeduamt + temp_meeddeduamt

dw_main.setitem(il_currow, "mondeduamt", temp_mondeduamt)

end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemerror;Beep(1)
Return 1
end event

event itemfocuschanged;
IF dwo.name ="contents" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type pb_1 from picturebutton within w_pil1000
integer x = 2007
integer y = 664
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\first.gif"
alignment htextalign = left!
end type

event clicked;String scode,sname,iv_empno

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

scode = dw_emp.getitemstring(1, "empno")

SELECT min("P1_MASTER"."EMPNO")  
	INTO :iv_empno  
   FROM "P1_MASTER"  
   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
IF IsNull(iv_empno) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
END IF

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Retrieve(gs_company,iv_empno,'%')

p_inq.TriggerEvent(Clicked!)	

dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)

end event

type pb_2 from picturebutton within w_pil1000
integer x = 2254
integer y = 664
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;string scode,sname,iv_empno

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

scode = dw_emp.getitemstring(1, "empno")
	
SELECT MAX("P1_MASTER"."EMPNO")  
  	INTO :iv_empno  
   FROM "P1_MASTER"  
  	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :scode	;
IF IsNull(iv_empno) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
END IF

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Retrieve(gs_company,iv_empno,'%')
p_inq.TriggerEvent(Clicked!)	
dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)



end event

type pb_3 from picturebutton within w_pil1000
integer x = 2130
integer y = 664
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;string scode,sname,iv_empno

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

scode = dw_emp.getitemstring(1, "empno")
	
SELECT MIN("P1_MASTER"."EMPNO")  
  	INTO :iv_empno  
  	FROM "P1_MASTER"  
  	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :scode	;
IF IsNull(iv_empno) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
END IF

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Retrieve(gs_company,iv_empno,'%')

p_inq.TriggerEvent(Clicked!)	

dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)

end event

type pb_4 from picturebutton within w_pil1000
integer x = 2377
integer y = 664
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\last.gif"
end type

event clicked;string scode,sname,iv_empno

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

scode = dw_emp.getitemstring(1, "empno")

SELECT Max("P1_MASTER"."EMPNO")  
	INTO :iv_empno  
   FROM "P1_MASTER"  
   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company   ;
IF IsNull(iv_empno) THEN 
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
END IF

dw_main.SetRedraw(False)
dw_emp.SetRedraw(False)

dw_emp.Retrieve(gs_company,iv_empno,'%')

p_inq.TriggerEvent(Clicked!)	

dw_main.SetRedraw(True)
dw_emp.SetRedraw(True)




end event

type cb_1 from commandbutton within w_pil1000
boolean visible = false
integer x = 1335
integer y = 2556
integer width = 581
integer height = 108
integer taborder = 240
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "상환계획작성(&H)"
end type

event clicked;call super::clicked;String 	sEmpNo , wkym, sgubn
String s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12

SetPointer(HourGlass!)
sle_msg.text="상환계획자료 생성중....!"

if dw_emp.AcceptText() = -1 then return
if dw_main.AcceptText() = -1 then return

sempno   = dw_emp.GetItemString(1,"empno")
sgubn   = dw_emp.GetItemString(1,"gubn")
s1 = dw_main.GetItemString(1,"m1")
s2 = dw_main.GetItemString(1,"m2")
s3 = dw_main.GetItemString(1,"m3")
s4 = dw_main.GetItemString(1,"m4")
s5 = dw_main.GetItemString(1,"m5")
s6 = dw_main.GetItemString(1,"m6")
s7 = dw_main.GetItemString(1,"m7")
s8 = dw_main.GetItemString(1,"m8")
s9 = dw_main.GetItemString(1,"m9")
s10 = dw_main.GetItemString(1,"m10")
s11 = dw_main.GetItemString(1,"m11")
s12 = dw_main.GetItemString(1,"m12")


wkym = f_lendsch(sempno,sgubn,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12) 

if wkym = '' or isnull(wkym) then
else
	dw_main.setitem(1,"to_lend", wkym)
	sle_msg.text="상환계획자료 생성이 완료되었습니다"
end if

SetPointer(Arrow!)
end event

type cb_2 from commandbutton within w_pil1000
boolean visible = false
integer x = 1952
integer y = 2556
integer width = 558
integer height = 108
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "상환계획수정(&U)"
end type

event clicked;sle_msg.text= ''
String 	sEmpNo ,lastdate , strdate,sgubn

dw_emp.AcceptText()
sempno   = dw_emp.GetItemString(1,"empno")
sgubn   = dw_emp.GetItemString(1,"gubn")

OpenWithParm(w_pil1000_popup, sempno +'-'+ sgubn)


  SELECT max("P3_LENDSCH"."SKEDUALDATE")  
    INTO :lastdate  
    FROM "P3_LENDSCH"  
   WHERE "P3_LENDSCH"."EMPNO" = :sempno and
         "P3_LENDSCH"."LENDGUBN" = :sgubn ;

IF SQLCA.SQLCODE <> 0 THEN
	lastdate = ''
END IF	

dw_main.setitem(1,"to_lend", lastdate)

 SELECT min("P3_LENDSCH"."SKEDUALDATE")  
    INTO :strdate  
    FROM "P3_LENDSCH"  
   WHERE "P3_LENDSCH"."EMPNO" = :sempno and
         "P3_LENDSCH"."LENDGUBN" = :sgubn   ;

IF SQLCA.SQLCODE <> 0 THEN
	strdate = ''
END IF	

dw_main.setitem(1,"fr_lend", strdate)

end event

type dw_emp from datawindow within w_pil1000
event ue_key pbm_dwnkey
integer x = 782
integer y = 220
integer width = 2894
integer height = 384
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pil1000_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()
IF This.GetColumnName() = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF

IF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemchanged;String 	sEmpNo,sEmpName,snull
Int il_RowCount, cnt, dcnt

SetNull(snull)

IF ib_any_typing =True THEN
	MessageBox("확 인","저장하지 않은 자료가 있습니다.!!")
	w_mdi_frame.sle_msg.text = "자료를 저장하지 않으려면 취소를 누르십시요!!"
	Return 1
END IF

dw_main.SetRedraw(False)
If dw_emp.GetColumnName() = "empno" Then

	sempno = this.GetText()
	
	IF sempno ="" OR IsNull(sempno) THEN RETURN
	
	IF IsNull(wf_exiting_data("empno",sempno,"1")) THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		
		dw_main.SetRedraw(False)
		dw_main.Reset()
		dw_main.InsertRow(0)
		dw_main.SetRedraw(True)
		Return 1
	END IF
	
	dw_emp.Retrieve(gs_company,sempno,'%')
	p_inq.TriggerEvent(Clicked!)	
				
	
END IF
If dw_emp.GetColumnName() = "empname" Then
	sempname = this.GetText()
	
	IF sempname ="" OR IsNull(sempname) THEN RETURN
	
	sempno = wf_exiting_data("empname",sempname,"1")
	IF IsNull(sempno) THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empname")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		
		dw_main.SetRedraw(False)
		dw_main.Reset()
		dw_main.InsertRow(0)
		dw_main.SetRedraw(True)
		Return 1
	END IF
	
	dw_emp.Retrieve(gs_company,sempno,'%')
				
	p_inq.TriggerEvent(Clicked!)	
end if
                                            /*대여금횟수제한*/
select to_number(dataname) into :cnt     
from p0_syscnfg
where sysgu = 'P' and serial = 32  and lineno = 1; 

select count(empno) into :dcnt
from p3_lendmst
where empno = :sempno;

if dcnt < cnt then
else
	messagebox("확인","이 사원은 이미"+string(cnt)+"회 이용하였습니다!")
	dw_emp.reset()
	dw_emp.insertrow(0)
	return
end if
	

If dw_emp.GetColumnName() = "gubn" Then
	p_inq.TriggerEvent(Clicked!)	
end if
dw_main.SetRedraw(True)

end event

event itemerror;
Beep(1)
Return 1
end event

event itemfocuschanged;IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

type p_plancre from uo_picture within w_pil1000
event ue_lbuttondown pbm_lbuttondown
integer x = 3323
integer y = 24
integer width = 306
integer taborder = 210
boolean bringtotop = true
string picturename = "C:\erpman\Image\상환계획작성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\Image\상환계획작성_dn.gif"
end event

event clicked;call super::clicked;call super::clicked;String 	sEmpNo , wkym, sgubn
String s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text="상환계획자료 생성중....!"

if dw_emp.AcceptText() = -1 then return
if dw_main.AcceptText() = -1 then return

sempno   = dw_emp.GetItemString(1,"empno")
sgubn   = dw_emp.GetItemString(1,"gubn")
s1 = dw_main.GetItemString(1,"m1")
s2 = dw_main.GetItemString(1,"m2")
s3 = dw_main.GetItemString(1,"m3")
s4 = dw_main.GetItemString(1,"m4")
s5 = dw_main.GetItemString(1,"m5")
s6 = dw_main.GetItemString(1,"m6")
s7 = dw_main.GetItemString(1,"m7")
s8 = dw_main.GetItemString(1,"m8")
s9 = dw_main.GetItemString(1,"m9")
s10 = dw_main.GetItemString(1,"m10")
s11 = dw_main.GetItemString(1,"m11")
s12 = dw_main.GetItemString(1,"m12")


wkym = f_lendsch(sempno,sgubn,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12) 

if wkym = '' or isnull(wkym) then
else
	dw_main.setitem(1,"to_lend", wkym)
	w_mdi_frame.sle_msg.text="상환계획자료 생성이 완료되었습니다"
end if

SetPointer(Arrow!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\Image\상환계획작성_up.gif"
end event

type p_planmod from uo_picture within w_pil1000
integer x = 3621
integer y = 24
integer width = 306
integer taborder = 220
boolean bringtotop = true
string picturename = "C:\erpman\Image\상환계획수정_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text= ''
String 	sEmpNo ,lastdate , strdate,sgubn

dw_emp.AcceptText()
sempno   = dw_emp.GetItemString(1,"empno")
sgubn   = dw_emp.GetItemString(1,"gubn")

OpenWithParm(w_pil1000_popup, sempno +'-'+ sgubn)


  SELECT max("P3_LENDSCH"."SKEDUALDATE")  
    INTO :lastdate  
    FROM "P3_LENDSCH"  
   WHERE "P3_LENDSCH"."EMPNO" = :sempno and
         "P3_LENDSCH"."LENDGUBN" = :sgubn ;

IF SQLCA.SQLCODE <> 0 THEN
	lastdate = ''
END IF	

dw_main.setitem(1,"to_lend", lastdate)

 SELECT min("P3_LENDSCH"."SKEDUALDATE")  
    INTO :strdate  
    FROM "P3_LENDSCH"  
   WHERE "P3_LENDSCH"."EMPNO" = :sempno and
         "P3_LENDSCH"."LENDGUBN" = :sgubn   ;

IF SQLCA.SQLCODE <> 0 THEN
	strdate = ''
END IF	

dw_main.setitem(1,"fr_lend", strdate)
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\Image\상환계획수정_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\Image\상환계획수정_dn.gif"
end event

type gb_5 from groupbox within w_pil1000
integer x = 1984
integer y = 612
integer width = 530
integer height = 164
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

