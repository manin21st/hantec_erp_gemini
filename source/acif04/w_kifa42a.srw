$PBExportHeader$w_kifa42a.srw
$PBExportComments$자동전표 관리 : 매출(품목상세)
forward
global type w_kifa42a from window
end type
type p_exit from uo_picture within w_kifa42a
end type
type dw_list from datawindow within w_kifa42a
end type
type rr_1 from roundrectangle within w_kifa42a
end type
end forward

global type w_kifa42a from window
integer x = 110
integer y = 100
integer width = 4027
integer height = 2224
boolean titlebar = true
string title = "매출 - 품목 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa42a w_kifa42a

on w_kifa42a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa42a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String sChkNo

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sChkNo = Message.StringParm

this.Title = this.Title + '[계산서권번호 : '+sChkNo+' ]'

IF dw_list.Retrieve(sChkNo,Gs_Gubun) <=0 then
	F_MessageChk(14,'')
	Close(w_kifa42a)
	Return
END IF

dw_list.ScrollToRow(1)
dw_list.SetColumn("accode")
dw_list.SetFocus()


	


end event

type p_exit from uo_picture within w_kifa42a
integer x = 3799
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Integer k

IF dw_list.AcceptText() = -1 THEN Return

IF Gs_Gubun = 'Y' THEN
	FOR k= 1 TO dw_list.RowCount()
		IF dw_list.GetItemString(k,"accode") = "" OR IsNull(dw_list.GetItemString(k,"accode")) THEN
			F_Messagechk(1,'[계정과목]')
			dw_list.ScrollToRow(k)
			dw_list.SetColumn("accode")
			dw_list.SetFocus()
			Return
		END IF
	NEXT
END IF

IF dw_list.Update() <> 1 THEN
	Rollback;
	Return
END IF

COMMIT;

Close(w_kifa42a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa42a
integer x = 37
integer y = 156
integer width = 3918
integer height = 1936
integer taborder = 10
string dataobject = "d_kifa42a1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;String sAcCode,sAcName,snull

SetNull(snull)

IF this.GetColumnName() ="accode" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN Return
	
	SELECT "KFZ01OM0"."ACC2_NM"   	INTO :sAcName
	  	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAcCode) AND
				( "KFZ01OM0"."GBN3" = 'Y') AND  ("KFZ01OM0"."BAL_GU" <> '4') ;
				
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(this.GetRow(),"accode",snull)
		Return 1
	END IF
END IF

end event

type rr_1 from roundrectangle within w_kifa42a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 152
integer width = 3945
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

