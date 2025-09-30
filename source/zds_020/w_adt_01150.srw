$PBExportHeader$w_adt_01150.srw
$PBExportComments$설비도면관리
forward
global type w_adt_01150 from w_inherite
end type
type rr_3 from roundrectangle within w_adt_01150
end type
type dw_1 from datawindow within w_adt_01150
end type
type rr_4 from roundrectangle within w_adt_01150
end type
type dw_detail from datawindow within w_adt_01150
end type
type p_1 from picture within w_adt_01150
end type
type rr_1 from roundrectangle within w_adt_01150
end type
end forward

global type w_adt_01150 from w_inherite
integer width = 4654
string title = "설비도면관리"
string menuname = ""
boolean maxbox = true
boolean resizable = true
rr_3 rr_3
dw_1 dw_1
rr_4 rr_4
dw_detail dw_detail
p_1 p_1
rr_1 rr_1
end type
global w_adt_01150 w_adt_01150

type variables
char   ic_status
string is_Last_Jpno, is_Date, is_gubun, is_del_path
int    ii_Last_Jpno


end variables

forward prototypes
public subroutine wf_new ()
end prototypes

public subroutine wf_new ();ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setfocus()

dw_detail.setredraw(true)

dw_insert.reset()
p_1.picturename = ''
ib_any_typing = false


end subroutine

on w_adt_01150.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_1=create dw_1
this.rr_4=create rr_4
this.dw_detail=create dw_detail
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_4
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_adt_01150.destroy
call super::destroy
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.rr_4)
destroy(this.dw_detail)
destroy(this.p_1)
destroy(this.rr_1)
end on

event open;call super::open;string s_code

dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)
p_can.TriggerEvent("clicked")

s_code = gs_gubun

//설비 마스터에서 호출시에만 가운데위치
if gs_code = '1' then
	   f_window_center(this)
end if	
	
if not(isnull(s_code) or s_code = "") then		
   dw_detail.setitem(1, 'mchno', s_code)
//	p_inq.triggerevent(Clicked!)
	dw_detail.triggerevent(itemchanged!)
end if	

end event

event close;call super::close;setnull(gs_gubun)
setnull(gs_code)
end event

type dw_insert from w_inherite`dw_insert within w_adt_01150
integer x = 41
integer y = 304
integer width = 1550
integer height = 1996
integer taborder = 20
string dataobject = "d_adt_01150_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;string  ls_mchno, ls_mapno, ls_rev_no, ls_file_path, ls_file_nm, ls_save_path
long    ll_FileLength, ll_rtn
blob    imagedata, imagedata2
int     li_TotalWrites, li_FileNum, loops, fnum, i

imagedata = Blob(Space(0))
imagedata = imagedata2
p_1.picturename = ''

if dw_insert.accepttext() = -1 then return -1

if currentrow <=0 then return
this.SelectRow(0,False)
this.SelectRow(currentrow,True)

ls_mchno  = dw_insert.GetItemString(currentrow,'mchno')
ls_mapno  = dw_insert.GetItemString(currentrow,'mapno')
ls_rev_no = dw_insert.GetItemString(currentrow,'rev_no')

//파일종류
SELECT FILE_NM  INTO :ls_file_nm FROM MCHMAP
 WHERE MCHNO  = :ls_mchno
   AND MAPNO  = :ls_mapno
   AND REV_NO = :ls_rev_no;

ls_save_path = "C:\erpman\" + ls_file_nm

//PC 임시저장 삭제
FileDelete(is_del_path)
is_del_path     = '' 

//이미지 DB => DISPLAY
SELECTBLOB IMAGE  INTO :imagedata FROM MCHMAP
	  WHERE MCHNO  = :ls_mchno
	    AND MAPNO  = :ls_mapno
		 AND REV_NO = :ls_rev_no;

ll_FileLength = Len(imagedata)

IF IsNull(imagedata) or len(imagedata) <= 0 THEN 
   return
END IF

IF ll_FileLength > 32765 THEN
  IF Mod(ll_FileLength, 32765) = 0 THEN
     loops = ll_FileLength/32765
  ELSE
     loops = (ll_FileLength/32765) + 1
  END IF
ELSE
  loops = 1
END IF

ls_file_path = ls_save_path
fnum = FileOpen(ls_file_path, StreamMode!, Write!, Shared!, Replace!)

// Read the file
FOR i = 1 to loops
   ll_rtn = FileWrite(fnum, imagedata)
   if ll_rtn=32765 then
      imagedata = BlobMid(imagedata, 32766)
   end if
NEXT

FileClose(fnum)

p_1.picturename = ls_save_path
is_del_path     = ls_save_path




end event

event dw_insert::clicked;call super::clicked;string  ls_mchno, ls_mapno, ls_rev_no, ls_file_path, ls_file_nm, ls_save_path
long    ll_FileLength, ll_rtn
blob    imagedata, imagedata2
int     li_TotalWrites, li_FileNum, loops, fnum, i

imagedata = Blob(Space(0))
imagedata = imagedata2
p_1.picturename = ''
if dw_insert.accepttext() = -1 then return -1

if row <=0 then return
this.SelectRow(0,False)
this.SelectRow(row,True)

ls_mchno  = dw_insert.GetItemString(row,'mchno')
ls_mapno  = dw_insert.GetItemString(row,'mapno')
ls_rev_no = dw_insert.GetItemString(row,'rev_no')

//파일종류
SELECT FILE_NM  INTO :ls_file_nm FROM MCHMAP
 WHERE MCHNO  = :ls_mchno
   AND MAPNO  = :ls_mapno
   AND REV_NO = :ls_rev_no;

ls_save_path = "C:\erpman\" + ls_file_nm

//PC 임시저장 삭제
FileDelete(is_del_path)
is_del_path     = '' 
 
//이미지 DB => DISPLAY
SELECTBLOB IMAGE  INTO :imagedata FROM MCHMAP
	  WHERE MCHNO  = :ls_mchno
	    AND MAPNO  = :ls_mapno
		 AND REV_NO = :ls_rev_no;

ll_FileLength = Len(imagedata)

IF IsNull(imagedata) or len(imagedata) <= 0 THEN 
   return
END IF

IF ll_FileLength > 32765 THEN
  IF Mod(ll_FileLength, 32765) = 0 THEN
     loops = ll_FileLength/32765
  ELSE
     loops = (ll_FileLength/32765) + 1
  END IF
ELSE
  loops = 1
END IF

ls_file_path = ls_save_path
fnum = FileOpen(ls_file_path, StreamMode!, Write!, Shared!, Replace!)

// Read the file
FOR i = 1 to loops
   ll_rtn = FileWrite(fnum, imagedata)
   if ll_rtn=32765 then
      imagedata = BlobMid(imagedata, 32766)
   end if
NEXT

FileClose(fnum)

p_1.picturename = ls_save_path
is_del_path     = ls_save_path



end event

event dw_insert::losefocus;call super::losefocus;//PC 임시저장 삭제
FileDelete(is_del_path)
is_del_path     = '' 
end event

type p_delrow from w_inherite`p_delrow within w_adt_01150
boolean visible = false
integer x = 3936
integer y = 164
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;string sblno
long	lrow, lcount
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

// 물대비용이 등록된 경우에는 수정불가
SELECT COUNT(*)  INTO :lcount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POBLNO = :sBlno and mulgu = 'Y'  ;
 
IF lcount > 0 then 
	MessageBox("확인", "구매결제된 B/L번호는 삭제할 수 없습니다.")
	RETURN 
END IF	

//IF f_msg_delete() = -1 THEN	RETURN

dw_insert.DeleteRow(lRow)
//sBlno = trim(dw_detail.GetItemString(1, "poblno"))
//
//if dw_insert.rowcount() < 1 then
//	
//	// 수입비용이 등록된 경우에는 수정불가
//	SELECT COUNT(*)  INTO :lcount
//	  FROM IMPEXP 
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno;
//	 
//	IF lcount > 0 then 
//		MessageBox("확인", "수입비용이 등록된 B/L번호는 삭제할 수 없습니다.")
//		RETURN 
//	END IF		
//	
//	// HEAD삭제
//	DELETE POLCBLHD
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		rollback;
//		MESSAGEBOX("B/L-HEAD", "B/L-HEAD삭제시 오류가 발생", stopsign!)
//		return
//	END IF	
//end if
//

ib_any_typing = true

end event

type p_addrow from w_inherite`p_addrow within w_adt_01150
boolean visible = false
integer x = 3758
integer y = 168
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return


//////////////////////////////////////////////////////////
long		lRow
string  	sBlno

sBlno	= dw_detail.getitemstring(1, "poblno")


lRow = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(lRow)
dw_insert.SetColumn("polcno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_adt_01150
boolean visible = false
integer x = 3922
integer taborder = 0
string picturename = "C:\erpman\image\도면조회_up.gif"
end type

event p_search::clicked;call super::clicked;



//string	filename, filepath, temp_date, txtname, il_filename
//long		filelength, loops
//Int		li_ItemTotal, li_ItemCount, fnum, i, li_rtn
//long     bytes_read, lgth
//blob     b, imagedata,imagedata2
//
//li_rtn = GetFileOpenName("Select File", &
//                         + txtname, il_filename, "JPG", &
//                         + "JPEG Files (*.JPG), *.JPG," &
//								 + "BMP Files (*.BMP), *.BMP") 
//								 
//filepath   = txtname
//filename   = il_filename
//filelength = FileLength(filepath)
//
////fnum = FileOpen(filepath,StreamMode!, Read!, LockRead!)
//
////IF fnum = -1 THEN
////  MessageBox('알림', '파일열기 에러입니다.')
////  return
////END IF
//
//P_1.PictureName = filepath
//
////파일을 닫는다.
////FileClose(fnum)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\도면조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\도면조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_adt_01150
integer x = 4096
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;Open(w_adt_01150_1)

w_mdi_frame.sle_msg.Text = ''

end event

type p_exit from w_inherite`p_exit within w_adt_01150
integer taborder = 100
end type

event p_exit::clicked;call super::clicked;setnull(gs_gubun)
setnull(gs_code)
end event

type p_can from w_inherite`p_can within w_adt_01150
integer taborder = 90
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

wf_New()


end event

type p_print from w_inherite`p_print within w_adt_01150
boolean visible = false
integer x = 3575
integer y = 164
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_adt_01150
integer x = 3922
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;string  ls_mchno, ls_null

if dw_detail.Accepttext() = -1	then 	return
			
SetNull(ls_null)

ls_mchno	= dw_detail.getitemstring(1, "mchno")

IF isnull(ls_mchno) or ls_mchno = "" 	THEN
	f_message_chk(30,'[설비코드]')
	dw_detail.SetColumn("mchno")
	dw_detail.SetFocus()
	RETURN
END IF

dw_detail.SetRedraw(False)

IF dw_insert.Retrieve(ls_mchno) < 1	THEN
	f_message_chk(50, '[설비코드]')
	dw_detail.setcolumn("mchno")
	dw_detail.setfocus()

	ib_any_typing = False
	p_can.TriggerEvent("clicked")
	RETURN
END IF

dw_detail.SetRedraw(True)

ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_adt_01150
boolean visible = false
integer x = 4110
integer y = 160
integer taborder = 80
end type

event p_del::clicked;call super::clicked;//string	ls_blno, ls_lcno, ls_baljpno, ls_itnbr
//integer  i
//long     lcnt, ll_cnt, ll_blseq, ll_balseq
//decimal  ld_blqty
//
//
//SetPointer(HourGlass!)
//
//IF dw_insert.RowCount() < 1		THEN 	RETURN 
//IF dw_detail.AcceptText() = -1	THEN	RETURN
//IF dw_insert.AcceptText() = -1	THEN	RETURN
//
//
////입고여부 체크 및 선택 여부체크
//if is_gubun = '1' then	
//	for i = 1 to dw_insert.Rowcount()	
//	 if dw_insert.GetItemString(i, 'chk') = 'Y' then 
//		 if dw_insert.GetItemnumber(i,'entqty') > 0 then
//			 messagebox('알림', '선택하신 내역중' + string(i) + '번째 선택 내역은 ~n이미 통관처리되어 입고취소 작업을 할 수 없습니다.')
//			 return
//		 end if		  
//		 lCnt++
//	 end if	 
//   Next
//else
//   MessageBox('알림','미입고된 자료입니다. 입고 후 작업가능 합니다')
//	return
//end if
//
//if lcnt < 1 then
//		MessageBox('확인', '선택하신 내역이 없습니다.~n선택 후 작업하시기 바랍니다', Exclamation!)
//		return
//end if	
//
//if MessageBox('확인', '선택하신 B/L을 입고 취소 하시겠습니까?', &
//														question!, YesNo!, 2) = 2 then
//	return 2
//end if	
//
////보세창고 입하(입고 내역 취소처리)
//if is_gubun = '1' then	
//	for i = 1 to dw_insert.rowcount()
//		 if dw_insert.GetItemString(i, 'chk') = 'Y' then 
//			 ls_blno    = dw_insert.GetItemString(i, 'poblno')
//			 ll_blseq   = dw_insert.GetItemNumber(i, 'pobseq')
//			 ls_lcno    = dw_insert.GetItemString(i, 'polcno')
//			 ls_baljpno = dw_insert.GetItemString(i, 'baljpno')
//			 ll_balseq  = dw_insert.GetItemNumber(i, 'balseq')
//			 ls_itnbr   = dw_insert.GetItemString(i, 'itnbr')	
//			 
//			 select count(*) 
//			   into :ll_cnt
//				from bondhst
// 			  where sabu    = :gs_sabu
//				 and poblno  = :ls_blno
//				 and pobseq  = :ll_blseq
//				 and polcno  = :ls_lcno
//				 and baljpno = :ls_baljpno
//				 and balseq  = :ll_balseq ;
//				 
//			 if ll_cnt > 0 then				
//				  delete from bondhst
//				  where sabu    = :gs_sabu    and poblno  = :ls_blno
//					 and pobseq  = :ll_blseq   and polcno  = :ls_lcno
//					 and baljpno = :ls_baljpno and balseq  = :ll_balseq ;
//					 
//			     if sqlca.sqlcode <> 0 then
//				     MessageBox('취소실패', '[보세창고 입고취소] DELETE 실패!~r' + &
//					 	  					       '전산실에 문의 하세요.', Stopsign!)
//				     Rollback;
//				     return
//			     end if
//			 else	  
//				Messagebox('확인', '취소할 보세창고 입고 자료가 존재하지 않습니다')
//				return
//			 end if				 
//		 end if	
//	next	
//end if	
//
//Commit;
//
//ib_any_typing = False
//
//p_inq.TriggerEvent("clicked")	
//cbx_1.checked = false
//
//SetPointer(Arrow!)
//
//
end event

type p_mod from w_inherite`p_mod within w_adt_01150
boolean visible = false
integer x = 4096
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;

//UPDATEBLOB MCHMAP
//		 SET IMAGE  = :imagedata
//	  WHERE empno  = :sempno	;
//
//IF sqlca.sqlCode = 0 and sqlca.sqldbcode = 0 THEN
//	commit;
//	p_1.SetPicture(imagedata)
//ELSE
//	MessageBox("DB ERROR", String(Sqlca.SqlCode) + '/' + String(Sqlca.SqlDbCode) + '/' +&
//					Sqlca.SqlErrText)
//	rollback;
//	return -1
//END IF
//
//END IF
end event

type cb_exit from w_inherite`cb_exit within w_adt_01150
end type

type cb_mod from w_inherite`cb_mod within w_adt_01150
end type

type cb_ins from w_inherite`cb_ins within w_adt_01150
end type

type cb_del from w_inherite`cb_del within w_adt_01150
end type

type cb_inq from w_inherite`cb_inq within w_adt_01150
end type

type cb_print from w_inherite`cb_print within w_adt_01150
end type

type st_1 from w_inherite`st_1 within w_adt_01150
end type

type cb_can from w_inherite`cb_can within w_adt_01150
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_adt_01150
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_01150
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_01150
end type

type rr_3 from roundrectangle within w_adt_01150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 28
integer width = 3465
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_adt_01150
boolean visible = false
integer x = 837
integer y = 2540
integer width = 411
integer height = 432
boolean bringtotop = true
string title = "none"
string dataobject = "d_lc_detail_popup1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_4 from roundrectangle within w_adt_01150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 1582
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_adt_01150
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 32
integer y = 84
integer width = 1577
integer height = 100
integer taborder = 10
string title = "none"
string dataobject = "d_adt_01150"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "mchno" then 
	if IsNull(s_cod) or s_cod = "" then 
		this.object.mchnm[1] = ""
		return
	end if	
	
	select mchnam into :s_nam1 
	  from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then 
	   this.object.mchno[1] = ""
	   this.object.mchnm[1] = ""
	else
	   this.object.mchno[1] = s_cod
	   this.object.mchnm[1] = s_nam1
   end if
	dw_insert.reset()
	p_inq.triggerevent(Clicked!)
end if


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "mchno" then
	gs_gubun = 'ALL'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.object.mchno[1] = gs_code
	this.object.mchnm[1] = gs_codename
   dw_insert.reset()
	p_inq.triggerevent(Clicked!)
end if	

end event

type p_1 from picture within w_adt_01150
integer x = 1646
integer y = 316
integer width = 2930
integer height = 1956
boolean bringtotop = true
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_adt_01150
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1623
integer y = 288
integer width = 2990
integer height = 2020
integer cornerheight = 40
integer cornerwidth = 55
end type

