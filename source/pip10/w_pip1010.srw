$PBExportHeader$w_pip1010.srw
$PBExportComments$** 퇴직전환금 등록(98/09 추가)
forward
global type w_pip1010 from w_inherite_multi
end type
type dw_ip from datawindow within w_pip1010
end type
type dw_main from u_key_enter within w_pip1010
end type
type rr_1 from roundrectangle within w_pip1010
end type
end forward

global type w_pip1010 from w_inherite_multi
string title = "퇴직전환금 등록"
dw_ip dw_ip
dw_main dw_main
rr_1 rr_1
end type
global w_pip1010 w_pip1010

type variables
string is_yymm, is_dept
end variables

on w_pip1010.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_main=create dw_main
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.rr_1
end on

on w_pip1010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_main)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.setitem(1, 'syymm', left(gs_today, 6))
dw_ip.Setcolumn('sdeptno')
dw_ip.SetFocus()

is_yymm = left(gs_today, 6)

dw_main.SetTransObject(SQLCA)
dw_main.Reset()
end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1010
boolean visible = false
integer x = 4375
integer y = 2692
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1010
boolean visible = false
integer x = 4201
integer y = 2692
end type

type p_search from w_inherite_multi`p_search within w_pip1010
boolean visible = false
integer x = 3685
integer y = 2692
end type

type p_ins from w_inherite_multi`p_ins within w_pip1010
boolean visible = false
integer x = 4027
integer y = 2692
end type

type p_exit from w_inherite_multi`p_exit within w_pip1010
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pip1010
integer x = 4242
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.Insertrow(0)
dw_ip.SetItem(1, 'syymm', left(gs_today, 6))
dw_ip.SetColumn('sdeptno')
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

type p_print from w_inherite_multi`p_print within w_pip1010
boolean visible = false
integer x = 3858
integer y = 2692
end type

type p_inq from w_inherite_multi`p_inq within w_pip1010
integer x = 3721
end type

event p_inq::clicked;call super::clicked;long i, lrow
double d_amt
string s_empno, s_yymm, s_dept

dw_ip.accepttext()
s_yymm = dw_ip.GetItemString(1, "syymm")
s_dept = dw_ip.GetItemString(1, "sdeptno")

IF IsNull(s_yymm) or s_yymm = ""	THEN
	Messagebox("확 인","작업년월을 입력하세요!!")
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	Return
END IF

IF IsNull(s_dept) or s_dept = ""	THEN 
	s_dept = '%'
END IF

w_mdi_frame.sle_msg.text = "조회 중........."
SetPointer(HourGlass!)

dw_main.SetRedraw(False)
IF dw_main.Retrieve(gs_company, s_dept, s_yymm) <=0 THEN
	MessageBox("확 인","선택한 부서에 자료가 없습니다!!",StopSign!)
	p_mod.enabled=false
   p_mod.Picturename = "C:\erpman\image\저장_d.gif"
   p_del.Enabled = false
	p_del.Picturename = "C:\erpman\image\삭제_d.gif"
   dw_main.reset()
   w_mdi_frame.sle_msg.text = ""
	dw_main.SetRedraw(true)
   return 
else
	for i = 1 to dw_main.rowcount()

     
     s_empno = dw_main.getitemstring(i, "p1_master_empno")
	  
	  SELECT "P3_PENSION"."RETIREFINE"  
		 INTO :d_amt  
		 FROM "P3_PENSION"  
		WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
				( "P3_PENSION"."WORKYM" = :s_yymm ) AND  
				( "P3_PENSION"."EMPNO" = :s_empno )   ;

	 	if sqlca.sqlcode = 0 then
			dw_main.setitem(i, "damt", d_amt)
		end if
	next
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

type p_del from w_inherite_multi`p_del within w_pip1010
integer x = 4069
end type

event p_del::clicked;call super::clicked;Int il_currow, i
string s_yymm, s_mm, s_yy, s_dept, s_deptnm, s_msg, s_empno

il_currow = dw_main.RowCount()
IF il_currow <=0 Then Return

dw_ip.accepttext()
s_yymm = dw_ip.getitemstring(1, "syymm")
s_mm = mid(s_yymm, 5, 2)
s_yy = left(s_yymm, 4)
s_dept = dw_ip.getitemstring(1, "sdeptno")

if s_dept = "" or isnull(s_dept) then
	s_deptnm = "전체"
else 
  SELECT "P0_DEPT"."DEPTNAME2"  
    INTO :s_deptnm 
    FROM "P0_DEPT"  
   WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
         ( "P0_DEPT"."DEPTCODE" = :s_dept )   ;
end if

s_msg = s_yy + "년 " + s_mm + "월 " + s_deptnm + " 자료를 삭제하시겠습니까? "
	
IF	MessageBox("삭제 확인", s_msg , question!, yesno!) = 2	THEN return

w_mdi_frame.sle_msg.text = '삭제 중........'
SetPointer(HourGlass!)
dw_main.accepttext()

for i = 1 to il_currow	
   
	s_empno  = dw_main.getitemstring(i, "p1_master_empno")   // 사원번호
	
   DELETE FROM "P3_PENSION"  
	 WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
			 ( "P3_PENSION"."WORKYM" = :s_yymm ) AND  
			 ( "P3_PENSION"."EMPNO" = :s_empno )   ;

	if sqlca.sqlcode < 0 then
		rollback using sqlca ;
		f_rollback()		
      ib_any_typing = True
      return 
   end if
next

commit using sqlca ;
dw_main.SetRedraw(FALSE)
dw_main.reset()
dw_main.SetRedraw(TRUE)
SetPointer(Arrow!)
ib_any_typing =False
w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
	
dw_ip.Setfocus()
	p_mod.enabled=false
   p_mod.Picturename = "C:\erpman\image\저장_d.gif"
   p_del.Enabled = false
	p_del.Picturename = "C:\erpman\image\삭제_d.gif"

end event

type p_mod from w_inherite_multi`p_mod within w_pip1010
integer x = 3895
end type

event p_mod::clicked;call super::clicked;long i
double d_amt
string s_empno, s_degree, s_yymm, arg_empno 

dw_ip.accepttext()
s_yymm = dw_ip.GetItemString(1, "syymm")

IF IsNull(s_yymm) or s_yymm = ""	THEN
	Messagebox("확 인","작업년월을 입력하세요!!")
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	Return
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

w_mdi_frame.sle_msg.text = '저장 중........'
SetPointer(HourGlass!)
dw_main.accepttext()

for i = 1 to dw_main.rowcount()	
	s_degree = dw_main.getitemstring(i, "pendegree")         // 등급
	d_amt    = dw_main.getitemnumber(i, "damt")              // 퇴직금전환금
	s_empno  = dw_main.getitemstring(i, "p1_master_empno")   // 사원번호

	IF IsNull(d_amt) THEN d_amt =0
	
	IF s_Degree = "" OR IsNull(s_Degree) AND d_amt <> 0 THEN
		MessageBox("확 인","["+s_empno+"] 급여 기본자료에 등급이 없으므로 처리할 수 없습니다!!")
		CONTINUE
	END IF
	
	SELECT "P3_PENSION"."EMPNO"  
	  INTO :arg_empno  
	  FROM "P3_PENSION"  
	 WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
			 ( "P3_PENSION"."WORKYM" = :s_yymm ) AND  
			 ( "P3_PENSION"."EMPNO" = :s_empno )   ;

	if sqlca.sqlcode = 0 and (d_amt = 0 or isnull(d_amt)) then //자료존재하고 금액 0이면 delete
      DELETE FROM "P3_PENSION"  
		 WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
				 ( "P3_PENSION"."WORKYM" = :s_yymm ) AND  
				 ( "P3_PENSION"."EMPNO" = :s_empno )   ;
	   if sqlca.sqlcode <> 0 then
			rollback using sqlca ;
			f_rollback()		
         ib_any_typing = True
			return 
		end if	
   elseif sqlca.sqlcode = 0 and d_amt <> 0 then   //자료존재하고 금액 0이 아니면 update
	  
	  UPDATE "P3_PENSION"  
		  SET "RETIREFINE" = :d_amt   
		WHERE ( "P3_PENSION"."COMPANYCODE" = :gs_company ) AND  
				( "P3_PENSION"."WORKYM" = :s_yymm ) AND  
				( "P3_PENSION"."EMPNO" = :s_empno )   ;
	   if sqlca.sqlcode <> 0 then
			rollback using sqlca ;
			f_rollback()		
         ib_any_typing = True
			return 
		end if	
	elseif sqlca.sqlcode > 0  and d_amt <> 0 then  //자료존재하지 않고 금액 0이 아니면 insert
	  INSERT INTO "P3_PENSION"  
				( "COMPANYCODE","WORKYM","EMPNO","DEGREE","FINETAG","RETIREFINE","RETIRESEQ" )  
	  VALUES ( :gs_company, :s_yymm, :s_empno, :s_degree, '0',   :d_amt,       null)  ;
	   if sqlca.sqlcode <> 0 then
			MessageBox("확 인","퇴직전환금 저장 실패!!"+sqlca.sqlerrtext)
			rollback using sqlca ;
			f_rollback()		
         ib_any_typing = True
			return 
		end if	
   elseif sqlca.sqlcode > 0 and (d_amt = 0 or isnull(d_amt)) then //자료없고 금액 0이면 skip
   else 
		rollback using sqlca ;
		f_rollback()		
      ib_any_typing = True
      return 
   end if
	
next

commit using sqlca ;
SetPointer(Arrow!)
ib_any_typing =False
w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
dw_ip.Setfocus()

end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1010
boolean visible = false
integer x = 3813
integer y = 2896
end type

type st_window from w_inherite_multi`st_window within w_pip1010
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1010
boolean visible = false
integer x = 855
integer y = 2556
integer taborder = 0
end type

type cb_exit from w_inherite_multi`cb_exit within w_pip1010
boolean visible = false
end type

type cb_update from w_inherite_multi`cb_update within w_pip1010
boolean visible = false
integer taborder = 40
boolean enabled = false
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1010
boolean visible = false
integer x = 1243
integer y = 2556
integer taborder = 0
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1010
boolean visible = false
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1010
boolean visible = false
integer x = 151
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1010
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1010
boolean visible = false
integer taborder = 60
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1010
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1010
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1010
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1010
boolean visible = false
integer width = 489
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1010
boolean visible = false
end type

type dw_ip from datawindow within w_pip1010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 379
integer y = 56
integer width = 2162
integer height = 168
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip1010_1"
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

type dw_main from u_key_enter within w_pip1010
integer x = 398
integer y = 252
integer width = 3584
integer height = 1936
integer taborder = 20
string dataobject = "d_pip1010_2"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

type rr_1 from roundrectangle within w_pip1010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 389
integer y = 244
integer width = 3611
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

