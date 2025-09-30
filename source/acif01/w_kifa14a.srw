$PBExportHeader$w_kifa14a.srw
$PBExportComments$자동전표 관리 : 수출(수출상세)
forward
global type w_kifa14a from window
end type
type p_exit from uo_picture within w_kifa14a
end type
type dw_list from datawindow within w_kifa14a
end type
type rr_1 from roundrectangle within w_kifa14a
end type
end forward

global type w_kifa14a from window
integer x = 133
integer y = 72
integer width = 4500
integer height = 2224
boolean titlebar = true
string title = "수출 - 품목 상세"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
dw_list dw_list
rr_1 rr_1
end type
global w_kifa14a w_kifa14a

on w_kifa14a.create
this.p_exit=create p_exit
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_list,&
this.rr_1}
end on

on w_kifa14a.destroy
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;String sCiNo

F_Window_Center_Response(This)

dw_list.SetTransObject(SQLCA)

sCiNo = Message.StringParm

this.Title = this.Title + '[C/I번호 : '+sCiNo+' ]'

IF dw_list.Retrieve(sCiNo,Gs_Gubun) <=0 then
	F_MessageChk(14,'')
	Close(w_kifa14a)
	Return
END IF


	


end event

type p_exit from uo_picture within w_kifa14a
integer x = 4274
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
		IF dw_list.GetItemString(k,"accod") = "" OR IsNull(dw_list.GetItemString(k,"accod")) THEN
			F_Messagechk(1,'[계정과목]')
			dw_list.ScrollToRow(k)
			dw_list.SetColumn("accod")
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

Close(w_kifa14a)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type dw_list from datawindow within w_kifa14a
integer x = 59
integer y = 160
integer width = 4384
integer height = 1944
integer taborder = 10
string dataobject = "d_kifa14a1"
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
   	WHERE ( "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAcCode);
				
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[계정과목]')
		this.SetItem(this.GetRow(),"accode",snull)
		this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",snull)
		Return 1
	ELSE
		this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",sAcName)
	END IF
END IF

end event

event rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

IF this.GetColumnName() ="accode" THEN

	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"accode"),1)

	IF IsNull(lstr_account.acc1_cd) then
   	lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
   	lstr_account.acc2_cd = ""
	end if

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	this.SetItem(this.GetRow(),"accode" ,lstr_account.acc1_cd+lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"kfz01om0_acc2_nm",lstr_account.acc2_nm)
END IF
end event

type rr_1 from roundrectangle within w_kifa14a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 152
integer width = 4411
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

