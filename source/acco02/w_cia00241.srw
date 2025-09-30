$PBExportHeader$w_cia00241.srw
$PBExportComments$원가요소 배부내역표-품목별상세
forward
global type w_cia00241 from window
end type
type p_exit from picture within w_cia00241
end type
type dw_2 from datawindow within w_cia00241
end type
type dw_1 from datawindow within w_cia00241
end type
type rr_1 from roundrectangle within w_cia00241
end type
end forward

global type w_cia00241 from window
integer width = 4192
integer height = 2200
boolean titlebar = true
string title = "품목별 배부 내역"
long backcolor = 32106727
p_exit p_exit
dw_2 dw_2
dw_1 dw_1
rr_1 rr_1
end type
global w_cia00241 w_cia00241

on w_cia00241.create
this.p_exit=create p_exit
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.dw_2,&
this.dw_1,&
this.rr_1}
end on

on w_cia00241.destroy
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;String  sMsg,sPdtGu,sAccode,sCostName,sAccName,sIoYm,sCostSaup,sIoYmt
Double  dAmount,dTotim

sMsg = Message.StringParm

sCostSaup = Left(sMsg,2)
sPdtGu    = Mid(sMsg,3,4)
sAccode   = Mid(sMsg,7,7)
sIoYm     = Mid(sMsg,14,6)
sIoYmt    = Mid(sMsg,20,6)
sCostName = Mid(sMsg,26,30)

dw_1.SetTransObject(Sqlca)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1,"cost_nm", sCostName)
dw_1.SetItem(1,"accode",  sAcCode)

select acc2_nm into :sAccName from kfz01om0 where acc1_cd||acc2_cd = :sAcCode;
dw_1.SetItem(1,"acname",  sAccName)

select sum(nvl(totim,0)) into :dTotIm 	from cia07t1	
	where yymm = :sIoYm and yymmt = :sIoYmt and pdtgu = :sPdtGu ;
dw_1.SetItem(1,"tot_time",  dTotIm)

select sum(nvl(a.self_cost,0) + nvl(a.ind_cost,0) + nvl(a.dptcom_cost,0) + nvl(a.com_cost,0))
	into :dAmount
	from cia20ot a, cia02m b
	where a.io_yymm = :sIoYm and a.io_yymmt = :sIoYmt and a.accode = :sAcCode and a.ucost_cd = b.cost_cd and
			b.cost_gua = :sPdtGu ;
dw_1.SetItem(1,"amount",  dAmount)
			
dw_2.SetTransObject(Sqlca)
dw_2.Reset()

dw_2.Retrieve(sIoYm,sIoymT,sAcCode,sPdtGu)

this.x = 300
this.y = 450
end event

type p_exit from picture within w_cia00241
integer x = 3959
integer width = 178
integer height = 144
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;Close(w_cia00241)
end event

type dw_2 from datawindow within w_cia00241
integer x = 41
integer y = 168
integer width = 4073
integer height = 1884
integer taborder = 20
string title = "none"
string dataobject = "dw_cia002412"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_cia00241
integer x = 18
integer y = 12
integer width = 3799
integer height = 144
integer taborder = 10
string title = "none"
string dataobject = "dw_cia002411"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cia00241
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 160
integer width = 4105
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

