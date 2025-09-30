$PBExportHeader$w_pil1003.srw
$PBExportComments$월상환자료생성
forward
global type w_pil1003 from w_inherite_standard
end type
type p_compute from picture within w_pil1003
end type
type st_24 from statictext within w_pil1003
end type
type st_23 from statictext within w_pil1003
end type
type st_22 from statictext within w_pil1003
end type
type dw_personal from u_d_select_sort within w_pil1003
end type
type dw_total from u_d_select_sort within w_pil1003
end type
type pb_2 from picturebutton within w_pil1003
end type
type pb_1 from picturebutton within w_pil1003
end type
type uo_progress from u_progress_bar within w_pil1003
end type
type st_12 from statictext within w_pil1003
end type
type st_10 from statictext within w_pil1003
end type
type st_9 from statictext within w_pil1003
end type
type st_8 from statictext within w_pil1003
end type
type rb_3 from radiobutton within w_pil1003
end type
type rb_2 from radiobutton within w_pil1003
end type
type rb_1 from radiobutton within w_pil1003
end type
type st_6 from statictext within w_pil1003
end type
type em_paydate from editmask within w_pil1003
end type
type st_7 from statictext within w_pil1003
end type
type rb_per from radiobutton within w_pil1003
end type
type sle_end from singlelineedit within w_pil1003
end type
type sle_start from singlelineedit within w_pil1003
end type
type st_4 from statictext within w_pil1003
end type
type rb_all from radiobutton within w_pil1003
end type
type st_3 from statictext within w_pil1003
end type
type st_2 from statictext within w_pil1003
end type
type em_date from editmask within w_pil1003
end type
type st_5 from statictext within w_pil1003
end type
type st_11 from statictext within w_pil1003
end type
type rr_1 from roundrectangle within w_pil1003
end type
type rr_6 from roundrectangle within w_pil1003
end type
type rr_7 from roundrectangle within w_pil1003
end type
type rr_8 from roundrectangle within w_pil1003
end type
type rr_2 from roundrectangle within w_pil1003
end type
type rr_3 from roundrectangle within w_pil1003
end type
type rr_4 from roundrectangle within w_pil1003
end type
type rr_5 from roundrectangle within w_pil1003
end type
type ln_6 from line within w_pil1003
end type
type ln_7 from line within w_pil1003
end type
type ln_1 from line within w_pil1003
end type
type ln_2 from line within w_pil1003
end type
type ln_3 from line within w_pil1003
end type
type ln_4 from line within w_pil1003
end type
type dw_err from u_d_select_sort within w_pil1003
end type
end forward

global type w_pil1003 from w_inherite_standard
string title = "월상환자료생성"
boolean resizable = false
p_compute p_compute
st_24 st_24
st_23 st_23
st_22 st_22
dw_personal dw_personal
dw_total dw_total
pb_2 pb_2
pb_1 pb_1
uo_progress uo_progress
st_12 st_12
st_10 st_10
st_9 st_9
st_8 st_8
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
st_6 st_6
em_paydate em_paydate
st_7 st_7
rb_per rb_per
sle_end sle_end
sle_start sle_start
st_4 st_4
rb_all rb_all
st_3 st_3
st_2 st_2
em_date em_date
st_5 st_5
st_11 st_11
rr_1 rr_1
rr_6 rr_6
rr_7 rr_7
rr_8 rr_8
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
ln_6 ln_6
ln_7 ln_7
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
dw_err dw_err
end type
global w_pil1003 w_pil1003

type variables
DataWindow dw_Process

Integer           il_RowCount,iAry_EditChild =0
String             Is_PbTag = 'P'
Double          Id_NoTax_Sub = 0                     //비과세공제
end variables

forward prototypes
public subroutine wf_create_error (string sempno, string sname, string sflag)
end prototypes

public subroutine wf_create_error (string sempno, string sname, string sflag);Int    il_CurRow

il_CurRow = dw_err.InsertRow(0)
dw_err.SetItem(il_CurRow,"empno",sempno)
dw_err.SetItem(il_CurRow,"empname",sname)

IF sflag ='1' THEN
	dw_err.SetItem(il_CurRow,"errtext",'대출금 마스타 자료 없슴')	
ELSEIF sflag ='2' THEN	
	dw_err.SetItem(il_CurRow,"errtext",'상환계획 자료 없슴')	
ELSEIF sflag ='3' THEN	
	dw_err.SetItem(il_CurRow,"errtext",'상환자료 생성시 오류')		
END IF

end subroutine

event open;call super::open;
dw_datetime.SetTransObject(SQLCA)
dw_datetime.Reset()
dw_datetime.InsertRow(0)

dw_total.settransobject(SQLCA)
dw_personal.settransobject(SQLCA)
dw_err.settransobject(SQLCA)

uo_progress.Hide()

em_date.text    = String(Left(gs_today,6),"@@@@.@@")
em_paydate.text = String(gs_today,"@@@@.@@.@@")

//em_date.TriggerEvent(Modified!)

em_date.Setfocus()

dw_err.reset()

pb_1.picturename = "C:\erpman\Image\next.gif"
pb_2.picturename = "C:\erpman\Image\prior.gif"



end event

on w_pil1003.create
int iCurrent
call super::create
this.p_compute=create p_compute
this.st_24=create st_24
this.st_23=create st_23
this.st_22=create st_22
this.dw_personal=create dw_personal
this.dw_total=create dw_total
this.pb_2=create pb_2
this.pb_1=create pb_1
this.uo_progress=create uo_progress
this.st_12=create st_12
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_6=create st_6
this.em_paydate=create em_paydate
this.st_7=create st_7
this.rb_per=create rb_per
this.sle_end=create sle_end
this.sle_start=create sle_start
this.st_4=create st_4
this.rb_all=create rb_all
this.st_3=create st_3
this.st_2=create st_2
this.em_date=create em_date
this.st_5=create st_5
this.st_11=create st_11
this.rr_1=create rr_1
this.rr_6=create rr_6
this.rr_7=create rr_7
this.rr_8=create rr_8
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
this.ln_6=create ln_6
this.ln_7=create ln_7
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.dw_err=create dw_err
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_compute
this.Control[iCurrent+2]=this.st_24
this.Control[iCurrent+3]=this.st_23
this.Control[iCurrent+4]=this.st_22
this.Control[iCurrent+5]=this.dw_personal
this.Control[iCurrent+6]=this.dw_total
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.uo_progress
this.Control[iCurrent+10]=this.st_12
this.Control[iCurrent+11]=this.st_10
this.Control[iCurrent+12]=this.st_9
this.Control[iCurrent+13]=this.st_8
this.Control[iCurrent+14]=this.rb_3
this.Control[iCurrent+15]=this.rb_2
this.Control[iCurrent+16]=this.rb_1
this.Control[iCurrent+17]=this.st_6
this.Control[iCurrent+18]=this.em_paydate
this.Control[iCurrent+19]=this.st_7
this.Control[iCurrent+20]=this.rb_per
this.Control[iCurrent+21]=this.sle_end
this.Control[iCurrent+22]=this.sle_start
this.Control[iCurrent+23]=this.st_4
this.Control[iCurrent+24]=this.rb_all
this.Control[iCurrent+25]=this.st_3
this.Control[iCurrent+26]=this.st_2
this.Control[iCurrent+27]=this.em_date
this.Control[iCurrent+28]=this.st_5
this.Control[iCurrent+29]=this.st_11
this.Control[iCurrent+30]=this.rr_1
this.Control[iCurrent+31]=this.rr_6
this.Control[iCurrent+32]=this.rr_7
this.Control[iCurrent+33]=this.rr_8
this.Control[iCurrent+34]=this.rr_2
this.Control[iCurrent+35]=this.rr_3
this.Control[iCurrent+36]=this.rr_4
this.Control[iCurrent+37]=this.rr_5
this.Control[iCurrent+38]=this.ln_6
this.Control[iCurrent+39]=this.ln_7
this.Control[iCurrent+40]=this.ln_1
this.Control[iCurrent+41]=this.ln_2
this.Control[iCurrent+42]=this.ln_3
this.Control[iCurrent+43]=this.ln_4
this.Control[iCurrent+44]=this.dw_err
end on

on w_pil1003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_compute)
destroy(this.st_24)
destroy(this.st_23)
destroy(this.st_22)
destroy(this.dw_personal)
destroy(this.dw_total)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.uo_progress)
destroy(this.st_12)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_6)
destroy(this.em_paydate)
destroy(this.st_7)
destroy(this.rb_per)
destroy(this.sle_end)
destroy(this.sle_start)
destroy(this.st_4)
destroy(this.rb_all)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_date)
destroy(this.st_5)
destroy(this.st_11)
destroy(this.rr_1)
destroy(this.rr_6)
destroy(this.rr_7)
destroy(this.rr_8)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.dw_err)
end on

type p_mod from w_inherite_standard`p_mod within w_pil1003
boolean visible = false
integer x = 2441
integer y = 2380
end type

type p_del from w_inherite_standard`p_del within w_pil1003
boolean visible = false
integer x = 2615
integer y = 2380
end type

type p_inq from w_inherite_standard`p_inq within w_pil1003
integer x = 3854
end type

event p_inq::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string sYearMonth,sYearMonthDay, pbgubn
dw_total.Reset()
dw_personal.Reset()
dw_err.Reset()

sYearMonth    = Left(em_date.text,4)+Right(em_date.text,2) 
sYearMonthDay = Left(em_paydate.text,4)+Mid(em_paydate.text,6,2)+Right(em_paydate.text,2)  
IF sYearMonthDay ="" OR IsNull(sYearMonthDay) THEN
	MessageBox("확 인","기준일자를 입력하세요!!")
	em_paydate.SetFocus()
	Return
END IF


IF dw_total.Retrieve(Gs_Company,sYearMonth,sYearMonthDay) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	em_date.SetFocus()
	Return
END IF
end event

type p_print from w_inherite_standard`p_print within w_pil1003
boolean visible = false
integer x = 1746
integer y = 2380
end type

type p_can from w_inherite_standard`p_can within w_pil1003
end type

type p_exit from w_inherite_standard`p_exit within w_pil1003
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)

end event

type p_ins from w_inherite_standard`p_ins within w_pil1003
boolean visible = false
integer x = 1920
integer y = 2380
end type

type p_search from w_inherite_standard`p_search within w_pil1003
boolean visible = false
integer x = 1568
integer y = 2380
end type

type p_addrow from w_inherite_standard`p_addrow within w_pil1003
boolean visible = false
integer x = 2094
integer y = 2380
end type

type p_delrow from w_inherite_standard`p_delrow within w_pil1003
boolean visible = false
integer x = 2267
integer y = 2380
end type

type dw_insert from w_inherite_standard`dw_insert within w_pil1003
boolean visible = false
integer x = 1307
integer y = 2376
end type

type st_window from w_inherite_standard`st_window within w_pil1003
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pil1003
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pil1003
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pil1003
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pil1003
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pil1003
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pil1003
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pil1003
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pil1003
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pil1003
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pil1003
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pil1003
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pil1003
boolean visible = false
end type

type p_compute from picture within w_pil1003
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4032
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\Image\계산_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\계산_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\계산_up.gif"
end event

event clicked;w_mdi_frame.sle_msg.text =""

String  sYearMonth,sYearMonthDay,pbgubn,delete_flag='NO',del_pbgubn
Integer iPayRate,il_RetrieveRow,il_meterPosition,il_currow,il_SearchRow,il_BefCount =0,k,rtnval

/*인사 마스타 자료*/
String  Master_EmpNo,   Master_EmpName

sYearMonth    = Left(em_date.text,4)+Right(em_date.text,2) 
sYearMonthDay = Left(em_paydate.text,4)+Mid(em_paydate.text,6,2)+Right(em_paydate.text,2)  
IF sYearMonthDay ="" OR IsNull(sYearMonthDay) THEN
	MessageBox("확 인","기준일자를 입력하세요!!")
	em_paydate.SetFocus()
	Return
END IF

IF rb_1.Checked = True THEN
	pbgubn = 'P'
ELSEIF rb_2.Checked = True THEN
	pbgubn = 'B'
ELSEIF rb_3.Checked = True THEN
	pbgubn = 'I'
END IF


IF rb_all.Checked = True THEN
	dw_Process = dw_Total
	il_RowCount = dw_Total.RowCount()
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
END IF

IF il_RowCount <=0 THEN
	MessageBox("확 인","처리 선택한 자료가 없습니다!!")
	Return
END IF
/* 처리년월의 급여자료가 있는지 확인*/
SELECT Count(*)
	INTO :il_BefCount
   FROM  "P3_LENDREST"
   WHERE "LENDDATE" = :sYearMonth AND "PAYGBN" = :Pbgubn;
	
IF il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "당월 상환 계산 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF

SELECT Count(*)
	INTO :il_BefCount
   FROM  "P3_LENDREST"
   WHERE "LENDDATE" = :sYearMonth AND "PAYGBN" <> :Pbgubn AND
			"RESTDATE" = :sYearMonthDay ;
	
IF il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "동일한 날짜에 구분이 다른 상환 계산 자료가 존재합니다. 모두삭제후 작업하시겠습니까?",&
																Question!,YesNo!,2) = 1 THEN 
		delete_flag = 'YES'
	ELSE
		delete_flag = 'NO'
	END IF	
END IF


w_mdi_frame.sle_msg.text = '당월 상환 자료 생성중 ......'
SetPointer(HourGlass!)

sle_start.text = String(Now(),'hh:mm:ss AM/PM')

uo_progress.Show()
/*전체처리시 상환자료 일괄삭제 */

IF delete_flag = 'YES' THEN
	del_pbgubn = '%'
ELSE
	del_pbgubn = pbgubn
END IF
	
IF rb_all.Checked = True THEN
   
	
	DELETE FROM "P3_LENDREST"  
   WHERE ( "P3_LENDREST"."LENDDATE" = :sYearMonth ) AND  
         ( "P3_LENDREST"."PAYGBN" LIKE :del_pbgubn )   ;
END IF

FOR k = 1 TO il_RowCount
	Master_EmpNo       = dw_Process.GetItemString(k,"empno")
	Master_EmpName     = dw_Process.GetItemString(k,"empname") 
	
	il_meterPosition = (k/ il_RowCount) * 100
	uo_progress.uf_set_position (il_meterPosition)	
   rtnval = f_lendcalc(Master_EmpNo,pbgubn,sYearMonthDay,sYearMonth,del_pbgubn)
	IF rtnval = 0 THEN
	ELSE
		wf_create_error(Master_EmpNo,Master_EmpName,STRING(rtnval)) 
	END IF	
NEXT
rtnval = f_lendmstupdate(sYearMonthDay)

uo_progress.Hide()

w_mdi_frame.sle_msg.text = '당월 상환 자료 생성 완료!!'
SetPointer(Arrow!)

sle_end.text = String(Now(),'hh:mm:ss AM/PM')


end event

type st_24 from statictext within w_pil1003
integer x = 2583
integer y = 460
integer width = 224
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "오류자"
boolean focusrectangle = false
end type

type st_23 from statictext within w_pil1003
integer x = 1627
integer y = 460
integer width = 155
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "개인"
boolean focusrectangle = false
end type

type st_22 from statictext within w_pil1003
integer x = 544
integer y = 460
integer width = 146
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean focusrectangle = false
end type

type dw_personal from u_d_select_sort within w_pil1003
integer x = 1595
integer y = 516
integer width = 859
integer height = 1664
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pil1003_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_total from u_d_select_sort within w_pil1003
integer x = 503
integer y = 516
integer width = 859
integer height = 1664
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pil1003_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type pb_2 from picturebutton within w_pil1003
integer x = 1426
integer y = 908
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName
Long   totRow , sRow,rowcnt
int i

totrow =dw_personal.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_personal.GetItemString(sRow, "empno")
   sEmpName     = dw_personal.GetItemString(sRow, "empname")
		
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_per.Checked = True
ELSE
	rb_all.Checked = True
END IF	
end event

type pb_1 from picturebutton within w_pil1003
integer x = 1426
integer y = 804
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
alignment htextalign = left!
end type

event clicked;String sEmpNo,sEmpName
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_total.GetItemString(sRow, "empno")
   sEmpName     = dw_total.GetItemString(sRow, "empname")
		
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname",     sEmpName)
	dw_personal.setitem(rowcnt, "empno",       sEmpNo)
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_per.Checked = True
ELSE
	rb_all.Checked = True
END IF	
end event

type uo_progress from u_progress_bar within w_pil1003
integer x = 3154
integer y = 2264
integer width = 1083
integer height = 72
integer taborder = 40
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type st_12 from statictext within w_pil1003
integer x = 1641
integer y = 88
integer width = 274
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
string text = " 처리조건"
boolean focusrectangle = false
end type

type st_10 from statictext within w_pil1003
integer x = 544
integer y = 80
integer width = 576
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
string text = " 작업년월및 대상설정"
boolean focusrectangle = false
end type

type st_9 from statictext within w_pil1003
integer x = 517
integer y = 172
integer width = 46
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
boolean focusrectangle = false
end type

type st_8 from statictext within w_pil1003
integer x = 1595
integer y = 168
integer width = 46
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
boolean focusrectangle = false
end type

type rb_3 from radiobutton within w_pil1003
integer x = 2391
integer y = 256
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "기 타"
boolean lefttext = true
end type

type rb_2 from radiobutton within w_pil1003
integer x = 2153
integer y = 256
integer width = 233
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "상 여"
boolean lefttext = true
end type

type rb_1 from radiobutton within w_pil1003
integer x = 1920
integer y = 260
integer width = 242
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "급 여"
boolean checked = true
boolean lefttext = true
end type

type st_6 from statictext within w_pil1003
integer x = 1641
integer y = 172
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "기준일자"
boolean focusrectangle = false
end type

type em_paydate from editmask within w_pil1003
event ue_keyenter pbm_keydown
integer x = 1929
integer y = 172
integer width = 311
integer height = 56
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
end type

event ue_keyenter;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 1
end if
end event

type st_7 from statictext within w_pil1003
integer x = 1641
integer y = 260
integer width = 261
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "공제구분"
boolean focusrectangle = false
end type

type rb_per from radiobutton within w_pil1003
integer x = 1161
integer y = 260
integer width = 201
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "개인"
boolean lefttext = true
end type

event clicked;//
//rb_all.checked = false
//
//
end event

type sle_end from singlelineedit within w_pil1003
integer x = 3113
integer y = 256
integer width = 407
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type sle_start from singlelineedit within w_pil1003
integer x = 3113
integer y = 156
integer width = 407
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type st_4 from statictext within w_pil1003
integer x = 2825
integer y = 156
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "시작시간"
boolean focusrectangle = false
end type

type rb_all from radiobutton within w_pil1003
integer x = 896
integer y = 260
integer width = 206
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "전체"
boolean checked = true
boolean lefttext = true
end type

event clicked;//
////String ldt_workdate
////
////ldt_workdate = Left(em_date.text,4) + Right(em_date.text,2)+ '31'
////
//mm = integer(mid(em_date.text,6,2))
//
//startdate = Left(em_date.text,4)+Right(em_date.text,2) + "01"
//enddate = Left(em_date.text,4)+Right(em_date.text,2)  + STRING(idd_dd[mm])
//
//st_info.Visible = True
//
//dw_1.retrieve(gs_company,startdate,enddate)
//dw_2.Reset()
//dw_err.Reset()
//
//rb_per.checked = false
end event

type st_3 from statictext within w_pil1003
integer x = 567
integer y = 260
integer width = 293
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업대상"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pil1003
integer x = 1271
integer y = 164
integer width = 165
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "현재"
boolean focusrectangle = false
end type

type em_date from editmask within w_pil1003
event ue_keydown pbm_keydown
integer x = 891
integer y = 172
integer width = 366
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy.mm"
end type

event ue_keydown;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 1
end if
end event

event modified;
//p_inq.TriggerEvent(Clicked!)
end event

type st_5 from statictext within w_pil1003
integer x = 567
integer y = 172
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업년월"
boolean focusrectangle = false
end type

type st_11 from statictext within w_pil1003
integer x = 2825
integer y = 260
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "완료시간"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 421
integer y = 424
integer width = 3826
integer height = 1816
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 485
integer y = 484
integer width = 887
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1577
integer y = 484
integer width = 887
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_8 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2537
integer y = 484
integer width = 1655
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 421
integer y = 52
integer width = 3218
integer height = 336
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 462
integer y = 100
integer width = 978
integer height = 264
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1522
integer y = 100
integer width = 1147
integer height = 264
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pil1003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2761
integer y = 100
integer width = 832
integer height = 264
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_6 from line within w_pil1003
integer linethickness = 1
integer beginx = 891
integer beginy = 228
integer endx = 1262
integer endy = 228
end type

type ln_7 from line within w_pil1003
integer linethickness = 1
integer beginx = 1934
integer beginy = 228
integer endx = 2240
integer endy = 228
end type

type ln_1 from line within w_pil1003
integer linethickness = 1
integer beginx = 1925
integer beginy = 332
integer endx = 2629
integer endy = 332
end type

type ln_2 from line within w_pil1003
integer linethickness = 1
integer beginx = 891
integer beginy = 324
integer endx = 1385
integer endy = 324
end type

type ln_3 from line within w_pil1003
integer linethickness = 1
integer beginx = 3118
integer beginy = 212
integer endx = 3515
integer endy = 212
end type

type ln_4 from line within w_pil1003
integer linethickness = 1
integer beginx = 3113
integer beginy = 312
integer endx = 3515
integer endy = 312
end type

type dw_err from u_d_select_sort within w_pil1003
integer x = 2569
integer y = 516
integer width = 1614
integer height = 1664
integer taborder = 11
string dataobject = "d_pil1003_2"
boolean hscrollbar = false
boolean border = false
end type

event clicked;call super::clicked;string objname, obj

obj = getobjectatpointer()
objname = f_get_token(obj, '~t')
choose case objname
	case 'p1_master_empno_t'
		setsort('#1 a')
		sort()
	case 'p1_master_empname_t'
		setsort('#2 a')
		sort()
end choose
end event

