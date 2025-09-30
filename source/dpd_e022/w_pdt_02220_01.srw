$PBExportHeader$w_pdt_02220_01.srw
$PBExportComments$** 작업우선순위등록-상세정보
forward
global type w_pdt_02220_01 from window
end type
type p_exit from uo_picture within w_pdt_02220_01
end type
type p_mod from uo_picture within w_pdt_02220_01
end type
type dw_1 from datawindow within w_pdt_02220_01
end type
end forward

global type w_pdt_02220_01 from window
integer x = 265
integer y = 1076
integer width = 3122
integer height = 908
boolean titlebar = true
string title = "작업우선순위-[상세]"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
dw_1 dw_1
end type
global w_pdt_02220_01 w_pdt_02220_01

on w_pdt_02220_01.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_1=create dw_1
this.Control[]={this.p_exit,&
this.p_mod,&
this.dw_1}
end on

on w_pdt_02220_01.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_1)
end on

event open;f_window_center_response(this)

dw_1.settransobject(sqlca)
dw_1.retrieve(gs_sabu, gs_code, gs_codename)

//dw_1.setitem(1, "momast_wrkctr_order_mchcod", gs_area)
dw_1.setitem(1, "momast_wrkctr_order_wrkctr", gs_gubun)
dw_1.setitem(1, "momast_wrkctr_order_user_stime", Left(gs_codename2, 4))
dw_1.setitem(1, "momast_wrkctr_order_user_etime", Right(gs_codename2, 4))

SetNull(gs_code)
SetNull(gs_codeName)
end event

type p_exit from uo_picture within w_pdt_02220_01
integer x = 2857
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;SetNull(gs_code)
SetNull(gs_gubun)
SetNull(gs_codename)
SetNull(gs_codename2)

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_mod from uo_picture within w_pdt_02220_01
integer x = 2683
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;if dw_1.accepttexT() = -1 then return

if f_msg_update() = -1 then return

// Error check
String swkctr, smchcod, sstime, setime

sWkctr  = dw_1.getitemstring(1, "momast_wrkctr_order_wrkctr")
smchcod = dw_1.getitemstring(1, "momast_wrkctr_order_mchcod")
sstime  = dw_1.getitemstring(1, "momast_wrkctr_order_user_stime")
setime  = dw_1.getitemstring(1, "momast_wrkctr_order_user_etime")

if Isnull(swkctr) or trim(swkctr) = '' then
	MessageBox("작업장", "작업장은 필수입니다", stopsign!)
	dw_1.setcolumn("momast_wrkctr_order_wkctr")
	dw_1.setfocus()
	return
end if

gs_code 		 = swkctr
gs_gubun		 = smchcod
gs_codename  = sstime
gs_codename2 = setime

close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type dw_1 from datawindow within w_pdt_02220_01
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 5
integer y = 168
integer width = 3086
integer height = 620
integer taborder = 10
string dataobject = "d_pdt_02220_03"
boolean border = false
end type

event ue_key;if key  = keyf1! then
	this.triggerevent(rbuttondown!)
end if
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;string colname
long   lrow

SETNULL(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

colname = this.getcolumnname()
lrow    = this.getrow()

if     colname = "momast_wrkctr_order_mchcod" then
		 gs_code = this.gettext()
		 gs_gubun    = this.getitemstring(lrow, "momast_wrkctr_order_wrkctr")
		 gs_codename = this.getitemstring(lrow, "wrkctr_wcdsc")
		 open(w_mchmst_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "momast_wrkctr_order_mchcod", gs_code)
		 this.triggerevent(itemchanged!)
elseif colname = "momast_wrkctr_order_wrkctr" then
		 gs_code = this.gettext()
		 open(w_workplace_popup)
	  	 IF gs_code = '' or isnull(gs_code) then return 
		 this.setitem(lrow, "momast_wrkctr_order_wrkctr", gs_code)
		 this.triggerevent(itemchanged!)
end if


end event

event itemerror;return 1
end event

event itemchanged;String   sreff, sreff1
integer  ireturn
Long		Lrow

Lrow = this.getrow()

if this.getcolumnname() = "momast_wrkctr_order_wrkctr" then
	ireturn = 0
	sreff = this.gettext()
	select a.wcdsc
	  into :sreff1 
	  from wrkctr a
	 where a.wkctr = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(90,'[작업장]')
		setnull(sreff) 
		setnull(sreff1)		
		ireturn = 1
	end if
	
	this.setitem(lrow, "momast_wrkctr_order_wrkctr", sreff)
	this.setitem(lrow, "wrkctr_wcdsc", 					 sreff1)
	return ireturn
elseif this.getcolumnname() = "momast_wrkctr_order_mchcod" then
	ireturn = 0
	sreff = this.gettext()
	select mchnam
	  into :sreff1
	  from mchmst
	 where sabu = :gs_sabu and mchno = :sreff;
	if sqlca.sqlcode <> 0 then
		f_message_chk(92,'[설비]')
		setnull(sreff)
		setnull(sreff1)
		ireturn = 1
	end if
	this.setitem(lrow, "momast_wrkctr_order_mchcod", sreff)	
	this.setitem(lrow, "mchmst_mchnam", sreff1)
	return ireturn	
end if
end event

