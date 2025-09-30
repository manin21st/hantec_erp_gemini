$PBExportHeader$w_pig5040.srw
$PBExportComments$교육훈련 완료 처리
forward
global type w_pig5040 from w_inherite_standard
end type
type dw_date from datawindow within w_pig5040
end type
type rr_1 from roundrectangle within w_pig5040
end type
type rr_2 from roundrectangle within w_pig5040
end type
type dw_detail from datawindow within w_pig5040
end type
end forward

global type w_pig5040 from w_inherite_standard
string title = "교육완료처리"
dw_date dw_date
rr_1 rr_1
rr_2 rr_2
dw_detail dw_detail
end type
global w_pig5040 w_pig5040

on w_pig5040.create
int iCurrent
call super::create
this.dw_date=create dw_date
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_date
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.dw_detail
end on

on w_pig5040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_date)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_detail)
end on

event open;call super::open;dw_date.setTransObject(sqlca)
dw_detail.settransobject(sqlca)

dw_date.reset()
dw_detail.reset()

dw_date.insertrow(0)

dw_date.setItem(1, 'startdate', string(today(), 'YYYYMM') + '01')
dw_date.setItem(1, 'enddate', string(today(), 'YYYYMMDD'))

dw_date.setfocus()
dw_date.setcolumn('startdate')

w_mdi_frame.sle_msg.text = '수정하려면 자료를 더블클릭하십시요!'

end event

type p_mod from w_inherite_standard`p_mod within w_pig5040
integer x = 4069
end type

event p_mod::clicked;call super::clicked;Integer  k
String   sEduyear,sEmpNo,sConFirm,sStatus,sReBackGbn,sEgubn
Long     lEduSeq

w_mdi_frame.sle_msg.text = ""

if dw_detail.AcceptText() = -1 then return 
if dw_detail.rowcount() <= 0 then 	return 

if f_msg_update() = -1 then return

For k = 1 To dw_detail.RowCount()
	sConFirm   = dw_detail.GetItemString(k,"isu")
	sEgubn     = dw_detail.GetItemString(k,"egubn")
	
	sEduyear   = dw_detail.GetItemString(k,"eduyear")
	lEduSeq    = dw_detail.GetItemNumber(k,"empseq")
	sEmpno     = dw_detail.GetItemString(k,"eduempno")
	
	if sEgubn = '1' then						/*사내이면*/
		update p5_educations_s
			set isu   = :sConFirm
			where companycode = :Gs_Company and empno = :sEmpNo and eduyear = :sEduyear and empseq = :lEduSeq;
	else
		update p5_educations_s
			set isu   = :sConFirm
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

type p_del from w_inherite_standard`p_del within w_pig5040
boolean visible = false
integer x = 4334
integer y = 3868
end type

type p_inq from w_inherite_standard`p_inq within w_pig5040
integer x = 3895
end type

event p_inq::clicked;call super::clicked;string ls_code, ls_sdate, ls_edate, ls_gbn, ls_empno

if dw_date.AcceptText() = -1 then return

ls_code = gs_company
ls_sdate = dw_date.GetItemString(1, 'startdate')
ls_edate = dw_date.GetItemString(1, 'enddate')
ls_empno = dw_date.GetItemString(1, 'empno')
ls_gbn  = dw_date.GetItemString(1, 'ekind')

if isnull(ls_sdate) or trim(ls_sdate) = "" then
	MessageBox("확인", "시작일자는 필수입력항목입니다.")
	dw_date.setfocus()
   dw_date.setcolumn('startdate')
	return
else
   If f_datechk(ls_sdate) = -1 Then
	   MessageBox("확 인", "유효한 일자가 아닙니다.")
   	dw_date.setfocus()
      dw_date.setcolumn('startdate')
      return
   end if
end if	

if isnull(ls_edate) or trim(ls_edate) = "" then 
	MessageBox("확인", "종료일자는 필수입력항목입니다.")
	dw_date.setfocus()
   dw_date.setcolumn('endtdate')
	return
else
   If f_datechk(ls_edate) = -1 Then
	   MessageBox("확 인", "유효한 일자가 아닙니다.")
   	dw_date.setfocus()
      dw_date.setcolumn('enddate')
   	return
  end if
end if

if ls_sdate > ls_edate then
   MessageBox("확 인", "시작일자가 종료일자보다 클 수는 없습니다.")
  	dw_date.setfocus()
   dw_date.setcolumn('startdate')
   return
 end if 
  
if isnull(ls_empno) or trim(ls_empno) = '' then
	ls_empno = ''
end if


w_mdi_frame.sle_msg.text = '수정하려면 자료를 더블클릭하십시요!'
dw_detail.SetRedraw(false)
if dw_detail.retrieve(ls_code, ls_sdate, ls_edate, ls_gbn, ls_empno + '%') <= 0 then
	MessageBox("확 인", "조건에 맞는 자료가 존재하지 않습니다.")
	dw_detail.reset()
	dw_date.setcolumn('empno')
	dw_date.setfocus()	
   dw_detail.SetRedraw(true)		
   return
end if

ib_any_typing = false

dw_detail.SetRedraw(true)

dw_detail.setfocus()

end event

type p_print from w_inherite_standard`p_print within w_pig5040
boolean visible = false
integer x = 3291
integer y = 3868
end type

type p_can from w_inherite_standard`p_can within w_pig5040
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_date.setredraw(false)
dw_detail.setredraw(false)
dw_date.reset()
dw_detail.reset()

dw_date.insertrow(0)

dw_date.setItem(1, 'startdate', string(today(), 'YYYYMM') + '01' + '01')
dw_date.setItem(1, 'enddate', string(today(), 'YYYYMMDD'))

dw_date.setfocus()
dw_date.setcolumn('startdate')

dw_date.setredraw(true)
dw_detail.setredraw(true)


w_mdi_frame.sle_msg.text = '수정하려면 자료를 더블클릭하십시요!'
ib_any_typing = false
end event

type p_exit from w_inherite_standard`p_exit within w_pig5040
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pig5040
boolean visible = false
integer x = 3931
integer y = 3652
end type

type p_search from w_inherite_standard`p_search within w_pig5040
boolean visible = false
integer x = 3118
integer y = 3868
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig5040
boolean visible = false
integer x = 3813
integer y = 3868
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig5040
boolean visible = false
integer x = 3986
integer y = 3868
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig5040
boolean visible = false
integer x = 1591
integer y = 3376
end type

type st_window from w_inherite_standard`st_window within w_pig5040
boolean visible = false
integer y = 3760
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig5040
boolean visible = false
integer y = 3588
end type

type cb_update from w_inherite_standard`cb_update within w_pig5040
boolean visible = false
integer x = 2478
integer y = 3588
integer taborder = 40
end type

event cb_update::clicked;call super::clicked;if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then
	return 
end if	

if f_msg_update() = -1 then return
	
if dw_detail.update() = 1 then
	commit using sqlca;	
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= false
   dw_detail.setfocus()	
else
	rollback using sqlca;
	MessageBox("저장실패", "자료 저장중 에러 발생")
	sle_msg.text = "자료가 저장되지 않았습니다.!!"	
	return 
end if	

end event

type cb_insert from w_inherite_standard`cb_insert within w_pig5040
boolean visible = false
integer y = 3588
integer taborder = 70
boolean enabled = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig5040
boolean visible = false
integer y = 3588
integer taborder = 80
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig5040
boolean visible = false
integer x = 2107
integer y = 3588
integer taborder = 30
end type

type st_1 from w_inherite_standard`st_1 within w_pig5040
boolean visible = false
integer x = 1518
integer y = 3868
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig5040
boolean visible = false
integer y = 3588
integer taborder = 50
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pig5040
boolean visible = false
integer y = 3760
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig5040
boolean visible = false
integer y = 3760
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig5040
boolean visible = false
integer y = 3528
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig5040
boolean visible = false
integer y = 3528
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig5040
boolean visible = false
integer y = 3708
end type

type dw_date from datawindow within w_pig5040
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 73
integer y = 48
integer width = 3278
integer height = 144
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig50401"
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

event itemchanged;string ls_startdate, ls_enddate, ls_empno, &
       get_empno, snull
		 
SetNull(snull)

IF this.GetColumnName() ="startdate"THEN
	IF IsNull(data) OR data ="" THEN Return 1
		If f_datechk(data) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			Return 1
		end if
	ls_startdate = data
	ls_enddate = this.GetItemString(1, 'enddate')
		
	if  ls_startdate > ls_enddate then
       MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
			                 "클 수는 없습니다.!!", stopsign!)
	 	return 1
	end if
END IF

IF this.GetColumnName() ="enddate"THEN
   IF IsNull(data) OR data ="" THEN Return 1
	If f_datechk(data) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if
		
	ls_startdate = this.GetItemstring(1, 'startdate')
	ls_enddate = data		
		
	if  ls_startdate > ls_enddate then
       MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
			                 "클 수는 없습니다.!!", stopsign!)
	 	return 1
	end if

end if

if this.GetcolumnName() = 'empno' then 
	ls_empno = this.GetText()
	
	if isnull(ls_empno) or trim(ls_empno) = '' then return 
	
 	IF IsNull(wf_exiting_data(this.GetColumnName(),ls_empno,"1")) THEN	
  	   MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
     	Return 1
   end if
	
	SELECT "P1_MASTER"."EMPNO" 
		 INTO :get_empno 
		 FROM "P1_MASTER"  
		WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
				( "P1_MASTER"."EMPNO" = :ls_empno )   ;	
	if sqlca.sqlcode = 0 then 
		this.SetItem(1, 'empno', get_empno)	
    end if	
	if sqlca.sqlcode <> 0 then 
		this.SetItem(1, 'empno', snull)	
		return 1
    end if	
	cb_retrieve.TriggerEvent(clicked!)	 
end if


end event

event itemerror;return 1
end event

event rbuttondown;string ls_eduyear

SetNull(Gs_Code)

if This.GetColumnName() = 'empno'   then             // 사원 조회선택
	
	open(w_employee_popup)
	 
	If IsNull(gs_code) Then Return 1
	
	this.SetItem(1,'empno', gs_code)
	
	this.TriggerEvent(itemchanged!)
end if 
		  
		  
end event

type rr_1 from roundrectangle within w_pig5040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 20
integer width = 3470
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pig5040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 236
integer width = 4544
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_pig5040
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 55
integer y = 244
integer width = 4521
integer height = 1928
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pig50402"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
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

event rowfocuschanged;//dw_detail.SetRowFocusIndicator(Hand!)
end event

event editchanged;ib_any_typing =True
end event

event itemerror;return 1
end event

event itemchanged;string ls_document, ls_isu, ls_pheungga, snull

SetNull(snull)

//if dwo.name = 'isu' then 
//	ls_isu = data
////	ls_pheungga = this.GetItemString(row,'pheungga')
////	ls_document = this.GetItemString(row, 'document')
//	
//	if ls_isu = "Y" then
//
//	end if	
//end if
//
//if dwo.name = 'pheungga' then 
//	ls_document = this.GetItemString(row, 'document')
//   ls_isu = this.GetItemString(row, 'isu')
////	if ls_document <> 'Y' then
////		MessageBox("확 인", "보고서가 작성되어 있지 않으면," + "~n"+ "~n"+ &
////								  "평가항목을 등록할 수 없습니다.")
////		return 2		// 내용을 변경하지 않고, focus만 이동
////	end if
////   if ls_isu = 'Y' then 
////		MessageBox("확 인", "이수처리가 되어 있으면," + "~n"+ "~n"+ &
////								  "평가항목을 변경할 수 없습니다.")
////		return 2		// 내용을 변경하지 않고, focus만 이동
////	end if
//end if	
//
end event

event doubleclicked;if row <=0 then Return

OpenWithParm(w_pig2010, 'S'+this.GetItemString(row,"eduyear")+&
									 String(this.GetItemNumber(row,"empseq"),'0000')+&
									 this.GetItemString(row,"eduempno"))
									 
if Message.StringParm = '1' then
	p_inq.TriggerEvent(Clicked!)
end if
end event

