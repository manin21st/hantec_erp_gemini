$PBExportHeader$w_pig5020.srw
$PBExportComments$교육계획 확인(총무)
forward
global type w_pig5020 from w_inherite_standard
end type
type gb_5 from groupbox within w_pig5020
end type
type dw_cond from datawindow within w_pig5020
end type
type p_1 from uo_picture within w_pig5020
end type
type dw_detail from u_d_popup_sort within w_pig5020
end type
type rr_1 from roundrectangle within w_pig5020
end type
end forward

global type w_pig5020 from w_inherite_standard
string title = "교육계획 확인"
gb_5 gb_5
dw_cond dw_cond
p_1 p_1
dw_detail dw_detail
rr_1 rr_1
end type
global w_pig5020 w_pig5020

on w_pig5020.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.dw_cond=create dw_cond
this.p_1=create p_1
this.dw_detail=create dw_detail
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.dw_cond
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.rr_1
end on

on w_pig5020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.dw_cond)
destroy(this.p_1)
destroy(this.dw_detail)
destroy(this.rr_1)
end on

event open;call super::open;dw_cond.setTransObject(sqlca)
dw_cond.reset()
dw_cond.insertrow(0)

dw_cond.setItem(1, 'startdate', Left(F_Today(),6)+'01')
dw_cond.setItem(1, 'enddate',   F_Today())

dw_cond.setcolumn('startdate')
dw_cond.setfocus()

dw_detail.settransobject(sqlca)
dw_detail.reset()


w_mdi_frame.sle_msg.text = '수정하려면 자료를 더블클릭하십시요!'

end event

type p_mod from w_inherite_standard`p_mod within w_pig5020
integer x = 4069
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;Integer  k
String   sEduyear,sEmpNo,sConFirm,sStatus,sReBackGbn,sEgubn
Long     lEduSeq

w_mdi_frame.sle_msg.text = ""

if dw_detail.AcceptText() = -1 then return 
if dw_detail.rowcount() <= 0 then 	return 

if f_msg_update() = -1 then return

For k = 1 To dw_detail.RowCount()
	sConFirm   = dw_detail.GetItemString(k,"confirm")
	sStatus    = dw_detail.GetItemString(k,"prostate")
	sRebackGbn = dw_detail.GetItemString(k,"rebackgbn")
	sEgubn     = dw_detail.GetItemString(k,"egubn")
	
	sEduyear   = dw_detail.GetItemString(k,"p5_educations_s_eduyear")
	lEduSeq    = dw_detail.GetItemNumber(k,"p5_educations_s_empseq")
	sEmpno     = dw_detail.GetItemString(k,"p5_educations_s_empno")
	
	if sEgubn = '1' then						/*사내이면*/
		update p5_educations_s
			set confirm   = :sConFirm,
				 prostate  = :sStatus,
				 rebackgbn = :sRebackGbn
			where companycode = :Gs_Company and empno = :sEmpNo and eduyear = :sEduyear and empseq = :lEduSeq;
	else
		update p5_educations_s
			set confirm   = :sConFirm,
				 prostate  = :sStatus,
				 rebackgbn = :sRebackGbn
			where companycode = :Gs_Company and eduyear = :sEduyear and empseq = :lEduSeq and eduempno = :sEmpNo ;
	end if
	
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','자료 저장을 실패하였습니다.')
		Rollback;
		Return
	end if
Next

Commit;

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다.'
end event

type p_del from w_inherite_standard`p_del within w_pig5020
boolean visible = false
integer x = 1769
integer y = 2928
integer taborder = 0
end type

type p_inq from w_inherite_standard`p_inq within w_pig5020
integer x = 3895
end type

event p_inq::clicked;call super::clicked;String sStart, sEnd, sDept, sEkind, sEmpNo,sUpDept

if dw_cond.AcceptText() = -1 then return
sStart  = Trim(dw_cond.GetItemString(1, 'startdate'))
sEnd    = Trim(dw_cond.GetItemString(1, 'enddate'))
sDept   = dw_cond.GetItemString(1, 'deptcode')
sEkind  = dw_cond.GetItemString(1, 'ekind')
sEmpNo  = dw_cond.GetItemString(1, 'empno')

if isnull(sStart) or sStart = "" then
	MessageBox("확인", "교육일자를 입력하십시요.")
	dw_cond.setcolumn('startdate')		
   dw_cond.setfocus()	
   return
end if	

if isnull(sEnd) or sEnd = "" then
	MessageBox("확인", "교육일자를 입력하십시요.")
	dw_cond.setcolumn('enddate')		
   dw_cond.setfocus()	
   return
end if
if sDept = '' or IsNull(sDept) then 
	sUpDept = '%'
else
	/*상위부서*/
	select updept	into :sUpDept	from p0_dept where companycode = :Gs_Company and deptocde = :sDept;
	if sqlca.sqlcode = 0 then
		if IsNull(sUpDept) or sUpDept = '' then sUpDept = sDept
	else
		sUpDept = sDept	
	end if
end if

if sEkind = '' or IsNull(sEkind) then sEkind = '%'
if sEmpno = '' or IsNull(sEmpNo) then sEmpNo = '%'

dw_detail.SetRedraw(false)
if dw_detail.retrieve(Gs_Company, sStart, sEnd, sUpDept, sEkind, sEmpNo) <= 0 then
	MessageBox("확 인", "조회한 자료가 없습니다.")
   dw_cond.setcolumn('empno')			
   dw_cond.setfocus()	
   dw_detail.SetRedraw(true)	
	return 
end if
dw_detail.SetRedraw(true)

w_mdi_frame.sle_msg.text = '수정하려면 자료를 더블클릭하십시요!'

end event

type p_print from w_inherite_standard`p_print within w_pig5020
boolean visible = false
integer x = 727
integer y = 2928
integer taborder = 0
end type

type p_can from w_inherite_standard`p_can within w_pig5020
integer x = 4242
integer taborder = 40
end type

event p_can::clicked;call super::clicked;

dw_cond.setfocus()
dw_cond.setcolumn('startdate')

dw_detail.Reset()

ib_any_typing = false

w_mdi_frame.sle_msg.text = '수정하려면 자료를 더블클릭하십시요!'
end event

type p_exit from w_inherite_standard`p_exit within w_pig5020
integer x = 4416
integer taborder = 60
end type

type p_ins from w_inherite_standard`p_ins within w_pig5020
boolean visible = false
integer x = 1074
integer y = 2928
integer taborder = 0
end type

type p_search from w_inherite_standard`p_search within w_pig5020
boolean visible = false
integer x = 553
integer y = 2928
integer taborder = 0
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig5020
boolean visible = false
integer x = 1248
integer y = 2928
integer taborder = 0
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig5020
boolean visible = false
integer x = 1422
integer y = 2928
integer taborder = 0
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig5020
boolean visible = false
integer x = 174
integer y = 3016
integer taborder = 0
end type

type st_window from w_inherite_standard`st_window within w_pig5020
boolean visible = false
integer x = 2203
integer y = 3548
integer taborder = 0
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig5020
boolean visible = false
integer x = 3200
integer y = 2712
integer taborder = 50
end type

type cb_update from w_inherite_standard`cb_update within w_pig5020
boolean visible = false
integer x = 2496
integer y = 2712
integer taborder = 0
end type

event cb_update::clicked;call super::clicked;long i

sle_msg.text = ""

if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then
	return 
end if	

if f_msg_update() = -1 then return


dw_detail.SetRedraw(false)			

if dw_detail.update() = 1 then
	commit ;
	ib_any_typing= FALSE	
   sle_msg.text = "자료가 저장되었습니다!!"	
   dw_detail.SetRedraw(true)			
	dw_detail.setfocus()
else
	rollback ;
	MessageBox("저장실패", "자료 저장중 에러 발생")
   sle_msg.text = "자료를 저장하지 못하였습니다!!"	
   dw_detail.SetRedraw(true)		
	return 
end if	

end event

type cb_insert from w_inherite_standard`cb_insert within w_pig5020
boolean visible = false
integer x = 457
integer y = 3376
integer taborder = 0
boolean enabled = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig5020
boolean visible = false
integer x = 2464
integer y = 3376
integer taborder = 0
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig5020
boolean visible = false
integer x = 2126
integer y = 2712
integer taborder = 0
end type

type st_1 from w_inherite_standard`st_1 within w_pig5020
boolean visible = false
integer x = 37
integer y = 3548
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig5020
boolean visible = false
integer x = 2830
integer y = 2712
integer taborder = 0
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig5020
boolean visible = false
integer x = 2848
integer y = 3548
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig5020
boolean visible = false
integer x = 366
integer y = 3548
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig5020
boolean visible = false
integer x = 2085
integer y = 3316
integer width = 1522
integer height = 180
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig5020
boolean visible = false
integer x = 55
integer y = 3316
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig5020
boolean visible = false
integer x = 18
integer y = 3496
end type

type gb_5 from groupbox within w_pig5020
boolean visible = false
integer x = 2043
integer y = 2880
integer width = 1522
integer height = 200
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type dw_cond from datawindow within w_pig5020
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 16
integer width = 3561
integer height = 156
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pig50201"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this),256,9,0)

Return 1

end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String   sStart,sEnd,sEmpNo,sEmpNm,sEkind,sEduGbn,sDept,sDeptNm,sNull

if this.GetColumnName() ="startdate"THEN
	sStart = Trim(this.GetText())
	if sStart = '' or IsNull(sStart) then Return
	
	if F_DateChk(sStart) = -1 then
		MessageBox("확 인", "유효한 날짜가 아닙니다.")
		this.SetItem(this.GetRow(),"startdate",   sNull)
		Return 1
	end if
end if

if this.GetColumnName() ="enddate"THEN
	sEnd = Trim(this.GetText())
	if sEnd = '' or IsNull(sEnd) then Return
	
	if F_DateChk(sEnd) = -1 then
		MessageBox("확 인", "유효한 날짜가 아닙니다.")
		this.SetItem(this.GetRow(),"enddate",   sNull)
		Return 1
	end if
end if

IF this.GetColumnName() ="deptcode"THEN
	sDept = Trim(this.GetText())
	if sDept = "" or isnull(sDept) then return
	
	select deptname  into :sDeptNm  from p0_dept 
		where companycode = :gs_company and	deptcode    = :sDept ;
	if sqlca.sqlcode <> 0 then
		MessageBox("확 인", "등록된 부서코드가 아닙니다.")
	   this.SetItem(this.GetRow(), 'deptcode',   sNull)
		this.SetItem(this.GetRow(), 'deptname', sNull)
		return 1
	end if
	this.SetItem(this.GetRow(), "deptname",   sDeptnm)
END IF

if this.GetColumnName() = 'ekind' then
	sEkind = this.GetText()
	if sEkind = '' or IsNull(sEkind) then Return
	
	select nvl(educationgbn,'1')	into :sEduGbn
		from p0_education where educationcode = :sEkind;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','등록되지 않은 교육종류입니다.')
		this.SetItem(this.GetRow(),"ekind",sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"egubn",sEduGbn)
end if

if this.GetColumnName() = 'empno'  then
	sEmpno = this.GetText()
	if sEmpno = '' or IsNull(sEmpNo) then
		this.SetItem(this.GetRow(),"empname",   sNull)
		Return
	end if
	
	select a.empname	into :sEmpNm from p1_master a	where a.empno = :sEmpNo;
	if sqlca.sqlcode <> 0 then
		MessageBox('확 인','등록되어 있는 사번이 아닙니다.확인하십시요.')
		this.SetItem(this.GetRow(),"empno", sNull)
		this.SetItem(this.GetRow(),"empname",    sNull)
		Return 1
	end if
	this.SetItem(this.GetRow(),"empname",   sEmpNm)
end if


end event

event itemerror;return 1

end event

event rbuttondown;if this.GetColumnName() = 'empno'  then
	SetNull(Gs_Code);		SetNull(Gs_CodeName);
	
	Open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",  Gs_Code)
   this.TriggerEvent(ItemChanged!)	
end if

IF this.GetColumnName() ="deptcode" THEN
	SetNull(Gs_Code);		SetNull(Gs_CodeName);
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"deptcode",gs_code)
   this.TriggerEvent(ItemChanged!)	
END IF

end event

type p_1 from uo_picture within w_pig5020
integer x = 3593
integer y = 24
integer width = 306
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\총무일괄확인_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\총무일괄확인_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\총무일괄확인_dn.gif"
end event

event clicked;call super::clicked;String sCheck 
Long ll_Row,I

w_mdi_frame.sle_msg.text = ''

ll_Row  = dw_detail.RowCount()
IF ll_Row = 0 THEN RETURN

FOR I = 1 TO ll_Row
	dw_detail.SetITem(I,"confirm","Y")
NEXT	

//w_mdi_frame.sle_msg.text = "총무일괄확인이 되었습니다.!!"
end event

type dw_detail from u_d_popup_sort within w_pig5020
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 50
integer y = 192
integer width = 4521
integer height = 1976
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pig50202"
boolean vscrollbar = true
boolean border = false
end type

event ue_key;choose case key
	case keypageup!
		this.scrollpriorpage()
	case keypagedown!
		this.scrollnextpage()
	case keyhome!
		this.scrolltorow(1)
	case keyend!
		this.scrolltorow(this.rowcount())
end choose

end event

event ue_enterkey;send(handle(this), 256, 9, 0)

return 1
end event

event doubleclicked;call super::doubleclicked;//
//if row <=0 then Return
//
//OpenWithParm(w_pig2010, 'S'+this.GetItemString(row,"p5_educations_s_eduyear")+&
//									 String(this.GetItemNumber(row,"p5_educations_s_empseq"),'0000')+&
//									 this.GetItemString(row,"p5_educations_s_eduempno"))
//									 
//if Message.StringParm = '1' then
//	p_inq.TriggerEvent(Clicked!)
//end if
end event

event editchanged;call super::editchanged;ib_any_typing = true
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;
if dwo.name = 'confirm' then
	if data = 'N' and this.GetItemString(this.GetRow(),"isu") = 'Y' then
		MessageBox('확 인',"완료되었으므로 취소할 수 없습니다!")
		this.SetItem(this.GetRow(),"confirm",'Y')
		Return 1
	end if	
end if

if dwo.name = 'prostate' then
	if data = 'R' or data = 'C' then
		this.SetItem(row,"confirm", 'Y')	
	end if	
end if
end event

type rr_1 from roundrectangle within w_pig5020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 184
integer width = 4549
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

