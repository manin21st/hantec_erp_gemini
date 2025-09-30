$PBExportHeader$w_pip1005.srw
$PBExportComments$** 급여 고정금액 등록
forward
global type w_pip1005 from w_inherite_multi
end type
type dw_main from u_key_enter within w_pip1005
end type
type dw_empinfo from u_d_popup_sort within w_pip1005
end type
type dw_ip from datawindow within w_pip1005
end type
type dw_saup from datawindow within w_pip1005
end type
type rr_2 from roundrectangle within w_pip1005
end type
type rr_3 from roundrectangle within w_pip1005
end type
end forward

global type w_pip1005 from w_inherite_multi
string title = "고정자료 등록"
dw_main dw_main
dw_empinfo dw_empinfo
dw_ip dw_ip
dw_saup dw_saup
rr_2 rr_2
rr_3 rr_3
end type
global w_pip1005 w_pip1005

type variables
String iv_pbtag,iv_pstag , sDate
end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
end prototypes

public function integer wf_required_check (integer ll_row);
String scode
Double damount

dw_main.AcceptText()
scode   = dw_main.GetItemString(ll_row,"allowcode")
damount = dw_main.GetItemNumber(ll_row,"allowamt") 

IF scode ="" OR IsNull(scode) THEN
	MessageBox("확 인","수당을 입력하세요!!")
	dw_main.SetColumn("allowcode")
	dw_main.Setfocus()
	Return -1
END IF

IF damount = 0 OR IsNull(damount) THEN
	MessageBox("확 인","금액을 입력하세요!!")
	dw_main.SetColumn("allowamt")
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

on w_pip1005.create
int iCurrent
call super::create
this.dw_main=create dw_main
this.dw_empinfo=create dw_empinfo
this.dw_ip=create dw_ip
this.dw_saup=create dw_saup
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_main
this.Control[iCurrent+2]=this.dw_empinfo
this.Control[iCurrent+3]=this.dw_ip
this.Control[iCurrent+4]=this.dw_saup
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_3
end on

on w_pip1005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_main)
destroy(this.dw_empinfo)
destroy(this.dw_ip)
destroy(this.dw_saup)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;
dw_empinfo.SetTransObject(SQLCA)      //사원정보
dw_empinfo.Reset()

dw_main.SetTransObject(SQLCA)
dw_main.Reset()

dw_saup.SetTransObject(SQLCA)
dw_saup.InsertRow(0)

f_set_saupcd(dw_saup, 'sabu', '1')
is_saupcd = gs_saupcd

iv_pbtag = "P"
iv_pstag = "1"

IF dw_empinfo.Retrieve(gs_company,left(f_today(),6)+'01',is_saupcd) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!")
	close(this)
	Return
ELSE
	dw_empinfo.SelectRow(0,False)
	dw_empinfo.SelectRow(1,True)
	
	IF dw_main.Retrieve(gs_company,dw_empinfo.GetItemString(1,"empno"),iv_pbtag,iv_pstag) > 0 THEN
		dw_main.ScrollToRow(dw_main.RowCount())
		dw_main.SetFocus()
	END IF
	
END IF

dw_ip.SetTransObject(SQLCA)
dw_ip.insertrow(0)
dw_ip.object.workday[1] = left(f_today(),6)+'01'
dw_ip.object.kunmu[1] = '01'
dw_ip.object.gijun[1] = '1'
dw_ip.object.pbtag[1] = '1'
dw_ip.object.allow[1] = '1'
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1005
boolean visible = false
integer x = 3881
integer y = 2820
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1005
boolean visible = false
integer x = 3707
integer y = 2820
end type

type p_search from w_inherite_multi`p_search within w_pip1005
boolean visible = false
integer x = 3698
integer y = 2560
end type

type p_ins from w_inherite_multi`p_ins within w_pip1005
integer x = 3721
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_required_check(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)	
	dw_main.SetItem(il_currow,"empno",&
					dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	
	
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pip1005
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pip1005
integer x = 4242
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

ib_any_typing = false

dw_main.retrieve(gs_company,dw_empinfo.GetItemString(dw_empinfo.GetSelectedRow(0),"empno"),iv_pbtag,iv_pstag)
dw_main.ScrollToRow(dw_main.RowCount())
dw_main.setfocus()



end event

type p_print from w_inherite_multi`p_print within w_pip1005
boolean visible = false
integer x = 3685
integer y = 2684
end type

type p_inq from w_inherite_multi`p_inq within w_pip1005
integer x = 3547
end type

event p_inq::clicked;call super::clicked;String sempno, ls_saup

dw_saup.AcceptText()
ls_saup = dw_saup.GetItemString(1,"sabu")
IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'

IF dw_empinfo.GetSelectedRow(0) <=0 THEN
	MessageBox("확 인","조회할 사원을 선택하세요!!")
	Return
ELSE
	sempno = dw_empinfo.GetItemString(dw_empinfo.GetSelectedRow(0),"empno")
END IF

IF dw_main.retrieve(gs_company,sempno,iv_pbtag,iv_pstag) <= 0 then
	MessageBox("확 인","등록된 자료가 없습니다!!")
	Return
ELSE
	dw_main.ScrollToRow(dw_main.RowCount())
end if
dw_main.setfocus()
end event

type p_del from w_inherite_multi`p_del within w_pip1005
integer x = 4069
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
		dw_main.SetColumn("allowcode")
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

type p_mod from w_inherite_multi`p_mod within w_pip1005
integer x = 3895
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
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

type dw_insert from w_inherite_multi`dw_insert within w_pip1005
boolean visible = false
integer x = 1550
integer y = 2572
end type

type st_window from w_inherite_multi`st_window within w_pip1005
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1005
boolean visible = false
integer taborder = 60
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_required_check(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)
//	dw_main.SetItem(il_currow,"companycode",gs_company)	
//	dw_main.SetItem(il_currow,"empno",&
//					dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
//	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
//	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
//
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("allowcode")
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1005
boolean visible = false
integer taborder = 110
end type

type cb_update from w_inherite_multi`cb_update within w_pip1005
boolean visible = false
integer taborder = 80
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1005
boolean visible = false
integer taborder = 70
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1005
boolean visible = false
integer taborder = 90
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1005
boolean visible = false
integer taborder = 50
end type

type st_1 from w_inherite_multi`st_1 within w_pip1005
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1005
boolean visible = false
integer taborder = 100
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1005
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1005
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1005
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1005
boolean visible = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1005
boolean visible = false
end type

type dw_main from u_key_enter within w_pip1005
integer x = 2437
integer y = 356
integer width = 1737
integer height = 1908
integer taborder = 40
string dataobject = "d_pip1005_2"
boolean vscrollbar = true
boolean border = false
end type

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

event itemchanged;call super::itemchanged;String sname,snull
Int il_currow,lReturnRow

SetNull(snull)

il_currow = this.GetRow()

IF this.GetColumnName() ="allowcode" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	SELECT "P3_ALLOWANCE"."ALLOWNAME"  
   	INTO :sname  
	   FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = :iv_pstag AND "P3_ALLOWANCE"."ALLOWCODE" =:data  ;
	IF SQLCA.SQLCODE <> 0 THEN
		w_mdi_frame.sle_msg.text ="수당을 등록하시려면 '급여기준정보'메뉴로 이동하십시요!!"
		Messagebox("확 인","등록된 수당이 아닙니다!!")
		this.SetItem(row,"allowcode",snull)
		Return 1
	END IF
	
	lReturnRow = This.Find("allowcode = '"+data+"' ", 1, This.RowCount())
	
	IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("확인","등록된 수당입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow,"allowcode",snull)
		RETURN  1	
	END IF
	
END IF

end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event retrievestart;call super::retrievestart;
DataWindowChild dw_child
Int il_rtn

il_rtn = dw_main.GetChild("allowcode",dw_child)
IF il_rtn = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve(iv_pstag,'1') <=0 THEN 
		Messagebox("확 인","등록된 수당이 없습니다!!")
		Return 1
	END IF
END IF
end event

type dw_empinfo from u_d_popup_sort within w_pip1005
integer x = 357
integer y = 356
integer width = 2007
integer height = 1908
boolean bringtotop = true
string dataobject = "d_pip1005_1"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	dw_empinfo.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_ip from datawindow within w_pip1005
event ue_key pbm_dwnkey
event ue_key_enter pbm_dwnprocessenter
integer x = 334
integer y = 32
integer width = 2345
integer height = 272
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pip1005_3"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_key_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string	ls_saup
long		rownum

if AcceptText() = -1 then return -1

dw_saup.AcceptText()
ls_saup = dw_saup.GetItemString(1,'sabu')
if ls_saup = '' OR isnull(ls_saup) then ls_saup = '%'

if dwo.Name = 'workday' then
	sDate= GetText()

	IF sDate ="" OR IsNull(sDate) THEN
		object.workday[1] = ""
		Return 1
	END IF
	
	IF F_datechk(sDate) = -1 then
   	messagebox("확인","일자를 확인하십시오!")
		object.workday[1] = ""
		return 1
	END IF	
	dw_empinfo.Retrieve(gs_company,sDate,ls_saup)
end if


if dwo.Name = 'empname' then
	if object.gijun[1] = '1' then
		rownum = dw_empinfo.find("left(#3," + string(len(GetText())) + ")='" + GetText() + "'", 1, dw_empinfo.rowcount())
	else
		rownum = dw_empinfo.find("left(#2," + string(len(GetText())) + ")='" + GetText() + "'", 1, dw_empinfo.rowcount())
	end if

	if rownum > 0 then
		dw_empinfo.setredraw(false)
		dw_main.SetRedraw(False)
	
		dw_empinfo.SelectRow(0,False)
		dw_empinfo.SelectRow(rownum,True)
	
		IF dw_main.Retrieve(gs_company,dw_empinfo.GetItemString(rownum,"empno"),iv_pbtag,iv_pstag) > 0 THEN
			dw_main.ScrollToRow(dw_main.RowCount())
			dw_main.SetFocus()
		END IF
		dw_empinfo.ScrollToRow(rownum)
	
		dw_empinfo.setredraw(true)
		dw_main.SetRedraw(True)
	end if
end if


if dwo.Name = 'pbtag' then

	if GetText() = '1' then
		iv_pbtag = "P"
	else
		iv_pbtag = "B"
	end if
	
	If ib_any_typing = True Then
		IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
			p_mod.TriggerEvent(Clicked!)
		END IF
	END IF

	p_inq.TriggerEvent(Clicked!)
end if


if dwo.Name = 'allow' then

	if GetText() = '1' then
		iv_pstag = "1"
	else
		iv_pstag = "2"
	end if
	
	If ib_any_typing = True Then
		IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
			p_mod.TriggerEvent(Clicked!)
		END IF
	END IF

	p_inq.TriggerEvent(Clicked!)
end if

end event

event itemerror;return 1
end event

type dw_saup from datawindow within w_pip1005
integer x = 1147
integer y = 60
integer width = 667
integer height = 88
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_saup, ls_Date

AcceptText()
dw_ip.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

ls_Date = dw_ip.GetItemString(1,'workday')

IF dw_empinfo.Retrieve(gs_company,ls_Date, is_saupcd) <=0 then
else
dw_main.Retrieve(gs_company,dw_empinfo.GetItemString(dw_empinfo.getrow(),"empno"),iv_pbtag,iv_pstag)
END IF
end event

type rr_2 from roundrectangle within w_pip1005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 343
integer y = 344
integer width = 2039
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip1005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2427
integer y = 344
integer width = 1751
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

