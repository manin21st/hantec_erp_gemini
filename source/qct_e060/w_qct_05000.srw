$PBExportHeader$w_qct_05000.srw
$PBExportComments$계측기 등록
forward
global type w_qct_05000 from w_inherite
end type
type dw_key from u_key_enter within w_qct_05000
end type
type dw_std from u_key_enter within w_qct_05000
end type
type cb_stdadd from commandbutton within w_qct_05000
end type
type cb_stddel from commandbutton within w_qct_05000
end type
type rr_1 from roundrectangle within w_qct_05000
end type
end forward

global type w_qct_05000 from w_inherite
string title = "계측기 교정 등록"
event ue_open pbm_custom01
dw_key dw_key
dw_std dw_std
cb_stdadd cb_stdadd
cb_stddel cb_stddel
rr_1 rr_1
end type
global w_qct_05000 w_qct_05000

type variables
string is_mchno

end variables

forward prototypes
public subroutine wf_init ()
public function integer wf_required_chk ()
end prototypes

public subroutine wf_init ();
end subroutine

public function integer wf_required_chk ();//필수입력항목 체크
if IsNull(Trim(dw_insert.object.silgu[1])) or Trim(dw_insert.object.silgu[1]) = "" then
	f_message_chk(30, "[실시구분]")
	dw_insert.setcolumn('silgu')
	dw_insert.setFocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.yongdo[1])) or Trim(dw_insert.object.yongdo[1]) = "" then
	f_message_chk(30, "[용도]")
	dw_insert.setcolumn('yongdo')
	dw_insert.setFocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.gigbn[1])) or Trim(dw_insert.object.gigbn[1]) = "" then
	f_message_chk(30, "[기기종류]")
	dw_insert.setcolumn('gigbn')
	dw_insert.setFocus()
	return -1
end if	
if IsNull(dw_insert.object.giilsu[1]) or dw_insert.object.giilsu[1] <= 0 then
	f_message_chk(30, "[주기개월수]")
	dw_insert.setcolumn('giilsu')
	dw_insert.setFocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.gikwan[1])) or Trim(dw_insert.object.gikwan[1]) = "" then
	f_message_chk(30, "[교정기관]")
	dw_insert.setcolumn('gikwan')
	dw_insert.setFocus()
	return -1
end if	
if f_datechk(dw_insert.object.lasdat[1]) = -1 or &
   IsNull(Trim(dw_insert.object.lasdat[1])) or &
   Trim(dw_insert.object.lasdat[1]) = "" then
	f_message_chk(30, "[최종교정일자]")
	dw_insert.setcolumn('lasdat')
	dw_insert.setFocus()
	return -1
end if	
if f_datechk(dw_insert.object.yudat[1]) = -1 or &
   IsNull(Trim(dw_insert.object.yudat[1])) or & 
	Trim(dw_insert.object.yudat[1]) = "" then
	dw_insert.setcolumn('yudat')
	dw_insert.setFocus()
	f_message_chk(30, "[유효일자]")
	return -1
end if	

return 1
end function

on w_qct_05000.create
int iCurrent
call super::create
this.dw_key=create dw_key
this.dw_std=create dw_std
this.cb_stdadd=create cb_stdadd
this.cb_stddel=create cb_stddel
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_key
this.Control[iCurrent+2]=this.dw_std
this.Control[iCurrent+3]=this.cb_stdadd
this.Control[iCurrent+4]=this.cb_stddel
this.Control[iCurrent+5]=this.rr_1
end on

on w_qct_05000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_key)
destroy(this.dw_std)
destroy(this.cb_stdadd)
destroy(this.cb_stddel)
destroy(this.rr_1)
end on

event open;call super::open;dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_std.SetTransObject(sqlca)
dw_std.ReSet()

dw_insert.SetRedraw(False)
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_key.SetRedraw(False)
dw_key.InsertRow(0)
dw_key.SetRedraw(True)
dw_key.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_qct_05000
integer x = 73
integer y = 240
integer width = 4517
integer height = 488
integer taborder = 20
string dataobject = "d_qct_05000"
boolean border = false
end type

event dw_insert::itemchanged;string s_cod, sTmpName, s_nam1, s_nam2
int    ireturn

s_cod = Trim(GetText())

if GetColumnName() = "giilsu'" then
	if Long(s_cod) < 0 Then
		f_message_chk(106,'')
		Return 1
	End If
elseif GetColumnName() = "yudat" then
	if IsNull(s_cod) or s_cod = "" then return
	If f_datechk(s_cod) = -1 Then
		f_message_chk(35,"유효일자")
		object.yudat[1] = ""
      SetColumn("yudat")
	   Return 1
   END IF
//elseif this.getcolumnname() = "gikwan" then
//	ireturn  = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
//	this.object.gikwan[1] = s_cod
//	this.object.cvnas2[1] = s_nam1
//	return ireturn 
//ElseIf GetColumnName() = "tempno" then
//	If IsNull(s_cod) or s_cod = "" Then 
//		SetItem(1,"tmpname", '')
//		Return
//	End If
//	
//	SELECT "MESKWA_TEMPLETE"."TMPNAME"  	INTO :sTmpName
//	  FROM "MESKWA_TEMPLETE"  
//	 WHERE ( "MESKWA_TEMPLETE"."SABU" = :gs_sabu ) AND ( "MESKWA_TEMPLETE"."TMPNO" = :s_cod )   ;
//		
//	IF SQLCA.SQLCODE <> 0 THEN
//		TriggerEvent(RButtonDown!)
//		Return 2
//	ELSE
//		SetItem(1,"tmpname", sTmpName)
//	END IF
End If
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::buttonclicked;call super::buttonclicked;string pathname

if dwo.name <> "btn1" then return

this.AcceptText()
pathname = Trim(this.object.imgpath[1])
//if IsNull(pathname) or Trim(pathname) = "" then
//	value = GetFileOpenName("열기", pathname, filename, "BMP", "Image Files (*.BMP),*.BMP")
//   if value = 0 THEN return
//   if value <> 1 then
//	   MessageBox("열기 윈도우 실패","전산실로 문의 하세요!")
//      return
//   end if
//end if	
//이미지 등록 윈도우 Call
OpenWithParm(w_pdt_06010, pathname)
pathname = Message.StringParm
if not (IsNull(pathname) or pathname = "") then
   dw_insert.object.imgpath[1] = Trim(pathname)
end if	

end event

event dw_insert::rbuttondown;//
//SetNull(Gs_Gubun)
//SetNull(Gs_Code)
//SetNull(Gs_CodeName)
//
//Choose Case this.GetColumnName() 
//	/* 템플릿 */
//	Case "tempno"
//		Open(w_qct_05020_popup)
//		If IsNull(gs_code) Or gs_code = '' Then Return
//
//		SetItem(1, 'tempno',  gs_code)
//		SetItem(1, 'tmpname', gs_codename)
////	Case "gikwan"
////		open(w_vndmst_popup)
////		If IsNull(gs_code) Or gs_code = '' Then Return
////		
////		this.object.gikwan[1] = gs_code
////		this.object.cvnas2[1] = gs_codename
//END Choose
//
end event

type p_delrow from w_inherite`p_delrow within w_qct_05000
integer x = 3703
integer taborder = 50
end type

event p_delrow::clicked;call super::clicked;string s_mchno
long   nRow,l_seq

nRow  = dw_std.GetRow()
If nRow <=0 Then Return

IF MessageBox("삭 제","현재 Row의 자료가 삭제됩니다." +"~n~n" +&
                   	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

if IsNUll(Trim(dw_std.object.sabu[nRow])) or Trim(dw_std.object.sabu[nRow]) = "" then
	dw_std.DeleteRow(nRow)
	w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'
	return
else
	dw_std.DeleteRow(nRow)
   IF dw_std.Update() <> 1 THEN
      ROLLBACK;
	   w_mdi_frame.sle_msg.text ='삭제작업 실패!!'
      Return
   END IF
end if

COMMIT;

w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'


end event

type p_addrow from w_inherite`p_addrow within w_qct_05000
integer x = 3529
integer taborder = 40
end type

event p_addrow::clicked;call super::clicked;Long crow

crow = dw_std.InsertRow(0)
dw_std.ScrollToRow(crow)
dw_std.SetRow(crow)
dw_std.SetColumn("stdno")
dw_std.SetFocus()

end event

type p_search from w_inherite`p_search within w_qct_05000
boolean visible = false
integer x = 3776
integer y = 3240
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_05000
boolean visible = false
integer x = 4297
integer y = 3240
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_05000
integer x = 4398
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_qct_05000
integer x = 4224
integer taborder = 80
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_key.object.mchno[1] = ""
dw_key.object.mchnam[1] = ""
dw_key.object.spec[1] = ""

dw_insert.SetReDraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetReDraw(True)

dw_key.SetFocus()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No
end event

type p_print from w_inherite`p_print within w_qct_05000
boolean visible = false
integer x = 3950
integer y = 3240
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_05000
boolean visible = false
integer x = 4142
integer y = 3088
integer taborder = 0
boolean enabled = false
string picturename = "C:\erpman\image\조회_d.gif"
end type

event p_inq::clicked;call super::clicked;String s_cod, s_gbn, s_stopdat

w_mdi_frame.sle_msg.Text = ""
if dw_key.AcceptText() = -1 then return

s_cod = dw_key.object.mchno[1]
if IsNull(s_cod) or s_cod = "" then 
	f_message_chk(30,"[관리번호]")
	dw_key.SetFocus()
	Return 
end if

select stopdat, kegbn into :s_stopdat, :s_gbn
  from mchmst
 where sabu = :gs_sabu and mchno = :s_cod;  
 
//사용중지일자 확인
if sqlca.sqlcode <> 0 or (not (IsNull(s_stopdat) or s_stopdat = "")) then
	MessageBox("설비마스터 확인", "설비마스터에 등록되지 않은 코드 이거나 ~n~n" + String(s_stopdat,"@@@@.@@.@@") + " 일자로 사용 중지된 설비 입니다!")
	dw_key.object.mchno[1] = ""
   dw_key.object.mchnam[1] = ""
	dw_key.object.spec[1] = ""
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
	return
end if	

if sqlca.sqlcode <> 0 then s_gbn = "X"

dw_insert.setredraw(false)
if dw_insert.Retrieve(gs_sabu, s_cod) < 1 then //계측기마스터에 등록되어 있지 않을 때
	dw_insert.Setredraw(False)
	dw_insert.ReSet()
	dw_insert.insertrow(0)
	dw_insert.Setredraw(true)
	if s_gbn = "Y" then //교정
		p_mod.Enabled = True
		p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
		
		dw_insert.Enabled = True
		dw_insert.object.sabu[1] = gs_sabu
	   dw_insert.object.mchno[1] = s_cod
		w_mdi_frame.sle_msg.Text = "신규로 등록하세요!"
	   dw_insert.SetFocus()
	else                //비교정 또는 설비마스터에 존재하지 않을 때
		messagebox("설비마스터 확인", "설비마스터에 등록되지 않은 자료~n~n" + &
		                              "또는 검교정 구분이 '비교정'인 자료 입니다!~n~n" + &
	                                 "다른 관리번호를 선택하세요!")
	end if	
else //계측기마스터에 등록되어 있을 때
	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\삭제_up.gif'
	if s_gbn = "Y" then //교정
      dw_std.ReTrieve(gs_sabu, s_cod)
		
		p_addrow.Enabled = True
		p_addrow.PictureName = 'c:\erpman\image\행추가_up.gif'
      
		p_delrow.Enabled = True
		p_delrow.PictureName = 'c:\erpman\image\행삭제_up.gif'
		
      p_mod.Enabled = True
		p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
		
		dw_insert.Enabled = True
		dw_insert.SetFocus()
   else
	   p_del.SetFocus()	
		messagebox("설비마스터 확인", "설비마스터에 등록되지 않은 자료~n~n" + &
		                              "또는 검교정 구분이 '비교정'인 자료 입니다!~n~n" + &
	                                 "삭제작업을 진행하세요!")
   end if
end if
dw_insert.setredraw(true)

return
end event

type p_del from w_inherite`p_del within w_qct_05000
integer x = 4050
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;Long crow

if f_msg_delete() = -1 then return

crow = dw_insert.GetRow()
dw_insert.DeleteRow(crow)
if dw_insert.Update() = 1 Then
	for crow = dw_std.RowCount() to 1 step -1
	    dw_std.DeleteRow(crow)
	next
	
   if dw_std.Update() <> 1 Then
      Rollback ;
	   MessageBox("삭제 실패", "교정용 표준기기 삭제작업 실패!")
	end if
	
   commit;
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
   ib_any_typing = False //입력필드 변경여부 No
Else
   Rollback ;
	MessageBox("삭제 실패", "삭제작업 실패!")
End If		

p_mod.Enabled = False
p_mod.PictureName = 'c:\erpman\image\저장_d.gif'

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

p_addrow.Enabled = False
p_addrow.PictureName = 'c:\erpman\image\행추가_d.gif'

p_delrow.Enabled = False
p_delrow.PictureName = 'c:\erpman\image\행삭제_d.gif'

dw_insert.SetReDraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetReDraw(True)

dw_key.SetReDraw(False)
dw_key.object.mchno[1] = ""
dw_key.object.mchnam[1] = ""
dw_key.object.spec[1] = ""
dw_key.SetReDraw(True)
dw_key.SetColumn("mchno")
dw_key.SetFocus()




end event

type p_mod from w_inherite`p_mod within w_qct_05000
integer x = 3877
integer taborder = 60
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;String mchno, lasdat, yudat
Long   i

if dw_insert.AcceptText() = -1 then
	dw_insert.SetFocus()
	return
end if	

if wf_required_chk() = -1 Then Return

if f_msg_update() = -1 then return

mchno = dw_insert.object.mchno[1]
lasdat = dw_insert.object.lasdat[1]
yudat = dw_insert.object.yudat[1]

If dw_insert.Update() = 1 then
	//최종교정일자와 유효일자 mesresult table에 셋팅
	insert into mesresult
	(mchno, ymd, remk1, remk2, empno, yudat)
	values (:mchno, :lasdat, '', '', '', :yudat);
	if sqlca.sqlcode <> 0 then
		update mesresult
		   set yudat = :yudat
		 where mchno = :mchno and ymd = :lasdat;
		if sqlca.sqlcode <> 0 then
         MessageBox("저장 실패","자료저장에 실패 하였습니다!")
			rollback;
			w_mdi_frame.sle_msg.text =	"저장작업 실패!"			
			return
		end if	
	end if
	
	for i = dw_std.RowCount() to 1 step -1
		if IsNull(Trim(dw_std.object.stdno[i])) or Trim(dw_std.object.stdno[i]) = "" then
			dw_std.DeleteRow(i)
		   continue
		end if
		dw_std.object.sabu[i] = gs_sabu
		dw_std.object.mchno[i] = dw_key.object.mchno[1]
	next
	
	If dw_std.Update() <> 1 then
		MessageBox("저장 실패","교정용 표준기기 자료저장에 실패 하였습니다!")
		rollback;
		w_mdi_frame.sle_msg.text =	"저장작업 실패!"			
		return
	end if	
	
	commit;
	w_mdi_frame.sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	dw_key.SetColumn("mchno")
	dw_key.SetFocus()
else
	rollback;
	w_mdi_frame.sle_msg.text =	"저장작업 실패!"			
end if

return 

end event

type cb_exit from w_inherite`cb_exit within w_qct_05000
integer x = 3026
integer y = 3280
end type

type cb_mod from w_inherite`cb_mod within w_qct_05000
integer x = 1970
integer y = 3280
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_05000
integer x = 46
integer y = 3128
string text = "추가(&I)"
end type

event cb_ins::clicked;call super::clicked;//int  row,nMax,ix,itemp
//
//If IsNull(is_year) Or IsNull(is_gu) Then
//   f_message_chk(1400,'')
//	dw_key.SetFocus()
//	dw_key.SetColumn('base_year')
//	Return -1
//End If
//
//// 최대 rank 구함
//nMax = 0
//For ix = 1 To dw_insert.RowCount()
//    itemp = dw_insert.GetItemNumber(ix,'bungi_rank')
//    nMax = Max(nMax,itemp)
//Next
//nMax += 1
//
//row = dw_insert.InsertRow(0)
//dw_insert.SetItem(row,'sabu',gs_saupj)
//dw_insert.SetItem(row,'base_year',is_year)
//dw_insert.SetItem(row,'sisang_gu',is_gu)
//dw_insert.SetItem(row,'bungi_rank',nMax)
//dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
//dw_insert.SetItemStatus(row, 0,Primary!, New!)
//dw_insert.SetFocus()
//dw_insert.SetRow(row)
//dw_insert.SetColumn('bungi_rank')
//
end event

type cb_del from w_inherite`cb_del within w_qct_05000
integer x = 2322
integer y = 3280
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_05000
integer x = 3785
integer y = 3112
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_qct_05000
integer x = 731
integer y = 3108
end type

type st_1 from w_inherite`st_1 within w_qct_05000
end type

type cb_can from w_inherite`cb_can within w_qct_05000
integer x = 2674
integer y = 3280
end type

type cb_search from w_inherite`cb_search within w_qct_05000
integer x = 1454
integer y = 3108
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_05000
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05000
end type

type dw_key from u_key_enter within w_qct_05000
event ue_key pbm_dwnkey
integer x = 64
integer y = 20
integer width = 3090
integer height = 216
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_05000_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	this.TriggerEvent(RbuttonDown!)
END IF

end event

event itemchanged;String s_cod, s_nam1, s_nam2, sGrpCod, sBuncd, sNull
Integer i_rtn

if this.GetColumnName() <> "mchno" Then Return 1

s_cod = Trim(This.GetText())
if IsNull(s_cod) or s_cod = "" then Return 

SetNull(sNull)

select mchnam, spec ,GrpCod, Buncd
  into :s_nam1, :s_nam2, :sGrpCod, :sBuncd
  from mchmst
 where sabu = :gs_sabu and mchno = :s_cod;
 
if sqlca.sqlcode <> 0 then //설비마스터에 존재하지 않을 때
	this.object.mchnam[1] = sNull
	this.object.spec[1] = sNull
	SetItem(1, 'grpcod', sNull)
	SetItem(1, 'buncd',  sNull)
else
	this.object.mchnam[1] = s_nam1
	this.object.spec[1] = s_nam2
	SetItem(1, 'grpcod', sGrpcod)
	SetItem(1, 'buncd',  sBuncd)
end if

p_inq.TriggerEvent(Clicked!)

return
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "mchno" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
   open(w_mchno_popup)
	If IsNull(gs_code) Or Trim(gs_code) = '' Then Return 2
	
   SetItem(1, 'mchno', gs_code)
	TriggerEvent(ItemChanged!)
	Return 1
end if	

end event

event getfocus;call super::getfocus;dw_insert.Setredraw(False)
dw_insert.reset()
dw_insert.InsertRow(0)
dw_insert.Setredraw(True)

dw_key.Setredraw(False)
dw_key.reset()
dw_key.InsertRow(0)
dw_key.Setredraw(True)

dw_std.Setredraw(False)
dw_std.ReSet()
dw_std.Setredraw(True)

p_mod.Enabled = False
p_mod.PictureName = 'c:\erpman\image\저장_d.gif'

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

p_addrow.Enabled = False
p_addrow.PictureName = 'c:\erpman\image\행추가_d.gif'

p_delrow.Enabled = False
p_delrow.PictureName = 'c:\erpman\image\행삭제_d.gif'

dw_insert.Enabled = False




end event

type dw_std from u_key_enter within w_qct_05000
integer x = 96
integer y = 744
integer width = 4453
integer height = 1532
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_05000_02"
boolean border = false
end type

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;Long crow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

crow = this.GetRow()
if this.getcolumnname() = "stdno" then 
	gs_gubun ='ALL'
	gs_code = '계측기'
   open(w_mchno_popup)
   this.object.stdno[crow] = gs_code
   this.TriggerEvent(itemchanged!)
	return
end if	
end event

event itemchanged;call super::itemchanged;String s_cod, mchnam, jenam, mdlnm 
Long   crow, cnt

if this.GetColumnName() <> "stdno" Then Return 1

s_cod = Trim(This.GetText())
crow = this.GetRow()

if IsNull(s_cod) or s_cod = "" then 
   this.object.mchnam[crow] = ""
   this.object.jenam[crow] = ""
   this.object.mdlnm[crow] = ""
	return 
end if

select count(*) into :cnt from mesmst
 where sabu = :gs_sabu and mchno = :s_cod;
 
if sqlca.sqlcode <> 0 or cnt < 1 then //계측기마스터에 존재하지 않을 때
   MessageBox("계측기마스터 확인", "계측기마스터에 등록되지 않은 코드 입니다!")
	this.object.mchno[crow] = ""
   this.object.mchnam[crow] = ""
   this.object.jenam[crow] = ""
   this.object.mdlnm[crow] = ""
	return 1
end if

select mchnam, jenam, mdlnm 
  into :mchnam, :jenam, :mdlnm
  from mchmst
 where sabu = :gs_sabu and mchno = :s_cod;

if sqlca.sqlcode <> 0 then //설비마스터에 존재하지 않을 때
   MessageBox("설비마스터 확인", "설비마스터에 등록되지 않은 코드 입니다!")
	this.object.mchno[crow] = ""
	this.object.mchnam[crow] = ""
   this.object.jenam[crow] = ""
   this.object.mdlnm[crow] = ""
   return 1
end if

this.object.mchnam[crow] = mchnam
this.object.jenam[crow] = jenam
this.object.mdlnm[crow] = mdlnm

return
end event

type cb_stdadd from commandbutton within w_qct_05000
boolean visible = false
integer x = 1298
integer y = 3280
integer width = 320
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가"
end type

type cb_stddel from commandbutton within w_qct_05000
boolean visible = false
integer x = 1637
integer y = 3280
integer width = 320
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제"
end type

type rr_1 from roundrectangle within w_qct_05000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 732
integer width = 4489
integer height = 1552
integer cornerheight = 40
integer cornerwidth = 55
end type

