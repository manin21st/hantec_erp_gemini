$PBExportHeader$w_qa02_00010.srw
$PBExportComments$** 부적합통보서 발행
forward
global type w_qa02_00010 from w_inherite
end type
type dw_1 from datawindow within w_qa02_00010
end type
type rb_1 from radiobutton within w_qa02_00010
end type
type rb_2 from radiobutton within w_qa02_00010
end type
type rb_3 from radiobutton within w_qa02_00010
end type
type rb_4 from radiobutton within w_qa02_00010
end type
type rr_1 from roundrectangle within w_qa02_00010
end type
end forward

global type w_qa02_00010 from w_inherite
integer height = 2468
string title = "품질개선 요구서 등록"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_1 rr_1
end type
global w_qa02_00010 w_qa02_00010

on w_qa02_00010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_1
end on

on w_qa02_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(SQLCA)
dw_insert.settransobject(SQLCA)

dw_1.InsertRow(0)

dw_1.Object.sdate[1] = f_afterday(f_today() , -30)
dw_1.Object.edate[1] = f_today()

dw_1.setitem(1,'saupj',gs_saupj)
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00010
integer x = 32
integer y = 216
integer width = 4558
integer height = 2064
integer taborder = 20
string dataobject = "d_qa02_00010_a_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::doubleclicked;//SetNull(gs_gubun)
//SetNull(gs_code )
//
//String ls_baldat ,ls_Parm ,ls_null
//
//If row > 0 then
//	
//	SetNull(ls_null)
//	gs_gubun = this.getitemstring(row, "iogbn")
//	gs_code  = this.getitemstring(row, "iojpno")
//	
//	Open(w_qa02_00011)
//	
//	ls_parm = Trim(Message.StringParm)
//	
//	If isNull(ls_parm) = False And ls_parm = 'OK'  Then
//		SetNull(ls_baldat)
//		Select baldat Into :ls_baldat
//		  From IMHFAG 
//		 Where sabu = '1' and iojpno = :gs_code ;
//		
//		dw_insert.Object.baldat[row] = ls_baldat
//		dw_insert.Object.status[row] = 'Y'
//	Else
//		dw_insert.Object.baldat[row] = ls_null
//		dw_insert.Object.status[row] = ls_null
//	End If
//	
//	
//AcceptText()
//End if

end event

event dw_insert::itemchanged;call super::itemchanged;SetNull(gs_gubun)
SetNull(gs_code )

String ls_status , ls_baldat ,ls_Parm ,ls_null , ls_fag_jpno
AcceptText()
If GetColumnName() = "status" Then
	
	ls_status = Trim(GetText())
	If ls_status = 'Y' Then
		
		SetNull(ls_null)
		SetNull(gs_gubun)
		SetNull(gs_code)
		SetNull(ls_status)
		SetNull(ls_baldat)
		
		gs_gubun = this.getitemstring(row, "iogbn")
		gs_code  = this.getitemstring(row, "iojpno")
	
		Select status , baldat 
		  Into :ls_status , :ls_baldat
		  From IMHFAG 
		 Where sabu = :gs_sabu and iojpno = :gs_code ;
		
		If isNull(ls_status) or ls_status = 'N' Then 

			Open(w_qa02_00011)
			
			SetNull(ls_status)
			SetNull(ls_baldat)
				
			Select status , baldat 
			  Into :ls_status , :ls_baldat
			  From IMHFAG 
			 Where sabu = :gs_sabu and iojpno = :gs_code ;
				
			If isNull(ls_status) or ls_status = 'N' Then 
				dw_insert.Object.baldat[row] = ls_null
				dw_insert.Object.status[row] = 'A'
				Return 1
			Else
				dw_insert.Object.baldat[row] = ls_baldat
				
			End IF
		End If
	End If	
AcceptText()
End if
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::buttonclicked;call super::buttonclicked;SetNull(gs_gubun)
SetNull(gs_code )

String 	ls_status , ls_baldat ,ls_Parm ,ls_null , ls_fag_jpno
string	ls_jochydat,  ls_jochwdat,  ls_submit_yn
AcceptText()

If dwo.name = "b_bin" Then
	
	SetNull(ls_null)
	SetNull(ls_status)
	
	gs_code  = this.getitemstring(row, "x_iojpno")
	
	
	Select status , balsite_dt 
	  Into :ls_status , :ls_baldat
	  From IMHFAG 
	 Where fagno = :gs_code ;
	
	if sqlca.sqlcode = 0 then
//		If ls_status = 'N' Then 
//			MessageBox('확인','해당 불량내용에는 부적합 통보서가 존재하지 않습니다.') 
//			Return 
//		End If
	else
		MessageBox('확인','해당 불량내용에는 부적합 통보서가 존재하지 않습니다.') 
		Return 
	end if
	
	gs_gubun = 'A' 
	Open(w_qa02_00011)
	
	ls_parm = Trim(Message.StringParm)
		
	SetNull(ls_baldat)
			
	Select status , balsite_dt,  jochydat,  jochwdat,  submit_yn
	  Into :ls_status , :ls_baldat,  :ls_jochydat, :ls_jochwdat, :ls_submit_yn
	  From IMHFAG 
	 Where fagno = :gs_code ;
	
	if sqlca.sqlcode = 0 then
		dw_insert.Object.jochydat[row] = ls_jochydat
		dw_insert.Object.jochwdat[row] = ls_jochwdat
//		dw_insert.Object.submit_yn[row] = ls_submit_yn
		dw_insert.Object.status[row] = ls_status
//	Else
//		dw_insert.Object.balsite_dt[row] = ls_null
//		dw_insert.Object.status[row] = 'A'
	End IF
	
	
AcceptText()
End if
end event

event dw_insert::clicked;call super::clicked;If row > 0 Then
	If isSelected(row) Then
		SelectRow(row, False)
	Else
		SelectRow(0, False)
		SelectRow(row, True)
	End If
End If
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00010
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00010
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa02_00010
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa02_00010
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa02_00010
integer x = 4425
end type

type p_can from w_inherite`p_can within w_qa02_00010
integer x = 4251
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_qa02_00010
boolean visible = false
integer x = 4827
integer y = 132
end type

event p_print::clicked;call super::clicked;//if dw_1.accepttext() = -1 then return
//
//gs_code  	 = dw_1.getitemstring(1, "sdate")
//gs_codename  = dw_1.getitemstring(1, "edate")
//
//if isnull(gs_code) or trim(gs_code) = '' then
//	gs_code = '10000101'
//end if
//
//if isnull(gs_codename) or trim(gs_codename) = '' then
//	gs_codename = '99991231'
//end if
//
//open(w_qct_01075_1)
//
//Setnull(gs_code)
//Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_qa02_00010
integer x = 4078
end type

event p_inq::clicked;String ssdate, sedate, sgubun, sstatus, sdptgu, snull, sgubun2
String ls_saupj

If dw_1.accepttext() = -1 Then Return
SetNull(snull)

ls_saupj = dw_1.getitemstring(1,"saupj")
IF IsNull(ls_saupj) or trim(ls_saupj) = '' THEN
   f_message_chk(33, '[사업장]')
	RETURN
END IF

ssdate = trim(dw_1.getitemstring(1, "sdate"))
sedate = trim(dw_1.getitemstring(1, "edate"))
sgubun = trim(dw_1.getitemstring(1, "fagbn"))
sgubun2= trim(dw_1.getitemstring(1, "status"))

If sgubun = '1' Then
	sstatus = 'Y'
ElseIf sgubun = '2' Then
	sstatus = 'N'
ElseIf sgubun = '3' Then
	sstatus = 'A'
Else
	sstatus = '전체'
End If

If isnull(ssdate) or trim(ssdate) = '' Then
	ssdate = '10000101'
End If

If isnull(sedate) or trim(sedate) = '' Then
	ssdate = '99991231'
End If

dw_insert.Setredraw(False)

If dw_insert.Retrieve(ssdate, sedate, sgubun, sgubun2, ls_saupj) > 0 Then
//	if sstatus <> '전체' then
//		dw_insert.setfilter("status = '"+ sstatus +"'")
//		dw_insert.filter()
//		dw_insert.SetFilter('')
//	end if
Else
   f_message_chk(50, '[이상발생 내역]')
End If

dw_insert.Setredraw(True)
end event

type p_del from w_inherite`p_del within w_qa02_00010
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_qa02_00010
boolean visible = false
integer x = 3662
integer y = 20
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

If f_msg_update() < 1 Then Return

String ls_status ,ls_jpno ,ls_iojpno ,ls_iogbn ,ls_null
Long   i
SetNull(ls_null)

For i = 1 To dw_insert.RowCount()
	
	ls_status = Trim(dw_insert.Object.status[i])
	ls_iojpno = Trim(dw_insert.Object.iojpno[i])
	ls_jpno   = Trim(dw_insert.Object.fag_iojpno[i])
	
	If isNull(ls_status) Or ls_status = 'A' Then   // 검토중
	  
		If isNull(ls_jpno) = False  Then
	
			DELETE FROM IMHFAG 
			      WHERE IOJPNO = :ls_jpno 
					  AND SABU = :gs_sabu ;
		Else
		   Continue ;			
		End If
	ElseIf ls_status = 'N' Then // 미발행 
		If isNull(ls_jpno) Then
			INSERT INTO IMHFAG ( SABU ,    IOJPNO ,    STATUS )
			            VALUES (:gs_sabu , :ls_iojpno, :ls_status ) ;
		Else
			UPDATE IMHFAG SET STATUS = :ls_status ,
			                  BALDAT = :ls_null
			            WHERE IOJPNO = :ls_jpno ;
		End If
	Else                        // 발행 
		Continue ;
	End If
	
	If SQLCA.SQLCODE <> 0 Then
		Rollback ;
		f_message_chk(31 ,'')
		Return
	End If
Next

Commit;

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qa02_00010
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00010
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa02_00010
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa02_00010
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa02_00010
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa02_00010
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa02_00010
end type

type cb_can from w_inherite`cb_can within w_qa02_00010
end type

type cb_search from w_inherite`cb_search within w_qa02_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_qa02_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00010
end type

type dw_1 from datawindow within w_qa02_00010
integer x = 14
integer y = 24
integer width = 3552
integer height = 172
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa02_00010_1_new"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, sdata 
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'sdate' then
	sdata = this.gettext()
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[시작일자]');
		this.setitem(1, "sdate", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'edate' then
	sdata = this.gettext()	
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[종료일자]');
		this.setitem(1, "edate", snull)
		return 1		
	end if
	if this.getitemstring(1, "sdate") > sdata then
		
		
	end if
	
end if
end event

event itemerror;return 1
end event

event constructor;//this.settransobject(sqlca)
end event

type rb_1 from radiobutton within w_qa02_00010
boolean visible = false
integer x = 4663
integer y = 424
integer width = 279
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
string text = "발행"
end type

type rb_2 from radiobutton within w_qa02_00010
boolean visible = false
integer x = 4663
integer y = 492
integer width = 279
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
string text = "미발행"
end type

type rb_3 from radiobutton within w_qa02_00010
boolean visible = false
integer x = 5001
integer y = 416
integer width = 279
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
string text = "검토중"
boolean checked = true
end type

type rb_4 from radiobutton within w_qa02_00010
boolean visible = false
integer x = 5033
integer y = 496
integer width = 279
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
string text = "전체"
end type

type rr_1 from roundrectangle within w_qa02_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 208
integer width = 4585
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

