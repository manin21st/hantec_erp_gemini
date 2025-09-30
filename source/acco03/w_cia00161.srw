$PBExportHeader$w_cia00161.srw
$PBExportComments$원가수불부(수량 상세)
forward
global type w_cia00161 from window
end type
type dw_list2 from datawindow within w_cia00161
end type
type rr_1 from roundrectangle within w_cia00161
end type
type p_exit from picture within w_cia00161
end type
type dw_list from datawindow within w_cia00161
end type
type dw_ip from u_key_enter within w_cia00161
end type
type rr_2 from roundrectangle within w_cia00161
end type
end forward

global type w_cia00161 from window
integer width = 3419
integer height = 2236
boolean titlebar = true
string title = "원가수불부 수량 상세 내역"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
dw_list2 dw_list2
rr_1 rr_1
p_exit p_exit
dw_list dw_list
dw_ip dw_ip
rr_2 rr_2
end type
global w_cia00161 w_cia00161

type variables
String IsItnbr
end variables

on w_cia00161.create
this.dw_list2=create dw_list2
this.rr_1=create rr_1
this.p_exit=create p_exit
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.rr_2=create rr_2
this.Control[]={this.dw_list2,&
this.rr_1,&
this.p_exit,&
this.dw_list,&
this.dw_ip,&
this.rr_2}
end on

on w_cia00161.destroy
destroy(this.dw_list2)
destroy(this.rr_1)
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.rr_2)
end on

event open;this.x = 300
this.y = 450

String  sIoYm,sPdtGu,sItdsc,sMsg,sIttyp

sMsg = Message.StringParm

sPdtGu  = Left(sMsg,1)
sIoYm   = Mid(sMsg,2,6)
IsItnbr = Mid(sMsg,8,20)

select b.itdsc, b.ittyp into :sItdsc, :sIttyp from itemas b where b.itnbr = :IsItnbr  ;

dw_ip.SetTransObject(Sqlca)

dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetItem(1,"io_ym",  sIoYm)
dw_ip.SetItem(1,"itnbr",  IsItnbr)
dw_ip.SetItem(1,"itdsc",  sItdsc)
dw_ip.SetItem(1,"ittyp",  sIttyp)
dw_ip.SetItem(1,"pdtgu",  sPdtGu)

dw_list.SetTransObject(Sqlca)
dw_list.Retrieve(sIttyp)

dw_list2.SetTransObject(Sqlca)
dw_list2.Retrieve(sIoYm,IsItnbr,sPdtGu)

end event

type dw_list2 from datawindow within w_cia00161
integer x = 1577
integer y = 252
integer width = 1769
integer height = 1852
integer taborder = 30
string title = "none"
string dataobject = "dw_cia00161_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cia00161
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 240
integer width = 1504
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_exit from picture within w_cia00161
integer x = 3186
integer y = 12
integer width = 178
integer height = 144
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;Close(w_cia00161)
end event

type dw_list from datawindow within w_cia00161
integer x = 59
integer y = 248
integer width = 1472
integer height = 1852
integer taborder = 20
string title = "none"
string dataobject = "dw_cia00161_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_ip from u_key_enter within w_cia00161
integer x = 37
integer y = 12
integer width = 2235
integer height = 228
integer taborder = 10
string dataobject = "dw_cia00161_1"
boolean border = false
end type

event itemchanged;String  sGbn,sItnbr,sIoYm,sPdtGu,sEleGbn
Double  dAmount
Integer iFindRow

if this.GetColumnName() = 'gbn' then
	sGbn = this.GetText()
	
	sItnbr = this.GetItemString(1,"itnbr")
	sIoym  = this.GetItemString(1,"io_ym")
	sPdtGu = this.GetItemString(1,"pdtgu")
	
	dw_list.SetRedraw(False)
	if sGbn = '1' then					/*재료비*/
		select sum(nvl(a.ip_mat,0)) into :dAmount	from cia24t a where a.io_yymm = :sIoYm and a.itnbr = :sItnbr and a.pdtgu = :sPdtGu;
		if sqlca.sqlcode <> 0 then
			dAmount = 0
		end if
		dw_list.DataObject ='dw_cia00141_2'
		dw_list.SetTransObject(Sqlca)
		dw_list.Retrieve(sIoYm,IsItnbr,sPdtGu)
		
		dw_list2.DataObject ='dw_cia00141_21'
		dw_list2.SetTransObject(Sqlca)
		dw_list2.Retrieve(sIoYm,IsItnbr,sPdtGu)
		
	elseif sGbn = '2' or sGbn = '3' then				/*노무비*/
		dw_list.DataObject ='dw_cia00141_3'
		dw_list.SetTransObject(Sqlca)
		
		if sGbn = '2' then
			select sum(nvl(a.ip_lab,0)) into :dAmount	from cia24t a where a.io_yymm = :sIoYm and a.itnbr = :sItnbr and a.pdtgu = :sPdtGu;
			if sqlca.sqlcode <> 0 then
				dAmount = 0
			end if
			sEleGbn = '20'
		else
			select sum(nvl(a.ip_over,0)) into :dAmount	from cia24t a where a.io_yymm = :sIoYm and a.itnbr = :sItnbr and a.pdtgu = :sPdtGu;
			if sqlca.sqlcode <> 0 then
				dAmount = 0
			end if
			sEleGbn = '30'
		end if
		if dw_list.Retrieve(sIoYm,sEleGbn,sPdtGu,IsItnbr) > 0 then
//			iFindRow = dw_list.Find("cia21t_itnbr = '"+IsItnbr+"'",1,dw_list.RowCount())
//			if iFindRow > 0 then
//				dw_list.SelectRow(0,False)
//				dw_list.SelectRow(iFindRow,True)
//				dw_list.ScrollToRow(iFindRow)
//			else
//				dw_list.Reset()
//			end if
		end if
		dw_list2.Reset()
	end if
	dw_list.SetRedraw(True)
	
	this.SetItem(1,"amt",dAmount)
	
end if
end event

type rr_2 from roundrectangle within w_cia00161
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1568
integer y = 244
integer width = 1801
integer height = 1872
integer cornerheight = 40
integer cornerwidth = 55
end type

