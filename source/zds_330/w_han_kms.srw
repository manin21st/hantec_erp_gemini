$PBExportHeader$w_han_kms.srw
$PBExportComments$생산금액(마감용) - 김무성 전용
forward
global type w_han_kms from w_standard_print
end type
type st_1 from statictext within w_han_kms
end type
type st_2 from statictext within w_han_kms
end type
type hpb_1 from hprogressbar within w_han_kms
end type
type st_3 from statictext within w_han_kms
end type
type st_4 from statictext within w_han_kms
end type
type pb_1 from u_pb_cal within w_han_kms
end type
type pb_2 from u_pb_cal within w_han_kms
end type
type rr_1 from roundrectangle within w_han_kms
end type
end forward

global type w_han_kms from w_standard_print
string title = "생산금액(마감용)"
st_1 st_1
st_2 st_2
hpb_1 hpb_1
st_3 st_3
st_4 st_4
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_han_kms w_han_kms

forward prototypes
public function integer wf_retrieve ()
public function integer wf_filter ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_yymm

ls_yymm = dw_ip.GetItemString(row, 'd_yymm')
If Trim(ls_yymm) = '' Or IsNull(ls_yymm) Then
	MessageBox('기간 확인', '시작일은 필수 사항 입니다.')
	dw_ip.SetColumn('d_yymm')
	dw_ip.SetFocus()
	Return -1
End If

String ls_yymm2

ls_yymm2 = dw_ip.GetItemString(row, 'd_yymm2')
If Trim(ls_yymm2) = '' OR IsNull(ls_yymm2) Then
	Messagebox('기간 확인', '종료일은 필수 사항 입니다.')
	dw_ip.SetColumn('d_yymm2')
	dw_ip.SetFocus()
	Return -1
End If

st_1.Visible = True
st_2.Visible = True

dw_list.SetRedraw(False)
dw_list.Retrieve(gs_saupj, ls_yymm, ls_yymm2)
dw_list.SetRedraw(True)

st_1.Text = '생산BOM 및 표준공정 검증 중입니다!!'
wf_filter()

st_1.Visible = False
st_2.Visible = False

Return 1

end function

public function integer wf_filter ();hpb_1.Position = 0
hpb_1.Visible  = True

Long i, ll_chk
String ls_itnbr
For i = 1 To dw_list.RowCount()
	ls_itnbr = dw_list.GetItemString(i, 'itnbr')
	
	select count('x')
	  into :ll_chk
     from (  select pinbr
	 		      from pstruc
	 		  connect by prior cinbr = pinbr
	 		  start with pinbr = :ls_itnbr )  a,
		    routng b
    where a.pinbr = b.itnbr ;
	
	If ll_chk < 1 Then
		dw_list.DeleteRow(i)
		i = i - 1
	end If
	
	hpb_1.Position = (i / dw_list.RowCount()) * 100
	
Next

ROLLBACK USING SQLCA;

hpb_1.Visible = False

Return 1
end function

on w_han_kms.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.hpb_1=create hpb_1
this.st_3=create st_3
this.st_4=create st_4
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.hpb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_han_kms.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.hpb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_han_kms
boolean visible = true
integer x = 4219
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_kms
integer x = 3689
integer y = 20
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_kms
boolean visible = false
integer x = 3333
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_han_kms
integer x = 4393
end type

type p_print from w_standard_print`p_print within w_han_kms
boolean visible = false
integer x = 3511
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_kms
integer x = 4046
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
//	p_preview.enabled = true
//	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

end event







type st_10 from w_standard_print`st_10 within w_han_kms
end type



type dw_print from w_standard_print`dw_print within w_han_kms
integer x = 3877
integer y = 32
boolean enabled = false
string dataobject = "d_han_kms_002"
end type

type dw_ip from w_standard_print`dw_ip within w_han_kms
integer x = 37
integer width = 1198
integer height = 164
string dataobject = "d_han_kms_001"
end type

type dw_list from w_standard_print`dw_list within w_han_kms
integer x = 50
integer y = 212
integer width = 4521
integer height = 2016
string dataobject = "d_han_kms_002"
boolean border = false
end type

type st_1 from statictext within w_han_kms
boolean visible = false
integer x = 50
integer y = 928
integer width = 4521
integer height = 268
boolean bringtotop = true
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "자료 조회 중 입니다!!"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_han_kms
boolean visible = false
integer x = 50
integer y = 1164
integer width = 4521
integer height = 232
boolean bringtotop = true
integer textsize = -28
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "빛으로 빠른 조회 스피드!!!!!!!"
alignment alignment = center!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_han_kms
boolean visible = false
integer x = 1065
integer y = 1400
integer width = 2487
integer height = 160
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type st_3 from statictext within w_han_kms
integer x = 1253
integer y = 60
integer width = 1253
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "※ 출하/매출 자료에는 CKD공장 자료분 제외"
boolean focusrectangle = false
end type

type st_4 from statictext within w_han_kms
integer x = 1253
integer y = 124
integer width = 2016
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "※ 일 검수 자료에는 M1공장 제외 (M1공장은 월 검수 자료만 접수 됨.)"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_han_kms
integer x = 617
integer y = 60
integer width = 78
integer height = 72
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_yymm')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_yymm', gs_code)

end event

type pb_2 from u_pb_cal within w_han_kms
integer x = 1083
integer y = 60
integer width = 82
integer height = 72
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_yymm2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_yymm2', gs_code)

end event

type rr_1 from roundrectangle within w_han_kms
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 200
integer width = 4549
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

