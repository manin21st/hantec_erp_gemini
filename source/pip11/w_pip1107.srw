$PBExportHeader$w_pip1107.srw
$PBExportComments$** 예외자료 등록
forward
global type w_pip1107 from w_inherite_multi
end type
type dw_main from u_key_enter within w_pip1107
end type
type dw_1 from datawindow within w_pip1107
end type
type p_input from uo_picture within w_pip1107
end type
type dw_saup from datawindow within w_pip1107
end type
type rr_1 from roundrectangle within w_pip1107
end type
end forward

global type w_pip1107 from w_inherite_multi
string title = "예외자료 등록"
dw_main dw_main
dw_1 dw_1
p_input p_input
dw_saup dw_saup
rr_1 rr_1
end type
global w_pip1107 w_pip1107

type variables
String spaytag
DataWindowChild dw_child

end variables

forward prototypes
public function integer wf_requiredcheck (integer ll_row)
end prototypes

public function integer wf_requiredcheck (integer ll_row);
String scode,stag

scode  = dw_main.GetItemString(ll_row,"empno")
stag   = dw_main.GetItemString(ll_row,"userec")

IF scode ="" OR IsNull(scode) THEN
	Messagebox("확 인","사원을 입력하세요!!")
	dw_main.SetColumn("empno")
	dw_main.SetFocus()
	Return -1
END IF

IF stag ="" OR IsNull(stag) THEN
	Messagebox("확 인","구분코드를 입력하세요!!")
	dw_main.SetColumn("userec")
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

on w_pip1107.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_1=create dw_1
this.p_input=create p_input
this.dw_saup=create dw_saup
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_input
this.Control[iCurrent+4]=this.dw_saup
this.Control[iCurrent+5]=this.rr_1
end on

on w_pip1107.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.dw_1)
destroy(this.p_input)
destroy(this.dw_saup)
destroy(this.rr_1)
end on

event open;call super::open;dw_main.SetTransObject(SQLCA)
dw_main.Reset()
dw_saup.SetTransObject(sqlca)
dw_saup.InsertRow(0)

IF dw_1.GetChild("code",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('PB') <=0 THEN RETURN 
END IF

dw_1.SetTransObject(SQLCA)      //사원정보
dw_1.Reset()
dw_1.insertrow(0)

/*사업장 정보 셋팅*/
f_set_saupcd(dw_saup,'saupcd','1')
is_saupcd = gs_saupcd

dw_1.setitem(1,"code",'P')
spaytag = "P"

dw_main.Retrieve(gs_company,spaytag,is_saupcd)
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1107
boolean visible = false
integer x = 3707
integer y = 3008
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1107
boolean visible = false
integer x = 3506
integer y = 3684
end type

type p_search from w_inherite_multi`p_search within w_pip1107
boolean visible = false
integer x = 2839
integer y = 3008
end type

type p_ins from w_inherite_multi`p_ins within w_pip1107
integer x = 3694
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)
	dw_main.SetItem(il_currow,"pbtag",spaytag)
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("empno")
	dw_main.SetFocus()
	
	
END IF



end event

type p_exit from w_inherite_multi`p_exit within w_pip1107
integer x = 4389
end type

type p_can from w_inherite_multi`p_can within w_pip1107
integer x = 4215
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

dw_main.Reset()
ib_any_typing = false

p_inq.TriggerEvent(Clicked!)
end event

type p_print from w_inherite_multi`p_print within w_pip1107
boolean visible = false
integer x = 3013
integer y = 3008
end type

type p_inq from w_inherite_multi`p_inq within w_pip1107
integer x = 3520
end type

event p_inq::clicked;call super::clicked;String ls_saup

w_mdi_frame.sle_msg.text = ''

ls_saup = dw_saup.GetItemString(1,"saupcd")
IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'

IF dw_main.Retrieve(gs_company,spaytag,ls_saup) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	Return
ELSE
	dw_main.SetRedraw(False)
	dw_main.ScrollToRow(dw_main.RowCount())
	dw_main.SetColumn("empno")
	dw_main.SetFocus()
	dw_main.SetRedraw(True)
END IF

w_mdi_frame.sle_msg.text = " 조회 "

end event

type p_del from w_inherite_multi`p_del within w_pip1107
integer x = 4041
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("empno")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pip1107
integer x = 3867
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_requiredcheck(dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
		
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1107
boolean visible = false
integer x = 1422
integer y = 2752
end type

type st_window from w_inherite_multi`st_window within w_pip1107
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1107
boolean visible = false
integer taborder = 40
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)
//	dw_main.SetItem(il_currow,"companycode",gs_company)	
//	dw_main.SetItem(il_currow,"pbtag",spaytag)	
//
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("empno")
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1107
boolean visible = false
integer taborder = 90
end type

type cb_update from w_inherite_multi`cb_update within w_pip1107
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1107
boolean visible = false
integer taborder = 50
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1107
boolean visible = false
integer taborder = 70
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1107
boolean visible = false
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1107
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1107
boolean visible = false
integer taborder = 80
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1107
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1107
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1107
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1107
boolean visible = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1107
boolean visible = false
end type

type dw_main from u_key_enter within w_pip1107
event ue_key pbm_dwnkey
integer x = 155
integer y = 200
integer width = 4183
integer height = 2028
integer taborder = 10
string dataobject = "d_pip1107_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;Int il_currow,lReturnRow
String scode,snull,sname,sdept,slevel,ssalary,senterdate,sretiredate

SetNull(snull)

il_currow = this.GetRow()

IF this.GetColumnName() = "empno" THEN
	
	scode = THIS.GETTEXT()								
	
	IF scode ="" OR IsNull(scode) THEN RETURN
	
	SELECT "P1_MASTER"."EMPNAME",   "P0_DEPT"."DEPTNAME2",   
			 "P1_MASTER"."LEVELCODE", "P1_MASTER"."SALARY",
			 "P1_MASTER"."ENTERDATE", "P1_MASTER"."RETIREDATE"
	   INTO :sname,   :sdept,   :slevel,   :ssalary,   :senterdate,   :sretiredate  
	   FROM "P1_MASTER",   "P0_DEPT"  
	   WHERE ( "P1_MASTER"."COMPANYCODE" = "P0_DEPT"."COMPANYCODE" ) and  
   	      ( "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" ) and  
      	   ( ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         	( "P1_MASTER"."EMPNO" = :scode ) )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다!!")
		this.SetItem(il_currow,"empno",snull)
		this.SetItem(il_currow,"empname",snull)
		this.SetItem(il_currow,"p0_dept_deptname2",snull)
		this.SetItem(il_currow,"levelcode",snull)
		this.SetItem(il_currow,"salary",snull)
		this.SetItem(il_currow,"enterdate",snull)
		this.SetItem(il_currow,"retiredate",snull)
		Return 1
	END IF
	
	lReturnRow = This.Find("empno = '"+scode+"' ", 1, This.RowCount())
	
	IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("확인","등록된 사원입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow,"empno",snull)
		this.SetItem(il_currow,"empname",snull)
		this.SetItem(il_currow,"p0_dept_deptname2",snull)
		this.SetItem(il_currow,"levelcode",snull)
		this.SetItem(il_currow,"salary",snull)
		this.SetItem(il_currow,"enterdate",snull)
		this.SetItem(il_currow,"retiredate",snull)
		RETURN  1	
	END IF
	
	this.SetItem(il_currow,"empname",sname)
	this.SetItem(il_currow,"p0_dept_deptname2",sdept)
	this.SetItem(il_currow,"levelcode",slevel)
	this.SetItem(il_currow,"salary",ssalary)
	this.SetItem(il_currow,"enterdate",senterdate)
	this.SetItem(il_currow,"retiredate",sretiredate)
END IF

IF this.GetColumnName() = "userec" THEN
	
	scode = THIS.GETTEXT()								
	
	IF scode ="" OR IsNull(scode) THEN RETURN

	IF scode <> '1' AND scode <> '2' AND scode <> '3' AND scode <> '4' AND scode <> 'N' THEN
		w_mdi_frame.sle_msg.text ="유효한 코드는 '1' 또는 '2' 또는 '3' 또는 '4' 또는 'N'입니다"
		MessageBox("확 인","구분코드를 확인하십시요!!")
		this.SetItem(il_currow,"userec",snull)
		Return 1
	END IF
END IF



end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

event rbuttondown;call super::rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)

IF This.GetColumnName() ="empno" THEN
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(row,"empno",Gs_code)
	
	this.TriggerEvent(ItemChanged!)
END IF

end event

type dw_1 from datawindow within w_pip1107
integer x = 146
integer y = 28
integer width = 1961
integer height = 156
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pip1006_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_saup
dw_1.accepttext()
dw_saup.AcceptText()
ls_saup = dw_saup.GetItemString(1,"saupcd")
IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'

spaytag = dw_1.getitemstring(1,"code")
dw_main.Retrieve(gs_company,spaytag,ls_saup)

end event

type p_input from uo_picture within w_pip1107
boolean visible = false
integer x = 4379
integer y = 2476
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\Erpman\image\행추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
end event

type dw_saup from datawindow within w_pip1107
integer x = 1243
integer y = 64
integer width = 699
integer height = 88
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_saup
dw_1.accepttext()
this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


spaytag = dw_1.getitemstring(1,"code")
dw_main.Retrieve(gs_company,spaytag,is_saupcd)
end event

type rr_1 from roundrectangle within w_pip1107
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 146
integer y = 192
integer width = 4201
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

