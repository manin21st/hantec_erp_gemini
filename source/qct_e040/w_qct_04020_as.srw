$PBExportHeader$w_qct_04020_as.srw
$PBExportComments$A/S의뢰 품목내역조회 및 선택
forward
global type w_qct_04020_as from window
end type
type p_1 from uo_picture within w_qct_04020_as
end type
type dw_1 from datawindow within w_qct_04020_as
end type
type rr_1 from roundrectangle within w_qct_04020_as
end type
end forward

global type w_qct_04020_as from window
integer x = 160
integer y = 804
integer width = 3063
integer height = 2212
boolean titlebar = true
string title = "샘플 의뢰 내역[품목]"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
dw_1 dw_1
rr_1 rr_1
end type
global w_qct_04020_as w_qct_04020_as

type variables
datawindow dwname
end variables

on w_qct_04020_as.create
this.p_1=create p_1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.dw_1,&
this.rr_1}
end on

on w_qct_04020_as.destroy
destroy(this.p_1)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;F_Window_Center_Response(This)

dwname = message.powerobjectparm

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code)
end event

type p_1 from uo_picture within w_qct_04020_as
integer x = 2752
integer width = 178
integer taborder = 1
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;dw_1.accepttext()

Long Lrow, Linsert, Lsel, Lcnt

For Lrow = 1 to dw_1.rowcount()
	
	 Lsel = dw_1.getitemdecimal(Lrow, "sel")
	 
	 For Lcnt = 1 to Lsel
	
		 Linsert = dwname.insertrow(0)
		
		 dwname.setitem(Linsert, "sabu",  		gs_sabu)
		 dwname.setitem(Linsert, "itnbr",  		dw_1.getitemstring(Lrow, "itnbr"))
		 dwname.setitem(Linsert, "itdsc",  		dw_1.getitemstring(Lrow, "itdsc"))
		 dwname.setitem(Linsert, "ispec",  		dw_1.getitemstring(Lrow, "ispec"))
		 dwname.setitem(Linsert, "ilotno", 		dw_1.getitemstring(Lrow, "ilotno"))	 
		 dwname.setitem(Linsert, "asseq",  		dw_1.getitemdecimal(Lrow, "asseq"))	 		 
		 dwname.setitem(Linsert, "as_jpno",  	dw_1.getitemstring(Lrow, "as_jpno"))
		 dwname.setitem(Linsert, "rcvdat",  	dw_1.getitemstring(Lrow, "rcvdat"))		 
		 
	Next
	
Next

close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

type dw_1 from datawindow within w_qct_04020_as
integer x = 59
integer y = 160
integer width = 2921
integer height = 1892
integer taborder = 10
string dataobject = "d_qct_04020_as"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_qct_04020_as
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 152
integer width = 2967
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

