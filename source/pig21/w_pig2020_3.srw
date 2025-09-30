$PBExportHeader$w_pig2020_3.srw
$PBExportComments$교육훈련계획 (사내/사외) - 출력
forward
global type w_pig2020_3 from w_standard_print
end type
type gb_4 from groupbox within w_pig2020_3
end type
type rr_2 from roundrectangle within w_pig2020_3
end type
type rr_1 from roundrectangle within w_pig2020_3
end type
end forward

global type w_pig2020_3 from w_standard_print
string title = "교육훈련계획"
gb_4 gb_4
rr_2 rr_2
rr_1 rr_1
end type
global w_pig2020_3 w_pig2020_3

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string eduyear,fr_dept,to_dept,fr_empno,to_empno, ls_kind
string min_dept,max_dept,min_empno,max_empno

dw_ip.AcceptText()
row = dw_ip.GetRow()
If row = 0 Then return -1

eduyear = Trim(dw_ip.GetItemString(row,'eduyear'))
fr_dept = Trim(dw_ip.GetItemString(row,'fr_dept'))
to_dept = Trim(dw_ip.GetItemString(row,'to_dept'))
fr_empno = Trim(dw_ip.GetItemString(row,'fr_empno'))
ls_kind = Trim(dw_ip.GetItemString(row,'ekind'))
//to_empno = Trim(dw_ip.GetItemString(row,'to_empno'))

If IsNull(eduyear) Then 
	MessageBox("확인","계획년도를 입력하세요")
	dw_ip.SetFocus()
	dw_ip.SetColumn('eduyear')
	return -1
End If	

////부서및 사번 미입력시 최대및 최소값을 구한후 조회
//select min(deptcode),max(deptcode) ,min(empno),max(empno)
//  into :min_dept,:max_dept,:min_empno,:max_empno
//  from p1_master;
//
If fr_dept = '' Or IsNull(fr_dept) Then fr_dept = '%'
//If to_dept = '' Or IsNull(to_dept) Then to_dept = max_dept
If fr_empno = '' Or IsNull(fr_empno) Then fr_empno = '%'
//If to_empno = '' Or IsNull(to_empno) Then to_empno = max_empno


If dw_print.Retrieve(eduyear,fr_dept,fr_empno,ls_kind ) < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	//p_print.enabled = false
  	return -1
End if	
dw_print.sharedata(dw_list)
return 1
//cb_print.enabled = true

end function

on w_pig2020_3.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pig2020_3.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;string syear

dw_list.SetTransObject(sqlca)

syear = String(Year(Today()))
dw_ip.SetItem(dw_ip.GetRow(),'eduyear',syear)  //당해년도 설정


end event

type p_preview from w_standard_print`p_preview within w_pig2020_3
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pig2020_3
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pig2020_3
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig2020_3
integer x = 3899
end type

type st_window from w_standard_print`st_window within w_pig2020_3
integer x = 2711
integer y = 4028
end type

type sle_msg from w_standard_print`sle_msg within w_pig2020_3
integer x = 736
integer y = 4028
end type

type dw_datetime from w_standard_print`dw_datetime within w_pig2020_3
integer x = 3205
integer y = 4028
end type

type st_10 from w_standard_print`st_10 within w_pig2020_3
integer x = 375
integer y = 4028
end type

type gb_10 from w_standard_print`gb_10 within w_pig2020_3
integer x = 361
integer y = 3992
end type

type dw_print from w_standard_print`dw_print within w_pig2020_3
integer x = 3749
string dataobject = "d_pig2020_3_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_pig2020_3
integer x = 114
integer y = 24
integer width = 3493
integer height = 252
string dataobject = "d_pig2020_8"
end type

event dw_ip::itemchanged;//If dwo.Name = 'fr_date' Or dwo.Name = 'to_date' Then
//	If f_datechk(data) = -1 Then return 1 // date형이 아니면 discard
//End If
//
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;Choose Case  This.GetColumnName() 
	Case "fr_dept" ,"to_dept"                 // 부서 조회선택
  	     open(w_dept_popup)
	     If IsNull(gs_code) Then Return 1
	     this.SetItem(GetRow(),This.GetColumnName(),Gs_code)
	Case "fr_empno" ,"to_empno"               // 사원 조회선택
  	     open(w_employee_popup)
	     If IsNull(gs_code) Then Return 1
	     this.SetItem(GetRow(),This.GetColumnName(),Gs_code)		  
END Choose

end event

type dw_list from w_standard_print`dw_list within w_pig2020_3
integer x = 119
integer y = 312
integer width = 4375
integer height = 1968
string title = "사외 교육훈련계획"
string dataobject = "d_pig2020_3"
boolean border = false
end type

type gb_4 from groupbox within w_pig2020_3
integer x = 389
integer y = 4056
integer width = 768
integer height = 404
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "정렬"
end type

type rr_2 from roundrectangle within w_pig2020_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 101
integer y = 304
integer width = 4402
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pig2020_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 96
integer y = 16
integer width = 3570
integer height = 276
integer cornerheight = 40
integer cornerwidth = 55
end type

