$PBExportHeader$w_pig2020_1.srw
$PBExportComments$교육신청서 (사내/사외) - 출력
forward
global type w_pig2020_1 from w_standard_print
end type
type gb_4 from groupbox within w_pig2020_1
end type
type rb_1 from radiobutton within w_pig2020_1
end type
type rb_2 from radiobutton within w_pig2020_1
end type
type gb_1 from groupbox within w_pig2020_1
end type
type rr_2 from roundrectangle within w_pig2020_1
end type
type rr_1 from roundrectangle within w_pig2020_1
end type
end forward

global type w_pig2020_1 from w_standard_print
string title = "교육 신청서"
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_2 rr_2
rr_1 rr_1
end type
global w_pig2020_1 w_pig2020_1

type variables
//구조체
str_edu istr_edu

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();long ll_row, ll_empseq
string ls_company, ls_empno, ls_eduyear


if dw_ip.AcceptText() = -1 then return -1
ll_row = dw_ip.GetRow()

If ll_row <= 0 Then Return -1

ls_company = gs_company

ls_eduyear = trim(dw_ip.GetItemString(ll_row, 'eduyear'))
ls_empno = Trim(dw_ip.GetItemString(ll_row,'empno'))
ll_empseq = dw_ip.GetItemNumber(ll_row, 'empseq')

if isnull(ls_eduyear) or ls_eduyear = "" then 
	MessageBox("확 인", "년도는 필수 입력사항입니다.!!")
	dw_ip.SetColumn('eduyear')
	dw_ip.setfocus()
	return -1 
end if

if isnull(ls_empno) or ls_empno = "" then 
	MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
	dw_ip.SetColumn('empno')
	dw_ip.setfocus()
	return -1 
end if

if isnull(ll_empseq) or string(ll_empseq) = "" then 
	MessageBox("확 인", "순번은 필수 입력사항입니다.!!")
	dw_ip.SetColumn('empseq')
	dw_ip.setfocus()
	return -1 
end if

dw_list.SetRedraw(false)
If dw_print.Retrieve(ls_company, ls_empno, ls_eduyear, ll_empseq) < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_list.reset()
	dw_list.insertrow(0)
   dw_list.SetRedraw(true)	
  	return -1
End if	
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)	

return 1
end function

on w_pig2020_1.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_pig2020_1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;
w_mdi_frame.sle_msg.text = ""
w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_ip.setItem(1, 'eduyear', string(today(), 'YYYY'))

end event

type p_preview from w_standard_print`p_preview within w_pig2020_1
end type

type p_exit from w_standard_print`p_exit within w_pig2020_1
end type

type p_print from w_standard_print`p_print within w_pig2020_1
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig2020_1
end type

type st_window from w_standard_print`st_window within w_pig2020_1
integer x = 2501
integer y = 3988
end type

type sle_msg from w_standard_print`sle_msg within w_pig2020_1
integer x = 526
integer y = 3988
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig2020_1
integer x = 2994
integer y = 3988
end type

type st_10 from w_standard_print`st_10 within w_pig2020_1
integer x = 165
integer y = 3988
end type

type gb_10 from w_standard_print`gb_10 within w_pig2020_1
integer x = 151
integer y = 3952
end type

type dw_print from w_standard_print`dw_print within w_pig2020_1
integer x = 4434
integer y = 200
string dataobject = "d_pig2020_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig2020_1
integer x = 457
integer y = 68
integer width = 2432
integer height = 156
string dataobject = "d_pig2020_9"
end type

event dw_ip::itemchanged;string ls_empno, snull, get_empno, ls_eduyear
long ll_empseq, get_empseq, lnull

SetNull(snull)
SetNull(lnull)

if this.GetColumnName() = 'eduyear' then
	
	ls_eduyear = this.GetItemString(1, 'eduyear')
	
	if isnull(ls_eduyear) or trim(ls_eduyear) = "" then 
		MessageBox("확 인", "년도는 필수입력사항입니다.!!")
		return 1
	end if 
	If f_datechk(ls_eduyear + '01' + '01') = -1 Then 
		MessageBox("확 인", "유효한 교육일자가 아닙니다.!!")
		return 1 // date형이 아니면 discard
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
		return 
    end if	
	if sqlca.sqlcode <> 0 then 
		this.SetItem(1, 'empno', snull)	
		return 1
    end if	
 
end if

If this.GetcolumnName() = 'empseq'  Then
	ll_empseq = long(this.GetText())
	ls_empno = this.GetItemString(1, 'empno')	
	ls_eduyear = this.GetItemString(1, 'eduyear')
	
	if isnull(ll_empseq) or trim(string(ll_empseq)) = "" then
		MessageBox("확 인", "순번은 필수 입력사항입니다.!!")
		return 1
	end if
	
	SELECT "P5_EDUCATIONS_P"."EMPSEQ"  
    INTO :get_empseq
    FROM "P5_EDUCATIONS_P"  
	 WHERE "P5_EDUCATIONS_P"."COMPANYCODE" = :gs_company AND   
          "P5_EDUCATIONS_P"."EMPNO" = :ls_empno AND    
          "P5_EDUCATIONS_P"."EDUYEAR"  = :ls_eduyear AND 
          "P5_EDUCATIONS_P"."EMPSEQ"  = :ll_empseq  AND 
          "P5_EDUCATIONS_P"."BGUBN" = 'R' ;           

    if sqlca.sqlcode <> 0 then 
		MessageBox("확 인", "존재하지 않는 순번이거나, " + "~n" + "~n" + &
		           "교육훈련[신청]자료가 아닙니다.!!")
		this.SetItem(1, 'empseq', lnull)
		return 1
	end if
end if 

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string ls_eduyear 

setNull(Gs_Code)

Choose Case  This.GetColumnName() 
	Case "empno"               // 사원 조회선택
  	     open(w_employee_popup)
	     If IsNull(gs_code) Then 	Return 1
		  
	     this.SetItem(GetRow(),This.GetColumnName(),Gs_code)

		  this.TriggerEvent(ItemChanged!)
		  
	case 'empseq'

      	Gs_Code  = gs_company		
		
			ls_eduyear = this.object.eduyear[GetRow()]
			
			if isnull(ls_eduyear) then
				ls_eduyear = ""
			end if
			
			istr_edu.str_empno   = this.Getitemstring(1, "empno")    // 사번
			istr_edu.str_eduyear =  ls_eduyear                       // 계획년도
			
			istr_edu.str_empseq  = this.GetitemNumber(1, "empseq")   // 일련번호
			
			SetNull(istr_edu.str_egubn)      // 교육구분(1:사내, 2:사외)
			
//         SetNull(istr_edu.str_gbn)   		// 자료구분(P : 계획자료, R : 신청자료)			
         istr_edu.str_gbn = 'R'      		// 자료구분(P : 계획자료, R : 신청자료)						
		
			//openwithparm(w_pig2020_popup7, istr_edu)
          openwithparm(w_edu_popup, istr_edu)							  
			 
			istr_edu = Message.PowerObjectParm	     // return value
		
			IF	IsNull(istr_edu.str_empno) THEN RETURN
			IF	IsNull(istr_edu.str_eduyear) THEN RETURN
			IF	IsNull(istr_edu.str_empseq) THEN RETURN
			IF	IsNull(istr_edu.str_gbn) THEN RETURN	
			
			this.SetItem(1, "empseq", istr_edu.str_empseq)
		
			this.SetColumn('empseq')
			
   	   this.TriggerEvent(ItemChanged!)			
		  
END Choose

end event

type dw_list from w_standard_print`dw_list within w_pig2020_1
integer x = 462
integer y = 320
integer width = 3817
integer height = 1932
string title = "사내 교육 신청서"
string dataobject = "d_pig2020_1"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type gb_4 from groupbox within w_pig2020_1
integer x = 251
integer y = 3868
integer width = 768
integer height = 428
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "정렬"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pig2020_1
integer x = 3035
integer y = 156
integer width = 704
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사외 교육 훈련 계획"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.DataObject = 'd_pig2020_2'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_pig2020_2_p'
dw_print.SetTransObject(sqlca)
dw_list.Title = '사외 교육 신청서'
end event

type rb_2 from radiobutton within w_pig2020_1
integer x = 3035
integer y = 68
integer width = 704
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사내 교육 훈련 계획"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.DataObject = 'd_pig2020_1'
dw_list.SetTransObject(sqlca)
dw_print.DataObject = 'd_pig2020_1_p'
dw_print.SetTransObject(sqlca)
dw_list.Title = '사내 교육 신청서'
end event

type gb_1 from groupbox within w_pig2020_1
integer x = 3013
integer y = 32
integer width = 754
integer height = 220
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within w_pig2020_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 453
integer y = 316
integer width = 3845
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pig2020_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 448
integer y = 28
integer width = 3360
integer height = 248
integer cornerheight = 40
integer cornerwidth = 55
end type

