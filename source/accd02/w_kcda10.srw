$PBExportHeader$w_kcda10.srw
$PBExportComments$결산조정코드 등록
forward
global type w_kcda10 from w_inherite
end type
type dw_ip from u_key_enter within w_kcda10
end type
type dw_ret from u_key_enter within w_kcda10
end type
type rr_1 from roundrectangle within w_kcda10
end type
end forward

global type w_kcda10 from w_inherite
string title = "결산조정코드 등록"
dw_ip dw_ip
dw_ret dw_ret
rr_1 rr_1
end type
global w_kcda10 w_kcda10

type variables
string        Is_fsGbn

end variables

forward prototypes
public function integer wf_requiredchk ()
end prototypes

public function integer wf_requiredchk ();//String sFsGbn,sName,sAcc1,sAcc2,sFsNo,sAmtGbn
//Long   lFsSeq

String   sEditGbn, sBalAcCd, sAmtGbn,sJpyGbn,sSysJpyNo
Long     lRefBalCd
Integer  k

dw_ret.AcceptText()

For k = 1 To dw_ret.RowCount()
	sEditGbn    = dw_ret.GetItemString(k,"editgbn")
	sBalAcCd    = dw_ret.GetItemString(k,"editgbn")	
Next
//sFsGbn  = dw_ret.Getitemstring(iRow,"fs_gu")
//lFsSeq  = dw_ret.Getitemnumber(iRow,"fs_seq")
//sFsNo   = dw_ret.Getitemstring(iRow,"fs_no")
//sAcc1   = dw_ret.Getitemstring(iRow,"acc1_cd")
//sAcc2   = dw_ret.Getitemstring(iRow,"acc2_cd")
//sName   = dw_ret.Getitemstring(iRow,"kname")
//sAmtGbn = dw_ret.Getitemstring(iRow,"amt_gu")
//
//IF sFsGbn = '' OR IsNull(sFsGbn) THEN
//	F_messagechk(1,"결산서구분코드")
//   dw_ret.SetColumn("fs_gu")
//   dw_ret.SetFocus()
//   return -1
//END IF
//
//if lFsSeq <= 0 OR IsNull(lFsSeq) then
//   f_messagechk(1,"결산서순번")
//   dw_ret.SetColumn("fs_seq")
//   dw_ret.SetFocus()
//   return -1
//end if
//
//if IsNull(sName) or sName = '' then
//   f_messagechk(1,"과목명")
//   dw_ret.SetColumn("kname")
//   dw_ret.SetFocus()
//   return -1
//end if
//
////IF sFsNo = '' OR IsNull(sFsNo) THEN
////	F_messagechk(1,"레벨")
////   dw_ret.SetColumn("fs_no")
////   dw_ret.SetFocus()
////   return -1
////END IF
//IF sAmtGbn = '' OR IsNull(sAmtGbn) THEN
//	F_messagechk(1,"금액구분")
//   dw_ret.SetColumn("amt_gu")
//   dw_ret.SetFocus()
//   return -1
//ELSE
//	IF sAmtGbn = '1' or sAmtGbn = '2' or sAmtGbn = '3' or sAmtGbn = '4' THEN
//		IF sAcc1 = '' OR IsNull(sAcc1) THEN
//			F_messagechk(1,"계정과목")
//			dw_ret.SetColumn("acc1_cd")
//			dw_ret.SetFocus()
//			return -1
//		END IF
//		IF sAcc2 = '' OR IsNull(sAcc2) THEN
//			F_messagechk(1,"계정과목")
//			dw_ret.SetColumn("acc2_cd")
//			dw_ret.SetFocus()
//			return -1
//		END IF
//				
//	END IF
//END IF
//
Return 1
end function

on w_kcda10.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_ret=create dw_ret
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_ret
this.Control[iCurrent+3]=this.rr_1
end on

on w_kcda10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_ret)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ret.SetTransObject(SQLCA)

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetFocus()

dw_ret.Reset()
ib_any_typing =False

Is_FsGbn ='1'

dw_ret.Retrieve(Is_FsGbn)

end event

type dw_insert from w_inherite`dw_insert within w_kcda10
boolean visible = false
integer x = 64
integer y = 1720
integer taborder = 60
end type

type p_delrow from w_inherite`p_delrow within w_kcda10
boolean visible = false
integer x = 2793
integer y = 28
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kcda10
boolean visible = false
integer x = 2619
integer y = 28
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kcda10
boolean visible = false
integer x = 2080
integer y = 20
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kcda10
integer x = 3045
integer y = 28
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_ret.GetRow()

//IF iRowCount > 0 THEN
//	iFunctionValue = Wf_RequiredChk(dw_ret.GetRow())
//	IF iFunctionValue <> 1 THEN RETURN
//ELSE
	iFunctionValue = 1	
//	
//	iRowCount = 0
//END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_ret.InsertRow(iCurRow)

	dw_ret.ScrollToRow(iCurRow)
	dw_ret.SetItem(iCurRow,"balance_gu",    Is_FsGbn)
	dw_ret.SetColumn("balance_cd")
	
	dw_ret.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_ret.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.picturename = "C:\erpman\image\추가_up.gif"
END IF


end event

type p_exit from w_inherite`p_exit within w_kcda10
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kcda10
integer taborder = 40
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_ip.SetFocus()

dw_ret.Reset()

p_ins.Enabled = False
p_ins.picturename = "C:\erpman\image\추가_d.gif"

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_kcda10
boolean visible = false
integer x = 2254
integer y = 20
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kcda10
boolean visible = false
integer x = 2437
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kcda10
integer x = 3218
integer y = 28
integer taborder = 0
end type

event p_del::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer k
Long    lSeqNo

IF dw_ret.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
//ELSE
//	lSeqNo = dw_ret.GetItemNumber(dw_ret.GetRow(),"fs_seq")
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ret.DeleteRow(dw_ret.GetRow())
IF dw_ret.Update() = 1 THEN
	
	dw_ret.SetColumn("balance_nm")
	dw_ret.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
	Return
END IF
commit;

end event

type p_mod from w_inherite`p_mod within w_kcda10
integer x = 4078
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

Integer k,iRtnValue
Long    lSeqNo
String  sFsGu

IF dw_ret.AcceptText() = -1 THEN Return

//IF dw_ret.RowCount() > 0 THEN
//	FOR k = 1 TO dw_ret.RowCount()
//		iRtnValue = Wf_RequiredChk(k)
//		IF iRtnValue = -1 THEN RETURN
//	NEXT
//ELSE
//	Return
//END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_ret.Update() = 1 THEN
	
//	FOR k = 1 TO dw_ret.RowCount()
//		dw_ret.SetItem(k,'sflag','M')
//		
//		if dw_ret.GetItemString(k,"amt_gu") <> '9' then
//			sFsGu  = dw_ret.GetItemString(k,"fs_gu")
//			lSeqNo = dw_ret.GetItemNumber(k,"fs_seq")
//			
//			delete from kfz02ot0 where fs_gu = :sFsGu and fs_seq = :lSeqNo;
//		end if
//	NEXT
	commit;

	dw_ret.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_ret.RowCount() <=0 THEN
	p_ins.Enabled = False
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
ELSE
	p_ins.Enabled = True
	p_ins.picturename = "C:\erpman\image\추가_up.gif"
END IF
end event

type cb_exit from w_inherite`cb_exit within w_kcda10
end type

type cb_mod from w_inherite`cb_mod within w_kcda10
end type

type cb_ins from w_inherite`cb_ins within w_kcda10
end type

type cb_del from w_inherite`cb_del within w_kcda10
end type

type cb_inq from w_inherite`cb_inq within w_kcda10
end type

type cb_print from w_inherite`cb_print within w_kcda10
end type

type st_1 from w_inherite`st_1 within w_kcda10
end type

type cb_can from w_inherite`cb_can within w_kcda10
end type

type cb_search from w_inherite`cb_search within w_kcda10
end type







type gb_button1 from w_inherite`gb_button1 within w_kcda10
end type

type gb_button2 from w_inherite`gb_button2 within w_kcda10
end type

type dw_ip from u_key_enter within w_kcda10
integer x = 46
integer y = 40
integer width = 1024
integer height = 140
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kcda101"
boolean border = false
end type

event itemchanged;call super::itemchanged;
IF this.GetColumnName() = 'accgbn' THEN
	Is_FsGbn = this.GetText()
	IF Is_FsGbn = '' OR IsNull(Is_FsGbn) THEN Return
	
	dw_ret.Retrieve(Is_FsGbn)
	
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_ret from u_key_enter within w_kcda10
integer x = 87
integer y = 192
integer width = 4503
integer height = 2048
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kcda102"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;String    sacc,sAccName,sAmtGbn,sNull

SetNull(sNull)

IF this.GetColumnName() = "balance_accd" THEN
	sacc = this.GetText()
	IF sacc = "" OR IsNull(sacc) THEN RETURN
	
	select acc2_nm	into :sAccName	from kfz01om0 where acc1_cd||acc2_cd = :sAcc;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"acnm",sAccName)
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"balance_accd",sNull)
		this.Setitem(this.getrow(),"acnm",sNull)
		Return 1
	end if
END IF

IF this.GetColumnName() = "amtgbn" THEN
	sAmtGbn = this.GetText()
	IF sAmtGbn = "" OR IsNull(sAmtGbn) THEN RETURN
	
	IF Integer(sAmtGbn) <> 1 AND Integer(sAmtGbn) <> 2 AND &
		Integer(sAmtGbn) <> 3 AND Integer(sAmtGbn) <> 4 THEN
		f_messagechk(20,'[금액구분]')
		this.SetItem(this.GetRow(),"amtgbn",snull)
		Return 1
	END IF
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

event itemfocuschanged;call super::itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="balance_nm" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event rbuttondown;call super::rbuttondown;IF this.GetColumnName() ="balance_accd" THEN

	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"balance_accd"),1)

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	
	Open(W_KFZ01OM0_POPUP1)

	IF gs_code ="" AND IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"balance_accd",lstr_account.acc1_cd+lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acnm",lstr_account.acc2_nm)
END IF
end event

type rr_1 from roundrectangle within w_kcda10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 184
integer width = 4544
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

