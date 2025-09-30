$PBExportHeader$w_sal_06230.srw
$PBExportComments$ASN 현황-invocie
forward
global type w_sal_06230 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06230
end type
type pb_2 from u_pb_cal within w_sal_06230
end type
type p_1 from picture within w_sal_06230
end type
type dw_print1 from datawindow within w_sal_06230
end type
type rb_1 from radiobutton within w_sal_06230
end type
type rb_2 from radiobutton within w_sal_06230
end type
type rr_1 from roundrectangle within w_sal_06230
end type
end forward

global type w_sal_06230 from w_standard_print
integer width = 4677
integer height = 2752
string title = "ASN 현황"
pb_1 pb_1
pb_2 pb_2
p_1 p_1
dw_print1 dw_print1
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_sal_06230 w_sal_06230

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sS, sS_Name ,ls_cvcod ,tx_name, ls_emp_id

If dw_ip.AcceptText() <> 1 Then Return -1

ls_cvcod  = Trim(dw_ip.getitemstring(1,'cvcod'))
If ls_cvcod  = '' Or IsNull(ls_cvcod)  Then ls_cvcod = '%'

//if rb_1.Checked = true then
//   messagebox('','상세 ')
//else 
//	messagebox('','집계표')
//end if

sFrom = Trim(dw_ip.GetItemString(1,'sdate'))
if	(sFrom = '') or isNull(sFrom) then
	f_Message_Chk(35, '[시작일자]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	Return -1
end if

sTo = Trim(dw_ip.GetItemString(1,'edate'))
if	(sTo = '') or isNull(sTo) then
	f_Message_Chk(35, '[종료일자]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	Return -1
end if

if	( sFrom > sTo ) then
	f_message_Chk(200, '[시작 및 종료일 CHECK]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	Return -1
END IF

dw_print.object.r_gigan.Text = Left(sFrom,4)+'.'+Mid(sFrom,5,2)+'.'+Right(sFrom,2) + ' - ' + &
                               Left(sTo,4)+'.'+Mid(sTo,5,2)+'.'+Right(sTo,2)

if dw_print.Retrieve(sFrom, sTo, ls_cvcod) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	dw_list.insertrow(0)
	//return -1
end if
dw_print.sharedata(dw_list)


return 1
end function

on w_sal_06230.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_1=create p_1
this.dw_print1=create dw_print1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.dw_print1
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rr_1
end on

on w_sal_06230.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_1)
destroy(this.dw_print1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
String sarea, steam, saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If
//dw_ip.SetItem(1, "saupj", saupj)
//dw_ip.SetItem(1, "sarea", sarea)


dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',left(f_today(),8))

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

event open;Integer  li_idx

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

dw_ip.SetTransObject(SQLCA)
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)
dw_print1.settransobject(sqlca)
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

type p_xls from w_standard_print`p_xls within w_sal_06230
end type

type p_sort from w_standard_print`p_sort within w_sal_06230
end type

type p_preview from w_standard_print`p_preview within w_sal_06230
end type

type p_exit from w_standard_print`p_exit within w_sal_06230
end type

type p_print from w_standard_print`p_print within w_sal_06230
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06230
integer x = 3749
integer y = 28
end type







type st_10 from w_standard_print`st_10 within w_sal_06230
end type



type dw_print from w_standard_print`dw_print within w_sal_06230
integer x = 3438
string dataobject = "d_sal_06210_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06230
integer x = 14
integer y = 56
integer width = 2930
integer height = 168
string dataobject = "d_sal_06230_1"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, svndcod, scvname, ls_saupj,chk
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
int nRow

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

IF chk = '1' then
messagebox('','1')
END IF 

Choose Case sCol_Name
   // 시작일자 유효성 Check
	Case "sdate"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "sdate", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "edate"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "edate", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
		if Long(this.GetItemString(1,'sdate')) > Long(this.GetText()) then
       	MessageBox("확 인","시작일과 종료일 CHECK!")
         this.SetItem(1, "d_to", sNull)
      	this.setcolumn('d_to')
       	this.setfocus()			
			return 1
		end if
	/* 거래처 */	
	Case 'cvcod'
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod',   sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			SetItem(1,"cvnas",	scvnas)
		END IF
		
	//	여기서부터 
		Case "chk"
		dw_list.reset()
		dw_print.reset()
		
	//	이까지 
end Choose



end event

event dw_ip::rbuttondown;call super::rbuttondown;string sPino
long   nRow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	Case "cvcod"
		nRow = dw_ip.RowCount()		
		gs_gubun = '2'
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
END Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06230
integer y = 264
integer width = 4576
integer height = 2064
string dataobject = "d_sal_06230"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06230
integer x = 594
integer y = 96
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06230
integer x = 1097
integer y = 96
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

end event

type p_1 from picture within w_sal_06230
integer x = 3922
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\CI출력_up.gif"
boolean focusrectangle = false
end type

event clicked;string sAsnno
Int nRow

nRow = dw_list.GetRow( )

if nRow > 0 then
	sAsnno = dw_list.GetItemString(nRow,'asnno')
	if dw_print1.Retrieve(sAsnno) < 1 then
		f_message_Chk(300, '[출력조건 CHECK]')
		dw_ip.setcolumn('sarea')
		dw_ip.setfocus()
		dw_list.insertrow(0)
		//return -1
	end if
	
	OpenWithParm(w_print_preview, dw_print1)	

	
else
	f_message_Chk(300, '출력할 행을 선택 하여야 합니다.')
	return -1
	
end if
end event

type dw_print1 from datawindow within w_sal_06230
boolean visible = false
integer x = 2674
integer y = 88
integer width = 347
integer height = 124
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_06230_p2"
boolean livescroll = true
end type

type rb_1 from radiobutton within w_sal_06230
integer x = 2976
integer y = 100
integer width = 265
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "상 세 "
boolean checked = true
end type

event clicked;char ic_status

If This.Checked = True Then
	dw_list.DataObject = 'd_sal_06230'
	dw_print.DataObject = 'd_sal_06210_p'
end if	
	dw_list.Settransobject(sqlca)
	dw_print.Settransobject(sqlca)	
//dw_list.SetTransObject(sqlca)	
end event

type rb_2 from radiobutton within w_sal_06230
integer x = 3333
integer y = 104
integer width = 334
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "집 계 표"
end type

event clicked;char ic_status

If This.Checked = True Then
	dw_list.DataObject = 'd_sal_06230_new'
	dw_print.DataObject = 'd_sal_06210_p_new'
end if	

	dw_list.Settransobject(sqlca)
	dw_print.Settransobject(sqlca)
	
//dw_list.SetTransObject(sqlca)
//dw_.SetTransObject(sqlca)
end event

type rr_1 from roundrectangle within w_sal_06230
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 248
integer width = 4608
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

