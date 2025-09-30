$PBExportHeader$w_kcda05a.srw
$PBExportComments$결산기준코드등록(보조등록)
forward
global type w_kcda05a from window
end type
type p_exit from uo_picture within w_kcda05a
end type
type p_del from uo_picture within w_kcda05a
end type
type p_mod from uo_picture within w_kcda05a
end type
type p_ins from uo_picture within w_kcda05a
end type
type dw_1 from datawindow within w_kcda05a
end type
type dw_ip from datawindow within w_kcda05a
end type
type rr_1 from roundrectangle within w_kcda05a
end type
end forward

global type w_kcda05a from window
integer x = 873
integer y = 252
integer width = 2720
integer height = 1464
boolean titlebar = true
string title = "연산금액 보조등록"
boolean controlmenu = true
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
global w_kcda05a w_kcda05a

type variables
long        irow,il_fsseq
Boolean  ib_changed = False,ib_DbChangedFlag = False
end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);String sAcc1,sAcc2,sAmtGbn,sCalcGbn,sJipGbn

dw_ip.AcceptText()

sAcc1    = dw_ip.GetItemString(ll_row,"acc1_cd")
sAcc2    = dw_ip.GetItemString(ll_row,"acc2_cd")
sAmtGbn  = dw_ip.GetItemString(ll_row,"amt_gu") 
sCalcGbn = dw_ip.GetItemString(ll_row,"calc_gu")
sJipGbn  = dw_ip.GetItemString(ll_row,"fs_kind")
	
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
IF sJipGbn = "" OR IsNull(sJipGbn) THEN
	f_messagechk(1,'[집계방법]')
	dw_ip.SetColumn("fs_kind")
	dw_ip.SetFocus()
	Return -1
END IF
Return 1
end function

event open;String smessage

F_Window_Center_Response(This)

dw_1.SetTransObject(sqlca)
dw_1.Reset()
dw_1.InsertRow(0)

dw_ip.SetTransObject(sqlca)
dw_ip.Reset()

smessage =message.stringparm

dw_1.SetItem(1,"fs_gu",   Left(smessage,1))
dw_1.SetItem(1,"fs_seq",  Long(Mid(smessage,2,5)))
dw_1.SetItem(1,"kname",   Mid(sMessage,7,40))

IF dw_ip.Retrieve(dw_1.GetItemString(1,"fs_gu"),dw_1.GetItemNumber(1,"fs_seq")) > 0 THEN
	dw_ip.SetFocus()
ELSE
	p_ins.SetFocus()
END IF

ib_changed = False
end event

on w_kcda05a.create
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

on w_kcda05a.destroy
destroy(this.p_exit)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_ins)
destroy(this.dw_1)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

type p_exit from uo_picture within w_kcda05a
integer x = 2501
integer y = 24
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

type p_del from uo_picture within w_kcda05a
integer x = 2327
integer y = 24
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
	MessageBox("확  인","결산연산자료 저장 실패!!!")
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

type p_mod from uo_picture within w_kcda05a
integer x = 2153
integer y = 24
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
	
	dw_ip.SetItem(i,"serno", i)
NEXT

IF f_dbconfirm('저장') = 2 THEN RETURN

IF dw_ip.Update() <> 1 THEN
	MessageBox("확  인","결산연산자료 저장 실패!!!")
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

type p_ins from uo_picture within w_kcda05a
integer x = 1979
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iGetRow

IF dw_ip.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ip.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
	
	iGetRow = dw_ip.GetRow()
ELSE
	iFunctionValue = 1	
	
	iGetRow = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iGetRow + 1
	
	dw_ip.InsertRow(iCurRow)

	dw_ip.ScrollToRow(iCurRow)
	dw_ip.SetItem(iCurRow,"fs_gu", dw_1.GetItemString(1,"fs_gu"))
	dw_ip.SetItem(iCurRow,"fs_seq",dw_1.GetItemNumber(1,"fs_seq"))
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

type dw_1 from datawindow within w_kcda05a
integer x = 27
integer y = 24
integer width = 1705
integer height = 188
string dataobject = "dw_kcda05a1"
boolean border = false
boolean livescroll = true
end type

type dw_ip from datawindow within w_kcda05a
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 46
integer y = 232
integer width = 2587
integer height = 1080
integer taborder = 10
string dataobject = "dw_kcda05a2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
end event

event clicked;//클릭
//irow = dw_ip.GetClickedRow()
//If  irow > 0  Then	
//	 this.SelectRow(0,False)
//	 this.SelectRow(irow,True)
//else
//    Return
//End If
end event

event rbuttondown;setnull(lstr_account.acc1_cd) 
setnull(lstr_account.acc2_cd) 
	
IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" THEN 
	
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
		this.SetItem(this.getrow(),"amt_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "calc_gu" THEN
	sCalcGbn = this.GetText()
	IF sCalcGbn = "" OR IsNull(sCalcGbn) THEN RETURN
	
	IF sCalcGbn <> '+' AND sCalcGbn <> '-' AND sCalcGbn <> '*' AND sCalcGbn <> '/' THEN
		f_messagechk(20,'[연산구분]')
		this.SetItem(this.getrow(),"calc_gu",snull)
		Return 1
	END IF
END IF
ib_changed = True
end event

event editchanged;ib_changed = True
end event

type rr_1 from roundrectangle within w_kcda05a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 228
integer width = 2633
integer height = 1096
integer cornerheight = 40
integer cornerwidth = 46
end type

