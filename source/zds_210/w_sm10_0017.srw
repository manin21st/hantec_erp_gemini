$PBExportHeader$w_sm10_0017.srw
$PBExportComments$차종BOM 등록
forward
global type w_sm10_0017 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0017
end type
type dw_list from datawindow within w_sm10_0017
end type
type p_2 from uo_picture within w_sm10_0017
end type
type rb_1 from radiobutton within w_sm10_0017
end type
type rb_2 from radiobutton within w_sm10_0017
end type
type rb_3 from radiobutton within w_sm10_0017
end type
type p_excel from uo_picture within w_sm10_0017
end type
type cbx_1 from checkbox within w_sm10_0017
end type
type dw_excel from datawindow within w_sm10_0017
end type
type st_2 from statictext within w_sm10_0017
end type
type st_splitbar from u_st_splitbar within w_sm10_0017
end type
type gb_1 from groupbox within w_sm10_0017
end type
end forward

global type w_sm10_0017 from w_inherite
integer height = 2448
string title = "차종BOM 등록"
dw_1 dw_1
dw_list dw_list
p_2 p_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
p_excel p_excel
cbx_1 cbx_1
dw_excel dw_excel
st_2 st_2
st_splitbar st_splitbar
gb_1 gb_1
end type
global w_sm10_0017 w_sm10_0017

type variables
String is_carcode  ,is_itnbr , is_seq

end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();//

If rb_1.Checked Then
	dw_1.DataObject = 'd_sm10_0017_1'
	dw_list.DataObject = 'd_sm10_0017_a'
	dw_insert.DataObject = 'd_sm10_0017_b'
ElseIf rb_2.Checked Then
	dw_1.DataObject = 'd_sm10_0017_2'
	dw_list.DataObject = 'd_sm10_0017_a2'
	dw_insert.DataObject = 'd_sm10_0017_b2'
ElseIf rb_3.Checked Then
	dw_1.DataObject = 'd_sm10_0017_1'
	dw_list.DataObject = 'd_sm10_0017_a3'
	dw_insert.DataObject = 'd_sm10_0017_b3'
End If

dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

SetNull(is_carcode)
SetNull(is_seq)
SetNull(is_itnbr)

dw_1.InsertRow(0)
dw_1.SetColumn("carname")
dw_1.SetFocus()


end subroutine

on w_sm10_0017.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.p_2=create p_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.p_excel=create p_excel
this.cbx_1=create cbx_1
this.dw_excel=create dw_excel
this.st_2=create st_2
this.st_splitbar=create st_splitbar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.p_excel
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.dw_excel
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_splitbar
this.Control[iCurrent+12]=this.gb_1
end on

on w_sm10_0017.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.p_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.p_excel)
destroy(this.cbx_1)
destroy(this.dw_excel)
destroy(this.st_2)
destroy(this.st_splitbar)
destroy(this.gb_1)
end on

event open;call super::open;
dw_excel.SetTransObject(SQLCA)

st_splitbar.of_Register(dw_list, st_splitbar.LEFT)
st_splitbar.of_Register(dw_insert, st_splitbar.RIGHT)

rb_2.Checked = True

wf_init()

If rb_1.Checked Then

	dw_list.Retrieve('')

End if

end event

type dw_insert from w_inherite`dw_insert within w_sm10_0017
integer x = 1495
integer y = 316
integer width = 3118
integer height = 1928
string dataobject = "d_sm10_0017_b2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_insert::clicked;call super::clicked;
f_multi_select(dw_insert)
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col , ls_value ,ls_null  
String ls_itnbr , ls_itdsc ,ls_ispec , ls_jijil ,ls_carname 
Int li_cnt 
Long ll_cnt

row = GetRow()
SetNull(ls_null)
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ls_col = GetColumnName() 
ls_value = GetText() 

Choose Case ls_col
	Case	"itnbr" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.itnbr[row]    	= ls_null
			Object.itemas_itdsc[row]    	= ls_null
			Object.itemas_ispec[row] 		= ls_null
			Object.itemas_jijil[row]      = ls_null
			
			Return 1
		END IF
	
		SELECT A.ITDSC , 
		       A.ISPEC ,
		       A.JIJIL
		  INTO :ls_itdsc, 
		       :ls_ispec, 		     
		       :ls_jijil
		  FROM ITEMAS A 
		 WHERE A.ITNBR = :ls_value
		   AND (A.USEYN = 0 OR A.USEYN = 1) ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[품번]')
			
			Object.itemas_itdsc[row]    	= ls_null
			Object.itemas_ispec[row] 		= ls_null
			Object.itemas_jijil[row]      = ls_null
			SetColumn("itnbr")
			Return 1
		END IF

		Object.itemas_itdsc[row]    	= ls_itdsc
		Object.itemas_ispec[row] 		= ls_ispec
		Object.itemas_jijil[row]      = ls_jijil
	
//	Case "seq"
//	
//	
//		If rb_3.Checked Then
//		
//			ll_cnt = 0 
//			Select count(*) Into :ll_cnt
//			  From carmst 
//			 Where carcode = :is_carcode 
//				and seq = :ls_value ;
//				
//			If ll_cnt = 0 Then
//				this.SetItem(row,"seq" , ls_null)
//				MessageBox('확인','해당 차종에 등록된 모델 코드가 아닙니다.')
//				Return 1
//			End IF
//			
//			is_seq = ls_value
//		
//		End if
	
	Case	"carcode" 

		IF ls_value ="" or isNull(ls_value) THEN
			Object.carcode[row]    	= ls_null
			Object.seq[row]    	= ls_null
			Object.carname[row] 		= ls_null
			
			Return 1
		END IF
	
		SELECT carname  into :ls_carname
		  FROM carhead
		 Where carcode = :ls_value ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[차종코드]')
			
			Object.carcode[row]    	= ls_null
			Object.seq[row]    	= ls_null
			Object.carname[row] 		= ls_null
			
			SetColumn("carcode")
			Return 1
		END IF


		Object.carname[row]    	= ls_carname
		
		//SetColumn("seq")
		
	Case	"seq"
		If rb_3.Checked Then
		
			ll_cnt = 0 
			Select count(*) Into :ll_cnt
			  From carmst 
			 Where carcode = :is_carcode 
				and seq = :ls_value ;
				
			If ll_cnt = 0 Then
				this.SetItem(row,"seq" , ls_null)
				MessageBox('확인','해당 차종에 등록된 모델 코드가 아닙니다.')
				Return 1
			End IF
			
			is_seq = ls_value
		
		End if
		
		If rb_2.Checked Then
		
			IF ls_value ="" or isNull(ls_value) THEN
				Object.carcode[row]    	= ls_null
				Object.seq[row]    	= ls_null
				Object.carname[row] 		= ls_null
				
				Return 1
			END IF
			
			String ls_carcode , ls_seq
			String ls_gbn1 , ls_gbn2, ls_gbn3, ls_gbn4, ls_gbn5, ls_gbn6 
			String ls_gbn7 , ls_gbn8, ls_gbn9 , ls_gbn10 , ls_gbn11 , ls_gbn12 , ls_bigo
			Long ll_seq
			ll_cnt=0
			ls_carcode = Trim(Object.carcode[row])
			
			
			SELECT cargbn1 	  , 
					 cargbn2 	  , 
					 cargbn3 	  , 
					 cargbn4 	  , 
					 cargbn5 	  , 
					 cargbn6 	  , 
					 cargbn7 	  , 
					 cargbn8 	  , 
					 cargbn9 	  , 
					 cargbn10 	  , 
					 cargbn11	  , 
					 cargbn12	  , 
					 bigo	  
			  into :ls_gbn1 , :ls_gbn2, :ls_gbn3, :ls_gbn4, :ls_gbn5, :ls_gbn6 ,
					 :ls_gbn7 , :ls_gbn8, :ls_gbn9, :ls_gbn10 , :ls_gbn11 , :ls_gbn12 , :ls_bigo
			  FROM CARMST
			 WHERE CARCODE = :ls_carcode
				AND SEQ = :ls_value ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				f_message_chk(33,'[차종모델]')
				
				Object.seq[row]    	= '000'
				
				SetColumn("seq")
				Return 1
			Else
				Object.cargbn1[row] = ls_gbn1
				Object.cargbn2[row] = ls_gbn2
				Object.cargbn3[row] = ls_gbn3
				Object.cargbn4[row] = ls_gbn4
				Object.cargbn5[row] = ls_gbn5
				Object.cargbn6[row] = ls_gbn6
				Object.cargbn7[row] = ls_gbn7
				Object.cargbn8[row] = ls_gbn8
				Object.cargbn9[row] = ls_gbn9
				Object.cargbn10[row] = ls_gbn10
				Object.cargbn11[row] = ls_gbn11
				Object.cargbn12[row] = ls_gbn12
				Object.bigo[row] = ls_bigo
				
				
			END IF
		End If

END Choose


end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''

If row < 1 Then Return
str_code lst_code
Long i , ll_i = 0
Long ll_seq , ll_cnt=0

String ls_carcode , ls_seq , ls_null
String ls_gbn1 , ls_gbn2, ls_gbn3, ls_gbn4, ls_gbn5, ls_gbn6 
String ls_gbn7 , ls_gbn8, ls_gbn9 , ls_gbn10 , ls_gbn11 , ls_gbn12 , ls_bigo
		
SetNull(ls_null)
	
dw_1.AcceptText()
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
			if i > row then p_ins.triggerevent("clicked")
			this.SetItem(i,"itnbr",lst_code.code[ll_i])
			this.TriggerEvent("itemchanged")
			
		Next

		
	Case "carcode"
	
		gs_code = ''
		
		Open(w_carcode_popup)
		
		lst_code = Message.PowerObjectParm
		IF isValid(lst_code) = False Then Return 
		If UpperBound(lst_code.code) < 1 Then Return 
		ll_i = 0
		For i = row To UpperBound(lst_code.code) + row - 1
			ll_i++
			if i > row then dw_insert.Insertrow(i)
			
			this.SetItem(i,"carcode",lst_code.code[ll_i])
			this.SetItem(i,"carname",lst_code.codename[ll_i])
			this.SetItem(i,"itnbr",is_itnbr)
			
		
			//this.SetItem(i,"seq",lst_code.sgubun1[ll_i])
			
			//ls_carcode = 	lst_code.code[ll_i]
			//ls_seq     = 	lst_code.sgubun1[ll_i]
			
		
		
//			SELECT cargbn1 	  , 
//					 cargbn2 	  , 
//					 cargbn3 	  , 
//					 cargbn4 	  , 
//					 cargbn5 	  , 
//					 cargbn6 	  , 
//					 cargbn7 	  , 
//					 cargbn8 	  , 
//					 cargbn9 	  , 
//					 cargbn10 	  , 
//					 cargbn11	  , 
//					 cargbn12	  , 
//					 bigo	  
//			  into :ls_gbn1 , :ls_gbn2, :ls_gbn3, :ls_gbn4, :ls_gbn5, :ls_gbn6 ,
//					 :ls_gbn7 , :ls_gbn8, :ls_gbn9, :ls_gbn10 , :ls_gbn11 , :ls_gbn12 , :ls_bigo
//			  FROM CARMST
//			 WHERE CARCODE = :ls_carcode
//				AND SEQ = :ls_seq ;
//		
//			IF SQLCA.SQLCODE <> 0 THEN
//				f_message_chk(33,'[차종모델]')
//				
//				Object.seq[i]    	= '000'
//				
//				SetColumn("seq")
//				Continue ;
//			Else
//				Object.cargbn1[i] = ls_gbn1
//				Object.cargbn2[i] = ls_gbn2
//				Object.cargbn3[i] = ls_gbn3
//				Object.cargbn4[i] = ls_gbn4
//				Object.cargbn5[i] = ls_gbn5
//				Object.cargbn6[i] = ls_gbn6
//				Object.cargbn7[i] = ls_gbn7
//				Object.cargbn8[i] = ls_gbn8
//				Object.cargbn9[i] = ls_gbn9
//				Object.cargbn10[i] = ls_gbn10
//				Object.cargbn11[i] = ls_gbn11
//				Object.cargbn12[i] = ls_gbn12
//				Object.bigo[row] = ls_bigo
//				
//				
//			END IF
		
		
		Next
		
		
END Choose
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0017
boolean visible = false
integer x = 4361
integer y = 156
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0017
boolean visible = false
integer x = 4187
integer y = 156
end type

type p_search from w_inherite`p_search within w_sm10_0017
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0017
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long ll_row , ll_r , i

If rb_1.Checked Then
	
	If is_carcode = '' Or isNull(is_carcode) Then
		MessageBox('확인','차종코드를 선택 후 품번을 추가할 수 있습니다.')
		Return
	End If
	
	ll_row = dw_insert.InsertRow(0)
	
	dw_insert.SetFocus()
	dw_insert.ScrollToRow(ll_row)
	dw_insert.Object.carcode[ll_row] = is_carcode
	dw_insert.Object.seq[ll_row] = is_seq
	dw_insert.SetColumn('itnbr')
ElseIf rb_2.Checked Then
	If is_itnbr = '' Or isNull(is_itnbr) Then
		MessageBox('확인','품번을 선택 후 차종모델을 추가할 수 있습니다.')
		Return
	End If
	
	ll_r = 0 
	For i = 1 To dw_insert.RowCount()
	
		If dw_insert.IsSelected(i) Then
			ll_r = i 
			exit;
		end if
	Next

	ll_row = dw_insert.InsertRow(ll_r)
	
	dw_insert.SetFocus()
	dw_insert.ScrollToRow(ll_row)
	dw_insert.Object.itnbr[ll_row] = is_itnbr
	dw_insert.SetColumn('carcode')
Else
	If is_carcode = '' Or isNull(is_carcode) Then
		MessageBox('확인','차종코드를 선택 후 품번을 추가할 수 있습니다.')
		Return
	End If
	
	ll_row = dw_insert.InsertRow(0)
	
	dw_insert.SetFocus()
	dw_insert.ScrollToRow(ll_row)
	dw_insert.Object.carcode[ll_row] = is_carcode
	dw_insert.SetColumn('seq')
End if


end event

type p_exit from w_inherite`p_exit within w_sm10_0017
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0017
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0017
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0017
integer x = 3575
end type

event p_inq::clicked;call super::clicked;
String ls_name ,ls_code , ls_itnbr ,ls_itdsc , ls_ittyp

dw_1.AcceptText() 
If rb_1.Checked Then
	
	ls_name = Trim(dw_1.Object.carname[1])
	
	If isNull(ls_name) Then ls_name = ''
	
	dw_list.SetRedraw(False)
	
	If dw_list.Retrieve(ls_name) > 0 Then
		
		is_carcode = Trim(dw_list.Object.carcode[1])
		is_seq     = Trim(dw_list.Object.seq[1])
		dw_insert.Retrieve( is_carcode ,is_seq)
		
	End If
	dw_list.SetRedraw(True)
ElseIf rb_2.Checked Then

	ls_itnbr = Trim(dw_1.Object.carname[1])
	ls_ittyp = Trim(dw_1.Object.ittyp[1])
	
	dw_list.SetRedraw(False)
	
	If ls_ittyp = '' or isNull(ls_ittyp) Then ls_ittyp = '%'
	
	If dw_list.Retrieve(ls_itnbr ,ls_ittyp) > 0 Then
		
		is_itnbr = Trim(dw_list.Object.itnbr[1])
		dw_insert.Retrieve( is_itnbr)
	
	End If
	dw_list.SetRedraw(True)
Else
	ls_name = Trim(dw_1.Object.carname[1])
	
	If isNull(ls_name) Then ls_name = '%'
	
	dw_list.SetRedraw(False)
	
	If dw_list.Retrieve(ls_name) > 0 Then
		
		is_carcode = Trim(dw_list.Object.carcode[1])
		dw_insert.Retrieve( is_carcode)
		
	End If
	dw_list.SetRedraw(True)
End If
end event

type p_del from w_inherite`p_del within w_sm10_0017
end type

event p_del::clicked;call super::clicked;String ls_new , ls_carcode , ls_seq , ls_itnbr
Long i , ll_r , ll_cnt=0

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 


For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
		ls_new = dw_insert.Object.is_new[i]
		If ls_new = 'N' Then
			ls_carcode = Trim(dw_insert.Object.carcode[i])
			ls_seq     = Trim(dw_insert.Object.seq[i])
			ls_itnbr   = Trim(dw_insert.Object.itnbr[i])
			
			Delete From CARBOM Where carcode = :ls_carcode 
			                     and seq = :ls_seq
										and itnbr = :ls_itnbr ;
										
			If sqlca.sqlcode <> 0 Then
				MessageBox('확인',sqlca.sqlerrText )
				Rollback;
				Return
			End iF
		End if
			
		dw_insert.DeleteRow(i)
		
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	Commit ;
	//dw_insert.Retrieve( is_itnbr)
End IF

end event

type p_mod from w_inherite`p_mod within w_sm10_0017
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0 ,ll_cnt2 = 0 ,ll_rtn=0  , ll_f 
String ls_new ,ls_null , ls_itnbr ,ls_chek
String ls_carcode ,ls_seq , ls_bigo , ls_bigo_s

Dec ll_rate


String ls_cargbn1,ls_cargbn2,ls_cargbn3,ls_cargbn4,ls_cargbn5,ls_cargbn7

If dw_insert.AcceptText() < 1 Then Return 
ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
SetNull(ls_null)
If rb_1.Checked Then
	For i = 1 To ll_r
		
		ls_new = Trim(dw_insert.Object.is_new[i])
		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
		ls_chek = Trim(dw_insert.Object.yebi1[i])
		
		If ls_new = 'Y' Then
			
			If ls_itnbr = '' Or isNull(ls_itnbr) Then
				MessageBox('확인',String(i)+' 행의 품번이 필요합니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('itnbr')
			End IF
			
			Select Count(*) Into :ll_cnt
			  from carbom
			 where  carcode = :is_carcode 
			   and seq = :is_seq 
				and itnbr = :ls_itnbr ;
			 
			If ll_cnt > 0 Then
				MessageBox('확인',String(i)+' 행의 해당 제품은 해당차종에 이미 등록된 품번입니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('itnbr')
				Rollback;
				Return
			End If
		
		End If
		
		ll_rate = dw_insert.object.yebid1[i]
		If ll_rate = 0 or isNull(ll_rate) Then 
			dw_insert.object.yebid1[i] = 1
		else
			dw_insert.object.yebid1[i] = Truncate(ll_rate,2)
		end if
	
	Next
	

	
ElseIf rb_2.Checked Then

	For i = 1 To  ll_r
		
		ls_new = Trim(dw_insert.Object.is_new[i])
		ls_carcode = Trim(dw_insert.Object.carcode[i])
		ls_seq =  Trim(dw_insert.Object.seq[i])
		
		ls_cargbn1 = Trim(dw_insert.Object.cargbn1[i])
		ls_cargbn2 = Trim(dw_insert.Object.cargbn2[i])
		ls_cargbn3 = Trim(dw_insert.Object.cargbn3[i])
		ls_cargbn4 = Trim(dw_insert.Object.cargbn4[i])
		ls_cargbn5 = Trim(dw_insert.Object.cargbn5[i])
		ls_cargbn7 = Trim(dw_insert.Object.cargbn7[i])
		ls_bigo    = Trim(dw_insert.Object.bigo[i])
		
		If ls_cargbn1 = '' or isNull(ls_cargbn1) Then 
			dw_insert.Object.cargbn1[i] = '.'
			ls_cargbn1 = '.'
		end if
		
		If ls_cargbn2 = '' or isNull(ls_cargbn2) Then 
			dw_insert.Object.cargbn2[i] = '.'
			ls_cargbn2 = '.'
		end if
		
		If ls_cargbn3 = '' or isNull(ls_cargbn3) Then 
			dw_insert.Object.cargbn3[i] = '.'
			ls_cargbn3 = '.'
		end if
		
		If ls_cargbn4 = '' or isNull(ls_cargbn4) Then 
			dw_insert.Object.cargbn4[i] = '.'
			ls_cargbn4 = '.'
		end if
		
		If ls_cargbn5 = '' or isNull(ls_cargbn5) Then 
			dw_insert.Object.cargbn5[i] = '.'
			ls_cargbn5 = '.'
		end if
		
		If ls_cargbn7 = '' or isNull(ls_cargbn7) Then 
			dw_insert.Object.cargbn7[i] = '.'
			ls_cargbn7 = '.'
		end if
		
		If ls_carcode = '' Or isNull(ls_carcode) Then
			MessageBox('확인',"저장실패 "+String(i)+' 행의 차종코드이 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('carcode')
			Rollback;
			Return

		End IF
		
		If i <> ll_r Then 
		
			ll_f = dw_insert.Find("carcode='"+ls_carcode+"' and "+&
										 "cargbn1='"+ls_cargbn1+"' and "+&
										 "cargbn2='"+ls_cargbn2+"' and "+&
										 "cargbn3='"+ls_cargbn3+"' and "+&
										 "cargbn4='"+ls_cargbn4+"' and "+&
										 "cargbn5='"+ls_cargbn5+"' and "+&
										 "cargbn7='"+ls_cargbn7+"'" , i+1 , ll_r)
										 
			If ll_f > 0 Then
				MessageBox('확인1',"저장실패 "+String(i)+' 행의 해당 제품은 중복된 모델입니다.')
				dw_insert.ScrollToRow(i)
				Rollback;
				Return
			End If
		End If
					

		ll_cnt = 0 
		Select count(*) Into :ll_cnt 
		  From carmst
		 where carcode = :ls_carcode
			and cargbn1 = :ls_cargbn1
			and cargbn2 = :ls_cargbn2
			and cargbn3 = :ls_cargbn3
			and cargbn4 = :ls_cargbn4
			and cargbn5 = :ls_cargbn5
			and cargbn7 = :ls_cargbn7 ;
			
		If ll_cnt = 0 Then
			
			Select max(seq) Into :ls_seq
			  From carmst
			 Where carcode = :ls_carcode ;
			 
			If ls_seq = '' or isNull(ls_seq) Then 
				ls_seq = '010'
			else
				ls_seq = String( Long(ls_seq) + 10 , '000')
				
				Insert Into carmst ( carcode ,  seq ,
											cargbn1 ,
											cargbn2 ,
											cargbn3 ,
											cargbn4 ,
											cargbn5 ,
											cargbn7 ,
											bigo )
								Values ( :ls_carcode , :ls_seq ,
											:ls_cargbn1 ,
											:ls_cargbn2 ,
											:ls_cargbn3 ,
											:ls_cargbn4 ,
											:ls_cargbn5 ,
											:ls_cargbn7 ,
											:ls_bigo ) ;
											
				IF sqlca.sqlcode <> 0 Then
					MessageBox('확인',sqlca.sqlerrText)
					Rollback;
					Return
				end if
				
			end if
		else
			
			
			Select seq  , Trim(bigo) Into :ls_seq , :ls_bigo_s
			  From carmst
			 where carcode = :ls_carcode
				and cargbn1 = :ls_cargbn1
				and cargbn2 = :ls_cargbn2
				and cargbn3 = :ls_cargbn3
				and cargbn4 = :ls_cargbn4
				and cargbn5 = :ls_cargbn5
				and cargbn7 = :ls_cargbn7 ;
			
			If isNull(ls_bigo) = false  and ( (  ls_bigo <> ls_bigo_s ) or ( isNull(ls_bigo_s) or ls_bigo_s = '' )) Then
				Update carmst Set bigo = :ls_bigo
								Where carcode = :ls_carcode
								  and seq = :ls_seq ;
				If sqlca.sqlnrows = 0 Then
					Messagebox('' , sqlca.sqlerrText )
					rollback;
					Return -1
				End if
			End if
			
		end if
		
		dw_insert.Object.seq[i] = ls_seq
			
		If ls_new = 'Y' Then								
			ll_cnt = 0 
			Select Count(*) Into :ll_cnt
			  from carbom
			 where  carcode = :ls_carcode and seq = :ls_seq and itnbr = :is_itnbr ;
			 
			If ll_cnt > 0 Then
				MessageBox('확인2',"저장실패 "+String(i)+' 행의 차종-모델은 이미 등록된 모델입니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('carcode')
				Rollback;
				Return
			End If
			
		End If
		
		ll_rate = dw_insert.object.yebid1[i]
		If ll_rate = 0 or isNull(ll_rate) Then 
			dw_insert.object.yebid1[i] = 1
		else
			dw_insert.object.yebid1[i] = Truncate(ll_rate,2)
		end if

	Next
Else
	
	For i = 1 To ll_r
		
		ls_new = Trim(dw_insert.Object.is_new[i])
		ls_itnbr = Trim(dw_insert.Object.itnbr[i])
		ls_chek = Trim(dw_insert.Object.yebi1[i])
		ls_seq =  Trim(dw_insert.Object.seq[i])
		
		If ls_new = 'Y' Then
			
			If ls_seq = '' Or isNull(ls_seq) Then
				MessageBox('확인',String(i)+' 행의 모델코드가 필요합니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('seq')
			End IF
			
			
			If ls_itnbr = '' Or isNull(ls_itnbr) Then
				MessageBox('확인',String(i)+' 행의 품번이 필요합니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('itnbr')
			End IF
			
			ll_cnt = 0 
			Select Count(*) Into :ll_cnt
			  from carbom
			 where  carcode = :is_carcode 
			   and seq = :ls_seq ;
				
			If ll_cnt = 0 Then
				MessageBox('확인',String(i)+' 행의 해당 모델은 해당차종에 등록된 모델이 아닙니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('seq')
				Rollback;
				Return
			End If
				
			ll_cnt = 0 
			Select Count(*) Into :ll_cnt
			  from carbom
			 where  carcode = :is_carcode 
			   and seq = :ls_seq 
				and itnbr = :ls_itnbr ;
			 
			If ll_cnt > 0 Then
				MessageBox('확인',String(i)+' 행의 해당 제품은 해당차종에 이미 등록된 품번입니다.')
				dw_insert.ScrollToRow(i)
				dw_insert.SetFocus()
				dw_insert.SetColumn('itnbr')
				Rollback;
				Return
			End If
		
		End If
		
		ll_rate = dw_insert.object.yebid1[i]
		If ll_rate = 0 or isNull(ll_rate) Then 
			dw_insert.object.yebid1[i] = 1
		else
			dw_insert.object.yebid1[i] = Truncate(ll_rate,2)
		end if
	
	Next
	
	
End If

If f_msg_update() < 1 Then Return

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('저장실패','저장실패')
	Return
Else
	Commit;
	p_inq.PostEvent(Clicked!)
End iF

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0017
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0017
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0017
end type

type cb_del from w_inherite`cb_del within w_sm10_0017
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0017
end type

type cb_print from w_inherite`cb_print within w_sm10_0017
end type

type st_1 from w_inherite`st_1 within w_sm10_0017
end type

type cb_can from w_inherite`cb_can within w_sm10_0017
end type

type cb_search from w_inherite`cb_search within w_sm10_0017
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0017
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0017
end type

type dw_1 from datawindow within w_sm10_0017
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 16
integer width = 2318
integer height = 264
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0017_2"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;
IF getColumnName() = 'carname' Then
	p_inq.TriggerEvent(Clicked!)
End If
end event

event itemchanged;str_code lst_code
Long i , ll_i = 0 , ll_row
String ls_carcode , ls_seq , ls_null
String ls_scd8a , ls_scd8b, ls_scd8c, ls_scd8d, ls_scd8e, ls_scd8f ,ls_scd8g , ls_scd8h, ls_scd8i
Long ll_seq , ll_cnt=0

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)
sle_msg.text = ''


ll_row = dw_insert.RowCount() + 1

SetNull(ls_null)
	
If getColumnName() = "carcode" Then
	
	If is_itnbr = '' Or isNull(is_itnbr) Then
	
		MessageBox('확인','품번을 선택 후 차종모델을 선택할 수 있습니다.')
		dw_1.SetItem(1,"carcode" , ls_null)
		Return 1
	End If
	
	gs_code = GetText()
	Open(w_carcode_popup)
	
	lst_code = Message.PowerObjectParm
	IF isValid(lst_code) = False Then Return 
	If UpperBound(lst_code.code) < 1 Then Return 
	
	
	For i = ll_row To UpperBound(lst_code.code)   + ll_row - 1
		
		ll_i++
		//if i > ll_row or ll_row = 1 then 
			p_ins.triggerevent("clicked")
			
		//End If
		
		dw_insert.SetItem(i,"carcode",lst_code.code[ll_i])
		dw_insert.SetItem(i,"carname",lst_code.codename[ll_i])
		dw_insert.SetItem(i,"seq",lst_code.sgubun1[ll_i])
		
		ls_carcode = 	lst_code.code[ll_i]
		ls_seq     = 	lst_code.sgubun1[ll_i]
		
		SELECT SCD8A 	  , SCD8B      ,SCD8C   ,SCD8D     ,SCD8E     ,SCD8F      ,SCD8G     ,SCD8H     ,SCD8I 
		  into :ls_scd8a , :ls_scd8b, :ls_scd8c, :ls_scd8d, :ls_scd8e, :ls_scd8f ,:ls_scd8g , :ls_scd8h, :ls_scd8i
		  FROM CARMST
		 WHERE CARCODE = :ls_carcode
			AND SEQ = :ls_seq ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			f_message_chk(33,'[차종모델]')
			
			dw_insert.Object.seq[i]    	= '000'
			
			dw_insert.SetColumn("seq")
			Continue ;
		Else
			
			dw_insert.Object.scd8a[i] = ls_scd8a
			dw_insert.Object.scd8b[i] = ls_scd8b
			dw_insert.Object.scd8c[i] = ls_scd8c
			dw_insert.Object.scd8d[i] = ls_scd8d
			dw_insert.Object.scd8e[i] = ls_scd8e
			dw_insert.Object.scd8f[i] = ls_scd8f
			dw_insert.Object.scd8g[i] = ls_scd8g
			dw_insert.Object.scd8h[i] = ls_scd8h
			dw_insert.Object.scd8i[i] = ls_scd8i
		End iF
		
	Next

	dw_1.SetItem(1,"carcode" , ls_null)
	Return 1
End If
	
end event

event itemerror;return 1
end event

type dw_list from datawindow within w_sm10_0017
integer x = 32
integer y = 316
integer width = 1440
integer height = 1928
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0017_a2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;
If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
	
	SetNull(gs_code)
	dw_insert.SetRedraw(false)
	If rb_1.Checked Then
		
		is_carcode = Trim(This.Object.carcode[row])
		is_seq     = Trim(This.Object.seq[row])
		
		dw_insert.Retrieve( is_carcode ,is_seq)
		
	ElseIf rb_2.Checked Then
		
		is_itnbr = Trim(This.Object.itnbr[row])
		dw_insert.Retrieve( is_itnbr)
		
	Else
		is_carcode = Trim(This.Object.carcode[row])
	
		dw_insert.Retrieve( is_carcode)
	End If
		
	dw_insert.SetRedraw(true)
END IF
end event

type p_2 from uo_picture within w_sm10_0017
boolean visible = false
integer x = 3355
integer y = 24
boolean bringtotop = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//
//If rb_1.checked Then
//	If is_carcode = '' Or isNull(is_carcode) Then
//		MessageBox('확인','차종코드를 선택 후 품번을 추가할 수 있습니다.')
//		Return
//	End If
//	open(w_carcode_popup)
//	
//	If gs_code = "" or isNull(gs_code) Or gs_codename = "" or isNull(gs_codename) Then
//		Return
//	Else
//		Long ll_row
//		String ls_itnbr ,ls_itdsc ,ls_ispec ,ls_jijil
//		ll_row = dw_insert.RowCount()
//		
//		
//		// 기존 데이타에서가져온다 . ======================
//		Declare car_cur Cursor For
//		
//			SELECT A.ITNBR ,
//					 B.ITDSC ,
//					 B.ISPEC ,
//					 B.JIJIL 
//			  FROM ITEMAS B ,
//					 CARBOM A
//			 WHERE A.ITNBR = B.ITNBR
//				AND A.CARCODE = :gs_code
//				AND A.SEQ = :gs_codename
//		ORDER BY A.SEQ ;
//		
//		Open car_cur;
//		
//		Do While True
//			Fetch car_cur Into :ls_itnbr ,:ls_itdsc ,:ls_ispec ,:ls_jijil ;
//			
//			If SQLCA.SQLCODE <> 0 Then Exit
//			ll_row = dw_insert.insertRow(0)
//			dw_insert.Object.itnbr[ll_row] = ls_itnbr
//			dw_insert.Object.itemas_itdsc[ll_row] = ls_itdsc
//			dw_insert.Object.itemas_ispec[ll_row] = ls_ispec
//			dw_insert.Object.itemas_jijil[ll_row] = ls_jijil
//			
//			dw_insert.Object.carcode[ll_row] = is_carcode
//			dw_insert.Object.seq[ll_row] = is_seq
//				
//		Loop
//			
//		Close car_cur;
//	//===========================================================
//		
//	End If
//Else
//	If is_itnbr = '' Or isNull(is_itnbr) Then
//		MessageBox('확인','품번을 선택 후 차종모델을 추가할 수 있습니다.')
//		Return
//	End If
//End If
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type rb_1 from radiobutton within w_sm10_0017
integer x = 2761
integer y = 76
integer width = 402
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
string text = "차종-모델"
end type

event clicked;wf_init()
end event

type rb_2 from radiobutton within w_sm10_0017
integer x = 3209
integer y = 76
integer width = 293
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

type rb_3 from radiobutton within w_sm10_0017
integer x = 2427
integer y = 76
integer width = 306
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

type p_excel from uo_picture within w_sm10_0017
integer x = 3579
integer y = 164
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

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

//String	ls_quota_no
//integer	li_rc
//string	ls_filepath, ls_filename
//boolean	lb_fileexist
//
//Long i
//String ls_carcode
//
//If dw_1.AcceptText() < 1 Then Return
//
//
//li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
//											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
//IF li_rc = 1 THEN
//	IF lb_fileexist THEN
//		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
//												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
//		IF li_rc = 2 THEN 
//			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
//			RETURN
//		END IF
//	END IF
//	
//	Setpointer(HourGlass!)
//	
//	If cbx_1.Checked Then
//		ls_carcode = '%'
//	else
//		ls_carcode = is_carcode
//	End if
//	
//	If ls_carcode = '' or isNull(ls_carcode) Then ls_carcode = '%'
//	
//	If dw_excel.Retrieve(ls_carcode) <= 0 Then
//		f_message_chk(50,'')
//		Return
//	End If
//	
// 	If dw_excel.SaveAsAscii(ls_filepath) <> 1 Then
//		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
//		return
//	End If
//
//END IF
//
//w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type cbx_1 from checkbox within w_sm10_0017
integer x = 3808
integer y = 232
integer width = 402
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
string text = "차종전체"
end type

type dw_excel from datawindow within w_sm10_0017
boolean visible = false
integer x = 2587
integer y = 212
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0017_excel"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sm10_0017
integer x = 1906
integer y = 256
integer width = 1637
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
string text = "* 생산비율은 소수점으로 입력하세요.( 예 90 % -> 0.9 )"
boolean focusrectangle = false
end type

type st_splitbar from u_st_splitbar within w_sm10_0017
integer x = 1472
integer y = 316
integer width = 23
integer height = 1928
boolean bringtotop = true
long textcolor = 8421504
long backcolor = 8421504
end type

type gb_1 from groupbox within w_sm10_0017
integer x = 2354
integer y = 4
integer width = 1189
integer height = 172
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

