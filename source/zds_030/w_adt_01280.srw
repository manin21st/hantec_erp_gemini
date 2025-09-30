$PBExportHeader$w_adt_01280.srw
$PBExportComments$문서관리대장
forward
global type w_adt_01280 from w_standard_print
end type
type rr_1 from roundrectangle within w_adt_01280
end type
type rr_3 from roundrectangle within w_adt_01280
end type
end forward

global type w_adt_01280 from w_standard_print
string title = "문서관리대장"
rr_1 rr_1
rr_3 rr_3
end type
global w_adt_01280 w_adt_01280

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
str_itnct str_sitnct
dec idMeter
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_null, ls_type, ls_idx, ls_empno, ls_docnm, ls_doccls
SetNull(ls_null)

if dw_ip.Accepttext() = -1	then 	return -1

ls_type   = dw_ip.GetItemstring(1,'doctype')
ls_idx    = dw_ip.GetItemstring(1,'docidx')
ls_empno  = dw_ip.GetItemstring(1,'empno')
ls_docnm  = dw_ip.GetItemstring(1,'docname')
ls_doccls = dw_ip.GetItemstring(1,'l_gubun')

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
/* 조회 */
if dw_print.retrieve(ls_type, ls_idx, ls_empno, ls_docnm, ls_doccls) < 1 then
	f_message_chk(300,'')
	dw_list.Reset()
	dw_ip.setfocus()
	dw_ip.setcolumn('doctype')
	return -1
end if

dw_print.ShareData(dw_list)

return 1




end function

on w_adt_01280.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_3
end on

on w_adt_01280.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event ue_open;call super::ue_open;
dw_ip.SetTransObject(SQLCA)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_print.object.datawindow.print.preview = "yes"	

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_adt_01280
end type

type p_exit from w_standard_print`p_exit within w_adt_01280
end type

type p_print from w_standard_print`p_print within w_adt_01280
end type

type p_retrieve from w_standard_print`p_retrieve within w_adt_01280
end type











type dw_print from w_standard_print`dw_print within w_adt_01280
integer x = 3744
integer y = 32
integer width = 133
integer height = 120
string dataobject = "d_adt_01280_p"
end type

type dw_ip from w_standard_print`dw_ip within w_adt_01280
integer x = 64
integer y = 48
integer width = 3456
integer height = 288
string dataobject = "d_adt_01280"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;string	ls_Data, ls_name, sNull, ls_nm, ls_nm2
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


end event

event dw_ip::rbuttondown;Setnull(gs_gubun)
Setnull(gs_code)
Setnull(gs_codename)
this.accepttext()

IF this.GetColumnName() = 'empno' or this.GetColumnName() = 'empnm'		THEN
	Open(w_sawon_popup)
	IF gs_code = '' or isnull(gs_code) then return 

	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
end if


end event

type dw_list from w_standard_print`dw_list within w_adt_01280
integer x = 55
integer y = 396
integer width = 4567
integer height = 1832
string dataobject = "d_adt_01280_1"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::clicked;call super::clicked;string ls_path, ls_docno, ls_file_name, ls_Null, ls_pritype, ls_empno, ls_dept1, ls_dept2
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

type rr_1 from roundrectangle within w_adt_01280
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 372
integer width = 4581
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_adt_01280
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 20
integer width = 3525
integer height = 328
integer cornerheight = 40
integer cornerwidth = 46
end type

