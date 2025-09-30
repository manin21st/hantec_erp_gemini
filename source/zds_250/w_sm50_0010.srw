$PBExportHeader$w_sm50_0010.srw
$PBExportComments$제품 인수 등록(물류업체)
forward
global type w_sm50_0010 from w_inherite
end type
type dw_1 from datawindow within w_sm50_0010
end type
type pb_1 from u_pb_cal within w_sm50_0010
end type
type pb_2 from u_pb_cal within w_sm50_0010
end type
type rr_1 from roundrectangle within w_sm50_0010
end type
type p_excel from uo_picture within w_sm50_0010
end type
type cbx_1 from checkbox within w_sm50_0010
end type
type dw_2 from datawindow within w_sm50_0010
end type
type p_1 from picture within w_sm50_0010
end type
end forward

global type w_sm50_0010 from w_inherite
integer width = 4741
integer height = 3764
string title = "제품 인수 등록"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
p_excel p_excel
cbx_1 cbx_1
dw_2 dw_2
p_1 p_1
end type
global w_sm50_0010 w_sm50_0010

type variables
String is_depot_no
end variables

forward prototypes
public function integer wf_itnbr_check (string sitnbr)
end prototypes

public function integer wf_itnbr_check (string sitnbr);Long icnt = 0

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '삭제 가능 여부 CHECK 중.....'

select count(*) into :icnt
  from vnddan
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[거래처제품단가]')
	return -1
end if

select count(*) into :icnt
  from danmst_bg
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from ecomst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[ECO 정보]')
	return -1
end if

select count(*) into :icnt
  from itemas_zig
 where itnbr2 = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[지그/검사구 정보]')
	return -1
end if

select count(*) into :icnt
  from poblkt
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주_품목정보]')
	return -1
end if

select count(*) into :icnt
  from estima
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주예정_구매의뢰]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수주]')
	return -1
end if

select count(*) into :icnt
  from exppid
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수출PI Detail]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[입출고이력]')
	return -1
end if

//기술 BOM 체크  
//  SELECT COUNT("ESTRUC"."USSEQ")  
//    INTO :icnt  
//    FROM "ESTRUC"  
//   WHERE "ESTRUC"."PINBR" = :sitnbr OR "ESTRUC"."CINBR" = :sitnbr ;
//
//if icnt > 0 then
//	w_mdi_frame.sle_msg.text = ''
//	f_message_chk(38,'[기술BOM]')
//	return -1
//end if
	
//생산 BOM 체크  
  SELECT COUNT("PSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "PSTRUC"  
   WHERE "PSTRUC"."PINBR" = :sitnbr OR "PSTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[생산BOM]')
	return -1
end if

//외주 BOM 체크  
  SELECT COUNT("WSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "WSTRUC"  
   WHERE "WSTRUC"."PINBR" = :sitnbr OR "WSTRUC"."CINBR" = :sitnbr ;	

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주BOM]')
	return -1
end if

//외주단가 BOM 체크  
  SELECT SUM(1)  
    INTO :icnt  
    FROM "WSUNPR"  
   WHERE "WSUNPR"."ITNBR" = :sitnbr;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주단가BOM]')
	return -1
end if

//할당 체크
select count(*) into :icnt
  from holdstock
 where itnbr = :sitnbr;
		 
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[할당]')
	return -1
end if

//월 재고
select count(*) into :icnt
  from stockmonth
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[기초재고]')
	return -1
end if

w_mdi_frame.sle_msg.text = ''

return 1
end function

on w_sm50_0010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.p_excel=create p_excel
this.cbx_1=create cbx_1
this.dw_2=create dw_2
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.p_excel
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.p_1
end on

on w_sm50_0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.p_excel)
destroy(this.cbx_1)
destroy(this.dw_2)
destroy(this.p_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.InsertRow(0)

dw_insert.SetTransObject(SQLCA)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
End If

dw_1.Object.jisi_date[1] = is_today
dw_1.Object.jisi_date2[1] = is_today

dw_1.Object.factory[1] = '.'

dw_1.Object.mdepot[1] = 'ZZ1'



end event

type dw_insert from w_inherite`dw_insert within w_sm50_0010
integer x = 37
integer y = 356
integer width = 4562
integer height = 1916
integer taborder = 10
string dataobject = "d_sm50_0010_a"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value , ls_saupj , ls_name ,ls_ispec , ls_jijil ,ls_null
Long   ll_cnt
SetNull(ls_null)
ls_col = Lower(GetColumnName())

ls_value = String(GetText())
row = GetRow()
dw_1.AcceptText()
ls_saupj = Trim(dw_1.Object.saupj[1])
Choose Case ls_col
		
	Case 'facgbn'
		String  ls_chk
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
		  INTO :ls_chk
		  FROM REFFPF
		 WHERE SABU = :gs_sabu AND RFCOD = '2A' AND RFGUB = :ls_value ;
		If ls_chk <> 'Y' Then
			MessageBox('확인', '등록된 공장코드가 아닙니다.')
			Return 1
		End If
		
	Case 'is_chek'
		
			If ls_value = 'Y' Then
				
//				If Trim(dw_2.object.facgbn[1]) = '' OR IsNull(dw_2.object.facgbn[1]) OR dw_2.object.facgbn[1] = '.' Then
//					MessageBox('공장확인', '공장을 확인 하십시오.')
//					Return
//				End If
			
				dw_insert.object.ioqty[row] = dw_insert.object.ioreqty[row]
				dw_insert.object.io_date[row] = is_today
				dw_insert.object.io_confirm[row] = ls_value
				If Trim(dw_insert.object.facgbn[row]) = '' OR IsNull(dw_insert.object.facgbn[row]) OR dw_insert.object.facgbn[row] = '.' Then
					dw_insert.object.facgbn[row] = dw_2.object.facgbn[1]
				End If
			else
				dw_insert.object.ioqty[row] = 0
				dw_insert.object.io_date[row] = ls_null
				dw_insert.object.io_confirm[row] = ls_value
			end if
		
End Choose


end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::clicked;call super::clicked;f_multi_select(this)
end event

type p_delrow from w_inherite`p_delrow within w_sm50_0010
boolean visible = false
integer x = 3392
integer y = 192
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_sm50_0010
boolean visible = false
integer x = 3570
integer y = 196
integer width = 174
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_sm50_0010
boolean visible = false
integer x = 4274
integer y = 196
integer taborder = 0
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;//

PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;//


PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm50_0010
boolean visible = false
integer x = 3922
integer y = 200
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_sm50_0010
integer taborder = 0
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm50_0010
integer taborder = 0
end type

event p_can::clicked;call super::clicked;
dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
//   if gs_code <> '%' then
//   	dw_1.Modify("saupj.protect=1")
//		dw_1.Modify("saupj.background.color = 80859087")
//   End if
End If

dw_1.Object.jisi_date[1] = is_today
dw_1.Object.jisi_date2[1] = is_today

dw_1.SetRedraw(True)





end event

type p_print from w_inherite`p_print within w_sm50_0010
boolean visible = false
integer x = 3744
integer y = 200
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_sm50_0010
integer x = 3922
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String ls_saupj , ls_sdate , ls_edate , ls_itnbr_fr , ls_itnbr_to , ls_empno , ls_confirm ,ls_mdepot, ls_factory
Long   ll_rcnt , i
dw_1.AcceptText() 
dw_insert.AcceptText() 

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_sdate = Trim(dw_1.Object.jisi_date[1])
ls_edate = Trim(dw_1.Object.jisi_date2[1])

If f_datechk(ls_sdate) < 1 Then
	f_message_chk(35,'[기준일자(시작)]')
	dw_1.setitem(1, "jisi_date", '')
	dw_1.SetFocus()
	return 
end if

If f_datechk(ls_edate) < 1 Then
	f_message_chk(35,'[기준일자(끝)]')
	dw_1.setitem(1, "jisi_date", '')
	dw_1.SetFocus()
	return 
end if
	
ls_itnbr_fr = Trim(dw_1.Object.itnbr_from[1])
ls_itnbr_to = Trim(dw_1.Object.itnbr_from[1])

ls_empno = Trim(dw_1.Object.empno[1])

If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) then ls_itnbr_fr = '.'
If ls_itnbr_to = '' or isNull(ls_itnbr_to) then ls_itnbr_to = 'z'


ls_mdepot = Trim(dw_1.Object.mdepot[1])


ls_factory = Trim(dw_1.Object.factory[1])
If ls_factory = '.' then 
	ls_factory = '%'
Else
	ls_factory = ls_factory + '%'
End if


dw_insert.SetRedraw(False)
ll_rcnt = dw_insert.Retrieve( ls_saupj , ls_sdate , ls_edate  ,ls_itnbr_fr , ls_itnbr_to, ls_mdepot, ls_factory  ) 
	
If ll_rcnt > 0 Then
	
Else
	Messagebox('확인','조건에 해당하는 데이타가 없습니다.')

End iF
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm50_0010
boolean visible = false
integer x = 4453
integer y = 196
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_sm50_0010
integer x = 4096
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;Long i ,ll_rcnt , ll_cnt , ii

String ls_chek ,ls_null
String ls_iojpno , ls_ipjpno, ls_date

SetNull(ls_null)

if dw_1.AcceptText() = -1 then return -1

if dw_insert.AcceptText() = -1 then return -1
if dw_insert.rowcount() <= 0 then return -1

ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','저장할 데이타가 존재하지 않습니다.')
	Return
End IF

if f_msg_update() = -1 then return

dw_insert.SetRedraw(FALSE)


For i = 1 To ll_rcnt
	
	
	ls_chek = Trim(dw_insert.object.is_chek[i])
	ls_iojpno = Trim(dw_insert.object.pjt_cd[i])
	ls_ipjpno = Trim(dw_insert.object.iojpno[i])
	ls_date = Trim(dw_insert.object.io_date[i])
	
	If ls_chek = 'Y' and f_datechk(ls_date) = 1 Then
		
		If Trim(dw_insert.object.facgbn[i]) = '' OR IsNull(dw_insert.object.facgbn[i]) OR dw_insert.object.facgbn[i] = '.' Then
			MessageBox('공장 확인', '공장을 선택 하십시오.')
			ROLLBACK USING SQLCA;
			Return
		End If
		
		dw_insert.object.iosuqty[i] = dw_insert.object.ioreqty[i]
		dw_insert.object.ioqty[i] = dw_insert.object.ioreqty[i]
		dw_insert.object.ioamt[i] = Truncate( dw_insert.object.ioreqty[i] * dw_insert.object.ioprc[i] , 0 )
		
		dw_insert.object.io_date[i] = ls_date
		dw_insert.object.io_confirm[i] = ls_chek
	

	else
		dw_insert.object.is_chek[i] = 'N'
		dw_insert.object.iosuqty[i] = 0
		dw_insert.object.ioqty[i] = 0
		dw_insert.object.ioamt[i] = 0
		dw_insert.object.io_date[i] = ls_null
		dw_insert.object.io_confirm[i] = ls_chek
		

	end if

Next

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장 실패')
	Return
End IF

commit ;

sle_msg.text =	string(ii) + "건의 자료를 저장하였습니다!!"	
	
dw_insert.SetRedraw(TRUE)

end event

type cb_exit from w_inherite`cb_exit within w_sm50_0010
end type

type cb_mod from w_inherite`cb_mod within w_sm50_0010
end type

type cb_ins from w_inherite`cb_ins within w_sm50_0010
end type

type cb_del from w_inherite`cb_del within w_sm50_0010
end type

type cb_inq from w_inherite`cb_inq within w_sm50_0010
end type

type cb_print from w_inherite`cb_print within w_sm50_0010
end type

type st_1 from w_inherite`st_1 within w_sm50_0010
end type

type cb_can from w_inherite`cb_can within w_sm50_0010
end type

type cb_search from w_inherite`cb_search within w_sm50_0010
end type







type gb_button1 from w_inherite`gb_button1 within w_sm50_0010
end type

type gb_button2 from w_inherite`gb_button2 within w_sm50_0010
end type

type dw_1 from datawindow within w_sm50_0010
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 12
integer width = 2638
integer height = 324
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm50_0010_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	
	Case "itnbr_from"
		ls_itnbr_t = Trim(This.GetItemString(row, 'itnbr_to'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'itnbr_to', ls_value)
	   end if
	Case "itnbr_to"
		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'itnbr_from', ls_value)
	   end if
	
END CHOOSE

end event

event itemerror;Return 1
end event

type pb_1 from u_pb_cal within w_sm50_0010
integer x = 814
integer y = 144
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sm50_0010
integer x = 1298
integer y = 144
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date2', gs_code)

end event

type rr_1 from roundrectangle within w_sm50_0010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 348
integer width = 4576
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_excel from uo_picture within w_sm50_0010
integer x = 4101
integer y = 184
integer width = 178
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\엑셀변환_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\엑셀변환_up.gif"
end event

event clicked;call super::clicked;String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(dw_insert,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type cbx_1 from checkbox within w_sm50_0010
integer x = 3049
integer y = 248
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Long i
String ls_null

SetNull(ls_null)

For i = 1 To dw_insert.RowCount()

	If cbx_1.Checked  Then
	
		dw_insert.object.ioqty[i] = dw_insert.object.ioreqty[i]
		
		If Trim(dw_insert.object.io_date[i]) = '' OR IsNull(dw_insert.object.io_date[i]) Then
			dw_insert.object.io_date[i] = is_today
		End If
		
		dw_insert.object.io_confirm[i] = 'Y'
		dw_insert.object.is_chek[i] = 'Y'
		
		If Trim(dw_insert.object.facgbn[i]) = '' OR IsNull(dw_insert.object.facgbn[i]) OR dw_insert.object.facgbn[i] = '.' Then
			dw_insert.object.facgbn[i] = dw_2.object.facgbn[1]
		End If
		
	else
		dw_insert.object.ioqty[i] = 0
		dw_insert.object.io_date[i] = ls_null
		dw_insert.object.io_confirm[i] = 'N'
		dw_insert.object.is_chek[i] = 'N'
	end if
	
Next
	

end event

type dw_2 from datawindow within w_sm50_0010
integer x = 2683
integer y = 12
integer width = 1065
integer height = 156
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm50_0010_fact"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event itemchanged;If row < 1 Then Return

String  ls_chk
Choose Case dwo.name
	Case 'facgbn'
		SELECT CASE WHEN COUNT('X') > 0 THEN 'Y' ELSE 'N' END
		  INTO :ls_chk
		  FROM REFFPF
		 WHERE SABU = :gs_sabu AND RFCOD = '2A' AND RFGUB = :data ;
		If ls_chk <> 'Y' Then
			MessageBox('확인', '등록된 공장코드가 아닙니다.')
			Return 1
		End If
End Choose

end event

type p_1 from picture within w_sm50_0010
integer x = 4443
integer y = 184
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\정렬_up.gif"
boolean focusrectangle = false
end type

event clicked;Openwithparm(w_sort, dw_insert)
end event

