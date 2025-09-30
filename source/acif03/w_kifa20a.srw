$PBExportHeader$w_kifa20a.srw
$PBExportComments$자동전표 관리 : 매출(거래명세서기준-수불상세)
forward
global type w_kifa20a from window
end type
type p_exit from uo_picture within w_kifa20a
end type
type dw_list from datawindow within w_kifa20a
end type
type rr_1 from roundrectangle within w_kifa20a
end type
end forward

global type w_kifa20a from window
integer x = 110
integer y = 84
integer width = 4023
integer height = 2224
boolean titlebar = true
string title = "수불내역 - 품목 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa20a w_kifa20a

on w_kifa20a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa20a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String  sGbn, sDate, sCvcod,sChkNo,sSaupj
Integer iCount

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sSaupj = Gs_Gubun

sGbn = Left(Message.StringParm,1)
IF sGbn = 'I' THEN										/*전표 발행 -상세*/
	sDate = Mid(Message.StringParm,2,16)
	sCvcod = Gs_Code
	
	dw_list.DataObject = 'd_kifa20a1'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	iCount = dw_list.Retrieve(sSaupj,Mid(sDate,1,8),Right(sDate,8),sCvcod)
ELSE
	sChkNo = Mid(Message.StringParm,2,15)
	
	dw_list.DataObject = 'd_kifa20a2'
	dw_list.SetTransObject(SQLCA)
	dw_list.Reset()
	
	iCount = dw_list.Retrieve(sSaupj,sChkNo)
END IF
IF iCount <=0 then
	F_MessageChk(14,'')
	Close(w_kifa20a)
	Return
END IF


	


end event

type p_exit from uo_picture within w_kifa20a
integer x = 3799
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
Close(w_kifa20a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa20a
integer x = 32
integer y = 152
integer width = 3927
integer height = 1928
integer taborder = 10
string dataobject = "d_kifa20a1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

event itemchanged;//String sAcCode,sAcName,snull
//
//SetNull(snull)
//
//IF this.GetColumnName() ="kif01ot1_accode" THEN
//	sAcCode = this.GetText()
//	IF sAcCode = "" OR IsNull(sAcCode) THEN Return
//	
//	SELECT "KFZ01OM0"."ACC2_NM"   	INTO :sAcName
//	  	FROM "KFZ01OM0"  
//   	WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAcCode) AND
//				( "KFZ01OM0"."GBN3" = 'Y') AND (  "KFZ01OM0"."BAL_GU" <> '4') ;
//				
//	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(this.GetRow(),"kif01ot1_accode",snull)
//		Return 1
//	END IF
//END IF
end event

event itemerror;Return 1
end event

type rr_1 from roundrectangle within w_kifa20a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 148
integer width = 3954
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

