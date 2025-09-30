$PBExportHeader$w_pm05_00020.srw
$PBExportComments$주간 생산계획 대비 실적현황
forward
global type w_pm05_00020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pm05_00020
end type
type rr_2 from roundrectangle within w_pm05_00020
end type
type rr_1 from roundrectangle within w_pm05_00020
end type
end forward

global type w_pm05_00020 from w_standard_print
string title = "주간 생산계획 현황"
pb_1 pb_1
rr_2 rr_2
rr_1 rr_1
end type
global w_pm05_00020 w_pm05_00020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sPdtgu, sJocod, ls_saupj, ls_pdtgu

If dw_ip.AcceptText() <> 1 Then Return -1

ls_saupj = dw_ip.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then
	ls_pdtgu = '%'
Else
	SELECT RFGUB INTO :ls_pdtgu FROM REFFPF WHERE SABU = '1' AND RFCOD = '03' AND RFNA2 = :ls_saupj;
	If Trim(ls_pdtgu) = '' OR IsNull(ls_pdtgu) Then ls_pdtgu = '%'
End If

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

If DayNumber(Date( Left(sYymm,4)+'-'+Mid(sYymm,5,2) +'-'+Right(sYymm,2) )) <> 2 Then
	MessageBox('확 인','주간 계획은 월요일부터 가능합니다.!!')
	Return -1
End If
//sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))
//If IsNull(sPdtgu) Or sPdtgu = '' Then
//	f_message_chk(1400,'')
//	Return -1
//End If

sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

String sitnbr , sgubun

sitnbr = dw_ip.GetItemString(1, 'itnbr')
sgubun = dw_ip.GetItemString(1, 'gubun')
If Trim(sitnbr) = '' OR IsNull(sitnbr) Then sitnbr = '%'

//IF dw_print.Retrieve(gs_sabu, syymm, sPdtgu, sJocod+'%') < 1 THEN
//IF dw_print.Retrieve(gs_sabu, syymm) < 1 THEN

IF sgubun ='2' THEN
	
		IF dw_print.Retrieve(gs_sabu, syymm, sJocod+'%', sitnbr, ls_pdtgu) < 1 THEN
			f_message_chk(50,'')
			dw_ip.Setfocus()
			return -1
		end if

ELSE 
	
		IF dw_print.Retrieve(gs_sabu, syymm, sitnbr, ls_pdtgu) < 1 THEN
			f_message_chk(50,'')
			dw_ip.Setfocus()
			return -1
		end if
		
END IF

Long   ll_rtn
ll_rtn = dw_print.sharedata(dw_list)

// Argument 표시
String sDd1,sDd2,sDd3,sDd4,sDd5,sDd6,sDd7

select to_char(to_date(:syymm,'yyyymmdd'),'DD'),
       to_char(to_date(:syymm,'yyyymmdd')+1,'DD'),
       to_char(to_date(:syymm,'yyyymmdd')+2,'DD'),
       to_char(to_date(:syymm,'yyyymmdd')+3,'DD'),
       to_char(to_date(:syymm,'yyyymmdd')+4,'DD'),
       to_char(to_date(:syymm,'yyyymmdd')+5,'DD'),
       to_char(to_date(:syymm,'yyyymmdd')+6,'DD')
  into :sDd1,:sDd2,:sDd3,:sDd4,:sDd5,:sDd6,:sDd7
  from dual;
  
dw_print.object.t_yymm.text = left(sYymm,4) + '.' + mid(sYymm,5,2) + '.' + mid(sYymm,7,2) 
dw_print.object.t_dd1.text  = sDd1 + ' 일'
dw_print.object.t_dd2.text  = sDd2 + ' 일'
dw_print.object.t_dd3.text  = sDd3 + ' 일'
dw_print.object.t_dd4.text  = sDd4 + ' 일'
dw_print.object.t_dd5.text  = sDd5 + ' 일'
dw_print.object.t_dd6.text  = sDd6 + ' 일'
dw_print.object.t_dd7.text  = sDd7 + ' 일'
dw_list.object.t_dd1.text  = sDd1 + ' 일'
dw_list.object.t_dd2.text  = sDd2 + ' 일'
dw_list.object.t_dd3.text  = sDd3 + ' 일'
dw_list.object.t_dd4.text  = sDd4 + ' 일'
dw_list.object.t_dd5.text  = sDd5 + ' 일'
dw_list.object.t_dd6.text  = sDd6 + ' 일'
dw_list.object.t_dd7.text  = sDd7 + ' 일'

//String tx_name
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_jocod.text = '"+tx_name+"'")
//
//
return 1
end function

on w_pm05_00020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pm05_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_2)
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

//dw_ip.SetTransObject(SQLCA)
//dw_ip.Reset()
//dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

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

//dw_print.ShareData(dw_list)
//
//PostEvent('ue_open')

String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

String  ls_pdtgu
SELECT RFGUB INTO :ls_pdtgu FROM REFFPF WHERE SABU = '1' AND RFCOD = '03' AND RFNA2 = '10';
/* 블럭코드 dddw 조회용 */
f_child_saupj(dw_ip, 'jocod', ls_pdtgu)

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'yymm', sDate)
dw_ip.SetItem(1, 'saupj', gs_saupj)
end event

type p_xls from w_standard_print`p_xls within w_pm05_00020
boolean visible = true
integer x = 4096
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_pm05_00020
end type

type p_preview from w_standard_print`p_preview within w_pm05_00020
integer x = 3922
end type

type p_exit from w_standard_print`p_exit within w_pm05_00020
end type

type p_print from w_standard_print`p_print within w_pm05_00020
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00020
integer x = 3749
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
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
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







type st_10 from w_standard_print`st_10 within w_pm05_00020
end type



type dw_print from w_standard_print`dw_print within w_pm05_00020
integer x = 3525
string dataobject = "d_pm05_00020_3_han_P"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00020
integer x = 105
integer y = 32
integer width = 3022
integer height = 180
string dataobject = "d_pm05_00020_4"
end type

event dw_ip::itemchanged;String sDate, sData, sNull,sName

SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 계획은 월요일부터 가능합니다.!!')
			Return 1
			Return
		End If
	Case 'saupj'
		sData = GetText()
		SELECT RFGUB INTO :sData FROM REFFPF WHERE SABU = '1' AND RFCOD = '03' AND RFNA2 = :sData;
		/* 블럭코드 dddw 조회용 */
		f_child_saupj(dw_ip, 'jocod', sData)
	Case 'jocod'
		sData = this.gettext()
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)
	Case 'gubun'
		sData = this.gettext()
		if sData = '1' then
//			dw_list.Visible = False  품목별
//			dw_list2.Visible = True
			dw_list.dataobject = 'd_pm05_00020_3'
			dw_print.dataobject = 'd_pm05_00020_3_p'
		else
//			dw_list.Visible = True //작업장별
//			dw_list.Visible = False
			dw_list.dataobject = 'd_pm05_00020_3_han2'
			dw_print.dataobject = 'd_pm05_00020_3_han_p'
		end if
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sData
long lrow

SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	Case 'jocod'
		Open(w_jomas_popup)
		SetItem(1,'jocod',gs_code)
		SetItem(1,'jonam',gs_codename)
	Case 'itnbr'
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_00020
integer x = 73
integer y = 260
integer width = 4453
integer height = 2004
string dataobject = "d_pm05_00020_3_han2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if
	
end event

type pb_1 from u_pb_cal within w_pm05_00020
integer x = 763
integer y = 132
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('yymm')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.yymm.protect = '1' Or dw_ip.Object.yymm.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'yymm', gs_code)
end event

type rr_2 from roundrectangle within w_pm05_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 28
integer width = 3104
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm05_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 252
integer width = 4471
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

