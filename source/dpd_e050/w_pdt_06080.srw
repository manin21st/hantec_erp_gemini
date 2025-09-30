$PBExportHeader$w_pdt_06080.srw
$PBExportComments$** 설비그룹별 소요량 등록
forward
global type w_pdt_06080 from w_inherite
end type
type dw_ip from u_key_enter within w_pdt_06080
end type
type dw_ins from u_key_enter within w_pdt_06080
end type
type dw_insert1 from u_key_enter within w_pdt_06080
end type
type rr_1 from roundrectangle within w_pdt_06080
end type
type rr_2 from roundrectangle within w_pdt_06080
end type
end forward

global type w_pdt_06080 from w_inherite
string title = "설비그룹별 소요량 등록"
boolean resizable = true
dw_ip dw_ip
dw_ins dw_ins
dw_insert1 dw_insert1
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_06080 w_pdt_06080

on w_pdt_06080.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_ins=create dw_ins
this.dw_insert1=create dw_insert1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_ins
this.Control[iCurrent+3]=this.dw_insert1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_pdt_06080.destroy
call super::destroy
destroy(this.dw_ip)
destroy(this.dw_ins)
destroy(this.dw_insert1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_insert1.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_pdt_06080
integer x = 2427
integer y = 184
integer width = 2153
integer height = 2104
integer taborder = 30
string dataobject = "d_pdt_06080_021"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06080
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06080
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06080
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06080
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06080
end type

type p_can from w_inherite`p_can within w_pdt_06080
end type

event p_can::clicked;call super::clicked;String grpcod1, grpcod2

w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

grpcod1 = Trim(dw_ip.object.grpcod1[1])
grpcod2 = Trim(dw_ip.object.grpcod2[1])
if IsNull(grpcod1) or grpcod1 = "" then grpcod1 = "."
if IsNull(grpcod2) or grpcod2 = "" then grpcod2 = "ZZZZZZ"

dw_insert.SetRedraw(False)
dw_insert.Retrieve(grpcod1, grpcod2)
dw_insert.SetRedraw(True)
dw_insert.setfocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type p_print from w_inherite`p_print within w_pdt_06080
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06080
integer x = 3922
end type

event p_inq::clicked;call super::clicked;setpointer(hourglass!)

// 소요수량이 0인것은 삭제한다.
Delete mchgrp_use
 Where use_qty = 0;

// 사용자별 그룹에 보유수량을 정리한다.
Update mchgrp_use
   Set save_qty	= 0;

// 사용자별 그룹에 규격을 저장한다.
insert into mchgrp_use
	  Select b.grpcod, b.spec, 0, 0
	    From mchmst b
		where not exists ( select 'x' from mchgrp_use c
								  where c.grpcod = b.grpcod and c.spec = b.spec)
		Group by b.grpcod, b.spec;
commit;

Update mchgrp_use a
	Set a.save_qty = (select NVL(count(*), 0)
							  From mchmst b
							 where a.grpcod = b.grpcod and a.spec = b.spec and b.pedat is null);
commit;


String grpcod1, grpcod2

if dw_ip.AcceptText() = -1 then 
	setpointer(arrow!)
	return
end if

grpcod1 = Trim(dw_ip.object.grpcod1[1])
grpcod2 = Trim(dw_ip.object.grpcod2[1])
if IsNull(grpcod1) or grpcod1 = "" then grpcod1 = "."
if IsNull(grpcod2) or grpcod2 = "" then grpcod2 = "ZZZZZZ"

if dw_insert1.Retrieve(grpcod1, grpcod2) < 1 then
	f_message_chk(50, "[설비그룹별 소요현황]")
end if

dw_insert1.setfocus()

setpointer(arrow!)

return


end event

type p_del from w_inherite`p_del within w_pdt_06080
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_06080
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long i, Lsqlcode

if dw_insert1.AcceptText() = -1 then return

if f_msg_update() = -1 then return

IF dw_insert1.Update() > 0 THEN
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	Lsqlcode = dec(sqlca.sqlcode)
	f_message_chk(Lsqlcode, "[저장실패]")
	w_mdi_frame.sle_msg.text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_exit from w_inherite`cb_exit within w_pdt_06080
boolean visible = false
integer x = 3470
integer y = 12
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06080
boolean visible = false
integer x = 2784
integer y = 12
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06080
boolean visible = false
integer x = 503
integer y = 2372
end type

type cb_del from w_inherite`cb_del within w_pdt_06080
boolean visible = false
integer x = 1934
integer y = 2464
integer taborder = 50
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;String grpcod, spec
Long   crow, fndrow

if f_msg_delete() = -1 then return
crow = dw_insert.GetRow()
if crow < 1 or crow > dw_insert.RowCount() then
	w_mdi_frame.sle_msg.text = "해당 장비를 선택한 다음 진행하세요!"
	return
end if	

grpcod = Trim(dw_insert.object.grpcod[crow])
spec = Trim(dw_insert.object.spec[crow])
dw_insert.object.use_qty[crow] = 0

fndrow = dw_ins.Find("grpcod = '" + grpcod + "' and spec = '" + spec + "'", 1, dw_ins.RowCount())
if fndrow >= 1 then 
	dw_ins.DeleteRow(fndrow)
	if dw_ins.Update() <> 1 then
      ROLLBACK;
      f_message_chk(31,'[삭제실패 : 설비 소요 현황]') 
      w_mdi_frame.sle_msg.text = "삭제 작업 실패!"
		return
   else
      COMMIT;
	end if
end if
w_mdi_frame.sle_msg.text = "삭제 되었습니다!"
Return



end event

type cb_inq from w_inherite`cb_inq within w_pdt_06080
boolean visible = false
integer x = 2441
integer y = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_06080
boolean visible = false
integer x = 869
integer y = 2364
end type

type st_1 from w_inherite`st_1 within w_pdt_06080
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06080
boolean visible = false
integer x = 3131
integer y = 12
integer taborder = 70
end type

type cb_search from w_inherite`cb_search within w_pdt_06080
boolean visible = false
integer x = 1920
integer y = 2364
integer width = 334
integer taborder = 90
string text = "IMAGE"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_06080
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06080
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06080
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06080
end type

type dw_ip from u_key_enter within w_pdt_06080
integer y = 16
integer width = 2258
integer height = 152
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_06080_01"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

type dw_ins from u_key_enter within w_pdt_06080
boolean visible = false
integer x = 361
integer y = 804
integer width = 1591
integer height = 604
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pdt_06080_03"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_insert1 from u_key_enter within w_pdt_06080
integer x = 32
integer y = 184
integer width = 2345
integer height = 2104
integer taborder = 20
string dataobject = "d_pdt_06080_02"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;IF CURRENTROW < 1 THEN RETURN

dw_insert.retrieve(this.getitemstring(this.getrow(), "grpcod"), this.getitemstring(this.getrow(), "spec"))
end event

event getfocus;IF this.getROW() < 1 THEN RETURN

dw_insert.retrieve(this.getitemstring(this.getrow(), "grpcod"), this.getitemstring(this.getrow(), "spec"))
end event

type rr_1 from roundrectangle within w_pdt_06080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 176
integer width = 2386
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_06080
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2414
integer y = 176
integer width = 2190
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

