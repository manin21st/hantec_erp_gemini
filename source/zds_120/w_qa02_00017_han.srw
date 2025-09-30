$PBExportHeader$w_qa02_00017_han.srw
$PBExportComments$** 개선대책등록-한텍
forward
global type w_qa02_00017_han from w_inherite
end type
type dw_1 from datawindow within w_qa02_00017_han
end type
type rb_1 from radiobutton within w_qa02_00017_han
end type
type rb_2 from radiobutton within w_qa02_00017_han
end type
type rb_3 from radiobutton within w_qa02_00017_han
end type
type rb_4 from radiobutton within w_qa02_00017_han
end type
type rr_1 from roundrectangle within w_qa02_00017_han
end type
end forward

global type w_qa02_00017_han from w_inherite
integer width = 4663
integer height = 2468
string title = "개선 대책 등록"
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_1 rr_1
end type
global w_qa02_00017_han w_qa02_00017_han

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" alias for "CopyFileA;Ansi"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" alias for "ShellExecuteA;Ansi" 
end prototypes

on w_qa02_00017_han.create
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

on w_qa02_00017_han.destroy
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

type dw_insert from w_inherite`dw_insert within w_qa02_00017_han
integer x = 32
integer y = 216
integer width = 4558
integer height = 2064
integer taborder = 20
string dataobject = "d_qa02_00017_han_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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

event dw_insert::itemchanged;call super::itemchanged;String	ls_baldat, ls_yn
//AcceptText()

If GetColumnName() = "submit_dt" Then
	
	ls_baldat = Trim(GetText())
	if isnull(ls_baldat) or ls_baldat = '' then return
	
	if f_datechk(ls_baldat) = -1 then
		messagebox('확인','날짜 지정 오류!!!')
		return 1
	end if
		
ElseIf GetColumnName() = "jochwdat" Then
	
	ls_baldat = Trim(GetText())
	if isnull(ls_baldat) or ls_baldat = '' then return
	
	if f_datechk(ls_baldat) = -1 then
		messagebox('확인','날짜 지정 오류!!!')
		SetFocus()
		return 1
	end if

End if
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::buttonclicked;call super::buttonclicked;String ls_sv_path, ls_sv_file, ls_path, ls_file, ls_inspt_dt, ls_new
Long   ll_v, ll_ques
integer li_FileNum

AcceptText()

/* 파일서버 경로 가져오기 */
select dataname into :ls_sv_path from syscnfg
 where sysgu = 'C' and serial = 12 and lineno = '1' ;


Choose Case dwo.name
	Case 'b_2'
		ls_sv_file = Trim(Object.filename[row])
		If ls_sv_file = '' Or isNull(ls_sv_file) Then
			ls_new = 'Y'
		End If		
		
	   If FileExists(ls_sv_file) Then
			ls_new = 'N'
		Else
			ls_new = 'Y'
		End If


		If ls_new = 'N' then
			ll_ques = MessageBox('확인', '등록된 파일을 열 경우 <예> 를 선택하고' + &
								'~n삭제하고 새로 등록할려면 <아니오> 를 선택하십시오.', Question!, YesNoCancel!, 1)
			if ll_ques = 3 then return
			if ll_ques = 2 then ls_new = 'Y'
		End If
		
		If ls_new = 'Y' then
			ll_v = GetFileOpenName("Upload File 선택", ls_path, ls_file ,"OFFICE","PowerPoint (*.PPT),*.PPT,Excel Files (*.XLS),*.XLS,모든 파일 (*.*),*.*")				
			If ll_v = 1 And FileExists(ls_path) Then
				ls_sv_file = ls_sv_path + ls_file
				if FileExists(ls_sv_file) Then
					messagebox('확인','동일한 파일명이 존재합니다.~n파일명을 바꾸세요.')
					return
				end if		
				SetPointer(Hourglass!)
				li_FileNum = FileCopy(ls_path, ls_sv_file, true)
				If li_FileNum <> 1 Then
					MessageBox('확인','File UpLoad Failed')
					Return
				End If
//				If CopyFileA(ls_path, ls_sv_file, true) = False Then
//					MessageBox('확인','File UpLoad Failed')
//					Return
//				End If
	
				Object.filename[row] = ls_sv_file
				Object.submit_file[row] = ls_file
				Object.submit_dt[row] = f_today()
				
				p_mod.PostEvent('clicked')
			Else
				return
			End If
		Else
			SetPointer(Hourglass!)
			ShellExecuteA(0, "open", ls_sv_file, "", "", 1) // 파일 자동 실행 
		End If

End Choose


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

type p_delrow from w_inherite`p_delrow within w_qa02_00017_han
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00017_han
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa02_00017_han
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa02_00017_han
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qa02_00017_han
integer x = 4425
end type

type p_can from w_inherite`p_can within w_qa02_00017_han
integer x = 4251
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_qa02_00017_han
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

type p_inq from w_inherite`p_inq within w_qa02_00017_han
integer x = 3904
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

//If sgubun = '1' Then
//	sstatus = 'Y'
//ElseIf sgubun = '2' Then
//	sstatus = 'N'
//ElseIf sgubun = '3' Then
//	sstatus = 'A'
//Else
//	sstatus = '전체'
//End If

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
   f_message_chk(50, '[개선대책등록]')
End If

dw_insert.Setredraw(True)
end event

type p_del from w_inherite`p_del within w_qa02_00017_han
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_qa02_00017_han
integer x = 4078
end type

event p_mod::clicked;call super::clicked;If dw_insert.AcceptText() < 1 Then Return
If dw_insert.RowCount() < 1 Then Return

If f_msg_update() < 1 Then Return

setpointer(hourglass!)
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("저장실패", "품질 개선 요구서 저장 실패!!!")
	return
end if

commit ;

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qa02_00017_han
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00017_han
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qa02_00017_han
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qa02_00017_han
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qa02_00017_han
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qa02_00017_han
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qa02_00017_han
end type

type cb_can from w_inherite`cb_can within w_qa02_00017_han
end type

type cb_search from w_inherite`cb_search within w_qa02_00017_han
end type







type gb_button1 from w_inherite`gb_button1 within w_qa02_00017_han
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00017_han
end type

type dw_1 from datawindow within w_qa02_00017_han
integer x = 14
integer y = 24
integer width = 3561
integer height = 172
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qa02_00017_han_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string snull, sdata , sname, scode
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


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',sname)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
END IF
end event

event itemerror;return 1
end event

event constructor;//this.settransobject(sqlca)
end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

type rb_1 from radiobutton within w_qa02_00017_han
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

type rb_2 from radiobutton within w_qa02_00017_han
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

type rb_3 from radiobutton within w_qa02_00017_han
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

type rb_4 from radiobutton within w_qa02_00017_han
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

type rr_1 from roundrectangle within w_qa02_00017_han
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

