$PBExportHeader$w_sm01_00025.srw
$PBExportComments$월 판매계획 확정
forward
global type w_sm01_00025 from w_inherite
end type
type rr_1 from roundrectangle within w_sm01_00025
end type
type dw_1 from u_key_enter within w_sm01_00025
end type
type p_1 from uo_picture within w_sm01_00025
end type
type p_2 from uo_picture within w_sm01_00025
end type
end forward

global type w_sm01_00025 from w_inherite
integer width = 4677
integer height = 2836
string title = "월 판매계획 확정"
rr_1 rr_1
dw_1 dw_1
p_1 p_1
p_2 p_2
end type
global w_sm01_00025 w_sm01_00025

forward prototypes
public function integer wf_danga (integer arg_row)
public subroutine wf_init ()
end prototypes

public function integer wf_danga (integer arg_row);String sCvcod, sItnbr, stoday, sGiDate ,sCurr
Double	 dDanga
Long ll_rtn

If arg_row <= 0 Then Return 1

sToday	= f_today()
sGiDate	= dw_1.GetItemString(1, 'yymm')+'01'	// 단가기준일자
sCvcod	= Trim(dw_insert.GetItemString(arg_row, 'cvcod'))
sItnbr	= Trim(dw_insert.GetItemString(arg_row, 'itnbr'))

dDanga = sqlca.fun_erp100000012_1(sGiDate, sCVCOD, sITNBR,'1' ) ;

If IsNull(dDanga) Then dDanga = 0

dw_insert.Setitem(arg_row, 'sprc', dDanga)

Return 0
end function

public subroutine wf_init ();//



	
end subroutine

on w_sm01_00025.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_2
end on

on w_sm01_00025.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)
dw_1.Object.yymm[1] = Left(is_today,6)
dw_1.Object.confirm_dt[1] = is_today

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
end event

type dw_insert from w_inherite`dw_insert within w_sm01_00025
integer x = 27
integer y = 292
integer width = 4567
integer height = 2024
integer taborder = 130
string dataobject = "d_sm01_00025_a"
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

nRow = GetRow()
If nRow <= 0 Then Return

SetNull(sNull)

sCol = GetColumnName()
Choose Case GetColumnName()
	
	Case 'itnbr'
		sItnbr = trim(this.GetText())
	
		Select ITDSC ,
		       CONTAINQTY 
			Into :sitdsc ,
			     :ll_containqty
		  FROM ITEMAS
		 WHERE ITNBR = :sitnbr ;
		If sqlca.sqlcode <> 0 Then
			setitem(nrow, "itnbr", sNull)	
			setitem(nrow, "itdsc", sNull)	
			setitem(nrow, "containqty", sNull)	
			Return 1
		End If
		
		setitem(nrow, "itnbr", sitnbr)	
		setitem(nrow, "itdsc", sitdsc)
		setitem(nrow, "containqty", ll_containqty)
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

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''

If row < 1 Then Return
str_code lst_code
Long i , ll_i = 0

this.AcceptText()
Choose Case GetcolumnName() 
	Case "itnbr"
		
		gs_gubun = '1'
		
		Open(w_itemas_multi_popup)

		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then p_addrow.triggerevent("clicked")
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next
	Case 'cvcod'
		gs_code = GetText()

		Open(w_vndmst_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		this.SetItem(row, "cvcod", gs_Code)
		this.SetItem(row, "cvnas", gs_Codename)
		
		Post wf_danga(row)
End Choose
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;
If currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if
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

type p_delrow from w_inherite`p_delrow within w_sm01_00025
boolean visible = false
integer x = 3296
integer y = 148
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_sm01_00025
boolean visible = false
integer x = 3593
integer y = 152
integer taborder = 50
end type

type p_search from w_inherite`p_search within w_sm01_00025
boolean visible = false
integer x = 3086
integer y = 20
integer taborder = 110
string picturename = "C:\erpman\image\from_excel.gif"
end type

event p_search::ue_lbuttondown;//
end event

event p_search::ue_lbuttonup;//
end event

type p_ins from w_inherite`p_ins within w_sm01_00025
boolean visible = false
integer x = 4064
integer y = 196
integer taborder = 30
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm01_00025
integer taborder = 100
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm01_00025
integer taborder = 90
end type

event p_can::clicked;call super::clicked;
dw_insert.Reset()
ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sm01_00025
boolean visible = false
integer x = 3264
integer y = 20
integer taborder = 120
string picturename = "C:\erpman\image\소요량계산_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\소요량계산_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\소요량계산_up.gif"
end event

type p_inq from w_inherite`p_inq within w_sm01_00025
integer x = 3749
end type

event p_inq::clicked;String ls_saupj , ls_yymm , ls_cvcod , ls_carcode ,ls_itnbr , ls_car


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
ls_car     = trim(dw_1.getitemstring(1, 'carcode'))

If ls_cvcod = '' Or isNull(ls_cvcod) Then 
	ls_cvcod = '%'
Else
	ls_cvcod = ls_cvcod+'%'
End If

If ls_car = '' Or isNull(ls_car) Then ls_car = '%' 

ls_itnbr   = trim(dw_1.getitemstring(1, 'itnbr'))
If ls_itnbr = '' Or isNull(ls_itnbr) Then 
	ls_itnbr = '%'
Else
	ls_itnbr = ls_itnbr+'%'
End If


If dw_insert.Retrieve(ls_saupj, ls_yymm,ls_cvcod , ls_car , ls_itnbr) <= 0 Then
	f_message_chk(50,'')
End If	


/* 월 셋팅 */
dw_insert.object.t_mm.text = String(ls_yymm,'@@@@.@@')+'월'


end event

type p_del from w_inherite`p_del within w_sm01_00025
boolean visible = false
integer x = 3113
integer y = 20
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

type p_mod from w_inherite`p_mod within w_sm01_00025
integer taborder = 70
string picturename = "C:\erpman\image\확정_up.gif"
end type

event p_mod::clicked;call super::clicked;If dw_1.acceptText() < 1 Then return

If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt
Long   ll_cnt

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm = Trim(dw_1.Object.yymm[1])
ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

If isNull(ls_confirm_dt) or ls_confirm_dt = '' Then
	f_message_chk(35 , "[확정일자]")
	dw_1.SetFocus()
	dw_1.SetColumn("confirm_dt")
	Return
End If
ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	 ;
If ll_cnt < 1 Then
	MessageBox('확인','해당 월에는 아직 판매계획이 생성되지 않았습니다.')
	Return
Else
	ll_cnt = 0 

	Select Count(*) Into :ll_cnt
	  from sm01_monplan_dt
	 where saupj = :ls_saupj
		and yymm = :ls_yymm
		and wandate is not null;
	If ll_cnt > 0 Then
		MessageBox('확인','해당 월에는 이미 판매계획이 확정 상태 입니다. 취소 후 재확정 하세요.')
		Return
	End If
	
End If


If MessageBox("확인",Left(ls_yymm,4)+" 년"+Right(ls_yymm,2)+ " 월 판매계획을 확정하시겠습니까?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

Delete From lw_002 where saupj = :ls_saupj and yymm = :ls_yymm ;

If sqlca.sqlcode <> 0 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return
End if

Update sm01_monplan_dt Set wandate = :ls_confirm_dt
                    where saupj = :ls_saupj
						    and yymm = :ls_yymm ;
If sqlca.sqlcode <> 0 Then
	MessageBox('' , sqlca.sqlerrText)
	Rollback;
	MessageBox('확인','저장실패')
	Return
Else
	Commit;
	dw_1.Object.cust[1]='2'
	
	MessageBox('확인','월판매 계획이 마감되었습니다.        ')
End If
	

	




	
	
	
end event

event p_mod::ue_lbuttondown;//
end event

event p_mod::ue_lbuttonup;//
end event

type cb_exit from w_inherite`cb_exit within w_sm01_00025
boolean visible = true
end type

type cb_mod from w_inherite`cb_mod within w_sm01_00025
boolean visible = true
end type

type cb_ins from w_inherite`cb_ins within w_sm01_00025
boolean visible = true
end type

type cb_del from w_inherite`cb_del within w_sm01_00025
boolean visible = true
end type

type cb_inq from w_inherite`cb_inq within w_sm01_00025
boolean visible = true
end type

type cb_print from w_inherite`cb_print within w_sm01_00025
boolean visible = true
end type

type st_1 from w_inherite`st_1 within w_sm01_00025
boolean visible = true
end type

type cb_can from w_inherite`cb_can within w_sm01_00025
boolean visible = true
end type

type cb_search from w_inherite`cb_search within w_sm01_00025
boolean visible = true
end type

type dw_datetime from w_inherite`dw_datetime within w_sm01_00025
boolean visible = true
end type

type sle_msg from w_inherite`sle_msg within w_sm01_00025
boolean visible = true
end type

type gb_10 from w_inherite`gb_10 within w_sm01_00025
boolean visible = true
end type

type gb_button1 from w_inherite`gb_button1 within w_sm01_00025
boolean visible = true
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_00025
boolean visible = true
end type

type rr_1 from roundrectangle within w_sm01_00025
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4585
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_sm01_00025
integer x = 18
integer y = 16
integer width = 3113
integer height = 252
integer taborder = 20
string dataobject = "d_sm01_00025_1"
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
				dw_1.Object.cust[1]='2'
				MessageBox('확 인','월판매계획이 마감처리 되어있습니다.!!')
				p_search.Enabled = False
				p_print.Enabled = False
				p_mod.Enabled = False
				p_addrow.Enabled = False
				p_delrow.Enabled = False
				p_del.Enabled = False
				p_search.PictureName = 'C:\erpman\image\from_excel.gif'
				p_print.PictureName = 'C:\erpman\image\소요량계산_d.gif'
				p_mod.PictureName = 'C:\erpman\image\확정_d.gif'
				p_addrow.PictureName = 'C:\erpman\image\행추가_d.gif'
				p_delrow.PictureName = 'C:\erpman\image\행삭제_d.gif'
				p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
				
				Return 1
			
			Else
				dw_1.Object.cust[1]='1'
				p_search.Enabled = True
				p_print.Enabled = True
				p_mod.Enabled = True
				p_addrow.Enabled = True
				p_delrow.Enabled = True
				p_del.Enabled = True
				p_search.PictureName = 'C:\erpman\image\from_excel.gif'
				p_print.PictureName = 'C:\erpman\image\소요량계산_up.gif'
				p_mod.PictureName = 'C:\erpman\image\확정_up.gif'
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

type p_1 from uo_picture within w_sm01_00025
integer x = 4096
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\확정취소_up.gif"
end type

event clicked;call super::clicked;If dw_1.acceptText() < 1 Then return

If dw_insert.Rowcount() < 1 Then Return

String ls_yymm , ls_saupj  ,ls_confirm_dt
Long   ll_cnt

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_yymm = Trim(dw_1.Object.yymm[1])
ls_confirm_dt= Trim(dw_1.Object.confirm_dt[1])

ll_cnt = 0 

Select Count(*) Into :ll_cnt
  from sm01_monplan_dt
 where saupj = :ls_saupj
   and yymm = :ls_yymm
	 ;
If ll_cnt < 1 Then
	MessageBox('확인','해당 월에는 아직 판매계획이 생성되지 않았습니다.')
	Return
END If

ll_cnt = 0 

SELECT COUNT(*) INTO :ll_cnt
 FROM PM01_MONPLAN_SUM A
 WHERE A.SABU = :gs_sabu
   AND A.MONYYMM = :ls_yymm
	AND A.MOSEQ = 0 
	AND A.SAUPJ LIKE :ls_saupj;

If ll_cnt > 0 Then
	MessageBox('확인','해당 월 판매계획은 이미 생산계획에 반영되어 마감상태입니다.  취소 불가능합니다.')
	Return
Else
	ll_cnt = 0 

	SELECT COUNT(*) INTO :ll_cnt
     FROM PM01_MONPLAN_SUM A
    WHERE A.SABU = :gs_sabu
      AND A.MONYYMM = :ls_yymm
	   AND A.MOSEQ != 0 
	   AND A.SAUPJ LIKE :ls_saupj;
		
	If ll_cnt > 0 Then
		MessageBox('확인','해당 월 판매계획은 이미 생산계획에 반영된 상태입니다.  취소 불가능합니다.')
	   Return
	End If
	
End If


If MessageBox("확인",Left(ls_yymm,4)+" 년"+Right(ls_yymm,2)+ " 월 판매계획을 취소 하시겠습니까?    ", Exclamation!, OKCancel!, 2) = 2 Then
	Return
End if

SetNull(ls_confirm_dt)

Update sm01_monplan_dt Set wandate = :ls_confirm_dt
                    where saupj = :ls_saupj
						    and yymm = :ls_yymm ;
If sqlca.sqlcode <> 0 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return
Else
	Commit;
	dw_1.Object.cust[1]='1'
	MessageBox('확인','월판매 계획이 마감 취소 되었습니다.        ')
End If
	

	




	
	
	
end event

type p_2 from uo_picture within w_sm01_00025
boolean visible = false
integer x = 3506
integer y = 72
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event clicked;call super::clicked;String ls_window_id , ls_window_nm, syymm
Double   ll_sp = 0

syymm = dw_1.GetItemString(1, 'yymm')
If syymm = '' or isNull(syymm) Then
	messagebox('','계획년도를 입력하세요.')
	return
End If


gs_code = '월간 판매계획 마감'
gs_codename = String(sYymm,'@@@@년 @@월 ') + '판매계획을 마감했습니다.'
//Open(w_mailsend_popup)
end event

