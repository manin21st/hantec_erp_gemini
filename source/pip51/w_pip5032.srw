$PBExportHeader$w_pip5032.srw
$PBExportComments$과세이연계좌등록
forward
global type w_pip5032 from w_inherite_multi
end type
type rr_2 from roundrectangle within w_pip5032
end type
type dw_ip from datawindow within w_pip5032
end type
type dw_main from u_key_enter within w_pip5032
end type
type rr_1 from roundrectangle within w_pip5032
end type
end forward

global type w_pip5032 from w_inherite_multi
integer height = 2504
string title = "과세이연계좌 등록"
rr_2 rr_2
dw_ip dw_ip
dw_main dw_main
rr_1 rr_1
end type
global w_pip5032 w_pip5032

type variables
string is_yymm, is_dept
end variables

on w_pip5032.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.dw_ip=create dw_ip
this.dw_main=create dw_main
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_main
this.Control[iCurrent+4]=this.rr_1
end on

on w_pip5032.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.dw_ip)
destroy(this.dw_main)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.setitem(1, 'kdate', left(gs_today, 6))

dw_ip.SetFocus()

dw_main.SetTransObject(SQLCA)
dw_main.Reset()
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip5032
boolean visible = false
integer x = 4375
integer y = 2692
integer taborder = 90
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip5032
boolean visible = false
integer x = 4201
integer y = 2692
integer taborder = 70
end type

type p_search from w_inherite_multi`p_search within w_pip5032
boolean visible = false
integer x = 3685
integer y = 2692
integer taborder = 170
end type

type p_ins from w_inherite_multi`p_ins within w_pip5032
boolean visible = false
integer x = 4027
integer y = 2692
integer taborder = 40
end type

type p_exit from w_inherite_multi`p_exit within w_pip5032
integer x = 4375
integer taborder = 160
end type

type p_can from w_inherite_multi`p_can within w_pip5032
integer x = 4201
integer taborder = 140
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.Insertrow(0)
dw_ip.SetItem(1, 'kdate', left(gs_today, 6))
dw_ip.SetColumn('kdate')
dw_ip.SetFocus()

is_yymm = left(gs_today, 6)
setnull(is_dept)
dw_ip.SetRedraw(True)

dw_main.SetRedraw(False)
dw_main.Reset()
dw_main.SetRedraw(True)
ib_any_typing = false
p_mod.enabled=false
p_mod.Picturename = "C:\erpman\image\저장_d.gif"
p_del.Enabled = false
p_del.Picturename = "C:\erpman\image\삭제_d.gif"

end event

type p_print from w_inherite_multi`p_print within w_pip5032
boolean visible = false
integer x = 3858
integer y = 2692
integer taborder = 180
end type

type p_inq from w_inherite_multi`p_inq within w_pip5032
integer x = 3854
end type

event p_inq::clicked;call super::clicked;long i, lrow
double d_amt
string s_empno, s_kdate, ls_saupcd

dw_ip.accepttext()
ls_saupcd = dw_ip.GetItemString(1, "saup")
s_kdate    = TRIM(dw_ip.GetItemString(1, "kdate"))

IF IsNull(s_kdate) or s_kdate = ""	THEN
	Messagebox("확 인","퇴직년월을 입력하세요!!")
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	Return
END IF
IF IsNull(ls_saupcd) or ls_saupcd = ""	THEN ls_saupcd = '%'

w_mdi_frame.sle_msg.text = "조회 중........."
SetPointer(HourGlass!)

dw_main.SetRedraw(False)
IF dw_main.Retrieve(ls_saupcd, s_kdate) <=0 THEN
	MessageBox("확 인","자료가 없습니다!!",StopSign!)
	p_mod.enabled=false
   p_mod.Picturename = "C:\erpman\image\저장_d.gif"
   p_del.Enabled = false
	p_del.Picturename = "C:\erpman\image\삭제_d.gif"
   dw_main.reset()
   w_mdi_frame.sle_msg.text = ""
	dw_main.SetRedraw(true)
   return 
end if

w_mdi_frame.sle_msg.text = ""
SetPointer(Arrow!)

dw_main.SetRedraw(True)
p_mod.enabled=true
p_mod.Picturename = "C:\erpman\image\저장_up.gif"
p_del.Enabled = true
p_del.Picturename = "C:\erpman\image\삭제_up.gif"
dw_main.SetFocus()

end event

type p_del from w_inherite_multi`p_del within w_pip5032
boolean visible = false
integer x = 3003
integer y = 60
integer taborder = 0
end type

event p_del::clicked;call super::clicked;//Int il_currow, i
//string s_yymm, s_mm, s_yy, s_dept, s_deptnm, s_msg, s_empno, s_chk
//
//
//
//s_msg =  "선택한 자료를 삭제하시겠습니까? "
//	
//IF	MessageBox("삭제 확인", s_msg , question!, yesno!) = 2	THEN return
//
//w_mdi_frame.sle_msg.text = '삭제 중........'
//SetPointer(HourGlass!)
//dw_main.accepttext()
//
//for i = 1 to  dw_main.rowcount()	
//   
//	s_empno  = dw_main.getitemstring(i, "p1_master_empno")   // 사원번호
//	s_chk    = dw_main.getitemstring(i, "chk")   
//	
//	if s_chk = 'Y' then
//		
//		DELETE FROM "P3_RETIRE_TAX_POSPONE"  
//		 WHERE ( "P3_RETIRE_TAX_POSPONE"."EMPNO" = :s_empno )   ;
//	
//		if sqlca.sqlcode < 0 then
//			rollback using sqlca ;
//			f_rollback()		
//			ib_any_typing = True
//			return 
//		end if
//		
//	end if	
//next
//
//commit using sqlca ;
//dw_main.SetRedraw(FALSE)
//dw_main.reset()
//dw_main.SetRedraw(TRUE)
//SetPointer(Arrow!)
//ib_any_typing =False
//w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
//p_inq.TriggerEvent(Clicked!)
//	
////dw_ip.Setfocus()
////p_mod.enabled=false
////p_mod.Picturename = "C:\erpman\image\저장_d.gif"
////p_del.Enabled = false
////p_del.Picturename = "C:\erpman\image\삭제_d.gif"
//
end event

type p_mod from w_inherite_multi`p_mod within w_pip5032
integer x = 4027
integer taborder = 110
end type

event p_mod::clicked;call super::clicked;long i, cnt
string s_empno,  s_kdate, s_dpno, s_banknm, s_banksano, s_postdate, s_postmdate

dw_ip.accepttext()

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

w_mdi_frame.sle_msg.text = '저장 중........'
SetPointer(HourGlass!)
dw_main.accepttext()

FOR i = 1 TO dw_main.RowCount()
	IF dw_main.GetItemString(i,"status") = 'M' THEN
		dw_main.SetItemStatus(i, 0, Primary!, DataModified!)
	ELSE
		dw_main.SetItemStatus(i, 0, Primary!, NewModified!)
	END IF
NEXT

IF dw_main.Update() <> 1 Then
   f_messagechk(13,"") 
   dw_main.SetFocus()
   Rollback;
	Return
END IF
Commit;

SetPointer(Arrow!)
ib_any_typing =False
w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
dw_ip.Setfocus()

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip5032
boolean visible = false
integer x = 3813
integer y = 2896
integer taborder = 20
end type

type st_window from w_inherite_multi`st_window within w_pip5032
boolean visible = false
integer taborder = 50
end type

type cb_append from w_inherite_multi`cb_append within w_pip5032
boolean visible = false
integer x = 855
integer y = 2556
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip5032
boolean visible = false
integer taborder = 150
end type

type cb_update from w_inherite_multi`cb_update within w_pip5032
boolean visible = false
integer taborder = 100
boolean enabled = false
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip5032
boolean visible = false
integer x = 1243
integer y = 2556
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip5032
boolean visible = false
integer taborder = 120
boolean enabled = false
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip5032
boolean visible = false
integer x = 151
integer taborder = 80
end type

type st_1 from w_inherite_multi`st_1 within w_pip5032
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip5032
boolean visible = false
integer taborder = 130
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip5032
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip5032
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip5032
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip5032
boolean visible = false
integer width = 489
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip5032
boolean visible = false
end type

type rr_2 from roundrectangle within w_pip5032
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 389
integer y = 84
integer width = 2405
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from datawindow within w_pip5032
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 398
integer y = 88
integer width = 2382
integer height = 156
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip5032_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF key = keyF1! THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemchanged;String snull, sget_name

SetNull(snull)

IF this.GetcolumnName() = "syymm" THEN
	is_yymm = Trim(this.GetText())
   
	IF is_yymm ="" OR IsNull(is_yymm) THEN RETURN
	
	IF f_datechk(is_yymm+"01") = -1 THEN
		messagebox('확 인','작업년월을 확인하세요!!')
		this.SetItem(1,"syymm",snull)
		this.SetColumn("syymm")
		this.Setfocus()
		Return 1
   END IF

   p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetcolumnName() ="sdeptno" THEN
	is_dept = trim(this.GetText())
	
	IF is_dept ="" OR IsNull(is_dept) THEN 
		this.SetItem(1,"sdeptnm",snull)
	ELSE	
		
		SELECT p0_dept.deptname2  
		  INTO :sget_name  
		  FROM p0_dept  
		 WHERE p0_dept.companycode = :gs_company AND 
				 p0_dept.deptcode = :is_dept  ;
	
		IF sqlca.sqlcode <> 0 THEN
			MessageBox("확 인","등록되지 않은 부서입니다!!")
			this.SetItem(1,"sdeptno",snull)
			this.SetItem(1,"sdeptnm",snull)
			this.SetColumn("sdeptno")
			this.Setfocus()
			Return 1
		ELSE
			this.SetItem(1,"sdeptnm",sget_name)
		END IF
	END IF

	IF is_yymm ="" OR IsNull(is_yymm) THEN RETURN
   p_inq.TriggerEvent(Clicked!)

END IF


end event

event itemerror;
Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="sdeptno" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"sdeptno",gs_code)
//	this.SetItem(1,"sdeptnm",gs_codename)	
	
	this.TriggerEvent(ItemChanged!)

END IF

end event

type dw_main from u_key_enter within w_pip5032
integer x = 393
integer y = 276
integer width = 3698
integer height = 1928
integer taborder = 60
string dataobject = "d_pip5032_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event editchanged;call super::editchanged;ib_any_typing =True


end event

event retrieverow;call super::retrieverow;IF row > 0 THEN
	this.SetItem(row,"empno", this.GetItemString(row,"p1_master_empno"))
END IF
end event

type rr_1 from roundrectangle within w_pip5032
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 384
integer y = 268
integer width = 3735
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

