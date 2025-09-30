$PBExportHeader$w_kgld69a.srw
$PBExportComments$합계잔액시산표 상세 조회-잔액 조회(거래처별)
forward
global type w_kgld69a from window
end type
type dw_2 from datawindow within w_kgld69a
end type
type dw_1 from datawindow within w_kgld69a
end type
type rr_1 from roundrectangle within w_kgld69a
end type
end forward

global type w_kgld69a from window
integer x = 206
integer y = 100
integer width = 4658
integer height = 2352
boolean titlebar = true
string title = "잔액 조회"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_kgld69a w_kgld69a

on w_kgld69a.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_kgld69a.destroy
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;
String sMsgParm,sSaupj,sAcc,sAccName,sYear,sMonth

F_Window_Center_Response(This)

sMsgParm = Message.StringParm

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.Insertrow(0)

sSaupj  = Gs_Gubun
sYear   = Mid(sMsgParm,1,4)
sMonth  = Mid(sMsgParm,5,2)

sAcc    = Mid(sMsgParm,7,7)

select acc2_nm 	into :sAccName 	from kfz01om0
	where acc1_cd||acc2_cd = :sAcc;

dw_1.SetItem(1,"saupj",   sSaupj)
dw_1.SetItem(1,"acc_ym",  sYear+sMonth)
dw_1.SetItem(1,"accno",   sAcc)
dw_1.SetItem(1,"accname", sAccName)

dw_2.Reset()
dw_2.Retrieve(sSaupj,sAcc,sYear,sMonth)
end event

type dw_2 from datawindow within w_kgld69a
integer x = 73
integer y = 200
integer width = 4521
integer height = 2008
string dataobject = "dw_kgld69a2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;IF dwo.name = 'dcb_report' THEN										/*장부 조회*/
	Gs_Gubun = dw_1.GetItemString(1,"saupj")
	
	OpenWithParm(w_kgld69b,dw_1.GetItemString(1,"acc_ym") + &
								  dw_1.GetItemString(1,"accno") + &
								  this.GetItemString(this.GetRow(),"person_cd"))
END IF
end event

type dw_1 from datawindow within w_kgld69a
integer x = 50
integer y = 12
integer width = 3849
integer height = 176
string dataobject = "dw_kgld69a1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kgld69a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 192
integer width = 4553
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

