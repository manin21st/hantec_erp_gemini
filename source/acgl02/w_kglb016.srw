$PBExportHeader$w_kglb016.srw
$PBExportComments$원가부문 상세 등록
forward
global type w_kglb016 from window
end type
type p_exit from uo_picture within w_kglb016
end type
type p_can from uo_picture within w_kglb016
end type
type dw_rtv_sdept from datawindow within w_kglb016
end type
type dw_ins from datawindow within w_kglb016
end type
type dw_disp from datawindow within w_kglb016
end type
type rr_1 from roundrectangle within w_kglb016
end type
end forward

global type w_kglb016 from window
integer x = 1778
integer y = 12
integer width = 2153
integer height = 2188
boolean titlebar = true
string title = "원가부문 상세 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_can p_can
dw_rtv_sdept dw_rtv_sdept
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb016 w_kglb016

type variables
Boolean ib_changed,ib_DbChanged
String     LsAccGbn
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);Double  dAmount

dw_ins.AcceptText()

dAmount    = dw_ins.GetItemNumber(iCurRow,"amount")
IF IsNull(dAmount) THEN dAmount = 0

IF dAmount = 0 THEN
	dw_ins.DeleteRow(iCurRow)
ELSE
			
	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
	dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
	dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)
END IF

Return 1
end function

on w_kglb016.create
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_rtv_sdept=create dw_rtv_sdept
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_can,&
this.dw_rtv_sdept,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb016.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_rtv_sdept)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

event open;Integer iRowCount,iFindRow,iCurRow,k,iSdeptRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)

dw_rtv_sdept.SetTransObject(SQLCA)

IF dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,&
										lstr_jpra.upmugu,lstr_jpra.bjunno,lstr_jpra.sortno) <=0 THEN
	dw_disp.InsertRow(0)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saupj",     lstr_jpra.saupjang)
	dw_disp.SetItem(dw_disp.GetRow(),"bal_date",  lstr_jpra.baldate)
	dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",   lstr_jpra.upmugu)
	dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",   lstr_jpra.bjunno)
	dw_disp.SetItem(dw_disp.GetRow(),"lin_no",    lstr_jpra.sortno)
END IF

select distinct acc_gbn		into :LsAccGbn  from cia01m where acc1_cd = :lstr_jpra.acc1 ;
if sqlca.sqlcode <> 0 then
	LsAccGbn = '%'
else
	if IsNull(LsAccGbn) then LsAccGbn = '%'
end if

dw_disp.SetItem(dw_disp.GetRow(),"amount",lstr_jpra.money)

iRowCount = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,&
													lstr_jpra.upmugu,lstr_jpra.bjunno,lstr_jpra.sortno)
iSdeptRow = dw_rtv_sdept.Retrieve(LsAccGbn,lstr_jpra.saupjang)

IF iRowCount <=0 THEN
	FOR k = 1 TO iSdeptRow
		iCurRow = dw_ins.InsertRow(0)	
		
		dw_ins.SetItem(iCurRow,"sdept_cd",dw_rtv_sdept.GetItemString(k,"cost_cd"))
	NEXT
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("amount")	
	dw_ins.SetFocus()
ELSE
	dw_ins.SetRedraw(False)
	FOR k = 1 TO iSdeptRow
		iFindRow = dw_ins.Find("sdept_cd = '"+dw_rtv_sdept.GetItemString(k,"cost_cd")+"'",1,iRowCount)
		IF iFindRow <=0 THEN
			iCurRow = dw_ins.InsertRow(0)	
			
			dw_ins.SetItem(iCurRow,"sdept_cd",dw_rtv_sdept.GetItemString(k,"cost_cd"))
		END IF
	NEXT
	dw_ins.SetSort("sdept_cd A")
	dw_ins.Sort()
	
	dw_ins.SetRedraw(True)
	
	dw_ins.ScrollToRow(1)
	dw_ins.SetColumn("amount")	
	dw_ins.SetFocus()
END IF

ib_changed   = False

end event

type p_exit from uo_picture within w_kglb016
integer x = 1943
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;String  sRtnValue,sSdept
Double  dSumAmt
Integer iRowCount,k

dw_ins.AcceptText()

IF ib_changed = True THEN
	
	iRowCount = dw_ins.RowCount()
	if iRowCount > 0 then
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

		sSdept = dw_ins.GetItemSTring(1,"sdept_cd")
	END IF
	sRtnValue = '1'
ELSE
	sRtnValue = '0'	
	sSdept = ""
END IF

CloseWithReturn(parent,sRtnValue + sSdept)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_kglb016
integer x = 1769
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;CloseWithReturn(parent,'0' + '')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_rtv_sdept from datawindow within w_kglb016
boolean visible = false
integer x = 2592
integer y = 468
integer width = 494
integer height = 360
boolean titlebar = true
string title = "원가부문 조회"
string dataobject = "dw_kglb016_3"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ins from datawindow within w_kglb016
event ue_enterkey pbm_dwnprocessenter
integer x = 41
integer y = 224
integer width = 2057
integer height = 1820
integer taborder = 10
string dataobject = "dw_kglb016_2"
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
String sSdeptcode,sNull

SetNull(sNull)

IF this.GetColumnName() = "sdept_cd" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
	   FROM "VW_CDEPT_CODE"  
   	WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(this.GetRow(),"sdept_cd",snull)
		Return 1
	END IF
END IF

ib_changed = True


end event

type dw_disp from datawindow within w_kglb016
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 12
integer width = 1755
integer height = 200
string dataobject = "dw_kglb016_1"
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

type rr_1 from roundrectangle within w_kglb016
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 216
integer width = 2085
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

