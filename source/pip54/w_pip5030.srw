$PBExportHeader$w_pip5030.srw
$PBExportComments$** 사업소득자 등록
forward
global type w_pip5030 from w_inherite_standard
end type
type dw_list from u_d_popup_sort within w_pip5030
end type
type dw_main from u_key_enter within w_pip5030
end type
type pb_1 from picturebutton within w_pip5030
end type
type pb_2 from picturebutton within w_pip5030
end type
type pb_3 from picturebutton within w_pip5030
end type
type pb_4 from picturebutton within w_pip5030
end type
type p_reg from uo_picture within w_pip5030
end type
type rb_all from radiobutton within w_pip5030
end type
type rb_use from radiobutton within w_pip5030
end type
type rb_unuse from radiobutton within w_pip5030
end type
type dw_saup from datawindow within w_pip5030
end type
type gb_3 from groupbox within w_pip5030
end type
type rr_1 from roundrectangle within w_pip5030
end type
type rr_2 from roundrectangle within w_pip5030
end type
type rr_3 from roundrectangle within w_pip5030
end type
type rr_4 from roundrectangle within w_pip5030
end type
end forward

global type w_pip5030 from w_inherite_standard
string title = "일용직 기본 자료 입력"
dw_list dw_list
dw_main dw_main
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
p_reg p_reg
rb_all rb_all
rb_use rb_use
rb_unuse rb_unuse
dw_saup dw_saup
gb_3 gb_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_pip5030 w_pip5030

type variables
//등록,수정 mode
String  is_status
String is_empno
string gwanri
end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
end prototypes

public function integer wf_required_check (integer ll_row);String sempno,sempname,sres_no1,ssaupno
long   ll_cardno
double damtday, damttime

dw_main.AcceptText()

sempno     = dw_main.GetItemString(1, "empno")
sempname   = dw_main.GetItemString(1, "empname")
sres_no1   = dw_main.GetItemString(1, "residentno")
ssaupno    = dw_main.GetItemString(1, "saupno")

IF sempno ="" OR IsNull(sempno) THEN
	MessageBox("확 인","사업자코드를 입력하십시요!!")
	dw_main.SetColumn("empno")
	dw_main.SetFocus()
	Return -1
END IF

IF sempname ="" OR IsNull(sempname) THEN
	MessageBox("확 인","성명을 입력하십시요!!")
	dw_main.SetColumn("empname")
	dw_main.SetFocus()
	Return -1
END IF

IF sres_no1 = "" OR IsNull(sres_no1) THEN
	MessageBox("확 인","주민등록번호를 입력하십시요!!")
	dw_main.SetColumn("residentno")
	dw_main.SetFocus()
	Return -1
END IF

IF ssaupno ="" OR IsNull(ssaupno) THEN
	MessageBox("확 인","사업장을 입력하십시요!!")
	dw_main.SetColumn("saupno")
	dw_main.SetFocus()
	Return -1
END IF


Return 1
end function

on w_pip5030.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_main=create dw_main
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.p_reg=create p_reg
this.rb_all=create rb_all
this.rb_use=create rb_use
this.rb_unuse=create rb_unuse
this.dw_saup=create dw_saup
this.gb_3=create gb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.pb_4
this.Control[iCurrent+7]=this.p_reg
this.Control[iCurrent+8]=this.rb_all
this.Control[iCurrent+9]=this.rb_use
this.Control[iCurrent+10]=this.rb_unuse
this.Control[iCurrent+11]=this.dw_saup
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
this.Control[iCurrent+16]=this.rr_4
end on

on w_pip5030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_main)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.p_reg)
destroy(this.rb_all)
destroy(this.rb_use)
destroy(this.rb_unuse)
destroy(this.dw_saup)
destroy(this.gb_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_list.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)
dw_saup.SetTransObject(SQLCA)
dw_saup.InsertRow(0)

f_set_saupcd(dw_saup,'saupcd','1')
is_saupcd = gs_saupcd

is_saupcd = '%'
p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite_standard`p_mod within w_pip5030
end type

event p_mod::clicked;call super::clicked;Int il_currow

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
setpointer(HourGlass!)
	
IF dw_main.Update() > 0 THEN
	
	COMMIT USING sqlca;
	ib_any_typing =False
	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
   setpointer(Arrow!)	

	String ls_code
	long   ll_foundrow
	ls_code = dw_main.GetItemString(dw_main.GetRow(),'empno')
	p_inq.TriggerEvent(Clicked!)
	ll_foundrow = dw_list.Find( "empno = '" + ls_code + "'", 1, dw_list.RowCount())
	if ll_foundrow > 0 then
		dw_list.Event rowfocuschanged(ll_foundrow)
	end if
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
   setpointer(Arrow!)	
	Return
END IF

end event

type p_del from w_inherite_standard`p_del within w_pip5030
end type

event p_del::clicked;call super::clicked;Int il_currow

dw_main.SetRedraw(False)

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)
	
IF dw_main.Update() > 0 THEN
	commit;
	p_reg.TriggerEvent(Clicked!)
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF
end event

type p_inq from w_inherite_standard`p_inq within w_pip5030
integer x = 3515
end type

event clicked;String 	sUseGbn

IF rb_all.checked = true THEN
	sUseGbn = '%'
ELSEIF rb_use.checked = true THEN
	sUseGbn = 'Y'
ELSEIF rb_unuse.checked = true THEN
	sUseGbn = 'N'
END IF

dw_list.SetRedraw(False)
dw_main.SetRedraw(False)

if dw_list.Retrieve(is_saupcd, sUseGbn) <= 0 then
	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetFocus()
else
	dw_list.event Rowfocuschanged(1)
end if

dw_list.SetRedraw(True)
dw_main.SetRedraw(True)


end event

type p_print from w_inherite_standard`p_print within w_pip5030
boolean visible = false
integer x = 3465
integer y = 2440
end type

type p_can from w_inherite_standard`p_can within w_pip5030
end type

event p_can::clicked;call super::clicked;p_inq.TriggerEvent(Clicked!)

end event

type p_exit from w_inherite_standard`p_exit within w_pip5030
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pip5030
boolean visible = false
integer x = 3639
integer y = 2440
end type

type p_search from w_inherite_standard`p_search within w_pip5030
boolean visible = false
integer x = 3291
integer y = 2440
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5030
boolean visible = false
integer x = 3813
integer y = 2440
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5030
boolean visible = false
integer x = 3986
integer y = 2440
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5030
boolean visible = false
integer x = 27
integer y = 2132
integer width = 128
integer height = 104
end type

type st_window from w_inherite_standard`st_window within w_pip5030
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5030
boolean visible = false
integer x = 3205
integer y = 2820
integer taborder = 80
end type

type cb_update from w_inherite_standard`cb_update within w_pip5030
boolean visible = false
integer x = 2103
integer y = 2820
integer taborder = 50
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5030
boolean visible = false
integer x = 462
integer y = 2820
integer taborder = 40
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5030
boolean visible = false
integer x = 2469
integer y = 2820
integer taborder = 60
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5030
boolean visible = false
integer x = 96
integer y = 2820
integer taborder = 30
end type

type st_1 from w_inherite_standard`st_1 within w_pip5030
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5030
boolean visible = false
integer x = 2834
integer y = 2820
integer taborder = 70
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5030
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5030
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5030
boolean visible = false
integer x = 2062
integer y = 2772
integer height = 176
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5030
boolean visible = false
integer x = 59
integer y = 2772
integer height = 176
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5030
boolean visible = false
end type

type dw_list from u_d_popup_sort within w_pip5030
event ue_key pbm_dwnkey
integer x = 192
integer y = 280
integer width = 955
integer height = 1928
integer taborder = 10
string dataobject = "d_pip5030_1"
boolean border = false
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;SelectRow(0,false)
SelectRow(currentrow,true)

dw_main.Retrieve(GetItemString(currentrow,'empno'))
dw_main.SetFocus()
end event

type dw_main from u_key_enter within w_pip5030
event ue_key pbm_dwnkey
integer x = 1335
integer y = 520
integer width = 2834
integer height = 1500
integer taborder = 20
string dataobject = "d_pip5030_2"
boolean border = false
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;String sres_no, snull

SetNull(snull)

IF this.GetColumnName() = "residentno" THEN
	sres_no = this.GetText()
	
	IF sres_no = "" OR IsNull(sres_no) THEN RETURN
	
	IF f_vendcode_check(sres_no) = False THEN
		IF MessageBox("확 인","주민등록번호가 틀렸습니다. 계속하시겠습니까?",Question!,YesNo!) = 2 then
			this.SetItem(this.GetRow(),"residentno",snull)
			this.SetColumn("residentno")
			Return 1
		END IF
	END IF
END IF

ib_any_typing = True

end event

event editchanged;ib_any_typing =True

end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" or dwo.name ="saupname" THEN
	f_toggle_kor(Handle(this))
ELSEIF dwo.name ="address1" or dwo.name ="address2" THEN
	f_toggle_kor(Handle(this))
	KeyDown(KeyEnd!)
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event rbuttondown;string ssaupcd
double damount

SetNull(gs_code)
SetNull(gs_codename)

this.AcceptText()

this.modify("saupcd.protect = 0")
IF GetColumnName() ="deptcode" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.SetItem(this.GetRow(),"p0_dept_deptname2",gs_codename)
	/*사업장*/
	SELECT "P0_DEPT"."SAUPCD"  
     INTO :ssaupcd  
     FROM "P0_DEPT"  
    WHERE "P0_DEPT"."DEPTCODE" = :gs_code   ;
	this.SetItem(this.GetRow(),"saupcd",ssaupcd)	
	this.modify("saupcd.protect = 1")
END IF

IF GetColumnName() = "bankcode" THEN
	
	open(w_bank_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SELECT "P0_BANK"."BANKNAME"  
   	INTO :gs_codename  
    	FROM "P0_BANK"  
	   WHERE "P0_BANK"."BANKCODE" = :gs_code   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"p0_bank_bankname",gs_codename)
	   this.SetItem(this.GetRow(),"bankcode",Gs_code)
	end if
END IF

IF this.GetColumnName() ="zipcode1" THEN
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN

	this.SetItem(this.GetRow(),"zipcode1", Gs_code)
	this.SetItem(this.GetRow(),"address1",Gs_codename)

	this.SetColumn("address1")
	this.SetFocus()
END IF

IF this.GetColumnName() ="zipcode2" THEN
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN

	this.SetItem(this.GetRow(),"zipcode2", Gs_code)
	this.SetItem(this.GetRow(),"address2",Gs_codename)

	this.SetColumn("address2")
	this.SetFocus()
END IF

ib_any_typing = true
return 1
end event

type pb_1 from picturebutton within w_pip5030
boolean visible = false
integer x = 2907
integer y = 60
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

event clicked;//String scode,sname,iv_empno, sabu
//
//IF ib_any_typing = True THEN
//	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
//	Return
//END IF
//
//scode = dw_emp.getitemstring(1, "empno")
//sabu = dw_emp.getitemstring(1,"saupj")
//if IsNull(sabu) or sabu = '' then sabu = '%'
////if gwanri = 'N' then sabu = gs_saupj
//
//SELECT min("P2_MASTER"."EMPNO")  
//	INTO :iv_empno  
//   FROM "P2_MASTER" 
//	WHERE "P2_MASTER"."SAUPCD" like :sabu	;
//IF IsNull(iv_empno) THEN 
//	MessageBox('확 인','더이상 자료가 없습니다.')
//	Return
//END IF
//
//dw_main.SetRedraw(False)
//dw_emp.SetRedraw(False)
//
//dw_emp.Retrieve(iv_empno,'%',sabu)
//
//IF dw_main.Retrieve(iv_empno, sabu) <=0 THEN
//	dw_main.Reset()
//	dw_main.InsertRow(0)
//	dw_main.SetItem(dw_main.GetRow(),"empno",iv_empno)
//	dw_main.SetColumn(1)
//	dw_main.SetFocus()
//ELSE
//	dw_main.SetColumn("empname")
//	dw_main.SetFocus()
//END IF
//
//dw_main.SetRedraw(True)
//dw_emp.SetRedraw(True)
//
end event

type pb_2 from picturebutton within w_pip5030
boolean visible = false
integer x = 3040
integer y = 60
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

event clicked;//string scode,sname,iv_empno, sabu
//
//IF ib_any_typing = True THEN
//	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
//	Return
//END IF
//
//scode = dw_emp.getitemstring(1, "empno")
//sabu = dw_emp.getitemstring(1,"saupj")
//if IsNull(sabu) or sabu = '' then sabu = '%'
////if gwanri = 'N' then sabu = gs_saupj
//	
//SELECT MAX("P2_MASTER"."EMPNO")  
//  	INTO :iv_empno  
//   FROM "P2_MASTER"  
//  	WHERE "P2_MASTER"."EMPNO" < :scode and
//	  	   "P2_MASTER"."SAUPCD" like :sabu	;
//IF IsNull(iv_empno) THEN 
//	MessageBox('확 인','더이상 자료가 없습니다.')
//	Return
//END IF
//
//dw_main.SetRedraw(False)
//dw_emp.SetRedraw(False)
//
//dw_emp.Retrieve(iv_empno,'%',sabu)
//
//IF dw_main.Retrieve(iv_empno,sabu) <=0 THEN
//	dw_main.Reset()
//	dw_main.InsertRow(0)
//	dw_main.SetItem(dw_main.GetRow(),"empno",iv_empno)
//	dw_main.SetColumn(1)
//	dw_main.SetFocus()
//ELSE
//	dw_main.SetColumn("empname")
//	dw_main.SetFocus()
//END IF
//
//dw_main.SetRedraw(True)
//dw_emp.SetRedraw(True)
//
//
//
end event

type pb_3 from picturebutton within w_pip5030
boolean visible = false
integer x = 3173
integer y = 60
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

event clicked;//string scode,sname,iv_empno,sabu
//
//IF ib_any_typing = True THEN
//	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
//	Return
//END IF
//
//scode = dw_emp.getitemstring(1, "empno")
//sabu = dw_emp.getitemstring(1,"saupj")
//if IsNull(sabu) or sabu = '' then sabu = '%'
////if gwanri = 'N' then sabu = gs_saupj
//	
//SELECT MIN("P2_MASTER"."EMPNO")  
//  	INTO :iv_empno  
//  	FROM "P2_MASTER"  
//  	WHERE "P2_MASTER"."EMPNO" > :scode and 
//	  	   "P2_MASTER"."SAUPCD" like :sabu	;
//IF IsNull(iv_empno) THEN 
//	MessageBox('확 인','더이상 자료가 없습니다.')
//	Return
//END IF
//
//dw_main.SetRedraw(False)
//dw_emp.SetRedraw(False)
//
//dw_emp.Retrieve(iv_empno,'%',sabu)
//
//IF dw_main.Retrieve(iv_empno,sabu) <=0 THEN
//	dw_main.Reset()
//	dw_main.InsertRow(0)
//	dw_main.SetItem(dw_main.GetRow(),"empno",iv_empno)
//	dw_main.SetColumn(1)
//	dw_main.SetFocus()
//ELSE
//	dw_main.SetColumn("empname")
//	dw_main.SetFocus()
//END IF
//
//dw_main.SetRedraw(True)
//dw_emp.SetRedraw(True)
//
end event

type pb_4 from picturebutton within w_pip5030
boolean visible = false
integer x = 3305
integer y = 60
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

event clicked;//string scode,sname,iv_empno,sabu
//
//IF ib_any_typing = True THEN
//	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
//	Return
//END IF
//
//scode = dw_emp.getitemstring(1, "empno")
//sabu = dw_emp.getitemstring(1,"saupj")
//if IsNull(sabu) or sabu = '' then sabu = '%'
////if gwanri = 'N' then sabu = gs_saupj
//
//SELECT Max("P2_MASTER"."EMPNO")  
//	INTO :iv_empno  
//   FROM "P2_MASTER"  
//	WHERE "P2_MASTER"."SAUPCD" like :sabu	;
//IF IsNull(iv_empno) THEN 
//	MessageBox('확 인','더이상 자료가 없습니다.')
//	Return
//END IF
//
//dw_main.SetRedraw(False)
//dw_emp.SetRedraw(False)
//
//dw_emp.Retrieve(iv_empno,'%',sabu)
//
//IF dw_main.Retrieve(iv_empno,sabu) <=0 THEN
//	dw_main.Reset()
//	dw_main.InsertRow(0)
//	dw_main.SetItem(dw_main.GetRow(),"empno",iv_empno)
//	dw_main.SetColumn(1)
//	dw_main.SetFocus()
//ELSE	
//	dw_main.SetColumn("empname")
//	dw_main.SetFocus()
//END IF
//
//dw_main.SetRedraw(True)
//dw_emp.SetRedraw(True)
//
//
//
//
end event

type p_reg from uo_picture within w_pip5030
integer x = 3689
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\등록_up.gif"
end type

event clicked;call super::clicked;long InsRow

IF Messagebox('확인','새로운 사업자를 추가로 등록하시겠습니까?',Question!,YesNo!) = 2 THEN return

InsRow = dw_main.InsertRow(0)
dw_main.ScrollToRow(InsRow)
dw_main.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\등록_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\등록_up.gif"
end event

type rb_all from radiobutton within w_pip5030
integer x = 270
integer y = 144
integer width = 201
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type rb_use from radiobutton within w_pip5030
integer x = 539
integer y = 144
integer width = 229
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "근로"
end type

event clicked;call super::clicked;p_inq.TriggerEvent(Clicked!)
end event

type rb_unuse from radiobutton within w_pip5030
integer x = 814
integer y = 144
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미근로"
end type

event clicked;p_inq.TriggerEvent(Clicked!)
end event

type dw_saup from datawindow within w_pip5030
integer x = 1280
integer y = 308
integer width = 722
integer height = 76
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_saup_jung"
boolean border = false
boolean livescroll = true
end type

event itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() ="saupcd" THEN 
   is_saupcd = this.GetText()
	IF trim(is_saupcd) = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
END IF

p_inq.TriggerEvent(Clicked!)
end event

type gb_3 from groupbox within w_pip5030
integer x = 187
integer y = 64
integer width = 969
integer height = 180
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "근로여부"
end type

type rr_1 from roundrectangle within w_pip5030
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2843
integer y = 20
integer width = 635
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip5030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1230
integer y = 444
integer width = 3022
integer height = 1616
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip5030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 178
integer y = 272
integer width = 983
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip5030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1230
integer y = 272
integer width = 777
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

