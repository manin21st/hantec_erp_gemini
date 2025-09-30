$PBExportHeader$w_cia00141.srw
$PBExportComments$제품별 제조원가 명세서-상세
forward
global type w_cia00141 from window
end type
type dw_list2 from datawindow within w_cia00141
end type
type rr_1 from roundrectangle within w_cia00141
end type
type p_exit from picture within w_cia00141
end type
type dw_list from datawindow within w_cia00141
end type
type dw_ip from u_key_enter within w_cia00141
end type
type rr_2 from roundrectangle within w_cia00141
end type
end forward

global type w_cia00141 from window
integer width = 4192
integer height = 2200
boolean titlebar = true
string title = "제품별 제조원가 상세 내역"
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
global w_cia00141 w_cia00141

type variables
String IsItnbr
end variables

on w_cia00141.create
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

on w_cia00141.destroy
destroy(this.dw_list2)
destroy(this.rr_1)
destroy(this.p_exit)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.rr_2)
end on

event open;this.x = 300
this.y = 450

String  sIoYm,sPdtGu,sItdsc,sMsg,sIoYmt
Double  dAmount,dTotIm

sMsg = Message.StringParm

sPdtGu  = Left(sMsg,1)
sIoYm   = Mid(sMsg,2,6)
sIoYmt  = Mid(sMsg,8,6)
IsItnbr = Mid(sMsg,14,20)

select b.itdsc,	a.pdtgu,	sum(nvl(a.ip_mat,0))
	into :sItdsc,	:sPdtGu,	:dAmount
	from cia24t a, itemas b
	where a.io_yymm = :sIoYm and a.io_yymmt = :sIoYmt and a.itnbr = :IsItnbr and
			a.itnbr = b.itnbr and a.pdtgu = :sPdtGu
	group by b.itdsc,	a.pdtgu ;
if sqlca.sqlcode <> 0 then
	SetNull(sPdtGu)
end if

select sum(nvl(totim,0)) into :dTotIm 	from cia07t1	where yymm = :sIoYm and yymmt = :sIoYmt and pdtgu = :sPdtGu ;

dw_ip.SetTransObject(Sqlca)

dw_ip.Reset()
dw_ip.InsertRow(0)

dw_ip.SetItem(1,"io_ym",  sIoYm)
dw_ip.SetItem(1,"io_ymt",  sIoYmt)
dw_ip.SetItem(1,"itnbr",  IsItnbr)
dw_ip.SetItem(1,"itdsc",  sItdsc)
dw_ip.SetItem(1,"pdtgu",  sPdtGu)
dw_ip.SetItem(1,"amt",    dAmount)
dw_ip.SetItem(1,"totim",  dTotIm)

dw_list.DataObject ='dw_cia00141_2'
dw_list.SetTransObject(Sqlca)
dw_list.Retrieve(sIoYm,sIoYmT,IsItnbr,sPdtGu)

dw_list2.DataObject ='dw_cia00141_21'
dw_list2.SetTransObject(Sqlca)
dw_list2.Retrieve(sIoYm,sIoYmt,IsItnbr,sPdtGu)
end event

type dw_list2 from datawindow within w_cia00141
integer x = 55
integer y = 1572
integer width = 4037
integer height = 512
integer taborder = 30
string title = "none"
string dataobject = "dw_cia00141_21"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cia00141
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 228
integer width = 4073
integer height = 1316
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_exit from picture within w_cia00141
integer x = 3959
integer width = 178
integer height = 144
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;Close(w_cia00141)
end event

type dw_list from datawindow within w_cia00141
integer x = 59
integer y = 236
integer width = 4041
integer height = 1300
integer taborder = 20
string title = "none"
string dataobject = "dw_cia00141_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_ip from u_key_enter within w_cia00141
integer x = 37
integer y = 12
integer width = 3712
integer height = 208
integer taborder = 10
string dataobject = "dw_cia00141_1"
boolean border = false
end type

event itemchanged;String  sGbn,sItnbr,sIoYm,sIoYmt,sPdtGu,sEleGbn
Double  dAmount
Integer iFindRow

if this.GetColumnName() = 'gbn' then
	sGbn = this.GetText()
	
	sItnbr = this.GetItemString(1,"itnbr")
	sIoym  = this.GetItemString(1,"io_ym")
	sIoymt = this.GetItemString(1,"io_ymt")
	sPdtGu = this.GetItemString(1,"pdtgu")
	
	dw_list.SetRedraw(False)
	if sGbn = '1' then					/*재료비*/
		select sum(nvl(a.ip_mat,0)) into :dAmount	from cia24t a where a.io_yymm = :sIoYm and a.itnbr = :sItnbr and a.pdtgu = :sPdtGu;
		if sqlca.sqlcode <> 0 then
			dAmount = 0
		end if
		dw_list.DataObject ='dw_cia00141_2'
		dw_list.SetTransObject(Sqlca)
		dw_list.Retrieve(sIoYm,sIoymt,IsItnbr,sPdtGu)
		
		dw_list2.DataObject ='dw_cia00141_21'
		dw_list2.SetTransObject(Sqlca)
		dw_list2.Retrieve(sIoYm,sIoymt,IsItnbr,sPdtGu)
		
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
		if dw_list.Retrieve(sIoYm,sIoymt,sEleGbn,sPdtGu,IsItnbr) > 0 then
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

type rr_2 from roundrectangle within w_cia00141
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 1564
integer width = 4073
integer height = 532
integer cornerheight = 40
integer cornerwidth = 55
end type

