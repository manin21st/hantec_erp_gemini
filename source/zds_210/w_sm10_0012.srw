$PBExportHeader$w_sm10_0012.srw
$PBExportComments$양산차종등록
forward
global type w_sm10_0012 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0012
end type
type cb_1 from commandbutton within w_sm10_0012
end type
type st_2 from statictext within w_sm10_0012
end type
type ddlb_1 from dropdownlistbox within w_sm10_0012
end type
type rr_1 from roundrectangle within w_sm10_0012
end type
end forward

global type w_sm10_0012 from w_inherite
integer height = 2500
string title = "품번계획 그룹 등록"
dw_1 dw_1
cb_1 cb_1
st_2 st_2
ddlb_1 ddlb_1
rr_1 rr_1
end type
global w_sm10_0012 w_sm10_0012

type variables
String is_carcode  ,is_itnbr , is_seq

end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();////
//
//If rb_1.Checked Then
//	dw_1.DataObject = 'd_pd10_0030_1'
//	dw_list.DataObject = 'd_sm10_0012_a'
//	dw_insert.DataObject = 'd_sm10_0012_b'
//Else
////	dw_1.DataObject = 'd_pd10_0030_2'
////	dw_list.DataObject = 'd_pd10_0030_a2'
////	dw_insert.DataObject = 'd_pd10_0030_b2'
//End If
//
//dw_1.SetTransObject(SQLCA)
//dw_list.SetTransObject(SQLCA)
//dw_insert.SetTransObject(SQLCA)
//
//SetNull(is_carcode)
//SetNull(is_seq)
//SetNull(is_itnbr)
//
//dw_1.InsertRow(0)
//dw_1.SetColumn(1)
//dw_1.SetFocus()
//
//
end subroutine

on w_sm10_0012.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.st_2=create st_2
this.ddlb_1=create ddlb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_sm10_0012.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.ddlb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.InsertRow(0)

ddlb_1.Text = '2.차종,드라이브,브레이크,품번'

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

dw_1.SetColumn("carname")
dw_1.SetFocus()

DataWindowChild child_dw
dw_1.GetChild("open_orders", child_dw)
dw_1.SetTransObject(SQLCA)

child_dw.Retrieve()
child_dw.SetFilter("isNull(rfna5) = True")
child_dw.Filter()




end event

type dw_insert from w_inherite`dw_insert within w_sm10_0012
integer x = 64
integer y = 248
integer width = 4517
integer height = 2052
string dataobject = "d_sm10_0012_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;
f_multi_select(dw_insert)
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col , ls_value ,ls_null  
String ls_itnbr , ls_itdsc ,ls_ispec , ls_jijil ,ls_carname 
Int li_cnt
//
//row = GetRow()
//SetNull(ls_null)
//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//
//ls_col = GetColumnName() 
//ls_value = GetText() 
//
//Choose Case ls_col

//	Case	"itnbr" 
//
//		IF ls_value ="" or isNull(ls_value) THEN
//			Object.itnbr[row]    	= ls_null
//			Object.itemas_itdsc[row]    	= ls_null
//			Object.itemas_ispec[row] 		= ls_null
//			Object.itemas_jijil[row]      = ls_null
//			
//			Return 1
//		END IF
//	
//		SELECT A.ITDSC , 
//		       A.ISPEC ,
//		       A.JIJIL
//		  INTO :ls_itdsc, 
//		       :ls_ispec, 		     
//		       :ls_jijil
//		  FROM ITEMAS A 
//		 WHERE A.ITNBR = :ls_value
//		   AND A.USEYN = 0 ;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			f_message_chk(33,'[품번]')
//			
//			Object.itemas_itdsc[row]    	= ls_null
//			Object.itemas_ispec[row] 		= ls_null
//			Object.itemas_jijil[row]      = ls_null
//			SetColumn("itnbr")
//			Return 1
//		END IF
//
//		Object.itemas_itdsc[row]    	= ls_itdsc
//		Object.itemas_ispec[row] 		= ls_ispec
//		Object.itemas_jijil[row]      = ls_jijil
//	
//	Case	"carcode" 
//
//		IF ls_value ="" or isNull(ls_value) THEN
//			Object.carcode[row]    	= ls_null
//			Object.seq[row]    	= ls_null
//			Object.carname[row] 		= ls_null
//			
//			Return 1
//		END IF
//	
//		SELECT FUN_GET_REFFPF('01',:ls_value)  into :ls_carname
//		  FROM Dual ;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			f_message_chk(33,'[차종코드]')
//			
//			Object.carname[row]    	= ls_null
//			
//			SetColumn("carcode")
//			Return 1
//		END IF
//
//
//		Object.carname[row]    	= ls_carname
//		
//		SetColumn("seq")
//		
//	Case	"seq" 
//		
//		IF ls_value ="" or isNull(ls_value) THEN
//			Object.carcode[row]    	= ls_null
//			Object.seq[row]    	= ls_null
//			Object.carname[row] 		= ls_null
//			
//			Return 1
//		END IF
//		String ls_carcode , ls_seq
//		String ls_scd8a , ls_scd8b, ls_scd8c, ls_scd8d, ls_scd8e, ls_scd8f ,ls_scd8g , ls_scd8h, ls_scd8i
//		Long ll_seq , ll_cnt=0
//		ls_carcode = Trim(Object.carcode[row])
//		
//		
//		SELECT SCD8A 	  , SCD8B      ,SCD8C   ,SCD8D     ,SCD8E     ,SCD8F      ,SCD8G     ,SCD8H     ,SCD8I 
//		  into :ls_scd8a , :ls_scd8b, :ls_scd8c, :ls_scd8d, :ls_scd8e, :ls_scd8f ,:ls_scd8g , :ls_scd8h, :ls_scd8i
//		  FROM CARMST
//		 WHERE CARCODE = :ls_carcode
//		   AND SEQ = :ls_value ;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			f_message_chk(33,'[차종모델]')
//			
//			Object.seq[row]    	= '000'
//			
//			SetColumn("seq")
//			Return 1
//		Else
//			Object.scd8a[row] = ls_scd8a
//			Object.scd8b[row] = ls_scd8b
//			Object.scd8c[row] = ls_scd8c
//			Object.scd8d[row] = ls_scd8d
//			Object.scd8e[row] = ls_scd8e
//			Object.scd8f[row] = ls_scd8f
//			Object.scd8g[row] = ls_scd8g
//			Object.scd8h[row] = ls_scd8h
//			Object.scd8i[row] = ls_scd8i
//			
//		END IF
////
//END Choose


end event

event dw_insert::rbuttondown;call super::rbuttondown;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//sle_msg.text = ''
//
//If row < 1 Then Return
//str_code lst_code
//Long i , ll_i = 0
//
//this.AcceptText()
//
//Choose Case GetcolumnName() 
//	Case "itnbr"
//		gs_gubun = '1'
//		
//		Open(w_itemas_multi_popup)
//
//		lst_code = Message.PowerObjectParm
//		IF isValid(lst_code) = False Then Return 
//		If UpperBound(lst_code.code) < 1 Then Return 
//		
//		For i = row To UpperBound(lst_code.code) + row - 1
//			ll_i++
//			if i > row then p_ins.triggerevent("clicked")
//			this.SetItem(i,"itnbr",lst_code.code[ll_i])
//			this.TriggerEvent("itemchanged")
//			
//		Next
//	Case "carcode"
//	
//		
//		Open(w_carcode_popup)
//		If gs_code = '' Or isNull(gs_code) Then Return 
//		If gs_codename = '' Or isNull(gs_codename) Then
//			MessageBox('확인','모델 번호를 가져올 수 없습니다.')
//			Return
//		End If
//		Object.carcode[row] = gs_code
//		Object.seq[row] = gs_codename
//		I
//		this.TriggerEvent("itemchanged")
//
//END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0012
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0012
boolean visible = false
end type

type p_search from w_inherite`p_search within w_sm10_0012
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0012
boolean visible = false
integer x = 3749
end type

event p_ins::clicked;call super::clicked;//Long ll_row
//
//If rb_1.Checked Then
//	
//	If is_carcode = '' Or isNull(is_carcode) Then
//		MessageBox('확인','차종코드를 선택 후 품번을 추가할 수 있습니다.')
//		Return
//	End If
//	
//	ll_row = dw_insert.InsertRow(0)
//	
//	dw_insert.SetFocus()
//	dw_insert.ScrollToRow(ll_row)
//	dw_insert.Object.carcode[ll_row] = is_carcode
//	dw_insert.Object.seq[ll_row] = is_seq
//	dw_insert.SetColumn('itnbr')
//Else
//	If is_itnbr = '' Or isNull(is_itnbr) Then
//		MessageBox('확인','품번을 선택 후 차종모델을 추가할 수 있습니다.')
//		Return
//	End If
//	ll_row = dw_insert.InsertRow(0)
//	
//	dw_insert.SetFocus()
//	dw_insert.ScrollToRow(ll_row)
//	dw_insert.Object.itnbr[ll_row] = is_itnbr
//	dw_insert.SetColumn('carcode')
//End if
//

end event

type p_exit from w_inherite`p_exit within w_sm10_0012
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0012
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If

dw_1.SetColumn("carname")
dw_1.SetFocus()

DataWindowChild child_dw
dw_1.GetChild("open_orders", child_dw)
dw_1.SetTransObject(SQLCA)


dw_1.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0012
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0012
integer x = 3922
end type

event p_inq::clicked;call super::clicked;
String ls_name ,ls_code , ls_itnbr ,ls_itdsc

dw_1.AcceptText() 

	
ls_name = Trim(dw_1.Object.carname[1])

If isNull(ls_name) Then ls_name = '%'

dw_insert.SetRedraw(False)

dw_insert.Retrieve(ls_name) 
dw_insert.ResetUpdate()

ddlb_1.TriggerEvent(Selectionchanged!)

dw_insert.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_sm10_0012
boolean visible = false
end type

event p_del::clicked;call super::clicked;//Long i , ll_r , ll_cnt=0
//
//ll_r = dw_insert.RowCount()
//
//If ll_r < 1 Then Return
//If f_msg_delete() < 1 Then Return
//If dw_insert.AcceptText() < 1 Then Return 
//
//For i = ll_r To 1 Step -1
//	
//	If dw_insert.IsSelected(i) Then
//		dw_insert.DeleteRow(i)
//		ll_cnt++
//	End If
//Next
//
//If ll_cnt < 1 Then 
//	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
//Else
//	If dw_insert.Update() < 1 Then
//		Rollback;
//		MessageBox('저장실패','저장실패')
//		Return
//	Else
//		Commit;
//	End iF
//End IF
end event

type p_mod from w_inherite`p_mod within w_sm10_0012
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Decimal ld_rate 
Long i,ll_rcnt ,ll_sum_rate,ll_cnt ,ll_row
String ls_grpcd , ls_itnbr , ls_carcode ,ls_saupj
String ls_drive , ls_break

If dw_1.AcceptText() < 1 Then Return 
If dw_insert.AcceptText() < 1 Then Return 
ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then Return
ls_saupj = Trim(dw_1.Object.saupj[1])
if f_msg_update() < 1 Then Return


DO WHILE ll_row <= ll_rcnt

        ll_row = dw_insert.GetNextModified(ll_row, Primary!)

        IF ll_row > 0 THEN

            ls_grpcd = Trim(dw_insert.Object.cargrp[ll_row])
				ld_rate = dw_insert.Object.schrate[ll_row]
				ll_sum_rate = dw_insert.Object.sum_rate[ll_row]
			
				
				SetNull(ls_carcode)
				SetNull(ls_itnbr)
				
				ls_carcode = Trim(dw_insert.Object.carcode_temp[ll_row])
				ls_itnbr = Trim(dw_insert.Object.itnbr_temp[ll_row])
				ls_drive  =  Trim(dw_insert.Object.drive_nm[ll_row])
				ls_break  =  Trim(dw_insert.Object.break_nm[ll_row])
		
				Select Count(*) Into :ll_cnt
				  FROM CAR_SCHRATE 
				 WHERE SAUPJ = :ls_saupj
					AND CARCODE = :ls_carcode 
					AND ITNBR = :ls_itnbr ;
				
				
				If ll_cnt < 1  Then
		
					Insert into CAR_SCHRATE (saupj, carcode , itnbr ,cargrp , schrate , drive_type , break_type )
										  values (:ls_saupj, :ls_carcode , :ls_itnbr , :ls_grpcd , :ld_rate ,:ls_drive , :ls_break) Using sqlca ;
							  
				Else
			
					Update car_schrate set cargrp = :ls_grpcd ,
												  schrate = :ld_rate ,
												  drive_type = :ls_drive ,
												  break_type = :ls_break
										Where saupj = :ls_saupj
										  and carcode = :ls_carcode 
										  and itnbr = :ls_itnbr  
										  Using sqlca ;
				End If
				
				If sqlca.sqlcode <> 0 Then
					MessageBox(String(i),'저장실패'+ sqlca.sqlerrText)
					Rollback;
					MessageBox(String(sqlca.sqlcode),'저장실패'+ sqlca.sqlerrText)
					Return
				End If

        ELSE

            ll_row = ll_rcnt + 1

        END IF

LOOP

Commit ;

p_inq.TriggerEvent(Clicked!)


end event

type cb_exit from w_inherite`cb_exit within w_sm10_0012
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0012
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0012
end type

type cb_del from w_inherite`cb_del within w_sm10_0012
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0012
end type

type cb_print from w_inherite`cb_print within w_sm10_0012
end type

type st_1 from w_inherite`st_1 within w_sm10_0012
end type

type cb_can from w_inherite`cb_can within w_sm10_0012
end type

type cb_search from w_inherite`cb_search within w_sm10_0012
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0012
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0012
end type

type dw_1 from datawindow within w_sm10_0012
event ue_keydown pbm_dwnprocessenter
integer x = 41
integer y = 16
integer width = 2235
integer height = 208
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0012_1"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;p_inq.TriggerEvent(Clicked!)
end event

type cb_1 from commandbutton within w_sm10_0012
integer x = 2331
integer y = 36
integer width = 1303
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전년도 생산실적(D2)으로 비율생성"
end type

event clicked;String ls_year , ls_grp , ls_carcode ,  ls_itnbr  , ls_saupj
Long   i  , ll_c ,ll_sum_qty , ll_qty ,ll_cnt
Decimal ld_rate

If dw_1.AcceptText() < 1 Then Return

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_carcode = Trim(dw_1.Object.carname[1])

If ls_carcode = '' Or isNull(ls_carcode) Then 
	f_message_chk(1400,"[차종코드]")
	dw_1.SetFocus()
	dw_1.SetColumn("carname")
	Return
End If

IF dw_insert.ModifiedCount() > 0  or dw_insert.DeletedCount() > 0 THEN 
	p_mod.TriggerEvent(Clicked!)
	
End iF

ls_year = String( Long(Left(is_today , 4)) - 1 )

ll_cnt = 0 
 SELECT count(*) Into :ll_cnt
   FROM CAR_SCHRATE
  WHERE SAUPJ = :ls_saupj
    AND CARCODE = :ls_carcode
    AND CARGRP IS NOT NULL ;

If ll_cnt < 1 Then
	MessageBox('확인','해당 차종에는 그룹이 지정되어 있지 않습니다.')
	Return
End If
	 

pointer oldpointer 

oldpointer = SetPointer(HourGlass!)


Declare rate_cur1 Cursor For

 SELECT DISTINCT CARGRP 
   FROM CAR_SCHRATE
  WHERE SAUPJ = :ls_saupj
    AND CARCODE = :ls_carcode
    AND CARGRP IS NOT NULL ;

Open rate_cur1;

Do While True
	Fetch rate_cur1 Into :ls_grp ;
	
	If SQLCA.SQLCODE <> 0 Then 
		
		EXIT
	End if
	
		SELECT SUM(NVL(PREV_RESULT,0)) Into :ll_sum_qty
        FROM VAN_HKCD2 
		 WHERE CUSTCD = FUN_GET_REFFPF_VALUE('AD',:ls_saupj,'4')
		   AND SUBSTR(DOCCODE ,3,4) = :ls_year
		   AND MITNBR IN ( SELECT ITNBR 
			                  FROM CAR_SCHRATE 
								  WHERE SAUPJ = :ls_saupj
								    AND CARCODE = :ls_carcode
								    AND CARGRP = :ls_grp ) ;
									 
		If SQLCA.SQLCODE <> 0 Then
			MessageBox('확인',ls_carcode + ' 차종의 '+ ls_grp+ " 그룹에 전년도 생산 실적이 존재하지 않습니다.")
			Return
		End if
	
		Declare rate_cur2 Cursor For

		SELECT MITNBR ,
		       SUM(NVL(PREV_RESULT,0)) 
        FROM VAN_HKCD2 
		 WHERE CUSTCD = FUN_GET_REFFPF_VALUE('AD',:ls_saupj,'4')
		   AND SUBSTR(DOCCODE ,3,4) = :ls_year
		   AND MITNBR IN ( SELECT ITNBR 
			                  FROM CAR_SCHRATE 
								  WHERE SAUPJ = :ls_saupj
								    AND CARCODE = :ls_carcode
								    AND CARGRP = :ls_grp )
		GROUP BY MITNBR ;
	
		Open rate_cur2;
		
		Do While True
			Fetch rate_cur2 Into :ls_itnbr , :ll_qty ;
			
			If SQLCA.SQLCODE <> 0 Then Exit
			
			ld_rate = Truncate( ( ll_qty / ll_sum_qty ) * 100 ,2)
			
			
//			if Left(ls_itnbr,2) = '58' Then
//				Update CAR_SCHRATE set schrate = :ld_rate
//									 where saupj = :ls_saupj
//										and carcode = :ls_carcode 
//										and (drive_type , break_type ,SUBSTR(ITNBR,1,2 ) ) in  
//										                                   ( SELECT DRIVE_TYPE ,BREAK_TYPE ,
//																					           SUBSTR(ITNBR,1,2)
//																							FROM CAR_SCHRATE 
//																						  WHERE SAUPJ = :ls_saupj
//																							 AND CARCODE = :ls_carcode
//																							 AND ITNBR = :ls_itnbr 
//																							 AND CARGRP = :ls_grp 
//																							 AND SUBSTR(ITNBR,1,2) = '58' 
//																							 );
//			
//			else
			
				Update CAR_SCHRATE set schrate = :ld_rate
									 where saupj = :ls_saupj
										and carcode = :ls_carcode 
										and itnbr = :ls_itnbr 
										and cargrp = :ls_grp ;
//			End If
									
			If sqlca.sqlcode <> 0 Then
				MessageBox('',sqlca.sqlerrText)
				Rollback;
				Return
			End If
			
		Loop
		Close rate_cur2 ;
		  
Loop

Close rate_cur1;

Commit ;

SetPointer(oldpointer)

MessageBox('확인','비율 적용 성공')


p_inq.TriggerEvent(Clicked!)


	 

end event

type st_2 from statictext within w_sm10_0012
integer x = 2341
integer y = 148
integer width = 288
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "정렬기준"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_sm10_0012
integer x = 2615
integer y = 136
integer width = 1010
integer height = 1156
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string item[] = {"1.차종,품번,드라이브,브레이크","2.차종,드라이브,브레이크,품번","3.차종,브레이크,드라이브,품번"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;If dw_insert.RowCount() < 1 Then Return

String ls_str

dw_insert.SetRedraw(False)

Choose Case Left(This.Text,1)
	Case '1'
		ls_str = " carcode_temp A ,itnbr_temp A , drive_nm A , break_nm A "
	Case '2'
		ls_str = " carcode_temp A , drive_nm A , break_nm A ,itnbr_temp A "
	Case '3'
		ls_str = " carcode_temp A , break_nm A , drive_nm A ,itnbr_temp A "
End Choose

dw_insert.SetSort(ls_str)
dw_insert.Sort()

dw_insert.SetSort("")

dw_insert.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sm10_0012
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 41
integer y = 240
integer width = 4562
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

