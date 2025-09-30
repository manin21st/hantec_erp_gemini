$PBExportHeader$w_pik1121.srw
$PBExportComments$** 년월차 내역 수정
forward
global type w_pik1121 from w_inherite_standard
end type
type rr_2 from roundrectangle within w_pik1121
end type
type dw_update from u_key_enter within w_pik1121
end type
type st_7 from statictext within w_pik1121
end type
type st_9 from statictext within w_pik1121
end type
type sle_findname from singlelineedit within w_pik1121
end type
type sle_find from singlelineedit within w_pik1121
end type
type p_clean from uo_picture within w_pik1121
end type
type st_10 from statictext within w_pik1121
end type
type gb_6 from gb_1 within w_pik1121
end type
type rr_1 from roundrectangle within w_pik1121
end type
type rr_3 from roundrectangle within w_pik1121
end type
type ln_6 from line within w_pik1121
end type
type ln_7 from line within w_pik1121
end type
type dw_ip from datawindow within w_pik1121
end type
end forward

global type w_pik1121 from w_inherite_standard
string title = "년차 수정"
rr_2 rr_2
dw_update dw_update
st_7 st_7
st_9 st_9
sle_findname sle_findname
sle_find sle_find
p_clean p_clean
st_10 st_10
gb_6 gb_6
rr_1 rr_1
rr_3 rr_3
ln_6 ln_6
ln_7 ln_7
dw_ip dw_ip
end type
global w_pik1121 w_pik1121

type variables
string ls_dkdeptcode
int li_level
end variables

on w_pik1121.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.dw_update=create dw_update
this.st_7=create st_7
this.st_9=create st_9
this.sle_findname=create sle_findname
this.sle_find=create sle_find
this.p_clean=create p_clean
this.st_10=create st_10
this.gb_6=create gb_6
this.rr_1=create rr_1
this.rr_3=create rr_3
this.ln_6=create ln_6
this.ln_7=create ln_7
this.dw_ip=create dw_ip
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.dw_update
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.st_9
this.Control[iCurrent+5]=this.sle_findname
this.Control[iCurrent+6]=this.sle_find
this.Control[iCurrent+7]=this.p_clean
this.Control[iCurrent+8]=this.st_10
this.Control[iCurrent+9]=this.gb_6
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_3
this.Control[iCurrent+12]=this.ln_6
this.Control[iCurrent+13]=this.ln_7
this.Control[iCurrent+14]=this.dw_ip
end on

on w_pik1121.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.dw_update)
destroy(this.st_7)
destroy(this.st_9)
destroy(this.sle_findname)
destroy(this.sle_find)
destroy(this.p_clean)
destroy(this.st_10)
destroy(this.gb_6)
destroy(this.rr_1)
destroy(this.rr_3)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.dw_ip)
end on

event open;call super::open;string sName, sabu  

dw_update.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)
dw_update.Reset()
dw_ip.insertrow(0)

dw_ip.SetItem(1,"workgubun",'1')
dw_ip.object.workmonth_t.text = '처리년월'

dw_ip.object.t_2.Visible     = False
dw_ip.object.p_2.Visible     = False		
dw_ip.object.empno.Visible   = False
dw_ip.object.empname.Visible = False


dw_ip.SetItem(1,"workmonth",String(Left(f_Today(),6)))

f_set_saupcd(dw_ip, 'sabu', '1')
is_saupcd = gs_saupcd


// 환경변수 근태담당부서 
SELECT dataname
	INTO :ls_dkdeptcode
	FROM p0_syscnfg
	WHERE sysgu = 'P' and serial = 1 and lineno = '1' ;

if gs_dept = ls_dkdeptcode  then
	dw_ip.SetItem(1,"deptcode",'')
else
	dw_ip.SetItem(1,"deptcode",gs_dept)
	/*부서명*/
	SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :gs_dept ); 
	if sqlca.sqlcode <> 0 then
	else
		dw_ip.SetItem(1,"deptcode",sname)
	end if	
end if	

p_clean.visible = false
dw_ip.SetColumn('workmonth')
dw_ip.SetFocus()
end event

type p_mod from w_inherite_standard`p_mod within w_pik1121
integer x = 4073
end type

event p_mod::clicked;int i, jday,yearday
dw_Update.AcceptText()

IF dw_Update.RowCount() <=0 THEN Return

IF MessageBox("확 인","저장하시겠습니까?",Question!,YesNo!) = 2 THEN Return

// 잔여일수 Setting
if dw_ip.GetItemString(1,"workgubun") = '1' then
	For i = 1 to  dw_Update.RowCount()
		 jday = dw_update.getitemnumber(i,"calc_jday")
		 yearday = dw_update.getitemnumber(i,"calc_yearday")
		 dw_Update.setitem(i,"jday",jday) 
		 dw_Update.setitem(i,"yearday",yearday) 
	NEXT	
end if
IF dw_Update.Update() > 0 THEN			
	COMMIT USING sqlca;
	
	ib_any_typing =False
	
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	F_Rollback()
	
	ib_any_typing = True
	
	Return
END IF

end event

type p_del from w_inherite_standard`p_del within w_pik1121
boolean visible = false
integer x = 5088
integer y = 2744
end type

type p_inq from w_inherite_standard`p_inq within w_pik1121
integer x = 3899
end type

event p_inq::clicked;call super::clicked;String sDept,sEmpNo,sYearMonth, sadddeptcode, sdeptcode,snull, sabu, slevel
SetNull(snull)

if dw_ip.Accepttext() = -1 then return -1

sYearMonth = trim(dw_ip.GetItemString(1,"workmonth"))
sDept      = trim(dw_ip.GetItemString(1,"deptcode"))
if sdept = '' then sdept = '%'

sabu = dw_ip.GetItemString(1,"sabu")
slevel = dw_ip.GetItemString(1,"level")
if IsNull(sabu) or sabu = '' then
	messagebox("확인","사업장을 확인하십시요!")
	dw_ip.setcolumn('sabu')
	dw_ip.setfocus()
	return
end if
if IsNull(slevel) or slevel = '' then slevel = '%'
IF dw_ip.GetItemString(1,"workgubun") = '1' THEN													/*년차*/

	IF sYearMonth = "" OR IsNull(sYearMonth) THEN
		MessageBox("확 인","처리년월을 입력하세요!!")
		dw_ip.SetColumn('workmonth')
		dw_ip.SetFocus()
		Return
	END IF
	
//	IF sDept = "" OR IsNull(sDept) THEN
//		MessageBox("확 인","소속부서를 입력하세요!!")
//		sle_dept.SetFocus()
//		Return
//	END IF
	IF li_level = 3 then
		sdeptcode = sDept
		sadddeptcode = '%'
	ELSE
		sadddeptcode = sDept
		sdeptcode = '%'
	END IF	

	IF dw_update.Retrieve(Gs_Company,sYearMonth,sDeptcode,sadddeptcode, sabu, slevel) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_ip.SetColumn('deptcode')
		dw_ip.SetFocus()
		Return
	END IF
dw_update.SetSort("p1_master_deptcode A,p1_master_gradecode A,p1_master_levelcode A,p1_master_salary A,empno A")
dw_update.sort()						
ELSE
	sEmpNo = dw_ip.GetItemString(1,"empno")
	
	IF sYearMonth = "" OR IsNull(sYearMonth) THEN
		MessageBox("확 인","기준년월을 입력하세요!!")
		dw_ip.SetColumn('workmonth')
		dw_ip.SetFocus()
		Return
	END IF
	
	//IF sDept = "" OR IsNull(sDept) THEN
	//	MessageBox("확 인","소속부서를 입력하세요!!")
	//	sle_dept.SetFocus()
	//	Return
	//END IF
	
	IF li_level = 3 then
		sdeptcode = sDept
		sadddeptcode = '%'
	ELSE
		sadddeptcode = sDept
		sdeptcode = '%'
	END IF
	
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		sEmpNo = '%'
	END IF

	IF dw_update.Retrieve(Gs_Company,sYearMonth,sDeptcode,sadddeptcode,sEmpNo, sabu,slevel) <=0 THEN
		MessageBox("확 인","조회한 자료가 없습니다!!")
		dw_ip.SetColumn('deptcode')
		dw_ip.SetFocus()
		Return
	END IF	
	dw_update.SetSort("p1_master_deptcode A,p1_master_gradecode A,p1_master_levelcode A,p1_master_salary A, empno A,yymm A")
	dw_update.sort()						
	
END IF

if dw_update.rowcount() > 0 and dw_ip.GetItemString(1,"workgubun") = '1' then
	p_clean.visible = true	
else
	p_clean.visible = false	
end if
end event

type p_print from w_inherite_standard`p_print within w_pik1121
boolean visible = false
integer x = 4393
integer y = 2744
end type

type p_can from w_inherite_standard`p_can within w_pik1121
integer x = 4247
end type

event p_can::clicked;call super::clicked;dw_update.Reset()
p_clean.visible = false
dw_ip.SetColumn('workmonth')
dw_ip.SetFocus()
end event

type p_exit from w_inherite_standard`p_exit within w_pik1121
integer x = 4421
end type

type p_ins from w_inherite_standard`p_ins within w_pik1121
boolean visible = false
integer x = 4567
integer y = 2744
end type

type p_search from w_inherite_standard`p_search within w_pik1121
boolean visible = false
integer x = 4219
integer y = 2744
string picturename = "C:\erpman\Image\button_up.gif"
end type

type p_addrow from w_inherite_standard`p_addrow within w_pik1121
boolean visible = false
integer x = 4741
integer y = 2744
end type

type p_delrow from w_inherite_standard`p_delrow within w_pik1121
boolean visible = false
integer x = 4914
integer y = 2744
end type

type dw_insert from w_inherite_standard`dw_insert within w_pik1121
boolean visible = false
integer x = 3712
integer y = 2668
end type

type st_window from w_inherite_standard`st_window within w_pik1121
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pik1121
boolean visible = false
integer x = 3086
integer y = 2584
integer taborder = 100
end type

type cb_update from w_inherite_standard`cb_update within w_pik1121
boolean visible = false
integer x = 2382
integer y = 2584
integer taborder = 80
end type

type cb_insert from w_inherite_standard`cb_insert within w_pik1121
boolean visible = false
integer x = 1394
integer y = 2596
integer taborder = 0
end type

type cb_delete from w_inherite_standard`cb_delete within w_pik1121
string tag = "Bubblehelp=지급된 15개 이상은 소멸됩니다"
boolean visible = false
integer x = 1819
integer y = 2576
integer width = 411
integer taborder = 0
string text = "일괄소멸(&D)"
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pik1121
boolean visible = false
integer x = 1038
integer y = 2596
integer taborder = 70
end type

type st_1 from w_inherite_standard`st_1 within w_pik1121
boolean visible = false
boolean enabled = true
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pik1121
boolean visible = false
integer x = 2715
integer y = 2584
integer taborder = 90
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pik1121
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pik1121
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pik1121
boolean visible = false
integer x = 2345
integer y = 2524
integer width = 1143
end type

type gb_1 from w_inherite_standard`gb_1 within w_pik1121
boolean visible = false
integer x = 1783
integer y = 2516
integer width = 485
end type

type gb_10 from w_inherite_standard`gb_10 within w_pik1121
boolean visible = false
integer x = 14
integer y = 2752
integer height = 128
end type

type rr_2 from roundrectangle within w_pik1121
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 233
integer y = 24
integer width = 3479
integer height = 304
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_update from u_key_enter within w_pik1121
integer x = 261
integer y = 344
integer width = 3296
integer height = 1876
integer taborder = 60
string dataobject = "d_pik1121_1"
boolean vscrollbar = true
boolean border = false
end type

event editchanged;ib_any_typing = True
end event

event itemchanged;call super::itemchanged;int  lrow
double icday, ikday, caljanday, ijday, isday, ibday, iyday, acday
string snull

setnull(snull)

lrow = this.getrow()
if this.Accepttext() = -1 then return

if dw_ip.GetItemString(1,"workgubun") = '1' then
	icday = this.Getitemnumber(lrow,'cday')
	ikday = this.Getitemnumber(lrow,'kday')
	caljanday = this.Getitemnumber(lrow,'calc_jday')

	
	if ikday > 0 then
		if icday = 0  then
			messagebox("확인","적치된 년차가 없습니다!")
			return
		end if
		acday = icday
		icday = icday - ikday
		ijday = icday
		if ijday <=0 then ijday = 0
		
		if icday < 0 then
			messagebox("확인","적치된 년차수를 확인하십시요!")
			this.setitem(lrow,'kday',snull)
			this.setitem(lrow,'cday',acday)
			this.setitem(lrow,'calc_jday',acday)
			return
		else
			this.setitem(lrow,'cday', icday)
         this.setitem(lrow,'calc_jday', ijday)
			this.setitem(lrow,'jday', ijday)
		end if
	end if
else
	iyday = this.Getitemnumber(lrow,'yday')
	ibday = this.Getitemnumber(lrow,'bday')
	isday = this.Getitemnumber(lrow,'sday')
	icday = this.Getitemnumber(lrow,'cday')
	ikday = this.Getitemnumber(lrow,'kday')
	
	ijday = ibday - isday
	if ijday < 0 then ijday = 0
	
	if iyday + ibday - isday < 0 then
		messagebox("확인","적치된 월차가 없습니다!")
		return
	else
		icday = iyday + ibday - isday
		ikday = icday
	end if
	   this.setitem(lrow,'jday', ijday)
		this.setitem(lrow,'cday', icday)
		this.setitem(lrow,'calc_jday', ijday)
		this.setitem(lrow,'kday', ikday)
		
end if

end event

type st_7 from statictext within w_pik1121
integer x = 2898
integer y = 216
integer width = 142
integer height = 52
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "성명"
boolean focusrectangle = false
end type

type st_9 from statictext within w_pik1121
integer x = 2898
integer y = 128
integer width = 142
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "사번"
boolean focusrectangle = false
end type

type sle_findname from singlelineedit within w_pik1121
integer x = 3058
integer y = 212
integer width = 567
integer height = 60
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 20
end type

event modified;
long lReturnRow

dw_update.SetRedraw(false)

dw_update.SetSort("empname A")
dw_update.Sort()
dw_update.SetRedraw(true)

IF trim(sle_findname.text)= '' OR ISNULL(trim(sle_findname.text)) THEN RETURN

lReturnRow = dw_update.Find("empname = '"+ trim(sle_findname.text) +"' ", 1, dw_update.RowCount())

dw_update.scrolltorow(lReturnRow)
dw_update.setrow(lReturnRow)

dw_update.SelectRow(0,False)
dw_update.SelectRow(lReturnRow,True)
dw_update.setfocus()

end event

type sle_find from singlelineedit within w_pik1121
integer x = 3058
integer y = 124
integer width = 320
integer height = 60
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 20
end type

event modified;
long lReturnRow

dw_update.SetRedraw(false)

dw_update.SetSort("empno A")
dw_update.Sort()
dw_update.SetRedraw(true)

IF trim(sle_find.text)= '' OR ISNULL(trim(sle_find.text)) THEN RETURN

lReturnRow = dw_update.Find("empno = '"+ trim(sle_find.text) +"' ", 1, dw_update.RowCount())

dw_update.scrolltorow(lReturnRow)
dw_update.setrow(lReturnRow)

dw_update.SelectRow(0,False)
dw_update.SelectRow(lReturnRow,True)
dw_update.setfocus()


end event

type p_clean from uo_picture within w_pik1121
integer x = 3726
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\Image\일괄삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\Image\일괄삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\Image\일괄삭제_up.gif"
end event

event clicked;call super::clicked;double kkday, scday
int lrow
string syymm, sempno, iempno, ls_gubn, ls_sabu

dw_ip.Accepttext()
syymm = trim(dw_ip.GetItemString(1,"workmonth"))
ls_gubn = dw_ip.GetitemString(1,'workgubun')
ls_sabu = dw_ip.GetitemString(1,'sabu')

if dw_update.rowcount() <= 0 then
	messagebox("확인","삭제할 자료가 없습니다!")
	return
else
 if messagebox("확인","해당월의 전체 자료를 삭제하시겠습니까?",Question!,YesNo!) = 2 then return
end if

if ls_gubn = '1'  then   //년차
	delete from p4_yearlist
	where yymm = :syymm and fun_get_saupcd(empno) = :ls_sabu;
else	
	delete from p4_monthlist
	where yymm = :syymm and fun_get_saupcd(empno) = :ls_sabu;
end if

if sqlca.sqlcode = 0 then
	commit;
	w_mdi_frame.sle_msg.text = '삭제완료!'
	dw_update.reset()
else
	rollback;
	messagebox("에러","삭제 에러")
end if

p_inq.Triggerevent(Clicked!)


end event

type st_10 from statictext within w_pik1121
integer x = 2926
integer y = 44
integer width = 165
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = " 찾기"
boolean focusrectangle = false
end type

type gb_6 from gb_1 within w_pik1121
integer x = 3685
integer y = 2532
integer width = 402
integer taborder = 70
end type

type rr_1 from roundrectangle within w_pik1121
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 233
integer y = 340
integer width = 3502
integer height = 1896
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1121
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2839
integer y = 60
integer width = 823
integer height = 248
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_6 from line within w_pik1121
integer linethickness = 1
integer beginx = 3058
integer beginy = 184
integer endx = 3383
integer endy = 184
end type

type ln_7 from line within w_pik1121
integer linethickness = 1
integer beginx = 3058
integer beginy = 272
integer endx = 3630
integer endy = 272
end type

type dw_ip from datawindow within w_pik1121
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 274
integer y = 44
integer width = 2560
integer height = 272
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1121_3"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String  sEmpNo,SetNull,sEmpName,sDeptCode,sDeptName, ls_name

this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF GetColumnName() = "empno" then
  sEmpNo = GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  SetITem(1,"empno",SetNull)
		  SetITem(1,"empname",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 SetITem(1,"empno",SetNull)
				 SetITem(1,"empname",SetNull)
				 RETURN 1 
			 END IF
				SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF
IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
END IF



IF GetColumnName() = "deptcode" then
  sDeptCode = GetItemString(1,"deptcode")

	  IF sDeptCode = '' or isnull(sDeptCode) THEN
		  SetITem(1,"deptcode",SetNull)
		  SetITem(1,"deptname",SetNull)
	  ELSE	
	SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sDeptName
   	FROM "P0_DEPT"  
   	WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
     		   ( "P0_DEPT"."DEPTCODE" = :sDeptCode ); 
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","부서코드를 확인하세요!!") 
				 SetITem(1,"deptcode",SetNull)
				 SetITem(1,"deptname",SetNull)
				 RETURN 1 
			 END IF
				SetITem(1,"deptname",sDeptName  )
				
	 END IF
END IF

IF GetColumnName() = "workgubun" THEN
	dw_update.SetRedraw(False)
	
	IF GetItemString(1,"workgubun") = '2' THEN

		dw_update.Dataobject = "d_pik1121_1"

		object.workmonth_t.text = '처리년월'

		object.t_2.Visible     = False
		object.p_2.Visible     = False		
		object.empno.Visible   = False
		object.empname.Visible = False

		SetColumn('deptcode')
		this.SetFocus()
		
	ELSEIF GetItemString(1,"workgubun") = '1' THEN

		dw_update.Dataobject = "d_pik1121_2"

		object.workmonth_t.text = '기준년월'

		object.t_2.Visible     = True
		object.p_2.Visible     = True
		object.empno.Visible   = True
		object.empname.Visible = True


		SetColumn('deptcode')
		this.SetFocus()
	END IF
	
	dw_update.SetTransobject(sqlca)
	dw_update.Reset()
	dw_update.SetRedraw(True)
END IF
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

AcceptText()

Gs_gubun = is_saupcd
IF GetColumnName() = "empno" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"empno",Gs_code)
	SetItem(this.GetRow(),"empname",Gs_codeName)
	
END IF


IF GetColumnName() = "deptcode" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"deptcode")
	
	open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),"deptcode",Gs_code)
	SetItem(this.GetRow(),"deptname",Gs_codeName)
	
END IF
end event

event itemerror;return 1
end event

