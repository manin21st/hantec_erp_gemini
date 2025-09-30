$PBExportHeader$w_psd1140.srw
$PBExportComments$피고과자대상등록
forward
global type w_psd1140 from w_inherite_standard
end type
type dw_list from datawindow within w_psd1140
end type
type dw_dept from datawindow within w_psd1140
end type
type dw_empno from datawindow within w_psd1140
end type
type cb_1 from commandbutton within w_psd1140
end type
type cb_2 from commandbutton within w_psd1140
end type
type rr_1 from roundrectangle within w_psd1140
end type
type rr_2 from roundrectangle within w_psd1140
end type
end forward

global type w_psd1140 from w_inherite_standard
integer height = 2472
string title = "피고과자 대상 등록"
dw_list dw_list
dw_dept dw_dept
dw_empno dw_empno
cb_1 cb_1
cb_2 cb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_psd1140 w_psd1140

on w_psd1140.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_dept=create dw_dept
this.dw_empno=create dw_empno
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_dept
this.Control[iCurrent+3]=this.dw_empno
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_psd1140.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_dept)
destroy(this.dw_empno)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_dept.settransobject(sqlca)
dw_empno.settransobject(sqlca)
dw_list.settransobject(sqlca)

dw_dept.insertrow(0)
dw_empno.insertrow(0)
//dw_list.insertrow(0)

f_set_saupcd(dw_dept, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_dept.setcolumn("deptcode")
dw_dept.setfocus()


end event

type p_mod from w_inherite_standard`p_mod within w_psd1140
integer x = 3890
integer y = 28
end type

event p_mod::clicked;call super::clicked;string icode, icode1, icode2
long  getrow, cnt, cnt_per

if dw_list.accepttext() = -1 then return -1

if messagebox('저장확인','저장하시겠습니까?',question!,yesno!) = 1 then

	setpointer(hourglass!)

	for getrow = 1 to dw_list.rowcount()
	
		icode = dw_list.getitemstring(getrow,"empno1")
		icode1 = dw_list.getitemstring(getrow,"empno2")
		icode2 = dw_list.getitemstring(getrow,"empno")
		
		if (icode = "" or isnull(icode)) and (icode1 = "" or isnull(icode1)) then
			//p6_meritlevel에 등록되어있는지 확인
			select count(*) into :cnt
			from p6_meritlevel
			where p6_meritlevel.empno = :icode2 ;
				
				if not(cnt = 0  or isnull(cnt)) then
					//등록되어있다면.. 배점이 등록되어있는지확인
					select count(*) into :cnt_per
					from p6_meritperson
					where EMPNO = :icode2 ;
							
						if not(cnt_per = 0 or  isnull(cnt_per)) then 	
							messagebox('확인','고과항목배점등록에 등록된 자료이므로 삭제할수없습니다')
							cb_retrieve.triggerevent(clicked!)	
							return 
						else							
							delete from p6_meritlevel where p6_meritlevel.empno = :icode2 ;
						end if

				end if
		else
				select count(*) into :cnt
				from p6_meritlevel
				where p6_meritlevel.empno = :icode2 ;
			
					if cnt = 0  or isnull(cnt) then
						
						insert into p6_meritlevel (empno,empno1,empno2)
						values (:icode2, :icode, :icode1) ;
	
					else
						update p6_meritlevel 
						set p6_meritlevel.empno1 = :icode, 
							 p6_meritlevel.empno2 = :icode1
						where p6_meritlevel.empno = :icode2 ;
			
					end if

		end if		
	next
	
end if

commit;	

setpointer(arrow!)

cb_retrieve.triggerevent(clicked!)	
w_mdi_frame.sle_msg.text = "저장되었습니다"
end event

type p_del from w_inherite_standard`p_del within w_psd1140
integer x = 4064
integer y = 28
end type

event p_del::clicked;call super::clicked;long getrow,cnt_per
string icode, icode1, icode2, iname

if dw_list.accepttext() = -1 then return

getrow = dw_list.getrow()

icode = dw_list.getitemstring(getrow,"y_empno1")
icode1 = dw_list.getitemstring(getrow,"z_empno2")
icode2 = dw_list.getitemstring(getrow,"p1_master_empno")
iname = dw_list.getitemstring(getrow,"p1_master_empname")

if messagebox('삭제확인','삭제하시겠습니까?',question!,yesno!) = 1 then
	
	if (icode = "" or isnull(icode)) and (icode1 = "" or isnull(icode1)) then
		messagebox('삭제확인','삭제할 사번을 확인하세요.',stopsign!)
		dw_list.setcolumn("y_empno1")
		dw_list.scrolltorow(getrow)
		dw_list.setfocus()
		return
	else
		select count(*) into :cnt_per
		from p6_meritperson
		where EMPNO = :icode2 ;
							
		if not(cnt_per = 0 or  isnull(cnt_per)) then 
				
			messagebox('확인','고과항목배점등록에 등록된 자료이므로 삭제할수없습니다')
			dw_list.setcolumn("y_empno1")
			dw_list.scrolltorow(getrow)
			dw_list.setfocus()
			return 
		else
		
			delete from p6_meritlevel where p6_meritlevel.empno = :icode2 ;
		
		end if

	end if	

end if

commit;

cb_retrieve.triggerevent(clicked!)	
sle_msg.text = "삭제하였습니다"


end event

type p_inq from w_inherite_standard`p_inq within w_psd1140
integer x = 3712
integer y = 28
end type

event p_inq::clicked;call super::clicked;string licode, saupcd

if dw_dept.accepttext() = -1 then return -1

licode = dw_dept.getitemstring(1,"deptcode")
saupcd = dw_dept.GetItemString(1,"saupcd")

if licode = "" or isnull(licode) then licode = '%'
if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

if dw_list.retrieve(licode,saupcd) <= 0 then 
	messagebox('확인','부서원이 없습니다',stopsign!)
	dw_dept.setcolumn("deptcode")
	dw_dept.setfocus()
	return -1
end if

dw_empno.setcolumn("empno1")
dw_empno.setfocus()

end event

type p_print from w_inherite_standard`p_print within w_psd1140
integer x = 2587
integer y = 2704
end type

type p_can from w_inherite_standard`p_can within w_psd1140
integer x = 4238
integer y = 28
end type

event p_can::clicked;call super::clicked;dw_dept.reset()
dw_empno.reset()
dw_list.reset()

dw_dept.insertrow(0)
dw_empno.insertrow(0)
//dw_list.insertrow(0)

dw_dept.setcolumn("deptcode")
dw_dept.setfocus()

end event

type p_exit from w_inherite_standard`p_exit within w_psd1140
integer x = 4411
integer y = 28
end type

type p_ins from w_inherite_standard`p_ins within w_psd1140
integer x = 3653
integer y = 2644
end type

type p_search from w_inherite_standard`p_search within w_psd1140
integer x = 2409
integer y = 2704
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1140
integer x = 3109
integer y = 2704
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1140
integer x = 3282
integer y = 2704
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1140
integer x = 50
integer y = 2588
end type

type st_window from w_inherite_standard`st_window within w_psd1140
integer x = 2149
integer y = 2392
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1140
integer x = 869
integer y = 2596
end type

type cb_update from w_inherite_standard`cb_update within w_psd1140
integer x = 1385
integer y = 2660
end type

event cb_update::clicked;call super::clicked;string icode, icode1, icode2
long  getrow, cnt, cnt_per

if dw_list.accepttext() = -1 then return -1

if messagebox('저장확인','저장하시겠습니까?',question!,yesno!) = 1 then

	setpointer(hourglass!)

	for getrow = 1 to dw_list.rowcount()
	
		icode = dw_list.getitemstring(getrow,"y_empno1")
		icode1 = dw_list.getitemstring(getrow,"z_empno2")
		icode2 = dw_list.getitemstring(getrow,"p1_master_empno")
		
		if (icode = "" or isnull(icode)) and (icode1 = "" or isnull(icode1)) then
			//p6_meritlevel에 등록되어있는지 확인
			select count(*) into :cnt
			from p6_meritlevel
			where p6_meritlevel.empno = :icode2 ;
				
				if not(cnt = 0  or isnull(cnt)) then
					//등록되어있다면.. 배점이 등록되어있는지확인
					select count(*) into :cnt_per
					from p6_meritperson
					where EMPNO = :icode2 ;
							
						if not(cnt_per = 0 or  isnull(cnt_per)) then 	
							messagebox('확인','고과항목배점등록에 등록된 자료이므로 삭제할수없습니다')
							cb_retrieve.triggerevent(clicked!)	
							return 
						else							
							delete from p6_meritlevel where p6_meritlevel.empno = :icode2 ;
						end if

				end if
		else
				select count(*) into :cnt
				from p6_meritlevel
				where p6_meritlevel.empno = :icode2 ;
			
					if cnt = 0  or isnull(cnt) then
						
						insert into p6_meritlevel (empno,empno1,empno2)
						values (:icode2, :icode, :icode1) ;
	
					else
						update p6_meritlevel 
						set p6_meritlevel.empno1 = :icode, 
							 p6_meritlevel.empno2 = :icode1
						where p6_meritlevel.empno = :icode2 ;
			
					end if

		end if		
	next
	
end if

commit;	

setpointer(arrow!)

cb_retrieve.triggerevent(clicked!)	
sle_msg.text = "저장되었습니다"
end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1140
integer x = 2523
integer y = 2552
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1140
integer x = 1266
integer y = 2892
end type

event cb_delete::clicked;call super::clicked;long getrow,cnt_per
string icode, icode1, icode2, iname

if dw_list.accepttext() = -1 then return

getrow = dw_list.getrow()

icode = dw_list.getitemstring(getrow,"y_empno1")
icode1 = dw_list.getitemstring(getrow,"z_empno2")
icode2 = dw_list.getitemstring(getrow,"p1_master_empno")
iname = dw_list.getitemstring(getrow,"p1_master_empname")

if messagebox('삭제확인','삭제하시겠습니까?',question!,yesno!) = 1 then
	
	if (icode = "" or isnull(icode)) and (icode1 = "" or isnull(icode1)) then
		messagebox('삭제확인','삭제할 사번을 확인하세요.',stopsign!)
		dw_list.setcolumn("y_empno1")
		dw_list.scrolltorow(getrow)
		dw_list.setfocus()
		return
	else
		select count(*) into :cnt_per
		from p6_meritperson
		where EMPNO = :icode2 ;
							
		if not(cnt_per = 0 or  isnull(cnt_per)) then 
				
			messagebox('확인','고과항목배점등록에 등록된 자료이므로 삭제할수없습니다')
			dw_list.setcolumn("y_empno1")
			dw_list.scrolltorow(getrow)
			dw_list.setfocus()
			return 
		else
		
			delete from p6_meritlevel where p6_meritlevel.empno = :icode2 ;
		
		end if

	end if	

end if

commit;

cb_retrieve.triggerevent(clicked!)	
sle_msg.text = "삭제하였습니다"


end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1140
integer x = 896
integer y = 2940
end type

event cb_retrieve::clicked;string licode, saupcd

if dw_dept.accepttext() = -1 then return -1

licode = dw_dept.getitemstring(1,"deptcode")
saupcd = dw_dept.GetItemString(1,"saupcd")

if licode = "" or isnull(licode) then licode = '%'
if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

if dw_list.retrieve(licode,saupcd) <= 0 then 
	messagebox('확인','부서원이 없습니다',stopsign!)
	dw_dept.setcolumn("deptcode")
	dw_dept.setfocus()
	return -1
end if

dw_empno.setcolumn("empno1")
dw_empno.setfocus()

end event

type st_1 from w_inherite_standard`st_1 within w_psd1140
integer x = 0
integer y = 2392
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1140
integer x = 1893
integer y = 2876
end type

event cb_cancel::clicked;call super::clicked;dw_dept.reset()
dw_empno.reset()
dw_list.reset()

dw_dept.insertrow(0)
dw_empno.insertrow(0)
//dw_list.insertrow(0)

dw_dept.setcolumn("deptcode")
dw_dept.setfocus()

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1140
integer x = 2793
integer y = 2380
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1140
integer x = 411
integer y = 2392
integer width = 1778
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1140
integer x = 1993
integer y = 2348
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1140
integer x = 96
integer y = 2356
integer width = 448
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1140
integer x = 3456
integer y = 2348
integer width = 3557
long backcolor = 80269524
end type

type dw_list from datawindow within w_psd1140
event ue_enter pbm_dwnprocessenter
event ue_keydown ( )
integer x = 110
integer y = 376
integer width = 3442
integer height = 1600
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1140_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this),256,9,0)
return 1
end event

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event rowfocuschanged;this.setrowfocusindicator(hand!)
end event

event rbuttondown;long getrow

if dw_list.accepttext() = -1 then return

setnull(gs_code)
setnull(gs_codename)

getrow = dw_list.getrow()

if dw_list.GetColumnName() = "y_empno1" then
	open(w_employee_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	
	dw_list.setitem(getrow,"y_empno1",gs_code)
	dw_list.setitem(getrow,"y_empname1",gs_codename)
	
	dw_list.setcolumn("z_empno2")
	dw_list.setfocus()
	return
end if

if dw_list.GetColumnName() = "z_empno2" then
	open(w_employee_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	
	dw_list.setitem(getrow,"z_empno2",gs_code)
	dw_list.setitem(getrow,"z_empname2",gs_codename)
			
	return
end if
	
end event

event itemchanged;string icode, iname
long getrow

if dw_list.accepttext() = -1 then return

setnull(icode)
setnull(iname)

getrow = dw_list.getrow()

if dw_list.GetColumnName() = "y_empno1" then
	icode = this.gettext()
	if icode = "" or isnull(icode) then 
		dw_list.setitem(getrow,"y_empname1","")
	else
		select empname into :iname
		from p1_master
		where empno = :icode ;
		
		if sqlca.sqlcode <> 0 then
			messagebox('확인','사번이 존재하지않습니다',stopsign!)
			triggerevent(rbuttondown!)
			return 
		else
			dw_list.setitem(getrow,"y_empno1",icode)
			dw_list.setitem(getrow,"y_empname1",iname)
		end if
		
	end if
	return
end if

if dw_list.GetColumnName() = "z_empno2" then
	icode = this.gettext()
	if icode = "" or isnull(icode) then 
		dw_list.setitem(getrow,"z_empname2","")
	else
		select empname into :iname
		from p1_master
		where empno = :icode ;
		
		if sqlca.sqlcode <> 0 then
			messagebox('확인','사번이 존재하지않습니다',stopsign!)
			triggerevent(rbuttondown!)
			return 
		else
			dw_list.setitem(getrow,"z_empno2",icode)
			dw_list.setitem(getrow,"z_empname2",iname)
		end if
		
	end if
	return
end if
	
end event

event itemerror;return 1
end event

type dw_dept from datawindow within w_psd1140
event ue_enter pbm_dwnprocessenter
event type long ue_keydown ( keycode key,  unsignedlong keyflags )
integer x = 201
integer y = 32
integer width = 2153
integer height = 112
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1140_dept"
boolean border = false
boolean livescroll = true
end type

event itemchanged;cb_retrieve.triggerevent(clicked!)
end event

event itemerror;return 1
end event

type dw_empno from datawindow within w_psd1140
event ue_keydown pbm_dwnkey
integer x = 55
integer y = 168
integer width = 2633
integer height = 88
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1140_emp"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemchanged;string icode, iname

if this.accepttext() = -1 then return -1

setnull(icode)
setnull(iname)

if dw_empno.GetColumnName() = "empno1" then
	icode = this.gettext()
	if not(icode = "" or isnull(icode)) then 

		select empname into :iname
		from p1_master
		where empno = :icode ;
		
		if sqlca.sqlcode <> 0 then
			messagebox('확인','사번이 존재하지않습니다',stopsign!)
			triggerevent(rbuttondown!)
			return 1
		else
			dw_empno.setitem(1,"empno1",icode)
			dw_empno.setitem(1,"empname1",iname)
		end if
		
	end if
	return 1
end if


if dw_empno.GetColumnName() = "empno2" then
	icode = this.gettext()
	if not(icode = "" or isnull(icode)) then 
		
		select empname into :iname
		from p1_master
		where empno = :icode ;
		
		if sqlca.sqlcode <> 0 then
			messagebox('확인','사번이 존재하지않습니다',stopsign!)
			triggerevent(rbuttondown!)
			return 1
		else
			dw_empno.setitem(1,"empno2",icode)
			dw_empno.setitem(1,"empname2",iname)
		end if
		
	end if
	return 1
end if
	
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

if dw_empno.accepttext() = -1 then return

if dw_empno.GetColumnName() = "empno1" then
	open(w_employee_popup)
	
	if isnull(gs_code) or gs_code = '' then return -1
	
	dw_empno.setitem(1,"empno1",gs_code)
	dw_empno.setitem(1,"empname1",gs_codename)
	
	dw_empno.setcolumn("empno2")
	dw_empno.setfocus()
	
	return 1
end if

if dw_empno.GetColumnName() = "empno2" then
	open(w_employee_popup)
	
	if isnull(gs_code) or gs_code = '' then return -1
	
	dw_empno.setitem(1,"empno2",gs_code)
	dw_empno.setitem(1,"empname2",gs_codename)
	
	return 1
end if
	
end event

event itemerror;return 1
end event

type cb_1 from commandbutton within w_psd1140
integer x = 4105
integer y = 228
integer width = 494
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "2차고과 일괄적용"
end type

event clicked;long rowcount, row
string iempno1, iempno2, iempname1, iempname2

rowcount = dw_list.rowcount()

iempno2 = dw_empno.getitemstring(1,"empno2")
iempname2 = dw_empno.getitemstring(1,"empname2")


if iempno2 = "" or isnull(iempno2) then
	messagebox('확인','2차고과자를 확인하십시요', stopsign!)
	dw_empno.setcolumn("empno2")
	dw_empno.setfocus()
	return
end if

if messagebox('확인','2차 고과자 : '+iempname2 +'~r~n~n' + &
							'일괄적용하시겠습니까?',question!, yesno!) = 1 then
	for row = 1 to rowcount
		dw_list.setitem(row,"empno2",iempno2)
		dw_list.setitem(row,"empname2",iempname2)
	next
end if
end event

type cb_2 from commandbutton within w_psd1140
integer x = 3602
integer y = 228
integer width = 494
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "1차고과 일괄적용"
end type

event clicked;long rowcount, row
string iempno1, iempno2, iempname1, iempname2

rowcount = dw_list.rowcount()

iempno1 = dw_empno.getitemstring(1,"empno1")
iempname1 = dw_empno.getitemstring(1,"empname1")

if iempno1 = "" or isnull(iempno1) then
	messagebox('확인','1차고과자를 확인하십시요', stopsign!)
	dw_empno.setcolumn("empno1")
	dw_empno.setfocus()
	return
end if


if messagebox('확인','1차 고과자 : '+iempname1 +'~r~n' + &
							'일괄적용하시겠습니까?',question!, yesno!) = 1 then
	for row = 1 to rowcount
		dw_list.setitem(row,"empno1",iempno1)
		dw_list.setitem(row,"empname1",iempname1)
	next
end if
end event

type rr_1 from roundrectangle within w_psd1140
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 50
integer y = 8
integer width = 3415
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1140
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 332
integer width = 4087
integer height = 1912
integer cornerheight = 40
integer cornerwidth = 55
end type

