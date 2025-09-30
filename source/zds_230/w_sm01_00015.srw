$PBExportHeader$w_sm01_00015.srw
$PBExportComments$월 판매계획 접수
forward
global type w_sm01_00015 from w_inherite
end type
type dw_temp from datawindow within w_sm01_00015
end type
type st_at from statictext within w_sm01_00015
end type
type hpb_1 from hprogressbar within w_sm01_00015
end type
type dw_save from datawindow within w_sm01_00015
end type
type rb_car from radiobutton within w_sm01_00015
end type
type rb_itnbr from radiobutton within w_sm01_00015
end type
type rr_1 from roundrectangle within w_sm01_00015
end type
type dw_1 from u_key_enter within w_sm01_00015
end type
type p_1 from uo_picture within w_sm01_00015
end type
type p_2 from uo_picture within w_sm01_00015
end type
type cb_1 from commandbutton within w_sm01_00015
end type
type st_2 from statictext within w_sm01_00015
end type
type cb_2 from commandbutton within w_sm01_00015
end type
end forward

global type w_sm01_00015 from w_inherite
integer width = 4645
integer height = 2476
string title = "월 판매계획 등록"
dw_temp dw_temp
st_at st_at
hpb_1 hpb_1
dw_save dw_save
rb_car rb_car
rb_itnbr rb_itnbr
rr_1 rr_1
dw_1 dw_1
p_1 p_1
p_2 p_2
cb_1 cb_1
st_2 st_2
cb_2 cb_2
end type
global w_sm01_00015 w_sm01_00015

forward prototypes
public function integer wf_danga (integer arg_row)
public subroutine wf_init ()
public function integer wf_mobis_as_add ()
end prototypes

public function integer wf_danga (integer arg_row);String sCvcod, sItnbr, stoday, sGiDate ,sCurr
Double	 dDanga
Long ll_rtn

If arg_row <= 0 Then Return 1

sToday	= f_today()
sGiDate	= dw_1.GetItemString(1, 'yymm')+'01'	// 단가기준일자
sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

dDanga = sqlca.fun_erp100000012_1(sGiDate, sCVCOD, sITNBR, '1') ;

If IsNull(dDanga) Then dDanga = 0

dw_insert.Setitem(arg_row, 'sprc', dDanga)

Return 0
end function

public subroutine wf_init ();If rb_car.Checked Then
	dw_1.DataObject = "d_sm01_00015_1"
	dw_insert.DataObject = "d_sm01_00015_a"
	
	//P_search.Visible = True
   //P_print.Visible = True
	//p_1.visible = False
	//p_2.visible = False  //ckd
	
Else
	dw_1.DataObject = "d_sm01_00015_2"
	dw_insert.DataObject = "d_sm01_00015_b"
	
	//P_search.Visible = False
	//P_print.Visible = False
	//p_1.visible = True
	//p_2.visible = True  //ckd
End iF

dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)
dw_1.Object.yymm[1] = Left(is_today,6)

/* User별 사업장 Setting Start */
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
		dw_1.Modify("saupj.background.color = 80859087")
   End if
End If
/* ---------------------- End  */

dw_1.SetColumn("cvcod")

Long ll_cnt
ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm01_monplan_dt
 where saupj = :gs_code
	and yymm = substr(:is_today,1,6)
	and wandate is not null;
If ll_cnt < 1 Then
	dw_1.Object.cust[1] = '1'
Else
	dw_1.Object.cust[1] = '2'
End If


	
end subroutine

public function integer wf_mobis_as_add ();String sYymm, ls_saupj
Long   ll_cnt=0 ,ll_containqty , ll_rcnt ,ll_rowcnt ,ll_f
Double ld_price
String ls_m0qty ,ls_m1qty ,ls_m2qty ,ls_m3qty , ls_m4qty

If dw_1.AcceptText() <> 1 Then Return -1

sYymm = trim(dw_1.getitemstring(1, 'yymm'))
ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'[계획년월]')
	Return -1
End If

setpointer(hourglass!)

w_mdi_frame.sle_msg.text ="MOBIS A/S 발주 추가중..."
//////////////////////////////////////////////////////////////////////////////////////////////////
// 1.기존자료 삭제
delete from sm01_monplan_dt
 where saupj = :ls_saupj and yymm = :sYymm and gubun = '2' ;
If sqlca.sqlcode <> 0 Then
	MessageBox('확인',sqlca.sqlerrText)
	Rollback ;
	Return -1
End If



//////////////////////////////////////////////////////////////////////////////////////////////////
// 2.MOBIS A/S 발주자료 추가
insert into sm01_monplan_dt
( 	saupj,         yymm,         cvcod,         itnbr,         carcode,       gubun,         sprc,
	s1qty,        	s2qty,         s3qty,         s4qty,         s5qty,         s6qty,
	mmqty,  			mmqty2,        mmqty3,       mmqty4,        mmqty5	)
select
	a.saupj		as saupj,
	a.yymm		as yymm,
	a.cvcod		as cvcod,
	a.itnbr		as itnbr,
	a.carcode	as carcode,
	a.gubun		as gubun,
	max(a.sprc)		as sprc,
	sum(a.s1qty)	as s1qty,
	sum(a.s2qty)	as s2qty,
	sum(a.s3qty)	as s3qty,
	sum(a.s4qty)	as s4qty,
	sum(a.s5qty)	as s5qty,
	sum(a.s6qty)	as s6qty,
	  sum(a.s1qty + a.s2qty + a.s3qty + a.s4qty + a.s5qty + a.s6qty) as mmqty,
	  sum(a.mmqty2)	as mmqty2,
	  sum(a.mmqty3)	as mmqty3,
	  sum(a.mmqty4)	as mmqty4,
	  sum(a.mmqty5)	as mmqty5
from (select
		saupj,
		:sYymm	as yymm,
		mcvcod		as cvcod,
		mitnbr		as itnbr,
		'.'			as carcode,
		'2'			as gubun, /* MOBIS AS 구분 */
		dlv_price	as sprc,
		decode(substr(due_date,1,6),:sYymm,fun_get_jucha(due_date),1,ord_qty,0) as s1qty,
		decode(substr(due_date,1,6),:sYymm,fun_get_jucha(due_date),2,ord_qty,0) as s2qty,
		decode(substr(due_date,1,6),:sYymm,fun_get_jucha(due_date),3,ord_qty,0) as s3qty,
		decode(substr(due_date,1,6),:sYymm,fun_get_jucha(due_date),4,ord_qty,0) as s4qty,
		decode(substr(due_date,1,6),:sYymm,fun_get_jucha(due_date),5,ord_qty,0) as s5qty,
		decode(substr(due_date,1,6),:sYymm,fun_get_jucha(due_date),6,ord_qty,0) as s6qty,
		decode(substr(due_date,1,6),to_char(add_months(to_date(:sYymm,'yyyymm'),1),'yyyymm'),ord_qty,0) as mmqty2,
		decode(substr(due_date,1,6),to_char(add_months(to_date(:sYymm,'yyyymm'),2),'yyyymm'),ord_qty,0) as mmqty3,
		decode(substr(due_date,1,6),to_char(add_months(to_date(:sYymm,'yyyymm'),3),'yyyymm'),ord_qty,0) as mmqty4,
		decode(substr(due_date,1,6),to_char(add_months(to_date(:sYymm,'yyyymm'),4),'yyyymm'),ord_qty,0) as mmqty5
	 from van_mobis_br
	 where saupj = :ls_saupj
		and due_date between :sYymm and to_char(add_months(to_date(:sYymm,'yyyymm'),4),'yyyymm')||'99'	) a
group by a.saupj, a.yymm, a.cvcod, a.itnbr, a.carcode, a.gubun ;

If sqlca.sqlcode <> 0 Then
	MessageBox('확인',sqlca.sqlerrText)
	Rollback ;
	Return -1
End If

Commit ;
	
return 1
end function

on w_sm01_00015.create
int iCurrent
call super::create
this.dw_temp=create dw_temp
this.st_at=create st_at
this.hpb_1=create hpb_1
this.dw_save=create dw_save
this.rb_car=create rb_car
this.rb_itnbr=create rb_itnbr
this.rr_1=create rr_1
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.cb_1=create cb_1
this.st_2=create st_2
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_temp
this.Control[iCurrent+2]=this.st_at
this.Control[iCurrent+3]=this.hpb_1
this.Control[iCurrent+4]=this.dw_save
this.Control[iCurrent+5]=this.rb_car
this.Control[iCurrent+6]=this.rb_itnbr
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.p_2
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.cb_2
end on

on w_sm01_00015.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_temp)
destroy(this.st_at)
destroy(this.hpb_1)
destroy(this.dw_save)
destroy(this.rb_car)
destroy(this.rb_itnbr)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.cb_2)
end on

event open;call super::open;dw_temp.SetTransObject(sqlca)
dw_save.SetTransObject(sqlca)

st_at.visible = False

hpb_1.visible = false

wf_init()
end event

type dw_insert from w_inherite`dw_insert within w_sm01_00015
integer x = 32
integer y = 348
integer width = 4553
integer height = 1936
integer taborder = 130
string dataobject = "d_sm01_00015_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;Dec 	 dQty, dAmt, dPrc, dmmqty, djucha, davg, dsum, dcha, dDayQty
Long   nRow, ix, dWorkMon, dWorkWeek
String sCol, sItnbr, sItdsc, siSpec, sjijil, sispec_code,s_cvcod, snull, get_nm, syymm, sDate, eDate, sFistCol
Int    ireturn, njucha
Long   ll_containqty
String ls_carcode

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

sCol = GetColumnName()
Choose Case GetColumnName()
	
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		Select ITDSC ,
		       CONTAINQTY ,
				 fun_get_carcode(:sitnbr) 
			Into :sitdsc ,
			     :ll_containqty ,
				  :ls_carcode
		  FROM ITEMAS
		 WHERE ITNBR = :sitnbr ;
		If sqlca.sqlcode <> 0 Then
			setitem(nrow, "itnbr", sNull)	
			setitem(nrow, "itdsc", sNull)	
			setitem(nrow, "containqty", sNull)	
			setitem(nrow, "carcode", sNull)	
			Return 1
		End If
		
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itdsc", sitdsc)
		setitem(nrow, "containqty", ll_containqty)
		setitem(nrow, "carcode", ls_carcode)	
		Post wf_danga(nrow)
		
		RETURN ireturn
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(nrow, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(nrow, 'cvnas', get_nm)
			
			Post wf_danga(nrow)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
End Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow , i , ll_i = 0
String sItnbr, sNull
str_code lst_code
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
SetNull(sNull)


nRow     = GetRow()
If nRow <= 0 Then Return

Choose Case GetcolumnName() 
		
	Case 'cvcod'
		
		gs_gubun = '1'

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(nRow, "cvcod", gs_Code)
		this.TriggerEvent("itemchanged")
		
	Case "itnbr"

		gs_code = Trim(Object.cvcod[nRow])
		gs_codename =Trim(Object.cvnas[nRow])
	
		If isNull(gs_code) or gs_code = '' Then 
			Messagebox('확인','거래처를 선택하세요.')
			Return
		End iF
		Open(w_sal_02000_vnddan)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_addrow.triggerevent("clicked")
			this.SetItem(i, "cvcod", gs_Code)
			this.SetItem(i, "cvnas", gs_Codename)
			
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next
	
END Choose


end event

event dw_insert::ue_pressenter;Dec dqty

/* 품번을 입력하면 수량으로 이동 */
If getcolumnname() = "mmqty"  then
	dQty = Dec(GetText())
	If IsNull(dQty) Or dQty = 0 Then
	Else
		SetColumn('mmqty2')
		Return 1
	End If
End If

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

event dw_insert::buttonclicked;call super::buttonclicked;
String ls_gubun

If dwo.name = "b_cal" Then
	If row < 1 Then Return
	gs_saupj = dw_1.object.saupj[1]
	gs_gubun = Trim(This.object.yymm[row])
	gs_code =  Trim(This.object.carcode[row])
	gs_codename =  Trim(This.object.itnbr[row])
	
	ls_gubun = Trim(This.object.gubun[row])
	
	If ls_gubun <> '1' Then
		MessageBox('확인','계산내역이 없습니다.')
		Return
	End If
	
	If gs_code = '.' or isNull(gs_code) or gs_code = '' Then
		MessageBox('확인','차종코드가 없습니다. 계산내역이 없습니다.')
		Return
	End If
	
	open(w_sm01_00015_popup)
	
end if
end event

type p_delrow from w_inherite`p_delrow within w_sm01_00015
integer x = 3922
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;Long i , ll_r , ll_cnt=0
String ls_new , ls_saupj , ls_cvcod , ls_itnbr, ls_carcode , ls_gubun ,ls_yymm

If dw_insert.AcceptText() <> 1 Then Return


ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_yymm  = trim(dw_1.getitemstring(1, 'yymm'))
ls_cvcod = trim(dw_1.getitemstring(1, 'cvcod'))

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	and wandate is not null;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다.  ')
	Return
End if

//If dw_insert.DataObject <> 'd_sm01_00015_b' Then
//	MessageBox('확 인','차종 계획은 삭제하실 수 없습니다.!!')
//	Return
//End If

If f_msg_delete() <> 1 Then	REturn

ll_r = dw_insert.Rowcount()

For i = ll_r To 1 Step -1

	If dw_insert.IsSelected(i) Then
		

		dw_insert.DeleteRow(i)
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('저장실패','저장실패')
		Return
	Else
		Commit;
		
		w_mdi_frame.sle_msg.text =String(ll_cnt)+'건의 삭제하였습니다.'
	End iF
End IF


end event

type p_addrow from w_inherite`p_addrow within w_sm01_00015
integer x = 3749
integer taborder = 50
end type

event p_addrow::clicked;
Long	 nRow, dMax ,ll_cnt 
String ls_saupj ,ls_yymm ,ls_cvcod

If dw_1.AcceptText() <> 1 Then REturn

ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_yymm  = trim(dw_1.getitemstring(1, 'yymm'))
ls_cvcod = trim(dw_1.getitemstring(1, 'cvcod'))

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	and wandate is not null;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다.   ')
	Return
End if


If dw_insert.DataObject <> 'd_sm01_00015_b' Then
	w_mdi_frame.sle_msg.text = '품번별 계획 상태에서만 추가등록이 가능합니다.!!'
	Return
End If

/* 사업장 체크 */
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')

	Return -1
End If

If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[년월]')
	dw_1.SetFocus()
	dw_1.SetColumn('yymm')
	Return
End If

If IsNull(ls_cvcod) Or ls_cvcod = '' Then
	f_message_chk(1400,'[거래처]')
	dw_1.SetFocus()
	dw_1.SetColumn('cvcod')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'saupj', ls_saupj)
dw_insert.SetItem(nRow, 'yymm', ls_yymm)
dw_insert.SetItem(nRow, 'cvcod', dw_1.GetItemString(1, 'cvcod'))
dw_insert.SetItem(nRow, 'cvnas', dw_1.GetItemString(1, 'cvnas'))
dw_insert.SetItem(nRow, 'gubun','2')  // 1. 계획 생산 2  . 기타 추가 3 .수출 
dw_insert.ScrollToRow(nRow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()
end event

type p_search from w_inherite`p_search within w_sm01_00015
boolean visible = false
integer x = 3086
integer taborder = 110
boolean enabled = false
string picturename = "C:\erpman\image\from_excel.gif"
end type

event p_search::ue_lbuttondown;//
end event

event p_search::ue_lbuttonup;//
end event

event p_search::clicked;cb_1.TriggerEvent('Clicked')
//String sYear, sCust, sCvcod, sToday , ls_saupj ,ls_factory , ls_sum , ls_carcode_pre = ''
//String ls_carcode ,ls_carcode2
//Long   ll_cnt=0  , ll_cnt2 ,ll_cnt3, ll_maxseq
//If dw_1.AcceptText() <> 1 Then Return
//
//sYear = trim(dw_1.getitemstring(1, 'yymm'))
//sCust = trim(dw_1.getitemstring(1, 'cust'))
//sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
//ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
//
//If IsNull(sYear) Or sYear = '' Then
//	f_message_chk(1400,'[계획년월]')
//	Return
//End If
//
//gs_code = sYear
//w_mdi_frame.sle_msg.text =""
//
//If trim(dw_1.getitemstring(1, 'cust')) <> '1' Then
//	MessageBox('확인','해당 월의 마감된 판매계획이 존재합니다. ')
//	
//	Return
//End If
//
//If rb_itnbr.checked Then
//	MessageBox('확인','차종 Checked 상태일때만 엑셀 파일 Import 가 가능합니다. ')
//	Return
//End if
//
//// 엘셀 IMPORT ***************************************************************
//uo_xlobject uo_xl
//string ls_docname, ls_named ,ls_line 
//Long   ll_FileNum ,ll_value
//String ls_gubun , ls_col ,ls_line_t , ls_data[]
//Long   ll_xl_row , ll_r , i 
//
//If dw_1.AcceptText() = -1 Then Return
//
//ls_gubun = 'H'
//
////If sCvcod <> 'S00100' Then 
////	MessageBox('확인','현대 자동차 VAN 만 사용 가능합니다.')
////	Return
////End If
//
//ll_value = GetFileOpenName("월간계획 VAN 데이타 가져오기", ls_docname, ls_named, & 
//             "XLS", "XLS Files (*.XLS),*.XLS,")
//
//If ll_value <> 1 Then Return
//
//dw_insert.Reset()
//
//Setpointer(Hourglass!)
// 
//ll_maxseq = 0 
//
//Select Max(seq) Into :ll_maxseq
//  From SM01_MONPLAN_CAR
// WHERE SAUPJ = :ls_saupj
//   AND YYMM = :sYear ;
//
//If isNull(ll_maxseq) or sqlca.sqlcode <> 0 Then
//	ll_maxseq = 0 ;
//end If
//
//// 기존 데이타 유무 체크 
////Select Count(*) Into :ll_cnt2
////  From SM01_MONPLAN_CAR
//// WHERE SAUPJ = :ls_saupj
////   AND YYMM = :sYear ;
////	
////If ll_cnt2 > 0 Then
////	If MessageBox('확인','기존자료가 존재합니다. 삭제 후 재생성 하시겠습니까? ',Exclamation!, OKCancel!, 2) = 2 Then
////		Return
////	Else
////		Delete From SM01_MONPLAN_CAR
////				 WHERE SAUPJ = :ls_saupj
////					AND YYMM = :sYear ;
////		If sqlca.sqlcode <> 0 Then
////			MessageBox('확인',sqlca.sqlerrText)
////			Rollback;
////			Return
////		End if
////	End if
////End if
//
//
//// 주차 가져오기 ==============================================================================
//String ls_end_date 
//Long   ll_jusu[],ll_jucnt=0 ,ll_su ,ll_m0_qty
//
//select TO_CHAR(LAST_DAY(:sYear||'01'),'yyyymmdd') Into :ls_end_date
//  from dual ;
//  
//ll_su = Long(Right(ls_end_date,2))
//
//select count(*) Into :ll_jucnt
//  from pdtweek where week_sdate like :sYear||'%' ;
//
//If ll_jucnt < 1 Then
//	MessageBox('확인','년간 주차 데이타가 없습니다. 년간 주차를 생성하세요')
//	Return
//End If
//
//For i = 1 To ll_jucnt
//
//	select week_edate - week_sdate + 1 Into :ll_jusu[i]
//	  from pdtweek 
//	 where week_sdate like :sYear||'%'
//		and mon_jucha = :i ;
//		
//Next
//
////===========================================================================================
////UserObject 생성
//uo_xl = create uo_xlobject
//		
////엑셀과 연결
//uo_xl.uf_excel_connect(ls_docname, false , 3)
//
//uo_xl.uf_selectsheet(1)
//
////If sYear <> Right(Trim(uo_xl.uf_gettext(4,2)),6) Then
////	MessageBox('확인','등록하신 기준년월이 파일의 년월과 일치하지 않습니다. 확인 후 등록하세요')
////	uo_xl.uf_excel_Disconnect()
////	Return
////End If
//
//dw_insert.object.t_mm.text = String(sYear,'@@@@.@@')+'월'
//
////Data 시작 Row Setting
//ll_xl_row =8
//ll_cnt = 0 
//ll_cnt3 = 1
//ls_factory = ' '
//Do While(True)
//	
//	//Data가 없을경우엔 Return...........
//	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
//	
//	ls_sum =     Trim(uo_xl.uf_gettext(ll_xl_row,16))	
//	If POS( ls_sum , '소계') > 0 Then
//		ll_xl_row++
//		continue ;
//	End if
//	
//	ls_carcode = Trim(uo_xl.uf_gettext(ll_xl_row,1)) 
//   
//	If ls_carcode_pre <> ls_carcode  Then
//		ll_cnt2 = 0 
//		Select count(*) Into :ll_cnt2 
//		  From sm01_monplan_car
//		 Where saupj = :ls_saupj
//			and yymm = :sYear
//			and seq like '%'
//			and carcode = :ls_carcode ;
//			
//		If ll_cnt2 > 0 Then
//			If MessageBox('확인',ls_carcode + ' 양산차종 코드는 이미 등록된 차종계획입니다. '+&
//			                                  '~n~r~n~rSKIP 후 계속 진행하시겠습니까?' , &
//														  Exclamation!, OKCancel!, 1) = 2 Then
//				uo_xl.uf_excel_Disconnect()
//				Return
//			End If
//			ll_xl_row++
//			ls_carcode_pre = ls_carcode
//			continue ;
//		End if
//	End IF
//	
//	If ll_cnt2 > 0 Then 
//		ll_xl_row++
//		ls_carcode_pre = ls_carcode
//		Continue ;
//	End If
//	
//	ls_carcode_pre = ls_carcode
//
//	ll_r = dw_insert.InsertRow(0) 
//	ll_cnt++
//
//	dw_insert.Scrolltorow(ll_r)
//	
//	
//	//사용자 ID(A,1)
//	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
//	For i =1 To 30
//		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
//		
//	Next
//	
//	ll_maxseq++
//	  
//	dw_insert.object.saupj[ll_r] =  ls_saupj
//	dw_insert.object.yymm[ll_r] =   sYear  
//	dw_insert.object.seq[ll_r] =    ll_maxseq
//	    
////	If ls_factory <> Trim(uo_xl.uf_gettext(ll_xl_row,3)) Then
////	   ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row,3))
////	  
////	   select nvl(RFNA2,'')
////		 into :sCvcod
////		 from reffpf
////	   where sabu = :gs_sabu and
////			   rfcod = '2A' and
////			   rfgub = :ls_factory;
////	
////	   If sCvcod = '' Or isNull(sCvcod) Then
////			messagebox('확인','등록된 참조코드의 공장코드가 없습니다.')
////			uo_xl.uf_excel_Disconnect()
////			Return
////		End iF
////	End iF
//
//	ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row,3))
//	  
//	dw_insert.object.s1[ll_r] =     ls_factory     
//	dw_insert.object.s2[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,4))    // 드라이브 
//	dw_insert.object.s3[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,8))    // 지역코드 
//	dw_insert.object.s4[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,10))   // 엔진코드 
//	dw_insert.object.s5[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,12))   // 연료 
//	dw_insert.object.s6[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,14))   //미션
//	
//	Select carcode Into :ls_carcode2
//	  from carhead
//	 Where ycarcode = :ls_carcode ;
//	 
//	If sqlca.sqlcode <> 0 Then
//		SetNull(ls_carcode2)
//	end if
//	 
//	dw_insert.object.s15[ll_r] =     ls_carcode2   //개발차종 
//	  
//
//	ll_m0_qty = Long( Dec(uo_xl.uf_gettext(ll_xl_row,19)))
//	  
//	If ll_m0_qty = 0 Then
//		dw_insert.object.s1qty[ll_r] = 0 
//		dw_insert.object.s2qty[ll_r] = 0 
//		dw_insert.object.s3qty[ll_r] = 0 
//		dw_insert.object.s4qty[ll_r] = 0 
//		dw_insert.object.s5qty[ll_r] = 0 
//		dw_insert.object.s6qty[ll_r] = 0 
//	Else
//		If ll_m0_qty * (ll_jusu[1]/ll_su) < 1 Then
//			dw_insert.object.s1qty[ll_r] = ll_m0_qty
//			dw_insert.object.s2qty[ll_r] = 0 
//			dw_insert.object.s3qty[ll_r] = 0 
//			dw_insert.object.s4qty[ll_r] = 0 
//			dw_insert.object.s5qty[ll_r] = 0 
//			dw_insert.object.s6qty[ll_r] = 0 
//		Else
//		  dw_insert.object.s1qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0)
//		  dw_insert.object.s2qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0)
//		  dw_insert.object.s3qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0)
//		  dw_insert.object.s4qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0)
//		 
//		  If ll_jucnt = 5 Then
//				dw_insert.object.s5qty[ll_r] =   ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) )
//				dw_insert.object.s6qty[ll_r] = 0
//				 
//		  Else
//				dw_insert.object.s5qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0)
//				dw_insert.object.s6qty[ll_r] =   ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) + &
//																			  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0) )
//		  End If
//		End If
//	End If
//	  
//	dw_insert.object.carcode[ll_r] =   ls_carcode
//	dw_insert.object.cvcod[ll_r] =    sCvcod 
//	dw_insert.object.gubun[ll_r] =    ls_gubun
//	dw_insert.object.mmqty[ll_r] =    ll_m0_qty
//	  
//	dw_insert.object.mmqty2[ll_r] =   Long( Dec(uo_xl.uf_gettext(ll_xl_row,21)))  
//	dw_insert.object.mmqty3[ll_r] =   Long( Dec(uo_xl.uf_gettext(ll_xl_row,23)))  
//	dw_insert.object.mmqty4[ll_r] =   Long( Dec(uo_xl.uf_gettext(ll_xl_row,25)))  
//	dw_insert.object.mmqty5[ll_r] =   Long( Dec(uo_xl.uf_gettext(ll_xl_row,27)))
//
//	ll_xl_row ++
//	
//Loop
//uo_xl.uf_excel_Disconnect()
//
//
//// 엘셀 IMPORT  END ***************************************************************
//
//dw_insert.AcceptText()
//
//If dw_insert.Update() < 1 Then
//	Rollback;
//	MessageBox('확인','저장실패')
//	Return
//Else
//	Commit;
//End If
//
//w_mdi_frame.sle_msg.text =String(ll_r)+'건의 월간계획 DATA IMPORT 를 완료하였습니다.'
//MessageBox('확인',String(ll_r)+'건의 월간계획 DATA IMPORT 를 완료하였습니다.')
//
//p_inq.TriggerEvent(Clicked!)
//
//Return
end event

type p_ins from w_inherite`p_ins within w_sm01_00015
boolean visible = false
integer x = 4064
integer y = 196
integer taborder = 30
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm01_00015
integer taborder = 100
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm01_00015
integer taborder = 90
end type

event p_can::clicked;call super::clicked;wf_init()

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sm01_00015
boolean visible = false
integer x = 3259
integer taborder = 120
boolean enabled = false
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

event p_print::clicked;String ls_saupj , ls_yymm , ls_cvcod
String ls_carcode ,ls_ycarcode , ls_itnbr , ls_mseq
String ls_car[] ,ls_ycar[], ls_item[1000,1000]
String ls_st_cvcod ,ls_s1 , ls_s2 , ls_s3 , ls_s4 ,ls_s5 , ls_s6 , ls_s7
String  ls_str1 , ls_str2 , ls_str3 , ls_str4 ,ls_str5 , ls_str6 , ls_str7
string old_select, new_select, where_clause ,ls_curr
String ls_op , ls_opstr
Long   i,j,k ,kk ,ll_cnt , ll_cnt2 ,ll_cnt3 , ll_f, ll_usage , ll_rcnt
Double w1_qty , w2_qty ,w3_qty ,w4_qty ,w5_qty , w6_qty
Double m1_qty , m2_qty ,m3_qty ,m4_qty ,m5_qty , ld_price , ld_rate
Long  ll_ycar_cnt 

Long  ll_maxseq

If dw_1.AcceptText() <> 1 Then REturn

ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_yymm  = trim(dw_1.getitemstring(1, 'yymm'))
ls_cvcod = trim(dw_1.getitemstring(1, 'cvcod'))

If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[계획년월]')
	Return
End If

If rb_itnbr.Checked Then 
	MessageBox('확인','차종별 계획 일때만 소요량 전개가 가능합니다.')
	Return
End If

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_car 
 where saupj = :ls_saupj
   and yymm = :ls_yymm 
	and seq like '%';
	
If ll_cnt < 1 Then
	MessageBox('확인', '해당월의 차종별 판매계획이 존재하지 않습니다 . ')
	Return
End if

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	and wandate is not null;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다. 재생성 불가능 합니다.  ')
	Return
End if

ll_cnt = 0 

select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm ;
	
If ll_cnt > 0 Then
	If MessageBox('확인', '해당월의 품번별 판매계획이 이미 존재합니다.  '+&
	                     "~n~r~n~r삭제 후 재생성 하시겠습니까? " , Question!, OKCancel!, 2) = 1 Then
		Delete From sm01_monplan_dt  
		      where saupj = :ls_saupj
              and yymm = :ls_yymm ;
		If sqlca.sqlcode <> 0 Then
			MessageBox('1',sqlca.sqlerrText)
		   Rollback ;
			Return
		End If
		
		Delete From SM01_MONPLAN_CALC  
		      where saupj = :ls_saupj
              and yymm = :ls_yymm ;
		If sqlca.sqlcode <> 0 Then
			MessageBox('2',sqlca.sqlerrText)
		   Rollback ;
			Return
		End If
		
	Else
		Return
	End if
	
End if

st_at.visible = True
st_at.Text = "데이타를 Loading 중입니다............."
ll_cnt = 0 
kk=0
Declare car_cnt Cursor For

select distinct s15 , carcode          /*개발차종을 가져온다. */
  from sm01_monplan_car 
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	and s15 is not null
	order by 1 ;
	
Declare itnbr_cnt Cursor For
   
//	select distinct a.itnbr 
//     from carbom a , itemas b , itnct c 
//    where a.itnbr = b.itnbr
//	  and b.ittyp = c.ittyp
//	  and b.itcls = c.itcls
//	  and c.porgu in ('ALL',:ls_saupj)
//	  and a.carcode = :ls_carcode 
// order by a.itnbr ;

//품목마스터에 USEYN(사용여부-0:사용, 1:사용중지, 2:단종)이 '0'(사용)인것만 계획생성 - 2006.10.12 by ShiNGooN
	select distinct a.itnbr 
     from carbom a 
    where a.carcode = :ls_carcode 
	   //추가--------------------------------------
		and not exists ( select 'x'
		                   from itemas b
								where b.itnbr = a.itnbr
								  and b.useyn <> '0' )
		//------------------------------------------
 order by a.itnbr ;
//-----------------------------------------------------------------------------------------------------------
Open car_cnt;

Do While True
	
	Fetch car_cnt Into :ls_carcode , :ls_ycarcode ;
	
	If SQLCA.SQLCODE <> 0 Then Exit
	ll_cnt++
	ls_car[ll_cnt] = ls_carcode 
	ls_ycar[ll_cnt] = ls_ycarcode 
	ll_cnt2 = 0 
	
	Open itnbr_cnt;
	
	Do While True
		Fetch itnbr_cnt Into :ls_itnbr ;
		
		If SQLCA.SQLCODE <> 0 Then Exit
		ll_cnt2++
	   ls_item[ll_cnt,ll_cnt2] = ls_itnbr
		kk++
		
	Loop

	Close itnbr_cnt;
	
Loop

Close car_cnt;

hpb_1.visible = True
hpb_1.maxposition =  100
hpb_1.setstep = 1
hpb_1.position = 0
k=0

dw_save.Reset()

For i=1 To UpperBound(ls_car)
	
//	ll_ycar_cnt = 0 
//	Select count(*) Into :ll_ycar_cnt
//	  From carhead 
//	 Where ycarcode is not null
//	   and ycarcode = :ls_car[i] ;
//		
//	If ll_ycar_cnt < 1 Then
//		If MessageBox('확인', ls_car[i]+" 양산차종은 등록되지 않은 차종 코드 입니다.    " + &
//		             "~n~r~n~r차종 별 소요량에서 해당 차종은 누락됩니다. 계속 진행하시겠습니까? " , &
//					     		 Exclamation!, OKCancel!, 2) = 2 Then 
//			rollback;
//			Return
//		Else
//			Continue ;
//		End if
//	End if
	
	For j= 1 To UpperBound(ls_item,2)
		If ls_item[i,j] = '' Or isNull(ls_item[i,j]) Then Continue ;
		k++
		st_at.Text = "차종 : "+ls_car[i]+" 품번 : "+ ls_item[i,j]
	
	//	dw_insert.object.s1[ll_r] =     ls_factory     
	//	dw_insert.object.s2[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,4))    // 드라이브 
	//	dw_insert.object.s3[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,8))    // 지역코드 
	//	dw_insert.object.s4[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,10))   // 엔진코드 
	//	dw_insert.object.s5[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,12))   // 연료 
	//	dw_insert.object.s6[ll_r] =     Trim(uo_xl.uf_gettext(ll_xl_row,14))   // 미션
	
	//	2B	0	차종-적용지역
	// 2C	0	차종-엔진
	// 2D	0	차종-연료
	// 2E	0	차종-미션
	// 2F	0	차종-드라이브
	// 2G	0	차종-내수/수출
	// 2H	0	차종-트림
	// 2J	0	차종-내장
	// 2K	0	차종-브레이크
	// 2L	0	차종-BODY
	// 2M	0	차종-파워핸들
	
		Declare carmst_cnt Cursor For

			select nvl(d.rfna2,c.cvcod) as cvcod       ,
					 nvl(a.cargbn1  ,'.')   ,    /* 공장 		 s1	   */
					 nvl(a.cargbn2  ,'.')   ,    /* 적용지역   s3	   */
					 nvl(a.cargbn3  ,'.')   ,    /* 엔진       s4		*/
					 nvl(a.cargbn4  ,'.')   ,    /* 연료   	 s5	   */
					 nvl(a.cargbn5  ,'.')   ,    /* 미션       s6		*/
				/*	 nvl(a.cargbn6  ,'.')   ,     안씀(미적용) */
				/*	 nvl(a.cargbn7  ,'.')   ,     내수/수출    */
					 nvl(b.usage ,1)        ,
					 nvl(b.yebid1,1)    ,
					 a.seq       
			  from carmst a ,
					 carbom b ,
					 carhead c ,
					 reffpf d
			 where a.carcode = c.carcode
				and a.carcode = b.carcode
				and a.seq = b.seq 
				and a.cargbn1 = d.rfgub(+)
				and d.rfcod(+) = '2A'
				and a.carcode =  :ls_car[i]
				and b.itnbr =  :ls_item[i,j];
  		
		
		Open carmst_cnt;
		
		Do While True
			
			Fetch carmst_cnt Into :ls_st_cvcod ,:ls_s1 ,:ls_s3 , :ls_s4 , :ls_s5 ,:ls_s6 , :ll_usage , :ld_rate ,:ls_mseq ;
			If SQLCA.SQLCODE <> 0 Then Exit
			
			// 공장적용 ======================================================
		  
//			If ls_s1 = '.' Then 
				ls_str1 = " s1 like '%' "
//			Else
//				select  fun_get_reffpf_value('1G',:ls_s1,'1'),
//	                 fun_get_reffpf_value('1G',:ls_s1,'2')
//					Into :ls_op , :ls_opstr
//	           from  dual ;
//				
//				If Upper(ls_op) = 'NOT' Then
//					ls_str1 = " s1 not in ( " + ls_opstr+ " ) "
//				Elseif Upper(ls_op) = 'OR' Then
//					ls_str1 = " s1 in ( " + ls_opstr+ " ) "
//				Else
//				  	ls_str1 = " s1 like '" + ls_s1+"'"
//				End IF
//				
//			End iF
			
			// 적용지역 ======================================================
			
			If ls_s3 = '.' Then 
				ls_str3 = " s3 like '%' "
			Else
				select  fun_get_reffpf_value('2B',:ls_s3,'1'),
	                 fun_get_reffpf_value('2B',:ls_s3,'2')
					Into :ls_op , :ls_opstr
	           from  dual ;
				
				If Upper(ls_op) = 'NOT' Then
					ls_str3 = " s3 not in ( " + ls_opstr+ " ) "
				Elseif Upper(ls_op) = 'OR' Then
					ls_str3 = " s3 in ( " + ls_opstr+ " ) "
				Else
				  	ls_str3 = " s3 like '" + ls_s3+"'"
				End IF
				
			End iF
						
			// 엔진   ======================================================
			
			If ls_s4 = '.' Then 
				ls_str4 = " s4 like '%' "
			Else
				ls_str4 = " s4 like '" + ls_s4 +"'"
			End iF
			
			// 연료   ======================================================
			
			If ls_s5 = '.' Then 
				ls_str5 = " s5 like '%' "
			Else
				ls_str5 = " s5 like '" + ls_s5 +"'"
				
			End iF
			
			// 미션   ======================================================
			
			If ls_s6 = '.' Then 
				ls_str6 = " s6 like '%' "
			Else
				select  fun_get_reffpf_value('2E',:ls_s6,'1'),
	                 fun_get_reffpf_value('2E',:ls_s6,'2')
					Into :ls_op , :ls_opstr
	           from  dual ;
				
				If Upper(ls_op) = 'NOT' Then
					ls_str6 = " s6 not in ( " + ls_opstr+ " ) "
				Elseif Upper(ls_op) = 'OR' Then
					ls_str6 = " s6 in ( " + ls_opstr+ " ) "
				Else
				  	ls_str6 = " s6 like '" + ls_s6 +"'"
				End IF
				
			End iF
	
			
			SetNull(old_select)
			SetNull(new_select)
			SetNull(where_clause)
			
			old_select = dw_temp.GetSQLSelect()
			
			where_clause = "WHERE SAUPJ = '"+ls_saupj+"'"+&
								"  AND YYMM  = '"+ls_yymm+"'"+&
								"  AND CARCODE = '"+ls_ycar[i]+"'"+&
								"  AND " + ls_str1 +&
								"  AND " + ls_str3 +&
								"  AND " + ls_str4 +&
								"  AND " + ls_str5 +&
								"  AND " + ls_str6 
			
			new_select = old_select + where_clause
		
			
			dw_temp.SetSQLSelect(new_select)
			
			If dw_temp.Retrieve() > 0 Then
				
				ld_price = sqlca.fun_erp100000012_1(is_today, ls_st_cvcod, ls_item[i,j] ,'1') ;
				
				If sqlca.sqlcode <> 0 or ld_price = 0 or isNull(ld_price) Then ld_price = 0 

				w1_qty = dw_temp.Object.w1[1]
				w2_qty = dw_temp.Object.w2[1]
				w3_qty = dw_temp.Object.w3[1]
				w4_qty = dw_temp.Object.w4[1]
				w5_qty = dw_temp.Object.w5[1]
				w6_qty = dw_temp.Object.w6[1]
				
				m1_qty = dw_temp.Object.m1[1]
				m2_qty = dw_temp.Object.m2[1]
				m3_qty = dw_temp.Object.m3[1]
				m4_qty = dw_temp.Object.m4[1]
				m5_qty = dw_temp.Object.m5[1]
				
				// 계산차수 생성 ==================
				Select max(seq) Into :ll_maxseq
				  From SM01_MONPLAN_CALC
				 Where saupj = :ls_saupj
					and yymm = :ls_yymm 
					and carcode = :ls_car[i] 
					and itnbr = :ls_item[i,j] ;
				
				If isNull( ll_maxseq ) Then
					ll_maxseq = 1
				else
					ll_maxseq = ll_maxseq + 1
				end if
				//=================================
				
				
				INSERT INTO SM01_MONPLAN_CALC (  SAUPJ  ,
															YYMM   ,
															SEQ    ,
															CARCODE,
															ITNBR  ,
															MSEQ   ,
															BUSAGE  ,
															BRATE ,
															WMMQTY ,
															W1QTY  ,
															W2QTY  ,
															W3QTY  ,
															W4QTY  ,
															W5QTY  ,
															W6QTY  ,
															S1QTY  ,
															S2QTY  ,
															S3QTY  ,
															S4QTY  ,
															S5QTY  ,
															S6QTY  ,
															MMQTY  ,
															MMQTY2 ,
															MMQTY3 ,
															MMQTY4 ,
															MMQTY5 )
												VALUES ( :ls_saupj ,
												         :ls_yymm ,
															:ll_maxseq ,
															:ls_car[i] ,
															:ls_item[i,j] ,
                                             :ls_mseq ,
															:ll_usage ,
															:ld_rate ,
															:m1_qty ,
															:w1_qty ,
															:w2_qty ,
															:w3_qty ,
															:w4_qty ,
															:w5_qty ,
															:w6_qty ,
															:w1_qty * :ll_usage * :ld_rate,
															:w2_qty * :ll_usage * :ld_rate,
															:w3_qty * :ll_usage * :ld_rate,
															:w4_qty * :ll_usage * :ld_rate,
															:w5_qty * :ll_usage * :ld_rate,
															:w6_qty * :ll_usage * :ld_rate,
															:m1_qty * :ll_usage * :ld_rate,
															:m2_qty * :ll_usage * :ld_rate,
															:m3_qty * :ll_usage * :ld_rate,
															:m4_qty * :ll_usage * :ld_rate,
															:m5_qty * :ll_usage * :ld_rate) ;
				If sqlca.sqlnrows = 0 Then
					MessageBox('' , sqlca.sqlerrText )							
					Rollback ;
					MessageBox('확인','저장 실패')
					Return
				End if
															
					
				ll_f = dw_save.Find(" saupj = '"+ls_saupj+"' and yymm = '"+ls_yymm+"' and cvcod = '"+ls_st_cvcod+"' and carcode ='"+ls_car[i]+"'"+&
				                    " and itnbr = '"+ls_item[i,j]+"' and gubun = '1' " , 1 ,dw_save.Rowcount() )
			
									
				If ll_f > 0 Then
					
					dw_save.Object.sprc[ll_f] =  ld_price
					dw_save.Object.s1qty[ll_f] = dw_save.Object.s1qty[ll_f] + (w1_qty * ll_usage * ld_rate)
					dw_save.Object.s2qty[ll_f] = dw_save.Object.s2qty[ll_f] + (w2_qty* ll_usage * ld_rate)
					dw_save.Object.s3qty[ll_f] = dw_save.Object.s3qty[ll_f] + (w3_qty* ll_usage * ld_rate)
					dw_save.Object.s4qty[ll_f] = dw_save.Object.s4qty[ll_f] + (w4_qty* ll_usage * ld_rate)
					dw_save.Object.s5qty[ll_f] = dw_save.Object.s5qty[ll_f] + (w5_qty* ll_usage * ld_rate)
					dw_save.Object.s6qty[ll_f] = dw_save.Object.s6qty[ll_f] + (w6_qty* ll_usage * ld_rate)
					
					dw_save.Object.mmqty[ll_f]  = dw_save.Object.mmqty[ll_f] +  (m1_qty* ll_usage * ld_rate)
					dw_save.Object.mmqty2[ll_f] = dw_save.Object.mmqty2[ll_f] + (m2_qty* ll_usage * ld_rate)
					dw_save.Object.mmqty3[ll_f] = dw_save.Object.mmqty3[ll_f] + (m3_qty* ll_usage * ld_rate)
					dw_save.Object.mmqty4[ll_f] = dw_save.Object.mmqty4[ll_f] + (m4_qty* ll_usage * ld_rate)
					dw_save.Object.mmqty5[ll_f] = dw_save.Object.mmqty5[ll_f] + (m5_qty* ll_usage * ld_rate)
					
				Else
					
					ll_cnt3 = dw_save.InsertRow(0)
					
					dw_save.Object.saupj[ll_cnt3] = ls_saupj
					dw_save.Object.yymm[ll_cnt3] = ls_yymm
					dw_save.Object.cvcod[ll_cnt3] = ls_st_cvcod
					dw_save.Object.carcode[ll_cnt3] = ls_car[i]
					dw_save.Object.itnbr[ll_cnt3] = ls_item[i,j]
					dw_save.Object.gubun[ll_cnt3] = '1'
					dw_save.Object.sprc[ll_cnt3] = ld_price
					dw_save.Object.s1qty[ll_cnt3] = (w1_qty* ll_usage* ld_rate)
					dw_save.Object.s2qty[ll_cnt3] = (w2_qty* ll_usage* ld_rate)
					dw_save.Object.s4qty[ll_cnt3] = (w4_qty* ll_usage* ld_rate)
					dw_save.Object.s3qty[ll_cnt3] = (w3_qty* ll_usage* ld_rate)
					dw_save.Object.s5qty[ll_cnt3] = (w5_qty* ll_usage* ld_rate)
					dw_save.Object.s6qty[ll_cnt3] = (w6_qty* ll_usage* ld_rate)
					
					dw_save.Object.mmqty[ll_cnt3] =  (m1_qty* ll_usage* ld_rate)
					dw_save.Object.mmqty2[ll_cnt3] = (m2_qty* ll_usage* ld_rate)
					dw_save.Object.mmqty3[ll_cnt3] = (m3_qty* ll_usage* ld_rate)
					dw_save.Object.mmqty4[ll_cnt3] = (m4_qty* ll_usage* ld_rate)
					dw_save.Object.mmqty5[ll_cnt3] = (m5_qty* ll_usage* ld_rate)
					
				End If
				
			End If
			
			dw_temp.SetSQLSelect(old_select)

			
		Loop
		

		Close carmst_cnt;
		Yield()
		hpb_1.position = int((k/kk)*100)
	Next

Next

dw_save.AcceptText()

ll_rcnt =dw_save.RowCount()
For i =ll_rcnt To 1 Step -1
	
	If dw_save.Object.mmqty[i] <= 0 Then
		dw_save.DeleteRow(i)
	End iF
Next

If dw_save.Update() < 1 Then
	MessageBox('' , sqlca.sqlerrText )
	Rollback ;
	MessageBox('확인','저장 실패')
	Return
Else
	// 비율 적용 ====================
	/*
	  UPDATE SM01_MONPLAN_DT SET  S1QTY =  CEIL(S1QTY * FUN_GET_CAR_SCHRATE(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR))   ,
											 S2QTY = CEIL(S2QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 S3QTY = CEIL(S3QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 S4QTY = CEIL(S4QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 S5QTY = CEIL(S5QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 S6QTY = CEIL(S6QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 MMQTY = CEIL(S1QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) +
														CEIL(S2QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) +
														CEIL(S3QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) +
														CEIL(S4QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) +
														CEIL(S5QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) +
											         CEIL(S6QTY * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR))  ,
											 MMQTY2 = CEIL(MMQTY2 * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 MMQTY3 = CEIL(MMQTY3 * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 MMQTY4 = CEIL(MMQTY4 * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) ,
											 MMQTY5 = CEIL(MMQTY5 * fun_get_car_schrate(SAUPJ,FUN_GET_REFFPF_RFGUB('01',CARCODE,'4'),ITNBR)) 
								WHERE SAUPJ = :ls_saupj
								  AND YYMM = :ls_yymm
								  AND GUBUN = '1' ;
	If sqlca.sqlcode <> 0 Then
		MessageBox('확인',sqlca.sqlerrtext)
		Rollback;
		Return

   End If
	
	Commit;
	
	*/
	
	rb_itnbr.Checked = True
	wf_init()
	
	dw_1.object.yymm[1] = ls_yymm
	
	// MOBIS A/S 발주 추가 - 2006.12.04 - 송병호 
	wf_mobis_as_add()	
	p_inq.TriggerEvent(Clicked!)

End IF

st_at.visible = False
hpb_1.visible = False

MessageBox('확 인', '소요량 계산이 완료되었습니다.!!')
end event

type p_inq from w_inherite`p_inq within w_sm01_00015
integer x = 3575
end type

event p_inq::clicked;String ls_saupj , ls_yymm , ls_cvcod , ls_carcode ,ls_itnbr


If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ls_yymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[계획년월]')
	Return
End If

ls_cvcod   = trim(dw_1.getitemstring(1, 'cvcod'))
ls_carcode = trim(dw_1.getitemstring(1, 'carcode'))

If ls_cvcod = '' Or isNull(ls_cvcod) Then 
	ls_cvcod = '%'
Else
	ls_cvcod = ls_cvcod+'%'
End If

If ls_carcode = '' Or isNull(ls_carcode) Then ls_carcode = '%' 
		
If rb_car.Checked Then
	
	If dw_insert.Retrieve(ls_saupj, ls_yymm,ls_cvcod , ls_carcode ) <= 0 Then
		f_message_chk(50,'')
	End If
Else

	ls_itnbr   = trim(dw_1.getitemstring(1, 'itnbr'))
	If ls_itnbr = '' Or isNull(ls_itnbr) Then 
		ls_itnbr = '%'
	Else
		ls_itnbr = ls_itnbr+'%'
	End If
	

	If dw_insert.Retrieve(ls_saupj, ls_yymm,ls_cvcod , ls_carcode , ls_itnbr) <= 0 Then
		f_message_chk(50,'')
	End If	
End If 


/* 월 셋팅 */
dw_insert.object.t_mm.text = String(ls_yymm,'@@@@.@@')+'월'


end event

type p_del from w_inherite`p_del within w_sm01_00015
boolean visible = false
integer x = 3881
integer y = 204
integer taborder = 80
boolean enabled = false
end type

event p_del::clicked;Long nRow, ix
String sCust, sCvcod, sItnbr, sItdsc, tx_name, sCargbn1, sCargbn2, sYear
String sSaupj

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

scust = Trim(dw_1.GetItemString(1, 'cust'))
sYear = Trim(dw_1.GetItemString(1, 'yymm'))
tx_name = Trim(dw_1.Describe("Evaluate('LookUpDisplay(cust) ', 1)"))
sCargbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCargbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

IF MessageBox("확인", '고객구분 ' + tx_name + ' 의 자료를 삭제합니다. ~r~n~r~n계속하시겠습니까?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

dw_insert.RowsMove(1, dw_insert.RowCount(), Primary!, dw_insert, 1, Delete!)

If dw_insert.Update() <> 1 Then
	RollBack;
	f_message_chk(31,'')
	Return
End If

// 차종별 계획인 경우
If dw_insert.DataObject = 'd_sm00_00010_2' Then
/* 기존자료 삭제 - 차종,기종 */
	DELETE FROM "SM01_YEARPLAN"
		WHERE SABU = :gs_sabu 
		  AND YYYY = :sYear
		  AND GUBUN = :sCargbn1||:sCargbn2
		  AND SAUPJ = :sSaupj;
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
		RollBack;
		Return
	End If
End If

Commit;

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sm01_00015
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Long ix, nRow
String ls_new , ls_saupj , ls_cvcod , ls_itnbr, ls_carcode , ls_gubun ,ls_yymm

If dw_insert.AcceptText() <> 1 Then Return
If dw_insert.RowCount() <= 0 Then Return

/* 품목별 계획일 경우 체크 */

If dw_insert.DataObject = 'd_sm01_00015_b' Then
	
	If trim(dw_1.getitemstring(1, 'cust')) <> '1' Then
		MessageBox('확인','해당 월의 마감된 판매계획이 존재합니다. 추가 저장 불가능 합니다. ')
		Return
	End If

	nRow = dw_insert.RowCount()
	For ix = nRow To 1 Step -1
		
		ls_saupj = Trim(dw_insert.Object.saupj[ix])
		ls_cvcod = Trim(dw_insert.Object.cvcod[ix])
		ls_yymm =  Trim(dw_insert.Object.yymm[ix])
		ls_itnbr  =  Trim(dw_insert.Object.itnbr[ix])
		ls_gubun  =  Trim(dw_insert.Object.gubun[ix])
		ls_carcode = Trim(dw_insert.Object.carcode[ix])
		
		If IsNull(ls_cvcod) Or ls_cvcod = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		If IsNull(ls_carcode) Or ls_carcode = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		If IsNull(ls_itnbr) Or ls_itnbr = '' Then
			dw_insert.DeleteRow(ix)
			continue
		End If
		
		dw_insert.Object.mmqty[ix] = dw_insert.Object.mmqty_com[ix]
		
		If ls_new = 'Y' Then
			dw_insert.Object.gubun[ix] = '2'
		End If
	   
	Next
Else
	nRow = dw_insert.RowCount()
	For ix = nRow To 1 Step -1
	
	  	dw_insert.Object.mmqty[ix] = dw_insert.Object.mmqty_com[ix]
	
	Next
End If

dw_insert.AcceptText()

If dw_insert.RowCount() > 0 Then
	If dw_insert.Update() <> 1 Then
		MessageBox(String(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If

	COMMIT;
	
	MessageBox('확 인','저장하였습니다')
Else
	MessageBox('확 인','저장할 자료가 없습니다.!!')
End If

ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_sm01_00015
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm01_00015
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm01_00015
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm01_00015
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm01_00015
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm01_00015
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm01_00015
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm01_00015
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm01_00015
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm01_00015
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm01_00015
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm01_00015
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm01_00015
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_00015
boolean visible = true
end type

type dw_temp from datawindow within w_sm01_00015
boolean visible = false
integer x = 2441
integer y = 508
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00015_sumqty"
boolean border = false
boolean livescroll = true
end type

type st_at from statictext within w_sm01_00015
integer x = 1568
integer y = 952
integer width = 1559
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_sm01_00015
integer x = 1568
integer y = 872
integer width = 1554
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type dw_save from datawindow within w_sm01_00015
boolean visible = false
integer x = 2053
integer y = 1224
integer width = 2510
integer height = 1000
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_sm01_00015_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type rb_car from radiobutton within w_sm01_00015
boolean visible = false
integer x = 2231
integer y = 48
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차종"
end type

event clicked;wf_init()
end event

type rb_itnbr from radiobutton within w_sm01_00015
boolean visible = false
integer x = 2537
integer y = 48
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품번"
boolean checked = true
end type

event clicked;wf_init()
end event

type rr_1 from roundrectangle within w_sm01_00015
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 340
integer width = 4585
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_sm01_00015
integer x = 18
integer y = 16
integer width = 3067
integer height = 252
integer taborder = 20
string dataobject = "d_sm01_00015_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;String s_cvcod, snull, get_nm, sItem, sCust, sDate
Long   nCnt
String sSaupj

SetNull(sNull)

If dw_1.AcceptText() <> 1 Then Return

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

Choose Case GetColumnName()
	Case 'cvcod'
		s_cvcod = this.GetText()								
		 
		if s_cvcod = "" or isnull(s_cvcod) then 
			this.setitem(1, 'cvnas', snull)
			return 
		end if
		
		SELECT "VNDMST"."CVNAS"  
		  INTO :get_nm  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_cvcod  ;
	
		if sqlca.sqlcode = 0 then 
			this.setitem(1, 'cvnas', get_nm)
		else
			this.triggerevent(RbuttonDown!)
			return 1
		end if
	
	Case 'item'
		sItem = GetText()
		
	Case 'yymm'
		sDate = Left(GetText(),6)
		
		If f_datechk(sDate+'01') <> 1 Then
			f_message_chk(35,'')
			return 1
		Else
			dw_insert.Reset()
			
			SELECT COUNT(*) INTO :nCnt FROM SM01_MONPLAN_DT WHERE SAUPJ = :sSaupj AND YYMM = :sDate AND WANDATE IS NOT NULL;
			
			If nCnt > 0 Then
				Object.cust[1] = '2'
				MessageBox('확 인','월판매계획이 마감처리 되어있습니다.!!')
				p_search.Enabled = False
				p_print.Enabled = False
				p_mod.Enabled = False
				p_addrow.Enabled = False
				p_delrow.Enabled = False
				p_del.Enabled = False
				p_search.PictureName = 'C:\erpman\image\from_excel.gif'
				p_print.PictureName = 'C:\erpman\image\소요량계산_d.gif'
				p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
				p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
				p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
				p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
				
				Return 1
			
			Else
				Object.cust[1] = '1'
				p_search.Enabled = True
				p_print.Enabled = True
				p_mod.Enabled = True
				p_addrow.Enabled = True
				p_delrow.Enabled = True
				p_del.Enabled = True
				p_search.PictureName = 'C:\erpman\image\from_excel.gif'
				p_print.PictureName = 'C:\erpman\image\소요량계산_up.gif'
				p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
				p_addrow.PictureName = 'C:\erpman\image\행추가_up.gif'
				p_delrow.PictureName = 'C:\erpman\image\행삭제_up.gif'
				p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
			End If
		End If
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;long lrow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

lrow = this.GetRow()
Choose Case GetcolumnName() 
	Case 'cvcod'
		gs_code = GetText()
		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(lrow, "cvcod", gs_Code)
		SetItem(lrow, "cvnas", gs_Codename)
End Choose
end event

event ue_pressenter;//

Choose Case This.GetColumnName()
	Case 'itnbr'
		p_inq.TriggerEvent(Clicked!)
		Return 1
End Choose

Send(Handle(this),256,9,0)
Return 1
end event

type p_1 from uo_picture within w_sm01_00015
boolean visible = false
integer x = 3255
integer y = 24
integer width = 315
boolean enabled = false
string picturename = "C:\erpman\image\용기량적용_up.gif"
end type

event clicked;call super::clicked;Long i, nRow 
Long ll_conqty ,ll_s1qty , ll_s2qty , ll_s3qty, ll_s4qty, ll_s5qty, ll_s6qty
Long ll_mmqty , ll_mmqty2 , ll_mmqty3, ll_mmqty4, ll_mmqty5
String ls_new , ls_saupj , ls_cvcod , ls_itnbr, ls_carcode , ls_gubun ,ls_yymm

/* 품목별 계획일 경우 체크 */

If trim(dw_1.getitemstring(1, 'cust')) <> '1' Then
	MessageBox('확인','해당 월의 마감된 판매계획이 존재합니다. ')
	Return
End If

If dw_1.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return
/* 사업장 체크 */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

ls_yymm = trim(dw_1.getitemstring(1, 'yymm'))
If IsNull(ls_yymm) Or ls_yymm = '' Then
	f_message_chk(1400,'[계획년월]')
	Return
End If

If dw_insert.DataObject = 'd_sm01_00015_b' Then
	
	If dw_insert.Retrieve(ls_saupj, ls_yymm, '%' , '%' , '%') < 1 Then
		MessageBox('확인','소요량 전개된 수량이 존재하지 않습니다.')
		Return
	End IF
	
	If dw_insert.AcceptText() <> 1 Then Return
	If dw_insert.RowCount() <= 0 Then Return
	nRow = dw_insert.RowCount()
	For i = nRow To 1 Step -1
		
		ll_conqty = dw_insert.Object.containqty[i]
		
		If ll_conqty <= 0 Then Continue ; 
		
		ll_s1qty = dw_insert.Object.s1qty[i]
		ll_s2qty = dw_insert.Object.s2qty[i]
		ll_s3qty = dw_insert.Object.s3qty[i]
		ll_s4qty = dw_insert.Object.s4qty[i]
		ll_s5qty = dw_insert.Object.s5qty[i]
		ll_s6qty = dw_insert.Object.s6qty[i]
		
		ll_mmqty2 = dw_insert.Object.mmqty2[i]
		ll_mmqty3 = dw_insert.Object.mmqty3[i]
		ll_mmqty4 = dw_insert.Object.mmqty4[i]
		ll_mmqty5 = dw_insert.Object.mmqty5[i]
		
		//messagebox(string(i) , ll_conqty)
		
		If mod(ll_s1qty,ll_conqty) = 0 Then
			dw_insert.Object.s1qty[i] = ll_s1qty
		Else
			dw_insert.Object.s1qty[i] = Truncate(ll_s1qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s2qty,ll_conqty) = 0 Then
			dw_insert.Object.s2qty[i] = ll_s2qty
		Else
			dw_insert.Object.s2qty[i] = Truncate(ll_s2qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s3qty,ll_conqty) = 0 Then
			dw_insert.Object.s3qty[i] = ll_s3qty
		Else
			dw_insert.Object.s3qty[i] = Truncate(ll_s3qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s4qty,ll_conqty) = 0 Then
			dw_insert.Object.s4qty[i] = ll_s4qty
		Else
			dw_insert.Object.s4qty[i] = Truncate(ll_s4qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s5qty,ll_conqty) = 0 Then
			dw_insert.Object.s5qty[i] = ll_s5qty
		Else
			dw_insert.Object.s5qty[i] = Truncate(ll_s5qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_s6qty,ll_conqty) = 0 Then
			dw_insert.Object.s6qty[i] = ll_s6qty
		Else
			dw_insert.Object.s6qty[i] = Truncate(ll_s6qty/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty2,ll_conqty) = 0 Then
			dw_insert.Object.mmqty2[i] = ll_mmqty2
		Else
			dw_insert.Object.mmqty2[i] = Truncate(ll_mmqty2/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty3,ll_conqty) = 0 Then
			dw_insert.Object.mmqty3[i] = ll_mmqty3
		Else
			dw_insert.Object.mmqty3[i] = Truncate(ll_mmqty3/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty4,ll_conqty) = 0 Then
			dw_insert.Object.mmqty4[i] = ll_mmqty4
		Else
			dw_insert.Object.mmqty4[i] = Truncate(ll_mmqty4/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		If mod(ll_mmqty5,ll_conqty) = 0 Then
			dw_insert.Object.mmqty5[i] = ll_mmqty5
		Else
			dw_insert.Object.mmqty5[i] = Truncate(ll_mmqty5/ll_conqty,0) * ll_conqty + ll_conqty
		End If
		
		
	Next
	
	messagebox('확인','용기적입량 적용완료 하였습니다.')

End If



ib_any_typing = false
end event

type p_2 from uo_picture within w_sm01_00015
boolean visible = false
integer x = 3086
integer y = 24
integer width = 178
boolean enabled = false
string picturename = "C:\erpman\image\CKD입력_up.gif"
end type

event clicked;call super::clicked;String sYear, sCust, sCvcod, sToday , ls_saupj ,ls_factory ,ls_itnbr ,ls_itdsc ,ls_itnbr_t,ls_curr ,ls_cvnas
Long   ll_cnt=0 ,ll_containqty , ll_rcnt ,ll_rowcnt ,ll_f
Double ld_price
String ls_m0qty ,ls_m1qty ,ls_m2qty ,ls_m3qty , ls_m4qty

If dw_1.AcceptText() <> 1 Then Return

sYear = trim(dw_1.getitemstring(1, 'yymm'))
sCust = trim(dw_1.getitemstring(1, 'cust'))
sCvcod = trim(dw_1.getitemstring(1, 'cvcod'))
ls_saupj = trim(dw_1.getitemstring(1, 'saupj'))
ls_cvnas = trim(dw_1.getitemstring(1, 'cvnas'))

If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400,'[계획년월]')
	Return
End If

//If IsNull(sCvcod) Or sCvcod = '' Then
//	f_message_chk(1400,'[거래처]')
//	dw_1.SetFocus()
//	dw_1.SetColumn("cvcod")
//	Return
//End If

gs_code = sYear
w_mdi_frame.sle_msg.text =""

If rb_car.checked Then
	MessageBox('확인','품번 Checked 상태일때만 엑셀 파일 Import 가 가능합니다. ')
	Return
End if

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_car 
 where saupj = :ls_saupj
   and yymm = :sYear ;
	
If ll_cnt < 1 Then
	MessageBox('확인', '해당월의 차종별 판매계획이 존재하지 않습니다 . ')
	Return
End if

ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :sYear
	and wandate is not null;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 품번별 판매계획이 이미 확정 마감되었습니다.  ')
	Return
End if


ll_cnt = 0 
select count(*) into :ll_cnt 
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :sYear 
	and gubun = '3' ;
	
If ll_cnt > 0 Then
	MessageBox('확인', '해당월의 CKD 판매계획이 이미 적용한 상태입니다. '+&
	                   '~n~r~n~r추가 적용할 경우 전체 소요량 계산 후 다시 적용하세요.  ')
	Return
End if


// 엘셀 IMPORT ***************************************************************
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line 
Long   ll_FileNum ,ll_value
String ls_gubun , ls_col ,ls_line_t , ls_data[]
Long   ll_xl_row , ll_r , i 

If dw_1.AcceptText() = -1 Then Return


ll_value = GetFileOpenName("월간계획 CKD 데이타 가져오기", ls_docname, ls_named, & 
             "XLS", "XLS Files (*.XLS),*.XLS,")

If ll_value <> 1 Then Return

If sCvcod = '' or isNull(sCvcod) Then
	select fun_get_reffpf_value('2A','Y','1') , fun_get_cvnas(fun_get_reffpf_value('2A','Y','1')) 
	  into :sCvcod , :ls_cvnas 
	 From dual ;
End If

ll_rcnt = dw_insert.Retrieve(ls_saupj, sYear,sCvcod , '%' , '%')

Setpointer(Hourglass!)

// 주차 가져오기 ==============================================================================
String ls_end_date 
Long   ll_jusu[],ll_jucnt=0 ,ll_su ,ll_m0_qty

select TO_CHAR(LAST_DAY(:sYear||'01'),'yyyymmdd') Into :ls_end_date
  from dual ;
  
ll_su = Long(Right(ls_end_date,2))

select count(*) Into :ll_jucnt
  from pdtweek where week_sdate like :sYear||'%' ;

If ll_jucnt < 1 Then
	MessageBox('확인','년간 주차 데이타가 없습니다. 년간 주차를 생성하세요')
	Return
End If

For i = 1 To ll_jucnt

	select week_edate - week_sdate + 1 Into :ll_jusu[i]
	  from pdtweek 
	 where week_sdate like :sYear||'%'
		and mon_jucha = :i ;
		
Next

//===========================================================================================

//===========================================================================================
//UserObject 생성
uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, false , 3)

uo_xl.uf_selectsheet(1)

If sYear <> Trim(uo_xl.uf_gettext(2,6)) Then
	MessageBox('확인','등록하신 기준년월이 파일의 년월과 일치하지 않습니다. 확인 후 등록하세요')
	uo_xl.uf_excel_Disconnect()
	Return
End If

//Data 시작 Row Setting
ll_xl_row =4
ll_cnt = 0 
ls_factory = 'Y'

Do While(True)
	
	//Data가 없을경우엔 Return...........
	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit

	//사용자 ID(A,1)
	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i =1 To 20
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
	Next
	
	ll_cnt++
	
	  ls_m0qty =Trim(uo_xl.uf_gettext(ll_xl_row,6))
	  //messagebox(string(len(ls_m0qty)),ls_m0qty)
//     ls_m0qty = Mid(ls_m0qty , 1,len(ls_m0qty)-1)  // 특수문자 있음  ?
  
     If isNull(ls_m0qty) Then ls_m0qty = '0'
  
     ll_m0_qty = Long( Dec(ls_m0qty))
	  
	  ls_m1qty =Trim(uo_xl.uf_gettext(ll_xl_row,7))
	  ls_m2qty =Trim(uo_xl.uf_gettext(ll_xl_row,8))
	  ls_m3qty =Trim(uo_xl.uf_gettext(ll_xl_row,9))
	  ls_m4qty =Trim(uo_xl.uf_gettext(ll_xl_row,10))
	  
//	  ls_m1qty = Mid(ls_m1qty , 1,len(ls_m1qty)-1)  // 특수문자 있음  ?
//	  ls_m2qty = Mid(ls_m2qty , 1,len(ls_m2qty)-1)  // 특수문자 있음  ?
//	  ls_m3qty = Mid(ls_m3qty , 1,len(ls_m3qty)-1)  // 특수문자 있음  ?
//	  ls_m4qty = Mid(ls_m4qty , 1,len(ls_m4qty)-1)  // 특수문자 있음  ?
	  
     If isNull(ls_m1qty) Then ls_m1qty = '0'
	  If isNull(ls_m2qty) Then ls_m2qty = '0'
	  If isNull(ls_m3qty) Then ls_m3qty = '0'
	  If isNull(ls_m4qty) Then ls_m4qty = '0'
	  
	  If Long( Dec(ls_m0qty)) + Long( Dec(ls_m1qty)) +Long( Dec(ls_m2qty)) +Long( Dec(ls_m3qty)) +Long( Dec(ls_m4qty)) <= 0 Then 
			ll_xl_row ++
			Continue 
		End If
		
				  
	  ls_itnbr_t = trim(uo_xl.uf_gettext(ll_xl_row,1))
	  
	  Select MAX(a.itnbr) , MAX(fun_get_itdsc(a.itnbr)) , MAX(a.containqty)
		 Into :ls_itnbr , :ls_itdsc , :ll_containqty
		 From vndmrp a, reffpf b
		where a.cvcod = b.rfna2
		  and b.rfcod = '2A'
		  and b.rfgub IN ('Y', 'L1', 'L2', 'L3', 'C1', 'C2', 'C3', 'C4') /* CKD공장 */
		  and (Replace(a.itnbr,'-','') = Replace(:ls_itnbr_t,' ','') OR
		       Replace(a.itnbr,'-','') = Replace(:ls_itnbr_t,'-','')) ; 
	  
	  If sqlca.sqlcode <> 0 OR Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then 
		  ll_xl_row ++
		  Continue
	  End If
////			MessageBox('확인','거래처 품번정보에 품번이 미등록 항목입니다.')
//			MessageBox('확인','거래처 품번정보에 품번이 미등록 항목입니다.~r~n~n' + ls_itnbr_t)
//			uo_xl.uf_excel_Disconnect()
//			Return
//		End iF
		
	  ll_f = dw_insert.Find("saupj = '"+ls_saupj+"' and cvcod='"+sCvcod+"' and yymm='"+sYear+"' and "+&
	                        "itnbr = '"+ls_itnbr+"' and carcode ='.' and gubun='3' " , 1 ,dw_insert.RowCount() )
	  
	  If ll_f > 0 Then
			
		  dw_insert.Scrolltorow(ll_r)
	
		   If ll_m0_qty = 0 Then
			
			Else
				If ll_m0_qty * (ll_jusu[1]/ll_su) < 1 Then
					dw_insert.object.s1qty[ll_f] = dw_insert.object.s1qty[ll_f]+ ll_m0_qty
					dw_insert.object.s2qty[ll_f] = 0 
					dw_insert.object.s3qty[ll_f] = 0 
					dw_insert.object.s4qty[ll_f] = 0 
					dw_insert.object.s5qty[ll_f] = 0 
					dw_insert.object.s6qty[ll_f] = 0 
				Else
				  dw_insert.object.s1qty[ll_f] =  dw_insert.object.s1qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0)
				  dw_insert.object.s2qty[ll_f] =  dw_insert.object.s2qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0)
				  dw_insert.object.s3qty[ll_f] =  dw_insert.object.s3qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0)
				  dw_insert.object.s4qty[ll_f] =  dw_insert.object.s4qty[ll_f] + Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0)
				 
				  If ll_jucnt = 5 Then
						dw_insert.object.s5qty[ll_f] = dw_insert.object.s5qty[ll_r] + &
						                                 ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) )
						dw_insert.object.s6qty[ll_f] = 0
						 
				  Else
						dw_insert.object.s5qty[ll_f] =   dw_insert.object.s5qty[ll_r] +  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0)
						dw_insert.object.s6qty[ll_f] =   dw_insert.object.s6qty[ll_r] + &
						                                 ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0) )
				  End If
				End If
			End If
	
		  dw_insert.object.mmqty[ll_f] = dw_insert.object.mmqty[ll_f] + ll_m0_qty
		  dw_insert.object.mmqty2[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m1qty))
		  dw_insert.object.mmqty3[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m2qty))
		  dw_insert.object.mmqty4[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m3qty))  
		  dw_insert.object.mmqty5[ll_f] = dw_insert.object.mmqty2[ll_f] + Long( Dec(ls_m4qty))
		
	  Else
		
		  ll_r = dw_insert.InsertRow(0) 
		 
		  dw_insert.Scrolltorow(ll_r)
		
		  dw_insert.object.saupj[ll_r] =  ls_saupj
		  dw_insert.object.yymm[ll_r] =   sYear 
		  dw_insert.object.cvcod[ll_r] = sCvcod
		  dw_insert.object.cvnas[ll_r] = ls_cvnas
		  dw_insert.object.carcode[ll_r] = '.'
		 
		  dw_insert.object.itnbr[ll_r] =  ls_itnbr
		  dw_insert.object.itdsc[ll_r] =  ls_itdsc
		  dw_insert.object.containqty[ll_r] = ll_containqty
		  dw_insert.object.gubun[ll_r] = '3'
			    
		  ld_price =  sqlca.fun_erp100000012_1(is_today , sCvcod , ls_itnbr,'1')
	
		  dw_insert.object.sprc[ll_r] = ld_price
		  
	
		  If ll_m0_qty = 0 Then
				dw_insert.object.s1qty[ll_r] = 0 
				dw_insert.object.s2qty[ll_r] = 0 
				dw_insert.object.s3qty[ll_r] = 0 
				dw_insert.object.s4qty[ll_r] = 0 
				dw_insert.object.s5qty[ll_r] = 0 
				dw_insert.object.s6qty[ll_r] = 0 
			Else
				If ll_m0_qty * (ll_jusu[1]/ll_su) < 1 Then
					dw_insert.object.s1qty[ll_r] = ll_m0_qty
					dw_insert.object.s2qty[ll_r] = 0 
					dw_insert.object.s3qty[ll_r] = 0 
					dw_insert.object.s4qty[ll_r] = 0 
					dw_insert.object.s5qty[ll_r] = 0 
					dw_insert.object.s6qty[ll_r] = 0 
				Else
				  dw_insert.object.s1qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0)
				  dw_insert.object.s2qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0)
				  dw_insert.object.s3qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0)
				  dw_insert.object.s4qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0)
				 
				  If ll_jucnt = 5 Then
						dw_insert.object.s5qty[ll_r] =   ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) )
						dw_insert.object.s6qty[ll_r] = 0
						 
				  Else
						dw_insert.object.s5qty[ll_r] =    Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0)
						dw_insert.object.s6qty[ll_r] =   ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) + &
																					  Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0) )
				  End If
				End If
			End If
	
		  dw_insert.object.mmqty[ll_r] =    ll_m0_qty
	
		  dw_insert.object.mmqty2[ll_r] =  Long( Dec(ls_m1qty))
		  dw_insert.object.mmqty3[ll_r] =  Long( Dec(ls_m2qty))
		  dw_insert.object.mmqty4[ll_r] =  Long( Dec(ls_m3qty))  
		  dw_insert.object.mmqty5[ll_r] =  Long( Dec(ls_m4qty))
	End IF
	
	ll_xl_row ++
	
Loop
uo_xl.uf_excel_Disconnect()

DESTROY uo_xl

// 엘셀 IMPORT  END ***************************************************************
dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return
Else
	Commit;
End If

w_mdi_frame.sle_msg.text =String(ll_cnt)+'건의 CKD 월간계획 DATA IMPORT 를 완료하였습니다.'
MessageBox('확인',String(ll_cnt)+'건의  CKD 월간계획 DATA IMPORT 를 완료하였습니다.')


Return
end event

type cb_1 from commandbutton within w_sm01_00015
boolean visible = false
integer x = 3173
integer y = 176
integer width = 457
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "excel import"
end type

event clicked;dw_1.AcceptText()

Long   row

row = dw_1.GetRow()
If row < 1 Then Return

String ls_yymm

ls_yymm = dw_1.GetItemString(row, 'yymm')
If Trim(ls_yymm) = '' Or IsNull(ls_yymm) Then
	MessageBox('기준 월 확인', '기준 월을 입력 하십시오.')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	Return
End If

String ls_saupj

ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('사업장 확인', '사업장을 선택하십시오.')
	Return
End If

Long   ll_cnt

SELECT COUNT('X')
  INTO :ll_cnt
  FROM SM01_MONPLAN_DT
 WHERE SAUPJ   =  :ls_saupj
   AND YYMM    =  :ls_yymm
	AND WANDATE IS NOT NULL ;
If ll_cnt > 0 Then
	MessageBox('확정 여부 확인', LEFT(ls_yymm, 4) + '년 ' + RIGHT(ls_yymm, 2) + '월 ' + '계획은 이미 확정 되었습니다.' + &
	                             '~r~r~n계속 진행하시기 원하시면 확정 취소 후 처리 하십시오.')
	Return
End If

/* File 선택 */
Long   ll_value
String ls_docname
String ls_named

ll_value = GetFileOpenName("월간계획 데이타 가져오기", ls_docname, ls_named, "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return

dw_insert.Reset()

Setpointer(Hourglass!)

/* 중복 확인 */
SetNull(ll_cnt)
SELECT COUNT('X')
  INTO :ll_cnt
  FROM SM01_MONPLAN_DT
 WHERE SAUPJ = :ls_saupj
   AND YYMM  = :ls_yymm ;
If ll_cnt > 0 Then
	If MessageBox('기존 자료 존재', '기존 등록된 자료를 삭제하시겠습니까?', Question!, YesNo!, 2) = 2 Then
		Return
	Else
		DELETE FROM SM01_MONPLAN_DT
		 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_yymm ;
		If SQLCA.SQLCODE = 0 Then
			COMMIT USING SQLCA;
		Else
			ROLLBACK USING SQLCA;
			MessageBox('삭제 오류', '자료 삭제 중 오류가 발생했습니다.')
			Return
		End If
	End If
End If

/* 주차확인 */
String ls_end_date

SELECT TO_CHAR(LAST_DAY(TO_DATE(:ls_yymm, 'YYYYMM')), 'YYYYMMDD')
  INTO :ls_end_date
  FROM DUAL;
Long   ll_su

ll_su = Long(RIGHT(ls_end_date, 2))

Long   ll_jucnt

SELECT COUNT('X')
  INTO :ll_jucnt
  FROM PDTWEEK
 WHERE WEEK_SDATE LIKE :ls_yymm||'%' ;
If ll_jucnt < 1 Then
	MessageBox('확인', '년간 주차 데이타가 없습니다. 년간 주차를 생성하세요')
	Return
End If

Long   i
Long   ll_jusu[]

For i = 1 To ll_jucnt
	SELECT WEEK_EDATE - WEEK_SDATE + 1
	  INTO :ll_jusu[i]
	  FROM PDTWEEK
	 WHERE WEEK_SDATE LIKE :ls_yymm||'%'
	   AND MON_JUCHA = :i ;
Next

/* Excel Import */
uo_xlobject uo_xl

//UserObject 생성
uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, False , 3)

uo_xl.uf_selectsheet(1)

dw_insert.object.t_mm.text = String(ls_yymm,'@@@@.@@')+'월'

//Data 시작 Row Setting
Long   ll_xl_row

ll_xl_row = 4

Long   ll_r
Long   ll_m0_qty
Long   ll_m2_qty
Long   ll_m3_qty
Long   ll_m4_qty
Long   ll_chk
Long   ll_find
Long   ll_mon

String ls_itnbr
String ls_cvcod

ll_mon = 0

Do While(True)
	
	Jump:
	
	//Data가 없을경우엔 Return...........
	If IsNull(uo_xl.uf_gettext(ll_xl_row, 1)) Or Trim(uo_xl.uf_gettext(ll_xl_row, 1)) = '' Then Exit
	
	ll_r = dw_insert.InsertRow(0)
	dw_insert.Scrolltorow(ll_r)
	
	//사용자 ID(A,1)
	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i = 1 To 30
		uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))		
	Next
	  
	dw_insert.object.saupj[ll_r] =  ls_saupj
	dw_insert.object.yymm[ll_r]  =  ls_yymm	
	
	ls_itnbr = Trim(uo_xl.uf_gettext(ll_xl_row, 3))
	ls_cvcod = Trim(uo_xl.uf_gettext(ll_xl_row, 2))
	
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM ITEMAS
	 WHERE ITNBR = :ls_itnbr ;
	If ll_chk < 1 Then
		MessageBox('미 등록된 품번', ls_itnbr + ' 은(는) 미 등록된 품번입니다.~r~r~nExcel Importing을 취소합니다.')
		uo_xl.uf_excel_Disconnect()
		DESTROY uo_xlobject
		dw_insert.ReSet()
		dw_insert.SetTransObject(SQLCA)
		Return
	End If
	
	SetNull(ll_chk)
	SELECT COUNT('X')
	  INTO :ll_chk
	  FROM SM01_MONPLAN_DT
	 WHERE SAUPJ = :ls_saupj AND YYMM    = :ls_yymm AND CVCOD = :ls_cvcod
		AND ITNBR = :ls_itnbr AND CARCODE = '.'      AND GUBUN = '1'       ;
	If ll_chk > 0 Then
		If MessageBox('Duplication!!', ls_cvcod + ' 거래처의 ' + ls_itnbr + ' 품번은 이미 등록 된 자료입니다.' + &
		                               '~r~r~n해당 품번을 건너뛰고 작업을 계속 하시겠습니까?', Question!, OKCancel!, 2) = 2 Then
			MessageBox('Excel Importing Cancel', 'Excel Importing 작업을 취소합니다.')
			uo_xl.uf_excel_Disconnect()
			DESTROY uo_xlobject
			dw_insert.ReSet()
			dw_insert.SetTransObject(SQLCA)
			Return
		Else
			GOTO Jump
		End If
	End If
	
	/* Duplication Sum */
	ll_m0_qty = Long( Dec(uo_xl.uf_gettext(ll_xl_row, 4)) )
	ll_m2_qty = Long( Dec(uo_xl.uf_gettext(ll_xl_row, 5)) )
	ll_m3_qty = Long( Dec(uo_xl.uf_gettext(ll_xl_row, 6)) )
	ll_m4_qty = Long( Dec(uo_xl.uf_gettext(ll_xl_row, 7)) )

	ll_find   = dw_insert.Find("cvcod = '" + ls_cvcod + "' and itnbr = '" + ls_itnbr + "'", 1, ll_r - 1)
	If ll_find > 0 Then			
		ll_m0_qty = ll_m0_qty + dw_insert.object.mmqty[ll_find]
		ll_m2_qty = ll_m2_qty + dw_insert.object.mmqty2[ll_find]
		ll_m3_qty = ll_m3_qty + dw_insert.object.mmqty3[ll_find]
		ll_m4_qty = ll_m4_qty + dw_insert.object.mmqty4[ll_find]
		
		dw_insert.object.mmqty[ll_find]  = ll_m0_qty
		dw_insert.object.mmqty2[ll_find] = ll_m2_qty
		dw_insert.object.mmqty3[ll_find] = ll_m3_qty
		dw_insert.object.mmqty4[ll_find] = ll_m4_qty
		
		ll_mon++
	Else
		ll_find = ll_r
	End If	
	  
	If ll_m0_qty = 0 Then
		dw_insert.object.s1qty[ll_find] = 0
		dw_insert.object.s2qty[ll_find] = 0
		dw_insert.object.s3qty[ll_find] = 0
		dw_insert.object.s4qty[ll_find] = 0
		dw_insert.object.s5qty[ll_find] = 0
		dw_insert.object.s6qty[ll_find] = 0
	Else
		If ll_m0_qty * (ll_jusu[1]/ll_su) < 1 Then
			dw_insert.object.s1qty[ll_find] = ll_m0_qty
			dw_insert.object.s2qty[ll_find] = 0 
			dw_insert.object.s3qty[ll_find] = 0 
			dw_insert.object.s4qty[ll_find] = 0 
			dw_insert.object.s5qty[ll_find] = 0 
			dw_insert.object.s6qty[ll_find] = 0 
		Else
		   dw_insert.object.s1qty[ll_find] = Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0)
		   dw_insert.object.s2qty[ll_find] = Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0)
		   dw_insert.object.s3qty[ll_find] = Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0)
		   dw_insert.object.s4qty[ll_find] = Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0)
		 
			If ll_jucnt = 5 Then
				dw_insert.object.s5qty[ll_find] = ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) )
				dw_insert.object.s6qty[ll_find] = 0
					 
			Elseif ll_jucnt = 6 Then
				dw_insert.object.s5qty[ll_find] = Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0)
				dw_insert.object.s6qty[ll_find] = ll_m0_qty - ( Truncate(ll_m0_qty * (ll_jusu[1]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[2]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[3]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[4]/ll_su) , 0) + &
																				Truncate(ll_m0_qty * (ll_jusu[5]/ll_su) , 0) )
			End If
		End If
	End If
	
	If ll_mon > 0 Then		
		dw_insert.DeleteRow(ll_r)
		ll_xl_row ++
		ll_mon = 0
		
		GOTO Jump
	End If
	/* Duplication Sum End */
	
	dw_insert.object.cvcod[ll_r]   = ls_cvcod
	dw_insert.object.itnbr[ll_r]   = ls_itnbr
	dw_insert.object.gubun[ll_r]   = '1'
	dw_insert.object.carcode[ll_r] = '.'
	
	dw_insert.object.cvnas[ll_r]   = f_get_name5('11', ls_cvcod, '')
	dw_insert.object.itdsc[ll_r]   = f_get_name5('13', ls_itnbr, '')
	
	dw_insert.object.mmqty[ll_r]   = ll_m0_qty
	dw_insert.object.mmqty2[ll_r]  = ll_m2_qty
	dw_insert.object.mmqty3[ll_r]  = ll_m3_qty
	dw_insert.object.mmqty4[ll_r]  = ll_m4_qty
	dw_insert.object.mmqty5[ll_r]  = 0
	
	wf_danga(ll_r)

	ll_xl_row ++
	
Loop

uo_xl.uf_excel_Disconnect()
DESTROY uo_xlobject
/* Excel Import End */

/* Duplication Checked */
//SetNull(i)
//SetNull(ls_cvcod)
//SetNull(ls_itnbr)
//
//Long   ll_dup
//
//For i = 1 To dw_insert.RowCount()
//	If i = dw_insert.RowCount() Then Exit
//	ls_cvcod = dw_insert.GetItemString(i, 'cvcod')
//	ls_itnbr = dw_insert.GetItemString(i, 'itnbr')
//	ll_dup = dw_insert.Find("cvcod = '" + ls_cvcod + "' and itnbr = '" + ls_itnbr + "'", i + 1, dw_insert.RowCount())
//	If ll_dup > 0 Then
//		MessageBox('Duplication Item', String(i) + '행과 ' + String(ll_dup) + '행이 중복입니다')
//		Return
//	End If
//Next

If dw_insert.UPDATE() = 1 Then
	COMMIT USING SQLCA;
	MessageBox('저장 성공', '자료가 저장 되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장 실패', '자료 저장 중 오류가 발생했습니다.')
	Return
End If


end event

type st_2 from statictext within w_sm01_00015
integer x = 37
integer y = 276
integer width = 2656
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "※ Excel Upload : 거래처-품번 기준으로 같은 자료일 경우 계획수량을 합산하여 처리됩니다."
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sm01_00015
integer x = 2528
integer y = 80
integer width = 485
integer height = 124
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "Ho"
string text = "년간 계획 적용"
end type

event clicked;dw_1.AcceptText()

Integer row
row = dw_1.GetRow()
If row < 1 Then Return

String  ls_ym
ls_ym = dw_1.GetItemString(row, 'yymm')
If Trim(ls_ym) = '' OR IsNull(ls_ym) Then
	MessageBox('확인', '기준 년월을 입력 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('yymm')
	Return
End If

String  ls_saupj
ls_saupj = dw_1.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	MessageBox('확인', '사업장을 선택 하십시오.')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

String  ls_yy
ls_yy = LEFT(ls_ym, 4)

/* 년간 계획의 최종 마감차수 가져오기 */
Integer li_cha
SELECT NVL(MAX(CHASU), 0)
  INTO :li_cha
  FROM SM01_YEARPLAN
 WHERE SABU = :gs_sabu AND YYYY = :ls_yy AND CNFIRM IS NOT NULL ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Select Err [SM01_YEARPLAN] ' + String(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT)
	Return
End If

If IsNull(li_cha) OR li_cha < 1 Then
	MessageBox('확인', '확정된 년간 계획이 없습니다.')
	Return
End If

/* 조업달력에서 월요일에 시작되는 주차가 몇 개 인지 확인 */
Integer li_jucha
SELECT COUNT('X')
  INTO :li_jucha
  FROM P4_CALENDAR
 WHERE YYYYMM = :ls_ym AND DAYGUBN = '2' ; /* DAYGUBN : 1-일, 2-월, 3-화, 4-수, 5-목, 6-금, 7-토 */
If SQLCA.SQLCODE <> 0 Then
	MessageBox('Select Err [P4_CALENDAR] ' + String(SQLCA.SQLDBCODE), SQLCA.SQLERRTEXT)
	Return
End If

/* 해당 월에 자료 생성여부 확인 */
Long    ll_err
String  ls_err
String  ls_dup
SELECT CASE WHEN COUNT('X') < 1 THEN 'N' ELSE 'Y' END
  INTO :ls_dup
  FROM SM01_MONPLAN_DT
 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_ym ;
If ls_dup = 'Y' Then
	If MessageBox('자료 존재 확인', '기 생성된 자료가 있습니다.~r~n삭제 후 계속 진행 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return
	
	DELETE FROM SM01_MONPLAN_DT
	 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_ym ;
	If SQLCA.SQLCODE = 0 Then
		COMMIT USING SQLCA;
	Else
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		MessageBox('기 자료 삭제 오류 ' + String(ll_err), ls_err)
	End If
End If

SetPointer(HourGlass!)

/* 최초 자료 생성 */
INSERT INTO SM01_MONPLAN_DT (
SAUPJ   , YYMM          , CVCOD     , ITNBR     , CARCODE   , GUBUN   , SPRC    , MMQTY   ,
S1QTY   , S2QTY         , S3QTY     , S4QTY     , S5QTY     , S6QTY   , MMQTY2  , MMQTY3  ,
MMQTY4  , MMQTY5        , NAPGI1    , NAPGI2    , NAPGI3    , NAPGI4  , NAPGI5  , NAPGI6  ,
WANDATE , APPROVALSTATUS, MANAGEDATE, MON_NAPGI2, MON_NAPGI3, WEEKQTY1, WEEKQTY2, WEEKQTY3,
WEEKQTY4, WEEKQTY5      , JAEGO     , WEEKQTY6  , SO_MMQTY  )
SELECT SAUPJ, :ls_ym, CVCOD, ITNBR, PLNT, '1', FUN_ERP100000012_1(TO_CHAR(SYSDATE, 'YYYYMMDD'), CVCOD, ITNBR, '1'),
       /* M월 자료 가져오기 */
       DECODE(SUBSTR(:ls_ym, 5, 2), '01', QTY_01, '02', QTY_02, '03', QTY_03, '04', QTY_04, '05', QTY_05, '06', QTY_06,
                                      '07', QTY_07, '08', QTY_08, '09', QTY_09, '10', QTY_10, '11', QTY_11, '12', QTY_12),
       0, 0, 0, 0, 0, 0, /* 주차별 수량 처리는 나중에.. */
       /* M+1월 자료 가져오기 */
       DECODE(SUBSTR(:ls_ym, 5, 2), '01', QTY_02, '02', QTY_03, '03', QTY_04, '04', QTY_05, '05', QTY_06, '06', QTY_07,
                                    '07', QTY_08, '08', QTY_09, '09', QTY_10, '10', QTY_11, '11', QTY_12, '12', 0),
       /* M+2월 자료 가져오기 */
       DECODE(SUBSTR(:ls_ym, 5, 2), '01', QTY_03, '02', QTY_04, '03', QTY_05, '04', QTY_06, '05', QTY_07, '06', QTY_08,
                                    '07', QTY_09, '08', QTY_10, '09', QTY_11, '10', QTY_12, '11', 0     , '12', 0),
       /* M+3월 자료 가져오기 */
       DECODE(SUBSTR(:ls_ym, 5, 2), '01', QTY_04, '02', QTY_05, '03', QTY_06, '04', QTY_07, '05', QTY_08, '06', QTY_09,
                                    '07', QTY_10, '08', QTY_11, '09', QTY_12, '10', 0     , '11', 0     , '12', 0),
       /* M+4월 자료 가져오기 */
       DECODE(SUBSTR(:ls_ym, 5, 2), '01', QTY_05, '02', QTY_06, '03', QTY_07, '04', QTY_08, '05', QTY_09, '06', QTY_10,
                                    '07', QTY_11, '08', QTY_12, '09', 0     , '10', 0     , '11', 0     , '12', 0),
       0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0
  FROM SM01_YEARPLAN
 WHERE SABU  = :gs_sabu
   AND YYYY  = :ls_yy
	AND CHASU = (SELECT MAX(CHASU) FROM SM01_YEARPLAN WHERE SABU = :gs_sabu AND YYYY = :ls_yy AND CNFIRM IS NOT NULL);
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
	ROLLBACK USING SQLCA;
	SetPointer(Arrow!)
	MessageBox('자료 생성 오류 ' + String(ll_err), ls_err)
	Return
End If

/* 위에 저장된 월간의 건별 자료를 읽어서 주차별 수량을 계산하여 UPDATE 처리 */
Integer li_cnt
SELECT COUNT('X')
  INTO :li_cnt
  FROM SM01_MONPLAN_DT
 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_ym ;

DECLARE cur_mon CURSOR FOR
	SELECT SAUPJ, YYMM, CVCOD, ITNBR, CARCODE, GUBUN, MMQTY, TRUNC(MMQTY / :li_jucha), MOD(MMQTY, :li_jucha)
	  FROM SM01_MONPLAN_DT
	 WHERE SAUPJ = :ls_saupj AND YYMM = :ls_ym ;
	 
OPEN cur_mon;

Integer i
Integer l
String  ls_sa
String  ls_yymm
String  ls_cvcod
String  ls_itnbr
String  ls_plnt
String  ls_gbn
Long    ll_mmqty
Long    ll_sqty
Long    ll_mod
Long    ll_jusum
Long    ll_upqty[6] = {0, 0, 0, 0, 0, 0}
SetNull(ll_err) ; SetNull(ls_err)
For i = 1 To li_cnt
	FETCH cur_mon INTO :ls_sa, :ls_yymm, :ls_cvcod, :ls_itnbr, :ls_plnt, :ls_gbn, :ll_mmqty, :ll_sqty, :ll_mod ;
	
	ll_jusum = 0
	
	/* 주차만큼 LOOP 계산 */
	For l = 1 To li_jucha
		/* 나머지 수량은 1주차에 포함 */
		If l = 1 Then
			ll_upqty[l] = ll_sqty + ll_mod
		Else
			ll_upqty[l] = ll_sqty
		End If
	Next
	
	UPDATE SM01_MONPLAN_DT
		SET S1QTY = :ll_upqty[1], S2QTY = :ll_upqty[2], S3QTY = :ll_upqty[3],
		    S4QTY = :ll_upqty[4], S5QTY = :ll_upqty[5], S6QTY = :ll_upqty[6]
	 WHERE SAUPJ = :ls_sa AND YYMM = :ls_ym AND CVCOD = :ls_cvcod AND ITNBR = :ls_itnbr AND CARCODE = :ls_plnt AND GUBUN = :ls_gbn ;
	If SQLCA.SQLCODE <> 0 Then
		ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
		ROLLBACK USING SQLCA;
		CLOSE cur_mon;
		SetPointer(Arrow!)
		MessageBox('자료 갱신 오류 ' + String(ll_err), ls_err)
		Return
	End If
Next

CLOSE cur_mon;
SetPointer(Arrow!)

COMMIT USING SQLCA;
MessageBox('생성 확인', '월간 계획이 생성 되었습니다.')
end event

