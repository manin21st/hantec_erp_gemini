$PBExportHeader$w_kifa58a.srw
$PBExportComments$자동전표 관리 : 수출비용(비용보기)
forward
global type w_kifa58a from window
end type
type p_exit from uo_picture within w_kifa58a
end type
type dw_list from datawindow within w_kifa58a
end type
type rr_1 from roundrectangle within w_kifa58a
end type
end forward

global type w_kifa58a from window
integer x = 110
integer y = 100
integer width = 4027
integer height = 2224
boolean titlebar = true
string title = "수출비용-비용보기"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa58a w_kifa58a

on w_kifa58a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa58a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String sCostNo

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sCostNo = Message.StringParm

this.Title = this.Title + '[물류전표번호 : '+sCostNo+' ]'

IF dw_list.Retrieve(sCostNo) <=0 then
	F_MessageChk(14,'')
	Close(w_kifa58a)
	Return
END IF

dw_list.ScrollToRow(1)
dw_list.SetFocus()


	


end event

type p_exit from uo_picture within w_kifa58a
integer x = 3808
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Close(w_kifa58a)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa58a
integer x = 41
integer y = 164
integer width = 3927
integer height = 1928
string dataobject = "d_kifa58a1"
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

type rr_1 from roundrectangle within w_kifa58a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 156
integer width = 3959
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

