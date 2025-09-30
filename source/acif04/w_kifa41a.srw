$PBExportHeader$w_kifa41a.srw
$PBExportComments$자동전표 관리 : 매입(품목상세)
forward
global type w_kifa41a from window
end type
type p_exit from uo_picture within w_kifa41a
end type
type dw_list from datawindow within w_kifa41a
end type
type rr_1 from roundrectangle within w_kifa41a
end type
end forward

global type w_kifa41a from window
integer x = 110
integer y = 84
integer width = 4027
integer height = 2224
boolean titlebar = true
string title = "매입 - 품목 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa41a w_kifa41a

on w_kifa41a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa41a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String sChkNo,sCvcod

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sChkNo = Message.StringParm
sCvcod = Gs_Code

//this.Title = this.Title + '[계산서권번호 : '+sChkNo+' ]'

IF dw_list.Retrieve(sChkNo,sCvcod,Gs_Gubun) <=0 then
	F_MessageChk(14,'')
	Close(w_kifa41a)
	Return
END IF

IF gs_gubun = "D" THEN dw_list.enabled = False


	


end event

type p_exit from uo_picture within w_kifa41a
integer x = 3799
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Integer k

IF Gs_Gubun = "D" THEN 
	Close(w_kifa41a)
ELSE
	//dw_list.AcceptText() 
	
	IF Gs_Gubun = 'Y' THEN
		FOR k= 1 TO dw_list.RowCount()
			IF dw_list.GetItemString(k,"kif01ot1_accode") = "" OR IsNull(dw_list.GetItemString(k,"kif01ot1_accode")) THEN
				F_Messagechk(1,'[계정과목]')
				dw_list.ScrollToRow(k)
				dw_list.SetColumn("kif01ot1_accode")
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
	
	Close(w_kifa41a)
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa41a
integer x = 32
integer y = 156
integer width = 3931
integer height = 1924
integer taborder = 10
string dataobject = "d_kifa41a1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

event itemchanged;String sAcCode,sAcName,snull

SetNull(snull)

IF this.GetColumnName() ="kif01ot1_accode" THEN
	sAcCode = this.GetText()
	IF sAcCode = "" OR IsNull(sAcCode) THEN Return
	
	SELECT "KFZ01OM0"."ACC2_NM"   	INTO :sAcName
	  	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAcCode) AND
				( "KFZ01OM0"."GBN3" = 'Y') AND (  "KFZ01OM0"."BAL_GU" <> '4') ;
				
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(this.GetRow(),"kif01ot1_accode",snull)
		Return 1
	END IF
END IF
end event

event itemerror;Return 1
end event

type rr_1 from roundrectangle within w_kifa41a
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

