$PBExportHeader$w_adt_01270.srw
$PBExportComments$문서 등록
forward
global type w_adt_01270 from w_inherite
end type
type rr_3 from roundrectangle within w_adt_01270
end type
type dw_1 from datawindow within w_adt_01270
end type
type rr_4 from roundrectangle within w_adt_01270
end type
type rb_2 from radiobutton within w_adt_01270
end type
type rb_1 from radiobutton within w_adt_01270
end type
type rr_2 from roundrectangle within w_adt_01270
end type
type dw_detail from datawindow within w_adt_01270
end type
end forward

global type w_adt_01270 from w_inherite
boolean visible = false
integer width = 4654
string title = "문서등록"
rr_3 rr_3
dw_1 dw_1
rr_4 rr_4
rb_2 rb_2
rb_1 rb_1
rr_2 rr_2
dw_detail dw_detail
end type
global w_adt_01270 w_adt_01270

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
char   ic_status
string is_Last_Jpno, is_Date
int    ii_Last_Jpno, iiRow


end variables

forward prototypes
public subroutine wf_new ()
end prototypes

public subroutine wf_new ();w_mdi_frame.sle_msg.text = ""

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_insert.Reset()

dw_detail.insertrow(0)
dw_detail.setredraw(true)

///////////////////////////////////////////////
dw_detail.SetFocus()

ib_any_typing = false


end subroutine

on w_adt_01270.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_1=create dw_1
this.rr_4=create rr_4
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rr_2=create rr_2
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_4
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.dw_detail
end on

on w_adt_01270.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.rr_4)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rr_2)
destroy(this.dw_detail)
end on

event open;call super::open;dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)

is_Date = f_Today()

rb_1.checked = true
rb_2.checked = false

dw_detail.Modify("doctype.dddw.display='전체'")

p_can.TriggerEvent("clicked")


end event

type dw_insert from w_inherite`dw_insert within w_adt_01270
integer x = 27
integer y = 392
integer width = 4567
integer height = 1872
integer taborder = 20
string dataobject = "d_adt_01270_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

end event

event dw_insert::clicked;call super::clicked;string ls_path, ls_docno, ls_file_name, ls_Null, ls_pritype, ls_empno, ls_dept1, ls_dept2
long   i, ll_seq, ll_new_pos, ll_flen, ll_bytes_read, ll_rc, ll_cnt, ll_cnt1
int    li_fp, li_loops, li_complete, li_rc
blob   b_data, b_data2

SetNull(ls_Null)
if row = 0 then
	f_sort_asc(this,dwo.name)  
end if


if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)

SetPointer(HourGlass!)
ls_docno     = this.getitemstring(row, 'docno'  )
ll_seq       = this.getitemnumber(row, 'docseq' )
ls_file_name = this.getitemstring(row, 'filename')
ls_pritype   = this.getitemstring(row, 'pritype')
ls_empno     = this.getitemstring(row, 'empno')


// 열기 버튼
if dwo.type = 'button' then
	
	//연구소 인원에대한 보안 해제	
   //해제 부서 확인(참조코드 = '9B')
	select count(*) into :ll_cnt1 
	  from reffpf where rfcod = '9B' and rfgub <> '00'
	   and rfna1 = :gs_dept;
	if ll_cnt1 <= 0 then
         /* 권 한 */
			if ls_pritype = '2' then     //해당부서만 공개
				//로그인 사원의 부서정보
				ls_dept1 = ''
				select deptcode
				  into :ls_dept1
				  from p1_master
				 where empno = :gs_empno ;
				if sqlca.sqlcode <> 0  then
					Messagebox("알림","등록자의 부서가 존재하지 않습니다.")
					return
				end if	
				
				//권한설정
				select count(*)
				  into :ll_cnt
				  from DOCSEC
				 where docno = :ls_docno 
					and code  = :ls_dept1;
				if ll_cnt = 0 then
					if ls_empno <> gs_empno then
						MessageBox("알림","문서 열람 권한이 없습니다.")
						return
					end if	
				end if 	
			elseif ls_pritype = '4' then //개인설정
				select count(*)
				  into :ll_cnt
				  from DOCSEC
				 where docno = :ls_docno 
					and code  = :gs_empno;
		
				if ll_cnt = 0 then
					if ls_empno <> gs_empno then
						MessageBox("알림","문서 열람 권한이 없습니다.")
						return
					end if
				end if 	
			elseif ls_pritype = '9' then //비공개
				if ls_empno <> gs_empno then
					MessageBox("알림","비공개 자료입니다.")
					return
				end if		
			end if
	end if			 
	
	
	ls_path = 'c:\erpman\doc' 	
	if not directoryexists(ls_path) then 
		createdirectory(ls_path) 
	End if 
	
	selectblob docimg into :b_data
	      from docmst
		  where docno  = :ls_docno
		    and docseq = :ll_seq;
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
		
	// Open 이력 기록
	is_today = f_today()
	is_totime = f_totime()
	
   INSERT INTO "DOCOPN_HST"  
	 		 ( "DOCNO",      "DOCSEQ", 	  "L_USERID",   "CDATE", 
			   "IPADD",      "USER_NAME" )  
   VALUES ( :ls_docno,   :ll_seq,        :gs_userid,   :is_today||:is_totime,  
	   		:gs_ipaddress, :gs_comname );
	If sqlca.sqlcode <> 0 Then
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
	
	COMMIT;
	
   //==[프로그램 실행/다운완료후]
   ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
	return		
End if 


end event

event dw_insert::itemchanged;call super::itemchanged;string	ls_Data, ls_name, ls_name2, sNull
int      ireturn
SetNull(sNull)

IF this.GetcolumnName() = 'crtdate'	THEN 
	ls_Data = trim(this.gettext())
   if ls_Data = '' or isnull(ls_Data) then return 
	if f_datechk(ls_Data) = -1 then 
		f_message_chk(35, "[재정일자]" )
		this.SetItem(1,"crtdate",sNull)
		return 1
	end if
ELSEIF this.GetcolumnName() = 'uptdate'	THEN 	
	ls_Data = trim(this.gettext())
   if ls_Data = '' or isnull(ls_Data) then return 
	if f_datechk(ls_Data) = -1 then 
		f_message_chk(35, "[개정일자]" )
		this.SetItem(1,"uptdate",sNull)
		return 1
	end if
END IF

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_adt_01270
boolean visible = false
integer x = 2999
integer y = 2452
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;//string ls_gbn, ls_sabu, ls_jpno, ls_newjpno, ls_null, ls_date, ls_msterno, ls_jocod, ls_opemp, ls_sildate
//long   ll_row, ll_maxno
//int    i
//
//Setnull(ls_null)
//w_mdi_frame.sle_msg.text =""
//SetPointer(HourGlass!)
//
//if dw_detail.AcceptText()  = -1	then return -1	
//if dw_detail2.AcceptText() = -1	then return -1	
//if dw_insert.AcceptText()  = -1	then return -1	
//
//
////입력조건
//ls_gbn   = dw_detail2.GetItemString(1,'gubun')
//
//if MessageBox('확인', '삭제 하시겠습니까?', &
//														question!, YesNo!, 2) = 2 then
//	return 2
//end if	
//
//ll_row = dw_2.getrow()
////전표유무여부
//ls_jpno = dw_2.GetItemString(ll_row,'shpjpno')
//
//if ls_jpno = '' or isnull(ls_jpno) then
//	dw_2.deleterow(ll_row)
//else	
//	//검사공정 실적등록 (SHPQCT생성)
//	if ls_gbn = '1' then      //광학특성
//		dw_2.SetItem(ll_row, 'vys'  , 0)
//		dw_2.SetItem(ll_row, 'vls'  , 0)
//		dw_2.SetItem(ll_row, 'vas'  , 0)
//		dw_2.SetItem(ll_row, 'vbs'  , 0)
//		dw_2.SetItem(ll_row, 'vp'   , 0)
//		dw_2.SetItem(ll_row, 'okyn1', ls_null)
//		dw_2.SetItem(ll_row, 'bigo1', ls_null)	
//		
//		if dw_2.update() <> 1 then
//			MessageBox('저장실패', '[광학특성 검사공정] 등록에 실패했습니다.~r' + &
//										  '전산실에 문의 하세요.', Stopsign!)
//			Rollback;
//			return
//		end if
//	elseif ls_gbn = '2' then  //신뢰성
//		dw_2.SetItem(ll_row, 'vag'  , 0)
//		dw_2.SetItem(ll_row, 'cond' , ls_null)
//		dw_2.SetItem(ll_row, 'okyn2', ls_null)
//		dw_2.SetItem(ll_row, 'bigo2', ls_null)	
//		if dw_2.update() <> 1 then
//			MessageBox('저장실패', '[신뢰성 검사공정] 등록에 실패했습니다.~r' + &
//										  '전산실에 문의 하세요.', Stopsign!)
//			Rollback;
//			return
//		end if
//	else                      //박리력
//		dw_2.SetItem(ll_row, 'vgl'  , 0)
//		dw_2.SetItem(ll_row, 'vef'  , 0)
//		dw_2.SetItem(ll_row, 'vpf'  , 0)
//		dw_2.SetItem(ll_row, 'val'  , 0)
//		dw_2.SetItem(ll_row, 'okyn3', ls_null)
//		dw_2.SetItem(ll_row, 'bigo3', ls_null)	
//		if dw_2.update() <> 1 then
//			MessageBox('저장실패', '[박리력 검사공정] 등록에 실패했습니다.~r' + &
//										  '전산실에 문의 하세요.', Stopsign!)
//			Rollback;
//			return
//		end if
//	end if
//end if
//
//Commit;
//ib_any_typing = False
//
//SetPointer(Arrow!)
//
//
end event

type p_addrow from w_inherite`p_addrow within w_adt_01270
boolean visible = false
integer x = 3186
integer y = 2448
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;//string ls_gbn, ls_jocod, ls_opemp, ls_sildate
//long   ll_cnt, ll_row, ll_row1
//int    i
//
//dw_insert.accepttext() 
//dw_detail.accepttext() 
//dw_detail2.accepttext() 
//
//ls_gbn      = dw_detail2.GetItemString(1,'gubun')
//ls_jocod    = dw_detail.GetItemString(1,'jocod')
//ls_opemp    = dw_detail.GetItemString(1,'opemp')
//ls_sildate  = dw_detail.GetItemString(1,'sildate')
//
//if ls_jocod = '' or isnull(ls_jocod)	 then
//	f_message_chk(30, '[작업조]')
//	dw_detail.setcolumn("jocod")
//	dw_detail.setfocus()	
//	return
//end if
//
//if ls_opemp = '' or isnull(ls_opemp)	 then
//	f_message_chk(30, '[검사자]')
//	dw_detail.setcolumn("opemp")
//	dw_detail.setfocus()	
//	return
//end if
//
//if f_datechk(ls_sildate) = -1	 then
//	f_message_chk(30, '[실적일자]')
//	dw_detail.setcolumn("sildate")
//	dw_detail.setfocus()	
//	return
//end if
//
////선택사항여부 확인
//ll_row = 0
//ll_cnt = 0
//for i = 1 to dw_insert.rowcount()
//	 if dw_insert.GetItemString(i,'chk') = 'Y' then
//		 ll_cnt ++
//		 ll_row = i  //선택 Row값
//	 end if	
//next
//
//if ll_cnt = 0 then
//	MessageBox('알림','선택하신 내역이 없습니다. 선택후 작업하세요!')
//	return
//elseif ll_cnt > 1 then
//	MessageBox('알림','선택하신 내역이 하나 이상입니다. ~n 한번에 하나씩 작업가능합니다!')
//	return
//end if	
//
//ll_row1 = dw_2.rowcount()
//dw_2.Insertrow(ll_row1 + 1)
////입력조건에 따른 DataWindow 활성/비활성
////조회사항 셋팅(dw_insert,dw_detail =>dw_1,dw_2,dw_3)
//dw_2.SetItem(ll_row1 + 1, 'sabu'    , dw_insert.GetItemString(ll_row,'sabu'))
//dw_2.SetItem(ll_row1 + 1, 'lotsno'  , dw_insert.GetItemString(ll_row,'lotsno'))		
//dw_2.SetItem(ll_row1 + 1, 'itnbr'   , dw_insert.GetItemString(ll_row,'itnbr'))
//dw_2.SetItem(ll_row1 + 1, 'itdsc'   , dw_insert.GetItemString(ll_row,'itdsc'))
//dw_2.SetItem(ll_row1 + 1, 'ispec'   , dw_insert.GetItemString(ll_row,'ispec'))
//	
//if ls_gbn = '1' then       //광학특성 
//   dw_2.setcolumn('vys')
//elseif ls_gbn = '2' then   //신뢰성
//	dw_2.setcolumn('vag')
//else                       //박리력
//	dw_2.setcolumn('vgl')	   
//end if
//dw_2.setfocus()
//
//
//
//
//
end event

type p_search from w_inherite`p_search within w_adt_01270
integer x = 3922
integer taborder = 0
string picturename = "C:\erpman\image\수정_up.gif"
end type

event p_search::clicked;call super::clicked;string ls_docno, ls_empno, ls_no
long   ll_docseq, ll_cnt, ll_row, ll_seq
int    i, j
str_doc str_1

w_mdi_frame.sle_msg.text =""
SetPointer(HourGlass!)

if dw_insert.AcceptText() = -1	then return -1	

//선택사항여부 확인
ll_cnt = 0
for i = 1 to dw_insert.rowcount()
	 if dw_insert.GetItemString(i,'chk') = 'Y' then
		 ll_row = i
		 ll_cnt ++
	 end if	
next

if ll_cnt = 0 then
	MessageBox('알림','선택하신 내역이 없습니다. 선택후 작업하세요!')
	return
elseif ll_cnt > 1 then
	MessageBox('알림','수정작업은 하나 이상 선택할 수 없습니다.')
	return
end if	

//삭제 권한 체크(등록자와 로그인 사번이 동일할 경우만 삭제가능함)
ll_cnt = 0
if dw_insert.GetItemString(ll_row,'chk') = 'Y' then
  if dw_insert.GetItemString(ll_row,'empno') <> gs_empno then
     MessageBox('알림', '자료에 대한 수정 권한이 없습니다.~n 본인이 등록한 자료만 수정 가능합니다.')
     return
  end if	
end if		
ls_no  = dw_insert.GetItemString(ll_row,'docno')
ll_seq = dw_insert.GetItemNumber(ll_row,'docseq')

str_1.st_docno = ls_no
str_1.st_seq   = ll_seq

//문서추가popup에서 수정일경우
gs_gubun = '2'

iiRow = dw_insert.GetRow()

openwithparm(w_adt_01270_01, str_1)

w_mdi_frame.sle_msg.Text = ''
p_inq.TriggerEvent(Clicked!)

dw_insert.SelectRow(0,False)
dw_insert.SelectRow(iiRow,True)

SetPointer(Arrow!)


end event

event p_search::ue_lbuttondown;p_search.picturename = "C:\erpman\image\수정_dn.gif"
end event

event p_search::ue_lbuttonup;p_search.picturename = "C:\erpman\image\수정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_adt_01270
integer x = 3749
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;str_doc str_1

str_1.st_docno = ''
str_1.st_seq   = 0

//문서추가popup에서 신규일경우
gs_gubun = '1'

openwithparm(w_adt_01270_01, str_1)

w_mdi_frame.sle_msg.Text = ''
p_inq.TriggerEvent(Clicked!)


end event

type p_exit from w_inherite`p_exit within w_adt_01270
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_adt_01270
integer taborder = 90
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

Rollback ;

wf_New()





end event

type p_print from w_inherite`p_print within w_adt_01270
boolean visible = false
integer x = 3003
integer y = 2336
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_adt_01270
integer x = 3575
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;string ls_null, ls_type, ls_idx, ls_empno,ls_docnm, ls_doccls
SetNull(ls_null)

if dw_detail.Accepttext() = -1	then 	return	

ls_type   = dw_detail.GetItemstring(1,'doctype')
ls_idx    = dw_detail.GetItemstring(1,'docidx')
ls_empno  = dw_detail.GetItemstring(1,'empno')
ls_docnm  = dw_detail.GetItemstring(1,'docname')
ls_doccls = dw_detail.GetItemstring(1,'l_gubun')

if ls_type = '' or isnull(ls_type) then
	ls_type = '%'
end if	

if ls_idx = '' or isnull(ls_idx) then
	ls_idx = '%'
else
	ls_idx = '%' + ls_idx + '%'
end if	
if ls_docnm = '' or isnull(ls_docnm) then
	ls_docnm = '%'
else
	ls_docnm = '%' + ls_docnm + '%'
end if	
if ls_empno = '' or isnull(ls_empno) then
	ls_empno = '%'
end if	
if ls_doccls = '' or isnull(ls_doccls) then
	ls_doccls = '%'
end if	

//조회
IF dw_insert.Retrieve(ls_type, ls_idx, ls_empno, ls_docnm, ls_doccls) < 1 THEN 
	f_message_chk(50, '[문서등록]')
	dw_detail.setcolumn("doctype")
	dw_detail.setfocus()
	RETURN
END IF

ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_adt_01270
integer taborder = 80
end type

event p_del::clicked;call super::clicked;string ls_docno, ls_empno
long   ll_docseq, ll_cnt
int    i, j

w_mdi_frame.sle_msg.text =""
SetPointer(HourGlass!)

if dw_insert.AcceptText() = -1	then return -1	

//선택사항여부 확인
ll_cnt = 0
for i = 1 to dw_insert.rowcount()
	 if dw_insert.GetItemString(i,'chk') = 'Y' then
		 ll_cnt ++
	 end if	
next

if ll_cnt = 0 then
	MessageBox('알림','선택하신 내역이 없습니다. 선택후 작업하세요!')
	return
end if	

//삭제 권한 체크(등록자와 로그인 사번이 동일할 경우만 삭제가능함)
ll_cnt = 0
for j = 1 to dw_insert.rowcount()
	if dw_insert.GetItemString(j,'chk') = 'Y' then
	   if dw_insert.GetItemString(j,'empno') <> gs_empno then
		   MessageBox('알림', string(j) + ' 번째 ROW 자료에 대한 삭제 권한이 없습니다.~n 본인이 등록한 자료만 삭제 가능합니다.')
		   return
	   end if	
	end if		
next

if MessageBox('확인', '선택하신 문서를 삭제 하시겠습니까?', &
														question!, YesNo!, 2) = 2 then
	return 2
end if	

for i = 1 to dw_insert.rowcount()
	 if dw_insert.GetItemString(i,'chk') = 'Y' then
		 ls_docno  = dw_insert.GetItemString(i,'docno')
		 ll_docseq = dw_insert.GetItemNumber(i,'docseq')
		 DELETE FROM DOCMST WHERE DOCNO = :ls_docno AND DOCSEQ = :ll_docseq; 
		 if sqlca.sqlcode <> 0 then
		    MessageBox('삭제실패', '[문서삭제] DELETE 실패!~r' + &
		  						         '전산실에 문의 하세요.', Stopsign!)
		    rollback;
		    return
	     end if	
	     dw_insert.deleterow(i)
	 end if		 
next	
commit;

ib_any_typing = False

//재조회
p_inq.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type p_mod from w_inherite`p_mod within w_adt_01270
boolean visible = false
integer x = 3369
integer y = 2444
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;//string ls_docname
//
//If dw_insert.AcceptText() <> 1 Then Return
//
//if dw_insert.rowcount() < 1 then
//	Messagebox("확인","저장할 자료가 없습니다")
//	return
//end if
//
//ls_docname  = dw_insert.getitemstring(1,'docname')
//
//if trim(ls_docname) = '' or isnull(ls_docname) then
//	messagebox('선택', '문서명(FILE명)을 선택하세요.')
//	dw_insert.setcolumn('docname')
//	dw_insert.setfocus()
//	return
//end if
//
//If dw_insert.Update() = -1 then  
//	messagebox("확인","저장실패!")
//	Rollback;
//Else
//	Commit;		
//	messagebox("확인","문서등록 내역이 수정 되었습니다!")
//End if
//
//w_mdi_frame.sle_msg.text =""
end event

type cb_exit from w_inherite`cb_exit within w_adt_01270
end type

type cb_mod from w_inherite`cb_mod within w_adt_01270
end type

type cb_ins from w_inherite`cb_ins within w_adt_01270
end type

type cb_del from w_inherite`cb_del within w_adt_01270
end type

type cb_inq from w_inherite`cb_inq within w_adt_01270
end type

type cb_print from w_inherite`cb_print within w_adt_01270
end type

type st_1 from w_inherite`st_1 within w_adt_01270
end type

type cb_can from w_inherite`cb_can within w_adt_01270
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_adt_01270
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_01270
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_01270
end type

type rr_3 from roundrectangle within w_adt_01270
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 3406
integer height = 332
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_adt_01270
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

type rr_4 from roundrectangle within w_adt_01270
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 380
integer width = 4590
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_2 from radiobutton within w_adt_01270
boolean visible = false
integer x = 2606
integer y = 2392
integer width = 270
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "수정"
end type

event clicked;//dw_detail.reset()
//dw_detail.insertrow(0)
//dw_detail.SetItem(1, "sdate", is_Date)
//dw_detail.SetItem(1, "edate", is_Date)
//dw_detail.SetItem(1, "sildate", is_Date)
//
//dw_insert.reset()
//dw_insert.dataobject = 'd_adt_01110_1_2'
//dw_insert.settransobject(sqlca)
//
//dw_2.reset()
//is_gubun = '1'

end event

type rb_1 from radiobutton within w_adt_01270
boolean visible = false
integer x = 2267
integer y = 2392
integer width = 315
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;//dw_detail.reset()
//dw_detail.insertrow(0)
//dw_detail.SetItem(1, "sdate", is_Date)
//dw_detail.SetItem(1, "edate", is_Date)
//dw_detail.SetItem(1, "sildate", is_Date)
//
//dw_insert.reset()
//dw_insert.dataobject = 'd_adt_01110_1'
//dw_insert.settransobject(sqlca)
//
//dw_2.reset()
//is_gubun = '0'
//
end event

type rr_2 from roundrectangle within w_adt_01270
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2213
integer y = 2352
integer width = 727
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_adt_01270
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 27
integer y = 52
integer width = 3387
integer height = 292
integer taborder = 10
string title = "none"
string dataobject = "d_adt_01270"
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

event itemchanged;string	ls_Data, ls_name, sNull, ls_nm, ls_nm2
int      ireturn

SetNull(sNull)
// 문서유형
IF this.GetColumnName() = 'doctype' THEN
	ls_Data = this.GetText()	
	SELECT "REFFPF"."RFNA1"  
	  INTO :ls_name  
     FROM "REFFPF"  
    WHERE ( "REFFPF"."SABU" = '1' )  
      AND ( "REFFPF"."RFCOD" = '12' )
      AND ( "REFFPF"."RFGUB" = :ls_Data ) ;
	IF SQLCA.SQLCODE <> 0 THEN
	   this.SetItem(1,"doctpnm",sNull)
	ELSE	
		this.SetItem(1,"doctpnm", left(ls_name, 20))
 	END IF
ELSEIF this.GetColumnName() = 'empno' THEN

	ls_Data = this.gettext()
	
   ireturn = f_get_name2('사번', 'Y', ls_Data, ls_nm, ls_nm2)	 
	this.setitem(1, "empno", ls_Data)
	this.setitem(1, "empnm", ls_nm)
	
   return ireturn 	 	 
ELSEIF this.GetColumnName() = 'empnm' then
	  ls_nm = Trim(GetText())
	  If ls_nm = '' Or IsNull(ls_nm) Then
		  this.SetItem(1,'empno',sNull)
		  Return
	  End If
	
	  SELECT "P1_MASTER"."EMPNO", "P1_MASTER"."EMPNAME" 
		 INTO :ls_Data, :ls_nm
		 FROM "P1_MASTER"  
		WHERE ("P1_MASTER"."EMPNAME" = :ls_nm ) AND 
				("P1_MASTER"."SERVICEKINDCODE" <> '3' );
	
	  IF SQLCA.SQLCODE <> 0 THEN
		 this.TriggerEvent(RbuttonDown!)
		 Return 2
	  ELSE
		 this.SetItem(1,"empno",ls_Data)
	  END IF
		
   return 0 	 	 
END IF


ib_any_typing = False
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;Setnull(gs_gubun)
Setnull(gs_code)
Setnull(gs_codename)
this.accepttext()

IF this.GetColumnName() = 'empno' or this.GetColumnName() = 'empnm'	THEN
	Open(w_sawon_popup)
	IF gs_code = '' or isnull(gs_code) then return 

	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
end if


end event

