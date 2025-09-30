$PBExportHeader$w_kglb015.srw
$PBExportComments$예산 상세 등록
forward
global type w_kglb015 from window
end type
type p_exit from uo_picture within w_kglb015
end type
type p_can from uo_picture within w_kglb015
end type
type dw_rtv_cdept from datawindow within w_kglb015
end type
type dw_ins from datawindow within w_kglb015
end type
type dw_disp from datawindow within w_kglb015
end type
type rr_1 from roundrectangle within w_kglb015
end type
end forward

global type w_kglb015 from window
integer x = 1765
integer y = 4
integer width = 2162
integer height = 2176
boolean titlebar = true
string title = "예산 상세 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
dw_rtv_cdept dw_rtv_cdept
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb015 w_kglb015

type variables
Boolean ib_changed,ib_DbChanged
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);Double  dAmount
String  sCdeptCode,sYesanGbn
Integer iFunValue

SELECT "KFZ01OM0"."YESAN_GU"      INTO :sYesanGbn  
	FROM "KFZ01OM0"  
   WHERE ( "KFZ01OM0"."ACC1_CD" = :lstr_jpra.acc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :lstr_jpra.acc2 );

dw_ins.AcceptText()

sCdeptCode = dw_ins.GetItemString(iCurRow,"cdept_cd") 
dAmount    = dw_ins.GetItemNumber(iCurRow,"amount")
IF IsNull(dAmount) THEN dAmount = 0

IF dAmount = 0 THEN
	dw_ins.DeleteRow(iCurRow)
ELSE
//	/*예산통제 체크*/
//	iFunValue = Sqlca.AcFn050(lstr_jpra.saupjang,  &
//									  Left(lstr_jpra.baldate,4), &
//									  Mid(lstr_jpra.baldate,5,2),&
//									  lstr_account.acc1_cd, &
//									  lstr_account.acc2_cd,&
//									  sCdeptCode, &
//									  sYesanGbn, &
//									  dAmount)
//	IF iFunValue = -1 THEN
//		F_MessageChk(58,'[예산잔액 초과]')
//		dw_ins.SetColumn("amount")
//		dw_ins.SetFocus()
//		Return -1		
//	ELSEIF iFunValue = -2 THEN
//		F_MessageChk(58,'[예산배정 없슴]')
//		dw_ins.SetColumn("amount")
//		dw_ins.SetFocus()
//		Return -1		
//	ELSEIF iFunValue = -3 THEN
//		F_MessageChk(53,'')
//		dw_ins.SetColumn("amount")
//		dw_ins.SetFocus()
//		Return -1		
//	END IF
			
	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
	dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
	dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)
	
	dw_ins.SetItem(iCurRow,"acc1_cd",   lstr_account.acc1_cd)
	dw_ins.SetItem(iCurRow,"acc2_cd",   lstr_account.acc2_cd)
END IF

Return 1
end function

on w_kglb015.create
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_rtv_cdept=create dw_rtv_cdept
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_can,&
this.dw_rtv_cdept,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb015.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_rtv_cdept)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

event open;Integer iRowCount,iFindRow,iCdeptRow,iCurRow,k

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)

dw_rtv_cdept.SetTransObject(SQLCA)

IF dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,&
										lstr_jpra.upmugu,lstr_jpra.bjunno,lstr_jpra.sortno) <=0 THEN
	dw_disp.InsertRow(0)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saupj",     lstr_jpra.saupjang)
	dw_disp.SetItem(dw_disp.GetRow(),"bal_date",  lstr_jpra.baldate)
	dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",   lstr_jpra.upmugu)
	dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",   lstr_jpra.bjunno)
	dw_disp.SetItem(dw_disp.GetRow(),"lin_no",    lstr_jpra.sortno)
END IF

dw_disp.SetItem(dw_disp.GetRow(),"amount",lstr_jpra.money)

iRowCount = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,&
													lstr_jpra.upmugu,lstr_jpra.bjunno,lstr_jpra.sortno)
iCdeptRow = dw_rtv_cdept.Retrieve(lstr_jpra.saupjang,Left(lstr_jpra.baldate,4),&
											 lstr_account.acc1_cd, lstr_account.acc2_cd)

IF iRowCount <=0 THEN
	FOR k = 1 TO iCdeptRow
		iCurRow = dw_ins.InsertRow(0)	
		
		dw_ins.SetItem(iCurRow,"cdept_cd",dw_rtv_cdept.GetItemString(k,"dept_cd"))
	NEXT
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("amount")	
	dw_ins.SetFocus()
ELSE
	dw_ins.SetRedraw(False)
	FOR k = 1 TO iCdeptRow
		iFindRow = dw_ins.Find("cdept_cd = '"+dw_rtv_cdept.GetItemString(k,"dept_cd")+"'",1,iRowCount)
		IF iFindRow <=0 THEN
			iCurRow = dw_ins.InsertRow(0)	
			
			dw_ins.SetItem(iCurRow,"cdept_cd",dw_rtv_cdept.GetItemString(k,"dept_cd"))
		END IF
	NEXT
	dw_ins.SetSort("cdept_cd A")
	dw_ins.Sort()
	
	dw_ins.SetRedraw(True)
	
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("amount")	
	dw_ins.SetFocus()
END IF

ib_changed   = False

end event

type p_exit from uo_picture within w_kglb015
integer x = 1943
integer y = 4
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;String  sRtnValue,sCdept
Double  dSumAmt
Integer iRowCount,k

dw_ins.AcceptText()

IF ib_changed = True THEN
	
	iRowCount = dw_ins.RowCount()
	if iRowcount > 0 then
		dSumAmt = dw_ins.GetItemNumber(dw_ins.RowCount(),"sum_amt")
		IF IsNull(dSumAmt) THEN dSumAmt = 0		
	else
		dSumAmt = 0
	end if
	IF dSumAmt <> lstr_jpra.money THEN
		F_MessageChk(37,'')
		Return	
	END IF
	
	dw_ins.SetRedraw(False)
	FOR k = iRowCount TO 1 Step -1
		IF Wf_RequiredChk(k) = -1 THEN 
			dw_ins.SetRedraw(True)
			Return	
		END IF
	NEXT
	dw_ins.SetRedraw(True)
	
	IF iRowCount > 0 THEN 	
		
		IF F_DbConFirm('저장') = 2  then return
		
		IF dw_ins.Update() <> 1 THEN
			Rollback;
			F_messageChk(13,'')
			Return
		END IF

		sCdept = dw_ins.GetItemSTring(1,"cdept_cd")
	END IF
	sRtnValue = '1'
ELSE
	sRtnValue = '0'	
	sCdept = ""
END IF

CloseWithReturn(parent,sRtnValue + sCdept)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_kglb015
integer x = 1769
integer y = 4
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;CloseWithReturn(parent,'0' + '')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_rtv_cdept from datawindow within w_kglb015
boolean visible = false
integer x = 1659
integer y = 160
integer width = 635
integer height = 100
boolean titlebar = true
string title = "예산부서 조회"
string dataobject = "dw_kglb015_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ins from datawindow within w_kglb015
event ue_enterkey pbm_dwnprocessenter
integer x = 32
integer y = 228
integer width = 2066
integer height = 1820
integer taborder = 10
string dataobject = "dw_kglb015_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;IF this.GetRow() = this.RowCount() THEN
	Send(Handle(this),256,9,0)
END IF
end event

event editchanged;ib_changed = True
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

event itemchanged;
String sCdeptcode,sNull

SetNull(sNull)

IF this.GetColumnName() = "cdept_cd" THEN
	sCdeptCode = this.GetText()	
	IF sCdeptCode = "" OR IsNull(sCdeptCode) THEN RETURN
	
	SELECT DISTINCT "KFE01OM0"."DEPT_CD"  	INTO :sCdeptCode  
	   FROM "KFE01OM0"  
   	WHERE "KFE01OM0"."DEPT_CD" = :sCdeptCode   ;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[예산부서]')
		this.SetItem(this.GetRow(),"cdept_cd",snull)
		Return 1
	END IF
END IF

ib_changed = True


end event

event dberror;
If f_messagechk(sqldbcode,'['+String(row)+'라인]') = -1 THEN
	Return
ELSE
	Return 1
END IF
end event

type dw_disp from datawindow within w_kglb015
event ue_pressenter pbm_dwnprocessenter
integer x = 9
integer y = 4
integer width = 1760
integer height = 212
string dataobject = "dw_kglb015_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
IF this.GetColumnName() = "pum_text" THEN
ELSE
	Send(Handle(this),256,9,0)
	Return 1
END IF
end event

event itemfocuschanged;
IF this.GetColumnName() = "pum_text" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))	
END IF
end event

event itemerror;
Return 1
end event

type rr_1 from roundrectangle within w_kglb015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 220
integer width = 2094
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

