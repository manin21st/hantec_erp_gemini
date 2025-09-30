$PBExportHeader$w_kcda08.srw
$PBExportComments$회계인명코드 등록
forward
global type w_kcda08 from w_inherite
end type
type dw_2 from datawindow within w_kcda08
end type
type gb_copy from groupbox within w_kcda08
end type
type gb_2 from groupbox within w_kcda08
end type
type dw_1 from datawindow within w_kcda08
end type
type rb_2 from radiobutton within w_kcda08
end type
type rb_3 from radiobutton within w_kcda08
end type
type cbx_1 from checkbox within w_kcda08
end type
type sle_search from singlelineedit within w_kcda08
end type
type p_1 from uo_picture within w_kcda08
end type
type gb_3 from groupbox within w_kcda08
end type
type rr_1 from roundrectangle within w_kcda08
end type
end forward

global type w_kcda08 from w_inherite
string title = "회계인명코드 등록"
dw_2 dw_2
gb_copy gb_copy
gb_2 gb_2
dw_1 dw_1
rb_2 rb_2
rb_3 rb_3
cbx_1 cbx_1
sle_search sle_search
p_1 p_1
gb_3 gb_3
rr_1 rr_1
end type
global w_kcda08 w_kcda08

type variables
String   LsEditFlag ='0'
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);String sPersonCode,sPersonName,sPersonSts

dw_2.AcceptText()
sPersonCode = dw_2.GetItemString(ll_row,"person_cd")
sPersonName = dw_2.GetItemString(ll_row,"person_nm")
sPersonSts  = dw_2.GetItemString(ll_row,"person_sts")

IF sPersonCode = "" OR IsNull(sPersonCode) THEN
	f_messagechk(1,'[인명코드]')
	dw_2.SetColumn("person_cd")
	dw_2.SetFocus()
	Return -1
END IF
IF sPersonName = "" OR IsNull(sPersonName) THEN
	f_messagechk(1,'[인명명칭]')
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
	Return -1
END IF
IF sPersonSts = "" OR IsNull(sPersonSts) THEN
	f_messagechk(1,'[코드상태]')
	dw_2.SetColumn("person_sts")
	dw_2.SetFocus()
	Return -1
END IF
Return 1
end function

public function integer wf_dup_chk (integer ll_row);String  sPersonGbn,sPersonCode
Integer iReturnRow

dw_1.AcceptText()
sPersonGbn = dw_1.GetItemString(1,"person_gu")

dw_2.AcceptText()
sPersonCode = dw_2.GetItemString(ll_row,"person_cd")

IF sPersonGbn  ="" OR IsNull(sPersonGbn)  THEN RETURN 1
IF sPersonCode ="" OR IsNull(sPersonCode) THEN RETURN 1

iReturnRow = dw_2.find("person_gu ='" + sPersonGbn + "' and person_cd = '" + sPersonCode+"'", 1, dw_2.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[인명코드]')
	RETURN  -1
END IF
	
Return 1
end function

on w_kcda08.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.gb_copy=create gb_copy
this.gb_2=create gb_2
this.dw_1=create dw_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cbx_1=create cbx_1
this.sle_search=create sle_search
this.p_1=create p_1
this.gb_3=create gb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_copy
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.sle_search
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.rr_1
end on

on w_kcda08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_copy)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cbx_1)
destroy(this.sle_search)
destroy(this.p_1)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

rb_2.Checked =True
end event

event key;//Descent Ancestor 
   graphicobject   obj_type
   
   obj_type = GetFocus()
   
   if Typeof(obj_type) <> SingleLineEdit! then
   	Choose Case key
   		Case KeyW!
   			p_print.TriggerEvent(Clicked!)
   		Case KeyQ!
   			p_inq.TriggerEvent(Clicked!)
   		Case KeyT!
   			p_ins.TriggerEvent(Clicked!)
   		Case KeyA!
   			p_addrow.TriggerEvent(Clicked!)
   		Case KeyE!
   			p_delrow.TriggerEvent(Clicked!)
   		Case KeyS!
   			p_mod.TriggerEvent(Clicked!)
   		Case KeyD!
   			p_del.TriggerEvent(Clicked!)
   		Case KeyC!
   			p_can.TriggerEvent(Clicked!)
   		Case KeyX!
   			p_exit.TriggerEvent(Clicked!)
   	End Choose
end if
end event

type dw_insert from w_inherite`dw_insert within w_kcda08
boolean visible = false
integer x = 69
integer y = 2880
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kcda08
boolean visible = false
integer x = 4037
integer y = 2988
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda08
boolean visible = false
integer x = 3813
integer y = 2972
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda08
integer x = 3621
integer y = 28
integer width = 306
boolean originalsize = true
string picturename = "C:\Erpman\image\거래처가져오기_up.gif"
end type

event p_search::clicked;call super::clicked;Int    iCount
String sCvCod, sCvNas, sSano

If MessageBox('확 인','거래처로 등록된 인명코드를 삭제(코드상태=사용불가 제외) 후 다시 생성합니다...'+'~n'+&
                      '계속하시겠습니까?',Question!,YesNo!,2) = 2 THEN Return

dw_2.Reset()

w_mdi_frame.sle_msg.text = '자료를 삭제하는 중...'
SetPointer(HourGlass!)

delete from kfz04om0 where person_gu = '1' and nvl(person_sts,'a') <> '2';
commit;

w_mdi_frame.sle_msg.text = '자료를 복사하는 중...'

Setpointer(Hourglass!)

Declare Cur_a Cursor for
	select cvcod, cvnas,
          decode(Length(sano) - 10,null,null,0,substr(sano,1,3)||'-'||substr(sano,4,2)||'-'||substr(sano,6,5),null)
     from vndmst
    where cvgu = '1' or cvgu = '2';

Open Cur_a;

Do While SQLCA.sqlcode = 0
	
	Fetch Cur_a Into :sCvCod, :sCvNas, :sSano;
	
	IF SQLCA.sqlcode <> 0 THEN
		Exit
	END IF
	
	Select count(*)
     Into :iCount
     From kfz04om0
    Where person_cd = :sCvCod
	   And person_gu = '1';
	
	IF iCount = 0 THEN
		
		Insert into kfz04om0
						(person_cd,		person_nm,		person_gu,		person_no,		
						 person_bnk,	person_sts,	 	person_ac1,		person_cd2,		person_tx)
			  Values (:sCvCod,		:sCvNas,			'1',				:sSano,
						 null,			'1',				null,				null,				null);
		IF sqlca.sqlcode <> 0 THEN
			Rollback;
			Close Cur_a;
			F_MessageChk(13,sqlca.sqlerrtext)
			SetPointer(Arrow!)
			Return
		END IF
	END IF
	
Loop

Commit;

Close Cur_a;

SetPointer(Arrow!)

w_mdi_frame.sle_msg.text = '자료 복사 완료'

p_inq.TriggerEvent(Clicked!)
end event

event p_search::ue_lbuttondown;PictureName = "C:\Erpman\image\거래처가져오기_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\Erpman\image\거래처가져오기_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kcda08
integer x = 3451
integer y = 28
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sPersonGbn

w_mdi_frame.sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sPersonGbn = dw_1.GetItemString(1,"person_gu")
IF sPersonGbn = "" OR IsNull(sPersonGbn) THEN
	F_MessageChk(1,'[인명구분]')
	dw_1.SetColumn("person_gu")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_2.InsertRow(0)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'person_gu',sPersonGbn)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetColumn("person_cd")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

end event

type p_exit from w_inherite`p_exit within w_kcda08
end type

type p_can from w_inherite`p_can within w_kcda08
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_2.SetRedraw(False)
IF dw_2.Retrieve(dw_1.GetItemString(1,"person_gu")) > 0 THEN
	dw_2.ScrollToRow(1)
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
ELSE
//	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

p_1.TriggerEvent(Clicked!)

ib_any_typing =False


end event

type p_print from w_inherite`p_print within w_kcda08
boolean visible = false
integer x = 3378
integer y = 3016
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda08
integer x = 3278
integer y = 28
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sgubun

IF dw_1.Accepttext() = -1 THEN RETURN

sgubun = dw_1.GetItemString(dw_1.GetRow(),"person_gu")

IF sGubun = "" OR IsNull(sGubun) THEN
	f_MessageChk(1,'[인명구분]')
	dw_1.SetColumn("person_gu")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.Retrieve(sGubun) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	Return
ELSE
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
END IF

IF LsEditFlag = '0' THEN
	p_ins.Enabled = True
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	
ELSE
	p_ins.Enabled = false
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
	
END IF

end event

type p_del from w_inherite`p_del within w_kcda08
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kcda08
integer y = 28
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_2.AcceptText() = -1 THEN Return

IF dw_2.RowCount() > 0 THEN
	FOR k = 1 TO dw_2.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT

	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_kcda08
boolean visible = false
integer x = 3410
integer y = 2820
end type

type cb_mod from w_inherite`cb_mod within w_kcda08
boolean visible = false
integer x = 2345
integer y = 2820
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_2.AcceptText() = -1 THEN Return

IF dw_2.RowCount() > 0 THEN
	FOR k = 1 TO dw_2.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT

	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_kcda08
boolean visible = false
integer x = 731
integer y = 2820
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sPersonGbn

sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sPersonGbn = dw_1.GetItemString(1,"person_gu")
IF sPersonGbn = "" OR IsNull(sPersonGbn) THEN
	F_MessageChk(1,'[인명구분]')
	dw_1.SetColumn("person_gu")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_2.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_2.InsertRow(0)

	dw_2.ScrollToRow(iCurRow)
	dw_2.SetItem(iCurRow,'person_gu',sPersonGbn)
	dw_2.SetItem(iCurRow,'sflag','I')
	dw_2.SetColumn("person_cd")
	dw_2.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_kcda08
boolean visible = false
integer x = 2697
integer y = 2820
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_2.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_2.DeleteRow(0)
IF dw_2.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_2.RowCount()
		dw_2.SetItem(k,'sflag','M')
	NEXT
	
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_kcda08
boolean visible = false
integer x = 370
integer y = 2820
end type

event cb_inq::clicked;call super::clicked;String sgubun

IF dw_1.Accepttext() = -1 THEN RETURN

sgubun = dw_1.GetItemString(dw_1.GetRow(),"person_gu")

IF sGubun = "" OR IsNull(sGubun) THEN
	f_MessageChk(1,'[인명구분]')
	dw_1.SetColumn("person_gu")
	dw_1.SetFocus()
	Return
END IF

IF dw_2.Retrieve(sGubun) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	Return
ELSE
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
END IF

IF LsEditFlag = '0' THEN
	cb_ins.Enabled = True
	cb_del.Enabled = True
ELSE
	cb_ins.Enabled = False
	cb_del.Enabled = False
END IF

end event

type cb_print from w_inherite`cb_print within w_kcda08
boolean visible = false
integer x = 2002
integer y = 2632
end type

type st_1 from w_inherite`st_1 within w_kcda08
boolean visible = false
integer x = 142
integer y = 2968
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_kcda08
boolean visible = false
integer x = 3054
integer y = 2820
end type

event cb_can::clicked;call super::clicked;
sle_msg.text =""

dw_2.SetRedraw(False)
IF dw_2.Retrieve(dw_1.GetItemString(1,"person_gu")) > 0 THEN
	dw_2.ScrollToRow(1)
	dw_2.SetColumn("person_nm")
	dw_2.SetFocus()
ELSE
//	cb_ins.SetFocus()
END IF
dw_2.SetRedraw(True)

p_1.TriggerEvent(Clicked!)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_kcda08
boolean visible = false
integer x = 1317
integer y = 2820
integer width = 741
string text = "거래처 가져오기(&W)"
end type

event cb_search::clicked;call super::clicked;
If MessageBox('확 인','거래처로 등록된 인명코드를 삭제 후 다시 생성합니다...'+'~n'+&
                      '계속하시겠습니까?',Question!,YesNo!,2) = 2 THEN Return

dw_2.Reset()

sle_msg.text = '자료를 삭제하는 중...'
SetPointer(HourGlass!)

delete from kfz04om0 where person_gu = '1';
commit;

sle_msg.text = '자료를 복사하는 중...'
insert into kfz04om0
	(person_cd,		person_nm,		person_gu,		
	 person_no,		
	 person_bnk,	person_sts,	 	person_ac1,		person_cd2,		person_tx)
select cvcod,		cvnas,			'1',				
	 decode(Length(sano) - 10,null,null,0,substr(sano,1,3)||'-'||substr(sano,4,2)||'-'||substr(sano,6,5),null),
	 null,			'1',				null,				null,				null
	from vndmst
	where cvgu = '1' or cvgu = '2' ;
if sqlca.sqlcode <> 0 then
	F_MessageChk(13,sqlca.sqlerrtext)
	Rollback;
	SetPointer(Arrow!)

	Return
else
	Commit;
end if

SetPointer(Arrow!)
sle_msg.text = '자료를 복사 완료'

cb_inq.TriggerEvent(Clicked!)



end event

type dw_datetime from w_inherite`dw_datetime within w_kcda08
boolean visible = false
integer x = 2967
integer y = 2968
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_kcda08
boolean visible = false
integer x = 453
integer y = 2968
integer width = 2514
end type

type gb_10 from w_inherite`gb_10 within w_kcda08
boolean visible = false
integer x = 123
integer y = 2920
integer width = 3593
end type

type gb_button1 from w_inherite`gb_button1 within w_kcda08
boolean visible = false
integer x = 338
integer y = 2764
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda08
boolean visible = false
integer x = 2299
integer y = 2764
end type

type dw_2 from datawindow within w_kcda08
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 73
integer y = 192
integer width = 4489
integer height = 2120
integer taborder = 40
string dataobject = "dw_kcda08_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;String sPersonCode,sAcc1,sAcc2,sAcc2Name,sPersonBank,sNull

SetNull(snull)

w_mdi_frame.sle_msg.text =""

IF this.GetColumnName() ="person_cd" THEN
	sPersonCode = this.GetText()
	IF sPersonCode = "" OR IsNull(sPersonCode) THEN RETURN
	
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"person_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "person_ac1" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN
		this.Setitem(this.getrow(),"person_ac2",snull)
		RETURN
	END IF
	
	sAcc2 = this.GetItemString(this.GetRow(),"person_cd2")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"  			INTO :sAcc2Name
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"person_ac1",snull)
		this.Setitem(this.getrow(),"person_cd2",snull)
		Return 
	end if
END IF

IF this.GetColumnName() = 'person_cd2' THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN 
		this.Setitem(this.getrow(),"person_ac1",snull)
		RETURN
	END IF
	
	sAcc1 = this.GetItemString(this.GetRow(),"person_ac1")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"			INTO :sAcc2Name
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode <> 0 then
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"person_ac1",snull)
		this.Setitem(this.getrow(),"person_cd2",snull)
		this.SetColumn("person_ac1")
		this.SetFocus()
		Return 
	end if
END IF

IF this.GetColumnName() = 'person_bnk' THEN
	sPersonBank = this.GetText()
	IF sPersonBank = "" OR IsNull(sPersonBank) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_CD"  
   	INTO :sPersonBank  
    	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '2' ) AND ( "KFZ04OM0"."PERSON_CD" = :sPersonBank )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,'[금융기관]')
		this.SetItem(this.GetRow(),"person_bnk",snull)
		Return 1
	END IF
END IF

ib_any_typing =True
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="person_nm" OR dwo.name ="person_tx" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rbuttondown;String ls_gj1,ls_gj2,rec_acc1,rec_acc2

setnull(lstr_account.acc1_cd)
setnull(lstr_account.acc2_cd)

dw_2.accepttext()

IF this.GetColumnName() ="person_ac1" THEN

	ls_gj1 =dw_2.GetItemString(this.GetRow(),"person_ac1")
	ls_gj2 =dw_2.GetItemString(this.GetRow(),"person_cd2")

	IF IsNull(ls_gj1) then ls_gj1 = ""
	IF IsNull(ls_gj2) then ls_gj2 = ""
	
 	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) THEN RETURN
	
	dw_2.SetItem(this.GetRow(),"person_ac1",lstr_account.acc1_cd)
	dw_2.SetItem(this.GetRow(),"person_cd2",lstr_account.acc2_cd)

END IF

ib_any_typing =True
end event

event retrieverow;
IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

event retrieveend;Integer k

FOR k = 1 TO rowcount
	this.SetItem(k,'sflag','M')
NEXT
end event

event itemerror;Return 1
end event

type gb_copy from groupbox within w_kcda08
boolean visible = false
integer x = 1285
integer y = 2764
integer width = 809
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_kcda08
integer x = 1925
integer y = 12
integer width = 507
integer height = 156
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "정렬/찾기"
borderstyle borderstyle = styleraised!
end type

type dw_1 from datawindow within w_kcda08
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 56
integer width = 1120
integer height = 104
integer taborder = 10
string dataobject = "dw_kcda08_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String snull,sPersonGbn

SetNull(snull)

w_mdi_frame.sle_msg.text =""

IF this.GetColumnName() ="person_gu" THEN
	sPersonGbn = this.GetText()
	IF sPersonGbn = "" OR IsNull(sPersonGbn) THEN REturn
	
	SELECT "RFGUB",	nvl("RFNA3",'0')  		INTO :sPersonGbn,	:LsEditFlag
    	FROM "REFFPF"  
   	WHERE ( "RFCOD" = 'CU' ) AND ( "RFGUB" =:sPersonGbn) ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"인명구분") 
		dw_1.SetItem(1,"person_gu",snull)
		LsEditFlag = '0'
		Return 1
	END IF
	
	setpointer(hourglass!)
	dw_2.Retrieve(sPersonGbn)
	setpointer(hourglass!)
	
	IF sPersonGbn = '1' THEN
		dw_2.Modify("person_no_t.text = '"+"사업자번호"+"'")	
		
		gb_copy.Visible = True
		cb_search.Visible = True
	ELSE
		dw_2.Modify("person_no_t.text = '"+"관리번호"+"'")
		
		gb_copy.Visible = False
		cb_search.Visible = False
	END IF
	IF LsEditFlag = '0' THEN
		p_ins.Enabled = True
		p_ins.PictureName = "C:\erpman\image\추가_up.gif"
		
	ELSE
		p_ins.Enabled = false
		p_ins.PictureName = "C:\erpman\image\추가_d.gif"
	END IF
END IF

end event

event itemerror;
Return 1
end event

event rbuttondown;String ls_gj1,ls_gj2,rec_acc1,rec_acc2

IF this.GetColumnName() ="person_ac1" OR this.GetColumnName() ="person_cd2" THEN

	ls_gj1 =dw_1.GetItemString(1,"person_ac1")
	ls_gj2 =dw_1.GetItemString(1,"person_cd2")

	IF IsNull(ls_gj1) then
   	ls_gj1 = ""
	end if
	IF IsNull(ls_gj2) then
   	ls_gj2 = ""
	end if

 	lstr_account.acc1_cd = Trim(ls_gj1)
	lstr_account.acc2_cd = Trim(ls_gj2)

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	dw_1.SetItem(1,"person_ac1",lstr_account.acc1_cd)
	dw_1.SetItem(1,"person_cd2",lstr_account.acc2_cd)

	dw_1.SetItem(1,"accname",lstr_account.acc2_nm)
END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="person_nm" OR dwo.name ="person_tx" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

type rb_2 from radiobutton within w_kcda08
integer x = 1957
integer y = 76
integer width = 229
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
string text = "코드"
boolean checked = true
end type

event clicked;
dw_2.SetRedraw(False)

IF rb_2.Checked =True THEN
	dw_2.SetSort("person_cd A,person_nm A")
END IF
dw_2.Sort()

dw_2.SetRedraw(True)
end event

type rb_3 from radiobutton within w_kcda08
integer x = 2194
integer y = 76
integer width = 229
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
string text = "명칭"
end type

event clicked;
dw_2.SetRedraw(False)

IF rb_3.Checked =True THEN
	dw_2.SetSort("person_nm A,person_cd A")
END IF
dw_2.Sort()

dw_2.SetRedraw(True)
end event

type cbx_1 from checkbox within w_kcda08
integer x = 2469
integer y = 84
integer width = 759
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "회계인명코드 조회 출력"
end type

event clicked;open(w_kcda08a)

cbx_1.Checked =False
end event

type sle_search from singlelineedit within w_kcda08
integer x = 1198
integer y = 76
integer width = 517
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event modified;p_1.TriggerEvent(Clicked!)
end event

type p_1 from uo_picture within w_kcda08
integer x = 1728
integer y = 20
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\검색_up.gif"
end type

event clicked;call super::clicked;String sSearch

sSearch = Trim(sle_search.Text)
IF sSearch = "" OR IsNull(sSearch) THEN
		dw_2.SetFilter('')		
ELSE
	IF rb_2.Checked = True THEN									/*코드*/
		dw_2.SetFilter("person_cd like '"+sSearch+'%'+"'")	
	ELSE
		dw_2.SetFilter("person_nm like '"+'%'+sSearch+'%'+"'")	
	END IF
END IF

dw_2.FilTer()

end event

type gb_3 from groupbox within w_kcda08
integer x = 2441
integer y = 44
integer width = 823
integer height = 128
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_kcda08
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 188
integer width = 4553
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 46
end type

