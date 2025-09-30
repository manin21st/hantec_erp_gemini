$PBExportHeader$w_mat_03010_popup.srw
$PBExportComments$** 주기 실사 등록(사유 popup)
forward
global type w_mat_03010_popup from window
end type
type p_1 from uo_picture within w_mat_03010_popup
end type
type p_2 from uo_picture within w_mat_03010_popup
end type
type dw_detail from datawindow within w_mat_03010_popup
end type
end forward

global type w_mat_03010_popup from window
integer x = 1815
integer y = 664
integer width = 1408
integer height = 816
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
p_2 p_2
dw_detail dw_detail
end type
global w_mat_03010_popup w_mat_03010_popup

type variables

end variables

on w_mat_03010_popup.create
this.p_1=create p_1
this.p_2=create p_2
this.dw_detail=create dw_detail
this.Control[]={this.p_1,&
this.p_2,&
this.dw_detail}
end on

on w_mat_03010_popup.destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.dw_detail)
end on

event open;string sname, ls_pspec
str_itmcyc ists_itmcyc

ists_itmcyc = Message.PowerObjectParm	

dw_detail.settransobject(sqlca)

dw_detail.retrieve(gs_sabu, ists_itmcyc.depot, ists_itmcyc.sicdat, ists_itmcyc.siseq, &
                   ists_itmcyc.itnbr, ists_itmcyc.pspec )

if isnull(gs_gubun) then 
   dw_detail.setitem(1, 'iogbn', gs_gubun)
   dw_detail.setitem(1, 'ionam', gs_gubun)
   dw_detail.setitem(1, 'crtgub', 'N')
	dw_detail.SetTabOrder('crtgub', 0)
elseif gs_gubun = 'Y' then 
	dw_detail.SetTabOrder('bigo', 0)
	dw_detail.SetTabOrder('crtgub', 0)
else
	SELECT "IOMATRIX"."IONAM"  
	  INTO :sname  
	  FROM "IOMATRIX"  
	 WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND  
			 ( "IOMATRIX"."IOGBN" = :gs_gubun )   ;

   dw_detail.setitem(1, 'iogbn', gs_gubun)
   dw_detail.setitem(1, 'ionam', sname)
   dw_detail.setitem(1, 'crtgub', 'Y')
end if

dw_detail.setfocus() 	
	
	
	

end event

type p_1 from uo_picture within w_mat_03010_popup
integer x = 1161
integer width = 178
integer taborder = 30
string pointer = "c:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;setnull(gs_code)
setnull(gs_codename)
gs_gubun = 'N'

close(parent)
end event

type p_2 from uo_picture within w_mat_03010_popup
integer x = 983
integer width = 178
integer taborder = 20
string pointer = "c:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;if dw_detail.AcceptText() = -1 then return 

gs_gubun    = 'Y'
gs_code     = dw_detail.GetItemString(1,'bigo')
gs_codename = dw_detail.GetItemString(1,'crtgub')

close(parent) 
end event

type dw_detail from datawindow within w_mat_03010_popup
event ue_key pbm_dwnkey
event ue_presenter pbm_dwnprocessenter
integer x = 14
integer y = 148
integer width = 1358
integer height = 628
integer taborder = 10
string dataobject = "d_mat_03010_popup"
boolean border = false
boolean livescroll = true
end type

