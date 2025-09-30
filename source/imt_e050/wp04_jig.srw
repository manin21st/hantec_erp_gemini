$PBExportHeader$wp04_jig.srw
$PBExportComments$치공구 수리결과 현황
forward
global type wp04_jig from w_standard_print
end type
type rr_1 from roundrectangle within wp04_jig
end type
end forward

global type wp04_jig from w_standard_print
integer height = 2504
string title = "치공구 수리결과 현황"
rr_1 rr_1
end type
global wp04_jig wp04_jig

type variables
DataWindowChild idwc_1, idwc_2
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(row, 'st_dat')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		Messagebox('일자확인', '일자형식이 잘못되었습니다.')
		dw_ip.SetColumn('st_dat')
		dw_ip.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_ip.GetItemString(row, 'ed_dat')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		Messagebox('일자확인', '일자형식이 잘못되었습니다.')
		dw_ip.SetColumn('ed_dat')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_kum

ls_kum = dw_ip.GetItemString(row, 'kumno')
If Trim(ls_kum) = '' OR IsNull(ls_kum) Then 
	ls_kum = '%'
Else
	ls_kum = ls_kum + '%'
End If

String ls_gbn[]

ls_gbn[1] = dw_ip.GetItemString(row, 'gbn1')
If Trim(ls_gbn[1]) = '' OR IsNull(ls_gbn[1]) Then ls_gbn[1] = 'N'

ls_gbn[2] = dw_ip.GetItemString(row, 'gbn2')
If Trim(ls_gbn[2]) = '' OR IsNull(ls_gbn[2]) Then ls_gbn[2] = 'N'

ls_gbn[3] = dw_ip.GetItemString(row, 'gbn3')
If Trim(ls_gbn[3]) = '' OR IsNull(ls_gbn[3]) Then ls_gbn[3] = 'N'

ls_gbn[4] = dw_ip.GetItemString(row, 'gbn4')
If Trim(ls_gbn[4]) = '' OR IsNull(ls_gbn[4]) Then ls_gbn[4] = 'N'

String ls_sts

ls_sts = ls_gbn[1] + ls_gbn[2] + ls_gbn[3] + ls_gbn[4]
If ls_sts = 'NNNN' Then ls_sts = '%'

String ls_grp

ls_grp = dw_ip.GetItemString(row, 'grpcod')
If Trim(ls_grp) = '' OR IsNull(ls_grp) Then ls_grp = '%'

String ls_sub

ls_sub = dw_ip.GetItemString(row, 'subcod')
If Trim(ls_sub) = '' OR IsNull(ls_sub) Then ls_sub = '%'

String ls_goc

ls_goc = dw_ip.GetItemString(row, 'gocod')
If Trim(ls_goc) = '' OR IsNull(ls_goc) Then ls_goc = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_kum, ls_sts, ls_grp, ls_sub, ls_goc)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1

end function

on wp04_jig.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp04_jig.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;//
Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

//dw_ip.GetChild('grpcod', idwc_1)
//idwc_1.SetTransObject(SQLCA)
//
//idwc_1.Retrieve()

dw_ip.GetChild('subcod', idwc_2)
idwc_2.SetTransObject(SQLCA)

idwc_2.Retrieve('%')

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_ip.SetItem(1, 'st_dat', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'ed_dat', String(TODAY(), 'yyyymmdd'))

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')

end event

type p_xls from w_standard_print`p_xls within wp04_jig
boolean visible = true
integer x = 4251
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within wp04_jig
integer x = 3465
integer y = 72
end type

type p_preview from w_standard_print`p_preview within wp04_jig
integer x = 4078
end type

type p_exit from w_standard_print`p_exit within wp04_jig
integer x = 4425
end type

type p_print from w_standard_print`p_print within wp04_jig
boolean visible = false
integer x = 3296
integer y = 76
end type

type p_retrieve from w_standard_print`p_retrieve within wp04_jig
integer x = 3904
end type

event p_retrieve::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within wp04_jig
end type



type dw_print from w_standard_print`dw_print within wp04_jig
integer x = 3712
string dataobject = "d_kumpe02_p2070_jig_02p"
end type

type dw_ip from w_standard_print`dw_ip within wp04_jig
integer x = 14
integer width = 3305
integer height = 252
string dataobject = "d_kumpe02_p2070_jig_01"
end type

event dw_ip::itemchanged;call super::itemchanged;This.AcceptText()

If row < 1 Then Return

Choose Case dwo.name
	Case 'kumno'
		Long   ll_cnt
		
		If Trim(data) = '' OR IsNull(data) Then Return
		
		SELECT COUNT('X')
		  INTO :ll_cnt
		  FROM KUMMST
		 WHERE KUMNO = :data ;
		If ll_cnt < 1 Then
			MessageBox('확인', '등록된 치공구코드가 아닙니다.')
			Return 1
		End If 
		
	Case 'grpcod'
		If Trim(data) = '' OR IsNull(data) Then 
			idwc_2.Retrieve('%')
		Else
			idwc_2.Retrieve(data)
		End If
		
		If idwc_2.RowCount() > 0 Then
			This.SetItem(row, 'subcod', idwc_2.GetItemString(1, 'grpcod'))
		End If
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)

String ls_name

Choose Case This.GetColumnName()
	Case 'kumno'
		gs_gubun = 'J'
		Open(w_imt_04630_popup)		
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(row, 'kumno', gs_code)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp04_jig
integer x = 32
integer y = 292
integer width = 4558
integer height = 1944
string dataobject = "d_kumpe02_p2070_jig_02"
boolean border = false
end type

type rr_1 from roundrectangle within wp04_jig
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 280
integer width = 4585
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

