$PBExportHeader$w_pig2005.srw
$PBExportComments$교육훈련계획(총무확인)
forward
global type w_pig2005 from w_inherite_standard
end type
type gb_6 from groupbox within w_pig2005
end type
type gb_5 from groupbox within w_pig2005
end type
type gb_3 from groupbox within w_pig2005
end type
type rb_1 from radiobutton within w_pig2005
end type
type rb_2 from radiobutton within w_pig2005
end type
type dw_detail from datawindow within w_pig2005
end type
type dw_date from datawindow within w_pig2005
end type
type cb_1 from commandbutton within w_pig2005
end type
type p_1 from uo_picture within w_pig2005
end type
type rr_1 from roundrectangle within w_pig2005
end type
end forward

global type w_pig2005 from w_inherite_standard
string title = "교육훈련계획(총무확인)"
gb_6 gb_6
gb_5 gb_5
gb_3 gb_3
rb_1 rb_1
rb_2 rb_2
dw_detail dw_detail
dw_date dw_date
cb_1 cb_1
p_1 p_1
rr_1 rr_1
end type
global w_pig2005 w_pig2005

on w_pig2005.create
int iCurrent
call super::create
this.gb_6=create gb_6
this.gb_5=create gb_5
this.gb_3=create gb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_detail=create dw_detail
this.dw_date=create dw_date
this.cb_1=create cb_1
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_6
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_detail
this.Control[iCurrent+7]=this.dw_date
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.rr_1
end on

on w_pig2005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.gb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_detail)
destroy(this.dw_date)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_date.setTransObject(sqlca)
dw_detail.settransobject(sqlca)

dw_date.reset()
dw_detail.reset()

dw_date.insertrow(0)

dw_date.setItem(1, 'startdate', string(today(), 'YYYYMM') + '01' + '01')
dw_date.setItem(1, 'enddate', string(today(), 'YYYYMMDD'))

dw_date.setfocus()
dw_date.setcolumn('startdate')

end event

type p_mod from w_inherite_standard`p_mod within w_pig2005
integer x = 4069
end type

event p_mod::clicked;call super::clicked;long i

w_mdi_frame.sle_msg.text = ""

if dw_detail.AcceptText() = -1 then return 

if dw_detail.rowcount() <= 0 then
	return 
end if	

if f_msg_update() = -1 then return


dw_detail.SetRedraw(false)			

if dw_detail.update() = 1 then
	commit ;
	ib_any_typing= FALSE	
   w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"	
   dw_detail.SetRedraw(true)			
	dw_detail.setfocus()
else
	rollback ;
	MessageBox("저장실패", "자료 저장중 에러 발생")
   w_mdi_frame.sle_msg.text = "자료를 저장하지 못하였습니다!!"	
   dw_detail.SetRedraw(true)		
	return 
end if	

end event

type p_del from w_inherite_standard`p_del within w_pig2005
integer x = 1842
integer y = 3972
end type

type p_inq from w_inherite_standard`p_inq within w_pig2005
integer x = 3895
end type

event p_inq::clicked;call super::clicked;string ls_code, ls_sdate, ls_edate, ls_gbn, ls_empno

if dw_date.AcceptText() = -1 then return

ls_code = gs_company
ls_sdate = dw_date.GetItemString(1, 'startdate')
ls_edate = dw_date.GetItemString(1, 'enddate')
ls_empno = dw_date.GetItemString(1, 'empno')


if isnull(ls_sdate) or ls_sdate = "" then
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

if isnull(ls_edate) or ls_edate = "" then 
	MessageBox("확인", "종료일자는 필수입력항목입니다.")
   dw_date.setfocus()	
   dw_date.setcolumn('enddate')		
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

if rb_1.checked = true then
	ls_gbn = "1"
elseif rb_2.checked = true then
	ls_gbn = "2"	
end if

dw_detail.SetRedraw(false)

if dw_detail.retrieve(ls_code, ls_sdate, ls_edate, ls_gbn, ls_empno + '%') < 1 then
	MessageBox("확 인", "조건에 맞는 자료가 존재하지 않습니다.")
	dw_detail.reset()
   dw_date.setcolumn('empno')			
   dw_date.setfocus()	
   dw_detail.SetRedraw(true)	
	return 
end if

dw_detail.SetRedraw(true)

ib_any_typing = false

dw_detail.setfocus()

w_mdi_frame.sle_msg.text = "자료가 조회되었습니다.!!"
end event

type p_print from w_inherite_standard`p_print within w_pig2005
integer x = 800
integer y = 3972
end type

type p_can from w_inherite_standard`p_can within w_pig2005
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

rb_1.checked = true

ib_any_typing = false
end event

type p_exit from w_inherite_standard`p_exit within w_pig2005
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pig2005
integer x = 1147
integer y = 3972
end type

type p_search from w_inherite_standard`p_search within w_pig2005
integer x = 626
integer y = 3972
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig2005
integer x = 1321
integer y = 3972
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig2005
integer x = 1495
integer y = 3972
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig2005
integer x = 183
integer y = 3844
end type

type st_window from w_inherite_standard`st_window within w_pig2005
integer x = 2277
integer y = 4592
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig2005
integer x = 3273
integer y = 3756
integer taborder = 70
end type

type cb_update from w_inherite_standard`cb_update within w_pig2005
integer x = 2569
integer y = 3756
integer taborder = 50
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

type cb_insert from w_inherite_standard`cb_insert within w_pig2005
boolean visible = false
integer x = 530
integer y = 4420
integer taborder = 80
boolean enabled = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig2005
boolean visible = false
integer x = 2537
integer y = 4420
integer taborder = 100
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig2005
integer x = 2199
integer y = 3756
integer taborder = 40
end type

event cb_retrieve::clicked;call super::clicked;string ls_code, ls_sdate, ls_edate, ls_gbn, ls_empno

if dw_date.AcceptText() = -1 then return

ls_code = gs_company
ls_sdate = dw_date.GetItemString(1, 'startdate')
ls_edate = dw_date.GetItemString(1, 'enddate')
ls_empno = dw_date.GetItemString(1, 'empno')


if isnull(ls_sdate) or ls_sdate = "" then
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

if isnull(ls_edate) or ls_edate = "" then 
	MessageBox("확인", "종료일자는 필수입력항목입니다.")
   dw_date.setfocus()	
   dw_date.setcolumn('enddate')		
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

if rb_1.checked = true then
	ls_gbn = "1"
elseif rb_2.checked = true then
	ls_gbn = "2"	
end if

dw_detail.SetRedraw(false)

if dw_detail.retrieve(ls_code, ls_sdate, ls_edate, ls_gbn, ls_empno + '%') < 1 then
	MessageBox("확 인", "조건에 맞는 자료가 존재하지 않습니다.")
	dw_detail.reset()
   dw_date.setcolumn('empno')			
   dw_date.setfocus()	
   dw_detail.SetRedraw(true)	
	return 
end if

dw_detail.SetRedraw(true)

ib_any_typing = false

dw_detail.setfocus()

sle_msg.text = "자료가 조회되었습니다.!!"
end event

type st_1 from w_inherite_standard`st_1 within w_pig2005
integer x = 110
integer y = 4592
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig2005
integer x = 2903
integer y = 3756
integer taborder = 60
end type

event cb_cancel::clicked;call super::clicked;dw_date.setredraw(false)
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

rb_1.checked = true

ib_any_typing = false
end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig2005
integer x = 2921
integer y = 4592
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig2005
integer x = 439
integer y = 4592
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig2005
integer x = 2158
integer y = 4360
integer width = 1522
integer height = 180
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig2005
boolean visible = false
integer x = 128
integer y = 4360
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig2005
integer x = 91
integer y = 4540
end type

type gb_6 from groupbox within w_pig2005
integer x = 201
integer y = 3708
integer width = 690
integer height = 180
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_5 from groupbox within w_pig2005
integer x = 2117
integer y = 3924
integer width = 1522
integer height = 200
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_pig2005
integer x = 3067
integer y = 84
integer width = 544
integer height = 152
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "교육구분"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pig2005
integer x = 3127
integer y = 136
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "사내"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_pig2005
integer x = 3346
integer y = 132
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "사외"
borderstyle borderstyle = stylelowered!
end type

type dw_detail from datawindow within w_pig2005
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 709
integer y = 304
integer width = 3131
integer height = 1968
boolean bringtotop = true
string dataobject = "d_pig2005"
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

event rowfocuschanged;dw_detail.SetRowFocusIndicator(Hand!)


end event

event itemerror;return 1
end event

event itemchanged;string ls_totchk, ls_company, ls_empno, ls_eduyear, get_eduyear, &
       ls_prostate
long ll_empseq, get_empseq, get_seq

if dwo.name = 'totchk' then 
	
   ls_totchk = data	
	ls_prostate = this.GetItemString(row, 'prostate')
	
	if ls_prostate <> "P" then  // 진행 상태가 아니면, 저장할 수 없다.
   									 // P : 진행, R : 보류, C : 취소
		MessageBox("확 인", "진행상태가 ~"진행~"이 아니면" + "~n"+ "~n"+ &
								  "자료를 변경할 수 없습니다.", stopsign!)
		return 1		
	end if

	
	ls_company = gs_company
	ls_empno = this.GetItemString(row, 'empno')
	ls_eduyear = this.GetItemString(row, 'eduyear')
	ll_empseq = this.GetItemNumber(row, 'empseq')
	
	SELECT "P5_EDUCATIONS_S"."EDUYEAR", 
			"P5_EDUCATIONS_S"."EMPSEQ",   
      	COUNT(*)
	INTO :get_eduyear, :get_empseq, :get_seq    
	FROM "P5_EDUCATIONS_S"   
	WHERE "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company  AND 
			"P5_EDUCATIONS_S"."EMPNO"       = :ls_empno AND   
			"P5_EDUCATIONS_S"."EDUEMPNO"    = :ls_empno AND   
			"P5_EDUCATIONS_S"."PEDUYEAR"     = :ls_eduyear AND   
			"P5_EDUCATIONS_S"."PEMPSEQ"     = :ll_empseq AND  
			"P5_EDUCATIONS_S"."ISU" = 'Y'   
  	GROUP BY "P5_EDUCATIONS_S"."EDUYEAR",  
	   		"P5_EDUCATIONS_S"."EMPSEQ"   ;   
   if sqlca.sqlcode = 0 and get_seq > 0 then 
		 MessageBox("확 인", "실적순번 : " + string(get_empseq) + & 
		                     " 로 이미 이수처리가 되어 있는 " + "~n" + "~n" + & 
								  "계획 자료입니다.!!" + "~n" + "~n" + &
								  "자료를 변경할 수 없습니다.!!")
      return 1  // 변경 불가
	elseif sqlca.sqlcode < 0 then 
   		MessageBox("에 러", string(sqlca.sqlcode)+ " : "+ sqlca.SQLErrText)
    		return 1 // 변경 불가
   end if
end if

end event

event editchanged;ib_any_typing = true
end event

type dw_date from datawindow within w_pig2005
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 713
integer y = 68
integer width = 2318
integer height = 180
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pig2005_1"
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

event itemchanged;string ls_startdate, ls_enddate, snull, &
       ls_empno, get_empno

SetNUll(snull)

IF this.GetcolumnName() ="startdate"THEN
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

IF this.GetcolumnName() ="enddate"THEN
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
	p_inq.TriggerEvent(clicked!)
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

type cb_1 from commandbutton within w_pig2005
integer x = 229
integer y = 3756
integer width = 635
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "총무일괄확인(&P)"
end type

event clicked;String sCheck 
Long ll_Row,I

sle_msg.text = ''

ll_Row  = dw_detail.RowCount()
IF ll_Row = 0 THEN RETURN

FOR I = 1 TO ll_Row
	dw_detail.SetITem(I,"totchk","Y")
NEXT	

sle_msg.text = "총무일괄확인이 되었습니다.!!"
end event

type p_1 from uo_picture within w_pig2005
integer x = 3685
integer y = 24
integer width = 210
integer height = 148
boolean bringtotop = true
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
	dw_detail.SetITem(I,"totchk","Y")
NEXT	

w_mdi_frame.sle_msg.text = "총무일괄확인이 되었습니다.!!"
end event

type rr_1 from roundrectangle within w_pig2005
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 690
integer y = 288
integer width = 3163
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

