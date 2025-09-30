$PBExportHeader$w_qct_05020.srw
$PBExportComments$교정 실적 등록
forward
global type w_qct_05020 from w_inherite
end type
type dw_key from datawindow within w_qct_05020
end type
type dw_list from datawindow within w_qct_05020
end type
type dw_1 from u_key_enter within w_qct_05020
end type
type cb_new from commandbutton within w_qct_05020
end type
type dw_history from datawindow within w_qct_05020
end type
type dw_2 from datawindow within w_qct_05020
end type
type rr_1 from roundrectangle within w_qct_05020
end type
type rr_2 from roundrectangle within w_qct_05020
end type
type rr_4 from roundrectangle within w_qct_05020
end type
type wst_mstkwa from structure within w_qct_05020
end type
end forward

type wst_mstkwa from structure
	string		ginug
	decimal {4}	bumwi
	decimal {4}	strat
end type

global type w_qct_05020 from w_inherite
integer width = 4686
integer height = 3372
string title = "교정 실적 등록"
dw_key dw_key
dw_list dw_list
dw_1 dw_1
cb_new cb_new
dw_history dw_history
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
rr_4 rr_4
end type
global w_qct_05020 w_qct_05020

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
string is_pino
string is_path, is_file
end variables

forward prototypes
public function integer wf_copy_row (integer row)
public subroutine wf_btn_enabled (boolean fg)
end prototypes

public function integer wf_copy_row (integer row);String s_mchno
Long   nRow, nMax, ix, itemp, rowcnt, l_seq

If dw_key.AcceptText() = -1 Then Return 1

// 최대 costseq 구함
nMax = 0
rowcnt = dw_insert.RowCount()
For ix = 1 To rowcnt
    itemp = dw_insert.GetItemNumber(ix,'chseq')
    nMax = Max(nMax, itemp)
Next
nMax += 1

If dw_insert.RowsCopy(row, row, Primary!, dw_insert, row, Primary!) <> 1 Then Return -1

nRow = row + 1 //dw_insert.Rowcount()
dw_insert.SetItem(nRow,'chseq',nMax)
dw_insert.SetItem(nRow,'chrat',0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(nRow)
dw_insert.SetRow(nRow)
dw_insert.SetColumn('chrat')

return 1
end function

public subroutine wf_btn_enabled (boolean fg);p_del.Enabled = fg
p_mod.Enabled = fg
//cb_ins.Enabled = fg
p_delrow.Enabled = fg

if fg = False then
	p_mod.PictureName = 'c:\erpman\image\저장_d.gif'	
	p_delrow.PictureName = 'c:\erpman\image\행삭제_d.gif'	
	p_del.PictureName = 'c:\erpman\image\삭제_d.gif'	
else
	p_mod.PictureName = 'c:\erpman\image\저장_up.gif'	
	p_delrow.PictureName = 'c:\erpman\image\행삭제_up.gif'	
	p_del.PictureName = 'c:\erpman\image\삭제_up.gif'	
end if
end subroutine

on w_qct_05020.create
int iCurrent
call super::create
this.dw_key=create dw_key
this.dw_list=create dw_list
this.dw_1=create dw_1
this.cb_new=create cb_new
this.dw_history=create dw_history
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_key
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.dw_history
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.rr_4
end on

on w_qct_05020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_key)
destroy(this.dw_list)
destroy(this.dw_1)
destroy(this.cb_new)
destroy(this.dw_history)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_key.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_history.SetTransObject(sqlca)

dw_key.SetRedraw(False)
dw_key.ReSet()
dw_key.InsertRow(0)
dw_key.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)
dw_1.SetFocus()



end event

type dw_insert from w_inherite`dw_insert within w_qct_05020
boolean visible = false
integer x = 1637
integer y = 28
integer width = 2002
integer height = 388
integer taborder = 0
string dataobject = "d_qct_05020_d"
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_qct_05020
boolean visible = false
integer x = 2574
integer y = 16
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\행삭제_d.gif"
end type

event p_delrow::clicked;call super::clicked;string s_mchno
long   nRow

nRow  = dw_insert.GetRow()
If nRow <=0 Then Return

IF MessageBox("삭 제","현재 Row의 자료가 삭제됩니다." +"~n~n" +&
                   	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_insert.DeleteRow(nRow) = 1 Then
  IF dw_insert.Update() <> 1 THEN
     ROLLBACK;
     Return
  END IF
End If

COMMIT;

w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'
dw_insert.TriggerEvent(itemchanged!)

end event

type p_addrow from w_inherite`p_addrow within w_qct_05020
integer x = 3525
integer y = 8
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\행추가_d.gif"
end type

event p_addrow::clicked;call super::clicked;Long crow

if MessageBox("신규등록","계획없이 신규로 등록 합니다!~n~n" + & 
                     "신규순번으로 등록 하시겠습니까?",Question!, YesNo!, 2) = 2 then return
crow = dw_list.GetRow()

p_mod.Enabled = True
p_mod.PictureName = 'c:\erpman\image\저장_up.gif'

p_delrow.Enabled = True
p_delrow.PictureName = 'c:\erpman\image\행삭제_up.gif'

dw_history.ReSet()
dw_history.InsertRow(0)

dw_key.SetRedraw(False)
dw_key.ReSet()
dw_key.InsertRow(0)
dw_key.object.sabu[1] = gs_sabu
dw_key.object.mchno[1] = dw_1.object.mchno[1]

if crow < 1 then
	dw_key.object.seq[1] = 1
else
	dw_key.object.seq[1] = dw_list.object.seq[1] + 1
end if	

if IsNull(Trim(dw_key.object.temp[1])) or Trim(dw_key.object.temp[1]) = "" then
	dw_key.object.temp[1] = "(26±2)℃"
end if
if IsNull(Trim(dw_key.object.humi[1])) or Trim(dw_key.object.humi[1]) = "" then
	dw_key.object.humi[1] = "70 % RH 이하"
end if
//if IsNull(Trim(dw_key.object.oksign[1])) or Trim(dw_key.object.oksign[1]) = "" then
//	dw_key.object.oksign[1] = "Y"
//end if

dw_key.SetRedraw(True)
dw_key.SetFocus()
end event

type p_search from w_inherite`p_search within w_qct_05020
integer x = 4238
integer y = 988
integer taborder = 0
string pointer = "c:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_search::clicked;call super::clicked;string s_mchno,ls_file, ls_path, ls_mchno, ls_filename
long   l_seq, ll_seq, ll_max
int    j, h, k 

If dw_insert.AcceptText() <> 1 Then Return

s_mchno = Trim(dw_1.GetItemString(1,'mchno'))
If IsNull(s_mchno) Or s_mchno = '' Then
   f_message_chk(1400,'[관리번호]')	
	f_setfocus_dw(dw_1, 1,'mchno')
	Return 1
End If

//자료없는 ROW삭제
for k = 1 to dw_2.rowcount()
	 ls_filename = dw_2.getitemstring(k,'filename') 		
	 if ls_filename = '' or isnull(ls_filename) then
		 dw_2.deleterow(k)
	 end if
next

//순번지정
select nvl(max(seq),0) + 1 into :ll_max
  from meskwa_dtl  
 where sabu   = :gs_sabu
   and mchno  = :s_mchno;		 
for j = 1 to dw_2.rowcount()
    ll_seq = dw_2.getitemnumber(j,'seq') 		 
	 if ( ll_seq = 0 or isnull(ll_seq)) then
		 dw_2.setitem(j,'seq',ll_max)
		 ll_max ++
	 end if	
next	

IF dw_2.Update() <> 1 THEN
   ROLLBACK;
	f_message_chk(32,'')	
   Return
ELSE
	COMMIT;
	integer 	li_FileNum, loops, i
	long 		flen, bytes_read, new_pos
	blob 		b, tot_b
	tot_b = Blob(Space(0))
	b     = Blob(Space(0))
		
	for h = 1 to  dw_2.rowcount()
		l_seq    = dw_2.getitemnumber(h,'seq') 	
		ls_mchno = dw_2.getitemstring(h,'mchno') 	
		/* 문서저장 */
		ls_file 		= upper(is_file)
		ls_path     = upper(is_path) 
		
		//////////////////////////////////////////
		// 선택한 FILE을 READ하여 DB에 UPDATE
		//////////////////////////////////////////
		
		
		flen = FileLength(ls_path)
		li_FileNum = FileOpen(ls_path, StreamMode!, Read!, LockRead!)

		if li_FileNum = -1 then	continue
			
		IF flen > 32765 THEN
			IF Mod(flen, 32765) = 0 THEN
				loops = flen/32765
			ELSE
				loops = (flen/32765) + 1
			END IF
		ELSE
			loops = 1
		END IF
		
		new_pos = 1
		
		FOR i = 1 to loops
			bytes_read = FileRead(li_FileNum, b)
			tot_b = tot_b + b
		NEXT
			
		FileClose(li_FileNum)	
		
		//Blob 저장
		UpdateBlob meskwa_dtl  
				 set mexcel = :tot_b
			  where sabu   = :gs_sabu
				 and mchno  = :ls_mchno 
				 and seq    = :l_seq;
				 
		If SQLCA.SQLCODE <> 0 Then
			messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
			ROLLBACK USING SQLCA	;
			Return
		End if				
										
		COMMIT USING SQLCA	;
		tot_b = Blob(Space(0))
  	   b     = Blob(Space(0))
	next	
END IF
w_mdi_frame.sle_msg.text =""
messagebox("확인","문서가 추가등록 되었습니다!")


end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_ins from w_inherite`p_ins within w_qct_05020
integer x = 4064
integer y = 988
integer taborder = 0
string pointer = "C:\erpman\cur\new.cur"
end type

event p_ins::clicked;call super::clicked;string s_cod
long   ll_row

if dw_1.accepttext() = -1 then return -1

s_cod =  dw_1.getitemstring(1, 'mchno')
If IsNull(s_cod) or s_cod = '' Then
   f_message_chk(1400,'[관리번호]')
   f_setfocus_dw(dw_1, 1,"mchno")
	Return 
End If

ll_row = dw_2.rowcount()
dw_2.insertrow(ll_row + 1)
dw_2.setitem(ll_row + 1, 'sabu', gs_sabu)
dw_2.setitem(ll_row + 1, 'mchno', dw_1.getitemstring(1, 'mchno'))

end event

type p_exit from w_inherite`p_exit within w_qct_05020
integer x = 4398
integer y = 8
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_qct_05020
integer x = 4224
integer y = 8
integer taborder = 80
end type

event p_can::clicked;call super::clicked;sle_msg.text =""

IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

p_inq.TriggerEvent(Clicked!)

ib_any_typing = False //입력필드 변경여부 No
end event

type p_print from w_inherite`p_print within w_qct_05020
integer x = 4411
integer y = 988
integer taborder = 0
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event p_print::clicked;call super::clicked;string ls_mchno
long   nRow, ll_seq

nRow  = dw_2.GetRow()
If nRow <=0 Then Return
	  
ls_mchno = Trim(dw_2.GetItemString(nRow,'mchno'))
ll_seq   = dw_2.GetItemNumber(nRow,'seq')

If IsNull(ls_mchno) Or ls_mchno = '' Then Return
If IsNull(ll_seq)  Then Return

IF MessageBox("삭 제","해당문서를 삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_2.DeleteRow(nRow) = 1 Then
   IF dw_2.Update() <> 1 THEN
      MessageBox("삭제실패","삭제 작업 실패(1)!")
		ROLLBACK;
      Return
   End If
 	COMMIT;
	w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'
	MessageBox("삭 제","삭제 작업 완료!")
end if

end event

type p_inq from w_inherite`p_inq within w_qct_05020
integer x = 3703
integer y = 8
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;string s_cod, s_stopdat

dw_history.ReSet()
dw_history.InsertRow(0)

dw_insert.Reset()

wf_btn_enabled(False) //Button Control
if dw_1.AcceptText() <> 1 then
	dw_1.SetFocus()
	return
end if	

s_cod = Trim(dw_1.object.mchno[1])
If IsNull(s_cod) or s_cod = '' Then
   f_message_chk(1400,'[관리번호]')
   f_setfocus_dw(dw_1, 1,"mchno")
	Return 
End If

//사용중지일자 확인
select stopdat into :s_stopdat from mchmst
 where sabu = :gs_sabu and mchno = :s_cod;
if sqlca.sqlcode <> 0 or (not (IsNull(s_stopdat) or s_stopdat = "")) then
	MessageBox("사용중지일자 확인", String(s_stopdat,"@@@@.@@.@@") + " 일자로 사용 중지된 설비 입니다!")
	dw_1.object.mchno[1] = ""
   dw_1.object.mchnm[1] = ""
	dw_1.SetColumn("mchno")
	dw_1.SetFocus()
	return
end if	

/* 검사성적서 */
dw_2.Retrieve(gs_sabu, s_cod) 

If dw_list.Retrieve(gs_sabu, s_cod) <= 0 Then
   w_mdi_frame.sle_msg.Text = '조회한 자료가 없습니다.!!'
	p_addrow.Enabled = True
	p_addrow.PictureName = 'c:\erpman\image\행추가_up.gif'
	return 
else	
	p_addrow.Enabled = True
	p_addrow.PictureName = 'c:\erpman\image\행추가_up.gif'
	return
End If
end event

type p_del from w_inherite`p_del within w_qct_05020
integer x = 4050
integer y = 8
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;string s_mchno, s_lasdat, s_yudat, pi_seq
long   nRow,l_seq

nRow  = dw_key.GetRow()
If nRow <=0 Then Return
	  
s_mchno = Trim(dw_key.GetItemString(nRow,'mchno'))
s_lasdat = Trim(dw_key.GetItemString(nRow,'sidat'))
l_seq   = dw_key.GetItemNumber(nRow,'seq')

If IsNull(s_mchno) Or s_mchno = '' Then Return
If IsNull(l_seq)  Then Return

IF MessageBox("삭 제","관리번호 " + s_mchno + '의 교정순번 ' + string(l_seq) + "의 모든 자료가 삭제됩니다." +"~n~n" +&
                    	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_key.DeleteRow(0) = 1 Then
	nRow = dw_insert.RowCount()
   dw_insert.RowsMove(1, nRow,  Primary!,dw_insert,1,Delete!)
   IF dw_key.Update() <> 1 THEN
      MessageBox("삭제실패","삭제 작업 실패(1)!")
		ROLLBACK;
      Return
   End If
   IF dw_insert.Update() <> 1 THEN
      MessageBox("삭제실패","삭제 작업 실패(2)!")
  	   ROLLBACK;
	   Return
   END IF		
	
	//최종교정일자와 유효일자 재셋팅작업
	dw_history.DeleteRow(0)
	IF dw_history.Update() <> 1 THEN
      MessageBox("삭제실패","삭제 작업 실패(3)!")
  	   ROLLBACK;
	   Return
   END IF		
  		
	select max(ymd) into :s_lasdat from mesresult
    where mchno = :s_mchno and not (yudat is null);
	
	if not (IsNull(s_lasdat) or s_lasdat = '') then 
      update mesmst
         set lasdat = :s_lasdat,
             yudat =  TO_CHAR(ADD_MONTHS(TO_DATE(:s_lasdat,'YYYYMMDD'), giilsu),'YYYYMMDD')
 	    where sabu = :gs_sabu and mchno = :s_mchno;
	  
      if sqlca.sqlcode <> 0 then 
		   MessageBox("최종교정일자 셋팅 작업 실패", "최종교정일자와 유효일자를 재셋팅 하지 못하였습니다!")
         ROLLBACK;
	      Return
      end if
	else	
		MessageBox("이전 최종교정일자 확인", "이전 최종교정일자를 확인하세요!(MESRESULT TABLE)")
      ROLLBACK;
      Return
	end if
	
	COMMIT;
	w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'
	dw_list.SetReDraw(False)
	dw_list.ReSet()
	dw_list.SetReDraw(True)
end if

end event

type p_mod from w_inherite`p_mod within w_qct_05020
integer x = 3877
integer y = 8
integer taborder = 60
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;string s_mchno, s_check, s_lasdat, s_yudat, s_lasdat1, s_yudat1, ls_file, ls_path
long   nRow, ix, l_seq, ll_seq, ll_max
int    j
dec    d_check

If dw_key.AcceptText() <> 1 Then Return
If dw_insert.AcceptText() <> 1 Then Return

nRow  = dw_key.GetRow()
If nRow <=0 Then Return
	  
s_mchno = Trim(dw_key.GetItemString(1,'mchno'))
If IsNull(s_mchno) Or s_mchno = '' Then
   f_message_chk(1400,'[관리번호]')
	f_setfocus_dw(dw_key,nRow,'mchno')
	Return 1
End If

l_seq = dw_key.GetItemNumber(1,'seq')
If IsNull(l_seq)  Then
   f_message_chk(1400,'[교정순번]')
	f_setfocus_dw(dw_key,nRow,'seq')
	Return 1
End If

s_check = Trim(dw_key.GetItemString(1,'sidat'))
If IsNull(s_check) Or s_check = '' or f_datechk(s_check) = -1 Then
   f_message_chk(1400,'[실시일자]')
	f_setfocus_dw(dw_key,nRow,'sidat')
	Return 1
End If

s_check = Trim(dw_key.GetItemString(1,'sigbn'))
If IsNull(s_check) Or s_check = '' Then
   f_message_chk(1400,'[실시구분]')
	f_setfocus_dw(dw_key,nRow,'sigbn')
	Return 1
End If

If s_check = '2' Then //사외이면
   s_check = Trim(dw_key.GetItemString(1,'sikwan'))
   If IsNull(s_check) Or s_check = '' Then
     f_message_chk(1400,'[실시기관]')
  	  f_setfocus_dw(dw_key,nRow,'sikwan')
     Return 1
  End If
End If  
//판정기준에 따라서 유효일자를 셋팅(불합격의 경우 '')
//if dw_key.object.oksign[1] = "Y" then
s_check = Trim(dw_key.GetItemString(1,'yudat'))
if IsNull(s_check) or s_check = '' or f_datechk(s_check) = -1 then
	f_message_chk(1400,'[유효일자]')
	f_setfocus_dw(dw_key,nRow,'sidat')
	return 1
end if
//else
//   dw_key.object.yudat[1] = ""	
//end if
//
//For ix =1 To dw_insert.RowCount()
//   s_check = Trim(dw_insert.GetItemString(1,'ginug'))
//   If IsNull(s_check) Or s_check = '' Then
//     f_message_chk(1400,'[측정기능]')
//	  f_setfocus_dw(dw_insert,ix,'ginug')
//     Return 1
//   End If
//
//   s_check = Trim(dw_insert.GetItemString(1,'bumwi'))
//   If IsNull(s_check) Or s_check = '' Then
//     f_message_chk(1400,'[범위]')
//	  f_setfocus_dw(dw_insert,ix,'bumwi')
//     Return 1
//   End If
//   d_check = dw_insert.GetItemNumber(1,'strat')
//   If IsNull(s_check) Or s_check = '' Then
//     f_message_chk(1400,'[표준치]')
//	  f_setfocus_dw(dw_insert,ix,'strat')
//     Return 1
//   End If
//   d_check = dw_insert.GetItemNumber(1,'chrat')
//   If IsNull(s_check) Or s_check = '' Then
//     f_message_chk(1400,'[측정치]')
//	  f_setfocus_dw(dw_insert,ix,'chrat')
//     Return 1
//   End If
//Next

IF dw_key.Update() <> 1 THEN
   ROLLBACK;
	f_message_chk(32,'')
   Return
END IF

//IF dw_insert.Update() <> 1 THEN
//   ROLLBACK;
//	f_message_chk(32,'')	
//   Return
//END IF
//
////순번지정
//select nvl(max(seq),0) + 1 into :ll_max
//  from meskwa_dtl  
// where sabu   = :gs_sabu
//   and mchno  = :s_mchno;		 
//for j = 1 to dw_2.rowcount()
//    ll_seq = dw_2.getitemnumber(j,'seq') 		 
//	 if ( ll_seq = 0 or isnull(ll_seq)) then
//		 dw_2.setitem(j,'seq',ll_max)
//		 ll_max ++
//	 end if	
//next	
//
//IF dw_2.Update() <> 1 THEN
//   ROLLBACK;
//	f_message_chk(32,'')	
//   Return
//ELSE
//	/* 문서저장 */
//	ls_file 		= upper(is_file)
//	ls_path     = upper(is_path) 
//	
//	//////////////////////////////////////////
//	// 선택한 FILE을 READ하여 DB에 UPDATE
//	//////////////////////////////////////////
//	integer 	li_FileNum, loops, i
//	long 		flen, bytes_read, new_pos
//	blob 		b, tot_b
//	
//	flen = FileLength(ls_path)
//	li_FileNum = FileOpen(ls_path, StreamMode!, Read!, LockRead!)
//		
//	IF flen > 32765 THEN
//		IF Mod(flen, 32765) = 0 THEN
//			loops = flen/32765
//		ELSE
//			loops = (flen/32765) + 1
//		END IF
//	ELSE
//		loops = 1
//	END IF
//	
//	new_pos = 1
//	
//	FOR i = 1 to loops
//		bytes_read = FileRead(li_FileNum, b)
//		tot_b = tot_b + b
//	NEXT
//		
//	FileClose(li_FileNum)	
//	
//	//Blob 저장
//	UpdateBlob meskwa_dtl  
//			 set mexcel = :tot_b
//		  where sabu   = :gs_sabu
//		    and mchno  = :s_mchno 
//			 and seq    = :l_seq;
//			 
//	If SQLCA.SQLCODE <> 0 Then
//		messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
//		ROLLBACK USING SQLCA	;
//		Return
//	End if				
//									
//	COMMIT USING SQLCA	;
//END IF
//
// 계측기마스터(mesmst)에 저장
s_lasdat = Trim(dw_key.GetItemString(1,'sidat'))
s_yudat = Trim(dw_key.GetItemString(1,'yudat'))
If IsNull(s_yudat) Then s_yudat = " "

//History에 저장 
dw_history.object.mchno[1] = s_mchno
dw_history.object.ymd[1] = s_lasdat
dw_history.object.remk1[1] = '교정'
if dw_key.object.oksign[1] = "Y" then
	dw_history.object.remk2[1] = 'QC합격'
else
   dw_history.object.remk2[1] = 'QC불합격'
end if	
dw_history.object.empno[1] = ' '
dw_history.object.yudat[1] = s_yudat

dw_history.AcceptText() 
IF dw_history.Update() <> 1 THEN
   ROLLBACK;
	f_message_chk(32,'')	
   Return
END IF

//최종교정일자와 유효일자는 현재 계측기 마스터에 저장된 내용과
//                          입력되는 내용 중에서 MAX값을 UPDATE 한다.
select lasdat, yudat into :s_lasdat1, :s_yudat1
  from mesmst
 where sabu = :gs_sabu and mchno = :s_mchno;

if s_lasdat1 > s_lasdat then s_lasdat = s_lasdat1
if s_yudat1 > s_yudat then s_yudat = s_yudat1

UPDATE "MESMST"  
	SET "LASDAT" = :s_lasdat,   
		 "YUDAT" = :s_yudat  
 WHERE ( "MESMST"."SABU" = :gs_sabu ) AND  
		 ( "MESMST"."MCHNO" = :s_mchno )   ;

If sqlca.sqlcode = 0 then
	w_mdi_frame.sle_msg.text ='자료를 저장하였습니다!!'
	ib_any_typing = False    
	COMMIT;
Else
	RollBack;
	f_message_chk(32,'')
	ib_any_typing = True
	return
End If

MessageBox("자료 저장", "자료를 저장하였습니다!")
return

end event

type cb_exit from w_inherite`cb_exit within w_qct_05020
integer x = 2459
integer y = 3584
end type

type cb_mod from w_inherite`cb_mod within w_qct_05020
integer x = 1381
integer y = 3592
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_05020
integer x = 914
integer y = 3312
integer width = 361
boolean enabled = false
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_qct_05020
integer x = 1733
integer y = 3592
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_05020
integer x = 590
integer y = 3592
end type

type cb_print from w_inherite`cb_print within w_qct_05020
integer x = 1326
integer y = 3324
integer width = 471
boolean enabled = false
string text = "불확도계산(&P)"
end type

event cb_print::clicked;call super::clicked;//int     rCnt,ix,group_cnt,ginug_cnt
//long    srow,erow
//dec {4} chrat,sum_chrat,avg_chrat,var_chrat
//dec {2} t_factor,ctl_ginug[]
//dec {4} ctl_chrat[],d_temp4
//dec {2} d_temp2
//
//string ginug,v_ginug[],bumwi
//
//If dw_key.AcceptText() <> 1 Then Return
//If dw_insert.AcceptText() <> 1 Then Return
//
//rCnt = dw_insert.RowCount()
//
//If rCnt <= 0 Then 
//	MessageBox("측정자료 확인","측정자료가 존재하지 않아요!")
//	cb_mod.Enabled = True
//	Return
//end if
//
//sle_msg.Text = '불확도 계산중...'
//
//// 불확도 계산을 위해 소트및 기능/범위로 group 화.
//dw_insert.SetSort('ginug A, bumwi A,strat a')      // 기능,범위,표준치 group
//dw_insert.Sort()
//dw_insert.GroupCalc()
//
//// 초기화
//srow  = dw_insert.FindGroupChange(0, 1)
//group_cnt = 1                   // 전체 group수
//v_ginug[group_cnt] = Trim(dw_insert.GetItemString(srow,'ginug'))
//
//DO WHILE NOT (False)
//   erow = dw_insert.FindGroupChange( srow + 1, 1)
//	IF erow > 0 THEN 
//      erow = erow - 1
//	Else
//		erow = dw_insert.RowCount()
//		If srow > erow Then Exit
//	End If
//
//   ginug = Trim(dw_insert.GetItemString(srow,'ginug'))
//	
//   // 표본평균
//   sum_chrat = 0
//	For ix = srow To erow
//     chrat = dw_insert.GetItemNumber(ix,'chrat')
//	  If IsNull(chrat) Then chrat = 0.0
//
//	  sum_chrat += chrat
//	Next
//	avg_chrat = sum_chrat / ( erow - srow + 1)
//	
//   // 추정표준편차
//   sum_chrat = 0
//   For ix = srow To erow
//     chrat = dw_insert.GetItemNumber(ix,'chrat')
//	  If IsNull(chrat) Then chrat = 0.0
//	  
//	  sum_chrat += (chrat - avg_chrat)^2
//	Next	
//	If sum_chrat > 0 Then
//   	var_chrat = sqrt(sum_chrat / ( erow - srow ))
//	Else
//		var_chrat = 0.0
//	End If
//	
//	// 우연불확도
//   rCnt = ( erow - srow + 1)
//	
//	SELECT "MESSIL"."SIL95"
//	  INTO :t_factor                           // t인자
//    FROM "MESSIL"  
//	 WHERE "MESSIL"."CNT" = :rcnt;
//	 
//   If IsNull(t_factor) or t_factor = 0 Then
//	   f_message_chk(120,'[95% 신뢰도 확인 : 측정 횟수는 2회 이상]')
//   	Return 	
//   End If
//
//   d_temp4 = var_chrat * ( t_factor / sqrt(erow - srow + 1))
//
//   // 기기에 대한 전체 불확도
//   If ginug = v_ginug[group_cnt] Then
//      ctl_chrat[group_cnt] += ( d_temp4^2 )
//	Else
//		ctl_chrat[group_cnt] = sqrt(ctl_chrat[group_cnt])  // 기기별 불확도
//		
//	   group_cnt += 1          // 그룹갯수 
//      v_ginug[group_cnt] = Trim(dw_insert.GetItemString(srow,'ginug'))		
//      ctl_chrat[group_cnt] += ( d_temp4^2 )
//		
//		v_ginug[group_cnt] = ginug
//   End If
//	
//	srow = erow + 1
//LOOP
//ctl_chrat[group_cnt] = sqrt(ctl_chrat[group_cnt])  // 기기별 불확도
//
////기기전체의 불확도 계산
//d_temp4 = 0.0
//For ix = 1 To group_cnt
//	d_temp4 += ctl_chrat[ix]^2
//Next
//
////------------------------//
//d_temp2 = sqrt(d_temp4)
////------------------------//
//
//dw_key.SetItem(dw_key.GetRow(),'bulrat',d_temp2)
//MessageBox("불확도 계산", "불확도 계산을 완료 하였습니다!")
//cb_mod.Enabled = True
//sle_msg.Text = ""
//
end event

type st_1 from w_inherite`st_1 within w_qct_05020
integer y = 3796
end type

type cb_can from w_inherite`cb_can within w_qct_05020
integer x = 2089
integer y = 3584
end type

type cb_search from w_inherite`cb_search within w_qct_05020
integer x = 951
integer y = 3592
integer width = 416
boolean enabled = false
string text = "전체삭제(&W)"
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_05020
integer y = 3796
end type

type sle_msg from w_inherite`sle_msg within w_qct_05020
integer y = 3796
end type

type gb_10 from w_inherite`gb_10 within w_qct_05020
integer y = 3744
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_05020
integer x = 1152
integer y = 3532
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05020
integer x = 1691
integer y = 3532
end type

type dw_key from datawindow within w_qct_05020
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1737
integer y = 160
integer width = 2871
integer height = 808
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_qct_05020_h"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string s_cod, s_mchno, s_seq, s_sidat, s_yudat, s_nam1, s_nam2
int    ireturn 

s_cod = Trim(this.GetText())
s_mchno = Trim(This.object.mchno[1])
s_seq = String(This.object.seq[1],"00000")

if this.GetColumnName() = "sigbn" then 
	if s_cod = "1" then //사내
	   this.object.calno[1] = s_mchno + "-" + s_seq
   end if
elseif this.GetColumnName() = "sidat" then // 실시일자 
   If f_datechk(s_cod) <> 1 Then
		f_message_chk(35,"실시일자")
     	this.setcolumn("sidat")
	   Return 1
   END IF
	
   //유효일자 = 실시일자 + mesmst.주기개월수
	select to_char(add_months(to_date(:s_cod,'yyyymmdd'),giilsu),'yyyymmdd')
	  into :s_yudat
     from mesmst
    where sabu = :gs_sabu and mchno = :s_mchno;

	if IsNull(s_yudat) then s_yudat = ''
	this.object.yudat[1] = s_yudat
elseif this.GetColumnName() = "rcvdat" then // 등록일자
   if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) <> 1 Then
		f_message_chk(35,"등록일자")
     	this.setcolumn("recdat")
	   Return 1
   end if
elseif this.GetColumnName() = "oksign" then // 판정기준
//	if s_cod = "Y" then //불합격
//      s_mchno = Trim(This.GetItemString(1,'mchno'))
//		s_sidat = Trim(This.GetItemString(1,'sidat'))
//      //유효일자 = 실시일자 + mesmst.주기개월수
//	   select to_char(add_months(to_date(:s_sidat,'yyyymmdd'),giilsu),'yyyymmdd')
//	     into :s_yudat
//        from mesmst
//       where sabu = :gs_sabu and mchno = :s_mchno;
//		 
//      if IsNull(s_yudat) then s_yudat = ''
//	   this.object.yudat[1] = s_yudat
//   else
//	   this.object.yudat[1] = ""
//   end if
//elseif this.getcolumnname() = "sikwan" then
//	ireturn  = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
//	this.object.sikwan[1] = s_cod
//	this.object.vndmst_cvnas2[1] = s_nam1
//	return ireturn 
end if


end event

event itemerror;return 1
end event

event editchanged;ib_any_typing =True
end event

event rbuttondown;//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//if this.getcolumnname() = "sikwan" then
//	open(w_vndmst_popup)
//	If IsNull(gs_code) Or gs_code = '' Then Return
//	this.object.sikwan[1] = gs_code
//	this.object.vndmst_cvnas2[1] = gs_codename
//end if
end event

type dw_list from datawindow within w_qct_05020
integer x = 123
integer y = 168
integer width = 1463
integer height = 2100
boolean bringtotop = true
string dataobject = "d_qct_05020_l"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;String mchno, sTmpNo
Long seq, crow, lBlobSize=0

SelectRow(0,false)
If row <=0 Then Return
SelectRow(row,true)

mchno  = this.object.mchno[row]
seq    = this.object.seq[row]

sTmpNo = dw_1.GetItemString(1,'tmpno')

if dw_key.Retrieve(gs_sabu, mchno, seq) <= 0 then
	f_message_chk(41,"[검교정 실적 자료 읽기]")
	dw_key.SetRedraw(False)
	dw_key.ReSet()
	dw_key.InsertRow(0)
	dw_key.SetRedraw(True)

	dw_history.ReSet()
	dw_history.InsertRow(0)
else
	if dw_key.object.sigbn[1] = '1' then
		dw_key.object.calno[1] = mchno + "-" + String(seq,"00000")
	end if	
	if IsNull(Trim(dw_key.object.temp[1])) or Trim(dw_key.object.temp[1]) = "" then
		dw_key.object.temp[1] = "(26±2)℃"
	end if
	if IsNull(Trim(dw_key.object.humi[1])) or Trim(dw_key.object.humi[1]) = "" then
		dw_key.object.humi[1] = "70 % RH 이하"
	end if
//	if IsNull(Trim(dw_key.object.oksign[1])) or Trim(dw_key.object.oksign[1]) = "" then
//		dw_key.object.oksign[1] = "Y"
//	end if
	
	wf_btn_enabled(True) //Button Control
	
	/* 검교정실적 자료 존재 확인 */
	If Not IsNull(sTmpNo) Then
		SELECT DBMS_LOB.GETLENGTH(MEXCEL) INTO :lBlobSize
		  FROM "MESKWA_DTL" 
		 WHERE "SABU" = :gs_sabu AND
				 "MCHNO" = :mchno AND
				 "SEQ" = :seq;
		If IsNull(lBlobSize) Or lBlobSize <= 0 Then		
			SQLCA.ERP000000540 ( gs_sabu, mchno, seq, sTmpNo)
			If sqlca.sqlcode <> 0 Then
				messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
				rollback;
				MessageBox('확 인','UPDATEBLOB')
				Return
			End If
		End If
	End If
	
	
	/* 검교정 실적 */
	If dw_insert.Retrieve(gs_sabu, mchno, seq) > 0 Then
	Else
	End If
	
	if dw_history.Retrieve(mchno, dw_key.object.sidat[1]) < 1 then
		dw_history.ReSet()
   	dw_history.InsertRow(0)
	end if	
	dw_key.SetFocus()
end if
end event

type dw_1 from u_key_enter within w_qct_05020
event ue_key pbm_dwnkey
integer x = 105
integer y = 24
integer width = 1481
integer height = 136
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_05020_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;String s_cod, s_nam1, s_nam2,sTempNo
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "mchno" then
	dw_list.SetReDraw(False)
	dw_list.ReSet()
	dw_list.SetReDraw(True)

	dw_key.SetReDraw(False)
	dw_key.ReSet()
	dw_key.InsertRow(0)
	dw_key.SetReDraw(True)
	
	dw_insert.SetReDraw(False)
	dw_insert.ReSet()
	dw_insert.SetReDraw(True)

	select a.mchno, b.mchnam, a.tempno
	  into :s_nam1, :s_nam2, :sTempNo
	  from mesmst a, mchmst b
	 where a.sabu = :gs_sabu
	   and a.mchno = :s_cod
		and b.sabu = a.sabu
		and b.mchno = a.mchno;
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,"[계측기마스터]")
		this.object.mchno[1] = ""
		this.object.mchnm[1] = ""
		this.object.tmpno[1] = ""
		return 1
	else
		this.object.mchno[1] = s_nam1
		this.object.mchnm[1] = s_nam2
		this.object.tmpno[1] = sTempNo
		p_inq.TriggerEvent(Clicked!)
		return
	end if	
end if

end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "mchno" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	open(w_mchno_popup)
	this.object.mchno[1] = gs_code
	this.object.mchnm[1] = gs_codename
   this.TriggerEvent(itemchanged!)
end if	
end event

type cb_new from commandbutton within w_qct_05020
boolean visible = false
integer x = 2807
integer y = 3584
integer width = 329
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "신규순번"
end type

type dw_history from datawindow within w_qct_05020
boolean visible = false
integer x = 1627
integer y = 2528
integer width = 841
integer height = 148
boolean bringtotop = true
string dataobject = "d_qct_05020_r"
boolean border = false
boolean livescroll = true
end type

type dw_2 from datawindow within w_qct_05020
integer x = 1787
integer y = 1156
integer width = 2793
integer height = 1084
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_qct_05020_e"
boolean border = false
boolean livescroll = true
end type

event clicked;string ls_path, ls_file_name, ls_Null, ls_mchno, ls_file
long   i, ll_seq, ll_new_pos, ll_flen, ll_bytes_read, ll_rc
int    li_fp, li_loops, li_complete, li_rc
blob   b_data, b_data2

SetNull(ls_Null)
if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)

SetPointer(HourGlass!)
ls_mchno     = this.getitemstring(row, 'mchno'  )
ls_file_name = this.getitemstring(row, 'filename'  )
ll_seq       = this.getitemnumber(row, 'seq' )


// 열기 버튼
if dwo.type = 'button' then
	if dwo.name = 'b_path' then
		if GetFileOpenName('원본 파일을 선택하세요', ls_path, ls_file) = 1 then
			dw_2.setitem(row,'path',ls_path)
			is_path = ls_path 
			is_file = ls_file
			dw_2.setitem(row,'filename',ls_file)
      end if
   elseif dwo.name = 'b_dis' then
		ls_path = 'c:\erpman\doc' 	
		if not directoryexists(ls_path) then 
			createdirectory(ls_path) 
		End if 
		
		selectblob mexcel into :b_data
				from meskwa_dtl
			  where sabu   = :gs_sabu
				 and mchno  = :ls_mchno
				 and seq    = :ll_seq;
		If IsNull(b_data) Then
			messagebox('확인',ls_file_name +' DownLoad할 자료가 없습니다.~r~n시스템 담당자에게 문의하십시오.')
		End If		
			IF SQLCA.SQLCode = 0 AND Not IsNull(b_data) THEN
				ls_file_name = ls_path + '\' + ls_file_name
				li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)
		
				ll_new_pos 	= 1
				li_loops 	= 0
				ll_flen 		= 0
		
				IF li_fp = -1 or IsNull(li_fp) then
					messagebox('확인',ls_path + ' Folder가 존재치 않거나 사용중인 자료입니다.')
					close(w_getblob)
				Else
					ll_flen = len(b_data)
					
					if ll_flen > 32765 then
						if mod(ll_flen,32765) = 0 then
							li_loops = ll_flen / 32765
						else
							li_loops = (ll_flen/32765) + 1
						end if
					else
						li_loops = 1
					end if
		
					if li_loops = 1 then 
						ll_bytes_read = filewrite(li_fp,b_data)
						Yield()					
					else
						for i = 1 to li_loops
							if i = li_loops then
								b_data2 = blobmid(b_data,ll_new_pos)
							else
								b_data2 = blobmid(b_data,ll_new_pos,32765)
							end if
							ll_bytes_read = filewrite(li_fp,b_data2)
							ll_new_pos = ll_new_pos + ll_bytes_read
		
							Yield()
							li_complete = ( (32765 * i ) / len(b_data)) * 100
						next
							Yield()
					end if
					
					li_rc = 0 
					
					FileClose(li_fp)
				END IF
			END IF
		//==[프로그램 실행/다운완료후]
		ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
		return		
	end if
	
End if 


end event

type rr_1 from roundrectangle within w_qct_05020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 160
integer width = 1490
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_05020
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1733
integer y = 2312
integer width = 421
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_qct_05020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1737
integer y = 1140
integer width = 2871
integer height = 1136
integer cornerheight = 40
integer cornerwidth = 55
end type

