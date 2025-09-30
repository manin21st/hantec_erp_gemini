$PBExportHeader$w_sm01_00015_popup.srw
$PBExportComments$월 판매계획 접수
forward
global type w_sm01_00015_popup from w_inherite_popup
end type
type dw_list1 from datawindow within w_sm01_00015_popup
end type
type dw_list2 from datawindow within w_sm01_00015_popup
end type
type st_2 from statictext within w_sm01_00015_popup
end type
type st_3 from statictext within w_sm01_00015_popup
end type
type dw_list3 from datawindow within w_sm01_00015_popup
end type
type st_4 from statictext within w_sm01_00015_popup
end type
type rr_2 from roundrectangle within w_sm01_00015_popup
end type
type rr_1 from roundrectangle within w_sm01_00015_popup
end type
type rr_3 from roundrectangle within w_sm01_00015_popup
end type
end forward

global type w_sm01_00015_popup from w_inherite_popup
integer width = 3817
integer height = 2312
string title = "차종계획 -> 품번 계산내역"
boolean controlmenu = true
dw_list1 dw_list1
dw_list2 dw_list2
st_2 st_2
st_3 st_3
dw_list3 dw_list3
st_4 st_4
rr_2 rr_2
rr_1 rr_1
rr_3 rr_3
end type
global w_sm01_00015_popup w_sm01_00015_popup

type variables
str_code istr_code
end variables

on w_sm01_00015_popup.create
int iCurrent
call super::create
this.dw_list1=create dw_list1
this.dw_list2=create dw_list2
this.st_2=create st_2
this.st_3=create st_3
this.dw_list3=create dw_list3
this.st_4=create st_4
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list1
this.Control[iCurrent+2]=this.dw_list2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_list3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_3
end on

on w_sm01_00015_popup.destroy
call super::destroy
destroy(this.dw_list1)
destroy(this.dw_list2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_list3)
destroy(this.st_4)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;	
dw_jogun.SetTransObject(sqlca)
dw_list1.SetTransObject(sqlca)
dw_list2.SetTransObject(sqlca)
dw_list3.SetTransObject(sqlca)

dw_1.InsertRow(0)
dw_1.SetItem(1, 'carcode', gs_code)

String ls_carname
Long i , ll_rcnt , ii , ll_f

String ls_st_cvcod ,ls_s1 , ls_s2 , ls_s3 , ls_s4 ,ls_s5 , ls_s6 , ls_s7
String  ls_str1 , ls_str2 , ls_str3 , ls_str4 ,ls_str5 , ls_str6 , ls_str7
string old_select, new_select, where_clause
String ls_op , ls_opstr

Long ll_seq

Select carname Into :ls_carname
  From carhead
 Where carcode = :gs_code ;
 
dw_1.object.carname[1] = ls_carname

dw_list1.Retrieve(gs_saupj , gs_gubun , gs_code )
If dw_list2.Retrieve( gs_code ) > 0 Then
	For i=1 To dw_list2.RowCount()
		If Trim(dw_list2.object.itnbr[i]) = gs_codename Then
			dw_list2.SelectRow(i,true) 
			
		
			// 적용지역 ======================================================
			ls_s3 = Trim(dw_list2.object.cargbn2[i])
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
			ls_s4 = Trim(dw_list2.object.cargbn3[i])
			
			If ls_s4 = '.' Then 
				ls_str4 = " s4 like '%' "
			Else
				ls_str4 = " s4 like '" + ls_s4 +"'"
			End iF
			
			// 연료   ======================================================
			ls_s5 = Trim(dw_list2.object.cargbn4[i])
			If ls_s5 = '.' Then 
				ls_str5 = " s5 like '%' "
			Else
				ls_str5 = " s5 like '" + ls_s5 +"'"
				
			End iF
			
			// 미션   ======================================================
			ls_s6 = Trim(dw_list2.object.cargbn5[i])
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
			
			old_select = dw_jogun.GetSQLSelect()
			
			where_clause = "  AND A.SAUPJ = '"+gs_saupj+"'"+&
								"  AND A.YYMM  = '"+gs_gubun+"'"+&
								"  AND B.CARCODE = '"+gs_code+"'"+&
								"  AND " + ls_str3 +&
								"  AND " + ls_str4 +&
								"  AND " + ls_str5 +&
								"  AND " + ls_str6 
			
			new_select = old_select + where_clause
			
			dw_jogun.SetSQLSelect(new_select)
			
			ll_rcnt = dw_jogun.Retrieve() 
			
			dw_jogun.SetSQLSelect(old_select)
			
			For ii = 1 to ll_rcnt
			   ll_seq = dw_jogun.object.seq[ii]
				ll_f = dw_list1.Find("seq = "+string(ll_seq),1,dw_list1.RowCount())
		
				If ll_f > 0 Then
					
					dw_list1.SelectRow(ll_f,true)
					dw_list1.object.selqty[ll_f] = dw_list1.object.mmqty[ll_f]
				end if
			Next
					
			dw_list2.ScrollToRow(i)
		end if
	Next
end if

dw_jogun.BringToTop = True
	
dw_list3.Retrieve(gs_saupj , gs_gubun , gs_code , gs_codename )



	


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm01_00015_popup
boolean visible = false
integer x = 2299
integer y = 32
integer width = 1111
integer height = 368
boolean titlebar = true
string dataobject = "d_sm01_00015_popup_calc"
boolean vscrollbar = true
boolean resizable = true
end type

type p_exit from w_inherite_popup`p_exit within w_sm01_00015_popup
integer x = 3602
integer y = 40
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_gubun)
Close(Parent)
end event

event p_exit::ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_sm01_00015_popup
boolean visible = false
integer x = 27
integer y = 1148
end type

type p_choose from w_inherite_popup`p_choose within w_sm01_00015_popup
boolean visible = false
integer x = 3429
integer y = 40
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\생성_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm01_00015_popup
integer x = 27
integer y = 24
integer width = 2299
integer height = 168
string dataobject = "d_sm01_00015_popup_1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::rowfocuschanged;//
end event

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm01_00015_popup
integer x = 183
integer y = 2332
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm01_00015_popup
integer x = 1344
integer y = 2320
end type

type cb_return from w_inherite_popup`cb_return within w_sm01_00015_popup
integer x = 1979
integer y = 2320
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm01_00015_popup
integer x = 1664
integer y = 2320
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm01_00015_popup
integer y = 2260
end type

type st_1 from w_inherite_popup`st_1 within w_sm01_00015_popup
end type

type dw_list1 from datawindow within w_sm01_00015_popup
integer x = 41
integer y = 244
integer width = 2345
integer height = 984
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00015_popup_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type dw_list2 from datawindow within w_sm01_00015_popup
integer x = 2432
integer y = 244
integer width = 1312
integer height = 984
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00015_popup_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_sm01_00015_popup
integer x = 69
integer y = 184
integer width = 334
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 32106727
string text = "[ 차종계획 ]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm01_00015_popup
integer x = 2450
integer y = 184
integer width = 334
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 32106727
string text = "[ 차종 BOM ]"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_list3 from datawindow within w_sm01_00015_popup
integer x = 41
integer y = 1308
integer width = 3721
integer height = 880
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_00015_popup_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type st_4 from statictext within w_sm01_00015_popup
integer x = 69
integer y = 1248
integer width = 334
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 32106727
string text = "[ 계산내역 ]"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sm01_00015_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 208
integer width = 2368
integer height = 1032
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_sm01_00015_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1272
integer width = 3749
integer height = 936
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm01_00015_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2418
integer y = 208
integer width = 1353
integer height = 1032
integer cornerheight = 40
integer cornerwidth = 55
end type

