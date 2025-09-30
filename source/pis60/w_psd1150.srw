$PBExportHeader$w_psd1150.srw
$PBExportComments$고과항목 및 배점 등록
forward
global type w_psd1150 from w_inherite_standard
end type
type dw_detail from datawindow within w_psd1150
end type
type dw_emp from datawindow within w_psd1150
end type
type dw_list from datawindow within w_psd1150
end type
type st_2 from statictext within w_psd1150
end type
type rr_1 from roundrectangle within w_psd1150
end type
type rr_2 from roundrectangle within w_psd1150
end type
type rr_3 from roundrectangle within w_psd1150
end type
end forward

global type w_psd1150 from w_inherite_standard
integer width = 4622
integer height = 2480
string title = "고과항목및 배점등록"
dw_detail dw_detail
dw_emp dw_emp
dw_list dw_list
st_2 st_2
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_psd1150 w_psd1150

on w_psd1150.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_emp=create dw_emp
this.dw_list=create dw_list
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_emp
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
end on

on w_psd1150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_emp)
destroy(this.dw_list)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;string saupcd

dw_emp.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_detail.settransobject(sqlca)

dw_emp.insertrow(0)
//dw_detail.insertrow(0)

f_set_saupcd(dw_emp, 'saupcd', '1')
is_saupcd = gs_saupcd

saupcd = dw_emp.GetItemString(1,'saupcd')
dw_list.retrieve(saupcd)

dw_emp.setcolumn(1)
dw_emp.setfocus()
end event

type p_mod from w_inherite_standard`p_mod within w_psd1150
integer x = 4027
integer y = 28
end type

event p_mod::clicked;call super::clicked;long getrow, rowcount, ipont, ls_cnt, ipont_tmp
string iempno, imrl, imrm, imrs,ls_mrflag, saupcd

if dw_detail.accepttext() = -1 then return -1

getrow = dw_detail.getrow()
rowcount = dw_detail.rowcount()
iempno = dw_emp.getitemstring(1,"empno")

if iempno = "" or isnull(iempno) then 
	messagebox('저장확인','피고과자를 확인하세요',stopsign!)
	dw_emp.setcolumn("empno")
	dw_emp.setfocus()
	return -1
end if

if messagebox('저장확인','저장하시겠습니까',question!,yesno!) = 1 then
	
	setpointer(hourglass!)
	
	for getrow = 1 to rowcount

		ipont = dw_detail.getitemdecimal(getrow,"points")
		if isnull(ipont) then ipont = 0
		
		imrl = dw_detail.getitemstring(getrow,"mrlcode")
		imrm = dw_detail.getitemstring(getrow,"mrmcode")
		imrs = dw_detail.getitemstring(getrow,"mrscode")
		
		ipont_tmp = ipont_tmp +  ipont
	next
		
	if (ipont_tmp > 0 and ipont_tmp < 100) or (ipont_tmp > 0 and ipont_tmp > 100)  then
		messagebox('저장확인','총 합계 배점이 100점이 되어야 합니다',stopsign!)
		dw_detail.setcolumn("points")
		dw_detail.scrolltorow(getrow)
		dw_detail.setfocus()
		return -1
	end if	
			
	if  ipont_tmp = 100 then
		
		for getrow = 1 to rowcount
			ipont = dw_detail.getitemdecimal(getrow,"points")
			imrl = dw_detail.getitemstring(getrow,"mrlcode")
			imrm = dw_detail.getitemstring(getrow,"mrmcode")
			imrs = dw_detail.getitemstring(getrow,"mrscode")
				
			select nvl(count(*),0) into :ls_cnt
			from p6_meritperson
			where EMPNO = :iempno and
					mrlcode = :imrl and
					mrmcode = :imrm and
					mrscode = :imrs ;
	
			if (ls_cnt = 0 or isnull(ls_cnt)) and not ( isnull(ipont) or ipont = 0 ) then 
							
				insert into p6_meritperson (empno,mrlcode,mrmcode,mrscode,points,mrflag)
				values (:iempno, :imrl, :imrm, :imrs, :ipont, 'N') ;
					
			else
							
				select mrflag into :ls_mrflag
				from p6_meritperson
				where EMPNO = :iempno and
						mrlcode = :imrl and
						mrmcode = :imrm and
						mrscode = :imrs ;
						
				if ls_mrflag = 'Y' then 
					messagebox('확인','배점이 확정된 자료이므로 수정할수없습니다')
					cb_retrieve.triggerevent(clicked!)
					return -1
				elseif ls_mrflag = 'N' then
					
					update p6_meritperson 
					set points = :ipont, mrflag = 'N'
					WHERE EMPNO = :iempno and
							mrlcode = :imrl and
							mrmcode = :imrm and
							mrscode = :imrs ;
				end if
	
			end if
		
		next
	
				
	elseif ipont_tmp = 0 then
		
		for getrow = 1 to rowcount
			ipont = dw_detail.getitemdecimal(getrow,"points")
			imrl = dw_detail.getitemstring(getrow,"mrlcode")
			imrm = dw_detail.getitemstring(getrow,"mrmcode")
			imrs = dw_detail.getitemstring(getrow,"mrscode")
				
			select nvl(count(*),0) into :ls_cnt
			from p6_meritperson
			where EMPNO = :iempno and
					mrlcode = :imrl and
					mrmcode = :imrm and
					mrscode = :imrs ;
	
			if not (ls_cnt = 0 or isnull(ls_cnt)) and ( isnull(ipont) or ipont = 0 ) then 
				
				select mrflag into :ls_mrflag
				from p6_meritperson
				where EMPNO = :iempno and
						mrlcode = :imrl and
						mrmcode = :imrm and
						mrscode = :imrs ;
						
				if ls_mrflag = 'Y' then 
					
					messagebox('확인','배점이 확정된 자료이므로 수정할수없습니다')
					cb_retrieve.triggerevent(clicked!)
					return -1
					
				elseif ls_mrflag = 'N' then
	
					delete from p6_meritperson where EMPNO = :iempno ;
				
				end if
			
			end if

		next
	
	end if

END IF	

commit;

setpointer(arrow!)

saupcd = dw_emp.GetItemString(1,"saupcd")

cb_retrieve.triggerevent(clicked!)
w_mdi_frame.sle_msg.text = "저장되었습니다"
dw_list.retrieve(saupcd)


end event

type p_del from w_inherite_standard`p_del within w_psd1150
integer x = 3941
integer y = 2672
end type

type p_inq from w_inherite_standard`p_inq within w_psd1150
integer x = 3854
integer y = 28
end type

event p_inq::clicked;call super::clicked;long cnt
string iempno, saupcd

if dw_emp.accepttext() = -1 then return -1

iempno = dw_emp.getitemstring(1,"empno")
saupcd = dw_emp.GetItemString(1,"saupcd")

if iempno = "" or isnull(iempno) then 
	messagebox('저장확인','피고과자를 확인하세요',stopsign!)
	dw_emp.setcolumn("empno")
	dw_emp.setfocus()
	return -1
end if

if saupcd = ""  or  isnull(saupcd) then	saupcd = '%'

dw_detail.retrieve(iempno,saupcd)
dw_detail.setcolumn("points")
dw_detail.scrolltorow(dw_detail.rowcount())
dw_detail.setfocus()

end event

type p_print from w_inherite_standard`p_print within w_psd1150
integer x = 256
integer y = 2956
end type

type p_can from w_inherite_standard`p_can within w_psd1150
integer x = 4206
integer y = 28
end type

event p_can::clicked;call super::clicked;
dw_emp.reset()
dw_detail.reset()

dw_emp.insertrow(0)
//dw_detail.insertrow(0)
dw_list.retrieve()

dw_emp.setcolumn(1)
dw_emp.setfocus()


end event

type p_exit from w_inherite_standard`p_exit within w_psd1150
integer y = 28
end type

type p_ins from w_inherite_standard`p_ins within w_psd1150
integer x = 3739
integer y = 2676
end type

type p_search from w_inherite_standard`p_search within w_psd1150
integer x = 78
integer y = 2956
end type

type p_addrow from w_inherite_standard`p_addrow within w_psd1150
integer x = 777
integer y = 2956
end type

type p_delrow from w_inherite_standard`p_delrow within w_psd1150
integer x = 951
integer y = 2956
end type

type dw_insert from w_inherite_standard`dw_insert within w_psd1150
integer x = 2464
integer y = 2864
end type

type st_window from w_inherite_standard`st_window within w_psd1150
integer x = 2176
integer y = 2640
integer width = 640
integer taborder = 100
long backcolor = 80269524
end type

type cb_exit from w_inherite_standard`cb_exit within w_psd1150
integer x = 2030
integer y = 2980
integer taborder = 80
end type

type cb_update from w_inherite_standard`cb_update within w_psd1150
integer x = 1856
integer y = 2972
integer width = 261
integer taborder = 50
end type

event cb_update::clicked;call super::clicked;long getrow, rowcount, ipont, ls_cnt, ipont_tmp
string iempno, imrl, imrm, imrs,ls_mrflag

if dw_detail.accepttext() = -1 then return -1

getrow = dw_detail.getrow()
rowcount = dw_detail.rowcount()
iempno = dw_emp.getitemstring(1,"empno")

if iempno = "" or isnull(iempno) then 
	messagebox('저장확인','피고과자를 확인하세요',stopsign!)
	dw_emp.setcolumn("empno")
	dw_emp.setfocus()
	return -1
end if

if messagebox('저장확인','저장하시겠습니까',question!,yesno!) = 1 then
	
	setpointer(hourglass!)
	
	for getrow = 1 to rowcount

		ipont = dw_detail.getitemdecimal(getrow,"points")
		if isnull(ipont) then ipont = 0
		
		imrl = dw_detail.getitemstring(getrow,"mrlcode")
		imrm = dw_detail.getitemstring(getrow,"mrmcode")
		imrs = dw_detail.getitemstring(getrow,"mrscode")
		
		ipont_tmp = ipont_tmp +  ipont
	next
		
	if (ipont_tmp > 0 and ipont_tmp < 100) or (ipont_tmp > 0 and ipont_tmp > 100)  then
		messagebox('저장확인','총 합계 배점이 100점이 되어야 합니다',stopsign!)
		dw_detail.setcolumn("points")
		dw_detail.scrolltorow(getrow)
		dw_detail.setfocus()
		return -1
	end if	
			
	if  ipont_tmp = 100 then
		
		for getrow = 1 to rowcount
			ipont = dw_detail.getitemdecimal(getrow,"points")
			imrl = dw_detail.getitemstring(getrow,"mrlcode")
			imrm = dw_detail.getitemstring(getrow,"mrmcode")
			imrs = dw_detail.getitemstring(getrow,"mrscode")
				
			select nvl(count(*),0) into :ls_cnt
			from p6_meritperson
			where EMPNO = :iempno and
					mrlcode = :imrl and
					mrmcode = :imrm and
					mrscode = :imrs ;
	
			if (ls_cnt = 0 or isnull(ls_cnt)) and not ( isnull(ipont) or ipont = 0 ) then 
							
				insert into p6_meritperson (empno,mrlcode,mrmcode,mrscode,points,mrflag)
				values (:iempno, :imrl, :imrm, :imrs, :ipont, 'N') ;
					
			else
							
				select mrflag into :ls_mrflag
				from p6_meritperson
				where EMPNO = :iempno and
						mrlcode = :imrl and
						mrmcode = :imrm and
						mrscode = :imrs ;
						
				if ls_mrflag = 'Y' then 
					messagebox('확인','배점이 확정된 자료이므로 수정할수없습니다')
					cb_retrieve.triggerevent(clicked!)
					return -1
				elseif ls_mrflag = 'N' then
					
					update p6_meritperson 
					set points = :ipont, mrflag = 'N'
					WHERE EMPNO = :iempno and
							mrlcode = :imrl and
							mrmcode = :imrm and
							mrscode = :imrs ;
				end if
	
			end if
		
		next
	
				
	elseif ipont_tmp = 0 then
		
		for getrow = 1 to rowcount
			ipont = dw_detail.getitemdecimal(getrow,"points")
			imrl = dw_detail.getitemstring(getrow,"mrlcode")
			imrm = dw_detail.getitemstring(getrow,"mrmcode")
			imrs = dw_detail.getitemstring(getrow,"mrscode")
				
			select nvl(count(*),0) into :ls_cnt
			from p6_meritperson
			where EMPNO = :iempno and
					mrlcode = :imrl and
					mrmcode = :imrm and
					mrscode = :imrs ;
	
			if not (ls_cnt = 0 or isnull(ls_cnt)) and ( isnull(ipont) or ipont = 0 ) then 
				
				select mrflag into :ls_mrflag
				from p6_meritperson
				where EMPNO = :iempno and
						mrlcode = :imrl and
						mrmcode = :imrm and
						mrscode = :imrs ;
						
				if ls_mrflag = 'Y' then 
					
					messagebox('확인','배점이 확정된 자료이므로 수정할수없습니다')
					cb_retrieve.triggerevent(clicked!)
					return -1
					
				elseif ls_mrflag = 'N' then
	
					delete from p6_meritperson where EMPNO = :iempno ;
				
				end if
			
			end if

		next
	
	end if

END IF	

commit;

setpointer(arrow!)


cb_retrieve.triggerevent(clicked!)
sle_msg.text = "저장되었습니다"
dw_list.retrieve()


end event

type cb_insert from w_inherite_standard`cb_insert within w_psd1150
integer x = 896
integer y = 2736
end type

type cb_delete from w_inherite_standard`cb_delete within w_psd1150
integer x = 1248
integer y = 2736
integer taborder = 90
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_psd1150
integer x = 1248
integer y = 2996
integer taborder = 30
boolean enabled = false
end type

event cb_retrieve::clicked;call super::clicked;long cnt
string iempno, saupcd

if dw_emp.accepttext() = -1 then return -1

iempno = dw_emp.getitemstring(1,"empno")
saupcd = dw_emp.GetItemString(1,"saupcd")

if iempno = "" or isnull(iempno) then 
	messagebox('저장확인','피고과자를 확인하세요',stopsign!)
	dw_emp.setcolumn("empno")
	dw_emp.setfocus()
	return -1
end if


dw_detail.retrieve(iempno, saupcd)
dw_detail.setcolumn("points")
dw_detail.scrolltorow(dw_detail.rowcount())
dw_detail.setfocus()

end event

type st_1 from w_inherite_standard`st_1 within w_psd1150
integer y = 2640
long backcolor = 80269524
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_psd1150
integer x = 1774
integer y = 2988
integer taborder = 60
end type

event cb_cancel::clicked;call super::clicked;
dw_emp.reset()
dw_detail.reset()

dw_emp.insertrow(0)
//dw_detail.insertrow(0)
dw_list.retrieve()

dw_emp.setcolumn(1)
dw_emp.setfocus()


end event

type dw_datetime from w_inherite_standard`dw_datetime within w_psd1150
integer x = 2816
integer y = 2628
end type

type sle_msg from w_inherite_standard`sle_msg within w_psd1150
integer x = 430
integer y = 2640
integer width = 1792
long backcolor = 80269524
end type

type gb_2 from w_inherite_standard`gb_2 within w_psd1150
integer x = 2359
integer y = 2596
integer width = 1184
long backcolor = 80269524
end type

type gb_1 from w_inherite_standard`gb_1 within w_psd1150
integer x = 0
integer y = 2604
integer width = 430
long backcolor = 80269524
end type

type gb_10 from w_inherite_standard`gb_10 within w_psd1150
integer x = 3474
integer y = 2596
integer width = 3543
long backcolor = 80269524
end type

type dw_detail from datawindow within w_psd1150
event ue_enter pbm_dwnprocessenter
integer x = 1189
integer y = 472
integer width = 2889
integer height = 1688
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1150_detail1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enter;send(handle(this),256,9,0)
return 1
end event

event rowfocuschanged;this.setrowfocusindicator(hand!)
return 1
end event

type dw_emp from datawindow within w_psd1150
event ue_keydown pbm_dwnkey
integer x = 91
integer y = 88
integer width = 2263
integer height = 104
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1150_emp"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

if dw_emp.GetColumnName() = "empno" then
	open(w_employee_popup)
	
	if gs_code = "" or isnull(gs_code) then return -1
	
	dw_emp.setitem(1,"empno",gs_code)
	dw_emp.setitem(1,"empno_1",gs_codename)

end if

triggerevent(itemchanged!)
end event

event itemchanged;string iempno, iempname

this.accepttext()

iempno = this.getitemstring(1,"empno")
if this.getcolumnname() = "empno" then

	if not(iempno = "" or isnull(iempno)) then 
		
		select p1_master.empname into :iempname
		from p1_master, p6_meritlevel
		where p1_master.empno = p6_meritlevel.empno and
				p1_master.empno = :iempno ;
		
		if sqlca.sqlcode <> 0 then
			messagebox('확인','피고과자로 등록되지 않은사번입니다',stopsign!)
			return 1
		end if
		
		dw_emp.setitem(1,"empno",iempno)
		dw_emp.setitem(1,"empno_1",iempname)
		cb_retrieve.triggerevent(clicked!)
	end if
end if
end event

type dw_list from datawindow within w_psd1150
integer x = 210
integer y = 476
integer width = 745
integer height = 1688
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_psd1150_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string iempno, iempname

if dw_list.accepttext() = -1 then return -1

if row <= 0 then return -1

dw_list.selectrow(0,false)
dw_list.selectrow(row,true)

iempno = this.getitemstring(row,"p6_meritperson_empno")
iempname = this.getitemstring(row,"p1_master_empname")

dw_detail.retrieve(iempno)
dw_emp.setitem(1,"empno",iempno)
dw_emp.setitem(1,"empno_1",iempname)
dw_detail.setcolumn("points")
dw_detail.scrolltorow(dw_detail.rowcount())
dw_detail.setfocus()

	
end event

type st_2 from statictext within w_psd1150
integer x = 242
integer y = 392
integer width = 517
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "등록자 목록"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_psd1150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 41
integer y = 16
integer width = 3461
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_psd1150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 344
integer width = 1006
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_psd1150
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1074
integer y = 348
integer width = 3465
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

