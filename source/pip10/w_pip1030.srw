$PBExportHeader$w_pip1030.srw
$PBExportComments$** 수당기준등록
forward
global type w_pip1030 from w_inherite_standard
end type
type dw_1 from datawindow within w_pip1030
end type
type rr_1 from roundrectangle within w_pip1030
end type
end forward

global type w_pip1030 from w_inherite_standard
string title = "수당기준등록"
dw_1 dw_1
rr_1 rr_1
end type
global w_pip1030 w_pip1030

type variables
string is_gubn
end variables

on w_pip1030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pip1030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SettransObject(sqlca)
dw_insert.SettransObject(sqlca)
//dw_1.insertrow(0)

DataWindowChild dw_child

IF dw_1.GetChild("allow",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('1') <=0 THEN RETURN 
END IF

dw_1.insertrow(0)

is_gubn = '1'

end event

type p_mod from w_inherite_standard`p_mod within w_pip1030
end type

event p_mod::clicked;call super::clicked;IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN


IF dw_insert.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	Return
END IF

dw_insert.Setfocus()
dw_insert.ScrollToRow(dw_insert.RowCount())

end event

type p_del from w_inherite_standard`p_del within w_pip1030
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_insert.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_insert.DeleteRow(il_currow)

IF dw_insert.Update() > 0 THEN
	commit;
	IF il_currow = 1 OR il_currow <= dw_insert.RowCount() THEN
	ELSE
		dw_insert.ScrollToRow(il_currow - 1)
		dw_insert.SetColumn(1)
		dw_insert.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_inq from w_inherite_standard`p_inq within w_pip1030
integer x = 3515
end type

event p_inq::clicked;call super::clicked;string ls_allow

if dw_1.Accepttext() = -1 then return

ls_allow = dw_1.GetitemString(1,'allow')
if IsNull(ls_allow) or ls_allow = '' then ls_allow = '%'

if dw_insert.retrieve(ls_allow) < 1 then	
	w_mdi_frame.sle_msg.text = '조회할 자료가 없습니다!!'
	Return
END IF


end event

type p_print from w_inherite_standard`p_print within w_pip1030
boolean visible = false
integer x = 2871
integer y = 32
end type

type p_can from w_inherite_standard`p_can within w_pip1030
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

p_inq.TriggerEvent(Clicked!)
end event

type p_exit from w_inherite_standard`p_exit within w_pip1030
end type

type p_ins from w_inherite_standard`p_ins within w_pip1030
integer x = 3689
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue, il_seq, il_mseq,i
string ls_allow,sgbn

IF dw_insert.RowCount() <=0 THEN
	il_currow = 1
ELSE	
	il_currow = dw_insert.Getrow() + 1
END IF

if dw_1.Accepttext() = -1 then return


if dw_1.GetitemString(1,'gubun') = '1' then
	sgbn = '1'
else
	sgbn = '2'
end if

ls_allow = dw_1.GetitemString(1,'allow')

select max(seq) into :il_seq
from p3_allowbasic;

if IsNull(il_seq) then il_seq = 0

if il_currow <> 1 then
	For i = 1 to dw_insert.rowcount()
		 il_mseq = dw_insert.GetitemNumber(i,'seq')
		 if il_mseq > il_seq then
			 il_seq = il_mseq
  		 end if
	Next
end if


IF il_currow >= 1 THEN	
	il_currow = il_currow	
	DataWindowChild dw_child

	IF dw_insert.GetChild("allowcode",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		IF dw_child.Retrieve(sgbn) <=0 THEN RETURN 
	END IF	

	dw_insert.InsertRow(il_currow)
	dw_insert.Setitem(il_currow, 'seq',il_seq + 1)
	if ls_allow = '' or IsNull(ls_allow) then 
   else
		dw_insert.Setitem(il_currow, 'allowcode',ls_allow)
	end if
	dw_insert.ScrollToRow(il_currow)	
	dw_insert.setcolumn(1)
	dw_insert.SetFocus()
END IF

w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"
end event

type p_search from w_inherite_standard`p_search within w_pip1030
boolean visible = false
integer x = 2693
integer y = 32
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip1030
boolean visible = false
integer x = 3067
integer y = 32
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip1030
boolean visible = false
integer x = 3241
integer y = 32
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip1030
integer x = 338
integer y = 304
integer width = 3758
integer height = 1904
string dataobject = "d_pip1030_2"
boolean border = false
end type

event dw_insert::editchanged;call super::editchanged;ib_any_typing = True
end event

event dw_insert::retrievestart;call super::retrievestart;Int rtncode

DataWindowChild state_child

rtncode = dw_insert.GetChild("allowcode", state_child)
IF rtncode = -1 THEN 
//	  MessageBox("확인","없슴")
//	  Return
END IF  

state_child.SetTransObject(SQLCA)



IF state_child.Retrieve(is_gubn) <= 0 THEN
	state_child.insertrow(0)
//	Return 1
END IF	
end event

type st_window from w_inherite_standard`st_window within w_pip1030
integer x = 2427
integer y = 4116
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip1030
integer x = 3424
integer y = 3944
end type

type cb_update from w_inherite_standard`cb_update within w_pip1030
integer x = 2322
integer y = 3912
integer height = 140
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip1030
integer x = 681
integer y = 3944
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip1030
integer x = 2688
integer y = 3944
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip1030
integer x = 315
integer y = 3944
end type

type st_1 from w_inherite_standard`st_1 within w_pip1030
integer x = 229
integer y = 4116
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip1030
integer x = 3054
integer y = 3944
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip1030
integer x = 3072
integer y = 4116
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip1030
integer x = 590
integer y = 4116
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip1030
integer x = 2281
integer y = 3884
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip1030
integer x = 279
integer y = 3884
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip1030
integer x = 242
integer y = 4064
end type

type dw_1 from datawindow within w_pip1030
integer x = 791
integer y = 16
integer width = 1787
integer height = 248
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1030_1"
boolean border = false
boolean livescroll = true
end type

event retrievestart;Int rtncode

DataWindowChild state_child

rtncode = dw_1.GetChild("tallowcode", state_child)
IF rtncode = -1 THEN 
//	  MessageBox("확인","없슴")
//	  Return
END IF  

state_child.SetTransObject(SQLCA)

string sgbn

this.Accepttext()
if this.GetitemString(1,'gubun') = '1' then
	sgbn = '1'
else
	sgbn = '2'
end if

IF state_child.Retrieve(sgbn) <= 0 THEN
	state_child.insertrow(0)
//	Return 1
END IF	
end event

event itemchanged;DataWindowChild dw_child
string sgbn

if dwo.Name = 'gubun' then
	is_gubn = this.gettext()
   dw_1.GetChild("allow", dw_child)  
   dw_child.SetTransObject(SQLCA)
   dw_child.Reset()
	IF dw_child.Retrieve(is_gubn) <= 0 THEN
		Return 1
	END IF
//	if is_gubn = '2' then
//   	dw_1.Setitem(1,'allow','06')
//	else
//		dw_1.Setitem(1,'allow','10')
//	end if
	p_inq.Triggerevent(Clicked!)
END IF	
end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_pip1030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 334
integer y = 296
integer width = 3776
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

