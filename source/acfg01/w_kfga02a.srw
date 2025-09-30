$PBExportHeader$w_kfga02a.srw
$PBExportComments$재무분석코드 등록(계산자료)
forward
global type w_kfga02a from window
end type
type p_exit from uo_picture within w_kfga02a
end type
type p_del from uo_picture within w_kfga02a
end type
type p_mod from uo_picture within w_kfga02a
end type
type p_ins from uo_picture within w_kfga02a
end type
type dw_1 from datawindow within w_kfga02a
end type
type dw_ip from datawindow within w_kfga02a
end type
type rr_1 from roundrectangle within w_kfga02a
end type
end forward

global type w_kfga02a from window
integer x = 873
integer y = 252
integer width = 2455
integer height = 1700
boolean titlebar = true
string title = "계산자료 등록"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_del p_del
p_mod p_mod
p_ins p_ins
dw_1 dw_1
dw_ip dw_ip
rr_1 rr_1
end type
global w_kfga02a w_kfga02a

type variables
long        irow,il_fsseq
Boolean  ib_changed = False,ib_DbChangedFlag = False
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);String sAcc1,sAcc2,sAmtGbn,sCalcGbn

dw_ip.AcceptText()

sAcc1    = dw_ip.GetItemString(ll_row,"acc1_cd")
sAcc2    = dw_ip.GetItemString(ll_row,"acc2_cd")
sAmtGbn  = dw_ip.GetItemString(ll_row,"amt_gu") 
sCalcGbn = dw_ip.GetItemString(ll_row,"calc_gu")
	
IF sAcc1 = "" OR IsNull(sAcc1) THEN
	f_messagechk(1,'[계정과목]')
	dw_ip.SetColumn("acc1_cd")
	dw_ip.SetFocus()
	Return -1
END IF
IF sAcc2 = "" OR IsNull(sAcc2) THEN
	f_messagechk(1,'[계정과목]')
	dw_ip.SetColumn("acc2_cd")
	dw_ip.SetFocus()
	Return -1
END IF
IF sAmtGbn = "" OR IsNull(sAmtGbn) THEN
	f_messagechk(1,'[금액구분]')
	dw_ip.SetColumn("amt_gu")
	dw_ip.SetFocus()
	Return -1
END IF
IF sCalcGbn = "" OR IsNull(sCalcGbn) THEN
	f_messagechk(1,'[연산구분]')
	dw_ip.SetColumn("calc_gu")
	dw_ip.SetFocus()
	Return -1
END IF

Return 1
end function

event open;String  smessage
Integer iLen

F_Window_Center_Response(this)

dw_1.SetTransObject(sqlca)
dw_1.Reset()
dw_1.InsertRow(0)

dw_ip.SetTransObject(sqlca)
dw_ip.Reset()

iLen     = Integer(Left(Message.StringParm,1))
sMessage = Mid(Message.StringParm,2,50)

dw_1.SetItem(1,"accd",    Left(smessage,iLen))
dw_1.SetItem(1,"accd_nm", Mid(sMessage,iLen + 1,40))

IF dw_ip.Retrieve(dw_1.GetItemString(1,"accd")) > 0 THEN
	dw_ip.SetFocus()
ELSE
	p_ins.SetFocus()
END IF

ib_changed = False


end event

on w_kfga02a.create
this.p_exit=create p_exit
this.p_del=create p_del
this.p_mod=create p_mod
this.p_ins=create p_ins
this.dw_1=create dw_1
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_del,&
this.p_mod,&
this.p_ins,&
this.dw_1,&
this.dw_ip,&
this.rr_1}
end on

on w_kfga02a.destroy
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.dw_1)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kfga02a
integer x = 2226
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;String sRtnFlag

IF ib_changed = True THEN
	IF MessageBox("확인","저장하지 않은 자료가 있습니다!!~n"+&
								"저장하시겠습니까?",Question!,YesNo!) = 1 THEN
		Return
	END IF
END IF

IF ib_dbchangedflag = True THEN
	sRtnFlag = 'ok'	
ELSE
	sRtnFlag = 'cancel'
END IF

CloseWithReturn(Parent,sRtnFlag)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_del from uo_picture within w_kfga02a
integer x = 2053
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;Integer iCurRow,rowno,i

iCurRow = dw_ip.GetRow()
IF iCurRow <=0 THEN
	messagebox("확인","삭제할 자료를 클릭하시오!")
  	dw_ip.SetFocus()
  	return
END IF

IF f_dbConfirm('삭제') = 2 THEN RETURN

dw_ip.DeleteRow(0)
IF dw_ip.Update() <> 1 THEN
	MessageBox("확  인","재무분석계산자료 저장 실패!!!")
	Rollback;
	Return
END IF

ib_changed  = False
ib_DbChangedFlag = True

dw_ip.SetFocus()



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_kfga02a
integer x = 1879
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;string sAcc1, sAcc2, sAmtGbn, sCalcGbn
long i,rowno

dw_ip.AcceptText()

IF dw_ip.RowCount() <=0 THEN RETURN

FOR i = 1 TO dw_ip.RowCount()
	IF Wf_RequiredChk(i) = -1 THEN RETURN
	
	dw_ip.SetItem(i, "serno", i)
NEXT

IF f_dbconfirm('저장') = 2 THEN RETURN

IF dw_ip.Update() <> 1 THEN
	MessageBox("확  인","재무분석계산자료 저장 실패!!!")
	Rollback;
	Return
END IF

ib_changed  = False
ib_DbChangedFlag = True

dw_ip.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from uo_picture within w_kfga02a
integer x = 1705
integer y = 4
integer width = 178
integer taborder = 10
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Integer  iCurRow,iFunctionValue

IF dw_ip.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ip.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_ip.InsertRow(0)

	dw_ip.ScrollToRow(iCurRow)
	
	dw_ip.SetItem(iCurRow,"accd",  dw_1.GetItemString(1,"accd"))
	
	dw_ip.SetColumn("acc1_cd")
	dw_ip.SetFocus()
	
	ib_changed  = False
	ib_DbChangedFlag = False
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type dw_1 from datawindow within w_kfga02a
integer x = 46
integer y = 8
integer width = 1339
integer height = 136
string dataobject = "d_kfga02a1"
boolean border = false
boolean livescroll = true
end type

type dw_ip from datawindow within w_kfga02a
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 64
integer y = 164
integer width = 2318
integer height = 1372
integer taborder = 20
string dataobject = "d_kfga02a2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
end event

event rbuttondown;setnull(lstr_account.acc1_cd) 
setnull(lstr_account.acc2_cd) 

if this.accepttext() = -1 then return
	
IF this.GetColumnName() = "acc1_cd" THEN 
	
	lstr_account.acc1_cd = this.object.acc1_cd[getrow()]
	
   Open(W_kfz01om0_popup1)
	
   dw_ip.SetItem(dw_ip.GetRow(), "acc1_cd", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "acc2_cd", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "kfz01om0_acc1_nm", lstr_account.acc1_nm)
	dw_ip.SetItem(dw_ip.GetRow(), "kfz01om0_acc2_nm", lstr_account.acc2_nm)

end if

ib_changed = True
end event

event itemerror;
Return 1
end event

event itemchanged;string sacc1 ,sacc2,sAcc1Name,sAcc2Name,sAmtGbn,sCalcGbn,sNull

SetNull(snull)

dw_ip.AcceptText()

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC1_NM",   	 "KFZ01OM0"."ACC2_NM"  
	  INTO :sAcc1Name,					 :sAcc2Name
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"kfz01om0_acc1_nm",sAcc1Name)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"acc1_cd",sNull)
		this.Setitem(this.getrow(),"acc2_cd",sNull)
		this.Setitem(this.getrow(),"kfz01om0_acc1_nm",sNull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		Return 1
	end if
END IF

IF this.GetColumnName() = 'acc2_cd' THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC1_NM",   	 "KFZ01OM0"."ACC2_NM"  
	  INTO :sAcc1Name,					 :sAcc2Name
	  FROM "KFZ01OM0"  
	  WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"kfz01om0_acc1_nm",sAcc1Name)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sAcc2Name)
	else
		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"acc1_cd",sNull)
		this.Setitem(this.getrow(),"acc2_cd",sNull)

		this.Setitem(this.getrow(),"kfz01om0_acc1_nm",sNull)
		this.Setitem(this.getrow(),"kfz01om0_acc2_nm",sNull)
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	end if	
END IF

IF this.GetColumnName() = "amt_gu" THEN
	sAmtGbn = this.GetText()
	IF sAmtGbn = "" OR IsNull(sAmtGbn) THEN RETURN
	
	IF Integer(sAmtGbn) < 1 OR Integer(sAmtGbn) > 4 THEN
		f_messagechk(20,'[금액구분]')
		this.SetItem(1,"amt_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "calc_gu" THEN
	sCalcGbn = this.GetText()
	IF sCalcGbn = "" OR IsNull(sCalcGbn) THEN RETURN
	
	IF sCalcGbn <> '+' AND sCalcGbn <> '-' AND sCalcGbn <> '*' AND sCalcGbn <> '/' THEN
		f_messagechk(20,'[연산구분]')
		this.SetItem(1,"calc_gu",snull)
		Return 1
	END IF
END IF
ib_changed = True
end event

event editchanged;ib_changed = True
end event

type rr_1 from roundrectangle within w_kfga02a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 152
integer width = 2345
integer height = 1408
integer cornerheight = 40
integer cornerwidth = 55
end type

