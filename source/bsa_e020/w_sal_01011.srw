$PBExportHeader$w_sal_01011.srw
$PBExportComments$ ===> 영업팀별 관할구역별 영업사원 등록
forward
global type w_sal_01011 from w_inherite
end type
type gb_5 from groupbox within w_sal_01011
end type
type gb_4 from groupbox within w_sal_01011
end type
type gb_3 from groupbox within w_sal_01011
end type
type dw_jogun from datawindow within w_sal_01011
end type
type dw_select from u_key_enter within w_sal_01011
end type
type gb_2 from groupbox within w_sal_01011
end type
type st_gubun from statictext within w_sal_01011
end type
type rr_1 from roundrectangle within w_sal_01011
end type
end forward

global type w_sal_01011 from w_inherite
string title = "영업팀별 관할구역별 영업사원 등록"
gb_5 gb_5
gb_4 gb_4
gb_3 gb_3
dw_jogun dw_jogun
dw_select dw_select
gb_2 gb_2
st_gubun st_gubun
rr_1 rr_1
end type
global w_sal_01011 w_sal_01011

forward prototypes
public function long wf_col_sum (string arg_col)
public function integer wf_update (string syear)
end prototypes

public function long wf_col_sum (string arg_col);long i, lHapCnt = 0

dw_Insert.AcceptText()

for i = 1 to dw_Insert.RowCount()
	lHapCnt += dw_Insert.GetItemNumber(i, arg_col)
next

return lHapCnt
end function

public function integer wf_update (string syear);// 전년도 장기계획 영업사원수를 당년도로 복사 
integer iCnt
icnt = 0

Select count(*) into :icnt from longplansarea
WHERE sabu  = :gs_sabu  AND
		setup_year = TO_CHAR(TO_NUMBER(:SYEAR) -1 );
		
if icnt > 0 then
  UPDATE "LONGPLANSAREA"  A
     SET ( "SALES_EMP_CNT_1",   "SALES_EMP_CNT_2",         "SALES_EMP_CNT_3",          
	  		  "SALES_EMP_CNT_4",   
           "SALES_EMP_CNT_5",   "SALES_EMP_CNT_6",         "SALES_EMP_CNT_7",   
           "SALES_EMP_CNT_8",   "SALES_EMP_CNT_9",         "SALES_EMP_CNT_10" )  
		 = ( SELECT Nvl(b.sales_emp_cnt_2, 0), 
 		 				Nvl(b.sales_emp_cnt_3, 0), 
 		 				Nvl(b.sales_emp_cnt_4, 0), 
 		 				Nvl(b.sales_emp_cnt_5, 0), 
 		 				Nvl(b.sales_emp_cnt_6, 0), 						  
		 				Nvl(b.sales_emp_cnt_7, 0), 
 		 				Nvl(b.sales_emp_cnt_8, 0), 
 		 				Nvl(b.sales_emp_cnt_9, 0), 
  		 				Nvl(b.sales_emp_cnt_10, 0), 
						0
				 FROM longplansarea b
				WHERE b.sabu       = :gs_sabu  AND
						b.setup_year = TO_CHAR(TO_NUMBER(:SYEAR) -1 ) ANd
						b.sarea      = a.sarea ) 
	 WHERE A."SABU"   = :gs_sabu  AND
			 A."SETUP_YEAR" = :sYear ;
end if

If sqlca.sqlcode <> 0 Then
	rollback;
	Messagebox("관할구역", "전년도 자료 복사중 오류발생" + '~n' + sqlca.sqlerrtext)
	return -1
End If

// 당해년도 관할 구역별 영업사원수를 집계하여 영업팀별로 저장
	insert into longplansteam
			 SELECT :gs_sabu, :sYear, b.steamcd, 
		 				Nvl(sum(a.sales_emp_cnt_1), 0), 
 		 				Nvl(sum(a.sales_emp_cnt_2), 0), 
 		 				Nvl(sum(a.sales_emp_cnt_3), 0), 
 		 				Nvl(sum(a.sales_emp_cnt_4), 0), 
 		 				Nvl(sum(a.sales_emp_cnt_5), 0), 						  
		 				Nvl(sum(a.sales_emp_cnt_6), 0), 
 		 				Nvl(sum(a.sales_emp_cnt_7), 0), 
 		 				Nvl(sum(a.sales_emp_cnt_8), 0), 
  		 				Nvl(sum(a.sales_emp_cnt_9), 0), 
  		 				Nvl(sum(a.sales_emp_cnt_10), 0) 
			    FROM longplansarea a, sarea b
			   WHERE a.sabu   		= :gs_sabu  AND
					   a.setup_year   = :sYear		 And
					   a.sarea        = b.sarea
		   group by b.steamcd;

If sqlca.sqlcode <> 0 Then
	rollback;
	Messagebox("영업팀", "영업팀 자료 집계중 오류 발생" + '~n' + sqlca.sqlerrtext)	
	return -1
End If

commit;
return 1
end function

on w_sal_01011.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_3=create gb_3
this.dw_jogun=create dw_jogun
this.dw_select=create dw_select
this.gb_2=create gb_2
this.st_gubun=create st_gubun
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.dw_jogun
this.Control[iCurrent+5]=this.dw_select
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.st_gubun
this.Control[iCurrent+8]=this.rr_1
end on

on w_sal_01011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.dw_jogun)
destroy(this.dw_select)
destroy(this.gb_2)
destroy(this.st_gubun)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent("ue_open")
end event

event ue_open;call super::ue_open;//*****************************************************************************//
//***  PGM NAME : 영업팀별 관할구역별 영업사원수 등록                       ***//
//***  PGM ID   : W_SAL_01011                                               ***//
//***  SUBJECT  : 장기판매계획관련 출력물에 사용되는 영업사원 및 관리사원   ***//
//***             을 관할구역별로 등록하여 영업팀 인원으로 생성             ***//
//***             관리인원은 별도 코드없이 영업팀인원에서 해당관할구역      ***//
//***             인원을 뺀 인원으로 본다.                                  ***//
//*****************************************************************************//
dw_Jogun.Settransobject(sqlca)
dw_Select.Settransobject(sqlca)
dw_Insert.Settransobject(sqlca)

p_can.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sal_01011
integer x = 297
integer y = 1116
integer width = 4018
integer height = 1164
string dataobject = "d_sal_01011_02"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String sNull, sCol_Name 
Long   lHapCnt = 0, i
long la1,la2,la3,la4,la5,la6,la7,la8,la9,la10,currow
sCol_Name = This.GetColumnName()
SetNull(sNull)

lHapCnt = wf_col_sum(sCol_Name)

Choose Case sCol_Name
	Case "sales_emp_cnt_1"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt1", lHapCnt)
	Case "sales_emp_cnt_2"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt2", lHapCnt)
	Case "sales_emp_cnt_3"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt3", lHapCnt)
	Case "sales_emp_cnt_4"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt4", lHapCnt)
		
	Case "sales_emp_cnt_5"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt5", lHapCnt)

	Case "sales_emp_cnt_6"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt6", lHapCnt)

	Case "sales_emp_cnt_7"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt7", lHapCnt)

	Case "sales_emp_cnt_8"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt8", lHapCnt)

	Case "sales_emp_cnt_9"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt9", lHapCnt)

	Case "sales_emp_cnt_10"
      dw_Select.SetItem(dw_Select.GetRow(), "emp_cnt10", lHapCnt)
end Choose



end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sal_01011
boolean visible = false
integer x = 3625
integer y = 2672
end type

type p_addrow from w_inherite`p_addrow within w_sal_01011
boolean visible = false
integer x = 3451
integer y = 2672
end type

type p_search from w_inherite`p_search within w_sal_01011
boolean visible = false
integer x = 2757
integer y = 2672
end type

event p_search::clicked;call super::clicked;String  sYear, sMonth, sJYear, sSabu, sSteam
Integer cnt, iMonth, i
Long    CurRow, lEmpCnt1=0, lEmpCnt2=0, lEmpCnt3=0, lEmpCnt4=0, lEmpCnt5=0, &
        lEmpCnt6=0, lEmpCnt7=0, lEmpCnt8=0, lEmpCnt9=0, lEmpCnt10=0, &
		  lEmpCnt_1=0, lEmpCnt_2=0, lEmpCnt_3=0, lEmpCnt_4=0, lEmpCnt_5=0, &
		  lEmpCnt_6=0, lEmpCnt_7=0, lEmpCnt_8=0, lEmpCnt_9=0, lEmpCnt_10=0

If dw_Jogun.AcceptText() <> 1 Then Return

sYear = dw_Jogun.GetItemString(1, "sales_yy")

if sYear = '' or isNull(sYear) or Len(Trim(sYear)) <> 4 then
	f_Message_Chk(35, '[수립년도]')
   dw_Jogun.SetColumn("sales_yy")
	dw_jogun.SetFocus()
	return 1
end if

//관할구역별 장기판매계획 수립여부 Check
Select Count(*) into :cnt From LongPlanSarea
 Where sabu = :gs_sabu and setup_Year = :sYear;

if (cnt = 0) or isNull(cnt) then
	beep(1)
  	MessageBox('확 인', '해당 수립년도의 관할구역별 장기판매계획을' + '~r~r' + &
                       '먼저 수립하시고 인원계획을 수립하세요!!!')
   cb_can.TriggerEvent(Clicked!)
	return 1
end if

sJYear = String(Integer(sYear) - 1)
sMonth = Mid(f_today(),5,2)
iMonth = Integer(sMonth)

// 영업팀별 영업사원수가 해당 수립년도에 존재하는지 Check
Select Count(*) into :cnt From LongPlanSteam
Where sabu = :gs_sabu and setup_Year = :sYear;

if (cnt = 0) or isNull(cnt) then
	// 존재하지 않으면(신규 계획수립일 경우)
  	MessageBox('확 인', '해당 수립년도의 영업사원수계획을' + '~r' + &
                       '신규로 등록하세요')

	if	wf_update(syear) <> 1 then
		Return
	end if

else
	// 존재하면(이미 계획수립이 되어 있으면)
  	MessageBox('확 인', '해당 수립년도의 영업사원 계획이' + '~r' + &
                       '이미 수립되어 있습니다' + '~r~r' + &
  							  '영업사원수를 조정할 수 있습니다.')
								 
End If  

SetPointer(HourGlass!)			
st_gubun.Text = '수립계획조정 (수정)'						
dw_Select.DataObject = "d_sal_01011_03"
dw_Select.Settransobject(sqlca)
dw_Select.Retrieve(gs_sabu, syear)
SetPointer(Arrow!)						

sle_msg.Text = '영업팀을 Click하여 해당 관할구역의 영업사원수 계획을 조정하세요'						
dw_Select.SelectRow(0, FALSE)
dw_Select.SetRow(1)
dw_Select.SelectRow(1, TRUE)

dw_Select.AcceptText()

If dw_select.RowCount() > 0 Then
	sSabu = dw_Select.GetItemString(1, "sabu")
	sYear = dw_Select.GetItemString(1, "setup_year")
	sSteam = dw_Select.GetItemString(1, "steamcd")
	lEmpCnt1  = dw_Select.GetItemNumber(1, "emp_cnt1")
	lEmpCnt2  = dw_Select.GetItemNumber(1, "emp_cnt2")
	lEmpCnt3  = dw_Select.GetItemNumber(1, "emp_cnt3")
	lEmpCnt4  = dw_Select.GetItemNumber(1, "emp_cnt4")
	lEmpCnt5  = dw_Select.GetItemNumber(1, "emp_cnt5")
	lEmpCnt6  = dw_Select.GetItemNumber(1, "emp_cnt6")
	lEmpCnt7  = dw_Select.GetItemNumber(1, "emp_cnt7")
	lEmpCnt8  = dw_Select.GetItemNumber(1, "emp_cnt8")
	lEmpCnt9  = dw_Select.GetItemNumber(1, "emp_cnt9")
	lEmpCnt10 = dw_Select.GetItemNumber(1, "emp_cnt10")
End If

dw_Insert.Retrieve(sSabu, sYear, sSteam)

dw_Insert.AcceptText()

for i = 1 to dw_Insert.RowCount()
	lEmpCnt_1  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_1")
	lEmpCnt_2  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_2")
	lEmpCnt_3  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_3")
	lEmpCnt_4  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_4")
	lEmpCnt_5  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_5")
	lEmpCnt_6  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_6")
	lEmpCnt_7  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_7")
	lEmpCnt_8  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_8")
	lEmpCnt_9  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_9")
	lEmpCnt_10 += dw_Insert.GetItemNumber(i, "sales_emp_cnt_10")
next

CurRow = dw_Insert.InsertRow(0)
dw_Insert.SetItem(CurRow, "sabu", sSabu)
dw_Insert.SetItem(CurRow, "setup_year", sYear)
dw_Insert.SetItem(CurRow, "sarea", '99')
dw_Insert.SetItem(CurRow, "sareanm", '관 리')
dw_Insert.SetItem(CurRow, "sales_emp_cnt_1", lEmpCnt1 - lEmpCnt_1)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_2", lEmpCnt2 - lEmpCnt_2)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_3", lEmpCnt3 - lEmpCnt_3)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_4", lEmpCnt4 - lEmpCnt_4)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_5", lEmpCnt5 - lEmpCnt_5)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_6", lEmpCnt6 - lEmpCnt_6)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_7", lEmpCnt7 - lEmpCnt_7)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_8", lEmpCnt8 - lEmpCnt_8)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_9", lEmpCnt9 - lEmpCnt_9)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_10", lEmpCnt10 - lEmpCnt_10)

sle_msg.Text = '관할구역별 인원계획을 등록하세요'
//   dw_Insert.SetColumn('sales_emp_cnt_5')
dw_Insert.SetFocus()	
end event

type p_ins from w_inherite`p_ins within w_sal_01011
boolean visible = false
integer x = 3278
integer y = 2672
end type

type p_exit from w_inherite`p_exit within w_sal_01011
end type

type p_can from w_inherite`p_can within w_sal_01011
end type

event p_can::clicked;call super::clicked;dw_Jogun.Reset()
dw_Select.Reset()
dw_Insert.Reset()

dw_Jogun.Insertrow(0)

st_gubun.Text = ''
w_mdi_frame.sle_msg.Text = '수립년도를 입력하세요.'
dw_Jogun.SetColumn("sales_yy")
dw_jogun.SetFocus()

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_sal_01011
boolean visible = false
integer x = 2930
integer y = 2672
end type

type p_inq from w_inherite`p_inq within w_sal_01011
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String  sYear, sMonth, sJYear, sSabu, sSteam
Integer cnt, iMonth, i
Long    CurRow, lEmpCnt1=0, lEmpCnt2=0, lEmpCnt3=0, lEmpCnt4=0, lEmpCnt5=0, &
        lEmpCnt6=0, lEmpCnt7=0, lEmpCnt8=0, lEmpCnt9=0, lEmpCnt10=0, &
		  lEmpCnt_1=0, lEmpCnt_2=0, lEmpCnt_3=0, lEmpCnt_4=0, lEmpCnt_5=0, &
		  lEmpCnt_6=0, lEmpCnt_7=0, lEmpCnt_8=0, lEmpCnt_9=0, lEmpCnt_10=0

If dw_Jogun.AcceptText() <> 1 Then Return

sYear = dw_Jogun.GetItemString(1, "sales_yy")

if sYear = '' or isNull(sYear) or Len(Trim(sYear)) <> 4 then
	f_Message_Chk(35, '[수립년도]')
   dw_Jogun.SetColumn("sales_yy")
	dw_jogun.SetFocus()
	return 1
end if

//관할구역별 장기판매계획 수립여부 Check
Select Count(*) into :cnt From LongPlanSarea
 Where sabu = :gs_sabu and setup_Year = :sYear;

if (cnt = 0) or isNull(cnt) then
	beep(1)
  	MessageBox('확 인', '해당 수립년도의 관할구역별 장기판매계획을' + '~r~r' + &
                       '먼저 수립하시고 인원계획을 수립하세요!!!')
   p_can.TriggerEvent(Clicked!)
	return 1
end if

sJYear = String(Integer(sYear) - 1)
sMonth = Mid(f_today(),5,2)
iMonth = Integer(sMonth)

// 영업팀별 영업사원수가 해당 수립년도에 존재하는지 Check
Select Count(*) into :cnt From LongPlanSteam
Where sabu = :gs_sabu and setup_Year = :sYear;

if (cnt = 0) or isNull(cnt) then
	// 존재하지 않으면(신규 계획수립일 경우)
  	MessageBox('확 인', '해당 수립년도의 영업사원수계획을' + '~r' + &
                       '신규로 등록하세요')

	if	wf_update(syear) <> 1 then
		Return
	end if

else
	// 존재하면(이미 계획수립이 되어 있으면)
  	MessageBox('확 인', '해당 수립년도의 영업사원 계획이' + '~r' + &
                       '이미 수립되어 있습니다' + '~r~r' + &
  							  '영업사원수를 조정할 수 있습니다.')
								 
End If  

SetPointer(HourGlass!)			
st_gubun.Text = '수립계획조정 (수정)'						
dw_Select.DataObject = "d_sal_01011_03"
dw_Select.Settransobject(sqlca)
dw_Select.Retrieve(gs_sabu, syear)
SetPointer(Arrow!)						

w_mdi_frame.sle_msg.Text = '영업팀을 Click하여 해당 관할구역의 영업사원수 계획을 조정하세요'						
dw_Select.SelectRow(0, FALSE)
dw_Select.SetRow(1)
dw_Select.SelectRow(1, TRUE)

dw_Select.AcceptText()

If dw_select.RowCount() > 0 Then
	sSabu = dw_Select.GetItemString(1, "sabu")
	sYear = dw_Select.GetItemString(1, "setup_year")
	sSteam = dw_Select.GetItemString(1, "steamcd")
	lEmpCnt1  = dw_Select.GetItemNumber(1, "emp_cnt1")
	lEmpCnt2  = dw_Select.GetItemNumber(1, "emp_cnt2")
	lEmpCnt3  = dw_Select.GetItemNumber(1, "emp_cnt3")
	lEmpCnt4  = dw_Select.GetItemNumber(1, "emp_cnt4")
	lEmpCnt5  = dw_Select.GetItemNumber(1, "emp_cnt5")
	lEmpCnt6  = dw_Select.GetItemNumber(1, "emp_cnt6")
	lEmpCnt7  = dw_Select.GetItemNumber(1, "emp_cnt7")
	lEmpCnt8  = dw_Select.GetItemNumber(1, "emp_cnt8")
	lEmpCnt9  = dw_Select.GetItemNumber(1, "emp_cnt9")
	lEmpCnt10 = dw_Select.GetItemNumber(1, "emp_cnt10")
End If

dw_Insert.Retrieve(sSabu, sYear, sSteam)

dw_Insert.AcceptText()

for i = 1 to dw_Insert.RowCount()
	lEmpCnt_1  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_1")
	lEmpCnt_2  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_2")
	lEmpCnt_3  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_3")
	lEmpCnt_4  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_4")
	lEmpCnt_5  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_5")
	lEmpCnt_6  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_6")
	lEmpCnt_7  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_7")
	lEmpCnt_8  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_8")
	lEmpCnt_9  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_9")
	lEmpCnt_10 += dw_Insert.GetItemNumber(i, "sales_emp_cnt_10")
next

CurRow = dw_Insert.InsertRow(0)
dw_Insert.SetItem(CurRow, "sabu", sSabu)
dw_Insert.SetItem(CurRow, "setup_year", sYear)
dw_Insert.SetItem(CurRow, "sarea", '99')
dw_Insert.SetItem(CurRow, "sareanm", '관 리')
dw_Insert.SetItem(CurRow, "sales_emp_cnt_1", lEmpCnt1 - lEmpCnt_1)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_2", lEmpCnt2 - lEmpCnt_2)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_3", lEmpCnt3 - lEmpCnt_3)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_4", lEmpCnt4 - lEmpCnt_4)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_5", lEmpCnt5 - lEmpCnt_5)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_6", lEmpCnt6 - lEmpCnt_6)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_7", lEmpCnt7 - lEmpCnt_7)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_8", lEmpCnt8 - lEmpCnt_8)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_9", lEmpCnt9 - lEmpCnt_9)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_10", lEmpCnt10 - lEmpCnt_10)

w_mdi_frame.sle_msg.Text = '관할구역별 인원계획을 등록하세요'
//   dw_Insert.SetColumn('sales_emp_cnt_5')
dw_Insert.SetFocus()	
end event

type p_del from w_inherite`p_del within w_sal_01011
end type

event p_del::clicked;call super::clicked;String sYear

Beep (1)

sYear = dw_Jogun.GetItemString(1,'sales_yy')

if MessageBox("삭제 확인", sYear + '년도의 영업팀 및 관할구역 인원계획을 삭제합니다.' + '~r~r' + &
									'삭제 하시겠습니까?' &
									,question!,yesno!, 2) = 2 THEN Return

Delete From longplansteam
Where  sabu = :gs_sabu and setup_year = :sYear;

if SQLCA.SQLCODE <> 0 then
   f_Message_Chk(31, '[영업팀 인원계획 삭제]')
	Rollback;
	return
end if

Update longplansarea 
Set    sales_emp_cnt_1 = 0,sales_emp_cnt_2 = 0,sales_emp_cnt_3 = 0,
       sales_emp_cnt_4 = 0,sales_emp_cnt_5 = 0,
		 sales_emp_cnt_6 = 0, sales_emp_cnt_7 = 0, sales_emp_cnt_8 = 0, 
       sales_emp_cnt_9 = 0, sales_emp_cnt_10 = 0
Where  sabu = :gs_sabu and setup_year = :sYear;


if SQLCA.SQLCODE <> 0 then
   f_Message_Chk(31, '[관할구역 인원계획 삭제]')
	Rollback;
	return
end if

Commit;		
messagebox("확인","삭제가 완료되었습니다!")

p_can.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_sal_01011
end type

event p_mod::clicked;call super::clicked;String  sSabu, sYear, sSteam
Long    lCnt1, lCnt2, lCnt3, lCnt4, lCnt5, lCnt6, lCnt7, lCnt8, lCnt9, lCnt10 
Integer i
Long    CurRow, lEmpCnt1=0, lEmpCnt2=0, lEmpCnt3=0, lEmpCnt4=0, lEmpCnt5=0, &
        lEmpCnt6=0, lEmpCnt7=0, lEmpCnt8=0, lEmpCnt9=0, lEmpCnt10=0, &
		  lEmpCnt_1=0, lEmpCnt_2=0, lEmpCnt_3=0, lEmpCnt_4=0, lEmpCnt_5=0, &
		  lEmpCnt_6=0, lEmpCnt_7=0, lEmpCnt_8=0, lEmpCnt_9=0, lEmpCnt_10=0
long la1,la2,la3,la4,la5,la6,la7,la8,la9,la10,lrow,lcount
setpointer(hourglass!)
w_mdi_frame.sle_msg.Text = '영업팀별 인원계획 저장중......'
If dw_Select.AcceptText() <> 1 Then Return 

CurRow = dw_Select.GetRow()
If CurRow <= 0 Then Return

lrow=dw_insert.getrow()
lcount=dw_insert.rowcount()

if lrow= lcount then
	lrow=lrow - 1
	dw_insert.setrow(lrow)
elseif lrow=0 then
	return
else
	lrow=lrow + 1
	dw_insert.setrow(lrow)
end if

la1=dw_insert.getitemnumber(1,"a1")
la2=dw_insert.getitemnumber(1,"a2")
la3=dw_insert.getitemnumber(1,"a3")
la4=dw_insert.getitemnumber(1,"a4")
la5=dw_insert.getitemnumber(1,"a5")
la6=dw_insert.getitemnumber(1,"a6")
la7=dw_insert.getitemnumber(1,"a7")
la8=dw_insert.getitemnumber(1,"a8")
la9=dw_insert.getitemnumber(1,"a9")
la10=dw_insert.getitemnumber(1,"a10")


dw_select.setitem(currow,"emp_cnt1",la1)
dw_select.setitem(currow,"emp_cnt2",la2)
dw_select.setitem(currow,"emp_cnt3",la3)
dw_select.setitem(currow,"emp_cnt4",la4)
dw_select.setitem(currow,"emp_cnt5",la5)
dw_select.setitem(currow,"emp_cnt6",la6)
dw_select.setitem(currow,"emp_cnt7",la7)
dw_select.setitem(currow,"emp_cnt8",la8)
dw_select.setitem(currow,"emp_cnt9",la9)
dw_select.setitem(currow,"emp_cnt10",la10)

commit using sqlca;

if dw_insert.rowcount()=1 then
	dw_insert.insertrow(1)
   commit using sqlca;
end if

for i = 1 to dw_Select.RowCount()
   sSabu = dw_Select.GetItemString(i, "sabu")
	sYear = dw_Select.GetItemString(i, "setup_year")
	sSteam = dw_Select.GetItemString(i, "steamcd")
	lCnt1  = dw_Select.GetItemNumber(i, "emp_cnt1")
	lCnt2  = dw_Select.GetItemNumber(i, "emp_cnt2")
	lCnt3  = dw_Select.GetItemNumber(i, "emp_cnt3")
	lCnt4  = dw_Select.GetItemNumber(i, "emp_cnt4")
	lCnt5  = dw_Select.GetItemNumber(i, "emp_cnt5")
	lCnt6  = dw_Select.GetItemNumber(i, "emp_cnt6")
	lCnt7  = dw_Select.GetItemNumber(i, "emp_cnt7")
	lCnt8  = dw_Select.GetItemNumber(i, "emp_cnt8")
	lCnt9  = dw_Select.GetItemNumber(i, "emp_cnt9")
	lCnt10 = dw_Select.GetItemNumber(i, "emp_cnt10")
	
	sYear = dw_Jogun.GetItemString(1, "sales_yy")
	
   if Right(st_gubun.Text,1) = '0' then
	   Insert Into 
	      longplansteam(sabu, setup_year, steamcd, sales_emp_cnt_1, sales_emp_cnt_2, 
		                 sales_emp_cnt_3, sales_emp_cnt_4, sales_emp_cnt_5, sales_emp_cnt_6, 
				   		  sales_emp_cnt_7, sales_emp_cnt_8, sales_emp_cnt_9, sales_emp_cnt_10)
   	Values(:sSabu, :sYear, :sSteam, :lCnt1, :lCnt2, 
		       :lCnt3, :lCnt4, :lCnt5, :lCnt6,
				 :lCnt7, :lCnt8, :lCnt9, :lCnt10);
				 
		if SQLCA.Sqlcode < 0 then
         f_message_Chk(32,'[영업팀별 인원계획 신규저장]')
      	Rollback;
			SetPointer(Arrow!)
      	return			
		end if
   else
	   Update longplansteam 
		Set    sales_emp_cnt_1 = :lCnt1,  sales_emp_cnt_2 = :lCnt2,  sales_emp_cnt_3 = :lCnt3,
		       sales_emp_cnt_4 = :lCnt4,  sales_emp_cnt_5 = :lCnt5,  sales_emp_cnt_6 = :lCnt6,
				 sales_emp_cnt_7 = :lCnt7,  sales_emp_cnt_8 = :lCnt8,  sales_emp_cnt_9 = :lCnt9,
				 sales_emp_cnt_10 = :lCnt10
		Where  sabu = :sSabu and setup_year = :sYear and steamcd = :sSteam;

		if SQLCA.Sqlcode < 0 then
         f_message_Chk(32,'[영업팀별 인원계획 수정저장]')
      	Rollback;
			SetPointer(Arrow!)
      	return			
		end if	
   end if		
next

w_mdi_frame.sle_msg.Text = '관할구역별 인원계획 저장중......'
dw_Insert.AcceptText()
dw_Insert.DeleteRow(dw_Insert.RowCount())

if dw_Insert.Update() = -1 then  
   f_message_Chk(32,'[관할구역별 인원계획 저장]')
	Rollback;
	return
end if

Commit;
f_message_Chk(202,'[인원계획 저장완료]')

st_gubun.Text = '수립계획조정 1'
dw_Select.DataObject = "d_sal_01011_03"
dw_Select.Settransobject(sqlca)	  

dw_Select.Retrieve(gs_sabu, syear)

w_mdi_frame.sle_msg.Text = '영업팀을 Click하여 해당 관할구역의 영업사원수 계획을 조정하세요'						
dw_Select.SelectRow(0, FALSE)
dw_Select.SetRow(CurRow)
dw_Select.SelectRow(CurRow, TRUE)



dw_Select.AcceptText()

sSabu = dw_Select.GetItemString(CurRow, "sabu")
sYear = dw_Select.GetItemString(CurRow, "setup_year")
sSteam = dw_Select.GetItemString(CurRow, "steamcd")
lEmpCnt1  = dw_Select.GetItemNumber(CurRow, "emp_cnt1")
lEmpCnt2  = dw_Select.GetItemNumber(CurRow, "emp_cnt2")
lEmpCnt3  = dw_Select.GetItemNumber(CurRow, "emp_cnt3")
lEmpCnt4  = dw_Select.GetItemNumber(CurRow, "emp_cnt4")
lEmpCnt5  = dw_Select.GetItemNumber(CurRow, "emp_cnt5")
lEmpCnt6  = dw_Select.GetItemNumber(CurRow, "emp_cnt6")
lEmpCnt7  = dw_Select.GetItemNumber(CurRow, "emp_cnt7")
lEmpCnt8  = dw_Select.GetItemNumber(CurRow, "emp_cnt8")
lEmpCnt9  = dw_Select.GetItemNumber(CurRow, "emp_cnt9")
lEmpCnt10 = dw_Select.GetItemNumber(CurRow, "emp_cnt10")
	
sYear = dw_Jogun.GetItemString(1, "sales_yy")
dw_Insert.Retrieve(sSabu, sYear, sSteam)
dw_Insert.AcceptText()
for i = 1 to dw_Insert.RowCount()
 	lEmpCnt_1  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_1")
   lEmpCnt_2  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_2")
   lEmpCnt_3  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_3")
   lEmpCnt_4  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_4")
   lEmpCnt_5  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_5")
   lEmpCnt_6  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_6")
   lEmpCnt_7  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_7")
   lEmpCnt_8  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_8")
  	lEmpCnt_9  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_9")
   lEmpCnt_10 += dw_Insert.GetItemNumber(i, "sales_emp_cnt_10")
next

CurRow = dw_Insert.InsertRow(0)
dw_Insert.SetItem(CurRow, "sabu", sSabu)
dw_Insert.SetItem(CurRow, "setup_year", sYear)
dw_Insert.SetItem(CurRow, "sarea", '99')
dw_Insert.SetItem(CurRow, "sareanm", '관 리')
dw_Insert.SetItem(CurRow, "sales_emp_cnt_1", lEmpCnt1 - lEmpCnt_1)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_2", lEmpCnt2 - lEmpCnt_2)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_3", lEmpCnt3 - lEmpCnt_3)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_4", lEmpCnt4 - lEmpCnt_4)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_5", lEmpCnt5 - lEmpCnt_5)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_6", lEmpCnt6 - lEmpCnt_6)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_7", lEmpCnt7 - lEmpCnt_7)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_8", lEmpCnt8 - lEmpCnt_8)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_9", lEmpCnt9 - lEmpCnt_9)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_10", lEmpCnt10 - lEmpCnt_10)

w_mdi_frame.sle_msg.Text = '관할구역별 인원계획을 등록하세요'
dw_Insert.SetColumn('sales_emp_cnt_5')
dw_Insert.SetFocus()	

SetPointer(Arrow!)

ib_any_typing = False
end event

type cb_exit from w_inherite`cb_exit within w_sal_01011
integer x = 2135
integer y = 2712
integer width = 384
integer taborder = 150
end type

type cb_mod from w_inherite`cb_mod within w_sal_01011
integer x = 869
integer y = 2712
integer width = 384
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;//String  sSabu, sYear, sSteam
//Long    lCnt1, lCnt2, lCnt3, lCnt4, lCnt5, lCnt6, lCnt7, lCnt8, lCnt9, lCnt10 
//Integer i
//Long    CurRow, lEmpCnt1=0, lEmpCnt2=0, lEmpCnt3=0, lEmpCnt4=0, lEmpCnt5=0, &
//        lEmpCnt6=0, lEmpCnt7=0, lEmpCnt8=0, lEmpCnt9=0, lEmpCnt10=0, &
//		  lEmpCnt_1=0, lEmpCnt_2=0, lEmpCnt_3=0, lEmpCnt_4=0, lEmpCnt_5=0, &
//		  lEmpCnt_6=0, lEmpCnt_7=0, lEmpCnt_8=0, lEmpCnt_9=0, lEmpCnt_10=0
//long la1,la2,la3,la4,la5,la6,la7,la8,la9,la10,lrow,lcount
//setpointer(hourglass!)
//sle_msg.Text = '영업팀별 인원계획 저장중......'
//If dw_Select.AcceptText() <> 1 Then Return 
//
//CurRow = dw_Select.GetRow()
//If CurRow <= 0 Then Return
//
//lrow=dw_insert.getrow()
//lcount=dw_insert.rowcount()
//
//if lrow= lcount then
//	lrow=lrow - 1
//	dw_insert.setrow(lrow)
//elseif lrow=0 then
//	return
//else
//	lrow=lrow + 1
//	dw_insert.setrow(lrow)
//end if
//
//la1=dw_insert.getitemnumber(1,"a1")
//la2=dw_insert.getitemnumber(1,"a2")
//la3=dw_insert.getitemnumber(1,"a3")
//la4=dw_insert.getitemnumber(1,"a4")
//la5=dw_insert.getitemnumber(1,"a5")
//la6=dw_insert.getitemnumber(1,"a6")
//la7=dw_insert.getitemnumber(1,"a7")
//la8=dw_insert.getitemnumber(1,"a8")
//la9=dw_insert.getitemnumber(1,"a9")
//la10=dw_insert.getitemnumber(1,"a10")
//
//
//dw_select.setitem(currow,"emp_cnt1",la1)
//dw_select.setitem(currow,"emp_cnt2",la2)
//dw_select.setitem(currow,"emp_cnt3",la3)
//dw_select.setitem(currow,"emp_cnt4",la4)
//dw_select.setitem(currow,"emp_cnt5",la5)
//dw_select.setitem(currow,"emp_cnt6",la6)
//dw_select.setitem(currow,"emp_cnt7",la7)
//dw_select.setitem(currow,"emp_cnt8",la8)
//dw_select.setitem(currow,"emp_cnt9",la9)
//dw_select.setitem(currow,"emp_cnt10",la10)
//
//commit using sqlca;
//
//if dw_insert.rowcount()=1 then
//	dw_insert.insertrow(1)
//   commit using sqlca;
//end if
//
//for i = 1 to dw_Select.RowCount()
//   sSabu = dw_Select.GetItemString(i, "sabu")
//	sYear = dw_Select.GetItemString(i, "setup_year")
//	sSteam = dw_Select.GetItemString(i, "steamcd")
//	lCnt1  = dw_Select.GetItemNumber(i, "emp_cnt1")
//	lCnt2  = dw_Select.GetItemNumber(i, "emp_cnt2")
//	lCnt3  = dw_Select.GetItemNumber(i, "emp_cnt3")
//	lCnt4  = dw_Select.GetItemNumber(i, "emp_cnt4")
//	lCnt5  = dw_Select.GetItemNumber(i, "emp_cnt5")
//	lCnt6  = dw_Select.GetItemNumber(i, "emp_cnt6")
//	lCnt7  = dw_Select.GetItemNumber(i, "emp_cnt7")
//	lCnt8  = dw_Select.GetItemNumber(i, "emp_cnt8")
//	lCnt9  = dw_Select.GetItemNumber(i, "emp_cnt9")
//	lCnt10 = dw_Select.GetItemNumber(i, "emp_cnt10")
//	
//	sYear = dw_Jogun.GetItemString(1, "sales_yy")
//	
//   if Right(st_gubun.Text,1) = '0' then
//	   Insert Into 
//	      longplansteam(sabu, setup_year, steamcd, sales_emp_cnt_1, sales_emp_cnt_2, 
//		                 sales_emp_cnt_3, sales_emp_cnt_4, sales_emp_cnt_5, sales_emp_cnt_6, 
//				   		  sales_emp_cnt_7, sales_emp_cnt_8, sales_emp_cnt_9, sales_emp_cnt_10)
//   	Values(:sSabu, :sYear, :sSteam, :lCnt1, :lCnt2, 
//		       :lCnt3, :lCnt4, :lCnt5, :lCnt6,
//				 :lCnt7, :lCnt8, :lCnt9, :lCnt10);
//				 
//		if SQLCA.Sqlcode < 0 then
//         f_message_Chk(32,'[영업팀별 인원계획 신규저장]')
//      	Rollback;
//			SetPointer(Arrow!)
//      	return			
//		end if
//   else
//	   Update longplansteam 
//		Set    sales_emp_cnt_1 = :lCnt1,  sales_emp_cnt_2 = :lCnt2,  sales_emp_cnt_3 = :lCnt3,
//		       sales_emp_cnt_4 = :lCnt4,  sales_emp_cnt_5 = :lCnt5,  sales_emp_cnt_6 = :lCnt6,
//				 sales_emp_cnt_7 = :lCnt7,  sales_emp_cnt_8 = :lCnt8,  sales_emp_cnt_9 = :lCnt9,
//				 sales_emp_cnt_10 = :lCnt10
//		Where  sabu = :sSabu and setup_year = :sYear and steamcd = :sSteam;
//
//		if SQLCA.Sqlcode < 0 then
//         f_message_Chk(32,'[영업팀별 인원계획 수정저장]')
//      	Rollback;
//			SetPointer(Arrow!)
//      	return			
//		end if	
//   end if		
//next
//
//sle_msg.Text = '관할구역별 인원계획 저장중......'
//dw_Insert.AcceptText()
//dw_Insert.DeleteRow(dw_Insert.RowCount())
//
//if dw_Insert.Update() = -1 then  
//   f_message_Chk(32,'[관할구역별 인원계획 저장]')
//	Rollback;
//	return
//end if
//
//Commit;
//f_message_Chk(202,'[인원계획 저장완료]')
//
//st_gubun.Text = '수립계획조정 1'
//dw_Select.DataObject = "d_sal_01011_03"
//dw_Select.Settransobject(sqlca)	  
//
//dw_Select.Retrieve(gs_sabu, syear)
//
//sle_msg.Text = '영업팀을 Click하여 해당 관할구역의 영업사원수 계획을 조정하세요'						
//dw_Select.SelectRow(0, FALSE)
//dw_Select.SetRow(CurRow)
//dw_Select.SelectRow(CurRow, TRUE)
//
//
//
//dw_Select.AcceptText()
//
//sSabu = dw_Select.GetItemString(CurRow, "sabu")
//sYear = dw_Select.GetItemString(CurRow, "setup_year")
//sSteam = dw_Select.GetItemString(CurRow, "steamcd")
//lEmpCnt1  = dw_Select.GetItemNumber(CurRow, "emp_cnt1")
//lEmpCnt2  = dw_Select.GetItemNumber(CurRow, "emp_cnt2")
//lEmpCnt3  = dw_Select.GetItemNumber(CurRow, "emp_cnt3")
//lEmpCnt4  = dw_Select.GetItemNumber(CurRow, "emp_cnt4")
//lEmpCnt5  = dw_Select.GetItemNumber(CurRow, "emp_cnt5")
//lEmpCnt6  = dw_Select.GetItemNumber(CurRow, "emp_cnt6")
//lEmpCnt7  = dw_Select.GetItemNumber(CurRow, "emp_cnt7")
//lEmpCnt8  = dw_Select.GetItemNumber(CurRow, "emp_cnt8")
//lEmpCnt9  = dw_Select.GetItemNumber(CurRow, "emp_cnt9")
//lEmpCnt10 = dw_Select.GetItemNumber(CurRow, "emp_cnt10")
//	
//sYear = dw_Jogun.GetItemString(1, "sales_yy")
//dw_Insert.Retrieve(sSabu, sYear, sSteam)
//dw_Insert.AcceptText()
//for i = 1 to dw_Insert.RowCount()
// 	lEmpCnt_1  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_1")
//   lEmpCnt_2  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_2")
//   lEmpCnt_3  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_3")
//   lEmpCnt_4  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_4")
//   lEmpCnt_5  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_5")
//   lEmpCnt_6  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_6")
//   lEmpCnt_7  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_7")
//   lEmpCnt_8  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_8")
//  	lEmpCnt_9  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_9")
//   lEmpCnt_10 += dw_Insert.GetItemNumber(i, "sales_emp_cnt_10")
//next
//
//CurRow = dw_Insert.InsertRow(0)
//dw_Insert.SetItem(CurRow, "sabu", sSabu)
//dw_Insert.SetItem(CurRow, "setup_year", sYear)
//dw_Insert.SetItem(CurRow, "sarea", '99')
//dw_Insert.SetItem(CurRow, "sareanm", '관 리')
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_1", lEmpCnt1 - lEmpCnt_1)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_2", lEmpCnt2 - lEmpCnt_2)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_3", lEmpCnt3 - lEmpCnt_3)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_4", lEmpCnt4 - lEmpCnt_4)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_5", lEmpCnt5 - lEmpCnt_5)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_6", lEmpCnt6 - lEmpCnt_6)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_7", lEmpCnt7 - lEmpCnt_7)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_8", lEmpCnt8 - lEmpCnt_8)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_9", lEmpCnt9 - lEmpCnt_9)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_10", lEmpCnt10 - lEmpCnt_10)
//
//sle_msg.Text = '관할구역별 인원계획을 등록하세요'
//dw_Insert.SetColumn('sales_emp_cnt_5')
//dw_Insert.SetFocus()	
//
//SetPointer(Arrow!)
//
//ib_any_typing = False
end event

type cb_ins from w_inherite`cb_ins within w_sal_01011
integer x = 1317
integer y = 2396
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_sal_01011
integer x = 1294
integer y = 2712
integer width = 384
integer taborder = 100
end type

event cb_del::clicked;call super::clicked;//String sYear
//
//Beep (1)
//
//sYear = dw_Jogun.GetItemString(1,'sales_yy')
//
//if MessageBox("삭제 확인", sYear + '년도의 영업팀 및 관할구역 인원계획을 삭제합니다.' + '~r~r' + &
//									'삭제 하시겠습니까?' &
//									,question!,yesno!, 2) = 2 THEN Return
//
//Delete From longplansteam
//Where  sabu = :gs_sabu and setup_year = :sYear;
//
//if SQLCA.SQLCODE <> 0 then
//   f_Message_Chk(31, '[영업팀 인원계획 삭제]')
//	Rollback;
//	return
//end if
//
//Update longplansarea 
//Set    sales_emp_cnt_1 = 0,sales_emp_cnt_2 = 0,sales_emp_cnt_3 = 0,
//       sales_emp_cnt_4 = 0,sales_emp_cnt_5 = 0,
//		 sales_emp_cnt_6 = 0, sales_emp_cnt_7 = 0, sales_emp_cnt_8 = 0, 
//       sales_emp_cnt_9 = 0, sales_emp_cnt_10 = 0
//Where  sabu = :gs_sabu and setup_year = :sYear;
//
//
//if SQLCA.SQLCODE <> 0 then
//   f_Message_Chk(31, '[관할구역 인원계획 삭제]')
//	Rollback;
//	return
//end if
//
//Commit;		
//messagebox("확인","삭제가 완료되었습니다!")
//
//cb_can.TriggerEvent(Clicked!)
end event

type cb_inq from w_inherite`cb_inq within w_sal_01011
integer x = 352
integer y = 2720
integer width = 384
integer taborder = 110
end type

event cb_inq::clicked;call super::clicked;//String  sYear, sMonth, sJYear, sSabu, sSteam
//Integer cnt, iMonth, i
//Long    CurRow, lEmpCnt1=0, lEmpCnt2=0, lEmpCnt3=0, lEmpCnt4=0, lEmpCnt5=0, &
//        lEmpCnt6=0, lEmpCnt7=0, lEmpCnt8=0, lEmpCnt9=0, lEmpCnt10=0, &
//		  lEmpCnt_1=0, lEmpCnt_2=0, lEmpCnt_3=0, lEmpCnt_4=0, lEmpCnt_5=0, &
//		  lEmpCnt_6=0, lEmpCnt_7=0, lEmpCnt_8=0, lEmpCnt_9=0, lEmpCnt_10=0
//
//If dw_Jogun.AcceptText() <> 1 Then Return
//
//sYear = dw_Jogun.GetItemString(1, "sales_yy")
//
//if sYear = '' or isNull(sYear) or Len(Trim(sYear)) <> 4 then
//	f_Message_Chk(35, '[수립년도]')
//   dw_Jogun.SetColumn("sales_yy")
//	dw_jogun.SetFocus()
//	return 1
//end if
//
////관할구역별 장기판매계획 수립여부 Check
//Select Count(*) into :cnt From LongPlanSarea
// Where sabu = :gs_sabu and setup_Year = :sYear;
//
//if (cnt = 0) or isNull(cnt) then
//	beep(1)
//  	MessageBox('확 인', '해당 수립년도의 관할구역별 장기판매계획을' + '~r~r' + &
//                       '먼저 수립하시고 인원계획을 수립하세요!!!')
//   cb_can.TriggerEvent(Clicked!)
//	return 1
//end if
//
//sJYear = String(Integer(sYear) - 1)
//sMonth = Mid(f_today(),5,2)
//iMonth = Integer(sMonth)
//
//// 영업팀별 영업사원수가 해당 수립년도에 존재하는지 Check
//Select Count(*) into :cnt From LongPlanSteam
//Where sabu = :gs_sabu and setup_Year = :sYear;
//
//if (cnt = 0) or isNull(cnt) then
//	// 존재하지 않으면(신규 계획수립일 경우)
//  	MessageBox('확 인', '해당 수립년도의 영업사원수계획을' + '~r' + &
//                       '신규로 등록하세요')
//
//	if	wf_update(syear) <> 1 then
//		Return
//	end if
//
//else
//	// 존재하면(이미 계획수립이 되어 있으면)
//  	MessageBox('확 인', '해당 수립년도의 영업사원 계획이' + '~r' + &
//                       '이미 수립되어 있습니다' + '~r~r' + &
//  							  '영업사원수를 조정할 수 있습니다.')
//								 
//End If  
//
//SetPointer(HourGlass!)			
//st_gubun.Text = '수립계획조정 (수정)'						
//dw_Select.DataObject = "d_sal_01011_03"
//dw_Select.Settransobject(sqlca)
//dw_Select.Retrieve(gs_sabu, syear)
//SetPointer(Arrow!)						
//
//sle_msg.Text = '영업팀을 Click하여 해당 관할구역의 영업사원수 계획을 조정하세요'						
//dw_Select.SelectRow(0, FALSE)
//dw_Select.SetRow(1)
//dw_Select.SelectRow(1, TRUE)
//
//dw_Select.AcceptText()
//
//If dw_select.RowCount() > 0 Then
//	sSabu = dw_Select.GetItemString(1, "sabu")
//	sYear = dw_Select.GetItemString(1, "setup_year")
//	sSteam = dw_Select.GetItemString(1, "steamcd")
//	lEmpCnt1  = dw_Select.GetItemNumber(1, "emp_cnt1")
//	lEmpCnt2  = dw_Select.GetItemNumber(1, "emp_cnt2")
//	lEmpCnt3  = dw_Select.GetItemNumber(1, "emp_cnt3")
//	lEmpCnt4  = dw_Select.GetItemNumber(1, "emp_cnt4")
//	lEmpCnt5  = dw_Select.GetItemNumber(1, "emp_cnt5")
//	lEmpCnt6  = dw_Select.GetItemNumber(1, "emp_cnt6")
//	lEmpCnt7  = dw_Select.GetItemNumber(1, "emp_cnt7")
//	lEmpCnt8  = dw_Select.GetItemNumber(1, "emp_cnt8")
//	lEmpCnt9  = dw_Select.GetItemNumber(1, "emp_cnt9")
//	lEmpCnt10 = dw_Select.GetItemNumber(1, "emp_cnt10")
//End If
//
//dw_Insert.Retrieve(sSabu, sYear, sSteam)
//
//dw_Insert.AcceptText()
//
//for i = 1 to dw_Insert.RowCount()
//	lEmpCnt_1  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_1")
//	lEmpCnt_2  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_2")
//	lEmpCnt_3  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_3")
//	lEmpCnt_4  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_4")
//	lEmpCnt_5  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_5")
//	lEmpCnt_6  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_6")
//	lEmpCnt_7  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_7")
//	lEmpCnt_8  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_8")
//	lEmpCnt_9  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_9")
//	lEmpCnt_10 += dw_Insert.GetItemNumber(i, "sales_emp_cnt_10")
//next
//
//CurRow = dw_Insert.InsertRow(0)
//dw_Insert.SetItem(CurRow, "sabu", sSabu)
//dw_Insert.SetItem(CurRow, "setup_year", sYear)
//dw_Insert.SetItem(CurRow, "sarea", '99')
//dw_Insert.SetItem(CurRow, "sareanm", '관 리')
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_1", lEmpCnt1 - lEmpCnt_1)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_2", lEmpCnt2 - lEmpCnt_2)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_3", lEmpCnt3 - lEmpCnt_3)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_4", lEmpCnt4 - lEmpCnt_4)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_5", lEmpCnt5 - lEmpCnt_5)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_6", lEmpCnt6 - lEmpCnt_6)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_7", lEmpCnt7 - lEmpCnt_7)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_8", lEmpCnt8 - lEmpCnt_8)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_9", lEmpCnt9 - lEmpCnt_9)
//dw_Insert.SetItem(CurRow, "sales_emp_cnt_10", lEmpCnt10 - lEmpCnt_10)
//
//sle_msg.Text = '관할구역별 인원계획을 등록하세요'
////   dw_Insert.SetColumn('sales_emp_cnt_5')
//dw_Insert.SetFocus()	
end event

type cb_print from w_inherite`cb_print within w_sal_01011
integer x = 1774
integer y = 2392
integer taborder = 120
end type

type st_1 from w_inherite`st_1 within w_sal_01011
end type

type cb_can from w_inherite`cb_can within w_sal_01011
integer x = 1714
integer y = 2712
integer width = 384
integer taborder = 130
end type

event cb_can::clicked;call super::clicked;//dw_Jogun.Reset()
//dw_Select.Reset()
//dw_Insert.Reset()
//
//dw_Jogun.Insertrow(0)
//
//st_gubun.Text = ''
//sle_msg.Text = '수립년도를 입력하세요.'
//dw_Jogun.SetColumn("sales_yy")
//dw_jogun.SetFocus()
//
//ib_any_typing = False
end event

type cb_search from w_inherite`cb_search within w_sal_01011
integer x = 2167
integer y = 2400
integer taborder = 140
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01011
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01011
end type

type gb_5 from groupbox within w_sal_01011
boolean visible = false
integer x = 818
integer y = 2656
integer width = 1746
integer height = 200
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_4 from groupbox within w_sal_01011
boolean visible = false
integer x = 302
integer y = 2664
integer width = 485
integer height = 200
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_sal_01011
integer x = 288
integer y = 1048
integer width = 4032
integer height = 1244
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "[ 관 할 구 역 ]"
borderstyle borderstyle = styleraised!
end type

type dw_jogun from datawindow within w_sal_01011
integer x = 265
integer y = 64
integer width = 1609
integer height = 196
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_sal_01011"
boolean border = false
boolean livescroll = true
end type

event itemchanged;call super::itemchanged;String sYear

if This.GetColumnName() = 'sales_yy' then
	sYear = this.GetText()
	if sYear = '' or isNull(sYear) or Len(sYear) <> 4 then
   	f_Message_Chk(35, '[수립년도]')
      dw_Jogun.SetColumn("sales_yy")
   	dw_jogun.SetFocus()
	   return 1		
	end if
	p_inq.TriggerEvent(Clicked!)
end if


end event

event itemerror;return 1
end event

type dw_select from u_key_enter within w_sal_01011
integer x = 297
integer y = 396
integer width = 4018
integer height = 584
integer taborder = 30
string dataobject = "d_sal_01011_03"
boolean vscrollbar = true
boolean border = false
end type

event dw_select::clicked;call super::clicked;// Row 선택시 파란색으로 선택표시
if row > 0 then
   dw_select.SelectRow(0, False)
   dw_select.SelectRow(row, true)
else
	return
end if

String  sSabu, sYear, sSteam
Integer i
Long    CurRow, lEmpCnt1=0, lEmpCnt2=0, lEmpCnt3=0, lEmpCnt4=0, lEmpCnt5=0, &
        lEmpCnt6=0, lEmpCnt7=0, lEmpCnt8=0, lEmpCnt9=0, lEmpCnt10=0, &
		  lEmpCnt_1=0, lEmpCnt_2=0, lEmpCnt_3=0, lEmpCnt_4=0, lEmpCnt_5=0, &
		  lEmpCnt_6=0, lEmpCnt_7=0, lEmpCnt_8=0, lEmpCnt_9=0, lEmpCnt_10=0

dw_Select.AcceptText()

sSabu = dw_Select.GetItemString(row, "sabu")
sYear = dw_Select.GetItemString(row, "setup_year")
sSteam = dw_Select.GetItemString(row, "steamcd")
lEmpCnt1  = dw_Select.GetItemNumber(row, "emp_cnt1")
lEmpCnt2  = dw_Select.GetItemNumber(row, "emp_cnt2")
lEmpCnt3  = dw_Select.GetItemNumber(row, "emp_cnt3")
lEmpCnt4  = dw_Select.GetItemNumber(row, "emp_cnt4")
lEmpCnt5  = dw_Select.GetItemNumber(row, "emp_cnt5")
lEmpCnt6  = dw_Select.GetItemNumber(row, "emp_cnt6")
lEmpCnt7  = dw_Select.GetItemNumber(row, "emp_cnt7")
lEmpCnt8  = dw_Select.GetItemNumber(row, "emp_cnt8")
lEmpCnt9  = dw_Select.GetItemNumber(row, "emp_cnt9")
lEmpCnt10 = dw_Select.GetItemNumber(row, "emp_cnt10")

sYear = dw_Jogun.GetItemString(1, "sales_yy")

IF dw_Insert.retrieve(sSabu, sYear, sSteam) = -1 THEN
	f_Message_Chk(33, '[자료 확인]')
	dw_Insert.Reset()
   dw_Insert.InsertRow(0)
	dw_Select.Setfocus()
   return
END IF

dw_Insert.AcceptText()
for i = 1 to dw_Insert.RowCount()
	lEmpCnt_1  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_1")
	lEmpCnt_2  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_2")
	lEmpCnt_3  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_3")
	lEmpCnt_4  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_4")
	lEmpCnt_5  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_5")
	lEmpCnt_6  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_6")
	lEmpCnt_7  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_7")
	lEmpCnt_8  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_8")
	lEmpCnt_9  += dw_Insert.GetItemNumber(i, "sales_emp_cnt_9")
	lEmpCnt_10 += dw_Insert.GetItemNumber(i, "sales_emp_cnt_10")
next

CurRow = dw_Insert.InsertRow(0)
dw_Insert.SetItem(CurRow, "sabu", sSabu)
dw_Insert.SetItem(CurRow, "setup_year", sYear)
dw_Insert.SetItem(CurRow, "sarea", '99')
dw_Insert.SetItem(CurRow, "sareanm", '관 리')
dw_Insert.SetItem(CurRow, "sales_emp_cnt_1", lEmpCnt1 - lEmpCnt_1)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_2", lEmpCnt2 - lEmpCnt_2)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_3", lEmpCnt3 - lEmpCnt_3)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_4", lEmpCnt4 - lEmpCnt_4)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_5", lEmpCnt5 - lEmpCnt_5)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_6", lEmpCnt6 - lEmpCnt_6)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_7", lEmpCnt7 - lEmpCnt_7)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_8", lEmpCnt8 - lEmpCnt_8)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_9", lEmpCnt9 - lEmpCnt_9)
dw_Insert.SetItem(CurRow, "sales_emp_cnt_10", lEmpCnt10 - lEmpCnt_10)

w_mdi_frame.sle_msg.Text = '관할구역별 인원계획을 등록하세요'
dw_Insert.SetColumn('sales_emp_cnt_5')
dw_Insert.SetFocus()


end event

type gb_2 from groupbox within w_sal_01011
integer x = 288
integer y = 332
integer width = 4032
integer height = 668
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "[ 영 업 팀 ]"
borderstyle borderstyle = styleraised!
end type

type st_gubun from statictext within w_sal_01011
integer x = 1166
integer y = 124
integer width = 640
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 15780518
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sal_01011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 265
integer y = 284
integer width = 4105
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

