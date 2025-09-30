$PBExportHeader$w_pip1001.srw
$PBExportComments$** 급호 테이블 등록
forward
global type w_pip1001 from w_inherite_multi
end type
type dw_level from datawindow within w_pip1001
end type
type dw_main from u_key_enter within w_pip1001
end type
type rr_1 from roundrectangle within w_pip1001
end type
end forward

global type w_pip1001 from w_inherite_multi
string title = "호봉 테이블 등록"
dw_level dw_level
dw_main dw_main
rr_1 rr_1
end type
global w_pip1001 w_pip1001

type variables

end variables

forward prototypes
public function integer wf_requiredcheck (integer ll_row)
end prototypes

public function integer wf_requiredcheck (integer ll_row);
String shobong, syymm
Double dbaseamt,detc1,detc2,dtotal

if dw_level.Accepttext() = -1 then return  -1
syymm = dw_level.Getitemstring(1,'yymm')
shobong  = dw_main.GetItemString(ll_row,"salary")
dbaseamt = dw_main.GetItemNumber(ll_row,"basepay")
detc1    = dw_main.GetItemNumber(ll_row,"defaultallow1")
detc2    = dw_main.GetItemNumber(ll_row,"defaultallow2")
dtotal   = dw_main.GetItemNumber(ll_row,"ctotal")

if IsNull(syymm) or syymm = '' then
	Messagebox("확 인","적용년월을 입력하세요!!")
	dw_level.SetColumn("yymm")
	dw_level.SetFocus()
	Return -1
END IF

IF shobong ="" OR IsNull(shobong) THEN
	Messagebox("확 인","호봉을 입력하세요!!")
	dw_main.SetColumn("salary")
	dw_main.SetFocus()
	Return -1
END IF

IF dtotal = 0 THEN
	Messagebox("확 인","기본급을 입력하세요!!")
	dw_main.SetColumn("basepay")
	dw_main.SetFocus()
	Return -1
END IF

dw_main.SetItem(ll_row, "startym", syymm)
dw_main.SetItem(ll_row,"totbasepay",dw_main.GetItemNumber(ll_row,"ctotal"))

Return 1
end function

on w_pip1001.create
int iCurrent
call super::create
this.dw_level=create dw_level
this.dw_main=create dw_main
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_level
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.rr_1
end on

on w_pip1001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_level)
destroy(this.dw_main)
destroy(this.rr_1)
end on

event open;call super::open;
dw_level.SetTransObject(SQLCA)
dw_level.Reset()
dw_level.InsertRow(0)
dw_level.SetFocus()

dw_main.SetTransObject(SQLCA)
dw_main.Reset()
dw_level.setitem(1,'yymm',left(gs_today,6))
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1001
boolean visible = false
integer x = 3451
integer y = 3004
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1001
boolean visible = false
integer x = 3278
integer y = 3004
end type

type p_search from w_inherite_multi`p_search within w_pip1001
boolean visible = false
integer x = 2930
integer y = 3008
end type

type p_ins from w_inherite_multi`p_ins within w_pip1001
integer x = 3721
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue,i

string jikjonggubn ,levelcode ,sCodeName,snull
w_mdi_frame.sle_msg.text= ''
dw_level.accepttext()

SetNull(snull)

jikjonggubn  = dw_level.GetItemString(1,"jikjonggubn")
levelcode   = dw_level.GetItemstring(1,"levelcode")

IF jikjonggubn ="" OR IsNull(jikjonggubn) OR (jikjonggubn <> '1' AND jikjonggubn <> '2') THEN
	Messagebox("확 인","직종을 확인하세요!!")
	w_mdi_frame.sle_msg.text= "직종구분은  '1' , '2' "
	dw_level.setitem(1,"jikjonggubn",snull)
	dw_level.SetColumn("jikjonggubn")
	dw_level.SetFocus()
	Return  
END IF

IF levelcode ="" OR IsNull(levelcode) THEN
	Messagebox("확 인","직급을 입력하세요!!")
 	w_mdi_frame.sle_msg.text= ''
	dw_level.SetColumn("levelcode")
	dw_level.SetFocus()
	Return 
else
	sCodeName = f_code_select('직급',LevelCode)
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 직급코드입니다!!")
		dw_level.SetItem(1,"levelcode",snull)
		dw_level.SetColumn("levelcode")
		dw_level.SetFocus()	
		Return 
	END IF
END IF


IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	for i = 1 to dw_main.rowcount()
		il_functionvalue = wf_requiredcheck(i)
	next
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)
	dw_main.SetItem(il_currow,"levelcode",levelcode)
	dw_main.SetItem(il_currow,"jikjonggubn",jikjonggubn)
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("salary")
	dw_main.SetFocus()
	
	
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pip1001
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pip1001
integer x = 4242
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

//dw_level.SetRedraw(False)
//dw_level.Reset()
//dw_level.Insertrow(0)
dw_level.Setfocus()
//dw_level.SetRedraw(True)

dw_main.Reset()
ib_any_typing = false

end event

type p_print from w_inherite_multi`p_print within w_pip1001
boolean visible = false
integer x = 3104
integer y = 3008
end type

type p_inq from w_inherite_multi`p_inq within w_pip1001
integer x = 3547
end type

event p_inq::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

string jikjonggubn ,levelcode ,sCodeName,snull
w_mdi_frame.sle_msg.text= ''
dw_level.accepttext()

SetNull(snull)

jikjonggubn  = dw_level.GetItemString(1,"jikjonggubn")
levelcode   = dw_level.GetItemstring(1,"levelcode")

IF jikjonggubn ="" OR IsNull(jikjonggubn) OR (jikjonggubn <> '1' AND jikjonggubn <> '2') THEN
	Messagebox("확 인","직종을 확인하세요!!")
	w_mdi_frame.sle_msg.text= "직종구분은  '1' , '2' "
	dw_level.setitem(1,"jikjonggubn",snull)
	dw_level.SetColumn("jikjonggubn")
	dw_level.SetFocus()
	Return  
END IF

IF levelcode ="" OR IsNull(levelcode) THEN
	Messagebox("확 인","직급을 입력하세요!!")
 	w_mdi_frame.sle_msg.text= ''
	dw_level.SetColumn("levelcode")
	dw_level.SetFocus()
	Return  
else
	sCodeName = f_code_select('직급',LevelCode)
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 직급코드입니다!!")
		dw_level.SetItem(1,"levelcode",snull)
		dw_level.SetColumn("levelcode")
		dw_level.SetFocus()	
		Return  
	END IF
END IF

dw_main.SetRedraw(False)
IF dw_main.Retrieve(gs_company,levelcode,jikjonggubn) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	p_ins.triggerevent(clicked!)
END IF

w_mdi_frame.sle_msg.text = " 조회 "

dw_main.SetSort("salary_num A")
dw_main.Sort()
dw_main.SetRedraw(True)

dw_main.ScrollToRow(1)
dw_main.SetColumn("salary")
dw_main.SetFocus()

end event

type p_del from w_inherite_multi`p_del within w_pip1001
integer x = 4069
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("salary")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pip1001
integer x = 3895
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_requiredcheck(dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

SetPointer(HourGlass!)
FOR k = 1 TO dw_main.RowCount()
	dw_main.SetItem(k,"totbasepay",dw_main.GetItemNumber(k,"ctotal"))
NEXT

SetPointer(Arrow!)
IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
		

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1001
boolean visible = false
integer x = 311
integer y = 2964
end type

type st_window from w_inherite_multi`st_window within w_pip1001
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1001
boolean visible = false
integer x = 1358
integer y = 2660
integer taborder = 40
end type

event cb_append::clicked;call super::clicked;Int il_currow,il_functionvalue

string jikjonggubn ,levelcode ,sCodeName,snull
w_mdi_frame.sle_msg.text= ''
dw_level.accepttext()

SetNull(snull)

jikjonggubn  = dw_level.GetItemString(1,"jikjonggubn")
levelcode   = dw_level.GetItemstring(1,"levelcode")

IF jikjonggubn ="" OR IsNull(jikjonggubn) OR (jikjonggubn <> '1' AND jikjonggubn <> '2') THEN
	Messagebox("확 인","직종을 확인하세요!!")
	w_mdi_frame.sle_msg.text= "직종구분은  '1' , '2' "
	dw_level.setitem(1,"jikjonggubn",snull)
	dw_level.SetColumn("jikjonggubn")
	dw_level.SetFocus()
	Return  
END IF

IF levelcode ="" OR IsNull(levelcode) THEN
	Messagebox("확 인","직급을 입력하세요!!")
 	w_mdi_frame.sle_msg.text= ''
	dw_level.SetColumn("levelcode")
	dw_level.SetFocus()
	Return 
else
	sCodeName = f_code_select('직급',LevelCode)
	IF IsNull(sCodeName) THEN
		MessageBox("확 인","등록되지 않은 직급코드입니다!!")
		dw_level.SetItem(1,"levelcode",snull)
		dw_level.SetColumn("levelcode")
		dw_level.SetFocus()	
		Return 
	END IF
END IF

IF dw_main.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)
	dw_main.SetItem(il_currow,"levelcode",levelcode)
	dw_main.SetItem(il_currow,"jikjonggubn",jikjonggubn)
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("salary")
	dw_main.SetFocus()
	
END IF

end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1001
boolean visible = false
integer x = 3173
integer y = 2656
integer taborder = 90
end type

type cb_update from w_inherite_multi`cb_update within w_pip1001
boolean visible = false
integer x = 2075
integer y = 2656
integer taborder = 60
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1001
boolean visible = false
integer x = 1723
integer y = 2660
integer taborder = 50
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1001
boolean visible = false
integer x = 2441
integer y = 2656
integer taborder = 70
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1001
boolean visible = false
integer x = 992
integer y = 2660
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1001
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1001
boolean visible = false
integer x = 2807
integer y = 2656
integer taborder = 80
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1001
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1001
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1001
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1001
boolean visible = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1001
boolean visible = false
end type

type dw_level from datawindow within w_pip1001
integer x = 55
integer y = 52
integer width = 1961
integer height = 168
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip1001_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string jikjonggubn ,levelcode ,sCodeName,snull
w_mdi_frame.sle_msg.text= ''
dw_level.accepttext()

SetNull(snull)

jikjonggubn  = dw_level.GetItemString(1,"jikjonggubn")
levelcode   = dw_level.GetItemstring(1,"levelcode")

IF dw_level.GetColumnName() = "jikjonggubn" then
	IF jikjonggubn ="" OR IsNull(jikjonggubn) OR (jikjonggubn <> '1' AND jikjonggubn <> '2') THEN
		Messagebox("확 인","직종을 확인하세요!!")
		w_mdi_frame.sle_msg.text= "직종구분은  '1' , '2' "
		dw_level.setitem(1,"jikjonggubn",snull)
		dw_level.SetColumn("jikjonggubn")
		dw_level.SetFocus()
		Return 1
	END IF
END IF

IF dw_level.GetColumnName() = "levelcode" THEN
	IF levelcode ="" OR IsNull(levelcode) THEN
		Messagebox("확 인","직급을 입력하세요!!")
		w_mdi_frame.sle_msg.text= ''
		dw_level.SetColumn("levelcode")
		dw_level.SetFocus()
		Return 1
	else
		sCodeName = f_code_select('직급',LevelCode)
		IF IsNull(sCodeName) THEN
			MessageBox("확 인","등록되지 않은 직급코드입니다!!")
			dw_level.SetItem(1,"levelcode",snull)
			dw_level.SetColumn("levelcode")
			dw_level.SetFocus()	
			Return 1
		END IF
	END IF
END IF
end event

event itemerror;
Return 1
end event

type dw_main from u_key_enter within w_pip1001
integer x = 73
integer y = 236
integer width = 4475
integer height = 1956
integer taborder = 20
string dataobject = "d_pip1001_1"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;Int     il_currow,lReturnRow
String  shobong,snull,sempname
Double  db_basepay,db_defaultallow1,db_defaultallow2

SetNull(snull)

il_currow = this.GetRow()

IF this.GetColumnName() = "salary" THEN
	
	shobong = THIS.GETTEXT()								
	
	lReturnRow = This.Find("salary = '"+sHobong+"' ", 1, This.RowCount())
	
	IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인","등록된 호봉코드입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow, "salary", sNull)
		RETURN  1	
	END IF
	
//	select empname into :sempname
//	from p1_master
//	where companycode = :gs_company and empno = :shobong;
//	
//	if IsNull(sempname) or sempname = '' then
//		this.Setitem(il_currow,'empname',sNull)		
//	else
//		this.Setitem(il_currow,'empname',sempname)
//	end if
END IF

IF this.GetColumnName() = 'basepay' THEN
	db_basepay = Double(this.GetText())
	IF db_basepay = 0 OR IsNull(db_basepay) THEN db_basepay = 0	
	
END IF

if this.GetColumnName() ='basepay' or &
   this.GetColumnName() ='defaultallow1' or &
   this.GetColumnName() ='defaultallow2'then 
	
   db_basepay       = this.getitemnumber(il_currow,'basepay')
	db_defaultallow1 = this.getitemnumber(il_currow,'defaultallow1')
   db_defaultallow2 = this.getitemnumber(il_currow,'defaultallow2')
	
   if db_basepay + db_defaultallow1 + db_defaultallow2  <> 0 then	
		this.setitem(il_currow,'totbasepay', db_basepay + db_defaultallow1 + db_defaultallow2 )	
	end if
else
	return
end if






end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

event itemfocuschanged;call super::itemfocuschanged;dw_main.SetItem(row,"totbasepay",dw_main.GetItemNumber(row,"ctotal"))

end event

event ue_pressenter;
IF dw_main.getcolumnname() = "defaultallow2" AND dw_main.rowcount() = dw_main.getrow() THEN
	p_ins.triggerevent(clicked!)
ELSE
	send(handle(this), 256, 9, 0)
	return 1
END IF


end event

event rbuttondown;call super::rbuttondown;//setnull(gs_code)
//setnull(gs_codename)
//
//open(w_employee_popup)
//
//if isnull(gs_code) or gs_code = ''then return
//
//this.setitem(getrow(),"salary",gs_code)
//this.setitem(getrow(),"empname",gs_codename)


end event

type rr_1 from roundrectangle within w_pip1001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 224
integer width = 4503
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

