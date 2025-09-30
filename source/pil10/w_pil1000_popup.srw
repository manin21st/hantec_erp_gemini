$PBExportHeader$w_pil1000_popup.srw
$PBExportComments$**종업원대여금기본자료입력(상환계획등록)
forward
global type w_pil1000_popup from w_inherite_popup
end type
type p_ins from uo_picture within w_pil1000_popup
end type
type p_mod from uo_picture within w_pil1000_popup
end type
type p_del from uo_picture within w_pil1000_popup
end type
type rr_1 from roundrectangle within w_pil1000_popup
end type
end forward

global type w_pil1000_popup from w_inherite_popup
integer x = 2011
integer width = 1897
integer height = 1824
string title = "상환계획등록"
boolean controlmenu = true
p_ins p_ins
p_mod p_mod
p_del p_del
rr_1 rr_1
end type
global w_pil1000_popup w_pil1000_popup

type variables
string iempno,igubn
Boolean ib_any_typing 
double ilendamt
end variables

forward prototypes
public function integer wf_master_read ()
public function integer wf_required_check (integer ll_row)
end prototypes

public function integer wf_master_read ();  
   SELECT "P3_LENDMST"."LENDAMT"  
    INTO :ilendamt  
    FROM "P3_LENDMST"  
   WHERE "P3_LENDMST"."EMPNO" = :iempno  AND
	      "P3_LENDMST"."LENDGUBN" =:igubn;
	
	if sqlca.sqlcode <> 0 then
		return -1
	end if
	
return 1
end function

public function integer wf_required_check (integer ll_row);
String syymm
Double spayrestamt,smeedrestamt,ilamt,totalamt

dw_1.AcceptText()
syymm        = dw_1.GetItemString(ll_row,"skedualdate")
spayrestamt  = dw_1.GetItemNumber(ll_row,"payrestamt") 
smeedrestamt = dw_1.GetItemNumber(ll_row,"meedrestamt") 
ilamt        = dw_1.GetItemNumber(ll_row,"ilsiamt") 

IF syymm ="" OR IsNull(syymm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_1.SetColumn("skedualdate")
	dw_1.Setfocus()
	Return -1
ELSE
	IF f_datechk(syymm + "01" ) = -1 THEN
		MessageBox("확 인","년월을 확인하세요!!")
		dw_1.SetColumn("skedualdate")
		dw_1.Setfocus()
	Return -1
   END IF
END IF

IF (spayrestamt = 0 OR IsNull(spayrestamt)) AND &
	(smeedrestamt = 0 OR IsNull(smeedrestamt)) AND & 
	(ilamt = 0 OR IsNull(ilamt)) THEN	
	MessageBox("확 인","공제금액을 입력하세요!!")
	dw_1.SetColumn("payrestamt")
	dw_1.SetFocus()
	Return -1
END IF

//*상환금액check *//

totalamt        = dw_1.GetItemnumber(1,"totalamt")

IF  ilendamt < totalamt THEN
	Messagebox("확인","대출금액이 월상환액 합계 ~r보다 작습니다.")
	dw_1.SetColumn("skedualdate")
	Return -1
END IF	
Return 1
end function

event open;call super::open;long i
string empnogu
dw_1.SetTransObject(SQLCA)

empnogu = Message.StringParm
i = pos(empnogu,'-')
iempno = mid(empnogu, 1, i - 1)
igubn = mid(empnogu, i + 1, 1)

if wf_master_read() = -1 then return

end event

on w_pil1000_popup.create
int iCurrent
call super::create
this.p_ins=create p_ins
this.p_mod=create p_mod
this.p_del=create p_del
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_ins
this.Control[iCurrent+2]=this.p_mod
this.Control[iCurrent+3]=this.p_del
this.Control[iCurrent+4]=this.rr_1
end on

on w_pil1000_popup.destroy
call super::destroy
destroy(this.p_ins)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_pil1000_popup
boolean visible = false
integer x = 0
integer y = 2352
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_pil1000_popup
integer x = 1682
integer y = 24
integer taborder = 50
end type

event p_exit::clicked;call super::clicked;Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pil1000_popup
boolean visible = false
integer x = 1723
integer y = 2204
integer taborder = 0
end type

type p_choose from w_inherite_popup`p_choose within w_pil1000_popup
boolean visible = false
integer x = 1897
integer y = 2204
integer taborder = 0
end type

type dw_1 from w_inherite_popup`dw_1 within w_pil1000_popup
integer x = 46
integer y = 220
integer width = 1778
integer height = 1452
integer taborder = 10
string dataobject = "d_pil1000_popup"
end type

type sle_2 from w_inherite_popup`sle_2 within w_pil1000_popup
boolean visible = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_pil1000_popup
boolean visible = false
end type

type cb_return from w_inherite_popup`cb_return within w_pil1000_popup
boolean visible = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pil1000_popup
boolean visible = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pil1000_popup
boolean visible = false
end type

type st_1 from w_inherite_popup`st_1 within w_pil1000_popup
boolean visible = false
end type

type p_ins from uo_picture within w_pil1000_popup
integer x = 1157
integer y = 24
integer width = 178
integer taborder = 20
boolean bringtotop = true
string pointer = "C:\erpman\cur\new.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_1.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_required_check(dw_1.GetRow())
	il_currow = dw_1.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = dw_1.RowCount()  + 1
	
	dw_1.InsertRow(il_currow)
	dw_1.SetItem(il_currow,"empno",iempno)
	dw_1.SetItem(il_currow,"lendgubn",igubn)
	dw_1.ScrollToRow(il_currow)
	dw_1.SetItem(il_currow,"gubn",'0')
	dw_1.setcolumn("skedualdate")
	dw_1.SetFocus()
	
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

type p_mod from uo_picture within w_pil1000_popup
integer x = 1335
integer y = 24
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;Int k

IF dw_1.Accepttext() = -1 THEN 	RETURN

IF dw_1.RowCount() > 0 THEN
	IF wf_required_check(dw_1.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_1.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_1.Setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_del from uo_picture within w_pil1000_popup
integer x = 1509
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;Int il_currow,i, totrow, srow
string gubn

il_currow = dw_1.GetRow()
IF il_currow <=0 Then Return

totrow =dw_1.Rowcount()

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return



FOR i = 1 TO totrow 
	sRow = dw_1.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	dw_1.DeleteRow(sRow)
NEXT	


IF dw_1.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_1.ScrollToRow(il_currow - 1)
		gubn = dw_1.getitemstring(1,"gubn")
		if gubn = '1' then
			dw_1.SetColumn("payrestamt")
		else
			dw_1.SetColumn("skedualdate")
		end if	
		dw_1.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type rr_1 from roundrectangle within w_pil1000_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 208
integer width = 1797
integer height = 1488
integer cornerheight = 40
integer cornerwidth = 55
end type

